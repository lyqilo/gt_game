using System;
using System.Collections.Generic;
using FancyScrollView;
using Hotfix.Hall;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Recharge
{
    public partial class RechargePanel : PanelBase
    {
        private List<string> _titleMenu = new List<string>()
        {
            "Recharge",
            "Withdrawal",
            "RechargeRecord",
            "WithdrawalRecord",
        };

        private Button closeBtn;

        private Button DKCZBtn;
        private Transform mainPanel;
        private Button maskCloseBtn;

        private Transform leftGroup;
        private Transform rightGroup;
        private Scroller _scroller;
        private TitleScrollView _scrollView;
        private Transform titleList;
        private int CurrentIndex { get; set; } = -1;
        private List<UIDetail> _details = new List<UIDetail>();

        public RechargePanel() : base(UIType.Middle, nameof(RechargePanel))
        {
        }

        public override void Create(params object[] args)
        {
            base.Create(args);
            int startIndex = 0;
            if (args.Length > 0 && (args[0] is int index)) startIndex = index;
            var view = titleList.FindChildDepth($"Viewport").GetComponent<RectTransform>();
            _scroller ??= ToolHelper.CreateScroller(titleList.gameObject, view);
            _scrollView ??= titleList.gameObject.CreateOrGetComponent<TitleScrollView>();
            List<TitleData> datas = new List<TitleData>();
            for (int i = 0; i < _titleMenu.Count; i++)
            {
                datas.Add(new TitleData(_titleMenu[i]));
            }

            _details.Clear();
            for (int i = 0; i < rightGroup.childCount; i++)
            {
                var child = rightGroup.GetChild(i);
                child.gameObject.SetActive(true);
                var detail = child.gameObject.AddComponent<UIDetail>();
                detail.Index = i;
                _details.Add(detail);
            }

            _scrollView.Init(datas, OnSelectTitle, startIndex);
        }

        protected override void FindComponent()
        {
            leftGroup = transform.FindChildDepth($"Left");
            rightGroup = transform.FindChildDepth($"Right");
            titleList = leftGroup.FindChildDepth($"TitleList");
            closeBtn = transform.FindChildDepth<Button>($"CloseBtn");
        }

        protected override void AddListener()
        {
            closeBtn.onClick.RemoveAllListeners();
            closeBtn.onClick.Add(OnClickClose);
        }

        private void OnClickClose()
        {
            UIManager.Instance.Close();
        }
        private void OnSelectTitle(int index)
        {
            if (CurrentIndex == index) return;
            for (int i = 0; i < _details.Count; i++)
            {
                if (index == i) _details[i].Show();
                else _details[i].Hide();
            }

            CurrentIndex = index;
            _scrollView.RefreshData();
        }
    }
}