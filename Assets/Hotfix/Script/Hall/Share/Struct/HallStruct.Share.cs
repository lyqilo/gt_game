using System.Collections.Generic;
using LuaFramework;

namespace Hotfix
{
    public partial class HallStruct
    {
        public struct sShareData : IBaseData
        {
            public ushort inviteCodeLength;
            public string inviteCode;
            public int bindCount; //绑定个数
            public List<int> bindList; //第一个是自己，剩余是绑定的玩家

            public sShareData(ByteBuffer buffer)
            {
                inviteCodeLength = buffer.ReadUInt16();
                inviteCode = buffer.ReadString(inviteCodeLength);
                bindCount = buffer.ReadInt32();
                bindList = new List<int>();
                for (int i = 0; i < bindCount; i++)
                {
                    bindList.Add(buffer.ReadInt32());
                }
            }
        }

        public struct sBindParent : IBaseData
        {
            public string strCode;

            private ByteBuffer _buffer;

            public ByteBuffer Buffer
            {
                get
                {
                    _buffer?.Close();
                    _buffer = new ByteBuffer();
                    _buffer.WriteBytes(10, strCode);
                    return _buffer;
                }
            }
        }

        public struct sInviteAward : IBaseData
        {
            public int InviteNum;
            public int PickIndex;
            public int Count;
            public List<sInviteAwardCfg> AwardCfg; //奖励配置

            public sInviteAward(ByteBuffer buffer)
            {
                InviteNum = buffer.ReadInt32();
                PickIndex = buffer.ReadInt32();
                Count = buffer.ReadInt32();
                AwardCfg = new List<sInviteAwardCfg>();
                for (int i = 0; i < Count; i++)
                {
                    AwardCfg.Add(new sInviteAwardCfg(buffer));
                }
            }
        }

        public struct sInviteAwardCfg : IBaseData
        {
            public int InviteNum; //邀请数量
            public int Award; //奖励

            public sInviteAwardCfg(ByteBuffer buffer)
            {
                InviteNum = buffer.ReadInt32();
                Award = buffer.ReadInt32();
            }
        }

        public struct sRechargeInfo : IBaseData
        {
            public int InviteNum;
            public long TodayAward;
            public long TotalAward;
            public long CanPickAmount;
            public ushort InviteCodeLen;
            public string InviteCode;

            public sRechargeInfo(ByteBuffer buffer)
            {
                InviteNum = buffer.ReadInt32();
                TodayAward = buffer.ReadInt64();
                TotalAward = buffer.ReadInt64();
                CanPickAmount = buffer.ReadInt64();
                InviteCodeLen = buffer.ReadShort();
                InviteCode = buffer.ReadString(InviteCodeLen);
            }
        }

        public struct sS2CQueryRebate : IBaseData
        {
            public int Count;
            public List<sQueryRebateRecordItem> QueryRebateRecord;

            public sS2CQueryRebate(ByteBuffer buffer)
            {
                Count = buffer.ReadInt32();
                QueryRebateRecord = new List<sQueryRebateRecordItem>();
                for (int i = 0; i < Count; i++)
                {
                    QueryRebateRecord.Add(new sQueryRebateRecordItem(buffer));
                }
            }
        };

        public struct sQueryRebateRecordItem : IBaseData
        {
            public int RechargeUserID;
            public int RechargeAmount;
            public int Rebate;

            public sQueryRebateRecordItem(ByteBuffer buffer)
            {
                RechargeUserID = buffer.ReadInt32();
                RechargeAmount = buffer.ReadInt32();
                Rebate = buffer.ReadInt32();
            }
        };
    }
}