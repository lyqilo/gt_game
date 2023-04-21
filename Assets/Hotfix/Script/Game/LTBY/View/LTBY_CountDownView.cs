using DG.Tweening;
using System;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.LTBY
{
    public class LTBY_CountDownView:LTBY_ViewBase
    {
        private int time;
        private TextMeshProUGUI timeNode;
        private Action callBack;

        public LTBY_CountDownView() : base(nameof(LTBY_CountDownView),true) { }

        protected override void OnCreate(params object[] args)
        {
            base.OnCreate(args);
            string text = args.Length >= 1 ? args[0].ToString() : "";
            int time = args.Length >= 2 ? (int)args[1] : 0;
            Action callBack = args.Length >= 3 ? (Action)args[2] : null;
            RectTransform rect = this.transform.GetComponent<RectTransform>();
            if (rect != null)
            {
                rect.offsetMax = Vector2.zero;
                rect.offsetMin = Vector2.zero;
            }
            this.time = time;
            this.timeNode = FindChild<TextMeshProUGUI>("Time");
            this.timeNode.text=time.ShowRichText();
            if (this.time <= 3) {
                Sequence sequence = DOTween.Sequence();
                timeNode.transform.localScale = Vector3.one;
                sequence.Append(timeNode.transform.DOBlendableScaleBy(new Vector3(0.8f, 0.8f), 0.15f));
                sequence.Append(timeNode.transform.DOBlendableScaleBy(new Vector3(-0.8f, -0.8f), 0.15f));
                sequence.SetLink(timeNode.gameObject);
                RunAction(sequence);
            }

            FindChild<Text>("Text").text = text;

            this.callBack = callBack;

            StartTimer("CountDown", 1, ()=>
            {
                this.time--;
                if (this.time <= 3 && this.time >= 0)
                {
                    this.timeNode.text = this.time.ShowRichText();
                    Sequence sequence = DOTween.Sequence();
                    timeNode.transform.localScale = Vector3.one;
                    sequence.Append(timeNode.transform.DOBlendableScaleBy(new Vector3(0.8f, 0.8f), 0.15f));
                    sequence.Append(timeNode.transform.DOBlendableScaleBy(new Vector3(-0.8f, -0.8f), 0.15f));
                    sequence.SetLink(timeNode.gameObject);
                    RunAction(sequence);
                    LTBY_Audio.Instance.Play(SoundConfig.Button);
                }

                if (this.time >= 0) return;
                callBack?.Invoke();
                //Destroy();
                return;
            });
        }
    }
}