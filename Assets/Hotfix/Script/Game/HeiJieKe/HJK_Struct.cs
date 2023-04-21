using System.Collections.Generic;
using LuaFramework;

namespace Hotfix.HeiJieKe
{
    public class HJK_Struct
    {
        public class ServerPlayerData
        {
            public ServerPlayerData()
            {
                m_iChip = new List<int>();
                m_iChipList = new List<int>();
                m_byPokerData = new List<byte>();
                m_byPokerCount = new List<byte>();
                m_bSurrender = new List<byte>();
                m_bHasOperatePoker = new List<byte>();
            }

            public ServerPlayerData(ByteBuffer buffer)
            {
                m_iChip = new List<int>();
                m_iChipList = new List<int>();
                m_byPokerData = new List<byte>();
                m_byPokerCount = new List<byte>();
                m_bSurrender = new List<byte>();
                m_bHasOperatePoker = new List<byte>();
                for (int i = 0; i < HJK_DataConfig.GAME_PLAYER; i++)
                {
                    m_iChip.Add(buffer.ReadInt32());
                }

                for (int i = 0; i < HJK_DataConfig.C_SPLIT_POKER_COUNT; i++)
                {
                    m_iChipList.Add(buffer.ReadInt32());
                }

                m_byGroupIndex = buffer.ReadByte();
                m_byGroupCount = buffer.ReadByte();
                for (int i = 0; i < HJK_DataConfig.C_SPLIT_POKER_COUNT*HJK_DataConfig.C_GROUP_MAX_POKER_COUNT; i++)
                {
                    m_byPokerData.Add(buffer.ReadByte());
                }

                for (int i = 0; i < HJK_DataConfig.C_SPLIT_POKER_COUNT; i++)
                {
                    m_byPokerCount.Add(buffer.ReadByte());
                }
                for (int i = 0; i < HJK_DataConfig.C_SPLIT_POKER_COUNT; i++)
                {
                    m_bSurrender.Add(buffer.ReadByte());
                }

                m_bInsurance = buffer.ReadByte() != 0;
                m_bPlaying = buffer.ReadByte() != 0;
                for (int i = 0; i < HJK_DataConfig.C_SPLIT_POKER_COUNT; i++)
                {
                    m_bHasOperatePoker.Add(buffer.ReadByte());
                }

                m_byNotChipCount = buffer.ReadByte();
                m_enPlayerOperateState = buffer.ReadInt32();
            }

            public List<int> m_iChip; //下注
            public List<int> m_iChipList; //下注列表
            public byte m_byGroupIndex; //组索引
            public byte m_byGroupCount; //组数量
            public List<byte> m_byPokerData; //扑克数据
            public List<byte> m_byPokerCount; //扑克数量
            public List<byte> m_bSurrender; //是否投降
            public bool m_bInsurance; //是否购买保险
            public bool m_bPlaying; //是否游戏中
            public List<byte> m_bHasOperatePoker; //是否已经操作扑克
            public byte m_byNotChipCount; //不下注次数
            public int m_enPlayerOperateState; //玩家操作状态
        }

        public class CMD_SC_GAME_FREE
        {
            public CMD_SC_GAME_FREE(ByteBuffer buffer)
            {
                lCellScore = buffer.ReadInt32();
                cbSetCellStatus = buffer.ReadByte();
                byCurrentOperateChairID = buffer.ReadByte();
                gameRunState = buffer.ReadInt32();
                zjOperateState = buffer.ReadInt32();
                iLeftTime = buffer.ReadInt32();
                iChip = new List<int>();
                serverPlayerData = new List<ServerPlayerData>();
                historyScore = new List<HistoryScore>();
                for (int i = 0; i < HJK_DataConfig.GAME_PLAYER; i++)
                {
                    iChip.Add(buffer.ReadInt32());
                }

                for (int i = 0; i <= HJK_DataConfig.GAME_PLAYER; i++)
                {
                    serverPlayerData.Add(new ServerPlayerData(buffer));
                }

                for (int i = 0; i < HJK_DataConfig.GAME_PLAYER; i++)
                {
                    historyScore.Add(new HistoryScore(buffer));
                }
            }

            public CMD_SC_GAME_FREE()
            {
                iChip = new List<int>();
                serverPlayerData = new List<ServerPlayerData>();
                historyScore = new List<HistoryScore>();
            }

            public int lCellScore = 0; //基础积分
            public byte cbSetCellStatus = 0; //自由场状态
            public byte byCurrentOperateChairID = 0; //当前操作座位号
            public int gameRunState = 0; //游戏运行状态
            public int zjOperateState = 0; //庄家操作状态
            public int iLeftTime = 0; //下注剩余时间
            public List<int> iChip; //下注值
            public List<ServerPlayerData> serverPlayerData; //玩家数据
            public List<HistoryScore> historyScore; //成绩
        }

