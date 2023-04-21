using System.Collections;
using UnityEngine;

namespace LuaFramework
{
    public class MusicManager : Manager
    {
        private readonly string SoundSaveKey = "SoundSave";

        private void Awake()
        {
            this._audio = base.GetComponent<AudioSource>();
        }

        public override void OnInitialize()
        {
            base.OnInitialize();

            soundSaveData = SaveHelper.Get<SoundSaveData>(SoundSaveKey);
            if (soundSaveData == null)
            {
                soundSaveData = new SoundSaveData
                {
                    soundVolume = 1,
                    musicVolume = 1,
                    isMuteMusic = false,
                    isMuteSound = false
                };
            }

            isPlayMV = soundSaveData.musicVolume > 0 && !soundSaveData.isMuteMusic;
            isPlaySV = soundSaveData.soundVolume > 0 && !soundSaveData.isMuteSound;
        }

        private void GetAudio()
        {
            bool flag = this._audio != null;
            if (flag) return;
            this._audio = base.GetComponent<AudioSource>();
            bool flag2 = this._audio == null;
            if (!flag2) return;
            base.gameObject.AddComponent<AudioSource>();
            this._audio = base.GetComponent<AudioSource>();
        }


        public void SetValue(float sv, float mv)
        {
            MusicManager.soundVolume = sv;
            MusicManager.musicVolume = mv;
            this.GetAudio();
            this._audio.volume = MusicManager.musicVolume;
            GetComponent<AudioSource>().volume = mv;
            soundSaveData.musicVolume = mv;
            isPlayMV = mv != 0;
            soundSaveData.soundVolume = sv;
            isPlaySV = sv != 0;
            SaveHelper.Save(SoundSaveKey, soundSaveData);
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
                AudioSource source = transform.GetChild(i).GetComponent<AudioSource>();
                if (source == null) continue;
                source.mute = isMute;
            }

            soundSaveData.isMuteSound = isMute;
            isPlaySV = !isMute;
            SaveHelper.Save(SoundSaveKey, soundSaveData);
        }

        /// <summary>
        ///     设置音乐静音
        /// </summary>
        /// <param name="isMute"></param>
        public void SetMusicMute(bool isMute)
        {
            GetAudio();
            GetComponent<AudioSource>().mute = isMute;
            soundSaveData.isMuteMusic = isMute;
            isPlayMV = !isMute;
            SaveHelper.Save(SoundSaveKey, soundSaveData);
        }

        public void SetPlaySM(bool sv, bool mv)
        {
            GetAudio();
            MusicManager.isPlaySV = sv;
            MusicManager.isPlayMV = mv;
            this._audio.mute = !MusicManager.isPlayMV;
        }


        public float GetgameQuality()
        {
            return MusicManager.gameQuality;
        }


        public float GetSoundVolume()
        {
            GetAudio();
            soundSaveData = SaveHelper.Get<SoundSaveData>(SoundSaveKey);
            soundVolume = (float)soundSaveData.soundVolume;
            isPlayMV = soundSaveData.musicVolume > 0 && !soundSaveData.isMuteMusic;
            isPlaySV = soundSaveData.soundVolume > 0 && !soundSaveData.isMuteSound;
            return MusicManager.soundVolume;
        }


        public float GetMusicVolume()
        {
            GetAudio();
            soundSaveData = SaveHelper.Get<SoundSaveData>(SoundSaveKey);
            musicVolume = (float)soundSaveData.musicVolume;
            isPlayMV = soundSaveData.musicVolume > 0 && !soundSaveData.isMuteMusic;
            isPlaySV = soundSaveData.soundVolume > 0 && !soundSaveData.isMuteSound;
            return MusicManager.musicVolume;
        }


        public bool GetIsPlaySV()
        {
            return MusicManager.isPlaySV;
        }


        public bool GetIsPlayMV()
        {
            return MusicManager.isPlayMV;
        }


        public bool isPlaying()
        {
            this.GetAudio();
            return _audio.isPlaying;
        }


        public void Add(string key, AudioClip value)
        {
            bool flag = this.sounds[key] != null || value == null;
            if (flag) return;
            this.sounds.Add(key, value);
        }


        public AudioClip Get(string key)
        {
            bool flag = this.sounds[key] == null;
            AudioClip result;
            result = flag ? null : this.sounds[key] as AudioClip;
            return result;
        }


