﻿using UnityEngine;
using System;
using System.IO;
using System.Text;
using System.Collections.Generic;
using System.Security.Cryptography;
using LuaInterface;
using System.Linq;
using DG.Tweening;
using Object = UnityEngine.Object;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using QPDefine;

 namespace LuaFramework
{
    public class Util
    {
        public static float TickCount
        {
            get { return UnityEngine.Time.realtimeSinceStartup; }
        }

        #region 核心路径初始化

        /// <summary>
        /// 设备外部数据存放目录
        /// </summary>
        public static string DataPath
        {
            get { return _dataPath; }
        }

        private static string _dataPath = null;

        public static string StreamPath
        {
            get { return _streamPath; }
        }

        private static string _streamPath = null;

        [NoToLua]
        public static void InitPath()
        {
#if UNITY_IPHONE && !UNITY_EDITOR
	        _streamPath = Application.dataPath + "/Raw/";                       //IOS
#elif UNITY_ANDROID && !UNITY_EDITOR
            _streamPath = "jar:file://" + Application.dataPath + "!/assets/";   //Android   
#elif UNITY_STANDALONE || UNITY_STANDALONE64 || UNITY_EDITOR
            _streamPath = Application.streamingAssetsPath + "/"; //PC端
#endif

#if (UNITY_IPHONE || UNITY_ANDROID) && !UNITY_EDITOR
            _dataPath = Application.persistentDataPath + "/";         //移动端
#elif (UNITY_STANDALONE || UNITY_STANDALONE64) && !UNITY_EDITOR
            _dataPath = Application.streamingAssetsPath.Replace("StreamingAssets","AssetFiles/");        //PC端 
#elif UNITY_EDITOR
            if (LoadState.AssetLoadState)
            {
                _dataPath = Application.dataPath.Replace("/Assets", "/AssetsFileDir/");
            }
            else
            {
                _dataPath = Application.streamingAssetsPath + "/";
            }
#endif
        }

        #endregion

        #region 其他辅助函数

        public static void Quit()
        {
#if UNITY_EDITOR
            UnityEditor.EditorApplication.isPlaying = false;
#else
            Defence.Defence.Exit();
            Application.Quit();
#endif
        }

        public static int Int(object o)
        {
            return Convert.ToInt32(o);
        }

        public static float Float(object o)
        {
            return (float) Math.Round(Convert.ToSingle(o), 2);
        }

        public static long Long(object o)
        {
            return Convert.ToInt64(o);
        }

        public static int Random(int min, int max)
        {
            return UnityEngine.Random.Range(min, max);
        }

        public static float Random(float min, float max)
        {
            return UnityEngine.Random.Range(min, max);
        }

        public static string Uid(string uid)
        {
            int position = uid.LastIndexOf('_');
            return uid.Remove(0, position + 1);
        }

        public static long GetTime()
        {
            TimeSpan ts = new TimeSpan(DateTime.UtcNow.Ticks - new DateTime(1970, 1, 1, 0, 0, 0).Ticks);
            return (long) ts.TotalMilliseconds;
        }

        public static int GetDiffDay(long unixUtcTime)
        {
            DateTime dateTime = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Local);
            dateTime = dateTime.AddSeconds(Convert.ToDouble(unixUtcTime));
            TimeSpan span = DateTime.Now - dateTime;
            return span.Days;
        }

        #endregion

        #region 加密解密

        //加密
        public static string Encryption(string express)
        {
            CspParameters param = new CspParameters();
            param.KeyContainerName = "xhr_chi_shi"; //密匙容器的名称，保持加密解密一致才能解密成功
            using (RSACryptoServiceProvider rsa = new RSACryptoServiceProvider(param))
            {
                byte[] plaindata = Encoding.Default.GetBytes(express); //将要加密的字符串转换为字节数组
                byte[] encryptdata = rsa.Encrypt(plaindata, false); //将加密后的字节数据转换为新的加密字节数组
                return Convert.ToBase64String(encryptdata); //将加密后的字节数组转换为字符串
            }
        }

