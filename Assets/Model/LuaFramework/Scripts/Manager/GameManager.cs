using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using LitJson;
using LuaInterface;
using QPDefine;
using UnityEngine;
using UnityEngine.Networking;

namespace LuaFramework
{
    public class GameManager : Manager
    {
        public IMain Main { get; private set; }
        public List<string> Urls = new List<string>();
        private bool restApp = false;
        public List<string> updateFiles = new List<string>();

        void OnApplicationQuit()
        {
            AppFacade.Instance.RemoveManager<GameManager>();
        }

        private static float allValue = 0;
        private float resetTime = 0f;


        void OnApplicationFocus(bool isFocus)
        {
            if (Util.isWindowsEditor || !AppConst.Initialize) return;
            bool flag = !AppConst.HomeKey;
            if (!flag)
            {
                if (isFocus)
                {
                    float num = Util.TickCount - this.resetTime;

                    bool flag2 = num > (float) AppConst.ResetGameTimer;

                    if (flag2)
                    {
                        MessageDispatcher.dispense();
                        Util.ResetGame();
                    }
                    else
                    {
                        MessageDispatcher.isSendMessge = true;
                        LuaManager.CallFunction("GameManager.OnApplicationFocus", isFocus);
                    }
                }
                else
                {
                    this.resetTime = Util.TickCount;
                    MessageDispatcher.isSendMessge = false;
                    LuaManager.CallFunction("GameManager.OnApplicationFocus", isFocus);
                }
            }
        }


        /// <summary>
        /// 初始化
        /// </summary>
        public override void OnInitialize()
        {
            Application.runInBackground = true;
            Screen.sleepTimeout = SleepTimeout.NeverSleep;
            Application.targetFrameRate = 60;
            Debugger.useLog = false;
            Caching.ClearCache();

            // HandleConfig.InitConfiger();

            //加载本地缓存设置
            //SaveManager.OnInitialize();
            //--核心工具
            AppFacade.Instance.AddManager<TimerManager>();
            AppFacade.Instance.AddManager<NetworkManager>();
            // AppFacade.Instance.AddManager("SDKManager",SDKManager.Instance);
            // StartCoroutine(UpdateGameFrame());
            AddManager();
            DontDestroyOnLoad(gameObject); //防止销毁自己  
        }

        /// <summary>
        /// 析构函数
        /// </summary>
        public override void UnInitialize()
        {
            // HandleConfig.SaveConfiger();
            //加载本地缓存设置
            // SaveManager.UnInitialize();
            StopAllCoroutines();
            AppFacade.Instance.RemoveManager<TimerManager>();
            AppFacade.Instance.RemoveManager<NetworkManager>();
            RemoveManager();

            //DebugTool.LogError("关闭游戏");
        }

        private void OnDestroy()
        {
            ConfigHelp.SaveAppInfoConfiger();
            ConfigHelp.SaveValueConfiger();
            // HandleConfig.SaveConfiger();
        }

        private void AddManager()
        {
            //-----------------启动管理器载入并初始化-----------------------
            //--资源加载
            // AppFacade.Instance.AddManager<AssetBundleManager>();
            AppFacade.Instance.AddManager<ResourceManager>();

            //--Obj缓存工具
            AppFacade.Instance.AddManager<ObjectPoolManager>();
            //--音效管理
            // AppFacade.Instance.AddManager<SoundManager>();
            AppFacade.Instance.AddManager<MusicManager>();
            AppFacade.Instance.AddManager<DownloadPicManager>();
            // Debug.LogError("增加的lua管理器");
            AppFacade.Instance.AddManager<LuaManager>();
            AppFacade.Instance.AddManager<ILRuntimeManager>();
        }

        private void RemoveManager()
        {
            //AppFacade.Instance.RemoveManager<AssetBundleManager>();
            AppFacade.Instance.RemoveManager<ResourceManager>();

            //AppFacade.Instance.RemoveManager<ObjectPoolManager>();
            // AppFacade.Instance.RemoveManager<SoundManager>();
            AppFacade.Instance.RemoveManager<MusicManager>();
        }

