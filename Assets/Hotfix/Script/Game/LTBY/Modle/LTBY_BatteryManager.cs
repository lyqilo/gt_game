using System.Collections.Generic;
using UnityEngine;
using LuaFramework;
using UnityEngine.EventSystems;
using System;
using DG.Tweening;
using UnityEngine.UI;
using TMPro;

namespace Hotfix.LTBY
{
    public class LTBY_BatteryManager : SingletonNew<LTBY_BatteryManager>
    {
        public float ShowWaterSpoutTime;
        private Dictionary<int, BatteryClass> BatteryList;
        private Dictionary<int, ElectricBatteryClass> ElectricList;
        private Dictionary<int, DrillBatteryClass> DrillList;
        private Dictionary<int, MissileBatteryClass> MissileList;
        private Dictionary<int, FreeBatteryClass> FreeBatteryList;
        public PointerEventData PressEventData;
        public bool Press;
        public bool AutoShoot;
        private bool CanShoot;
        private bool isOpenFreeLottery;
        private float MultiShootAngleLockingOffset = -65; //散射发射位置偏移
        private float MultiShootAngleOffset = -20; //散射角度偏移

        private bool IsOpenWaterBattery = true;//是否开启水炮
        public bool IsFreeBattery { get; set; } = false;//是否免费
        public int CurrentLevel { get; set; } = 0;//当前等级

        public override void Init(Transform ilentity = null)
        {
            base.Init(ilentity);
            ShowWaterSpoutTime = BatteryConfig.ShowWaterSpoutTime;
            BatteryList = new Dictionary<int, BatteryClass>();

            ElectricList = new Dictionary<int, ElectricBatteryClass>();

            DrillList = new Dictionary<int, DrillBatteryClass>();

            MissileList = new Dictionary<int, MissileBatteryClass>();

            FreeBatteryList = new Dictionary<int, FreeBatteryClass>();

            if (ilentity != null)
            {
                EventTriggerHelper node = EventTriggerHelper.Get(ilentity.gameObject);
                node.onDown = (go, eventData)=>
                {
                    DebugHelper.Log("点击");
                    PressEventData = eventData;
                    Press = true;
                };

                node.onDrag = (go, eventData) => { PressEventData = eventData; };

                node.onUp = (go, eventData) =>
                {
                    PressEventData = eventData;
                    Press = false;
                };
            }

            RegisterEvent();

            Press = false;

            AutoShoot = false;

            CanShoot = true;
            isOpenFreeLottery = false;
        }

        private void RegisterEvent()
        {
            LTBY_Event.SyncPropInfo += SyncPropInfo;
            LTBY_Event.ChangeBatteryLevel += SetProbability;
            LTBY_Event.OnPlayerShoot += LTBY_Event_OnPlayerShoot;
            LTBY_Event.OnLockFish += LTBY_Event_OnLockFish;
            LTBY_Event.OnCancelLockFish += LTBY_Event_OnCancelLockFish;
            LTBY_Event.OnRobotCome += LTBY_EventOnOnRobotCome;
            LTBY_Event.OnReceiveRobotList += LTBY_EventOnOnReceiveRobotList;
            LTBY_Event.OnRobotShoot += LTBY_EventOnOnRobotShoot;
        }

        private void LTBY_EventOnOnRobotShoot(LTBY_Struct.CMD_S_RobotShoot obj)
        {
            LTBY_Struct.CMD_S_ChangeBulletLevel changeBulletLevel = new LTBY_Struct.CMD_S_ChangeBulletLevel
            {
                wChairID = obj.chairId,
                cbGunLevel = obj.level,
                cbGunType = obj.type
            };
            LTBY_Event.DispatchChangeBatteryLevel(changeBulletLevel);

            BatteryClass batteryClass = GetBattery(obj.chairId);
            batteryClass?.SetRobot(true);
            batteryClass?.RobotShoot();
        }

        private void LTBY_EventOnOnReceiveRobotList(LTBY_Struct.CMD_S_RobotList obj)
        {
            for (int i = 0; i < obj.isRobot.Count; i++)
            {
                if (obj.isRobot[i] != 1) continue;
                BatteryClass batteryClass = GetBattery(i);
                batteryClass?.SetRobot(true);
            }
        }

        private void LTBY_EventOnOnRobotCome(LTBY_Struct.CMD_S_RobotCome obj)
        {
            BatteryClass batteryClass = GetBattery(obj.chairID);
            batteryClass?.SetRobot(true);
        }

        private void LTBY_Event_OnCancelLockFish(LTBY_Struct.CMD_S_PlayerCancalLock obj)
        {
            int chairId = obj.chairId;
            if (!LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                SetLockShoot(chairId, false);
            }
        }

        private void LTBY_Event_OnLockFish(LTBY_Struct.CMD_S_PlayerLock obj)
        {
            int chairId = obj.chairId;
            if (!LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                SetLockShoot(chairId, true);
            }
        }

        private void LTBY_Event_OnPlayerShoot(LTBY_Struct.CMD_S_PlayerShoot obj)
        {
            LTBY_GameView.GameInstance.SetScore(obj.wChairID, obj.playCurScore);
            if (LTBY_GameView.GameInstance.IsSelf(obj.wChairID)) return;
            OtherShoot(obj);
        }

        public override void Release()
        {
            base.Release();
            int[] keys = BatteryList.GetDictionaryKeys();
            for (int i = 0; i < keys.Length; i++)
            {
                DestroyBattery(keys[i]);
            }

            BatteryList?.Clear();

            ElectricList?.Clear();

            DrillList?.Clear();

            MissileList?.Clear();

            FreeBatteryList?.Clear();

            UnregisterEvent();
        }

        private void UnregisterEvent()
        {
            LTBY_Event.SyncPropInfo -= SyncPropInfo;
            LTBY_Event.ChangeBatteryLevel -= SetProbability;
            LTBY_Event.OnPlayerShoot -= LTBY_Event_OnPlayerShoot;
            LTBY_Event.OnLockFish -= LTBY_Event_OnLockFish;
            LTBY_Event.OnCancelLockFish -= LTBY_Event_OnCancelLockFish;
            LTBY_Event.OnRobotCome -= LTBY_EventOnOnRobotCome;
            LTBY_Event.OnReceiveRobotList -= LTBY_EventOnOnReceiveRobotList;
            LTBY_Event.OnRobotShoot -= LTBY_EventOnOnRobotShoot;
        }

        public void SetRageShoot(int chairId, bool flag)
        {
            if (BatteryList.ContainsKey(chairId))
            {
                BatteryList[chairId].SetRageShoot(flag);
            }
        }

        public void SetMultiShoot(int chairId, bool flag)
        {
            if (BatteryList.ContainsKey(chairId))
            {
                BatteryList[chairId].SetMultiShoot(flag);
            }
        }

        public void SetLockShoot(int chairId, bool flag)
        {
            if (!BatteryList.ContainsKey(chairId)) return;
            BatteryList[chairId].SetLockShoot(flag);
        }
        public bool IsRobot(int chairId)
        {
            BatteryClass battery = GetBattery(chairId);
            return battery != null && battery.IsRobot();
        }
        public bool IsPress()
        {
            return Press;
        }

        public void SetPress(bool flag)
        {
            Press = flag;
        }

        /// <summary>
        /// 同步炮台信息
        /// </summary>
        /// <param name="data"></param>
        private void SyncPropInfo(LTBY_Struct.CMD_S_PlayerGunLevel data)
        {
            for (int i = 0; i < data.GunLevel.Count; i++)
            {
                int chairId = i;
                ShowBattery(chairId);
                if (chairId == LTBY_GameView.GameInstance.chairId) return;
                LTBY_Struct.CMD_S_ChangeBulletLevel _S_ChangeBulletLevel = new LTBY_Struct.CMD_S_ChangeBulletLevel
                {
                    cbGunLevel = (byte)(data.GunLevel[i]),
                    cbGunType = (byte)(data.GunType[i]),
                    wChairID= chairId
                };
                LTBY_Event.DispatchChangeBatteryLevel(_S_ChangeBulletLevel);
            }
        }

        public void SetAutoShoot(bool flag)
        {
            AutoShoot = flag;
        }

        public bool GetIsAutoShoot()
        {
            return AutoShoot;
        }

        public void SetCanShoot(bool flag)
        {
            CanShoot = flag;
        }

        public void SetIsOpenFreeLottery(bool flag)
        {
            isOpenFreeLottery = flag;
        }

        public bool GetCanShoot()
        {
            return CanShoot && !isOpenFreeLottery;
        }

        public void OnSwitchRoom()
        {
            int[] keys = BatteryList.GetDictionaryKeys();
            for (int i = 0; i < keys.Length; i++)
            {
                DestroyBattery(keys[i]);
            }

            BatteryList?.Clear();

            ElectricList?.Clear();

            DrillList?.Clear();

            MissileList?.Clear();

            FreeBatteryList?.Clear();
            Press = false;

            AutoShoot = false;

            CanShoot = true;
            isOpenFreeLottery = false;
        }

        public void CreateBattery(int chairId, bool isSelf, Transform parent)
        {
            if (BatteryList.ContainsKey(chairId)) return;

            BatteryClass battery = null;

            battery = isSelf ? new SelfBatteryClass() : new BatteryClass();

            battery.OnCreate(chairId, parent);

            BatteryList.Add(chairId, battery);
        }

        public void ShowBattery(int chairId)
        {
            if (BatteryList.ContainsKey(chairId))
            {
                BatteryList[chairId].Show();
                //GC.BulletManager.ShowWaterSpout(chairId, true);
            }

            //在掉落的时候关闭射击，在重新显示炮台的时候打开射击
            if (LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                SetCanShoot(true);
            }
        }

        private void HideBattery(int chairId)
        {
            if (BatteryList.ContainsKey(chairId))
            {
                BatteryList[chairId].Hide();
                //GC.BulletManager.ShowWaterSpout(chairId, false);
            }
        }

        public void ShowSummonTip(int chairId)
        {
            if (!BatteryList.ContainsKey(chairId)) return;

            Transform parent = BatteryList[chairId].parent;
            Transform tipNode = LTBY_Extend.Instance.LoadPrefab("LTBY_SummonText", parent);
            tipNode.localPosition = new Vector3(0, 135, 0);
            if (LTBY_GameView.GameInstance.CheckIsOtherSide(chairId))
            {
                tipNode.localEulerAngles = new Vector3(0, 0, 180);
            }

            ToolHelper.DelayRun(1.5f, () =>
            {
                if (tipNode != null) UnityEngine.Object.Destroy(tipNode.gameObject);
            });
        }

