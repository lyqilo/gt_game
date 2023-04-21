using UnityEngine;
using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using LuaFramework;


namespace LuaFramework
{
    public enum DisType
    {
        Exception,
        Disconnect,
    }
    public class SocketClient
    {
        /// <summary>
        /// 包头长度定义
        /// </summary>
        private class Constants
        {
            #region 包头常量定义
            /// <summary>
            /// 包总长度描述(int)(4byte)(除开自身以外的字节)
            /// </summary>
            public static int HEAD_MSG_LEN = 4;

            /// <summary>
            /// 校验标志(short)(2byte)
            /// </summary>
            public static int HEAD_FLAG_LEN = 2;

            /// <summary>
            /// 协议号(short)(2byte)
            /// </summary>
            public static int HEAD_CMD_LEN = 2;

            /// <summary>
            /// 保留字段(short)(2byte)
            /// </summary>
            public static int HEAD_SID_LEN = 2;

            /// <summary>
            /// 包头总长(10byte)
            /// </summary>
            public static int HEAD_LEN
            {
                get { return HEAD_FLAG_LEN + HEAD_MSG_LEN + HEAD_CMD_LEN + HEAD_SID_LEN; }
            }
            #endregion

            //public short flag;      //flag = cmd^length
            //public short length;    //length = msgBytes.len + HEAD_LEN
            //public short cmd;       //协议号
            //public short sid;       //预留字段
            //public byte[] msgBytes;	//pb序列化后的bytes
        }

        /// <summary>
        /// 发送消息结构类
        /// </summary>
        private class C2SSocketData
        {
            private int _dataLength;
            private short _flag;
            private short _cmd;
            private short _SID;
            private byte[] _data;

            public C2SSocketData(int protocalType, byte[] data)
            {
                _dataLength = (data == null) ? 0 : (data.Length);
                _cmd = (short)protocalType;
                _flag = (short)(_cmd ^ _dataLength);
                _data = data;
            }

            public byte[] GetReqSocketDataBytes()
            {
                byte[] _tmpBuff = new byte[_dataLength + Constants.HEAD_LEN];                    //根据总长度生成bytes

                byte[] _tmpDataLength = BitConverter.GetBytes(_dataLength + Constants.HEAD_LEN - Constants.HEAD_MSG_LEN); //获取_dataLength的bytes
                Array.Reverse(_tmpDataLength);

                byte[] _tmpFlag = BitConverter.GetBytes(_flag);             //获取flag的bytes
                Array.Reverse(_tmpFlag);

                byte[] _tmpCMD = BitConverter.GetBytes(_cmd);               //cmd
                Array.Reverse(_tmpCMD);

                byte[] _tmpSID = BitConverter.GetBytes(_SID);               //sid
                Array.Reverse(_tmpSID);

                var offect = 0;

                //缓存总长度（包：【校验标志（2byte）】【包总长度描述（2byte）】）
                Array.Copy(_tmpDataLength, 0, _tmpBuff, 0, Constants.HEAD_MSG_LEN);
                offect += Constants.HEAD_MSG_LEN;

                //缓存校验标志（包：【校验标志（2byte）】）
                Array.Copy(_tmpFlag, 0, _tmpBuff, offect, Constants.HEAD_FLAG_LEN);
                offect += Constants.HEAD_FLAG_LEN;

                //协议类型（包：【校验标志（2byte）】【包总长度描述（2byte）】【协议（2byte）】）                                          
                Array.Copy(_tmpCMD, 0, _tmpBuff, offect, Constants.HEAD_CMD_LEN);
                offect += Constants.HEAD_CMD_LEN;

                //协议类型（包：【校验标志（2byte）】【包总长度描述（2byte）】【协议（2byte）】【SID (2Byte)】）                        
                Array.Copy(_tmpSID, 0, _tmpBuff, offect, Constants.HEAD_SID_LEN);
                offect += Constants.HEAD_SID_LEN;

                if (_dataLength > 0)
                {
                    //协议数据（包：【校验标志（2byte）】【包总长度描述（2byte）】【协议（2byte）】【SID (2Byte)】【数据】）
                    Array.Copy(_data, 0, _tmpBuff, offect, _dataLength);
                }
                return _tmpBuff;
            }
        }

