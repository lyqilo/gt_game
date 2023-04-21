

using DG.Tweening;
using DragonBones;
using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using Transform = UnityEngine.Transform;

namespace Hotfix.TJZ
{
    public class TJZ_Result : ILHotfixEntity
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
            TJZ_Event.ShowResult += TJZ_Event_ShowResult;
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
            TJZ_Event.ShowResult -= TJZ_Event_ShowResult;
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
        private void TJZ_Event_ShowResult()
        {
            DebugHelper.Log("nWinGold===" + TJZEntry.Instance.GameData.ResultData.nWinGold);
            if (TJZEntry.Instance.GameData.ResultData.nReturn)
            {
                if (TJZEntry.Instance.GameData.ResultData.nWinGold > 0)
                {
                    hsm?.ChangeState(nameof(NormalWinState));
                }
                else
                {
                    hsm?.ChangeState(nameof(NoWinState));
                }
                return;
            }
            if (TJZEntry.Instance.GameData.ReturnNum>0)
            {
                TJZEntry.Instance.GameData.ResultData.nWinGold = TJZEntry.Instance.GameData.ReturnNum;
                float winRate = (float)TJZEntry.Instance.GameData.ResultData.nWinGold / (TJZ_DataConfig.ALLLINECOUNT * TJZEntry.Instance.GameData.CurrentChip);

                if (winRate <= 10)
                {
                    hsm?.ChangeState(nameof(NoWinState));
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
                if (TJZEntry.Instance.GameData.ResultData.nWinGold > 0)
                {
                    float winRate = (float)TJZEntry.Instance.GameData.ResultData.nWinGold / (TJZ_DataConfig.ALLLINECOUNT * TJZEntry.Instance.GameData.CurrentChip);

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

        }

        private class IdleState : State<TJZ_Result>
        {
            public IdleState(TJZ_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                TJZEntry.Instance.FQGY_Event_ShowResultNum(true);
            }
        }
        /// <summary>
        /// 未中奖
        /// </summary>
        public class NoWinState : State<TJZ_Result>
        {
            public NoWinState(TJZ_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
        private class NormalWinState : State<TJZ_Result>
        {
            public NormalWinState(TJZ_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                timer = 0;
                isStart = false;
                owner.WinNum.text = 0.ShortNumber().ShowRichText();
                owner.WinText.gameObject.SetActive(true);
                owner.Content.gameObject.SetActive(true);
                TJZ_Audio.Instance.PlaySound(TJZ_Audio.XiaoCoins);
                ToolHelper.RunGoal(0, TJZEntry.Instance.GameData.ResultData.nWinGold, TJZ_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    long.TryParse(goal, out var num);
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
                    owner.WinText.gameObject.SetActive(false);
                    hsm?.ChangeState(nameof(UpLevelState));
                }
            }
        }
        private class BigWinState : State<TJZ_Result>
        {
            public BigWinState(TJZ_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                TJZ_Audio.Instance.PlaySound(TJZ_Audio.BigWin,2.5f);
                ToolHelper.RunGoal(0, TJZEntry.Instance.GameData.ResultData.nWinGold, TJZ_DataConfig.winBigGoldChangeRate, delegate (string goal)
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
                    owner.Win.gameObject.SetActive(false);
                    hsm?.ChangeState(nameof(UpLevelState));
                }
            }
        }

        private class SuperWinState : State<TJZ_Result>
        {
            public SuperWinState(TJZ_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                TJZ_Audio.Instance.PlaySound(TJZ_Audio.BigWin, 2.5f);
                ToolHelper.RunGoal(0, TJZEntry.Instance.GameData.ResultData.nWinGold, TJZ_DataConfig.winBigGoldChangeRate, delegate (string goal)
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
                    owner.Win.gameObject.SetActive(false);
                    hsm?.ChangeState(nameof(UpLevelState));
                }
            }
        }

        private class UltraWinState : State<TJZ_Result>
        {
            public UltraWinState(TJZ_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                owner.superEffect.gameObject.SetActive(true);
                owner.Win.gameObject.SetActive(true);
                owner.Content.gameObject.SetActive(true);
                TJZ_Audio.Instance.PlaySound(TJZ_Audio.BigWin, 2.5f);
                ToolHelper.RunGoal(0, TJZEntry.Instance.GameData.ResultData.nWinGold, TJZ_DataConfig.winBigGoldChangeRate, delegate (string goal)
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
                    owner.Win.gameObject.SetActive(false);
                    hsm?.ChangeState(nameof(UpLevelState));
                }
            }
        }

        private class UpLevelState : State<TJZ_Result>
        {
            public UpLevelState(TJZ_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                timer = 0;
                if (TJZEntry.Instance.GameData.isFreeGame)
                {
                    switch (TJZEntry.Instance.GameData.UpLevel)
                    {
                        case 3 when !TJZEntry.Instance.FreeDeng.GetChild(0).gameObject.activeSelf:
                            owner.UpLevel1.gameObject.SetActive(true);
                            break;
                        case 6 when !TJZEntry.Instance.FreeMZ.GetChild(0).gameObject.activeSelf:
                            owner.UpLevel2.gameObject.SetActive(true);
                            break;
                        case 10 when !TJZEntry.Instance.FreeChe.GetChild(0).gameObject.activeSelf:
                            owner.UpLevel3.gameObject.SetActive(true);
                            break;
                        default:
                            owner.UpLevel1.gameObject.SetActive(false);
                            owner.UpLevel2.gameObject.SetActive(false);
                            owner.UpLevel3.gameObject.SetActive(false);
                            break;
                    }
                    if (TJZEntry.Instance.GameData.UpLevel > 0)
                    {
                        TJZEntry.Instance.pillar.GetChild(TJZEntry.Instance.GameData.UpLevel - 1).FindChildDepth("Image").gameObject.SetActive(true);
                    }
                    owner.UpLevel.gameObject.SetActive(true);
                    owner.Content.gameObject.SetActive(true);
                    if (TJZEntry.Instance.GameData.UpLevel == 3 && !TJZEntry.Instance.FreeDeng.GetChild(0).gameObject.activeSelf)
                    {
                        TJZ_Audio.Instance.PlaySound(TJZ_Audio.ShengJi);
                        TJZEntry.Instance.FreeDeng.GetChild(0).gameObject.SetActive(true);
                    }
                    if (TJZEntry.Instance.GameData.UpLevel == 6 && !TJZEntry.Instance.FreeMZ.GetChild(0).gameObject.activeSelf)
                    {
                        TJZ_Audio.Instance.PlaySound(TJZ_Audio.ShengJi);
                        TJZEntry.Instance.FreeMZ.GetChild(0).gameObject.SetActive(true);
                    }
                    if (TJZEntry.Instance.GameData.UpLevel == 10 && !TJZEntry.Instance.FreeChe.GetChild(0).gameObject.activeSelf)
                    {
                        TJZ_Audio.Instance.PlaySound(TJZ_Audio.ShengJi);
                        TJZEntry.Instance.FreeChe.GetChild(0).gameObject.SetActive(true);
                    }
                    ToolHelper.DelayRun(0.5f, () =>
                    {
                        isStart = true;
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
                if (timer >= 1f)
                {
                    isStart = false;
                    TJZ_Event.DispatchShowResultComplete();
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }

    }
}
