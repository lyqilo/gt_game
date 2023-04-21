TGG_Rule = {};

local self = TGG_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;

function TGG_Rule.ShowRule()
    if not TGG_Result.isShow then
        self.lastRollState = TGG_Roll.currentState;
        TGG_Roll.currentState = 0;
    else
        self.lastRollState = -1;
        TGG_Result.isPause = true;
    end
    self.currentPos = 0;
    self.totalPos = TGGEntry.ruleList.content.childCount;
    TGGEntry.closeGame.gameObject:SetActive(false);
    TGGEntry.ruleList.horizontalNormalizedPosition = 0;
    TGGEntry.rulePanel.gameObject:SetActive(true);
    TGGEntry.closeRuleBtn.onClick:RemoveAllListeners();
    TGGEntry.closeRuleBtn.onClick:AddListener(self.CloseRule);

end
function TGG_Rule.CloseRule()
    TGGEntry.closeGame.gameObject:SetActive(true);
    TGG_Audio.PlaySound(TGG_Audio.SoundList.BTN);
    TGG_Result.isPause = false;
    if self.lastRollState ~= -1 then
        TGG_Roll.currentState = self.lastRollState;
    end
    TGGEntry.rulePanel.gameObject:SetActive(false);
end
function TGG_Rule.ClickLeftBtn()
    TGG_Audio.PlaySound(TGG_Audio.SoundList.BTN);
    self.currentPos = self.currentPos - 1;
    if self.currentPos < 0 then
        self.currentPos = self.totalPos - 1;
    end
    TGGEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end
function TGG_Rule.ClickRightBtn()
    TGG_Audio.PlaySound(TGG_Audio.SoundList.BTN);
    self.currentPos = self.currentPos + 1;
    if self.currentPos > self.totalPos - 1 then
        self.currentPos = 0;
    end
    TGGEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end