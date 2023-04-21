Procedure_SamllGameSence_Default = {}
local self = Procedure_SamllGameSence_Default

self.ProcedureName = "Procedure_SamllGameSence_Default"
self.NextProcedureName = "Procedure_SamllGameSence_OpenSence"

function Procedure_SamllGameSence_Default:new(args)
    local o = args or {}
    setmetatable(o, { __index = self })
    return self
end

function Procedure_SamllGameSence_Default:OnAwake()
    local sence = SenceMgr.FindSence(SamllGameSence.SenceName);
    sence.SenceHost.transform:Find("Back"):GetComponent("RectTransform").sizeDelta = Vector2.New(Screen.width*1.5, Screen.height*1.5);
    --TODO 加载外圈旋转
    local length = sence.SenceHost.transform:Find("IconGroup").transform.childCount;
    for i = 1, length do
        local obj = sence.SenceHost.transform:Find("IconGroup/Icon_Index_" .. i).gameObject;
        local slide = SlideObject:new();
        slide:OnInit(obj);
        slide:Hide();
        table.insert(LogicDataSpace.samlGameRollIcon, slide);
    end
    for i = 1, 4 do
        local item = {};
        for j = 1, 2 do
            local unit = Element:new();
            unit:OnInit(sence.SenceHost.transform:Find("SamllGame_RollMgr/SamllGame_Roll_" .. i):Find("SamllGame_Roll_" .. i .. "_" .. (j - 1)))
            unit.m_col = i;
            unit.m_pos = j;
            unit.m_Conut = 2;
            item[j] = unit;
        end
        local roll = RollElement:new();
        roll.m_count = #item;
        roll:Init(item);
        LogicDataSpace.samlGameCenterRoll[i] = roll;
        sence.SenceHost.transform:Find("SamllGame_RollMgr/SamllGame_Roll_" .. i).localPosition = Vector3(sence.SenceHost.transform:Find("SamllGame_RollMgr/SamllGame_Roll_" .. i).localPosition.x, 0, 0);
    end
    --TODO 初始完成后关闭场景
    sence.SenceHost.gameObject:SetActive(false);

end

function Procedure_SamllGameSence_Default:OnDestroy()
end

function Procedure_SamllGameSence_Default:OnRuning()

end

