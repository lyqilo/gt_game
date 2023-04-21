TGG_Audio = {};

local self = TGG_Audio;

self.SoundList = {
    BGM = "BGM_Normal", --背景音乐
    BTN = "Button", --按钮音乐
    FreeBGM = "BGM_Free", --财神音乐
    RS = "RawStop", --每列停止音乐
    LINE = "Win", --连线
    ADDBET = "AddBet", --加注
    REDUCEBET = "ReduceBet", --减注
    BW = "BigWin", --超大倍率音乐
    MW = "MegaWin", --超大倍率音乐
    SW = "SuperWin"--超大倍率音乐
}
self.pool = nil;
function TGG_Audio.Init()
    self.pool = GameObject.New("AudioPool"):AddComponent(typeof(UnityEngine.AudioSource));
    self.pool.playOnAwake = false;
    self.pool.loop = true;
    self.pool.volume = MusicManager.musicVolume;
    self.pool.mute = not AllSetGameInfo._5IsPlayAudio;
    self.pool.transform:SetParent(TGGEntry.MainContent:Find("Content"));
end
function TGG_Audio.PlayBGM(mode)
    --播放bgm
    self.pool:Stop();
    local rc = AllSetGameInfo._5IsPlayAudio;
    local audioclip = nil;
    if mode == nil then
        audioclip = TGGEntry.soundList:Find(self.SoundList.BGM):GetComponent("AudioSource");
    else
        audioclip = TGGEntry.soundList:Find(mode):GetComponent("AudioSource");
    end
    self.pool.clip = audioclip.clip;
    self.pool:Play();
end

function TGG_Audio.PlaySound(soundName, time)
    local isPlay = AllSetGameInfo._6IsPlayEffect;
    if not isPlay then
        return ;
    end
    local volumn = 1;
    if PlayerPrefs.HasKey("SoundValue") then
        volumn = tonumber(PlayerPrefs.GetString("SoundValue"));
    end
    local obj = TGGEntry.soundList:Find(soundName);
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