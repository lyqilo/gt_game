YGBH_Audio = {};

local self = YGBH_Audio;

self.SoundList = {
    ADDSPEED = "AddSpeed", --加速
    BETFORCE = "betforce",
    BGM_ZX = "BGM_ZX"; --紫霞背景音乐
    BGM_BJJ = "BGM_BJJ"; --白晶晶背景音乐
    BTN = "Button", --按钮音乐
    FREESELECT = "Ding", --选择免费类型
    FIREGOLD = "FireGold",
    HIGHWIN1 = "HighWin1",
    HIGHWIN2 = "HighWin2",
    KULOU = "KuLou", --骷髅
    SMALLEND = "LotteryRoll", --小游戏停止
    OPENCARD = "OpenCard", --开启卡片
    BJJEFECT = "BJJ_Effect", --白晶晶粒子音效
    COLLECTEFFECT = "CollectEffect", --收集卡片音效
    SCATTER1 = "Scatter1", --scatter1
    SCATTER2 = "Scatter2", --scatter2
    SCATTER3 = "Scatter3", --scatter3
    RS = "Stop", --每列停止音乐
    SMALLSTART = "TanChuang2", --小游戏开始
    FREESTART = "TanChuang1", --免费开始
    ZXEFFECT = "LingDang", --紫霞铃铛
    TIMEDOWN = "Down"--免费五秒倒计时
}
self.pool = nil;
function YGBH_Audio.Init()
    self.pool = GameObject.New("AudioPool"):AddComponent(typeof(UnityEngine.AudioSource));
    self.pool.playOnAwake = false;
    self.pool.loop = true;
    self.pool.volume = MusicManager.musicVolume;
    self.pool.mute = not AllSetGameInfo._5IsPlayAudio;
    self.pool.transform:SetParent(YGBHEntry.MainContent);
end
function YGBH_Audio.PlayBGM(mode)
    log("播放背景音乐");
    --播放bgm
    self.pool:Stop();
    local audioclip = nil;
    if mode == nil then
        return ;
    else
        audioclip = YGBHEntry.soundList:Find(mode):GetComponent("AudioSource");
    end
    self.pool.clip = audioclip.clip;
    self.pool:Play();
end

function YGBH_Audio.PlaySound(soundName, time)
    local isPlay = AllSetGameInfo._6IsPlayEffect;
    if not isPlay then
        return ;
    end
    local volumn = 1;
    if PlayerPrefs.HasKey("SoundValue") then
        volumn = tonumber(PlayerPrefs.GetString("SoundValue"));
    end
    local obj = YGBHEntry.soundList:Find(soundName);
    if obj == nil then
        error("没有找到该音效");
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
function YGBH_Audio.ClearAuido(soundName)
    local sound = self.pool.transform:Find(soundName);
    if sound ~= nil then
        destroy(sound.gameObject);
    end
end