

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
using Spine.Unity;

namespace Hotfix.YGBH
{
    /// <summary>
    /// 游戏主入口
    /// </summary>
    public class YGBHEntry : SingletonILEntity<YGBHEntry>
    {
        public Data GameData { get; set; }
        HierarchicalStateMachine hsm;
        List<IState> states;

        public Transform effectList;
        public Transform CSGroup;

        public Transform MainContent;
        public Transform RollContent;
        private TextMeshProUGUI selfGold;
        private Text userName;
        private Image userHead;
        private TextMeshProUGUI ChipNum;
        public Transform WinInfo;
        public TextMeshProUGUI WinNum;
        public TextMeshProUGUI WinDesc;
        private Button reduceChipBtn;
        private Button addChipBtn;
        Transform btnGroup;
        private Button startBtn;
        private Transform autoEffect;
        private Button stopBtn;
        private Transform FreeContent;
        TextMeshProUGUI freeText;
        Button AutoStartBtn;
        private TextMeshProUGUI autoText;
        public Button MaxChipBtn;
        private Button closeAutoMenu;
        private Transform autoSelectList;
        private Transform freePanel;
        private SkeletonGraphic freeSelectOne;
        private SkeletonGraphic freeSelectTwo;
        private TextMeshProUGUI freedownTime;
        private Button closeSet;
        private Button showRuleBtn;
        private Transform settingPanel;
        private Slider soundSet;
        private Slider musicSet;
        private Button closeGame;
        private Button settingBtn;
        private Button soundBtn;
        public Transform Icons;
        public Transform effectPool;
        private Transform LineGroup;
        private Transform rulePanel;
        private Button menuBtn;
        private Transform menulist;
        private Button backgroundBtn;
        private Transform resultPanel;
        private Transform Sounds;
        private Transform bjjEffect;
        public Transform bjjKuGroup;
        public Transform bjjLightGroup;
        public Button dlBtn;
        public Transform zpPanel;
        public TextMeshProUGUI zpProgress;
        private GameObject zpSPImg;
        private Button closeZPBtn;
        private Button startZPBtn;
        private GameObject gbObj;
        public Transform maskGroup;
        public Transform smallGoldGroup;

        public bool isRoll;
        public int smallSPRealCount;
        public int smallSPCount;
        public bool FullSP;
        private float showFreeTimer;
        private bool isshowFree;
        private bool ispress;
        private float clickStartTimer;
        public List<List<int>> bjjList;
        public List<Image> bjjImgList;
        public List<Transform> scatterList;
        public bool hasNewSP = false;
        public Transform dlLightGroup;
        private int currentSmallRollIndex;
        private int currentSmallCycleCount;
        private int smallRollTimer;
        private object smallTempRollTimer;
        private bool isLastCycle;
        private int stopIndex;
        private int needMove;
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
            gameObject.AddILComponent<YGBH_Network>();
            gameObject.AddILComponent<YGBH_Audio>();
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
            rulePanel.gameObject.AddILComponent<YGBH_Rule>();
            resultPanel.gameObject.AddILComponent<YGBH_Result>();
            RollContent.gameObject.AddILComponent<YGBH_Roll>();
            RollContent.gameObject.AddILComponent<YGBH_Line>();
            bjjList = new List<List<int>>();
            bjjImgList = new List<Image>();
            scatterList = new List<Transform>();
            userHead.sprite = ILGameManager.Instance.GetHeadIcon();
            userName.text = GameLocalMode.Instance.SCPlayerInfo.NickName;
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
            AutoSelectFree();
            if (!ispress) return;
            clickStartTimer += Time.deltaTime;
            if (!(clickStartTimer >= 1.5f)) return;
            ispress = false;
            autoEffect.gameObject.SetActive(false);
            closeAutoMenu.gameObject.SetActive(true);
            //OnClickAutoCall();
        }

        protected override void AddEvent()
        {
            YGBH_Event.RefreshGold += YGBH_Event_RefreshGold;
            YGBH_Event.OnGetSceneData += YGBH_Event_OnGetSceneData;
            YGBH_Event.ShowResultComplete += YGBH_Event_ShowResultComplete;
            YGBH_Event.OnChangeBet += YGBH_Event_OnChangeBet;
            YGBH_Event.RollPrepreaComplete += YGBH_Event_RollPrepreaComplete;
            YGBH_Event.RollComplete += YGBH_Event_RollComplete;
            YGBH_Event.RollFailed += YGBH_Event_RollFailed;
            YGBH_Event.ShowResult += YGBH_Event_ShowResult;
            YGBH_Event.StartRoll += YGBH_Event_ShowResultZero;

        }
        protected override void RemoveEvent()
        {
            YGBH_Event.RefreshGold -= YGBH_Event_RefreshGold;
            YGBH_Event.OnGetSceneData -= YGBH_Event_OnGetSceneData;
            YGBH_Event.ShowResultComplete -= YGBH_Event_ShowResultComplete;
            YGBH_Event.OnChangeBet -= YGBH_Event_OnChangeBet;
            YGBH_Event.RollPrepreaComplete -= YGBH_Event_RollPrepreaComplete;
            YGBH_Event.RollComplete -= YGBH_Event_RollComplete;
            YGBH_Event.RollFailed -= YGBH_Event_RollFailed;
            YGBH_Event.ShowResult -= YGBH_Event_ShowResult;
            YGBH_Event.StartRoll -= YGBH_Event_ShowResultZero;
        }

