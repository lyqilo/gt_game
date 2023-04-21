using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Threading.Tasks;

namespace LuaFramework
{
    public abstract class AChannel : IDisposable
    {
        public long Id { get; set; }

        public ChannelType ChannelType { get; }

        public IPEndPoint RemoteAddress { get; protected set; }

        private event Action<AChannel, SocketError> errorCallback;

        private event Action connectSuccessCallback;

        public event Action<AChannel, SocketError> ErrorCallback
        {
            add
            {
                this.errorCallback += value;
            }
            remove
            {
                this.errorCallback -= value;
            }
        }

        public event Action ConnectSuccessCallback
        {
            add
            {
                this.connectSuccessCallback += value;
            }
            remove
            {
                this.connectSuccessCallback -= value;
            }
        }

        protected void OnError(AChannel channel, SocketError e)
        {
            this.session.CallBack?.Invoke("No");
            this.session.Dispose();
            Action<AChannel, SocketError> action = this.errorCallback;
            if (action != null)
            {
                action(channel, e);
            }
        }

        protected void ConnectSuccess()
        {
            Action action = this.connectSuccessCallback;
            if (action != null)
            {
                action();
            }
        }
        public virtual void Connect(){}

        protected AChannel(AService service, ChannelType channelType,Session session)
        {
            this.Id = IdGenerater.GenerateId();
            this.ChannelType = channelType;
            this.service = service;
            this.session = session;
        }

        public abstract void Send(byte[] buffer);

        public abstract void Send(List<byte[]> buffers);

        public abstract Task<Packet> Recv();

        public virtual void Dispose()
        {
            bool flag = this.Id == 0L;
            if (!flag)
            {
                long id = this.Id;
                this.Id = 0L;
                this.service.Remove(id);
            }
        }

        protected AService service;

        private Session session;
    }
}
