using LuaFramework;
using UnityEngine;

namespace Hotfix.FQGY
{
    public class FQGY_Audio:SingletonILEntity<FQGY_Audio>
    {
        public const string AddGold = "addgold";//增加金币
        public const string BGM = "bg"; //背景音乐
        public const string BigWin = "bigwin";//大奖1
        public const string Bous = "bous";//小游戏
        public const string End = "end";//小游戏
        public const string EnterFree = "enterfree";//进入免费
        public const string FreeBGM = "freegamebg"; //背景音乐
        public const string BTN = "game_button"; //game_button
        public const string Light1 = "light1"; //game_button
        public const string Light2 = "light2"; //game_button
        public const string Light3 = "light3"; //game_button
        public const string Light4 = "light4"; //game_button
        public const string Light5 = "light5"; //game_button
        public const string SmallGameBGM = "minigamebg"; //背景音乐
        public const string Pull = "pull"; //背景音乐
        public const string Roll = "roll"; //背景音乐
        public const string RollAdder = "rolladder"; //背景音乐
        public const string Run = "run";
        public const string Scaltter1 = "scaltter1"; //背景音乐
        public const string Scaltter2 = "scaltter2"; //背景音乐
        public const string Scaltter3 = "scaltter3"; //背景音乐
        public const string _Start = "start"; //背景音乐
        public const string StartSpin = "startspin";
        public const string Stoproll = "stoproll";
        public const string Win = "win";
        public const string LittleWin1 = "littlewin1";
        public const string LittleWin2 = "littlewin2";
        public const string MiddleWin1 = "middlewin1";
        public const string BigWin_All = "bigwin_all";
        public const string BigWin_PoopUP = "bigwin_poopup";
        public const string BonusResult = "bonusresult";
        public const string FreeResult = "freeresult";
        public const string GainBonus = "gainbonus";
        public const string GainFree = "gainfree";
        public const string JackPot_Grand = "jackpot_grand";
        public const string Bonus = "bonus";
        public const string FreeSpins = "freespins";
        public const string ShowBonus2 = "showbonus2";

  
        public const string rollEnd = "rollEnd";
        public const string iconBO = "iconBO";

      //  public const string NormalWin = "NormalWin";
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
            soundList = FQGYEntry.Instance.transform.FindChildDepth("Sound"); //声音库
            pool = new GameObject("AudioPool").AddComponent<AudioSource>();
            pool.playOnAwake = false;
            pool.loop = true;
            pool.volume = MusicManager.musicVolume;
            pool.mute = !MusicManager.isPlayMV;
            pool.transform.SetParent(FQGYEntry.Instance.transform);
            PlayBGM();
        }
        /// <summary>
        /// 播放bgm
        /// </summary>
        /// <param name="mode">背景名</param>
        public void PlayBGM(string mode=null)
        {
            //
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
            //pool.mute = true;
            //for (int i = pool.transform.childCount - 1; i >= 0; i--)
            //{
            //    pool.transform.GetChild(i).GetComponent<AudioSource>().mute = true;
            //}
        }
        /// <summary>
        /// 恢复音效
        /// </summary>
        public void ResetSound()
        {
            //pool.mute = false;
            //for (int i = pool.transform.childCount - 1; i >= 0; i--)
            //{
            //    pool.transform.GetChild(i).GetComponent<AudioSource>().mute = false;
            //}
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
            //if (string.IsNullOrEmpty(soundName)) {
            //    DebugHelper.LogError($"不存在该音效:{soundName}");
            //    return;
            //}
            //bool isPlay = MusicManager.isPlaySV;
            //if (!isPlay) return;
            //float volumn = 1;
            //if (PlayerPrefs.HasKey("SoundValue")) {
            //    volumn = int.Parse(PlayerPrefs.GetString("SoundValue"));
            //}
            //Transform obj = soundList.Find(soundName);
            //if (obj == null) {
            //    DebugHelper.LogError($"没有找到该音效:{soundName}");
            //    return;
            //}
            //GameObject go = GameObject.Instantiate(obj.gameObject);
            //go.transform.SetParent(pool.transform);
            //go.transform.localPosition = Vector3.zero;
            //go.name = soundName;
            //AudioSource audio = go.transform.GetComponent<AudioSource>();
            //audio.volume = volumn;
            //audio.Play();
            //float timer = time;
            //if (timer < 0)
            //{
            //    timer = audio.clip.length;
            //}
            //GameObject.Destroy(audio.gameObject, timer);
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
