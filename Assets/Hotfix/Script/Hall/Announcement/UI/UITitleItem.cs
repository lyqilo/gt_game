using System;
using FancyScrollView;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Announcement
{
    public class UITitleItem : FancyScrollRectCell<AnnouncementPanel.TitleData, AnnouncementPanel.TitleContext>
    {
        private GameObject unselect;
        private GameObject select;
        private TextMeshProUGUI title;
        private Button btn;
        private bool isInit;
        private AnnouncementPanel.TitleData Data;
        
        public override void Initialize()
        {
            base.Initialize();
            FindComponent();
            btn.onClick.RemoveAllListeners();
            btn.onClick.Add(OnClickSelectMail);
        }

        private void FindComponent()
        {
            if (isInit) return;
            isInit = true;
            title = transform.FindChildDepth<TextMeshProUGUI>("MailTitle");
            unselect = transform.FindChildDepth("UnSelect").gameObject;
            select = transform.FindChildDepth("Select").gameObject;
            btn = GetComponent<Button>();
        }

        private void OnClickSelectMail()
        {
            if (Context.SelectedIndex == Index) return;//点击自己
            
            Context.SelectedIndex = Index;
            Context.OnCellClicked?.Invoke(Data.Data);
        }

        public override void UpdateContent(AnnouncementPanel.TitleData itemData)
        {
            Data = itemData;
            bool isSelect = Index == Context.SelectedIndex;
            select.SetActive(isSelect);
            unselect.SetActive(!isSelect);
            title.SetText(Data.Data.title);
            ColorUtility.TryParseHtmlString(isSelect ? "#5a3116" : "#fdfad0", out var color);
            title.color = color;
        }
    }
}