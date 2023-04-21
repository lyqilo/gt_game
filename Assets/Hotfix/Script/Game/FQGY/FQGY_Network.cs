using LuaFramework;

namespace Hotfix.FQGY
{
    /// <summary>
    /// 网络管理
    /// </summary>
    public class FQGY_Network : SingletonILEntity<FQGY_Network>
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
            FQGYEntry.Instance.FQGY_Event_ShowResultNum(false);

            DebugHelper.Log($"JWEntry.Instance.GameData.myGold:{FQGYEntry.Instance.GameData.myGold}");
            DebugHelper.Log($"JWEntry:{FQGYEntry.Instance.GameData.CurrentChip * FQGY_DataConfig.ALLLINECOUNT}");
            if (FQGYEntry.Instance.GameData.myGold < FQGYEntry.Instance.GameData.CurrentChip * FQGY_DataConfig.ALLLINECOUNT && !FQGYEntry.Instance.GameData.isFreeGame)
            {
                ToolHelper.PopBigWindow(new BigMessage()
                {
                    content = "Insufficient gold coins, please recharge",
                    okCall = delegate ()
                    {
                        FQGY_Event.DispatchRollFailed();
                    },
                    cancelCall = delegate ()
                    {
                        FQGY_Event.DispatchRollFailed();
                    }
                });
                return;
            }

            FQGYEntry.Instance.GameData.myGold -= (FQGYEntry.Instance.GameData.CurrentChip * FQGY_DataConfig.ALLLINECOUNT);
            FQGY_Event.DispatchRefreshGold(FQGYEntry.Instance.GameData.myGold);

            FQGY_Struct.CMD_3D_CS_StartGame _StartGame = new FQGY_Struct.CMD_3D_CS_StartGame(FQGYEntry.Instance.GameData.CurrentChip);
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, FQGY_Struct.SUB_CS_GAME_START, _StartGame.ByteBuffer, SocketType.Game);
        }

        /// <summary>
        /// 开始小游戏
        /// </summary>
        public void StartSmallGame()
        {
            FQGYEntry.Instance.FQGY_Event_ShowResultNum(false);

            FQGY_Struct.CMD_3D_CS_StartSmallGame _StartGame = new FQGY_Struct.CMD_3D_CS_StartSmallGame();
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, FQGY_Struct.SUB_CS_GOLDGAME_START, _StartGame.ByteBuffer, SocketType.Game);
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
                case FQGY_Struct.SUB_SC_GAME_START:
                    FQGYEntry.Instance.GameData.ResultData = new FQGY_Struct.CMD_3D_SC_Result(buffer);
                    DebugHelper.Log($"result:{LitJson.JsonMapper.ToJson(FQGYEntry.Instance.GameData.ResultData)}");
                    FQGY_Event.DispatchStartRoll();
                    break;
                case FQGY_Struct.SUB_SC_GOLD_GAME:
                    FQGYEntry.Instance.GameData.SmallGameData = new FQGY_Struct.CMD_3D_SC_SmallGameResult(buffer);
                    DebugHelper.Log($"result:{LitJson.JsonMapper.ToJson(FQGYEntry.Instance.GameData.SmallGameData)}");
                    FQGY_Event.DispatchStartSmallGame();
                    break;

                case FQGY_Struct.SUB_SC_BET_FAIL:
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
            FQGYEntry.Instance.GameData.SceneData = new FQGY_Struct.SC_SceneInfo(buffer);
            FQGY_Event.DispatchOnGetSceneData();
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
