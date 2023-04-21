--[[require "Common/define"
require "Data/gameData"
require "Data/DataStruct"]]

MallInfoSystem = { }
local self = MallInfoSystem;
local _LuaBeHaviour = nil;
local GoodsId = nil;
local GoodsValue = nil;
local RecordInfo = { };
-- 商城所有物品
local AllMallInfo = { }
-- ===========================================商城信息系统======================================
function MallInfoSystem.Open()
    if true then return end
    if self.MallInfoPanel == nil then
        self.MallInfoPanel = "obj";

        -- LoadAssetAsync("hall_twobg", "TwoBg", self.OnCreacterChildPanel_Mall);
        -- ResManager:LoadAsset("hall_mall", "MallInfoPanel", self.OnCreacterChildPanel_Mall);
        -- LoadAssetAsync("module02/hall_mall", "MallInfoPanel", self.OnCreacterChildPanel_Mall);
        self.OnCreacterChildPanel_Mall(HallScenPanel.Pool("MallInfoPanel"));
    end
end

-- 创建UI的子面板_商城
function MallInfoSystem.OnCreacterChildPanel_Mall(prefeb)
    local go = prefeb;
    go.transform:SetParent(HallScenPanel.Compose.transform);
    go.name = "MallInfoPanel";
    go.transform.localScale = Vector3.New(1, 1, 1);
    go.transform.localPosition = Vector3.New(0, 1000, 0);
    self.MallInfoPanel = go;

    self.Bg = go.transform:Find("Bg").gameObject;
    self.Bg.transform.localScale = Vector3.New(0.1, 0.1, 0.1);
    MallInfoSystem.Init(self.MallInfoPanel, HallScenPanel.LuaBehaviour);
    if #AllMallInfo == 0 then
        MallInfoSystem.SelectGoods();
    else
        MallInfoSystem.CreatPrefebGoods(self.GoodsImgPrefeb);
    end;
    Event.AddListener(PanelListModeEven._015ChangeGoldTicket, self.SetValue);
    MallInfoSystem.ShowPanel(self.MallInfoPanel);
    HallScenPanel.SetXiaoGuo(self.Bg)
end

-- 显示商城信息
function MallInfoSystem.ShowMallInfo(prefeb)
    local go = prefeb;
    go.transform:SetParent(self.MallInfoPanel.transform);
    go.name = "Bg";
    go.transform.localScale = Vector3.New(1, 1, 1);
    go.transform.localPosition = Vector3.New(0, 0, 0);
    self.Bg = go;
    MallInfoSystem.Init(self.MallInfoPanel, HallScenPanel.LuaBehaviour);
    if #AllMallInfo == 0 then
        MallInfoSystem.SelectGoods();
    else
        MallInfoSystem.CreatPrefebGoods(self.GoodsImgPrefeb);
    end;
    Event.AddListener(PanelListModeEven._015ChangeGoldTicket, self.SetValue);
end


