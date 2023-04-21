using LuaFramework;
using UnityEngine;

namespace Hotfix.TouKui
{
    public class TouKui_Audio:SingletonILEntity<TouKui_Audio>
    {
        public const string BGM = "BGM"; //背景音乐
        public const string FreeBGM = "FreeBGM"; //背景音乐
        public const string BTN = "BTN"; //按钮音乐
        public const string AddMoney = "AddMoney";
        public const string BeginFreeGame = "BeginFreeGame";
        public const string Run = "Run";
        public const string NormalWin = "NormalWin";
        public const string BigWin = "BigWin";
        public const string SuperWin = "SuperWin";
        public const string MegaWin = "MegaWin";
        public const string FinishMoney = "FinishMoney";
        public const string BeiShuSound = "FreeSound0";
        public const string KuoSanSound = "FreeSound1";
        public const string FuDongSound = "FreeSound2";
        public const string GuDingSound = "FreeSound3";
        public const string FreeSelectOK = "FreeSelectOK";
        public const string FreeSelectRoll = "FreeSelectRoll";
        public const string JiaBei = "JiaBei";
        public const string Light = "Light";
        public const string LiuZhou = "LiuZhou";
        public const string LoopWheel = "LoopWheel";
        public const string RunWheel = "RunWheel";
        public const string StopWheel = "StopWheel";
        private Transform soundList;
        private AudioSource pool;
       
        protected override void Awake()
        {
            base.Awake();
            soundList = TouKuiEntry.Instance.MainContent.FindChildDepth("Content/SoundList"); //声音库
            pool = new GameObject("AudioPool").AddComponent<AudioSource>();
            pool.playOnAwake = false;
            pool.loop = true;
            pool.volume = ILMusicManager.Instance.GetMusicValue();
            pool.mute = !ILMusicManager.Instance.isPlayMV;
            pool.transform.SetParent(TouKuiEntry.Instance.MainContent.FindChildDepth("Content"));
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
        /// <param name="isloop">是否循环</param>
        /// <param name="time">播放时间</param>
        public void PlaySound(string soundName, bool isloop = false, float time = -1f)
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
            audio.loop = isloop;
            if (!isloop) GameObject.Destroy(audio.gameObject, timer);
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
