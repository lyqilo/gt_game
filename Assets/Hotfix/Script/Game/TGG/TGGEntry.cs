

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

namespace Hotfix.TGG
{
    /// <summary>
    /// 游戏主入口
    /// </summary>
    public class TGGEntry : SingletonILEntity<TGGEntry>
    {
        public Data GameData { get; set; }

        public Transform MainContent;
        private Transform normalBackground;
        public Transform RollContent;
        public Transform freeBackground;
        public TextMeshProUGUI freeShowCount;

        private TextMeshProUGUI chipNum;
        private TextMeshProUGUI allChipInfo;       
        private Button reduceChipBtn;
        private Button addChipBtn;
        private Button startBtn;
        
        private TextMeshProUGUI gold;
        public Transform WinInfo;
        public TextMeshProUGUI WinInfoNum;

        private Transform rulePanel;
        private Transform resultPanel;
        private Transform Sounds;

        public Transform Icons;
        public Transform effectPool;

        public Transform RERoll;

        HierarchicalStateMachine hsm;
        List<IState> states;

        Button showRuleBtn;
        Transform normalBot;
        Transform freeBot;
        Transform btnGroup;
        TextMeshProUGUI freeText;
        Button AutoStartBtn;
        Button closeGame;
        Button soundBtn;
        //Button closeGame;
        Transform soundOn;
        Transform soundOff;
        public Transform effectList;
        public Transform CSGroup;
        public bool isRoll = false;

        Transform EnterFreeEffect;
        TextMeshProUGUI EnterFreeCount;
        Transform FreeResultEffect;
        TextMeshProUGUI FreeResultNum;

        protected override void Awake()
        {
            base.Awake();
            DebugHelper.Log("---------------OnAwake--------------");
            Screen.orientation = ScreenOrientation.Landscape;
            Screen.autorotateToLandscapeLeft = true;
            Screen.autorotateToLandscapeRight = true;
            Screen.autorotateToPortrait = false;
            Screen.autorotateToPortraitUpsideDown = false;
            GameData = new Data();
            gameObject.AddILComponent<TGG_Network>();
            gameObject.AddILComponent<TGG_Audio>();
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
            rulePanel.gameObject.AddILComponent<TGG_Rule>();
            resultPanel.gameObject.AddILComponent<TGG_Result>();
            RollContent.gameObject.AddILComponent<TGG_Roll>();
            RollContent.gameObject.AddILComponent<TGG_Line>();
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
        }

        protected override void AddEvent()
        {
            TGG_Event.RefreshGold += TJZ_Event_RefreshGold;
            TGG_Event.OnGetSceneData += TJZ_Event_OnGetSceneData;
            TGG_Event.ShowResultComplete += TJZ_Event_ShowResultComplete;
            TGG_Event.OnChangeBet += TJZ_Event_OnChangeBet;
            TGG_Event.OnChangeJackPot += TJZ_Event_OnChangeJackPot;
            TGG_Event.RollPrepreaComplete += TJZ_Event_RollPrepreaComplete;
            TGG_Event.RollComplete += TJZ_Event_RollComplete;
            TGG_Event.RollFailed += TJZ_Event_RollFailed;
            TGG_Event.ShowResult += TJZ_Event_ShowResult;
            TGG_Event.StartRoll += TJZ_Event_ShowResultZero;

        }
        protected override void RemoveEvent()
        {
            TGG_Event.RefreshGold -= TJZ_Event_RefreshGold;
            TGG_Event.OnGetSceneData -= TJZ_Event_OnGetSceneData;
            TGG_Event.ShowResultComplete -= TJZ_Event_ShowResultComplete;
            TGG_Event.OnChangeBet -= TJZ_Event_OnChangeBet;
            TGG_Event.OnChangeJackPot += TJZ_Event_OnChangeJackPot;
            TGG_Event.RollPrepreaComplete -= TJZ_Event_RollPrepreaComplete;
            TGG_Event.RollComplete -= TJZ_Event_RollComplete;
            TGG_Event.RollFailed -= TJZ_Event_RollFailed;
            TGG_Event.ShowResult -= TJZ_Event_ShowResult;
            TGG_Event.StartRoll -= TJZ_Event_ShowResultZero;

        }

