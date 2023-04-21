--[[require "Common/define"
require "Data/gameData"
require "module02/GiveAndSendMoneyRecordPanle"]]
GiveRedBag = {}
local self = GiveRedBag
local _luaBeHaviour = nil
self.transferMoney = 0;
self.upperNum = { "零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "百", "千", "万", "亿" }

-- ===========================================贈送紅包信息系统======================================

self.transferConfig = { 1, 10, 20, 50, 100 };
self.rate = 10000;
function GiveRedBag.Open(go)
    if self.GiveRedBagPanel == nil then
        self.GiveRedBagPanel = "obj"
        self.OnCreacterChildPanel_Cornucopia(go)
    elseif self.Gold ~= nil then
        self.UpdateSaveGold()
    end
end
-- 创建UI的子面板_聚宝盆
function GiveRedBag.OnCreacterChildPanel_Cornucopia(go)
    self.GiveRedBagPanel = go
    GiveRedBag.Init(self.GiveRedBagPanel, HallScenPanel.LuaBehaviour)
end

function GiveRedBag.Init(obj, luaBeHaviour)
    _luaBeHaviour = luaBeHaviour
    local t = obj.transform
    -- 赋值自己
    self.GiveRedBagPanel = obj
    -- 初始化面板，绑定点击事件
    self.GiveGoldBtn = t:Find("BtnGroup/GiveGoldBtn").gameObject
    -- self.GiveCardBtn = t:Find("BtnGroup/GiveCardBtn").gameObject
    -- self.GiveCardBtn:SetActive(SCPlayerInfo.IsVIP == 1);
    self.GiveGoldRecordBtn = t:Find("BtnGroup/RedRecordBtn").gameObject
    -- self.GoldTishi = t:Find("Gold/Text").gameObject:GetComponent("Text")
    -- self.GoldTishi.text = "当前存款:"
    self.Gold = t:Find("Gold/Text"):GetComponent("Text")
    self.SaveGold = t:Find("SaveGold/Text"):GetComponent("Text")
    self.GiveGoldNickName = t:Find("GiveGoldNickName/InputField").gameObject
    local a = t:Find("GiveGoldNickName/InputField"):GetComponent("InputField")
    a.contentType = UnityEngine.UI.InputField.ContentType.IntegerNumber
    self.GiveGoldNum = t:Find("GiveGoldNum/InputField").gameObject
    local b = t:Find("GiveGoldNum/InputField"):GetComponent("InputField")
    b.contentType = UnityEngine.UI.InputField.ContentType.IntegerNumber
    self.checknameTxt = t:Find("GiveGoldNickName/titlename"):GetComponent("Text")
    self.upperMoneyTxt = t:Find("GiveGoldNum/uppernum"):GetComponent("Text")
    self.TishiText = t:Find("TishiText").gameObject
    self.resetBtn = t:Find("GiveGoldNum/ResetBtn").gameObject;
    self.transferGroup = t:Find("TransferGroup");
    --self.resetBtn:SetActive(SCPlayerInfo.IsVIP == 1);
    self.transferGroup.gameObject:SetActive(SCPlayerInfo.IsVIP == 1);
    for i = 1, #self.transferConfig do
        local child = nil;
        if i > self.transferGroup.childCount then
            child = newObject(self.transferGroup:GetChild(0).gameObject);
            child.transform:SetParent(self.transferGroup);
        else
            child = self.transferGroup:GetChild(i - 1);
        end
        child.gameObject:SetActive(true);
        child.transform.localPosition = Vector3.New(0, 0, 0);
        child.transform.localScale = Vector3.New(1, 1, 1);
        child.transform:Find("Text"):GetComponent("TextMeshProUGUI").text =HallScenPanel.ShowText(self.transferConfig[i] .. "y");
        child.transform.name = tonumber(self.transferConfig[i]);
        luaBeHaviour:AddClick(child.gameObject, self.OnClickSelectMoneyCall);
    end
    self.UpdateSaveGold()
    luaBeHaviour:AddClick(self.resetBtn, self.OnClickResetBtn);
    luaBeHaviour:AddClick(self.GiveGoldBtn, self.TishiGiveGoldYesBtnOnClick)
    --luaBeHaviour:AddClick(self.GiveCardBtn, self.OpenGiveCardPanel)
    luaBeHaviour:AddClick(self.GiveGoldRecordBtn, self.GiveGoldRecordOnClick)
    luaBeHaviour:AddEndEditEvent(self.GiveGoldNickName, self.NickNameEndValue)
    luaBeHaviour:AddEndEditEvent(self.GiveGoldNum, self.GiveGoldEndValue)
    self.TishiText:GetComponent("Text").text = ""
    logYellow("注册刷新事件")
    Event.AddListener(PanelListModeEven._015ChangeGoldTicket, self.UpdateSaveGold)
end
function GiveRedBag.OnClickSelectMoneyCall(go)
    self.transferMoney = self.transferMoney + tonumber(go.name) * self.rate;
    self.GiveGoldNum.transform:GetComponent("InputField").text = tostring(self.transferMoney);
    self.showUpperMoney(tostring(self.transferMoney));
end
-- 关闭聚宝盆按钮
function GiveRedBag.CloseBtnOnClick()
    if self.GiveRedBagPanel ~= nil then
        -- 恢复被禁用的状态
        destroy(self.GiveRedBagPanel)
        self.GiveRedBagPanel = nil
        Event.RemoveListener(PanelListModeEven._015ChangeGoldTicket, self.UpdateSaveGold)
    end
end
function GiveRedBag.OnClickResetBtn()
    self.GiveGoldNum.transform:GetComponent("InputField").text = "";
    self.upperMoneyTxt.text = " ";
    self.transferMoney = 0;
end
function GiveRedBag.UpdateSaveGold()
    self.SaveGold.text = tostring(gameData.GetProp(enum_Prop_Id.E_PROP_STRONG))
    self.Gold.text = tostring(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD))
