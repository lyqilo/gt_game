YGBH_Rule = {};

local self = YGBH_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;
self.custom = {};
function YGBH_Rule.Init()
    self.zzb = YGBHEntry.ruleList.content:Find("One/ZZB");
    self.swk = YGBHEntry.ruleList.content:Find("One/SWK");
    self.other = YGBHEntry.ruleList.content:Find("One/Other");
    self.ld = YGBHEntry.ruleList.content:Find("One/LD");
    self.zm = YGBHEntry.ruleList.content:Find("One/Zimu");
    self.sz = YGBHEntry.ruleList.content:Find("One/Shuzi");
    self.scatter = YGBHEntry.ruleList.content:Find("Two/Scatter");
    self.wild = YGBHEntry.ruleList.content:Find("Two/Wild");
    self.custom = {};
    table.insert(self.custom, self.zzb);
    table.insert(self.custom, self.swk);
    table.insert(self.custom, self.other);
    table.insert(self.custom, self.ld);
    table.insert(self.custom, self.zm);
    table.insert(self.custom, self.sz);
    table.insert(self.custom, self.scatter);
    table.insert(self.custom, self.wild);
end
function YGBH_Rule.SetBeiShu()
    for i = 1, #self.custom do
        local count = 0;
        for j = 1, #YGBH_DataConfig.BeiLVTable do
            if YGBH_DataConfig.BeiLVTable[j][i] ~= 0 then
                count = count + 1;
                self.custom[i]:GetChild(count - 1):GetComponent("Text").text = tostring(#YGBH_DataConfig.BeiLVTable - j + 2) .. "  " .. self.GetCustomK(YGBH_DataConfig.BeiLVTable[j][i] * YGBHEntry.CurrentChip);
            end
        end
    end
end
function YGBH_Rule.GetCustomK(num)
    local n = tonumber(num) / 1000;
    if n <= 1 then
        return tostring(num);
    else
        return tostring(n) .. "K";
    end
end
function YGBH_Rule.ShowRule()
    YGBHEntry.CloseMenuCall();
    self.SetBeiShu();
    if not YGBH_Result.isShow then
        self.lastRollState = YGBH_Roll.currentState;
        YGBH_Roll.currentState = 0;
    else
        self.lastRollState = -1;
        YGBH_Result.isPause = true;
    end
    self.currentPos = 0;
    self.totalPos = YGBHEntry.ruleList.content.childCount;
    YGBHEntry.ruleList.horizontalNormalizedPosition = 0;
    YGBHEntry.rulePanel.gameObject:SetActive(true);
    YGBHEntry.closeRuleBtn.onClick:RemoveAllListeners();
    YGBHEntry.closeRuleBtn.onClick:AddListener(self.CloseRule);
    YGBHEntry.leftShowBtn.onClick:RemoveAllListeners();
    YGBHEntry.leftShowBtn.onClick:AddListener(self.ClickLeftBtn);
    YGBHEntry.rightShowBtn.onClick:RemoveAllListeners();
    YGBHEntry.rightShowBtn.onClick:AddListener(self.ClickRightBtn);

end
function YGBH_Rule.CloseRule()
    YGBH_Audio.PlaySound(YGBH_Audio.SoundList.BTN);
    YGBH_Result.isPause = false;
    if self.lastRollState ~= -1 then
        YGBH_Roll.currentState = self.lastRollState;
    end
    YGBHEntry.rulePanel.gameObject:SetActive(false);
end
function YGBH_Rule.ClickLeftBtn()
    YGBH_Audio.PlaySound(YGBH_Audio.SoundList.BTN);
    self.currentPos = self.currentPos - 1;
    if self.currentPos < 0 then
        self.currentPos = self.totalPos - 1;
    end
    YGBHEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end
function YGBH_Rule.ClickRightBtn()
    YGBH_Audio.PlaySound(YGBH_Audio.SoundList.BTN);
    self.currentPos = self.currentPos + 1;
    if self.currentPos > self.totalPos - 1 then
        self.currentPos = 0;
    end
    YGBHEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
end