using System;
using System.Collections.Generic;
using DragonBones;
using LuaFramework;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using Transform = UnityEngine.Transform;

namespace Hotfix.BQTP
{
    public class UIEntry : Game.Singleton<UIEntry>, IILManager
    {
        public Transform MainContent { get; set; }
        private Transform normalBg;
        private Transform freeBg;
        private UnityArmatureComponent enterFreeEffect;
        private UnityArmatureComponent exitFreeEffect;
        private TextMeshProUGUI freeText;
        private Transform freeBLGroup;
        private TextMeshProUGUI ChipNum;
        private Button reduceChipBtn;
        private Button addChipBtn;
        private Transform btnGroup;
        private Transform startBtn;
        private Button startState;
        private Button stopAutoState;
        private TextMeshProUGUI stopAutoStateDesc;
        private Transform freeState;
        private TextMeshProUGUI freeStateDesc;
        private Transform stopState;
        private Button MaxChipBtn;
        private Transform rulePanel;
        private Button settingBtn;
        private Button showRuleBtn;
        private Transform userInfo;
        private Transform CSGroup;
        private Transform quitPanel;
        private Button settingPanel;
        private Button autoPanel;

        public Transform RollContent { get; set; }


        private UIRule _rule;

        private HierarchicalStateMachine _hsm;
        private List<IState> _states;
        private Coroutine longClick;

        protected override void Awake()
        {
            base.Awake();
            Screen.orientation = UnityEngine.ScreenOrientation.Landscape;
            Screen.autorotateToLandscapeLeft = true;
            Screen.autorotateToLandscapeRight = true;
            Screen.autorotateToPortrait = false;
            Screen.autorotateToPortraitUpsideDown = false;
            
            FindComponent();
            UILine.Add(gameObject);
            AddEvent();
            gameObject.CreateOrGetComponent<Model>();
            Model.Instance.PlayBGM();
            _states = new List<IState>();
            _hsm = new HierarchicalStateMachine(false, gameObject);
            _states.Add(new IdleState(this, _hsm));
            _states.Add(new CheckState(this, _hsm));
            _states.Add(new NormalRollState(this, _hsm));
            _states.Add(new AutoRollState(this, _hsm));
            _states.Add(new FreeRollState(this, _hsm));
            _states.Add(new ReRollState(this, _hsm));
            _hsm.Init(_states, nameof(IdleState));
        }

        private void Start()
        {
            Model.Instance.LoginGame();
        }

        private void Update()
        {
            _hsm?.Update();
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            RemoveEvent();
        }

        private void FindComponent()
        {
            this.MainContent = this.transform.FindChildDepth("MainPanel");

            this.normalBg = this.MainContent.FindChildDepth("Content/Background/Normal");
            this.freeBg = this.MainContent.FindChildDepth("Content/Background/Free");
            this.enterFreeEffect =
                this.MainContent.FindChildDepth<UnityArmatureComponent>("Content/Background/GamePanel/Bing");
            this.exitFreeEffect =
                this.MainContent.FindChildDepth<UnityArmatureComponent>("Content/Background/GamePanel/BingSui");
            this.freeText = this.freeBg.FindChildDepth<TextMeshProUGUI>("Num");
            this.freeBLGroup = this.freeBg.FindChildDepth("Group");

            this.RollContent = this.MainContent.FindChildDepth("Content/RollContent"); //转动区域
            UIRoll.Get(RollContent.gameObject);

            Transform bottom = this.MainContent.FindChildDepth("Content/Bottom");
            this.ChipNum = this.MainContent.FindChildDepth<TextMeshProUGUI>("Content/Bottom/Chip/Num"); //下注金额

            this.reduceChipBtn = this.MainContent.FindChildDepth<Button>("Content/Bottom/Chip/Reduce"); //减注
            this.addChipBtn = this.MainContent.FindChildDepth<Button>("Content/Bottom/Chip/Add"); //加注

            this.btnGroup = this.MainContent.FindChildDepth("Content/ButtonGroup");
            this.startBtn = this.btnGroup.FindChildDepth("StartBtn"); //开始按钮
            this.startState = this.startBtn.transform.FindChildDepth<Button>("Start");
            this.stopState = this.startBtn.transform.FindChildDepth("Stop");
            this.stopAutoState = this.startBtn.transform.FindChildDepth<Button>("StopAuto");
            this.stopAutoStateDesc = this.stopAutoState.transform.FindChildDepth<TextMeshProUGUI>("Desc");
            this.freeState = this.startBtn.transform.FindChildDepth("Free");
            this.freeStateDesc = this.freeState.transform.FindChildDepth<TextMeshProUGUI>("Desc");

            this.MaxChipBtn = this.btnGroup.FindChildDepth<Button>("MaxChip"); //最大下注

            this.rulePanel = this.MainContent.FindChildDepth("Content/Rule"); //规则界面
            _rule = UIRule.Add(rulePanel.gameObject);

            this.settingBtn = this.MainContent.FindChildDepth<Button>("Content/SettingBtn");
            this.showRuleBtn = this.MainContent.FindChildDepth<Button>("Content/RuleBtn");

            this.userInfo = this.MainContent.FindChildDepth("Content/Bottom/UserInfo");
            var info = UIUserInfo.Add(userInfo.gameObject);

            autoPanel = MainContent.FindChildDepth<Button>("Content/AutoGroup");
            UIAuto.Add(autoPanel.gameObject, autoCount =>
            {
                Model.Instance.PlaySound(Model.Sound.Normal_AutoSpin);
                autoPanel.gameObject.SetActive(false);
                Model.Instance.CurrentAutoCount = autoCount;
                _hsm.ChangeState(nameof(AutoRollState));
            });
            settingPanel = MainContent.FindChildDepth<Button>("Content/Setting");
            UISetting.Add(settingPanel.gameObject);
            UIResult.Add(bottom.gameObject, info.SelfGold.transform);
        }

