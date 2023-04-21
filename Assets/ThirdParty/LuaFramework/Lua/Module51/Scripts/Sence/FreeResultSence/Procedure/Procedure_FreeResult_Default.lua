
Procedure_FreeResult_Default = {}
local self = Procedure_FreeResult_Default

self.ProcedureName = "Procedure_FreeResult_Default"
self.NextProcedureName = "Procedure_FreeResult_OpenSence"

function Procedure_FreeResult_Default:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_FreeResult_Default:OnAwake()
    local sence = SenceMgr.FindSence(FreeResultSence.SenceName);
    if (sence == nil) then
        logYellow("not find sence FreeResultSence");
        return;
    end
    local closeBtn = function()
        sence.ProMgr:RunProcedure(Procedure_FreeResult_CloseSence.ProcedureName);
    end
    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("Close").gameObject,closeBtn);
    sence.SenceHost.gameObject:SetActive(false);
end

function Procedure_FreeResult_Default:OnDestroy()
end

function Procedure_FreeResult_Default:OnRuning()
end

