Module13_Rule = {};

local self = Module13_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;
self.panelID=1
self.trnsform=nil
function Module13_Rule.ShowRule()
    Module13Entry.CloseMenuCall();
    -- if not Module13_Result.isShow then
    --     self.lastRollState = Module13_Roll.currentState;
    --     Module13_Roll.currentState = 0;
    -- else
    --     self.lastRollState = -1;
    --     --Module13_Result.isPause = true;
    -- end
    
    --self.currentPos = 0;
    -- self.totalPos = Module13Entry.ruleList.content.childCount;
    -- Module13Entry.ruleList.horizontalNormalizedPosition = 0;
    self.panelID=1
    Module13Entry.ruleList:Find("Viewport/Content/Image").gameObject:SetActive(true)
    Module13Entry.ruleList:Find("Viewport/Content/Image (1)").gameObject:SetActive(false)
    Module13Entry.ruleList:Find("Viewport/Content/Image (2)").gameObject:SetActive(false)


    if self.transform==nil then
        local eventTrigger = Util.AddComponent("EventTriggerListener", Module13Entry.ruleList.gameObject);
        eventTrigger.onEndDrag = self.GameScrollMid_OnEndDrag
        self.transform=Module13Entry.rulePanel
    end
    Module13Entry.closeRuleBtn.onClick:RemoveAllListeners();
    Module13Entry.closeRuleBtn.onClick:AddListener(self.CloseRule);
    Module13Entry.rulePanel.gameObject:SetActive(true);
end


function Module13_Rule.GameScrollMid_OnEndDrag()
    logYellow("00000000000000")
    local num =Module13Entry.ruleList:GetComponent("ScrollRect").horizontalNormalizedPosition
    logYellow("num=="..num)
    if self.panelID==1 then
        if num>0.2 then
            self.panelID=2
        else
            self.panelID=3
        end
    elseif self.panelID==2 then
        if num>0.2 then
            self.panelID=3
        else
            self.panelID=1
        end
    elseif self.panelID==3 then
        if num>0.2 then
            self.panelID=1
        else
            self.panelID=2
        end
    end

    if self.panelID==1 then
        Module13Entry.ruleList:Find("Viewport/Content/Image").gameObject:SetActive(true)
        Module13Entry.ruleList:Find("Viewport/Content/Image (1)").gameObject:SetActive(false)
        Module13Entry.ruleList:Find("Viewport/Content/Image (2)").gameObject:SetActive(false)
    elseif self.panelID==2 then
        Module13Entry.ruleList:Find("Viewport/Content/Image").gameObject:SetActive(false)
        Module13Entry.ruleList:Find("Viewport/Content/Image (1)").gameObject:SetActive(true)
        Module13Entry.ruleList:Find("Viewport/Content/Image (2)").gameObject:SetActive(false)
    elseif self.panelID==3 then
        Module13Entry.ruleList:Find("Viewport/Content/Image").gameObject:SetActive(false)
        Module13Entry.ruleList:Find("Viewport/Content/Image (1)").gameObject:SetActive(false)
        Module13Entry.ruleList:Find("Viewport/Content/Image (2)").gameObject:SetActive(true)
    end
end

function Module13_Rule.CloseRule()
    Module13_Audio.PlaySound(Module13_Audio.SoundList.BTN);
    -- Module13_Result.isPause = false;
    -- if self.lastRollState~=-1 then
    --     Module13_Roll.currentState = self.lastRollState;
    -- end
    Module13Entry.rulePanel.gameObject:SetActive(false);
end
