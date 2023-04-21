--[[require "Common/define"
require "Data/gameData"
require "Data/DataStruct"]]

RechargeInfoSystem = { };
local self = RechargeInfoSystem;
local _luab
FirstReChargeInfoData = { };
-- ===========================================充值信息系统======================================
function RechargeInfoSystem.Open()
    if HallScenPanel.MidCloseBtn == self.RechargeCloseBtnOnClick then return end
    if HallScenPanel.MidCloseBtn ~= nil then HallScenPanel.MidCloseBtn(); HallScenPanel.MidCloseBtn = nil end
    if self.RechargeInfoPanel == nil then
        if #AllRecharege == 0 then
            local buffer = ByteBuffer.New();
            -- 获取充值数据
            Network.Send(MH.MDM_3D_RECHARGE, MH.SUB_3D_CS_RECHARGE_LIST, buffer, gameSocketNumber.HallSocket);
        end
        self.RechargeInfoPanel = "obj";
        -- LoadAssetAsync("module02/hall_recharge", "RechargeInfoPanel", self.OnCreacterChildPanel_Recharge, true, true);
        self.OnCreacterChildPanel_Recharge(HallScenPanel.Pool("RechargeInfoPanel"));
    end
end

-- 创建UI的子面板_充值
function RechargeInfoSystem.OnCreacterChildPanel_Recharge(prefab)
    local go = prefab;
    go.transform:SetParent(HallScenPanel.Compose.transform);
    go.name = "RechargeInfoPanel";
    go.layer = 5;
    go.transform.localScale = Vector3.New(1, 1, 1);
    go.transform.localPosition = Vector3.New(900, 0, 0);
    self.RechargeInfoPanel = go;
    HallScenPanel.LastPanel = self.RechargeInfoPanel
    HallScenPanel.SetXiaoGuo(self.RechargeInfoPanel)
    self.Init(self.RechargeInfoPanel, HallScenPanel.LuaBehaviour);
    go = nil;
    HallScenPanel.SetBtnInter(true);
end


function RechargeInfoSystem.Init(obj, luaBehaviour)
    local t = obj.transform;
    -- 赋值自己
    self.RechargeInfoPanel = obj;
    -- 初始化面板
    self.RechargeCloseBtn = t:Find("RechargCloseBtn").gameObject;
    self.ShopShow = t:Find("Bg/MainInfo/ShopShow").gameObject;
    self.ShopShow.transform:GetChild(0).gameObject:SetActive(false);
    self.Left = t:Find("Left").gameObject;
    self.Right = t:Find("Right").gameObject;
    self.luab = luaBehaviour
    luaBehaviour:AddClick(self.RechargeCloseBtn, self.RechargeCloseBtnOnClick);

    luaBehaviour:AddClick(self.Left, self.LeftOnClick);
    luaBehaviour:AddClick(self.Right, self.RightOnClick);
    self.RechargeZheZhao = t:Find("zhezhao").gameObject;
    self.RechargeZheZhao:SetActive(false);
    self.FirstRecharg = t:Find("FirstImg").gameObject;
	self.FirstRecharg:SetActive(false);
    self.QQ = t:Find("QQ").gameObject;
    -- hall2代表游戏QQ
    if GCF == nil or GCF[GameManager.GetBid() .. AppConst.Version] == nil then
        GameQQ = GameQQ;
    else
        GameQQ = GCF[GameManager.GetBid() .. AppConst.Version][enum_hall.hall2] or GameQQ;
    end
    self.QQ.transform:GetComponent('Text').text = "客服QQ: " .. GameQQ;
    self.QQCopyBtn = self.QQ.transform:Find("Button").gameObject;
    --
    luaBehaviour:AddClick(self.QQCopyBtn, self.QQCopyBtnOnClick);
    if gameIsOnline then self.QQ:SetActive(true); else self.QQ:SetActive(false); end
--[[    if SCPlayerInfo._16bIsFirstRecharge == 1 then
        self.FirstRecharg.transform:Find("num"):GetComponent('Text').text = "首次充值额外赠送" .. SCSystemInfo._11wFirstRechargePresentRate .. "%";
        self.FirstRecharg:SetActive(true);
    elseif SCPlayerInfo._21dwStartServerRecharge == 1 then
        self.FirstRecharg.transform:Find("num"):GetComponent('Text').text = "首次充值额外赠送" .. SCSystemInfo._13wStartRechargePresentRate .. "%";
        self.FirstRecharg:SetActive(true);
    else
        self.FirstRecharg:SetActive(false);
    end--]]
    _luab = luaBehaviour;
    self.UpdateRecharge();
    HallScenPanel.MidCloseBtn = self.RechargeCloseBtnOnClick
