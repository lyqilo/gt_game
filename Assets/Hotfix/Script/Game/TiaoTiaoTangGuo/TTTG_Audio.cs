using LuaFramework;
using UnityEngine;

namespace Hotfix.TiaoTiaoTangGuo
{
    public class TTTG_Audio : SingletonILEntity<TTTG_Audio>
    {
        public const string BGM = "Candybreak_spin"; //背景音乐
        public const string FreeBGM = "Candybreak_freespinreel"; //背景音乐
        public const string Candybreak_bonusin = "Candybreak_bonusin"; //按钮音乐
        public const string Candybreak_bonuswin = "Candybreak_bonuswin"; //按钮音乐
        public const string Candybreak_Click = "Candybreak_Click"; //按钮音乐
        public const string Candybreak_combo1 = "Candybreak_combo1"; //按钮音乐
        public const string Candybreak_combo2 = "Candybreak_combo2"; //按钮音乐
        public const string Candybreak_combo3 = "Candybreak_combo3"; //按钮音乐
        public const string Candybreak_combo4 = "Candybreak_combo4"; //按钮音乐
        public const string Candybreak_combo5 = "Candybreak_combo5"; //按钮音乐
        public const string Candybreak_combo6 = "Candybreak_combo6"; //按钮音乐
        public const string Candybreak_freespinreel = "Candybreak_freespinreel"; //按钮音乐
        public const string Candybreak_perfect = "Candybreak_perfect"; //按钮音乐
        public const string Candybreak_Reel_feedback = "Candybreak_Reel_feedback"; //按钮音乐
        public const string Candybreak_Reel_Stop = "Candybreak_Reel_Stop"; //按钮音乐
        public const string Candybreak_special = "Candybreak_special"; //按钮音乐
        public const string Candybreak_specialwin = "Candybreak_specialwin"; //按钮音乐
        public const string Candybreak_SpinClick = "Candybreak_SpinClick"; //按钮音乐
        public const string Candybreak_symbolwin = "Candybreak_symbolwin"; //按钮音乐
        public const string click = "click";
        public const string Getchip = "Getchip";
        public const string S_Social_Rank = "S_Social_Rank";
        public const string S_Social_Reward = "S_Social_Reward";
        private Transform soundList;
        private AudioSource pool;

        protected override void Awake()
        {
            base.Awake();
            soundList = TTTGEntry.Instance.transform.FindChildDepth("SoundList"); //声音库
            pool = gameObject.AddComponent<AudioSource>();
            pool.playOnAwake = false;
            pool.loop = true;
            pool.volume = MusicManager.musicVolume;
            pool.mute = !MusicManager.isPlayMV;
        }

        /// <summary>
        /// 播放bgm
        /// </summary>
        /// <param name="mode">背景名</param>
        public void PlayBGM(string mode = null)
        {
            //
            pool.volume = MusicManager.musicVolume;
            pool.mute = !MusicManager.isPlayMV;
            pool.Stop();
            AudioSource audioclip = null;
            audioclip = soundList.FindChildDepth<AudioSource>(string.IsNullOrEmpty(mode) ? BGM : mode);
            pool.clip = audioclip.clip;
            pool.Play();
        }

        /// <summary>
        /// 静音音效
        /// </summary>
        public void MuteSound()
        {
            pool.mute = true;
            for (int i = pool.transform.childCount - 1; i >= 0; i--)
            {
                pool.transform.GetChild(i).GetComponent<AudioSource>().mute = true;
            }
        }

        /// <summary>
        /// 恢复音效
        /// </summary>
        public void ResetSound()
        {
            pool.mute = false;
            for (int i = pool.transform.childCount - 1; i >= 0; i--)
            {
                pool.transform.GetChild(i).GetComponent<AudioSource>().mute = false;
            }
        }

        public void MuteMusic()
        {
            pool.mute = true;
        }

        public void ResetMusic()
        {
            pool.mute = false;
        }

        public void SetSoundValue(float value)
        {
            for (int i = pool.transform.childCount - 1; i >= 0; i--)
            {
                pool.transform.GetChild(i).GetComponent<AudioSource>().volume = value;
            }
        }

        public void SetMusicValue(float value)
        {
            pool.volume = value;
        }

        /// <summary>
        /// 播放音效
        /// </summary>
        /// <param name="soundName">音效名</param>
        /// <param name="isloop">是否循环</param>
        /// <param name="time">播放时间</param>
        public void PlaySound(string soundName, bool canRepeat = true, bool isloop = false, float time = -1f)
        {
            if (string.IsNullOrEmpty(soundName))
            {
                DebugHelper.LogError("不存在该音效");
                return;
            }

            bool isPlay = MusicManager.isPlaySV;
            if (!isPlay) return;
            float volumn = 1;
            if (PlayerPrefs.HasKey("SoundValue"))
            {
                volumn = float.Parse(PlayerPrefs.GetString("SoundValue"));
            }

            Transform obj = soundList.Find(soundName);
            if (obj == null)
            {
                DebugHelper.LogError($"没有找到该音效:{soundName}");
                return;
            }

            if (!canRepeat)
            {
                Transform child = pool.transform.Find(soundName);
                if (child != null) return;
            }
            GameObject go = Object.Instantiate(obj.gameObject, pool.transform, true);
            go.transform.localPosition = Vector3.zero;
            go.name = soundName;
            AudioSource _audio = go.transform.GetComponent<AudioSource>();
            _audio.volume = volumn;
            _audio.Play();
            float timer = time;
            if (timer < 0)
            {
                timer = _audio.clip.length;
            }

            _audio.loop = isloop;
            if (!isloop) GameObject.Destroy(_audio.gameObject, timer);
        }

        /// <summary>
        /// 清除音效
        /// </summary>
        /// <param name="soundName">音效名</param>
        public void ClearAuido(string soundName)
        {
            Transform sound = pool.transform.Find(soundName);
            if (sound != null)
            {
                GameObject.Destroy(sound.gameObject);
            }
        }
    }
}