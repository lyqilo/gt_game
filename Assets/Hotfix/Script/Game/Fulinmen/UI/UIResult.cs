using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using Spine;
using Spine.Unity;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Object = UnityEngine.Object;

namespace Hotfix.Fulinmen
{
    public class UIResult : MonoBehaviour, IILManager
    {
        public static UIResult Add(GameObject go, Transform selfPos)
        {
            UIResult ui = go.CreateOrGetComponent<UIResult>();
            ui._selfPos = selfPos;
            ui.Init();
            return ui;
        }

        private Transform _selfPos;
        private float _timer = 0;
        private bool _isShow = false;

        private bool _isPause = false;

        private long _currentRunGold = 0;

        private bool _isShowFXGZ = false; //展示福星高照
        private bool _isShowFLSQ = false; //展示福禄双全
        private bool _isShowWFQQ = false; //展示五福齐全
        private bool _isShowBFJZ = false; //展示百福具臻
        private bool _isShowFMT = false; //展示福满堂
        private bool _isShowNormal = false; //展示中奖
        private bool _isHideNormal = false; //隐藏中奖
        private CAction _showResultCallback = null;
        private float _hideNormalTime = 0.5f; //退出动画时长

        private bool _nowin = false; //没有得分
        private bool _isFreeGame = false; //是否为免费游戏
        private CAction _showFreeTweener = null; //免费财神动画tween
        private bool _isShowFree = false; //展示免费
        private bool _isHideFree = false; //隐藏免费

        private long _totalFreeGold = 0;
        private bool _isShowTotalFree = false;
        private SkeletonGraphic winNormalEffect;
        private TextMeshProUGUI winNormalNum;
        private SkeletonGraphic DJJYEffect;
        private SkeletonGraphic WFQQEffect;
        private TextMeshProUGUI WFQQNum;
        private SkeletonGraphic FXGZEffect;
        private TextMeshProUGUI FXGZNum;
        private SkeletonGraphic FMTEffect;
        private TextMeshProUGUI FMTNum;
        private SkeletonGraphic FLSQEffect;
        private TextMeshProUGUI FLSQNum;
        private SkeletonGraphic BFJZEffect;
        private TextMeshProUGUI BFJZNum;
        private SkeletonGraphic EnterFreeEffect;
        private SkeletonGraphic FreeResultEffect;
        private TextMeshProUGUI FreeResultNum;


        public TextMeshProUGUI WinNum { get; set; }
        public Transform CSGroup { get; set; }

        private List<IState> _states;
        private HierarchicalStateMachine _hsm;
        private Transform RollContent;
        private Tweener _tween;

        private void Awake()
        {
            var parent = transform.parent;
            RollContent = parent.FindChildDepth("RollContent");//转动区域
            WinNum = parent.FindChildDepth<TextMeshProUGUI>("Bottom/Win/Num"); //本次获得金币
            CSGroup = parent.FindChildDepth("CSContent"); //显示财神
            winNormalEffect = transform.FindChildDepth<SkeletonGraphic>("Reward");
            winNormalNum = winNormalEffect.transform.FindChildDepth<TextMeshProUGUI>("RewardNum");
            DJJYEffect = transform.FindChildDepth<SkeletonGraphic>("DJJY");
            WFQQEffect = transform.FindChildDepth<SkeletonGraphic>("WFQQ");
            WFQQNum = WFQQEffect.transform.FindChildDepth<TextMeshProUGUI>("Num");
            FXGZEffect = transform.FindChildDepth<SkeletonGraphic>("FXGZ");
            FXGZNum = FXGZEffect.transform.FindChildDepth<TextMeshProUGUI>("Num");
            FMTEffect = transform.FindChildDepth<SkeletonGraphic>("FMT");
            FMTNum = FMTEffect.transform.FindChildDepth<TextMeshProUGUI>("Num");
            FLSQEffect = transform.FindChildDepth<SkeletonGraphic>("FLSQ");
            FLSQNum = FLSQEffect.transform.FindChildDepth<TextMeshProUGUI>("Num");
            BFJZEffect = transform.FindChildDepth<SkeletonGraphic>("BFJZ");
            BFJZNum = BFJZEffect.transform.FindChildDepth<TextMeshProUGUI>("Num");
            EnterFreeEffect = transform.FindChildDepth<SkeletonGraphic>("EnterFree");
            FreeResultEffect = transform.FindChildDepth<SkeletonGraphic>("FreeResult");
            FreeResultNum = FreeResultEffect.transform.FindChildDepth<TextMeshProUGUI>("Num");
            _hsm = new HierarchicalStateMachine(false, gameObject);
            _states = new List<IState>
            {
                new IdleState(this, _hsm),
                new DJJYShowState(this, _hsm),
                new DJJYState(this, _hsm),
                new DJJYResultState(this, _hsm),
                new ReRollDJJYState(this, _hsm),
                new BFJZState(this, _hsm),
                new WFQQState(this, _hsm),
                new FLSQState(this, _hsm),
                new FXGZState(this, _hsm),
                new FMTState(this, _hsm),
                new NormalShowState(this, _hsm),
                new NormalHideState(this, _hsm),
                new FreeShowState(this, _hsm),
                new FreeResultState(this, _hsm),
                new NoWinState(this, _hsm),
                new CheckState(this, _hsm)
            };
            _hsm.Init(_states,nameof(IdleState));
            HotfixMessageHelper.AddListener(Model.ShowResult, OnShowResult);
            HotfixMessageHelper.AddListener(Model.StartRoll, OnRoll);
        }

