using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Activity
{
    public class UIOnLineReward : MonoBehaviour, IReward
    {
        private Sequence[] waitsequence = new Sequence[3];

        public void Show()
        {
            gameObject.SetActive(true);
            HallStruct.sActiveInfoCS ac = new HallStruct.sActiveInfoCS()
            {
                ActiveID = 3
            };
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO, 58, ac.ByteBuffer,
                SocketType.Hall);
        }

        public void Hide()
        {
            gameObject.SetActive(false);
        }

        public void InitOnline(HallStruct.ACP_SC_sActiveInfoSC info)
        {
            Transform item = transform.FindChildDepth<Transform>("item");
            Transform content = transform.FindChildDepth<Transform>(
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
                onlineItem.name = data.SubActiveID.ToString();
                Button get = onlineItem.FindChildDepth<Button>("collect");
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
                recharge.onClick.RemoveAllListeners();
                recharge.onClick.Add(() => { UIManager.Instance.ReplaceUI<Recharge.RechargePanel>(); });
                Button wait = onlineItem.FindChildDepth<Button>("wait");
                Button complete = onlineItem.FindChildDepth<Button>("complete");
                bool hasGet = data.IsPick == 1;

                if (data.Param2 != 0)
                {
                    onlineItem.FindChildDepth<Text>("dec")
                        .SetText("Get rewards by online " + (data.Param1 / 60) + " minutes and any recharge");
                }
                else
                {
                    onlineItem.FindChildDepth<Text>("dec")
                        .SetText("Get rewards by online " + (data.Param1 / 60) + " minutes");
                }

                onlineItem.FindChildDepth<Text>("num").SetText("X" + data.Reward);

                if (hasGet)
                {
                    setOnlineBtnState(onlineItem, "complete");
                }
                else if ((data.Progress1 / data.Param1 < 1))
                {
                    setOnlineBtnState(onlineItem, "wait");
                    onlineItem.FindChildDepth<Text>("wait/time").SetText(sec_to_hms(data.Param1 - data.Progress1));
                    waitsequence[i].Kill();
                    var time = data.Param1 - data.Progress1;
                    waitsequence[i] = DOTween.Sequence();
                    int ii = i;
                    waitsequence[i].AppendCallback(() =>
                    {
                        time -= 1;
                        if (time <= 0)
                        {
                            waitsequence[ii].Kill();
                            Show();
                        }
                        else
                        {
                            onlineItem.FindChildDepth<Text>("wait/time").SetText(sec_to_hms(time));
                        }
                    });
                    waitsequence[i].AppendInterval(1);
                    waitsequence[i].SetLoops(-1);
                    waitsequence[i].SetLink(transform.gameObject, LinkBehaviour.KillOnDisable);
                }
                else if ((data.Param2 != 0 && data.Progress2 / data.Param2 < 1))
                {
                    setOnlineBtnState(onlineItem, "recharge");
                }
                else
                {
                    setOnlineBtnState(onlineItem, "collect");
                }

                //get.gameObject.SetActive()
            }
        }

        private string sec_to_hms(long duration)
        {
            //秒数取整
            int seconds = (int) duration;
            //一小时为3600秒 秒数对3600取整即为小时
            int hour = seconds / 3600;
            //一分钟为60秒 秒数对3600取余再对60取整即为分钟
            int minute = seconds % 3600 / 60;
            //对3600取余再对60取余即为秒数
            seconds = seconds % 3600 % 60;

            return $"{hour:D2}:{minute:D2}:{seconds:D2}";
        }

        private void setOnlineBtnState(Transform item, string button)
        {
            Button get = item.FindChildDepth<Button>("collect");
            Button recharge = item.FindChildDepth<Button>("recharge");
            Button wait = item.FindChildDepth<Button>("wait");
            Button complete = item.FindChildDepth<Button>("complete");
            complete.gameObject.SetActive(false);
            wait.gameObject.SetActive(false);
            recharge.gameObject.SetActive(false);
            get.gameObject.SetActive(false);
            if (button == "collect")
            {
                get.gameObject.SetActive(true);
            }
            else if (button == "recharge")
            {
                recharge.gameObject.SetActive(true);
            }
            else if (button == "wait")
            {
                wait.gameObject.SetActive(true);
            }
            else if (button == "complete")
            {
                complete.gameObject.SetActive(true);
            }
        }
    }
}