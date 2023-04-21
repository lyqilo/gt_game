using LuaFramework;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

namespace Hotfix.WPBY
{
    public class WPBY_FishController : SingletonILEntity<WPBY_FishController>
    {
        private int fishGroupID;
        int nowFishGroup;
        private bool IsShowKingFish;
        bool isLockBigFish;
        Dictionary<int, WPBY_Fish> fishDic;
        private long YuChaoTime;

        protected override void Awake()
        {
            base.Awake();
            fishDic = new Dictionary<int, WPBY_Fish>();
        }
        public void SetFish(WPBY_Struct.CMD_S_AddFish data)
        {
            DebugHelper.Log("开始创建鱼");
            for (int i = 1; i < data.loadFishList.Count; i++)
            {
                if (data.loadFishList[i].Kind > 0)
                {
                    CreateFish(data.loadFishList[i]);
                }
            }
        }
        public void InitFish(WPBY_Struct.CMD_S_PlayerEnter _data)
        {
            DebugHelper.Log("初始创建鱼");
            WPBY_Struct.CMD_S_AddFish data = new WPBY_Struct.CMD_S_AddFish() { FishCount = _data.szSize, loadFishList = _data.szLoadFish };
            for (int i = 1; i < data.loadFishList.Count; i++)
            {
                if (data.loadFishList[i].Kind > 0)
                {
                    CreateFish(data.loadFishList[i]);
                }
            }
        }
        public void CreateFish(WPBY_Struct.LoadFish data)
        {
            Transform fishObj = WPBYEntry.Instance.fishCache.Find(WPBY_DataConfig.FishKind[data.Kind - 1]);
            if (fishObj == null)
            {
                Transform _fish = WPBYEntry.Instance.fishPool.Find(WPBY_DataConfig.FishKind[data.Kind - 1]);
                fishObj = UnityEngine.Object.Instantiate(_fish.gameObject).transform;
                fishObj.gameObject.name = WPBY_DataConfig.FishKind[data.Kind - 1];
            }
            WPBY_Fish fish = fishObj.gameObject.AddILComponent<WPBY_Fish>();
            fishDic.Add(data.id, fish);
            fish.Create(data);
            EventTriggerHelper eventtrigger = fishObj.gameObject.AddComponent<EventTriggerHelper>();
            eventtrigger.onDown = (obj, eventData) =>
            {
                LockFish(data.id);
            };
        }

        public WPBY_Fish GetFish(int id)
        {
            WPBY_Fish fish = null;
            fishDic.TryGetValue(id, out fish);
            return fish;
        }
        public void SetAddSpeed()
        {
            WPBY_Fish[] fishs = fishDic.GetDictionaryValues();
            for (int i = 0; i < fishs.Length; i++)
            {
                fishs[i].QuickSwim();
            }
        }