end
local CornucopiaNickName
local CornucopiaNum
local CornucopiaPwd
function GiveRedBag.OpenGiveCardPanel(obj)
    ZSCardPanel.Init();
end
-- 点击送宝
function GiveRedBag.TishiGiveGoldYesBtnOnClick(obj)
    if SCPlayerInfo._29szPhoneNumber == "" then
        MessageBox.CreatGeneralTipsPanel("需要绑定手机号才能使用该功能!")
        return
    end
    CornucopiaNickName = self.GiveGoldNickName:GetComponent("InputField").text
    CornucopiaNum = tonumber(self.GiveGoldNum:GetComponent("InputField").text)
    if CornucopiaNum == nil then
        MessageBox.CreatGeneralTipsPanel("请输入正确的转账数额")
        return
    end
    if CornucopiaNickName == tostring(SCPlayerInfo._33PlayerID) then
        MessageBox.CreatGeneralTipsPanel("请勿给自己转账")
        return
    end
    if string.len(CornucopiaNickName) < 1 then
        MessageBox.CreatGeneralTipsPanel("输入的信息有误，请检查输入信息")
        return
    end
    if (tonumber(gameData.GetProp(enum_Prop_Id.E_PROP_STRONG)) < CornucopiaNum) then
        MessageBox.CreatGeneralTipsPanel("你的存款不足，请重新输入！")
        return
    end
    obj:GetComponent("Button").interactable = false
    local t = GeneralTipsSystem_ShowInfo
    t._01_Title = "提    示"
    t._03_ButtonNum = 2
    t._02_Content = "接收人：" ..
            self.checknameTxt.text ..
            "(" ..
            self.GiveGoldNickName:GetComponent("InputField").text ..
            ")\n数   额：" .. self.GiveGoldNum:GetComponent("InputField").text .. "(" .. self.upperMoneyTxt.text .. ")"
    t._04_YesCallFunction = GiveRedBag.GiveGoldYesBtnOnClick
    t._05_NoCallFunction = GiveRedBag.GiveGoldNoBtnOnClick
    t.isBig=true;
    MessageBox.CreatGeneralTipsPanel(t)
