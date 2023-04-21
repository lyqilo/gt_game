using System.Net;

namespace LuaFramework
{
    public static class NetworkHelper
    {
        public static IPEndPoint ToIPEndPoint(string host, int port)
        {
            return new IPEndPoint(IPAddress.Parse(host), port);
        }

        public static IPEndPoint ToIPEndPoint(string address)
        {
            int num = address.LastIndexOf(':');
            string host = address.Substring(0, num);
            string s = address.Substring(num + 1);
            int port = int.Parse(s);
            return ToIPEndPoint(host, port);
        }

        public static string Int2IP_LoginServer(uint ipCode)
        {
            byte b = (byte)((ipCode & 4278190080u) >> 24);
            byte b2 = (byte)((ipCode & 16711680u) >> 16);
            byte b3 = (byte)((ipCode & 65280u) >> 8);
            byte b4 = (byte)(ipCode & 255u);
            return string.Format("{0}.{1}.{2}.{3}", new object[]
            {
                b,
                b2,
                b3,
                b4
            });
        }

        public static string Int2IP(uint ipCode)
        {
            byte b = (byte)((ipCode & 4278190080u) >> 24);
            byte b2 = (byte)((ipCode & 16711680u) >> 16);
            byte b3 = (byte)((ipCode & 65280u) >> 8);
            byte b4 = (byte)(ipCode & 255u);
            return string.Format("{3}.{2}.{1}.{0}", new object[]
            {
                b,
                b2,
                b3,
                b4
            });
        }
    }
}
