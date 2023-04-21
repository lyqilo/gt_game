SGXML_Rule = {};

local self = SGXML_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;

function SGXML_Rule.ShowRule()
    --if not SGXML_Result.isShow then
    --    self.lastRollState = SGXML_Roll.currentState;
    --    SGXML_Roll.currentState = 0;
    --else
    --    self.lastRollState = -1;
    --    SGXML_Result.isPause = true;
    --end
    self.currentPos = 0;
    self.totalPos = SGXMLEntry.ruleList.content.childCount;
    SGXMLEntry.ruleList.horizontalNormalizedPosition = 0;
    SGXMLEntry.rulePanel.gameObject:SetActive(true);
    SGXMLEntry.closeRuleBtn.onClick:RemoveAllListeners();
    SGXMLEntry.closeRuleBtn.onClick:AddListener(self.CloseRule);
    SGXMLEntry.leftShowBtn.onClick:RemoveAllListeners();
    SGXMLEntry.leftShowBtn.onClick:AddListener(self.ClickLeftBtn);
    SGXMLEntry.rightShowBtn.onClick:RemoveAllListeners();
    SGXMLEntry.rightShowBtn.onClick:AddListener(self.ClickRightBtn);

end
function SGXML_Rule.CloseRule()
    SGXML_Audio.PlaySound(SGXML_Audio.SoundList.BTN);
    --SGXML_Result.isPause = false;
    --if self.lastRollState~=-1 then
    --    SGXML_Roll.currentState = self.lastRollState;
    --end
    SGXMLEntry.rulePanel.gameObject:SetActive(false);
end
function SGXML_Rule.ClickLeftBtn()
    SGXML_Audio.PlaySound(SGXML_Audio.SoundList.BTN);
    self.currentPos = self.currentPos - 1;
    if self.currentPos < 0 then
        self.currentPos = self.totalPos - 1;
    end
    SGXMLEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end
function SGXML_Rule.ClickRightBtn()
    SGXML_Audio.PlaySound(SGXML_Audio.SoundList.BTN);
    self.currentPos = self.currentPos + 1;
    if self.currentPos > self.totalPos - 1 then
        self.currentPos = 0;
    end
    SGXMLEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end