        //解密
        public static string Decrypt(string ciphertext)
        {
            CspParameters param = new CspParameters();
            param.KeyContainerName = "xhr_chi_shi";
            using (RSACryptoServiceProvider rsa = new RSACryptoServiceProvider(param))
            {
                byte[] encryptdata = Convert.FromBase64String(ciphertext);
                byte[] decryptdata = rsa.Decrypt(encryptdata, false);
                return Encoding.Default.GetString(decryptdata);
            }
        }

        #endregion

        #region 加载与释放资源

        //public static Dictionary<string, AssetBundle> sceneAB = new Dictionary<string, AssetBundle>();
        //public static void LoadSceneAssetBundle(string sceneABName,int version, LuaFunction lunfunc)
        //{
        //    if (sceneAB.ContainsKey(sceneABName)) { lunfunc.Call(); }
        //    else
        //    {
        //        var resMrg = AppFacade.Instance.GetManager<ResourceManager>();
        //        //resMrg.LoadSceneBundle(sceneABName);
        //        //lunfunc.Call();
        //        resMrg.LoadSceneBundle(sceneABName, version,(ab) =>
        //         {
        //             if (ab != null)
        //             {
        //                 sceneAB.Add(sceneABName, ab);
        //                 lunfunc.Call();
        //             }
        //             else
        //             {
        //                 DebugTool.LogError("加载场景AB失败");
        //             }

        //         });

        //    }
        //}

        //public static void UnLoadSceneAssetBundle(string sceneABName)
        //{
        //    if (sceneABName == null || sceneABName.Trim(' ') == string.Empty)
        //    {
        //        DebugTool.LogError("场景ab名出错");
        //        return;
        //    }
        //    if (sceneAB.ContainsKey(sceneABName))
        //    {
        //        sceneAB[sceneABName].Unload(true);
        //    }
        //}

        //同步加载AssetBundle
        public static Object LoadAssetObj(string abName, string assetName)
        {
            var resMrg = AppFacade.Instance.GetManager<ResourceManager>();
            var asset = resMrg.LoadAsset<Object>(abName, assetName);
            return asset;
        }

        public static GameObject LoadAsset(string abName, string assetName)
        {
            // var resMrg = AppFacade.Instance.GetManager<ResourceManager>();
            // var asset = resMrg.LoadAsset<GameObject>(abName, assetName);
            // return asset;
            var pack = GetAssetsPackage(abName);
            if (!pack.CheckLocationValid(assetName)) return null;
            var asset = pack.LoadAssetSync<GameObject>(assetName);
            return asset.GetAssetObject<GameObject>();
        }

        public static void ReleasePackage(string packageName)
        {
            var pack = GetAssetsPackage(packageName);
            pack.UnloadUnusedAssets();
        }


        public static void Unload(string abname)
        {
            var resMrg = AppFacade.Instance.GetManager<ResourceManager>();
            resMrg.Unload(abname);
        }

        public static void GC()
        {
            Resources.UnloadUnusedAssets();
            System.GC.Collect();
        }

        //public static GameObject LoadAsset(string assetName)
        //{
        //    if (assetName == null || assetName.Trim(' ') == string.Empty)
        //    {
        //        return null;
        //    }
        //    var resMrg = AppFacade.Instance.GetManager<ResourceManager>();
        //    var asset = resMrg.LoadAsset<GameObject>(assetName);
        //    return asset;
        //}

        //public static Sprite LoadSprite(string assetName)
        //{
        //    if (assetName == null || assetName.Trim(' ') == string.Empty)
        //    {
        //        return null;
        //    }
        //    var resMrg = AppFacade.Instance.GetManager<ResourceManager>();
        //    var sprite = resMrg.LoadAsset<Sprite>(assetName + ".png");
        //    return sprite;
        //}

