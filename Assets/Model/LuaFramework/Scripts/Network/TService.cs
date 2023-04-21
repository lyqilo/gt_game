using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Threading.Tasks;
using UnityEngine;

namespace LuaFramework
{
    public sealed class TService : AService
    {
        public TService(IPEndPoint ipEndPoint)
        {
            this.acceptor = new TcpListener(ipEndPoint);
            this.acceptor.Start();
        }

        public TService()
        {
        }

        public override void Dispose()
        {
            bool flag = this.acceptor == null;
            if (!flag)
            {
                foreach (long key in this.idChannels.Keys.ToArray<long>())
                {
                    TChannel tchannel = this.idChannels[key];
                    tchannel.Dispose();
                }
                this.acceptor.Stop();
                this.acceptor = null;
            }
        }

        public override AChannel GetChannel(long id)
        {
            TChannel result = null;
            this.idChannels.TryGetValue(id, out result);
            return result;
        }

        public override async Task<AChannel> AcceptChannel(int timeOut)
        {
            bool flag = this.acceptor == null;
            if (flag)
            {
                throw new Exception("service construct must use host and port param");
            }
            TcpClient tcpClient2 = await this.acceptor.AcceptTcpClientAsync();
            TcpClient tcpClient = tcpClient2;
            tcpClient2 = null;
            TChannel channel = null;
            this.idChannels[channel.Id] = channel;
            return channel;
        }

        public override AChannel ConnectChannel(IPEndPoint ipEndPoint, int timeOut, AddressFamily addressFamily,Session session )
        {
            TcpClient tcpClient = new TcpClient(addressFamily);
            TChannel tchannel = new TChannel(tcpClient, ipEndPoint, this, timeOut, session);
            this.idChannels[tchannel.Id] = tchannel;
            return tchannel;
        }

        public override void Remove(long id)
        {
            TChannel tchannel;
            bool flag = !this.idChannels.TryGetValue(id, out tchannel);
            if (!flag)
            {
                bool flag2 = tchannel == null;
                if (!flag2)
                {

                    Debug.LogErrorFormat(string.Format("TService Remove:{0}", id));
                    this.idChannels.Remove(id);
                    tchannel.Dispose();
                }
            }
        }

        public override void Update()
        {
        }

        //public override Task<AChannel> AcceptChannel(int timeOut)
        //{
        //    throw new NotImplementedException();
        //}

        private TcpListener acceptor;

        private readonly Dictionary<long, TChannel> idChannels = new Dictionary<long, TChannel>();
    }
}
