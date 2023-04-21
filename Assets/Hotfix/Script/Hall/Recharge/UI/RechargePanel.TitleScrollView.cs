using System.Collections.Generic;
using EasingCore;
using FancyScrollView;
using Hotfix.Hall;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Recharge
{
    public partial class RechargePanel
    {
        public class TitleScrollView : FancyScrollRect<TitleData, TitleContext>
        {
            private GameObject _cellPrefab;
            protected override GameObject CellPrefab => _cellPrefab;
            private float _cellSize;
            protected override float CellSize => _cellSize;

            public void Init(List<TitleData> items, CAction<int> callback, int startIndex = 0)
            {
                _cellPrefab = transform.Find("TitleItem").gameObject;
                _cellPrefab.CreateOrGetComponent<UITitleItem>();
                cellContainer ??= transform.FindChildDepth("Viewport/Content");
                _cellSize = _cellPrefab.GetComponent<RectTransform>().rect.height;

                UpdateData(items);
                Context.OnCellClicked = callback;
                ScrollTo(startIndex, 0f, Ease.InOutQuint, Alignment.Upper);
                if (items.Count > 0) Context.OnCellClicked?.Invoke(startIndex);
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
            public string Title { get; set; }

            public TitleData(string title)
            {
                Title = title;
            }
        }

        public class TitleContext : FancyScrollRectContext
        {
            public int SelectedIndex { get; set; } = -1;
            public CAction<int> OnCellClicked;
        }

        public class UITitleItem : FancyScrollRectCell<TitleData, TitleContext>
        {
            private GameObject unselect;
            private GameObject select;
            private TextMeshProUGUI title;
            private Button btn;
            private bool isInit;
            private TitleData Data;

            public override void Initialize()
            {
                base.Initialize();
                title ??= transform.FindChildDepth<TextMeshProUGUI>("Title");
                unselect ??= transform.FindChildDepth("UnSelect").gameObject;
                select ??= transform.FindChildDepth("Select").gameObject;
                btn ??= GetComponent<Button>();
                btn.onClick.RemoveAllListeners();
                btn.onClick.Add(OnClickSelect);
            }

            private void OnClickSelect()
            {
                if (Context.SelectedIndex == Index) return; //点击自己

                Context.SelectedIndex = Index;
                Context.OnCellClicked?.Invoke(Index);
            }

            public override void UpdateContent(TitleData itemData)
            {
                Data = itemData;
                bool isSelect = Index == Context.SelectedIndex;
                select.SetActive(isSelect);
                unselect.SetActive(!isSelect);
                title.SetText(Data.Title);
                ColorUtility.TryParseHtmlString(isSelect ? "#fdfad0" : "#a48552", out var color);
                title.color = color;
            }
        }
    }
}