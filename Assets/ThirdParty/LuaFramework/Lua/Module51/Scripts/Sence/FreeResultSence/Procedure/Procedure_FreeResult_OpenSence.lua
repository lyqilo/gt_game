--[[    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2019-08-20 19:50:12
]]
Procedure_FreeResult_OpenSence = {}
local self = Procedure_FreeResult_OpenSence
self.ProcedureName = "Procedure_FreeResult_OpenSence"
self.NextProcedureName = "Procedure_FreeResult_CloseSence"

function Procedure_FreeResult_OpenSence:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_FreeResult_OpenSence:OnAwake()
end

function Procedure_FreeResult_OpenSence:OnDestroy()
end
function Procedure_FreeResult_OpenSence:OnRuning()
    MainGameSence.PlaySound(MainGameSence.AudioEnum.MaliPayout);
    local sence = SenceMgr.FindSence(FreeResultSence.SenceName);
    sence.SenceHost.gameObject:SetActive(true);
    sence.SenceHost.transform:Find("Free"):GetComponent('Text').text = LogicDataSpace.FreeTotalCount .. "";
    sence.SenceHost.transform:Find("Win"):GetComponent('Text').text = LogicDataSpace.lastFreeWinGold .. "";
    local hide = function()
        coroutine.wait(20);
        if sence ~= nil and sence.SenceHost.gameObject.activeSelf then
            sence.ProMgr:RunProcedure(Procedure_FreeResult_CloseSence.ProcedureName);
        end
    end
    coroutine.start(hide);
end