        protected override void FindComponent()
        {
            MainContent = transform.FindChildDepth("MainPanel/Content");
            RollContent = MainContent.FindChildDepth("RollContent"); //转动区域
            selfGold = MainContent.FindChildDepth<TextMeshProUGUI>("Bottom/Gold/Num"); //自身金币
            userName = MainContent.FindChildDepth<Text>("Bottom/Gold/UserName"); //用户名
            userHead = MainContent.FindChildDepth<Image>("Bottom/Gold/Head/Mask/Icon"); //用户头像
            ChipNum = MainContent.FindChildDepth<TextMeshProUGUI>("Bottom/Chip/Num"); //下注金额
            WinNum = MainContent. FindChildDepth<TextMeshProUGUI>("Bottom/Win/Num") ; //本次获得金币
            WinDesc = MainContent.FindChildDepth<TextMeshProUGUI>("Bottom/Win/Desc"); //本次获得金币
            reduceChipBtn = MainContent.FindChildDepth<Button>("Bottom/Chip/Reduce"); //减注
            addChipBtn = MainContent.FindChildDepth<Button>("Bottom/Chip/Add"); //加注
            btnGroup = MainContent.FindChildDepth("Bottom/ButtonGroup");
            startBtn = btnGroup.FindChildDepth<Button>("StartBtn"); //开始按钮
            autoEffect = startBtn.transform.FindChildDepth("AutoEffect");
            stopBtn = btnGroup.FindChildDepth<Button>("StopBtn"); //停止按钮
            stopBtn.gameObject.SetActive(false);
            FreeContent = btnGroup.FindChildDepth("Free"); //免费状态
            FreeContent.gameObject.SetActive(false);
            freeText = FreeContent.transform.FindChildDepth<TextMeshProUGUI>("Num"); //免费次数
            AutoStartBtn = btnGroup.FindChildDepth<Button>("AutoState"); //打开自动开始界面
            AutoStartBtn.gameObject.SetActive(false);
            autoText = AutoStartBtn.transform.FindChildDepth<TextMeshProUGUI>("AutoNum"); //自动次数
            MaxChipBtn = btnGroup.FindChildDepth<Button>("MaxChip"); //最大下注
            closeAutoMenu = btnGroup.FindChildDepth<Button>("CloseAutoMenu"); //关闭自动开始界面
            autoSelectList = closeAutoMenu.transform.FindChildDepth("AutoSelect"); //自动开始次数选择
            closeAutoMenu.gameObject.SetActive(false);
            freePanel = MainContent.FindChildDepth("FreePanel");
            freePanel.gameObject.SetActive(false);
            freeSelectOne = freePanel.FindChildDepth<SkeletonGraphic>("Group/FreeSelect1");
            freeSelectTwo = freePanel.FindChildDepth<SkeletonGraphic>("Group/FreeSelect2");
            freedownTime = freePanel.FindChildDepth<TextMeshProUGUI>("Timer");
            rulePanel = MainContent.FindChildDepth("Rule"); //规则界面
            resultPanel = MainContent.FindChildDepth("Result");
            menuBtn = MainContent.FindChildDepth<Button>("Menu"); //菜单按钮
            menulist = MainContent.FindChildDepth("MenuList"); //菜单按钮详情
            backgroundBtn = MainContent.FindChildDepth<Button>("CloseMenu");
            closeGame = menulist.FindChildDepth<Button>("Content/Back");
            settingBtn = menulist.FindChildDepth<Button>("Content/Setting");
            closeGame.transform.SetAsLastSibling();
            menulist.localScale = Vector3.zero;
            backgroundBtn.gameObject.SetActive(false);
            showRuleBtn = MainContent.FindChildDepth<Button>("RuleBtn");
            settingPanel = MainContent.FindChildDepth("Setting");
            soundSet = settingPanel.FindChildDepth<Slider>("Content/Sound");
            musicSet = settingPanel.FindChildDepth<Slider>("Content/Music");
            closeSet = settingPanel.FindChildDepth<Button>("Content/Close");
            Icons = MainContent.FindChildDepth("Icons"); //图标库
            effectList = MainContent.FindChildDepth("EffectList"); //动画库
            effectPool = MainContent.FindChildDepth("EffectPool"); //动画缓存库
            //LineGroup = MainContent.FindChildDepth("LineGroup"); //连线
            CSGroup = MainContent.FindChildDepth("CSContent"); //显示财神
            Sounds = MainContent.FindChildDepth("SoundList"); //声音库
            bjjEffect = MainContent.FindChildDepth("BJJ");
            bjjKuGroup = bjjEffect.FindChildDepth("KuGroup");
            bjjLightGroup = bjjEffect.FindChildDepth("Group");
            dlBtn = MainContent.FindChildDepth<Button>("DL/Group");
            for (int i = 0; i < dlBtn.transform.childCount; i++)
            {
                dlBtn.transform.GetChild(i).gameObject.SetActive(false);
            }
            dlLightGroup = MainContent.FindChildDepth("DL/LightGroup");
            for (int i = 0; i < dlLightGroup.childCount; i++)
            {
                dlLightGroup.GetChild(i).gameObject.SetActive(false);
            }
            zpPanel = MainContent.FindChildDepth("ZPPanel/Content");
            zpProgress = zpPanel.FindChildDepth<TextMeshProUGUI>("Background/Progress/Value");
            zpSPImg = zpPanel.FindChildDepth("Background/Progress/Image").gameObject;
            closeZPBtn = zpPanel.FindChildDepth<Button>("Close");
            startZPBtn = zpPanel.FindChildDepth<Button>("Background/Start");
            gbObj = zpPanel.FindChildDepth("GB").gameObject;
            gbObj.SetActive(false);
            maskGroup = zpPanel.FindChildDepth("Background/Group");
            for (int i = 0; i < maskGroup.childCount; i++)
            {
                maskGroup.GetChild(i).GetComponent<Image>().enabled = false;
            }

            smallGoldGroup = zpPanel.FindChildDepth("Background/RewardGroup");
            for (int i = 0; i < smallGoldGroup.childCount; i++)
            {
                smallGoldGroup.GetChild(i).gameObject.SetActive(false);
            }
            soundSet.value = ILMusicManager.Instance.GetSoundValue();
            musicSet.value = ILMusicManager.Instance.GetMusicValue();
           
        }
        private void AddListener()
        {
            //添加监听事件
            reduceChipBtn.onClick.RemoveAllListeners();
            reduceChipBtn.onClick.Add(ReduceChipCall);
            addChipBtn.onClick.RemoveAllListeners();
            addChipBtn.onClick.Add(AddChipCall);
            //startBtn.onClick.RemoveAllListeners();
            //startBtn.onClick.Add(StartGameCall);

            EventTriggerHelper trigger = EventTriggerHelper.Get(startBtn.gameObject);
            trigger.onDown = OnBeginClick;
            trigger.onUp = OnEndClick;

            startBtn.onClick.RemoveAllListeners();
            startBtn.onClick.Add(StartGameCall);
            stopBtn.onClick.RemoveAllListeners();
            stopBtn.onClick.Add(StartGameCall);

            menuBtn.onClick.RemoveAllListeners();
            menuBtn.onClick.Add(ClickMenuCall);
            backgroundBtn.onClick.RemoveAllListeners();
            backgroundBtn.onClick.Add(CloseMenuCall);
            closeGame.onClick.RemoveAllListeners();
            closeGame.onClick.Add(CloseGameCall);
            settingBtn.onClick.RemoveAllListeners();
            settingBtn.onClick.Add(OpenSettingPanel);

            musicSet.onValueChanged.RemoveAllListeners();
            musicSet.onValueChanged.Add(SetMusicVolumn);

            soundSet.onValueChanged.RemoveAllListeners();
            soundSet.onValueChanged.Add(SetSoundVolumn);

            closeSet.onClick.RemoveAllListeners();
            closeSet.onClick.Add(() =>
            {
                settingPanel.gameObject.SetActive(false);
            });


            AutoStartBtn.onClick.RemoveAllListeners();
            AutoStartBtn.onClick.Add(OnClickAutoCall);

            for (int i = 0; i < autoSelectList.childCount; i++)
            {
                Transform child = autoSelectList.GetChild(i);
                child.GetComponent<Button>().onClick.RemoveAllListeners();
                child.GetComponent<Button>().onClick.Add(() =>
                {
                    GameData.CurrentAutoCount = int.Parse(child.name);
                    OnClickAutoItemCall();
                });
                child.gameObject.SetActive(true);
            }


            closeAutoMenu.onClick.RemoveAllListeners(); //关闭自动
            closeAutoMenu.onClick.Add(() =>
            {
                closeAutoMenu.gameObject.SetActive(false);

            });

            showRuleBtn.onClick.RemoveAllListeners(); //显示规则
            showRuleBtn.onClick.Add(ShowRulePanel);

            MaxChipBtn.onClick.RemoveAllListeners();
            MaxChipBtn.onClick.Add(SetMaxChipCall);

            freeSelectOne.transform.GetComponent<Button>().onClick.RemoveAllListeners();
            freeSelectOne.transform.GetComponent<Button>().onClick.Add(() => 
            {
                OnSelectFreeTypeCall(freeSelectOne, freeSelectTwo, 1);
            });

            freeSelectTwo.transform.GetComponent<Button>().onClick.RemoveAllListeners();
            freeSelectTwo.transform.GetComponent<Button>().onClick.Add(() =>
            {
                OnSelectFreeTypeCall(freeSelectTwo, freeSelectOne, 2);
            });

            dlBtn.onClick.RemoveAllListeners();
            dlBtn.onClick.Add(OpenZP);

            closeZPBtn.onClick.RemoveAllListeners();
            closeZPBtn.onClick.Add(CloseZP);

            startZPBtn.onClick.RemoveAllListeners();
            startZPBtn.onClick.Add(() => 
            {
                startZPBtn.gameObject.SetActive(false);
                zpProgress.transform.parent.gameObject.SetActive(true);
                zpProgress.text = "0/6";
                YGBH_Network.Instance.StartSmallGame();
            });
        }

