using System;
using System.Collections.Generic;
using Hotfix.Hall.PopTaskSystem;

namespace Hotfix.Hall.Activity
{
    public class Model : Singleton.Singleton<Model>,IPopItem
    {
        public readonly List<Tuple<byte, string>> Titles = new List<Tuple<byte, string>>()
        {
            new Tuple<byte, string>(0, "Login Reward"),
            new Tuple<byte, string>(1, "Online Reward"),
            new Tuple<byte, string>(2, "Recharge \r\nReward"),
            new Tuple<byte, string>(3, "Betting Reward"),
        };

        public string PopName => "Activity";

        public Func<bool> Condition { get; set; } = () =>
        {
            string lastPopTime = SaveHelper.GetString("PopActivityTime", $"{GameLocalMode.Instance.SCPlayerInfo.DwUser_Id}");
            long.TryParse(lastPopTime, out long time);
            DateTime lastPop = ToolHelper.TimeSpanToDateTime(time);
            DateTime now = ToolHelper.TimeSpanToDateTime(TimeComponent.Instance.GetServerTime());
            TimeSpan timeSpan = now - lastPop;
            return timeSpan.Days > 0 && GameLocalMode.Instance.SCPlayerInfo.nIsDrain != 0;
        };

        public Action Excute { get; set; } = () =>
        {
            SaveHelper.SaveCommon("PopActivityTime", $"{TimeComponent.Instance.GetServerTime()}",
                $"{GameLocalMode.Instance.SCPlayerInfo.DwUser_Id}");
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO, DataStruct.PersonalStruct.SUB_3D_CS_SignCheck, null,
                SocketType.Hall);
        };
        public Action Complete { get; set; }
    }
}