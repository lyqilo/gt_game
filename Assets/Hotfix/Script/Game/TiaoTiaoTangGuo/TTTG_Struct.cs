using System.Collections.Generic;
using Hotfix.TouKui;
using LuaFramework;

namespace Hotfix.TiaoTiaoTangGuo
{
    public class TTTG_Struct
    {
        #region CS

        /// <summary>
        /// 开始游戏
        /// </summary>
        public const int SUB_CS_GAME_START = 1;

        #endregion

        #region SC

        /// <summary>
        /// 启动游戏 
        /// </summary>
        public const int SUB_SC_GAME_START = 0;

        /// <summary>
        /// 游戏结束
        /// </summary>
        public const int SUB_SC_BET_FAIL = 2;

        /// <summary>
        /// 奖池分数
        /// </summary>
        public const int SUB_SC_UPDATE_JACKPOT = 3;

        #endregion

        /// <summary>
        /// 开始游戏
        /// </summary>
        public class StartGame
        {
            /// <summary>
            /// 押注
            /// </summary>
            public int nBet;

            private ByteBuffer buffer;

            public ByteBuffer ByteBuffer
            {
                get
                {
                    buffer?.Close();
                    buffer = new ByteBuffer();
                    buffer.WriteInt(nBet);
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
                nFreeCount = buffer.ReadInt32();
                nCurrenBet = buffer.ReadInt32();
                nBetCount = buffer.ReadInt32();
                nBet = new List<int>();
                for (int i = 0; i < TTTG_DataConfig.MAX_BET_COUNT; i++)
                {
                    nBet.Add(buffer.ReadInt32());
                }

                cbFreeIcon = new List<byte>();
                for (int i = 0; i < TTTG_DataConfig.GI_count; i++)
                {
                    cbFreeIcon.Add(buffer.ReadByte());
                }
            }

            public SC_SceneInfo()
            {
            }

            /// <summary>
            /// 免费次数
            /// </summary>
            public int nFreeCount;

            /// <summary>
            /// 当前下注
            /// </summary>
            public int nCurrenBet;

            /// <summary>
            /// 下注列表个数
            /// </summary>
            public int nBetCount;

            /// <summary>
            /// 下注列表
            /// </summary>
            public List<int> nBet;

            /// <summary>
            /// 免费类型
            /// </summary>
            public List<byte> cbFreeIcon;
        }

        /// <summary>
        /// 下注失败
        /// </summary>
        public class CMD_SC_BetFail
        {
            public CMD_SC_BetFail(ByteBuffer buffer)
            {
                cbResCode = buffer.ReadByte();
            }

            /// <summary>
            /// 1。金币不足，2.下注失败
            /// </summary>
            public byte cbResCode;
        }

        /// <summary>
        /// 游戏结果
        /// </summary>
        public class CMD_3D_SC_Result
        {
            public CMD_3D_SC_Result()
            {
                cbIcon = new List<byte>();
                cbHit = new List<List<byte>>();
            }

            public CMD_3D_SC_Result(ByteBuffer buffer)
            {
                cbIcon = new List<byte>();
                for (int i = 0; i < TTTG_DataConfig.MAX_ICONCOUNT; i++)
                {
                    cbIcon.Add(buffer.ReadByte());
                }

                cbHit = new List<List<byte>>();
                for (int i = 0; i < TTTG_DataConfig.MAX_HITTIMES; i++)
                {
                    List<byte> hitIcon = new List<byte>();
                    for (int j = 0; j < TTTG_DataConfig.MAX_Col * TTTG_DataConfig.MAX_Row; j++)
                    {
                        hitIcon.Add(buffer.ReadByte());
                    }

                    cbHit.Add(hitIcon);
                }

                useIdx = buffer.ReadInt();
                nWinGold = buffer.ReadInt32();
                nFreeCount = buffer.ReadInt32();
                hitTimes = buffer.ReadInt32();
            }

            public List<byte> cbIcon;
            public List<List<byte>> cbHit;
            public int useIdx; // 已使用长度
            public int nWinGold; // 赢得金币
            public int nFreeCount; // 免费次数
            public int hitTimes; // 已命中轮数
        }

        /// <summary>
        /// 彩金
        /// </summary>
        public class CMD_3D_SC_CaiJin
        {
            public CMD_3D_SC_CaiJin(ByteBuffer buffer)
            {
                lCaijin = buffer.ReadInt64();
            }

            public long lCaijin; //彩金变化
        }
    }
}