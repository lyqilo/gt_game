using UnityEngine;

namespace Hotfix
{
    public class SingletonILEntity<T> : ILHotfixEntity where T : SingletonILEntity<T>
    {

        protected static T m_Instance;

        public static T Instance
        {
            get { return m_Instance; }
        }

        protected override void Awake()
        {
            m_Instance = this as T;
            base.Awake();
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            m_Instance = null;
        }
    }

    public class SingletonNew<T> where T : SingletonNew<T>,new()
    {
        protected static T m_Instance;
        public static T Instance
        {
            set { m_Instance = value; }
            get
            {
                if (m_Instance == null)
                {
                    m_Instance = new T();
                }
                return m_Instance;
            }
        }
        public Transform ILBehaviour { get; set; }
        public virtual void Init(Transform iLEntity = null)
        {
            ILBehaviour = iLEntity;
        }
        public virtual void Release()
        {
            Instance = null;
        }
    }
}