        private void AddListener()
        {
            //添加监听事件
            this.reduceChipBtn.onClick.RemoveAllListeners();
            this.reduceChipBtn.onClick.AddListener(this.ReduceChipCall);
            this.addChipBtn.onClick.RemoveAllListeners();
            this.addChipBtn.onClick.AddListener(this.AddChipCall);

            this.showRuleBtn.onClick.RemoveAllListeners(); //显示规则
            this.showRuleBtn.onClick.AddListener(this.ShowRulePanel);

            this.MaxChipBtn.onClick.RemoveAllListeners();
            this.MaxChipBtn.onClick.AddListener(this.SetMaxChipCall);

            settingBtn.onClick.RemoveAllListeners();
            settingBtn.onClick.Add(OnClickSetting);

            autoPanel.onClick.RemoveAllListeners();
            autoPanel.onClick.Add(() => { autoPanel.gameObject.SetActive(false); });
            
            stopAutoState.onClick.RemoveAllListeners();
            stopAutoState.onClick.Add(OnClickStopAuto);

            EventTriggerHelper trigger = EventTriggerHelper.Get(startState.gameObject);
            trigger.onDown = OnDown;
            trigger.onUp = OnUp;
        }

        private void OnClickStopAuto()
        {
            Model.Instance.IsAutoGame = false;
            stopState.gameObject.SetActive(true);
            startState.gameObject.SetActive(false);
            freeState.gameObject.SetActive(false);
            stopAutoState.gameObject.SetActive(false);
        }

        private void OnClickSetting()
        {
            settingPanel.gameObject.SetActive(true);
        }

        private void OnUp(GameObject arg1, PointerEventData arg2)
        {
            if (longClick == null) return;
            StopCoroutine(longClick);
            longClick = null;
            StartGameCall();
        }

        private void OnDown(GameObject arg1, PointerEventData arg2)
        {
            longClick = StartCoroutine(ToolHelper.DelayCall(1, () =>
            {
                autoPanel.gameObject.SetActive(true);
                longClick = null;
            }));
        }

        private void AddEvent()
        {
            HotfixGameMessageHelper.AddListener($"{Model.MDM_ScenInfo}|{DataStruct.GameSceneStruct.SUB_GF_SCENE}",
                OnReceiveScene);
            HotfixGameMessageHelper.AddListener($"{Model.MDM_GF_GAME}|{Model.SUB_SC_START_GAME}", OnReceiveGameInfo);
            HotfixMessageHelper.AddListener(Model.StartFailed, OnStartFailed);
            HotfixMessageHelper.AddListener(Model.StartRoll, OnStartRoll);
            HotfixMessageHelper.AddListener(Model.ShowResult, OnShowResult);
            HotfixMessageHelper.AddListener(Model.StopRoll, OnStopRoll);
            HotfixMessageHelper.AddListener(Model.Check, OnCheck);
            HotfixMessageHelper.AddListener(Model.ReqReRoll, OnReqReRoll);
        }

