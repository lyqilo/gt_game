using DG.Tweening;
using LuaFramework;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.WPBY
{
    public class WPBY_Player : ILHotfixEntity
    {
        public GameUserData data = null;
       public  ulong goldNum = 0;
       public byte gunLevel = 1;
       public byte gungrade = 1;

        Transform ptTrans = null;
        Transform playerInfo = null;
        Transform playerGoldChangeGroup = null;
        Transform posTag = null;

        private Button addBeiBtn = null;
        private Button reduceBeiBtn = null;
        private Button upgradeGunBtn;
        private Button maxGunBtn;
        private Transform gunGroup = null;
        private Transform gunPoint = null;
        private Transform gunEffect;
        private Transform gunEffect_Normal = null;
        private Transform gunEffect_Super = null;
        private Transform onSitTag = null;
        private Transform chipNode;
        private TextMeshProUGUI chipNum;
        private Button changeGunBtn = null;
        private Transform LevelNode = null;
        public Transform gun_Function;
        private Transform userHead = null;
        private Text userName = null;
        public TextMeshProUGUI userGold = null;
        public bool isSelf = false;
        private Transform shootPoint = null;
        public WPBY_Fish LockFish = null;
        public bool IsLock = false;
        public int bulletID = 0;
        public List<WPBY_Bullet> bulletList = new List<WPBY_Bullet>();

        private Queue<GameObject> goldlist = new Queue<GameObject>();
        private int goldMaxNum = 12;
        private float timer = 0;
        private float updateTime = 3;
        public bool isSuperMode;

        public bool isRobot = false;
        public bool isRobotIsLock = false;

        public Vector3 dir;
        public bool isThumb = false;
        public bool isContinue = false;

        Transform TheGun = null;
        Transform lockObj = null;
        Transform lockTag = null;

        private int continueState = 0;
        private float continueTimer = 0;
        private float continueDefaultTimer = 0.2f;
        private float continueMaxTimer = 0.2f;

        private Tweener repeatTweener;
        protected override void Awake()
        {
            base.Awake();
            this.bulletList = new List<WPBY_Bullet>();
            this.goldlist = new Queue<GameObject>();
            this.continueMaxTimer = this.continueDefaultTimer;
        }
        protected override void FindComponent()
        {
            base.FindComponent();
            this.ptTrans = this.transform.FindChildDepth("PaoTai");
            this.playerInfo = this.transform.FindChildDepth("UserInfo");
            this.playerGoldChangeGroup = this.transform.FindChildDepth("ChangeGoldGroup");
            this.playerGoldChangeGroup.GetChild(0).gameObject.SetActive(false);
            this.posTag = this.transform.FindChildDepth("SelfPos");

            this.gunGroup = this.ptTrans.FindChildDepth("GunGroup");
            this.gunPoint = this.gunGroup.FindChildDepth("Gun");
            this.gunEffect = this.gunGroup.FindChildDepth("GunEffect");
            this.gunEffect_Normal = this.gunEffect.FindChildDepth("Normal");
            this.gunEffect_Super = this.gunEffect.FindChildDepth("Super");
            this.shootPoint = this.gunGroup.FindChildDepth("ShootPoint");
            this.changeGunBtn = this.ptTrans.FindChildDepth<Button>("ChangeGun");
            this.onSitTag = this.ptTrans.FindChildDepth("OnSit");
            this.chipNode = this.ptTrans.FindChildDepth("Chip");
            this.chipNum = this.ptTrans.FindChildDepth<TextMeshProUGUI>("Chip/Num");
            this.LevelNode = this.ptTrans.FindChildDepth("Level");

            this.gun_Function = this.ptTrans.FindChildDepth("Gun_Function");
            this.addBeiBtn = this.gun_Function.FindChildDepth<Button>("Gun_Add");
            this.reduceBeiBtn = this.gun_Function.FindChildDepth<Button>("Gun_Reduce");
            this.upgradeGunBtn = this.gun_Function.FindChildDepth<Button>("Gun_UpGrade");
            this.maxGunBtn = this.gun_Function.FindChildDepth<Button>("Gun_Max");

            this.userName = this.playerInfo.FindChildDepth<Text>("NickName");
            this.userGold = this.playerInfo.FindChildDepth<TextMeshProUGUI>("GoldNum");
            this.userName.gameObject.SetActive(false);
            this.lockObj = this.transform.FindChildDepth("Lock/lockImage");
        }

        public void Enter(GameUserData userdata)
        {
            this.data = userdata;
            this.goldNum = this.data.Gold;
            if (WPBYEntry.Instance.GameData.ChairID == this.data.ChairId)
            {
                this.isSelf = true;
                this.onSitTag.gameObject.SetActive(true);
                this.changeGunBtn.gameObject.SetActive(true);
                this.posTag.gameObject.SetActive(true);
                SetWhite(this.transform);
            }
            else
            {
                this.isSelf = false;
                this.onSitTag.gameObject.SetActive(false);
                this.changeGunBtn.gameObject.SetActive(false);
                this.posTag.gameObject.SetActive(false);
                SetGray(this.transform);
            }
            this.gun_Function.gameObject.SetActive(false);
            this.playerGoldChangeGroup.gameObject.SetActive(true);
            this.gunGroup.gameObject.SetActive(true);
            for (int i = 0; i < this.playerGoldChangeGroup.childCount; i++)
            {
                this.playerGoldChangeGroup.GetChild(i).gameObject.SetActive(false);
            }
            for (int i = 0; i < this.gunPoint.childCount; i++)
            {
                this.gunPoint.GetChild(i).gameObject.SetActive(false);
            }
            this.ptTrans.gameObject.SetActive(true);
            this.LevelNode.gameObject.SetActive(true);
            this.gunLevel = 0;
            this.gungrade = 0;
            this.chipNode.gameObject.SetActive(true);
            OnSetUserGunLevel(this.gunLevel, this.gungrade);
            this.playerInfo.gameObject.SetActive(true);
            this.userName.text = this.data.NickName;
            this.userGold.text = ToolHelper.ShowRichText(this.data.Gold);
            AddListener();
            this.gameObject.SetActive(true);
            this.gunGroup.localRotation = Quaternion.identity;
        }

        private void AddListener()
        {
            this.addBeiBtn.onClick.RemoveAllListeners();
            this.addBeiBtn.onClick.Add(() =>
            {
                WPBY_Audio.Instance.PlaySound(WPBY_Audio.ChangeGun);
                AddBet();
                SendChangeGunLevel();
            });
            this.reduceBeiBtn.onClick.RemoveAllListeners();
            this.reduceBeiBtn.onClick.Add(() =>
            {
                WPBY_Audio.Instance.PlaySound(WPBY_Audio.ChangeGun);
                ReduceBet();
                SendChangeGunLevel();
            });
            this.maxGunBtn.onClick.RemoveAllListeners();
            this.maxGunBtn.onClick.Add(() =>
            {
                WPBY_Audio.Instance.PlaySound(WPBY_Audio.ChangeGun);
                //最大炮
                this.gunLevel = 9;
                OnSetUserGunLevel(this.gunLevel, this.gungrade);
                SendChangeGunLevel();
            });
            this.upgradeGunBtn.onClick.RemoveAllListeners();
            this.upgradeGunBtn.onClick.Add(() =>
            {
                WPBY_Audio.Instance.PlaySound(WPBY_Audio.ChangeGun);
                //升级
                this.gungrade++;
                if (this.gungrade > 2)
                {
                    this.gungrade = 0;
                }
                this.gunLevel = 0;
                OnSetUserGunLevel(this.gunLevel, this.gungrade);
                SendChangeGunLevel();
            });
            this.changeGunBtn.onClick.RemoveAllListeners();
            this.changeGunBtn.onClick.Add(() =>
            {
                if (this.gun_Function.gameObject.activeSelf)
                {
                    this.gun_Function.gameObject.SetActive(false);
                }
                else
                {
                    this.gun_Function.gameObject.SetActive(true);
                }
            });
        }
        protected override void Update()
        {
            base.Update();
            this.timer += Time.deltaTime;
            if (this.timer >= this.updateTime)
            {
                if (this.goldlist.Count > 0)
                {
                    UnityEngine.Object.Destroy(this.goldlist.Dequeue());
                }
                this.timer = 0;
            }
            LockControl();
            ContinueControl();
        }

        private void LockControl()
        {
            if (this.IsLock)
            {
                if (this.LockFish == null || this.LockFish.isdead || !this.LockFish.IsToSence())
                {
                    this.LockFish = null;
                    this.lockTag = null;
                    if (this.lockObj.gameObject.activeSelf)
                    {
                        this.lockObj.gameObject.SetActive(false);
                    }
                    if (this.isRobot)
                    {
                        this.LockFish = WPBY_FishController.Instance.OnGetRandomLookFish(true);
                        if (this.LockFish != null)
                        {
                            this.lockTag = this.LockFish.transform.FindChildDepth("Lock");
                            ContinueFire(0.5f, 0.5f);
                        }
                    }
                    return;
                }
                else
                {
                    if (!this.isRobot)
                    {
                        if (this.isSelf)
                        {
                            if (!this.lockObj.gameObject.activeSelf && this.lockTag != null)
                            {
                                this.lockObj.gameObject.SetActive(true);
                            }
                            if (this.lockTag != null)
                            {
                                this.lockObj.transform.position = this.lockTag.position;
                            }
                        }
                    }
                    this.dir = this.LockFish.transform.position;
                    RotatePaoTaiByPos(this.LockFish.transform.position);
                }
            }
        }
        private void ContinueControl()
        {
            if (this.isContinue)
            {
                if (this.continueState == 1)
                {
                    WPBY_Fish ranFish = WPBY_FishController.Instance.OnGetRandomLookFish(true);
                    if (ranFish == null)
                    {
                        this.continueState = 0;
                        return;
                    }
                    this.continueTimer += Time.deltaTime;
                    if (this.continueTimer >= continueMaxTimer)
                    {
                        this.continueTimer = 0;
                        if (this.dir == default(Vector3))
                        {
                            if (this.data.ChairId == 0 || this.data.ChairId == 1)
                            {
                                if (WPBYEntry.Instance.GameData.ChairID <= 1)
                                {
                                    this.dir = this.gunGroup.transform.position + new Vector3(0, 1, 0);
                                }
                                else
                                {
                                    this.dir = this.gunGroup.transform.position + new Vector3(0, -1, 0);
                                }
                            }
                            else
                            {
                                if (WPBYEntry.Instance.GameData.ChairID > 1)
                                {
                                    this.dir = this.gunGroup.transform.position + new Vector3(0, 1, 0);
                                }
                                else
                                {
                                    this.dir = this.gunGroup.transform.position + new Vector3(0, -1, 0);
                                }
                            }
                        }
                        WPBY_PlayerController.Instance.ShootSelfBullet(this.dir, this.data.ChairId);
                    }
                }
                else
                {
                    WPBY_Fish ranFish = WPBY_FishController.Instance.OnGetRandomLookFish(true);
                    if (ranFish != null)
                    {
                        if (this.isRobot)
                        {
                            ContinueFire(0.5f, 0.5f);
                        }
                        else
                        {
                            ContinueFire(WPBY_PlayerController.Instance.acceleration, WPBY_PlayerController.Instance.acceleration);
                        }
                    }
                }
            }
        }

        public void ContinueFire(float delayTime, float time)
        {
            if (this.repeatTweener != null)
            {
                this.repeatTweener.Kill();
                this.repeatTweener = null;
            }
            this.continueState = 0;
            this.continueMaxTimer = time;
            this.continueTimer = 0;
            if (this.IsLock && this.LockFish != null)
            {
                this.dir = this.LockFish.transform.position;
            }
            WPBY_Fish fish = WPBY_FishController.Instance.OnGetRandomLookFish(true);
            if (fish != null)
            {
                this.continueState = 1;
            }
        }
        public void StopContinueFire()
        {
            if (this.repeatTweener != null)
            {
                this.repeatTweener.Kill();
                this.repeatTweener = null;
            }
            this.continueState = 0;
            this.continueMaxTimer = this.continueDefaultTimer;
            this.continueTimer = 0;
        }

        public void SetLockState(bool value)
        {
            this.IsLock = value;
            if (!this.IsLock)
            {
                this.LockFish = null;
                this.lockObj.gameObject.SetActive(false);
            }
        }

        private void AddBet()
        {
            this.gunLevel++;
            if (this.gunLevel >= 10)
            {
                this.gunLevel = 0;
            }
            OnSetUserGunLevel(this.gunLevel, this.gungrade);
        }

        private void ReduceBet()
        {
            this.gunLevel--;
            if (this.gunLevel < 0)
            {
                this.gunLevel = 9;
            }
            OnSetUserGunLevel(this.gunLevel, this.gungrade);
        }

        public void SendChangeGunLevel()
        {
            WPBY_Struct.ChangeGunLevel changeGunLevel = new WPBY_Struct.ChangeGunLevel();
            changeGunLevel.chairID = data.ChairId;
            changeGunLevel.grade = gungrade;
            changeGunLevel.level = gunLevel;
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, WPBY_Network.SUB_C_CHANGEBULLETLEVEL, changeGunLevel.ByteBuffer, SocketType.Game);
        }

        public void ChangePTLevel(WPBY_Struct.CMD_S_ChangeBulletLevel changeLevel)
        {
            this.gungrade = changeLevel.cbGunType;
            this.gunLevel = changeLevel.cbGunLevel;
            OnSetUserGunLevel(this.gunLevel, this.gungrade);
        }

        public void OnSetUserGunLevel(byte level, byte grade)
        {
            //初始化炮台
            this.gunLevel = level;
            this.gungrade = grade;
            for (int i = 0; i < this.gunPoint.childCount; i++)
            {
                if (grade == i)
                {
                    this.gunPoint.GetChild(i).gameObject.SetActive(true);
                    this.TheGun = this.gunPoint.GetChild(i);
                    this.LevelNode.GetChild(i).gameObject.SetActive(true);
                }
                else
                {
                    this.gunPoint.GetChild(i).gameObject.SetActive(false);
                    this.LevelNode.GetChild(i).gameObject.SetActive(false);
                }
            }
            SetPaoTaiChip();
        }

        private void SetPaoTaiChip()
        {
            if (WPBYEntry.Instance.GameData.Config == null) return;
            if (WPBYEntry.Instance.GameData.Config.bulletScore.Count > 0)
            {
                this.chipNum.text = ToolHelper.ShowRichText(WPBYEntry.Instance.GameData.Config.bulletScore[this.gungrade] * (this.gunLevel+1));
            }
        }

        public void RotatePaoTaiByAngle(float angle)
        {
            this.gunGroup.localRotation = new Quaternion(0, 0, angle, 0);
        }
        public void Shoot(WPBY_Struct.CMD_S_PlayerShoot bullet)
        {
            OnChangeUserScure((ulong)bullet.playCurScore, false);
            Vector3 pos = new Vector3(bullet.x, bullet.y, 0);
            RotatePaoTaiByPos(pos);
            CreateBullet(bullet);
        }

        public void CreateBulltEffect()
        {
            Transform eff = null;
            Transform effParent = null;
            if (this.isSuperMode)
            {
                effParent = this.gunEffect_Super;
            }
            else
            {
                effParent = this.gunEffect_Normal;
            }
            for (int i = 0; i < effParent.childCount; i++)
            {
                if (!effParent.GetChild(i).gameObject.activeSelf)
                {
                    eff = effParent.GetChild(i);
                    break;
                }
            }

            if (eff == null)
            {
                GameObject go = UnityEngine.Object.Instantiate(effParent.GetChild(0).gameObject);
                go.transform.SetParent(effParent);
                go.transform.localPosition = Vector3.zero;
                go.transform.localScale = Vector3.one;
                eff = go.transform;
            }

            eff.gameObject.SetActive(true);
            WPBYEntry.Instance.DelayCall(0.3f, () =>
            {
                eff.gameObject.SetActive(false);
            });
        }

        private void CreateBullet(WPBY_Struct.CMD_S_PlayerShoot bullet)
        {
            if (this.bulletID >= WPBY_DataConfig.MAX_BULLET)
            {
                this.bulletID = 1;
            }
            else
            {
                this.bulletID++;
            }
            OnCreateBullet(this.bulletID, bullet);
        }
        private void OnCreateBullet(int bulletid, WPBY_Struct.CMD_S_PlayerShoot bulletdata)
        {
            if (this.TheGun != null)
            {
                this.TheGun.transform.GetComponent<Animator>().SetTrigger($"Stop");
                this.TheGun.transform.GetComponent<Animator>().SetTrigger($"Fire");
            }
            Transform bullet = null;
            if (this.isSelf)
            {
                bullet = WPBYEntry.Instance.bulletCache.Find($"SelfBullt_{this.gungrade + 1}");
            }
            else
            {
                bullet = WPBYEntry.Instance.bulletCache.Find($"Bullt_{this.gungrade + 1}");
            }
            if (bullet == null)
            {
                if (this.isSelf)
                {
                    bullet = UnityEngine.Object.Instantiate(WPBYEntry.Instance.bulletPool.Find($"SelfBullt_{this.gungrade + 1}").gameObject).transform;
                }
                else
                {
                    bullet = UnityEngine.Object.Instantiate(WPBYEntry.Instance.bulletPool.Find($"Bullt_{this.gungrade + 1}").gameObject).transform;
                }
            }
            bullet.SetParent(this.shootPoint);
            bullet.localPosition = Vector3.zero;
            bullet.localRotation = Quaternion.identity;
            bullet.SetParent(WPBYEntry.Instance.bulletScene);
            bullet.localScale = Vector3.one;
            if (this.isSelf)
            {
                bullet.gameObject.name = $"SelfBullt_{this.gungrade + 1}";
            }
            else
            {
                bullet.gameObject.name = $"Bullt_{this.gungrade + 1}";
            }
            WPBY_Bullet _bullet = bullet.AddILComponent<WPBY_Bullet>();
            _bullet.isLock = this.IsLock;
            _bullet.lockFish = this.LockFish;
            _bullet.Create(bulletid, bulletdata);
            this.bulletList.Add(_bullet);
            WPBY_Audio.Instance.PlayFire();
        }

        public void RotatePaoTaiByPos(Vector3 pos)
        {
            Vector3 direction = pos - this.gunGroup.transform.position;
            float angle = 360 - Mathf.Atan2(direction.x, direction.y) * Mathf.Rad2Deg;
            this.gunGroup.transform.eulerAngles = new Vector3(0, 0, angle);
        }

        private void SetGray(Transform parent)
        {
            if (parent == null) return;
            Image img = parent.GetComponent<Image>();
            if (img != null)
            {
                img.color = new Color(0.4f, 0.4f, 0.4f, img.color.a);
            }
            for (int i = 0; i < parent.childCount; i++)
            {
                SetGray(parent.GetChild(i));
            }
        }
        private void SetWhite(Transform parent)
        {
            if (parent == null) return;
            Image img = parent.GetComponent<Image>();
            if (img != null)
            {
                img.color = new Color(1f, 1f, 1f, img.color.a);
            }
            for (int i = 0; i < parent.childCount; i++)
            {
                SetWhite(parent.GetChild(i));
            }
        }

        public void Leave()
        {
            this.transform.gameObject.SetActive(false);
            this.onSitTag.gameObject.SetActive(false);
            this.gunGroup.gameObject.SetActive(false);
            this.reduceBeiBtn.gameObject.SetActive(false);
            this.addBeiBtn.gameObject.SetActive(false);
            this.playerGoldChangeGroup.gameObject.SetActive(false);
            this.playerInfo.gameObject.SetActive(false);
            this.posTag.gameObject.SetActive(false);
            this.changeGunBtn.gameObject.SetActive(true);
            this.LevelNode.gameObject.SetActive(false);
            this.chipNode.gameObject.SetActive(false);
            this.chipNum.text = "";
            this.lockObj.gameObject.SetActive(false);
            this.LockFish = null;
            this.IsLock = false;
            this.isRobot = false;
            this.isContinue = false;
            this.isThumb = false;
            this.isSuperMode = false;
            this.TheGun = null;
            CollectBullet();
            StopContinueFire();
            if (this.repeatTweener != null)
            {
                this.repeatTweener.Kill();
                this.repeatTweener = null;
            }
        }
        public void CollectBullet()
        {
            for (int i = bulletList.Count - 1; i >= 0; i--)
            {
                bulletList[i].Collect();
            }
        }
        public void OnChangeUserScure(ulong change, bool isAdd)
        {
            if (isAdd)
            {
                this.goldNum += change;
                this.userGold.text = ToolHelper.ShowRichText(this.goldNum);
                return;
            }
            if (change >= 0)
            {
                this.goldNum = change;
                this.userGold.text = ToolHelper.ShowRichText(this.goldNum);
            }
            else
            {
                this.goldNum += change;
                this.userGold.text = ToolHelper.ShowRichText(this.goldNum);
            }
        }
        public void OnShowGold(int gold, int fishId)
        {
            float magnificat = WPBYEntry.Instance.GetMagnificationToFishID(fishId);
            if (this.goldlist.Count >= 3)
            {
                UnityEngine.Object.Destroy(this.goldlist.Dequeue());
            }
            GameObject obj = UnityEngine.Object.Instantiate(this.playerGoldChangeGroup.GetChild(0).gameObject);
            obj.transform.SetParent(this.playerGoldChangeGroup);
            obj.transform.localPosition = Vector3.zero;
            obj.transform.localRotation = Quaternion.identity;
            obj.transform.localScale = Vector3.one;
            obj.transform.FindChildDepth<Slider>("Slider").value = 0;
            obj.gameObject.SetActive(true);
            int max = 1000;
            int h = (int)(30 * 212 * magnificat) / max;
            obj.transform.FindChildDepth<TextMeshProUGUI>("Slider/Handle Slide Area/Handle/Num").text = "";
            ToolHelper.RunGoal(0, magnificat / 30f, 0.5f, value =>
            {
                if (obj == null) return;
                obj.transform.FindChildDepth<Slider>("Slider").value = float.Parse(value);
            }).SetEase(DG.Tweening.Ease.Linear);
            this.goldlist.Enqueue(obj.gameObject);
        }

        public void OnJoinSuperPowrModel(bool isJoin)
        {
            this.isSuperMode = isJoin;
            OnSetUserGunLevel(this.gunLevel, this.gungrade);
        }
        public void SendBulltPackIsLock(int fishId)
        {
            if (this.IsLock)
            {
                DebugHelper.Log($"锁定鱼：{fishId}");
                WPBY_Fish fish = WPBY_FishController.Instance.GetFish(fishId);
                if (fish != null)
                {
                    this.LockFish = fish;
                    this.lockTag = this.LockFish.transform.Find("Lock");
                    this.IsLock = true;
                    this.dir = fish.transform.position;
                    WPBY_Struct.PlayerLock player = new WPBY_Struct.PlayerLock();
                    player.chairID = (byte)data.ChairId;
                    player.fishId = fishId;
                    HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, WPBY_Network.SUB_C_PlayerLock, player.ByteBuffer, SocketType.Game);
                }
            }
        }

        private void SetLockFish(int fishId)
        {
            this.IsLock = true;
            if (this.lockObj == null) {
                this.lockObj = UnityEngine.Object.Instantiate(WPBYEntry.Instance.lockNode.GetChild(0).gameObject).transform;
                this.lockObj.transform.SetParent(WPBYEntry.Instance.lockNode);
                this.lockObj.transform.localPosition = Vector3.zero;
                this.lockObj.transform.localScale = Vector3.one;
            }
            WPBY_Fish fish = WPBY_FishController.Instance.GetFish(fishId);
            if (fish != null && fish.IsToSence()) {
                this.LockFish = fish;
                this.lockTag = this.LockFish.transform.Find("Lock");
            }
            else
            {
                while (true) {
                    fish = WPBY_FishController.Instance.OnGetRandomLookFish(false);
                    if (fish != null && fish.IsToSence()) {
                        this.LockFish = fish;
                        this.lockTag = this.LockFish.transform.Find("Lock");
                        break;
                    }
                    if (!this.IsLock) break;
                }
            }
            if (fish != null) {
                this.dir = fish.transform.position;
                this.lockObj.gameObject.SetActive(true);
            }
        }
    }
}