function MallInfoSystem.Init(obj, LuaBeHaviour)
    local t = obj.transform;
    _LuaBeHaviour = LuaBeHaviour;
    -- 赋值自己
    self.MallInfoPanel = obj;
    -- 初始化面板
    self.Bg = t:Find("Bg").gameObject;
    self.MallInfoCloseBtn = t:Find("CloseBtn").gameObject;
    self.ShopShow = t:Find("Bg/Bg/MainInfo/ShopShow").gameObject;
    -- 创建商品显示地方
    self.GoldTxt = t:Find("Bg/Bg/GoldImg/Text").gameObject:GetComponent('Text');
    self.TicketTxt = t:Find("Bg/Bg/TicketImg/Text").gameObject:GetComponent('Text');
    self.GoodsImg = t:Find("Bg/GoodsImg").gameObject;
    -- 所有图片
    self.GoodsImg:SetActive(false);
    self.GoodsImgPrefeb = self.ShopShow.transform:Find("Goods").gameObject;
    -- 商品Prefeb
    self.GoodsImgPrefeb:SetActive(false);
    self.RecordBtn = t:Find("Bg/Bg/RecordBtn").gameObject;
    -- 查询兑奖记录
    self.RecordPanel = t:Find("Bg/Record").gameObject;
    self.CloseRecord = t:Find("Bg/Record/CloseRecord").gameObject;
    self.CloseRecordTwo = t:Find("Bg/Record/Close").gameObject;
    self.RecordTicketBtn = t:Find("Bg/Bg/RecordTicketBtn").gameObject;
    -- 获取奖券
    self.RecordMainInfo = t:Find("Bg/Record/Mask/MainInfo").gameObject;
    -- 实物面板（虚物合成一个面板）
    self.RecordInfoPanel = t:Find("Bg/RecordInfo");
    self.RecordInfoImage = self.RecordInfoPanel:Find("GoodsImg/Image").gameObject;
    self.RecordInfolmessage = self.RecordInfoPanel:Find("Info").gameObject;
    self.needTicket = self.RecordInfoPanel:Find("Ticket/Text").gameObject;
    self.RecordInfoYesBtn = self.RecordInfoPanel:Find("YesBtn").gameObject;
    self.RecordInfoNoBtn = self.RecordInfoPanel:Find("NoBtn").gameObject;
    self.RecordInfoCloseBtn = self.RecordInfoPanel:Find("CloseBtn").gameObject;
    self.RecordInfolName = self.RecordInfoPanel:Find("Name/InputField").gameObject;


    self.UserPhonePanel = self.RecordInfoPanel:Find("phone").gameObject;
    self.UserPhonePanelPhoneNum = self.RecordInfoPanel:Find("phone/PhoneNum/InputField").gameObject;
    self.UserPhonePanelRePhoneNum = self.RecordInfoPanel:Find("phone/RePhoneNum/InputField").gameObject;

    self.UserPosPanel = self.RecordInfoPanel:Find("Pos").gameObject;
    self.UserPosPanelPhoneNum = self.RecordInfoPanel:Find("Pos/PhoneNum/InputField").gameObject;
    self.UserPosPanelPos = self.RecordInfoPanel:Find("Pos/Pos/InputField").gameObject;
    self.UserPosPanelyoubian = self.RecordInfoPanel:Find("Pos/youbian/InputField").gameObject;
    self.UserPosPanelPwd = self.RecordInfoPanel:Find("Pos/Pwd/InputField").gameObject;

    -- 绑定点击按钮事件
    LuaBeHaviour:AddClick(self.MallInfoCloseBtn, self.MallInfoCloseBtnOnClick);
    -- 兑换填写信息界面按钮
    LuaBeHaviour:AddClick(self.RecordInfoNoBtn, self.NoBtnOnClick);
    LuaBeHaviour:AddClick(self.RecordInfoCloseBtn, self.NoBtnOnClick);
    LuaBeHaviour:AddClick(self.RecordInfoYesBtn, self.UserPosYesBtnOnClick);
    -- 查询兑奖界面按钮
    LuaBeHaviour:AddClick(self.RecordBtn, self.RecordBtnOnClick);
    LuaBeHaviour:AddClick(self.CloseRecord, self.CloseRecordOnClick)
    LuaBeHaviour:AddClick(self.CloseRecordTwo, self.CloseRecordOnClick)
    -- 获取奖券
    LuaBeHaviour:AddClick(self.RecordTicketBtn, self.GetTicketBtnOnClick);
    -- 隐藏提示图标
    self.SetValue();
    self.RecordInfoPanel.gameObject:SetActive(false);
    self.RecordPanel:SetActive(false);
end
----隐藏和显示一个transform
function MallInfoSystem.ShowPanel(g, isShow)
    local t = g.transform;
    if (t.localPosition.y > 100) then
        t.transform.localPosition = Vector3.New(0, 0, 0);
        --        --  效果测试代码
        --        local tweener = g.transform:DOScale(Vector3.New(1, 1, 1), 1);
        --        tweener:SetEase(DG.Tweening.Ease.OutBack);
    else
        t.transform.localPosition = Vector3.New(0, 1000, 0);
    end;
end
-- 获取到服务器的值，显示到界面
function MallInfoSystem.ShowGoods()
    if self.ShopShow.transform.childCount == 0 then
        error("-- 获取到服务器的值，显示到界面");
        ResManager:LoadAsset("module02/hall_mall_Version3", "Goods_Version3", self.CreatPrefebGoods);
    end
end
-- 向服务器发送查询实物消息
function MallInfoSystem.SelectGoods()
    if #AllMallInfo == 0 then
        local buffer = ByteBuffer.New();
        Network.Send(MH.MDM_3D_SHOP, MH.SUB_3D_CS_SELECT_GOODS, buffer, gameSocketNumber.HallSocket);
    end
end

