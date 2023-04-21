using DG.Tweening;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.LTBY
{
    public class LTBY_WaitForServerView : SingletonNew<LTBY_WaitForServerView>
    {
        private float WaitTime1;
        private float WaitTime2;
        private bool Waiting;
        private Transform View;
        private int ActionKey;
        private RawImage ShieldingLayer;
        private Transform WaitContent;
        private Color hideColor = new Color(0, 0, 0, 0);
        private Color showColor = new Color(0, 0, 0, 0.8f);

        //这个主要为了不同功能的等待而加的  防止func1取消了func2的等待
        private Dictionary<string, bool> WaitKeyWords;

        public override void Init(Transform iLEntity = null)
        {
            base.Init(iLEntity);
            Instance = this;
            WaitKeyWords = new Dictionary<string, bool>();
            WaitTime1 = WaitForServerConfig.waitTime1;
            WaitTime2 = WaitForServerConfig.waitTime2;

            Transform parent = LTBYEntry.Instance.UiTopLayer;
            View = LTBY_Extend.Instance.LoadPrefab("LTBY_WaitForServerView", parent);
            RectTransform rect = View.GetComponent<RectTransform>();
            if (rect != null)
            {
                rect.offsetMax = Vector2.zero;
                rect.offsetMin = Vector2.zero;
            }
            ShieldingLayer = View.FindChildDepth<RawImage>("ShieldingLayer");
            WaitContent = View.FindChildDepth("Content");
            View.gameObject.SetActive(false);
        }
        /// <summary>
        /// 为了兼容老代码,wait的keyWord放到最后，默认为nil
        /// </summary>
        /// <param name="waitTime"></param>
        /// <param name="callBack"></param>
        /// <param name="keyWord"></param>
        public void BeginWait(float waitTime, CAction callBack, string keyWord)
        {
            if (!string.IsNullOrEmpty(keyWord))
            {
                WaitKeyWords.Add(keyWord, true);
            }

            if (Waiting) return;
            Waiting = true;
            View.gameObject.SetActive(true);
            WaitContent.gameObject.SetActive(false);
            ShieldingLayer.color = hideColor;

            Sequence sequence = DOTween.Sequence();
            sequence.SetLink(WaitContent.gameObject);
            sequence.Append(LTBY_Extend.DelayRun(waitTime == 0 ? WaitTime1 : waitTime).OnComplete(() =>
            {
                WaitContent.gameObject.SetActive(true);
                WaitContent.FindChildDepth<Text>("Text").text = WaitForServerConfig.connectText;
                ShieldingLayer.color = showColor;
            }));
            sequence.Append(LTBY_Extend.DelayRun(WaitTime2).OnComplete(() =>
            {
                callBack?.Invoke();
                EndWait();
            }));
            ActionKey = LTBY_Extend.Instance.RunAction(sequence);
        }
        public void EndWait(string keyWord = null)
        {
            if (!string.IsNullOrEmpty(keyWord))
            {
                WaitKeyWords.Remove(keyWord);
            }

            if (!Waiting) return;

            if (!CheckKeyWordIsEmpty()) return;
            Waiting = false;
            View.gameObject.SetActive(false);
            LTBY_Extend.Instance.StopAction(ActionKey);
        }
        private bool CheckKeyWordIsEmpty()
        {
            string[] keys = WaitKeyWords.GetDictionaryKeys();
            for (int i = 0; i < keys.Length; i++)
            {
                if (!string.IsNullOrEmpty(keys[i])) return false;
            }

            return true;
        }

        public void ConnectTimeout(string msg)
        {
            //EndWait();
            LTBY_Extend.Instance.StopAction(ActionKey);

            if (string.IsNullOrEmpty(msg))
            {
                LTBY_ViewManager.Instance.ShowTip(msg);
            }

            View.gameObject.SetActive(true);
            WaitContent.gameObject.SetActive(true);
            WaitContent.FindChildDepth<Text>("Text").text = WaitForServerConfig.connectText;
            ShieldingLayer.color = showColor;

            Sequence sequence = DOTween.Sequence();
            sequence.Append(LTBY_Extend.DelayRun(5).OnComplete(() =>
            {
                //GC.Notification.GamePost("BackToHall");
                EndWait();
            }));
            ActionKey = LTBY_Extend.Instance.RunAction(sequence);
        }
        public void OnGameResume(CAction func = null)
        {
            LTBY_Extend.Instance.StopAction(ActionKey);

            View.gameObject.SetActive(true);
            WaitContent.gameObject.SetActive(true);
            WaitContent.FindChildDepth<Text>("Text").text = WaitForServerConfig.reconnectText;
            ShieldingLayer.color = showColor;

            Sequence sequence = DOTween.Sequence();
            sequence.Append(ToolHelper.DelayRun(1, () =>
             {
                 func?.Invoke();
                 View.gameObject.SetActive(false);
                 LTBY_Extend.Instance.StopAction(ActionKey);
             }));
            ActionKey = LTBY_Extend.Instance.RunAction(sequence);
        }
    }
}
