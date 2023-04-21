using DG.Tweening;
using LuaFramework;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Transform = UnityEngine.Transform;

namespace Hotfix.TouKui
{
    /// <summary>
    /// 游戏主入口
    /// </summary>
    public class TouKuiEntry : SingletonILEntity<TouKuiEntry>
    {
        public Data GameData { get; set; }

        public Transform MainContent;
        private Animator changeGameModeAnim;
        private Transform RollContent;
        private TextMeshProUGUI lineNum;
        private TextMeshProUGUI ChipNum;
        private TextMeshProUGUI TotalChipNum;
        private TextMeshProUGUI winNum;
        private Button reduceChipBtn;
        private Button addChipBtn;
        private Transform btnGroup;
        private Transform startBtn;
        private Button startState;
        private Button stopState;
        private Button openAutoBtn;
        private Button closeAutoBtn;
        private Button MaxChipBtn;
        private Button closeAutoListBtn;
        private TextMeshProUGUI autoNum;
        private Transform autoListGroup;
        private Transform freeShowGroup;
        private TextMeshProUGUI freeNum;
        private TextMeshProUGUI freeTotalWinNum;
        private Transform rulePanel;
        private Button closeGame;
        private Button showRuleBtn;
        private Toggle soundBtn;
        private Transform soundOn;
        private Transform soundOff;
        private Transform userInfo;
        private TextMeshProUGUI selfGold;
        private Transform resultEffect;
        private Transform CSGroup;

        public Transform effectList;
        public Transform effectPool;



        private Transform freeResultNode;
        private TextMeshProUGUI freeShowNum;
        private Button freeResultSureBtn;
        private Transform specialModeNode;
        HierarchicalStateMachine hsm;
        List<IState> states;

        protected override void Awake()
        {
            base.Awake();
            Screen.orientation = ScreenOrientation.Landscape;
            Screen.autorotateToLandscapeLeft = true;
            Screen.autorotateToLandscapeRight = true;
            Screen.autorotateToPortrait = false;
            Screen.autorotateToPortraitUpsideDown = false;
            GameData = new Data();
            gameObject.AddILComponent<TouKui_Network>();
            gameObject.AddILComponent<TouKui_Audio>();
            gameObject.AddILComponent<TouKui_SpecialMode>();
        }

