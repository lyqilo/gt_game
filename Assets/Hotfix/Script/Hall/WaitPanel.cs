using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall
{
    public class WaitPanel : PanelBase
    {
        public WaitPanel() : base(UIType.Fix, nameof(WaitPanel))
        {
        }

        private static WaitPanel _panel;

        public static WaitPanel Open(string content)
        {
            _panel ??= UIManager.Instance.GetUI<WaitPanel>();
            _panel ??= UIManager.Instance.OpenUI<WaitPanel>();
            _panel.SetContent(content);
            _panel.transform.localScale = Vector3.one;
            return _panel;
        }

        public static void Close()
        {
            if (_panel == null) return;
            _panel.transform.localScale = Vector3.zero;
        }

        private static int _openIndex;
        private Text content;

        protected override void FindComponent()
        {
            base.FindComponent();
            content = transform.FindChildDepth<Text>($"Text");
        }

        public override void Create(params object[] args)
        {
            base.Create(args);
            if (args.Length <= 0)
            {
                content.text = $"";
            }
            else
            {
                content.text = args[0] == null ? $"" : args[0].ToString();
            }
        }

        public void SetContent(string msg)
        {
            content.text = string.IsNullOrEmpty(msg) ? "" : msg;
        }
    }
}