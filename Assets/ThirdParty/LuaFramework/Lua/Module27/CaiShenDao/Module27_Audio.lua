Module27_Audio = {};

local self = Module27_Audio;

self.SoundList = {
    BGM = "BGM", --背景音乐
    BTN = "Button", --按钮音乐
    DS = "DownScore", --跑分音乐
    GO = "Go", --开始音乐
    CSJLBGM = "CSJLBGM", --财神音乐
    CYGG = "CYGG", --财源滚滚音乐
    JYMT = "JYMT", --金玉满堂音乐
    LINE = "Line", --连线音乐
    RS = "RawStop", --每列停止音乐
    SG = "SuperGold"--超大倍率音乐
}
self.pool = nil;
function Module27_Audio.Init()
    self.pool = GameObject.New("AudioPool"):AddComponent(typeof(UnityEngine.AudioSource));
    self.pool.playOnAwake = false;
    self.pool.loop = true;
    self.pool.volume = MusicManager:GetMusicVolume();
    self.pool.mute = not MusicManager:GetIsPlayMV();
    self.pool.transform:SetParent(Module27.transform:Find("Content"));
end
function Module27_Audio.PlayBGM(mode)
    --播放bgm
    self.pool:Stop();
    local rc = MusicManager:GetIsPlayMV();
    local audioclip = nil;
    if mode == nil then
        audioclip = Module27.soundList:Find(self.SoundList.BGM):GetComponent("AudioSource");
    else
        audioclip = Module27.soundList:Find(mode):GetComponent("AudioSource");
    end
    self.pool.clip = audioclip.clip;
    self.pool:Play();
end
function Module27_Audio.ResetEffect()
    for i = 1, self.pool.transform.childCount do
        if self.pool.transform:GetChild(i - 1) ~= nil then
            self.pool.transform:GetChild(i - 1).gameObject:SetActive(false);
        end
    end
end
function Module27_Audio.PlaySound(soundName, time)
    local isPlay = MusicManager:GetIsPlaySV();
    if not isPlay then
        return ;
    end
    local volumn = MusicManager:GetSoundVolume();
    --if PlayerPrefs.HasKey("SoundValue") then
    --    volumn = tonumber(PlayerPrefs.GetString("SoundValue"));
    --end
    local obj = Module27.soundList:Find(soundName);
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