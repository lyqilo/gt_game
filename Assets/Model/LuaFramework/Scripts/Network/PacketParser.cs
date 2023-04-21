using System;

namespace LuaFramework
{
    internal class PacketParser
    {
        public PacketParser(CircularBuffer buffer)
        {
            this.buffer = buffer;
        }

        public bool Parse()
        {
            bool flag = this.isOK;
            bool result;
            if (flag)
            {
                result = true;
            }
            else
            {
                bool flag2 = false;
                while (!flag2)
                {
                    ParserState parserState = this.state;
                    if (parserState != ParserState.PacketSize)
                    {
                        if (parserState == ParserState.PacketBody)
                        {
                            bool flag3 = this.buffer.Count < this.packet.Length;
                            if (flag3)
                            {
                                flag2 = true;
                            }
                            else
                            {
                                this.buffer.RecvFrom(this.packet.bodyBytes, this.packet.Length);
                                this.packet.Length = (int)this.packetSize;
                                this.isOK = true;
                                this.state = ParserState.PacketSize;
                                flag2 = true;
                            }
                        }
                    }
                    else
                    {
                        bool flag4 = this.buffer.Count < this.packet.headSize;
                        if (flag4)
                        {
                            flag2 = true;
                        }
                        else
                        {
                            this.buffer.RecvFrom(this.packet.headBytes, this.packet.headSize);
                            Y7ServerDef.CMD_Info cmd_Info = (Y7ServerDef.CMD_Info)this.packet.headBytes.BytesToObject(typeof(Y7ServerDef.CMD_Info));
                            this.packetSize = cmd_Info.wPacketSize;
                            this.packet.Length = (int)cmd_Info.wPacketSize - this.packet.headSize;
                            bool flag5 = this.packetSize > 60000;
                            if (flag5)
                            {
                               // Log.Error(string.Format("packet too large, size: {0}", this.packetSize));
                            }
                            this.state = ParserState.PacketBody;
                        }
                    }
                }
                result = this.isOK;
            }
            return result;
        }

        public Packet GetPacket()
        {
            this.isOK = false;
            return this.packet;
        }

        private readonly CircularBuffer buffer;

        private ushort packetSize;

        private ParserState state;

        private Packet packet = new Packet(8192);

        private bool isOK;
    }
}