        protected override void FindComponent()
        {
            MainContent = transform.FindChildDepth("MainPanel");

            normalBackground = MainContent.FindChildDepth("Content/MainBackground");
            freeBackground = MainContent.FindChildDepth("Content/FreeBackground");
            freeShowCount = freeBackground.transform.FindChildDepth<TextMeshProUGUI>("Count");
            RollContent = MainContent.FindChildDepth("Content/RollContent"); //转动区域
            gold = MainContent.FindChildDepth<TextMeshProUGUI>("Content/Bottom/Gold/Num"); //自身金币
            chipNum = MainContent.FindChildDepth<TextMeshProUGUI>("Content/Bottom/Chip/Num"); //下注金额
            WinInfo = MainContent.FindChildDepth("Content/Bottom/Win");
            WinInfoNum = MainContent.FindChildDepth<TextMeshProUGUI>("Content/Bottom/Win/Num"); //本次获得金币
            WinInfoNum.SetText("");
            showRuleBtn = MainContent.FindChildDepth<Button>("Content/Bottom/RuleBtn"); //规则
            normalBot = MainContent.FindChildDepth("Content/Bottom/MainBottom");
            freeBot = MainContent.FindChildDepth("Content/Bottom/FreeBottom");
            reduceChipBtn = MainContent.FindChildDepth<Button>("Content/Bottom/Chip/Reduce"); //减注
            addChipBtn = MainContent.FindChildDepth<Button>("Content/Bottom/Chip/Add"); //加注
            btnGroup = MainContent.FindChildDepth("Content/ButtonGroup");
            startBtn = btnGroup.FindChildDepth<Button>("StartBtn"); //开始按钮
            startBtn.transform.FindChildDepth("On").gameObject.SetActive(true);
            startBtn.transform.FindChildDepth("Off").gameObject.SetActive(false);
            freeText = btnGroup.transform.FindChildDepth<TextMeshProUGUI>("FreeCount"); //免费次数
            AutoStartBtn = btnGroup.FindChildDepth<Button>("AutoStart"); //打开自动开始界面
            AutoStartBtn.transform.FindChildDepth("On").gameObject.SetActive(true);
            AutoStartBtn.transform.FindChildDepth("Off").gameObject.SetActive(false);
            rulePanel = MainContent.FindChildDepth("Content/Rule"); //规则界面
            closeGame = MainContent.FindChildDepth<Button>("Content/BackBtn");
            soundBtn = MainContent.FindChildDepth<Button>("Content/SoundBtn");
            soundOn = soundBtn.transform.FindChildDepth("On");
            soundOff = soundBtn.transform.FindChildDepth("Off");
            soundOn.gameObject.SetActive(MusicManager.isPlayMV);
            soundOff.gameObject.SetActive(!MusicManager.isPlayMV);
            resultPanel = MainContent.FindChildDepth("Content/Result"); //中奖后特效
            Icons = MainContent.FindChildDepth("Content/Icons"); //图标库
            effectList = MainContent.FindChildDepth("Content/EffectList"); //动画库
            effectPool = MainContent.FindChildDepth("Content/EffectPool"); //动画缓存库
            CSGroup = MainContent.FindChildDepth("Content/CSContent"); //显示财神

            EnterFreeEffect = MainContent.FindChildDepth("Content/Result/EnterFree");
            EnterFreeCount = EnterFreeEffect.FindChildDepth<TextMeshProUGUI>("Content/FreeCount");
            FreeResultEffect = MainContent.FindChildDepth("Content/Result/FreeResult");
            FreeResultNum = FreeResultEffect.FindChildDepth <TextMeshProUGUI>("Num");

        }
        private void AddListener()
        {
            reduceChipBtn.onClick.RemoveAllListeners();
            reduceChipBtn.onClick.Add(ReduceChipCall);
            addChipBtn.onClick.RemoveAllListeners();
            addChipBtn.onClick.Add(AddChipCall);
            startBtn.onClick.RemoveAllListeners();
            startBtn.onClick.Add(StartGameCall);

            closeGame.onClick.RemoveAllListeners();
            closeGame.onClick.Add(CloseGameCall);

            soundBtn.onClick.RemoveAllListeners();
            soundBtn.onClick.Add(delegate ()
            {
                SetSounds();
            });

            AutoStartBtn.onClick.RemoveAllListeners();
            AutoStartBtn.onClick.Add(OnClickAutoCall);

            showRuleBtn.onClick.RemoveAllListeners();
            showRuleBtn.onClick.Add(ShowRulePanel);
        }

        private void TJZ_Event_RefreshGold(long gold)
        {
            GameData.myGold = gold;
            this.gold.text = GameData.myGold.ShortNumber().ShowRichText();
        }

        private void TJZ_Event_OnGetSceneData()
        {
            hsm?.ChangeState(nameof(InitState));
        }

