using UnityEngine;

namespace Hotfix.CMLHJ
{
    public class CMLHJ_Audio : SingletonILEntity<CMLHJ_Audio>
    {
        public const string BigWin = "bigwin";
        public const string ChangeBet = "changebet";
        public const string BTN = "click";
        public const string Hitline1 = "hitline1";
        public const string Hitline2 = "hitline2";
        public const string Hitline3 = "hitline3";
        public const string Hitline4 = "hitline4";
        public const string Hitline5 = "hitline5";
        public const string Hitline6 = "hitline6";
        public const string Hitline7 = "hitline7";
        public const string Hitline8 = "hitline8";
        public const string Hitline9 = "hitline9";
        public const string MarryHit = "marryhit";
        public const string Roll = "roll";
        public const string Score1 = "score1";
        public const string Score2 = "score2";
        public const string Score3 = "score3";
        public const string Score4 = "score4";
        public const string Stop = "stop";
        public const string Superwin = "superwin";

        private Transform soundList;
        private AudioSource pool;
       
        protected override void Awake()
        {
            base.Awake();
            soundList = CMLHJEntry.Instance.transform.FindChildDepth("Sound"); //声音库
            pool = new GameObject("AudioPool").AddComponent<AudioSource>();
            pool.playOnAwake = false;
            pool.loop = true;
            pool.volume = ILMusicManager.Instance.GetMusicValue();
            pool.mute = !ILMusicManager.Instance.isPlayMV;
            pool.transform.SetParent(CMLHJEntry.Instance.transform);
            PlayBGM();
        }
        /// <summary>
        /// 播放bgm
        /// </summary>
        /// <param name="mode">背景名</param>
        public void PlayBGM(string mode=null)
        {
            //pool.Stop();
            //AudioSource audioclip = null;
            //if (string.IsNullOrEmpty(mode))
            //{
            //    audioclip = soundList.FindChildDepth<AudioSource>(BGM);
            //}
            //else
            //{
            //    audioclip = soundList.FindChildDepth<AudioSource>(mode);
            //}
            //pool.clip = audioclip.clip;
            //pool.Play();
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

        /// <summary>
        /// 播放音效
        /// </summary>
        /// <param name="soundName">音效名</param>
        /// <param name="time">播放时间</param>
        public void PlaySound(string soundName, float time = -1f) 
        {
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