        public async void Being(IMain m)
        {
            this.Main = m;
            await this.LaunchGame();
        }

        public async Task LaunchGame()
        {
            this.CheckLocalVersion();
            bool flag = !File.Exists(PathHelp.AppHotfixResPath + AppConst.ValueConfigerName) && !AppConst.DebugMode;
            if (flag)
            {
                Main.UpdateUIDesc("正在解压文件，请稍等");
                await this.OnUnzip();
            }

            Main.UpdateUIDesc("正在获取版本文件，请稍等");
            bool isOk = true;
            int count = 2;
            bool flag2 = await this.OnInitWebUrl();

            StartCoroutine(StartReqWebRequest(
                AppConst.WebUrl + AppConst.csConfiger.SkinVersionName + "/" + AppConst.CSConfigerName,
                (isSuccess, result) =>
                {
                    if (isSuccess)
                    {
                        string text2 = Util.DecryptDES(result, "89219417");
                        AppConst.csConfiger = JsonMapper.ToObject<CSConfiger>(text2);
                        // AppConst.csConfiger.UpdateMode = false;
                    }

                    taskTool.SetResult(true);
                }));
            await WaitWebRequest();
            flag2 = await OnInitWebUrl();
            isOk = flag2;
            if (!isOk)
            {
                Main.UpdateUIProgress(-1f);

                await this.LaunchGame();
                //return;
            }
            else
            {
                Main.UpdateUIDesc("正在更新中，请稍等");
                for (int i = 0; i < count; i++)
                {
                    bool flag3 = await this.OnUpdateResource(flag);
                    isOk = flag3;
                    if (isOk && i < count)
                    {
                        i += count;
                    }
                }

                if (!isOk)
                {
                    Main.UpdateUIProgress(-1f);
                    await this.LaunchGame();
                    return;
                }
                else
                {
                }

                Main.UpdateUIDesc("更新完成，正在加载资源，请稍等");
                await this.InitConfiger();
                //  await this.InitLuaScript();
                StartCoroutine(UpdateGameFrame());
            }
        }


        private TaskCompletionSource<bool> taskTool;

        Task<bool> WaitWebRequest()
        {
            taskTool = new TaskCompletionSource<bool>();
            return taskTool.Task;
        }

        IEnumerator StartReqWebRequest(string url, Action<bool, string> callback)
        {
            yield return new WaitForEndOfFrame();
            UnityWebRequest rq = UnityWebRequest.Get(url);
            rq.timeout = 3000;
            yield return rq.SendWebRequest();
            if (!string.IsNullOrEmpty(rq.error) || rq.isHttpError || rq.isNetworkError)
            {
                if (callback != null)
                {
                    callback(false, rq.error);
                }

                yield break;
            }

            if (callback != null)
            {
                callback(true, rq.downloadHandler.text);
            }
        }

        public async Task InitConfiger()
        {
            // await ConfigHelp.InitAppInfoConfiger();
            await ConfigHelp.InitGameValueConfiger();
        }

