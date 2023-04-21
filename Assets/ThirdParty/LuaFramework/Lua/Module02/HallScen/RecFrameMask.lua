
RecFrameMask={}
local self =RecFrameMask
self.m_luaBeHaviour = nil
self.transform=nil

function RecFrameMask.Init(_luaBeHaviour)
    if  self.transform==nil then
        self.transform = HallScenPanel.Pool("RecFrameMask").transform;
        self.transform:SetParent(HallScenPanel.Compose.transform);
        self.transform.localPosition = Vector3.New(0, 0, 0);
        self.transform.localScale = Vector3.New(1, 1, 1);
        self.transform.localScale = Vector3.New(GameManager.ScreenRate, GameManager.ScreenRate, GameManager.ScreenRate);
    end   
    self.m_luaBeHaviour = _luaBeHaviour

    self.transform.gameObject:SetActive(true)
    self.mainPanel=self.transform:Find("mainPanel")
    self.CloseBtn=self.mainPanel:Find("CloseBtn")
    self.MyBackpackMask=self.mainPanel:Find("Close")


    self.logonType = self.mainPanel.transform:Find("logonType")
    self.nowSta = self.mainPanel.transform:Find("nowSta")

    self.BDSetPhoneBtn = self.mainPanel.transform:Find("RecFrameBtns/SetPhone/SetBtn")

    
    self.SafeBtn = self.mainPanel.transform:Find("RecFrameBtns/PasswordInfo/SetBtn").gameObject
    self.quitGameBtn = self.mainPanel.transform:Find("RecFrameBtns/quitGameBtn")

    self.musicBtn = self.mainPanel:Find("RecFrameBtns/musicBtn").gameObject;
    self.GameCBtn = self.mainPanel:Find("RecFrameBtns/GameCBtn").gameObject;

    self.SetsChildSetBtn = self.mainPanel:Find("RecFrameBtns/AccountInfo/SetBtn").gameObject;
    self.recAccountInfoName = self.mainPanel:Find("RecFrameBtns/AccountInfo/name"):GetComponent("Text")

    self.RECPasswordInfo = self.mainPanel:Find("RecFrameBtns/PasswordInfo").gameObject;
    self.RECSetPhoneInfo = self.mainPanel:Find("RecFrameBtns/SetPhone").gameObject;

    self.RecFrameDLText = self.mainPanel:Find("nowSta/Text"):GetComponent("Text")
    self.RecFramelogonType = self.mainPanel:Find("logonType/Text"):GetComponent("Text")

    -- 用户头像的点击事件
    self.m_luaBeHaviour:AddClick(self.CloseBtn.gameObject, self.RenWuPanelClose);
    self.m_luaBeHaviour:AddClick(self.MyBackpackMask.gameObject, self.RenWuPanelClose);

    self.m_luaBeHaviour:AddClick(self.musicBtn.gameObject, self.OpenMusicPanel);
    self.m_luaBeHaviour:AddClick(self.GameCBtn.gameObject, self.ClearnGame);

    self.m_luaBeHaviour:AddClick(self.BDSetPhoneBtn.gameObject, self.BDPhonePanel);
    self.m_luaBeHaviour:AddClick(self.SafeBtn.gameObject, self.SafeBtnOnClick);
    self.m_luaBeHaviour:AddClick(self.SetsChildSetBtn.gameObject, self.SetsChildSetBtnOnClick);
    self.m_luaBeHaviour:AddClick(self.quitGameBtn.gameObject, self.QuitGame);


end

function RecFrameMask.Open(_luaBeHaviour)
    if  self.transform==nil then
        self.Init(_luaBeHaviour)
    else
        self.transform.gameObject:SetActive(true)
    end
    self.RecFrameDLText.text = HallScenPanel.bdsta

    if SCPlayerInfo._29szPhoneNumber == "" then
        self.RecFramelogonType.text = "游客登录"
        self.RecFrameDLText.text="未绑定手机";
        self.RECPasswordInfo.gameObject:SetActive(false);
        self.RECSetPhoneInfo.gameObject:SetActive(true);
        self.RECSetPhoneInfo.transform.localPosition = self.RECPasswordInfo.transform.localPosition
    else
        self.RecFramelogonType.text = "账号登录"
        self.RecFrameDLText.text="已绑定手机";
        self.RECPasswordInfo.gameObject:SetActive(true);
        self.RECSetPhoneInfo.gameObject:SetActive(false);
    end
    self.recAccountInfoName.text = SCPlayerInfo._05wNickName


end

function RecFrameMask.SafeBtnOnClick()
    HallScenPanel.PlayeBtnMusic()
    changePassWordPanel.Open(self.m_luaBeHaviour)
    self.RenWuPanelClose()
end

function RecFrameMask.OpenMusicPanel()
    --HallScenPanel.PlayeBtnMusic()
    MusicPanel.Open(self.m_luaBeHaviour)
    self.RenWuPanelClose()
end
function RecFrameMask.ClearnGame()
    --self.RecFrameBtns:SetActive(false);
    GamesCleanPanel.Open(self.m_luaBeHaviour)
    self.RenWuPanelClose()
end

function RecFrameMask.SetsChildSetBtnOnClick()
    self.RenWuPanelClose()
    HallScenPanel.SetsChildSetBtnOnClick()
    Network.Close(gameSocketNumber.HallSocket);
end

function RecFrameMask.BDPhonePanel()
    HallScenPanel.PlayeBtnMusic()
    BDPhonePanel.Open(self.m_luaBeHaviour)
    self.RenWuPanelClose()
end

function RecFrameMask.RenWuPanelClose()
    HallScenPanel.PlayeBtnMusic()
    destroy(self.transform.gameObject)
    self.m_luaBeHaviour = nil
    self.transform=nil
end

function RecFrameMask.QuitGame()
    HallScenPanel.ExitGameCall()
end