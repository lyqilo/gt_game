
CornucopiaSystem = { }
local self = CornucopiaSystem;
local _luaBeHaviour = nil;
local IsPlayingAnimator = false;
local SeedWait = 0;
-- ===========================================聚宝盆信息系统======================================
function CornucopiaSystem.Open()
    if self.CornucopiaPanel == nil then
        self.CornucopiaPanel = "obj";
        -- ResManager:LoadAsset("hall_getticket", "GetTicketPanel", self.OnCreacterChildPanel_Cornucopia);
        -- LoadAssetAsync("module02/hall_getticket", "GetTicketPanel", self.OnCreacterChildPanel_Cornucopia);

        self.OnCreacterChildPanel_Cornucopia(newobject(HallScenPanel.Pool("GetTicketPanel")));
    end
end
-- 创建UI的子面板_聚宝盆
function CornucopiaSystem.OnCreacterChildPanel_Cornucopia(prefab)
    -- local go =newobject(prefab)
    local go = prefab
    go.transform:SetParent(HallScenPanel.Compose.transform);
    go.name = "GetTicketPanel";
    go.layer = 5;
    go.transform.localScale = Vector3.New(0.1, 0.1, 0.1);
    go.transform.localPosition = Vector3.New(0, 1000, 0);
    self.CornucopiaPanel = go;
    CornucopiaSystem.ShowPanel(self.CornucopiaPanel);
    go = nil;
    --  Event.AddListener(PanelListModeEven._015ChangeGoldTicket, self.SetValue);
    CornucopiaSystem.NewInit(self.CornucopiaPanel, HallScenPanel.LuaBehaviour);
end

function CornucopiaSystem.NewInit(obj, luaBeHaviour)
    _luaBeHaviour = luaBeHaviour;
    local t = obj.transform;
    -- 赋值自己
    self.CornucopiaPanel = obj;
    self.onetxt = t:Find("First/Text").gameObject;
    self.oneBtn = t:Find("First/Button").gameObject;
    self.oneImgBtn = t:Find("First/Image").gameObject;
    self.twotxt = t:Find("Two/Text").gameObject;
    self.twoBtn = t:Find("Two/Button").gameObject;
    self.twoImgBtn = t:Find("Two/Image").gameObject;
    self.threetxt = t:Find("Three/Text").gameObject;
    self.threeBtn = t:Find("Three/Button").gameObject;
    self.threeImgBtn = t:Find("Three/Image").gameObject;
    self.goMall = t:Find("YesBtn").gameObject;
    self.CloseBtn = t:Find("CloseBtn").gameObject;
    self.BgCloseBtn = obj;
    self.oneBtn.name = "500000";
    self.twoBtn.name = "1000000";
    self.threeBtn.name = "5000000";
    self.oneImgBtn.name = "500000";
    self.twoImgBtn.name = "1000000";
    self.threeImgBtn.name = "5000000";
    self.onetxt:GetComponent('Text').text = "50万"
    self.twotxt:GetComponent('Text').text = "100万"
    self.threetxt:GetComponent('Text').text = "500万"
    luaBeHaviour:AddClick(self.oneBtn, self.TishiGetGoldBtnOnClick);
    luaBeHaviour:AddClick(self.twoBtn, self.TishiGetGoldBtnOnClick);
    luaBeHaviour:AddClick(self.threeBtn, self.TishiGetGoldBtnOnClick);
    luaBeHaviour:AddClick(self.oneImgBtn, self.TishiGetGoldBtnOnClick);
    luaBeHaviour:AddClick(self.twoImgBtn, self.TishiGetGoldBtnOnClick);
    luaBeHaviour:AddClick(self.threeImgBtn, self.TishiGetGoldBtnOnClick);
    luaBeHaviour:AddClick(self.BgCloseBtn, self.CornucopiaCloseBtnOnClick);
    luaBeHaviour:AddClick(self.CloseBtn, self.CornucopiaCloseBtnOnClick);
    luaBeHaviour:AddClick(self.goMall, self.MallBtnOnClick);
end
----隐藏和显示一个transform
function CornucopiaSystem.ShowPanel(g, isShow)
    local t = g.transform;
    if (t.localPosition.y > 100) then
        t.transform.localPosition = Vector3.New(0, 0, 0);
        --  效果测试代码
        local tweener = t.transform:DOScale(Vector3.New(1, 1, 1), 1);
        tweener:SetEase(DG.Tweening.Ease.OutBack);
    else
        t.localPosition = Vector3.New(0, 1000, 0);
    end
