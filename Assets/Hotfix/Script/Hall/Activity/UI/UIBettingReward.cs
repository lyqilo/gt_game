using System;
using Hotfix.Hall.ItemBox;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Activity
{
    public class UIBettingReward : MonoBehaviour, IReward
    {
        private Text todayBetText;
        private Text needBetText;

        private Image betPro;

        private Transform betBoxON;
        private Transform betBoxOFF;
        private Button getBetBtn;       
        private Button goBetBtn;


        private void Awake()
        {
            todayBetText = transform.FindChildDepth<Text>("mybettxt");
            needBetText = transform.FindChildDepth<Text>("needtxt");
            betPro = transform.FindChildDepth<Image>("betPro");
            betBoxON = transform.FindChildDepth<Transform>("box_on");
            betBoxOFF = transform.FindChildDepth<Transform>("box_off");
            getBetBtn = transform.FindChildDepth<Button>("GetBetBtn");
            goBetBtn = transform.FindChildDepth<Button>("goBetBtn");
            
            
            goBetBtn.onClick.RemoveAllListeners();
            goBetBtn.onClick.Add(() => { UIManager.Instance.Close(); });
            getBetBtn.onClick.RemoveAllListeners();
            getBetBtn.onClick.Add(() =>
            {
                ILMusicManager.Instance.PlayBtnSound();
                HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO, 56, null,SocketType.Hall);
            });
        }

        public void Show()
        {
            gameObject.SetActive(true);
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO, 54, null,
                SocketType.Hall);
        }

        public void Hide()
        {
            gameObject.SetActive(false);
        }

        public void OnGetData(HallStruct.ACP_SC_DBR_3D_Res_CodeRebateBeign info)
        {
            DebugTool.Log("打码结果返回");
            DebugHelper.Log(LitJson.JsonMapper.ToJson(info));
            getBetBtn.interactable = false;
            UIItemBox.Open(2, info.CodeRebateReward);
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO, 54, null,
                SocketType.Hall);
        }
        public void SetData(HallStruct.ACP_SC_DBR_3D_Res_CodeRebateQuery info)
        {
            todayBetText.SetText(info.CodeRebateValue.ShortNumber());
            needBetText.SetText(
                $"Need to bet {(info.CodeRebateConfig - info.CodeRebateValue).ShortNumber()} more to receive award");

            float rate = (float) info.CodeRebateValue / (float) info.CodeRebateConfig;
            betPro.fillAmount = rate;
            if (rate >= 1)
            {
                needBetText.gameObject.SetActive(false);
                getBetBtn.gameObject.SetActive(true);
                goBetBtn.gameObject.SetActive(false);
                betBoxON.gameObject.SetActive(true);
                betBoxOFF.gameObject.SetActive(false);
            }
            else
            {
                needBetText.gameObject.SetActive(true);
                getBetBtn.gameObject.SetActive(false);
                goBetBtn.gameObject.SetActive(true);
                betBoxON.gameObject.SetActive(false);
                betBoxOFF.gameObject.SetActive(true);
            }
        }
    }
}