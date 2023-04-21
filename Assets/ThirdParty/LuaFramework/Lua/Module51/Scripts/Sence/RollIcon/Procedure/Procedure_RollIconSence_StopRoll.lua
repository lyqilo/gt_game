--[[    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2019-08-20 20:04:27
]]
Procedure_RollIconSence_StopRoll = {}
local self = Procedure_RollIconSence_StopRoll

self.ProcedureName = "Procedure_RollIconSence_StopRoll"
self.NextProcedureName = ""

function Procedure_RollIconSence_StopRoll:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_RollIconSence_StopRoll:OnAwake()
end

function Procedure_RollIconSence_StopRoll:OnDestroy()
end

function Procedure_RollIconSence_StopRoll:OnRuning()
    coroutine.stop(self.StopRoll);
    coroutine.start(self.StopRoll);
    -- SlotGameEntry.AddCallBack(time + 1, showLine);
end
function Procedure_RollIconSence_StopRoll.StopRoll()
    for i = 1, #LogicDataSpace.RollElementList do
        local stop = function()
            if LogicDataSpace.RollElementList[i] ~= nil then
                LogicDataSpace.RollElementList[i].OnStoped = function()
                    local f = function()
                        coroutine.wait(0.1);
                        MainGameSence.PlaySound(MainGameSence.AudioEnum.WheelStop);
                    end
                    coroutine.start(f);
                end
                LogicDataSpace.RollElementList[i]:Stop();
            end
        end
        -- SlotGameEntry.AddCallBack(time, stop);
        -- time = time + 0.5
        stop();
        coroutine.wait(0.3);
    end
    coroutine.wait(0.5);
    SenceMgr.FindSence(LineSence.SenceName).ProMgr:RunProcedure(Procedure_LineSence_OpenSence.ProcedureName);
end