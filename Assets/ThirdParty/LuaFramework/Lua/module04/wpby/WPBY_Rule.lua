WPBY_Rule = {};

local self = WPBY_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;

self.ruleList = nil;

function WPBY_Rule.Init()
    self.currentPos = 0;
    self.ruleList = WPBYEntry.rulePanel:Find("Content/RuleList"):GetComponent("ScrollRect");
    self.closeRuleBtn = WPBYEntry.rulePanel:Find("Content/BackBtn"):GetComponent("Button");
    self.leftShowBtn = WPBYEntry.rulePanel:Find("Content/LeftBtn"):GetComponent("Button");
    self.rightShowBtn = WPBYEntry.rulePanel:Find("Content/RightBtn"):GetComponent("Button");
    self.closeRuleBtn1 = WPBYEntry.rulePanel:Find("Content/FanHuiBtn"):GetComponent("Button");
    self.totalPos = self.ruleList.content.childCount;
    self.ruleList.horizontalNormalizedPosition = 0;
    self.closeRuleBtn.onClick:RemoveAllListeners();
    self.closeRuleBtn.onClick:AddListener(self.CloseRule);
    self.closeRuleBtn1.onClick:RemoveAllListeners();
    self.closeRuleBtn1.onClick:AddListener(self.CloseRule);
    self.leftShowBtn.onClick:RemoveAllListeners();
    self.leftShowBtn.onClick:AddListener(self.ClickLeftBtn);
    self.rightShowBtn.onClick:RemoveAllListeners();
    self.rightShowBtn.onClick:AddListener(self.ClickRightBtn);
    self.leftShowBtn.interactable = false;
end
function WPBY_Rule.ShowRule()
    WPBYEntry.rulePanel.gameObject:SetActive(true);
end
function WPBY_Rule.CloseRule()
    WPBYEntry.rulePanel.gameObject:SetActive(false);
end
function WPBY_Rule.ClickLeftBtn()
    if self.currentPos == self.totalPos - 1 then
        self.rightShowBtn.interactable = true;
    end
    self.currentPos = self.currentPos - 1;
    self.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
    if self.currentPos <= 0 then
        self.currentPos = 0;
        self.leftShowBtn.interactable = false;
        return ;
    end
end
function WPBY_Rule.ClickRightBtn()
    if self.currentPos == 0 then
        self.leftShowBtn.interactable = true;
    end
    self.currentPos = self.currentPos + 1;
    self.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
    if self.currentPos >= self.totalPos - 1 then
        self.currentPos = self.totalPos - 1;
        self.rightShowBtn.interactable = false;
        return ;
    end
end