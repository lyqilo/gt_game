

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
using DG.Tweening;

namespace Hotfix.TJZ
{
    /// <summary>
    /// 游戏主入口
    /// </summary>
    public class TJZEntry : SingletonILEntity<TJZEntry>
    {
        public Data GameData { get; set; }

        public Transform MainContent;

        private Transform normalGame;
        public Transform RollContent;

        public Transform FreeBG;
        public Transform pillar;
        public Transform FreeDeng;
        public Transform FreeMZ;
        public Transform FreeChe;

        private Transform menu;
        private Transform buttomMenu;
        private Text chipNum;
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
        public Transform WinInfo;
        public TextMeshProUGUI WinInfoNum;
        private Transform Freestate;
        private TextMeshProUGUI FreestateNum;

        private Transform topMenu;
        private Transform JackPotInfo;
        private TextMeshProUGUI JackPotInfoNum;

        private Transform FreeBonus;
        private Transform EnterFree;
        private TextMeshProUGUI EnterFreeNum;

        private Transform FreeResult;
        private TextMeshProUGUI FreeResultNum;

        private Transform rulePanel;
        private Transform resultPanel;
        private Transform Sounds;

        public Transform Icons;
        public Transform effectPool;

        public Transform RERoll;

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
            gameObject.AddILComponent<TJZ_Network>();
            gameObject.AddILComponent<TJZ_Audio>();
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
            states.Add(new ReturnState(this, hsm));
            states.Add(new NormalRollState(this, hsm)); 
            states.Add(new AutoRollState(this, hsm));
            states.Add(new EnterFreeState(this, hsm));
            states.Add(new FreeRollState(this, hsm));
            states.Add(new FreeResultState(this, hsm));
            hsm.Init(states, nameof(IdleState));
            rulePanel.gameObject.AddILComponent<TJZ_Rule>();
            resultPanel.gameObject.AddILComponent<TJZ_Result>();
            RollContent.gameObject.AddILComponent<TJZ_Roll>();
            LineData.gameObject.AddILComponent<TJZ_Line>();
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
            TJZ_Event.RefreshGold += TJZ_Event_RefreshGold;
            TJZ_Event.OnGetSceneData += TJZ_Event_OnGetSceneData;
            TJZ_Event.ShowResultComplete += TJZ_Event_ShowResultComplete;
            TJZ_Event.OnChangeBet += TJZ_Event_OnChangeBet;
            TJZ_Event.OnChangeJackPot += TJZ_Event_OnChangeJackPot;
            TJZ_Event.RollPrepreaComplete += TJZ_Event_RollPrepreaComplete;
            TJZ_Event.RollComplete += TJZ_Event_RollComplete;
            TJZ_Event.RollFailed += TJZ_Event_RollFailed;
            TJZ_Event.ShowResult += TJZ_Event_ShowResult;
            TJZ_Event.StartRoll += TJZ_Event_ShowResultZero;

            HotfixActionHelper.LoadGameRule += ShowRulePanel;
            HotfixActionHelper.LoadGameExit += CloseGameCall;
            HotfixActionHelper.LoadGameMusic += GameMusicControl;
            HotfixActionHelper.LoadGameSound += GameSoundControl;
        }

        protected override void RemoveEvent()
        {
            TJZ_Event.RefreshGold -= TJZ_Event_RefreshGold;
            TJZ_Event.OnGetSceneData -= TJZ_Event_OnGetSceneData;
            TJZ_Event.ShowResultComplete -= TJZ_Event_ShowResultComplete;
            TJZ_Event.OnChangeBet -= TJZ_Event_OnChangeBet;
            TJZ_Event.OnChangeJackPot += TJZ_Event_OnChangeJackPot;
            TJZ_Event.RollPrepreaComplete -= TJZ_Event_RollPrepreaComplete;
            TJZ_Event.RollComplete -= TJZ_Event_RollComplete;
            TJZ_Event.RollFailed -= TJZ_Event_RollFailed;
            TJZ_Event.ShowResult -= TJZ_Event_ShowResult;
            TJZ_Event.StartRoll -= TJZ_Event_ShowResultZero;

            HotfixActionHelper.LoadGameRule -= ShowRulePanel;
            HotfixActionHelper.LoadGameExit -= CloseGameCall;
            HotfixActionHelper.LoadGameMusic -= GameMusicControl;
            HotfixActionHelper.LoadGameSound -= GameSoundControl;
        }

