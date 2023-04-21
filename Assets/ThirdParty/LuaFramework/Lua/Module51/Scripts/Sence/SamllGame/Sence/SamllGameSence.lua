

require("module51/Scripts/Sence/SamllGame/Procedure/Procedure_SamllGameSence_Default")
require("module51/Scripts/Sence/SamllGame/Procedure/Procedure_SamllGameSence_OpenSence")
require("module51/Scripts/Sence/SamllGame/Procedure/Procedure_SamllGameSence_CloseSence")
require("module51/Scripts/Sence/SamllGame/Procedure/Procedure_SamllGameSence_StarGame")
require("module51/Scripts/Sence/SamllGame/Procedure/Procedure_SamllGameSence_StarRoll")
require("module51/Scripts/Sence/SamllGame/Procedure/Procedure_SamllGameSence_ShowResult")
require("module51/Scripts/Sence/SamllGame/Procedure/Procedure_SamllGameSence_Node")
require("module51/Scripts/Sence/SamllGame/Procedure/Procedure_SamllGameSence_RestSamlGameChips")
require("module51/Scripts/Sence/SamllGame/Procedure/Procedure_SamllGameSence_RestSamlGameNum")
require("module51/Scripts/Sence/SamllGame/Procedure/Procedure_SamllGameSence_RestSamlGameSelfGold")
require("module51/Scripts/Sence/SamllGame/Procedure/Procedure_SamllGameSence_RestSamlGameWinGold")

SamllGameSence = {}
local self = SamllGameSence

self.SenceHost = nil
self.SenceName = "SamllGameSence";
self.ProMgr = nil;

function SamllGameSence.new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function SamllGameSence.OnAwake()
    self.SenceHost = SlotGameEntry.transform:Find("Canvas/SamllGame").gameObject;
    self.ProMgr = ProcedureMgr:new();
    self.ProMgr.proMap = {};
    self.ProMgr:LoadProcedure(Procedure_SamllGameSence_Default:new())
    self.ProMgr:LoadProcedure(Procedure_SamllGameSence_OpenSence:new())
    self.ProMgr:LoadProcedure(Procedure_SamllGameSence_CloseSence:new())
    self.ProMgr:LoadProcedure(Procedure_SamllGameSence_StarGame:new())
    self.ProMgr:LoadProcedure(Procedure_SamllGameSence_StarRoll:new())
    self.ProMgr:LoadProcedure(Procedure_SamllGameSence_ShowResult:new())
    self.ProMgr:LoadProcedure(Procedure_SamllGameSence_Node:new())
    self.ProMgr:LoadProcedure(Procedure_SamllGameSence_RestSamlGameChips:new())
    self.ProMgr:LoadProcedure(Procedure_SamllGameSence_RestSamlGameNum:new())
    self.ProMgr:LoadProcedure(Procedure_SamllGameSence_RestSamlGameSelfGold:new())
    self.ProMgr:LoadProcedure(Procedure_SamllGameSence_RestSamlGameWinGold:new())
    self.ProMgr:RunProcedure(Procedure_SamllGameSence_Default.ProcedureName);
end

function SamllGameSence.OnDisable()
    self.SenceHost:SetActive(false)
end

function SamllGameSence.OnEnable()
    self.SenceHost:SetActive(true)
end
function SamllGameSence.OnDestroy()
    destroy(self.SenceHost)
end
