using FancyScrollView;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Recharge
{
    public class SubChannelItem : FancyGridViewCell<RechargeState.SubChannelData, RechargeState.SubChannelContext>
    {
        private Toggle tog;
        private RechargeState.SubChannelData Data { get; set; }
        private TextMeshProUGUI label;
        public override void Initialize()
        {
            base.Initialize();
            tog ??= transform.GetComponent<Toggle>();
            tog.SetIsOnWithoutNotify(false);
            tog.onValueChanged.RemoveAllListeners();
            tog.onValueChanged.Add(OnToggleSelect);
            label = transform.FindChildDepth<TextMeshProUGUI>("Label");
        }

        private void OnToggleSelect(bool isOn)
        {
            if (Context.SelectedIndex == Index) return;
            if (!isOn) return;
            Context.SelectedIndex = Index;
            Context.OnCellClicked?.Invoke(Data.RechageData);
        }

        public override void UpdateContent(RechargeState.SubChannelData itemData)
        {
            Data = itemData;
            bool isSelect = Index == Context.SelectedIndex;
            label.SetText(Data.RechageData.name);
            tog.SetIsOnWithoutNotify(isSelect);
        }
    }
}