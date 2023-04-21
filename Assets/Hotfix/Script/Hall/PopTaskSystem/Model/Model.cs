using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Hotfix.Hall.PopTaskSystem
{
    public class Model : Singleton.SingletonNoMono<Model>, IModule
    {
        public const string CompleteShowPop = "CompleteShowPop";

        private List<IPopItem> _popItems = new List<IPopItem>()
        {
            Announcement.Model.Instance,
            BindPhone.Model.Instance,
            Recharge.Model.Instance,
            Activity.Model.Instance,
        };

        private IPopItem _currentPopItem;
        public IPopItem CurrentPopItem => _currentPopItem;
        private Queue<IPopItem> _popQueue = new Queue<IPopItem>();
        private TaskCompletionSource<bool> _popComplete;
        public bool IsPoping { get; private set; }

        public void Initialize()
        {
            _currentPopItem = null;
            HotfixMessageHelper.AddListener(CompleteShowPop, Callback);
        }

        private void Callback(object data)
        {
            if (!(data is string popName)) return;
            if (_currentPopItem != null && _currentPopItem.PopName.Equals(popName))
            {
                CompleteCall();
            }
        }

        public void UnInitialize()
        {
            StopPop();
            HotfixMessageHelper.RemoveListener(CompleteShowPop, Callback);
        }

        public async void StartPop()
        {
            if (IsPoping) return;
            IsPoping = true;
            _popQueue.Clear();
            for (int i = 0; i < _popItems.Count; i++)
            {
                _popQueue.Enqueue(_popItems[i]);
            }

            while (_popQueue.Count > 0)
            {
                await Pop();
            }

            StopPop();
        }

        public void StopPop()
        {
            _popQueue.Clear();
            _currentPopItem = null;
            IsPoping = false;
        }

        private async Task Pop()
        {
            _popComplete = new TaskCompletionSource<bool>();
            if (_popQueue.Count <= 0) return;
            _currentPopItem = _popQueue.Dequeue();
            if (_currentPopItem.Condition == null || !_currentPopItem.Condition.Invoke()) return;
            if (_currentPopItem.Excute == null) return;
            _currentPopItem.Excute();
            await _popComplete.Task;
        }

        private void CompleteCall()
        {
            _popComplete?.TrySetResult(true);
        }
    }

    public interface IPopItem
    {
        string PopName { get; }
        Func<bool> Condition { get; set; }
        Action Excute { get; set; }
    }
}