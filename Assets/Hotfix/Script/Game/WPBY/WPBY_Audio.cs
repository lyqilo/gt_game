using UnityEngine;

namespace Hotfix.WPBY
{
    public class WPBY_Audio : SingletonILEntity<WPBY_Audio>
    {
        public const string BGM = "BGM"; //背景音乐
        public const string FlyCoin0 = "FlyCoin0"; //背景音乐
        public const string BTN = "Button";
        public const string QP = "QP";
        public const string TL = "TL";
        public const string ChangeGun = "ChangeGun";
        public const string Boss = "Boss";
        public const string OddWoman = "Fish8";
        public const string OddMan = "Fish17";
        public const string JBZD = "jubuzhadan";
        public const string Shoot = "sound_fire";
        public const string Hit = "sound_hit";
        public const string HaiLang = "HaiLang"; //按钮音乐

        public AudioSource pool;

        protected override void Awake()
        {
            base.Awake();
            pool = new GameObject("AudioPool").AddComponent<AudioSource>();
            pool.playOnAwake = false;
            pool.loop = true;
            pool.volume = ILMusicManager.Instance.GetMusicValue();
            pool.mute = !ILMusicManager.Instance.isPlayMV;
            pool.transform.SetParent(WPBYEntry.Instance.transform);
        }

        /// <summary>
        /// 播放背景音乐
        /// </summary>
        /// <param name="mode"></param>
        public void PlayBGM(string mode = null)
        {
            //播放bgm
            pool.Stop();
            AudioSource audioclip = mode == null
                ? transform.Find(BGM).GetComponent<AudioSource>()
                : transform.Find(mode).GetComponent<AudioSource>();

            pool.clip = audioclip.clip;
            pool.Play();
        }

        public void PlayFire()
        {
            if (pool.transform.Find(Shoot) != null) return;
            PlaySound(Shoot);
        }

        public void PlaySound(string soundName, float time = -1)
        {
            if (soundName == null)
            {
                DebugHelper.LogError("不存在该音效");
                return;
            }

            bool isPlay = ILMusicManager.Instance.isPlaySV;
            if (!isPlay) return;
            float volumn = ILMusicManager.Instance.GetSoundValue();
            Transform obj = transform.Find(soundName);
            if (obj == null)
            {
                DebugHelper.LogError($"没有找到该音效:{soundName}");
                return;
            }

            GameObject go = Object.Instantiate(obj.gameObject, pool.transform, true);
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

            ToolHelper.Destroy(audio.gameObject, timer);
        }

        public void ClearAuido(string soundName)
        {
            Transform sound = pool.transform.Find(soundName);
            if (sound != null) Object.Destroy(sound.gameObject);
        }
    }
}