JPM_Rule = {};

local self = JPM_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;
self.panelID=1

function JPM_Rule.ShowRule()
    if not JPM_Result.isShow then
        self.lastRollState = JPM_Roll.currentState;
        JPM_Roll.currentState = 0;
    else
        self.lastRollState = -1;
        JPM_Result.isPause = true;
    end
    self.panelID=1
    self.RuleChildsImage(self.panelID)
    JPMEntry.rulePanel.gameObject:SetActive(true);
    JPMEntry.closeRuleBtn.onClick:RemoveAllListeners();
    JPMEntry.closeRuleBtn.onClick:AddListener(self.CloseRule);

    JPMEntry.ruleUpBtn.onClick:RemoveAllListeners();
    JPMEntry.ruleUpBtn.onClick:AddListener(self.OnUpClick);

    JPMEntry.ruleDownBtn.onClick:RemoveAllListeners();
    JPMEntry.ruleDownBtn.onClick:AddListener(self.OnDownClick);
end
function JPM_Rule.CloseRule()
    JPM_Audio.PlaySound(JPM_Audio.SoundList.BTN);
    JPM_Result.isPause = false;
    if self.lastRollState ~= -1 then
        JPM_Roll.currentState = self.lastRollState;
    end
    JPMEntry.rulePanel.gameObject:SetActive(false);
end

function JPM_Rule.OnUpClick()
    if self.panelID==1 then
        self.panelID=3
    elseif self.panelID ==2 then
        self.panelID=1
    elseif self.panelID ==3 then
        self.panelID=2
    end
    self.RuleChildsImage(self.panelID)
end
function JPM_Rule.OnDownClick()
    if self.panelID==1 then
        self.panelID=2
    elseif self.panelID ==2 then
        self.panelID=3
    elseif self.panelID ==3 then
        self.panelID=1
    end
    self.RuleChildsImage(self.panelID)
end

function JPM_Rule.RuleChildsImage(index)
    if index==1 then
        JPMEntry.ruleChild1Image.gameObject:SetActive(true)
        JPMEntry.ruleChild2Image.gameObject:SetActive(false)
        JPMEntry.ruleChild3Image.gameObject:SetActive(false)
    elseif index==2 then
        JPMEntry.ruleChild1Image.gameObject:SetActive(false)
        JPMEntry.ruleChild2Image.gameObject:SetActive(true)
        JPMEntry.ruleChild3Image.gameObject:SetActive(false)
    elseif index==3 then
        JPMEntry.ruleChild1Image.gameObject:SetActive(false)
        JPMEntry.ruleChild2Image.gameObject:SetActive(false)
        JPMEntry.ruleChild3Image.gameObject:SetActive(true)
    end
end