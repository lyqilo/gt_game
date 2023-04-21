

using DragonBones;
using LuaFramework;
using System.Collections.Generic;
using System.Collections;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Transform = UnityEngine.Transform;
using UnityEngine.EventSystems;
using System;

namespace Hotfix.FQGY
{
    /// <summary>
    /// 游戏主入口
    /// </summary>
    public class FQGYEntry : SingletonILEntity<FQGYEntry>
    {
        public Data GameData { get; set; }

        public Transform MainContent;

        private Transform normalGame;
        public Transform RollContent;
        private Transform freeState;

        private Transform menu;
        private Transform buttomMenu;
        public TextMeshProUGUI winNum;
        private Text chipNum;
        private Button reduceChipBtn;
        private Button addChipBtn;
        private Transform freeInfo;
        private TextMeshProUGUI freeInfoText;
        private Button maxChipBtn;
        private Transform AutoOption;
        private Button autoMode;
        private Button hangUPMode;
        private Button closeAutoListBtn;
        private Button startState;
        private Button stopState;
        private Button closeAutoBtn;
        private Button closehangUPBtn;

        private Transform topMenu;
        private Button closeGame;
        private Transform settingList;
        private Button settingBtn;
        private Button showRuleBtn;
        private Transform userInfo;
        private Text selfGold;
        private Transform BonusInfo;
        private Transform bigBonus;
        private Transform smallBonus;
        private TextMeshProUGUI bonusNum;
        private Button AwardBtn;

        private Transform FreeBonus;
        private Transform EnterFree;
        private TextMeshProUGUI EnterFreeNum;
        private Button EnterFreeBtn;

        private Transform FreeResult;
        private TextMeshProUGUI FreeResultNum;
        private Button FreeSureBtn;

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
            gameObject.AddILComponent<FQGY_Network>();
            gameObject.AddILComponent<FQGY_Audio>();
            onDownTime = 0f;
            isOnDownState = false;
            isStopRoll = true;
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

