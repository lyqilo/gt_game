

using DragonBones;
using LuaFramework;
using System.Collections.Generic;
using System.Collections;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Transform = UnityEngine.Transform;

namespace Hotfix.JTJW
{
    /// <summary>
    /// 游戏主入口
    /// </summary>
    public class JWEntry : SingletonILEntity<JWEntry>
    {
        public Data GameData { get; set; }

        public Transform MainContent;

        private Animator changeGameModeAnim;

        private Transform RollContent;

        private TextMeshProUGUI lineNum;
        private TextMeshProUGUI ChipNum;
        private TextMeshProUGUI TotalChipNum;
        public TextMeshProUGUI winNum;
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
        
        private Transform effectgroup;

        private Transform EnterFree;
        private Transform ExitFree;
        private TextMeshProUGUI ExitFreeNum;
        private TextMeshProUGUI ExitFreeTime;
        private Button ExitFreeCloseBtn;

        private Transform AutoCount;
        private TextMeshProUGUI AutoCountNum;

        public Transform CSGroup;

        public Transform effectList;
        public Transform effectPool;

        private Transform NormalBG;
        private Transform FreeBG;
        public Transform NormalMode;
        private Transform FreeMode;
        private TextMeshProUGUI FreeModeNum;

        private Transform TWG_gunag;

        
        HierarchicalStateMachine hsm;
        List<IState> states;
        bool isStopRoll;

        private int twNum = 0;
        private int twSGNum = 0;

        private float twTime = 0f;
        private bool ISTWtate=false;
        private Transform lineGroup;

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
            RollContent.gameObject.AddILComponent<JW_Roll>();
            rulePanel.gameObject.AddILComponent<JW_Rule>();
            resultEffect.gameObject.AddILComponent<JW_Result>();
            lineGroup.gameObject.AddILComponent<JW_Line>();
            gameObject.AddILComponent<JW_Network>();
            gameObject.AddILComponent<JW_Audio>();;
            isStopRoll = true;
            twNum = 0;
            twTime = 0f;
            twSGNum = 0;
            ISTWtate = false;
            
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
            if (!ISTWtate) return;
            twTime += Time.deltaTime;
            if (!(twTime >= 5)) return;
            ISTWtate = false;
            twTime = 0;
            JW_TWNONOver();
        }

        protected override void AddEvent()
        {
            JW_Event.RefreshGold += JW_Event_RefreshGold;
            JW_Event.OnGetSceneData += JW_Event_OnGetSceneData;
            JW_Event.ShowResultComplete += JW_Event_ShowResultComplete;
            JW_Event.OnChangeBet += JW_Event_OnChangeBet;
            JW_Event.RollPrepreaComplete += JW_Event_RollPrepreaComplete;
            JW_Event.RollComplete += JW_Event_RollComplete;
            JW_Event.RollFailed += JW_Event_RollFailed;
            JW_Event.ShowResult += JW_Event_ShowResult;
            JW_Event.ShowW += JW_TWNON;
            JW_Event.JW_TWG_PLAY += JW_TWG_PLAY;
        }

        protected override void RemoveEvent()
        {
            JW_Event.RefreshGold -= JW_Event_RefreshGold;
            JW_Event.OnGetSceneData -= JW_Event_OnGetSceneData;
            JW_Event.ShowResultComplete -= JW_Event_ShowResultComplete;
            JW_Event.OnChangeBet -= JW_Event_OnChangeBet;
            JW_Event.RollPrepreaComplete -= JW_Event_RollPrepreaComplete;
            JW_Event.RollComplete -= JW_Event_RollComplete;
            JW_Event.RollFailed -= JW_Event_RollFailed;
            JW_Event.ShowResult -= JW_Event_ShowResult;
            JW_Event.ShowW -= JW_TWNON;
            JW_Event.JW_TWG_PLAY -= JW_TWG_PLAY;
        }

