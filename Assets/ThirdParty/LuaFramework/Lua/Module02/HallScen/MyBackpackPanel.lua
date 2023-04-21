
MyBackpackPanel={}
local self =MyBackpackPanel
self.m_luaBeHaviour = nil
self.transform=nil

function MyBackpackPanel.Init(_luaBeHaviour)
    if  self.transform==nil then
        self.transform = HallScenPanel.Pool("MyBackpack").transform;
        self.transform:SetParent(HallScenPanel.Compose.transform);
        self.transform.localPosition = Vector3.New(0, 0, 0);
        self.transform.localScale = Vector3.New(1, 1, 1);
    end   
    self.m_luaBeHaviour = _luaBeHaviour

    self.transform.gameObject:SetActive(true)

    self.mainPanel=self.transform:Find("mainPanel")

    self.MyBackpack=self.mainPanel:Find("CloseBtn")
    self.MyBackpackMask=self.transform:Find("zhezhao")
    --self.RWQWBtn=self.mainPanel:Find("Image/Button")

    self.BeiB=self.mainPanel:Find("left/BeiB")
    self.LiB=self.mainPanel:Find("left/LiB")

    self.BB=self.mainPanel:Find("right/BB")

    -- 用户头像的点击事件
    self.m_luaBeHaviour:AddClick(self.MyBackpack.gameObject, self.RenWuPanelClose);
    self.m_luaBeHaviour:AddClick(self.MyBackpackMask.gameObject, self.RenWuPanelClose);
    -- self.m_luaBeHaviour:AddClick(self.BeiB.gameObject, self.leftBtnClick);
    -- self.m_luaBeHaviour:AddClick(self.LiB.gameObject, self.leftBtnClick);
    for i=1,self.BB.childCount do
        local go1=self.BB:GetChild(i-1):Find("Button")
        self.m_luaBeHaviour:AddClick(go1.gameObject,self.RightBtnClck)
    end

end

function MyBackpackPanel.Open(_luaBeHaviour)
    if  self.transform==nil then
        self.Init(_luaBeHaviour)
    else
        self.transform.gameObject:SetActive(true)
    end
    -- self.BeiB:GetComponent("Button").interactable = false
    -- self.BeiB:Find("TextB").gameObject:SetActive(false)
    -- self.BeiB:Find("TextG").gameObject:SetActive(true)

    -- self.LiB:GetComponent("Button").interactable = true
    -- self.LiB:Find("TextB").gameObject:SetActive(true)
    -- self.LiB:Find("TextG").gameObject:SetActive(false)  
    self.BB.gameObject:SetActive(true)
end

function MyBackpackPanel.RenWuPanelClose()

    destroy(self.transform.gameObject)
    self.m_luaBeHaviour = nil
    self.transform=nil
    --self.:SetActive(false)
end

function MyBackpackPanel.leftBtnClick(args)
    if args.name=="BeiB" then
        self.BeiB:GetComponent("Button").interactable = false
        self.BeiB:Find("TextB").gameObject:SetActive(false)
        self.BeiB:Find("TextG").gameObject:SetActive(true)

        self.LiB:GetComponent("Button").interactable = true
        self.LiB:Find("TextB").gameObject:SetActive(true)
        self.LiB:Find("TextG").gameObject:SetActive(false)   
        self.BB.gameObject:SetActive(true)

    elseif args.name=="LiB" then
        self.BeiB:GetComponent("Button").interactable = true
        self.BeiB:Find("TextB").gameObject:SetActive(true)
        self.BeiB:Find("TextG").gameObject:SetActive(false)
    
        self.LiB:GetComponent("Button").interactable = false
        self.LiB:Find("TextB").gameObject:SetActive(false)
        self.LiB:Find("TextG").gameObject:SetActive(true)   
        self.BB.gameObject:SetActive(false)

    end
end

function MyBackpackPanel.RightBtnClck(args)
    --if  args.transform.parent.name=="1" then
    --    DuiHuanPanel.Open(self.m_luaBeHaviour,"1")
    --elseif  args.transform.parent.name=="2" then
    --    DuiHuanPanel.Open(self.m_luaBeHaviour,"1")
    --end
   self.RenWuPanelClose()

    --self.transform.gameObject:SetActive(false)
end