using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using Hotfix.Hall;
using HybridCLR;
using LuaFramework;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.U2D;
using UnityEngine.UI;
using YooAsset;

namespace Hotfix
{
    public partial class CustomEvent
    {
        public const string DownEvent = "DownEvent";
        public const string DownStatus = "DownStatus";
    }
    public class ILGameManager : Singleton<ILGameManager>
    {
        private static List<string> aotDlls = new List<string>()
        {
            "Adjust.Runtime.dll", "Assembly-CSharp-firstpass.dll", "Assembly-CSharp.dll", "AVProVideo.Unity.dll",
            "BetterStreamingAssets.dll", "Coffee.UIEffect.dll", "CString.dll", "Debug.dll", "Debugger.dll",
            "DOTween.dll", "DOTween.Modules.dll", "DOTweenPro.dll", "DOTweenPro.Scripts.dll", "DragonBones_Unity.dll",
            "ES3.Unity.dll", "HybridCLR.Runtime.dll", "I18N.CJK.dll", "I18N.dll", "I18N.MidEast.dll", "I18N.Other.dll",
            "I18N.Rare.dll", "I18N.West.dll", "ILRuntime.dll", "ILRuntime.Mono.Cecil.dll",
            "ILRuntime.Mono.Cecil.Pdb.dll", "Mono.Security.dll", "mscorlib.dll", "NativeGallery.Runtime.dll",
            "spine-unity.dll", "StompyRobot.SRDebugger.dll", "StompyRobot.SRF.dll", "System.Configuration.dll",
            "System.Core.dll", "System.dll", "System.Numerics.dll", "System.Xml.dll", "Unity.Model.dll",
            "Unity.TextMeshPro.dll", "UnityEngine.AndroidJNIModule.dll", "UnityEngine.AnimationModule.dll",
            "UnityEngine.AssetBundleModule.dll", "UnityEngine.AudioModule.dll", "UnityEngine.CoreModule.dll",
            "UnityEngine.dll", "UnityEngine.GridModule.dll", "UnityEngine.ImageConversionModule.dll",
            "UnityEngine.IMGUIModule.dll", "UnityEngine.InputLegacyModule.dll", "UnityEngine.JSONSerializeModule.dll",
            "UnityEngine.ParticleSystemModule.dll", "UnityEngine.Physics2DModule.dll", "UnityEngine.PhysicsModule.dll",
            "UnityEngine.SharedInternalsModule.dll", "UnityEngine.SpriteShapeModule.dll",
            "UnityEngine.TextCoreModule.dll", "UnityEngine.TextCoreTextEngineModule.dll",
            "UnityEngine.TextRenderingModule.dll", "UnityEngine.TilemapModule.dll", "UnityEngine.UI.dll",
            "UnityEngine.UIModule.dll", "UnityEngine.UnityWebRequestAssetBundleModule.dll",
            "UnityEngine.UnityWebRequestAudioModule.dll", "UnityEngine.UnityWebRequestModule.dll",
            "UnityEngine.UnityWebRequestTextureModule.dll", "UnityEngine.UnityWebRequestWWWModule.dll",
            "UnityEngine.VideoModule.dll", "YooAsset.dll", "zlib.net.dll", "zxing.unity.dll",
        };

        private string _AccText;
        private string _PwText;
        private string _selfIP;
        private int ipIndex = 0;
        private string gameVersion;

        public GameObject RootObj { get; private set; }
        private Transform rootContent;

        public Transform HeadIcons { get; set; }
        private GameObject gameSetPanelObj;

        private Dictionary<int, PatchDownloaderOperation> _downloaderOperations;

        private Dictionary<int, GameDownStatus> _gameStatuses;

        public string UserAttribution { get; set; }
        public Dictionary<string, string> Attribution { get; set; }

