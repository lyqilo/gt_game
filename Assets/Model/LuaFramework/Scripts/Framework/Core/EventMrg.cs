using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace LuaFramework
{
    public delegate void Callback();
    public delegate void Callback<T>(T arg1);
    public delegate void Callback<T, U>(T arg1, U arg2);
    public delegate void Callback<T, U, V>(T arg1, U arg2, V arg3);

    public delegate void Callback_NetMessage_Handle(object _data);

    /// <summary>
    /// 静态全局消息分发执行管理器
    /// </summary>
    public static class EventMrg
    {
        #region 普通消息

        //普通消息
        private static Dictionary<string, object> MsgList = new Dictionary<string, object>();

        // 添加普通消息监听者
        public static void AddListener(string msgName, Callback _callback)
        {
            if (MsgList.ContainsKey(msgName))
            {
                var handle = MsgList[msgName] as Callback;
                if (handle != null)
                    handle += _callback;
                else
                    DebugTool.LogError("当前消息类型有误，错误消息："+msgName);
            }
            else
            {
                MsgList.Add(msgName, _callback);
            }
        }
        public static void AddListener<T>(string msgName, Callback<T> _callback)
        {
            if (MsgList.ContainsKey(msgName))
            {
                var handle = MsgList[msgName] as Callback<T>;
                if (handle != null)
                    handle += _callback;
                else
                    DebugTool.LogError("当前消息类型有误，错误消息："+msgName);
            }
            else
            {
                MsgList.Add(msgName, _callback);
            }
        }
        public static void AddListener<T, U>(string msgName, Callback<T, U> _callback)
        {
            if (MsgList.ContainsKey(msgName))
            {
                var handle = MsgList[msgName] as Callback<T, U>;
                if (handle != null)
                    handle += _callback;
                else
                    DebugTool.LogError("当前消息类型有误，错误消息："+msgName);
            }
            else
            {
                MsgList.Add(msgName, _callback);
            }
        }
        public static void AddListener<T, U, V>(string msgName, Callback<T, U, V> _callback)
        {
            if (MsgList.ContainsKey(msgName))
            {
                var handle = MsgList[msgName] as Callback<T, U, V>;
                if (handle != null)
                    handle += _callback;
                else
                    DebugTool.LogError("当前消息类型有误，错误消息：" + msgName);
            }
            else
            {
                MsgList.Add(msgName, _callback);
            }
        }

        // 删除普通消息监听者
        public static void RemoveListener(string msgName, Callback _callback)
        {
            if (MsgList.ContainsKey(msgName))
            {
                var handle = MsgList[msgName] as Callback;
                if (handle != null)
                {
                    handle -= _callback;
                    if (handle == null) MsgList.Remove(msgName);
                }
            }
        }
        public static void RemoveListener<T>(string msgName, Callback<T> _callback)
        {
            if (MsgList.ContainsKey(msgName))
            {
                var handle = MsgList[msgName] as Callback<T>;
                if (handle != null)
                {
                    handle -= _callback;
                    if (handle == null) MsgList.Remove(msgName);
                }
            }
        }
        public static void RemoveListener<T, U>(string msgName, Callback<T, U> _callback)
        {
            if (MsgList.ContainsKey(msgName))
            {
                var handle = MsgList[msgName] as Callback<T, U>;
                if (handle != null)
                {
                    handle -= _callback;
                    if (handle == null) MsgList.Remove(msgName);
                }
            }
        }
        public static void RemoveListener<T, U, V>(string msgName, Callback<T, U, V> _callback)
        {
            if (MsgList.ContainsKey(msgName))
            {
                var handle = MsgList[msgName] as Callback<T, U, V>;
                if (handle != null)
                {
                    handle -= _callback;
                    if (handle == null) MsgList.Remove(msgName);
                }
            }
        }

        // 广播普通消息
        public static void Brocast(string msgName)
        {
            if (MsgList.ContainsKey(msgName))
            {
                var callback = MsgList[msgName] as Callback;
                if (callback != null) callback();
            }
        }
        public static void Brocast<T>(string msgName, T arg1)
        {
            if (MsgList.ContainsKey(msgName))
            {
                var callback = MsgList[msgName] as Callback<T>;
                if (callback != null) callback(arg1);
            }
        }
        public static void Brocast<T, U>(string msgName, T arg1, U arg2)
        {
            if (MsgList.ContainsKey(msgName))
            {
                var callback = MsgList[msgName] as Callback<T, U>;
                if (callback != null) callback(arg1, arg2);
            }
        }
        public static void Brocast<T, U, V>(string msgName, T arg1, U arg2, V arg3)
        {
            if (MsgList.ContainsKey(msgName))
            {
                var callback = MsgList[msgName] as Callback<T, U, V>;
                if (callback != null) callback(arg1, arg2, arg3);
            }
        }


        #endregion

        #region 网络消息

        //网络消息
        private static Dictionary<int, Callback_NetMessage_Handle> NetMsgList = new Dictionary<int, Callback_NetMessage_Handle>();

        /// <summary>
        /// 添加网络事件观察者
        /// </summary>
        public static void AddObsever(int _protocalType, Callback_NetMessage_Handle _callback)
        {
            if (NetMsgList.ContainsKey(_protocalType))
            {
                NetMsgList[_protocalType] += _callback;
            }
            else
            {
                NetMsgList.Add(_protocalType, _callback);
                //NetworkManager.SetCSharpFlag(_protocalType);    //设置该消息归属C#层
            }
        }

        /// <summary>
        /// 删除网络事件观察者
        /// </summary>
        public static void RemoveObserver(int _protocalType, Callback_NetMessage_Handle _callback)
        {
            if (NetMsgList.ContainsKey(_protocalType))
            {
                NetMsgList[_protocalType] -= _callback;
                if (NetMsgList[_protocalType] == null)
                {
                    NetMsgList.Remove(_protocalType);
                }
            }
        }

        /// <summary>
        /// 广播网络消息
        /// </summary>
        public static void BrocastObserver(int _protocalType, object data)
        {
            if (NetMsgList.ContainsKey(_protocalType))
            {
                NetMsgList[_protocalType](data);
            }
        }

        #endregion

        public static void Clear()
        {
            MsgList.Clear();
            NetMsgList.Clear();
        }
    }

}


