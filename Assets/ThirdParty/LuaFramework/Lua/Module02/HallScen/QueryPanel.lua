--[[require "Common/define"
require "Data/gameData"
require "Data/DataStruct"
require "module02/unitPublic"]]


QueryPanel = { }
local self = QueryPanel;

self.luaBehaviour = nil;
self.queryIDTimer = 0;
self.queryCardTimer = 0;
self.maxTimer = 20;
self.isDownID = false;
self.isDownCard = false;
self.exitIDTimer = 0;
self.exitCardTimer = 0;
function QueryPanel.Init(obj)
    self.transform = obj.transform;
    self.gameObject = obj.gameObject;
    self.queryPanel = self.gameObject;
    self.gameObject.transform.localScale = Vector3.New(1, 1, 1);
    -- self.gameObject.transform.localPosition = Vector3.New(0, 0, 0);
    self.luaBehaviour = self.transform:GetComponent("LuaBehaviour");
    if self.luaBehaviour == nil then
        self.luaBehaviour = Util.AddComponent("LuaBehaviour", self.gameObject);
    end
end
function QueryPanel.Awake(obj)
    self.queryId = self.transform:Find("Content/QueryID/InputField"):GetComponent("InputField");
    self.queryIdBtn = self.transform:Find("Content/QueryID/QueryBtn").gameObject;
    self.queryIdObj = self.transform:Find("Content/QueryID/QueryBtn/Img").gameObject;
    self.queryIdText = self.transform:Find("Content/QueryID/QueryBtn/Text"):GetComponent("Text");
    self.queryCard = self.transform:Find("Content/QueryCard/InputField"):GetComponent("InputField");
    self.queryCardBtn = self.transform:Find("Content/QueryCard/QueryBtn").gameObject;
    self.queryCardObj = self.transform:Find("Content/QueryCard/QueryBtn/Img").gameObject;
    self.queryCardText = self.transform:Find("Content/QueryCard/QueryBtn/Text"):GetComponent("Text");

    --self.closeBtn = self.transform:Find("Content/Close").gameObject;
    self.balancegold = self.transform:Find("Content/QueryBalance/Balance"):GetComponent("Text");
    --self.balancegold.transform.parent.gameObject:SetActive(false);
    self.cardResult = self.transform:Find("Content/Group/CardResult");
    self.recordResult = self.transform:Find("Content/Group/RecordResult");

    self.InitID();
    self.InitRecord();
    self.cardResult.gameObject:SetActive(true);
    self.recordResult.gameObject:SetActive(false);
    local isexitIDTimer = PlayerPrefs.HasKey("RamindID");
    if isexitIDTimer then
        local iddata = PlayerPrefs.GetString("RamindID");
        local idarr = string.split(iddata, "|");
        self.queryIDTimer = tonumber(idarr[1]) - (os.time() - tonumber(idarr[2]));
        if self.queryIDTimer > 0 then
            self.queryIdBtn.transform:GetComponent("Button").interactable = false;
            self.isDownID = true;
        else
            self.queryIdBtn.transform:GetComponent("Button").interactable = true;
            self.queryIdObj:SetActive(true);
            self.queryIdText.text = "";
            self.isDownID = false;
        end
        PlayerPrefs.DeleteKey("RamindID");
    else
        self.queryIdBtn.transform:GetComponent("Button").interactable = true;
        self.queryIdObj:SetActive(true);
        self.queryIdText.text = "";
        self.isDownID = false;
    end
    local isexitCardTimer = PlayerPrefs.HasKey("RamindCard");
    if isexitCardTimer then
        local carddata = PlayerPrefs.GetString("RamindCard");
        local cardarr = string.split(carddata, "|");
        self.queryIDTimer = tonumber(cardarr[1]) - math.ceil((os.time() - tonumber(cardarr[2])));
        if self.queryCardTimer > 0 then
            self.queryCardBtn.transform:GetComponent("Button").interactable = false;
            self.isDownCard = true;
        else
            self.queryCardBtn.transform:GetComponent("Button").interactable = true;
            self.queryCardObj:SetActive(true);
            self.queryCardText.text = "";
            self.isDownCard = false;
        end
        PlayerPrefs.DeleteKey("RamindCard");
    else
        self.queryCardBtn.transform:GetComponent("Button").interactable = true;
        self.queryCardObj:SetActive(true);
        self.queryCardText.text = "";
        self.isDownCard = false;
    end