-- 商城
function MallInfoSystem.MallInfo(wSubID, buffer, wSize)
    local recardNum = 0;
    if wSubID == MH.SUB_3D_SC_SELECT_GOODS then
        local value = GetS2CInfo(SC_SelectGoods, buffer);
        -- log("实物ID===" .. value[1] .. "奖券数===" .. value[2] .. "实物类型===" .. value[3] .. "关联数===" .. value[4]);
        local Info = { };
        Info._1dwGoods_Id = value[1]; Info._2dwTicket = value[2]; Info._3byGoodsType = value[3]; Info._4iRelationAmount = value[4];
        -- 防止重复添加
        local count = 0;
        for i = 1, table.getn(AllMallInfo) do
            if AllMallInfo[i]._1dwGoods_Id == Info._1dwGoods_Id then count = count + 1; end
        end
        if count == 0 then table.insert(AllMallInfo, Info) end
    elseif wSubID == MH.SUB_3D_SC_SELECT_GOODS_STOP then
        MallInfoSystem.CreatPrefebGoods(self.GoodsImgPrefeb);
    elseif wSubID == MH.SC_EXCHANGE_GOODS_RECORD_START then
        -- 兑换记录开始
        RecordInfo = { };
    elseif wSubID == MH.SUB_3D_SC_EXCHANGE_GOODS_RECORD then

        local value = GetS2CInfo(SC_ExchangeGoods_Record, buffer);
        table.insert(RecordInfo, #RecordInfo + 1, value);
    elseif wSubID == MH.SUB_3D_SC_EXCHANGE_GOODS_RECORD_STOP then
        MallInfoSystem.ShowRecord()
    elseif wSubID == MH.SUB_3D_SC_EXCHANGE_GOODS_NORMAL then
        -- 实物兑换
        MallInfoSystem.DuihuanSuccess(wSubID, buffer, wSize);
    elseif wSubID == MH.SUB_3D_SC_EXCHANGE_GOODS_RECHARGE_CARD then
        -- 充值卡兑换
        MallInfoSystem.DuihuanSuccess(wSubID, buffer, wSize);
    end

end

-- 关闭商城信息系统
function MallInfoSystem.MallInfoCloseBtnOnClick()
    HallScenPanel.PlayeBtnMusic();
    Event.RemoveListener(PanelListModeEven._015ChangeGoldTicket, self.SetValue);
    self.ShowPanel(self.MallInfoPanel);
    self.RecordPanel.transform.localPosition = Vector3.New(0, 1000, 0);
    self.UserPosPanel.transform.localPosition = Vector3.New(0, 1000, 0);
    self.UserPosPanel:SetActive(false);
    self.UserPhonePanel:SetActive(false);
    self.RecordPanel:SetActive(false);
    -- 恢复被禁用的状态

    RecordInfo = { };
    destroy(self.MallInfoPanel);
    self.MallInfoPanel = nil;
end
-- 取消按钮
function MallInfoSystem.NoBtnOnClick()
    HallScenPanel.PlayeBtnMusic();
    self.RecordInfoPanel.transform.localPosition = Vector3.New(0, 1000, 0);
    self.RecordInfoPanel.gameObject:SetActive(false);
end
-- 兑换记录
function MallInfoSystem.RecordBtnOnClick()
    HallScenPanel.PlayeBtnMusic();
    RecordInfo = { };
    -- Event.AddListener(tostring(MH.MDM_3D_SHOP), Network.MallInfo);
    local buffer = ByteBuffer.New();
    local Data =
    {
        -- 兑换记录开始位置
        [1] = 0,
        -- 数量
        [2] = 7,
    }
    buffer = SetC2SInfo(CS_ExchangeGoods_Record, Data);
    Network.Send(MH.MDM_3D_SHOP, MH.SUB_3D_CS_EXCHANGE_GOODS_RECORD, buffer, gameSocketNumber.HallSocket);
    self.RecordPanel.transform.localPosition = Vector3.New(0, 0, 0);
    self.RecordPanel:SetActive(true);

end

-- 获取奖券按钮
function MallInfoSystem.GetTicketBtnOnClick()
    Event.Brocast(PanelListModeEven._009cornucopiaPanel);
end
-- 关闭兑换记录界面
function MallInfoSystem.CloseRecordOnClick()
    self.RecordPanel.transform.localPosition = Vector3.New(0, 1000, 0);
    self.RecordPanel:SetActive(false);
end
-- 显示兑换记录
function MallInfoSystem.ShowRecord()
    if self.MallInfoPanel ~= nil then
        self.RecordPanel.transform.localPosition = Vector3.New(0, 0, 0);
        self.RecordPanel:SetActive(true);
        -- 实物Id value[1]  总奖券数量  value[2] 购买数量 value[3] 购买时间 value[4]/value[5]/value[7]  订单号 value[13];
        for i = 1, #RecordInfo do
            if i <= 7 then
                self.RecordMainInfo.transform:GetChild(i - 1):Find("Time"):GetComponent('Text').text = RecordInfo[i][4] .. "/" .. RecordInfo[i][5] .. "/" .. RecordInfo[i][7];
                self.RecordMainInfo.transform:GetChild(i - 1):Find("Ticket"):GetComponent('Text').text = RecordInfo[i][2];
                --  error("RecordInfo[i][1]================"..RecordInfo[i][1]);
                self.RecordMainInfo.transform:GetChild(i - 1):Find("Prize"):GetComponent('Text').text = MallInfoSystem.GoodsName(RecordInfo[i][1])
                self.RecordMainInfo.transform:GetChild(i - 1):Find("Num"):GetComponent('Text').text = RecordInfo[i][3];
                self.RecordMainInfo.transform:GetChild(i - 1):Find("dingdanhao"):GetComponent('Text').text = RecordInfo[i][13];
            else
                local go = newobject(self.RecordMainInfo.transform:GetChild(0).gameObject);
                go.transform.SetParent(self.RecordMainInfo.transform);
                go.transform.localScale = Vector3.one;
                go.transform:Find("Time"):GetComponent('Text').text = RecordInfo[i][4] .. "/" .. RecordInfo[i][5] .. "/" .. RecordInfo[i][7];
                go.transform:Find("Ticket"):GetComponent('Text').text = RecordInfo[i][2];
                go.transform:Find("Prize"):GetComponent('Text').text = MallInfoSystem.GoodsName(RecordInfo[i][1]);
                go.transform:Find("Num"):GetComponent('Text').text = RecordInfo[i][3];
                go.transform:Find("dingdanhao"):GetComponent('Text').text = RecordInfo[i][13];
                self.RecordMainInfo:GetComponent("RectTransform").sizeDelta = Vector2.New(630, 350 + 48 *(i - 7));
                self.RecordMainInfo.transform.localPosition = Vector3.New(self.RecordMainInfo.transform.localPosition.x, self.RecordMainInfo.transform.localPosition.y - 24, self.RecordMainInfo.transform.localPosition.z);
            end
        end
    end
end

-- 点击兑换
function MallInfoSystem.GoodsBtnOnClick(obj)
    local i = tonumber(obj.name)
    -- 目前只有200元话费
    HallScenPanel.PlayeBtnMusic();
    btnParent = obj.transform.parent;
    self.GoodsImgFun(AllMallInfo[i]._1dwGoods_Id, self.RecordInfoImage);
    btnParent:Find("Name"):GetComponent('Text').text = self.GoodsName(AllMallInfo[i]._1dwGoods_Id);
    self.RecordInfolmessage:GetComponent('Text').text = "你兑换的奖品是:" .. self.GoodsName(AllMallInfo[i]._1dwGoods_Id);
    self.needTicket:GetComponent('Text').text = AllMallInfo[i]._2dwTicket .. "张";
    self.RecordInfoPanel.gameObject:SetActive(true);
    self.RecordInfoPanel.localPosition = Vector3.New(0, 0, 0);
    self.RecordInfolName:GetComponent('InputField').text="";
    self.UserPhonePanelPhoneNum:GetComponent('InputField').text="";
    self.UserPhonePanelRePhoneNum:GetComponent('InputField').text="";
    if AllMallInfo[i]._3byGoodsType == 1 then
        self.UserPosPanel.transform.localPosition = Vector3.New(0, 0, 0);
        self.UserPhonePanel.transform.localPosition = Vector3.New(0, 1000, 0);

    elseif AllMallInfo[i]._3byGoodsType == 2 then
        self.UserPhonePanel.transform.localPosition = Vector3.New(0, 0, 0);
        self.UserPosPanel.transform.localPosition = Vector3.New(0, 1000, 0);
    end;
    GoodsId = AllMallInfo[i]._1dwGoods_Id;
    GoodsValue = 1;
end
function MallInfoSystem.UserPosYesBtnOnClick(obj)
    -- 实物判断界面显示的是虚物还是实物(需要判断输入的内容是否合法)
    if string.len(self.RecordInfolName:GetComponent("InputField").text) < 2 then MessageBox.CreatGeneralTipsPanel("请检查输入的姓名是否正确") return end

    if self.UserPosPanel.transform.localPosition.y < 100 then
        -- 兑换手机鼠标等
        if not(self.PhoneNum(self.UserPosPanelPhoneNum:GetComponent("InputField").text)) then
            MessageBox.CreatGeneralTipsPanel("请检查输入的电话是否正确")
            obj:GetComponent("Button").interactable = true; return
        end
        if not(self.Pos(self.UserPosPanelPos:GetComponent("InputField").text)) then
            MessageBox.CreatGeneralTipsPanel("请检查输入的地址是否正确")
            obj:GetComponent("Button").interactable = true;
            return
        end
        if not(self.Youbian(self.UserPosPanelyoubian:GetComponent("InputField").text)) then
            MessageBox.CreatGeneralTipsPanel("请检查输入的邮编是否正确") obj:GetComponent("Button").interactable = true;
            return
        end
        obj:GetComponent("Button").interactable = false;
        local data = {
            [1] = GoodsId,
            [2] = GoodsValue,
            [3] = SCPlayerInfo._06wPassword,
            [4] = self.RecordInfolName:GetComponent("InputField").text,
            [5] = self.UserPosPanelPhoneNum:GetComponent("InputField").text,
            [6] = self.UserPosPanelPos:GetComponent("InputField").text,
            [7] = self.UserPosPanelyoubian:GetComponent("InputField").text,
        }
        local buffer = SetC2SInfo(CS_ExchangeGoods_Normal, data);
        Network.Send(MH.MDM_3D_SHOP, MH.SUB_3D_CS_EXCHANGE_GOODS_NORMAL, buffer, gameSocketNumber.HallSocket);
    elseif self.UserPhonePanel.transform.localPosition.y < 100 then
        -- 兑换话费
        if not(self.PhoneNum(self.UserPhonePanelPhoneNum:GetComponent("InputField").text)) then MessageBox.CreatGeneralTipsPanel("请检查输入的电话是否正确") obj:GetComponent("Button").interactable = true; return end
        if not(self.PhoneNum(self.UserPhonePanelRePhoneNum:GetComponent("InputField").text)) then MessageBox.CreatGeneralTipsPanel("请检查输入的确认电话是否正确") obj:GetComponent("Button").interactable = true; return end
        if self.UserPhonePanelRePhoneNum:GetComponent("InputField").text ~= self.UserPhonePanelPhoneNum:GetComponent("InputField").text then MessageBox.CreatGeneralTipsPanel("两次输入手机号不同，请重新输入") obj:GetComponent("Button").interactable = true; return end
        obj:GetComponent("Button").interactable = false;
        local data = {
            [1] = GoodsId,
            [2] = GoodsValue,
            [3] = SCPlayerInfo._06wPassword,
            [4] = self.UserPhonePanelPhoneNum:GetComponent("InputField").text,
        }
        local buffer = SetC2SInfo(CS_ExchangeGoods_RechargeCard, data);
        Network.Send(MH.MDM_3D_SHOP, MH.SUB_3D_CS_EXCHANGE_GOODS_RECHARGE_CARD, buffer, gameSocketNumber.HallSocket);
        obj:GetComponent("Button").interactable = true;
    end
end
-- 兑换成功
function MallInfoSystem.DuihuanSuccess(wSubID, buffer, wSize)
    if (wSize == 0) then
        FramePopoutCompent.Show("商品兑换成功！请与客服人员联系完成信息确认！")
        self.SetValue();
        MallInfoSystem.NoBtnOnClick();
        for i = 1, self.ShopShow.transform.childCount do
            local butName = "Button" .. i .. AllMallInfo[i]._3byGoodsType;
            local btnparset = self.ShopShow.transform:GetChild(i - 1).gameObject;
            local duihuanbtn = btnparset:Find(butName).gameObject;
            if (gameData.GetProp(enum_Prop_Id.E_PROP_TICKET) < AllMallInfo[i]._2dwTicket) then
                duihuanbtn:GetComponent('Button').interactable = false;
            end;
        end
        self.RecordInfoYesBtn:GetComponent("Button").interactable = true;
    else
        MessageBox.CreatGeneralTipsPanel("兑换失败:" .. buffer:ReadString(wSize));
    end

end
-- 添加Goods
function MallInfoSystem.CreatPrefebGoods(prefeb)
    for i = 1, table.getn(AllMallInfo) do
        if i > 3 then return end
        local go = newobject(prefeb);
        go:SetActive(true);
        go.transform:SetParent(self.ShopShow.transform);
        go.name = "Goods" .. tostring(i);
        go.transform:Find("Button").gameObject.name = i;
        go.transform.localScale = Vector3.one;
        go.transform.localPosition = Vector3.New(0, 0, 0);
        self.GoodsValue(go.transform, i);
    end
    local rectTransform = self.ShopShow:GetComponent('RectTransform');
    local hei =((table.getn(AllMallInfo) / 3) * 272) + 100;
    rectTransform.sizeDelta = Vector2.New(730, hei);
    local posy =(222 - hei / 2);
    self.ShopShow.transform.localPosition = Vector3.New(0, posy, 0);

end


-- 给Goods赋值，添加按钮事件
function MallInfoSystem.GoodsValue(t, i)
    t:Find("Name").gameObject:GetComponent('Text').text = AllMallInfo[i]._1dwGoods_Id;
    t:Find("Name"):GetComponent('Text').text = self.GoodsName(AllMallInfo[i]._1dwGoods_Id);
    self.GoodsImgFun(AllMallInfo[i]._1dwGoods_Id, t:Find("Goods").gameObject);
    t:Find("Ticket/Text").gameObject:GetComponent('Text').text = AllMallInfo[i]._2dwTicket .. " 张";
    _LuaBeHaviour:AddClick(t:Find(i).gameObject, self.GoodsBtnOnClick);
    local duihuanbtn = t:Find(i).gameObject;
    if (gameData.GetProp(enum_Prop_Id.E_PROP_TICKET) < AllMallInfo[i]._2dwTicket) then
        duihuanbtn:GetComponent('Button').interactable = false;
    end;
end
-- 奖券金币赋值
function MallInfoSystem.SetValue()
    local gold = gameData.GetProp(enum_Prop_Id.E_PROP_GOLD);
    local ticket = gameData.GetProp(enum_Prop_Id.E_PROP_TICKET);
    self.GoldTxt.text = tostring(gold);
    self.TicketTxt.text = tostring(ticket);
end
-- 商品Id 对应名称
function MallInfoSystem.GoodsName(namei)
    if namei == 1 then
        return "50元话费卡";
    elseif namei == 2 then
        return "100元话费卡";
    elseif namei == 3 then
        return "200元话费卡";
    elseif namei == 4 then
        return "200元话费卡";
    elseif namei == 5 then
        return "200元话费卡";
    elseif namei == 6 then
        return "200元话费卡";
    elseif namei == 7 then
        return "200元话费卡";
        --    elseif namei == 9 then
        --        t:GetComponent('Text').text = "10元话费卡";
        --        self.GoodsImg(namei,t);
        --    elseif namei == 10 then
        --        t:GetComponent('Text').text = "20元话费卡";
        --        self.GoodsImg(namei,t);
        --    elseif namei == 11 then
        --        t:GetComponent('Text').text = "50元话费卡";
        --        self.GoodsImg(9,t);
        --    elseif namei == 12 then
        --        t:GetComponent('Text').text = "100元话费卡";
        --        self.GoodsImg(9,t);
    end

end

-- 创建图片
function MallInfoSystem.GoodsImgFun(namei, t)
    t:GetComponent('Image').sprite = self.GoodsImg.transform:GetChild(namei - 1).gameObject:GetComponent('Image').sprite;
    t:GetComponent('Image'):SetNativeSize();
end

-- 电话InputField判断
function MallInfoSystem.PhoneNum(args)
    if string.find(args, "%d") then
        if string.find(args, "^0") then
            return false;
        elseif (RegularString(args) and string.len(args) == 11) then
            return true;
        else
            return false;
        end;
    else
        return false;
    end;
end


-- 判断地址
function MallInfoSystem.Pos(args)
    if (string.len(args) < 6) then
        return false;
    elseif (RegularString(string.gsub(args, " ", ""))) then
        return true;
    else
        return false;
    end
end
-- 邮编InputField判断
function MallInfoSystem.Youbian(args)
    if string.find(args, "%d") then
        if string.len(args) == 6 then
            return true;
        else
            return false;
        end;
    else
        return false;
    end;
end
-- 登录密码InputField判断
function MallInfoSystem.Pwd(args)
    if MD5Helper.MD5Stringjia(args) ~= SCPlayerInfo._06wPassword then
        return false;
    else
        return true;
    end;
end
