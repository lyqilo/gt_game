using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Activity
{
    public class UIRechargeReward : MonoBehaviour, IReward
    {
        public void Show()
        {
            gameObject.SetActive(true);
            HallStruct.sActiveInfoCS recharge = new HallStruct.sActiveInfoCS()
            {
                ActiveID = 1
            };
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO, 58,
                recharge.ByteBuffer,
                SocketType.Hall);
        }

        public void Hide()
        {
            gameObject.SetActive(false);
        }
        
        public void InitRecharge(HallStruct.ACP_SC_sActiveInfoSC info)
        {
            Transform item = transform.FindChildDepth<Transform>("item");
            Transform content =
                transform.FindChildDepth<Transform>(
                    "RightPanel/ScrollViewsend/Viewport/Content");
            for (int i = 0; i < content.childCount; i++)
            {
                Object.Destroy(content.GetChild(i).gameObject);
            }

            for (int i = 0; i < info.leth; i++)
            {
                var data = info.data[i];
                Transform onlineItem = Object.Instantiate(item);
                onlineItem.transform.SetParent(content);
                onlineItem.gameObject.SetActive(true);
                onlineItem.transform.localPosition = Vector3.zero;
                onlineItem.transform.localScale = Vector3.one;
                onlineItem.FindChildDepth<Text>("total").SetText("Today Recharge " + data.Param1);
                onlineItem.FindChildDepth<Text>("pro").SetText(data.Progress1 + "/" + data.Param1);
                onlineItem.FindChildDepth<Text>("reward").SetText(data.Reward.ShortNumber());
                onlineItem.FindChildDepth<Image>("pre").fillAmount = (float) data.Progress1 / data.Param1;

                Button get = onlineItem.FindChildDepth<Button>("getBtn");
                get.onClick.RemoveAllListeners();
                ushort index = data.ActiveID;
                ushort sub = data.SubActiveID;
                get.onClick.Add(() =>
                {
                    HallStruct.sActiveInfoCSPick ac = new HallStruct.sActiveInfoCSPick()
                    {
                        ActiveID = (short) index,
                        SubActiveID = (short) sub
                    };
                    HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO, 60, ac.ByteBuffer,
                        SocketType.Hall);
                });
                Button recharge = onlineItem.FindChildDepth<Button>("recharge");
                Button complete = onlineItem.FindChildDepth<Button>("complete");
                recharge.onClick.RemoveAllListeners();
                recharge.onClick.Add(() => { UIManager.Instance.ReplaceUI<Recharge.RechargePanel>(); });
                if (data.IsPick == 1)
                {
                    complete.gameObject.SetActive(true);
                    recharge.gameObject.SetActive(false);
                    get.gameObject.SetActive(false);
                }
                else
                {
                    complete.gameObject.SetActive(false);
                    if (data.Progress1 >= data.Param1)
                    {
                        recharge.gameObject.SetActive(false);
                        get.gameObject.SetActive(true);
                    }
                    else
                    {
                        recharge.gameObject.SetActive(true);
                        get.gameObject.SetActive(false);
                    }
                }
            }
        }
    }
}