        private void RemoveEvent()
        {
            HotfixGameMessageHelper.RemoveListener($"{Model.MDM_ScenInfo}|{DataStruct.GameSceneStruct.SUB_GF_SCENE}",
                OnReceiveScene);
            HotfixGameMessageHelper.RemoveListener($"{Model.MDM_GF_GAME}|{Model.SUB_SC_START_GAME}", OnReceiveGameInfo);
            HotfixMessageHelper.RemoveListener(Model.StartFailed, OnStartFailed);
            HotfixMessageHelper.RemoveListener(Model.StartRoll, OnStartRoll);
            HotfixMessageHelper.RemoveListener(Model.ShowResult, OnShowResult);
            HotfixMessageHelper.RemoveListener(Model.StopRoll, OnStopRoll);
            HotfixMessageHelper.RemoveListener(Model.Check, OnCheck);
            HotfixMessageHelper.RemoveListener(Model.ReqReRoll, OnReqReRoll);
        }

        private void ReduceChipCall()
        {
            //减注
            Model.Instance.PlaySound(Model.Sound.Normal_Reduce.ToString());
            if (Model.Instance.SceneInfo.chipList == null || Model.Instance.SceneInfo.chipList.Count <= 0) return;
            Model.Instance.CurrentChipIndex -= 1;
            if (Model.Instance.CurrentChipIndex < 0)
            {
                Model.Instance.CurrentChipIndex = 0;
                ToolHelper.PopSmallWindow("Bets have reached the minimum");
                return;
            }

            Model.Instance.CurrentChip = Model.Instance.SceneInfo.chipList[Model.Instance.CurrentChipIndex];
            ChipNum.SetText($"{(Model.Instance.CurrentChip * Data.Alllinecount).ShortNumber()}");
        }

        private void AddChipCall()
        {
            //加注
            Model.Instance.PlaySound(Model.Sound.Normal_Addbet.ToString());
            if (Model.Instance.SceneInfo.chipList == null || Model.Instance.SceneInfo.chipList.Count <= 0) return;
            Model.Instance.CurrentChipIndex += 1;
            if (Model.Instance.CurrentChipIndex >= Model.Instance.SceneInfo.chipNum)
            {
                Model.Instance.CurrentChipIndex = Model.Instance.SceneInfo.chipNum - 1;
                ToolHelper.PopSmallWindow("Bet max reached");
                return;
            }

            Model.Instance.CurrentChip = Model.Instance.SceneInfo.chipList[Model.Instance.CurrentChipIndex];
            ChipNum.SetText($"{(Model.Instance.CurrentChip * Data.Alllinecount).ShortNumber()}");
        }

        private void StartGameCall()
        {
            //开始游戏
            if (Model.Instance.IsFreeGame) return;
            if (Model.Instance.IsRoll)
            {
                //TODO 急停
                return;
            }

            Model.Instance.PlaySound(Model.Sound.Normal_Spin.ToString());
            _hsm?.ChangeState(nameof(NormalRollState));
        }
        private void ShowRulePanel()
        {
            //显示规则
            Model.Instance.PlaySound(Model.Sound.BTN.ToString());
            _rule.Show();
        }

        private void SetMaxChipCall()
        {
            //设置最大下注
            Model.Instance.PlaySound(Model.Sound.Normal_MaxBet);
            Model.Instance.CurrentChipIndex = Model.Instance.SceneInfo.chipNum - 1;
            Model.Instance.CurrentChip = Model.Instance.SceneInfo.chipList[Model.Instance.CurrentChipIndex];
            ChipNum.text = $"{(Model.Instance.CurrentChip * Data.Alllinecount).ShortNumber()}";
        }

        private void OnStartFailed(object data)
        {
            _hsm.ChangeState(nameof(IdleState));
        }

        private void OnStartRoll(object data)
        {
            //开始转动    
            if (Model.Instance.IsFreeGame || Model.Instance.IsReRoll) return;
            Model.Instance.MyGold -= (ulong) Model.Instance.CurrentChip * Data.Alllinecount;
            HotfixMessageHelper.PostHotfixEvent(Model.RefreshGold);
        }

        private void OnShowResult(object data)
        {
            if (Model.Instance.ResultInfo.WinScore > 0) return;
            StartCoroutine(ToolHelper.DelayCall(Data.AutoNoRewardInterval, () =>
            {
                HotfixMessageHelper.PostHotfixEvent(Model.RefreshGold);
                Model.Instance.IsReRoll = false;
                _hsm.ChangeState(nameof(CheckState));
            }));
        }

        private void OnStopRoll(object data)
        {
            HotfixMessageHelper.PostHotfixEvent(Model.ShowResult);
        }

