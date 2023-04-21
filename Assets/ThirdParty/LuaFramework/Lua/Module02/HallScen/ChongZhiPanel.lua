
ChongZhiPanel={}
local self =ChongZhiPanel
self.m_luaBeHaviour = nil
self.transform=nil

function ChongZhiPanel.Init(_luaBeHaviour)
    if  self.transform==nil then
        self.transform = HallScenPanel.Pool("ChongZhiPanel").transform;
        self.transform:SetParent(HallScenPanel.Compose.transform);
        self.transform.localPosition = Vector3.New(0, 0, 0);
        self.transform.localScale = Vector3.New(1,1,1);
        self.transform.localScale = Vector3.New(GameManager.ScreenRate, GameManager.ScreenRate, GameManager.ScreenRate);
    end   
    self.m_luaBeHaviour = _luaBeHaviour

    self.transform.gameObject:SetActive(true)

    self.mainPanel=self.transform:Find("mainPanel")

    self.CloseBtn=self.mainPanel:Find("CloseBtn")
    self.MyBackpackMask=self.transform:Find("zhezhao")
    self.DKCZBtn=self.mainPanel:Find("DKCZBtn")


    -- 用户头像的点击事件
    self.m_luaBeHaviour:AddClick(self.CloseBtn.gameObject, self.RenWuPanelClose);
    self.m_luaBeHaviour:AddClick(self.MyBackpackMask.gameObject, self.RenWuPanelClose);
    self.m_luaBeHaviour:AddClick(self.DKCZBtn.gameObject, self.OnClickDKCZ);
end

function ChongZhiPanel.Open(_luaBeHaviour)
    if  self.transform==nil then
        self.Init(_luaBeHaviour)
    else
        self.transform.gameObject:SetActive(true)
    end
end

function ChongZhiPanel.RenWuPanelClose()
    HallScenPanel.PlayeBtnMusic()
    destroy(self.transform.gameObject)
    self.m_luaBeHaviour = nil
    self.transform=nil
end

function ChongZhiPanel.OnClickDKCZ(args)
    DuiHuanPanel.Init(self.m_luaBeHaviour);
    --PersonalInfoSystem.Creatobj(HallScenPanel.Pool("DuiHuanPanel"))
    ChongZhiPanel.RenWuPanelClose()
end