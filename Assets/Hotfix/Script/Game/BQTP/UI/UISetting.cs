using System;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.BQTP
{
    public class UISetting : MonoBehaviour
    {
        private Transform _quitPanel;
        private Button _btn;

        public static UISetting Add(GameObject go)
        {
            return go.CreateOrGetComponent<UISetting>();
        }

        private void Awake()
        {
            _btn = transform.GetComponent<Button>();
            _quitPanel = transform.parent.FindChildDepth("QuitPanel");
            Transform setContent = transform.FindChildDepth("Content");
            Toggle soundBtn = setContent.FindChildDepth<Toggle>("Sound");
            Toggle musicBtn = setContent.FindChildDepth<Toggle>("Music");
            Button backHallBtn = setContent.FindChildDepth<Button>("BackHall");
            backHallBtn.onClick.RemoveAllListeners();
            backHallBtn.onClick.Add(() =>
            {
                gameObject.SetActive(false);
                CloseGameCall();
            });

            soundBtn.onValueChanged.RemoveAllListeners();
            soundBtn.onValueChanged.Add(isOn =>
            {
                if (isOn)
                {
                    ILMusicManager.Instance.SetSoundValue(1);
                    ILMusicManager.Instance.SetSoundMute(false);
                    Model.Instance.ResetSound();
                }
                else
                {
                    ILMusicManager.Instance.SetSoundMute(true);
                    Model.Instance.MuteSound();
                }
            });

            musicBtn.onValueChanged.RemoveAllListeners();
            musicBtn.onValueChanged.Add(isOn =>
            {
                if (isOn)
                {
                    ILMusicManager.Instance.SetMusicValue(1);
                    ILMusicManager.Instance.SetMusicMute(false);
                    Model.Instance.ResetMusic();
                }
                else
                {
                    ILMusicManager.Instance.SetMusicMute(true);
                    Model.Instance.MuteMusic();
                }
            });
            musicBtn.SetIsOnWithoutNotify(!(!ILMusicManager.Instance.isPlayMV ||
                                            ILMusicManager.Instance.GetMusicValue() <= 0));
            soundBtn.SetIsOnWithoutNotify(!(!ILMusicManager.Instance.isPlaySV ||
                                            ILMusicManager.Instance.GetSoundValue() <= 0));
            _btn.onClick.RemoveAllListeners();
            _btn.onClick.Add(() => { gameObject.SetActive(false); });
        }

        private void CloseGameCall()
        {
            Model.Instance.PlaySound(Model.Sound.BTN.ToString());
            _quitPanel.gameObject.SetActive(true);
            Button backHallBtn = _quitPanel.FindChildDepth<Button>("Content/BackHall");
            Button closeBtn = _quitPanel.FindChildDepth<Button>("Content/ContinueGame");
            Button closebtn1 = _quitPanel.FindChildDepth<Button>("Content/Close");
            backHallBtn.onClick.RemoveAllListeners();
            backHallBtn.onClick.AddListener(() =>
            {
                if (!Model.Instance.IsFreeGame)
                    HotfixActionHelper.DispatchLeaveGame();
                else
                    ToolHelper.PopSmallWindow("Cannot leave the game in special mode");
            });
            closeBtn.onClick.RemoveAllListeners();
            closeBtn.onClick.AddListener(() => { _quitPanel.gameObject.SetActive(false); });
            closebtn1.onClick.RemoveAllListeners();
            closebtn1.onClick.AddListener(() => { _quitPanel.gameObject.SetActive(false); });
        }
    }
}