        public void CreateFreeBattery(int chairId, int ratio, int mul, float time, bool begin = false)
        {
            if (FreeBatteryList.ContainsKey(chairId))
            {
                FreeBatteryList[chairId].SetMul(mul);
                FreeBatteryList[chairId].SetTime(time);
                return;
            }


            //if (MissileList[chairId]) {

            //    GC.Notification.GamePost("SCTorpedoCancelSelfShoot", true);
            //}


            HideBattery(chairId);

            Transform parent = BatteryList[chairId].parent;
            FreeBatteryClass battery = new FreeBatteryClass();
            battery.OnCreate(chairId, ratio, mul, time, parent, begin);
            FreeBatteryList.Add(chairId, battery);
        }

        public FreeBatteryClass GetFreeBattery(int chairId)
        {
            FreeBatteryList.TryGetValue(chairId, out FreeBatteryClass freebattery);
            return freebattery;
        }

        public void DestroyFreeBattery(int chairId)
        {
            if (!FreeBatteryList.ContainsKey(chairId)) return;
            FreeBatteryList[chairId].Destroy();
            FreeBatteryList.Remove(chairId);
        }

        public void CreateElectric(int chairId, int ratio)
        {
            if (ElectricList.ContainsKey(chairId)) return;

            //if MissileList[chairId] {
            //    GC.Notification.GamePost("SCTorpedoCancelSelfShoot", true);
            //end

            HideBattery(chairId);

            Transform parent = BatteryList[chairId].parent;
            ElectricBatteryClass battery = new ElectricBatteryClass();
            battery.OnCreate(chairId, ratio, parent);
            battery.SetAngles(BatteryList[chairId].GetAngles());
            ElectricList.Add(chairId, battery);
        }

        public ElectricBatteryClass GetElectric(int chairId)
        {
            ElectricList.TryGetValue(chairId, out ElectricBatteryClass batteryClass);
            return batteryClass;
        }

        public void DestroyElectric(int chairId)
        {
            if (!ElectricList.ContainsKey(chairId)) return;
            ElectricList[chairId].Destroy();
            ElectricList.Remove(chairId);
        }

        public void CreateMissile(int chairId, int propId)
        {
            if (MissileList.ContainsKey(chairId)) return;

            HideBattery(chairId);

            Transform parent = BatteryList[chairId].parent;
            MissileBatteryClass battery = new MissileBatteryClass();
            battery.OnCreate(chairId, propId, parent);
            battery.SetAngles(0);
            MissileList.Add(chairId, battery);
        }

        public MissileBatteryClass GetMissile(int chairId)
        {
            MissileList.TryGetValue(chairId, out MissileBatteryClass batteryClass);
            return batteryClass;
        }

        public void DestroyMissile(int chairId)
        {
            if (!MissileList.ContainsKey(chairId)) return;
            MissileList[chairId].Destroy();
            MissileList.Remove(chairId);
        }

        public void CreateDrill(int chairId, int ratio)
        {
            if (DrillList.ContainsKey(chairId)) return;

            //if MissileList[chairId] {

            //    GC.Notification.GamePost("SCTorpedoCancelSelfShoot", true);
            //end

            HideBattery(chairId);

            Transform parent = BatteryList[chairId].parent;
            DrillBatteryClass battery = new DrillBatteryClass();
            battery.OnCreate(chairId, ratio, parent);
            battery.SetAngles(BatteryList[chairId].GetAngles());

            DrillList.Add(chairId, battery);
        }

        public DrillBatteryClass GetDrill(int chairId)
        {
            DrillList.TryGetValue(chairId, out DrillBatteryClass batteryClass);
            return batteryClass;
        }

        public void DestroyDrill(int chairId)
        {
            if (!DrillList.ContainsKey(chairId)) return;
            DrillList[chairId].Destroy();
            DrillList.Remove(chairId);
        }

        public void DestroyBattery(int chairId)
        {
            DestroyElectric(chairId);
            DestroyDrill(chairId);
            DestroyMissile(chairId);
            DestroyFreeBattery(chairId);
            if (!BatteryList.ContainsKey(chairId)) return;
            BatteryList[chairId].Destroy();
            BatteryList.Remove(chairId);
        }

        public string HadSpecialBattery(int chairId)
        {
            if (GetDrill(chairId) != null && GetDrill(chairId).isShoot) return "Drill";
            else if (GetElectric(chairId) != null && GetElectric(chairId).isShoot) return "Electric";
            else if (GetFreeBattery(chairId) != null && GetFreeBattery(chairId).isShoot) return "FreeBattery";
            return null;
        }

        public bool CheckCanUseMissile(int chairId)
        {
            return GetDrill(chairId) == null && GetElectric(chairId) == null && GetMissile(chairId) == null &&
                   GetFreeBattery(chairId) == null;
        }

        public string ChangeUnit(int num)
        {
            return num.ShortNumber();
            if (num >= 10000)
            {
                return $"{Mathf.Floor((float) num / 10000)}{BatteryConfig.Wan}";
            }
            else if (num >= 1000)
            {
                return $"{Mathf.Floor((float) num / 1000)}{BatteryConfig.Qian}";
            }
            else
            {
                return $"{num}";
            }
        }

        private void OtherShoot(LTBY_Struct.CMD_S_PlayerShoot data)
        {
            int bulletType = PropConfig.Bullet.id;
            int chairId = data.wChairID;
            if (bulletType == PropConfig.Bullet.id)
            {
                BatteryList.TryGetValue(chairId, out BatteryClass battery);
                if (battery != null && !battery.IsRobot()&&!LTBY_GameView.GameInstance.IsSelf(data.wChairID))
                {
                    battery.SetMultiShoot(false);
                    battery.SetAngles(data.x);
                    battery.Shoot();
                }
            }
            else if (bulletType == PropConfig.Drill1.id)
            {
                DrillList.TryGetValue(chairId, out DrillBatteryClass battery);
                if (battery != null)
                {
                    battery.SetAngles(data.x);
                    battery.Shoot();
                }
            }
            else if (bulletType == PropConfig.Electric1.id)
            {
                ElectricList.TryGetValue(chairId, out ElectricBatteryClass battery);
                if (battery != null)
                {
                    battery.SetAngles(data.x);
                    battery.Shoot();
                }
            }
            else if (bulletType == PropConfig.FreeBattery.id)
            {
                FreeBatteryList.TryGetValue(chairId, out FreeBatteryClass battery);
                if (battery != null)
                {
                    battery.SetAngles(data.x);
                    battery.Shoot();
                }
            }
            //if (LTBY_GameView.GameInstance.IsSelf(data.wChairID))
            //{
            //    LTBY_GameView.GameInstance.UserData.Gold = (ulong)data.playCurScore;
            //    LTBY_GameView.GameInstance.SetUserScore(data.playCurScore);
            //}
            LTBY_GameView.GameInstance.SetScore(chairId, data.playCurScore);
        }

        public void OtherMultiShoot(object data)
        {
            //if LTBY_GameView.GameInstance:IsSelf(data.chair_idx) { return end;

            //var bulletType = data.bullet_type;
            //       var chairId = data.chair_idx;
            //if bulletType == GC.PropConfig.Bullet.id {

            //       var battery = BatteryList[chairId];
            //	if battery {

            //           battery:SetMultiShoot(true);
            //       battery:SetAngles(data.angle);
            //       battery:Shoot();
            //       end
            //else
            //	logError("BatteryMGR @OtherMultiShoot 收到其他玩家用特殊子弹散射！！！")

            //   end
            //   LTBY_GameView.GameInstance:SetScore(chairId, data.score);
        }

        public void AdjustBatteryRatio(bool flag)
        {
            BatteryList.TryGetValue(LTBY_GameView.GameInstance.chairId, out BatteryClass batteryClass);
            if (batteryClass == null) return;
            LTBY_Struct.PlayerChangeGunLevel gunLevel = new LTBY_Struct.PlayerChangeGunLevel();
            gunLevel.wChairId = LTBY_GameView.GameInstance.chairId;
            int level = batteryClass.GetRatio();
            if (flag)
            {
                level++;
                if (level > 10) level = 1;
                batteryClass.SetRatio(level);
            }
            else
            {
                level--;
                if (level <= 0) level = 10;
                batteryClass.SetRatio(level);
            }

            gunLevel.gunGrade = (byte)(batteryClass.GetLevel() - 1);
            gunLevel.gunLevel = (byte)(batteryClass.GetRatio() - 1);
            LTBY_Network.Instance.Send(LTBY_Network.SUB_C_CHANGEBULLETLEVEL, gunLevel.Buffer);
        }

        public void SetRatio(int chairId, int ratio)
        {
            BatteryList.TryGetValue(chairId, out BatteryClass battery);
            battery?.SetRatio(ratio);
        }

        public void SetLevel(int chairId, int level)
        {
            BatteryList.TryGetValue(chairId, out BatteryClass battery);
            battery?.SetLevel(level);
        }

        private void SetProbability(LTBY_Struct.CMD_S_ChangeBulletLevel data)
        {
            int chairId = data.wChairID;
            SetLevel(chairId, data.cbGunType + 1);
            SetRatio(chairId, data.cbGunLevel + 1);
        }

        public Vector3 GetShootPosFromOffset(float offset, Vector3 oldPos, float angles)
        {
            if (offset == 0) return oldPos;
            float a = Mathf.Deg2Rad * 1 * angles;
            Vector3 pos = new Vector3(offset, 0, 0);
            float x = pos.x * Mathf.Cos(a) - pos.y * Mathf.Sin(a);
            float y = pos.x * Mathf.Sin(a) + pos.y * Mathf.Cos(a);
            Vector3 delta = new Vector3(x, y, 0);
            return oldPos + delta;
        }

        public float GetShootAngleFromOffset(float offset, float oldAngle, bool isLocking)
        {
            if (offset == 0) return oldAngle;
            if (isLocking)
            {
                return oldAngle + MultiShootAngleLockingOffset * offset;
            }
            else
            {
                return oldAngle + MultiShootAngleOffset * offset;
            }
        }

        public Vector3 GetShootingPos(int chairId)
        {
            return BatteryList.ContainsKey(chairId) ? BatteryList[chairId].shootPos.position : default;
        }

        public BatteryClass GetBattery(int chairId)
        {
            BatteryList.TryGetValue(chairId, out BatteryClass battery);
            return battery;
        }

        public bool IsWaterSpoutBattery(int level)
        {
            if (!IsOpenWaterBattery) return false;
            switch (level)
            {
                case BatteryConfig.DragonBatteryLevel:
                case BatteryConfig.ZCMBatteryLevel:
                    return true;
                default:
                    return false;
            }
        }
    }

    public class BatteryClass : IILManager
    {
        protected int chairId;
        protected bool isRobot;
        public Transform parent;
        protected float shootAngles;
        protected Transform battery;
        protected int level;
        protected int ratio;
        public Transform shootPos;
        protected float shootPosShowTime;
        protected bool shootPosShow;
        protected bool isOtherside;
        protected bool activeSelf;

