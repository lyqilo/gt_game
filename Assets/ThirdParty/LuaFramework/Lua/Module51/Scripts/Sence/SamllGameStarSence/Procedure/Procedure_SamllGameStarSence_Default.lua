Procedure_SamllGameStarSence_Default = {}
local self = Procedure_SamllGameStarSence_Default

self.ProcedureName = "Procedure_SamllGameStarSence_Default"
self.NextProcedureName = "Procedure_SamllGameStarSence_OpenSence"

function Procedure_SamllGameStarSence_Default:new(args)
    local o = args or {}
    setmetatable(o, { __index = self })
    return self
end

function Procedure_SamllGameStarSence_Default:OnAwake()
    local sence = SenceMgr.FindSence(SamllGameStarSence.SenceName);
    local starSamllGame = function()
        MainGameSence.PlaySound(MainGameSence.AudioEnum.BtnClick);
        SenceMgr.FindSence(SamllGameSence.SenceName).ProMgr:RunProcedure(Procedure_SamllGameSence_StarGame.ProcedureName);
        sence.ProMgr:RunProcedure(Procedure_SamllGameStarSence_CloseSence.ProcedureName);
    end
    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("Star").gameObject, starSamllGame);
    sence.SenceHost.gameObject:SetActive(false);
end

function Procedure_SamllGameStarSence_Default:OnDestroy()
end

function Procedure_SamllGameStarSence_Default:OnRuning()
end