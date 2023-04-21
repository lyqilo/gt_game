
#if UNITY_EDITOR
using System.IO;

using UnityEditor;
using UnityEngine;

public class LoadStateSaveData
{
    public bool LuaLoadState;
    public bool AssetLoadState;
}

public static class LoadState
{
    private static LoadStateSaveData getData()
    {
        LoadStateSaveData data = null;
        if (File.Exists(Application.dataPath + "/LoadStateSaveData.txt"))
            data = JsonUtility.FromJson<LoadStateSaveData>(
                File.ReadAllText(Application.dataPath + "/LoadStateSaveData.txt"));
        else
            data = new LoadStateSaveData();
        return data;
    }

    private static void saveData(LoadStateSaveData data)
    {
        File.WriteAllText(Application.dataPath + "/LoadStateSaveData.txt", JsonUtility.ToJson(data));
        AssetDatabase.Refresh();
    }

    /// <summary>
    /// 开启LuaBundle模式
    /// </summary>
    public static bool LuaLoadState
    {
        set
        {
            var data = getData();
            data.LuaLoadState = value;
            saveData(data);
        }
        get { return getData().LuaLoadState; }
    }


    /// <summary>
    /// 开启AssetsBundle模式
    /// </summary>
    public static bool AssetLoadState
    {
        set
        {
            var data = getData();
            data.AssetLoadState = value;
            saveData(data);
        }
        get { return getData().AssetLoadState; }
    }

}
#endif