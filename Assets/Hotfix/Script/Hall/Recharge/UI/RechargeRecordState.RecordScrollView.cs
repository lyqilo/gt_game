using System.Collections.Generic;
using EasingCore;
using FancyScrollView;
using TMPro;
using UnityEngine;

namespace Hotfix.Hall.Recharge
{
    public partial class RechargeRecordState
    {
        public class RecordScrollView : FancyScrollRect<RecordData, RecordContext>
        {
            private GameObject _cellPrefab;
            protected override GameObject CellPrefab => _cellPrefab;
            private float _cellSize;
            protected override float CellSize => _cellSize;

            public void Init(List<RecordData> items, CAction<int> callback)
            {
                _cellPrefab = transform.Find("Item").gameObject;
                _cellPrefab.CreateOrGetComponent<UIRecordItem>();
                cellContainer ??= transform.FindChildDepth("View/Content");
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

            public void UpdateData(IList<RecordData> items)
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

        public class RecordData
        {
            public CommonRecordData Data { get; set; }

            public RecordData(CommonRecordData data)
            {
                Data = data;
            }
        }

        public class RecordContext : FancyScrollRectContext
        {
            public int SelectedIndex { get; set; } = -1;
            public CAction<int> OnCellClicked;
        }

        public class UIRecordItem : FancyScrollRectCell<RecordData, RecordContext>
        {
            private TextMeshProUGUI timeTxt;
            private TextMeshProUGUI amount;
            private TextMeshProUGUI resultState;
            private TextMeshProUGUI getgold;

            public override void Initialize()
            {
                base.Initialize();
                timeTxt ??= transform.FindChildDepth<TextMeshProUGUI>("Time");
                amount ??= transform.FindChildDepth<TextMeshProUGUI>("Amount");
                resultState ??= transform.FindChildDepth<TextMeshProUGUI>("Results");
                getgold ??= transform.FindChildDepth<TextMeshProUGUI>("GetGold");
            }
            public override void UpdateContent(RecordData itemData)
            {
                timeTxt.SetText(itemData.Data.createTime);
                amount.SetText(itemData.Data.amount);
                switch (itemData.Data.orderStatus)
                {
                    case 1:
                        resultState.SetText("Waiting");
                        break;
                    case 2:
                        resultState.SetText("Succeed");
                        break;
                    case 3:
                        resultState.SetText("Failed");
                        break;
                }

                getgold.SetText(itemData.Data.gold.ShortNumber());
            }
        }
    }
}