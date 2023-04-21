

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

namespace Hotfix.CMLHJ
{
    /// <summary>
    /// 游戏主入口
    /// </summary>
    public class CMLHJEntry : SingletonILEntity<CMLHJEntry>
    {
        public Data GameData { get; set; }

        public Transform MainContent;

        private Transform normalGame;
        public Transform RollContent;
        private Transform LineData;

        private Transform menu;
        private Transform buttomMenu;
        private Button addChipBtn;
        private TextMeshProUGUI chipNum;
        private TextMeshProUGUI allChipInfo;
        private Button startState;
        private Button OverBtn;
        private Button autoBtn;
        private Button closeAutoBtn;
        private Transform userInfo;
        private TextMeshProUGUI selfGold;
        public Transform WinInfo;
        public TextMeshProUGUI WinInfoNum;

        private Transform topMenu;
        private Transform tipText;
        private Transform lineTipText;

        private Transform rulePanel;
        private Transform resultPanel;
        public Transform SmallGamePanel;
        private Transform Sounds;
        public Transform Icons;
        public Transform effectPool;

        HierarchicalStateMachine hsm;
        List<IState> states;
        bool isStopRoll;

        private float onDownTime;
        private bool isOnDownState;

        private long allGetGold;
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
            gameObject.AddILComponent<CMLHJ_Network>();
            gameObject.AddILComponent<CMLHJ_Audio>();
            onDownTime = 0f;
            isOnDownState = false;
            isStopRoll = true;
            ILGameManager.Instance.GetGameSetPanel(MainContent);
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
            states.Add(new EnterBounsState(this, hsm));
            hsm.Init(states, nameof(IdleState));
            rulePanel.gameObject.AddILComponent<CMLHJ_Rule>();
            resultPanel.gameObject.AddILComponent<CMLHJ_Result>();
            RollContent.gameObject.AddILComponent<CMLHJ_Roll>();
            LineData.gameObject.AddILComponent<CMLHJ_Line>();
            SmallGamePanel.gameObject.AddILComponent<CMLHJ_SmallGame>();
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
            CMLHJ_Event.RefreshGold += CMLHJ_Event_RefreshGold;
            CMLHJ_Event.OnGetSceneData += CMLHJ_Event_OnGetSceneData;
            CMLHJ_Event.ShowResultComplete += CMLHJ_Event_ShowResultComplete;
            CMLHJ_Event.OnChangeBet += CMLHJ_Event_OnChangeBet;
            CMLHJ_Event.RollPrepreaComplete += CMLHJ_Event_RollPrepreaComplete;
            CMLHJ_Event.RollComplete += CMLHJ_Event_RollComplete;
            CMLHJ_Event.RollFailed += CMLHJ_Event_RollFailed;
            CMLHJ_Event.StartRoll += CMLHJEvent_ShowResult;
            CMLHJ_Event.ShowSingleLine += CMLHJ_Event_ShowResult;
            HotfixActionHelper.LoadGameRule += ShowRulePanel;
            HotfixActionHelper.LoadGameExit += CloseGameCall;
        }
        protected override void RemoveEvent()
        {
            CMLHJ_Event.RefreshGold -= CMLHJ_Event_RefreshGold;
            CMLHJ_Event.OnGetSceneData -= CMLHJ_Event_OnGetSceneData;
            CMLHJ_Event.ShowResultComplete -= CMLHJ_Event_ShowResultComplete;
            CMLHJ_Event.OnChangeBet -= CMLHJ_Event_OnChangeBet;
            CMLHJ_Event.RollPrepreaComplete -= CMLHJ_Event_RollPrepreaComplete;
            CMLHJ_Event.RollComplete -= CMLHJ_Event_RollComplete;
            CMLHJ_Event.RollFailed -= CMLHJ_Event_RollFailed;
            CMLHJ_Event.StartRoll -= CMLHJEvent_ShowResult;
            CMLHJ_Event.ShowSingleLine -= CMLHJ_Event_ShowResult;
            HotfixActionHelper.LoadGameRule -= ShowRulePanel;
            HotfixActionHelper.LoadGameExit -= CloseGameCall;
        }

