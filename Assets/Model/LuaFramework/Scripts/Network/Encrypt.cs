
using System;
using System.Text;
using System.Collections;
using System.Security.Cryptography;
using System.Runtime.InteropServices;

namespace LuaFramework
{
    public class Encrypt
    {
        public static string MD5Encrypt(string str)
        {
            string pwd = "";
            MD5 md5 = new MD5CryptoServiceProvider();
            // 加密后是一个字节类型的数组，这里要注意编码UTF8/Unicode等的选择　
            byte[] s = md5.ComputeHash(CommonFunctions.StringToBytes(str));
            // 通过使用循环，将字节类型的数组转换为字符串，此字符串是常规字符格式化所得
            for (int i = 0; i < s.Length; i++)
            {
                string tempPwd = s[i].ToString("x");
                if (tempPwd.Length < 2) tempPwd = "0" + tempPwd;
                pwd = pwd + tempPwd;
            }
            return pwd;
        }



        private byte m_cbSendRound = 0; 
        private byte m_cbRecvRound = 0; 
        private System.UInt32 m_dwSendXorKey = 0; 
        private System.UInt32 m_dwRecvXorKey = 0;
        private System.UInt32 m_dwSendPacketCount = 0; 
        private System.UInt32 m_dwRecvPacketCount = 0; 
        private System.UInt32 g_dwPacketKey = 0xC55CC55C; 

        private static byte[] g_SendByteMap =
    {
        0x70,0x2F,0x40,0x5F,0x44,0x8E,0x6E,0x45,0x7E,0xAB,0x2C,0x1F,0xB4,0xAC,0x9D,0x91,
        0x0D,0x36,0x9B,0x0B,0xD4,0xC4,0x39,0x74,0xBF,0x23,0x16,0x14,0x06,0xEB,0x04,0x3E,
        0x12,0x5C,0x8B,0xBC,0x61,0x63,0xF6,0xA5,0xE1,0x65,0xD8,0xF5,0x5A,0x07,0xF0,0x13,
        0xF2,0x20,0x6B,0x4A,0x24,0x59,0x89,0x64,0xD7,0x42,0x6A,0x5E,0x3D,0x0A,0x77,0xE0,
        0x80,0x27,0xB8,0xC5,0x8C,0x0E,0xFA,0x8A,0xD5,0x29,0x56,0x57,0x6C,0x53,0x67,0x41,
        0xE8,0x00,0x1A,0xCE,0x86,0x83,0xB0,0x22,0x28,0x4D,0x3F,0x26,0x46,0x4F,0x6F,0x2B,
        0x72,0x3A,0xF1,0x8D,0x97,0x95,0x49,0x84,0xE5,0xE3,0x79,0x8F,0x51,0x10,0xA8,0x82,
        0xC6,0xDD,0xFF,0xFC,0xE4,0xCF,0xB3,0x09,0x5D,0xEA,0x9C,0x34,0xF9,0x17,0x9F,0xDA,
        0x87,0xF8,0x15,0x05,0x3C,0xD3,0xA4,0x85,0x2E,0xFB,0xEE,0x47,0x3B,0xEF,0x37,0x7F,
        0x93,0xAF,0x69,0x0C,0x71,0x31,0xDE,0x21,0x75,0xA0,0xAA,0xBA,0x7C,0x38,0x02,0xB7,
        0x81,0x01,0xFD,0xE7,0x1D,0xCC,0xCD,0xBD,0x1B,0x7A,0x2A,0xAD,0x66,0xBE,0x55,0x33,
        0x03,0xDB,0x88,0xB2,0x1E,0x4E,0xB9,0xE6,0xC2,0xF7,0xCB,0x7D,0xC9,0x62,0xC3,0xA6,
        0xDC,0xA7,0x50,0xB5,0x4B,0x94,0xC0,0x92,0x4C,0x11,0x5B,0x78,0xD9,0xB1,0xED,0x19,
        0xE9,0xA1,0x1C,0xB6,0x32,0x99,0xA3,0x76,0x9E,0x7B,0x6D,0x9A,0x30,0xD6,0xA9,0x25,
        0xC7,0xAE,0x96,0x35,0xD0,0xBB,0xD2,0xC8,0xA2,0x08,0xF3,0xD1,0x73,0xF4,0x48,0x2D,
        0x90,0xCA,0xE2,0x58,0xC1,0x18,0x52,0xFE,0xDF,0x68,0x98,0x54,0xEC,0x60,0x43,0x0F
    };

