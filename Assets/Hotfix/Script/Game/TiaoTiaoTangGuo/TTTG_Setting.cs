using LuaFramework;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.TiaoTiaoTangGuo
{
    public class TTTG_Setting : ILHotfixEntity
    {
        private Slider soundProgress;
        private Toggle soundTog;
        private Slider soundTogSlider;
        private Slider musicProgress;
        private Toggle musicTog;
        private Slider musicTogSlider;
        private Button sureBtn;
        private Button closeBtn;

        private MusicManager musicManager;

        protected override void FindComponent()
        {
            base.FindComponent();
            sureBtn = transform.FindChildDepth<Button>($"SureBtn");
            closeBtn = transform.FindChildDepth<Button>($"CloseButton");

            soundProgress = transform.FindChildDepth<Slider>($"Sound/Slider");
            musicProgress = transform.FindChildDepth<Slider>($"Music/Slider");

            soundTog = transform.FindChildDepth<Toggle>($"Sound/Toggle");
            soundTogSlider = transform.FindChildDepth<Slider>($"Sound/Toggle/Slider");
            musicTog = transform.FindChildDepth<Toggle>($"Music/Toggle");
            musicTogSlider = transform.FindChildDepth<Slider>($"Music/Toggle/Slider");
        }

        private void AddListener()
        {
            sureBtn.onClick.RemoveAllListeners();
            sureBtn.onClick.Add(OnClickCloseCall);
            closeBtn.onClick.RemoveAllListeners();
            closeBtn.onClick.Add(OnClickCloseCall);
            
            soundProgress.onValueChanged.RemoveAllListeners();
            soundProgress.onValueChanged.Add(OnSoundProgressChangeCall);
            musicProgress.onValueChanged.RemoveAllListeners();
            musicProgress.onValueChanged.Add(OnMusicProgressChangeCall);
            
            soundTog.onValueChanged.RemoveAllListeners();
            soundTog.onValueChanged.Add(OnClickSoundTogCall);
            musicTog.onValueChanged.RemoveAllListeners();
            musicTog.onValueChanged.Add(OnClickMusicTogCall);
        }

        protected override void Start()
        {
            base.Start();
            musicManager = AppFacade.Instance.GetManager<MusicManager>();

            soundTog.isOn = musicManager.GetIsPlaySV();
            musicTog.isOn = musicManager.GetIsPlayMV();
            soundTogSlider.value = soundTog.isOn ? 1 : 0;
            musicTogSlider.value = musicTog.isOn ? 1 : 0;
            if (!PlayerPrefs.HasKey("MusicValue"))
            {
                PlayerPrefs.SetString("MusicValue", "1");
            }

            if (!PlayerPrefs.HasKey("SoundValue"))
            {
                PlayerPrefs.SetString("SoundValue", "1");
            }

            MusicManager.musicVolume = float.Parse(PlayerPrefs.GetString("MusicValue"));
            MusicManager.soundVolume = float.Parse(PlayerPrefs.GetString("SoundValue"));
            soundProgress.value = float.Parse(PlayerPrefs.GetString("SoundValue"));
            musicProgress.value =float.Parse(PlayerPrefs.GetString("MusicValue"));
            AddListener();
        }

        private void OnClickMusicTogCall(bool isOn)
        {
            musicTogSlider.value = isOn ? 1 : 0;
            musicProgress.value = isOn ? float.Parse(PlayerPrefs.GetString("MusicValue")) : 0;
            TTTG_Audio.Instance.PlaySound(TTTG_Audio.Candybreak_Click);
            if (isOn)
            {
                ToolHelper.PlayMusic();
                TTTG_Audio.Instance.ResetMusic();
                TTTG_Audio.Instance.SetMusicValue(1);
                PlayerPrefs.SetString("MusicValue", "1");
            }
            else
            {
                ToolHelper.MuteMusic();
                TTTG_Audio.Instance.MuteMusic();
                TTTG_Audio.Instance.SetMusicValue(0);
                PlayerPrefs.SetString("MusicValue", "0");
            }
        }

        private void OnClickSoundTogCall(bool isOn)
        {
            soundTogSlider.value = isOn ? 1 : 0;
            soundProgress.value = isOn ? float.Parse(PlayerPrefs.GetString("SoundValue")) : 0;
            TTTG_Audio.Instance.PlaySound(TTTG_Audio.Candybreak_Click);
            if (isOn)
            {
                ToolHelper.PlaySound();
                TTTG_Audio.Instance.ResetSound();
                TTTG_Audio.Instance.SetSoundValue(1);
                PlayerPrefs.SetString("SoundValue", "1");
            }
            else
            {
                ToolHelper.MuteSound();
                TTTG_Audio.Instance.MuteSound();
                TTTG_Audio.Instance.SetSoundValue(0);
                PlayerPrefs.SetString("SoundValue", "0");
            }
        }

        private void OnMusicProgressChangeCall(float value)
        {
            PlayerPrefs.SetString("MusicValue", $"{value}");
            musicManager.SetValue(soundProgress.value,musicProgress.value);
            TTTG_Audio.Instance.SetMusicValue(value);
            if (value <= 0)
            {
                ToolHelper.MuteMusic();
                TTTG_Audio.Instance.MuteMusic();
                musicTog.isOn = false;
                musicTogSlider.value = 0;
            }
            else
            {
                ToolHelper.PlayMusic();
                TTTG_Audio.Instance.ResetMusic();
                musicTog.isOn = true;
                musicTogSlider.value = 1;
            }
        }

        private void OnSoundProgressChangeCall(float value)
        {
            PlayerPrefs.SetString("SoundValue", $"{value}");
            musicManager.SetValue(soundProgress.value,musicProgress.value);
            TTTG_Audio.Instance.SetSoundValue(value);
            if (value <= 0)
            {
                ToolHelper.MuteSound();
                TTTG_Audio.Instance.MuteSound();
                soundTog.isOn = false;
                soundTogSlider.value = 0;
            }
            else
            {
                ToolHelper.PlaySound();
                TTTG_Audio.Instance.ResetSound();
                soundTog.isOn = true;
                soundTogSlider.value = 1;
            }
        }

        private void OnClickCloseCall()
        {
            TTTG_Audio.Instance.PlaySound(TTTG_Audio.Candybreak_Click);
            transform.localScale = Vector3.zero;
        }
    }
}