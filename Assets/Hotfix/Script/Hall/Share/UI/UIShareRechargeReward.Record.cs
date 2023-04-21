using System.Collections.Generic;
using EasingCore;
using FancyScrollView;
using LuaFramework;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Share
{
    public partial class UIShareRechargeReward
    {
        public class ScrollView : FancyScrollRect<Data, Context>
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

            public void Init(List<Data> items)
            {
                _cellPrefab = transform.Find($"Item").gameObject;
                _cellPrefab.CreateOrGetComponent<Cell>();
                cellContainer ??= transform.FindChildDepth($"View/Content");
                _cellSize = _cellPrefab.GetComponent<RectTransform>().rect.height;
                UpdateData(items);
                Relayout();
                int index = 0;
                ScrollTo(index, 0f, Ease.InOutQuint, Alignment.Upper);
            }

            public void UpdateData(IList<Data> items)
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

        public class Data
        {
            public HallStruct.sQueryRebateRecordItem Cfg { get; set; }

            public Data(HallStruct.sQueryRebateRecordItem cfg)
            {
                Cfg = cfg;
            }
        }

        public class Context : FancyScrollRectContext
        {
            public int SelectedIndex { get; set; } = -1;
            public CAction SelectedCall { get; set; }
        }

        public class Cell : FancyScrollRectCell<Data, Context>
        {
            private TextMeshProUGUI Id;
            private TextMeshProUGUI recharge;
            private TextMeshProUGUI dividend;
            public override void Initialize()
            {
                base.Initialize();
                Id ??= transform.FindChildDepth<TextMeshProUGUI>("ID");
                recharge ??= transform.FindChildDepth<TextMeshProUGUI>("Recharge");
                dividend ??= transform.FindChildDepth<TextMeshProUGUI>("Dividend");
            }

            public override void UpdateContent(Data itemData)
            {
                Id.SetText(itemData.Cfg.RechargeUserID);
                recharge.SetText(itemData.Cfg.RechargeAmount);
                dividend.SetText(itemData.Cfg.Rebate);
            }
        }
    }
}