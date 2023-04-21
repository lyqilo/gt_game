using System;
using System.Collections.Generic;
using LuaInterface;
using UnityEngine;

namespace LuaFramework
{
    public class CircularBuffer
    {
        public int ChunkSize = 8192;
        private byte[] lastBuffer;

        private readonly Queue<byte[]> bufferQueue = new Queue<byte[]>();
        private readonly Queue<byte[]> bufferCache = new Queue<byte[]>();

        public int LastIndex { get; set; }
        public int FirstIndex { get; set; }

        public CircularBuffer()
        {
            this.AddLast();
        }

        public int Count
        {
            get
            {
                bool flag = this.bufferQueue.Count == 0;
                int num;
                if (flag)
                {
                    num = 0;
                }
                else
                {
                    num = (this.bufferQueue.Count - 1) * this.ChunkSize + this.LastIndex - this.FirstIndex;
                }
                bool flag2 = num < 0;
                if (flag2)
                {
                    Debug.LogErrorFormat("TBuffer count < 0: {0}, {1}, {2}".Fmt(new object[]
                    {
                        this.bufferQueue.Count,
                        this.LastIndex,
                        this.FirstIndex
                    }));

                }
                return num;
            }
        }

        public void AddLast()
        {
            bool flag = this.bufferCache.Count > 0;
            byte[] item;
            if (flag)
            {
                item = this.bufferCache.Dequeue();
            }
            else
            {
                item = new byte[this.ChunkSize];
            }
            this.bufferQueue.Enqueue(item);
            this.lastBuffer = item;
        }

        public void RemoveFirst()
        {
            this.bufferCache.Enqueue(this.bufferQueue.Dequeue());
        }

        public byte[] First
        {
            get
            {
                bool flag = this.bufferQueue.Count == 0;
                if (flag)
                {
                    this.AddLast();
                }
                return this.bufferQueue.Peek();
            }
        }

        public byte[] Last
        {
            get
            {
                bool flag = this.bufferQueue.Count == 0;
                if (flag)
                {
                    this.AddLast();
                }
                return this.lastBuffer;
            }
        }

        public void RecvFrom(byte[] buffer, int count)
        {
            bool flag = this.Count < count;
            if (flag)
            {
                throw new Exception(string.Format("bufferList size < n, bufferList: {0} buffer length: {1} {2}", this.Count, buffer.Length, count));
            }
            int i = 0;
            while (i < count)
            {
                int num = count - i;
                bool flag2 = this.ChunkSize - this.FirstIndex > num;
                if (flag2)
                {
                    Array.Copy(this.First, this.FirstIndex, buffer, i, num);
                    this.FirstIndex += num;
                    i += num;
                }
                else
                {
                    Array.Copy(this.First, this.FirstIndex, buffer, i, this.ChunkSize - this.FirstIndex);
                    i += this.ChunkSize - this.FirstIndex;
                    this.FirstIndex = 0;
                    this.RemoveFirst();
                }
            }
        }

        public void SendTo(byte[] buffer)
        {
            int i = 0;
            while (i < buffer.Length)
            {
                bool flag = this.LastIndex == this.ChunkSize;
                if (flag)
                {
                    this.AddLast();
                    this.LastIndex = 0;
                }
                int num = buffer.Length - i;
                bool flag2 = this.ChunkSize - this.LastIndex > num;
                if (flag2)
                {
                    Array.Copy(buffer, i, this.lastBuffer, this.LastIndex, num);
                    this.LastIndex += buffer.Length - i;
                    i += num;
                }
                else
                {
                    Array.Copy(buffer, i, this.lastBuffer, this.LastIndex, this.ChunkSize - this.LastIndex);
                    i += this.ChunkSize - this.LastIndex;
                    this.LastIndex = this.ChunkSize;
                }
            }
        }

    }
}
