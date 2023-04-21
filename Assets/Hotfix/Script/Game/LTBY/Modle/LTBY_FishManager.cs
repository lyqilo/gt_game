using System;
using DG.Tweening;
using LuaFramework;
using System.Collections.Generic;
using LitJson;
using TMPro;
using UnityEngine;
using Random = UnityEngine.Random;

namespace Hotfix.LTBY
{
    public class FishCacheData
    {
        public int fishType;
        public int num;
        public int maxNum;
    }

    public class FishPoolData
    {
        public int maxNum;
        public Stack<FishClass> Fish;
    }

    /// <summary>
    /// 鱼类资源管理
    /// </summary>
    public class LTBY_FishManager : SingletonNew<LTBY_FishManager>
    {
        public Transform FishParent;
        Dictionary<int, FishClass> FishList = new Dictionary<int, FishClass>();
        Dictionary<int, FishArrayClass> FishArrayList = new Dictionary<int, FishArrayClass>();
        List<FishClass> ScreenList = new List<FishClass>();
        int FishArrayId;
        private float LayerW;
        private float LayerH;
        int FishZOrder;
        public Dictionary<int, FishDataConfig> fishConfig = new Dictionary<int, FishDataConfig>();
        bool LockFishSwitch;
        bool RobotLockFishSwitch;
        public bool MissileLockSwitch;
        Dictionary<int, FishClass> LockFishList = new Dictionary<int, FishClass>();
        Dictionary<int, FishClass> RobotLockFishList = new Dictionary<int, FishClass>();
        int FishLayerMask;
        bool ChangeSceneFinish;
        int PlayOnlySoundKey;
        int UpdateKey;
        Dictionary<int, DragonClass> DragonList = new Dictionary<int, DragonClass>();
        public bool ShowDragonLight = true;
        bool DebugPool = false;
        bool Finish;

        private Dictionary<int, FishPoolData> FishPool = new Dictionary<int, FishPoolData>();

        int PreLoadIndex;
        int PreLoadUpdateKey;

        public List<LTBY_Struct.CMD_S_DaJiangZhangYu> DaJiangZhangYus = new List<LTBY_Struct.CMD_S_DaJiangZhangYu>();

        List<FishCacheData> PreLoadFishList = new List<FishCacheData>()
        {
            new FishCacheData() {fishType = 101, num = 10, maxNum = 20},
            new FishCacheData() {fishType = 102, num = 10, maxNum = 30},
            new FishCacheData() {fishType = 103, num = 5, maxNum = 15},
            new FishCacheData() {fishType = 104, num = 5, maxNum = 15},
            new FishCacheData() {fishType = 105, num = 1, maxNum = 5},
            new FishCacheData() {fishType = 106, num = 5, maxNum = 15},
            new FishCacheData() {fishType = 107, num = 5, maxNum = 15},
            new FishCacheData() {fishType = 108, num = 5, maxNum = 15},
            new FishCacheData() {fishType = 109, num = 1, maxNum = 5},
            new FishCacheData() {fishType = 110, num = 1, maxNum = 5},

            new FishCacheData() {fishType = 111, num = 5, maxNum = 10},
            new FishCacheData() {fishType = 112, num = 5, maxNum = 10},
            new FishCacheData() {fishType = 113, num = 1, maxNum = 5},
            new FishCacheData() {fishType = 114, num = 1, maxNum = 5},
            new FishCacheData() {fishType = 115, num = 1, maxNum = 5},
            new FishCacheData() {fishType = 116, num = 1, maxNum = 5},
            new FishCacheData() {fishType = 117, num = 5, maxNum = 10},
            new FishCacheData() {fishType = 118, num = 5, maxNum = 15},
            new FishCacheData() {fishType = 119, num = 1, maxNum = 5},
            new FishCacheData() {fishType = 120, num = 1, maxNum = 5},

            new FishCacheData() {fishType = 121, num = 1, maxNum = 5},
            new FishCacheData() {fishType = 122, num = 1, maxNum = 5},
            new FishCacheData() {fishType = 123, num = 0, maxNum = 2},
            new FishCacheData() {fishType = 124, num = 0, maxNum = 2},
            new FishCacheData() {fishType = 125, num = 0, maxNum = 2},
            new FishCacheData() {fishType = 126, num = 0, maxNum = 2},
            new FishCacheData() {fishType = 127, num = 0, maxNum = 2},
            new FishCacheData() {fishType = 128, num = 0, maxNum = 1},
            new FishCacheData() {fishType = 129, num = 0, maxNum = 3},

            new FishCacheData() {fishType = 131, num = 0, maxNum = 2},
            new FishCacheData() {fishType = 132, num = 0, maxNum = 1},
            new FishCacheData() {fishType = 133, num = 0, maxNum = 1},
            new FishCacheData() {fishType = 134, num = 0, maxNum = 1},
            new FishCacheData() {fishType = 136, num = 0, maxNum = 1},
            new FishCacheData() {fishType = 139, num = 0, maxNum = 1},
            new FishCacheData() {fishType = 140, num = 0, maxNum = 1},
            new FishCacheData() {fishType = 141, num = 0, maxNum = 1},
            new FishCacheData() {fishType = 142, num = 0, maxNum = 1},
            new FishCacheData() {fishType = 144, num = 0, maxNum = 1},
            new FishCacheData() {fishType = 145, num = 0, maxNum = 1},
        };


        #region 鱼预加载部分

        public void PreLoad()
        {
            ShowDragonLight = true;

            FishPool.Clear();

            PreLoadIndex = 1;
            Finish = false;
            PreLoadUpdateKey = LTBY_Extend.Instance.StartTimer(Loading, 0.05f);
            FishParent = LTBYEntry.Instance.GetFishLayer();
            fishConfig.Clear();
            for (int i = 0; i < FishConfig.Fish.Count; i++)
            {
                fishConfig.Add(FishConfig.Fish[i].fishOrginType, FishConfig.Fish[i]);
            }
        }

        private void PreLoadFinish()
        {
            Finish = true;
            LTBY_Extend.Instance.StopTimer(PreLoadUpdateKey);
        }

        public bool IsFinish()
        {
            return Finish;
        }

        private void Loading()
        {
            if (PreLoadIndex >= PreLoadFishList.Count)
            {
                PreLoadFinish();
            }
            else
            {
                var data = PreLoadFishList[PreLoadIndex];
                int fishType = data.fishType;
                if (!FishPool.ContainsKey(fishType))
                {
                    FishPool.Add(fishType, new FishPoolData() { maxNum = data.maxNum, Fish = new Stack<FishClass>() });
                }
                for (int i = 0; i < data.num; i++)
                {
                    FishClass fish;
                    if (FishConfig.CheckIsDragon(fishType))
                    {
                        fish = new DragonClass();
                    }
                    else if (FishConfig.CheckIsTreasureBowl(fishType))
                    {
                        fish = new TreasureBowl();
                    }
                    else
                    {
                        fish = new FishClass();
                    }

                    fish.Init(fishType, FishParent);
                    FishPool[fishType].Fish.Push(fish);
                }

                PreLoadIndex++;
                if (DebugPool) DebugHelper.LogError($"预加载鱼的对象:{fishType} 数量: {data.num}");
            }
        }

        /// <summary>
        /// 清空对象池
        /// </summary>
        private void ReleasePool()
        {
            FishPoolData[] fishs = FishPool.GetDictionaryValues();
            for (int i = 0; i < fishs.Length; i++)
            {
                while (fishs[i].Fish.Count > 0)
                {
                    fishs[i].Fish.Pop().Release();
                }
            }

            FishPool.Clear();
        }

        /// <summary>
        /// 从对象池中取出
        /// </summary>
        /// <param name="name">对象池id</param>
        /// <param name="parent">取出后的父节点</param>
        /// <returns></returns>
        public FishClass GetFishFromPool(int name, Transform parent)
        {
            if (!FishPool.ContainsKey(name))
            {
                FishPool.Add(name, new FishPoolData() {maxNum = 0, Fish = new Stack<FishClass>()});
                PreLoadFishList.Add(new FishCacheData() {fishType = name, num = 0, maxNum = 0});
            }

            if (FishPool[name].Fish.Count > 0)
            {
                FishClass fishTable = FishPool[name].Fish.Pop();
                fishTable.SetParent(parent);

                if (DebugPool) DebugHelper.LogError($"从缓存池:{name} 里面拿出一个，当前剩余:{FishPool[name].Fish.Count}");

                return fishTable;
            }
            else
            {
                FishClass fishTable;
                if (FishConfig.CheckIsDragon(name))
                    fishTable = new DragonClass();
                else if (FishConfig.CheckIsTreasureBowl(name))
                    fishTable = new TreasureBowl();
                else
                    fishTable = new FishClass();

                fishTable.Init(name, parent);

                if (DebugPool)
                    DebugHelper.LogError($"缓存池没有: {name} 这个鱼创建一个新的");

                return fishTable;
            }
        }

        public void RemoveFishToPool(int name, FishClass fishTable)
        {
            if (!FishPool.ContainsKey(name))
            {
                DebugHelper.LogError("没有: " + name + " 的缓存池，检查代码");
            }

            if (FishPool[name].Fish.Count >= FishPool[name].maxNum)
            {
                if (DebugPool)
                    DebugHelper.LogError("缓存池: " + name + " 的数量为:" + FishPool[name].Fish.Count + " 已经满了，直接删除");

                fishTable.Release();
            }
            else
            {
                fishTable.SetParent(FishParent);

                fishTable.fish.localPosition = new Vector3(1000, 0, 0);
                fishTable.fishAnimator.enabled = false;
                fishTable.CloseCollider();
                FishPool[name].Fish.Push(fishTable);

                if (DebugPool) DebugHelper.LogError("回收: " + name + " 的鱼,回收之后剩余:" + FishPool[name].Fish.Count);
            }
        }

        #endregion

        public override void Init(Transform iLEntity = null)
        {
            base.Init(iLEntity);
            FishZOrder = 0;
            FishArrayId = 0;
            FishList.Clear();
            FishArrayList.Clear();
            Camera mainCam = LTBYEntry.Instance.GetUiCam();
            Vector2 wh = LTBYEntry.Instance.GetBackgroundWH();
            LayerW = wh.x;
            LayerH = wh.y;
            FishParent = FishParent == null ? LTBYEntry.Instance.GetFishLayer() : FishParent;
            FishLayerMask = (int) (Mathf.Pow(2, 21) + Mathf.Pow(2, 10) + Mathf.Pow(2, 11));
            fishConfig = fishConfig == null ? new Dictionary<int, FishDataConfig>() : fishConfig;
            fishConfig.Clear();
            for (int i = 0; i < FishConfig.Fish.Count; i++)
            {
                var v = FishConfig.Fish[i];
                fishConfig.Add(v.fishOrginType, v);
            }

            LockFishList.Clear();
            RobotLockFishList.Clear();
            LockFishSwitch = false;
            MissileLockSwitch = false;
            ChangeSceneFinish = true;
            PlayOnlySoundKey = 0;
            RegisterEvent();
            Physics2D.IgnoreLayerCollision(9, 9, true);
            Physics2D.IgnoreLayerCollision(9, 10, true);
            Physics2D.IgnoreLayerCollision(10, 10, true);
            Physics2D.IgnoreLayerCollision(11, 11, true);
            LTBYEntry.Instance.UpdateEvent += Update;
            // UpdateKey = LTBY_Extend.Instance.StartTimer(Update);
        }

        public override void Release()
        {
            SetMissileLockSwitch(false);
            SetLockFishSwitch(false);
            UnregisterEvent();
            DestroyAllFish(false);
            ReleasePool();
            FishList.Clear();
            FishArrayList.Clear();
            ScreenList.Clear();
            Physics2D.IgnoreLayerCollision(9, 9, false);
            Physics2D.IgnoreLayerCollision(9, 10, false);
            Physics2D.IgnoreLayerCollision(10, 10, false);
            Physics2D.IgnoreLayerCollision(11, 11, false);
            // LTBY_Extend.Instance.StopTimer(UpdateKey);
            LTBYEntry.Instance.UpdateEvent -= Update;
        }

        private void RegisterEvent()
        {
            LTBY_Event.AddFishList += OnAddFish;
            LTBY_Event.S_CSyncFishReq += OnSyncFishReq;
            LTBY_Event.SCPlayerEnter += OnSyncFishRsp;
            LTBY_Event.SCPlayerYCEnter += OnSyncYCFishRsp;
            LTBY_Event.OnFishDead += CallHitFish;
            LTBY_Event.SCOnShootLK += LTBY_EventOnSCOnShootLK;
            LTBY_Event.S_CHitSpecialFish += CallHitSpecialFish;
            LTBY_Event.S_CTorpedoHit += CallTorpedoHit;
            LTBY_Event.OnLockFish += CallLockFish;
            LTBY_Event.OnCancelLockFish += CallCancelLockFish;
            LTBY_Event.OnYCPre += ChangeScene;
            LTBY_Event.OnYCCome += LTBY_EventOnOnYCCome;
            LTBY_Event.S_CGameInfoNotify += CallGameInfoNotify;
            LTBY_Event.S_CTreasureFishInfo += CallTreasureFishInfo;
            LTBY_Event.S_CTreasureFishCatched += TreasureBowlCaptured;
            LTBY_Event.SCOnKillDJZY += LTBY_EventOnSCOnKillDJZY;
        }

        private void UnregisterEvent()
        {
            LTBY_Event.AddFishList -= OnAddFish;
            LTBY_Event.S_CSyncFishReq -= OnSyncFishReq;
            LTBY_Event.SCPlayerEnter -= OnSyncFishRsp;
            LTBY_Event.SCPlayerYCEnter -= OnSyncYCFishRsp;
            LTBY_Event.OnFishDead -= CallHitFish;
            LTBY_Event.SCOnShootLK -= LTBY_EventOnSCOnShootLK;
            LTBY_Event.S_CHitSpecialFish -= CallHitSpecialFish;
            LTBY_Event.S_CTorpedoHit -= CallTorpedoHit;
            LTBY_Event.OnLockFish -= CallLockFish;
            LTBY_Event.OnCancelLockFish -= CallCancelLockFish;
            LTBY_Event.OnYCPre -= ChangeScene;
            LTBY_Event.OnYCCome -= LTBY_EventOnOnYCCome;
            LTBY_Event.S_CGameInfoNotify -= CallGameInfoNotify;
            LTBY_Event.S_CTreasureFishInfo -= CallTreasureFishInfo;
            LTBY_Event.S_CTreasureFishCatched -= TreasureBowlCaptured;
            LTBY_Event.SCOnKillDJZY -= LTBY_EventOnSCOnKillDJZY;
        }

        public bool IsChangeSceneFinish()
        {
            return ChangeSceneFinish;
        }

        /// <summary>
        /// 切换场景
        /// </summary>
        /// <param name="obj"></param>
        void ChangeScene(LTBY_Struct.CMD_S_YuChaoComePre obj)
        {
            ChangeSceneFinish = false;
            MoveOut(1.5f);
        }

        private void LTBY_EventOnOnYCCome(LTBY_Struct.CMD_S_YuChaoCome ycdata)
        {
            System.GC.Collect();
            //鱼潮来了
            //这个是鱼阵
            FishArrayList list = FishArray.YCArray[ycdata.YuChaoId];
            if (list.RoadList == null)
            {
                DebugHelper.LogError($"没有鱼潮路线：{ycdata.YuChaoId}");
                return;
            }

            int count = 0;
            int id = 100;
            for (int j = 0; j < list.RoadList.Count; j++)
            {
                int _index = j;
                SCFishTracesList data = new SCFishTracesList
                {
                    fish_traces = new List<Fish_Traces>(),
                    fish_road = list.RoadList[_index],
                    fish_array = ycdata.YuChaoId,
                    create_interval=Time.deltaTime,
                };
                for (int i = 0; i < list.list.Count; i++)
                {
                    int index = i;
                    FishDataConfig dataConfig =
                        FishConfig.Fish.FindItem(p => p.fishOrginType == list.list[index].fishType);
                    if (dataConfig == null) continue;
                    id++;
                    data.fish_traces.Add(new Fish_Traces()
                    {
                        fish_uid = id,
                        fish_type = dataConfig.fishOrginType,
                        groupIndex = count,
                        fish_stage = 0,
                        is_aced = false
                    });
                    count++;
                    if (count >= list.list.Count) count = 0;
                }

                OnFishTracesList(data, true);
            }
        }

        private void UseMissileEffect(SCTorpedoHit data)
        {
            if (!LTBY_GameView.GameInstance.IsPlayerInRoom(data.chair_idx)) return;

            int chairId = data.chair_idx;
            long earn = data.earn;
            long score = data.score;
            Vector3 worldPos = new Vector3(data.x, data.y);

            if (LTBY_GameView.GameInstance.IsSelf(data.chair_idx))
                LTBY_DataReport.Instance.Get("导弹", earn);
            else
                LTBY_GameView.GameInstance.SetScore(chairId, score);


            var effect = LTBY_EffectManager.Instance.CreateMissile(chairId, data.propId);
            Vector3 aimPos = effect.GetNumWorldPos();

            Action callBack = () =>
            {
                effect.AddScore(earn, 2);
                effect.SettleAccount(3.5f);
            };
            EffectParamData paramData = new EffectParamData()
            {
                level = 2,
                pos = worldPos,
                playSound = true,
            };
            LTBY_EffectManager.Instance.CreateEffect<ExplosionPoint>(chairId, paramData);
            paramData = new EffectParamData()
            {
                score = earn,
                worldPos = worldPos,
                aimPos = aimPos,
                showText = false,
                callBack = callBack,
            };
            LTBY_EffectManager.Instance.CreateEffect<FlyCoin>(chairId, paramData);
        }


