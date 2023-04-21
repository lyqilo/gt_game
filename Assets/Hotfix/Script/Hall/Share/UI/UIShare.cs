using System.Collections.Generic;
using FancyScrollView;
using LuaFramework;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Share
{
    public partial class UIShare : PanelBase
    {
        public UIShare() : base(UIType.Middle, nameof(UIShare))
        {
        }

        private List<string> _titleMenu = new List<string>()
        {
            "Share & Bind",
            "Invitation Reward",
            "Recharge Reward"
        };

        private Scroller _scroller;
        private Transform leftGroup;
        private Transform rightGroup;

        private TitleScrollView _scrollView;
        private Transform titleList;
        private Button close;
        private int CurrentIndex { get; set; } = -1;
        private List<UIDetail> _details = new List<UIDetail>();

        public override void Create(params object[] args)
        {
            base.Create(args);
            CreateMenuScroller(titleList.FindChildDepth($"Viewport").GetComponent<RectTransform>());
            _scrollView ??= titleList.gameObject.CreateOrGetComponent<TitleScrollView>();
            List<TitleData> datas = new List<TitleData>();
            for (int i = 0; i < _titleMenu.Count; i++)
            {
                datas.Add(new TitleData(_titleMenu[i]));
            }

            for (int i = 0; i < rightGroup.childCount; i++)
            {
                var child = rightGroup.GetChild(i);
                child.gameObject.SetActive(true);
                var detail = child.gameObject.AddComponent<UIDetail>();
                detail.Hide();
                detail.Index = i;
                _details.Add(detail);
            }

            _scrollView.Init(datas, OnSelectTitle);
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            leftGroup = transform.FindChildDepth($"Left");
            rightGroup = transform.FindChildDepth($"Right");
            titleList = leftGroup.FindChildDepth($"TitleList");
            close = transform.FindChildDepth<Button>($"CloseBtn");
        }

        protected override void AddListener()
        {
            base.AddListener();
            close.onClick.RemoveAllListeners();
            close.onClick.Add(OnClickClose);
        }

        private void OnClickClose()
        {
            UIManager.Instance.Close();
        }

        private void CreateMenuScroller(RectTransform viewport)
        {
            _scroller ??= titleList.gameObject.CreateOrGetComponent<Scroller>();
            _scroller.Viewport ??= viewport;
            _scroller.SnapEnabled = false;
            _scroller.Draggable = true;
            _scroller.MovementType = MovementType.Clamped;
            _scroller.ScrollDirection = ScrollDirection.Vertical;
        }

        private void OnSelectTitle(int index)
        {
            if (CurrentIndex == index) return;
            for (int i = 0; i < _details.Count; i++)
            {
                if (i == index) _details[i].Show();
                else _details[i].Hide();
            }

            CurrentIndex = index;
            _scrollView.RefreshData();
        }
    }
}