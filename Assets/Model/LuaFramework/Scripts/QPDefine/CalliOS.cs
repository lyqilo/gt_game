using System;
using UnityEngine;
using System.Runtime.InteropServices;
namespace QPDefine
{
    
    public class CalliOS
    {
#if UNITY_IOS
        [DllImport("__Internal")]
        private static extern string getIosUUIDCode(string makeCode);
        [DllImport("__Internal")]
        private static extern string _getUUIDInKeychain(string uuidKey);
#endif
        //获取iOS唯一编码
        public static string getIosMackUUIDCode(string makeCode)
        {
#if UNITY_IOS
            return _getUUIDInKeychain(makeCode);
#else
            return "";
#endif
        }

        public static void AppInitIAPManager()
        {
        }

        
        public static void iosOpenPhotoLibrary(bool allowsEditing = true)
        {
        }

        
        public static void iosOpenPhotoAlbums(bool allowsEditing = true)
        {
        }

        
        public static void iosOpenCamera(bool allowsEditing = true)
        {
        }

        
        public static void iosSaveImageToPhotosAlbum(string readAddr)
        {
        }

     
        public static void UnityGetXiangChe()
        {
#if UNITY_ANDROID
            string persistentDataPath = Application.persistentDataPath;
            AndroidJavaClass androidJavaClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
            AndroidJavaObject @static = androidJavaClass.GetStatic<AndroidJavaObject>("currentActivity");
            @static.Call("TakePhoto", new object[]
            {
                "takeSave",
                persistentDataPath
            });
#endif
        }

        
        public static void UnityGetXiangJi()
        {
#if UNITY_ANDROID
            string persistentDataPath = Application.persistentDataPath;
            AndroidJavaClass androidJavaClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
            AndroidJavaObject @static = androidJavaClass.GetStatic<AndroidJavaObject>("currentActivity");
            @static.Call("TakePhoto", new object[]
            {
                "takePhoto",
                persistentDataPath
            });
#endif
        }

        
        public static void UnityGetPhone()
        {
#if UNITY_ANDROID
            string persistentDataPath = Application.persistentDataPath;
            AndroidJavaClass androidJavaClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
            AndroidJavaObject @static = androidJavaClass.GetStatic<AndroidJavaObject>("currentActivity");
            @static.Call("TakePhoto", new object[]
            {
                "getPhoto",
                persistentDataPath
            });
#endif
        }

        
        public static void GetPhonePicture(int scale, int wh)
        {
#if UNITY_ANDROID
            string persistentDataPath = Application.persistentDataPath;
            AndroidJavaClass androidJavaClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
            AndroidJavaObject @static = androidJavaClass.GetStatic<AndroidJavaObject>("currentActivity");
            @static.Call("iosUnityOpenPhoto", new object[]
            {
                scale.ToString(),
                wh.ToString()
            });
#endif
        }

        
        public static void UnityGetTake()
        {
#if UNITY_ANDROID
            string persistentDataPath = Application.persistentDataPath;
            AndroidJavaClass androidJavaClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
            AndroidJavaObject @static = androidJavaClass.GetStatic<AndroidJavaObject>("currentActivity");
            @static.Call("TakePhoto", new object[]
            {
                "getTake",
                persistentDataPath
            });
#endif
        }

        
        public static void CopyTextToClipboard(string input)
        {
#if UNITY_ANDROID
            AndroidJavaClass androidJavaClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
            AndroidJavaObject @static = androidJavaClass.GetStatic<AndroidJavaObject>("currentActivity");
            @static.Call("CopyTextToClipboard", new object[]
            {
                input
            });
#endif
        }

        
        public static void ServerBuyOk(string id)
        {
        }

        
        public static void IOSPay(string name, string number)
        {
        }

        
        public static void IOSRequstProductInfo(string str)
        {
        }

        
        public static string GetADID()
        {
            return string.Empty;
        }

        
        public static bool ProductAvailable()
        {
            return true;
        }

        
        public static void SetNoBackupFlag(string path)
        {
        }

        
        public static bool JailBreak1()
        {
            return false;
        }

        
        public static bool JailBreak2()
        {
            return false;
        }

        
        public static bool JailBreak3()
        {
            return false;
        }

        
        public static bool JailBreak4()
        {
            return false;
        }

        
        public static bool JailBreak5()
        {
            return false;
        }

        
        public static string GetTotalDiskSpace()
        {
#if UNITY_ANDROID
            AndroidJavaClass androidJavaClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
            AndroidJavaObject @static = androidJavaClass.GetStatic<AndroidJavaObject>("currentActivity");
            return @static.Call<string>("totalDiskSpace", Array.Empty<object>());
#else
            return "";
#endif
        }

        
        public static string GetFreeDiskSpace()
        {
#if UNITY_ANDROID
            AndroidJavaClass androidJavaClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
            AndroidJavaObject @static = androidJavaClass.GetStatic<AndroidJavaObject>("currentActivity");
            return @static.Call<string>("freeDiskSpace", Array.Empty<object>());
#else
            return "";
#endif
        }

        
        public static string GetHaveUseDiskSpace()
        {
#if UNITY_ANDROID
            AndroidJavaClass androidJavaClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
            AndroidJavaObject @static = androidJavaClass.GetStatic<AndroidJavaObject>("currentActivity");
            return @static.Call<string>("haveUseDiskSpace", Array.Empty<object>());
#else
            return "";
#endif
        }
    }
}
