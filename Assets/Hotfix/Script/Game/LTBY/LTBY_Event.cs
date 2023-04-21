using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.LTBY
{
    /// <summary>
    /// 事件管理
    /// </summary>
    public class LTBY_Event
    {
        /// <summary>
        /// 玩家进入
        /// </summary>
        public static event CAction<GameUserData> SCUserReady;

        public static void DispatchSCUserReady(GameUserData data)
        {
            SCUserReady?.Invoke(data);
        }

        /// <summary>
        /// 玩家退出
        /// </summary>
        public static event CAction<GameUserData> SCNotifyLogout;

        public static void DispatchSCNotifyLogout(GameUserData data)
        {
            SCNotifyLogout?.Invoke(data);
        }

        /// <summary>
        /// 同步玩家金币
        /// </summary>
        public static event CAction<GameUserData> SCSyncMoney;

        public static void DispatchSCSyncMoney(GameUserData data)
        {
            SCSyncMoney?.Invoke(data);
        }

        /// <summary>
        /// 显示游戏ui
        /// </summary>
        public static event CAction<bool> ShowGameUi;

        public static void DispatchShowGameUi(bool showUiFlag)
        {
            ShowGameUi?.Invoke(showUiFlag);
        }

        /// <summary>
        /// 获取到配置
        /// </summary>
        public static event CAction OnGetConfig;

        public static void DispatchOnGetConfig()
        {
            OnGetConfig?.Invoke();
        }

        /// <summary>
        /// 改变炮台押注
        /// </summary>
        public static event CAction<int, int> ChangeBatteryChip;

        public static void DispatchChangeBatteryChip(int wChairId, int chip)
        {
            ChangeBatteryChip?.Invoke(wChairId, chip);
        }

        /// <summary>
        /// 初始化炮台等级
        /// </summary>
        public static event CAction<LTBY_Struct.CMD_S_PlayerGunLevel> SyncPropInfo;

        public static void DispatchSyncPropInfo(LTBY_Struct.CMD_S_PlayerGunLevel gunLevel)
        {
            SyncPropInfo?.Invoke(gunLevel);
        }

        /// <summary>
        /// 改变炮台等级
        /// </summary>
        public static event CAction<LTBY_Struct.CMD_S_ChangeBulletLevel> ChangeBatteryLevel;

        public static void DispatchChangeBatteryLevel(LTBY_Struct.CMD_S_ChangeBulletLevel _S_ChangeBulletLevel)
        {
            ChangeBatteryLevel?.Invoke(_S_ChangeBulletLevel);
        }

        /// <summary>
        /// 炮台发炮
        /// </summary>
        public static event CAction<int, Vector2> BatteryFire;

        public static void DispatchBatteryFire(int chairID, Vector2 pos)
        {
            BatteryFire?.Invoke(chairID, pos);
        }

        /// <summary>
        /// 连续射击
        /// </summary>
        public static event CAction<int, bool> BatteryContinueFire;

        public static void DispatchContinueFire(int chairId, bool isContinue)
        {
            BatteryContinueFire?.Invoke(chairId, isContinue);
        }

        /// <summary>
        /// 锁定射击
        /// </summary>
        public static event CAction<int, bool> BatteryLockFire;

        public static void DispatchLockFire(int chairId, bool isLock)
        {
            BatteryLockFire?.Invoke(chairId, isLock);
        }

        /// <summary>
        /// 鱼潮即将来临
        /// </summary>
        public static event CAction<LTBY_Struct.CMD_S_YuChaoComePre> OnYCPre;

        public static void DispatchOnYCPre(LTBY_Struct.CMD_S_YuChaoComePre cMD_S_Yu)
        {
            OnYCPre?.Invoke(cMD_S_Yu);
        }

        /// <summary>
        /// 鱼潮来临
        /// </summary>
        public static event CAction<LTBY_Struct.CMD_S_YuChaoCome> OnYCCome;

        public static void DispatchOnYCCome(LTBY_Struct.CMD_S_YuChaoCome cMD_S_Yu)
        {
            OnYCCome?.Invoke(cMD_S_Yu);
        }

        /// <summary>
        /// 子弹撞击后
        /// </summary>
        public static event CAction<int, int> OnBulletHit;

        public static void DispatchOnBulletHit(int chairId, int bulletId)
        {
            OnBulletHit?.Invoke(chairId, bulletId);
        }

        /// <summary>
        /// 锁定鱼
        /// </summary>
        public static event CAction<LTBY_Struct.CMD_S_PlayerLock> OnLockFish;

        public static void DispatchOnLockFish(LTBY_Struct.CMD_S_PlayerLock playerLock)
        {
            OnLockFish?.Invoke(playerLock);
        }

        /// <summary>
        /// 玩家取消锁定
        /// </summary>
        public static event CAction<LTBY_Struct.CMD_S_PlayerCancalLock> OnCancelLockFish;

        public static void DispatchOnCancelLockFish(LTBY_Struct.CMD_S_PlayerCancalLock playerCancalLock)
        {
            OnCancelLockFish?.Invoke(playerCancalLock);
        }

        /// <summary>
        /// 玩家发射
        /// </summary>
        public static event CAction<LTBY_Struct.CMD_S_PlayerShoot> OnPlayerShoot;

        public static void DispatchOnPlayerShoot(LTBY_Struct.CMD_S_PlayerShoot playerShoot)
        {
            OnPlayerShoot?.Invoke(playerShoot);
        }

        /// <summary>
        /// 鱼死亡
        /// </summary>
        public static event CAction<int, LTBY_Struct.CMD_S_FishDead> OnFishDead;

        public static void DispatchOnFishDead(int chairId, LTBY_Struct.CMD_S_FishDead fishDead)
        {
            OnFishDead?.Invoke(chairId, fishDead);
        }

        /// <summary>
        /// 显示大鱼提示
        /// </summary>
        public static event CAction<int> ShowTip;

        public static void DispatchShowTip(int fishKind)
        {
            ShowTip?.Invoke(fishKind);
        }


        /// <summary>
        /// 显示游戏MenuUI
        /// </summary>
        public static event CAction<bool> MenuViewShowGameUi;

        public static void DispatchMenuViewShowGameUi(bool showUiFlag)
        {
            MenuViewShowGameUi?.Invoke(showUiFlag);
        }


        /// <summary>
        /// 
        /// </summary>
        public static event CAction<Dictionary<string, CAction>> SCUserInfoNotify;

        public static void DispatchSCUserInfoNotify(Dictionary<string, CAction> dic)
        {
            SCUserInfoNotify?.Invoke(dic);
        }

        /// <summary>
        /// 
        /// </summary>
        public static event CAction<Dictionary<string, CAction>> SCCallFish;

        public static void DispatchSCCallFish(Dictionary<string, CAction> dic)
        {
            SCCallFish?.Invoke(dic);
        }

        public static event CAction<LTBY_Struct.CMD_S_PlayerEnter> SCPlayerEnter;

        public static void DispatchSCPlayerEnter(LTBY_Struct.CMD_S_PlayerEnter _S_PlayerEnter)
        {
            SCPlayerEnter?.Invoke(_S_PlayerEnter);
        }

        public static event CAction<LTBY_Struct.CMD_S_Player_YC_Enter> SCPlayerYCEnter;

        public static void DispatchSCPlayerYCEnter(LTBY_Struct.CMD_S_Player_YC_Enter _S_PlayerEnter)
        {
            SCPlayerYCEnter?.Invoke(_S_PlayerEnter);
        }

        /// <summary>
        /// 打中李逵
        /// </summary>
        public static event CAction<LTBY_Struct.CMD_S_ShootLK> SCOnShootLK;

        public static void DispatchSCOnShootLK(LTBY_Struct.CMD_S_ShootLK shootLk)
        {
            SCOnShootLK?.Invoke(shootLk);
        }


        //------------------fish----------------------//

        /// <summary>
        /// 普通产鱼
        /// </summary>
        public static event CAction<LTBY_Struct.CMD_S_AddFish> AddFishList;

        public static void DispatchAddFishList(LTBY_Struct.CMD_S_AddFish action)
        {
            AddFishList?.Invoke(action);
        }

        /// <summary>
        /// 服务器请求客户端同步鱼
        /// </summary>
        public static event CAction<SCSyncFishReq> S_CSyncFishReq;

        public static void DispatchSCSyncFishReq(SCSyncFishReq action)
        {
            S_CSyncFishReq?.Invoke(action);
        }

        /// <summary>
        /// 服务器返回客户端同步鱼
        /// </summary>
        public static event CAction<SCSyncFishRsp> S_CSyncFishRsp;

        public static void DispatchSCSyncFishRsp(SCSyncFishRsp action)
        {
            S_CSyncFishRsp?.Invoke(action);
        }

        /// <summary>
        /// 捕获
        /// </summary>
        public static event CAction<SCHitFish> S_CHitFish;

        public static void DispatchSCHitFish(SCHitFish action)
        {
            S_CHitFish?.Invoke(action);
        }

        /// <summary>
        /// 特殊捕鱼
        /// </summary>
        public static event CAction<SCHitSpecialFish> S_CHitSpecialFish;

        public static void DispatchSCHitSpecialFish(SCHitSpecialFish action)
        {
            S_CHitSpecialFish?.Invoke(action);
        }

        /// <summary>
        /// 弹头捕获
        /// </summary>
        public static event CAction<SCTorpedoHit> S_CTorpedoHit;

        public static void DispatchSCTorpedoHit(SCTorpedoHit action)
        {
            S_CTorpedoHit?.Invoke(action);
        }

        /// <summary>
        /// 锁鱼
        /// </summary>
        public static event CAction<SCLockFish> S_CLockFish;

        public static void DispatchSCLockFish(SCLockFish action)
        {
            S_CLockFish?.Invoke(action);
        }

        /// <summary>
        /// 切换场景
        /// </summary>
        public static event CAction<SCChangeScene> S_CChangeScene;

        public static void DispatchSCChangeScene(SCChangeScene action)
        {
            S_CChangeScene?.Invoke(action);
        }

        /// <summary>
        /// 游戏信息
        /// </summary>
        public static event CAction<SCGameInfoNotify> S_CGameInfoNotify;

        public static void DispatchSCGameInfoNotify(SCGameInfoNotify action)
        {
            S_CGameInfoNotify?.Invoke(action);
        }

        /// <summary>
        /// 聚宝盆的数值监听
        /// </summary>
        public static event CAction<SCTreasureFishInfo> S_CTreasureFishInfo;

        public static void DispatchSCTreasureFishInfo(SCTreasureFishInfo action)
        {
            S_CTreasureFishInfo?.Invoke(action);
        }

        /// <summary>
        /// 捕获聚宝盆
        /// </summary>
        public static event CAction<SCTreasureFishCatched> S_CTreasureFishCatched;

        public static void DispatchSCTreasureFishCatched(SCTreasureFishCatched action)
        {
            S_CTreasureFishCatched?.Invoke(action);
        }

        /// <summary>
        /// 打死奇遇蟹
        /// </summary>
        public static event CAction<LTBY_Struct.CMD_S_QiYuXie> SCOnKillQYX;

        public static void DispatchSCOnKillSCOnKillQYX(LTBY_Struct.CMD_S_QiYuXie qiYuXie)
        {
            SCOnKillQYX?.Invoke(qiYuXie);
        }
        /// <summary>
        /// 打死大奖章鱼
        /// </summary>
        public static event CAction<LTBY_Struct.CMD_S_DaJiangZhangYu> SCOnKillDJZY;

        public static void DispatchSCOnKillDJZY(LTBY_Struct.CMD_S_DaJiangZhangYu zhangYu)
        {
            SCOnKillDJZY?.Invoke(zhangYu);
        }


        public static event CAction<SCSetProbability> S_CSetProbability;

        public static void DispatchSCSetProbability(SCSetProbability action)
        {
            S_CSetProbability?.Invoke(action);
        }


        /// <summary>
        /// 
        /// </summary>
        public static event CAction<CSSyncFishRsp> CSSyncFishRsp;

        public static void DispatchCSSyncFishRsp(CSSyncFishRsp action)
        {
            CSSyncFishRsp?.Invoke(action);
        }

        public static event CAction<LTBY_Struct.PropStatus> SCPropStatus;

        public static void DispatchSCPropStatus(LTBY_Struct.PropStatus status)
        {
            SCPropStatus?.Invoke(status);
        }

        /// <summary>
        /// 机器人进入
        /// </summary>
        public static event CAction<LTBY_Struct.CMD_S_RobotCome> OnRobotCome;

        public static void DispatchOnRobotCome(LTBY_Struct.CMD_S_RobotCome come)
        {
            OnRobotCome?.Invoke(come);
        }

        /// <summary>
        /// 获取机器人列表
        /// </summary>
        public static event CAction<LTBY_Struct.CMD_S_RobotList> OnReceiveRobotList;

        public static void DispatchOnReceiveRobotList(LTBY_Struct.CMD_S_RobotList robotList)
        {
            OnReceiveRobotList?.Invoke(robotList);
        }

        /// <summary>
        /// 机器人射击
        /// </summary>
        public static event CAction<LTBY_Struct.CMD_S_RobotShoot> OnRobotShoot;

        public static void DispatchOnRobotShoot(LTBY_Struct.CMD_S_RobotShoot robotShoot)
        {
            OnRobotShoot?.Invoke(robotShoot);
        }
    }
}