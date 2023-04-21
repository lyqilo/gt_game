JSYC_Audio = {};

local self = JSYC_Audio;

self.SoundList = {
    BGM = "BGM_Normal", --背景音乐
    BGM2 = "BGM_Free", --背景音乐
    FreeBGM = "FreeMusic", --财神音乐
    BTN = "Button", --按钮音乐
    LINE = "Win", --连线
    BW = "Win0", --超大倍率音乐
    RS = "LineEnd", --每列停止音乐
    RollStart = "RollStart", --每列停止音乐
    FreeGameIn = "FreeGameIn", --按钮音乐
    Multiplier = "Multiplier", --按钮音乐
}
self.pool = nil;
function JSYC_Audio.Init()
    self.pool = GameObject.New("AudioPool"):AddComponent(typeof(UnityEngine.AudioSource));
    self.pool.playOnAwake = false;
    self.pool.loop = true;
    self.pool.volume = MusicManager:GetMusicVolume();
    self.pool.mute = not MusicManager:GetIsPlayMV();
    self.pool.transform:SetParent(JSYCEntry.MainContent:Find("Content"));
end
function JSYC_Audio.PlayBGM(mode)
    --播放bgm
    self.pool:Stop();
    local rc = MusicManager:GetIsPlayMV();
    local audioclip = nil;
    if mode == nil then
        local num=math.random(1,2)
        if num==1 then
            audioclip = JSYCEntry.soundList:Find(self.SoundList.BGM):GetComponent("AudioSource");
        else
            audioclip = JSYCEntry.soundList:Find(self.SoundList.BGM2):GetComponent("AudioSource");
        end
    else
        audioclip = JSYCEntry.soundList:Find(mode):GetComponent("AudioSource");
    end
    self.pool.clip = audioclip.clip;
    self.pool:Play();
end

function JSYC_Audio.PlaySound(soundName, time)
    local isPlay = MusicManager:GetIsPlaySV();
    if not isPlay then
        return ;
    end
    local volumn = MusicManager:GetSoundVolume();
    local obj = JSYCEntry.soundList:Find(soundName);
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