        public AudioClip LoadAudioClip(string path)
        {
            AudioClip audioClip = this.Get(path);
            bool flag = audioClip == null;
            if (!flag) return audioClip;
            audioClip = (AudioClip) Resources.Load(path, typeof(AudioClip));
            this.Add(path, audioClip);
            return audioClip;
        }


        public bool CanPlayBackSound()
        {
            string text = AppConst.AppPrefix + "BackSound";
            int @int = PlayerPrefs.GetInt(text, 1);
            return @int == 1;
        }


        public void PlayBacksound(string name, bool canPlay)
        {
            this.GetAudio();
            bool flag = this._audio.clip != null;
            if (flag)
            {
                bool flag2 = name.IndexOf(this._audio.clip.name) > -1;
                if (flag2)
                {
                    bool flag3 = !canPlay;
                    if (!flag3) return;
                    this._audio.Stop();
                    this._audio.clip = null;
                    return;
                }
            }

            if (canPlay)
            {
                this._audio.loop = true;
                this._audio.clip = this.LoadAudioClip(name);
                this._audio.volume = MusicManager.musicVolume;
                this._audio.Play();
                this._audio.mute = !MusicManager.isPlayMV;
            }
            else
            {
                this._audio.Stop();
                this._audio.clip = null;
            }
        }


        public void PlayBacksoundX(UnityEngine.Object clipObj, bool canPlay)
        {
            this.GetAudio();
            bool flag = this._audio.clip != null;
            if (flag)
            {
                bool flag2 = clipObj.name.IndexOf(this._audio.clip.name) > -1;
                if (flag2)
                {
                    bool flag3 = !canPlay;
                    if (!flag3) return;
                    this._audio.Stop();
                    this._audio.clip = null;
                    return;
                }
            }

            if (canPlay)
            {
                this._audio.loop = true;
                this._audio.clip = (clipObj as AudioClip);
                this._audio.volume = musicVolume;
                this._audio.Play();
                this._audio.mute = !isPlayMV;
            }
            else
            {
                this._audio.Stop();
                this._audio.clip = null;
            }
        }


        public bool CanPlaySoundEffect()
        {
            string text = AppConst.AppPrefix + "SoundEffect";
            int @int = PlayerPrefs.GetInt(text, 1);
            return @int == 1;
        }


        public AudioSource Play(string path)
        {
            Vector3 zero = Vector3.zero;
            AudioClip clip = this.LoadAudioClip(path);
            bool flag = !this.CanPlaySoundEffect();
            AudioSource result;
            if (flag)
            {
                result = null;
            }
            else
            {
                float volume = MusicManager.isPlaySV ? MusicManager.soundVolume : 0f;
                AudioSource audioSource = this.PlayAudioClip(clip, zero, volume);
                result = audioSource;
            }

            return result;
        }


        public AudioSource PlayX(Object obj)
        {
            Vector3 zero = Vector3.zero;
            AudioClip clip = obj as AudioClip;
            bool flag = !this.CanPlaySoundEffect();
            AudioSource result;
            if (flag)
            {
                result = null;
            }
            else
            {
                float volume = MusicManager.isPlaySV ? MusicManager.soundVolume : 0f;
                AudioSource audioSource = this.PlayAudioClip(clip, zero, volume);
                result = audioSource;
            }

            return result;
        }


        public AudioSource PlayAudioClip(AudioClip clip, Vector3 position, float volume)
        {
            GameObject gameObject = new GameObject("One shot audio");
            gameObject.transform.SetParent(this.transform);
            gameObject.transform.position = position;
            AudioSource audioSource = gameObject.AddComponent<AudioSource>();
            audioSource.clip = clip;
            audioSource.volume = volume;
            audioSource.spatialBlend = 0f;
            audioSource.Play();
            Object.Destroy(gameObject, clip.length);
            return audioSource;
        }

        public void KillAllSoundEffect()
        {
            AudioSource[] ass = GetComponentsInChildren<AudioSource>();
            for (int i = 0; i < ass.Length; i++)
            {
                if (ass[i].name == transform.name) continue;
                ass[i].mute = true;
            }
        }


        private AudioSource _audio = null;


        private Hashtable sounds = new Hashtable();


        public static float soundVolume = 1f;


        public static float musicVolume = 1f;


        public static float gameQuality = 4f;


        public static bool isPlaySV = true;


        public static bool isPlayMV = true;
        private SoundSaveData soundSaveData;
    }

    public class SoundSaveData : BaseSave
    {
        public bool isMuteMusic;
        public bool isMuteSound;
        public double musicVolume;
        public double soundVolume;
    }
}