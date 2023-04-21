XYSGJ_Rule = {};

local self = XYSGJ_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;
self.panelID=1

function XYSGJ_Rule.ShowRule()
    -- if not XYSGJ_Result.isShow then
    --     self.lastRollState = XYSGJ_Roll.currentState;
    --     XYSGJ_Roll.currentState = 0;
    -- else
    --     self.lastRollState = -1;
    --     XYSGJ_Result.isPause = true;
    -- end
    self.panelID=3
    self.RuleChildsImage(self.panelID)
    XYSGJEntry.rulePanel.gameObject:SetActive(true);
    XYSGJEntry.closeRuleBtn.onClick:RemoveAllListeners();
    XYSGJEntry.closeRuleBtn.onClick:AddListener(self.CloseRule);

    XYSGJEntry.ruleUpBtn.onClick:RemoveAllListeners();
    XYSGJEntry.ruleUpBtn.onClick:AddListener(self.OnUpClick);

    XYSGJEntry.ruleDownBtn.onClick:RemoveAllListeners();
    XYSGJEntry.ruleDownBtn.onClick:AddListener(self.OnDownClick);
end
function XYSGJ_Rule.CloseRule()
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);
    XYSGJ_Result.isPause = false;
    if self.lastRollState ~= -1 then
        XYSGJ_Roll.currentState = self.lastRollState;
    end
    XYSGJEntry.rulePanel.gameObject:SetActive(false);
end

function XYSGJ_Rule.OnUpClick()
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);

    self.panelID= self.panelID-1
    if self.panelID<=0 then
        self.panelID=XYSGJEntry.ruleChildPanel.transform.childCount
    end
    self.RuleChildsImage(self.panelID)
end
function XYSGJ_Rule.OnDownClick()
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);

    self.panelID= self.panelID+1
    if self.panelID>XYSGJEntry.ruleChildPanel.transform.childCount then
        self.panelID=1
    end
    self.RuleChildsImage(self.panelID)
end

function XYSGJ_Rule.RuleChildsImage(index)

    for i=1,XYSGJEntry.ruleChildPanel.childCount do
        if index==i then
            XYSGJEntry.ruleChildPanel:GetChild(i-1).gameObject:SetActive(true)
        else
            XYSGJEntry.ruleChildPanel:GetChild(i-1).gameObject:SetActive(false)
        end
        if index==1 then
            XYSGJEntry.ruleUpBtn.transform:GetComponent("Button").interactable=false
            XYSGJEntry.ruleDownBtn.transform:GetComponent("Button").interactable=true
            XYSGJEntry.ruleChildPanel.parent:Find("Image/Image").gameObject:SetActive(false)
            XYSGJEntry.ruleChildPanel.parent:Find("Image/Image1").gameObject:SetActive(true)
        elseif index==XYSGJEntry.ruleChildPanel.childCount then
            XYSGJEntry.ruleUpBtn.transform:GetComponent("Button").interactable=true
            XYSGJEntry.ruleDownBtn.transform:GetComponent("Button").interactable=false
            XYSGJEntry.ruleChildPanel.parent:Find("Image/Image").gameObject:SetActive(true)
            XYSGJEntry.ruleChildPanel.parent:Find("Image/Image1").gameObject:SetActive(false)
        else
            XYSGJEntry.ruleUpBtn.transform:GetComponent("Button").interactable=true
            XYSGJEntry.ruleDownBtn.transform:GetComponent("Button").interactable=true
            XYSGJEntry.ruleChildPanel.parent:Find("Image/Image").gameObject:SetActive(true)
            XYSGJEntry.ruleChildPanel.parent:Find("Image/Image1").gameObject:SetActive(false)
        end
    end
end