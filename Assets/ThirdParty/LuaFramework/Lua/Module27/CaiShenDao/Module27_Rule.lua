Module27_Rule = {};

local self = Module27_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;

function Module27_Rule.ShowRule()
    Module27.CloseMenuCall();
    if not Module27_Result.isShow then
        self.lastRollState = Module27_Roll.currentState;
        Module27_Roll.currentState = 0;
    else
        self.lastRollState = -1;
        Module27_Result.isPause = true;
    end
    self.currentPos = 0;
    self.totalPos = Module27.ruleList.content.childCount;
    Module27.ruleList.horizontalNormalizedPosition = 0;
    Module27.rulePanel.gameObject:SetActive(true);
    Module27.closeRuleBtn.onClick:RemoveAllListeners();
    Module27.closeRuleBtn.onClick:AddListener(self.CloseRule);
    Module27.leftShowBtn.onClick:RemoveAllListeners();
    Module27.leftShowBtn.onClick:AddListener(self.ClickLeftBtn);
    Module27.rightShowBtn.onClick:RemoveAllListeners();
    Module27.rightShowBtn.onClick:AddListener(self.ClickRightBtn);

end
function Module27_Rule.CloseRule()
    Module27_Audio.PlaySound(Module27_Audio.SoundList.BTN);
    Module27_Result.isPause = false;
    if self.lastRollState~=-1 then
        Module27_Roll.currentState = self.lastRollState;
    end
    Module27.rulePanel.gameObject:SetActive(false);
end
function Module27_Rule.ClickLeftBtn()
    Module27_Audio.PlaySound(Module27_Audio.SoundList.BTN);
    self.currentPos = self.currentPos - 1;
    if self.currentPos < 0 then
        self.currentPos = self.totalPos - 1;
    end
    Module27.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end
function Module27_Rule.ClickRightBtn()
    Module27_Audio.PlaySound(Module27_Audio.SoundList.BTN);
    self.currentPos = self.currentPos + 1;
    if self.currentPos > self.totalPos - 1 then
        self.currentPos = 0;
    end
    Module27.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end