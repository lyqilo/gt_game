
Procedure_AutoStarSence_Default = {}
local self = Procedure_AutoStarSence_Default

self.ProcedureName = "Procedure_AutoStarSence_Default"
self.NextProcedureName = "Procedure_AutoStarSence_OpenSence"

function Procedure_AutoStarSence_Default:new(args)
    local o = args or {}
    setmetatable(o, {__index = self})
    return o
end

function Procedure_AutoStarSence_Default:OnAwake()
    local sence = SenceMgr.FindSence(AutoStar.SenceName);
    local maxAuto = function()
        LogicDataSpace.SeleteAutoNumber = -1;
        sence.ProMgr:RunProcedure(Procedure_AutoStarSence_CloseSence.ProcedureName);
    end
    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("auto_back/max").gameObject,maxAuto);

    local auto20 = function()
        LogicDataSpace.SeleteAutoNumber = 20;
        sence.ProMgr:RunProcedure(Procedure_AutoStarSence_CloseSence.ProcedureName);
    end
    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("auto_back/auto_20").gameObject,auto20);

    local auto50 = function()
        LogicDataSpace.SeleteAutoNumber = 50;
        sence.ProMgr:RunProcedure(Procedure_AutoStarSence_CloseSence.ProcedureName);
    end
    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("auto_back/auto_50").gameObject,auto50);

    local auto100 = function()
        LogicDataSpace.SeleteAutoNumber = 100;
        sence.ProMgr:RunProcedure(Procedure_AutoStarSence_CloseSence.ProcedureName);
    end
    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("auto_back/auto_100").gameObject,auto100);

    local close = function()
        sence.ProMgr:RunProcedure(Procedure_AutoStarSence_CloseSence.ProcedureName);
    end
    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.gameObject,close);

    sence.SenceHost.gameObject:SetActive(false);
end



function Procedure_AutoStarSence_Default:OnDestroy()
end

function Procedure_AutoStarSence_Default:OnRuning()
   
end

