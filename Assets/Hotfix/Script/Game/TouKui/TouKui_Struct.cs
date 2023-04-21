
using LuaFramework;
using System.Collections.Generic;

namespace Hotfix.TouKui
{
    /// <summary>
    /// 结构体
    /// </summary>
    public class TouKui_Struct
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
        public const ushort SUB_SC_GAME_START = 0;

        /// <summary>
        /// 小游戏返回
        /// </summary>
        public const ushort SUB_SC_SMALL_GAME = 1;
        /// <summary>
        /// 游戏结束
        /// </summary>
        public const ushort SUB_SC_BET_FAIL = 2;
        /// <summary>
        /// 奖池分数
        /// </summary>
        public const ushort SUB_SC_UPDATE_JACKPOT = 3;
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
                for (int i = 0; i < TouKui_DataConfig.MAX_BET_COUNT; i++)
                {
                    nBet.Add(buffer.ReadInt32());
                }
                nFreeType = buffer.ReadInt32();
                nExtOdd = buffer.ReadInt32();
                nStartRow = buffer.ReadInt32();
                nStartCol = buffer.ReadInt32();
                cbType = buffer.ReadByte();
                nExtWildCount = buffer.ReadInt32();
                cbFixed = new List<byte>();
                for (int i = 0; i < TouKui_DataConfig.MAX_ALLICON; i++)
                {
                    cbFixed.Add(buffer.ReadByte());
                }
            }
            public SC_SceneInfo() { }
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
            public int nFreeType;
            /// <summary>
            /// 额外倍数
            /// </summary>
            public int nExtOdd;
            /// <summary>
            /// 浮动起始行
            /// </summary>
            public int nStartRow;
            /// <summary>
            /// 浮动起始列
            /// </summary>
            public int nStartCol;
            /// <summary>
            /// 浮动类型
            /// </summary>
            public byte cbType;
            /// <summary>
            /// 浮动当前爱心数量
            /// </summary>
            public int nExtWildCount;
            /// <summary>
            /// 固定wild
            /// </summary>
            public List<byte> cbFixed;
        }

        public class CMD_SC_BetFail
        {
            public CMD_SC_BetFail(ByteBuffer buffer)
            {
                cbResCode = buffer.ReadByte();
            }
            public CMD_SC_BetFail() { }
            /// <summary>
            /// 错误码 1：金币不足 2：下注失败
            /// </summary>
            public byte cbResCode;
        }

        public class CMD_3D_SC_Result
        {
            public CMD_3D_SC_Result() { }
            public CMD_3D_SC_Result(ByteBuffer buffer)
            {
                cbIcon = new List<byte>();
                for (int i = 0; i < TouKui_DataConfig.MAX_ALLICON; i++)
                {
                    cbIcon.Add(buffer.ReadByte());
                }
                cbHitIcon = new List<List<byte>>();
                for (int i = 0; i < TouKui_DataConfig.ALLLINECOUNT; i++)
                {
                    List<byte> col = new List<byte>();
                    for (int j = 0; j < TouKui_DataConfig.MAX_COL; j++)
                    {
                        col.Add(buffer.ReadByte());
                    }
                    cbHitIcon.Add(col);
                }
                nWinGold = buffer.ReadInt32();
                nFreeCount = buffer.ReadInt32();
                nFreeType = buffer.ReadInt32();
                nNolmalFreeType = buffer.ReadInt32();
                nExtOdd = buffer.ReadInt32();
                nStartRow = buffer.ReadInt32();
                nStartCol = buffer.ReadInt32();
                cbType = buffer.ReadByte();
                nExtWildCount = buffer.ReadInt32();
                cbFixed = new List<byte>();
                for (int i = 0; i < TouKui_DataConfig.MAX_ALLICON; i++)
                {
                    cbFixed.Add(buffer.ReadByte());
                }
            }
            /// <summary>
            /// 结果图标
            /// </summary>
            public List<byte> cbIcon;
            /// <summary>
            /// 击中的图标
            /// </summary>
            public List<List<byte>> cbHitIcon;
            /// <summary>
            /// 赢得金币
            /// </summary>
            public int nWinGold;
            /// <summary>
            /// 免费次数
            /// </summary>
            public int nFreeCount;
            /// <summary>
            /// 免费类型（1：扩散 2：固定 3：倍数 4：浮动）
            /// </summary>
            public int nFreeType;
            /// <summary>
            /// 普通免费游戏类型（1：扩散 2：固定 3：倍数 4：浮动）
            /// </summary>
            public int nNolmalFreeType;
            /// <summary>
            /// 额外倍数
            /// </summary>
            public int nExtOdd;
            /// <summary>
            /// 浮动起始行
            /// </summary>
            public int nStartRow;
            /// <summary>
            /// 浮动起始列
            /// </summary>
            public int nStartCol;
            /// <summary>
            /// 浮动类型
            /// </summary>
            public byte cbType;
            /// <summary>
            /// 浮动当前爱心数量
            /// </summary>
            public int nExtWildCount;
            /// <summary>
            /// 固定wild
            /// </summary>
            public List<byte> cbFixed;
        }
        #endregion
    }
}
