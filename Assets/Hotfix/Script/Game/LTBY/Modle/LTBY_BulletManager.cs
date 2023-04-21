using DG.Tweening;
using LuaFramework;
using System;
using System.Collections.Generic;
using UnityEngine;
using Object = UnityEngine.Object;

namespace Hotfix.LTBY
{
    /// <summary>
    /// 子弹管理器
    /// </summary>
    public class LTBY_BulletManager : SingletonNew<LTBY_BulletManager>
    {
        private Dictionary<int, Dictionary<int, BulletClass>> BulletList;
        private Dictionary<int, BulletDrillClass> DrillList;
        private Dictionary<int, BulletElectricClass> ElectricList;
        private Dictionary<int, BulletMissileClass> MissileList;
        private Dictionary<int, BulletWaterSpoutClass> WaterSpoutList;
        private Dictionary<int, BulletDragonBallClass> DragonBallList;
        private int BulletId;
        private Dictionary<int, int> BulletCount;
        public Transform Parent;
        public float LeftEdge;
        public float RightEdge;
        public float TopEdge;
        public float BottomEdge;

        public override void Init(Transform iLEntity = null)
        {
            base.Init(iLEntity);
            Parent = LTBYEntry.Instance.GetBulletLayer();

            Vector2 v = LTBYEntry.Instance.GetBackgroundWH();
            RightEdge = v.x * 0.5f;
            LeftEdge = -RightEdge;
            TopEdge = v.y * 0.5f;
            BottomEdge = -TopEdge;

            BulletId = 0;

            BulletCount = new Dictionary<int, int>();

            BulletList = new Dictionary<int, Dictionary<int, BulletClass>>();

            DrillList = new Dictionary<int, BulletDrillClass>();

            ElectricList = new Dictionary<int, BulletElectricClass>();

            MissileList = new Dictionary<int, BulletMissileClass>();

            WaterSpoutList = new Dictionary<int, BulletWaterSpoutClass>();

            DragonBallList = new Dictionary<int, BulletDragonBallClass>();

            UnityEngine.Physics2D.IgnoreLayerCollision(15, 15, true);
            UnityEngine.Physics2D.IgnoreLayerCollision(8, 15, true);
            RegisterEvent();
        }

        public override void Release()
        {
            base.Release();
            DestroyAllBullet();

            BulletList?.Clear();

            DrillList?.Clear();

            ElectricList?.Clear();

            MissileList?.Clear();

            DragonBallList?.Clear();

            UnityEngine.Physics2D.IgnoreLayerCollision(15, 15, false);
            UnityEngine.Physics2D.IgnoreLayerCollision(8, 15, false);

            UnregisterEvent();
        }

        private void RegisterEvent()
        {
            LTBY_Event.SCPropStatus += LTBY_Event_SCPropStatus;
        }

        private void LTBY_Event_SCPropStatus(LTBY_Struct.PropStatus data)
        {
            DebugHelper.LogError($"SCPropStatus:{LitJson.JsonMapper.ToJson(data)}");
            int chairId = data.chairId;
            int propId = data.propId;
            int status = data.status;
            if (PropConfig.CheckIsDrill(propId))
            {
                if (DrillList.ContainsKey(chairId) && status == 2)
                {
                    DrillList[chairId].OnFinish();
                }
            }
            else if (PropConfig.CheckIsElectric(propId))
            {
                if (ElectricList.ContainsKey(chairId) && status == 2)
                {
                    ElectricList[chairId].OnFinish();
                }
            }
            else if (PropConfig.CheckIsDragonBall(propId))
            {
                DebugHelper.LogError($"龙珠结算: {DragonBallList.ContainsKey(chairId)} BulletManager:95");
                DebugHelper.LogError($"SCPropStatus{data}");
                if (!DragonBallList.ContainsKey(chairId) || status != 2) return;
                DragonBallList[chairId].OnFinish();
                LTBY_DataReport.Instance.ReportElectricDragonScore(chairId);
            }
        }

        private void UnregisterEvent()
        {
            LTBY_Event.SCPropStatus -= LTBY_Event_SCPropStatus;
        }

        public int AllocateBulletId()
        {
            BulletId++;
            if (BulletId >= 10000)
            {
                BulletId = 0;
            }

            return BulletId;
        }

        public int GetBulletCount(int chairId)
        {
            return BulletCount.ContainsKey(chairId) ? BulletCount[chairId] : 0;
        }

        public bool CanCreateBullet(int chairId, int delta = 1)
        {
            if (!BulletCount.ContainsKey(chairId))
            {
                BulletCount.Add(chairId, 0);
            }

            return BulletCount[chairId] + delta <= 30;
        }

        public BulletClass CreateBullet(int chairId, int level, Vector3 pos, float angles)
        {
            if (!BulletCount.ContainsKey(chairId))
            {
                BulletCount.Add(chairId, 0);
            }

            BulletCount[chairId] += 1;

            int id = AllocateBulletId();
            BulletClass bullet = new BulletClass();
            bullet.OnCreate(chairId, id, level, pos, angles);

            if (!BulletList.ContainsKey(chairId))
            {
                BulletList.Add(chairId, new Dictionary<int, BulletClass>());
            }

            if (BulletList[chairId].ContainsKey(id))
            {
                BulletList[chairId].Remove(id);
            }

            BulletList[chairId].Add(id, bullet);
            return bullet;
        }

        public BulletWaterSpoutClass CreateWaterSpout(int chairId, int level, bool isRaged, bool isMulti)
        {
            if (WaterSpoutList.ContainsKey(chairId))
            {
                return WaterSpoutList[chairId];
            }

            int id = AllocateBulletId();

            BulletWaterSpoutClass bullet = new BulletWaterSpoutClass();
            //chairId,id,level,pos,angles
            //

            bullet.OnCreate(chairId, id, level, isRaged, isMulti);

            WaterSpoutList.Add(chairId, bullet);
            return bullet;
        }

