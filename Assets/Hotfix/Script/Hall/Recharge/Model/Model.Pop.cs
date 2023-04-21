using System;
using Hotfix.Hall.PopTaskSystem;

namespace Hotfix.Hall.Recharge
{
    public partial class Model : IPopItem
    {
        public string PopName => "FristRecharge";

        public Func<bool> Condition { get; set; } = () =>
            GameLocalMode.Instance.SCPlayerInfo.nIsDrain != 0 &&
            GameLocalMode.Instance.SCPlayerInfo.IsFirstRecharge == 0;

        public Action Excute { get; set; } = () =>
        {
            UIManager.Instance.OpenUI<FristRechargePanel>();
        };
        public Action Complete { get; set; }
    }
}