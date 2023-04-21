using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using UnityEngine.Events;

namespace LuaFramework {

    /// <summary>
    /// 对象池管理器，游戏资源对象池
    /// </summary>
    public class ObjectPoolManager : Manager 
    {
        /// <summary>
        /// 游戏资源缓存池
        /// </summary>
        private class GameObjectPool
        {
            private int maxSize;
            private string poolName;
            private Transform poolRoot;
            private GameObject poolObjectPrefab;
            private Stack<GameObject> availableObjStack = new Stack<GameObject>();

            /// <summary>
            /// 创建一个游戏资源缓存池
            /// </summary>
            /// <param name="poolName">缓存池名称</param>
            /// <param name="poolObjectPrefab">缓存池资源prefab</param>
            /// <param name="initCount">初始化生成实例个数</param>
            /// <param name="maxSize">最大缓存实例个数</param>
            /// <param name="pool">缓存池节点</param>
            public GameObjectPool(string poolName, GameObject poolObjectPrefab, int initCount, int maxSize, Transform pool)
            {
                this.poolName = poolName;
                this.maxSize = maxSize;
                this.poolRoot = pool;
                this.poolObjectPrefab = poolObjectPrefab;

                //初始化实例缓存资源
                for (int index = 0; index < initCount; index++)
                {
                    AddObjectToPool(NewObjectInstance());
                }
            }

            /// <summary>
            /// 实例化一个新的Obj
            /// </summary>
            /// <returns></returns>
            private GameObject NewObjectInstance()
            {
                var go = GameObject.Instantiate(poolObjectPrefab);

                //初始化回收脚本
                var auto = go.GetComponent<AutoRelease>();
                if (auto == null) auto = go.AddComponent<AutoRelease>();
                auto.InitData(poolName);

                return go;
            }

            /// <summary>
            /// 销毁多余的Obj
            /// </summary>
            private void DestroyObjectInstance(GameObject go)
            {
                GameObject.Destroy(go);
            }

            /// <summary>
            /// 将Obj挂载到PoolRoot上
            /// </summary>
            /// <param name="go"></param>
            private void AddObjectToPool(GameObject go)
            {
                go.SetActive(false);
                availableObjStack.Push(go);
                go.transform.SetParent(poolRoot, false);
            }

            /// <summary>
            /// 从缓存池获取一个Obj
            /// </summary>
            public GameObject GetObjectOfPool()
            {
                GameObject go = null;
                if (availableObjStack.Count == 0)
                {
                    go = NewObjectInstance();
                }
                else
                {
                    go = availableObjStack.Pop();
                }
                go.SetActive(true);
                return go;
            }

            /// <summary>
            /// 将一个Obj放回缓存池
            /// </summary>
            /// <param name="pool">缓存池名称</param>
            /// <param name="po">回收的Obj</param>
            public void ReturnObjectToPool(string pool, GameObject po)
            {
                if (poolName.Equals(pool))
                {
                    //超过上限回收的直接销毁
                    if (availableObjStack.Count >= maxSize)
                    {
                        DestroyObjectInstance(po);
                    }
                    else
                    {
                        AddObjectToPool(po);
                    }
                }
                else
                {
                    DebugTool.LogError(string.Format("Trying to add object to incorrect pool {0} ", poolName));
                }
            }

            /// <summary>
            /// 清空当前缓存池保存的缓存
            /// </summary>
            public void Clear()
            {
                while (availableObjStack.Count > 0)
                {
                    var go = availableObjStack.Pop();
                    GameObject.Destroy(go);
                }
#if UNITY_EDITOR
                GameObject.Destroy(poolRoot.gameObject);
#endif
            }

            public void Del()
            {
                Clear();
                poolObjectPrefab = null;
            }
        }

        //游戏资源对象池保存
        private Dictionary<string, GameObjectPool> m_GameObjectPools = new Dictionary<string, GameObjectPool>();

        [NoToLua]
        public override void OnInitialize()
        {
            
        }

        [NoToLua]
        public override void UnInitialize()
        {
            ClearPool();
            m_GameObjectPools.Clear();
        }

        #region 游戏资源对象池

        /// <summary>
        /// 获取一个游戏资源对象池
        /// </summary>
        /// <param name="poolName">对象池名称</param>
        /// <returns></returns>
        private GameObjectPool GetPool(string poolName)
        {
            if (m_GameObjectPools.ContainsKey(poolName))
            {
                return m_GameObjectPools[poolName];
            }
            return null;
        }

        /// <summary>
        /// 创建一个游戏资源对象池
        /// </summary>
        /// <param name="poolName">缓存池名称</param>
        /// <param name="prefab">用于实例的模板prefab</param>
        /// <param name="initSize">创建缓存池初始实例资源个数</param>
        /// <param name="maxSize">最大缓存个数</param>
        public void CreatePool(string poolName, GameObject prefab,int initSize = 1, int maxSize = 10)
        {
            var pool = GetPool(poolName);
            if (pool != null) return;

#if UNITY_EDITOR
            var poolRoot = new GameObject(poolName + "MaxSize:" + maxSize.ToString());
            poolRoot.transform.SetParent(transform);
            poolRoot.transform.localScale = Vector3.one;
            poolRoot.transform.localPosition = Vector3.zero;
            pool = new GameObjectPool(poolName, prefab, initSize, maxSize, poolRoot.transform);
#else
            pool = new GameObjectPool(poolName, prefab, initSize, maxSize, transform);
#endif
            m_GameObjectPools[poolName] = pool;
        }

        /// <summary>
        /// 删除指定缓存池
        /// </summary>
        public void DelPool(string poolName)
        {
            if (m_GameObjectPools.ContainsKey(poolName))
            {
                var pool = m_GameObjectPools[poolName];
                pool.Del();
                m_GameObjectPools.Remove(poolName);
            }
        }

        /// <summary>
        /// 从一个对象池获取一个游戏资源
        /// </summary>
        /// <param name="poolName">对象池名称</param>
        /// <returns></returns>
        public GameObject Get(string poolName) 
        {
            GameObject result = null;
            if (m_GameObjectPools.ContainsKey(poolName)) 
            {
                GameObjectPool pool = m_GameObjectPools[poolName];
                result = pool.GetObjectOfPool();
            } 
            else 
            {
                DebugTool.LogErrorFormat("Invalid pool name specified: {0}", poolName);
            }
            return result;
        }

        /// <summary>
        /// 回收一个游戏资源
        /// </summary>
        /// <param name="poolName">对象池名称</param>
        /// <param name="go">游戏资源</param>
        public void Release(string poolName, GameObject go) 
        {
            if (m_GameObjectPools.ContainsKey(poolName)) 
            {
                GameObjectPool pool = m_GameObjectPools[poolName];
                pool.ReturnObjectToPool(poolName, go);
            } 
            else 
            {
                DebugTool.LogError("No pool available with name: " + poolName);
            }
        }

        #endregion

        /// <summary>
        /// 清空所有缓存池的缓存文件
        /// </summary>
        public void ClearPool()
        {
            foreach (var goPool in m_GameObjectPools)
            {
                var pool = goPool.Value;
                pool.Clear();
            }
        }
    }
}