        private void UseEffect(FishClass fish, SCHitFish data)
        {
            if (!LTBY_GameView.GameInstance.IsPlayerInRoom(data.chair_idx)) return;

            if (LTBY_GameView.GameInstance.IsSelf(data.chair_idx))
            {
                LTBY_GameView.GameInstance.SetScore(data.chair_idx, data.user_score);
            }
            int chairId = data.chair_idx;
            long score = data.earn;
            Vector3 worldPos = fish.GetWorldPos();

            if (FishConfig.CheckIsDragon(fish.fishType))
            {
                EffectParamData paramData;
                if (FishConfig.CheckIsElectricDragon(fish.fishType))
                {
                    int cs = GameData.Instance.ElectricDragonMultiple;
                    if (cs <= 0) return;
                    int result = 0;
                    Dictionary<int, int> keys = new Dictionary<int, int>();
                    while (cs > 0)
                    {
                        if (GameData.Instance.ElectricDragonMultiple % cs > 0)
                        {
                            cs--;
                            continue;
                        }

                        result = GameData.Instance.ElectricDragonMultiple / cs;
                        keys.Add(cs, result);
                        cs--;
                    }

                    if (keys.Count > 2)
                    {
                        if (keys.ContainsKey(1)) keys.Remove(1);
                        if (keys.ContainsKey(GameData.Instance.ElectricDragonMultiple)) keys.Remove(GameData.Instance.ElectricDragonMultiple);
                    }
                    List<int> ks = new List<int>(keys.Keys);
                    int index = Random.Range(0, ks.Count);
                    paramData = new EffectParamData()
                    {
                        isElectricDragon = true,
                        worldPos = fish.GetWorldPos(),
                        multiples = new List<int>()
                        {
                            ks[index],
                            keys[ks[index]]
                        },
                        func = () =>
                        {
                            DebugHelper.LogError($"雷龙结算");
                            if (!(data is SCHitSpecialFish spData))
                            {
                                spData = new SCHitSpecialFish
                                {
                                    fish_uid = data.fish_uid,
                                    chair_idx = data.chair_idx,
                                    user_score = data.user_score,
                                    earn = data.earn,
                                    fish_value = data.fish_value,
                                    multiple = data.multiple
                                };
                            }

                            UseDragonBallEffect(fish, spData);
                        }
                    };

                    LTBY_EffectManager.Instance.CreateEffect<ElectricDragonDeadEffect>(chairId, fish.GetBonesWorldPosList(),
                        paramData);
                }
                else
                {
                    paramData = new EffectParamData()
                    {
                        score = data.earn,
                        baseScore = data.fish_value
                    };
                    LTBY_EffectManager.Instance.CreateEffect<DragonDeadEffect>(chairId, fish.GetBonesWorldPosList(),
                        paramData);
                }
            }
            else if (LTBY_BatteryManager.Instance.GetDrill(data.chair_idx) != null &&
                     LTBY_BatteryManager.Instance.GetDrill(data.chair_idx).isShoot)
            {
                //使用电钻炮阶段

                var effect = LTBY_EffectManager.Instance.GetDrill(chairId);
                if (effect == null)
                {
                    effect = LTBY_EffectManager.Instance.CreateDrill(chairId);
                }

                Vector3 aimPos = effect.GetNumWorldPos();

                Action callBack = () => { effect?.AddScore(score); };
                EffectParamData paramData = new EffectParamData()
                {
                    level = fish.explosionPointLevel,
                    pos = worldPos,
                    playSound = true,
                };
                LTBY_EffectManager.Instance.CreateEffect<ExplosionPoint>(chairId, paramData);
                paramData = new EffectParamData()
                {
                    score = score,
                    worldPos = worldPos,
                    aimPos = aimPos,
                    showText = true,
                    callBack = callBack,
                };
                LTBY_EffectManager.Instance.CreateEffect<FlyCoin>(chairId, paramData);
            }
            else if (LTBY_BatteryManager.Instance.GetElectric(data.chair_idx) != null &&
                     LTBY_BatteryManager.Instance.GetElectric(data.chair_idx).isShoot)
            {
                //使用电磁炮阶段

                var effect = LTBY_EffectManager.Instance.GetElectric(chairId);
                if (effect == null)
                {
                    effect = LTBY_EffectManager.Instance.CreateElectric(chairId);
                }

                var aimPos = effect.GetNumWorldPos();

                Action callBack = () => { effect.AddScore(score); };
                EffectParamData paramData = new EffectParamData()
                {
                    level = fish.explosionPointLevel,
                    pos = worldPos,
                    playSound = true,
                };
                LTBY_EffectManager.Instance.CreateEffect<ExplosionPoint>(chairId, paramData);
                paramData = new EffectParamData()
                {
                    score = score,
                    worldPos = worldPos,
                    aimPos = aimPos,
                    showText = true,
                    callBack = callBack,
                };
                LTBY_EffectManager.Instance.CreateEffect<FlyCoin>(chairId, paramData);
            }
            else if (LTBY_BatteryManager.Instance.GetFreeBattery(data.chair_idx) != null &&
                     LTBY_BatteryManager.Instance.GetFreeBattery(data.chair_idx).isShoot)
            {
                //免费炮阶段

                var effect = LTBY_EffectManager.Instance.GetFreeBattery(chairId) ?? LTBY_EffectManager.Instance.CreateFreeBattery(chairId);

                var aimPos = effect.GetNumWorldPos();

                Action callBack = () => { effect.AddScore(score); };

                EffectParamData paramData = new EffectParamData()
                {
                    level = fish.explosionPointLevel,
                    pos = worldPos,
                    playSound = true,
                };
                LTBY_EffectManager.Instance.CreateEffect<ExplosionPoint>(chairId, paramData);
                paramData = new EffectParamData()
                {
                    score = score,
                    worldPos = worldPos,
                    aimPos = aimPos,
                    showText = true,
                    callBack = callBack,
                    useMul = data.multiple,
                };
                LTBY_EffectManager.Instance.CreateEffect<FlyCoin>(chairId, paramData);
            }
            else if (fish.isCoinOutburstFish)
            {
                //使用金币大爆发特效
                LTBY_EffectManager.Instance.CreateEffect<ExplosionPoint>(chairId, new EffectParamData()
                {
                    level = fish.explosionPointLevel,
                    pos = worldPos,
                    playSound = true,
                });

                LTBY_EffectManager.Instance.CreateEffect<CoinOutburst>(chairId, score);

                LTBY_EffectManager.Instance.CreateEffect<Wheel>(chairId, new EffectParamData()
                {
                    pos = fish.GetWorldPos(),
                    showType = "Text",
                    showScore = 0,
                    fishType = fish.fishType,
                    playSound = true,
                });
            }
            else if (FishConfig.CheckUseSpine(data.fish_value) != 0)
            {
                //使用各个等级spine动画

                var level = FishConfig.CheckUseSpine(data.fish_value);
                var fishType = fish.fishType;

                if (level == 4 && LTBY_GameView.GameInstance.IsSelf(chairId))
                {
                    LTBY_EffectManager.Instance.CreateEffect<SpineAwardFullScreen>(chairId, fishType, score, 0.5f);

                    LTBY_EffectManager.Instance.CreateEffect<ExplosionPoint>(chairId, new EffectParamData()
                    {
                        level = fish.explosionPointLevel,
                        pos = worldPos,
                        angles = fish.GetFishAngles(),
                        playSound = true,
                    });
                }
                else
                {
                    var effect = LTBY_EffectManager.Instance.CreateEffect<SpineAwardLevel>(chairId, level, fishType);
                    var aimPos = effect.GetNumWorldPos();
                    Action callBack = () => { effect.AddScore(score); };

                    LTBY_EffectManager.Instance.CreateEffect<ExplosionPoint>(chairId, new EffectParamData()
                    {
                        level = fish.explosionPointLevel,
                        pos = worldPos,
                        playSound = true,
                    });
                    LTBY_EffectManager.Instance.CreateEffect<FlyCoin>(chairId, new EffectParamData()
                    {
                        score = score,
                        worldPos = worldPos,
                        aimPos = aimPos,
                        showText = true,
                        callBack = callBack,
                    });
                }
            }
            else if (FishConfig.CheckUseWheel(data.fish_value))
            {
                //使用转盘特效
                LTBY_EffectManager.Instance.CreateEffect<Wheel>(chairId, new EffectParamData()
                {
                    pos = fish.GetWorldPos(),
                    showType = "Score",
                    showScore = score,
                    fishType = fish.fishType,
                    playSound = true,
                    callBack = () =>
                    {
                        LTBY_GameView.GameInstance.CreateAddUserScoreItem(chairId, score);
                        LTBY_GameView.GameInstance.AddScore(chairId, score);
                    }
                });
            }
            else
            {
                //普通飞金币
                LTBY_EffectManager.Instance.CreateEffect<ExplosionPoint>(chairId, new EffectParamData()
                {
                    level = fish.explosionPointLevel,
                    pos = worldPos,
                    playSound = true,
                });

                LTBY_EffectManager.Instance.CreateEffect<FlyCoin>(chairId, new EffectParamData()
                {
                    score = score,
                    worldPos = worldPos,
                    aimPos = LTBY_GameView.GameInstance.GetCoinWorldPos(chairId),
                    showText = true,
                    callBack = () =>
                    {
                        LTBY_GameView.GameInstance.CreateAddUserScoreItem(chairId, score);
                        LTBY_GameView.GameInstance.AddScore(chairId, score);
                    }
                });
            }
        }

        public void AddFishInScreen(FishClass fish)
        {
            if (fish == null) return;
            if (ScreenList.Contains(fish)) return;
            ScreenList.Add(fish);
        }
        public void RemoveFishInScreen(FishClass fish)
        {
            if (fish == null) return;
            if (!ScreenList.Contains(fish)) return;
            ScreenList.Remove(fish);
        }


        private void LightLinkFish(int chairId, FishClass fish, FishClass subFish)
        {
            LTBY_EffectManager.Instance.CreateEffect<EffectLight>(chairId, fish.GetWorldPos(), subFish.GetWorldPos());
            fish.AddLightBall();
            fish.StopMove();
            subFish.AddLightBall();
            subFish.StopMove();
        }


        public void SetLockFishSwitch(bool flag)
        {
            LockFishSwitch = flag;
            if (LTBY_GameView.GameInstance == null) return;
            UnLockFish(LTBY_GameView.GameInstance.chairId);
            LTBY_Struct.PlayerCancelLockFish playerCancelLock = new LTBY_Struct.PlayerCancelLockFish();
            playerCancelLock.wChairId = (byte) LTBY_GameView.GameInstance.chairId;
            LTBY_Network.Instance.Send(LTBY_Network.SUB_C_PlayerCancalLock, playerCancelLock.Buffer);
        }


        private void SetMissileLockSwitch(bool flag)
        {
            MissileLockSwitch = false;
            FishClass[] fishs = FishList.GetDictionaryValues();
            for (int i = 0; i < fishs.Length; i++)
            {
                var fish = fishs[i];
                if (fish.inScreen && !fish.isDead)
                {
                    fish.MissileLock(flag);
                }
            }

            FishArrayClass[] arrayClasses = FishArrayList.GetDictionaryValues();
            for (int i = 0; i < arrayClasses.Length; i++)
            {
                var v = arrayClasses[i];
                var list = v.GetInScreenAwardFishList();
                for (int j = 0; j < list.Count; j++)
                {
                    var fish = list[j];
                    fish.MissileLock(flag);
                }
            }
        }


        private void Update()
        {
            if (MissileLockSwitch)
            {
                CheckMissileLockUpdate();
            }
            else if (LockFishSwitch)
            {
                CheckLockFishUpdate();
            }
        }

        private void CheckMissileLockUpdate()
        {
            if (!Input.GetMouseButton(0) || !LTBY_BatteryManager.Instance.IsPress()) return;
            Camera cam = LTBYEntry.Instance.GetMainCam();
            Vector3 mousePos = cam.ScreenToWorldPoint(Input.mousePosition);

            Vector2 mousePos2D = new Vector2(mousePos.x, mousePos.y);

            var hit = UnityEngine.Physics2D.Raycast(mousePos2D, new Vector2(0, 0), 1000, FishLayerMask);

            if (hit.collider == null) return;
            int fishId = int.Parse(hit.collider.name);
            var fish = GetFish(fishId);

            if (fish != null && fish.isAwardFish && !fish.isDead)
            {
                var battery = LTBY_BatteryManager.Instance.GetMissile(LTBY_GameView.GameInstance.chairId);
                if (battery == null) return;
                battery.Shoot(fish.GetWorldPos(), fishId);
                LTBY_BatteryManager.Instance.SetPress(false);
            }
            else
            {
                LTBY_ViewManager.Instance.ShowTip(BatteryConfig.MissileTip2);
                LTBY_ViewManager.Instance.GetView<LTBY_SpecialItemView>().ShakeBtn();
            }
        }

        private void CheckLockFishUpdate()
        {
            int chairId = LTBY_GameView.GameInstance.chairId;
            if (Input.GetMouseButton(0) && LTBY_BatteryManager.Instance.IsPress())
            {
                var cam = LTBYEntry.Instance.GetMainCam();
                var mousePos = cam.ScreenToWorldPoint(Input.mousePosition);

                var mousePos2D = new Vector2(mousePos.x, mousePos.y);

                var hit = UnityEngine.Physics2D.Raycast(mousePos2D, new Vector2(0, 0), 1000, FishLayerMask);
                if (hit.collider != null)
                {
                    int _fishId = int.Parse(hit.collider.name);
                    if (LockFish(_fishId, chairId))
                    {
                        SendLockFishMsg(chairId);
                        return;
                    }
                }
            }

            if (GetLockFish(chairId) != null) return;
            var list = LockFishConfig.LockFishList;
            int fishId;

            var keys = list.GetDictionaryKeys();
            if (keys.Length <= 0) return;
            List<int> listArr = new List<int>();
            for (int i = 0; i < keys.Length; i++)
            {
                listArr.Add(keys[i]);
            }

            if (ScreenList.Count <= 0) return;
            for (int i = 0; i < listArr.Count; i++)
            {
                if (ScreenList.Count <= 0) return;
                int index = Random.Range(0, listArr.Count);
                if (list.Count <= index) continue;
                fishId = FishConfig.CheckIsAcedFish(listArr[index]) ? GetInScreenAcedFishId() : GetInScreenFishIdByType(listArr[index]);
                if (fishId <= 0) continue;
                DebugHelper.LogError($"锁定：{listArr[index]}");
                if (!LockFish(fishId, chairId)) continue;
                SendLockFishMsg(chairId);
                return;
            }
            // for (int i = 0; i < keys.Length; i++)
            // {
            //     var item = keys[i];
            //     fishId = FishConfig.CheckIsAcedFish(item) ? GetInScreenAcedFishId() : GetInScreenFishIdByType(item);
            //     if (fishId <= 0) continue;
            //     if (!LockFish(fishId, chairId)) continue;
            //     SendLockFishMsg(chairId);
            //     return;
            // }
        }

        private void SendLockFishMsg(int chairId)
        {
            if (!LockFishList.ContainsKey(chairId)) return;
            LTBY_Struct.PlayerLockFish playerLockFish = new LTBY_Struct.PlayerLockFish();
            playerLockFish.fishId = LockFishList[chairId].fishId;
            playerLockFish.wChairId = (byte) chairId;
            LTBY_Network.Instance.Send(LTBY_Network.SUB_C_PlayerLock, playerLockFish.Buffer);
            //自己或者机器人就自己给自己模拟一个消息
            LTBY_Struct.CMD_S_PlayerLock playerLock = new LTBY_Struct.CMD_S_PlayerLock();
            playerLock.chairId = (byte) chairId;
            playerLock.fishId = LockFishList[chairId].fishId;
            LTBY_Event.DispatchOnLockFish(playerLock);
        }


        /// <summary>
        /// 锁定鱼
        /// </summary>
        /// <param name="fishId"></param>
        /// <param name="chairId"></param>
        /// <returns></returns>
        private bool LockFish(int fishId, int chairId)
        {
            FishClass fish = GetFish(fishId);
            if (fish == null) return false;
            if (fish.isDead) return false;
            BatteryClass battery = LTBY_BatteryManager.Instance.GetBattery(chairId);
            if (battery == null || battery.IsRobot()) return false;
            Vector3 pos = Vector3.zero;
            FishClass _fish = null;
            if (LockFishList.ContainsKey(chairId))
            {
                _fish = LockFishList[chairId];
            }

            if (_fish == fish)
            {
                return false;
            }
            else if (_fish != null)
            {
                pos = _fish.GetLockEffectPos(chairId);
                _fish.UnLock(chairId);
            }

            LockFishList.Remove(chairId);
            LockFishList.Add(chairId, fish);
            LockFishList[chairId].Lock(chairId, pos);

            LTBY_GameView.GameInstance.ShowLockFishImage(true, chairId,
                fish.isAced ? FishConfig.AcedFishType : fish.fishType);
            return true;
        }

        /// <summary>
        /// 解锁鱼
        /// </summary>
        /// <param name="chairId"></param>
        public void UnLockFish(int chairId)
        {
            if (!LockFishList.ContainsKey(chairId)) return;
            LockFishList[chairId].UnLock(chairId);
            LockFishList.Remove(chairId);
            LTBY_GameView.GameInstance.ShowLockFishImage(false, chairId);
        }

        public bool CheckIsLockFish(int fishId)
        {
            FishClass[] fishs = LockFishList.GetDictionaryValues();
            for (int i = 0; i < fishs.Length; i++)
            {
                var item = fishs[i];
                if (item.fishId == fishId)
                {
                    return true;
                }
            }

            return false;
        }


        public FishClass GetLockFish(int chairId)
        {
            LockFishList.TryGetValue(chairId, out FishClass fish);
            return fish;
        }

        public int GetInScreenFishIdByType(int fishType)
        {
            if (ScreenList.Count <= 0) return 0;
            FishClass[] fishs = FishList.GetDictionaryValues();
            for (int i = 0; i < fishs.Length; i++)
            {
                var item = fishs[i];
                if (item.inScreen && !item.isDead && item.fishType == fishType)
                {
                    return item.fishId;
                }
            }

            FishArrayClass[] fishArrays = FishArrayList.GetDictionaryValues();
            for (int i = 0; i < fishArrays.Length; i++)
            {
                var item = fishArrays[i];
                int fishId = item.GetInScreenFishIdByType(fishType);
                if (fishId > 0)
                {
                    return fishId;
                }
            }

            return 0;
        }

        private int GetInScreenAcedFishId()
        {
            if (ScreenList.Count <= 0) return 0;
            FishClass[] fishs = FishList.GetDictionaryValues();
            for (int i = 0; i < fishs.Length; i++)
            {
                var v = fishs[i];
                if (v.inScreen && !v.isDead && v.isAced)
                {
                    return v.fishId;
                }
            }

            FishArrayClass[] fishArrays = FishArrayList.GetDictionaryValues();
            for (int i = 0; i < fishArrays.Length; i++)
            {
                var v = fishArrays[i];
                int fishId = v.GetInScreenAcedFishId();
                if (fishId > 0)
                {
                    return fishId;
                }
            }

            return 0;
        }

        public List<short> GetAcedFishIdList(int fishId = 0)
        {
            List<short> list = new List<short>();
            FishClass[] fishs = FishList.GetDictionaryValues();
            for (int i = 0; i < fishs.Length; i++)
            {
                FishClass v = fishs[i];
                if (fishId != 0 && fishId == v.fishId) continue;
                if (!v.isDead && v.isAced)
                {
                    list.Add((short) v.fishId);
                }
            }

            FishArrayClass[] fishArrays = FishArrayList.GetDictionaryValues();
            for (int i = 0; i < fishArrays.Length; i++)
            {
                FishArrayClass v = fishArrays[i];
                List<int> _list = v.GetAcedFishIdList();
                for (int j = 0; j < _list.Count; j++)
                {
                    if (fishId != 0 && fishId == _list[j]) continue;
                    list.Add((short) _list[j]);
                }
            }

            return list;
        }

        public List<short> GetInScreenFishIdByKindList(int kind,int fishId = 0)
        {
            List<short> list = new List<short>();
            if (ScreenList.Count <= 0) return list;
            FishClass[] fishs = FishList.GetDictionaryValues();
            for (int i = 0; i < fishs.Length; i++)
            {
                FishClass v = fishs[i];
                if (fishId != 0 && fishId == v.fishId) continue;
                if (!v.inScreen || v.isDead) continue;
                switch (kind)
                {
                    case 140:
                        if (v.fishType != 102) continue;
                        break;
                    case 139:
                        if (v.fishType != 101) continue;
                        break;
                    case 132:
                        if (v.fishType > 108) continue;
                        break;
                }
                list.Add((short) v.fishId);
            }

            FishArrayClass[] fishArrays = FishArrayList.GetDictionaryValues();
            for (int i = 0; i < fishArrays.Length; i++)
            {
                FishArrayClass v = fishArrays[i];
                List<FishClass> _list = v.GetInScreenFishClassList();
                for (int j = 0; j < _list.Count; j++)
                {
                    if (fishId != 0 && fishId == _list[j].fishId) continue;
                    switch (kind)
                    {
                        case 140:
                            if (_list[j].fishType != 102) continue;
                            break;
                        case 139:
                            if (_list[j].fishType != 101) continue;
                            break;
                        case 132:
                            if (_list[j].fishType > 108) continue;
                            break;
                    }
                    list.Add((short) _list[j].fishId);
                }
            }

            return list;
        }
        public List<short> GetInScreenFishIdList(int fishId = 0)
        {
            List<short> list = new List<short>();
            if (ScreenList.Count <= 0) return list;
            FishClass[] fishs = FishList.GetDictionaryValues();
            for (int i = 0; i < fishs.Length; i++)
            {
                FishClass v = fishs[i];
                if (fishId != 0 && fishId == v.fishId) continue;
                if (v.inScreen && !v.isDead)
                {
                    list.Add((short) v.fishId);
                }
            }

            FishArrayClass[] fishArrays = FishArrayList.GetDictionaryValues();
            for (int i = 0; i < fishArrays.Length; i++)
            {
                FishArrayClass v = fishArrays[i];
                List<int> _list = v.GetInScreenFishIdList();
                for (int j = 0; j < _list.Count; j++)
                {
                    if (fishId != 0 && fishId == _list[j]) continue;
                    list.Add((short) _list[j]);
                }
            }

            return list;
        }

        List<FishClass> list = new List<FishClass>();
        public List<FishClass> GetInScreenNormalFishId()
        {
            list.Clear();
            if (ScreenList.Count <= 0) return list;
            List<FishClass> fishs = new List<FishClass>(FishList.Values);
            for (int i = 0; i < fishs.Count; i++)
            {
                FishClass v = fishs[i];
                if (!FishConfig.CheckIsNormalFish(v.fishType)) continue;
                if (!v.inScreen || v.isDead) continue;
                list.Add(v);
            }

            List<FishArrayClass> fishArrays = new List<FishArrayClass>(FishArrayList.Values);
            for (int i = 0; i < fishArrays.Count; i++)
            {
                FishArrayClass v = fishArrays[i];
                List<FishClass> _list = v.GetInScreenFishClassList();
                for (int j = 0; j < _list.Count; j++)
                {
                    if (!FishConfig.CheckIsNormalFish(_list[j].fishType)) continue;
                    if (!_list[j].inScreen || _list[j].isDead) continue;
                    list.Add(_list[j]);
                }
            }

            return list;
        }

        public int AllocateZOrder()
        {
            FishZOrder += 4;
            if (FishZOrder >= 120)
            {
                FishZOrder = 0;
            }

            return FishZOrder;
        }

        private int AllocateArrayId()
        {
            FishArrayId++;
            return FishArrayId;
        }

