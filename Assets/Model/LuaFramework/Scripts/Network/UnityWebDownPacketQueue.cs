using System;
using System.Collections.Generic;
using System.IO;

namespace LuaFramework
{
    
    public class UnityWebDownPacketQueue
    {
        
        public UnityWebDownPacketQueue()
        {
            this.paks = new List<UnityWebPacket>();
        }

        
        public void Add(UnityWebPacket pak)
        {
            this.paks.Add(pak);
        }

        
        public void Rmove(UnityWebPacket pak)
        {
            this.paks.Remove(pak);
        }

        
        
        public int Count
        {
            get
            {
                return this.paks.Count;
            }
        }

        
        
        public ulong Size
        {
            get
            {
                bool flag = this.size > 0UL;
                ulong result;
                if (flag)
                {
                    result = this.size;
                }
                else
                {
                    foreach (UnityWebPacket unityWebPacket in this.paks)
                    {
                        bool flag2 = unityWebPacket.size <= 0UL;
                        if (flag2)
                        {
                            FileInfo fileInfo = new FileInfo(unityWebPacket.localPath);
                            unityWebPacket.size = (ulong)fileInfo.Length;
                        }
                        this.size += unityWebPacket.size;
                    }
                    result = this.size;
                }
                return result;
            }
        }

        
        public List<UnityWebPacket> paks;

        
        private ulong size = 0UL;
    }
}
