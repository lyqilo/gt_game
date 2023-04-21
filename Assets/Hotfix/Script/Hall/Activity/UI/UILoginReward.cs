using System;
using DG.Tweening;
using Hotfix.Hall.ItemBox;
using UnityEngine;
using UnityEngine.UI;
using Random = UnityEngine.Random;

namespace Hotfix.Hall.Activity
{
    public class UILoginReward : MonoBehaviour, IReward
    {
        private Button playBtn;
        private Image loginMark;
        private Sprite[] spList = new Sprite[3];

        private void Awake()
        {
            playBtn = transform.FindChildDepth<Button>("PlayBtn");
            loginMark = transform.FindChildDepth<Image>("loginMark");
            playBtn.onClick.RemoveAllListeners();
            playBtn.onClick.Add(() =>
            {
                ILMusicManager.Instance.PlayBtnSound();
                DebugTool.Log("playBtn click");
                HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO, 52, null,
                    SocketType.Hall);
            });
        }

        public void Init(HallStruct.ACP_SC_SignCheck_QueryRet info)
        {
            playBtn.gameObject.SetActive(!info.IsSignCheck);
            loginMark.gameObject.SetActive(info.IsSignCheck);
        }

        public void Show()
        {
            gameObject.SetActive(true);
        }

        public void Hide()
        {
            gameObject.SetActive(false);
        }

        public void SignBack(HallStruct.ACP_SC_SignCheck_Begin info)
        {
            DebugTool.Log("签到返回");
            playBtn.gameObject.SetActive(false);
            loginMark.gameObject.SetActive(true);
            //uii
            OnClickLoginGame(info);
        }

        //登录小游戏
        private void OnClickLoginGame(HallStruct.ACP_SC_SignCheck_Begin info)
        {
            Transform up = transform.FindChildDepth<Transform>("Image/Panel/up");
            Transform down = transform.FindChildDepth<Transform>("Image/Panel/down");
            Transform use = transform.FindChildDepth<Transform>("Image/Panel/use");


            //var picList=down.GetComponentsInChildren<Sprite>();
            for (int i = 0; i < use.childCount; i++)
            {
                spList[i] = use.FindChildDepth<Image>("icon_" + i).sprite;
            }

            float time = 0.1f;
            Sequence sequence = DOTween.Sequence();
            var prePos = up.localPosition;
            sequence.Append(up.DOLocalMoveY(prePos.y - 113 * 2, 2 * time));
            sequence.AppendCallback(() =>
            {
                up.localPosition = prePos;
                for (int k = 0; k < 3; k++)
                {
                    int iconIndex = Random.Range(0, 3);
                    up.FindChildDepth<Image>("icon_" + k).sprite = spList[iconIndex];
                    up.FindChildDepth<Image>("icon_" + k).SetNativeSize();
                }
            });
            sequence.SetLoops(10);

            int count = 0;
            Sequence sequenceD = DOTween.Sequence();
            sequenceD.Append(down.DOLocalMoveY(prePos.y - 113 * 2, time));
            sequenceD.AppendCallback(() =>
            {
                count++;
                down.localPosition = prePos;
                for (int k = 0; k < 3; k++)
                {
                    int iconIndex = Random.Range(0, 3);
                    if (count == 10)
                    {
                        iconIndex = 1;
                        UIItemBox.Open(info.SignCheckInfoType, info.SignCheckInfo);
                    }

                    down.FindChildDepth<Image>("icon_" + k).sprite = spList[iconIndex];
                    down.FindChildDepth<Image>("icon_" + k).SetNativeSize();
                }
            });
            sequenceD.Append(down.DOLocalMoveY(prePos.y - 113, time));
            sequenceD.SetLoops(10);
        }
    }
}