using LitJson;
using LuaFramework;
using System;

namespace Hotfix.LTBY
{
    public class LTBY_Network: SingletonILEntity<LTBY_Network>
    {
        #region REQ
        /// <summary>
        /// 发射子弹
        /// </summary>
        public const ushort SUB_C_PRESS_SHOOT = 50100;
        /// <summary>
        /// 玩家命中
        /// </summary>
        public const ushort SUB_C_HITED_FISH = 50101;
        /// <summary>
        /// 切换炮台等级
        /// </summary>
        public const ushort SUB_C_CHANGEBULLETLEVEL = 50102;
        /// <summary>
        /// 击中水浒传
        /// </summary>
        public const ushort SUB_C_SHUIHUZHUAN = 50103;
        /// <summary>
        /// 打死鱼王
        /// </summary>
        public const ushort SUB_C_YUWANG = 50104;
        /// <summary>
        /// 打死同类炸弹
        /// </summary>
        public const ushort SUB_C_TONGLEIZHADAN = 50105;
        /// <summary>
        /// 打死局部炸弹
        /// </summary>
        public const ushort SUB_C_JUBUZHADAN = 50106;
        /// <summary>
        /// 玩家开始锁定
        /// </summary>
        public const ushort SUB_C_PlayerLock = 50107;
        /// <summary>
        /// 玩家取消锁定
        /// </summary>
        public const ushort SUB_C_PlayerCancalLock = 50108;

        #endregion

        #region ACP
        /// <summary>
        /// 游戏开始
        /// </summary>
        private const ushort SUB_S_GAME_START = 50001;
        /// <summary>
        /// 增加鱼
        /// </summary>
        private const ushort SUB_S_ADD_FISH = 50002;
        /// <summary>
        /// 鱼死亡
        /// </summary>
        private const ushort SUB_S_FISH_DEAD = 50003;
        /// <summary>
        /// 玩家发炮
        /// </summary>
        private const ushort SUB_S_PLAYER_SHOOT = 50004;
        /// <summary>
        /// 配置信息
        /// </summary>
        private const ushort SUB_S_CONFIG = 50005;
        /// <summary>
        /// 切换炮台等级
        /// </summary>
        private const ushort SUB_S_CHANGEBULLETLEVEL = 50006;
        /// <summary>
        /// 打死水浒传
        /// </summary>
        private const ushort SUB_S_SHUIHUZHUAN = 50007;
        /// <summary>
        /// 打死忠义堂
        /// </summary>
        private const ushort SUB_S_ZHONGYITANG = 50008;
        /// <summary>
        /// 打死大三元,大奖章鱼
        /// </summary>
        private const ushort SUB_S_DASANYUAN = 50009;
        /// <summary>
        /// 打死大四喜
        /// </summary>
        private const ushort SUB_S_DASIXI = 50010;
        /// <summary>
        /// 打死鱼王
        /// </summary>
        private const ushort SUB_S_YUWANG = 50011;
        /// <summary>
        /// 打死同类炸弹
        /// </summary>
        private const ushort SUB_S_TONGLEIZHADAN = 50012;
        /// <summary>
        /// 打死一网打尽
        /// </summary>
        private const ushort SUB_S_YIWANGDAJIN = 50013;
        /// <summary>
        /// 打死局部炸弹
        /// </summary>
        private const ushort SUB_S_JUBUZHADAN = 50014;
        /// <summary>
        /// 玩家进入
        /// </summary>
        private const ushort SUB_S_PLAYERENTER = 50015;
        /// <summary>
        /// 击中李逵
        /// </summary>
        private const ushort SUB_S_SHOOT_LK = 50016;
        /// <summary>
        /// 鱼潮来临
        /// </summary>
        private const ushort SUB_S_YUCHAOCOME = 50017;
        /// <summary>
        /// 鱼潮即将来临
        /// </summary>
        private const ushort SUB_S_YUCHAOPRE = 50018;
        /// <summary>
        /// 玩家炮台信息
        /// </summary>
        private const ushort SUB_S_PLAYERGUNLEVEL = 50019;
        /// <summary>
        /// 玩家锁定
        /// </summary>
        private const ushort SUB_S_PlayerLock = 50020;
        /// <summary>
        /// 玩家取消锁定
        /// </summary>
        private const ushort SUB_S_PlayerCancalLock = 50021;
        /// <summary>
        /// 机器人进入
        /// </summary>
        private const ushort SUB_S_RobotCome = 50022;
        /// <summary>
        /// 机器人列表
        /// </summary>
        private const ushort SUB_S_RobotList = 50023;
        /// <summary>
        /// 机器人发炮
        /// </summary>
        private const ushort SUB_S_RobotShoot = 50024;
        /// <summary>
        /// 玩家鱼潮进入
        /// </summary>
        private const ushort SUB_S_PLAYER_YC_ENTER = 50026;

