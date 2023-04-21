FLM_Rule = {};

local self = FLM_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;

function FLM_Rule.ShowRule()
    FLMEntry.CloseMenuCall();
    if not FLM_Result.isShow then
        self.lastRollState = FLM_Roll.currentState;
        FLM_Roll.currentState = 0;
    else
        self.lastRollState = -1;
        FLM_Result.isPause = true;
    end
    self.currentPos = 0;
    self.totalPos = FLMEntry.ruleList.content.childCount;
    FLMEntry.ruleList.horizontalNormalizedPosition = 0;
    FLMEntry.rulePanel.gameObject:SetActive(true);
    FLMEntry.closeRuleBtn.onClick:RemoveAllListeners();
    FLMEntry.closeRuleBtn.onClick:AddListener(self.CloseRule);
    FLMEntry.leftShowBtn.onClick:RemoveAllListeners();
    FLMEntry.leftShowBtn.onClick:AddListener(self.ClickLeftBtn);
    FLMEntry.rightShowBtn.onClick:RemoveAllListeners();
    FLMEntry.rightShowBtn.onClick:AddListener(self.ClickRightBtn);
    FLMEntry.pageDesc.text = (self.currentPos+1).."/"..self.totalPos;
end
function FLM_Rule.CloseRule()
    FLM_Audio.PlaySound(FLM_Audio.SoundList.BTN);
    FLM_Result.isPause = false;
    if self.lastRollState~=-1 then
        FLM_Roll.currentState = self.lastRollState;
    end
    FLMEntry.rulePanel.gameObject:SetActive(false);
end
function FLM_Rule.ClickLeftBtn()
    FLM_Audio.PlaySound(FLM_Audio.SoundList.BTN);
    self.currentPos = self.currentPos - 1;
    if self.currentPos < 0 then
        self.currentPos = self.totalPos - 1;
    end
    FLMEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
    FLMEntry.pageDesc.text = (self.currentPos+1).."/"..self.totalPos;
end
function FLM_Rule.ClickRightBtn()
    FLM_Audio.PlaySound(FLM_Audio.SoundList.BTN);
    self.currentPos = self.currentPos + 1;
    if self.currentPos > self.totalPos - 1 then
        self.currentPos = 0;
    end
    FLMEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
    FLMEntry.pageDesc.text = (self.currentPos+1).."/"..self.totalPos;
end