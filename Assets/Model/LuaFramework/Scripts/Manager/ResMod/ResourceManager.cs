using UnityEngine;
using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.IO;
//using BuildConfig;
using Object = UnityEngine.Object;
using System.Collections;
using LuaInterface;

namespace LuaFramework
{
    public class ResourceManager : Manager
    {
        private class AssetRequest : IPool
        {
            private Stopwatch sw = new Stopwatch();

            private Action<Object> _callBack;

            public Action<Object> CallBack
            {
                set
                {
                    if (_callBack == null)
                        _callBack = value;
                    else
                        _callBack += value;
                }
                get { return _callBack; }
            }

            public AssetBundleRequest AssetBundleRequest { private set; get; }

            public Object Asset { private set; get; }

            public string AssetName { private set; get; }

            public string AssetBundleName { private set; get; }

            public string AssetPath { private set; get; }

            public bool IsLoading { private set; get; }

            public bool IsFinished { private set; get; }

            private List<AssetBundle> abList;

            public void Init(string assetName, string assetBundleName, string assetPath, Action<Object> callBack)
            {
                AssetName = assetName;
                AssetBundleName = assetBundleName;
                AssetPath = assetPath;
                CallBack = callBack;
                IsLoading = false;
                IsFinished = false;
            }

            public void Clear()
            {
                _callBack = null;
                AssetBundleRequest = null;
                Asset = null;
                AssetName = null;
                AssetBundleName = null;
                AssetPath = null;
                IsLoading = false;
                IsFinished = false;
                abList = null;
                sw.Reset();
            }

            public void StartLoadAsset()
            {
//                if (IsLoading || IsFinished) return;
//                IsLoading = true;

//#if UNITY_EDITOR
//                if (LoadState.AssetLoadState)
//                {
//                    abList = LoadAssetBundles(AssetBundleName);
//                    if (abList == null)
//                    {
//                        //载入失败直接返回
//                        FinishLoadAsset(null);
//                        return;
//                    }

//                    //载入资源
//                    var mainAB = abList[0];
//                    AssetBundleRequest = mainAB.LoadAssetAsync<Object>(AssetName);
//                }
//                else
//                {
//                    //载入资源
//                    var asset = UnityEditor.AssetDatabase.LoadAssetAtPath<Object>(AssetPath + "/" + AssetName);
//                    FinishLoadAsset(asset);
//                }
//#else
//                abList = LoadAssetBundles(AssetBundleName);
//                    if (abList == null)
//                    {
//                        //载入失败直接返回
//                        FinishLoadAsset(null);
//                        return;
//                    }

//                    //载入资源
//                    var mainAB = abList[0];
//                    AssetBundleRequest = mainAB.LoadAssetAsync<Object>(AssetName);
//#endif
            }

            public void UpdateLoadAsset()
            {
                if (IsFinished || !IsLoading) return;
#if UNITY_EDITOR
                if (!AssetBundleRequest.isDone) return;
                FinishLoadAsset(AssetBundleRequest.asset);
#else
                if (!AssetBundleRequest.isDone) return;
                FinishLoadAsset(AssetBundleRequest.asset);
#endif
            }

            public void FinishLoadAsset(Object asset)
            {
                ReleaseAssetBundle(abList);
                abList = null;
                AssetBundleRequest = null;
                IsFinished = true;
                IsLoading = false;
                Asset = asset;
                if (asset == null)
                {
                    DebugTool.LogError(string.Format("加载资源失败!名称:[{0}]", AssetName));
                }
            }
        }

        private static AssetBundleManager AbMrg;

        private static AssetBundleManifest AbManifest;

        // private static ResourcePathConfig ResPathConfig;

        private ObjectPool<AssetRequest> assetReqPool = new ObjectPool<AssetRequest>(null, l => l.Clear());

        private Dictionary<string, Object> objsMap = new Dictionary<string, Object>(); //载入的资源缓存Map

        private Queue<AssetRequest> reqLoadQueue = new Queue<AssetRequest>(); //异步加载队列

        private Dictionary<string, AssetRequest> reqMap = new Dictionary<string, AssetRequest>(); //异步载入请求Map

        public Dictionary<string, AssetBundle> bundles;
        public Queue<ABPacket> ABPackets = new Queue<ABPacket>();
        private Dictionary<string, Object> _objRes = new Dictionary<string, Object>();
        public override void OnInitialize()
        {
            bundles = new Dictionary<string, AssetBundle>();
            _objRes.Clear();
        }

        /// <summary>
        /// 销毁资源
        /// </summary>
        public override void UnInitialize()
        {
            ClearAsset();
            AbMrg = null;
            AbManifest = null;
            _objRes.Clear();
            // ResPathConfig = null;
        }

