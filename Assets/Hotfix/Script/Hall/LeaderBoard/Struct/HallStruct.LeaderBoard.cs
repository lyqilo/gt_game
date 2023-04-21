using System.Collections.Generic;
using LuaFramework;

namespace Hotfix
{
    public partial class HallStruct
    {
        public struct LeaderBoard
        {
            public struct sRankItem
            {
                public int nUserID; //玩家id
                public ushort nNickName; //昵称长度
                public string strNickName; //邮件标题
                public short nHeadID; //头像ID
                public long nGold; //显示金币

                public sRankItem(ByteBuffer buffer)
                {
                    nUserID = buffer.ReadInt32();
                    nNickName = buffer.ReadUInt16();
                    strNickName = buffer.ReadString(nNickName);
                    nHeadID = buffer.ReadInt16();
                    nGold = buffer.ReadInt64();
                }
            }

            public struct sRankInfo
            {
                public byte nType;
                public List<sRankItem> RankInfo; //排行榜信息（0-9 排行榜  10 自身信息）

                public sRankInfo(ByteBuffer buffer)
                {
                    nType = buffer.ReadByte();
                    RankInfo = new List<sRankItem>();
                    for (int i = 0; i < 11; i++)
                    {
                        RankInfo.Add(new sRankItem(buffer));
                    }
                }
            }
        }
    }
}