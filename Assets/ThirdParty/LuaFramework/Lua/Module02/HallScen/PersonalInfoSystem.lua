--[[require "Common/define"
require "Data/gameData"]]

PersonalInfoSystem = { }
local self = PersonalInfoSystem;
local _obj = nil;
local updateSex = 0;
self.isReflushSignAndName = false;-- 当等于安卓的时候要实时检查名字和签名更新
-- ===========================================个人信息系统======================================
-- 用户头像点击事件
-- local PersonalInfoPanelNotice;  0
function PersonalInfoSystem.Open(id)
    log("打开窗口:" .. id);
    self.isReflushSignAndName = false;
    if self.openInfoIndex == id and HallScenPanel.MidCloseBtn == self.PersonalInfoPanelCloseBtnOnClick then
        return
    end
    if HallScenPanel.MidCloseBtn ~= nil then
        HallScenPanel.MidCloseBtn();
        HallScenPanel.MidCloseBtn = nil
    end
    if self.PersonalInfoPanel == nil then
        self.openInfoIndex = id;
        self.PersonalInfoPanel = "obj"
        self.openInfoIndexopenInfoIndex = id;
        --LoadAssetAsync("module02/hall_personal", "PersonalInfoPanel", self.OnCreacterChildPanel_Personal, true, true);
        self.OnCreacterChildPanel_Personal(HallScenPanel.Pool("PersonalInfoPanel"));
    elseif self.openInfoIndex ~= nil and self.openInfoIndex ~= id then
        self.openInfoIndex = id;
        self.ShowInfo_Personal()
    end
end

-- 创建UI的子面板_个人信息
function PersonalInfoSystem.OnCreacterChildPanel_Personal(prefeb)
    -- local go = newobject(prefeb);
    local go = prefeb;
    go.transform:SetParent(HallScenPanel.Compose.transform);
    go.name = "PersonalInfoPanel";
    go.transform.localScale = Vector3.New(1, 1, 1);
    go.transform.localScale = Vector3.New(GameManager.ScreenRate, GameManager.ScreenRate, GameManager.ScreenRate);
    go.transform.localPosition = Vector3.New(900, 0, 0);
    self.PersonalInfoPanel = go;
    -- 修改头像界面
    self.PhonePanel = self.PersonalInfoPanel.transform:Find("PhonePanel").gameObject;

    self.Bg = go.transform:Find("Bg").gameObject;
    -- 审核模式
    self.Bg:SetActive(gameIsOnline);
    if not (gameIsOnline) then
        self.Bg = self.PhonePanel;
        error("审核模式")
    end ;
    self.Bg.transform.localScale = Vector3.New(1, 1, 1);
    HallScenPanel.LastPanel = self.PersonalInfoPanel
    HallScenPanel.SetXiaoGuo(self.PersonalInfoPanel)
    PersonalInfoSystem.Init(self.PersonalInfoPanel, HallScenPanel.LuaBehaviour);
    HallScenPanel.SetBtnInter(true);
    --    if gameIsOnline then
    --    self.ShowPanel(self.PersonalInfoPanel);
    --    else
    --    self.ShowPanel(self.PersonalInfoPanel);
    --    self.ShowPanel(self.Bg);
    --    end

end

-- 显示UI界面信息
function PersonalInfoSystem.ShowInfo_Personal()
    -- 1 绑定手机   2 修改昵称 3 上传头像 4修改签名 5修改密码
    if self.openInfoIndex == nil then
        logError("默认窗口");
        self.defaultPanel:SetActive(true)
        HallScenPanel.PlayeBtnMusic();
        --self.SetPhonePanel.transform.localPosition = Vector3.New(900, 0, 0);
        self.SetPhonePanel:SetActive(false);
        --self.UpdatePasswordPanel.transform.localPosition = Vector3.New(900, 0, 0)
        self.UpdatePasswordPanel:SetActive(false);
        self.defaultPanel.transform:DOLocalMoveX(0, 0.2, false):SetEase(DG.Tweening.Ease.Linear);
        return ;
    end
    if self.openInfoIndex == 1 then
        log("显示显示绑定手机界面");
        self.UpdataPhoneNumberOnClick(nil)
    elseif self.openInfoIndex == 2 then
        log("显示修改昵称修改");
        self.UpdataNickNameOnClick();
    elseif self.openInfoIndex == 3 then
        log("显示修改头像");
        self.OpenChangeHead();
    elseif self.openInfoIndex == 4 then
        log("显示修改头像1");
        self.OpenChangeHead();
    elseif self.openInfoIndex == 5 then
        log("显示安全中心");
        -- 修改密码
        self.CheckIsOpenLoginCode();
        self.UpdataPasswordOnClick();
    else
        -- 默认值
    end

end

