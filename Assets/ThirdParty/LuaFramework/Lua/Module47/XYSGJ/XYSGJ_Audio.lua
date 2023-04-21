XYSGJ_Audio = {};

local self = XYSGJ_Audio;

self.SoundList = {
    BGM = "BGM_Normal", --背景音乐
    BGM_Free = "BGM_Free", --按钮音乐
    BTN = "yx_button", --财神音乐
    yx_longClick = "yx_longClick", --财神音乐
    yx_spin = "yx_spin", --财神音乐
    RS = "yx_dingge", --每列停止音乐
    yx_dingge = "yx_dingge", --财神音乐
    yx_zhuangchang = "yx_zhuangchang", --财神音乐
    yx_awardLine = "yx_awardLine", --财神音乐
    LINE = "yx_awardLine", --连线
    yx_addSpeed = "yx_addSpeed", --jaisu
    yx_big_win = "yx_big_win", --财神音乐
    yx_bigwin = "yx_bigwin", --财神音乐
    yx_bigwin_end = "yx_bigwin_end", --财神音乐
    yx_bonus3 = "yx_bonus3", --财神音乐
    dididi = "dididi", --财神音乐
    yx_awardtrue = "yx_awardtrue", --财神音乐
    yx_goldruku = "yx_goldruku", --财神音乐
    yx_jinbi = "yx_jinbi", --财神音乐
    yx_jinbi_bigwin = "yx_jinbi_bigwin", --财神音乐
    yx_leiji = "yx_leiji", --财神音乐
    zhuanpan_jf = "zhuanpan_jf", --财神音乐
    zhuanpan_jg = "zhuanpan_jg", --财神音乐
    yx_zhuanpan = "yx_zhuanpan", --财神音乐
}
self.pool = nil;
function XYSGJ_Audio.Init()
    self.pool = GameObject.New("AudioPool"):AddComponent(typeof(UnityEngine.AudioSource));
    self.pool.playOnAwake = false;
    self.pool.loop = true;
    self.pool.volume = MusicManager:GetMusicVolume();
    self.pool.mute = not MusicManager:GetIsPlayMV();
    self.pool.transform:SetParent(XYSGJEntry.MainContent:Find("Content"));
end
function XYSGJ_Audio.PlayBGM(mode)
    --播放bgm
    self.pool:Stop();
    local rc = MusicManager:GetIsPlayMV();
    local audioclip = nil;
    if mode == nil then
        audioclip = XYSGJEntry.soundList:Find(self.SoundList.BGM):GetComponent("AudioSource");
    else
        audioclip = XYSGJEntry.soundList:Find(mode):GetComponent("AudioSource");
    end
    self.pool.clip = audioclip.clip;
    self.pool:Play();
end

function XYSGJ_Audio.PlaySound(soundName, time)
    -- if true then
    --     return
    -- end

    local isPlay = MusicManager:GetIsPlaySV();
    if not isPlay then
        return ;
    end
    local volumn = MusicManager:GetSoundVolume();
    --if PlayerPrefs.HasKey("SoundValue") then
    --    volumn = tonumber(PlayerPrefs.GetString("SoundValue"));
    --end
    local obj = XYSGJEntry.soundList:Find(soundName);
    if obj == nil then
        error("没有找到该音效");
        return ;
    end
    local go = newObject(obj.gameObject);
    go.transform:SetParent(self.pool.transform);
    go.transform.localPosition = Vector3.New(0, 0, 0);
    go.gameObject.name = soundName;
    local audio = go.transform:GetComponent("AudioSource");
    audio.volume = volumn;
    audio:Play();
    local timer = time;
    if timer == nil then
        timer = audio.clip.length;
    end
    GameObject.Destroy(audio.gameObject, timer);
end
function XYSGJ_Audio.ClearAuido(soundName)
    log("soundname:" .. soundName);
    local sound = self.pool.transform:Find(soundName);
    log("sound:" .. tostring(sound == nil));
    if sound ~= nil then
        destroy(sound.gameObject);
    end
end