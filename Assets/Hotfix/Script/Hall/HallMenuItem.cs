using System.Collections.Generic;
using FancyScrollView;
using UnityEngine;
using UnityEngine.U2D;
using UnityEngine.UI;

namespace Hotfix.Hall
{
    public class HallMenuItem : FancyScrollRectCell<HallGameShow.MenuItemData, HallGameShow.MenuItemContext>
    {
        private Button clickBtn;
        private GameObject select;
        private Image selectImg;
        private GameObject unSelect;
        private Image unSelectImg;

        private GameObject line;
        private bool isInit;

        private HallGameShow.MenuItemData Data;
        private SpriteAtlas _atlas;

        public override void Initialize()
        {
            InitComponent();
            clickBtn = transform.GetComponent<Button>();
            clickBtn.onClick.RemoveAllListeners();
            clickBtn.onClick.Add(OnClickMenu);
            _atlas ??= ToolHelper.LoadAsset<SpriteAtlas>(SceneType.Hall, "Hall_Title");
        }

        private void InitComponent()
        {
            if (isInit) return;
            isInit = true;
            select = transform.FindChildDepth($"Select").gameObject;
            selectImg = select.transform.FindChildDepth<Image>($"GroupName");
            unSelect = transform.FindChildDepth($"UnSelect").gameObject;
            unSelectImg = unSelect.transform.FindChildDepth<Image>($"GroupName");
            line = transform.FindChildDepth($"Line").gameObject;
        }

        public override void UpdateContent(HallGameShow.MenuItemData itemData)
        {
            Data = itemData;
            line.SetActive(Index < Context.TagCount - 1);
            select.SetActive(Index == Context.SelectedIndex);
            unSelect.SetActive(Index != Context.SelectedIndex);
            selectImg.sprite = _atlas.GetSprite($"dating_title_{itemData.Tag}_Select");
            unSelectImg.sprite = _atlas.GetSprite($"dating_title_{itemData.Tag}_UnSelect");
        }

        private void OnClickMenu()
        {
            if (Context.SelectedIndex == Index) return; //点击自己

            Context.SelectedIndex = Index;
            Context.OnCellClicked?.Invoke(Data.Tag);
        }
    }
}