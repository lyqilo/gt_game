BQTP_Audio = {};

local self = BQTP_Audio;

self.SoundList = {
    BGM = "BGM", --背景音乐
    FreeBGM = "FreeBGM", --背景音乐
    BTN = "Button", --按钮音乐
    BigWin = "BigWin",
    FreeSpin_Awad = "FreeSpin_Awad";
    Normal_AutoSpin = "Normal_AutoSpin",
    Normal_Addbet = "Normal_Addbet",
    FreeSpin_End = "FreeSpin_End",
    Normal_Clear = "Normal_Clear",
    Normal_Double = "Normal_Double",
    Normal_Drop = "Normal_Drop",
    Normal_FiveKind = "Normal_FiveKind",
    Normal_Forward = "Normal_Forward",
    Normal_Guard = "Normal_Guard",
    Normal_Judge = "Normal_Judge",
    Normal_Keeper = "Normal_Keeper",
    Normal_MaxBet = "Normal_MaxBet",
    Normal_Reduce = "Normal_Reduce",
    Normal_ReelRun = "Normal_ReelRun",
    Normal_ReelStop = "Normal_ReelStop",
    Normal_Spin = "Normal_Spin",
    Normal_Win = "Normal_Win",
    NumberRunning = "NumberRunning",
    Scatter_Second = "Scatter_Second",
    Scatter_Speedup = "Scatter_Speedup",
    Scatter_Third = "Scatter_Third",
    Scattet_First = "Scattet_First",
    Smathing_Break = "Smathing_Break",
    Smathing_Cheer = "Smathing_Cheer",
    Smathing_Coming = "Smathing_Coming",
    Smathing_Crash = "Smathing_Crash",
    Smathing_End = "Smathing_End",
    Smathing_Frozen = "Smathing_Frozen",
    Smathing_Warning = "Smathing_Warning",
    Wild = "Wild",
    Wild_Cheer = "Wild_Cheer",
}
self.pool = nil;
function BQTP_Audio.Init()
    self.pool = GameObject.New("AudioPool"):AddComponent(typeof(UnityEngine.AudioSource));
    self.pool.playOnAwake = false;
    self.pool.loop = true;
    self.pool.volume = MusicManager:GetMusicVolume();
    self.pool.mute = not MusicManager:GetIsPlayMV();
    self.pool.transform:SetParent(BQTPEntry.MainContent:Find("Content"));
end
function BQTP_Audio.PlayBGM(mode)
    --播放bgm
    self.pool:Stop();
    local rc = MusicManager:GetIsPlayMV();
    local audioclip = nil;
    if mode == nil then
        audioclip = BQTPEntry.soundList:Find(self.SoundList.BGM):GetComponent("AudioSource");
    else
        audioclip = BQTPEntry.soundList:Find(mode):GetComponent("AudioSource");
    end
    self.pool.clip = audioclip.clip;
    self.pool:Play();
end
function BQTP_Audio.MuteSound()
    self.pool.mute = true;
    for i = self.pool.transform.childCount, 1, -1 do
        self.pool.transform:GetChild(i - 1):GetComponent("AudioSource").mute = true;
    end
end
function BQTP_Audio.ResetSound()
    self.pool.mute = false;
    for i = self.pool.transform.childCount, 1, -1 do
        self.pool.transform:GetChild(i - 1):GetComponent("AudioSource").mute = false;
    end
end
function BQTP_Audio.PlaySound(soundName, time)
    if soundName == nil then
        error("不存在该音效");
        return ;
    end
    local isPlay = MusicManager:GetIsPlaySV();
    if not isPlay then
        return ;
    end
    local volumn = MusicManager:GetMusicVolume();
    local obj = BQTPEntry.soundList:Find(soundName);
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
function BQTP_Audio.ClearAuido(soundName)
    local sound = self.pool.transform:Find(soundName);
    if sound ~= nil then
        destroy(sound.gameObject);
    end
end