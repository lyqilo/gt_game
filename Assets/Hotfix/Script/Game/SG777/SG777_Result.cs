

using DG.Tweening;
using DragonBones;
using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using Transform = UnityEngine.Transform;

namespace Hotfix.SG777
{
    public class SG777_Result : ILHotfixEntity
    {
        HierarchicalStateMachine hsm;
        List<IState> states;

        private Transform Content;
        private Transform Win;
        private Transform winEffect;
        private Transform bigEffect;
        private TextMeshProUGUI winEffectNum;

        private Transform QPEffect;
        private Transform QP1Effect;
        private Transform QP2Effect;
        private Transform QP3Effect;

        private Transform QPWinText;
        private TextMeshProUGUI QPWinNum;

        protected override void Awake()
        {
            base.Awake();
            FindComponent();
            SG777_Event.ShowResult += SG777_Event_ShowResult;
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
            states.Add(new QPWinState(this, hsm));
            states.Add(new UltraWinState(this, hsm));
            
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
            SG777_Event.ShowResult -= SG777_Event_ShowResult;
        }

        protected override void FindComponent()
        {
            Content = this.transform.FindChildDepth("Content");

            Win = Content.FindChildDepth("Win");
            winEffect = Win.FindChildDepth("bg/Image1");
            bigEffect = Win.FindChildDepth("bg/Image2");
            winEffectNum = Win.FindChildDepth<TextMeshProUGUI>("Text");

            QPEffect = Content.FindChildDepth("QP");
            QP1Effect = QPEffect.FindChildDepth("Image1");
            QP2Effect = QPEffect.FindChildDepth("Image2");
            QP3Effect = QPEffect.FindChildDepth("Image3");

            QPWinText = Content.FindChildDepth("winInfo");
            QPWinNum = QPWinText.FindChildDepth<TextMeshProUGUI>("Text");

        }
        private void SG777_Event_ShowResult()
        {
            DebugHelper.Log("nWinGold===" + SG777Entry.Instance.GameData.ResultData.nWinGold);
            if (SG777Entry.Instance.GameData.ResultData.nLineWinScore > 0)
            {
                float winRate = (float)SG777Entry.Instance.GameData.ResultData.nLineWinScore / (SG777_DataConfig.ALLLINECOUNT * SG777Entry.Instance.GameData.CurrentChip);

                if (winRate <= 4)
                {
                    hsm?.ChangeState(nameof(NormalWinState));
                }
                else if (winRate > 4 && winRate <= 10)
                {
                    hsm?.ChangeState(nameof(BigWinState));
                }
                else
                {
                    hsm?.ChangeState(nameof(UltraWinState));
                }
            }
            else if (SG777Entry.Instance.GameData.ResultData.nAllScreenWinScore>0)
            {
                hsm?.ChangeState(nameof(QPWinState));
            }
            else
            {
                hsm?.ChangeState(nameof(NoWinState));
            }
        }