        public bool CheckResKeyVaild(string key, bool isHall = true)
        {
            if (_objRes.ContainsKey(key)) return true;
            string packName = isHall ? "HallPackage" : "GamePackage";
            var pack = YooAsset.YooAssets.GetAssetsPackage(packName) ??
                       YooAsset.YooAssets.CreateAssetsPackage(packName);
            return pack.CheckLocationValid(key);
        }
        public T LoadAsset<T>(string key,bool isHall = true) where T: Object
        {
            if (!_objRes.TryGetValue(key, out Object obj))
            {
                if (!CheckResKeyVaild(key, isHall)) return null;
                string packName = isHall ? "HallPackage" : "GamePackage";
                var pack = YooAsset.YooAssets.GetAssetsPackage(packName) ??
                           YooAsset.YooAssets.CreateAssetsPackage(packName);
                var handle = pack.LoadAssetSync<T>(key);
                obj = handle.AssetObject;
                _objRes.Add(key, obj);
            }

            return obj == null ? null : obj as T;
        }

        public void LoadAssetCacheAsync(string abName, string bundleName, string hash = null, object func = null,
            bool crate = true, bool show = true)
        {
            ABPacket item = new ABPacket
            {
                abName = abName,
                bundleName = bundleName,
                crate = crate,
                show = show,
                callFunc = func,
                hash = hash,
                isDone = false,
                isBegin = false,
                tyep = LoadAssetType.LoadABCacheAsync
            };
            this.ABPackets.Enqueue(item);
        }

        /// <summary>
        /// 刷新异步加载队列
        /// </summary>
        void Update()
        {
            ExecuteAB();
        }

        public void ExecuteAB()
        {
            bool flag = this.ABPackets.Count == 0;
            if (!flag)
            {
                ABPacket abpacket = this.ABPackets.Peek();
                bool flag2 = !abpacket.isBegin;
                if (flag2)
                {
                    abpacket.isBegin = true;
                    // Debugger.Log(string.Format("启动{0}:{1}的加载", abpacket.abName, abpacket.bundleName));
                    this.StartLoadPacket(abpacket);
                }

                bool isDone = abpacket.isDone;
                if (isDone)
                {
                    this.ABPackets.Dequeue();
                }
            }
        }

        public void StartLoadPacket(ABPacket pak)
        {
            LoadAssetBundleAsync(pak);
        }

        public void LoadAssetBundleAsync(ABPacket apack)
        {
            AssetBundle aBundle = null;
            Action action1 = delegate
            {
                bool flag2 = aBundle == null;
                if (flag2)
                {
                    this.bundles.TryGetValue(apack.abName, out aBundle);
                }

                AssetBundleRequest assetBundleRequest = aBundle.LoadAssetAsync<GameObject>(apack.bundleName);
                GameObject gameObject2 = assetBundleRequest.asset as GameObject;
                bool crate = apack.crate;
                if (crate)
                {
                    bool show = apack.show;
                    if (show)
                    {
                        gameObject2 = Object.Instantiate<GameObject>(gameObject2);
                    }
                    else
                    {
                        gameObject2 = Object.Instantiate<GameObject>(gameObject2, new Vector3(10000f, 10000f, 10000f),
                            Quaternion.identity);
                    }
                }

                LuaManager.CallFunction(apack.callFunc, new object[]
                {
                    gameObject2
                });
                apack.isDone = true;
            };


            bool flag = this.bundles.ContainsKey(apack.abName);
            if (flag)
            {
                action1();
            }
            else
            {
                string path = apack.abName;
                bool f = !apack.abName.EndsWith(AppConst.ExtName);
                if (f)
                {
                    path += AppConst.ExtName;
                }

                var filePath = Util.DataPath + path;
                StartCoroutine(LoadAsyncCoroutine(filePath, (ab) =>
                {
                    aBundle = ab;
                    action1();
                }));
            }
        }

        public void LoadSceneBundle(string mainABName, Action<AssetBundle> callBack)
        {
            var filePath = PathHelp.AppHotfixResPath + mainABName + "/" + mainABName + ".unity3d";
            StartCoroutine(LoadAsyncCoroutine(filePath, (ab) => { callBack(ab); }));
        }

        public void LoadSceneBundleAsync(string mainABName, LuaFunction callBack)
        {
            var filePath = PathHelp.AppHotfixResPath + mainABName + "/" + mainABName + ".unity3d";
            StartCoroutine(LoadAsyncCoroutine(filePath, (ab) => { callBack?.Call(ab); }));
        }

