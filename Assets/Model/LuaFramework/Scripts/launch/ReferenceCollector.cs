using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Object = UnityEngine.Object;

public class ReferenceCollector : MonoBehaviour,ISerializationCallbackReceiver
{
    //用于序列化的List
    public List<ReferenceCollectorData> data = new List<ReferenceCollectorData>();
    private readonly Dictionary<string, Object> dict = new Dictionary<string, Object>();
    public T Get<T>(string key) where T : class
    {
        if (!dict.TryGetValue(key, out Object dictGo))
        {
            return null;
        }
        return dictGo as T;
    }

    public void OnBeforeSerialize()
    {
        
    }

    public void OnAfterDeserialize()
    {
        dict.Clear();
        for (var i = 0; i < data.Count; i++)
        {
            ReferenceCollectorData referenceCollectorData = data[i];
            if (!dict.ContainsKey(referenceCollectorData.key))
            {
                dict.Add(referenceCollectorData.key, referenceCollectorData.gameObject);
            }
        }
    }
}
[Serializable]
public class ReferenceCollectorData
{
    public string key;
    //Object并非C#基础中的Object，而是 UnityEngine.Object
    public Object gameObject;
}