        public BulletDrillClass CreateBulletDrill(int chairId, Vector3 pos, float angles)
        {
            if (DrillList.ContainsKey(chairId))
            {
                return DrillList[chairId];
            }

            int id = AllocateBulletId();
            BulletDrillClass bullet = new BulletDrillClass();
            bullet.OnCreate(chairId, id, pos, angles);

            DrillList.Add(chairId, bullet);

            return bullet;
        }

        public BulletMissileClass CreateBulletMissile(int chairId, Vector3 pos, float angles, Vector3 aimPos,
            int propId)
        {
            if (MissileList.ContainsKey(chairId))
            {
                return MissileList[chairId];
            }

            int id = AllocateBulletId();

            BulletMissileClass bullet = new BulletMissileClass();
            bullet.OnCreate(chairId, id, pos, angles, aimPos, propId);

            MissileList.Add(chairId, bullet);

            return bullet;
        }

        public BulletElectricClass CreateBulletElectric(int chairId, Vector3 pos, float angles)
        {
            if (ElectricList.ContainsKey(chairId))
            {
                //此处容错解释
                //服务器不给非playing状态的玩家发射电磁炮用完的包，所有在玩家进入的时候，同步道具电磁炮正在使用，并且在没有变成playing状态的时候
                //其他玩家用完了，这个时候收不到电磁炮消失，所以在获取下次电磁炮的时候会出现创建了两个电磁炮的可能，此处已修改，以防万一加容错,电
                //钻炮同理
                //logError(GC.GameInstance.chairId.."已经有电磁炮激光了\n"..debug.traceback());
                return ElectricList[chairId];
            }

            int id = AllocateBulletId();
            BulletElectricClass bullet = new BulletElectricClass();
            bullet.OnCreate(chairId, id, pos, angles);

            ElectricList.Add(chairId, bullet);

            return bullet;
        }

        public BulletDragonBallClass CreateBulletDragonBall(int chairId, int multiplier)
        {
            //logError('创建:BulletDragonBallClass   BulletManager:212')
            // not GC.GameInstance: IsPlayerInRoom(chairId) or

            if (LTBY_GameView.GameInstance.IsPlayerInRoom(chairId) && DragonBallList.ContainsKey(chairId))
                return DragonBallList[chairId];

            int id = AllocateBulletId();
            BulletDragonBallClass bullet = new BulletDragonBallClass();

            bullet.OnCreate(chairId, id, multiplier);

            DragonBallList.Add(chairId, bullet);
            return bullet;
        }

        private void DestroyAllBullet()
        {
            var bulletKeys = BulletList.GetDictionaryKeys();
            for (int i = 0; i < bulletKeys.Length; i++)
            {
                DestroyPlayerBullet(bulletKeys[i]);
            }

            BulletList?.Clear();
            var DrillKeys = DrillList.GetDictionaryKeys();
            for (int i = 0; i < DrillKeys.Length; i++)
            {
                DestroyDrill(DrillKeys[i]);
            }

            DrillList?.Clear();
            var ElectricKeys = ElectricList.GetDictionaryKeys();
            for (int i = 0; i < ElectricKeys.Length; i++)
            {
                DestroyElectric(ElectricKeys[i]);
            }

            ElectricList?.Clear();

            var MissileKeys = MissileList.GetDictionaryKeys();
            for (int i = 0; i < MissileKeys.Length; i++)
            {
                DestroyMissile(MissileKeys[i]);
            }

            MissileList?.Clear();

            var WaterSpoutKeys = WaterSpoutList.GetDictionaryKeys();
            for (int i = 0; i < WaterSpoutKeys.Length; i++)
            {
                DestroyWaterSpout(WaterSpoutKeys[i]);
            }

            WaterSpoutList?.Clear();

            var DragonBallKeys = DragonBallList.GetDictionaryKeys();
            for (int i = 0; i < DragonBallKeys.Length; i++)
            {
                DestroyDragonBall(DragonBallKeys[i]);
            }

            DragonBallList?.Clear();


            BulletCount?.Clear();
        }

        public BulletClass GetPlayerBullet(int chairId, int id)
        {
            if (!BulletList.ContainsKey(chairId)) return null;
            BulletList[chairId].TryGetValue(id, out var bullet);
            return bullet;
        }

        /// <summary>
        /// 获取存在屏幕上子弹的剩余价值
        /// </summary>
        /// <param name="chairId">椅子号</param>
        /// <returns></returns>
        public int GetPlayerBulletValue(int chairId)
        {
            int value = 0;
            if (!BulletList.ContainsKey(chairId)) return value;
            var values = BulletList[chairId].GetDictionaryValues();
            for (int i = 0; i < values.Length; i++)
            {
                value = values[i].GetRatio() + value;
            }

            return value;
        }

        public void DestroyPlayerBullet(int chairId)
        {
            if (BulletList.ContainsKey(chairId))
            {
                var values = BulletList[chairId].GetDictionaryValues();
                for (int i = 0; i < values.Length; i++)
                {
                    values[i].Destroy();
                }

                BulletList[chairId].Clear();
                BulletCount[chairId] = 0;
            }

            DestroyDrill(chairId);
            DestroyElectric(chairId);
            DestroyMissile(chairId);
            DestroyDragonBall(chairId);
        }

        public BulletDrillClass GetDrill(int chairId)
        {
            DrillList.TryGetValue(chairId, out BulletDrillClass bulletDrillClass);
            return bulletDrillClass;
        }

        public void DestroyDrill(int chairId)
        {
            if (!DrillList.ContainsKey(chairId)) return;
            DrillList[chairId].Destroy();
            DrillList[chairId] = null;
            DrillList.Remove(chairId);
        }

