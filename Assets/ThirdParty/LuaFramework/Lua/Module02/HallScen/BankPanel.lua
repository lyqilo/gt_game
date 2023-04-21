BankPanel = {}
local self = BankPanel
local _luaBeHaviour = nil
self.m_luaBeHaviour = nil
self.bankTime = 0
self.pwd = nil
self.olduserid = 0
self.PanelID=1
-- ===========================================银行信息系统======================================
function BankPanel.Open(data)
    log("==============================银行信息==================================")
    logTable(data)
    self._bHasStrongBoxPassword = data[1]
    -- 进入保险箱
    if HallScenPanel.MidCloseBtn == self.CloseBtnOnClick then
        return
    end
    if HallScenPanel.MidCloseBtn ~= nil then
        HallScenPanel.MidCloseBtn()
        HallScenPanel.MidCloseBtn = nil
    end
    if self.BankPanelObj == nil then
        self.BankPanelObj = "obj"
        self.OnCreacterChildPanel_BankPanel(HallScenPanel.Pool("BankPanel"))
    end
    HallScenPanel.isOpenBank = false;
    self.InputPwdGetGold();
end

-- 创建UI的子面板_聚宝盆
function BankPanel.OnCreacterChildPanel_BankPanel(prefab)
    local go = prefab
    go.transform:SetParent(HallScenPanel.Compose.transform)
    go.name = "BankPanel"
    go.transform.localScale = Vector3.New(1, 1, 1)
    go.transform.localScale = Vector3.New(GameManager.ScreenRate, GameManager.ScreenRate, GameManager.ScreenRate);
    go.transform.localPosition = Vector3.New(900, 0, -500)
    self.Bg = go.transform:Find("Bg").gameObject
    self.Bg.transform.localScale = Vector3.New(1, 1, 1)
    self.BankPanelObj = go
    HallScenPanel.LastPanel = self.BankPanelObj
    HallScenPanel.SetXiaoGuo(self.BankPanelObj)
    self.Init(self.BankPanelObj, HallScenPanel.LuaBehaviour)
    go = nil
    HallScenPanel.MidCloseBtn = self.CloseBtnOnClick
    HallScenPanel.SetBtnInter(true)
end

function BankPanel.ShowInfo_Info(prefab)
    local go = prefab
    go.transform:SetParent(self.BankPanelObj.transform)
    go.name = "Bg"
    go.transform.localScale = Vector3.New(1, 1, 1)
    go.transform.localPosition = Vector3.New(0, 0, 0)
    self.Bg = go
end

