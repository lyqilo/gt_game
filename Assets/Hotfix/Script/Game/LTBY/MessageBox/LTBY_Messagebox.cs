using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.LTBY
{
    public class LTBY_Messagebox : LTBY_ViewBase
    {
        protected CAction closeFunc;
        protected CAction confirmFunc;
        protected RectTransform board;
        protected Transform contentParent;
        public bool actionPlaying;
        public new bool isTop = true;
        public LTBY_Messagebox() : base("LTBY_Messagebox", true) { }
        public LTBY_Messagebox(string viewName,bool isTip) : base("LTBY_Messagebox", true) { }

        protected override void OnCreate(params object[] args)
        {
            // base.OnCreate( args);
            closeFunc = null;
            confirmFunc = null;
            board = transform.FindChildDepth<RectTransform>("Board");
            contentParent = board.FindChildDepth("Content");
            AddClick(board.FindChildDepth("Top/BtnBack"), OnBtnBack);
            EnterAction();
        }

        protected virtual void OnBtnBack()
        {
            closeFunc?.Invoke();
            ExitAction();
        }

        protected void SetBoardProperty(float x, float y, float w, float h)
        {
            board.localPosition = new Vector3(x, y, 0);
            board.sizeDelta = new Vector2(w, h);
        }

        protected virtual void EnterAction()
        {
            if (actionPlaying) return;
            actionPlaying = true;
            board.localScale = new Vector3(0.01f, 0.01f, 0.01f);
            board.DOScale(1, 0.3f).SetEase(Ease.OutBack).OnKill(() =>
            {
                actionPlaying = false;
            }).SetLink(board.gameObject);
        }

        public virtual void ExitAction()
        {
            if (actionPlaying) return;
            actionPlaying = true;
            board.DOScale(0, 0.3f).SetEase(Ease.InBack).OnKill(Destroy).SetLink(board.gameObject);

            //  关闭的时候防止按钮多次点击，设置空方法
            Transform btn = board.FindChildDepth("BtnConfirm");
            AddClick(btn, delegate () { });
        }

        public void SetText(string str)
        {
            Text txt = board.FindChildDepth<Text>("Text");
            txt.gameObject.SetActive(true);
            txt.text = str;
        }

        public void SetTitle(string str)
        {
            board.FindChildDepth<Text>("Top/Title").text = str;
        }

        public void HideBtnBack()
        {
            board.FindChildDepth("Top/BtnBack").gameObject.SetActive(false);
        }

        public void SetCloseFunc(CAction func)
        {
            closeFunc = func;
        }

        public void ShowBtnConfirm(CAction func, bool autoClose, string text = null)
        {
            Transform btn = board.FindChildDepth("BtnConfirm");
            btn.FindChildDepth<Text>("Text").text = string.IsNullOrEmpty(text) ? MessageBoxConfig.TextConfirm : text;
            btn.gameObject.SetActive(true);
            confirmFunc = func;
            AddClick(btn, delegate ()
            {
                confirmFunc?.Invoke();
                if (autoClose) ExitAction();
            });
        }
        public virtual void Show() { }
    }
}
