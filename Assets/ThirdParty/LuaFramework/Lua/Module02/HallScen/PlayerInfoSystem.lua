--[[require "Common/define"
require "Data/gameData"
require "Data/DataStruct"]]

PlayerInfoSystem = { }
local self = PlayerInfoSystem;
local accountid = nil;
local nowpanel = nil;
local creatValue = nil;
local PlayerImg = nil;
local ShowSprite = nil;
-- 面板是否被激活
local isActive = false;
-- ===========================================排行榜信息系统======================================
function PlayerInfoSystem.Open()
end
local userId;
local SeedPanel = nil;
local IsSend = true;
local ShowHead = nil;
-- 查询用户信息请求
function PlayerInfoSystem.SelectUserInfo(args, args1, imgobj, ...)
    error("-- 查询用户信息请求");
    if not gameIsOnline then return end
    --避免二次创建
    if isActive then return end
    isActive = true;
    if IsSend then
        IsSend = false;
        error("IsSend = false;" .. args);
        userId = args;
        SeedPanel = args1;
        ShowHead = imgobj;
        if select('#', ...) > 0 then ShowSprite = select(1, ...) else ShowSprite = nil end
        local buffer = ByteBuffer.New();
        local data = { [1] = args, [2] = 0 }
        buffer = SetC2SInfo(CS_UserInfoSelect, data);
		SeleteInfoToWindows=0;
        Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_USER_INFO_SELECT, buffer, gameSocketNumber.HallSocket);
        IsSend = true;
    else
    end
end

function PlayerInfoSystem.SelectUserInfoCallBack(data)
    --error("-- PlayerInfoSystem.SelectUserInfoCallBack");
    IsSend = true;
    PlayerInfoSystem.CreatPanel(userId, SeedPanel, data, ShowHead)

end

function PlayerInfoSystem.Init(obj, LuaBeHaviour)
    local t = obj.transform;
    local UrlHeadImgP = nil;
    self.PlayerHeadImg = t:Find("PlayerInfo/PlayerHeadIMG2/Image").gameObject;
    self.nickName = t:Find("PlayerInfo/Info/NickNameTxt/Text").gameObject:GetComponent('Text');
    self.gold = t:Find("PlayerInfo/Info/GoldTxt/Text").gameObject:GetComponent('Text');
    -- self.OneKeyTicket = t:Find("PlayerInfo/Info/TicketTxt").gameObject
    -- self.ticket = t:Find("PlayerInfo/Info/TicketTxt/Text").gameObject:GetComponent('Text');
    self.leaveWord = t:Find("PlayerInfo/LeaveWord/Text").gameObject:GetComponent('Text');
    self.postiontxt = t:Find("PlayerInfo/PosBg/PostionTxt").gameObject:GetComponent('Text');
    self.palyerClosebtn = t:Find("PlayerInfo/PlayerCloseBtn").gameObject;
    --  self.PlayerLv = t:Find("PlayerInfo/PlayerHeadIMG2/Lv").gameObject;

    self.nickName.text = creatValue[3];
    self.gold.text =tostring(creatValue[10]);
    -- self.ticket.text = creatValue[11];
    self.leaveWord.text = "  " .. creatValue[9];
    if creatValue[12] == 0 then
        self.postiontxt.text = "离线";
    elseif creatValue[13] == 0 then
        self.postiontxt.text = "正在大厅逗留";
    elseif creatValue[14] ~= 0 then
        if creatValue[13] == enum_GameID.E_GAME_ID_BLACKJACK then
            self.postiontxt.text = "正在二十一点" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_DOUDIZHU then
            self.postiontxt.text = "正在斗地主" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_LKPY then
            self.postiontxt.text = "正在李逵劈鱼" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_SHUIHUZHUI then
            self.postiontxt.text = "正在水浒传" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_BACCARAT then
            self.postiontxt.text = "正在免佣百家乐" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_3D_FISH then
            self.postiontxt.text = "正在3D捕鱼" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_LHDB then
            self.postiontxt.text = "正在龙珠探宝" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_SLT then
            self.postiontxt.text = "正在斯洛特" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_NIUNIU then
            self.postiontxt.text = "正在牛牛" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_BENCHIBAOMA then
            self.postiontxt.text = "正在奔驰宝马" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_FISH_ZOMBIE then
            self.postiontxt.text = "正在僵尸捕鱼" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_ZHAJINHUA then
            self.postiontxt.text = "正在扎金花" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_VIP then
            self.postiontxt.text = "正在VIP" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_FQZS then
            self.postiontxt.text = "正在飞禽走兽" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_JLCF then
            self.postiontxt.text = "正在金龙赐福" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_SGPD then
            self.postiontxt.text = "正在水果派对" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_YQS then
            self.postiontxt.text = "正在摇钱树" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_WKNH then
            self.postiontxt.text = "正在悟空闹海" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_SGKH then
            self.postiontxt.text = "正在水果狂欢" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_FKFPJ then
            self.postiontxt.text = "正在疯狂连翻机" .. creatValue[14] .. "号房间玩游戏";
        elseif creatValue[13] == enum_GameID.E_GAME_ID_XMST then
            self.postiontxt.text = "正在熊猫solt" .. creatValue[14] .. "号房间玩游戏";
        end
    end
    LuaBeHaviour:AddClick(self.palyerClosebtn, self.PlayerCloseOnClick);
    if ShowSprite ~= nil then
        self.PlayerHeadImg:GetComponent('Image').sprite = ShowSprite
    elseif PlayerImg ~= nil then
        self.PlayerHeadImg:GetComponent('Image').sprite = PlayerImg:GetComponent('Image').sprite;
    elseif PlayerImg == nil then
        local headImgUrl = nil;
        if creatValue[5] == 0 then
            headImgUrl = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/0" .. creatValue[4] .. ".png";
        else
            headImgUrl = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/" .. creatValue[1] .. "." .. creatValue[7];
        end;
        headstr = creatValue[1] .. "." .. creatValue[7];
        UpdateFile.downHead(headImgUrl, headstr, nil, self.PlayerHeadImg);
    end
    --   self.OneKeyTicket:SetActive(gameIsOnline);
