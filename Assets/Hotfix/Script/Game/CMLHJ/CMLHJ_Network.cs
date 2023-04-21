using LuaFramework;

namespace Hotfix.CMLHJ
{
    /// <summary>
    /// 网络管理
    /// </summary>
    public class CMLHJ_Network : SingletonILEntity<CMLHJ_Network>
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
            CMLHJEntry.Instance.CMLHJ_ShowResultNum(false);
            DebugHelper.Log($"CMLHJEntry.Instance.GameData.myGold:{CMLHJEntry.Instance.GameData.myGold}");
            DebugHelper.Log($"CMLHJEntry:{CMLHJEntry.Instance.GameData.CurrentChip * CMLHJ_DataConfig.ALLLINECOUNT}");
            if (CMLHJEntry.Instance.GameData.myGold < CMLHJEntry.Instance.GameData.CurrentChip * CMLHJ_DataConfig.ALLLINECOUNT)
            {
                ToolHelper.PopBigWindow(new BigMessage()
                {
                    content = "Insufficient gold coins, please recharge",
                    okCall = delegate ()
                    {
                        CMLHJ_Event.DispatchRollFailed();
                    },
                    cancelCall = delegate ()
                    {
                        CMLHJ_Event.DispatchRollFailed();
                    }
                });
                return;
            }

            CMLHJEntry.Instance.GameData.myGold -= (CMLHJEntry.Instance.GameData.CurrentChip * CMLHJ_DataConfig.ALLLINECOUNT);
            CMLHJ_Event.DispatchRefreshGold(CMLHJEntry.Instance.GameData.myGold);
            CMLHJ_Struct.CMD_3D_CS_StartGame _StartGame = new CMLHJ_Struct.CMD_3D_CS_StartGame(CMLHJEntry.Instance.GameData.CurrentChipIndex+1);
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, CMLHJ_Struct.SUB_CS_GAME_START, _StartGame.ByteBuffer, SocketType.Game);
        }

        /// <summary>
        /// 开始小游戏
        /// </summary>
        public void StartMaryGame()
        {
            DebugHelper.Log("开始小游戏");
            ByteBuffer buffer = new ByteBuffer();
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, CMLHJ_Struct.SUB_CS_GAME_MALI, buffer, SocketType.Game);
        }

        /// <summary>
        /// 结算
        /// </summary>
        public void StartResult()
        {
            ByteBuffer buffer = new ByteBuffer();
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, CMLHJ_Struct.SUB_CS_GET_SCORE, buffer, SocketType.Game);
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
                case CMLHJ_Struct.SUB_SC_GAME_START:
                    CMLHJEntry.Instance.GameData.ResultData = new CMLHJ_Struct.CMD_3D_SC_Result(buffer);
                    DebugHelper.Log($"result:{LitJson.JsonMapper.ToJson(CMLHJEntry.Instance.GameData.ResultData)}");
                    CMLHJ_Event.DispatchStartRoll();
                    break;
                case CMLHJ_Struct.SUB_SC_GAME_OVER:
                    DebugHelper.Log("====SUB_SC_GAME_OVER====");
                    CMLHJ_Event.DispatchShowResultComplete();
                    break;
                case CMLHJ_Struct.SUB_SC_MALI_RESULT:
                    CMLHJEntry.Instance.GameData.MaryData = new CMLHJ_Struct.CMD_3D_SC_MaryResult(buffer);
                    DebugHelper.Log($"result:{LitJson.JsonMapper.ToJson(CMLHJEntry.Instance.GameData.MaryData)}");
                    CMLHJ_Event.DispatchStartSmallGame();
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
            CMLHJEntry.Instance.GameData.SceneData = new CMLHJ_Struct.SC_SceneInfo(buffer);
            CMLHJ_Event.DispatchOnGetSceneData();
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
