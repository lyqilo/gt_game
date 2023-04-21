using UnityEngine;

namespace Hotfix.HeiJieKe
{
    public class HJK_Player : ILHotfixEntity
    {
        private GameUserData userData;
        private Transform content;
        private HJK_PlayerInfo playerInfo;

        protected override void FindComponent()
        {
            base.FindComponent();
            content = transform.FindChildDepth($"Content");
        }

        protected override void Awake()
        {
            base.Awake();
            Transform info = HJK_Extend.Instance.GetItem($"UserInfo");
            info.SetParent(content);
            info.localScale = Vector3.one;
            info.localPosition = new Vector3(0, -200, 0);
            info.localRotation = Quaternion.identity;
            playerInfo = info.AddILComponent<HJK_PlayerInfo>();
        }

        protected override void AddEvent()
        {
            base.AddEvent();
            HJK_Event.OnPlayerScoreChange += SetData;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            HJK_Event.OnPlayerScoreChange -= SetData;
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            userData = null;
        }

        public void SetData(GameUserData data)
        {
            if (userData == null)
            {
                playerInfo.SetData(data);
            }

            userData = data;
        }
    }

    public class HJK_PlayerInfo : ILHotfixEntity
    {
        public bool IsSpecial { get; set; } //是否是界面上自己的那个面板
        private GameUserData userData;

        protected override void AddEvent()
        {
            base.AddEvent();
            HJK_Event.OnPlayerEnter += HJK_EventOnOnPlayerEnter;
            HJK_Event.OnPlayerExit += HJK_EventOnOnPlayerExit;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            HJK_Event.OnPlayerEnter -= HJK_EventOnOnPlayerEnter;
            HJK_Event.OnPlayerExit -= HJK_EventOnOnPlayerExit;
        }

        private void HJK_EventOnOnPlayerExit(GameUserData data)
        {
            if (!IsSpecial) return;
        }

        private void HJK_EventOnOnPlayerEnter(GameUserData data)
        {
            if (!IsSpecial) return;
        }

        public void SetData(GameUserData data)
        {
            userData = data;
        }
    }
}