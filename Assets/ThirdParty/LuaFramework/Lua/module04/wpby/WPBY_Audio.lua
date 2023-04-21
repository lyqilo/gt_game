WPBY_Audio = {};

local self = WPBY_Audio;

self.SoundList = {
    BGM = "BGM", --背景音乐
    FlyCoin0 = "FlyCoin0", --背景音乐
    FlyCoin1 = "FlyCoin1", --背景音乐
    OddWoman = "Fish8",
    OddMan = "Fish17",
    JBZD = "jubuzhadan",
    Shoot = "sound_fire",
    Hit = "sound_hit",
    HaiLang = "HaiLang", --按钮音乐
    Coin = "Coin", --每列停止音乐
    CameraShutter = "CameraShutter", --每列停止音乐
    Di = "Di", --每列停止音乐
    GameStart = "GameStart", --连线
    Go = "Go", --连线
    Jia = "Jia", --连线
    Over = "Over", --超大倍率音乐
    Ready = "Ready", --超大倍率音乐
}
self.pool = nil;
function WPBY_Audio.Init()
    self.pool = GameObject.New("AudioPool"):AddComponent(typeof(UnityEngine.AudioSource));
    self.pool.playOnAwake = false;
    self.pool.loop = true;
    self.pool.volume = MusicManager.musicVolume;
    self.pool.mute = not AllSetGameInfo._5IsPlayAudio;
    self.pool.transform:SetParent(WPBYEntry.transform);
end
function WPBY_Audio.PlayBGM(mode)
    --播放bgm
    self.pool:Stop();
    local rc = AllSetGameInfo._5IsPlayAudio;
    local audioclip = nil;
    if mode == nil then
        audioclip = WPBYEntry.soundList:Find(self.SoundList.BGM):GetComponent("AudioSource");
    else
        audioclip = WPBYEntry.soundList:Find(mode):GetComponent("AudioSource");
    end
    self.pool.clip = audioclip.clip;
    self.pool:Play();
end

function WPBY_Audio.PlaySound(soundName, time)
    if soundName == nil then
        error("不存在该音效");
        return ;
    end
    local isPlay = AllSetGameInfo._6IsPlayEffect;
    if not isPlay then
        return ;
    end
    local volumn = 1;
    if PlayerPrefs.HasKey("SoundValue") then
        volumn = tonumber(PlayerPrefs.GetString("SoundValue"));
    end
    local obj = WPBYEntry.soundList:Find(soundName);
    if obj == nil then
        error("没有找到该音效");
        return ;
    end
    local go = newObject(obj.gameObject);
    go.transform:SetParent(self.pool.transform);
    go.transform.localPosition = Vector3.New(0, 0, 0);
    go.name = soundName;
    local audio = go.transform:GetComponent("AudioSource");
    audio.volume = volumn;
    audio:Play();
    local timer = time;
    if timer == nil then
        timer = audio.clip.length;
    end
    GameObject.Destroy(audio.gameObject, timer);
end
function WPBY_Audio.ClearAuido(soundName)
    local sound = self.pool.transform:Find(soundName);
    if sound ~= nil then
        destroy(sound.gameObject);
    end
end