        public void FishDead(WPBY_Struct.CMD_S_FishDead deadFish)
        {
            //鱼死亡
            for (int i = 0; i < deadFish.fish.Count; i++)
            {
                if (deadFish.fish[i].id > 0)
                {
                    WPBY_Fish fish = GetFish(deadFish.fish[i].id);
                    fish.Dead(deadFish.fish[i], deadFish.wChairID);
                }
            }
        }
        public void CollectFish(int id, int kind, GameObject obj)
        {
            if (!fishDic.ContainsKey(id)) return;
            WPBY_Fish data = fishDic[id];
            obj.gameObject.name = WPBY_DataConfig.FishKind[kind];
            obj.transform.SetParent(WPBYEntry.Instance.fishCache);
            obj.transform.localPosition = Vector3.zero;
            obj.gameObject.SetActive(false);
            data.gameObject.RemoveILComponent<WPBY_Fish>();
            EventTriggerHelper eventtrigger = obj.transform.GetComponent<EventTriggerHelper>();
            if (eventtrigger != null)
            {
                UnityEngine.Object.Destroy(eventtrigger);
            }
            fishDic.Remove(id);
        }
        public void ClearFish()
        {
            fishDic.Clear();
        }
        public void OnJoinFishTide(WPBY_Struct.CMD_S_YuChaoCome msg)
        {
            float endTime = 0;
            DebugHelper.Log($"{msg.fishTide.fishTideCurTime}   {msg.fishTide.fishTideStartTime}鱼潮已经开始时间");
            if (msg.YuChaoId == 3 || msg.YuChaoId == 4)
            {
                this.YuChaoTime = msg.fishTide.fishTideCurTime;
                if (this.YuChaoTime == 0)
                {
                    WPBYEntry.Instance.DelayCall(6, () =>
                    {
                        WPBYEntry.Instance.heidongEffect.gameObject.SetActive(true);
                    });
                }
                else
                {
                    long remain = 6 - msg.fishTide.fishTideCurTime;
                    WPBYEntry.Instance.DelayCall(remain > 0 ? remain : 0, () =>
                    {
                        WPBYEntry.Instance.heidongEffect.gameObject.SetActive(true);
                    });
                }
            }
            int index = 101;
            bool IsShowHaiLang = true;
            for (int i = 0; i < msg.fishTide.fishLines.Count; i++)
            {
                if (msg.fishTide.fishLines[i].fishNum > 0)
                {
                    float last = msg.fishTide.fishLines[i].startDelayTime / 1000f;
                    for (int j = 0; j < msg.fishTide.fishLines[i].fishNum; j++)
                    {
                        long cTime = msg.fishTide.fishTideStartTime + msg.fishTide.fishLines[i].startDelayTime + (msg.fishTide.fishLines[i].delayTime * j);
                        long nTime = (msg.fishTide.fishTideCurTime - cTime) <= 0 ? 0 : ((msg.fishTide.fishTideCurTime - cTime) / 10);
                        int indexx = i;
                        if (nTime > msg.fishTide.fishLines[i].livedTime)
                        {
                            index++;
                            IsShowHaiLang = false;
                        }
                        else
                        {
                            WPBY_Struct.LoadFish fish = new WPBY_Struct.LoadFish();
                            fish.CreateTime = (int)cTime;
                            fish.EndTime = msg.fishTide.fishLines[indexx].livedTime;
                            fish.fishPoint = msg.fishTide.fishLines[indexx].line.Points;
                            fish.id = index;
                            fish.Kind = (byte)msg.fishTide.fishLines[indexx].Kind;
                            fish.NowTime = (int)nTime;
                            fish.odd = 0;

                            WPBYEntry.Instance.DelayCall((nTime > 0) ? 0 : last, () =>
                            {
                                this.CreateFish(fish);
                            });
                            if (nTime <= 0)
                            {
                                last += msg.fishTide.fishLines[i].delayTime / 1000f;
                            }
                            index++;
                            if (endTime == 0)
                            {
                                if (j == msg.fishTide.fishLines[i].fishNum - 1)
                                {
                                    endTime = last + (msg.fishTide.fishLines[i].livedTime / 1000);
                                }
                            }
                        }
                    }
                    if (IsShowHaiLang && msg.fishTide.Rotate != 0)
                    {
                        IsShowHaiLang = false;
                        WPBY_Effect.Instance.OnShowHaiLang(msg.YuChaoId, msg.fishTide.Rotate);
                    }
                }
            }
        }

        public void OnDSYDie(WPBY_Struct.CMD_S_DaSanYuan cMD_S_DaSanYuan)
        {

        }

        public void OnDSXDie(WPBY_Struct.CMD_S_DaSiXi cMD_S_DaSiXi)
        {

        }

        public void SendHitFish(WPBY_Struct.Bullet bullet, int site, List<WPBY_Fish> fishIdlist)
        {
            WPBY_Struct.HitFish hitFish = new WPBY_Struct.HitFish();
            hitFish.bulletId = bullet.id;
            hitFish.type = bullet.type;
            hitFish.isUse = bullet.isUse;
            hitFish.level = bullet.level;
            hitFish.grade = bullet.grade;
            hitFish.bet = WPBYEntry.Instance.GameData.Config.bulletScore[bullet.grade] * (bullet.level + 1);
            hitFish.wChairID = site;
            hitFish.fishIDList = new List<int>();
            for (int i = 0; i < fishIdlist.Count; i++)
            {
                hitFish.fishIDList.Add(fishIdlist[i].fishData.id);
            }
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, WPBY_Network.SUB_C_HITED_FISH, hitFish.ByteBuffer, SocketType.Game);
        }

