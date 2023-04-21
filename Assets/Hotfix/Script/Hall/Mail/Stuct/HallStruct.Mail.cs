using System.Collections.Generic;
using LuaFramework;

namespace Hotfix
{
    public partial class HallStruct
    {
        public class sMail
        {
            public int nMailID; //邮件ID
            public int nSendUserID; //发送者ID
            public long nSendTime; //发送时间
            public ushort nTitle; //邮件标题
            public string strTitle; //邮件标题
            public ushort nContent; //邮件内容
            public string strContent; //邮件内容
            public long nGold; //邮件附件(只有金币)
            public bool bIsRead; //是否已读
            public bool bIsClaim; //是否领取

            public sMail(ByteBuffer buffer)
            {
                nMailID = buffer.ReadInt32();
                nSendUserID = buffer.ReadInt32();
                nSendTime = buffer.ReadInt64();
                nTitle = buffer.ReadUInt16();
                strTitle = buffer.ReadString(nTitle);
                nContent = buffer.ReadUInt16();
                strContent = buffer.ReadString(nContent);
                nGold = buffer.ReadInt64();
                bIsRead = buffer.ReadByte() != 0;
                bIsClaim = buffer.ReadByte() != 0;
            }
        }

        public class sMailDatas : IHotfixMessage
        {
            public int nMailCount;
            public List<sMail> Mails; //玩家邮件

            public sMailDatas(ByteBuffer buffer)
            {
                nMailCount = buffer.ReadInt32();
                Mails = new List<sMail>();
                for (int i = 0; i < nMailCount; i++)
                {
                    Mails.Add(new sMail(buffer));
                }
            }
        }
    }
}