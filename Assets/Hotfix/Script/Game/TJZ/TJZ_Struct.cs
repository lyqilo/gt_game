
using LuaFramework;
using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.TJZ
{
    /// <summary>
    /// 结构体
    /// </summary>
    public class TJZ_Struct
    {
        #region REQ
        /// <summary>
        /// 开始游戏
        /// </summary>
        public const ushort SUB_CS_GAME_START = 0;

        #endregion

        #region ACP

        /// <summary>
        /// 启动游戏
        /// </summary>
        public const ushort SUB_SC_GAME_START = 0;
        /// <summary>
        /// 游戏结束
        /// </summary>
        public const ushort SUB_SC_GAME_OVER = 1;
        #endregion

        #region 结构体
        /// <summary>
        /// 开始游戏
        /// </summary>
        public class CMD_3D_CS_StartGame
        {
            private ByteBuffer buffer;
            private int nbet;				// 押注
            public CMD_3D_CS_StartGame()
            {
            }
            public CMD_3D_CS_StartGame(int bet)
            {
                nbet = bet;
            }
            public ByteBuffer ByteBuffer
            {
                get
                {
                    buffer?.Close();
                    buffer = new ByteBuffer();
                    buffer.WriteInt(nbet);
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
                AccuPool = buffer.ReadInt64();
                nBet = new List<int>();
                for (int i = 0; i < TJZ_DataConfig.MAX_BET_COUNT; i++)
                {
                    nBet.Add(buffer.ReadInt32());
                }
                nCurrenBet = buffer.ReadInt32();

                buffer.ReadInt32();//作弊下注限制
                nFreeCount = buffer.ReadByte();

                nSelectImg = new List<byte>();
                for (int i = 0; i < TJZ_DataConfig.MAX_ALLICON; i++)
                {
                    nSelectImg.Add(buffer.ReadByte());
                }
                nCurUpProcess = buffer.ReadByte();
                nUpProcess = buffer.ReadByte();

                byte isretrun = buffer.ReadByte();
                nReturn = isretrun == 1;

                buffer.ReadByte();//历史金币是否超过限制
            }
            public SC_SceneInfo() { }

            public long AccuPool;//当前累积奖池
            public List<int> nBet;//下注列表
            public int nCurrenBet;//断线前下注筹码
            public byte nFreeCount;// 免费次数
            public List<byte> nSelectImg;//
            public byte nCurUpProcess;//当前升级图标进度
            public byte nUpProcess;//下次转动使用图标进度
            public bool nReturn;//是否重转
        }

        public class BellData
        {
            public byte isOpen;
            public long nBellGold;
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
                AccuPool = buffer.ReadInt64();
                AccuGold = buffer.ReadInt64();
                nWinGold = buffer.ReadInt64();
                nWinTypeScore = buffer.ReadInt64();
                nOpenrate = buffer.ReadInt32();
                CheatLimitChip = buffer.ReadInt32();

                cbIcon = new List<byte>();
                for (int i = 0; i < TJZ_DataConfig.MAX_ALLICON; i++)
                {
                    cbIcon.Add(buffer.ReadByte());
                }
                cbHitIcon = new List<byte>();
                for (int i = 0; i < TJZ_DataConfig.ALLLINECOUNT; i++)
                {
                    cbHitIcon.Add(0);
                }
                for (int i = 0; i < TJZ_DataConfig.ALLLINECOUNT; i++)
                {
                    int index = i;
                    int count = 0;
                    for (int j = 0; j < 5; j++)
                    {
                        byte hitCount = buffer.ReadByte();
                        if (hitCount>0)
                        {
                            count++;
                        }
                    }
                    if (count>=3)
                    {
                        cbHitIcon[index] = (byte)count;
                    }
                }

                nAddFreeCnt = buffer.ReadByte();
                nFreeCount = buffer.ReadByte();
                nCurUpProcess = buffer.ReadByte();
                nUpProcess = buffer.ReadByte();
                nMaxWinType = buffer.ReadByte();
                nReturn = buffer.ReadByte() == 1;
                nHisGoldMoreThan= buffer.ReadByte();
                if (TJZEntry.Instance.GameData.isFreeGame || nAddFreeCnt>0)
                {
                    TJZEntry.Instance.GameData.TotalFreeWin += nWinGold;
                }
                else if (nReturn || TJZEntry.Instance.GameData.ReturnNum > 0)
                {
                    TJZEntry.Instance.GameData.ReturnNum += nWinGold;
                }

                if (TJZEntry.Instance.GameData.UpLevel >= 3)
                {
                    for (int i = 0; i < cbIcon.Count; i++)
                    {
                        if (cbIcon[i]==4 && nCurUpProcess >= 3)
                        {
                            cbIcon[i] = 12;
                        }
                        else if (cbIcon[i] == 5 && nCurUpProcess >= 6)
                        {
                            cbIcon[i] = 13;
                        }
                        else if (cbIcon[i] == 6 && nCurUpProcess >= 10)
                        {
                            cbIcon[i] = 14;
                        }
                    }
                }

                TJZEntry.Instance.GameData.UpLevel = nCurUpProcess;

            }

            public long AccuPool;//当前累积奖池
            public long AccuGold;//彩金
            public long nWinGold;//结算金币
            public long nWinTypeScore;//大奖提示的金币
            public int nOpenrate;//倍率
            public int CheatLimitChip;//作弊下注限制
            public List<byte> cbIcon;//图标
            public List<byte> cbHitIcon;// 击中的图标
            public byte nAddFreeCnt;// 免费次数
            public byte nFreeCount;// 免费次数
            public byte nCurUpProcess;//当前升级图标进度
            public byte nUpProcess;//下次转动使用图标进度
            public byte nMaxWinType;//大奖类型
            public bool nReturn;//重转
            public byte nHisGoldMoreThan;//历史金币是否超过限制
        }

        #endregion
    }
}
