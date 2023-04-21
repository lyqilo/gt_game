using System;
using System.Runtime.InteropServices;

namespace LuaFramework
{
    public static class Y7ServerDef
    {
        public const uint SOCKET_BUFFER = 8192u;

        public const ushort MDM_KN_COMMAND = 0;

        public const ushort SUB_KN_DETECT_SOCKET = 1;

        public const ushort SUB_KN_SHUT_DOWN_SOCKET = 2;

        [StructLayout(LayoutKind.Sequential, Pack = 1)]
        public struct CMD_Info
        {
            public byte cbVersion;

            public byte cbCheckCode;

            public ushort wPacketSize;

            public uint dwReserved;
        }

        [Serializable]
        [StructLayout(LayoutKind.Sequential, Pack = 1)]
        public struct CMD_Command
        {
            public ushort wMainCmdID;

            public ushort wSubCmdID;
        }

        [Serializable]
        [StructLayout(LayoutKind.Sequential, Pack = 1)]
        public struct CMD_Head
        {
            public Y7ServerDef.CMD_Info CmdInfo;

            public Y7ServerDef.CMD_Command CommandInfo;
        }
    }
}
