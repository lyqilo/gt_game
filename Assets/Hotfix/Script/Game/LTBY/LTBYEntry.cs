using DG.Tweening;
using LuaFramework;
using System;
using System.Collections;
using System.Collections.Generic;
using LitJson;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using Object = UnityEngine.Object;

namespace Hotfix.LTBY
{
    /// <summary>
    /// 龙腾捕鱼启动主入口
    /// </summary>
    public class LTBYEntry : SingletonILEntity<LTBYEntry>
    {
        public UnityEngine.Transform GameLayer { get; set; }
        public Camera MainCam { get; set; }
        public Camera UiCam { get; set; }
        public UnityEngine.Transform UiLayer { get; set; }
        public UnityEngine.Transform UiTopLayer { get; set; }
        private UnityEngine.Transform Bg;
        public UnityEngine.Transform FishLayer { get; set; }
        public UnityEngine.Transform BulletLayer { get; set; }
        private UnityEngine.Transform Wave;
        public bool SceneChange { get; set; }

        Tweener ShakeKey;
        UnityEngine.Transform ChangeSceneText;
        private int SceneIndex;

        public Transform GetBulletLayer()
        {
            return BulletLayer;
        }

        public event CAction UpdateEvent;

        protected override void Awake()
        {
            base.Awake();
            Screen.orientation = ScreenOrientation.Landscape;
            Screen.autorotateToLandscapeLeft = true;
            Screen.autorotateToLandscapeRight = true;
            Screen.autorotateToPortrait = false;
            Screen.autorotateToPortraitUpsideDown = false;
            UnityEngine.Physics2D.autoSyncTransforms = false;
            DOTween.defaultEaseType = Ease.Linear;
            GameData.Instance.Init();
            LTBY_ResourceManager.Instance.Init();
            gameObject.AddILComponent<LTBY_Network>();
            gameObject.AddILComponent<LTBY_Audio>();
        }

        protected override void Start()
        {
            base.Start();
            GameData.Instance.recordQuality = UnityEngine.QualitySettings.GetQualityLevel();
            GameData.Instance.recordFps = Application.targetFrameRate;
            GameData.Instance.recordFixedDeltaTime = Time.fixedDeltaTime;
            Time.fixedDeltaTime = 0.06f;

            for (int i = 0; i < UnityEngine.QualitySettings.names.Length; i++)
            {
                if (UnityEngine.QualitySettings.names[i].Equals("BuYuHighLevel"))
                {
                    UnityEngine.QualitySettings.SetQualityLevel(i);
                    break;
                }
            }

            LTBY_WaitForServerView.Instance.Init();
            LTBY_DataReport.Instance.Init();
            LTBY_ViewManager.Instance.Init();
            LTBY_FishManager.Instance.Init();
            LTBY_BulletManager.Instance.Init();
            LTBY_EffectManager.Instance.Init();
            LTBY_BatteryManager.Instance.Init(transform.FindChildDepth("TouchController"));
            LTBY_FishManager.Instance.PreLoad();
            DebugHelper.Log("进入游戏");
        }

        protected override void OnDestroy()
        {
            UnityEngine.Physics2D.autoSyncTransforms = true;
            ExitGame();
            Time.fixedDeltaTime = GameData.Instance.recordFixedDeltaTime;
            Application.targetFrameRate = GameData.Instance.recordFps;
            UnityEngine.QualitySettings.SetQualityLevel(GameData.Instance.recordQuality);

            LTBY_Extend.Instance.Release();
            LTBY_WaitForServerView.Instance.Release();
            LTBY_FishManager.Instance.Release();
            LTBY_BulletManager.Instance.Release();
            LTBY_EffectManager.Instance.Release();
            LTBY_ViewManager.Instance.Release();
            LTBY_BatteryManager.Instance.Release();
            GameData.Instance.Release();
            LTBY_ResourceManager.Instance.Release();
            LTBY_DataReport.Instance.Release();
            LTBY_GameView.GameInstance = null;
            LockFishConfig.ClearFishList();
            Resources.UnloadUnusedAssets();
            UpdateEvent -= UpdateEvent;
            base.OnDestroy();
        }

