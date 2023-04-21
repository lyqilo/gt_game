SHT_Rule = {};

local self = SHT_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;
self.custom = {};
self.panelID=1

function SHT_Rule.Init()
    self.custom={}
    self.zzb = SHTEntry.ruleChildPanel.content:Find("Image/ZZB");
    self.swk = SHTEntry.ruleChildPanel.content:Find("Image/SWK");
    self.other = SHTEntry.ruleChildPanel.content:Find("Image/Other");
    self.ld = SHTEntry.ruleChildPanel.content:Find("Image/Other1");
    self.zm = SHTEntry.ruleChildPanel.content:Find("Image/Other2");
    self.sz = SHTEntry.ruleChildPanel.content:Find("Image/Other3");
    self.scatter = SHTEntry.ruleChildPanel.content:Find("Image/Other4");
    self.wild = SHTEntry.ruleChildPanel.content:Find("Image/Other5");
    table.insert(self.custom, self.wild);
    table.insert(self.custom, self.scatter);
    table.insert(self.custom, self.sz);
    table.insert(self.custom, self.zm);
    table.insert(self.custom, self.ld);
    table.insert(self.custom, self.other);
    table.insert(self.custom, self.swk);
    table.insert(self.custom, self.zzb);
end
function SHT_Rule.SetBeiShu()
    logTable(self.custom)
    for i = 1, #self.custom do
        local count = 0;
        for j = 1, #SHT_DataConfig.BeiLVTable do
            if SHT_DataConfig.BeiLVTable[j][i] ~= 0 then
                count = count + 1;
                --tostring(#SHT_DataConfig.BeiLVTable - j + 2) .. "  " .. 
                self.custom[i]:GetChild(count - 1):GetComponent("Text").text =self.GetCustomK(SHT_DataConfig.BeiLVTable[j][i] * SHTEntry.CurrentChip);
            end
        end
    end
end
function SHT_Rule.GetCustomK(num)
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
function SHT_Rule.ShowRule()
    SHTEntry.CloseMenuCall();
    self.SetBeiShu();
    -- if not SHT_Result.isShow then
    --     self.lastRollState = SHT_Roll.currentState;
    --     SHT_Roll.currentState = 0;
    -- else
    --     self.lastRollState = -1;
    --     SHT_Result.isPause = true;
    -- end
    self.currentPos = 0;
    self.panelID=1
    self.RuleChildsImage(self.panelID)
    SHTEntry.ruleChildPanel.horizontalNormalizedPosition = 0;
    SHTEntry.rulePanel.gameObject:SetActive(true);
    SHTEntry.closeRuleBtn.onClick:RemoveAllListeners();
    SHTEntry.closeRuleBtn.onClick:AddListener(self.CloseRule);

    SHTEntry.ruleUpBtn.onClick:RemoveAllListeners();
    SHTEntry.ruleUpBtn.onClick:AddListener(self.OnUpClick);

    SHTEntry.ruleDownBtn.onClick:RemoveAllListeners();
    SHTEntry.ruleDownBtn.onClick:AddListener(self.OnDownClick);

end
function SHT_Rule.CloseRule()
    SHT_Audio.PlaySound(SHT_Audio.SoundList.CloseClick);
    SHT_Result.isPause = false;
    if self.lastRollState ~= -1 then
        SHT_Roll.currentState = self.lastRollState;
    end
    SHTEntry.rulePanel.gameObject:SetActive(false);
end
function SHT_Rule.OnUpClick()
    SHT_Audio.PlaySound(SHT_Audio.SoundList.BtnClick);
    self.panelID= self.panelID-1
    if self.panelID<=0 then
        self.panelID=SHTEntry.ruleChildPanel.transform:GetChild(0):GetChild(0).childCount
    end
    self.RuleChildsImage(self.panelID)
end
function SHT_Rule.OnDownClick()
    SHT_Audio.PlaySound(SHT_Audio.SoundList.BtnClick);
    self.panelID= self.panelID+1
    if self.panelID>SHTEntry.ruleChildPanel.transform:GetChild(0):GetChild(0).childCount then
        self.panelID=1
    end
    self.RuleChildsImage(self.panelID)
end

function SHT_Rule.RuleChildsImage(index)
    for i=1,SHTEntry.ruleChildPanel.transform:GetChild(0):GetChild(0).childCount do
        if index==i then
            SHTEntry.ruleChildPanel.transform:GetChild(0):GetChild(0):GetChild(i-1).gameObject:SetActive(true)
        else
            SHTEntry.ruleChildPanel.transform:GetChild(0):GetChild(0):GetChild(i-1).gameObject:SetActive(false)
        end
    end
    if index==1 then
        SHTEntry.ruleUpBtn.transform:GetComponent("Button").interactable=false
        SHTEntry.ruleDownBtn.transform:GetComponent("Button").interactable=true
    elseif index==SHTEntry.ruleChildPanel.transform:GetChild(0):GetChild(0).childCount then
        SHTEntry.ruleUpBtn.transform:GetComponent("Button").interactable=true
        SHTEntry.ruleDownBtn.transform:GetComponent("Button").interactable=false
    else
        SHTEntry.ruleUpBtn.transform:GetComponent("Button").interactable=true
        SHTEntry.ruleDownBtn.transform:GetComponent("Button").interactable=true
    end
end