        private void OnClickAutoItemCall()
        {
            //点击选择自动次数
            YGBH_Audio.Instance.PlaySound(YGBH_Audio.BTN);
            GameData.isAutoGame = true;
            ispress = false;
            stopBtn.gameObject.SetActive(false);
            //startBtn.transform.GetComponent<Image>().color = Color.gray;
            startBtn.gameObject.SetActive(false);
            FreeContent.gameObject.SetActive(false);
            AutoStartBtn.gameObject.SetActive(true);
            closeAutoMenu.gameObject.SetActive(false);
            addChipBtn.interactable = false;
            reduceChipBtn.interactable = false;
            MaxChipBtn.interactable = false;
            if ( GameData.isFreeGame)
            {
                FreeContent.gameObject.SetActive(true);
                AutoStartBtn.gameObject.SetActive(false);
            }
            else
            {
                if (GameData.myGold < GameData.CurrentChip * YGBH_DataConfig.ALLLINECOUNT)
                {
                    ToolHelper.PopSmallWindow("Insufficient gold coins!");
                    return;
                }
            }

            if (isRoll || GameData.isFreeGame) return;
            //没有转动的状态开始自动旋转
            DebugHelper.Log("开始自动游戏");
            hsm?.ChangeState(nameof(AutoRollState));
            //YGBH_Network.Instance.StartGame();
        }

