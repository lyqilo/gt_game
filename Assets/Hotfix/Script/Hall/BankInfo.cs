using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall
{
    public class BankInfo : PanelBase
    {
        private Button closeBtn;
        private Text info;
        private Button maskCloseBtn;

        public BankInfo() : base(UIType.Middle, nameof(BankInfo))
        {
        }
        public override void Create(params object[] args)
        {
            base.Create(args);
            info = transform.FindChildDepth<Text>("Info/Text");
            closeBtn = transform.FindChildDepth<Button>("CloseBtn");
            maskCloseBtn = transform.FindChildDepth<Button>("Mask");

            info.text = args[0].ToString();
            HallEvent.DispatchChangeGoldTicket();

            closeBtn.onClick.RemoveAllListeners();
            closeBtn.onClick.Add(OnClickClose);

            maskCloseBtn.onClick.RemoveAllListeners();
            maskCloseBtn.onClick.Add(OnClickClose);
        }

        private void OnClickClose()
        {
            HallEvent.DispatchOnTransferComplete(false);
            info.text = "";
            UIManager.Instance.Close();
        }
    }
}