        private void OnReqReRoll(object data)
        {
            _hsm.ChangeState(nameof(ReRollState));
        }

        private void OnCheck(object data)
        {
            _hsm.ChangeState(nameof(CheckState));
        }

        private void OnReceiveGameInfo(IGameData data)
        {
            if (!(data is BQTPStruct.ResultInfo resultInfo)) return;
            if (Model.Instance.ReRollCount > 0)
            {
                HotfixMessageHelper.PostHotfixEvent(Model.Instance.IsScene ? Model.StartRoll : Model.StartReRoll);
            }
            else
            {
                HotfixMessageHelper.PostHotfixEvent(Model.StartRoll);
            }
        }

        private void OnReceiveScene(IGameData data)
        {
            //场景消息初始化
            if (!(data is BQTPStruct.SceneInfo sceneInfo)) return;
            HotfixMessageHelper.PostHotfixEvent(Model.RefreshGold);
            for (int i = 0; i < Model.Instance.SceneInfo.chipList.Count; i++)
            {
                if (Model.Instance.SceneInfo.chipList[i] != Model.Instance.SceneInfo.bet) continue;
                Model.Instance.CurrentChipIndex = i;
                Model.Instance.CurrentChip = Model.Instance.SceneInfo.bet;
            }

            if (Model.Instance.SceneInfo.freeNumber <= 0)
            {
                Model.Instance.CurrentChipIndex = Model.Instance.MyGold.CheckNear(Model.Instance.SceneInfo.chipList);
                Model.Instance.CurrentChip = Model.Instance.SceneInfo.chipList[Model.Instance.CurrentChipIndex];
            }
            ChipNum.SetText($"{(Model.Instance.CurrentChip * Data.Alllinecount).ShortNumber()}");

            Model.Instance.IsRoll = false;
            Model.Instance.IsFreeGame = false;
            Model.Instance.IsAutoGame = false;
            _hsm.ChangeState(nameof(CheckState));
            AddListener();
        }

        private void OnEnterFreeAnimationEventHandler(string type, EventObject eventobject)
        {
            Model.Instance.IsFreeGame = true;
            enterFreeEffect.RemoveDBEventListener(DragonBones.EventObject.COMPLETE, OnEnterFreeAnimationEventHandler);
            freeText.text = ToolHelper.ShowRichText(Model.Instance.FreeCount);
            normalBg.gameObject.SetActive(false);
            freeBg.gameObject.SetActive(true);
            Model.Instance.PlayBGM(Model.Sound.FreeBGM.ToString());
            _hsm.ChangeState(nameof(CheckState));
        }

        private void OnExitFreeAnimationEventHandler(string type, EventObject eventobject)
        {
            Model.Instance.IsFreeGame = false;
            exitFreeEffect.RemoveDBEventListener(DragonBones.EventObject.COMPLETE, OnExitFreeAnimationEventHandler);
            exitFreeEffect.gameObject.SetActive(false);
            freeText.text = "";
            normalBg.gameObject.SetActive(true);
            freeBg.gameObject.SetActive(false);
            Model.Instance.PlaySound(Model.Sound.FreeSpin_End);
            StartCoroutine(ToolHelper.DelayCall(4, () =>
            {
                Model.Instance.ClearAuido(Model.Sound.FreeSpin_End.ToString());
                Model.Instance.PlayBGM();
                _hsm.ChangeState(nameof(CheckState));
            }));
        }


        private class IdleState : State<UIEntry>
        {
            public IdleState(UIEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.startState.gameObject.SetActive(true);
                owner.stopState.gameObject.SetActive(false);
                owner.stopAutoState.gameObject.SetActive(false);
                owner.freeState.gameObject.SetActive(false);
                owner.startState.interactable = true;
                owner.MaxChipBtn.interactable = true;
                owner.stopAutoState.interactable = true;
                owner.addChipBtn.interactable = true;
                owner.reduceChipBtn.interactable = true;
                owner.settingBtn.interactable = true;
                Model.Instance.IsAutoGame = false;
                Model.Instance.CurrentAutoCount = 0;
                Model.Instance.IsFreeGame = false;
                Model.Instance.IsRoll = false;
            }
        }

        private class ReRollState : State<UIEntry>
        {
            public ReRollState(UIEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                Model.Instance.IsReRoll = true;
                for (int i = 0; i < owner.freeBLGroup.childCount; i++)
                {
                    owner.freeBLGroup.GetChild(i).GetComponent<Toggle>().SetIsOnWithoutNotify(false);
                }

                for (int i = 0; i < Model.Instance.ReRollCount; i++)
                {
                    if (i < owner.freeBLGroup.childCount)
                    {
                        owner.freeBLGroup.GetChild(i).GetComponent<Toggle>().SetIsOnWithoutNotify(true);
                    }
                }

                Model.Instance.StartGame();
            }
        }