        protected List<int> actionKey;
        protected List<int> timerKey;
        protected bool lockShoot;
        protected bool rageShoot;
        protected Transform rageSmokeEffect;
        protected int rageSmokeTimerKey;
        protected bool multiShoot;
        protected bool waterSpout;
        protected float showWaterSpoutTime;
        protected Animator batteryAnimator;
        public float shootInterval;
        protected float lastShootTime;
        protected int updateKey;
        protected Camera cam;
        protected bool alreadyPress;
        protected Transform tipNode;
        protected Transform tipImage;
        protected float countdownTime;
        protected Text tipCountdown;
        protected ILBehaviour IlBehaviour;
        protected bool isRobotAutoShoot;
        protected FishClass lockFish;

        public virtual void OnCreate(int _chairId, Transform _parent)
        {
            this.chairId = _chairId;
            this.parent = _parent;
            this.shootPosShowTime = 0;
            this.shootPosShow = false;
            this.shootAngles = 0;
            this.battery = null;
            this.level = 0;
            this.ratio = 0;
            this.isOtherside = LTBY_GameView.GameInstance.CheckIsOtherSide(this.chairId);
            _parent.gameObject.SetActive(true);
            this.actionKey = new List<int>();
            this.timerKey = new List<int>();
            this.lockShoot = false; //锁定技能控制变量
            this.rageShoot = false;
            this.rageSmokeEffect = null;
            this.rageSmokeTimerKey = 0;
            this.multiShoot = false; //是否开启了散射
            this.waterSpout = false; //是否应该发射水柱
            this.showWaterSpoutTime = 0; //显示水柱的时间
            BatteryLevelData defaultConfig = BatteryConfig.DefaultBattery[LTBY_GameView.GameInstance.GetArena()];
            SetLevel(defaultConfig.level);
            SetRatio(defaultConfig.ratio);
            Show();
            isRobot = false;
            isRobotAutoShoot = false;
            if (IlBehaviour == null)
            {
                IlBehaviour = this.battery.gameObject.AddComponent<ILBehaviour>();
            }

            IlBehaviour.UpdateEvent = OnUpdate;
            // this.updateKey = LTBY_Extend.Instance.StartTimer(()=>
            // {
            //     this.OnUpdate();
            // });
            LTBY_Event.OnGetConfig += LTBY_Event_OnGetConfig;
        }

        protected virtual void LTBY_Event_OnGetConfig()
        {
            SetLevel(this.level);
            SetRatio(this.ratio);
        }

        public virtual void SetRageShoot(bool flag)
        {
            this.rageShoot = flag;
            LTBY_BulletManager.Instance.SetRageSpout(this.chairId, flag);
        }

        public virtual void SetMultiShoot(bool flag)
        {
            this.multiShoot = flag;
            LTBY_BulletManager.Instance.SetWiderSpout(this.chairId, flag);
        }

        public virtual void SetLockShoot(bool flag)
        {
            this.lockShoot = flag;
            if (!flag)
            {
                LTBY_BulletManager.Instance.DestroyWaterSpout(this.chairId);
            }
        }
        public virtual void RobotShoot()
        {
            lockFish = null;
            isRobotAutoShoot = true;
        }
        public virtual void SetAutoShoot(bool flag)
        {
            Vector3 pos = new Vector2()
            {
                x = UnityEngine.Random.Range(0, 1136),
                y = UnityEngine.Random.Range(0, 640)
            };
            Vector3 worldPos = battery.position;

            float angles = Mathf.Atan2((pos.y - worldPos.y), (pos.x - worldPos.x)) * Mathf.Rad2Deg;
            //DebugHelper.LogError($"self angles:{angles - 90}");
            SetAngles(angles - 90);
        }

        public virtual void SetRobot(bool _isrobot)
        {
            this.isRobot = _isrobot;
        }
        public virtual bool IsRobot()
        {
            return this.isRobot;
        }
        public virtual void Hide()
        {
            if (!activeSelf) return;
            //DebugHelper.LogError($"{this.chairId}Hide");

            if (battery != null)
            {
                battery.gameObject.SetActive(false);
            }

            LTBY_Extend.Instance.StopTimer(this.updateKey);
            activeSelf = false;
        }

        public virtual void Show()
        {
            if (activeSelf) return;
            // DebugHelper.LogError($"{this.chairId}Show");

            if (battery != null)
            {
                battery.gameObject.SetActive(true);
            }

            activeSelf = true;
        }

        public virtual int GetLevel()
        {
            return this.level;
        }

        public virtual int GetRatio()
        {
            return this.ratio;
        }

        public virtual void SetLevel(int _level)
        {
            if (_level == 0 || _level == this.level) return;
            if (this.rageSmokeEffect)
            {
                LTBY_PoolManager.Instance.RemoveUiItem("LTBY_RageSmoke", rageSmokeEffect);
                rageSmokeEffect = null;
            }

            LTBY_Extend.Instance.StopTimer(rageSmokeTimerKey);
            rageSmokeTimerKey = 0;


            LTBY_BulletManager.Instance.DestroyWaterSpout(chairId);
            waterSpout = LTBY_BatteryManager.Instance.IsWaterSpoutBattery(_level) && lockShoot;
            if (battery != null)
            {
                LTBY_Extend.Destroy(battery.gameObject);
                battery = null;
            }
            IlBehaviour = null;

            this.level = _level;
            battery = LTBY_Extend.Instance.LoadPrefab($"LTBY_Battery{this.level}", parent);
            if (IlBehaviour == null)
            {
                IlBehaviour = this.battery.gameObject.AddComponent<ILBehaviour>();
            }
            if (BatteryConfig.Battery.ContainsKey(this.level))
            {
                BatteryData batteryData = BatteryConfig.Battery[this.level];
                battery.GetComponent<RectTransform>().pivot = batteryData.pivot;
                battery.localPosition = Vector3.zero;
            }
            IlBehaviour.UpdateEvent = OnUpdate;
            if (!activeSelf)
            {
                battery.gameObject.SetActive(false);
            }


            batteryAnimator = battery.GetComponent<Animator>();
            shootPos = battery.transform.FindChildDepth("ShootPos");
            if (isOtherside)
            {
                RotateRatioNode();
            }

            if (!LTBY_GameView.GameInstance.IsSelf(this.chairId)) return;
            LTBY_BatteryManager.Instance.CurrentLevel = level;
            EventTriggerHelper hepler = EventTriggerHelper.Get(battery.transform.FindChildDepth("Body").gameObject);
            hepler.onDown = (go, eventData) => LTBY_GameView.GameInstance.OpenSelectBattery();
        }

        public virtual void SetRatio(int _ratio)
        {
            if (_ratio == 0) return;

            this.ratio = _ratio;
            if (battery == null) return;
            TextMeshProUGUI num = battery.transform.FindChildDepth<TextMeshProUGUI>("Body/Ratio");
            num.enableAutoSizing = true;
            num.fontSizeMin = 1;
            num.fontSizeMax = 25;
            num.transform.localScale = Vector3.one * 0.8f;
            if (GameData.Instance.Config != null)
            {
                num.text = LTBY_BatteryManager.Instance.ChangeUnit(GameData.Instance.Config.bulletScore[this.level-1] * this.ratio);
            }
            Sequence sequence = DOTween.Sequence();
            Vector3 scale = num.transform.localScale;
            sequence.Append(num.transform.DOScale(new Vector3(0.8f + scale.x, 0.8f + scale.y), 0.1f).SetLink(num.gameObject));
            sequence.Append(num.transform.DOScale(new Vector3(-0.8f + scale.x, -0.8f + scale.y) + scale, 0.1f).SetLink(num.gameObject));
            sequence.SetLink(num.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);

            Transform effect = battery.FindChildDepth("Body/Effect");
            effect.gameObject.SetActive(false);
            effect.gameObject.SetActive(true);
        }

        protected virtual void OnUpdate()
        {
            if (battery == null) return;
            if (shootPosShow)
            {
                shootPosShowTime -= Time.deltaTime;
                if (shootPosShowTime <= 0)
                {
                    shootPosShow = false;
                    shootPos.gameObject.SetActive(shootPosShow);
                }
            }
            
            if (lockShoot && LTBY_BatteryManager.Instance.IsWaterSpoutBattery(level))
            {
                WaterSpoutLockUpdate();
            }
            else
            {
                waterSpout = false;
            }
            if (isRobot && isRobotAutoShoot)
            {
                LockUpdate();
            }
        }

        protected virtual void WaterSpoutLockUpdate()
        {
            FishClass fish = LTBY_FishManager.Instance.GetLockFish(chairId);
            waterSpout = fish != null;

            if (showWaterSpoutTime >= 0)
            {
                showWaterSpoutTime -= Time.deltaTime;
                LTBY_BulletManager.Instance.ShowWaterSpout(chairId, true);
            }
            else
            {
                LTBY_BulletManager.Instance.ShowWaterSpout(chairId, false);
            }
        }

        protected virtual void RotateRatioNode()
        {
            battery.FindChildDepth("Body/Ratio").Rotate(new Vector3(0, 0, 180));
        }

        public virtual void SetAngles(float angles)
        {
            angles = Mathf.Clamp(angles, -80, 80);
            shootAngles = angles;
            if (battery != null)
            {
                battery.localEulerAngles = new Vector3(0, 0, angles);
            }
        }

        public virtual void Destroy()
        {
            OnDestroy();
            LTBY_Extend.Instance.StopTimer(this.updateKey);
            LTBY_Event.OnGetConfig -= LTBY_Event_OnGetConfig;
        }

        public virtual float GetAngles()
        {
            return shootAngles;
        }

        protected virtual void ShootEffect()
        {
            batteryAnimator.SetTrigger($"shoot");
            shootPosShow = true;
            shootPos.gameObject.SetActive(shootPosShow);
            shootPosShowTime = 0.04f;

            if (!rageShoot || rageSmokeTimerKey != 0) return;
            if (rageSmokeEffect == null)
            {
                rageSmokeEffect = LTBY_PoolManager.Instance.GetUiItem("LTBY_RageSmoke", battery);
                rageSmokeEffect.localPosition = new Vector3(0, -30, 0);
            }

            rageSmokeEffect.gameObject.SetActive(true);
            rageSmokeTimerKey = LTBY_Extend.Instance.DelayRun(1.5f, ()=>
            {
                rageSmokeEffect?.gameObject.SetActive(false);
                LTBY_Extend.Instance.StopTimer(rageSmokeTimerKey);
                rageSmokeTimerKey = 0;
            });
        }

