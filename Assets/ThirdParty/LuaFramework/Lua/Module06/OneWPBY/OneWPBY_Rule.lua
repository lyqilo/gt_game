OneWPBY_Rule = {};

local self = OneWPBY_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;

self.ruleList = nil;

function OneWPBY_Rule.Init()
    self.currentPos = 0;
    self.ruleList = OneWPBYEntry.rulePanel:Find("Content/RuleList"):GetComponent("ScrollRect");
    self.closeRuleBtn = OneWPBYEntry.rulePanel:Find("Content/BackBtn"):GetComponent("Button");
    self.leftShowBtn = OneWPBYEntry.rulePanel:Find("Content/LeftBtn"):GetComponent("Button");
    self.rightShowBtn = OneWPBYEntry.rulePanel:Find("Content/RightBtn"):GetComponent("Button");
    self.closeRuleBtn1 = OneWPBYEntry.rulePanel:Find("Content/FanHuiBtn"):GetComponent("Button");
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
function OneWPBY_Rule.ShowRule()
    OneWPBYEntry.openMoveGroup.isOn = false;
    OneWPBYEntry.moveGroup.gameObject:SetActive(false);
    OneWPBYEntry.rulePanel.gameObject:SetActive(true);
end
function OneWPBY_Rule.CloseRule()
    OneWPBYEntry.rulePanel.gameObject:SetActive(false);
end
function OneWPBY_Rule.ClickLeftBtn()
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
function OneWPBY_Rule.ClickRightBtn()
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