        protected override void FindComponent()
        {
            MainContent = transform.FindChildDepth("Main/Content");
            normalGame = MainContent.FindChildDepth("NormalGame");
            RollContent = normalGame.FindChildDepth("ViewPort/Scroll"); //转动区域
            RERoll = normalGame.FindChildDepth("ViewPort/RERoll");

            FreeBG= normalGame.FindChildDepth("FreeBG");
            pillar= FreeBG.FindChildDepth("pillar");
            FreeDeng = FreeBG.FindChildDepth("deng");
            FreeMZ = FreeBG.FindChildDepth("mz");
            FreeChe = FreeBG.FindChildDepth("che");

            menu = MainContent.FindChildDepth("Menu");//总菜单
            buttomMenu = menu.FindChildDepth("ButtomMenu");//下方
            chipNum= buttomMenu.FindChildDepth<Text>("chipInfo/stake/chip");//单注
            allChipInfo = buttomMenu.FindChildDepth<TextMeshProUGUI>("chipInfo/stake/allChip");//单注
            reduceChipBtn = buttomMenu.FindChildDepth<Button>("chipInfo/stake/subBtn");//减注
            addChipBtn = buttomMenu.FindChildDepth<Button>("chipInfo/stake/addBtn");//加注
            AutoOption = buttomMenu.FindChildDepth("AutoOption");
            closeAutoListBtn = buttomMenu.FindChildDepth<Button>("AutoOption/mask");//关闭选择
            startState = buttomMenu.FindChildDepth<Button>("startBtn");//开始
            stopState = buttomMenu.FindChildDepth<Button>("stopBtn");//急停
            closeAutoBtn = buttomMenu.FindChildDepth<Button>("AutoStopBtn");//停止自动
            Freestate = buttomMenu.FindChildDepth("Freestate");
            FreestateNum = Freestate.FindChildDepth<TextMeshProUGUI>("Text");
            userInfo = buttomMenu.FindChildDepth("Playinfo");
            selfGold = userInfo.FindChildDepth<TextMeshProUGUI>("playerGold"); //自身金币
            WinInfo = buttomMenu.FindChildDepth("winInfo");
            WinInfoNum = WinInfo.FindChildDepth<TextMeshProUGUI>("Text");
            WinInfoNum.text = 0.ShortNumber().ShowRichText();

            topMenu = menu.FindChildDepth("TopMenu");//下方
            JackPotInfo = topMenu.FindChildDepth("JackPotInfo");
            JackPotInfoNum = topMenu.FindChildDepth<TextMeshProUGUI>("Text");

            FreeBonus = MainContent.FindChildDepth("FreeBonus");
            EnterFree = FreeBonus.FindChildDepth("EnterFree");
            EnterFreeNum = EnterFree.FindChildDepth<TextMeshProUGUI>("FreeGameEnter/Text");

            FreeResult = FreeBonus.FindChildDepth("FreeResult");
            FreeResultNum = FreeResult.FindChildDepth<TextMeshProUGUI>("FreeGameOver/Text");

            rulePanel = transform.FindChildDepth("RulePanel"); //规则界面
            resultPanel = transform.FindChildDepth("ResultPanel");//结算界面
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

            closeAutoListBtn.onClick.RemoveAllListeners();
            closeAutoListBtn.onClick.Add(CloseAutoListCall);

            closeAutoBtn.onClick.RemoveAllListeners();
            closeAutoBtn.onClick.Add(StopAutoGame);

            for (int i = 0; i < AutoOption.FindChildDepth("Conent").childCount; i++)
            {
                int index = i;
                AutoOption.FindChildDepth("Conent").GetChild(i).GetComponent<Button>().onClick.RemoveAllListeners();
                AutoOption.FindChildDepth("Conent").GetChild(i).GetComponent<Button>().onClick.Add(()=> 
                {
                    OnClickAutoCall(int.Parse(AutoOption.FindChildDepth("Conent").GetChild(index).name));
                });
            }
        }

