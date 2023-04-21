using LuaFramework;
using UnityEngine;

namespace Hotfix.MJHL
{
    public class MJHL_Audio:SingletonILEntity<MJHL_Audio>
    {
        public const string BGM = "BGM"; //背景音乐
        public const string FreeBGM = "FreeBGM"; //背景音乐
        public const string BTN = "BTN"; //按钮音乐

        //获奖icon
        public const string MJ_0 = "MJ_0"; //
        public const string MJ_1 = "MJ_1"; //
        public const string MJ_2 = "MJ_2"; //
        public const string MJ_3 = "MJ_3"; //
        public const string MJ_4 = "MJ_4"; //
        public const string MJ_5 = "MJ_5"; //
        public const string MJ_6 = "MJ_6"; //
        public const string MJ_7 = "MJ_7"; //
        public const string MJ_8 = "MJ_8"; //
        public const string MJ_winline = "MJ_winline"; //

        //本次倍数
        public const string MJ_2rate = "MJ_2rate"; //
        public const string MJ_3rate = "MJ_3rate"; //
        public const string MJ_4rate = "MJ_4rate"; //
        public const string MJ_5rate = "MJ_5rate"; //
        public const string MJ_6rate = "MJ_6rate"; //
        public const string MJ_10rate = "MJ_10rate"; //

        //增加金币
        public const string MJ_addgold = "MJ_addgold"; //
        public const string MJ_Award1 = "MJ_Award1"; //
        public const string MJ_Award2 = "MJ_Award2"; //
        public const string MJ_Award3 = "MJ_Award3"; //
        public const string MJ_totalwin = "MJ_totalwin"; //

        //大奖
        public const string MJ_bigwin = "MJ_bigwin"; //
        public const string MJ_bigwinend = "MJ_bigwinend"; //

        //点击
        public const string MJ_click = "MJ_click"; //
        public const string MJ_click1 = "MJ_click1"; //
        public const string MJ_click2 = "MJ_click2"; //

        //列停止
        public const string MJ_forcestop = "MJ_forcestop"; //
        public const string MJ_freerun = "MJ_freerun"; //

        //胡
        public const string MJ_hu = "MJ_hu"; //
        public const string MJ_hule = "MJ_hule"; //


        public const string MJ_rateloop = "MJ_rateloop"; //
        public const string MJ_run = "MJ_run"; //
        public const string MJ_speedup = "MJ_speedup"; //
        public const string MJ_start = "MJ_start"; //

        private Transform soundList;
        private AudioSource pool;
       
        protected override void Awake()
        {
            base.Awake();
            soundList = MJHLEntry.Instance.mainContent.FindChildDepth("Content/SoundList"); //声音库
            pool = new GameObject("AudioPool").AddComponent<AudioSource>();
            pool.playOnAwake = false;
            pool.loop = true;
            pool.volume = MusicManager.musicVolume;
            pool.mute = !MusicManager.isPlayMV;
            pool.transform.SetParent(MJHLEntry.Instance.mainContent.FindChildDepth("Content"));
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