function BankPanel.Init(obj, luaBeHaviour)
    _luaBeHaviour = luaBeHaviour
    self.m_luaBeHaviour = luaBeHaviour
    local t = obj.transform
    -- 赋值自己
    self.BankPanelObj = obj
    self.bg = t:Find("Bg")
    self.CloseBtn = t:Find("Bg/CloseBtn").gameObject
    self.CloseMaskBtn = t:Find("Image").gameObject
    -- 设置银行密码
    self.Newpwd = self.bg:Find("NewPwd").gameObject
    self.pwdinputfiel = self.bg:Find("NewPwd/pwd/InputField").gameObject
    self.surepwdinputfiel = self.bg:Find("NewPwd/surepwd/InputField").gameObject
    self.SureSetPwdBtn = self.bg:Find("NewPwd/SureBtn").gameObject
    self.BgLen = self.bg:Find("TwoBg/bg").gameObject

    -- 存取界面
    self.GetAndSave = self.bg:Find("GetAndSave").gameObject
    self.BankerBg = self.bg:Find("GetAndSave/Bg").gameObject
    self.BankerBg:SetActive(true)
    self.GoldText = self.bg:Find("GetAndSave/Bg/Gold/Text").gameObject
    self.SaveGoldText = self.bg:Find("GetAndSave/Bg/SaveGold/Text").gameObject
    self.setgoldInputField = self.bg:Find("GetAndSave/Bg/Group/SetGold/InputField").gameObject
    local a = self.setgoldInputField.transform:GetComponent("InputField")
    a.contentType = UnityEngine.UI.InputField.ContentType.IntegerNumber
    self.allgoldBtn = self.bg:Find("GetAndSave/Bg/AllBtn"):GetComponent("Button");

    self.getgoldPWInputField = self.bg:Find("GetAndSave/Bg/Group/BankPw/InputField").gameObject

    self.setgoldUpperText = self.bg:Find("GetAndSave/Bg/Group/UpperGold/Desc"):GetComponent("Text");
    self.resetPWBtn = self.bg:Find("GetAndSave/Bg/ChangePasswordBtn"):GetComponent("Button");
    self.resetSetGoldBtn = self.bg:Find("GetAndSave/Bg/RestBtn"):GetComponent("Button");

    self.SaveGoldBtn = self.bg:Find("GetAndSave/Bg/SaveBtn").gameObject
    self.GetGoldBtn = self.bg:Find("GetAndSave/Bg/GetBtn").gameObject
    self.ResetGoldBtn = self.bg:Find("GetAndSave/Bg/SaveBtn").gameObject
    -- 存
    self.BankBtn = self.bg:Find("GetAndSave/Group/BankBtn").gameObject
    self.BankBtn:GetComponent("Button").interactable = false
    self.BankBtn.transform:Find("Image").gameObject:SetActive(true)
    self.BankBtn.transform:Find("name").gameObject:SetActive(false)
    self.BankBtn.transform:Find("name1").gameObject:SetActive(true)
    --取
    self.BankGetBtn = self.bg:Find("GetAndSave/Group/GetBtn").gameObject
    self.BankGetBtn:GetComponent("Button").interactable = true
    self.BankGetBtn.transform:Find("Image").gameObject:SetActive(false)
    self.BankGetBtn.transform:Find("name").gameObject:SetActive(true)
    self.BankGetBtn.transform:Find("name1").gameObject:SetActive(false)
    -- 查询
    self.QueryBtn = self.bg:Find("GetAndSave/Group/QueryBtn").gameObject
    self.QueryBtn:GetComponent("Button").interactable = true
    self.QueryBtn.transform:Find("Image").gameObject:SetActive(false)
    self.QueryBtn.transform:Find("name").gameObject:SetActive(true)
    self.QueryBtn.transform:Find("name1").gameObject:SetActive(false)
    -- 转账
    self.TransferBtn = self.bg:Find("GetAndSave/Group/TransferBtn").gameObject
    self.TransferBtn:GetComponent("Button").interactable = true
    self.TransferBtn.transform:Find("Image").gameObject:SetActive(false)
    self.TransferBtn.transform:Find("name").gameObject:SetActive(true)
    self.TransferBtn.transform:Find("name1").gameObject:SetActive(false)
    --赠送卡
    self.LPKBtn=self.bg:Find("GetAndSave/Group/LPKBtn").gameObject
    self.LPKBtn:SetActive(SCPlayerInfo.IsVIP == 1);
    self.LPKBtn:GetComponent("Button").interactable = true
    self.LPKBtn.transform:Find("Image").gameObject:SetActive(false)
    self.LPKBtn.transform:Find("name").gameObject:SetActive(true)
    self.LPKBtn.transform:Find("name1").gameObject:SetActive(false)
    -- 转账界面
    self.TransferBg = self.bg:Find("Transfer").gameObject
    self.TransferBg:SetActive(false)
    -- 查询界面
    self.QueryBg = self.bg:Find("QueryPanel").gameObject
    self.QueryBg:SetActive(false)
    if SCPlayerInfo.IsVIP == 1 then
        self.QueryBtn:SetActive(true);
    else
        self.QueryBtn:SetActive(false);
    end

    log(tostring(self.resetPWBtn == nil));
    self.resetSetGoldBtn.onClick:RemoveAllListeners();
    self.resetSetGoldBtn.onClick:AddListener(self.OnClickResetSetGoldCall);
    self.resetPWBtn.onClick:RemoveAllListeners();
    self.resetPWBtn.onClick:AddListener(self.OnClickResetPWCall);
    --
    -- 修改密码界面
    self.ResetPwdBg = self.bg:Find("UpdatePwd").gameObject
    self.ResetPwdBg:SetActive(false)
    self.Reset_phone = self.ResetPwdBg.transform:Find("phone/Text").gameObject
    if tonumber(SCPlayerInfo._29szPhoneNumber) and string.len(SCPlayerInfo._29szPhoneNumber) == 11 then
        local str = string.sub(SCPlayerInfo._29szPhoneNumber, 0, 3)
        local str1 = string.sub(SCPlayerInfo._29szPhoneNumber, 8, string.len(SCPlayerInfo._29szPhoneNumber))
        self.Reset_phone:GetComponent("Text").text = str .. "****" .. str1
    end
    self.Reset_pwd = self.ResetPwdBg.transform:Find("pwd/InputField").gameObject
    self.Reset_repwd = self.ResetPwdBg.transform:Find("surepwd/InputField").gameObject
    self.Reset_code = self.ResetPwdBg.transform:Find("code/InputField").gameObject
    self.Reset_codebtn = self.ResetPwdBg.transform:Find("codebtn").gameObject
    self.Reset_updatebtn = self.ResetPwdBg.transform:Find("ResetBtn").gameObject
    self.Reset_quitbtn = self.ResetPwdBg.transform:Find("BackBtn").gameObject
    -- 取款输入密码
    self.InputPwd = self.bg:Find("InputPwd").gameObject
    self.InputPwd_ReSetBtn = self.InputPwd.transform:Find("ReSetBtn").gameObject
    self.InputPwd:SetActive(false)
    self.InputPwd.transform.localPosition = Vector3.New(800, 0, 0)
    self.GetGoldPwdInputField = self.bg:Find("InputPwd/InputField").gameObject
    local partxt = newobject(self.GetGoldPwdInputField.transform:Find("Placeholder").gameObject)
    partxt.transform:SetParent(self.GetGoldPwdInputField.transform)
    partxt.transform:GetComponent("RectTransform").sizeDelta = self.GetGoldPwdInputField.transform:Find("Placeholder"):GetComponent("RectTransform").sizeDelta
    partxt.transform.localPosition = self.GetGoldPwdInputField.transform:Find("Placeholder").localPosition
    partxt.transform.localRotation = self.GetGoldPwdInputField.transform:Find("Placeholder").localRotation
    partxt.transform.localScale = self.GetGoldPwdInputField.transform:Find("Placeholder").localScale
    partxt.name = "GoldPwdTitle"
    self.GetGoldPwdBtn = self.bg:Find("InputPwd/Button").gameObject

    _luaBeHaviour:AddClick(self.BankBtn, self.BankBtnOnClick)
    _luaBeHaviour:AddClick(self.BankGetBtn, self.BankGetBtnOnClick)
    _luaBeHaviour:AddClick(self.TransferBtn, self.TransferBtnOnClick)
    _luaBeHaviour:AddClick(self.QueryBtn, self.QueryBtnOnClick)
    _luaBeHaviour:AddClick(self.LPKBtn, self.LPKBtnOnClick)

    _luaBeHaviour:AddClick(self.CloseBtn, self.CloseBtnOnClick)
    _luaBeHaviour:AddClick(self.CloseMaskBtn, self.CloseBtnOnClick)
    _luaBeHaviour:AddClick(self.SureSetPwdBtn, self.SetPwdBtnOnClick)
    _luaBeHaviour:AddClick(self.SaveGoldBtn, self.SaveGoldBtnOnClick)
    _luaBeHaviour:AddClick(self.GetGoldBtn, self.GetGoldBtnOnClick)
    _luaBeHaviour:AddClick(self.GetGoldPwdBtn, self.InputPwdGetGold)
    _luaBeHaviour:AddClick(self.InputPwd_ReSetBtn, self.UpdateOnClick)
    _luaBeHaviour:AddClick(self.Reset_codebtn, self.UpdatePwdCodeBtn)
    _luaBeHaviour:AddClick(self.Reset_updatebtn, self.UpdateResetBtnOnClick)
    _luaBeHaviour:AddClick(self.Reset_quitbtn, self.UpdateBackOnClick)
    _luaBeHaviour:AddEndEditEvent(self.setgoldInputField.gameObject, self.InputOverNum);

    if self._bHasStrongBoxPassword == 0 then
        logError("没有实用过保险箱")
        --self.Newpwd:SetActive(true)
        --self.GetAndSave:SetActive(false)
        --self.Newpwd.transform.localPosition = Vector3.New(0, 0, 0)
        --self.GetAndSave.transform.localPosition = Vector3.New(800, 0, 0)

        local buffer = ByteBuffer.New()
        buffer:WriteUInt32(SCPlayerInfo._01dwUser_Id)
        buffer:WriteBytes(33, MD5Helper.MD5String("123456"))
        logError("输入的设置密码格式正确")
        Network.Send(4, 129, buffer, gameSocketNumber.HallSocket)
        logError("发送设置密码后")
    elseif self.olduserid ~= SCPlayerInfo._01dwUser_Id then
        --self.InputPwd:SetActive(true)
        --self.Newpwd:SetActive(false)
        --self.GetAndSave:SetActive(false)
        --self.InputPwd.transform.localPosition = Vector3.New(0, 0, 0)
        self.InputPwdGetGold();
    else
        self.Newpwd:SetActive(false)
        self.GetAndSave:SetActive(true)
        --self.GetAndSave.transform.localPosition = Vector3.New(0, 0, 0)
        --self.Newpwd.transform.localPosition = Vector3.New(800, 0, 0)
    end
    self.SetGoldChange()
    Event.AddListener(PanelListModeEven._015ChangeGoldTicket, self.SetGoldChange)
