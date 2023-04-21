using LuaFramework;
using UnityEngine;

namespace Hotfix.SG777
{
    public class SG777_Audio: SingletonILEntity<SG777_Audio>
    {
        public const string SMBGM = "s_bell_game";
        public const string BTN = "s_btn";
        public const string BELL = "s_click_bell";
        public const string BELL_ON = "s_enter_bell_on";
        public const string FreeBGM = "s_free";
        public const string Full = "s_full";
        public const string Gold_Add = "s_gold_add";
        public const string Line = "s_line";
        public const string Run = "s_start";
        public const string rollEnd = "sound_run_stop";

        private Transform soundList;
        private AudioSource pool;
       
        protected override void Awake()
        {
            base.Awake();
            soundList = SG777Entry.Instance.transform.FindChildDepth("Sound"); //声音库
            pool = new GameObject("AudioPool").AddComponent<AudioSource>();
            pool.playOnAwake = false;
            pool.loop = true;
            pool.volume = ILMusicManager.Instance.GetMusicValue();
            pool.mute = !ILMusicManager.Instance.isPlayMV;
            pool.transform.SetParent(SG777Entry.Instance.transform);
            PlayBGM();
        }
        /// <summary>
        /// 播放bgm
        /// </summary>
        /// <param name="mode">背景名</param>
        public void PlayBGM(string mode=null)
        {
            pool.Stop();
            AudioSource audioclip = null;
            if (string.IsNullOrEmpty(mode))
            {
                return;
                //audioclip = soundList.FindChildDepth<AudioSource>(BGM);
            }
            else
            {
                audioclip = soundList.FindChildDepth<AudioSource>(mode);
            }
            pool.clip = audioclip.clip;
            pool.Play();
        }
        /// <summary>
        /// 静音音效
        /// </summary>
        public void MuteSound()
        {
            //pool.mute = true;
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
            //pool.mute = false;
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

        /// <summary>
        /// 播放音效
        /// </summary>
        /// <param name="soundName">音效名</param>
        /// <param name="time">播放时间</param>
        public void PlaySound(string soundName, float time = -1f) {
            if (string.IsNullOrEmpty(soundName))
            {
                DebugHelper.LogError($"不存在该音效:{soundName}");
                return;
            }
            bool isPlay = ILMusicManager.Instance.isPlaySV;
            if (!isPlay) return;
            float volumn = ILMusicManager.Instance.GetSoundValue();
            Transform obj = soundList.Find(soundName);
            if (obj == null)
            {
                DebugHelper.LogError($"没有找到该音效:{soundName}");
                return;
            }
            GameObject go = Object.Instantiate(obj.gameObject,pool.transform,false);
            go.transform.localPosition = Vector3.zero;
            go.name = soundName;
            AudioSource audio = go.transform.GetComponent<AudioSource>();
            audio.volume = volumn;
            audio.Play();
            float timer = time;
            if (timer < 0)
            {
                timer = audio.clip.length;
            }
            Object.Destroy(audio.gameObject, timer);
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
                Object.Destroy(sound.gameObject);
            }
        }
    }
}
