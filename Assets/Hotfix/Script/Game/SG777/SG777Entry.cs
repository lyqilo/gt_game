using LuaFramework;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Transform = UnityEngine.Transform;
using UnityEngine.EventSystems;

namespace Hotfix.SG777
{
    /// <summary>
    /// 游戏主入口
    /// </summary>
    public class SG777Entry : SingletonILEntity<SG777Entry>
    {
        public Data GameData { get; set; }

        public Transform MainContent;

        private Transform normalGame;
        public Transform RollContent;

        private Transform menu;
        private Transform buttomMenu;
        private TextMeshProUGUI chipNum;
        private TextMeshProUGUI allChipInfo;
        private Button reduceChipBtn;
        private Button addChipBtn;
        private Transform AutoOption;
        private Button closeAutoListBtn;
        private Button startState;
        private Button stopState;

        private Button closeAutoBtn;

        private Transform userInfo;
        private TextMeshProUGUI selfGold;

        private Transform Freestate;
        private TextMeshProUGUI FreestateNum;

        private Transform topMenu;
        private Button closeGame;
        private Transform settingList;
        private Button settingBtn;
        private Button showRuleBtn;

        private Transform FreeBonus;
        private Transform EnterFree;
        private TextMeshProUGUI EnterFreeNum;

        private Transform FreeResult;
        private TextMeshProUGUI FreeResultNum;

        private Transform rulePanel;
        private Transform settingPanel;
        private Transform resultPanel;
        private Transform miniGamePanel;
        private Transform Sounds;

        public Transform Icons;
        public Transform effectPool;

        HierarchicalStateMachine hsm;
        List<IState> states;
        bool isStopRoll;

        private float onDownTime;
        private bool isOnDownState;

        private Transform LineData;

        protected override void Awake()
        {
            base.Awake();
            DebugHelper.Log("----------OnAwake---------------");
            Screen.orientation = ScreenOrientation.Landscape;
            Screen.autorotateToLandscapeLeft = true;
            Screen.autorotateToLandscapeRight = true;
            Screen.autorotateToPortrait = false;
            Screen.autorotateToPortraitUpsideDown = false;
            GameData = new Data();
            gameObject.AddILComponent<SG777_Network>();
            gameObject.AddILComponent<SG777_Audio>();
            onDownTime = 0f;
            isOnDownState = false;
            isStopRoll = true;
            ILGameManager.Instance.GetGameSetPanel(transform.FindChildDepth("Main"));
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
            states.Add(new SmallState(this, hsm));
            states.Add(new AutoRollState(this, hsm));
            states.Add(new EnterFreeState(this, hsm));
            states.Add(new FreeRollState(this, hsm));
            states.Add(new FreeResultState(this, hsm));
            hsm.Init(states, nameof(IdleState));
            rulePanel.gameObject.AddILComponent<SG777_Rule>();
            settingPanel.gameObject.AddILComponent<SG777_Set>();
            resultPanel.gameObject.AddILComponent<SG777_Result>();
            miniGamePanel.gameObject.AddILComponent<SG777_SmallGame>();
            RollContent.gameObject.AddILComponent<SG777_Roll>();
            LineData.gameObject.AddILComponent<SG777_Line>();
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            RemoveEvent();
        }

        protected override void Update()
        {
            base.Update();
            hsm?.Update();
            if (isOnDownState)
            {
                onDownTime += Time.deltaTime;
                if (onDownTime >= 1.5f)
                {
                    isOnDownState = false;
                    OpenAutoListCall();
                }
            }
        }

        protected override void AddEvent()
        {
            SG777_Event.RefreshGold += SG777_Event_RefreshGold;
            SG777_Event.OnGetSceneData += SG777_Event_OnGetSceneData;
            SG777_Event.ShowResultComplete += SG777_Event_ShowResultComplete;
            SG777_Event.OnChangeBet += SG777_Event_OnChangeBet;
            SG777_Event.RollPrepreaComplete += SG777_Event_RollPrepreaComplete;
            SG777_Event.RollComplete += SG777_Event_RollComplete;
            SG777_Event.RollFailed += SG777_Event_RollFailed;
            SG777_Event.ShowResult += SG777_Event_ShowResult;

            HotfixActionHelper.LoadGameRule += ShowRulePanel;
            HotfixActionHelper.LoadGameExit += CloseGameCall;
            HotfixActionHelper.LoadGameMusic += GameMusicControl;
            HotfixActionHelper.LoadGameSound += GameSoundControl;
        }

