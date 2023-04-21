XMZZ_Rule = {};

local self = XMZZ_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;

function XMZZ_Rule.ShowRule()
    --if not XMZZ_Result.isShow then
    --    self.lastRollState = XMZZ_Roll.currentState;
    --    XMZZ_Roll.currentState = 0;
    --else
    --    self.lastRollState = -1;
    --    XMZZ_Result.isPause = true;
    --end
    self.currentPos = 0;
    self.totalPos = XMZZEntry.ruleList.content.childCount;
    XMZZEntry.ruleList.horizontalNormalizedPosition = 0;
    XMZZEntry.rulePanel.gameObject:SetActive(true);
    XMZZEntry.closeRuleBtn.onClick:RemoveAllListeners();
    XMZZEntry.closeRuleBtn.onClick:AddListener(self.CloseRule);
    XMZZEntry.leftShowBtn.onClick:RemoveAllListeners();
    XMZZEntry.leftShowBtn.onClick:AddListener(self.ClickLeftBtn);
    XMZZEntry.rightShowBtn.onClick:RemoveAllListeners();
    XMZZEntry.rightShowBtn.onClick:AddListener(self.ClickRightBtn);

end
function XMZZ_Rule.CloseRule()
    XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.BTN);
    --XMZZ_Result.isPause = false;
    --if self.lastRollState~=-1 then
    --    XMZZ_Roll.currentState = self.lastRollState;
    --end
    XMZZEntry.rulePanel.gameObject:SetActive(false);
end
function XMZZ_Rule.ClickLeftBtn()
    XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.BTN);
    self.currentPos = self.currentPos - 1;
    if self.currentPos < 0 then
        self.currentPos = self.totalPos - 1;
    end
    XMZZEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end
function XMZZ_Rule.ClickRightBtn()
    XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.BTN);
    self.currentPos = self.currentPos + 1;
    if self.currentPos > self.totalPos - 1 then
        self.currentPos = 0;
    end
    XMZZEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end