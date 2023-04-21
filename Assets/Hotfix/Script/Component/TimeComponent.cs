using System;
using LuaFramework;
using UnityEngine;

namespace Hotfix
{
    public class TimeComponent : Singleton.Singleton<TimeComponent>, IModule
    {
        private long reqDur = 12 * 60 * 60;
        private long lastServerTime;
        private long serverTime;
        private float timer;

        public void Initialize()
        {
            timer = 0;
            serverTime = 0;
            HotfixMessageHelper.AddListener(CustomEvent.MDM_3D_PERSONAL_INFO, OnRecieveMessage);
            SyncServerTime();
        }

        public void UnInitialize()
        {
            HotfixMessageHelper.RemoveListener(CustomEvent.MDM_3D_PERSONAL_INFO, OnRecieveMessage);
            SyncServerTime();
        }

        private void SyncServerTime()
        {
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO,
                DataStruct.PersonalStruct.SUB_3D_CS_SYNC_SERVER_TIME, new ByteBuffer(), SocketType.Hall);
        }

        private void OnRecieveMessage(object data)
        {
            if (!(data is BytesPack pack)) return;
            if (pack.sid != DataStruct.PersonalStruct.SUB_3D_SC_SYNC_SERVER_TIME) return;
            HallStruct.sCommonINT64 serverdata = new HallStruct.sCommonINT64(new ByteBuffer(pack.bytes));
            lastServerTime = serverdata.nValue;
            serverTime = serverdata.nValue;
        }

        public void Update()
        {
            if (serverTime <= 0) return;
            timer += Time.deltaTime;
            if (timer < 1) return;
            serverTime++;
            timer--;
            if (serverTime < lastServerTime + reqDur) return;
            SyncServerTime();
        }

        public long GetServerTime()
        {
            if (serverTime > 0) return serverTime;
            var span = DateTime.Now - new DateTime(1970, 1, 1, 0, 0, 0, 0);
            serverTime = Convert.ToInt64(span.TotalSeconds);
            return serverTime;
        }

        /// <summary>
        /// 判断当前时间是否满足指定时间
        /// </summary>
        /// <param name="targetTime"></param>
        /// <returns></returns>
        public bool CheckTime(long targetTime)
        {
            if (serverTime > 0) return targetTime <= serverTime;
            var span = DateTime.Now - new DateTime(1970, 1, 1, 0, 0, 0, 0);
            return targetTime <= Convert.ToInt64(span.TotalSeconds);
        }
    }
}