        protected override void Start()
        {
            base.Start();
            hsm = new HierarchicalStateMachine(false, gameObject);
            states = new List<IState>();
            states.Add(new IdleState(this, hsm));
            states.Add(new InitState(this, hsm));
            states.Add(new CheckState(this, hsm));
            states.Add(new WaitStopState(this, hsm));
            states.Add(new NormalRollState(this, hsm));
            states.Add(new AutoRollState(this, hsm));
            states.Add(new EnterFreeState(this, hsm));
            states.Add(new FreeRollState(this, hsm));
            states.Add(new FreeResultState(this, hsm));
            hsm.Init(states, nameof(IdleState));
        }
        protected override void OnDestroy()
        {
            base.OnDestroy();
            hsm?.CurrentState.OnExit();
        }
        protected override void Update()
        {
            base.Update();
            hsm?.Update();
        }
        protected override void AddEvent()
        {
            base.AddEvent();
            TouKui_Event.RefreshGold += TouKui_Event_RefreshGold;
            TouKui_Event.OnGetSceneData += TouKui_Event_OnGetSceneData;
            TouKui_Event.ShowResultComplete += TouKui_Event_ShowResultComplete;
            TouKui_Event.OnChangeBet += TouKui_Event_OnChangeBet;
            TouKui_Event.RollPrepreaComplete += TouKui_Event_RollPrepreaComplete;
            TouKui_Event.RollComplete += TouKui_Event_RollComplete;
            TouKui_Event.BetFailed += TouKui_Event_RollFailed;
            TouKui_Event.ShowResult += TouKui_Event_ShowResult;
            TouKui_Event.SelectFreeGameComplete += TouKui_Event_SelectFreeGameComplete;
            TouKui_Event.ExitSpecialMode += TouKui_Event_ExitSpecialMode;
            TouKui_Event.ChangeSpecialModeBackground += TouKui_Event_ChangeSpecialModeBackground;
            TouKui_Event.CheckRunState += TouKui_Event_CheckRunState;
            HotfixActionHelper.ReconnectGame += EventHelper_ReconnectGame;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            TouKui_Event.RefreshGold -= TouKui_Event_RefreshGold;
            TouKui_Event.OnGetSceneData -= TouKui_Event_OnGetSceneData;
            TouKui_Event.ShowResultComplete -= TouKui_Event_ShowResultComplete;
            TouKui_Event.OnChangeBet -= TouKui_Event_OnChangeBet;
            TouKui_Event.RollPrepreaComplete -= TouKui_Event_RollPrepreaComplete;
            TouKui_Event.RollComplete -= TouKui_Event_RollComplete;
            TouKui_Event.BetFailed -= TouKui_Event_RollFailed;
            TouKui_Event.ShowResult -= TouKui_Event_ShowResult;
            TouKui_Event.SelectFreeGameComplete -= TouKui_Event_SelectFreeGameComplete;
            TouKui_Event.ExitSpecialMode -= TouKui_Event_ExitSpecialMode;
            TouKui_Event.CheckRunState -= TouKui_Event_CheckRunState;
            TouKui_Event.ChangeSpecialModeBackground -= TouKui_Event_ChangeSpecialModeBackground;
            HotfixActionHelper.ReconnectGame -= EventHelper_ReconnectGame;
        }
        protected override void FindComponent()
        {
            base.FindComponent();
            MainContent = transform.Find("MainPanel");

            changeGameModeAnim = MainContent.FindChildDepth<Animator>("Content/Background");

            RollContent = MainContent.Find("Content/RollContent"); //转动区域
            RollContent.gameObject.AddILComponent<TouKui_Roll>();
            lineNum = MainContent.FindChildDepth<TextMeshProUGUI>("Content/Bottom/Chip/BeiNum"); //下注金额
            ChipNum = MainContent.FindChildDepth<TextMeshProUGUI>("Content/Bottom/Chip/ChipNum"); //下注金额
            TotalChipNum = MainContent.FindChildDepth<TextMeshProUGUI>("Content/Bottom/Chip/TotalChipNum"); //下注金额
            lineNum.text = ToolHelper.ShowRichText(TouKui_DataConfig.ALLLINECOUNT);
            TotalChipNum.enableWordWrapping = false;

            winNum = MainContent.FindChildDepth<TextMeshProUGUI>("Content/Bottom/Win/Num");

            reduceChipBtn = MainContent.FindChildDepth<Button>("Content/Bottom/Chip/Reduce"); //减注
            addChipBtn = MainContent.FindChildDepth<Button>("Content/Bottom/Chip/Add"); //加注

            btnGroup = MainContent.Find("Content/NormalBtnGroup");
            startBtn = btnGroup.Find("StartBtn"); //开始按钮
            startState = startBtn.transform.FindChildDepth<Button>("Start");
            stopState = startBtn.transform.FindChildDepth<Button>("Stop");
            openAutoBtn = btnGroup.transform.FindChildDepth<Button>("OpenAutoBtn");
            closeAutoBtn = btnGroup.transform.FindChildDepth<Button>("CloseAutoBtn");
            closeAutoBtn.gameObject.SetActive(false);

            MaxChipBtn = btnGroup.FindChildDepth<Button>("MaxChip"); //最大下注
            closeAutoListBtn = MainContent.FindChildDepth<Button>("Content/CloseAutoListBtn");
            autoNum = closeAutoBtn.transform.FindChildDepth<TextMeshProUGUI>("Num");
            autoListGroup = closeAutoListBtn.transform.FindChildDepth("AutoList/Group");

            freeShowGroup = MainContent.FindChildDepth("Content/FreeBtnGroup");
            freeNum = freeShowGroup.FindChildDepth<TextMeshProUGUI>("FreeCount");
            freeTotalWinNum = freeShowGroup.FindChildDepth<TextMeshProUGUI>("TotalWin");

            rulePanel = MainContent.FindChildDepth("Content/Rule"); //规则界面
            rulePanel.gameObject.AddILComponent<TouKui_Rule>();

            closeGame = MainContent.FindChildDepth<Button>("Content/QuitGameBtn");
            showRuleBtn = MainContent.FindChildDepth<Button>("Content/RuleBtn");
            soundBtn = MainContent.FindChildDepth<Toggle>("Content/SoundBtn");
            soundOn = soundBtn.transform.FindChildDepth("SoundOn");
            soundOff = soundBtn.transform.FindChildDepth("SoundOff");
            soundBtn.isOn = MusicManager.isPlayMV;
            soundOn.gameObject.SetActive(MusicManager.isPlayMV);
            soundOff.gameObject.SetActive(!MusicManager.isPlayMV);

            userInfo = MainContent.FindChildDepth("Content/Bottom/UserInfo");
            selfGold = userInfo.FindChildDepth<TextMeshProUGUI>("GoldNum"); //自身金币

            resultEffect = MainContent.FindChildDepth("Content/Result");
            resultEffect.gameObject.AddILComponent<TouKui_Result>();

            Transform lineGroup = MainContent.FindChildDepth("Content/LineGroup");
            lineGroup.gameObject.AddILComponent<TouKui_Line>();
            Transform effectgroup = MainContent.FindChildDepth("Content/Effect"); //动画库
            CSGroup = MainContent.FindChildDepth("Content/CSContent"); //显示特別效果

            effectList = MainContent.FindChildDepth("Content/EffectList"); //动画库
            effectPool = MainContent.FindChildDepth("Content/EffectPool"); //动画缓存库


            freeResultNode = transform.FindChildDepth("FreeResult");
            freeShowNum = freeResultNode.FindChildDepth<TextMeshProUGUI>("Num");
            freeResultSureBtn = freeResultNode.FindChildDepth<Button>("Sure");
            specialModeNode = MainContent.FindChildDepth("FreeMN");
            specialModeNode.gameObject.AddILComponent<TouKui_Lens>();

        }
        private void AddListener()
        {
            reduceChipBtn.onClick.RemoveAllListeners();
            reduceChipBtn.onClick.Add(ReduceChipCall);
            addChipBtn.onClick.RemoveAllListeners();
            addChipBtn.onClick.Add(AddChipCall);

            startState.onClick.RemoveAllListeners();
            startState.onClick.Add(StartGameCall);
            stopState.onClick.RemoveAllListeners();
            stopState.onClick.Add(StopGame);

            showRuleBtn.onClick.RemoveAllListeners(); //显示规则
            showRuleBtn.onClick.Add(ShowRulePanel);

            MaxChipBtn.onClick.RemoveAllListeners();
            MaxChipBtn.onClick.Add(SetMaxChipCall);

            closeGame.onClick.RemoveAllListeners();
            closeGame.onClick.Add(CloseGameCall);

            openAutoBtn.onClick.RemoveAllListeners();
            openAutoBtn.onClick.Add(OpenAutoListCall);

            closeAutoBtn.onClick.RemoveAllListeners();
            closeAutoBtn.onClick.Add(StopAutoGame);
            closeAutoListBtn.onClick.RemoveAllListeners();
            closeAutoListBtn.onClick.Add(CloseAutoListCall);
            soundBtn.onValueChanged.RemoveAllListeners();
            soundBtn.onValueChanged.Add(delegate (bool value)
            {
                if (value)
                {
                    ToolHelper.PlaySound();
                    ToolHelper.PlayMusic();
                    TouKui_Audio.Instance.ResetSound();
                    TouKui_Audio.Instance.PlaySound(TouKui_Audio.BTN);
                }
                else
                {
                    ToolHelper.MuteMusic();
                    ToolHelper.MuteSound();
                    TouKui_Audio.Instance.MuteSound();
                }
                soundOn.gameObject.SetActive(MusicManager.isPlayMV);
                soundOff.gameObject.SetActive(!MusicManager.isPlayMV);
            });
            for (int i = 0; i < autoListGroup.childCount; i++)
            {
                Button child = autoListGroup.GetChild(i).GetComponent<Button>();
                if (child != null)
                {
                    child.onClick.RemoveAllListeners();
                    child.onClick.Add(delegate ()
                    {
                        OnClickAutoCall(int.Parse(child.gameObject.name));
                        CloseAutoListCall();
                    });
                }
            }
        }

