using System.Collections.Generic;
using EasingCore;
using FancyScrollView;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Recharge
{
    public partial class RechargeState
    {
        public class ChannelScrollView : FancyScrollRect<ChannelData, ChannelContext>
        {
            private GameObject _cellPrefab;
            protected override GameObject CellPrefab => _cellPrefab;
            private float _cellSize;
            protected override float CellSize => _cellSize;

            public void Init(List<ChannelData> items, CAction<int> callback)
            {
                _cellPrefab = transform.Find("Item").gameObject;
                _cellPrefab.CreateOrGetComponent<ChannelItem>();
                cellContainer ??= transform.FindChildDepth("View/Content");
                _cellSize = _cellPrefab.GetComponent<RectTransform>().rect.width;

                UpdateData(items);
                Context.OnCellClicked = callback;
                ScrollTo(0, 0f, Ease.InOutQuint, Alignment.Upper);
                if (items.Count > 0) Context.OnCellClicked?.Invoke(items[0].ChannelID);
            }

            public void ScrollTo(int index, float duration, Ease easing, Alignment alignment = Alignment.Middle)
            {
                UpdateSelection(index);
                ScrollTo(index, duration, easing, GetAlignment(alignment));
            }

            public void UpdateData(IList<ChannelData> items)
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

        public class ChannelData
        {
            public int ChannelID { get; set; }
            public RechargeArray RechageDatas { get; set; }

            public ChannelData(int channelId, RechargeArray datas)
            {
                ChannelID = channelId;
                RechageDatas = datas;
            }
        }

        public class ChannelContext : FancyScrollRectContext
        {
            public int SelectedIndex { get; set; } = -1;
            public CAction<int> OnCellClicked { get; set; }
        }
    }

    public class ChannelItem : FancyScrollRectCell<RechargeState.ChannelData, RechargeState.ChannelContext>
    {
        private Toggle tog;
        private RechargeState.ChannelData Data { get; set; }
        private TextMeshProUGUI label;

        private Transform tagGroup;
        public override void Initialize()
        {
            base.Initialize();
            tog ??= transform.GetComponent<Toggle>();
            tog.SetIsOnWithoutNotify(false);
            tog.onValueChanged.RemoveAllListeners();
            tog.onValueChanged.Add(OnToggleSelect);
            label = transform.FindChildDepth<TextMeshProUGUI>("Label");
            tagGroup ??= transform.FindChildDepth("Tag");
        }

        private void OnToggleSelect(bool isOn)
        {
            if (Context.SelectedIndex == Index) return;
            if (!isOn) return;
            Context.SelectedIndex = Index;
            Context.OnCellClicked?.Invoke(Data.ChannelID);
        }

        public override void UpdateContent(RechargeState.ChannelData itemData)
        {
            Data = itemData;
            bool isSelect = Index == Context.SelectedIndex;
            label.SetText(Data.RechageDatas.channel_name);
            tog.SetIsOnWithoutNotify(isSelect);
            for (int i = 0; i < tagGroup.childCount; i++)
            {
                tagGroup.GetChild(i).gameObject.SetActive(Data.RechageDatas.types[0].isLabel == i);
            }
        }
    }
}