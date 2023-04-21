namespace Hotfix
{
    public partial class DataStruct
    {
        public class MailStruct
        {
            public const ushort MDM_3D_MAIL = 30; //邮件
            public const ushort C2S_GET_MAIL_LIST = 1; //获取邮件列表
            public const ushort S2C_GET_MAIL_LIST_RESP = 2; //获取邮件列表返回
            public const ushort C2S_READ_MAIL = 3; //读取邮件
            public const ushort C2S_CLAIM_MAIL = 4; //领取邮件附件
            public const ushort S2C_CLAIM_MAIL_RESP = 5; //领取邮件附件返回
            public const ushort S2C_ADD_MAIL = 6; //增加邮件
        }
    }
}