        public async Task<bool> OnUpdateResource(bool isFirst=false)
        {
            bool flag = !AppConst.UpdateMode;
            bool result;
            if (flag)
            {
                result = true;
            }
            else
            {
                bool flag2 = AppConst.WebUrl.IsNullOrEmpty();
                if (flag2)
                {
                    result = false;
                }
                else
                {
                    string url = AppConst.WebUrl;
                    ValueConfiger updateConfiger = AppConst.valueConfiger;
                    string dataPath = PathHelp.AppHotfixResPath;
                    bool flag3 = !Directory.Exists(dataPath);
                    if (flag3)
                    {
                        Directory.CreateDirectory(dataPath);
                        CalliOS.SetNoBackupFlag(PathHelp.AppHotfixResPath);
                    }

                    int webHallLuaVer = updateConfiger.Version;
                    int localHallLuaVer = AppConst.UpdateVersion;

                    bool flag4 = webHallLuaVer == localHallLuaVer;
                    if (flag4)
                    {
                        // DebugTool.LogError("Check version, Don't need to update!");
                        result = true;
                    }
                    else
                    {
                        string[] auditPak = updateConfiger.AuditPak;
                        bool flag5 = auditPak == null;
                        if (flag5)
                        {
                            auditPak = new string[0];
                        }

                        string CurrentPak = Util.PakNameVersion;
                        // Log.Debug("CurrentPak:" + CurrentPak);
                        bool flag6 = updateConfiger.isAudit(CurrentPak);
                        if (flag6)
                        {
                            // DebugTool.LogError("new package, Don't need to update!");
                            result = true;
                        }
                        else
                        {
                            List<UnityWebPacket> HotUpdatePaks = new List<UnityWebPacket>();
                            Dictionary<string, BaseValueConfigerJson> files = updateConfiger.JsonData;
                            //   Log.Debug(string.Format("{0} files need to be updated !", files.Count));
                            bool isResGamea = false;

                            Action<float, object> func = delegate(float a, object b)
                            {
                                bool flag14 = a < 0f;
                                if (flag14)
                                {
                                    IMain main = this.Main;
                                    if (main != null)
                                    {
                                        main.UpdateUIProgress(a);
                                        if (a < 0)
                                        {
                                            this.Being(Main);
                                            return;
                                        }
                                    }

                                    //   Log.Error("更新资源出错...");
                                }

                                IMain main2 = this.Main;
                                if (main2 != null)
                                {
                                    main2.UpdateUIProgress(a);
                                }

                                bool flag15 = a >= 1f;
                                if (flag15)
                                {
                                    AppConst.UpdateVersion = webHallLuaVer;

                                    bool isResGame = isResGamea;
                                    if (isResGame)
                                    {
                                        this.restApp = true;
                                    }
                                }
                            };
                            foreach (BaseValueConfigerJson fj in files.Values)
                            {
                                if (fj.dirPath == "ValueConfiger.json") continue;
                                bool flag7 = string.IsNullOrEmpty(fj.dirPath);
                                if (!flag7)
                                {
                                    string fileDirPath = fj.dirPath;
                                    string fileLocalPath = (dataPath + fileDirPath).Trim();
                                    string fileDir = Path.GetDirectoryName(fileLocalPath);
                                    bool flag8 = !Directory.Exists(fileDir);
                                    if (flag8)
                                    {
                                        Directory.CreateDirectory(fileDir);
                                    }

                                    string fileWebUrl = string.Concat(new string[]
                                    {
                                        url,
                                        AppConst.HotUpdateDirectoryName,
                                        "/",
                                        fileDirPath,
                                        "?m=",
                                        fj.md5
                                    });
                                    bool canUpdate = !File.Exists(fileLocalPath);
                                    bool flag9 = !canUpdate;
                                    if (flag9)
                                    {
                                        string remoteMd5 = fj.md5.Trim();
                                        string localMd5 = Util.md5file(fileLocalPath);

                                        canUpdate = !remoteMd5.Equals(localMd5);
                                        if (canUpdate)
                                        {
                                            //DebugTool.LogError("------------------------------资源路径=" + fj.dirPath);
                                            //DebugTool.LogError("本地md5=" + localMd5);
                                            //DebugTool.LogError("远程md5=" + remoteMd5);
                                        }

                                        remoteMd5 = null;
                                        localMd5 = null;
                                    }

                                    bool flag10 = canUpdate;
                                    if (flag10)
                                    {
                                        UnityWebPacket pak = new UnityWebPacket();
                                        pak.urlPath = fileWebUrl;
                                        pak.localPath = fileLocalPath;
                                        ulong size = 0UL;
                                        ulong.TryParse(fj.size, out size);
                                        bool flag11 = size < 0UL;
                                        if (flag11)
                                        {
                                            DebugTool.LogError(string.Format("update file Length is {0} ,error!!!",
                                                size));
                                        }

                                        DebugTool.LogError(pak.urlPath);
                                        pak.size = size;
                                        pak.func = func;
                                        HotUpdatePaks.Add(pak);
                                        this.updateFiles.Add(fj.dirPath);
                                        bool flag12 = fj.dirPath.ToLower().Trim()
                                            .Contains("CSConfiger.json".ToLower().Trim());
                                        if (flag12)
                                        {
                                            isResGamea = true;
                                        }

                                        pak = null;
                                    }

                                    fileDirPath = null;
                                    fileLocalPath = null;
                                    fileDir = null;
                                    fileWebUrl = null;
                                }
                            }

                            GameObject obj = new GameObject("OnUpdateResource");
                            UnityWebRequestAsync uwa = obj.AddComponent<UnityWebRequestAsync>();

                            await uwa.DownloadAsync(HotUpdatePaks, null);
                            UnityEngine.Object.Destroy(obj);
                            result = true;
                        }
                    }
                }
            }

            return result;
        }

