require("module51/Scripts/Sence/MainGameSence/Procedure/Procedure_MainGameSence_Default")
require("module51/Scripts/Sence/MainGameSence/Procedure/Procedure_MainGameSence_OpenSence")
require("module51/Scripts/Sence/MainGameSence/Procedure/Procedure_MainGameSence_CloseSence")
require("module51/Scripts/Sence/MainGameSence/Procedure/Procedure_MainGameSence_RestWinGold")
require("module51/Scripts/Sence/MainGameSence/Procedure/Procedure_MainGameSence_RestUserInfo")
require("module51/Scripts/Sence/MainGameSence/Procedure/Procedure_MainGameSence_RestJackpot")
require("module51/Scripts/Sence/MainGameSence/Procedure/Procedure_MainGameSence_RestStarButtonState")
require("module51/Scripts/Sence/MainGameSence/Procedure/Procedure_MainGameSence_RestSeleteChips")
require("module51/Scripts/Sence/MainGameSence/Procedure/Procedure_MainGameSence_RsqGameStar")
require("module51/Scripts/Core/AudioItem")
MainGameSence = {}
local self = MainGameSence
self.SenceName = "MainGameSence";
self.ProMgr = nil;
self.SenceHost = nil
self.AudioContr = nil;
self.PlayIndex = 0;
self.AudioEnum = {
    BigWin = "snd_bigwin_coin";
    Bomb = "snd_bomb";
    BtnClick = "snd_btnclick";
    Endmali = "snd_end_mali";
    FrameAppear = "snd_frame_appear";
    MaliBingo = "snd_mali_bingo";
    MaliPayout = "snd_mali_payout";
    MaliWheelPitch = "snd_maliwheel_pitch";
    Reward = "snd_reward";
    WheelPlaying = "snd_wheel_playing";
    WheelStart = "snd_wheel_start";
    WheelStop = "snd_wheel_stop";
}
function MainGameSence.new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function MainGameSence.OnAwake()
    self.SenceHost = SlotGameEntry.transform:Find("Canvas/GameMainSence").gameObject;
    self.ProMgr = ProcedureMgr:new();
    self.ProMgr.proMap = {};
    self.ProMgr:LoadProcedure(Procedure_MainGameSence_Default:new())
    self.ProMgr:LoadProcedure(Procedure_MainGameSence_OpenSence:new())
    self.ProMgr:LoadProcedure(Procedure_MainGameSence_CloseSence:new())
    self.ProMgr:LoadProcedure(Procedure_MainGameSence_RestUserInfo:new())
    self.ProMgr:LoadProcedure(Procedure_MainGameSence_RestJackpot:new())
    self.ProMgr:LoadProcedure(Procedure_MainGameSence_RestStarButtonState:new())
    self.ProMgr:LoadProcedure(Procedure_MainGameSence_RestWinGold:new())
    self.ProMgr:LoadProcedure(Procedure_MainGameSence_RestSeleteChips:new())
    self.ProMgr:LoadProcedure(Procedure_MainGameSence_RsqGameStar:new())
    self.ProMgr:RunProcedure(Procedure_MainGameSence_Default.ProcedureName);
    self.AudioContr = SlotGameEntry.transform:Find("Canvas/AudioController");
    if self.AudioContr == nil then
        self.AudioContr = GameObject.New("AudioController").transform;
        self.AudioContr:SetParent(SlotGameEntry.transform:Find("Canvas"));
        self.AudioContr.localPosition = Vector3(0, 0, 0);
        self.AudioContr.localScale = Vector3(1, 1, 1);
    end
end

function MainGameSence.OnDisable()
    self.SenceHost:SetActive(false)
end

function MainGameSence.OnEnable()
    self.SenceHost:SetActive(true)
end
function MainGameSence.OnDestroy()
    destroy(self.SenceHost)
end
function MainGameSence.PlayBgMusic()
    local rc = PlayerPrefs.GetString("IsPlayAudio");
    if rc == nil then end
    if rc == tostring(false) then
        LogicDataSpace.isCanPlayMusic = false
    end
    if rc == tostring(true) then
        LogicDataSpace.isCanPlayMusic = true;
    end
    local b = LogicDataSpace.isCanPlayMusic;
    local clipName = "snd_bg";
    local clip = ResoureceMgr.FindAudio(clipName);
    if clip == nil or clip.clip == nil then return end
    if not PlayerPrefs.HasKey("MusicValue") then
        PlayerPrefs.SetString("MusicValue", "1");
    end
    if not PlayerPrefs.HasKey("SoundValue") then
        PlayerPrefs.SetString("SoundValue", "1");
    end
    local musicvlaue = PlayerPrefs.GetString("MusicValue");
    local soundvlaue = PlayerPrefs.GetString("SoundValue");
    MusicManager:SetValue(tonumber(soundvlaue), tonumber(musicvlaue));
    logError("---------------=================================007")
    MusicManager:PlayBacksoundX(clip.clip, b);
end
function MainGameSence.PlaySound(soundname)
    if not PlayerPrefs.HasKey("MusicValue") then
        PlayerPrefs.SetString("MusicValue", "1");
        
    end
    if not PlayerPrefs.HasKey("SoundValue") then
        PlayerPrefs.SetString("SoundValue", "1");
    end
    local audiolength = 0;
    local b = LogicDataSpace.isCanPlaySound;
    if not b then return audiolength end
    local isfind = false;
    local child = nil;
    for i = 1, self.AudioContr.childCount do
        if self.AudioContr:GetChild(i - 1).name == soundname and not self.AudioContr:GetChild(i - 1).gameObject.activeSelf then
            isfind = true;
            child = self.AudioContr:GetChild(i - 1);
            break;
        end
    end
    local audioitem = AudioItem:new();
    if isfind then
        audiolength = child:GetComponent("AudioSource").clip.length;
        audioitem:Init(child.gameObject, audiolength);
    else
        local audio = ResoureceMgr.FindAudio(soundname);
        if audio == nil or audio.clip == nil then return end
        local newaudio = newObject(audio.gameObject);
        local soundvlaue = PlayerPrefs.GetString("SoundValue");
        local musicvlaue = PlayerPrefs.GetString("MusicValue");

        --MusicManager:SetValue(tonumber(soundvlaue), tonumber(musicvlaue));
        newaudio:GetComponent("AudioSource").volume = tonumber(soundvlaue);
        newaudio.name = soundname;
        newaudio.transform:SetParent(self.AudioContr);
        newaudio.transform.localPosition = Vector3(0, 0, 0);
        newaudio.transform.localScale = Vector3(1, 1, 1);
        audiolength = newaudio:GetComponent("AudioSource").clip.length;
        audioitem:Init(newaudio, audiolength);
    end
    return audiolength;
end