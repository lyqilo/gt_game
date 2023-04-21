using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.Fulinmen
{
    public partial class Model
    {
        public enum Sound
        {
            BGM, //背景音乐
            BGM_Free, //免费背景音乐
            BGM_Coin, //堆金积玉背景音乐
            BGM_Fire, //堆金积玉背景音乐
            Button, //按钮音乐
            Bell, //进入堆金积玉
            Cock,
            BoyLaugh,
            Coin1,
            Coin2,
            Coin3,
            Coin4,
            Coin5,
            Coin_Collect,
            Coin_Fly,
            Collect,
            FireCrackerExplose,
            FireWorkExplose,
            Jackpot,
            Lion,
            NCoin, //进入金币模式后
            NFree, //进入免费后
            Turn,
            TurnAT,
            Win,
            WinBig,
        }

        private AudioSource _mAudio;
        private Transform _mSoundList;
        private GameObject _audioPool;
        private Dictionary<string, Queue<AudioSource>> _sources = new Dictionary<string, Queue<AudioSource>>();

        private void InitAudio()
        {
            _mSoundList = transform.FindChildDepth("Content/SoundList"); //声音库
            GameObject audioGo = new GameObject("Audio", typeof(UnityEngine.AudioSource));
            _mAudio = audioGo.GetComponent<AudioSource>();
            _mAudio.playOnAwake = false;
            _mAudio.loop = true;
            _mAudio.volume = ILMusicManager.Instance.GetMusicValue();
            _mAudio.mute = !ILMusicManager.Instance.isPlayMV;
            _mAudio.transform.SetParent(transform);
            _mAudio.transform.localPosition = Vector3.zero;
            _audioPool = new GameObject("AudioPool");
            _audioPool.transform.SetParent(transform);
            _sources.Clear();
        }

        private void ReleaseAudio()
        {
            if (_mAudio == null) return;
            Destroy(_mAudio.gameObject);
            _mAudio = null;
        }

        public void PlayBGM(Sound bgName = Sound.BGM)
        {
            PlayBGM($"{bgName}");
        }

        /// <summary>
        /// 播放背景音乐
        /// </summary>
        /// <param name="bgName"></param>
        public void PlayBGM(string bgName)
        {
            //播放bgm
            _mAudio.Stop();
            bool rc = ILMusicManager.Instance.isPlayMV;
            AudioSource rAudio = null;
            if (string.IsNullOrEmpty(bgName))
            {
                rAudio = _mSoundList.Find(Sound.BGM.ToString()).GetComponent<AudioSource>();
            }
            else
            {
                rAudio = _mSoundList.Find(bgName).GetComponent<AudioSource>();
            }

            _mAudio.clip = rAudio.clip;
            _mAudio.Play();
        }

        public void PlaySound(Sound soundName, float time = 0)
        {
            PlaySound($"{soundName}", time);
        }

        /// <summary>
        /// 播放音效
        /// </summary>
        /// <param name="soundName">音效名</param>
        /// <param name="time">播放时长</param>
        public void PlaySound(string soundName, float time = 0)
        {
            if (string.IsNullOrEmpty(soundName))
            {
                DebugHelper.LogError("不存在该音效");
                return;
            }

            bool isPlay = ILMusicManager.Instance.isPlaySV;
            if (!isPlay) return;
            float volumn = ILMusicManager.Instance.GetSoundValue();
            AudioSource rAudio = null;
            float timer = time;
            if (_sources.TryGetValue(soundName, out var list) && list.Count > 0)
            {
                rAudio = list.Dequeue();
                rAudio.volume = volumn;
                rAudio.Play();
                rAudio.transform.SetParent(_mAudio.transform);
                if (timer == 0) timer = rAudio.clip.length;
                StartCoroutine(ToolHelper.DelayCall(timer, () => { CollectAudio(soundName, rAudio); }));
                return;
            }

            Transform obj = _mSoundList.FindChildDepth(soundName);
            if (obj == null)
            {
                DebugHelper.LogError($"没有找到该音效:{soundName}");
                return;
            }

            GameObject go = Instantiate(obj.gameObject, _mAudio.transform, false);
            go.name = soundName;
            rAudio = go.GetComponent<AudioSource>();
            rAudio.volume = volumn;
            rAudio.Play();
            if (timer == 0) timer = rAudio.clip.length;
            StartCoroutine(ToolHelper.DelayCall(timer, () => { CollectAudio(soundName, rAudio); }));
        }

        private void CollectAudio(string soundname, AudioSource source)
        {
            if (string.IsNullOrEmpty(soundname) || source == null) return;
            source.Stop();
            source.transform.SetParent(_audioPool.transform);
            if (!_sources.ContainsKey(soundname)) _sources.Add(soundname, new Queue<AudioSource>());
            _sources[soundname].Enqueue(source);
        }

        /// <summary>
        /// 关闭指定音效
        /// </summary>
        /// <param name="soundName">音效名</param>
        public void ClearAuido(string soundName)
        {
            AudioSource sound = _mAudio.transform.FindChildDepth<AudioSource>(soundName);
            if (sound != null) CollectAudio(soundName, sound);
        }

        public void MuteMusic()
        {
            _mAudio.mute = true;
        }

        public void ResetMusic()
        {
            _mAudio.mute = false;
        }

        public void MuteSound()
        {
            for (int i = _mAudio.transform.childCount - 1; i >= 0; i--)
            {
                _mAudio.transform.GetChild(i).GetComponent<AudioSource>().mute = true;
            }
        }

        public void ResetSound()
        {
            for (int i = _mAudio.transform.childCount - 1; i >= 0; i--)
            {
                _mAudio.transform.GetChild(i).GetComponent<AudioSource>().mute = false;
            }
        }
    }
}