        protected override void Awake()
        {
            base.Awake();
            SRDebug.Instance.HideDebugPanel();
            LoadScene($"module02", SceneType.Hall, (isdone, apt) =>
            {
                if (!isdone) return;
                RootObj = GameObject.FindGameObjectWithTag(LaunchTag._02hallTag);
                if (RootObj == null) RootObj = GameObject.Find("HallManager");
                if (RootObj == null)
                {
                    DebugHelper.LogError($"没有找到大厅根节点");
                    return;
                }

                RootObj.AddILComponent<UIManager>();
                rootContent = RootObj.transform.FindChildDepth($"Content");
            });
            AndroidBridge.Instance.OnRecieveMessage = OnRecieveMessage;
            AndroidBridge.Instance.InitInstallReferrer();     
            LoadAOT();     
            AddEvent();
            InitDownDictionary();
        }

        private void InitDownDictionary()
        {
            _downloaderOperations = new Dictionary<int, PatchDownloaderOperation>();   
            _gameStatuses = new Dictionary<int, GameDownStatus>();          
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            RemoveEvent();
        }

        private void OnRecieveMessage(string obj)
        {
            Attribution ??= new Dictionary<string, string>();
            UserAttribution = obj;
            if (string.IsNullOrEmpty(obj) || obj.Equals("ERROR")) return;
            var arr = obj.Split('&');
            for (int i = 0; i < arr.Length; i++)
            {
                var googleAttr = arr[i].Split('=');
                if (googleAttr.Length < 2) continue;
                Attribution.Add(googleAttr[0], googleAttr[1]);
            }
        }

        private void LoadAOT()
        {
            foreach (var aot in aotDlls)
            {
                if (aot.Contains("Hotfix")) continue;
                var txt = ToolHelper.LoadAsset<TextAsset>(SceneType.Hall, aot);
                if (txt == null) continue;
                var bytes = AES.AESDecrypt(txt.bytes, ILRuntimeManager.AesKey);
                HybridCLR.RuntimeApi.LoadMetadataForAOTAssembly(bytes, HomologousImageMode.SuperSet);
            }

            DebugHelper.LogError($"加载AOT dll成功");
        }

        protected void AddEvent()
        {
            HotfixActionHelper.OnEnterGame += HotfixActionHelper_OnEnterGame;
            HotfixActionHelper.LeaveGame += HotfixActionHelper_LeaveGame;
        }

        protected void RemoveEvent()
        {
            HotfixActionHelper.OnEnterGame -= HotfixActionHelper_OnEnterGame;
            HotfixActionHelper.LeaveGame -= HotfixActionHelper_LeaveGame;
        }

        private void HotfixActionHelper_LeaveGame()
        {
            // UIMask.Enable(true, () =>
            // {
            GameLocalMode.Instance.SetScreen(ScreenOrientation.Landscape);
            GameLocalMode.Instance.IsInGame = false;
            ILMusicManager.Instance.Init();
            rootContent.gameObject.SetActive(true);
            AppFacade.Instance.GetManager<MusicManager>().KillAllSoundEffect();
            AudioSource source = AppFacade.Instance.GetManager<MusicManager>().transform.GetComponent<AudioSource>();
            if (source != null)
            {
                HallExtend.Destroy(source);
            }

            ILMusicManager.Instance.PlayBackgroundMusic();
            DebugHelper.Log($"退出游戏");
            HotfixGameComponent.Instance.Send(DataStruct.UserDataStruct.MDM_GR_USER,
                DataStruct.UserDataStruct.SUB_GR_USER_LEFT_GAME_REQ, new ByteBuffer(), SocketType.Game);
            HotfixGameComponent.Instance.CloseNetwork(SocketType.Game);

            StartCoroutine(WaitSyncGoal());
            // Hall.PopTaskSystem.Model.Instance.StartPop();
        }

        private IEnumerator WaitSyncGoal()
        {
            yield return new WaitForSeconds(0.3f);
            ByteBuffer buffer = new ByteBuffer();
            buffer.WriteUInt32(GameLocalMode.Instance.SCPlayerInfo.DwUser_Id);
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO,
                DataStruct.PersonalStruct.SUB_3D_CS_SELECT_GOLD_MSG,
                buffer, SocketType.Hall);
            yield return new WaitForSeconds(0.3f);
            SceneManager.UnloadSceneAsync(GameLocalMode.Instance.CurrentGame);
            Util.Unload(GameLocalMode.Instance.CurrentGame);
            var pack = GameLocalMode.Instance.GetPackage(SceneType.Game);
            pack.UnloadUnusedAssets();
        }

