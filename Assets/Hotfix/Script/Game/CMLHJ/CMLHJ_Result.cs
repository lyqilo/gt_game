

using DG.Tweening;
using DragonBones;
using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using Transform = UnityEngine.Transform;

namespace Hotfix.CMLHJ
{
    public class CMLHJ_Result : ILHotfixEntity
    {
        HierarchicalStateMachine hsm;
        List<IState> states;

        private Transform Content;

        private Transform WinText;
        private TextMeshProUGUI WinNum;

        private Transform Win;
        private Transform winEffect;
        private Transform bigEffect;
        private Transform superEffect;
        private TextMeshProUGUI winEffectNum;


        private Transform UpLevel;
        private Transform UpLevel1;
        private Transform UpLevel2;
        private Transform UpLevel3;

        protected override void Awake()
        {
            base.Awake();
            FindComponent();
            //CMLHJ_Event.ShowResult += CMLHJ_Event_ShowResult;
        }
        protected override void Start()
        {
            base.Start();
            hsm = new HierarchicalStateMachine(false, gameObject);
            states = new List<IState>();
            states.Add(new IdleState(this, hsm));
            states.Add(new NoWinState(this, hsm));
            states.Add(new NormalWinState(this, hsm));
            states.Add(new BigWinState(this, hsm));
            states.Add(new SuperWinState(this, hsm));
            states.Add(new UltraWinState(this, hsm));
            states.Add(new UpLevelState(this, hsm));

            hsm.Init(states,nameof(IdleState));
        }
        protected override void Update()
        {
            base.Update();
            hsm?.Update();
        }
        protected override void OnDestroy()
        {
            base.OnDestroy();
            //CMLHJ_Event.ShowResult -= CMLHJ_Event_ShowResult;
        }

        protected override void FindComponent()
        {
            Content = this.transform.FindChildDepth("Content");

            Win = Content.FindChildDepth("Win");
            winEffect = Win.FindChildDepth("bg/Image1");
            bigEffect = Win.FindChildDepth("bg/Image2");
            superEffect = Win.FindChildDepth("bg/Image3");
            winEffectNum = Win.FindChildDepth<TextMeshProUGUI>("Text");

            UpLevel = Content.FindChildDepth("SJinfo");
            UpLevel1 = UpLevel.FindChildDepth("info/sg1");
            UpLevel2 = UpLevel.FindChildDepth("info/sg2");
            UpLevel3 = UpLevel.FindChildDepth("info/sg3");

            WinText = Content.FindChildDepth("winInfo");
            WinNum = WinText.FindChildDepth<TextMeshProUGUI>("Text");

        }
        private void CMLHJ_Event_ShowResult()
        {
            if (CMLHJEntry.Instance.GameData.ResultData.nWinGold > 0)
            {
                float winRate = (float)CMLHJEntry.Instance.GameData.ResultData.nWinGold / (CMLHJ_DataConfig.ALLLINECOUNT * CMLHJEntry.Instance.GameData.CurrentChip);

                if (winRate <= 10)
                {
                    hsm?.ChangeState(nameof(NormalWinState));
                }
                else if (winRate > 10 && winRate <= 20)
                {
                    hsm?.ChangeState(nameof(BigWinState));
                }
                else if (winRate > 20 && winRate <= 40)
                {
                    hsm?.ChangeState(nameof(SuperWinState));
                }
                else
                {
                    hsm?.ChangeState(nameof(UltraWinState));
                }
            }
            else
            {
                hsm?.ChangeState(nameof(NoWinState));
            }
        }