        protected virtual BulletClass CreateBullet(float offset, params object[] args)
        {
            Vector3 pos = Vector3.zero;
            float angle = 0;
            if (args.Length >= 1)
            {
                pos = (Vector3) args[0];
            }

            if (args.Length >= 2)
            {
                angle = (float) args[1];
            }

            float trueOffset = isOtherside ? -offset : offset;
            bool isLockAngle = LTBY_FishManager.Instance.GetLockFish(chairId) != null && lockShoot;

            Vector3 _shootPos = args.Length >= 1
                ? pos
                : LTBY_BatteryManager.Instance.GetShootPosFromOffset(trueOffset, this.shootPos.position, shootAngles);
            float shootAngle = args.Length >= 2
                ? angle
                : LTBY_BatteryManager.Instance.GetShootAngleFromOffset(offset, this.shootAngles, isLockAngle);

            BulletClass bullet = LTBY_BulletManager.Instance.CreateBullet(this.chairId, this.level, _shootPos,
                this.isOtherside ? (shootAngle + 180) : shootAngle);
            bullet.SetRatio(this.ratio);
            return bullet;
        }

        public virtual BulletClass Shoot(params object[] args)
        {
            if (!activeSelf) return null;

            if (waterSpout)
            {
                ShootWaterSpout();
            }
            else
            {
                ShootBullet();
            }

            return null;
        }

        protected virtual void ShootWaterSpout()
        {
            int _chairId = this.chairId;
            int _level = this.level;
            var _ratio = this.ratio;
            if (LTBY_GameView.GameInstance.IsSelf(_chairId))
            {
                var _waterSpout = LTBY_BulletManager.Instance.GetWaterSpout(_chairId);
                if (_waterSpout == null)
                {
                    _waterSpout =
                        LTBY_BulletManager.Instance.CreateWaterSpout(_chairId, _level, this.rageShoot, this.multiShoot);
                }
                _waterSpout.SetRatio(_ratio);

                FishClass fish = LTBY_FishManager.Instance.GetLockFish(this.chairId);

                if (fish == null) return;
                var bulletCount = this.multiShoot ? 3 : 1;
                if (this.shootInterval <= 0 && LTBY_BatteryManager.Instance.GetCanShoot())
                {
                    if (this.multiShoot)
                    {
                        List<int> bulletInfo = new List<int>();
                        for (int i = 0; i < bulletCount; i++)
                        {
                            int id = LTBY_BulletManager.Instance.AllocateBulletId();
                            bulletInfo.Add(id);

                            LTBY_Struct.PlayerShoot playerShoot = new LTBY_Struct.PlayerShoot()
                            {
                                bet = GameData.Instance.Config.bulletScore[level - 1] * ratio,
                                bulletId = id,
                                gunLevel = (byte) (this.ratio - 1),
                                gunGrade = (byte) (this.level - 1),
                                x = this.shootAngles,
                                wChairId = this.chairId
                            };
                            LTBY_Network.Instance.Send(LTBY_Network.SUB_C_PRESS_SHOOT, playerShoot.Buffer);
                        }

                        //发送消息
                        //GC.NetworkRequest.Request("CSMultiShoot",{
                        //    ratio = this.ratio,
                        //	bullet_type = GC.PropConfig.Bullet.id,
                        //	angle = this.shootAngles;
                        //    bullets = bulletInfo,
                        //});
                        IlBehaviour.StartCoroutine(ToolHelper.DelayCall(0.3f, ()=>
                        {
                            for (int i = 0; i < bulletInfo.Count; i++)
                            {
                                var bullet = LTBY_BulletManager.Instance.GetPlayerBullet(chairId, bulletInfo[i]);
                                if (bullet == null) continue;
                                fish.OnHit(this.chairId, bullet);
                            }
                        }));
                    }
                    else
                    {
                        // int bulletId = LTBY_BulletManager.Instance.AllocateBulletId();
                        //发送消息

                        LTBY_Struct.PlayerShoot playerShoot = new LTBY_Struct.PlayerShoot()
                        {
                            bet = GameData.Instance.Config.bulletScore[level - 1] * ratio,
                            bulletId = _waterSpout.id,
                            gunLevel = (byte) (this.ratio - 1),
                            gunGrade = (byte) (this.level - 1),
                            x = this.shootAngles,
                            wChairId = this.chairId
                        };
                        LTBY_Network.Instance.Send(LTBY_Network.SUB_C_PRESS_SHOOT, playerShoot.Buffer);
                        //           GC.NetworkRequest.Request("CSUserShoot",{
                        //               angle = this.shootAngles,
                        //	bullet_id = bulletId,
                        //	ratio = this.ratio,
                        //	bullet_type = GC.PropConfig.Bullet.id,
                        //});
                        IlBehaviour.StartCoroutine(ToolHelper.DelayCall(0.3f, ()=>
                        {
                            fish.OnHit(this.chairId, _waterSpout);
                        }));
                    }

                    LTBY_GameView.GameInstance.MinusScore(this.chairId,
                        GameData.Instance.Config.bulletScore[level - 1] * ratio * bulletCount);
                    LTBY_DataReport.Instance.Cost("子弹", GameData.Instance.Config.bulletScore[level - 1] * ratio);
                }

                LTBY_Audio.Instance.Play(this.multiShoot ? SoundConfig.WaterSpoutWide : SoundConfig.WaterSpoutSmall);
                this.showWaterSpoutTime = LTBY_BatteryManager.Instance.ShowWaterSpoutTime;
            }
            else
            {
                var _waterSpout = LTBY_BulletManager.Instance.GetWaterSpout(_chairId);
                if (_waterSpout == null)
                {
                    _waterSpout =
                        LTBY_BulletManager.Instance.CreateWaterSpout(_chairId, _level, this.rageShoot, this.multiShoot);
                }

                this.showWaterSpoutTime = LTBY_BatteryManager.Instance.ShowWaterSpoutTime;
            }
        }

        protected virtual void ShootBullet()
        {
            //这里是为了限制当同桌龙帝炮锁定时，子弹包锁定发射有延迟，导致进来这里发射出了普通子弹
            if (this.multiShoot)
            {
                this.MultiShoot();
            }
            else
            {
                this.NormalShoot();
            }
        }

        protected virtual void NormalShoot()
        {
            if (LTBY_GameView.GameInstance.IsSelf(this.chairId) || this.isRobot)
            {
                if (!LTBY_BulletManager.Instance.CanCreateBullet(this.chairId) ||
                    !LTBY_GameView.GameInstance.MinusScore(this.chairId, GameData.Instance.Config.bulletScore[level-1] * ratio)) return;
                if (this.shootPos == null) return;
                BulletClass bullet = LTBY_BulletManager.Instance.CreateBullet(this.chairId, this.level,
                    this.shootPos.position, this.isOtherside ? this.shootAngles + 180 : this.shootAngles);
                bullet.SetRatio(this.ratio);
                //TODO 发送发射子弹消息

                //     GC.NetworkRequest.Request("CSUserShoot",{
                //	angle = this.shootAngles,
                //	bullet_id = bullet.id,
                //	ratio = this.ratio,
                //	bullet_type = GC.PropConfig.Bullet.id,
                //});
                if (GameData.Instance.Config == null) return;
                LTBY_Struct.PlayerShoot playerShoot = new LTBY_Struct.PlayerShoot()
                {
                    bet = GameData.Instance.Config.bulletScore[level - 1] * ratio,
                    bulletId = bullet.id,
                    gunLevel = (byte)(this.ratio - 1),
                    gunGrade = (byte)(this.level - 1),
                    wChairId = this.chairId,
                    x = this.shootAngles
                };
                
                LTBY_Network.Instance.Send(LTBY_Network.SUB_C_PRESS_SHOOT, playerShoot.Buffer);
                if (!this.isRobot)
                {
                    LTBY_Audio.Instance.Play(SoundConfig.Shoot);
                }
                ShootEffect();

                LTBY_DataReport.Instance.Cost("子弹", this.ratio);
            }
            else
            {
                if (this.rageShoot)
                {
                    if (Time.time - this.lastShootTime == 0)
                    {
                        int key = LTBY_Extend.Instance.DelayRun(0.1f, ()=>
                        {
                            if (LTBY_BulletManager.Instance.CanCreateBullet(this.chairId))
                            {
                                if (this.shootPos == null) return;
                                LTBY_BulletManager.Instance.CreateBullet(this.chairId, this.level,
                                    this.shootPos.position,
                                    this.isOtherside ? this.shootAngles + 180 : this.shootAngles);
                            }
                        });
                        timerKey.Add(key);
                    }
                    else if (LTBY_BulletManager.Instance.CanCreateBullet(this.chairId))
                    {
                        if (this.shootPos == null) return;
                        LTBY_BulletManager.Instance.CreateBullet(this.chairId, this.level, this.shootPos.position,
                            this.isOtherside ? this.shootAngles + 180 : this.shootAngles);
                    }

                    this.lastShootTime = Time.time;
                }
                else if (LTBY_BulletManager.Instance.CanCreateBullet(this.chairId))
                {
                    if (this.shootPos == null) return;
                    LTBY_BulletManager.Instance.CreateBullet(this.chairId, this.level, this.shootPos.position,
                        this.isOtherside ? this.shootAngles + 180 : this.shootAngles);
                }

                ShootEffect();
            }
        }

        protected virtual void MultiShoot()
        {
            if (LTBY_GameView.GameInstance.IsSelf(this.chairId))
            {
                if (!LTBY_BulletManager.Instance.CanCreateBullet(this.chairId, 3)) return;
                if (LTBY_GameView.GameInstance.GetUserScore() - this.ratio * 3 >= 0)
                {
                    List<int> bulletInfo = new List<int>();
                    float angle = 0;
                    for (int i = -1; i < 2; i++)
                    {
                        BulletClass bullet = CreateBullet(i);
                        if (i == 0)
                        {
                            angle = bullet.bulletAngles.z;
                        }

                        bulletInfo.Add(bullet.id);
                    }

                    LTBY_GameView.GameInstance.MinusScore(this.chairId, this.ratio * 3);
                    //发送multi发射消息
                    //            GC.NetworkRequest.Request("CSMultiShoot",{
                    //            ratio = this.ratio,
                    //	bullet_type = GC.PropConfig.Bullet.id,
                    //	angle = angle;
                    //            bullets = bulletInfo,
                    //});

                    LTBY_Audio.Instance.Play(SoundConfig.Shoot);
                    ShootEffect();

                    LTBY_DataReport.Instance.Cost("子弹", this.ratio * 3);
                }
                else
                {
                    LTBY_GameView.GameInstance.MoneyInsufficient();
                }
            }

            else
            {
                if (this.rageShoot)
                {
                    if (Time.time - this.lastShootTime == 0)
                    {
                        int key = LTBY_Extend.Instance.DelayRun(0.1f, ()=>
                        {
                            if (!LTBY_BulletManager.Instance.CanCreateBullet(this.chairId, 3)) return;
                            for (int i = -1; i < 2; i++)
                            {
                                BulletClass bullet = CreateBullet(i);
                            }
                        });
                        timerKey.Add(key);
                    }
                    else if (LTBY_BulletManager.Instance.CanCreateBullet(this.chairId, 3))
                    {
                        for (int i = -1; i < 2; i++)
                        {
                            BulletClass bullet = CreateBullet(i);
                        }
                    }

                    this.lastShootTime = Time.time;
                }
                else if (LTBY_BulletManager.Instance.CanCreateBullet(this.chairId, 3))
                {
                    for (int i = -1; i < 2; i++)
                    {
                        BulletClass bullet = CreateBullet(i);
                    }
                }

                ShootEffect();
            }
        }

