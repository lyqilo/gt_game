using System;
using System.Collections.Generic;
using LuaInterface;
using UnityEngine.Networking;

namespace LuaFramework
{
    public enum ProtocalType
    {
        None = 0,
        CSharp = 1,
        Lua = 2,
        Share = 3,
    }

    public class NetworkManager : Manager
    {
        private int port = 10013; //游戏服端口
        private string address = "192.168.1.12"; //游戏服地址

        private SocketClient socket;

        //接收消息队列
        static Queue<KeyValuePair<int, byte[]>> resEvents = new Queue<KeyValuePair<int, byte[]>>();

        static Queue<KeyValuePair<int, byte[]>> reqEvents = new Queue<KeyValuePair<int, byte[]>>();

        public static Queue<Action> Actions = new Queue<Action>();

        SocketClient SocketClient
        {
            get
            {
                if (socket == null)
                    socket = new SocketClient();
                return socket;
            }
        }

        public override void OnInitialize()
        {
            //注册代理
            //SocketClient.OnRegister();
        }

        public override void UnInitialize()
        {
            // SocketClient.OnRemove();
        }

        #region 网络消息分发

        /// <summary>
        /// 将消息加入消息分发队列
        /// </summary>
        public static void AddEvent(int _event, byte[] data = null)
        {
            resEvents.Enqueue(new KeyValuePair<int, byte[]>(_event, data));
        }

        /// <summary>
        /// 广播一条消息
        /// </summary>
        void BrocastMsg()
        {
            KeyValuePair<int, byte[]> _event = resEvents.Dequeue();
            //DebugTool.LogError("messge:" + _event.Key);
            //解析数据为LuaStringBuffer
            if (_event.Value == null)
            {
                LuaManager.CallFunction("Network.OnSocket", _event.Key.ToString(), null);
            }
            else
            {
                var luaStrBuff = new LuaByteBuffer(_event.Value);
                LuaManager.CallFunction("Network.OnSocket", _event.Key.ToString(), luaStrBuff);
            }
        }

        /// <summary>
        /// 分发消息
        /// </summary>
        void Update()
        {
            //收消息
            //if (resEvents.Count > 0)
            //{
            //    while (resEvents.Count > 0)
            //    {
            //        BrocastMsg();
            //    }
            //}
            if (Actions.Count > 0)
            {
                Actions.Dequeue().Invoke();
            }
            for (int i = 0; i < NetworkManager.DicSession.Count; i++)
            {
                bool flag = !NetworkManager.DicSession.ContainsKey(i);
                if (!flag)
                {
                    Session session = NetworkManager.DicSession[i];
                    if (session != null)
                    {
                        session.Update();
                    }
                }
            }
        }

        void FixedUpdate()
        {
            //发消息
            if (reqEvents.Count > 0)
            {
                var reqEvent = reqEvents.Dequeue();
                SocketClient.SessionSend(reqEvent.Key, reqEvent.Value);
            }
        }

        #endregion

        #region 外部调用接口

        public void SetNetAddress(string _address, int _port)
        {
            address = _address;
            port = _port;
        }

        /// <summary>
        /// 发送链接请求
        /// </summary>
        public void SendConnect()
        {
            SocketClient.ConnectServer(address, port);
        }

        public void UnConnect()
        {
            SocketClient.OnRemove();
        }

        /// <summary>
        /// Lua 发送SOCKET消息
        /// </summary>
        public void SendMessage(string protocal, LuaByteBuffer data)
        {
            var cmd = int.Parse(protocal);
            //屏蔽一帧内同一消息重复发送
            if (reqEvents.Count > 0)
            {
                var oldEvent = reqEvents.Peek();
                if (oldEvent.Key == cmd) return;
            }

            //消息加入队列
            var buffer = data.buffer;
            var reqEvent = new KeyValuePair<int, byte[]>(cmd, buffer);
            reqEvents.Enqueue(reqEvent);
        }

        /// <summary>
        /// Lua 发送HTTP消息
        /// </summary>
        public HttpRequest CreateHTTPRequest(string url, string method, LuaFunction callback)
        {
            HttpRequest client = new HttpRequest(url, method, 5000, (HttpResponse response) =>
            {
                if (null != callback)
                {
                    callback.Call(response);
                }
            });
            return client;
        }

        #endregion


        public static Dictionary<int, Session> DicSession = new Dictionary<int, Session>();

        public static int aaa = 100;

        public ulong recCount = 0UL;


        public ulong recSize = 0UL;


        public ulong sendCount = 0UL;


        public ulong sendSize = 0UL;


        public ulong downCount = 0UL;


        public ulong downSize = 0UL;


        public ulong upCount = 0UL;


        public ulong upSize = 0UL;


        private UnityWebRequest UnityWebWWW = null;


        private object DownLuaMethod = null;
    }
}