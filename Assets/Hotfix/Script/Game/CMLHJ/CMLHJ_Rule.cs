using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.CMLHJ
{
    public class CMLHJ_Rule : ILHotfixEntity
    {
        Transform content;
        Transform pages;
        Transform helpBtns;
        Button backBtn;
        Button leftBtn;
        Button rightBtn;
        Transform ruleList;
        int currentPos;
        int totalPos;

        protected override void Awake()
        {
            base.Awake();
            AddListener();
        }

        protected override void FindComponent()
        {
            content = this.transform.FindChildDepth("Content");
            pages = content.FindChildDepth("Pages");
            helpBtns = content.FindChildDepth("helpBtns");
            backBtn = helpBtns.FindChildDepth<Button>("closeBtn");
            leftBtn = helpBtns.FindChildDepth<Button>("leftBtn");
            rightBtn = helpBtns.FindChildDepth<Button>("rightBtn");
            ruleList = pages.FindChildDepth("Content"); //规则子界面
            ruleList.GetChild(0).gameObject.SetActive(true);
        }
        private void AddListener()
        {
            currentPos = 0;
            totalPos = ruleList.childCount;
            backBtn.onClick.RemoveAllListeners();
            backBtn.onClick.Add(CloseRule);

            leftBtn.onClick.RemoveAllListeners();
            leftBtn.onClick.Add(ClickLeftBtn);

            rightBtn.onClick.RemoveAllListeners();
            rightBtn.onClick.Add(ClickRightBtn);
        }

        private void ClickRightBtn()
        {
            CMLHJ_Audio.Instance.PlaySound(CMLHJ_Audio.BTN);
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
            CMLHJ_Audio.Instance.PlaySound(CMLHJ_Audio.BTN);
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
            CMLHJ_Audio.Instance.PlaySound(CMLHJ_Audio.BTN);
            gameObject.SetActive(false);
        }
    }
}
