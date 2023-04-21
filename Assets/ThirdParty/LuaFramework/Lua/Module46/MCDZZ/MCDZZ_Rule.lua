MCDZZ_Rule = {};

local self = MCDZZ_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;
self.custom = {};
self.panelID=1

function MCDZZ_Rule.Init()
    self.custom={}
    self.zzb = MCDZZEntry.ruleChildPanel:Find("Image1/eh");
    self.swk = MCDZZEntry.ruleChildPanel:Find("Image1/lh");
    self.other = MCDZZEntry.ruleChildPanel:Find("Image1/td");
    self.ld = MCDZZEntry.ruleChildPanel:Find("Image1/yc");
    self.zm = MCDZZEntry.ruleChildPanel:Find("Image1/tao");
    self.sz = MCDZZEntry.ruleChildPanel:Find("Image1/hua");
    table.insert(self.custom, self.sz);
    table.insert(self.custom, self.zm);
    table.insert(self.custom, self.ld);
    table.insert(self.custom, self.other);
    table.insert(self.custom, self.swk);
    table.insert(self.custom, self.zzb);
end
function MCDZZ_Rule.SetBeiShu()
    logTable(self.custom)
    for i = 1, #self.custom do
        local count = 0;
        for j = 1, #MCDZZ_DataConfig.BeiLVTable do
            if MCDZZ_DataConfig.BeiLVTable[j][i] ~= 0 then
                count = count + 1;
                --tostring(#MCDZZ_DataConfig.BeiLVTable - j + 2) .. "  " .. 
                self.custom[i]:GetChild(count - 1):GetComponent("Text").text =self.GetCustomK(MCDZZ_DataConfig.BeiLVTable[j][i] * MCDZZEntry.CurrentChip);
            end
        end
    end
end
function MCDZZ_Rule.GetCustomK(num)
    local str=""
    local n = 0;
    if num<1000 then
        n=num
        str=""
    elseif num>=1000 and num <1000000 then
        n=tonumber(num) / 1000
        str="k"
    else
        n=tonumber(num) / 1000000
        str="M"
    end
    return tostring(n)..str;

end
function MCDZZ_Rule.ShowRule()
    MCDZZEntry.CloseMenuCall();
    self.SetBeiShu();
    -- if not MCDZZ_Result.isShow then
    --     self.lastRollState = MCDZZ_Roll.currentState;
    --     MCDZZ_Roll.currentState = 0;
    -- else
    --     self.lastRollState = -1;
    --     MCDZZ_Result.isPause = true;
    -- end
    self.currentPos = 0;
    self.panelID=1
    self.RuleChildsImage(self.panelID)
    MCDZZEntry.rulePanel.gameObject:SetActive(true);
    MCDZZEntry.closeRuleBtn.onClick:RemoveAllListeners();
    MCDZZEntry.closeRuleBtn.onClick:AddListener(self.CloseRule);

    MCDZZEntry.ruleUpBtn.onClick:RemoveAllListeners();
    MCDZZEntry.ruleUpBtn.onClick:AddListener(self.OnUpClick);

    MCDZZEntry.ruleDownBtn.onClick:RemoveAllListeners();
    MCDZZEntry.ruleDownBtn.onClick:AddListener(self.OnDownClick);

end
function MCDZZ_Rule.CloseRule()
    MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.BTN1);
    --MCDZZ_Result.isPause = false;
    -- if self.lastRollState ~= -1 then
    --     MCDZZ_Roll.currentState = self.lastRollState;
    -- end
    MCDZZEntry.rulePanel.gameObject:SetActive(false);
end

function MCDZZ_Rule.OnUpClick()
    MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.BTN1);
    self.panelID= self.panelID-1
    if self.panelID<=0 then
        self.panelID=MCDZZEntry.ruleChildPanel.transform.childCount
    end
    self.RuleChildsImage(self.panelID)
end
function MCDZZ_Rule.OnDownClick()
    MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.BTN1);

    self.panelID= self.panelID+1
    if self.panelID>MCDZZEntry.ruleChildPanel.transform.childCount then
        self.panelID=1
    end
    self.RuleChildsImage(self.panelID)
end

function MCDZZ_Rule.RuleChildsImage(index)

    for i=1,MCDZZEntry.ruleChildPanel.transform.childCount do
        if index==i then
            MCDZZEntry.ruleChildPanel.transform:GetChild(i-1).gameObject:SetActive(true)
        else
            MCDZZEntry.ruleChildPanel.transform:GetChild(i-1).gameObject:SetActive(false)
        end
    end
    if index==1 then
        MCDZZEntry.ruleUpBtn.transform:GetComponent("Button").interactable=false
        MCDZZEntry.ruleUpBtn.transform:GetChild(0).gameObject:SetActive(true)

        MCDZZEntry.ruleDownBtn.transform:GetComponent("Button").interactable=true
        MCDZZEntry.ruleDownBtn.transform:GetChild(0).gameObject:SetActive(false)
    elseif index==MCDZZEntry.ruleChildPanel.transform.childCount then
        MCDZZEntry.ruleUpBtn.transform:GetComponent("Button").interactable=true
        MCDZZEntry.ruleUpBtn.transform:GetChild(0).gameObject:SetActive(false)

        MCDZZEntry.ruleDownBtn.transform:GetComponent("Button").interactable=false
        MCDZZEntry.ruleDownBtn.transform:GetChild(0).gameObject:SetActive(true)
    else
        MCDZZEntry.ruleUpBtn.transform:GetComponent("Button").interactable=true
        MCDZZEntry.ruleUpBtn.transform:GetChild(0).gameObject:SetActive(false)

        MCDZZEntry.ruleDownBtn.transform:GetComponent("Button").interactable=true
        MCDZZEntry.ruleDownBtn.transform:GetChild(0).gameObject:SetActive(false)

    end
end