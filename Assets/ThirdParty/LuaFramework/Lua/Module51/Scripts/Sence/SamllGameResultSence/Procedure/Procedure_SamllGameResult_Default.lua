
Procedure_SamllGameResult_Default = {}
local self = Procedure_SamllGameResult_Default

self.ProcedureName = "Procedure_SamllGameResult_Default"
self.NextProcedureName = "Procedure_SamllGameResult_OpenSence"

function Procedure_SamllGameResult_Default:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_SamllGameResult_Default:OnAwake()
    local sence = SenceMgr.FindSence(SamllGameResultSence.SenceName);
    local close = function()
        MainGameSence.PlaySound(MainGameSence.AudioEnum.BtnClick);
        SenceMgr.FindSence(SamllGameResultSence.SenceName).ProMgr:RunProcedure(Procedure_SamllGameResult_CloseSence.ProcedureName);
    end
    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("Close").gameObject,close);
    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("ContGame").gameObject,close);
    sence.SenceHost.gameObject:SetActive(false);
end

function Procedure_SamllGameResult_Default:OnDestroy()
end

function Procedure_SamllGameResult_Default:OnRuning()
end
