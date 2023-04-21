using System;
using System.Collections.Generic;
using LitJson;
using LuaFramework;

namespace Hotfix
{
    public partial class CustomEvent
    {
        public const string MDM_3D_PERSONAL_INFO = "MDM_3D_PERSONAL_INFO";
    }
}
namespace Hotfix.Hall.Share
{
    public class Model : Singleton.Singleton<Model>
    {
        Dictionary<ushort, HallStruct.IBaseData> _shareBaseDatas =
            new Dictionary<ushort, HallStruct.IBaseData>();

        private Dictionary<ushort, long> _shareTimes = new Dictionary<ushort, long>();

        public void Awake()
        {
            HotfixMessageHelper.AddListener(CustomEvent.MDM_3D_PERSONAL_INFO, OnRecieveMessage);
        }

        private void OnDestroy()
        {
            HotfixMessageHelper.RemoveListener(CustomEvent.MDM_3D_PERSONAL_INFO, OnRecieveMessage);
        }

        private HallStruct.IBaseData GetData(ushort sid)
        {
            if (_shareBaseDatas.ContainsKey(sid)) return _shareBaseDatas[sid];
            return null;
        }

        public void RemoveData(ushort sid)
        {
            if (_shareBaseDatas.ContainsKey(sid)) _shareBaseDatas.Remove(sid);
            if (_shareTimes.ContainsKey(sid)) _shareTimes.Remove(sid);
        }

        public void Send(ushort sid, ByteBuffer buffer)
        {
            _shareTimes.TryGetValue(sid, out var timer);
            if (timer > TimeComponent.Instance.GetServerTime() - 10)
            {
                HotfixMessageHelper.PostHotfixEvent(CustomEvent.MDM_3D_PERSONAL_INFO + sid, GetData(sid));
                return;
            }

            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO,
                sid, buffer, SocketType.Hall);
        }

        private void OnRecieveMessage(object data)
        {
            if (!(data is BytesPack pack)) return;
            HallStruct.IBaseData baseData = null;
            switch (pack.sid)
            {
                case DataStruct.PersonalStruct.SUB_3D_SC_QueryShareInfo:
                    baseData = new HallStruct.sShareData(new ByteBuffer(pack.bytes));
                    break;
                case DataStruct.PersonalStruct.SUB_3D_SC_BindParent:
                    baseData = new HallStruct.sCommonINT16(new ByteBuffer(pack.bytes));
                    break;
                case DataStruct.PersonalStruct.SUB_3D_SC_QueryInviteAwardCfg:
                    baseData = new HallStruct.sInviteAward(new ByteBuffer(pack.bytes));
                    break;
                case DataStruct.PersonalStruct.SUB_3D_SC_PickInviteAward:
                    baseData = new HallStruct.sCommonINT64(new ByteBuffer(pack.bytes));
                    break;
                case DataStruct.PersonalStruct.SUB_3D_SC_QueryRechargeInfo:
                    baseData = new HallStruct.sRechargeInfo(new ByteBuffer(pack.bytes));
                    break;
                case DataStruct.PersonalStruct.SUB_3D_SC_QueryRechargeRebateRecord:
                    baseData = new HallStruct.sS2CQueryRebate(new ByteBuffer(pack.bytes));
                    break;
                case DataStruct.PersonalStruct.SUB_3D_SC_PickRechargeRebate:
                    baseData = new HallStruct.sCommonINT64(new ByteBuffer(pack.bytes));
                    break;
            }

            _shareBaseDatas[(ushort) pack.sid] = baseData;
            _shareTimes[(ushort) pack.sid] = TimeComponent.Instance.GetServerTime();
            HotfixMessageHelper.PostHotfixEvent(CustomEvent.MDM_3D_PERSONAL_INFO + pack.sid, GetData((ushort) pack.sid));
        }
    }
}