        public static void LoadAssetAsync(string assetName, LuaFunction luafunc)
        {
            if (assetName == null || assetName.Trim(' ') == string.Empty)
            {
                luafunc.Call();
                return;
            }

            var resMrg = AppFacade.Instance.GetManager<ResourceManager>();
            Action<Object> func = (asset) =>
            {
                if (asset is GameObject)
                {
                    var obj = asset as GameObject;
                    luafunc.Call(obj);
                }
                else
                {
                    luafunc.Call();
                }
            };
            DebugTool.LogError($"加载异步物体{assetName}");
            resMrg.LoadAssetAsync<GameObject>(assetName, func);
        }

        public static void LoadSpriteAsync(string assetName, LuaFunction luafunc)
        {
            if (assetName == null || assetName.Trim(' ') == string.Empty)
            {
                luafunc.Call();
                return;
            }

            var resMrg = AppFacade.Instance.GetManager<ResourceManager>();
            Action<Object> func = (asset) => { luafunc.Call(asset as Sprite); };
            resMrg.LoadAssetAsync<Sprite>(assetName + ".png", func);
        }

        public static void SetAsyncImage(string url, UnityEngine.UI.Image image)
        {
            var dicMrg = AppFacade.Instance.GetManager<DownloadPicManager>();
            dicMrg.SetAsyncImage(url, image);
        }


        //public static void ClearMemory()
        //{
        //    GC.Collect();
        //    var resMrg = AppFacade.Instance.GetManager<ResourceManager>();
        //    if (resMrg != null) resMrg.ClearAsset();
        //    LuaManager mgr = AppFacade.Instance.GetManager<LuaManager>();
        //    if (mgr != null) mgr.LuaGC();
        //}

        #endregion

        #region UI层级辅助处理工具

        // private static List<MatQueue> matQueueList = new List<MatQueue>();

        [NoToLua]
        public static void GetAllComs<T>(GameObject obj, List<T> comsList)
        {
            var coms = obj.GetComponents<T>();
            comsList.AddRange(coms);
            for (int i = 0; i < obj.transform.childCount; i++)
            {
                var child = obj.transform.GetChild(i).gameObject;
                GetAllComs(child, comsList);
            }
        }

        //public static void SetRenderQueue(GameObject obj, int queue)
        //{
        //    var _matQueue = obj.GetComponent<MatQueue>();
        //    if (_matQueue == null)
        //    {
        //        _matQueue = obj.AddComponent<MatQueue>();
        //        _matQueue.SetRenderQueue(queue);
        //    }
        //    else
        //    {
        //        GetAllComs(obj, matQueueList);
        //        for (int i = 0; i < matQueueList.Count; i++)
        //        {
        //            var matQueue = matQueueList[i];
        //            matQueue.SetRenderQueue(queue);
        //        }
        //        matQueueList.Clear();
        //    }

        //}
        //public static void SetRenderQueue(Transform obj, int queue)
        //{
        //    SetRenderQueue(obj.gameObject, queue);
        //}

        #endregion

        #region 控件获取与添加

        /// <summary>
        /// 搜索子物体组件-GameObject版
        /// </summary>
        public static Component GetComponent(GameObject go, string subnode, string typeName)
        {
            if (go != null)
            {
                Transform sub = go.transform.Find(subnode);
                if (sub != null)
                {
                    return sub.GetComponent(typeName);
                }
            }

            return null;
        }

        /// <summary>
        /// 搜索子物体组件-Transform版
        /// </summary>
        public static Component GetComponent(Transform go, string subnode, string typeName)
        {
            if (go != null)
            {
                Transform sub = go.Find(subnode);
                if (sub != null) return sub.GetComponent(typeName);
            }

            return null;
        }

        /// <summary>
        /// 添加组件
        /// </summary>
        //public static Component AddComponent(GameObject go, string typeName)
        //{
        //    if (go != null)
        //    {

