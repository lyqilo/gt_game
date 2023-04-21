using FancyScrollView;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Mail
{
    public partial class UIMail : PanelBase
    {
        public UIMail() : base(UIType.Middle, nameof(UIMail))
        {
        }

        private Scroller _scroller;
        private Transform leftGroup;
        private Transform rightGroup;

        private TitleScrollView _scrollView;
        private Transform mailList;
        private UIMainDetail _detail;
        private Button close;
        public override void Create(params object[] args)
        {
            base.Create(args);
            _detail = rightGroup.gameObject.CreateOrGetComponent<UIMainDetail>();
            _detail.gameObject.SetActive(false);
            CreateMenuScroller(mailList.FindChildDepth($"Viewport").GetComponent<RectTransform>());
            _scrollView ??= mailList.gameObject.CreateOrGetComponent<TitleScrollView>();
            var list = Model.Instance.GetMailData();
            _scrollView.Init(list, OnSelectMail);
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            leftGroup = transform.FindChildDepth($"Left");
            rightGroup = transform.FindChildDepth($"Right");
            mailList = leftGroup.FindChildDepth($"MailList");
            close = transform.FindChildDepth<Button>($"CloseBtn");
        }

        protected override void AddListener()
        {
            base.AddListener();
            close.onClick.RemoveAllListeners();
            close.onClick.Add(OnClickClose);
        }

        protected override void AddEvent()
        {
            base.AddEvent();
            Model.Instance.OnMailGetReward = OnMailGetReward;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            Model.Instance.OnMailGetReward = null;
        }

        private void CreateMenuScroller(RectTransform viewport)
        {
            _scroller ??= mailList.gameObject.CreateOrGetComponent<Scroller>();
            _scroller.Viewport ??= viewport;
            _scroller.SnapEnabled = false;
            _scroller.Draggable = true;
            _scroller.MovementType = MovementType.Clamped;
            _scroller.ScrollDirection = ScrollDirection.Vertical;
        }

        private void OnClickClose()
        {
            UIManager.Instance.Close();
        }

        private void OnSelectMail(HallStruct.sMail obj)
        {
            if (obj == null) return;
            _scrollView.RefreshData();
            _detail.ShowMail(obj);
        }

        private void OnMailGetReward()
        {
            _detail.ChangeClaimState();
        }
    }
}