        private class IdleState : State<CMLHJ_Result>
        {
            public IdleState(CMLHJ_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                owner.Content.gameObject.SetActive(false);
                owner.Win.gameObject.SetActive(false);
                owner.WinText.gameObject.SetActive(false);
                owner.winEffect.gameObject.SetActive(false);
                owner.bigEffect.gameObject.SetActive(false);
                owner.superEffect.gameObject.SetActive(false);
                owner.UpLevel.gameObject.SetActive(false);
                owner.winEffectNum.text="";
                //CMLHJEntry.Instance.CMLHJ_Event_ShowResultNum(true);
            }
        }
        /// <summary>
        /// 未中奖
        /// </summary>
        public class NoWinState : State<CMLHJ_Result>
        {
            public NoWinState(CMLHJ_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;

            public override void OnEnter()
            {
                base.OnEnter();
                timer = 0;
                isStart=true;
            }
            public override void Update()
            {
                base.Update();
                if (isStart)
                {
                    timer += Time.deltaTime;
                    if (timer >= 0.1f)
                    {
                        isStart = false;
                        timer = 0;
                        hsm?.ChangeState(nameof(UpLevelState));
                    }
                }

            }
        }
        private class NormalWinState : State<CMLHJ_Result>
        {
            public NormalWinState(CMLHJ_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                timer = 0;
                isStart = false;
                owner.WinNum.text = "0";
                owner.WinText.gameObject.SetActive(true);
                owner.Content.gameObject.SetActive(true);
                ToolHelper.RunGoal(0, CMLHJEntry.Instance.GameData.ResultData.nWinGold, CMLHJ_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    owner.WinNum.text = ToolHelper.ShowRichText(goal);

                }).OnComplete(delegate ()
                {
                    isStart = true;
                });
            }
            public override void Update()
            {
                base.Update();
                if (!isStart) return;
                timer += Time.deltaTime;
                if (timer >= 0.2f)
                {
                    isStart = false;
                    owner.WinText.gameObject.SetActive(false);
                    hsm?.ChangeState(nameof(UpLevelState));
                }
            }
        }
        private class BigWinState : State<CMLHJ_Result>
        {
            public BigWinState(CMLHJ_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                timer = 0;
                owner.winEffectNum.text = "";
                owner.winEffect.gameObject.SetActive(true);
                owner.Win.gameObject.SetActive(true);
                owner.Content.gameObject.SetActive(true);
                CMLHJ_Audio.Instance.PlaySound(CMLHJ_Audio.BigWin,2.5f);
                ToolHelper.RunGoal(0, CMLHJEntry.Instance.GameData.ResultData.nWinGold, CMLHJ_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    owner.winEffectNum.text = ToolHelper.ShowRichText(goal);

                }).OnComplete(delegate ()
                {
                    isStart = true;
                });
            }
            public override void Update()
            {
                base.Update();
                if (!isStart) return;
                timer += Time.deltaTime;
                if (timer >= 1f)
                {
                    isStart = false;
                    owner.Win.gameObject.SetActive(false);
                    hsm?.ChangeState(nameof(UpLevelState));
                }
            }
        }

        private class SuperWinState : State<CMLHJ_Result>
        {
            public SuperWinState(CMLHJ_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                timer = 0;

                owner.winEffectNum.text = "";
                owner.bigEffect.gameObject.SetActive(true);
                owner.Win.gameObject.SetActive(true);
                owner.Content.gameObject.SetActive(true);
                CMLHJ_Audio.Instance.PlaySound(CMLHJ_Audio.BigWin, 2.5f);
                ToolHelper.RunGoal(0, CMLHJEntry.Instance.GameData.ResultData.nWinGold, CMLHJ_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    owner.winEffectNum.text = ToolHelper.ShowRichText(goal);

                }).OnComplete(delegate ()
                {
                    isStart = true;
                });
            }

            public override void Update()
            {
                base.Update();
                if (!isStart) return;
                timer += Time.deltaTime;
                if (timer >= 1f)
                {
                    isStart = false;
                    owner.Win.gameObject.SetActive(false);
                    hsm?.ChangeState(nameof(UpLevelState));
                }
            }
        }

        private class UltraWinState : State<CMLHJ_Result>
        {
            public UltraWinState(CMLHJ_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                timer = 0;

                owner.winEffectNum.text = "";
                owner.superEffect.gameObject.SetActive(true);
                owner.Win.gameObject.SetActive(true);
                owner.Content.gameObject.SetActive(true);
                CMLHJ_Audio.Instance.PlaySound(CMLHJ_Audio.BigWin, 2.5f);
                ToolHelper.RunGoal(0, CMLHJEntry.Instance.GameData.ResultData.nWinGold, CMLHJ_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    owner.winEffectNum.text = ToolHelper.ShowRichText(goal);
                }).OnComplete(delegate ()
                {
                    isStart = true;
                });
            }

            public override void Update()
            {
                base.Update();
                if (!isStart) return;
                timer += Time.deltaTime;
                if (timer >= 1f)
                {
                    isStart = false;
                    owner.Win.gameObject.SetActive(false);
                    hsm?.ChangeState(nameof(UpLevelState));
                }
            }
        }

        private class UpLevelState : State<CMLHJ_Result>
        {
            public UpLevelState(CMLHJ_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                isStart = true;
                timer = 0;
            }

            public override void Update()
            {
                base.Update();
                if (!isStart) return;
                timer += Time.deltaTime;
                if (timer >= 1f)
                {
                    isStart = false;
                    CMLHJ_Event.DispatchShowResultComplete();
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }

    }
}
