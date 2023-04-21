

using DragonBones;
using LuaFramework;
using System.Collections.Generic;
using System.Collections;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Transform = UnityEngine.Transform;
using DG.Tweening;

namespace Hotfix.MJHL
{
    /// <summary>
    /// 游戏主入口
    /// </summary>
    public class MJHLEntry : SingletonILEntity<MJHLEntry>
    {
        public Data GameData { get; set; }

        public Transform mainContent;

        private Transform normalBG;
        private Transform freeBG;
        private Transform bottomnormalMode;
        private Transform NormalImage;

        private Transform bottomFreeMode;
        private Transform FreeImage;
        

        private Transform freeMode;
        private TextMeshProUGUI freeModeNum;
        private Transform rollContent;
        public Transform CSGroup;
        private Transform bottom;
        private Transform bottom_Normal;
        private Transform bottom_Free;
        private Transform freeTipText;
        private Transform freeTipImage;

        private Transform BtnInfo1;
        private Button startBtn;
        private Transform startBG;
        private Transform startRot;
        private Button openAutoBtn;
        private Button closeAutoBtn;
        private Transform AutoCount;
        private TextMeshProUGUI AutoCountNum;
        private Button reduceChipBtn;
        private Button addChipBtn;
        private Transform rulePanel;
        private Transform userInfo;
        private TextMeshProUGUI selfGold;
        public TextMeshProUGUI winNum;
        private Button ContentBtn;
        private Transform BtnInfo2;

        private Button CloseContentBtn;
        private Button closeGame;
        private Toggle soundBtn;
        private Button showRuleBtn;
        private Transform soundOn;
        private Transform soundOff;
        private Transform btnContent;
        private Transform EnterFree;
        private TextMeshProUGUI EnterFreeNum;
        private Button EnterFreeBtn;
        private Transform ExitFree;
        private TextMeshProUGUI ExitFreeNum;
        private Button ExitFreeCloseBtn;
        private TextMeshProUGUI ChipNum;
        private Button closeAutoListBtn;
        private Transform autoListGroup;
        private Transform resultEffect;
        private Transform effectgroup;
        public Transform effectList;
        public Transform effectPool;
        private Transform Top;
        private Transform TopNormal;
        private Transform TopNormalRateGroup;
        private Transform TopNormalFree;
        private Transform TopNormalFreeRateGroup;

        private Transform FreeMove;


        HierarchicalStateMachine hsm;
        List<IState> states;
        bool isStopRoll;

        float timer;
        bool isPlayOverGuang;

        protected override void Awake()
        {
            base.Awake();
            DebugHelper.Log("----------OnAwake---------------");
            Screen.autorotateToLandscapeLeft = true;
            Screen.autorotateToLandscapeRight = true;
            Screen.autorotateToPortrait = false;
            Screen.autorotateToPortraitUpsideDown = false;
            GameData = new Data();
            rollContent.gameObject.AddILComponent<MJHL_Roll>();
            rulePanel.gameObject.AddILComponent<MJHL_Rule>();
            resultEffect.gameObject.AddILComponent<MJHL_Result>();
            CSGroup.gameObject.AddILComponent<MJHL_Line>();
            gameObject.AddILComponent<MJHL_Network>();
            gameObject.AddILComponent<MJHL_Audio>();;
            isStopRoll = true;
            isPlayOverGuang = true;
            timer = 0f;
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

            if (isPlayOverGuang) return;
            timer += Time.deltaTime;
            if (timer > 0.75f)
            {
                isPlayOverGuang = true;
                timer = 0;
                startRot.gameObject.SetActive(false);
            }
        }

        protected override void AddEvent()
        {
            MJHL_Event.RefreshGold += MJHL_Event_RefreshGold;
            MJHL_Event.OnGetSceneData += MJHL_Event_OnGetSceneData;
            MJHL_Event.ShowResultComplete += MJHL_Event_ShowResultComplete;
            MJHL_Event.RollPrepreaComplete += MJHL_Event_RollPrepreaComplete;
            MJHL_Event.RollComplete += MJHL_Event_RollComplete;
            MJHL_Event.RollFailed += MJHL_Event_RollFailed;
            MJHL_Event.ShowResult += MJHL_Event_ShowResult;
            MJHL_Event.MJHL_PLAY_Multiple += DisplayMultiple;
            MJHL_Event.MJHL_AllWinGold += MJHL_Event_ShowResultNum;
        }

