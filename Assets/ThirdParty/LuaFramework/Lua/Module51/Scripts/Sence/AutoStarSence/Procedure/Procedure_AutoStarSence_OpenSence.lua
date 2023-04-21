--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2019-08-20 20:04:27
]]
Procedure_AutoStarSence_OpenSence = {}
local self = Procedure_AutoStarSence_OpenSence

self.ProcedureName = "Procedure_AutoStarSence_OpenSence"
self.NextProcedureName = "Procedure_AutoStarSence_CloseSence"

function Procedure_AutoStarSence_OpenSence:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_AutoStarSence_OpenSence:OnAwake()
end

function Procedure_AutoStarSence_OpenSence:OnDestroy()
end

function Procedure_AutoStarSence_OpenSence:OnRuning()
    local sence = SenceMgr.FindSence(AutoStar.SenceName);
    sence.SenceHost.gameObject:SetActive(true);
end

