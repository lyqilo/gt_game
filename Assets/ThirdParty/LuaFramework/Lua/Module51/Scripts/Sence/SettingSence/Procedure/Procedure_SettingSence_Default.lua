--[[    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2019-08-20 20:03:43
]]
Procedure_SettingSence_Default = {}
local self = Procedure_SettingSence_Default

self.ProcedureName = "Procedure_SettingSence_Default"
self.NextProcedureName = "Procedure_SettingSence_OpenSence"

function Procedure_SettingSence_Default:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_SettingSence_Default:OnAwake()
    local sence = SenceMgr.FindSence(SettingSence.SenceName);
    local rc = PlayerPrefs.GetString("IsPlayAudio");
    if rc == nil then end
    if rc == tostring(false) then
        LogicDataSpace.isCanPlayMusic = false
    end
    if rc == tostring(true) then
        LogicDataSpace.isCanPlayMusic = true;
    end
    if not PlayerPrefs.HasKey("MusicValue") then
        PlayerPrefs.SetString("MusicValue", "1");
    end
    if not PlayerPrefs.HasKey("SoundValue") then
        PlayerPrefs.SetString("SoundValue", "1");
    end

    
     logError("------------------MusicValue: "..PlayerPrefs.GetString("MusicValue"))
     logError("------------------SoundValue: "..PlayerPrefs.GetString("SoundValue"))
    if AllSetGameInfo._5IsPlayAudio == true then
       
        sence.SenceHost.transform:Find("Body/Music"):GetComponent('Slider').value = tonumber(PlayerPrefs.GetString("MusicValue"));
    else
        sence.SenceHost.transform:Find("Body/Music"):GetComponent('Slider').value = 0;
    end
    local cansound = PlayerPrefs.GetString("isCanPlaySound");
    if not PlayerPrefs.HasKey("isCanPlaySound") or AllSetGameInfo._6IsPlayEffect then
        LogicDataSpace.isCanPlaySound = true;
        sence.SenceHost.transform:Find("Body/Sound"):GetComponent('Slider').value = tonumber(PlayerPrefs.GetString("SoundValue"));
    else
        LogicDataSpace.isCanPlaySound = false;
        sence.SenceHost.transform:Find("Body/Sound"):GetComponent('Slider').value = 0;
    end


    -- local changeMusic = function()
    --     MainGameSence.PlaySound(MainGameSence.AudioEnum.BtnClick);
    --     if (LogicDataSpace.isCanPlayMusic == true) then
    --         LogicDataSpace.isCanPlayMusic = false;
    --         sence.SenceHost.transform:Find("Music"):GetComponent('Image').sprite = ResoureceMgr.FindSpriteRes("cjsgj_21");
    --         SetInfoSystem.GameMute()
    --     else
    --         LogicDataSpace.isCanPlayMusic = true;
    --         sence.SenceHost.transform:Find("Music"):GetComponent('Image').sprite = ResoureceMgr.FindSpriteRes("cjsgj_18");
    --         SetInfoSystem.ResetMute()
    --     end
    --     sence.ProMgr:RunProcedure(Procedure_SettingSence_CloseSence.ProcedureName);
    -- end
    -- SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("Music").gameObject, changeMusic);
    -- local changeSound = function()
    --     MainGameSence.PlaySound(MainGameSence.AudioEnum.BtnClick);
    --     if (LogicDataSpace.isCanPlaySound == true) then
    --         LogicDataSpace.isCanPlaySound = false;
    --         Util.SetString("isCanPlaySound", "false");
    --         sence.SenceHost.transform:Find("Sound"):GetComponent('Image').sprite = ResoureceMgr.FindSpriteRes("cjsgj_20");
    --     else
    --         LogicDataSpace.isCanPlaySound = true;
    --         Util.SetString("isCanPlaySound", "true");
    --         sence.SenceHost.transform:Find("Sound"):GetComponent('Image').sprite = ResoureceMgr.FindSpriteRes("cjsgj_19");
    --     end
    --     sence.ProMgr:RunProcedure(Procedure_SettingSence_CloseSence.ProcedureName);
    -- end
    -- SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("Sound").gameObject, changeSound);
    local close = function()
        MainGameSence.PlaySound(MainGameSence.AudioEnum.BtnClick);
        sence.ProMgr:RunProcedure(Procedure_SettingSence_CloseSence.ProcedureName)
    end

    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.gameObject, close);
    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("Body/Close").gameObject, close);

    SlotGameEntry.luaScripts:AddSliderEvent(sence.SenceHost.transform:Find("Body/Sound").gameObject, function(value)
        PlayerPrefs.SetString("SoundValue", tostring(value));
        if value == 0 then
            LogicDataSpace.isCanPlaySound = false;
            PlayerPrefs.SetString("isCanPlaySound", "false");
        else
            LogicDataSpace.isCanPlaySound = true;
            PlayerPrefs.SetString("isCanPlaySound", "true");
        end
        if MainGameSence.AudioContr == nil then return end
        for i = 1, MainGameSence.AudioContr.childCount do
            MainGameSence.AudioContr:GetChild(i - 1):GetComponent("AudioSource").volume = value;
        end
    end);
    SlotGameEntry.luaScripts:AddSliderEvent(sence.SenceHost.transform:Find("Body/Music").gameObject, function(value)
        logError("----------------music value: "..value)
        PlayerPrefs.SetString("MusicValue", tostring(value));
        MusicManager:SetValue(1, value);
        if value == 0 then
            LogicDataSpace.isCanPlayMusic = false;
            PlayerPrefs.SetString("isCanPlayMusic", "false");
            SetInfoSystem.GameMute()
            self.palyBgmusic = false
        else
           
            logError("kkk---------------------------")
            LogicDataSpace.isCanPlayMusic = true;
            PlayerPrefs.SetString("isCanPlayMusic", "true");
            SetInfoSystem.ResetMute()
        end
    end);
    sence.SenceHost.gameObject:SetActive(false);
end



function Procedure_SettingSence_Default:OnDestroy()
end

function Procedure_SettingSence_Default:OnRuning()
end