--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2019-08-20 20:05:18
]]
Procedure_SettingSence_CloseSence = {}
local self = Procedure_SettingSence_CloseSence

self.ProcedureName = "Procedure_SettingSence_CloseSence"
self.NextProcedureName = "Procedure_SettingSence_OpenSence"

function Procedure_SettingSence_CloseSence:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_SettingSence_CloseSence:OnAwake()
end

function Procedure_SettingSence_CloseSence:OnDestroy()
end

function Procedure_SettingSence_CloseSence:OnRuning()
    local sence = SenceMgr.FindSence(SettingSence.SenceName);
    sence.SenceHost.gameObject:SetActive(false);
end

