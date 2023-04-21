
using LuaFramework;
using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.YGBH
{
    /// <summary>
    /// 结构体
    /// </summary>
    public class YGBH_Struct
    {
        #region REQ
        /// <summary>
        /// 开始游戏
        /// </summary>
        public const ushort SUB_CS_GAME_START = 1;

        /// <summary>
        /// 选择免费游戏类型
        /// </summary>
        public const ushort SUB_CS_CHOSE_FREEGAME_TYPE = 8;

        /// <summary>
        /// 开始小游戏
        /// </summary>
        public const ushort SUB_CS_LITTLE_GAME = 9;
        #endregion

        #region ACP

        /// <summary>
        /// 下注失败
        /// </summary>
        public const ushort SUB_SC_BET_FAIL = 2;
        /// <summary>
        /// 游戏结算
        /// </summary>
        public const ushort SUB_SC_RESULTS_INFO = 3;

        /// <summary>
        /// 小游戏数据
        /// </summary>
        public const ushort SUB_SC_SMALLGAME = 11;

        /// <summary>
        /// 小游戏结果
        /// </summary>
        public const ushort SUB_SC_SMALLGAMEEND = 12;
        #endregion

        #region 结构体
        /// <summary>
        /// 开始游戏
        /// </summary>
        public class CMD_3D_CS_StartGame
        {
            private ByteBuffer buffer;
            private uint nbet;				// 押注
            private uint linecount;
            public CMD_3D_CS_StartGame()
            {
            }
            public CMD_3D_CS_StartGame(int bet,int lineCount)
            {
                nbet = (uint)bet;
                linecount = (uint)lineCount;
            }
            public ByteBuffer ByteBuffer
            {
                get
                {
                    buffer?.Close();
                    buffer = new ByteBuffer();
                    buffer.WriteUInt32(linecount);
                    buffer.WriteUInt32(nbet);
                    return buffer;
                }
            }
        }


        /// <summary>
        /// 场景消息
        /// </summary>
        public class SC_SceneInfo
        {
            public SC_SceneInfo(ByteBuffer buffer)
            {
                freeNumber = buffer.ReadInt32();
                bet = buffer.ReadInt32();
                nGainPeilv = buffer.ReadInt32();
                nBetonCount = buffer.ReadInt32();
                chipList = new List<int>();
                for (int i = 0; i < YGBH_DataConfig.MAX_BET_COUNT; i++)
                {
                    chipList.Add(buffer.ReadInt32());
                }
                nFreeIcon_lie = new List<byte>();
                for (int i = 0; i < YGBH_DataConfig.MAX_COL; i++)
                {
                    nFreeIcon_lie.Add(buffer.ReadByte());
                }
                nFreeType= buffer.ReadInt32();

                smallGameTrack = new List<int>();
                for (int i = 0; i < YGBH_DataConfig.SMALLCHECKNUM; i++)
                {
                    smallGameTrack.Add(buffer.ReadInt32());
                }
            }
            public SC_SceneInfo() { }
            public int freeNumber;// 免费次数
            public int bet;//断线前下注筹码
            public int nGainPeilv;//
            public int nBetonCount;//
            public List<int> chipList;//下注列表
            public List<byte> nFreeIcon_lie;//
            public int nFreeType;//免费类型
            public List<int> smallGameTrack;//下注列表
        }


        public class CMD_SC_BetFail
        {
            public CMD_SC_BetFail(ByteBuffer buffer)
            {
                cbResCode = buffer.ReadByte();
            }
            public CMD_SC_BetFail() { }
            public byte cbResCode;	// 1：金币不足 2：下注失败
        }

        /// <summary>
        /// 游戏消息
        /// </summary>
        public class CMD_3D_SC_Result
        {
            public CMD_3D_SC_Result() { }
            public CMD_3D_SC_Result(ByteBuffer buffer)
            {
                ImgTable = new List<byte>();
                for (int i = 0; i < YGBH_DataConfig.MAX_ALLICON; i++)
                {
                    ImgTable.Add(buffer.ReadByte());
                }
                LineTypeTable = new List<List<byte>>();
                for (int i = 0; i < YGBH_DataConfig.ALLLINECOUNT; i++)
                {
                    List<byte> data = new List<byte>();
                    for (int j = 0; j < YGBH_DataConfig.MAX_COL; j++)
                    {
                        data.Add(buffer.ReadByte());
                    }
                    LineTypeTable.Add(data);
                }
                m_nWinPeiLv = buffer.ReadInt32();
                m_szCurrGold = buffer.ReadInt64();
                WinScore = buffer.ReadInt32();
                m_nTotalWinGold = buffer.ReadInt32();
                m_nSmallGame = buffer.ReadInt32();
                FreeCount = buffer.ReadInt32();
                m_nPrizePoolGold = buffer.ReadInt32();
                m_nMultiple = buffer.ReadInt32();
                m_nPrizePoolPercentMax = buffer.ReadInt32();
                m_nSmallNnm = buffer.ReadInt32();
                m_nTotalFreeTimes = buffer.ReadInt32();
                m_nPrizePoolWildGold = buffer.ReadInt32();
                m_FreeType = buffer.ReadByte();
                YGBHEntry.Instance.GameData.m_FreeType = (uint)m_FreeType;
                m_nIconLie = new List<byte>();
                for (int i = 0; i < YGBH_DataConfig.MAX_COL; i++)
                {
                    m_nIconLie.Add(buffer.ReadByte());
                }
            }
            public List<byte> ImgTable;//图标
            public List<List<byte>> LineTypeTable;// 击中的图标
            public int m_nWinPeiLv;
            public long m_szCurrGold; 
            public int WinScore; 
            public int m_nTotalWinGold;
            public int FreeCount;
            public int m_nSmallGame;
            public int m_nPrizePoolGold;
            public int m_nMultiple;
            public int m_nPrizePoolPercentMax;
            public int m_nSmallNnm;
            public int m_nTotalFreeTimes;
            public int m_nPrizePoolWildGold;
            public byte m_FreeType;
            public List<byte> m_nIconLie;
        }

        /// <summary>
        /// 小游戏数据
        /// </summary>
        public class CMD_3D_SC_SmallResult
        {
            public CMD_3D_SC_SmallResult() { }
            public CMD_3D_SC_SmallResult(ByteBuffer buffer)
            {
                YGBHEntry.Instance.GameData.SceneData.smallGameTrack.Clear();
                smallGameTrack = new List<int>();
                int count = 0;
                for (int i = 0; i < 8; i++)
                {
                    int isnew = buffer.ReadInt32();

                    if (isnew!=0)
                    {
                        count++;
                    }
                    smallGameTrack.Add(isnew);
                }
                if (count>YGBHEntry.Instance.smallSPCount)
                {
                    YGBHEntry.Instance.GameData.hasNewSP = true;
                    YGBHEntry.Instance.smallSPCount = count;
                }
                YGBHEntry.Instance.GameData.SceneData.smallGameTrack = smallGameTrack;
            }
            public List<int> smallGameTrack;
        }

        /// <summary>
        /// 小游戏结果
        /// </summary>
        public class CMD_3D_SC_SmallEnd
        {
            public CMD_3D_SC_SmallEnd() { }
            public CMD_3D_SC_SmallEnd(ByteBuffer buffer)
            {
                nIndex = buffer.ReadByte();
                nGold = buffer.ReadInt32();
                YGBHEntry.Instance.GameData.smallWinIndex = nIndex;
            }
            public byte nIndex;
            public int nGold;
        }

        #endregion
    }
}
