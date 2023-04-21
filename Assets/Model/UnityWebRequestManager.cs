using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using LuaFramework;
using LuaInterface;
using UnityEngine;
using UnityEngine.Networking;

public class UnityWebRequestManager : MonoBehaviour
{
    private static UnityWebRequestManager _instance;

    public static UnityWebRequestManager Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = FindObjectOfType<UnityWebRequestManager>();
                if (_instance == null)
                {
                    _instance = AppFacade.Instance.GetManager<GameManager>().gameObject
                        .AddComponent<UnityWebRequestManager>();
                }
            }

            return _instance;
        }
    }

    /// <summary>
    /// GET请求
    /// </summary>
    /// <param name="url">地址</param>
    /// <param name="timeout">超时</param>
    /// <param name="actionResult">回调</param>
    public void GetText(string url, int timeout, LuaFunction actionResult)
    {
        StartCoroutine(_GetText(url, timeout, actionResult));
    }

    /// <summary>
    /// GET请求
    /// </summary>
    /// <param name="url">地址</param>
    /// <param name="timeout">超时</param>
    /// <param name="form">表单</param>
    /// <param name="actionResult">回调</param>
    public void GetText(string url, int timeout, FormData form, LuaFunction actionResult)
    {
        StringBuilder builder=new StringBuilder(url).Append("?");
        for (int i = 0; i < form.FieldNames.Count; i++)
        {
            if (i != 0)
            {
                builder.Append("&");
            }
            builder.Append(form.FieldNames[i]).Append("=").Append(form.FieldValues[i]);
        }
        StartCoroutine(_GetText(builder.ToString(), timeout, actionResult));
    }

    /// <summary>
    /// 下载文件
    /// </summary>
    /// <param name="url">请求地址</param>
    /// <param name="timeout">超时</param>
    /// <param name="downloadFilePathAndName">储存文件的路径和文件名 like 'Application.persistentDataPath+"/unity3d.html"'</param>
    /// <param name="actionResult">请求发起后处理回调结果的委托,处理请求对象</param>
    /// <returns></returns>
    public void DownloadFile(string url, int timeout, string downloadFilePathAndName, LuaFunction actionResult)
    {
        StartCoroutine(_DownloadFile(url, timeout, downloadFilePathAndName, actionResult));
    }


    public void DownloadContinueFile(string url, int timeout, string downloadFilePathAndName, LuaFunction actionResult)
    {
        StartCoroutine(_DownloadContinueFile(url, timeout, downloadFilePathAndName, actionResult));
    }
    /// <summary>
    /// 请求图片
    /// </summary>
    /// <param name="url">图片地址,like 'http://www.my-server.com/image.png '</param>
    /// <param name="timeout">超时</param>
    /// <param name="actionResult">请求发起后处理回调结果的委托,处理请求结果的图片</param>
    /// <returns></returns>
    public void GetTexture(string url, int timeout, LuaFunction actionResult)
    {
        StartCoroutine(_GetTexture(url, timeout, actionResult));
    }

    /// <summary>
    /// 请求AssetBundle
    /// </summary>
    /// <param name="url">AssetBundle地址,like 'http://www.my-server.com/myData.unity3d'</param>
    /// <param name="timeout">超时</param>
    /// <param name="actionResult">请求发起后处理回调结果的委托,处理请求结果的AssetBundle</param>
    /// <returns></returns>
    public void GetAssetBundle(string url, int timeout, LuaFunction actionResult)
    {
        StartCoroutine(_GetAssetBundle(url, timeout, actionResult));
    }

    /// <summary>
    /// 请求服务器地址上的音效
    /// </summary>
    /// <param name="url">没有音效地址,like 'http://myserver.com/mysound.wav'</param>
    /// <param name="timeout">超时</param>
    /// <param name="actionResult">请求发起后处理回调结果的委托,处理请求结果的AudioClip</param>
    /// <param name="audioType">音效类型</param>
    /// <returns></returns>
    public void GetAudioClip(string url, int timeout, LuaFunction actionResult, AudioType audioType = AudioType.WAV)
    {
        StartCoroutine(_GetAudioClip(url, timeout, actionResult, audioType));
    }


    /// <summary>
    /// 向服务器提交post请求
    /// </summary>
    /// <param name="url">服务器请求目标地址,like "http://www.my-server.com/myform"</param>
    /// <param name="timeout">超时</param>
    /// <param name="form">form表单参数</param>
    /// <param name="actionResult">处理返回结果的委托,处理请求对象</param>
    /// <returns></returns>
    public void Post(string url, int timeout, FormData form, LuaFunction actionResult)
    {
        StartCoroutine(_Post(url, timeout, form, actionResult));
    }


    /// <summary>
    /// GET请求
    /// </summary>
    /// <param name="url">请求地址,like 'http://www.my-server.com/ '</param>
    /// <param name="timeout">超时</param>
    /// <param name="actionResult">lua请求回调</param>
    /// <returns></returns>
    IEnumerator _GetText(string url, int timeout, LuaFunction actionResult)
    {
        UnityWebRequest www = UnityWebRequest.Get(url);
        DebugTool.Log(www.uri);
        www.timeout = timeout;
        yield return www.SendWebRequest();
        if (!string.IsNullOrEmpty(www.error) || www.isHttpError || www.isNetworkError)
        {
            if (actionResult != null)
            {
                actionResult.Call(201, www.error);
            }

            yield break;
        }

        if (actionResult != null)
        {
            actionResult.Call(200, www.downloadHandler.text);
        }
    }

    /// <summary>
    /// 向服务器提交post请求
    /// </summary>
    /// <param name="url">服务器请求目标地址,like "http://www.my-server.com/myform"</param>
    /// <param name="timeout">超时</param>
    /// <param name="form">form表单参数</param>
    /// <param name="actionResult">处理返回结果的委托</param>
    /// <returns></returns>
    IEnumerator _Post(string url, int timeout, FormData form, LuaFunction actionResult)
    {
        UnityWebRequest www = UnityWebRequest.Post(url, form.Form);
        www.timeout = timeout;
        yield return www.SendWebRequest();
        if (!string.IsNullOrEmpty(www.error) || www.isHttpError || www.isNetworkError)
        {
            if (actionResult != null)
            {
                actionResult.Call(201, www.error);
            }

            yield break;
        }

        if (actionResult != null)
        {
            actionResult.Call(200, www.downloadHandler.text);
        }
    }

    /// <summary>
    /// 下载文件
    /// </summary>
    /// <param name="url">请求地址</param>
    /// <param name="timeout">超时</param>
    /// <param name="downloadFilePathAndName">储存文件的路径和文件名 like 'Application.persistentDataPath+"/unity3d.html"'</param>
    /// <param name="actionResult">请求发起后处理回调结果的委托,处理请求对象</param>
    /// <returns></returns>
    public IEnumerator _DownloadFile(string url, int timeout, string downloadFilePathAndName,
        LuaFunction actionResult)
    {
        UnityWebRequest www = UnityWebRequest.Get(url);
        www.downloadHandler = new DownloadHandlerFile(downloadFilePathAndName);
        www.timeout = timeout;
        yield return www.SendWebRequest();
        if (!string.IsNullOrEmpty(www.error) || www.isHttpError || www.isNetworkError)
        {
            if (actionResult != null)
            {
                actionResult.Call(201, www.error);
            }

            yield break;
        }

        if (actionResult != null)
        {
            actionResult.Call(200, "文件下载成功");
        }
    }


    public IEnumerator _DownloadContinueFile(string url, int timeout, string filePath,LuaFunction actionResult)
    {
        float progress = 0;
        var headRequest = UnityWebRequest.Head(url);
        headRequest.timeout = timeout;
        yield return headRequest.SendWebRequest();
        
        var totalLength = long.Parse(headRequest.GetResponseHeader("Content-Length"));

        var dirPath = Path.GetDirectoryName(filePath);
        if (!Directory.Exists(dirPath))
        {
            Directory.CreateDirectory(dirPath);
        }

        using (var fs = new FileStream(filePath, FileMode.OpenOrCreate, FileAccess.Write))
        {
            var fileLength = fs.Length;

            if (fileLength < totalLength)
            {
                fs.Seek(fileLength, SeekOrigin.Begin);

                var request = UnityWebRequest.Get(url);
                request.SetRequestHeader("Range", "bytes=" + fileLength + "-" + totalLength);
                request.SendWebRequest();

                var index = 0;
                while (!request.isDone)
                {
                    yield return null;
                    var buff = request.downloadHandler.data;
                    if (buff != null)
                    {
                        var length = buff.Length - index;
                        fs.Write(buff, index, length);
                        index += length;
                        fileLength += length;

                        if (fileLength == totalLength)
                        {
                            progress = 1f;
                        }
                        else
                        {
                            progress = fileLength / (float) totalLength;
                        }
                    }
                }
            }
            else
            {
                progress = 1f;
            }

            fs.Close();
            fs.Dispose();
        }

        if (progress >= 1f)
        {
            if (actionResult != null)
            {
                actionResult.Call();
            }
        }
    }
    /// <summary>
    /// 请求图片
    /// </summary>
    /// <param name="url">图片地址,like 'http://www.my-server.com/image.png '</param>
    /// <param name="timeout">超时</param>
    /// <param name="actionResult">请求发起后处理回调结果的委托,处理请求结果的图片</param>
    /// <returns></returns>
    IEnumerator _GetTexture(string url, int timeout, LuaFunction actionResult)
    {
        UnityWebRequest www = UnityWebRequestTexture.GetTexture(url);
        www.timeout = timeout;
        yield return www.SendWebRequest();
        if (!string.IsNullOrEmpty(www.error) || www.isHttpError || www.isNetworkError)
        {
            if (actionResult != null)
            {
                actionResult.Call(201, www.error);
            }

            yield break;
        }

        if (actionResult != null)
        {
            actionResult.Call(200, DownloadHandlerTexture.GetContent(www));
        }
    }

    /// <summary>
    /// 请求AssetBundle
    /// </summary>
    /// <param name="url">AssetBundle地址,like 'http://www.my-server.com/myData.unity3d'</param>
    /// <param name="timeout">超时</param>
    /// <param name="actionResult">请求发起后处理回调结果的委托,处理请求结果的AssetBundle</param>
    /// <returns></returns>
    IEnumerator _GetAssetBundle(string url, int timeout, LuaFunction actionResult)
    {
        UnityWebRequest www = UnityWebRequestAssetBundle.GetAssetBundle(url);
        www.timeout = timeout;
        yield return www.SendWebRequest();
        if (!string.IsNullOrEmpty(www.error) || www.isHttpError || www.isNetworkError)
        {
            if (actionResult != null)
            {
                actionResult.Call(201, www.error);
            }

            yield break;
        }

        if (actionResult != null)
        {
            actionResult.Call(200, DownloadHandlerAssetBundle.GetContent(www));
        }
    }

    /// <summary>
    /// 请求服务器地址上的音效
    /// </summary>
    /// <param name="url">没有音效地址,like 'http://myserver.com/mysound.wav'</param>
    /// <param name="timeout">超时</param>
    /// <param name="actionResult">请求发起后处理回调结果的委托,处理请求结果的AudioClip</param>
    /// <param name="audioType">音效类型</param>
    /// <returns></returns>
    IEnumerator _GetAudioClip(string url, int timeout, LuaFunction actionResult, AudioType audioType = AudioType.WAV)
    {
        UnityWebRequest www = UnityWebRequestMultimedia.GetAudioClip(url, audioType);
        www.timeout = timeout;
        yield return www.SendWebRequest();
        if (!string.IsNullOrEmpty(www.error) || www.isHttpError || www.isNetworkError)
        {
            if (actionResult != null)
            {
                actionResult.Call(201, www.error);
            }

            yield break;
        }

        if (actionResult != null)
        {
            actionResult.Call(200, DownloadHandlerAudioClip.GetContent(www));
        }
    }
}

public class FormData
{
    private WWWForm _wwwForm;
    private List<string> fieldNames;
    private List<string> fieldValues;

    public List<string> FieldNames
    {
        get { return fieldNames; }
    }

    public List<string> FieldValues
    {
        get { return fieldValues; }
    }

    public WWWForm Form
    {
        get { return _wwwForm; }
    }

    public FormData()
    {
        _wwwForm = new WWWForm();
        this.fieldNames = new List<string>();
        this.fieldValues = new List<string>();
    }

    public void AddField(string fieldName, string value)
    {
        fieldNames.Add(fieldName);
        fieldValues.Add(value);
        _wwwForm.AddField(fieldName, value);
    }

    public void AddBinaryData(string fieldName, byte[] contents)
    {
        _wwwForm.AddBinaryData(fieldName, contents);
    }

    public void AddBinaryData(string fieldName, byte[] contents, string fileName)
    {
        _wwwForm.AddBinaryData(fieldName, contents, fileName);
    }
}