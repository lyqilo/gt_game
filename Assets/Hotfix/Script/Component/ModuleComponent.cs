using System.Collections.Generic;
using UnityEngine;

namespace Hotfix
{
    public interface IModule
    {
        void Initialize();
        void UnInitialize();
    }

    public class ModuleComponent : SingletonNew<ModuleComponent>, IModule
    {
        private bool isInit;

        private List<IModule> _modules = new List<IModule>();

        public void Resigter(IModule module)
        {
            if (_modules.Contains(module)) return;
            _modules.Add(module);
        }

        public void UnResigter(IModule module)
        {
            if (!_modules.Contains(module)) return;
            _modules.Remove(module);
        }

        public override void Init(Transform iLEntity = null)
        {
            base.Init(iLEntity);
            ResigterModules();
            Initialize();
        }

        private void ResigterModules()
        {
            _modules.Clear();
            Resigter(Hall.Mail.Model.Instance);
            Resigter(Hall.LeaderBoard.Model.Instance);
            Resigter(TimeComponent.Instance);
            Resigter(RedPoint.Model.Instance);
            Resigter(Hall.Recharge.Model.Instance);
            Resigter(Hall.PopTaskSystem.Model.Instance);
            Resigter(Hall.Service.Model.Instance);
        }

        public override void Release()
        {
            base.Release();
            UnInitialize();
        }

        public void Initialize()
        {
            if (isInit) return;
            for (int i = 0; i < _modules.Count; i++)
            {
                _modules[i].Initialize();
            }

            isInit = true;
        }

        public void UnInitialize()
        {
            if (!isInit) return;
            for (int i = _modules.Count - 1; i >= 0; i--)
            {
                _modules[i].UnInitialize();
            }

            isInit = false;
        }
    }
}