end

-- 点击确认按钮事件
function GiveRedBag.GiveGoldYesBtnOnClick()
    -- if (gameData.GetProp(enum_Prop_Id.E_PROP_STRONG) >= SCSystemInfo._7dwPresentMinGold) then
    HallScenPanel.PlayeBtnMusic()
    self.GiveGoldBtn:GetComponent("Button").interactable = false
    CornucopiaNickName = self.GiveGoldNickName:GetComponent("InputField").text
    CornucopiaNum = tonumber(self.GiveGoldNum:GetComponent("InputField").text)
    self.transferMoney = 0;
    local buffer = ByteBuffer.New()
    -- local Data = { [1] = CornucopiaNum, [2] = CornucopiaNickName,};
    -- buffer = SetC2SInfo(CS_PresentGold, Data);
    buffer:WriteUInt32(CornucopiaNickName)
    buffer:WriteLong(CornucopiaNum)
    Network.Send(MH.MDM_3D_GOLDMINET, MH.SUB_3D_CS_TRANSFERACCOUNTS, buffer, gameSocketNumber.HallSocket)
    --    else
    --        MessageBox.CreatGeneralTipsPanel("最低转账为" .. SCSystemInfo._7dwPresentMinGold .. "，你的金币不足，请充值。");
    --    end
end

-- 赠送后，服务器反馈消息
function GiveRedBag.GiveGoldSuccess(wSubID, buffer, wSize)
    self.GiveGoldBtn:GetComponent("Button").interactable = true
    self.Gold.text = gameData.GetProp(enum_Prop_Id.E_PROP_STRONG)
    self.ShowSuccess(HallScenPanel.Pool("BankInfo"))
    local buffer = ByteBuffer.New()
    buffer:WriteUInt32(SCPlayerInfo._01dwUser_Id) -- 玩家ID
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_SELECT_GOLD_MSG, buffer, gameSocketNumber.HallSocket)
end
function GiveRedBag.GiveGoldFill()
    self.GiveGoldBtn:GetComponent("Button").interactable = true
    self.GiveGoldNickName:GetComponent("InputField").text = ""
    self.GiveGoldNum:GetComponent("InputField").text = ""
    self.checknameTxt.text = ""
    self.upperMoneyTxt.text = ""
end

