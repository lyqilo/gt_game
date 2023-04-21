using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using LuaFramework;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace Hotfix.Hall
{
    public class PanelData
    {
        
    }
    public class PanelBase : ILHotfixEntity
    {
        protected int __longClickCount;
        protected bool __longClickFlag;
        protected int _actionKey;

        protected Dictionary<int, Tween> _actionMap;
        protected List<int> _cos;
        protected Dictionary<string, int> _timerMap;

        public CAction<PanelBase> OnDestroyFinishHandle;
        public UIType uitype;
        public string UIName;

        public PanelBase()
        {
            _actionMap = new Dictionary<int, Tween>();
            _timerMap = new Dictionary<string, int>();
        }

        public PanelBase(UIType _uitype, string _uiName)
        {
            uitype = _uitype;
            UIName = _uiName;
            _actionMap = new Dictionary<int, Tween>();
            _timerMap = new Dictionary<string, int>();
            _cos = new List<int>();
        }

        protected override void Awake()
        {
            base.Awake();
            AddListener();
        }
        public virtual void Create(params object[] args){}

        protected virtual void AddListener()
        {

        }
        protected override void OnDestroy()
        {
            base.OnDestroy();
            CancelAllDelayRun();
            StopAllTimer();
            StopAllAction();

            OnDestroyFinishHandle?.Invoke(this);
        }

        protected virtual void CancelAllDelayRun()
        {
            for (var i = 0; i < _cos.Count; i++)
            {
                HallExtend.Instance?.StopTimer(_cos[i]);
            }
            _cos.Clear();
        }

        protected virtual IEnumerator Delay(float second, CAction func)
        {
            if(second>0) yield return new WaitForSeconds(second);
            func?.Invoke();
        }
        protected virtual int DelayRun(float second, CAction func)
        {
            var co = HallExtend.Instance.DelayRun(second, func);
            _cos.Add(co);
            return co;
        }

        public virtual void CancelDelayRun(int co)
        {
            if (co <= 0) return;
            if (_cos.Contains(co)) _cos.Remove(co);
            HallExtend.Instance?.StopTimer(co);
        }

        protected virtual void AddLongClick(Transform node, LongClickData data)
        {
            var funcClick = data.funcClick;
            CAction<GameObject, PointerEventData> funcLongClick = data.funcLongClick;
            var funcDown = data.funcDown;
            var funcUp = data.funcUp;
            var time = data.time > 0 ? data.time : 1;

            __longClickCount = __longClickCount == 0 ? __longClickCount + 1 : 0;
            var curCount = __longClickCount;

            var listener = EventTriggerHelper.Get(node.gameObject);
            listener.onDown = (obj, eventData) =>
            {
                // MusicManager.Instance.PlaySound();
                __longClickFlag = false;
                StartTimer($"CheckLongClick{curCount}", time, () =>
                {
                    if (eventData.pointerCurrentRaycast.gameObject != node.gameObject) return;
                    __longClickFlag = true;
                    funcLongClick(obj, eventData);
                }, 1);
                funcDown?.Invoke(obj, eventData);
            };
            listener.onUp = (obj, eventData) =>
            {
                funcUp?.Invoke(obj, eventData);

                StopTimer($"CheckLongClick{curCount}");
            };
            listener.onClick = (obj, eventData) =>
            {
                StopTimer($"CheckLongClick{curCount}");
                if (!__longClickFlag) funcClick?.Invoke(obj, eventData);
            };
        }

        protected virtual int RunAction(Tween tweener)
        {
            _actionKey++;
            if (_actionMap.ContainsKey(_actionKey))
            {
                if (_actionMap[_actionKey].IsActive()) _actionMap[_actionKey]?.Kill();
                _actionMap.Remove(_actionKey);
            }

            tweener?.Play();
            _actionMap.Add(_actionKey, tweener);
            return _actionKey;
        }

        protected virtual void StopAction(int _actionKey, bool complete = false)
        {
            if (!_actionMap.ContainsKey(_actionKey)) return;
            if (_actionMap[_actionKey].IsActive()) _actionMap[_actionKey]?.Kill(complete);
            _actionMap.Remove(_actionKey);
        }

        protected virtual void StopAllAction(bool complete = false)
        {
            var values = _actionMap.GetDictionaryValues();
            for (var i = 0; i < values.Length; i++)
                if (values[i].IsActive())
                    values[i]?.Kill(complete);
            _actionKey = 0;
            _actionMap.Clear();
        }

        protected virtual void AddClick(Transform node, CAction<GameObject, PointerEventData> func)
        {
            if (node == null) return;
            var btn = node.GetComponent<Button>();
            if (btn != null)
            {
                btn.onClick.RemoveAllListeners();
                btn.onClick.Add(() =>
                {
                    // MusicManager.Instance.PlaySound();
                    func?.Invoke(btn.gameObject, null);
                });
                return;
            }

            var listener = EventTriggerHelper.Get(node.gameObject);
            listener.onClick = delegate (GameObject obj, PointerEventData eventData)
            {
                // MusicManager.Instance.PlaySound();
                func?.Invoke(obj, eventData);
            };
        }

        protected virtual void AddClick(Transform node, CAction func)
        {
            if (node == null) return;
            var btn = node.GetComponent<Button>();
            if (btn != null)
            {
                btn.onClick.RemoveAllListeners();
                btn.onClick.Add(() =>
                {
                    // MusicManager.Instance.PlaySound();
                    func?.Invoke();
                });
                return;
            }

            var listener = EventTriggerHelper.Get(node.gameObject);
            listener.onClick = (obj, eventData) =>
            {
                // MusicManager.Instance.PlaySound();
                func?.Invoke();
            };
        }


        protected virtual void StartTimer(string name, float interval, CAction func, int times = -1)
        {
            StopTimer(name);
            var key = HallExtend.Instance.StartTimer(func, interval, times);
            _timerMap.Add(name, key);
        }

        protected virtual void StopTimer(string name)
        {
            if (!_timerMap.ContainsKey(name)) return;
            var co = _timerMap[name];
            HallExtend.Instance?.StopTimer(co);
            _timerMap.Remove(name);
        }

        protected virtual void StopAllTimer()
        {
            var values = _timerMap.GetDictionaryValues();
            for (var i = 0; i < values.Length; i++)
            {
                HallExtend.Instance?.StopTimer(values[i]);
            }
            _timerMap.Clear();
        }
    }
}