function PersonalInfoSystem.Init(obj, luaBehaviour)
    logError("个人信息初始化")
    local t = obj.transform;
    _obj = obj;
    -- 初始化面板，绑定点击事件
    self.PersonalInfoPanelCloseBtn = t:Find("Bg/CloseBtn").gameObject;
    self.PersonalInfoPanelCloseMaskBtn = t:Find("Image").gameObject;
    -- 提示界面
    self.waitPanel = t:Find("waitPanel").gameObject;
    self.waitPanel:SetActive(false);
    -- 修改密码后需要显示Btn
    self.BtnImg = t:Find("Bg/BtnBg").gameObject;
    -- 初始化界面
    self.defaultPanel = t:Find("Bg/defaultPanel").gameObject;
    self.defaultPanel:SetActive(true);
    -- 绑定手机界面
    self.SetPhonePanel = t:Find("Bg/SetPhonePanel").gameObject;
    -- 修改个人信息
    self.UpdateNamePanel = t:Find("Bg/UpdataNickNamePanel").gameObject;
    -- 修改头像界面
    self.PhonePanel = t:Find("PhonePanel").gameObject;
    -- 修改密码
    self.UpdatePasswordPanel = t:Find("Bg/UpdataPasswordPanel").gameObject;
    -- 修改头像
    self.ChangeHeadPanel = t:Find("Bg/ChangeHeadPanel").gameObject;
    -- 绑定手机按钮
    self.packBtn = t:Find("Bg/defaultPanel/packBtn").gameObject;
    -- 兑换新手卡
    self.DuiHuanBtn = t:Find("Bg/defaultPanel/DuiHuanBtn").gameObject;

    self.ChangeHeadBtn = t:Find("Bg/defaultPanel/ChangeHeadBtn").gameObject;
    -- Btn
    self.sendgoldbtn = self.BtnImg.transform:Find("sendgoldbtn").gameObject;
    -- 送/领红包
    self.UpdatePwdBtn = self.BtnImg.transform:Find("UpdatePasswordBtn").gameObject;
    -- 修改密码
    self.GetTicketBtn = self.BtnImg.transform:Find("GetTickteBtn").gameObject;
    -- 获取奖券（之前的赠送币）
    luaBehaviour:AddClick(self.UpdatePwdBtn, self.UpdataPasswordOnClick);
    luaBehaviour:AddClick(self.packBtn, self.UpdataPhoneNumberOnClick);
    luaBehaviour:AddClick(self.DuiHuanBtn, self.UpdataLeaveWord);
    luaBehaviour:AddClick(self.ChangeHeadBtn, self.OpenChangeHead);
    luaBehaviour:AddClick(self.sendgoldbtn, self.sendgoldbtnOnClick);
    luaBehaviour:AddClick(self.GetTicketBtn, self.GetTicketBtnOnClick);
    luaBehaviour:AddClick(self.PersonalInfoPanelCloseBtn, self.PersonalInfoPanelCloseBtnOnClick);
    luaBehaviour:AddClick(self.PersonalInfoPanelCloseMaskBtn, self.PersonalInfoPanelCloseBtnOnClick);
    -- 个人信息界面
    self.ID = self.defaultPanel.transform:Find("IDText/Text").gameObject;
    self.CopyIDBtn = self.defaultPanel.transform:Find("IDText/Copy").gameObject;
    self.Gold = self.defaultPanel.transform:Find("GoldText/Text").gameObject;
    self.BankGold = self.defaultPanel.transform:Find("BankText/Text").gameObject;
    self.Ticket = self.defaultPanel.transform:Find("TicketText/Text").gameObject;

    self.GoldAddBtn = self.defaultPanel.transform:Find("GoldText/Button")
    self.BankGoldAddBtn = self.defaultPanel.transform:Find("BankText/Button");

    local GoldAddClick = function()
        HallScenPanel.PlayeBtnMusic()
        --DuiHuanPanel.Open(luaBehaviour,"2")
    end

    luaBehaviour:AddClick(self.GoldAddBtn.gameObject, GoldAddClick);

    local BankGoldAddClick = function()
        PersonalInfoSystem.PersonalInfoPanelCloseBtnOnClick()
        HallScenPanel.OpenShopOnClick()
    end

    luaBehaviour:AddClick(self.BankGoldAddBtn.gameObject, BankGoldAddClick);
    -- 添加字体颜色
    --AddUTColor(self.Gold);
    --AddUTColor(self.Ticket);
    self.PlayerHeadIMG = self.defaultPanel.transform:Find("HeadBg/Image").gameObject;
    self.PlayerHead = self.defaultPanel.transform:Find("HeadBg").gameObject;
    self.NickName = self.defaultPanel.transform:Find("NickNameText/InputField").gameObject;

    self.NickNameTipText = self.defaultPanel.transform:Find("NickNameText/tipText"):GetComponent("Text")
    self.NickNameTipText.text = LogonScenPanel.GWData.CNameGold;

    --self.UpdateInfoBtn = self.defaultPanel.transform:Find("UpdateInfoBtn").gameObject;
    self.LeaveWordInput = self.defaultPanel.transform:Find("LeaveWord/InputField").gameObject;
    --if not Util.isAndroidPlatform then
    --luaBehaviour:AddEndEditEvent(self.LeaveWordInput, self.UpdataLeaveWord);
    luaBehaviour:AddEndEditEvent(self.NickName, self.UpdataNickName);
    --end
    --luaBehaviour:AddClick(self.UpdateInfoBtn, self.UpdataNickNameOnClick);
    luaBehaviour:AddClick(self.PlayerHead, self.OpenChangeHead);
    luaBehaviour:AddClick(self.CopyIDBtn, self.CopyIDCall);
    -- 修改昵称界面
    self.oldnameInputField = self.UpdateNamePanel.transform:Find("NickNameText/InputField").gameObject;
    self.NewnameInputField = self.UpdateNamePanel.transform:Find("NewNickNameText/InputField").gameObject;
    self.UpdataSex = self.UpdateNamePanel.transform:Find("UpdataSexText").gameObject;
    self.ToggleManBtn = self.UpdateNamePanel.transform:Find("UpdataSexText/ToggleManButton").gameObject;
    self.ToggleWomanBtn = self.UpdateNamePanel.transform:Find("UpdataSexText/ToggleWomanButton").gameObject;
    self.UpdateNameYesBtn = self.UpdateNamePanel.transform:Find("YesBtn").gameObject;
    self.UpdateNameNoBtn = self.UpdateNamePanel.transform:Find("NoBtn").gameObject;
    self.UpdateNameCloseBtn = self.UpdateNamePanel.transform:Find("CloseBtn").gameObject;
    self.NeedGoldTxt = self.UpdateNamePanel.transform:Find("NeedGoldTxt").gameObject;
    luaBehaviour:AddClick(self.ToggleManBtn, self.UpdateManSexOnClick);
    luaBehaviour:AddClick(self.ToggleWomanBtn, self.UpdateWomanSexOnClick);
    -- luaBehaviour:AddClick(self.UpdateNameYesBtn, self.UpdataNickNamePanel_YesBtnOnClick);
    luaBehaviour:AddClick(self.UpdateNameNoBtn, self.UpdataNickNamePanel_NoBtnOnClick);
    luaBehaviour:AddClick(self.UpdateNameCloseBtn, self.UpdataNickNamePanel_NoBtnOnClick)
    -- 修改密码
    self.myphone = self.UpdatePasswordPanel.transform:Find("PhoneInfo/Text").gameObject;
    self.setcodebtn = self.UpdatePasswordPanel.transform:Find("Button").gameObject;
    log("手机号：" .. SCPlayerInfo._29szPhoneNumber);
    if string.len(SCPlayerInfo._29szPhoneNumber) == 11 then
        local str = string.sub(SCPlayerInfo._29szPhoneNumber, 0, 3)
        local str1 = string.sub(SCPlayerInfo._29szPhoneNumber, 8, string.len(SCPlayerInfo._29szPhoneNumber))
        --self.DuiHuanBtn.transform.localPosition = Vector3.New(0, -300, 0);
        self.myphone:GetComponent("Text").text = str .. "****" .. str1;
    end
    if SCPlayerInfo._26bLoginValidate == 0 then
        self.setcodebtn.transform:Find("on").gameObject:SetActive(false);
        self.setcodebtn.transform:Find("off").gameObject:SetActive(true);
    else
        self.setcodebtn.transform:Find("on").gameObject:SetActive(true);
        self.setcodebtn.transform:Find("off").gameObject:SetActive(false);
    end
    logError("个人信息初始化2")
    self.oldPwdInputField = self.UpdatePasswordPanel.transform:Find("OldPwdText/InputField").gameObject;
    self.newPwdInputField = self.UpdatePasswordPanel.transform:Find("NewPwdText/InputField").gameObject;
    self.RenewPwdInputField = self.UpdatePasswordPanel.transform:Find("RePwdText/InputField").gameObject
    self.UpdatePasswordYesBtn = self.UpdatePasswordPanel.transform:Find("YesBtn").gameObject;
    self.UpdatePasswordNoBtn = self.UpdatePasswordPanel.transform:Find("NoBtn").gameObject;
    self.UpdatePasswordCloseBtn = self.UpdatePasswordPanel.transform:Find("CloseBtn").gameObject;
    luaBehaviour:AddClick(self.UpdatePasswordYesBtn, self.UpdataPasswordPanel_YesBtnOnClick);
    luaBehaviour:AddClick(self.UpdatePasswordNoBtn, self.UpdataPasswordPanel_NoBtnOnClick);
    luaBehaviour:AddClick(self.UpdatePasswordCloseBtn, self.UpdataPasswordPanel_NoBtnOnClick);
    luaBehaviour:AddClick(self.setcodebtn, self.SetCodeBtnOnClick);
    -- 绑定手机
    self.setNewPwdInputField = self.SetPhonePanel.transform:Find("PassWordText/InputField").gameObject;
    self.ResetNewPwdInputField = self.SetPhonePanel.transform:Find("RePassWordText/InputField").gameObject;
    self.setPhoneNumberInputField = self.SetPhonePanel.transform:Find("PhoneNumberText/InputField").gameObject;
    self.CodeInputField = self.SetPhonePanel.transform:Find("CodeText/InputField").gameObject;
    self.SetPhoneGetCodeBtn = self.SetPhonePanel.transform:Find("CodeText/GetCodeBtn").gameObject;
    self.GetCodeTxt = self.SetPhonePanel.transform:Find("CodeText/GetCodeBtn/Time"):GetComponent("Text");
    self.GetCodeTxt.text = " "
    logError("个人信息初始化3")
    self.SetPhoneYesBtn = self.SetPhonePanel.transform:Find("YesBtn").gameObject;
    self.SetPhoneNoBtn = self.SetPhonePanel.transform:Find("NoBtn").gameObject;
    self.SetPhoneCloseBtn = self.SetPhonePanel.transform:Find("CloseBtn").gameObject;
    luaBehaviour:AddClick(self.SetPhoneYesBtn, self.BindingPhoneNumeberPanel_YesBtnOnClick);
    luaBehaviour:AddClick(self.SetPhoneNoBtn, self.BindingPhoneNumeberPanel_NoBtnOnClick);
    luaBehaviour:AddClick(self.SetPhoneCloseBtn, self.BindingPhoneNumeberPanel_NoBtnOnClick)
    luaBehaviour:AddClick(self.SetPhoneGetCodeBtn, self.UpdataNickNamePanel_GetCodeBtnOnClick);
    -- 修改头像
    self.PhoneCloseBtn = self.PhonePanel.transform:Find("CloseBtn").gameObject;
    self.PhoneNoBtn = self.PhonePanel.transform:Find("NoBtn").gameObject;
    self.PhoneLocalPhoneBtn = self.PhonePanel.transform:Find("LocalPhoneBtn").gameObject;
    self.PhoneBtn = self.PhonePanel.transform:Find("Phone").gameObject;
    self.PhonePanel_Img = self.PhonePanel.transform:Find("PlayerHeadIMG2/Image").gameObject;
    luaBehaviour:AddClick(self.PhoneCloseBtn, self.PhonePanel_NoBtnOnClick);
    luaBehaviour:AddClick(self.PhoneNoBtn, self.PhonePanel_NoBtnOnClick);
    luaBehaviour:AddClick(self.PhoneLocalPhoneBtn, self.LocalPhoneBtnOnClick)
    luaBehaviour:AddClick(self.PhoneBtn, self.PhoneCameraBtnOnClick);

    self.UpdataPersonalInfo()
    self.ShowInfo_Personal();
    HallScenPanel.MidCloseBtn = self.PersonalInfoPanelCloseBtnOnClick
    Event.AddListener(PanelListModeEven._015ChangeGoldTicket, self.UpdatePanleGoldTextInfo);

    self.HeadSelectArea = self.ChangeHeadPanel.transform:Find("SelectArea"):GetComponent("ScrollRect");
    for i = 0, HallScenPanel.headIcons.childCount - 1 do
        local child = nil;
        if i < self.HeadSelectArea.content.childCount then
            child = self.HeadSelectArea.content:GetChild(i).gameObject;
        else
            child = newobject(self.HeadSelectArea.content:GetChild(0).gameObject);
            child.transform:SetParent(self.HeadSelectArea.content);
            child.transform.localScale = Vector3.New(1, 1, 1);
            child.transform.localPosition = Vector3.New(0, 0, 0);
        end
        if i == SCPlayerInfo.faceID - 1 then
            child.transform:Find("Select").gameObject:SetActive(true);
            self.currentHeadSelect = child;
        else
            child.transform:Find("Select").gameObject:SetActive(false);
        end
        child.transform:Find("Bg").gameObject:SetActive(true);
        child.transform:GetComponent("Image").sprite = HallScenPanel.headIcons:GetChild(i):GetComponent("Image").sprite;
        child.transform:Find("Bg"):GetComponent("Image").sprite = HallScenPanel.headIcons:GetChild(i):GetComponent("Image").sprite;

        luaBehaviour:AddClick(child, self.SelectHeadCall);
    end

    self.changeHeadBtn = self.ChangeHeadPanel.transform:Find("Sure").gameObject;
    self.closeChangeHeadBtn = self.ChangeHeadPanel.transform:Find("Close").gameObject;
    luaBehaviour:AddClick(self.changeHeadBtn, self.ChangeHeadCall);
    luaBehaviour:AddClick(self.closeChangeHeadBtn, self.CloseChangeHeadPanelCall);
    self.ChangeHeadPanel.gameObject:SetActive(false);
end
self.currentHeadSelect = nil;
function PersonalInfoSystem.SelectHeadCall(go)
    HallScenPanel.PlayeBtnMusic()

    if self.currentHeadSelect ~= nil then
        self.currentHeadSelect.transform:Find("Select").gameObject:SetActive(false);
        self.currentHeadSelect.transform:Find("Bg").gameObject:SetActive(true);
    end
    go.transform:Find("Select").gameObject:SetActive(true);
    --go.transform:Find("Bg").gameObject:SetActive(false);
    self.currentHeadSelect = go;
end
function PersonalInfoSystem.ChangeHeadCall(go)
    HallScenPanel.PlayeBtnMusic()

    local bytebuffer = ByteBuffer.New();
    log("==========当前选中" .. (self.currentHeadSelect.transform:GetSiblingIndex()));
    bytebuffer:WriteByte(self.currentHeadSelect.transform:GetSiblingIndex() + 1);
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_ChangeHeader, bytebuffer, gameSocketNumber.HallSocket);
end
function PersonalInfoSystem.CloseChangeHeadPanelCall(go)
    if go~=nil then
        HallScenPanel.PlayeBtnMusic() 
    end
    self.ChangeHeadPanel.gameObject:SetActive(false);
end
function PersonalInfoSystem.UpdatePanleGoldTextInfo()
    if (self.PersonalInfoPanel == nil) then
        return
    end
    self.Gold:GetComponent('Text').text = tostring(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD));
    --self.BankGold:GetComponent('Text').text = tostring(gameData.GetProp(enum_Prop_Id.E_PROP_STRONG));
end

function PersonalInfoSystem.CopyIDCall()
    HallScenPanel.PlayeBtnMusic()

    local strID = self.ID:GetComponent('Text').text;
    Util.CopyStr(strID);
    MessageBox.CreatGeneralTipsPanel("复制ID成功");