-- 转账成功显示界面
function GiveRedBag.ShowSuccess(obj)
    local go = obj
    go.transform:SetParent(self.GiveRedBagPanel.transform)
    go.name = "Success"
    go.transform.localScale = Vector3.New(1, 1, 1)
    go.transform.localPosition = Vector3.New(0, 0, 0)
    self.Success = go
    self.Goldnum = self.Success.transform:Find("Gold").gameObject
    self.Info = self.Success.transform:Find("Info/Text"):GetComponent("Text")
    self.CopyBtn = self.Success.transform:Find("CopyBtn").gameObject
    self.CloseBtn = self.Success.transform:Find("CloseBtn").gameObject
    self.BgCloseBtn = self.Success.transform:Find("BgCloseBtn").gameObject
    self.num = self.Success.transform:Find("num").gameObject
    self.num:SetActive(false)
    local numstr = tonumber(self.GiveGoldNum:GetComponent("InputField").text)

    local str1=GiveRedBag.doUpperMoney(numstr,0)
    local index = string.find(str1, "零", 1)
    if index == 1 then
        str1 = string.sub(str1, 4, -1)
    end

    local str = " "
    -- str = "<color=#0effc9>转账金额：</color>" ..
    --         self.GiveGoldNum:GetComponent("InputField").text ..
    --         "\n<color=#0effc9>转账人ID：</color>" ..
    --         SCPlayerInfo._beautiful_Id ..
    --         "\n<color=#0effc9>转账人昵称：</color>" ..
    --         SCPlayerInfo._05wNickName ..
    --         "\n<color=#0effc9>接收人ID：</color>" ..
    --         self.GiveGoldNickName:GetComponent("InputField").text ..
    --         "\n<color=#0effc9>接收人昵称：</color>" ..
    --         self.checknameTxt.text .. "\n<color=#0effc9>转账时间：</color>" .. os.date("%Y年%m月%d日%H点%M分%S秒")

    str=SCPlayerInfo._beautiful_Id.."赠送给"..self.GiveGoldNickName:GetComponent("InputField").text..
        "\n金币:"..self.GiveGoldNum:GetComponent("InputField").text..
        "\n大写:"..str1..
        "\n时间:"..os.date("%Y年%m月%d日%H点%M分%S秒")..
        "\n成功!"
    self.Info.text = str

    self.UpdateSaveGold()

    local function closeobj()
        self.GiveGoldNickName:GetComponent("InputField").text = ""
        self.GiveGoldNum:GetComponent("InputField").text = ""
        self.upperMoneyTxt.text = " "
        self.checknameTxt.text = " "
        self.Goldnum = nil
        self.Info = nil
        self.CopyBtn = nil
        self.CloseBtn = nil
        self.BgCloseBtn = nil
        self.num = nil
        destroy(self.Success)
    end
    local function copybtnOnClick()
        if Util.isAndroidPlatform then
            Util.CopyTextToClipboard(str)
            return
        end
        if Util.isApplePlatform then
            Util.CopyTextToClipboard(str)
            return
        end
        local textEditor = TextEditor.New()
        textEditor.text = str
        TextEditor.OnFocus(textEditor)
        TextEditor.Copy(textEditor)
    end
    _luaBeHaviour:AddClick(self.CopyBtn, copybtnOnClick)
    _luaBeHaviour:AddClick(self.CloseBtn, closeobj)
    _luaBeHaviour:AddClick(self.BgCloseBtn, closeobj)

    local localSaveGold = gameData.GetProp(enum_Prop_Id.E_PROP_STRONG)
    localSaveGold = localSaveGold - CornucopiaNum
    gameData.ChangProp(localSaveGold, enum_Prop_Id.E_PROP_STRONG)
    local buffer = ByteBuffer.New()
    buffer:WriteUInt32(SCPlayerInfo._01dwUser_Id)
    Network.Send(4, 133, buffer, gameSocketNumber.HallSocket)
end

-- 点击取消送宝按钮事件
function GiveRedBag.GiveGoldNoBtnOnClick()
    HallScenPanel.PlayeBtnMusic()
    self.GiveGoldNickName:GetComponent("InputField").text = String.Empte
    self.GiveGoldNum:GetComponent("InputField").text = String.Empte
    self.GiveGoldNickName:GetComponent("InputField").text = ""
    self.GiveGoldNum:GetComponent("InputField").text = ""
    self.upperMoneyTxt.text = " "
    self.checknameTxt.text = " "
    self.transferMoney = 0;
    self.GiveGoldBtn:GetComponent("Button").interactable = true
end

-- 帐号InputField输入时调用（输入昵称更改为ID）
function GiveRedBag.NickNameEndValue(obj, args)
    --[[	if string.len(args) < 1 or not string.find(args, "^[+-]?%d+$",0,false) then 
        MessageBox.CreatGeneralTipsPanel("输入的信息有误，请检查输入信息"); 
        self.GiveFill();
        return 
    end;--]]
    self.checknameTxt.text = " "
    local str = string.gsub(args, " ", "")
    if string.find(str, "%d") then
        if tonumber(str) ~= nil then
            self.checkName(tonumber(str))
        end
    end
end
-- 送宝InputField输入时调用
function GiveRedBag.GiveGoldEndValue(obj, args)
    self.upperMoneyTxt.text = " "
    local str = string.gsub(args, " ", "")
    if string.find(str, "%d") then
        if tonumber(str) < tonumber(SCSystemInfo._7dwPresentMinGold) then
        end
        if string.find(str, "^0") then
        else
            self.showUpperMoney(str)
        end
    end
    if string.find(self.GiveGoldNum.transform:GetComponent("InputField").text, " ") ~= nil or self.GiveGoldNum.transform:GetComponent("InputField").text == "" then
        self.transferMoney = 0;
    else
        self.transferMoney = tonumber(self.GiveGoldNum.transform:GetComponent("InputField").text);
    end
