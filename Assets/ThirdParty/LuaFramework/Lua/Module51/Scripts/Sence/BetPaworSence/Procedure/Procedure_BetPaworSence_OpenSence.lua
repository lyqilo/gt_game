--[[    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2019-08-20 20:04:27
]]
Procedure_BetPaworSence_OpenSence = {}
local self = Procedure_BetPaworSence_OpenSence

self.ProcedureName = "Procedure_BetPaworSence_OpenSence"
self.NextProcedureName = "Procedure_BetPaworSence_CloseSence"

function Procedure_BetPaworSence_OpenSence:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_BetPaworSence_OpenSence:OnAwake()
end

function Procedure_BetPaworSence_OpenSence:OnDestroy()
end

function Procedure_BetPaworSence_OpenSence:OnRuning()

    local sence = SenceMgr.FindSence(BetPaworSence.SenceName);
    if (LogicDataSpace.isShowBetPowar == false) then
        sence.SenceHost.transform:Find("BetPowarback"):DOLocalMoveY(-20, 0.5, false);
    end
    LogicDataSpace.isShowBetPowar = true;
    local animname = "ani_1";
    if LogicDataSpace.CurrSeleteChipsIndex ~= LogicDataSpace.LastSelectChipsIndex then
        if LogicDataSpace.CurrSeleteChipsIndex - LogicDataSpace.LastSelectChipsIndex > 1 and LogicDataSpace.CurrSeleteChipsIndex == 5 then
            animname = "ani_" .. (LogicDataSpace.CurrSeleteChipsIndex - 1) .. "-" .. LogicDataSpace.CurrSeleteChipsIndex;
        elseif LogicDataSpace.LastSelectChipsIndex - LogicDataSpace.CurrSeleteChipsIndex > 1 and LogicDataSpace.CurrSeleteChipsIndex == 1 then
            animname = "ani_" .. (LogicDataSpace.CurrSeleteChipsIndex + 1) .. "-" .. LogicDataSpace.CurrSeleteChipsIndex;
        else
            animname = "ani_" .. LogicDataSpace.LastSelectChipsIndex .. "-" .. LogicDataSpace.CurrSeleteChipsIndex;
        end
    end
    -- local a = LogicDataSpace.CurrSeleteChipsIndex / #LogicDataSpace.ChipsLable;
    -- sence.SenceHost.gameObject:SetActive(true);

    if animname == "ani_1-4" then
        animname = "ani_3-4";
    elseif animname == "ani_1-3" then
        animname = "ani_2-3";
    elseif animname == "ani_1-5" then
        animname = "ani_4-5";
    end
    animname = "bet" .. LogicDataSpace.CurrSeleteChipsIndex;
    sence.SenceHost.transform:Find("BetPowarback/BetPowarinfo"):GetComponent("Animator"):SetTrigger(animname);
end