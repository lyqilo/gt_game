using System;
using System.Collections.Generic;
using Hotfix.Hall;
using LuaFramework;
using RenderHeads.Media.AVProVideo;
using UnityEngine;

namespace Hotfix
{
    public class ILMusicManager : Singleton<ILMusicManager>
    {
        /// <summary>
        /// 背景音乐模式
        /// </summary>
        public enum BgPlayModel
        {
            None,//默认
            Audio,//音频
            Video,//视频
        }
        private Dictionary<string, AudioClip> _musicbundles;
        private readonly string SoundSaveKey = "SoundSave";
        private readonly string MusicValue = "MusicValue";
        private readonly string SoundValue = "SoundValue";
        private AudioSource _audio;
        private DisplayUGUI _video;
        public bool isPlayMV;
        public bool isPlaySV;
        private SoundSaveData soundSaveData;

        public const string BGMVideo = "Background.mp4";
        public const string BGM = "bgm3";
        public const string BTN = "anniu3";

        /// <summary>
        /// 
        /// </summary>
        public BgPlayModel BgModel = BgPlayModel.Audio;

        private void GetAudio()
        {
            switch (BgModel)
            {
                case BgPlayModel.Audio:
                    _audio = transform.GetComponent<AudioSource>();
                    if (_audio != null) return;
                    _audio = gameObject.AddComponent<AudioSource>();
                    _audio.playOnAwake = false;
                    break;
                case BgPlayModel.Video:
                    _video = transform.GetComponent<DisplayUGUI>();
                    if (_video != null) return;
                    _video = gameObject.AddComponent<DisplayUGUI>();
                    _video._mediaPlayer.m_AutoStart = false;
                    break;
            }
        }

        protected override void Awake()
        {
            base.Awake();
            GetAudio();
            _musicbundles = new Dictionary<string, AudioClip>();
            Init();
        }

        public void Init()
        {
            soundSaveData ??= SaveHelper.Get<SoundSaveData>(SoundSaveKey);
            if (soundSaveData == null)
            {
                soundSaveData = new SoundSaveData
                {
                    soundVolume = 1,
                    musicVolume = 1,
                    isMuteMusic = false,
                    isMuteSound = false
                };
                SaveHelper.Save(SoundSaveKey, soundSaveData);
            }
            isPlayMV = soundSaveData.musicVolume > 0 && !soundSaveData.isMuteMusic;
            isPlaySV = soundSaveData.soundVolume > 0 && !soundSaveData.isMuteSound;
        }
        protected override void OnDestroy()
        {
            base.OnDestroy();
            _musicbundles.Clear();
        }

        /// <summary>
        /// 播放背景音乐
        /// </summary>
        public void PlayBackgroundMusic()
        {
            switch (BgModel)
            {
                case BgPlayModel.Audio:
                    PlayAudioBackground();
                    break;
                case BgPlayModel.Video:
                    PlayVideoBackground();
                    break;
            }
        }

        private void PlayVideoBackground()
        {
            _video._mediaPlayer.m_VideoLocation = MediaPlayer.FileLocation.AbsolutePathOrURL;
            string videoUrl = $"{PathHelp.AppHotfixResPath}{BGMVideo}";
            _video._mediaPlayer.m_VideoPath = videoUrl;
            _video._mediaPlayer.m_Volume = (float) soundSaveData.musicVolume;
            _video._mediaPlayer.m_Muted = soundSaveData.isMuteMusic;
            _video._mediaPlayer.m_Loop = true;
            _video._mediaPlayer.Play();
        }

        private void PlayAudioBackground()
        {
            if (_musicbundles.ContainsKey(BGM))
            {
                PlayMusic(_musicbundles[BGM]);
                return;
            }

            GameObject obj = ToolHelper.LoadAsset<GameObject>(SceneType.Hall, $"Music");

            if (obj == null)
            {
                DebugHelper.LogError($"没找到music");
                return;
            }

            AudioSource source = obj.transform.FindChildDepth<AudioSource>(BGM);
            if (source == null)
            {
                DebugHelper.LogError($"没找到背景音乐节点{BGM}");
                return;
            }

            var clip = source.clip;
            _musicbundles[BGM] = clip;
            PlayMusic(clip);
        }

        /// <summary>
        /// 播放按钮音效
        /// </summary>
        public void PlayBtnSound()
        {
            PlaySound(BTN);
        }

        /// <summary>
        ///     设置音效音量
        /// </summary>
        /// <param name="sv">音效音量</param>
        public void SetSoundValue(float sv)
        {
            GetAudio();
            soundSaveData.soundVolume = sv;
            isPlaySV = sv != 0;
            soundSaveData.isMuteSound = !isPlaySV;
            for (var i = transform.childCount - 1; i >= 0; i--)
            {
                transform.GetChild(i).GetComponent<AudioSource>().volume = sv;
                transform.GetChild(i).GetComponent<AudioSource>().mute = soundSaveData.isMuteSound;
            }
            SaveHelper.Save(SoundSaveKey, soundSaveData);
        }

        /// <summary>
        ///     获取音效音量
        /// </summary>
        /// <returns></returns>
        public float GetSoundValue()
        {
            soundSaveData ??= SaveHelper.Get<SoundSaveData>(SoundSaveKey);
            return isPlaySV ? (float) soundSaveData.soundVolume : 0;
        }