        private void HotfixActionHelper_OnEnterGame()
        {
            GameLocalMode.Instance.IsInGame = false;
            GameLocalMode.Instance.IsInGame = true;
            AppFacade.Instance.GetManager<MusicManager>().OnInitialize();
            rootContent.gameObject.SetActive(false);
        }

        /// <summary>
        /// 加载场景
        /// </summary>
        /// <param name="sceneName">场景名</param>
        /// <param name="callback">加载完成回调</param>
        public void LoadScene(string sceneName, SceneType sceneType, CAction<bool, SceneOperationHandle> callback,
            LoadSceneMode mode = LoadSceneMode.Additive)
        {
            StartCoroutine(_LoadScene(sceneName, sceneType, callback, mode));
        }

        private IEnumerator _LoadScene(string sceneName, SceneType sceneType,
            CAction<bool, SceneOperationHandle> callback, LoadSceneMode mode = LoadSceneMode.Additive)
        {
            yield return new WaitForEndOfFrame();
            var pack = GameLocalMode.Instance.GetPackage(sceneType);
            SceneOperationHandle apt = pack.LoadSceneAsync(sceneName, mode);
            while (!apt.IsDone)
            {
                yield return new WaitForEndOfFrame();
                callback?.Invoke(false, apt);
            }

            callback?.Invoke(true, apt);
        }

        /// <summary>
        /// 发送登录
        /// </summary>
        /// <param name="account">账号信号</param>
        public void SendLoginMasseage(AccountMSG account)
        {
            var headimgurl = "";
            var nickname = "";

            HallStruct.REQ_CS_LOGIN login = new HallStruct.REQ_CS_LOGIN()
            {
                platform = GameLocalMode.Instance.Platform,
                channelID = GameLocalMode.Instance.GameQuDao,
                iD = GameLocalMode.Instance.PlatformID,
                addMultiplyID = (uint) (GameLocalMode.Instance.PlatformID * GameLocalMode.Instance.LoginPlatMultiply +
                                        GameLocalMode.Instance.LoginPlatAdd),
                multiplyID = (ushort) (GameLocalMode.Instance.PlatformID * GameLocalMode.Instance.LoginPlatMultiply),
                addID = (byte) (GameLocalMode.Instance.PlatformID + GameLocalMode.Instance.LoginPlatAdd),
                account = account.account,
                password = account.password,
                mechinaCode = GameLocalMode.Instance.MechinaCode,
                ip = GameLocalMode.Instance.IP,
                headUrl = headimgurl,
                nickName = nickname,
                nIsDrain = (byte) (GameLocalMode.Instance.CheckUserIsNature() ? 0 : 1),
            };
            DebugHelper.Log(LitJson.JsonMapper.ToJson(login));
            HotfixGameComponent.Instance.Send(DataStruct.LoginStruct.MDM_3D_LOGIN,
                DataStruct.LoginStruct.SUB_3D_CS_LOGIN, login.ByteBuffer, SocketType.Hall);
        }

