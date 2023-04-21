using FancyScrollView;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.LeaderBoard
{
    public class UILeaderBoardTitleItem : FancyScrollRectCell<UILeaderBoard.TitleData, UILeaderBoard.TitleContext>
    {
        private GameObject unselect;
        private GameObject select;
        private TextMeshProUGUI title;
        private Button btn;
        private bool isInit;
        private UILeaderBoard.TitleData Data;
        
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
            title = transform.FindChildDepth<TextMeshProUGUI>("RankTitle");
            unselect = transform.FindChildDepth("UnSelect").gameObject;
            select = transform.FindChildDepth("Select").gameObject;
            btn = GetComponent<Button>();
        }

        private void OnClickSelectMail()
        {
            if (Context.SelectedIndex == Index) return;//点击自己
            
            Context.SelectedIndex = Index;
            Context.OnCellClicked?.Invoke(Data.Data.Item1);
        }

        public override void UpdateContent(UILeaderBoard.TitleData itemData)
        {
            Data = itemData;
            bool isSelect = Index == Context.SelectedIndex;
            select.SetActive(isSelect);
            unselect.SetActive(!isSelect);
            title.SetText(Data.Data.Item2);
            ColorUtility.TryParseHtmlString(isSelect ? "#FFFFFF" : $"#A38451", out var color);
            title.color = color;
        }
    }
}