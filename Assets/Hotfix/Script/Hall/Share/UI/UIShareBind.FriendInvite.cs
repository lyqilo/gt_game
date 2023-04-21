using System.Collections.Generic;
using EasingCore;
using FancyScrollView;
using TMPro;
using UnityEngine;

namespace Hotfix.Hall.Share
{
    public partial class UIShareBind
    {
        public class ScrollView : FancyScrollRect<Data, Content>
        {
            private GameObject _cellPrefab;
            private float _cellSize;
            protected override GameObject CellPrefab => _cellPrefab;
            protected override float CellSize => _cellSize;

            public void Init(List<Data> items, CAction<int> callback = null)
            {
                _cellPrefab = transform.Find($"Item").gameObject;
                _cellPrefab.CreateOrGetComponent<Cell>();
                cellContainer ??= transform.FindChildDepth($"View/Content");
                _cellSize = _cellPrefab.GetComponent<RectTransform>().rect.height;

                UpdateData(items);
                Context.OnCellClicked = callback;
                ScrollTo(0, 0f, Ease.InOutQuint, Alignment.Upper);
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
            public int UserId { get; }

            public Data(int userId)
            {
                UserId = userId;
            }
        }

        public class Content : FancyScrollRectContext
        {
            public int SelectedIndex { get; set; } = -1;
            public CAction<int> OnCellClicked { get; set; }
        }

        public class Cell : FancyScrollRectCell<Data, Content>
        {
            private TextMeshProUGUI Id;
            public override void Initialize()
            {
                base.Initialize();
                Id ??= transform.FindChildDepth<TextMeshProUGUI>("ID");
            }

            public override void UpdateContent(Data itemData)
            {
                Id.SetText(itemData.UserId);
            }
        }
    }
}