        private void TouKui_Event_RefreshGold(long gold)
        {
            GameData.myGold = gold;
            selfGold.text = GameData.myGold.ShortNumber().ShowRichText();
        }

        private void TouKui_Event_OnGetSceneData()
        {
            hsm?.ChangeState(nameof(InitState));
        }


        private void TouKui_Event_CheckRunState()
        {
            hsm?.ChangeState(nameof(CheckState));
        }
        private void TouKui_Event_ShowResultComplete(bool iswin)
        {
            if (!iswin)
            {
                if (GameData.isNormalFreeGame)
                {
                    TouKui_Event.DispatchExitSpecialMode();
                }
                if (GameData.CurrentMode != SpecialMode.FuDong)
                {
                    TouKui_Event.DispatchCheckRunState();
                }
                return;
            }

            if (GameData.ResultData.nWinGold > 0)
            {
                winNum.text = GameData.ResultData.nWinGold.ShortNumber().ShowRichText();
            }
            TouKui_Audio.Instance.PlaySound(TouKui_Audio.FinishMoney);
            //TODO 收分做跳跃动画
            GameObject wintxt = GameObject.Instantiate(winNum.gameObject);
            Vector3 jumpTarget = selfGold.transform.localPosition;
            if (GameData.isFreeGame)
            {
                wintxt.transform.SetParent(freeTotalWinNum.transform.parent);
                jumpTarget = freeTotalWinNum.transform.localPosition;
            }
            else
            {
                wintxt.transform.SetParent(selfGold.transform.parent);
                jumpTarget = selfGold.transform.localPosition;
            }
            wintxt.transform.localScale = Vector3.one;
            wintxt.transform.localRotation = Quaternion.identity;
            wintxt.transform.position = winNum.transform.position;
            wintxt.transform.DOLocalJump(jumpTarget, 30, 1, 0.5f).SetEase(Ease.Linear).OnComplete(delegate ()
            {
                GameObject.Destroy(wintxt);
                if (GameData.isFreeGame)
                {
                    float currentFreeTotal = GameData.TotalFreeWin;
                    GameData.TotalFreeWin += GameData.ResultData.nWinGold;
                    ToolHelper.RunGoal(currentFreeTotal, GameData.TotalFreeWin, 0.2f, delegate (string goal)
                    {
                        long.TryParse(goal, out long num);
                        freeTotalWinNum.text = num.ShortNumber().ShowRichText();
                    }).OnComplete(delegate ()
                      {
                          freeTotalWinNum.text = GameData.TotalFreeWin.ShortNumber().ShowRichText();
                          TouKui_Audio.Instance.PlaySound(TouKui_Audio.AddMoney);
                          ToolHelper.RunGoal(0, 1, 0.5f).OnComplete(delegate ()
                          {
                              if (GameData.CurrentMode == SpecialMode.FuDong && GameData.isFreeGame) 
                              {
                                  TouKui_Event.DispatchChangeFudong();
                                  return;
                              }
                              TouKui_Event.DispatchCheckRunState();
                          });
                      });
                }
                else
                {
                    ToolHelper.RunGoal(GameData.myGold, GameLocalMode.Instance.UserGameInfo.Gold, 0.2f, delegate (string goal)
                      {
                          TouKui_Event.DispatchRefreshGold(long.Parse(goal));
                      }).OnComplete(delegate ()
                      {
                          TouKui_Audio.Instance.PlaySound(TouKui_Audio.AddMoney);
                          TouKui_Event.DispatchRefreshGold((long)GameLocalMode.Instance.UserGameInfo.Gold);
                          if (GameData.CurrentNormalMode != SpecialMode.None)
                          {
                              TouKui_Event.DispatchExitSpecialMode();
                          }
                          ToolHelper.RunGoal(0, 1, 0.5f).OnComplete(delegate ()
                          {
                              TouKui_Event.DispatchCheckRunState();
                          });
                      });
                }
            });
        }
        private void TouKui_Event_OnChangeBet()
        {
            TotalChipNum.text = (GameData.CurrentChip * TouKui_DataConfig.ALLLINECOUNT).ShortNumber().ShowRichText();
        }