        private void Update()
        {
            _hsm?.Update();
        }

        private void OnDestroy()
        {
            HotfixMessageHelper.RemoveListener(Model.ShowResult, OnShowResult);
            HotfixMessageHelper.RemoveListener(Model.StartRoll, OnRoll);
            _hsm?.CurrentState?.OnExit();
            _tween?.Kill();
        }

        private void OnShowResult(object data)
        {
            ShowResult();
        }

        private void OnRoll(object data)
        {
            HideResult();
        }

        private void Init()
        {
            _showResultCallback = null;
            _timer = 0;
            _currentRunGold = 0;
            _isShow = false;
            _isPause = false;
            WinNum.SetText("0");
        }

        private void ShowResult()
        {
            //TODO 判断中奖
            //如果是 中小游戏类型（财神降临）
            _showResultCallback = null;
            _timer = 0;
            _currentRunGold = 0;
            _isShow = true;
            if (!Model.Instance.IsDJJY)
            {
                WinNum.text = Model.Instance.ResultInfo.WinScore.ShortNumber();
                if (Model.Instance.ResultInfo.GoldModelNum > 0)
                {
                    //得财神
                    Model.Instance.IsDJJY = true;
                    _hsm.ChangeState(nameof(DJJYShowState));
                }
                else
                {
                    //其他正常模式
                    if (Model.Instance.ResultInfo.fuType[2] > 0)
                    {
                        _hsm.ChangeState(nameof(FMTState));
                    }
                    else if (Model.Instance.ResultInfo.allOpenRate > 499)
                    {
                        _hsm.ChangeState(nameof(BFJZState));
                    }
                    else if (Model.Instance.ResultInfo.allOpenRate > 299)
                    {
                        _hsm.ChangeState(nameof(WFQQState));
                    }
                    else if (Model.Instance.ResultInfo.allOpenRate > 199)
                    {
                        _hsm.ChangeState(nameof(FLSQState));
                    }
                    else if (Model.Instance.ResultInfo.allOpenRate > 99)
                    {
                        _hsm.ChangeState(nameof(FXGZState));
                    }
                    else if (Model.Instance.ResultInfo.allOpenRate >= 0)
                    {
                        if (Model.Instance.ResultInfo.WinScore > 0)
                        {
                            _hsm.ChangeState(nameof(NormalShowState));
                        }
                        else
                        {
                            _hsm.ChangeState(nameof(NoWinState));
                            HotfixMessageHelper.PostHotfixEvent(Model.RefreshGold);
                        }
                    }
                }
            }
            else
            {
                _hsm.ChangeState(Model.Instance.ResultInfo.GoldModelNum > 0
                    ? nameof(DJJYState)
                    : nameof(DJJYResultState));
            }
        }
        private void HideResult()
        {
            for (int i = 0; i < transform.childCount; i++)
            {
                transform.GetChild(i).gameObject.SetActive(false);
            }

            _showResultCallback = null;
        }