end

-- 按钮
function CornucopiaSystem.GoMallBtnOnClick()
    HallScenPanel.PlayeBtnMusic();
    Event.Brocast(PanelListModeEven._008exchangePanel);
    destroy(self.CornucopiaPanel);
end
-- 奖券金币赋值
function CornucopiaSystem.SetValue()
    local gold = gameData.GetProp(enum_Prop_Id.E_PROP_GOLD);
    local ticket = gameData.GetProp(enum_Prop_Id.E_PROP_TICKET);
    self.GoldTxt:GetComponent('Text').text = tostring(gold);
    self.TicketTxt:GetComponent('Text').text = tostring(ticket);
    --   self.ShowImgNum();
end

-- 关闭聚宝盆按钮
function CornucopiaSystem.CornucopiaCloseBtnOnClick()
    if IsPlayingAnimator == false then
        HallScenPanel.PlayeBtnMusic();
        -- 恢复被禁用的状态
        destroy(self.CornucopiaPanel);
        self.CornucopiaPanel = nil;
    else

    end
end

local CornucopiaNickName;
local CornucopiaNum;
local CornucopiaPwd;
local oldGold = 0;
local oldTicke = 0;

function CornucopiaSystem.TishiGetGoldBtnOnClick(obj)
    oldTicke = gameData.GetProp(enum_Prop_Id.E_PROP_TICKET);
    obj:GetComponent('Button').interactable = false;
    local t = GeneralTipsSystem_ShowInfo;
    t._01_Title = "提    示";
    t._03_ButtonNum = 2;
    if tonumber(obj.name) == 500000 then
        t._02_Content = "需要消耗五十万金币来获取奖券，是否操作？";
        t._04_YesCallFunction = CornucopiaSystem.OneStartGetGoldBtnOnClick;
    elseif tonumber(obj.name) == 1000000 then
        t._02_Content = "需要消耗一百万金币来获取奖券，是否操作？";
        t._04_YesCallFunction = CornucopiaSystem.TwoStartGetGoldBtnOnClick;
    elseif tonumber(obj.name) == 5000000 then
        t._02_Content = "需要消耗五百万金币来获取奖券，是否操作？";
        t._04_YesCallFunction = CornucopiaSystem.ThreeStartGetGoldBtnOnClick;
    end
    if int64.new(obj.name) > gameData.GetProp(enum_Prop_Id.E_PROP_GOLD) then
        t._02_Content = "你的金币不足，请前往充值界面充值";
        t._03_ButtonNum = 1;
        t._04_YesCallFunction = CornucopiaSystem.NoGetGoldBtnOnClick;
    end
    t._05_NoCallFunction = CornucopiaSystem.NoGetGoldBtnOnClick;
    MessageBox.CreatGeneralTipsPanel(t);
    obj:GetComponent('Button').interactable = true;
end

-- 点击取消聚宝
function CornucopiaSystem.NoGetGoldBtnOnClick()
    self.oneBtn:GetComponent('Button').interactable = true;
    self.twoBtn:GetComponent('Button').interactable = true;
    self.threeBtn:GetComponent('Button').interactable = true;
end
-- 点击第一个开始聚宝
function CornucopiaSystem.OneStartGetGoldBtnOnClick()
    HallScenPanel.PlayeBtnMusic();
    local buffer = ByteBuffer.New();
    local Data = { [1] = 500000, }
    buffer = SetC2SInfo(CS_GoldToPrize, Data);
    Network.Send(MH.MDM_3D_GOLDMINET, MH.SUB_3D_CS_GOLD_TO_PRIZET, buffer, gameSocketNumber.HallSocket);
end

-- 点击第二个开始聚宝
function CornucopiaSystem.TwoStartGetGoldBtnOnClick()
    HallScenPanel.PlayeBtnMusic();
    local buffer = ByteBuffer.New();
    local Data = { [1] = 1000000, }
    buffer = SetC2SInfo(CS_GoldToPrize, Data);
    Network.Send(MH.MDM_3D_GOLDMINET, MH.SUB_3D_CS_GOLD_TO_PRIZET, buffer, gameSocketNumber.HallSocket);
end

