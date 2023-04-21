using System;
using System.Runtime.InteropServices;
using System.Text;

namespace LuaFramework
{
    public static class ByteHelper
    {
        public static string ToHex(this byte b)
        {
            return b.ToString("X2");
        }

        public static string ToHex(this byte[] bytes)
        {
            StringBuilder stringBuilder = new StringBuilder();
            foreach (byte b in bytes)
            {
                stringBuilder.Append(b.ToString("X2"));
            }
            return stringBuilder.ToString();
        }

        public static string ToHex(this byte[] bytes, string format)
        {
            StringBuilder stringBuilder = new StringBuilder();
            foreach (byte b in bytes)
            {
                stringBuilder.Append(b.ToString(format));
            }
            return stringBuilder.ToString();
        }

        public static string ToHex(this byte[] bytes, int offset, int count)
        {
            StringBuilder stringBuilder = new StringBuilder();
            for (int i = offset; i < offset + count; i++)
            {
                stringBuilder.Append(bytes[i].ToString("X2"));
            }
            return stringBuilder.ToString();
        }

        public static string ToStr(this byte[] bytes)
        {
            return Encoding.Default.GetString(bytes);
        }

        public static string ToStr(this byte[] bytes, int index, int count)
        {
            return Encoding.Default.GetString(bytes, index, count);
        }

        public static string Utf8ToStr(this byte[] bytes)
        {
            return Encoding.UTF8.GetString(bytes);
        }

        public static string Utf8ToStr(this byte[] bytes, int index, int count)
        {
            return Encoding.UTF8.GetString(bytes, index, count);
        }

        public static void WriteTo(this byte[] bytes, int offset, uint num)
        {
            byte[] bytes2 = BitConverter.GetBytes(num);
            for (int i = 0; i < bytes2.Length; i++)
            {
                bytes[offset + i] = bytes2[i];
            }
        }

        public static byte[] ObjectToBytes(this object sendData, int iStartIndex = -1, int iLen = 0)
        {
            int num = Marshal.SizeOf(sendData);
            byte[] array = new byte[num];
            IntPtr intPtr = Marshal.AllocHGlobal(num);
            Marshal.StructureToPtr(sendData, intPtr, false);
            Marshal.Copy(intPtr, array, 0, num);
            Marshal.FreeHGlobal(intPtr);
            bool flag = iStartIndex >= 0 && iLen > 0;
            byte[] result;
            if (flag)
            {
                byte[] array2 = new byte[num - iLen];
                Buffer.BlockCopy(array, 0, array2, 0, iStartIndex);
                Buffer.BlockCopy(array, iStartIndex + iLen, array2, iStartIndex, num - iLen - iStartIndex);
                result = array2;
            }
            else
            {
                result = array;
            }
            return result;
        }

        public static object BytesToObject(this byte[] bytes, Type type)
        {
            IntPtr intPtr = Marshal.AllocHGlobal(bytes.Length);
            Marshal.Copy(bytes, 0, intPtr, bytes.Length);
            object result = Marshal.PtrToStructure(intPtr, type);
            Marshal.FreeHGlobal(intPtr);
            return result;
        }

        public static byte[] Join(this byte[] b1, byte[] b2)
        {
            byte[] array = new byte[b1.Length + b2.Length];
            Buffer.BlockCopy(b1, 0, array, 0, b1.Length);
            Buffer.BlockCopy(b2, 0, array, b1.Length, b2.Length);
            return array;
        }
    }
}