        #endregion

        bool canSend;
        protected override void Awake()
        {
            base.Awake();
            canSend = true;
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
            HotfixActionHelper.ReconnectGame += EventHelper_ReconnectGame;
        }

        private void LoginGame()
        {
            if (HotfixGameComponent.Instance == null) return;
            if (!canSend) return;
            REQ_LOGINGAME login = new REQ_LOGINGAME(0, 0, GameLocalMode.Instance.SCPlayerInfo.DwUser_Id, GameLocalMode.Instance.SCPlayerInfo.Password, GameLocalMode.Instance.MechinaCode, 0, 0);
            canSend = HotfixGameComponent.Instance.Send(DataStruct.LoginGameStruct.MDM_GR_LOGON, DataStruct.LoginGameStruct.SUB_GR_LOGON_GAME, login.ByteBuffer, SocketType.Game); 
            if (!canSend)
            {
                LTBY_Messagebox tipBox = LTBY_ViewManager.Instance.OpenMessageBox<LTBY_Messagebox>();
                tipBox.SetTitle(MessageBoxConfig.Title);
                tipBox.SetText(MessageBoxConfig.NetworkError);
                tipBox.SetCloseFunc(() =>
                {
                    Action action = LTBY_GameView.GameInstance.BackToSelectArena;
                    LTBY_ViewManager.Instance.Open<LTBY_CountDownView>(GameViewConfig.Text.SyncServerData, 3, action);
                    //LTBY_BatteryManager.Instance.SetCanShoot(true); 
                });
                tipBox.ShowBtnConfirm(() =>
                {
                    Action action = LTBY_GameView.GameInstance.BackToSelectArena;
                    LTBY_ViewManager.Instance.Open<LTBY_CountDownView>(GameViewConfig.Text.SyncServerData, 3, action);
                    //LTBY_ViewManager.Instance.Open<LTBY_ShopView>();
                }, true);
            }
        }

        private void EventHelper_ReconnectGame()
        {
            LoginGame();
        }

