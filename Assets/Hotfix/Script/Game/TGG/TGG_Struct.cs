
using LuaFramework;
using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.TGG
{
    /// <summary>
    /// 结构体
    /// </summary>
    public class TGG_Struct
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

        /// <summary>
        /// 游戏结束
        /// </summary>
        public const ushort SUB_SC_BET_ERR = 11;
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

                bet = buffer.ReadInt32();
                userGold= buffer.ReadInt32();
                chipList = new List<int>();
                for (int i = 0; i < TGG_DataConfig.MAX_BET_COUNT; i++)
                {
                    chipList.Add(buffer.ReadInt32());
                }
                freeNumber = buffer.ReadByte();
                caiJin = buffer.ReadInt32();
            }
            public SC_SceneInfo() { }
            public int bet;//断线前下注筹码
            public int userGold;
            public List<int> chipList;//下注列表
            public byte freeNumber;// 免费次数
            public int caiJin;
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
                for (int i = 0; i < TGG_DataConfig.MAX_ALLICON; i++)
                {
                    ImgTable.Add(buffer.ReadByte());
                }
                LineTypeTable = new List<LineData>();
                for (int i = 0; i < TGG_DataConfig.IconTable.Count; i++)
                {
                    LineData data = new LineData();
                    data.cbIcon = buffer.ReadByte();
                    data.cbCount = buffer.ReadByte();
                    data.cbTemp1 = buffer.ReadByte();
                    data.cbTemp2 = buffer.ReadByte();
                    data.cbTemp3 = buffer.ReadByte();
                    LineTypeTable.Add(data);
                }

                WinScore = buffer.ReadInt32();
                nFreeCount = buffer.ReadByte();

                caiJin = buffer.ReadInt32();
                cbChangeLine = buffer.ReadByte();
                if (nFreeCount>0|| TGGEntry.Instance.GameData.TotalFreeWin>0)
                {
                    TGGEntry.Instance.GameData.TotalFreeWin += WinScore;
                }
            }
            public List<byte> ImgTable;//图标
            public List<LineData> LineTypeTable;// 击中的图标
            public int WinScore;//结算金币
            public byte nFreeCount;// 免费次数
            public int caiJin;
            public byte cbChangeLine;// 免费次数
        }


        public class LineData
        {
          public byte cbIcon=0;
          public byte cbCount=0;
          public byte cbTemp1=0;
          public byte cbTemp2=0;
          public byte cbTemp3=0;
        }

        #endregion
    }
}
