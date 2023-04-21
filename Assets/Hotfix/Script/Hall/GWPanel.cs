using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall
{
    public class GWPanel : PanelBase
    {
        private Button closeBtn;
        private Button CopyBtn;

        private Image GWImage;
        private Text GWURL;
        private Button maskBtn;
        private Transform mainPanel;

        public GWPanel(): base(UIType.Middle, nameof(GWPanel))
        {

        }

        protected override void FindComponent()
        {
            mainPanel = transform.FindChildDepth("MainPanel");
            closeBtn = mainPanel.FindChildDepth<Button>("CloseBtn");
            maskBtn = mainPanel.FindChildDepth<Button>("Mask");
            CopyBtn = mainPanel.FindChildDepth<Button>("CopyBtn");

            GWImage = mainPanel.FindChildDepth<Image>("Image");
            GWURL = mainPanel.FindChildDepth<Text>("GWURL");
            Init();
        }

        protected override void AddListener()
        {
            closeBtn.onClick.RemoveAllListeners();
            closeBtn.onClick.Add(CloseGWPanel);
            maskBtn.onClick.RemoveAllListeners();
            maskBtn.onClick.Add(CloseGWPanel);

            CopyBtn.onClick.RemoveAllListeners();
            CopyBtn.onClick.Add(() =>
            {
                var str = GWURL.text;
                ToolHelper.SetText(str);
                ToolHelper.PopSmallWindow("官网复制成功");
            });
        }

        private void Init()
        {
            GWURL.text = GameLocalMode.Instance.GWData.GWUrl;
        }

        private void CloseGWPanel()
        {
            UIManager.Instance.CloseUI<GWPanel>();
        }
    }
}