end
--struct CMD_3D_CS_LOGINVERIFY
--{
--	BYTE cbType;		// 0:查询 1: 更改
--	BYTE cbLoginVerify;	// 0:不开启 1:开启
--};
function PersonalInfoSystem.CheckIsOpenLoginCode()
    if string.length(SCPlayerInfo._29szPhoneNumber) < 11 then
        return ;
    end
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    buffer:WriteByte(0);
    log("查询是否开启登录验证")
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_QUERYLOGINVERIFY, buffer, gameSocketNumber.HallSocket);
end
--struct CMD_3D_SC_LoginVerify_Res
--{
--	BYTE cbResult;		// 0：成功 1：失败
--	BYTE cbType;		// 0:查询 1: 更改
--	BYTE cbLoginVerify;	// 0:不开启 1:开启
--};
function PersonalInfoSystem.CheckLoginCodeBack(buffer)

    local su = buffer:ReadByte();
    local t = buffer:ReadByte();
    local v = buffer:ReadByte();
    log("返回登录验证消息 状态：" .. su);
    log(" 类型：" .. t);
    log(" 值：" .. v);
    if su == 1 then
        MessageBox.CreatGeneralTipsPanel("修改失败");
    end

    if t == 0 then
        if v == 0 then
            self.setcodebtn.transform:Find("on").gameObject:SetActive(false);
            self.setcodebtn.transform:Find("off").gameObject:SetActive(true);
        else
            self.setcodebtn.transform:Find("on").gameObject:SetActive(true);
            self.setcodebtn.transform:Find("off").gameObject:SetActive(false);
        end
    else
        if v == 0 then
            self.setcodebtn.transform:Find("on").gameObject:SetActive(false);
            self.setcodebtn.transform:Find("off").gameObject:SetActive(true);
        else
            self.setcodebtn.transform:Find("on").gameObject:SetActive(true);
            self.setcodebtn.transform:Find("off").gameObject:SetActive(false);
        end
        SCPlayerInfo._26bLoginValidate = v;
    end
end
function PersonalInfoSystem.OpenChangeHead()
    HallScenPanel.PlayeBtnMusic()
    --self.LocalPhoneBtnOnClick()
    self.ChangeHeadPanel.gameObject:SetActive(true);
    self.SelectHeadCall(self.HeadSelectArea.content:GetChild(SCPlayerInfo.faceID - 1).gameObject);
    -- self.PhonePanel.transform.localPosition = Vector3.New(0, 0, 0);
    -- self.PhonePanel:SetActive(true);
end
--- 初始化个人信息面板必要的显示参数（比如昵称 帐号等）
function PersonalInfoSystem.UpdataPersonalInfo()
    logError("更新信息")
    if tonumber(SCPlayerInfo._29szPhoneNumber) and string.len(SCPlayerInfo._29szPhoneNumber) == 11 then
        --self.SetPhoneBtn.transform.localPosition = Vector3.New(1500, 1500, 0)
        --self.SetPhoneBtn:SetActive(false);
        -- self.DuiHuanBtn:SetActive(true);
        -- self.DuiHuanBtn.transform.localPosition = Vector3.New(0, -300, 0)
    else
        --self.SetPhoneBtn.transform.localPosition = Vector3.New(-220, -300, 0)
        -- self.DuiHuanBtn:SetActive(true);
        -- self.DuiHuanBtn.transform.localPosition = Vector3.New(220, -300, 0)
        --self.BtnImg.transform.localPosition = Vector3.New(1500, 1500, 0)
        self.BtnImg:SetActive(false);
        -- self.SetPhoneBtn:SetActive(true);
    end
    -- 初始化界面信息
    self.NickName:GetComponent('InputField').text = SCPlayerInfo._05wNickName;
    self.ID:GetComponent('Text').text = SCPlayerInfo._beautiful_Id;
    self.Gold:GetComponent('Text').text = tostring(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD));
    --self.BankGold:GetComponent('Text').text = tostring(gameData.GetProp(enum_Prop_Id.E_PROP_STRONG));
    self.Ticket:GetComponent('Text').text = tostring(gameData.GetProp(enum_Prop_Id.E_PROP_TICKET));
    updateSex = SCPlayerInfo._02bySex;
    -- 显示头像
    HallScenPanel.GetHeadIcon()
    self.PlayerHeadIMG:GetComponent("Image").sprite = HallScenPanel.Compose.transform:Find("HeadImg/Image/Image/Image"):GetComponent("Image").sprite;
    self.PhonePanel_Img:GetComponent("Image").sprite = HallScenPanel.Compose.transform:Find("HeadImg/Image/Image/Image"):GetComponent("Image").sprite;
    -- 性别
    if SCPlayerInfo._02bySex == enum_Sex.E_SEX_WOMAN then
        self.UpdataSex.transform:Find("ToggleWoman"):GetComponent('Toggle').isOn = true;
        self.UpdataSex.transform:Find("ToggleMan"):GetComponent('Toggle').isOn = false;
    else
        self.UpdataSex.transform:Find("ToggleMan"):GetComponent('Toggle').isOn = true;
        self.UpdataSex.transform:Find("ToggleWoman"):GetComponent('Toggle').isOn = false;
    end
    updateSex = SCPlayerInfo._02bySex;
    -- 初始化信息
    if SCPlayerInfo._17bHasChangeNameOrSex == 1 then
        self.NeedGoldTxt:GetComponent('Text').text = " "
        -- "提示：修改昵称、性别需要消耗" .. SCSystemInfo._9dwChangeNickNameOrSexNeedGold .. "金币。"
    else
        self.NeedGoldTxt:GetComponent('Text').text = "提示：第一次修改昵称、性别,有金币相送。"
    end
    
    self.SetPhonePanel:SetActive(false);
    -- 修改个人信息
    self.UpdateNamePanel:SetActive(false);
    -- 修改密码
    self.UpdatePasswordPanel:SetActive(false);
    -- 修改头像界面没有
    if gameIsOnline then
        self.PhonePanel:SetActive(false);
    else
    end
    -- 红点
    self.FromPanel = self.defaultPanel;
    self.NeedGoldTxt.transform.localPosition = Vector3.New(110, -20, 0);
    if string.find(SCPlayerInfo._08wSign, "这个人很懒") then
        -- self.LeaveWordInput:GetComponent('InputField').text="请输入你的个性签名...";--SCPlayerInfo._08wSign
    else
        self.LeaveWordInput:GetComponent('InputField').text = SCPlayerInfo._08wSign;
    end
    if SCPlayerInfo._13bHasGetExchangeCodeAward == true then
        --  self.DuiHuanBtn:SetActive(false);
    else
        --  self.DuiHuanBtn:SetActive(true);
    end
    self.isReflushSignAndName = true;
    error("_______SCPlayerInfo._08wSign_______" .. SCPlayerInfo._08wSign .. SCPlayerInfo._13bHasGetExchangeCodeAward);
end
function PersonalInfoSystem.IsChangeLeave()
    self.LeaveWordInputField:GetComponent('InputField').interactable = true;
    self.LeaveBtn:SetActive(false);
end
-- 发送修改签名
function PersonalInfoSystem.UpdataLeaveWord(go, args)
    args = self.LeaveWordInput:GetComponent('InputField').text
    error("____000_______UpdataLeaveWord________" .. args);
    if args == "" then
        return
    end ;
    if args == nil then
        return
    end ;
    if args == SCPlayerInfo._08wSig then
        return
    end ;
    if args ~= SCPlayerInfo._08wSign then
        local str = args;
        local buffer = ByteBuffer.New();
        buffer:WriteBytes(50, str);
        error("___________UpdataLeaveWord________" .. str);
        Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_CHANGE_SIGN, buffer, gameSocketNumber.HallSocket);
    end
end
-- 返回成功消息
function PersonalInfoSystem.LeaveWordCallBack(issc, errmess)
    error("___________LeaveWordCallBack______");
    if issc == 0 then
        SCPlayerInfo._08wSign = self.LeaveWordInput:GetComponent('InputField').text;
        MessageBox.CreatGeneralTipsPanel("修改签名成功");
        self.isReflushSignAndName = true;
    else
        MessageBox.CreatGeneralTipsPanel(self.creatMessBoxData(errmess, self.creatUpdataSignError));
    end
end


-- 个人信息面板的关闭按钮事件
function PersonalInfoSystem.PersonalInfoPanelCloseBtnOnClick()
    MoveNotifyInfoClass.getcodefuntion = nil;
    self.isReflushSignAndName = false;
    self.openInfoIndex = nil;
    HallScenPanel.PlayeBtnMusic();
    --Event.RemoveListener(PanelListModeEven._015ChangeGoldTicket, self.UpdatePanleGoldTextInfo);
    destroy(self.PersonalInfoPanel);
    self.PersonalInfoPanel = nil;
    HallScenPanel.MidCloseBtn = nil;
    HallScenPanel.BackHallOnClick();
end
-- 更新头像点击事件
function PersonalInfoSystem.UpdataHeadOnClick()
    HallScenPanel.PlayeBtnMusic();
    self.ChangePasswordBtn:SetActive(false);
    self.ChangeNickNameBtn:SetActive(false);
    self.BindingPhoneNumberBtn:SetActive(false);
    self.sendgoldbtn:SetActive(false);
    self.BtnImg:SetActive(false);
    self.PhonePanel:SetActive(true);
    --  self.defaultPanel.transform.localPosition = Vector3.New(0, 1000, 0);
    if self.FromPanel.name ~= self.defaultPanel.name then
        self.RightHead:SetActive(false);
    end
    self.FromPanel:SetActive(false);
    self.ShowPanel(self.PhonePanel);
end
-- 更新密码点击事件
function PersonalInfoSystem.UpdataPasswordOnClick()
    HallScenPanel.PlayeBtnMusic();
    -- self.ShowPanel(self.UpdatePasswordPanel);
    self.defaultPanel:SetActive(false);
    self.UpdatePasswordPanel.transform.localPosition = Vector3.New(900, 0, 0)
    self.UpdatePasswordPanel.transform:DOLocalMoveX(0, 0.2, false):SetEase(DG.Tweening.Ease.Linear);
    self.UpdatePasswordPanel:SetActive(true);
    if (SCPlayerInfo._06wPassword == "") then
        self.oldPwdInputField:GetComponent('InputField').interactable = false;
        self.oldPwdInputField.transform:Find("Placeholder"):GetComponent('Text').text = "游客帐号无原密码";
    end