        public BulletElectricClass GetElectric(int chairId)
        {
            ElectricList.TryGetValue(chairId, out BulletElectricClass bulletDrillClass);
            return bulletDrillClass;
        }

        public void DestroyElectric(int chairId)
        {
            if (!ElectricList.ContainsKey(chairId)) return;
            ElectricList[chairId].Destroy();
            ElectricList[chairId] = null;
            ElectricList.Remove(chairId);
        }

        public BulletMissileClass GetMissile(int chairId)
        {
            MissileList.TryGetValue(chairId, out BulletMissileClass bulletDrillClass);
            return bulletDrillClass;
        }

        private void DestroyMissile(int chairId)
        {
            if (!MissileList.ContainsKey(chairId)) return;
            MissileList[chairId].Destroy();
            MissileList[chairId] = null;
            MissileList.Remove(chairId);
        }

        public BulletDragonBallClass GetDragonBall(int chairId)
        {
            DragonBallList.TryGetValue(chairId, out BulletDragonBallClass bulletDrillClass);
            return bulletDrillClass;
        }

        private void DestroyDragonBall(int chairId)
        {
            if (!DragonBallList.ContainsKey(chairId)) return;
            DragonBallList[chairId].Destroy();
            DragonBallList[chairId] = null;
            DragonBallList.Remove(chairId);
        }

        public void DestroyBullet(int chairId, int id)
        {
            if (BulletList == null) return;
            BulletList.TryGetValue(chairId, out Dictionary<int, BulletClass> bulletlist);
            if (bulletlist == null) return;
            bulletlist.TryGetValue(id, out BulletClass bullet);
            if (bullet == null) return;
            bullet.Destroy();
            BulletList[chairId][id] = null;
            BulletList[chairId].Remove(id);
            BulletCount[chairId] -= 1;
        }

        public BulletWaterSpoutClass GetWaterSpout(int chairId)
        {
            WaterSpoutList.TryGetValue(chairId, out BulletWaterSpoutClass bulletDrillClass);
            return bulletDrillClass;
        }

        public void ShowWaterSpout(int chairId, bool flag)
        {
            if (WaterSpoutList.ContainsKey(chairId))
            {
                WaterSpoutList[chairId].ShowSpout(flag);
            }
        }

        public void DestroyWaterSpout(int chairId)
        {
            if (!WaterSpoutList.ContainsKey(chairId)) return;
            WaterSpoutList[chairId].Destroy();
            WaterSpoutList[chairId] = null;
            WaterSpoutList.Remove(chairId);
        }

        public void SetWaterSpoutHeadPos(int chairId, Vector3 pos)
        {
            if (WaterSpoutList.ContainsKey(chairId))
            {
                WaterSpoutList[chairId].SetHeadPosition(pos);
            }
        }

        public void SetRageSpout(int chairId, bool flag)
        {
            if (WaterSpoutList.ContainsKey(chairId))
            {
                WaterSpoutList[chairId].SetRageSpout(flag);
            }
        }

        public void SetWiderSpout(int chairId, bool flag)
        {
            if (WaterSpoutList.ContainsKey(chairId))
            {
                WaterSpoutList[chairId].SetWiderSpout(flag);
            }
        }
    }

    public class BulletClass
    {
        public Vector3 bulletAngles;
        protected int chairId;
        public int id;
        protected int level;
        protected string bulletName;
        protected Transform bullet;
        protected Vector3 bulletPos;
        protected float speed;
        protected float xSpeed;
        protected float ySpeed;
        protected float fishnetExistTime;
        protected int state;
        protected int ratio;

        protected List<int> timerKey;
        protected int actionKey;
        protected float existTime;
        protected CollisionTriggerUtility collisionTriggerUtility;
        protected FishClass lockFish;
        protected string fishnetName;
        protected Transform fishnet;

        protected Collider2D _collider;

        protected ILBehaviour IlBehaviour;

        public virtual void OnCreate(int _chairId, int _id, int _level, Vector3 pos, float angles)
        {
            this.chairId = _chairId;
            this.id = _id;
            this.level = _level;
            this.bulletName = $"LTBY_Bullet{(LTBY_BatteryManager.Instance.IsFreeBattery ? "Free" : this.level.ToString())}";
            this.bullet = LTBY_PoolManager.Instance.GetGameItem(this.bulletName, LTBY_BulletManager.Instance.Parent);

            this.bulletPos = pos;
            this.bullet.position = this.bulletPos;

            this.bulletAngles = new Vector3(0, 0, angles);
            this.bullet.eulerAngles = this.bulletAngles;

            this.speed = 40f;
            float rad = Mathf.Deg2Rad * (90 + angles);
            this.xSpeed = Mathf.Cos(rad) * this.speed;
            this.ySpeed = Mathf.Sin(rad) * this.speed;

            this.state = 0;

            this.ratio = 0;

            this.lockFish = null;

            this.timerKey = new List<int>();
            if (IlBehaviour == null)
            {
                IlBehaviour = this.bullet.gameObject.AddComponent<ILBehaviour>();
            }

            IlBehaviour.UpdateEvent = OnUpdate;
            // int key = LTBY_Extend.Instance.StartTimer(()=>
            // {
            //     OnUpdate();
            // });
            // this.timerKey.Add(key);
            this.existTime = 1f;
            collisionTriggerUtility = CollisionTriggerUtility.Get(this.bullet);
        }

        public virtual void SetRatio(int _ratio)
        {
            this.ratio = _ratio;
        }

        public virtual void OnFinish()
        {
        }


        public virtual int GetRatio()
        {
            return this.ratio;
        }

        public virtual int GetLevel()
        {
            return this.level;
        }