end

function BankPanel.InputOverNum()
    if self.setgoldInputField:GetComponent("InputField").text=="" then
        return
    end
    if self.PanelID==1 then
        if tonumber(self.setgoldInputField:GetComponent("InputField").text) >tonumber(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD)) then
            self.setgoldInputField:GetComponent("InputField").text=tostring(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD))
        end
    else
        if tonumber(self.setgoldInputField:GetComponent("InputField").text) >tonumber(gameData.GetProp(enum_Prop_Id.E_PROP_STRONG)) then
            self.setgoldInputField:GetComponent("InputField").text=tostring(gameData.GetProp(enum_Prop_Id.E_PROP_STRONG))
        end
    end
    local str=GiveRedBag.doUpperMoney(tostring((self.setgoldInputField:GetComponent("InputField").text)),0)
    local index = string.find(str, "零", 1)
    if index == 1 then
        str = string.sub(str, 4, -1)
    end
    self.setgoldUpperText.text=str
end

--更改密码
function BankPanel.OnClickResetPWCall()
    self.ResetPwdBg:SetActive(true)

    --changePassWordPanel.Open(HallScenPanel.LuaBehaviour);
end
function BankPanel.OnClickResetSetGoldCall()
    self.setgoldInputField:GetComponent("InputField").text = "";
    self.setgoldUpperText.text=""
end
-- 存
function BankPanel.BankBtnOnClick(args)
    if args~=nil then
        HallScenPanel.PlayeBtnMusic()   
    end
    self.PanelID=1

    self.BankerBg:SetActive(true)
    --self.BankerBg.transform.localPosition = Vector3.New(165, -20, 0)
    self.TransferBg:SetActive(false)
    --self.TransferBg.transform.localPosition = Vector3.New(800, 0, 0)
    self.QueryBg:SetActive(false)
    --self.QueryBg.transform.localPosition = Vector3.New(800, 0, 0)
    self.BankBtn:GetComponent("Button").interactable = false
    self.BankBtn.transform:Find("Image").gameObject:SetActive(true)
    self.BankBtn.transform:Find("name1").gameObject:SetActive(true)
    self.BankBtn.transform:Find("name").gameObject:SetActive(false)

    self.BankGetBtn:GetComponent("Button").interactable = true
    self.BankGetBtn.transform:Find("Image").gameObject:SetActive(false)
    self.BankGetBtn.transform:Find("name1").gameObject:SetActive(false)
    self.BankGetBtn.transform:Find("name").gameObject:SetActive(true)

    self.TransferBtn:GetComponent("Button").interactable = true
    self.TransferBtn.transform:Find("Image").gameObject:SetActive(false)
    self.TransferBtn.transform:Find("name1").gameObject:SetActive(false)
    self.TransferBtn.transform:Find("name").gameObject:SetActive(true)

    self.QueryBtn:GetComponent("Button").interactable = true
    self.QueryBtn.transform:Find("Image").gameObject:SetActive(false)
    self.TransferBtn.transform:Find("name1").gameObject:SetActive(false)
    self.TransferBtn.transform:Find("name").gameObject:SetActive(true)

    self.LPKBtn:GetComponent("Button").interactable = true
    self.LPKBtn.transform:Find("Image").gameObject:SetActive(false)
    self.LPKBtn.transform:Find("name1").gameObject:SetActive(false)
    self.LPKBtn.transform:Find("name").gameObject:SetActive(true)

    self.ResetPwdBg:SetActive(false)
    self.SaveGoldBtn:SetActive(true);
    self.GetGoldBtn:SetActive(false);
    
    self.allgoldBtn.onClick:RemoveAllListeners();
    self.allgoldBtn.transform:Find("Cun").gameObject:SetActive(true);
    self.allgoldBtn.transform:Find("Qu").gameObject:SetActive(false);
    self.setgoldInputField:GetComponent("InputField").text=""
    self.setgoldUpperText.text=""
    self.getgoldPWInputField:GetComponent("InputField").text = "";

    self.allgoldBtn.onClick:AddListener(function()
        self.setgoldInputField:GetComponent("InputField").text = tostring(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD));
        local str=GiveRedBag.doUpperMoney(tostring((self.setgoldInputField:GetComponent("InputField").text)),0)
        local index = string.find(str, "零", 1)
        if index == 1 then
            str = string.sub(str, 4, -1)
        end
        self.setgoldUpperText.text=str
    end);
    --self.ResetPwdBg.transform.localPosition = Vector3.New(800, 0, 0)