end
-- 更新昵称点击事件
function PersonalInfoSystem.UpdataNickNameOnClick()
    HallScenPanel.PlayeBtnMusic();
    self.oldnameInputField:GetComponent('InputField').interactable = false;
    self.oldnameInputField.transform:Find("Placeholder"):GetComponent('Text').text = SCPlayerInfo._05wNickName;
    self.UpdateNamePanel:SetActive(true);
    self.ShowPanel(self.UpdateNamePanel);
end
-- 绑定手机点击事件
function PersonalInfoSystem.UpdataPhoneNumberOnClick(obj)
    HallScenPanel.PlayeBtnMusic()
    --MessageBox.CreatGeneralTipsPanel("功能暂未开放");
    MyBackpackPanel.Open(HallScenPanel.LuaBehaviour)
    logYellow("查看背包")
    -- if obj == nil then
    --     self.defaultPanel:SetActive(false);
    -- end
    -- HallScenPanel.PlayeBtnMusic();
    -- if tonumber(SCPlayerInfo._29szPhoneNumber) and string.len(SCPlayerInfo._29szPhoneNumber) == 11 then
    --     local str = string.sub(SCPlayerInfo._29szPhoneNumber, 0, 3)
    --     local str1 = string.sub(SCPlayerInfo._29szPhoneNumber, 8, string.len(SCPlayerInfo._29szPhoneNumber))
    --     log(SCPlayerInfo._29szPhoneNumber);
    --     self.myphone:GetComponent("Text").text = str .. "****" .. str1;
    -- end
    -- self.SetPhonePanel.transform.localPosition = Vector3.New(2000, 0, 0);
    -- self.SetPhonePanel:SetActive(true);
    -- self.SetPhonePanel.transform:DOLocalMoveX(0, 0.2, false):SetEase(DG.Tweening.Ease.Linear);
    -- self.defaultPanel.transform:DOLocalMoveX(-2000, 0.2, false):SetEase(DG.Tweening.Ease.Linear);
    -- self.defaultPanel.gameObject:SetActive(false);
end

-- 赠送币按钮点击
self.istwocallclose = false;-- 是不是要二次调用关闭
function PersonalInfoSystem.sendgoldbtnOnClick(args)
    HallScenPanel.PlayeBtnMusic()
    self.istwocallclose = false;
    self.PersonalInfoPanelCloseBtnOnClick();
    if self.istwocallclose == true then
        self.PersonalInfoPanelCloseBtnOnClick();
    end
    Event.Brocast(PanelListModeEven._007redPackagePanel);
end

-- 获取奖券按钮
function PersonalInfoSystem.GetTicketBtnOnClick()
    HallScenPanel.PlayeBtnMusic()
    self.istwocallclose = false;
    self.PersonalInfoPanelCloseBtnOnClick();
    if self.istwocallclose == true then
        self.PersonalInfoPanelCloseBtnOnClick();
    end
    Event.Brocast(PanelListModeEven._009cornucopiaPanel);
    self.PersonalInfoPanelCloseBtnOnClick();
end

function PersonalInfoSystem.UpdataNickNamePanel_GetCodeBtnOnClick(obj)
    HallScenPanel.PlayeBtnMusic();
    obj.transform:GetComponent("Button").interactable = false;
    local NewPhoneNumber = self.setPhoneNumberInputField:GetComponent('InputField').text;
    if string.len(NewPhoneNumber) ~= 11 then
        -- self.Notice("无效手机号");
        MessageBox.CreatGeneralTipsPanel("无效手机号")
        self.SetPhoneGetCodeBtn:GetComponent('Button').interactable = true;
        return ;
    end
    self.SetPhoneGetCodeBtn:GetComponent('Button').interactable = false;
    if string.length(SCPlayerInfo._29szPhoneNumber) >= 11 then
        MessageBox.CreatGeneralTipsPanel("手机号已经绑定")
        self.SetPhoneGetCodeBtn:GetComponent('Button').interactable = true;
        return ;
    else
        MoveNotifyInfoClass.getcodetime = 60;
        MoveNotifyInfoClass.getcodefuntion = PersonalInfoSystem.UpdataNickNamePanel_GetCodeTimeCallBack;
        self.GetCodeTxt.text = "60s again";
        coroutine.start(MoveNotifyInfoClass.GetCodeTime)
        Event.AddListener(tostring(MH.SUB_3D_SC_DOWN_GAME_RESOURCE), self.UpdataNickNamePanel_GetCodeBtnCallBack);
        local bf = ByteBuffer.New();
        bf:WriteBytes(1, 1);
        bf:WriteBytes(1, 1);
        bf:WriteBytes(DataSize.String12, NewPhoneNumber);
        --bf:WriteBytes(50,Opcodes);

        Network.Send(MH.MDM_3D_LOGIN, MH.SUB_3D_SC_DOWN_GAME_RESOURCE, bf, gameSocketNumber.HallSocket);
    end
end
-- 验证码倒计时时间
function PersonalInfoSystem.UpdataNickNamePanel_GetCodeTimeCallBack()
    if self.PersonalInfoPanel == nil then
        return
    end
    --  error("MoveNotifyInfoClass.getcodetime================"..MoveNotifyInfoClass.getcodetime);
    if self.GetCodeTxt == nil then
        return
    end
    self.GetCodeTxt.text = MoveNotifyInfoClass.getcodetime .. "s again"
    if MoveNotifyInfoClass.getcodetime <= 0 then
        self.GetCodeTxt.text = " "
        self.SetPhoneGetCodeBtn:GetComponent('Button').interactable = true;
    end
end
-- 获取验证码按钮事件的回调
function PersonalInfoSystem.UpdataNickNamePanel_GetCodeBtnCallBack(data)
    Event.RemoveListener(tostring(MH.SUB_3D_SC_DOWN_GAME_RESOURCE));
    local str = tostring(data[1]);
    --   error("str==============" .. str);
    if str == "0" then
        MessageBox.CreatGeneralTipsPanel("手机号已经绑定")
        --  self.SetPhoneGetCodeBtn:GetComponent('Button').interactable = true;
        return ;
    end
end

function PersonalInfoSystem.UpdateWomanSexOnClick()
    HallScenPanel.PlayeBtnMusic()

    if updateSex == enum_Sex.E_SEX_MAN then
        self.UpdataSex.transform:Find("ToggleWoman"):GetComponent('Toggle').isOn = true;
        self.UpdataSex.transform:Find("ToggleMan"):GetComponent('Toggle').isOn = false;
        updateSex = enum_Sex.E_SEX_WOMAN;
    end
end
function PersonalInfoSystem.UpdateManSexOnClick()
    HallScenPanel.PlayeBtnMusic()

    if updateSex == enum_Sex.E_SEX_WOMAN then
        self.UpdataSex.transform:Find("ToggleMan"):GetComponent('Toggle').isOn = true;
        self.UpdataSex.transform:Find("ToggleWoman"):GetComponent('Toggle').isOn = false;
        updateSex = enum_Sex.E_SEX_MAN;
    end
end

-- 个人信息面板下的密码更新面板确认按钮
function PersonalInfoSystem.UpdataPasswordPanel_YesBtnOnClick()
    HallScenPanel.PlayeBtnMusic()

    self.UpdatePasswordYesBtn:GetComponent('Button').interactable = false;
    local oldPwd = self.oldPwdInputField:GetComponent('InputField').text;
    local newPwd = self.newPwdInputField:GetComponent('InputField').text;
    local ConfirmPwd = self.RenewPwdInputField:GetComponent('InputField').text;
    --if SCPlayerInfo._06wPassword == "" then oldPwd = ""; end
    --[[if MD5Helper.MD5String(oldPwd) ~= SCPlayerInfo._06wPassword then
    MessageBox.CreatGeneralTipsPanel("输入的信息有误，请确认你原密码是否正确"..SCPlayerInfo._06wPassword)
    self.UpdatePasswordYesBtn:GetComponent('Button').interactable = true;
    return;
end--]]
    if not (self.PwdFun(newPwd)) then
        MessageBox.CreatGeneralTipsPanel("输入的信息有误，请确认你新密码是否正确")
        self.UpdatePasswordYesBtn:GetComponent('Button').interactable = true;
        return
    end ;
    if not (self.PwdFun(ConfirmPwd)) and ConfirmPwd == newPwd then
        MessageBox.CreatGeneralTipsPanel("输入的信息有误，请确认你确认密码是否正确")
        self.UpdatePasswordYesBtn:GetComponent('Button').interactable = true;
        return
    end ;
    if newPwd ~= ConfirmPwd then
        MessageBox.CreatGeneralTipsPanel("两次输入的密码不同，请重新输入")
        self.UpdatePasswordYesBtn:GetComponent('Button').interactable = true;
        return
    end ;
    local data = {
        [1] = MD5Helper.MD5String(self.oldPwdInputField:GetComponent('InputField').text),
        [2] = MD5Helper.MD5String(self.newPwdInputField:GetComponent('InputField').text),
    }
    log("修改密码：" .. data[1] .. "  " .. data[2]);
    local buffer = SetC2SInfo(CS_ChangePassword, data)
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_CHANGE_PASSWORD, buffer, gameSocketNumber.HallSocket);
end
function PersonalInfoSystem.UpdataPasswordPanelCallBack(data, size)
    changePassWordPanel.UpdataPasswordPanelCallBack()

    --self.UpdatePasswordYesBtn:GetComponent('Button').interactable = true;
    if size == 0 then
        MessageBox.CreatGeneralTipsPanel("修改密码成功");
        SCPlayerInfo._06wPassword = MD5Helper.MD5String(self.RenewPwdInputField:GetComponent('InputField').text);
        self.SaveAccount(false);
    else
        MessageBox.CreatGeneralTipsPanel("修改密码失败" .. data:ReadString(size));
    end
    -- self.oldPwdInputField:GetComponent('InputField').text = "";
    -- self.newPwdInputField:GetComponent('InputField').text = "";
    -- self.RenewPwdInputField:GetComponent('InputField').text = "";
end
-- 个人信息面板下的密码更新面板取消按钮
function PersonalInfoSystem.UpdataPasswordPanel_NoBtnOnClick()
    HallScenPanel.PlayeBtnMusic()

    self.ShowPanel(self.UpdatePasswordPanel);
    self.UpdatePasswordPanel:SetActive(false);
end

