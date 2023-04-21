using System;
using Hotfix.Hall.PopTaskSystem;

namespace Hotfix.Hall.BindPhone
{
    public class Model : Singleton.SingletonNoMono<Model>,IPopItem
    {
        public string PopName => "PopBindPhone";

        public Func<bool> Condition { get; set; } = () => GameLocalMode.Instance.SCPlayerInfo != null &&
                                                          string.IsNullOrEmpty(GameLocalMode.Instance.SCPlayerInfo.SzPhoneNumber);

        public Action Excute { get; set; } = () =>
        {
            UIManager.Instance.OpenUI<BindPanel>();
        };
    }
}