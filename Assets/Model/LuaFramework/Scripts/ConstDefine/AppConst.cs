using System.Collections.Generic;
using UnityEngine;

namespace LuaFramework
{
    public static class AppConst
    {
        //之前的
        public const string FileDataName = "Files.txt";

        public static int GameFrameRate
        {
            get { return _gameFrameRate; }
        }

        private const int _gameFrameRate = 35;

        /// <summary>
        /// Lua是否初始化完成
        /// </summary>
        public static bool Initialize
        {
            set { _initialize = value; }
            get { return _initialize; }
        }

        private static bool _initialize = false;
        public static bool LuaDebug = true;

        /// <summary>
        /// Lua工程目录
        /// </summary>
        public static string LuaFrameworkRoot
        {
            get { return Application.dataPath + "/ThirdParty/LuaFramework"; }
        }

        /// <summary>
        /// AB素材扩展名
        /// </summary>
        public static string ExtName
        {
            get { return _extName; }
        }

        private const string _extName = ".unity3d";
        public static int MBUnitSize = 1048576;
        private static bool _allowDowloadFromWWAN = false;

        //是否允许流量下载
        public static bool AllowDowloadFromWWAN
        {
            set { _allowDowloadFromWWAN = value; }
            get { return _allowDowloadFromWWAN; }
        }
        public static string LuaAssetName = "luascript.unity3d";
        public static string Lua = "Lua";

        public const string LuaTempDir = "templetelua/"; //临时目录
        public const bool LuaBundleMode = true; //Lua代码AssetBundle模式
        public const bool LuaByteMode = false; //Lua字节码模式-默认关闭 
        public const string AssetDir = "StreamingAssets"; //素材目录 

        public const int CodeVersion = 801;
        public const int TimerInterval = 1;
        public const string Nil = "null";
        public const string CSConfigerName = "CSConfiger.json";
        public const string StreamingAssetsName = "StreamingAssets";
        public const string ConstCode = "1F8W9QX1FP1M7G6Z3A72Q2E7U";
        public const string noDestroy = "dontDestroyOnLoad";
        public const string AndroidPlatformName = "android";
        public const string iOSPlatformName = "iOS";
        public const string WinPlatformName = "win";
        public const string MacPlatformName = "mac";
        public static CSConfiger csConfiger;
        public static ValueConfiger valueConfiger;
        public static ValueConfiger gameValueConfiger;
        public static AppInfoConfiger appInfoConfiger;
        public static string WebUrl = string.Empty;
        public static string Login_Ip = string.Empty;
        public static int Login_Port = 0;

        public static List<string> gfIPs = new List<string>();
        public static int UpdateVersion = 0;

        static AppConst()
        {
            AppConst.csConfiger = new CSConfiger();
            AppConst.valueConfiger = default(ValueConfiger);
            AppConst.gameValueConfiger = default(ValueConfiger);
            AppConst.appInfoConfiger = default(AppInfoConfiger);
        }

        public static string AppName
        {
            get { return Application.identifier; }
        }

        public static string AppPrefix
        {
            get { return AppConst.AppName + "_"; }
        }

        public static string LuaBasePath
        {
            get { return Application.dataPath + "/Scripts/uLua/Source/"; }
        }

        public static string LuaWrapPath
        {
            get { return AppConst.LuaBasePath + "LuaWrap/"; }
        }

        public static string HotUpdateDirectoryName
        {
            get { return AppConst.SkinVersionName; }
        }

        public static string AccountFilePath
        {
            get { return PathHelp.AppHotfixResPath + AppConst.AccountFileName; }
        }

        public static string DataFileSavePath
        {
            get { return PathHelp.AppHotfixResPath + AppConst.csConfiger.DataFileName; }
        }

        public static string Version
        {
            get { return Application.version; }
        }

        public static bool ExampleMode
        {
            get { return true; }
        }

        public static bool AutoWrapMode
        {
            get { return true; }
        }

        public static string AppInstallTime { get; set; }

        public static bool DebugMode
        {
            get { return AppConst.csConfiger.DebugMode; }
            set { AppConst.csConfiger.DebugMode = value; }
        }

        public static bool UpdateMode
        {
            get { return AppConst.csConfiger.UpdateMode; }
            set { AppConst.csConfiger.UpdateMode = value; }
        }

        public static int SocketCount
        {
            get { return AppConst.csConfiger.SocketCount; }
            set { AppConst.csConfiger.SocketCount = value; }
        }

        public static int FPS
        {
            get { return AppConst.csConfiger.FPS; }
            set { AppConst.csConfiger.FPS = value; }
        }

        public static int UrlCheckOutTimer
        {
            get { return AppConst.csConfiger.UrlCheckOutTimer; }
            set { AppConst.csConfiger.UrlCheckOutTimer = value; }
        }

        public static int SocketOutTimer
        {
            get { return AppConst.csConfiger.SocketOutTimer; }
            set { AppConst.csConfiger.SocketOutTimer = value; }
        }