        /// <summary>
        /// 接收消息结构类
        /// </summary>
        private class S2CSocketData
        {
            public int Protocal { private set; get; }
            public byte[] Data { private set; get; }

            public S2CSocketData(byte[] data)
            {
                //读取消息数据
                var buffer = new BinaryReader(new MemoryStream(data));

                //获取data总长度
                var dataLenBytes = buffer.ReadBytes(Constants.HEAD_MSG_LEN);
                Array.Reverse(dataLenBytes);
                var dataLen = BitConverter.ToInt32(dataLenBytes, 0);
                //获取Flag
                var flagbytes = buffer.ReadBytes(Constants.HEAD_FLAG_LEN);
                Array.Reverse(flagbytes);
                var flag = BitConverter.ToInt16(flagbytes, 0);
                //读取协议号
                var cmdbytes = buffer.ReadBytes(Constants.HEAD_CMD_LEN);
                Array.Reverse(cmdbytes);
                Protocal = BitConverter.ToInt16(cmdbytes, 0);
                //取出保留字段SID
                var sidbytes = buffer.ReadBytes(Constants.HEAD_SID_LEN);
                //PB数据
                Data = buffer.ReadBytes(dataLen + Constants.HEAD_MSG_LEN - Constants.HEAD_LEN);
            }

        }

        private TcpClient client = null;
        private NetworkStream outStream = null;
        private MemoryStream memStream;
        private BinaryReader reader;

        private const int MAX_READ = 8192; //8k
        private byte[] byteBuffer = new byte[MAX_READ];
        public static bool loggedIn { set; get; }
        //public static bool IsReverse = true;

        // Use this for initialization
        public SocketClient()
        {
        }

        /// <summary>
        /// 注册代理
        /// </summary>
        public void OnRegister()
        {
            memStream = new MemoryStream();
            reader = new BinaryReader(memStream);
        }

        /// <summary>
        /// 移除代理
        /// </summary>
        public void OnRemove()
        {
            this.Close();
        }

        /// <summary>
        /// 关闭链接
        /// </summary>
        public void Close()
        {
            reader.Close();
            memStream.Close();
            Array.Clear(byteBuffer, 0, byteBuffer.Length);

            if (client != null)
            {
                if (client.Connected) client.Close();
                client = null;
            }
            loggedIn = false;
        }

        #region 链接服务并接收消息

        /// <summary>
        /// 连接服务器
        /// </summary>
        public void ConnectServer(string host, int port)
        {
            Close();
            OnRegister();

            client = null;
            client = new TcpClient();
            client.SendTimeout = 1000;
            client.ReceiveTimeout = 1000;
            client.NoDelay = true;
            try
            {
                client.BeginConnect(host, port, new AsyncCallback(OnConnect), null);
            }
            catch (Exception e)
            {
                Close(); DebugTool.LogError(e.Message);
            }
        }

        /// <summary>
        /// 剩余的字节
        /// </summary>
        private long RemainingBytes()
        {
            return memStream.Length - memStream.Position;
        }

        // 连接上服务器
        void OnConnect(IAsyncResult asr)
        {
            try
            {
                outStream = client.GetStream();
                client.GetStream().BeginRead(byteBuffer, 0, MAX_READ, new AsyncCallback(OnRead), null);
                //通知连接服务器成功消息
                NetworkManager.AddEvent((int)Protocal.Connect);
            }
            catch (Exception e)
            {
                Close();
                NetworkManager.AddEvent(-100);
            }
        }