        /// <summary>
        /// 查询自己的金币
        /// </summary>
        public void QuerySelfGold()
        {
            DebugHelper.Log("查询自己的金币");
            var buffer = new ByteBuffer();
            buffer.WriteUInt32(GameLocalMode.Instance.SCPlayerInfo.DwUser_Id); // 玩家ID
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO,
                DataStruct.PersonalStruct.SUB_3D_CS_SELECT_GOLD_MSG, buffer, SocketType.Hall);
        }

        /// <summary>
        /// 获取自己头像
        /// </summary>
        /// <returns></returns>
        public Sprite GetHeadIcon(uint faceId = 0)
        {
            if (HeadIcons == null)
            {
                HeadIcons = ToolHelper.LoadAsset<GameObject>(SceneType.Hall, "HeadIcons")?.transform;
            }

            if (HeadIcons == null) return null;
            uint id = 0;
            if (faceId > 0)
            {
                id = faceId - 1;
                if (id >= HeadIcons.transform.childCount) id = 0;
                return HeadIcons.transform.GetChild((int) id).GetComponent<Image>().sprite;
            }

            bool isExist = (GameLocalMode.Instance.SCPlayerInfo != null &&
                            GameLocalMode.Instance.SCPlayerInfo.FaceID > 0);
            if (isExist) id = GameLocalMode.Instance.SCPlayerInfo.FaceID - 1;
            if (id >= HeadIcons.transform.childCount) id = 0;
            return isExist ? HeadIcons.transform.GetChild((int) id).GetComponent<Image>().sprite : null;
        }

        public GameObject GetGameSetPanel(Transform parent)
        {
            if (gameSetPanelObj == null)
            {
                gameSetPanelObj = ToolHelper.LoadAsset<GameObject>(SceneType.Hall, "GameSetsPanel");
            }

            GameObject go = ToolHelper.Instantiate(gameSetPanelObj);
            go.transform.SetParent(parent);
            go.transform.localPosition = Vector3.zero;
            go.transform.localScale = Vector3.one;
            go.transform.localRotation = Quaternion.identity;
            go.transform.GetComponent<RectTransform>().anchorMax = Vector2.one;
            go.transform.GetComponent<RectTransform>().anchorMin = Vector2.zero;
            go.transform.GetComponent<RectTransform>().offsetMax = Vector2.zero;
            go.transform.GetComponent<RectTransform>().offsetMin = Vector2.zero;

            go.transform.AddILComponent<GameSetBtns>();
            return go;
        }

        public InitializeParameters GetInitializeParam(SceneType type)
        {
            InitializeParameters initParameters = null;
            switch (type)
            {
                case SceneType.Hall:
                    switch (Framework.Assets.Model.Instance.PlayMode)
                    {
                        case Framework.Assets.PlayMode.EditorSimulateMode:
                            initParameters = new EditorSimulateModeParameters
                            {
                                SimulatePatchManifestPath =
                                    EditorSimulateModeHelper.SimulateBuild(GameLocalMode.HallPackage),
                                DecryptionServices = new YooAsset.BundleDecryptionServices()
                            };
                            break;
                        case Framework.Assets.PlayMode.PreRelease:
                            initParameters = new HostPlayModeParameters
                            {
                                QueryServices = new QueryStreamingAssetsFileServices(),
                                DefaultHostServer =
                                    $"{AppConst.DNSUrl}/{Util.PlatformName}/{GameLocalMode.HallPackage}/PreRelease",
                                FallbackHostServer =
                                    $"{AppConst.DNSUrl}/{Util.PlatformName}/{GameLocalMode.HallPackage}/PreRelease",
                                DecryptionServices = new YooAsset.BundleDecryptionServices()
                            };
                            break;
                        case Framework.Assets.PlayMode.Release:
                            initParameters = new HostPlayModeParameters
                            {
                                QueryServices = new QueryStreamingAssetsFileServices(),
                                DefaultHostServer =
                                    $"{AppConst.DNSUrl}/{Util.PlatformName}/{GameLocalMode.HallPackage}/Release",
                                FallbackHostServer =
                                    $"{AppConst.DNSUrl}/{Util.PlatformName}/{GameLocalMode.HallPackage}/Release",
                                DecryptionServices = new YooAsset.BundleDecryptionServices()
                            };
                            break;
                        default:
                            throw new ArgumentOutOfRangeException();
                    }

                    break;
                case SceneType.Game:
                    initParameters = new HostPlayModeParameters
                    {
                        QueryServices = new QueryStreamingAssetsFileServices(),
                        DefaultHostServer = $"{AppConst.DNSUrl}/{(Util.IsDebug ? "" : Util.PlatformName)}/Game",
                        FallbackHostServer = $"{AppConst.DNSUrl}/{(Util.IsDebug ? "" : Util.PlatformName)}/Game",
// DefaultHostServer = $"http://192.168.0.108:8080/SJHLCRes/{Application.version}/{(Util.IsDebug ? "" : Util.PlatformName)}/Game",
//
// FallbackHostServer = $"http://192.168.0.108:8080/SJHLCRes/{Application.version}/{(Util.IsDebug ? "" : Util.PlatformName)}/Game",
                        DecryptionServices = new BundleDecryptionServices()
                    };
                    break;
                default:
                    throw new ArgumentOutOfRangeException(nameof(type), type, null);
            }

            return initParameters;
        }

        /// <summary>
        /// 获取游戏状态是否需要下载更新
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public GameDownStatus GetGameStatus(int id)
        {
            if (_gameStatuses.TryGetValue(id, out GameDownStatus status))
                return status;
            var pack = GameLocalMode.Instance.GetPackage(SceneType.Game);
            GameData data = GameConfig.GetGameData(id);
            if (data == null)
            {
                DebugTool.LogError($"not find config id={id}");
                return GameDownStatus.None;
            }

            List<string> files = data.configer.downFiles;
            string[] pathFiles = new string[files.Count];
            status = GameDownStatus.Downed;
            for (int i = 0; i < files.Count; i++)
            {
                pathFiles[i] = files[i];
                if (!pack.IsNeedDownloadFromRemote(files[i])) continue;
                status = GameDownStatus.None;
                break;
            }

            _gameStatuses[id] = status;
            return status;
        }

        public void CreateDownLoader(int id)
        {
            int gameId = id;
            _downloaderOperations.TryGetValue(gameId, out var downloader);
            var pack = GameLocalMode.Instance.GetPackage(SceneType.Game);
            if (downloader != null)
            {
                GameDownStatus status = GetGameStatus(gameId);
                switch (status)
                {
                    case GameDownStatus.None:
                        downloader.ResumeDownload();
                        HotfixMessageHelper.PostMessageEvent(CustomEvent.DownStatus, gameId, GameDownStatus.Downing);
                        break;
                }
                return;
            }
            GameData data = GameConfig.GetGameData(gameId);
            if (data == null)
            {
                DebugTool.LogError($"not find config id={gameId}");
                return;
            }

            List<string> files = data.configer.downFiles;
            string[] pathFiles = new string[files.Count];
            for (int i = 0; i < pathFiles.Length; i++)
            {
                pathFiles[i] = files[i];
            }
            int downloadingMaxNum = 10;
            int failedTryAgain = 3;
            int timeout = 60;
            downloader =
                pack.CreatePatchDownloader(pathFiles, downloadingMaxNum, failedTryAgain, timeout);
            long totalDownloadBytes = downloader.TotalDownloadBytes;
            //没有需要下载的资源
            if (totalDownloadBytes == 0)
            {
                _gameStatuses[gameId] = GameDownStatus.Downed;
                HotfixMessageHelper.PostMessageEvent(CustomEvent.DownEvent, gameId, 1);
                HotfixMessageHelper.PostMessageEvent(CustomEvent.DownStatus, gameId, GameDownStatus.Downed);
                return;
            }

            downloader.OnDownloadErrorCallback =
                (name, error) => HotfixMessageHelper.PostMessageEvent(CustomEvent.DownEvent, gameId, -1);
            downloader.OnDownloadProgressCallback =
                (count, downloadCount, bytes, downloadBytes) =>
                {
                    double progress = (double) downloadBytes / totalDownloadBytes;
                    HotfixMessageHelper.PostMessageEvent(CustomEvent.DownEvent, gameId, progress);
                    if (progress >= 1)
                    {
                        _gameStatuses[gameId] = GameDownStatus.Downed;
                        HotfixMessageHelper.PostMessageEvent(CustomEvent.DownStatus, gameId, GameDownStatus.Downed);
                    }
                };
            _downloaderOperations[id] = downloader;
            _downloaderOperations[id].BeginDownload();
            _gameStatuses[gameId] = GameDownStatus.Downing;
            HotfixMessageHelper.PostMessageEvent(CustomEvent.DownStatus, gameId, GameDownStatus.Downing);
        }

        public void StopDownload(int id)
        {
            if (!_downloaderOperations.ContainsKey(id)) return;
            _downloaderOperations[id].CancelDownload();
            _downloaderOperations.Remove(id);
            _gameStatuses[id] = GameDownStatus.None;
            HotfixMessageHelper.PostMessageEvent(CustomEvent.DownStatus, id, GameDownStatus.None);
        }

        public async Task UpdateAllGameConfig()
        {
            var pack = GameLocalMode.Instance.GetPackage(SceneType.Game);
            if (pack.InitializeStatus != EOperationStatus.Succeed)
                await pack.InitializeAsync(GetInitializeParam(SceneType.Game)).Task;

            var versionOperation = pack.UpdatePackageVersionAsync();
            await versionOperation.Task;
            if (versionOperation.Status != EOperationStatus.Succeed)
            {
                DebugHelper.LogError($"{versionOperation.Error}");
                return;
            }

            if (!string.IsNullOrEmpty(gameVersion) && gameVersion.Equals(versionOperation.PackageVersion)) return;
            var manifestOperation = pack.UpdatePackageManifestAsync(versionOperation.PackageVersion);
            await manifestOperation.Task;
            if (manifestOperation.Status != EOperationStatus.Succeed)
            {
                DebugHelper.LogError($"{manifestOperation.Error}");
                return;
            }

            gameVersion = versionOperation.PackageVersion;
        }

        public async void UpdateGame(int id, CAction<bool, float> progressCall)
        {
            GameData data = GameConfig.GetGameData(id);
            if (data == null)
            {
                progressCall?.Invoke(false, 0);
                return;
            }

            var pack = GameLocalMode.Instance.GetPackage(SceneType.Game);
            if (pack.InitializeStatus != EOperationStatus.Succeed)
                await pack.InitializeAsync(GetInitializeParam(SceneType.Game)).Task;
            var versionOperation = pack.UpdatePackageVersionAsync();
            await versionOperation.Task;
            if (versionOperation.Status != EOperationStatus.Succeed)
            {
                progressCall?.Invoke(false, -1);
                return;
            }

            if (string.IsNullOrEmpty(gameVersion) || !gameVersion.Equals(versionOperation.PackageVersion))
            {
                var manifestOperation = pack.UpdatePackageManifestAsync(versionOperation.PackageVersion);
                await manifestOperation.Task;
                if (manifestOperation.Status != EOperationStatus.Succeed)
                {
                    progressCall?.Invoke(false, -1);
                    return;
                }

                gameVersion = versionOperation.PackageVersion;
            }

            int downloadingMaxNum = 10;
            int failedTryAgain = 3;
            int timeout = 60;
            List<string> files = data.configer.downFiles;
            var downloader =
                pack.CreatePatchDownloader(files.ToArray(), downloadingMaxNum, failedTryAgain, timeout);
            //没有需要下载的资源
            if (downloader.TotalDownloadCount == 0)
            {
                progressCall?.Invoke(true, 1);
                return;
            }

            //需要下载的文件总数和总大小
            int totalDownloadCount = downloader.TotalDownloadCount;
            long totalDownloadBytes = downloader.TotalDownloadBytes;

            //注册回调方法
            downloader.OnDownloadErrorCallback = delegate { progressCall?.Invoke(false, -1); };
            downloader.OnDownloadProgressCallback =
                delegate(int count, int downloadCount, long bytes, long downloadBytes)
                {
                    decimal progress = (decimal) downloadBytes / totalDownloadBytes;
                    progressCall?.Invoke(false, (float) progress);
                };
            downloader.OnDownloadOverCallback = null;
            downloader.OnStartDownloadFileCallback = null;
            //开启下载
            downloader.BeginDownload();
            await downloader.Task;
            if (downloader.Status != EOperationStatus.Succeed)
            {
                await Task.Delay(100);
                progressCall?.Invoke(false, -1);
                return;
            }

            progressCall?.Invoke(true, 1);
        }
    }
}