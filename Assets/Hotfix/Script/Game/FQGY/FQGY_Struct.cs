
using LuaFramework;
using System.Collections.Generic;

namespace Hotfix.FQGY
{
    /// <summary>
    /// 结构体
    /// </summary>
    public class FQGY_Struct
    {
        #region REQ
        /// <summary>
        /// 开始游戏
        /// </summary>
        public const ushort SUB_CS_GAME_START = 1;

        /// <summary>
        /// 开始小游戏
        /// </summary>
        public const ushort SUB_CS_GOLDGAME_START = 2;
        #endregion

        #region ACP

        /// <summary>
        /// 启动游戏
        /// </summary>
        public const ushort SUB_SC_GAME_START = 0;

        /// <summary>
        /// 小游戏返回
        /// </summary>
        public const ushort SUB_SC_GOLD_GAME = 1;
        /// <summary>
        /// 下注失败
        /// </summary>
        public const ushort SUB_SC_BET_FAIL = 2;
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
        /// 开始游戏
        /// </summary>
        public class CMD_3D_CS_StartSmallGame
        {
            public CMD_3D_CS_StartSmallGame()
            {
                ByteBuffer = new ByteBuffer();
            }
            public ByteBuffer ByteBuffer { get; set; }

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

                for (int i = 0; i < nBetCount; i++)
                {
                    nBet.Add(buffer.ReadInt32());
                }
                nSmallGameCount = buffer.ReadInt32();
            }
            public SC_SceneInfo() { }
            public int nFreeCount;              // 免费次数
            public int nCurrenBet;             // 当前下注
            public int nBetCount;             // 下注列表个数
            public List<int> nBet;           //下注列表
            public int nSmallGameCount;      //小游戏次数
            public int nSmallGameTatolGold; //小游戏获得总金币
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
                cbIcon = new List<byte>();
                for (int i = 0; i < FQGY_DataConfig.MAX_ALLICON; i++)
                {
                    cbIcon.Add(buffer.ReadByte());
                }

                cbHitIcon = new List<byte>();
                for (int i = 0; i < FQGY_DataConfig.ALLLINECOUNT; i++)
                {
                    cbHitIcon.Add(0);
                }
                for (int i = 0; i < FQGY_DataConfig.ALLLINECOUNT; i++)
                {
                    byte hitCount = buffer.ReadByte();
                    if (hitCount>=3)
                    {
                        for (int j = 0; j < hitCount; j++)
                        {
                            cbHitIcon[i] = hitCount;
                        }
                    }
                }

                nWinGold = buffer.ReadInt32();
                nFreeCount = buffer.ReadInt32();
                nSmallGameCount = buffer.ReadByte();
                nJackpot = buffer.ReadInt64();
            }
            public List<byte> cbIcon;
            public List<byte> cbHitIcon;        // 击中的图标
            public int nWinGold;               // 赢得金币
            public int nFreeCount;            // 免费次数
            public byte nSmallGameCount;     //小游戏
            public long nJackpot;           //奖池

        }

        public class CMD_3D_SC_SmallGameResult
        {
            public CMD_3D_SC_SmallGameResult() { }
            public CMD_3D_SC_SmallGameResult(ByteBuffer buffer)
            {
                nWinGold = buffer.ReadInt32();
                nStopIndex = buffer.ReadInt32();
                smallGameCount = buffer.ReadInt32();
                nTatolGold = buffer.ReadInt32();
            }

            public int nWinGold;              // 赢得金币
            public int nStopIndex;           // 停止图标
            public int smallGameCount;      //小游戏次数
            public int nTatolGold;         // 本轮总金币

        }


        #endregion
    }
}
