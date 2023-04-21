using UnityEngine;

namespace Hotfix
{
    public static class DebugHelper
    {
        public static bool IsDebug { get; set; } = true;
        public static void Log(object msg)
        {
            if (IsDebug) Debug.Log(msg);
        }
        public static void LogWarning(object msg)
        {
            if (IsDebug) Debug.LogWarning(msg);
        }
        public static void LogError(object msg)
        {
            if (IsDebug) Debug.LogError(msg);
        }
        public static void LogFormat(string msg, params object[] args)
        {
            if (IsDebug) Debug.LogFormat(msg, args);
        }
        public static void LogWarningFormat(string msg, params object[] args)
        {
            if (IsDebug) Debug.LogWarningFormat(msg, args);
        }
        public static void LogErrorFormat(string content, params object[] args)
        {
            if (IsDebug) Debug.LogErrorFormat(content, args);
        }

        public static void LogObject(object msg)
        {
            if(IsDebug) Debug.Log(LitJson.JsonMapper.ToJson(msg));
        }
        public static void LogWarningObject(object msg)
        {
            if(IsDebug) Debug.LogWarning(LitJson.JsonMapper.ToJson(msg));
        }
        public static void LogErrorObject(object msg)
        {
            if(IsDebug) Debug.LogError(LitJson.JsonMapper.ToJson(msg));
        }
    }
}
