WSZS_Audio = {};

local self = WSZS_Audio;

self.SoundList = {
    BGM = "BGM", --背景音乐
    BGMFree = "FreeBGM", --背景音乐
    BTN = "Button", --按钮音乐
    BTN1 = "Button1", --按钮音乐
    RS = "RollStop", --每列停止音乐
    NormalWin = "NormalWin", --连线
    MiddleWin = "MiddleWin", --加注
    BigWin = "BigWin", --减注
    Attack = "Attack", --超大倍率音乐
    Broken = "Broken", --超大倍率音乐
    CollectCoin = "CollectCoin", --超大倍率音乐
    DangLose = "DangLose", --超大倍率音乐
    FreeWS = "FreeWS", --超大倍率音乐
    FreeWin = "FreeWin", --超大倍率音乐
    FreeLose = "FreeLose", --超大倍率音乐
    LongPress = "LongPress", --超大倍率音乐
    AddSpeedStop = "AddSpeedStop", --超大倍率音乐
    AddSpeed = "AddSpeed", --超大倍率音乐
    Dao = "Dao", --超大倍率音乐
    Ling = "Ling", --超大倍率音乐
    Sha = "Sha", --超大倍率音乐
    MonsterB = "MonsterB", --超大倍率音乐
    WSZSN = "WSZSN", --超大倍率音乐
    WSZSLD = "WSZSLD", --超大倍率音乐
    CloseWindow = "CloseWindow", --超大倍率音乐
}
self.pool = nil;
function WSZS_Audio.Init()
    self.pool = GameObject.New("AudioPool"):AddComponent(typeof(UnityEngine.AudioSource));
    self.pool.playOnAwake = false;
    self.pool.loop = true;
    self.pool.volume = MusicManager:GetMusicVolume();
    self.pool.mute = not MusicManager:GetIsPlayMV();
    self.pool.transform:SetParent(WSZSEntry.MainContent:Find("Content"));
end
function WSZS_Audio.PlayBGM(mode)
    --播放bgm
    self.pool:Stop();
    local rc = MusicManager:GetIsPlayMV();
    local audioclip = nil;
    if mode == nil then
        audioclip = WSZSEntry.soundList:Find(self.SoundList.BGM):GetComponent("AudioSource");
    else
        audioclip = WSZSEntry.soundList:Find(mode):GetComponent("AudioSource");
    end
    self.pool.clip = audioclip.clip;
    self.pool:Play();
end
function WSZS_Audio.PlaySoundAtTime(soundName, startTime, time)
    if soundName == nil or soundName == "" then
        error("sound Name is null");
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
    local obj = WSZSEntry.soundList:Find(soundName);
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
    audio.time = startTime;
    audio:Play();
    local timer = time;
    if timer == nil then
        timer = audio.clip.length;
    end
    GameObject.Destroy(audio.gameObject, timer);
end
function WSZS_Audio.PlaySound(soundName, time)
    if soundName == nil or soundName == "" then
        error("sound Name is null");
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
    local obj = WSZSEntry.soundList:Find(soundName);
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
function WSZS_Audio.ClearAuido(soundName)
    local sound = self.pool.transform:Find(soundName);
    if sound ~= nil then
        destroy(sound.gameObject);
    end
end