        private void ShowEffect(TextMeshProUGUI num, long startScore, long targetScore,float timer, CAction onPreRunScore,
            Action onScoreRollComplete, bool isRich = false)
        {
            onPreRunScore?.Invoke();
            _currentRunGold = 0;
            num.text = isRich ? _currentRunGold.ShortNumber().ShowRichText() : _currentRunGold.ShortNumber();
            num.gameObject.SetActive(true);
            HotfixMessageHelper.PostHotfixEvent(Model.RefreshGold);
            _tween?.Kill();
            _tween = DOTween.To(v =>
            {
                _currentRunGold = Mathf.CeilToInt(v);
                num.text = isRich ? _currentRunGold.ShortNumber().ShowRichText() : _currentRunGold.ShortNumber();
            }, startScore, targetScore, timer).SetEase(Ease.Linear).OnComplete(() =>
            {
                num.text = isRich ? targetScore.ShortNumber().ShowRichText() : targetScore.ShortNumber();
                onScoreRollComplete?.Invoke();
            });
        }

        private class IdleState : State<UIResult>
        {
            public IdleState(UIResult owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }
        
        private class DJJYShowState : State<UIResult>
        {
            public DJJYShowState(UIResult owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                //堆金积玉展示动画
                Model.Instance.PlaySound(Model.Sound.Bell);
                owner.DJJYEffect.gameObject.SetActive(true);
                owner.DJJYEffect.AnimationState.SetAnimation(0, "ch_in", false);
                owner.DJJYEffect.AnimationState.AddAnimation(0, "ch_idle", true, 0);
                owner.CSGroup.gameObject.SetActive(true);
                for (int i = 0; i < owner.CSGroup.childCount; i++)
                {
                    for (int j = 0; j < owner.CSGroup.GetChild(i).childCount; j++)
                    {
                        owner.CSGroup.GetChild(i).GetChild(j).gameObject.SetActive(false);
                    }
                }

                for (int i = 0; i < Model.Instance.ResultInfo.ImgTable.Count; i++)
                {
                    if (Model.Instance.ResultInfo.ImgTable[i] != 11) continue;
                    int column = i / 5;//排
                    int raw = i % 5;//列
                    owner.CSGroup.GetChild(raw).GetChild(column).gameObject.SetActive(true);
                    string num = Model.Instance.ResultInfo.GoldNum[i] switch
                    {
                        1 => "d".ShowRichText(),
                        2 => "x".ShowRichText(),
                        _ => Model.Instance.ResultInfo.GoldNum[i].ShortNumber().ShowRichText()
                    };

                    owner.CSGroup.GetChild(raw).GetChild(column).Find("Icon").GetChild(0).GetComponent<TextMeshProUGUI>().SetText(num);
                }

                owner.StartCoroutine(ToolHelper.DelayCall(Data.smallGameLoadingShowTime, () =>
                {
                    owner.DJJYEffect.gameObject.SetActive(false);
                    Model.Instance.PlaySound(Model.Sound.NCoin);
                    Model.Instance.PlayBGM(Model.Sound.BGM_Coin);
                    hsm.ChangeState(nameof(CheckState));
                    HotfixMessageHelper.PostHotfixEvent(Model.DJJYRoll);
                }));
            }
        }
        
        private class DJJYState : State<UIResult>
        {
            public DJJYState(UIResult owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.WinNum.text = Model.Instance.ResultInfo.WinScore.ShortNumber();
                //继续重转
                for (int i = 0; i < Model.Instance.ResultInfo.ImgTable.Count; i++)
                {
                    if (Model.Instance.ResultInfo.ImgTable[i] != 11) continue;
                    int column = i / 5;
                    //排
                    int raw = i % 5;
                    //列
                    string num = Model.Instance.ResultInfo.GoldNum[i] switch
                    {
                        1 => "d".ShowRichText(),
                        2 => "x".ShowRichText(),
                        _ => Model.Instance.ResultInfo.GoldNum[i].ShortNumber().ShowRichText()
                    };

                    owner.CSGroup.GetChild(raw).GetChild(column).Find("Icon").GetChild(0)
                        .GetComponent<TextMeshProUGUI>().SetText(num);
                    owner.CSGroup.GetChild(raw).GetChild(column).gameObject.SetActive(true);
                }

                owner.StartCoroutine(ToolHelper.DelayCall(Data.autoNoRewardInterval, () =>
                {
                    hsm.ChangeState(nameof(CheckState));
                    HotfixMessageHelper.PostHotfixEvent(Model.DJJYRoll);
                }));
            }
        }
        
