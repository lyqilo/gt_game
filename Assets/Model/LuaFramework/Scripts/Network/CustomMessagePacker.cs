using System;
using System.Runtime.InteropServices;

namespace LuaFramework
{
    public class CustomMessagePacker : IMessagePacker
    {
        public string SerializeToText(object obj)
        {
            throw new NotImplementedException();
        }

        public object DeserializeFrom(Type type, byte[] bytes)
        {
            throw new NotImplementedException();
        }

        public object DeserializeFrom(Type type, byte[] bytes, int index, int count)
        {
            throw new NotImplementedException();
        }

        public T DeserializeFrom<T>(byte[] messageBytes)
        {
            throw new NotImplementedException();
        }

        public T DeserializeFrom<T>(object obj1, object obj2, object obj3)
        {
            byte[] array = (byte[])obj1;
            int num = (int)obj2;
            Session session = (Session)obj3;
            ushort num2 = session.encrypt.CrevasseBuffer(array, (ushort)num);
            Buffer.BlockCopy(array, 0, this.headBytes, 0, this.headBytes.Length);
            Y7ServerDef.CMD_Head cmd_Head = (Y7ServerDef.CMD_Head)this.headBytes.BytesToObject(typeof(Y7ServerDef.CMD_Head));
            byte[] array2 = new byte[(int)num2 - this.headBytes.Length];
            Buffer.BlockCopy(array, this.headBytes.Length, array2, 0, array2.Length);
            bool flag = cmd_Head.CmdInfo.cbVersion > 0;
            if (flag)
            {
                array2 = Compress.DecompressBytes(array2);
            }
            ushort wMainCmdID = cmd_Head.CommandInfo.wMainCmdID;
            ushort wSubCmdID = cmd_Head.CommandInfo.wSubCmdID;
            ushort num3 = (ushort)array2.Length;
            BytesPack bytesPack = new BytesPack((int)wMainCmdID, (int)wSubCmdID, array2, session);
            return (T)((object)bytesPack);
        }

        public T DeserializeFrom<T>(string str)
        {
            throw new NotImplementedException();
        }

        public object DeserializeFrom(Type type, string str)
        {
            throw new NotImplementedException();
        }

        public byte[] DeserializeFrom(byte[] bytes)
        {
            return bytes;
        }

        public T DeserializeFrom<T>(object obj2)
        {
            throw new NotImplementedException();
        }

        public T DeserializeFrom<T>(object obj1, object obj2)
        {
            throw new NotImplementedException();
        }

        public byte[] SerializeToByteArray(object obj)
        {
            throw new NotImplementedException();
        }

        public byte[] SerializeToByteArray(object obj1, object obj2)
        {
            byte[] array = new byte[8192];
            BytesPack bytesPack = (BytesPack)obj1;
            Session session = (Session)obj2;
            this.head.CommandInfo.wMainCmdID = (ushort)bytesPack.mid;
            this.head.CommandInfo.wSubCmdID = (ushort)bytesPack.sid;
            this.head.CmdInfo.cbVersion = 0;
            bool flag = bytesPack.bytes.Length >= 1024;
            if (flag)
            {
                this.head.CmdInfo.cbVersion = 1;
                bytesPack.bytes = Compress.CompressBytes(bytesPack.bytes);
            }
            byte[] array2 = this.head.ObjectToBytes(-1, 0);
            Buffer.BlockCopy(array2, 0, array, 0, array2.Length);
            Buffer.BlockCopy(bytesPack.bytes, 0, array, array2.Length, bytesPack.bytes.Length);
            ushort num = session.encrypt.EncryptBuffer(array, (ushort)((int)this.CmdHeadSize + bytesPack.bytes.Length), (ushort)array.Length);
            byte[] array3 = new byte[(int)num];
            Buffer.BlockCopy(array, 0, array3, 0, (int)num);
            return array3;
        }

        public byte[] SerializeToByteArray(object obj1, object obj2, object obj3)
        {
            throw new NotImplementedException();
        }

        private byte[] headBytes = new byte[Marshal.SizeOf(typeof(Y7ServerDef.CMD_Head))];

        private Y7ServerDef.CMD_Head head = default(Y7ServerDef.CMD_Head);

        private ushort CmdHeadSize = (ushort)Marshal.SizeOf(typeof(Y7ServerDef.CMD_Head));
    }
}