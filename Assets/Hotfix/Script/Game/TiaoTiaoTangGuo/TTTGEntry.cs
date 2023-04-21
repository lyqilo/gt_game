using System.Collections.Generic;
using DG.Tweening;
using Spine.Unity;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.TiaoTiaoTangGuo
{
    /// <summary>
    /// 跳跳糖果启动类
    /// </summary>
    public class TTTGEntry : SingletonILEntity<TTTGEntry>
    {
        public Data GameData { get; set; }
        private List<IState> states;
        private HierarchicalStateMachine hsm;

        private Transform mainPanel;
        private Transform resultPanel;
        private Transform helpPanel;
        private Transform settingPanel;
        private Transform effectPool;
        private Transform effectCache;
        private Transform iconPool;

        private Transform normalRollTrans;
        private Transform freeRollTrans;
        private Button helpBtn;
        private Button betBtn;
        private SkeletonGraphic betAnim;
        private TextMeshProUGUI betNum;
        private TextMeshProUGUI totalBetNum;
        private Button autoBtn;
        private SkeletonGraphic autoAnim;
        private TextMeshProUGUI autoNum;
        private Button startBtn;
        private TextMeshProUGUI freeNum;
        private Transform betOption;
        private Transform autoOption;
        private TextMeshProUGUI jackpotNum;
        private Image headImg;
        private TextMeshProUGUI idNum;
        private TextMeshProUGUI goldNum;
        private Button quitBtn;
        private Button settingBtn;

        private bool isInitBetOption;
        private bool isInitAutoOption;
        private SkeletonGraphic startAnim;


        private TTTG_Network _networkManager;
        private TTTG_Audio _audioManager;
        private TTTG_Rule _ruleController;
        private TTTG_Result _resultController;
        private TTTG_Setting _settingController;
        private TTTG_NormalRoll _normalRollController;
        private TTTG_FreeRoll _freeRollManager;

        public Transform flyGoldTrans;
        public Transform cacheGroup;
        private ScrollRect moveGroup;


        protected override void Awake()
        {
            base.Awake();
            Screen.orientation = ScreenOrientation.Landscape;
            Screen.autorotateToLandscapeLeft = true;
            Screen.autorotateToLandscapeRight = true;
            Screen.autorotateToPortrait = false;
            Screen.autorotateToPortraitUpsideDown = false;
            DOTween.defaultEaseType = Ease.Linear;
            GameData = new Data();
            AddListener();
            normalRollTrans.gameObject.AddILComponent<TTTG_NormalRoll>();
            freeRollTrans.gameObject.AddILComponent<TTTG_FreeRoll>();
            gameObject.AddILComponent<TTTG_Network>();
            GameObject audioPool = new GameObject("AudioPool");
            audioPool.transform.SetParent(transform);
            audioPool.AddILComponent<TTTG_Audio>();
            helpPanel.gameObject.AddILComponent<TTTG_Rule>();
            settingPanel.gameObject.AddILComponent<TTTG_Setting>();
            resultPanel.gameObject.AddILComponent<TTTG_Result>();
            Init();
            TTTG_Audio.Instance.PlayBGM();
        }

        protected override void Start()
        {
            base.Start();
            hsm = new HierarchicalStateMachine(false, gameObject);
            states = new List<IState>()
            {
                new IdleState(this, hsm),
                new NormalRollState(this, hsm),
                new AutoRollState(this, hsm),
                new FreeRollState(this, hsm),
                new CheckState(this, hsm),
            };
            hsm?.Init(states, nameof(IdleState));
        }

        protected override void Update()
        {
            base.Update();
            hsm?.Update();
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            hsm?.CurrentState.OnExit();
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            mainPanel = transform.FindChildDepth("MainPanel");
            resultPanel = transform.FindChildDepth("ShowRewardPanel");
            helpPanel = transform.FindChildDepth("HelperPanel");
            settingPanel = transform.FindChildDepth("SettingPanel");
            effectPool = transform.FindChildDepth("EffectPool/Pool");
            effectCache = transform.FindChildDepth("EffectPool/Cache");
            iconPool = transform.FindChildDepth("IconGroup");
            cacheGroup = transform.FindChildDepth($"Cache");

            
            moveGroup = mainPanel.FindChildDepth<ScrollRect>("Scroll");
            RectTransform rect = moveGroup.content;
            float rate = (Screen.width / (float) Screen.height) * 720;
            rect.offsetMax = new Vector2(rate, 0);
            normalRollTrans = mainPanel.FindChildDepth("NormalGame");
            freeRollTrans = mainPanel.FindChildDepth("FreeGame");

            Transform bottomBtnGroup = mainPanel.FindChildDepth("Menu/ButtomMenu");
            Transform topBtnGroup = mainPanel.FindChildDepth("Menu/TopMenu");
            helpBtn = bottomBtnGroup.FindChildDepth<Button>("HelpBtn");
            betBtn = bottomBtnGroup.FindChildDepth<Button>("BetBtn");
            betAnim = bottomBtnGroup.FindChildDepth<SkeletonGraphic>("BetBtn");
            betNum = betBtn.transform.FindChildDepth<TextMeshProUGUI>("Num");
            totalBetNum = bottomBtnGroup.FindChildDepth<TextMeshProUGUI>("TotalBet/Num");
            autoBtn = bottomBtnGroup.FindChildDepth<Button>("AutoBtn");
            autoAnim = bottomBtnGroup.FindChildDepth<SkeletonGraphic>("AutoBtn");
            autoNum = autoBtn.transform.FindChildDepth<TextMeshProUGUI>("Num");
            startBtn = bottomBtnGroup.FindChildDepth<Button>("StartBtn");
            startAnim = bottomBtnGroup.FindChildDepth<SkeletonGraphic>("StartBtn");
            freeNum = startBtn.transform.FindChildDepth<TextMeshProUGUI>("Num");
            betOption = bottomBtnGroup.FindChildDepth("BetOption");
            autoOption = bottomBtnGroup.FindChildDepth("AutoOption");

            jackpotNum = topBtnGroup.FindChildDepth<TextMeshProUGUI>("Jackpot/Num");
            headImg = topBtnGroup.FindChildDepth<Image>("PlayinfoBox/Head");
            idNum = topBtnGroup.FindChildDepth<TextMeshProUGUI>("PlayinfoBox/Name/Num");
            goldNum = topBtnGroup.FindChildDepth<TextMeshProUGUI>("PlayinfoBox/Gold/Num");
            flyGoldTrans = topBtnGroup.FindChildDepth("PlayinfoBox/Gold/Icon");
            quitBtn = topBtnGroup.FindChildDepth<Button>("QuitBtn");
            settingBtn = topBtnGroup.FindChildDepth<Button>("SettingBtn");
        }

        private void AddListener()
        {
            helpBtn.onClick.RemoveAllListeners();
            helpBtn.onClick.Add(OnClickHelpCall);
            settingBtn.onClick.RemoveAllListeners();
            settingBtn.onClick.Add(OnClickSettingCall);
            quitBtn.onClick.RemoveAllListeners();
            quitBtn.onClick.Add(OnClickQuitCall);

            startBtn.onClick.RemoveAllListeners();
            startBtn.onClick.Add(OnClickStartCall);

            autoBtn.onClick.RemoveAllListeners();
            autoBtn.onClick.Add(OnClickAutoCall);

            betBtn.onClick.RemoveAllListeners();
            betBtn.onClick.Add(OnClickBetCall);
        }

        protected override void AddEvent()
        {
            base.AddEvent();
            TTTG_Event.OnReceiveSceneInfo += TTTG_EventOnOnReceiveSceneInfo;
            TTTG_Event.OnJackpotChanged += TTTG_EventOnOnJackpotChanged;
            TTTG_Event.OnBetChanged += TTTG_EventOnOnBetChanged;
            TTTG_Event.OnReceiveResult += TTTG_EventOnOnReceiveResult;
            TTTG_Event.OnShowResultComplete += TTTG_EventOnOnShowResultComplete;
            TTTG_Event.OnResetGame += TTTG_EventOnOnResetGame;
            TTTG_Event.OnUserScoreChanged += TTTG_EventOnOnUserScoreChanged;
            TTTG_Event.ChangeUserGold += TTTG_EventOnChangeUserGold;
            TTTG_Event.MoveScreen += TTTG_EventOnMoveScreen;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            TTTG_Event.OnReceiveSceneInfo -= TTTG_EventOnOnReceiveSceneInfo;
            TTTG_Event.OnJackpotChanged -= TTTG_EventOnOnJackpotChanged;
            TTTG_Event.OnBetChanged -= TTTG_EventOnOnBetChanged;
            TTTG_Event.OnReceiveResult -= TTTG_EventOnOnReceiveResult;
            TTTG_Event.OnShowResultComplete -= TTTG_EventOnOnShowResultComplete;
            TTTG_Event.OnResetGame -= TTTG_EventOnOnResetGame;
            TTTG_Event.OnUserScoreChanged -= TTTG_EventOnOnUserScoreChanged;
            TTTG_Event.ChangeUserGold -= TTTG_EventOnChangeUserGold;
            TTTG_Event.MoveScreen -= TTTG_EventOnMoveScreen;
        }

        private void Init()
        {
            idNum.text = ToolHelper.ShowRichText(GameLocalMode.Instance.SCPlayerInfo.DwUser_Id);
            headImg.sprite = ILGameManager.Instance.GetHeadIcon();
            autoOption.gameObject.SetActive(false);
            betOption.gameObject.SetActive(false);
            helpPanel.gameObject.SetActive(false);
            settingPanel.gameObject.SetActive(false);
        }

        /// <summary>
        /// 获取特效
        /// </summary>
        /// <param name="effectName">特效名</param>
        /// <param name="parent">父物体</param>
        /// <returns></returns>
        public Transform GetEffect(string effectName, Transform parent)
        {
            Transform eff = effectCache.FindChildDepth(effectName);
            if (eff == null)
            {
                Transform _eff = effectPool.FindChildDepth(effectName);
                if (_eff == null)
                {
                    DebugHelper.LogError($"没有找到{effectName}特效");
                    return null;
                }

                eff = Object.Instantiate(_eff.gameObject, parent).transform;
                eff.gameObject.name = effectName;
            }

            eff.SetParent(parent);
            eff.localPosition = Vector3.one;
            eff.localRotation = Quaternion.identity;
            eff.localScale = Vector3.one;
            return eff;
        }

        /// <summary>
        /// 回收特效
        /// </summary>
        /// <param name="effect">特效</param>
        public void CollectEffect(GameObject effect)
        {
            effect.transform.SetParent(effectCache);
            effect.SetActive(false);
        }

        #region ui事件

        /// <summary>
        /// 点击设置按钮
        /// </summary>
        private void OnClickSettingCall()
        {
            TTTG_Audio.Instance.PlaySound(TTTG_Audio.Candybreak_Click);
            settingPanel.gameObject.SetActive(true);
            settingPanel.localScale = Vector3.one;
        }

        /// <summary>
        /// 点击退出按钮
        /// </summary>
        private void OnClickQuitCall()
        {
            if (GameData.isFreeGame)
            {
                ToolHelper.PopSmallWindow($"特殊模式中，不能退出游戏!");
                return;
            }
            TTTG_Audio.Instance.PlaySound(TTTG_Audio.Candybreak_Click);

            HotfixActionHelper.DispatchLeaveGame();
        }

        /// <summary>
        /// 点击开始按钮
        /// </summary>
        private void OnClickStartCall()
        {
            if (GameData.isFreeGame || GameData.isAutoGame) return;
            if (!hsm.CurrentStateName.Equals(nameof(IdleState))) return;
            startAnim.AnimationState.ClearTracks();
            startAnim.AnimationState.SetAnimation(0, $"spin_click", false);
            startAnim.AnimationState.AddAnimation(0, $"spin_disable", true, 0);
            startBtn.interactable = false;
            TTTG_Audio.Instance.PlaySound(TTTG_Audio.Candybreak_SpinClick);
            hsm?.ChangeState(nameof(NormalRollState));
        }

        /// <summary>
        /// 点击下注按钮
        /// </summary>
        private void OnClickBetCall()
        {
            if (!InitBetOption()) return;
            TTTG_Audio.Instance.PlaySound(TTTG_Audio.Candybreak_Click);
            betOption.gameObject.SetActive(true);
        }

        /// <summary>
        /// 初始化下注界面
        /// </summary>
        private bool InitBetOption()
        {
            if (GameData.SceneData == null) return isInitBetOption;
            if (isInitBetOption) return isInitBetOption;
            for (int i = 0; i < betOption.childCount; i++)
            {
                betOption.GetChild(i).gameObject.SetActive(false);
            }

            GameData.CurrentChipIndex = 0;
            if (GameData.SceneData.nCurrenBet != 0)
            {
                GameData.CurrentChipIndex =
                    GameData.SceneData.nBet.FindListIndex(p => p == GameData.SceneData.nCurrenBet);
            }

            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            TTTG_Event.DispatchOnBetChanged(GameData.CurrentChip);
            Transform betOptionGroup = betOption.FindChildDepth($"Group");
            Button maskBtn = betOption.FindChildDepth<Button>($"mask");
            maskBtn.onClick.RemoveAllListeners();
            maskBtn.onClick.Add(() => { betOption.gameObject.SetActive(false); });
            maskBtn.gameObject.SetActive(true);
            for (int i = 0; i < GameData.SceneData.nBet.Count; i++)
            {
                if (GameData.SceneData.nBet[i] <= 0) continue;
                int index = i;
                GameObject child = betOptionGroup.gameObject.InstantiateChild(index);
                Toggle tog = child.GetComponent<Toggle>();
                TextMeshProUGUI _betNum = tog.transform.FindChildDepth<TextMeshProUGUI>("Num");
                _betNum.text = ToolHelper.ShowRichText(GameData.SceneData.nBet[index]);
                tog.onValueChanged.RemoveAllListeners();
                tog.onValueChanged.Add(isChanged => { OnBetChangedCall(isChanged, index); });
                tog.isOn = GameData.CurrentChipIndex == index;
            }

            betOptionGroup.gameObject.SetActive(true);
            isInitBetOption = true;
            return isInitBetOption;
        }

        /// <summary>
        /// 改变押注
        /// </summary>
        /// <param name="isChanged">是否打开isOn</param>
        /// <param name="index">押注索引</param>
        private void OnBetChangedCall(bool isChanged, int index)
        {
            if (!isChanged) return;
            TTTG_Audio.Instance.PlaySound(TTTG_Audio.Candybreak_Click);
            GameData.CurrentChipIndex = index;
            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            betOption.gameObject.SetActive(false);
            TTTG_Event.DispatchOnBetChanged(GameData.CurrentChip);
        }

        /// <summary>
        /// 点击自动按钮
        /// </summary>
        private void OnClickAutoCall()
        {
            if (GameData.SceneData == null)
            {
                ToolHelper.PopSmallWindow($"初始化数据中……");
                return;
            }

            if (GameData.isAutoGame)
            {
                autoNum.text = "";
                GameData.CurrentAutoCount = 0;
                return;
            }

            if (!InitAutoOption()) return;
            TTTG_Audio.Instance.PlaySound(TTTG_Audio.Candybreak_Click);
            autoOption.gameObject.SetActive(true);
        }

        private bool InitAutoOption()
        {
            if (isInitAutoOption) return isInitAutoOption;
            Transform autoGroup = autoOption.FindChildDepth($"Group");
            Button maskBtn = autoOption.FindChildDepth<Button>($"mask");
            maskBtn.onClick.RemoveAllListeners();
            maskBtn.onClick.Add(() => { autoOption.gameObject.SetActive(false); });
            for (int i = 0; i < TTTG_DataConfig.AutoConfig.Count; i++)
            {
                int index = i;
                GameObject child = autoGroup.gameObject.InstantiateChild(index);
                Button btn = child.GetComponent<Button>();
                TextMeshProUGUI childNum = child.transform.FindChildDepth<TextMeshProUGUI>($"Text");
                childNum.text = ToolHelper.ShowRichText(TTTG_DataConfig.AutoConfig[index]);
                btn.onClick.RemoveAllListeners();
                btn.onClick.Add(() => { OnClickAutoCallItem(TTTG_DataConfig.AutoConfig[index]); });
            }

            isInitAutoOption = true;
            return isInitAutoOption;
        }

        private void OnClickAutoCallItem(int autoCount)
        {
            TTTG_Audio.Instance.PlaySound(TTTG_Audio.Candybreak_Click);
            GameData.CurrentAutoCount = autoCount;
            autoOption.gameObject.SetActive(false);
            if (GameData.isAutoGame || GameData.isFreeGame) return;
            hsm?.ChangeState(nameof(AutoRollState));
        }

        /// <summary>
        /// 点击帮助按钮
        /// </summary>
        private void OnClickHelpCall()
        {
            if (GameData.SceneData == null)
            {
                ToolHelper.PopSmallWindow($"数据初始化中……");
                return;
            }
            TTTG_Audio.Instance.PlaySound(TTTG_Audio.Candybreak_Click);

            helpPanel.gameObject.SetActive(true);
            helpPanel.localScale = Vector3.one;
        }

        #endregion

        #region 事件集合

        private void TTTG_EventOnOnReceiveSceneInfo(TTTG_Struct.SC_SceneInfo obj)
        {
            GameData.SceneData = obj;
            GameData.CurrentFreeCount = GameData.SceneData.nFreeCount;
            GameData.myGold = (long) GameLocalMode.Instance.UserGameInfo.Gold;
            goldNum.text = ToolHelper.ShowRichText($"${GameData.myGold}");
            InitBetOption();
            hsm?.ChangeState(nameof(CheckState));
        }

        private void TTTG_EventOnOnJackpotChanged(long obj)
        {
            DebugHelper.Log($"jackpot:{obj}");
            jackpotNum.text = ToolHelper.ShowRichText($"${obj}");
        }

        private void TTTG_EventOnOnBetChanged(int bet)
        {
            betNum.text = ToolHelper.ShowRichText(bet);
            totalBetNum.text = ToolHelper.ShowRichText(bet * TTTG_DataConfig.LineCount);
        }

        private void TTTG_EventOnOnReceiveResult(TTTG_Struct.CMD_3D_SC_Result obj)
        {
            GameData.ResultData = obj;
            GameData.CurrentFreeCount = obj.nFreeCount;
            if (GameData.isFreeGame) freeNum.text = ToolHelper.ShowRichText(GameData.CurrentFreeCount);
        }

        private void TTTG_EventOnOnShowResultComplete()
        {
            hsm?.ChangeState(nameof(CheckState));
        }

        private void TTTG_EventOnOnResetGame()
        {
            hsm?.ChangeState(nameof(IdleState));
        }

        private void TTTG_EventOnOnUserScoreChanged(GameUserData obj)
        {
            ToolHelper.RunGoal(GameData.myGold, obj.Gold, 0.3f,
                p => { goldNum.text = ToolHelper.ShowRichText($"${p}"); }).OnComplete(() =>
            {
                goldNum.text = ToolHelper.ShowRichText($"${obj.Gold}");
                GameData.myGold = (long) obj.Gold;
                TTTG_Event.DispatchOnShowResultComplete();
            });
        }

        private void TTTG_EventOnChangeUserGold(long obj)
        {
            GameData.myGold = obj;
            goldNum.text = ToolHelper.ShowRichText($"${GameData.myGold}");
        }

        private void TTTG_EventOnMoveScreen(bool isFree)
        {
            float startValue = isFree ? 0 : 1;
            float endValue = isFree ? 1 : 0;
            DOTween.To(value =>
            {
                moveGroup.horizontalNormalizedPosition = value;
            },startValue,endValue,2.5f).OnComplete(() =>
            {
                moveGroup.horizontalNormalizedPosition = endValue;
                if (!isFree)
                {
                    TTTG_Audio.Instance.PlayBGM(TTTG_Audio.BGM);
                }
                TTTG_Event.DispatchMoveScreenComplete(isFree);
            });
        }

        #endregion


        #region 状态机

        /// <summary>
        /// 待机
        /// </summary>
        private class IdleState : State<TTTGEntry>
        {
            public IdleState(TTTGEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.startBtn.interactable = true;
                owner.startAnim.AnimationState.ClearTracks();
                owner.startAnim.AnimationState.SetAnimation(0, $"spin_idle", true);
                owner.autoBtn.interactable = true;
                owner.autoAnim.AnimationState.SetAnimation(0, $"auto", true);
                owner.autoNum.text = "";
                owner.freeNum.text = "";
                owner.GameData.isAutoGame = false;
                owner.GameData.isFreeGame = false;
                owner.betBtn.interactable = true;
                owner.betAnim.AnimationState.ClearTracks();
                owner.betAnim.AnimationState.SetAnimation(0, $"bet", true);
                owner.quitBtn.interactable = true;
                owner.settingBtn.interactable = true;
                owner.helpBtn.interactable = true;
            }
        }

        /// <summary>
        /// 普通开始
        /// </summary>
        private class NormalRollState : State<TTTGEntry>
        {
            public NormalRollState(TTTGEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.betBtn.interactable = false;
                owner.betAnim.AnimationState.ClearTracks();
                owner.betAnim.AnimationState.SetAnimation(0, $"bet_disable", true);
                owner.autoBtn.interactable = false;
                owner.startAnim.AnimationState.ClearTracks();
                owner.startAnim.AnimationState.SetAnimation(0, $"spin_disable", true);
                owner.settingBtn.interactable = false;
                owner.quitBtn.interactable = false;
                owner.helpBtn.interactable = false;
                owner.freeNum.text = "";
                //TODO 发送开始游戏消息
                TTTG_Network.Instance.StartGame();
            }
        }

        /// <summary>
        /// 自动
        /// </summary>
        private class AutoRollState : State<TTTGEntry>
        {
            public AutoRollState(TTTGEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.betBtn.interactable = false;
                owner.betAnim.AnimationState.ClearTracks();
                owner.betAnim.AnimationState.SetAnimation(0, $"bet_disable", true);
                owner.autoBtn.interactable = true;
                owner.startAnim.AnimationState.ClearTracks();
                owner.startAnim.AnimationState.SetAnimation(0, $"spin_disable", true);
                owner.settingBtn.interactable = false;
                owner.quitBtn.interactable = false;
                owner.helpBtn.interactable = false;
                owner.GameData.isAutoGame = true;
                owner.freeNum.text = "";
                owner.autoNum.text = ToolHelper.ShowRichText(owner.GameData.CurrentAutoCount - 1);
                //TODO 发送开始游戏消息
                TTTG_Network.Instance.StartGame();
            }
        }

        /// <summary>
        /// 免费
        /// </summary>
        private class FreeRollState : State<TTTGEntry>
        {
            public FreeRollState(TTTGEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.betBtn.interactable = false;
                owner.betAnim.AnimationState.ClearTracks();
                owner.betAnim.AnimationState.SetAnimation(0, $"bet_disable", true);
                owner.autoBtn.interactable = false;
                owner.startAnim.AnimationState.ClearTracks();
                owner.startAnim.AnimationState.SetAnimation(0, $"freespin_idle", true);
                owner.settingBtn.interactable = false;
                owner.quitBtn.interactable = false;
                owner.helpBtn.interactable = false;
                owner.GameData.isFreeGame = true;
                owner.freeNum.text = ToolHelper.ShowRichText(owner.GameData.CurrentFreeCount);
                //TODO 发送开始游戏消息
                TTTG_Network.Instance.StartGame();
            }
        }

        /// <summary>
        /// 检测当前状态
        /// </summary>
        private class CheckState : State<TTTGEntry>
        {
            public CheckState(TTTGEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                Check();
            }

            private void Check()
            {
                if (owner.GameData.isFreeGame) //如果在免费中
                {
                    //owner.GameData.CurrentFreeCount--;
                    if (owner.GameData.CurrentFreeCount <= 0) //判断免费次数
                    {
                        return;
                    }

                    hsm?.ChangeState(nameof(FreeRollState));
                    return;
                }

                if (owner.GameData.CurrentFreeCount > 0)
                {
                    TTTG_Event.DispatchOnEnterFree();
                    return;
                }

                if (owner.GameData.isAutoGame) //不在免费，自动模式下
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

        #endregion
    }
}