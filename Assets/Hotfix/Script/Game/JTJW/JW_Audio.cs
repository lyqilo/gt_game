using LuaFramework;
using UnityEngine;

namespace Hotfix.JTJW
{
    public class JW_Audio:SingletonILEntity<JW_Audio>
    {
        public const string BGM = "BGM"; //背景音乐
        public const string FreeBGM = "FreeBGM"; //背景音乐
        public const string BTN = "BTN"; //按钮音乐

        public const string Run = "rollStart";
        public const string rollEnd = "rollEnd";
        public const string iconBO = "iconBO";

      //  public const string NormalWin = "NormalWin";
        public const string BigWin = "win1";
        public const string SuperWin = "win2";
        public const string MegaWin = "win3";
        public const string iconWinStar = "iconWinStar";
        public const string iconWinEnd = "iconWinEnd";

        public const string wuStar = "wuStar";
        public const string freeGameIn = "freeGameIn";
        public const string freeGameEnd = "freeGameEnd";

        private Transform soundList;
        private AudioSource pool;
       
        protected override void Awake()
        {
            base.Awake();
            soundList = JWEntry.Instance.MainContent.FindChildDepth("Content/SoundList"); //声音库
            pool = new GameObject("AudioPool").AddComponent<AudioSource>();
            pool.playOnAwake = false;
            pool.loop = true;
            pool.volume = MusicManager.musicVolume;
            pool.mute = !MusicManager.isPlayMV;
            pool.transform.SetParent(JWEntry.Instance.MainContent.FindChildDepth("Content"));
            PlayBGM();
        }
        /// <summary>
        /// 播放bgm
        /// </summary>
        /// <param name="mode">背景名</param>
        public void PlayBGM(string mode=null)
        {
            //
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
        /// <summary>
        /// 播放音效
        /// </summary>
        /// <param name="soundName">音效名</param>
        /// <param name="time">播放时间</param>
        public void PlaySound(string soundName, float time = -1f) {
            if (string.IsNullOrEmpty(soundName)) {
                DebugHelper.LogError("不存在该音效");
                return;
            }
            bool isPlay = MusicManager.isPlaySV;
            if (!isPlay) return;
            float volumn = 1;
            if (PlayerPrefs.HasKey("SoundValue")) {
                volumn = int.Parse(PlayerPrefs.GetString("SoundValue"));
            }
            Transform obj = soundList.Find(soundName);
            if (obj == null) {
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
