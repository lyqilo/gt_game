using System;
using System.Runtime.InteropServices;
using UnityEngine;

namespace Defence
{
    public class Defence
    {
        public static bool IsInit { get; private set; }

        public static void _ExitAndroid()
        {
            AndroidJavaClass jjc = new AndroidJavaClass("com.dun.bridge.TaiJiDunBridge");
            try
            {
                jjc.CallStatic("Exit");
            }
            catch (Exception e)
            {
                Debug.LogError(e.Message);
            }
        }

        public static bool IsEmulator()
        {
#if UNITY_ANDROID && !UNITY_EDITOR
            AndroidJavaClass jjc = new AndroidJavaClass("com.dun.bridge.TaiJiDunBridge");
            try
            {
                return jjc.CallStatic<bool>("IsEmulator");
            }
            catch (Exception e)
            {
                Debug.LogError(e.Message);
                return false;
            }
#else
            return false;
#endif
        }

        public static int InitDefenceSDK(string key, out string sysName)
        {
            int code = ClinkSDKForUnity.Start(key, out sysName);
            IsInit = code == 150;
            return code;
        }

        public static void StopSDK()
        {
            ClinkSDKForUnity.Stop();
        }

        public static void Exit()
        {
#if UNITY_ANDROID && !UNITY_EDITOR
        _ExitAndroid();
#elif UNITY_STANDALONE || UNITY_EDITOR
#elif UNITY_IOS
#endif
        }
    }
}