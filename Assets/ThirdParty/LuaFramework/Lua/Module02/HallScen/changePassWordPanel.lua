changePassWordPanel={}
local self = changePassWordPanel

self.m_luaBeHaviour = nil
self.transform=nil
self.PanelID=1

self.ISOpenDLYZ=false
function changePassWordPanel.Init(_luaBeHaviour)
    if  self.transform==nil then
        self.transform = HallScenPanel.Pool("changePassWord").transform;
        self.transform:SetParent(HallScenPanel.Compose.transform);
        self.transform.localPosition = Vector3.New(0, 0, 0);
        self.transform.localScale = Vector3.New(1, 1, 1);
    end  

    self.m_luaBeHaviour = _luaBeHaviour
    self.CPWmainPanel=self.transform:Find("mainPanel")

    self.CPWDLBtn=self.transform:Find("mainPanel/left/DL")
    self.CPWBXXBtn=self.transform:Find("mainPanel/left/BXX")

    self.CPWSureBtn=self.CPWmainPanel:Find("SureBtn")
    self.CPWCloseBtn=self.CPWmainPanel:Find("CloseBtn")
    self.CPWClosemaskBtn=self.transform:Find("zhezaho")

    self.DL=self.CPWmainPanel:Find("right/DL")

    -- self.CPWOldPassWord=self.CPWmainPanel:Find("right/DL/OldPassWord")
    -- self.CPWnewPassWord=self.CPWmainPanel:Find("right/DL/newPassWord")
    -- self.CPWTWoNewPassWord=self.CPWmainPanel:Find("right/DL/TWoNewPassWord")
    self.phoneText=self.CPWmainPanel:Find("right/DL/phoneText/Text"):GetComponent("Text")
    self.dlBtn=self.CPWmainPanel:Find("right/DL/dlkg/Button"):GetComponent("Button")
    
    self.CPWOldPassWordText=self.CPWmainPanel:Find("right/DL/OldPassWord/InputField"):GetComponent("InputField")
    self.CPWnewPassWordText=self.CPWmainPanel:Find("right/DL/newPassWord/InputField"):GetComponent("InputField")

    self.CPWTWoNewPassWordText=self.CPWmainPanel:Find("right/DL/TWoNewPassWord/InputField"):GetComponent("InputField")
    
    self.CPWOldPassWordText_x=self.CPWmainPanel:Find("right/DL/OldPassWord/Text"):GetComponent("Text")
    self.CPWnewPassWordText_x=self.CPWmainPanel:Find("right/DL/newPassWord/Text"):GetComponent("Text")
    self.CPWTWoNewPassWordText_x=self.CPWmainPanel:Find("right/DL/TWoNewPassWord/Text"):GetComponent("Text")

    self.BXX=self.CPWmainPanel:Find("right/BXX")

    self.CPWBXXPhone=self.CPWmainPanel:Find("right/BXX/Phone/InputField"):GetComponent("InputField")
    self.CPWBXXnewPassWord=self.CPWmainPanel:Find("right/BXX/newPassWord/InputField"):GetComponent("InputField")
    self.CPWBXXTWoNewPassWord=self.CPWmainPanel:Find("right/BXX/TWoNewPassWord/InputField"):GetComponent("InputField")
    self.CPWBXXYZM=self.CPWmainPanel:Find("right/BXX/YZM/InputField"):GetComponent("InputField")
    self.CPWBXXYZMBtn=self.CPWmainPanel:Find("right/BXX/YZM/Button"):GetComponent("Button")

    log("CPWSureBtn"..tostring(self.CPWSureBtn.name))

    self.m_luaBeHaviour:AddClick(self.CPWSureBtn.gameObject, self.CPWSure);
    self.m_luaBeHaviour:AddClick(self.CPWCloseBtn.gameObject, self.CPWClose);
    self.m_luaBeHaviour:AddClick(self.CPWClosemaskBtn.gameObject, self.CPWClose);
    self.m_luaBeHaviour:AddClick(self.CPWDLBtn.gameObject, self.LeftBtnClick);
    self.m_luaBeHaviour:AddClick(self.CPWBXXBtn.gameObject, self.LeftBtnClick);

    self.m_luaBeHaviour:AddClick(self.CPWBXXYZMBtn.gameObject, self.UpdatePwdCodeBtn);
    self.m_luaBeHaviour:AddClick(self.dlBtn.gameObject, self.DLYZBtncLICK);

    self.m_luaBeHaviour:AddEndEditEvent(self.CPWOldPassWordText.gameObject, self.InputOverNum1);
    self.m_luaBeHaviour:AddEndEditEvent(self.CPWnewPassWordText.gameObject, self.InputOverNum2);
    self.m_luaBeHaviour:AddEndEditEvent(self.CPWTWoNewPassWordText.gameObject, self.InputOverNum3);
