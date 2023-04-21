
Procedure_LineSence_Default = {}
local self = Procedure_LineSence_Default

self.ProcedureName = "Procedure_LineSence_Default"
self.NextProcedureName = "Procedure_LineSence_OpenSence"

function Procedure_LineSence_Default:new(args)
    local o = args or {}
    setmetatable(o, {__index = self})
    return o
end

function Procedure_LineSence_Default:OnAwake()
    local sence = SenceMgr.FindSence(LineSence.SenceName);
    for i = 1, 9 do
        sence.SenceHost.transform:Find("Line_"..i).gameObject:SetActive(true);
    end
end



function Procedure_LineSence_Default:OnDestroy()
end

function Procedure_LineSence_Default:OnRuning()
    -- local sence = SenceMgr.FindSence(LineSence.SenceName);
    -- sence.ProMgr:RunProcedure(Procedure_LineSence_CloseSence.ProcedureName)
end

