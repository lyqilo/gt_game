--[[    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2019-08-20 20:05:18
]]
Procedure_BetPaworSence_CloseSence = {}
local self = Procedure_BetPaworSence_CloseSence

self.ProcedureName = "Procedure_BetPaworSence_CloseSence"
self.NextProcedureName = "Procedure_BetPaworSence_OpenSence"

function Procedure_BetPaworSence_CloseSence:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_BetPaworSence_CloseSence:OnAwake()
end

function Procedure_BetPaworSence_CloseSence:OnDestroy()
end

function Procedure_BetPaworSence_CloseSence:OnRuning()
    local sence = SenceMgr.FindSence(BetPaworSence.SenceName);
    if (LogicDataSpace.isShowBetPowar ~= false) then
        sence.SenceHost.transform:Find("BetPowarback"):DOLocalMoveY(-90, 0.5, false);
    end
    LogicDataSpace.isShowBetPowar = false;
    sence.SenceHost.transform:Find("BetPowarback/BetPowarinfo"):GetComponent("Animator"):SetTrigger("bet1");
    -- sence.SenceHost.gameObject:SetActive(false);
end