OneWPBY_Audio = {};

local self = OneWPBY_Audio;

self.SoundList = {
    BGM = "BGM", --背景音乐
    FlyCoin0 = "FlyCoin0", --背景音乐
    BTN = "Button",
    QP = "QP",
    TL = "TL",
    ChangeGun = "ChangeGun",
    Boss = "Boss",
    OddWoman = "Fish8",
    OddMan = "Fish17",
    JBZD = "jubuzhadan",
    Shoot = "sound_fire",
    Hit = "sound_hit",
    HaiLang = "HaiLang", --按钮音乐
}
self.pool = nil;
function OneWPBY_Audio.Init()
    self.pool = GameObject.New("AudioPool"):AddComponent(typeof(UnityEngine.AudioSource));
    self.pool.playOnAwake = false;
    self.pool.loop = true;
    self.pool.volume = MusicManager:GetMusicVolume();
    self.pool.mute = not MusicManager:GetIsPlayMV();
    self.pool.transform:SetParent(OneWPBYEntry.transform);
end
function OneWPBY_Audio.PlayBGM(mode)
    --播放bgm
    self.pool:Stop();
    local rc = MusicManager:GetIsPlayMV();
    local audioclip = nil;
    if mode == nil then
        audioclip = OneWPBYEntry.soundList:Find(self.SoundList.BGM):GetComponent("AudioSource");
    else
        audioclip = OneWPBYEntry.soundList:Find(mode):GetComponent("AudioSource");
    end
    self.pool.clip = audioclip.clip;
    self.pool:Play();
end
function OneWPBY_Audio.PlayFire()
    if self.pool.transform:Find(self.SoundList.Shoot) ~= nil then
        return ;
    end
    self.PlaySound(self.SoundList.Shoot);
end
function OneWPBY_Audio.PlaySound(soundName, time)
    if soundName == nil then
        error("不存在该音效");
        return ;
    end
    local isPlay = MusicManager:GetIsPlaySV();
    if not isPlay then
        return ;
    end
    local volumn = MusicManager:GetSoundVolume();
    --if PlayerPrefs.HasKey("SoundValue") then
    --    volumn = tonumber(PlayerPrefs.GetString("SoundValue"));
    --end
    local obj = OneWPBYEntry.soundList:Find(soundName);
    if obj == nil then
        error("没有找到该音效:" .. soundName);
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
function OneWPBY_Audio.ClearAuido(soundName)
    local sound = self.pool.transform:Find(soundName);
    if sound ~= nil then
        destroy(sound.gameObject);
    end
end