        //        var type = Type.GetType(typeName);
        //        if (type == null) return null;
        //        Component ts = go.GetComponent(type);
        //        GameObject.Destroy(ts);
        //        return go.AddComponent(type);
        //    }
        //    return null;
        //}
        public static Component AddComponent(string type, GameObject obj)
        {
            Component result = null;

            if (type == "LuaBehaviour")
            {
                result = obj.AddComponent<LuaBehaviour>();
            }
            else if (type == "Image")
            {
                result = obj.AddComponent<Image>();
            }
            else if (type == "ImageAnima")
            {
                result = obj.AddComponent<ImageAnima>();
            }
            else if (type == "SpriteAnima")
            {
                result = obj.AddComponent<SpriteAnima>();
            }
            else if (type == "CsJoinLua")
            {
                result = obj.AddComponent<CsJoinLua>();
            }
            else if (type == "BaseBehaviour")
            {
                result = obj.AddComponent<BaseBehaviour>();
            }
            else if (type == "AudioListener")
            {
                result = obj.AddComponent<AudioListener>();
            }
            else if (type == "IMGResolution")
            {
                result = obj.AddComponent<IMGResolution>();
            }
            else if (type == "UguiGradient")
            {
                result = obj.AddComponent<UguiGradient>();
            }
            else if (type == "EventTriggerListener")
            {
                result = obj.AddComponent<EventTriggerListener>();
            }
            else if (type == "Canvas")
            {
                result = obj.AddComponent<Canvas>();
                obj.GetComponent<Canvas>().overrideSorting = true;
            }
            else if (type == "AlignView")
            {
                result = obj.AddComponent<AlignView>();
            }
            else if (type == "AlignViewEx")
            {
                result = obj.AddComponent<AlignViewEx>();
            }

            return result;
        }

        ///// <summary>
        ///// 添加组件
        ///// </summary>
        //public static Component AddComponent(Transform go, string typeName)
        //{
        //    return AddComponent(go.gameObject, typeName);
        //}

        /// <summary>
        /// 查找子对象
        /// </summary>
        public static GameObject GetChild(GameObject go, string subnode)
        {
            return GetChild(go.transform, subnode);
        }

        /// <summary>
        /// 查找子对象
        /// </summary>
        public static GameObject GetChild(Transform go, string subnode)
        {
            Transform tran = go.Find(subnode);
            if (tran == null) return null;
            return tran.gameObject;
        }

        /// <summary>
        /// 取平级对象
        /// </summary>
        public static GameObject GetPeer(GameObject go, string subnode)
        {
            return GetPeer(go.transform, subnode);
        }

        /// <summary>
        /// 取平级对象
        /// </summary>
        public static GameObject GetPeer(Transform go, string subnode)
        {
            Transform tran = go.parent.Find(subnode);
            if (tran == null) return null;
            return tran.gameObject;
        }

        #endregion

        #region 打印

        public static void Log(string str)
        {
            DebugTool.Log(str);
        }

        public static void LogWarning(string str)
        {
            DebugTool.LogWarning(str);
        }

        public static void LogError(string str)
        {
            DebugTool.LogError(str);
        }

        #endregion

        #region 保存与载入

        //public static void SaveStr(string key, string data)
        //{
        //    SaveManager.SaveData(key, data);
        //}

        //public static string LoadStr(string key)
        //{
        //    string data = null;
        //    SaveManager.GetData(key, out data, null);
        //    return data;
        //}

        public static int GetStrLength(string str)
        {
            return str.Length;
        }

        #endregion

        #region 二进制计算

        //与运算
        public static int Band(int a, int b)
        {
            return a & b;
        }

        //或运算
        public static int Bor(int a, int b)
        {
            return a | b;
        }

        //取反 非运算
        public static int Neg(int a)
        {
            return ~a;
        }

        //异或运算
        public static int Xor(int a, int b)
        {
            return a ^ b;
        }

        //左移
        public static int Shl(int a, int b)
        {
            return a << b;
        }

        //右移
        public static int Shr(int a, int b)
        {
            return a >> b;
        }

        #endregion


        //C(n,m) n個取m個
        public static List<int[]> GetCombine(int n, int m)
        {
            int[] arr = new int[n];
            for (int i = 0; i < n; i++)
            {
                arr[i] = i + 1;
            }

            List<int[]> list = new List<int[]>();
            foreach (int s in arr)
            {
                List<int[]> lst = list.Where(p => p.Length < m).ToList();
                int[] nArr = {s};
                list.Add(nArr);
                foreach (int[] ss in lst)
                {
                    list.Add(ss.Concat(nArr).ToArray());
                }
            }

            List<int[]> outList = list.OrderByDescending(p => p.Length).ToList();
            return outList;
        }

