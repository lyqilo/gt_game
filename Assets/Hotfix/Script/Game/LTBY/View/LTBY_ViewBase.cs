using System.Collections.Generic;
using DG.Tweening;
using LuaFramework;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace Hotfix.LTBY
{
    /// <summary>
    /// 界面基础类
    /// </summary>
    public abstract class LTBY_ViewBase : IILManager
    {
        protected static GameObject Canvas;
        protected static GameObject CanvasTop;

        protected string viewName;
        public bool isTop;

        protected Dictionary<int, Tween> _actionMap;
        protected int _actionKey;

        protected string prefabName;
        protected string bundleName;
        protected Dictionary<string, int> _timers;
        protected List<int> _cos;

        private int __longClickCount;
        private bool __longClickFlag;
        public Transform transform;

        public CAction<LTBY_ViewBase> OnDestroyFinishHandle;
        public LTBY_ViewBase()
        {

        }
        public LTBY_ViewBase(string viewName,bool isTop=false)
        {
            this.viewName = viewName;
            this.isTop = isTop;
            prefabName = this.viewName;

            _timers = new Dictionary<string, int>();
            _cos = new List<int>();
            _actionMap = new Dictionary<int, Tween>();
            _actionKey = 0;
        }
        public virtual void Create(params object[] args)
        {
            string _bundleName = $"module62/prefab";
            transform = LTBY_ResourceManager.Instance.LoadPrefab(prefabName, isTop ? GetCanvasTop() : GetCanvas(), prefabName);
            OnCreate(args);

            AdaptScreen();
        }

        protected virtual void OnCreate(params object[] args)
        {
            RectTransform rect = transform.GetComponent<RectTransform>();
            if (rect != null)
            {
                rect.anchorMax = Vector2.one;
                rect.anchorMin = Vector2.zero;
                rect.offsetMax = Vector2.zero;
                rect.offsetMin = Vector2.zero;
            }
        }

        protected virtual void AdaptScreen()
        {

        }
        public virtual void GTGameChange()
        {

        }

        protected virtual int DelayRun(float second, CAction func)
        {
            int co = LTBY_Extend.Instance.DelayRun(second, func);
            _cos.Add(co);
            return co;
        }

        public virtual void CancelDelayRun(int co)
        {
            if (co <=0) return;
            if (_cos.Contains(co)) _cos.Remove(co);
            LTBY_Extend.Instance.StopTimer(co);
        }

        protected virtual void CancelAllDelayRun()
        {
            for (int i = 0; i < _cos.Count; i++)
            {
                LTBY_Extend.Instance.StopTimer(_cos[i]);
            }
            _cos.Clear();
        }

        public virtual void Destroy()
        {
            CancelAllDelayRun();
            StopAllTimer();
            StopAllAction();
            if (transform != null)
            {
                LTBY_Extend.Destroy(transform.gameObject);
                transform = null;
            }
            OnDestroyFinish();
            OnDestroy();
        }

        protected virtual void OnDestroy() { }

        protected virtual void OnDestroyFinish()
        {
            //待重写，现在用来清除ViewManager的状态
        }

        private T Assert<T>(T obj, string err) where T: Component
        {
            if (obj == null)
            {
                DebugHelper.LogError(err);
            }
            return obj;
        }

        protected virtual T FindChild<T>(string childNodeName) where T : Component
        {
            return Assert(transform.FindChildDepth<T>(childNodeName), $"child not find {childNodeName}");
        }

        protected virtual Transform FindChild(string childNodeName)
        {
            return Assert(transform.FindChildDepth(childNodeName), $"child not find {childNodeName}");
        }

        protected virtual void SetActive(bool bActive)
        {
            if (transform != null)
            {
                transform.gameObject.SetActive(bActive);
            }
        }

        public virtual T AddComponent<T>() where T : Component
        {
            return transform.gameObject.AddComponent<T>();
        }
        public virtual T GetComponent<T>() where T : Component
        {
            return Assert(transform.GetComponent<T>(), $"GetComponent component not find : {typeof(T).Name}");
        }
        public virtual T SubAdd<T>(string childNodeName) where T : Component
        {
            return FindChild(childNodeName).gameObject.AddComponent<T>();
        }

        public virtual T SubGet<T>(string childNodeName) where T : Component
        {
            Transform obj = FindChild(childNodeName);
            return obj != null ? Assert(obj: GetComponent<T>(), $"SubGet component not find : {childNodeName}.{typeof(T).Name}") : null;
        }

        public virtual void SetText(string childNodeName, string text)
        {
            Text obj = FindChild<Text>(childNodeName);

            if (obj != null)
            {
                obj.text = text;
            }
        }

        public virtual string GetText(string childNodeName)
        {
            Text obj = FindChild<Text>(childNodeName);
            return obj != null ? obj.text : "";
        }

        public virtual void SetImage(string childNodeName, Sprite nameOrTexture)
        {
            Image obj = FindChild<Image>(childNodeName);
            if (obj != null)
            {
                obj.sprite = nameOrTexture;
            }
        }

        private static Transform GetCanvas()
        {
            if (Canvas != null) return Canvas.transform;
            Transform trans = LTBYEntry.Instance.transform.FindChildDepth("Canvas");
            Canvas = trans.gameObject;

            return Canvas.transform;
        }

        private static Transform GetCanvasTop()
        {
            if (CanvasTop != null) return CanvasTop.transform;
            Transform trans = LTBYEntry.Instance.transform.FindChildDepth("CanvasTop");
            CanvasTop = trans.gameObject;

            return CanvasTop.transform;
        }
        public virtual void OnDestroyFinish(LTBY_ViewBase baseView = null)
        {
            OnDestroyFinishHandle?.Invoke(baseView == null ? this : baseView);
        }

        protected virtual void AddLongClick(Transform node, LongClickData data)
        {
            CAction<GameObject, PointerEventData> funcClick = data.funcClick;
            CAction<GameObject, PointerEventData> funcLongClick = data.funcLongClick;
            CAction<GameObject, PointerEventData> funcDown = data.funcDown;
            CAction<GameObject, PointerEventData> funcUp = data.funcUp;
            float time = data.time > 0 ? data.time : 1;

            __longClickCount = __longClickCount == 0 ? __longClickCount + 1 : 0;
            int curCount = __longClickCount;

            EventTriggerHelper listener = EventTriggerHelper.Get(node.gameObject);
            listener.onDown = (obj,eventData)=>
            {
                LTBY_Audio.Instance.Play(LTBY_Audio.Button);
                __longClickFlag = false;
                DebugHelper.Log($"按下");
                DebugHelper.Log($"CheckLongClick{ curCount}");
                StartTimer($"CheckLongClick{curCount}", time, () =>
                {
                    if (eventData.pointerCurrentRaycast.gameObject != node.gameObject) return;
                    DebugHelper.Log($"长按");
                    __longClickFlag = true;
                    funcLongClick(obj, eventData);
                },1);
                funcDown?.Invoke(obj, eventData);
            };
            listener.onUp = (obj,eventData)=>
            {
                DebugHelper.Log($"抬起");
                DebugHelper.Log($"CheckLongClick{ curCount}");
                DebugHelper.Log($"停止长按");
                funcUp?.Invoke(obj, eventData);

                StopTimer($"CheckLongClick{curCount}");
            };
            listener.onClick = (obj,eventData)=>
            {
                DebugHelper.Log($"点击");
                DebugHelper.Log($"CheckLongClick{ curCount}");
                StopTimer($"CheckLongClick{curCount}");
                if (!__longClickFlag) funcClick?.Invoke(obj, eventData);
            };
        }

        protected virtual void StartTimer(string name, float interval, CAction func, int times = -1)
        {
            StopTimer(name);
            int key = LTBY_Extend.Instance.StartTimer(func, interval, times);
            _timers.Add(name, key);
        }

        protected virtual void StopTimer(string name)
        {
            if (!_timers.ContainsKey(name)) return;
            int co = _timers[name];
            LTBY_Extend.Instance.StopTimer(co);
            _timers.Remove(name);
        }

        protected virtual void StopAllTimer()
        {
            var values = _timers.GetDictionaryValues();
            for (int i = 0; i < values.Length; i++)
            {
                LTBY_Extend.Instance.StopTimer(values[i]);
            }
            _timers.Clear();
        }

        protected virtual void AddClick(Transform node, CAction<GameObject, PointerEventData> func)
        {
            if (node == null) return;
            Button btn = node.GetComponent<Button>();
            if (btn != null)
            {
                btn.onClick.RemoveAllListeners();
                btn.onClick.Add(() =>
                {
                    LTBY_Audio.Instance.Play(LTBY_Audio.Button);
                    func?.Invoke(btn.gameObject, null);
                });
                return;
            }
            EventTriggerHelper listener = EventTriggerHelper.Get(node.gameObject);
            listener.onClick = delegate (GameObject obj, PointerEventData eventData)
            {
                LTBY_Audio.Instance.Play(LTBY_Audio.Button);
                func?.Invoke(obj, eventData);

            };
        }

        protected virtual void AddClick(Transform node, CAction func)
        {
            if (node == null) return;
            Button btn = node.GetComponent<Button>();
            if (btn != null)
            {
                btn.onClick.RemoveAllListeners();
                btn.onClick.Add(() =>
                {
                    LTBY_Audio.Instance.Play(LTBY_Audio.Button);
                    func?.Invoke();
                });
                return;
            }
            EventTriggerHelper listener = EventTriggerHelper.Get(node.gameObject);
            listener.onClick = (obj,eventData)=>
            {
                LTBY_Audio.Instance.Play(LTBY_Audio.Button);
                func?.Invoke();
            };
        }

        public virtual void OnPause() { }
        public virtual void OnResume() { }

        protected virtual int RunAction(Tween tweener)
        {
            _actionKey++;
            if (_actionMap.ContainsKey(_actionKey))
            {
                _actionMap[_actionKey]?.Complete();
                _actionMap.Remove(_actionKey);
            }
            tweener?.Play();
            _actionMap.Add(_actionKey, tweener);
            return _actionKey;

        }

        protected virtual void StopAction(int _actionKey, bool complete = false)
        {
            if (!_actionMap.ContainsKey(_actionKey)) return;
            _actionMap[_actionKey]?.Complete(complete);
            _actionMap.Remove(_actionKey);
        }

        protected virtual void StopAllAction(bool complete = false)
        {
            var values = _actionMap.GetDictionaryValues();
            for (int i = 0; i < values.Length; i++)
            {
                if (values[i].IsActive())
                {
                    values[i]?.Kill(complete);
                }
            }
            _actionKey = 0;
            _actionMap.Clear();
        }

        public class LongClickData
        {
            public CAction<GameObject, PointerEventData> funcClick;
            public CAction<GameObject, BaseEventData> funcLongClick;
            public CAction<GameObject, PointerEventData> funcDown;
            public CAction<GameObject, PointerEventData> funcUp;
            public float time;
        }

    }
}