end

-- 关闭按钮
function RechargeInfoSystem.RechargeCloseBtnOnClick()
    HallScenPanel.PlayeBtnMusic();
    destroy(self.RechargeInfoPanel);
    self.RechargeInfoPanel = nil;
end

function RechargeInfoSystem.QQCopyBtnOnClick()
    if Util.isAndroidPlatform then Util.CopyTextToClipboard(GameQQ); return end
    if Util.isApplePlatform then Util.CopyTextToClipboard(GameQQ); return end
    local textEditor = TextEditor.New();
    textEditor.text = GameQQ;
    TextEditor.OnFocus(textEditor);
    TextEditor.Copy(textEditor);
end

function RechargeInfoSystem.LeftOnClick()
    self.LeftOrRight(1)
end

function RechargeInfoSystem.RightOnClick()
    self.LeftOrRight(-1)
end

-- 滑动
function RechargeInfoSystem.LeftOrRight(xishu)
    local x = self.ShopShow.transform.localPosition.x + xishu * 317
    self.ShopShow.transform:DOLocalMoveX(x, 0.2, false);
end

function RechargeInfoSystem.UpdateRecharge()
    local goldImg = nil;
    local goldNum = nil;
    local bilinum = 1;
    if SCPlayerInfo._16bIsFirstRecharge == 1 then
        bilinum = bilinum +(SCSystemInfo._11wFirstRechargePresentRate / 100);
    elseif SCPlayerInfo._21dwStartServerRecharge == 1 then
        bilinum = bilinum +(SCSystemInfo._13wStartRechargePresentRate / 100);
    else
        bilinum = 1;
    end
    local a = 1;
    -- self.ShopShow.transform:GetChild(0).gameObject:SetActive(true);
    local newprefeb = self.ShopShow.transform:GetChild(0).gameObject;
    if IsNil(newprefeb) then return end
    if #AllRecharege > self.ShopShow.transform.childCount then return end

    for i = #AllRecharege, self.ShopShow.transform.childCount - 1 do
        if #AllRecharege == 0 then i = i + 1 end;
        local go = self.ShopShow.transform:GetChild(i - 1).gameObject
	    _luab:AddClick(go, self.ChongzhiBtnOnClick);
        go:SetActive(true);
    end
	
--[[    for i = 1, #AllRecharege do
        local go = nil;
        if AllRecharege[i][5] ~= 1 and AllRecharege[i][5] ~= 18 then
            go = self.ShopShow.transform:GetChild(i - 1).gameObject;
            a = a + 1;
            go.transform:Find("RMB").gameObject:GetComponent('Text').text = AllRecharege[i][5] .. "元";
            go:SetActive(true);
            local isshow = true;
            for k = 1, #FirstReChargeInfoData do
                if AllRecharege[i][1] == FirstReChargeInfoData[k] then isshow = false; end
            end
            goldNum = AllRecharege[i][4];
            -- * bilinum;
            go.transform:Find("FirstImg").gameObject:SetActive(isshow);
            go.transform:Find("Gold"):GetComponent('Text').text = unitPublic.showNumberText(goldNum) .. "金币"
            go.name = "Chongzhi" ..(i - 1);
            _luab:AddClick(go, self.ChongzhiBtnOnClick);
        end
    end--]]
end
local IsChongzhiBtn = false;
function RechargeInfoSystem.ChongzhiBtnOnClick(args)
	MessageBox.CreatGeneralTipsPanel("该平台不支持充值");
	do return end 
    if not(Util.isApplePlatform) then MessageBox.CreatGeneralTipsPanel("该平台不支持充值"); end
    local isshow = true;
    if WebAppInfo ~= nil then isshow = WebAppInfo.buy; end
    if isshow == false then
        FramePopoutCompent.Show("充值系统维护中") error("不能购买")
        return
    end
    --  local btnparset = args.transform.parent.gameObject;
    --    local chongzhiNum = btnparset.transform:Find("Add/InputField"):GetComponent('InputField').text;
    --    if tonumber(chongzhiNum) == 0 then return end
    --    if tonumber(chongzhiNum) == nil then return end
    --    if string.len(chongzhiNum) == 0 then chongzhiNum = 1 end
    -- 充值的数量=充值按钮的ID（不同的ID代表不同的值）*输入的数量
    -- local needRMB=btnparset:Find("RMB").gameObject:GetComponent('Text').text;
    -- 这里要对渠道进行判断，因为不同的渠道充值方式是不一样的
    -- 设置页面遮罩
    IsChongzhiBtn = true;
    self.RechargeZheZhao:SetActive(true);
    if VersionInfo[2] == Channel.AppSotre then self.IOSPay(args, 1) end
    coroutine.start(self.waitTiemFalse);
