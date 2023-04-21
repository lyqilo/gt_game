using System;
using FancyScrollView;
using TMPro;
using UnityEngine.U2D;
using UnityEngine.UI;

namespace Hotfix.Hall.ItemBox
{
    public class UIItemCell : FancyScrollRectCell<UIItemBox.Data,UIItemBox.Content>
    {
        public Image icon;
        public TextMeshProUGUI count;
        private SpriteAtlas _atlas;
        public override void Initialize()
        {
            base.Initialize();
            icon ??= transform.FindChildDepth<Image>("Icon");
            count ??= transform.FindChildDepth<TextMeshProUGUI>("Count");
            _atlas ??= ToolHelper.LoadAsset<SpriteAtlas>(SceneType.Hall, "Hall_Item");
        }

        public override void UpdateContent(UIItemBox.Data itemData)
        {
            icon.sprite = _atlas.GetSprite($"item_{itemData.ItemId}");
            icon.SetNativeSize();
            string countStr = string.Empty;
            switch ((ItemType)itemData.ItemId)
            {
                case ItemType.Coin:
                    countStr = itemData.ItemCount.ShortNumber();
                    break;
                case ItemType.SpinCount:
                    countStr = $"{itemData.ItemCount}";
                    break;
            }

            count.SetText($"X{countStr}");
        }
    }
}