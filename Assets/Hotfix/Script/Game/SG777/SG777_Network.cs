using LuaFramework;

namespace Hotfix.SG777
{
    /// <summary>
    /// 网络管理
    /// </summary>
    public class SG777_Network : SingletonILEntity<SG777_Network>
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
            SG777Entry.Instance.FQGY_Event_ShowResultNum(false);
            DebugHelper.Log($"SG777Entry.Instance.GameData.myGold:{SG777Entry.Instance.GameData.myGold}");
            DebugHelper.Log($"SG777Entry:{SG777Entry.Instance.GameData.CurrentChip * SG777_DataConfig.ALLLINECOUNT}");
            if (SG777Entry.Instance.GameData.myGold < SG777Entry.Instance.GameData.CurrentChip * SG777_DataConfig.ALLLINECOUNT && !SG777Entry.Instance.GameData.isFreeGame)
            {
                ToolHelper.PopBigWindow(new BigMessage()
                {
                    content = "Insufficient gold coins, please recharge",
                    okCall = delegate ()
                    {
                        SG777_Event.DispatchRollFailed();
                    },
                    cancelCall = delegate ()
                    {
                        SG777_Event.DispatchRollFailed();
                    }
                });
                return;
            }
            SG777Entry.Instance.GameData.myGold -= (SG777Entry.Instance.GameData.CurrentChip * SG777_DataConfig.ALLLINECOUNT);
            SG777_Event.DispatchRefreshGold(SG777Entry.Instance.GameData.myGold);
            SG777_Struct.CMD_3D_CS_StartGame _StartGame = new SG777_Struct.CMD_3D_CS_StartGame(SG777Entry.Instance.GameData.CurrentChip);
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, SG777_Struct.SUB_CS_GAME_START, _StartGame.ByteBuffer, SocketType.Game);
        }

        /// <summary>
        /// 开始小游戏
        /// </summary>
        public void StartSmallGame(int index)
        {
            DebugHelper.Log("index=======" + index);
            SG777_Struct.CMD_3D_CS_StartSmallGame _StartGame = new SG777_Struct.CMD_3D_CS_StartSmallGame(index + 1);
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, SG777_Struct.SUB_CS_GOLDGAME_START, _StartGame.ByteBuffer, SocketType.Game);
        }

        /// <summary>
        /// 获取下注配置
        /// </summary>
        public void Game_Peilv()
        {
            DebugHelper.Log("获取下注配置");
            SG777_Struct.CMD_3D_CS_GmaePeilv _StartGame = new SG777_Struct.CMD_3D_CS_GmaePeilv();
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, SG777_Struct.SUB_CS_GAME_PEILV, _StartGame.ByteBuffer, SocketType.Game);
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
                case SG777_Struct.SUB_SC_GAME_OVER:
                    SG777Entry.Instance.GameData.ResultData = new SG777_Struct.CMD_3D_SC_Result(buffer);
                    DebugHelper.Log($"result:{LitJson.JsonMapper.ToJson(SG777Entry.Instance.GameData.ResultData)}");
                    SG777_Event.DispatchStartRoll();
                    break;
                case SG777_Struct.SUB_SC_BELL_GAME:
                    SG777Entry.Instance.GameData.SmallGameData = new SG777_Struct.CMD_3D_SC_SmallGameResult(buffer);
                    DebugHelper.Log($"result:{LitJson.JsonMapper.ToJson(SG777Entry.Instance.GameData.SmallGameData)}");
                    SG777_Event.DispatchStartSmallGame();
                    break;
                case SG777_Struct.SUB_SC_USER_PEILV:
                    GetPEILV(buffer);
                    break;
            }
        }

        private void GetPEILV(ByteBuffer buffer)
        {
            DebugHelper.Log("-------下注信息返回----------");
            SG777Entry.Instance.GameData.SceneData.nCurrenBet = buffer.ReadInt32(); //--断线前下注筹码
            int nBetonCnt = buffer.ReadInt32(); //--下注配置数组个数
            SG777Entry.Instance.GameData.SceneData.nBet.Clear();
            for (int i = 0; i < nBetonCnt; i++)
            {
                SG777Entry.Instance.GameData.SceneData.nBet.Add(buffer.ReadInt32());
            }
            SG777_Event.DispatchOnGetSceneData();
        }

        /// <summary>
        /// 场景消息
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="pack">数据</param>
        private void GameSceneInfoAction(ushort sid, BytesPack pack)
        {
            ByteBuffer buffer = new ByteBuffer(pack.bytes);
            SG777Entry.Instance.GameData.SceneData = new SG777_Struct.SC_SceneInfo(buffer);
            Game_Peilv();
            SG777_Event.DispatchOnGetSceneData();
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