end

function GiveRedBag.checkName(args)
    logError("查询玩家：" .. args .. type(args))

    local buffer = ByteBuffer.New()
    buffer:WriteUInt32(tonumber(args))
    SeleteInfoToWindows = 1

    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_USER_INFO_SELECT, buffer, gameSocketNumber.HallSocket)
end

-- 显示输入的大写金额
function GiveRedBag.showUpperMoney(arg)
    local str = self.doUpperMoney(tonumber(arg), 0)
    local index = string.find(str, "零", 1)
    if index == 1 then
        str = string.sub(str, 4, -1)
    end
    self.upperMoneyTxt.text = str
end

function GiveRedBag.checknameRes(args)
    logTable(args)
    self.TargeInfo = args
    if self.checknameTxt ~= nil then
        if args[1] == 0 then
            MessageBox.CreatGeneralTipsPanel("ID不存在")
            self.GiveFill()
            return
        end
        self.checknameTxt.text = args[5]
    end
end

-- self.upperNum = {"零","壹","贰","叁","肆","伍","陆","柒","捌","玖","拾","佰","仟","万","亿"};
function GiveRedBag.doUpperMoney(args, index)
    local vlu = math.fmod(args, 10000)
    local falg = 0
    local str = {}
    local num = 0
    if vlu ~= 0 then
        if vlu >= 1000 then
            falg = math.floor(vlu / 1000)
            table.insert(str, self.upperNum[falg + 1] .. self.upperNum[13])
            vlu = vlu - falg * 1000
            num = 1
        end

        if vlu >= 100 then
            falg = math.floor(vlu / 100)
            if num ~= 1 then
                table.insert(str, self.upperNum[1] .. self.upperNum[falg + 1] .. self.upperNum[12])
            else
                table.insert(str, self.upperNum[falg + 1] .. self.upperNum[12])
            end
            vlu = vlu - falg * 100
            num = 2
        end

        if vlu >= 10 then
            falg = math.floor(vlu / 10)
            if num ~= 2 then
                -- elseif falg==1 then
                -- table.insert(str,self.upperNum[11]);
                table.insert(str, self.upperNum[1] .. self.upperNum[falg + 1] .. self.upperNum[11])
            else
                table.insert(str, self.upperNum[falg + 1] .. self.upperNum[11])
            end
            vlu = vlu - falg * 10
            num = 3
        end

        if vlu > 0 then
            if num ~= 3 then
                table.insert(str, self.upperNum[1] .. self.upperNum[vlu + 1])
            else
                table.insert(str, self.upperNum[vlu + 1])
            end
        end
    end

    local restr = ""
    table.foreachi(
            str,
            function(i, v)
                restr = restr .. v
            end
    )

    local nextv = ""
    args = math.floor(args / 10000)
    if args > 0 then
        nextv = self.doUpperMoney(args, index + 1)
    end

    if restr ~= "" then
        if index == 1 then
            restr = restr .. self.upperNum[14]
        elseif index == 2 then
            restr = restr .. self.upperNum[15]
        end
        return nextv .. restr
    end

    return nextv
end

function GiveRedBag.GetStrLenght(args)
    local lenInByte = #args
    local strIndex = 0
    for i = 1, lenInByte do
        local curByte = string.byte(args, i)
        local byteCount = 1
        if curByte > 0 and curByte <= 127 then
            byteCount = 1
            strIndex = strIndex + 1
        elseif curByte >= 192 and curByte < 223 then
            byteCount = 2
            strIndex = strIndex + 1
        elseif curByte >= 224 and curByte < 239 then
            byteCount = 3
            strIndex = strIndex + 1
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = 4
            strIndex = strIndex + 1
        end
        i = i + byteCount - 1
    end
    return strIndex
end

function GiveRedBag.GiveGoldRecordOnClick()
    GiveAndSendMoneyRecordPanle.showPanel(HallScenPanel.Compose.transform, 0)
end