--	BYTE cbResult;		// 0：成功 1：失败
--	BYTE cbType;		// 0:查询 1: 更改
--	BYTE cbLoginVerify;	// 0:不开启 1:开启
-- 设置是否开启登录验证
function PersonalInfoSystem.SetCodeBtnOnClick(obj)
    HallScenPanel.PlayeBtnMusic()

    obj.transform:GetComponent("Button").interactable = false
    local data = 0;
    if SCPlayerInfo._26bLoginValidate == 0 then
        data = 1;
    end
    if SCPlayerInfo._26bLoginValidate == 1 then
        data = 0;
    end
    local buffer = ByteBuffer.New();
    buffer:WriteByte(1);
    buffer:WriteByte(data);
    log("修改登录验证状态：" .. data);
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_QUERYLOGINVERIFY, buffer, gameSocketNumber.HallSocket);
    obj.transform:GetComponent("Button").interactable = true
end
-- 设置登录验证成功
function PersonalInfoSystem.SetCodeBtnSuccess(buffer, wSize)
    MessageBox.CreatGeneralTipsPanel("设置登录验证成功");
    SCPlayerInfo._26bLoginValidate = buffer:ReadByte();

    if SCPlayerInfo._26bLoginValidate == 0 then
        self.setcodebtn.transform:Find("on").gameObject:SetActive(false);
        self.setcodebtn.transform:Find("off").gameObject:SetActive(true);
    end
    if SCPlayerInfo._26bLoginValidate == 1 then
        self.setcodebtn.transform:Find("on").gameObject:SetActive(true);
        self.setcodebtn.transform:Find("off").gameObject:SetActive(false);
    end
end

function PersonalInfoSystem.UpdataNickName(go, str)
    log("UpdataNickName")
    local NewNickName = str;
    NewNickName = string.gsub(NewNickName, " ", "");
    if NewNickName == SCPlayerInfo._05wNickName then
        return
    end ;
    if string.len(NewNickName) == 0 then
        MessageBox.CreatGeneralTipsPanel(self.creatMessBoxData("输入的昵称有误，请重新输入", self.creatUpdataNameError));
        return
    end
    if self.StrIsTrue(NewNickName, 0, 7) == 0 then
        MessageBox.CreatGeneralTipsPanel(self.creatMessBoxData("输入的昵称过长，请重新输入", self.creatUpdataNameError));
        return
    end
    if not (self.Newname(NewNickName)) then
        MessageBox.CreatGeneralTipsPanel(self.creatMessBoxData("输入的昵称有误，请重新输入", self.creatUpdataNameError));
        return
    end
    local data = {
        [1] = NewNickName,
        [2] = SCPlayerInfo._02bySex,
    }
    local buffer = SetC2SInfo(CS_ChangeNickName, data);
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_CHANGE_NICKNAME, buffer, gameSocketNumber.HallSocket);
end

function PersonalInfoSystem.creatUpdataNameError(args)
    self.NickName:GetComponent('InputField').text = SCPlayerInfo._05wNickName;
    self.isReflushSignAndName = true;
end
function PersonalInfoSystem.creatUpdataSignError(args)
    if string.find(SCPlayerInfo._08wSign, "这个人很懒") then
        self.LeaveWordInput:GetComponent("InputField").text = "";
    else
        self.LeaveWordInput:GetComponent('InputField').text = SCPlayerInfo._08wSign;
    end
    self.isReflushSignAndName = true;
end
function PersonalInfoSystem.creatMessBoxData(args, fun)
    local sdata = { };
    sdata._01_Title = "提示";
    sdata._02_Content = args;
    sdata._03_ButtonNum = 1;
    sdata._04_YesCallFunction = fun;
    sdata._05_NoCallFunction = nil;
    return sdata;
end



-- 个人信息面板下的昵称更新面板确认按钮
function PersonalInfoSystem.UpdataNickNamePanel_YesBtnOnClick()
    log("UpdataNickNamePanel_YesBtnOnClick")

    local btn = self.UpdateNameYesBtn:GetComponent('Button');
    -- 给服务器发送修改昵称的信息
    local NickName = SCPlayerInfo._05wNickName;
    local NewNickName = self.NickName:GetComponent('InputField').text;
    if updateSex ~= SCPlayerInfo._02bySex and string.len(NewNickName) == 0 then
        NewNickName = SCPlayerInfo._05wNickName;
    else
        -- 去除空格
        NewNickName = string.gsub(NewNickName, " ", "");
        if string.len(NewNickName) == 0 then
            MessageBox.CreatGeneralTipsPanel("昵称不能为空，请重新输入");
            btn.interactable = true;
            return
        end
        -- if string.len(NewNickName)>7 then MessageBox.CreatGeneralTipsPanel("输入的昵称过长，请确认你输入的的新昵称是否正确"); btn.interactable = true; return end
        if self.StrIsTrue(NewNickName, 0, 6) == 0 then
            MessageBox.CreatGeneralTipsPanel("输入的昵称过长，请重新输入");
            btn.interactable = true;
            return
        end
        if not (self.Newname(NewNickName)) then
            MessageBox.CreatGeneralTipsPanel("输入的昵称有误，请重新输入");
            btn.interactable = true;
            return
        end
        if NewNickName == NickName then
            MessageBox.CreatGeneralTipsPanel("新昵称与旧昵称相同，请重新输入");
            btn.interactable = true;
            return
        end ;
    end
    local sexMan = self.UpdateNamePanel.transform:Find("UpdataSexText/ToggleMan"):GetComponent('Toggle');
    local sexWoman = self.UpdateNamePanel.transform:Find("UpdataSexText/ToggleWoman"):GetComponent('Toggle');
    local sex = enum_Sex.E_SEX_NULL;
    if sexMan.isOn then
        sex = enum_Sex.E_SEX_MAN
    end
    if sexWoman.isOn then
        sex = enum_Sex.E_SEX_WOMAN
    end
    local data = {
        [1] = NewNickName,
        [2] = sex,
    }
    local buffer = SetC2SInfo(CS_ChangeNickName, data);
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_CHANGE_NICKNAME, buffer, gameSocketNumber.HallSocket);
end
-- 个人信息面板修改昵称的回调
function PersonalInfoSystem.UpdataNickNameCallBack(buffer, size)
    if size == 0 then
        if SCPlayerInfo._02bySex == updateSex then
            SCPlayerInfo._05wNickName = self.NickName:GetComponent('InputField').text;
            self.NickName:GetComponent('InputField').text = SCPlayerInfo._05wNickName;
            HallScenPanel.HeadIoc.transform:Find("PlayerName"):GetComponent('Text').text = SCPlayerInfo._05wNickName;
            SCPlayerInfo._02bySex = updateSex;
            MessageBox.CreatGeneralTipsPanel("修改信息成功");
            SCPlayerInfo._17bHasChangeNameOrSex = 1;
            self.UpdataNickNamePanel_NoBtnOnClick();
            self.isReflushSignAndName = true;
        else
            SCPlayerInfo._02bySex = updateSex;
            local NewNickName = self.NewnameInputField:GetComponent('InputField').text
            if string.len(NewNickName) > 0 then
                SCPlayerInfo._05wNickName = self.NewnameInputField:GetComponent('InputField').text;
                self.NickName:GetComponent('InputField').text = SCPlayerInfo._05wNickName;
                HallScenPanel.HeadIoc.transform:Find("PlayerName"):GetComponent('Text').text = SCPlayerInfo._05wNickName;
            end
            if SCPlayerInfo._02bySex == enum_Sex.E_SEX_WOMAN then
                self.UpdateNamePanel.transform:Find("UpdataSexText/ToggleWoman"):GetComponent('Toggle').isOn = true;
                self.UpdateNamePanel.transform:Find("UpdataSexText/ToggleMan"):GetComponent('Toggle').isOn = false;
            else
                self.UpdateNamePanel.transform:Find("UpdataSexText/ToggleMan"):GetComponent('Toggle').isOn = true;
                self.UpdateNamePanel.transform:Find("UpdataSexText/ToggleWoman"):GetComponent('Toggle').isOn = false;
            end
            MessageBox.CreatGeneralTipsPanel("修改成功");
            self.UpdataNickNamePanel_NoBtnOnClick();
            self.isReflushSignAndName = true;
        end
        -- 修改性别后，切换玩家头像
        if SCPlayerInfo._03bCustomHeader == 0 then
            if SCPlayerInfo._02bySex == enum_Sex.E_SEX_MAN then
                --HallScenPanel.Compose.transform:Find("HeadImg/Image").gameObject:GetComponent('Image').sprite = HallScenPanel.nanSprtie;
                self.PlayerHeadIMG:GetComponent("Image").sprite = HallScenPanel.nanSprtie;
                self.PlayerHeadIMG:GetComponent("Image").sprite = HallScenPanel.nanSprtie;
            elseif SCPlayerInfo._02bySex == enum_Sex.E_SEX_WOMAN then
                --HallScenPanel.Compose.transform:Find("HeadImg/Image/Image/Image").gameObject:GetComponent('Image').sprite = HallScenPanel.nvSprtie;
                self.PlayerHeadIMG:GetComponent("Image").sprite = HallScenPanel.nvSprtie;
                self.PlayerHeadIMG:GetComponent("Image").sprite = HallScenPanel.nvSprtie;
            end
        end
        if SCPlayerInfo._17bHasChangeNameOrSex == 0 then
            SCPlayerInfo._17bHasChangeNameOrSex = 1;
            self.NeedGoldTxt:GetComponent('Text').text = "提示：修改昵称、性别需要消耗" .. SCSystemInfo._9dwChangeNickNameOrSexNeedGold .. "金币。"
        end
    else
        self.UpdateNameYesBtn:GetComponent('Button').interactable = true;
        MessageBox.CreatGeneralTipsPanel(self.creatMessBoxData("修改失败：" .. buffer:ReadString(size), self.creatUpdataNameError));
    end
    self.UpdateNameYesBtn:GetComponent('Button').interactable = true;
    self.NewnameInputField:GetComponent('InputField').text = "";
    self.PlayerHeadIMG:GetComponent("Image").sprite = HallScenPanel.GetHeadIcon();
    HallScenPanel.Compose.transform:Find("HeadImg/Image/Image/Image").gameObject:GetComponent('Image').sprite = HallScenPanel.GetHeadIcon();
end
-- 个人信息面板下的昵称更新面板取消按钮
function PersonalInfoSystem.UpdataNickNamePanel_NoBtnOnClick()
    self.UpdateNameYesBtn:GetComponent('Button').interactable = true;
    self.NewnameInputField:GetComponent('InputField').text = "";
    self.ShowPanel(self.UpdateNamePanel);
    self.UpdateNamePanel:SetActive(false);
