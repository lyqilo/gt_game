JSYC_Rule = {};

local self = JSYC_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;

function JSYC_Rule.ShowRule()
    -- if not JSYC_Result.isShow then
    --     self.lastRollState = JSYC_Roll.currentState;
    --     JSYC_Roll.currentState = 0;
    -- else
    --     self.lastRollState = -1;
    --     JSYC_Result.isPause = true;
    -- end
    self.currentPos = 0;
    self.totalPos = JSYCEntry.ruleList.content.childCount;
    JSYCEntry.closeGame.gameObject:SetActive(false);
    JSYCEntry.ruleList.horizontalNormalizedPosition = 0;
    JSYCEntry.rulePanel.gameObject:SetActive(true);
    JSYCEntry.closeRuleBtn.onClick:RemoveAllListeners();
    JSYCEntry.closeRuleBtn.onClick:AddListener(self.CloseRule);

end
function JSYC_Rule.CloseRule()
    JSYCEntry.closeGame.gameObject:SetActive(true);
    JSYC_Audio.PlaySound(JSYC_Audio.SoundList.BTN);
    -- JSYC_Result.isPause = false;
    -- if self.lastRollState ~= -1 then
    --     JSYC_Roll.currentState = self.lastRollState;
    -- end
    JSYCEntry.rulePanel.gameObject:SetActive(false);
end
function JSYC_Rule.ClickLeftBtn()
    JSYC_Audio.PlaySound(JSYC_Audio.SoundList.BTN);
    self.currentPos = self.currentPos - 1;
    if self.currentPos < 0 then
        self.currentPos = self.totalPos - 1;
    end
    JSYCEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end
function JSYC_Rule.ClickRightBtn()
    JSYC_Audio.PlaySound(JSYC_Audio.SoundList.BTN);
    self.currentPos = self.currentPos + 1;
    if self.currentPos > self.totalPos - 1 then
        self.currentPos = 0;
    end
    JSYCEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end