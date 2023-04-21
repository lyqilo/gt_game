using Hotfix.Hall;
using LuaFramework;
using UnityEngine;

namespace Hotfix
{
    public class HotfixTimerHandle
    {
        private float _timer;
        private CAction action;
        private readonly ILBehaviour ilBehaviour;
        private bool isStart;
        private float timer;
        private readonly GameObject timerObj;
        private int times;

        public HotfixTimerHandle(float _timer, int _times, CAction _action)
        {
            timer = _timer;
            times = _times;
            action = _action;
            timerObj = new GameObject("TimerObject");
            ilBehaviour = timerObj.AddComponent<ILBehaviour>();
        }

        public HotfixTimerHandle()
        {
        }

        public void SetTimer(float mtimer)
        {
            timer = mtimer;
        }

        public void SetAction(CAction _action)
        {
            action = _action;
        }

        public void StartTimer()
        {
            if (ilBehaviour == null) return;
            ilBehaviour.UpdateEvent = UpdateTimer;
            _timer = timer;
            isStart = true;
        }

        public void PauseTimer()
        {
            isStart = false;
        }

        public void ResumeTimer()
        {
            isStart = true;
        }

        private void UpdateTimer()
        {
            if (!isStart) return;
            _timer -= Time.deltaTime;
            if (_timer > 0) return;
            action?.Invoke();
            if (times > 0)
            {
                times--;
                _timer = timer;
                if (times == 0) StopTimer();
                return;
            }

            if (times < 0) _timer = timer;
        }

        public void StopTimer()
        {
            if (ilBehaviour == null) return;
            isStart = false;
            ilBehaviour.UpdateEvent = null;
            if (timerObj != null) HallExtend.Destroy(timerObj);
        }
    }
}