        public void CheckLocalVersion()
        {
            bool flag = !File.Exists(AppConst.DataFileSavePath);
            if (flag)
            {
                AppConst.AppInstallTime = Util.FormatTimeToNumber;
            }
            else
            {
                string version = Application.version;
                string value = Util.Read("Version");
                bool flag2 = !version.Equals(value);
                if (flag2)
                {
                    // Directory.Delete(PathHelp.AppHotfixResPath, true);
                    DebugTool.LogError("Different versions!Reinitialize resources！");
                    AppConst.AppInstallTime = Util.FormatTimeToNumber;
                }
            }
        }

        public async Task<bool> OnInitWebUrl()
        {
            bool debugMode = AppConst.DebugMode;
            bool result;
            if (debugMode)
            {
                result = true;
            }
            else
            {
                this.Urls.Clear();
                float b = Time.realtimeSinceStartup;
                this.Urls = ConfigHelp.GetHotFixUrls();
                GameObject obj = new GameObject("UnityDns");
                UnityDns ud = obj.AddComponent<UnityDns>();
                UrlInfo urlInfo = await ud.ParseUrl(this.Urls);
                UrlInfo urlinfo = urlInfo;
                if (string.IsNullOrEmpty(urlinfo.conten) ||
                    !urlinfo.conten.Equals(Framework.Assets.Model.Instance.Auth)) return false;
                urlInfo = default(UrlInfo);
                if (urlinfo.state)
                {
                    //DebugTool.Log(string.Format("find web url use time:{0}", Time.realtimeSinceStartup - b));
                    // AppConst.WebUrl = urlinfo.url.Replace(ConfigHelp.ServerUpdateConfigerPath, string.Empty);
                    // AppConst.WebUrl = string.Concat(new string[]
                    // {
                    //     AppConst.WebUrl,
                    //     "/",
                    //     AppConst.CdnDirectoryName,
                    //     "/",
                    //     Util.PlatformName,
                    //     // "iOS",
                    //     "/"
                    // });
                    // AppConst.valueConfiger = JsonMapper.ToObject<ValueConfiger>(urlinfo.conten);
                    AppConst.WebUrl =
                        $"{AppConst.DNS[urlinfo.index]}/{AppConst.CdnDirectoryName}/{(Util.IsTest ? "Test" : Application.version)}/{Util.PlatformName}/";
                    AppConst.DNSUrl =
                        $"{AppConst.DNS[urlinfo.index]}/{AppConst.CdnDirectoryName}/{(Util.IsTest ? "Test" : Application.version)}";
                }

                UnityEngine.Object.Destroy(obj);
                result = urlinfo.state;
            }

            return result;
        }

        // 初始化Lua代码
        IEnumerator InitLuaCode()
        {
            // Loading.Show();
            yield return 0;

            LuaManager.InitStart();

            yield return 0;

            //最小Lua加载时间
            // var luamintime = 1f;
            //var startProTime = Time.realtimeSinceStartup;

            //获取逻辑模块Lua脚本
            LuaManager.DoFile("Loader/LoadEnter");
            var luaFiles = LuaManager.CallFunction("Loader.GetLoadFiles", null);

            // DebugTool.Log("--------------------------------开始加载逻辑模块Lua文件-------------------------------");
            float allCount = luaFiles.Length;

            for (int i = 0; i < luaFiles.Length; ++i)
            {
                var file = (string) luaFiles[i];
                LuaManager.DoFile(file);

                if ((i / 10f) == 0)
                {
                    yield return 1;
                }
            }

            LuaManager.DoFile("Logic/Network"); //加载网络

            AppConst.Initialize = true;

            LuaManager.CallFunction("GameManager.StartGame");

            yield return 0;
        }