        private void TJZ_Event_ShowResultComplete()
        {
            //TODO 收分做跳跃动画
            hsm?.ChangeState(nameof(CheckState));
            TGG_Event.DispatchRefreshGold((long)GameLocalMode.Instance.UserGameInfo.Gold);
        }

        private void TJZ_Event_OnChangeBet()
        {
            chipNum.text = (GameData.CurrentChip * 30).ShortNumber().ShowRichText();
        }

        private void TJZ_Event_OnChangeJackPot()
        {
            //JackPotInfoNum.text = ToolHelper.ShowRichText(GameData.JackPotNum);
        }

        private void TJZ_Event_RollComplete()
        {
            TGG_Event.DispatchShowResult();
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
            WinInfoNum.text = GameData.ResultData.WinScore.ShortNumber().ShowRichText();
        }

        private void TJZ_Event_ShowResultZero()
        {
           // WinInfoNum.text = ToolHelper.ShowRichText(0);
        }

        public void FQGY_Event_ShowResultNum(bool b)
        {
            isRoll = b;
        }

        /// <summary>
        /// 加注
        /// </summary>
        private void AddChipCall()
        {
            TGG_Audio.Instance.PlaySound(TGG_Audio.ADDBET);
            //加注
            GameData.CurrentChipIndex = GameData.CurrentChipIndex + 1;
            if (GameData.CurrentChipIndex >= GameData.SceneData.chipList.Count)
            {
                GameData.CurrentChipIndex = 0;
            }
            GameData.CurrentChip = GameData.SceneData.chipList[GameData.CurrentChipIndex];
            TGG_Event.DispatchOnChangeBet();
        }

        /// <summary>
        /// 减注
        /// </summary>
        private void ReduceChipCall()
        {
            TGG_Audio.Instance.PlaySound(TGG_Audio.REDUCEBET);
            GameData.CurrentChipIndex = GameData.CurrentChipIndex - 1;
            if (GameData.CurrentChipIndex <= 0) 
            {
                GameData.CurrentChipIndex = GameData.SceneData.chipList.Count-1;
            }
            GameData.CurrentChip = GameData.SceneData.chipList[GameData.CurrentChipIndex];
            TGG_Event.DispatchOnChangeBet();
        }

        //开始游戏
        private void StartGameCall()
        {
            if (GameData.isFreeGame || GameData.isAutoGame) return;

            if (!isRoll)
            {
                StopGame();
                return;
            }

            TGG_Audio.Instance.PlaySound(TGG_Audio.BTN);

            if (TGGEntry.Instance.GameData.myGold < TGGEntry.Instance.GameData.CurrentChip * TGG_DataConfig.ALLLINECOUNT && !TGGEntry.Instance.GameData.isFreeGame)
            {
                ToolHelper.PopBigWindow(new BigMessage()
                {
                    content = "Insufficient gold coins, please recharge",
                    okCall = delegate ()
                    {
                        TGG_Event.DispatchRollFailed();
                    },
                    cancelCall = delegate ()
                    {
                        TGG_Event.DispatchRollFailed();
                    }
                });
                return;
            }

            startBtn.transform.FindChildDepth("On").gameObject.SetActive(false);
            startBtn.transform.FindChildDepth("Off").gameObject.SetActive(true);
            hsm?.ChangeState(nameof(NormalRollState));
            //TGG_Network.Instance.StartGame();
        }

        private void StopGame()
        {
            TGG_Audio.Instance.PlaySound(TGG_Audio.BTN);
            startBtn.interactable = false;
            TGG_Event.DispatchStopRoll(true);
        }
        /// <summary>
        /// 显示规则界面
        /// </summary>
        private void ShowRulePanel()
        {
            TGG_Audio.Instance.PlaySound(TGG_Audio.BTN);
            rulePanel.gameObject.SetActive(true);
        }

        private void SetSounds()
        {
            if (!MusicManager.isPlayMV)
            {
                ToolHelper.PlaySound();
                ToolHelper.PlayMusic();
                TGG_Audio.Instance.ResetSound();
                TGG_Audio.Instance.PlaySound(TGG_Audio.BTN);
            }
            else
            {
                ToolHelper.MuteMusic();
                ToolHelper.MuteSound();
                TGG_Audio.Instance.MuteSound();
            }
            soundOn.gameObject.SetActive(MusicManager.isPlayMV);
            soundOff.gameObject.SetActive(!MusicManager.isPlayMV);
        }