        private class NormalRollState : State<UIEntry>
        {
            public NormalRollState(UIEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.startState.gameObject.SetActive(false);
                owner.stopState.gameObject.SetActive(true);
                owner.stopAutoState.gameObject.SetActive(false);
                owner.freeState.gameObject.SetActive(false);
                owner.startState.interactable = false;
                owner.MaxChipBtn.interactable = false;
                owner.stopAutoState.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.settingBtn.interactable = false;
                Model.Instance.IsRoll = true;
                Model.Instance.StartGame();
            }
        }

        private class AutoRollState : State<UIEntry>
        {
            public AutoRollState(UIEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.startState.gameObject.SetActive(false);
                owner.stopState.gameObject.SetActive(false);
                owner.stopAutoState.gameObject.SetActive(true);
                owner.freeState.gameObject.SetActive(false);
                owner.startState.interactable = false;
                owner.MaxChipBtn.interactable = false;
                owner.stopAutoState.interactable = true;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.settingBtn.interactable = false;
                if (Model.Instance.CurrentAutoCount < 1000) --Model.Instance.CurrentAutoCount;
                Model.Instance.IsAutoGame = Model.Instance.CurrentAutoCount > 0;
                if (Model.Instance.IsRoll) return;
                Model.Instance.IsRoll = true;
                Model.Instance.StartGame();
                owner.stopAutoStateDesc.SetText(
                    $"<b>STOP</b>\r\n<size=16>Left {(Model.Instance.CurrentAutoCount > 1000 ? "∞" : Model.Instance.CurrentAutoCount.ToString())}</size>");
            }
        }

        private class FreeRollState : State<UIEntry>
        {
            public FreeRollState(UIEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.startState.gameObject.SetActive(false);
                owner.stopState.gameObject.SetActive(false);
                owner.stopAutoState.gameObject.SetActive(false);
                owner.freeState.gameObject.SetActive(true);
                owner.startState.interactable = false;
                owner.MaxChipBtn.interactable = false;
                owner.stopAutoState.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.settingBtn.interactable = false;
                Model.Instance.IsRoll = true;
                for (int i = 0; i < owner.freeBLGroup.childCount; i++)
                {
                    owner.freeBLGroup.GetChild(i).GetComponent<Toggle>().SetIsOnWithoutNotify(false);
                }

                Model.Instance.StartGame();
                owner.freeStateDesc.SetText(
                    $"<b>FREE GAME</b>\r\n<size=16>Left {Model.Instance.FreeCount - 1}</size>");
            }
        }

        private class CheckState : State<UIEntry>
        {
            public CheckState(UIEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                Model.Instance.IsRoll = false;
                if (Model.Instance.FreeCount > 0)
                {
                    owner.freeText.text = ToolHelper.ShowRichText(Model.Instance.FreeCount);
                    if (Model.Instance.IsFreeGame)
                    {
                        hsm.ChangeState(nameof(FreeRollState));
                    }
                    else
                    {
                        owner.enterFreeEffect.gameObject.SetActive(true);
                        owner.enterFreeEffect.AddDBEventListener(DragonBones.EventObject.COMPLETE,
                            owner.OnEnterFreeAnimationEventHandler);
                        owner.enterFreeEffect.dbAnimation.Play("Sprite", 1);
                    }
                }
                else
                {
                    if (Model.Instance.IsFreeGame)
                    {
                        owner.enterFreeEffect.gameObject.SetActive(false);
                        owner.exitFreeEffect.gameObject.SetActive(true);
                        owner.exitFreeEffect.AddDBEventListener(DragonBones.EventObject.COMPLETE,
                            owner.OnExitFreeAnimationEventHandler);
                        owner.exitFreeEffect.dbAnimation.Play("Sprite", 1);
                    }
                    else if (Model.Instance.IsAutoGame)
                    {
                        hsm.ChangeState(nameof(AutoRollState));
                    }
                    else
                    {
                        if (Model.Instance.ReRollCount > 0)
                        {
                            Model.Instance.IsReRoll = true;
                            hsm.ChangeState(nameof(NormalRollState));
                        }
                        else
                        {
                            hsm.ChangeState(nameof(IdleState));
                        }
                    }
                }
            }
        }
    }
}