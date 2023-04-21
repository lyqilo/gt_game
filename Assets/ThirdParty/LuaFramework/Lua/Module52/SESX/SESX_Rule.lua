SESX_Rule = {};

local self = SESX_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;

function SESX_Rule.ShowRule()
    --if not SESX_Result.isShow then
    --    self.lastRollState = SESX_Roll.currentState;
    --    SESX_Roll.currentState = 0;
    --else
    --    self.lastRollState = -1;
    --    SESX_Result.isPause = true;
    --end
    self.currentPos = 0;
    self.totalPos = SESXEntry.ruleList.content.childCount;
    SESXEntry.ruleList.horizontalNormalizedPosition = 0;
    SESXEntry.rulePanel.gameObject:SetActive(true);
    SESXEntry.closeRuleBtn.onClick:RemoveAllListeners();
    SESXEntry.closeRuleBtn.onClick:AddListener(self.CloseRule);
    SESXEntry.leftShowBtn.onClick:RemoveAllListeners();
    SESXEntry.leftShowBtn.onClick:AddListener(self.ClickLeftBtn);
    SESXEntry.rightShowBtn.onClick:RemoveAllListeners();
    SESXEntry.rightShowBtn.onClick:AddListener(self.ClickRightBtn);

end
function SESX_Rule.CloseRule()
    SESX_Audio.PlaySound(SESX_Audio.SoundList.BTN);
    --SESX_Result.isPause = false;
    --if self.lastRollState~=-1 then
    --    SESX_Roll.currentState = self.lastRollState;
    --end
    SESXEntry.rulePanel.gameObject:SetActive(false);
end
function SESX_Rule.ClickLeftBtn()
    SESX_Audio.PlaySound(SESX_Audio.SoundList.BTN);
    self.currentPos = self.currentPos - 1;
    if self.currentPos < 0 then
        self.currentPos = self.totalPos - 1;
    end
    SESXEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end
function SESX_Rule.ClickRightBtn()
    SESX_Audio.PlaySound(SESX_Audio.SoundList.BTN);
    self.currentPos = self.currentPos + 1;
    if self.currentPos > self.totalPos - 1 then
        self.currentPos = 0;
    end
    SESXEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end