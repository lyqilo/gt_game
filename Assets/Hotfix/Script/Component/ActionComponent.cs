using System;
using System.Collections.Generic;

namespace Hotfix
{
    /// <summary>
    /// 事件转发器
    /// </summary>
    public class ActionComponent : Singleton<ActionComponent>
    {
        private Queue<Action> _queue = new Queue<Action>();

        protected override void Awake()
        {
            base.Awake();
            _queue.Clear();
        }

        public void Clear()
        {
            _queue?.Clear();
        }

        public void Add(Action action)
        {
            if (action != null) _queue.Enqueue(action);
        }

        protected virtual void Update()
        {
            if (_queue.Count <= 0) return;
            Action action = _queue.Dequeue();
            action?.Invoke();
        }
    }
}