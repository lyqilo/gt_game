using LuaFramework;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Service
{
    public class ServicePanel : PanelBase
    {
        private Button closeBtn;
        private Transform mainPanel;
        private Button wechatBtn;
        private Button shareServer2Btn;
        private Button shareServer3Btn;

        public ServicePanel() : base(UIType.Middle, nameof(ServicePanel))
        {
        }

        public override void Create(params object[] args)
        {
            base.Create(args);
            Init();
        }

        protected override void FindComponent()
        {
            mainPanel = transform.FindChildDepth("MainPanel");
            closeBtn = mainPanel.FindChildDepth<Button>("CloseBtn");
            wechatBtn = mainPanel.FindChildDepth<Button>("chatBtn");

            shareServer2Btn = mainPanel.FindChildDepth<Button>("shareServer2Btn");
            shareServer3Btn = mainPanel.FindChildDepth<Button>("shareServer3Btn");
        }

        protected override void AddListener()
        {
            closeBtn.onClick.RemoveAllListeners();
            closeBtn.onClick.Add(ClosePanel);
            wechatBtn.onClick.RemoveAllListeners();
            wechatBtn.onClick.Add(() =>
            {
                Model.Instance.Configs.TryGetValue("WhatsApp", out var config);
                string url = config.resources;
                if (string.IsNullOrEmpty(url)) url = "https://wa.me/639665525323";
                Application.OpenURL(url);
            });

            shareServer2Btn.onClick.RemoveAllListeners();
            shareServer2Btn.onClick.Add(() =>
            {
                Model.Instance.Configs.TryGetValue("Viber", out var config);
                string url = config.resources;
                if (string.IsNullOrEmpty(url)) url = "+63 9665525323";
                UIManager.Instance.OpenUI<UIViber>(url);
            });

            shareServer3Btn.onClick.RemoveAllListeners();
            shareServer3Btn.onClick.Add(() =>
            {
                Model.Instance.Configs.TryGetValue("LiveChat", out var config);
                string url = config.resources;
                if (string.IsNullOrEmpty(url)) url = "https://direct.lc.chat/15211527/";
                UIManager.Instance.ReplaceUI<UIService>(url);
            });
        }

        private void Init()
        {

        }



        private void ClosePanel()
        {
            ILMusicManager.Instance.PlayBtnSound();
            UIManager.Instance.Close();
        }
    }
}