end

-- 苹果的商店内购
function RechargeInfoSystem.IOSPay(btn, payNumber)
    -- payID是指购买的商品在苹果商店的唯一ID，这里传来的是用户点击按钮的ID，要转换
    local payID = string.gsub(btn.name, "Chongzhi", "");
    -- 把payID转为苹果商店定义好的ID
    error("tonumber(payID)" .. tonumber(payID));
    payID = BundleIdentifier .. "." .. AllRecharege[(tonumber(payID) + 1)][5];
    -- 调用C#层的内购接口，传入购买的商品ID和数目
    error("PayId=" .. payID .. "," .. "Paynumber=" .. payNumber);
    if Util.isApplePlatform then
        palyAppID = payID;
        -- IOS绑定充值的回调
        NetManager:PayCallBackMethod(self.PayCallBack, self.PayFailed, self.ProvideContent);
        NetManager:CallIOSPay(payID, payNumber);

    else
        IsChongzhiBtn = false; self.RechargeZheZhao:SetActive(false); error("当前平台没有充值入口");
    end
end

-- 购买的回调
function RechargeInfoSystem.PayCallBack(args)
    error("lua层收到购买的回调");
    IsChongzhiBtn = false;
    if RechargeInfoSystem.RechargeInfoPanel == nil then return end;
    self.RechargeZheZhao:SetActive(false);
end
local waitNum = 0;
function RechargeInfoSystem.waitTiemFalse()
    coroutine.wait(1);
    if IsChongzhiBtn then
        waitNum = waitNum + 1;
        if waitNum == 30 then
            if self.RechargeInfoPanel == nil then IsChongzhiBtn = false; waitNum = 0; return; else if self.RechargeZheZhao.activeSelf then self.RechargeZheZhao:SetActive(false); IsChongzhiBtn = false; waitNum = 0; return; end end
        end
        coroutine.start(self.waitTiemFalse);
    else
        waitNum = 0; return;
    end
end

-- 服务器返回是否购买成功
function RechargeInfoSystem.ServerBuyOk(wSubID, buffer, wSize)
    -- 0=false  1=true
    local bl = buffer:ReadByte();
    error("充值结果=" .. bl);
    if bl == 0 then
        if isProvideContent then
            error("ios充值结果验证出错，再次请求验证！"); self.SendBuyOver(strProvideContent); isProvideContent = false;
        else
            FramePopoutCompent.Show("充值失败，请与游戏客服联系")
        end
    end
    -- 充值成功的处理
    if bl == 1 then
        -- 这里应该判断一下是不是ios充值！只有ios内购返回才有订单id
        FramePopoutCompent.Show("充值成功")
        local palyAppID = buffer:ReadString(buffer:ReadUInt16());
        NetManager:ServerBuyOk(palyAppID);
        if SCPlayerInfo._16bIsFirstRecharge == 1 then
            SCPlayerInfo._16bIsFirstRecharge = 0;
            self.FirstRecharg:SetActive(false);
            --            for i = 0, self.ShopShow.transform.childCount - 1 do
            --                self.ShopShow.transform:GetChild(i):Find("FirstImg").gameObject:SetActive(false);
            --            end
        end
        self.UpdateRecharge();
        self.SetValue();
        HallScenPanel.UpdatePropInfo();
    end
    --  Event.RemoveListener(tostring(MH.MDM_3D_RECHARGE));
    IsChongzhiBtn = false;
    self.RechargeZheZhao:SetActive(false);
end
-- 获取商品回执
local isProvideContent = false;
local strProvideContent = "";
function RechargeInfoSystem.ProvideContent(args)
    error("lua层收到商品回执=" .. args);
    -- 接下来 请求服务器验证，服务器告诉成功了要对调 ServerBuyOk方法
    isProvideContent = true;
    strProvideContent = args;
    self.SendBuyOver(args);