        private void TouKui_Event_RollComplete()
        {
            if (GameData.isFreeGame || GameData.isNormalFreeGame) return;//免费先处理免费逻辑
            TouKui_Event.DispatchShowResult();
        }

        private void TouKui_Event_RollPrepreaComplete()
        {
            hsm?.ChangeState(nameof(WaitStopState));
        }

        private void TouKui_Event_RollFailed()
        {
            hsm?.ChangeState(nameof(IdleState));
        }

        private void TouKui_Event_ShowResult()
        {
            stopState.interactable = false;
        }

        private void TouKui_Event_SelectFreeGameComplete()
        {
            hsm?.ChangeState(nameof(FreeRollState));
        }

        private void TouKui_Event_ExitSpecialMode()
        {
            changeGameModeAnim.SetTrigger($"Normal");
        }

        private void TouKui_Event_ChangeSpecialModeBackground(SpecialMode mode)
        {
            changeGameModeAnim.SetTrigger($"Free{(int)mode}");
        }

        private void EventHelper_ReconnectGame()
        {
            hsm?.ChangeState(nameof(IdleState));
        }
        /// <summary>
        /// 加注
        /// </summary>
        private void AddChipCall()
        {
            //加注
            TouKui_Audio.Instance.PlaySound(TouKui_Audio.BTN);
            if (GameData.SceneData.nBet == null || GameData.SceneData.nBet.Count <= 0) return;
            GameData.CurrentChipIndex += 1;
            if (GameData.CurrentChipIndex >= GameData.SceneData.nBetCount)
            {
                GameData.CurrentChipIndex = GameData.SceneData.nBetCount - 1;
                ToolHelper.PopSmallWindow("Bet max reached");
                return;
            }
            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            ChipNum.text = GameData.CurrentChip.ShortNumber().ShowRichText();
            TouKui_Event.DispatchOnChangeBet();
        }