        private void CloseZP()
        {
            zpPanel.FindChildDepth("Mask/Image").DOScale(Vector3.zero, 0.3f);
            maskGroup.parent.DOScale(Vector3.zero, 0.3f).OnComplete(() =>
            {
                zpPanel.parent.gameObject.SetActive(false);
            });
        }

        private void OpenZP()
        {
            maskGroup.parent.localScale = Vector3.zero;
            smallSPRealCount = 0;
            for (int i = 0; i < GameData.SceneData.smallGameTrack.Count; i++)
            {
                int index = YGBH_DataConfig.ZPList[i];
                if (GameData.SceneData.smallGameTrack[i] > 0)
                {
                    if (i< GameData.SceneData.smallGameTrack.Count-2)
                    {
                        smallSPRealCount += 1;
                    }
                    maskGroup.GetChild(index-1).GetComponent<Image>().enabled = false;
                    smallGoldGroup.GetChild(index-1).GetComponent<TextMeshProUGUI>().text = GameData.SceneData.smallGameTrack[i].ShortNumber();
                }
                else
                {
                    maskGroup.GetChild(index-1).GetComponent<Image>().enabled = true;
                    smallGoldGroup.GetChild(index-1).GetComponent<TextMeshProUGUI>().text ="";
                }
                smallGoldGroup.GetChild(index-1).gameObject.SetActive(true);
            }

            zpProgress.text = YGBHEntry.Instance.smallSPRealCount + "/6";
            zpSPImg.SetActive(YGBHEntry.Instance.smallSPCount > 0);
            zpPanel.parent.gameObject.SetActive(true);
            zpPanel.FindChildDepth("Mask/Image").DOScale(Vector3.one, 0.3f);
            maskGroup.parent.DOScale(Vector3.one, 0.3f).SetEase(DG.Tweening.Ease.OutBack);
            closeZPBtn.gameObject.SetActive(!FullSP);
            if (FullSP) 
            {
                startZPBtn.gameObject.SetActive(true);
                zpProgress.transform.parent.gameObject.SetActive(false);
            }
            else
            {
                startZPBtn.gameObject.SetActive(false);
                zpProgress.transform.parent.gameObject.SetActive(true);
            }

        }

        private Coroutine _coroutine;
        public void RollZP()
        {
           currentSmallRollIndex = 0;
           currentSmallCycleCount = 0;
           smallRollTimer = 0;
           smallTempRollTimer = YGBH_DataConfig.smallRollDurationTime;
           isLastCycle = false;
           gbObj.transform.SetParent(maskGroup.GetChild(currentSmallRollIndex));
           gbObj.transform.localPosition = new Vector3(YGBH_DataConfig.smallLighIconPos[0], YGBH_DataConfig.smallLighIconPos[1], YGBH_DataConfig.smallLighIconPos[2]);
           gbObj.transform.localRotation = Quaternion.Euler(0, 0, YGBH_DataConfig.smallLighIconAngle);
           gbObj.gameObject.SetActive(true);
           if (_coroutine != null) Behaviour.StopCoroutine(_coroutine);
          _coroutine= Behaviour.StartCoroutine(StartRollSmallGame());
        }

        IEnumerator StartRollSmallGame()
        {
            stopIndex = YGBHEntry.Instance.GameData.smallWinIndex;
            needMove = stopIndex + 8 * 2;
            int currentPos = 0;
            for (int i = 0; i < needMove; i++)
            {
                currentPos += 1;
                if (currentPos>8)
                {
                    currentPos -= 8;
                }
                gbObj.transform.SetParent(maskGroup.GetChild(currentPos - 1));
                gbObj.transform.localPosition = new Vector3(YGBH_DataConfig.smallLighIconPos[0], YGBH_DataConfig.smallLighIconPos[1], YGBH_DataConfig.smallLighIconPos[2]);
                gbObj.transform.localRotation = Quaternion.Euler(0, 0, YGBH_DataConfig.smallLighIconAngle);
                YGBH_Audio.Instance.PlaySound(YGBH_Audio.RS);
                if (needMove - i > 6)
                {
                    yield return new WaitForSeconds(YGBH_DataConfig.smallMoveSpeed);
                }
                else if (needMove - i > 4)
                {
                    yield return new WaitForSeconds(YGBH_DataConfig.smallMoveSpeed * 2);
                }
                else if (needMove - i > 2)
                {
                    yield return new WaitForSeconds(YGBH_DataConfig.smallMoveSpeed * 4);
                }
                else
                {
                    yield return new WaitForSeconds(YGBH_DataConfig.smallMoveSpeed * 8);
                }
            }
            //TODO 显示结算
            YGBH_Event.DispatchShowF_sResult();
        }

