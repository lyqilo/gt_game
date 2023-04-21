using System.Collections.Generic;
using EasingCore;
using FancyScrollView;
using UnityEngine;

namespace Hotfix.Hall.Announcement
{
    public partial class AnnouncementPanel
    {
        public class TitleScrollView : FancyScrollView.FancyScrollRect<TitleData, TitleContext>
        {
            private GameObject _cellPrefab;
            protected override GameObject CellPrefab => _cellPrefab;
            private float _cellSize;
            protected override float CellSize => _cellSize;

            public void Init(List<TitleData> items, CAction<NoticeData> callback)
            {
                _cellPrefab = transform.Find($"TitleItem").gameObject;
                _cellPrefab.CreateOrGetComponent<UITitleItem>();
                cellContainer ??= transform.FindChildDepth($"Viewport/Content");
                _cellSize = _cellPrefab.GetComponent<RectTransform>().rect.height;
                spacing = 20;
                paddingHead = 20;
                paddingTail = 20;

                UpdateData(items);
                Context.OnCellClicked = callback;
                ScrollTo(0, 0f, Ease.InOutQuint, Alignment.Upper);
                if (items.Count > 0) Context.OnCellClicked?.Invoke(items[0].Data);
            }

            public void ScrollTo(int index, float duration, Ease easing, Alignment alignment = Alignment.Middle)
            {
                UpdateSelection(index);
                ScrollTo(index, duration, easing, GetAlignment(alignment));
            }

            public void UpdateData(IList<TitleData> items)
            {
                UpdateContents(items);
            }

            public void RefreshData()
            {
                Refresh();
            }

            float GetAlignment(Alignment alignment)
            {
                switch (alignment)
                {
                    case Alignment.Upper: return 0.0f;
                    case Alignment.Middle: return 0.5f;
                    case Alignment.Lower: return 1.0f;
                    default: return GetAlignment(Alignment.Middle);
                }
            }

            void UpdateSelection(int index)
            {
                if (Context.SelectedIndex == index)
                {
                    return;
                }

                Context.SelectedIndex = index;
                Refresh();
            }
        }

        public class TitleData
        {
            public NoticeData Data { get; set; }

            public TitleData(NoticeData data)
            {
                Data = data;
            }
        }

        public class TitleContext : FancyScrollRectContext
        {
            public int SelectedIndex { get; set; } = -1;
            public CAction<NoticeData> OnCellClicked;
        }
    }
}