        protected override void FindComponent()
        {
            MainContent = transform.Find("MainPanel");
            RollContent = MainContent.Find("Content/RollContent"); //转动区域
            ChipNum = MainContent.FindChildDepth<TextMeshProUGUI>("Content/ButtonGroup/Chip/Num0"); //单注
            TotalChipNum = MainContent.FindChildDepth<TextMeshProUGUI>("Content/ButtonGroup/Chip/Num"); //总注
            winNum = MainContent.FindChildDepth<TextMeshProUGUI>("Content/ButtonGroup/WinNormal/Num");//中奖数额
            reduceChipBtn = MainContent.FindChildDepth<Button>("Content/ButtonGroup/Chip/Reduce"); //减注
            addChipBtn = MainContent.FindChildDepth<Button>("Content/ButtonGroup/Chip/Add"); //加注
            btnGroup = MainContent.Find("Content/ButtonGroup");
            startBtn = btnGroup.Find("StartBtn"); //开始按钮
            startState = startBtn.transform.FindChildDepth<Button>("Start");//开始状态
            openAutoBtn = btnGroup.transform.FindChildDepth<Button>("AutoBtn");//自动按钮
            autoListGroup = openAutoBtn.transform.FindChildDepth("AutoList");//自动列表
            autoListGroup.gameObject.SetActive(false);
            closeAutoListBtn = openAutoBtn.transform.FindChildDepth<Button>("CloseAutoListBtn");//关闭自动列表
            closeAutoBtn = btnGroup.transform.FindChildDepth<Button>("CloseAutoBtn");//停止自动
            closeAutoBtn.gameObject.SetActive(false);

            //freeShowGroup = MainContent.FindChildDepth("Content/FreeBtnGroup");//免费结算界面
            //freeNum = freeShowGroup.FindChildDepth<TextMeshProUGUI>("FreeCount");
            //freeTotalWinNum = freeShowGroup.FindChildDepth<TextMeshProUGUI>("TotalWin");

            rulePanel = MainContent.FindChildDepth("Content/Rule"); //规则界面
            rulePanel.gameObject.SetActive(false);

            closeGame = MainContent.FindChildDepth<Button>("Content/QuitGameBtn");
            showRuleBtn = MainContent.FindChildDepth<Button>("Content/ButtonGroup/RuleBtn");
            soundBtn = MainContent.FindChildDepth<Toggle>("Content/SoundBtn");
            soundOn = soundBtn.transform.FindChildDepth("SoundOn");
            soundOff = soundBtn.transform.FindChildDepth("SoundOff");
            soundBtn.isOn = MusicManager.isPlayMV;
            soundOn.gameObject.SetActive(MusicManager.isPlayMV);
            soundOff.gameObject.SetActive(!MusicManager.isPlayMV);

            userInfo = MainContent.FindChildDepth("Content/Bottom/UserInfo");
            selfGold = userInfo.FindChildDepth<TextMeshProUGUI>("GoldNum"); //自身金币

            resultEffect = MainContent.FindChildDepth("Content/Result");

            lineGroup = MainContent.FindChildDepth("Content/LineGroup");

            effectgroup = MainContent.FindChildDepth("Content/Effect"); //图标库
            CSGroup = MainContent.FindChildDepth("Content/CSContent"); //显示特別效果

            effectList = MainContent.FindChildDepth("Content/EffectList"); //动画库
            effectPool = MainContent.FindChildDepth("Content/EffectPool"); //动画缓存库

            EnterFree = MainContent.FindChildDepth("Content/EnterFree");
            ExitFree = MainContent.FindChildDepth("Content/ExitFree");
            ExitFreeNum = MainContent.FindChildDepth<TextMeshProUGUI>("Content/ExitFree/Content/Num");
            ExitFreeTime = MainContent.FindChildDepth<TextMeshProUGUI>("Content/ExitFree/Content/Time");
            ExitFreeCloseBtn = MainContent.FindChildDepth<Button>("Content/ExitFree/Content/closeBtn");

            AutoCount = MainContent.FindChildDepth("Content/ButtonGroup/AutoBtn/AutoCount");
            AutoCountNum = MainContent.FindChildDepth<TextMeshProUGUI>("Content/ButtonGroup/AutoBtn/AutoCount/Num");


            NormalBG = MainContent.FindChildDepth("Content/Background/Normal");
            FreeBG = MainContent.FindChildDepth("Content/Background/Free");
            NormalMode = MainContent.FindChildDepth("Content/NormalMode");
            FreeMode = MainContent.FindChildDepth("Content/FreeMode");
            FreeModeNum = MainContent.FindChildDepth<TextMeshProUGUI>("Content/FreeMode/FreeNum/Image/Num");
            TWG_gunag = MainContent.FindChildDepth("Content/NormalMode/Nan/go");
        }
        private void AddListener()
        {
            reduceChipBtn.onClick.RemoveAllListeners();
            reduceChipBtn.onClick.Add(ReduceChipCall);

            addChipBtn.onClick.RemoveAllListeners();
            addChipBtn.onClick.Add(AddChipCall);

            startState.onClick.RemoveAllListeners();
            startState.onClick.Add(StartGameCall);

            showRuleBtn.onClick.RemoveAllListeners(); //显示规则
            showRuleBtn.onClick.Add(ShowRulePanel);

            //MaxChipBtn.onClick.RemoveAllListeners();
            //MaxChipBtn.onClick.Add(SetMaxChipCall);

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
                    JW_Audio.Instance.ResetSound();
                    JW_Audio.Instance.PlaySound(JW_Audio.BTN);
                }
                else
                {
                    ToolHelper.MuteMusic();
                    ToolHelper.MuteSound();
                    JW_Audio.Instance.MuteSound();
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


        private void JW_Event_RefreshGold(long gold)
        {
            GameData.myGold = gold;
            selfGold.text = ToolHelper.ShowRichText(GameData.myGold);
        }

        private void JW_Event_OnGetSceneData()
        {
            hsm?.ChangeState(nameof(InitState));
        }

        private void JW_Event_ShowResultComplete()
        {
            //TODO 收分做跳跃动画
            hsm?.ChangeState(nameof(CheckState));
            JW_Event.DispatchRefreshGold((long)GameLocalMode.Instance.UserGameInfo.Gold);

        }

        private void JW_Event_OnChangeBet()
        {
            TotalChipNum.text = ToolHelper.ShowRichText(GameData.CurrentChip * JW_DataConfig.ALLLINECOUNT);
        }

        private void JW_Event_RollComplete()
        {
            JW_Event.DispatchShowResult();
        }

        private void JW_Event_RollPrepreaComplete()
        {
            hsm?.ChangeState(nameof(WaitStopState));
        }

        private void JW_Event_RollFailed()
        {
            hsm?.ChangeState(nameof(IdleState));
        }

        private void JW_Event_ShowResult()
        {
          //  winNum.text = ToolHelper.ShowRichText(GameData.ResultData.nWinGold);
        }

        public void JW_Event_ShowResultNum(int gold)
        {
              winNum.text = ToolHelper.ShowRichText(gold);
        }

        public void JW_Event_ShowResultNum(bool b)
        {
            isStopRoll = b;
        }

        private void JW_TWNON()
        {
            ISTWtate = true;
            twNum++;
            twSGNum=0;

            if (twNum%2==0)
            {
                NormalMode.transform.FindChildDepth("Nan/Image1").gameObject.SetActive(false);
                NormalMode.transform.FindChildDepth("Nan/Image2").gameObject.SetActive(true);
                TWG_gunag = NormalMode.transform.FindChildDepth("Nan/go");
                TWG_gunag.gameObject.SetActive(true);
            }
            else
            {
                NormalMode.transform.FindChildDepth("NV/Image1").gameObject.SetActive(false);
                NormalMode.transform.FindChildDepth("NV/Image2").gameObject.SetActive(true);
                TWG_gunag = NormalMode.transform.FindChildDepth("NV/go");
                TWG_gunag.gameObject.SetActive(true);
            }
        }
        private void JW_TWNONOver()
        {
            NormalMode.transform.FindChildDepth("Nan/Image1").gameObject.SetActive(true);
            NormalMode.transform.FindChildDepth("Nan/Image2").gameObject.SetActive(false);
            NormalMode.transform.FindChildDepth("NV/Image1").gameObject.SetActive(true);
            NormalMode.transform.FindChildDepth("NV/Image2").gameObject.SetActive(false);
            TWG_gunag.gameObject.SetActive(false);
            for (int i = 0; i < TWG_gunag.childCount; i++)
            {
               TWG_gunag.GetChild(i).gameObject.SetActive(false);
            }
        }

        private void JW_TWG_PLAY()
        {
            if (twSGNum >= TWG_gunag.childCount)
                return;

            TWG_gunag.GetChild(twSGNum).gameObject.SetActive(true);
            twSGNum++;
        }



        /// <summary>
        /// 加注
        /// </summary>
        private void AddChipCall()
        {
            //加注
            JW_Audio.Instance.PlaySound(JW_Audio.BTN);
            if (GameData.SceneData.nBet == null || GameData.SceneData.nBet.Count <= 0) return;
            GameData.CurrentChipIndex += 1;
            if (GameData.CurrentChipIndex >= GameData.SceneData.nBetCount)
            {
                GameData.CurrentChipIndex = GameData.SceneData.nBetCount - 1;
                ToolHelper.PopSmallWindow("Bet max reached");
                return;
            }
            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            ChipNum.text = ToolHelper.ShowRichText(GameData.CurrentChip);
            JW_Event.DispatchOnChangeBet();
        }

        /// <summary>
        /// 减注
        /// </summary>
        private void ReduceChipCall()
        {
            JW_Audio.Instance.PlaySound(JW_Audio.BTN);
            if (GameData.SceneData.nBet == null || GameData.SceneData.nBet.Count <= 0) return;

            GameData.CurrentChipIndex -= 1;

            if (GameData.CurrentChipIndex < 0)
            {
                GameData.CurrentChipIndex = 0;
                ToolHelper.PopSmallWindow("Bets have reached the minimum");
                return;
            }

            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            ChipNum.text = ToolHelper.ShowRichText(GameData.CurrentChip);
            JW_Event.DispatchOnChangeBet();
        }

        //开始游戏
        private void StartGameCall()
        {
            if (GameData.isFreeGame) return;
            //JW_Audio.Instance.PlaySound(JW_Audio.RunWheel);
            hsm?.ChangeState(nameof(NormalRollState));
        }

        private void StopGame()
        {
            JW_Audio.Instance.PlaySound(JW_Audio.BTN);
          //  startState.gameObject.SetActive(true);
            //stopState.gameObject.SetActive(false);
            startState.interactable = false;
            openAutoBtn.interactable = false;
            //stopState.interactable = false;
            JW_Event.DispatchStopRoll(true);
        }
        /// <summary>
        /// 显示规则界面
        /// </summary>
        private void ShowRulePanel()
        {
            JW_Audio.Instance.PlaySound(JW_Audio.BTN);
            rulePanel.gameObject.SetActive(true);
        }
        /// <summary>
        /// 设置最大下注
        /// </summary>
        private void SetMaxChipCall()
        {
            JW_Audio.Instance.PlaySound(JW_Audio.BTN);
            GameData.CurrentChipIndex = GameData.SceneData.nBetCount - 1;
            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            ChipNum.text = ToolHelper.ShowRichText(GameData.CurrentChip);
            JW_Event.DispatchOnChangeBet();
        }
        private void CloseGameCall()
        {
            JW_Audio.Instance.PlaySound(JW_Audio.BTN);
            if (!GameData.isFreeGame && GameData.ResultData.cbRerun <= 0)
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

            if (autoListGroup.gameObject.activeSelf) {
                CloseAutoListCall();
                return;
            }
            JW_Audio.Instance.PlaySound(JW_Audio.BTN);
            closeAutoListBtn.gameObject.SetActive(true);
            autoListGroup.gameObject.SetActive(true);
        }
        /// <summary>
        /// 关闭自动列表
        /// </summary>
        private void CloseAutoListCall()
        {
            JW_Audio.Instance.PlaySound(JW_Audio.BTN);
            openAutoBtn.interactable = true;
            autoListGroup.gameObject.SetActive(false);
            closeAutoListBtn.gameObject.SetActive(false);
        }

        /// <summary>
        /// 停止自动旋转
        /// </summary>
        private void StopAutoGame()
        {
            GameData.isAutoGame = false;
            hsm?.ChangeState(nameof(IdleState));
        }

        private void OnClickAutoCall(int autoCount)
        {
            //点击自动开始
            JW_Audio.Instance.PlaySound(JW_Audio.BTN);
            GameData.CurrentAutoCount = autoCount;
            hsm?.ChangeState(nameof(AutoRollState));
            GameData.isAutoGame = true;
        }
        #region 状态机
        /// <summary>
        /// 待机状态
        /// </summary>
        private class IdleState : State<JWEntry>
        {
            public IdleState(JWEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.GameData.CurrentAutoCount = 0;
                owner.GameData.CurrentFreeCount = 0;
                owner.AutoCount.gameObject.SetActive(false);
                owner.closeAutoBtn.gameObject.SetActive(false);
                owner.openAutoBtn.interactable = true;

                if (owner.isStopRoll)
                {
                    owner.startState.interactable = true;
                    owner.addChipBtn.interactable = true;
                    owner.reduceChipBtn.interactable = true;
                }
            }
        }
        /// <summary>
        /// 初始化状态
        /// </summary>
        private class InitState : State<JWEntry>
        {
            public InitState(JWEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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

                JW_Event.DispatchRefreshGold((long)GameLocalMode.Instance.UserGameInfo.Gold);
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
                owner.ChipNum.text = ToolHelper.ShowRichText(owner.GameData.SceneData.nCurrenBet);
                JW_Event.DispatchOnChangeBet();
                owner.winNum.text = ToolHelper.ShowRichText(0); ;
                owner.AddListener();
                if (owner.GameData.SceneData.nFreeCount != 0)
                {
                    owner.GameData.CurrentFreeCount = owner.GameData.SceneData.nFreeCount;
                    JW_Audio.Instance.PlayBGM(JW_Audio.FreeBGM);
                    hsm?.ChangeState(nameof(FreeRollState));
                }
                else if(owner.GameData.SceneData.cbRerun>0)
                {
                    hsm?.ChangeState(nameof(NormalRollState));
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
        private class CheckState : State<JWEntry>
        {
            public CheckState(JWEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
        private class NormalRollState : State<JWEntry>
        {
            public NormalRollState(JWEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                owner.openAutoBtn.interactable = false;
                owner.CloseAutoListCall();
                owner.openAutoBtn.interactable = false;
                JW_Network.Instance.StartGame();
                JW_Audio.Instance.PlaySound(JW_Audio.Run);

                owner.JW_Event_ShowResultNum(0);
            }
        }
        private class WaitStopState : State<JWEntry>
        {
            public WaitStopState(JWEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
        private class AutoRollState : State<JWEntry>
        {
            public AutoRollState(JWEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();

                owner.startState.interactable = false;
                owner.openAutoBtn.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                
                owner.closeAutoBtn.gameObject.SetActive(true);
                owner.AutoCount.gameObject.SetActive(true);
                owner.autoListGroup.gameObject.SetActive(false);
                owner.closeAutoListBtn.gameObject.SetActive(false);

                owner.AutoCountNum.text = ToolHelper.ShowRichText(owner.GameData.CurrentAutoCount);

                if (owner.isStopRoll)
                {
                    JW_Audio.Instance.PlaySound(JW_Audio.Run);
                    JW_Network.Instance.StartGame();
                }
            }
            public override void Update()
            {
                base.Update();
            }
        }
        /// <summary>
        /// 免费
        /// </summary>
        private class EnterFreeState : State<JWEntry>
        {
            bool isEnterFreeGame = false;
            float _time = 0f;
            public EnterFreeState(JWEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.Behaviour.StartCoroutine(PlayFreeIcon());
            }

            IEnumerator PlayFreeIcon()
            {
                JW_Event.DispatchShowFreePlay();
                yield return new WaitForSeconds(0.5f);
                owner.GameData.isFreeGame = true;
                owner.EnterFree.gameObject.SetActive(true);
                JW_Audio.Instance.PlaySound(JW_Audio.freeGameIn);
                isEnterFreeGame = true;
                _time = 0f;
                owner.GameData.TotalFreeWin = 0;
                owner.GameData.CurrentFreeCount = owner.GameData.ResultData.nFreeCount;
                owner.NormalBG.gameObject.SetActive(false);
                owner.NormalMode.gameObject.SetActive(false);
                owner.FreeBG.gameObject.SetActive(true);
                owner.AutoCount.gameObject.SetActive(false);
                owner.FreeModeNum.text = ToolHelper.ShowRichText(owner.GameData.CurrentFreeCount);
                owner.FreeMode.gameObject.SetActive(true);
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
                        JW_Audio.Instance.PlayBGM(JW_Audio.FreeBGM);
                        owner.EnterFree.gameObject.SetActive(false);
                        hsm?.ChangeState(nameof(CheckState));
                    }
                }
            }

            public override void OnExit()
            {
                base.OnExit();
                owner.Behaviour.StopCoroutine(PlayFreeIcon());

            }
        }
        /// <summary>
        /// 免费
        /// </summary>
        private class FreeRollState : State<JWEntry>
        {
            public FreeRollState(JWEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.startState.interactable = false;
                owner.openAutoBtn.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.GameData.isFreeGame = true;
                owner.NormalBG.gameObject.SetActive(false);
                owner.NormalMode.gameObject.SetActive(false);
                owner.FreeBG.gameObject.SetActive(true);
                owner.AutoCount.gameObject.SetActive(false);
                owner.FreeModeNum.text = ToolHelper.ShowRichText(owner.GameData.CurrentFreeCount);
                owner.FreeMode.gameObject.SetActive(true);
                JW_Network.Instance.StartGame();

            }
            public override void Update()
            {
                base.Update();
            }
        }

        /// <summary>
        /// 免费结算
        /// </summary>
        private class FreeResultState : State<JWEntry>
        {
            float _time = 0f;
            int AllTime;
            public FreeResultState(JWEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                _time = 0f;
                AllTime = JW_DataConfig.AUTOVERFREETIME;
                owner.GameData.isFreeGame = false;
                owner.ExitFreeNum.text= ToolHelper.ShowRichText(owner.GameData.TotalFreeWin);
                owner.ExitFreeTime.text = ToolHelper.ShowRichText(AllTime);
                owner.ExitFree.gameObject.SetActive(true);
                owner.ExitFreeCloseBtn.onClick.RemoveAllListeners();
                owner.ExitFreeCloseBtn.onClick.Add(OnClickCloseFreeResult);
            }

            public override void Update()
            {
                base.Update();
                _time += Time.deltaTime;
                if (_time>=1)
                {
                    _time = 0;
                    AllTime--;
                    owner.ExitFreeTime.text = ToolHelper.ShowRichText(AllTime);
                    if (AllTime<=0)
                    {
                        OnClickCloseFreeResult();
                    }
                }
            }

            private void OnClickCloseFreeResult()
            {
                owner.NormalBG.gameObject.SetActive(true);
                owner.NormalMode.gameObject.SetActive(true);
                owner.FreeBG.gameObject.SetActive(false);
                owner.FreeMode.gameObject.SetActive(false);
                owner.ExitFree.gameObject.SetActive(false);
                owner.AutoCount.gameObject.SetActive(true);
                JWEntry.Instance.GameData.TotalFreeWin = 0;
                JW_Audio.Instance.PlayBGM();
                hsm?.ChangeState(nameof(CheckState));
            }

        }

        #endregion
    }
}
