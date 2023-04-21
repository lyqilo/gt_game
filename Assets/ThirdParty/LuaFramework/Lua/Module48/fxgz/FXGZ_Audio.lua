FXGZ_Audio = {};

local self = FXGZ_Audio;

self.SoundList = {
    BGM = "BGM", --背景音乐
    BGMFree = "BGMFree", --背景音乐
    BGMBonus = "BGMBonus", --背景音乐
    BGMReSpin = "BGMReSpin", --背景音乐
    BTN = "Button", --按钮音乐
    RStart = "RawRoll", --每列停止音乐
    RollStop = "RawStop", --每列停止音乐
    Rolling = "Rolling", --每列停止音乐
    LongPress = "LongPress",
    Coin = "Coin",
    TST = "TST",
    AddSpeed = "AddSpeed",
    Award = "Award",
    AwardLine = "AwardLine",
    BigJB = "BigJB", --连线
    JB = "JB", --连线
    BigWin1 = "BigWin1", --连线
    BigWin2 = "BigWin2", --超大倍率音乐
    SmallGameClick = "SmallGameClick", --超大倍率音乐
    SmallGameResult = "SmallGameResult", --超大倍率音乐
    FreeEnd = "FreeEnd", --超大倍率音乐
    FreeShowBei = "FreeShowBei", --超大倍率音乐
}
self.pool = nil;
function FXGZ_Audio.Init()
    self.pool = GameObject.New("AudioPool"):AddComponent(typeof(UnityEngine.AudioSource));
    self.pool.playOnAwake = false;
    self.pool.loop = true;
    self.pool.volume = MusicManager:GetMusicVolume();
    self.pool.mute = not MusicManager:GetIsPlayMV();
    self.pool.transform:SetParent(FXGZEntry.MainContent:Find("Content"));
end
function FXGZ_Audio.PlayBGM(mode)
    --播放bgm
    self.pool:Stop();
    local rc = MusicManager:GetIsPlayMV();
    local audioclip = nil;
    if mode == nil then
        audioclip = FXGZEntry.soundList:Find(self.SoundList.BGM):GetComponent("AudioSource");
    else
        audioclip = FXGZEntry.soundList:Find(mode):GetComponent("AudioSource");
    end
    self.pool.clip = audioclip.clip;
    self.pool:Play();
end

function FXGZ_Audio.PlaySound(soundName, time)
    if soundName == nil then
        error("不存在该音效:"..soundName);
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
    local obj = FXGZEntry.soundList:Find(soundName);
    if obj == nil then
        error("没有找到该音效:"..soundName);
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
function FXGZ_Audio.ClearAuido(soundName)
    local sound = self.pool.transform:Find(soundName);
    if sound ~= nil then
        destroy(sound.gameObject);
    end
end