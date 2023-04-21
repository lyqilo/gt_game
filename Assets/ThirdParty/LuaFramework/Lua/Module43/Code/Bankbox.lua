
local BankBox={}

local self= BankBox

self.transform=nil
self.IsInputGold = false
self.numformat = nil

function BankBox.Init(obj,m_luaBehaviour, Numformat)

    logError("000000")
    self.transform=obj.transform 
    self.numformat = Numformat
    
    logError("000000.1")
    self.m_luaBehaviour=m_luaBehaviour
    logError("000001")
    self.mainPanel=self.transform:Find("mainPanel")
    self.myGoldText=self.mainPanel:Find("BG/MyGold/GoldText"):GetComponent("TextMeshProUGUI")
    self.myBankGoldText=self.mainPanel:Find("BG/BankGold/GoldText"):GetComponent("TextMeshProUGUI")
    self.QuChu_Input=self.mainPanel:Find("Mid/mid/quchu/InputField"):GetComponent("TMP_InputField")
    self.passWord=self.mainPanel:Find("Mid/mid/passWord/passWord"):GetComponent("TMP_InputField")
    self.DXGold=self.mainPanel:Find("Mid/mid/quchu/DXGold"):GetComponent("TextMeshProUGUI")
    self.Slider=self.mainPanel:Find("Mid/Slider"):GetComponent("Slider")
    self.bigBtn=self.mainPanel:Find("Mid/BigBtn"):GetComponent("Button")
    self.resetBtn=self.mainPanel:Find("Lower/resBtn"):GetComponent("Button")
    self.SureBtn=self.mainPanel:Find("Lower/SureBtn"):GetComponent("Button")
    logError("000002")
    self.m_luaBehaviour:AddClick(self.transform:Find("mainPanel/CloseBtn").gameObject,self.Close)
    self.m_luaBehaviour:AddClick(self.transform:Find("zhezhao").gameObject,self.Close)
    self.m_luaBehaviour:AddClick(self.mainPanel:Find("Mid/mid/quchu/Button").gameObject,self.OpenRecharge)
    self.m_luaBehaviour:AddClick(self.resetBtn.gameObject,self._resetBtn)
    self.m_luaBehaviour:AddClick(self.bigBtn.gameObject, self._MaxBtn);--最大
    self.m_luaBehaviour:AddTMPEndEditEvent(self.QuChu_Input.gameObject, self._EndInputOver);--监听Input输入完毕
    self.m_luaBehaviour:AddSliderEvent(self.Slider.gameObject, self._EndSliderOver);--监听slider
    self.m_luaBehaviour:AddClick(self.SureBtn.gameObject, self.SendQCgold);--最大
    logError("000003")
    self.transform.gameObject:SetActive(false)
    logError("000004")
end

function BankBox.OnGoldChangedCall()
    log((gameData.GetProp(enum_Prop_Id.E_PROP_GOLD)))
    self._nowGold   =   tonumber(gameData.GetProp(enum_Prop_Id.E_PROP_STRONG))
    self.MyGold     =   tonumber(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD))
    self.SetGold(self.MyGold,self._nowGold)
    Game71Panel.UpdateMyGold(self.MyGold)
end

function BankBox.SetGold(Value1,value2)
    self.myGoldText.text = self.numformat.ChnageText(self.numformat.ReturnGoldToText(tonumber(Value1)))
    self.myBankGoldText.text = self.numformat.ChnageText(self.numformat.ReturnGoldToText(tonumber(value2)))
end

function BankBox.SendQCgold()
    --_Socket.playaudio("btn",false,false,false)       

    logYellow("取出金币")
    local QGold=tonumber(self.QuChu_Input.text)*GameManager.moneyRate
    local p = "000000"
    local buffer = ByteBuffer.New()
    buffer:WriteUInt32(SCPlayerInfo._01dwUser_Id) -- 玩家ID
    buffer:WriteUInt32(1)
    buffer:WriteLong(QGold)
    buffer:WriteBytes(33, MD5Helper.MD5String(p)) -- 银行密码
    Network.Send(MH.MDM_GP_USER, MH.SUB_GP_USER_BANK_OPERATE, buffer, gameSocketNumber.HallSocket)
end


function BankBox.Open()
    Event.AddListener(PanelListModeEven._015ChangeGoldTicket, self.OnGoldChangedCall);
    self._nowGold   =   tonumber(gameData.GetProp(enum_Prop_Id.E_PROP_STRONG))
    self.MyGold     =   tonumber(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD))
    self.SetGold(self.MyGold,self._nowGold)
    self._resetBtn()
    self.transform.gameObject:SetActive(true)
    self.transform:DOScale(Vector3.New(1, 1, 1), 0.1):SetEase(DG.Tweening.Ease.InBack):OnComplete(function()		
    end);
end

