LGDDY_Rule = {};

local self = LGDDY_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;

function LGDDY_Rule.ShowRule()
    --if not LGDDY_Result.isShow then
    --    self.lastRollState = LGDDY_Roll.currentState;
    --    LGDDY_Roll.currentState = 0;
    --else
    --    self.lastRollState = -1;
    --    LGDDY_Result.isPause = true;
    --end
    self.currentPos = 0;
    self.totalPos = LGDDYEntry.ruleList.content.childCount;
    LGDDYEntry.ruleList.horizontalNormalizedPosition = 0;
    LGDDYEntry.rulePanel.gameObject:SetActive(true);
    LGDDYEntry.closeRuleBtn.onClick:RemoveAllListeners();
    LGDDYEntry.closeRuleBtn.onClick:AddListener(self.CloseRule);
    LGDDYEntry.leftShowBtn.onClick:RemoveAllListeners();
    LGDDYEntry.leftShowBtn.onClick:AddListener(self.ClickLeftBtn);
    LGDDYEntry.rightShowBtn.onClick:RemoveAllListeners();
    LGDDYEntry.rightShowBtn.onClick:AddListener(self.ClickRightBtn);

end
function LGDDY_Rule.CloseRule()
    LGDDY_Audio.PlaySound(LGDDY_Audio.SoundList.BTN);
    --LGDDY_Result.isPause = false;
    --if self.lastRollState~=-1 then
    --    LGDDY_Roll.currentState = self.lastRollState;
    --end
    LGDDYEntry.rulePanel.gameObject:SetActive(false);
end
function LGDDY_Rule.ClickLeftBtn()
    LGDDY_Audio.PlaySound(LGDDY_Audio.SoundList.BTN);
    self.currentPos = self.currentPos - 1;
    if self.currentPos < 0 then
        self.currentPos = self.totalPos - 1;
    end
    LGDDYEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end
function LGDDY_Rule.ClickRightBtn()
    LGDDY_Audio.PlaySound(LGDDY_Audio.SoundList.BTN);
    self.currentPos = self.currentPos + 1;
    if self.currentPos > self.totalPos - 1 then
        self.currentPos = 0;
    end
    LGDDYEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end