using System;
using System.Net;
using System.Net.Sockets;
using System.Threading.Tasks;
using UnityEngine;
using LuaInterface;

namespace LuaFramework
{
    public class Session
    {
        private IPEndPoint ipEndPoint;

        public int Id = 0;

        private AService Service;
        private AChannel Channel;

        private IMessagePacker MessagePacker { get; set; }
        private IMessageDispatcher MessageDispatcher { get; set; }

        public Action<string> CallBack = null;
        private byte[] ByteMsg = new byte[8192];
        private BytesPack pack = default(BytesPack);
        public bool run = true;
        public object CloseFunc = null;

        public Encrypt encrypt = new Encrypt();

//        public Session(string host, int port, int sessionId, LuaFunction luaCallBack = null, int timeOut = 1000)
//        {
//            try
//            {
//                CallBack = delegate(string state)
//                {
//                    if (luaCallBack != null)
//                    {
//                        luaCallBack.Call(state, this);
//                    }
//                };

//                IPAddress[] address = Dns.GetHostAddresses(host);
//                if (address.Length == 0)
//                {
//                    return;
//                }

//                AddressFamily addressFamily = AddressFamily.InterNetwork;
//                if (address[0].AddressFamily == AddressFamily.InterNetworkV6)
//                {
//                    addressFamily = AddressFamily.InterNetworkV6;
//                }

////                Debug.LogError(address[0].ToString());
//                ipEndPoint = NetworkHelper.ToIPEndPoint(address[0].ToString(), port);
//                Service = new TService();
//                Id = sessionId;
//                Channel = Service.ConnectChannel(ipEndPoint, timeOut, addressFamily, this);

//                MessagePacker = new CustomMessagePacker();
//                MessageDispatcher = new MessageDispatcher();

//                Channel.ErrorCallback += delegate(AChannel c, SocketError e)
//                {
//                    if (luaCallBack != null)
//                    {
//                        CallBack?.Invoke("No");
//                        Dispose();
//                    }

//                    Dispose();
//                };

//                Channel.ConnectSuccessCallback += ConnectSuccess;
//                Channel.Connect();
//                StartRecv();
//            }
//            catch (Exception e)
//            {
//                CallBack?.Invoke("No");
//                //throw;
//            }
//        }


        public Session(string host, int port, int sessionId, int timeOut = 1000, Action<string, Session> callBack=null)
        {
            CallBack = delegate (string state)
            {
                callBack?.Invoke(state, this);
            };
            try
            {
                IPAddress[] address = Dns.GetHostAddresses(host);
                if (address.Length == 0)
                {
                    return;
                }
                AddressFamily addressFamily = AddressFamily.InterNetwork;
                if (address[0].AddressFamily == AddressFamily.InterNetworkV6)
                {
                    addressFamily = AddressFamily.InterNetworkV6;
                }
                ipEndPoint = NetworkHelper.ToIPEndPoint(address[0].ToString(), port);
                Service = new TService();
                Id = sessionId;
                Channel = Service.ConnectChannel(ipEndPoint, timeOut, addressFamily, this);
                MessagePacker = new CustomMessagePacker();
                MessageDispatcher = new MessageDispatcher();
                Channel.ErrorCallback += delegate (AChannel c, SocketError e)
                {
                    callBack?.Invoke("No", this);
                    Dispose();
                };
                Channel.ConnectSuccessCallback += ConnectSuccess;
                Channel.Connect();
                StartRecv();
            }
            catch (Exception e)
            {
                callBack?.Invoke("No",this);
            }
        }

        private void ConnectSuccess()
        {
            Add();
            CallBack?.Invoke("Yes");
            CallBack = null;
        }

        public Session this[int id]
        {
            get { return (NetworkManager.DicSession.Count < id) ? null : NetworkManager.DicSession[id]; }
        }

        private void Add()
        {
            bool flag = NetworkManager.DicSession.ContainsKey(this.Id);
            bool flag2 = flag;
            if (flag2)
            {
                NetworkManager.DicSession[this.Id] = this;
            }

            bool flag3 = !flag;
            if (flag3)
            {
                NetworkManager.DicSession.Add(this.Id, this);
            }
        }

        public void ListenConnect()
        {
            bool flag = this.CallBack == null;
            if (!flag)
            {
                bool flag2 = this.Id < 0;
                if (!flag2)
                {
                    Debug.LogError("Listen over timeOut");
                    Action<string> callBack = this.CallBack;
                    if (callBack != null)
                    {
                        callBack("no");
                    }

                    this.CallBack = null;
                    this.Dispose();
                }
            }
        }