        protected override void FixedUpdate()
        {
            base.FixedUpdate();
            UpdateEvent?.Invoke();
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            MainCam = transform.FindChildDepth<Camera>("MainCamera");

            UiCam = transform.FindChildDepth<Camera>("UiCamera");

            UiLayer = transform.FindChildDepth("Canvas");

            UiTopLayer = transform.FindChildDepth("CanvasTop");

            GameLayer = transform.FindChildDepth("GameLayer");

            FishLayer = GameLayer.FindChildDepth("FishLayer");

            BulletLayer = GameLayer.FindChildDepth("BulletLayer");

            Wave = GameLayer.FindChildDepth("Wave");

            SceneIndex = 1;
        }

        protected override void AddEvent()
        {
            LTBY_Event.OnYCPre += LTBY_Event_OnYCPre;
        }

        protected override void RemoveEvent()
        {
            LTBY_Event.OnYCPre -= LTBY_Event_OnYCPre;
        }

        private void LTBY_Event_OnYCPre(LTBY_Struct.CMD_S_YuChaoComePre yuChaoCome)
        {
            ChangeScene(yuChaoCome.backId + 1);
        }

        private void SetSceneIndex(int index)
        {
            SceneIndex = index;
        }

        public void EnterGame()
        {
            SceneChange = false;
            ShakeKey = null;
            ChangeSceneText = null;
            CreateBackground(SceneIndex);
        }

        protected override void Update()
        {
            base.Update();
            Demo.Instance.Update();
        }

        public void ExitGame()
        {
            SetLowPower(4);

            if (ChangeSceneText != null)
            {
                UnityEngine.Object.Destroy(ChangeSceneText.gameObject);
                ChangeSceneText = null;
            }

            Wave.gameObject.SetActive(false);
            SceneChange = false;
            //退出游戏就删除背景
            RemoveBackground();
        }

        private void ChangeScene(int nextIndex)
        {
            if (SceneChange) return;
            SceneChange = true;
            if (nextIndex > 3) nextIndex -= 3;
            SceneIndex = nextIndex;
            Transform oldBg = Bg;
            ChangeSceneText = LTBY_Extend.Instance.LoadPrefab("LTBY_TextWave", UiLayer);
            ToolHelper.DelayRun(1.5f, () =>
            {
                LTBY_Audio.Instance.Play(LTBY_Audio.Wave);
                Wave.gameObject.SetActive(true);

                LTBY_Extend.Instance.RendererFadeOut(oldBg, 1.5f);

                CreateBackground(nextIndex);

                LTBY_Extend.Instance.RendererFadeIn(Bg, 1.5f);

                ToolHelper.DelayRun(1.5f, () =>
                {
                    if (oldBg != null) LTBY_Extend.Destroy(oldBg.gameObject);
                });

                ToolHelper.DelayRun(3f, () =>
                {
                    if (ChangeSceneText != null)
                    {
                        LTBY_Extend.Destroy(ChangeSceneText.gameObject);
                        ChangeSceneText = null;
                    }
                    if(Wave!=null) Wave.gameObject.SetActive(false);
                    SceneChange = false;
                    GC.Collect();
                });
            });
        }

        /// <summary>
        /// 创建背景
        /// </summary>
        /// <param name="index">背景Id</param>
        /// <returns></returns>
        public void CreateBackground(int index)
        {
            Bg = LTBY_Extend.Instance.LoadPrefab($"LTBY_Background_{index}", FishLayer, "BG");
            Vector2 size = GetBackgroundWH();
            Bg.localScale = new Vector3(size.x + 1, size.y + 1, 1);
            Bg.localPosition = new Vector3(0, 0, 200);
        }

