using System.Collections.Generic;
using System.Threading.Tasks;
using Hotfix.Hall;
using LuaFramework;
using RenderHeads.Media.AVProVideo;
using UnityEngine;

namespace Hotfix
{
    /// <summary>
    ///     ui类型
    /// </summary>
    public enum UIType
    {
        /// <summary>
        ///     底层
        /// </summary>
        Bottom,

        /// <summary>
        ///     中间层
        /// </summary>
        Middle,

        /// <summary>
        ///     顶层
        /// </summary>
        Top,

        /// <summary>
        /// 提示
        /// </summary>
        TipWindow,

        /// <summary>
        /// 提示
        /// </summary>
        SmallTipWindow,
        Fix,
    }

    public class UIManager : SingletonILEntity<UIManager>
    {
        private Transform BottomPanel;
        private Transform CentralPanel;
        private Transform Pools;
        private Transform TopPanel;
        private Transform TipPanel;
        private Transform FixPanel;
        private readonly List<PanelBase> uiList = new List<PanelBase>();
        private readonly Dictionary<string, PanelBase> uiMap = new Dictionary<string, PanelBase>();
        public Camera UICamera { get; private set; }

        protected override void Awake()
        {
            base.Awake();
            Util.GC();
            Application.targetFrameRate = 60;
            Screen.orientation = ScreenOrientation.Landscape;
            Screen.autorotateToLandscapeLeft = true;
            Screen.autorotateToLandscapeRight = true;
            Screen.autorotateToPortrait = false;
            Screen.autorotateToPortraitUpsideDown = false;
            uiList.Clear();
            uiMap.Clear();
            Pools = transform.FindChildDepth("Pools");
            Pools.localPosition = Vector3.one * 10000;
            Pools.gameObject.SetActive(false);
            BottomPanel = transform.FindChildDepth("BottomPanel");
            CentralPanel = transform.FindChildDepth("CentralPanel");
            TopPanel = transform.FindChildDepth("TopPanel");
            TipPanel = transform.FindChildDepth("TipPanel");
            FixPanel = transform.FindChildDepth("FixPanel");
            UICamera = transform.FindChildDepth<Camera>($"Camera");
        }

        protected override void Start()
        {
            base.Start();
            ILMusicManager.Instance.PlayBackgroundMusic();
            // OpenUI<TouchPanel>();
            GameObject hall = ToolHelper.LoadAsset<GameObject>(SceneType.Hall, nameof(HallScenPanel));
            hall = Object.Instantiate(hall, Pools, false);
            hall.name = nameof(HallScenPanel);
            OpenUI<LogonScenPanel>();
        }

        protected override void Update()
        {
            base.Update();
            if (Input.GetKeyDown(KeyCode.Escape))
            {
                ToolHelper.PopBigWindow(new BigMessage
                {
                    content = "Whether to quit the game?",
                    okCall = () => { Application.Quit(); }
                });
            }
        }

        /// <summary>
        /// 更换ui
        /// </summary>
        /// <param name="args">参数</param>
        /// <typeparam name="T">ui</typeparam>
        /// <returns></returns>
        public T ReplaceUI<T>(params object[] args) where T : PanelBase, new()
        {
            Close();
            return OpenUI<T>(args);
        }

        /// <summary>
        /// 打开ui
        /// </summary>
        /// <param name="args">参数</param>
        /// <typeparam name="T">ui</typeparam>
        /// <returns></returns>
        public T OpenUI<T>(params object[] args) where T : PanelBase, new()
        {
            var uiName = typeof(T).Name;
            var go = FindPoolsExist(uiName);
            var t = CreateUI<T>(go);
            if (t == null) return null;
            //监听页面被销毁，清除他在iViewList中的保存
            t.OnDestroyFinishHandle = baseView =>
            {
                uiList.Remove(baseView);
                uiMap.Remove(uiName);
            };
            if (t.uitype != UIType.Fix && t.uitype != UIType.SmallTipWindow) uiList.Add(t);
            if (uiMap.ContainsKey(uiName)) uiMap.Remove(uiName);
            uiMap.Add(uiName, t);
            t.Create(args);
            return t;
        }

