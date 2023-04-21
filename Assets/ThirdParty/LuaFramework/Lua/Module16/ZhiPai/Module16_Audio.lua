Module16_Audio = {};

local self = Module16_Audio;

self.SoundList = {
    BGM = "BGM", --背景音乐
    BJ_Free = "BJ_Free", --背景音乐
    BJ_SGame = "BJ_SGame", --背景音乐

    BTN = "Button", --按钮音乐
    BW="winBig",--  dabeilv
    WSGame="WinSmall",--xyxuode 
    Gold_Big="Gold_Big",--
    RS = "FB_Stop", --每列停止音乐
    --LINE = "Line", --连线音乐
   -- SG = "SuperGold",--超大倍率音
}
self.pool = nil;
function Module16_Audio.Init()
    self.pool = GameObject.New("AudioPool"):AddComponent(typeof(UnityEngine.AudioSource));
    self.pool.playOnAwake = false;
    self.pool.loop = true;
    self.pool.volume = MusicManager:GetMusicVolume();
    self.pool.mute = not MusicManager:GetIsPlayMV();
    self.pool.transform:SetParent(Module16Entry.transform:Find("Content"));
end
function Module16_Audio.PlayBGM(mode)
    --播放bgm
    self.pool:Stop();
    local rc = MusicManager:GetIsPlayMV();
    local audioclip = nil;
    if mode == nil then
        audioclip = Module16Entry.soundList:Find(self.SoundList.BGM):GetComponent("AudioSource");
    else
        audioclip = Module16Entry.soundList:Find(mode):GetComponent("AudioSource");
    end
    self.pool.clip = audioclip.clip;
    self.pool:Play();
end

function Module16_Audio.PlaySound(soundName, time)
    local isPlay = MusicManager:GetIsPlaySV();
    if not isPlay then
        return ;
    end
    local volumn = MusicManager:GetSoundVolume();
    --if PlayerPrefs.HasKey("SoundValue") then
    --    volumn = tonumber(PlayerPrefs.GetString("SoundValue"));
    --end
    local obj = Module16Entry.soundList:Find(soundName);
    if obj == nil then
        error("没有找到该音效 "..soundName);
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