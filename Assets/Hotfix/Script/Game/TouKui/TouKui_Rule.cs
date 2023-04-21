using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.TouKui
{
    public class TouKui_Rule:ILHotfixEntity
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
            base.FindComponent();
            ruleList = transform.FindChildDepth("Content/RuleList"); //规则子界面
            ruleTogGroup = transform.FindChildDepth("Content/Group"); //规则子界面
            leftShowBtn = transform.FindChildDepth<Button>("Content/LeftBtn");
            rightShowBtn = transform.FindChildDepth<Button>("Content/RightBtn");
            closeRuleBtn = transform.FindChildDepth<Button>("Content/BackBtn");
            for (int i = 0; i < ruleList.childCount; i++)
            {
                ruleList.GetChild(i).gameObject.SetActive(false);
                ruleTogGroup.GetChild(i).GetComponent<Toggle>().isOn = false;
            }
            ruleList.GetChild(0).gameObject.SetActive(true);
            ruleTogGroup.GetChild(0).GetComponent<Toggle>().isOn = true;
        }
        private void AddListener()
        {
            currentPos = 0;
            totalPos = ruleList.childCount;
            closeRuleBtn.onClick.RemoveAllListeners();
            closeRuleBtn.onClick.Add(CloseRule);
            leftShowBtn.onClick.RemoveAllListeners();
            leftShowBtn.onClick.Add(ClickLeftBtn);
            rightShowBtn.onClick.RemoveAllListeners();
            rightShowBtn.onClick.Add(ClickRightBtn);
        }

        private void ClickRightBtn()
        {
            TouKui_Audio.Instance.PlaySound(TouKui_Audio.BTN);
            ruleList.GetChild(currentPos).gameObject.SetActive(false);
            currentPos ++;
            if (currentPos >= totalPos)
            {
                currentPos = 0;
            }
            ruleList.GetChild(currentPos).gameObject.SetActive(true);
            ruleTogGroup.GetChild(currentPos).GetComponent<Toggle>().isOn = true;
        }

        private void ClickLeftBtn()
        {
            TouKui_Audio.Instance.PlaySound(TouKui_Audio.BTN);
            ruleList.GetChild(currentPos).gameObject.SetActive(false);
            currentPos --;
            if (currentPos < 0)
            {
                currentPos = totalPos - 1;
            }
            ruleList.GetChild(currentPos).gameObject.SetActive(true);
            ruleTogGroup.GetChild(currentPos).GetComponent<Toggle>().isOn = true;
        }

        private void CloseRule()
        {
            TouKui_Audio.Instance.PlaySound(TouKui_Audio.BTN);
            gameObject.SetActive(false);
        }
    }
}