end
--取
function BankPanel.BankGetBtnOnClick()
    HallScenPanel.PlayeBtnMusic()
    self.PanelID=2

    self.BankerBg:SetActive(true)
    self.TransferBg:SetActive(false)
    self.QueryBg:SetActive(false)

    self.BankBtn:GetComponent("Button").interactable = true
    self.BankBtn.transform:Find("Image").gameObject:SetActive(false)
    self.BankBtn.transform:Find("name1").gameObject:SetActive(false)
    self.BankBtn.transform:Find("name").gameObject:SetActive(true)


    self.BankGetBtn:GetComponent("Button").interactable = false
    self.BankGetBtn.transform:Find("Image").gameObject:SetActive(true)
    self.BankGetBtn.transform:Find("name1").gameObject:SetActive(false)
    self.BankGetBtn.transform:Find("name").gameObject:SetActive(true)

    self.TransferBtn:GetComponent("Button").interactable = true
    self.TransferBtn.transform:Find("Image").gameObject:SetActive(false)
    self.TransferBtn.transform:Find("name1").gameObject:SetActive(false)
    self.TransferBtn.transform:Find("name").gameObject:SetActive(true)

    self.QueryBtn:GetComponent("Button").interactable = true
    self.QueryBtn.transform:Find("Image").gameObject:SetActive(false)
    self.QueryBtn.transform:Find("name1").gameObject:SetActive(false)
    self.QueryBtn.transform:Find("name").gameObject:SetActive(true)

    self.QueryBtn:GetComponent("Button").interactable = true
    self.QueryBtn.transform:Find("Image").gameObject:SetActive(false)
    self.QueryBtn.transform:Find("name1").gameObject:SetActive(false)
    self.QueryBtn.transform:Find("name").gameObject:SetActive(true)

    self.LPKBtn:GetComponent("Button").interactable = true
    self.LPKBtn.transform:Find("Image").gameObject:SetActive(false)
    self.LPKBtn.transform:Find("name1").gameObject:SetActive(false)
    self.LPKBtn.transform:Find("name").gameObject:SetActive(true)

    self.ResetPwdBg:SetActive(false)
    self.SaveGoldBtn:SetActive(false);
    self.GetGoldBtn:SetActive(true);
    self.setgoldInputField:GetComponent("InputField").text=""
    self.setgoldUpperText.text=""
    self.getgoldPWInputField:GetComponent("InputField").text = "";

    self.allgoldBtn.onClick:RemoveAllListeners();
    self.allgoldBtn.transform:Find("Cun").gameObject:SetActive(false);
    self.allgoldBtn.transform:Find("Qu").gameObject:SetActive(true);
    self.allgoldBtn.onClick:AddListener(function()
        self.setgoldInputField:GetComponent("InputField").text = tostring(gameData.GetProp(enum_Prop_Id.E_PROP_STRONG));

        local str=GiveRedBag.doUpperMoney(tostring((self.setgoldInputField:GetComponent("InputField").text)),0)
        local index = string.find(str, "零", 1)
        if index == 1 then
            str = string.sub(str, 4, -1)
        end
        self.setgoldUpperText.text=str
    end);
    --self.ResetPwdBg.transform.localPosition = Vector3.New(800, 0, 0)
end
-- 转账
function BankPanel.TransferBtnOnClick()
    HallScenPanel.PlayeBtnMusic()
    self.BankerBg:SetActive(false)
    self.TransferBg:SetActive(true)
    self.ResetPwdBg:SetActive(false)
    self.QueryBg:SetActive(false)
    Event.Brocast(PanelListModeEven._007redPackagePanel, self.TransferBg)
    self.BankBtn:GetComponent("Button").interactable = true
    self.BankBtn.transform:Find("Image").gameObject:SetActive(false)
    self.BankBtn.transform:Find("name1").gameObject:SetActive(false)
    self.BankBtn.transform:Find("name").gameObject:SetActive(true)

    self.BankGetBtn:GetComponent("Button").interactable = true
    self.BankGetBtn.transform:Find("Image").gameObject:SetActive(false)
    self.BankGetBtn.transform:Find("name1").gameObject:SetActive(false)
    self.BankGetBtn.transform:Find("name").gameObject:SetActive(true)

    self.TransferBtn:GetComponent("Button").interactable = false
    self.TransferBtn.transform:Find("Image").gameObject:SetActive(true)
    self.TransferBtn.transform:Find("name1").gameObject:SetActive(true)
    self.TransferBtn.transform:Find("name").gameObject:SetActive(false)

    self.QueryBtn:GetComponent("Button").interactable = true
    self.QueryBtn.transform:Find("Image").gameObject:SetActive(false)
    self.QueryBtn.transform:Find("name1").gameObject:SetActive(false)
    self.QueryBtn.transform:Find("name").gameObject:SetActive(true)

    self.LPKBtn:GetComponent("Button").interactable = true
    self.LPKBtn.transform:Find("Image").gameObject:SetActive(false)
    self.LPKBtn.transform:Find("name1").gameObject:SetActive(false)
    self.LPKBtn.transform:Find("name").gameObject:SetActive(true)
    --self.QueryBtn.transform:Find("Text"):GetComponent("Text").color = Color.New(0, 175, 255, 255);
end

-- 查询
function BankPanel.QueryBtnOnClick()
    HallScenPanel.PlayeBtnMusic()

    self.BankerBg:SetActive(false)
    --self.BankerBg.transform.localPosition = Vector3.New(800, 0, 0)
    self.TransferBg:SetActive(false)
    --self.TransferBg.transform.localPosition = Vector3.New(800, 0, 0)
    self.ResetPwdBg:SetActive(false)
    --self.ResetPwdBg.transform.localPosition = Vector3.New(800, 0, 0)
    self.QueryBg:SetActive(true)
    --self.QueryBg.transform.localPosition = Vector3.New(0, 0, 0)
    --Event.Brocast(PanelListModeEven._007redPackagePanel, self.QueryBg)
    QueryPanel.Init(self.QueryBg);
    self.BankBtn:GetComponent("Button").interactable = true
    self.BankBtn.transform:Find("Image").gameObject:SetActive(false)
    self.BankBtn.transform:Find("name1").gameObject:SetActive(false)
    self.BankBtn.transform:Find("name").gameObject:SetActive(true)

    self.BankGetBtn:GetComponent("Button").interactable = true
    self.BankGetBtn.transform:Find("Image").gameObject:SetActive(false)
    self.BankGetBtn.transform:Find("name1").gameObject:SetActive(false)
    self.BankGetBtn.transform:Find("name").gameObject:SetActive(true)

    self.TransferBtn:GetComponent("Button").interactable = true
    self.TransferBtn.transform:Find("Image").gameObject:SetActive(false)
    self.TransferBtn.transform:Find("name1").gameObject:SetActive(false)
    self.TransferBtn.transform:Find("name").gameObject:SetActive(true)

    self.QueryBtn:GetComponent("Button").interactable = false
    self.QueryBtn.transform:Find("Image").gameObject:SetActive(true)
    self.QueryBtn.transform:Find("name1").gameObject:SetActive(true)
    self.QueryBtn.transform:Find("name").gameObject:SetActive(false)

    self.LPKBtn:GetComponent("Button").interactable = true
    self.LPKBtn.transform:Find("Image").gameObject:SetActive(false)
    self.LPKBtn.transform:Find("name1").gameObject:SetActive(false)
    self.LPKBtn.transform:Find("name").gameObject:SetActive(true)
