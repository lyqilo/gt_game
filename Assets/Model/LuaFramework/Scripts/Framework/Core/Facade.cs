/* 
    LuaFramework Code By Jarjin lee
*/

using System;
using System.Collections.Generic;
using UnityEngine;

public class Facade
{
    private GameObject m_GameManager;
    public  Dictionary<string, object> m_Managers = new Dictionary<string, object>();

    GameObject AppGameManager
    {
        get
        {
            if (m_GameManager == null)
            {
                m_GameManager = GameObject.Find("GameManager");
                if (m_GameManager == null)
                {
                    m_GameManager= new GameObject("GameManager");
                }
            }
            return m_GameManager;
        }
    }

    protected Facade()
    {
        InitFramework();
    }
    protected virtual void InitFramework()
    {

    }

    /// <summary>
    /// 添加管理器
    /// </summary>
    public void AddManager(string typeName, object obj)
    {
        if (!m_Managers.ContainsKey(typeName))
        {
            var mrg = (IManager)obj;
            if (mrg != null) mrg.OnInitialize();
            m_Managers.Add(typeName, obj);
        }
    }

    /// <summary>
    /// 删除管理器
    /// </summary>
    public void RemoveManager(string typeName)
    {
        object obj = null;
        m_Managers.TryGetValue(typeName, out obj);
        if (obj == null) return;

        var mrg = (IManager)obj;
        if (mrg != null) mrg.UnInitialize();

        Type type = obj.GetType();
        if (type.IsSubclassOf(typeof(MonoBehaviour)))
        {
            GameObject.Destroy((Component)obj);
        }
        m_Managers.Remove(typeName);
    }




    /// <summary>
    /// 添加Unity对象
    /// </summary>
    public T AddManager<T>(string typeName = null) where T : Component, IManager
    {
        object result = null;
        typeName = string.IsNullOrEmpty(typeName) ? typeof(T).Name : typeName;
        m_Managers.TryGetValue(typeName, out result);
        if (result != null)
        {
            return (T)result;
        }
        Component c = AppGameManager.AddComponent<T>();
        m_Managers.Add(typeName, c);
        ((IManager)c).OnInitialize();
        return (T)c;
    }

    public void RemoveManager<T>(string typeName = null) where T : IManager
    {
        typeName = string.IsNullOrEmpty(typeName) ? typeof(T).Name : typeName;
        object manager = null;
        m_Managers.TryGetValue(typeName, out manager);
        if (manager == null) return;
        ((IManager)manager).UnInitialize();
        Type type = manager.GetType();
        if (type.IsSubclassOf(typeof(MonoBehaviour)))
        {
            GameObject.Destroy((Component)manager);
        }
        m_Managers.Remove(typeName);
    }

    /// <summary>
    /// 获取系统管理器
    /// </summary>
    public T GetManager<T>(string typeName = null) where T : class
    {
        typeName = string.IsNullOrEmpty(typeName) ? typeof(T).Name : typeName;
        if (!m_Managers.ContainsKey(typeName))
        {
            return default(T);
        }
        object manager = null;
        m_Managers.TryGetValue(typeName, out manager);
        return (T)manager;
    }


}
