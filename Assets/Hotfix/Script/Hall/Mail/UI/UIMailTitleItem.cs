using System;
using FancyScrollView;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Mail
{
    public class UIMailTitleItem : FancyScrollRectCell<UIMail.TitleData, UIMail.TitleContext>
    {
        private GameObject unselect;
        private GameObject select;
        private TextMeshProUGUI title;
        private Button btn;
        private bool isInit;
        private UIMail.TitleData Data;
        
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
            Context.OnCellClicked?.Invoke(Data.Mail);
        }

        public override void UpdateContent(UIMail.TitleData itemData)
        {
            Data = itemData;
            select.SetActive(Index == Context.SelectedIndex);
            unselect.SetActive(Index != Context.SelectedIndex);
            title.SetText(Data.Mail.strTitle);
        }
    }
}