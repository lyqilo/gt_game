using Coffee.UIExtensions;
using DG.Tweening;
using UnityEngine;

namespace Hotfix.Hall
{
    public class UIMask : PanelBase
    {
        public UIMask() : base(UIType.TipWindow, nameof(UIMask)) { }
        private UITransitionEffect _canvasGroup;
        protected override void FindComponent()
        {
            base.FindComponent();
            _canvasGroup = transform.FindChildDepth<UITransitionEffect>($"Mask");
            _canvasGroup.effectFactor = 0;
        }

        private void Show(CAction call = null)
        {
            _canvasGroup.Show();
            ToolHelper.DelayRun(_canvasGroup.duration, () =>
            {
                call?.Invoke();
            });
        }

        private void Hide(CAction call = null)
        {
            _canvasGroup.Hide();
            ToolHelper.DelayRun(_canvasGroup.duration,() =>
            {
                UIManager.Instance.CloseUI<UIMask>();
                call?.Invoke();
            });
        }

        public static void Enable(bool isShow, CAction showCall = null, CAction hideCall = null)
        {
            UIMask uiMask = UIManager.Instance.GetUI<UIMask>();
            if (uiMask == null)
            {
                uiMask = UIManager.Instance.OpenUI<UIMask>();
            }

            if (uiMask == null) return;
            if (isShow) uiMask.Show(showCall);
            else uiMask.Hide(hideCall);
        }
    }
}