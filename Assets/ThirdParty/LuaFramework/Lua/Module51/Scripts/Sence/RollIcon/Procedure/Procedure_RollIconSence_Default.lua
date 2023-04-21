
Procedure_RollIconSence_Default = {}
local self = Procedure_RollIconSence_Default

self.ProcedureName = "Procedure_RollIconSence_Default"
self.NextProcedureName = "Procedure_RollIconSence_OpenSence"

function Procedure_RollIconSence_Default:new(args)
    local o = args or {}
    setmetatable(o, {__index = self})
    return o
end

function Procedure_RollIconSence_Default:OnAwake()
    local sence = SenceMgr.FindSence(RollIconSence.SenceName);
    
    for i = 1, 5 do
        local item = {};
        for j = 1, 4 do
            local unit = Element:new();
            unit:OnInit(sence.SenceHost.transform:Find("RolCol_"..i):Find("RolCol_"..i.."_"..j))
            unit.m_col = i;
            unit.m_pos = j;
            unit.m_Conut = 5;
            item[j] = unit;
        end
        local roll = RollElement:new();
        roll.m_count = #item;
        roll:Init(item);
        LogicDataSpace.RollElementList[i] = roll;
        sence.SenceHost.transform:Find("RolCol_"..i).localPosition = Vector3.New( sence.SenceHost.transform:Find("RolCol_"..i).localPosition.x,140,0);
    end
end



function Procedure_RollIconSence_Default:OnDestroy()
end

function Procedure_RollIconSence_Default:OnRuning()

end

