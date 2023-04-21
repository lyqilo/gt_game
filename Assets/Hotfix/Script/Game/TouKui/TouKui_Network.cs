using LuaFramework;

namespace Hotfix.TouKui
{
    /// <summary>
    /// 网络管理
    /// </summary>
    public class TouKui_Network:SingletonILEntity<TouKui_Network>
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
            HotfixActionHelper.ReconnectGame += EventHelper_ReconnectGame;
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
            DebugHelper.Log($"TouKuiEntry.Instance.GameData.myGold:{TouKuiEntry.Instance.GameData.myGold}");
            DebugHelper.Log($"TouKuiEntry:{TouKuiEntry.Instance.GameData.CurrentChip * TouKui_DataConfig.ALLLINECOUNT}");
            if (TouKuiEntry.Instance.GameData.myGold < TouKuiEntry.Instance.GameData.CurrentChip * TouKui_DataConfig.ALLLINECOUNT && !TouKuiEntry.Instance.GameData.isFreeGame)
            {
                ToolHelper.PopBigWindow(new BigMessage()
                {
                    content = "Insufficient gold coins, please recharge",
                    okCall = delegate ()
                    {
                        TouKui_Event.DispatchBetFailed();
                    },
                    cancelCall = delegate ()
                    {
                        TouKui_Event.DispatchBetFailed();
                    }
                });
                return;
            }
            if (!TouKuiEntry.Instance.GameData.isFreeGame)
            {
                long gold = TouKuiEntry.Instance.GameData.myGold;
                TouKuiEntry.Instance.GameData.myGold -= (TouKuiEntry.Instance.GameData.CurrentChip * TouKui_DataConfig.ALLLINECOUNT);
                ToolHelper.RunGoal(gold, TouKuiEntry.Instance.GameData.myGold, 0.2f, delegate (string goal)
                {
                    TouKui_Event.DispatchRefreshGold(long.Parse(goal));
                });
            }
            TouKui_Struct.CMD_3D_CS_StartGame _StartGame = new TouKui_Struct.CMD_3D_CS_StartGame(TouKuiEntry.Instance.GameData.CurrentChip);
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, TouKui_Struct.SUB_CS_GAME_START, _StartGame.ByteBuffer, SocketType.Game);
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
            ByteBuffer buffer = new ByteBuffer(pack.bytes);
            DebugHelper.Log("收到游戏结果");
            switch (sid)
            {
                case TouKui_Struct.SUB_SC_GAME_START:
                    TouKuiEntry.Instance.GameData.ResultData = new TouKui_Struct.CMD_3D_SC_Result(buffer);
                    DebugHelper.LogError($"result:{LitJson.JsonMapper.ToJson(TouKuiEntry.Instance.GameData.ResultData)}");
                    TouKuiEntry.Instance.GameData.CurrentMode = (SpecialMode)TouKuiEntry.Instance.GameData.ResultData.nFreeType;
                    TouKuiEntry.Instance.GameData.CurrentNormalMode = (SpecialMode)TouKuiEntry.Instance.GameData.ResultData.nNolmalFreeType;
                    TouKuiEntry.Instance.GameData.CurrentFreeCount = TouKuiEntry.Instance.GameData.ResultData.nFreeCount;
                    TouKuiEntry.Instance.GameData.CurrentExtOdd = TouKuiEntry.Instance.GameData.ResultData.nExtOdd;
                    TouKuiEntry.Instance.GameData.FuDongStartCol = TouKuiEntry.Instance.GameData.ResultData.nStartCol;
                    TouKuiEntry.Instance.GameData.FuDongStartRow = TouKuiEntry.Instance.GameData.ResultData.nStartRow;
                    TouKuiEntry.Instance.GameData.CurrentFuDongType = TouKuiEntry.Instance.GameData.ResultData.cbType;
                    TouKuiEntry.Instance.GameData.CurrentFuDongExtWildCount = TouKuiEntry.Instance.GameData.SceneData.nExtWildCount;
                    TouKui_Event.DispatchStartRoll();
                    break;
                case TouKui_Struct.SUB_SC_BET_FAIL:
                    TouKui_Struct.CMD_SC_BetFail betFail = new TouKui_Struct.CMD_SC_BetFail(buffer);
                    if (betFail.cbResCode == 1)
                    {
                        ToolHelper.PopBigWindow(new BigMessage()
                        {
                            content = "Insufficient gold coins",
                            okCall = delegate ()
                            {
                                TouKui_Event.DispatchBetFailed();
                            }
                        });
                    }
                    else
                    {
                        ToolHelper.PopBigWindow(new BigMessage()
                        {
                            content = "下注失败",
                            okCall = delegate ()
                            {
                                TouKui_Event.DispatchBetFailed();
                            }
                        }); 
                    }
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
            TouKuiEntry.Instance.GameData.SceneData = new TouKui_Struct.SC_SceneInfo(buffer);
            TouKuiEntry.Instance.GameData.CurrentMode = (SpecialMode)TouKuiEntry.Instance.GameData.SceneData.nFreeType;
            TouKuiEntry.Instance.GameData.CurrentFreeCount = TouKuiEntry.Instance.GameData.SceneData.nFreeCount;
            TouKuiEntry.Instance.GameData.FixWild = TouKuiEntry.Instance.GameData.SceneData.cbFixed;
            TouKuiEntry.Instance.GameData.CurrentExtOdd = TouKuiEntry.Instance.GameData.SceneData.nExtOdd;
            TouKuiEntry.Instance.GameData.FuDongStartCol = TouKuiEntry.Instance.GameData.SceneData.nStartCol;
            TouKuiEntry.Instance.GameData.FuDongStartRow = TouKuiEntry.Instance.GameData.SceneData.nStartRow;
            TouKuiEntry.Instance.GameData.CurrentFuDongType = TouKuiEntry.Instance.GameData.SceneData.cbType;
            TouKuiEntry.Instance.GameData.CurrentFuDongExtWildCount = TouKuiEntry.Instance.GameData.SceneData.nExtWildCount;
            TouKui_Event.DispatchOnGetSceneData();
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
            HotfixActionHelper.ReconnectGame -= EventHelper_ReconnectGame;
        }
    }
}
