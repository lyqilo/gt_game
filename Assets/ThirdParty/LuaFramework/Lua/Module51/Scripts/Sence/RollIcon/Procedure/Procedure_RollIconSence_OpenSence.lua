--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2019-08-20 20:04:27
]]
Procedure_RollIconSence_OpenSence = {}
local self = Procedure_RollIconSence_OpenSence

self.ProcedureName = "Procedure_RollIconSence_OpenSence"
self.NextProcedureName = "Procedure_RollIconSence_CloseSence"

function Procedure_RollIconSence_OpenSence:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_RollIconSence_OpenSence:OnAwake()
end

function Procedure_RollIconSence_OpenSence:OnDestroy()
end

function Procedure_RollIconSence_OpenSence:OnRuning()
    local sence = SenceMgr.FindSence(AutoStar.SenceName);
    sence.SenceHost.gameObject:SetActive(true);
end