        private void OnSelectFreeTypeCall(SkeletonGraphic selectObj, SkeletonGraphic unselectObj, int index)
        {
            YGBH_Audio.Instance.PlaySound(YGBH_Audio.FREESELECT);
            showFreeTimer = YGBH_DataConfig.freeWaitTime;
            isshowFree = false;
            YGBH_Network.Instance.SelectFree();
            if (GameData.m_FreeType == 13)
            {
                selectObj.transform.GetChild(0).gameObject.SetActive(true);
                unselectObj.transform.GetChild(1).gameObject.SetActive(true);
                selectObj.AnimationState.SetAnimation(0, "zx_03", false);
                unselectObj.AnimationState.SetAnimation(0, "bjj_03", false);
            }
            else if (GameData.m_FreeType == 14)
            {
                selectObj.transform.GetChild(1).gameObject.SetActive(true);
                unselectObj.transform.GetChild(0).gameObject.SetActive(true);
                selectObj.AnimationState.SetAnimation(0, "bjj_03", false);
                unselectObj.AnimationState.SetAnimation(0, "zx_03", false);
            }
            Behaviour.StopCoroutine(outEffect(selectObj, unselectObj, index));
            Behaviour.StartCoroutine(outEffect(selectObj, unselectObj, index));
        }

        IEnumerator outEffect(SkeletonGraphic selectObj, SkeletonGraphic unselectObj, int index)
        {
            Vector3 pos;
            if (index == 1)
            {
                pos = new Vector3(1334, -100, 0);
            }
            else
            {
                pos = new Vector3(-1334, -100, 0);
            }

            yield return new WaitForSeconds(0.8f);
            freedownTime.text = "";

            unselectObj.transform.DOLocalMove(pos, 0.5f);
            unselectObj.DOFade(0, 0.5f);
            unselectObj.transform.DOScale(new Vector3(0.5f, 0.5f, 0.5f), 0.5f).OnComplete(() =>
            {
                unselectObj.gameObject.SetActive(false);
                unselectObj.DOFade(1, 0.01f);
                unselectObj.transform.DOScale(Vector3.one, 0.01f);
                Behaviour.StopCoroutine(showDescFunc(selectObj, unselectObj, index));
                Behaviour.StartCoroutine(showDescFunc(selectObj, unselectObj, index));
            });

            selectObj.transform.DOLocalMove(Vector3.zero, 0.5f);
        }

        IEnumerator showDescFunc(SkeletonGraphic selectObj, SkeletonGraphic unselectObj, int index) 
        {
            Transform backImg = freePanel.FindChildDepth("Background");
            freePanel.GetComponent<Animator>().SetTrigger(GameData.m_FreeType == 13 ? "ZX" : "BJJ");

            while (backImg.gameObject.activeSelf)
            {
                yield return new WaitForSeconds(0.01f);
            }
            freePanel.gameObject.SetActive(false);
            if (GameData.m_FreeType == 13)
            {
                if (GameData.ResultData==null)
                {
                    for (int i = GameData.SceneData.nFreeIcon_lie.Count-1; i >= 0; i--)
                    {
                        if (GameData.SceneData.nFreeIcon_lie[i] <= 0) continue;
                        CSGroup.GetChild(i).FindChildDepth("Item").gameObject.SetActive(true);
                        yield return new WaitForSeconds(0.1f);
                    }
                }
                else
                {
                    for (int i = GameData.ResultData.m_nIconLie.Count-1; i >= 0; i--)
                    {
                        if (GameData.ResultData.m_nIconLie[i] <= 0) continue;
                        CSGroup.GetChild(i).FindChildDepth("Item").gameObject.SetActive(true);
                        yield return new WaitForSeconds(0.1f);
                    }
                }
                YGBH_Audio.Instance.PlayBGM(YGBH_Audio.BGM_ZX);
            }
            else
            {
                YGBH_Audio.Instance.PlayBGM(YGBH_Audio.BGM_BJJ);
            }
            hsm?.ChangeState(nameof(FreeRollState));
        }

        private void SetSoundVolumn(float value)
        {
            ILMusicManager.Instance.SetSoundValue(value);
            YGBH_Audio.Instance.SetSoundValue(value);
        }

        private void SetMusicVolumn(float value)
        {
            ILMusicManager.Instance.SetMusicValue(value);
            YGBH_Audio.Instance.SetMusicValue(value);
        }

        private void OpenSettingPanel()
        {
            CloseMenuCall();
            settingPanel.gameObject.SetActive(true);
        }

        private void CloseMenuCall()
        {
            YGBH_Audio.Instance.PlaySound(YGBH_Audio.BTN);

            backgroundBtn.interactable = false;
            menulist.DOScale(Vector3.zero, 0.2f).OnComplete(() =>
            {
                backgroundBtn.interactable = true;
                menulist.gameObject.SetActive(false);
                backgroundBtn.gameObject.SetActive(false);
            });
        }

        private void ClickMenuCall()
        {
            YGBH_Audio.Instance.PlaySound(YGBH_Audio.BTN);

            backgroundBtn.gameObject.SetActive(true);
            backgroundBtn.interactable = false;
            menulist.gameObject.SetActive(true);
            menulist.DOScale(Vector3.one, 0.2f).OnComplete(() =>
            {
                backgroundBtn.interactable = true;
            });
        }

        private void OnEndClick(GameObject arg1, PointerEventData arg2)
        {
            // if (clickStartTimer >= 1.5f) return;
            // if (!ispress) return;
            // ispress = false;
            // autoEffect.gameObject.SetActive(false);
            // clickStartTimer =0;
            // StartGameCall();
        }

        private void OnBeginClick(GameObject arg1, PointerEventData arg2)
        {
            if (hsm.CurrentStateName != nameof(IdleState)) return;
            clickStartTimer = 0;
            autoEffect.gameObject.SetActive(true);
            ispress = true;
        }

        private void YGBH_Event_RefreshGold(long gold)
        {
            GameData.myGold = gold;
            this.selfGold.text = GameData.myGold.ShortNumber();
        }