            settingPanel.gameObject.AddILComponent<FQGY_Set>();
            rulePanel.gameObject.AddILComponent<FQGY_Rule>();
            resultPanel.gameObject.AddILComponent<FQGY_Result>();
            miniGamePanel.gameObject.AddILComponent<FQGY_MiniGame>();
            RollContent.gameObject.AddILComponent<FQGY_Roll>();

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
                if (onDownTime>=1.5f)
                {
                    isOnDownState = false;
                    OpenAutoListCall();
                }
            }
        }

        protected override void AddEvent()
        {
            FQGY_Event.RefreshGold += FQGY_Event_RefreshGold;
            FQGY_Event.OnGetSceneData += FQGY_Event_OnGetSceneData;
            FQGY_Event.ShowResultComplete += FQGY_Event_ShowResultComplete;
            FQGY_Event.OnChangeBet += FQGY_Event_OnChangeBet;
            FQGY_Event.RollPrepreaComplete += FQGY_Event_RollPrepreaComplete;
            FQGY_Event.RollComplete += FQGY_Event_RollComplete;
            FQGY_Event.RollFailed += FQGY_Event_RollFailed;
            FQGY_Event.ShowResult += FQGY_Event_ShowResult;
        }

        protected override void RemoveEvent()
        {
            FQGY_Event.RefreshGold -= FQGY_Event_RefreshGold;
            FQGY_Event.OnGetSceneData -= FQGY_Event_OnGetSceneData;
            FQGY_Event.ShowResultComplete -= FQGY_Event_ShowResultComplete;
            FQGY_Event.OnChangeBet -= FQGY_Event_OnChangeBet;
            FQGY_Event.RollPrepreaComplete -= FQGY_Event_RollPrepreaComplete;
            FQGY_Event.RollComplete -= FQGY_Event_RollComplete;
            FQGY_Event.RollFailed -= FQGY_Event_RollFailed;
            FQGY_Event.ShowResult -= FQGY_Event_ShowResult;
        }

        protected override void FindComponent()
        {
            MainContent = transform.FindChildDepth("Main/Content");
            normalGame = MainContent.FindChildDepth("NormalGame");
            RollContent = normalGame.Find("ViewPort/Scroll"); //转动区域
            freeState = normalGame.FindChildDepth("ViewPort/FreeState");//免费显示

            menu = MainContent.FindChildDepth("Menu");//总菜单
            buttomMenu = menu.FindChildDepth("ButtomMenu");//下方
            winNum = buttomMenu.FindChildDepth<TextMeshProUGUI>("winInfo/Text");//获得金币
            chipNum= buttomMenu.FindChildDepth<Text>("chipInfo/stake/Text");//单注
            reduceChipBtn= buttomMenu.FindChildDepth<Button>("chipInfo/stake/subBtn");//减注
            addChipBtn = buttomMenu.FindChildDepth<Button>("chipInfo/stake/addBtn");//加注
            freeInfo = buttomMenu.FindChildDepth("FreeInfo");//免费
            freeInfoText = freeInfo.FindChildDepth<TextMeshProUGUI>("Free_Text");//免费次数
            maxChipBtn= buttomMenu.FindChildDepth<Button>("MaxBetBtn");//最大下注
            AutoOption = buttomMenu.FindChildDepth("AutoOption");
            autoMode = buttomMenu.FindChildDepth<Button>("AutoOption/Button0");//自动
            hangUPMode= buttomMenu.FindChildDepth<Button>("AutoOption/Button1");//挂机
            closeAutoListBtn = buttomMenu.FindChildDepth<Button>("AutoOption/mask");//关闭选择
            startState = buttomMenu.FindChildDepth<Button>("startBtn");//开始
            stopState = buttomMenu.FindChildDepth<Button>("stopBtn");//急停
            closeAutoBtn = buttomMenu.FindChildDepth<Button>("semiAutoStopBtn");//停止自动
            closehangUPBtn = buttomMenu.FindChildDepth<Button>("fullAutoStopBtn");//停止挂机

            topMenu = menu.FindChildDepth("TopMenu");//下方
            closeGame = topMenu.FindChildDepth<Button>("HomeBtn");
            settingList = topMenu.FindChildDepth("SettingList");
            settingBtn = topMenu.FindChildDepth<Button>("SettingBtn");
            showRuleBtn = topMenu.FindChildDepth<Button>("RuleBtn");
            userInfo = topMenu.FindChildDepth("Playinfo");
            selfGold = userInfo.FindChildDepth<Text>("playerGold"); //自身金币
            BonusInfo = topMenu.FindChildDepth("BonusInfo");
            bigBonus = BonusInfo.FindChildDepth("bigBonus");
            smallBonus = BonusInfo.FindChildDepth("smallBonus");
            bonusNum = BonusInfo.FindChildDepth<TextMeshProUGUI>("Text");
            AwardBtn = topMenu.FindChildDepth<Button>("AwardBtn");

            FreeBonus = MainContent.FindChildDepth("FreeBonus");
            EnterFree = FreeBonus.FindChildDepth("Content/EnterFree");
            EnterFreeNum = EnterFree.FindChildDepth<TextMeshProUGUI>("FreeGameEnter/Text");
            EnterFreeBtn = EnterFree.FindChildDepth<Button>("FreeGameEnter/Btn");

            FreeResult = FreeBonus.FindChildDepth("Content/FreeResult");
            FreeResultNum = FreeResult.FindChildDepth<TextMeshProUGUI>("FreeGameFinish/Text");
            FreeSureBtn = FreeResult.FindChildDepth<Button>("FreeGameFinish/Btn");

            rulePanel = transform.FindChildDepth("RulePanel"); //规则界面
            settingPanel = transform.FindChildDepth("SettingPanel"); //设置界面
            resultPanel = transform.FindChildDepth("ResultPanel");//结算界面
            miniGamePanel = transform.FindChildDepth("MiniGamePanel");//结算界面
            Sounds = transform.FindChildDepth("Sound");
            Icons = transform.FindChildDepth("Icons");
            effectPool = transform.FindChildDepth("effectPool");
        }

        private void AddListener()
        {
            reduceChipBtn.onClick.RemoveAllListeners();
            reduceChipBtn.onClick.Add(ReduceChipCall);

            addChipBtn.onClick.RemoveAllListeners();
            addChipBtn.onClick.Add(AddChipCall);

            maxChipBtn.onClick.RemoveAllListeners();
            maxChipBtn.onClick.Add(SetMaxChipCall);

            EventTriggerHelper trigger = EventTriggerHelper.Get(startState.gameObject);
            trigger.onDown = OnBeginClick;
            trigger.onUp = OnEndClick;

            showRuleBtn.onClick.RemoveAllListeners(); //显示规则
            showRuleBtn.onClick.Add(ShowRulePanel);

            closeGame.onClick.RemoveAllListeners();
            closeGame.onClick.Add(CloseGameCall);

            closeAutoListBtn.onClick.RemoveAllListeners();
            closeAutoListBtn.onClick.Add(CloseAutoListCall);

            autoMode.onClick.RemoveAllListeners();
            autoMode.onClick.Add(()=> 
            {
                OnClickAutoCall(0);
            });

            hangUPMode.onClick.RemoveAllListeners();
            hangUPMode.onClick.Add(()=> 
            {
                OnClickAutoCall(1);
            });

            closeAutoBtn.onClick.RemoveAllListeners();
            closeAutoBtn.onClick.Add(StopAutoGame);

            closehangUPBtn.onClick.RemoveAllListeners();
            closehangUPBtn.onClick.Add(StopAutoGame);

        }

        private void FQGY_Event_RefreshGold(long gold)
        {
            GameData.myGold = gold;
            selfGold.text = $"{GameData.myGold}";
        }

        private void FQGY_Event_OnGetSceneData()
        {
            hsm?.ChangeState(nameof(InitState));
        }

        private void FQGY_Event_ShowResultComplete()
        {
            //TODO 收分做跳跃动画
            hsm?.ChangeState(nameof(CheckState));
            FQGY_Event.DispatchRefreshGold((long)GameLocalMode.Instance.UserGameInfo.Gold);
        }

        private void FQGY_Event_OnChangeBet()
        {
            chipNum.text = (GameData.CurrentChip*FQGY_DataConfig.ALLLINECOUNT).ToString();
        }

        private void FQGY_Event_RollComplete()
        {
            FQGY_Event.DispatchShowResult();
        }

        private void FQGY_Event_RollPrepreaComplete()
        {
            hsm?.ChangeState(nameof(WaitStopState));
        }

        private void FQGY_Event_RollFailed()
        {
            hsm?.ChangeState(nameof(IdleState));
        }

        private void FQGY_Event_ShowResult()
        {
           winNum.text = ToolHelper.ShowRichText(GameData.ResultData.nWinGold);
        }

        public void FQGY_Event_ShowResultNum(int gold)
        {
           winNum.text = ToolHelper.ShowRichText(gold);
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
            FQGY_Audio.Instance.PlaySound(FQGY_Audio.BTN);
            if (GameData.SceneData.nBet == null || GameData.SceneData.nBet.Count <= 0) return;
            GameData.CurrentChipIndex += 1;
            if (GameData.CurrentChipIndex >= GameData.SceneData.nBetCount)
            {
                GameData.CurrentChipIndex = GameData.SceneData.nBetCount - 1;
                ToolHelper.PopSmallWindow("Bet max reached");
                return;
            }
            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            FQGY_Event.DispatchOnChangeBet();
        }

        /// <summary>
        /// 减注
        /// </summary>
        private void ReduceChipCall()
        {
            FQGY_Audio.Instance.PlaySound(FQGY_Audio.BTN);
            if (GameData.SceneData.nBet == null || GameData.SceneData.nBet.Count <= 0) return;
            GameData.CurrentChipIndex -= 1;
            if (GameData.CurrentChipIndex < 0)
            {
                GameData.CurrentChipIndex = 0;
                ToolHelper.PopSmallWindow("Bets have reached the minimum");
                return;
            }
            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            FQGY_Event.DispatchOnChangeBet();
        }

        /// <summary>
        /// 设置最大下注
        /// </summary>
        private void SetMaxChipCall()
        {
            FQGY_Audio.Instance.PlaySound(FQGY_Audio.BTN);
            GameData.CurrentChipIndex = GameData.SceneData.nBetCount - 1;
            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            FQGY_Event.DispatchOnChangeBet();
        }

        private void OnEndClick(GameObject arg1, PointerEventData arg2)
        {
            if (onDownTime>=1.5f)  return;
            isOnDownState = false;
            onDownTime = 0f;
            StartGameCall();
        }

        private void OnBeginClick(GameObject arg1, PointerEventData arg2)
        {
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
            FQGY_Audio.Instance.PlaySound(FQGY_Audio.BTN);
            startState.interactable = false;
            autoMode.interactable = false;
            FQGY_Event.DispatchStopRoll(true);
        }
        /// <summary>
        /// 显示规则界面
        /// </summary>
        private void ShowRulePanel()
        {
            FQGY_Audio.Instance.PlaySound(FQGY_Audio.BTN);
            rulePanel.gameObject.SetActive(true);
        }

        /// <summary>
        /// 退出游戏
        /// </summary>
        private void CloseGameCall()
        {
            FQGY_Audio.Instance.PlaySound(FQGY_Audio.BTN);
            if (!GameData.isFreeGame && GameData.ResultData.nSmallGameCount <= 0)
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
            FQGY_Audio.Instance.PlaySound(FQGY_Audio.BTN);
            AutoOption.gameObject.SetActive(true);
        }

        /// <summary>
        /// 关闭自动列表
        /// </summary>
        private void CloseAutoListCall()
        {
            FQGY_Audio.Instance.PlaySound(FQGY_Audio.BTN);
            AutoOption.gameObject.SetActive(false);
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
        private void OnClickAutoCall(int state)
        {
            //点击自动开始
            FQGY_Audio.Instance.PlaySound(FQGY_Audio.BTN);
            if (state==0)
            {
                closeAutoBtn.gameObject.SetActive(true);
                closehangUPBtn.gameObject.SetActive(false);
            }
            else
            {
                closeAutoBtn.gameObject.SetActive(false);
                closehangUPBtn.gameObject.SetActive(true);
            }
            GameData.CurrentAutoCount = 100000;
            hsm?.ChangeState(nameof(AutoRollState));
            GameData.isAutoGame = true;
        }

        #region 状态机
        /// <summary>
        /// 待机状态
        /// </summary>
        private class IdleState : State<FQGYEntry>
        {
            public IdleState(FQGYEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.GameData.CurrentAutoCount = 0;
                owner.GameData.CurrentFreeCount = 0;
                owner.closeAutoBtn.gameObject.SetActive(false);
                owner.closehangUPBtn.gameObject.SetActive(false);
                owner.startState.interactable = true;
                owner.addChipBtn.interactable = true;
                owner.reduceChipBtn.interactable = true;
                owner.maxChipBtn.interactable = true;
                owner.closeGame.interactable = true;
                owner.showRuleBtn.interactable = true;
                owner.settingBtn.interactable = true;
                owner.freeState.gameObject.SetActive(false);
                owner.freeInfo.gameObject.SetActive(false);
                owner.freeInfoText.text = ToolHelper.ShowRichText(0);//免费次数
            }
        }
        /// <summary>
        /// 初始化状态
        /// </summary>
        private class InitState : State<FQGYEntry>
        {
            public InitState(FQGYEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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

                FQGY_Event.DispatchRefreshGold((long)GameLocalMode.Instance.UserGameInfo.Gold);
                if (owner.GameData.SceneData.nCurrenBet != 0)
                {
                   owner.GameData.CurrentChipIndex= owner.GameData.SceneData.nBet.FindListIndex(delegate (int match)
                    {
                        return match == owner.GameData.SceneData.nCurrenBet;
                    });
                }
                else
                {
                    owner.GameData.CurrentChipIndex = 0;
                }
                owner.GameData.CurrentChip = owner.GameData.SceneData.nBet[owner.GameData.CurrentChipIndex];
                FQGY_Event.DispatchOnChangeBet();
                owner.winNum.text = ToolHelper.ShowRichText(0); ;
                owner.AddListener();


                if (owner.GameData.SceneData.nSmallGameCount != 0)
                {
                    hsm?.ChangeState(nameof(SmallState));

                }
                else if (owner.GameData.SceneData.nFreeCount > 0)
                {
                    owner.GameData.CurrentFreeCount = owner.GameData.SceneData.nFreeCount;
                    FQGY_Audio.Instance.PlayBGM(FQGY_Audio.FreeBGM);
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
        private class CheckState : State<FQGYEntry>
        {
            public CheckState(FQGYEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                if (owner.GameData.isSmallGame==false && owner.GameData.ResultData.nSmallGameCount>0)
                {
                    hsm?.ChangeState(nameof(SmallState));
                    return;
                }
                if (owner.GameData.isFreeGame)//如果在免费中
                {
                    owner.GameData.CurrentFreeCount--;
                    if (owner.GameData.CurrentFreeCount < 0)//判断免费次数
                    {
                        hsm?.ChangeState(nameof(FreeResultState));
                        return;
                    }
                    hsm?.ChangeState(nameof(FreeRollState));
                    return;
                }

                if (owner.GameData.ResultData.nFreeCount > 0)//如果不在免费，但有免费次数，进入免费模式
                {
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
        /// 正常
        /// </summary>
        private class NormalRollState : State<FQGYEntry>
        {
            public NormalRollState(FQGYEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                if (!owner.isStopRoll)
                    return;

                owner.startState.interactable=false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                //owner.autoMode.interactable = false;
                owner.CloseAutoListCall();
                FQGY_Network.Instance.StartGame();
                FQGY_Audio.Instance.PlaySound(FQGY_Audio.Run);
                owner.FQGY_Event_ShowResultNum(0);
            }
        }

        /// <summary>
        /// 正常
        /// </summary>
        private class SmallState : State<FQGYEntry>
        {
            public SmallState(FQGYEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.GameData.isSmallGame = true;
                owner.miniGamePanel.gameObject.SetActive(true);
                owner.GameData.SmallGameData.smallGameCount = owner.GameData.ResultData.nSmallGameCount;
                FQGY_Event.DispatchEnterSmallGame();

            }
        }


        private class WaitStopState : State<FQGYEntry>
        {
            public WaitStopState(FQGYEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
        private class AutoRollState : State<FQGYEntry>
        {
            public AutoRollState(FQGYEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.startState.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.maxChipBtn.interactable = false;
                owner.closeGame.interactable = false;
                owner.showRuleBtn.interactable = false;
                owner.settingBtn.interactable = false;
                owner.AutoOption.gameObject.SetActive(false);
                FQGY_Audio.Instance.PlaySound(FQGY_Audio.Run);
                FQGY_Network.Instance.StartGame();
            }
            public override void Update()
            {
                base.Update();
            }
        }
        /// <summary>
        /// 进入免费
        /// </summary>
        private class EnterFreeState : State<FQGYEntry>
        {
            bool isEnterFreeGame = false;
            float _time = 0f;
            public EnterFreeState(FQGYEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.GameData.isFreeGame = true;
                isEnterFreeGame = true;
                _time = 0f;
                owner.GameData.TotalFreeWin = 0;
                owner.GameData.CurrentFreeCount = owner.GameData.ResultData.nFreeCount;
                owner.EnterFree.gameObject.SetActive(true);
                owner.EnterFreeNum.text = ToolHelper.ShowRichText(owner.GameData.CurrentFreeCount);
                FQGY_Audio.Instance.PlayBGM(FQGY_Audio.FreeBGM);
                owner.EnterFreeBtn.onClick.RemoveAllListeners();
                owner.EnterFreeBtn.onClick.Add(()=> 
                {
                    isEnterFreeGame = false;
                    _time = 0;
                    FQGY_Audio.Instance.PlaySound(FQGY_Audio.BTN);
                    owner.EnterFree.gameObject.SetActive(false);
                    hsm?.ChangeState(nameof(CheckState));
                });
            }

            public override void Update()
            {
                base.Update();
                if (isEnterFreeGame)
                {
                    _time += Time.deltaTime;
                    if (_time>=3f)
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
        private class FreeRollState : State<FQGYEntry>
        {
            public FreeRollState(FQGYEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.startState.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.maxChipBtn.interactable = false;
                owner.closeGame.interactable = false;
                owner.showRuleBtn.interactable = false;
                owner.settingBtn.interactable = false;
                owner.AutoOption.gameObject.SetActive(false);
                owner.GameData.isFreeGame = true;
                owner.freeState.gameObject.SetActive(true);
                owner.freeInfo.gameObject.SetActive(true);
                owner.freeInfoText.text = ToolHelper.ShowRichText(owner.GameData.CurrentFreeCount);//免费次数
                FQGY_Network.Instance.StartGame();
            }
            public override void Update()
            {
                base.Update();
            }
        }
        /// <summary>
        /// 免费结算
        /// </summary>
        private class FreeResultState : State<FQGYEntry>
        {
            float _time = 0f;
            bool isFreeResultGame;
            public FreeResultState(FQGYEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                _time = 0f;
                isFreeResultGame = true;
                owner.GameData.isFreeGame = false;
                owner.FreeResult.gameObject.SetActive(true);
                owner.FreeResultNum.text= ToolHelper.ShowRichText(owner.GameData.TotalFreeWin);
                owner.FreeSureBtn.onClick.RemoveAllListeners();
                owner.FreeSureBtn.onClick.Add(()=> 
                {
                    isFreeResultGame = false;
                    _time = 0f;
                    OnClickCloseFreeResult();
                });
            }

            public override void Update()
            {
                base.Update();
                if (isFreeResultGame)
                {
                    _time += Time.deltaTime;
                    if (_time >= 3f)
                    {
                        isFreeResultGame = false;
                        _time = 0f;
                       OnClickCloseFreeResult();
                    }
                }
            }

            private void OnClickCloseFreeResult()
            {
                owner.freeState.gameObject.SetActive(false);
                owner.freeInfo.gameObject.SetActive(false);
                owner.freeInfoText.text = ToolHelper.ShowRichText(0);//免费次数
                FQGYEntry.Instance.GameData.TotalFreeWin = 0;
                FQGY_Audio.Instance.PlayBGM();
                hsm?.ChangeState(nameof(CheckState));
            }
        }
        #endregion
    }
}
