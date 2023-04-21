using UnityEngine.UI;

namespace Hotfix.WPBY
{
    public class WPBY_Rule : SingletonILEntity<WPBY_Rule>
    {
        int lastRollState = 0;
        int currentPos = 0;
        int totalPos = 0;
        ScrollRect ruleList;
        private Button closeRuleBtn;
        private Button leftShowBtn;
        private Button rightShowBtn;
        private Button closeRuleBtn1;

        public void Create()
        {
            this.currentPos = 0;
            this.ruleList = WPBYEntry.Instance.rulePanel.FindChildDepth<ScrollRect>("Content/RuleList");
            this.closeRuleBtn = WPBYEntry.Instance.rulePanel.FindChildDepth<Button>("Content/BackBtn");
            this.leftShowBtn = WPBYEntry.Instance.rulePanel.FindChildDepth<Button>("Content/LeftBtn");
            this.rightShowBtn = WPBYEntry.Instance.rulePanel.FindChildDepth<Button>("Content/RightBtn");
            this.closeRuleBtn1 = WPBYEntry.Instance.rulePanel.FindChildDepth<Button>("Content/FanHuiBtn");
            this.totalPos = this.ruleList.content.childCount;
            this.ruleList.horizontalNormalizedPosition = 0;
            this.closeRuleBtn.onClick.RemoveAllListeners();
            this.closeRuleBtn.onClick.Add(this.CloseRule);
            this.closeRuleBtn1.onClick.RemoveAllListeners();
            this.closeRuleBtn1.onClick.Add(this.CloseRule);
            this.leftShowBtn.onClick.RemoveAllListeners();
            this.leftShowBtn.onClick.Add(this.ClickLeftBtn);
            this.rightShowBtn.onClick.RemoveAllListeners();
            this.rightShowBtn.onClick.Add(this.ClickRightBtn);
            this.leftShowBtn.interactable = false;
        }
        public void ShowRule()
        {
            WPBYEntry.Instance.openMoveGroup.isOn = false;
            WPBYEntry.Instance.moveGroup.gameObject.SetActive(false);
            WPBYEntry.Instance.rulePanel.gameObject.SetActive(true);
        }
        private void CloseRule()
        {
            WPBYEntry.Instance.rulePanel.gameObject.SetActive(false);
        }
        private void ClickLeftBtn()
        {
            if (this.currentPos == this.totalPos - 1)
            {
                this.rightShowBtn.interactable = true;
            }
            this.currentPos--;
            this.ruleList.horizontalNormalizedPosition = this.currentPos / (float)(this.totalPos - 1);
            if (this.currentPos <= 0)
            {
                this.currentPos = 0;
                this.leftShowBtn.interactable = false;
                return;
            }
        }
        private void ClickRightBtn()
        {
            if (this.currentPos == 0)
            {
                this.leftShowBtn.interactable = true;
            }
            this.currentPos++;
            this.ruleList.horizontalNormalizedPosition = this.currentPos / (float)(this.totalPos - 1);
            if (this.currentPos >= this.totalPos - 1)
            {
                this.currentPos = this.totalPos - 1;
                this.rightShowBtn.interactable = false;
                return;
            }
        }
    }
}
