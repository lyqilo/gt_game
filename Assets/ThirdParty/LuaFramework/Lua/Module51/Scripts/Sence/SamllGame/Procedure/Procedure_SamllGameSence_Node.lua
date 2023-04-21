Procedure_SamllGameSence_Node = {}
local self = Procedure_SamllGameSence_Node

self.ProcedureName = "Procedure_SamllGameSence_Node"
self.NextProcedureName = "Procedure_SamllGameSence_StarGame"

function Procedure_SamllGameSence_Node:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_SamllGameSence_Node:OnAwake()
end

function Procedure_SamllGameSence_Node:OnDestroy()
end

function Procedure_SamllGameSence_Node:OnRuning()
    if(LogicDataSpace.MiniGameCount <= 0) then
        --TODO 没有小游戏次数，显示结算界面
        log("没有小游戏次数，显示结算界面");
        return;
    end
    --TODO 还有小游戏次数，继续开始
    log("还有小游戏次数，继续开始")
    local sence = SenceMgr.FindSence(SamllGameSence.SenceName);
end
