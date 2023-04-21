using System.Threading.Tasks;
using System;
using UnityEngine;
using com.adjust.sdk;
public class MyMain : MonoBehaviour
{
    public bool _isDebug;
    public bool _isTest;
    public Framework.Assets.PlayMode _mode;
    // Start is called before the first frame update
    private void Awake()
    {
        LuaFramework.Util.IsDebug = _isDebug;
        LuaFramework.Util.IsTest = _isTest;
        YooAsset.YooAssets.Initialize();
        Framework.Assets.Model.Instance.PlayMode = _mode;
    }
}
