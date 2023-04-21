using DG.Tweening;
using LuaFramework;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.WPBY
{
    public class WPBYEntry : SingletonILEntity<WPBYEntry>
    {
        public Transform bulletCache;
        public Transform netCache;
        public Dictionary<int, GameUserData> UserList;
        public Transform playerGroup;
        private Transform systemGroup;
        private Toggle lockBtn;
        public Transform fishPool;
        public Transform bulletPool;
        public Transform netPool;
        public Transform fishScene;
        public Transform bulletEffectScene;
        public Transform bulletScene;
        public Transform netScene;
        public Transform fishCache;
        public Transform bulletEffectCache;
        public Transform backgroundPanel;
        public Transform fishPanel;
        public Transform uiPanel;
        private Camera backgroundCamera;
        public Vector4 viewportRect;
        public Transform backgroup;
        public Transform goldEffectPool;
        public Transform goldEffectPoolAllScene;
        private Toggle continueBtn;
        public Transform rulePanel;
        public Transform lockNode;
        private Transform soundList;
        private Transform tips;
        private Transform quitPanel;
        private Button quitBtn;
        private Button cancelQuitBtn;
        private Transform settingPanel;
        private Slider musicSet;
        private Slider soundSet;
        private Button closeSet;
        public Transform moveGroup;
        public Toggle openMoveGroup;
        private Button openBackBtn;
        private Button setBtn;
        private Button openRuleBtn;

        public Data GameData { get; set; }
        public Transform EffectPool { get; private set; }

        public Transform effectScene;
        public Transform heidongEffect;
        private GameObject touchArea;
        private Transform sceneArea;
        public float width;
        public float height;

        protected override void Awake()
        {
            base.Awake();
            AddListener();
            GameData = new Data();
            UserList = new Dictionary<int, GameUserData>();
            transform.AddILComponent<WPBY_FishController>();
            transform.AddILComponent<WPBY_BulletController>();
            transform.AddILComponent<WPBY_PlayerController>();
            transform.AddILComponent<WPBY_NetController>();
            soundList.AddILComponent<WPBY_Audio>();
            transform.AddILComponent<WPBY_Rule>().Create();
            transform.AddILComponent<WPBY_Network>();
            EffectPool.AddILComponent<WPBY_Effect>();
            WPBY_Audio.Instance.PlayBGM(WPBY_Audio.BGM);
        }

        protected override void AddEvent()
        {
            base.AddEvent();
            WPBY_Event.OnGetSceneInfo += WPBY_Event_OnGetSceneInfo;
            WPBY_Event.OnGetConfig += WPBY_Event_OnGetConfig;
            WPBY_Event.OnPlayerEnter += WPBY_Event_OnPlayerEnter;
            WPBY_Event.OnPlayerExit += WPBY_Event_OnPlayerExit;
            WPBY_Event.OnPlayerScoreChanged += WPBY_Event_OnPlayerScoreChanged;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            WPBY_Event.OnGetSceneInfo -= WPBY_Event_OnGetSceneInfo;
            WPBY_Event.OnGetConfig -= WPBY_Event_OnGetConfig;
            WPBY_Event.OnPlayerEnter -= WPBY_Event_OnPlayerEnter;
            WPBY_Event.OnPlayerExit -= WPBY_Event_OnPlayerExit;
            WPBY_Event.OnPlayerScoreChanged -= WPBY_Event_OnPlayerScoreChanged;
        }
        protected override void FindComponent()
        {
            base.FindComponent();
            this.backgroundPanel = this.transform.Find("BackgroundPanel");
            this.fishPanel = this.transform.Find("FishPanel");
            this.uiPanel = this.transform.Find("UIPanel");

            this.backgroundCamera = this.transform.FindChildDepth<Camera>("UICamera");
            Vector3 _leftBottom = this.backgroundCamera.ViewportToWorldPoint(Vector2.zero);
            Vector3 _rightTop = this.backgroundCamera.ViewportToWorldPoint(new Vector2(1, 1));
            this.viewportRect =new Vector4(_leftBottom.x, _rightTop.y, _rightTop.x, _leftBottom.y);

            this.backgroup = this.backgroundPanel.Find("Background");

            this.goldEffectPool = this.fishPanel.Find("GoldEffectPool");
            this.goldEffectPoolAllScene = this.fishPanel.Find("GoldEffectPoolAllScene");
            this.fishPool = this.fishPanel.Find("FishPool");
            this.bulletPool = this.fishPanel.Find("BulletPool");
            this.netPool = this.fishPanel.Find("NetPool");

            this.fishScene = this.fishPanel.Find("FishScene");
            this.bulletEffectScene = this.fishPanel.Find("BulletEffectScene");
            this.bulletScene = this.fishPanel.Find("BulletScene");
            this.netScene = this.fishPanel.Find("NetScene");

            this.fishCache = this.fishPanel.Find("FishCache");
            this.bulletEffectCache = this.fishPanel.Find("BulletEffectCache");
            this.bulletCache = this.fishPanel.Find("BulletCache");
            this.netCache = this.fishPanel.Find("NetCache");

            this.playerGroup = this.uiPanel.Find("PlayerGunGroup");
            this.systemGroup = this.uiPanel.Find("SystemGroup");
            this.lockBtn = this.systemGroup.FindChildDepth<Toggle>("RightGroup/Lock");
            this.lockBtn.isOn = false;
            this.lockBtn.transform.Find("Flag").gameObject.SetActive(false);
            this.continueBtn = this.systemGroup.FindChildDepth<Toggle>("RightGroup/Continue");
            this.continueBtn.isOn = false;
            this.continueBtn.transform.Find("Flag").gameObject.SetActive(false);
            this.rulePanel = this.uiPanel.Find("Rule");
            this.lockNode = this.uiPanel.Find("Lock");
            this.soundList = this.uiPanel.Find("SoundList");
            this.tips = this.uiPanel.Find("Tips");
            this.quitPanel = this.uiPanel.Find("QuitPanel");
            this.quitBtn = this.quitPanel.FindChildDepth<Button>("Content/Quit");
            this.cancelQuitBtn = this.quitPanel.FindChildDepth<Button>("Content/Cancel");

            this.settingPanel = this.uiPanel.Find("Setting");
            this.musicSet = this.settingPanel.FindChildDepth<Slider>("Music/MusicSlider");
            this.soundSet = this.settingPanel.FindChildDepth<Slider>("Sound/SoundSlider");
            this.closeSet = this.settingPanel.FindChildDepth<Button>("Sure");

            this.moveGroup = this.systemGroup.Find("LeftGroup/GroupImage");
            this.openMoveGroup = this.systemGroup.FindChildDepth<Toggle>("LeftGroup/OpenBtn");
            this.openBackBtn = this.moveGroup.FindChildDepth<Button>("Quit");
            this.setBtn = this.moveGroup.FindChildDepth<Button>("Setting");
            this.openRuleBtn = this.moveGroup.FindChildDepth<Button>("Help");
            this.openMoveGroup.isOn = false;
            this.moveGroup.gameObject.SetActive(false);

            this.EffectPool = this.uiPanel.Find("EffectPool");
            this.effectScene = this.uiPanel.Find("EffectScene");
            this.heidongEffect = this.EffectPool.Find("HeiDong");

            this.touchArea = this.fishPanel.Find("TouchArea").gameObject;
            this.sceneArea = this.fishPanel.Find("Area");
            this.width = this.sceneArea.Find("Point2").localPosition.x - this.sceneArea.Find("Point1").localPosition.x;
            this.height = this.sceneArea.Find("Point2").localPosition.y - this.sceneArea.Find("Point1").localPosition.y;
        }

        private void AddListener()
        {
            EventTriggerHelper touchAreaListener = touchArea.AddComponent<EventTriggerHelper>();
            touchAreaListener.onDown = (obj, eventData) =>
            {
                DebugHelper.Log("点击发炮");
                Vector2 vector2 = this.backgroundCamera.ScreenToWorldPoint(Input.mousePosition);
                WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(this.GameData.ChairID);
                player.gun_Function.gameObject.SetActive(false);
                WPBY_Fish ranFish = WPBY_FishController.Instance.OnGetRandomLookFish(true);
                if (ranFish == null)
                {
                    player.dir = vector2;
                    player.RotatePaoTaiByPos(player.dir);
                    return;
                }
                if (player.LockFish == null)
                {
                    player.dir = vector2;
                    if (player.isContinue)
                    {
                        player.RotatePaoTaiByPos(player.dir);
                    }
                    else
                    {
                        WPBY_PlayerController.Instance.ShootSelfBullet(new Vector3(vector2.x, vector2.y, 0), this.GameData.ChairID);
                    }
                }
                else
                {
                    if (!player.isContinue)
                    {
                        vector2 = player.LockFish.transform.position;
                        WPBY_PlayerController.Instance.ShootSelfBullet(new Vector3(vector2.x, vector2.y, 0), this.GameData.ChairID);
                    }
                }
            };

            this.lockBtn.onValueChanged.RemoveAllListeners();
            this.lockBtn.onValueChanged.Add((value)=>
            {
                this.ControlLock(value);
            });
            this.continueBtn.onValueChanged.RemoveAllListeners();
            this.continueBtn.onValueChanged.Add((value)=>
            {
                WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(this.GameData.ChairID);
                if (player != null)
                {
                    if (player.goldNum < (ulong)(GameData.Config.bulletScore[player.gungrade] * (player.gunLevel + 1)))
                    {
                        ToolHelper.PopSmallWindow("金币不足!");
                        return;
                    }
                }
                this.ControlContinue(value);
            });

            this.openMoveGroup.onValueChanged.RemoveAllListeners();
            this.openMoveGroup.onValueChanged.Add((value)=>
            {
                this.moveGroup.gameObject.SetActive(value);
            });
            this.openBackBtn.onClick.RemoveAllListeners();
            this.openBackBtn.onClick.Add(()=>
            {
                this.openMoveGroup.isOn = false;
                this.moveGroup.gameObject.SetActive(false);
                this.quitPanel.gameObject.SetActive(true);
                this.quitBtn.onClick.RemoveAllListeners();
                this.quitBtn.onClick.Add(() =>
                {
                    EventHelper.DispatchLeaveGame();
                });
                this.cancelQuitBtn.onClick.RemoveAllListeners();
                this.cancelQuitBtn.onClick.Add(() =>
                {
                    this.quitPanel.gameObject.SetActive(false);
                });
            });
            this.openRuleBtn.onClick.RemoveAllListeners();
            this.openRuleBtn.onClick.Add(()=>
            {
                WPBY_Rule.Instance.ShowRule();
            });
            this.setBtn.onClick.RemoveAllListeners();
            this.setBtn.onClick.Add(this.OpenSettingPanel);
        }
        private void WPBY_Event_OnPlayerExit(GameUserData data)
        {
            if (UserList.ContainsKey(data.ChairId))
            {
                UserList.Remove(data.ChairId);
            }
        }
        private void WPBY_Event_OnPlayerEnter(GameUserData data)
        {
            if (data.ChairId == GameLocalMode.Instance.SCPlayerInfo.DwUser_Id)
            {
                GameData.ChairID = data.ChairId;
                GameData.myGold = (long)data.Gold;
                if (data.ChairId >= 2)
                {
                    playerGroup.transform.localRotation = new Quaternion(0, 0, 180, 0);
                    GameData.isRevert = true;
                }
                else
                {
                    playerGroup.transform.localRotation = Quaternion.identity;
                    GameData.isRevert = false;
                }
            }
            if (UserList.ContainsKey(data.ChairId)) UserList.Remove(data.ChairId);
            UserList.Add(data.ChairId, data);
        }

        private void WPBY_Event_OnPlayerScoreChanged(GameUserData data)
        {
            if (data.ChairId == GameData.ChairID)
            {
                GameData.myGold = (long)data.Gold;
            }
        }

        private void WPBY_Event_OnGetConfig()
        {
            InitPanel();
        }

        private void WPBY_Event_OnGetSceneInfo()
        {
            InitPanel();
        }

        public void DelayCall(float timer,CAction callback)
        {
            Behaviour.StartCoroutine(Delay(timer, callback));
        }

        private IEnumerator Delay(float timer,CAction callback)
        {
            if (timer > 0)
            {
                yield return new WaitForSeconds(timer);
            }
            else
            {
                yield return new WaitForEndOfFrame();
            }
            callback?.Invoke();
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            WPBY_FishController.Instance.ClearFish();
        }
        public void ControlContinue(bool value)
        {
            WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(this.GameData.ChairID);
            player.isContinue = value;
            this.continueBtn.isOn = value;
            this.continueBtn.transform.Find("Flag").gameObject.SetActive(value);
            if (value)
            {
                player.ContinueFire(WPBY_PlayerController.Instance.acceleration, WPBY_PlayerController.Instance.acceleration);
            }
            else
            {
                player.StopContinueFire();
            }
        }
        public void ControlLock(bool value)
        {
            WPBY_Player player = WPBY_PlayerController.Instance.GetPlayer(this.GameData.ChairID);
            player.SetLockState(value);
            this.lockBtn.isOn = value;
            WPBY_FishController.Instance.SetLockFish(value);
            if (value)
            {
                this.touchArea.transform.SetAsFirstSibling();
            }
            else
            {
                this.touchArea.transform.SetAsLastSibling();
                WPBY_Struct.PlayerCancelLock cancelLock = new WPBY_Struct.PlayerCancelLock();
                cancelLock.chairID = (byte)this.GameData.ChairID;
                HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, WPBY_Network.SUB_C_PlayerCancalLock, cancelLock.ByteBuffer, SocketType.Game);
            }
            this.lockBtn.transform.Find("Flag").gameObject.SetActive(value);
        }
        public void OpenSettingPanel()
        {
            WPBY_Audio.Instance.PlaySound(WPBY_Audio.BTN);
            this.moveGroup.gameObject.SetActive(false);
            this.settingPanel.gameObject.SetActive(true);
            this.openMoveGroup.isOn = false;
            float musicvalue = ILMusicManager.Instance.GetMusicValue();
            float soundvalue = ILMusicManager.Instance.GetSoundValue();
            if (ILMusicManager.Instance.isPlayMV) {
                this.musicSet.value = musicvalue;
            }
            else
            {
                this.musicSet.value = 0;
            }

            if (ILMusicManager.Instance.isPlaySV) {
                this.soundSet.value = soundvalue;
            }
            else
            {
                this.soundSet.value = 0;
            }
            this.musicSet.onValueChanged.RemoveAllListeners();
               this.musicSet.onValueChanged.Add(value=>
               {
                   ILMusicManager.Instance.SetMusicValue(value);
                   WPBY_Audio.Instance.pool.volume = value;
                   WPBY_Audio.Instance.pool.mute = !ILMusicManager.Instance.isPlayMV;
               });
            this.soundSet.onValueChanged.RemoveAllListeners();
            this.soundSet.onValueChanged.Add(value =>
            {
                ILMusicManager.Instance.SetSoundValue(value);
            });
            this.closeSet.onClick.RemoveAllListeners();
            this.closeSet.onClick.Add(()=>
            {
                this.settingPanel.gameObject.SetActive(false);
            });
        }
        public List<Vector3> GetBezierPoint(List<Vector3> controllerPos, int segmentNum)
        {
            List<Vector3> poss = new List<Vector3>();
            for (int i = 0; i < segmentNum; i++)
            {
                float t = i / (float)segmentNum;

                Vector3 pos = GetPathToPoint(controllerPos, t);
                poss.Add(pos);
            }
            return poss;
        }

        public Vector3 GetPathToPoint(List<Vector3> controlPosList, float t)
        {
            Vector3 p = Vector3.zero;
            float n = 1 - t;
            //系数是根据杨辉三角的值是相同的
            //TODO: 实现任意阶贝塞尔曲线
            float x = 0;
            float y = 0;
            int count = controlPosList.Count;
            for (int i = 1; i <= count; i++)
            {
                int index = 1;
                if (i == 2)
                {
                    index = 4;
                }
                else if (i >= 3 && i <= count - 2)
                {
                    index = 8;
                }
                else if (i == count - 1)
                {
                    index = 4;
                }
                x += index * controlPosList[i - 1].x * Mathf.Pow(n, count - i) * Mathf.Pow(t, i - 1);
                y += index * controlPosList[i - 1].y * Mathf.Pow(n, count - i) * Mathf.Pow(t, i - 1);
            }
            p = new Vector3(x, y, 0);
            return p;
        }
        public void InitPanel()
        {
            //初始化背景
            WPBY_Effect.Instance.OnChangeBGStart(GameData.Config.bGID);
        }

        public void ShowTip(int fishkind)
        {
            Transform tip = null;
            if (fishkind == -1)
            {
                //鱼潮
                tip = this.tips.Find("YC");
            }
            if (tip != null)
            {
                tip.gameObject.SetActive(true);
                TextMeshProUGUI tipNum = tip.FindChildDepth<TextMeshProUGUI>("TimeNum");
                ToolHelper.RunGoal(5, 0, 5, value =>
                {
                    float v = Mathf.Ceil(float.Parse(value));
                    if (tipNum != null)
                    {
                        tipNum.text = v.ToString();
                    }
                }).OnComplete(() =>
                {
                    if (tip != null)
                    {
                        tip.gameObject.SetActive(false);
                    }
                });
            }
        }
        public float GetMagnificationToFishID(int fishId)
        {
            WPBY_Fish fish = WPBY_FishController.Instance.GetFish(fishId);
            int magnification = 0;
            float conversion = 0;
            if (fish.fishData.Kind <= 2)
            {
                magnification = 2;
            }
            else if (fish.fishData.Kind > 2 && fish.fishData.Kind <= 10)
            {
                magnification = fish.fishData.Kind;
            }
            else if (fish.fishData.Kind == 11)
            {
                magnification = 12;
            }
            else if (fish.fishData.Kind == 12)
            {
                magnification = 15;
            }
            else if (fish.fishData.Kind == 13)
            {
                magnification = 18;
            }
            else if (fish.fishData.Kind == 14)
            {
                magnification = 20;
            }
            else if (fish.fishData.Kind == 15)
            {
                magnification = 25;
            }
            else if (fish.fishData.Kind == 16)
            {
                magnification = 30;
            }
            else if (fish.fishData.Kind == 17)
            {
                magnification = 35;
            }
            else if (fish.fishData.Kind == 18)
            {
                magnification = 350;
            }
            else if (fish.fishData.Kind == 19)
            {
                magnification = 150;
            }
            else if (fish.fishData.Kind == 20)
            {
                magnification = 200;
            }
            else if (fish.fishData.Kind == 21)
            {
                magnification = 320;
            }
            else if (fish.fishData.Kind == 22)
            {
                magnification = 300;
            }
            else if (fish.fishData.Kind == 27)
            {
                magnification = 2;
            }
            else if (fish.fishData.Kind == 28)
            {
                magnification = 2;
            }
            else if (fish.fishData.Kind == 29)
            {
                magnification = 3;
            }
            else if (fish.fishData.Kind == 30)
            {
                magnification = 4;
            }
            else if (fish.fishData.Kind == 31)
            {
                magnification = 5;
            }
            else if (fish.fishData.Kind == 32)
            {
                magnification = 6;
            }
            else if (fish.fishData.Kind == 33)
            {
                magnification = 7;
            }
            else if (fish.fishData.Kind == 34)
            {
                magnification = 8;
            }
            else if (fish.fishData.Kind == 35)
            {
                magnification = 9;
            }
            else if (fish.fishData.Kind == 36)
            {
                magnification = 12;
            }
            else if (fish.fishData.Kind == 37)
            {
                magnification = 2;
            }
            else if (fish.fishData.Kind == 38)
            {
                magnification = 4;
            }
            else if (fish.fishData.Kind == 39)
            {
                magnification = 8;
            }
            else if (fish.fishData.Kind == 40)
            {
                magnification = 12;
            }
            else if (fish.fishData.Kind == 41)
            {
                magnification = 18;
            }
            else if (fish.fishData.Kind == 42)
            {
                magnification = 12;
            }
            else if (fish.fishData.Kind == 43)
            {
                magnification = 18;
            }
            else if (fish.fishData.Kind == 44)
            {
                magnification = 24;
            }
            else if (fish.fishData.Kind == 45)
            {
                magnification = 30;
            }
            else if (fish.fishData.Kind == 46)
            {
                magnification = 12;
            }
            else if (fish.fishData.Kind == 47)
            {
                magnification = 20;
            }
            else if (fish.fishData.Kind == 48)
            {
                magnification = 28;
            }
            else if (fish.fishData.Kind == 49)
            {
                magnification = 36;
            }

            if (magnification <= 10)
            {
                conversion = magnification;
            }
            else if (magnification <= 50)
            {
                conversion = magnification / 5f + 7;
            }
            else if (magnification <= 150)
            {
                conversion = magnification / 10 + 2;
            }
            else
            {
                conversion = magnification / 20 + 10;
            }

            return conversion;
        }
    }
}