        protected virtual void OnDestroy()
        {
            isRobot = false;
            isRobotAutoShoot = false;
            for (int i = timerKey.Count-1; i>=0 ; i--)
            {
                LTBY_Extend.Instance.StopTimer(timerKey[i]);
            }

            this.timerKey.Clear();
            for (int i = actionKey.Count - 1; i >= 0; i--)
            {
                LTBY_Extend.Instance.StopAction(actionKey[i]);
            }

            this.actionKey.Clear();
            if (IlBehaviour != null)
            {
                IlBehaviour.UpdateEvent = null;
                LTBY_Extend.Destroy(IlBehaviour);
                IlBehaviour = null;
            }

            if (this.battery != null)
            {
                LTBY_Extend.Destroy(this.battery.gameObject);
                this.battery = null;
            }

            if (this.rageSmokeEffect != null)
            {
                LTBY_PoolManager.Instance.RemoveUiItem("LTBY_RageSmoke", this.rageSmokeEffect);
                this.rageSmokeEffect = null;
            }

            LTBY_Extend.Instance.StopTimer(this.rageSmokeTimerKey);
            this.rageSmokeTimerKey = 0;
        }

        protected virtual void InitTip()
        {
        }

        protected virtual void HideTip()
        {
        }

        protected virtual void SettleAccount()
        {
        }

        protected virtual void MinusTime(float time)
        {
        }

        protected virtual bool LockUpdate()
        {
            if (lockFish == null || lockFish.fish == null || lockFish.isDead || !lockFish.inScreen)
            {
                lockFish = null;
                List<short> list = LTBY_FishManager.Instance.GetInScreenFishIdList();
                if (list.Count <= 0) return false;
                lockFish = LTBY_FishManager.Instance.GetFish(list[0]);
                if (lockFish == null) return false;
            }

            Vector3 pos = lockFish.GetWorldPos();
            Vector3 worldPos = battery.position;
            float angles = 0;
            if (LTBY_GameView.GameInstance.CheckIsOtherSide(chairId) != LTBY_GameView.GameInstance.CheckIsOtherSide(LTBY_GameView.GameInstance.chairId))
            {
                angles = Mathf.Atan2((-pos.y + worldPos.y), (-pos.x + worldPos.x)) * Mathf.Rad2Deg;
            }
            else
            {
                angles = Mathf.Atan2((pos.y - worldPos.y), (pos.x - worldPos.x)) * Mathf.Rad2Deg;
            }
            //DebugHelper.LogError($"self angles:{(angles - 90)}");
            SetAngles(angles - 90);

            if (shootInterval <= 0)
            {
                Shoot();
                shootInterval = 0.16f;
                if (rageShoot)
                {
                    shootInterval = 0.1f;
                }
            }

            shootInterval -= Time.deltaTime;
            return true;
        }

        protected virtual void ShootUpdate()
        {
        }
    }

    /// <summary>
    /// 自己的炮台才会有的接口
    /// </summary>
    public class SelfBatteryClass : BatteryClass
    {
        public override void OnCreate(int _chairId, Transform _parent)
        {
            base.OnCreate(_chairId, _parent);

            this.shootInterval = 0;
            this.cam = LTBYEntry.Instance.GetUiCam();
        }

        protected override bool LockUpdate()
        {
            FishClass fish = LTBY_FishManager.Instance.GetLockFish(chairId);
            if (fish == null) return false;
            Vector3 pos = fish.GetWorldPos();
            Vector3 worldPos = battery.position;

            float angles = Mathf.Atan2((pos.y - worldPos.y), (pos.x - worldPos.x)) * Mathf.Rad2Deg;
            //DebugHelper.LogError($"self angles:{(angles - 90)}");
            SetAngles(angles - 90);

            if (shootInterval <= 0 && LTBY_BatteryManager.Instance.GetCanShoot())
            {
                Shoot();
                shootInterval = 0.16f;
                if (rageShoot)
                {
                    shootInterval = 0.1f;
                }
            }

            shootInterval -= Time.deltaTime;
            return true;
        }

        protected override void ShootUpdate()
        {
            if (LTBY_BatteryManager.Instance.Press || LTBY_BatteryManager.Instance.AutoShoot)
            {
                //DebugHelper.Log("射击");
                if (LTBY_BatteryManager.Instance.PressEventData != null)
                {
                    Vector3 pos = cam.ScreenToWorldPoint(LTBY_BatteryManager.Instance.PressEventData.position);
                    Vector3 worldPos = battery.position;

                    float angles = Mathf.Atan2((pos.y - worldPos.y), (pos.x - worldPos.x)) * Mathf.Rad2Deg;
                    //DebugHelper.LogError($"self angles:{angles - 90}");
                    SetAngles(angles - 90);
                }

                if (shootInterval <= 0 && LTBY_BatteryManager.Instance.GetCanShoot())
                {
                    Shoot();
                    shootInterval = 0.16f;
                    if (rageShoot)
                    {
                        shootInterval = 0.1f;
                    }
                }
            }

            shootInterval -= Time.deltaTime;
        }

        protected override void OnUpdate()
        {
            if (battery == null) return;
            base.OnUpdate();
            if (!LockUpdate())
            {
                ShootUpdate();
            }
        }
    }

    /// <summary>
    /// 电磁炮
    /// </summary>
    public class ElectricBatteryClass : BatteryClass
    {
        public bool isShoot;

        public void OnCreate(int _chairId, int _ratio, Transform _parent)
        {
            this.chairId = _chairId;

            this.parent = _parent;

            this.cam = LTBYEntry.Instance.GetUiCam();

            this.ratio = _ratio;

            this.actionKey = new List<int>();

            this.timerKey = new List<int>();

            this.alreadyPress = false;

            this.shootAngles = 0;

            this.isOtherside = LTBY_GameView.GameInstance.CheckIsOtherSide(this.chairId);

            this.isShoot = false;

            this.battery = LTBY_Extend.Instance.LoadPrefab("LTBY_BatteryElectric", this.parent);
            Text ratiotxt = this.battery.FindChildDepth<Text>("Ratio");
            if (ratiotxt != null) ratiotxt.text = LTBY_BatteryManager.Instance.ChangeUnit(this.ratio);
            else
                this.battery.FindChildDepth<TextMeshProUGUI>("Ratio").text =
                    LTBY_BatteryManager.Instance.ChangeUnit(this.ratio);


            this.shootPos = this.battery.FindChildDepth("ShootPos");
            this.shootPos.localScale = new Vector3(0, 2, 2);

            if (LTBY_GameView.GameInstance.IsSelf(this.chairId))
            {
                this.shootPos.gameObject.SetActive(true);
                Sequence sequence = DOTween.Sequence();
                sequence.SetLink(battery.gameObject);
                sequence.Append(this.battery.DOBlendableScaleBy(new Vector3(0.5f, 0.5f, 1), 0.2f).SetEase(Ease.Linear).SetLink(battery.gameObject));
                sequence.Append(
                    this.battery.DOBlendableScaleBy(new Vector3(-0.5f, -0.5f, 1), 0.2f).SetEase(Ease.Linear).SetLink(battery.gameObject));
                sequence.OnKill(delegate()
                {
                    this.shootPos.localScale = new Vector3(0, 2, 2);
                    Sequence _sequence = DOTween.Sequence();
                    _sequence.SetLink(shootPos.gameObject);
                    _sequence.Append(shootPos.DOScale(2, 0.3f).SetEase(Ease.Linear).SetLink(shootPos.gameObject));
                    Sequence _sequence1 = DOTween.Sequence();
                    _sequence.Append(_sequence1);
                    Image img = shootPos.GetComponent<Image>();
                    _sequence1.Append(img.DOFade(30f / 255, 1).SetEase(Ease.Linear).SetLink(img.gameObject));
                    _sequence1.Append(img.DOFade(255f / 255, 1).SetEase(Ease.Linear).SetLink(img.gameObject));
                    _sequence1.SetLoops(10).SetLink(img.gameObject);
                    int _key = LTBY_Extend.Instance.RunAction(_sequence);
                    actionKey.Add(_key);
                });
                int key = LTBY_Extend.Instance.RunAction(sequence);
                actionKey.Add(key);
                LTBY_GameView.GameInstance.SetAdjustRatioEnable(this.chairId, false);

                LTBY_Audio.Instance.Play(SoundConfig.ChangeSpecialBattery);
                LTBY_Audio.Instance.Play(SoundConfig.ElectricGet);
            }
            else
            {
                this.shootPos.gameObject.SetActive(false);
            }

            InitTip();
            if (IlBehaviour == null)
            {
                IlBehaviour = this.battery.gameObject.AddComponent<ILBehaviour>();
            }

            IlBehaviour.UpdateEvent = OnUpdate;
            // this.updateKey = LTBY_Extend.Instance.StartTimer(() =>
            // {
            //     this.OnUpdate();
            // });
        }

        protected override void HideTip()
        {
            tipNode.gameObject.SetActive(false);
        }

        protected override void InitTip()
        {
            this.tipNode = LTBY_Extend.Instance.LoadPrefab("LTBY_ElectricTip", this.parent);
            this.tipNode.localPosition = new Vector3(0, 135, 0);

            this.tipImage = this.tipNode.FindChildDepth("Image");
            Sequence sequence = DOTween.Sequence();
            sequence.Append(tipImage.DOBlendableScaleBy(new Vector3(1, 1, 1), 0.1f).SetLink(tipImage.gameObject).SetEase(Ease.Linear));
            sequence.Append(tipImage.DOBlendableScaleBy(new Vector3(-1, -1, 1), 0.2f).SetLink(tipImage.gameObject).SetEase(Ease.Linear));
            sequence.SetLink(tipImage.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);

            if (LTBY_GameView.GameInstance.IsSelf(this.chairId))
            {
                this.tipImage.FindChildDepth<Text>("Text").text = BatteryConfig.ShootCountdownText;
                this.countdownTime = 30f;
                this.tipCountdown = this.tipImage.FindChildDepth<Text>("Countdown");
                this.tipCountdown.text = $"{this.countdownTime}{BatteryConfig.Second}";
            }
            else
            {
                this.tipImage.FindChildDepth("Text").gameObject.SetActive(false);
                this.tipImage.FindChildDepth("Countdown").gameObject.SetActive(false);

                if (this.isOtherside)
                {
                    this.tipNode.localEulerAngles = new Vector3(0, 0, 180);
                }
            }
        }