        protected override void RemoveEvent()
        {
            SG777_Event.RefreshGold -= SG777_Event_RefreshGold;
            SG777_Event.OnGetSceneData -= SG777_Event_OnGetSceneData;
            SG777_Event.ShowResultComplete -= SG777_Event_ShowResultComplete;
            SG777_Event.OnChangeBet -= SG777_Event_OnChangeBet;
            SG777_Event.RollPrepreaComplete -= SG777_Event_RollPrepreaComplete;
            SG777_Event.RollComplete -= SG777_Event_RollComplete;
            SG777_Event.RollFailed -= SG777_Event_RollFailed;
            SG777_Event.ShowResult -= SG777_Event_ShowResult;

            HotfixActionHelper.LoadGameRule -= ShowRulePanel;
            HotfixActionHelper.LoadGameExit -= CloseGameCall;
            HotfixActionHelper.LoadGameMusic -= GameMusicControl;
            HotfixActionHelper.LoadGameSound -= GameSoundControl;
        }

        protected override void FindComponent()
        {
            MainContent = transform.FindChildDepth("Main/Content");
            normalGame = MainContent.FindChildDepth("NormalGame");
            RollContent = normalGame.Find("ViewPort/Scroll"); //转动区域

            menu = MainContent.FindChildDepth("Menu"); //总菜单
            buttomMenu = menu.FindChildDepth("ButtomMenu"); //下方
            chipNum = buttomMenu.FindChildDepth<TextMeshProUGUI>("chipInfo/stake/Text"); //单注
            allChipInfo = buttomMenu.FindChildDepth<TextMeshProUGUI>("allChipInfo/Text"); //单注
            reduceChipBtn = buttomMenu.FindChildDepth<Button>("chipInfo/stake/subBtn"); //减注
            addChipBtn = buttomMenu.FindChildDepth<Button>("chipInfo/stake/addBtn"); //加注
            AutoOption = buttomMenu.FindChildDepth("AutoOption");
            closeAutoListBtn = buttomMenu.FindChildDepth<Button>("AutoOption/mask"); //关闭选择
            startState = buttomMenu.FindChildDepth<Button>("startBtn"); //开始
            stopState = buttomMenu.FindChildDepth<Button>("stopBtn"); //急停
            closeAutoBtn = buttomMenu.FindChildDepth<Button>("AutoStopBtn"); //停止自动
            Freestate = buttomMenu.FindChildDepth("Freestate");
            FreestateNum = Freestate.FindChildDepth<TextMeshProUGUI>("Text");

            userInfo = buttomMenu.FindChildDepth("Playinfo");
            selfGold = userInfo.FindChildDepth<TextMeshProUGUI>("playerGold"); //自身金币

            topMenu = menu.FindChildDepth("TopMenu"); //下方
            closeGame = topMenu.FindChildDepth<Button>("HomeBtn");
            settingList = topMenu.FindChildDepth("SettingList");
            settingBtn = topMenu.FindChildDepth<Button>("SettingBtn");
            showRuleBtn = topMenu.FindChildDepth<Button>("RuleBtn");

            FreeBonus = MainContent.FindChildDepth("FreeBonus");
            EnterFree = FreeBonus.FindChildDepth("EnterFree");
            EnterFreeNum = EnterFree.FindChildDepth<TextMeshProUGUI>("FreeGameEnter/Text");

            FreeResult = FreeBonus.FindChildDepth("FreeResult");
            FreeResultNum = FreeResult.FindChildDepth<TextMeshProUGUI>("winInfo/Text");

            rulePanel = transform.FindChildDepth("RulePanel"); //规则界面
            settingPanel = transform.FindChildDepth("SettingPanel"); //设置界面
            resultPanel = transform.FindChildDepth("ResultPanel"); //结算界面
            miniGamePanel = transform.FindChildDepth("MiniGamePanel"); //结算界面
            Sounds = transform.FindChildDepth("Sound");
            Icons = transform.FindChildDepth("Icons");
            effectPool = transform.FindChildDepth("effectPool");

            LineData = this.transform.FindChildDepth("Main/Content/NormalGame/ViewPort/LineData");
        }

