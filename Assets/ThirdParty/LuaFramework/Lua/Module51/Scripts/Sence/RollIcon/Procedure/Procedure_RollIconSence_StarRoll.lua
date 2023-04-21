Procedure_RollIconSence_StarRoll = {}
local self = Procedure_RollIconSence_StarRoll

self.ProcedureName = "Procedure_RollIconSence_StarRoll"
self.NextProcedureName = "Procedure_RollIconSence_StopRoll"

function Procedure_RollIconSence_StarRoll:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_RollIconSence_StarRoll:OnAwake()
end

function Procedure_RollIconSence_StarRoll:OnDestroy()
end

function Procedure_RollIconSence_StarRoll:OnRuning()
    local time = 0
    LogicDataSpace.isSmallGameStart = false;
    for i = 1, #LogicDataSpace.RollElementList do
        local f = function()
            LogicDataSpace.RollElementList[i]:Start();
        end
        -- SlotGameEntry.AddCallBack(time, f);
        coroutine.start(function()
            coroutine.wait(i * 0.05);
            f();
        end);
        time = time + 0.05
    end
    local stop = function()
        SenceMgr.FindSence(RollIconSence.SenceName).ProMgr:RunProcedure(Procedure_RollIconSence_StopRoll.ProcedureName);
    end
    local PlayPlayingSound = function()
        MainGameSence.PlaySound(MainGameSence.AudioEnum.WheelPlaying);
    end
    SlotGameEntry.AddCallBack(1, stop);
    SlotGameEntry.AddCallBack(0.5, PlayPlayingSound);
end