end

function BankPanel.LPKBtnOnClick()

    ZSCardPanel.Init();

    self.BankBtn:GetComponent("Button").interactable = true
    self.BankBtn.transform:Find("Image").gameObject:SetActive(false)
    self.BankBtn.transform:Find("name1").gameObject:SetActive(false)
    self.BankBtn.transform:Find("name").gameObject:SetActive(true)

    self.BankGetBtn:GetComponent("Button").interactable = true
    self.BankGetBtn.transform:Find("Image").gameObject:SetActive(false)
    self.BankGetBtn.transform:Find("name1").gameObject:SetActive(false)
    self.BankGetBtn.transform:Find("name").gameObject:SetActive(true)

    self.TransferBtn:GetComponent("Button").interactable = true
    self.TransferBtn.transform:Find("Image").gameObject:SetActive(false)
    self.TransferBtn.transform:Find("name1").gameObject:SetActive(false)
    self.TransferBtn.transform:Find("name").gameObject:SetActive(true)

    self.QueryBtn:GetComponent("Button").interactable = true
    self.QueryBtn.transform:Find("Image").gameObject:SetActive(false)
    self.QueryBtn.transform:Find("name1").gameObject:SetActive(false)
    self.QueryBtn.transform:Find("name").gameObject:SetActive(true)

    self.LPKBtn:GetComponent("Button").interactable = false
    self.LPKBtn.transform:Find("Image").gameObject:SetActive(true)
    self.LPKBtn.transform:Find("name1").gameObject:SetActive(true)
    self.LPKBtn.transform:Find("name").gameObject:SetActive(false)
    BankPanel.CloseBtnOnClick()
end

-- 修改密码
function BankPanel.UpdateOnClick()
    HallScenPanel.PlayeBtnMusic()

    logError("存储手机号码:" .. SCPlayerInfo._29szPhoneNumber)
    logTable(SCPlayerInfo)
    if tonumber(SCPlayerInfo._29szPhoneNumber) == nil or string.len(SCPlayerInfo._29szPhoneNumber) ~= 11 then
        MessageBox.CreatGeneralTipsPanel("绑定了手机号，才能重置密码")
        return
    end
    --self.BgLen.transform:GetComponent("RectTransform").sizeDelta = Vector2.New(750, 500)
    self.BankerBg:SetActive(false)
    --self.BankerBg.transform.localPosition = Vector3.New(800, 0, 0)
    self.TransferBg:SetActive(false)
    --self.TransferBg.transform.localPosition = Vector3.New(800, 0, 0)
    self.ResetPwdBg:SetActive(true)
    --self.ResetPwdBg.transform.localPosition = Vector3.New(0, 0, 0)
    self.InputPwd:SetActive(false)
    --self.InputPwd.transform.localPosition = Vector3.New(800, 0, 0)
end
-- 取消修改
function BankPanel.UpdateBackOnClick(data)
    HallScenPanel.PlayeBtnMusic()

    --self.BgLen.transform:GetComponent("RectTransform").sizeDelta = Vector2.New(750, 450)
    self.BankerBg:SetActive(true)
    --self.BankerBg.transform.localPosition = Vector3.New(800, 0, 0)
    self.TransferBg:SetActive(false)
    --self.TransferBg.transform.localPosition = Vector3.New(800, 0, 0)
    self.ResetPwdBg:SetActive(false)
    --self.ResetPwdBg.transform.localPosition = Vector3.New(800, 0, 0)
    self.InputPwd:SetActive(false)
    --self.InputPwd.transform.localPosition = Vector3.New(0, 0, 0)
end

function BankPanel.UpdateResetBtnOnClick(obj)
    HallScenPanel.PlayeBtnMusic()

    obj.transform:GetComponent("Button").interactable = false
    if
    LogonScenPanel.StrIsTrue(self.Reset_pwd:GetComponent("InputField").text, 6, 12) == 0 or
            LogonScenPanel.StrIsTrue(self.Reset_pwd:GetComponent("InputField").text, 6, 12) > 2
    then
        error("密码输入不对")
        MessageBox.CreatGeneralTipsPanel("密码格式有误")
        obj.transform:GetComponent("Button").interactable = true
        return
    end
    if LogonScenPanel.StrIsTrue(self.Reset_code:GetComponent("InputField").text, 4, 8) ~= 1 then
        error("验证码输入不对")
        MessageBox.CreatGeneralTipsPanel("验证码输入有误")
        obj.transform:GetComponent("Button").interactable = true
        return
    end
    if self.Reset_pwd:GetComponent("InputField").text ~= self.Reset_repwd:GetComponent("InputField").text then
        error("两次输入密码不同")
        MessageBox.CreatGeneralTipsPanel("两次输入密码不同")
        obj.transform:GetComponent("Button").interactable = true
        return
    end
    local function _f()
        Event.AddListener(tostring(MH.SUB_3D_SC_RESET_PASSWORD), self.UpdatePwdSuccess)
        local buffer = ByteBuffer.New()
        --bf:WriteBytes(12,phonenum);
        local Data = {
            -- 手机号码
            [1] = SCPlayerInfo._29szPhoneNumber,
            -- 密码
            [2] = MD5Helper.MD5String(self.Reset_pwd:GetComponent("InputField").text),
            -- 验证码
            [3] = self.Reset_code:GetComponent("InputField").text,
            -- 类型
            [4] = PlatformID
        }
        -- error("NetManager:GetMd5String(PasswordInput:GetComponent(InputField).text)===========" .. MD5Helper.MD5String(self.Reset_pwd:GetComponent("InputField").text))
        buffer = SetC2SInfo(CS_ResetPassword, Data)
        Network.Send(MH.MDM_GP_USER, MH.SUB_GP_MODIFY_BANK_PASSWD, buffer, gameSocketNumber.HallSocket)
    end

    _f()
end

