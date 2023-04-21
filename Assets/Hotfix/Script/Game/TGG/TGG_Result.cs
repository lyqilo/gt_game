

using DG.Tweening;
using DragonBones;
using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using Transform = UnityEngine.Transform;

namespace Hotfix.TGG
{
    public class TGG_Result : ILHotfixEntity
    {
        HierarchicalStateMachine hsm;
        List<IState> states;

        Transform WinEffect;
        TextMeshProUGUI WinNum;

        Transform NormalReward;
        TextMeshProUGUI NormalRewardWinNum;

        Transform bigWinEffect;
        TextMeshProUGUI bigWinNum;

        Transform superWinEffect;
        TextMeshProUGUI superWinNum;

        Transform megaWinEffect;
        TextMeshProUGUI megaWinNum;

        protected override void Awake()
        {
            base.Awake();
            FindComponent();
            TGG_Event.ShowResult += TJZ_Event_ShowResult;
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
            states.Add(new ISEnterFreeState(this, hsm));

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
            TGG_Event.ShowResult -= TJZ_Event_ShowResult;
        }

        protected override void FindComponent()
        {

            WinEffect = TGGEntry.Instance.WinInfo;
            WinNum = TGGEntry.Instance.WinInfoNum;
            NormalReward = this.transform.FindChildDepth("NormalReward");
            NormalRewardWinNum = NormalReward.FindChildDepth<TextMeshProUGUI>("win/Num");
            bigWinEffect = this.transform.FindChildDepth("BigWin");
            bigWinNum = bigWinEffect.FindChildDepth<TextMeshProUGUI>("win/Num");
            superWinEffect = this.transform.FindChildDepth("SuperWin");
            superWinNum = superWinEffect.FindChildDepth<TextMeshProUGUI>("win/Num");
            megaWinEffect = this.transform.FindChildDepth("MegaWin");
            megaWinNum = megaWinEffect.FindChildDepth<TextMeshProUGUI>("win/Num");
        }
        private void TJZ_Event_ShowResult()
        {
            DebugHelper.Log("-----------TJZ_Event_ShowResult----------");
            if (TGGEntry.Instance.GameData.ResultData.WinScore > 0)
            {
                float winRate = (float)TGGEntry.Instance.GameData.ResultData.WinScore / (TGG_DataConfig.ALLLINECOUNT * TGGEntry.Instance.GameData.CurrentChip);

                if (winRate < 5)
                {
                    hsm?.ChangeState(nameof(NormalWinState));
                }
                else if (winRate >= 5 && winRate < 10)
                {
                    hsm?.ChangeState(nameof(BigWinState));
                }
                else if (winRate >= 10 && winRate < 15)
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

        private class IdleState : State<TGG_Result>
        {
            public IdleState(TGG_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                owner.NormalReward.gameObject.SetActive(false);
                owner.NormalRewardWinNum.text = 0.ShortNumber().ShowRichText();
                //owner.WinEffect.gameObject.SetActive(false);
                // owner.WinNum.text = ToolHelper.ShowRichText("0");
                owner.bigWinEffect.gameObject.SetActive(false);
                owner.bigWinNum.text = 0.ShortNumber().ShowRichText();
                owner.superWinEffect.gameObject.SetActive(false);
                owner.superWinNum.text = 0.ShortNumber().ShowRichText();
                owner.megaWinEffect.gameObject.SetActive(false);
                owner.megaWinNum.text = 0.ShortNumber().ShowRichText();
                TGGEntry.Instance.FQGY_Event_ShowResultNum(true);
            }
        }
        /// <summary>
        /// 未中奖
        /// </summary>
        public class NoWinState : State<TGG_Result>
        {
            public NoWinState(TGG_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                        hsm?.ChangeState(nameof(ISEnterFreeState));
                    }
                }
            }
        }
        private class NormalWinState : State<TGG_Result>
        {
            public NormalWinState(TGG_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                timer = 0;
                isStart = false;
                owner.NormalRewardWinNum.text = 0.ShortNumber().ShowRichText();
                owner.NormalRewardWinNum.gameObject.SetActive(true);
                owner.NormalReward.gameObject.SetActive(true);
                owner.WinEffect.gameObject.SetActive(true);
                ToolHelper.RunGoal(0, TGGEntry.Instance.GameData.ResultData.WinScore, TGG_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    long.TryParse(goal, out var num);
                    owner.NormalRewardWinNum.text = num.ShortNumber().ShowRichText();
                    owner.WinNum.text = num.ShortNumber().ShowRichText();

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
                    owner.NormalRewardWinNum.gameObject.SetActive(false);
                    hsm?.ChangeState(nameof(ISEnterFreeState));
                }
            }
        }
        private class BigWinState : State<TGG_Result>
        {
            public BigWinState(TGG_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                timer = 0;
                owner.bigWinNum.text = 0.ShortNumber().ShowRichText();
                owner.bigWinEffect.gameObject.SetActive(true);
                owner.WinEffect.gameObject.SetActive(true);
                TGG_Audio.Instance.PlaySound(TGG_Audio.BW, 2.5f);
                ToolHelper.RunGoal(0, TGGEntry.Instance.GameData.ResultData.WinScore, TGG_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    long.TryParse(goal, out var num);
                    owner.bigWinNum.text = num.ShortNumber().ShowRichText();
                    owner.WinNum.text = num.ShortNumber().ShowRichText();

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
                    owner.bigWinEffect.gameObject.SetActive(false);
                    hsm?.ChangeState(nameof(ISEnterFreeState));
                }
            }
        }

        private class SuperWinState : State<TGG_Result>
        {
            public SuperWinState(TGG_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                timer = 0;

                owner.superWinNum.text = 0.ShortNumber().ShowRichText();
                owner.superWinEffect.gameObject.SetActive(true);
                TGG_Audio.Instance.PlaySound(TGG_Audio.SW, 2.5f);
                owner.WinEffect.gameObject.SetActive(true);
                ToolHelper.RunGoal(0, TGGEntry.Instance.GameData.ResultData.WinScore, TGG_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    long.TryParse(goal, out var num);
                    owner.superWinNum.text = num.ShortNumber().ShowRichText();
                    owner.WinNum.text = num.ShortNumber().ShowRichText();
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
                    owner.superWinEffect.gameObject.SetActive(false);
                    hsm?.ChangeState(nameof(ISEnterFreeState));
                }
            }
        }

        private class UltraWinState : State<TGG_Result>
        {
            public UltraWinState(TGG_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                timer = 0;

                owner.megaWinNum.text = 0.ShortNumber().ShowRichText();
                owner.megaWinEffect.gameObject.SetActive(true);
                TGG_Audio.Instance.PlaySound(TGG_Audio.MW, 2.5f);
                owner.WinEffect.gameObject.SetActive(true);
                ToolHelper.RunGoal(0, TGGEntry.Instance.GameData.ResultData.WinScore, TGG_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    long.TryParse(goal, out var num);
                    owner.megaWinNum.text = num.ShortNumber().ShowRichText();
                    owner.WinNum.text = num.ShortNumber().ShowRichText();

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
                    owner.megaWinEffect.gameObject.SetActive(false);
                    hsm?.ChangeState(nameof(ISEnterFreeState));
                }
            }
        }

        private class ISEnterFreeState : State<TGG_Result>
        {
            public ISEnterFreeState(TGG_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                timer = 0;
                isStart = true;

            }

            public override void Update()
            {
                base.Update();
                if (!isStart) return;
                timer += Time.deltaTime;
                if (timer >= 0.1f)
                {
                    isStart = false;
                    TGG_Event.DispatchShowResultComplete();
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }

    }
}
