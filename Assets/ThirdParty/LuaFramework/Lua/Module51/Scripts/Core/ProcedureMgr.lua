ProcedureMgr = {};
local self = ProcedureMgr
self.lastProcedure = nil;
self.currProcedure = nil;
self.proMap = {};

function ProcedureMgr:new(args)
    local o = args or {};
    setmetatable(o, { __index = self });
    return o;
end

function ProcedureMgr:LoadProcedure(procedure)
    procedure:OnAwake();
    table.insert(self.proMap, procedure);
end

function ProcedureMgr:UnLoadProcedure(proName)
    local length = #self.proMap;
    for i = 1, length do
        if (self.proMap[i].ProcedureName == proName) then
            self.proMap[i]:OnDestroy();
            table.remove(self.proMap, i);
        end
    end
end

function ProcedureMgr:RunProcedure(procedure)
    local p = self:FindProcedure(procedure)
    if (p == nil) then
        logYellow("not find procedure:" .. procedure);
        return;
    end
    p:OnRuning();
    self.lastProcedure = self.currProcedure;
    self.currProcedure = p;

    -- log("Runing Procedure -> "..p.ProcedureName.."  procedure pool length :"..#self.proMap)
end

function ProcedureMgr:HasCurrProcedure(procedureName)
    return self.currProcedure.ProcedureName == procedureName;
end

---查找指定名字的流程
function ProcedureMgr:FindProcedure(proName)
    local length = #self.proMap;
    for i = 1, length do
        if (self.proMap[i].ProcedureName == proName) then
            return self.proMap[i];
        end
    end
    return nil;
end