        public static int ResetGameTimer
        {
            get { return AppConst.csConfiger.ResetGameTimer; }
            set { AppConst.csConfiger.ResetGameTimer = value; }
        }

        public static int Port
        {
            get { return AppConst.csConfiger.Port; }
            set { AppConst.csConfiger.Port = value; }
        }

        public static int ResourcePort
        {
            get { return AppConst.csConfiger.ResourcePort; }
            set { AppConst.csConfiger.ResourcePort = value; }
        }

        public static int ResourcePortRange
        {
            get { return AppConst.csConfiger.ResourcePortRange; }
            set { AppConst.csConfiger.ResourcePortRange = value; }
        }

        public static int DnsCheckOutTime
        {
            get { return AppConst.csConfiger.DnsCheckOutTime; }
            set { AppConst.csConfiger.DnsCheckOutTime = value; }
        }

        public static bool LuaEncode
        {
            get { return AppConst.csConfiger.LuaEncode; }
            set { AppConst.csConfiger.LuaEncode = value; }
        }

        public static bool HomeKey
        {
            get { return AppConst.csConfiger.HomeKey; }
            set { AppConst.csConfiger.HomeKey = value; }
        }

        public static bool LogMode
        {
            get { return AppConst.csConfiger.LogMode; }
            set { AppConst.csConfiger.LogMode = value; }
        }

        public static bool SaveLogMode
        {
            get { return AppConst.csConfiger.SaveLogMode; }
            set { AppConst.csConfiger.SaveLogMode = value; }
        }

        public static string Ip
        {
            get { return AppConst.csConfiger.Ip; }
            set { AppConst.csConfiger.Ip = value; }
        }

        public static string[] DNS
        {
            get { return AppConst.csConfiger.DNS; }
            set { AppConst.csConfiger.DNS = value; }
        }

        public static string CdnDirectoryName
        {
            get { return AppConst.csConfiger.CdnDirectoryName; }
            set { AppConst.csConfiger.CdnDirectoryName = value; }
        }

        public static string BeginScenName
        {
            get { return AppConst.csConfiger.BeginScenName; }
            set { AppConst.csConfiger.BeginScenName = value; }
        }

        public static string SetFileName
        {
            get { return AppConst.csConfiger.DataFileName; }
            set { AppConst.csConfiger.DataFileName = value; }
        }

        public static string AccountFileName
        {
            get { return AppConst.csConfiger.AccountFileName; }
            set { AppConst.csConfiger.AccountFileName = value; }
        }

        public static string luaEncryptionCode
        {
            get { return AppConst.csConfiger.luaEncryptionCode; }
            set { AppConst.csConfiger.luaEncryptionCode = value; }
        }

        public static bool FileNameEncryption
        {
            get { return AppConst.csConfiger.FileNameEncryption; }
            set { AppConst.csConfiger.FileNameEncryption = value; }
        }

        public static string LuaFileSuffix
        {
            get { return AppConst.csConfiger.LuaFileSuffix; }
            set { AppConst.csConfiger.LuaFileSuffix = value; }
        }

        public static string SkinVersionName
        {
            get { return AppConst.csConfiger.SkinVersionName; }
            set { AppConst.csConfiger.SkinVersionName = value; }
        }

        public static string GameAssetDirectoryName
        {
            get { return AppConst.csConfiger.GameAssetDirectoryName; }
            set { AppConst.csConfiger.GameAssetDirectoryName = value; }
        }

        public static string AppInfoConfigerName
        {
            get { return AppConst.csConfiger.AppInfoConfigerName; }
            set { AppConst.csConfiger.AppInfoConfigerName = value; }
        }

        public static string ValueConfigerName
        {
            get { return AppConst.csConfiger.ValueConfigerName; }
            set { AppConst.csConfiger.ValueConfigerName = value; }
        }

        public static string GameValueConfigerName
        {
            get { return AppConst.csConfiger.GameValueConfigerName; }
            set { AppConst.csConfiger.GameValueConfigerName = value; }
        }

        public static string GameEnterConfigerName
        {
            get { return AppConst.csConfiger.GameEnterConfigerName; }
            set { AppConst.csConfiger.GameEnterConfigerName = value; }
        }

        public static string TextSuffix
        {
            get { return AppConst.csConfiger.TextSuffix; }
            set { AppConst.csConfiger.TextSuffix = value; }
        }

        public static string AssetBundleExtendName
        {
            get { return AppConst.csConfiger.AssetBundleExtendName; }
            set { AppConst.csConfiger.AssetBundleExtendName = value; }
        }

        public static string AuthCode
        {
            get { return AppConst.csConfiger.AuthCode; }
            set { AppConst.csConfiger.AuthCode = value; }
        }
        public static string DNSUrl { get; set; }
    }
    public class DNS
    {
        public List<string> dns;
        public string cdnDirectoryName;
        public string auth;
    }
}