        private void OnAddFish(LTBY_Struct.CMD_S_AddFish addFish)
        {
            SCFishTracesList data = new SCFishTracesList();
            data.fish_traces = new List<Fish_Traces>();
            bool isFishGroup = addFish.loadFishList[0].cbGroupId > 0;
            if (isFishGroup)
            {
                //这个是鱼阵
                data.fish_road = addFish.loadFishList[0].nRoad;
                data.fish_array = addFish.loadFishList[0].cbGroupId;
                for (int i = 0; i < addFish.loadFishList.Count; i++)
                {
                    if (addFish.loadFishList[i].id <= 0) continue;
                    int index = i;
                    if (addFish.loadFishList[index].Kind > FishConfig.fishCount)
                    {
                        addFish.loadFishList[index].Kind -= FishConfig.fishCount;
                        addFish.loadFishList[index].Kind += 8;
                        addFish.loadFishList[index].cbIsAced = true;
                    }
                    FishDataConfig dataConfig =
                        FishConfig.Fish.FindItem(p => p.fishType == addFish.loadFishList[index].Kind);
                    if (dataConfig == null) continue;
                    data.fish_traces.Add(new Fish_Traces()
                    {
                        fish_uid = addFish.loadFishList[index].id,
                        fish_type = dataConfig.fishOrginType,
                        groupIndex = addFish.loadFishList[index].cbGroupNo,
                        fish_stage = addFish.loadFishList[index].cbStage,
                        is_aced = addFish.loadFishList[index].cbIsAced,
                    });
                }

                OnFishTracesList(data);
            }
            else
            {
                for (int i = 0; i < addFish.loadFishList.Count; i++)
                {
                    if (addFish.loadFishList[i].id <= 0) continue;
                    int index = i;
                    if (addFish.loadFishList[index].Kind > FishConfig.fishCount &&
                        addFish.loadFishList[index].Kind < 47)
                    {
                        addFish.loadFishList[index].Kind -= FishConfig.fishCount;
                        addFish.loadFishList[index].Kind += 8;
                        addFish.loadFishList[index].cbIsAced = true;
                    }
                    data.fish_traces.Clear();
                    data.fish_road = addFish.loadFishList[i].nRoad;
                    data.fish_array = addFish.loadFishList[i].cbGroupId;
                    FishDataConfig dataConfig =
                        FishConfig.Fish.FindItem(p => p.fishType == addFish.loadFishList[index].Kind);
                    if (dataConfig == null) continue;
                    data.fish_traces.Add(new Fish_Traces()
                    {
                        fish_uid = addFish.loadFishList[index].id,
                        fish_type = dataConfig.fishOrginType,
                        is_aced= addFish.loadFishList[index].cbIsAced,
                        fish_stage = addFish.loadFishList[index].cbStage,
                    });

                    OnFishTracesList(data);
                }
            }
        }

        private FishDataSave.Data GetRoadTotalTime(int roadIndex)
        {
            FishDataSave savedata = new FishDataSave();
            savedata.data = new List<FishDataSave.Data>();
            FishRoadList roadConfig = null;
            if (FishRoadConfig.FishRoads.ContainsKey(roadIndex))
            {
                roadConfig = FishRoadConfig.FishRoads[roadIndex];
            }

            float timer = 0;
            float _timer = 0;
            FishDataSave.Data save = new FishDataSave.Data();
            if (roadConfig != null)
            {
                float speed = 0.5f;
                float mt = 0;
                float _mt = 0;
                save.roadName = roadConfig.RoadName;
                save.subTime = new List<int>();
                save.mtlist = new List<float>();
                for (int j = 0; j < roadConfig.list.Count; j++)
                {
                    if (j == roadConfig.list.Count - 1) continue;
                    mt = 0;
                    _mt = 0;
                    speed = roadConfig.list[j + 1].speed * 0.1f;
                    while (mt < 1)
                    {
                        mt += speed * Time.deltaTime;
                        _mt += Time.deltaTime;
                    }

                    timer += mt;
                    _timer += _mt;
                    save.subTime.Add((int) (_mt * 1000));
                    save.mtlist.Add(mt);
                }
            }

            save.totalTime = (int) (_timer * 1000);
            return save;
        }

        /// <summary>
        /// 普通产鱼
        /// </summary>
        /// <param name="data"></param>
        /// <param name="isYC"></param>
        public void OnFishTracesList(SCFishTracesList data, bool isYC = false)
        {
            ChangeSceneFinish = true;
            if (data.fish_array == 0)
            {
                var roadConfig = FishRoadConfig.FishRoads[data.fish_road];

                for (int i = 0; i < data.fish_traces.Count; i++)
                {
                    var v = data.fish_traces[i];
                    if (!fishConfig.ContainsKey(v.fish_type))
                    {
                        DebugHelper.Log($"{v.fish_type}类型的鱼没有配置表");
                    }
                    else
                    {
                        DestroyFish(v.fish_uid, false);
                        var fish = CreateFish(v.fish_uid, v.fish_type, FishParent);

                        fish.SetIsAced(v.is_aced);
                        if (FishConfig.CheckIsDragon(v.fish_type))
                        {
                            fish.InitRoad(data.fish_road);
                        }
                        else
                        {
                            fish.SetIsSummon(data.is_called);
                            fish.InitRoad(roadConfig.list, i * data.create_interval);
                        }

                        fish.SetFishRoad(data.fish_road);
                    }
                }
            }
            else
            {
                List<FishArrayParams> tracesList = new List<FishArrayParams>();

                var arrayConfig = isYC ? LTBY.FishArray.YCArray[data.fish_array] : LTBY.FishArray.NormalArray[data.fish_array];

                for (int i = 0; i < data.fish_traces.Count; i++)
                {
                    var item = data.fish_traces[i];
                    var t = new FishArrayParams
                    {
                        fishId = item.fish_uid,
                        fishType = item.fish_type,
                        isAced = item.is_aced,
                        x = arrayConfig.list[item.groupIndex].x,
                        y = arrayConfig.list[item.groupIndex].y,
                    };
                    tracesList.Add(t);
                    DestroyFish(item.fish_uid, false);
                }

                var FishArray = CreateFishArray(tracesList, FishParent);
                var roadConfig = FishRoadConfig.FishRoads[data.fish_road];
                FishArray.InitRoad(roadConfig.list);
                FishArray.SetFishRoad(data.fish_road);
                FishArray.SetFishArray(data.fish_array);
            }
        }


        /// <summary>
        /// 服务器请求客户端同步鱼
        /// </summary>
        /// <param name="data"></param>
        void OnSyncFishReq(SCSyncFishReq data)
        {
        }

        /// <summary>
        /// 服务器返回客户端鱼潮同步鱼
        /// </summary>
        private void OnSyncYCFishRsp(LTBY_Struct.CMD_S_Player_YC_Enter playerEnter)
        {
            if (playerEnter.YcId <= 0) return;
            SyncFishArray(playerEnter);
        }

        /// <summary>
        /// 服务器返回客户端同步鱼
        /// </summary>
        /// <param name="playerEnter"></param>
        void OnSyncFishRsp(LTBY_Struct.CMD_S_PlayerEnter playerEnter)
        {
            Dictionary<string, List<LTBY_Struct.LoadFish>> fishArray =
                new Dictionary<string, List<LTBY_Struct.LoadFish>>();
            List<LTBY_Struct.LoadFish> fishs = new List<LTBY_Struct.LoadFish>();
            for (int i = 0; i < playerEnter.szLoadFish.Count; i++)
            {
                LTBY_Struct.LoadFish loadFish = playerEnter.szLoadFish[i];
                if (loadFish.cbGroupId == 0)
                {
                    fishs.Add(loadFish);
                }
                else
                {
                    if (!fishArray.ContainsKey($"{loadFish.cbGroupId}{loadFish.CreateTime}"))
                    {
                        fishArray.Add($"{loadFish.cbGroupId}{loadFish.CreateTime}", new List<LTBY_Struct.LoadFish>());
                    }

                    fishArray[$"{loadFish.cbGroupId}{loadFish.CreateTime}"].Add(loadFish);
                }
            }

            SyncNormalFish(fishs);
            SyncFishArray(fishArray);
        }

        /// <summary>
        /// 同步普通鱼
        /// </summary>
        /// <param name="fishs">普通鱼数组</param>
        private void SyncNormalFish(List<LTBY_Struct.LoadFish> fishs)
        {
            for (int j = 0; j < fishs.Count; j++)
            {
                if (fishs[j].id <= 0) continue;
                LTBY_Struct.LoadFish loadFish = fishs[j];
                if (loadFish.NowTime >= loadFish.EndTime) continue;
                SCSyncFishRsp data = new SCSyncFishRsp();
                // TODO 设置鱼的鱼阵和鱼线
                
                if (loadFish.Kind > FishConfig.fishCount)
                {
                    loadFish.Kind -= FishConfig.fishCount;
                    loadFish.Kind += 8;
                    loadFish.cbIsAced = true;
                }
                data.fish_array = loadFish.cbGroupId;
                data.fish_road = loadFish.nRoad;
                data.fish_traces = new List<Fish_Traces>();
                FishDataConfig config = FishConfig.Fish.FindItem(p => p.fishType == loadFish.Kind);
                Fish_Traces item = new Fish_Traces()
                {
                    fish_uid = loadFish.id,
                    fish_type = config.fishOrginType,
                };
                switch (config.fishOrginType)
                {
                    case 145: //聚宝盆
                        item.fish_stage = loadFish.cbJBPStage > 0 ? loadFish.cbJBPStage : 1;
                        break;
                    case 109: //河豚
                        item.fish_stage = loadFish.cbStage > 0 ? loadFish.cbStage + 1 : 1;
                        break;
                }

                FishDataSave.Data dataSave = GetRoadTotalTime(data.fish_road);
                data.road_idx = 0;
                int nowtime = loadFish.NowTime;
                float rate = 0;
                for (int i = 0; i < dataSave.subTime.Count; i++)
                {
                    if (nowtime >= dataSave.subTime[i])
                    {
                        data.road_idx++;
                        nowtime -= dataSave.subTime[i];
                    }
                    else
                    {
                        rate = (float) nowtime / dataSave.subTime[i];
                        break;
                    }
                }

                if (dataSave.mtlist.Count > data.road_idx)
                {
                    data.move_t = dataSave.mtlist[data.road_idx] * rate;
                }

                ChangeSceneFinish = true;
                if (!FishRoadConfig.FishRoads.ContainsKey(data.fish_road)) continue;
                FishRoadList roadConfig = FishRoadConfig.FishRoads[data.fish_road];

                if (!fishConfig.ContainsKey(item.fish_type))
                {
                    DebugHelper.Log($"{item.fish_type}类型的鱼没有配置表");
                }
                else
                {
                    DestroyFish(item.fish_uid, false);
                    var fish = CreateFish(item.fish_uid, item.fish_type, FishParent);
                    fish.SetZOrder(item.fish_layer);
                    fish.SetGrowStage(item.fish_stage);
                    fish.SetIsAced(item.is_aced);
                    if (FishConfig.CheckIsDragon(item.fish_type))
                    {
                        data.road_idx = 0;
                        data.move_t = (float) nowtime / 11666;
                        fish.InitRoad(data.fish_road, data.move_delay, data.road_idx, data.move_t);
                    }
                    else
                    {
                        fish.InitRoad(roadConfig.list, data.move_delay, data.road_idx, data.move_t);
                    }

                    fish.SetFishRoad(data.fish_road);
                    if (!FishConfig.CheckIsTreasureBowl(config.fishOrginType)) continue;
                    SCTreasureFishInfo info = new SCTreasureFishInfo
                    {
                        fish_uid = loadFish.id,
                        fish_value = loadFish.cbJBPMul,
                        cur_stage = loadFish.cbJBPStage,
                        accum_money = loadFish.cbJBPScore
                    };
                    LTBY_Event.DispatchSCTreasureFishInfo(info);
                }
            }
        }

        /// <summary>
        /// 同步鱼组
        /// </summary>
        /// <param name="fishArray">鱼组数组</param>
        private void SyncFishArray(Dictionary<string, List<LTBY_Struct.LoadFish>> fishArray)
        {
            string[] keys = fishArray.GetDictionaryKeys();
            for (int i = 0; i < keys.Length; i++)
            {
                List<LTBY_Struct.LoadFish> fishes = fishArray[keys[i]];
                FishArrayList arrayConfig = LTBY.FishArray.NormalArray[fishes[0].cbGroupId];
                List<FishArrayParams> tracesList = new List<FishArrayParams>();
                for (int j = 0; j < fishes.Count; j++)
                {
                    LTBY_Struct.LoadFish item = fishes[j];
                    if (item.NowTime >= item.EndTime) continue;

                    if (item.Kind > FishConfig.fishCount)
                    {
                        item.Kind -= FishConfig.fishCount;
                        item.Kind += 8;
                        item.cbIsAced = true;
                    }
                    FishDataConfig config = FishConfig.Fish.FindItem(p => p.fishType == item.Kind);
                    if (config == null) continue;
                    var t = new FishArrayParams
                    {
                        fishId = item.id,
                        fishType = config.fishOrginType,
                        fishStage = item.cbStage,
                        isAced = item.cbIsAced,
                        x = arrayConfig.list[item.cbGroupNo].x,
                        y = arrayConfig.list[item.cbGroupNo].y
                    };
                    tracesList.Add(t);
                    DestroyFish(item.id, false);
                }

                if (tracesList.Count <= 0) continue;
                var FishArray = CreateFishArray(tracesList, FishParent);
                if (!FishRoadConfig.FishRoads.ContainsKey(fishes[0].nRoad)) continue;
                var roadConfig = FishRoadConfig.FishRoads[fishes[0].nRoad];
                FishDataSave.Data dataSave = GetRoadTotalTime(fishes[0].nRoad);
                int road_idx = 0;
                int nowtime = fishes[0].NowTime;
                float rate = 0;
                for (int j = 0; j < dataSave.subTime.Count; j++)
                {
                    if (nowtime >= dataSave.subTime[j])
                    {
                        nowtime -= dataSave.subTime[j];
                    }
                    else
                    {
                        rate = (float) nowtime / dataSave.subTime[j];
                        road_idx = j;
                        break;
                    }
                }

                float move_t = dataSave.mtlist[road_idx] * rate;
                FishArray.InitRoad(roadConfig.list, Time.deltaTime, road_idx, move_t);
                FishArray.SetFishRoad(fishes[0].nRoad);
                FishArray.SetFishArray(fishes[0].cbGroupId);
            }
        }

        /// <summary>
        /// 同步鱼潮
        /// </summary>
        /// <param name="data">初始化信息</param>
        private void SyncFishArray(LTBY_Struct.CMD_S_Player_YC_Enter data)
        {
            FishArrayList arrayConfig = LTBY.FishArray.YCArray[data.YcId];

            for (int i = 0; i < arrayConfig.RoadList.Count; i++)
            {
                List<LTBY_Struct.LoadFish> fishes = data.szLoadFish;
                List<FishArrayParams> tracesList = new List<FishArrayParams>();
                for (int j = 0; j < fishes.Count; j++)
                {
                    LTBY_Struct.LoadFish item = fishes[j];
                    if (item.NowTime >= item.EndTime) continue;
                    FishDataConfig config = FishConfig.Fish.FindItem(p => p.fishType == item.Kind);
                    if (config == null) continue;
                    if (item.cbGroupNo >= arrayConfig.list.Count) item.cbGroupNo -= (byte) arrayConfig.list.Count;
                    var t = new FishArrayParams
                    {
                        fishId = item.id,
                        fishType = config.fishOrginType,
                        fishStage = item.cbStage,
                        isAced = item.cbIsAced,
                        x = arrayConfig.list[item.cbGroupNo].x,
                        y = arrayConfig.list[item.cbGroupNo].y
                    };
                    tracesList.Add(t);
                    DestroyFish(item.id, false);
                }

                if (tracesList.Count <= 0) continue;
                var FishArray = CreateFishArray(tracesList, FishParent);
                if (!FishRoadConfig.FishRoads.ContainsKey(arrayConfig.RoadList[i])) continue;
                var roadConfig = FishRoadConfig.FishRoads[arrayConfig.RoadList[i]];
                FishDataSave.Data dataSave = GetRoadTotalTime(arrayConfig.RoadList[i]);
                int road_idx = 0;
                int nowtime = fishes[0].NowTime;
                float rate = 0;
                for (int j = 0; j < dataSave.subTime.Count; j++)
                {
                    if (nowtime >= dataSave.subTime[j])
                    {
                        nowtime -= dataSave.subTime[j];
                    }
                    else
                    {
                        rate = (float) nowtime / dataSave.subTime[j];
                        road_idx = j;
                        break;
                    }
                }

                float move_t = dataSave.mtlist[road_idx] * rate;
                FishArray.InitRoad(roadConfig.list, Time.deltaTime, road_idx, move_t);
                FishArray.SetFishRoad(arrayConfig.RoadList[i]);
                FishArray.SetFishArray(data.YcId);
            }
        }

        public FishClass CreateFish(int fishId, int fishType, Transform parent)
        {
            var fish = GetFishFromPool(fishType, parent);
            fish.OnCreate(fishId);
            FishList.Add(fishId, fish);
            return fish;
        }

        private FishArrayClass CreateFishArray(List<FishArrayParams> traces, Transform parent)
        {
            int arrayId = AllocateArrayId();

            FishArrayClass array = new FishArrayClass();
            array.OnCreate(arrayId, traces, parent);

            FishArrayList.Add(arrayId, array);
            return array;
        }


        public void DestroyFish(int fishId, bool sendMsgToServer = false)
        {
            FishList.TryGetValue(fishId, out FishClass fish);

            if (fish != null)
            {
                fish.OnDestroy();
                FishList.Remove(fishId);
            }
            else
            {
                var fishArrays = FishArrayList.GetDictionaryValues();
                for (int i = 0; i < fishArrays.Length; i++)
                {
                    var v = fishArrays[i];
                    var _fish = v.DestroyFish(fishId, sendMsgToServer);
                    if (_fish) break;
                }
            }
        }


        public void DestroyFishArray(int arrayId, bool sendMsgToServer)
        {
            FishArrayList.TryGetValue(arrayId, out FishArrayClass array);
            if (array == null) return;
            array.OnDestroy(sendMsgToServer);
            FishArrayList.Remove(arrayId);
        }


        public void DestroyAllFish(bool sendMsgToServer)
        {
            FishClass[] fishs = FishList.GetDictionaryValues();
            for (int i = 0; i < fishs.Length; i++)
            {
                var item = fishs[i];
                item.OnDestroy(sendMsgToServer);
            }

            FishList.Clear();
            FishArrayClass[] fishArrays = FishArrayList.GetDictionaryValues();
            for (int i = 0; i < fishArrays.Length; i++)
            {
                var item = fishArrays[i];
                item.OnDestroy(sendMsgToServer);
            }

            FishArrayList.Clear();
        }

        private FishClass OnCapture(int fishId)
        {
            FishList.TryGetValue(fishId, out FishClass fish);

            if (fish != null)
            {
                fish.OnCapture();
            }
            else
            {
                int[] keys = FishArrayList.GetDictionaryKeys();
                for (int i = 0; i < keys.Length; i++)
                {
                    var item = FishArrayList[keys[i]];
                    fish = item.GetFish(fishId);

                    if (fish == null) continue;
                    if (fish.OnCapture())
                    {
                        fish.SetParent(FishParent);
                    }

                    break;
                }
            }

            return fish;
        }


        public void PlayOnlySound(string name)
        {
            if (string.IsNullOrEmpty(name)) return;

            if (PlayOnlySoundKey > 0) return;

            PlayOnlySoundKey = LTBY_Extend.Instance.DelayRun(3f, () => { PlayOnlySoundKey = 0; });
            LTBY_Audio.Instance.Play(SoundConfig.AllAudio[name]);
        }


        private void UseAcedEffect(FishClass fish, SCHitSpecialFish data)
        {
            var chairId = data.chair_idx;

            List<EffectParamData> fishList = new List<EffectParamData>();
            var fishList1 = new EffectParamData()
            {
                pos = fish.GetWorldPos(),
                fishType = fish.fishType,
                score = data.fish_value
            };
            fishList.Add(fishList1);

            for (int i = 0; i < data.shock_fishes.Count; i++)
            {
                var item = data.shock_fishes[i];
                var subFish = GetFish(item.id);
                if (subFish != null)
                {
                    subFish.StopMove();
                    subFish.CloseCollider();

                    var fishList2 = new EffectParamData()
                    {
                        pos = subFish.GetWorldPos(),
                        fishType = subFish.fishType,
                        score = item.count,
                        callBack = () => { OnCapture(item.id); }
                    };
                    fishList.Add(fishList2);
                }
                else
                {
                    LTBY_GameView.GameInstance.AddScore(chairId, item.count);
                }
            }

            LTBY_EffectManager.Instance.CreateEffect<Aced>(chairId, new EffectParamData()
            {
                fishList = fishList,
                multiple = data.multiple,
            });
        }


