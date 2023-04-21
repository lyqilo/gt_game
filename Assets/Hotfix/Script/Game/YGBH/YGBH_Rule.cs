using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.YGBH
{
    public class YGBH_Rule : ILHotfixEntity
    {
        Transform ruleList;
        Button BackBtn;
        Button leftShowBtn;
        Button rightShowBtn;

        Transform Content;
        int currentPos;
        int totalPos;
        private Transform zzb;
        private Transform swk;
        private Transform other;
        private Transform ld;
        private Transform zm;
        private Transform sz;
        private Transform scatter;
        private Transform wild;

        List<Transform> custom;
        protected override void Awake()
        {
            base.Awake();
            AddListener();
        }

        protected override void FindComponent()
        {
            custom = new List<Transform>();
            ruleList = this.transform.FindChildDepth("Content/RuleList/Viewport/Content");
            leftShowBtn = this.transform.FindChildDepth<Button>("Content/LeftBtn");
            rightShowBtn = this.transform.FindChildDepth<Button>("Content/RightBtn");
            BackBtn = this.transform.FindChildDepth<Button>("Content/BackBtn");
            Content = this.transform.FindChildDepth("Content/RuleList/Viewport/Content");
            zzb = Content.FindChildDepth("One/ZZB");
            swk = Content.FindChildDepth("One/SWK");
            other = Content.FindChildDepth("One/Other");
            ld = Content.FindChildDepth("One/LD");
            zm = Content.FindChildDepth("One/Zimu");
            sz = Content.FindChildDepth("One/Shuzi");
            scatter = Content.FindChildDepth("Two/Scatter");
            wild = Content.FindChildDepth("Two/Wild");
            custom.Clear();
            custom.Add(zzb);
            custom.Add(swk);
            custom.Add(other);
            custom.Add(ld);
            custom.Add(zm);
            custom.Add(sz);
            custom.Add(scatter);
            custom.Add(wild);
            SetBeiShu();
        }

        private void SetBeiShu()
        {
            for (int i = 0; i < custom.Count; i++)
            {
                int count = 0;
                for (int j = 0; j < YGBH_DataConfig.BeiLVTable.Count; j++)
                {
                    if (YGBH_DataConfig.BeiLVTable[j][i]!=0)
                    {
                        count += 1;
                        custom[i].GetChild(count - 1).GetComponent<Text>().text =
                            $"{(YGBH_DataConfig.BeiLVTable.Count - j + 1)}  {(YGBH_DataConfig.BeiLVTable[j][i] * YGBHEntry.Instance.GameData.CurrentChip).ShortNumber()}";
                    }
                }
            }
        }

        private string GetCustomK(int num)
        {
            int n = num / 1000;
            if (n <= 1 )
                return num.ToString();
            else
                return n+"K";
        }

        private void AddListener()
        {
            currentPos = 0;
            totalPos = ruleList.childCount;
            BackBtn.onClick.RemoveAllListeners();
            BackBtn.onClick.Add(CloseRule);
            leftShowBtn.onClick.RemoveAllListeners();
            leftShowBtn.onClick.Add(ClickLeftBtn);
            rightShowBtn.onClick.RemoveAllListeners();
            rightShowBtn.onClick.Add(ClickRightBtn);
        }

        private void ClickRightBtn()
        {
            YGBH_Audio.Instance.PlaySound(YGBH_Audio.BTN);
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
            YGBH_Audio.Instance.PlaySound(YGBH_Audio.BTN);
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
            YGBH_Audio.Instance.PlaySound(YGBH_Audio.BTN);
            gameObject.SetActive(false);
        }
    }
}