function BankPanel.UpdatePwdSuccess(buffer, wSize)
    error("找回密码返回====================" .. wSize)
    local data = {}
    data.cbSuccess = buffer:ReadInt32() -- 是否成功
    data.szInfoDiscrib = buffer:ReadString(128) -- 更改反馈
    self.Reset_updatebtn.transform:GetComponent("Button").interactable = true
    Event.RemoveListener(tostring(MH.SUB_3D_SC_RESET_PASSWORD))
    if data.cbSuccess == 1 then
        error("重置密码成功")
        MessageBox.CreatGeneralTipsPanel("重置密码成功，请妥善保管")
        BankPanel.UpdateBackOnClick()
        return
    end
    changePassWordPanel.UpdatePwdSuccess()
    MessageBox.CreatGeneralTipsPanel(data.szInfoDiscrib)
    -- 替换现在有得密码
end

-- 找回密码验证码
function BankPanel.UpdatePwdCodeBtn()
    HallScenPanel.PlayeBtnMusic()

    local phonenum = SCPlayerInfo._29szPhoneNumber
    if tonumber(phonenum) == nil then
        MessageBox.CreatGeneralTipsPanel("请输入正确手机号码")
        return
    end
    if string.len(phonenum) ~= 11 then
        MessageBox.CreatGeneralTipsPanel("请输入正确手机号码")
        return
    end
    local function _f()
        self.Reset_codebtn.transform:GetComponent("Button").interactable = false
        self.Reset_codebtn.transform:GetComponent("Text").enabled = false

        self.Reset_codebtn.transform:Find("Text"):GetComponent("Text").text = "60s again"
        MoveNotifyInfoClass.getcodefuntion = self.TimeOverTwo
        MoveNotifyInfoClass.getcodetime = 60
        coroutine.start(MoveNotifyInfoClass.GetCodeTime)
        Event.AddListener(tostring(MH.SUB_3D_SC_RESET_PASSWORD_CODE), self.UpdatePwdCodeSC)

        local bf = ByteBuffer.New()
        bf:WriteBytes(12, phonenum)
        --bf:WriteByte(2);
        --bf:WriteBytes(100,Opcodes);
        Network.Send(MH.MDM_GP_USER, MH.SUB_GP_MODIFY_BANK_PASSWD_CHECK_CODE, bf, gameSocketNumber.HallSocket)
    end

    _f()
end
function BankPanel.TimeOverTwo()
    self.Reset_codebtn.transform:Find("Text"):GetComponent("Text").text = MoveNotifyInfoClass.getcodetime .. "s again"
    if MoveNotifyInfoClass.getcodetime <= 0 then
        self.Reset_codebtn.transform:Find("Text"):GetComponent("Text").text = "________"
        self.Reset_codebtn.transform:GetComponent("Button").interactable = true
        self.Reset_codebtn.transform:GetComponent("Text").enabled = true

    end
end

-- 验证码返回
function BankPanel.UpdatePwdCodeSC(buffer, wSize)
    error("获取验证码按钮事件的回调")
    Event.RemoveListener(tostring(MH.SUB_3D_SC_RESET_PASSWORD_CODE))
    local str = tostring(buffer:ReadUInt32())
    error("str==============" .. str)
    self.ScCode = str
    if wSize == 0 then
        MoveNotifyInfoClass.getcodetime = -1
        MessageBox.CreatGeneralTipsPanel("找不到该手机号")
        MoveNotifyInfoClass.getcodefuntion = nil
        self.Reset_codebtn.transform:GetComponent("Button").interactable = true
        self.Reset_codebtn.transform:GetComponent("Text").enabled = true
        self.Reset_codebtn.transform:Find("Text"):GetComponent("Text").text = "________"
        return
    end
end

-- 设置金币变动
function BankPanel.SetGoldChange()
    self.BankeGoldNumber = tonumber(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD))
    self.SaveGoldText:GetComponent("Text").text = tostring(gameData.GetProp(enum_Prop_Id.E_PROP_STRONG))
    self.GoldText.transform:GetComponent("Text").text = tostring(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD))
    log("设置金币变动")
end

----隐藏和显示一个transform
function BankPanel.ShowPanel(g, isShow)
    local t = g.transform
    if (t.localPosition.x > 100) then
        t.transform.localPosition = Vector3.New(0, 0, 0)
    else
        t.localPosition = Vector3.New(800, 0, 0)
    end
end

-- 关闭按钮
function BankPanel.CloseBtnOnClick()
    log("==========CloseBtnOnClick================")
    HallScenPanel.PlayeBtnMusic()

    Event.RemoveListener(PanelListModeEven._015ChangeGoldTicket, self.SetGoldChange)
    destroy(self.BankPanelObj)
    GiveRedBag.CloseBtnOnClick()
    self.BankPanelObj = nil
    HallScenPanel.MidCloseBtn = nil;
    HallScenPanel.BackHallOnClick();
end

-- 设置密码
function BankPanel.SetPwdBtnOnClick()
    HallScenPanel.PlayeBtnMusic()

    local t1 = self.pwdinputfiel:GetComponent("InputField").text
    local t2 = self.surepwdinputfiel:GetComponent("InputField").text
    if not (self.PwdEndValue(t1)) then
        MessageBox.CreatGeneralTipsPanel("输入的密码格式或长度有误")
        return
    end
    if not (self.PwdEndValue(t2)) then
        MessageBox.CreatGeneralTipsPanel("输入的确认密码格式或长度有误")
        return
    end
    if t1 ~= t2 then
        MessageBox.CreatGeneralTipsPanel("两次输入密码有误，请重新输入")
        return
    end
    if self._bHasStrongBoxPassword == 1 then
        self.InputPwd:SetActive(true)
        self.Newpwd:SetActive(false)
        self.GetAndSave:SetActive(false)
        --self.InputPwd.transform.localPosition = Vector3.New(0, 0, 0)
        --self.Newpwd.transform.localPosition = Vector3.New(800, 0, 0)
        return
    end
    local buffer = ByteBuffer.New()
    buffer:WriteUInt32(SCPlayerInfo._01dwUser_Id)
    buffer:WriteBytes(33, MD5Helper.MD5String(t1))
    logError("输入的设置密码格式正确")
    Network.Send(4, 129, buffer, gameSocketNumber.HallSocket)
    logError("发送设置密码后")
end

