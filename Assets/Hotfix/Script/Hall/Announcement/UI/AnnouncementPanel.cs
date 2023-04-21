using System.Collections.Generic;
using FancyScrollView;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Announcement
{
    public partial class AnnouncementPanel : PanelBase
    {
        public AnnouncementPanel() : base(UIType.Middle, nameof(AnnouncementPanel))
        {
        }

        public static AnnouncementPanel Open(List<NoticeData> config)
        {
            return UIManager.Instance.OpenUI<AnnouncementPanel>(config);
        }
        private Scroller _scroller;
        private Transform leftGroup;
        private Transform rightGroup;

        private TitleScrollView _scrollView;
        private Transform list;
        private UIMainDetail _detail;
        private Button close;

        public override void Create(params object[] args)
        {
            base.Create(args);
            if (args.Length <= 0 || !(args[0] is List<NoticeData> config))
            {
                DebugHelper.LogError("config is null");
                return;
            }
            _detail = rightGroup.gameObject.CreateOrGetComponent<UIMainDetail>();
            _detail.gameObject.SetActive(false);
            ToolHelper.CreateScroller(list.gameObject,list.FindChildDepth($"Viewport").GetComponent<RectTransform>());
            _scrollView ??= list.gameObject.CreateOrGetComponent<TitleScrollView>();
            var listdata = new List<TitleData>();
            for (int i = 0; i < config.Count; i++)
            {
                listdata.Add(new TitleData(config[i]));
            }
            _scrollView.Init(listdata, OnSelectNotice);
            
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            leftGroup = transform.FindChildDepth($"Left");
            rightGroup = transform.FindChildDepth($"Right");
            list = leftGroup.FindChildDepth($"List");
            close = transform.FindChildDepth<Button>($"CloseBtn");
        }

        protected override void AddListener()
        {
            base.AddListener();
            close.onClick.RemoveAllListeners();
            close.onClick.Add(OnClickClose);
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            HotfixMessageHelper.PostHotfixEvent(PopTaskSystem.Model.CompleteShowPop, Model.Instance.PopName);
        }

        private void OnClickClose()
        {
            UIManager.Instance.Close();
        }


        private void OnSelectNotice(NoticeData obj)
        {
            _scrollView.RefreshData();
            _detail.ShowData(obj);
        }
    }
}