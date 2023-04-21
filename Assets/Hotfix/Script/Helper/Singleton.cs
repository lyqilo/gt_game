using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace Hotfix
{
    public class Singleton<T>: MonoBehaviour where T:Singleton<T>
    {
        protected static T m_Instance;
        public static T Instance => m_Instance;

        protected virtual void Awake()
        {
            m_Instance = this as T;

        }
        protected virtual void OnDestroy()
        {
            m_Instance = null;
        }
    }
}