        /// <summary>
        /// 玩家下注
        /// </summary>
        public class CMD_SC_PLAYER_CHIP
        {
            public CMD_SC_PLAYER_CHIP(ByteBuffer buffer)
            {
                bet = buffer.ReadInt32();
                chairId = buffer.ReadByte();
                betType = buffer.ReadByte();
            }

            public CMD_SC_PLAYER_CHIP()
            {
            }

            public int bet;
            public byte chairId;
            public byte betType;
        }

        /// <summary>
        /// 牌数据
        /// </summary>
        public class PokerData
        {
            public PokerData(ByteBuffer buffer)
            {
                poker1 = buffer.ReadByte();
                poker2 = buffer.ReadByte();
            }

            public PokerData()
            {
            }

            public byte poker1;
            public byte poker2;
        }

        /// <summary>
        /// 发牌
        /// </summary>
        public class CMD_SC_SEND_POKER
        {
            public CMD_SC_SEND_POKER(ByteBuffer buffer)
            {
                pokerData = new List<PokerData>();
                chipTypes = new List<List<byte>>();
                tabWins = new List<List<byte>>();
                for (int i = 0; i <= HJK_DataConfig.GAME_PLAYER; i++)
                {
                    pokerData.Add(new PokerData(buffer));
                }

                for (int i = 0; i < HJK_DataConfig.GAME_PLAYER; i++)
                {
                    List<byte> tabType = new List<byte>();
                    for (int j = 0; j < HJK_DataConfig.Chip13Area; j++)
                    {
                        tabType.Add(buffer.ReadByte());
                    }

                    chipTypes.Add(tabType);
                }

                for (int i = 0; i < HJK_DataConfig.GAME_PLAYER; i++)
                {
                    List<byte> tabWin = new List<byte>();
                    for (int j = 0; j < HJK_DataConfig.Chip13Area; j++)
                    {
                        tabWin.Add(buffer.ReadByte());
                    }

                    tabWins.Add(tabWin);
                }
            }

            public CMD_SC_SEND_POKER()
            {
                pokerData = new List<PokerData>();
                chipTypes = new List<List<byte>>();
                tabWins = new List<List<byte>>();
            }

            public List<PokerData> pokerData;
            public List<List<byte>> chipTypes;
            public List<List<byte>> tabWins;
        }

        /// <summary>
        /// 玩家保险
        /// </summary>
        public class CMD_SC_PLAYER_INSURANCE
        {
            public CMD_SC_PLAYER_INSURANCE(ByteBuffer buffer)
            {
                chairId = buffer.ReadByte();
                isBuy = buffer.ReadByte() != 0;
            }

            public CMD_SC_PLAYER_INSURANCE()
            {
            }

            public byte chairId;
            public bool isBuy;
        }

        /// <summary>
        /// 查看庄家是否黑杰克
        /// </summary>
        public class CMD_SC_LOOK_ZJ_BLAKC_JACK
        {
            public CMD_SC_LOOK_ZJ_BLAKC_JACK(ByteBuffer buffer)
            {
                isBankerHJK = buffer.ReadByte();
                poker = buffer.ReadByte();
            }

            public CMD_SC_LOOK_ZJ_BLAKC_JACK()
            {
            }

            public byte isBankerHJK;
            public byte poker;
        }

        /// <summary>
        /// 普通操作
        /// </summary>
        public class CMD_SC_NORMAL_OPERATE
        {
            public CMD_SC_NORMAL_OPERATE(ByteBuffer buffer)
            {
                chairId = buffer.ReadByte();
                isSplit = buffer.ReadByte() != 0;
            }

            public CMD_SC_NORMAL_OPERATE()
            {
            }

            public byte chairId;
            public bool isSplit;
        }

        /// <summary>
        /// 玩家普通操作
        /// </summary>
        public class CMD_SC_PLAYER_NORMAL_OPERATE
        {
            public CMD_SC_PLAYER_NORMAL_OPERATE(ByteBuffer buffer)
            {
                operate = buffer.ReadInt32();
                poker1 = buffer.ReadByte();
                poker2 = buffer.ReadByte();
                chairId = buffer.ReadByte();
                isBroken = buffer.ReadByte() != 0;
                is21Point = buffer.ReadByte() != 0;
                isStop = buffer.ReadByte() != 0;
            }

            public CMD_SC_PLAYER_NORMAL_OPERATE()
            {
            }

            public int operate;
            public byte poker1;
            public byte poker2;
            public byte chairId;
            public bool isBroken;
            public bool is21Point;
            public bool isStop;
        }

        /// <summary>
        /// 查看庄家第二张牌
        /// </summary>
        public class CMD_SC_LOOK_ZJ_SECOND_POKER
        {
            public CMD_SC_LOOK_ZJ_SECOND_POKER(ByteBuffer buffer)
            {
                poker = buffer.ReadByte();
            }

