using System;
using UnityEngine;

namespace Hotfix.Game
{
    public class Singleton<T> : MonoBehaviour where T : Singleton<T>
    {
        private static T _mInstance;
        public static T Instance => _mInstance;

        protected virtual void Awake()
        {
            if (_mInstance != null) return;
            _mInstance = this as T;
        }

        protected virtual void OnDestroy()
        {
            _mInstance = null;
        }
    }
}