        private static byte[] g_RecvByteMap =
    {
        0x51,0xA1,0x9E,0xB0,0x1E,0x83,0x1C,0x2D,0xE9,0x77,0x3D,0x13,0x93,0x10,0x45,0xFF,
        0x6D,0xC9,0x20,0x2F,0x1B,0x82,0x1A,0x7D,0xF5,0xCF,0x52,0xA8,0xD2,0xA4,0xB4,0x0B,
        0x31,0x97,0x57,0x19,0x34,0xDF,0x5B,0x41,0x58,0x49,0xAA,0x5F,0x0A,0xEF,0x88,0x01,
        0xDC,0x95,0xD4,0xAF,0x7B,0xE3,0x11,0x8E,0x9D,0x16,0x61,0x8C,0x84,0x3C,0x1F,0x5A,
        0x02,0x4F,0x39,0xFE,0x04,0x07,0x5C,0x8B,0xEE,0x66,0x33,0xC4,0xC8,0x59,0xB5,0x5D,
        0xC2,0x6C,0xF6,0x4D,0xFB,0xAE,0x4A,0x4B,0xF3,0x35,0x2C,0xCA,0x21,0x78,0x3B,0x03,
        0xFD,0x24,0xBD,0x25,0x37,0x29,0xAC,0x4E,0xF9,0x92,0x3A,0x32,0x4C,0xDA,0x06,0x5E,
        0x00,0x94,0x60,0xEC,0x17,0x98,0xD7,0x3E,0xCB,0x6A,0xA9,0xD9,0x9C,0xBB,0x08,0x8F,
        0x40,0xA0,0x6F,0x55,0x67,0x87,0x54,0x80,0xB2,0x36,0x47,0x22,0x44,0x63,0x05,0x6B,
        0xF0,0x0F,0xC7,0x90,0xC5,0x65,0xE2,0x64,0xFA,0xD5,0xDB,0x12,0x7A,0x0E,0xD8,0x7E,
        0x99,0xD1,0xE8,0xD6,0x86,0x27,0xBF,0xC1,0x6E,0xDE,0x9A,0x09,0x0D,0xAB,0xE1,0x91,
        0x56,0xCD,0xB3,0x76,0x0C,0xC3,0xD3,0x9F,0x42,0xB6,0x9B,0xE5,0x23,0xA7,0xAD,0x18,
        0xC6,0xF4,0xB8,0xBE,0x15,0x43,0x70,0xE0,0xE7,0xBC,0xF1,0xBA,0xA5,0xA6,0x53,0x75,
        0xE4,0xEB,0xE6,0x85,0x14,0x48,0xDD,0x38,0x2A,0xCC,0x7F,0xB1,0xC0,0x71,0x96,0xF8,
        0x3F,0x28,0xF2,0x69,0x74,0x68,0xB7,0xA3,0x50,0xD0,0x79,0x1D,0xFC,0xCE,0x8A,0x8D,
        0x2E,0x62,0x30,0xEA,0xED,0x2B,0x26,0xB9,0x81,0x7C,0x46,0x89,0x73,0xA2,0xF7,0x72
    };
        public System.UInt16 EncryptBuffer(byte[] cbDataBuffer, System.UInt16 wDataSize, System.UInt16 wBufferSize)
        {
            System.UInt16 wEncryptSize = (System.UInt16)(wDataSize - Marshal.SizeOf(typeof(Y7ServerDef.CMD_Info)));
            System.UInt16 wSnapCount = 0;
            if ((wEncryptSize % sizeof(System.UInt32)) != 0)
            {
                wSnapCount = (System.UInt16)(sizeof(System.UInt32) - wEncryptSize % sizeof(System.UInt32));
            }

            byte cbCheckCode = 0;
            for (System.UInt16 i = (System.UInt16)Marshal.SizeOf(typeof(Y7ServerDef.CMD_Info)); i < wDataSize; i++)
            {
                cbCheckCode += cbDataBuffer[i];
                cbDataBuffer[i] = MapSendByte(cbDataBuffer[i]);
            }

            byte[] headBytes = new byte[Marshal.SizeOf(typeof(Y7ServerDef.CMD_Head))];
            System.Buffer.BlockCopy(cbDataBuffer, 0, headBytes, 0, headBytes.Length);
            Y7ServerDef.CMD_Head pHead = (Y7ServerDef.CMD_Head)CommonFunctions.BytesToObject(headBytes, typeof(Y7ServerDef.CMD_Head));
            pHead.CmdInfo.wPacketSize = wDataSize;
            pHead.CmdInfo.cbCheckCode = (byte)(~cbCheckCode + 1);

            headBytes = CommonFunctions.ObjectToBytes(pHead);
            System.Buffer.BlockCopy(headBytes, 0, cbDataBuffer, 0, headBytes.Length);

            System.UInt32 dwXorKey = m_dwSendXorKey;
            if (m_dwSendPacketCount == 0)
            {
                dwXorKey = (System.UInt32)System.Environment.TickCount; 
                System.Guid guid = System.Guid.NewGuid(); 
                for (int i = 0; i < 4; i++)
                {
                    byte[] dataBytes = new byte[4];
                    System.Buffer.BlockCopy(guid.ToByteArray(), i * 4, dataBytes, 0, 4);
                    System.UInt32 data = (System.UInt32)CommonFunctions.BytesToObject(dataBytes, typeof(System.UInt32));
                    dwXorKey ^= data;
                }

                dwXorKey = SeedRandMap((System.UInt16)dwXorKey);
                dwXorKey |= ((System.UInt32)SeedRandMap((System.UInt16)(dwXorKey >> 16))) << 16;
                dwXorKey ^= g_dwPacketKey;
                m_dwSendXorKey = dwXorKey;
                m_dwRecvXorKey = dwXorKey;
            }

            byte[] seedBytes = new byte[wEncryptSize + wSnapCount];
            System.Buffer.BlockCopy(cbDataBuffer, Marshal.SizeOf(typeof(Y7ServerDef.CMD_Info)), seedBytes, 0, seedBytes.Length);
            System.UInt16 wEncrypCount = (System.UInt16)((wEncryptSize + wSnapCount) / sizeof(System.UInt32));
            for (int i = 0; i < wEncrypCount; i++)
            {
                byte[] uint32Bytes = new byte[4];
                System.Buffer.BlockCopy(seedBytes, i * 4, uint32Bytes, 0, 4);
                System.UInt32 uint32 = (System.UInt32)CommonFunctions.BytesToObject(uint32Bytes, typeof(System.UInt32));
                uint32 ^= dwXorKey;

                uint32Bytes = CommonFunctions.ObjectToBytes(uint32);
                System.Buffer.BlockCopy(uint32Bytes, 0, seedBytes, i * 4, 4);

                byte[] uint16Bytes = new byte[2];
                System.Buffer.BlockCopy(seedBytes, i * 4, uint16Bytes, 0, 2);
                System.UInt16 int16_1 = (System.UInt16)CommonFunctions.BytesToObject(uint16Bytes, typeof(System.UInt16));
                dwXorKey = SeedRandMap(int16_1);

                System.Buffer.BlockCopy(seedBytes, i * 4 + 2, uint16Bytes, 0, 2);
                System.UInt16 int16_2 = (System.UInt16)CommonFunctions.BytesToObject(uint16Bytes, typeof(System.UInt16));
                dwXorKey |= ((System.UInt32)SeedRandMap(int16_2)) << 16;
                dwXorKey ^= g_dwPacketKey;
            }

            System.Buffer.BlockCopy(seedBytes, 0, cbDataBuffer, Marshal.SizeOf(typeof(Y7ServerDef.CMD_Info)), seedBytes.Length);

            if (m_dwSendPacketCount == 0)
            {
                byte[] m_dwSendXorKeyBytes = CommonFunctions.ObjectToBytes(m_dwSendXorKey);


                System.Buffer.BlockCopy(cbDataBuffer, Marshal.SizeOf(typeof(Y7ServerDef.CMD_Head)), cbDataBuffer, Marshal.SizeOf(typeof(Y7ServerDef.CMD_Head)) + 4, wDataSize);

                System.Buffer.BlockCopy(m_dwSendXorKeyBytes, 0, cbDataBuffer, Marshal.SizeOf(typeof(Y7ServerDef.CMD_Head)), 4);
                wDataSize += 4;
            }

            System.Buffer.BlockCopy(cbDataBuffer, 0, headBytes, 0, headBytes.Length);
            pHead = (Y7ServerDef.CMD_Head)CommonFunctions.BytesToObject(headBytes, typeof(Y7ServerDef.CMD_Head));
            pHead.CmdInfo.wPacketSize = wDataSize;
            headBytes = CommonFunctions.ObjectToBytes(pHead);
            System.Buffer.BlockCopy(headBytes, 0, cbDataBuffer, 0, headBytes.Length);

            m_dwSendPacketCount++;
            m_dwSendXorKey = dwXorKey;

            return wDataSize;
        }

