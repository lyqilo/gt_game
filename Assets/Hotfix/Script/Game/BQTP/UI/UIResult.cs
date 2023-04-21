using DG.Tweening;
using LuaFramework;
using TMPro;
using UnityEngine;

namespace Hotfix.BQTP
{
    public class UIResult : MonoBehaviour
    {
        private Transform normalWin;
        private TextMeshProUGUI normalWinNum;
        private Transform bigWin;
        private TextMeshProUGUI bigWinNum;
        private Tween _tween;
        private Transform _selfPos;

        public static UIResult Add(GameObject go, Transform selfPos)
        {
            UIResult ui = go.CreateOrGetComponent<UIResult>();
            ui._selfPos = selfPos;
            return ui;
        }

        private void Awake()
        {
            var parent = transform.parent;
            this.normalWin = parent.FindChildDepth("Bottom/WinNormal");
            this.normalWinNum = this.normalWin.FindChildDepth<TextMeshProUGUI>("Num"); //本次获得金币
            this.bigWin = parent.FindChildDepth("Bottom/WinBig");
            this.bigWinNum = this.bigWin.FindChildDepth<TextMeshProUGUI>("Num"); //本次获得金币

            HotfixMessageHelper.AddListener(Model.ShowResult, ShowResult);
            HotfixMessageHelper.AddListener(Model.StartRoll, OnStartRoll);
        }

        private void OnDestroy()
        {
            _tween?.Kill();
            HotfixMessageHelper.RemoveListener(Model.ShowResult, ShowResult);
            HotfixMessageHelper.RemoveListener(Model.StartRoll, OnStartRoll);
        }

        private void OnStartRoll(object data)
        {
            normalWinNum.SetText(0.ShortNumber());
            bigWinNum.SetText(0.ShortNumber().ShowRichText());
            normalWin.gameObject.SetActive(true);
            bigWin.gameObject.SetActive(false);
        }

        private void ShowResult(object data)
        {
            if (Model.Instance.ResultInfo.WinScore <= 0) return;
            float rate = (float) Model.Instance.ResultInfo.WinScore / (Data.Alllinecount * Model.Instance.CurrentChip);
            if (rate < 8)
            {
                ShowNormalEffect();
            }
            else
            {
                //superwin
                ShowBigWinEffect();
            }
        }

        private void ShowBigWinEffect()
        {
            //BigWin奖动画
            normalWin.gameObject.SetActive(false);
            bigWin.gameObject.SetActive(true);
            Model.Instance.PlaySound(Model.Sound.BigWin);
            Model.Instance.PlaySound(Model.Sound.NumberRunning);
            _tween?.Kill();
            _tween = DOTween.To(value =>
                {
                    int v = Mathf.FloorToInt(value);
                    bigWinNum.SetText(v.ShortNumber().ShowRichText());
                }, Model.Instance.TotalFreeGold, Model.Instance.TotalFreeGold + Model.Instance.ResultInfo.WinScore, Data.WinGoldChangeRate)
                .SetEase(Ease.Linear).OnComplete(() =>
                {
                    Model.Instance.TotalFreeGold += Model.Instance.ResultInfo.WinScore;
                    normalWinNum.SetText(Model.Instance.ResultInfo.WinScore.ShortNumber());
                    StartCoroutine(ToolHelper.DelayCall(Data.AutoNoRewardInterval * 2, () =>
                    {
                        HotfixMessageHelper.PostHotfixEvent(Model.RefreshGold);
                        if (Model.Instance.ReRollCount > 0) return;
                        Model.Instance.IsReRoll = false;
                        StartCoroutine(
                            ToolHelper.DelayCall(0.5f, () => { HotfixMessageHelper.PostHotfixEvent(Model.Check); }));
                    }));
                });
        }

        private void ShowNormalEffect()
        {
            normalWin.gameObject.SetActive(true);
            bigWin.gameObject.SetActive(false);
            Model.Instance.PlaySound(Model.Sound.Normal_Win);
            Model.Instance.PlaySound(Model.Sound.NumberRunning);
            _tween?.Kill();
            _tween = DOTween.To(value =>
                {
                    int v = Mathf.FloorToInt(value);
                    normalWinNum.SetText(v.ShortNumber());
                }, Model.Instance.TotalFreeGold, Model.Instance.TotalFreeGold + Model.Instance.ResultInfo.WinScore, Data.WinGoldChangeRate)
                .SetEase(Ease.Linear).OnComplete(
                    () =>
                    {
                        Model.Instance.TotalFreeGold += Model.Instance.ResultInfo.WinScore;
                        bigWinNum.SetText(Model.Instance.ResultInfo.WinScore.ShortNumber().ShowRichText());
                        StartCoroutine(ToolHelper.DelayCall(Data.AutoNoRewardInterval * 2, () =>
                        {
                            
                            HotfixMessageHelper.PostHotfixEvent(Model.RefreshGold);
                            if (Model.Instance.ReRollCount > 0) return;
                            Model.Instance.IsReRoll = false;
                            StartCoroutine(ToolHelper.DelayCall(0.5f,
                                () => { HotfixMessageHelper.PostHotfixEvent(Model.Check); }));
                        }));
                    });
        }
    }
}