        private void UseLightEffect(FishClass fish, SCHitSpecialFish data)
        {
            var chairId = data.chair_idx;

            List<EffectParamData> fishList = new List<EffectParamData>();

            var fishList1 = new EffectParamData()
            {
                pos = fish.GetWorldPos(),
                score = data.fish_value
            };
            fishList.Add(fishList1);

            for (int i = 0; i < data.shock_fishes.Count; i++)
            {
                var item = data.shock_fishes[i];
                var subFish = OnCapture(item.id);
                if (subFish != null)
                {
                    LightLinkFish(chairId, fish, subFish);
                    var fishList2 = new EffectParamData();
                    fishList2.pos = subFish.GetWorldPos();
                    fishList2.score = item.count;
                    fishList.Add(fishList2);
                }
                else
                {
                    LTBY_GameView.GameInstance.AddScore(chairId, item.count);
                }
            }

            LTBY_Audio.Instance.Play(SoundConfig.LightLink);
            LTBY_EffectManager.Instance.CreateEffect<LightAccount>(chairId, new EffectParamData()
            {
                fishType = fish.fishType,
                fishList = fishList,
                multiple = data.multiple,
                bulletType = data.hit_bullet_type,
            });
        }


        private void UseDialEffect(FishClass fish, SCHitSpecialFish data)
        {
            var chairId = data.chair_idx;

            EffectParamData _dialEffect = new EffectParamData
            {
                pos = fish.GetWorldPos(),
                score = data.earn,
                multiple = data.multiple,
                ratio = data.wheel.ratio,
                mulList = data.wheel.wheels
            };
            LTBY_EffectManager.Instance.CreateEffect<DialFish>(chairId, _dialEffect);
        }


        private void SpecialCaptureEffect(FishClass fish, SCHitSpecialFish data)
        {
            if (!LTBY_GameView.GameInstance.IsPlayerInRoom(data.chair_idx)) return;

            var isSelf = LTBY_GameView.GameInstance.IsSelf(data.chair_idx);

            if (!isSelf)
            {
                LTBY_GameView.GameInstance.SetScore(data.chair_idx, data.user_score);
            }
            else
            {
                //统计自己打死的雷皇龙总分数
                if (PropConfig.CheckIsDragonBall(data.hit_bullet_type))
                {
                    LTBY_DataReport.Instance.AddElectricDragonScore(data.earn);
                    for (int i = 0; i < data.shock_fishes.Count; i++)
                    {
                        LTBY_DataReport.Instance.AddElectricDragonScore(data.shock_fishes[i].count);
                    }
                }
            }

            if (data.earn > 0)
            {
                if (fish.isLightFish) //闪电鱼
                {
                    UseLightEffect(fish, data);
                }
                else if (fish.isAced) //一网打尽鱼
                {
                    UseAcedEffect(fish, data);
                }
                else if (fish.isDialFish)
                {
                    UseDialEffect(fish, data); //连环转盘
                }
                else if (data.grow_stage != 0)
                {
                    fish.SetGrowStage(data.grow_stage); //愤怒河豚
                    UseEffect(fish, data);
                }
                else if (PropConfig.CheckIsDragonBall(data.hit_bullet_type))
                {
                    //被龙珠电死的鱼只显示龙珠爆分并累加分数
                    UseDragonBallEffect(fish, data);
                }
                else
                {
                    if (FishConfig.CheckIsElectricDragon(fish.fishType))
                    {
                        UseLightEffect(fish, data);
                        return;
                    }
                    UseEffect(fish, data);
                }
            }
            else
            {
                if (FishConfig.CheckIsElectricDragon(fish.fishType) && data.death)
                {
                    //雷皇龙捕获
                    List<int> multipleList = new List<int>();

                    // for (int i = 0; i < data.drop_props.Count; i++)
                    // {
                    //     var item = data.drop_props[i];
                    //     if (item.id == PropConfig.DragonBall.id)
                    //     {
                    //         multipleList.Add(item.count);
                    //     }
                    // }
                    
                    int cs = GameData.Instance.ElectricDragonMultiple;
                    if (cs <= 0) return;
                    int result = 0;
                    Dictionary<int, int> keys = new Dictionary<int, int>();
                    while (cs > 0)
                    {
                        if (GameData.Instance.ElectricDragonMultiple % cs > 0)
                        {
                            cs--;
                            continue;
                        }

                        result = GameData.Instance.ElectricDragonMultiple / cs;
                        keys.Add(cs, result);
                        cs--;
                    }
                    if (keys.Count > 2) // 如果不是1或者质数  则把1*倍数和倍数*1去掉
                    {
                        keys.Remove(1);
                        keys.Remove(GameData.Instance.ElectricDragonMultiple);
                    }
                    List<int> ks = new List<int>(keys.Keys);
                    int index = Random.Range(0, ks.Count);

                    int chairId = data.chair_idx;

                    multipleList.Add(ks[index]);
                    multipleList.Add(keys[ks[index]]);
                    LTBY_EffectManager.Instance.CreateEffect<ElectricDragonDeadEffect>(chairId,
                        fish.GetBonesWorldPosList(), new EffectParamData()
                        {
                            isElectricDragon = true,
                            worldPos = fish.GetWorldPos(),
                            multiples = multipleList,
                        });

                    if (isSelf)
                    {
                        LTBY_DataReport.Instance.ResetElectricDragonScore();
                    }
                }
            }

            if (data.drop_props.Count > 0)
            {
                int chairId = data.chair_idx;

                for (int i = 0; i < data.drop_props.Count; i++)
                {
                    var item = data.drop_props[i];
                    EffectParamData config = new EffectParamData
                    {
                        worldPos = fish.GetWorldPos(),
                        angles = fish.GetFishAngles(),
                        id = item.id,
                        count = item.count,
                        ratio = item.ratio,
                        time = item.time,
                        mul = item.multiple
                    };

                    if (PropConfig.CheckIsDrill(item.id))
                    {
                        config.angles.z += 250;
                        config.itemType = "Drill";

                        LTBY_EffectManager.Instance.CreateEffect<DropItem>(chairId, config);

                        if (LTBY_GameView.GameInstance.IsSelf(chairId))
                        {
                            LTBY_BatteryManager.Instance.SetCanShoot(false);
                        }
                    }
                    else if (PropConfig.CheckIsElectric(item.id))
                    {
                        config.angles.z += 250;
                        config.itemType = "Electric";

                        LTBY_EffectManager.Instance.CreateEffect<DropItem>(chairId, config);

                        if (LTBY_GameView.GameInstance.IsSelf(chairId))
                        {
                            LTBY_BatteryManager.Instance.SetCanShoot(false);
                        }
                    }
                    else if (PropConfig.CheckIsFreeBattery(item.id))
                    {
                        config.angles.z += 250;
                        config.itemType = "FreeBattery";

                        LTBY_EffectManager.Instance.CreateEffect<DropItem>(chairId, config);

                        if (LTBY_GameView.GameInstance.IsSelf(chairId))
                        {
                            LTBY_BatteryManager.Instance.SetCanShoot(false);
                        }
                    }
                    else if (PropConfig.CheckIsScratchCard(item.id))
                    {
                        config.angles.z = 0;
                        if (LTBY_GameView.GameInstance.IsSelf(chairId))
                        {
                            LTBY_ViewManager.Instance.GetView<LTBY_ScratchCardView>().AddScratchCardNum(config.count);
                        }

                        config.itemType = "ScratchCard";
                        LTBY_EffectManager.Instance.CreateEffect<DropItem>(chairId, config);
                    }
                    else if (PropConfig.CheckIsSummon(item.id))
                    {
                        config.angles.z = 0;
                        if (LTBY_GameView.GameInstance.IsSelf(chairId))
                        {
                            LTBY_ViewManager.Instance.GetView<LTBY_SummonView>().AddItemNum(config.count);
                        }

                        config.itemType = "Summon";
                        LTBY_EffectManager.Instance.CreateEffect<DropItem>(chairId, config);
                    }
                    else if (PropConfig.CheckIsFreeAddTime(item.id))
                    {
                        if (LTBY_BatteryManager.Instance.GetFreeBattery(chairId) == null) continue;
                        config.itemType = "FreeAddTime";
                        LTBY_EffectManager.Instance.CreateEffect<FreeDropItem>(chairId, config);
                    }
                    else if (PropConfig.CheckIsFreeAddMul(item.id))
                    {
                        if (LTBY_BatteryManager.Instance.GetFreeBattery(chairId) == null) continue;
                        config.itemType = "FreeAddMul";
                        LTBY_EffectManager.Instance.CreateEffect<FreeDropItem>(chairId, config);
                    }
                }
            }
        }


        public FishClass GetFish(int fishId)
        {
            FishList.TryGetValue(fishId, out FishClass fish);
            if (fish != null)
            {
                return fish;
            }

            FishArrayClass[] fishArrays = FishArrayList.GetDictionaryValues();
            for (int i = 0; i < fishArrays.Length; i++)
            {
                FishArrayClass v = fishArrays[i];
                var _fish = v.GetFish(fishId);
                if (_fish != null)
                {
                    return _fish;
                }
            }

            return null;
        }


        private void MoveOut(float delayMoveTime)
        {
            FishClass[] fishs = FishList.GetDictionaryValues();
            for (int i = 0; i < fishs.Length; i++)
            {
                var item = fishs[i];
                item.MoveOut(delayMoveTime);
            }

            FishArrayClass[] fishArrays = FishArrayList.GetDictionaryValues();
            for (int i = 0; i < fishArrays.Length; i++)
            {
                var item = fishArrays[i];
                item.MoveOut(delayMoveTime);
            }
        }

        private void ToggleDragonLight(bool flag)
        {
            DragonClass[] dragons = DragonList.GetDictionaryValues();
            for (int i = 0; i < dragons.Length; i++)
            {
                var item = dragons[i];
                item.ToggleLight(flag);
            }
        }


        private void UseDragonBallEffect(FishClass fish, SCHitSpecialFish data)
        {
            if (!LTBY_GameView.GameInstance.IsPlayerInRoom(data.chair_idx)) return;
            int chairId = data.chair_idx;
            Vector3 worldPos = fish.GetWorldPos();

            // var dragonBallBullet = LTBY_BulletManager.Instance.GetDragonBall(chairId);
            //
            // if (dragonBallBullet == null)
            // {
            //     return;
            // }
            //
            int multiple = GameData.Instance.ElectricDragonMultiple;
            int freeMultiple = data.multiple;
            //结算面板只有打到分之后才创建
            var effect = LTBY_EffectManager.Instance.GetElectricDragonSpineAward(chairId);
            DebugHelper.LogError($"雷龙特效：{effect == null} multiple:{multiple}");
            if (effect == null)
            {
                effect = LTBY_EffectManager.Instance.CreateElectricDragonSpineAward(chairId, multiple);
            }

            var aimPos = effect.GetNumWorldPos();

            Action callBack = () =>
            {
                effect?.AddScore(data.earn);
                effect?.OnSettle();
            };

            LTBY_EffectManager.Instance.CreateEffect<ExplosionPoint>(chairId, new EffectParamData()
            {
                level = fish.explosionPointLevel,
                pos = worldPos,
                playSound = true,
            });

            LTBY_EffectManager.Instance.CreateEffect<EffectText>(chairId, data.earn, worldPos, multiple, true,
                freeMultiple);
            // LTBY_EffectManager.Instance.CreateEffect<EffectText>(chairId, data.earn, worldPos, freeMultiple, true,
            //     freeMultiple);


            LTBY_EffectManager.Instance.CreateEffect<FlyCoin>(chairId, new EffectParamData()
            {
                score = data.earn,
                worldPos = worldPos,
                aimPos = aimPos,
                showText = false,
                callBack = callBack,
            });

            if (!LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                LTBY_GameView.GameInstance.SetScore(chairId, data.user_score);
            }
        }
        Dictionary<int, long> scores = new Dictionary<int, long>();

        /// <summary>
        /// 捕获
        /// </summary>
        /// <param name="chairId"></param>
        /// <param name="data"></param>
        void CallHitFish(int chairId, LTBY_Struct.CMD_S_FishDead data)
        {
            LTBY_GameView.GameInstance.SetScore(data.wChairID, data.score);
            FishClass fish = GetFish(data.fish[0].id);
            if (fish != null)
            {
                if (FishConfig.CheckIsElectricDragon(fish.fishType))
                {
                    GameData.Instance.ElectricDragonMultiple = data.electricDragonMultiple;
                    for (int i = 0; i < data.fish.Count; i++)
                    {
                        var fishC = GetFish(data.fish[i].id);
                        if (fishC == null) continue;
                        fishC.OnCapture();
                        LightLinkFish(data.wChairID, fish, fishC);
                    }
                }
                
                if (fish.isAced || fish.isLightFish)
                {
                    CatchAceAndLightFish(data);
                    return;
                }
                if (fish.fishType == 145) return;
            }

            scores = scores ?? new Dictionary<int, long>();
            scores.Clear();
            FishClass dragon = null;
            for (int i = 0; i < data.fish.Count; i++)
            {
                int index = i;
                FishClass fishClass = GetFish(data.fish[index].id);
                if (fishClass == null) return;
                if (scores.ContainsKey(data.fish[index].id)) continue;
                scores.Add(data.fish[index].id, data.fish[index].score);
                switch (fishClass.fishType)
                {
                    case 131: //宝藏章鱼
                    case 142: //大奖章鱼
                    case 109: //愤怒河豚
                    case 141: //奇遇蟹
                        BatteryClass battery = LTBY_BatteryManager.Instance.GetBattery(data.wChairID);
                        if (battery == null) return;
                        SCHitSpecialFish hitSpecialFish = new SCHitSpecialFish();
                        hitSpecialFish.wheel = new WheelTwo();
                        hitSpecialFish.wheel.wheels = new List<int>();
                        if (fishClass.fishType == 109) //河豚
                        {
                            hitSpecialFish.death = fishClass.GetGrowStage() > 4;
                            hitSpecialFish.grow_stage = fishClass.GetGrowStage() + 1;
                        }
                        else
                        {
                            if (fishClass.fishType == 142) //大奖章鱼
                            {
                                int ratio = data.fish[index].score /
                                            (GameData.Instance.Config.bulletScore[battery.GetLevel()-1] *
                                            battery.GetRatio());
                                LTBY_Struct.CMD_S_DaJiangZhangYu zhangYu =
                                    DaJiangZhangYus.FindItem(p => p.id == fishClass.fishId);
                                hitSpecialFish.wheel.wheels.Add(zhangYu.odd1);
                                hitSpecialFish.wheel.wheels.Add(zhangYu.odd2);
                                hitSpecialFish.wheel.wheels.Add(zhangYu.odd3);
                                hitSpecialFish.wheel.ratio = zhangYu.odd1 * zhangYu.odd2 * zhangYu.odd3;
                                DaJiangZhangYus.Remove(zhangYu);
                            }

                            hitSpecialFish.death = true;
                        }

                        hitSpecialFish.drop_props = new List<Drop_Props>();
                        hitSpecialFish.hit_bullet_type = PropConfig.Bullet.id;
                        hitSpecialFish.shock_fishes = new List<Shock_Fishes>();
                        hitSpecialFish.chair_idx = data.wChairID;
                        hitSpecialFish.earn = data.fish[index].score;
                        hitSpecialFish.fish_uid = data.fish[index].id;
                        hitSpecialFish.fish_value = data.fish[index].score;
                        hitSpecialFish.user_score = data.score;
                        if (fishClass.fishType == 141)
                        {
                            hitSpecialFish.drop_props.Add(new Drop_Props() //免费子弹
                            {
                                id = 800,
                                multiple = GameData.Instance.Config.bulletScore[battery.GetLevel() - 1] *
                                           battery.GetRatio(),
                                ratio = battery.GetRatio(),
                                count = 0,
                                time = 20,
                            });
                        }
                        LTBY_Event.DispatchSCHitSpecialFish(hitSpecialFish);
                        break;
                    default:
                        CatchNormalFish(data, data.fish[index]);
                        break;
                }
            }
        }

        /// <summary>
        /// 打死一网打尽和闪电
        /// </summary>
        /// <param name="data"></param>
        private void CatchAceAndLightFish(LTBY_Struct.CMD_S_FishDead data)
        {
            BatteryClass batteryClass = LTBY_BatteryManager.Instance.GetBattery(data.wChairID);
            if (batteryClass == null) return;
            SCHitSpecialFish hitSpecialFish = new SCHitSpecialFish()
            {
                death = true,
                drop_props = new List<Drop_Props>(),
                grow_stage = 0,
                hit_bullet_type = PropConfig.Bullet.id,
                shock_fishes = new List<Shock_Fishes>(),
                wheel = new WheelTwo() {wheels = new List<int>()},
                fish_uid = data.fish[0].id,
                user_score = data.score,
                chair_idx=data.wChairID
            };
            int totalgold = data.fish[0].score;

            hitSpecialFish.earn = totalgold;
            hitSpecialFish.multiple = totalgold / (GameData.Instance.Config.bulletScore[batteryClass.GetLevel()-1] *
                                                  batteryClass.GetRatio());
            for (int i = 1; i < data.fish.Count; i++)
            {
                if (data.fish[i].id <= 0) continue;
                int mul = data.fish[i].score / (GameData.Instance.Config.bulletScore[batteryClass.GetLevel()-1] * batteryClass.GetRatio());
                Shock_Fishes shockFishes = new Shock_Fishes()
                {
                    id = data.fish[i].id,
                    count = data.fish[i].score,
                    multiple = mul
                };
                data.fish[0].score -= data.fish[i].score;
                hitSpecialFish.shock_fishes.Add(shockFishes);
            }
            hitSpecialFish.fish_value = data.fish[0].score;
            LTBY_Event.DispatchSCHitSpecialFish(hitSpecialFish);
        }

        private void CatchNormalFish(LTBY_Struct.CMD_S_FishDead data, LTBY_Struct.FishData fishData)
        {
            BatteryClass battery = LTBY_BatteryManager.Instance.GetBattery(data.wChairID);
            if (battery == null) return;
            SCHitFish fishdata = new SCHitFish
            {
                chair_idx = data.wChairID,
                earn = fishData.score,
                fish_uid = fishData.id,
                fish_value = fishData.score /
                             (GameData.Instance.Config.bulletScore[battery.GetLevel() - 1] * battery.GetRatio()),
                multiple = fishData.score /
                           (GameData.Instance.Config.bulletScore[battery.GetLevel()-1] * battery.GetRatio()),
                user_score = data.score
            };
            var fish = OnCapture(fishData.id);

            if (fish != null)
            {
                UseEffect(fish, fishdata);
            }
            else if (LTBY_GameView.GameInstance.IsSelf(fishdata.chair_idx))
            {
                LTBY_GameView.GameInstance.AddScore(fishdata.chair_idx, fishdata.earn);
            }

            if (LTBY_GameView.GameInstance.IsSelf(fishdata.chair_idx))
            {
                LTBY_DataReport.Instance.Get(fishdata.chair_idx.ToString(), fishdata.earn);
            }
        }


        private void LTBY_EventOnSCOnShootLK(LTBY_Struct.CMD_S_ShootLK obj)
        {
            if (obj.score > 0)
            {
                BatteryClass batteryClass = LTBY_BatteryManager.Instance.GetBattery(obj.wChairID);
                if (batteryClass == null) return;
                SCTreasureFishCatched data = new SCTreasureFishCatched
                {
                    death = obj.isDeaded > 0,
                    chair_idx = obj.wChairID,
                    accum_money = obj.culScore,
                    cur_stage = obj.cbJBPStage,
                    earn = obj.score,
                    fish_uid = obj.id,
                    fish_value = 1,
                    multiple = obj.Multiple,
                    ratio = GameData.Instance.Config.bulletScore[batteryClass.GetLevel()-1]*batteryClass.GetRatio(),
                    user_score = obj.culPlayerScore
                };
                LTBY_Event.DispatchSCTreasureFishCatched(data);
            }
            else
            {
                SCTreasureFishInfo data = new SCTreasureFishInfo
                {
                    fish_uid = obj.id,
                    cur_stage = obj.cbJBPStage,
                    fish_value = obj.Multiple,
                    accum_money = obj.culScore,
                };
                LTBY_Event.DispatchSCTreasureFishInfo(data);
            }
        }