        protected virtual void Collider(GameObject go, GameObject _other)
        {
            FishClass hitFish = LTBY_FishManager.Instance.GetFish(int.Parse(_other.name));
            FishClass _lockFish = LTBY_FishManager.Instance.GetLockFish(this.chairId);
            if (_lockFish != null)
            {
                if (_lockFish != hitFish) return;
                hitFish.OnHit(this.chairId, this);
                OnHit();
            }
            else if (hitFish != null)
            {
                hitFish.OnHit(this.chairId, this);
                OnHit();
            }
        }

        protected virtual void OnHit(Vector3 pos)
        {
            OnHit();
        }

        protected virtual void OnHit()
        {
            this.fishnetName = $"LTBY_Fishnet{this.level}";
            this.fishnet = LTBY_PoolManager.Instance.GetGameItem(this.fishnetName, LTBY_BulletManager.Instance.Parent);

            this.fishnet.position = this.bulletPos;

            this.fishnetExistTime = 0.5f;

            this.state = 2;
            LTBY_Extend.Instance.DelayRun(this.fishnetExistTime,
                () => { LTBY_BulletManager.Instance.DestroyBullet(this.chairId, this.id); });
            RemoveBullet();
        }

        protected virtual void RemoveBullet()
        {
            if (this.bullet == null) return;
            LTBY_PoolManager.Instance.RemoveGameItem(this.bulletName, this.bullet);
            if (collisionTriggerUtility != null)
            {
                collisionTriggerUtility.onTriggerEnter2D = null;
                collisionTriggerUtility.onTriggerStay2D = null;
            }

            this.bullet = null;
        }

        protected virtual void RemoveFishnet()
        {
            if (this.fishnet == null) return;
            LTBY_PoolManager.Instance.RemoveGameItem(this.fishnetName, this.fishnet);
            this.fishnet = null;
        }

        protected virtual void OnDestroy()
        {
            RemoveBullet();
            RemoveFishnet();
            if (this.timerKey != null)
            {
                for (int i = 0; i < timerKey.Count; i++)
                {
                    LTBY_Extend.Instance.StopTimer(timerKey[i]);
                }

                this.timerKey.Clear();
            }
            if (IlBehaviour != null)
            {
                IlBehaviour.UpdateEvent = null;
                LTBY_Extend.Destroy(IlBehaviour);
                IlBehaviour = null;
            }

            IlBehaviour = null;
            this.timerKey = null;
        }

        public virtual void Destroy()
        {
            OnDestroy();
        }

        protected virtual void MoveUpdate(float dt)
        {
            if (this.lockFish == null)
            {
                if (this.bulletPos.x < LTBY_BulletManager.Instance.LeftEdge ||
                    this.bulletPos.x > LTBY_BulletManager.Instance.RightEdge)
                {
                    this.xSpeed = -this.xSpeed;

                    this.bulletAngles.z = 360 - this.bulletAngles.z;
                    this.bullet.eulerAngles = this.bulletAngles;

                    this.bulletPos.x = Mathf.Clamp(this.bulletPos.x, LTBY_BulletManager.Instance.LeftEdge,
                        LTBY_BulletManager.Instance.RightEdge);
                }

                if (this.bulletPos.y < LTBY_BulletManager.Instance.BottomEdge ||
                    this.bulletPos.y > LTBY_BulletManager.Instance.TopEdge)
                {
                    this.ySpeed = -this.ySpeed;
                    this.bulletAngles.z = 180 - this.bulletAngles.z;
                    this.bullet.eulerAngles = this.bulletAngles;
                    this.bulletPos.y = Mathf.Clamp(this.bulletPos.y, LTBY_BulletManager.Instance.BottomEdge,
                        LTBY_BulletManager.Instance.TopEdge);
                }
            }

            this.bulletPos.x += this.xSpeed * dt;
            this.bulletPos.y += this.ySpeed * dt;
            this.bullet.position = this.bulletPos;
        }

        protected virtual void LockFishUpdate(float dt)
        {
            this.lockFish = LTBY_FishManager.Instance.GetLockFish(this.chairId);
            if (this.lockFish == null) return;
            Vector3 pos = this.lockFish.GetWorldPos();
            Vector3 worldPos = this.bulletPos;
            float angles = Mathf.Atan2((pos.y - worldPos.y), (pos.x - worldPos.x)) * Mathf.Rad2Deg - 90;
            float curAngles = this.bulletAngles.z;
            float delta = (angles - curAngles) % 360;
            if (delta > 180)
            {
                delta -= 360;
            }
            else if (delta < -180)
            {
                delta += 360;
            }

            if (this.existTime >= 0)
            {
                if (Mathf.Abs(delta) > 90 && Vector2.Distance(pos, worldPos) <= 4)
                {
                    curAngles = angles;
                }
                else
                {
                    curAngles += Mathf.Clamp(delta, -400 * dt, 400 * dt);
                }
            }
            else
            {
                curAngles += delta;
            }

            this.existTime -= Time.deltaTime;
            this.bulletAngles = new Vector3(0, 0, curAngles);
            this.bullet.eulerAngles = this.bulletAngles;

            float rad = Mathf.Deg2Rad * (curAngles + 90);
            this.xSpeed = Mathf.Cos(rad) * this.speed;
            this.ySpeed = Mathf.Sin(rad) * this.speed;
        }

        protected virtual void OnUpdate()
        {
            //if GC.GameInstance:IsPlayerRunInBackground(this.chairId) then return end

            float dt = Time.deltaTime;
            switch (this.state)
            {
                case 0:
                    collisionTriggerUtility.onTriggerEnter2D = Collider;
                    collisionTriggerUtility.onTriggerStay2D = Collider;
                    this.state = 1;
                    break;
                case 1:
                    LockFishUpdate(dt);
                    MoveUpdate(dt);
                    break;
            }
        }
    }

    public class BulletDrillClass : BulletClass
    {
        private Transform trail;
        private Transform warnEffect;
        private bool finish;
        private float xPad;
        private float yPad;
        private string explosionName;
        private Transform explosion;
        private new Queue<Transform> fishnet;
        private float explosionExistTime;

