using Hotfix.TouKui;
using LuaFramework;
using UnityEngine;

namespace Hotfix.HeiJieKe
{
    public enum PlayerNormalOperate 
    {
    //玩家普通操作
        E_PLAYER_NORMAL_OPERATE_NULL = -1,
        //未知
        E_PLAYER_NORMAL_OPERATE_SURRENDER = 0, //投降
        E_PLAYER_NORMAL_OPERATE_SPLIT_POKER = 1, //分牌
        E_PLAYER_NORMAL_OPERATE_DOUBLE_CHIP = 2, //双倍
        E_PLAYER_NORMAL_OPERATE_STAND_POKER = 3, //停牌
        E_PLAYER_NORMAL_OPERATE_HIT_POKER = 4, //拿牌
        E_PLAYER_NORMAL_OPERATE_AUTO_ADD_POKER = 5 //自动补牌
    }
    public class HJK_Network : SingletonILEntity<HJK_Network>
    {
        #region REP

        public const ushort SUB_CS_SET_CELLSCORE = 0; //自由场
        public const ushort SUB_CS_SMALL_TIP = 1; //打赏小费
        public const ushort SUB_CS_PLAYER_CHIP = 2; //玩家下注
        public const ushort SUB_CS_PLAYER_INSURANCE = 3; //玩家保险
        public const ushort SUB_CS_PLAYER_NORMAL_OPERATE = 4; //玩家普通操作
        public const ushort SUB_CS_TE_SHU_CHU_LI = 5; //特殊处理
        public const ushort SUB_CS_STOP_CHIP = 6; //停止下注
        public const ushort SUB_CS_ANIMAL_END = 7; //游戏结束
        public const ushort SUB_CS_HEART_BIT = 49; //心跳

        #endregion

        #region ACP

        public const ushort SUB_SC_CHIP = 1; //下注
        public const ushort SUB_SC_PLAYER_CHIP = 2; //玩家下注
        public const ushort SUB_SC_DEAL_POKER = 3; //发牌
        public const ushort SUB_SC_INSURANCE = 4; //保险
        public const ushort SUB_SC_PLAYER_INSURANCE = 5; //玩家保险
        public const ushort SUB_SC_LOOK_ZJ_BLACK_JACK = 6; //查看庄家是否黑杰克
        public const ushort SUB_SC_PLAYER_BLACK_JACK = 7; //玩家黑杰克
        public const ushort SUB_SC_NORMAL_OPERATE = 8; //普通操作
        public const ushort SUB_SC_PLAYER_NORMAL_OPERATE = 9; //玩家普通操作
        public const ushort SUB_SC_LOOK_ZJ_SECOND_POKER = 10; //查看庄家第二张牌
        public const ushort SUB_SC_NEW_PALYER_ENTER_AT_CHIP = 11; //下注状态进入玩家
        public const ushort SUB_SC_GAME_END = 20; //游戏结束
        public const ushort SUB_SC_CHIP_LIST = 21; //下注列表
        public const ushort SUB_SC_STOP_CHIP = 22; //停止下注
        public const ushort SUB_SC_CHIP_ERROR = 23;
        public const ushort SUB_SC_HEART_BIT = 49; //心跳

        #endregion

        private float waitTimer = 3;
        private float timer = 0;
        private bool isLoginSuccess;
        protected override void AddEvent()
        {
            base.AddEvent();
            AddMessage();
        }

        protected override void Start()
        {
            base.Start();
            LoginGame();
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            RemoveMessage();
        }

        protected override void Update()
        {
            base.Update();
            if (!isLoginSuccess) return;
            timer += Time.fixedDeltaTime;
            if (timer < waitTimer) return;
            timer = 0;
            Send(SUB_CS_HEART_BIT, new ByteBuffer());
        }

        private void AddMessage()
        {
            HotfixGameComponent.Instance.GameSceneInfoAction += GameSceneInfoAction;
            HotfixGameComponent.Instance.GameFrameAction += GameFrameAction;
            HotfixGameComponent.Instance.GameAction += GameAction;
            HotfixGameComponent.Instance.LoginGameAction += LoginGameAction;
            HotfixGameComponent.Instance.OnSitAction += OnSitAction;
            HotfixGameComponent.Instance.RoomBreakLineAction += RoomBreakLineAction;
            HotfixGameComponent.Instance.UserEnterAction += UserEnterAction;
            HotfixGameComponent.Instance.UserExitAction += UserExitAction;
            HotfixGameComponent.Instance.UserScoreAction += UserScoreAction;
            HotfixGameComponent.Instance.UserStatusAction += UserStatusAction;
            HotfixActionHelper.ReconnectGame += EventHelper_ReconnectGame;
        }