        // 读取消息
        void OnRead(IAsyncResult asr)
        {
            int bytesRead = 0;
            try
            {
                lock (client.GetStream())
                {   //读取字节流到缓冲区
                    bytesRead = client.GetStream().EndRead(asr);
                }
                if (bytesRead < 1)
                {   //包尺寸有问题，断线处理
                    OnDisconnected(DisType.Disconnect, "bytesRead < 1");
                    return;
                }

                //分析数据包内容，抛给逻辑层
                OnReceive(byteBuffer, bytesRead);

                //分析完，再次监听服务器发过来的新消息
                lock (client.GetStream())
                {
                    Array.Clear(byteBuffer, 0, byteBuffer.Length);   //清空数组
                    client.GetStream().BeginRead(byteBuffer, 0, MAX_READ, new AsyncCallback(OnRead), null);
                }
            }
            catch (Exception ex)
            {
                //PrintBytes();
                OnDisconnected(DisType.Exception, ex.Message);
            }
        }

        // 丢失链接
        void OnDisconnected(DisType dis, string msg)
        {
            Close();   //关掉客户端链接
            int protocal = dis == DisType.Exception ?
            (int)Protocal.Exception : (int)Protocal.Disconnect;

            NetworkManager.AddEvent(protocal);
            DebugTool.LogError("Connection was closed by the server:>" + msg + " Distype:>" + dis);
        }

        // 接收消息
        void OnReceive(byte[] bytes, int length)
        {
            //将新数据写入缓存中
            memStream.Seek(0, SeekOrigin.End);      //将流位置设置在流末尾
            memStream.Write(bytes, 0, length);      //将新内容写到流末尾
            memStream.Seek(0, SeekOrigin.Begin);    //将流位置设置在流开头

            //判读剩余数据是否足够一个包头长度 （包头长度（10byte））协议数据（包：【Len（4byte）】【FLAG（2byte）】【CMD（2byte）】【Byte】【Byte】【数据】）
            while (RemainingBytes() >= Constants.HEAD_LEN)
            {
                //获取Msg总长度
                var dataLenBytes = reader.ReadBytes(Constants.HEAD_MSG_LEN);
                Array.Reverse(dataLenBytes);
                var dataLen = BitConverter.ToInt32(dataLenBytes, 0);
                //重置流位置设置 
                memStream.Position = memStream.Position - Constants.HEAD_MSG_LEN;
                //包读未读取完毕返回等待读取完毕
                if (RemainingBytes() < dataLen + Constants.HEAD_MSG_LEN) break;
                //读取一个整包数据
                var databytes = reader.ReadBytes(dataLen + Constants.HEAD_MSG_LEN);
                var socketData = new S2CSocketData(databytes);
                //加入消息分发队列
                NetworkManager.AddEvent(socketData.Protocal, socketData.Data);
            }

            //重置缓存
            byte[] leftover = reader.ReadBytes((int)RemainingBytes());  //读取剩余不够一个包头长度的数据
            memStream.SetLength(0);                                     //Clear
            memStream.Write(leftover, 0, leftover.Length);              //保存剩余的数据
        }

        #endregion


        #region 服务器发送消息

        /// <summary>
        /// 向链接写入数据流
        /// </summary>
        void OnWrite(IAsyncResult r)
        {
            try
            {
                outStream.EndWrite(r);
            }
            catch (Exception ex)
            {
                DebugTool.LogError("OnWrite--->>>" + ex.Message);
            }
        }

        /// <summary>
        /// 写数据
        /// </summary>
        void WriteMessage(int protocal, byte[] message)
        {
            C2SSocketData data = new C2SSocketData(protocal, message);
            //发送消息
            if (client != null && client.Connected)
            {
                //NetworkStream stream = client.GetStream(); 
                byte[] payload = data.GetReqSocketDataBytes();
                outStream.BeginWrite(payload, 0, payload.Length, new AsyncCallback(OnWrite), null);
            }
            else
            {
                DebugTool.LogError("client.connected----->>false");
            }
        }

        /// <summary>
        /// 会话发送
        /// </summary>
        public void SessionSend(int protocal, byte[] bytes)
        {
            WriteMessage(protocal, bytes);
        }

        #endregion
    }

}



