using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using UnityEngine;

namespace Hotfix.WPBY
{
    public class WPBY_Bullet : ILHotfixEntity
    {
        WPBY_Struct.CMD_S_PlayerShoot bulletdata;
        public int bulletId;
        public int wChairID;
        public byte type;
        public byte isUse;
        public byte level = 0;
        public byte grade = 0;
        public int Direction;
        public float speed = 20*5;
        public WPBY_Fish lockFish;
        public bool isLock;

        public void Create(int _bulletId, WPBY_Struct.CMD_S_PlayerShoot data)
        {
            WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(wChairID);
            if (player != null)
            {
                if (player.isSuperMode)
                {
                    speed = 12*10;
                    type = 1;
                }
                else
                {
                    speed = 20*10;
                    type = 0;
                }
            }

            bulletdata = data;
            Direction = 0;
            level = (byte)data.level;
            grade = (byte)data.type;
            bulletId = _bulletId;
            transform.GetComponent<Collider>().enabled = true;
        }

        public void Collect()
        {
            if (Behaviour != null) Object.Destroy(Behaviour);
            transform.GetComponent<Collider>().enabled = false;
            transform.SetParent(WPBYEntry.Instance.bulletCache);
            transform.localPosition = Vector3.zero;
            WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(wChairID);
            if (player == null) return;
            for (int i = player.bulletList.Count - 1; i >= 0; i--)
            {
                if (player.bulletList[i] != null && player.bulletList[i].bulletId == bulletId)
                {
                    player.bulletList.RemoveAt(i);
                }
            }
        }

        public void SendHitFish(List<int> fishIdlist)
        {
            WPBY_Struct.HitFish hitFish = new WPBY_Struct.HitFish();
            hitFish.bulletId = bulletId;
            hitFish.type = type;
            hitFish.isUse = isUse;
            hitFish.level = level;
            hitFish.grade = grade;
            hitFish.bet = WPBYEntry.Instance.GameData.Config.bulletScore[grade] * (level + 1);
            hitFish.wChairID = wChairID;
            hitFish.fishIDList = fishIdlist;
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, WPBY_Network.SUB_C_HITED_FISH, hitFish.ByteBuffer, SocketType.Game);
        }

        protected override void Update()
        {
            base.Update();
            if (this.isLock)
            {
                WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(this.wChairID);
                if (player == null)
                {
                    this.isLock = false;
                    Collect();
                    return;
                }
                if (this.lockFish != null)
                {
                    if (player.LockFish != this.lockFish || !this.lockFish.IsToSence())
                    {
                        this.isLock = false;
                        return;
                    }
                }
                else
                {
                    this.isLock = false;
                }
            }
            if (this.Direction != 1)
            {
                //向左
                if (this.transform.position.x < WPBYEntry.Instance.viewportRect.x)
                {
                    this.Direction = 1;
                    this.transform.up = Vector3.Reflect(this.transform.up, Vector3.right);
                }
            }
            if (this.Direction != 2)
            {
                //向上
                if (this.transform.position.y > WPBYEntry.Instance.viewportRect.y)
                {
                    this.Direction = 2;
                    this.transform.up = Vector3.Reflect(this.transform.up, Vector3.down);
                }
            }
            if (this.Direction != 3)
            {
                //向右
                if (this.transform.position.x > WPBYEntry.Instance.viewportRect.z)
                {
                    this.Direction = 3;
                    this.transform.up = Vector3.Reflect(this.transform.up, Vector3.left);
                }
            }
            if (this.Direction != 4)
            {
                //向下
                if (this.transform.position.y < WPBYEntry.Instance.viewportRect.w)
                {
                    this.Direction = 4;
                    this.transform.up = Vector3.Reflect(this.transform.up, Vector3.up);
                }
            }
            if (this.isLock && this.lockFish != null)
            {
                Vector3 _dir = this.lockFish.transform.position - this.transform.position;
                this.transform.up = _dir;
                this.transform.Translate(new Vector3(0, 1 * Time.deltaTime * this.speed, 0));
                return;
            }
            this.transform.Translate(new Vector3(0, 1 * Time.deltaTime * this.speed, 0));
        }
        protected override void OnTriggerEnter(Collider collider)
        {
            base.OnTriggerEnter(collider);
            if (collider.tag != "fish") return;
            //碰到鱼
            //如果是锁定，判断是否为锁定的鱼
            if (this.isLock && this.lockFish != null && (!this.lockFish.isdead || !this.lockFish.IsToSence()))
            {
                if (this.lockFish.fishData.id != int.Parse(collider.gameObject.name))
                {
                    return;
                }
            }
            //TODO 发送消息,隐藏子弹
            int id = int.Parse(collider.gameObject.name);
            WPBY_Fish fish = WPBY_FishController.Instance.GetFish(int.Parse(collider.gameObject.name));
            if (fish != null)
            {
                fish.OnHitFish();
                WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(this.wChairID);
                if (this.wChairID == WPBYEntry.Instance.GameData.ChairID || player.isRobot)
                {
                    SendHitFish(new List<int>() { fish.fishData.id });
                }
            }
            WPBY_NetController.Instance.CreateNew(this.wChairID, this.transform.position, id);
            Collect();
        }
    }
}