        public static bool isApplePlatform
        {
            get { return (int) Application.platform == 8; }
        }

        public static bool isOSXEditor
        {
            get { return Application.platform == 0; }
        }

        public static bool isOSXPlayer
        {
            get { return (int) Application.platform == 1; }
        }

        public static bool isWindowsEditor
        {
            get { return (int) Application.platform == 7; }
        }

        public static bool isWindowsPlayer
        {
            get { return (int) Application.platform == 2; }
        }

        public static bool isAndroidPlatform
        {
            get { return (int) Application.platform == 11; }
        }

        public static bool isEditor
        {
            get { return Application.isEditor; }
        }

        public static bool isPc
        {
            get { return (int) Application.platform == 2; }
        }

        // Token: 0x06002801 RID: 10241 RVA: 0x001071A8 File Offset: 0x001053A8
        public static string GetFileText(string path)
        {
            return File.ReadAllText(path);
        }

        // Token: 0x1700012B RID: 299
        // (get) Token: 0x06002802 RID: 10242 RVA: 0x001071C0 File Offset: 0x001053C0
        public static bool NetAvailable
        {
            get { return Application.internetReachability > 0; }
        }

        // Token: 0x1700012C RID: 300
        // (get) Token: 0x06002803 RID: 10243 RVA: 0x001071DC File Offset: 0x001053DC
        public static bool IsWifi
        {
            get { return (int) Application.internetReachability == 2; }
        }

        public static void CreatDireCtory(string dataPath)
        {
            bool flag = Directory.Exists(dataPath);
            if (!flag)
            {
                Directory.CreateDirectory(dataPath);
            }
        }

        // Token: 0x06002804 RID: 10244 RVA: 0x001071F8 File Offset: 0x001053F8
        public static bool Exists(string path)
        {
            return File.Exists(path);
        }

        // Token: 0x06002805 RID: 10245 RVA: 0x00107210 File Offset: 0x00105410
        public static bool DeletePath(string path)
        {
            bool flag = File.Exists(path);
            bool result;
            if (flag)
            {
                File.Delete(path);
                result = true;
            }
            else
            {
                result = false;
            }

            return result;
        }

        // Token: 0x06002806 RID: 10246 RVA: 0x0010723C File Offset: 0x0010543C
        public static bool SaveFile(object o, string path)
        {
            bool result = true;
            bool flag = o as Sprite != null;
            if (flag)
            {
                File.WriteAllBytes(path, ImageConversion.EncodeToPNG((o as Sprite).texture));
            }
            else
            {
                bool flag2 = o as Texture != null;
                if (flag2)
                {
                    File.WriteAllBytes(path, ImageConversion.EncodeToPNG((o as Sprite).texture));
                }
                else
                {
                    result = false;
                }
            }

            return result;
        }

        // Token: 0x06002807 RID: 10247 RVA: 0x001072AC File Offset: 0x001054AC
        public static void CreaterPath(string path)
        {
            bool flag = !File.Exists(path);
            if (flag)
            {
                File.Create(path);
            }
        }

        // Token: 0x060027F1 RID: 10225 RVA: 0x00106E70 File Offset: 0x00105070
        public static string EncryptDES(string encryptString, string encryptKey)
        {
            return MD5Helper.EncryptDES(encryptString, encryptKey);
        }

        // Token: 0x060027F2 RID: 10226 RVA: 0x00106E8C File Offset: 0x0010508C
        public static string DecryptDES(string decryptString, string decryptKey)
        {
            return MD5Helper.DecryptDES(decryptString, decryptKey);
        }

