Module16_Rule = {};

local self = Module16_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;
self.panelID=1
self.trnsform=nil
function Module16_Rule.ShowRule()
    Module16Entry.CloseMenuCall();
    -- if not Module16_Result.isShow then
    --     self.lastRollState = Module16_Roll.currentState;
    --     Module16_Roll.currentState = 0;
    -- else
    --     self.lastRollState = -1;
    --    -- Module16_Result.isPause = true;
    -- end
    
    --self.currentPos = 0;
    -- self.totalPos = Module16Entry.ruleList.content.childCount;
    -- Module16Entry.ruleList.horizontalNormalizedPosition = 0;
    self.panelID=1
    Module16Entry.ruleList:Find("Viewport/Content/Image").gameObject:SetActive(true)
    Module16Entry.ruleList:Find("Viewport/Content/Image (1)").gameObject:SetActive(false)
    Module16Entry.ruleImage1:Find("Image").gameObject:SetActive(true)
    Module16Entry.ruleImage2:Find("Image").gameObject:SetActive(false)

    if self.transform==nil then
        local eventTrigger = Util.AddComponent("EventTriggerListener", Module16Entry.ruleList.gameObject);
        eventTrigger.onEndDrag = self.GameScrollMid_OnEndDrag
        self.transform=Module16Entry.rulePanel
    end
    Module16Entry.closeRuleBtn.onClick:RemoveAllListeners();
    Module16Entry.closeRuleBtn.onClick:AddListener(self.CloseRule);
    Module16Entry.rulePanel.gameObject:SetActive(true);
end


function Module16_Rule.GameScrollMid_OnEndDrag()
    logYellow("00000000000000")
    if self.panelID==1 then
        self.panelID=2
        Module16Entry.ruleList:Find("Viewport/Content/Image").gameObject:SetActive(false)
        Module16Entry.ruleList:Find("Viewport/Content/Image (1)").gameObject:SetActive(true)
        Module16Entry.ruleImage1:Find("Image").gameObject:SetActive(false)
        Module16Entry.ruleImage2:Find("Image").gameObject:SetActive(true)
    elseif self.panelID==2 then
        self.panelID=1
        Module16Entry.ruleList:Find("Viewport/Content/Image").gameObject:SetActive(true)
        Module16Entry.ruleList:Find("Viewport/Content/Image (1)").gameObject:SetActive(false)
        Module16Entry.ruleImage1:Find("Image").gameObject:SetActive(true)
        Module16Entry.ruleImage2:Find("Image").gameObject:SetActive(false)
    end
end

function Module16_Rule.CloseRule()
    Module16_Audio.PlaySound(Module16_Audio.SoundList.BTN);
    -- Module16_Result.isPause = false;
    -- if self.lastRollState~=-1 then
    --     Module16_Roll.currentState = self.lastRollState;
    -- end
    Module16Entry.rulePanel.gameObject:SetActive(false);
end