end
-- 个人信息面板下的绑定手机号面板确认按钮
function PersonalInfoSystem.BindingPhoneNumeberPanel_YesBtnOnClick()
    HallScenPanel.PlayeBtnMusic()

    -- 给服务器发送绑定手机号的信息
    self.SetPhoneYesBtn:GetComponent('Button').interactable = false;
    local NewPhoneNumber = self.setPhoneNumberInputField:GetComponent('InputField').text;
    local Code = self.CodeInputField:GetComponent('InputField').text;
    local setPwd = self.setNewPwdInputField:GetComponent('InputField').text;
    local ResetPwd = self.ResetNewPwdInputField:GetComponent('InputField').text;
    if not (self.PwdFun(setPwd)) then
        MessageBox.CreatGeneralTipsPanel("输入的信息有误，请确认你密码是否正确")
        self.SetPhoneYesBtn:GetComponent('Button').interactable = true;
        return
    end ;
    if setPwd ~= ResetPwd then
        MessageBox.CreatGeneralTipsPanel("输入的信息有误，请确保两次密码相同")
        self.SetPhoneYesBtn:GetComponent('Button').interactable = true;
        return
    end
    if not (self.Phone(NewPhoneNumber)) then
        MessageBox.CreatGeneralTipsPanel("输入的信息有误，请确认绑定的手机是否正确")
        self.SetPhoneYesBtn:GetComponent('Button').interactable = true;
        return
    end ;
    if not (self.PhoneMa(Code)) then
        MessageBox.CreatGeneralTipsPanel("输入的信息有误，请确认验证码是否正确")
        self.SetPhoneYesBtn:GetComponent('Button').interactable = true;
        return
    end ;

    local data = {
        [1] = NewPhoneNumber;
        [2] = Code;
        [3] = MD5Helper.MD5String(setPwd);
    }
    local buffer = SetC2SInfo(CS_ChangeAccount, data);
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_CHANGE_ACCOUNT, buffer, gameSocketNumber.HallSocket);
    self.SetPhoneYesBtn:GetComponent('Button').interactable = true;

end
-- 个人信息面板绑定手机号回调
function PersonalInfoSystem.UpdataPhoneNumberCallBack(buffer, size)
    if size == 0 then
        HallScenPanel.BackHallOnClick();
        MessageBox.CreatGeneralTipsPanel("绑定成功");
        MoveNotifyInfoClass.getcodefuntion = nil;
        self.SaveAccount(true);
    else
        MessageBox.CreatGeneralTipsPanel("绑定手机号失败：" .. buffer:ReadString(size));
    end
end

function PersonalInfoSystem.SaveAccount(FromBl)
    -- fromBl true 代表绑定手机，false代表修改密码
    local id = Util.EncryptDES(SCPlayerInfo._04wAccount, gameDECkey);
    local pwd = Util.EncryptDES(SCPlayerInfo._06wPassword, gameDECkey);
    if FromBl then
        SCPlayerInfo._04wAccount = BDPhonePanel.SJHM.text;
        SCPlayerInfo._28IsPhoneNumber = 22
        SCPlayerInfo._29szPhoneNumber = SCPlayerInfo._04wAccount;
        SCPlayerInfo._06wPassword = MD5Helper.MD5String(BDPhonePanel.BXXMM.text)
        id = Util.EncryptDES(SCPlayerInfo._04wAccount, gameDECkey);
        pwd = Util.EncryptDES(SCPlayerInfo._06wPassword, gameDECkey);
    else
        SCPlayerInfo._06wPassword = MD5Helper.MD5String(BDPhonePanel.BXXMM.text)
    end
    PlayerPrefs.SetString("ID", id);
    PlayerPrefs.SetString("Password", pwd);
    PlayerPrefs.SetString("LoginType", "1");
    PlayerPrefs.SetString("AutoLogin", "1");
    
    log("账号:" .. Util.DecryptDES(PlayerPrefs.GetString("ID"), gameDECkey));
    log("密码:" .. Util.DecryptDES(PlayerPrefs.GetString("Password"), gameDECkey));
    local file = io.open(AppConst.AccountFilePath)
    if file == nil then
        log("文件不存在")
        file = io.open(AppConst.AccountFilePath, "w");
        file:close();
        file = io.open(AppConst.AccountFilePath)
    end
    tab = ReadFile(file)
    file:close()
    for i = 1, #tab do
        if tab[i] == id or tonumber(tab[i]) == nil then
            table.remove(tab, i);
            table.remove(tab, i)
        end
    end
    tab = { };
    if FromBl then
        SCPlayerInfo._04wAccount = BDPhonePanel.SJHM.text;
        SCPlayerInfo._28IsPhoneNumber = 22
        SCPlayerInfo._29szPhoneNumber = SCPlayerInfo._04wAccount;
        SCPlayerInfo._06wPassword = MD5Helper.MD5String(BDPhonePanel.BXXMM.text)
        id = Util.EncryptDES(SCPlayerInfo._04wAccount, gameDECkey);
        pwd = Util.EncryptDES(SCPlayerInfo._06wPassword, gameDECkey);
        tab = { };
    else
        --  pwd = self.setNewPwdInputField:GetComponent('InputField').text
        pwd = Util.EncryptDES(SCPlayerInfo._06wPassword, gameDECkey);
    end
    table.insert(tab, id)
    table.insert(tab, pwd)
    local filewrite = io.open(AppConst.AccountFilePath, "w")
    WriteFile(filewrite, tab)
    filewrite:close();
    logTable(tab);
end
-- 个人信息面板下的绑定手机好面板取消按钮
function PersonalInfoSystem.BindingPhoneNumeberPanel_NoBtnOnClick()
    HallScenPanel.PlayeBtnMusic()

    self.ShowPanel(self.SetPhonePanel)
    self.SetPhonePanel:SetActive(false);
end
-- 个人信息面板下的照片面板的取消按钮
function PersonalInfoSystem.PhonePanel_NoBtnOnClick()
    HallScenPanel.PlayeBtnMusic()

    if gameIsOnline then
        self.ShowPanel(self.PhonePanel)
        self.PhonePanel:SetActive(false);
        NetManager:GetLoadHeaderFile(UrlHeadImg, self.PhonePanel_Img);
    else
        destroy(self.PersonalInfoPanel);

        self.PersonalInfoPanel = nil;
    end
end
-- 个人信息面板的取消按钮点击事件
function PersonalInfoSystem.PersonalInfoPanel_NoOnClick(g)
    self.ShowPanel(g);
    self.ChangePasswordBtn:SetActive(true);
    self.sendgoldbtn:SetActive(false);
    if (SCPlayerInfo._06wPassword ~= "") then
        self.ChangeNickNameBtn:SetActive(true);
        self.BindingPhoneNumberBtn:SetActive(true);
        if SCPlayerInfo._28IsPhoneNumber ~= 0 then
            self.BindingPhoneNumberBtn:SetActive(false);
            self.sendgoldbtn:SetActive(true);
        end
    else
        self.ChangeNickNameBtn:SetActive(false);
        self.BindingPhoneNumberBtn:SetActive(false);
    end
    self.BtnImg:SetActive(true);
    self.ChangePasswordBtn:GetComponent('Button').interactable = true;
    self.ChangeNickNameBtn:GetComponent('Button').interactable = true;
    self.BindingPhoneNumberBtn:GetComponent('Button').interactable = true;
    self.ChangePasswordBtnTxt:SetActive(true);
    self.ChangeNickNameBtnTxt:SetActive(true);
    self.BindingPhoneNumberBtnTxt:SetActive(true);
    self.ChangePasswordBtnPress:SetActive(false);
    self.ChangeNickNameBtnPress:SetActive(false);
    self.BindingPhoneNumberBtnPress:SetActive(false);
end

-- 隐藏和显示一个transform
function PersonalInfoSystem.ShowPanel(g)
    if g.transform.localPosition.y > 100 then
        g.transform.localPosition = Vector3.New(0, 0, 0);
    else
        g.transform.localPosition = Vector3.New(1500, 1500, 0);
    end
end

function PersonalInfoSystem.PwdFun(args)
    -- 0:为长度不正确;1:表示字符为纯数字;2:表示字母加数字；3：表示无特殊符合字符串且不含汉字;4:表示无特殊符合字符串且含汉字;5:表示含特殊符号的字符串；
    if (args ~= nil) then
        if (self.StrIsTrue(args, 4, 16) == 0) then
            return false;
        elseif (self.StrIsTrue(args, 4, 16) == 4) then
            return false;
        elseif (self.StrIsTrue(args, 4, 16) == 5) then
            return false;
        elseif true then
            return true;
        end
    else
        return false;
    end
end

function PersonalInfoSystem.Newname(args)
    if (args ~= nil) and args ~= " " then
        if (self.StrIsTrue(args, 2, 7) == 0) then
            return false;
        elseif (self.StrIsTrue(args, 2, 7) == 5) then
            return false;
        elseif true then
            return true;
        end
    else
        return false;
    end
end

function PersonalInfoSystem.Phone(args)
    if (args ~= nil) then
        if (self.StrIsTrue(args, 11, 11) == 0) then
            return false;
        elseif (self.StrIsTrue(args, 11, 11) == 1) then
            return true;
        elseif true then
            return false
        end
    else
        return false
    end
end

function PersonalInfoSystem.PhoneMa(args)
    if (args ~= nil) then
        if (self.StrIsTrue(args, 4, 4) == 0) then
            return false
        elseif (self.StrIsTrue(args, 4, 4) == 1) then
            return true
        elseif (self.StrIsTrue(args, 4, 4) == 2) then
            return true
        elseif true then
            return false
        end
    else
        return false
    end

end
-- 通用返回字符串类型
function PersonalInfoSystem.StrIsTrue(args, start, stop)
    -- 0:为长度不正确;1:表示字符为纯数字;2:表示字母加数字；3：表示无特殊符合字符串且不含汉字;4:表示无特殊符合字符串且含汉字;5:表示含特殊符号的字符串；
    local valueNum = 0;
    if (self.GetStrLenght(args) < start) then
        valueNum = 0;
    elseif (self.GetStrLenght(args) > stop) then
        valueNum = 0;
    elseif (RegularString(args)) then
        if (string.find(args, "%d")) then
            valueNum = 1;
        elseif (string.find(args, "%w")) then
            valueNum = 2;
        else
            valueNum = 3;
            local curByte = 0;
            for i = 1, string.len(args) do
                curByte = string.byte(args, i);
                if (curByte > 127) then
                    valueNum = 4;
                    return ;
                end ;
            end

        end
    else
        valueNum = 5;
    end ;
    return valueNum;
