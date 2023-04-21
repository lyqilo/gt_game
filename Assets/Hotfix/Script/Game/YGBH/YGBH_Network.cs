using LuaFramework;
using System;

namespace Hotfix.YGBH
{
    /// <summary>
    /// 网络管理
    /// </summary>
    public class YGBH_Network : SingletonILEntity<YGBH_Network>
    {
        protected override void Awake()
        {
            base.Awake();
            AddMessage();
        }
        protected override void Start()
        {
            base.Start();
            LoginGame();
        }
        protected override void OnDestroy()
        {
            base.OnDestroy();
            RemoveMessage();
        }
        private void AddMessage()
        {
            if (HotfixGameComponent.Instance == null) return;
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
        }
        private void LoginGame()
        {
            REQ_LOGINGAME login = new REQ_LOGINGAME(0,0,GameLocalMode.Instance.SCPlayerInfo.DwUser_Id, GameLocalMode.Instance.SCPlayerInfo.Password, GameLocalMode.Instance.MechinaCode, 0,0);
            HotfixGameComponent.Instance.Send(DataStruct.LoginGameStruct.MDM_GR_LOGON, DataStruct.LoginGameStruct.SUB_GR_LOGON_GAME, login.ByteBuffer, SocketType.Game);
        }
        /// <summary>
        /// 开始游戏
        /// </summary>
        public void StartGame()
        {
            if (YGBHEntry.Instance.GameData.myGold < YGBHEntry.Instance.GameData.CurrentChip * YGBH_DataConfig.ALLLINECOUNT && !YGBHEntry.Instance.GameData.isFreeGame)
            {
                ToolHelper.PopBigWindow(new BigMessage()
                {
                    content = "Insufficient gold coins, please recharge",
                    okCall = YGBH_Event.DispatchRollFailed,
                    cancelCall = YGBH_Event.DispatchRollFailed
                });
                return;
            }
            if (!YGBHEntry.Instance.GameData.isFreeGame)
            {
                YGBHEntry.Instance.GameData.myGold -= (YGBHEntry.Instance.GameData.CurrentChip * YGBH_DataConfig.ALLLINECOUNT);
                YGBH_Event.DispatchRefreshGold(YGBHEntry.Instance.GameData.myGold);
            }

            YGBH_Struct.CMD_3D_CS_StartGame startGame = new YGBH_Struct.CMD_3D_CS_StartGame(YGBHEntry.Instance.GameData.CurrentChip,YGBH_DataConfig.ALLLINECOUNT);
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, YGBH_Struct.SUB_CS_GAME_START, startGame.ByteBuffer, SocketType.Game);
        }


        public void StartSmallGame()
        {
            ByteBuffer buffer =new ByteBuffer();
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, YGBH_Struct.SUB_CS_LITTLE_GAME, buffer, SocketType.Game);
        }

        public void SelectFree()
        {
            if (YGBHEntry.Instance.GameData.m_FreeType == 0)return;
            ByteBuffer buffer = new ByteBuffer();
            buffer.WriteUInt32(YGBHEntry.Instance.GameData.m_FreeType);
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, YGBH_Struct.SUB_CS_CHOSE_FREEGAME_TYPE, buffer, SocketType.Game);
        }

        /// <summary>
        /// 游戏消息
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="pack">数据</param>
        private void GameAction(ushort sid, BytesPack pack)
        {
            ByteBuffer buffer = new ByteBuffer(pack.bytes);
            DebugHelper.Log("收到游戏结果");
            switch (sid)
            {
                case YGBH_Struct.SUB_SC_RESULTS_INFO:
                    YGBHEntry.Instance.GameData.ResultData = new YGBH_Struct.CMD_3D_SC_Result(buffer);
                    DebugHelper.Log($"result:{LitJson.JsonMapper.ToJson(YGBHEntry.Instance.GameData.ResultData)}");
                    YGBH_Event.DispatchStartRoll();
                    break;
                case YGBH_Struct.SUB_SC_BET_FAIL:
                    byte tag = buffer.ReadByte();
                    if (tag == 1)
                    {
                        ToolHelper.PopSmallWindow("Insufficient gold coins");
                    }
                    else if (tag == 2)
                    {
                        ToolHelper.PopSmallWindow("Wrong bet value");
                    }
                    break;
                case YGBH_Struct.SUB_SC_SMALLGAME:
                    DebugHelper.Log("小游戏数据");
                    YGBHEntry.Instance.GameData.SmallData = new YGBH_Struct.CMD_3D_SC_SmallResult(buffer);
                    DebugHelper.Log($"result:{LitJson.JsonMapper.ToJson(YGBHEntry.Instance.GameData.SmallData)}");
                    break;
                case YGBH_Struct.SUB_SC_SMALLGAMEEND:
                    YGBHEntry.Instance.GameData.SmallEndData = new YGBH_Struct.CMD_3D_SC_SmallEnd(buffer);
                    DebugHelper.Log($"result:{LitJson.JsonMapper.ToJson(YGBHEntry.Instance.GameData.SmallEndData)}");
                    YGBHEntry.Instance.RollZP();
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
            ByteBuffer buffer = new ByteBuffer(pack.bytes);
            YGBHEntry.Instance.GameData.SceneData = new YGBH_Struct.SC_SceneInfo(buffer);
            YGBH_Event.DispatchOnGetSceneData();
        }
        /// <summary>
        /// 玩家状态
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="data">数据</param>
        private void UserStatusAction(ushort sid, GameUserData data)
        {

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
            GameLocalMode.Instance.UserGameInfo = data;
        }

        /// <summary>
        /// 玩家离开
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="data">数据</param>
        private void UserExitAction(ushort sid, GameUserData data)
        {

        }

        /// <summary>
        /// 玩家进入
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="data">数据</param>
        private void UserEnterAction(ushort sid, GameUserData data)
        {

        }

        /// <summary>
        /// 断线
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="pack">数据</param>
        private void RoomBreakLineAction(ushort sid, BytesPack pack)
        {

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
            if (HotfixGameComponent.Instance == null) return;
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
        }


    }
}
