using System;
using System.Collections.Generic;
using System.IO;
using FancyScrollView;
using LitJson;
using LuaFramework;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Share
{
    public partial class UIShareBind : MonoBehaviour , IModuleDetail
    {
        private HallStruct.sShareData shareData;
        private TMP_InputField yourInvite;
        private TMP_InputField enterInviteCode;
        private TMP_InputField downloadLink;
        private TMP_InputField myInviteCode;
        private Button bindBtn;
        private RawImage myInviteCodeImg;
        private Button copyLinkBtn;
        private Button myInviteCopyBtn;
        private Button saveCodeBtn;

        private Transform friendInviteNode;
        private Scroller friendInviteScroller;
        private ScrollView friendInviteScrollView;
        private Scrollbar friendInviteBar;

        private Texture2D qr;

        public int Index { get; set; }

        private void Awake()
        {
            yourInvite = transform.FindChildDepth<TMP_InputField>("YourInvite/InviteCode");
            enterInviteCode = transform.FindChildDepth<TMP_InputField>("InputInviteCode/Code");
            downloadLink = transform.FindChildDepth<TMP_InputField>("DownloadLink/Link");
            myInviteCode = transform.FindChildDepth<TMP_InputField>("MyCode/Code");
            bindBtn = transform.FindChildDepth<Button>("InputInviteCode/BindBtn");
            copyLinkBtn = transform.FindChildDepth<Button>("DownloadLink/Copy");
            myInviteCopyBtn = transform.FindChildDepth<Button>("MyCode/Copy");
            myInviteCodeImg = transform.FindChildDepth<RawImage>("ShareCodeImage/Code");
            saveCodeBtn = transform.FindChildDepth<Button>("ShareCodeImage/SaveBtn");
            friendInviteNode = transform.FindChildDepth("FriendInvite/List");
            friendInviteBar = friendInviteNode.FindChildDepth<Scrollbar>("Scrollbar");

            bindBtn.onClick.RemoveAllListeners();
            bindBtn.onClick.Add(OnClickBindCall);
            copyLinkBtn.onClick.RemoveAllListeners();
            copyLinkBtn.onClick.Add(OnClickCopyLinkCall);
            myInviteCopyBtn.onClick.RemoveAllListeners();
            myInviteCopyBtn.onClick.Add(OnClickCopyMyInviteCall);
            saveCodeBtn.onClick.RemoveAllListeners();
            saveCodeBtn.onClick.Add(OnClickSaveCodeImageCall);
        }

        private void AddEvent()
        {
            HotfixMessageHelper.AddListener(
                CustomEvent.MDM_3D_PERSONAL_INFO + DataStruct.PersonalStruct.SUB_3D_SC_QueryShareInfo,
                OnRecieveQueryShareInfo);
            HotfixMessageHelper.AddListener(
                CustomEvent.MDM_3D_PERSONAL_INFO + DataStruct.PersonalStruct.SUB_3D_SC_BindParent,
                OnRecieveBindParent);
        }

        private void RemoveEvent()
        {
            HotfixMessageHelper.RemoveListener(
                CustomEvent.MDM_3D_PERSONAL_INFO + DataStruct.PersonalStruct.SUB_3D_SC_QueryShareInfo,
                OnRecieveQueryShareInfo);
            HotfixMessageHelper.RemoveListener(
                CustomEvent.MDM_3D_PERSONAL_INFO + DataStruct.PersonalStruct.SUB_3D_SC_BindParent,
                OnRecieveBindParent);
        }

        private void CreateScroller(RectTransform viewport)
        {
            friendInviteScroller ??= friendInviteNode.gameObject.CreateOrGetComponent<Scroller>();
            friendInviteScroller.Viewport ??= viewport;
            friendInviteScroller.SnapEnabled = false;
            friendInviteScroller.Draggable = true;
            friendInviteScroller.MovementType = MovementType.Clamped;
            friendInviteScroller.ScrollDirection = ScrollDirection.Vertical;
            friendInviteScroller.Scrollbar = friendInviteBar;
        }

        private void OnRecieveBindParent(object data)
        {
            if (!(data is HallStruct.sCommonINT16 result)) return;
            string str = String.Empty;
            switch (result.nValue)
            {
                case 1:
                    str = "Bind Success";
                    break;
                case 2:
                    str = "Code is incorrect";
                    break;
                case 3:
                    str = "Bind Failed,The code is already Binded";
                    break;
                case 4:
                    str = "You are not bound  phone";
                    break;
                case 5:           
                    str = "The inviter is not bound phone";
                    break;
                case 6:
                    str = "Can't bind the people you invite";
                    break;
            }

            ToolHelper.PopSmallWindow(str);
        }
        private void OnRecieveQueryShareInfo(object data)
        {
            if (!(data is HallStruct.sShareData _shareData)) return;
            shareData = _shareData;
            DebugHelper.Log($"sharedata:{JsonMapper.ToJson(shareData)}");
            InitInfo();
        }

        private void InitInfo()
        {
            yourInvite.text = shareData.bindCount > 0 && shareData.bindList[0] > 0 ? $"{shareData.bindList[0]}" : "";
            myInviteCode.text = shareData.inviteCode;

            CreateScroller(friendInviteNode.FindChildDepth("View").GetComponent<RectTransform>());
            friendInviteScrollView ??= friendInviteNode.gameObject.CreateOrGetComponent<ScrollView>();
            List<Data> datas = new List<Data>();
            for (int i = 1; i < shareData.bindList.Count; i++)
            {
                datas.Add(new Data(shareData.bindList[i]));
            }

            friendInviteScrollView.Init(datas);
            qr = ToolHelper.CreateQR(shareData.inviteCode);
            myInviteCodeImg.texture = qr;
            downloadLink.SetTextWithoutNotify("http://web.5gtgame.com:18080/download.html");
        }

        private void OnClickSaveCodeImageCall()
        {
            if (Util.isPc || Util.isEditor)
            {
                string saveDir = Path.Combine(Application.persistentDataPath, "NGallery");
                Directory.CreateDirectory(saveDir);
                string path = Path.Combine(saveDir, $"InviteCode_{GameLocalMode.Instance.SCPlayerInfo.DwUser_Id}.png");
                File.WriteAllBytes(path, qr.EncodeToPNG());
                return;
            }

            NativeGallery.SaveImageToGallery(qr, "GT_GAME",
                $"InviteCode_{GameLocalMode.Instance.SCPlayerInfo.DwUser_Id}",
                (success, path) => { ToolHelper.PopSmallWindow(success ? "Image Saved" : "Image Save Failed"); });
        }

        private void OnClickCopyMyInviteCall()
        {
            ILMusicManager.Instance.PlayBtnSound();
            if (string.IsNullOrEmpty(myInviteCode.text))
            {
                ToolHelper.PopSmallWindow("Code Save Failed");
                return;
            }

            ToolHelper.SetText(myInviteCode.text);
            ToolHelper.PopSmallWindow("Code Saved");
        }

        private void OnClickCopyLinkCall()
        {
            ILMusicManager.Instance.PlayBtnSound();

            if (string.IsNullOrEmpty(downloadLink.text))
            {
                ToolHelper.PopSmallWindow("Link Save Failed");
                return;
            }

            ToolHelper.SetText($"Click on the link to download the latest version of GTgame with the latest games of slots, fishing and poker. You will get 3% rebate for sharing the link and binding the invitation code：{downloadLink.text}");
            ToolHelper.PopSmallWindow("Link Saved");
        }

        private void OnClickBindCall()
        {
            ILMusicManager.Instance.PlayBtnSound();
            if (string.IsNullOrEmpty(enterInviteCode.text)) return;
            var bindData = new HallStruct.sBindParent();
            bindData.strCode = enterInviteCode.text;
            Model.Instance.Send(DataStruct.PersonalStruct.SUB_3D_CS_BindParent, bindData.Buffer);
        }

        public void Show()
        {
            AddEvent();
            Model.Instance.Send(DataStruct.PersonalStruct.SUB_3D_CS_QueryShareInfo, new ByteBuffer());
            gameObject.SetActive(true);
        }

        public void Hide()
        {
            RemoveEvent();
            gameObject.SetActive(false);
        }
    }
}