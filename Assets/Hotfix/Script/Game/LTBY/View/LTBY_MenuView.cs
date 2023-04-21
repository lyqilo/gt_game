using DG.Tweening;
using UnityEngine;

namespace Hotfix.LTBY
{
    public class LTBY_MenuView : LTBY_ViewBase
    {
        private Transform btnOpen;
        private Transform btnClose;
        private Transform mask;
        private Transform menuFrame;
        private bool actionPlaying;
        private int showUiActionKey;

        public LTBY_MenuView() : base(nameof(LTBY_MenuView))
        {

        }

        protected override void OnCreate(params object[] args)
        {
            base.OnCreate(args);
            this.btnOpen = FindChild("BtnOpen");
            AddClick(this.btnOpen, OpenView);

            this.btnClose = FindChild("BtnClose");
            AddClick(this.btnClose, CloseView);

            this.mask = FindChild("Mask");
            AddClick(this.mask, CloseView);

            this.menuFrame = FindChild("Mask/MenuFrame");

            AddClick(this.menuFrame.FindChildDepth("BtnBack"), OnBtnBack);

            AddClick(this.menuFrame.FindChildDepth("BtnSet"), OnBtnSet);

            AddClick(this.menuFrame.FindChildDepth("BtnHelp"), OnBtnHelp);

            AddClick(this.menuFrame.FindChildDepth("BtnSwitch"), OnClickSwitchRoom);

            AddClick(this.menuFrame.FindChildDepth("BtnShop"), OnBtnShop);

            this.actionPlaying = false;

            this.showUiActionKey = 0;

            RegisterEvent();
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            UnregisterEvent();
        }
        private void UnregisterEvent()
        {
            LTBY_Event.ShowGameUi -= ShowGameUi;
        }
        private void RegisterEvent()
        {
            LTBY_Event.ShowGameUi += ShowGameUi;
        }

        private void ShowGameUi(bool flag)
        {
            if (this.showUiActionKey > 0) return;

            if (flag)
            {
                Tween tween = transform.DOBlendableLocalMoveBy(new Vector3(-GameViewConfig.ShowGameUi.Dis, 0), GameViewConfig.ShowGameUi.Time).SetEase(Ease.OutBack).OnKill(() =>
                  {
                      StopAction(this.showUiActionKey);
                      this.showUiActionKey = 0;
                  }).SetLink(transform.gameObject);
                this.showUiActionKey = RunAction(tween);
}
            else
            {
                Tween tween = transform.DOBlendableLocalMoveBy(new Vector3(GameViewConfig.ShowGameUi.Dis, 0), GameViewConfig.ShowGameUi.Time).SetEase(Ease.InBack).OnKill(() =>
                {
                    StopAction(this.showUiActionKey);
                    this.showUiActionKey = 0;
                }).SetLink(transform.gameObject);
                this.showUiActionKey = RunAction(tween);
            }
        }
        private void OnBtnBack()
        {
            LTBY_GameView.GameInstance.ExitGame();
        }
        private void OnBtnSet()
        {
            LTBY_ViewManager.Instance.OpenMessageBox<LTBY_Set>();
        }
        private void OnBtnHelp()
        {
            LTBY_ViewManager.Instance.OpenMessageBox<LTBY_Help>();
        }
        private void OnBtnShop()
        {
            //LTBY_ViewManager.Instance.Open<LTBY_ShopView>();
        }
        private void OnClickSwitchRoom()
        {
            //           if (not GC.GameInstance) then

            //       return
            //   end

            //   local limitMoney = GC.SelectArenaConfig.Limit[GC.GameInstance:GetArena()]
            //if limitMoney > GC.GameInstance:GetUserScore() then
            //       local tipBox = GC.ViewManager.OpenMessageBox("LTBY_Messagebox");
            //       tipBox: SetTitle(GC.MessageBoxConfig.Title);
            //       tipBox: SetText(GC.MessageBoxConfig.SwitchRoomMoneyNotEnough);
            //       tipBox: ShowBtnConfirm(function()

            //            GC.ViewManager.Open("LTBY_ShopView");
            //           end,true);
            //           return
            //       end

            //   GC.GameInstance:SwitchRoom()
        }
        private void OpenView()
        {
            if (this.actionPlaying) return;
            this.actionPlaying = true;

            this.btnOpen.gameObject.SetActive(false);
            this.btnClose.gameObject.SetActive(true);

            this.mask.gameObject.SetActive(true);
            this.menuFrame.localScale = Vector3.zero;
            Tween tween = menuFrame.DOScale(new Vector3(1, 1), 0.2f).OnKill(() =>
              {
                  this.actionPlaying = false;
              }).SetLink(menuFrame.gameObject);
            RunAction(tween);
        }
        private void CloseView()
        {
            if (this.actionPlaying) return;
            this.actionPlaying = true;

            this.btnOpen.gameObject.SetActive(true);
            this.btnClose.gameObject.SetActive(false);

            this.menuFrame.localScale = Vector3.one;
            Tween tween = menuFrame.DOScale(new Vector3(0, 0), 0.2f).OnKill(() =>
            {
                if (this.mask == null) return;
                this.mask.gameObject.SetActive(false);
                this.actionPlaying = false;
            }).SetLink(menuFrame.gameObject);
            RunAction(tween);
        }
    }
}