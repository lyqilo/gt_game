using System.IO;
using LuaFramework;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Service
{
    public class UIViber : PanelBase
    {
        public UIViber() : base(UIType.Middle, nameof(UIViber))
        {
            
        }

        private Button closeBtn;
        private RawImage qrCode;
        private TMP_InputField _account;
        private Button copyCode;
        private Button copyAccount;
        public override void Create(params object[] args)
        {
            base.Create(args);
            if (args == null || args.Length <= 0) return;
            if (!(args[0] is string phone)) return;
            _account.text = phone;
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            qrCode = transform.FindChildDepth<RawImage>("Code");
            _account = transform.FindChildDepth<TMP_InputField>("Account");
            copyCode = transform.FindChildDepth<Button>("CopyImg");
            copyAccount = transform.FindChildDepth<Button>("CopyAccount");
            closeBtn = transform.FindChildDepth<Button>("CloseBtn");
        }

        protected override void AddListener()
        {
            base.AddListener();
            copyCode.onClick.RemoveAllListeners();
            copyCode.onClick.Add(OnClickSaveCode);
            copyAccount.onClick.RemoveAllListeners();
            copyAccount.onClick.Add(OnClickSaveAccount);
            closeBtn.onClick.RemoveAllListeners();
            closeBtn.onClick.Add(OnClickClose);
        }

        private void OnClickClose()
        {
            UIManager.Instance.Close();
        }

        private void OnClickSaveAccount()
        {
            var strID = _account.text;
            ToolHelper.SetText($"{strID}");
            ToolHelper.PopSmallWindow("Copy success");
        }

        private void OnClickSaveCode()
        {
            if (Util.isPc || Util.isEditor)
            {
                string saveDir = Path.Combine(Application.persistentDataPath, "NGallery");
                Directory.CreateDirectory(saveDir);
                string path = Path.Combine(saveDir, $"InviteCode_{GameLocalMode.Instance.SCPlayerInfo.DwUser_Id}.png");
                File.WriteAllBytes(path, ((Texture2D) qrCode.texture).EncodeToPNG());
                ToolHelper.PopSmallWindow("Image Saved"); 
                return;
            }

            NativeGallery.SaveImageToGallery(((Texture2D) qrCode.texture), "GT_GAME",
                $"Viber",
                (success, path) => { ToolHelper.PopSmallWindow(success ? "Image Saved" : "Image Save Failed"); });
        }
    }
}