        public void OnCreate(int _chairId, int _id, Vector3 pos, float angles)
        {
            this.chairId = _chairId;

            this.id = _id;

            this.bulletName = "LTBY_BulletDrill";

            this.bulletPos = pos;
            this.bullet.position = this.bulletPos;

            this.bulletAngles = new Vector3(0, 0, angles);
            this.bullet.eulerAngles = this.bulletAngles;

            this.bullet.localScale = new Vector3(3, 3, 3);

            this.trail = this.bullet.FindChildDepth("Trail");
            this.trail.gameObject.SetActive(true);

            this.warnEffect = this.bullet.FindChildDepth("Warn");
            this.warnEffect.gameObject.SetActive(false);

            this.finish = false;

            this.speed = 50;
            float rad = Mathf.Deg2Rad * (90 + angles);
            this.xSpeed = Mathf.Cos(rad) * this.speed;
            this.ySpeed = Mathf.Sin(rad) * this.speed;

            this.xPad = 2;
            this.yPad = 1;

            this.state = 0;

            this.actionKey = 0;

            this.explosionName = "LTBY_DrillExplosion";
            this.explosion = null;

            this.fishnetName = "LTBY_DrillHitEffect";
            this.fishnet = new Queue<Transform>();

            this.timerKey = new List<int>();
        }

        protected override void Collider(GameObject go, GameObject _other)
        {
            FishClass hitFish = LTBY_FishManager.Instance.GetFish(int.Parse(_other.name));
            if (hitFish == null) return;
            hitFish.OnHit(this.chairId, this);
            OnHit();
        }

        protected override void OnHit()
        {
            LTBY_Audio.Instance.Play(SoundConfig.DrillHitFish);

            Transform net = LTBY_PoolManager.Instance.GetGameItem(this.fishnetName, LTBY_BulletManager.Instance.Parent);
            net.position = this.bulletPos;
            net.eulerAngles = this.bulletAngles;
            this.fishnet.Enqueue(net);

            int key = LTBY_Extend.Instance.DelayRun(0.5f, () =>
            {
                if (this.fishnet.Count <= 0) return;
                Transform _net = this.fishnet.Dequeue();
                LTBY_PoolManager.Instance.RemoveGameItem(this.fishnetName, net);
            });
            this.timerKey.Add(key);
        }

        public override void OnFinish()
        {
            if (this.finish) return;

            this.finish = true;
            this.trail.gameObject.SetActive(false);
            this.warnEffect.gameObject.SetActive(true);
            this.xSpeed *= 0.3f;
            this.ySpeed *= 0.3f;
            collisionTriggerUtility.onTriggerEnter2D = null;
            Sequence sequence = DOTween.Sequence();
            sequence.SetLink(bullet.gameObject);
            sequence.Append(bullet.DOBlendableRotateBy(new Vector3(0, 0, 1080), 3).SetLink(bullet.gameObject));
            Sequence sequence1 = DOTween.Sequence();
            sequence.Insert(0, sequence1);
            sequence1.Append(bullet.DOBlendableScaleBy(new Vector2(1, 1), 0.5f).SetLink(bullet.gameObject));
            sequence1.Append(bullet.DOBlendableScaleBy(new Vector2(-1, -1), 0.5f).SetLink(bullet.gameObject));
            sequence1.SetLoops(3);
            sequence1.SetLink(bullet.gameObject);
            sequence.OnKill(CreateExplosion);
            this.actionKey = LTBY_Extend.Instance.RunAction(sequence);
        }

        private void CreateExplosion()
        {
            LTBY_Audio.Instance.Play(SoundConfig.DrillFinish);

            if (this.actionKey > 0)
            {
                LTBY_Extend.Instance.StopAction(this.actionKey);
                this.actionKey = 0;
            }

            this.explosion =
                LTBY_PoolManager.Instance.GetGameItem(this.explosionName, LTBY_BulletManager.Instance.Parent);

            Vector3 pos = this.bulletPos;
            pos.z = -5f;
            this.explosion.position = pos;

            this.explosionExistTime = 2f;

            LTBYEntry.Instance.ShakeFishLayer(1);

            this.state = 2;

            RemoveBullet();
        }

        private void RemoveExplosion()
        {
            if (this.explosion == null) return;
            LTBY_PoolManager.Instance.RemoveGameItem(this.explosionName, this.explosion);
            this.explosion = null;
        }

        protected override void RemoveBullet()
        {
            if (this.actionKey > 0)
            {
                LTBY_Extend.Instance.StopAction(this.actionKey);
                this.actionKey = 0;
            }

            for (int i = 0; i < timerKey.Count; i++)
            {
                LTBY_Extend.Instance.StopTimer(timerKey[i]);
            }

            this.timerKey.Clear();

            if (this.bullet == null) return;
            LTBY_PoolManager.Instance.RemoveGameItem(this.bulletName, this.bullet);
            collisionTriggerUtility.onTriggerEnter2D = null;
            this.bullet = null;
        }

        protected override void RemoveFishnet()
        {
            if (this.fishnet == null) return;
            while (this.fishnet.Count>0)
            {
                LTBY_PoolManager.Instance.RemoveGameItem(this.fishnetName, fishnet.Dequeue());
            }

            this.fishnet = null;
        }

        protected override void OnDestroy()
        {
            RemoveBullet();
            RemoveFishnet();
            RemoveExplosion();
        }

