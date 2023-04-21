using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.Threading.Tasks;
using UnityEngine;

namespace LuaFramework
{
    public class TChannel : AChannel
    {
        public TChannel(TcpClient tcpClient, IPEndPoint ipEndPoint, TService service, int timeOut, Session session) :
            base(service, ChannelType.Connect, session)
        {
            this.tcpClient = tcpClient;
            this.timeOut = timeOut;
            this.parser = new PacketParser(this.recvBuffer);
            base.RemoteAddress = ipEndPoint;
        }

        public TChannel(TcpClient tcpClient, TService service, int timeOut, Session session) : base(service,
            ChannelType.Accept, session)
        {
            this.tcpClient = tcpClient;
            this.timeOut = timeOut;
            this.parser = new PacketParser(this.recvBuffer);
            IPEndPoint remoteAddress = (IPEndPoint) this.tcpClient.Client.RemoteEndPoint;
            base.RemoteAddress = remoteAddress;
            this.OnAccepted();
        }

        public override void Connect()
        {
            base.Connect();
            this.ConnectAsync(base.RemoteAddress);
        }

        private Thread thread;
        private Thread checkStateThread;

        private void ConnectAsync(IPEndPoint ipEndPoint)
        {
            try
            {
                this.tcpClient.ReceiveTimeout = this.timeOut;
                this.tcpClient.SendTimeout = this.timeOut;
                checkStateThread?.Abort();
                checkStateThread = new Thread(new ThreadStart(() =>
                {
                    try
                    {
                        tcpClient.Connect(ipEndPoint.Address, ipEndPoint.Port);
                        this.isConnected = true;
                        this.StartSend();
                        this.StartRecv();
                        NetworkManager.Actions.Enqueue(() =>
                        {
                            base.ConnectSuccess();
                        });
                    }
                    catch (Exception e)
                    {
                        base.OnError(this, SocketError.SocketError);
                        Debug.LogErrorFormat(string.Format("Exception connect error: {0} {1}", ipEndPoint,
                            SocketError.SocketError));
                    }
                }));
                checkStateThread.Start();
            }
            catch (SocketException e)
            {
                Debug.LogErrorFormat(string.Format("SocketException connect error: {0}", e.SocketErrorCode));
                base.OnError(this, e.SocketErrorCode);
            }
            catch (Exception e2)
            {
                base.OnError(this, SocketError.SocketError);
                Debug.LogErrorFormat(string.Format("Exception connect error: {0} {1}", ipEndPoint, e2));
            }
        }

        public override void Dispose()
        {
            bool flag = base.Id == 0L;
            if (!flag)
            {
                base.Dispose();
                this.tcpClient?.Close();
                this.tcpClient?.Dispose();
                thread?.Abort();
                checkStateThread?.Abort();
            }
        }

        private void OnAccepted()
        {
            this.isConnected = true;
            this.StartSend();
            this.StartRecv();
        }

        public override void Send(byte[] buffer)
        {
            bool flag = base.Id == 0L;
            if (flag)
            {
                throw new Exception("TChannel已经被Dispose, 不能发送消息");
            }

            this.sendBuffer.SendTo(buffer);
            bool flag2 = this.isConnected;
            if (flag2)
            {
                this.StartSend();
            }
        }

        public override void Send(List<byte[]> buffers)
        {
            bool flag = base.Id == 0L;
            if (flag)
            {
                throw new Exception("TChannel已经被Dispose, 不能发送消息!");
            }

            try
            {
                foreach (byte[] buffer in buffers)
                {
                    this.sendBuffer.SendTo(buffer);
                }

                bool flag2 = this.isConnected;
                if (flag2)
                {
                    this.StartSend();
                }
            }
            catch (Exception)
            {
                base.OnError(this, SocketError.SocketError);
                throw new Exception("TChannel发送消息失败!");
            }
        }

        private async void StartSend()
        {
            try
            {
                bool flag = base.Id == 0L;
                if (!flag)
                {
                    bool flag2 = this.isSending;
                    if (!flag2)
                    {
                        for (;;)
                        {
                            bool flag3 = base.Id == 0L;
                            if (flag3)
                            {
                                break;
                            }

                            bool flag4 = this.sendBuffer.Count == 0;
                            if (flag4)
                            {
                                goto Block_5;
                            }

                            this.isSending = true;
                            int sendSize = this.sendBuffer.ChunkSize - this.sendBuffer.FirstIndex;
                            bool flag5 = sendSize > this.sendBuffer.Count;
                            if (flag5)
                            {
                                sendSize = this.sendBuffer.Count;
                            }

                            this.tcpClient.GetStream()
                                .Write(this.sendBuffer.First, this.sendBuffer.FirstIndex, sendSize);
                            this.sendBuffer.FirstIndex += sendSize;
                            if (this.sendBuffer.FirstIndex == this.sendBuffer.ChunkSize)
                            {
                                this.sendBuffer.FirstIndex = 0;
                                this.sendBuffer.RemoveFirst();
                            }
                        }

                        return;
                        Block_5:
                        this.isSending = false;
                    }
                }
            }
            catch (Exception)
            {
                throw new Exception("TChannel发送消息失败!");
            }
        }

        private async void StartRecv()
        {
            try
            {
                for (;;)
                {
                    bool flag = base.Id == 0L;
                    if (flag)
                    {
                        break;
                    }

                    int size = this.recvBuffer.ChunkSize - this.recvBuffer.LastIndex;
                    int num = await this.tcpClient.GetStream()
                        .ReadAsync(this.recvBuffer.Last, this.recvBuffer.LastIndex, size);
                    int i = num;
                    if (i == 0)
                    {
                        goto Block_3;
                    }

                    this.recvBuffer.LastIndex += i;
                    if (this.recvBuffer.LastIndex == this.recvBuffer.ChunkSize)
                    {
                        this.recvBuffer.AddLast();
                        this.recvBuffer.LastIndex = 0;
                    }

                    if (this.recvTcs != null)
                    {
                        bool isOK = this.parser.Parse();
                        if (isOK)
                        {
                            Packet packet = this.parser.GetPacket();
                            TaskCompletionSource<Packet> tcs = this.recvTcs;
                            this.recvTcs = null;
                            tcs.SetResult(packet);
                            packet = default(Packet);
                            tcs = null;
                        }
                    }
                }

                return;
                Block_3:
                base.OnError(this, SocketError.NetworkReset);
            }
            catch (ObjectDisposedException)
            {
            }
            catch (Exception e)
            {
                Debug.LogError(e.ToString());
                base.OnError(this, SocketError.SocketError);
            }
        }

        public override Task<Packet> Recv()
        {
            bool flag = base.Id == 0L;
            if (flag)
            {
                throw new Exception("TChannel已经被Dispose, 不能接收消息");
            }

            bool flag2 = this.parser.Parse();
            bool flag3 = flag2;
            Task<Packet> result;
            if (flag3)
            {
                Packet packet = this.parser.GetPacket();
                result = Task.FromResult<Packet>(packet);
            }
            else
            {
                this.recvTcs = new TaskCompletionSource<Packet>();
                result = this.recvTcs.Task;
            }

            return result;
        }


        private readonly TcpClient tcpClient;

        private readonly CircularBuffer recvBuffer = new CircularBuffer();

        private readonly CircularBuffer sendBuffer = new CircularBuffer();

        private int timeOut = 10000;

        private bool isSending;

        private readonly PacketParser parser;

        public bool isConnected;

        private TaskCompletionSource<Packet> recvTcs;
    }
}