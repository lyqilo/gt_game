using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using LuaFramework;
using System.IO;
using DG.Tweening;
using Spine.Unity;
using TMPro;

namespace Hotfix.Hall
{
    internal class DownLoadGamePanel : PanelBase
    {
        HallStruct.RoomInfo info;

        Button closeBtn;
        Text downloadValue;
        TextMeshProUGUI downloadDesc;
        SkeletonGraphic anim;
        Slider downProgress;

        GameObject downObj;

        private List<IState> states;
        private HierarchicalStateMachine hsm;
        private Transform mainPanel;
        private Button maskCloseBtn;

        public DownLoadGamePanel() : base(UIType.Top, nameof(DownLoadGamePanel))
        {
        }

        public override void Create(params object[] args)
        {
            base.Create(args);
            if (args.Length <= 0) return;
            info = (HallStruct.RoomInfo)args[0];
            Init();
        }

        protected override void Start()
        {
            base.Start();
            states = new List<IState>();
            hsm = new HierarchicalStateMachine(false, gameObject);
            states.Add(new IdleState(this, hsm));
            states.Add(new ConnectState(this, hsm));
            states.Add(new LoadGameState(this, hsm));
            states.Add(new DownloadGameState(this, hsm));
            hsm.Init(states, nameof(IdleState));
        }

        protected override void Update()
        {
            base.Update();
            hsm?.Update();
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            mainPanel = transform.FindChildDepth("MainPanel");
            closeBtn = mainPanel.FindChildDepth<Button>("CloseBtn");
            downloadValue = mainPanel.FindChildDepth<Text>("ProgressValue");
            downloadDesc = mainPanel.FindChildDepth<TextMeshProUGUI>("Desc");
            anim = mainPanel.FindChildDepth<SkeletonGraphic>("Anim");
            downProgress = mainPanel.FindChildDepth<Slider>("Progress");
            
            anim.transform.localScale = Vector3.zero;
            anim.transform.DOScale(1, 0.5f).SetEase(Ease.OutBack);
        }

        protected override void AddListener()
        {
            base.AddListener();
            closeBtn.onClick.RemoveAllListeners();
            closeBtn.onClick.Add(() =>
            {
                if (downObj != null)
                {
                    HallExtend.Destroy(downObj);
                }
                HotfixGameComponent.Instance.CloseNetwork(SocketType.Game);
                ILMusicManager.Instance.PlayBtnSound();
                UIManager.Instance.Close();
            });
        }

        private void Init()
        {
            hsm?.ChangeState(nameof(ConnectState));
        }

        private class IdleState : State<DownLoadGamePanel>
        {
            public IdleState(DownLoadGamePanel owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }
        /// <summary>
        /// 连接服务器
        /// </summary>
        private class ConnectState : State<DownLoadGamePanel>
        {
            public ConnectState(DownLoadGamePanel owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                GameLocalMode.Instance.SCPlayerInfo.ReconnectGameID = 0;
                GameLocalMode.Instance.SCPlayerInfo.ReconnectFloorID = 0;
                owner.downloadDesc.text = $"正在连接……";
                owner.downloadValue.text = $"0%";
                owner.downProgress.value = 0;
                GameLocalMode.Instance.GameHost = owner.info._4dwServerAddr;
                GameLocalMode.Instance.GamePort = owner.info._5wServerPort;
                if (GameLocalMode.Instance.GWData.isUseGameIP)
                {
                    if (GameLocalMode.Instance.GWData.isUseDefence)
                    {
                        GameLocalMode.Instance.GameHost = Util.isPc || Util.isEditor
                            ? GameLocalMode.Instance.GWData.DefencePCGameIP
                            : GameLocalMode.Instance.GWData.DefenceGameIP;
                    }
                    else
                    {
                        GameLocalMode.Instance.GameHost = Util.isPc || Util.isEditor
                            ? GameLocalMode.Instance.GWData.PCGameIP
                            : GameLocalMode.Instance.GWData.GameIP;
                    }
                }
                else
                {
                    if (GameLocalMode.Instance.GWData.isUseDefence)
                    {
                        GameLocalMode.Instance.GameHost = Util.isPc || Util.isEditor
                            ? GameLocalMode.Instance.GWData.DefencePCGameIP
                            : GameLocalMode.Instance.GWData.DefenceGameIP;
                    }
                }
                HotfixGameComponent.Instance.ConnectGameServer(isSuccess =>
                {
                    if (isSuccess)
                    {
                        InitLua();
                        hsm?.ChangeState(nameof(DownloadGameState));
                        return;
                    }
                    hsm?.ChangeState(nameof(IdleState));
                    UIManager.Instance.Close();
                    ToolHelper.PopBigWindow(new BigMessage()
                    {
                        content = $"Connect server failed"
                    });
                });
            }

