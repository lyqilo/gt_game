using System;
using System.IO;
using zlib;

namespace LuaFramework
{
    public class Compress
    {
        public static byte[] CompressBytes(byte[] SourceByte)
        {
            MemoryStream input = new MemoryStream(SourceByte);
            MemoryStream memoryStream = new MemoryStream();
            ZOutputStream zoutputStream = new ZOutputStream(memoryStream, -1);
            Compress.CopyStream(input, zoutputStream);
            zoutputStream.finish();
            byte[] array = new byte[memoryStream.Length];
            memoryStream.Position = 0L;
            memoryStream.Read(array, 0, array.Length);
            return array;
        }

        public static byte[] DecompressBytes(byte[] SourceByte)
        {
            MemoryStream input = new MemoryStream(SourceByte);
            MemoryStream memoryStream = new MemoryStream();
            ZOutputStream zoutputStream = new ZOutputStream(memoryStream);
            Compress.CopyStream(input, zoutputStream);
            zoutputStream.finish();
            byte[] array = new byte[memoryStream.Length];
            memoryStream.Position = 0L;
            memoryStream.Read(array, 0, array.Length);
            return array;
        }

        public static void CopyStream(Stream input, Stream output)
        {
            byte[] buffer = new byte[2000];
            int count;
            while ((count = input.Read(buffer, 0, 2000)) > 0)
            {
                output.Write(buffer, 0, count);
            }
            output.Flush();
        }
    }
}