        // Token: 0x060026D7 RID: 9943 RVA: 0x00100B20 File Offset: 0x000FED20
        public void Update()
        {
            AService service = this.Service;
            if (service != null)
            {
                service.Update();
            }

            IMessageDispatcher messageDispense = this.MessageDispatcher;
            if (messageDispense != null)
            {
                messageDispense.Update();
            }
        }

        private async void StartRecv()
        {
            for (;;)
            {
                bool flag = this.Id < 0;
                if (flag)
                {
                    break;
                }

                Packet packet;
                try
                {
                    Packet packet2 = await this.Channel.Recv();
                    packet = packet2;
                    packet2 = default(Packet);
                    if (this.Id < 0)
                    {
                        Debug.LogErrorFormat(string.Format("session ={0} error!!", this.Id));
                        return;
                    }
                }
                catch (Exception e)
                {
                    Debug.LogError(e.Message);
                    this.Dispose();
                    continue;
                }

                if (packet.Length < 2)
                {
                    goto Block_3;
                }

                try
                {
                    await this.RunDecompressedBytes(packet);
                }
                catch (Exception e2)
                {
                    Debug.LogError(e2.ToString());
                    this.Dispose();
                }

                packet = default(Packet);
            }

            Debug.LogError(string.Format("session ={0} error!", this.Id));
            return;
            Block_3:
            string error = string.Format("message error length < 2, ip: {0}", this.ipEndPoint);
        }

        // Token: 0x060026D9 RID: 9945 RVA: 0x00100B84 File Offset: 0x000FED84
        private async Task RunDecompressedBytes(Packet packet)
        {
            Buffer.BlockCopy(packet.headBytes, 0, this.ByteMsg, 0, packet.headBytes.Length);
            Buffer.BlockCopy(packet.bodyBytes, 0, this.ByteMsg, packet.headBytes.Length,
                packet.Length - packet.headBytes.Length);
            BytesPack bytesPack = await Task.Run<BytesPack>(delegate
            {
                this.pack = this.MessagePacker.DeserializeFrom<BytesPack>(this.ByteMsg, packet.Length, this);
                return this.pack;
            });
            this.pack = bytesPack;
            bytesPack = default(BytesPack);
            this.MessageDispatcher.Dispense(this.pack);
        }

        public bool Send(byte[] msg)
        {
            try
            {
                this.Channel.Send(msg);
            }
            catch (Exception ex)
            {
                Debug.LogErrorFormat(string.Format("Send exception:{0}", ex.Message));
                this.Dispose();
                return false;
            }

            return true;
        }

        // Token: 0x060026DB RID: 9947 RVA: 0x00100C2C File Offset: 0x000FEE2C
        public bool Send(BytesPack msg)
        {
            return this.Send(this.MessagePacker.SerializeToByteArray(msg, this));
        }

        // Token: 0x060026DC RID: 9948 RVA: 0x00100C58 File Offset: 0x000FEE58
        public bool Send(ushort mid, ushort sid, ByteBuffer bf)
        {
            return this.Send(mid, sid, bf.ToBytes());
        }

        // Token: 0x060026DD RID: 9949 RVA: 0x00100C78 File Offset: 0x000FEE78
        public bool Send(ushort mid, ushort sid, byte[] bytes)
        {
            bool flag = bytes == null;
            if (flag)
            {
                bytes = new byte[0];
            }

            BytesPack bytesPack = new BytesPack((int) mid, (int) sid, bytes, this);
            bytes = this.MessagePacker.SerializeToByteArray(bytesPack, this);
            return this.Send(bytes);
        }

        // Token: 0x060026DE RID: 9950 RVA: 0x00100CC4 File Offset: 0x000FEEC4
        public void Dispose()
        {
            bool flag = this.Id < 0;
            if (!flag)
            {
                Debug.LogErrorFormat(string.Format("session {0} dispose !", this.Id));
                this.run = false;
                this.Channel.Dispose();
                bool flag2 = this.CloseFunc != null;
                if (flag2)
                {
                    Action<string> callf = (Action<string>) this.CloseFunc;
                    callf?.Invoke(this.Id.ToString());
                }

                this.Id = -1;
            }
        }
    }
}