using LuaFramework;

namespace Hotfix.MJHL
{
    /// <summary>
    /// 网络管理
    /// </summary>
    public class MJHL_Network:SingletonILEntity<MJHL_Network>
    {
        bool isCbRerun = false;
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
            MJHLEntry.Instance.MJHL_Event_ShowResultNum(false);

            DebugHelper.Log($"MJHLEntry.Instance.GameData.myGold:{MJHLEntry.Instance.GameData.myGold}");
            DebugHelper.Log($"MJHLEntry:{MJHLEntry.Instance.GameData.CurrentChip * MJHL_DataConfig.ALLLINECOUNT}");
            if (MJHLEntry.Instance.GameData.myGold < MJHLEntry.Instance.GameData.CurrentChip * MJHL_DataConfig.ALLLINECOUNT && !MJHLEntry.Instance.GameData.isFreeGame)
            {
                ToolHelper.PopBigWindow(new BigMessage()
                {
                    content = "Insufficient gold coins, please recharge",
                    okCall = delegate ()
                    {
                        MJHL_Event.DispatchRollFailed();
                    },
                    cancelCall = delegate ()
                    {
                        MJHL_Event.DispatchRollFailed();
                    }
                });
                return;
            }


            MJHLEntry.Instance.GameData.myGold -= (MJHLEntry.Instance.GameData.CurrentChip * MJHL_DataConfig.ALLLINECOUNT);
            MJHL_Event.DispatchRefreshGold(MJHLEntry.Instance.GameData.myGold);
            MJHL_Struct.CMD_3D_CS_StartGame _StartGame = new MJHL_Struct.CMD_3D_CS_StartGame(MJHLEntry.Instance.GameData.CurrentChip);
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, MJHL_Struct.SUB_CS_GAME_START, _StartGame.ByteBuffer, SocketType.Game);
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
                case MJHL_Struct.SUB_SC_GAME_START:
                    MJHLEntry.Instance.GameData.ResultData = new MJHL_Struct.CMD_3D_SC_Result(buffer, pack);
                    MJHLEntry.Instance.GameData.Index = 0;
                    isCbRerun = MJHLEntry.Instance.GameData.ResultData.cbTurn > 0;
                    DebugHelper.Log($"result:{LitJson.JsonMapper.ToJson(MJHLEntry.Instance.GameData.ResultData)}");
                    MJHL_Event.DispatchStartRoll();
                    break;
                case MJHL_Struct.SUB_SC_BET_FAIL:
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
            MJHLEntry.Instance.GameData.SceneData = new MJHL_Struct.SC_SceneInfo(buffer);
            MJHL_Event.DispatchOnGetSceneData();
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