        private void AddListener()
        {
            reduceChipBtn.onClick.RemoveAllListeners();
            reduceChipBtn.onClick.Add(ReduceChipCall);

            addChipBtn.onClick.RemoveAllListeners();
            addChipBtn.onClick.Add(AddChipCall);

            EventTriggerHelper trigger = EventTriggerHelper.Get(startState.gameObject);
            trigger.onDown = OnBeginClick;
            trigger.onUp = OnEndClick;

            //showRuleBtn.onClick.RemoveAllListeners(); //显示规则
            //showRuleBtn.onClick.Add(ShowRulePanel);

            //closeGame.onClick.RemoveAllListeners();
            //closeGame.onClick.Add(CloseGameCall);

            closeAutoListBtn.onClick.RemoveAllListeners();
            closeAutoListBtn.onClick.Add(CloseAutoListCall);

            closeAutoBtn.onClick.RemoveAllListeners();
            closeAutoBtn.onClick.Add(StopAutoGame);


            for (int i = 0; i < AutoOption.FindChildDepth("Conent").childCount; i++)
            {
                int index = i;
                AutoOption.FindChildDepth("Conent").GetChild(i).GetComponent<Button>().onClick.RemoveAllListeners();
                AutoOption.FindChildDepth("Conent").GetChild(i).GetComponent<Button>().onClick.Add(() =>
                {
                    OnClickAutoCall(int.Parse(AutoOption.FindChildDepth("Conent").GetChild(index).name));
                });
            }
        }

        private void SG777_Event_RefreshGold(long gold)
        {
            GameData.myGold = gold;
            selfGold.text = GameData.myGold.ShortNumber().ShowRichText();
        }

        private void SG777_Event_OnGetSceneData()
        {
            hsm?.ChangeState(nameof(InitState));
        }

        private void SG777_Event_ShowResultComplete()
        {
            //TODO 收分做跳跃动画
            hsm?.ChangeState(nameof(CheckState));
            SG777_Event.DispatchRefreshGold((long) GameLocalMode.Instance.UserGameInfo.Gold);
        }

        private void SG777_Event_OnChangeBet()
        {
            chipNum.text = GameData.CurrentChip.ShortNumber().ShowRichText();
            allChipInfo.text = (GameData.CurrentChip * SG777_DataConfig.ALLLINECOUNT).ShortNumber().ShowRichText();
        }

        private void SG777_Event_RollComplete()
        {
            SG777_Event.DispatchShowResult();
        }

        private void SG777_Event_RollPrepreaComplete()
        {
            hsm?.ChangeState(nameof(WaitStopState));
        }

        private void SG777_Event_RollFailed()
        {
            hsm?.ChangeState(nameof(IdleState));
        }

        private void SG777_Event_ShowResult()
        {
            //winNum.text = ToolHelper.ShowRichText(GameData.ResultData.nWinGold);
        }

        public void FQGY_Event_ShowResultNum(int gold)
        {
            //winNum.text = ToolHelper.ShowRichText(gold);
        }

        public void FQGY_Event_ShowResultNum(bool b)
        {
            isStopRoll = b;
        }


        /// <summary>
        /// 加注
        /// </summary>
        private void AddChipCall()
        {
            //加注
            SG777_Audio.Instance.PlaySound(SG777_Audio.BTN);
            if (GameData.SceneData.nBet == null || GameData.SceneData.nBet.Count <= 0) return;
            GameData.CurrentChipIndex += 1;
            if (GameData.CurrentChipIndex >= GameData.SceneData.nBet.Count)
            {
                GameData.CurrentChipIndex = 0;
                //ToolHelper.PopSmallWindow("Bet max reached");
                //return;
            }

            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            SG777_Event.DispatchOnChangeBet();
        }

        /// <summary>
        /// 减注
        /// </summary>
        private void ReduceChipCall()
        {
            SG777_Audio.Instance.PlaySound(SG777_Audio.BTN);
            if (GameData.SceneData.nBet == null || GameData.SceneData.nBet.Count <= 0) return;
            GameData.CurrentChipIndex -= 1;
            if (GameData.CurrentChipIndex < 0)
            {
                GameData.CurrentChipIndex = 0;
                ToolHelper.PopSmallWindow("Bets have reached the minimum");
                return;
            }

            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            SG777_Event.DispatchOnChangeBet();
        }

