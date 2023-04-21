JPM_Audio = {};

local self = JPM_Audio;

self.SoundList = {
    BGM = "BGM_Normal", --背景音乐
    BTN = "Button", --按钮音乐
    --FreeBGM = "BGM_Free", --财神音乐
    RS = "RawStop", --每列停止音乐
    LINE = "Win", --连线
    RR = "RawRoll", --旋转
    COIN = "Coin", --硬币

    --ADDBET = "AddBet", --加注
    --REDUCEBET = "ReduceBet", --减注
    -- BW = "BigWin", --超大倍率音乐
    -- MW = "MegaWin", --超大倍率音乐
    -- SW = "SuperWin"--超大倍率音乐
}
self.pool = nil;
function JPM_Audio.Init()
    self.pool = GameObject.New("AudioPool"):AddComponent(typeof(UnityEngine.AudioSource));
    self.pool.playOnAwake = false;
    self.pool.loop = true;
    self.pool.volume = MusicManager:GetMusicVolume();
    self.pool.mute = not MusicManager:GetIsPlayMV();
    self.pool.transform:SetParent(JPMEntry.MainContent:Find("Content"));
end
function JPM_Audio.PlayBGM(mode)
    --播放bgm
    self.pool:Stop();
    local rc = MusicManager:GetIsPlayMV();
    local audioclip = nil;
    if mode == nil then
        audioclip = JPMEntry.soundList:Find(self.SoundList.BGM):GetComponent("AudioSource");
    else
        audioclip = JPMEntry.soundList:Find(mode):GetComponent("AudioSource");
    end
    self.pool.clip = audioclip.clip;
    self.pool:Play();
end

function JPM_Audio.PlaySound(soundName, time)
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
    local obj = JPMEntry.soundList:Find(soundName);
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