        protected override void RemoveEvent()
        {
            MJHL_Event.RefreshGold -= MJHL_Event_RefreshGold;
            MJHL_Event.OnGetSceneData -= MJHL_Event_OnGetSceneData;
            MJHL_Event.ShowResultComplete -= MJHL_Event_ShowResultComplete;
            MJHL_Event.RollPrepreaComplete -= MJHL_Event_RollPrepreaComplete;
            MJHL_Event.RollComplete -= MJHL_Event_RollComplete;
            MJHL_Event.RollFailed -= MJHL_Event_RollFailed;
            MJHL_Event.ShowResult -= MJHL_Event_ShowResult;
            MJHL_Event.MJHL_PLAY_Multiple -= DisplayMultiple;
            MJHL_Event.MJHL_AllWinGold -= MJHL_Event_ShowResultNum;
        }

        protected override void FindComponent()
        {
            mainContent = transform.Find("MainPanel");
            rollContent = mainContent.Find("Content/RollContent"); //转动区域
            ChipNum = mainContent.FindChildDepth<TextMeshProUGUI>("Content/Bottom/Chip/GoldNum"); //单注
            winNum = mainContent.FindChildDepth<TextMeshProUGUI>("Content/Bottom/WinNormal/GoldNum");//中奖数额

            bottom = mainContent.Find("Content/Bottom");

            BtnInfo1 = bottom.FindChildDepth("BtnInfo1");
            reduceChipBtn = BtnInfo1.FindChildDepth<Button>("Reduce"); //减注
            addChipBtn = BtnInfo1.FindChildDepth<Button>("Add"); //加注
            startBtn = BtnInfo1.transform.FindChildDepth<Button>("StartBtn");//开始状态
            startBG = startBtn.transform.FindChildDepth("Start");
            startRot= startBtn.transform.FindChildDepth("StartRot");

            openAutoBtn = BtnInfo1.transform.FindChildDepth<Button>("AutoBtn");//自动按钮
            closeAutoListBtn = openAutoBtn.transform.FindChildDepth<Button>("Canvas/CloseAutoListBtn");
            autoListGroup = openAutoBtn.transform.FindChildDepth("Canvas/AutoList");
            openAutoBtn.gameObject.SetActive(true);
            closeAutoBtn = BtnInfo1.transform.FindChildDepth<Button>("CloseAutoBtn");//停止自动
            ContentBtn = BtnInfo1.FindChildDepth<Button>("ContentBtn");

            closeAutoBtn.gameObject.SetActive(false);
            AutoCount = BtnInfo1.transform.FindChildDepth("AutoNum");//自动按钮
            AutoCount.gameObject.SetActive(false);
            AutoCountNum = AutoCount.FindChildDepth<TextMeshProUGUI>("Text");
            rulePanel = mainContent.FindChildDepth("Content/Rule"); //规则界面
            rulePanel.gameObject.SetActive(false);
            resultEffect = mainContent.FindChildDepth("Content/Result");
            effectgroup = mainContent.FindChildDepth("Content/Effect"); //图标库
            CSGroup = mainContent.FindChildDepth("Content/CSContent"); //显示特別效果
            effectList = mainContent.FindChildDepth("Content/EffectList"); //动画库
            effectPool = mainContent.FindChildDepth("Content/EffectPool"); //动画缓存库
            EnterFree = mainContent.FindChildDepth("Content/EnterFree");
            EnterFreeNum = EnterFree.FindChildDepth<TextMeshProUGUI>("EnterFree/FreeObject/Image/Text");
            EnterFreeBtn = EnterFree.FindChildDepth<Button>("EnterFree/FreeObject/Button");
            ExitFree = mainContent.FindChildDepth("Content/ExitFree");
            ExitFreeNum = ExitFree.FindChildDepth<TextMeshProUGUI>("Content/Num");
            ExitFreeCloseBtn = mainContent.FindChildDepth<Button>("Content/ExitFree/Content/closeBtn");
            normalBG = mainContent.FindChildDepth("Content/Background/Normal");
            freeBG = mainContent.FindChildDepth("Content/Background/Free");

            bottomnormalMode = mainContent.FindChildDepth("Content/Bottom/Normal");
            NormalImage= mainContent.FindChildDepth("Content/Bottom/NormalImage");

            bottomFreeMode = mainContent.FindChildDepth("Content/Bottom/Free");
            FreeImage= mainContent.FindChildDepth("Content/Bottom/FreeImage");

            freeMode = mainContent.FindChildDepth("Content/Bottom/freeMode");
            freeModeNum = freeMode.FindChildDepth<TextMeshProUGUI>("Num");
            Top = mainContent.FindChildDepth("Content/Top");
            TopNormal = Top.FindChildDepth("Normal");
            TopNormalRateGroup = TopNormal.FindChildDepth("RateGroup");
            TopNormalFree = Top.FindChildDepth("Free");
            TopNormalFreeRateGroup = TopNormalFree.FindChildDepth("RateGroup");
            TopNormalFree.gameObject.SetActive(false);

            BtnInfo2 = bottom.FindChildDepth("BtnInfo2");
            CloseContentBtn = BtnInfo2.FindChildDepth<Button>("CloseConent");
            closeGame = BtnInfo2.FindChildDepth<Button>("QuitGameBtn");
            showRuleBtn = BtnInfo2.FindChildDepth<Button>("RuleBtn");
            soundBtn = BtnInfo2.FindChildDepth<Toggle>("SoundBtn");
            soundOn = soundBtn.transform.FindChildDepth("SoundOn");
            soundOff = soundBtn.transform.FindChildDepth("SoundOff");
            soundBtn.isOn = MusicManager.isPlayMV;
            soundOn.gameObject.SetActive(MusicManager.isPlayMV);
            soundOff.gameObject.SetActive(!MusicManager.isPlayMV);

            userInfo = mainContent.FindChildDepth("Content/Bottom/UserInfo");
            selfGold = userInfo.FindChildDepth<TextMeshProUGUI>("GoldNum"); //自身金币
            FreeMove = mainContent.FindChildDepth("Content/FreeMove");
            FreeMove.gameObject.SetActive(false);
        }
        private void AddListener()
        {
            reduceChipBtn.onClick.RemoveAllListeners();
            reduceChipBtn.onClick.Add(ReduceChipCall);

            addChipBtn.onClick.RemoveAllListeners();
            addChipBtn.onClick.Add(AddChipCall);

            startBtn.onClick.RemoveAllListeners();
            startBtn.onClick.Add(StartGameCall);

            showRuleBtn.onClick.RemoveAllListeners(); //显示规则
            showRuleBtn.onClick.Add(ShowRulePanel);

            closeGame.onClick.RemoveAllListeners();
            closeGame.onClick.Add(CloseGameCall);

            openAutoBtn.onClick.RemoveAllListeners();
            openAutoBtn.onClick.Add(()=> 
            {
                MJHL_Audio.Instance.PlaySound(MJHL_Audio.BTN);
                OpenAutoListCall();
            });
            closeAutoBtn.onClick.RemoveAllListeners();
            closeAutoBtn.onClick.Add(StopAutoGame);


            ContentBtn.onClick.RemoveAllListeners();
            ContentBtn.onClick.Add(()=> 
            {
                MJHL_Audio.Instance.PlaySound(MJHL_Audio.BTN);
                BtnInfo2.localPosition = new Vector3(0, -600, 0);
                BtnInfo1.DOLocalMoveY(-600, 0.5f);
                ToolHelper.DelayRun(0.25f).OnComplete(delegate () 
                { 
                    BtnInfo2.DOLocalMoveY(0, 0.5f);
                });
            });

            CloseContentBtn.onClick.RemoveAllListeners();
            CloseContentBtn.onClick.Add(() =>
            {
                MJHL_Audio.Instance.PlaySound(MJHL_Audio.BTN);
                BtnInfo2.DOLocalMoveY(-600, 0.5f);
                ToolHelper.DelayRun(0.25f).OnComplete(delegate ()
                {
                    BtnInfo1.DOLocalMoveY(0, 0.5f);
                });
            });

            soundBtn.onValueChanged.RemoveAllListeners();
            soundBtn.onValueChanged.Add(delegate (bool value)
            {
                if (value)
                {
                    ToolHelper.PlaySound();
                    ToolHelper.PlayMusic();
                    MJHL_Audio.Instance.ResetSound();
                    MJHL_Audio.Instance.PlaySound(MJHL_Audio.BTN);
                }
                else
                {
                    ToolHelper.MuteMusic();
                    ToolHelper.MuteSound();
                    MJHL_Audio.Instance.MuteSound();
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


        private void MJHL_Event_RefreshGold(long gold)
        {
            GameData.myGold = gold;
            selfGold.text = GameData.myGold.ShortNumber();
        }

        private void MJHL_Event_OnGetSceneData()
        {
            hsm?.ChangeState(nameof(InitState));
        }

        private void MJHL_Event_ShowResultComplete()
        {
            //TODO 收分做跳跃动画
            hsm?.ChangeState(nameof(CheckState));
            MJHL_Event.DispatchRefreshGold((long)GameLocalMode.Instance.UserGameInfo.Gold);

        }

        private void MJHL_Event_RollComplete()
        {
            MJHL_Event.DispatchShowResult();
        }

        private void MJHL_Event_RollPrepreaComplete()
        {
            hsm?.ChangeState(nameof(WaitStopState));
        }

        private void MJHL_Event_RollFailed()
        {
            hsm?.ChangeState(nameof(IdleState));
        }

        private void MJHL_Event_ShowResult()
        {
          //  winNum.text = ToolHelper.ShowRichText(GameData.ResultData.nWinGold);
        }

        public void MJHL_Event_ShowResultNum(int gold)
        {
              winNum.text = gold.ShortNumber();
        }

        public void MJHL_Event_ShowResultNum(bool b)
        {
            isStopRoll = b;
        }

 
        /// <summary>
        /// 加注
        /// </summary>
        private void AddChipCall()
        {
            //加注
            MJHL_Audio.Instance.PlaySound(MJHL_Audio.BTN);
            if (GameData.SceneData.nBet == null || GameData.SceneData.nBet.Count <= 0) return;
            GameData.CurrentChipIndex += 1;
            if (GameData.CurrentChipIndex >= GameData.SceneData.nBetCount)
            {
                GameData.CurrentChipIndex = GameData.SceneData.nBetCount - 1;
                ToolHelper.PopSmallWindow("Bet max reached");
                return;
            }
            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            ChipNum.text = (GameData.CurrentChip * MJHL_DataConfig.ALLLINECOUNT).ShortNumber();
        }

        /// <summary>
        /// 减注
        /// </summary>
        private void ReduceChipCall()
        {
            MJHL_Audio.Instance.PlaySound(MJHL_Audio.BTN);
            if (GameData.SceneData.nBet == null || GameData.SceneData.nBet.Count <= 0) return;

            GameData.CurrentChipIndex -= 1;

            if (GameData.CurrentChipIndex < 0)
            {
                GameData.CurrentChipIndex = 0;
                ToolHelper.PopSmallWindow("Bets have reached the minimum");
                return;
            }

            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            ChipNum.text = (GameData.CurrentChip * MJHL_DataConfig.ALLLINECOUNT).ShortNumber();
        }

        //开始游戏
        private void StartGameCall()
        {
            if (GameData.isFreeGame) return;
            MJHL_Audio.Instance.PlaySound(MJHL_Audio.BTN);
            timer = 0;
            isPlayOverGuang = false;
            startRot.gameObject.SetActive(true);
            hsm?.ChangeState(nameof(NormalRollState));
        }

        /// <summary>
        /// 显示规则界面
        /// </summary>
        private void ShowRulePanel()
        {
            MJHL_Audio.Instance.PlaySound(MJHL_Audio.BTN);
            rulePanel.gameObject.SetActive(true);
        }
        private void CloseGameCall()
        {
            MJHL_Audio.Instance.PlaySound(MJHL_Audio.BTN);
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
            if (autoListGroup.gameObject.activeSelf) {
                CloseAutoListCall();
                return;
            }
            MJHL_Audio.Instance.PlaySound(MJHL_Audio.BTN);
            closeAutoListBtn.gameObject.SetActive(true);
            autoListGroup.gameObject.SetActive(true);
        }
        /// <summary>
        /// 关闭自动列表
        /// </summary>
        private void CloseAutoListCall()
        {
            MJHL_Audio.Instance.PlaySound(MJHL_Audio.BTN);
            openAutoBtn.interactable = true;
            autoListGroup.gameObject.SetActive(false);
            closeAutoListBtn.gameObject.SetActive(false);
        }

        /// <summary>
        /// 停止自动旋转
        /// </summary>
        private void StopAutoGame()
        {
            MJHL_Audio.Instance.PlaySound(MJHL_Audio.BTN);
            GameData.isAutoGame = false;
            hsm?.ChangeState(nameof(IdleState));
        }

        private void OnClickAutoCall(int autoCount)
        {
            //点击自动开始
            //MJHL_Audio.Instance.PlaySound(MJHL_Audio.BTN);
            GameData.CurrentAutoCount = autoCount;
            hsm?.ChangeState(nameof(AutoRollState));
            GameData.isAutoGame = true;
        }

        private void DisplayMultiple()
        {
            if (!GameData.isFreeGame)
            {
                TopNormalRateGroup.GetChild(GameData.Index).GetComponent<Toggle>().isOn = true;
                if (!TopNormalRateGroup.GetChild(GameData.Index).FindChildDepth("Light1").gameObject.activeSelf && GameData.Index==0)
                {
                    TopNormalRateGroup.GetChild(GameData.Index).FindChildDepth("FreeParticle").gameObject.SetActive(true);
                    TopNormalRateGroup.GetChild(GameData.Index).FindChildDepth("Light1").gameObject.SetActive(true);
                    TopNormalRateGroup.GetChild(GameData.Index).FindChildDepth("Image").gameObject.SetActive(true);
                    for (int i = 1; i < TopNormalRateGroup.childCount; i++)
                    {
                        TopNormalRateGroup.GetChild(i).FindChildDepth("Light1").gameObject.SetActive(false);
                        TopNormalRateGroup.GetChild(i).FindChildDepth("Image").gameObject.SetActive(false);
                    }
                }
                else if (GameData.Index == 1 || GameData.Index == 2)
                {
                    TopNormalRateGroup.GetChild(GameData.Index).FindChildDepth("FreeParticle").gameObject.SetActive(true);
                    TopNormalRateGroup.GetChild(GameData.Index).FindChildDepth("Light1").gameObject.SetActive(true);
                    TopNormalRateGroup.GetChild(GameData.Index).FindChildDepth("Image").gameObject.SetActive(true);
                    TopNormalRateGroup.GetChild(GameData.Index - 1).FindChildDepth("Light1").gameObject.SetActive(false);
                    TopNormalRateGroup.GetChild(GameData.Index - 1).FindChildDepth("Image").gameObject.SetActive(false);
                }
                else if (GameData.Index > 2)
                {
                    TopNormalRateGroup.GetChild(GameData.Index).FindChildDepth("FreeParticle").gameObject.SetActive(true);
                    TopNormalRateGroup.GetChild(GameData.Index).FindChildDepth("Light1").gameObject.SetActive(true);
                    TopNormalRateGroup.GetChild(GameData.Index).FindChildDepth("Image").gameObject.SetActive(true);
                    TopNormalRateGroup.GetChild(GameData.Index - 1).FindChildDepth("Light1").gameObject.SetActive(false);
                    TopNormalRateGroup.GetChild(GameData.Index - 1).FindChildDepth("Image").gameObject.SetActive(false);
                }

                if (GameData.Index == 1)
                    MJHL_Audio.Instance.PlaySound(MJHL_Audio.MJ_2rate);
                else if (GameData.Index == 2) 
                    MJHL_Audio.Instance.PlaySound(MJHL_Audio.MJ_3rate);
                else if(GameData.Index > 2)
                    MJHL_Audio.Instance.PlaySound(MJHL_Audio.MJ_5rate);


                ToolHelper.DelayRun(0.9f).OnComplete(delegate () 
                {
                    TopNormalRateGroup.GetChild(GameData.Index).FindChildDepth("FreeParticle").gameObject.SetActive(false);
                });
            }
            else
            {
                TopNormalFreeRateGroup.GetChild(GameData.Index).GetComponent<Toggle>().isOn = true;
                if (!TopNormalFreeRateGroup.GetChild(GameData.Index).FindChildDepth("Light1").gameObject.activeSelf && GameData.Index == 0)
                {
                    TopNormalFreeRateGroup.GetChild(GameData.Index).FindChildDepth("FreeParticle").gameObject.SetActive(true);
                    TopNormalFreeRateGroup.GetChild(GameData.Index).FindChildDepth("Light1").gameObject.SetActive(true);
                    TopNormalFreeRateGroup.GetChild(GameData.Index).FindChildDepth("Image").gameObject.SetActive(true);
                }

                if (GameData.Index == 0)
                {
                    TopNormalFreeRateGroup.GetChild(3).FindChildDepth("Light1").gameObject.SetActive(false);
                    TopNormalFreeRateGroup.GetChild(3).FindChildDepth("Image").gameObject.SetActive(false);
                }
                else
                {
                    TopNormalFreeRateGroup.GetChild(GameData.Index - 1).FindChildDepth("Light1").gameObject.SetActive(false);
                    TopNormalFreeRateGroup.GetChild(GameData.Index - 1).FindChildDepth("Image").gameObject.SetActive(false);
                }

                if (GameData.Index == 1)
                    MJHL_Audio.Instance.PlaySound(MJHL_Audio.MJ_4rate);
                else if (GameData.Index == 2)
                    MJHL_Audio.Instance.PlaySound(MJHL_Audio.MJ_6rate);
                else if (GameData.Index > 2)
                    MJHL_Audio.Instance.PlaySound(MJHL_Audio.MJ_10rate);

                ToolHelper.DelayRun(0.9f).OnComplete(delegate ()
                {
                    TopNormalFreeRateGroup.GetChild(GameData.Index).FindChildDepth("FreeParticle").gameObject.SetActive(false);
                });
            }
        }


        #region 状态机
        /// <summary>
        /// 待机状态
        /// </summary>
        private class IdleState : State<MJHLEntry>
        {
            public IdleState(MJHLEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                owner.openAutoBtn.gameObject.SetActive(true);

                if (owner.isStopRoll)
                {
                    owner.startBtn.interactable = true;
                    owner.startBG.GetChild(0).gameObject.SetActive(false);
                    owner.addChipBtn.interactable = true;
                    owner.reduceChipBtn.interactable = true;
                }
            }
        }
        /// <summary>
        /// 初始化状态
        /// </summary>
        private class InitState : State<MJHLEntry>
        {
            public InitState(MJHLEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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

                MJHL_Event.DispatchRefreshGold((long)GameLocalMode.Instance.UserGameInfo.Gold);
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
                if (owner.GameData.SceneData.nFreeCount <= 0)
                {
                    owner.GameData.CurrentChipIndex = GameLocalMode.Instance.UserGameInfo.Gold.CheckNear(owner.GameData.SceneData.nBet);
                }
                owner.GameData.CurrentChip = owner.GameData.SceneData.nBet[owner.GameData.CurrentChipIndex];
                owner.ChipNum.text = (owner.GameData.SceneData.nCurrenBet * MJHL_DataConfig.ALLLINECOUNT).ShortNumber();
                owner.winNum.text = 0.ShortNumber();
                owner.AddListener();
                if (owner.GameData.SceneData.nFreeCount != 0)
                {
                    owner.GameData.CurrentFreeCount = owner.GameData.SceneData.nFreeCount;
                    owner.GameData.CurrentFreeCount--;
                    MJHL_Audio.Instance.PlayBGM(MJHL_Audio.FreeBGM);
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
        private class CheckState : State<MJHLEntry>
        {
            public CheckState(MJHLEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
        private class NormalRollState : State<MJHLEntry>
        {

            public NormalRollState(MJHLEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.startBG.gameObject.SetActive(false);
                owner.startBtn.interactable = false;
                owner.startBG.gameObject.SetActive(true);
                owner.startBG.GetChild(0).gameObject.SetActive(true);
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.openAutoBtn.interactable = false;
                MJHL_Event.DispatchIAllWinGold(0);
                MJHL_Network.Instance.StartGame();
                //MJHL_Audio.Instance.PlaySound(MJHL_Audio.Run);
            }

            public override void Update()
            {
                base.Update();

            }

        }
        private class WaitStopState : State<MJHLEntry>
        {
            public WaitStopState(MJHLEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
        private class AutoRollState : State<MJHLEntry>
        {
            public AutoRollState(MJHLEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();

                owner.startBtn.interactable = false;
                owner.openAutoBtn.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.openAutoBtn.gameObject.SetActive(false);
                owner.closeAutoBtn.gameObject.SetActive(true);

                owner.AutoCountNum.text = owner.GameData.CurrentAutoCount > 1000 ? "w".ShowRichText() : owner.GameData.CurrentAutoCount.ShowRichText();
                owner.AutoCount.gameObject.SetActive(true);

                if (owner.isStopRoll)
                {
                    MJHL_Network.Instance.StartGame();
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
        private class EnterFreeState : State<MJHLEntry>
        {
            bool isEnterFreeGame = false;
            float _time = 0f;
            public EnterFreeState(MJHLEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.Behaviour.StartCoroutine(PlayFreeIcon());
            }

            IEnumerator PlayFreeIcon()
            {
                yield return new WaitForEndOfFrame();
                isEnterFreeGame = true;
                _time = 0f;
                owner.GameData.isFreeGame = true;

                owner.EnterFree.gameObject.SetActive(true);
                owner.GameData.CurrentFreeCount = owner.GameData.ResultData.nFreeCount;
                owner.EnterFreeNum.text = owner.GameData.CurrentFreeCount.ShowRichText();
                owner.freeModeNum.text = owner.GameData.CurrentFreeCount.ShowRichText();
                owner.GameData.TotalFreeWin = 0;
                owner.EnterFreeBtn.onClick.RemoveAllListeners();
                owner.EnterFreeBtn.onClick.Add(() =>
                {
                    OnClickCloseEnterFree();
                });
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
                        OnClickCloseEnterFree();
                    }
                }
            }

            private void OnClickCloseEnterFree()
            {
                _time = 0;
                isEnterFreeGame = false;
                owner.normalBG.gameObject.SetActive(false);
                owner.freeBG.gameObject.SetActive(true);
                owner.AutoCount.gameObject.SetActive(false);
                owner.startBtn.gameObject.SetActive(false);
                owner.openAutoBtn.gameObject.SetActive(false);
                owner.addChipBtn.gameObject.SetActive(false);
                owner.reduceChipBtn.gameObject.SetActive(false);
                owner.ContentBtn.gameObject.SetActive(false);
                owner.freeMode.gameObject.SetActive(true);
                owner.TopNormal.gameObject.SetActive(false);
                owner.TopNormalFree.gameObject.SetActive(true);
                owner.bottomnormalMode.gameObject.SetActive(false);
                owner.NormalImage.gameObject.SetActive(false);
                owner.bottomFreeMode.gameObject.SetActive(true);
                owner.FreeImage.gameObject.SetActive(true);
                owner.BtnInfo1.gameObject.SetActive(false);
                owner.BtnInfo2.gameObject.SetActive(false);
                MJHL_Audio.Instance.PlayBGM(MJHL_Audio.FreeBGM);
                owner.EnterFree.gameObject.SetActive(false);
                MJHL_Event.DispatchISShow_FreeTIP(true);

                hsm?.ChangeState(nameof(CheckState));
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
        private class FreeRollState : State<MJHLEntry>
        {
            public FreeRollState(MJHLEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.normalBG.gameObject.SetActive(false);
                owner.freeBG.gameObject.SetActive(true);
                owner.AutoCount.gameObject.SetActive(false);
                owner.startBtn.gameObject.SetActive(false);
                owner.openAutoBtn.gameObject.SetActive(false);
                owner.addChipBtn.gameObject.SetActive(false);
                owner.reduceChipBtn.gameObject.SetActive(false);
                owner.ContentBtn.gameObject.SetActive(false);
                owner.freeMode.gameObject.SetActive(true);
                owner.TopNormal.gameObject.SetActive(false);
                owner.TopNormalFree.gameObject.SetActive(true);
                owner.EnterFree.gameObject.SetActive(false);
                MJHL_Event.DispatchISShow_FreeTIP(true);
                owner.GameData.isFreeGame = true;

                owner.bottomnormalMode.gameObject.SetActive(false);
                owner.NormalImage.gameObject.SetActive(false);
                owner.bottomFreeMode.gameObject.SetActive(true);
                owner.FreeImage.gameObject.SetActive(true);

                owner.freeModeNum.text = owner.GameData.CurrentFreeCount.ShowRichText();
                owner.freeMode.gameObject.SetActive(true);
                owner.FreeMove.gameObject.SetActive(true);
                MJHL_Network.Instance.StartGame();

            }
            public override void Update()
            {
                base.Update();
            }
        }

        /// <summary>
        /// 免费结算
        /// </summary>
        private class FreeResultState : State<MJHLEntry>
        {
            float _time = 0f;
            public FreeResultState(MJHLEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                _time = 0f;
                owner.GameData.isFreeGame = false;
                owner.ExitFreeNum.text= owner.GameData.TotalFreeWin.ShortNumber().ShowRichText();
                owner.ExitFree.gameObject.SetActive(true);
                owner.ExitFreeCloseBtn.onClick.RemoveAllListeners();
                owner.ExitFreeCloseBtn.onClick.Add(OnClickCloseFreeResult);
            }

            public override void Update()
            {
                base.Update();
                _time += Time.deltaTime;
                if (_time>=5f)
                {
                    _time = 0;
                    OnClickCloseFreeResult();
                }
            }

            private void OnClickCloseFreeResult()
            {
                owner.normalBG.gameObject.SetActive(true);
                owner.bottomnormalMode.gameObject.SetActive(true);
                owner.NormalImage.gameObject.SetActive(true);
                owner.bottomFreeMode.gameObject.SetActive(false);
                owner.FreeImage.gameObject.SetActive(false);

                owner.freeBG.gameObject.SetActive(false);
                owner.freeMode.gameObject.SetActive(false);
                owner.ExitFree.gameObject.SetActive(false);
                owner.AutoCount.gameObject.SetActive(true);
                owner.startBtn.gameObject.SetActive(true);
                owner.openAutoBtn.gameObject.SetActive(true);
                owner.addChipBtn.gameObject.SetActive(true);
                owner.reduceChipBtn.gameObject.SetActive(true);
                owner.ContentBtn.gameObject.SetActive(true);
                owner.TopNormal.gameObject.SetActive(true);
                owner.TopNormalFree.gameObject.SetActive(false);
                owner.FreeMove.gameObject.SetActive(false);
                owner.FreeMove.FindChildDepth("MoveIcon").gameObject.SetActive(false);
                owner.FreeMove.FindChildDepth("Loong").gameObject.SetActive(false);
                MJHLEntry.Instance.GameData.TotalFreeWin = 0;
                MJHL_Audio.Instance.PlayBGM();
                MJHL_Event.DispatchISShow_FreeTIP(false);
                owner.BtnInfo1.gameObject.SetActive(true);
                owner.BtnInfo2.gameObject.SetActive(true);
                hsm?.ChangeState(nameof(CheckState));
            }

        }

        #endregion
    }
}
