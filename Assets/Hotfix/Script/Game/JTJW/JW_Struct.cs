
using LuaFramework;
using System.Collections.Generic;

namespace Hotfix.JTJW
{
    /// <summary>
    /// 结构体
    /// </summary>
    public class JW_Struct
    {
        #region REQ
        /// <summary>
        /// 开始游戏
        /// </summary>
        public const ushort SUB_CS_GAME_START = 1;
        #endregion

        #region ACP

        /// <summary>
        /// 启动游戏
        /// </summary>
        public const ushort SUB_SC_GAME_START = 102;

        /// <summary>
        /// 小游戏返回
        /// </summary>
       // public const ushort SUB_SC_SMALL_GAME = 1;
        /// <summary>
        /// 游戏结束
        /// </summary>
        public const ushort SUB_SC_BET_FAIL = 2;
        /// <summary>
        /// 奖池分数
        /// </summary>
       // public const ushort SUB_SC_UPDATE_JACKPOT = 3;
        #endregion

        #region 结构体
        /// <summary>
        /// 开始游戏
        /// </summary>
        public class CMD_3D_CS_StartGame
        {
            public CMD_3D_CS_StartGame()
            {
                ByteBuffer = new ByteBuffer();
            }
            public CMD_3D_CS_StartGame(int bet)
            {
                ByteBuffer = new ByteBuffer();
                nBet = bet;
            }
            public ByteBuffer ByteBuffer { get; set; }
            private int nbet;				// 押注
            public int nBet { get { return nbet; } set { nbet = value; ByteBuffer.WriteInt(nbet); } }
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

                for (int i = 0; i < JW_DataConfig.MAX_BET_COUNT; i++)
                {
                    nBet.Add(buffer.ReadInt32());
                }
                cbRerun = buffer.ReadByte();
            }
            public SC_SceneInfo() { }
            public int nFreeCount;           // 免费次数
            public int nCurrenBet;           // 当前下注
            public int nBetCount;            // 下注列表个数
            public List<int> nBet;             //下注列表
            public byte cbRerun;              // 是否重转

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

        public class CMD_3D_SC_Result
        {
            public CMD_3D_SC_Result() { }
            public CMD_3D_SC_Result(ByteBuffer buffer)
            {
                cbIcon = new List<byte>();
                for (int i = 0; i < JW_DataConfig.MAX_ALLICON; i++)
                {
                    cbIcon.Add(buffer.ReadByte());
                }

                cbHitIcon = new List<byte>();
                for (int i = 0; i < JW_DataConfig.MAX_RAW * JW_DataConfig.MAX_COL; i++)
                {
                    cbHitIcon.Add(0);
                }
                for (int i = 0; i < 25; i++)
                {
                    byte hitCount = buffer.ReadByte();
                    if (hitCount>=3)
                    {
                        for (int j = 0; j < hitCount; j++)
                        {
                            cbHitIcon[JW_DataConfig.Lines[i][j]-1] = 1;
                        }
                    }

                }
                nWinGold = buffer.ReadInt32();
                nFreeCount = buffer.ReadInt32();
                cbRerun = buffer.ReadByte();
                cbDoubleCount = buffer.ReadByte();
                nDouble = new List<int>();
                for (int i = 0; i < JW_DataConfig.MAX_ALLICON; i++)
                {
                    nDouble.Add(buffer.ReadInt32());
                }
            }
            public List<byte> cbIcon;
            public List<byte> cbHitIcon;          // 击中的图标
            public int nWinGold;                             // 赢得金币
            public int nFreeCount;                               // 免费次数
            public byte cbRerun;                                // 重转
            public byte cbDoubleCount;                      // 本次翻倍次数 0不触发翻倍 大于0为翻倍个数
            public List<int> nDouble;					// 值大于零为翻倍倍数
        }
        #endregion
    }
}
