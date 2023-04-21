using DG.Tweening;
using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.LTBY
{
    public class ResData
    {
        public string name;
        public int num;
        public int maxNum;
        public Stack<Transform> item;
    }
    public class LTBY_PoolManager : SingletonNew<LTBY_PoolManager>
    {
        private Transform GameParent;
        private Transform UiParent;
        private Dictionary<string, ResData> GameItemList = new Dictionary<string, ResData>();
        private Dictionary<string, ResData> UiItemList = new Dictionary<string, ResData>();
        private bool Finish;
        private int PreLoadIndex;
        private string PreLoadFlag;
        private int UpdateKey;
        private bool DebugLog = false;
        private string DebugItem = "";
        /// <summary>
        /// 鱼的缓存池fishManger特殊处理
        /// </summary>
        private List<PoolData> GameLayerPreLoadItem = new List<PoolData>()
        {
            new PoolData(){name = "LTBY_LockOther",num = 1,maxNum = 1},
            new PoolData(){name = "LTBY_LockSelf",num = 1,maxNum = 1},
            new PoolData(){name = "LTBY_MissileLock",num = 2,maxNum = 2},
            new PoolData(){name = "LTBY_BulletDrill",num = 1,maxNum = 1},
            new PoolData(){name = "LTBY_DrillHitEffect",num = 1,maxNum = 5},
            new PoolData(){name = "LTBY_BulletElectric",num = 1,maxNum = 1},
            new PoolData(){name = "LTBY_BulletWaterSpout9",num = 1,maxNum = 4},
            new PoolData(){name = "LTBY_BulletWaterSpout10",num = 1,maxNum = 4},
            new PoolData(){name = "LTBY_Fishnet1",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_Fishnet2",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_Fishnet3",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_Fishnet4",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_Fishnet5",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_Fishnet6",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_Fishnet7",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_Fishnet8",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_Fishnet9",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_FishnetFree",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_FishnetDragonBall",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_BulletMissile",num = 1,maxNum = 1},
            new PoolData(){name = "LTBY_SummonAppear",num = 2,maxNum = 2},
            new PoolData(){name = "LTBY_Bullet1",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_Bullet2",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_Bullet3",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_Bullet4",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_Bullet5",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_Bullet6",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_Bullet7",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_Bullet8",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_BulletFree",num = 0,maxNum = 30},
            new PoolData(){name = "LTBY_BulletDragonBall",num = 1,maxNum = 1},
            new PoolData(){name = "LTBY_Light",num = 0,maxNum = 10},
            new PoolData(){name = "LTBY_LightBall",num = 0,maxNum = 10},
            new PoolData(){name = "LTBY_DoubleDragonEffect",num = 0,maxNum = 1},
            new PoolData(){name = "LTBY_AcedLink",num = 5,maxNum = 20},
        };
        private List<PoolData> UiLayerPreLoadItem = new List<PoolData>()
        {
            new PoolData(){name = "LTBY_ExplosionPoint1",num = 5,maxNum = 10},
            new PoolData(){name = "LTBY_ExplosionPoint2",num = 2,maxNum = 4},
            new PoolData(){name = "LTBY_ExplosionPoint3",num = 1,maxNum = 1},
            new PoolData(){name = "LTBY_CoinSelf",num = 10,maxNum = 30},
            new PoolData(){name = "LTBY_CoinOther",num = 0,maxNum = 60},
            new PoolData(){name = "LTBY_TextSelf",num = 15,maxNum = 15},
            new PoolData(){name = "LTBY_TextOther",num = 0,maxNum = 20},
            new PoolData(){name = "LTBY_TextNode",num = 2,maxNum = 4},
            new PoolData(){name = "LTBY_FishAppear",num = 1,maxNum = 1},
            new PoolData(){name = "LTBY_SpineAwardLevel1",num = 2,maxNum = 4},
            new PoolData(){name = "LTBY_SpineAwardLevel2",num = 2,maxNum = 4},
            new PoolData(){name = "LTBY_SpineAwardLevel3",num = 2,maxNum = 4},
            new PoolData(){name = "LTBY_SpineAwardLevel4",num = 1,maxNum = 1},
            new PoolData(){name = "LTBY_SpineAwardFullScreen",num = 1,maxNum = 1},
            new PoolData(){name = "LTBY_SpineLight",num = 1,maxNum = 1},
            new PoolData(){name = "LTBY_DrillSpineAward",num = 0,maxNum = 1},
            new PoolData(){name = "LTBY_ElectricSpineAward",num = 0,maxNum = 1},
            new PoolData(){name = "LTBY_MissileSpineAward",num = 0,maxNum = 1},
            new PoolData(){name = "LTBY_FreeBatterySpineAward",num = 0,maxNum = 1},
            new PoolData(){name = "LTBY_DragonDeadEffect",num = 0,maxNum = 1},
            new PoolData(){name = "LTBY_DragonSpineAward",num = 0,maxNum = 1},
            new PoolData(){name = "LTBY_Wheel",num = 5,maxNum = 10},
            new PoolData(){name = "LTBY_CoinOutburst",num = 1,maxNum = 1},
            new PoolData(){name = "LTBY_SelfAddScoreItem",num = 5,maxNum = 10},
            new PoolData(){name = "LTBY_OtherAddScoreItem",num = 0,maxNum = 10},
            new PoolData(){name = "LTBY_DialEffect",num = 1,maxNum = 1},
            new PoolData(){name = "LTBY_SpineDialFish",num = 1,maxNum = 1},
            new PoolData(){name = "LTBY_FireworkEffect",num = 0,maxNum = 1},
            new PoolData(){name = "LTBY_PandaDanceEffect",num = 0,maxNum = 1},
            new PoolData(){name = "LTBY_FreeBatteryFullScreenEffect",num = 0,maxNum = 1},
            new PoolData(){name = "LTBY_ElectricDragonSpineAward",num = 0,maxNum = 1},
            new PoolData(){name = "LTBY_DragonBalls",num = 0,maxNum = 1},
            new PoolData(){name = "LTBY_yifenbaojiang",num = 0,maxNum = 1},
            new PoolData(){name = "LTBY_TreasureBowlText",num = 0,maxNum = 1},
            new PoolData(){name = "LTBY_Jubaopen_baojinbi01",num = 1,maxNum = 2},
            new PoolData(){name = "LTBY_Jubaopen_baojinbi02",num = 1,maxNum = 2},
            new PoolData(){name = "LTBY_JBPSpineAward1",num = 1,maxNum = 2},
            new PoolData(){name = "LTBY_JBPSpineAward2",num = 1,maxNum = 2},
            new PoolData(){name = "LTBY_JBPSpineAward3",num = 1,maxNum = 1},
            new PoolData(){name = "LTBY_JBPSpineAward4",num = 1,maxNum = 1},
        };

        public override void Release()
        {
            base.Release();
            var getItemValues = GameItemList.GetDictionaryValues();
            for (int i = 0; i < getItemValues.Length; i++)
            {
                while (getItemValues[i].item.Count>0)
                {
                    LTBY_Extend.Destroy(getItemValues[i].item.Pop().gameObject);
                }
            }
            GameItemList.Clear();

            var uiItemValues = UiItemList.GetDictionaryValues();

            for (int i = 0; i < uiItemValues.Length; i++)
            {
                while (getItemValues[i].item.Count > 0)
                {
                    LTBY_Extend.Destroy(uiItemValues[i].item.Pop().gameObject);
                }
            }
            UiItemList.Clear();
        }
        public void PreLoad()
        {
            GameParent = LTBYEntry.Instance.GetGameLayer().FindChildDepth("GamePool");
            UiParent = LTBYEntry.Instance.GetUiLayer().FindChildDepth("UiPool");
            Finish = false;
            GameItemList.Clear();
            UiItemList.Clear();

            UpdateKey = LTBY_Extend.Instance.DelayRun(0.05f, Loading);
            PreLoadIndex = 1;
            PreLoadFlag = "Game";
        }

        private void Loading()
        {
            if (PreLoadFlag == "Game")
            {
                if (PreLoadIndex > GameLayerPreLoadItem.Count)
                {
                    if (DebugLog)
                    {
                        DebugHelper.LogError("Game预加载完成");
                    }
                    PreLoadFlag = "Ui";
                    PreLoadIndex = 1;
                }
                else
                {
                    PoolData data = GameLayerPreLoadItem[PreLoadIndex];
                    GameItemList.Add(data.name, new ResData() { maxNum = data.maxNum, item = new Stack<Transform>() });
                    for (int i = 0; i < data.num; i++)
                    {
                        Transform item = LTBY_Extend.Instance.LoadPrefab(data.name, GameParent);
                        item.localPosition = new Vector3(1000, 0, 0);
                        GameItemList[data.name].item.Push(item);
                    }
                    PreLoadIndex++;
                    if (!DebugLog) return;
                    if (string.IsNullOrEmpty(DebugItem))
                    {
                        if (data.name == DebugItem)
                        {
                            DebugHelper.LogError($"预加载GameLayer的对象:{data.name}数量:{data.num}");
                        }
                    }
                    else
                    {
                        DebugHelper.LogError($"预加载GameLayer的对象:{data.name}数量:{data.num}");
                    }
                }
            }
            else
            {
                if (PreLoadIndex > UiLayerPreLoadItem.Count)
                {
                    if (DebugLog)
                    {
                        DebugHelper.LogError("Ui预加载完成");
                    }
                    PreLoadFinish();
                }
                else
                {
                    PoolData data = UiLayerPreLoadItem[PreLoadIndex];
                    UiItemList.Add(data.name, new ResData() { maxNum = data.maxNum, item = new Stack<Transform>() });
                    for (int i = 0; i < data.num; i++)
                    {
                        Transform item = LTBY_Extend.Instance.LoadPrefab(data.name, UiParent);
                        item.localPosition = new Vector3(1000, 0, 0);
                        UiItemList[data.name].item.Push(item);
                    }
                    PreLoadIndex++;
                    if (!DebugLog) return;
                    if (string.IsNullOrEmpty(DebugItem))
                    {
                        if (data.name == DebugItem)
                        {
                            DebugHelper.LogError($"预加载UiLayer的对象:{data.name}数量:{data.num}");
                        }
                    }
                    else
                    {
                        DebugHelper.LogError($"预加载UiLayer的对象:{data.name}数量:{data.num}");
                    }
                }
            }
        }

        private void PreLoadFinish()
        {
            Finish = true;
            LTBY_Extend.Instance.StopAction(UpdateKey);
        }
        public bool IsFinish()
        {
            return Finish;
        }

        public Transform GetGameItem(string name, Transform parent)
        {
            if (!GameItemList.ContainsKey(name))
            {
                GameItemList.Add(name, new ResData() { maxNum = 0, item = new Stack<Transform>() });
                GameLayerPreLoadItem.Add(new PoolData() { name = name, num = 0, maxNum = 0 });
            }
            if (GameItemList[name].item.Count > 0)
            {
                Transform item = GameItemList[name].item.Pop();
                if (item.parent != parent)
                {
                    item.SetParent(parent);
                }
                if (!item.gameObject.activeSelf)
                {
                    item.gameObject.SetActive(true);
                }

                if (!DebugLog) return item;
                if (!string.IsNullOrEmpty(DebugItem))
                {
                    if (name == DebugItem)
                    {
                        DebugHelper.LogError($"从缓存池{name}里面拿出一个，当前剩余{GameItemList[name].item.Count}");
                    }
                }
                else
                {
                    DebugHelper.LogError($"从缓存池{name}里面拿出一个，当前剩余{GameItemList[name].item.Count}");
                }
                return item;
            }
            else
            {
                if (!DebugLog) return LTBY_Extend.Instance.LoadPrefab(name, parent);
                if (!string.IsNullOrEmpty(DebugItem))
                {
                    if (name == DebugItem)
                    {
                        DebugHelper.LogError($"缓存池{name}里数量不够额外创建1个");
                    }
                }
                else
                {
                    DebugHelper.LogError($"缓存池{name}里数量不够额外创建1个");
                }
                return LTBY_Extend.Instance.LoadPrefab(name, parent);
            }
        }

        public void RemoveGameItem(string name, Transform item)
        {
            LTBY_Extend.Destroy(item.gameObject);
            return;
            if (!GameItemList.ContainsKey(name))
            {
                DebugHelper.LogError($"没有{name}的缓存池");
                GameItemList.Add(name, new ResData() { maxNum = 0, item = new Stack<Transform>() });
            }


            if (GameItemList[name].item.Count >= GameItemList[name].maxNum)
            {
                if (DebugLog)
                {
                    DebugHelper.LogError($"缓存池{name}的数量为{GameItemList[name].item.Count} 已经满了，直接删除");
                }
                LTBY_Extend.Destroy(item.gameObject);
            }
            else
            {
                //DebugHelper.LogError($"RemoveGameItem:{item.name}");
                item.parent = GameParent;
                item.localPosition = new Vector3(1000, 0, 0);
                GameItemList[name].item.Push(item);
                if (!DebugLog) return;
                if (!string.IsNullOrEmpty(DebugItem))
                {
                    if (name == DebugItem)
                    {
                        DebugHelper.LogError($"回收{ name} 的对象,回收之后剩余:{GameItemList[name].item.Count}");
                    }
                }
                else
                {
                    DebugHelper.LogError($"回收{ name} 的对象,回收之后剩余:{GameItemList[name].item.Count}");
                }
            }
        }

        public Transform GetUiItem(string name, Transform parent)
        {
            if (!UiItemList.ContainsKey(name))
            {
                UiItemList.Add(name, new ResData() { maxNum = 0, item = new Stack<Transform>() });
                UiLayerPreLoadItem.Add(new PoolData() { name = name, num = 0, maxNum = 0 });
            }
            if (UiItemList[name].item.Count > 0)
            {
                Transform item = UiItemList[name].item.Pop();
                if (item.parent != parent)
                {
                    item.SetParent(parent, false);
                }
                if (!item.gameObject.activeSelf)
                {
                    item.gameObject.SetActive(true);
                }
                if (DebugLog)
                {
                    if (string.IsNullOrEmpty(DebugItem)) return item;
                    if (name == DebugItem)
                    {
                        DebugHelper.LogError($"从缓存池{name}里面拿出一个，当前剩余{UiItemList[name].item.Count}");
                    }
                }
                else
                {
                    DebugHelper.LogError($"从缓存池{name}里面拿出一个，当前剩余{UiItemList[name].item.Count}");
                }
                return item;
            }
            return LTBY_Extend.Instance.LoadPrefab(name, parent);
        }
        public void RemoveUiItem(string name, Transform item)
        {
            if (!UiItemList.ContainsKey(name))
            {
                DebugHelper.LogError($"没有{name}的缓存池，检查代码");
                UiItemList.Add(name, new ResData() { maxNum = 0, item = new Stack<Transform>() });
            }

            if (item == null) return;
            if (UiItemList[name].item.Count >= UiItemList[name].maxNum)
            {
                if (DebugLog)
                {
                    DebugHelper.LogError($"缓存池{name}的数量为{UiItemList[name].item.Count} 已经满了，直接删除");
                }
                LTBY_Extend.Destroy(item.gameObject);
            }
            else
            {
                item.SetParent(UiParent, false);
                item.localPosition = new Vector3(1000, 0, 0);
                UiItemList[name].item.Push(item);
                if (!DebugLog) return;
                if (!string.IsNullOrEmpty(DebugItem))
                {
                    if (name == DebugItem)
                    {
                        DebugHelper.LogError($"回收{name}的对象,回收之后剩余:{UiItemList[name].item.Count}");
                    }
                }
                else
                {
                    DebugHelper.LogError($"回收{name}的对象,回收之后剩余:{UiItemList[name].item.Count}");
                }
            }
        }
    }

    public class PoolData
    {
        public string name;
        public int num;
        public int maxNum;
    }
}