end

-- 关闭页面
function PlayerInfoSystem.PlayerCloseOnClick()
    IsSend = true;
    isActive=false;
    destroy(self.PlayererInfoPanel);
    self.PlayererInfoPanel = nil;
end

function PlayerInfoSystem.CreatPanel(args, args1, data, Img)
    accountid = args;
    nowpanel = args1;
    creatValue = data;
    PlayerImg = Img;
    if not IsNil(self.PlayererInfoPanel) then return end
    --LoadAssetAsync("module02/hall_player", "PlayerInfo", self.CreatPlayer, true, true);
    self.CreatPlayer(HallScenPanel.Pool("PlayerInfo"));
end
self.posx = 0;
self.posy = 0;
self.posz = 0;
function PlayerInfoSystem.SetObjPosition(x, y, z)
    self.posx = x or 0;
    self.posy = y or 0;
    self.posz = z or 0;
end

-- 创建界面
function PlayerInfoSystem.CreatPlayer(prefeb)
    local _luaBeHaviour = nil;
    if ScenSeverName == gameServerName.HALL then
        _luaBeHaviour = HallScenPanel.LuaBehaviour;
        self.tishipartent = GameObject.FindGameObjectWithTag('GuiCamera');
    else
        _luaBeHaviour = GameSetsBtnInfo._LuaBehaviour;
        self.tishipartent = GameObject.FindGameObjectWithTag('GuiCamera');
    end
    if _luaBeHaviour==nil then error("__luaBeHaviour is  nil"); return end;
    local go = prefeb;
    self.PlayererInfoPanel = go;
    if nowpanel ~= nil then self.tishipartent = nowpanel; end
    go.transform:SetParent(self.tishipartent.transform);
    go.transform.localScale = Vector3.New(1, 1, 1);
    local infoList = nil;
    for k = 1, table.getn(AllSCGameRoom) do
        if AllSCGameRoom[k]._9Name == ScenSeverName then infoList = AllSCGameRoom[k]; end
    end
    if LaunchModule.currentHallScene==nil then 
    infoList=nil;
    else
    if LaunchModule.currentHallScene.activeSelf then infoList=nil;  end
    end;
    
    if infoList == nil then
        go.transform.localPosition = Vector3.New(0, 1000, 1152);
    else
        go.transform.localPosition = Vector3.New(0, 1000, 0);

    end;
    self.Init(go, _luaBeHaviour);
    self.ShowPanel(go);
    if infoList == nil then
        go.transform.localPosition = Vector3.New(0, 0, 1152);
    else
        go.transform.localPosition = Vector3.New(self.posx, self.posy, self.posz);

    end;

end
----隐藏和显示一个transform
function PlayerInfoSystem.ShowPanel(g)
    local t = g.transform;
    if (t.localPosition.y > 100) then
        local infoList = nil;
        for k = 1, table.getn(AllSCGameRoom) do
            if AllSCGameRoom[k]._9Name == ScenSeverName then infoList = AllSCGameRoom[k]; end
        end
        if infoList == nil then
            t.transform.localPosition = Vector3.New(0, 0, 1152);
        else
            t.transform.localPosition = Vector3.New(self.posx, self.posy, self.posz);

        end;
        --  效果测试代码
        t.transform:DOLocalMoveX(0, 0.2, false):SetEase(DG.Tweening.Ease.Linear);
        --  HallScenPanel.SetXiaoGuo(g)
    else
        t.localPosition = Vector3.New(0, 1000, 0);
    end
end