end

function changePassWordPanel.Open(_luaBeHaviour)
    if  self.transform==nil then
        self.Init(_luaBeHaviour)
    else
        self.transform.gameObject:SetActive(true)
    end

    self.CPWDLBtn:GetComponent("Button").interactable=false
    self.CPWDLBtn:Find("TextB").gameObject:SetActive(false)
    self.CPWDLBtn:Find("TextG").gameObject:SetActive(true)

    self.CPWBXXBtn:GetComponent("Button").interactable=true
    self.CPWBXXBtn:Find("TextB").gameObject:SetActive(true)
    self.CPWBXXBtn:Find("TextG").gameObject:SetActive(false)
    self.phoneText.text=SCPlayerInfo._29szPhoneNumber
    self.PanelID=1
    self.DL.gameObject:SetActive(true)
    self.BXX.gameObject:SetActive(false)
    self.transform.gameObject:SetActive(true)
    logYellow("_26bLoginValidate=="..SCPlayerInfo._26bLoginValidate)
    if SCPlayerInfo._26bLoginValidate == 0 then
        self.dlBtn.transform:Find("Close").gameObject:SetActive(true)
        self.dlBtn.transform:Find("Open").gameObject:SetActive(false)
    end
    if SCPlayerInfo._26bLoginValidate == 1 then
        self.dlBtn.transform:Find("Close").gameObject:SetActive(false)
        self.dlBtn.transform:Find("Open").gameObject:SetActive(true)
    end

end

function changePassWordPanel.InputOverNum1(go,str)
    -- if  self.CPWOldPassWordText.text==""  then
    --     --self.CPWOldPassWordText_x.gameObject:SetActive(true)
    -- else
    --     self.CPWOldPassWordText_x.gameObject:SetActive(false)
    -- end
end
function changePassWordPanel.InputOverNum2(go,str)
    -- if  self.CPWnewPassWordText.text==""  then
    --     --self.CPWnewPassWordText_x.gameObject:SetActive(true)
    -- else
    --     self.CPWnewPassWordText_x.gameObject:SetActive(false)
    -- end
end
function changePassWordPanel.InputOverNum3(go,str)
    -- if  self.CPWTWoNewPassWordText.text==""  then
    --     --self.CPWTWoNewPassWordText_x.gameObject:SetActive(true)
    -- else
    --     self.CPWTWoNewPassWordText_x.gameObject:SetActive(false)
    -- end
