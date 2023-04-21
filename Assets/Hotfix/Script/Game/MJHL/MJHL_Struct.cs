
using LuaFramework;
using System.Collections.Generic;

namespace Hotfix.MJHL
{
    /// <summary>
    /// 结构体
    /// </summary>
    public class MJHL_Struct
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
        /// 游戏结束
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
            }
            public SC_SceneInfo() { }
            public int nFreeCount;           // 免费次数
            public int nCurrenBet;           // 当前下注
            public int nBetCount;            // 下注列表个数
            public List<int> nBet;           //下注列表
        }

        public class CMD_SC_BetFail
        {
            public CMD_SC_BetFail(ByteBuffer buffer)
            {
                cbResCode = buffer.ReadByte();
            }
            public CMD_SC_BetFail() { }
            public byte cbResCode;	// 0：金币不足 1：下注失败
        }

        public class CMD_3D_SC_Result
        {
            public CMD_3D_SC_Result() { }
            public CMD_3D_SC_Result(ByteBuffer buffer, BytesPack pack)
            {
                tagIconInfo = new List<Round>();

                for (int i = 0; i < MJHL_DataConfig.ALLAcceptMaxCount; i++)
                {
                    Round round;
                    if (tagIconInfo.Count<5)
                    {
                        round = new Round();
                        round.cbIcon = new List<byte>();
                        round.cbHitIcon = new List<byte>();
                        round.cbGoldIconInfo = new List<byte>();
                    }
                    else
                    {
                        round = tagIconInfo[i];
                    }
                    round.cbIcon.Clear();
                    round.cbHitIcon.Clear();
                    round.cbGoldIconInfo.Clear();
                    round.odd = 0;
                    if (tagIconInfo.Count < 5)
                    {
                        tagIconInfo.Add(round);
                    }
                }
                MJHLEntry.Instance.GameData.Index = 0;
                MJHL_Event.DispatchPLAY_Multiple();

                cbTurn = buffer.ReadByte();
                for (int i = 0; i < MJHL_DataConfig.ALLAcceptMaxCount; i++)
                {
                    Round round = tagIconInfo[i];
                    for (int j = 0; j < MJHL_DataConfig.MAX_ALLICON; j++)
                    {
                        round.cbIcon.Add(buffer.ReadByte());
                    }
                    for (int j = 0; j < MJHL_DataConfig.MAX_ALLICON; j++)
                    {
                        round.cbHitIcon.Add(buffer.ReadByte());
                    }
                    for (int j = 0; j < MJHL_DataConfig.MAX_ALLICON; j++)
                    {
                        round.cbGoldIconInfo.Add(buffer.ReadByte());
                    }
                    round.odd = buffer.ReadInt32();
                }

                nMultiple = buffer.ReadInt32();
                nFreeCount = buffer.ReadInt32();
                nWinGold = buffer.ReadInt32();
            }
            public byte cbTurn;     //第几轮
            public List<Round> tagIconInfo;//每一轮的数据
            public int nMultiple;      // 总倍数
            public int nFreeCount;    // 免费次数
            public int nWinGold;     // 赢得金币
        }

        public class Round
        {
            public List<byte> cbIcon;//每轮的图标
            public List<byte> cbHitIcon;// 击中的图标
            public List<byte> cbGoldIconInfo;  //金色的图标
            public int odd;     // 倍数
        }



        #endregion
    }
}
