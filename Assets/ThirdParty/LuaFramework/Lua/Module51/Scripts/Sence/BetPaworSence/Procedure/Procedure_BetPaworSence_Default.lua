
Procedure_BetPaworSence_Default = {}
local self = Procedure_BetPaworSence_Default

self.ProcedureName = "Procedure_AutoStarSence_Default"
self.NextProcedureName = "Procedure_BetPaworSence_OpenSence"

function Procedure_BetPaworSence_Default:new(args)
    local o = args or {}
    setmetatable(o, {__index = self})
    return o
end

function Procedure_BetPaworSence_Default:OnAwake()
    local sence = SenceMgr.FindSence(BetPaworSence.SenceName);
    sence.ProMgr:RunProcedure(Procedure_BetPaworSence_OpenSence.ProcedureName);
end

function Procedure_BetPaworSence_Default:OnDestroy()
end

function Procedure_BetPaworSence_Default:OnRuning()

end

