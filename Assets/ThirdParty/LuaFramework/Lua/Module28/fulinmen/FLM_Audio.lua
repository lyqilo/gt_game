FLM_Audio = {};

local self = FLM_Audio;

self.SoundList = {
    BGM = "BGM", --背景音乐
    BGMFree = "BGM_Free", --免费背景音乐
    BGMCoin = "BGM_Coin", --堆金积玉背景音乐
    BGMFire = "BGM_Fire", --堆金积玉背景音乐
    BTN = "Button", --按钮音乐
    Bell = "Bell",--进入堆金积玉
    Cock = "Cock",
    BoyLaugh = "BoyLaugh",
    Coin1 = "Coin1",
    Coin2 = "Coin2",
    Coin3 = "Coin3",
    Coin4 = "Coin4",
    Coin5 = "Coin5",
    Coin_Collect = "Coin_Collect",
    Coin_Fly = "Coin_Fly",
    Collect = "Collect",
    FireCrackerExplose = "FireCrackerExplose",
    FireWorkExplose = "FireWorkExplose",
    Jackpot = "Jackpot",
    Lion = "Lion",
    NCoin = "NCoin",--进入金币模式后
    NFree = "NFree",--进入免费后
    Turn = "Turn",
    TurnAT = "TurnAT",
    Win = "Win",
    WinBig = "WinBig",
}
self.pool = nil;
function FLM_Audio.Init()
    self.pool = GameObject.New("AudioPool"):AddComponent(typeof(UnityEngine.AudioSource));
    self.pool.playOnAwake = false;
    self.pool.loop = true;
    self.pool.volume = MusicManager:GetMusicVolume();
    self.pool.mute = not MusicManager:GetIsPlayMV();
    self.pool.transform:SetParent(FLMEntry.transform:Find("Content"));
end
function FLM_Audio.PlayBGM(mode)
    --播放bgm
    self.pool:Stop();
    local rc = AllSetGameInfo._5IsPlayAudio;
    local audioclip = nil;
    if mode == nil then
        audioclip = FLMEntry.soundList:Find(self.SoundList.BGM):GetComponent("AudioSource");
    else
        audioclip = FLMEntry.soundList:Find(mode):GetComponent("AudioSource");
    end
    self.pool.clip = audioclip.clip;
    self.pool:Play();
end

function FLM_Audio.PlaySound(soundName, time)
    if soundName == nil then
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
    local obj = FLMEntry.soundList:Find(soundName);
    if obj == nil then
        error("没有找到该音效");
        return ;
    end
    local go = newObject(obj.gameObject);
    go.transform:SetParent(self.pool.transform);
    go.transform.localPosition = Vector3.New(0, 0, 0);
    local audio = go.transform:GetComponent("AudioSource");
    audio.volume = volumn;
    audio:Play();
    local timer = time;
    if timer == nil then
        timer = audio.clip.length;
    end
    GameObject.Destroy(audio.gameObject, timer);
end