        private void YGBH_Event_OnGetSceneData()
        {
            hsm?.ChangeState(nameof(InitState));
        }

        private void YGBH_Event_ShowResultComplete()
        {
            //TODO 收分做跳跃动画
            hsm?.ChangeState(nameof(CheckState));
            YGBH_Event.DispatchRefreshGold((long)GameLocalMode.Instance.UserGameInfo.Gold);
        }

        private void YGBH_Event_OnChangeBet()
        {
            ChipNum.text = (GameData.CurrentChip * YGBH_DataConfig.ALLLINECOUNT).ShortNumber();
        }

        private void YGBH_Event_RollComplete()
        {
            YGBH_Event.DispatchShowResult();
        }

        private void YGBH_Event_RollPrepreaComplete()
        {
            hsm?.ChangeState(nameof(WaitStopState));
        }

        private void YGBH_Event_RollFailed()
        {
            hsm?.ChangeState(nameof(IdleState));
        }

        private void YGBH_Event_ShowResult()
        {
            WinNum.text = GameData.ResultData.WinScore.ShortNumber();
        }

        private void YGBH_Event_ShowResultZero()
        {
            stopBtn.gameObject.SetActive(true);
            WinNum.text = 0.ShortNumber();
        }

        /// <summary>
        /// 加注
        /// </summary>
        private void AddChipCall()
        {
           // YGBH_Audio.Instance.PlaySound(YGBH_Audio.ADDBET);
            //加注
            GameData.CurrentChipIndex += 1;
            if (GameData.CurrentChipIndex >= GameData.SceneData.chipList.Count)
            {
                GameData.CurrentChipIndex = 0;
            }
            GameData.CurrentChip = GameData.SceneData.chipList[GameData.CurrentChipIndex];
            YGBH_Event.DispatchOnChangeBet();
        }

        /// <summary>
        /// 减注
        /// </summary>
        private void ReduceChipCall()
        {
            //YGBH_Audio.Instance.PlaySound(YGBH_Audio.REDUCEBET);
            GameData.CurrentChipIndex -= 1;
            if (GameData.CurrentChipIndex <= 0) 
            {
                GameData.CurrentChipIndex = GameData.SceneData.chipList.Count-1;
            }
            GameData.CurrentChip = GameData.SceneData.chipList[GameData.CurrentChipIndex];
            YGBH_Event.DispatchOnChangeBet();
        }

        /// <summary>
        /// 设置最大下注
        /// </summary>
        private void SetMaxChipCall()
        {
            YGBH_Audio.Instance.PlaySound(YGBH_Audio.BTN);
            GameData.CurrentChipIndex = GameData.SceneData.chipList.Count - 1;
            GameData.CurrentChip = GameData.SceneData.chipList[GameData.CurrentChipIndex];
            YGBH_Event.DispatchOnChangeBet();
        }

        private void ShowFreeGame()
        {
            //显示免费界面
            freePanel.gameObject.SetActive(true);
            freeSelectOne.transform.DOLocalMove(new Vector3(-230, 0, 0), 0.3f);
            freeSelectTwo.transform.DOLocalMove(new Vector3(230, 0, 0), 0.3f);
            freedownTime.gameObject.SetActive(true);
            Transform parent = freeSelectOne.transform.parent;
            for (int i = 0; i < parent.childCount; i++)
            {
                parent.GetChild(i).gameObject.SetActive(true);
                for (int j = 0; j < parent.GetChild(i).childCount; j++)
                {
                    parent.GetChild(i).GetChild(j).gameObject.SetActive(false);
                }
            }
            freeSelectOne.AnimationState.SetAnimation(0, "bjj_01", true);
            freeSelectTwo.AnimationState.SetAnimation(0, "zx_01", true);
            showFreeTimer = YGBH_DataConfig.freeWaitTime;
            isshowFree = true;
            //ToolHelper.DelayRun(1f, () =>
            //{
            //    hsm?.ChangeState(nameof(CheckState));

            //});
        }

        //开始游戏
        private void StartGameCall()
        {
            ispress = false;
            autoEffect.gameObject.SetActive(false);
            clickStartTimer =0;
            if (GameData.isFreeGame || GameData.isAutoGame) return;
            if (isRoll)
            {
                if (hsm.CurrentStateName != nameof(WaitStopState)) return;
                StopGame();
                startBtn.gameObject.SetActive(true);
                stopBtn.gameObject.SetActive(false);
                return;
            }

            YGBH_Audio.Instance.PlaySound(YGBH_Audio.BTN);

            if (GameData.myGold < GameData.CurrentChip * YGBH_DataConfig.ALLLINECOUNT && !GameData.isFreeGame)
            {
                ToolHelper.PopBigWindow(new BigMessage()
                {
                    content = "Insufficient gold coins, please recharge",
                    okCall = YGBH_Event.DispatchRollFailed,
                    cancelCall = YGBH_Event.DispatchRollFailed
                });
                return;
            }
            hsm?.ChangeState(nameof(NormalRollState));
        }

        private void StopGame()
        {
            if (hsm.CurrentStateName != nameof(WaitStopState)) return;
            YGBH_Audio.Instance.PlaySound(YGBH_Audio.BTN);
            YGBH_Event.DispatchStopRoll(true);
        }
        /// <summary>
        /// 显示规则界面
        /// </summary>
        private void ShowRulePanel()
        {
            YGBH_Audio.Instance.PlaySound(YGBH_Audio.BTN);
            rulePanel.gameObject.SetActive(true);
        }

