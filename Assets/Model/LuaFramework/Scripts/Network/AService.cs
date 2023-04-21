using System;
using System.Net;
using System.Net.Sockets;
using System.Threading.Tasks;

namespace LuaFramework
{
    public abstract class AService : IDisposable
    {
        public abstract AChannel GetChannel(long id);

        public abstract Task<AChannel> AcceptChannel(int timeOut);

        public abstract AChannel ConnectChannel(IPEndPoint ipEndPoint, int timeOut, AddressFamily addressFamily, Session session);

        public abstract void Remove(long channelId);

        public abstract void Update();

        public abstract void Dispose();
    }
}
