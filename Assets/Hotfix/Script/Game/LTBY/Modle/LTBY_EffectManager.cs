using System;
using DG.Tweening;
using Spine.Unity;
using System.Collections.Generic;
using LuaFramework;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Random = UnityEngine.Random;

namespace Hotfix.LTBY
{
    public class EffectParamData
    {
        public List<EffectParamData> fishList;
        public int chairId;
        public int level;
        public Vector3 pos;
        public bool playSound;
        public long score;
        public Vector3 worldPos;
        public Vector3 aimPos;
        public bool showText;
        public Action callBack;
        public Vector3 angles;
        public int useMul;
        public int baseScore;
        public string showType;
        public long showScore;
        public int fishType;
        public int multiple;
        public int bulletType;
        public int ratio;
        public List<int> mulList;
        public bool isElectricDragon;
        public List<int> multiples;
        public int id;
        public int count;
        public float time;
        public int mul;
        public string itemType;
        public string EffectName;
        public Vector3 position;
        public float lifeTime;
        public Action func;
        public string key;
        public string value;
        public EffectParamData award_cnt;
        public EffectParamData award;
        public int delay;
        public float scale;
        public long earn;
        public int fish_value;
        public int accum_money;
        public bool display_multiple;
    }

    public class EffectData
    {
        public Stack<EffectClass> Pool;
        public int maxNum;
    }

    /// <summary>
    /// 特效管理
    /// </summary>
    public class LTBY_EffectManager : SingletonNew<LTBY_EffectManager>
    {
        private int EffectId;
        Dictionary<int, Dictionary<int, EffectClass>> EffectList = new Dictionary<int, Dictionary<int, EffectClass>>();

        public Transform UiLayer;
        public Transform UiTopLayer;
        public Transform FishLayer;
        private Dictionary<int, SpecialBatterySpineAward> DrillList;
        private Dictionary<int, Dictionary<int, MissileSpineAward>> MissileList;
        private Dictionary<int, SpecialBatterySpineAward> ElectricList;
        private Dictionary<int, SpecialBatterySpineAward> FreeBatteryList;
        private Dictionary<int, ElectricDragonSpineAward> ElectricDragonSpineList;
        private Dictionary<int, EffectClass> DragonBallList;
        private FishAppear FishAppear;

        /// <summary>
        /// 特效的对象池
        /// </summary>
        private Dictionary<string, EffectData> EffectPoolItems = new Dictionary<string, EffectData>()
        {
            {nameof(FlyCoin), new EffectData() {maxNum = 60, Pool = new Stack<EffectClass>()}},
            {nameof(EffectLight), new EffectData() {maxNum = 10, Pool = new Stack<EffectClass>()}},
            {nameof(EffectText), new EffectData() {maxNum = 20, Pool = new Stack<EffectClass>()}},
            {nameof(LightAccount), new EffectData() {maxNum = 10, Pool = new Stack<EffectClass>()}},
            {nameof(DropItem), new EffectData() {maxNum = 5, Pool = new Stack<EffectClass>()}},
            {nameof(FishAppear), new EffectData() {maxNum = 1, Pool = new Stack<EffectClass>()}},
            {nameof(SpineAwardLevel), new EffectData() {maxNum = 4, Pool = new Stack<EffectClass>()}},
            {nameof(SpineAwardFullScreen), new EffectData() {maxNum = 1, Pool = new Stack<EffectClass>()}},
            {nameof(SpecialBatterySpineAward), new EffectData() {maxNum = 2, Pool = new Stack<EffectClass>()}},
            {nameof(MissileSpineAward), new EffectData() {maxNum = 1, Pool = new Stack<EffectClass>()}},
            {nameof(PoolTreasure), new EffectData() {maxNum = 1, Pool = new Stack<EffectClass>()}},
            {nameof(Wheel), new EffectData() {maxNum = 5, Pool = new Stack<EffectClass>()}},
            {nameof(CoinOutburst), new EffectData() {maxNum = 1, Pool = new Stack<EffectClass>()}},
            {nameof(FlyText), new EffectData() {maxNum = 4, Pool = new Stack<EffectClass>()}},
            {nameof(ExplosionPoint), new EffectData() {maxNum = 6, Pool = new Stack<EffectClass>()}},
            {nameof(GetItem), new EffectData() {maxNum = 5, Pool = new Stack<EffectClass>()}},
            {nameof(DragonDeadEffect), new EffectData() {maxNum = 2, Pool = new Stack<EffectClass>()}},
            {nameof(DragonSpineAward), new EffectData() {maxNum = 1, Pool = new Stack<EffectClass>()}},
            {nameof(FreeLotteryDropItem), new EffectData() {maxNum = 1, Pool = new Stack<EffectClass>()}},
            {nameof(SummonAppear), new EffectData() {maxNum = 2, Pool = new Stack<EffectClass>()}},
            {nameof(FreeDropItem), new EffectData() {maxNum = 5, Pool = new Stack<EffectClass>()}},
            {nameof(Aced), new EffectData() {maxNum = 4, Pool = new Stack<EffectClass>()}},
            {nameof(AcedLink), new EffectData() {maxNum = 20, Pool = new Stack<EffectClass>()}},
            {nameof(DialFish), new EffectData() {maxNum = 1, Pool = new Stack<EffectClass>()}},
            {nameof(SpineDialFish), new EffectData() {maxNum = 1, Pool = new Stack<EffectClass>()}},
            {nameof(Firework), new EffectData() {maxNum = 1, Pool = new Stack<EffectClass>()}},
            {nameof(ElectricDragonDeadEffect), new EffectData() {maxNum = 1, Pool = new Stack<EffectClass>()}},
            {nameof(DragonBallEffect), new EffectData() {maxNum = 1, Pool = new Stack<EffectClass>()}},
            {nameof(ElectricDragonSpineAward), new EffectData() {maxNum = 1, Pool = new Stack<EffectClass>()}},
            {nameof(DoubleDragonEffect), new EffectData() {maxNum = 1, Pool = new Stack<EffectClass>()}},
            {nameof(PandaDance), new EffectData() {maxNum = 1, Pool = new Stack<EffectClass>()}},
            {nameof(HundredMillionMoney), new EffectData() {maxNum = 1, Pool = new Stack<EffectClass>()}},
            {nameof(TreasureBowlEffect2), new EffectData() {maxNum = 1, Pool = new Stack<EffectClass>()}},
            {nameof(TreasureBowlEffect1), new EffectData() {maxNum = 1, Pool = new Stack<EffectClass>()}},
            {nameof(BaoJinBi), new EffectData() {maxNum = 3, Pool = new Stack<EffectClass>()}},
        };

        private T GetEffectFromPool<T>() where T : EffectClass, new()
        {
            string name = typeof(T).Name;
            if (!EffectPoolItems.ContainsKey(name))
            {
                DebugHelper.LogError($"没有注册此特效:{name}");
                return null;
            }

            // EffectData list = EffectPoolItems[name];
            // int curLength = list.Pool.Count;
            // T result = null;
            // if (curLength > 0)
            // {
            //     result = list.Pool.Pop() as T;
            // }
            // else
            // {
               T result = Activator.CreateInstance<T>();
            // }

            return result;
        }

        private void RemoveEffectToPool<T>(T effect) where T : EffectClass
        {
            effect?.OnDestroy();
            // string name = typeof(T).Name;
            // if (!EffectPoolItems.ContainsKey(name))
            // {
            //     DebugHelper.LogError($"没有注册此特效:{name}");
            //     effect.OnDestroy();
            //     return;
            // }

            // EffectData list = EffectPoolItems[name];
            // int curLength = list.Pool.Count;
            // if (curLength >= list.maxNum)
            // {
                // effect.OnDestroy();
            // }
            // else
            // {
            //     list.Pool.Push(effect);
            //     effect.OnStored();
            // }
        }

        public override void Init(Transform iLEntity = null)
        {
            base.Init(iLEntity);
            UiLayer = LTBYEntry.Instance.GetUiLayer();
            UiTopLayer = LTBYEntry.Instance.GetUiTopLayer();
            FishLayer = LTBYEntry.Instance.GetFishLayer();

            EffectList = new Dictionary<int, Dictionary<int, EffectClass>>();

            DrillList = new Dictionary<int, SpecialBatterySpineAward>();

            MissileList = new Dictionary<int, Dictionary<int, MissileSpineAward>>();

            ElectricList = new Dictionary<int, SpecialBatterySpineAward>();

            FreeBatteryList = new Dictionary<int, SpecialBatterySpineAward>();

            ElectricDragonSpineList = new Dictionary<int, ElectricDragonSpineAward>();

            DragonBallList = new Dictionary<int, EffectClass>();

            EffectId = 0;

            FishAppear = null;

            RegisterEvent();
        }

        public override void Release()
        {
            base.Release();
            DestroyAllEffect();
            UnregisterEvent();
        }

        private void RegisterEvent()
        {
        }

        private void UnregisterEvent()
        {
        }

        //----------------------effect创建与销毁 start--------------------------------
        public T CreateEffect<T>(int chairId, params object[] args) where T : EffectClass, new()
        {
            if (!EffectList.ContainsKey(chairId))
            {
                EffectList.Add(chairId, new Dictionary<int, EffectClass>());
            }

            T effect = GetEffectFromPool<T>();
            int id = AllocateEffectId();
            DestroyEffect<T>(chairId, id);
            if(EffectList[chairId].ContainsKey(id))
            {
                EffectList[chairId][id]?.OnDestroy();
                EffectList[chairId].Remove(id);
            }
            effect.OnCreate(id, chairId, args);
            
            EffectList[chairId].Add(id, effect);
            return effect;
        }

        public void DestroyEffect<T>(int chairId, int id) where T : EffectClass
        {
            if (!EffectList.TryGetValue(chairId ,out var dic)) return;
            if (dic == null)
            {
                EffectList.Remove(chairId);
                return;
            }

            if (!EffectList[chairId].ContainsKey(id)) return;
            // if (!(effect is T t)) effect.OnDestroy();
            // else RemoveEffectToPool(t);
            EffectList[chairId][id]?.OnDestroy();
            EffectList[chairId].Remove(id);
        }
        //----------------------effect创建与销毁 end--------------------------------

        //----------------------Missile创建与销毁 start--------------------------------
        public MissileSpineAward CreateMissile(int chairId, int propId)
        {
            if (!MissileList.ContainsKey(chairId))
            {
                MissileList.Add(chairId, new Dictionary<int, MissileSpineAward>());
            }

            MissileSpineAward effect = GetEffectFromPool<MissileSpineAward>();
            int id = AllocateEffectId();
            effect.OnCreate(id, chairId, propId);
            MissileList[chairId].Add(id,effect);
            return effect;
        }

        public void DestroyMissile(int chairId, int id = -1)
        {
            if (id >= 0)
            {
                if (!MissileList.ContainsKey(chairId)) return;
                if (!MissileList[chairId].ContainsKey(id)) return;
                if (MissileList[chairId][id] != null)
                {
                    RemoveEffectToPool(MissileList[chairId][id]);
                }

                MissileList[chairId].Remove(id);
            }
            else
            {
                if (!MissileList.ContainsKey(chairId)) return;
                var MissileValues = MissileList[chairId].GetDictionaryValues();
                for (int i = 0; i < MissileValues.Length; i++)
                {
                    RemoveEffectToPool(MissileValues[i]);
                }

                MissileList.Remove(chairId);
            }
        }

        //----------------------Missile创建与销毁 end--------------------------------
        //----------------------免费子弹创建与销毁 start--------------------------------
        public SpecialBatterySpineAward CreateFreeBattery(int chairId)
        {
            SpecialBatterySpineAward effect = CreateEffect<SpecialBatterySpineAward>(chairId, "FreeBattery");
            FreeBatteryList.Add(chairId, effect);
            return effect;
        }

        public SpecialBatterySpineAward GetFreeBattery(int chairId)
        {
            return FreeBatteryList.ContainsKey(chairId) ? FreeBatteryList[chairId] : null;
        }

        public void DestroyFreeBattery(int chairId)
        {
            if (!FreeBatteryList.ContainsKey(chairId)) return;
            RemoveEffectToPool(FreeBatteryList[chairId]);
            FreeBatteryList.Remove(chairId);
        }
        //----------------------免费子弹创建与销毁 end-------------------------------- 

        //----------------------钻头炮创建与销毁 start--------------------------------
        public SpecialBatterySpineAward CreateDrill(int chairId)
        {
            SpecialBatterySpineAward effect = CreateEffect<SpecialBatterySpineAward>(chairId, "Drill");
            // effect.OnCreate(chairId, "Drill");
            DrillList.Add(chairId, effect);
            return effect;
        }

        public SpecialBatterySpineAward GetDrill(int chairId)
        {
            return DrillList.ContainsKey(chairId) ? DrillList[chairId] : null;
        }

        public void DestroyDrill(int chairId)
        {
            if (!DrillList.ContainsKey(chairId)) return;
            RemoveEffectToPool(DrillList[chairId]);
            DrillList.Remove(chairId);
        }
        //----------------------钻头炮创建与销毁 end--------------------------------

        //----------------------电磁炮创建与销毁 start--------------------------------
        public SpecialBatterySpineAward CreateElectric(int chairId)
        {
            SpecialBatterySpineAward effect = CreateEffect<SpecialBatterySpineAward>(chairId, "Electric");
            // effect.OnCreate(chairId, "Electric");
            ElectricList.Add(chairId, effect);
            return effect;
        }

        public SpecialBatterySpineAward GetElectric(int chairId)
        {
            return ElectricList.ContainsKey(chairId) ? ElectricList[chairId] : null;
        }

        public void DestroyElectric(int chairId)
        {
            if (!ElectricList.ContainsKey(chairId)) return;
            RemoveEffectToPool(ElectricList[chairId]);
            ElectricList.Remove(chairId);
        }
        //----------------------电磁炮创建与销毁 end--------------------------------

        //----------------------雷皇龙创建与销毁 start--------------------------------
        public ElectricDragonSpineAward CreateElectricDragonSpineAward(int chairId, params object[] args)
        {
            DebugHelper.LogError("创建ElectricDragonSpineAward  effectManager:308");
            ElectricDragonSpineAward effect = GetEffectFromPool<ElectricDragonSpineAward>();

            int id = AllocateEffectId();
            effect.OnCreate(id, chairId, args);
            ElectricDragonSpineList.Add(chairId, effect);
            return effect;
        }

        public ElectricDragonSpineAward GetElectricDragonSpineAward(int chairId)
        {
            return ElectricDragonSpineList.ContainsKey(chairId) ? ElectricDragonSpineList[chairId] : null;
        }


        public void DestroyElectricDragonSpineAward(int chairId)
        {
            if (!ElectricDragonSpineList.ContainsKey(chairId)) return;
            RemoveEffectToPool(ElectricDragonSpineList[chairId]);
            ElectricDragonSpineList.Remove(chairId);
        }
        //----------------------雷皇龙创建与销毁 end--------------------------------

        //----------------------龙珠创建与销毁 start--------------------------------
        public DragonBallEffect CreateDragonBallEffect(int chairId, params object[] args)
        {
            DragonBallEffect effect = GetEffectFromPool<DragonBallEffect>();
            int id = AllocateEffectId();
            effect.OnCreate(id, chairId, args);
            DragonBallList.Add(chairId, effect);
            return effect;
        }

        public void DestroyDragonBallEffect(int chairId)
        {
            if (DragonBallList == null) return;
            if (DragonBallList.TryGetValue(chairId, out var ball))
            {
                if (ball != null) RemoveEffectToPool(DragonBallList[chairId]);
            }

            DragonBallList.Remove(chairId);
        }

        public void DestroyAllDragonBallEffect()
        {
            var DragonBallKeys = DragonBallList.GetDictionaryKeys();
            for (int i = 0; i < DragonBallKeys.Length; i++)
            {
                DestroyDragonBallEffect(DragonBallKeys[i]);
            }
        }

        //----------------------龙珠创建与销毁 end--------------------------------
        //----------------------特殊鱼出场特效创建与销毁 start--------------------------------
        public FishAppear CreateFishAppear(FishDataConfig config)
        {
            if (FishAppear != null) return FishAppear;
            FishAppear = GetEffectFromPool<FishAppear>();
            FishAppear.OnCreate(config);
            return FishAppear;
        }

        public void DestroyFishAppear()
        {
            if (Instance.FishAppear == null) return;
            RemoveEffectToPool(Instance.FishAppear);
            Instance.FishAppear = null;
        }

        //----------------------特殊鱼出场特效创建与销毁 end--------------------------------
        private int AllocateEffectId()
        {
            EffectId++;
            if (EffectId < 1000000) return EffectId;
            EffectId = 0;
            return EffectId;
        }

        public void DestroyPlayerEffect(int chairId)
        {
            if (EffectList.ContainsKey(chairId))
            {
                var effectValues = EffectList[chairId].GetDictionaryValues();
                for (int i = 0; i < effectValues.Length; i++)
                {
                    effectValues[i].OnDestroy();
                }

                EffectList.Remove(chairId);
            }

            DestroyElectric(chairId);
            DestroyDrill(chairId);
            DestroyMissile(chairId);
            DestroyFreeBattery(chairId);
            DestroyElectricDragonSpineAward(chairId);
            DestroyDragonBallEffect(chairId);
        }

        private void DestroyAllEffect()
        {
            var effectKeys = EffectList.GetDictionaryKeys();
            for (int i = 0; i < effectKeys.Length; i++)
            {
                DestroyPlayerEffect(effectKeys[i]);
            }

            DestroyFishAppear();
            var MissileKeys = MissileList.GetDictionaryKeys();
            for (int i = 0; i < MissileKeys.Length; i++)
            {
                DestroyMissile(MissileKeys[i]);
            }

            var DrillKeys = DrillList.GetDictionaryKeys();
            for (int i = 0; i < DrillKeys.Length; i++)
            {
                DestroyDrill(DrillKeys[i]);
            }

            var ElectricListKeys = ElectricList.GetDictionaryKeys();
            for (int i = 0; i < ElectricListKeys.Length; i++)
            {
                DestroyElectric(ElectricListKeys[i]);
            }

            var FreeBatteryListKeys = FreeBatteryList.GetDictionaryKeys();
            for (int i = 0; i < FreeBatteryListKeys.Length; i++)
            {
                DestroyFreeBattery(FreeBatteryListKeys[i]);
            }

            var ElectricDragonSpineListKeys = ElectricDragonSpineList.GetDictionaryKeys();
            for (int i = 0; i < ElectricDragonSpineListKeys.Length; i++)
            {
                DestroyElectricDragonSpineAward(ElectricDragonSpineListKeys[i]);
            }


            //清除缓存池中的数据
            var EffectPoolItemsValues = EffectPoolItems.GetDictionaryValues();
            for (int i = 0; i < EffectPoolItemsValues.Length; i++)
            {
                if (EffectPoolItemsValues[i].Pool == null) continue;
                while (EffectPoolItemsValues[i].Pool.Count > 0)
                {
                    EffectPoolItemsValues[i].Pool.Pop().OnDestroy();
                }

                EffectPoolItemsValues[i].Pool.Clear();
            }

            GC.Collect();
        }

        /// <summary>
        /// 切换房间时,把所有特效全部放到对象池中
        /// </summary>
        public void StoreAllEffect()
        {
            var EffectListValues = EffectList.GetDictionaryValues();
            for (int i = 0; i < EffectListValues.Length; i++)
            {
                var itemValues = EffectListValues[i].GetDictionaryValues();
                for (int j = 0; j < itemValues.Length; j++)
                {
                    RemoveEffectToPool(itemValues[j]);
                }

                EffectListValues[i].Clear();
            }


            DestroyFishAppear();
            var MissileListKeys = MissileList.GetDictionaryKeys();
            for (int i = 0; i < MissileListKeys.Length; i++)
            {
                DestroyMissile(MissileListKeys[i]);
            }

            var DrillListKeys = DrillList.GetDictionaryKeys();
            for (int i = 0; i < DrillListKeys.Length; i++)
            {
                DestroyDrill(DrillListKeys[i]);
            }

            var ElectricListKeys = ElectricList.GetDictionaryKeys();
            for (int i = 0; i < ElectricListKeys.Length; i++)
            {
                DestroyElectric(ElectricListKeys[i]);
            }

            var FreeBatteryListKeys = FreeBatteryList.GetDictionaryKeys();
            for (int i = 0; i < FreeBatteryListKeys.Length; i++)
            {
                DestroyFreeBattery(FreeBatteryListKeys[i]);
            }

            var ElectricDragonSpineListKeys = ElectricDragonSpineList.GetDictionaryKeys();
            for (int i = 0; i < ElectricDragonSpineListKeys.Length; i++)
            {
                DestroyElectricDragonSpineAward(ElectricDragonSpineListKeys[i]);
            }
        }

        public void CreateBoostScoreBoardEffects(long score, params object[] args)
        {
            EffectParamData data = args.Length > 0 ? (EffectParamData)args[0] : new EffectParamData();
            int chairId = data.chairId;
            Vector3 pos = data.pos;
            float scale = data.scale == 0 ? 1 : data.scale;
            float delay = data.delay; //delay这里不用赋默认值，由各个特效自己负责自己的默认播放时间
            if (score >= EffectConfig.UseFireworkScore)
            {
                CreateEffect<Firework>(chairId, new EffectParamData()
                {
                    pos = pos,
                    scale = scale,
                    delay = (int) delay,
                });
            }

            if (!LTBY_GameView.GameInstance.IsSelf(chairId)) return;
            if (CheckCanUseHundredMillion(score))
            {
                CreateEffect<HundredMillionMoney>(chairId);
            }
        }

        public bool CheckCanUseHundredMillion(long score)
        {
            return score >= EffectConfig.UseHundredMillionScore;
        }
    }

    public class EffectClass
    {
        protected string name;
        protected int id;
        protected int chairId;
        protected Transform effect;
        protected Image imageBG;
        protected Transform fishImage;
        protected Transform text;
        protected string prefab;
        protected float scale;

        protected Transform item;
        protected Transform account;
        protected string prefabName;

        protected List<int> timerKey;
        protected List<int> actionKey;

        protected SkeletonGraphic skeleton;
        protected NumberRoller num;
        protected Vector3 numPosition;
        protected long score;
        protected ILBehaviour IlBehaviour;

        public virtual void OnCreate(int _id, int _chairId, params object[] args)
        {
        }

        public virtual void OnCreate(int _chairId, params object[] args)
        {
        }

        public virtual void OnCreate(params object[] args)
        {
        }

        public virtual void OnStored()
        {
            if (actionKey != null)
            {
                for (int i = 0; i < actionKey.Count; i++)
                {
                    LTBY_Extend.Instance.StopAction(actionKey[i]);
                }

                actionKey.Clear();
            }

            if (timerKey != null)
            {
                for (int i = 0; i < timerKey.Count; i++)
                {
                    LTBY_Extend.Instance.StopTimer(timerKey[i]);
                }

                timerKey.Clear();
            }

            num = null;
            skeleton = null;
        }

        public virtual void OnDestroy()
        {
            OnStored();
        }

        public virtual void SettleAccount()
        {
        }

        public virtual Vector3 GetNumWorldPos()
        {
            return numPosition;
        }

        public virtual void AddScore(long _score, float roll = 0)
        {
        }

        public virtual void OnSettle()
        {
        }
    }