        private void TJZ_Event_RefreshGold(long gold)
        {
            GameData.myGold = gold;
            selfGold.text =GameData.myGold.ShortNumber().ShowRichText();
        }

        private void TJZ_Event_OnGetSceneData()
        {
            hsm?.ChangeState(nameof(InitState));
        }

        private void TJZ_Event_ShowResultComplete()
        {
            //TODO 收分做跳跃动画
            hsm?.ChangeState(nameof(CheckState));
            TJZ_Event.DispatchRefreshGold((long)GameLocalMode.Instance.UserGameInfo.Gold);
        }

        private void TJZ_Event_OnChangeBet()
        {
            // chipNum.text = $"(25linex{GameData.CurrentChip.ShortNumber()})";
            chipNum.text = $"";
            allChipInfo.text = (GameData.CurrentChip * TJZ_DataConfig.ALLLINECOUNT).ShortNumber().ShowRichText();
        }

        private void TJZ_Event_OnChangeJackPot()
        {
            JackPotInfoNum.text = GameData.JackPotNum.ShortNumber().ShowRichText();
        }

        private void TJZ_Event_RollComplete()
        {
            TJZ_Event.DispatchShowResult();
        }

        private void TJZ_Event_RollPrepreaComplete()
        {
            hsm?.ChangeState(nameof(WaitStopState));
        }

        private void TJZ_Event_RollFailed()
        {
            hsm?.ChangeState(nameof(IdleState));
        }

        private void TJZ_Event_ShowResult()
        {
            long winGold = 0;
            if (GameData.Return || GameData.ReturnNum > 0)
            {
                winGold = GameData.ReturnNum;
            }
            else
            {
                winGold = GameData.ResultData.nWinGold;
            }
            WinInfoNum.text = winGold.ShortNumber().ShowRichText();
        }

        private void TJZ_Event_ShowResultZero()
        {
            if (!GameData.Return)
            {
                WinInfoNum.text = 0.ShortNumber().ShowRichText();
            }
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
            TJZ_Audio.Instance.PlaySound(TJZ_Audio.XiaZhu);
            if (GameData.SceneData.nBet == null || GameData.SceneData.nBet.Count <= 0) return;
            GameData.CurrentChipIndex += 1;
            if (GameData.CurrentChipIndex >= GameData.SceneData.nBet.Count)
            {
                GameData.CurrentChipIndex = 0;
            }
            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            TJZ_Event.DispatchOnChangeBet();
        }

        /// <summary>
        /// 减注
        /// </summary>
        private void ReduceChipCall()
        {
            TJZ_Audio.Instance.PlaySound(TJZ_Audio.XiaZhu);
            if (GameData.SceneData.nBet == null || GameData.SceneData.nBet.Count <= 0) return;
            GameData.CurrentChipIndex -= 1;
            if (GameData.CurrentChipIndex < 0)
            {
                GameData.CurrentChipIndex = GameData.SceneData.nBet.Count-1;
            }
            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            TJZ_Event.DispatchOnChangeBet();
        }