        public override BulletClass Shoot(params object[] args)
        {
            HideTip();

            this.isShoot = true;

            this.shootPos.gameObject.SetActive(false);

            BulletClass bullet = LTBY_BulletManager.Instance.CreateBulletElectric(this.chairId, this.shootPos.position,
                this.isOtherside ? this.shootAngles + 180 : this.shootAngles);

            if (!LTBY_GameView.GameInstance.IsSelf(this.chairId)) return bullet;
            LTBY_Struct.PlayerShoot playerShoot = new LTBY_Struct.PlayerShoot()
            {
                x = this.shootAngles,
                wChairId = this.chairId,
                bulletId = bullet.id,
                bet = GameData.Instance.Config.bulletScore[level-1] * ratio,
                gunLevel = (byte)(this.ratio-1),
                gunGrade = (byte)(this.level-1)
            };
            LTBY_Network.Instance.Send(LTBY_Network.SUB_C_PRESS_SHOOT, playerShoot.Buffer);
            //      GC.NetworkRequest.Request("CSUserShoot",{
            //              angle = this.shootAngles,
            //	bullet_id = bullet.id,
            //	ratio = 0,
            //	bullet_type = GC.PropConfig.Electric1.id,
            //});

            //          GC.NetworkRequest.Request("CSSyncPropInfo",{
            //              id = GC.PropConfig.Electric1.id,
            //	ratio = 0,
            //	angle = this.shootAngles,
            //	x = 0,
            //	y = 0,
            //	status = 1,
            //});

            LTBY_Audio.Instance.Play(SoundConfig.ElectricShoot);
            return bullet;
        }

        public override void SetAngles(float angles)
        {
            angles = Mathf.Clamp(angles, -80, 80);
            battery.localEulerAngles = new Vector3(0, 0, angles);
            shootAngles = angles;
        }

        protected override void SettleAccount()
        {
            int key = LTBY_Extend.Instance.DelayRun(2f, ()=>
            {
                LTBY_BatteryManager.Instance.DestroyElectric(this.chairId);
                LTBY_BatteryManager.Instance.ShowBattery(this.chairId);

                var effect = LTBY_EffectManager.Instance.GetElectric(this.chairId);
                effect?.SettleAccount();
            });
            timerKey.Add(key);
        }

        protected override void MinusTime(float time)
        {
            countdownTime -= time;
        }

        protected override void OnUpdate()
        {
            base.OnUpdate();
            if (!LTBY_GameView.GameInstance.IsPlayerInRoom(this.chairId)) return;

            if (this.countdownTime <= 0)
            {
                this.countdownTime = 0;
                this.tipCountdown.text = $"{Mathf.Floor(this.countdownTime)}{BatteryConfig.Second}";
                Shoot();
            }
            else
            {
                this.countdownTime -= Time.deltaTime;
                this.tipCountdown.text = $"{Mathf.Floor(this.countdownTime)}{BatteryConfig.Second}";

                if (LTBY_BatteryManager.Instance.Press)
                {
                    if (!this.alreadyPress)
                    {
                        this.alreadyPress = true;
                    }

                    Vector3 pos = this.cam.ScreenToWorldPoint(LTBY_BatteryManager.Instance.PressEventData.position);
                    Vector3 worldPos = this.battery.position;
                    float angles = Mathf.Atan2((pos.y - worldPos.y), (pos.x - worldPos.x)) * Mathf.Rad2Deg;
                    SetAngles(angles - 90);
                }
                else if (this.alreadyPress)
                {
                    Shoot();
                }
            }
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            if (IlBehaviour != null)
            {
                IlBehaviour.UpdateEvent = null;
                LTBY_Extend.Destroy(IlBehaviour);
                IlBehaviour = null;
            }

            if (this.battery != null)
            {
                UnityEngine.Object.Destroy(this.battery.gameObject);
                this.battery = null;
            }

            if (this.tipNode != null)
            {
                UnityEngine.Object.Destroy(this.tipNode.gameObject);
                this.tipNode = null;
            }

            for (int i = 0; i < actionKey.Count; i++)
            {
                LTBY_Extend.Instance.StopAction(actionKey[i]);
            }

            actionKey.Clear();
            for (int i = 0; i < timerKey.Count; i++)
            {
                LTBY_Extend.Instance.StopTimer(timerKey[i]);
            }

            timerKey.Clear();

            LTBY_GameView.GameInstance.SetAdjustRatioEnable(this.chairId, true);
        }
    }

    /// <summary>
    /// 电钻炮
    /// </summary>
    public class DrillBatteryClass : BatteryClass
    {
        public bool isShoot;
        private Transform ratioNode;

        public void OnCreate(int _chairId, int _ratio, Transform _parent)
        {
            this.chairId = _chairId;

            this.parent = _parent;

            this.cam = LTBYEntry.Instance.GetUiCam();

            this.ratio = _ratio;

            this.actionKey = new List<int>();

            this.timerKey = new List<int>();

            this.isOtherside = LTBY_GameView.GameInstance.CheckIsOtherSide(this.chairId);

            this.alreadyPress = false;

            this.shootAngles = 0;

            this.isShoot = false;

            this.battery = LTBY_Extend.Instance.LoadPrefab("LTBY_BatteryDrill", this.parent);

            this.ratioNode = LTBY_Extend.Instance.LoadPrefab("LTBY_DrillRatio", this.parent);
            this.ratioNode.FindChildDepth<Text>("Ratio").text = LTBY_BatteryManager.Instance.ChangeUnit(this.ratio);

            this.shootPos = this.battery.FindChildDepth("ShootPos");

            if (LTBY_GameView.GameInstance.IsSelf(this.chairId))
            {
                Sequence sequence = DOTween.Sequence();
                sequence.Append(this.battery.DOBlendableScaleBy(new Vector3(0.5f, 0.5f, 1), 0.2f).SetLink(battery.gameObject).SetEase(Ease.Linear));
                sequence.Append(
                    this.battery.DOBlendableScaleBy(new Vector3(-0.5f, -0.5f, 1), 0.2f).SetLink(battery.gameObject).SetEase(Ease.Linear));
                sequence.SetLink(battery.gameObject);
                int key = LTBY_Extend.Instance.RunAction(sequence);
                actionKey.Add(key);

                LTBY_GameView.GameInstance.SetAdjustRatioEnable(this.chairId, false);

                LTBY_Audio.Instance.Play(SoundConfig.ChangeSpecialBattery);

                LTBY_Audio.Instance.Play(SoundConfig.DrillGet);
            }

            InitTip();
            if (IlBehaviour == null)
            {
                IlBehaviour = this.battery.gameObject.AddComponent<ILBehaviour>();
            }

            IlBehaviour.UpdateEvent = OnUpdate;
            // this.updateKey = LTBY_Extend.Instance.StartTimer(() =>
            // {
            //     this.OnUpdate();
            // });
        }

        protected override void HideTip()
        {
            this.tipNode.gameObject.SetActive(false);
        }

        protected override void InitTip()
        {
            this.tipNode = LTBY_Extend.Instance.LoadPrefab("LTBY_DrillTip", this.parent);
            this.tipNode.localPosition = new Vector3(0, 135, 0);

            this.tipImage = this.tipNode.FindChildDepth("Image");

            Sequence sequence = DOTween.Sequence();
            sequence.Append(tipImage.DOBlendableScaleBy(new Vector3(1, 1, 1), 0.1f).SetLink(tipImage.gameObject).SetEase(Ease.Linear));
            sequence.Append(tipImage.DOBlendableScaleBy(new Vector3(-1, -1, 1), 0.1f).SetLink(tipImage.gameObject).SetEase(Ease.Linear));
            sequence.SetLink(tipImage.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);

            if (LTBY_GameView.GameInstance.IsSelf(this.chairId))
            {
                this.tipImage.FindChildDepth<Text>("Text").text = BatteryConfig.ShootCountdownText;
                this.countdownTime = 30;
                this.tipCountdown = this.tipImage.FindChildDepth<Text>("Countdown");
                this.tipCountdown.text = $"{this.countdownTime}{BatteryConfig.Second}";
                this.ratioNode.localPosition = new Vector3(0, 10, 0);
            }
            else
            {
                this.tipImage.FindChildDepth("Text").gameObject.SetActive(false);
                this.tipImage.FindChildDepth("Countdown").gameObject.SetActive(false);

                if (this.isOtherside)
                {
                    this.tipNode.localEulerAngles = new Vector3(0, 0, 180);

                    this.ratioNode.localEulerAngles = new Vector3(0, 0, 180);
                    this.ratioNode.localPosition = new Vector3(0, 5, 0);
                }
                else
                {
                    this.ratioNode.localPosition = new Vector3(0, 10, 0);
                }
            }
        }

        protected override void SettleAccount()
        {
            int key = LTBY_Extend.Instance.DelayRun(2f, ()=>
            {
                LTBY_BatteryManager.Instance.DestroyDrill(this.chairId);
                LTBY_BatteryManager.Instance.ShowBattery(this.chairId);

                EffectClass effect = LTBY_EffectManager.Instance.GetDrill(this.chairId);
                effect?.SettleAccount();
            });
            timerKey.Add(key);
        }

        public void SetAngles(BatteryClass batteryClass, object p)
        {
        }


        public override BulletClass Shoot(params object[] args)
        {
            HideTip();

            this.isShoot = true;

            this.battery.gameObject.SetActive(false);

            BulletClass bullet = LTBY_BulletManager.Instance.CreateBulletDrill(this.chairId, this.shootPos.position,
                this.isOtherside ? this.shootAngles + 180 : this.shootAngles);
            if (!LTBY_GameView.GameInstance.IsSelf(this.chairId)) return bullet;
            LTBY_Struct.PlayerShoot playerShoot = new LTBY_Struct.PlayerShoot()
            {
                x = this.shootAngles,
                wChairId = this.chairId,
                bulletId = bullet.id,
                bet = GameData.Instance.Config.bulletScore[level-1] * ratio,
                gunLevel = (byte)(this.ratio-1),
                gunGrade = (byte)(this.level-1)
            };
            LTBY_Network.Instance.Send(LTBY_Network.SUB_C_PRESS_SHOOT, playerShoot.Buffer);
            //      GC.NetworkRequest.Request("CSUserShoot",{
            //              angle = this.shootAngles,
            //	bullet_id = bullet.id,
            //	ratio = 0,
            //	bullet_type = GC.PropConfig.Drill1.id,
            //});

            //          GC.NetworkRequest.Request("CSSyncPropInfo",{
            //              id = GC.PropConfig.Drill1.id,
            //	ratio = 0,
            //	angle = this.shootAngles,
            //	x = this.shootPos.position.x,
            //	y = this.shootPos.position.y,
            //	status = 1,
            //});

            LTBY_Audio.Instance.Play(SoundConfig.DrillShoot);
            return bullet;
        }

        public override void SetAngles(float angles)
        {
            angles = Mathf.Clamp(angles, -80, 80);
            this.battery.localEulerAngles = new Vector3(0, 0, angles);
            this.shootAngles = angles;
        }

