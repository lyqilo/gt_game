using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Transform = UnityEngine.Transform;

namespace Hotfix.YGBH
{
    public class YGBH_Result : ILHotfixEntity
    {
        HierarchicalStateMachine hsm;
        List<IState> states;
        private Transform resultEffect;
        private Transform winNormalEffect;
        private TextMeshProUGUI winNormalNum;
        private Transform greatEffect;
        private Slider greatProgress;
        private Button closeGreatBtn;
        private TextMeshProUGUI winGreatNum;
        private Transform goodEffect;
        private Slider goodProgress;
        private Button closegoodBtn;
        private TextMeshProUGUI winGoodNum;
        private Transform perfectEffect;
        private Slider prefectProgress;
        private Button closeperfectBtn;
        private TextMeshProUGUI winPerfectNum;
        private Transform bigEffect;
        private Slider bigProgress;
        private GameObject bigDJJY;
        private GameObject bigFJYF;
        private GameObject bigTXWS;
        private Button closebigBtn;
        private TextMeshProUGUI winBigNum;
        private Transform smallEffect;
        private TextMeshProUGUI winSmallEffectNum;
        private long spGameGold;
        private int freeGold;
        private bool isShowCSJLResult;

        protected override void Awake()
        {
            base.Awake();
            FindComponent();
            YGBH_Event.ShowResult += YGBH_Event_ShowResult;
            YGBH_Event.ShowF_sResult += YGBH_ShowFreeSmall;
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
            states.Add(new ShowCSJLResultEffect(this, hsm));
            hsm.Init(states, nameof(IdleState));
        }
        protected override void Update()
        {
            base.Update();
            hsm?.Update();
        }
        protected override void OnDestroy()
        {
            base.OnDestroy();
            YGBH_Event.ShowResult -= YGBH_Event_ShowResult;
            YGBH_Event.ShowF_sResult -= YGBH_ShowFreeSmall;

        }

        protected override void FindComponent()
        {
            resultEffect = this.transform; //中奖后特效
            winNormalEffect = resultEffect.FindChildDepth("Reward");
            winNormalNum = winNormalEffect.FindChildDepth("RewardNum").GetComponent<TextMeshProUGUI>();
            greatEffect = resultEffect.FindChildDepth("Great");
            greatProgress = greatEffect.FindChildDepth("Slider").GetComponent<Slider>();
            closeGreatBtn = greatEffect.FindChildDepth("Close").GetComponent<Button>();
            winGreatNum = greatEffect.FindChildDepth("Num").GetComponent<TextMeshProUGUI>();
            goodEffect = resultEffect.FindChildDepth("Good");
            goodProgress = goodEffect.FindChildDepth("Slider").GetComponent<Slider>();
            closegoodBtn = goodEffect.FindChildDepth("Close").GetComponent<Button>();
            winGoodNum = goodEffect.FindChildDepth("Num").GetComponent<TextMeshProUGUI>();
            perfectEffect = resultEffect.FindChildDepth("Perfect");
            prefectProgress = perfectEffect.FindChildDepth("Slider").GetComponent<Slider>();
            closeperfectBtn = perfectEffect.FindChildDepth("Close").GetComponent<Button>();
            winPerfectNum = perfectEffect.FindChildDepth("Num").GetComponent<TextMeshProUGUI>();
            bigEffect = resultEffect.FindChildDepth("Big");
            bigProgress = bigEffect.FindChildDepth("Content/Slider").GetComponent<Slider>();
            bigDJJY = bigEffect.FindChildDepth("Content/DJJY").gameObject;
            bigFJYF = bigEffect.FindChildDepth("Content/FJYF").gameObject;
            bigTXWS = bigEffect.FindChildDepth("Content/TXWS").gameObject;
            closebigBtn = bigEffect.FindChildDepth("Close").GetComponent<Button>();
            winBigNum = bigEffect.FindChildDepth("Content/Num").GetComponent<TextMeshProUGUI>();
            smallEffect = resultEffect.FindChildDepth("SmallReward");
            winSmallEffectNum = smallEffect.FindChildDepth("Num").GetComponent<TextMeshProUGUI>();
        }

