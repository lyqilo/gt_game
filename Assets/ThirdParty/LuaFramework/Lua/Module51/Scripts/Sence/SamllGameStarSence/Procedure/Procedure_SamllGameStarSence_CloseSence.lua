--[[    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2019-08-20 20:07:57
]]
Procedure_SamllGameStarSence_CloseSence = {}
local self = Procedure_SamllGameStarSence_CloseSence

self.ProcedureName = "Procedure_SamllGameStarSence_CloseSence"
self.NextProcedureName = "Procedure_SamllGameStarSence_OpenSence"

function Procedure_SamllGameStarSence_CloseSence:new(args)
    local o = args or {}
    setmetatable(o, { __index = self })
    return self
end

function Procedure_SamllGameStarSence_CloseSence:OnAwake()
end

function Procedure_SamllGameStarSence_CloseSence:OnDestroy()
end

function Procedure_SamllGameStarSence_CloseSence:OnRuning()
    local sence = SenceMgr.FindSence(SamllGameStarSence.SenceName);
    sence.SenceHost.gameObject:SetActive(false);
    local mgr = SenceMgr.FindSence(SamllGameSence.SenceName).SenceHost.transform:Find("SamllGame_RollMgr");
    error(mgr.name)
    for i = 1, mgr.childCount do
        mgr:GetChild(i - 1):GetComponent("Animator"):SetTrigger("hide");
    end
end