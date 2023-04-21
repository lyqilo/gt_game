BQTP_Rule = {};

local self = BQTP_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;

function BQTP_Rule.ShowRule()
    --if not BQTP_Result.isShow then
    --    self.lastRollState = BQTP_Roll.currentState;
    --    BQTP_Roll.currentState = 0;
    --else
    --    self.lastRollState = -1;
    --    BQTP_Result.isPause = true;
    --end
    self.currentPos = 0;
    self.totalPos = BQTPEntry.ruleList.content.childCount;
    BQTPEntry.ruleList.horizontalNormalizedPosition = 0;
    BQTPEntry.rulePanel.gameObject:SetActive(true);
    BQTPEntry.closeRuleBtn.onClick:RemoveAllListeners();
    BQTPEntry.closeRuleBtn.onClick:AddListener(self.CloseRule);
    BQTPEntry.leftShowBtn.onClick:RemoveAllListeners();
    BQTPEntry.leftShowBtn.onClick:AddListener(self.ClickLeftBtn);
    BQTPEntry.rightShowBtn.onClick:RemoveAllListeners();
    BQTPEntry.rightShowBtn.onClick:AddListener(self.ClickRightBtn);

end
function BQTP_Rule.CloseRule()
    BQTP_Audio.PlaySound(BQTP_Audio.SoundList.BTN);
    --BQTP_Result.isPause = false;
    --if self.lastRollState~=-1 then
    --    BQTP_Roll.currentState = self.lastRollState;
    --end
    BQTPEntry.rulePanel.gameObject:SetActive(false);
end
function BQTP_Rule.ClickLeftBtn()
    BQTP_Audio.PlaySound(BQTP_Audio.SoundList.BTN);
    self.currentPos = self.currentPos - 1;
    if self.currentPos < 0 then
        self.currentPos = self.totalPos - 1;
    end
    BQTPEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end
function BQTP_Rule.ClickRightBtn()
    BQTP_Audio.PlaySound(BQTP_Audio.SoundList.BTN);
    self.currentPos = self.currentPos + 1;
    if self.currentPos > self.totalPos - 1 then
        self.currentPos = 0;
    end
    BQTPEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end