        private void SyncInfo(bool isOtherside, float x, float y, float angles)
        {
            if (isOtherside)
            {
                float a = Mathf.PI;
                this.bulletPos.x = x * Mathf.Cos(a) - y * Mathf.Sin(a);
                this.bulletPos.y = x * Mathf.Sin(a) + y * Mathf.Cos(a);
                angles += 180;
            }
            else
            {
                this.bulletPos.x = x;
                this.bulletPos.y = y;
            }

            this.bulletAngles = new Vector3(0, 0, angles);
            float rad = Mathf.Deg2Rad * (90 + angles);
            this.xSpeed = Mathf.Cos(rad) * this.speed;
            this.ySpeed = Mathf.Sin(rad) * this.speed;


            //logError("---------------------补帧前"..this.bulletPos.x.. "  "..this.bulletPos.y);
            float dt = Time.deltaTime;
            for (int i = 0; i < 5; i++)
            {
                SyncUpdate(dt);
            }
            // logError("---------------------补帧后"..this.bulletPos.x.. "  "..this.bulletPos.y);

            this.bullet.position = this.bulletPos;
            this.bullet.eulerAngles = this.bulletAngles;
        }

        private void SyncUpdate(float dt)
        {
            if (this.bulletPos.x < LTBY_BulletManager.Instance.LeftEdge - this.xPad ||
                this.bulletPos.x > LTBY_BulletManager.Instance.RightEdge + this.xPad)
            {
                this.xSpeed = -this.xSpeed;

                this.bulletAngles.z = 360 - this.bulletAngles.z;
                this.bulletPos.x = Mathf.Clamp(this.bulletPos.x, LTBY_BulletManager.Instance.LeftEdge - this.xPad,
                    LTBY_BulletManager.Instance.RightEdge + this.xPad);
            }


            if (this.bulletPos.y < LTBY_BulletManager.Instance.BottomEdge - this.yPad ||
                this.bulletPos.y > LTBY_BulletManager.Instance.TopEdge + this.yPad)
            {
                this.ySpeed = -this.ySpeed;

                this.bulletAngles.z = 180 - this.bulletAngles.z;

                this.bulletPos.y = Mathf.Clamp(this.bulletPos.y, LTBY_BulletManager.Instance.BottomEdge - this.yPad,
                    LTBY_BulletManager.Instance.TopEdge + this.yPad);
            }

            this.bulletPos.x += this.xSpeed * dt;
            this.bulletPos.y += this.ySpeed * dt;
        }

        protected override void MoveUpdate(float dt)
        {
            if (this.bulletPos.x < LTBY_BulletManager.Instance.LeftEdge - this.xPad ||
                this.bulletPos.x > LTBY_BulletManager.Instance.RightEdge + this.xPad)
            {
                this.xSpeed = -this.xSpeed;
                this.bulletAngles.z = 360 - this.bulletAngles.z;
                this.bullet.eulerAngles = this.bulletAngles;
                this.bulletPos.x = Mathf.Clamp(this.bulletPos.x, LTBY_BulletManager.Instance.LeftEdge - this.xPad,
                    LTBY_BulletManager.Instance.RightEdge + this.xPad);
                LTBYEntry.Instance.ShakeFishLayer(0.5f);
            }

            if (this.bulletPos.y < LTBY_BulletManager.Instance.BottomEdge - this.yPad ||
                this.bulletPos.y > LTBY_BulletManager.Instance.TopEdge + this.yPad)
            {
                this.ySpeed = -this.ySpeed;
                this.bulletAngles.z = 180 - this.bulletAngles.z;
                this.bullet.eulerAngles = this.bulletAngles;
                this.bulletPos.y = Mathf.Clamp(this.bulletPos.y, LTBY_BulletManager.Instance.BottomEdge - this.yPad,
                    LTBY_BulletManager.Instance.TopEdge + this.yPad);
                LTBYEntry.Instance.ShakeFishLayer(0.5f);
            }

            this.bulletPos.x += this.xSpeed * dt;
            this.bulletPos.y += this.ySpeed * dt;
            this.bullet.position = this.bulletPos;
            if (LTBY_GameView.GameInstance.IsSelf(this.chairId))
            {
                //              GC.NetworkRequest.Request("CSSyncPropInfo",{
                //                  id = GC.PropConfig.Drill1.id,
                //	ratio = 0,
                //	angle = this.bulletAngles.z,
                //	x = this.bulletPos.x,
                //	y = this.bulletPos.y,
                //	status = 1,
                //});
            }
        }

        protected override void OnUpdate()
        {
            if (!LTBY_GameView.GameInstance.IsPlayerInRoom(this.chairId)) return;

            float dt = Time.deltaTime;
            switch (this.state)
            {
                case 0:
                    collisionTriggerUtility.onTriggerEnter2D = Collider;

                    this.state = 1;
                    break;
                case 1:
                    MoveUpdate(dt);
                    break;
                case 2:
                {
                    this.explosionExistTime -= dt;
                    if (this.explosionExistTime < 0)
                    {
                        LTBY_BulletManager.Instance.DestroyDrill(this.chairId);
                    }

                    break;
                }
            }
        }
    }

    public class BulletElectricClass : BulletClass
    {
        private float bulletZ;
        private bool finish;
        private Transform startFire;
        private Transform endFire;
        private bool canCollider;
        private float colliderSleepTime;
        private int colliderFishLimit;
        private int colliderFish;
        private new Queue<Transform> fishnet;

