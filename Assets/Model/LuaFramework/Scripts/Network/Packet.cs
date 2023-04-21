using System.Runtime.InteropServices;

namespace LuaFramework
{
    public struct Packet
    {
        public byte[] bodyBytes { get; set; }

        public int Length { get; set; }

        public byte[] headBytes { get; set; }

        public Packet(int length)
        {
            this.bodyBytes = new byte[length];
            this.Length = 0;
            this.headSize = Marshal.SizeOf(typeof(Y7ServerDef.CMD_Info));
            this.headBytes = new byte[this.headSize];
        }

        public int headSize;
    }
}
