using DG.Tweening;
using System;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace Hotfix.LTBY
{
    public class LTBY_GameView : LTBY_ViewBase
    {
        private bool isFirstEnter;
        public int gun_level;
        private bool lastRageStatus;
        private bool lastAutoShootStatus;
        private bool lastLockFishStatus;
        private bool lastMultiShootStatus;
        private List<GunInfoData> gunInfo;
        private int lastGunLevel;
        private int curTableId;
        public new bool isTop = false;
        private Dictionary<int, Transform> playerList = new Dictionary<int, Transform>();
        private Dictionary<int, Transform> nameFrameList = new Dictionary<int, Transform>();
        private Dictionary<int, Transform> scoreFrameList = new Dictionary<int, Transform>();
        private Dictionary<int, NumberRoller> scoreList = new Dictionary<int, NumberRoller>();
        private Dictionary<int, Transform> batteryFrameList = new Dictionary<int, Transform>();
        private Dictionary<int, Transform> batteryList = new Dictionary<int, Transform>();
        private Dictionary<int, Transform> waitFrameList = new Dictionary<int, Transform>();
        private Dictionary<int, Transform> lockEffectList = new Dictionary<int, Transform>();
        private Dictionary<int, Transform> rageEffectList = new Dictionary<int, Transform>();
        private Dictionary<int, Transform> locationEffectList = new Dictionary<int, Transform>();
        private Dictionary<int, Transform> multiShootEffectList = new Dictionary<int, Transform>();
        private Dictionary<int, bool> playerRunInBackground = new Dictionary<int, bool>();
        private Dictionary<int, Transform> effectList = new Dictionary<int, Transform>();
        private Dictionary<int, Transform> coinList = new Dictionary<int, Transform>();
        public int chairId = -1;

        private int arena;
        private int showUiActionKey;
        private bool showUiFlag;
        private Transform btnShowUi;
        private Transform btnShop;
        private Transform btnAutoShoot;
        private Transform btnAutoShootActive;
        private Transform btnMultiShoot;
        private Transform btnMultiShootActive;
        private Transform btnRageShoot;
        private Transform btnRageShootActive;
        private Transform btnLockFish;
        private Transform btnLockFishActive;
        private Transform btnLockFishEffect;
        private Image lockFishImage;
        private int lockFishType;
        private long userScore;
        private Button btnMinus;
        private Button btnPlus;
        private bool isFreeBatteryMode;
        public GameUserData UserData { get; set; }
        public static LTBY_GameView GameInstance { get; set; }

        public LTBY_GameView() : base(nameof(LTBY_GameView), false)
        {
            //是否第一次进入  不是说明是游戏内切换桌子
            GameInstance = this;
            this.isFirstEnter = true;
            //记录上一场的选中炮台

            this.gun_level = 1;
            //上一场是否打开狂暴模式 用于游戏内切换桌子

            this.lastRageStatus = false;

            this.lastAutoShootStatus = false;

            this.lastLockFishStatus = false;

            this.lastMultiShootStatus = false;

            this.lastGunLevel = 1; //服务器传过来的上一次使用的炮台等级


            this.curTableId = 0; //当前的桌子id
            playerList?.Clear();
            nameFrameList?.Clear();
            scoreFrameList?.Clear();
            scoreList?.Clear();
            batteryFrameList?.Clear();
            batteryList?.Clear();
            waitFrameList?.Clear();
            lockEffectList?.Clear();
            rageEffectList?.Clear();
            locationEffectList?.Clear();
            multiShootEffectList?.Clear();
            playerRunInBackground?.Clear();
            effectList?.Clear();
            coinList?.Clear();
        }

        protected override void OnCreate(params object[] args)
        {
            base.OnCreate(args);
            System.GC.Collect();
            Resources.UnloadUnusedAssets();

            LTBYEntry.Instance.EnterGame();

            LTBYEntry.Instance.SetLowPower(3);


            InitDataList(1);
            curTableId = 0;

            InitView();

            InitSkill();

            RegisterEvent();
        }

        private void InitView()
        {
            //LTBY_ViewManager.Instance.Open<LTBY_MatchGiftBtnView>();
            //LTBY_ViewManager.Instance.Open<LTBY_SwitchGameView>();
            //LTBY_ViewManager.Instance.Open<LTBY_JackpotView>();
            LTBY_ViewManager.Instance.Open<LTBY_MenuView>();
            LTBY_ViewManager.Instance.Open<LTBY_ChatView>();
            //LTBY_ViewManager.Instance.Open<LTBY_ScratchCardView>();
            //LTBY_ViewManager.Instance.Open<LTBY_FreeLotteryView>();
            //LTBY_ViewManager.Instance.Open<LTBY_SpecialItemView>();
            //LTBY_ViewManager.Instance.Open<LTBY_SummonView>();
            //LTBY_ViewManager.Instance.Open<LTBY_FishMatchView>();
            for (int i = 0; i < LTBY_DataConfig.GAME_PLAYER; i++)
            {
                transform.FindChildDepth<Text>($"Player{i}/Frame/Active/WaitFrame/Text").text =
                    GameViewConfig.Text.Wait;
                transform.FindChildDepth<Text>($"Player{i}/Frame/Background/Text").text = GameViewConfig.Text.Reconnect;
            }
        }

        private void SetSelfChairId(int _chairId)
        {
            this.chairId = _chairId;
            Transform gameLayer = LTBYEntry.Instance.GetGameLayer();
            gameLayer.transform.eulerAngles = CheckIsTop() ? new Vector3(0, 0, 180) : new Vector3(0, 0, 0);
        }

        public int GetSelfChairId()
        {
            return this.chairId;
        }

        /// <summary>
        /// 是否是自己
        /// </summary>
        /// <param name="_chairId">椅子号</param>
        /// <returns></returns>
        public bool IsSelf(int _chairId)
        {
            return this.chairId == _chairId;
        }

        public bool IsPlayerRunInBackground(int _chairId)
        {
            return this.playerRunInBackground.ContainsKey(_chairId);
        }

        public bool IsPlayerInRoom(int _chairId)
        {
            return this.playerList.ContainsKey(_chairId);
        }


        public void OpenSelectBattery()
        {
            LTBY_SelectBattery box = LTBY_ViewManager.Instance.GetMessageBox<LTBY_SelectBattery>();
            if (box != null)
            {
                box.Show();
            }
            else
            {
                box = LTBY_ViewManager.Instance.OpenMessageBox<LTBY_SelectBattery>();
            }

            if (this.gunInfo != null)
            {
                box.InitContent(this.gunInfo, this.lastGunLevel);
            }
        }

        private void InitPlayer(int _chairId, GameUserData data)
        {
            if (_chairId == this.chairId && this.playerList.ContainsKey(_chairId))
            {
                //自己需要刷新的数据

                //上报自己切回前台的信息
                LTBY_DataReport.Instance.ReportBackFromBackground((ulong) this.userScore, data.Gold, this.chairId);


                this.userScore = (long) data.Gold;
                SetScore(this.chairId, this.userScore);
                //收到ready包之后才能开始发射子弹;
                LTBY_BatteryManager.Instance.SetCanShoot(true);
                return;
            }

            Transform player = transform.FindChildDepth($"Player{GetPlayerPosition(_chairId)}");
            if (this.playerList.ContainsKey(_chairId)) playerList.Remove(_chairId);
            this.playerList.Add(_chairId, player);

            BatteryPosition posConfig = GameViewConfig.Position[GetPlayerPosition(_chairId)];

            effectList.Add(_chairId, player.FindChildDepth("Frame/Active/EffectFrame"));

            Transform scoreFrame = player.FindChildDepth("Frame/Active/ScoreFrame");
            scoreFrame.gameObject.SetActive(true);
            scoreFrame.localPosition = posConfig.ScoreFrame;
            Transform compNum = scoreFrame.FindChildDepth("Num");
            NumberRoller comp = compNum.GetILComponent<NumberRoller>();
            if (comp == null)
            {
                comp = compNum.AddILComponent<NumberRoller>();
            }

            comp.Init(false, false);

            comp.text =$"{data.Gold.ShortNumber()}";
            scoreList.Add(_chairId, comp);
            this.coinList.Add(_chairId, scoreFrame.FindChildDepth("Coin"));
            this.scoreFrameList.Add(_chairId, scoreFrame);

            Transform nameFrame = player.FindChildDepth("Frame/Active/NameFrame");
            nameFrame.gameObject.SetActive(true);
            nameFrame.localPosition = posConfig.NameFrame;
            this.nameFrameList.Add(_chairId, nameFrame);

            nameFrame.FindChildDepth("Medal").gameObject.SetActive(false);

            Transform batteryFrame = player.FindChildDepth("Frame/Active/BatteryFrame");
            batteryFrame.gameObject.SetActive(true);
            batteryFrame.localPosition = posConfig.BatteryFrame;
            this.batteryFrameList.Add(_chairId, batteryFrame);

            this.batteryList.Add(_chairId, batteryFrame.FindChildDepth("Base"));

            if (_chairId == this.chairId)
            {
                nameFrame.FindChildDepth<Text>("Name").text = data.NickName.Length >= 6
                    ? $"{data.NickName.Substring(0, 6)}..."
                    : data.NickName;

                this.coinList[_chairId].FindChildDepth("Plus").gameObject.SetActive(true);

                AddClick(this.scoreFrameList[_chairId], (go, eventData) =>
                {
                    //LTBY_ViewManager.Instance.Open<LTBY_ShopView>();
                });

                LTBY_BatteryManager.Instance.CreateBattery(_chairId, true, this.batteryList[_chairId]);
                this.btnMinus = batteryFrame.FindChildDepth<Button>("BtnMinus");
                this.btnMinus.gameObject.SetActive(true);
                AddClick(this.btnMinus.transform,
                    (go, eventData) => LTBY_BatteryManager.Instance.AdjustBatteryRatio(false));
                this.btnPlus = batteryFrame.FindChildDepth<Button>("BtnPlus");
                this.btnPlus.gameObject.SetActive(true);
                AddClick(this.btnPlus.transform,
                    (go, eventData) => LTBY_BatteryManager.Instance.AdjustBatteryRatio(true));

                this.userScore = (long) data.Gold;
                SendSelectBattery();
                LTBY_DataReport.Instance.SetEnterScore(this.userScore);
            }
            else
            {
                string nickName = data.NickName.Length >= 6
                    ? $"{data.NickName.Substring(0, 6)}..."
                    : data.NickName;
                nameFrame.FindChildDepth<Text>("Name").text = $"{nickName}";
                this.coinList[_chairId].FindChildDepth("Plus").gameObject.SetActive(false);

                LTBY_BatteryManager.Instance.CreateBattery(_chairId, false, this.batteryList[_chairId]);
                Transform _btnMinus = batteryFrame.FindChildDepth("BtnMinus");
                _btnMinus.gameObject.SetActive(false);

                Transform _btnPlus = batteryFrame.FindChildDepth("BtnPlus");
                _btnPlus.gameObject.SetActive(false);
                LTBY_BatteryManager.Instance.SetRageShoot(_chairId, false);
                //切后台状态
                //if data.status == 3 then
                //          self:OnUserRunBackground(chairId,true);
                //else
                //	self:OnUserRunBackground(chairId,false);
                //      end
            }


            LTBY_BatteryManager.Instance.SetLevel(_chairId, 1);
            LTBY_BatteryManager.Instance.SetRatio(_chairId, 1);

            Transform waitFrame = player.FindChildDepth("Frame/Active/WaitFrame");
            waitFrame.gameObject.SetActive(false);
            this.waitFrameList[_chairId] = waitFrame;
            OnSetProbability(data.ChairId);
        }

        private void SendSelectBattery()
        {
            if (this.isFirstEnter)
            {
                OpenSelectBattery();
                this.isFirstEnter = false;
            }
            else
            {
                //              GC.NetworkRequest.Request("CSSetProbability",{
                //                  gun_level = this.gun_level,
                //});
                LTBY_Struct.PlayerChangeGunLevel playerChangeGunLevel = new LTBY_Struct.PlayerChangeGunLevel
                {
                    gunGrade = (byte)this.gun_level, gunLevel =0, wChairId = this.chairId
                };
                LTBY_Network.Instance.Send(LTBY_Network.SUB_C_CHANGEBULLETLEVEL, playerChangeGunLevel.Buffer);
                SetRageShoot(this.lastRageStatus);
                SetAutoShoot(this.lastAutoShootStatus);
                SetLockFish(this.lastLockFishStatus);
                SetMultiShoot(this.lastMultiShootStatus);
            }
        }

        private void ClearMananger(int _chairId)
        {
            if (_chairId < 0) return;
            LTBY_FishManager.Instance.UnLockFish(_chairId);
            LTBY_BatteryManager.Instance.DestroyBattery(_chairId);
            LTBY_BulletManager.Instance.DestroyPlayerBullet(_chairId);
            LTBY_EffectManager.Instance.DestroyPlayerEffect(_chairId);
        }

        private void RemovePlayer(int _chairId)
        {
            //在loading界面退出，服务器依然发退出包过来，这个时候还没有创建过这个玩家，所以return
            if (!this.playerList.ContainsKey(_chairId)) return;
            LTBY_BulletManager.Instance.DestroyWaterSpout(_chairId);
            OnUserRunBackground(_chairId, false);

            ClearMananger(_chairId);

            this.scoreFrameList[_chairId].gameObject.SetActive(false);

            this.nameFrameList[_chairId].gameObject.SetActive(false);

            this.batteryFrameList[_chairId].gameObject.SetActive(false);
            ShowFreeLottery(_chairId, false);

            this.waitFrameList[_chairId].gameObject.SetActive(true);

            this.nameFrameList.Remove(_chairId);
            this.scoreList.Remove(_chairId);
            this.effectList.Remove(_chairId);
            this.coinList.Remove(_chairId);
            this.scoreFrameList.Remove(_chairId);
            this.batteryFrameList.Remove(_chairId);
            this.batteryList.Remove(_chairId);
            this.waitFrameList.Remove(_chairId);
            this.playerList.Remove(_chairId);

            if (_chairId == this.chairId)
            {
                RemoveLockEffect(_chairId);
                RemoveRageEffect(_chairId);
            }

            RemoveLocationEffect(_chairId);
        }

        public void SetAdjustRatioEnable(int _chairId, bool flag)
        {
            if (_chairId != this.chairId) return;
            this.btnMinus.interactable = flag;
            this.btnPlus.interactable = flag;
        }

        public bool CheckIsFreeMode()
        {
            return this.isFreeBatteryMode;
        }

        public long GetUserScore()
        {
            return this.userScore;
        }
        public void AddScore(int _chairId, long delta)
        {
            // if (_chairId != this.chairId) return;
            // this.userScore += delta;
            // SetScore(_chairId, this.userScore);
        }

        public bool MinusScore(int _chairId, long delta)
        {
            if (_chairId != this.chairId) return true;
            if (this.userScore - delta < 0)
            {
                MoneyInsufficient();
                return false;
            }

            // this.userScore -= delta;
            // SetScore(_chairId, this.userScore);

            return true;
        }

        public void MoneyInsufficient()
        {
            LTBY_BatteryManager.Instance.SetCanShoot(false);
            SetAutoShoot(false);
            SetLockFish(false);
            SetMultiShoot(false);
            LTBY_Messagebox tipBox = LTBY_ViewManager.Instance.OpenMessageBox<LTBY_Messagebox>();
            tipBox.SetTitle(MessageBoxConfig.Title);
            tipBox.SetText(MessageBoxConfig.GoToShopTip);
            tipBox.SetCloseFunc(() =>
            {
                //Action action = BackToSelectArena;
                //LTBY_ViewManager.Instance.Open<LTBY_CountDownView>(GameViewConfig.Text.SyncServerData, 3, action);
                //LTBY_BatteryManager.Instance.SetCanShoot(true);
            });
            tipBox.ShowBtnConfirm(()=>
            {
                Action action = BackToSelectArena;
                LTBY_ViewManager.Instance.Open<LTBY_CountDownView>(GameViewConfig.Text.SyncServerData, 3, action);
                //LTBY_ViewManager.Instance.Open<LTBY_ShopView>();
            }, true);
        }

        public void SetScore(int _chairId, long score)
        {
            if (IsSelf(_chairId)) userScore = score;
            if (this.scoreList.ContainsKey(_chairId))
            {
                this.scoreList[_chairId].text = score.ShortNumber().ToString();
            }
        }

        public void CreateAddUserScoreItem(int _chairId, long score, bool serial = false)
        {
            if (!this.playerList.ContainsKey(_chairId)) return;

            Transform coin = this.coinList[_chairId];
            {
                Sequence key = DOTween.Sequence();
                key.Append(coin.DOScale(1.6f, 0.1f).SetEase(Ease.Linear).SetLink(coin.gameObject));
                key.Append(coin.DOScale(1f, 0.1f).SetEase(Ease.Linear).SetLink(coin.gameObject));
                key.SetLink(coin.gameObject);
                RunAction(key);
            }
            string _prefabName = null;

            if (_chairId == this.chairId)
            {
                LTBY_Audio.Instance.Play(SoundConfig.GetCoin);
                _prefabName = "LTBY_SelfAddScoreItem";
            }
            else
            {
                _prefabName = "LTBY_OtherAddScoreItem";
            }

            Transform item = LTBY_PoolManager.Instance.GetUiItem(_prefabName, this.scoreFrameList[_chairId]);

            NumberRoller roller = item.gameObject.GetILComponent<NumberRoller>();
            if (roller == null)
            {
                roller = item.gameObject.AddILComponent<NumberRoller>();
            }

            roller.Init();
            roller.text = $"+{score.ShortNumber()}";

            float offsetY = serial ? 110 : 50;
            if (CheckIsOtherSide(_chairId))
            {
                offsetY = -offsetY;

                item.GetComponent<RectTransform>().anchoredPosition = new Vector3(0, -20, 0);
            }
            else
            {
                offsetY = offsetY;
                item.GetComponent<RectTransform>().anchoredPosition = new Vector3(0, 20, 0);
            }

            if (serial)
            {
                Sequence key = DOTween.Sequence();
                Sequence _key1 = DOTween.Sequence();
                var t = item.GetComponent<TextMeshProUGUI>();
                _key1.Append(t.DOFade(255f / 255, 0.01f).SetEase(Ease.Linear).SetLink(item.gameObject));
                _key1.Append(item.DOBlendableLocalMoveBy(new Vector3(0, offsetY, 0), 0.7f).SetEase(Ease.OutSine).SetLink(item.gameObject));
                _key1.Append(t.DOFade(0f / 255, 0.2f).SetEase(Ease.Linear).SetLink(item.gameObject));
                key.Append(_key1);
                Sequence _key2 = DOTween.Sequence();
                _key2.Append(item.DOScale(1, 0.01f).SetDelay(0.1f).SetLink(item.gameObject));
                _key2.Append(item.DOScale(new Vector3(1.1f, 1.1f), 0.2f).SetLink(item.gameObject));
                _key2.Append(item.DOScale(new Vector3(1, 1), 0.2f).SetLink(item.gameObject).OnKill(() => LTBY_PoolManager.Instance.RemoveUiItem(_prefabName, item)));
                _key1.SetLink(item.gameObject);
                _key2.SetLink(item.gameObject);
                key.SetLink(item.gameObject);
                key.Insert(0, _key2);
                RunAction(key);
            }
            else
            {
                Sequence key = DOTween.Sequence();
                key.Append(item.GetComponent<TextMeshProUGUI>().DOFade(255f / 255, 0.01f).SetEase(Ease.Linear));
                key.Append(item.DOBlendableLocalMoveBy(new Vector3(0, offsetY, 0), 0.7f).SetEase(Ease.OutSine));
                key.Append(item.GetComponent<TextMeshProUGUI>().DOFade(0f / 255, 0.2f).SetEase(Ease.Linear));
                key.OnKill(() => LTBY_PoolManager.Instance.RemoveUiItem(_prefabName, item));
                key.SetLink(item.gameObject);
                RunAction(key);
            }
        }

        private void ShowFreeLottery(int _chairId, bool flag)
        {
            this.batteryFrameList[_chairId].FindChildDepth("FreeLottery").gameObject.SetActive(flag);
        }

        private void CreateLockEffect(int _chairId)
        {
            if (this.chairId < 0) return;

            if (_chairId != this.chairId) return;

            if (this.lockEffectList.ContainsKey(_chairId)) return;

            Transform parent = this.playerList[_chairId].FindChildDepth("Frame/Active");
            this.lockEffectList.Add(_chairId, LTBY_Extend.Instance.LoadPrefab("LTBY_LockEffect", parent));
            this.lockEffectList[_chairId].localPosition = this.batteryFrameList[_chairId].localPosition;
        }

        private void RemoveLockEffect(int _chairId)
        {
            if (!this.lockEffectList.ContainsKey(_chairId)) return;

            LTBY_Extend.Destroy(this.lockEffectList[_chairId].gameObject);
            this.lockEffectList.Remove(_chairId);
        }

        private void CreateRageEffect(int _chairId)
        {
            if (this.chairId < 0) return;

            if (_chairId != this.chairId) return;

            if (this.rageEffectList.ContainsKey(_chairId)) return;

            Transform parent = this.playerList[_chairId].FindChildDepth("Frame/Active");
            this.rageEffectList.Add(_chairId, LTBY_Extend.Instance.LoadPrefab("LTBY_RageEffect", parent));
            this.rageEffectList[_chairId].localPosition = this.batteryFrameList[_chairId].localPosition;
        }

        private void RemoveRageEffect(int _chairId)
        {
            if (!this.rageEffectList.ContainsKey(_chairId)) return;

            LTBY_Extend.Destroy(this.rageEffectList[_chairId].gameObject);
            this.rageEffectList.Remove(_chairId);
        }

        private void CreateMultiShootEffect(int _chairId)
        {
            if (this.chairId < 0) return;

            if (_chairId != this.chairId) return;

            if (this.multiShootEffectList.ContainsKey(_chairId)) return;
            Transform parent = this.playerList[_chairId].FindChildDepth("Frame/Active");
            this.multiShootEffectList.Add(_chairId, LTBY_Extend.Instance.LoadPrefab("LTBY_MultiShootEffect", parent));
            this.multiShootEffectList[_chairId].localPosition = this.batteryFrameList[_chairId].localPosition;
        }

        private void RemoveMultiShootEffect(int _chairId)
        {
            if (!this.multiShootEffectList.ContainsKey(_chairId)) return;
            LTBY_Extend.Destroy(this.multiShootEffectList[_chairId].gameObject);
            this.multiShootEffectList.Remove(_chairId);
        }

        private void OnSetProbability(int _chairId)
        {
            //自己设置完炮台之后创建位置特效
            if (_chairId == this.chairId)
            {
                CreateSelfLocationEffect(null);
            }
        }

        /// <summary>
        /// 第一次选择炮台之后会触发的操作
        /// </summary>
        private void OperateAfterSelectBattery()
        {
            //LTBY_ViewManager.Instance.GetView<LTBY_FreeLotteryView>().UpdateAwardPool();
        }

        private void CreateSelfLocationEffect(object vip)
        {
            if (this.locationEffectList.ContainsKey(this.chairId)) return;

            Transform parent = this.playerList[this.chairId].FindChildDepth("Frame/Active");
            Transform effect = LTBY_Extend.Instance.LoadPrefab("LTBY_LocationEffect", parent);
            effect.position = this.batteryFrameList[this.chairId].position;
            Transform level = effect.FindChildDepth("Level1");
            level.gameObject.SetActive(true);
            level.FindChildDepth("Medal").gameObject.SetActive(false);
            this.locationEffectList[this.chairId] = effect;

            DelayRun(4, () => HideLocationEffect(this.chairId));

            OperateAfterSelectBattery();
        }

        private void CreateOtherLocationEffect(int _chairId, object vip)
        {
            if (this.locationEffectList.ContainsKey(_chairId)) return;
            //Transform medalCfg = MedalConfig.GetConfigByLevel(vip);
            //if (medalCfg != null)
            //{

            //Transform parent = this.playerList[chairId].FindChildDepth("Frame/Active");
            //Transform effect = LTBY_Extend.Instance.LoadPrefab("LTBY_LocationEffect", parent);
            //effect.position = this.batteryFrameList[chairId].position;
            //Transform level = effect.FindChildDepth($"Level{medalCfg.effectLevel}");
            //level.gameObject.SetActive(true);
            //level.FindChildDepth("Text1").gameObject.SetActive(false);
            //level.FindChildDepth("biao").gameObject.SetActive(false);
            //level.FindChildDepth("biao2").gameObject.SetActive(false);

            //Image image = level.FindChildDepth<Image>("Medal/Image");
            //image.sprite = LTBY_Extend.Instance.LoadSprite(medalCfg.imageBundleName, medalCfg.imageName);
            //image.SetNativeSize();
            //level.FindChildDepth<Text>("Medal/Text").text = $"{medalCfg.name}{MedalConfig.Sit}";

            //if (CheckIsOtherSide(chairId))
            //{
            //    effect.localEulerAngles = new Vector3(0, 0, 180);
            //level.FindChildDepth("Medal").localEulerAngles = new Vector3(0, 0, 180);
            //}

            //DelayRun(4, delegate ()
            //{
            //    HideLocationEffect(chairId);
            //});
            //this.locationEffectList[chairId] = effect;
            //}
        }

        private void HideLocationEffect(int _chairId)
        {
            if (!this.locationEffectList.ContainsKey(_chairId)) return;
            this.locationEffectList[_chairId].gameObject.SetActive(false);
        }

        private void RemoveLocationEffect(int _chairId)
        {
            if (!this.locationEffectList.ContainsKey(_chairId)) return;
            LTBY_Extend.Destroy(this.locationEffectList[_chairId].gameObject);
            this.locationEffectList.Remove(_chairId);
        }

        public Vector3 GetCoinWorldPos(int _chairId)
        {
            Transform coin = this.coinList[_chairId];
            return coin != null ? coin.position : new Vector3(-99999, 0, 0);
        }

        public Vector3 GetEffectWorldPos(int _chairId)
        {
            return this.effectList.ContainsKey(_chairId) ? this.effectList[_chairId].position : new Vector3(-99999, 0, 0);
        }

        public Vector3 GetBatteryWorldPos(int _chairId)
        {
            return this.batteryList[_chairId].position;
        }

        private void InitSkill()
        {
            showUiActionKey = -1;
            showUiFlag = true;

            btnShowUi = transform.FindChildDepth("BtnShowUi");
            btnShowUi.FindChildDepth("Open").gameObject.SetActive(!showUiFlag);
            btnShowUi.FindChildDepth("Close").gameObject.SetActive(showUiFlag);
            AddClick(btnShowUi.FindChildDepth("Btn"), () => LTBY_Event.DispatchShowGameUi(!showUiFlag));

            btnShop = transform.FindChildDepth("BtnShop");
            btnShop.FindChildDepth("Effect").gameObject.SetActive(false);
            //打开商店
            //AddClick(this.btnShop, function()
            // GC.ViewManager.Open("LTBY_ShopView");
            //end);

            Transform skillPanel = transform.FindChildDepth("Skill");
            //skillPanel.localPosition = canMulti and Vector3(-38,-285,0) or Vector3(0,-285,0);

            btnAutoShoot = skillPanel.FindChildDepth("Auto");
            btnAutoShootActive = btnAutoShoot.FindChildDepth("Active");
            btnAutoShootActive.gameObject.SetActive(false);
            AddClick(btnAutoShoot, () =>
            {
                bool flag = !btnAutoShootActive.gameObject.activeSelf;
                SetAutoShoot(flag);
            });

            btnMultiShoot = skillPanel.FindChildDepth("Multi");
            btnMultiShootActive = btnMultiShoot.FindChildDepth("Active");
            btnMultiShootActive.gameObject.SetActive(false);
            AddClick(btnMultiShoot, () =>
            {
                bool flag = !btnMultiShootActive.gameObject.activeSelf;
                SetMultiShoot(flag);
            });

            btnRageShoot = skillPanel.FindChildDepth("Rage");
            btnRageShootActive = btnRageShoot.FindChildDepth("Active");
            btnRageShootActive.gameObject.SetActive(false);
            AddClick(btnRageShoot, () =>
            {
                LTBY_Messagebox tipBox = LTBY_ViewManager.Instance.OpenMessageBox<LTBY_Messagebox>();
                tipBox.SetTitle(MessageBoxConfig.Title);
                tipBox.SetText(MessageBoxConfig.OpenRageFail);
                tipBox.ShowBtnConfirm(() =>
                {
                    //LTBY_ViewManager.Instance.Open("LTBY_ShopView");
                }, true, MessageBoxConfig.GoTo);
            });

            btnLockFish = skillPanel.FindChildDepth("Lock");
            btnLockFishActive = btnLockFish.FindChildDepth("Active");
            btnLockFishActive.gameObject.SetActive(false);
            btnLockFishEffect = btnLockFish.FindChildDepth("PressEffect");
            btnLockFishEffect.gameObject.SetActive(false);
            lockFishImage = btnLockFish.FindChildDepth<Image>("Fish");
            lockFishType = 0;

            LongClickData longClickData = new LongClickData()
            {
                funcClick = (obj,eventData)=>
                {
                    DebugHelper.LogError($"点击锁定");
                    bool flag = !btnLockFishActive.gameObject.activeSelf;
                    SetLockFish(flag);
                },
                funcLongClick = (obj,eventData)=>
                {
                    btnLockFishEffect.gameObject.SetActive(false);
                    LTBY_ViewManager.Instance.OpenMessageBox<LTBY_LockFish>();
                },
                funcDown = (obj,eventData)=>
                {
                    btnLockFishEffect.gameObject.SetActive(true);
                },
                funcUp = (obj,eventData)=>
                {
                    btnLockFishEffect.gameObject.SetActive(false);
                },
                time = 1,
            };
            AddLongClick(btnLockFish, longClickData);
        }

        public void ToggleGameViewSkill(PlayShootState data)
        {
            btnMultiShoot.gameObject.SetActive(data.multi_shoot);
            btnRageShoot.gameObject.SetActive(data.crazy_speed);
        }

        private void ShowGameUi(bool flag)
        {
            if (showUiActionKey > 0) return;

            showUiFlag = flag;

            btnShowUi.FindChildDepth("Open").gameObject.SetActive(!flag);
            btnShowUi.FindChildDepth("Close").gameObject.SetActive(flag);
            // int showUIStatus = 1; //0:打开,1:关闭

            if (flag)
            {
                showUiActionKey = RunAction(btnShop
                    .DOLocalMove(new Vector3(-GameViewConfig.ShowGameUi.Dis, 0), GameViewConfig.ShowGameUi.Time)
                    .SetEase(Ease.OutBack).OnKill(() =>
                    {
                        StopAction(showUiActionKey);
                        showUiActionKey = -1;
                    }).SetLink(btnShop.gameObject));
                // showUIStatus = 0;
                Transform btn = btnShowUi.FindChildDepth("Btn");
                RunAction(DOTween.To(value =>
                {
                    if (btn == null) return;
                    float t = value * 0.01f;
                    btn.localEulerAngles = new Vector3(0, 0, -180 * (1 - t));
                }, 0, 100, GameViewConfig.ShowGameUi.Time).SetEase(Ease.Linear).SetLink(btn.gameObject));
            }
            else
            {
                showUiActionKey = RunAction(btnShop
                    .DOLocalMove(new Vector3(GameViewConfig.ShowGameUi.Dis, 0), GameViewConfig.ShowGameUi.Time)
                    .SetEase(Ease.InBack).OnKill(() =>
                    {
                        StopAction(showUiActionKey);
                        showUiActionKey = -1;
                    }).SetLink(btnShop.gameObject));

                Transform btn = btnShowUi.FindChildDepth("Btn");
                RunAction(DOTween.To(value =>
                {
                    if (btn == null) return;
                    float t = value * 0.01f;
                    btn.localEulerAngles = new Vector3(0, 0, -180 * t);
                }, 0, 100, GameViewConfig.ShowGameUi.Time).SetEase(Ease.Linear).SetLink(btn.gameObject));

                // showUIStatus = 1;
            }

            //请求商店CSUserEvent
            //GC.NetworkRequest.Request("CSUserEvent",{
            //    id = GC.GameViewConfig.UserEventId.HideIcon,
            //	status = showUIStatus,
            //});
        }

        /// <summary>
        /// 设置狂暴射击 hideEffect:默认为nil(false) 只有当游戏内切换房间时候 不需要显示特效与提示所以设置为true
        /// </summary>
        /// <param name="flag"></param>
        /// <param name="hideEffect"></param>
        private void SetRageShoot(bool flag, bool hideEffect = false)
        {
            btnRageShootActive.gameObject.SetActive(flag);
            LTBY_BatteryManager.Instance.SetRageShoot(chairId, flag);

            if (flag)
            {
                if (!hideEffect)
                {
                    if (LTBY_BatteryManager.Instance.GetFreeBattery(this.chairId) != null)
                    {
                        LTBY_ViewManager.Instance.ShowTip(GameViewConfig.Text.RageShootInvalid);
                    }
                }
                else
                {
                    LTBY_ViewManager.Instance.ShowTip(GameViewConfig.Text.OpenRageShoot);
                }

                LTBY_Audio.Instance.Play(SoundConfig.OpenRage);
                CreateRageEffect(this.chairId);
            }

            else
            {
                RemoveRageEffect(this.chairId);
            }

            //           GC.NetworkRequest.Request("CSCrazySkill",{
            //               is_open = flag,
            //});
        }

        /// <summary>
        /// 设置自动射击 hideEffect:默认为nil(false) 只有当游戏内切换房间时候 不需要显示特效与提示所以设置为true
        /// </summary>
        /// <param name="flag"></param>
        /// <param name="hideEffect"></param>
        private void SetAutoShoot(bool flag, bool hideEffect = false)
        {
            this.btnAutoShootActive.gameObject.SetActive(flag);
            LTBY_BatteryManager.Instance.SetAutoShoot(flag);
            if (flag && !hideEffect)
            {
                LTBY_ViewManager.Instance.ShowTip(GameViewConfig.Text.OpenAutoShoot);
            }
        }

        /// <summary>
        /// 设置自动射击 hideEffect:默认为nil(false) 只有当游戏内切换房间时候 不需要显示特效与提示所以设置为true
        /// </summary>
        /// <param name="flag"></param>
        /// <param name="hideEffect"></param>
        public void SetLockFish(bool flag, bool hideEffect = false)
        {
            this.btnLockFishActive.gameObject.SetActive(flag);
            if (flag)
            {
                if (!hideEffect)
                {
                    LTBY_ViewManager.Instance.ShowTip(GameViewConfig.Text.OpenLockFish);
                    LTBY_Audio.Instance.Play(SoundConfig.OpenLock);
                    CreateLockEffect(this.chairId);
                }
            }
            else
            {
                RemoveLockEffect(this.chairId);
            }

            this.btnLockFishEffect.gameObject.SetActive(false);
            LTBY_BatteryManager.Instance.SetLockShoot(this.chairId, flag);
            LTBY_FishManager.Instance.SetLockFishSwitch(flag);
        }

        private void SetMultiShoot(bool flag, bool hideEffect = false)
        {
            this.btnMultiShootActive.gameObject.SetActive(flag);
            LTBY_BatteryManager.Instance.SetMultiShoot(this.chairId, flag);
            if (flag)
            {
                if (hideEffect) return;
                LTBY_ViewManager.Instance.ShowTip(GameViewConfig.Text.OpenMultiShoot);
                CreateMultiShootEffect(this.chairId);
                LTBY_Audio.Instance.Play(SoundConfig.OpenMultiShoot);
            }
            else
            {
                RemoveMultiShootEffect(this.chairId);
            }

            //       GC.NetworkRequest.Request("CSUserEvent",{
            //               id = GC.GameViewConfig.UserEventId.MultiShoot,
            //	status = flag ? 0 : 1,
            //});
        }

        public void ShowLockFishImage(bool flag, int _chairId, int fishType = 0)
        {
            if (_chairId != this.chairId) return;

            if (flag)
            {
                if (this.lockFishType == fishType) return;
                this.lockFishType = fishType;
                this.lockFishImage.gameObject.SetActive(true);
                string imageBundle = FishConfig.GetFishImageBundle(fishType);

                this.lockFishImage.GetComponent<Image>().sprite =
                    LTBY_Extend.Instance.LoadSprite(imageBundle, $"fish_{fishType}");
            }
            else
            {
                this.lockFishType = 0;
                this.lockFishImage.gameObject.SetActive(false);
            }
        }

        public int GetPlayerPosition(int _chairId)
        {
            switch (this.chairId)
            {
                case 0:
                case 1:
                    return _chairId;
                case 2:
                case 3:
                {
                    switch (_chairId)
                    {
                        case 0:
                            return 3;
                        case 1:
                            return 2;
                        case 2:
                            return 1;
                        case 3:
                            return 0;
                    }

                    break;
                }
            }

            return 0;
        }

        public bool CheckIsTop()
        {
            return this.chairId >= 2;
        }

        /// <summary>
        /// 检查是否在另一边
        /// </summary>
        /// <param name="_chairId">椅子号</param>
        /// <returns></returns>
        public bool CheckIsOtherSide(int _chairId)
        {
            switch (this.chairId)
            {
                case 0:
                case 1:
                {
                    if (_chairId == 2 || _chairId == 3)
                    {
                        return true;
                    }

                    break;
                }
                case 2:
                case 3:
                {
                    if (_chairId == 0 || _chairId == 1)
                    {
                        return true;
                    }

                    break;
                }
            }

            return false;
        }


        public void EnterOtherGame(CAction enterFunc, string enterText)
        {
            LTBY_DataReport.Instance.Release();

            //           GC.NetworkRequest.Request("CSSyncMoney",{
            //               type = 1,
            //});

            SetRageShoot(false);
            SetAutoShoot(false);
            SetLockFish(false);

            ClearMananger(chairId);
            CAction action = () =>
            {
                //断开socket一定要在所有release之前，防止一些不应该传给服务器的包过去
                enterFunc?.Invoke();
            };
            LTBY_ViewManager.Instance.Open<LTBY_CountDownView>(enterText, 3, action);
        }

        public void ExitGame()
        {
            int value = LTBY_BulletManager.Instance.GetPlayerBulletValue(this.chairId);

            LTBY_DataReport.Instance.Cost("子弹", -value);

            LTBY_DataReport.Instance.Release();

            SetRageShoot(false);
            SetAutoShoot(false);
            SetLockFish(false);

            //   GC.NetworkRequest.Request("CSSyncMoney",{
            //       type = 1,
            //});

            ClearMananger(this.chairId);
            Action action = BackToSelectArena;
            LTBY_ViewManager.Instance.Open<LTBY_CountDownView>(GameViewConfig.Text.SyncServerData, 3, action);
        }

        public void BackToSelectArena()
        {
            DebugHelper.LogError("准备退出游戏");
            //断开socket一定要在所有release之前，防止一些不应该传给服务器的包过去
            HotfixActionHelper.DispatchLeaveGame();

            //GC.ViewManager.Replace("LTBY_SelectArenaView", self.userScore);

            //退出游戏
        }

        private void InitDataList(int _arena)
        {
            playerList = new Dictionary<int, Transform>();
            nameFrameList = new Dictionary<int, Transform>();
            scoreFrameList = new Dictionary<int, Transform>();
            scoreList = new Dictionary<int, NumberRoller>();
            batteryFrameList = new Dictionary<int, Transform>();
            batteryList = new Dictionary<int, Transform>();
            waitFrameList = new Dictionary<int, Transform>();
            lockEffectList = new Dictionary<int, Transform>();
            rageEffectList = new Dictionary<int, Transform>();
            locationEffectList = new Dictionary<int, Transform>();
            multiShootEffectList = new Dictionary<int, Transform>();
            playerRunInBackground = new Dictionary<int, bool>();
            effectList = new Dictionary<int, Transform>();
            coinList = new Dictionary<int, Transform>();

            this.arena = _arena;

            chairId = -1;
        }

        public int GetArena()
        {
            return arena;
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            UnregisterEvent();
        }

        private void RegisterEvent()
        {
            LTBY_Event.OnGetConfig+= LTBY_EventOnOnGetConfig;
            LTBY_Event.SCUserReady += OnUserReady;
            LTBY_Event.SyncPropInfo += OnUserInfoNotify;
            LTBY_Event.ChangeBatteryLevel += LTBY_EventOnChangeBatteryLevel;
            LTBY_Event.SCNotifyLogout += OnNotifyLogout;
            LTBY_Event.SCSyncMoney += OnSyncMoney;
            LTBY_Event.ShowGameUi += ShowGameUi;
            //GC.Notification.NetworkRegister(self, "SCSetProbability", function(_, data)
            // self: OnSetProbability(data);
            //end);
        }

        private void UnregisterEvent()
        {
            LTBY_Event.OnGetConfig-= LTBY_EventOnOnGetConfig;
            LTBY_Event.SCUserReady -= OnUserReady;
            LTBY_Event.SyncPropInfo -= OnUserInfoNotify;
            LTBY_Event.ChangeBatteryLevel -= LTBY_EventOnChangeBatteryLevel;
            LTBY_Event.SCNotifyLogout -= OnNotifyLogout;
            LTBY_Event.SCSyncMoney -= OnSyncMoney;
            LTBY_Event.ShowGameUi -= ShowGameUi;

        }


        private void LTBY_EventOnChangeBatteryLevel(LTBY_Struct.CMD_S_ChangeBulletLevel data)
        {
            if (data.wChairID != this.chairId) return;
            OnBaseUserInfoNotify(data);
            OnSetProbability(data.wChairID);
        }

        private void OnBaseUserInfoNotify(LTBY_Struct.CMD_S_ChangeBulletLevel data)
        {
            this.gunInfo = LTBY_DataConfig.gunInfos;
            this.lastGunLevel = data.cbGunType + 1;
            if (this.gunInfo == null) return;
            if (IsSelf(data.wChairID))
            {
                LTBY_SelectBattery box = LTBY_ViewManager.Instance.GetMessageBox<LTBY_SelectBattery>();
                box?.InitContent(this.gunInfo, this.lastGunLevel);
            }

            for (int i = 0; i < gunInfo.Count; i++)
            {
                if (!gunInfo[i].new_enable) continue;
                int level = gunInfo[i].gun_level;
                BatteryData config = BatteryConfig.Battery[level];
                BatteryData _data = new BatteryData()
                {
                    name = config.name, imageBundleName = config.imageBundleName, imageName = config.imageName
                };

                LTBY_GetItemMessagebox _box = LTBY_ViewManager.Instance.GetMessageBox<LTBY_GetItemMessagebox>();
                if (_box == null)
                {
                    LTBY_ViewManager.Instance.OpenMessageBox<LTBY_GetItemMessagebox>(true, null, "Item", _data);
                }
                else
                {
                    _box.SetNextData("Item", _data);
                }
            }
        }

        private void OnUserInfoNotify(LTBY_Struct.CMD_S_PlayerGunLevel data)
        {
            DebugHelper.LogError($"OnUserInfoNotify:{LitJson.JsonMapper.ToJson(data)}");
            for (int i = 0; i < data.GunType.Count; i++)
            {
                LTBY_Struct.CMD_S_ChangeBulletLevel changeBulletLevel = new LTBY_Struct.CMD_S_ChangeBulletLevel();
                if (data.GunType[i] == 0)
                {
                    if (i == this.chairId)
                    {
                        changeBulletLevel.cbGunType = 0;
                        changeBulletLevel.cbGunLevel = 0;
                        changeBulletLevel.wChairID = i;
                    }
                    else
                    {
                        continue;
                    }
                }
                else
                {
                    changeBulletLevel.cbGunType = (byte) data.GunType[i];
                    changeBulletLevel.cbGunLevel = (byte)data.GunLevel[i];
                    changeBulletLevel.wChairID = i;
                }
                OnBaseUserInfoNotify(changeBulletLevel);
                LTBY_Event.DispatchChangeBatteryLevel(changeBulletLevel);
            }

            //VIP--------------
            //this.vipInfo = LTBY_DataConfig.vipInfos;
            //        if (this.vipInfo.old_vip < this.vipInfo.cur_vip) {

            //            local oldConfig = MedalConfig.GetConfigByLevel(this.vipInfo.old_vip);
            //            local newConfig = MedalConfig.GetConfigByLevel(this.vipInfo.cur_vip);
            //            if oldConfig ~= newConfig then

            //                local box = GC.ViewManager.GetMessageBox("LTBY_GetItemMessagebox");
            //            if not box then
            //                    GC.ViewManager.OpenMessageBox("LTBY_GetItemMessagebox", "Medal", this.vipInfo.cur_vip);

            //        else
            //            box: SetNextData("Medal", this.vipInfo.cur_vip);
            //            end
            //        end

            //}
        }

        private void LTBY_EventOnOnGetConfig()
        {
            LTBY_Struct.CMD_S_ChangeBulletLevel changeBulletLevel = new LTBY_Struct.CMD_S_ChangeBulletLevel();
            changeBulletLevel.wChairID = this.chairId;
            changeBulletLevel.cbGunLevel = 0;
            changeBulletLevel.cbGunType = 0;
            OnBaseUserInfoNotify(changeBulletLevel);
        }
        private void OnUserReady(GameUserData data)
        {
            Dictionary<int, bool> existPlayer = new Dictionary<int, bool>();
            if (data.UserId == GameLocalMode.Instance.SCPlayerInfo.DwUser_Id)
            {
                DebugHelper.LogError($"自己椅子：{data.ChairId}");
                UserData = data;
                SetSelfChairId(data.ChairId);
            }

            int _chairId = data.ChairId;

            InitPlayer(_chairId, data);
            existPlayer.Add(_chairId, true);

            DebugHelper.LogError($"OnUserReady结束等待");
            if (_chairId != this.chairId)
            {
                CreateOtherLocationEffect(_chairId, 1);
            }

            //当OnUserReady消息返回后 才取消转圈圈 让玩家操作
            LTBY_WaitForServerView.Instance.EndWait("SwitchRoom");
        }

        private void OnNotifyLogout(GameUserData data)
        {
            RemovePlayer(data.ChairId);
        }

        private void OnSyncMoney(GameUserData data)
        {
            DebugHelper.LogError(LitJson.JsonMapper.ToJson(data));
            if (UserData.ChairId != data.ChairId) return;
            UserData = data;
        }

        private void OnUserRunBackground(int _chairId, bool background)
        {
            if (!this.playerList.ContainsKey(_chairId)) return;

            this.playerList[_chairId].FindChildDepth("Frame/Active").gameObject.SetActive(!background);
            this.playerList[_chairId].FindChildDepth("Frame/Background").gameObject.SetActive(background);

            this.playerRunInBackground[_chairId] = background;

            // if background then
            //  GC.BulletManager.DestroyPlayerBullet(chairId);
            //end
        }
    }

    public class PlayShootState
    {
        public bool multi_shoot;
        public bool crazy_speed;
    }
}