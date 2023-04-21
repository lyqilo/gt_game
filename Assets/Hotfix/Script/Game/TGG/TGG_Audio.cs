using LuaFramework;
using UnityEngine;

namespace Hotfix.TGG
{
    public class TGG_Audio : SingletonILEntity<TGG_Audio>
    {
        public const string BGM = "BGM_Normal"; //背景音乐
        public const string BTN = "Button"; //按钮音乐
        public const string FreeBGM = "BGM_Free"; //财神音乐
        public const string RS = "RawStop"; //每列停止音乐
        public const string LINE = "Win"; //连线
        public const string ADDBET = "AddBet"; //加注
        public const string REDUCEBET = "ReduceBet"; //减注
        public const string BW = "BigWin"; //超大倍率音乐
        public const string MW = "MegaWin"; //超大倍率音乐
        public const string SW = "SuperWin";//超大倍率音乐

        private Transform soundList;
        private AudioSource pool;
       
        protected override void Awake()
        {
            base.Awake();
            soundList = TGGEntry.Instance.transform.FindChildDepth("Content/SoundList"); //声音库
            pool = new GameObject("AudioPool").AddComponent<AudioSource>();
            pool.playOnAwake = false;
            pool.loop = true;
            pool.volume = MusicManager.musicVolume;
            pool.mute = !MusicManager.isPlayMV;
            pool.transform.SetParent(TGGEntry.Instance.transform);
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
                audioclip = soundList.FindChildDepth<AudioSource>(BGM);
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
            bool isPlay = MusicManager.isPlaySV;
            if (!isPlay) return;
            float volumn = 1;
            if (PlayerPrefs.HasKey("SoundValue"))
            {
                volumn = int.Parse(PlayerPrefs.GetString("SoundValue"));
            }
            Transform obj = soundList.Find(soundName);
            if (obj == null)
            {
                DebugHelper.LogError($"没有找到该音效:{soundName}");
                return;
            }
            GameObject go = GameObject.Instantiate(obj.gameObject);
            go.transform.SetParent(pool.transform);
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
            GameObject.Destroy(audio.gameObject, timer);
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