        // Token: 0x06002829 RID: 10281 RVA: 0x00107C88 File Offset: 0x00105E88
        public static bool IsPointerOverGameObject()
        {
            PointerEventData pointerEventData = new PointerEventData(EventSystem.current);
            pointerEventData.pressPosition = Input.mousePosition;
            pointerEventData.position = Input.mousePosition;
            List<RaycastResult> list = new List<RaycastResult>();
            EventSystem.current.RaycastAll(pointerEventData, list);
            return list.Count > 0;
        }

        // Token: 0x0600282A RID: 10282 RVA: 0x00107CE4 File Offset: 0x00105EE4
        public static bool IsPointerOverGameObject1(Vector2 screenPosition)
        {
            PointerEventData pointerEventData = new PointerEventData(EventSystem.current);
            pointerEventData.position = new Vector2(screenPosition.x, screenPosition.y);
            List<RaycastResult> list = new List<RaycastResult>();
            EventSystem.current.RaycastAll(pointerEventData, list);
            return list.Count > 0;
        }

        // Token: 0x0600282B RID: 10283 RVA: 0x00107D38 File Offset: 0x00105F38
        public static bool IsPointerOverGameObject2(Canvas canvas, Vector2 screenPosition)
        {
            PointerEventData pointerEventData = new PointerEventData(EventSystem.current);
            pointerEventData.position = screenPosition;
            GraphicRaycaster component = canvas.gameObject.GetComponent<GraphicRaycaster>();
            List<RaycastResult> list = new List<RaycastResult>();
            component.Raycast(pointerEventData, list);
            return list.Count > 0;
        }

        // Token: 0x06002820 RID: 10272 RVA: 0x00107B98 File Offset: 0x00105D98
        public static int getRandom(int a, int b)
        {
            System.Random random = new System.Random(Guid.NewGuid().GetHashCode());
            return random.Next(a, b);
        }

        public static Vector3 WorlPointToScreenSpace(Vector3 wpos, Camera viewCamera)
        {
            return viewCamera.WorldToScreenPoint(wpos);
        }

        public static bool IsDebug { get; set; }
        public static bool IsTest { get; set; }

        public static string PlatformName
        {
            get
            {
#if UNITY_EDITOR
                return IsDebug ? $"{UnityEditor.BuildTarget.StandaloneWindows}" : $"{UnityEditor.EditorUserBuildSettings.activeBuildTarget}";
#endif
                string result = string.Empty;
                int platform = (int) Application.platform;
                if (platform != 2)
                {
                    switch (platform)
                    {
                        case 7:
                            return "StandaloneWindows";
                        case 8:
                            return "iOS";
                        case 11:
                            return "Android";
                    }

                    result = "StandaloneWindows";
                }
                else
                {
                    result = "StandaloneWindows";
                }

                return result;
            }
        }


        public static string md5(string source)
        {
            return MD5Helper.MD5String(source);
        }


        public static string md52(string source)
        {
            string source2 = Util.md5(source) + "89219417";
            return Util.md5(source2);
        }


        public static string md5file(string file)
        {
            return MD5Helper.MD5File(file);
        }

        public static string FormatTimeToNumber
        {
            get { return TimeHelper.ToNumber().ToString(); }
        }

        public static string Read(string key)
        {
            return SaveHelper.GetString(key);
        }


        public static bool Write(string key, string val)
        {
            SaveHelper.SaveCommon(key, val);
            return true;
        }

        public static string PakNameVersion
        {
            get
            {
                string text = Application.identifier;
                bool flag = text.IsNullOrEmpty();
                string result;
                if (flag)
                {
                    result = "";
                }
                else
                {
                    string str = text.Split(new char[]
                    {
                        '.'
                    })[2];
                    text = str + Application.version;
                    result = text;
                }

                return result;
            }
        }

        public static string getIosCode()
        {
            string code = GetCodeMax();
            return CalliOS.getIosMackUUIDCode(code);
        }

