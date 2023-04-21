
using LuaFramework;
using System.Collections.Generic;

namespace Hotfix.SG777
{
    /// <summary>
    /// 结构体
    /// </summary>
    public class SG777_Struct
    {
        #region REQ
        /// <summary>
        /// 开始游戏
        /// </summary>
        public const ushort SUB_CS_GAME_START = 0;

        /// <summary>
        /// 请求铃铛
        /// </summary>
        public const ushort SUB_CS_GOLDGAME_START = 1;

        /// <summary>
        /// 获取下注配置
        /// </summary>
        public const ushort SUB_CS_GAME_PEILV = 2;
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
        /// <summary>
        /// 小游戏返回
        /// </summary>
        public const ushort SUB_SC_BELL_GAME = 2;
        /// <summary>
        /// 下注失败
        /// </summary>
        public const ushort SUB_SC_USER_PEILV = 3;
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
        /// 开始铃铛游戏
        /// </summary>
        public class CMD_3D_CS_StartSmallGame
        {
            public CMD_3D_CS_StartSmallGame(int index)
            {
                ByteBuffer = new ByteBuffer();
                nIndex = (byte)index;
            }

            public ByteBuffer ByteBuffer { get; set; }

            private byte nindex;				// 押注
            public byte nIndex { get { return nindex; } set { nindex = value; ByteBuffer.WriteByte(nindex); } }
        }

        /// <summary>
        /// 获得下注配置
        /// </summary>
        public class CMD_3D_CS_GmaePeilv
        {
            public CMD_3D_CS_GmaePeilv()
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
                nCurrenBet = buffer.ReadInt32();
                nBet = new List<int>();
                for (int i = 0; i < SG777_DataConfig.MAX_BET_COUNT; i++)
                {
                    nBet.Add(buffer.ReadInt32());
                }
                nFreeCount = buffer.ReadByte();
                nBellNum = buffer.ReadByte();
                int count=0;
                long allSmallGold = 0;
                nSmallGameData = new List<BellData>();
                for (int i = 0; i < SG777_DataConfig.SmallGameMaxCount; i++)
                {
                    BellData bell = new BellData();
                    bell.isOpen = buffer.ReadByte();
                    bell.nBellGold = buffer.ReadInt64();
                    if (bell.isOpen > 0)
                    {
                        count++;
                        allSmallGold = allSmallGold+ bell.nBellGold;
                    }
                    nSmallGameData.Add(bell);
                }
                nSmallGameCount = SG777_DataConfig.SmallGameMaxCount  - count;
                nSmallGameTatolGold = allSmallGold;
                buffer.ReadInt32();
                buffer.ReadByte();
            }
            public SC_SceneInfo() { }
            public int nCurrenBet; //断线前下注筹码
            public List<int> nBet;           //下注列表
            public byte nFreeCount;              // 免费次数
            public byte nBellNum;    //铃铛次数
            public List<BellData> nSmallGameData;
            public int cheatLimitChip;//作弊下注限制
            public byte hisGoldMoreThan;//历史金币是否超过限制

            public int nSmallGameCount;      //小游戏次数
            public long nSmallGameTatolGold; //小游戏获得总金币
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
                cbIcon = new List<int>();
                for (int i = 0; i < SG777_DataConfig.MAX_ALLICON; i++)
                {
                    cbIcon.Add(buffer.ReadInt32());
                }

                cbHitIcon = new List<byte>();
                for (int i = 0; i < SG777_DataConfig.ALLLINECOUNT; i++)
                {
                    cbHitIcon.Add(0);
                }

                for (int i = 0; i < SG777_DataConfig.ALLLINECOUNT; i++)
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
                nOpenrate= buffer.ReadInt32();
                nFullScreenType = buffer.ReadByte();
                nWinGold = buffer.ReadInt64();
                nFreeCount = buffer.ReadByte();

                if (nFullScreenType==0)
                {
                    nLineWinScore = nWinGold;
                    nAllScreenWinScore = 0;
                }
                else
                {
                    if (cbIcon[0]==0 || cbIcon[0] == 1 || cbIcon[0] == 2)
                    {
                        nLineWinScore = (nWinGold / nOpenrate) * (nOpenrate - SG777_DataConfig.AllScreenRate1);
                        nAllScreenWinScore = nWinGold-nLineWinScore;
                    }
                    else if (cbIcon[0] == 3 || cbIcon[0] == 4 || cbIcon[0] == 5)
                    {
                        nLineWinScore = (nWinGold / nOpenrate) * (nOpenrate - SG777_DataConfig.AllScreenRate2);
                        nAllScreenWinScore = nWinGold - nLineWinScore;
                    }
                    else if (cbIcon[0] == 6 || cbIcon[0] == 7 || cbIcon[0] == 8)
                    {
                        nLineWinScore = (nWinGold / nOpenrate) * (nOpenrate - SG777_DataConfig.AllScreenRate3);
                        nAllScreenWinScore = nWinGold - nLineWinScore;
                    }
                }
                nisSmallGame = buffer.ReadByte();
                if (nisSmallGame>0)
                {
                    nSmallGameCount = 5;
                    nisSmallGame = 1;
                }
                else
                {
                    nSmallGameCount = 0;
                }

                nOpenWild = new List<byte>();
                for (int i = 0; i < 4; i++)
                {
                    nOpenWild.Add(buffer.ReadByte());
                }

                buffer.ReadInt32();
                buffer.ReadByte();
            }
            public List<int> cbIcon;
            public List<byte> cbHitIcon;        // 击中的图标
            public int nOpenrate;               //倍率
            public byte nFullScreenType;        //全屏类型
            public long nLineWinScore;         // 连线金币
            public long nAllScreenWinScore;    // 全屏金币
            public long nWinGold;           // 赢得金币
            public byte nFreeCount;         // 免费次数
            public byte nisSmallGame;       //小游戏
            public byte nSmallGameCount;     //小游戏
            public List<byte> nOpenWild;
        }

        public class CMD_3D_SC_SmallGameResult
        {
            public CMD_3D_SC_SmallGameResult() { }
            public CMD_3D_SC_SmallGameResult(ByteBuffer buffer)
            {
                nWinGold = buffer.ReadInt64();
                nStopIndex = buffer.ReadByte();
                count = buffer.ReadByte();
                nSmallGameCount = SG777_DataConfig.SmallGameMaxCount - count;
                DebugHelper.Log("nSmallGameCount==" + nSmallGameCount);
            }

            private int count;
            public long nWinGold;              // 赢得金币
            public byte nStopIndex;           // 停止图标
            public int nSmallGameCount;      //小游戏次数
        }

        #endregion
    }
}
