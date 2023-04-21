using System;
using System.Collections.Generic;
using EasingCore;
using FancyScrollView;
using UnityEngine;

namespace Hotfix.Hall.Activity
{
    public partial class ActivityPanel
    {
        public class TitleScrollView : FancyScrollRect<TitleData, TitleContext>
        {
            private GameObject _cellPrefab;
            private float _cellSize;
            protected override GameObject CellPrefab => _cellPrefab;
            protected override float CellSize => _cellSize;
            
            public int DataCount => ItemsSource.Count;

            public float PaddingTop
            {
                get => paddingHead;
                set
                {
                    paddingHead = value;
                    Relayout();
                }
            }

            public float PaddingBottom
            {
                get => paddingTail;
                set
                {
                    paddingTail = value;
                    Relayout();
                }
            }

            public float Spacing
            {
                get => spacing;
                set
                {
                    spacing = value;
                    Relayout();
                }
            }

            public void Init(List<TitleData> items,CAction<byte> callback)
            {
                _cellPrefab = transform.Find($"TitleItem").gameObject;
                _cellPrefab.CreateOrGetComponent<UITitleItem>();
                cellContainer ??= transform.FindChildDepth($"Viewport/Content");
                _cellSize = _cellPrefab.GetComponent<RectTransform>().rect.height;

                UpdateData(items);
                Context.OnCellClicked = callback;
                ScrollTo(0, 0f, Ease.InOutQuint, Alignment.Upper);
                if (items.Count > 0) Context.OnCellClicked?.Invoke(items[0].Data.Item1);
            }
            
            public void UpdateData(IList<TitleData> items)
            {
                UpdateContents(items);
            }

            public void ScrollTo(int index, float duration, Ease easing, Alignment alignment = Alignment.Middle)
            {
                UpdateSelection(index);
                ScrollTo(index, duration, easing, GetAlignment(alignment));
            }

            public void JumpTo(int index, Alignment alignment = Alignment.Middle)
            {
                UpdateSelection(index);
                JumpTo(index, GetAlignment(alignment));
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
            public Tuple<byte,string> Data { get; set; }

            public TitleData(Tuple<byte,string> data)
            {
                Data = data;
            }
        }

        public class TitleContext : FancyScrollRectContext
        {
            public int SelectedIndex { get; set; } = -1;
            public CAction<byte> OnCellClicked { get; set; }
        }
    }
}