        private void YGBH_ShowFreeSmall()
        {
            hsm?.ChangeState(nameof(ShowCSJLResultEffect));
        }

        private void YGBH_Event_ShowResult()
        {
            DebugHelper.Log("-----------YGBH_Event_ShowResult----------");

            Behaviour.StopCoroutine(PlayFreeGame());
            Behaviour.StartCoroutine(PlayFreeGame());
        }

        IEnumerator PlayFreeGame()
        {
            if (YGBHEntry.Instance.GameData.isFreeGame)
            {
                YGBHEntry.Instance.GameData.TotalFreeWin += YGBHEntry.Instance.GameData.ResultData.WinScore;
                DebugHelper.Log($"免费累计获得:{YGBHEntry.Instance.GameData.TotalFreeWin}");
                if (YGBHEntry.Instance.GameData.ResultData.m_FreeType == 13)//紫霞
                {
                    for (int i = YGBHEntry.Instance.GameData.ResultData.m_nIconLie.Count-1; i >= 0; i--)
                    {
                        GameObject item = YGBHEntry.Instance.CSGroup.GetChild(i).FindChildDepth("Item").gameObject;
                        if (YGBHEntry.Instance.GameData.ResultData.m_nIconLie[i] > 0 && !item.activeSelf)
                        {
                            item.SetActive(true);
                            yield return new WaitForSeconds(0.1f);
                        }
                    }
                }
                else if (YGBHEntry.Instance.GameData.ResultData.m_FreeType == 14)//白晶晶
                {
                    for (int i = 0; i < YGBHEntry.Instance.bjjKuGroup.childCount; i++)
                    {
                        YGBHEntry.Instance.bjjKuGroup.GetChild(i).gameObject.SetActive(true);
                    }
                    YGBHEntry.Instance.bjjKuGroup.gameObject.SetActive(true);
                    YGBH_Audio.Instance.PlaySound(YGBH_Audio.KULOU);
                    while (YGBHEntry.Instance.bjjKuGroup.GetChild(0).gameObject.activeSelf)
                    {
                        yield return new WaitForSeconds(0.1f);
                    }
                    YGBHEntry.Instance.bjjKuGroup.gameObject.SetActive(false);
                    YGBHEntry.Instance.bjjLightGroup.gameObject.SetActive(true);
                    bool ischanged = false;
                    YGBH_Audio.Instance.PlaySound(YGBH_Audio.BJJEFECT);
                    for (int i = 0; i < YGBHEntry.Instance.bjjList.Count; i++)
                    {
                        DebugHelper.Log("i0000000====" + i);
                        Transform child = YGBHEntry.Instance.bjjLightGroup.GetChild(i);
                        Vector3 pos = new Vector3(YGBHEntry.Instance.bjjList[i][0], YGBHEntry.Instance.bjjList[i][1], YGBHEntry.Instance.bjjList[i][2]);
                        child.DOLocalMove(pos, 0.3f).OnComplete(() =>
                        {
                            child.DOScale(new Vector3(5, 5, 5), 0.2f).OnComplete(() =>
                            {
                                DebugHelper.Log("i====" + i);
                                DebugHelper.Log("YGBHEntry.Instance.bjjList.Count====" + (YGBHEntry.Instance.bjjList.Count));
                                if (i == (YGBHEntry.Instance.bjjList.Count))
                                {
                                    ischanged = true;
                                }
                            });
                        });
                    }
                    while (!ischanged)
                    {
                        yield return new WaitForSeconds(0.1f);
                    }
                    YGBH_Audio.Instance.PlaySound(YGBH_Audio.FREESELECT);
                    YGBHEntry.Instance.bjjLightGroup.gameObject.SetActive(false);

                    for (int i = 0; i < YGBHEntry.Instance.bjjLightGroup.childCount; i++)
                    {
                        YGBHEntry.Instance.bjjLightGroup.GetChild(i).localPosition = new Vector3(500, -500, 0);
                    }
                    ischanged = false;
                    for (int i = 0; i < YGBHEntry.Instance.bjjImgList.Count; i++)
                    {
                        Image childImg = YGBHEntry.Instance.bjjImgList[i];

                        childImg.transform.DOScale(Vector3.zero, 0.2f).OnComplete(() =>
                        {
                            childImg.sprite = YGBHEntry.Instance.Icons.FindChildDepth<Image>(YGBH_DataConfig.IconTable[13]).sprite;
                            childImg.transform.DOScale(Vector3.one, 0.2f).OnComplete(() =>
                            {
                                if (i == YGBHEntry.Instance.bjjLightGroup.childCount)
                                {
                                    ischanged = true;
                                }
                            });
                        });
                    }
                    while (!ischanged)
                    {
                        yield return new WaitForSeconds(0.1f);
                    }
                }
            }

            if (YGBHEntry.Instance.GameData.ResultData.WinScore > 0)
            {
                YGBH_Event.DispatchShowLine();
                float winRate = (float)YGBHEntry.Instance.GameData.ResultData.WinScore / (YGBH_DataConfig.ALLLINECOUNT * YGBHEntry.Instance.GameData.CurrentChip);

                if (YGBHEntry.Instance.GameData.ResultData.m_nWinPeiLv < 1 * YGBH_DataConfig.ALLLINECOUNT)
                {
                    hsm?.ChangeState(nameof(NormalWinState));
                }
                else if (YGBHEntry.Instance.GameData.ResultData.m_nWinPeiLv == 1 * YGBH_DataConfig.ALLLINECOUNT)
                {
                    hsm?.ChangeState(nameof(BigWinState));
                }
                else if (YGBHEntry.Instance.GameData.ResultData.m_nWinPeiLv > 1 * YGBH_DataConfig.ALLLINECOUNT && YGBHEntry.Instance.GameData.ResultData.m_nWinPeiLv < 2 * YGBH_DataConfig.ALLLINECOUNT)
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
                int rd = Random.Range(0, YGBH_DataConfig.WinConfig.Count-1);
                YGBHEntry.Instance.WinDesc.text = YGBH_DataConfig.WinConfig[rd];
                hsm?.ChangeState(nameof(NoWinState));
            }

        }