end
-- 显示需要提示的对象
function PersonalInfoSystem.showTishi(obj, IsShow)
    obj:SetActive(true);
    if IsShow then
        obj.transform:Find("isTrue").gameObject:SetActive(true);
        obj.transform:Find("isFalse").gameObject:SetActive(false);
    else
        obj.transform:Find("isFalse").gameObject:SetActive(true);
        obj.transform:Find("isTrue").gameObject:SetActive(false);
        self.UpdataPasswordPanel_YesBtn:GetComponent('Button').interactable = false;
        self.UpdataPasswordPanel_YesBtn.transform:Find('Press').gameObject:SetActive(true);
        self.UpdataPasswordPanel_YesBtn.transform:Find('Text').gameObject:SetActive(false);
        self.UpdataNickNamePanel_YesBtn:GetComponent('Button').interactable = false;
        self.UpdataNickNamePanel_YesBtn.transform:Find('Press').gameObject:SetActive(true);
        self.UpdataNickNamePanel_YesBtn.transform:Find('Text').gameObject:SetActive(false);
        self.BindingPhoneNumeberPanel_YesBtn:GetComponent('Button').interactable = false;
        self.BindingPhoneNumeberPanel_YesBtn.transform:Find('Press').gameObject:SetActive(true);
        self.BindingPhoneNumeberPanel_YesBtn.transform:Find('Text').gameObject:SetActive(false);
    end ;
end
-- 设置提示为fasle
function PersonalInfoSystem.TishiFalse()
    self.oldPwdTishi:SetActive(false);
    self.newPwdTishi:SetActive(false);
    self.RenewPwdTishi:SetActive(false);
    self.NewnameTishi:SetActive(false);
    self.PhoneTishi:SetActive(false);
    self.PhoneMaTishi:SetActive(false);
    _obj.transform:Find("Bg/UpdataPasswordPanel/OldPWDText/InputField").gameObject:GetComponent("InputField").text = "";
    _obj.transform:Find("Bg/UpdataPasswordPanel/NewPWDText/InputField").gameObject:GetComponent("InputField").text = "";
    _obj.transform:Find("Bg/UpdataPasswordPanel/ConfirmText/InputField").gameObject:GetComponent("InputField").text = "";
    _obj.transform:Find("Bg/UpdataNickNamePanel/NewNickNameText/InputField").gameObject:GetComponent("InputField").text = "";
    _obj.transform:Find("Bg/SetPhonePanel/PhoneNumberText/InputField").gameObject:GetComponent("InputField").text = "";
    _obj.transform:Find("Bg/SetPhonePanel/CodeText/InputField").gameObject:GetComponent("InputField").text = "";
end
function PersonalInfoSystem.CreatRenQiPrefeb(args)
    for i = 0, self.RenQiNum.transform.childCount - 1 do
        destroy(self.RenQiNum.transform:GetChild(i).gameObject);
    end
    for i = 1, string.len(self.RenqiTxt) do
        local prefebnum = string.sub(self.RenqiTxt, i, i);
        local go = newobject(args.transform:GetChild(prefebnum).gameObject);
        go.transform:SetParent(self.RenQiNum.transform);
        go.transform.localScale = Vector3.one;
        go.transform.localPosition = Vector3.New(0, 0, 0);
    end
end

function PersonalInfoSystem.ShowImgNum()
    ResManager:LoadAsset("module02/hall_person_version3", "PersonNum_Version3", self.CreatRenQiPrefeb);
end

function PersonalInfoSystem.GetStrLenght(args)
    local lenInByte = #args;
    local strIndex = 0;
    for i = 1, lenInByte do
        local curByte = string.byte(args, i)
        local byteCount = 1;
        if curByte > 0 and curByte <= 127 then
            byteCount = 1;
            strIndex = strIndex + 1;
        elseif curByte >= 192 and curByte < 223 then
            byteCount = 1;
            strIndex = strIndex + 1;
        elseif curByte >= 224 and curByte < 239 then
            byteCount = 1;
            strIndex = strIndex + 1;
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = 1;
            strIndex = strIndex + 1;
        end
        i = i + byteCount - 1;
    end
    return strIndex;
end
-- 照相 命令2015002
function PersonalInfoSystem.PhoneCameraBtnOnClick()
    HallScenPanel.PlayeBtnMusic()

    if not (Util.isApplePlatform) and not (Util.isAndroidPlatform) then
        MessageBox.CreatGeneralTipsPanel("目前照相机不支持该平台");
        return
    end ;
    self.waitPanel.transform:Find("Text"):GetComponent('Text').text = "  ";
    if (Util.isApplePlatform) then
        self.waitPanel:SetActive(true);
        -- GameObject.FindGameObjectWithTag("GuiCamera").transform.localPosition = Vector3.New(0, 10000, 0)
    end
    error("点击相机");
    NetManager:CallCamera(self.LocalPhoneCallBack);
    --  self.waitPanel:SetActive(false)
end
-- 本地相册 命令2015001
function PersonalInfoSystem.LocalPhoneBtnOnClick()

    MessageBox.CreatGeneralTipsPanel("目前本地相册不支持该平台");
    do
        return
    end
    self.waitPanel.transform:Find("Text"):GetComponent('Text').text = "  ";
    if not (Util.isApplePlatform) and not (Util.isAndroidPlatform) then
        MessageBox.CreatGeneralTipsPanel("目前本地相册不支持该平台");
        return
    end ;
    if (Util.isApplePlatform) then
        self.waitPanel:SetActive(true);
        -- GameObject.FindGameObjectWithTag("GuiCamera").transform.localPosition = Vector3.New(0, 10000, 0)
    end
    NetManager:CallPhoto(self.LocalPhoneCallBack);
end

function PersonalInfoSystem.loadcom(args)
    if args == true then
        changeimgResType = 2;
    else
        changeimgResType = 3;
    end
end

local ChangePhoto = false;
local changeimg = nil;
changeimgResType = 1; -- 1 表示没有上传 2 上传成功 3 上传失败
function PersonalInfoSystem.checkUpHead()
    --[[	if changeimgResType ~= 1 then
            if changeimgResType == 2 then
                if SCPlayerInfo._03bCustomHeader == 0 then
                    SCPlayerInfo._03bCustomHeader = 1;
                    SCPlayerInfo._07wHeaderExtensionName = "0.png";
                    MessageBox.CreatGeneralTipsPanel("上传头像成功");
                else
                    local headname = string.split(SCPlayerInfo._07wHeaderExtensionName, ".");
                    if #headname > 1 then
                        SCPlayerInfo._07wHeaderExtensionName =(tonumber(headname[1]) + 1) .. "." .. headname[2];
                    end
                    MessageBox.CreatGeneralTipsPanel("上传头像成功");
                end
                HallScenPanel.Compose.transform:Find("HeadImg/Image/Image/Image").gameObject:GetComponent('Image').sprite = changeimg;
                self.PlayerHeadIMG:GetComponent("Image").sprite = changeimg;
                self.PlayerHeadIMG:GetComponent("Image").sprite = changeimg;
            else
                MessageBox.CreatGeneralTipsPanel("上传头像失败，请重试");
            end
            changeimgResType = 1;
            self.waitPanel:SetActive(false);
        end--]]

    self.checkSignAndNameChang();
end

function PersonalInfoSystem.checkSignAndNameChang(args)
    --if self.isReflushSignAndName  and (self.LeaveWordInput:GetComponent('InputField').isFocused == false and self.NickName:GetComponent('InputField').isFocused == false) then

    if self.isReflushSignAndName and Util.isAndroidPlatform and (self.LeaveWordInput:GetComponent('InputField').isFocused == false and self.NickName:GetComponent('InputField').isFocused == false) then
        if self.NickName:GetComponent('InputField').text ~= SCPlayerInfo._05wNickName and self.NickName:GetComponent('InputField').text ~= "" then
            self.isReflushSignAndName = false;
            --self.UpdataNickName(nil, self.NickName:GetComponent('InputField').text);
        end
        if string.find(SCPlayerInfo._08wSign, "这个人很懒") then
            if self.LeaveWordInput:GetComponent('InputField').text ~= "" then
                self.isReflushSignAndName = false;
                --self.UpdataLeaveWord(nil, self.LeaveWordInput:GetComponent('InputField').text);
            end
        else
            if self.LeaveWordInput:GetComponent('InputField').text ~= SCPlayerInfo._08wSign and self.LeaveWordInput:GetComponent('InputField').text ~= "" then
                self.isReflushSignAndName = false;
               -- self.UpdataLeaveWord(nil, self.LeaveWordInput:GetComponent('InputField').text);
            end
        end
    end
end

function PersonalInfoSystem.UpImg(urlPath, localPath, progressCallBack)
    -- 创建一个队列
    local UWPacketQueue = UnityWebDownPacketQueue.New();
    local UWPacket = UnityWebPacket.New();
    UWPacket.urlPath = urlPath;
    UWPacket.localPath = localPath;
    UWPacket.size = 0;
    UWPacket.func = progressCallBack;
    UWPacketQueue:Add(UWPacket);
    -- 创建一个空物体
    local obj = GameObject.New();
    obj.name = "UnityWebUpRequestAsync";
    -- 挂载执行下载队列的脚本
    local UWRAsync = obj:AddComponent(typeof(SuperLuaFramework.UnityWebUpRequestAsync));
    -- 传参开始执行
    UWRAsync:UploadAsync(UWPacketQueue);
    return obj;
end

-- 返回相机或者相册中的图片
function PersonalInfoSystem.LocalPhoneCallBack(img, _sprite)
    error("返回相机或者相册中的图片 yes.....");
    if img == nil and _sprite == nil then
        self.waitPanel:SetActive(false);
        return
    end
    local imgUrl = PathHelp.AppHotfixResPath .. "Head.png";
    Util.SaveFile(img, imgUrl);
    self.PhonePanel_Img:GetComponent('Image').sprite = img;
    -- 上传头像
    changeimg = img;

    local url = "http://" .. gameip .. ":8088/HeaderPage.aspx?Account=" .. SCPlayerInfo._04wAccount .. "&Password=" .. SCPlayerInfo._06wPassword;
    self.waitPanel.transform:Find("Text"):GetComponent('Text').text = "正在上传中,请稍等...";
    local f = function(state)
        if state then
            self.YesHeadImg(changeimg)
        else
            self.FailHeadImg()
        end
    end
    -- NetManager:UpLoadHeaderFileAsyn(url, imgUrl, f);
    if AppConst.CodeVersion > 200 then
        local b = function(a, c)
            if tonumber(a) == 1 then
                f(true)
            end
            if tonumber(a) == -1 then
                f(false)
            end
        end
        self.UpImg(url, imgUrl, b);
    else
        local bl = NetManager:UpLoadHeaderFile(url, imgUrl);
        f(bl);
    end
