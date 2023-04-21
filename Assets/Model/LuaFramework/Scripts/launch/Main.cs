using System;
using System.Collections.Generic;
using System.IO;
using LitJson;
using MyMobleSDK;
using UnityEngine;
using UnityEngine.UI;

namespace LuaFramework
{
    /// <summary>
    /// </summary>
    public class Main : MonoBehaviour, IMain
    {
        [HideInInspector] public TextAsset CsConfiger;
        private TextAsset keyconfig;

        public Slider Progress;

        public Text text;
        public Text desc;

        bool isTest = false;
        private float rate;
        private int currentheight;
        private int currentwidth;
        private int lastheight;
        private int lastwidth;

        void Start()
        {
            AppFacade.Instance.RemoveManager<ResourceManager>();
            AppFacade.Instance.RemoveManager<LuaManager>();
            AppFacade.Instance.RemoveManager<ILRuntimeManager>();
            AppFacade.Instance.RemoveManager<ObjectPoolManager>();
            AppFacade.Instance.RemoveManager<TimerManager>();
            AppFacade.Instance.RemoveManager<MusicManager>();
            AppFacade.Instance.RemoveManager<DownloadPicManager>();
            AppFacade.Instance.RemoveManager<GameManager>();
            AppConst.Initialize = false;
            AssetBundle.UnloadAllAssetBundles(true);
            this.InitConfiger();
//#if UNITY_EDITOR
//            DebugTool.logEnabled = true;
//            DebugTool.logWarningEnabled = true;
//            DebugTool.logErrorEnabled = true;
//#else
//            DebugTool.logEnabled = false;
//            DebugTool.logWarningEnabled = false;
//            DebugTool.logErrorEnabled = false;
//#endif

#if UNITY_STANDALONE_WIN
            ES3.Save<string>(ScreenOrientation,UnityEngine.ScreenOrientation.Landscape.ToString());
#endif
#if !UNITY_EDITOR
            //try
            //{
            //    Defence.Init();
            //}
            //catch (Exception e)
            //{
            //    DebugTool.LogError(e.Message);
            //}
#endif
            this.InitGameMangager();
        }

#if UNITY_STANDALONE_WIN
        public const string ScreenOrientation = "ScreenOrientation";
        private string lastOrientation;
        private void Update()
        {
            bool hasKey = ES3.KeyExists(ScreenOrientation);
            if (!hasKey) return;
            string orientation = ES3.Load<string>(ScreenOrientation);
            if (lastOrientation == orientation) return;
            if (orientation == UnityEngine.ScreenOrientation.Portrait.ToString())
            {
                AspectRatioController.Instance.SetAspectRatio(9, 16, true);
            }
            else
            {
                AspectRatioController.Instance.SetAspectRatio(16, 9, true);
            }

            lastOrientation = orientation;
        }
#endif

        public void InitConfiger()
        {
            this.CsConfiger = Resources.Load<TextAsset>("CsConfiger");
            if (this.CsConfiger == null)
            {
                DebugTool.LogError("获取配置失败");
                return;
            }

            string text = string.Empty;
            string text2 = string.Empty;
            text = PathHelp.AppHotfixResPath + "CSConfiger.json";
            text2 = this.CsConfiger.text;
            if (File.Exists(text))
            {
                text2 = CSFile.Read(text);
            }

            if (!text2.Contains("1F8W9QX1FP1M7G6Z3A72Q2E7U"))
            {
                text2 = Util.DecryptDES(text2, "89219417");
            }

            AppConst.csConfiger = JsonMapper.ToObject<CSConfiger>(text2);
//            DebugTool.LogError(text2);
//            AppConst.csConfiger.UpdateMode = false;
            // AppConst.csConfiger.DNS = new string[] { "http://47.108.78.47" };
            if (isTest)
            {
                AppConst.CdnDirectoryName = "TestBoleRes"; //服务器上的测试bundle文件夹
            }
        }

        public void InitGameMangager()
        {
            GameObject gameObject = new GameObject("CallUnity");
            gameObject.AddComponent<CallUnity>();
            gameObject.AddComponent<WWWAsync>();
            GameManager gameManager;
            if (!AppConst.Initialize)
            {
                gameManager = AppFacade.Instance.AddManager<GameManager>();
            }
            else
            {
                gameManager = AppFacade.Instance.GetManager<GameManager>();
            }

            gameManager.Being(this);
        }

        public void UpdateUIProgress(float progess)
        {
            if (progess <= -1f)
            {
                this.text.text = "网络错误";
                Debug.Log("网络错误");
                return;
            }

            progess = (float) Math.Round((double) progess, 2);
            progess = Mathf.Clamp(progess, 0f, 1f);
            this.Progress.value = progess;
            string text = string.Format("{0}%", progess * 100f);
            this.text.text = text;
        }

        public void UpdateUIDesc(string _desc)
        {
            if (string.IsNullOrEmpty(_desc))
            {
                this.desc.text = "";
            }
            else
            {
                this.desc.text = _desc;
            }
        }
    }
}