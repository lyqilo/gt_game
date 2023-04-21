

using DG.Tweening;
using DragonBones;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using Transform = UnityEngine.Transform;

namespace Hotfix.MJHL
{
    public class MJHL_Result : ILHotfixEntity
    {
        HierarchicalStateMachine hsm;
        List<IState> states;
        private Transform normalEffect;
        private TextMeshProUGUI normalEffectNum;
        private Transform winEffect;
        private TextMeshProUGUI winEffectNum;
        private Transform tipImage;
        private Transform tipText;

        private Transform winBG;
        private Transform winFreeBG;


        private int imageIndex;

        private bool isPlayImage;

        float timer;

        protected override void Start()
        {
            base.Start();
            hsm = new HierarchicalStateMachine(false, gameObject);
            states = new List<IState>();
            states.Add(new IdleState(this, hsm));
            states.Add(new NoWinState(this, hsm));
            states.Add(new NormalWinState(this, hsm));
            hsm.Init(states,nameof(IdleState));
            imageIndex = 0;
            timer = 0f;
        }

        protected override void AddEvent()
        {
            base.AddEvent();
            MJHL_Event.ShowResult += MJHL_Event_ShowResult;
            MJHL_Event.MJHL_ISShow_FreeTIP += ISShowFreeBg;
            MJHL_Event.MJHL_OnceWinGold += OnceWinGold;
        }

        protected override void Update()
        {
            base.Update();
            hsm?.Update();
            timer += Time.deltaTime;
            if (timer>=7.5f)
            {
                timer = 0f;
                tipImage.GetChild(0).GetChild(imageIndex).DOLocalMoveX(-1000, 2f).OnComplete(delegate() 
                {
                    tipImage.GetChild(0).GetChild(imageIndex).gameObject.SetActive(false);
                    imageIndex++;
                    if (imageIndex >= 4)
                    {
                        imageIndex = 0;
                    }
                    tipImage.GetChild(0).GetChild(imageIndex).localPosition = Vector3.zero;
                    tipImage.GetChild(0).GetChild(imageIndex).gameObject.SetActive(true);
                });
            }
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            MJHL_Event.ShowResult -= MJHL_Event_ShowResult;
            MJHL_Event.MJHL_ISShow_FreeTIP -= ISShowFreeBg;
            MJHL_Event.MJHL_OnceWinGold -= OnceWinGold;
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            hsm?.CurrentState.OnExit();
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            normalEffectNum = MJHLEntry.Instance.winNum; //本次获得金币
            winEffect = transform.FindChildDepth("Win");
            tipImage = winEffect.FindChildDepth("tipImage");
            tipText = winEffect.FindChildDepth("tipText");
            winEffectNum = tipText.FindChildDepth<TextMeshProUGUI>("Num"); //本次获得金币
            winBG = winEffect.FindChildDepth("BG");
            winFreeBG= winEffect.FindChildDepth("FreeBG");
        }

        private void ISShowFreeBg(bool isShow)
        {
            winBG.gameObject.SetActive(!isShow);
            winFreeBG.gameObject.SetActive(isShow);
        }

        private void MJHL_Event_ShowResult()
        {
            if (MJHLEntry.Instance.GameData.ResultData.nWinGold > 0)
            {
               hsm?.ChangeState(nameof(NormalWinState));
            }
            else
            {
                hsm?.ChangeState(nameof(NoWinState));
            }
        }

        private void OnceWinGold(int glod)
        {
            tipImage.gameObject.SetActive(false);
            tipText.gameObject.SetActive(true);
            ToolHelper.RunGoal(0, glod, MJHL_DataConfig.winBigGoldChangeRate / 2, delegate (string goal)
            {
                long.TryParse(goal, out var num);
                winEffectNum.text = ("yd").ShowRichText() + num.ShortNumber().ShowRichText();
            }).OnComplete(delegate() 
            {
                ToolHelper.DelayRun(0.5f).OnComplete(delegate() 
                {
                    tipImage.gameObject.SetActive(true);
                    tipText.gameObject.SetActive(false);
                });
            });
        }

        private class IdleState : State<MJHL_Result>
        {
            public IdleState(MJHL_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                owner.tipImage.gameObject.SetActive(true);
                owner.tipText.gameObject.SetActive(false);
                MJHLEntry.Instance.MJHL_Event_ShowResultNum(true);
                MJHL_Event.DispatchIAllWinGold(0);
            }
        }
        /// <summary>
        /// 未中奖
        /// </summary>
        private class NoWinState : State<MJHL_Result>
        {
            public NoWinState(MJHL_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            public override void OnEnter()
            {
                base.OnEnter();
                timer = 0;
            }
            public override void Update()
            {
                base.Update();
                timer += Time.deltaTime;
                if (timer >= MJHL_DataConfig.autoNoRewardInterval)
                {
                    MJHL_Event.DispatchShowResultComplete();
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }
        private class NormalWinState : State<MJHL_Result>
        {
            public NormalWinState(MJHL_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                timer = 0;
                isStart = false;
                owner.winEffectNum.text = "";
                owner.tipImage.gameObject.SetActive(false);
                owner.tipText.gameObject.SetActive(true);
                MJHL_Event.DispatchIAllWinGold(MJHLEntry.Instance.GameData.ResultData.nWinGold);
                MJHL_Audio.Instance.PlaySound(MJHL_Audio.MJ_totalwin);
                ToolHelper.RunGoal(0, MJHLEntry.Instance.GameData.ResultData.nWinGold, MJHL_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    long.TryParse(goal, out var num);
                    owner.winEffectNum.text = "a".ShowRichText() + num.ShortNumber().ShowRichText();
                }).OnComplete(delegate ()
                {
                    isStart = true;
                    // MJHL_Audio.Instance.PlaySound(MJHL_Audio.iconWinEnd);
                });
            }
            public override void Update()
            {
                base.Update();
                if (!isStart) return;
                timer += Time.deltaTime;
                if (timer >= 0.5f)
                {
                    isStart = false;
                    MJHL_Event.DispatchShowResultComplete();
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }



    }
}
