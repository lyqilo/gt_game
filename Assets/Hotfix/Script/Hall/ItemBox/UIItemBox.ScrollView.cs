using System.Collections.Generic;
using EasingCore;
using FancyScrollView;
using UnityEngine;

namespace Hotfix.Hall.ItemBox
{
    public partial class UIItemBox
    {
        public class ScrollView : FancyScrollRect<Data, Content>
        { 
            private GameObject _cellPrefab;
            protected override GameObject CellPrefab => _cellPrefab;
            private float _cellSize;
            protected override float CellSize => _cellSize;
            public void Init(List<Data> items, CAction<int> callback = null)
            {
                _cellPrefab = transform.Find($"Item").gameObject;
                _cellPrefab.CreateOrGetComponent<UIItemCell>();
                cellContainer ??= transform.FindChildDepth($"View/Content");
                _cellSize = _cellPrefab.GetComponent<RectTransform>().rect.width;
                spacing = 10;
                paddingHead = 20;
                paddingTail = 20;
                UpdateData(items);
                Context.OnCellClicked = callback;
                ScrollTo(Mathf.FloorToInt(items.Count / 2f), 0f, Ease.InOutQuint);
                if (items.Count > 0) Context.OnCellClicked?.Invoke(0);
            }

            public void ScrollTo(int index, float duration, Ease easing, Alignment alignment = Alignment.Middle)
            {
                UpdateSelection(index);
                ScrollTo(index, duration, easing, GetAlignment(alignment));
            }

            public void UpdateData(IList<Data> items)
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

        public class Data
        {
            public int ItemId { get; set; }
            public long ItemCount { get; set; }

            public Data(int itemId,long itemCount)
            {
                ItemId = itemId;
                ItemCount = itemCount;
            }
        }

        public class Content : FancyScrollRectContext
        {
            public int SelectedIndex { get; set; }
            public CAction<int> OnCellClicked { get; set; }
        }
    }
}