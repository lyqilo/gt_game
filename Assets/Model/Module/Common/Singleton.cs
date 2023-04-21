using UnityEngine;

namespace Singleton
{
    public class Singleton<T> : MonoBehaviour where T : Singleton<T>
    {
        private static readonly object _lockObj = new object();
        private static T m_Instance;

        public static T Instance
        {
            get
            {
                lock (_lockObj)
                {
                    if (m_Instance != null) return m_Instance;
                    m_Instance = FindObjectOfType<T>();
                    if (m_Instance != null) return m_Instance;
                    GameObject go = new GameObject($"Singleton Of {typeof(T).Name}", typeof(T));
                    DontDestroyOnLoad(go);
                    m_Instance = go.GetComponent<T>();
                    m_Instance.InitImmediate();
                    return m_Instance;
                }
            }
        }

        protected virtual void InitImmediate()
        {
            
        }
    }

    public class SingletonNoMono<T> where T : new()
    {
        private static T m_Instance;

        public static T Instance
        {
            get
            {
                if (m_Instance == null) m_Instance = new T();
                return m_Instance;
            }
        }
    }
}