        protected override void FindComponent()
        {
            MainContent = transform.FindChildDepth("Main/Content");
            normalGame = MainContent.FindChildDepth("NormalGame");
            RollContent = normalGame.FindChildDepth("ViewPort/Scroll"); //转动区域

            menu = MainContent.FindChildDepth("Menu");//总菜单
            buttomMenu = menu.FindChildDepth("ButtomMenu");//下方
            chipNum= buttomMenu.FindChildDepth<TextMeshProUGUI>("chipInfo/stake/chip");//单注
            allChipInfo = buttomMenu.FindChildDepth<TextMeshProUGUI>("allChipInfo/stake/allChip");//单注
            addChipBtn = buttomMenu.FindChildDepth<Button>("addBtn");//加注
            startState = buttomMenu.FindChildDepth<Button>("startBtn");//开始
            OverBtn = buttomMenu.FindChildDepth<Button>("OverBtn");//结算
            autoBtn = buttomMenu.FindChildDepth<Button>("autoBtn");//自动
            closeAutoBtn = buttomMenu.FindChildDepth<Button>("closeAutoBtn");//停止自动
            userInfo = buttomMenu.FindChildDepth("Playinfo");
            selfGold = userInfo.FindChildDepth<TextMeshProUGUI>("playerGold"); //自身金币
            WinInfo = buttomMenu.FindChildDepth("winInfo");
            WinInfoNum = WinInfo.FindChildDepth<TextMeshProUGUI>("Text");

            topMenu = menu.FindChildDepth("TopMenu");//下方
            tipText= topMenu.FindChildDepth("Text1");
            lineTipText = topMenu.FindChildDepth("Text2");

            rulePanel = transform.FindChildDepth("RulePanel"); //规则界面
            resultPanel = transform.FindChildDepth("ResultPanel");//结算界面
            SmallGamePanel= transform.FindChildDepth("SmallGamePanel");
            Sounds = transform.FindChildDepth("Sound");
            Icons = transform.FindChildDepth("Icons");
            effectPool = transform.FindChildDepth("effectPool");
            LineData = this.transform.FindChildDepth("Main/Content/NormalGame/ViewPort/LineData");
        }
        private void AddListener()
        {
            addChipBtn.onClick.RemoveAllListeners();
            addChipBtn.onClick.Add(AddChipCall);

            startState.onClick.RemoveAllListeners();
            startState.onClick.Add(StartGameCall);

            OverBtn.onClick.RemoveAllListeners();
            OverBtn.onClick.Add(OverGameCall);

            autoBtn.onClick.RemoveAllListeners();
            autoBtn.onClick.Add(()=>
            {
                OnClickAutoCall();
            });

            closeAutoBtn.onClick.RemoveAllListeners();
            closeAutoBtn.onClick.Add(StopAutoGame);
        }

        private void CMLHJ_Event_RefreshGold(long gold)
        {
            GameData.myGold = gold;
            selfGold.text =GameData.myGold.ShortNumber().ShowRichText();
        }

        private void CMLHJ_Event_OnGetSceneData()
        {
            hsm?.ChangeState(nameof(InitState));
        }

        private void CMLHJ_Event_ShowResultComplete()
        {
            //TODO 收分做跳跃动画
            DebugHelper.Log("===收分做跳跃动画===");
            hsm?.ChangeState(nameof(CheckState));
            CMLHJEvent_ShowResult();
            CMLHJ_Event.DispatchRefreshGold((long)GameLocalMode.Instance.UserGameInfo.Gold);
        }

        private void CMLHJ_Event_OnChangeBet()
        {
            chipNum.text = GameData.CurrentChip.ShortNumber().ShowRichText();
            allChipInfo.text =(GameData.CurrentChip*CMLHJ_DataConfig.ALLLINECOUNT).ShortNumber().ShowRichText();
        }

        private void CMLHJ_Event_RollComplete()
        {
            CMLHJ_Event.DispatchShowResult();
        }

        private void CMLHJ_Event_RollPrepreaComplete()
        {
            hsm?.ChangeState(nameof(WaitStopState));
        }

        private void CMLHJ_Event_RollFailed()
        {
            hsm?.ChangeState(nameof(IdleState));
        }

        private void CMLHJ_Event_ShowResult(int gold)
        {
            allGetGold += gold;
            WinInfoNum.text = allGetGold.ShortNumber().ShowRichText();
        }

        private void CMLHJEvent_ShowResult()
        {
            allGetGold = 0;
            WinInfoNum.text = 0.ShortNumber().ShowRichText();
        }

        public void CMLHJ_ShowResultNum(bool b)
        {
            isStopRoll = b;
        }

        public void CMLHJ_ShowOverBtn(bool b)
        {
            OverBtn.gameObject.SetActive(b);
        }
        /// <summary>
        /// 加注
        /// </summary>
        private void AddChipCall()
        {
            //加注
            CMLHJ_Audio.Instance.PlaySound(CMLHJ_Audio.ChangeBet);
            if (GameData.SceneData.nBet == null || GameData.SceneData.nBet.Count <= 0) return;
            GameData.CurrentChipIndex += 1;
            if (GameData.CurrentChipIndex >= GameData.SceneData.nBet.Count)
            {
                GameData.CurrentChipIndex = 0;
            }
            GameData.CurrentChip = GameData.SceneData.nBet[GameData.CurrentChipIndex];
            CMLHJ_Event.DispatchOnChangeBet();
        }