end

function PersonalInfoSystem.FailHeadImg()
    error("FailHeadImg:上传失败");
    self.waitPanel:SetActive(false);
    FramePopoutCompent.Show("上传失败");
end

function PersonalInfoSystem.YesHeadImg(img)
    error("FailHeadImg:上传成功");
    self.waitPanel:SetActive(false);
    if SCPlayerInfo._03bCustomHeader == 0 then
        SCPlayerInfo._03bCustomHeader = 1;
        SCPlayerInfo._07wHeaderExtensionName = "0.png";
        FramePopoutCompent.Show("上传头像成功");
    else
        local headname = string.split(SCPlayerInfo._07wHeaderExtensionName, ".");
        if #headname > 1 then
            SCPlayerInfo._07wHeaderExtensionName = (tonumber(headname[1]) + 1) .. "." .. headname[2];
        end
        FramePopoutCompent.Show("上传头像成功");
    end
    HallScenPanel.Compose.transform:Find("HeadImg/Image/Image/Image").gameObject:GetComponent('Image').sprite = img;
    self.PlayerHeadIMG:GetComponent("Image").sprite = img;
    self.PlayerHeadIMG:GetComponent("Image").sprite = img;
end

-- 关闭相册
function PersonalInfoSystem.HomeBack()
    -- GameObject.FindGameObjectWithTag("GuiCamera").transform.localPosition = Vector3.New(0, 0, 0)
    if self.waitPanel ~= nil then
        self.waitPanel:SetActive(false);
    end
end

function PersonalInfoSystem.DuiHuanOnClick(obj)
    HallScenPanel.PlayeBtnMusic()
    logYellow("querenxiugai")
    DuiHuanPanel.Init(luaBehaviour);
    --PersonalInfoSystem.Creatobj(HallScenPanel.Pool("DuiHuanPanel"))

end

function PersonalInfoSystem.sendinfo()
    if self.DuiHuanName.text == "ID不存在" then
        self.DuiHuan_Button.transform:GetComponent("Button").interactable = true;
        return
    end ;
    local buffer = ByteBuffer.New();
    local Data = {
        -- ID
        [1] = self.DuiHuanId.text,
        -- 兑换码
        [2] = self.DuiHuanMa.text,
    }
    buffer = SetC2SInfo(CS_GetExchangeCodeAward, Data);
    Network.Send(MH.MDM_3D_TASK, MH.SUB_3D_CS_GET_EXCHANGE_CODE_AWARD, buffer, gameSocketNumber.HallSocket);
end

function PersonalInfoSystem.duihuanmatishiinfo()
    --       if self.duihuanma_Gold == 0.1 then return end
    --        if self.duihuanma_Gold == 0 then
    --            self.DuiHuan_Button.transform:GetComponent("Button").interactable = true;
    --            MessageBox.CreatGeneralTipsPanel("该兑换码已使用，或不存在"); return
    --        end;
    if tonumber(self.duihuanma_Gold) == nil then
        self.DuiHuan_Button.transform:GetComponent("Button").interactable = true;
        MessageBox.CreatGeneralTipsPanel("该兑换码已使用，或不存在");
        return
    end ;
    if self.DuiHuanName.text == "ID不存在" then
        self.DuiHuan_Button.transform:GetComponent("Button").interactable = true;
        MessageBox.CreatGeneralTipsPanel("输入得兑换ID不存在");
        return
    end ;
    local t = GeneralTipsSystem_ShowInfo;
    t._01_Title = "提    示";
    t._03_ButtonNum = 2;
    t._02_Content = "\n兑换ID：   <color=#ffd800ff>" .. self.DuiHuanId.text .. "</color>\n昵   称：   <color=#ffd800ff>" .. self.DuiHuanName.text .. "</color>\n金   币：   <color=#ffd800ff>" .. self.duihuanma_Gold .. "</color>";
    t._04_YesCallFunction = self.sendinfo;
    t._05_NoCallFunction = nil;
    MessageBox.CreatGeneralTipsPanel(t);
end

function PersonalInfoSystem.duihuanmaclosepanel()
    HallScenPanel.PlayeBtnMusic()

    self.DHOld.gameObject:SetActive(false)
    destroy(self.DuiHuanPanel);
    self.DuiHuanPanel = nil
    self.DuiHuanNameBg = nil;
end

function PersonalInfoSystem.Creatobj(prefeb)
    self.DuiHuanPanel = prefeb;
    prefeb.transform:SetParent(HallScenPanel.Compose.transform);
    prefeb.name = "DuiHuanPanel";
    prefeb.transform.localScale = Vector3.New(1, 1, 1);
    prefeb.transform.localPosition = Vector3.New(0, 0, 0);

    self.DHOld = self.DuiHuanPanel.transform:Find("Bg/Old")
    self.DHNew = self.DuiHuanPanel.transform:Find("Bg/New")

    self.DHOld.gameObject:SetActive(true)
    self.DHNew.gameObject:SetActive(false)

    log("00000000000")
    self.DuiHuanId = self.DuiHuanPanel.transform:Find("Bg/Old/DuiHuanId/InputField"):GetComponent("InputField");
    self.DuiHuanMa = self.DuiHuanPanel.transform:Find("Bg/Old/DuiHuanMa/InputField"):GetComponent("InputField");
    self.DuiHuanNameBg = self.DuiHuanPanel.transform:Find("Bg/Old/DuiHuanName").gameObject;
    self.DuiHuanName = self.DuiHuanPanel.transform:Find("Bg/Old/DuiHuanName/Text"):GetComponent("Text");
    self.DuiHuan_Button = self.DuiHuanPanel.transform:Find("Bg/Old/Button").gameObject;
    self.DuiHuan_Close = self.DuiHuanPanel.transform:Find("Bg/CloseBtn").gameObject;
    self.DuiHuanMask_Close = self.DuiHuanPanel.transform:Find("Image").gameObject;
    self.DuiHuanNameBg:SetActive(false);
    HallScenPanel.LuaBehaviour:AddClick(self.DuiHuan_Button, self.checkduihuanma)
    HallScenPanel.LuaBehaviour:AddClick(self.DuiHuan_Close, self.duihuanmaclosepanel)
    HallScenPanel.LuaBehaviour:AddClick(self.DuiHuanMask_Close, self.duihuanmaclosepanel)
    --HallScenPanel.LuaBehaviour:AddEndEditEvent(self.DuiHuanPanel.transform:Find("Bg/Old/DuiHuanId/InputField").gameObject, self.checkName);
    -- HallScenPanel.LuaBehaviour:AddEndEditEvent(self.DuiHuanPanel.transform:Find("Bg/DuiHuanMa/InputField").gameObject, self.checkduihuanma);
    --self.DuiHuanId.text = SCPlayerInfo._beautiful_Id
    --self.DuiHuanName.text = SCPlayerInfo._05wNickName
    self.DuiHuanNameBg:SetActive(true);
end

function PersonalInfoSystem.checkName(obj, args)
    self.DuiHuanName.text = " ";
    if string.find(args, "%d") then
        if tonumber(args) == nil then
            return
        end
    else
        return
    end
    local buffer = ByteBuffer.New();
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(tonumber(args));
    --local data = { [1] = tonumber(args), [2] = 1 }

    --buffer = SetC2SInfo(CS_UserInfoSelect, data);
    SeleteInfoToWindows = 1;
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_USER_INFO_SELECT, buffer, gameSocketNumber.HallSocket);
end

function PersonalInfoSystem.checkduihuanma(obj, args)
    HallScenPanel.PlayeBtnMusic()

    if SCPlayerInfo._29szPhoneNumber == "" then
        MessageBox.CreatGeneralTipsPanel("需要绑定手机号才能使用该功能!");
        return
    end
    -- SUB_3D_CS_SELECT_EXCHANGE_CODE
    args = self.DuiHuanPanel.transform:Find("Bg/Old/DuiHuanId/InputField/Text").gameObject:GetComponent("Text").text;
    local args2=self.DuiHuanPanel.transform:Find("Bg/Old/DuiHuanMa/InputField/Text").gameObject:GetComponent("Text").text;
    if string.len(args) <= 0 then
        MessageBox.CreatGeneralTipsPanel("该兑换码不正确，请输入正确的兑换码");
        return
    end
    if self.DuiHuan_Button.transform:GetComponent("Button").interactable == false then
        return ;
    end
    self.DuiHuan_Button.transform:GetComponent("Button").interactable = false;
    local str1 = string.gsub(args, " ", "")
    local str2 = string.gsub(args2, " ", "")

    self.duihuanma_Gold = 0.1;
    local buffer = ByteBuffer.New();
    local data = { [1] = str1, [2] = str2 }
    logTable(data)
    buffer = SetC2SInfo(CS_DuiHuanMa_Gold, data);
    Network.Send(MH.MDM_3D_TASK, MH.SUB_3D_CS_GET_EXCHANGE_CODE_AWARD, buffer, gameSocketNumber.HallSocket);
end

function PersonalInfoSystem.SetDuiHuan_ButtonShow(flag)
    self.DuiHuan_Button.transform:GetComponent("Button").interactable = flag;
end

function PersonalInfoSystem.duihuanmaSc(buffer, wSize)
    --logError("-----------------------------------")
    self.duihuanma_Gold = buffer:ReadUInt32();
    if self.duihuanma_Gold == 0 then
        MessageBox.CreatGeneralTipsPanel("该兑换码已使用，或不存在");
        -- self.DuiHuanPanel.transform:Find("Bg/DuiHuanMa/InputField").gameObject:GetComponent("InputField").text="";
        self.DuiHuan_Button.transform:GetComponent("Button").interactable = true;
        self.duihuanma_Gold = "该兑换码已使用，或不存在";
    elseif self.DuiHuanNameBg ~= nil then
        self.duihuanmatishiinfo();
    end
end

function PersonalInfoSystem.checkNameEnd(args)
    if self.DuiHuanNameBg ~= nil then
        self.DuiHuanNameBg:SetActive(true);
        if args[1] == 0 then
            self.DuiHuanName.text = "ID不存在";
            return ;
        end
        self.DuiHuanName.text = args[5];
    end
end