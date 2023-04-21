using System;
using UnityEngine;

public class AndroidBridge : Singleton.Singleton<AndroidBridge>
{
    public Action<string> OnRecieveMessage { get; set; }

    /// <summary>
    /// 当信息来源收到回调
    /// </summary>
    /// <param name="msg"></param>
    public void OnGetAndroidMessage(string msg)
    {
        DebugTool.LogError($"Android call back:{msg}");
        OnRecieveMessage?.Invoke(msg);
    }

    /// <summary>
    /// 获取Android用户来源
    /// </summary>
    public void InitInstallReferrer()
    {
#if UNITY_ANDROID && !UNITY_EDITOR
            AndroidJavaClass jjc = new AndroidJavaClass("com.dun.bridge.TaiJiDunBridge");
            try
            {
                jjc.CallStatic<string>("initInstallReferrer");
            }
            catch (Exception e)
            {
                Debug.LogError(e.Message);
            }
#endif
    }
}