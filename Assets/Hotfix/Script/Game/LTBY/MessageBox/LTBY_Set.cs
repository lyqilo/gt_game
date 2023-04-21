using LuaFramework;
using System;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;


namespace Hotfix.LTBY
{
    /// <summary>
    /// 设置
    /// </summary>
    public class LTBY_Set: LTBY_Messagebox
    {
        Transform content;

        Transform effectBtn;

        Transform musicBtn;

        bool effectOpen;
        bool musicOpen;
        int lowPowerLevel;

        public LTBY_Set() : base(nameof(LTBY_Set), true) { }

        protected override void OnCreate(params object[] args)
        {
            base.OnCreate(args);
            FrameData cfg = SetConfig.Frame;

            SetTitle(cfg.Title);

            SetBoardProperty(cfg.x, cfg.y, cfg.w, cfg.h);

            //LTBY_EffectManager.Instance
            this.content = LTBY_Extend.Instance.LoadPrefab("LTBY_Set", this.contentParent);
            RectTransform rect = this.content.GetComponent<RectTransform>();
            if (rect != null)
            {
                rect.offsetMax = Vector2.zero;
                rect.offsetMin = Vector2.zero;
            }

            this.content.FindChildDepth<Text>("EffectFrame/Text").text= SetConfig.Effect;

            this.content.FindChildDepth<Text>("MusicFrame/Text").text=SetConfig.Music;

            this.effectBtn = this.content.FindChildDepth("EffectFrame/Btn");
            this.effectBtn.FindChildDepth<Text>("Close/Text").text=SetConfig.CloseText;
            this.effectBtn.FindChildDepth<Text>("Open/Text").text=SetConfig.OpenText;
            AddClick(this.effectBtn, (go, eventData) => ChangeEffect());

            this.musicBtn = this.content.FindChildDepth("MusicFrame/Btn");
            this.musicBtn.FindChildDepth<Text>("Close/Text").text=SetConfig.CloseText;
            this.musicBtn.FindChildDepth<Text>("Open/Text").text=SetConfig.OpenText;
            AddClick(this.musicBtn, (go, eventData) => ChangeMusic());

            for (int i = 1; i <= 4; i++)
            {
                int index = i;
                var node = this.content.FindChildDepth($"LowPowerFrame/Level{index}");
                node.FindChildDepth<Text>("Text").text = SetConfig.LowPower[$"LowPower{index}"];
                AddClick(node, (go, eventData) => ChangeLowPower(index));
            }

            effectOpen = AppFacade.Instance.GetManager<MusicManager>().GetIsPlaySV();

            this.effectBtn.FindChildDepth("Close").gameObject.SetActive(!this.effectOpen);
            this.effectBtn.FindChildDepth("Open").gameObject.SetActive(this.effectOpen);

            musicOpen = AppFacade.Instance.GetManager<MusicManager>().GetIsPlayMV() ;

            this.musicBtn.FindChildDepth("Close").gameObject.SetActive(!this.musicOpen);
            this.musicBtn.FindChildDepth("Open").gameObject.SetActive(this.musicOpen);

            this.lowPowerLevel = GetFromPlayerPrefs("LTBY_LowPowerLevel")>0?GetFromPlayerPrefs("LTBY_LowPowerLevel"):3;
            this.content.FindChildDepth($"LowPowerFrame/Level{this.lowPowerLevel}/Btn/Open").gameObject.SetActive(true);
            LTBYEntry.Instance.SetLowPower(lowPowerLevel);

        }

        private void ChangeLowPower(int level)
        {
            if (level == lowPowerLevel) return;

            content.FindChildDepth($"LowPowerFrame/Level{lowPowerLevel}/Btn/Open").gameObject.SetActive(false);
            lowPowerLevel = level;
            content.FindChildDepth($"LowPowerFrame/Level{lowPowerLevel}/Btn/Open").gameObject.SetActive(true);
            LTBYEntry.Instance.SetLowPower(lowPowerLevel);
            PlayerPrefs.SetInt("LTBY_LowPowerLevel", lowPowerLevel);
        }

        private void ChangeMusic()
        {
            musicOpen = ! musicOpen;

            musicBtn.FindChildDepth("Close").gameObject.SetActive(!musicOpen);
            musicBtn.FindChildDepth("Open").gameObject.SetActive(musicOpen);

            if (musicOpen)
            {
                ToolHelper.PlayMusic();
                LTBY_Audio.Instance.ResetMusic();
            }
            else
            {
                ToolHelper.MuteMusic();
                LTBY_Audio.Instance.MuteMusic();
            }
        }

        private void ChangeEffect()
        {
            effectOpen = !effectOpen;

            effectBtn.FindChildDepth("Close").gameObject.SetActive(!effectOpen);
            effectBtn.FindChildDepth("Open").gameObject.SetActive(effectOpen);

            if (effectOpen)
            {
                ToolHelper.PlaySound();
                LTBY_Audio.Instance.ResetSound();
            }
            else
            {
                ToolHelper.MuteSound();
                LTBY_Audio.Instance.MuteSound();
            }
        }

        private int GetFromPlayerPrefs(string name)
        {
            int num = !PlayerPrefs.HasKey(name) ? 0 : PlayerPrefs.GetInt(name);
            return num;
        }
    }
}