        public void OnZYTDie(WPBY_Struct.CMD_S_ZhongYiTang data)
        {
            WPBY_PlayerController.Instance.OnSetPlayerState(1, data.wChairID);
            if (data.wChairID == WPBYEntry.Instance.GameData.ChairID)
            {
                WPBY_Effect.Instance.OnShowSuperPowrEffect(true, data.time, data.wChairID);
            }
            else
            {
                WPBYEntry.Instance.DelayCall(data.time, () =>
                {
                    WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(data.wChairID);
                    player.OnJoinSuperPowrModel(false);
                });
            }
        }
        public void OnSHZDie(WPBY_Struct.CMD_S_ShuiHuZhuan data)
        {
            WPBY_Effect.Instance.ShuiHuZhuan();
            List<WPBY_Fish> fishlist = this.OnGetFishToSence();
            WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(data.wChairID);
            if (player == null) return;
            if (player.isSelf || player.isRobot)
            {
                WPBY_Struct.HitSHZ hitSHZ = new WPBY_Struct.HitSHZ();
                hitSHZ.chairID = data.wChairID;
                hitSHZ.fishId = data.fishid;
                hitSHZ.fishlist = new List<int>();
                for (int i = 0; i < fishlist.Count; i++)
                {
                    hitSHZ.fishlist.Add(fishlist[i].fishData.id);
                    WPBY_NetController.Instance.CreateNew(data.wChairID, fishlist[i].transform.position, fishlist[i].fishData.id);
                }
                HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, WPBY_Network.SUB_C_SHUIHUZHUAN, hitSHZ.ByteBuffer, SocketType.Game);
            }
        }
        public void OnJBZDDie(WPBY_Struct.CMD_S_JuBuZhaDan data)
        {
            WPBY_Effect.Instance.JBZDEffectEvent();
            WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(data.wChairID);
            if (player == null) return;
            if (player.isSelf || player.isRobot)
            {
                WPBY_Fish fish = GetFish(data.fishid);
                List<WPBY_Fish> totalfishlist = new List<WPBY_Fish>();
                List<WPBY_Fish> fishlist = OnGetFishToXY(200, fish.transform.localPosition);
                for (int i = 0; i < fishlist.Count; i++)
                {
                    fishlist[i].StopSwim(fish.transform.position);
                    totalfishlist.Add(fishlist[i]);
                }
                IEnumerator DoDelay()
                {
                    float t = 0;
                    while (true)
                    {
                        yield return new WaitForEndOfFrame();
                        t += 0.1f;
                        if (t > 1.5f) break;
                        fishlist = OnGetFishToXY(200, fish.transform.localPosition);
                        for (int i = 0; i < fishlist.Count; i++)
                        {
                            bool isfind = false;
                            for (int j = 0; j < totalfishlist.Count; j++)
                            {
                                if (totalfishlist[j].fishData.id == fishlist[i].fishData.id)
                                {
                                    isfind = true;
                                    break;
                                }
                            }
                            if (!isfind)
                            {
                                fishlist[i].StopSwim(fish.transform.position);
                                totalfishlist.Add(fishlist[i]);
                            }
                        }
                    }
                    yield return new WaitForSeconds(0.5f);
                    WPBY_Struct.HitJBZD hitJBZD = new WPBY_Struct.HitJBZD();
                    hitJBZD.chairID = data.wChairID;
                    hitJBZD.fishId = data.fishid;
                    hitJBZD.fishlist = new List<int>();
                    for (int i = 0; i < totalfishlist.Count; i++)
                    {
                        hitJBZD.fishlist.Add(totalfishlist[i].fishData.id);
                        WPBY_NetController.Instance.CreateNew(data.wChairID, totalfishlist[i].transform.position, totalfishlist[i].fishData.id);
                    }
                    HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, WPBY_Network.SUB_C_JUBUZHADAN, hitJBZD.ByteBuffer, SocketType.Game);
                }

                Behaviour.StartCoroutine(DoDelay());
            }
        }
        public void OnYWDie(WPBY_Struct.CMD_S_YuWang data)
        {
            WPBY_Fish fish = GetFish(data.kingID);
            if (this.nowFishGroup >= 3)
            {
                this.fishGroupID = 1000;
                this.nowFishGroup = 0;
                this.IsShowKingFish = false;
            }
            this.nowFishGroup++;
            Vector3 deadYuWangPoint = Vector3.zero;
            if (fish == null)
            {
                if (!this.IsShowKingFish) return;
                this.OnShowFishGroupToYuWang(data.fish, deadYuWangPoint);
                return;
            }
            this.IsShowKingFish = true;
            deadYuWangPoint = fish.transform.localPosition;
            if (data.wChairID == WPBYEntry.Instance.GameData.ChairID)
            {
                ByteBuffer buffer = new ByteBuffer();
                buffer.WriteInt(data.wChairID);
                HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, WPBY_Network.SUB_C_YUWANG, buffer, SocketType.Game);
            }
            this.OnShowFishGroupToYuWang(data.fish, deadYuWangPoint);
            WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(data.wChairID);
            if (player != null)
            {
                WPBY_Effect.Instance.ShowOhterFishDead(0, "YuWang", player.transform, fish);
            }
        }

        public void OnYWDJDie(WPBY_Struct.CMD_S_YiWangDaJin data)
        {
            List<WPBY_Fish> fishlist = OnGetFishToSence();
            for (int i = 0; i < fishlist.Count; i++)
            {
                WPBY_NetController.Instance.CreateNew(data.wChairID, fishlist[i].transform.localPosition, fishlist[i].fishData.id);
                fishlist[i].OnHitFish();
            }
            if (data.wChairID == WPBYEntry.Instance.GameData.ChairID)
            {
                WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(data.wChairID);
                if (player == null) return;
                WPBY_Struct.Bullet bullet = new WPBY_Struct.Bullet();
                bullet.id = data.bullet;
                bullet.type = (byte)(player.isSuperMode ? 1 : 0);
                bullet.isUse = 0;
                bullet.level = player.gunLevel;
                bullet.grade = player.gungrade;
                bullet.chips = WPBYEntry.Instance.GameData.Config.bulletScore[player.gungrade] * (player.gunLevel + 1);
                SendHitFish(bullet, data.wChairID, fishlist);
            }
        }
        public void OnTLZDDie(WPBY_Struct.CMD_S_TongLeiZhaDan data)
        {
            List<WPBY_Fish> fishlist = OnGetFishToSence();
            List<WPBY_Fish> newfishlist = new List<WPBY_Fish>();
            for (int i = 0; i < fishlist.Count; i++)
            {
                if (fishlist[i].fishData.Kind == data.kind)
                {
                    newfishlist.Add(fishlist[i]);
                }
            }
            WPBY_Effect.Instance.TLZDEffectEvent();
            WPBY_Effect.Instance.ShowSingleBomb(newfishlist);
            WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(data.wChairID);
            if (player == null) return;
            if (player.isSelf || player.isRobot)
            {
                WPBY_Struct.HitJBZD jBZD = new WPBY_Struct.HitJBZD();
                jBZD.chairID = data.wChairID;
                jBZD.fishId = data.fishId;
                jBZD.fishlist = new List<int>();
                for (int i = 0; i < newfishlist.Count; i++)
                {
                    DebugHelper.Log($"同类：{newfishlist[i].fishData.id}");
                    jBZD.fishlist.Add(newfishlist[i].fishData.id);

                }
                HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, WPBY_Network.SUB_C_TONGLEIZHADAN, jBZD.ByteBuffer, SocketType.Game);
            }
        }
        public void OnShotLK(WPBY_Struct.CMD_S_ShootLK data)
        {
            WPBY_Fish fish = GetFish(data.id);
            if (fish == null) return;
            if (data.score != 0)
            {
                WPBY_Effect.Instance.ShowSuperJack(data.score, fish, data.site);
                fish.Dead();
            }
            else
            {
                fish.transform.FindChildDepth<TextMeshProUGUI>("odd").text = ToolHelper.ShowRichText(data.Multiple);
            }
        }
        public List<WPBY_Fish> OnGetFishToSence()
        {
            List<WPBY_Fish> list = new List<WPBY_Fish>();
            WPBY_Fish[] fishs = fishDic.GetDictionaryValues();
            for (int i = 0; i < fishs.Length; i++)
            {
                if (fishs[i].IsToSence())
                {
                    list.Add(fishs[i]);
                }
            }
            return list;
        }

        public List<WPBY_Fish> OnGetBigFishToSence()
        {
            List<WPBY_Fish> list = new List<WPBY_Fish>();
            WPBY_Fish[] fishs = fishDic.GetDictionaryValues();
            for (int i = 0; i < fishs.Length; i++)
            {
                if (fishs[i].IsToSence() && fishs[i].fishData.Kind >= 18)
                {
                    list.Add(fishs[i]);
                }
            }
            return list;
        }
        public List<WPBY_Fish> OnGetFishToXY(float distance, Vector3 pos)
        {
            List<WPBY_Fish> list = new List<WPBY_Fish>();
            WPBY_Fish[] fishs = fishDic.GetDictionaryValues();
            for (int i = 0; i < fishs.Length; i++)
            {
                if (fishs[i].IsToAngle(distance, pos))
                {
                    list.Add(fishs[i]);
                }
            }
            return list;
        }

        public void OnShowFishGroupToYuWang(List<WPBY_Struct.LoadFish> fishGroup, Vector3 vector)
        {
            float changeAngle = 9;
            float angle = 0;
            for (int i = 0; i < fishGroup.Count; i++)
            {
                fishGroup[i].CreateTime = (int)Time.realtimeSinceStartup;
                fishGroup[i].fishPoint = new List<WPBY_Struct.FishPoint>();
                float hudu = (angle / 180) * Mathf.PI;
                int v = 3000 / 6;
                for (int j = 0; j < 6; j++)
                {
                    WPBY_Struct.FishPoint point = new WPBY_Struct.FishPoint() { x = 0, y = 0 };
                    if (j == 0)
                    {
                        point.x = (int)vector.x;
                        point.y = (int)vector.y;
                    }
                    else
                    {
                        float x_off = vector.x + v * j * Mathf.Cos(hudu);
                        float y_off = vector.y + v * j * Mathf.Sin(hudu);
                        point.x = (int)x_off;
                        point.y = (int)y_off;
                    }
                    fishGroup[i].fishPoint.Add(point);
                }
                fishGroup[i].EndTime = 1200;
                fishGroup[i].NowTime = 0;
                CreateFish(fishGroup[i]);
                angle += changeAngle;
            }
        }

        public void SetLockFish(bool islock)
        {
            WPBY_PlayerController.Instance.isLock = islock;
            int[] ids = fishDic.GetDictionaryKeys();
            for (int i = 0; i < ids.Length; i++)
            {
                int fishid = ids[i];
                WPBY_Fish fish = fishDic[fishid];
                if (fish.lockTag != null)
                {
                    fish.lockTag.gameObject.SetActive(islock);
                }
                EventTriggerHelper eventtrigger = fish.transform.GetComponent<EventTriggerHelper>();
                if (islock)
                {
                    if (eventtrigger != null)
                    {
                        ToolHelper.Destroy(eventtrigger);
                    }
                    eventtrigger = fish.gameObject.AddComponent<EventTriggerHelper>();
                    eventtrigger.onDown = (obj, eventData) =>
                    {
                        LockFish(fishid);
                    };
                }
                else
                {
                    if (eventtrigger != null)
                    {
                        ToolHelper.Destroy(eventtrigger);
                    }
                }
            }
        }
        public void LockFish(int fishid)
        {
            WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(WPBYEntry.Instance.GameData.ChairID);
            if (player.IsLock)
            {
                WPBY_Fish fish = GetFish(fishid);
                if (fish == null) return;
                DebugHelper.Log($"点击鱼id：{fishid}  Kind:{fish.fishData.Kind}");
                if (fish.fishData.Kind <= 12) return;
                player.LockFish = fish;
                player.SendBulltPackIsLock(fishid);
                Vector3 vector2 = fish.transform.position;
                if (!player.isContinue)
                {
                    WPBY_PlayerController.Instance.ShootSelfBullet(new Vector3(vector2.x, vector2.y, 0), player.data.ChairId);
                }
                else
                {
                    WPBY_PlayerController.Instance.ContinuousFireByPos(true, player.data.ChairId, vector2);
                }
            }
        }
        public WPBY_Fish OnGetRandomLookFish(bool isrobot)
        {
            List<WPBY_Fish> a = new List<WPBY_Fish>();
            if (isrobot)
            {
                a = OnGetFishToSence();
            }
            else
            {
                if (isLockBigFish)
                {
                    a = OnGetBigFishToSence();
                }
                else
                {
                    a = OnGetFishToSence();
                }
            }
            if (a.Count <= 0) return null;
            int key = Random.Range(0, a.Count);
            return a[key];
        }
    }
}
