using FancyScrollView;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Recharge
{
    public partial class FristRechargeBankPanel
    {
        public class SubChannelItem : FancyGridViewCell<SubChannelData, SubChannelContext>
        {
            private Button tog;
            private GameObject selectObj;
            private SubChannelData Data { get; set; }
            private TextMeshProUGUI label;

            public override void Initialize()
            {
                base.Initialize();
                tog ??= transform.GetComponent<Button>();
                tog.onClick.RemoveAllListeners();
                tog.onClick.Add(OnToggleSelect);
                label = transform.FindChildDepth<TextMeshProUGUI>("Label");
                selectObj = transform.FindChildDepth("Checkmark").gameObject;
            }

            private void OnToggleSelect()
            {
                if (Context.SelectedIndex == Index) return;
                Context.SelectedIndex = Index;
                Context.OnCellClicked?.Invoke(true, Data.RechageData);
            }

            public override void UpdateContent(SubChannelData itemData)
            {
                Data = itemData;
                bool isSelect = Index == Context.SelectedIndex;
                label.SetText(Data.RechageData.name);
                selectObj.SetActive(isSelect);
            }
        }
    }
}