        private void LoginGame()
        {
            REQ_LOGINGAME login = new REQ_LOGINGAME(0, 0, GameLocalMode.Instance.SCPlayerInfo.DwUser_Id,
                GameLocalMode.Instance.SCPlayerInfo.Password, GameLocalMode.Instance.MechinaCode, 0, 0);
            HotfixGameComponent.Instance.Send(DataStruct.LoginGameStruct.MDM_GR_LOGON,
                DataStruct.LoginGameStruct.SUB_GR_LOGON_GAME, login.ByteBuffer, SocketType.Game);
        }
        /// <summary>
        /// 发送消息
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="buffer">buffer</param>
        public void Send(ushort sid, ByteBuffer buffer)
        {
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, sid, buffer, SocketType.Game);
        }

        private void EventHelper_ReconnectGame()
        {
            LoginGame();
        }

        /// <summary>
        /// 游戏消息
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="pack">数据</param>
        private void GameAction(ushort sid, BytesPack pack)
        {
            int length = pack.bytes.Length;
            ByteBuffer buffer = new ByteBuffer(pack.bytes);
            DebugHelper.Log("收到游戏结果");
            switch (sid)
            {
                case SUB_SC_CHIP: //下注
                    HJK_Event.DispatchOnStartChip();
                    break;
                case SUB_SC_PLAYER_CHIP: //玩家下注
                    HJK_Struct.CMD_SC_PLAYER_CHIP playerChip = new HJK_Struct.CMD_SC_PLAYER_CHIP(buffer);
                    HJK_Event.DispatchOnPlayerChip(playerChip);
                    break;
                case SUB_SC_DEAL_POKER: //发牌
                    HJK_Struct.CMD_SC_SEND_POKER sendPoker = new HJK_Struct.CMD_SC_SEND_POKER(buffer);
                    HJK_Event.DispatchOnSendPoker(sendPoker);
                    break;
                case SUB_SC_INSURANCE: //保险
                    HJK_Event.DispatchOnCheckInsurance();
                    break;
                case SUB_SC_PLAYER_INSURANCE:
                    HJK_Struct.CMD_SC_PLAYER_INSURANCE playerInsurance = new HJK_Struct.CMD_SC_PLAYER_INSURANCE(buffer);
                    HJK_Event.DispatchOnCheckPlayerInsurance(playerInsurance);
                    break;
                case SUB_SC_LOOK_ZJ_BLACK_JACK: //查看庄家是否黑杰克
                    HJK_Struct.CMD_SC_LOOK_ZJ_BLAKC_JACK hjk = new HJK_Struct.CMD_SC_LOOK_ZJ_BLAKC_JACK(buffer);
                    HJK_Event.DispatchOnCheckBankerHJK(hjk);
                    break;
                case SUB_SC_PLAYER_BLACK_JACK: //玩家黑杰克
                    break;
                case SUB_SC_NORMAL_OPERATE: //普通操作
                    HJK_Struct.CMD_SC_NORMAL_OPERATE normalOperate = new HJK_Struct.CMD_SC_NORMAL_OPERATE(buffer);
                    HJK_Event.DispatchOnNormalOperate(normalOperate);
                    break;
                case SUB_SC_PLAYER_NORMAL_OPERATE: //玩家普通操作
                    HJK_Struct.CMD_SC_PLAYER_NORMAL_OPERATE playerNormalOperate =
                        new HJK_Struct.CMD_SC_PLAYER_NORMAL_OPERATE(buffer);
                    HJK_Event.DispatchOnPlayerNormalOperate(playerNormalOperate);
                    break;
                case SUB_SC_LOOK_ZJ_SECOND_POKER: //查看庄家第二张牌
                    HJK_Struct.CMD_SC_LOOK_ZJ_SECOND_POKER lookZjSecondPoker =
                        new HJK_Struct.CMD_SC_LOOK_ZJ_SECOND_POKER(buffer);
                    HJK_Event.DispatchLookSecondPoker(lookZjSecondPoker);
                    break;
                case SUB_SC_NEW_PALYER_ENTER_AT_CHIP: //下注状态进入玩家
                    HJK_Struct.CMD_SC_NEW_PLAYER_ENTER_AT_CHIP playerEnterAtChip =
                        new HJK_Struct.CMD_SC_NEW_PLAYER_ENTER_AT_CHIP(buffer);
                    HJK_Event.DispatchPlayerEnterOnChip(playerEnterAtChip);
                    break;
                case SUB_SC_GAME_END: //游戏结束
                    HJK_Struct.CMD_SC_GAME_END gameEnd = new HJK_Struct.CMD_SC_GAME_END(buffer);
                    HJK_Event.DispatchOnGameEnd(gameEnd);
                    break;
                case SUB_SC_CHIP_LIST: //下注列表
                    HJK_Struct.CMD_SC_CHIP_LIST chipList=new HJK_Struct.CMD_SC_CHIP_LIST(buffer);
                    HJK_Event.DispatchOnChipList(chipList);
                    break;
                case SUB_SC_STOP_CHIP: //停止下注
                    HJK_Struct.CMD_SC_STOP_CHIP stopChip=new HJK_Struct.CMD_SC_STOP_CHIP(buffer);
                    HJK_Event.DispatchOnStopChip(stopChip);
                    break;
                case SUB_SC_CHIP_ERROR: //下注错误
                    HJK_Struct.SUB_SC_CHIP_ERROR error=new HJK_Struct.SUB_SC_CHIP_ERROR(buffer,length);
                    HJK_Event.DispatchOnChipError(error);
                    break;
                case SUB_SC_HEART_BIT://心跳
                    HJK_Event.DispatchOnHeart();
                    break;
            }
        }