        static IEnumerator LoadAsyncCoroutine(string path, Action<AssetBundle> callback)
        {
            yield return null;
            AssetBundleCreateRequest abcr = MD5Helper.SamplyDESDNAsync(path, MD5Helper.FileKey);
            // AssetBundleCreateRequest abcr = AssetBundle.LoadFromFileAsync(path);
            yield return abcr;
            callback(abcr.assetBundle);

        }

        public AssetBundle LoadSceneBundle(string mainABName)
        {
            var filePath = PathHelp.AppHotfixResPath + mainABName + "/" + mainABName + ".unity3d";
            AssetBundle assetBundle = MD5Helper.SamplyDESDN(filePath, MD5Helper.FileKey);
            return assetBundle;
            // return AssetBundle.LoadFromFile(filePath);
        }

        /// <summary>
        /// 同步加载AB包
        /// </summary>
        public AssetBundle LoadAssetBundles(string abname)
        {
            bool flag = !abname.EndsWith(AppConst.ExtName);
            if (flag)
            {
                abname += AppConst.ExtName;
            }

            AssetBundle assetBundle = null;
            bundles.TryGetValue(abname, out assetBundle);
            bool flag2 = assetBundle != null;
            AssetBundle result;
            if (flag2)
            {
                result = assetBundle;
            }
            else
            {
                string text = PathHelp.AppHotfixResPath + abname;
                assetBundle = MD5Helper.SamplyDESDN(text, MD5Helper.FileKey);

                // assetBundle = AssetBundle.LoadFromFile(text);
                this.bundles.Add(abname, assetBundle);
                result = assetBundle;
            }

            return result;
        }

        public void Unload(string abname)
        {
            bool flag = abname.IsNullOrEmpty();
            if (!flag)
            {
                bool flag2 = !this.bundles.ContainsKey(abname);
                if (flag2)
                {
                    abname += AppConst.ExtName;
                }

                bool flag3 = this.bundles.ContainsKey(abname);
                if (flag3)
                {
                    this.bundles[abname].Unload(true);
                    this.bundles.Remove(abname);
                    DebugTool.Log("Unload：" + abname);
                }
            }
        }

        /// <summary>
        /// 回收ABList
        /// </summary>
        private static void ReleaseAssetBundle(List<AssetBundle> abList)
        {
            if (abList == null) return;

            for (int i = 0; i < abList.Count; i++)
            {
                AbMrg.ReleaseAssetBundle(abList[i]);
            }

            abList.Clear();
        }

        /// <summary>
        /// AB中载入组件方法
        /// </summary>
        private static T LoadComponent<T>(Object obj) where T : Object
        {
            T pb = obj as T;
            if (pb != null) return pb;

            var go = obj as GameObject;
            if (go == null) return null;

            pb = go.GetComponent<T>();
            return pb;
        }

        /// <summary>
        /// 获取缓存的资源
        /// </summary>
        private T GetAsset<T>(string assetName) where T : Object
        {
            Object obj = null;
            objsMap.TryGetValue(assetName, out obj);
            T pb = obj as T;
            return pb;
        }

        // //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        /// <summary>
        /// 同步加载asset方法
        /// </summary>
        public T LoadAsset<T>(string mainABName, string assetName) where T : Object
        {
            T pb = null;
            var ab = LoadAssetBundles(mainABName);
            if (ab == null) return null; //载入失败直接返回

            pb = ab.LoadAsset<T>(assetName);

            if (pb == null)
            {
                DebugTool.LogError(string.Format("加载资源失败!名称:[{0}]", assetName));
            }
            return pb;
        }

        /// <summary>
        /// 异步加载asset方法
        /// </summary>
        public void LoadAssetAsync<T>(string assetName, Action<Object> callBack) where T : Object
        {
            T pb = GetAsset<T>(assetName);
            if (pb != null)
            {
                callBack(pb);
                return;
            }

            if (reqMap.ContainsKey(assetName))
            {
                var req = reqMap[assetName];
                req.CallBack = callBack;
            }
            else
            {
                var perfabPath = ""; //ResPathConfig.GetPath(assetName);
                var mainABName = ""; //ResPathConfig.GetABName(assetName);
                var req = assetReqPool.Get();
                req.Init(assetName, mainABName, perfabPath, callBack);
                reqMap.Add(assetName, req);
                reqLoadQueue.Enqueue(req);
            }
        }

        /// <summary>
        /// 删除一个asset缓存,并不会释放内存需要手动调用 Resources.UnloadUnusedAssets();
        /// </summary>
        public void RemoveAsset(string assetName)
        {
            if (!objsMap.ContainsKey(assetName)) return;
            objsMap.Remove(assetName);
        }

        /// <summary>
        /// 清空管理器缓存的AssetObject
        /// </summary> 
        public void ClearAsset()
        {
            objsMap.Clear();
            Resources.UnloadUnusedAssets();
        }
    }
}