        /// <summary>
        /// 减注
        /// </summary>
        private void ReduceChipCall()
        {
            TouKui_Audio.Instance.PlaySound(TouKui_Audio.BTN);
            if (GameData.SceneData.nBet == null || GameData.SceneData.nBet.Count <= 0) return;
            GameData.CurrentChipIndex -= 1;
            if (GameData.CurrentChipIndex < 0)
            {
                GameData.CurrentChipIndex = 0;
                ToolHelper.PopSmallWindow("Bets have reached the minimum");
                return;
            }
            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            ChipNum.text = GameData.CurrentChip.ShortNumber().ShowRichText();
            TouKui_Event.DispatchOnChangeBet();
        }

        //开始游戏
        private void StartGameCall()
        {
            if (GameData.isFreeGame) return;
            TouKui_Audio.Instance.PlaySound(TouKui_Audio.Run);
            hsm?.ChangeState(nameof(NormalRollState));
        }

        private void StopGame()
        {
            TouKui_Audio.Instance.PlaySound(TouKui_Audio.BTN);
            startState.gameObject.SetActive(true);
            stopState.gameObject.SetActive(false);
            startState.interactable = false;
            stopState.interactable = false;
            TouKui_Event.DispatchStopRoll(true);
        }
        /// <summary>
        /// 显示规则界面
        /// </summary>
        private void ShowRulePanel()
        {
            TouKui_Audio.Instance.PlaySound(TouKui_Audio.BTN);
            rulePanel.gameObject.SetActive(true);
        }
        /// <summary>
        /// 设置最大下注
        /// </summary>
        private void SetMaxChipCall()
        {
            TouKui_Audio.Instance.PlaySound(TouKui_Audio.BTN);
            GameData.CurrentChipIndex = GameData.SceneData.nBetCount - 1;
            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            ChipNum.text = GameData.CurrentChip.ShortNumber().ShowRichText();
            TouKui_Event.DispatchOnChangeBet();
        }
        private void CloseGameCall()
        {
            TouKui_Audio.Instance.PlaySound(TouKui_Audio.BTN);
            if (!GameData.isFreeGame)
            {
                HotfixActionHelper.DispatchLeaveGame();
            }
            else
            {
                ToolHelper.PopSmallWindow("Cannot leave the game in special mode");
            }
        }
        /// <summary>
        /// 打开自动列表
        /// </summary>
        private void OpenAutoListCall()
        {

            if (closeAutoListBtn.gameObject.activeSelf)
            {
                CloseAutoListCall();
                return;
            }
            TouKui_Audio.Instance.PlaySound(TouKui_Audio.BTN);
            closeAutoListBtn.gameObject.SetActive(true);
        }
        /// <summary>
        /// 关闭自动列表
        /// </summary>
        private void CloseAutoListCall()
        {
            TouKui_Audio.Instance.PlaySound(TouKui_Audio.BTN);
            openAutoBtn.interactable = true;
            closeAutoListBtn.gameObject.SetActive(false);
        }
        /// <summary>
        /// 停止自动旋转
        /// </summary>
        private void StopAutoGame()
        {
            GameData.isAutoGame = false;
            GameData.CurrentAutoCount = 0;
            startState.gameObject.SetActive(false);
            stopState.gameObject.SetActive(true);
            startState.interactable = false;
            stopState.interactable = false;
            closeAutoBtn.gameObject.SetActive(false);
            openAutoBtn.gameObject.SetActive(true);
            openAutoBtn.interactable = false;
        }

