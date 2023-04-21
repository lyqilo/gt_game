WLZB_Rule = {};

local self = WLZB_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;

function WLZB_Rule.ShowRule()
    WLZBEntry.CloseMenuCall();
    if not WLZB_Result.isShow then
        self.lastRollState = WLZB_Roll.currentState;
        WLZB_Roll.currentState = 0;
    else
        self.lastRollState = -1;
        WLZB_Result.isPause = true;
    end
    self.currentPos = 0;
    self.totalPos = WLZBEntry.ruleList.content.childCount;
    WLZBEntry.ruleList.horizontalNormalizedPosition = 0;
    WLZBEntry.rulePanel.gameObject:SetActive(true);
    WLZBEntry.closeRuleBtn.onClick:RemoveAllListeners();
    WLZBEntry.closeRuleBtn.onClick:AddListener(self.CloseRule);
    WLZBEntry.leftShowBtn.onClick:RemoveAllListeners();
    WLZBEntry.leftShowBtn.onClick:AddListener(self.ClickLeftBtn);
    WLZBEntry.rightShowBtn.onClick:RemoveAllListeners();
    WLZBEntry.rightShowBtn.onClick:AddListener(self.ClickRightBtn);

end
function WLZB_Rule.CloseRule()
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.BTN);
    WLZB_Result.isPause = false;
    if self.lastRollState~=-1 then
        WLZB_Roll.currentState = self.lastRollState;
    end
    WLZBEntry.rulePanel.gameObject:SetActive(false);
end
function WLZB_Rule.ClickLeftBtn()
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.BTN);
    self.currentPos = self.currentPos - 1;
    if self.currentPos < 0 then
        self.currentPos = self.totalPos - 1;
    end
    WLZBEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end
function WLZB_Rule.ClickRightBtn()
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.BTN);
    self.currentPos = self.currentPos + 1;
    if self.currentPos > self.totalPos - 1 then
        self.currentPos = 0;
    end
    WLZBEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end