        /// <summary>
        /// 移除背景
        /// </summary>
        public void RemoveBackground()
        {
            if (Bg != null) UnityEngine.Object.Destroy(Bg.gameObject);
        }

        /// <summary>
        /// 获取背景高宽
        /// </summary>
        /// <returns></returns>
        public Vector2 GetBackgroundWH()
        {
            float size = MainCam.orthographicSize;
            if (Screen.width > Screen.height)
            {
                float height = size * 2;
                float width = height * ((float) Screen.width / Screen.height);
                return new Vector2(width, height);
            }
            else
            {
                float height = size * 2;
                float width = height * ((float) Screen.height / Screen.width);
                return new Vector2(width, height);
            }
        }

        public void DealHighFps()
        {
            Application.targetFrameRate = 60;
            GameLayer.FindChildDepth("ShadowProjector").gameObject.SetActive(true);
        }

        public Transform GetGameLayer()
        {
            return GameLayer;
        }

        public Transform GetUiLayer()
        {
            return UiLayer;
        }

        public Transform GetUiTopLayer()
        {
            return UiTopLayer;
        }

        public Transform GetFishLayer()
        {
            return FishLayer;
        }

        public void DealLowFps()
        {
            //DebugHepler.LogError("执行降帧处理")
            Application.targetFrameRate = 30;
            GameLayer.FindChildDepth("ShadowProjector").gameObject.SetActive(false);
        }

        /// <summary>
        /// 设置渲染等级
        /// </summary>
        /// <param name="level">等级</param>
        public void SetLowPower(int level)
        {
            if (level == 1)
            {
                Application.targetFrameRate = 25;
                GameLayer.FindChildDepth("Light").gameObject.SetActive(false);
                GameLayer.FindChildDepth("ShadowProjector").gameObject.SetActive(false);

                //GC.FishManager.ToggleDragonLight(false);
            }
            else if (level == 2)
            {
                Application.targetFrameRate = 35;
                GameLayer.FindChildDepth("Light").gameObject.SetActive(false);
                GameLayer.FindChildDepth("ShadowProjector").gameObject.SetActive(true);

                //GC.FishManager.ToggleDragonLight(false);
            }
            else if (level == 3)
            {
                Application.targetFrameRate = 45;
                GameLayer.FindChildDepth("Light").gameObject.SetActive(true);
                GameLayer.FindChildDepth("ShadowProjector").gameObject.SetActive(true);

                //GC.FishManager.ToggleDragonLight(true);
            }
            else
            {
                Application.targetFrameRate = 55;
                GameLayer.FindChildDepth("Light").gameObject.SetActive(true);
                GameLayer.FindChildDepth("ShadowProjector").gameObject.SetActive(true);

                //GC.FishManager.ToggleDragonLight(true);
            }
        }

        /// <summary>
        /// 震动鱼池
        /// </summary>
        /// <param name="time">时间</param>
        /// <param name="strength">频率</param>
        public void ShakeFishLayer(float time, float strength = 1)
        {
            if (ShakeKey != null) return;
            ShakeKey = FishLayer.DOShakePosition(time, strength, 50, 90, false).SetEase(Ease.Linear).OnComplete(() =>
            {
                FishLayer.localPosition = Vector3.zero;
                ShakeKey = null;
            });
            ShakeKey?.SetAutoKill();
        }

        public Vector3 GetUIPosFromWorld(Vector3 pos)
        {
            if (UiCam == null || MainCam == null)
            {
                DebugHelper.LogError("转换坐标时 camera为空!!!");
                return pos;
            }

            Vector3 mainCamScreenPoint = MainCam.WorldToScreenPoint(pos);
            Vector3 uiCamWorldPoint = UiCam.ScreenToWorldPoint(mainCamScreenPoint);

            return uiCamWorldPoint;
        }

        public Camera GetUiCam()
        {
            return UiCam;
        }

        public Camera GetMainCam()
        {
            return MainCam;
        }

        public bool GetIsChangeScene()
        {
            return SceneChange;
        }
    }
}