        public void OnCreate(int _chairId, int _id, Vector3 pos, float angles)
        {
            this.chairId = _chairId;

            this.id = _id;

            this.bulletName = "LTBY_BulletElectric";
            this.bullet = LTBY_PoolManager.Instance.GetGameItem(this.bulletName, LTBY_BulletManager.Instance.Parent);

            this.bulletZ = pos.z;
            this.bullet.position = pos;

            this.bullet.eulerAngles = new Vector3(0, 0, angles);

            this.finish = false;

            this.startFire = this.bullet.FindChildDepth("Node/StartFire");
            this.endFire = this.bullet.FindChildDepth("Node/EndFire");

            this._collider = this.bullet.GetComponent<Collider2D>();
            this._collider.enabled = false;

            this.canCollider = true;
            this.colliderSleepTime = 0.4f;
            this.colliderFishLimit = 10;
            this.colliderFish = 0;

            collisionTriggerUtility = CollisionTriggerUtility.Get(this.bullet);
            collisionTriggerUtility.onTriggerEnter2D = (_self, _other) =>
            {
                if (!this.canCollider) return;

                this.colliderFish++;
                Collider(_self, _other);
                if (this.colliderFish < this.colliderFishLimit) return;
                this._collider.enabled = false;
                this.canCollider = false;
                this.colliderSleepTime = 0.4f;
                //DebugHelper.LogError("关闭碰撞");
            };


            this.fishnetName = "LTBY_Fishnet6";
            this.fishnet = new Queue<Transform>();

            this.timerKey = new List<int>();

            int key = LTBY_Extend.Instance.DelayRun(1, () =>
            {
                this._collider.enabled = true;
                LTBY_Audio.Instance.Play(SoundConfig.ElectricContinues, true);
                LTBYEntry.Instance.ShakeFishLayer(1);
            });
            this.timerKey.Add(key);

            //key = LTBY_Extend.Instance.StartTimer(()=>
            //{
            //    Update();
            //});
            //this.timerKey.Add(key);
        }

        protected override void Collider(GameObject go, GameObject _other)
        {
            FishClass hitFish = LTBY_FishManager.Instance.GetFish(int.Parse(_other.name));
            //DebugHelper.LogError($"碰撞了{hitFish.fishType}一共碰撞了{this.colliderFish}次");
            if (hitFish == null) return;
            hitFish.OnHit(this.chairId, this);
            OnHit(hitFish.GetWorldPos());
        }

        protected override void OnHit(Vector3 pos)
        {
            Transform net = LTBY_PoolManager.Instance.GetGameItem(this.fishnetName, LTBY_BulletManager.Instance.Parent);
            pos.z = this.bulletZ;
            net.position = pos;
            this.fishnet.Enqueue(net);
        }

        protected override void RemoveBullet()
        {
            if (this.bullet == null) return;
            this.startFire.gameObject.SetActive(true);
            this.endFire.gameObject.SetActive(false);
            collisionTriggerUtility.onTriggerEnter2D = null;
            LTBY_PoolManager.Instance.RemoveGameItem(this.bulletName, this.bullet);
            this.bullet = null;
        }

        protected override void RemoveFishnet()
        {
            if (this.fishnet == null) return;
            while (this.fishnet.Count>0)
            {
                LTBY_PoolManager.Instance.RemoveGameItem(this.fishnetName, fishnet.Dequeue());
            }

            this.fishnet.Clear();
        }

        protected override void OnDestroy()
        {
            LTBY_Audio.Instance.ClearAuido(SoundConfig.ElectricContinues);

            RemoveBullet();
            RemoveFishnet();
            for (int i = 0; i < this.timerKey.Count; i++)
            {
                LTBY_Extend.Instance.StopTimer(timerKey[i]);
            }

            this.timerKey.Clear();
        }

        public override void OnFinish()
        {
            if (this.finish) return;

            this.finish = true;
            this.startFire.gameObject.SetActive(false);
            this.endFire.gameObject.SetActive(true);
            collisionTriggerUtility.onTriggerEnter2D = null;

            int key = LTBY_Extend.Instance.DelayRun(2,
                () => { LTBY_BulletManager.Instance.DestroyElectric(this.chairId); });
            this.timerKey.Add(key);
        }

        protected override void OnUpdate()
        {
            //if GC.GameInstance:IsPlayerRunInBackground(this.chairId) then return end

            if (this.finish) return;

            if (this.canCollider) return;
            if (this.colliderSleepTime > 0)
            {
                this.colliderSleepTime -= Time.deltaTime;
            }

            if (!(this.colliderSleepTime <= 0)) return;
            this.canCollider = true;
            this._collider.enabled = true;
            this.colliderFish = 0;
            LTBYEntry.Instance.ShakeFishLayer(1);
            //DebugHelper.LogError("开启碰撞");
        }
    }

    public class BulletMissileClass : BulletClass
    {
        public void OnCreate(int _chairId, int _id, Vector3 pos, float angles, Vector3 aimPos, int propId)
        {
        }
    }

    public class BulletWaterSpoutClass : BulletClass
    {
        private LineRenderer currentLineRenderer;
        private Transform currentTail;
        private Transform currentHead;
        private Transform currentSpout;
        private bool activeSelf;
        private bool isMulti;
        private bool isRaged;
        private BulletWaterSpoutClass self;
        private Transform normalSpoutHead;
        private Transform normalSpoutTail;
        private LineRenderer rageLineRenderer;
        private Transform rageSpoutTail;
        private Transform rageSpoutHead;
        private Transform rageSpout;
        private Transform normalSpout;
        private LineRenderer nomralLineRenderer;
        private Dictionary<int,Material> SpoutMats;
        private int lengthOfLineRenderer;

        public Dictionary<int, BatteryWaterSpout> WaterSpoutConfig { get; set; }

