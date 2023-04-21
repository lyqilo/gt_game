require("module51/Scripts/Sence/SettingSence/Procedure/Procedure_SettingSence_Default")
require("module51/Scripts/Sence/SettingSence/Procedure/Procedure_SettingSence_OpenSence")
require("module51/Scripts/Sence/SettingSence/Procedure/Procedure_SettingSence_CloseSence")

SettingSence = {}
local self = SettingSence
self.SenceHost = nil
self.SenceName = "SettingSence";
self.ProMgr = nil;

function SettingSence.new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function SettingSence.OnAwake()
    self.SenceHost = SlotGameEntry.transform:Find("Canvas/Setting").gameObject;
    self.ProMgr = ProcedureMgr:new();
    self.ProMgr.proMap = {};
    self.ProMgr:LoadProcedure(Procedure_SettingSence_Default:new())
    self.ProMgr:LoadProcedure(Procedure_SettingSence_OpenSence:new())
    self.ProMgr:LoadProcedure(Procedure_SettingSence_CloseSence:new())
    self.ProMgr:RunProcedure(Procedure_SettingSence_Default.ProcedureName);
end

function SettingSence.OnDisable()
    self.SenceHost:SetActive(false)
end

function SettingSence.OnEnable()
    self.SenceHost:SetActive(true)
end
function SettingSence.OnDestroy()
    destroy(self.SenceHost)
end
