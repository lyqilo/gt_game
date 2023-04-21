using LuaFramework;
using UnityEngine;

namespace Hotfix.YGBH
{
    public class YGBH_Audio : SingletonILEntity<YGBH_Audio>
    {
       public const string ADDSPEED = "AddSpeed";      //加速
       public const string BETFORCE = "betforce";      //
       public const string BGM_ZX = "BGM_ZX";          //紫霞背景音乐
       public const string BGM_BJJ = "BGM_BJJ";        //白晶晶背景音乐
       public const string BTN = "Button";             //按钮音乐
       public const string FREESELECT = "Ding";        //选择免费类型
       public const string FIREGOLD = "FireGold";      //
       public const string HIGHWIN1 = "HighWin1";      //
       public const string HIGHWIN2 = "HighWin2";      //
       public const string KULOU = "KuLou";            //骷髅
       public const string SMALLEND = "LotteryRoll";   //小游戏停止
       public const string OPENCARD = "OpenCard";      //开启卡片
       public const string BJJEFECT = "BJJ_Effect";    //白晶晶粒子音效
       public const string COLLECTEFFECT = "CollectEffect"; //收集卡片音效
       public const string SCATTER1 = "Scatter1"; //scatter1
       public const string SCATTER2 = "Scatter2"; //scatter2
       public const string SCATTER3 = "Scatter3"; //scatter3
       public const string RS = "Stop"; //每列停止音乐
       public const string SMALLSTART = "TanChuang2"; //小游戏开始
       public const string FREESTART = "TanChuang1"; //免费开始
       public const string ZXEFFECT = "LingDang"; //紫霞铃铛
       public const string TIMEDOWN = "Down";//免费五秒倒计时

        private Transform soundList;
        private AudioSource pool;
       
        protected override void Awake()
        {
            base.Awake();
            soundList = YGBHEntry.Instance.transform.FindChildDepth("Content/SoundList"); //声音库
            pool = new GameObject("AudioPool").AddComponent<AudioSource>();
            pool.playOnAwake = false;
            pool.loop = true;
            pool.volume = ILMusicManager.Instance.GetMusicValue();
            pool.mute = !ILMusicManager.Instance.isPlayMV;
            pool.transform.SetParent(YGBHEntry.Instance.transform);
            PlayBGM();
        }

        public void SetMusicValue(float value)
        {
            if (pool == null) return;
            pool.volume = value;
            pool.mute = value == 0;
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
        public void PlaySound(string soundName, float time = -1f) 
        {
            if (string.IsNullOrEmpty(soundName))
            {
                DebugHelper.LogError($"不存在该音效:{soundName}");
                return;
            }
            bool isPlay = MusicManager.isPlaySV;
            if (!isPlay) return;
            float volumn = ILMusicManager.Instance.GetSoundValue();
            Transform obj = soundList.Find(soundName);
            if (obj == null)
            {
                DebugHelper.LogError($"没有找到该音效:{soundName}");
                return;
            }
            GameObject go = Object.Instantiate(obj.gameObject, pool.transform, false);
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

        public void SetSoundValue(float value)
        {
            for (int i = pool.transform.childCount - 1; i >= 0; i--)
            {
                pool.transform.GetChild(i).GetComponent<AudioSource>().mute = value == 0;
                pool.transform.GetChild(i).GetComponent<AudioSource>().volume = value;
            }
        }
    }
}
