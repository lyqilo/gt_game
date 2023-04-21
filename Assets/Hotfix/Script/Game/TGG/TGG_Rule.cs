using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.TGG
{
    public class TGG_Rule : ILHotfixEntity
    {
        Transform ruleList;
        Button BackBtn;
        int currentPos;
        int totalPos;

        protected override void Awake()
        {
            base.Awake();
            AddListener();
        }

        protected override void OnEnable()
        {
            ruleList.GetComponent<ScrollRect>().horizontalNormalizedPosition = 0;

        }

        protected override void FindComponent()
        {
            ruleList = this.transform.FindChildDepth("Content/RuleList");
            BackBtn = this.transform.FindChildDepth<Button>("Content/BackBtn");
        }
        private void AddListener()
        {
            currentPos = 0;
            totalPos = ruleList.childCount;
            BackBtn.onClick.RemoveAllListeners();
            BackBtn.onClick.Add(CloseRule);
        }

        private void ClickRightBtn()
        {
            TGG_Audio.Instance.PlaySound(TGG_Audio.BTN);
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
            TGG_Audio.Instance.PlaySound(TGG_Audio.BTN);
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
            TGG_Audio.Instance.PlaySound(TGG_Audio.BTN);
            gameObject.SetActive(false);
        }
    }
}
