using LuaFramework;

namespace Hotfix.TJZ
{
    /// <summary>
    /// 网络管理
    /// </summary>
    public class TJZ_Network : SingletonILEntity<TJZ_Network>
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
            TJZEntry.Instance.FQGY_Event_ShowResultNum(false);
            DebugHelper.Log($"TJZEntry.Instance.GameData.myGold:{TJZEntry.Instance.GameData.myGold}");
            DebugHelper.Log($"TJZEntry:{TJZEntry.Instance.GameData.CurrentChip * TJZ_DataConfig.ALLLINECOUNT}");
            if (TJZEntry.Instance.GameData.myGold < TJZEntry.Instance.GameData.CurrentChip * TJZ_DataConfig.ALLLINECOUNT && !TJZEntry.Instance.GameData.isFreeGame)
            {
                ToolHelper.PopBigWindow(new BigMessage()
                {
                    content = "Insufficient gold coins, please recharge",
                    okCall = delegate ()
                    {
                        TJZ_Event.DispatchRollFailed();
                    },
                    cancelCall = delegate ()
                    {
                        TJZ_Event.DispatchRollFailed();
                    }
                });
                return;
            }
            if (!TJZEntry.Instance.GameData.isFreeGame && !TJZEntry.Instance.GameData.Return)
            {
                TJZEntry.Instance.GameData.myGold -= (TJZEntry.Instance.GameData.CurrentChip * TJZ_DataConfig.ALLLINECOUNT);
                TJZ_Event.DispatchRefreshGold(TJZEntry.Instance.GameData.myGold);
            }
            TJZ_Struct.CMD_3D_CS_StartGame _StartGame = new TJZ_Struct.CMD_3D_CS_StartGame(TJZEntry.Instance.GameData.CurrentChip);
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, TJZ_Struct.SUB_CS_GAME_START, _StartGame.ByteBuffer, SocketType.Game);
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
                case TJZ_Struct.SUB_SC_GAME_OVER:
                    TJZEntry.Instance.GameData.ResultData = new TJZ_Struct.CMD_3D_SC_Result(buffer);
                    DebugHelper.Log($"result:{LitJson.JsonMapper.ToJson(TJZEntry.Instance.GameData.ResultData)}");
                    TJZ_Event.DispatchStartRoll();
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
            TJZEntry.Instance.GameData.SceneData = new TJZ_Struct.SC_SceneInfo(buffer);
            TJZ_Event.DispatchOnGetSceneData();
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