        /// <summary>
        /// 特殊捕鱼
        /// </summary>
        /// <param name="data"></param>
        void CallHitSpecialFish(SCHitSpecialFish data)
        {
            FishClass fish = data.death ? OnCapture(data.fish_uid) : GetFish(data.fish_uid);
            if (fish != null)
            {
                SpecialCaptureEffect(fish, data);
            }
            else if (LTBY_GameView.GameInstance.IsSelf(data.chair_idx))
            {
                LTBY_GameView.GameInstance.AddScore(data.chair_idx, data.earn);

                for (int i = 0; i < data.shock_fishes.Count; i++)
                {
                    LTBY_GameView.GameInstance.AddScore(data.chair_idx, (long) data.shock_fishes[i].count);
                }
            }

            if (LTBY_GameView.GameInstance.IsSelf(data.chair_idx))
            {
                if (PropConfig.CheckIsDragonBall(data.hit_bullet_type)) return;

                LTBY_DataReport.Instance.Get("捕鱼", data.earn);

                for (int i = 0; i < data.shock_fishes.Count; i++)
                {
                    LTBY_DataReport.Instance.Get("捕鱼", (long) data.shock_fishes[i].count);
                }

                if (data.drop_props.Count > 0)
                {
                    for (int i = 0; i < data.drop_props.Count; i++)
                    {
                        var item = data.drop_props[i];
                        if (PropConfig.CheckIsDragonBall(item.id))
                        {
                            LTBY_DataReport.Instance.ReportElectricDragonCapture(item.ratio, data.fish_uid,
                                data.chair_idx);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// 弹头捕获
        /// </summary>
        /// <param name="data"></param>
        void CallTorpedoHit(SCTorpedoHit data)
        {
            OnCapture(data.fish_uid);
            UseMissileEffect(data);
        }

        /// <summary>
        /// 锁鱼
        /// </summary>
        /// <param name="playerLock"></param>
        private void CallLockFish(LTBY_Struct.CMD_S_PlayerLock playerLock)
        {
            int chairId = playerLock.chairId;
            int fishId = playerLock.fishId;
            LockFish(fishId, chairId);
        }

        private void CallCancelLockFish(LTBY_Struct.CMD_S_PlayerCancalLock playerCancelLock)
        {
            int chairId = playerCancelLock.chairId;
            UnLockFish(chairId);
        }

        /// <summary>
        /// 游戏信息
        /// </summary>
        /// <param name="data"></param>
        void CallGameInfoNotify(SCGameInfoNotify data)
        {
            for (int i = 0; i < FishConfig.Fish.Count; i++)
            {
                var item = FishConfig.Fish[i];
                item.isAwardFish = false;

                for (int j = 0; j < data.award_fish.Count; j++)
                {
                    var fishAwardType = data.award_fish[i];
                    if (item.fishType == fishAwardType)
                    {
                        item.isAwardFish = true;
                    }
                }
            }
        }

        /// <summary>
        /// 聚宝盆的数值监听
        /// </summary>
        /// <param name="data"></param>
        void CallTreasureFishInfo(SCTreasureFishInfo data)
        {
            var fish = GetFish(data.fish_uid);

            if (fish == null)
            {
                return;
            }

            if (FishConfig.CheckIsTreasureBowl(fish.fishType))
            {
                fish.RefreshTreasureData(data);
            }
        }

        /// <summary>
        /// 捕获聚宝盆
        /// </summary>
        /// <param name="data"></param>
        private void TreasureBowlCaptured(SCTreasureFishCatched data)
        {
            DebugHelper.Log("捕获聚宝盆");

            FishClass fish = data.death ? OnCapture(data.fish_uid) : GetFish(data.fish_uid);

            if (fish != null)
            {
                fish.GetCaptureInfo(data);
            }
            else if (LTBY_GameView.GameInstance.IsSelf(data.chair_idx))
            {
                long totalMoney = data.ratio * data.fish_value * data.multiple + data.accum_money * data.multiple;
                LTBY_GameView.GameInstance.AddScore(data.chair_idx, totalMoney);
            }
        }

        /// <summary>
        /// 捕获大奖章鱼
        /// </summary>
        /// <param name="obj"></param>
        private void LTBY_EventOnSCOnKillDJZY(LTBY_Struct.CMD_S_DaJiangZhangYu obj)
        {
            DaJiangZhangYus.Add(obj);
        }
    }

    /// <summary>
    /// 特殊鱼(龙)
    /// </summary>
    public class DragonClass : FishClass
    {
        Camera camera;
        protected new List<Vector3> roadList;
        private string deadSound;
        private int listIndex;
        private Dictionary<int, DragonClass> DragonList = new Dictionary<int, DragonClass>();
        private float moveTime;
        private new Dictionary<int, List<Transform>> lockEffect;

        public override void Init(int _fishType, Transform _parent)
        {
            this.fishType = _fishType;
            this.parent = _parent;
            this.fish = LTBY_Extend.Instance.LoadPrefab($"fish_{this.fishType}", this.parent);
            this.fish.localPosition = new Vector3(1000, 0, 0);
            this.fishLight = this.fish.FindChildDepth("Light");
            this.fishModel = this.fish.FindChildDepth("model");
            this.fishModel.localEulerAngles = new Vector3(0, 0, 0);
            this.fishMat = this.fish.GetComponentInChildren<SkinnedMeshRenderer>().material;
            this.cameraTrans = this.fish.FindChildDepth("Camera");
            if (this.cameraTrans != null)
            {
                this.cameraTrans.gameObject.SetActive(false);
                this.camera = this.cameraTrans.GetComponent<Camera>();
            }

            this.fishAnimator = this.fish.FindChildDepth<Animator>("model");
            this.fishAnimator.enabled = false;

            this.fishColliderList = this.fish.gameObject.GetComponentsInChildren<Collider2D>();

            //尾巴节点的索引

            int maxPriorityLockIndex = this.fishColliderList.Length - 1;
            //选取其中三个点作为锁定的点

            this.priorityLockIndexList = new Dictionary<int, bool>()
            {
                {0,true },
                {(int) Mathf.Floor(maxPriorityLockIndex / 2f),true },
                { maxPriorityLockIndex,true },
            };
            //优先级最高的锁定骨骼索引

            this.priorityLockIndex = 0;

            for (int i = 0; i < this.fishColliderList.Length; i++)
            {
                int index = i;
                Collider2D node = this.fishColliderList[index];

                if (!this.priorityLockIndexList.ContainsKey(index) || !this.priorityLockIndexList[index]) continue;
                CollisionTriggerUtility collision = CollisionTriggerUtility.Get(node.transform);
                collision.onTriggerEnter2D = (_self, _other) =>
                {
                    if (!this.isDead && _other.name.Equals("BG"))
                    {
                        InScreen(index);
                    }
                };

                collision.onTriggerExit2D = (_self, _other) =>
                {
                    if (!this.isDead && _other.name.Equals("BG"))
                    {
                        OutScreen(index);
                    }
                };
            }


            this.fishConfig = FishConfig.Fish.FindItem(p => p.fishOrginType == this.fishType);

            this.normalColor = this.fishMat.color;

            if (this.fishConfig.hitColor.a > 0)
            {
                Color _hitColor = this.fishConfig.hitColor;

                float r = _hitColor.r / 255f;
                float g = _hitColor.g / 255f;
                float b = _hitColor.b / 255f;
                this.hitColor = new Color(r, g, b, 1);
            }
            else
            {
                this.hitColor = new Color(1, 0, 0, 1);
            }


            this.roadList = this.fishConfig.roadEulerAngle;
            this.deadSound = this.fishConfig.fishDieSound;
            int t = DragonList.Count;
            this.listIndex = t + 1;
            DragonList.Add(listIndex, this);
        }

        public override void OnCreate(int _fishId)
        {
            this.fishId = _fishId;
            this.fish.name = this.fishId.ToString();

            OpenCollider(); 
            this.fishAnimator = this.fish.FindChildDepth<Animator>("model");
            this.fishAnimator.enabled = true;

            this.fishMat.color = this.normalColor;

            this.inScreen = false;

            this.beHit = false;
            this.isDead = false;
            this.canMove = false;
            this.moveTime = 0f;

            if (!string.IsNullOrEmpty(this.fishConfig.broadcast))
            {
                LTBY_EffectManager.Instance.CreateFishAppear(this.fishConfig);
            }


            this.fixedZ = this.fishConfig.fixedZ;

            this.lockEffect = new Dictionary<int, List<Transform>>();

            this.fish.localPosition = new Vector3(0, 0, this.fixedZ);

            this.fish.localScale = new Vector3(1, 1, 1);

            this.fishAppearSound = this.fishConfig.fishAppearSound;
            LTBY_Audio.Instance.Play(SoundConfig.AllAudio[this.fishAppearSound]);

            this.isAwardFish = this.fishConfig.isAwardFish;

            if (IlBehaviour == null)
            {
                IlBehaviour = this.fish.gameObject.AddComponent<ILBehaviour>();
            }

            IlBehaviour.UpdateEvent = Update;
            // this.updateKey = LTBY_Extend.Instance.StartTimer(Update);

            this.moveOutKey = 0;

            this.canUpdate = true;

            this.actionKey = new List<int>();

            ToggleLight(LTBY_FishManager.Instance.ShowDragonLight);
            if (this.cameraTrans != null) this.cameraTrans.gameObject.SetActive(true);
        }

        public override void OnDestroy(bool sendMsgToServer = false)
        {
            for (int i = 0; i < actionKey.Count; i++)
            {
                LTBY_Extend.Instance.StopAction(actionKey[i]);
            }
            this.actionKey.Clear();
            if (IlBehaviour != null) LTBY_Extend.Destroy(IlBehaviour);
            IlBehaviour = null;
            this.canUpdate = false;
            CloseCollider();
            if (this.cameraTrans != null) this.cameraTrans.gameObject.SetActive(false);
            this.fishModel.localEulerAngles = new Vector3(0, 0, 0);
            int[] keys = lockEffect.GetDictionaryKeys();
            for (int i = 0; i < keys.Length; i++)
            {
                LTBY_FishManager.Instance.UnLockFish(keys[i]);
            }


            MissileLock(false);

            // LTBY_Extend.Instance.StopTimer(this.updateKey);

            if (this.moveOutKey > 0)
            {
                LTBY_Extend.Instance.StopTimer(this.moveOutKey);
                this.moveOutKey = 0;
            }


            if (sendMsgToServer)
            {
                //GC.NetworkRequest.Request("CSFishOutsideScreen",{
                //    fish_uid = this.fishId;
                //});
            }

            if (this.lightBall != null)
            {
                LTBY_PoolManager.Instance.RemoveGameItem("LTBY_LightBall", this.lightBall);
                this.lightBall = null;
            }

            LTBY_FishManager.Instance.RemoveFishToPool(this.fishType, this);
        }

        public override void Release()
        {
            DragonList.Remove(this.listIndex);
            LTBY_ResourceManager.Instance.Destroy(this.fish.gameObject);
            this.fish = null;
        }

        protected override void InScreen(int boneIndex = 0)
        {
            if (boneIndex < this.priorityLockIndex)
            {
                this.priorityLockIndex = boneIndex;
                ChangeLockParent(boneIndex);
                //DebugHelper.LogError($"当前应该锁定的骨骼节点为{this.priorityLockIndex}");
            }
            LTBY_FishManager.Instance.AddFishInScreen(this);
            this.inScreen = true;
        }

        protected override void OutScreen(int boneIndex = 0)
        {
            if (this.priorityLockIndex != boneIndex) return;
            LTBY_FishManager.Instance.RemoveFishInScreen(this);
            bool findNext = false;
            int[] keys = priorityLockIndexList.GetDictionaryKeys();
            for (int i = 0; i < keys.Length; i++)
            {
                if (keys[i] <= boneIndex) continue;
                this.priorityLockIndex = keys[i];
                findNext = true;
                break;
            }
            if (findNext)
            {
                ChangeLockParent(this.priorityLockIndex);
            }
            else
            {
                DebugHelper.LogError("没有任何节点可以锁定");
                int[] _keys = lockEffect.GetDictionaryKeys();
                for (int i = 0; i < _keys.Length; i++)
                {
                    LTBY_FishManager.Instance.UnLockFish(_keys[i]);
                }

                this.inScreen = false;
            }
        }

        protected override void OpenCollider()
        {
            for (int i = 0; i < this.fishColliderList.Length; i++)
            {
                Collider2D node = this.fishColliderList[i];
                node.name = this.fishId.ToString();
                node.gameObject.SetActive(true);
            }
        }

        public override void CloseCollider()
        {
            for (int i = 0; i < this.fishColliderList.Length; i++)
            {
                this.fishColliderList[i].gameObject.SetActive(false);
            }
        }

        protected override void Update()
        {
            if (!this.canUpdate) return;

            float dt = Time.deltaTime;
            if (this.isDead)
            {
                this.deadTime -= dt;
                if (this.deadTime <= 0)
                {
                    LTBY_FishManager.Instance.DestroyFish(this.fishId, true);
                }

                return;
            }

            if (this.beHit)
            {
                this.hitTime -= dt;
                if (this.hitTime <= 0)
                {
                    this.beHit = false;
                    this.fishMat.color = this.normalColor;
                }
            }

            if (!this.canMove) return;
            this.moveTime -= dt;
            if (this.moveTime <= 0)
            {
                MoveFinish();
            }
        }

        public override void SetParent(Transform _parent)
        {
            if (this.parent == _parent) return;
            this.fish.parent = _parent;
            this.parent = _parent;
        }

        public override void SetZOrder(int z = 0)
        {
            this.zOrder = this.fixedZ == 0 ? z : 0;
        }

        public override void InitRoad(int _fishRoad, float _delay = 0, int _roadIndex = 0, float _moveT = 0)
        {
            this.fishRoad = _fishRoad;
            this.fishModel.localEulerAngles = this.roadList[this.fishRoad - 1];

            if (LTBY_GameView.GameInstance.CheckIsTop())
            {
                if (this.cameraTrans != null)
                {
                    this.cameraTrans.localEulerAngles = new Vector3(0, 0, -180);
                }
                this.fishAnimator = this.fishAnimator == null ? this.fish.FindChildDepth<Animator>("model") : this.fishAnimator;
                this.fishAnimator.Play("swim02", -1, _moveT);
            }
            else
            {
                if (this.cameraTrans != null)
                {
                    this.cameraTrans.localEulerAngles = new Vector3(0, 0, 0);
                }

                this.fishAnimator = this.fishAnimator == null ? this.fish.FindChildDepth<Animator>("model") : this.fishAnimator;
                this.fishAnimator.Play("swim01", -1, _moveT);
            }

            this.moveTime = 14.5f;

            this.moveTime = (1 - _moveT) * this.moveTime;

            this.canMove = true;
        }

        public override void SetIsAced(bool flag)
        {
            this.isAced = false;
        }
        public override Vector3 GetWorldPos()
        {
            return this.fishColliderList[this.priorityLockIndex].transform.position;
        }

        public override Vector3 GetFishAngles()
        {
            return this.fish.localEulerAngles;
        }

        public override List<Vector3> GetBonesWorldPosList()
        {
            List<Vector3> list = new List<Vector3>();
            for (int i = 0; i < this.fishColliderList.Length; i++)
            {
                Collider2D node = this.fishColliderList[i];

                list.Add(node.transform.position);
            }

            return list;
        }

        public override bool OnCapture()
        {
            this.fishAnimator = this.fishAnimator == null ? this.fish.FindChildDepth<Animator>("model") : this.fishAnimator;
            this.fishAnimator.enabled = false;
            this.canMove = false;
            this.fishMat.color = this.normalColor;
            this.isDead = true;
            this.deadTime = 4.5f;
            //  CloseCollider();
            int[] keys = lockEffect.GetDictionaryKeys();
            for (int i = 0; i < keys.Length; i++)
            {
                LTBY_FishManager.Instance.UnLockFish(keys[i]);
            }

            Tween tween = fish.DOShakePosition(1, 1.5f, 50, 90, false);
            int key = LTBY_Extend.Instance.RunAction(tween);
            this.actionKey.Add(key);

            return true;
        }

        protected override void HitEffect()
        {
            if (this.beHit) return;

            this.fishMat.color = this.hitColor;
            this.beHit = true;
            this.hitTime = 0.2f;
        }

        public override void Lock(int chairId,Vector3 pos)
        {
            if (this.lockEffect.ContainsKey(chairId)) return;
            this.lockEffect.Add(chairId, new List<Transform>());

            Transform _parent = this.fishColliderList[this.priorityLockIndex].transform;
            string prefab = LTBY_GameView.GameInstance.IsSelf(chairId) ? "LTBY_LockSelf" : "LTBY_LockOther";
            Transform effect = LTBY_PoolManager.Instance.GetGameItem(prefab, _parent);
            effect.localPosition = LTBY_GameView.GameInstance.IsSelf(chairId)
                ? new Vector3(0, 0, -4)
                : new Vector3(0, 0, -3.9f);
            effect.localScale = new Vector3(2, 2, 2);
            effect.localEulerAngles = new Vector3(0, 0, 0);
            this.lockEffect[chairId].Add(effect);

            Transform _effect = LTBY_PoolManager.Instance.GetGameItem(prefab, _parent);
            _effect.localPosition = LTBY_GameView.GameInstance.IsSelf(chairId)
                ? new Vector3(0, 0, 4)
                : new Vector3(0, 0, 3.9f);
            _effect.localScale = new Vector3(2, 2, 2);
            _effect.localEulerAngles = new Vector3(0, 0, 0);
            this.lockEffect[chairId].Add(_effect);
        }

        private void ChangeLockParent(int index)
        {
            int[] keys = lockEffect.GetDictionaryKeys();
            for (int i = 0; i < keys.Length; i++)
            {
                var v = lockEffect[keys[i]];
                for (int j = 0; j < v.Count; j++)
                {
                    Transform _parent = this.fishColliderList[index].transform;
                    Transform effect = v[j];
                    effect.SetParent(_parent);
                    effect.localScale = new Vector3(2, 2, 2);
                    effect.localEulerAngles = new Vector3(0, 0, 0);
                    if (i == 1)
                    {
                        effect.localPosition = LTBY_GameView.GameInstance.IsSelf(keys[i])
                            ? new Vector3(0, 0, -4)
                            : new Vector3(0, 0, -3.9f);
                    }
                    else
                    {
                        effect.localPosition = LTBY_GameView.GameInstance.IsSelf(keys[i])
                            ? new Vector3(0, 0, 4)
                            : new Vector3(0, 0, 3.9f);
                    }
                }
            }
        }
        public override Vector3 GetLockEffectPos(int chairId)
        {
            return Vector3.zero;
        }

        public override void UnLock(int chairId)
        {
            if (!this.lockEffect.ContainsKey(chairId)) return;
            string prefab = LTBY_GameView.GameInstance.IsSelf(chairId) ? "LTBY_LockSelf" : "LTBY_LockOther";
            for (int i = 0; i < lockEffect[chairId].Count; i++)
            {
                LTBY_PoolManager.Instance.RemoveGameItem(prefab, lockEffect[chairId][i]);
            }

            this.lockEffect.Remove(chairId);
        }

        public override void OnHit(int chairId, BulletClass bullet)
        {
            HitEffect();
            if (!LTBY_GameView.GameInstance.IsSelf(chairId) && !LTBY_BatteryManager.Instance.IsRobot(chairId)) return;
            LTBY_Struct.PlayerHitFish hitFish = new LTBY_Struct.PlayerHitFish
            {
                type = 0,
                gunLevel = (byte)(bullet.GetRatio() - 1),
                gunGrade = (byte)(bullet.GetLevel() - 1),
                bet = GameData.Instance.Config.bulletScore[bullet.GetLevel() - 1] * bullet.GetRatio(),
                wChairId = chairId,
                bulletId = bullet.id,
                hitFishList = new List<short>()
            };
            hitFish.hitFishList.Add((short) this.fishId);
            if (FishConfig.CheckIsElectricDragon(fishType))
            {
                var fl = LTBY_FishManager.Instance.GetInScreenNormalFishId();
                fl.OrderBy((a, b) => a.fishType > b.fishType);
                for (int i = 0; i < fl.Count; i++)
                {
                    hitFish.hitFishList.Add((short) fl[i].fishId);
                }
            }
            // GC.NetworkRequest.Request("CSHitFish",{
            //     fish_uid = this.fishId;
            //     bullet_id = tonumber(bulletId);
            // });
            LTBY_Network.Instance.Send(LTBY_Network.SUB_C_HITED_FISH, hitFish.Buffer);
        }

        protected override void MoveFinish()
        {
            LTBY_FishManager.Instance.DestroyFish(this.fishId, true);
        }

        public void ToggleLight(bool flag)
        {
            if (this.fishLight != null)
            {
                this.fishLight.gameObject.SetActive(flag);
            }
        }
    }

    /// <summary>
    /// 普通鱼
    /// </summary>
    public class FishClass
    {
        public int maxNum;
        public int fishType;
        protected Transform parent;
        protected FishDataConfig fishConfig;
        public Transform fish;
        protected Transform fishLight;
        protected Transform fishModel;
        protected Material fishMat;
        protected Color normalColor;
        protected Color hitColor;
        protected Transform cameraTrans;
        public Animator fishAnimator;
        protected Collider2D[] fishColliderList;
        protected int priorityLockIndex;
        protected Dictionary<int, bool> priorityLockIndexList;
        public int explosionPointLevel;
        public bool isCoinOutburstFish;
        public bool inScreen;
        protected Vector3 fishLocalPosition;
        protected Vector3 fishLocalEulerAngles;
        protected bool beHit;
        protected float hitTime;
        public bool isDead;
        protected float deadTime;
        public int fishId;
        public bool isAced;
        public bool isAwardFish;
        public bool isLightFish;
        public bool isDialFish;
        protected bool isGlobefish;
        protected bool isWhaleFish;
        protected Collider2D fishCollider;
        protected bool hitChange;
        protected float effectScale;
        protected bool canMove;
        protected float delay;
        protected int fishRoad;
        protected int fishArray;
        protected int stage;
        protected bool canScale;
        protected float swinScaleT;
        protected float swinScaleState;
        protected float swinScaleSpeed;
        protected float swinScaleWait;
        protected float swinScaleInterval;
        protected float swinChangeScale;
        protected float swinBaseScale;
        protected float fixedZ;
        protected string fishAppearSound;
        protected string fishHitSound;
        protected string fishDeadSound;
        protected Dictionary<int, Transform> lockEffect;
        protected bool isMoveOut;
        protected int updateKey;
        protected int moveOutKey;
        protected bool canUpdate;
        protected bool isSummon;
        protected List<int> actionKey;
        protected Transform missileLockEffect;
        protected Transform lightBall;
        protected Transform acedEffect;
        protected float summonT;
        protected float summonSpeed;
        protected float zOrder;
        protected Vector3 summonScaleDelta;
        protected float summonZDelta;
        protected float speed;
        protected float moveT;
        protected int roadIndex;
        protected float aimX;
        protected float aimY;
        protected bool curveMotion;
        protected float aimOffsetX;
        protected float aimOffsetY;
        protected float baseX;
        protected float baseY;
        protected List<FishRoad> roadList = new List<FishRoad>();
        protected ILBehaviour IlBehaviour;

        //初始化prefab，缓存所有组件
        public virtual void Init(int _fishType, Transform _parent)
        {
            this.parent = _parent;
            this.fishConfig = FishConfig.Fish.FindItem(p => p.fishOrginType == _fishType);
            this.fish = LTBY_Extend.Instance.LoadPrefab($"fish_{_fishType}", this.parent);
            this.fishType = _fishType;
            this.fishMat = this.fish.GetComponentInChildren<SkinnedMeshRenderer>().material;
            this.normalColor = new Color(1f, 1f, 1f, 1);
            this.hitColor = new Color(1, 0, 0, 1);

            if (this.fishConfig.hitColor.a > 0)
            {
                Color _hitColor = this.fishConfig.hitColor;

                float r = _hitColor.r / 255f;
                float g = _hitColor.g / 255f;
                float b = _hitColor.b / 255f;
                this.hitColor = new Color(r, g, b, 1);
            }


            this.fish.localPosition = new Vector3(1000, 0, 0);

            //this.fishAnimator = this.fish.FindChildDepth<Animator>("model");
            this.fishAnimator = this.fishAnimator == null ? this.fish.GetComponentInChildren<Animator>() : this.fishAnimator;
            this.fishAnimator.enabled = false;

            this.fishCollider = this.fish.FindChildDepth<Collider2D>("collider");
            this.fishCollider?.gameObject.SetActive(false);

            CollisionTriggerUtility collision = CollisionTriggerUtility.Get(this.fish.FindChildDepth("collider"));
            collision.onTriggerEnter2D = (_self, _other) =>
            {
                if (!this.isDead && _other.name.Equals("BG"))
                {
                    InScreen();
                }
            };


            collision.onTriggerExit2D = (_self, _other) =>
            {
                if (!this.isDead && _other.name.Equals("BG"))
                {
                    OutScreen();
                }
            };


            this.hitChange = this.fishConfig.hitChange;

            this.effectScale = this.fishConfig.effectScale == 0 ? 1 : this.fishConfig.effectScale;

            this.isLightFish = this.fishConfig.isLightFish;

            this.isDialFish = this.fishConfig.isDialFish;

            this.isGlobefish = this.fishConfig.isGlobefish;

            this.isWhaleFish = this.fishConfig.isWhaleFish;

            this.isCoinOutburstFish = this.fishConfig.isCoinOutburstFish;

            this.explosionPointLevel =
                this.fishConfig.explosionPointLevel == 0 ? 1 : this.fishConfig.explosionPointLevel;
        }
        protected virtual void OpenCollider()
        {
            this.fishCollider?.gameObject.SetActive(true);
        }

        public virtual void CloseCollider()
        {
            this.fishCollider?.gameObject.SetActive(false);
        }

        public virtual void Release()
        {
            if (this.fishCollider != null)
            {
                this.fishCollider.gameObject.name = $"collider";
            }
            LTBY_ResourceManager.Instance.Destroy(this.fish.gameObject);
            this.fish = null;
        }

        public virtual void OnCreate(int _fishId)
        {
            this.fishId = _fishId; 
            this.fishAnimator = this.fishAnimator == null ? this.fish.GetComponentInChildren<Animator>() : this.fishAnimator;
            this.fishCollider.gameObject.name = this.fishId.ToString();
            OpenCollider();

            this.fishAnimator.enabled = true;
            this.fishAnimator.SetTrigger($"move");

            this.fishMat.color = this.normalColor;

            this.canMove = false;
            this.delay = 0f;
            this.fishRoad = 0;
            this.fishArray = 0;
            this.inScreen = false;

            this.fishLocalPosition = new Vector3(0, 0, 0);

            this.fishLocalEulerAngles = new Vector3(0, 0, 0);
            this.fish.localEulerAngles = this.fishLocalEulerAngles;

            this.beHit = false;
            this.isDead = false;

            this.fish.localScale = new Vector3(1, 1, 1);
            this.stage = 1;
            if (this.fishConfig.swinScale)
            {
                this.canScale = true;
                this.swinScaleT = 0;
                this.swinScaleState = 1;
                this.swinScaleSpeed = 0.06f;
                this.swinScaleWait = 0f;
                this.swinScaleInterval = 2f;
                this.swinChangeScale = 0.4f;
                this.swinBaseScale = 1;
            }

            //DebugHelper.LogError(this.fishType.."是否是奖金鱼："..tostring(this.fishConfig.isAwardFish))


            this.isAwardFish = this.fishConfig.isAwardFish;

            if (!string.IsNullOrEmpty(this.fishConfig.broadcast))
            {
                LTBY_EffectManager.Instance.CreateFishAppear(this.fishConfig);
            }


            this.fixedZ = this.fishConfig.fixedZ;

            this.fishAppearSound = this.fishConfig.fishAppearSound;
            this.fishHitSound = this.fishConfig.fishHitSound;
            this.fishDeadSound = this.fishConfig.fishDeadSound;

            this.lockEffect = new Dictionary<int, Transform>();

            this.missileLockEffect = null;

            this.lightBall = null;

            this.isMoveOut = false;

            if (IlBehaviour == null)
            {
                IlBehaviour = this.fish.gameObject.AddComponent<ILBehaviour>();
            }

            IlBehaviour.UpdateEvent = Update;
            // this.updateKey = LTBY_Extend.Instance.StartTimer(() => { Update(); });

            this.moveOutKey = 0;

            this.canUpdate = true;

            this.isSummon = false;

            this.actionKey = new List<int>();
        }

        public virtual void OnCreate(int _arrayId, List<FishArrayParams> list, Transform _parent)
        {
        }

        public virtual void OnDestroy(bool sendMsgToServer = false)
        {
            this.canUpdate = false;
            int[] chairIds = lockEffect.GetDictionaryKeys();
            for (int i = 0; i < chairIds.Length; i++)
            {
                LTBY_FishManager.Instance.UnLockFish(chairIds[i]);
            }

            MissileLock(false);

            if (this.lightBall != null)
            {
                LTBY_PoolManager.Instance.RemoveGameItem("LTBY_LightBall", this.lightBall);
                this.lightBall = null;
            }


            this.isAced = false;
            if (this.acedEffect != null)
            {
                LTBY_PoolManager.Instance.RemoveGameItem("fish_143", this.acedEffect);
                this.acedEffect = null;
            }


            // LTBY_Extend.Instance.StopTimer(this.updateKey);
            if (IlBehaviour != null)
            {
                IlBehaviour.UpdateEvent = null;
                LTBY_Extend.Destroy(IlBehaviour);
                IlBehaviour = null;
            }

            if (this.moveOutKey > 0)
            {
                LTBY_Extend.Instance.StopTimer(this.moveOutKey);
                this.moveOutKey = 0;
            }

            for (int i = actionKey.Count-1; i >=0; i--)
            {
                LTBY_Extend.Instance.StopAction(actionKey[i]);
            }

            this.actionKey.Clear();

            if (sendMsgToServer)
            {
                //GC.NetworkRequest.Request("CSFishOutsideScreen",{
                //    fish_uid = this.fishId;
                //});
            }

            LTBY_FishManager.Instance.RemoveFishToPool(this.fishType, this);
        }

        public virtual void AddLightBall()
        {
            if (this.lightBall != null) return;
            this.lightBall = LTBY_PoolManager.Instance.GetGameItem("LTBY_LightBall", this.fish);
            this.lightBall.localPosition = new Vector3(0, 0, -10);
            float scale = this.effectScale;
            this.lightBall.localScale = new Vector3(scale, scale, scale);
        }

        public virtual void SetParent(Transform _parent)
        {
            if (this.parent == _parent) return;
            this.fish.parent = _parent;
            this.parent = _parent;
        }

        public virtual void SetIsAced(bool flag)
        {
            this.isAced = flag;
            if (!this.isAced || this.acedEffect != null) return;
            this.acedEffect = LTBY_PoolManager.Instance.GetGameItem("fish_143", this.fish);
            this.acedEffect.localPosition = new Vector3(0, 0, 0);
            this.acedEffect.localScale = new Vector3(1, 1, 1);
            this.acedEffect.name = this.fishId.ToString();
        }

        public virtual void SetFishRoad(int str)
        {
            this.fishRoad = str;
        }

        public virtual void SetFishArray(int str)
        {
            this.fishArray = str;
        }

        public virtual Vector3 GetFishAngles()
        {
            return this.fish.localEulerAngles;
        }

        protected virtual void HitEffect()
        {
            if (this.beHit) return;

            this.fishMat.color = this.hitColor;
            this.beHit = true;
            this.hitTime = 0.2f;

            if (this.hitChange)
            {
                this.hitChange = false; 
                this.fishAnimator = this.fishAnimator == null ? this.fish.GetComponentInChildren<Animator>() : this.fishAnimator;
                this.fishAnimator.SetTrigger($"hit");

                if (this.isWhaleFish)
                {
                    LTBY_Audio.Instance.Play(SoundConfig.HitWhale);
                }
            }

            if (string.IsNullOrEmpty(this.fishHitSound)) return;
            LTBY_FishManager.Instance.PlayOnlySound(this.fishHitSound);
            this.fishHitSound = null;
        }

        public virtual void OnHit(int chairId, BulletClass bullet)
        {
            HitEffect();
            if (!LTBY_GameView.GameInstance.IsSelf(chairId) && !LTBY_BatteryManager.Instance.IsRobot(chairId)) return;
            LTBY_Struct.PlayerHitFish hitFish = new LTBY_Struct.PlayerHitFish
            {
                hitFishList = new List<short>(),
                bulletId = bullet.id,
                bet = GameData.Instance.Config.bulletScore[bullet.GetLevel() - 1] * bullet.GetRatio(),
                gunLevel = (byte)(bullet.GetRatio() - 1),
                gunGrade = (byte)(bullet.GetLevel() - 1),
                wChairId = chairId
            };
            hitFish.hitFishList.Add((short) this.fishId);
            if (this.isLightFish)
            {
                FishDataConfig config = FishConfig.Fish.FindItem(p => p.fishOrginType == this.fishType);
                if (config == null) return;
                var v = LTBY_FishManager.Instance.GetInScreenFishIdByKindList(this.fishType,this.fishId);
                hitFish.hitFishList.AddRange(v);
                //GC.NetworkRequest.Request("CSHitFish",{
                //    fish_uid = this.fishId;
                //    bullet_id = tonumber(bulletId);
                //    screen_fishes = M.GetInScreenFishIdList();
                //});
            }
            else if (this.isAced)
            {
                hitFish.hitFishList.AddRange(LTBY_FishManager.Instance.GetAcedFishIdList(this.fishId));
                //GC.NetworkRequest.Request("CSHitFish",{
                //    fish_uid = this.fishId;
                //    bullet_id = tonumber(bulletId);
                //    screen_fishes = M.GetAcedFishIdList();
                //});
            }
            else
            {
                //GC.NetworkRequest.Request("CSHitFish",{
                //    fish_uid = this.fishId;
                //    bullet_id = tonumber(bulletId);
                //});
            }

            LTBY_Network.Instance.Send(LTBY_Network.SUB_C_HITED_FISH, hitFish.Buffer);
        }

        protected virtual void InScreen(int boneIndex = 0)
        {
            this.inScreen = true;
            LTBY_FishManager.Instance.PlayOnlySound(this.fishAppearSound);
            LTBY_FishManager.Instance.AddFishInScreen(this);
            if (LTBY_FishManager.Instance.MissileLockSwitch)
            {
                MissileLock(this.inScreen);
            }
        }

        protected virtual void OutScreen(int boneIndex = 0)
        {
            this.inScreen = false;
            LTBY_FishManager.Instance.RemoveFishInScreen(this);

            int[] keys = lockEffect.GetDictionaryKeys();
            for (int i = 0; i < keys.Length; i++)
            {
                LTBY_FishManager.Instance.UnLockFish(keys[i]);
            }

            if (LTBY_FishManager.Instance.MissileLockSwitch)
            {
                MissileLock(this.inScreen);
            }
        }

        public virtual void MissileLock(bool flag)
        {
            if (!this.isAwardFish) return;

            if (flag && this.missileLockEffect == null)
            {
                Transform effect = LTBY_PoolManager.Instance.GetGameItem("LTBY_MissileLock", this.fish);
                effect.localPosition = new Vector3(0, 0, -15);
                effect.localScale = new Vector3(5, 5, 5);
                effect.localEulerAngles = new Vector3(0, 0, 0);

                Tween tween = effect.DOScale(new Vector2(1, 1), 0.5f).SetLink(effect.gameObject);
                int key = LTBY_Extend.Instance.RunAction(tween);
                this.actionKey.Add(key);
                this.missileLockEffect = effect;
                return;
            }


            if (flag || this.missileLockEffect == null) return;
            LTBY_PoolManager.Instance.RemoveGameItem("LTBY_MissileLock", this.missileLockEffect);
            this.missileLockEffect = null;
            return;
        }

        public virtual void Lock(int chairId, Vector3 pos)
        {
            if (this.lockEffect == null) lockEffect = new Dictionary<int, Transform>();
            if (this.lockEffect.ContainsKey(chairId)) return;
            float lockScaleFactor = 0.8f;
            if (LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                Transform effect = LTBY_PoolManager.Instance.GetGameItem("LTBY_LockSelf", this.fish);
                if (effect == null) return;
                effect.localEulerAngles = new Vector3(0, 0, 0);
                effect.localPosition = new Vector3(0, 0, -15);
                if (pos == Vector3.zero)
                {
                    if (this.stage != 1)
                    {
                        float scale = 1 / (1 + (this.stage - 1) * lockScaleFactor);
                        //DebugHelper.LogError($"FishMGR @2014 stage : scale {this.stage} : {scale}");
                        effect.localScale = new Vector3(scale, scale, scale);
                    }
                    else
                    {
                        effect.localScale = new Vector3(1, 1, 1);
                    }

                    Vector3 aimPos = effect.position;
                    effect.position = pos;
                    Tween tween = DOTween.To(value =>
                    {
                        if (effect == null) return;
                        float t = value * 0.01f;
                        effect.position = new Vector3(pos.x + (aimPos.x - pos.x) * t, pos.y + (aimPos.y - pos.y) * t, aimPos.z);
                    }, 0, 100, 0.2f).OnKill(() =>
                    {
                        if (effect == null) return;
                        effect.localPosition = LTBY_GameView.GameInstance.IsSelf(chairId)
                            ? new Vector3(0, 0, -15)
                            : new Vector3(0, 0, -14);
                    }).SetLink(effect.gameObject);
                    int key = LTBY_Extend.Instance.RunAction(tween);
                    this.actionKey.Add(key);
                }
                else
                {
                    effect.localScale = new Vector3(10, 10, 10);
                    if (this.stage != 1)
                    {
                        float scale = 1 / (1 + (this.stage - 1) * lockScaleFactor);
                        //DebugHelper.LogError($"FishMGR @2033 stage : scale {this.stage} : {scale}");
                        Tween tween = effect.DOScale(new Vector2(scale, scale), 0.6f).SetLink(effect.gameObject);
                        int key = LTBY_Extend.Instance.RunAction(tween);
                        this.actionKey.Add(key);
                    }
                    else
                    {
                        Tween tween = effect.DOScale(new Vector2(1, 1), 0.6f).SetLink(effect.gameObject).OnKill(() =>
                        {
                            if (effect == null) return;
                            effect.localScale = new Vector3(1, 1, 1);
                        }).SetLink(effect.gameObject);
                        int key = LTBY_Extend.Instance.RunAction(tween);
                        this.actionKey.Add(key);
                    }
                }

                this.lockEffect.Remove(chairId);
                this.lockEffect.Add(chairId, effect);
            }
            else
            {
                Transform effect = LTBY_PoolManager.Instance.GetGameItem("LTBY_LockOther", this.fish);
                effect.localEulerAngles = new Vector3(0, 0, 0);
                effect.localPosition = new Vector3(0, 0, -14);

                if (this.stage != 1)
                {
                    float scale = 1 / (1 + (this.stage - 1) * lockScaleFactor);
                    effect.localScale = new Vector3(scale, scale, scale);
                }
                else
                {
                    effect.localScale = new Vector3(1, 1, 1);
                }

                // effect.localScale = new Vector3(1, 1, 1);
                this.lockEffect.Remove(chairId);
                this.lockEffect.Add(chairId, effect);
            }
        }

        public virtual Vector3 GetLockEffectPos(int chairId)
        {
            return lockEffect.ContainsKey(chairId) ? this.lockEffect[chairId].position : default;
        }

        public virtual void UnLock(int chairId)
        {
            if (!this.lockEffect.ContainsKey(chairId)) return;
            string prefab = LTBY_GameView.GameInstance.IsSelf(chairId) ? "LTBY_LockSelf" : "LTBY_LockOther";
            LTBY_PoolManager.Instance.RemoveGameItem(prefab, this.lockEffect[chairId]);
            this.lockEffect.Remove(chairId);
        }

        public virtual int GetGrowStage()
        {
            return this.stage;
        }

        public virtual void SetGrowStage(int _stage = 0, bool showEffect = false)
        {
            if (_stage == 0 || this.stage == 5 || !this.isGlobefish)
            {
                return;
            }


            this.stage = _stage;

            this.fishAnimator = this.fishAnimator == null ? this.fish.GetComponentInChildren<Animator>() : this.fishAnimator;
            this.fishAnimator.SetTrigger($"hit");

            this.explosionPointLevel = this.stage == 5 ? 2 : 1;

            this.swinBaseScale = 1 + (this.stage - 1) * 0.8f;

            float scale = 1 / this.swinBaseScale;
            Transform[] values = lockEffect.GetDictionaryValues();
            for (int i = 0; i < values.Length; i++)
            {
                values[i].localScale = new Vector3(scale, scale, scale);
            }


            this.fish.localScale = new Vector3(this.swinBaseScale, this.swinBaseScale, 1);

            LTBY_Audio.Instance.Play(SoundConfig.FishGrowUp);
        }

        public virtual bool OnCapture()
        {
            if (this.isGlobefish)
            {
                if (this.stage < 5)
                {
                    return false;
                }
            }

            this.fishMat.color = this.normalColor;
            this.fishAnimator = this.fishAnimator == null ? this.fish.GetComponentInChildren<Animator>() : this.fishAnimator;
            this.fishAnimator.SetTrigger($"die");
            CloseCollider();
            this.deadTime = 1.5f;
            this.isDead = true;

            int[] keys = lockEffect.GetDictionaryKeys();
            for (int i = 0; i < keys.Length; i++)
            {
                LTBY_FishManager.Instance.UnLockFish(keys[i]);
            }

            LTBY_FishManager.Instance.PlayOnlySound(this.fishDeadSound);

            return true;
        }

        public virtual void MoveOut(float delayMoveTime)
        {
            if (this.delay > 0)
            {
                LTBY_FishManager.Instance.DestroyFish(this.fishId, true);
            }
            else if (!this.inScreen)
            {
                LTBY_FishManager.Instance.DestroyFish(this.fishId, true);
            }
            else
            {
                this.moveOutKey = LTBY_Extend.Instance.StartTimer(InitMoveOut, delayMoveTime, 1);
            }
        }

        public virtual void StopMove()
        {
            this.canMove = false;
        }

        protected virtual void Update()
        {
            if (!this.canUpdate) return;

            float dt = Time.deltaTime;
            if (this.isDead)
            {
                this.deadTime -= dt;
                if (this.deadTime <= 0)
                {
                    LTBY_FishManager.Instance.DestroyFish(this.fishId, false);
                }

                return;
            }

            if (this.isSummon)
            {
                SummonUpdate(dt);
            }

            if (this.delay > 0)
            {
                this.delay -= dt;
                if (!(this.delay <= 0)) return;
                this.fishAnimator = this.fishAnimator == null ? this.fish.GetComponentInChildren<Animator>() : this.fishAnimator;
                OpenCollider();
                    this.fishAnimator.enabled = true;

                return;
            }

            if (this.beHit)
            {
                this.hitTime -= dt;
                if (this.hitTime <= 0)
                {
                    this.beHit = false;
                    this.fishMat.color = this.normalColor;
                }
            }

            if (this.canScale)
            {
                SwinScale(dt);
            }

            if (this.canMove)
            {
                this.Motion(dt);
            }
        }

        protected virtual float PingPong(float t)
        {
            t -= Mathf.Floor(t / 2) * 2;
            return 1 - Mathf.Abs(t - 1);
        }

        protected virtual float QuadEaseInOut(float t)
        {
            return -0.5f * (Mathf.Cos(Mathf.PI * t) - 1);
        }

        protected virtual void SwinScale(float dt)
        {
            if (this.swinScaleWait > 0)
            {
                this.swinScaleWait -= dt;
                return;
            }
            else
            {
                switch (this.swinScaleState)
                {
                    case 1:
                    {
                        this.swinScaleT += this.swinScaleSpeed;
                        if (this.swinScaleT >= 1)
                        {
                            this.swinScaleState = 2;
                        }

                        break;
                    }
                    case 2:
                    {
                        this.swinScaleT -= this.swinScaleSpeed;
                        if (this.swinScaleT <= 0)
                        {
                            this.swinScaleWait = this.swinScaleInterval;
                            this.swinScaleState = 1;
                        }

                        break;
                    }
                }

                float value = this.swinChangeScale * this.swinScaleT + this.swinBaseScale;
                this.fish.localScale = new Vector3(value, value, 1);
            }
        }

        protected virtual void SummonUpdate(float dt)
        {
            this.summonT += dt * this.summonSpeed;
            if (this.summonT >= 1)
            {
                this.summonT = 0;
                this.isSummon = false;

                this.fishLocalPosition.z = this.zOrder;
                this.fish.localPosition = this.fishLocalPosition;

                this.fish.localScale = this.summonScaleDelta;
            }
            else
            {
                float t = (1 - this.summonT);
                this.fishLocalPosition.z = this.zOrder + this.summonZDelta * t;
                this.fish.localPosition = this.fishLocalPosition;
                this.fish.localScale = this.summonScaleDelta * this.summonT;
            }
        }

        private float timer = 0;

        protected virtual void Motion(float dt)
        {
            this.moveT += dt * this.speed;
            timer += dt;
            if (this.moveT >= 1)
            {
                this.moveT = 0;
                this.roadIndex += 1;
                if (InitMotionByList()) return;
                MoveFinish();
            }
            else
            {
                float _aimX = this.aimX;
                float _aimY = this.aimY;
                if (this.curveMotion)
                {
                    _aimX = this.aimX + this.aimOffsetX * (1 - this.moveT);
                    _aimY = this.aimY + this.aimOffsetY * (1 - this.moveT);
                }

                SetPosition(this.baseX + (_aimX - this.baseX) * this.moveT,
                    this.baseY + (_aimY - this.baseY) * this.moveT);
            }
        }

        protected virtual void MoveFinish()
        {
            LTBY_FishManager.Instance.DestroyFish(this.fishId, true);
        }

        protected virtual void InitMoveOut()
        {
            this.isMoveOut = true;

            this.roadIndex = this.roadList.Count;

            Vector3 pos = this.fishLocalPosition;
            this.baseX = pos.x;
            this.baseY = pos.y;
            float angles = this.fishLocalEulerAngles.z;

            float dis = 50;
            this.aimX = this.baseX + dis * Mathf.Cos(angles * Mathf.Deg2Rad);
            this.aimY = this.baseY + dis * Mathf.Sin(angles * Mathf.Deg2Rad);

            this.curveMotion = false;

            this.moveT = 0;

            this.speed = 0.5f;
        }

        protected virtual bool InitMotionByList(bool firstTime = false)
        {
            if (this.roadIndex >= this.roadList.Count - 1)
            {
                return false;
            }

            this.canMove = true;

            FishRoad baseConfig = this.roadList[this.roadIndex];

            this.baseX = baseConfig.x;
            this.baseY = baseConfig.y;
            FishRoad aimConfig = this.roadList[this.roadIndex + 1];
            this.aimX = aimConfig.x;
            this.aimY = aimConfig.y;
            this.aimOffsetX = aimConfig.offsetX;
            this.aimOffsetY = aimConfig.offsetY;
            this.speed = aimConfig.speed * 0.1f;
            if (this.aimOffsetX == 0 && this.aimOffsetY == 0)
            {
                this.curveMotion = false;
                float angles = Mathf.Atan2((this.aimY - this.baseY), (this.aimX - this.baseX)) * Mathf.Rad2Deg;
                this.fishLocalEulerAngles.z = angles;
                this.fish.localEulerAngles = this.fishLocalEulerAngles;
            }
            else
            {
                this.curveMotion = true;
            }


            if (this.moveT == 0)
            {
                this.fishLocalPosition.x = this.baseX;
                this.fishLocalPosition.y = this.baseY;
                this.fishLocalPosition.z = this.zOrder;
                this.fish.localPosition = this.fishLocalPosition;
            }
            else
            {
                //同步鱼的时候使用
                float _aimX = this.aimX;
                float _aimY = this.aimY;
                if (this.curveMotion)
                {
                    _aimX = this.aimX + this.aimOffsetX * (1 - this.moveT);
                    _aimY = this.aimY + this.aimOffsetY * (1 - this.moveT);
                }

                this.fishLocalPosition.x = this.baseX + (_aimX - this.baseX) * this.moveT;
                this.fishLocalPosition.y = this.baseY + (_aimY - this.baseY) * this.moveT;
                this.fishLocalPosition.z = this.zOrder;
                this.fish.localPosition = this.fishLocalPosition;
            }


            if (firstTime)
            {
                //算出下一帧坐标
                float _moveT = 0.016f;
                float _aimX, _aimY;
                if (this.curveMotion)
                {
                    _aimX = this.aimX + this.aimOffsetX * (1 - _moveT);
                    _aimY = this.aimY + this.aimOffsetY * (1 - _moveT);
                }
                else
                {
                    _aimX = this.aimX;
                    _aimY = this.aimY;
                }

                float angles = Mathf.Atan2((_aimY - this.baseY), (_aimX - this.baseX)) * Mathf.Rad2Deg;
                this.fishLocalEulerAngles.z = angles;
                this.fish.localEulerAngles = this.fishLocalEulerAngles;
            }

            return true;
        }


        public virtual void SetZOrder(int z = 0)
        {
            this.zOrder = this.fixedZ == 0 ? z : this.fixedZ;
        }

        public virtual void SetIsSummon(bool flag)
        {
            this.isSummon = flag;
        }

        public virtual void InitRoad(int _fishRoad, float _delay = 0, int _roadIndex = 0, float _moveT = 0)
        {
        }

        public virtual void InitRoad(List<FishRoad> list, float _delay = 0, int _roadIndex = 0, float _moveT = 0)
        {
            this.roadList = list;
            this.roadIndex = _roadIndex;
            this.delay = _delay;
            this.moveT = _moveT;
            SetZOrder(LTBY_FishManager.Instance.AllocateZOrder());
            InitMotionByList(true);

            if (this.isSummon)
            {
                this.summonT = 0;
                this.summonSpeed = 0.5f;

                this.summonScaleDelta = this.fish.localScale;
                this.fish.localScale = new Vector3(0, 0, 0);

                this.summonZDelta = 10;
                this.fishLocalPosition.z = this.zOrder + this.summonZDelta;
                this.fish.localPosition = this.fishLocalPosition;

                Vector3 worldPos = GetWorldPos();
                worldPos.z = this.zOrder + this.summonZDelta * 0.8f;
                LTBY_EffectManager.Instance.CreateEffect<SummonAppear>(LTBY_GameView.GameInstance.chairId, worldPos);
            }

            if (this.delay <= 0) return;
            this.fishAnimator = this.fishAnimator == null ? this.fish.GetComponentInChildren<Animator>() : this.fishAnimator;
            CloseCollider();
            this.fishAnimator.enabled = false;
        }

        public virtual void SetPosition(float x, float y)
        {
            Vector3 curPos = this.fishLocalPosition;
            if (this.curveMotion)
            {
                float curAngles = this.fishLocalEulerAngles.z;
                float nextAngles = Mathf.Atan2((y - curPos.y), (x - curPos.x)) * Mathf.Rad2Deg;
                float delta = (nextAngles - curAngles);
                if (delta > 180)
                {
                    delta -= 360;
                    curAngles += 360;
                }
                else if (delta < -180)
                {
                    delta += 360;
                    curAngles -= 360;
                }

                // DebugHelper.LogError($"要到达的角度:{nextAngles}  当前的角度:{curAngles}");
                curAngles += Mathf.Clamp(delta, -2, 2);
                //DebugHelper.LogError($"本来转动的角度{delta}  实际转的角度{Mathf.Clamp(delta, -2, 2)}");
                this.fishLocalEulerAngles.z = curAngles;
                this.fish.localEulerAngles = this.fishLocalEulerAngles;
            }

            this.fishLocalPosition.x = x;
            this.fishLocalPosition.y = y;
            this.fish.localPosition = this.fishLocalPosition;
        }

        public virtual Vector3 GetWorldPos()
        {
            return this.fish.position;
        }

        public virtual List<Vector3> GetBonesWorldPosList()
        {
            return null;
        }

        public virtual List<int> GetAcedFishIdList()
        {
            return null;
        }

        public virtual List<int> GetInScreenFishIdList()
        {
            return null;
        }

        public virtual void RefreshTreasureData(SCTreasureFishInfo data)
        {
        }

        public virtual void GetCaptureInfo(SCTreasureFishCatched data)
        {
        }
    }

    /// <summary>
    /// 鱼阵
    /// </summary>
    public class FishArrayClass : FishClass
    {
        private int arrayId;
        List<FishClass> subFishList;

        public override void OnCreate(int _arrayId, List<FishArrayParams> list, Transform _parent)
        {
            this.arrayId = _arrayId;

            this.subFishList = new List<FishClass>();

            this.fishRoad = 0;
            this.fishArray = 0;

            this.fish = new GameObject().transform;
            this.fish.name = $"FishArray{_arrayId}";
            this.fish.parent = _parent;

            this.fish.localScale = new Vector3(1, 1, 1);

            this.fishLocalEulerAngles = new Vector3(0, 0, 0);
            this.fish.localEulerAngles = this.fishLocalEulerAngles;

            this.fishLocalPosition = new Vector3(0, 0, 0);

            for (int i = 0; i < list.Count; i++)
            {
                FishArrayParams v = list[i];
                if (v.fishId <= 0) continue;
                //v.fishId == 0 表示同步过来的鱼已经被捕获
                if (!LTBY_FishManager.Instance.fishConfig.ContainsKey(v.fishType))
                {
                    DebugHelper.LogError($"{v.fishType}类型的鱼没有配置表!!!!");
                }
                else
                {
                    FishClass _fish = LTBY_FishManager.Instance.GetFishFromPool(v.fishType, this.fish);
                    _fish.OnCreate(v.fishId);
                    _fish.SetZOrder(v.fishLayer);
                    _fish.SetGrowStage(v.fishStage);
                    _fish.SetIsAced(v.isAced);
                    _fish.SetPosition(v.x, v.y);
                    this.subFishList.Add(_fish);
                }
            }

            this.delay = 0;
            this.canScale = false;
            this.canMove = false;

            this.isMoveOut = false;

            this.canUpdate = true;

            if (IlBehaviour == null)
            {
                IlBehaviour = this.fish.gameObject.AddComponent<ILBehaviour>();
            }

            IlBehaviour.UpdateEvent = Update;
            // this.updateKey = LTBY_Extend.Instance.StartTimer(() => { Update(); });

            this.moveOutKey = 0;
        }

        public override void MoveOut(float delayMoveTime)
        {
            bool _inScreen = false;
            for (int i = 0; i < subFishList.Count; i++)
            {
                FishClass v = subFishList[i];
                if (v == null || !v.inScreen) continue;
                _inScreen = true;
                break;
            }

            if (!_inScreen)
            {
                LTBY_FishManager.Instance.DestroyFishArray(this.arrayId, true);
            }
            else
            {
                this.moveOutKey = LTBY_Extend.Instance.StartTimer(InitMoveOut, delayMoveTime, 1);
            }
        }

        public FishClass GetFish(int _fishId)
        {
            for (int i = 0; i < subFishList.Count; i++)
            {
                FishClass v = subFishList[i];
                if (v != null && v.fishId == _fishId)
                {
                    return v;
                }
            }

            return null;
        }

        public int GetInScreenFishIdByType(int _fishType)
        {
            for (int i = 0; i < this.subFishList.Count; i++)
            {
                FishClass v = subFishList[i];
                if (v != null && v.inScreen && !v.isDead && v.fishType == _fishType)
                {
                    return v.fishId;
                }
            }

            return 0;
        }

        public int GetInScreenAcedFishId()
        {
            for (int i = 0; i < this.subFishList.Count; i++)
            {
                FishClass v = subFishList[i];
                if (v != null && v.inScreen && !v.isDead && v.isAced)
                {
                    return v.fishId;
                }
            }

            return 0;
        }

        public List<FishClass> GetInScreenAwardFishList()
        {
            List<FishClass> list = new List<FishClass>();

            for (int i = 0; i < subFishList.Count; i++)
            {
                var item = subFishList[i];
                if (item != null && item.inScreen && !item.isDead && item.isAwardFish)
                {
                    list.Add(item);
                }
            }

            return list;
        }

        public override List<int> GetAcedFishIdList()
        {
            List<int> list = new List<int>();
            for (int i = 0; i < subFishList.Count; i++)
            {
                FishClass v = subFishList[i];
                if (v != null && !v.isDead && v.isAced)
                {
                    list.Add(v.fishId);
                }
            }

            return list;
        }

        public List<FishClass> GetInScreenFishClassList()
        {
            List<FishClass> list = new List<FishClass>();

            for (int i = 0; i < subFishList.Count; i++)
            {
                FishClass v = subFishList[i];
                if (v != null && !v.isDead && v.inScreen)
                {
                    list.Add(v);
                }
            }

            return list;
        }
        public override List<int> GetInScreenFishIdList()
        {
            List<int> list = new List<int>();

            for (int i = 0; i < subFishList.Count; i++)
            {
                FishClass v = subFishList[i];
                if (v != null && !v.isDead && v.inScreen)
                {
                    list.Add(v.fishId);
                }
            }

            return list;
        }

        public bool DestroyFish(int _fishId, bool sendMsgToServer)
        {
            for (int i = subFishList.Count - 1; i >= 0; i--)
            {
                FishClass v = subFishList[i];
                if (v == null || v.fishId != _fishId) continue;
                v.OnDestroy(sendMsgToServer);
                this.subFishList[i] = null;
                this.subFishList.RemoveAt(i);
                return true;
            }

            return false;
        }

        protected override void MoveFinish()
        {
            LTBY_FishManager.Instance.DestroyFishArray(this.arrayId, true);
        }

        public override void OnDestroy(bool sendMsgToServer = false)
        {
            this.canUpdate = false;
            if (IlBehaviour != null)
            {
                IlBehaviour.UpdateEvent = null;
                LTBY_Extend.Destroy(IlBehaviour);
                IlBehaviour = null;
            }

            for (int i = 0; i < subFishList.Count; i++)
            {
                FishClass v = subFishList[i];
                v?.OnDestroy(sendMsgToServer);
            }

            this.subFishList.Clear();

            this.canMove = false;

            LTBY_Extend.Instance.StopTimer(this.updateKey);

            if (this.moveOutKey > 0)
            {
                LTBY_Extend.Instance.StopTimer(this.moveOutKey);
                this.moveOutKey = 0;
            }

            LTBY_ResourceManager.Instance.Destroy(this.fish.gameObject);
            this.fish = null;
        }
    }

    /// <summary>
    /// 聚宝盆捕获
    /// </summary>
    public class TreasureBowl : FishClass
    {
        private SkinnedMeshRenderer[] allMeshRender;
        private List<Material> allMats;

        public Transform RotateRoot { get; private set; }

        private Transform model;
        private Transform topPoint;
        private Transform bottomPoint;
        private List<Transform> StagePart;
        private Transform EffectRoot;
        private Transform LockPos;
        private Transform TreasureBowlText;
        private Transform TopPart;
        private TextMeshProUGUI topText;

        private Transform bottomPart;

        private TextMeshProUGUI bottomText;
        private Transform ChangeStageEffect;
        private List<int> TimerKeys;
        public List<int> ActionKeys;
        private float UpLevelTime;
        private float captureTime;
        private bool isFaceRight;
        private int fishValue;
        private int TreasureStage;
        private int ChangeStageActionTimer;

        public override void Init(int _fishType, Transform _parent)
        {
            base.Init(_fishType, _parent);

            this.normalColor = Color.white;

            this.allMeshRender = this.fish.GetComponentsInChildren<SkinnedMeshRenderer>();
            this.allMats = new List<Material>();
            for (int i = 0; i < this.allMeshRender.Length; i++)
            {
                this.allMats.Add(this.allMeshRender[i].material);
            }

            this.topPoint = this.fish.FindChildDepth("topPoint");

            this.bottomPoint = this.fish.FindChildDepth("bottomPoint");

            this.StagePart = new List<Transform>();
            this.RotateRoot = this.fish.FindChildDepth("RotateRoot");

            this.model = this.fish.FindChildDepth("RotateRoot/model");

            this.StagePart.Add(this.model.FindChildDepth("cjb_145_03"));

            this.StagePart.Add(this.model.FindChildDepth("cjb_145_02"));

            this.StagePart.Add(this.model.FindChildDepth("cjb_145_01"));

            this.EffectRoot = this.model.FindChildDepth("Anm_145/joint1/joint18");

            this.LockPos = this.model.FindChildDepth("Anm_145/joint1/LockPos");
        }

        public override void OnCreate(int _fishId)
        {
            base.OnCreate(_fishId);
            for (int i = 1; i < this.allMats.Count; i++)
            {
                this.allMats[i].color = this.normalColor;
            }

            Vector3 curRotation = Vector3.zero;

            if (LTBY_GameView.GameInstance.CheckIsTop())
            {
                curRotation = new Vector3(0, 0, 180);
            }

            this.fish.localEulerAngles = curRotation;


            this.TreasureBowlText =
                LTBY_PoolManager.Instance.GetUiItem("LTBY_TreasureBowlText", LTBYEntry.Instance.GetUiLayer());
            this.TreasureBowlText.localPosition = new Vector3(1000, 0, 0);

            this.TopPart = this.TreasureBowlText.FindChildDepth("Top");

            this.topText = this.TreasureBowlText.FindChildDepth<TextMeshProUGUI>("Top/topText");

            this.bottomPart = this.TreasureBowlText.FindChildDepth("Bottom");

            this.bottomText = this.TreasureBowlText.FindChildDepth<TextMeshProUGUI>("Bottom/bottomText");

            this.ChangeStageEffect = this.TreasureBowlText.FindChildDepth("ChangeStageEffect");

            this.TimerKeys = new List<int>();
            this.ActionKeys = new List<int>();

            //初始化

            this.topText.gameObject.SetActive(false);

            this.ChangeStageEffect.gameObject.SetActive(false);

            this.bottomText.text = "x0".ShowRichText();

            this.UpLevelTime = 0f; // 播放升级动画的时间

            this.captureTime = 0f; // 播放被捕获动画的时间


            this.isFaceRight = false;

            this.fishValue = 0; // 当前展示的鱼的分值

            this.TreasureStage = 1; // 聚宝盆初始阶段为1

            this.ChangeStageActionTimer = -1; // 变身动画的定时器

            ChangeStage(this.TreasureStage);

            SetHeadDirection(true, true);
            RefreshBottomText(100);
        }

        public override bool OnCapture()
        {
            for (int i = 1; i < this.allMats.Count; i++)
            {
                this.allMats[i].color = this.normalColor;
            }

            CloseCollider();
            this.isDead = true;

            int[] keys = this.lockEffect.GetDictionaryKeys();
            for (int i = 0; i < keys.Length; i++)
            {
                LTBY_FishManager.Instance.UnLockFish(keys[i]);
            }

            LTBY_FishManager.Instance.PlayOnlySound(this.fishDeadSound);

            this.deadTime = 1.5f;

            return true;
        }

        public override void OnDestroy(bool sendMsgToServer = false)
        {
            base.OnDestroy(sendMsgToServer);
            ReleaseTBText();

            if (this.ChangeStageActionTimer != -1)
            {
                LTBY_Extend.Instance.StopAction(this.ChangeStageActionTimer);
                this.ChangeStageActionTimer = -1;
            }

            for (int i = 0; i < this.TimerKeys.Count; i++)
            {
                LTBY_Extend.Instance.StopTimer(this.TimerKeys[i]);
            }

            this.TimerKeys.Clear();
        }

        private void ReleaseTBText()
        {
            if (this.TreasureBowlText == null)
            {
                return;
            }

            this.TopPart.transform.localPosition = Vector3.zero;
            this.TopPart = null;
            this.bottomPart.transform.localPosition = Vector3.zero;
            this.bottomPart = null;

            LTBY_PoolManager.Instance.RemoveUiItem("LTBY_TreasureBowlText", this.TreasureBowlText);

            this.TreasureBowlText = null;
        }

        private void RefreshBottomText(int num)
        {
            this.bottomText.gameObject.SetActive(true);
            this.bottomText.text = $"x{num}".ShowRichText();
            this.fishValue = num;
        }

        public override void RefreshTreasureData(SCTreasureFishInfo data)
        {
            if (this.fishValue == 0)
            {
                RefreshBottomText(data.fish_value);
            }
            else
            {
                this.fishValue = data.fish_value;
            }

            this.topText.gameObject.SetActive(data.accum_money > 0);

            string accumMoney = null;

            accumMoney = $"{data.accum_money.ShortNumber()}";

            this.topText.text = $"+{accumMoney}".ShowRichText();

            if (data.cur_stage > this.TreasureStage)
            {
                SetGrowStage(data.cur_stage, true);
            }
        }

        public override void GetCaptureInfo(SCTreasureFishCatched data)
        {
            this.isDead = data.death;

            //说明正在播升级动画,取消升级动画

            if (this.ChangeStageActionTimer != -1)
            {
                ChangeStage(this.TreasureStage, false);
                this.UpLevelTime = 0;
            }

            //说明死亡 是第三阶段捕获

            if (this.isDead)
            {
                PlayFinalCaptureEffect(data);
            }
            else
            {
                PlayCaptureEffect(data);
            }
        }

        /// <summary>
        /// 播放最终阶段被捕获的特效
        /// </summary>
        /// <param name="data"></param>
        private void PlayFinalCaptureEffect(SCTreasureFishCatched data)
        {
            bool isFinal = data.cur_stage == 5;
            this.deadTime = isFinal ? 1.5f : 5f;
            LTBY_EffectManager.Instance.CreateEffect<BaoJinBi>(0, new EffectParamData()
            {
                EffectName = $"LTBY_Jubaopen_baojinbi02",
                lifeTime = 3f,
                position = this.EffectRoot.position,
            });

            if (LTBY_GameView.GameInstance.IsSelf(data.chair_idx))
            {
                LTBYEntry.Instance.ShakeFishLayer(3);
                LTBY_Audio.Instance.Play(SoundConfig.JBPExplosionBig);
                if (isFinal)
                {
                    LTBY_Audio.Instance.Play(SoundConfig.JBPFinalVoice);
                }
            }

            if (!isFinal)
            {
                this.fishAnimator = this.fishAnimator == null ? this.fish.GetComponentInChildren<Animator>() : this.fishAnimator;
                if (!this.fishAnimator.GetCurrentAnimatorStateInfo(0).IsName($"stand02"))
                {
                    this.fishAnimator.SetTrigger($"stand02");
                }
                else
                {
                    this.fishAnimator.Play($"stand02", -1, 0);
                }

                float curScale = this.fish.localScale.x;
                Tween tween = DOTween.To(value =>
                {
                    if (this.fish == null) return;
                        float scale = (1 - value / 1000) * curScale;
                        this.fish.localScale = new Vector3(scale, scale, scale);
                }, 0, 1000, 1).SetEase(Ease.InQuint).OnKill(() =>
                {
                    ReleaseTBText();
                    LTBY_EffectManager.Instance.CreateEffect<TreasureBowlEffect2>(data.chair_idx, data,
                        FishConfig.TreasureBowlConfig.captureEffectType[data.cur_stage]);
                    this.deadTime = 0;
                }).SetDelay(2.2f).SetLink(this.fish.gameObject);
                int _actionKey = LTBY_Extend.Instance.RunAction(tween);

                this.ActionKeys.Add(_actionKey);
            }
            else
            {
                LTBY_EffectManager.Instance.CreateEffect<TreasureBowlEffect1>(data.chair_idx, data, this.fish.position);
            }
        }

        /// <summary>
        /// 播放前2阶段被捕获的特效
        /// </summary>
        /// <param name="data"></param>
        private void PlayCaptureEffect(SCTreasureFishCatched data)
        {
            bool isSelf = LTBY_GameView.GameInstance.IsSelf(data.chair_idx);
            //说明此时正在播捕获动画 那第二个捕获动画 就不转圈了 直接放特效

            this.fishAnimator = this.fishAnimator == null ? this.fish.GetComponentInChildren<Animator>() : this.fishAnimator;
            if (!this.fishAnimator.GetCurrentAnimatorStateInfo(0).IsName($"stand02"))
            {
                this.fishAnimator.SetTrigger($"stand02");
            }
            else
            {
                this.fishAnimator.Play($"stand02", -1, 0);
            }

            if (isSelf)
            {
                LTBY_Audio.Instance.Play(SoundConfig.JBPCaptureRotate);
            }

            this.captureTime = 2.7f;

            float delayTime = 2.1f;

            int key = LTBY_Extend.Instance.DelayRun(delayTime, () =>
            {
                if (isSelf)
                {
                    LTBYEntry.Instance.ShakeFishLayer(2);
                    LTBY_Audio.Instance.Play(SoundConfig.JBPExplosionSmall);
                }

                LTBY_EffectManager.Instance.CreateEffect<BaoJinBi>(0, new EffectParamData()
                {
                    EffectName = "LTBY_Jubaopen_baojinbi01",
                    lifeTime = 3,
                    position = this.EffectRoot.position,
                });
            });
            this.TimerKeys.Add(key);

            key = LTBY_Extend.Instance.DelayRun(delayTime + 0.2f,
                () =>
                {
                    LTBY_EffectManager.Instance.CreateEffect<TreasureBowlEffect2>(data.chair_idx, data,
                        FishConfig.TreasureBowlConfig.captureEffectType[data.cur_stage]);
                });
            this.TimerKeys.Add(key);
        }

        public override void SetGrowStage(int _stage = 0, bool showEffect = false)
        {
            if (_stage == 0 || this.TreasureStage == _stage)
            {
                return;
            }

            DebugHelper.LogError(showEffect ? $"聚宝盆正常升级:{_stage}" : $"聚宝盆同步消息  设置stage:{_stage}");

            this.TreasureStage = _stage;

            ChangeStage(this.TreasureStage, showEffect);
        }

        private void ChangeStage(int targetStage, bool showEffect = false)
        {
            //每次变身的时候 都要清掉播放的动画
            if (this.ChangeStageActionTimer != -1)
            {
                LTBY_Extend.Instance.StopAction(this.ChangeStageActionTimer);
                this.ChangeStageActionTimer = -1;
            }

            //这里无论展示变身效果与否 都要重置

            this.RotateRoot.localEulerAngles = Vector3.zero;

            if (!showEffect)
            {
                for (int i = 0; i < this.StagePart.Count; i++)
                {
                    this.StagePart[i].gameObject.SetActive(targetStage >= FishConfig.TreasureBowlConfig.StageNum[i + 1]);
                }

                float scale = FishConfig.TreasureBowlConfig.Scale[targetStage];
                this.fish.localScale = new Vector3(scale, scale, scale);
                AdjustLockEffect();
                RefreshBottomText(this.fishValue);
                return;
            }

            this.UpLevelTime = 2f;

            bool showRotateEffect = FishConfig.TreasureBowlConfig.ShowRotate[targetStage];


            int key = LTBY_Extend.Instance.DelayRun(0.5f,
                () => { LTBY_Audio.Instance.Play(SoundConfig.JBPChangeStage); });
            this.TimerKeys.Add(key);

            Tween tween = DOTween.To(value =>
            {
                if (this.fish == null) return;
                if (showRotateEffect)
                {
                    if (this.RotateRoot == null) return;
                    float rotateY = value * (LTBY_GameView.GameInstance.CheckIsTop() ? -1.08f : 1.08f);
                    Vector3 curAngles = this.RotateRoot.localEulerAngles;
                    this.RotateRoot.localEulerAngles = new Vector3(curAngles.x, rotateY, curAngles.z);
                }

                var ScaleConfig = FishConfig.TreasureBowlConfig.Scale;

                float scale = ScaleConfig[targetStage - 1] +
                              value / 1000 * (ScaleConfig[targetStage] - ScaleConfig[targetStage - 1]);

                this.fish.localScale = new Vector3(scale, scale, scale);
            }, 0, 1000, 2).SetEase(Ease.InQuint).OnKill(() =>
            {
                AdjustLockEffect();

                for (int i = 0; i < this.StagePart.Count; i++)
                {
                    this.StagePart[i]?.gameObject.SetActive(targetStage >= FishConfig.TreasureBowlConfig.StageNum[i+1]);
                }

                AdjustPosition(this.ChangeStageEffect, this.EffectRoot.position);

                this.ChangeStageEffect?.gameObject.SetActive(false);

                LTBY_Audio.Instance.Play(SoundConfig.JBPChangeStageFlash);
                this.ChangeStageEffect?.gameObject.SetActive(true);

                this.ChangeStageActionTimer = -1;

                RefreshBottomText(this.fishValue);
            }).SetLink(this.fish.gameObject);
            this.ChangeStageActionTimer = LTBY_Extend.Instance.RunAction(tween);
        }

        /// <summary>
        /// 实时调整UI位置  与模型对应
        /// </summary>
        /// <param name="trans"></param>
        /// <param name="targetPosition"></param>
        private void AdjustPosition(Transform trans, Vector3 targetPosition)
        {
            if (trans == null) return;
            //这里可以直接赋值主要是因为两个相机的参数都是一样的，可简化转化的计算 当相机不一样时，需要进行转换
            targetPosition.z = 0;
            trans.position = targetPosition;
            Vector3 localPos = trans.localPosition;
            trans.localPosition = new Vector3(localPos.x, localPos.y, 0);
        }

        protected override void Update()
        {
            if (!this.canUpdate) return;
            AdjustPosition(this.TopPart, this.topPoint.position);
            AdjustPosition(this.bottomPart, this.bottomPoint.position);

            float dt = Time.deltaTime;
            if (this.isDead)
            {
                this.deadTime -= dt;
                if (this.deadTime <= 0)
                {
                    LTBY_FishManager.Instance.DestroyFish(this.fishId, false);
                }

                return;
            }

            if (this.delay > 0)
            {
                this.delay -= dt;
                if (!(this.delay <= 0)) return;
                this.fishAnimator = this.fishAnimator == null ? this.fish.GetComponentInChildren<Animator>() : this.fishAnimator;
                OpenCollider();
                this.fishAnimator.enabled = true;
                return;
            }

            if (this.beHit)
            {
                this.hitTime -= dt;
                if (this.hitTime <= 0)
                {
                    this.beHit = false;
                    for (int i = 0; i < this.allMats.Count; i++)
                    {
                        this.allMats[i].color = this.normalColor;
                    }
                }
            }

            if (this.UpLevelTime > 0)
            {
                this.UpLevelTime -= dt;
                return;
            }

            if (this.captureTime > 0)
            {
                this.captureTime -= dt;
                return;
            }

            if (!this.canMove) return;
            Motion(dt);
        }

        protected override void Motion(float dt)
        {
            this.moveT += dt * this.speed;

            if (this.moveT >= 1)
            {
                this.moveT = 0;
                this.roadIndex++;
                if (!InitMotionByList())
                {
                    MoveFinish();
                }
            }
            else
            {
                float _aimX = this.aimX;
                float _aimY = this.aimY;
                if (this.curveMotion)
                {
                    _aimX = this.aimX + this.aimOffsetX * (1 - this.moveT);
                    _aimY = this.aimY + this.aimOffsetY * (1 - this.moveT);
                }

                this.fishLocalPosition.x = this.baseX + (_aimX - this.baseX) * this.moveT;
                this.fishLocalPosition.y = this.baseY + (_aimY - this.baseY) * this.moveT;
                this.fish.localPosition = this.fishLocalPosition;
            }
        }

        protected override bool InitMotionByList(bool firstTime = false)
        {
            if (this.roadIndex >= this.roadList.Count - 1)
            {
                return false;
            }

            this.canMove = true;

            FishRoad baseConfig = this.roadList[this.roadIndex];

            this.baseX = baseConfig.x;
            this.baseY = baseConfig.y;
            FishRoad aimConfig = this.roadList[this.roadIndex + 1];
            this.aimX = aimConfig.x;
            this.aimY = aimConfig.y;
            this.aimOffsetX = aimConfig.offsetX;
            this.aimOffsetY = aimConfig.offsetY;
            this.speed = aimConfig.speed * 0.1f;
            if (this.aimOffsetX == 0 && this.aimOffsetY == 0)
            {
                this.curveMotion = false;
            }
            else
            {
                this.curveMotion = true;
            }

            if (this.moveT == 0)
            {
                this.fishLocalPosition.x = this.baseX;
                this.fishLocalPosition.y = this.baseY;
                this.fishLocalPosition.z = this.zOrder;
                this.fish.localPosition = this.fishLocalPosition;
            }
            else
            {
                //同步鱼的时候使用
                float _aimX = this.aimX;
                float _aimY = this.aimY;
                if (this.curveMotion)
                {
                    _aimX = this.aimX + this.aimOffsetX * (1 - this.moveT);
                    _aimY = this.aimY + this.aimOffsetY * (1 - this.moveT);
                }

                this.fishLocalPosition.x = this.baseX + (_aimX - this.baseX) * this.moveT;
                this.fishLocalPosition.y = this.baseY + (_aimY - this.baseY) * this.moveT;
                this.fishLocalPosition.z = this.zOrder;
                this.fish.localPosition = this.fishLocalPosition;
            }

            float aimDeltaX = this.aimX - this.baseX;
            if (Mathf.Abs(aimDeltaX) > 0.5f)
            {
                SetHeadDirection(aimDeltaX > 0, firstTime);
            }

            return true;
        }

        private void SetHeadDirection(bool isRight, bool isFirstTime)
        {
            Vector3 targetRotate;

            Vector3 startRotate;

            bool isTop = LTBY_GameView.GameInstance.CheckIsTop();
            if ((isRight && !isTop) || (!isRight && isTop))
            {
                targetRotate = FishConfig.TreasureBowlRotation[1];

                startRotate = FishConfig.TreasureBowlRotation[2];
            }
            else
            {
                targetRotate = FishConfig.TreasureBowlRotation[2];
                startRotate = FishConfig.TreasureBowlRotation[1];
            }

            //这里是第一次
            if (isFirstTime)
            {
                this.isFaceRight = isRight;
                this.model.localEulerAngles = new Vector3(targetRotate.x, targetRotate.y, targetRotate.z);
                return;
            }

            if (isRight == this.isFaceRight) return;
            this.isFaceRight = isRight;
            Tween tween = DOTween.To(value =>
            {
                if (this.model == null) return;
                float x = (targetRotate.x - startRotate.x) / 100 * value + startRotate.x;
                float y = (targetRotate.y - startRotate.y) / 100 * value + startRotate.y;
                float z = (targetRotate.z - startRotate.z) / 100 * value + startRotate.z;
                this.model.localEulerAngles = new Vector3(x, y, z);
            }, 0, 100, 1);
            int key = LTBY_Extend.Instance.RunAction(tween);
            this.actionKey.Add(key);
        }

        protected override void HitEffect()
        {
            if (this.beHit) return;

            for (int i = 1; i < this.allMats.Count; i++)
            {
                this.allMats[i].color = this.hitColor;
            }

            this.beHit = true;
            this.hitTime = 0.2f;

            if (string.IsNullOrEmpty(this.fishHitSound)) return;
            LTBY_FishManager.Instance.PlayOnlySound(this.fishHitSound);
            this.fishHitSound = null;
        }

        protected override void OutScreen(int boneIndex = 0)
        {
            if (LTBYEntry.Instance.GetIsChangeScene()) return;

            this.inScreen = false;
            int[] keys = lockEffect.GetDictionaryKeys();
            for (int i = 0; i < keys.Length; i++)
            {
                LTBY_FishManager.Instance.UnLockFish(keys[i]);
            }

            if (LTBY_FishManager.Instance.MissileLockSwitch)
            {
                MissileLock(this.inScreen);
            }
        }

        private void AdjustLockEffect()
        {
            float scale = 1 / FishConfig.TreasureBowlConfig.Scale[this.TreasureStage];
            int[] keys = lockEffect.GetDictionaryKeys();
            for (int i = 0; i < keys.Length; i++)
            {
                lockEffect[keys[i]].localScale = new Vector3(scale, scale, scale);
            }
        }

        public override void Lock(int chairId, Vector3 pos)
        {
            float scale = 1 / FishConfig.TreasureBowlConfig.Scale[this.TreasureStage];

            if (this.lockEffect.ContainsKey(chairId)) return;
            if (LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                Transform effect = LTBY_PoolManager.Instance.GetGameItem("LTBY_LockSelf", this.fish);
                effect.localEulerAngles = new Vector3(0, 0, 0);
                effect.localPosition = new Vector3(0, 0, -2);
                if (pos != default)
                {
                    effect.localScale = new Vector3(scale, scale, scale);
                    Vector3 aimPos = effect.position;
                    effect.position = pos;
                    Tween tween = DOTween.To(value =>
                    {
                        if (effect == null) return;
                        float t = value * 0.01f;
                        effect.position = new Vector3(pos.x + (aimPos.x - pos.x) * t,
                            pos.y + (aimPos.y - pos.y) * t, aimPos.z);
                    }, 0, 100, 0.2f).OnKill(() =>
                    {
                        effect.localPosition = LTBY_GameView.GameInstance.IsSelf(chairId)
                            ? new Vector3(0, 0, -2.1f)
                            : new Vector3(0, 0, -2);
                    }).SetLink(effect.gameObject);
                    int key = LTBY_Extend.Instance.RunAction(tween);
                    this.actionKey.Add(key);
                }
                else
                {
                    effect.localScale = new Vector3(10, 10, 10);
                    Tween tween = effect.DOScale(new Vector2(scale, scale), 0.6f).SetLink(effect.gameObject);
                    int key = LTBY_Extend.Instance.RunAction(tween);
                    this.actionKey.Add(key);
                }

                this.lockEffect[chairId] = effect;
            }
            else
            {
                Transform effect = LTBY_PoolManager.Instance.GetGameItem("LTBY_LockOther", this.fish);
                effect.localEulerAngles = new Vector3(0, 0, 0);
                effect.localPosition = new Vector3(0, 0, -2);
                effect.localScale = new Vector3(scale, scale, scale);
                lockEffect.Remove(chairId);
                this.lockEffect.Add(chairId, effect);
            }
        }
    }

    public class FishArrayParams
    {
        public int fishId;
        public int fishType;
        public int fishLayer;
        public int fishStage;
        public bool isAced;
        public float x;
        public float y;
    }

    public class TreasureFishInfo
    {
        public int fish_uid;
        public int fish_value;
        public long accum_money;
        public int cur_stage;
    }
}