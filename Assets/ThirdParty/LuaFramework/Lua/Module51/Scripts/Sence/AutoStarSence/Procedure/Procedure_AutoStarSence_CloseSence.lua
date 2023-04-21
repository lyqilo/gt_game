--[[    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2019-08-20 20:05:18
]]
Procedure_AutoStarSence_CloseSence = {}
local self = Procedure_AutoStarSence_CloseSence

self.ProcedureName = "Procedure_AutoStarSence_CloseSence"
self.NextProcedureName = "Procedure_AutoStarSence_OpenSence"

function Procedure_AutoStarSence_CloseSence:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_AutoStarSence_CloseSence:OnAwake()
end

function Procedure_AutoStarSence_CloseSence:OnDestroy()
end

function Procedure_AutoStarSence_CloseSence:OnRuning()
    local sence = SenceMgr.FindSence(AutoStar.SenceName).SenceHost.gameObject:SetActive(false);
    SlotGameEntry.isOpenAutoSelete = false;
    if (LogicDataSpace.SeleteAutoNumber == 0) then --没有选择次数
        return;
    end
    if (#LogicDataSpace.ChipsLable <= 0) then
        return
    end
    if ((LogicDataSpace.UserGold - (LogicDataSpace.ChipsLable[LogicDataSpace.CurrSeleteChipsIndex] * 9)) > 0) then
        SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestStarButtonState.ProcedureName);
    end
    -- SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestStarButtonState.ProcedureName);
    error("自动开始")
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RsqGameStar.ProcedureName);
end