        private void OnClickAutoCall(int autoCount)
        {
            //点击自动开始
            TouKui_Audio.Instance.PlaySound(TouKui_Audio.BTN);
            GameData.CurrentAutoCount = autoCount;
            hsm?.ChangeState(nameof(AutoRollState));
            GameData.isAutoGame = true;
        }
        #region 状态机
        /// <summary>
        /// 待机状态
        /// </summary>
        private class IdleState : State<TouKuiEntry>
        {
            public IdleState(TouKuiEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.GameData.CurrentAutoCount = 0;
                owner.GameData.CurrentFreeCount = 0;

                owner.freeShowGroup.gameObject.SetActive(false);
                owner.btnGroup.gameObject.SetActive(true);
                owner.startState.gameObject.SetActive(true);
                owner.startState.interactable = true;
                owner.stopState.gameObject.SetActive(false);
                owner.stopState.interactable = true;
                owner.MaxChipBtn.interactable = true;
                owner.addChipBtn.interactable = true;
                owner.reduceChipBtn.interactable = true;
                owner.closeGame.interactable = true;
                owner.openAutoBtn.interactable = true;
                owner.openAutoBtn.gameObject.SetActive(true);
                owner.closeAutoBtn.gameObject.SetActive(false);
            }
        }
        /// <summary>
        /// 初始化状态
        /// </summary>
        private class InitState : State<TouKuiEntry>
        {
            public InitState(TouKuiEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            bool isComplete;
            public override void OnEnter()
            {
                base.OnEnter();
                isComplete = false;
            }
            public override void Update()
            {
                base.Update();
                if (isComplete) return;
                isComplete = true;
                DebugHelper.LogError($"场景消息：{LitJson.JsonMapper.ToJson(owner.GameData.SceneData)}");
                TouKui_Event.DispatchRefreshGold((long)GameLocalMode.Instance.UserGameInfo.Gold);
                if (owner.GameData.SceneData.nCurrenBet != 0)
                {
                    owner.GameData.CurrentChipIndex = owner.GameData.SceneData.nBet.FindListIndex(match =>
                        match == owner.GameData.SceneData.nCurrenBet);
                }
                else
                {
                    owner.GameData.CurrentChipIndex = 0;
                }

                if (owner.GameData.SceneData.nFreeCount <= 0)
                {
                    owner.GameData.CurrentChipIndex = owner.GameData.myGold.CheckNear(owner.GameData.SceneData.nBet);
                }
                owner.GameData.CurrentChip = owner.GameData.SceneData.nBet[owner.GameData.CurrentChipIndex];

                owner.ChipNum.text = owner.GameData.CurrentChip.ShortNumber().ShowRichText();
                TouKui_Event.DispatchOnChangeBet();
                owner.winNum.text = 0.ShortNumber().ShowRichText();
                owner.AddListener();
                if (owner.GameData.CurrentMode != SpecialMode.None)
                {
                    TouKui_Audio.Instance.PlayBGM(TouKui_Audio.FreeBGM);
                    if (owner.GameData.CurrentFreeCount == 10)
                    {
                        hsm?.ChangeState(nameof(EnterFreeState));
                    }
                    else
                    {
                        TouKui_Event.DispatchChangeSpecialModeBackground(owner.GameData.CurrentMode);
                        hsm?.ChangeState(nameof(FreeRollState));
                    }
                }
                else
                {
                    TouKui_Audio.Instance.PlayBGM(TouKui_Audio.BGM);
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }
        /// <summary>
        /// 检查状态
        /// </summary>
        private class CheckState : State<TouKuiEntry>
        {
            public CheckState(TouKuiEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            bool isComplete;
            public override void OnEnter()
            {
                base.OnEnter();
                isComplete = false;
            }
            public override void Update()
            {
                base.Update();
                if (isComplete) return;
                isComplete = true;
                Check();
            }
            private void Check()
            {
                if (owner.GameData.isFreeGame)//如果在免费中
                {
                    //owner.GameData.CurrentFreeCount--;
                    if (owner.GameData.CurrentFreeCount <= 0)//判断免费次数
                    {
                        hsm?.ChangeState(nameof(FreeResultState));
                        return;
                    }
                    hsm?.ChangeState(nameof(FreeRollState));
                    return;
                }
                if (owner.GameData.CurrentMode != SpecialMode.None)//如果不在免费，但有免费次数，进入免费模式
                {
                    TouKui_Audio.Instance.PlayBGM(TouKui_Audio.FreeBGM);
                    hsm?.ChangeState(nameof(EnterFreeState));
                    return;
                }
                if (owner.GameData.isAutoGame)//不在免费，自动模式下
                {
                    owner.GameData.CurrentAutoCount--;
                    if (owner.GameData.CurrentAutoCount <= 0)
                    {
                        owner.GameData.isAutoGame = false;
                        Check();
                        return;
                    }
                    hsm?.ChangeState(nameof(AutoRollState));
                    return;
                }
                hsm?.ChangeState(nameof(IdleState));
            }
        }
        /// <summary>
        /// 免费结算
        /// </summary>
        private class FreeResultState : State<TouKuiEntry>
        {
            public FreeResultState(TouKuiEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.freeResultNode.gameObject.SetActive(true);
                owner.freeShowNum.text = owner.GameData.TotalFreeWin.ShortNumber().ShowRichText();
                owner.freeResultSureBtn.onClick.RemoveAllListeners();
                owner.freeResultSureBtn.onClick.Add(OnClickCloseFreeResult);
            }

            private void OnClickCloseFreeResult()
            {
                owner.freeResultNode.gameObject.SetActive(false);
                TouKui_Audio.Instance.PlayBGM(TouKui_Audio.BGM);
                TouKui_Event.DispatchRefreshGold((long)GameLocalMode.Instance.UserGameInfo.Gold);
                TouKui_Event.DispatchExitSpecialMode();
                hsm?.ChangeState(nameof(CheckState));
            }

        }
        /// <summary>
        /// 正常
        /// </summary>
        private class NormalRollState : State<TouKuiEntry>
        {
            public NormalRollState(TouKuiEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.startState.gameObject.SetActive(false);
                owner.stopState.gameObject.SetActive(true);
                owner.stopState.interactable = false;
                owner.MaxChipBtn.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.closeGame.interactable = false;
                owner.CloseAutoListCall();
                owner.openAutoBtn.interactable = false;
                owner.winNum.text = 0.ShortNumber().ShowRichText();
                TouKui_Network.Instance.StartGame();
            }
        }
        private class WaitStopState : State<TouKuiEntry>
        {
            public WaitStopState(TouKuiEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.stopState.interactable = true;
            }
        }
        /// <summary>
        /// 自动
        /// </summary>
        private class AutoRollState : State<TouKuiEntry>
        {
            public AutoRollState(TouKuiEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.freeShowGroup.gameObject.SetActive(false);
                owner.btnGroup.gameObject.SetActive(true);
                owner.startState.gameObject.SetActive(false);
                owner.startState.interactable = false;
                owner.stopState.gameObject.SetActive(true);
                owner.stopState.interactable = false;
                owner.MaxChipBtn.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.closeGame.interactable = false;
                owner.openAutoBtn.gameObject.SetActive(false);
                owner.closeAutoBtn.gameObject.SetActive(true);
                owner.winNum.text = 0.ShortNumber().ShowRichText();
                owner.autoNum.text = owner.GameData.CurrentAutoCount.ShowRichText();
                TouKui_Network.Instance.StartGame();
            }
        }
        /// <summary>
        /// 免费
        /// </summary>
        private class EnterFreeState : State<TouKuiEntry>
        {
            public EnterFreeState(TouKuiEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.btnGroup.gameObject.SetActive(false);
                owner.freeShowGroup.gameObject.SetActive(true);
                owner.freeTotalWinNum.text = 0.ShortNumber().ShowRichText();
                owner.freeNum.text = owner.GameData.CurrentFreeCount.ShowRichText();
                owner.winNum.text = 0.ShortNumber().ShowRichText();
                owner.GameData.TotalFreeWin = 0;
                TouKui_Event.DispatchOnEnterSpecialGame(true, owner.GameData.CurrentMode);
            }
        }
        /// <summary>
        /// 免费
        /// </summary>
        private class FreeRollState : State<TouKuiEntry>
        {
            public FreeRollState(TouKuiEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.GameData.isFreeGame = true;
                owner.btnGroup.gameObject.SetActive(false);
                owner.freeShowGroup.gameObject.SetActive(true);
                owner.freeTotalWinNum.text = owner.GameData.TotalFreeWin.ShortNumber().ShowRichText();
                owner.freeNum.text = (owner.GameData.CurrentFreeCount-1).ShowRichText();
                owner.winNum.text = 0.ShortNumber().ShowRichText();
                TouKui_Network.Instance.StartGame();
            }
        }
        #endregion
    }
}
