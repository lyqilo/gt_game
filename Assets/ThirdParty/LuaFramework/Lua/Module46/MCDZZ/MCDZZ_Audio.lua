MCDZZ_Audio = {};

local self = MCDZZ_Audio;

self.SoundList = {
    BGM = "bg", --背景音乐
    freeGameBg = "freeGameBg", --免费
    RR = "rollBegin5", --旋转
    moneyAdd = "moneyAdd", --加注
    RS = "mati", --
    BTN = "buttonClick", --按钮音乐
    BTN1 = "buttonClick1", --按钮音乐 Button_6
    BTN2 = "buttonClick2", --按钮音乐 failScatter3
    LINE = "resultShowOver", --连线
    goldFly = "goldFly", --
    smallWin = "smallWin", --
    goldToGround = "goldToGround", --
    Button_4 = "Button_4", --出现第一个的
    Button_5 = "Button_5", --出现第er个的
    Button_6 = "Button_6", --出现第san个的
    mao1 = "mao1", --
    mao2 = "mao2", --
    gou1 = "gou1", --
    gou2 = "gou2", --
    gou3 = "gou3", --
    bigWin3 = "bigWin3", --按钮音乐
    levelUp = "levelUp", --
    failScatter3 = "failScatter3", --

    GuoChang = "GuoChang", --
    Jiasu_150_2s = "Jiasu_150_2s", --

    roll = "roll", --旋转
    GuoChang = "GuoChang", --
    failTwo = "failTwo", --
    rolling = "rolling", --
    scatter1 = "scatter1", --
    scatter2 = "scatter2", --
    scatter3 = "scatter3", --
    ScatterShow = "ScatterShow", --
    COIN = "Coin", --硬币

}
self.pool = nil;
function MCDZZ_Audio.Init()
    self.pool = GameObject.New("AudioPool"):AddComponent(typeof(UnityEngine.AudioSource));
    self.pool.playOnAwake = false;
    self.pool.loop = true;
    self.pool.volume = MusicManager:GetMusicVolume();
    self.pool.mute = not MusicManager:GetIsPlayMV();
    self.pool.transform:SetParent(MCDZZEntry.MainContent:Find("Content"));
end
function MCDZZ_Audio.PlayBGM(mode)
    --播放bgm
    self.pool:Stop();
    local rc = MusicManager:GetIsPlayMV();
    local audioclip = nil;
    if mode == nil then
        audioclip = MCDZZEntry.soundList:Find(self.SoundList.BGM):GetComponent("AudioSource");
    else
        audioclip = MCDZZEntry.soundList:Find(mode):GetComponent("AudioSource");
    end
    self.pool.clip = audioclip.clip;
    self.pool:Play();
end

function MCDZZ_Audio.PlaySound(soundName, time)
    local isPlay = MusicManager:GetIsPlaySV();
    if not isPlay then
        return ;
    end
    local volumn = MusicManager:GetSoundVolume();
    --if PlayerPrefs.HasKey("SoundValue") then
    --    volumn = tonumber(PlayerPrefs.GetString("SoundValue"));
    --end
    local obj = MCDZZEntry.soundList:Find(soundName);
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