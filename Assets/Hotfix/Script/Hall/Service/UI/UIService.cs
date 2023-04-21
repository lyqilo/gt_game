using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Service
{
    public class UIService : PanelBase
    {
        public UIService() : base(UIType.Top, nameof(UIService))
        {
        }

        private UniWebView _uniWebView;
        private Button _closeBtn;

        protected override void FindComponent()
        {
            base.FindComponent();
            _uniWebView = transform.FindChildDepth<UniWebView>($"UniWebView");
            _uniWebView.ReferenceRectTransform = _uniWebView.GetComponent<RectTransform>();
            _closeBtn = transform.FindChildDepth<Button>("CloseBtn");
        }

        private bool UniWebViewOnOnShouldClose(UniWebView webview)
        {
            OnClose();
            return false;
        }

        protected override void AddListener()
        {
            base.AddListener();
            _closeBtn.onClick.RemoveAllListeners();
            _closeBtn.onClick.Add(OnClose);
        }

        private void OnClose()
        {
            UIManager.Instance.Close();
            Screen.orientation = ScreenOrientation.Landscape;
        }

        public override void Create(params object[] args)
        {
            base.Create(args);
            if (args == null || args.Length <= 0) return;
            if (!(args[0] is string url)) return;
            _uniWebView.Load(url);
            if (_uniWebView.isActiveAndEnabled) _uniWebView.Reload();
            _uniWebView.Show();
            _uniWebView.OnShouldClose += UniWebViewOnOnShouldClose;
            Screen.orientation = ScreenOrientation.Portrait;
        }
    }
}