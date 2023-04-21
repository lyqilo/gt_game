using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.MJHL
{
    public class MJHL_Rule:ILHotfixEntity
    {
        private Transform ruleList;
        private Transform ruleTogGroup;
        private Button leftShowBtn;
        private Button rightShowBtn;
        private Button closeRuleBtn;
        private int currentPos;
        private int totalPos;

        protected override void Awake()
        {
            base.Awake();
            AddListener();
        }
        protected override void FindComponent()
        {
            //transform.GetComponent<Canvas>().sortingOrder = 30;
            ruleList = transform.FindChildDepth("Content/RuleList"); //规则子界面
            //leftShowBtn = transform.FindChildDepth<Button>("Content/LeftBtn");
            //rightShowBtn = transform.FindChildDepth<Button>("Content/RightBtn");
            closeRuleBtn = transform.FindChildDepth<Button>("Content/BackBtn");
            //ruleList.GetChild(0).gameObject.SetActive(true);
        }
        private void AddListener()
        {
            currentPos = 0;
            totalPos = ruleList.childCount;
            closeRuleBtn.onClick.RemoveAllListeners();
            closeRuleBtn.onClick.Add(CloseRule);

            //leftShowBtn.onClick.RemoveAllListeners();
            //leftShowBtn.onClick.Add(ClickLeftBtn);

            //rightShowBtn.onClick.RemoveAllListeners();
            //rightShowBtn.onClick.Add(ClickRightBtn);
        }

        private void ClickRightBtn()
        {
            MJHL_Audio.Instance.PlaySound(MJHL_Audio.BTN);
            ruleList.GetChild(currentPos).gameObject.SetActive(false);
            currentPos ++;
            if (currentPos >= totalPos)
            {
                currentPos = 0;
            }
            ruleList.GetChild(currentPos).gameObject.SetActive(true);
        }

        private void ClickLeftBtn()
        {
            MJHL_Audio.Instance.PlaySound(MJHL_Audio.BTN);
            ruleList.GetChild(currentPos).gameObject.SetActive(false);
            currentPos --;
            if (currentPos < 0)
            {
                currentPos = totalPos - 1;
            }
            ruleList.GetChild(currentPos).gameObject.SetActive(true);
        }

        private void CloseRule()
        {
            MJHL_Audio.Instance.PlaySound(MJHL_Audio.BTN);
            gameObject.SetActive(false);
        }
    }
}
