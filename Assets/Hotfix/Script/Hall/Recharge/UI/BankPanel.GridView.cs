using System.Collections.Generic;
using EasingCore;
using FancyScrollView;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Recharge
{
    public partial class BankPanel
    {
        public class GridView : FancyGridView<DataArr, Context>
        {
            class CellGroup : DefaultCellGroup
            {
            }

            private UIItem _cellPrefab;
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

            public void Init(List<DataArr> items, CAction<bool, RechargeArray> callback, RechargeArray current)
            {
                DebugHelper.LogError($"数据个数:{items.Count}");

                _cellPrefab = transform.Find("Item").gameObject.CreateOrGetComponent<UIItem>();
                cellContainer ??= transform.FindChildDepth("View/Content");
                var rect = _cellPrefab.GetComponent<RectTransform>().rect;
                cellSize = new Vector2(rect.width, rect.height);
                startAxisCellCount = 4;
                PaddingTop = 10;
                PaddingBottom = 10;
                SpacingX = 20;
                SpacingY = 10;

                UpdateData(items);
                Context.OnCellClickedArr = callback;
                int index = items.FindIndex(p => p.RechageDataArr.id == current.id);
                ScrollTo(index >= 0 ? index : 0, 0f, Ease.InOutQuint, Alignment.Upper);
                Context.OnCellClickedArr?.Invoke(true, current);
            }

            //public void Init(List<Data> items, CAction<bool, RechageData> callback, RechageData current)
            //{
            //    _cellPrefab = transform.Find("Item").gameObject.CreateOrGetComponent<UIItem>();
            //    cellContainer ??= transform.FindChildDepth("View/Content");
            //    var rect = _cellPrefab.GetComponent<RectTransform>().rect;
            //    cellSize = new Vector2(rect.width, rect.height);
            //    startAxisCellCount = 4;
            //    PaddingTop = 10;
            //    PaddingBottom = 10;
            //    SpacingX = 20;
            //    SpacingY = 10;

            //    UpdateData(items);
            //    Context.OnCellClicked = callback;
            //    int index = items.FindIndex(p => p.RechageData.id == current.id && p.RechageData.pid == current.pid);
            //    ScrollTo(index, 0f, Ease.InOutQuint, Alignment.Upper);
            //    if (items.Count > 0) Context.OnCellClicked?.Invoke(true, current);
            //}

            public void ScrollTo(int index, float duration, Ease easing, Alignment alignment = Alignment.Middle)
            {
                UpdateSelection(index);
                ScrollTo(index, duration, easing, GetAlignment(alignment));
            }


            //public void UpdateData(IList<Data> items)
            //{
            //    UpdateContents(items);
            //}
            public void UpdateData(IList<DataArr> items)
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
            public int SubChannelID { get; set; }
            public RechageData RechageData { get; set; }

            public Data(int subChannelId, RechageData data)
            {
                SubChannelID = subChannelId;
                RechageData = data;
            }
        }

        public class DataArr
        {
            public int SubChannelID { get; set; }
            public RechargeArray RechageDataArr { get; set; }

            public DataArr(int subChannelId, RechargeArray data)
            {
                SubChannelID = subChannelId;
                RechageDataArr = data;
            }
        }

        public class Context : FancyGridViewContext
        {
            public int SelectedIndex { get; set; } = -1;
            public CAction<bool,RechageData> OnCellClicked;
            public CAction<bool, RechargeArray> OnCellClickedArr;
        }

        public class UIItem : FancyGridViewCell<DataArr, Context>
        {
            private TextMeshProUGUI desc;
            private Button tog;
            private DataArr data;
            private Transform tagGroup;
            private GameObject selectObj;
            
            public override void Initialize()
            {
                base.Initialize();
                desc ??= transform.FindChildDepth<TextMeshProUGUI>("Label");
                tog ??= transform.GetComponent<Button>();
                tog.onClick.RemoveAllListeners();
                tog.onClick.Add(OnSelectChannel);
                tagGroup ??= transform.FindChildDepth("Tag");
                selectObj ??= transform.FindChildDepth("Checkmark").gameObject;
            }

            private void OnSelectChannel()
            {
                if (Context.SelectedIndex == Index) return;
                Context.SelectedIndex = Index;
                Context.OnCellClickedArr?.Invoke(false,data.RechageDataArr);
            }

            public override void UpdateContent(DataArr itemData)
            {
                data = itemData;
                bool isSelect = Index == Context.SelectedIndex;
                selectObj.SetActive(isSelect);
                desc.SetText(data.RechageDataArr.channel_name);
                if (data.RechageDataArr.types == null || data.RechageDataArr.types.Count <= 0)
                {
                    tagGroup.gameObject.SetActive(false);
                    return;
                }

                tagGroup.gameObject.SetActive(true);
                RechageData rechageData = data.RechageDataArr.types[0];
                for (int i = 0; i < tagGroup.childCount; i++)
                {
                    tagGroup.GetChild(i).gameObject.SetActive(rechageData.isLabel == i);
                }
            }
        }
    }
}