        public void OnCreate(int _chairId, int _id, int _level, bool isRaged, bool isMulti)
        {
            self = this;
            self.chairId = _chairId;
            self.id = _id;
            self.level = _level;
            self.activeSelf = false;
            self.fishnetName = $"LTBY_FishNet{self.level}";
            self.bulletName = $"LTBY_BulletWaterSpout{self.level}";
            this.bullet = LTBY_PoolManager.Instance.GetGameItem(this.bulletName, LTBY_BulletManager.Instance.Parent);
            self.lengthOfLineRenderer = 2;

            self.WaterSpoutConfig = BatteryConfig.BatteryWaterSpoutConfig[self.level];
            self.SpoutMats = new Dictionary<int, Material>();
            for (int i = 1; i <= 4; i++)
            {
                self.SpoutMats.Add(i, LTBY_Extend.Instance.LoadAsset<Material>(self.WaterSpoutConfig[i].materialName));
            }
            // 当前应当显示的水柱节点
            self.currentSpout = null;
            self.currentHead = null;
            self.currentTail = null;
            self.currentLineRenderer = null;

            // 将两种水柱节点缓存起来
            self.normalSpout = self.bullet.FindChildDepth("normal");
            self.normalSpoutHead = self.normalSpout.FindChildDepth("Begin");
            self.normalSpoutTail = self.normalSpout.FindChildDepth("End");
            self.nomralLineRenderer = self.normalSpout.GetComponent<LineRenderer>();
            //self.nomralLineRenderer.startWidth = self.widthOfLineRenderer;
            self.rageSpout = self.bullet.FindChildDepth("rage");
            self.rageSpoutHead = self.rageSpout.FindChildDepth("Begin");
            self.rageSpoutTail = self.rageSpout.FindChildDepth("End");
            self.rageLineRenderer = self.rageSpout.GetComponent<LineRenderer>();
            //self.rageLineRenderer.startWidth = self.widthOfLineRenderer;
            // 初始化Line Renderer
            self.nomralLineRenderer.positionCount = self.lengthOfLineRenderer;
            self.rageLineRenderer.positionCount = self.lengthOfLineRenderer;
            self.nomralLineRenderer.useWorldSpace = true;
            self.rageLineRenderer.useWorldSpace = true; 

            SetStartSpout(isRaged);

            self.isRaged = isRaged;
            self.isMulti = isMulti;
            SetRageSpout(isRaged);
            SetWiderSpout(isMulti);
            self.ratio = 0;
            if (IlBehaviour == null)
            {
                IlBehaviour = this.bullet.gameObject.AddComponent<ILBehaviour>();
            }
            IlBehaviour.UpdateEvent = OnUpdate;
        }

        protected override void OnUpdate()
        {
            var fish = LTBY_FishManager.Instance.GetLockFish(self.chairId);
            if (fish == null) return;
            var tailPos = fish.GetWorldPos();
            var headPos = LTBY_BatteryManager.Instance.GetShootingPos(self.chairId);
            SetHeadPosition(headPos);
            SetTailPosition(tailPos);
        }

        private void SetStartSpout(bool isRaged)
        {
            if (isRaged)
            {
                self.currentSpout = self.rageSpout;
                self.currentHead = self.rageSpoutHead;
                self.currentTail = self.rageSpoutTail;
                self.currentLineRenderer = self.rageLineRenderer;
            }
            else
            {
                self.currentSpout = self.normalSpout;
                self.currentHead = self.normalSpoutHead;
                self.currentTail = self.normalSpoutTail;
                self.currentLineRenderer = self.nomralLineRenderer;
            }
        }

        public void SetRageSpout(bool isRaged)
        {
            if (isRaged)
            {
                self.currentSpout = self.rageSpout;
                self.currentHead = self.rageSpoutHead;
                self.currentTail = self.rageSpoutTail;
                self.currentLineRenderer = self.rageLineRenderer;
                SetHeadPosition(self.normalSpoutHead.position);
                SetTailPosition(self.normalSpoutTail.position);
            }
            else
            {
                self.currentSpout = self.normalSpout;
                self.currentHead = self.normalSpoutHead;
                self.currentTail = self.normalSpoutTail;
                self.currentLineRenderer = self.nomralLineRenderer;
                SetHeadPosition(self.rageSpoutHead.position);
                SetTailPosition(self.rageSpoutTail.position);
            }

            self.normalSpout.gameObject.SetActive(!isRaged && self.activeSelf);
            self.rageSpout.gameObject.SetActive(isRaged && self.activeSelf);
            self.isRaged = isRaged;
            SetWiderSpout(self.isMulti);
        }

        public void SetWiderSpout(bool isWider)
        {
            // if (isWider)
            // {
            //     if (isRaged)
            //     {
            //         self.rageLineRenderer.material = self.SpoutMats[4];
            //         self.currentLineRenderer.startWidth = self.WaterSpoutConfig[4].spoutWidth;
            //     }
            //     else
            //     {
            //         self.nomralLineRenderer.material = self.SpoutMats[3];
            //         self.currentLineRenderer.startWidth = self.WaterSpoutConfig[3].spoutWidth;
            //     }
            // }
            // else
            // {
            //     if (self.isRaged)
            //     {
            //         self.rageLineRenderer.material = self.SpoutMats[2];
            //         self.currentLineRenderer.startWidth = self.WaterSpoutConfig[2].spoutWidth;
            //     }
            //     else
            //     {
            //         self.nomralLineRenderer.material = self.SpoutMats[1];
            //         self.currentLineRenderer.startWidth = self.WaterSpoutConfig[1].spoutWidth;
            //     }
            // }

            isMulti = isWider;
        }

        public void ShowSpout(bool flag)
        {
            currentSpout.gameObject.SetActive(flag);
            activeSelf = flag;
        }

        public void SetHeadPosition(Vector3 headPos)
        {
            Vector3 pos = new Vector3(headPos.x, headPos.y, 0);
            //先将Line Renderer组件的启点设置好
            currentLineRenderer.SetPosition(0, pos);
            //在将对应特效的位置设置过去
            currentHead.position = pos;
        }

        private void SetTailPosition(Vector3 tailPos)
        {
            Vector3 pos = new Vector3(tailPos.x, tailPos.y, 0);
            //先将Line Renderer组件的止点设置好
            currentLineRenderer.SetPosition(1, pos);
            //在将对应特效的位置设置过去
            currentTail.position = pos;
        }
    }

    public class BulletDragonBallClass : BulletClass
    {
        public int totalMultiplier;

        public void OnCreate(int _chairId, int _id, int multiplier)
        {
        }
    }
}