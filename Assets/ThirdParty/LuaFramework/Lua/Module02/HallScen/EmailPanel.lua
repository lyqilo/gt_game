EmailPanel={}
local self = EmailPanel

self.m_luaBeHaviour = nil
self.transform=nil

function EmailPanel.Init(_luaBeHaviour)
    if  self.transform==nil then
        self.transform = HallScenPanel.Pool("EmailPanel").transform;
        self.transform:SetParent(HallScenPanel.Compose.transform);
        self.transform.localPosition = Vector3.New(0, 0, 0);
        self.transform.localScale = Vector3.New(1,1,1);
        self.transform.localScale = Vector3.New(GameManager.ScreenRate, GameManager.ScreenRate, GameManager.ScreenRate);
    end   
    self.m_luaBeHaviour = _luaBeHaviour

    self.transform.gameObject:SetActive(true)

    self.CloseBtn=self.transform:Find("mainPanel/CloseBtn")
    self.CloseMaskBtn=self.transform:Find("zhezhao")
    self.QBXXBtn=self.transform:Find("mainPanel/left/QBXXBtn")
    self.WJXXBtn=self.transform:Find("mainPanel/left/WJXXBtn")
    self.XTXXBtn=self.transform:Find("mainPanel/left/XTXXBtn")

    self.CXBtn=self.transform:Find("mainPanel/CXBtn")
    self.SCBtn=self.transform:Find("mainPanel/SCBtn")
    self.CXInput=self.transform:Find("mainPanel/CXInput"):GetComponent("InputField")


    self.m_luaBeHaviour:AddClick(self.CloseBtn.gameObject, self.EmailPanelClose);
    self.m_luaBeHaviour:AddClick(self.CloseMaskBtn.gameObject, self.EmailPanelClose);
    self.m_luaBeHaviour:AddClick(self.QBXXBtn.gameObject, self.EmailPanelleftBtn);
    self.m_luaBeHaviour:AddClick(self.WJXXBtn.gameObject, self.EmailPanelleftBtn);
    self.m_luaBeHaviour:AddClick(self.XTXXBtn.gameObject, self.EmailPanelleftBtn);

    self.m_luaBeHaviour:AddClick(self.CXBtn.gameObject, self.EmailPanelCX);
    self.m_luaBeHaviour:AddClick(self.SCBtn.gameObject, self.EmailPanellSCBtn);


end

function EmailPanel.Open(_luaBeHaviour)
    if  self.transform==nil then
        self.Init(_luaBeHaviour)
    else
        self.transform.gameObject:SetActive(true)
    end

    self.QBXXBtn:GetComponent("Button").interactable = false
    self.QBXXBtn:Find("TextB").gameObject:SetActive(false)
    self.QBXXBtn:Find("TextG").gameObject:SetActive(true)

    self.WJXXBtn:GetComponent("Button").interactable = true
    self.WJXXBtn:Find("TextB").gameObject:SetActive(true)
    self.WJXXBtn:Find("TextG").gameObject:SetActive(false)   

    self.XTXXBtn:GetComponent("Button").interactable = true
    self.XTXXBtn:Find("TextB").gameObject:SetActive(true)
    self.XTXXBtn:Find("TextG").gameObject:SetActive(false) 
    self.CXInput.text=""

end

function EmailPanel.EmailPanellSCBtn()
    HallScenPanel.PlayeBtnMusic()
    
end

function EmailPanel.EmailPanelleftBtn(args)
    HallScenPanel.PlayeBtnMusic()

    if args.name=="QBXXBtn" then
        self.QBXXBtn:GetComponent("Button").interactable = false
        self.QBXXBtn:Find("TextB").gameObject:SetActive(false)
        self.QBXXBtn:Find("TextG").gameObject:SetActive(true)
    
        self.WJXXBtn:GetComponent("Button").interactable = true
        self.WJXXBtn:Find("TextB").gameObject:SetActive(true)
        self.WJXXBtn:Find("TextG").gameObject:SetActive(false)   
    
        self.XTXXBtn:GetComponent("Button").interactable = true
        self.XTXXBtn:Find("TextB").gameObject:SetActive(true)
        self.XTXXBtn:Find("TextG").gameObject:SetActive(false) 
    elseif args.name=="WJXXBtn" then
        self.QBXXBtn:GetComponent("Button").interactable = true
        self.QBXXBtn:Find("TextB").gameObject:SetActive(true)
        self.QBXXBtn:Find("TextG").gameObject:SetActive(false)
    
        self.WJXXBtn:GetComponent("Button").interactable = false
        self.WJXXBtn:Find("TextB").gameObject:SetActive(false)
        self.WJXXBtn:Find("TextG").gameObject:SetActive(true)   
    
        self.XTXXBtn:GetComponent("Button").interactable = true
        self.XTXXBtn:Find("TextB").gameObject:SetActive(true)
        self.XTXXBtn:Find("TextG").gameObject:SetActive(false) 
    elseif args.name=="XTXXBtn" then
        self.QBXXBtn:GetComponent("Button").interactable = true
        self.QBXXBtn:Find("TextB").gameObject:SetActive(true)
        self.QBXXBtn:Find("TextG").gameObject:SetActive(false)
    
        self.WJXXBtn:GetComponent("Button").interactable = true
        self.WJXXBtn:Find("TextB").gameObject:SetActive(true)
        self.WJXXBtn:Find("TextG").gameObject:SetActive(false)   
    
        self.XTXXBtn:GetComponent("Button").interactable = false
        self.XTXXBtn:Find("TextB").gameObject:SetActive(false)
        self.XTXXBtn:Find("TextG").gameObject:SetActive(true) 
    end
end

function EmailPanel.EmailPanelCX(args)
    HallScenPanel.PlayeBtnMusic()

    self.CXInput.text=""
    MessageBox.CreatGeneralTipsPanel("没有查询到");

end

function EmailPanel.EmailPanelClose(args)
    HallScenPanel.PlayeBtnMusic()

    destroy(self.transform.gameObject)
    self.m_luaBeHaviour = nil
    self.transform=nil
end