        //获取s随机码
        public static string GetCodeMax()
        {
//            string[] codeList =
//            {
//                "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",
//                "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F",
//                "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
//            };
//
//            string StringVKey =
//                "QjDeRHdZ0123456789qwertyuiopasdfghjklzxcvbnmASDFGHJKLZXCVBNMQWERTYUIOP0123456789qwertyuiopasdfghjklzxcvbnmASDFGHJKLZXCVBNMQWERTYUIOP0123456789qwertyuiopasdfghjklzxcvbnmASDFGHJKLZXCVBNMQWERTYUIOP0123456789qwertyuiopasdfghjklzxcvbnmASDFGHJKLZXCVBNMQWERTYUIOP";
//
//            string code = "";
//            int codeSum = 0;
//            for (int i = 0; i < 31; i++)
//            {
//                int index = Random(0, 62);
//                code += codeList[index];
//                codeSum += System.Text.Encoding.ASCII.GetBytes(code.Substring(i, 1))[0];
//            }
//
//            code += StringVKey.Substring((codeSum & 0xff), 1);
//            return code;

            string code = Application.identifier + "1.0";
            return code;
        }

        public static void ResetGame()
        {
            //AppFacade.Instance.RemoveManager<GameManager>();
            //UnityEngine.Object.Destroy(GameObject.Find("GameManager"));
            GameObject gameObject = new GameObject();
            gameObject.AddComponent<ResetGame>();
        }

        public static string OutPutPokerValue(int rPokerData)
        {
            if (rPokerData == 0) return "0,0";
            int n1 = (rPokerData >> 4) & 0x0F;
            int n2 = rPokerData & 0x0F;
            return n1 + "," + n2;
        }

        public static int SystmeMode()
        {
            if (IntPtr.Size == 8)
            {
                return 64;
            }

            return 32;
        }

        public static string IntToIp(int ipInt)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append((ipInt >> 24) & 0xFF).Append(".");
            sb.Append((ipInt >> 16) & 0xFF).Append(".");
            sb.Append((ipInt >> 8) & 0xFF).Append(".");
            sb.Append(ipInt & 0xFF);
            return sb.ToString();
        }
//将192.168.1.1转成0xc0a80101

        public static int IpToInt(string ip)
        {
            char[] separator = new char[] {'.'};
            string[] items = ip.Split(separator);
            return int.Parse(items[0]) << 24
                   | int.Parse(items[1]) << 16
                   | int.Parse(items[2]) << 8
                   | int.Parse(items[3]);
        }

        public static void CopyStr(string str)
        {
            UniClipboard.SetText(str);
        }

        public static void InitGF(string key)
        {
            
        }

        /// <summary>
        /// 高防是否初始化
        /// </summary>
        /// <returns></returns>
        public static bool IsGFInit()
        {
            return Defence.Defence.IsInit;
        }

        /// <summary>
        /// 获取新的高防IP和端口
        /// </summary>
        /// <param name="groupId">防御组Id</param>
        /// <param name="denfencetag">防御标识</param>
        /// <param name="orginport">源端口</param>
        /// <returns></returns>
        public static string GetIPAndPort(string host, int port)
        {
            return "";
        }

        public static Tweener RunWinScore(float orginScore, float targetScore, float timer, LuaFunction callback)
        {
            return DOTween.To(value => { callback?.Call(value); }, orginScore, targetScore, timer);
        }

        public static void LoginWithWX(int platformID, LuaFunction callback)
        {
            ShareSDKManager.Instance.Login(platformID, callback);
        }

        public static bool IsAuth(int platformID)
        {
            return ShareSDKManager.Instance.IsAuth(platformID);
        }
        
        public static string[] StringToChars(string str)
        {
            List<string> list = new List<string>();
            char[] chars = str.ToCharArray();
            for (int i = 0; i < chars.Length; i++)
            {
                list.Add(chars[i].ToString());
            }

            return list.ToArray();
        }
        
        public static bool IsEmulator()
        {
            return Defence.Defence.IsEmulator();
        }

        public static YooAsset.AssetsPackage GetAssetsPackage(string package)
        {
            var pack = YooAsset.YooAssets.GetAssetsPackage(package);
            pack ??= YooAsset.YooAssets.CreateAssetsPackage(package);
            return pack;
        }
    }
}