        protected override void MinusTime(float time)
        {
            this.countdownTime -= time;
        }

        protected override void OnUpdate()
        {
            base.OnUpdate();
            if (!LTBY_GameView.GameInstance.IsPlayerInRoom(this.chairId)) return;

            if (this.countdownTime <= 0)
            {
                this.countdownTime = 0;
                this.tipCountdown.text = $"{Mathf.Floor(this.countdownTime)}{BatteryConfig.Second}";
                Shoot();
            }
            else
            {
                this.countdownTime -= Time.deltaTime;
                this.tipCountdown.text = $"{Math.Floor(this.countdownTime)}{BatteryConfig.Second}";
                if (LTBY_BatteryManager.Instance.Press)
                {
                    if (!this.alreadyPress)
                    {
                        this.alreadyPress = true;
                    }

                    Vector3 pos = this.cam.ScreenToWorldPoint(LTBY_BatteryManager.Instance.PressEventData.position);
                    Vector3 worldPos = this.battery.position;

                    float angles = Mathf.Atan2((pos.y - worldPos.y), (pos.x - worldPos.x)) * Mathf.Rad2Deg;

                    SetAngles(angles - 90);
                }
                else if (this.alreadyPress)
                {
                    Shoot();
                }
            }
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            if (IlBehaviour != null)
            {
                IlBehaviour.UpdateEvent = null;
                LTBY_Extend.Destroy(IlBehaviour);
                IlBehaviour = null;
            }

            for (int i = 0; i < actionKey.Count; i++)
            {
                LTBY_Extend.Instance.StopAction(actionKey[i]);
            }

            actionKey.Clear();

            for (int i = 0; i < timerKey.Count; i++)
            {
                LTBY_Extend.Instance.StopTimer(timerKey[i]);
            }

            timerKey.Clear();

            if (this.battery != null)
            {
                LTBY_Extend.Destroy(this.battery.gameObject);
                this.battery = null;
            }

            if (this.ratioNode != null)
            {
                LTBY_Extend.Destroy(this.ratioNode.gameObject);
                this.ratioNode = null;
            }

            if (this.tipNode != null)
            {
                LTBY_Extend.Destroy(this.tipNode.gameObject);
                this.tipNode = null;
            }

            LTBY_GameView.GameInstance.SetAdjustRatioEnable(this.chairId, true);
        }
    }

    /// <summary>
    /// 弹头
    /// </summary>
    public class MissileBatteryClass : BatteryClass
    {
        private int propId;
        private bool isShoot;

        public void OnCreate(int _chairId, int _propId, Transform _parent)
        {
            this.chairId = _chairId;

            this.parent = _parent;

            this.cam = LTBYEntry.Instance.GetUiCam();

            this.propId = _propId;

            this.actionKey = new List<int>();

            this.timerKey = new List<int>();

            this.isOtherside = LTBY_GameView.GameInstance.CheckIsOtherSide(this.chairId);

            this.alreadyPress = false;

            this.shootAngles = 0;

            this.isShoot = false;

            this.battery = LTBY_Extend.Instance.LoadPrefab("LTBY_BatteryMissile", this.parent);

            Image image = this.battery.FindChildDepth<Image>("Image");


            DropItemData config = EffectConfig.DropItem["Missile"];
            image.sprite = LTBY_Extend.Instance.LoadSprite(config.imageBundleName, config.imageName[this.propId]);

            this.shootPos = this.battery.FindChildDepth("ShootPos");

            if (LTBY_GameView.GameInstance.IsSelf(this.chairId))
            {
                Sequence sequence = DOTween.Sequence();
                sequence.Append(battery.DOBlendableScaleBy(new Vector3(0.5f, 0.5f, 1), 0.2f).SetEase(Ease.Linear).SetLink(battery.gameObject));
                sequence.Append(battery.DOBlendableScaleBy(new Vector3(-0.5f, -0.5f, 1), 0.2f).SetEase(Ease.Linear).SetLink(battery.gameObject));
                sequence.SetLink(battery.gameObject);
                int key = LTBY_Extend.Instance.RunAction(sequence);
                actionKey.Add(key);
                LTBY_GameView.GameInstance.SetAdjustRatioEnable(this.chairId, false);

                LTBY_Audio.Instance.Play(SoundConfig.ChangeSpecialBattery);
            }

            InitTip();
            if (IlBehaviour == null)
            {
                IlBehaviour = this.battery.gameObject.AddComponent<ILBehaviour>();
            }

            IlBehaviour.UpdateEvent = OnUpdate;
            // this.updateKey = LTBY_Extend.Instance.StartTimer(() =>
            // {
            //     this.OnUpdate();
            // });
        }

        protected override void HideTip()
        {
            this.tipNode.gameObject.SetActive(false);
        }

        protected override void InitTip()
        {
            this.tipNode = LTBY_Extend.Instance.LoadPrefab("LTBY_MissileTip", this.parent);
            this.tipNode.FindChildDepth<Text>("Image/Text").text = BatteryConfig.MissileTip1;
            this.tipNode.localPosition = new Vector3(0, 135, 0);

            this.tipImage = this.tipNode.FindChildDepth("Image");

            Sequence sequence = DOTween.Sequence();
            sequence.Append(battery.DOBlendableScaleBy(new Vector3(1f, 1f, 1), 0.1f).SetEase(Ease.Linear).SetLink(battery.gameObject));
            sequence.Append(battery.DOBlendableScaleBy(new Vector3(-1f, -1f, 1), 0.2f).SetEase(Ease.Linear).SetLink(battery.gameObject));
            sequence.SetLink(battery.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);

            if (!LTBY_GameView.GameInstance.IsSelf(this.chairId) && this.isOtherside)
            {
                this.tipNode.localEulerAngles = new Vector3(0, 0, 180);
            }
        }

        private void Cancel()
        {
            LTBY_BatteryManager.Instance.DestroyMissile(this.chairId);
            LTBY_BatteryManager.Instance.ShowBattery(this.chairId);
        }

        public override BulletClass Shoot(params object[] args)
        {
            this.isShoot = true;
            Vector3 pos = (Vector3) args[0];
            int fishId = (int) args[1];
            Vector3 worldPos = this.battery.position;
            float angles = Mathf.Atan2((pos.y - worldPos.y), (pos.x - worldPos.x)) * Mathf.Rad2Deg;
            SetAngles(angles - 90);

            BulletClass bullet = LTBY_BulletManager.Instance.CreateBulletMissile(this.chairId, this.shootPos.position,
                this.shootAngles, pos, this.propId);
            if (LTBY_GameView.GameInstance.IsSelf(this.chairId))
            {
                if (bullet == null) return null;

                //      GC.NetworkRequest.Request("CSTorpedoShoot",{
                //              fish_uid = fishId,
                //	x = pos.x,
                //	y = pos.y,
                //});

                //          GC.NetworkRequest.Request("CSSyncPropInfo",{
                //              id = this.propId,
                //	ratio = 0,
                //	angle = this.shootAngles,
                //	x = this.shootPos.position.x,
                //	y = this.shootPos.position.y,
                //	status = 1,
                //});

                LTBY_Audio.Instance.Play(SoundConfig.DrillShoot);

                Cancel();

                //GC.Notification.GamePost("SCTorpedoCancelSelfShoot", false);
            }
            else
            {
                Cancel();
            }

            return bullet;
        }

        public override void SetAngles(float angles)
        {
            this.battery.localEulerAngles = new Vector3(0, 0, angles);
            this.shootAngles = angles;
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            if (IlBehaviour != null)
            {
                IlBehaviour.UpdateEvent = null;
                LTBY_Extend.Destroy(IlBehaviour);
                IlBehaviour = null;
            }

            for (int i = 0; i < actionKey.Count; i++)
            {
                LTBY_Extend.Instance.StopAction(actionKey[i]);
            }

            actionKey.Clear();

            for (int i = 0; i < timerKey.Count; i++)
            {
                LTBY_Extend.Instance.StopTimer(timerKey[i]);
            }

            timerKey.Clear();

            if (this.battery != null)
            {
                LTBY_Extend.Destroy(this.battery.gameObject);
                this.battery = null;
            }

            if (this.tipNode != null)
            {
                LTBY_Extend.Destroy(this.tipNode.gameObject);
                this.tipNode = null;
            }

            LTBY_GameView.GameInstance.SetAdjustRatioEnable(this.chairId, true);
        }
    }

    public class FreeBatteryClass : BatteryClass
    {
        public bool isShoot;
        private int state;
        private int mul;
        private float time;
        private Transform status;
        private Text mulNode;
        private Text timeNode;
        private Transform stayBattery;
        private Transform shootBattery;
        private Transform fullScreenEffect;
        private Transform effectTip;

        private List<IState> states;
        private HierarchicalStateMachine hsm;

        public void OnCreate(int _chairId, int _ratio, int _mul, float _time, Transform _parent, bool begin)
        {
            states = new List<IState>();
            hsm = new HierarchicalStateMachine(false, _parent.gameObject);
            states.Add(new IdleState(this, hsm));
            states.Add(new SelfState(this, hsm));
            states.Add(new OtherState(this, hsm));
            hsm.Init(states, nameof(IdleState));

            this.level = LTBY_BatteryManager.Instance.CurrentLevel; //"Free";
            LTBY_BatteryManager.Instance.IsFreeBattery = true;

            this.chairId = _chairId;

            this.parent = _parent;

            this.cam = LTBYEntry.Instance.GetUiCam();

            this.ratio = _ratio;

            this.mul = _mul;

            this.time = _time;

            this.actionKey = new List<int>();

            this.timerKey = new List<int>();

            this.shootAngles = 0;

            this.isOtherside = LTBY_GameView.GameInstance.CheckIsOtherSide(this.chairId);

            this.battery = LTBY_Extend.Instance.LoadPrefab("LTBY_BatteryFree", this.parent);
            this.battery.transform.localPosition = new Vector3(0, 60, 0);
            this.status = this.battery.FindChildDepth("Status");
            this.status.gameObject.SetActive(true);
            this.status.localEulerAngles = new Vector3(0, 0, this.isOtherside ? 180 : 0);

            this.status.FindChildDepth<TextMeshProUGUI>("Ratio").text = LTBY_BatteryManager.Instance.ChangeUnit(this.ratio);
            this.status.FindChildDepth<TextMeshProUGUI>("Ratio").text = "";
            this.mulNode = this.status.FindChildDepth<Text>("Mul");

            this.timeNode = this.status.FindChildDepth<Text>("Time");

            this.stayBattery = this.battery.FindChildDepth("BatteryStay");
            this.stayBattery.gameObject.SetActive(true);

            this.shootBattery = this.battery.FindChildDepth("BatteryShoot");
            this.shootBattery.gameObject.SetActive(false);
            this.shootPos = this.shootBattery.FindChildDepth("ShootPos");
            this.shootPos.gameObject.SetActive(false);

            this.fullScreenEffect = null;

            if (LTBY_GameView.GameInstance.IsSelf(this.chairId))
            {
                LTBY_GameView.GameInstance.SetAdjustRatioEnable(this.chairId, false);
                InitFullScreenEffect();
                hsm?.ChangeState(nameof(SelfState));
            }
            else
            {
                hsm?.ChangeState(nameof(OtherState));
            }

            this.effectTip = this.battery.FindChildDepth("EffectTip");
            this.effectTip.gameObject.SetActive(true);
            this.effectTip.FindChildDepth<Text>("tu/Time").text = $"{(object) this.time:F1}{BatteryConfig.Second}";
            this.effectTip.localEulerAngles = new Vector3(0, 0, this.isOtherside ? 180 : 0);

            this.isShoot = false;

            this.state = 1;

            SetMul(this.mul);

            SetTime(this.time);

            if (begin)
            {
                this.effectTip.gameObject.SetActive(false);
                ChangeState(2);
            }
            else
            {
                int key = LTBY_Extend.Instance.DelayRun(2, () =>
                {
                    this.effectTip.gameObject.SetActive(false);
                    ChangeState(2);
                });
                timerKey.Add(key);
            }


            this.shootInterval = 0;

            if (LTBY_GameView.GameInstance.IsSelf(this.chairId))
            {
                LTBY_Audio.Instance.PlayBackMusic(SoundConfig.FreeBG);
                LTBY_Audio.Instance.Play(SoundConfig.FreeGet);
            }

            if (IlBehaviour == null)
            {
                IlBehaviour = this.battery.gameObject.AddComponent<ILBehaviour>();
            }

            IlBehaviour.UpdateEvent = OnUpdate;
            // this.updateKey = LTBY_Extend.Instance.StartTimer(() =>
            // {
            //     this.OnUpdate();
            // });
        }

