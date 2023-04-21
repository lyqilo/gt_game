using LuaFramework;

namespace Hotfix.TGG
{
    /// <summary>
    /// 网络管理
    /// </summary>
    public class TGG_Network : SingletonILEntity<TGG_Network>
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
            TGGEntry.Instance.FQGY_Event_ShowResultNum(false);
            DebugHelper.Log($"TJZEntry.Instance.GameData.myGold:{TGGEntry.Instance.GameData.myGold}");
            DebugHelper.Log($"TJZEntry:{TGGEntry.Instance.GameData.CurrentChip * TGG_DataConfig.ALLLINECOUNT}");
            if (TGGEntry.Instance.GameData.myGold < TGGEntry.Instance.GameData.CurrentChip * TGG_DataConfig.ALLLINECOUNT && !TGGEntry.Instance.GameData.isFreeGame)
            {
                ToolHelper.PopBigWindow(new BigMessage()
                {
                    content = "Insufficient gold coins, please recharge",
                    okCall = delegate ()
                    {
                        TGG_Event.DispatchRollFailed();
                    },
                    cancelCall = delegate ()
                    {
                        TGG_Event.DispatchRollFailed();
                    }
                });
                return;
            }
            if (!TGGEntry.Instance.GameData.isFreeGame && !TGGEntry.Instance.GameData.Return)
            {
                TGGEntry.Instance.GameData.myGold -= (TGGEntry.Instance.GameData.CurrentChip * TGG_DataConfig.ALLLINECOUNT);
                TGG_Event.DispatchRefreshGold(TGGEntry.Instance.GameData.myGold);
            }
            TGG_Struct.CMD_3D_CS_StartGame _StartGame = new TGG_Struct.CMD_3D_CS_StartGame(TGGEntry.Instance.GameData.CurrentChip);
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, TGG_Struct.SUB_CS_GAME_START, _StartGame.ByteBuffer, SocketType.Game);
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
                case TGG_Struct.SUB_SC_GAME_START:
                    TGGEntry.Instance.GameData.ResultData = new TGG_Struct.CMD_3D_SC_Result(buffer);
                    DebugHelper.Log($"result:{LitJson.JsonMapper.ToJson(TGGEntry.Instance.GameData.ResultData)}");
                    TGG_Event.DispatchStartRoll();
                    break;
                case TGG_Struct.SUB_SC_BET_ERR:
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
            TGGEntry.Instance.GameData.SceneData = new TGG_Struct.SC_SceneInfo(buffer);
            TGG_Event.DispatchOnGetSceneData();
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
