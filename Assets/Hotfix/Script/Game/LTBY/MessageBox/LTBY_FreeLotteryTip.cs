using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.LTBY
{
    public class LTBY_FreeLotteryTip: LTBY_Messagebox
    {
        Transform content;
        public LTBY_FreeLotteryTip() : base(nameof(LTBY_FreeLotteryTip), true) { }

        protected override void OnCreate(params object[] args)
        {
            SetTitle(MessageBoxConfig.Title);
            SetBoardProperty(0, 0, 700, 430);
            content = LTBY_Extend.Instance.LoadPrefab("LTBY_FreelotteryTip", contentParent);
            content.GetComponent<Text>().text= args[0].ToString();
        }

    }
}
