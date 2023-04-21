using System.Collections.Generic;
using FancyScrollView;
using Hotfix.Hall.ItemBox;
using LuaFramework;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Share
{
    public partial class UIShareInviteReward : MonoBehaviour , IModuleDetail
    {
        private Scroller _scroller;
        private ScrollView _scrollView;
        private Transform rewardList;
        public int Index { get; set; }
        public void Show()
        {
            AddEvent();
            gameObject.SetActive(true);
            FindComponent();
            Model.Instance.Send(DataStruct.PersonalStruct.SUB_3D_CS_QueryInviteAwardCfg, new ByteBuffer());
        }

        private void FindComponent()
        {
            rewardList ??= transform.FindChildDepth("Reward");
        }

        public void Hide()
        {
            gameObject.SetActive(false);
            RemoveEvent();
        }

        private void AddEvent()
        {
            HotfixMessageHelper.AddListener(
                CustomEvent.MDM_3D_PERSONAL_INFO + DataStruct.PersonalStruct.SUB_3D_SC_QueryInviteAwardCfg,
                OnReceiveConfig);
            HotfixMessageHelper.AddListener(
                CustomEvent.MDM_3D_PERSONAL_INFO + DataStruct.PersonalStruct.SUB_3D_SC_PickInviteAward,
                OnReceiveReward);
        }

        private void RemoveEvent()
        {
            HotfixMessageHelper.AddListener(
                CustomEvent.MDM_3D_PERSONAL_INFO + DataStruct.PersonalStruct.SUB_3D_SC_QueryInviteAwardCfg,
                OnReceiveConfig);
            HotfixMessageHelper.AddListener(
                CustomEvent.MDM_3D_PERSONAL_INFO + DataStruct.PersonalStruct.SUB_3D_SC_PickInviteAward,
                OnReceiveReward);
        }

        private void OnReceiveConfig(object data)
        {
            if (!(data is HallStruct.sInviteAward config)) return;
            List<Data> datas = new List<Data>();
            for (int i = 0; i < config.AwardCfg.Count; i++)
            {
                datas.Add(new Data(config.AwardCfg[i], config.PickIndex, config.InviteNum));
            }

            _scroller ??= ToolHelper.CreateScroller(rewardList.gameObject,
                rewardList.FindChildDepth("View").GetComponent<RectTransform>(), direction: ScrollDirection.Horizontal);
            _scrollView ??= rewardList.gameObject.CreateOrGetComponent<ScrollView>();
            _scrollView.Init(datas,OnClickReceive);
        }

        private void OnClickReceive()
        {
            ToolHelper.ShowWaitPanel();
            Model.Instance.Send(DataStruct.PersonalStruct.SUB_3D_CS_PickInviteAward, new ByteBuffer());
        }

        private void OnReceiveReward(object data)
        {
            ToolHelper.ShowWaitPanel(false);
            if (!(data is HallStruct.sCommonINT64 result)) return;
            if (result.nValue <= 0) return;
            ByteBuffer buffer = new ByteBuffer();
            buffer.WriteUInt32(GameLocalMode.Instance.SCPlayerInfo.DwUser_Id);
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO,
                DataStruct.PersonalStruct.SUB_3D_CS_SELECT_GOLD_MSG,
                buffer, SocketType.Hall);
            UIItemBox.Open((int) ItemType.Coin, result.nValue);
            Model.Instance.RemoveData(DataStruct.PersonalStruct.SUB_3D_CS_QueryInviteAwardCfg);
            Model.Instance.Send(DataStruct.PersonalStruct.SUB_3D_CS_QueryInviteAwardCfg, new ByteBuffer());
        }
    }
}