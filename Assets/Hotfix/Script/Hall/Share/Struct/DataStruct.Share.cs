namespace Hotfix
{
    public partial class DataStruct
    {
        public partial class PersonalStruct
        {
            public const ushort SUB_3D_CS_QueryShareInfo = 50; //分享信息查询
            public const ushort SUB_3D_SC_QueryShareInfo = 51; //分享信息查询返回

            public const ushort SUB_3D_CS_BindParent = 63; //绑定上一级
            public const ushort SUB_3D_SC_BindParent = 64; //绑定上一级返回、


            public const ushort SUB_3D_CS_QueryInviteAwardCfg = 65; //获取邀请奖励配置
            public const ushort SUB_3D_SC_QueryInviteAwardCfg = 66; //获取邀请奖励配置返回

            public const ushort SUB_3D_CS_PickInviteAward = 67; //领取邀请奖励
            public const ushort SUB_3D_SC_PickInviteAward = 68; //领取邀请奖励返回

            public const ushort SUB_3D_CS_QueryRechargeInfo = 69; //查询充值信息
            public const ushort SUB_3D_SC_QueryRechargeInfo = 70; //查询充值信息返回

            public const ushort SUB_3D_CS_QueryRechargeRebateRecord = 71; //查询代理返利记录
            public const ushort SUB_3D_SC_QueryRechargeRebateRecord = 72; //查询代理返利记录返回
            public const ushort SUB_3D_CS_PickRechargeRebate = 73; //领取代理分成奖励
            public const ushort SUB_3D_SC_PickRechargeRebate = 74; //领取代理分成奖励返回
        }
    }
}