            private void InitLua()
            {
                GameData data = GameConfig.GetGameData(owner.info._2wGameID);
                if (data.configer.driveType != ScriptType.ILRuntime)
                {
                    AppFacade.Instance.GetManager<LuaManager>().DoFile(data.configer.luaPath.Replace('.', '/'));
                }
            }
        }
        /// <summary>
        /// 加载游戏
        /// </summary>
        private class LoadGameState : State<DownLoadGamePanel>
        {
            public LoadGameState(DownLoadGamePanel owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            GameData _data;
            public override void OnEnter()
            {
                base.OnEnter();
                owner.closeBtn.gameObject.SetActive(false);
                owner.downloadDesc.text = $"Loading…";
                _data = GameConfig.GetGameData(owner.info._2wGameID);
                // UIMask.Enable(true, () =>
                // {
                    GameLocalMode.Instance.SetScreen(_data.Orientation);
                    var gamePackage = GameLocalMode.Instance.GetPackage(SceneType.Game);
                    YooAsset.YooAssets.SetDefaultAssetsPackage(gamePackage);
                    ILGameManager.Instance.LoadScene(_data.scenName, SceneType.Game, (isdone, apt) =>
                    {
                        if (!isdone)
                        {
                            owner.downProgress.value = apt.Progress;
                            owner.downloadValue.text = $"{Mathf.Ceil(apt.Progress * 100)}%";
                        }
                        else
                        {
                            owner.downProgress.value = 1;
                            owner.downloadValue.text = $"100%";
                            hsm?.ChangeState(nameof(IdleState));
                            OnLoadComplete();
                            // ToolHelper.DelayRun(0.5f, () => { UIMask.Enable(false); });
                        }
                    });
                // });
            }

            private void OnLoadComplete()
            {
                UIManager.Instance.CloseUI<DownLoadGamePanel>();
                ILMusicManager.Instance.StopMusic();
                ILMusicManager.Instance.SyncData();
                HotfixActionHelper.DispatchOnEnterGame();
                GameLocalMode.Instance.CurrentGame = _data.scenName;
                if (_data.configer.driveType == ScriptType.Lua)
                {
                    GameObject go = GameObject.FindGameObjectWithTag(LaunchTag._01gameTag);
                    if (go == null)
                    {
                        go = GameObject.Find(_data.configer.luaRootName);
                        if (go == null)
                        {
                            DebugHelper.LogError($"没有找到根节点 {_data.configer.luaRootName} 0");
                            return;
                        }
                    }
                    else
                    {
                        if (go.name != _data.configer.luaRootName)
                        {
                            Transform child = go.transform.FindChildDepth(_data.configer.luaRootName);
                            if (child != null)
                            {
                                go = child.gameObject;
                            }
                        }
                    }

                    LuaBehaviour behaviour = go.CreateOrGetComponent<LuaBehaviour>();
                }
                else
                {
                    EventHelper.DispatchOnEnterGame(_data.scenName);
                }
            }
        }
        /// <summary>
        /// 下载游戏
        /// </summary>
        private class DownloadGameState : State<DownLoadGamePanel>
        {
            public DownloadGameState(DownLoadGamePanel owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            bool isComplete;
            public override void OnEnter()
            {
                base.OnEnter();
                owner.downProgress.value = 0;
                owner.closeBtn.gameObject.SetActive(true);
                isComplete = false;
            }
            public override void Update()
            {
                base.Update();
                if (isComplete) return;
                isComplete = true;
                owner.downloadDesc.text = $"正在下载游戏……";
                owner.downloadValue.text = $"0%";
                ILGameManager.Instance.UpdateGame(owner.info._2wGameID, OnDownGameCall);
                // hsm?.ChangeState(nameof(LoadGameState));
            }
            private void OnDownComplete(bool obj)
            {
                if (!obj)
                {
                    owner.downloadDesc.text = $"下载错误";
                    return;
                }
                hsm?.ChangeState(nameof(LoadGameState));
            }
            /// <summary>
            /// 下载进度
            /// </summary>
            /// <param name="progress">进度</param>
            /// <param name="t2"></param>
            private void OnDownGameCall(bool isSuccess,float progress)
            {
                owner.downProgress.value = progress;
                owner.downloadValue.text = $"{Mathf.Ceil(progress * 100)}%";
                if(isSuccess)
                {
                    hsm?.ChangeState(nameof(LoadGameState));
                    return;
                }
                float p = progress < 0 ? 0 : progress;
                owner.downProgress.value = p;
                owner.downloadValue.text = $"{Mathf.Ceil(p * 100)}%";
                if (progress < 0)
                {
                    owner.downloadDesc.text = $"下载错误";
                }
            }
        }
    }
    public static class DownLoadFile
    {
        /// <summary>
        /// 是否下载游戏
        /// </summary>
        /// <param name="id">游戏id</param>
        /// <returns></returns>
        public static bool IsDown(int id)
        {
            bool isDown = false;
            GameData data = GameConfig.GetGameData(id);
            List<string> files = data.configer.downFiles;
            BaseValueConfigerJson[] configer = AppConst.gameValueConfiger.GetModule(data.scenName);
            for (int i = 0; i < files.Count; i++)
            {
                string path = $"{PathHelp.AppHotfixResPath}{files[i]}";
                if (!File.Exists(path))
                {
                    string dirName = Path.GetDirectoryName(path);
                    if (!Directory.Exists(dirName))
                    {
                        Directory.CreateDirectory(dirName);
                    }
                    isDown = true;
                    break;
                }
                for (int j = 0; j < configer.Length; j++)
                {
                    BaseValueConfigerJson con = configer[j];
                    if (!files[i].ToLower().Equals(con.dirPath.ToLower())) continue;
                    string localMd5 = MD5Helper.MD5File(path);
                    if (!localMd5.Equals(con.md5))
                    {
                        isDown = true;
                        break;
                    }
                }
            }
            return isDown;
        }
        /// <summary>
        /// 下载游戏资源
        /// </summary>
        /// <param name="id">游戏id</param>
        /// <param name="callback">回调</param>
        /// <returns></returns>
        public static GameObject  DownloadFileAsync(int id,CAction<float,object> callback)
        {
            GameData data = GameConfig.GetGameData(id);
            List<string> files = data.configer.downFiles;
            UnityWebDownPacketQueue queue = new UnityWebDownPacketQueue();
            BaseValueConfigerJson[] configer = AppConst.gameValueConfiger.GetModule(data.scenName);
            for (int i = 0; i < files.Count; i++)
            {
                for (int j = 0; j < configer.Length; j++)
                {
                    BaseValueConfigerJson con = configer[j];
                    if (!files[i].ToLower().Equals(con.dirPath.ToLower())) continue;
                    string localUlr = $"{PathHelp.AppHotfixResPath}{con.dirPath}";
                    if (File.Exists(localUlr))
                    {
                        string localMd5 = MD5Helper.MD5File(localUlr);
                        if (localMd5.Equals(con.md5)) continue;
                        File.Delete(localUlr);
                    }
                    string webUrl = $"{AppConst.WebUrl}games/{con.dirPath}?md5={con.md5}";
                    DebugHelper.Log($"需要下载的资源地址:{webUrl}");
                    UnityWebPacket unityWeb = new UnityWebPacket();
                    unityWeb.urlPath = webUrl;
                    unityWeb.localPath = localUlr;
                    unityWeb.size = ulong.Parse(con.size);
                    unityWeb.func = (a, b) =>
                    {
                        callback?.Invoke(a, b);
                    };
                    queue.Add(unityWeb);
                }
            }
            GameObject go = new GameObject($"UnityWebRequestAsync");
            UnityWebRequestAsync asyncDown = go.AddComponent<UnityWebRequestAsync>();
            asyncDown.DownloadAsync(queue);
            return go;
        }
    }
}