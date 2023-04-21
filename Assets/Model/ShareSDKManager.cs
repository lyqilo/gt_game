using System;
using System.Collections;
// using cn.sharesdk.unity3d;
using LitJson;
using LuaInterface;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ShareSDKManager : MonoBehaviour
{
    // private ShareSDK ssdk;

    private LuaFunction loginCallBack;

    private static ShareSDKManager _mInstance;

    public static ShareSDKManager Instance
    {
        get
        {
            if (_mInstance == null)
            {
                _mInstance = FindObjectOfType<ShareSDKManager>();
                if (_mInstance == null)
                {
                    GameObject go = new GameObject("ShareSDKManager");
                    _mInstance = go.AddComponent<ShareSDKManager>();
                    DontDestroyOnLoad(go);
                }
            }

            return _mInstance;
        }
    }

    private void Awake()
    {
        if (_mInstance == null)
        {
            _mInstance = this;
            DontDestroyOnLoad(gameObject);
            // if (ssdk == null)
            // {
            //     ssdk = GetComponent<ShareSDK>();
            // }
        }

        // ssdk.showUserHandler = OnLoginCompleted;
        // ssdk.authHandler = OnAuthCompleted;
        SceneManager.LoadSceneAsync("Start");
    }

//     private void OnLoginCompleted(int reqid, ResponseState state, PlatformType type, Hashtable data)
//     {
//         switch (state)
//         {
//             case ResponseState.Success:
//                 DebugTool.Log($"info result:{JsonMapper.ToJson(data)}");
//                 loginCallBack?.Call(200, JsonMapper.ToJson(data));
//                 break;
//             case ResponseState.Fail:
// #if UNITY_ANDROID
//                 loginCallBack?.Call(201, $"错误信息:{data["msg"]}");
// #elif UNITY_IPHONE
//                 loginCallBack?.Call(201, $"错误信息:{data["error_msg"]}");
// #endif
//                 break;
//             case ResponseState.Cancel:
//                 loginCallBack?.Call(202, $"操作取消");
//                 break;
//         }

//         loginCallBack = null;
//     }

//     private void OnAuthCompleted(int reqid, ResponseState state, PlatformType type, Hashtable data)
//     {
//         switch (state)
//         {
//             case ResponseState.Success:
//                 if (data != null && data.Count > 0)
//                 {
//                     DebugTool.Log($"auth result:{JsonMapper.ToJson(data)}");
//                     loginCallBack?.Call(200, JsonMapper.ToJson(data));
//                 }
//                 else
//                 {
//                     ssdk?.GetUserInfo(type); 
//                     return;
//                 }

//                 break;
//             case ResponseState.Fail:
// #if UNITY_ANDROID
//                 loginCallBack?.Call(201, $"错误信息:{data["msg"]}");
// #elif UNITY_IPHONE
//                 loginCallBack?.Call(201, $"错误信息:{data["error_msg"]}");
// #endif
//                 break;
//             case ResponseState.Cancel:
//                 loginCallBack?.Call(202, $"操作取消");
//                 break;
//         }

//         loginCallBack = null;
//     }

    /// <summary>
    /// 登录
    /// </summary>
    /// <param name="platformID">平台id 微信=22</param>
    /// <param name="callback"></param>
    public void Login(int platformID, LuaFunction callback)
    {
        // loginCallBack = callback;
        // if (!IsAuth(platformID))
        // {
        //     ssdk?.Authorize((PlatformType) platformID);
        // }
        // else
        // {
        //     ssdk?.GetUserInfo((PlatformType) platformID);
        // }
    }

    /// <summary>
    /// 是否授权
    /// </summary>
    /// <param name="platformID">平台ID 微信=22</param>
    public bool IsAuth(int platformID)
    {

        return false;

        // if (ssdk == null) return false;
        // return ssdk.IsAuthorized((PlatformType) platformID);
    }
}