using System;
using System.Net.Sockets;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;
using UnityEngine;

namespace QPDefine
{
    
    public class IPv6Support
    {
        
        //[DllImport("__Internal")]
        //private static extern string getIPv6(string mHost, string mPort);

       
       

        private static string GetIPv6(string mHost, string mPort)
        {
            return mHost + "&&ipv4";
        }
       
        public static void getIPType(string serverIp, string serverPorts, out string newServerIp, out AddressFamily mIPType)
        {
            mIPType = AddressFamily.InterNetwork;
            newServerIp = serverIp;
            try
            {
                string ipv = IPv6Support.GetIPv6(serverIp, serverPorts);
                bool flag = !string.IsNullOrEmpty(ipv);
                if (flag)
                {
                    string[] array = Regex.Split(ipv, "&&");
                    bool flag2 = array != null && array.Length >= 2;
                    if (flag2)
                    {
                        string a = array[1];
                        bool flag3 = a == "ipv6";
                        if (flag3)
                        {
                            newServerIp = array[0];
                            mIPType = AddressFamily.InterNetworkV6;
                        }
                    }
                }
            }
            catch (Exception arg)
            {
                Debug.LogError("GetIPv6 error:" + arg);
            }
        }
    }
}