-- 点击第三个开始聚宝
function CornucopiaSystem.ThreeStartGetGoldBtnOnClick()
    HallScenPanel.PlayeBtnMusic();
    -- 播放聚宝动画
    local buffer = ByteBuffer.New();
    local Data = { [1] = 5000000, }
    buffer = SetC2SInfo(CS_GoldToPrize, Data);
    -- 发送数据
    Network.Send(MH.MDM_3D_GOLDMINET, MH.SUB_3D_CS_GOLD_TO_PRIZET, buffer, gameSocketNumber.HallSocket);
end

-- 点击聚宝服务器成功返回信息
function CornucopiaSystem.GetGoldSuccess(wSubID, buffer, wSize)
    local noticeText = nil;
    if wSubID == MH.SUB_3D_SC_GOLD_TO_PRIZET then
        if wSize == 0 then
            -- 播放聚宝动画
            error("聚宝成功")
            self.ValueShow(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD), gameData.GetProp(enum_Prop_Id.E_PROP_TICKET))
            HallScenPanel.UpdatePropInfo();
        else
            MessageBox.CreatGeneralTipsPanel("聚宝失败:" .. buffer:ReadString(wSize));
        end
    end
end
-- 播放数值减少，奖券增加
function CornucopiaSystem.ValueShow(gold, ticke)
    local showTicket =(ticke - oldTicke);
    -- 提示框，提示用户聚宝完成
    MessageBox.CreatGeneralTipsPanel("聚宝成功,获得<color=red>" .. showTicket .. "</color>个奖券");
end

function CornucopiaSystem.checkName(args)
    local buffer = ByteBuffer.New();
    local data = { [1] = args - 1000000, [2] = 1 }
	logError("发送金币请求：" .. data[1])
    buffer = SetC2SInfo(CS_UserInfoSelect, data);
	SeleteInfoToWindows=1;	
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_USER_INFO_SELECT, buffer, gameSocketNumber.HallSocket);
end

-- 显示输入的大写金额
function CornucopiaSystem.showUpperMoney(arg)
    local str = self.doUpperMoney(tonumber(arg), 0);
    local index = string.find(str, "零", 1);
    if index == 1 then
        str = string.sub(str, 4, -1);
    end
    self.upperMoneyTxt.text = str;
end

function CornucopiaSystem.checknameRes(args)
    if args[1] == 4294967295 then
        self.NickNameTishi.transform:Find("isTrue").gameObject:SetActive(false);
        self.NickNameTishi.transform:Find("isFalse").gameObject:SetActive(true);
        self.checknameTxt.text = "ID不存在";
        return;
    end
    self.checknameTxt.text = args[3];
    -- error("CornucopiaSystem.checknameRes___"..args[3]);
end

-- self.upperNum = {"零","壹","贰","叁","肆","伍","陆","柒","捌","玖","拾","佰","仟","万","亿"};
function CornucopiaSystem.doUpperMoney(args, index)
    local vlu = math.fmod(args, 10000);
    local falg = 0;
    local str = { };
    local num = 0;
    if vlu ~= 0 then
        if vlu >= 1000 then
            falg = math.floor(vlu / 1000);
            table.insert(str, self.upperNum[falg + 1] .. self.upperNum[13]);
            vlu = vlu - falg * 1000;
            num = 1;
        end

        if vlu >= 100 then
            falg = math.floor(vlu / 100);
            if num ~= 1 then
                table.insert(str, self.upperNum[1] .. self.upperNum[falg + 1] .. self.upperNum[12]);
            else
                table.insert(str, self.upperNum[falg + 1] .. self.upperNum[12]);
            end
            vlu = vlu - falg * 100;
            num = 2;
        end

        if vlu >= 10 then
            falg = math.floor(vlu / 10);
            if num ~= 2 then
                table.insert(str, self.upperNum[1] .. self.upperNum[falg + 1] .. self.upperNum[11]);
                -- elseif falg==1 then
                -- table.insert(str,self.upperNum[11]);
            else
                table.insert(str, self.upperNum[falg + 1] .. self.upperNum[11]);
            end
            vlu = vlu - falg * 10;
            num = 3;
        end

        if vlu > 0 then
            if num ~= 3 then
                table.insert(str, self.upperNum[1] .. self.upperNum[vlu + 1]);
            else
                table.insert(str, self.upperNum[vlu + 1]);
            end
        end
    end

    local restr = "";
    table.foreachi(str, function(i, v)
        restr = restr .. v;
    end )

    local nextv = "";
    args = math.floor(args / 10000);
    if args > 0 then
        nextv = self.doUpperMoney(args, index + 1);
    end

    if restr ~= "" then
        if index == 1 then
            restr = restr .. self.upperNum[14];
        elseif index == 2 then
            restr = restr .. self.upperNum[15];
        end
        return nextv .. restr
    end
    return nextv;