        //更新游戏
        IEnumerator UpdateGameFrame()
        {
            yield return 0;
            DebugTool.Log($"更新完成");
            RunGameFrame();
        }

        public async Task OnUnzip()
        {
            Caching.ClearCache();
            string dataPath = PathHelp.AppHotfixResPath;
            string resPath = PathHelp.AppResPath;
            // Log.Debug("dataPath:" + dataPath + "    resPath:" + resPath);
            bool flag = !Directory.Exists(dataPath);
            if (flag)
            {
                Directory.CreateDirectory(dataPath);
            }

            string infile = resPath + AppConst.ValueConfigerName;
            string outfile = dataPath + AppConst.ValueConfigerName;
            bool flag2 = File.Exists(outfile);
            if (flag2)
            {
                File.Delete(outfile);
            }

            // Log.Debug("Extract: " + infile + " ==> " + outfile);
            WWWAsync down = WWWAsync.instance;
            List<UnityWebPacket> paks = new List<UnityWebPacket>();
            bool flag3 = Application.platform == RuntimePlatform.Android;
            if (flag3)
            {
                UnityWebPacket pak = new UnityWebPacket
                {
                    localPath = outfile,
                    urlPath = infile,
                    size = 1UL
                };
                await down.DownloadAsync(pak);
                down.Save();
                pak = null;
            }
            else
            {
                if (!File.Exists(infile))
                {
                    // Log.Error("can't find " + infile);
                    return;
                }

                File.Copy(infile, outfile, true);
            }

            string txt = File.ReadAllText(outfile);
            ValueConfiger updateConfiger = default(ValueConfiger);
            updateConfiger = JsonMapper.ToObject<ValueConfiger>(txt);
            Dictionary<string, BaseValueConfigerJson> bfj = updateConfiger.JsonData;
            //Log.Debug(string.Format("need copy files {0}", bfj.Count));
            paks.Clear();
            float a = 0f;
            float a2 = (float) bfj.Values.Count;
            UnityWebPacket p = new UnityWebPacket();
            foreach (BaseValueConfigerJson obj in bfj.Values)
            {
                string p2 = dataPath + obj.dirPath;
                string p3 = resPath + obj.dirPath;
                string dir = Path.GetDirectoryName(p2);
                if (!Directory.Exists(dir))
                {
                    Directory.CreateDirectory(dir);
                }

                if (Application.platform == RuntimePlatform.Android)
                {
                    p.localPath = p2;
                    p.urlPath = p3;
                    p.size = 1UL;
                    p.func = null;
                    ulong.TryParse(obj.size, out p.size);
                    await down.DownloadAsync(p);
                    down.Save();
                }
                else
                {
                    File.Copy(p3, p2, true);
                }

                a += 1f;
                float v = a / a2;
                IMain main = this.Main;
                if (main != null)
                {
                    main.UpdateUIProgress(v);
                }

                p2 = null;
                p3 = null;
                dir = null;
            }
        }

        public void RunGameFrame()
        {
            //AddManager();
            StartCoroutine(InitLuaCode());
            InitILRuntime();
        }

        public void StartCoroutineFunc(Func<IEnumerator> CoroutineFunc)
        {
            StartCoroutine(CoroutineFunc());
        }

        public void StopCoroutineFunc(Func<IEnumerator> CoroutineFunc)
        {
            StopCoroutine(CoroutineFunc());
        }

        private void InitILRuntime()
        {
            GameObject go = Util.LoadAsset("HallPackage", "Dll");
            if (go == null)
            {
                Debug.LogError($"未获取到ilruntime脚本");
                return;
            }

            byte[] dll = go.GetComponent<ReferenceCollector>().Get<TextAsset>($"Hotfix.dll").bytes;
            AppFacade.Instance.GetManager<ILRuntimeManager>().LoadHotFix(dll, null);
        }
    }
}