    public class FishAppear : EffectClass
    {
        public override void OnCreate(params object[] args)
        {
            base.OnCreate(args);
            name = nameof(FishAppear);
            LTBY_Audio.Instance.Play(SoundConfig.FishAppear);
            if (effect == null)
            {
                effect =
                    LTBY_PoolManager.Instance.GetUiItem("LTBY_FishAppear", LTBY_EffectManager.Instance.UiLayer);
            }

            effect.gameObject.SetActive(true);
            effect.localPosition = new Vector3(0, 0, 0);
            FishDataConfig config = args.Length >= 1 ? args[0] as FishDataConfig : new FishDataConfig();
            if (config == null) config = new FishDataConfig();
            string BGBundle = string.IsNullOrEmpty(config.broadcastBgBundle) ? "res_effect" : config.broadcastBgBundle;
            string BGName = string.IsNullOrEmpty(config.broadcastBg) ? "ty_gc_di" : config.broadcastBg;
            Sprite appearBG = LTBY_Extend.Instance.LoadSprite(BGBundle, BGName);
            if (imageBG == null)
            {
                imageBG = effect.FindChildDepth<Image>("Node/yu");
            }

            imageBG.sprite = appearBG;
            imageBG.SetNativeSize();

            if (fishImage == null)
            {
                fishImage = effect.FindChildDepth("Node/yu/yu");
            }

            fishImage.gameObject.SetActive(false);
            string imageBundle = FishConfig.GetFishImageBundle(config.fishOrginType);
            fishImage.GetComponent<Image>().sprite =
                LTBY_Extend.Instance.LoadSprite(imageBundle, $"fish_{config.fishOrginType}");
            fishImage.GetComponent<RectTransform>().sizeDelta = Vector2.one * 120;
            fishImage.GetComponent<RectTransform>().anchorMax = Vector2.one * 0.5f;
            fishImage.GetComponent<RectTransform>().anchorMin = Vector2.one * 0.5f;
            fishImage.localPosition = new Vector3(-112, 10);
            fishImage.gameObject.SetActive(true);
            if (text == null)
            {
                text = effect.FindChildDepth("Node/yu/text");
            }

            text.GetComponent<Text>().text = config.broadcast;

            timerKey = new List<int>();
            int key = LTBY_Extend.Instance.DelayRun(4, () => LTBY_EffectManager.Instance.DestroyFishAppear());
            timerKey.Add(key);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (effect == null) return;
            effect.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (effect == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem("LTBY_FishAppear", effect);
            effect = null;
        }
    }

    public class EffectText : EffectClass
    {
        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(EffectText);
            id = _id;
            chairId = _chairId;
            score = args.Length >= 1 ? (long) args[0] : 0;
            Vector3 worldPos = args.Length >= 2 ? (Vector3) args[1] : Vector3.zero;
            int useMul = args.Length >= 3 ? (int) args[2] : 0;
            bool isElectric = args.Length >= 4 && (bool) args[3];
            int useMul2 = args.Length >= 5 ? (int) args[4] : 0;
            if (isElectric)
            {
                prefab = LTBY_GameView.GameInstance.IsSelf(_chairId)
                    ? "LTBY_TextElectricSelf"
                    : "LTBY_TextElectricOther";
            }
            else
            {
                prefab = LTBY_GameView.GameInstance.IsSelf(_chairId) ? "LTBY_TextSelf" : "LTBY_TextOther";
            }


            text = LTBY_PoolManager.Instance.GetUiItem(prefab, LTBY_EffectManager.Instance.UiLayer);
            text.position = worldPos;
            scale = 1;
            actionKey = new List<int>();

            int chair = chairId;
            int Id = id;
            if (useMul > 0)
            {
                text.GetComponent<TextMeshProUGUI>().text = $"+{Mathf.FloorToInt((float) score / useMul).ShortNumber()}";
                text.FindChildDepth("Mul").gameObject.SetActive(true);
                text.FindChildDepth<Text>("Mul").text = useMul2 > 0 ? $"x{useMul}x{useMul2}" : $"x{useMul}";

                text.localScale = new Vector3(0, 0, 0);
                Sequence tween = DOTween.Sequence();
                tween.SetLink(text.gameObject);
                tween.Append(text.DOScale(new Vector3(scale, scale, 1), 0.4f).SetEase(Ease.OutElastic).SetLink(text.gameObject));
                tween.Append(text.DOScale(new Vector3(0, 0, 1), 0.4f).SetEase(Ease.InBack).SetDelay(0.2f).SetLink(text.gameObject));
                tween.OnKill(() =>
                {
                    LTBY_EffectManager.Instance.DestroyEffect<EffectText>(chair, Id);
                });
                int key = LTBY_Extend.Instance.RunAction(tween);
                actionKey.Add(key);
            }
            else
            {
                text.GetComponent<TextMeshProUGUI>().text = $"+{score.ShortNumber()}";
                text.FindChildDepth("Mul").gameObject.SetActive(false);
                Sequence tween = DOTween.Sequence();
                tween.SetLink(text.gameObject);
                tween.Append(text.DOScale(new Vector3(scale * 1.2f, scale * 1.2f, 1), 0.2f)
                    .SetEase(Ease.Linear).SetLink(text.gameObject));
                tween.Append(text.DOScale(new Vector3(scale, scale, 1), 0.2f).SetEase(Ease.Linear).SetLink(text.gameObject));
                Sequence tween1 = DOTween.Sequence();
                tween.Append(tween1);
                tween1.Append(text.DOBlendableLocalMoveBy(new Vector3(0, 50, 1), 0.4f).SetEase(Ease.Linear).SetLink(text.gameObject));
                CanvasGroup group = text.GetComponent<CanvasGroup>();
                if (group == null) group = text.gameObject.AddComponent<CanvasGroup>();

                tween1.Insert(0, group.DOFade(0, 0.4f).SetLink(group.gameObject));
                tween1.SetDelay(0.2f);
                tween1.SetLink(text.gameObject);
                tween.OnKill(() =>
                {
                    group.alpha = 1;
                    LTBY_EffectManager.Instance.DestroyEffect<EffectText>(chair, Id);
                });
                int key = LTBY_Extend.Instance.RunAction(tween);
                actionKey.Add(key);
            }
        }

        public override void OnStored()
        {
            base.OnStored();
            if (string.IsNullOrEmpty(prefab)) return;
            LTBY_PoolManager.Instance.RemoveUiItem(prefab, text);
            prefab = null;
        }
    }

    public class EffectLight : EffectClass
    {
        private Transform light;
        private LineRenderer lineRenderer;
        private float detail;
        private int lightningWarp;
        private Vector3 startPos;

        private Vector3 endPos;
        private int hideFrame;
        private List<Vector3> rendererPosList;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(EffectLight);
            id = _id;
            chairId = _chairId;
            detail = 2;
            lightningWarp = 4;
            startPos = args.Length >= 1 ? (Vector3) args[0] : Vector3.zero;
            endPos = args.Length >= 2 ? (Vector3) args[1] : Vector3.zero;
            float existTime = args.Length >= 3 ? (float) args[2] : 0;

            hideFrame = 1;
            if (light == null)
            {
                light = LTBY_PoolManager.Instance.GetGameItem("LTBY_Light", LTBY_EffectManager.Instance.FishLayer);
            }

            light.gameObject.SetActive(false);

            if (lineRenderer == null)
            {
                lineRenderer = light.GetComponent<LineRenderer>();
            }

            lineRenderer.useWorldSpace = true;
            rendererPosList = new List<Vector3>();

            timerKey = new List<int>();
            if (IlBehaviour == null)
            {
                IlBehaviour = light.gameObject.AddComponent<ILBehaviour>();
            }

            IlBehaviour.UpdateEvent = Update;
            // int key = LTBY_Extend.Instance.StartTimer(delegate() { Update(); });
            // this.timerKey.Add(key);

            int chair = chairId;
            int Id = id;
            int _key = LTBY_Extend.Instance.DelayRun(existTime <= 0 ? 1.5f : existTime,
                ()=> { LTBY_EffectManager.Instance.DestroyEffect<EffectLight>(chair, Id); });
            timerKey.Add(_key);
        }

        private void CollectLinePos(Vector3 _startPos, Vector3 destPos, float displace)
        {
            if (displace < detail)
            {
                rendererPosList.Add(_startPos);
            }
            else
            {
                float midX = (_startPos.x + destPos.x) * 0.5f;
                float midY = (_startPos.y + destPos.y) * 0.5f;
                float midZ = (_startPos.z + destPos.z) * 0.5f;

                midX += (Random.Range(0f, 1f) - 0.5f) * displace;
                midY += (Random.Range(0f, 1f) - 0.5f) * displace;
                midZ += (Random.Range(0f, 1f) - 0.5f) * displace;

                Vector3 midPos = new Vector3(midX, midY, midZ);

                CollectLinePos(_startPos, midPos, displace * 0.5f);
                CollectLinePos(midPos, destPos, displace * 0.5f);
            }
        }

        private void Update()
        {
            if (hideFrame > 0)
            {
                hideFrame--;
                if (hideFrame == 0)
                {
                    light.gameObject.SetActive(true);
                }
            }

            rendererPosList.Clear();
            CollectLinePos(startPos, endPos, lightningWarp);

            rendererPosList.Add(endPos);

            lineRenderer.positionCount = rendererPosList.Count;
            for (int i = 0; i < rendererPosList.Count; i++)
            {
                lineRenderer.SetPosition(i, rendererPosList[i]);
            }
        }

