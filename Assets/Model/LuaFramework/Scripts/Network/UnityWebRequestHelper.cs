using System;
using System.Collections;
using System.IO;
using LuaInterface;
using UnityEngine;
using UnityEngine.Networking;

namespace LuaFramework
{
    public class UnityWebRequestHelper
    {
        private UnityWebRequest _webRequest;
        private WWWForm _wwwForm;
        private string _url;
        private LuaFunction _luaFunction;
        private string _method;
        private int _timeout;
        private byte[] _uploadBytes;

        public UnityWebRequestHelper(string url, string method, int timeout, LuaFunction luaFunction)
        {
            _url = url;
            _method = method;
            _timeout = timeout;
            _luaFunction = luaFunction;
        }

        /// <summary>
        /// 添加post参数
        /// </summary>
        /// <param name="key">字段</param>
        /// <param name="value">字段值</param>
        public void AddData(string key, string value)
        {
            if (_wwwForm == null)
            {
                _wwwForm = new WWWForm();
            }

            _wwwForm.AddField(key, value);
        }

        /// <summary>
        /// 添加上传的数据
        /// </summary>
        /// <param name="key">字段</param>
        /// <param name="uploadPath">上传路径</param>
        public void AddBytes(string key, string uploadPath)
        {
            if (_wwwForm == null)
            {
                _wwwForm = new WWWForm();
            }

            byte[] bytes = File.ReadAllBytes(uploadPath);

            _wwwForm.AddBinaryData(key, bytes);
        }

        /// <summary>
        /// 获取上传的byte[]
        /// </summary>
        /// <param name="path">上传路径</param>
        public void GetFileBytes(string path)
        {
            _uploadBytes = File.ReadAllBytes(path);
        }

        /// <summary>
        /// 开始请求
        /// </summary>
        public void StartReq()
        {
            AppFacade.Instance.GetManager<NetworkManager>().StartCoroutine(WaitReq());
        }

        /// <summary>
        /// 获取链接Url
        /// </summary>
        /// <returns></returns>
        public string GetUrl()
        {
            if (_webRequest == null) return null;
            return _webRequest.url;
        }

        IEnumerator WaitReq()
        {
            yield return new WaitForEndOfFrame();
            if (string.IsNullOrEmpty(_method)) yield break;
            _method = _method.ToUpper();
            if (_method == UnityWebRequest.kHttpVerbPOST)
            {
                if (_wwwForm == null)
                {
                    yield break;
                }

                _webRequest = UnityWebRequest.Post(_url, _wwwForm);
            }
            else if (_method == UnityWebRequest.kHttpVerbGET)
            {
                _webRequest = UnityWebRequest.Get(_url);
            }
            else if (_method == UnityWebRequest.kHttpVerbPUT)
            {
                _webRequest = UnityWebRequest.Put(_url, _uploadBytes);
            }

            _webRequest.timeout = _timeout;
            yield return _webRequest.SendWebRequest();
            Debug.Log(_webRequest.url);
            if (!string.IsNullOrEmpty(_webRequest.error) || _webRequest.isHttpError ||
                _webRequest.isNetworkError)
            {
                if (_luaFunction != null)
                {
                    _luaFunction.Call(201, _webRequest.error);
                }

                yield break;
            }

            if (_luaFunction != null)
            {
                _luaFunction.Call(200, _webRequest.downloadHandler.text);
            }

            _webRequest.Dispose();
            _webRequest = null;
        }
    }
}