        /// <summary>
        /// 场景消息
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="pack">数据</param>
        private void GameSceneInfoAction(ushort sid, BytesPack pack)
        {
            isLoginSuccess = true;
            ByteBuffer buffer = new ByteBuffer(pack.bytes);
            HJK_Struct.CMD_SC_GAME_FREE data = new HJK_Struct.CMD_SC_GAME_FREE(buffer);
            HJK_Event.DispatchOnSceneData(data);
        }

        /// <summary>
        /// 玩家状态
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="data">数据</param>
        private void UserStatusAction(ushort sid, GameUserData data)
        {
            HJK_Event.DispatchOnPlayerStatusChange(data);
        }

        /// <summary>
        /// 框架消息
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="pack">数据</param>
        private void GameFrameAction(ushort sid, BytesPack pack)
        {
        }

        /// <summary>
        /// 玩家分数
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="data">数据</param>
        private void UserScoreAction(ushort sid, GameUserData data)
        {
            DebugHelper.Log($"金币变动");
            HJK_Event.DispatchOnPlayerScoreChange(data);
        }

        /// <summary>
        /// 玩家离开
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="data">数据</param>
        private void UserExitAction(ushort sid, GameUserData data)
        {
            HJK_Event.DispatchOnPlayerExit(data);
        }

        /// <summary>
        /// 玩家进入
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="data">数据</param>
        private void UserEnterAction(ushort sid, GameUserData data)
        {
            HJK_Event.DispatchOnPlayerEnter(data);
        }

        /// <summary>
        /// 断线
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="pack">数据</param>
        private void RoomBreakLineAction(ushort sid, BytesPack pack)
        {
            isLoginSuccess = false;
        }

        /// <summary>
        /// 坐下消息
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="pack">数据</param>
        private void OnSitAction(ushort sid, BytesPack pack)
        {
        }

        /// <summary>
        /// 登录消息
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="pack">数据</param>
        private void LoginGameAction(ushort sid, BytesPack pack)
        {
        }

        private void RemoveMessage()
        {
            HotfixGameComponent.Instance.GameSceneInfoAction -= GameSceneInfoAction;
            HotfixGameComponent.Instance.GameFrameAction -= GameFrameAction;
            HotfixGameComponent.Instance.GameAction -= GameAction;
            HotfixGameComponent.Instance.LoginGameAction -= LoginGameAction;
            HotfixGameComponent.Instance.OnSitAction -= OnSitAction;
            HotfixGameComponent.Instance.RoomBreakLineAction -= RoomBreakLineAction;
            HotfixGameComponent.Instance.UserEnterAction -= UserEnterAction;
            HotfixGameComponent.Instance.UserExitAction -= UserExitAction;
            HotfixGameComponent.Instance.UserScoreAction -= UserScoreAction;
            HotfixGameComponent.Instance.UserStatusAction -= UserStatusAction;
            HotfixActionHelper.ReconnectGame -= EventHelper_ReconnectGame;
        }
    }
}