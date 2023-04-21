FXGZ_Rule = {};

local self = FXGZ_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;
self.tip = nil;

function FXGZ_Rule.Init()
    self.currentPos = 0;
    self.totalPos = FXGZEntry.ruleList.content.childCount;
    FXGZEntry.ruleList.horizontalNormalizedPosition = 0;
    FXGZEntry.closeRuleBtn.onClick:RemoveAllListeners();
    FXGZEntry.closeRuleBtn.onClick:AddListener(self.CloseRule);
    FXGZEntry.leftShowBtn.onClick:RemoveAllListeners();
    FXGZEntry.leftShowBtn.onClick:AddListener(self.ClickLeftBtn);
    FXGZEntry.rightShowBtn.onClick:RemoveAllListeners();
    FXGZEntry.rightShowBtn.onClick:AddListener(self.ClickRightBtn);
    FXGZEntry.leftShowBtn.interactable = false;
    FXGZEntry.ruleProgress:GetChild(self.currentPos):GetComponent("Toggle").isOn = true;
    self.tip = FXGZEntry.rulePanel:Find("Content/Tip");
    self.tip.gameObject:SetActive(false);
end
function FXGZ_Rule.SetBeiShu()
    local jackpot = FXGZEntry.ruleList.content:GetChild(0):Find("Jackpot/Score");
    for i = jackpot.childCount, 1, -1 do
        jackpot:GetChild(i - 1):GetComponent("TextMeshProUGUI").text = self.GetCustomK(FXGZ_DataConfig.oddList[i][10] * FXGZEntry.CurrentChip);
    end
    local othergroup = FXGZEntry.ruleList.content:GetChild(2);
    for i = 1, othergroup.childCount do
        local child = othergroup:GetChild(i - 1):Find("Score");
        local count = othergroup:GetChild(i - 1):Find("Count");
        for j = 1, child.childCount do
            count:GetChild(j - 1):GetComponent("TextMeshProUGUI").text = tostring(6 - j);
            child:GetChild(j - 1):GetComponent("TextMeshProUGUI").text = self.GetCustomK(FXGZ_DataConfig.oddList[j][i] * FXGZEntry.CurrentChip);
        end
    end
end
function FXGZ_Rule.GetCustomK(num)
    local n = tonumber(num) / 1000000;
    if n > 1 then
        return tostring(n) .. "M";
    else
        n = tonumber(num) / 1000;
        if n > 1 then
            return tostring(n) .. "K";
        else
            return tostring(num);
        end
    end
end
function FXGZ_Rule.ShowRule()
    FXGZEntry.closeGame.gameObject:SetActive(false);
    FXGZEntry.rulePanel.gameObject:SetActive(true);
    self.SetBeiShu();
end
function FXGZ_Rule.CloseRule()
    FXGZEntry.closeGame.gameObject:SetActive(true);
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
    FXGZEntry.rulePanel.gameObject:SetActive(false);
end
function FXGZ_Rule.ClickLeftBtn()
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
    if self.currentPos == self.totalPos - 1 then
        FXGZEntry.rightShowBtn.interactable = true;
    end
    self.currentPos = self.currentPos - 1;
    FXGZEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
    FXGZEntry.ruleProgress:GetChild(self.currentPos):GetComponent("Toggle").isOn = true;
    if self.currentPos == 2 then
        self.tip.gameObject:SetActive(true);
    else
        self.tip.gameObject:SetActive(false);
    end
    if self.currentPos <= 0 then
        self.currentPos = 0;
        FXGZEntry.leftShowBtn.interactable = false;
        return ;
    end
end
function FXGZ_Rule.ClickRightBtn()
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
    if self.currentPos == 0 then
        FXGZEntry.leftShowBtn.interactable = true;
    end
    self.currentPos = self.currentPos + 1;
    FXGZEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
    FXGZEntry.ruleProgress:GetChild(self.currentPos):GetComponent("Toggle").isOn = true;

    if self.currentPos == 2 then
        self.tip.gameObject:SetActive(true);
    else
        self.tip.gameObject:SetActive(false);
    end
    if self.currentPos >= self.totalPos - 1 then
        self.currentPos = self.totalPos - 1;
        FXGZEntry.rightShowBtn.interactable = false;
        return ;
    end
end