        /// <summary>
        /// 创建UI
        /// </summary>
        /// <param name="trans">ui主体</param>
        /// <param name="args">参数</param>
        /// <typeparam name="T">ui类</typeparam>
        /// <returns></returns>
        private T CreateUI<T>(Transform trans) where T : PanelBase, new()
        {
            var uiName = typeof(T).Name;
            if (trans == null)
            {
                GameObject go = ToolHelper.LoadAsset<GameObject>(SceneType.Hall, uiName);
                if (go == null) return null;
                trans = Object.Instantiate(go).transform;
                go.SetActive(true);
            }

            trans.gameObject.name = uiName;
            var parent = BottomPanel;
            var t = trans.GetILComponent<T>() ?? trans.AddILComponent<T>();
            switch (t.uitype)
            {
                case UIType.Bottom:
                    parent = BottomPanel;
                    break;
                case UIType.Middle:
                    parent = CentralPanel;
                    break;
                case UIType.Top:
                    parent = TopPanel;
                    break;
                case UIType.TipWindow:
                case UIType.SmallTipWindow:
                    parent = TipPanel;
                    break;
                case UIType.Fix:
                    parent = FixPanel;
                    break;
            }

            trans.SetParent(parent);
            trans.localPosition = Vector3.one;
            trans.localRotation = Quaternion.identity;
            trans.localScale = Vector3.one;
            trans.GetComponent<RectTransform>().anchorMax = Vector2.one;
            trans.GetComponent<RectTransform>().anchorMin = Vector2.zero;
            trans.GetComponent<RectTransform>().offsetMax = Vector2.zero;
            trans.GetComponent<RectTransform>().offsetMin = Vector2.zero;
            return t;
        }

        /// <summary>
        /// 获取ui
        /// </summary>
        /// <typeparam name="T">ui类</typeparam>
        /// <returns></returns>
        public T GetUI<T>() where T : PanelBase
        {
            var uiName = typeof(T).Name;
            if (string.IsNullOrWhiteSpace(uiName))
            {
                DebugHelper.Log("UI名字不能为空");
                return null;
            }

            if (uiMap.ContainsKey(uiName)) return uiMap[uiName] as T;
            return null;
        }

        /// <summary>
        /// 关闭指定ui
        /// </summary>
        /// <typeparam name="T">ui类</typeparam>
        public void CloseUI<T>() where T : PanelBase
        {
            var uiName = typeof(T).Name;
            if (!uiMap.ContainsKey(uiName)) return;
            var ui = uiMap[uiName];
            CloseUI(ui);
        }

        public void CloseUI<T>(T ui) where T : PanelBase
        {
            var keys = uiMap.GetDictionaryKeys();
            for (var i = 0; i < keys.Length; i++)
            {
                if (!keys[i].Equals(ui.Behaviour.BehaviourName)) continue;
                if (uiMap[keys[i]] != ui) continue;
                uiMap.Remove(ui.Behaviour.BehaviourName);
                break;
            }

            for (var i = 0; i < uiList.Count; i++)
            {
                if (!uiList[i].Behaviour.BehaviourName.Equals(ui.Behaviour.BehaviourName)) continue;
                Destroy(ui);
                ui.transform.SetParent(Pools);
                ui.OnDestroyFinishHandle = null;
                uiList.RemoveAt(i);
                break;
            }
        }

        /// <summary>
        /// 关闭顶层UI
        /// </summary>
        public void Close()
        {
            if (uiList.Count <= 1) return;
            var panel = uiList[uiList.Count - 1];
            uiList.RemoveAt(uiList.Count - 1);
            if (panel == null)
                return;

            panel.transform.SetParent(Pools);
            panel.transform.localScale = Vector3.zero;
            Destroy(panel);
        }

        /// <summary>
        /// 关闭所有ui
        /// </summary>
        public void CloseAllUI()
        {
            for (var i = 0; i < uiList.Count; i++)
            {
                if (uiList[i] == null) continue;
                DebugHelper.Log($"关闭{uiList[i].Behaviour.BehaviourName}");
                uiList[i]?.transform.SetParent(Pools);
                Destroy(uiList[i]);
            }

            uiList.Clear();
            uiMap.Clear();
        }

        private Transform FindPoolsExist(string name)
        {
            return Pools.Find(name);
        }
    }
}