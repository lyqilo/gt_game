using System;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.U2D;
using UnityEngine.UI;

namespace Hotfix.Hall.Mail
{
    public class UIMainDetail : MonoBehaviour
    {
        private TextMeshProUGUI desc;
        private Text sender;
        private TextMeshProUGUI date;
        private Transform reward;
        private Image icon;
        private TextMeshProUGUI rewardCount;
        private Button claimBtn;
        private TextMeshProUGUI claimDesc;
            
        private HallStruct.sMail currentMail;
        private SpriteAtlas _atlas;

        private void Awake()
        {
            desc = transform.FindChildDepth<TextMeshProUGUI>($"Content/Desc");
            sender = transform.FindChildDepth<Text>($"Content/Sender");
            date = transform.FindChildDepth<TextMeshProUGUI>($"Content/Date");
            reward = transform.FindChildDepth($"Reward");
            icon = reward.FindChildDepth<Image>("Icon");
            rewardCount = reward.FindChildDepth<TextMeshProUGUI>($"Count");
            claimBtn = transform.FindChildDepth<Button>($"ClaimBtn");
            claimDesc = claimBtn.transform.FindChildDepth<TextMeshProUGUI>($"Text");
            
            claimBtn.onClick.RemoveAllListeners();
            claimBtn.onClick.Add(OnClickClaim);
        }

        public void ShowMail(HallStruct.sMail mail)
        {
            currentMail = mail;
            _atlas ??= ToolHelper.LoadAsset<SpriteAtlas>(SceneType.Hall, "Hall_Item");
            Model.Instance.ReadMail(currentMail.nMailID);
            gameObject.SetActive(true);
            string senderName = $"{mail.nSendUserID}";
            if (Model.Instance.MailConfigs.TryGetValue(mail.nSendUserID, out var senderConfig))
            {
                senderName = senderConfig.sender;
            }
            sender.SetText(senderName);
            date.SetText(mail.nSendTime.StampToDatetime().ToString("yyyy-MM-dd"));
            desc.SetText(mail.strContent.Replace("\\r","\r").Replace("\\n","\n"));
            reward.gameObject.SetActive(mail.nGold > 0);
            rewardCount.SetText(mail.nGold.ShortNumber());
            icon.sprite = _atlas.GetSprite("item_1");
            claimBtn.gameObject.SetActive(mail.nGold > 0);
            claimDesc.SetText(mail.bIsClaim ? "Received" : "Receive");
            claimBtn.interactable = !mail.bIsClaim;
        }
        private void OnClickClaim()
        {
            if (currentMail == null) return;
            var msg = new HallStruct.sCommonINT32();
            msg.nValue = currentMail.nMailID;
            HotfixGameComponent.Instance.Send(DataStruct.MailStruct.MDM_3D_MAIL, DataStruct.MailStruct.C2S_CLAIM_MAIL,
                msg.Buffer, SocketType.Hall);
        }

        public void ChangeClaimState()
        {
            Model.Instance.ClaimMail(currentMail.nMailID);
            ItemBox.UIItemBox.Open((int) ItemType.Coin, currentMail.nGold);
            claimDesc.SetText("Received");
            claimBtn.interactable = false;
        }
    }
}