        protected override void OnUpdate()
        {
            hsm?.Update();
        }

        private void InitFullScreenEffect()
        {
            this.fullScreenEffect =
                LTBY_PoolManager.Instance.GetUiItem("LTBY_FreeBatteryFullScreenEffect",
                    LTBYEntry.Instance.GetUiLayer());
            this.fullScreenEffect.localPosition = Vector3.zero;
        }

        private void ChangeState(int _state)
        {
            if (this.state == _state) return;

            this.state = _state;
            this.stayBattery.gameObject.SetActive(this.state == 1);

            this.shootBattery.gameObject.SetActive(this.state == 2);

            this.shootBattery.localEulerAngles = new Vector3(0, 0, this.shootAngles);

            this.isShoot = this.state == 2;
        }

        public Vector3 GetMulWorldPos()
        {
            return this.mulNode.transform.position;
        }

        public Vector3 GetTimeWorldPos()
        {
            return this.timeNode.transform.position;
        }

        public void SetMul(int _mul)
        {
            this.mul = _mul;
            this.mulNode.text = $"x{1}";
        }

        public void AddMul(int _mul)
        {
            SetMul(this.mul + _mul);
            Sequence sequence = DOTween.Sequence();
            sequence.Append(mulNode.transform.DOBlendableScaleBy(new Vector3(0.8f, 0.8f, 1), 0.1f)
                .SetEase(Ease.Linear).SetLink(mulNode.gameObject));
            sequence.Append(mulNode.transform.DOScale(new Vector3(1f, 1f, 1), 0.1f).SetEase(Ease.Linear).SetLink(mulNode.gameObject));
            sequence.SetLink(mulNode.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);
        }

        public void SetTime(float _time)
        {
            this.time = _time > 0 ? _time : 0;
            this.timeNode.text = $"{this.time:F1}";
        }

        public void AddTime(float _time)
        {
            SetTime(this.time + _time);
            if (this.state == 1)
            {
                ChangeState(2);
            }

            Sequence sequence = DOTween.Sequence();
            sequence.Append(
                timeNode.transform.DOBlendableScaleBy(new Vector3(0.8f, 0.8f, 1), 0.1f).SetEase(Ease.Linear).SetLink(timeNode.gameObject));
            sequence.Append(timeNode.transform.DOScale(new Vector3(1f, 1f, 1), 0.1f).SetEase(Ease.Linear).SetLink(timeNode.gameObject));
            sequence.SetLink(timeNode.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);
        }

        public override void SetAngles(float angles)
        {
            angles = Mathf.Clamp(angles, -80, 80);
            this.shootAngles = angles;
            this.shootBattery.localEulerAngles = new Vector3(0, 0, this.shootAngles);
        }

        protected override bool LockUpdate()
        {
            FishClass fish = LTBY_FishManager.Instance.GetLockFish(this.chairId);
            if (fish == null) return false;
            Vector3 pos = fish.GetWorldPos();
            Vector3 worldPos = this.battery.position;

            float angles = Mathf.Atan2((pos.y - worldPos.y), (pos.x - worldPos.x)) * Mathf.Rad2Deg;
            SetAngles(angles - 90);
            return true;
        }

        protected override void ShootUpdate()
        {
            if (!LTBY_BatteryManager.Instance.Press || LTBY_BatteryManager.Instance.PressEventData == null) return;
            Vector3 pos = this.cam.ScreenToWorldPoint(LTBY_BatteryManager.Instance.PressEventData.position);
            Vector3 worldPos = this.battery.position;

            float angles = Mathf.Atan2((pos.y - worldPos.y), (pos.x - worldPos.x)) * Mathf.Rad2Deg;
            //DebugHelper.LogError($"self angles:{angles - 90}");
            SetAngles(angles - 90);
        }

        protected override void SettleAccount()
        {
            SetTime(0);
            ChangeState(1);

            Transform tip = this.battery.FindChildDepth("EffectFinish");
            tip.gameObject.SetActive(true);
            tip.localEulerAngles = new Vector3(0, 0, this.isOtherside ? 180 : 0);

            if (LTBY_GameView.GameInstance.IsSelf(this.chairId))
            {
                LTBY_Audio.Instance.Play(SoundConfig.FreeFinish);
            }

            int key = LTBY_Extend.Instance.DelayRun(2f, ()=>
            {
                LTBY_BatteryManager.Instance.DestroyFreeBattery(this.chairId);
                LTBY_BatteryManager.Instance.ShowBattery(this.chairId);

                EffectClass effect = LTBY_EffectManager.Instance.GetFreeBattery(this.chairId);
                effect?.SettleAccount();
            });
            timerKey.Add(key);
        }

        public override BulletClass Shoot(params object[] args)
        {
            BulletClass bullet = null;
            if (LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                bullet = LTBY_BulletManager.Instance.CreateBullet(this.chairId, this.level, this.shootPos.position,
                    this.isOtherside ? this.shootAngles + 180 : this.shootAngles);
                //              GC.NetworkRequest.Request("CSUserShoot",{
                //                  angle = this.shootAngles,
                //	bullet_id = bullet.id,
                //	ratio = 0,
                //	bullet_type = GC.PropConfig.FreeBattery.id,
                //});
                bullet.SetRatio(ratio);
                LTBY_Struct.PlayerShoot playerShoot = new LTBY_Struct.PlayerShoot()
                {
                    x = this.shootAngles,
                    wChairId = this.chairId,
                    bulletId = bullet.id,
                    bet = GameData.Instance.Config.bulletScore[level - 1] * ratio,
                    gunLevel = (byte)(this.ratio - 1),
                    gunGrade = (byte)(this.level - 1)
                };
                LTBY_Network.Instance.Send(LTBY_Network.SUB_C_PRESS_SHOOT, playerShoot.Buffer);
                LTBY_Audio.Instance.Play(SoundConfig.FreeShoot);
            }
            else
            {
                bullet = LTBY_BulletManager.Instance.CreateBullet(this.chairId, this.level, this.shootPos.position,
                    this.isOtherside ? this.shootAngles + 180 : this.shootAngles);
            }

            return bullet;
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            if (IlBehaviour != null)
            {
                IlBehaviour.UpdateEvent = null;
                LTBY_Extend.Destroy(IlBehaviour);
                IlBehaviour = null;
            }

            if (this.battery != null)
            {
                LTBY_Extend.Destroy(this.battery.gameObject);
                this.battery = null;
            }

            if (this.fullScreenEffect != null)
            {
                LTBY_PoolManager.Instance.RemoveUiItem("LTBY_FreeBatteryFullScreenEffect", this.fullScreenEffect);
                this.fullScreenEffect = null;
            }

            for (int i = 0; i < actionKey.Count; i++)
            {
                LTBY_Extend.Instance.StopAction(actionKey[i]);
            }

            actionKey.Clear();

            for (int i = 0; i < timerKey.Count; i++)
            {
                LTBY_Extend.Instance.StopTimer(timerKey[i]);
            }

            timerKey.Clear();

            LTBY_GameView.GameInstance.SetAdjustRatioEnable(this.chairId, true);

            if (LTBY_GameView.GameInstance.IsSelf(this.chairId))
            {
                LTBY_Audio.Instance.PlayBackMusic(SoundConfig.BG);
            }
            LTBY_BatteryManager.Instance.IsFreeBattery = false;
        }

        private class IdleState : State<FreeBatteryClass>
        {
            public IdleState(FreeBatteryClass owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }

        private class SelfState : State<FreeBatteryClass>
        {
            public SelfState(FreeBatteryClass owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void Update()
            {
                base.Update();
                if (!LTBY_GameView.GameInstance.IsPlayerInRoom(owner.chairId)) return;

                if (owner.state == 1) return;


                if (!owner.LockUpdate())
                {
                    owner.ShootUpdate();
                }

                float dt = Time.deltaTime;
                if (owner.shootInterval <= 0)
                {
                    if (owner.time > 0)
                    {
                        //如果时间大于0，继续发射
                        owner.Shoot();
                    }
                    else if (LTBY_BulletManager.Instance.GetBulletCount(owner.chairId) < 10)
                    {
                        //如果时间小于0，并且服务器还没退出，并且屏幕免费子弹小于10颗
                        // DebugHelper.LogError("如果时间小于0，并且服务器还没退出，并且屏幕免费子弹小于10颗")

                        owner.Shoot();
                    }

                    owner.shootInterval += 0.2f;
                }

                owner.shootInterval -= dt;
                owner.time -= dt;
                owner.SetTime(owner.time);
                if (owner.time > 0) return;
                owner.SettleAccount();
            }
        }

        private class OtherState : State<FreeBatteryClass>
        {
            public OtherState(FreeBatteryClass owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void Update()
            {
                base.Update();
                if (owner.state == 1) return;
                float dt = Time.deltaTime;
                owner.time -= dt;
                owner.SetTime(owner.time);
                if (owner.time > 0) return;
                owner.SettleAccount();
            }
        }
    }
}