        /// <summary>
        /// 退出游戏
        /// </summary>
        private void CloseGameCall()
        {
            TGG_Audio.Instance.PlaySound(TGG_Audio.BTN);
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
        /// 停止自动旋转
        /// </summary>
        private void StopAutoGame()
        {
            GameData.isAutoGame = false;
            GameData.CurrentAutoCount = 0;
            AutoStartBtn.transform.FindChildDepth("On").gameObject.SetActive(true);
            AutoStartBtn.transform.FindChildDepth("Off").gameObject.SetActive(false);
            addChipBtn.interactable = true;
            reduceChipBtn.interactable = true;
            startBtn.interactable = true;
        }

        /// <summary>
        /// 点击自动开始
        /// </summary>
        /// <param name="state"></param>
        private void OnClickAutoCall()
        {
            TGG_Audio.Instance.PlaySound(TGG_Audio.BTN);
            if (GameData.isAutoGame)
            {
                StopAutoGame();
                return;
            }
            //点击自动开始
            AutoStartCall();
        }

        private void AutoStartCall()
        {
            GameData.CurrentAutoCount = 10000;
            AutoStartBtn.transform.FindChildDepth("On").gameObject.SetActive(false);
            AutoStartBtn.transform.FindChildDepth("Off").gameObject.SetActive(true);
            startBtn.transform.FindChildDepth("On").gameObject.SetActive(true);
            startBtn.transform.FindChildDepth("Off").gameObject.SetActive(false);
            GameData.isAutoGame = true;
            hsm?.ChangeState(nameof(AutoRollState));
        }


        private void FreeGame()
        {
            GameData.isFreeGame = true;
            freeShowCount.text = ("x"+ (12-GameData.currentFreeCount)).ShowRichText();
            TGG_Audio.Instance.PlaySound(GameData.currentFreeCount < 12
                ? $"Freex{GameData.currentFreeCount}"
                : "Freex12");

            freeText.text = GameData.currentFreeCount.ShowRichText();
            TGG_Network.Instance.StartGame();
        }


        #region 状态机
        /// <summary>
        /// 待机状态
        /// </summary>
        private class IdleState : State<TGGEntry>
        {
            public IdleState(TGGEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.GameData.CurrentAutoCount = 0;
                owner.GameData.currentFreeCount = 0;
                owner.startBtn.interactable = true;
                owner.addChipBtn.interactable = true;
                owner.reduceChipBtn.interactable = true;
                owner.GameData.isFreeGame = false;
                owner.freeText.gameObject.SetActive(false);
                owner.startBtn.gameObject.SetActive(true);
                owner.AutoStartBtn.gameObject.SetActive(true);
                owner.normalBackground.gameObject.SetActive(true);
                owner.freeBackground.gameObject.SetActive(false);
                owner.normalBot.gameObject.SetActive(true);
                owner.freeBot.gameObject.SetActive(false);
                owner.startBtn.transform.FindChildDepth("On").gameObject.SetActive(true);
                owner.startBtn.transform.FindChildDepth("Off").gameObject.SetActive(false);
            }
        }
        /// <summary>
        /// 初始化状态
        /// </summary>
        private class InitState : State<TGGEntry>
        {
            public InitState(TGGEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            bool isComplete;
            public override void OnEnter()
            {
                base.OnEnter();
                DebugHelper.Log("-----------场景消息返回------------");
                isComplete = false;
            }
            public override void Update()
            {
                base.Update();
                if (isComplete) return;
                isComplete = true;
                DebugHelper.Log(LitJson.JsonMapper.ToJson(owner.GameData.SceneData));
                TGG_Event.DispatchRefreshGold((long)GameLocalMode.Instance.UserGameInfo.Gold);
                if (owner.GameData.SceneData.bet != 0)
                {
                   owner.GameData.CurrentChipIndex= owner.GameData.SceneData.chipList.FindListIndex(delegate (int match)
                    {
                        return match == owner.GameData.SceneData.bet;
                    });
                }
                else
                {
                    owner.GameData.CurrentChipIndex = 0;
                }

                if (owner.GameData.SceneData.freeNumber <= 0)
                {
                    owner.GameData.CurrentChipIndex = GameLocalMode.Instance.UserGameInfo.Gold.CheckNear(owner.GameData.SceneData.chipList);
                }
                owner.GameData.CurrentChip = owner.GameData.SceneData.chipList[owner.GameData.CurrentChipIndex];
                TGG_Event.DispatchOnChangeBet();
                owner.GameData.JackPotNum = owner.GameData.SceneData.caiJin;
                TGG_Event.DispatchOnChangeJackPot();
                owner.AddListener();
                if(owner.GameData.SceneData.freeNumber > 0 )
                {
                    owner.GameData.currentFreeCount = owner.GameData.SceneData.freeNumber;
                    TGG_Audio.Instance.PlayBGM(TGG_Audio.FreeBGM);
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
        private class CheckState : State<TGGEntry>
        {
            public CheckState(TGGEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                    owner.GameData.currentFreeCount--;
                    if (owner.GameData.currentFreeCount < 0 )//判断免费次数
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
        private class NormalRollState : State<TGGEntry>
        {
            public NormalRollState(TGGEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();

                if (!owner.isRoll)
                {
                    return;
                }
                owner.startBtn.interactable=false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                TGG_Network.Instance.StartGame();
            }
        }

        private class WaitStopState : State<TGGEntry>
        {
            public WaitStopState(TGGEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
        private class AutoRollState : State<TGGEntry>
        {
            public AutoRollState(TGGEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.startBtn.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                if (!owner.isRoll)
                {
                    return;
                }
                TGG_Network.Instance.StartGame();
            }
            public override void Update()
            {
                base.Update();
            }
        }

        /// <summary>
        /// 进入免费
        /// </summary>
        private class EnterFreeState : State<TGGEntry>
        {
            bool isEnterFreeGame = false;
            float _time = 0f;
            public EnterFreeState(TGGEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.normalBackground.gameObject.SetActive(false);
                owner.freeBackground.gameObject.SetActive(true);
                owner.normalBot.gameObject.SetActive(false);
                owner.freeBot.gameObject.SetActive(true);
                owner.startBtn.gameObject.gameObject.SetActive(false);
                owner.AutoStartBtn.gameObject.gameObject.SetActive(false);
                owner.freeText.gameObject.gameObject.SetActive(true);
                owner.GameData.isFreeGame = true;
                _time = 0f;
                owner.GameData.currentFreeCount = owner.GameData.ResultData.nFreeCount;
                owner.EnterFreeEffect.gameObject.SetActive(true);
                owner.EnterFreeCount.text = owner.GameData.currentFreeCount.ShowRichText();
                TGG_Audio.Instance.PlayBGM(TGG_Audio.FreeBGM);
                isEnterFreeGame = true;

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
                        owner.EnterFreeEffect.gameObject.SetActive(false);
                        hsm?.ChangeState(nameof(CheckState));
                    }
                }
            }
        }
        /// <summary>
        /// 免费
        /// </summary>
        private class FreeRollState : State<TGGEntry>
        {
            public FreeRollState(TGGEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.normalBackground.gameObject.SetActive(false);
                owner.freeBackground.gameObject.SetActive(true);
                owner.normalBot.gameObject.SetActive(false);
                owner.freeBot.gameObject.SetActive(true);
                owner.startBtn.gameObject.gameObject.SetActive(false);
                owner.AutoStartBtn.gameObject.gameObject.SetActive(false);
                owner.freeText.gameObject.gameObject.SetActive(true);
                owner.freeText.text = owner.GameData.currentFreeCount.ShowRichText();
                owner.FreeGame();
                owner.startBtn.interactable = false;
                owner.startBtn.gameObject.SetActive(false);
                owner.AutoStartBtn.gameObject.SetActive(false);
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.freeBackground.gameObject.SetActive(true);
                owner.GameData.isFreeGame = true;
                TGG_Network.Instance.StartGame();
            }
            public override void Update()
            {
                base.Update();
            }
        }
        /// <summary>
        /// 免费结算
        /// </summary>
        private class FreeResultState : State<TGGEntry>
        {
            float _time = 0f;
            bool isFreeResultGame;
            public FreeResultState(TGGEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                _time = 0f;
                isFreeResultGame = false;
                owner.GameData.isFreeGame = false;
                owner.FreeResultEffect.gameObject.SetActive(true);
                ToolHelper.RunGoal(0, TGGEntry.Instance.GameData.TotalFreeWin, TGG_DataConfig.winBigGoldChangeRate, delegate (string goal)
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
                TGGEntry.Instance.GameData.TotalFreeWin = 0;
                owner.FreeResultEffect.gameObject.SetActive(false);
                owner.freeBackground.gameObject.SetActive(false);
                owner.startBtn.gameObject.SetActive(true);
                owner.AutoStartBtn.gameObject.SetActive(true);
                owner.normalBackground.gameObject.SetActive(true);
                owner.freeBackground.gameObject.SetActive(false);
                owner.normalBot.gameObject.SetActive(true);
                owner.freeBot.gameObject.SetActive(false);
                owner.freeText.gameObject.gameObject.SetActive(false);
                owner.GameData.isFreeGame = false;
                TGG_Audio.Instance.PlayBGM();
                hsm?.ChangeState(nameof(CheckState));
            }
        }
        #endregion
    }
}