end
function changePassWordPanel.LeftBtnClick(args)
    HallScenPanel.PlayeBtnMusic()

    if args.name=="DL" then
        self.PanelID=1
        self.CPWDLBtn:GetComponent("Button").interactable = false
        self.CPWDLBtn:Find("TextB").gameObject:SetActive(false)
        self.CPWDLBtn:Find("TextG").gameObject:SetActive(true)
        self.CPWBXXBtn:GetComponent("Button").interactable = true
        self.CPWBXXBtn:Find("TextB").gameObject:SetActive(true)
        self.CPWBXXBtn:Find("TextG").gameObject:SetActive(false)   
        self.CPWOldPassWordText.text=""
        self.CPWnewPassWordText.text=""
        self.CPWTWoNewPassWordText.text=""
        self.CPWOldPassWordText_x.gameObject:SetActive(false)
        self.CPWnewPassWordText_x.gameObject:SetActive(false)
        self.CPWTWoNewPassWordText_x.gameObject:SetActive(false)
        self.DL.gameObject:SetActive(true)
        self.BXX.gameObject:SetActive(false) 
    elseif args.name=="BXX" then
        self.PanelID=2
        self.CPWBXXBtn:GetComponent("Button").interactable = false
        self.CPWBXXBtn:Find("TextB").gameObject:SetActive(false)
        self.CPWBXXBtn:Find("TextG").gameObject:SetActive(true)
        self.CPWDLBtn:GetComponent("Button").interactable = true
        self.CPWDLBtn:Find("TextB").gameObject:SetActive(true)
        self.CPWDLBtn:Find("TextG").gameObject:SetActive(false) 
        self.CPWBXXPhone.text=""
        self.CPWBXXnewPassWord.text=""
        self.CPWBXXTWoNewPassWord.text=""
        self.CPWBXXYZM.text=""
        self.DL.gameObject:SetActive(false)
        self.BXX.gameObject:SetActive(true)
    end
end

function changePassWordPanel.DLYZBtncLICK(args)
    HallScenPanel.PlayeBtnMusic()
    if args then
        args.transform:GetComponent("Button").interactable = false 
    end
    local data = 0;
    if SCPlayerInfo._26bLoginValidate == 0 then
        data = 1;
        self.dlBtn.transform:Find("Close").gameObject:SetActive(false)
        self.dlBtn.transform:Find("Open").gameObject:SetActive(true)
    end
    if SCPlayerInfo._26bLoginValidate == 1 then
        data = 0;
        self.dlBtn.transform:Find("Close").gameObject:SetActive(true)
        self.dlBtn.transform:Find("Open").gameObject:SetActive(false)
    end
    local buffer = ByteBuffer.New();
    buffer:WriteByte(1);
    buffer:WriteByte(data);
    log("修改登录验证状态：" .. data);
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_QUERYLOGINVERIFY, buffer, gameSocketNumber.HallSocket);
    if args then
        args.transform:GetComponent("Button").interactable = true
    end
end

function changePassWordPanel.CheckLoginCodeBack(buffer)
    if self.transform==nil then
        return
    end
    local su = buffer:ReadByte();
    local t = buffer:ReadByte();
    local v = buffer:ReadByte();
    log("返回登录验证消息 状态：" .. su);
    log(" 类型：" .. t);
    log(" 值：" .. v);
    -- if su == 1 then
    --     MessageBox.CreatGeneralTipsPanel("修改失败");
    -- end

    if t == 0 then
        if v == 0 then
            self.dlBtn.transform:Find("Close").gameObject:SetActive(true)
            self.dlBtn.transform:Find("Open").gameObject:SetActive(false)
        else
            self.dlBtn.transform:Find("Close").gameObject:SetActive(false)
            self.dlBtn.transform:Find("Open").gameObject:SetActive(true)
        end
    else
        if v == 0 then
            self.dlBtn.transform:Find("Close").gameObject:SetActive(true)
            self.dlBtn.transform:Find("Open").gameObject:SetActive(false)
        else
            self.dlBtn.transform:Find("Close").gameObject:SetActive(false)
            self.dlBtn.transform:Find("Open").gameObject:SetActive(true)
        end
        SCPlayerInfo._26bLoginValidate = v;
    end
    
end

-- 设置登录验证成功
function changePassWordPanel.SetCodeBtnSuccess(buffer, wSize)
    MessageBox.CreatGeneralTipsPanel("设置登录验证成功");
    SCPlayerInfo._26bLoginValidate = buffer:ReadByte();
    if SCPlayerInfo._26bLoginValidate == 0 then
        self.dlBtn.transform:Find("Close").gameObject:SetActive(false)
        self.dlBtn.transform:Find("Open").gameObject:SetActive(true)
    end
    if SCPlayerInfo._26bLoginValidate == 1 then
        self.dlBtn.transform:Find("Close").gameObject:SetActive(true)
        self.dlBtn.transform:Find("Open").gameObject:SetActive(false)
    end
