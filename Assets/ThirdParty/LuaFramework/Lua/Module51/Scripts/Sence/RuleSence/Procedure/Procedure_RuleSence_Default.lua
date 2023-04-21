Procedure_RuleSence_Default = {}
local self = Procedure_RuleSence_Default

self.ProcedureName = "Procedure_RuleSence_Default"
self.NextProcedureName = "Procedure_FreeResult_OpenSence"
local pagrViewer = nil
function Procedure_RuleSence_Default:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_RuleSence_Default:OnAwake()
    local sence = SenceMgr.FindSence(RuleSence.SenceName)
    local last = function()
        MainGameSence.PlaySound(MainGameSence.AudioEnum.BtnClick);
        LogicDataSpace.PageNumber = LogicDataSpace.PageNumber - 1;
        if (LogicDataSpace.PageNumber < 0) then
            LogicDataSpace.PageNumber = 2;
        end
        sence.ProMgr:RunProcedure(Procedure_RuleSence_RestPageInfo.ProcedureName);
    end
    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("Left").gameObject, last)

    local next = function()
        MainGameSence.PlaySound(MainGameSence.AudioEnum.BtnClick);
        LogicDataSpace.PageNumber = LogicDataSpace.PageNumber + 1;
        if (LogicDataSpace.PageNumber > 2) then
            LogicDataSpace.PageNumber = 0;
        end
        sence.ProMgr:RunProcedure(Procedure_RuleSence_RestPageInfo.ProcedureName);
    end
    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("Rigth").gameObject, next)

    local close = function()
        MainGameSence.PlaySound(MainGameSence.AudioEnum.BtnClick);
        sence.ProMgr:RunProcedure(Procedure_RuleSence_CloseSence.ProcedureName);
    end
    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("Close").gameObject, close)
    sence.SenceHost.gameObject:SetActive(false);

    local page = sence.SenceHost.transform:Find("Image");
    eventTrigger = Util.AddComponent("EventTriggerListener",page.gameObject);
    eventTrigger.onBeginDrag = function (go,data)
        self.lastPos = data.position;
    end
    eventTrigger.onDrag = function (go,data)

    end
    eventTrigger.onEndDrag = function (go,data)
        local off = data.position.y - self.lastPos.y;
        if off < 0 then
            last();
        else
            next();
        end
    end
end

function Procedure_RuleSence_Default:OnDestroy()
end

function Procedure_RuleSence_Default:OnRuning()

end