using System.Collections.Generic;
using EasingCore;
using FancyScrollView;
using UnityEngine;

namespace Hotfix.Hall.Recharge
{
    public partial class RechargeState
    {
        public class SubChannelGridView : FancyGridView<SubChannelData, SubChannelContext>
        {
            class CellGroup : DefaultCellGroup
            {
            }

            private SubChannelItem _cellPrefab;
            protected override void SetupCellTemplate() => Setup<CellGroup>(_cellPrefab);

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

            public float SpacingY
            {
                get => spacing;
                set
                {
                    spacing = value;
                    Relayout();
                }
            }

            public float SpacingX
            {
                get => startAxisSpacing;
                set
                {
                    startAxisSpacing = value;
                    Relayout();
                }
            }

            public void Init(List<SubChannelData> items, CAction<RechageData> callback)
            {
                _cellPrefab = transform.Find("Item").gameObject.CreateOrGetComponent<SubChannelItem>();
                cellContainer ??= transform.FindChildDepth("View/Content");
                var rect = _cellPrefab.GetComponent<RectTransform>().rect;
                cellSize = new Vector2(rect.width, rect.height);
                startAxisCellCount = 4;
                PaddingTop = 10;
                PaddingBottom = 10;
                SpacingX = 20;
                SpacingY = 10;

                UpdateData(items);
                Context.OnCellClicked = callback;
                ScrollTo(0, 0f, Ease.InOutQuint, Alignment.Upper);
                if (items.Count > 0) Context.OnCellClicked?.Invoke(items[0].RechageData);
            }

            public void UpdateSelection(int index)
            {
                if (Context.SelectedIndex == index)
                {
                    return;
                }

                Context.SelectedIndex = index;
                Refresh();
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

            public void UpdateData(IList<SubChannelData> items)
            {
                UpdateContents(items);
            }

            public void RefreshData()
            {
                Refresh();
            }
        }

        public class SubChannelData
        {
            public int SubChannelID { get; set; }
            public RechageData RechageData { get; set; }

            public SubChannelData(int subChannelId,RechageData data)
            {
                SubChannelID = subChannelId;
                RechageData = data;
            }
        }

        public class SubChannelContext : FancyGridViewContext
        {
            public int SelectedIndex { get; set; } = -1;
            public CAction<RechageData> OnCellClicked { get; set; }
        }
    }
}