end


function changePassWordPanel.CPWSure()
    HallScenPanel.PlayeBtnMusic()

    if self.PanelID==1 then
        self.CPWSureBtn:GetComponent('Button').interactable = false;
        local oldPwd = self.CPWOldPassWordText.text;
        local newPwd = self.CPWnewPassWordText.text;
        local ConfirmPwd = self.CPWTWoNewPassWordText.text;
        if not (PersonalInfoSystem.PwdFun(newPwd)) then
            MessageBox.CreatGeneralTipsPanel("输入的信息有误，请确认你新密码是否正确")
            self.CPWSureBtn:GetComponent('Button').interactable = true;
            return
        end ;
        if not (PersonalInfoSystem.PwdFun(ConfirmPwd)) and ConfirmPwd == newPwd then
            MessageBox.CreatGeneralTipsPanel("输入的信息有误，请确认你确认密码是否正确")
            self.CPWSureBtn:GetComponent('Button').interactable = true;
            return
        end ;
        if newPwd ~= ConfirmPwd then
            MessageBox.CreatGeneralTipsPanel("两次输入的密码不同，请重新输入")
            self.CPWSureBtn:GetComponent('Button').interactable = true;
            return
        end ;

        local data = {
            [1] = MD5Helper.MD5String(self.CPWOldPassWordText.text),
            [2] = MD5Helper.MD5String(self.CPWnewPassWordText.text),
        }
        log("修改密码：" .. data[1] .. "  " .. data[2]);
        local buffer = SetC2SInfo(CS_ChangePassword, data)
        Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_CHANGE_PASSWORD, buffer, gameSocketNumber.HallSocket);

    elseif self.PanelID==2 then

        self.CPWSureBtn:GetComponent("Button").interactable = false
        if LogonScenPanel.StrIsTrue(self.CPWBXXnewPassWord.text, 6, 12) == 0 or LogonScenPanel.StrIsTrue(self.CPWBXXnewPassWord.text, 6, 12) > 2 then
            MessageBox.CreatGeneralTipsPanel("密码格式不正确")
            self.CPWSureBtn:GetComponent("Button").interactable = true
            return
        end

        if LogonScenPanel.StrIsTrue(self.CPWBXXYZM.text, 4, 8) ~= 1 then
            MessageBox.CreatGeneralTipsPanel("验证码输入有误")
            self.CPWSureBtn:GetComponent("Button").interactable = true
            return
        end

        if self.CPWBXXnewPassWord.text ~= self.CPWBXXTWoNewPassWord.text then
            MessageBox.CreatGeneralTipsPanel("两次输入密码不同")
            self.CPWSureBtn:GetComponent("Button").interactable = true
            return
        end
        local function _f()
            Event.AddListener(tostring(MH.SUB_3D_SC_RESET_PASSWORD), self.UpdatePwdSuccess)
            local buffer = ByteBuffer.New()
            local Data = {
                -- 手机号码
                [1] = SCPlayerInfo._29szPhoneNumber,
                -- 密码
                [2] = MD5Helper.MD5String(self.CPWBXXnewPassWord.text),
                [3] = self.CPWBXXYZM.text,
                [4] = PlatformID
            }
            buffer = SetC2SInfo(CS_ResetPassword, Data)
            Network.Send(MH.MDM_GP_USER, MH.SUB_GP_MODIFY_BANK_PASSWD, buffer, gameSocketNumber.HallSocket)
        end
        _f()
    end
end

