
using LuaFramework;
using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.CMLHJ
{
    /// <summary>
    /// 结构体
    /// </summary>
    public class CMLHJ_Struct
    {
        #region REQ
        /// <summary>
        /// 开始游戏
        /// </summary>
        public const ushort SUB_CS_GAME_START = 0;

        /// <summary>
        /// 开始玛丽
        /// </summary>
        public const ushort SUB_CS_GAME_MALI = 1;

        /// <summary>
        /// 得分
        /// </summary>
        public const ushort SUB_CS_GET_SCORE = 2;

        #endregion

        #region ACP

        /// <summary>
        /// 启动游戏
        /// </summary>
        public const ushort SUB_SC_GAME_START = 0;
        /// <summary>
        /// 玛丽结果
        /// </summary>
        public const ushort SUB_SC_MALI_RESULT = 1;
        /// <summary>
        /// 游戏结算
        /// </summary>
        public const ushort SUB_SC_GAME_OVER = 2;
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
                nWinNum = buffer.ReadInt64();
                nCurrenBet = buffer.ReadInt32();

                nBet = new List<int>();
                for (int i = 0; i < CMLHJ_DataConfig.MAX_BET_COUNT; i++)
                {
                    nBet.Add(buffer.ReadInt32());
                }

                nLineRate = new List<int>()
;               for (int i = 0; i < CMLHJ_DataConfig.ALLLINECOUNT; i++)
                {
                    nLineRate.Add(buffer.ReadInt32());
                }

                nGame_State = buffer.ReadByte();
                nByImg = new List<byte>();
                for (int i = 0; i < CMLHJ_DataConfig.MAX_ALLICON; i++)
                {
                    nByImg.Add(buffer.ReadByte());
                }

                nLineList = new List<byte>();
                for (int i = 0; i < CMLHJ_DataConfig.ALLLINECOUNT* CMLHJ_DataConfig.MAX_COL; i++)
                {
                    byte data = buffer.ReadByte();
                    nLineList.Add(data);
                }

                nMaryCount = buffer.ReadByte();
                nByPrizeImg = new List<byte>();
                for (int i = 0; i < CMLHJ_DataConfig.MAX_RAW; i++)
                {
                    byte data = buffer.ReadByte();
                    nByPrizeImg.Add(data);
                }
                nStopIndex = buffer.ReadByte();
                nOhterGameWinGold = buffer.ReadInt32();

            }
            public SC_SceneInfo() { }

            public long nWinNum;//小游戏金币
            public int nCurrenBet;//断线前下注筹码
            public List<int> nBet;//下注列表
            public List<int> nLineRate;//连线倍率
            public byte nGame_State;//游戏状态
            public List<byte> nByImg;//图标
            public List<byte> nLineList;//连线结果
            public byte nMaryCount;//玛丽次数
            public List<byte> nByPrizeImg;//玛丽奖励图标
            public byte nStopIndex;//停止索引
            public int nOhterGameWinGold;//其他奖励
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
                nWinGold = buffer.ReadInt64();
                Debug.Log("nWinGold==" + nWinGold);
                nLineRate = new List<int>();
                for (int i = 0; i < CMLHJ_DataConfig.ALLLINECOUNT; i++)
                {
                    nLineRate.Add(buffer.ReadInt32());
                }

                cbIcon = new List<byte>();
                for (int i = 0; i < CMLHJ_DataConfig.MAX_ALLICON; i++)
                {
                    cbIcon.Add(buffer.ReadByte());
                }

                nLineList = new List<byte>();
                for (int i = 0; i < CMLHJ_DataConfig.ALLLINECOUNT * CMLHJ_DataConfig.MAX_COL; i++)
                {
                    byte data = buffer.ReadByte();
                    nLineList.Add(data);
                }

                nMaryCount = buffer.ReadByte();
                CMLHJEntry.Instance.GameData.CurrentMaryCount = nMaryCount;

                //if (nMaryCount > 0)
                //{
                //    Time.timeScale = 0;
                //}
            }
            public long nWinGold;//结算金币
            public List<int> nLineRate;//连线倍率
            public List<byte> cbIcon;//图标
            public List<byte> nLineList;//连线结果
            public byte nMaryCount;// 免费次数
        }


        /// <summary>
        /// 小游戏消息
        /// </summary>
        public class CMD_3D_SC_MaryResult
        {
            public CMD_3D_SC_MaryResult() { }
            public CMD_3D_SC_MaryResult(ByteBuffer buffer)
            {
                nWinGold = buffer.ReadInt64();
                nMaryCount = buffer.ReadByte();

                nByPrizeImg = new List<byte>();
                for (int i = 0; i < CMLHJ_DataConfig.MAX_RAW; i++)
                {
                    byte data = buffer.ReadByte();
                    nByPrizeImg.Add(data);
                }

                nStopIndex = buffer.ReadByte();
            }
            public long nWinGold;//结算金币
            public byte nMaryCount;// 小玛丽次数
            public List<byte> nByPrizeImg;//玛丽奖励图标
            public byte nStopIndex;// 停止索引

        }


        #endregion
    }
}
