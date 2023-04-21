using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;

namespace Hotfix.Hall
{
    public class HallExtend : SingletonNew<HallExtend>
    {
        private readonly Dictionary<int, HotfixTimerHandle> _timerMap = new Dictionary<int, HotfixTimerHandle>();
        private int actionKey;

        private readonly Dictionary<int, Tween> actionMap = new Dictionary<int, Tween>();
        private int timerKey;
        private Dictionary<int, Tween> timerMap = new Dictionary<int, Tween>();

        public int StartTimer(CAction func, float interval = 0, int times = -1)
        {
            timerKey++;
            var timer = new HotfixTimerHandle(interval, times, func);
            timer.StartTimer();
            _timerMap.Add(timerKey, timer);
            return timerKey;
        }

        public void StopTimer(int _timerKey = 0)
        {
            if (_timerKey <= 0) return;
            var has = _timerMap.ContainsKey(_timerKey);
            if (!has) return;
            _timerMap[_timerKey]?.StopTimer();
        }

        public void StopAllTimer()
        {
            var values = _timerMap.GetDictionaryValues();
            for (var i = 0; i < values.Length; i++) values[i]?.StopTimer();

            _timerMap.Clear();
            timerKey = 0;
        }

        public int RunAction(Tween action)
        {
            actionKey++;
            actionMap.Add(actionKey, action);
            return actionKey;
        }

        public void StopAction(int _actionKey)
        {
            if (!actionMap.ContainsKey(_actionKey)) return;
            if (!actionMap[_actionKey].IsActive()) actionMap[_actionKey]?.Kill();
            actionMap.Remove(_actionKey);
        }

        public void StopAllAction()
        {
            var values = actionMap.GetDictionaryValues();
            for (var i = 0; i < values.Length; i++)
            {
                if (!values[i].IsActive()) continue;
                values[i]?.Kill();
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
        ///     销毁
        /// </summary>
        /// <param name="obj"></param>
        public static void Destroy(Object obj)
        {
            Object.Destroy(obj);
        }

        /// <summary>
        ///     销毁
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="timer"></param>
        public static void Destroy(Object obj, float timer)
        {
            Object.Destroy(obj, timer);
        }
    }
}