        /// <summary>
        /// 退出游戏
        /// </summary>
        private void CloseGameCall()
        {
            YGBH_Audio.Instance.PlaySound(YGBH_Audio.BTN);
            if (!GameData.isFreeGame)
            {
                DebugHelper.Log("退出游戏");
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
            closeAutoMenu.gameObject.SetActive(false);
            stopBtn.gameObject.SetActive(false);
            startBtn.gameObject.SetActive(true);
            FreeContent.gameObject.SetActive(false);
            AutoStartBtn.gameObject.SetActive(false);
        }

        /// <summary>
        /// 点击自动开始
        /// </summary>
        /// <param name="state"></param>
        private void OnClickAutoCall()
        {
            YGBH_Audio.Instance.PlaySound(YGBH_Audio.BTN);
            if (!GameData.isAutoGame) return;
            StopAutoGame();
            return;
            //点击自动开始
            //AutoStartCall();
        }

        public void OnClickCloseFreeResult()
        {
            YGBHEntry.Instance.GameData.TotalFreeWin = 0;
            startBtn.gameObject.SetActive(true);
            AutoStartBtn.gameObject.SetActive(true);
            freeText.gameObject.gameObject.SetActive(false);
            FreeContent.gameObject.SetActive(false);
            GameData.isFreeGame = false;
            for (int i = 0; i < CSGroup.childCount; i++)
            {
                for (int j = 0; j < CSGroup.GetChild(i).childCount; j++)
                {
                    CSGroup.GetChild(i).GetChild(j).gameObject.SetActive(false);
                }
            }
            YGBH_Audio.Instance.PlayBGM();
            hsm?.ChangeState(nameof(CheckState));
        }

        private void AutoStartCall()
        {
            GameData.CurrentAutoCount = 10000;
            GameData.isAutoGame = true;
            closeAutoMenu.gameObject.SetActive(true);
        }


        private void FreeGame()
        {
            //免费游戏
            GameData.isFreeGame = true;
            startBtn.gameObject.SetActive(false);
            stopBtn.gameObject.SetActive(false);
            AutoStartBtn.gameObject.SetActive(false);
            FreeContent.gameObject.SetActive(true);
            FreeContent.transform.FindChildDepth("Num").GetComponent<TextMeshProUGUI>().text =GameData.currentFreeCount.ShowRichText();
            //YGBH_Network.Instance.StartGame();
        }

        private void AutoSelectFree()
        {
            if (!isshowFree) return;
            showFreeTimer -= Time.deltaTime;
            if (showFreeTimer < 6 && showFreeTimer > 0)
            {
                if (freedownTime.text != Mathf.CeilToInt(showFreeTimer).ShowRichText())
                {
                    YGBH_Audio.Instance.PlaySound(YGBH_Audio.TIMEDOWN);
                }
            }

            freedownTime.text = Mathf.CeilToInt(showFreeTimer).ShowRichText();
            if (!(showFreeTimer <= 0)) return;
            //默认选择
            showFreeTimer = YGBH_DataConfig.freeWaitTime;
            freedownTime.gameObject.SetActive(false);
            OnSelectFreeTypeCall(freeSelectOne, freeSelectTwo, 1);
        }


        #region 状态机
        /// <summary>
        /// 待机状态
        /// </summary>
        private class IdleState : State<YGBHEntry>
        {
            public IdleState(YGBHEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                owner.MaxChipBtn.interactable = true;
                owner.GameData.isFreeGame = false;
                owner.freeText.gameObject.SetActive(false);
                owner.startBtn.gameObject.SetActive(true);
                owner.AutoStartBtn.gameObject.SetActive(false);
                owner.stopBtn.gameObject.SetActive(false);
                owner.WinNum.text = 0.ShortNumber();
                owner.isRoll = false;
            }
        }
        /// <summary>
        /// 初始化状态
        /// </summary>
        private class InitState : State<YGBHEntry>
        {
            public InitState(YGBHEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                YGBH_Event.DispatchRefreshGold((long)GameLocalMode.Instance.UserGameInfo.Gold);
                if (owner.GameData.SceneData.bet != 0)
                {
                   owner.GameData.CurrentChipIndex= owner.GameData.SceneData.chipList.FindListIndex(match =>
                       match == owner.GameData.SceneData.bet);
                }
                else
                {
                    owner.GameData.CurrentChipIndex = 0;
                }

                if (owner.GameData.SceneData.freeNumber <= 0)
                {
                    owner.GameData.CurrentChipIndex =
                        GameLocalMode.Instance.UserGameInfo.Gold.CheckNear(owner.GameData.SceneData.chipList);
                }
                owner.GameData.CurrentChip = owner.GameData.SceneData.chipList[owner.GameData.CurrentChipIndex];
                YGBH_Event.DispatchOnChangeBet();
                owner.AddListener();
                if(owner.GameData.SceneData.freeNumber > 0 )
                {
                    owner.GameData.m_FreeType = uint.Parse(owner.GameData.SceneData.nFreeType.ToString());
                    owner.GameData.currentFreeCount = owner.GameData.SceneData.freeNumber;
                    if (owner.GameData.SceneData.freeNumber==5)
                    {
                        owner.GameData.currentFreeCount = owner.GameData.SceneData.freeNumber;
                        hsm?.ChangeState(nameof(EnterFreeState));
                        return;
                    }
                    else
                    {
                        owner.GameData.isFreeGame = true;
                        if (owner.GameData.m_FreeType == 13)
                        {
                            YGBH_Audio.Instance.PlayBGM(YGBH_Audio.BGM_ZX);
                            for (int i = 0; i < YGBHEntry.Instance.GameData.SceneData.nFreeIcon_lie.Count; i++)
                            {
                                GameObject item = owner.CSGroup.GetChild(i).FindChildDepth("Item").gameObject;
                                if (owner.GameData.SceneData.nFreeIcon_lie[i] > 0 && !item.activeSelf)
                                {
                                    item.SetActive(true);
                                }
                            }
                        }
                        else if (owner.GameData.m_FreeType == 14)
                        {
                            YGBH_Audio.Instance.PlayBGM(YGBH_Audio.BGM_BJJ);
                        }
                        hsm?.ChangeState(nameof(CheckState));
                    }
                }
                else
                {
                    owner.smallSPCount = 0;
                    owner.smallSPRealCount = 0;

                    for (int i = 0; i < owner.GameData.SceneData.smallGameTrack.Count; i++)
                    {
                        if (owner.GameData.SceneData.smallGameTrack[i] <= 0) continue;
                        if (i<=owner.GameData.SceneData.smallGameTrack.Count-1)
                        {
                            owner.smallSPRealCount += 1;
                        }
                        owner.smallSPCount += 1;
                    }
                    for (int i = 0; i < owner.smallSPCount; i++)
                    {
                        owner.dlBtn.transform.GetChild(i).gameObject.SetActive(true);
                    }

                    if (owner.smallSPCount>=8)
                    {
                        owner.FullSP = true;
                        hsm?.ChangeState(nameof(CheckState));
                    }
                    else
                    {
                        hsm?.ChangeState(nameof(IdleState));
                    }
                }
            }
        }
        /// <summary>
        /// 检查状态
        /// </summary>
        private class CheckState : State<YGBHEntry>
        {
            public CheckState(YGBHEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                DebugHelper.Log("CheckState--------检查状态");
                Check();
            }
            private void Check()
            {
                if (owner.FullSP)
                {
                    owner.GameData.isSmallGame = true;
                    owner.OpenZP();
                    owner.isRoll = true;
                    return;
                }

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

                if (owner.GameData.ResultData.FreeCount > 0)//如果不在免费，但有免费次数，进入免费模式
                {
                    owner.GameData.currentFreeCount = owner.GameData.ResultData.FreeCount;
                    hsm?.ChangeState(nameof(EnterFreeState));
                    return;
                }
                if (owner.GameData.isAutoGame)//不在免费，自动模式下
                {
                    if (owner.GameData.CurrentAutoCount <= 0)
                    {
                        owner.GameData.isAutoGame = false;
                        Check();
                        return;
                    }

                    owner.isRoll = false;
                    hsm?.ChangeState(nameof(AutoRollState));
                    return;
                }
                hsm?.ChangeState(nameof(IdleState));
            }
        }
        /// <summary>
        /// 正常
        /// </summary>
        private class NormalRollState : State<YGBHEntry>
        {
            public NormalRollState(YGBHEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();

                if (owner.isRoll) return;
                owner.startBtn.interactable=false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.MaxChipBtn.interactable = false;
                owner.isRoll = true;
                YGBH_Network.Instance.StartGame();
            }
        }

        private class WaitStopState : State<YGBHEntry>
        {
            public WaitStopState(YGBHEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }
        /// <summary>
        /// 自动
        /// </summary>
        private class AutoRollState : State<YGBHEntry>
        {
            public AutoRollState(YGBHEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.startBtn.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.MaxChipBtn.interactable = false;
                owner.GameData.isAutoGame = true;
                if (owner.isRoll) return;
                owner.isRoll = true;

                if (owner.GameData.CurrentAutoCount < 1000) owner.GameData.CurrentAutoCount--;
                owner.autoText.text = owner.GameData.CurrentAutoCount > 1000 ? "∞" : owner.GameData.CurrentAutoCount.ShowRichText();
                YGBH_Network.Instance.StartGame();
            }
        }

        /// <summary>
        /// 进入免费
        /// </summary>
        private class EnterFreeState : State<YGBHEntry>
        {
            bool isEnterFreeGame = false;
            float _time = 0f;
            public EnterFreeState(YGBHEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.startBtn.gameObject.gameObject.SetActive(false);
                owner.AutoStartBtn.gameObject.gameObject.SetActive(false);
                owner.freeText.gameObject.gameObject.SetActive(true);
                owner.GameData.isFreeGame = true;
                _time = 0f;
                //YGBH_Audio.Instance.PlayBGM(YGBH_Audio.FreeBGM);
                //isEnterFreeGame = true;
                owner.ShowFreeGame();
            }

            public override void Update()
            {
                base.Update();
                if (!isEnterFreeGame) return;
                _time += Time.deltaTime;
                if (!(_time >= 1.5f)) return;
                isEnterFreeGame = false;
                _time = 0;
                hsm?.ChangeState(nameof(CheckState));
            }
        }
        /// <summary>
        /// 免费
        /// </summary>
        private class FreeRollState : State<YGBHEntry>
        {
            public FreeRollState(YGBHEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
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
                owner.MaxChipBtn.interactable = false;
                owner.GameData.isFreeGame = true;
                YGBH_Network.Instance.StartGame();
            }
        }
        /// <summary>
        /// 免费结算
        /// </summary>
        private class FreeResultState : State<YGBHEntry>
        {
            float _time = 0f;
            bool isFreeResultGame;
            public FreeResultState(YGBHEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                YGBH_Event.DispatchShowF_sResult();
            }
        }
        #endregion
    }
}
