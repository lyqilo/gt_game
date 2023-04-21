using LuaFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix
{
    public class GameSetBtns: ILHotfixEntity
    {
        Button SetsBtn;

        Transform RecFrameMask;
        Button CloseRecFrameMask;
        Button BgMusicBtn;
        Button HelpBtn;
        Button ReturnBtn;

        Transform MusicPanel;
        Button CloseMusicPanel;
        Slider BgMusic;

        Slider BgSound;

        protected override void Awake()
        {
            base.Awake();
            AddListener();
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            SetsBtn = this.transform.FindChildDepth<Button>("SetsBtn");

            RecFrameMask = this.transform.FindChildDepth("RecFrameMask");
            CloseRecFrameMask = RecFrameMask.FindChildDepth<Button>("Close");
            BgMusicBtn = RecFrameMask.FindChildDepth<Button>("RecFrameBtns/BgMusicBtn");
            HelpBtn = RecFrameMask.FindChildDepth<Button>("RecFrameBtns/HelpBtn");
            ReturnBtn = RecFrameMask.FindChildDepth<Button>("RecFrameBtns/ReturnBtn");

            RecFrameMask.gameObject.SetActive(false);

            MusicPanel = this.transform.FindChildDepth("MusicPanel");
            CloseMusicPanel = MusicPanel.FindChildDepth<Button>("MainPanel/CloseBtn");
            BgMusic = MusicPanel.FindChildDepth<Slider>("Music/Slider");
            BgSound = MusicPanel.FindChildDepth<Slider>("Sound/Slider");

            BgMusic.value = ILMusicManager.Instance.GetMusicValue();
            BgSound.value = ILMusicManager.Instance.GetSoundValue();
            MusicPanel.gameObject.SetActive(false);
        }

        private void AddListener() 
        {
            SetsBtn.onClick.RemoveAllListeners();
            SetsBtn.onClick.Add(SetsBtnOnClick);

            CloseRecFrameMask.onClick.RemoveAllListeners();
            CloseRecFrameMask.onClick.Add(CloseRecFrameMaskOnClick);

            BgMusicBtn.onClick.RemoveAllListeners();
            BgMusicBtn.onClick.Add(BgMusicBtnOnClick);

            HelpBtn.onClick.RemoveAllListeners();
            HelpBtn.onClick.Add(HelpBtnOnClick);

            ReturnBtn.onClick.RemoveAllListeners();
            ReturnBtn.onClick.Add(ReturnBtnOnClick);

            CloseMusicPanel.onClick.RemoveAllListeners();
            CloseMusicPanel.onClick.Add(CloseMusicPanelOnClick);

            BgMusic.onValueChanged.RemoveAllListeners();
            BgMusic.onValueChanged.Add(value =>
            {
                ILMusicManager.Instance.SetMusicValue(value);
                if (value>0)
                {
                    ToolHelper.PlayMusic();
                    HotfixActionHelper.DispatchLoadGameMusic(true);
                }
                else
                {
                    ToolHelper.MuteMusic();
                    HotfixActionHelper.DispatchLoadGameMusic(false);
                }

            });

            BgSound.onValueChanged.RemoveAllListeners();
            BgSound.onValueChanged.Add(value =>
            {
                ILMusicManager.Instance.SetSoundValue(value);
                if (value>0)
                {
                    ToolHelper.PlaySound();
                    HotfixActionHelper.DispatchLoadGameSound(true);
                }
                else
                {
                    ToolHelper.MuteSound();
                    HotfixActionHelper.DispatchLoadGameSound(false);
                }

            });
        }

        private void CloseMusicPanelOnClick()
        {
            MusicPanel.gameObject.SetActive(false);
        }

        private void ReturnBtnOnClick()
        {
            HotfixActionHelper.DispatchLoadGameExit();
        }

        private void HelpBtnOnClick()
        {
            RecFrameMask.gameObject.SetActive(false);
            HotfixActionHelper.DispatchLoadGameRule();
        }

        private void BgMusicBtnOnClick()
        {
            RecFrameMask.gameObject.SetActive(false);
            MusicPanel.gameObject.SetActive(true);
        }

        private void CloseRecFrameMaskOnClick()
        {
            RecFrameMask.gameObject.SetActive(false);
        }

        private void SetsBtnOnClick()
        {
            RecFrameMask.gameObject.SetActive(!RecFrameMask.gameObject.activeSelf);
        }
    }
}
