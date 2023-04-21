SESX_Audio = {};

local self = SESX_Audio;

self.SoundList = {
    BTN = "Shengxiao_Normal_Item",
    BGM = "Shengxiao_Normal_Bgm", --背景音乐
    FreeBGM = "Shengxiao_FreeSpin_Bgm", --背景音乐
    RollStop = "Shengxiao_Normal_Weelstop", --每列停止音乐
    Rolling = "Shengxiao_Normal_Wheelroll", --每列停止音乐
    Shengxiao_Wild_Win = "Shengxiao_Wild_Win",
    Shengxiao_Wild_Second = "Shengxiao_Wild_Second",
    Shengxiao_Wild_Move = "Shengxiao_Wild_Move";
    Shengxiao_Wild_First = "Shengxiao_Wild_First",
    Shengxiao_Wild = "Shengxiao_Wild",
    Shengxiao_SpeedUp = "Shengxiao_SpeedUp",
    Shengxiao_Scatter_Third = "Shengxiao_Scatter_Third",
    Shengxiao_Scatter_Second = "Shengxiao_Scatter_Second",
    Shengxiao_Scatter_First = "Shengxiao_Scatter_First",
    Shengxiao_Normal_YMS = "Shengxiao_Normal_YMS",
    Shengxiao_Normal_Win = "Shengxiao_Normal_Win",
    Shengxiao_Normal_Sp = "Shengxiao_Normal_Sp",
    Shengxiao_Normal_Rabbit = "Shengxiao_Normal_Rabbit",
    Shengxiao_Normal_Mouse = "Shengxiao_Normal_Mouse",
    Shengxiao_Normal_Item = "Shengxiao_Normal_Item",
    Shengxiao_Normal_Fivekind = "Shengxiao_Normal_Fivekind",
    Shengxiao_Normal_Cattle = "Shengxiao_Normal_Cattle",
    Shengxiao_Normal_Autospin = "Shengxiao_Normal_Autospin",
    Shengxiao_Jackpot_Win = "Shengxiao_Jackpot_Win",
    Shengxiao_FreeSpin_End = "Shengxiao_FreeSpin_End",
    Shengxiao_FreeSpin_Awad = "Shengxiao_FreeSpin_Awad",
    Shengxiao_BigWin = "Shengxiao_BigWin",
    Shengxiao_AddCoin = "Shengxiao_AddCoin",
    Flame_BigWin = "Flame_BigWin"
}
self.pool = nil;
function SESX_Audio.Init()
    self.pool = GameObject.New("AudioPool"):AddComponent(typeof(UnityEngine.AudioSource));
    self.pool.playOnAwake = false;
    self.pool.loop = true;
    self.pool.volume = MusicManager.musicVolume;
    self.pool.mute = not AllSetGameInfo._5IsPlayAudio;
    self.pool.transform:SetParent(SESXEntry.MainContent:Find("Content"));
end
function SESX_Audio.PlayBGM(mode)
    --播放bgm
    self.pool:Stop();
    local rc = AllSetGameInfo._5IsPlayAudio;
    local audioclip = nil;
    if mode == nil then
        audioclip = SESXEntry.soundList:Find(self.SoundList.BGM):GetComponent("AudioSource");
    else
        audioclip = SESXEntry.soundList:Find(mode):GetComponent("AudioSource");
    end
    self.pool.clip = audioclip.clip;
    self.pool:Play();
end

function SESX_Audio.PlaySound(soundName, time)
    if soundName == nil then
        error("不存在该音效" .. soundName);
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
    local obj = SESXEntry.soundList:Find(soundName);
    if obj == nil then
        error("没有找到该音效" .. soundName);
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
function SESX_Audio.MuteSound()
    for i = self.pool.transform.childCount, 1, -1 do
        self.pool.transform:GetChild(i - 1):GetComponent("AudioSource").mute = true;
    end
end
function SESX_Audio.ResetSound()
    for i = self.pool.transform.childCount, 1, -1 do
        self.pool.transform:GetChild(i - 1):GetComponent("AudioSource").mute = false;
    end
end
function SESX_Audio.ClearAuido(soundName)
    local sound = self.pool.transform:Find(soundName);
    if sound ~= nil then
        destroy(sound.gameObject);
    end
end