function BankBox.Close()
    --_Socket.playaudio("btn",false,false,false)       

    Event.RemoveListener(PanelListModeEven._015ChangeGoldTicket, self.OnGoldChangedCall);
    self.transform:DOScale(Vector3.New(0, 0, 0), 0.2):SetEase(DG.Tweening.Ease.InBack):OnComplete(function()		
        self.transform.gameObject:SetActive(false)
    end);
end

function BankBox.OpenRecharge()
    --_Socket.playaudio("btn",false,false,false)       

end

--重置按钮
function BankBox._resetBtn()
    --_Socket.playaudio("btn",false,false,false)       
    self.rightSlid(0)
    self.QuChu_Input.text = ""
    self.DXGold.text=""
end

--最大按钮
function BankBox._MaxBtn()
    --_Socket.playaudio("btn",false,false,false)       
    self.rightSlid(0)
    self.QuChu_Input.text = ""
    local _ExGold = math.floor(tonumber(self._nowGold))
    if _ExGold <= 0 then
        _ExGold = 0
    end
    self.rightSlid(1)
    self.QuChu_Input.text = _ExGold
end

--判断输入金额
function BankBox._EndInputOver()
    local _InputText = self.QuChu_Input.text
    if _InputText and _InputText ~= "" then
        if tonumber(_InputText) > 0 then
            _InputText = self.cutZreo(_InputText)
            if tonumber(_InputText) > self._nowGold then
                self.IsInputGold = true
                -- _InputText=(math.floor(self._nowGold)-8)
                _InputText = self._nowGold
                self.QuChu_Input.text = _InputText
                self.rightSlid(1)
                self.DXGold.text= numberToString(tonumber(self.QuChu_Input.text))
            else
                self.IsInputGold = true
                self.QuChu_Input.text = _InputText
                local _value = 0
                if self._nowGold > 0 then
                    _value = _InputText / self._nowGold
                end
                self.rightSlid(_value)
                self.DXGold.text= numberToString(tonumber(self.QuChu_Input.text))
            end
        else
            self.rightSlid(0)
            self.QuChu_Input.text = ""
        end
    else
        self.rightSlid(0)
        self.QuChu_Input.text = ""
    end
end

--slider控制金额
function BankBox._EndSliderOver()
    if self.IsInputGold then
        return ;
    end
    local _value = self.Slider.value
    self.QuChu_Input.text = math.floor((self._nowGold * _value) + 0.5)
    self.DXGold.text= numberToString(self.QuChu_Input.text)
end
--设置当前金币进度和%进度
function BankBox.rightSlid(_value)
    logError("kkkkkkkkkkk1")
    self.Slider.value = math.floor((_value*10)+0.5)/10
     logError("kkkkkkkkkkk2")
    self.IsInputGold = false
     logError("kkkkkkkkkkk3")
end

function BankBox.cutZreo(str)
    local str1 = tostring(str)
    for i = 1, string.len(str1) do
        if "0" == string.sub(str1, i, i) then
        else
            return string.sub(str1, i, string.len(str))
            --break
        end
    end
end


function  numberToString(szNum)
    ---阿拉伯数字转中文大写
    local szChMoney = ""
    local iLen = 0
    local iNum = 0
    local iAddZero = 0
    local hzUnit = {"", "拾", "佰", "仟", "万", "拾", "佰", "仟", "亿","拾", "佰", "仟", "万", "拾", "佰", "仟"}
    local hzNum = {"零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖"}
    if nil == tonumber(szNum) then
        return tostring(szNum)
    end
    iLen =string.len(szNum)
    if iLen > 10 or iLen == 0 or tonumber(szNum) < 0 then
        return tostring(szNum)
    end
    for i = 1, iLen  do
        iNum = string.sub(szNum,i,i)
        if iNum == 0 and i ~= iLen then
            iAddZero = iAddZero + 1
        else
            if iAddZero > 0 then
            szChMoney = szChMoney..hzNum[1]
        end
            szChMoney = szChMoney..hzNum[iNum + 1] --//转换为相应的数字
            iAddZero = 0
        end
        if (iAddZero < 4) and (0 == (iLen - i) % 4 or 0 ~= tonumber(iNum)) then
            szChMoney = szChMoney..hzUnit[iLen-i+1]
        end
    end
    local function removeZero(num)
        --去掉末尾多余的 零
        num = tostring(num)
        local szLen = string.len(num)
        local zero_num = 0
        for i = szLen, 1, -3 do
            szNum = string.sub(num,i-2,i)
            if szNum == hzNum[1] then
                zero_num = zero_num + 1
            else
                break
            end
        end
        num = string.sub(num, 1,szLen - zero_num * 3)
        szNum = string.sub(num, 1,6)
        --- 开头的 "一十" 转成 "十" , 贴近人的读法
        if szNum == hzNum[2]..hzUnit[2] then
            num = string.sub(num, 4, string.len(num))
        end
        return num
    end
    return removeZero(szChMoney)
end

return BankBox
