using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.WPBY
{
    public class WPBY_Fish : ILHotfixEntity
    {
        public WPBY_Struct.LoadFish fishData;
        public int fishID = 0;
        public List<Vector3> Path = new List<Vector3>();
        public int pointCount = 300;
        public int speed = 0;
        public bool isSwim = false;
        public int currentPos = 1;
        public bool isdead = false;
        public float resetColorTime = 0.1f;
        public float timer = 0;
        public List<Image> FishImage = new List<Image>();
        public bool IsHit = false;
        public Transform lockTag;
        public Color hitColor = new Color(255 / 255, 133 / 255, 133 / 255, 255 / 255);
        public bool isRotate = false;
        public Vector3 rotateTarget;
        private float lastRestTime;

        public void Create(WPBY_Struct.LoadFish data)
        {
            this.fishData = data;
            this.fishID = data.id;
            this.gameObject.name = data.id.ToString();
            this.currentPos = (int)Mathf.Ceil(this.fishData.NowTime / Mathf.Ceil(Time.fixedDeltaTime / 0.01f));
            if (this.currentPos <= 0) this.currentPos = 1;
            this.Path = CreateNewPath(data.fishPoint);
            if (this.fishData.NowTime >= this.fishData.EndTime)
            {
                SwimCompleted();
                return;
            }
            this.lockTag = this.transform.Find("Lock");
            if (this.lockTag != null)
            {
                this.lockTag.gameObject.SetActive(WPBY_PlayerController.Instance.isLock);
            }
            this.gameObject.SetActive(true);
            Collider collider = this.transform.GetComponent<Collider>();
            if (collider != null)
            {
                collider.enabled = true;
            }
            Swim();
        }
        public void FindAllFishImage()
        {
            this.FishImage = new List<Image>();
            Image img = this.transform.GetComponent<Image>();
            if (img != null) {
                this.FishImage.Add(img);
            }
            FindChildImage(this.transform);
        }
        public void FindChildImage(Transform parent)
        {
            for (int i = 0; i < parent.childCount; i++)
            {
                Image img = parent.GetChild(i).GetComponent<Image>();
                if (img != null)
                {
                    this.FishImage.Add(img);
                }
                FindChildImage(parent.GetChild(i));
            }
        }

        public List<Vector3> CreateNewPath(List<WPBY_Struct.FishPoint> _path)
        {
            List<Vector3> path = new List<Vector3>();
            for (int i = 0; i < _path.Count; i++) {
                Vector3 p = new Vector3(_path[i].x, _path[i].y, 0);
                if (WPBYEntry.Instance.GameData.isRevert)
                {
                    p = new Vector3(-p.x, -p.y, 0);
                }
                path.Add(p);
            }
            int points = (int)Mathf.Ceil(this.fishData.EndTime / Mathf.Ceil(Time.fixedDeltaTime / 0.01f));
            return WPBYEntry.Instance.GetBezierPoint(path, points);
        }
        public void Swim()
        {
            this.transform.SetParent(WPBYEntry.Instance.fishScene);
            this.transform.localPosition = this.Path[(int)Mathf.Floor(this.currentPos)];
            float rate = WPBY_DataConfig.StartScale[this.fishData.Kind];
            this.transform.localScale = new Vector3(1 * rate, 1 * rate, 1 * rate);
            if (WPBYEntry.Instance.GameData.isYc)
            {
                this.speed = 5;
            }
            else
            {
                this.speed = 1;
            }
            Image img = this.transform.GetComponent<Image>();
            if (img != null)
            {
                img.color = new Color(1, 1, 1, img.color.a);
            }
            this.isdead = false;
            this.isSwim = true;
        }
        public void QuickSwim()
        { 
    this.speed = 5;
            }
        protected override void FixedUpdate()
        {
            base.FixedUpdate();
            RestColor();
            if (this.isRotate)
            {
                this.transform.RotateAround(this.rotateTarget, new Vector3(0, 0, -1), 3);
            }
            if (this.isSwim)
            {
                this.currentPos += this.speed;
                if (this.currentPos >= this.Path.Count)
                {
                    SwimCompleted();
                    return;
                }
                this.transform.localPosition = this.Path[(int)Mathf.Floor(this.currentPos)];
                this.transform.eulerAngles = new Vector3(0, 0, GetAngle());
            }
        }
        public void SwimCompleted()
        {
            this.isSwim = false;
            this.speed = 0;
            this.isdead = true;
            this.isRotate = false;
            Animator anim = this.transform.GetComponent<Animator>();
            if (anim != null)
            {
                anim.SetTrigger($"PlayDieAnime");
            }
            Collider collider = this.transform.GetComponent<Collider>();
            if (collider != null)
            {
                collider.enabled = false;
            }
            WPBYEntry.Instance.DelayCall(1.5f, () =>
            {
                WPBY_FishController.Instance.CollectFish(this.fishData.id, this.fishData.Kind, this.gameObject);
            });
        }
        public void StopSwim(Vector3 pos)
        {
            this.isSwim = false;
            this.rotateTarget = pos;
            this.speed = 0;
            this.isdead = true;
            Collider collider = this.transform.GetComponent<Collider>();
            if (collider != null)
            {
                collider.enabled = false;
            }
            this.isRotate = true;
        }

        public void Dead(WPBY_Struct.FishData deadFishData = null, int chairId = -1)
        {
            this.isSwim = false;
            this.speed = 0;
            this.isdead = true;
            this.isRotate = false;
            Animator anim = this.transform.GetComponent<Animator>();
            if (anim != null)
            {
                anim.SetTrigger($"PlayDieAnime");
            }
            Collider collider = this.transform.GetComponent<Collider>();
            if (collider != null)
            {
                collider.enabled = false;
            }
            if (deadFishData != null)
            {
                //TODO 飞金币, 显示文本金币
                WPBY_Effect.Instance.ShowSuperJack(deadFishData.score, this, chairId);
                WPBY_Effect.Instance.OnShowScure(this, deadFishData.score, chairId);
                WPBY_Effect.Instance.FlyGold(this, deadFishData, chairId);
            }
            WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(chairId);
            if (player != null)
            {
                player.OnChangeUserScure((ulong)deadFishData.score, true);
                player.OnShowGold(deadFishData.score, this.fishData.id);
            }
            float time = 1.5f;
            if (this.fishData.Kind == 19)
            {
                time = 3;
                this.lockTag.gameObject.SetActive(false);
            }
            WPBYEntry.Instance.DelayCall(time, () =>
            {
                WPBY_FishController.Instance.CollectFish(this.fishData.id, this.fishData.Kind, this.gameObject);
            });
        }
        public float GetAngle()
        {
            if (this.currentPos >= this.Path.Count - 1)
            {
                return this.transform.eulerAngles.z;
            }
            Vector3 to = this.Path[(int)Mathf.Floor(this.currentPos + 1)];
            Vector3 direction = to - this.transform.localPosition;
            float angle = (360 - Mathf.Atan2(direction.x, direction.y) * Mathf.Rad2Deg) + 90;
            return angle;
        }

        public void RestColor()
        {
            if (!this.IsHit) return;
            if (Time.realtimeSinceStartup - this.lastRestTime > this.resetColorTime) {
                Image img = this.transform.GetComponent<Image>();
                if (img != null)
                {
                    img.color = new Color(1, 1, 1, img.color.a);
                }
                }
    }
        public void OnChangeHitColor()
        {
            Image img = this.transform.GetComponent<Image>();
            if (img != null)
            {
                img.color = new Color(this.hitColor.r, this.hitColor.g, this.hitColor.b, img.color.a);
            }
        }
        public void OnHitFish()
        {
            OnChangeHitColor();
            this.IsHit = true;
            this.lastRestTime = Time.realtimeSinceStartup;
        }
        public bool IsToSence()
        {
            if (this.transform.localPosition.x > WPBYEntry.Instance.width / 2)
            {
                return false;
            }
            if (this.transform.localPosition.x < -WPBYEntry.Instance.width / 2)
            {
                return false;
            }
            if (this.transform.localPosition.y < -WPBYEntry.Instance.height / 2)
            {
                return false;
            }
            if (this.transform.localPosition.y > WPBYEntry.Instance.height / 2)
            {
                return false;
            }
            if (this.isdead)
            {
                return false;
            }
            return true;
        }
        public bool IsToAngle(float distance, Vector3 point)
        {
            if (this.isdead)
            {
                return false;
            }
            Vector3 selfPos = this.transform.localPosition;
            if (Vector3.Distance(point, selfPos) <= distance)
            {
                return true;
            }
            return false;
        }
    }
}
