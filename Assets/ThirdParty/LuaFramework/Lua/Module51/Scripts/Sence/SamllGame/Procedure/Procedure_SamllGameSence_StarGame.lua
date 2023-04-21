Procedure_SamllGameSence_StarGame = {}
local self = Procedure_SamllGameSence_StarGame

self.ProcedureName = "Procedure_SamllGameSence_StarGame"
self.NextProcedureName = "Procedure_SamllGameSence_StarRoll"

function Procedure_SamllGameSence_StarGame:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_SamllGameSence_StarGame:OnAwake()
end

function Procedure_SamllGameSence_StarGame:OnDestroy()
end

function Procedure_SamllGameSence_StarGame:OnRuning()
    local s = SenceMgr.FindSence(SamllGameSence.SenceName);
    error("小游戏次数：===========" .. LogicDataSpace.MiniGameCount)
    logErrorTable(LogicDataSpace.ChipsLable);
    error("下注金额：===========" .. LogicDataSpace.currentchip)
    if (LogicDataSpace.MiniGameCount > 0) then
        SpureSlotGameNet.RsqMiniGameStar(LogicDataSpace.currentchip);--TODO 发送小游戏开始消息
        -- SenceMgr.FindSence(SamllGameSence.SenceName).ProMgr:RunProcedure(Procedure_SamllGameSence_StarRoll.ProcedureName);
    end
end