        public override void OnStored()
        {
            base.OnStored();
            if (light == null) return;
            light.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (light == null) return;
            if (IlBehaviour != null)
            {
                LTBY_Extend.Destroy(IlBehaviour);
            }

            IlBehaviour = null;
            LTBY_PoolManager.Instance.RemoveGameItem("LTBY_Light", light);
            light = null;
        }
    }

    public class LightAccount : EffectClass
    {
        private string hadSpecialBattery;
        private Transform image;
        private List<long> scoreList;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(LightAccount);
            id = _id;
            chairId = _chairId;

            actionKey = new List<int>();
            timerKey = new List<int>();

            EffectParamData data = args.Length >= 1 ? (EffectParamData) args[0] : new EffectParamData();

            hadSpecialBattery = LTBY_BatteryManager.Instance.HadSpecialBattery(chairId);
            int bulletType = data.bulletType;
            if (PropConfig.CheckIsDragonBall(bulletType))
            {
                hadSpecialBattery = "DragonBall";
            }
            
            if (FishConfig.CheckIsElectricDragon(data.fishType))
            {
                hadSpecialBattery = "Electric";
            }

            if (!string.IsNullOrEmpty(hadSpecialBattery))
            {
                SpecialShow(data);
            }
            else
            {
                NormalShow(data);
            }
        }

        private void SpecialShow(EffectParamData data)
        {
            int multiple = data.multiple;
            EffectClass _effect = null;
            int useMul = 0;
            switch (hadSpecialBattery)
            {
                case "Drill":
                {
                    _effect = LTBY_EffectManager.Instance.GetDrill(chairId);
                    if (_effect == null)
                    {
                        _effect = LTBY_EffectManager.Instance.CreateDrill(chairId);
                    }

                    break;
                }
                case "Electric":
                {
                    _effect = LTBY_EffectManager.Instance.GetElectric(chairId);
                    if (_effect == null)
                    {
                        _effect = LTBY_EffectManager.Instance.CreateElectric(chairId);
                    }

                    break;
                }
                case "FreeBattery":
                {
                    _effect = LTBY_EffectManager.Instance.GetFreeBattery(chairId);
                    if (_effect == null)
                    {
                        _effect = LTBY_EffectManager.Instance.CreateFreeBattery(chairId);
                    }

                    useMul = multiple;
                    break;
                }
                case "DragonBall":
                {
                    _effect = LTBY_EffectManager.Instance.GetElectricDragonSpineAward(chairId);
                    if (_effect == null)
                    {
                        _effect = LTBY_EffectManager.Instance.CreateElectricDragonSpineAward(chairId, multiple);
                    }

                    break;
                }
            }

            if (_effect == null) return;
            Vector3 aimPos = _effect.GetNumWorldPos();

            float delay = 0;
            List<EffectParamData> fishList = data.fishList;
            for (int i = 0; i < fishList.Count; i++)
            {
                int index = i;
                delay += 0.05f;
                int key = LTBY_Extend.Instance.DelayRun(delay, ()=>
                {
                    if (fishList.Count <= index || fishList[index] == null) return;
                    EffectParamData _data = new EffectParamData()
                    {
                        score = fishList[index].score,
                        worldPos = fishList[index].pos,
                        aimPos = aimPos,
                        showText = true,
                        callBack = () => { _effect.AddScore(fishList[index].score); },
                        useMul = useMul,
                    };
                    LTBY_EffectManager.Instance.CreateEffect<FlyCoin>(chairId, _data);
                });
                timerKey.Add(key);
            }

            delay++;

            int chair = chairId;
            int Id = id;
            int _key = LTBY_Extend.Instance.DelayRun(delay,
                ()=> { LTBY_EffectManager.Instance.DestroyEffect<LightAccount>(chair, Id); });
            timerKey.Add(_key);
        }

        private void NormalShow(EffectParamData data)
        {
            int fishType = data.fishType;
            int chair = chairId;
            int Id = id;
            List<EffectParamData> fishList = data.fishList;
            if (account == null)
            {
                account =
                    LTBY_PoolManager.Instance.GetUiItem("LTBY_SpineLight", LTBY_EffectManager.Instance.UiLayer);
            }

            account.gameObject.SetActive(true);

            skeleton = account.FindChildDepth<SkeletonGraphic>("Skeleton");
            if (skeleton != null)
            {
                skeleton.AnimationState.SetAnimation(0, "stand01", false);
            }

            account.localScale = new Vector3(1, 1, 1);

            account.position = LTBY_GameView.GameInstance.GetEffectWorldPos(chair);
            if (num == null)
            {
                Transform numtrans = account.FindChildDepth("Num");
                num = numtrans.gameObject.GetILComponent<NumberRoller>();
                if (num == null)
                {
                    num = numtrans.gameObject.AddILComponent<NumberRoller>();
                }
            }

            num.Init();
            num.text = "0";
            numPosition = num.transform.position;

            if (image == null)
            {
                image = account.FindChildDepth("Image");
            }

            image.GetComponent<Image>().sprite =
                LTBY_Extend.Instance.LoadSprite("res_fishmodel", $"fish_{fishType}");

            account.gameObject.SetActive(false);

            float delay = 0.5f;

            int key = LTBY_Extend.Instance.DelayRun(delay + 0.5f, ()=>
            {
                account?.gameObject.SetActive(true);

                if (!LTBY_GameView.GameInstance.IsSelf(chair)) return;
                LTBY_Audio.Instance.Play(SoundConfig.SpineAward3);
                LTBY_Audio.Instance.Play(SoundConfig.SpineAwardLight);
            });
            timerKey.Add(key);

            scoreList = new List<long>();

            long scoreNum = 0;
            for (int i = 0; i < fishList.Count; i++)
            {
                delay += 0.05f;
                int index = i;
                int _key = LTBY_Extend.Instance.DelayRun(delay, ()=>
                {
                    if (fishList.Count <= index || fishList[index] == null) return;
                    EffectParamData flyCoinData = new EffectParamData()
                    {
                        score = fishList[index].score,
                        worldPos = fishList[index].pos,
                        aimPos = numPosition,
                        showText = true,
                        callBack = ()=>
                        {
                            num.RollBy(fishList[index].score, 0.5f);
                        }
                    };
                    LTBY_EffectManager.Instance.CreateEffect<FlyCoin>(chair, flyCoinData);
                    scoreList.Add(fishList[index].score);
                });
                timerKey.Add(_key);

                scoreNum += fishList[i].score;
            }

            delay += 2;

            if (scoreNum >= EffectConfig.UseFireworkScore)
            {
                int _key = LTBY_Extend.Instance.DelayRun(delay, () =>
                 {
                     EffectParamData _data = new EffectParamData()
                     {
                         chairId = chair,
                         pos = LTBY_GameView.GameInstance.GetEffectWorldPos(chair),
                         scale = 0.5f
                     };
                     LTBY_EffectManager.Instance.CreateBoostScoreBoardEffects(scoreNum, _data);
                 });
                timerKey.Add(_key);
                delay += 5;
            }
            else
            {
                delay++;
            }

            int kkey = LTBY_Extend.Instance.DelayRun(delay, ()=>
            {
                float baseX = account.position.x;
                float baseY = account.position.y;
                Vector3 aimPos = LTBY_GameView.GameInstance.GetCoinWorldPos(chair);
                float aimX = aimPos.x;
                float aimY = aimPos.y;

                Sequence sequence = DOTween.Sequence();
                sequence.Append(DOTween.To(value=>
                {
                    if (account == null) return;
                    float t = value * 0.01f;
                    account.position = new Vector3(baseX + (aimX - baseX) * t, baseY + (aimY - baseY) * t, 0);
                    float _scale = 1 - t;
                    account.localScale = new Vector3(_scale, _scale, _scale);
                }, 0, 100, 0.3f).SetEase(Ease.InBack));
                sequence.OnKill(()=>
                {
                    account.gameObject.SetActive(false);
                    for (int i = 0; i < scoreList.Count; i++)
                    {
                        int index = i;
                        Tween tween = LTBY_Extend.DelayRun(index * 0.15f).OnKill(()=>
                        {
                            if (scoreList.Count <= index) return;
                            LTBY_GameView.GameInstance.AddScore(chair, scoreList[index]);
                            LTBY_GameView.GameInstance.CreateAddUserScoreItem(chair, scoreList[index], true);
                            if (index == scoreList.Count - 1)
                            {
                                LTBY_EffectManager.Instance.DestroyEffect<LightAccount>(chair, Id);
                            }
                        }).SetLink(account.gameObject);
                        int _tkey = LTBY_Extend.Instance.RunAction(tween);
                        actionKey.Add(_tkey);
                    }
                });
                sequence.SetLink(account.gameObject);
                int _key = LTBY_Extend.Instance.RunAction(sequence);
                actionKey.Add(_key);
            });
            timerKey.Add(kkey);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (account == null) return;
            account.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (account == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem("LTBY_SpineLight", account);
            account = null;
        }
    }

    public class DragonDeadEffect : EffectClass
    {
        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(DragonDeadEffect);
            id = _id;
            chairId = _chairId;
            timerKey = new List<int>();
            float delay = 1;
            int chair = chairId;
            int Id = id;
            int key = LTBY_Extend.Instance.DelayRun(delay, ()=> { LTBYEntry.Instance.ShakeFishLayer(4); });
            timerKey.Add(key);
            List<Vector3> poslist = args.Length >= 1 ? (List<Vector3>) args[0] : new List<Vector3>();
            for (int i = 0; i < poslist.Count; i++)
            {
                int index = i;
                int kkey = LTBY_Extend.Instance.DelayRun(delay, ()=>
                {
                    if (poslist.Count <= index) return;
                    EffectParamData paramData = new EffectParamData()
                    {
                        level = 2,
                        pos = poslist[index],
                        playSound = true
                    };
                    LTBY_EffectManager.Instance.CreateEffect<ExplosionPoint>(chairId, paramData);
                });
                timerKey.Add(kkey);
                delay += 0.28f;
            }

            delay += 0.5f;

            if (LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                int kkey = LTBY_Extend.Instance.DelayRun(delay, ()=>
                {
                    effect = effect != null ? effect : LTBY_PoolManager.Instance.GetUiItem("LTBY_DragonDeadEffect",
                            LTBY_EffectManager.Instance.UiLayer);
                    effect?.gameObject.SetActive(true);
                    effect.localPosition = new Vector3(0, 0, 0);
                    LTBY_Audio.Instance.Play(SoundConfig.DragonEffect1);
                });
                timerKey.Add(kkey);
            }

            delay++;

            int _key = LTBY_Extend.Instance.DelayRun(delay, () =>
            {
                EffectParamData data = args[1] as EffectParamData;
                if (data == null) data = new EffectParamData();
                LTBY_EffectManager.Instance.CreateEffect<DragonSpineAward>(chair, data.score, data.baseScore);
                LTBY_EffectManager.Instance.DestroyEffect<DragonDeadEffect>(chair, Id);
            });
            timerKey.Add(_key);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (effect == null) return;
            effect.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (effect == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem("LTBY_DragonDeadEffect", effect);
            effect = null;
        }
    }

    public class ElectricDragonDeadEffect : EffectClass
    {
        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(ElectricDragonDeadEffect);
            id = _id;
            chairId = _chairId;
            timerKey = new List<int>();

            float delay = 1;
            int key = LTBY_Extend.Instance.DelayRun(delay, () =>{ LTBYEntry.Instance.ShakeFishLayer(4); });
            timerKey.Add(key);
            List<Vector3> poslist = args.Length >= 1 ? (List<Vector3>) args[0] : new List<Vector3>();
            EffectParamData data = args.Length >= 2 ? (EffectParamData) args[1] : new EffectParamData();
            for (int i = 0; i < poslist.Count; i++)
            {
                int index = i;
                int _key = LTBY_Extend.Instance.DelayRun(delay, ()=>
                {
                    if (poslist.Count <= index) return;
                    EffectParamData param = new EffectParamData()
                    {
                        level = 2,
                        pos = poslist[index],
                        playSound = true,
                    };
                    LTBY_EffectManager.Instance.CreateEffect<ExplosionPoint>(_chairId, param);
                });
                timerKey.Add(_key);
                delay += 0.28f;
            }

            delay += 0.5f;

            if (LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                int _key = LTBY_Extend.Instance.DelayRun(delay, ()=>
                {
                    effect = effect!= null ? effect : LTBY_PoolManager.Instance.GetUiItem("LTBY_ElectricDragonDeadEffect",
                            LTBY_EffectManager.Instance.UiLayer);
                    effect?.gameObject.SetActive(true);
                    effect.localPosition = new Vector3(0, 0, 0);
                    LTBY_Audio.Instance.Play(SoundConfig.DragonEffect1);
                });
                timerKey.Add(_key);
                delay++;
                DebugHelper.LogError($"_chairId:DoubleDragonEffect:{_chairId}");
                int _delayKey = LTBY_Extend.Instance.DelayRun(delay - 0.4f, ()=>
                {
                    LTBY_EffectManager.Instance.CreateEffect<DoubleDragonEffect>(_chairId);
                    if (LTBY_GameView.GameInstance.IsPlayerInRoom(_chairId))
                    {
                        if (data == null) return;
                        LTBY_EffectManager.Instance.CreateDragonBallEffect(_chairId, data.worldPos,
                            data.multiples[0], data.multiples[1], data);
                    }
                });
                timerKey.Add(_delayKey);
            }
            else
            {
                DebugHelper.LogError($"_chairId:DoubleDragonEffect1:{_chairId}");
                int _delayKey = LTBY_Extend.Instance.DelayRun(delay - 0.4f, ()=>
                {
                    if (LTBY_GameView.GameInstance.IsPlayerInRoom(_chairId))
                    {
                        DebugHelper.LogError($"data:{data==null}");
                        if (data == null) return;
                        LTBY_EffectManager.Instance.CreateDragonBallEffect(_chairId, data.worldPos,
                            data.multiples[0], data.multiples[1], data);
                    }
                });
                timerKey.Add(_delayKey);
            }

            int delayKey = LTBY_Extend.Instance.DelayRun(delay, () =>
            {
                LTBY_EffectManager.Instance.DestroyEffect<ElectricDragonDeadEffect>(_chairId, _id);
            });
            timerKey.Add(delayKey);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (effect == null) return;
            effect.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (effect == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem("LTBY_ElectricDragonDeadEffect", effect);
            effect = null;
        }
    }

    public class ExplosionPoint : EffectClass
    {
        int level;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(ExplosionPoint);
            id = _id;
            chairId = _chairId;
            int chair = chairId;
            int Id = id;
            EffectParamData data = args.Length >= 1 ? (EffectParamData) args[0] : new EffectParamData();
            level = data.level <= 0 ? 1 : data.level;
            Vector3 pos = data.pos;
            bool playSound = data.playSound;
            Vector3 angles = data.angles;

            if (LTBY_GameView.GameInstance.IsSelf(chairId) && playSound)
            {
                LTBY_Audio.Instance.Play(SoundConfig.AllAudio[$"ExplosionPoint{level}"]);
            }

            prefab = $"LTBY_ExplosionPoint{level}";
            effect = LTBY_PoolManager.Instance.GetUiItem(prefab, LTBY_EffectManager.Instance.UiLayer);
            effect.position = pos;

            float delay = 1;

            if (level > 1)
            {
                LTBYEntry.Instance.ShakeFishLayer(level - 1);
            }

            if (level == 3)
            {
                delay = 4;
            }

            if (args.Length >= 4)
            {
                effect.localEulerAngles = angles;
            }

            timerKey = new List<int>();
            int key = LTBY_Extend.Instance.DelayRun(delay,
                ()=> { LTBY_EffectManager.Instance.DestroyEffect<ExplosionPoint>(chair, Id); });
            timerKey.Add(key);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (effect == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem(prefab, effect);
            effect = null;
        }
    }

    /// <summary>
    /// 飞金币
    /// </summary>
    public class FlyCoin : EffectClass
    {
        private List<Transform> coinList;
        private Vector3 position;
        private Vector3 aimPos;
        private Action callBack;
        private bool showText;
        private int useMul;
        private int coinNum;
        private float deltaAngle;
        private float initAngle;
        private string coinPrefab;

        /// <summary>
        /// 创建飞行硬币
        /// </summary>
        /// <param name="_id">id</param>
        /// <param name="_chairId">椅子号</param>
        /// <param name="args">参数</param>
        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            EffectParamData data = args.Length >= 1 ? args[0] as EffectParamData : new EffectParamData();
            if (data == null) data = new EffectParamData();
            name = nameof(FlyCoin);
            id = _id;
            chairId = _chairId;
            coinList = new List<Transform>();
            position = data.worldPos;
            aimPos = data.aimPos;
            score = data.score;
            callBack = data.callBack;
            showText = data.showText;
            useMul = data.useMul;

            coinNum = 2;
            deltaAngle = 360f / coinNum;
            initAngle = Random.Range(0, 360);
            actionKey = new List<int>();
            timerKey = new List<int>();

            int chair = chairId;
            int Id = id;
            coinPrefab = LTBY_GameView.GameInstance.IsSelf(chairId) ? "LTBY_CoinSelf" : "LTBY_CoinOther";
            int _num = coinNum;

            while (_num > 0)
            {
                Transform coin =
                    LTBY_PoolManager.Instance.GetUiItem(coinPrefab, LTBY_EffectManager.Instance.UiLayer);
                var transform = coin.transform;
                transform.localScale = Vector3.one;
                transform.position = position;
                coinList.Add(coin);
                AppearAction(coin);
                _num--;
            }

            int key = LTBY_Extend.Instance.DelayRun(0.5f, ()=>
            {
                for (int i = 0; i < coinList.Count; i++)
                {
                    int index = i;
                    int _key = LTBY_Extend.Instance.DelayRun(0.1f * (index), () =>
                        {
                            if (coinList.Count <= index)
                            {
                                LTBY_EffectManager.Instance.DestroyEffect<FlyCoin>(chair, Id);
                                return;
                            }
                            MoveAction(index, coinList[index]);
                        });
                    timerKey.Add(_key);
                }
            });
            timerKey.Add(key);
        }

        /// <summary>
        /// 展示移动
        /// </summary>
        /// <param name="coin">移动的物体</param>
        private void AppearAction(Transform coin)
        {
            float rad = Mathf.Deg2Rad * 1 * (deltaAngle * (coinList.Count - 1) + initAngle);
            float radius = Random.Range(1f, 4f);
            float baseX = position.x;
            float baseY = position.y;
            float aimX = baseX + radius * Mathf.Cos(rad);
            float aimY = baseY + radius * Mathf.Sin(rad);
            Sequence sequence = DOTween.Sequence();
            sequence.Append(DOTween.To(value=>
            {
                if (coin == null) return;
                float t = value * 0.01f;
                coin.position = new Vector3(baseX + (aimX - baseX) * t, baseY + (aimY - baseY) * t, 0);
            }, 0, 100, 0.3f).SetEase(Ease.OutSine));
            sequence.SetLink(coin.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);
        }

        /// <summary>
        /// 移动金币
        /// </summary>
        /// <param name="index">索引</param>
        /// <param name="coin">金币</param>
        private void MoveAction(int index, Transform coin)
        {
            int chair = chairId;
            int Id = id;
            var position1 = coin.position;
            float baseX = position1.x;
            float baseY = position1.y;
            float aimX = aimPos.x;
            float aimY = aimPos.y;
            float offsetX = (aimX - baseX) * 0.5f;
            float offsetY = aimY > baseY ? -15f : 15f;

            Sequence sequence = DOTween.Sequence();
            sequence.Append(DOTween.To(value=>
            {
                if (coin == null) return;
                float t = value * 0.01f;
                float x = aimX + offsetX * (1 - t);
                float y = aimY + offsetY * (1 - t);
                coin.position = new Vector3(baseX + (x - baseX) * t, baseY + (y - baseY) * t, 0);
                float _scale = 1 - 0.4f * t;
                coin.localScale = new Vector3(_scale, _scale, _scale);
            }, 0, 100, 0.7f).SetEase(Ease.OutSine).OnKill(()=>
            {
                if (index == 0) callBack?.Invoke();
                if (index == coinNum - 1)
                {
                    LTBY_EffectManager.Instance.DestroyEffect<FlyCoin>(chair, Id);
                }

                coin?.gameObject.SetActive(false);
            }));
            sequence.SetLink(coin.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);
        }

        /// <summary>
        /// 回收
        /// </summary>
        public override void OnStored()
        {
            base.OnStored();
            if (coinList == null) return;
            for (int i = 0; i < coinList.Count; i++)
            {
                LTBY_PoolManager.Instance.RemoveUiItem(coinPrefab, coinList[i]);
            }

            coinList?.Clear();
        }
    }

    public class GetItem : EffectClass
    {
        public class GetItemData
        {
            public string name;
            public int num;
            public string imageBundleName;
            public string imageName;
        }

        private CAction callBack;
        private Transform itemName;
        private Transform itemNum;
        private Image itemImage;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(GetItem);
            id = _id;
            chairId = _chairId;
            int chair = chairId;
            int Id = id;
            Vector3 worldPos = args.Length >= 1 ? (Vector3) args[0] : Vector3.zero;
            GetItemData config = args.Length >= 2 ? (GetItemData) args[1] : new GetItemData();
            callBack = args.Length >= 3 ? (CAction) args[2] : null;

            actionKey = new List<int>();

            item = item
                ? item
                : LTBY_Extend.Instance.LoadPrefab("LTBY_GetItem", LTBY_EffectManager.Instance.UiLayer);
            item.gameObject.SetActive(true);
            if (string.IsNullOrEmpty(config.name))
            {
                itemName = itemName ? itemName : item.FindChildDepth("Name");
                itemName.gameObject.SetActive(true);
                itemName.GetComponent<Text>().text = config.name;
            }

            if (config.num > 0)
            {
                itemNum = itemNum ? itemNum : item.FindChildDepth("Num");
                itemNum.gameObject.SetActive(true);
                itemNum.GetComponent<NumberRoller>().text = config.num.ShortNumber().ToString();
            }

            itemImage = itemImage ? itemImage : item.GetComponent<Image>();
            itemImage.sprite = LTBY_Extend.Instance.LoadSprite(config.imageBundleName, config.imageName);
            itemImage.SetNativeSize();

            item.position = worldPos;

            Vector3 aimPos = LTBY_GameView.GameInstance.GetBatteryWorldPos(_chairId);

            Sequence sequence = DOTween.Sequence();
            sequence.Append(DOTween.To(value=>
            {
                if (item == null) return;
                float t = value * 0.01f;
                item.position = new Vector3(worldPos.x + (aimPos.x - worldPos.x) * t,
                    worldPos.y + (aimPos.y - worldPos.y) * t, 0);
                float _scale = 1 - t;
                item.localScale = new Vector3(_scale, _scale, _scale);
            }, 0, 100, 0.5f).SetDelay(0.5f).SetEase(Ease.Linear).OnKill(()=>
            {
                callBack?.Invoke();
                LTBY_EffectManager.Instance.DestroyEffect<GetItem>(chair, Id);
            }));
            sequence.SetLink(item.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (item == null) return;
            item.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (item == null) return;
            LTBY_Extend.Destroy(item.gameObject);
            item = null;
        }
    }

    public class FreeLotteryDropItem : EffectClass
    {
        Vector3 aimPos;
        Vector3 worldPos;
        Text FrameName;
        Image OpenImage;
        Transform Open;
        Transform Close;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(FreeLotteryDropItem);
            id = _id;
            chairId = _chairId;
            int chair = chairId;
            int Id = id;
            EffectParamData data = args.Length >= 1 ? (EffectParamData) args[0] : new EffectParamData();
            actionKey = new List<int>();

            aimPos = LTBY_GameView.GameInstance.GetBatteryWorldPos(chairId);

            if (LTBY_GameView.GameInstance.CheckIsOtherSide(chairId))
            {
                worldPos = new Vector3(aimPos.x, aimPos.y - 6, 0);
            }
            else
            {
                worldPos = new Vector3(aimPos.x, aimPos.y + 6, 0);
            }

            item = item
                ? item
                : LTBY_Extend.Instance.LoadPrefab("LTBY_FreeLotteryDropItem", LTBY_EffectManager.Instance.UiLayer);
            item.gameObject.SetActive(true);
            item.position = worldPos;

            FrameName = FrameName ? FrameName : item.FindChildDepth<Text>("Open/NameFrame/Name");
            FrameName.text = data.award.key;
            OpenImage = OpenImage ? OpenImage : item.FindChildDepth<Image>("Open/Image");
            OpenImage.sprite = LTBY_Extend.Instance.LoadSprite("res_view", data.award.value);
            OpenImage.SetNativeSize();
            Open = Open ? Open : item.FindChildDepth("Open");
            Close = Open ? Open : item.FindChildDepth("Close");

            float aimX = aimPos.x;
            float aimY = aimPos.y;
            float baseX = worldPos.x;
            float baseY = worldPos.y;


            Sequence tween = DOTween.Sequence();
            Sequence sequence1 = DOTween.Sequence();
            sequence1.Append(item.DOBlendableRotateBy(Vector3.one * 8, 0.04f).SetEase(Ease.Linear).SetLink(item.gameObject));
            sequence1.Append(item.DOBlendableRotateBy(Vector3.one * -16, 0.08f).SetEase(Ease.Linear).SetLink(item.gameObject));
            sequence1.Append(item.DOBlendableRotateBy(Vector3.one * 8, 0.04f).SetEase(Ease.Linear).SetLink(item.gameObject));
            sequence1.SetLoops(3);
            sequence1.OnKill(()=>
            {
                Open.gameObject.SetActive(true);
                Close.gameObject.SetActive(false);
            }).SetLink(item.gameObject);
            tween.Append(sequence1);
            Sequence sequence2 = DOTween.Sequence();
            sequence2.Append(DOTween.To(value =>
            {
                if (item == null) return;
                float t = value * 0.01f;
                item.position = new Vector3(baseX + (aimX - baseX) * t, baseY + (aimY - baseY) * t, 0);
                float _scale = 1 - t;
                item.localScale = new Vector3(_scale, _scale, _scale);
            }, 0, 100, 0.5f).SetEase(Ease.OutSine).OnKill(()=>
            {
                if (data == null) return;
                int propId = data.award_cnt.id;
                int count = data.award_cnt.count;
                if (PropConfig.CheckIsCoin(propId))
                {
                    //DebugHelper.LogError($"玩家抽中金币，数量:{data.count}");
                    LTBY_GameView.GameInstance.CreateAddUserScoreItem(_chairId, count);
                }

                LTBY_EffectManager.Instance.DestroyEffect<FreeLotteryDropItem>(chair, Id);
            }).SetDelay(2).SetLink(item.gameObject));
            sequence2.SetLoops(3);
            sequence2.OnKill(()=>
            {
                Open.gameObject.SetActive(true);
                Close.gameObject.SetActive(false);
            });
            tween.Insert(0, sequence2);
            tween.SetLink(item.gameObject);
            int key = LTBY_Extend.Instance.RunAction(tween);
            actionKey.Add(key);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (item == null) return;
            item.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (item == null) return;
            LTBY_Extend.Destroy(item.gameObject);
            item = null;
        }
    }

    public class FreeDropItem : EffectClass
    {
        Vector3 worldPos;
        string itemType;
        float time;
        int mul;
        Transform itemTime;
        Transform itemMul;
        Text itemTimeText;
        Text itemMulText;
        Vector3 aimPos;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(FreeDropItem);
            id = _id;
            chairId = _chairId;

            int chair = chairId;
            int Id = id;
            if (LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                LTBY_Audio.Instance.Play(SoundConfig.DropItem);
            }

            EffectParamData data = args.Length >= 1 ? (EffectParamData) args[0] : new EffectParamData();
            worldPos = data.worldPos;
            worldPos.z = 0;

            itemType = data.itemType;
            time = data.time;
            mul = data.mul;

            item = item
                ? item
                : LTBY_Extend.Instance.LoadPrefab("LTBY_FreeDropItem", LTBY_EffectManager.Instance.UiLayer);
            item.localScale = Vector3.one;
            item.gameObject.SetActive(true);
            item.position = worldPos;
            itemTime = item.FindChildDepth("Time");
            itemMul = item.FindChildDepth("Mul");
            itemTimeText = item.FindChildDepth<Text>("Time/Text");
            itemMulText = item.FindChildDepth<Text>("Mul/Text");

            switch (itemType)
            {
                case "FreeAddTime":
                    itemTime.gameObject.SetActive(true);
                    itemMul.gameObject.SetActive(false);
                    itemTimeText.text = $"+{time}{BatteryConfig.Second}";
                    aimPos = LTBY_BatteryManager.Instance.GetFreeBattery(chairId).GetTimeWorldPos();
                    break;
                case "FreeAddMul":
                    itemTime.gameObject.SetActive(false);
                    itemMul.gameObject.SetActive(true);
                    itemMulText.text = $"+{mul.ShortNumber()} ";
                    aimPos = LTBY_BatteryManager.Instance.GetFreeBattery(chairId).GetMulWorldPos();
                    break;
            }

            actionKey = new List<int>();
            timerKey = new List<int>();

            float aimX = aimPos.x;
            float aimY = aimPos.y;
            float baseX = worldPos.x;
            float baseY = worldPos.y;

            float offsetX = (aimX - baseX);
            float offsetY = aimY > baseY ? -15 : 15;

            Sequence sequence = DOTween.Sequence();

            sequence.Append(item.DOBlendableScaleBy(new Vector3(0.7f, 0.7f, 1), 0.2f).SetEase(Ease.Linear).SetLink(item.gameObject));
            sequence.Append(item.DOBlendableScaleBy(new Vector3(-0.5f, -0.5f, 1), 0.2f).SetEase(Ease.Linear).SetLink(item.gameObject));
            sequence.Append(DOTween.To(value=>
            {
                if (item == null) return;
                float t = value * 0.01f;
                float x = aimX + offsetX * (1 - t);
                float y = aimY + offsetY * (1 - t);
                item.position = new Vector3(baseX + (x - baseX) * t, baseY + (y - baseY) * t, 0);

                float _scale = 1 - 0.5f * t;
                item.localScale = new Vector3(_scale, _scale, _scale);
            }, 0, 100, 0.7f).SetDelay(0.6f).SetLink(item.gameObject));
            sequence.OnKill(()=>
            {
                FreeBatteryClass aimBattery = LTBY_BatteryManager.Instance.GetFreeBattery(chairId);
                if (aimBattery == null) return;
                if (itemType.Equals("FreeAddTime"))
                {
                    aimBattery.AddTime(time);
                }
                else if (itemType.Equals("FreeAddMul"))
                {
                    aimBattery.AddMul(mul);
                }

                LTBY_EffectManager.Instance.DestroyEffect<FreeDropItem>(chairId, Id);
            });
            sequence.SetLink(item.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (item == null) return;
            item.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (item == null) return;
            LTBY_Extend.Destroy(item.gameObject);
            item = null;
        }
    }

    public class DropItem : EffectClass
    {
        Vector3 worldPos;
        Vector3 angles;
        string itemType;
        int ratio;
        Vector3 aimPos;
        int propId;
        float time;
        int mul;
        float aimAngles;

        Image itemImage;
        Transform itemEffect;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(DropItem);
            id = _id;
            chairId = _chairId;
            EffectParamData config = args.Length >= 1 ? (EffectParamData) args[0] : new EffectParamData();
            worldPos = config.worldPos;
            worldPos.z = 0;
            angles = config.angles;
            itemType = config.itemType;
            ratio = config.ratio;
            aimPos = LTBY_GameView.GameInstance.GetBatteryWorldPos(chairId);
            propId = config.id;
            time = config.time;
            mul = config.mul;

            if (LTBY_GameView.GameInstance.CheckIsOtherSide(chairId))
            {
                aimPos.y -= 1.35f;
                aimAngles = 1080 + 180;
            }
            else
            {
                aimPos.y += 1.35f;
                aimAngles = 1080;
            }

            float delayCreate = 0.5f;
            if (itemType.Equals("ScratchCard") || itemType.Equals("Summon"))
            {
                aimAngles = 720;
            }
            else if (itemType.Equals("Missile"))
            {
                delayCreate = 0;
            }

            actionKey = new List<int>();
            timerKey = new List<int>();

            if (delayCreate > 0)
            {
                int key = LTBY_Extend.Instance.DelayRun(delayCreate, CreateItem);
                timerKey.Add(key);
            }
            else
            {
                CreateItem();
            }
        }

        private void CreateItem()
        {
            if (LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                LTBY_Audio.Instance.Play(SoundConfig.DropItem);
            }

            EffectConfig.DropItem.TryGetValue(itemType, out DropItemData config);
            if (config == null)
            {
                DebugHelper.LogError($"GC.EffectConfig.DropItem {itemType} 没有配置");
            }

            item = item != null ? item : LTBY_Extend.Instance.LoadPrefab("LTBY_DropItem", LTBY_EffectManager.Instance.UiLayer);
            item.localScale = Vector3.one;
            item.gameObject.SetActive(true);
            item.position = worldPos;
            item.localEulerAngles = angles;

            itemImage = item.FindChildDepth<Image>("Image");
            itemEffect = item.FindChildDepth("Effect");
            if (config != null)
            {
                itemImage.sprite =
                    LTBY_Extend.Instance.LoadSprite(config.imageBundleName, config.imageName[propId]);
                itemImage.SetNativeSize();
                float _scale = config.scale;
                itemImage.transform.localScale = new Vector3(_scale, _scale, _scale);
            }

            itemImage.gameObject.SetActive(true);

            float aimX = aimPos.x;
            float aimY = aimPos.y;
            float baseX = worldPos.x;
            float baseY = worldPos.y;

            float baseAngles = angles.z;
            float _aimAngles = aimAngles;

            Sequence sequence = DOTween.Sequence();
            sequence.Append(item.DOBlendableScaleBy(new Vector3(0.5f, 0.5f, 1), 0.2f).SetEase(Ease.Linear));
            sequence.Append(item.DOBlendableScaleBy(new Vector3(-0.5f, -0.5f, 1), 0.2f).SetEase(Ease.Linear));
            sequence.Append(DOTween.To(value=>
            {
                if (item == null) return;
                float t = value * 0.01f;
                item.position = new Vector3(baseX + (aimX - baseX) * t, baseY + (aimY - baseY) * t, 0);
                item.localEulerAngles = new Vector3(0, 0, baseAngles + (_aimAngles - baseAngles) * t);
            }, 0, 100, 0.8f).SetEase(Ease.OutSine).SetDelay(1).OnKill(OnFinish));
            sequence.SetLink(item.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);
        }

        private void OnFinish()
        {
            int chair = chairId;
            int Id = id;
            itemImage.gameObject.SetActive(false);
            itemEffect.gameObject.SetActive(false);
            itemEffect.gameObject.SetActive(true);
            int key = LTBY_Extend.Instance.DelayRun(0.5f,
                ()=> { LTBY_EffectManager.Instance.DestroyEffect<DropItem>(chair, Id); });
            timerKey.Add(key);

            switch (itemType)
            {
                case "Drill":
                    LTBY_BatteryManager.Instance.CreateDrill(chairId, ratio);
                    break;
                case "Electric":
                    LTBY_BatteryManager.Instance.CreateElectric(chairId, ratio);
                    break;
                case "FreeBattery":
                    LTBY_BatteryManager.Instance.CreateFreeBattery(chairId, ratio, mul, time);
                    break;
            }
        }

        public override void OnStored()
        {
            base.OnStored();
            if (item == null) return;
            item.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (item == null) return;
            LTBY_Extend.Destroy(item.gameObject);
            item = null;
        }
    }

    public class CoinOutburst : EffectClass
    {
        Transform outburst1;
        Transform outburst2;
        int devide;
        int halfDevide;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(CoinOutburst);
            id = _id;
            chairId = _chairId;

            score = args.Length >= 1 ? (long) args[0] : 0;

            actionKey = new List<int>();
            timerKey = new List<int>();

            if (LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                SelfEffect();
            }
            else
            {
                OtherEffect();
            }
        }

        private void SelfEffect()
        {
            int chair = chairId;
            int Id = id;
            LTBY_Audio.Instance.Play(SoundConfig.CoinOutburst);

            Vector3 pos = LTBY_GameView.GameInstance.GetEffectWorldPos(chairId);

            effect = effect != null ? effect : LTBY_PoolManager.Instance.GetUiItem("LTBY_CoinOutburst", LTBY_EffectManager.Instance.UiLayer);
            effect.gameObject.SetActive(true);
            effect.position = pos;

            outburst1 = outburst1 != null ? outburst1 : effect.FindChildDepth("Effect1");
            outburst1.gameObject.SetActive(false);
            outburst2 = outburst2 != null ? outburst2 : effect.FindChildDepth("Effect2");
            outburst2.gameObject.SetActive(false);

            devide = 10;
            halfDevide = 5;

            CalcShowScore();

            Vector3 worldPos = new Vector3(pos.x, pos.y, 0);
            Sequence sequence = DOTween.Sequence();
            sequence.Append(LTBY_Extend.DelayRun(0).OnComplete(() =>
            {
                outburst1.gameObject.SetActive(true);
                LTBY_EffectManager.Instance.CreateEffect<FlyText>(chairId, "Outburst", 1f, worldPos, GetCurShowScore());
            }));
            sequence.Append(LTBY_Extend.DelayRun(2).OnComplete(() => outburst2.gameObject.SetActive(false)));
            sequence.SetLoops(halfDevide);
            sequence.SetLink(outburst1.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);

            int _key = LTBY_Extend.Instance.DelayRun(1, () =>
            {
                Sequence sq = DOTween.Sequence();
                Tween sequence1 = LTBY_Extend.DelayRun(0).OnComplete(() =>
                {
                    outburst2?.gameObject.SetActive(true);
                    LTBY_EffectManager.Instance.CreateEffect<FlyText>(chairId, "Outburst", 1f, worldPos, GetCurShowScore());
                });
                sq.Append(sequence1);
                Tween sequence2 = LTBY_Extend.DelayRun(2).OnComplete(() => outburst2?.gameObject.SetActive(false));
                sq.Append(sequence2);
                sq.SetLoops(halfDevide).OnKill(() =>
                    LTBY_EffectManager.Instance.DestroyEffect<CoinOutburst>(chair, Id));
                sq.SetLink(outburst2.gameObject);
                int tween = LTBY_Extend.Instance.RunAction(sq);
                actionKey.Add(tween);
            });
            timerKey.Add(_key);
        }

        int count;
        List<long> scoreList;

        private void CalcShowScore()
        {
            count = 0;
            scoreList = new List<long>();

            long lastScore = score;
            for (int i = 0; i < devide - 1; i++)
            {
                long _score = (long) Mathf.Floor(score * Random.Range(3, 11f) / 100);

                scoreList.Add(_score);
                lastScore -= _score;
            }

            scoreList.Insert(Random.Range(1, scoreList.Count-1), lastScore);
        }

        private long GetCurShowScore()
        {
            if (count >= devide) return 0;
            long _score = scoreList[count];
            count++;
            return _score;
        }

        private void OtherEffect()
        {
            Vector3 worldPos = LTBY_GameView.GameInstance.GetEffectWorldPos(chairId);
            LTBY_EffectManager.Instance.CreateEffect<FlyText>(chairId, "Outburst", 2.5f, worldPos, score);
            LTBY_EffectManager.Instance.DestroyEffect<CoinOutburst>(chairId, id);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (effect == null) return;
            effect.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (effect == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem("LTBY_CoinOutburst", effect);
            effect = null;
        }
    }

    public class PoolTreasure : EffectClass
    {
        Transform EffectPart;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(PoolTreasure);
            id = _id;
            chairId = _chairId;
            int level = args.Length >= 1 ? (int) args[0] : 0;

            score = args.Length >= 2 ? (long) args[1] : 0;

            actionKey = new List<int>();
            timerKey = new List<int>();

            LTBY_Audio.Instance.Play(SoundConfig.AllAudio[$"Treasure{level}"]);

            LTBY_Audio.Instance.Play(SoundConfig.TreasureText);

            effect =
                LTBY_Extend.Instance.LoadPrefab($"LTBY_PoolTreasure{level}", LTBY_EffectManager.Instance.UiLayer);
            effect.position = new Vector3(0, 0, 0);

            Transform numtxt = effect.FindChildDepth("CaiDai/Text");
            num = numtxt.gameObject.GetILComponent<NumberRoller>();
            if (num == null)
            {
                num = numtxt.gameObject.AddILComponent<NumberRoller>();
            }

            num.Init();
            num.text = "0";
            EffectPart = effect.FindChildDepth("Effect");
            EffectPart.gameObject.SetActive(!LTBY_EffectManager.Instance.CheckCanUseHundredMillion(score));

            int key = LTBY_Extend.Instance.DelayRun(1, ()=>
            {
                EffectParamData _data = new EffectParamData()
                {
                    chairId = _chairId,
                    pos = Vector3.zero,
                    scale = 1
                };
                LTBY_EffectManager.Instance.CreateBoostScoreBoardEffects(score, _data);
            });

            num.transform.localScale = Vector3.one;
            num.transform.gameObject.SetActive(false);

            float delay = 0.5f;

            int _key = LTBY_Extend.Instance.DelayRun(delay, ()=>
            {
                num?.transform.gameObject.SetActive(true);
                num?.RollTo(score, 4);
            });
            timerKey.Add(_key);

            delay += 4;

            int _key1 = LTBY_Extend.Instance.DelayRun(delay, ()=>
            {
                Sequence sequence = DOTween.Sequence();
                sequence.Append(num.transform.DOBlendableScaleBy(new Vector3(1, 1, 1), 0.1f).SetEase(Ease.Linear));
                sequence.Append(num.transform.DOBlendableScaleBy(new Vector3(-1, -1, 1), 0.2f).SetEase(Ease.Linear));
                sequence.SetLink(item.gameObject);
                int kkey = LTBY_Extend.Instance.RunAction(sequence);
                actionKey.Add(kkey);
            });
            timerKey.Add(_key1);

            delay++;

            int _key2 = LTBY_Extend.Instance.DelayRun(delay, ()=>
            {
                Sequence sequence = DOTween.Sequence();
                sequence.Append(effect.DOScale(new Vector3(0, 0, 1), 0.5f).SetLink(effect.gameObject).SetEase(Ease.InBack).OnKill(()=>
                {
                    LTBY_GameView.GameInstance.CreateAddUserScoreItem(chairId, score);
                    LTBY_GameView.GameInstance.AddScore(chairId, score);
                    LTBY_EffectManager.Instance.DestroyEffect<PoolTreasure>(chairId, id);
                }));
                sequence.SetLink(effect.gameObject);
                int kkey = LTBY_Extend.Instance.RunAction(sequence);
                actionKey.Add(kkey);
            });
            timerKey.Add(_key2);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (effect == null) return;
            LTBY_Extend.Destroy(effect.gameObject);
            effect = null;
        }
    }

    public class MissileSpineAward : EffectClass
    {
        int settleAccountActionKey = -1;
        float numScale;
        Transform image;
        Image image2;
        bool isSettleAccount;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(MissileSpineAward);
            id = _id;
            chairId = _chairId;
            score = 0;
            int propId = args.Length >= 1 ? (int) args[0] : 0;

            if (LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                LTBY_Audio.Instance.Play(SoundConfig.SpineAward3);
            }

            actionKey = new List<int>();
            timerKey = new List<int>();
            settleAccountActionKey = -1;

            account = account
                ? account
                : LTBY_PoolManager.Instance.GetUiItem("LTBY_MissileSpineAward", LTBY_EffectManager.Instance.UiLayer);
            account.gameObject.SetActive(true);
            skeleton = skeleton!=null ? skeleton : account.FindChildDepth<SkeletonGraphic>("Skeleton");
            if (skeleton != null)
            {
                skeleton.AnimationState.SetAnimation(0, "stand01", false);
            }

            account.localScale = new Vector3(1, 1, 1);

            account.position = LTBY_GameView.GameInstance.GetEffectWorldPos(chairId);
            Transform numtxt = account.FindChildDepth("Num");
            num = numtxt.gameObject.GetILComponent<NumberRoller>() != null
                ? numtxt.gameObject.GetILComponent<NumberRoller>()
                : numtxt.gameObject.AddILComponent<NumberRoller>();
            num.Init();
            num.text = "0";
            numPosition = num.transform.position;
            numScale = 0.45f;

            num.transform.gameObject.SetActive(false);

            image = image ? image : account.FindChildDepth("Image");
            image.localEulerAngles = new Vector3(0, 0, 0);
            image.localScale = new Vector3(1, 1, 1);
            DropItemData config = EffectConfig.DropItem["Missile"];
            image2 = image2 ? image2 : image.FindChildDepth<Image>("Image");
            if (!string.IsNullOrEmpty(config.imageName[propId]))
            {
                image2.sprite = LTBY_Extend.Instance.LoadSprite(config.imageBundleName, config.imageName[propId]);
            }

            Sequence sequence = DOTween.Sequence();
            sequence.Append(image.DOBlendableScaleBy(new Vector3(3, 3, 1), 0.01f).SetEase(Ease.Linear).SetLink(image.gameObject));
            sequence.Append(image.DOBlendableScaleBy(new Vector3(-3, -3, 1), 0.2f).SetEase(Ease.Linear).SetLink(image.gameObject));
            Sequence sequence1 = DOTween.Sequence();
            sequence.Append(sequence);
            sequence1.Append(image.DOBlendableRotateBy(new Vector3(0, 0, 10), 0.2f).SetEase(Ease.Linear).SetLink(image.gameObject));
            sequence1.Append(image.DOBlendableRotateBy(new Vector3(0, 0, -20), 0.4f).SetEase(Ease.Linear).SetLink(image.gameObject));
            sequence1.Append(image.DOBlendableRotateBy(new Vector3(0, 0, 10), 0.2f).SetEase(Ease.Linear).SetLink(image.gameObject));
            sequence1.SetLoops(20);
            sequence1.SetLink(image.gameObject);
            sequence.SetLink(image.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);

            isSettleAccount = false;
        }

        public override void AddScore(long _score, float roll = 0)
        {
            base.AddScore(_score, roll);
            if (isSettleAccount)
            {
                LTBY_GameView.GameInstance.CreateAddUserScoreItem(chairId, _score);
                LTBY_GameView.GameInstance.AddScore(chairId, _score);
            }
            else
            {
                num.transform.gameObject.SetActive(true);
                score += (long) _score;
                if (roll > 0)
                {
                    num.RollTo(score, roll);
                }
                else
                {
                    num.text = score.ShortNumber();
                }

                Sequence sequence = DOTween.Sequence();
                sequence.Append(num.transform.DOScale(new Vector3(numScale + 0.3f, numScale + 0.3f, 1), 0.1f)
                    .SetEase(Ease.Linear).SetLink(num.gameObject));
                sequence.Append(num.transform.DOScale(new Vector3(numScale, numScale, 1), 0.1f)
                    .SetEase(Ease.Linear).SetLink(num.gameObject));
                sequence.SetLink(num.gameObject);
                int key = LTBY_Extend.Instance.RunAction(sequence);
                actionKey.Add(key);
            }
        }

        public void SettleAccount(float delay = 0)
        {
            if (isSettleAccount) return;

            Vector3 basePos = LTBY_GameView.GameInstance.GetEffectWorldPos(chairId);

            account.position = basePos;
            account.localScale = new Vector3(1, 1, 1);

            float baseX = basePos.x;
            float baseY = basePos.y;

            Vector3 aimPos = LTBY_GameView.GameInstance.GetCoinWorldPos(chairId);
            float aimX = aimPos.x;
            float aimY = aimPos.y;

            LTBY_Extend.Instance.StopAction(settleAccountActionKey);
            Sequence sequence = DOTween.Sequence();
            sequence.Append(DOTween.To(value=>
            {
                if (account == null) return;
                float t = value * 0.01f;
                account.position = new Vector3(baseX + (aimX - baseX) * t, baseY + (aimY - baseY) * t, 0);
                float _scale = 1 - t;
                account.localScale = new Vector3(_scale, _scale, _scale);
            }, 0, 100, 0.3f).SetEase(Ease.InBack).OnKill(()=>
            {
                LTBY_GameView.GameInstance.CreateAddUserScoreItem(chairId, score);
                LTBY_GameView.GameInstance.AddScore(chairId, score);
                LTBY_EffectManager.Instance.DestroyMissile(chairId, id);
            }).SetDelay(delay));
            sequence.SetLink(account.gameObject);
            settleAccountActionKey = LTBY_Extend.Instance.RunAction(sequence);
        }

        public override void OnStored()
        {
            base.OnStored();
            isSettleAccount = true;

            if (settleAccountActionKey > 0)
            {
                LTBY_Extend.Instance.StopAction(settleAccountActionKey);
                settleAccountActionKey = -1;
            }

            if (account != null)
            {
                account.gameObject.SetActive(false);
            }
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (!account) return;
            LTBY_PoolManager.Instance.RemoveUiItem("LTBY_MissileSpineAward", account);
            account = null;
        }
    }

    public class SpecialBatterySpineAward : EffectClass
    {
        List<long> scoreList;
        int settleAccountActionKey = -1;
        string batteryType;
        float numScale;
        Transform image;
        bool isSettleAccount;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(SpecialBatterySpineAward);
            chairId = _chairId;
            score = 0;
            scoreList = new List<long>();

            if (LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                LTBY_Audio.Instance.Play(SoundConfig.SpineAward3);
            }

            actionKey = new List<int>();
            timerKey = new List<int>();
            settleAccountActionKey = -1;

            batteryType = args.Length >= 1 ? args[0].ToString() : "";

            prefabName = $"LTBY_{batteryType}SpineAward";

            account = LTBY_PoolManager.Instance.GetUiItem(prefabName, LTBY_EffectManager.Instance.UiLayer);

            skeleton = account.FindChildDepth<SkeletonGraphic>("Skeleton");
            if (skeleton != null)
            {
                skeleton.AnimationState.SetAnimation(0, "stand01", false);
            }

            account.localScale = new Vector3(1, 1, 1);

            account.position = LTBY_GameView.GameInstance.GetEffectWorldPos(chairId);
            Transform numTxt = account.FindChildDepth("Num");
            num = numTxt.gameObject.GetILComponent<NumberRoller>();
            num = num == null ? numTxt.gameObject.AddILComponent<NumberRoller>() : num;
            num.Init();
            num.text = "0";
            numPosition = num.transform.position;
            numScale = 0.45f;

            num.transform.gameObject.SetActive(false);

            image = account.FindChildDepth("Image");
            image.localEulerAngles = new Vector3(0, 0, 0);
            image.localScale = new Vector3(1, 1, 1);
            Sequence sequence = DOTween.Sequence();
            sequence.Append(image.DOBlendableScaleBy(new Vector3(3, 3, 1), 0.01f).SetEase(Ease.Linear).SetLink(image.gameObject));
            sequence.Append(image.DOBlendableScaleBy(new Vector3(-3, -3, 1), 0.2f).SetEase(Ease.Linear).SetLink(image.gameObject));
            Sequence sequence1 = DOTween.Sequence();
            sequence.Append(sequence1);
            sequence1.Append(image.DOBlendableRotateBy(new Vector3(0, 0, 10), 0.2f).SetEase(Ease.Linear).SetLink(image.gameObject));
            sequence1.Append(image.DOBlendableRotateBy(new Vector3(0, 0, -20), 0.4f).SetEase(Ease.Linear).SetLink(image.gameObject));
            sequence1.Append(image.DOBlendableRotateBy(new Vector3(0, 0, 10), 0.2f).SetEase(Ease.Linear).SetLink(image.gameObject));
            sequence1.SetLoops(100);
            sequence1.SetLink(image.gameObject);
            sequence.SetLink(image.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);

            isSettleAccount = false;
        }

        public override void AddScore(long _score, float roll = 0)
        {
            base.AddScore(_score, roll);
            if (isSettleAccount)
            {
                LTBY_GameView.GameInstance.CreateAddUserScoreItem(chairId, _score);
                LTBY_GameView.GameInstance.AddScore(chairId, _score);
            }
            else
            {
                num.transform.gameObject.SetActive(true);
                score += (long) _score;
                scoreList.Add((long) _score);
                if (roll > 0)
                {
                    num.RollTo(score, roll);
                }
                else
                {
                    num.text = score.ShortNumber().ToString();
                }

                Sequence sequence = DOTween.Sequence();
                sequence.Append(num.transform.DOScale(new Vector3(numScale + 0.3f, numScale + 0.3f, 1), 0.1f)
                    .SetEase(Ease.Linear).SetLink(num.gameObject));
                sequence.Append(num.transform.DOScale(new Vector3(numScale, numScale, 1), 0.1f)
                    .SetEase(Ease.Linear).SetLink(num.gameObject));
                sequence.SetLink(num.gameObject);
                int key = LTBY_Extend.Instance.RunAction(sequence);
                actionKey.Add(key);
            }
        }

        public override void SettleAccount()
        {
            base.SettleAccount();
            Vector3 basePos = LTBY_GameView.GameInstance.GetEffectWorldPos(chairId);

            account.position = basePos;
            account.localScale = new Vector3(1, 1, 1);

            float baseX = basePos.x;
            float baseY = basePos.y;

            Vector3 aimPos = LTBY_GameView.GameInstance.GetCoinWorldPos(chairId);
            float aimX = aimPos.x;
            float aimY = aimPos.y;

            LTBY_Extend.Instance.StopAction(settleAccountActionKey);

            float delay = 0;

            if (score >= EffectConfig.UseFireworkScore)
            {
                EffectParamData _data = new EffectParamData()
                {
                    chairId = chairId,
                    pos = basePos,
                    scale = 0.5f
                };
                LTBY_EffectManager.Instance.CreateBoostScoreBoardEffects(score, _data);
                delay += 5;
            }

            Sequence sequence = DOTween.Sequence();
            sequence.SetLink(account.gameObject);
            sequence.Append(DOTween.To(value=>
            {
                if (account == null) return;
                float t = value * 0.01f;
                account.position = new Vector3(baseX + (aimX - baseX) * t, baseY + (aimY - baseY) * t, 0);
                float _scale = 1 - t;
                account.localScale = new Vector3(_scale, _scale, _scale);
            }, 0, 100, 0.5f).SetEase(Ease.InBack).SetDelay(delay).OnKill(()=>
            {
                isSettleAccount = true;
                account?.gameObject.SetActive(false);
                for (int i = 0; i < scoreList.Count; i++)
                {
                    int index = i;
                    Tween sequence1= LTBY_Extend.DelayRun(index * 0.15f).OnComplete(()=>
                    {
                        LTBY_GameView.GameInstance.AddScore(chairId, scoreList[index]);
                        LTBY_GameView.GameInstance.CreateAddUserScoreItem(chairId, scoreList[index], true);
                        if (index != scoreList.Count - 1) return;
                        switch (batteryType)
                        {
                            case "Drill":
                                LTBY_EffectManager.Instance.DestroyDrill(chairId);
                                break;
                            case "Electric":
                                LTBY_EffectManager.Instance.DestroyElectric(chairId);
                                break;
                            case "FreeBattery":
                                LTBY_EffectManager.Instance.DestroyFreeBattery(chairId);
                                break;
                        }
                    });
                    int key = LTBY_Extend.Instance.RunAction(sequence1);
                    actionKey.Add(key);
                }
            }));
            settleAccountActionKey = LTBY_Extend.Instance.RunAction(sequence);
        }

        public override void OnStored()
        {
            base.OnStored();
            isSettleAccount = true;

            if (settleAccountActionKey > 0)
            {
                LTBY_Extend.Instance.StopAction(settleAccountActionKey);
                settleAccountActionKey = -1;
            }

            if (account == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem(prefabName, account);
            account = null;
        }
    }

    public class SpineAwardLevel : EffectClass
    {
        Transform image;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(SpineAwardLevel);
            id = _id;
            chairId = _chairId;

            actionKey = new List<int>();
            timerKey = new List<int>();
            int level = args.Length >= 1 ? (int) args[0] : 0;
            int fishType = args.Length >= 1 ? (int) args[1] : 0;
            if (LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                LTBY_Audio.Instance.Play(SoundConfig.SpineAward2);
                if (SoundConfig.AllAudio.ContainsKey($"SpineAwardText{level}"))
                {
                    LTBY_Audio.Instance.Play(SoundConfig.AllAudio[$"SpineAwardText{level}"]);
                }
            }

            prefabName = $"LTBY_SpineAwardLevel{level}";
            account = LTBY_PoolManager.Instance.GetUiItem(prefabName, LTBY_EffectManager.Instance.UiLayer);

            skeleton = account.FindChildDepth<SkeletonGraphic>("Skeleton");
            if (skeleton != null)
            {
                skeleton.AnimationState.SetAnimation(0, "stand01", false);
            }

            account.localScale = new Vector3(1, 1, 1);

            account.position = LTBY_GameView.GameInstance.GetEffectWorldPos(chairId);
            num = account.FindChildDepth("Num").gameObject.GetILComponent<NumberRoller>() ??
                       account.FindChildDepth("Num").gameObject.AddILComponent<NumberRoller>();
            num.Init();
            num.text = "0";
            numPosition = num.transform.position;

            num.transform.gameObject.SetActive(false);

            image = account.FindChildDepth("Image");
            image.localScale = Vector3.one;
            image.GetComponent<Image>().sprite =
                LTBY_Extend.Instance.LoadSprite("res_fishmodel", $"fish_{fishType}");
            image.localEulerAngles = new Vector3(0, 0, 0);

            Sequence sequence = DOTween.Sequence();
            sequence.Append(image.DOBlendableScaleBy(new Vector3(3, 3, 1), 0.01f).SetEase(Ease.Linear).SetLink(image.gameObject));
            sequence.Append(image.DOBlendableScaleBy(new Vector3(-3, -3, 1), 0.2f).SetEase(Ease.Linear).SetLink(image.gameObject));
            sequence.SetLink(image.gameObject);
            Sequence sequence1 = DOTween.Sequence();
            sequence.Append(sequence1);
            sequence1.Append(image.DOBlendableRotateBy(new Vector3(0, 0, 10), 0.2f).SetEase(Ease.Linear).SetLink(image.gameObject));
            sequence1.Append(image.DOBlendableRotateBy(new Vector3(0, 0, -10), 0.4f).SetEase(Ease.Linear).SetLink(image.gameObject));
            sequence1.Append(image.DOBlendableRotateBy(new Vector3(0, 0, 10), 0.2f).SetEase(Ease.Linear).SetLink(image.gameObject));
            sequence1.SetLoops(10);
            sequence1.SetLink(image.gameObject);
            sequence.SetLink(image.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);
        }

        public override void AddScore(long _score, float roll = 0)
        {
            base.AddScore(_score, roll);
            num.transform.gameObject.SetActive(true);

            score = _score;

            num.RollTo(score, 2);

            var position = account.position;
            float baseX = position.x;
            float baseY = position.y;
            Vector3 aimPos = LTBY_GameView.GameInstance.GetCoinWorldPos(chairId);
            float aimX = aimPos.x;
            float aimY = aimPos.y;

            float delay = 4;

            if (score >= EffectConfig.UseFireworkScore)
            {
                int key = LTBY_Extend.Instance.DelayRun(0, ()=>
                {
                    EffectParamData _data = new EffectParamData()
                    {
                        chairId = chairId,
                        pos = LTBY_GameView.GameInstance.GetEffectWorldPos(chairId),
                        scale = 0.5f
                    };
                    LTBY_EffectManager.Instance.CreateBoostScoreBoardEffects(score, _data);
                });
                timerKey.Add(key);
            }

            if (LTBY_EffectManager.Instance.CheckCanUseHundredMillion(score))
            {
                delay++;
            }

            Sequence sequence = DOTween.Sequence();
            sequence.Append(DOTween.To(value =>
            {
                if (account == null) return;
                float t = value * 0.01f;
                account.position = new Vector3(baseX + (aimX - baseX) * t, baseY + (aimY - baseY) * t, 0);
                float _scale = 1 - t;
                account.localScale = new Vector3(_scale, _scale, _scale);
            }, 0, 100, 0.3f).SetEase(Ease.InBack).OnKill(() =>
            {
                LTBY_GameView.GameInstance.CreateAddUserScoreItem(chairId, score);
                LTBY_GameView.GameInstance.AddScore(chairId, score);
                LTBY_EffectManager.Instance.DestroyEffect<SpineAwardLevel>(chairId, id);
            }).SetDelay(delay));
            sequence.SetLink(account.gameObject);
            int _key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(_key);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (account == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem(prefabName, account);
            account = null;
        }
    }

    public class SpineAwardFullScreen : EffectClass
    {
        Transform JinBiPart;
        Transform image;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(SpineAwardFullScreen);
            id = _id;
            chairId = _chairId;

            actionKey = new List<int>();
            timerKey = new List<int>();
            int fishType = args.Length >= 1 ? (int) args[0] : 0;
            score = args.Length >= 2 ? (long) args[1] : 0;
            float delay = args.Length >= 3 ? (float) args[2] : 0;

            if (score >= EffectConfig.UseFireworkScore)
            {
                int key = LTBY_Extend.Instance.DelayRun(1, ()=>
                {
                    EffectParamData _data = new EffectParamData()
                    {
                        chairId = _chairId,
                        pos = Vector3.zero
                    };
                    LTBY_EffectManager.Instance.CreateBoostScoreBoardEffects(score, _data);
                });
                timerKey.Add(key);
            }

            int _key = LTBY_Extend.Instance.DelayRun(delay, ()=>
            {
                LTBY_Audio.Instance.Play(SoundConfig.SpineAward2);

                LTBY_Audio.Instance.Play(SoundConfig.SpineAwardText4);

            account = account != null ? account : LTBY_PoolManager.Instance.GetUiItem("LTBY_SpineAwardFullScreen",
                        LTBY_EffectManager.Instance.UiLayer);
                account.gameObject.SetActive(true);
                account.position = new Vector3(0, 0, 0);

                JinBiPart = JinBiPart != null ? JinBiPart : account.FindChildDepth("Particle System/JinBiPart");

                JinBiPart.gameObject.SetActive(!LTBY_EffectManager.Instance.CheckCanUseHundredMillion(score));

                skeleton = skeleton!=null ? skeleton : account.FindChildDepth<SkeletonGraphic>("Skeleton");
                if (skeleton != null)
                {
                    skeleton.AnimationState.SetAnimation(0, "stand01", false);
                }

                account.localScale = new Vector3(1, 1, 1);

                num = num!=null ? num : account.FindChildDepth("Num").GetILComponent<NumberRoller>();
                num = num!=null ? num : account.FindChildDepth("Num").AddILComponent<NumberRoller>();
                num.Init();
                num.text = "0";
                num.RollTo(score, 3);

                image = image!=null ? image : account.FindChildDepth("Image");
                image.GetComponent<Image>().sprite =
                    LTBY_Extend.Instance.LoadSprite("res_fishmodel", $"fish_{fishType}");
                image.localEulerAngles = new Vector3(0, 0, 0);
                image.localScale = Vector3.one;

                Sequence sequence = DOTween.Sequence();
                sequence.Append(image.DOBlendableScaleBy(new Vector3(3, 3, 1), 0.01f).SetEase(Ease.Linear).SetLink(image.gameObject));
                sequence.Append(image.DOBlendableScaleBy(new Vector3(-3, -3, 1), 0.2f).SetEase(Ease.Linear).SetLink(image.gameObject));
                sequence.SetLink(image.gameObject);
                Sequence sequence1 = DOTween.Sequence();
                sequence.Append(sequence1);
                sequence1.Append(image.DOBlendableRotateBy(new Vector3(0, 0, 10), 0.2f).SetEase(Ease.Linear).SetLink(image.gameObject));
                sequence1.Append(image.DOBlendableRotateBy(new Vector3(0, 0, -10), 0.4f).SetEase(Ease.Linear).SetLink(image.gameObject));
                sequence1.Append(image.DOBlendableRotateBy(new Vector3(0, 0, 10), 0.2f).SetEase(Ease.Linear).SetLink(image.gameObject));
                sequence1.SetLoops(10);
                sequence1.SetLink(image.gameObject);
                sequence.SetLink(image.gameObject);
                
                int _key1 = LTBY_Extend.Instance.RunAction(sequence);
                actionKey.Add(_key1);

                float delayTime = 4.5f;
                if (LTBY_EffectManager.Instance.CheckCanUseHundredMillion(score))
                {
                    delayTime = 5.8f;
                }

                Sequence sequence2 = DOTween.Sequence();
                sequence2.Append(DOTween.To(value =>
                {
                    if (account == null) return;
                    float t = value * 0.01f;
                    float _scale = 1 - t;
                    account.localScale = new Vector3(_scale, _scale, _scale);
                }, 0, 100, 0.5f).SetEase(Ease.InBack).OnKill(() =>
                {
                    LTBY_GameView.GameInstance.CreateAddUserScoreItem(chairId, score);
                    LTBY_GameView.GameInstance.AddScore(chairId, score);
                    LTBY_EffectManager.Instance.DestroyEffect<SpineAwardFullScreen>(chairId, id);
                }).SetDelay(delayTime));
                sequence2.SetLink(account.gameObject);
                int _key2 = LTBY_Extend.Instance.RunAction(sequence2);
                actionKey.Add(_key2);
            });
            timerKey.Add(_key);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (account == null) return;
            account.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (account == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem("LTBY_SpineAwardFullScreen", account);
            account = null;
        }
    }

    public class DragonSpineAward : EffectClass
    {
        long baseScore;
        bool isSelf;
        Transform effect1;
        Transform effect2;
        Transform numNode;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(DragonSpineAward);
            id = _id;
            chairId = _chairId;
            score = args.Length >= 1 ? (long) args[0] : 0;
            baseScore = args.Length >= 2 ? (int) args[1] : 0;

            actionKey = new List<int>();
            timerKey = new List<int>();

            account = account != null ? account : LTBY_PoolManager.Instance.GetUiItem("LTBY_DragonSpineAward", LTBY_EffectManager.Instance.UiLayer);
            account.gameObject.SetActive(true);
            skeleton = skeleton!= null ? skeleton : account.FindChildDepth<SkeletonGraphic>("Skeleton");
            skeleton.AnimationState.SetAnimation(0, "stand01", false);

            if (LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                LTBY_Audio.Instance.Play(SoundConfig.DragonSpineAward);
                isSelf = true;
                account.localScale = new Vector3(1.1f, 1.1f, 1.1f);
                account.position = new Vector3(0, 0, 0);
                effect1 = account.FindChildDepth("Effect1_1");
                effect2 = account.FindChildDepth("Effect1_2");
            }
            else
            {
                isSelf = false;
                account.localScale = new Vector3(0.7f, 0.7f, 0.7f);
                account.position = LTBY_GameView.GameInstance.GetEffectWorldPos(chairId);
                effect1 = account.FindChildDepth("Effect2_1");
                effect2 = account.FindChildDepth("Effect2_2");
            }


            numNode = numNode!=null ? numNode : account.FindChildDepth("Num");
            numNode.gameObject.SetActive(false);
            num = num!=null ? num : numNode.GetILComponent<NumberRoller>();
            num = num!=null ? num : numNode.AddILComponent<NumberRoller>();
            num.Init();
            num.text = "0";

            int key = LTBY_Extend.Instance.DelayRun(2, ()=> { skeleton?.AnimationState?.SetAnimation(1, "stand02", true); });
            timerKey.Add(key);

            RollNum();
        }

        float numScale;

        private void RollNum()
        {
            numScale = 0.65f;
            numNode.localScale = new Vector3(numScale, numScale, numScale);
            int count = 0;
            Queue<long> numList = new Queue<long>();
            long bulletRatio = score / baseScore;
            Queue<float> scaleList = new Queue<float>();

            long ratio = 0;
            if (baseScore >= 100)
            {
                count = 1;
                ratio = baseScore < 200 ? baseScore : 100;
                numList.Enqueue(bulletRatio * ratio);
                scaleList.Enqueue(0.75f);
            }

            if (baseScore >= 200)
            {
                count = 2;
                ratio = baseScore < 300 ? baseScore : 200;
                numList.Enqueue(bulletRatio * ratio);
                scaleList.Enqueue(0.8f);
            }

            if (baseScore >= 300)
            {
                count = 3;
                ratio = baseScore < 400 ? baseScore : 300;
                numList.Enqueue(bulletRatio * ratio);
                scaleList.Enqueue(0.85f);
            }

            if (baseScore >= 400)
            {
                count = 4;
                ratio = baseScore < 500 ? baseScore : 400;
                numList.Enqueue(bulletRatio * ratio);
                scaleList.Enqueue(0.9f);
            }

            if (baseScore >= 500)
            {
                count = 5;
                numList.Enqueue(bulletRatio * 500);
                scaleList.Enqueue(1);
            }

            float delay = 0;
            for (int i = 0; i < count; i++)
            {
                int index = i;
                long to = numList.Dequeue();

                float data = scaleList.Dequeue();
                Sequence sequence = DOTween.Sequence();
                sequence.Append(LTBY_Extend.DelayRun(delay + 1).OnComplete(() =>
                {
                    numNode.gameObject.SetActive(true);
                    num.RollTo(to, 1);
                }));
                sequence.Append(LTBY_Extend.DelayRun(0.6f).OnComplete(() =>
                {
                    LTBY_Audio.Instance.Play(SoundConfig.DragonEffect2);

                    //最后一次加分的时候 播放烟花
                    if (index == count - 1)
                    {
                        //当达到一亿分的时候 隐藏这个爆金币的特效，用一亿分的特效代替
                        if (!(isSelf && LTBY_EffectManager.Instance.CheckCanUseHundredMillion(score)))
                        {
                            effect2?.gameObject.SetActive(false);
                            effect2?.gameObject.SetActive(true);
                        }


                        if (score < EffectConfig.UseFireworkScore) return;
                        EffectParamData _data = new EffectParamData()
                        {
                            chairId = chairId,
                            pos = isSelf ? new Vector3(0, 0, 0) : LTBY_GameView.GameInstance.GetEffectWorldPos(chairId),
                            scale = isSelf ? 1f : 0.5f
                        };
                        LTBY_EffectManager.Instance.CreateBoostScoreBoardEffects(score, _data);
                    }
                    else
                    {
                        effect2?.gameObject.SetActive(false);
                        effect2?.gameObject.SetActive(true);
                    }
                }));
                sequence.Append(LTBY_Extend.DelayRun(0.4f).OnComplete(() =>
                {
                    effect1?.gameObject.SetActive(false);
                    effect1?.gameObject.SetActive(true);
                }));
                sequence.Append(numNode.DOScale(new Vector3(data * 1.5f, data * 1.5f, 1), 0.04f)
                    .SetEase(Ease.Linear).SetLink(numNode.gameObject));
                sequence.Append(numNode.DOScale(new Vector3(data, data, 1), 0.7f).SetEase(Ease.OutSine).SetLink(numNode.gameObject));
                sequence.SetLink(effect1.gameObject);
                int key = LTBY_Extend.Instance.RunAction(sequence);
                actionKey.Add(key);
                delay += 2;
            }

            if (score >= EffectConfig.UseFireworkScore)
            {
                delay += 2;
            }

            if (isSelf)
            {
                Sequence sequence = DOTween.Sequence();
                sequence.Append(LTBY_Extend.DelayRun(delay + 2).OnComplete(() =>
                {
                    effect1?.gameObject.SetActive(false);
                    effect2?.gameObject.SetActive(false);
                }));
                sequence.Append(account.DOScale(new Vector3(0, 0, 1), 0.4f).SetEase(Ease.InBack).SetDelay(0.2f).SetLink(account.gameObject));
                sequence.OnKill(() =>
                {
                    LTBY_GameView.GameInstance.CreateAddUserScoreItem(chairId, score);
                    LTBY_GameView.GameInstance.AddScore(chairId, score);
                    LTBY_EffectManager.Instance.DestroyEffect<DragonSpineAward>(chairId, id);
                });
                sequence.SetLink(account.gameObject);
                int key = LTBY_Extend.Instance.RunAction(sequence);
                actionKey.Add(key);
            }
            else
            {
                var position = account.position;
                float baseX = position.x;
                float baseY = position.y;
                Vector3 aimPos = LTBY_GameView.GameInstance.GetCoinWorldPos(chairId);
                float aimX = aimPos.x;
                float aimY = aimPos.y;
                Sequence sequence = DOTween.Sequence();
                sequence.Append(DOTween.To(value =>
                {
                    if (account == null) return;
                    float t = value * 0.01f;
                    account.position = new Vector3(baseX + (aimX - baseX) * t, baseY + (aimY - baseY) * t, 0);
                    float _scale = (1 - t) * 0.7f;
                    account.localScale = new Vector3(_scale, _scale, _scale);
                }, 0, 100, 0.3f).SetEase(Ease.InBack).OnKill(() =>
                {
                    LTBY_GameView.GameInstance.CreateAddUserScoreItem(chairId, score);
                    LTBY_EffectManager.Instance.DestroyEffect<DragonSpineAward>(chairId, id);
                }).SetDelay(delay + 2));
                sequence.SetLink(account.gameObject);
                int key = LTBY_Extend.Instance.RunAction(sequence);
                actionKey.Add(key);
            }
        }

        public override void OnStored()
        {
            base.OnStored();
            skeleton?.AnimationState.ClearTracks();

            if (account != null)
            {
                account.gameObject.SetActive(false);
            }
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (account == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem("LTBY_DragonSpineAward", account);
            account = null;
        }
    }

    public class Wheel : EffectClass
    {
        Vector3 aimPos;
        string showType;
        Action callBack;
        Text effectMul;
        Transform nodeText;
        Image image;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(Wheel);
            id = _id;
            chairId = _chairId;
            EffectParamData data = args.Length > 0 ? (EffectParamData) args[0] : new EffectParamData();
            showType = data.showType;
            score = data.showScore;
            callBack = data.callBack;
            aimPos = data.aimPos == Vector3.zero
                ? LTBY_GameView.GameInstance.GetCoinWorldPos(chairId)
                : data.aimPos;

            if (LTBY_GameView.GameInstance.IsSelf(chairId) && data.playSound)
            {
                LTBY_Audio.Instance.Play(SoundConfig.Wheel);
            }

            effect = effect!=null
                ? effect
                : LTBY_PoolManager.Instance.GetUiItem("LTBY_Wheel", LTBY_EffectManager.Instance.UiLayer);
            effect.gameObject.SetActive(true);
            effect.localScale = new Vector3(0.5f, 0.5f, 1);
            effect.position = data.pos;

            skeleton =
                skeleton !=null? skeleton : effect.FindChildDepth<SkeletonGraphic>("Node/Skeleton");
            if (skeleton!=null)
            {
                skeleton.AnimationState.SetAnimation(0, "stand01", false);
            }

            effectMul = effectMul!=null ? effectMul : effect.FindChildDepth<Text>("Mul");

            if (data.useMul > 0)
            {
                effectMul.gameObject.SetActive(true);
                effectMul.text = $"x{data.useMul}";
                score /= data.useMul;
            }
            else
            {
                effectMul.gameObject.SetActive(false);
            }


            num = num!=null ? num : effect.FindChildDepth("Node/Num").GetILComponent<NumberRoller>();
            num = num!=null ? num : effect.FindChildDepth("Node/Num").AddILComponent<NumberRoller>();
            num.Init();
            nodeText = nodeText!=null ? nodeText : effect.FindChildDepth("Node/Text");
            if (showType.Equals("Score"))
            {
                num.gameObject.SetActive(true);
                num.RollFromTo(0, score, 0.7f);
                nodeText.gameObject.SetActive(false);
            }
            else
            {
                nodeText.gameObject.SetActive(true);
                num.gameObject.SetActive(false);
            }

            num.transform.localEulerAngles = new Vector3(0, 0, 0);

            image = image!=null ? image : effect.FindChildDepth<Image>("Node/Image");
            image.sprite = LTBY_Extend.Instance.LoadSprite("res_fishmodel", $"fish_{data.fishType}");
            image.transform.localEulerAngles = new Vector3(0, 0, 0);

            actionKey = new List<int>();

            Sequence sequence = DOTween.Sequence();
            sequence.Append(effect.DOScale(new Vector3(1, 1, 1), 0.5f).SetEase(Ease.OutElastic).SetLink(effect.gameObject));
            sequence.SetLink(effect.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);

            Sequence sequence1 = DOTween.Sequence();
            sequence1.Append(image.transform.DOBlendableRotateBy(new Vector3(0, 0, 10), 0.2f).SetEase(Ease.Linear).SetLink(image.gameObject));
            sequence1.Append(image.transform.DOBlendableRotateBy(new Vector3(0, 0, -20), 0.4f).SetEase(Ease.Linear).SetLink(image.gameObject));
            sequence1.Append(image.transform.DOBlendableRotateBy(new Vector3(0, 0, 10), 0.2f).SetEase(Ease.Linear).SetLink(image.gameObject));
            sequence1.SetLoops(2);
            sequence1.SetLink(image.gameObject);
            int _key = LTBY_Extend.Instance.RunAction(sequence1);
            actionKey.Add(_key);

            Sequence sequence2 = DOTween.Sequence();
            sequence2.Append(image.transform.DOBlendableRotateBy(new Vector3(0, 0, 7), 0.2f).SetEase(Ease.Linear).SetLink(image.gameObject));
            sequence2.Append(image.transform.DOBlendableRotateBy(new Vector3(0, 0, -14), 0.4f).SetEase(Ease.Linear).SetLink(image.gameObject));
            sequence2.Append(image.transform.DOBlendableRotateBy(new Vector3(0, 0, 7), 0.2f).SetEase(Ease.Linear).SetLink(image.gameObject));
            sequence2.SetLoops(2);
            sequence2.OnKill(MoveAction);
            sequence2.SetLink(image.gameObject);
            int _key1 = LTBY_Extend.Instance.RunAction(sequence2);
            actionKey.Add(_key1);
        }

        private void MoveAction()
        {
            if (showType.Equals("Score"))
            {
                var position = effect.position;
                float baseX = position.x;
                float baseY = position.y;

                float aimX = aimPos.x;
                float aimY = aimPos.y;

                float offsetX = (aimX - baseX) * 0.5f;
                float offsetY = aimY > baseY ? -15 : 15;

                Sequence sequence = DOTween.Sequence();
                sequence.Append(DOTween.To(value =>
                {
                    if (effect == null) return;
                    float t = value * 0.01f;
                    float x = aimX + offsetX * (1 - t);
                    float y = aimY + offsetY * (1 - t);
                    effect.position = new Vector3(baseX + (x - baseX) * t, baseY + (y - baseY) * t, 0);

                    float _scale = 1 - 0.9f * t;
                    effect.localScale = new Vector3(_scale, _scale, _scale);
                }, 0, 100, 0.5f).OnKill(() =>
                {
                    callBack?.Invoke();
                    LTBY_EffectManager.Instance.DestroyEffect<Wheel>(chairId, id);
                }));
                sequence.SetLink(effect.gameObject);
                int key = LTBY_Extend.Instance.RunAction(sequence);
                actionKey.Add(key);
            }
            else
            {
                Sequence sequence = DOTween.Sequence();
                sequence.Append(effect.DOScale(new Vector3(0, 0, 1), 0.3f).SetLink(effect.gameObject).SetEase(Ease.InBack).OnKill(() =>
                {
                    callBack?.Invoke();
                    LTBY_EffectManager.Instance.DestroyEffect<Wheel>(chairId, id);
                }));
                sequence.SetLink(effect.gameObject);
                int key = LTBY_Extend.Instance.RunAction(sequence);
                actionKey.Add(key);
            }
        }

        public override void OnStored()
        {
            base.OnStored();
            callBack = null;

            if (effect != null)
            {
                effect.gameObject.SetActive(false);
            }
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (effect == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem("LTBY_Wheel", effect);
            effect = null;
        }
    }

    public class FlyText : EffectClass
    {
        Transform textNode;
        NumberRoller numRoller;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(FlyText);
            id = _id;
            chairId = _chairId;

            actionKey = new List<int>();
            string textType = args.Length >= 1 ? args[0].ToString() : "";
            float interval = args.Length >= 2 ? (float) args[1] : 0;
            Vector3 worldPos = args.Length >= 3 ? (Vector3) args[2] : Vector3.zero;
            try
            {
                score = args.Length >= 4 ? (long) args[3] : 0;
            }
            catch (Exception e)
            {
                score = 0;
            }

            textNode = textNode!=null
                ? textNode
                : LTBY_PoolManager.Instance.GetUiItem("LTBY_TextNode", LTBY_EffectManager.Instance.UiLayer);
            textNode.gameObject.SetActive(true);
            textNode.localScale = new Vector3(1, 1, 1);
            textNode.position = worldPos;
            numRoller = numRoller!=null
                ? numRoller
                : textNode.FindChildDepth("Num").GetILComponent<NumberRoller>();
            numRoller = numRoller!=null
                ? numRoller
                : textNode.FindChildDepth("Num").AddILComponent<NumberRoller>();
            numRoller.Init();
            numRoller.text = score.ShortNumber().ToString();

            text = text!=null ? text : textNode.FindChildDepth("Text");
            switch (textType)
            {
                case "Outburst":
                    text.GetComponent<Text>().text = EffectConfig.FlyText[1];
                    break;
                case "ScratchCard":
                    text.GetComponent<Text>().text = EffectConfig.FlyText[2];
                    break;
                case "PoolTreasure0":
                    text.GetComponent<Text>().text = EffectConfig.FlyText[3];
                    break;
                case "PoolTreasure1":
                    text.GetComponent<Text>().text = EffectConfig.FlyText[4];
                    break;
                case "PoolTreasure2":
                    text.GetComponent<Text>().text = EffectConfig.FlyText[5];
                    break;
            }

            var position = textNode.position;
            float baseX = position.x;
            float baseY = position.y;
            Vector3 aimPos = LTBY_GameView.GameInstance.GetCoinWorldPos(chairId);
            float aimX = aimPos.x;
            float aimY = aimPos.y;

            Sequence sequence = DOTween.Sequence();
            sequence.Append(textNode.DOScale(new Vector3(1.2f, 1.2f, 1), 0.1f).SetLink(textNode.gameObject).SetEase(Ease.Linear));
            sequence.Append(textNode.DOScale(new Vector3(1, 1, 1), 0.1f).SetLink(textNode.gameObject).SetEase(Ease.Linear));
            sequence.Append(LTBY_Extend.DelayRun(interval - 0.65f).SetEase(Ease.Linear));
            sequence.Append(DOTween.To(value =>
            {
                if (textNode == null) return;
                float t = value * 0.01f;
                textNode.position = new Vector3(baseX + (aimX - baseX) * t, baseY + (aimY - baseY) * t, 0);

                float _scale = 1 - 0.8f * t;
                textNode.localScale = new Vector3(_scale, _scale, _scale);
            }, 0, 100, 0.45f).SetEase(Ease.Linear).SetLink(textNode.gameObject));
            sequence.OnKill(() =>
            {
                LTBY_GameView.GameInstance.CreateAddUserScoreItem(chairId, score);
                LTBY_GameView.GameInstance.AddScore(chairId, score);
                LTBY_EffectManager.Instance.DestroyEffect<FlyText>(chairId, id);
            });
            sequence.SetLink(textNode.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (textNode == null) return;
            textNode.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (textNode == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem("LTBY_TextNode", textNode);
            textNode = null;
        }
    }

    public class SummonAppear : EffectClass
    {
        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            LTBY_Audio.Instance.Play(SoundConfig.Summon);
            name = nameof(SummonAppear);
            id = _id;
            chairId = _chairId;
            Vector3 pos = args.Length > 0 ? (Vector3) args[0] : Vector3.zero;
            effect = effect!=null
                ? effect
                : LTBY_PoolManager.Instance.GetGameItem("LTBY_SummonAppear", LTBY_EffectManager.Instance.FishLayer);
            effect.gameObject.SetActive(true);
            effect.position = pos;

            timerKey = new List<int>();
            int key = LTBY_Extend.Instance.DelayRun(2,
                ()=> { LTBY_EffectManager.Instance.DestroyEffect<SummonAppear>(chairId, id); });
            timerKey.Add(key);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (effect == null) return;
            effect.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (effect == null) return;
            LTBY_PoolManager.Instance.RemoveGameItem("LTBY_SummonAppear", effect);
            effect = null;
        }
    }

    public class Aced : EffectClass
    {
        List<EffectParamData> fishList;
        new EffectClass effect;
        int multiple;
        int useMul;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(Aced);
            id = _id;
            chairId = _chairId;
            EffectParamData data = args.Length > 0 ? (EffectParamData) args[0] : new EffectParamData();
            if (LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                LTBY_Audio.Instance.Play(SoundConfig.AcedLinkText);
            }

            fishList = data.fishList;
            multiple = data.multiple;

            actionKey = new List<int>();
            timerKey = new List<int>();

            float interval = 0.15f;

            float delay = 0;

            for (int i = 0; i < fishList.Count; i++)
            {
                int index = i;
                int key = LTBY_Extend.Instance.DelayRun(delay, () =>
                {
                    if (index + 1 < fishList.Count && fishList[index + 1] != null)
                    {
                        LTBY_EffectManager.Instance.CreateEffect<AcedLink>(chairId, fishList[index].pos,
                            fishList[index + 1].pos);
                    }
                });
                timerKey.Add(key);
                delay += interval;
            }

            delay += interval;

            int lastIndex = fishList.Count;
            for (int i = 0; i < fishList.Count; i++)
            {
                int index = i;
                EffectParamData v = fishList[index];
                int key = LTBY_Extend.Instance.DelayRun(delay,  ()=>
                {
                    Check();
                    if (v?.callBack != null)
                    {
                        v.callBack.Invoke();
                        v.callBack = null;
                    }

                    EffectParamData effectConfigData = new EffectParamData()
                    {
                        level = 2,
                        pos = v.pos,
                        playSound = false
                    };
                    LTBY_EffectManager.Instance.CreateEffect<ExplosionPoint>(chairId, effectConfigData);
                    if (v == null) return;
                    EffectParamData effectConfigData1 = new EffectParamData()
                    {
                        pos = v.pos,
                        showType = "Score",
                        showScore = v.score,
                        fishType = v.fishType,
                        aimPos = effect == null ? Vector3.zero : effect.GetNumWorldPos(),
                        useMul = useMul,
                        playSound = index == 0 || index == lastIndex-1,
                        callBack = () =>
                        {
                            if (effect != null)
                            {
                                effect.AddScore(v.score);
                            }
                            else
                            {
                                LTBY_GameView.GameInstance.CreateAddUserScoreItem(chairId, v.score, true);
                                LTBY_GameView.GameInstance.AddScore(chairId, v.score);
                            }
                        }
                    };
                    LTBY_EffectManager.Instance.CreateEffect<Wheel>(chairId, effectConfigData1);
                });
                timerKey.Add(key);
                delay += interval;
            }
        }

        private void Check()
        {
            effect = null;
            useMul = -1;
            string hadSpecialBattery = LTBY_BatteryManager.Instance.HadSpecialBattery(chairId);
            if (string.IsNullOrEmpty(hadSpecialBattery)) return;
            if (hadSpecialBattery.Equals("Drill"))
            {
                effect = LTBY_EffectManager.Instance.GetDrill(chairId);
                if (effect == null)
                {
                    effect = LTBY_EffectManager.Instance.CreateDrill(chairId);
                }
            }
            else if (hadSpecialBattery.Equals("Electric"))
            {
                effect = LTBY_EffectManager.Instance.GetElectric(chairId);
                if (effect == null)
                {
                    effect = LTBY_EffectManager.Instance.CreateElectric(chairId);
                }
            }
            else if (hadSpecialBattery.Equals("FreeBattery"))
            {
                effect = LTBY_EffectManager.Instance.GetFreeBattery(chairId);
                if (effect == null)
                {
                    effect = LTBY_EffectManager.Instance.CreateFreeBattery(chairId);
                }

                useMul = multiple;
            }
        }

        public override void OnStored()
        {
            base.OnStored();
            if (fishList == null) return;
            for (int i = 0; i < fishList.Count; i++)
            {
                fishList[i]?.func?.Invoke();
            }

            fishList.Clear();
        }
    }

    public class AcedLink : EffectClass
    {
        Transform Dot1;
        Transform Dot2;
        LineRenderer line;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(AcedLink);
            id = _id;
            chairId = _chairId;

            if (LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                LTBY_Audio.Instance.Play(SoundConfig.AcedLink);
            }

            effect = effect!=null
                ? effect
                : LTBY_PoolManager.Instance.GetGameItem("LTBY_AcedLink", LTBY_EffectManager.Instance.FishLayer);
            effect.gameObject.SetActive(true);
            Vector3 startPos = args.Length > 0 ? (Vector3) args[0] : Vector3.zero;
            Vector3 endPos = args.Length > 0 ? (Vector3) args[1] : Vector3.zero;
            float dis = Vector2.Distance(startPos, endPos) - 4;
            float rad = Mathf.PI - Mathf.Atan2((endPos.y - startPos.y), (endPos.x - startPos.x));
            Vector3 midPos = (startPos + endPos) * 0.5f;

            Vector3 pos1 = new Vector3(midPos.x + dis * Mathf.Cos(rad) * 0.5f, midPos.y - dis * Mathf.Sin(rad) * 0.5f,
                0);
            Vector3 pos2 = new Vector3(midPos.x - dis * Mathf.Cos(rad) * 0.5f, midPos.y + dis * Mathf.Sin(rad) * 0.5f,
                0);

            Dot1 = Dot1 ? Dot1 : effect.FindChildDepth("Dot1");
            Dot2 = Dot2 ? Dot2 : effect.FindChildDepth("Dot2");
            Dot1.position = pos1;
            Dot2.position = pos2;

            line = line ? line : effect.FindChildDepth<LineRenderer>("Line");
            line.useWorldSpace = true;

            line.positionCount = 2;
            line.SetPosition(0, pos1);
            line.SetPosition(1, pos2);

            timerKey = new List<int>();
            int key = LTBY_Extend.Instance.DelayRun(1,
                ()=> { LTBY_EffectManager.Instance.DestroyEffect<AcedLink>(chairId, id); });
            timerKey.Add(key);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (effect == null) return;
            effect.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (effect == null) return;
            LTBY_PoolManager.Instance.RemoveGameItem("LTBY_AcedLink", effect);
            effect = null;
        }
    }

    public class DialFish : EffectClass
    {
        public class DialFishData
        {
            public Vector3 dialAimPos;
            public int dialMul;
            public TextMeshProUGUI mul;
            public Transform mulEffect;
            public int curShowMul;
            public bool beginRoll;
            public int rollState;
            public float dialT;
            public CFunc<float, float> easeFunc;
            public float dialSpeed;
            public float aimRotation;
            public float speedSlope;
            public float pointerSpeed;
            public float pointerSpeedMul;
            public float pointerT;
            public float pointerRotation1;
            public float pointerRotation2;
            public Transform effect;
            public Transform dial;
            public Transform board;
            public Transform pointer;
            public int mulCount;
            public float split;
            public List<Transform> dotList1;
            public List<Transform> dotList2;
            public bool dotShowFlag;
            internal int dotCount;
        }

        string hadSpecialBattery;
        bool isSelf;
        List<DialFishData> dialList;

        Transform shine;
        RectTransform mask;

        Vector3 basePos;
        Vector3 pos;
        int ratio;
        private TextMeshProUGUI result;
        private int resultMul;
        private Transform resultEffect;
        private List<Transform> Dails;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(DialFish);
            id = _id;
            chairId = _chairId;
            timerKey = new List<int>();
            actionKey = new List<int>();

            hadSpecialBattery = LTBY_BatteryManager.Instance.HadSpecialBattery(chairId);

            isSelf = LTBY_GameView.GameInstance.IsSelf(chairId);

            if (isSelf)
            {
                LTBY_Audio.Instance.Play(SoundConfig.DialFishText);
            }

            effect = effect!=null
                ? effect
                : LTBY_PoolManager.Instance.GetUiItem("LTBY_DialEffect", LTBY_EffectManager.Instance.UiLayer);
            effect.gameObject.SetActive(true);
            effect.localScale = new Vector3(1, 1, 1);
            Vector3 _pos = LTBY_GameView.GameInstance.GetBatteryWorldPos(chairId);
            if (isSelf)
            {
                _pos.y += 5;
                if (!string.IsNullOrEmpty(hadSpecialBattery))
                {
                    _pos.x = 0;
                }
            }
            else if (LTBY_GameView.GameInstance.CheckIsOtherSide(chairId))
            {
                _pos.y += 6;
            }
            else
            {
                _pos.y += 2;
            }

            effect.position = _pos;
            EffectParamData data = args.Length > 0 ? (EffectParamData) args[0] : new EffectParamData();
            InitData(data);

            EnterAction();
        }

        private void MoveAction(int i)
        {
            if (isSelf)
            {
                LTBY_Audio.Instance.Play(SoundConfig.DialFishGet);
            }
            if (dialList.Count <= i) return;
            DialFishData config = dialList[i];
            if (config == null) return;
            var position = config.dial.position;
            float baseX = position.x;
            float baseY = position.y;

            float aimX = config.dialAimPos.x;
            float aimY = config.dialAimPos.y;

            float offsetX = (aimX - baseX) * 0.5f;
            float offsetY = aimY > baseY ? -15 : 15;

            Sequence sequence = DOTween.Sequence();
            sequence.Append(DOTween.To(value =>
            {
                if (config.dial == null) return;
                float t = value * 0.01f;
                float x = aimX + offsetX * (1 - t);
                float y = aimY + offsetY * (1 - t);
                config.dial.position = new Vector3(baseX + (x - baseX) * t, baseY + (y - baseY) * t, 0);

                if (isSelf) return;
                float _scale = 1 - t;
                config.dial.localScale = new Vector3(_scale, _scale, _scale);
            }, 0, 100, 0.5f).SetEase(Ease.Linear).OnKill(() =>
            {
                if (i == 2)
                {
                    MoveFinish();
                }
            }));
            sequence.SetLink(config.dial.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);
        }

        private void MoveFinish()
        {
            if (isSelf)
            {
                shine.gameObject.SetActive(true);
                LTBY_Audio.Instance.Play(SoundConfig.DialFishFrame);
            }
            else
            {
                shine.gameObject.SetActive(false);
                effect.localScale = new Vector3(0.7f, 0.7f, 0.7f);
            }

            Sequence sequence = DOTween.Sequence();
            sequence.Append(DOTween.To(value =>
            {
                if (mask == null) return;
                float t = value / 100;
                float x = mask.sizeDelta.x;
                mask.sizeDelta = new Vector2(460 * t, 58);
            }, 0, 100, 0.5f).SetEase(Ease.Linear));
            sequence.SetLink(mask.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);

            for (int i = 0; i < 3; i++)
            {
                int index = i;
                int _key = LTBY_Extend.Instance.DelayRun(index * 0.5f, () =>
                {
                    if (isSelf)
                    {
                        LTBY_Audio.Instance.Play(SoundConfig.DialFishRoll);
                    }
                    if (dialList.Count > index) dialList[index].mul.gameObject.SetActive(true);
                    int kkey = LTBY_Extend.Instance.StartTimer(() => UpdateDial(index));
                    timerKey.Add(kkey);

                    if (index == 2)
                    {
                        int kkey1 = LTBY_Extend.Instance.StartTimer(() => UpdateMul(index), 0.05f);
                        timerKey.Add(kkey1);
                    }
                    else
                    {
                        int kkey1 = LTBY_Extend.Instance.StartTimer(() => UpdateMul(index));
                        timerKey.Add(kkey1);
                    }

                    int _key1 = LTBY_Extend.Instance.StartTimer(() => UpdateDot(index), 0.3f);
                    timerKey.Add(_key1);
                });
                timerKey.Add(_key);
            }
        }

        private void EnterAction()
        {
            basePos = pos;
            for (int i = 0; i < 3; i++)
            {
                int index = i;
                dialList[i].dialAimPos = isSelf
                    ? dialList[i].dial.position
                    : LTBY_GameView.GameInstance.GetBatteryWorldPos(chairId);
                dialList[i].dial.position = basePos;
                int key = LTBY_Extend.Instance.DelayRun(i * 0.3f + 0.5f, ()=> { MoveAction(index); });
                timerKey.Add(key);
            }
        }

        private int GetDialMulIndex(int i, int mul)
        {
            int[] keys = EffectConfig.DialConfig.GetDictionaryKeys();
            for (int j = 0; j < EffectConfig.DialConfig[keys[i]].Count; j++)
            {
                if (EffectConfig.DialConfig[keys[i]][j] == mul)
                {
                    return j;
                }
            }

            return 0;
        }

        private void InitData(EffectParamData data)
        {
            pos = data.pos;

            dialList = new List<DialFishData>();

            mask = mask!=null ? mask : effect.FindChildDepth<RectTransform>("Mask");
            mask.sizeDelta = new Vector2(0, 0);

            shine = mask.FindChildDepth("Shine");
            shine.gameObject.SetActive(false);

            if (hadSpecialBattery=="FreeBattery")
            {
                mask.FindChildDepth("ExtraMul").gameObject.SetActive(true);
                mask.FindChildDepth<Text>("ExtraMul").text = $"x{data.multiple}";
            }
            else
            {
                mask.FindChildDepth("ExtraMul").gameObject.SetActive(false);
            }

            ratio = data.ratio;

            result = mask.FindChildDepth<TextMeshProUGUI>("MulFrame/Result/Num");
            result.gameObject.SetActive(false);
            resultMul = 1;
            resultEffect = mask.FindChildDepth("MulFrame/Result/NumEffect");
            resultEffect.gameObject.SetActive(false);

            score = data.score;

            int[] dialkeys = EffectConfig.DialConfig.GetDictionaryKeys();
            for (int i = 0; i < 3; i++)
            {
                dialList.Add(new DialFishData());

                dialList[i].dialMul = GetDialMulIndex(i, data.mulList[i]);

                dialList[i].mul = mask.FindChildDepth<TextMeshProUGUI>($"MulFrame/Mul{i + 1}/Num");
                dialList[i].mul.gameObject.SetActive(false);
                dialList[i].mulEffect = mask.FindChildDepth($"MulFrame/Mul{i + 1}/NumEffect");
                dialList[i].mulEffect.gameObject.SetActive(false);
                dialList[i].curShowMul = 1;

                dialList[i].beginRoll = true;
                dialList[i].rollState = 1;
                dialList[i].dialT = 0;
                dialList[i].easeFunc = QuadEaseIn;

                if (i == 2)
                {
                    dialList[i].dialSpeed = 0.03f;
                    dialList[i].aimRotation = -720;
                }
                else
                {
                    dialList[i].dialSpeed = 0.04f;
                    dialList[i].aimRotation = -360;
                }

                dialList[i].speedSlope = -1;

                dialList[i].pointerSpeed = 5;
                dialList[i].pointerSpeedMul = 0;

                dialList[i].pointerT = 0;

                dialList[i].pointerRotation1 = 0;
                dialList[i].pointerRotation2 = 15;

                Dails = Dails != null ? Dails : new List<Transform>();
                if (Dails.Count <= i)
                {
                    Dails.Add(effect.FindChildDepth($"Dial{i + 1}"));
                }

                Transform dial = Dails[i];
                dial.localScale = new Vector3(1, 1, 1);
                dial.localPosition = new Vector3(-300 + (i + 1) * 150, 0, 0);
                Transform board = dial.FindChildDepth("Board");
                board.localEulerAngles = new Vector3(0, 0, 0);
                Transform pointer = dial.FindChildDepth("Pointer");

                dialList[i].effect = dial.FindChildDepth("Effect");

                dialList[i].dial = dial;
                dialList[i].board = board;
                dialList[i].pointer = pointer;

                int childCount = board.childCount;
                dialList[i].mulCount = childCount;
                for (int j = 0; j < childCount; j++)
                {
                    Text mul = board.FindChildDepth<Text>($"{j + 1}");
                    mul.text = $"x{EffectConfig.DialConfig[dialkeys[i]][j]}";
                    float rad = -2 * Mathf.PI / childCount * j;
                    float x = 38 * Mathf.Cos(rad + Mathf.PI * 0.5f);
                    float y = 38 * Mathf.Sin(rad + Mathf.PI * 0.5f);
                    var transform = mul.transform;
                    transform.localPosition = new Vector3(x, y, 0);
                    transform.localEulerAngles = new Vector3(0, 0, Mathf.Rad2Deg * rad);
                }

                dialList[i].split = 360f / childCount;

                dialList[i].dotList1 = new List<Transform>();
                dialList[i].dotList2 = new List<Transform>();
                dialList[i].dotShowFlag = true;

                int _childCount = dial.FindChildDepth("Dot1").childCount;
                dialList[i].dotCount = _childCount;

                for (int j = 0; j < _childCount; j++)
                {
                    Transform dot1 = dial.FindChildDepth($"Dot1/{j + 1}");
                    Transform dot2 = dial.FindChildDepth($"Dot2/{j + 1}");
                    float rad = 2 * Mathf.PI / _childCount * j;
                    float x = 63 * Mathf.Cos(rad);
                    float y = 63 * Mathf.Sin(rad);
                    dot1.localPosition = new Vector3(x, y, 0);
                    dot1.gameObject.SetActive(j % 2 == 0);
                    dot2.localPosition = new Vector3(x, y, 0);
                    dot2.gameObject.SetActive(j % 2 != 0);
                    dialList[i].dotList1.Add(dot1);
                    dialList[i].dotList2.Add(dot2);
                }
            }
        }

        private void OnFinish(int i)
        {
            Transform _effect = dialList[i].effect;

            TextMeshProUGUI mul = dialList[i].mul;
            int[] keys = EffectConfig.DialConfig.GetDictionaryKeys();
            int mulNum = EffectConfig.DialConfig[keys[i]][dialList[i].dialMul];
            mul.SetText(mulNum, true);
            dialList[i].mulEffect.gameObject.SetActive(true);
            Sequence sequence = DOTween.Sequence();
            sequence.Append(mul.transform.DOScale(new Vector3(1f * 1.8f, 1f * 1.8f, 0), 0.1f).SetLink(mul.gameObject));
            sequence.Append(mul.transform.DOScale(new Vector3(1f, 1f, 0), 0.1f).SetLink(mul.gameObject));
            sequence.SetLink(mul.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);

            resultMul *= mulNum;

            if (isSelf)
            {
                LTBY_Audio.Instance.Play(SoundConfig.AllAudio[$"DialFishMul{i + 1}"]);
            }

            if (i != 2) return;

            Sequence _sequence = DOTween.Sequence();
            _sequence.SetLink(result.gameObject);
            _sequence.Append(LTBY_Extend.DelayRun(0.8f).OnComplete(() =>
            {
                if (result == null) return;
                result.SetText(resultMul, true);
                result.gameObject.SetActive(true);
                resultEffect.gameObject.SetActive(true);
                if (isSelf)
                {
                    LTBY_Audio.Instance.Play(SoundConfig.DialFishMul4);
                }

                Sequence _sq = DOTween.Sequence();
                _sq.SetLink(result.gameObject);
                _sq.Append(result.transform.DOScale(new Vector3(1f * 1.8f, 1f * 1.8f, 1), 0.15f).SetLink(result.gameObject));
                _sq.Append(result.transform.DOScale(new Vector3(1f, 1f, 1), 0.15f).SetLink(result.gameObject));
                int kkey = LTBY_Extend.Instance.RunAction(_sq);
                actionKey.Add(kkey);
            }));
            _sequence.Append(LTBY_Extend.DelayRun(1).OnComplete(() =>
            {
                for (int j = 0; j < timerKey.Count; j++)
                {
                    LTBY_Extend.Instance.StopTimer(timerKey[j]);
                }

                timerKey.Clear();
                if (resultMul >= 500)
                {
                    LTBYEntry.Instance.ShakeFishLayer(1);
                }

                LTBY_EffectManager.Instance.CreateEffect<SpineDialFish>(chairId, score);
            }));
            CanvasGroup group = effect.GetComponent<CanvasGroup>();
            if (group == null) group = effect.gameObject.AddComponent<CanvasGroup>();
            _sequence.Append(group.DOFade(0, 0.3f).SetEase(Ease.Linear).OnKill(() =>
            {
                LTBY_EffectManager.Instance.DestroyEffect<DialFish>(chairId, id);
                group.alpha = 1;
            }));
            int _key = LTBY_Extend.Instance.RunAction(_sequence);
            actionKey.Add(_key);
        }

        private void UpdateDot(int i)
        {
            if (dialList.Count <= i) return;
            DialFishData config = dialList[i];
            if (config == null) return;
            if (config.dotShowFlag)
            {
                for (int j = 0; j < config.dotCount; j++)
                {
                    config.dotList1[j].gameObject.SetActive(j % 2 != 0);
                    config.dotList2[j].gameObject.SetActive(j % 2 == 0);
                }
            }
            else
            {
                for (int j = 0; j < config.dotCount; j++)
                {
                    config.dotList1[j].gameObject.SetActive(j % 2 == 0);
                    config.dotList2[j].gameObject.SetActive(j % 2 != 0);
                }
            }

            config.dotShowFlag = !config.dotShowFlag;
        }

        private void UpdateMul(int i)
        {
            if (dialList.Count <= i) return;
            DialFishData config = dialList[i];
            if (config == null) return;
            if (!config.beginRoll) return;
            config.curShowMul++;
            if (config.curShowMul > config.mulCount)
            {
                config.curShowMul = 1;
            }

            int[] keys = EffectConfig.DialConfig.GetDictionaryKeys();
            config.mul?.SetText(EffectConfig.DialConfig[keys[i]][config.curShowMul - 1], true);
        }

        private void UpdateDial(int i)
        {
            if (i >= dialList.Count) return;
            DialFishData config = dialList[i];
            if (config == null) return;
            if (!config.beginRoll) return;
            config.dialT += config.dialSpeed;
            if (config.dialT > 1)
            {
                config.dialT = 0;
                switch (config.rollState)
                {
                    case 1:
                        config.rollState = 2;
                        config.easeFunc = Linear;
                        config.speedSlope = -1;
                        break;
                    case 2:
                        config.rollState = 3;
                        config.easeFunc = QuadEaseOut;
                        config.aimRotation += config.dialMul * config.split;
                        config.speedSlope = -1;
                        break;
                    case 3:
                        config.beginRoll = false;
                        config.pointer.localEulerAngles = new Vector3(0, 0, 0);
                        config.curShowMul = config.dialMul + 1;
                        OnFinish(i);
                        break;
                }
            }
            else
            {
                var t = config.easeFunc(config.dialT);
                config.board.localEulerAngles = new Vector3(0, 0, Lerp(0, config.aimRotation, t));

                if (config.speedSlope < 0)
                {
                    config.speedSlope = t;
                }
                else
                {
                    config.pointerSpeedMul = t - config.speedSlope;
                    config.speedSlope = t;
                }

                config.pointerT += config.pointerSpeed * config.pointerSpeedMul;
                config.pointer.localEulerAngles = new Vector3(0, 0,
                    Lerp(config.pointerRotation1, config.pointerRotation2, config.pointerT));
                if (config.pointerT > 1)
                {
                    config.pointerT = 0;
                }
            }
        }

        private float Lerp(float a, float b, float t)
        {
            return a + (b - a) * t;
        }

        private float QuadEaseOut(float time)
        {
            return -1 * time * (time - 2);
        }

        private float Linear(float time)
        {
            return time * 2;
        }

        private float QuadEaseIn(float time)
        {
            return time * time;
        }

        public override void OnStored()
        {
            base.OnStored();
            dialList?.Clear();
            if (effect == null) return;
            effect.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (effect == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem("LTBY_DialEffect", effect);
            effect = null;
        }
    }

    public class SpineDialFish : EffectClass
    {
        bool isSelf;
        Transform EffectSelf;
        Transform EffectOther;
        Transform JinBiPart;
        float curScale;
        Transform SelfGQ;
        Transform OtherGQ;
        private Transform image;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(SpineDialFish);
            id = _id;
            chairId = _chairId;
            isSelf = LTBY_GameView.GameInstance.IsSelf(chairId);

            actionKey = new List<int>();
            timerKey = new List<int>();

            score = args.Length > 0 ? (long) args[0] : 0;

            account = account!=null
                ? account
                : LTBY_PoolManager.Instance.GetUiItem($"LTBY_SpineDialFish", LTBY_EffectManager.Instance.UiLayer);
            account.gameObject.SetActive(true);

            EffectSelf = EffectSelf!=null ? EffectSelf : account.FindChildDepth("EffectSelf");
            EffectOther = EffectOther!=null ? EffectOther : account.FindChildDepth("EffectOther");
            JinBiPart = JinBiPart != null ? JinBiPart : EffectSelf.FindChildDepth($"JinBiPart");

            if (isSelf)
            {
                LTBY_Audio.Instance.Play(SoundConfig.SpineAward2);

                account.position = new Vector3(0, 0, 0);
                EffectSelf.gameObject.SetActive(false);
                EffectSelf.gameObject.SetActive(isSelf);
                EffectOther.gameObject.SetActive(false);

                curScale = 1;
            }
            else
            {
                account.position = LTBY_GameView.GameInstance.GetEffectWorldPos(chairId);
                EffectOther.gameObject.SetActive(false);
                EffectOther.gameObject.SetActive(!isSelf);
                EffectSelf.gameObject.SetActive(false);

                curScale = 0.8f;
            }

            SelfGQ = SelfGQ!=null ? SelfGQ : account.FindChildDepth("EffectSelf/guaquan");
            OtherGQ = OtherGQ!=null ? OtherGQ : account.FindChildDepth("EffectOther/guaquan");

            if (score >= EffectConfig.UseFireworkScore)
            {
                SelfGQ.gameObject.SetActive(false);
                OtherGQ.gameObject.SetActive(false);
                EffectParamData _data = new EffectParamData()
                {
                    chairId = _chairId,
                    pos = isSelf ? Vector3.zero : LTBY_GameView.GameInstance.GetEffectWorldPos(chairId),
                    scale = isSelf ? 1 : 0.5f
                };
                LTBY_EffectManager.Instance.CreateBoostScoreBoardEffects(score, _data);
            }
            else
            {
                SelfGQ.gameObject.SetActive(true);
                OtherGQ.gameObject.SetActive(true);
            }

            JinBiPart.gameObject.SetActive(!LTBY_EffectManager.Instance.CheckCanUseHundredMillion(score));

            account.localScale = new Vector3(curScale, curScale, curScale);

            skeleton = skeleton!=null ? skeleton : account.FindChildDepth<SkeletonGraphic>("Skeleton");
            if (skeleton != null)
            {
                skeleton.AnimationState.SetAnimation(0, "stand01", false);
            }

            num = num!=null ? num : account.FindChildDepth("Num").GetILComponent<NumberRoller>();
            num = num!=null ? num : account.FindChildDepth("Num").AddILComponent<NumberRoller>();
            num.Init();
            num.text = "0";
            num.RollTo(score, 3);

            image = account.FindChildDepth("Image");
            image.localEulerAngles = new Vector3(0, 0, 0);
            image.localScale = Vector3.one;
            Sequence sequence = DOTween.Sequence();
            sequence.Append(image.DOBlendableScaleBy(new Vector3(3, 3), 0.01f).SetLink(image.gameObject));
            sequence.Append(image.DOBlendableScaleBy(new Vector3(-3, -3), 0.01f).SetLink(image.gameObject));
            Sequence sequence1 = DOTween.Sequence();
            sequence.Append(sequence1);
            sequence1.Append(image.DOBlendableRotateBy(new Vector3(0, 0, 10), 0.2f).SetLink(image.gameObject));
            sequence1.Append(image.DOBlendableRotateBy(new Vector3(0, 0, -10), 0.4f).SetLink(image.gameObject));
            sequence1.Append(image.DOBlendableRotateBy(new Vector3(0, 0, 10), 0.2f).SetLink(image.gameObject));
            sequence1.SetLoops(10);
            sequence1.SetLink(image.gameObject);
            sequence.SetLink(image.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);

            Tween tween = DOTween.To(value =>
            {
                if (account == null) return;
                float t = value * 0.01f;
                float _scale = (1 - t) * curScale;
                account.localScale = new Vector3(_scale, _scale, _scale);
            }, 0, 100, 0.5f).SetEase(Ease.InBack).OnKill(() =>
            {
                LTBY_GameView.GameInstance.CreateAddUserScoreItem(chairId, score);
                LTBY_GameView.GameInstance.AddScore(chairId, score);
                LTBY_EffectManager.Instance.DestroyEffect<SpineDialFish>(chairId, id);
            }).SetDelay(4).SetLink(account.gameObject);
            int key1 = LTBY_Extend.Instance.RunAction(tween);
            actionKey.Add(key1);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (account == null) return;
            account.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (account == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem("LTBY_SpineDialFish", account);
            account = null;
        }
    }

    public class Firework : EffectClass
    {
        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            LTBY_Audio.Instance.Play(SoundConfig.SpineAwardDialFish);
            name = nameof(Firework);
            id = _id;
            chairId = _chairId;

            EffectParamData data = args.Length > 0 ? (EffectParamData) args[0] : new EffectParamData();

            effect = effect!=null
                ? effect
                : LTBY_PoolManager.Instance.GetUiItem("LTBY_FireworkEffect", LTBY_EffectManager.Instance.UiLayer);
            effect.gameObject.SetActive(true);
            effect.position = data.pos;
            float _scale = data.scale != 0 ? data.scale : 1;
            effect.localScale = new Vector3(_scale, _scale, _scale);

            timerKey = new List<int>();
            int key = LTBY_Extend.Instance.DelayRun(data.delay == 0 ? 5 : data.delay,
                ()=> { LTBY_EffectManager.Instance.DestroyEffect<Firework>(chairId, id); });
            timerKey.Add(key);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (effect == null) return;
            effect.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (effect == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem("LTBY_FireworkEffect", effect);
            effect = null;
        }
    }

    public class PandaDance : EffectClass
    {
        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            LTBY_Audio.Instance.Play(SoundConfig.SpineAwardDialFish);
            name = nameof(PandaDance);
            id = _id;
            chairId = _chairId;

            EffectParamData data = args.Length > 0 ? (EffectParamData) args[0] : new EffectParamData();

            effect = effect!=null
                ? effect
                : LTBY_PoolManager.Instance.GetUiItem("LTBY_PandaDanceEffect", LTBY_EffectManager.Instance.UiLayer);
            effect.gameObject.SetActive(true);
            effect.position = data.pos;
            float _scale = data.scale != 0 ? data.scale : 1;
            effect.localScale = new Vector3(_scale, _scale, _scale);

            timerKey = new List<int>();

            int key = LTBY_Extend.Instance.DelayRun(data.delay == 0 ? 3.2f : data.delay,
                ()=> { LTBY_EffectManager.Instance.DestroyEffect<PandaDance>(chairId, id); });
            timerKey.Add(key);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (effect == null) return;
            effect.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (effect == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem("LTBY_PandaDanceEffect", effect);
            effect = null;
        }
    }

    public class DragonBallEffect : EffectClass
    {
        int dragonOwnerId;
        bool isSelf;
        bool isMyDragon;
        private Dictionary<int, List<int>> MulConfig;
        private Transform ball_1;
        private Transform ball_2;
        private TextMeshProUGUI multiplier_1;
        private TextMeshProUGUI multiplier_2;
        private ParticleSystem zip_1;
        private ParticleSystem zip_2;
        private EffectParamData data;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, chairId, args);
            name = nameof(DragonBallEffect);
            id = _id;
            chairId = _chairId;
            dragonOwnerId = _chairId;
            isSelf = LTBY_GameView.GameInstance.IsSelf(chairId);
            isMyDragon = LTBY_GameView.GameInstance.chairId == _chairId;
            actionKey = new List<int>();
            timerKey = new List<int>();

            Vector3 pos = args.Length >= 1 ? (Vector3) args[0] : Vector3.zero;
            int num1 = args.Length >= 2 ? (int) args[1] : 0;
            int num2 = args.Length >= 3 ? (int) args[2] : 0;
            data = args.Length >= 4 ? (EffectParamData) args[3] : null;
            MulConfig = EffectConfig.ElectriBallMul;
            effect = effect!=null
                ? effect
                : LTBY_PoolManager.Instance.GetUiItem("LTBY_DragonBalls", LTBY_EffectManager.Instance.UiLayer);
            effect.gameObject.SetActive(true);

            ball_1 = ball_1!=null ? ball_1 : effect.FindChildDepth("ElectricBall1");
            ball_2 = ball_2!=null ? ball_2 : effect.FindChildDepth($"ElectricBall2");
            ball_1.gameObject.SetActive(true);
            ball_2.gameObject.SetActive(true);
            ball_1.localPosition = new Vector3(0, 0, 0);
            ball_2.localPosition = new Vector3(0, 0, 0);

            multiplier_1 = multiplier_1 != null ? multiplier_1 : ball_1.FindChildDepth<TextMeshProUGUI>("multiplier");
            multiplier_2 = multiplier_2!=null ? multiplier_2 : ball_2.FindChildDepth<TextMeshProUGUI>("multiplier");
            multiplier_1.gameObject.SetActive(false);
            multiplier_2.gameObject.SetActive(false);

            zip_1 = zip_1!=null ? zip_1 : ball_1.FindChildDepth<ParticleSystem>("ZipEffect");
            zip_2 = zip_2!=null ? zip_2 : ball_2.FindChildDepth<ParticleSystem>("ZipEffect");

            float timer = 0;
            float phaseOneTime = 1;
            ball_1.localScale = new Vector3(0.4f, 0.4f, 0.4f);
            ball_2.localScale = new Vector3(0.4f, 0.4f, 0.4f);
            if (isMyDragon)
            {
                effect.localPosition = new Vector3(0, 0, 1000);
                LTBY_Audio.Instance.Play(SoundConfig.ElectricDragonDie);
                timer += phaseOneTime;
                List<float> scaleArray = new List<float>() {40, 20, 60, 40, 60};
                LTBY_Audio.Instance.Play(SoundConfig.DragonBallFly);
                Sequence sequence = DOTween.Sequence();
                sequence.SetLink(ball_1.gameObject);
                sequence.Append(ball_1.DOLocalMove(new Vector3(-160, 0, 0), phaseOneTime));
                Sequence sequence1 = DOTween.Sequence();
                sequence.Insert(0, sequence1);
                sequence1.Append(DOTween.To(value =>
                {
                    if (ball_1 == null || ball_2 == null) return;
                    float t = value * 0.01f;
                    ball_1.localScale = new Vector3(t, t, t);
                    ball_2.localScale = new Vector3(t, t, t);
                }, scaleArray[0], scaleArray[1], 0.2f));
                sequence1.Append(DOTween.To(value =>
                {
                    if (ball_1 == null || ball_2 == null) return;
                    float t = value * 0.01f;
                    ball_1.localScale = new Vector3(t, t, t);
                    ball_2.localScale = new Vector3(t, t, t);
                }, scaleArray[1], scaleArray[2], 0.3f));
                sequence1.Append(DOTween.To(value =>
                {
                    if (ball_1 == null || ball_2 == null) return;
                    float t = value * 0.01f;
                    ball_1.localScale = new Vector3(t, t, t);
                    ball_2.localScale = new Vector3(t, t, t);
                }, scaleArray[2], scaleArray[3], 0.3f));
                sequence1.Append(DOTween.To(value =>
                {
                    if (ball_1 == null || ball_2 == null) return;
                    float t = value * 0.01f;
                    ball_1.localScale = new Vector3(t, t, t);
                    ball_2.localScale = new Vector3(t, t, t);
                }, scaleArray[3], scaleArray[4], 0.3f));
                int action_1 = LTBY_Extend.Instance.RunAction(sequence);
                actionKey.Add(action_1);

                Tween tween = ball_2.DOLocalMove(new Vector3(160, 0, 0), phaseOneTime).SetLink(ball_2.gameObject);
                int action_2 = LTBY_Extend.Instance.RunAction(tween);
                actionKey.Add(action_2);
                timer += 0.3f;
                int delayKey = LTBY_Extend.Instance.DelayRun(timer, ()=> { RollMultipliers(num1, num2); });
                timerKey.Add(delayKey);
            }
            else
            {
                effect.localPosition = new Vector3(0, 0, 1000);
                int otherId = dragonOwnerId;
                Vector3 effectPos = LTBY_GameView.GameInstance.GetBatteryWorldPos(otherId);
                Tween tween = ball_1.DOLocalMove(new Vector3(-60, 0, 0), phaseOneTime);
                int moveBallOne = LTBY_Extend.Instance.RunAction(tween);
                actionKey.Add(moveBallOne);
                Tween tween1 = ball_2.DOLocalMove(new Vector3(60, 0, 0), phaseOneTime);
                int moveBallTwo = LTBY_Extend.Instance.RunAction(tween1);
                actionKey.Add(moveBallTwo);
                float x = effectPos.x;
                float y = LTBY_GameView.GameInstance.CheckIsOtherSide(otherId)
                    ? effectPos.y - 4.5f
                    : effectPos.y + 4.5f;
                float z = effect.position.z;
                Tween tween2 = DOTween.To(value =>
                {
                    if (effect == null) return;
                    float t = value * 0.01f;
                    effect.position = new Vector3(x * t, y * t, z);
                }, 0, 100, phaseOneTime);
                int moveAll = LTBY_Extend.Instance.RunAction(tween2);
                actionKey.Add(moveAll);
                timer += phaseOneTime + 0.3f;
                int delayKey = LTBY_Extend.Instance.DelayRun(timer, ()=> { RollMultipliers(num1, num2); });
                timerKey.Add(delayKey);
            }
        }

        private void RollMultipliers(int num1 = 1, int num2 = 1)
        {
            // int mul_start_1 = 1;
            // int mul_start_2 = 1;
            int mul_end_1 = num1;
            int mul_end_2 = num2;
            TextMeshProUGUI mulText_1 = multiplier_1;
            TextMeshProUGUI mulText_2 = multiplier_2;
            mulText_1.text = $"x{mul_end_1}".ShowRichText();
            mulText_2.text = $"x{mul_end_2}".ShowRichText();

            // int index = 1;
            List<int> mulConfig_2 = MulConfig[2];
            // Transform ball_1 = this.ball_1;
            // Transform ball_2 = this.ball_2;
            float phaseTwoTime = 1.5f;
            float scaleTime = 0.3f;

            //缩放电球1文本，并播放小闪电
            Sequence sequence = DOTween.Sequence();
            sequence.Append(mulText_1.transform.DOScale(new Vector3(0, 0), 0).SetLink(mulText_1.gameObject));
            sequence.Append(mulText_1.transform.DOScale(new Vector3(1.7f, 1.7f), scaleTime).SetLink(mulText_1.gameObject));
            sequence.Append(mulText_1.transform.DOScale(new Vector3(1.2f, 1.2f), scaleTime).SetLink(mulText_1.gameObject).OnKill(() => { }));
            sequence.SetLink(mulText_1.gameObject);
            int textScaleKey_1 = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(textScaleKey_1);

            //缩放电球1
            List<float> scaleArray = isMyDragon ? new List<float>() {60, 80, 60} : new List<float>() {40, 60, 40};
            //球放大缩小比例
            Sequence sequence1 = DOTween.Sequence();
            sequence1.SetLink(ball_1.gameObject);
            sequence1.Append(DOTween.To(value =>
            {
                if (ball_1 == null) return;
                float t = value * 0.01f;
                ball_1.localScale = new Vector3(t, t, t);
                //this.ball_2.localScale = new Vector3(t, t, t);
            }, scaleArray[0], scaleArray[1], scaleTime).OnKill(() =>
            {
                mulText_1?.gameObject.SetActive(true);
                if (isMyDragon)
                {
                    LTBY_Audio.Instance.Play(SoundConfig.RollMultiple);
                    LTBYEntry.Instance.ShakeFishLayer(0.5f, 2);
                }

                zip_1.Play();
            }));
            sequence1.Insert(0, DOTween.To(value =>
            {
                if (ball_1 == null) return;
                float t = value * 0.01f;
                ball_1.localScale = new Vector3(t, t, t);
                //this.ball_2.localScale = new Vector3(t, t, t);
            }, scaleArray[1], scaleArray[2], scaleTime));
            sequence1.SetEase(Ease.InOutSine);
            int scaleBallUp = LTBY_Extend.Instance.RunAction(sequence1);
            actionKey.Add(scaleBallUp);

            //电球2等待0.3秒后再开始动作
            int delayKey = LTBY_Extend.Instance.DelayRun(scaleTime + 0.3f, ()=>
            {
                //缩放电球2大小，并播放小闪电
                Sequence seq = DOTween.Sequence();
                seq.SetLink(mulText_2.gameObject);
                seq.Append(mulText_2.transform.DOScale(new Vector3(0, 0), 0).SetLink(mulText_2.gameObject));
                seq.Append(mulText_2.transform.DOScale(new Vector3(1.7f, 1.7f), scaleTime).SetLink(mulText_2.gameObject));
                seq.Append(mulText_2.transform.DOScale(new Vector3(1.2f, 1.2f), scaleTime).SetLink(mulText_2.gameObject).OnKill(() => { }));
                int textScaleKey_2 = LTBY_Extend.Instance.RunAction(seq);
                actionKey.Add(textScaleKey_2);
                //缩放电球2，并在缩回去后震屏
                Sequence seq1 = DOTween.Sequence();
                seq1.SetLink(ball_2.gameObject);
                seq1.Append(DOTween.To(value =>
                {
                    if (ball_2 == null) return;
                    float t = value * 0.01f;
                    //this.ball_1.localScale = new Vector3(t, t, t);
                    ball_2.localScale = new Vector3(t, t, t);
                }, scaleArray[0], scaleArray[1], scaleTime).OnKill(() =>
                {
                    mulText_2?.gameObject.SetActive(true);
                    if (isMyDragon)
                    {
                        LTBY_Audio.Instance.Play(SoundConfig.RollMultiple);
                        LTBYEntry.Instance.ShakeFishLayer(0.5f, 2);
                    }

                    zip_2.Play();
                }));
                seq1.Insert(0, DOTween.To(value =>
                {
                    if (ball_2 == null) return;
                    float t = value * 0.01f;
                    //this.ball_1.localScale = new Vector3(t, t, t);
                    ball_2.localScale = new Vector3(t, t, t);
                }, scaleArray[1], scaleArray[2], scaleTime));
                seq1.SetEase(Ease.InOutSine);
                int _scaleBallUp = LTBY_Extend.Instance.RunAction(seq1);
                actionKey.Add(_scaleBallUp);
            });
            timerKey.Add(delayKey);
            //等待所有动作完成，进入融合阶段
            int _delayKey = LTBY_Extend.Instance.DelayRun(phaseTwoTime, ()=> { Fusion(mul_end_1 * mul_end_2); });
            timerKey.Add(_delayKey);
        }

        private void Fusion(int product)
        {
            TextMeshProUGUI mulText_1 = multiplier_1;
            float fusionTime = 0.6f;
            float hoverShakingTime = 0.4f;
            // float smashBackTime = 0.8f;
            float timer = 0;
            // Transform ball_1 = this.ball_1;
            // Transform ball_2 = this.ball_2;
            if (isMyDragon)
            {
                LTBY_Audio.Instance.Play(SoundConfig.DragonBallFly);
            }

            //移动电球2到中心并隐藏
            Tween tween = ball_2.DOLocalMove(new Vector2(0, 0), fusionTime)
                .OnKill(() => { ball_2?.gameObject.SetActive(false); }).SetLink(ball_2.gameObject);
            int moveBallTwoKey = LTBY_Extend.Instance.RunAction(tween);
            actionKey.Add(moveBallTwoKey);

            //移动电球1到中心并进行融合
            List<int> scaleArray = isMyDragon ? new List<int>() {60, 100, 80} : new List<int>() {40, 60, 40};
            Sequence sequence = DOTween.Sequence();
            sequence.SetLink(ball_1.gameObject);
            sequence.Append(ball_1.DOLocalMove(new Vector2(0, 0), fusionTime).OnKill(() =>
            {
                multiplier_1.text = $"x{product}".ShowRichText();
                if (isMyDragon)
                {
                    LTBY_Audio.Instance.Play(SoundConfig.RollMultiple);
                    LTBYEntry.Instance.ShakeFishLayer(0.5f, 2);
                }
            }));
            Sequence sequence1 = DOTween.Sequence();
            sequence.Append(sequence1);
            sequence1.SetLink(ball_1.gameObject);
            sequence1.Append(DOTween.To(value =>
            {
                if (ball_1 == null) return;
                float t = value * 0.01f;
                ball_1.localScale = new Vector3(t, t, t);
            }, scaleArray[0], scaleArray[1], fusionTime / 2));

            sequence1.Insert(0, ball_1.DOShakePosition(fusionTime / 2, 50, 100, 100, false));
            sequence.Append(DOTween.To(value =>
            {
                if (ball_1 == null) return;
                float t = value * 0.01f;
                ball_1.localScale = new Vector3(t, t, t);
            }, scaleArray[1], scaleArray[2], fusionTime / 2));

            int moveBallOneKey = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(moveBallOneKey);


            timer += fusionTime;

            //融合之后电球1进行震动并缩放
            int delayTimerKey = LTBY_Extend.Instance.DelayRun(timer, ()=>
            {
                Sequence _seq = DOTween.Sequence();
                _seq.SetLink(mulText_1.gameObject);
                _seq.Append(mulText_1.transform.DOScale(new Vector2(1.7f, 1.7f), 0.3f).SetLink(mulText_1.gameObject));
                _seq.Append(mulText_1.transform.DOScale(new Vector2(1.2f, 1.2f), 0.1f).SetLink(mulText_1.gameObject).OnKill(() =>
                {
                    if (!isMyDragon) return;
                    Tween tween1 = effect.DOShakePosition(hoverShakingTime, 50, 100, 100, false);
                    tween1.SetLink(effect.gameObject);
                    int shakeActionKey = LTBY_Extend.Instance.RunAction(tween1);
                    actionKey.Add(shakeActionKey);
                }));
                int scaleTextKey = LTBY_Extend.Instance.RunAction(_seq);
                actionKey.Add(scaleTextKey);
            });
            timerKey.Add(delayTimerKey);


            timer += hoverShakingTime;
            int delayTimerKey1 = LTBY_Extend.Instance.DelayRun(timer, ()=>
            {
                ball_2.localPosition = new Vector3(0, 0, 0);
                if (isMyDragon)
                {
                    LTBYEntry.Instance.ShakeFishLayer(0.8f, 3);
                }

                zip_1.Play();
                // LTBY_BulletManager.Instance.CreateBulletDragonBall(isMyDragon ? chairId : dragonOwnerId,
                //     product);

                OnFinish();
            });
            timerKey.Add(delayTimerKey1);

            //int nextPhaseTimer = LTBY_Extend.Instance.DelayRun(timer, delegate () { });
            //this.timerKey.Add(nextPhaseTimer);
        }

        private void OnFinish(long _score = 0, int multiplier = 0)
        {
            float _scale = isMyDragon ? 80 : 40;
            int delayKey = LTBY_Extend.Instance.DelayRun(0.6f, ()=>
            {
                Tween tween = DOTween.To(value =>
                {
                    if (ball_1 == null) return;
                    float t = value * 0.01f;
                    ball_1.localScale = new Vector3(t, t, t);
                }, _scale, 0, 0.8f).SetEase(Ease.InBack).OnKill(() =>
                {
                    DebugHelper.LogError($"销毁龙珠");
                    LTBY_EffectManager.Instance.DestroyDragonBallEffect(chairId);
                    data?.func?.Invoke();
                }).SetLink(ball_1.gameObject);
                int scaleOutKey = LTBY_Extend.Instance.RunAction(tween);
                actionKey.Add(scaleOutKey);
            });
            timerKey.Add(delayKey);
        }

        public override void OnStored()
        {
            base.OnStored();
            
            if (effect == null) return;
            effect.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (effect == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem("LTBY_DragonBalls", effect);
            effect = null;
        }
    }

    public class ElectricDragonSpineAward : EffectClass
    {
        private int multiple = -1;
        private TextMeshProUGUI multipleText;
        private bool isSelf;
        private Transform effect1;
        private Transform effect2;
        private Transform numNode;
        private float numScale;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(ElectricDragonSpineAward);
            id = _id;
            chairId = _chairId;
            score = 0;
            multiple = args.Length > 0 ? (int) args[0] : 0;
            actionKey = new List<int>();
            timerKey = new List<int>();

            if (!LTBY_GameView.GameInstance.IsPlayerInRoom(_chairId))
            {
                LTBY_DataReport.Instance.ReportElectricInBackground(_chairId);
                return;
            }

            account = account != null
                ? account
                : LTBY_PoolManager.Instance.GetUiItem("LTBY_ElectricDragonSpineAward",
                    LTBY_EffectManager.Instance.UiLayer);
            account.gameObject.SetActive(true);

            skeleton = skeleton!=null ? skeleton : account.FindChildDepth<SkeletonGraphic>("Skeleton");
            skeleton.AnimationState.SetAnimation(0, "stand", false);

            multipleText = multipleText!=null ? multipleText : account.FindChildDepth<TextMeshProUGUI>("Multiple");
            if (args.Length > 0)
            {
                multipleText.gameObject.SetActive(true);
                multipleText.text = $"x{multiple}".ShowRichText();
            }
            else
            {
                multipleText.gameObject.SetActive(false);
            }

            if (LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                isSelf = true;
                account.localScale = new Vector3(1.1f, 1.1f, 1.1f);
                account.position = new Vector3(0, 0, 0);
                effect1 = account.FindChildDepth("Effect1_1");
                effect2 = account.FindChildDepth("Effect1_2");
            }
            else
            {
                isSelf = false;
                account.localScale = new Vector3(0.7f, 0.7f, 0.7f);
                account.position = LTBY_GameView.GameInstance.GetEffectWorldPos(chairId);
                effect1 = account.FindChildDepth("Effect2_1");
                effect2 = account.FindChildDepth("Effect2_2");
            }

            effect1.gameObject.SetActive(false);
            effect2.gameObject.SetActive(false);
            numNode = numNode!=null ? numNode : account.FindChildDepth("Num");
            numNode.gameObject.SetActive(true);
            numPosition = numNode.position;
            num = num!=null ? num : numNode.GetILComponent<NumberRoller>();
            num = num!=null ? num : numNode.AddILComponent<NumberRoller>();
            num.Init();
            num.RollFromTo(0, 0, 0.1f);
            numScale = 0.65f;
            int delay = LTBY_Extend.Instance.DelayRun(1,
                ()=> { skeleton?.AnimationState.SetAnimation(0, "stand1", true); });
            timerKey.Add(delay);
        }

        public override void AddScore(long _score, float roll = 0)
        {
            base.AddScore(_score, roll);
            //DebugHelper.LogError($"雷皇龙加分:{score}    effectManager:3424");
            numNode.transform.gameObject.SetActive(true);
            score += _score;

            num.RollTo(score, 0.7f);
            //this.num.text = this.score.ToString();
            Sequence sequence = DOTween.Sequence();
            sequence.Append(num.transform.DOScale(new Vector2(numScale + 0.3f, numScale + 0.3f), 0.1f).SetLink(num.gameObject));
            sequence.Append(num.transform.DOScale(new Vector2(numScale, numScale), 0.1f).SetLink(num.gameObject));
            sequence.SetLink(num.gameObject);
            int key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);
        }

        public override void OnSettle()
        {
            base.OnSettle();
            bool _isSelf = LTBY_GameView.GameInstance.IsSelf(chairId);

            //只有当播放自己特效的时候 effect2的爆金币特效被一亿金币特效特换
            bool showEffect2 = (!_isSelf) || (!LTBY_EffectManager.Instance.CheckCanUseHundredMillion(score));
            effect2.gameObject.SetActive(showEffect2);

            int key = LTBY_Extend.Instance.DelayRun(1.2f,  ()=>
            {
                effect1?.gameObject.SetActive(true);
                if (score < EffectConfig.UseFireworkScore) return;
                EffectParamData _data = new EffectParamData()
                {
                    chairId = chairId,
                    pos = isSelf ? Vector3.zero : LTBY_GameView.GameInstance.GetEffectWorldPos(chairId),
                    scale = isSelf ? 1 : 0.5f
                };
                LTBY_EffectManager.Instance.CreateBoostScoreBoardEffects(score, _data);
            });
            timerKey.Add(key);

            if (isSelf)
            {
                LTBY_Audio.Instance.Play(SoundConfig.SpineAward3);
                LTBYEntry.Instance.ShakeFishLayer(4);
            }

            int key1 = LTBY_Extend.Instance.DelayRun(5.4f, ()=>
            {
                if (isSelf)
                {
                    Tween tween = account.DOScale(new Vector2(0, 0), 0.6f).SetEase(Ease.InBack).SetDelay(0.2f)
                        .OnKill(() =>
                        {
                            LTBY_GameView.GameInstance.CreateAddUserScoreItem(chairId, score);
                            LTBY_GameView.GameInstance.AddScore(chairId, score);
                            LTBY_EffectManager.Instance.DestroyElectricDragonSpineAward(chairId);
                            LTBY_DataReport.Instance.Get("雷皇龙", score);
                            LTBY_DataReport.Instance.ReportElectricDragonAddScore(score, multiple,
                                chairId);
                        }).SetLink(account.gameObject);
                    int _key = LTBY_Extend.Instance.RunAction(tween);
                    actionKey.Add(_key);
                }
                else
                {
                    float baseX = account.position.x;
                    float baseY = account.position.y;
                    Vector3 aimPos = LTBY_GameView.GameInstance.GetCoinWorldPos(chairId);
                    float aimX = aimPos.x;
                    float aimY = aimPos.y;

                    Tween tween = DOTween.To(value =>
                    {
                        if (account == null) return;
                        float t = value * 0.01f;
                        account.position = new Vector3(baseX + (aimX - baseX) * t, baseY + (aimY - baseY) * t, 0);
                        float _scale = (1 - t) * 0.7f;
                        account.localScale = new Vector3(_scale, _scale, _scale);
                    }, 0, 100, 0.3f).SetEase(Ease.InBack).OnKill(() =>
                    {
                        LTBY_GameView.GameInstance.CreateAddUserScoreItem(chairId, score);
                        LTBY_EffectManager.Instance.DestroyElectricDragonSpineAward(chairId);
                    }).SetLink(account.gameObject);
                    int _key = LTBY_Extend.Instance.RunAction(tween);
                    actionKey.Add(_key);
                }
            });
            timerKey.Add(key1);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (skeleton != null)
            {
                skeleton.AnimationState.ClearTracks();
            }

            if (account != null)
            {
                account.gameObject.SetActive(false);
            }
        }

        public override void OnDestroy()
        {
            if (LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                //LTBY_DataReport.Instance.ReportDestroyElectricDragon(debug.traceback())
            }

            base.OnDestroy();
            if (account == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem("LTBY_ElectricDragonSpineAward", account);
            account = null;
        }
    }

    public class DoubleDragonEffect : EffectClass
    {
        private float playTime;
        private Animator animator_1;
        private Animator animator_2;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(DoubleDragonEffect);
            id = _id;
            chairId = _chairId;
            timerKey = new List<int>();
            effect = effect!=null
                ? effect
                : LTBY_PoolManager.Instance.GetGameItem("LTBY_DoubleDragonEffect",
                    LTBY_EffectManager.Instance.FishLayer);
            effect.gameObject.SetActive(true);
            effect.localPosition = new Vector3(0, 0, 0);
            playTime = 10;
            animator_1 = animator_1!=null ? animator_1 : effect.FindChildDepth<Animator>("model");
            animator_2 = animator_2!=null ? animator_2 : effect.FindChildDepth<Animator>("model2");

            animator_1.SetTrigger($"move");
            animator_2.SetTrigger($"move");

            int key = LTBY_Extend.Instance.DelayRun(playTime,
                ()=> { LTBY_EffectManager.Instance.DestroyEffect<DoubleDragonEffect>(chairId, id); });
            timerKey.Add(key);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (effect == null) return;
            effect.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (effect == null) return;
            LTBY_PoolManager.Instance.RemoveGameItem("LTBY_DoubleDragonEffect", effect);
            effect = null;
        }
    }

    public class HundredMillionMoney : EffectClass
    {
        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(HundredMillionMoney);
            id = _id;
            chairId = _chairId;

            effect = effect!=null
                ? effect
                : LTBY_PoolManager.Instance.GetUiItem("LTBY_yifenbaojiang", LTBY_EffectManager.Instance.UiLayer);
            effect.gameObject.SetActive(true);
            effect.position = new Vector3(0, 0, 0);
            float _scale = 1;
            effect.localScale = new Vector3(_scale, _scale, _scale);
            bool isTop = args.Length > 0 && (bool) args[0];
            //设置层级
            string sortLayer = isTop ? "sort10" : "Default";
            int sortOrder = isTop ? 2 : 0;
            ParticleSystemRenderer[] particleComps = effect.GetComponentsInChildren<ParticleSystemRenderer>();
            if (particleComps != null)
            {
                for (int i = 0; i < particleComps.Length; i++)
                {
                    particleComps[i].sortingLayerName = sortLayer;
                    particleComps[i].sortingOrder = sortOrder;
                }
            }

            timerKey = new List<int>();

            LTBY_Audio.Instance.Play(SoundConfig.HundredMillion);

            int key = LTBY_Extend.Instance.DelayRun(6,
                ()=> { LTBY_EffectManager.Instance.DestroyEffect<HundredMillionMoney>(chairId, id); });
            timerKey.Add(key);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (effect == null) return;
            effect.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (effect == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem("LTBY_yifenbaojiang", effect);
            effect = null;
        }
    }

    public class TreasureBowlEffect2 : EffectClass
    {
        SCTreasureFishCatched data;
        private string effectName;
        private Queue<float> totalNums;
        private bool isSelf;
        private Transform effect1;
        private Transform effect2;
        private Transform numNode;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(TreasureBowlEffect2);
            id = _id;
            chairId = _chairId;
            data = args.Length > 0 ? (SCTreasureFishCatched) args[0] : new SCTreasureFishCatched();
            score = data.earn;
            int status = (int) args[1];
            effectName = $"LTBY_JBPSpineAward{status}";

            actionKey = new List<int>();
            timerKey = new List<int>();

            totalNums = new Queue<float>();
            float value1 = data.fish_value * data.ratio * data.multiple;
            totalNums.Enqueue(value1);
            //float value2 = data.accum_money * data.multiple;
            float value2 = data.accum_money;
            if (value2 > 0)
            {
                totalNums.Enqueue(value2 + value1);
            }

            effect = effect != null ? effect : LTBY_PoolManager.Instance.GetUiItem(effectName, LTBY_EffectManager.Instance.UiLayer);
            effect.gameObject.SetActive(true);
            skeleton = skeleton != null ? skeleton : effect.FindChildDepth<SkeletonGraphic>("Skeleton");
            skeleton.AnimationState.SetAnimation(0, "stand01", false);
            int key = LTBY_Extend.Instance.DelayRun(1.4f,
                ()=> { skeleton?.AnimationState.SetAnimation(1, "stand02", true); });
            timerKey.Add(key);

            if (LTBY_GameView.GameInstance.IsSelf(chairId))
            {
                isSelf = true;
                //这里由于三个阶段的spine大小不一样 这里处理一下
                if (status != 3)
                {
                    effect.localScale = new Vector3(0.85f, 0.85f, 0.85f);
                }
                else
                {
                    effect.localScale = new Vector3(1, 1, 1);
                }

                effect.position = new Vector3(0, 0, -40);
                effect1 = effect.FindChildDepth("Effect1_1");
                effect2 = effect.FindChildDepth("Effect1_2");
                LTBY_Audio.Instance.Play(SoundConfig.JBPSettleVoice);
            }
            else
            {
                isSelf = false;
                effect.localScale = new Vector3(0.7f, 0.7f, 0.7f);
                Vector3 pos = LTBY_GameView.GameInstance.GetEffectWorldPos(chairId);
                if (!LTBY_GameView.GameInstance.CheckIsOtherSide(chairId))
                {
                    pos = new Vector3(pos.x, pos.y + 1, -40);
                }
                else
                {
                    pos = new Vector3(pos.x, pos.y - 1, -40);
                }

                effect.position = pos;
                effect1 = effect.FindChildDepth("Effect2_1");
                effect2 = effect.FindChildDepth("Effect2_2");
            }


            numNode = effect.FindChildDepth("Num");
            numNode.gameObject.SetActive(true);
            num = num!=null ? num : numNode.GetILComponent<NumberRoller>();
            num = num!=null ? num : numNode.AddILComponent<NumberRoller>();
            num.Init();
            num.text = "0";

            RollNum();
        }

        private void RollNum()
        {
            float delay = 0;
            float numScale = 0.65f;
            int count = totalNums.Count;
            for (int i = 0; i < count; i++)
            {
                int index = i;
                int curShowNum = (int) totalNums.Dequeue();
                Sequence sequence = DOTween.Sequence();
                sequence.SetLink(numNode.gameObject);
                sequence.Append(LTBY_Extend.DelayRun(delay + 1).OnComplete(() =>
                {
                    numNode?.gameObject.SetActive(true);
                    num?.RollTo(curShowNum, 1);
                }));

                sequence.Append(LTBY_Extend.DelayRun(0.9f).OnComplete(() =>
                {
                    if (LTBY_GameView.GameInstance.IsSelf(chairId))
                    {
                        LTBY_Audio.Instance.Play(SoundConfig.DragonEffect2);
                    }

                    //最后一次加分的时候 播放烟花
                    if (index == count - 1)
                    {
                        //当达到一亿分的时候 隐藏这个爆金币的特效，用一亿分的特效代替
                        if (!(isSelf && LTBY_EffectManager.Instance.CheckCanUseHundredMillion(score)))
                        {
                            effect2?.gameObject.SetActive(false);
                            effect2?.gameObject.SetActive(true);
                        }


                        if (score < EffectConfig.UseFireworkScore) return;
                        EffectParamData _data = new EffectParamData()
                        {
                            chairId = chairId,
                            pos = isSelf ? Vector3.zero : LTBY_GameView.GameInstance.GetEffectWorldPos(chairId),
                            scale = isSelf ? 0.7f : 0.4f
                        };
                        LTBY_EffectManager.Instance.CreateBoostScoreBoardEffects(score, _data);
                    }
                    else
                    {
                        effect2?.gameObject.SetActive(false);
                        effect2?.gameObject.SetActive(true);
                    }
                }));
                sequence.Append(LTBY_Extend.DelayRun(0.2f).OnComplete(() =>
                {
                    effect1?.gameObject.SetActive(false);
                    effect1?.gameObject.SetActive(true);
                }));
                sequence.Append(numNode.DOScale(new Vector2(numScale * 1.5f, numScale * 1.5f), 0.04f).SetLink(numNode.gameObject));
                sequence.Append(numNode.DOScale(new Vector2(numScale, numScale), 0.7f).SetLink(numNode.gameObject).SetEase(Ease.OutSine));
                int key = LTBY_Extend.Instance.RunAction(sequence);
                actionKey.Add(key);
                delay += 2;
            }

            if (data.earn >= EffectConfig.UseFireworkScore)
            {
                delay += 2;
            }

            if (isSelf)
            {
                Sequence sequence = DOTween.Sequence();
                sequence.SetLink(effect.gameObject);
                sequence.Append(LTBY_Extend.DelayRun(delay + 2).OnComplete(() =>
                {
                    effect1?.gameObject.SetActive(false);
                    effect2?.gameObject.SetActive(false);
                }));
                sequence.Append(effect.DOScale(new Vector2(0, 0), 0.4f).SetLink(effect.gameObject).SetEase(Ease.InBack).SetDelay(0.2f));
                sequence.OnKill(() =>
                {
                    LTBY_GameView.GameInstance.CreateAddUserScoreItem(chairId, score);
                    LTBY_GameView.GameInstance.AddScore(chairId, score);
                    LTBY_EffectManager.Instance.DestroyEffect<TreasureBowlEffect2>(chairId, id);
                });
                int key = LTBY_Extend.Instance.RunAction(sequence);
                actionKey.Add(key);
            }
            else
            {
                var position = effect.position;
                float baseX = position.x;
                float baseY = position.y;
                Vector3 aimPos = LTBY_GameView.GameInstance.GetCoinWorldPos(chairId);
                float aimX = aimPos.x;
                float aimY = aimPos.y;

                Tween tween = DOTween.To(value =>
                {
                    if (effect == null) return;
                    float t = value * 0.01f;
                    effect.position = new Vector3(baseX + (aimX - baseX) * t, baseY + (aimY - baseY) * t, 0);
                    float _scale = (1 - t) * 0.7f;
                    effect.localScale = new Vector3(_scale, _scale, _scale);
                }, 0, 100, 0.3f).SetEase(Ease.InBack).OnKill(() =>
                {
                    LTBY_GameView.GameInstance.CreateAddUserScoreItem(chairId, score);
                    LTBY_EffectManager.Instance.DestroyEffect<TreasureBowlEffect2>(chairId, id);
                }).SetDelay(delay + 2).SetLink(effect.gameObject);
                int key = LTBY_Extend.Instance.RunAction(tween);
                actionKey.Add(key);
            }
        }

        public override void OnStored()
        {
            base.OnStored();
            skeleton?.AnimationState.ClearTracks();
            if (effect == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem(effectName, effect);
            effect = null;
        }
    }

    public class TreasureBowlEffect1 : EffectClass
    {
        SCTreasureFishCatched data;
        private bool isSelf;
        private Transform topEffect;
        private Transform TopRoot;
        private Transform BottomRoot;
        private Text bottomText;
        private Text TopMul;
        private Text BottomMul;
        private float targetScale;

        private Transform BottomEffect { get; set; }

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(TreasureBowlEffect1);
            id = _id;
            chairId = _chairId;
            data = args.Length > 0 ? (SCTreasureFishCatched) args[0] : new SCTreasureFishCatched();
            Vector3 pos = (Vector3) args[1];
            isSelf = LTBY_GameView.GameInstance.IsSelf(chairId);

            actionKey = new List<int>();
            timerKey = new List<int>();

            effect = effect!=null
                ? effect
                : LTBY_PoolManager.Instance.GetUiItem("LTBY_JBPSpineAward4", LTBY_EffectManager.Instance.UiLayer);
            effect.gameObject.SetActive(true);

            topEffect = topEffect!=null ? topEffect : effect.FindChildDepth("TopEffect");
            BottomEffect = BottomEffect!=null ? BottomEffect : effect.FindChildDepth("BottomEffect");

            skeleton = skeleton!=null ? skeleton : effect.FindChildDepth<SkeletonGraphic>("Skeleton");
            TopRoot = TopRoot != null ? TopRoot : effect.FindChildDepth("Top");
            TopRoot.gameObject.SetActive(false);
            TopRoot.FindChildDepth<Text>("topText").text = $"+{data.accum_money}";

            BottomRoot = BottomRoot!=null ? BottomRoot : effect.FindChildDepth("Bottom");
            BottomRoot.gameObject.SetActive(false);
            bottomText = bottomText!=null ? bottomText : BottomRoot.FindChildDepth<Text>("bottomText");
            bottomText.text = $"x{data.fish_value}";

            TopMul = TopMul!=null ? TopMul : TopRoot.FindChildDepth<Text>("topText/TopMul");
            BottomMul = BottomMul!=null ? BottomMul : BottomRoot.FindChildDepth<Text>("BottomMul");
            string multipleText = data.display_multiple ? $"x{data.multiple.ShortNumber()}" : "";
            TopMul.text = multipleText;
            BottomMul.text = multipleText;
            Vector3 startPos = LTBYEntry.Instance.GetUIPosFromWorld(pos);
            effect.position = startPos;
            targetScale = 1;

            Vector3 targetPos = new Vector3(0, -0.8f, 0);
            if (!isSelf)
            {
                targetPos = LTBY_GameView.GameInstance.GetEffectWorldPos(chairId);
                if (!LTBY_GameView.GameInstance.CheckIsOtherSide(chairId))
                {
                    targetPos = new Vector3(targetPos.x, targetPos.y + 0.2f, targetPos.z);
                }
                else
                {
                    targetPos = new Vector3(targetPos.x, targetPos.y - 0.2f, targetPos.z);
                }

                targetScale = 0.5f;
            }

            effect.localScale = new Vector3(targetScale, targetScale, targetScale);

            if (skeleton != null)
            {
                skeleton.AnimationState.ClearTracks();
            }

            skeleton?.AnimationState.SetAnimation(0, "stand01", false);
            int key = LTBY_Extend.Instance.DelayRun(1.4f,
                ()=> { skeleton?.AnimationState.SetAnimation(0, "stand02", true); });
            timerKey.Add(key);

            float startX = startPos.x;
            float startY = startPos.y;
            float aimX = targetPos.x;
            float aimY = targetPos.y;

            float startTime = 1.4f;
            float numScale = 1f;
            Tween tween = DOTween.To(value =>
            {
                if (effect == null) return;
                float t = value * 0.001f;
                effect.position = new Vector3(startX + t * (aimX - startX), startY + t * (aimY - startY), -40);
            }, 0, 1000, 1.2f).SetEase(Ease.OutSine).SetDelay(startTime);
            key = LTBY_Extend.Instance.RunAction(tween);
            actionKey.Add(key);

            startTime += 1;

            if (isSelf)
            {
                key = LTBY_Extend.Instance.DelayRun(startTime, ()=>
                {
                    LTBY_Audio.Instance.Play(SoundConfig.JBPCoinDrop);
                    string EffectName = "Effect_Jubaopen_jinbidiaoluo";
                    float lifeTime = 6;
                    Vector3 position = Vector3.zero;
                    LTBY_EffectManager.Instance.CreateEffect<BaoJinBi>(0, EffectName, lifeTime, position);
                });
                timerKey.Add(key);
            }

            startTime += 0.4f;
            key = LTBY_Extend.Instance.DelayRun(startTime, ()=>
            {
                BottomRoot?.gameObject.SetActive(true);
                BottomEffect?.gameObject.SetActive(false);
                if (isSelf)
                {
                    LTBY_Audio.Instance.Play(SoundConfig.JBPFlashNum);
                }

                BottomEffect?.gameObject.SetActive(true);
            });
            timerKey.Add(key);
            Sequence sequence = DOTween.Sequence();
            sequence.SetLink(BottomRoot.gameObject);
            sequence.Append(BottomRoot.DOScale(new Vector2(numScale * 1.5f, numScale * 1.5f), 0.2f).SetLink(BottomRoot.gameObject));
            sequence.Append(BottomRoot.DOScale(new Vector2(numScale, numScale), 0.7f).SetLink(BottomRoot.gameObject).SetEase(Ease.OutSine));
            sequence.SetDelay(startTime);
            key = LTBY_Extend.Instance.RunAction(sequence);
            actionKey.Add(key);

            startTime += 1.4f;

            key = LTBY_Extend.Instance.DelayRun(startTime, ()=>
            {
                TopRoot?.gameObject.SetActive(true);
                topEffect?.gameObject.SetActive(false);
                if (isSelf)
                {
                    LTBY_Audio.Instance.Play(SoundConfig.JBPFlashNum);
                }

                topEffect?.gameObject.SetActive(true);
            });
            timerKey.Add(key);

            Sequence sequence1 = DOTween.Sequence();
            sequence1.Append(TopRoot.DOScale(new Vector2(numScale * 1.5f, numScale * 1.5f), 0.2f).SetLink(TopRoot.gameObject));
            sequence1.Append(TopRoot.DOScale(new Vector2(numScale, numScale), 0.7f).SetLink(TopRoot.gameObject).SetEase(Ease.OutSine));
            sequence1.SetDelay(startTime).SetLink(TopRoot.gameObject);
            key = LTBY_Extend.Instance.RunAction(sequence1);
            actionKey.Add(key);

            startTime += 2;
            key = LTBY_Extend.Instance.DelayRun(startTime, ()=>
            {
                LTBY_EffectManager.Instance.DestroyEffect<TreasureBowlEffect1>(_chairId, _id);
                LTBY_EffectManager.Instance.CreateEffect<TreasureBowlEffect2>(_chairId, data, 3);
            });
            timerKey.Add(key);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (effect == null) return;
            effect.gameObject.SetActive(false);
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
            if (effect == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem("LTBY_JBPSpineAward4", effect);
            effect = null;
        }
    }

    public class BaoJinBi : EffectClass
    {
        private string EffectName;
        private Action callBack;

        public override void OnCreate(int _id, int _chairId, params object[] args)
        {
            base.OnCreate(_id, _chairId, args);
            name = nameof(BaoJinBi);
            id = _id;
            chairId = _chairId;
            timerKey = new List<int>();
            EffectParamData data = args.Length > 0 ? (EffectParamData) args[0] : new EffectParamData();
            EffectName = data.EffectName;
            callBack = data.callBack;

            effect = effect != null ? effect : LTBY_PoolManager.Instance.GetUiItem(EffectName, LTBY_EffectManager.Instance.UiLayer);
            float _scale = data.scale;
            effect.localScale = Mathf.Abs(_scale) > 0 ? new Vector3(_scale, _scale, _scale) : Vector3.one;
            effect.position = data.position;
            Vector3 localPos = effect.localPosition;

            effect.localPosition = new Vector3(localPos.x, localPos.y, 0);
            effect.gameObject.SetActive(true);

            int key = LTBY_Extend.Instance.DelayRun(data.lifeTime,
                ()=> { LTBY_EffectManager.Instance.DestroyEffect<BaoJinBi>(_chairId, _id); });
            timerKey.Add(key);
        }

        public override void OnStored()
        {
            base.OnStored();
            if (effect == null) return;
            LTBY_PoolManager.Instance.RemoveUiItem(EffectName, effect);
            effect = null;
        }
    }
}