--[[    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2019-08-20 19:57:50
]]
Procedure_FreeResult_CloseSence = {}
local self = Procedure_FreeResult_CloseSence

self.ProcedureName = "Procedure_FreeResult_CloseSence"
self.NextProcedureName = "Procedure_FreeResult_OpenSence"

function Procedure_FreeResult_CloseSence:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_FreeResult_CloseSence:OnAwake()
end

function Procedure_FreeResult_CloseSence:OnDestroy()
end
function Procedure_FreeResult_CloseSence:OnRuning()
    LogicDataSpace.lastFreeCount = 0;
    LogicDataSpace.lastFreeWinGold = 0;
    SenceMgr.FindSence(FreeResultSence.SenceName).SenceHost.gameObject:SetActive(false);
    error("免费开始")
    Procedure_MainGameSence_RsqGameStar.isEnterFree = false;
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RsqGameStar.ProcedureName);
    local pao = SlotGameEntry.transform:Find("Canvas/FreePaoMa").gameObject;
    pao:SetActive(false);
end