using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using EasingCore;
using FancyScrollView;
using UnityEngine;

namespace Hotfix.Hall
{
    public partial class HallGameShow
    {
        public class MenuItemScrollView : FancyScrollRect<MenuItemData, MenuItemContext>
        {
            [SerializeField] float cellSize = 80f;
            [SerializeField] GameObject cellPrefab = default;

            protected override float CellSize => cellSize;
            protected override GameObject CellPrefab => cellPrefab;
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

            public void Init(List<MenuItemData> items,CAction<string> callback)
            {
                cellPrefab = transform.Find($"Viewport/GameItem").gameObject;
                cellPrefab.CreateOrGetComponent<HallMenuItem>();
                cellContainer ??= transform.FindChildDepth($"Viewport/Content");
                cellSize = cellPrefab.GetComponent<RectTransform>().rect.height;

                UpdateData(items);
                Context.TagCount = items.Count;
                Context.OnCellClicked = callback;
                ScrollTo(0, 0f, Ease.InOutQuint, Alignment.Upper);
                Context.OnCellClicked?.Invoke(items[0].Tag);
            }
            
            public void UpdateData(IList<MenuItemData> items)
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

        [System.Serializable]
        public class MenuItemData
        {
            public string Tag { get; set; }
            public List<int> GameList { get; set; }

            public MenuItemData(string tag, List<int> list)
            {
                Tag = tag;
                GameList = list;
            }
        }

        public class MenuItemContext : FancyScrollRectContext
        {
            public int SelectedIndex = -1;
            public CAction<string> OnCellClicked;
            public int TagCount { get; set; }
        }
    }
}