        /// <summary>
        /// 发送游戏消息
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="buffer">结构体</param>
        public bool Send(ushort sid,ByteBuffer buffer)
        {
            if (!HotfixGameComponent.Instance.connectGameSuccess) return false;
            if (!canSend) return false;
            canSend = HotfixGameComponent.Instance != null && HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, sid, buffer, SocketType.Game);
            if (!canSend)
            {
                LTBY_Messagebox tipBox = LTBY_ViewManager.Instance.OpenMessageBox<LTBY_Messagebox>();
                tipBox.SetTitle(MessageBoxConfig.Title);
                tipBox.SetText(MessageBoxConfig.NetworkError);
                tipBox.SetCloseFunc(() =>
                {
                    Action action = LTBY_GameView.GameInstance.BackToSelectArena;
                    LTBY_ViewManager.Instance.Open<LTBY_CountDownView>(GameViewConfig.Text.SyncServerData, 3, action);
                    //LTBY_BatteryManager.Instance.SetCanShoot(true); 
                });
                tipBox.ShowBtnConfirm(() =>
                {
                    Action action = LTBY_GameView.GameInstance.BackToSelectArena;
                    LTBY_ViewManager.Instance.Open<LTBY_CountDownView>(GameViewConfig.Text.SyncServerData, 3, action);
                    //LTBY_ViewManager.Instance.Open<LTBY_ShopView>();
                }, true);
            }
            return canSend;
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
                case SUB_S_ADD_FISH:
                    LTBY_Struct.CMD_S_AddFish addFish = new LTBY_Struct.CMD_S_AddFish(buffer);
                    DebugHelper.Log($"增加鱼：{JsonMapper.ToJson(addFish)}");
                    if (addFish.loadFishList.Exists(p => p.Kind == 48))
                    {
                        DebugHelper.Log($"奇遇蟹");
                    }
                    LTBY_Event.DispatchAddFishList(addFish);
                    break;
                case SUB_S_FISH_DEAD:
                    LTBY_Struct.CMD_S_FishDead fishDead = new LTBY_Struct.CMD_S_FishDead(buffer);
                    DebugHelper.LogError($"鱼死亡：{JsonMapper.ToJson(fishDead)}");
                    LTBY_Event.DispatchOnFishDead(fishDead.wChairID, fishDead);
                    break;
                case SUB_S_PLAYER_SHOOT:
                    LTBY_Struct.CMD_S_PlayerShoot shoot = new LTBY_Struct.CMD_S_PlayerShoot(buffer);
                    LTBY_Event.DispatchOnPlayerShoot(shoot);
                    DebugHelper.Log($"玩家发炮:{shoot.playCurScore}");
                    break;
                case SUB_S_CONFIG:
                    GameData.Instance.Config = new LTBY_Struct.CMD_S_CONFIG(buffer);
                    DebugHelper.Log($"获取配置成功:{LitJson.JsonMapper.ToJson(GameData.Instance.Config)}");
                    LTBY_Event.DispatchOnGetConfig();
                    break;
                case SUB_S_CHANGEBULLETLEVEL:
                    LTBY_Struct.CMD_S_ChangeBulletLevel _S_ChangeBulletLevel =
                        new LTBY_Struct.CMD_S_ChangeBulletLevel(buffer);
                    LTBY_Event.DispatchChangeBatteryLevel(_S_ChangeBulletLevel);
                    DebugHelper.Log($"改变炮台等级:{LitJson.JsonMapper.ToJson(_S_ChangeBulletLevel)}");
                    break;
                case SUB_S_SHUIHUZHUAN:
                    break;
                case SUB_S_ZHONGYITANG:
                    break;
                case SUB_S_DASANYUAN: //大奖章鱼
                    LTBY_Struct.CMD_S_DaJiangZhangYu zhangYu = new LTBY_Struct.CMD_S_DaJiangZhangYu(buffer);
                    //DebugHelper.Log($"打死大奖章鱼:{LitJson.JsonMapper.ToJson(zhangYu)}");
                    LTBY_Event.DispatchSCOnKillDJZY(zhangYu);
                    break;
                case SUB_S_DASIXI:
                    break;
                case SUB_S_YUWANG:
                    break;
                case SUB_S_TONGLEIZHADAN:
                    break;
                case SUB_S_YIWANGDAJIN:
                    break;
                case SUB_S_JUBUZHADAN:
                    break;
                case SUB_S_SHOOT_LK:
                    LTBY_Struct.CMD_S_ShootLK shootLk = new LTBY_Struct.CMD_S_ShootLK(buffer);
                    //DebugHelper.LogError($"打中李逵:{JsonMapper.ToJson(shootLk)}");
                    LTBY_Event.DispatchSCOnShootLK(shootLk);
                    break;
                case SUB_S_PLAYERENTER:
                    LTBY_Struct.CMD_S_PlayerEnter playerEnter = new LTBY_Struct.CMD_S_PlayerEnter(buffer);
                    DebugHelper.Log($"玩家进入:{JsonMapper.ToJson(playerEnter)}");
                    LTBY_Event.DispatchSCPlayerEnter(playerEnter);
                    break;
                case SUB_S_PLAYER_YC_ENTER:
                    LTBY_Struct.CMD_S_Player_YC_Enter playerYcEnter = new LTBY_Struct.CMD_S_Player_YC_Enter(buffer);
                    //DebugHelper.Log($"玩家鱼潮进入:{JsonMapper.ToJson(playerYcEnter)}");
                    LTBY_Event.DispatchSCPlayerYCEnter(playerYcEnter);
                    break;
                case SUB_S_YUCHAOCOME:
                    LTBY_Struct.CMD_S_YuChaoCome cMD_S_YuChao = new LTBY_Struct.CMD_S_YuChaoCome(buffer);
                    LTBY_Event.DispatchOnYCCome(cMD_S_YuChao);
                    //DebugHelper.Log($"鱼潮来临:{JsonMapper.ToJson(cMD_S_YuChao)}");
                    break;
                case SUB_S_YUCHAOPRE:
                    LTBY_Struct.CMD_S_YuChaoComePre cMD_S_YuChaoComePre = new LTBY_Struct.CMD_S_YuChaoComePre(buffer);
                    LTBY_Event.DispatchOnYCPre(cMD_S_YuChaoComePre);
                    //DebugHelper.Log($"鱼潮即将来临:{JsonMapper.ToJson(cMD_S_YuChaoComePre)}");
                    break;
                case SUB_S_PLAYERGUNLEVEL:
                    GameData.Instance.playerGuns = new LTBY_Struct.CMD_S_PlayerGunLevel(buffer);
                    LTBY_Event.DispatchSyncPropInfo(GameData.Instance.playerGuns);
                    DebugHelper.Log($"初始化炮台:{JsonMapper.ToJson(GameData.Instance.playerGuns)}");
                    break;
                case SUB_S_PlayerLock:
                    LTBY_Struct.CMD_S_PlayerLock playerLock = new LTBY_Struct.CMD_S_PlayerLock(buffer);
                    LTBY_Event.DispatchOnLockFish(playerLock);
                    break;
                case SUB_S_PlayerCancalLock:
                    LTBY_Struct.CMD_S_PlayerCancalLock
                        playerCancalLock = new LTBY_Struct.CMD_S_PlayerCancalLock(buffer);
                    LTBY_Event.DispatchOnCancelLockFish(playerCancalLock);
                    break;
                case SUB_S_RobotCome:
                    LTBY_Struct.CMD_S_RobotCome robotCome = new LTBY_Struct.CMD_S_RobotCome(buffer);
                    LTBY_Event.DispatchOnRobotCome(robotCome);
                    break;
                case SUB_S_RobotList:
                    LTBY_Struct.CMD_S_RobotList robotList = new LTBY_Struct.CMD_S_RobotList(buffer);
                    LTBY_Event.DispatchOnReceiveRobotList(robotList);
                    //DebugHelper.LogError($"机器人列表");
                    break;
                case SUB_S_RobotShoot:
                    LTBY_Struct.CMD_S_RobotShoot robotShoot = new LTBY_Struct.CMD_S_RobotShoot(buffer);
                    //DebugHelper.LogError($"机器人开炮");
                    LTBY_Event.DispatchOnRobotShoot(robotShoot);
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
            //DebugHelper.Log($"金币变动{data.ChairId}：{data.Gold}");
            LTBY_Event.DispatchSCSyncMoney(data);
        }

        /// <summary>
        /// 玩家离开
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="data">数据</param>
        private void UserExitAction(ushort sid, GameUserData data)
        {
            //DebugHelper.LogError($"玩家退出：{data.ChairId}");
            LTBY_Event.DispatchSCNotifyLogout(data);
        }

        /// <summary>
        /// 玩家进入
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="data">数据</param>
        private void UserEnterAction(ushort sid, GameUserData data)
        {
            LTBY_Event.DispatchSCUserReady(data);
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
            HotfixActionHelper.ReconnectGame -= EventHelper_ReconnectGame;
        }

        public void Stop()
        {

        }
    }
}