end

function QueryPanel.Start()
    self.luaBehaviour:AddClick(self.queryIdBtn, self.OnClickQueryIdCall);
    self.luaBehaviour:AddClick(self.queryCardBtn, self.OnClickQueryCardCall);
    --self.luaBehaviour:AddClick(self.closeBtn, self.OnClickCloseCall);
end

function QueryPanel.Update()
    if self.isDownCard then
        self.queryCardTimer = self.queryCardTimer - Time.deltaTime;
        self.queryCardObj:SetActive(false);
        self.queryCardText.text = "<color=black>" .. math.ceil(self.queryCardTimer) .. "s</color>";
        if self.queryCardTimer <= 0 then
            self.queryCardTimer = self.maxTimer;
            self.isDownCard = false;
            self.queryCardBtn.transform:GetComponent("Button").interactable = true;
            self.queryCardObj:SetActive(true);
            self.queryCardText.text = "";
        end
    end
    if self.isDownID then
        self.queryIDTimer = self.queryIDTimer - Time.deltaTime;
        self.queryIdText.text = "<color=black>" .. math.ceil(self.queryIDTimer) .. "s</color>";
        self.queryIdObj:SetActive(false);
        if self.queryIDTimer <= 0 then
            self.queryIDTimer = self.maxTimer;
            self.isDownID = false;
            self.queryIdBtn.transform:GetComponent("Button").interactable = true;
            self.queryIdObj:SetActive(true);
            self.queryIdText.text = "";
        end
    end
end
function QueryPanel.InitID()
    self.cardNum = self.cardResult:Find("CardNum/Desc"):GetComponent("Text");
    self.isUsed = self.cardResult:Find("IsUsed/Desc"):GetComponent("Text");
    self.UserId = self.cardResult:Find("UserID/Desc"):GetComponent("Text");
    self.UseTime = self.cardResult:Find("UseTime/Desc"):GetComponent("Text");
    self.cardNum.text = "";
    self.isUsed.text = "";
    self.UserId.text = "";
    self.UseTime.text = "";
    self.balancegold.text = "";
end
function QueryPanel.InitRecord()
    self.recordResultGroup = self.recordResult:Find("Result/Viewport/Content");
    for i = 0, self.recordResultGroup.childCount - 1 do
        self.recordResultGroup:GetChild(i).gameObject:SetActive(false);
    end
    self.balancegold.text = "";
end

function QueryPanel.OnClickQueryIdCall(go)
    self.queryIdBtn.transform:GetComponent("Button").interactable = false;
    self.queryIDTimer = self.maxTimer;
    self.queryIdText.text = "<color=black>" .. math.ceil(self.queryIDTimer) .. "s</color>";
    self.queryIdObj:SetActive(false);
    self.isDownID = true;
    self.InitID();
    self.InitRecord();
    self.queryCard.text = "";

    if string.len(self.queryId.text) <= 0 then
        MessageBox.CreatGeneralTipsPanel("请输入正确的ID!");
        return ;
    end
    self.cardResult.gameObject:SetActive(false);
    self.recordResult.gameObject:SetActive(true);
    local bytebuffer = ByteBuffer.New();
    bytebuffer:WriteInt(tonumber(self.queryId.text));--玩家id
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_QUERY_UP_SCORE_RECORD, bytebuffer, gameSocketNumber.HallSocket);
end
function QueryPanel.OnClickQueryCardCall(go)
    self.queryCardBtn.transform:GetComponent("Button").interactable = false;
    self.queryCardTimer = self.maxTimer;
    self.queryCardText.text = "<color=black>" .. math.ceil(self.queryCardTimer) .. "s</color>";
    self.queryCardObj:SetActive(false);
    self.isDownCard = true;
    self.InitID();
    self.InitRecord();
    self.queryId.text = "";
    self.balancegold.text = "0";
    if string.len(self.queryCard.text) <= 0 then
        MessageBox.CreatGeneralTipsPanel("请输入正确的兑换码!");
        return ;
    end
    self.cardResult.gameObject:SetActive(true);
    self.recordResult.gameObject:SetActive(false);
    local bytebuffer = ByteBuffer.New();
    bytebuffer:WriteBytes(9, self.queryCard.text);--兑换码 只可能是7(EXCHANGE_CODE_LEN - 1)位数字和大小字母的组合
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_QUERY_EXCHANGE_CODE, bytebuffer, gameSocketNumber.HallSocket);
end

