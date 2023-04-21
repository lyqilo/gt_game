SHT_Audio = {};

local self = SHT_Audio;

self.SoundList = {
    --BGM = "BGM",
    BetClick ="betClick",
    CloseClick ="closeClick",
    BtnClick ="btnClick",
    EGold ="EGold",--9
    eMan ="eMan",--7
    eManPowerCar ="eManPowerCar",--5
    eSound ="eSound",    --4
    eWatch ="eWatch", -- 3
    eWild ="eWild", --8
    eWoman ="eWoman",--6
    FreeBgm ="FreeBgm",--nv
    mati_01 ="mati_01",--nv
    titleMove ="titleMove",--nv
    moneyAdd ="moneyAdd",--nv
    goldToGround ="goldToGround",--nv
    win ="win",--0
    goldFly ="goldFly",--nv
    rollBegin5 ="rollBegin5",--nv
    moneySmallWin ="moneySmallWin",--nv
    speed1 ="speed1",--nv
    freeBoundS1 ="freeBoundS1",--nv
    freeBoundS2 ="freeBoundS2",--nv
    freeBoundS3 ="freeBoundS3",--nv
    middleWin1 ="middleWin1",--nv
    guochang ="guochang",--nv


    bigWin ="bigWin",
    miniGameRun ="miniGameRun",--nv
    miniGameStart ="miniGameStart",--nv
    moneyBigWin ="moneyBigWin",--nv
    montyMiniGameWin ="montyMiniGameWin",--nv
    resultShowOver ="resultShowOver",--nv
    xuli_01 ="xuli_01",--nv
}
self.pool = nil;
function SHT_Audio.Init()
    self.pool = GameObject.New("AudioPool"):AddComponent(typeof(UnityEngine.AudioSource));
    self.pool.playOnAwake = false;
    self.pool.loop = true;
    self.pool.volume = MusicManager:GetMusicVolume();
    self.pool.mute = not MusicManager:GetIsPlayMV();
    self.pool.transform:SetParent(SHTEntry.MainContent);
end
function SHT_Audio.PlayBGM(mode)
    log("播放背景音乐");
    --播放bgm
    self.pool:Stop();
    local audioclip = nil;
    if mode == nil then
        return
        --audioclip = XYSGJEntry.soundList:Find(self.SoundList.BGM):GetComponent("AudioSource");
    else
        audioclip = SHTEntry.soundList:Find(mode):GetComponent("AudioSource");
    end
    self.pool.clip = audioclip.clip;
    self.pool:Play();
end

function SHT_Audio.PlaySound(soundName, time)
    local isPlay = MusicManager:GetIsPlaySV();
    if not isPlay then
        return ;
    end
    local volumn = MusicManager:GetSoundVolume();
    --if PlayerPrefs.HasKey("SoundValue") then
    --    volumn = tonumber(PlayerPrefs.GetString("SoundValue"));
    --end
    local obj = SHTEntry.soundList:Find(soundName);
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