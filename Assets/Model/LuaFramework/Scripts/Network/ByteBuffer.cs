using System;
using System.IO;
using System.Text;

namespace LuaFramework
{
    public class ByteBuffer
    {
        public ByteBuffer()
        {
            this.stream = new MemoryStream();
            this.writer = new BinaryWriter(this.stream);
        }

        public ByteBuffer(byte[] data)
        {
            bool flag = data != null;
            if (flag)
            {
                this.stream = new MemoryStream(data);
                this.reader = new BinaryReader(this.stream, this.EN);
            }
            else
            {
                this.stream = new MemoryStream();
                this.writer = new BinaryWriter(this.stream, this.EN);
            }
        }

        public void Close()
        {
            MemoryStream memoryStream = this.stream;
            if (memoryStream != null)
            {
                memoryStream.Close();
            }

            BinaryWriter binaryWriter = this.writer;
            if (binaryWriter != null)
            {
                binaryWriter.Close();
            }

            BinaryReader binaryReader = this.reader;
            if (binaryReader != null)
            {
                binaryReader.Close();
            }

            this.stream = null;
            this.writer = null;
            this.reader = null;
        }

        public void WriteByte(int v)
        {
            this.writer.Write((byte) v);
        }

        public void WriteInt(int v)
        {
            this.writer.Write(v);
        }

        public void WriteUInt16(ushort v)
        {
            this.writer.Write(v);
        }

        public void WriteUInt32(uint v)
        {
            this.writer.Write(v);
        }

        public void WriteInt16(short v)
        {
            this.writer.Write(v);
        }

        public void WriteShort(ushort v)
        {
            this.writer.Write(v);
        }

        public void WriteLong(long v)
        {
            this.writer.Write(v);
        }

        public void WriteFloat(float v)
        {
            byte[] bytes = BitConverter.GetBytes(v);
            this.writer.Write(BitConverter.ToSingle(bytes, 0));
        }

        public void WriteDouble(double v)
        {
            byte[] bytes = BitConverter.GetBytes(v);
            Array.Reverse(bytes);
            this.writer.Write(BitConverter.ToDouble(bytes, 0));
        }

        public void WriteBytes(byte[] v)
        {
            this.writer.Write(v);
        }

        public void WriteString(string v)
        {
            byte[] bytes = this.EN.GetBytes(v);
            this.writer.Write((ushort) bytes.Length);
            this.writer.Write(bytes);
        }

        public void WriteBytes(uint len, string str)
        {
            bool flag = this.EN == Encoding.Unicode;
            if (flag)
            {
                len *= 2u;
            }

            byte[] bytes = this.EN.GetBytes(str);
            byte[] array = new byte[len];
            Buffer.BlockCopy(bytes, 0, array, 0, bytes.Length);
            this.writer.Write(array);
        }

        public byte ReadByte()
        {
            byte result = this.reader.ReadByte();
            return result;
        }

        public uint[] ReadUInt32s(int len)
        {
            uint[] array = new uint[len];
            for (int i = 0; i < len; i++)
            {
                array[i] = this.reader.ReadUInt32();
            }

            return array;
        }

        public int[] ReadInts(int len)
        {
            int[] array = new int[len];
            for (int i = 0; i < len; i++)
            {
                array[i] = this.reader.ReadInt32();
            }

            return array;
        }

        public int[] ReadInt32s(int len)
        {
            int[] array = new int[len];
            for (int i = 0; i < len; i++)
            {
                array[i] = this.reader.ReadInt32();
            }

            return array;
        }

        public long[] ReadInt64s(int len)
        {
            long[] array = new long[len];
            for (int i = 0; i < len; i++)
            {
                array[i] = this.reader.ReadInt64();
            }

            return array;
        }

        public int ReadInt()
        {
            return this.reader.ReadInt32();
        }

        public int ReadInt32()
        {
            int result = this.reader.ReadInt32();
            return result;
        }

        public ushort ReadUInt16()
        {
            return this.reader.ReadUInt16();
        }

        public uint ReadUInt32()
        {
            return this.reader.ReadUInt32();
        }

        public long ReadInt64()
        {
            return this.reader.ReadInt64();
        }


        public string ReadInt64Str()
        {
            return this.reader.ReadInt64().ToString();
        }

        public long ReadUInt64()
        {
            return (long) this.reader.ReadUInt64();
        }

        public short ReadInt16()
        {
            return this.reader.ReadInt16();
        }

        public ushort ReadShort()
        {
            return (ushort) this.reader.ReadInt16();
        }

        public long ReadLong()
        {
            return this.reader.ReadInt64();
        }

        public float ReadFloat()
        {
            byte[] bytes = BitConverter.GetBytes(this.reader.ReadSingle());
            return BitConverter.ToSingle(bytes, 0);
        }

        public double ReadDouble()
        {
            byte[] bytes = BitConverter.GetBytes(this.reader.ReadDouble());
            Array.Reverse(bytes);
            return BitConverter.ToDouble(bytes, 0);
        }

        public string ReadString()
        {
            ushort num = this.reader.ReadUInt16();
            byte[] bytes = new byte[(int) num];
            bytes = this.reader.ReadBytes((int) num);
            return this.EN.GetString(bytes);
        }

        public string ReadString(int len)
        {
            byte[] bytes = new byte[len];
            bytes = this.reader.ReadBytes(len);
            return this.EN.GetString(bytes);
        }

        public byte[] ReadBytes()
        {
            ushort count = this.ReadUInt16();
            return this.reader.ReadBytes((int) count);
        }

        public byte[] ReadBytes(ushort len)
        {
            return this.reader.ReadBytes((int) len);
        }

        public byte[] ToBytes()
        {
            this.writer.Flush();
            return this.stream.ToArray();
        }

        public void Flush()
        {
            this.writer.Flush();
        }

        private MemoryStream stream = null;

        private BinaryWriter writer = null;

        private BinaryReader reader = null;

        private Encoding EN = Encoding.Unicode;
    }
}