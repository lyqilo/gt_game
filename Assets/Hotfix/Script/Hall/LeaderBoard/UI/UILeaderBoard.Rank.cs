using System.Collections.Generic;
using EasingCore;
using FancyScrollView;
using Hotfix.Hall;
using UnityEngine;

namespace Hotfix.Hall.LeaderBoard
{
    public partial class UILeaderBoard
    {
        public class RankScrollView : FancyScrollRect<RankCellData, RankContentData>
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

            public void Init(List<RankCellData> items, CAction<HallStruct.LeaderBoard.sRankItem> callback = null)
            {
                _cellPrefab = transform.parent.Find($"UIRankItem").gameObject;
                _cellPrefab.CreateOrGetComponent<UILeaderBoardItem>();
                cellContainer ??= transform.FindChildDepth($"Viewport/Content");
                _cellSize = _cellPrefab.GetComponent<RectTransform>().rect.height;
                PaddingTop = 5;
                PaddingBottom = 5;
                Spacing = 10;
                UpdateData(items);
                Relayout();
                Context.OnCellClicked = callback;
                ScrollTo(0, 0f, Ease.InOutQuint, Alignment.Upper);
                if (items.Count > 0) Context.OnCellClicked?.Invoke(items[0].ItemData);
            }

            public void UpdateData(IList<RankCellData> items)
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

        public class RankCellData
        {
            public int UserId { get; set; }
            public int Rank { get; set; }
            public HallStruct.LeaderBoard.sRankItem ItemData { get; set; }

            public RankCellData(HallStruct.LeaderBoard.sRankItem item, int rank)
            {
                UserId = item.nUserID;
                ItemData = item;
                Rank = rank;
            }
        }

        public class RankContentData : FancyScrollRectContext
        {
            public int SelectedIndex { get; set; } = -1;
            public CAction<HallStruct.LeaderBoard.sRankItem> OnCellClicked { get; set; }
        }
    }
}