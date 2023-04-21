--[[    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2019-08-20 20:12:09
]]
Procedure_MainGameSence_CloseSence = {}
local self = Procedure_MainGameSence_CloseSence

self.ProcedureName = "Procedure_SamllGameResult_CloseSence"
self.NextProcedureName = "Procedure_SamllGameResult_OpenSence"

function Procedure_MainGameSence_CloseSence:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_MainGameSence_CloseSence:OnAwake()
end

function Procedure_MainGameSence_CloseSence:OnDestroy()
end

function Procedure_MainGameSence_CloseSence:OnRuning()
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RsqGameStar.ProcedureName);
end