JZSF_Audio = {};

local self = JZSF_Audio;

self.SoundList = {
    BGM = "BGM", --背景音乐
    FreeBGM = "BGM_Free", --财神音乐
    RS = "RawStop", --每列停止音乐
    RS5 = "RawStop5", --每列停止音乐
    StartRoll = "StartRoll", --每列停止音乐
    LINE = "Win", --连线
    FreeResult = "FreeResult",


    -- BTN = "Button", --按钮音乐
    -- SCATTER1 = "Scatter1",
    -- SCATTER2 = "Scatter2",
    -- SCATTER3 = "Scatter3",
    -- SCATTER4 = "Scatter4",
    -- SCATTER5 = "Scatter5",
    --Speed = "Speed",
    --TotalFreeResult = "TotalFreeResult",
    --Counting = "Counting",
    --WILD = "Wild",
    -- BW = "BigWin", --超大倍率音乐
    -- MW = "MegaWin", --超大倍率音乐
    -- SW = "SuperWin"--超大倍率音乐
}
self.pool = nil;
function JZSF_Audio.Init()
    self.pool = GameObject.New("AudioPool"):AddComponent(typeof(UnityEngine.AudioSource));
    self.pool.playOnAwake = false;
    self.pool.loop = true;
    self.pool.volume = MusicManager.musicVolume;
    self.pool.mute = not AllSetGameInfo._5IsPlayAudio;
    self.pool.transform:SetParent(JZSFEntry.MainContent:Find("Content"));
end
function JZSF_Audio.PlayBGM(mode)
    --播放bgm
    self.pool:Stop();
    local rc = AllSetGameInfo._5IsPlayAudio;
    local audioclip = nil;
    if mode == nil then
        audioclip = JZSFEntry.soundList:Find(self.SoundList.BGM):GetComponent("AudioSource");
    else
        audioclip = JZSFEntry.soundList:Find(mode):GetComponent("AudioSource");
    end
    self.pool.clip = audioclip.clip;
    self.pool:Play();
end

function JZSF_Audio.ResetEffect()
    for i = 1, self.pool.transform.childCount do
        if self.pool.transform:GetChild(i - 1) ~= nil then
            self.pool.transform:GetChild(i - 1).gameObject:SetActive(false);
        end
    end
end
function JZSF_Audio.PlaySound(soundName, time)
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
    local obj = JZSFEntry.soundList:Find(soundName);
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