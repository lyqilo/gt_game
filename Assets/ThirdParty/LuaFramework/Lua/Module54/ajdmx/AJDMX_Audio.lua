AJDMX_Audio = {};

local self = AJDMX_Audio;

local rollGO={}

self.SoundList = {
    BGM = "BGM",
    FreeBgm ="FreeBgm",--nv
    BtnClick ="btnClick",
    speed1 ="addspeed",--nv


    mati_01 ="mati_01",--nv
    rollBegin5 ="rollBegin5",--nv

    win ="win",--0

    titleMove ="titleMove",--nv
    moneyAdd ="moneyAdd",--nv
    goldToGround ="goldToGround",--nv
    goldFly ="goldFly",--nv
    moneySmallWin ="moneySmallWin",--nv
    freeBoundS1 ="freeBoundS1",--nv
    freeBoundS2 ="freeBoundS2",--nv
    freeBoundS3 ="freeBoundS3",--nv
    bigWin ="bigWin",
}
self.pool = nil;
function AJDMX_Audio.Init()
    self.pool = GameObject.New("AudioPool"):AddComponent(typeof(UnityEngine.AudioSource));
    self.pool.playOnAwake = false;
    self.pool.loop = true;
    self.pool.volume = MusicManager:GetMusicVolume();
    self.pool.mute = not MusicManager:GetIsPlayMV();
    self.pool.transform:SetParent(AJDMXEntry.MainContent);
end
function AJDMX_Audio.PlayBGM(mode)
    log("播放背景音乐");
    --播放bgm
    self.pool:Stop();
    local audioclip = nil;
    if mode == nil then
        audioclip = AJDMXEntry.soundList:Find(self.SoundList.BGM):GetComponent("AudioSource");
    else
        audioclip = AJDMXEntry.soundList:Find(mode):GetComponent("AudioSource");
    end
    self.pool.clip = audioclip.clip;
    self.pool:Play();
end

function AJDMX_Audio.PlaySound(soundName, time)
    local isPlay = MusicManager:GetIsPlaySV();
    if not isPlay then
        return ;
    end
    local volumn = MusicManager:GetSoundVolume();
    --if PlayerPrefs.HasKey("SoundValue") then
    --    volumn = tonumber(PlayerPrefs.GetString("SoundValue"));
    --end
    local obj = AJDMXEntry.soundList:Find(soundName);
    if obj == nil then
        error("没有找到该音效");
        return ;
    end
    local go = newObject(obj.gameObject);
    go.transform:SetParent(self.pool.transform);
    go.transform.localPosition = Vector3.New(0, 0, 0);
    go.name=soundName
    if soundName=="rollBegin5" then
        table.insert( rollGO,#rollGO+1,go)
    end
    local audio = go.transform:GetComponent("AudioSource");
    audio.volume = volumn;
    audio:Play();
    local timer = time;
    if timer == nil then
        timer = audio.clip.length;
    end
    GameObject.Destroy(audio.gameObject, timer);
end

function AJDMX_Audio.StopPlaySound(soundName)
    logYellow("soundName====="..soundName)
    for i=1,#rollGO do
        if rollGO[i]==nil then
            table.remove(rollGO,i)
            return
        end
        if soundName==rollGO[i].name  then
            GameObject.Destroy(rollGO[i]);   
            table.remove(rollGO,i)
        end
    end
end