        private class ReRollDJJYState : State<UIResult>
        {
            public ReRollDJJYState(UIResult owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.WinNum.SetText(Model.Instance.ResultInfo.WinScore.ShortNumber());
                //继续重转
                for (int i = 0; i < Model.Instance.ResultInfo.ImgTable.Count; i++)
                {
                    if (Model.Instance.ResultInfo.ImgTable[i] != 11) continue;
                    int column = i / 5;
                    //排
                    int raw = i % 5;
                    //列
                    string num = Model.Instance.ResultInfo.GoldNum[i] switch
                    {
                        1 => "d".ShowRichText(),
                        2 => "x".ShowRichText(),
                        _ => Model.Instance.ResultInfo.GoldNum[i].ShortNumber().ShowRichText()
                    };

                    owner.CSGroup.GetChild(raw).GetChild(column).Find("Icon").GetChild(0)
                        .GetComponent<TextMeshProUGUI>().SetText(num);
                    owner.CSGroup.GetChild(raw).GetChild(column).gameObject.SetActive(true);
                }

                owner.StartCoroutine(ToolHelper.DelayCall(Data.autoNoRewardInterval, () =>
                {
                    hsm.ChangeState(nameof(CheckState));
                    HotfixMessageHelper.PostHotfixEvent(Model.DJJYRoll);
                }));
            }
        }
        private class DJJYResultState : State<UIResult>
        {
            public DJJYResultState(UIResult owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                DebugHelper.Log("====堆金积玉结束1====");
                Model.Instance.IsDJJY = false;
                long showNum = 0;
                long hideNum = 0;
                long totalwin = 0;
                bool resultOver = false;
                for (int i = 0; i < owner.CSGroup.childCount; i++)
                {
                    for (int j = 0; j < owner.CSGroup.GetChild(i).childCount; j++)
                    {
                        TextMeshProUGUI num = owner.CSGroup.GetChild(i).GetChild(j).Find("Icon").GetChild(0)
                            .GetComponent<TextMeshProUGUI>();
                        if (string.IsNullOrEmpty(num.text)) continue;
                        showNum += 1;
                        GameObject go = Object.Instantiate(num.gameObject, num.transform.parent, false);
                        go.name = num.gameObject.name;
                        go.transform.localPosition = Vector3.zero;
                        go.transform.localRotation = Quaternion.identity;
                        go.transform.localScale = Vector3.one;
                        var num1 = showNum;
                        go.transform.DOMove(owner.WinNum.transform.position, 0.3f).SetEase(DG.Tweening.Ease
                            .Linear).OnComplete(() =>
                        {
                            long.TryParse(go.name, out var goNum);
                            totalwin += goNum;
                            owner.WinNum.SetText(totalwin.ShortNumber());
                            UnityEngine.Object.Destroy(go.gameObject);
                            hideNum += 1;
                            if (hideNum == num1) resultOver = true;
                        });
                    }
                }

                owner.StartCoroutine(ToolHelper.DelayCall(0.4f, () =>
                {
                    owner.ShowEffect(owner.winNormalNum,0,Model.Instance.ResultInfo.WinScore,Data.winGoldChangeRate, () =>
                    {
                        owner.winNormalNum.gameObject.SetActive(true);
                        owner.winNormalEffect.gameObject.SetActive(true);
                        owner.winNormalEffect.AnimationState.SetAnimation(0, "ch_in", false);
                        owner.winNormalEffect.AnimationState.AddAnimation(0, "ch_idle", true, 0);
                    }, () =>
                    {
                        Model.Instance.PlayBGM();
                        owner.winNormalNum.gameObject.SetActive(false);
                        owner.winNormalEffect.AnimationState.SetAnimation(0, "ch_out", false);
                        owner.CSGroup.gameObject.SetActive(false);
                        for (int i = 0; i < owner.CSGroup.childCount; i++)
                        {
                            for (int j = 0; j < owner.CSGroup.GetChild(i).childCount; j++)
                            {
                                owner.CSGroup.GetChild(i).GetChild(j).gameObject.SetActive(false);
                                owner.CSGroup.GetChild(i).GetChild(j).Find("Icon").GetChild(0).GetComponent<TextMeshProUGUI>().text = "";
                            }
                        }
                        hsm.ChangeState(nameof(NormalHideState));
                    },true);
                }));
            }
        }
        
