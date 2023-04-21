using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;

public class ClinkSDKForUnity : MonoBehaviour
{
#if UNITY_EDITOR_WIN || UNITY_STANDALONE_WIN
    //导入windows版本的api
    [DllImport("clinkAPI")]
    private static extern int clinkStart(string key);

    [DllImport("clinkAPI")]
    private static extern int clinkStop();
#endif

#if UNITY_IPHONE
    //导入ios版本的api
    [DllImport("__Internal")]
    private static extern int clinkStartForIOS(string key);
#endif


    /// <summary>
    ///  启动客户端安全接入组件(只需要调用一次，最好不要重复调用)
    ///  返回150表示成功，其它的为失败。返回0有可能是网络不通或密钥错误，返回170有可能是实例到期或不存在。如果重复掉用start()有可能会返回150也可能返回1000，这取决于当时连接的状态，所以最好不要重复调用
    /// </summary>
    /// <param name="key">sdk配置密钥</param>
    /// <param name="sysName">返回的宏定义系统名称(有些版本的Unity在生成时会出现宏定义错误,这样会造成执行的代码不对,这里返回名称有助于分析是否执行了正确的代码)</param>
    /// <returns></returns>
    public static int Start(string key, out string sysName)
    {
        int ret = -99;
        sysName = "unknown";

#if UNITY_EDITOR_WIN || UNITY_STANDALONE_WIN
        //windows版本执行的代码
        ret = clinkStart(key);
        sysName = "windows";
#elif UNITY_IPHONE
       //ios版本执行的代码
       ret = clinkStartForIOS(key);
       sysName = "ios";
#elif UNITY_ANDROID
       //Android版本执行的代码
       AndroidJavaObject jc = new AndroidJavaObject("cn.ay.clinkapi.Api");
       ret = jc.Call<int>("start", key);
       sysName = "android";
#endif
        return ret;
    }

    public static void Stop()
    {
#if UNITY_EDITOR || UNITY_STANDALONE_WIN
        Stop();
#endif
    }
}