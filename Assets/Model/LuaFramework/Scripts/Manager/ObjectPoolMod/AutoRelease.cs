using UnityEngine;

namespace LuaFramework
{
    public class AutoRelease : MonoBehaviour
    {
        private string m_poolName;

        public void InitData(string poolName)
        {
            m_poolName = poolName;
        }

        public void Release()
        {
            var objectPoolMgr = AppFacade.Instance.GetManager<ObjectPoolManager>();
            objectPoolMgr.Release(m_poolName,gameObject);
        }

    }
}