        private class IdleState : State<SG777_Result>
        {
            public IdleState(SG777_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                owner.Content.gameObject.SetActive(false);
                owner.Win.gameObject.SetActive(false);
                owner.winEffect.gameObject.SetActive(false);
                owner.bigEffect.gameObject.SetActive(false);
                owner.winEffectNum.text="";
                owner.QPEffect.gameObject.SetActive(false);
                owner.QP1Effect.gameObject.SetActive(false);
                owner.QP2Effect.gameObject.SetActive(false);
                owner.QP3Effect.gameObject.SetActive(false);
                owner.QPWinText.gameObject.SetActive(false);
                owner.QPWinNum.text ="";
                SG777Entry.Instance.FQGY_Event_ShowResultNum(true);
            }
        }
        /// <summary>
        /// 未中奖
        /// </summary>
        public class NoWinState : State<SG777_Result>
        {
            public NoWinState(SG777_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                if (timer >= SG777_DataConfig.autoNoRewardInterval)
                {
                    SG777_Event.DispatchShowResultComplete();
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }
        private class NormalWinState : State<SG777_Result>
        {
            public NormalWinState(SG777_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                timer = 0;
                isStart = false;
                owner.QPWinNum.text = 0.ShortNumber().ShowRichText();
                owner.QPWinText.gameObject.SetActive(true);
                owner.Content.gameObject.SetActive(true);
                SG777_Audio.Instance.PlaySound(SG777_Audio.Gold_Add);
                ToolHelper.RunGoal(0, SG777Entry.Instance.GameData.ResultData.nLineWinScore, SG777_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    long.TryParse(goal, out var num);
                    owner.QPWinNum.text = num.ShortNumber().ShowRichText();

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
                if (timer >= 0.5f)
                {
                    isStart = false;
                    hsm?.ChangeState(nameof(QPWinState));
                }
            }
        }
        private class BigWinState : State<SG777_Result>
        {
            public BigWinState(SG777_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                timer = 0;
                owner.winEffectNum.text = 0.ShortNumber().ShowRichText();
                owner.winEffect.gameObject.SetActive(true);
                owner.Win.gameObject.SetActive(true);
                owner.Content.gameObject.SetActive(true);
                SG777_Audio.Instance.PlaySound(SG777_Audio.Gold_Add);
                ToolHelper.RunGoal(0, SG777Entry.Instance.GameData.ResultData.nLineWinScore, SG777_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    long.TryParse(goal, out var num);
                    owner.winEffectNum.text = num.ShortNumber().ShowRichText();

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
                    hsm?.ChangeState(nameof(QPWinState));
                }
            }
        }

        private class UltraWinState : State<SG777_Result>
        {
            public UltraWinState(SG777_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                timer = 0;

                owner.winEffectNum.text = 0.ShortNumber().ShowRichText();
                owner.bigEffect.gameObject.SetActive(true);
                owner.Win.gameObject.SetActive(true);
                owner.Content.gameObject.SetActive(true);
                SG777_Audio.Instance.PlaySound(SG777_Audio.Gold_Add);
                ToolHelper.RunGoal(0, SG777Entry.Instance.GameData.ResultData.nLineWinScore, SG777_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    long.TryParse(goal, out var num);
                    owner.winEffectNum.text = num.ShortNumber().ShowRichText();

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
                    hsm?.ChangeState(nameof(QPWinState));
                }
            }
        }

        /// <summary>
        /// 全盘显示
        /// </summary>
        private class QPWinState : State<SG777_Result>
        {
            public QPWinState(SG777_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                timer = 0;
                if (SG777Entry.Instance.GameData.ResultData.nFullScreenType != 0)
                {
                    if (SG777Entry.Instance.GameData.ResultData.nFullScreenType == 1)
                    {
                        owner.QP1Effect.gameObject.SetActive(true);
                    }
                    else if (SG777Entry.Instance.GameData.ResultData.nFullScreenType == 2)
                    {
                        owner.QP2Effect.gameObject.SetActive(true);
                    }
                    else if (SG777Entry.Instance.GameData.ResultData.nFullScreenType == 3)
                    {
                        owner.QP3Effect.gameObject.SetActive(true);
                    }
                    owner.QPEffect.gameObject.SetActive(true);
                    owner.Content.gameObject.SetActive(true);
                    SG777_Audio.Instance.PlaySound(SG777_Audio.Full);
                    ToolHelper.DelayRun(0.5f, () =>
                    {
                        owner.QPWinText.gameObject.SetActive(true);
                        long goldNum = SG777Entry.Instance.GameData.ResultData.nLineWinScore;
                        SG777_Audio.Instance.PlaySound(SG777_Audio.Gold_Add);
                        ToolHelper.RunGoal(goldNum, SG777Entry.Instance.GameData.ResultData.nWinGold, SG777_DataConfig.winBigGoldChangeRate, delegate (string goal)
                        {
                            long.TryParse(goal, out var num);
                            owner.QPWinNum.text = num.ShortNumber().ShowRichText();

                        }).OnComplete(delegate ()
                        {
                            isStart = true;
                        });
                    });
                }
                else
                {
                    isStart = true;
                }
            }

            public override void Update()
            {
                base.Update();
                if (!isStart) return;
                timer += Time.deltaTime;
                if (timer >= 0.5f)
                {
                    isStart = false;
                    SG777_Event.DispatchShowResultComplete();
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }


    }
}
