using System.Collections.Generic;
using FancyScrollView;
using Hotfix.Hall.ItemBox;
using LuaFramework;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Share
{
    public partial class UIShareRechargeReward : MonoBehaviour ,IModuleDetail
    {
        private Scroller _scroller;
        private ScrollView _scrollView;
        private Transform recordList;

        private TMP_InputField myInviteCode;
        private TMP_InputField totalReward;
        private TMP_InputField inviteNumber;
        private TextMeshProUGUI canClaimNum;
        private Button claimBtn;
        public int Index { get; set; }
        private int CurrentIndex { get; set; } = 1;
        public void Show()
        {
            AddEvent();
            FindComponent();
            gameObject.SetActive(true);
            Model.Instance.Send(DataStruct.PersonalStruct.SUB_3D_CS_QueryRechargeInfo, new ByteBuffer());
            
            Model.Instance.Send(DataStruct.PersonalStruct.SUB_3D_CS_QueryRechargeRebateRecord, new ByteBuffer());
        }

        private void FindComponent()
        {
            recordList ??= transform.FindChildDepth("List");
            myInviteCode ??= transform.FindChildDepth<TMP_InputField>("MyInviteCode");
            totalReward ??= transform.FindChildDepth<TMP_InputField>("TotalReward");
            inviteNumber ??= transform.FindChildDepth<TMP_InputField>("InviteNumber");
            canClaimNum ??= transform.FindChildDepth<TextMeshProUGUI>("CurrentReward/Count");
            claimBtn ??= transform.FindChildDepth<Button>("CurrentReward/ClaimBtn");
            claimBtn.onClick.RemoveAllListeners();
            claimBtn.onClick.Add(OnClickClaim);
        }


        private void AddEvent()
        {
            HotfixMessageHelper.AddListener(
                CustomEvent.MDM_3D_PERSONAL_INFO + DataStruct.PersonalStruct.SUB_3D_SC_QueryRechargeInfo,
                QueryRechargeInfo);
            HotfixMessageHelper.AddListener(
                CustomEvent.MDM_3D_PERSONAL_INFO + DataStruct.PersonalStruct.SUB_3D_SC_QueryRechargeRebateRecord,
                QueryRechargeRebateRecord);
            HotfixMessageHelper.AddListener(
                CustomEvent.MDM_3D_PERSONAL_INFO + DataStruct.PersonalStruct.SUB_3D_SC_PickRechargeRebate,
                PickRechargeRebate);
        }

        public void Hide()
        {
            gameObject.SetActive(false);
            RemoveEvent();
        }

        private void RemoveEvent()
        {
            HotfixMessageHelper.RemoveListener(
                CustomEvent.MDM_3D_PERSONAL_INFO + DataStruct.PersonalStruct.SUB_3D_SC_QueryRechargeInfo,
                QueryRechargeInfo);
            HotfixMessageHelper.RemoveListener(
                CustomEvent.MDM_3D_PERSONAL_INFO + DataStruct.PersonalStruct.SUB_3D_SC_QueryRechargeRebateRecord,
                QueryRechargeRebateRecord);
            HotfixMessageHelper.RemoveListener(
                CustomEvent.MDM_3D_PERSONAL_INFO + DataStruct.PersonalStruct.SUB_3D_SC_PickRechargeRebate,
                PickRechargeRebate);
        }
        

        private void OnClickClaim()
        {
            Model.Instance.Send(DataStruct.PersonalStruct.SUB_3D_CS_PickRechargeRebate, new ByteBuffer());
        }

        private void PickRechargeRebate(object data)
        {
            if (!(data is HallStruct.sCommonINT64 info)) return;
            ByteBuffer buffer = new ByteBuffer();
            buffer.WriteUInt32(GameLocalMode.Instance.SCPlayerInfo.DwUser_Id);
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO,
                DataStruct.PersonalStruct.SUB_3D_CS_SELECT_GOLD_MSG,
                buffer, SocketType.Hall);
            
            UIItemBox.Open((int) ItemType.Coin, info.nValue);
            Model.Instance.RemoveData(DataStruct.PersonalStruct.SUB_3D_CS_QueryRechargeInfo);
            Model.Instance.Send(DataStruct.PersonalStruct.SUB_3D_CS_QueryRechargeInfo, new ByteBuffer());
        }

        private void QueryRechargeRebateRecord(object data)
        {
            if (!(data is HallStruct.sS2CQueryRebate info)) return;
            List<Data> datas = new List<Data>();
            for (int i = 0; i < info.Count; i++)
            {
                datas.Add(new Data(info.QueryRebateRecord[i]));
            }

            _scroller ??=
                ToolHelper.CreateScroller(recordList.gameObject, recordList.FindChildDepth<RectTransform>("View"));
            _scrollView ??= recordList.gameObject.CreateOrGetComponent<ScrollView>();
            _scrollView.Init(datas);
        }

        private void QueryRechargeInfo(object data)
        {
            if (!(data is HallStruct.sRechargeInfo info)) return;
            myInviteCode.SetTextWithoutNotify(info.InviteCode);
            totalReward.SetTextWithoutNotify($"{info.TotalAward}");
            inviteNumber.SetTextWithoutNotify($"{info.InviteNum}");
            canClaimNum.SetText($"{info.CanPickAmount.ShortNumber()}");
            claimBtn.interactable = info.CanPickAmount > 0;
        }
    }
}