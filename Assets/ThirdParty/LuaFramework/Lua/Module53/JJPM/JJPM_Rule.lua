JJPM_Rule = {};

local self = JJPM_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;

function JJPM_Rule.ShowRule()
    self.currentPos = 0;
    self.ruleList = JJPMEntry.rulePanel:Find("Content/RuleList"):GetComponent("ScrollRect");
    self.leftShowBtn = JJPMEntry.rulePanel:Find("Content/LeftBtn"):GetComponent("Button");
    self.rightShowBtn = JJPMEntry.rulePanel:Find("Content/RightBtn"):GetComponent("Button");
    self.closeRuleBtn = JJPMEntry.rulePanel:Find("Content/BackBtn"):GetComponent("Button");
    self.ruleProgress = JJPMEntry.rulePanel:Find("Content/Progress");
    self.totalPos = self.ruleList.content.childCount;
    self.ruleList.horizontalNormalizedPosition = 0;
    JJPMEntry.rulePanel.gameObject:SetActive(true);
    self.closeRuleBtn.onClick:RemoveAllListeners();
    self.closeRuleBtn.onClick:AddListener(self.CloseRule);
    self.leftShowBtn.onClick:RemoveAllListeners();
    self.leftShowBtn.onClick:AddListener(self.ClickLeftBtn);
    self.rightShowBtn.onClick:RemoveAllListeners();
    self.rightShowBtn.onClick:AddListener(self.ClickRightBtn);
    self.leftShowBtn.interactable = false;
    self.ruleProgress:GetChild(self.currentPos):GetComponent("Toggle").isOn = true;

end
function JJPM_Rule.CloseRule()
    JJPM_Audio.PlaySound(JJPM_Audio.SoundList.BTN);
    JJPMEntry.rulePanel.gameObject:SetActive(false);
end
function JJPM_Rule.ClickLeftBtn()
    JJPM_Audio.PlaySound(JJPM_Audio.SoundList.BTN);
    if self.currentPos == self.totalPos - 1 then
        self.rightShowBtn.interactable = true;
    end
    self.currentPos = self.currentPos - 1;
    self.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
    self.ruleProgress:GetChild(self.currentPos):GetComponent("Toggle").isOn = true;
    if self.currentPos <= 0 then
        self.currentPos = 0;
        self.leftShowBtn.interactable = false;
        return ;
    end
end
function JJPM_Rule.ClickRightBtn()
    JJPM_Audio.PlaySound(JJPM_Audio.SoundList.BTN);
    if self.currentPos == 0 then
        self.leftShowBtn.interactable = true;
    end
    self.currentPos = self.currentPos + 1;
    self.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
    self.ruleProgress:GetChild(self.currentPos):GetComponent("Toggle").isOn = true;
    if self.currentPos >= self.totalPos - 1 then
        self.currentPos = self.totalPos - 1;
        self.rightShowBtn.interactable = false;
        return ;
    end
end