        public System.UInt16 CrevasseBuffer(byte[] cbDataBuffer, System.UInt16 wDataSize)
        {
            m_dwRecvPacketCount++;

            System.UInt16 wSnapCount = 0;
            if ((wDataSize % sizeof(System.UInt32)) != 0)
            {
                wSnapCount = (System.UInt16)(sizeof(System.UInt32) - wDataSize % sizeof(System.UInt32));
            }

            System.UInt32 dwXorKey = m_dwRecvXorKey;
            byte[] seedBytes = new byte[wDataSize + wSnapCount - Marshal.SizeOf(typeof(Y7ServerDef.CMD_Info))];
            System.Buffer.BlockCopy(cbDataBuffer, Marshal.SizeOf(typeof(Y7ServerDef.CMD_Info)), seedBytes, 0, seedBytes.Length);
            System.UInt16 wEncrypCount = (System.UInt16)((wDataSize + wSnapCount - Marshal.SizeOf(typeof(Y7ServerDef.CMD_Info))) / 4);
            for (System.UInt16 i = 0; i < wEncrypCount; i++)
            {
                if ((i == (wEncrypCount - 1)) && (wSnapCount > 0))
                {
                    byte[] pcKey = new byte[wSnapCount];
                    byte[] m_dwRecvXorKeyBytes = CommonFunctions.ObjectToBytes(m_dwRecvXorKey);
                    System.Buffer.BlockCopy(m_dwRecvXorKeyBytes, sizeof(System.UInt32) - wSnapCount, pcKey, 0, wSnapCount);
                    System.Buffer.BlockCopy(pcKey, 0, cbDataBuffer, wDataSize, wSnapCount);
                    System.Buffer.BlockCopy(pcKey, 0, seedBytes, seedBytes.Length - wSnapCount, wSnapCount);
                }
                byte[] uint16Bytes = new byte[2];
                System.Buffer.BlockCopy(seedBytes, i * 4, uint16Bytes, 0, 2);
                System.UInt16 int16_1 = (System.UInt16)CommonFunctions.BytesToObject(uint16Bytes, typeof(System.UInt16));
                dwXorKey = SeedRandMap(int16_1);

                System.Buffer.BlockCopy(seedBytes, i * 4 + 2, uint16Bytes, 0, 2);
                System.UInt16 int16_2 = (System.UInt16)CommonFunctions.BytesToObject(uint16Bytes, typeof(System.UInt16));
                dwXorKey |= ((System.UInt32)SeedRandMap(int16_2)) << 16;

                dwXorKey ^= g_dwPacketKey;

                byte[] pdwXorBytes = new byte[4];
                System.Buffer.BlockCopy(seedBytes, i * 4, pdwXorBytes, 0, 4);
                System.UInt32 pdwXor = (System.UInt32)CommonFunctions.BytesToObject(pdwXorBytes, typeof(System.UInt32));
                pdwXor ^= m_dwRecvXorKey;
                pdwXorBytes = CommonFunctions.ObjectToBytes(pdwXor);
                System.Buffer.BlockCopy(pdwXorBytes, 0, seedBytes, i * 4, 4);

                m_dwRecvXorKey = dwXorKey;
            }

            System.Buffer.BlockCopy(seedBytes, 0, cbDataBuffer, Marshal.SizeOf(typeof(Y7ServerDef.CMD_Info)), seedBytes.Length);

            byte[] headBytes = new byte[Marshal.SizeOf(typeof(Y7ServerDef.CMD_Head))];
            System.Buffer.BlockCopy(cbDataBuffer, 0, headBytes, 0, headBytes.Length);
            Y7ServerDef.CMD_Head head = (Y7ServerDef.CMD_Head)CommonFunctions.BytesToObject(headBytes, typeof(Y7ServerDef.CMD_Head));
            byte cbCheckCode = head.CmdInfo.cbCheckCode;
            for (int i = Marshal.SizeOf(typeof(Y7ServerDef.CMD_Info)); i < wDataSize; i++)
            {
                cbDataBuffer[i] = MapRecvByte(cbDataBuffer[i]);
                cbCheckCode += cbDataBuffer[i];
            }

            return wDataSize;
        }

        private byte MapSendByte(byte cbData)
        {
            byte cbMap = g_SendByteMap[(byte)(cbData + m_cbSendRound)];
            m_cbSendRound += 3;
            return cbMap;
        }

        private byte MapRecvByte(byte cbData)
        {
            byte cbMap = (byte)(g_RecvByteMap[cbData] - m_cbRecvRound);
            m_cbRecvRound += 3;
            return cbMap;
        }

        private System.UInt16 SeedRandMap(System.UInt16 wSeed)
        {
            System.UInt32 dwHold = wSeed;
            return (System.UInt16)((dwHold = (System.UInt32)(dwHold * 241103L + 2533101L)) >> 16);
        }
    }
}

