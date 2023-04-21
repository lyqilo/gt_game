using System;
using UnityEngine;

namespace LuaFramework
{
    // Token: 0x02000205 RID: 517
    public class ABPacket
    {
        // Token: 0x040003E4 RID: 996
        public string abName;

        // Token: 0x040003E5 RID: 997
        public string bundleName;

        // Token: 0x040003E6 RID: 998
        public bool crate;

        // Token: 0x040003E7 RID: 999
        public bool show;

        // Token: 0x040003E8 RID: 1000
        public bool isDone;

        // Token: 0x040003E9 RID: 1001
        public bool isBegin;

        // Token: 0x040003EA RID: 1002
        public object callFunc;

        // Token: 0x040003EB RID: 1003
        public GameObject obj;

        // Token: 0x040003EC RID: 1004
        public string hash;

        // Token: 0x040003ED RID: 1005
        public string crc;

        // Token: 0x040003EE RID: 1006
        public int version;

        // Token: 0x040003EF RID: 1007
        public string path;

        // Token: 0x040003F0 RID: 1008
        public LoadAssetType tyep;
    }
}