        private class IdleState : State<YGBH_Result>
        {
            public IdleState(YGBH_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }
        /// <summary>
        /// 未中奖
        /// </summary>
        public class NoWinState : State<YGBH_Result>
        {
            public NoWinState(YGBH_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;

            public override void OnEnter()
            {
                base.OnEnter();
                timer = 0;
                isStart = true;
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
        private class NormalWinState : State<YGBH_Result>
        {
            public NormalWinState(YGBH_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                owner.winNormalEffect.transform.localScale = Vector3.zero;
                owner.winNormalEffect.gameObject.SetActive(true);
                owner.winNormalEffect.DOScale(Vector3.one, 0.3f).OnComplete(()=> 
                {
                    timer = 0;
                    isStart = false;
                    owner.winNormalNum.text = 0.ShortNumber().ShowRichText();
                    ToolHelper.RunGoal(0, YGBHEntry.Instance.GameData.ResultData.WinScore, YGBH_DataConfig.winBigGoldChangeRate, delegate (string goal)
                    {
                        long.TryParse(goal, out var num);
                        owner.winNormalNum.text = num.ShortNumber().ShowRichText();
                    }).OnComplete(delegate ()
                    {
                        isStart = true;
                    });
                    YGBH_Audio.Instance.PlaySound(YGBH_Audio.FIREGOLD, YGBH_DataConfig.winGoldChangeRate);
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
                    owner.winNormalEffect.gameObject.SetActive(false);
                    hsm?.ChangeState(nameof(ISEnterFreeState));
                }
            }
        }
        private class BigWinState : State<YGBH_Result>
        {
            public BigWinState(YGBH_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                timer = 0;
                owner.goodEffect.transform.localScale = Vector3.zero;
                owner.winGoodNum.text = 0.ShortNumber().ShowRichText();
                owner.goodProgress.value = 0;
                owner.goodEffect.gameObject.SetActive(true);
                owner.goodEffect.DOScale(Vector3.one, 0.3f).OnComplete(()=> 
                {
                    ToolHelper.RunGoal(0, YGBHEntry.Instance.GameData.ResultData.WinScore, YGBH_DataConfig.winBigGoldChangeRate, delegate (string goal)
                    {
                        long.TryParse(goal, out var num);
                        owner.goodProgress.value = (float)num / YGBHEntry.Instance.GameData.ResultData.WinScore;
                        owner.winGoodNum.text = num.ShortNumber().ShowRichText();
                    }).OnComplete(delegate ()
                    {
                        isStart = true;
                    });
                    YGBH_Audio.Instance.PlaySound(YGBH_Audio.HIGHWIN2, YGBH_DataConfig.winGoldChangeRate);

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
                    owner.goodEffect.gameObject.SetActive(false);
                    hsm?.ChangeState(nameof(ISEnterFreeState));
                }
            }
        }

        private class SuperWinState : State<YGBH_Result>
        {
            public SuperWinState(YGBH_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                timer = 0;

                owner.perfectEffect.transform.localScale = Vector3.zero;
                owner.winPerfectNum.text = 0.ShortNumber().ShowRichText();
                owner.prefectProgress.value = 0;
                owner.perfectEffect.gameObject.SetActive(true);

                owner.perfectEffect.DOScale(Vector3.one, 0.3f).OnComplete(()=> 
                {
                    ToolHelper.RunGoal(0, YGBHEntry.Instance.GameData.ResultData.WinScore, YGBH_DataConfig.winBigGoldChangeRate, delegate (string goal)
                    {
                        long.TryParse(goal, out var num);
                        owner.prefectProgress.value = (float)num / YGBHEntry.Instance.GameData.ResultData.WinScore;
                        owner.winPerfectNum.text = num.ShortNumber().ShowRichText();
                    }).OnComplete(delegate ()
                    {
                        isStart = true;
                    });

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
                    owner.perfectEffect.gameObject.SetActive(false);
                    hsm?.ChangeState(nameof(ISEnterFreeState));
                }
            }
        }

        private class UltraWinState : State<YGBH_Result>
        {
            public UltraWinState(YGBH_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                timer = 0;

                owner.bigEffect.transform.localScale = Vector3.zero;
                owner.winBigNum.text = 0.ShortNumber().ShowRichText();
                owner.bigDJJY.SetActive(true);
                owner.bigFJYF.SetActive(false);
                owner.bigTXWS.SetActive(false);
                owner.bigProgress.value = 0;
                int index = 0;
                owner.bigEffect.gameObject.SetActive(true);
                owner.bigEffect.DOScale(Vector3.one, 0.3f).SetEase(DG.Tweening.Ease.Linear).OnComplete(()=> 
                {
                    ToolHelper.RunGoal(0, YGBHEntry.Instance.GameData.ResultData.WinScore, YGBH_DataConfig.winBigGoldChangeRate, delegate (string goal)
                    {
                        long.TryParse(goal, out var num);
                        if (num >= YGBHEntry.Instance.GameData.ResultData.WinScore)
                        {
                            num = YGBHEntry.Instance.GameData.ResultData.WinScore;
                        }
                        float remain = (float)(num - index * (YGBHEntry.Instance.GameData.ResultData.WinScore / 3)) / (YGBHEntry.Instance.GameData.ResultData.WinScore / 3);
                        owner.bigProgress.value = remain;
                        if (remain >= 1)
                        {
                            if (index < 2)
                            {
                                owner.bigEffect.FindChildDepth("Content").GetChild(index).gameObject.SetActive(false);
                                index += 1;
                                owner.bigEffect.FindChildDepth("Content").GetChild(index).gameObject.SetActive(true);
                                owner.bigProgress.value = 0;
                                YGBH_Audio.Instance.ClearAuido(YGBH_Audio.HIGHWIN2);
                                YGBH_Audio.Instance.PlaySound(YGBH_Audio.HIGHWIN2);
                            }

                        }
                        owner.winBigNum.text = num.ShortNumber().ShowRichText();
                    }).OnComplete(delegate ()
                    {
                        isStart = true;
                    });

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
                    owner.bigEffect.gameObject.SetActive(false);
                    hsm?.ChangeState(nameof(ISEnterFreeState));
                }
            }
        }


        private class ISEnterFreeState : State<YGBH_Result>
        {
            public ISEnterFreeState(YGBH_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;

            public override void OnEnter()
            {
                base.OnEnter();
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
                    YGBH_Event.DispatchShowResultComplete();
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }


        private class ShowCSJLResultEffect : State<YGBH_Result>
        {
            public ShowCSJLResultEffect(YGBH_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;

            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                if (YGBHEntry.Instance.GameData.isSmallGame)
                {
                    owner.spGameGold = YGBHEntry.Instance.GameData.SmallEndData.nGold;
                }
                else if (YGBHEntry.Instance.GameData.isFreeGame)
                {
                    owner.spGameGold = YGBHEntry.Instance.GameData.TotalFreeWin;
                }
                owner.smallEffect.transform.localPosition = new Vector3(0, -500, 0);
                owner.smallEffect.transform.localScale = Vector3.zero;
                owner.winSmallEffectNum.text = 0.ShortNumber().ShowRichText();
                owner.smallEffect.gameObject.SetActive(true);
                owner.smallEffect.DOLocalMove(Vector3.zero, 0.3f);
                owner.smallEffect.DOScale(Vector3.one, 0.3f).OnComplete(() =>
                {
                    timer = 0;
                    Transform jbObj = owner.smallEffect.transform.FindChildDepth("JB");
                    jbObj.DOScale(Vector3.one * 1.15f, 0.1f).OnComplete(() =>
                    {
                        jbObj.DOScale(Vector3.one, 0.1f);
                    });
                    YGBH_Audio.Instance.PlaySound(YGBH_Audio.FIREGOLD, YGBH_DataConfig.winGoldChangeRate);
                    ToolHelper.RunGoal(0,owner.spGameGold, YGBH_DataConfig.winBigGoldChangeRate, delegate (string goal)
                    {
                        long.TryParse(goal, out var num);
                        owner.winSmallEffectNum.text = num.ShortNumber().ShowRichText();

                    }).OnComplete(delegate ()
                    {
                        owner.isShowCSJLResult = false;
                        YGBHEntry.Instance.FullSP = false;
                        bool issmall = YGBHEntry.Instance.GameData.isSmallGame;
                        if (YGBHEntry.Instance.GameData.isSmallGame)
                        {
                            YGBHEntry.Instance.GameData.isSmallGame = false;
                            for (int i = 0; i < YGBHEntry.Instance.dlBtn.transform.childCount; i++)
                            {
                                YGBHEntry.Instance.dlBtn.transform.GetChild(i).gameObject.SetActive(false);
                            }
                            YGBHEntry.Instance.smallSPRealCount = 0;
                        }
                        ToolHelper.DelayRun(1f, () =>
                        {
                            owner.smallEffect.DOScale(Vector3.zero, 0.3f).OnComplete(() =>
                            {
                                owner.smallEffect.gameObject.SetActive(false);
                                if (issmall) 
                                { 
                                    YGBHEntry.Instance.zpPanel.parent.gameObject.SetActive(false);
                                }
                                isStart = true;
                            });
                        });
                    });
                });
            }

            public override void Update()
            {
                base.Update();
                if (!isStart) return;
                timer += Time.deltaTime;
                if (timer >= 0.1f)
                {
                    isStart = false;
                    YGBHEntry.Instance.OnClickCloseFreeResult();
                    YGBH_Event.DispatchShowResultComplete();
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }


    }
}
