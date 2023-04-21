using System;
using TMPro;
using UnityEngine;
using UnityEngine.U2D;
using UnityEngine.UI;

namespace Hotfix.Hall.Announcement
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

        private NoticeData currentNoticeData;
        private SpriteAtlas _atlas;

        private void Awake()
        {
            desc = transform.FindChildDepth<TextMeshProUGUI>($"Content/Desc");
        }

        public void ShowData(NoticeData data)
        {
            currentNoticeData =  data;
            gameObject.SetActive(true);
            desc.SetText(currentNoticeData.content);
       }
    }
}