        /// <summary>
        /// 设置最大下注
        /// </summary>
        private void SetMaxChipCall()
        {
            SG777_Audio.Instance.PlaySound(SG777_Audio.BTN);
            GameData.CurrentChipIndex = GameData.SceneData.nBet.Count - 1;
            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            SG777_Event.DispatchOnChangeBet();
        }


        private void OnEndClick(GameObject arg1, PointerEventData arg2)
        {
            DebugHelper.Log("=========OnEndClick==========");
            if (onDownTime >= 1.5f) return;
            isOnDownState = false;
            onDownTime = 0f;

            StartGameCall();
        }

        private void OnBeginClick(GameObject arg1, PointerEventData arg2)
        {
            DebugHelper.Log("isFreeGame==" + GameData.isFreeGame);
            if (GameData.isFreeGame)
            {
                isOnDownState = false;
                return;
            }

            isOnDownState = true;
            onDownTime = 0f;
        }

        //开始游戏
        private void StartGameCall()
        {
            if (GameData.isFreeGame) return;
            hsm?.ChangeState(nameof(NormalRollState));
        }

        private void StopGame()
        {
            SG777_Audio.Instance.PlaySound(SG777_Audio.BTN);
            startState.interactable = false;
            SG777_Event.DispatchStopRoll(true);
        }

        /// <summary>
        /// 显示规则界面
        /// </summary>
        private void ShowRulePanel()
        {
            SG777_Audio.Instance.PlaySound(SG777_Audio.BTN);
            rulePanel.gameObject.SetActive(true);
        }

        /// <summary>
        /// 退出游戏
        /// </summary>
        private void CloseGameCall()
        {
            SG777_Audio.Instance.PlaySound(SG777_Audio.BTN);
            if (!GameData.isFreeGame && !GameData.isSmallGame)
            {
                HotfixActionHelper.DispatchLeaveGame();
            }
            else
            {
                ToolHelper.PopSmallWindow("Cannot leave the game in special mode");
            }
        }

        private void GameMusicControl(bool isOpen)
        {
            if (isOpen)
            {
                SG777_Audio.Instance.ResetMusic();
            }
            else
            {
                SG777_Audio.Instance.MuteMusic();
            }
        }

        private void GameSoundControl(bool isOpen)
        {
            if (isOpen)
            {
                SG777_Audio.Instance.ResetSound();
            }
            else
            {
                SG777_Audio.Instance.MuteSound();
            }
        }


        /// <summary>
        /// 打开自动列表
        /// </summary>
        private void OpenAutoListCall()
        {
            SG777_Audio.Instance.PlaySound(SG777_Audio.BTN);
            AutoOption.gameObject.SetActive(true);
        }

        /// <summary>
        /// 关闭自动列表
        /// </summary>
        private void CloseAutoListCall()
        {
            SG777_Audio.Instance.PlaySound(SG777_Audio.BTN);
            AutoOption.gameObject.SetActive(false);
            //OnClickAutoCall(100000);
        }

        /// <summary>
        /// 停止自动旋转
        /// </summary>
        private void StopAutoGame()
        {
            GameData.isAutoGame = false;
            hsm?.ChangeState(nameof(IdleState));
        }

        /// <summary>
        /// 点击自动开始
        /// </summary>
        /// <param name="state"></param>
        private void OnClickAutoCall(int num)
        {
            DebugHelper.Log("OnClickAutoCall====" + num);
            //点击自动开始
            SG777_Audio.Instance.PlaySound(SG777_Audio.BTN);
            closeAutoBtn.gameObject.SetActive(true);
            GameData.CurrentAutoCount = num;
            if (num >= 1000)
            {
                closeAutoBtn.transform.FindChildDepth("Image").gameObject.SetActive(true);
                closeAutoBtn.transform.FindChildDepth("Text").gameObject.SetActive(false);
            }
            else
            {
                closeAutoBtn.transform.FindChildDepth("Image").gameObject.SetActive(false);
                closeAutoBtn.transform.FindChildDepth("Text").gameObject.SetActive(true);
            }

            hsm?.ChangeState(nameof(AutoRollState));
            GameData.isAutoGame = true;
        }

        #region 状态机