end
function RechargeInfoSystem.SendBuyOver(args)
    -- 接下来 请求服务器验证，服务器告诉成功了要对调 ServerBuyOk方法

    function a(str)
        local buffer = ByteBuffer.New();
        local Data =
        {
            [1] = str,
        }
        error(str);
        buffer = SetC2SInfo(CS_RecharegeAppstore, Data);
        error("1");
        Network.Send(MH.MDM_3D_RECHARGE, MH.SUB_3D_CS_RECHARGE_APPSTORE, buffer, gameSocketNumber.HallSocket);
        error("2");
    end

    a("start:");
    local num = 1000;
    local str = { };
    local count = string.len(args) / num;
    local mod = math.modf(string.len(args), num);
    if mod == 0 then
        count = count;
    end

    for i = 0, count - 1 do
        str[i + 1] = string.sub(args, i * num + 1, i * num + num);
    end
    if mod ~= 0 then
        str[#str + 1] = string.sub(args, #str * num + 1, string.len(args));
    end

    for i = 1, #str do
        a(str[i])
    end

    a("end:")

end
-- 购买失败
function RechargeInfoSystem.PayFailed(args)
    error("lua层收到购买失败=" .. args);
    IsChongzhiBtn = false;
    self.RechargeZheZhao:SetActive(false);
    -- args 小于1 说明用户点击了取消按钮，这个不应该提示
    if string.match(args, "Code=0") then
        FramePopoutCompent.Show("连接充值服务器失败")
    end
end

--- 接受服务器传来的信息
function RechargeInfoSystem.SetInfo(wSubID, buffer)
--[[    if wSubID == MH.SUB_3D_SC_RECHARGE_LIST_START then AllRecharege = { }; end
    if wSubID == MH.SUB_3D_SC_RECHARGE_LIST then
        local data = GetS2CInfo(SC_RecharegeList, buffer)
        table.insert(AllRecharege, data);
    end
    if wSubID == MH.SUB_3D_SC_RECHARGE_LIST_STOP then
        self.UpdateRecharge();
    end--]]
end

function RechargeInfoSystem.ShowNum(prefeb)

    local str = tostring(goldNum);
    for i = 1, string.len(str) do
        local prefebnum = string.sub(str, i, i);
        local go = newobject(prefeb.transform:GetChild(prefebnum).gameObject);
        go.transform:SetParent(goldImg.transform);
        go.transform.localScale = Vector3.one;
        go.transform.localPosition = Vector3.New(0, 0, 0);
    end
end

-- 奖券金币赋值
function RechargeInfoSystem.SetValue()
    local gold = gameData.GetProp(enum_Prop_Id.E_PROP_GOLD);
    local ticket = gameData.GetProp(enum_Prop_Id.E_PROP_TICKET);
    self.GoldTxt.text = tostring(gold);
    self.TicketTxt.text = tostring(ticket);
    --   self.ShowImgNum(gold, ticket);

end

function RechargeInfoSystem.CreatShowNum(gold, parset)
    for i = 0, parset.transform.childCount - 1 do
        destroy(parset.transform:GetChild(i).gameObject);
    end
    for i = 1, string.len(gold) do
        local prefebnum = string.sub(gold, i, i);
        local go2 = newobject(self.ChongzhiNum.transform:GetChild(prefebnum).gameObject);
        go2.transform:SetParent(parset.transform);
        go2.transform.localScale = Vector3.one;
        go2.transform.localPosition = Vector3.New(0, 0, 0);
    end

end

function RechargeInfoSystem.CreatTickePrefeb(args)
    for i = 0, self.TicketNum.transform.childCount - 1 do
        destroy(self.TicketNum.transform:GetChild(i).gameObject);
    end
    for i = 1, string.len(self.TicketTxt.text) do
        local prefebnum = string.sub(self.TicketTxt.text, i, i);
        local go = newobject(args.transform:GetChild(prefebnum).gameObject);
        go.transform:SetParent(self.TicketNum.transform);
        go.transform.localScale = Vector3.one;
        go.transform.localPosition = Vector3.New(0, 0, 0);
    end
end

function RechargeInfoSystem.ShowImgNum()
    --    ResManager:LoadAsset('tynum', "TyNum", self.CreatShowNum);
    --    ResManager:LoadAsset('tynum', "TyNum", self.CreatTickePrefeb);
    --    self.CreatShowNum(tyNum);
    --    self.CreatTickePrefeb(tyNum);
    --  HallScenPanel.CreatShowNum(self.GoldNum, self.GoldTxt.text);
    --   HallScenPanel.CreatShowNum(self.TicketNum, self.TicketTxt.text);
end