        /// <summary>
        /// 设置最大下注
        /// </summary>
        private void SetMaxChipCall()
        {
            TJZ_Audio.Instance.PlaySound(TJZ_Audio.XiaZhu);
            GameData.CurrentChipIndex = GameData.SceneData.nBet.Count - 1;
            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            TJZ_Event.DispatchOnChangeBet();
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
            TJZ_Audio.Instance.PlaySound(TJZ_Audio.BTN);
            startState.interactable = false;
            TJZ_Event.DispatchStopRoll(true);
        }
        /// <summary>
        /// 显示规则界面
        /// </summary>
        private void ShowRulePanel()
        {
            TJZ_Audio.Instance.PlaySound(TJZ_Audio.BTN);
            rulePanel.gameObject.SetActive(true);
        }

        /// <summary>
        /// 退出游戏
        /// </summary>
        private void CloseGameCall()
        {
            TJZ_Audio.Instance.PlaySound(TJZ_Audio.BTN);
            if (GameData.ResultData==null)
            {
                HotfixActionHelper.DispatchLeaveGame();
                return;
            }
            if (!GameData.isFreeGame && !GameData.Return)
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
                TJZ_Audio.Instance.ResetMusic();
            }
            else
            {
                TJZ_Audio.Instance.MuteMusic();
            }
        }
        private void GameSoundControl(bool isOpen)
        {
            if (isOpen)
            {
                TJZ_Audio.Instance.ResetSound();
            }
            else
            {
                TJZ_Audio.Instance.MuteSound();
            }
        }

        /// <summary>
        /// 打开自动列表
        /// </summary>
        private void OpenAutoListCall()
        {
            TJZ_Audio.Instance.PlaySound(TJZ_Audio.BTN);
            AutoOption.gameObject.SetActive(true);
        }

        /// <summary>
        /// 关闭自动列表
        /// </summary>
        private void CloseAutoListCall()
        {
            TJZ_Audio.Instance.PlaySound(TJZ_Audio.BTN);
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
            //点击自动开始
            TJZ_Audio.Instance.PlaySound(TJZ_Audio.BTN);
            closeAutoBtn.gameObject.SetActive(true);
            GameData.CurrentAutoCount = num;
            if (num>=1000)
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
        private class IdleState : State<TJZEntry>
        {
            public IdleState(TJZEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.Freestate.gameObject.SetActive(false);
                owner.FreeResult.gameObject.SetActive(false);
                owner.GameData.CurrentAutoCount = 0;
                owner.GameData.CurrentFreeCount = 0;
                owner.closeAutoBtn.gameObject.SetActive(false);
                owner.startState.interactable = true;
                owner.addChipBtn.interactable = true;
                owner.reduceChipBtn.interactable = true;
                owner.GameData.isFreeGame = false;
            }
        }
        /// <summary>
        /// 初始化状态
        /// </summary>
        private class InitState : State<TJZEntry>
        {
            public InitState(TJZEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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

                TJZ_Event.DispatchRefreshGold((long)GameLocalMode.Instance.UserGameInfo.Gold);
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

                if (!owner.GameData.SceneData.nReturn && owner.GameData.SceneData.nFreeCount <= 0)
                {
                    owner.GameData.CurrentChipIndex = owner.GameData.myGold.CheckNear(owner.GameData.SceneData.nBet);
                }
                owner.GameData.CurrentChip = owner.GameData.SceneData.nBet[owner.GameData.CurrentChipIndex];
                TJZ_Event.DispatchOnChangeBet();
                owner.GameData.JackPotNum = owner.GameData.SceneData.AccuPool;
                TJZ_Event.DispatchOnChangeJackPot();
                owner.AddListener();

                if(owner.GameData.SceneData.nFreeCount > 0 || owner.GameData.SceneData.nCurUpProcess>0)
                {
                    for (int i = 0; i < owner.GameData.SceneData.nCurUpProcess; i++)
                    {
                        owner.pillar.GetChild(i).FindChildDepth("Image").gameObject.SetActive(true);
                    }
                    if (owner.GameData.SceneData.nCurUpProcess >= 3)
                    {
                        TJZEntry.Instance.FreeDeng.GetChild(0).gameObject.SetActive(true);
                    }
                    if (owner.GameData.SceneData.nCurUpProcess >= 6)
                    {
                        TJZ_Audio.Instance.PlaySound(TJZ_Audio.ShengJi);
                        TJZEntry.Instance.FreeMZ.GetChild(0).gameObject.SetActive(true);
                    }
                    if (TJZEntry.Instance.GameData.UpLevel >= 10)
                    {
                        TJZ_Audio.Instance.PlaySound(TJZ_Audio.ShengJi);
                        TJZEntry.Instance.FreeChe.GetChild(0).gameObject.SetActive(true);
                    }
                    owner.GameData.CurrentFreeCount = owner.GameData.SceneData.nFreeCount;
                    TJZ_Audio.Instance.PlayBGM(TJZ_Audio.FreeBGM);
                    hsm?.ChangeState(nameof(FreeRollState));
                }
                else if (owner.GameData.SceneData.nReturn)
                {
                    hsm?.ChangeState(nameof(ReturnState));
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
        private class CheckState : State<TJZEntry>
        {
            public CheckState(TJZEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                if (owner.GameData.ResultData.nReturn && owner.GameData.ResultData.nAddFreeCnt<=0)
                {
                    hsm?.ChangeState(nameof(ReturnState));
                    return;
                }
                else
                {
                    owner.GameData.ReturnNum = 0;
                    owner.GameData.Return = false;
                }
                if (owner.GameData.isFreeGame)//如果在免费中
                {
                    owner.GameData.CurrentFreeCount--;
                    if (owner.GameData.CurrentFreeCount < 0 )//判断免费次数
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
                    if (owner.GameData.CurrentAutoCount<1000)
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
        private class NormalRollState : State<TJZEntry>
        {
            public NormalRollState(TJZEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                owner.startState.interactable=false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.CloseAutoListCall();
                TJZ_Network.Instance.StartGame();
            }
        }


        private class WaitStopState : State<TJZEntry>
        {
            public WaitStopState(TJZEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
        private class AutoRollState : State<TJZEntry>
        {
            public AutoRollState(TJZEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                if (owner.GameData.CurrentAutoCount<1000)
                {
                    owner.closeAutoBtn.transform.FindChildDepth<TextMeshProUGUI>("Text").text = owner.GameData.CurrentAutoCount.ShowRichText();
                }
                owner.Freestate.gameObject.SetActive(false);
                owner.closeAutoBtn.gameObject.SetActive(true);
                owner.startState.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.AutoOption.gameObject.SetActive(false);
                if (!owner.isStopRoll)
                {
                    return;
                }
                TJZ_Network.Instance.StartGame();
            }
            public override void Update()
            {
                base.Update();
            }
        }

        /// <summary>
        /// 重转
        /// </summary>
        private class ReturnState : State<TJZEntry>
        {
            public ReturnState(TJZEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                if (owner.GameData.ResultData == null)
                {
                    TJZ_Network.Instance.StartGame();
                    return;
                }
                else
                {
                    owner.RERoll.gameObject.SetActive(true);
                    owner.GameData.Return = true;
                    for (int i = 0; i < owner.GameData.ResultData.cbIcon.Count; i++)
                    {
                        byte Icon = owner.GameData.ResultData.cbIcon[i];
                        if (Icon==10)
                        {
                            int hitIndex = i;
                            int row = hitIndex / 5;
                            int col = hitIndex % 5;
                            Transform hitTrans = owner.RERoll.GetChild(col).GetChild(row);
                            string iconName = TJZ_DataConfig.IconTable[Icon];
                            Transform images = owner.Icons.FindChildDepth(iconName);
                            hitTrans.GetChild(0).GetComponent<Image>().sprite= images.FindChildDepth<Image>("Image").sprite;
                            hitTrans.gameObject.SetActive(true);
                        }
                        if (owner.GameData.isFreeGame && owner.GameData.UpLevel>=3)
                        {
                            if (Icon == 12 || Icon==13 || Icon==14)
                            {
                                int hitIndex = i;
                                int row = hitIndex / 5;
                                int col = hitIndex % 5;
                                Transform hitTrans = owner.RERoll.GetChild(col).GetChild(row);
                                string iconName = TJZ_DataConfig.IconTable[Icon];
                                Transform images = owner.Icons.FindChildDepth(iconName);
                                hitTrans.GetChild(0).GetComponent<Image>().sprite = images.FindChildDepth<Image>("Image").sprite;
                                hitTrans.gameObject.SetActive(true);
                            }
                        }
                    }
                    TJZ_Network.Instance.StartGame();
                }
            }
            public override void Update()
            {
                base.Update();
            }
        }
        /// <summary>
        /// 进入免费
        /// </summary>
        private class EnterFreeState : State<TJZEntry>
        {
            bool isEnterFreeGame = false;
            float _time = 0f;
            public EnterFreeState(TJZEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.Freestate.gameObject.SetActive(true);
                owner.FreeBG.gameObject.SetActive(true);
                owner.closeAutoBtn.gameObject.SetActive(false);
                owner.GameData.isFreeGame = true;
                isEnterFreeGame = true;
                _time = 0f;
                owner.GameData.ResultData.nAddFreeCnt = 0;
                owner.GameData.CurrentFreeCount = owner.GameData.ResultData.nFreeCount;
                owner.EnterFree.gameObject.SetActive(true);
                owner.EnterFreeNum.text = owner.GameData.CurrentFreeCount.ShowRichText();
                owner.FreestateNum.text = owner.GameData.CurrentFreeCount.ShowRichText();
                TJZ_Audio.Instance.PlayBGM(TJZ_Audio.FreeBGM);
            }

            public override void Update()
            {
                base.Update();
                if (isEnterFreeGame)
                {
                    _time += Time.deltaTime;
                    if (_time>=1.5f)
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
        private class FreeRollState : State<TJZEntry>
        {
            public FreeRollState(TJZEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.FreestateNum.text = owner.GameData.CurrentFreeCount.ShowRichText();
                owner.startState.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.AutoOption.gameObject.SetActive(false);
                owner.Freestate.gameObject.SetActive(true);
                owner.FreeBG.gameObject.SetActive(true);
                owner.GameData.isFreeGame = true;
                TJZ_Network.Instance.StartGame();
            }
            public override void Update()
            {
                base.Update();
            }
        }
        /// <summary>
        /// 免费结算
        /// </summary>
        private class FreeResultState : State<TJZEntry>
        {
            float _time = 0f;
            bool isFreeResultGame;
            public FreeResultState(TJZEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                _time = 0f;
                isFreeResultGame = false;
                owner.GameData.isFreeGame = false;
                owner.FreeResult.gameObject.SetActive(true);

                ToolHelper.RunGoal(0, TJZEntry.Instance.GameData.TotalFreeWin, TJZ_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    long.TryParse(goal, out var num);
                    owner.FreeResultNum.text = num.ShortNumber().ShowRichText();
                }).OnComplete(delegate ()
                {
                    isFreeResultGame = true;
                });
                
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
                TJZEntry.Instance.GameData.TotalFreeWin = 0;
                owner.FreeResult.gameObject.SetActive(false);
                owner.FreeBG.gameObject.SetActive(false);

                for (int i = 0; i < owner.pillar.childCount; i++)
                {
                    owner.pillar.GetChild(i).GetChild(0).gameObject.SetActive(false);
                }
                owner.FreeDeng.GetChild(0).gameObject.SetActive(false);
                owner.FreeMZ.GetChild(0).gameObject.SetActive(false);
                owner.FreeChe.GetChild(0).gameObject.SetActive(false);
                TJZ_Audio.Instance.PlayBGM();
                hsm?.ChangeState(nameof(CheckState));
            }
        }
        #endregion
    }
}