        /// <summary>
        /// 待机状态
        /// </summary>
        private class IdleState : State<SG777Entry>
        {
            public IdleState(SG777Entry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.Freestate.gameObject.SetActive(false);
                owner.GameData.CurrentAutoCount = 0;
                owner.GameData.CurrentFreeCount = 0;
                owner.closeAutoBtn.gameObject.SetActive(false);
                owner.startState.interactable = true;
                owner.addChipBtn.interactable = true;
                owner.reduceChipBtn.interactable = true;
                owner.closeGame.interactable = true;
                owner.showRuleBtn.interactable = true;
                owner.settingBtn.interactable = true;
                owner.GameData.isFreeGame = false;
                owner.GameData.isSmallGame = false;
            }
        }

        /// <summary>
        /// 初始化状态
        /// </summary>
        private class InitState : State<SG777Entry>
        {
            public InitState(SG777Entry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            bool isComplete;

            public override void OnEnter()
            {
                base.OnEnter();
                DebugHelper.Log("-------------场景消息返回---------");
                isComplete = false;
            }

            public override void Update()
            {
                base.Update();
                if (isComplete) return;
                isComplete = true;
                DebugHelper.Log(LitJson.JsonMapper.ToJson(owner.GameData.SceneData));

                SG777_Event.DispatchRefreshGold((long) GameLocalMode.Instance.UserGameInfo.Gold);
                if (owner.GameData.SceneData.nCurrenBet != 0)
                {
                    owner.GameData.CurrentChipIndex = owner.GameData.SceneData.nBet.FindListIndex(delegate(int match)
                    {
                        return match == owner.GameData.SceneData.nCurrenBet;
                    });
                }
                else
                {
                    owner.GameData.CurrentChipIndex = 0;
                }
                if (owner.GameData.SceneData.nFreeCount <= 0)
                {
                    owner.GameData.CurrentChipIndex = GameLocalMode.Instance.UserGameInfo.Gold.CheckNear(owner.GameData.SceneData.nBet);
                }
                owner.GameData.CurrentChip = owner.GameData.SceneData.nBet[owner.GameData.CurrentChipIndex];
                SG777_Event.DispatchOnChangeBet();
                owner.AddListener();

                if (owner.GameData.SceneData.nBellNum != 0)
                {
                    hsm?.ChangeState(nameof(SmallState));
                }
                else if (owner.GameData.SceneData.nFreeCount > 0)
                {
                    owner.GameData.CurrentFreeCount = owner.GameData.SceneData.nFreeCount;
                    SG777_Audio.Instance.PlayBGM(SG777_Audio.FreeBGM);
                    hsm?.ChangeState(nameof(FreeRollState));
                }
                else
                {
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }

        /// <summary>
        /// 检查状态
        /// </summary>
        private class CheckState : State<SG777Entry>
        {
            public CheckState(SG777Entry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                if (owner.GameData.ResultData == null)
                {
                    if (owner.GameData.SceneData.nFreeCount > 0)
                    {
                        owner.GameData.CurrentFreeCount = owner.GameData.SceneData.nFreeCount;
                        SG777_Audio.Instance.PlayBGM(SG777_Audio.FreeBGM);
                        hsm?.ChangeState(nameof(FreeRollState));
                        return;
                    }

                    hsm?.ChangeState(nameof(IdleState));
                    return;
                }

                if (owner.GameData.isSmallGame == false && owner.GameData.ResultData.nSmallGameCount > 0)
                {
                    hsm?.ChangeState(nameof(SmallState));
                    return;
                }

                if (owner.GameData.isFreeGame) //如果在免费中
                {
                    owner.GameData.CurrentFreeCount--;
                    if (owner.GameData.CurrentFreeCount < 0) //判断免费次数
                    {
                        hsm?.ChangeState(nameof(FreeResultState));
                        return;
                    }

                    hsm?.ChangeState(nameof(FreeRollState));
                    return;
                }

                if (owner.GameData.ResultData.nFreeCount > 0) //如果不在免费，但有免费次数，进入免费模式
                {
                    hsm?.ChangeState(nameof(EnterFreeState));
                    return;
                }

                if (owner.GameData.isAutoGame) //不在免费，自动模式下
                {
                    if (owner.GameData.CurrentAutoCount < 1000)
                    {
                        owner.GameData.CurrentAutoCount--;
                    }

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
        /// 正常
        /// </summary>
        private class NormalRollState : State<SG777Entry>
        {
            public NormalRollState(SG777Entry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();

                if (!owner.isStopRoll)
                {
                    return;
                }

                owner.Freestate.gameObject.SetActive(false);
                owner.closeAutoBtn.gameObject.SetActive(false);
                owner.startState.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.CloseAutoListCall();
                SG777_Network.Instance.StartGame();
                SG777_Audio.Instance.PlaySound(SG777_Audio.Run);
                owner.FQGY_Event_ShowResultNum(0);
            }
        }

        /// <summary>
        /// 正常
        /// </summary>
        private class SmallState : State<SG777Entry>
        {
            public SmallState(SG777Entry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.GameData.isSmallGame = true;
                SG777_Audio.Instance.PlayBGM(SG777_Audio.SMBGM);
                SG777_Event.DispatchEnterSmallGame();
            }
        }

        private class WaitStopState : State<SG777Entry>
        {
            public WaitStopState(SG777Entry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                //owner.stopState.interactable = true;
            }
        }

        /// <summary>
        /// 自动
        /// </summary>
        private class AutoRollState : State<SG777Entry>
        {
            public AutoRollState(SG777Entry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                if (owner.GameData.CurrentAutoCount < 1000)
                {
                    owner.closeAutoBtn.transform.FindChildDepth<TextMeshProUGUI>("Text").text =
                        owner.GameData.CurrentAutoCount.ShowRichText();
                }

                owner.Freestate.gameObject.SetActive(false);
                owner.closeAutoBtn.gameObject.SetActive(true);
                owner.startState.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.AutoOption.gameObject.SetActive(false);
                if (!owner.isStopRoll)
                {
                    return;
                }

                SG777_Audio.Instance.PlaySound(SG777_Audio.Run);
                SG777_Network.Instance.StartGame();
            }

            public override void Update()
            {
                base.Update();
            }
        }

        /// <summary>
        /// 进入免费
        /// </summary>
        private class EnterFreeState : State<SG777Entry>
        {
            bool isEnterFreeGame = false;
            float _time = 0f;

            public EnterFreeState(SG777Entry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.Freestate.gameObject.SetActive(true);
                owner.closeAutoBtn.gameObject.SetActive(false);
                owner.GameData.isFreeGame = true;
                isEnterFreeGame = true;
                _time = 0f;
                owner.GameData.TotalFreeWin = 0;
                owner.GameData.CurrentFreeCount = owner.GameData.ResultData.nFreeCount;
                owner.EnterFree.gameObject.SetActive(true);
                owner.EnterFreeNum.text = owner.GameData.CurrentFreeCount.ShowRichText();
                SG777_Audio.Instance.PlayBGM(SG777_Audio.FreeBGM);
            }

            public override void Update()
            {
                base.Update();
                if (isEnterFreeGame)
                {
                    _time += Time.deltaTime;
                    if (_time >= 1.5f)
                    {
                        isEnterFreeGame = false;
                        _time = 0;
                        owner.EnterFree.gameObject.SetActive(false);
                        hsm?.ChangeState(nameof(CheckState));
                    }
                }
            }
        }

        /// <summary>
        /// 免费
        /// </summary>
        private class FreeRollState : State<SG777Entry>
        {
            public FreeRollState(SG777Entry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.FreestateNum.text = owner.GameData.CurrentFreeCount.ShowRichText();
                owner.startState.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.AutoOption.gameObject.SetActive(false);
                owner.Freestate.gameObject.SetActive(true);
                owner.GameData.isFreeGame = true;
                SG777_Network.Instance.StartGame();
            }

            public override void Update()
            {
                base.Update();
            }
        }

        /// <summary>
        /// 免费结算
        /// </summary>
        private class FreeResultState : State<SG777Entry>
        {
            float _time = 0f;
            bool isFreeResultGame;

            public FreeResultState(SG777Entry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                _time = 0f;
                isFreeResultGame = true;
                owner.GameData.isFreeGame = false;
                //owner.FreeResult.gameObject.SetActive(true);
            }

            public override void Update()
            {
                base.Update();
                if (isFreeResultGame)
                {
                    _time += Time.deltaTime;
                    if (_time >= 1.5f)
                    {
                        isFreeResultGame = false;
                        _time = 0f;
                        OnClickCloseFreeResult();
                    }
                }
            }

            private void OnClickCloseFreeResult()
            {
                SG777Entry.Instance.GameData.TotalFreeWin = 0;
                SG777_Audio.Instance.PlayBGM();
                hsm?.ChangeState(nameof(CheckState));
            }
        }

        #endregion
    }
}