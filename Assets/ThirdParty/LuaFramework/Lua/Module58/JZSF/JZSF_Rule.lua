JZSF_Rule = {};

local self = JZSF_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;
self.panelID=1

function JZSF_Rule.ShowRule()
    JZSFEntry.CloseMenuCall();
    -- if not JZSF_Result.isShow then
    --     self.lastRollState = JZSF_Roll.currentState;
    --     JZSF_Roll.currentState = 0;
    -- else
    --     self.lastRollState = -1;
    --     JZSF_Result.isPause = true;
    -- end
    self.currentPos = 0;
    self.panelID=1
    self.totalPos = JZSFEntry.ruleList.content.childCount;
    JZSFEntry.ruleList.horizontalNormalizedPosition = 0;
    JZSFEntry.rulePanel.gameObject:SetActive(true);

    JZSFEntry.closeRuleBtn.onClick:RemoveAllListeners();
    JZSFEntry.closeRuleBtn.onClick:AddListener(self.CloseRule);
    
    JZSFEntry.leftShowBtn.onClick:RemoveAllListeners();
    JZSFEntry.leftShowBtn.onClick:AddListener(self.ClickLeftBtn);
    
    JZSFEntry.rightShowBtn.onClick:RemoveAllListeners();
    JZSFEntry.rightShowBtn.onClick:AddListener(self.ClickRightBtn);

end
function JZSF_Rule.CloseRule()
    --JZSF_Audio.PlaySound(JZSF_Audio.SoundList.BTN);
    JZSFEntry.rulePanel.gameObject:SetActive(false);
end

function JZSF_Rule.ClickLeftBtn()
    --JZSF_Audio.PlaySound(JZSF_Audio.SoundList.BTN);
    self.panelID=self.panelID-1
    if self.panelID<=0 then
        self.panelID=JZSFEntry.ruleList.transform:GetChild(0):GetChild(0).childCount
    end
    self.RuleChildsImage(self.panelID)

end
function JZSF_Rule.ClickRightBtn()
    --JZSF_Audio.PlaySound(JZSF_Audio.SoundList.BTN);
    self.panelID= self.panelID+1
    if self.panelID>JZSFEntry.ruleList.transform:GetChild(0):GetChild(0).childCount then
        self.panelID=1
    end
    self.RuleChildsImage(self.panelID)
end

function JZSF_Rule.RuleChildsImage(index)
    for i=1,JZSFEntry.ruleList.transform:GetChild(0):GetChild(0).childCount do
        if index==i then
            JZSFEntry.ruleList.transform:GetChild(0):GetChild(0):GetChild(i-1).gameObject:SetActive(true)
        else
            JZSFEntry.ruleList.transform:GetChild(0):GetChild(0):GetChild(i-1).gameObject:SetActive(false)
        end
    end
    -- if index==1 then
    --     JZSFEntry.leftShowBtn.transform.gameObject:SetActive(false)
    --     JZSFEntry.rightShowBtn.transform.gameObject:SetActive(true)
    --     JZSFEntry.leftShowBtn.transform:GetComponent("Button").interactable=false
    --     JZSFEntry.rightShowBtn.transform:GetComponent("Button").interactable=true
    -- elseif index==JZSFEntry.ruleList.transform:GetChild(0):GetChild(0).childCount then
    --     JZSFEntry.leftShowBtn.transform.gameObject:SetActive(true)
    --     JZSFEntry.rightShowBtn.transform.gameObject:SetActive(false)
    --     JZSFEntry.leftShowBtn.transform:GetComponent("Button").interactable=true
    --     JZSFEntry.rightShowBtn.transform:GetComponent("Button").interactable=false
    -- else
    --     JZSFEntry.leftShowBtn.transform.gameObject:SetActive(true)
    --     JZSFEntry.rightShowBtn.transform.gameObject:SetActive(true)
    --     JZSFEntry.leftShowBtn.transform:GetComponent("Button").interactable=true
    --     JZSFEntry.rightShowBtn.transform:GetComponent("Button").interactable=true
    -- end
end