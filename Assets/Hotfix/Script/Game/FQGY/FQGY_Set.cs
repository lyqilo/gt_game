using System;
using UnityEngine;
using UnityEngine.UI;
using LuaFramework;

namespace Hotfix.FQGY
{
    public class FQGY_Set: ILHotfixEntity
    {

        Transform content;

        Button musicBtn;
        Transform musicON;
        Transform musicOFF;

        Button soundBtn;
        Transform soundON;
        Transform soundOFF;

        Button maskCloseBtn;

        bool effectOpen;
        bool musicOpen;

        protected override void Awake()
        {
            base.Awake();
            AddListener();
            Init();
        }

        protected override void FindComponent()
        {
            content = this.transform.FindChildDepth("Content");
            musicBtn = this.transform.FindChildDepth<Button>("Content/helpBG/music");
            musicON = content.FindChildDepth("helpBG/music/on");
            musicOFF = content.FindChildDepth("helpBG/music/off");

            soundBtn = this.transform.FindChildDepth<Button>("Content/helpBG/sound");
            soundON = content.transform.FindChildDepth("helpBG/sound/on");
            soundOFF = content.transform.FindChildDepth("helpBG/sound/off");

            maskCloseBtn = this.transform.FindChildDepth<Button>("Mask");
        }

        private void AddListener()
        {
            musicBtn.onClick.RemoveAllListeners();
            musicBtn.onClick.Add(MusicBtnOnClick);

            soundBtn.onClick.RemoveAllListeners();
            soundBtn.onClick.Add(SoundBtnOnClick);

            maskCloseBtn.onClick.RemoveAllListeners();
            maskCloseBtn.onClick.Add(CloseSetOnClick);
        }

        private void Init()
        {
            effectOpen = AppFacade.Instance.GetManager<MusicManager>().GetIsPlaySV();
            this.soundON.gameObject.SetActive(this.effectOpen);
            this.soundOFF.gameObject.SetActive(!this.effectOpen);

            musicOpen = AppFacade.Instance.GetManager<MusicManager>().GetIsPlayMV();
            this.musicON.gameObject.SetActive(this.musicOpen);
            this.musicOFF.gameObject.SetActive(!this.musicOpen);
        }

        private void MusicBtnOnClick()
        {
            musicOpen = !musicOpen;
            this.musicON.gameObject.SetActive(this.musicOpen);
            this.musicOFF.gameObject.SetActive(!this.musicOpen);

            if (musicOpen)
            {
                ToolHelper.PlayMusic();
                FQGY_Audio.Instance.ResetMusic();
            }
            else
            {
                ToolHelper.MuteMusic();
                FQGY_Audio.Instance.MuteMusic();
            }

        }

        private void SoundBtnOnClick()
        {
            effectOpen = !effectOpen;

            this.soundON.gameObject.SetActive(this.effectOpen);
            this.soundOFF.gameObject.SetActive(!this.effectOpen);

            if (effectOpen)
            {
                ToolHelper.PlaySound();
                FQGY_Audio.Instance.ResetSound();
            }
            else
            {
                ToolHelper.MuteSound();
                FQGY_Audio.Instance.MuteSound();
            }
        }

        private void CloseSetOnClick()
        {
            FQGY_Audio.Instance.PlaySound(FQGY_Audio.BTN);
            this.gameObject.SetActive(false);
        }
    }
}