        /// <summary>
        ///     设置音乐音量
        /// </summary>
        /// <param name="mv">音乐音量</param>
        public void SetMusicValue(float mv)
        {
            GetAudio();
            switch (BgModel)
            {
                case BgPlayModel.Audio:
                    _audio.volume = mv;
                    soundSaveData.musicVolume = mv;
                    isPlayMV = mv != 0;
                    soundSaveData.isMuteMusic = !isPlayMV;
                    _audio.mute = soundSaveData.isMuteMusic;
                    break;
                case BgPlayModel.Video:
                    _video._mediaPlayer.m_Volume = mv;
                    soundSaveData.musicVolume = mv;
                    isPlayMV = mv != 0;
                    soundSaveData.isMuteMusic = !isPlayMV;
                    _video._mediaPlayer.m_Muted = soundSaveData.isMuteMusic;
                    break;
            }
            DebugHelper.LogError($"hotfix:{mv}");
            SaveHelper.Save(SoundSaveKey, soundSaveData);
        }

        /// <summary>
        ///     获取音乐音量
        /// </summary>
        /// <returns></returns>
        public float GetMusicValue()
        {
            soundSaveData ??= SaveHelper.Get<SoundSaveData>(SoundSaveKey);
            return isPlayMV ? (float) soundSaveData.musicVolume : 0;
        }

        public void SyncData()
        {
            soundSaveData = SaveHelper.Get<SoundSaveData>(SoundSaveKey);
        }

        /// <summary>
        ///     设置音效静音
        /// </summary>
        /// <param name="isMute">是否静音</param>
        public void SetSoundMute(bool isMute)
        {
            GetAudio();
            for (var i = transform.childCount - 1; i >= 0; i--)
            {
                transform.GetChild(i).GetComponent<AudioSource>().mute = isMute;
            }

            soundSaveData.isMuteSound = isMute;
            isPlaySV = !isMute;
            SaveHelper.Save(SoundSaveKey, soundSaveData);
        }

        /// <summary>
        /// 设置音乐静音
        /// </summary>
        /// <param name="isMute"></param>
        public void SetMusicMute(bool isMute)
        {
            DebugHelper.Log("isMute===" + isMute);

            GetAudio();
            switch (BgModel)
            {
                case BgPlayModel.Audio:
                    _audio.mute = isMute;
                    soundSaveData.isMuteMusic = isMute;
                    isPlayMV = !isMute;
                    break;
                case BgPlayModel.Video:
                    _video._mediaPlayer.m_Muted = isMute;
                    soundSaveData.isMuteMusic = isMute;
                    isPlayMV = !isMute;
                    break;
            }
            SaveHelper.Save(SoundSaveKey, soundSaveData);
        }

        /// <summary>
        ///     播放音乐
        /// </summary>
        /// <param name="clip">音乐文件</param>
        public void PlayMusic(AudioClip clip)
        {
            GetAudio();
            if (clip == null)
            {
                DebugHelper.LogError("音乐片段是错误的");
                return;
            }

            _audio.clip = clip;
            _audio.volume = (float) soundSaveData.musicVolume;
            _audio.mute = soundSaveData.isMuteMusic;
            _audio.loop = true;
            _audio.Play();
        }

        /// <summary>
        ///     播放音效
        /// </summary>
        /// <param name="clipName">音效名</param>
        /// <param name="times">次数</param>
        public void PlaySound(string clipName, int times = 1)
        {
            if (_musicbundles.ContainsKey(clipName))
            {
                PlaySound(_musicbundles[clipName], times);
                return;
            }
            GameObject obj = ToolHelper.LoadAsset<GameObject>(SceneType.Hall, "Music");

            if (obj == null)
            {
                DebugHelper.LogError($"没找到music");
                return;
            }

            AudioSource source = obj.transform.FindChildDepth<AudioSource>(clipName);
            if (source == null)
            {
                DebugHelper.LogError($"没找到音效节点{clipName}");
                return;
            }

            var clip = source.clip;
            _musicbundles[clipName] = clip;
            PlaySound(clip, times);
        }

        /// <summary>
        ///     播放音效
        /// </summary>
        /// <param name="clip">音效</param>
        /// <param name="times">次数</param>
        public void PlaySound(AudioClip clip, int times = 1)
        {
            GetAudio();
            if (clip == null)
            {
                DebugHelper.LogError("音乐片段是错误的");
                return;
            }

            var timer = clip.length * times;
            var go = new GameObject($"{clip.name}");
            go.transform.SetParent(_audio.transform);
            var source = go.AddComponent<AudioSource>();
            source.clip = clip;
            source.loop = true;
            source.volume = (float) soundSaveData.soundVolume;
            source.mute = soundSaveData.isMuteSound;
            source.Play();
            if (times > 0) HallExtend.Destroy(go, timer);
        }

        public void StopSound(string soundName)
        {
            for (var i = transform.childCount - 1; i >= 0; i--)
            {
                if (!transform.GetChild(i).gameObject.name.Equals(soundName)) continue;
                HallExtend.Destroy(transform.GetChild(i).gameObject);
            }
        }

        /// <summary>
        ///     停止播放音乐
        /// </summary>
        public void StopMusic()
        {
            GetAudio();
            switch (BgModel)
            {
                case BgPlayModel.Audio:
                    _audio.Stop();
                    break;
                case BgPlayModel.Video:
                    _video._mediaPlayer.Stop();
                    break;
            }
        }

        /// <summary>
        ///     停止所有音效
        /// </summary>
        public void StopAllSound()
        {
            GetAudio();
            for (var i = transform.childCount - 1; i >= 0; i--)
            {
                transform.GetChild(i).GetComponent<AudioSource>().Stop();
                HallExtend.Destroy(transform.GetChild(i).gameObject);
            }
        }
    }

    public class SoundSaveData : BaseSave
    {
        public bool isMuteMusic;
        public bool isMuteSound;
        public double musicVolume;
        public double soundVolume;
    }
}