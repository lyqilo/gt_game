WSZS_Rule = {};

local self = WSZS_Rule;
self.lastRollState = 0;
self.currentPos = 0;
self.totalPos = 0;

function WSZS_Rule.Init()
    self.currentPos = 0;
    self.totalPos = WSZSEntry.ruleList.content.childCount;
    WSZSEntry.ruleList.horizontalNormalizedPosition = 0;
    WSZSEntry.closeRuleBtn.onClick:RemoveAllListeners();
    WSZSEntry.closeRuleBtn.onClick:AddListener(self.CloseRule);
    WSZSEntry.leftShowBtn.onClick:RemoveAllListeners();
    WSZSEntry.leftShowBtn.onClick:AddListener(self.ClickLeftBtn);
    WSZSEntry.rightShowBtn.onClick:RemoveAllListeners();
    WSZSEntry.rightShowBtn.onClick:AddListener(self.ClickRightBtn);
    WSZSEntry.leftShowBtn.transform:Find("Image").gameObject:SetActive(false);
    WSZSEntry.leftShowBtn.interactable = false;
    WSZSEntry.ruleProgress:GetChild(self.currentPos):GetComponent("Toggle").isOn = true;
end
function WSZS_Rule.SetBeiShu()
    local twogroup = WSZSEntry.ruleList.content:GetChild(1):GetChild(0);
    local threegroup = WSZSEntry.ruleList.content:GetChild(2):GetChild(0);
    for i = 1, twogroup.childCount do
        local twocount = 0;
        local odd = WSZS_DataConfig.oddlist[i];
        for j = twogroup:GetChild(i - 1).childCount, 1, -1 do
            twocount = twocount + 1;
            local winnum = twogroup:GetChild(i - 1):GetChild(j - 1):Find("WinNum"):GetComponent("TextMeshProUGUI");
            local count = twogroup:GetChild(i - 1):GetChild(j - 1):Find("Count"):GetComponent("TextMeshProUGUI");
            if odd[twocount] > 0 then
                count.text = tostring(twocount);
                winnum.text = self.GetCustomK(odd[twocount] * WSZSEntry.CurrentChip);
            else
                count.text = "";
                winnum.text = "";
            end
        end
    end
    local BeiShuGroup = threegroup:Find("BeiShuGroup");
    local oddindex = 0;
    for i = 1, #WSZS_DataConfig.lineoddlist do
        for j = 1, #WSZS_DataConfig.lineoddlist[i] do
            oddindex = oddindex + 1;
            BeiShuGroup:GetChild(oddindex - 1):GetComponent("TextMeshProUGUI").text = self.GetCustomK(WSZS_DataConfig.lineoddlist[i][j]*WSZSEntry.CurrentChip);
        end
    end
end
function WSZS_Rule.GetCustomK(num)
    return ShortNumber(num);
end
function WSZS_Rule.ShowRule()
    WSZSEntry.menulist.gameObject:SetActive(false);
    WSZSEntry.rulePanel.gameObject:SetActive(true);
    self.SetBeiShu();
end
function WSZS_Rule.CloseRule()
    WSZS_Audio.PlaySound(WSZS_Audio.SoundList.BTN);
    WSZSEntry.rulePanel.gameObject:SetActive(false);
end
function WSZS_Rule.ClickLeftBtn()
    WSZS_Audio.PlaySound(WSZS_Audio.SoundList.BTN);
    if self.currentPos == self.totalPos - 1 then
        WSZSEntry.rightShowBtn.transform:Find("Image").gameObject:SetActive(true);
        WSZSEntry.rightShowBtn.interactable = true;
    end
    self.currentPos = self.currentPos - 1;
    WSZSEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
    WSZSEntry.ruleProgress:GetChild(self.currentPos):GetComponent("Toggle").isOn = true;
    if self.currentPos <= 0 then
        self.currentPos = 0;
        WSZSEntry.leftShowBtn.transform:Find("Image").gameObject:SetActive(false);
        WSZSEntry.leftShowBtn.interactable = false;
        return ;
    end
end
function WSZS_Rule.ClickRightBtn()
    WSZS_Audio.PlaySound(WSZS_Audio.SoundList.BTN);
    if self.currentPos == 0 then
        WSZSEntry.leftShowBtn.transform:Find("Image").gameObject:SetActive(true);
        WSZSEntry.leftShowBtn.interactable = true;
    end
    self.currentPos = self.currentPos + 1;
    WSZSEntry.ruleList.horizontalNormalizedPosition = self.currentPos / (self.totalPos - 1);
    WSZSEntry.ruleProgress:GetChild(self.currentPos):GetComponent("Toggle").isOn = true;
    if self.currentPos >= self.totalPos - 1 then
        self.currentPos = self.totalPos - 1;
        WSZSEntry.rightShowBtn.transform:Find("Image").gameObject:SetActive(false);
        WSZSEntry.rightShowBtn.interactable = false;
        return ;
    end
end