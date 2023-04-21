AJDMX_Rule = {};

local self = AJDMX_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;
self.custom = {};
self.panelID=1

function AJDMX_Rule.Init()
    self.custom={}
    -- self.zzb = AJDMXEntry.ruleChildPanel.content:Find("Image/ZZB");
    -- self.swk = AJDMXEntry.ruleChildPanel.content:Find("Image/SWK");
    -- self.other = AJDMXEntry.ruleChildPanel.content:Find("Image/Other");
    -- self.ld = AJDMXEntry.ruleChildPanel.content:Find("Image/Other1");
    -- self.zm = AJDMXEntry.ruleChildPanel.content:Find("Image/Other2");
    -- self.sz = AJDMXEntry.ruleChildPanel.content:Find("Image/Other3");
    -- self.scatter = AJDMXEntry.ruleChildPanel.content:Find("Image/Other4");
    -- self.wild = AJDMXEntry.ruleChildPanel.content:Find("Image/Other5");
    -- table.insert(self.custom, self.wild);
    -- table.insert(self.custom, self.scatter);
    -- table.insert(self.custom, self.sz);
    -- table.insert(self.custom, self.zm);
    -- table.insert(self.custom, self.ld);
    -- table.insert(self.custom, self.other);
    -- table.insert(self.custom, self.swk);
    -- table.insert(self.custom, self.zzb);
end
function AJDMX_Rule.SetBeiShu()
    -- logTable(self.custom)
    -- for i = 1, #self.custom do
    --     local count = 0;
    --     for j = 1, #AJDMX_DataConfig.BeiLVTable do
    --         if AJDMX_DataConfig.BeiLVTable[j][i] ~= 0 then
    --             count = count + 1;
    --             --tostring(#AJDMX_DataConfig.BeiLVTable - j + 2) .. "  " .. 
    --             self.custom[i]:GetChild(count - 1):GetComponent("Text").text =self.GetCustomK(AJDMX_DataConfig.BeiLVTable[j][i] * AJDMXEntry.CurrentChip);
    --         end
    --     end
    -- end
end
function AJDMX_Rule.GetCustomK(num)
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
function AJDMX_Rule.ShowRule()
    -- AJDMXEntry.CloseMenuCall();
    -- self.SetBeiShu();
    -- if not AJDMX_Result.isShow then
    --     self.lastRollState = AJDMX_Roll.currentState;
    --     AJDMX_Roll.currentState = 0;
    -- else
    --     self.lastRollState = -1;
    --     AJDMX_Result.isPause = true;
    -- end
    self.currentPos = 0;
    self.panelID=1
    self.RuleChildsImage(self.panelID)
    AJDMXEntry.ruleChildPanel.horizontalNormalizedPosition = 0;
    AJDMXEntry.rulePanel.gameObject:SetActive(true);
    AJDMXEntry.closeRuleBtn.onClick:RemoveAllListeners();
    AJDMXEntry.closeRuleBtn.onClick:AddListener(self.CloseRule);

    AJDMXEntry.ruleUpBtn.onClick:RemoveAllListeners();
    AJDMXEntry.ruleUpBtn.onClick:AddListener(self.OnUpClick);

    AJDMXEntry.ruleDownBtn.onClick:RemoveAllListeners();
    AJDMXEntry.ruleDownBtn.onClick:AddListener(self.OnDownClick);

end
function AJDMX_Rule.CloseRule()
    AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BtnClick);
    -- AJDMX_Result.isPause = false;
    -- if self.lastRollState ~= -1 then
    --     AJDMX_Roll.currentState = self.lastRollState;
    -- end
    AJDMXEntry.rulePanel.gameObject:SetActive(false);
end
function AJDMX_Rule.OnUpClick()
    AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BtnClick);
    self.panelID= self.panelID-1
    if self.panelID<=0 then
        self.panelID=AJDMXEntry.ruleChildPanel.transform:GetChild(0):GetChild(0).childCount
    end
    self.RuleChildsImage(self.panelID)
end
function AJDMX_Rule.OnDownClick()
    AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BtnClick);
    self.panelID= self.panelID+1
    if self.panelID>AJDMXEntry.ruleChildPanel.transform:GetChild(0):GetChild(0).childCount then
        self.panelID=1
    end
    self.RuleChildsImage(self.panelID)
end

function AJDMX_Rule.RuleChildsImage(index)
    for i=1,AJDMXEntry.ruleChildPanel.transform:GetChild(0):GetChild(0).childCount do
        if index==i then
            AJDMXEntry.ruleChildPanel.transform:GetChild(0):GetChild(0):GetChild(i-1).gameObject:SetActive(true)
        else
            AJDMXEntry.ruleChildPanel.transform:GetChild(0):GetChild(0):GetChild(i-1).gameObject:SetActive(false)
        end
    end
    if index==1 then
        AJDMXEntry.ruleUpBtn.transform.gameObject:SetActive(false)
        AJDMXEntry.ruleDownBtn.transform.gameObject:SetActive(true)
        AJDMXEntry.ruleUpBtn.transform:GetComponent("Button").interactable=false
        AJDMXEntry.ruleDownBtn.transform:GetComponent("Button").interactable=true
    elseif index==AJDMXEntry.ruleChildPanel.transform:GetChild(0):GetChild(0).childCount then
        AJDMXEntry.ruleUpBtn.transform.gameObject:SetActive(true)
        AJDMXEntry.ruleDownBtn.transform.gameObject:SetActive(false)
        AJDMXEntry.ruleUpBtn.transform:GetComponent("Button").interactable=true
        AJDMXEntry.ruleDownBtn.transform:GetComponent("Button").interactable=false
    else
        AJDMXEntry.ruleUpBtn.transform.gameObject:SetActive(true)
        AJDMXEntry.ruleDownBtn.transform.gameObject:SetActive(true)
        AJDMXEntry.ruleUpBtn.transform:GetComponent("Button").interactable=true
        AJDMXEntry.ruleDownBtn.transform:GetComponent("Button").interactable=true
    end
end