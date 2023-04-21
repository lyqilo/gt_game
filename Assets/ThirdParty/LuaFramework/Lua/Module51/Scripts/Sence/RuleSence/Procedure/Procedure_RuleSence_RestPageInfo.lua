
Procedure_RuleSence_RestPageInfo = {}
local self = Procedure_RuleSence_RestPageInfo

self.ProcedureName = "Procedure_RuleSence_RestPageInfo"
self.NextProcedureName = ""

function Procedure_RuleSence_RestPageInfo:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_RuleSence_RestPageInfo:OnAwake()
end

function Procedure_RuleSence_RestPageInfo:OnDestroy()
end

function Procedure_RuleSence_RestPageInfo:OnRuning()
    local sence = SenceMgr.FindSence(RuleSence.SenceName);
    local page = LogicDataSpace.PageNumber + 1;
    sence.SenceHost.transform:Find("Page"):GetComponent("Image").sprite = ResoureceMgr.FindSpriteRes("sgjgz_"..page);
end

