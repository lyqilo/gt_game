RenWuPanel={}
local self = RenWuPanel

self.m_luaBeHaviour = nil
self.transform=nil

function RenWuPanel.Init(_luaBeHaviour)
    if  self.transform==nil then
        self.transform = HallScenPanel.Pool("RenWuPanel").transform;
        self.transform:SetParent(HallScenPanel.Compose.transform);
        self.transform.localPosition = Vector3.New(0, 0, 0);
        self.transform.localScale = Vector3.New(1,1,1);
        self.transform.localScale = Vector3.New(GameManager.ScreenRate, GameManager.ScreenRate, GameManager.ScreenRate);
    end   
    self.m_luaBeHaviour = _luaBeHaviour

    self.transform.gameObject:SetActive(true)

    self.mainPanel=self.transform:Find("mainPanel")

    self.renWuPanelCloseBtn=self.mainPanel:Find("CloseBtn")
    self.renWuPanelCloseMaskBtn=self.transform:Find("zhezhao")
    self.RenWuPanelXX=self.mainPanel:Find("Image")
    self.RenWuPanelText=self.mainPanel:Find("Text")

    --local _luaBehaviour = transform:GetComponent('LuaBehaviour');

    self.RWQWBtn=self.mainPanel:Find("Image/Button")

    -- 用户头像的点击事件
    self.m_luaBeHaviour:AddClick(self.renWuPanelCloseBtn.gameObject, self.RenWuPanelClose);
    self.m_luaBeHaviour:AddClick(self.renWuPanelCloseMaskBtn.gameObject, self.RenWuPanelClose);
    self.m_luaBeHaviour:AddClick(self.RWQWBtn.gameObject, self.RenWuPanelQW);

    --self.m_luaBeHaviour:AddClick(self.SCBtn.gameObject, self.EmailPanelleftBtn);
end

function RenWuPanel.Open(_luaBeHaviour)
    if  self.transform==nil then
        self.Init(_luaBeHaviour)
    else
        self.transform.gameObject:SetActive(true)
    end

    if tonumber(SCPlayerInfo._29szPhoneNumber) and string.len(SCPlayerInfo._29szPhoneNumber) == 11 then
        self.RenWuPanelXX.gameObject:SetActive(false)
        self.RenWuPanelText.gameObject:SetActive(true)

    else
        self.RenWuPanelXX.gameObject:SetActive(true)
        self.RenWuPanelText.gameObject:SetActive(false)

    end

end

function RenWuPanel.RenWuPanelClose()
    HallScenPanel.PlayeBtnMusic();

    destroy(self.transform.gameObject)

    self.m_luaBeHaviour = nil
    self.transform=nil
end

function RenWuPanel.RenWuPanelQW()
    BDPhonePanel.Open(self.m_luaBeHaviour)

    destroy(self.transform.gameObject)

    self.m_luaBeHaviour = nil
    self.transform=nil
end