-- 设置密码CallBack
function BankPanel.SetPwdBtnCallBack(data)
    
    if data[1] == 1 then
        MessageBox.CreatGeneralTipsPanel("你已成功设置银行密码，请妥善保管")
        self._bHasStrongBoxPassword = 1
        self.pwd = self.pwdinputfiel:GetComponent("InputField").text
        self.bankTime = Util.TickCount
        self.olduserid = SCPlayerInfo._01dwUser_Id
        self.Newpwd:SetActive(false)
        self.GetAndSave:SetActive(true)
        self.GetAndSave.transform.localPosition = Vector3.New(0, 0, 0)
        self.Newpwd.transform.localPosition = Vector3.New(800, 0, 0)
        gameData.ChangProp(data[3], enum_Prop_Id.E_PROP_STRONG)
        self.SetGoldChange()
    else
        MessageBox.CreatGeneralTipsPanel(data[4])
        if self._bHasStrongBoxPassword == 1 then
            self.InputPwd:SetActive(true)
            self.Newpwd:SetActive(false)
            self.GetAndSave:SetActive(false)
            self.InputPwd.transform.localPosition = Vector3.New(0, 0, 0)
            self.Newpwd.transform.localPosition = Vector3.New(800, 0, 0)
            return
        end
    end
    self.InputPwdGetGold();
end

-- 存入金币
self.CostBtnOnClick = true
function BankPanel.SaveGoldBtnOnClick()
    HallScenPanel.PlayeBtnMusic()

    --表示点击了存;则不能此时不能取;反之....
    if self.CostBtnOnClick == false then
        return
    end
    local a = self.setgoldInputField.transform:GetComponent("InputField").text
    log(tonumber(a))
    if a == nil or a == "" then
        --[[        MessageBox.CreatGeneralTipsPanel("你的输入有误，请重新输入！");
        return;--]]
        --self.setgoldInputField.transform:GetComponent("InputField").text = tostring(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD))
        --a = gameData.GetProp(enum_Prop_Id.E_PROP_GOLD)
        --a = 0
        logError("存入的钱=" .. a)
        MessageBox.CreatGeneralTipsPanel("请检查你输入的金币是否正确!")
        return;
    end
    if self.BankeGoldNumber < tonumber(a) then
        MessageBox.CreatGeneralTipsPanel("你持有的金币数量不足，请重新输入！")
        return
    end
    if tonumber(a) < 1 then
        MessageBox.CreatGeneralTipsPanel("请检查你输入的金币是否正确!")
        return
    end
    self.CostBtnOnClick = false
    local function f()
        local buffer = ByteBuffer.New()
        buffer:WriteUInt32(SCPlayerInfo._01dwUser_Id) -- 玩家ID
        buffer:WriteUInt32(0)
        --- 存款标识0  取款标识1
        buffer:WriteLong(a)
        --- 存款金币
        ---
        self.pwd = self.getgoldPWInputField:GetComponent("InputField").text;
        buffer:WriteBytes(33, MD5Helper.MD5String(self.pwd)) -- 银行密码
        Network.Send(MH.MDM_GP_USER, MH.SUB_GP_USER_BANK_OPERATE, buffer, gameSocketNumber.HallSocket)
        logError("发送进入保险箱密码消息主ID：" .. MH.MDM_GP_USER .. ",子ID：" .. MH.SUB_GP_USER_BANK_OPERATE)
    end
    f()
    coroutine.start(
            function()
                coroutine.wait(4)
                if IsNil(self.SaveGoldBtn) then
                    return
                end
                if IsNil(self.SaveGoldBtn.transform) then
                    return
                end
                if IsNil(self.SaveGoldBtn.transform:GetComponent("Button")) then
                    return
                end
                self.GetGoldPwdBtn.transform:GetComponent("Button").interactable = true
                self.CostBtnOnClick = true
            end
    )
end

-- 取出金币
function BankPanel.GetGoldBtnOnClick()
    HallScenPanel.PlayeBtnMusic()

    --表示点击了存;则不能此时不能取;反之....
    if self.CostBtnOnClick == false then
        return
    end
    local a = self.setgoldInputField.transform:GetComponent("InputField").text
    log("=====================================取钱==========================================" .. a)
    if (a == nil or a == "" or tonumber(a) <= 0) then
        --[[MessageBox.CreatGeneralTipsPanel("请检查你输入的金币是否正确");
        return--]]
        --self.setgoldInputField.transform:GetComponent("InputField").text = tostring(gameData.GetProp(enum_Prop_Id.E_PROP_STRONG))
        --a = self.setgoldInputField.transform:GetComponent("InputField").text
        MessageBox.CreatGeneralTipsPanel("请检查你输入的金币是否正确!")
        return
    end
    log("存款:" .. a)
    if (tonumber(a) > tonumber(gameData.GetProp(enum_Prop_Id.E_PROP_STRONG))) then
        MessageBox.CreatGeneralTipsPanel("你的存款不足，请重新输入！")
        return
    end
    self.BankGetGold()
end

-- 取消输入密码
function BankPanel.ReturnMainPanel()
    HallScenPanel.BackHallOnClick()
end

-- 输入密码进入保险箱
function BankPanel.InputPwdGetGold()
    --HallScenPanel.PlayeBtnMusic()

    logError("输入密码进入保险箱")
    self.GetGoldPwdBtn.transform:GetComponent("Button").enabled = false
    local p = self.GetGoldPwdInputField.transform:GetComponent("InputField").text
    local buffer = ByteBuffer.New()
    p = "123456";
    buffer:WriteBytes(33, MD5Helper.MD5String(p))
    logError("发送进入保险箱密码消息主ID：" .. MH.MDM_3D_PERSONAL_INFO .. ",子ID：" .. MH.SUB_3D_CS_STRONG_BOX_COME_IN)
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_STRONG_BOX_COME_IN, buffer, gameSocketNumber.HallSocket) --  修改成317
    coroutine.start(
            function()
                coroutine.wait(11)
                while not (Network.State(gameSocketNumber.HallSocket)) do
                    coroutine.wait(1)
                end
                if IsNil(self.GetGoldPwdBtn) then
                    return
                end
                if IsNil(self.GetGoldPwdBtn.transform) then
                    return
                end
                if IsNil(self.GetGoldPwdBtn.transform:GetComponent("Button")) then
                    return
                end
                self.GetGoldPwdBtn.transform:GetComponent("Button").enabled = true
            end
    )
end

