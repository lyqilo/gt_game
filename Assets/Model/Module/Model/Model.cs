using System;
using System.Threading.Tasks;
using LitJson;
using LuaFramework;
using UnityEngine;
using YooAsset;

namespace Framework.Assets
{
    public enum PlayMode
    {
        EditorSimulateMode,
        PreRelease,
        Release,
    }
    
    public class Model : Singleton.Singleton<Model>
    {
        public PlayMode PlayMode { get; set; }
        public string Auth { get; private set; }
        private UILaunch _launch;
        private GameManager _gameManager;

        protected override void InitImmediate()
        {
            base.InitImmediate();
#if UNITY_STANDALONE_WIN
            ES3.Save(ScreenOrientation,UnityEngine.ScreenOrientation.Landscape.ToString());
#endif
            _gameManager = AppFacade.Instance.AddManager<GameManager>();
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

        private void CheckAuth()
        {
            var txt = Resources.Load<TextAsset>($"dns");
            string key = $"byte";
            var bs = MD5Helper.Decrypt(txt.text, key);
            DNS table = JsonMapper.ToObject<DNS>(bs);
            Auth = table.auth;
            AppConst.DNS = table.dns.ToArray();
            AppConst.CdnDirectoryName = table.cdnDirectoryName;
            AppConst.AuthCode = table.auth;
        }

        public async void UpdateRes(UILaunch launch)
        {
            _launch = launch;
            CheckAuth();
            bool isSuccess = await _gameManager.OnInitWebUrl();
            if (!isSuccess)
            {
                await Task.Delay(1000);
                UpdateRes(_launch);
                return;
            }

            await UpdatePackage("HallPackage", ()=>
            {
                UpdateRes(_launch);
            }, UpdateSuccess, p =>
            {
                if (_launch != null)
                {
                    _launch.SetProgress(p);
                    _launch.SetDesc("正在更新……");
                }
            });
        }

        private async Task UpdateSuccess()
        {
            _launch.SetProgress(1);
            _launch.SetDesc("更新完成");
            await _gameManager.InitConfiger();
            DebugTool.Log($"更新完成");
            _gameManager.RunGameFrame();
        }

        public async Task<bool> UpdatePackage(string packageName, Action restartCall, Func<Task> completeCall,Action<float> progressCall,
            bool isDefault = true)
        {
            DebugTool.Log($"开始更新资源");
            // 创建默认的资源包
            var hallPackage = YooAssets.GetAssetsPackage(packageName) ?? YooAssets.CreateAssetsPackage(packageName);
// 设置该资源包为默认的资源包，可以使用YooAssets相关加载接口加载该资源包内容。
            if (isDefault) YooAssets.SetDefaultAssetsPackage(hallPackage);
            if (hallPackage.InitializeStatus != EOperationStatus.Succeed)
                await hallPackage.InitializeAsync(GetParameters(packageName)).Task;
            var versionOperation = hallPackage.UpdatePackageVersionAsync();
            await versionOperation.Task;
            if (versionOperation.Status != EOperationStatus.Succeed)
            {
                await Task.Delay(1000);
                restartCall?.Invoke();
                return false;
            }

            var manifestOperation = hallPackage.UpdatePackageManifestAsync(versionOperation.PackageVersion);
            await manifestOperation.Task;
            if (manifestOperation.Status != EOperationStatus.Succeed)
            {
                await Task.Delay(1000);
                restartCall?.Invoke();
                return false;
            }

            int downloadingMaxNum = 10;
            int failedTryAgain = 3;
            int timeout = 60;
            var downloader = hallPackage.CreatePatchDownloader(downloadingMaxNum, failedTryAgain, timeout);
            //没有需要下载的资源
            if (downloader.TotalDownloadCount == 0)
            {
                DebugTool.Log($"没有可更新资源");
                if (completeCall != null) await completeCall?.Invoke();
                return true;
            }

            //需要下载的文件总数和总大小
            int totalDownloadCount = downloader.TotalDownloadCount;
            long totalDownloadBytes = downloader.TotalDownloadBytes;

            //注册回调方法
            downloader.OnDownloadErrorCallback = delegate { restartCall?.Invoke(); };
            downloader.OnDownloadProgressCallback =
                delegate(int count, int downloadCount, long bytes, long downloadBytes)
                {
                    decimal progress = (decimal) downloadBytes / totalDownloadBytes;
                    progressCall?.Invoke((float) progress);
                };
            downloader.OnDownloadOverCallback = null;
            downloader.OnStartDownloadFileCallback = null;
            //开启下载
            downloader.BeginDownload();
            await downloader.Task;
            if (downloader.Status != EOperationStatus.Succeed)
            {
                await Task.Delay(1000);
                restartCall?.Invoke();
                return false;
            }

            hallPackage.ClearPackageUnusedCacheFilesAsync();
            DebugTool.Log($"更新完成");
            if (completeCall != null) await completeCall?.Invoke();
            return true;
        }

        private InitializeParameters GetParameters(string packageName)
        {
            switch (PlayMode)
            {
                case PlayMode.EditorSimulateMode:
                {
                    var initParameters = new EditorSimulateModeParameters
                    {
                        SimulatePatchManifestPath = EditorSimulateModeHelper.SimulateBuild(packageName),
                        DecryptionServices = new YooAsset.BundleDecryptionServices()
                    };
                    return initParameters;
                }
                case PlayMode.PreRelease:
                {
                    var initParameters = new HostPlayModeParameters
                    {
                        QueryServices = new QueryStreamingAssetsFileServices(),
                        DefaultHostServer = $"{AppConst.DNSUrl}/{Util.PlatformName}/{packageName}/PreRelease",
                        FallbackHostServer = $"{AppConst.DNSUrl}/{Util.PlatformName}/{packageName}/PreRelease",
                        DecryptionServices = new YooAsset.BundleDecryptionServices()
                    };
                    return initParameters;
                }
                case PlayMode.Release:
                {
                    var initParameters = new HostPlayModeParameters
                    {
                        QueryServices = new QueryStreamingAssetsFileServices(),
                        DefaultHostServer = $"{AppConst.DNSUrl}/{Util.PlatformName}/{packageName}/Release",
                        FallbackHostServer = $"{AppConst.DNSUrl}/{Util.PlatformName}/{packageName}/Release",
                        DecryptionServices = new YooAsset.BundleDecryptionServices()
                    };
                    return initParameters;
                }
                default:
                    throw new ArgumentOutOfRangeException();
            }
        }

        private void OnDestroy()
        {
            YooAsset.YooAssets.Destroy();
        }
        
    }
}