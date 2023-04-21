using System;
using Hotfix.Hall.PopTaskSystem;

namespace Hotfix.Hall.Announcement
{
    public partial class Model : IPopItem
    {
        public string PopName => "Announcement";
        public Func<bool> Condition { get; set; } = () => GameLocalMode.Instance.SCPlayerInfo.nIsDrain != 0;

        public Action Excute { get; set; } = async () =>
        {
            bool isOpen = await Instance.TryOpenNotice();
            if (!isOpen) HotfixMessageHelper.PostHotfixEvent(PopTaskSystem.Model.CompleteShowPop, Instance.PopName);
        };
        public Action Complete { get; set; }
    }
}