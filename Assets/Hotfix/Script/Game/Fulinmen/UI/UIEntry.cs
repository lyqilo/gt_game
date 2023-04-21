using System;
using System.Collections.Generic;
using LuaFramework;
using Spine.Unity;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace Hotfix.Fulinmen
{
    public class UIEntry : MonoBehaviour, IILManager
    {
        private HierarchicalStateMachine _hsm;
        private List<IState> _states;
        private Coroutine longClick;
        private TextMeshProUGUI DFMosaicNum;
        private TextMeshProUGUI XFMosaicNum;
        private TextMeshProUGUI ChipNum;
        private Button reduceChipBtn;
        private Button addChipBtn;
        private Transform btnGroup;
        private Transform startBtn;
        private Button stopAutoBtn;
        private Transform freeState;
        private Button skinBtn;
        private Button MaxChipBtn;
        private Transform resultEffect;
        private Button settingBtn;

        private UIRule _rule;
        private Button showRuleBtn;
        private Button _autoPanel;
        private UISetting _setting;

        private void Awake()
        {
            Screen.orientation = UnityEngine.ScreenOrientation.Landscape;
            Screen.autorotateToLandscapeLeft = true;
            Screen.autorotateToLandscapeRight = true;
            Screen.autorotateToPortrait = false;
            Screen.autorotateToPortraitUpsideDown = false;
            FindComponent();
            gameObject.CreateOrGetComponent<UIJackpot>();
            gameObject.CreateOrGetComponent<Model>();
            AddListener();
            AddEvent();
            _states = new List<IState>();
            _hsm = new HierarchicalStateMachine(false, gameObject);
            _states.Add(new IdleState(this, _hsm));
            _states.Add(new CheckState(this, _hsm));
            _states.Add(new NormalRollState(this, _hsm));
            _states.Add(new AutoRollState(this, _hsm));
            _states.Add(new FreeRollState(this, _hsm));
            _states.Add(new DJJYState(this, _hsm));
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

        private void OnDestroy()
        {
            _hsm?.CurrentState?.OnExit();
            RemoveEvent();
        }

        private void FindComponent()
        {
            DFMosaicNum = transform.FindChildDepth<TextMeshProUGUI>("Content/Mosaic/D");
            XFMosaicNum = transform.FindChildDepth<TextMeshProUGUI>("Content/Mosaic/X");
            var rollContent = transform.FindChildDepth("Content/RollContent"); //转动区域
            UIRoll.Add(rollContent.gameObject);
            ChipNum = transform.FindChildDepth<TextMeshProUGUI>("Content/Bottom/Chip/Num"); //下注金额

            reduceChipBtn = transform.FindChildDepth<Button>("Content/Bottom/Chip/Reduce"); //减注
            addChipBtn = transform.FindChildDepth<Button>("Content/Bottom/Chip/Add"); //加注

            Transform userInfo = transform.FindChildDepth($"Content/UserInfo");
            var info = UIUserInfo.Add(userInfo.gameObject);

            btnGroup = transform.FindChildDepth("Content/ButtonGroup");
            startBtn = btnGroup.FindChildDepth("StartState"); //开始按钮
            freeState = btnGroup.FindChildDepth("FreeState"); //免费状态
            stopAutoBtn = btnGroup.FindChildDepth<Button>("StopAutoState");
            skinBtn = btnGroup.FindChildDepth<Button>("SkinState");

            MaxChipBtn = transform.FindChildDepth<Button>("MaxChip"); //最大下注
            this.settingBtn = transform.FindChildDepth<Button>("Content/SettingBtn");
            showRuleBtn = transform.FindChildDepth<Button>("Content/RuleBtn");

            _autoPanel = transform.FindChildDepth<Button>("Content/AutoGroup");
            UIAuto.Add(_autoPanel.gameObject, autoCount =>
            {
                Model.Instance.PlaySound(Model.Sound.Button);
                _autoPanel.gameObject.SetActive(false);
                Model.Instance.CurrentAutoCount = autoCount;
                _hsm.ChangeState(nameof(AutoRollState));
            });

            var rulePanel = transform.FindChildDepth("Content/Rule"); //规则界面
            _rule = UIRule.Add(rulePanel.gameObject);
            
            var settingPanel = transform.FindChildDepth("Content/Setting"); //规则界面
            _setting = UISetting.Add(settingPanel.gameObject);

            resultEffect = transform.FindChildDepth("Content/Result"); //中奖后特效
            UIResult.Add(resultEffect.gameObject, info.SelfGold.transform);
            var lineGroup = transform.FindChildDepth("LineGroup"); //连线
            UILine.Add(lineGroup.gameObject);
        }

        private void AddListener()
        {
            //添加监听事件
            reduceChipBtn.onClick.RemoveAllListeners();
            reduceChipBtn.onClick.AddListener(ReduceChipCall);
            addChipBtn.onClick.RemoveAllListeners();
            addChipBtn.onClick.AddListener(AddChipCall);
            MaxChipBtn.onClick.RemoveAllListeners();
            MaxChipBtn.onClick.AddListener(SetMaxChipCall);
            showRuleBtn.onClick.RemoveAllListeners(); //显示规则
            showRuleBtn.onClick.AddListener(ShowRulePanel);

            var helper = EventTriggerHelper.Get(startBtn.gameObject);
            helper.onDown = OnDown;
            helper.onUp = OnUp;
            
            stopAutoBtn.onClick.RemoveAllListeners();
            stopAutoBtn.onClick.Add(OnClickStopAuto);
            skinBtn.onClick.RemoveAllListeners();
            skinBtn.onClick.Add(OnClickSkin);
            settingBtn.onClick.RemoveAllListeners(); //显示规则
            settingBtn.onClick.AddListener(ShowSettingPanel);
        }

        private void AddEvent()
        {
            HotfixGameMessageHelper.AddListener($"{Model.MDM_ScenInfo}|{DataStruct.GameSceneStruct.SUB_GF_SCENE}",
                OnReceiveScene);
            HotfixGameMessageHelper.AddListener($"{Model.MDM_GF_GAME}|{Model.SUB_SC_GAME_OVER}", OnReceiveGameInfo);
            HotfixMessageHelper.AddListener(Model.StartRoll, OnStartRoll);
            HotfixMessageHelper.AddListener(Model.ShowResult, OnShowResult);
            HotfixMessageHelper.AddListener(Model.Check, OnCheck);
            HotfixMessageHelper.AddListener(Model.DJJYRoll, OnDJJYRoll);
        }

        private void RemoveEvent()
        {
            HotfixGameMessageHelper.RemoveListener($"{Model.MDM_ScenInfo}|{DataStruct.GameSceneStruct.SUB_GF_SCENE}",
                OnReceiveScene);
            HotfixGameMessageHelper.RemoveListener($"{Model.MDM_GF_GAME}|{Model.SUB_SC_GAME_OVER}", OnReceiveGameInfo);
            HotfixMessageHelper.RemoveListener(Model.StartRoll, OnStartRoll);
            HotfixMessageHelper.RemoveListener(Model.ShowResult, OnShowResult);
            HotfixMessageHelper.RemoveListener(Model.Check, OnCheck);
            HotfixMessageHelper.RemoveListener(Model.DJJYRoll, OnDJJYRoll);
        }


        private void OnClickSkin()
        {
            if (!Model.Instance.IsRoll) return;
            //TODO急停
            HotfixMessageHelper.PostHotfixEvent(Model.ForceStopRoll);
        }

        private void OnClickStopAuto()
        {
            if (!Model.Instance.IsAutoGame) return;
            Model.Instance.IsAutoGame = false;
            skinBtn.gameObject.SetActive(true);
            stopAutoBtn.gameObject.SetActive(false);
        }
        private void OnShowResult(object data)
        {
        }

        private void OnCheck(object data)
        {
            _hsm.ChangeState(nameof(CheckState));
        }

        private void OnDJJYRoll(object data)
        {
            _hsm.ChangeState(nameof(DJJYState));
        }

        private void OnStartRoll(object data)
        {
            //开始转动    
            if (Model.Instance.IsFreeGame || Model.Instance.IsDJJY) return;
            HotfixMessageHelper.PostHotfixEvent(Model.RefreshGold,
                Model.Instance.MyGold - (ulong) Model.Instance.CurrentChip * Data.Alllinecount);
        }

        private void OnReceiveScene(IGameData data)
        {
            //场景消息初始化
            HotfixMessageHelper.PostHotfixEvent(Model.RefreshGold);
            XFMosaicNum.text = Model.Instance.SceneInfo.fuTimes[0].ShortNumber().ShowRichText();
            DFMosaicNum.text = Model.Instance.SceneInfo.fuTimes[1].ShortNumber().ShowRichText();
            if (Model.Instance.SceneInfo.bet == 0)
            {
                Model.Instance.CurrentChipIndex = 0;
            }
            for (int i = 0; i < Model.Instance.SceneInfo.chipList.Count; i++)
            {
                if (Model.Instance.SceneInfo.chipList[i] != Model.Instance.SceneInfo.bet) continue;
                Model.Instance.CurrentChipIndex = i;
            }

            if (Model.Instance.SceneInfo.FreeCount <= 0 && Model.Instance.SceneInfo.GoldModelNum <= 0)
            {
                Model.Instance.CurrentChipIndex = Model.Instance.MyGold.CheckNear(Model.Instance.SceneInfo.chipList);
            }

            Model.Instance.CurrentChip = Model.Instance.SceneInfo.chipList[Model.Instance.CurrentChipIndex];
            ChipNum.text = (Model.Instance.CurrentChip * Data.Alllinecount).ShortNumber();
            

            if (Model.Instance.SceneInfo.GoldModelNum > 0)
            {
                HotfixMessageHelper.PostHotfixEvent(Model.ShowResult);
            }
            else if (Model.Instance.SceneInfo.FreeCount > 0)
            {
                //如果免费
                HotfixMessageHelper.PostHotfixEvent(Model.ShowFree);
            }
        }

        private void OnReceiveGameInfo(IGameData data)
        {
            if (!(data is FulinmenStruct.ResultInfo resultInfo)) return;
            HotfixMessageHelper.PostHotfixEvent(Model.StartRoll);
        }

        private void ReduceChipCall()
        {
            //减注
            Model.Instance.PlaySound(Model.Sound.Button);
            if (Model.Instance.SceneInfo.chipList == null || Model.Instance.SceneInfo.chipList.Count <= 0) return;
            Model.Instance.CurrentChipIndex -= 1;
            if (Model.Instance.CurrentChipIndex < 0)
                Model.Instance.CurrentChipIndex = Model.Instance.SceneInfo.chipList.Count - 1;
            Model.Instance.CurrentChip = Model.Instance.SceneInfo.chipList[Model.Instance.CurrentChipIndex];
            ChipNum.SetText((Model.Instance.CurrentChip * Data.Alllinecount).ShortNumber());
        }

        private void AddChipCall()
        {
            //加注
            Model.Instance.PlaySound(Model.Sound.Button);
            if (Model.Instance.SceneInfo.chipList == null || Model.Instance.SceneInfo.chipList.Count <= 0) return;
            Model.Instance.CurrentChipIndex += 1;
            if (Model.Instance.CurrentChipIndex >= Model.Instance.SceneInfo.chipList.Count)
                Model.Instance.CurrentChipIndex = 0;
            Model.Instance.CurrentChip = Model.Instance.SceneInfo.chipList[Model.Instance.CurrentChipIndex];
            ChipNum.SetText((Model.Instance.CurrentChip * Data.Alllinecount).ShortNumber());
        }

        private void StartGameCall()
        {
            //开始游戏
            if (Model.Instance.IsFreeGame || Model.Instance.IsAutoGame) return;

            Model.Instance.PlaySound(Model.Sound.Button);
            //播放闲置动画
            if (Model.Instance.MyGold < (ulong) Model.Instance.CurrentChip * Data.Alllinecount)
            {
                ToolHelper.PopSmallWindow("Not enough gold!");
                return;
            }

            _hsm.ChangeState(nameof(NormalRollState));
        }

        private void SetMaxChipCall()
        {
            //设置最大下注
            Model.Instance.PlaySound(Model.Sound.Button);
            Model.Instance.CurrentChipIndex = Model.Instance.SceneInfo.chipList.Count - 1;
            Model.Instance.CurrentChip = Model.Instance.SceneInfo.chipList[Model.Instance.CurrentChipIndex];
            ChipNum.SetText((Model.Instance.CurrentChip * Data.Alllinecount).ShortNumber());
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
                longClick = null;
                if (Model.Instance.IsRoll || Model.Instance.IsFreeGame || Model.Instance.IsAutoGame) return;
                _autoPanel.gameObject.SetActive(true);
            }));
        }
        private void ShowRulePanel()
        {
            //显示规则
            Model.Instance.PlaySound(Model.Sound.Button);
            _rule.Show();
        }

        private void ShowSettingPanel()
        {
            _setting.gameObject.SetActive(true);
        }

        private class IdleState : State<UIEntry>
        {
            public IdleState(UIEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.MaxChipBtn.interactable = true;
                owner.addChipBtn.interactable = true;
                owner.reduceChipBtn.interactable = true;
                owner.showRuleBtn.interactable = true;
                owner.settingBtn.interactable = true;
                Model.Instance.IsRoll = false;
                Model.Instance.IsFreeGame = false;
                Model.Instance.IsAutoGame = false;
                owner.skinBtn.interactable = true;
                owner.freeState.gameObject.SetActive(false);
                owner.stopAutoBtn.gameObject.SetActive(false);
                owner.startBtn.gameObject.SetActive(true);
                owner.skinBtn.gameObject.SetActive(false);
                owner.skinBtn.interactable = true;
                owner.stopAutoBtn.interactable = true;
            }
        }

        private class AutoRollState : State<UIEntry>
        {
            private TextMeshProUGUI _autonum;
            private Transform _infinite;

            public AutoRollState(UIEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.MaxChipBtn.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.showRuleBtn.interactable = false;
                owner.settingBtn.interactable = false;
                owner.skinBtn.interactable = true;
                owner.skinBtn.gameObject.SetActive(false);
                owner.freeState.gameObject.SetActive(false);
                owner.startBtn.gameObject.SetActive(false);
                owner.stopAutoBtn.gameObject.SetActive(true);
                if (Model.Instance.CurrentAutoCount < 1000) --Model.Instance.CurrentAutoCount;
                Model.Instance.IsAutoGame = Model.Instance.CurrentAutoCount > 0;
                Model.Instance.IsFreeGame = false;
                _autonum ??= owner.stopAutoBtn.transform.FindChildDepth<TextMeshProUGUI>("Num");
                _autonum.SetText(
                    $"LEFT {(Model.Instance.CurrentAutoCount > 1000 ? "<size=25>∞</size>" : Model.Instance.CurrentAutoCount.ToString())}");
                Model.Instance.IsRoll = true;
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
                owner.MaxChipBtn.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.showRuleBtn.interactable = false;
                owner.settingBtn.interactable = false;
                owner.skinBtn.interactable = true;
                owner.freeState.gameObject.SetActive(false);
                owner.stopAutoBtn.gameObject.SetActive(false);
                owner.startBtn.gameObject.SetActive(false);
                owner.skinBtn.gameObject.SetActive(true);
                //TODO 发送开始消息, 等待结果开始转动
                Model.Instance.StartGame();
                Model.Instance.IsRoll = true;
            }
        }

        private class FreeRollState : State<UIEntry>
        {
            private TextMeshProUGUI _freeNum;

            public FreeRollState(UIEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                Model.Instance.IsRoll = true;
                Model.Instance.IsFreeGame = true;
                owner.MaxChipBtn.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.showRuleBtn.interactable = false;
                owner.settingBtn.interactable = false;
                owner.freeState.gameObject.SetActive(true);
                owner.stopAutoBtn.gameObject.SetActive(false);
                owner.skinBtn.gameObject.SetActive(false);
                owner.startBtn.gameObject.SetActive(false);
                Model.Instance.FreeCount--;
                _freeNum ??= owner.freeState.transform.Find("Num").GetComponent<TextMeshProUGUI>();
                _freeNum.SetText($"LEFT {Model.Instance.FreeCount}");
                Model.Instance.StartGame();
            }
        }


        private class DJJYState : State<UIEntry>
        {
            private TextMeshProUGUI autonum;
            private Transform infinite;

            public DJJYState(UIEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.MaxChipBtn.interactable = false;
                owner.addChipBtn.interactable = false;
                owner.reduceChipBtn.interactable = false;
                owner.showRuleBtn.interactable = false;
                owner.settingBtn.interactable = false;
                owner.freeState.gameObject.SetActive(false);
                owner.stopAutoBtn.gameObject.SetActive(true);
                owner.skinBtn.gameObject.SetActive(false);
                owner.startBtn.gameObject.SetActive(false);
                owner.stopAutoBtn.interactable = false;
                Model.Instance.IsRoll = true;
                autonum ??= owner.stopAutoBtn.transform.FindChildDepth<TextMeshProUGUI>("Num");
                autonum.SetText($"LEFT {Model.Instance.ResultInfo.GoldModelNum - 1}");
                Model.Instance.StartGame();
            }

            public override void OnExit()
            {
                base.OnExit();
                owner.stopAutoBtn.interactable = true;
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
                if (Model.Instance.IsDJJY) return;
                if (Model.Instance.IsFreeGame)
                {
                    if (Model.Instance.FreeCount <= 0)
                    {
                        //免费结束
                        Model.Instance.PlayBGM();
                        CheckAuto();
                    }
                    else
                    {
                        //还有免费次数
                        hsm.ChangeState(nameof(FreeRollState));
                    }
                }
                else
                {
                    CheckAuto();
                }
            }

            private void CheckAuto()
            {
                //判断是否为自动游戏
                if (Model.Instance.IsAutoGame)
                {
                    //如果是自动游戏
                    hsm.ChangeState(Model.Instance.CurrentAutoCount <= 0 ? nameof(IdleState) : nameof(AutoRollState));
                }
                else
                {
                    //不是自动游戏，直接待机
                    hsm.ChangeState(nameof(IdleState));
                }
            }
        }
    }
}