        private class BFJZState : State<UIResult>
        {
            public BFJZState(UIResult owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                //百福具臻奖动画
                owner.ShowEffect(owner.BFJZNum,0,Model.Instance.ResultInfo.WinScore,Data.winBigGoldChangeRate, () =>
                {
                    Model.Instance.PlaySound(Model.Sound.WinBig);
                    Model.Instance.PlaySound(Model.Sound.Coin_Collect);
                    owner.BFJZEffect.gameObject.SetActive(true);
                    owner.BFJZEffect.AnimationState.SetAnimation(0, "start", false);
                    owner.BFJZEffect.AnimationState.AddAnimation(0, "loop", true, 0);
                }, () =>
                {
                    owner.StartCoroutine(ToolHelper.DelayCall(Data.winBigGoldChangeRate, () =>
                    {
                        owner.BFJZEffect.gameObject.SetActive(false);
                        hsm.ChangeState(nameof(CheckState));
                    }));
                },true);
            }
        }
        private class WFQQState : State<UIResult>
        {
            public WFQQState(UIResult owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                //五福齐全奖动画
                owner.ShowEffect(owner.WFQQNum,0,Model.Instance.ResultInfo.WinScore,Data.winBigGoldChangeRate, () =>
                {
                    Model.Instance.PlaySound(Model.Sound.WinBig);
                    Model.Instance.PlaySound(Model.Sound.Coin_Collect);
                    owner.WFQQEffect.gameObject.SetActive(true);
                    owner.WFQQEffect.AnimationState.SetAnimation(0, "start", false);
                    owner.WFQQEffect.AnimationState.AddAnimation(0, "loop", true, 0);
                }, () =>
                {
                    owner.StartCoroutine(ToolHelper.DelayCall(Data.winBigGoldChangeRate, () =>
                    {
                        owner.WFQQEffect.gameObject.SetActive(false);
                        hsm.ChangeState(nameof(CheckState));
                    }));
                },true);
            }
        }
        private class FLSQState : State<UIResult>
        {
            public FLSQState(UIResult owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                //福禄双全
                owner.ShowEffect(owner.FLSQNum,0,Model.Instance.ResultInfo.WinScore,Data.winBigGoldChangeRate, () =>
                {
                    Model.Instance.PlaySound(Model.Sound.WinBig);
                    Model.Instance.PlaySound(Model.Sound.Coin_Collect);
                    owner.FLSQEffect.gameObject.SetActive(true);
                    owner.FLSQEffect.AnimationState.SetAnimation(0, "start", false);
                    owner.FLSQEffect.AnimationState.AddAnimation(0, "loop", true, 0);
                }, () =>
                {
                    owner.StartCoroutine(ToolHelper.DelayCall(Data.winBigGoldChangeRate, () =>
                    {
                        owner.FLSQEffect.gameObject.SetActive(false);
                        hsm.ChangeState(nameof(CheckState));
                    }));
                },true);
            }
        }
        private class FXGZState : State<UIResult>
        {
            public FXGZState(UIResult owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                //福星高照奖动画
                owner.ShowEffect(owner.FXGZNum,0,Model.Instance.ResultInfo.WinScore,Data.winBigGoldChangeRate, () =>
                {
                    Model.Instance.PlaySound(Model.Sound.WinBig);
                    Model.Instance.PlaySound(Model.Sound.Coin_Collect);
                    owner.FXGZEffect.gameObject.SetActive(true);
                    owner.FXGZEffect.AnimationState.SetAnimation(0, "start", false);
                    owner.FXGZEffect.AnimationState.AddAnimation(0, "loop", true, 0);
                }, () =>
                {
                    owner.StartCoroutine(ToolHelper.DelayCall(Data.winBigGoldChangeRate, () =>
                    {
                        owner.FXGZEffect.gameObject.SetActive(false);
                        hsm.ChangeState(nameof(CheckState));
                    }));
                },true);
            }
        }
        private class FMTState : State<UIResult>
        {
            public FMTState(UIResult owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                //福满堂奖动画
                owner.ShowEffect(owner.FMTNum,0,Model.Instance.ResultInfo.WinScore,Data.winGoldChangeRate, () =>
                {
                    Model.Instance.PlaySound(Model.Sound.Jackpot, Data.winGoldChangeRate);
                    owner.FMTEffect.gameObject.SetActive(true);
                    owner.FMTEffect.AnimationState.SetAnimation(0, "start", false);
                    owner.FMTEffect.AnimationState.AddAnimation(0, "loop", true, 0);
                }, () =>
                {
                    owner.StartCoroutine(ToolHelper.DelayCall(Data.winBigGoldChangeRate, () =>
                    {
                        owner.FMTEffect.gameObject.SetActive(false);
                        hsm.ChangeState(nameof(CheckState));
                    }));
                },true);
            }
        }
        private class NormalShowState : State<UIResult>
        {
            public NormalShowState(UIResult owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            private Tween _tween;
            public override void OnEnter()
            {
                base.OnEnter();
                //普通奖动画     
                owner.ShowEffect(owner.winNormalNum,0,Model.Instance.ResultInfo.WinScore,Data.winGoldChangeRate, () =>
                {
                    owner.winNormalNum.gameObject.SetActive(true);
                    Model.Instance.PlaySound(Model.Sound.Coin_Collect, Data.winGoldChangeRate);
                    owner.winNormalEffect.gameObject.SetActive(true);
                    owner.winNormalEffect.AnimationState.SetAnimation(0, "ch_in", false);
                    owner.winNormalEffect.AnimationState.AddAnimation(0, "ch_idle", true, 0);
                }, () =>
                {
                    owner.StartCoroutine(ToolHelper.DelayCall(Data.winGoldChangeRate, () =>
                    {
                        owner.winNormalNum.gameObject.SetActive(false);
                        owner.winNormalEffect.AnimationState.SetAnimation(0, "ch_out", false);
                        hsm.ChangeState(nameof(NormalHideState));
                    }));
                },true);
                // FLM_Line.Show();
                Model.Instance.PlaySound(Model.Sound.Win, Data.winGoldChangeRate);
            }

            public override void OnExit()
            {
                base.OnExit();
                _tween?.Kill();
                _tween = null;
            }
        }
        private class NormalHideState : State<UIResult>
        {
            public NormalHideState(UIResult owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            float hideNormalTime = 0.5f;//退出动画时长
            public override void OnEnter()
            {
                base.OnEnter();
                owner._timer = 0;
            }

            public override void Update()
            {
                base.Update();
                owner._timer += Time.deltaTime;
                if (owner._timer < hideNormalTime) return;
                //等待退出动画时长
                owner._timer = 0;
                owner.winNormalEffect.gameObject.SetActive(false);
                hsm.ChangeState(nameof(CheckState));
            }
        }
        private class FreeShowState : State<UIResult>
        {
            public FreeShowState(UIResult owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            List<GameObject> bplist = new List<GameObject>();
            public override void OnEnter()
            {
                base.OnEnter();
                owner._timer = 0;
                //展示免费
                Model.Instance.IsFreeGame = true;
                Model.Instance.PlayBGM(Model.Sound.BGM_Free);
                Model.Instance.PlaySound(Model.Sound.NFree);
                bplist.Clear();
                if (!Model.Instance.IsScene)
                {
                    for (int i = 0; i < Model.Instance.ResultInfo.ImgTable.Count; i++)
                    {
                        if (Model.Instance.ResultInfo.ImgTable[i] != 10) continue;
                        int column = i / 5;
                        int raw = i % 5;
                        Transform child = owner.RollContent.transform.GetChild(raw).GetComponent<ScrollRect>().content
                            .GetChild(column);
                        Transform icon = child.Find("Icon");
                        GameObject bp = Model.Instance.CreateEffect("BP");
                        bp.transform.SetParent(icon);
                        icon.GetComponent<Image>().enabled = false;
                        bp.gameObject.name = "BP";
                        bp.transform.localPosition = Vector3.zero;
                        bp.transform.localScale = Vector3.one;
                        bp.transform.localRotation = Quaternion.identity;
                        bp.gameObject.SetActive(true);
                        bp.transform.GetComponent<SkeletonGraphic>().AnimationState.SetAnimation(0, "animation", true);
                        bplist.Add(bp.gameObject);
                    }

                    Model.Instance.PlaySound(Model.Sound.FireCrackerExplose);
                }

                owner.StartCoroutine(Delay());
            }

            private IEnumerator Delay()
            {
                yield return new WaitForSeconds(1);
                for (int i = 0; i < bplist.Count; i++)
                {
                    bplist[i].transform.parent.GetComponent<Image>().enabled = true;
                    Model.Instance.CollectEffect(bplist[i]);
                }

                owner.EnterFreeEffect.gameObject.SetActive(true);
                owner.EnterFreeEffect.AnimationState.SetAnimation(0, "animation", true);
                owner._timer = 0;
                owner._totalFreeGold = 0;
                yield return new WaitForSeconds(Data.freeLoadingShowTime);
                hsm.ChangeState(nameof(CheckState));
            }
            public override void OnExit()
            {
                base.OnExit();
                owner.EnterFreeEffect.gameObject.SetActive(false);
            }
        }
        private class FreeResultState : State<UIResult>
        {
            public FreeResultState(UIResult owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            private Tween _tween;
            public override void OnEnter()
            {
                base.OnEnter();
                owner._timer = 0;
                owner._currentRunGold = 0;
                owner._showResultCallback = () =>
                {
                    Model.Instance.PlayBGM();
                    owner.FreeResultEffect.gameObject.SetActive(false);
                    owner._timer = 0;
                    Model.Instance.IsFreeGame = false;
                    hsm.ChangeState(nameof(CheckState));
                };
                owner.WinNum.text = owner._totalFreeGold.ShortNumber();
                owner.FreeResultNum.text = owner._currentRunGold.ShortNumber().ShowRichText();
                owner.FreeResultEffect.gameObject.SetActive(true);
                owner.FreeResultEffect.AnimationState.SetAnimation(0, "animation", true);
                owner.FreeResultNum.gameObject.SetActive(true);
                HotfixMessageHelper.PostHotfixEvent(Model.RefreshGold);
                _tween = DOTween.To(v =>
                {
                    owner._currentRunGold = Mathf.CeilToInt(v);
                    owner.FreeResultNum.text = owner._currentRunGold.ShortNumber().ShowRichText();
                }, 0, owner._totalFreeGold, Data.winGoldChangeRate).SetEase(Ease.Linear).OnComplete(() =>
                {
                    owner.FreeResultNum.text = owner._totalFreeGold.ShortNumber().ShowRichText();
                    owner._showResultCallback?.Invoke();
                });
            }

            public override void OnExit()
            {
                base.OnExit();
                _tween?.Kill();
                _tween = null;
            }
        }
        private class NoWinState : State<UIResult>
        {
            public NoWinState(UIResult owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner._timer = 0;
            }

            public override void Update()
            {
                base.Update();
                owner._timer += Time.deltaTime;
                if (owner._timer < Data.autoNoRewardInterval) return;
                owner._timer = 0;
                hsm.ChangeState(nameof(CheckState));
            }
        }
        
        private class CheckState : State<UIResult>
        {
            public CheckState(UIResult owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            private bool _isComplete;
            public override void OnEnter()
            {
                base.OnEnter();
                _isComplete = false;
            }

            public override void Update()
            {
                base.Update();
                if (_isComplete) return;
                _isComplete = true;
                if (!Model.Instance.IsFreeGame)
                {
                    if (Model.Instance.ResultInfo.FreeCount > 0)
                    {
                        // FLM_Line.Close();
                        hsm.ChangeState(nameof(FreeShowState));
                    }
                    else
                    {
                        hsm.ChangeState(nameof(IdleState));
                        HotfixMessageHelper.PostHotfixEvent(Model.Check);
                    }
                }
                else
                {
                    hsm.ChangeState(nameof(IdleState));
                    HotfixMessageHelper.PostHotfixEvent(Model.Check);
                }
            }
        }
    }
}