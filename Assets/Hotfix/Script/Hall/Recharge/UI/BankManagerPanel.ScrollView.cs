using System.Collections.Generic;
using EasingCore;
using FancyScrollView;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Recharge
{
    public partial class BankManagerPanel
    {
        public class ScrollView : FancyScrollRect<Data, Context>
        {
            private GameObject _cellPrefab;
            protected override GameObject CellPrefab => _cellPrefab;
            private float _cellSize;
            protected override float CellSize => _cellSize;

            public void Init(List<Data> items, CAction<BankBaseSaveData> callback, CAction<string> deleteCall)
            {
                _cellPrefab = transform.Find("Item").gameObject;
                _cellPrefab.CreateOrGetComponent<UIItem>();
                cellContainer ??= transform.FindChildDepth("View/Content");
                _cellSize = _cellPrefab.GetComponent<RectTransform>().rect.height;
                int index = -1;
                if (items.Count > 0) index = items.FindIndex(p => p.SaveData.isSelect);

                UpdateData(items);
                Context.OnCellClicked = callback;
                Context.OnDeleteCall = deleteCall;
                Context.SelectedIndex = index;
                ScrollTo(index >= 0 ? index : 0, 0f, Ease.InOutQuint, Alignment.Upper, index >= 0);
                if (items.Count > 0 && index >= 0) Context.OnCellClicked?.Invoke(items[index].SaveData);
            }

            public void ScrollTo(int index, float duration, Ease easing, Alignment alignment = Alignment.Middle,
                bool changeIndex = true)
            {
                UpdateSelection(index, changeIndex);
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

            void UpdateSelection(int index, bool changeIndex)
            {
                if (Context.SelectedIndex == index)
                {
                    return;
                }

                if (changeIndex) Context.SelectedIndex = index;
                Refresh();
            }
        }

        public class Data
        {
            public RechageData RechageData { get; set; }
            public BankBaseSaveData SaveData { get; set; }

            public Data(BankBaseSaveData data, RechageData rechageData)
            {
                SaveData = data;
                RechageData = rechageData;
            }
        }

        public class Context : FancyScrollRectContext
        {
            public int SelectedIndex { get; set; } = -1;
            public CAction<BankBaseSaveData> OnCellClicked;
            public CAction<string> OnDeleteCall;
        }

        public class UIItem : FancyScrollRectCell<Data, Context>
        {
            private Toggle selectBtn;
            private Toggle selectTog;
            private TextMeshProUGUI account;
            private TextMeshProUGUI holder;
            private TextMeshProUGUI wallet;
            private Button deleteBtn;

            private Data _data;

            public override void Initialize()
            {
                base.Initialize();
                selectBtn ??= transform.GetComponent<Toggle>();
                selectTog ??= transform.FindChildDepth<Toggle>("SelectToggle");
                account ??= transform.FindChildDepth<TextMeshProUGUI>("Account");
                holder ??= transform.FindChildDepth<TextMeshProUGUI>("Holder");
                wallet ??= transform.FindChildDepth<TextMeshProUGUI>("Wallet");
                deleteBtn ??= transform.FindChildDepth<Button>("HandeBtn");

                selectBtn.onValueChanged.RemoveAllListeners();
                selectBtn.onValueChanged.Add(OnSelectCall);
                deleteBtn.onClick.RemoveAllListeners();
                deleteBtn.onClick.Add(OnDeleteCall);
            }

            private void OnDeleteCall()
            {
                Context.OnDeleteCall?.Invoke(_data.SaveData.uid);
            }

            private void OnSelectCall(bool isOn)
            {
                if (Context.SelectedIndex == Index) return;
                if (!isOn) return;
                Context.SelectedIndex = Index;
                Context.OnCellClicked?.Invoke(_data.SaveData);
            }

            public override void UpdateContent(Data itemData)
            {
                _data = itemData;
                account.SetText(_data.SaveData.account);
                holder.SetText(_data.SaveData.holderName);
                wallet.SetText(_data.RechageData.name);
                bool isSelect = Context.SelectedIndex == Index;
                selectTog.SetIsOnWithoutNotify(isSelect);
                selectBtn.SetIsOnWithoutNotify(isSelect);
            }
        }
    }
}