end




-- 显示需要提示的对象
function CornucopiaSystem.showTishi(obj, IsShow)
    if IsShow then
        obj.transform:Find("isTrue").gameObject:SetActive(true); obj.transform:Find("isFalse").gameObject:SetActive(false);
    else
        obj.transform:Find("isFalse").gameObject:SetActive(true); obj.transform:Find("isTrue").gameObject:SetActive(false);
        self.GiveGoldYesBtn:GetComponent('Button').interactable = false;
        self.GiveGoldYesBtn.transform:Find('Text').gameObject:SetActive(false);
        self.GiveGoldYesBtn.transform:Find('Press').gameObject:SetActive(true);
    end;
end

function CornucopiaSystem.CreatShowNum(prefeb)
    for i = 0, self.GoldNumobj.transform.childCount - 1 do
        destroy(self.GoldNumobj.transform:GetChild(i).gameObject);
    end
    for i = 1, string.len(self.GoldTxt:GetComponent('Text').text) do
        local prefebnum = string.sub(self.GoldTxt:GetComponent('Text').text, i, i);
        local go2 = newobject(prefeb.transform:GetChild(prefebnum).gameObject);
        go2.transform:SetParent(self.GoldNumobj.transform);
        go2.transform.localScale = Vector3.one;
        go2.transform.localPosition = Vector3.New(0, 0, 0);
    end
end
function CornucopiaSystem.CreatTickePrefeb(args)
    for i = 0, self.TicketNumobj.transform.childCount - 1 do
        destroy(self.TicketNumobj.transform:GetChild(i).gameObject);
    end
    for i = 1, string.len(self.TicketTxt:GetComponent('Text').text) do
        local prefebnum = string.sub(self.TicketTxt:GetComponent('Text').text, i, i);
        local go = newobject(args.transform:GetChild(prefebnum).gameObject);
        go.transform:SetParent(self.TicketNumobj.transform);
        go.transform.localScale = Vector3.one;
        go.transform.localPosition = Vector3.New(0, 0, 0);
    end
end


function CornucopiaSystem.ShowImgNum()
    --    self.CreatShowNum(tyNum);
    --    self.CreatTickePrefeb(tyNum);
    --   HallScenPanel.CreatShowNum(self.GoldNumobj,self.GoldTxt:GetComponent('Text').text);
    --   HallScenPanel.CreatShowNum(self.TicketNumobj,self.TicketTxt:GetComponent('Text').text);
end

function CornucopiaSystem.GetStrLenght(args)
    local lenInByte = #args;
    local strIndex = 0;
    for i = 1, lenInByte do
        local curByte = string.byte(args, i)
        local byteCount = 1;
        if curByte > 0 and curByte <= 127 then
            byteCount = 1;
            strIndex = strIndex + 1;
        elseif curByte >= 192 and curByte < 223 then
            byteCount = 2;
            strIndex = strIndex + 1;
        elseif curByte >= 224 and curByte < 239 then
            byteCount = 3;
            strIndex = strIndex + 1;
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = 4;
            strIndex = strIndex + 1;
        end
        i = i + byteCount - 1;
    end
    return strIndex;
end

function CornucopiaSystem.WaitTishi()
    if SeedWait < 0 then return end
    coroutine.wait(1);
    SeedWait = SeedWait + 1;
    if SeedWait > 15 then MessageBox.CreatGeneralTipsPanel("连接服务器超时，请重新请求"); SeedWait = -10; self.SetBtnTxt(); return end
    coroutine.start(self.WaitTishi);
end

function CornucopiaSystem.MallBtnOnClick()
    self.CornucopiaCloseBtnOnClick()
    Event.Brocast(PanelListModeEven._008exchangePanel);
end


function CornucopiaSystem.GiveGoldRecordOnClick()
    GiveAndSendMoneyRecordPanle.showPanel(self.CornucopiaPanel.transform.parent);
end
