using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.HeiJieKe
{
    public class HeiJieKeEntry : SingletonILEntity<HeiJieKeEntry>
    {
        public Data GameData { get; set; }
        private Transform playerGroup;
        private Transform soundPool;
        private Transform userInfo;

        private List<IState> states;
        private HierarchicalStateMachine hsm;
        private Transform chipBtnGroup;
        private Button chipCompleteBtn;
        private Transform operateList;
        private Button splitPokerBtn;
        private Button surrenderBtn;
        private Button stopPokerBtn;
        private Button doubleChipBtn;
        private Button askPokerBtn;
        private Transform tip;
        private Transform insuranceGroup;
        private Button okInsurance;
        private Button cancelInsurance;
        private Transform collectPokerPos;
        private Transform sendPokerPos;
        private Transform pairsPanel;
        private Transform banker;

        protected override void Awake()
        {
            base.Awake();
            AddListener();
            states = new List<IState>();
            hsm = new HierarchicalStateMachine(false, gameObject);
            states.Add(new InitState(this, hsm));
            states.Add(new ChipState(this, hsm));
            states.Add(new SendPokerState(this, hsm));
            states.Add(new StopSendPokerState(this, hsm));
            states.Add(new OperateState(this, hsm));
            states.Add(new PlayerOperateState(this, hsm));
            states.Add(new GameOverState(this, hsm));
            hsm?.Init(states, nameof(InitState));
            GameData = new Data();
            HJK_PlayerInfo playerInfo = userInfo.AddILComponent<HJK_PlayerInfo>();
            playerInfo.IsSpecial = true;
            banker.AddILComponent<HJK_Banker>();
            playerGroup.AddILComponent<HJK_PlayerManager>();
            transform.AddILComponent<HJK_Extend>();
            soundPool.AddILComponent<HJK_Audio>();
            transform.AddILComponent<HJK_Network>();
            pairsPanel.gameObject.SetActive(false);
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            playerGroup = transform.FindChildDepth($"PlayerGroup");
            soundPool = transform.FindChildDepth($"SoundPool");
            userInfo = transform.FindChildDepth($"UserInfo");
            chipBtnGroup = transform.FindChildDepth($"ChipBtnGroup");
            chipCompleteBtn = transform.FindChildDepth<Button>($"ChipCompleteBtn");
            operateList = transform.FindChildDepth($"OperationList");
            splitPokerBtn = operateList.FindChildDepth<Button>($"ButtonSplit");
            surrenderBtn = operateList.FindChildDepth<Button>($"ButtonSurrender");
            stopPokerBtn = operateList.FindChildDepth<Button>($"ButtonStop");
            doubleChipBtn = operateList.FindChildDepth<Button>($"ButtonDouble");
            askPokerBtn = operateList.FindChildDepth<Button>($"ButtonAskPoker");
            tip = transform.FindChildDepth($"Tip");

            insuranceGroup = transform.FindChildDepth($"Insurance");
            okInsurance = insuranceGroup.FindChildDepth<Button>($"OK");
            cancelInsurance = insuranceGroup.FindChildDepth<Button>($"Cancel");

            sendPokerPos = transform.FindChildDepth($"SendPokersPos");
            collectPokerPos = transform.FindChildDepth($"SendPokersPos");

            banker = transform.FindChildDepth($"Banker");
            pairsPanel = transform.FindChildDepth($"PairsPanel");
        }

        private void AddListener()
        {
            chipCompleteBtn.onClick.RemoveAllListeners();
            chipCompleteBtn.onClick.Add(OnChipComplete);
            splitPokerBtn.onClick.RemoveAllListeners();
            splitPokerBtn.onClick.Add(() => { OperatePokerCall(PlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_SPLIT_POKER); });
            surrenderBtn.onClick.RemoveAllListeners();
            surrenderBtn.onClick.Add(() => { OperatePokerCall(PlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_SURRENDER); });
            stopPokerBtn.onClick.RemoveAllListeners();
            stopPokerBtn.onClick.Add(() => { OperatePokerCall(PlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_STAND_POKER); });
            doubleChipBtn.onClick.RemoveAllListeners();
            doubleChipBtn.onClick.Add(() => { OperatePokerCall(PlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_DOUBLE_CHIP); });
            askPokerBtn.onClick.RemoveAllListeners();
            askPokerBtn.onClick.Add(() => { OperatePokerCall(PlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_HIT_POKER); });

            okInsurance.onClick.RemoveAllListeners();
            okInsurance.onClick.Add(OnClickInsuranceOKCall);
            cancelInsurance.onClick.RemoveAllListeners();
            cancelInsurance.onClick.Add(OnClickInsuranceCancelCall);
        }

        protected override void Update()
        {
            base.Update();
            hsm?.Update();
        }

        protected override void AddEvent()
        {
            base.AddEvent();
            HJK_Event.OnSceneData += HJK_EventOnOnSceneData;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            HJK_Event.OnSceneData -= HJK_EventOnOnSceneData;
        }

        private void HJK_EventOnOnSceneData(HJK_Struct.CMD_SC_GAME_FREE sceneData)
        {
            GameData.SceneData = sceneData;
        }

        private void OperatePokerCall(PlayerNormalOperate normalOperate) //要牌
        {
            HJK_Struct.CMD_CS_PLAYER_NORMAL_OPERATE normal = new HJK_Struct.CMD_CS_PLAYER_NORMAL_OPERATE()
            {
                operateId = (int) normalOperate
            };
            HJK_Network.Instance.Send(HJK_Network.SUB_CS_PLAYER_NORMAL_OPERATE, normal.ByteBuffer);
        }

        private void OnChipComplete()
        {
            chipBtnGroup.gameObject.SetActive(false);
            chipCompleteBtn.gameObject.SetActive(false);
        }

        private void OnClickInsuranceCancelCall()
        {
            insuranceGroup.gameObject.SetActive(false);
            HJK_Struct.CMD_CS_PLAYER_INSURANCE insurance = new HJK_Struct.CMD_CS_PLAYER_INSURANCE() {isInsurance = false};
            HJK_Network.Instance.Send(HJK_Network.SUB_CS_PLAYER_INSURANCE,insurance.ByteBuffer);
        }

        private void OnClickInsuranceOKCall()
        {
            insuranceGroup.gameObject.SetActive(false);
            HJK_Struct.CMD_CS_PLAYER_INSURANCE insurance = new HJK_Struct.CMD_CS_PLAYER_INSURANCE() {isInsurance = true};
            HJK_Network.Instance.Send(HJK_Network.SUB_CS_PLAYER_INSURANCE,insurance.ByteBuffer);
        }

        /// <summary>
        /// 初始化
        /// </summary>
        private class InitState : State<HeiJieKeEntry>
        {
            public InitState(HeiJieKeEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }

        /// <summary>
        /// 下注
        /// </summary>
        private class ChipState : State<HeiJieKeEntry>
        {
            public ChipState(HeiJieKeEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }

        /// <summary>
        /// 发牌
        /// </summary>
        private class SendPokerState : State<HeiJieKeEntry>
        {
            public SendPokerState(HeiJieKeEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }

        /// <summary>
        /// 停止发牌
        /// </summary>
        private class StopSendPokerState : State<HeiJieKeEntry>
        {
            public StopSendPokerState(HeiJieKeEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }

        /// <summary>
        /// 操作
        /// </summary>
        private class OperateState : State<HeiJieKeEntry>
        {
            public OperateState(HeiJieKeEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }

        /// <summary>
        /// 其他玩家操作
        /// </summary>
        private class PlayerOperateState : State<HeiJieKeEntry>
        {
            public PlayerOperateState(HeiJieKeEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }

        /// <summary>
        /// 游戏结束
        /// </summary>
        private class GameOverState : State<HeiJieKeEntry>
        {
            public GameOverState(HeiJieKeEntry owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }
    }
}