        //开始游戏
        private void StartGameCall()
        {
            if (GameData.isMaryGame) return;
            hsm?.ChangeState(nameof(NormalRollState));
        }

        private void OverGameCall()
        {
            OverBtn.gameObject.SetActive(false);
            CMLHJ_Network.Instance.StartResult();
        }


        private void StopGame()
        {
            CMLHJ_Audio.Instance.PlaySound(CMLHJ_Audio.BTN);
            startState.interactable = false;
            CMLHJ_Event.DispatchStopRoll(true);
        }
        /// <summary>
        /// 显示规则界面
        /// </summary>
        private void ShowRulePanel()
        {
            CMLHJ_Audio.Instance.PlaySound(CMLHJ_Audio.BTN);
            rulePanel.gameObject.SetActive(true);
        }

        /// <summary>
        /// 退出游戏
        /// </summary>
        private void CloseGameCall()
        {
            CMLHJ_Audio.Instance.PlaySound(CMLHJ_Audio.BTN);
            if (!GameData.isMaryGame)
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
            hsm?.ChangeState(nameof(IdleState));
        }

        /// <summary>
        /// 点击自动开始
        /// </summary>
        /// <param name="state"></param>
        private void OnClickAutoCall()
        {
            //点击自动开始
            CMLHJ_Audio.Instance.PlaySound(CMLHJ_Audio.BTN);
            closeAutoBtn.gameObject.SetActive(true);
            GameData.CurrentAutoCount = 10000;
            closeAutoBtn.gameObject.SetActive(true);
            hsm?.ChangeState(nameof(AutoRollState));
            GameData.isAutoGame = true;
        }

        #region 状态机
        /// <summary>
        /// 待机状态
        /// </summary>
        private class IdleState : State<CMLHJEntry>
        {
            public IdleState(CMLHJEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();

                owner.GameData.CurrentAutoCount = 0;
                owner.closeAutoBtn.gameObject.SetActive(false);
                owner.OverBtn.gameObject.SetActive(false);
                owner.startState.interactable = true;
                owner.addChipBtn.interactable = true;
                owner.GameData.isMaryGame = false;
            }
        }
        /// <summary>
        /// 初始化状态
        /// </summary>
        private class InitState : State<CMLHJEntry>
        {
            public InitState(CMLHJEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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

                CMLHJ_Event.DispatchRefreshGold((long)GameLocalMode.Instance.UserGameInfo.Gold);
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
                if (owner.GameData.SceneData.nMaryCount <= 0)
                {
                    owner.GameData.CurrentChipIndex = GameLocalMode.Instance.UserGameInfo.Gold.CheckNear(owner.GameData.SceneData.nBet);
                }
                owner.GameData.CurrentChip = owner.GameData.SceneData.nBet[owner.GameData.CurrentChipIndex];
                CMLHJ_Event.DispatchOnChangeBet();
                owner.AddListener();
                if(owner.GameData.SceneData.nMaryCount>0)
                {
                    owner.GameData.CurrentMaryCount = owner.GameData.SceneData.nMaryCount;
                    hsm?.ChangeState(nameof(EnterBounsState));
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
        private class CheckState : State<CMLHJEntry>
        {
            public CheckState(CMLHJEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                if (CMLHJEntry.Instance.GameData.CurrentMaryCount > 0)//如果在免费中
                {
                    hsm?.ChangeState(nameof(EnterBounsState));
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
        private class NormalRollState : State<CMLHJEntry>
        {
            public NormalRollState(CMLHJEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();

                if (!owner.isStopRoll)
                {
                    return;
                }
                owner.closeAutoBtn.gameObject.SetActive(false);
                owner.startState.interactable=false;
                owner.addChipBtn.interactable = false;
                CMLHJ_Network.Instance.StartGame();
            }
        }


        private class WaitStopState : State<CMLHJEntry>
        {
            public WaitStopState(CMLHJEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
        private class AutoRollState : State<CMLHJEntry>
        {
            public AutoRollState(CMLHJEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.closeAutoBtn.gameObject.SetActive(true);
                owner.startState.interactable = false;
                owner.addChipBtn.interactable = false;
                if (!owner.isStopRoll)
                {
                    return;
                }
                CMLHJ_Network.Instance.StartGame();
            }
            public override void Update()
            {
                base.Update();
            }
        }

        /// <summary>
        /// 进入小游戏
        /// </summary>
        private class EnterBounsState : State<CMLHJEntry>
        {
            public EnterBounsState(CMLHJEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.closeAutoBtn.gameObject.SetActive(false);
                owner.GameData.isMaryGame = true;
                owner.isStopRoll = false;
                CMLHJ_Audio.Instance.PlaySound(CMLHJ_Audio.MarryHit);
                owner.SmallGamePanel.gameObject.SetActive(true);
                CMLHJ_Event.DispatchEnterSmallGame();
            }
        }

        #endregion
    }
}
