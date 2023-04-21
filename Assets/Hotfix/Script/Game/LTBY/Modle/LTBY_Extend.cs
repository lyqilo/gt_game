using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.LTBY
{
    public class LTBY_Extend : SingletonNew<LTBY_Extend>
    {

        private Dictionary<int, Tween> timerMap = new Dictionary<int, Tween>();
        private Dictionary<int, HotfixTimer> _timerMap = new Dictionary<int, HotfixTimer>();
        private int timerKey = 0;
        public int StartTimer(CAction func, float interval = 0, int times = -1)
        {
            timerKey++;
            HotfixTimer timer = new HotfixTimer(interval, times, func);
            timer.StartTimer();
            _timerMap.Add(timerKey, timer);
            return timerKey;
        }
        private IEnumerator Timer(CAction func, float interval = 0, int times = -1)
        {
            int count = times;
            bool isContinue = times < 0 || count > 0;
            while (isContinue)
            {
                yield return new WaitForSeconds(interval);
                func?.Invoke();
                if (count > 0) count--;
                isContinue = times < 0 || count > 0;
            }
        }

        public void StopTimer(int _timerKey = 0)
        {
            if (_timerKey <= 0) return;
            bool has = _timerMap.ContainsKey(_timerKey);
            if (!has) return;
            _timerMap[_timerKey]?.StopTimer();
        }
        public void StopAllTimer()
        {
            var values = _timerMap.GetDictionaryValues();
            for (int i = 0; i < values.Length; i++)
            {
                values[i]?.StopTimer();
            }
            _timerMap.Clear();
            timerKey = 0;
        }
        Dictionary<int,Tween> actionMap = new Dictionary<int, Tween>();
        int actionKey = 0;
        public int RunAction(Tween action)
        {
            actionKey++;
            actionMap.Add(actionKey, action);
            return actionKey;
        }

        public void StopAction(int _actionKey)
        {
            if (!actionMap.TryGetValue(_actionKey, out var tween)) return;
            tween?.Complete();
            actionMap.Remove(_actionKey);
        }

        public void StopAllAction()
        {
            var values = actionMap.GetDictionaryValues();
            for (int i = 0; i < values.Length; i++)
            {
                values[i]?.Complete();
            }
            actionKey = 0;
            actionMap.Clear();
        }
        public int DelayRun(float interval, CAction func)
        {
            return StartTimer(func, interval, 1);
        }

        public static Tween DelayRun(float interval)
        {
            if (interval <= 0) interval = Time.deltaTime;
            return DOTween.To(value => { }, 0, 1, interval).SetEase(Ease.Linear);
        }

        /// <summary>
        /// 销毁
        /// </summary>
        /// <param name="obj"></param>
        public static void Destroy(UnityEngine.Object obj)
        {
            UnityEngine.Object.Destroy(obj);
        }

        /// <summary>
        /// 销毁
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="timer"></param>
        public static void Destroy(UnityEngine.Object obj,float timer)
        {
            UnityEngine.Object.Destroy(obj,timer);
        }
        /// <summary>
        /// 加载预制件
        /// </summary>
        /// <param name="prefabName">预制件名</param>
        /// <param name="parent">父物体</param>
        /// <param name="nodeName">节点命名</param>
        /// <returns></returns>
        public UnityEngine.Transform LoadPrefab(string prefabName, UnityEngine.Transform parent, string nodeName = null)
        {
            Transform transform = LTBY_ResourceManager.Instance.LoadPrefab(prefabName, parent, string.IsNullOrEmpty(nodeName) ? prefabName : nodeName);
            return transform;
        }
        
        /// <summary>
        /// 加载预制件
        /// </summary>
        /// <param name="prefabName">预制件名</param>
        /// <returns></returns>
        public T LoadAsset<T>(string prefabName) where T : UnityEngine.Object
        {
            T transform = LTBY_ResourceManager.Instance.LoadAsset<T>("module62/prefab", prefabName);
            return transform;
        }
        /// <summary>
        /// 加载图片
        /// </summary>
        /// <param name="bundleName">bundle名</param>
        /// <param name="assetName">资源名</param>
        /// <returns></returns>
        public Sprite LoadSprite(string bundleName, string assetName)
        {
            bundleName = $"module62/prefab";
            return LTBY_ResourceManager.Instance.LoadAssetSprite(bundleName, assetName);
        }
        /// <summary>
        /// rendener渐显
        /// </summary>
        /// <param name="node">节点</param>
        /// <param name="time">时间</param>
        /// <param name="callback">回调</param>
        public void RendererFadeIn(UnityEngine.Transform node, float time, CAction callback = null)
        {
            Renderer renderer = node.GetComponent<Renderer>();
            renderer.material.SetColor($"_Color", new Color(1, 1, 1, 0));
            DOTween.To(value=>
            {
                float t = value / 100;
                renderer?.material?.SetColor($"_Color", new Color(1, 1, 1, t));
            }, 0, 100, time).SetEase(Ease.Linear).OnComplete( ()=>
            {
                callback?.Invoke();
            });
        }
        /// <summary>
        /// rendener渐失
        /// </summary>
        /// <param name="node">节点</param>
        /// <param name="time">时间</param>
        /// <param name="callback">回调</param>
        public void RendererFadeOut(UnityEngine.Transform node, float time, CAction callback = null)
        {
            node.GetComponent<Renderer>().material.SetColor($"_Color", new Color(1, 1, 1, 1));
            Renderer renderer = node.GetComponent<Renderer>();
            Tweener key = null;
            key = DOTween.To(value=>
             {
                 float t = 1 - value / 100;
                 renderer?.material?.SetColor($"_Color", new Color(1, 1, 1, t));
             }, 0, 100, time).SetEase(Ease.Linear).OnComplete( ()=>
             {
                 callback?.Invoke();
             });
            key?.SetAutoKill();
        }
        /// <summary>
        /// 所有显示
        /// </summary>
        /// <param name="node">节点</param>
        /// <param name="time">时间</param>
        public void FadeAllIn(UnityEngine.Transform node, float time)
        {
            UnityEngine.UI.Graphic[] children = node.gameObject.GetComponentsInChildren<UnityEngine.UI.Graphic>();
            for (int i = 0; i < children.Length; i++)
            {
                children[i].CrossFadeAlpha(0, 0, true);
                children[i].CrossFadeAlpha(1, time, true);
            }
        }
        /// <summary>
        /// 所有隐藏
        /// </summary>
        /// <param name="node">节点</param>
        /// <param name="time">时间</param>
        public void FadeAllOut(UnityEngine.Transform node, float time)
        {
            UnityEngine.UI.Graphic[] children = node.gameObject.GetComponentsInChildren<UnityEngine.UI.Graphic>();
            for (int i = 0; i < children.Length; i++)
            {
                children[i].CrossFadeAlpha(0, time, true);
            }
        }
        public void DestroyAllChildren(Transform transform, bool immediately=false)
        {
            int count = transform.childCount;
            for (int i = count - 1; i >= 0; i--)
            {
                if (immediately)
                {
                    UnityEngine.Object.DestroyImmediate(transform.GetChild(i).gameObject);
                }
                else
                {
                    UnityEngine.Object.Destroy(transform.GetChild(i).gameObject);
                }
            }
        }

    }
    public class HotfixTimer
    {
        float timer;
        bool isStart;
        int times;
        CAction action;
        float _timer;
        public HotfixTimer(float _timer,int _times,CAction _action)
        {
           this.timer = _timer;
            this.times = _times;
           this.action = _action;
        }
        public HotfixTimer() { }
        public void SetTimer(float _timer)
        {
            this.timer = _timer;
        }
        public void SetAction(CAction _action)
        {
            this.action=_action;
        }
        public void StartTimer()
        {
            if (LTBYEntry.Instance == null) return;
            LTBYEntry.Instance.UpdateEvent += UpdateTimer;
            _timer = timer;
            isStart = true;
        }
        private void UpdateTimer()
        {
            if (!isStart) return;
            this._timer -= Time.deltaTime;
            if (_timer > 0) return;
            this.action?.Invoke();
            if (times > 0)
            {
                times--;
                _timer = timer;
                if (times == 0)
                {
                    StopTimer();
                }
                return;
            }
            if (times < 0) _timer = timer;
        }

        public void StopTimer()
        {
            isStart = false;
            LTBYEntry.Instance.UpdateEvent -= UpdateTimer;
        }
    }
}
