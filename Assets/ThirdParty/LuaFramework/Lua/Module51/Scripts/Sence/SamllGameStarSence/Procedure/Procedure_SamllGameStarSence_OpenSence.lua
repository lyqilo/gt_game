Procedure_SamllGameStarSence_OpenSence = {}
local self = Procedure_SamllGameStarSence_OpenSence

self.ProcedureName = "Procedure_SamllGameStarSence_OpenSence"
self.NextProcedureName = "Procedure_SamllGameStarSence_CloseSence"

function Procedure_SamllGameStarSence_OpenSence:new(args)
    local o = args or {}
    setmetatable(o, { __index = self })
    return self
end

function Procedure_SamllGameStarSence_OpenSence:OnAwake()
end

function Procedure_SamllGameStarSence_OpenSence:OnDestroy()
end

function Procedure_SamllGameStarSence_OpenSence:OnRuning()
    log("开启小游戏开始界面")
    local sence = SenceMgr.FindSence(SamllGameStarSence.SenceName);
    sence.SenceHost.gameObject:SetActive(true);
    local hide = function()
        coroutine.wait(20);
        if sence ~= nil and sence.SenceHost.gameObject.activeSelf then
            local starsence = SenceMgr.FindSence(SamllGameSence.SenceName);
            if starsence ~= nil then
                starsence.ProMgr:RunProcedure(Procedure_SamllGameSence_StarGame.ProcedureName);
                sence.ProMgr:RunProcedure(Procedure_SamllGameStarSence_CloseSence.ProcedureName);
            end
        end
    end
    SenceMgr.FindSence(SettingSence.SenceName).ProMgr:RunProcedure(Procedure_SettingSence_CloseSence.ProcedureName);
    SenceMgr.FindSence(RuleSence.SenceName).ProMgr:RunProcedure(Procedure_RuleSence_CloseSence.ProcedureName);
    coroutine.start(hide);
end