using LuaFramework;

namespace Hotfix.TiaoTiaoTangGuo
{
    public class TTTG_Network : SingletonILEntity<TTTG_Network>
    {

        protected override void Awake()
        {
            base.Awake();
            LoginGame();
        }

        protected override void AddEvent()
        {
            base.AddEvent();
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
        /// 开始游戏
        /// </summary>
        public void StartGame()
        {
            TTTG_Struct.StartGame startGame = new TTTG_Struct.StartGame()
            {
                nBet = TTTGEntry.Instance.GameData.CurrentChip
            };
            if (TTTGEntry.Instance.GameData.myGold <
                TTTGEntry.Instance.GameData.CurrentChip * TTTG_DataConfig.LineCount)
            {
                ToolHelper.PopSmallWindow($"金币不足，请充值！");
                TTTG_Event.DispatchOnResetGame();
                return;
            }

            if (!TTTGEntry.Instance.GameData.isFreeGame)
            {
                TTTGEntry.Instance.GameData.myGold -=
                    TTTGEntry.Instance.GameData.CurrentChip * TTTG_DataConfig.LineCount;
                TTTG_Event.DispatchChangeUserGold(TTTGEntry.Instance.GameData.myGold);
            }

            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, TTTG_Struct.SUB_CS_GAME_START,
                startGame.ByteBuffer, SocketType.Game);
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
            TTTGEntry.Instance.GameData.isScene = false;
            ByteBuffer buffer = new ByteBuffer(pack.bytes);
            DebugHelper.Log("收到游戏结果");
            switch (sid)
            {
                case TTTG_Struct.SUB_SC_GAME_START:
                   TTTG_Struct.CMD_3D_SC_Result result = new TTTG_Struct.CMD_3D_SC_Result(buffer);
                    TTTG_Event.DispatchOnReceiveResult(result);
                    DebugHelper.Log($"结果：{LitJson.JsonMapper.ToJson(result)}");
                    break;
                case TTTG_Struct.SUB_SC_BET_FAIL:
                    TTTG_Struct.CMD_SC_BetFail fail = new TTTG_Struct.CMD_SC_BetFail(buffer);
                    ToolHelper.PopSmallWindow(fail.cbResCode == 0 ? $"Insufficient gold coins！" : $"下注失败");
                    TTTG_Event.DispatchOnResetGame();
                    break;
                case TTTG_Struct.SUB_SC_UPDATE_JACKPOT:
                    TTTG_Struct.CMD_3D_SC_CaiJin caiJin = new TTTG_Struct.CMD_3D_SC_CaiJin(buffer);
                    TTTG_Event.DispatchOnJackpotChanged(caiJin.lCaijin);
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
            TTTGEntry.Instance.GameData.isScene = true;
            ByteBuffer buffer = new ByteBuffer(pack.bytes);
            TTTG_Struct.SC_SceneInfo sceneInfo = new TTTG_Struct.SC_SceneInfo(buffer);
            TTTG_Event.DispatchOnReceiveSceneInfo(sceneInfo);
            DebugHelper.Log($"场景消息：{LitJson.JsonMapper.ToJson(sceneInfo)}");
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
            DebugHelper.Log($"金币变动");
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
            GameLocalMode.Instance.UserGameInfo = data;
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

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
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
            HotfixActionHelper.ReconnectGame -= EventHelper_ReconnectGame;
        }
    }
}