function changePassWordPanel.UpdatePwdSuccess(buffer, wSize)
    self.CPWBXXPhone.text=""
    self.CPWBXXnewPassWord.text=""
    self.CPWBXXTWoNewPassWord.text=""
    self.CPWBXXYZM.text=""
    local data = {}
    data.cbSuccess = buffer:ReadInt32() -- 是否成功
    data.szInfoDiscrib = buffer:ReadString(128) -- 更改反馈
    log("000000000000000000000000000")
    self.CPWSureBtn:GetComponent("Button").interactable = true
    Event.RemoveListener(tostring(MH.SUB_3D_SC_RESET_PASSWORD))
    if data.cbSuccess == 1 then
        error("重置密码成功")
        MessageBox.CreatGeneralTipsPanel("重置密码成功，请妥善保管")
        return
    end
    MessageBox.CreatGeneralTipsPanel(data.szInfoDiscrib)
end

function changePassWordPanel.UpdataPasswordPanelCallBack()
    log("0000000000000000")
    self.CPWSureBtn:GetComponent('Button').interactable = true;
    self.CPWOldPassWordText.text = "";
    self.CPWnewPassWordText.text = "";
    self.CPWTWoNewPassWordText.text = "";
end

-- 找回密码验证码
function changePassWordPanel.UpdatePwdCodeBtn()
    HallScenPanel.PlayeBtnMusic()

    local phonenum = self.CPWBXXPhone.text
    if tonumber(phonenum) == nil then
        MessageBox.CreatGeneralTipsPanel("请输入正确手机号码")
        return
    end
    if string.len(phonenum) ~= 11 then
        MessageBox.CreatGeneralTipsPanel("请输入正确手机号码")
        return
    end
    local function _f()
        self.CPWBXXYZMBtn.transform:GetComponent("Button").interactable = false
        self.CPWBXXYZMBtn.transform:Find("Text"):GetComponent("Text").text = "120s again"
        self.CPWBXXYZMBtn.transform:Find("Text").gameObject:SetActive(true)
        self.CPWBXXYZMBtn.transform:Find("Image").gameObject:SetActive(false)

        MoveNotifyInfoClass.getcodefuntion = self.TimeOverTwo
        MoveNotifyInfoClass.getcodetime = 120
        coroutine.start(MoveNotifyInfoClass.GetCodeTime)
        Event.AddListener(tostring(MH.SUB_3D_SC_RESET_PASSWORD_CODE), self.UpdatePwdCodeSC)

        local bf = ByteBuffer.New()
        bf:WriteBytes(12, phonenum)
        Network.Send(MH.MDM_GP_USER, MH.SUB_GP_MODIFY_BANK_PASSWD_CHECK_CODE, bf, gameSocketNumber.HallSocket)
    end

    _f()
end

-- 验证码返回
function changePassWordPanel.UpdatePwdCodeSC(buffer, wSize)
    Event.RemoveListener(tostring(MH.SUB_3D_SC_RESET_PASSWORD_CODE))
    local str = tostring(buffer:ReadUInt32())
    error("str==============" .. str)
    self.ScCode = str
    if wSize == 0 then
        MoveNotifyInfoClass.getcodetime = -1
        MessageBox.CreatGeneralTipsPanel("找不到该手机号")
        MoveNotifyInfoClass.getcodefuntion = nil
        self.CPWBXXYZMBtn.transform:GetComponent("Button").interactable = true
        self.CPWBXXYZMBtn.transform:Find("Text"):GetComponent("Text").text = ""
        return
    end
end

function changePassWordPanel.TimeOverTwo()
    self.CPWBXXYZMBtn.transform:Find("Text"):GetComponent("Text").text = MoveNotifyInfoClass.getcodetime .. "s again"
    if MoveNotifyInfoClass.getcodetime <= 0 then
        self.CPWBXXYZMBtn.transform:Find("Text").gameObject:SetActive(false)
        self.CPWBXXYZMBtn.transform:Find("Image").gameObject:SetActive(true)
        self.CPWBXXYZMBtn.transform:Find("Text"):GetComponent("Text").text = ""
        self.CPWBXXYZMBtn.transform:GetComponent("Button").interactable = true
    end
end

function changePassWordPanel.CPWClose()
    HallScenPanel.PlayeBtnMusic()

    destroy(self.transform.gameObject)

    self.m_luaBeHaviour = nil
    self.transform=nil
end