using System;
using System.Threading;
using UnityEngine;
using UnityEngine.Networking;

namespace LuaFramework
{

    public class UnityWebPacket
    {

        public string name;


        public string urlPath;


        public string localPath;


        public ulong size;


        public UnityWebRequest Request;


        public UnityWebRequest www;


        public Hash128 hash;


        public int version;


        public int crc;


        public CancellationToken token;


        public Action<float, object> func;
    }
}
