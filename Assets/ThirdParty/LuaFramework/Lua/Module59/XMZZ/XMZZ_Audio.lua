XMZZ_Audio = {};

local self = XMZZ_Audio;

self.SoundList = {
    BGM = "Panda_Bgm", --背景音乐
    FreeBGM = "Panda_FreeBgm", --背景音乐
    BTN = "Panda_Button", --按钮音乐
    RollStop = "Panda_TurnStop",
    Panda_Spin = "Panda_Spin",
    Panda_Singleline = "Panda_Singleline",
    Panda_Normal_Win = "Panda_Normal_Win",
    Panda_JackPot = "Panda_JackPot",
    Panda_FreeSpins = "Panda_FreeSpins",
    Panda_FlyCoins = "Panda_FlyCoins",
    Panda_Click = "Panda_Click",
    Panda_Button = "Panda_Button",
    Panda_BigWin = "Panda_BigWin"
}
self.pool = nil;
function XMZZ_Audio.Init()
    self.pool = GameObject.New("AudioPool"):AddComponent(typeof(UnityEngine.AudioSource));
    self.pool.playOnAwake = false;
    self.pool.loop = true;
    self.pool.volume = MusicManager.musicVolume;
    self.pool.mute = not AllSetGameInfo._5IsPlayAudio;
    self.pool.transform:SetParent(XMZZEntry.MainContent:Find("Content"));
end
function XMZZ_Audio.PlayBGM(mode)
    --播放bgm
    self.pool:Stop();
    local rc = AllSetGameInfo._5IsPlayAudio;
    local audioclip = nil;
    if mode == nil then
        audioclip = XMZZEntry.soundList:Find(self.SoundList.BGM):GetComponent("AudioSource");
    else
        audioclip = XMZZEntry.soundList:Find(mode):GetComponent("AudioSource");
    end
    self.pool.clip = audioclip.clip;
    self.pool:Play();
end
function XMZZ_Audio.MuteSound()
    self.pool.mute = true;
    for i = self.pool.transform.childCount, 1, -1 do
        self.pool.transform:GetChild(i - 1):GetComponent("AudioSource").mute = true;
    end
end
function XMZZ_Audio.ResetSound()
    self.pool.mute = false;
    for i = self.pool.transform.childCount, 1, -1 do
        self.pool.transform:GetChild(i - 1):GetComponent("AudioSource").mute = false;
    end
end
function XMZZ_Audio.PlaySound(soundName, time)
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
    local obj = XMZZEntry.soundList:Find(soundName);
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
function XMZZ_Audio.ClearAuido(soundName)
    local sound = self.pool.transform:Find(soundName);
    if sound ~= nil then
        destroy(sound.gameObject);
    end
end