-- 返回进入保险箱是否成功
function BankPanel.InBankInfo(buffer, wSize)
    --self.GetGoldPwdBtn.transform:GetComponent('Button').interactable = true;
    local num = buffer:ReadByte()
    local BankGold = buffer:ReadInt64Str()
    if num > 200 then
        error("银行因安全问题已被锁定,请重置银行密码")
        MessageBox.CreatGeneralTipsPanel(
                "银行因安全问题已被锁定,请重置银行密码。",
                function()
                    self.GetGoldPwdBtn.transform:GetComponent("Button").enabled = true
                end
        )
        return
    end
    gameData.ChangProp(BankGold, enum_Prop_Id.E_PROP_STRONG)
    local InputPwd = self.GetGoldPwdInputField.transform:GetComponent("InputField")
    if num == 0 then
        self.SaveGoldText.transform:GetComponent("Text").text = BankGold
        self.olduserid = SCPlayerInfo._01dwUser_Id
        self.pwd = InputPwd.text
        self.Newpwd:SetActive(false)
        self.InputPwd:SetActive(false)
        self.GetAndSave:SetActive(true)
        self.BankerBg:SetActive(true)
        --self.BankerBg.transform.localPosition = Vector3.New(165, -20, 0)
        --self.GetAndSave.transform.localPosition = Vector3.New(0, 0, 0)
        --self.Newpwd.transform.localPosition = Vector3.New(800, 0, 0)
        --self.InputPwd.transform.localPosition = Vector3.New(800, 0, 0)
        self.GetGoldPwdBtn.transform:GetComponent("Button").enabled = true
        self.BankBtnOnClick()
        return
    end
    -- 银行密码输入错误，还能输入xx次
    MessageBox.CreatGeneralTipsPanel(
            "银行密码输入错误,还能输入<color=#ffff00ff>" .. num .. "</color>次",
            function()
                self.GetGoldPwdBtn.transform:GetComponent("Button").enabled = true
            end
    )
    -- 清空错误密码
    InputPwd.text = ""
end

function BankPanel.BankGetGold()
    local p = self.pwd
    self.pwd = self.getgoldPWInputField:GetComponent("InputField").text;
    local a = self.setgoldInputField.transform:GetComponent("InputField").text

    if string.length(self.pwd)<=0 then
        MessageBox.CreatGeneralTipsPanel("密码不能为空")
        return
    end

    local function f()
        local buffer = ByteBuffer.New()
        buffer:WriteUInt32(SCPlayerInfo._01dwUser_Id) -- 玩家ID
        buffer:WriteUInt32(1)
        --- 存款标识0  取款标识1
        logError("--------------------------------取款金币：" .. a)
        buffer:WriteLong(a)
        --- 取款金币
        buffer:WriteBytes(33, MD5Helper.MD5String(self.pwd)) -- 银行密码
        logError("--------------------------------银行密码" .. self.pwd)

        Network.Send(MH.MDM_GP_USER, MH.SUB_GP_USER_BANK_OPERATE, buffer, gameSocketNumber.HallSocket)
    end
    f()
end

function BankPanel.QCBankZSGold(gold)
    local a = gold
    local pw=""
    local buffer = ByteBuffer.New()
    buffer:WriteUInt32(SCPlayerInfo._01dwUser_Id) -- 玩家ID
    buffer:WriteUInt32(1)
    --- 存款标识0  取款标识1
    logError("--------------------------------取款金币：" .. a)
    buffer:WriteLong(a)
    --- 取款金币

    buffer:WriteBytes(33, MD5Helper.MD5String(pw)) -- 银行密码
    Network.Send(MH.MDM_GP_USER, MH.SUB_GP_USER_BANK_OPERATE, buffer, gameSocketNumber.HallSocket)
end

-- 取出金币CallBack
function BankPanel.GetGoldBtnCallBack(buffer, wSize)
    -- 弹出输入密码的界面
    logYellow("取出金币CallBack")
    self.CostBtnOnClick = true
    self.GetGoldPwdBtn.transform:GetComponent("Button").interactable = true
    self.GetGoldBtn.transform:GetComponent("Button").interactable = true
    self.setgoldInputField.transform:GetComponent("InputField").text = ""
    self.setgoldUpperText.text=""
    self.getgoldPWInputField:GetComponent("InputField").text = "";

    if wSize == 0 then
        MessageBox.CreatGeneralTipsPanel("取出金币成功")
        gameData.ChangProp(buffer.szInsureScore, enum_Prop_Id.E_PROP_STRONG)
        self.SaveGoldText.transform:GetComponent("Text").text = buffer.szInsureScore
        local buffer = ByteBuffer.New()
        buffer:WriteUInt32(SCPlayerInfo._01dwUser_Id) -- 玩家ID
        Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_SELECT_GOLD_MSG, buffer, gameSocketNumber.HallSocket)
        return
    end
    MessageBox.CreatGeneralTipsPanel(buffer.szInfoDiscrib)
end

-- 存入金币CallBack
function BankPanel.SaveGoldBtnCallBack(buffer, wSize)
    self.setgoldInputField.transform:GetComponent("InputField").text = ""
    self.setgoldUpperText.text=""

    self.getgoldPWInputField:GetComponent("InputField").text = "";
    self.CostBtnOnClick = true
    if wSize == 0 then
        gameData.ChangProp(buffer.szInsureScore, enum_Prop_Id.E_PROP_STRONG)
        self.SaveGoldText.transform:GetComponent("Text").text = buffer.szInsureScore
        local buffer = ByteBuffer.New()
        buffer:WriteUInt32(SCPlayerInfo._01dwUser_Id) -- 玩家ID
        Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_SELECT_GOLD_MSG, buffer, gameSocketNumber.HallSocket)
        MessageBox.CreatGeneralTipsPanel("存入金币成功")
    else
        MessageBox.CreatGeneralTipsPanel(buffer.szInfoDiscrib)
    end
end

-- 密码InputField输入结束时调用
function BankPanel.PwdEndValue(args)
    if (string.len(args) < 6) then
        return false
    elseif (string.len(args) > 8) then
        return false
    elseif (RegularString(args)) then
        return true
    else
        return false
    end
end

-- 输入的金币是否正确
function BankPanel.GiveGoldEndValue(args)
    if string.find(args, "%d") then
        if string.find(args, "^0") then
            return false
        else
            return true
        end
    else
        return false
    end
end
