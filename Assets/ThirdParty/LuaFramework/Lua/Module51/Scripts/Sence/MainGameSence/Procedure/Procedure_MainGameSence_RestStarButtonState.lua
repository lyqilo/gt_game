Procedure_MainGameSence_RestStarButtonState = {}
local self = Procedure_MainGameSence_RestStarButtonState

self.ProcedureName = "Procedure_MainGameSence_RestStarButtonState"
self.NextProcedureName = ""

function Procedure_MainGameSence_RestStarButtonState:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_MainGameSence_RestStarButtonState:OnAwake()
    --self.OnRuning()
end

function Procedure_MainGameSence_RestStarButtonState:OnDestroy()
end
function Procedure_MainGameSence_RestStarButtonState:SetButtonState(isroll, isselect)
    local sence = SenceMgr.FindSence(MainGameSence.SenceName)
    if isroll then
        if isselect then
            sence.SenceHost.transform:Find("DownInfo/StarBtn"):GetComponent("Image").color = Color.black;
            sence.SenceHost.transform:Find("DownInfo/StarBtn"):GetComponent("Button").enabled = false;
        end
        sence.SenceHost.transform:Find("DownInfo/PutBetInfo/rec"):GetComponent("Image").color = Color.black;
        sence.SenceHost.transform:Find("DownInfo/PutBetInfo/add"):GetComponent("Image").color = Color.black;
        sence.SenceHost.transform:Find("DownInfo/MaxPushBet"):GetComponent("Image").color = Color.black;

        sence.SenceHost.transform:Find("DownInfo/PutBetInfo/rec"):GetComponent("Button").enabled = false;
        sence.SenceHost.transform:Find("DownInfo/PutBetInfo/add"):GetComponent("Button").enabled = false;
        sence.SenceHost.transform:Find("DownInfo/MaxPushBet"):GetComponent("Button").enabled = false;
    else
        sence.SenceHost.transform:Find("DownInfo/StarBtn"):GetComponent("Image").color = Color.white;
        sence.SenceHost.transform:Find("DownInfo/PutBetInfo/rec"):GetComponent("Image").color = Color.white;
        sence.SenceHost.transform:Find("DownInfo/PutBetInfo/add"):GetComponent("Image").color = Color.white;
        sence.SenceHost.transform:Find("DownInfo/MaxPushBet"):GetComponent("Image").color = Color.white;

        sence.SenceHost.transform:Find("DownInfo/StarBtn"):GetComponent("Button").enabled = true;
        sence.SenceHost.transform:Find("DownInfo/PutBetInfo/rec"):GetComponent("Button").enabled = true;
        sence.SenceHost.transform:Find("DownInfo/PutBetInfo/add"):GetComponent("Button").enabled = true;
        sence.SenceHost.transform:Find("DownInfo/MaxPushBet"):GetComponent("Button").enabled = true;
        SenceMgr.FindSence(BetPaworSence.SenceName).ProMgr:RunProcedure(Procedure_BetPaworSence_OpenSence.ProcedureName)
    end
end
function Procedure_MainGameSence_RestStarButtonState:OnRuning()
    local sence = SenceMgr.FindSence(MainGameSence.SenceName)
    if (LogicDataSpace.isRoll == true) then
        if (LogicDataSpace.FreeGameCount > 0) then
            self:SetButtonState(true, true);
            sence.SenceHost.transform:Find("DownInfo/StarBtn/StarImage"):GetComponent("Image").sprite = ResoureceMgr.FindSpriteRes("cjsgj_62")
            sence.SenceHost.transform:Find("DownInfo/StarBtn/AutoNum"):GetComponent("Text").text = "Free Times" .. LogicDataSpace.FreeGameCount;
            return
        end
        if (LogicDataSpace.SeleteAutoNumber == 0) then
            -- sence.SenceHost.transform:Find("DownInfo/StarBtn/StarImage"):GetComponent("Image").color = Color.black;
            -- sence.SenceHost.transform:Find("DownInfo/StarBtn/StarImage"):GetComponent("Image").sprite = ResoureceMgr.FindSpriteRes("cjsgj_35")
            self:SetButtonState(true, true);
            sence.SenceHost.transform:Find("DownInfo/StarBtn/StarImage"):GetComponent("Image").sprite = ResoureceMgr.FindSpriteRes("cjsgj_33")
            sence.SenceHost.transform:Find("DownInfo/StarBtn/AutoNum"):GetComponent("Text").text = "";
            return
        end
        -- sence.SenceHost.transform:Find("DownInfo/StarBtn/StarImage"):GetComponent("Image").sprite = ResoureceMgr.FindSpriteRes("cjsgj_35")
        -- sence.SenceHost.transform:Find("DownInfo/StarBtn/StarImage"):GetComponent("Image").color = Color.black;
        sence.SenceHost.transform:Find("DownInfo/StarBtn/StarImage"):GetComponent("Image").sprite = ResoureceMgr.FindSpriteRes("cjsgj_34")
        self:SetButtonState(true, false);
        if (LogicDataSpace.SeleteAutoNumber > 0) then
            sence.SenceHost.transform:Find("DownInfo/StarBtn/AutoNum"):GetComponent("Text").text = "auto times" .. LogicDataSpace.SeleteAutoNumber ;
        end
        if (LogicDataSpace.SeleteAutoNumber < 0) then            
            sence.SenceHost.transform:Find("DownInfo/StarBtn/AutoNum"):GetComponent("Text").text = "∞";
        end
        return
    end
    if (LogicDataSpace.FreeGameCount > 0) then
        self:SetButtonState(true, true);
        sence.SenceHost.transform:Find("DownInfo/StarBtn/StarImage"):GetComponent("Image").sprite = ResoureceMgr.FindSpriteRes("cjsgj_62")            
        sence.SenceHost.transform:Find("DownInfo/StarBtn/AutoNum"):GetComponent("Text").text = "Free Times" .. LogicDataSpace.FreeGameCount ;
        return
    end
    if (LogicDataSpace.SeleteAutoNumber == 0) then
        if LogicDataSpace.isRoll == true then
            self:SetButtonState(true, true);
        else
            self:SetButtonState(false, true);
        end
        sence.SenceHost.transform:Find("DownInfo/StarBtn/StarImage"):GetComponent("Image").sprite = ResoureceMgr.FindSpriteRes("cjsgj_33")
        sence.SenceHost.transform:Find("DownInfo/StarBtn/AutoNum"):GetComponent("Text").text = "";
        return
    end
    sence.SenceHost.transform:Find("DownInfo/StarBtn/StarImage"):GetComponent("Image").sprite = ResoureceMgr.FindSpriteRes("cjsgj_34")
    self:SetButtonState(true, false);
    if (LogicDataSpace.SeleteAutoNumber > 0) then
        sence.SenceHost.transform:Find("DownInfo/StarBtn/AutoNum"):GetComponent("Text").text = "auto times" .. LogicDataSpace.SeleteAutoNumber ;
    end
    if (LogicDataSpace.SeleteAutoNumber < 0) then
        sence.SenceHost.transform:Find("DownInfo/StarBtn/AutoNum"):GetComponent("Text").text = "∞";
    end
end