function QueryPanel.RecordCallBack(buffer)
    local cbRes = buffer:ReadByte();
    if cbRes == 0 then
        log("没有数据")
        MessageBox.CreatGeneralTipsPanel("没有查询到该玩家！");
        return ;
    end
    local cbCount = buffer:ReadByte();
    for i = 0, 9 do
        local child = nil;
        if self.recordResultGroup.childCount > i then
            child = self.recordResultGroup:GetChild(i);
        else
            child = newObject(self.recordResultGroup:GetChild(0));
            child.transform:SetParent(self.recordResultGroup);
            child.transform.localScale = Vector3.New(1, 1, 1);
            child.transform.localPosition = Vector3.New(0, 0, 0);
        end
        local mIndex = buffer:ReadInt();
        local mSenderId = buffer:ReadInt();
        local mRecverId = buffer:ReadInt();
        local mGold = buffer:ReadInt64Str();
        local mTime = buffer:ReadInt();
        child.transform:Find("Order"):GetComponent("Text").text = tostring(mIndex);
        child.transform:Find("Receive"):GetComponent("Text").text = tostring(mRecverId);
        child.transform:Find("Send"):GetComponent("Text").text = tostring(mSenderId);
        child.transform:Find("Number"):GetComponent("Text").text = tostring(mGold);
        child.transform:Find("Time"):GetComponent("Text").text = tostring(os.date("%m.%d-%H:%M", mTime));
        if i < cbCount then
            child.gameObject:SetActive(true);
        else
            child.gameObject:SetActive(false);
        end
    end
    local m_balance = buffer:ReadInt64Str();
    log("余额：" .. m_balance);
    self.balancegold.text = m_balance;
end
function QueryPanel.ExchangeCallBack(buffer)
    local cbRes = buffer:ReadByte();
    if cbRes == 0 then
        MessageBox.CreatGeneralTipsPanel("没有此兑换码！");
        return ;
    end
    local isUsed = buffer:ReadByte();
    local muserID = buffer:ReadInt();
    local mtimer = buffer:ReadInt();
    local mgold = buffer:ReadInt();
    self.cardNum.text = tostring(mgold);
    self.isUsed.text = isUsed == 0 and "未使用" or "已使用";
    self.UserId.text = tostring(muserID);
    self.UseTime.text = tostring(os.date("%Y年%m月%d日 %H:%M", mtimer));
end
function QueryPanel.OnClickCloseCall(go)
    HallScenPanel.PlayBtnOnClick();
    HallScenPanel.BackHallOnClick();
    self.queryPanel = nil;
    self.transform = nil;
    self.gameObject = nil;
end
function QueryPanel.OnDestroy()
    if self.isDownCard then
        PlayerPrefs.SetString("RamindCard", self.queryCardTimer .. "|" .. os.time());
    end
    if self.isDownID then
        PlayerPrefs.SetString("RamindID", self.queryIDTimer .. "|" .. os.time());
    end
    self.queryPanel = nil;
    self.transform = nil;
    self.gameObject = nil;
end