            public CMD_SC_LOOK_ZJ_SECOND_POKER()
            {
            }

            public byte poker;
        }

        /// <summary>
        /// 新玩家在下注状态时进入
        /// </summary>
        public class CMD_SC_NEW_PLAYER_ENTER_AT_CHIP
        {
            public CMD_SC_NEW_PLAYER_ENTER_AT_CHIP(ByteBuffer buffer)
            {
                chairId = buffer.ReadByte();
            }

            public CMD_SC_NEW_PLAYER_ENTER_AT_CHIP()
            {
            }

            public byte chairId;
        }

        public class GameResult
        {
            public GameResult(ByteBuffer buffer)
            {
                bPlayerWin = buffer.ReadInt32();
                bBlackJack = buffer.ReadByte() != 0;
                bDragon = buffer.ReadByte() != 0;
                iWinGameGold = buffer.ReadInt32();
            }

            public GameResult()
            {
            }

            public int bPlayerWin; //玩家输赢
            public bool bBlackJack; //是否黑杰克
            public bool bDragon; //是否龙
            public int iWinGameGold; //赢的游戏金币
        }

        public class HistoryScore
        {
            public HistoryScore(ByteBuffer buffer)
            {
                bValid = buffer.ReadByte();
                byChairID = buffer.ReadByte();
                iLastWinGameGold = buffer.ReadInt32();
                iTotalWinGameGold = buffer.ReadInt32();
            }

            public HistoryScore()
            {
            }

            public byte bValid; //是否有效
            public byte byChairID; //座位号
            public int iLastWinGameGold; //上轮成绩
            public int iTotalWinGameGold; //总成绩
        }

        /// <summary>
        /// 游戏结束
        /// </summary>
        public class CMD_SC_GAME_END
        {
            public CMD_SC_GAME_END(ByteBuffer buffer)
            {
                gameEndType = buffer.ReadInt32();
                gameResult = new List<GameResult>();
                historyScore = new List<HistoryScore>();
                for (int i = 0; i < HJK_DataConfig.GAME_PLAYER * HJK_DataConfig.C_SPLIT_POKER_COUNT; i++)
                {
                    gameResult.Add(new GameResult(buffer));
                }

                for (int i = 0; i < HJK_DataConfig.GAME_PLAYER; i++)
                {
                    historyScore.Add(new HistoryScore(buffer));
                }
            }

            public CMD_SC_GAME_END()
            {
                gameResult = new List<GameResult>();
                historyScore = new List<HistoryScore>();
            }

            public int gameEndType;
            public List<GameResult> gameResult;
            public List<HistoryScore> historyScore;
        }

        /// <summary>
        /// 下注列表
        /// </summary>
        public class CMD_SC_CHIP_LIST
        {
            public CMD_SC_CHIP_LIST(ByteBuffer buffer)
            {
                chipList = new List<int>();
                for (int i = 0; i < 4; i++)
                {
                    chipList.Add(buffer.ReadInt32());
                }
            }

            public CMD_SC_CHIP_LIST()
            {
                chipList = new List<int>();
            }

            public List<int> chipList;
        }

        /// <summary>
        /// 停止下注
        /// </summary>
        public class CMD_SC_STOP_CHIP
        {
            public CMD_SC_STOP_CHIP(ByteBuffer buffer)
            {
                chairId = buffer.ReadByte();
            }

            public CMD_SC_STOP_CHIP()
            {
            }

            public byte chairId;
        }

        /// <summary>
        /// 下注错误
        /// </summary>
        public class SUB_SC_CHIP_ERROR
        {
            public SUB_SC_CHIP_ERROR(ByteBuffer buffer, int length)
            {
                error = buffer.ReadString(length);
            }

            public SUB_SC_CHIP_ERROR()
            {
            }

            public string error;
        }
        
        /// <summary>
        /// 玩家普通操作
        /// </summary>
        public class CMD_CS_PLAYER_NORMAL_OPERATE
        {
            public CMD_CS_PLAYER_NORMAL_OPERATE()
            {
                
            }

            private ByteBuffer _buffer;
            public ByteBuffer ByteBuffer
            {
                get
                {
                    _buffer?.Close();
                    _buffer = new ByteBuffer();
                    _buffer.WriteInt(operateId);
                    return _buffer;
                }
            }
            public int operateId;
        }
        /// <summary>
        /// 购买保险
        /// </summary>
        public class CMD_CS_PLAYER_INSURANCE
        {
            public CMD_CS_PLAYER_INSURANCE()
            {
                
            }

            private ByteBuffer buffer;

            public ByteBuffer ByteBuffer
            {
                get
                {
                    buffer?.Close();
                    buffer=new ByteBuffer();
                    buffer.WriteByte(isInsurance ? 1 : 0);
                    return buffer;
                }
            }

            public bool isInsurance;
        }
    }
}