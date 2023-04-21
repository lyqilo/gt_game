using System.Collections;
using System.Collections.Generic;
using Hotfix.TouKui;
using LuaFramework;
using UnityEngine;

namespace Hotfix.WPBY
{
    public class WPBY_Network : SingletonILEntity<WPBY_Network>
    {
        public const ushort SUB_C_PRESS_SHOOT = 50100; //发射子弹
        public const ushort SUB_C_HITED_FISH = 50101; //玩家命中
        public const ushort SUB_C_CHANGEBULLETLEVEL = 50102; //切换炮台等级
        public const ushort SUB_C_SHUIHUZHUAN = 50103; //击中水浒传
        public const ushort SUB_C_YUWANG = 50104; //打死鱼王
        public const ushort SUB_C_TONGLEIZHADAN = 50105; //打死同类炸弹
        public const ushort SUB_C_JUBUZHADAN = 50106; //打死局部炸弹
        public const ushort SUB_C_PlayerLock = 50107; //玩家开始锁定
        public const ushort SUB_C_PlayerCancalLock = 50108; //玩家取消锁定
        public const ushort SUB_S_GAME_START = 50001; //游戏开始
        public const ushort SUB_S_ADD_FISH = 50002; //增加鱼
        public const ushort SUB_S_FISH_DEAD = 50003; //鱼死亡
        public const ushort SUB_S_PLAYER_SHOOT = 50004; //玩家发炮
        public const ushort SUB_S_CONFIG = 50005; //配置信息
        public const ushort SUB_S_CHANGEBULLETLEVEL = 50006; //切换炮台等级
        public const ushort SUB_S_SHUIHUZHUAN = 50007; //打死水浒传
        public const ushort SUB_S_ZHONGYITANG = 50008; //打死忠义堂
        public const ushort SUB_S_DASANYUAN = 50009; //打死大三元
        public const ushort SUB_S_DASIXI = 50010; //打死大四喜
        public const ushort SUB_S_YUWANG = 50011; //打死鱼王
        public const ushort SUB_S_TONGLEIZHADAN = 50012; //打死同类炸弹
        public const ushort SUB_S_YIWANGDAJIN = 50013; //打死一网打尽
        public const ushort SUB_S_JUBUZHADAN = 50014; //打死局部炸弹
        public const ushort SUB_S_PLAYERENTER = 50015; //玩家进入
        public const ushort SUB_S_SHOOT_LK = 50016; //击中李逵
        public const ushort SUB_S_YUCHAOCOME = 50017; //鱼潮来临
        public const ushort SUB_S_YUCHAOPRE = 50018; //鱼潮即将来临
        public const ushort SUB_S_PLAYERGUNLEVEL = 50019; //玩家炮台信息
        public const ushort SUB_S_PlayerLock = 50020; //玩家锁定
        public const ushort SUB_S_PlayerCancalLock = 50021; //玩家取消锁定
        public const ushort SUB_S_RobotCome = 50022; //机器人进入
        public const ushort SUB_S_RobotList = 50023; //机器人列表
        public const ushort SUB_S_RobotShoot = 50024; //机器人发炮
        protected override void Awake()
        {
            base.Awake();
            LoginGame();
        }
        protected override void AddEvent()
        {
            base.AddEvent();
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
                case SUB_S_CONFIG://初始场景
                                  //获取配置
                    WPBYEntry.Instance.GameData.Config = new WPBY_Struct.CMD_S_CONFIG(buffer);
                    WPBY_Event.DispatchOnGetConfig();
                    break;
                case SUB_S_PLAYERGUNLEVEL://初始化炮台
                    WPBY_PlayerController.Instance.SetPlayerGunLevel(new WPBY_Struct.CMD_S_PlayerGunLevel(buffer));
                    break;
                case SUB_S_PLAYERENTER://玩家进入
                    WPBY_FishController.Instance.InitFish(new WPBY_Struct.CMD_S_PlayerEnter(buffer));
                    break;
                case SUB_S_ADD_FISH://增加鱼
                    WPBY_FishController.Instance.SetFish(new WPBY_Struct.CMD_S_AddFish(buffer));
                    WPBYEntry.Instance.heidongEffect.gameObject.SetActive(false);
                    break;
                case SUB_S_PLAYER_SHOOT://玩家发炮
                    WPBY_Struct.CMD_S_PlayerShoot playerShoot = new WPBY_Struct.CMD_S_PlayerShoot(buffer);
                    if (WPBYEntry.Instance.GameData.isRevert)
                    {
                        playerShoot.x *= -1;
                        playerShoot.y *= -1;
                    }
                    WPBY_PlayerController.Instance.ShootBullet(playerShoot);
                    break;
                case SUB_S_FISH_DEAD://鱼被打死
                    WPBY_FishController.Instance.FishDead(new WPBY_Struct.CMD_S_FishDead(buffer));
                    break;
                case SUB_S_CHANGEBULLETLEVEL://改变炮台等级
                    {
                        WPBY_Struct.CMD_S_ChangeBulletLevel changeBulletLevel = new WPBY_Struct.CMD_S_ChangeBulletLevel(buffer);
                        WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(changeBulletLevel.wChairID);
                        if (player != null) player.ChangePTLevel(changeBulletLevel);
                    }
                    break;
                case SUB_S_YUCHAOPRE://鱼潮即将来临
                    WPBY_Struct.CMD_S_YuChaoPre yuChaoPre = new WPBY_Struct.CMD_S_YuChaoPre(buffer);
                    WPBYEntry.Instance.ShowTip(-1);
                    WPBY_FishController.Instance.SetAddSpeed();
                    WPBY_Effect.Instance.OnChangeBGYuChao(yuChaoPre.backId);
                    WPBYEntry.Instance.GameData.isYc = true;
                    break;
                case SUB_S_YUCHAOCOME://鱼潮来临
                    WPBY_FishController.Instance.SetAddSpeed();
                    WPBYEntry.Instance.GameData.isYc = false;
                    WPBY_FishController.Instance.OnJoinFishTide(new WPBY_Struct.CMD_S_YuChaoCome(buffer));
                    break;
                case SUB_S_ZHONGYITANG://打死忠义堂
                    WPBY_FishController.Instance.OnZYTDie(new WPBY_Struct.CMD_S_ZhongYiTang(buffer));
                    break;
                case SUB_S_SHUIHUZHUAN://打死水浒传
                    WPBY_FishController.Instance.OnSHZDie(new WPBY_Struct.CMD_S_ShuiHuZhuan(buffer));
                    break;
                case SUB_S_JUBUZHADAN://打死局部炸弹
                    WPBY_FishController.Instance.OnJBZDDie(new WPBY_Struct.CMD_S_JuBuZhaDan(buffer));
                    break;
                case SUB_S_DASIXI://打死大四喜
                    WPBY_FishController.Instance.OnDSXDie(new WPBY_Struct.CMD_S_DaSiXi(buffer));
                    break;
                case SUB_S_DASANYUAN://打死大三元
                    WPBY_FishController.Instance.OnDSYDie(new WPBY_Struct.CMD_S_DaSanYuan(buffer));
                    break;
                case SUB_S_SHOOT_LK://击中李逵
                    WPBY_FishController.Instance.OnShotLK(new WPBY_Struct.CMD_S_ShootLK(buffer));
                    break;
                case SUB_S_PlayerLock://玩家锁定
                    WPBY_PlayerController.Instance.OnLockFish(new WPBY_Struct.CMD_S_PlayerLock(buffer));
                    break;
                case SUB_S_PlayerCancalLock://玩家取消锁定
                    WPBY_Struct.CMD_S_PlayerCancalLockLock cancalLockLock = new WPBY_Struct.CMD_S_PlayerCancalLockLock(buffer);
                    WPBY_PlayerController.Instance.OnCancalLock(cancalLockLock.chairId);
                    break;
                case SUB_S_YUWANG://打死鱼王
                    WPBY_FishController.Instance.OnYWDie(new WPBY_Struct.CMD_S_YuWang(buffer));
                    break;
                case SUB_S_YIWANGDAJIN://一网打尽
                    WPBY_FishController.Instance.OnYWDJDie(new WPBY_Struct.CMD_S_YiWangDaJin(buffer));
                    break;
                case SUB_S_TONGLEIZHADAN://同类炸弹
                    WPBY_FishController.Instance.OnTLZDDie(new WPBY_Struct.CMD_S_TongLeiZhaDan(buffer));
                    break;
                case SUB_S_RobotCome://机器人进入
                    {
                        WPBY_Struct.CMD_S_RobotCome robotCome = new WPBY_Struct.CMD_S_RobotCome(buffer);
                        WPBY_Player player1 = WPBY_PlayerController.Instance.GetPlayer(robotCome.chairID);
                        if (player1 != null)
                        {
                            player1.isRobot = true;
                        }
                        break;
                    }
                case SUB_S_RobotList://机器人列表
                    {
                        WPBY_Struct.CMD_S_RobotList robotList = new WPBY_Struct.CMD_S_RobotList(buffer);
                        for (int i = 0; i < robotList.isRobot.Count; i++)
                        {
                            if (robotList.isRobot[i])
                            {
                                WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(i);
                                if (player != null)
                                {
                                    player.isRobot = true;
                                }
                            }
                        }
                    }
                    break;
                case SUB_S_RobotShoot://机器人开炮
                    {
                        WPBY_Struct.CMD_S_RobotShoot robotShoot = new WPBY_Struct.CMD_S_RobotShoot(buffer);
                        WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(robotShoot.chairId);
                        if (player == null) return;
                        player.isRobot = true;
                        player.IsLock = true;
                        player.isRobotIsLock = true;
                        player.isContinue = true;
                        WPBY_Fish fish = WPBY_FishController.Instance.OnGetRandomLookFish(true);
                        if (fish != null)
                        {
                            player.LockFish = fish;
                            player.dir = fish.transform.position;
                        }
                        player.OnSetUserGunLevel(robotShoot.level, robotShoot.type);
                        player.ContinueFire(0.5f, 0.5f);
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
            WPBY_Event.DispatchOnPlayerScoreChanged(data);
        }

        /// <summary>
        /// 玩家离开
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="data">数据</param>
        private void UserExitAction(ushort sid, GameUserData data)
        {
            WPBY_Event.DispatchOnPlayerExit(data);
            if (WPBYEntry.Instance.UserList.ContainsKey(data.ChairId))
            {
                WPBY_PlayerController.Instance.DestroyPlayer(data.ChairId);
                WPBYEntry.Instance.UserList.Remove(data.ChairId);
            }
        }

        /// <summary>
        /// 玩家进入
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="data">数据</param>
        private void UserEnterAction(ushort sid, GameUserData data)
        {
            WPBY_Event.DispatchOnPlayerEnter(data);
        }

        /// <summary>
        /// 断线
        /// </summary>
        /// <param name="sid">子消息号</param>
        /// <param name="pack">数据</param>
        private void RoomBreakLineAction(ushort sid, BytesPack pack)
        {
            ByteBuffer buffer = new ByteBuffer(pack.bytes);
            ushort len = buffer.ReadUInt16();
            string msg = buffer.ReadString(len);
            ToolHelper.PopBigWindow(new BigMessage()
            {
                content = msg,
                okCall = Quit,
                cancelCall = Quit
            });
        }
        private void Quit()
        {
            WPBY_Event.DispatchOnLeaveGame();
            ByteBuffer buffer = new ByteBuffer();
            buffer.WriteUInt32(GameLocalMode.Instance.SCPlayerInfo.DwUser_Id);
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO, DataStruct.PersonalStruct.SUB_3D_CS_SELECT_GOLD_MSG, buffer, SocketType.Hall);
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