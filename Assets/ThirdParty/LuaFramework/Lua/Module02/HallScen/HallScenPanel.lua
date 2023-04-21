HallScenPanel = {};
local self = HallScenPanel;
local transform = nil;
local gameObject = nil;

local HallScenPanelobj;
local luaBehaviour;
local ComposePanel;
self.CreatOver = false;
self.logonover = false;
self.connectCount = 0;
self.startCheckNetHall = false;
self.restConnectCount = 0;
self.NumDic = nil;
self.Game22Sprite = nil;
self.moduleBg = nil;
self.IsInGame = false;
self.isReconnectGame = false;
self.ptxjIndex = 1
function HallScenPanel.New()
    local t = o or {};
    setmetatable(t, { __index = HallScenPanel });
    return t;
end

function HallScenPanel.Open()
    self.PlayeBgMusic();
    self.StartValuePropInfo()
    ScenSeverName = gameServerName.HALL;
    MoveNotifyInfoClass.Int();
    MoveNotifyInfoClass.PlayerDeleteNotifyInfo();
    GameManager.isEnterGame = false;
    --self.ExitGameBtn.gameObject:SetActive(true);
end

function HallScenPanel:Awake(obj)
    HallScenPanel.IsInGame = false;

    error("大厅初始化")
    local dleObj = GameObject.FindGameObjectWithTag("rootStartModule").gameObject;
    destroy(dleObj);
    ScenSeverName = gameServerName.HALL;  --"hall"
    self.modulePanel = obj.transform;
    LaunchModule.modulePanel = obj.transform;
    transform = obj.transform;
    gameObject = obj;
    self.moduleBg = self.Pool("BGIMG", false).transform:Find("moduleBg");
    self.headIcons = self.Pool("HeadIcons", false).transform;
    self:FindComponent();
    self.StartValuePropInfo();
    self:AddOnClickEvent();
    SetCanvasScalersMatch(self.CanvasScalers, 1);
    self.PlayeBgMusic();

    self.BackHallOnClick()

    self.logonover = true;
    LogonScenPanel.Create()

    self:InitPanl();
    self:GetNumberSprites();
    self:GetGame22Sprites();
    GameManager.isEnterGame = false;
    -- self.ExitGameBtn.gameObject:SetActive(true);
end
function HallScenPanel.GetGame22Sprites()
    local game22 = transform:Find("Game22");
    local wan = game22:Find("w"):GetComponent("Image").sprite;
    local yi = game22:Find("y"):GetComponent("Image").sprite;
    self.Game22Sprite = {};
    table.insert(self.Game22Sprite, #self.Game22Sprite, wan);
    table.insert(self.Game22Sprite, #self.Game22Sprite, yi);
end

-- function HallScenPanel.GetTGGSprites()
--     local TGG_Rule = transform:Find("TGG");
--     return TGG_Rule:Find("Image"):GetComponent("Image").sprite
-- end

function HallScenPanel.GetGame22Rule()
    local rule = transform:Find("Game22/rule"):GetComponent("Image").sprite;
    return rule;
end
--获取游戏数字资源
function HallScenPanel.GetNumberSprites()
    self.NumDic = {};
    local numNode = transform:Find("Number");
    if numNode == nil then
        error("没有找到");
        return nil;
    end
    numNode.localPosition = Vector3.New(1000000, 0, 0);
    for i = 0, numNode.childCount - 1 do
        local child = numNode:GetChild(i);
        local numberImage = child:GetComponent("ImageAnima");
        if numberImage == nil then
            numberImage = child.gameObject:AddComponent(typeof(ImageAnima));
            for j = 0, child.childCount - 1 do
                numberImage:AddSprite(child:GetChild(j):GetComponent("Image").sprite);
            end
            table.insert(self.NumDic, #self.NumDic + 1, numberImage);
        end
    end
    logErrorTable(self.NumDic);
end

--获取对象下所有的Sprite
function HallScenPanel.GetGameAddAllSprite(childName)
    local go = nil
    if type(childName) == "string" then
        go = self.Pool("BGIMG", false).transform:Find(childName);
    else
        log("传入错误名字--" .. childName)
        return nil;
    end
    if go == nil then
        error("没有找到名字为--" .. childName .. "--的对象");
        return nil;
    end
    local rettb = {}
    for i = 1, go.transform.childCount do
        local temtb = {};
        local child = go:GetChild(i - 1).transform;
        for j = 1, child.childCount do
            temtb[j] = child:GetChild(j - 1):GetComponent("Image").sprite;
        end
        rettb[i] = temtb;
    end
    return rettb;
end


--把Pool里面的gameObject拿出来
function HallScenPanel.Pool(prefabName, create)
    --local t = self.modulePanel.transform:Find("Pool");
    --local child = t:Find(prefabName);
    local child = nil;
    if child == nil then
        --self.prefabPool = {};
        --if child == nil then
        --local obj = LoadAsset("module02/Pool/" .. string.lower(prefabName), prefabName);
        local obj = LoadAsset("HallPackage", prefabName);
        if obj == nil then
            log("没有找到" .. prefabName);
        else
            child = newobject(obj);
            child.name = prefabName;
            --child.transform:SetParent(t);
            child.transform.gameObject:SetActive(false);
        end
        --end
        --local n = t.transform.childCount - 1;
        --for i = 0, n do
        --    local ct = t.transform:GetChild(i).gameObject;
        --    ct.gameObject:SetActive(false);
        --    self.prefabPool[ct.name] = ct;
        --end
    end
    --local t = self.prefabPool[prefabName] or nil;
    if child == nil then
        logError("not find pool " .. prefabName);
        return nil
    end
    local c;
    if create == nil then
        c = true
    else
        c = create
    end ;
    if not c then
        return child.gameObject;
    end
    --local obj = newobject(child);
    local obj = child;
    obj.gameObject:SetActive(true);
    obj.gameObject.name = prefabName;

    local rate = Screen.width / Screen.height;
    if obj.transform:GetComponent("RectTransform") ~= nil then
        obj.transform:GetComponent("RectTransform").sizeDelta = Vector2.New(750 * rate, 750)
    end
    if prefabName == "GameRoomListPanel" then
        --  self.ExitGameBtn.gameObject:SetActive(false);
    end

    return obj.gameObject;
end

function HallScenPanel:FindComponent()
    self.Compose = find("Compose");

    -----------------------
    self.EmailBtn = transform:Find("Compose/Top/MailBtn").gameObject
    self.GWBtn = transform:Find("Compose/Top/GWBtn").gameObject
    self.ExitGameBtn = transform:Find("Compose/Top/yaoqing").gameObject

    -----------------------
    local IMGResolution = self.Compose:GetComponent("IMGResolution");
    if IMGResolution == nil then
        Util.AddComponent("IMGResolution", self.Compose);
    end
    local screenSize = self.Compose:GetComponent("RectTransform").sizeDelta;
    self.CanvasScalers = GameObject.FindGameObjectWithTag("rootHallModule"):GetComponent("CanvasScaler");
    self.head = transform:Find("Compose/HeadImg").gameObject;
    -- 男头像
    self.nanSprtie = transform:Find("Compose/nan"):GetComponent("Image").sprite;
    -- 女头像
    self.nvSprtie = transform:Find("Compose/nv"):GetComponent("Image").sprite;
    -- 头像Ioc
    self.HeadIoc = transform:Find("Compose/HeadIoc").gameObject;
    self.PlayerNameObj = self.HeadIoc.transform:Find("PlayerName");
    self.copyIDBtn = self.HeadIoc.transform:Find("CopyIDBtn").gameObject;
    -- 个人信息
    self.goldNum = self.HeadIoc.transform:Find("gold").gameObject;
    self.goldText = self.HeadIoc.transform:Find("gold"):GetComponent('TextMeshProUGUI');
    self.ticketText = self.HeadIoc.transform:Find("ticket"):GetComponent('Text');
    self.PlayerNameText = self.HeadIoc.transform:Find("PlayerName"):GetComponent('Text');

    self.ID = self.HeadIoc.transform:Find("ID").gameObject;
    self.IDText = self.HeadIoc.transform:Find("ID"):GetComponent('Text');
    self.BankGold = self.HeadIoc.transform:Find("BankGold"):GetComponent("TextMeshProUGUI");

    self.ZSaddBtn = self.HeadIoc.transform:Find("ZSNum/Button").gameObject;
    self.JBaddBtn = self.HeadIoc.transform:Find("GoldNum/Button").gameObject;

    self.Version = transform:Find("Compose/floor/Version"):GetComponent("Text");
    -- 充值
    self.PlayBtn = transform:Find("Compose/PlayBtn").gameObject;
    self.PlayBtn:GetComponent("RectTransform").anchorMax = Vector2.New(0.5, 1);
    self.PlayBtn:GetComponent("RectTransform").anchorMin = Vector2.New(0.5, 1);
    self.PlayBtn.transform.localPosition = Vector3(self.PlayBtn.transform.localPosition.x, screenSize.y / 2 - 60, 0);
    -- 菜单按钮
    self.SetsBtn = transform:Find("Compose/floor/GameObject/SetsBtn").gameObject;
    -- 排行榜
    -- self.RankingBtn = transform:Find("Compose/floor/RankingBtn").gameObject;
    -- self.RankingBtn.transform.localScale = Vector3.New(0, 0, 0);
    -- 返回大厅按钮
    --self.backhallBtn = transform:Find("Compose/floor/BackHallBtn").gameObject;

    self.shopBtn = transform:Find("Compose/floor/GameObject/shopBtn").gameObject;

    -- 银行
    self.BankerBtn = transform:Find("Compose/floor/GameObject/BankBtn").gameObject;
    self.DuihuanBtn = transform:Find("Compose/floor/GameObject/DuihuanBtn").gameObject;

    self.RenWuBtn = transform:Find("Compose/floor/GameObject/renwuBtn").gameObject;

    -- self.ChongZhiPanel = transform:Find("Compose/ChongZhiPanel");
    -- self.ChongZhiPanel.gameObject:SetActive(false);

    self.floor = transform:Find("Compose/floor").gameObject;

    self.waitTransform = transform:Find("wait");
    self.waitTransform:Find("wait"):GetComponent("Image"):SetNativeSize();
    -- 实例化一个喇叭隐藏起来
    self.PlayerSuona = transform:Find("Compose/PlaySuona").gameObject;
    --self.PlayerSuona:GetComponent("RectTransform").anchorMax = Vector2.New(0.5, 1);
    --self.PlayerSuona:GetComponent("RectTransform").anchorMin = Vector2.New(0.5, 1);
    --self.PlayerSuona.transform.localPosition = Vector3(self.PlayerSuona.transform.localPosition.x, screenSize.y / 2 - 120, 0);
    self.Suona = newobject(self.PlayerSuona)
    self.Suona.transform:SetParent(self.Compose.transform);
    self.Suona.transform.localPosition = Vector3.New(0, 0, 0);
    self.Suona.transform.localScale = Vector3.New(1, 1, 1);
    self.Suona:SetActive(false);

    -- self.KefuBtn:SetActive(false);
    --中间对象 ，RankPrefab Prefab ScrollMid
    self.Mid = transform:Find("Compose/Mid").gameObject;
    --self.Mid:GetComponent("RectTransform").sizeDelta = Vector2.New(self.Mid:GetComponent("RectTransform").sizeDelta.x, screenSize.y - 1334 + self.Mid:GetComponent("RectTransform").sizeDelta.y);
    local ScrollRect = self.Mid:GetComponent("ScrollRect")
    ScrollRect.elasticity = 0.14
    ScrollRect.decelerationRate = 0.135
    self.Mid:SetActive(false);

    --
    self.HallMid = transform:Find("Compose/Mid/View").gameObject;

    self.BGImage = transform:Find("Compose/BGImage")
    -- self.PTXZ = transform:Find("Compose/Mid/PTXZ")

    -- self.YHBtn = self.PTXZ:Find("main/LBBtn").gameObject
    -- self._998Btn = self.PTXZ:Find("main/QPBtn").gameObject
    -- self.BFBtn = self.PTXZ:Find("main/BYBtn").gameObject
    -- self.DCRBtn = self.PTXZ:Find("main/DRRBtn").gameObject

    -- self.YYLBtn = self.PTXZ:Find("main/YYLBtn").gameObject
    -- self.LLDZZBtn = self.PTXZ:Find("main/LLDZZBtn").gameObject
    -- self.TTCMBtn = self.PTXZ:Find("main/TTCMBtn").gameObject

    -- if tonumber(Screen.width / Screen.height) >= 1.8 then
    --     self.YHBtn.transform.localScale=Vector3.New(1.1,1.1,1.1)
    --     self._998Btn.transform.localScale=Vector3.New(1.1,1.1,1.1)
    --     self.BFBtn.transform.localScale=Vector3.New(1.1,1.1,1.1)
    --     self.DCRBtn.transform.localScale=Vector3.New(1.1,1.1,1.1)
    -- else
    --     self.YHBtn.transform.localScale=Vector3.New(1,1,1)
    --     self._998Btn.transform.localScale=Vector3.New(1,1,1)
    --     self.BFBtn.transform.localScale=Vector3.New(1,1,1)
    --     self.DCRBtn.transform.localScale=Vector3.New(1,1,1)
    -- end

    -- 判断是否是审核模式，审核的时候要隐藏部分模块
    self.HideHallMode();
    -- 更新金币
    Event.AddListener(PanelListModeEven._015ChangeGoldTicket, HallScenPanel.UpdatePropInfo);
end

-- 隐藏大厅不需要显示的模块
function HallScenPanel.HideHallMode()
    self.SetsBtn:SetActive(gameIsOnline);
    --self.RankingBtn:SetActive(gameIsOnline);
    self.BankerBtn:SetActive(gameIsOnline);
    if WebAppInfo ~= nil then
        gameIsShare = WebAppInfo.share;
    end
    --self.ShareBtn:SetActive(gameIsShare);
end

function HallScenPanel.SetGW(isShow)
    self.GWBtn.gameObject:SetActive(isShow)
end

-- 添加点击事件
function HallScenPanel:AddOnClickEvent()
    luaBehaviour = transform:GetComponent('LuaBehaviour');
    self.LuaBehaviour = luaBehaviour;
    FramePopoutCompent._luaBeHaviour = luaBehaviour;
    -- 用户头像的点击事件
    -- luaBehaviour:AddClick(self.HeadIoc.transform:Find("HeadBtn").gameObject, self.HeadBtnOnClick);
    -- luaBehaviour:AddClick(self.head.transform:Find("Btn").gameObject, self.HeadBtnOnClick)
    luaBehaviour:AddClick(self.shopBtn, self.OpenShopOnClick);
    luaBehaviour:AddClick(self.ZSaddBtn, self.OpenShopOnClick);
    -- 用户点击充值
    luaBehaviour:AddClick(self.PlayBtn, self.PlayBtnOnClick);
    -- 菜单按钮（打开）
    luaBehaviour:AddClick(self.SetsBtn, self.SetsBtnOnClick);
    -- 菜单按钮（关闭）
    luaBehaviour:AddClick(self.CLoseRecFrameBtns, self.CloseSettingPanel);
    luaBehaviour:AddClick(self.CLoseRecFrameBtns1, self.CloseSettingPanel);
    -- 银行
    luaBehaviour:AddClick(self.BankerBtn, self.BankerBtnOnClick)
    luaBehaviour:AddClick(self.DuihuanBtn, self.DuihuanOnClick)
    luaBehaviour:AddClick(self.RenWuBtn, self.RenWuOnClick)
    -- 点击邮件（菜单2）
    --luaBehaviour:AddClick(self.EmailBtn, self.EmailBtnOnClick);
    luaBehaviour:AddClick(self.GWBtn, self.GWBtnOnClick);

    luaBehaviour:AddClick(self.ExitGameBtn, self.ExitGameCall);
    -- 点击大厅空白区域关闭设置界面
    --luaBehaviour:AddClick(self.Compose, self.CloseSettingPanel)
    luaBehaviour:AddClick(self.copyIDBtn, self.CopyIDCall)

end

function HallScenPanel.PTXZCall(args)
    -- self.HallMid:SetActive(true);

    -- self.PTXZ:Find("main").gameObject:SetActive(false)
    -- for i = 1, 4 do
    --     if args.name == self.PTXZ:Find("main"):GetChild(i - 1).name then
    --         --self.PTXZ:Find("main"):GetChild(i - 1):GetComponent("Button").interactable = false
    --         -- self.PTXZ:Find("main"):GetChild(i - 1):Find("Image").gameObject:SetActive(true)
    --         self.HallMid.transform:Find("ScrollMid"):GetChild(i - 1).gameObject:SetActive(true)
    --         --self.BGImage:GetChild(i - 1).gameObject:SetActive(true)
    --         self.ptxjIndex = i
    --         self.HallMid.transform:Find("ScrollMid").localPosition = Vector3.New(0, self.HallMid.transform:Find("ScrollMid").localPosition.y, self.HallMid.transform:Find("ScrollMid").localPosition.z)
    --         SetShowGame.currentpage = SetShowGame.moveIndex[self.ptxjIndex]

    --     else
    --         --self.PTXZ:Find("main"):GetChild(i - 1):GetComponent("Button").interactable = true
    --         --self.PTXZ:Find("main"):GetChild(i - 1):Find("Image").gameObject:SetActive(false)
    --         self.HallMid.transform:Find("ScrollMid"):GetChild(i - 1).gameObject:SetActive(false)
    --         self.BGImage:GetChild(i - 1).gameObject:SetActive(false)
    --     end
    -- end
end

function HallScenPanel.CheckLoginCode()
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    buffer:WriteByte(0);
    log("查询是否开启登录验证")
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_QUERYLOGINVERIFY, buffer, gameSocketNumber.HallSocket);
end

function HallScenPanel.CheckLoginCodeBack(buffer)
    local su = buffer:ReadByte();
    local t = buffer:ReadByte();
    local v = buffer:ReadByte();
    log("返回登录验证消息 状态：" .. su);
    log(" 类型：" .. t);
    log(" 值：" .. v);
    SCPlayerInfo._26bLoginValidate = v;
    if SCPlayerInfo._26bLoginValidate == 1 then
        self.RecFrameDLText.text = "已绑定本机"
    else
        self.RecFrameDLText.text = "未绑定本机"
    end
end

function HallScenPanel.ExitGameCall()

    -- if self.HallMid.activeSelf then
    --     self.HallMid:SetActive(false);
    --     self.PTXZ:Find("main").gameObject:SetActive(true)
    --     return ;
    -- end
    -- self.HallMid:SetActive(true);
    -- self.PTXZ.gameObject:SetActive(false)
    local pop = FramePopoutCompent.Pop.New()
    pop._02conten = "是否退出游戏?";
    pop._05yesBtnCallFunc = function()
        Util.Quit();
    end;
    pop.isBig = true;
    GameManager.isQuitGame = true
    FramePopoutCompent.Add(pop);
end



-- function HallScenPanel.BDPhonePanel()
--     HallScenPanel.PlayeBtnMusic()
--     self.RecFrameBtns:SetActive(false);
--     BDPhonePanel.Open(luaBehaviour)
-- end

-- function HallScenPanel.OpenMusicPanel()
--     HallScenPanel.PlayeBtnMusic()
--     self.RecFrameBtns:SetActive(false);
--     self.MusicPanel_Close = self.MusicPanel:Find("CloseBtn")
--     luaBehaviour:AddClick(self.MusicPanel_Close.gameObject, self.MusicPanelClose)
--     self.MusicPanel.gameObject:SetActive(true);
-- end
function HallScenPanel.MusicPanelClose()
    HallScenPanel.PlayeBtnMusic()
    logYellow("关闭shengyin界面")
    self.MusicPanel.gameObject:SetActive(false);
end

function HallScenPanel.OpenShopOnClick(args)
    HallScenPanel.PlayeBtnMusic()
    ChongZhiPanel.Open(luaBehaviour)
end

function HallScenPanel.ChongZhiPanelClose(args)
    HallScenPanel.PlayeBtnMusic()
    logYellow("关闭充值界面")
    self.ChongZhiPanel.gameObject:SetActive(false);
end
function HallScenPanel.DKCZClick(args)
    HallScenPanel.PlayeBtnMusic()
    DuiHuanPanel.Init(self.LuaBehaviour);
    --PersonalInfoSystem.Creatobj(HallScenPanel.Pool("DuiHuanPanel"))
end

local nowPanel = 1
function HallScenPanel.GameScrollMid_OnBeginDrag()
end
function HallScenPanel.GameScrollMid_OnDrag()
end
function HallScenPanel.GameScrollMid_OnEndDrag()

    local num = self.GameScrollMid.horizontalNormalizedPosition
    if nowPanel == 1 and num > 0.12 then
        nowPanel = 2
    elseif nowPanel == 2 and num >= 0.62 then
        nowPanel = 3
    elseif nowPanel == 2 and num < 0.37 then
        nowPanel = 1
    elseif nowPanel == 3 and num < 0.87 then
        nowPanel = 2
    end

    if nowPanel == 1 then
        self.GameScrollMid.horizontalNormalizedPosition = 0
        self.JT:Find("Image1/Image").gameObject:SetActive(true)
        self.JT:Find("Image2/Image").gameObject:SetActive(false)
        self.JT:Find("Image3/Image").gameObject:SetActive(false)
        self.JT1.gameObject:SetActive(false)
        self.JT2.gameObject:SetActive(true)

    elseif nowPanel == 2 then
        self.GameScrollMid.horizontalNormalizedPosition = 0.5
        self.JT:Find("Image1/Image").gameObject:SetActive(false)
        self.JT:Find("Image2/Image").gameObject:SetActive(true)
        self.JT:Find("Image3/Image").gameObject:SetActive(false)
        self.JT1.gameObject:SetActive(true)
        self.JT2.gameObject:SetActive(true)
    else
        self.GameScrollMid.horizontalNormalizedPosition = 1
        self.JT:Find("Image1/Image").gameObject:SetActive(false)
        self.JT:Find("Image2/Image").gameObject:SetActive(false)
        self.JT:Find("Image3/Image").gameObject:SetActive(true)
        self.JT2.gameObject:SetActive(false)
        self.JT1.gameObject:SetActive(true)
    end
end

function HallScenPanel.RecodeValueChange()
    -- if nowPanel ==1 and self.GameScrollMid.horizontalNormalizedPosition>0.12 then
    --     nowPanel=2
    -- elseif nowPanel ==2 and self.GameScrollMid.horizontalNormalizedPosition>=0.62 then
    --     nowPanel=3
    -- elseif nowPanel ==2 and self.GameScrollMid.horizontalNormalizedPosition<0.37 then
    --     nowPanel=1
    -- elseif nowPanel ==3 and self.GameScrollMid.horizontalNormalizedPosition<0.87 then
    --     nowPanel=2
    -- end
end

function HallScenPanel.JTDJ(args)
    logYellow("args----" .. tostring(args.name))

    if args.name == "JT1" then
        if self.GameScrollMid.horizontalNormalizedPosition >= 0.66 then
            self.GameScrollMid.horizontalNormalizedPosition = 0.5
            self.JT:Find("Image1/Image").gameObject:SetActive(false)
            self.JT:Find("Image2/Image").gameObject:SetActive(true)
            self.JT:Find("Image3/Image").gameObject:SetActive(false)
            self.JT1.gameObject:SetActive(true)
            self.JT2.gameObject:SetActive(true)
            nowPanel = 2
        elseif self.GameScrollMid.horizontalNormalizedPosition > 0.33 and self.GameScrollMid.horizontalNormalizedPosition < 0.66 then
            self.GameScrollMid.horizontalNormalizedPosition = 0
            self.JT:Find("Image1/Image").gameObject:SetActive(true)
            self.JT:Find("Image2/Image").gameObject:SetActive(false)
            self.JT:Find("Image3/Image").gameObject:SetActive(false)
            self.JT2.gameObject:SetActive(true)
            self.JT1.gameObject:SetActive(false)
            nowPanel = 1
        end
    elseif args.name == "JT2" then
        logYellow("000000000000")
        logYellow("horizontalNormalizedPosition==" .. self.GameScrollMid.horizontalNormalizedPosition)
        if self.GameScrollMid.horizontalNormalizedPosition <= 0.33 then
            self.GameScrollMid.horizontalNormalizedPosition = 0.5
            self.JT:Find("Image1/Image").gameObject:SetActive(false)
            self.JT:Find("Image2/Image").gameObject:SetActive(true)
            self.JT:Find("Image3/Image").gameObject:SetActive(false)
            self.JT1.gameObject:SetActive(true)
            self.JT2.gameObject:SetActive(true)
            nowPanel = 2

        elseif self.GameScrollMid.horizontalNormalizedPosition > 0.33 and self.GameScrollMid.horizontalNormalizedPosition < 0.66 then
            self.GameScrollMid.horizontalNormalizedPosition = 1
            self.JT:Find("Image1/Image").gameObject:SetActive(false)
            self.JT:Find("Image2/Image").gameObject:SetActive(false)
            self.JT:Find("Image3/Image").gameObject:SetActive(true)
            self.JT2.gameObject:SetActive(false)
            self.JT1.gameObject:SetActive(true)
            nowPanel = 3

        end
    end
end

function HallScenPanel.CopyIDCall(go)
    HallScenPanel.PlayeBtnMusic();
    local strID = self.IDText.text;
    Util.CopyStr(strID);
    MessageBox.CreatGeneralTipsPanel("复制ID成功");
end
--是否屏蔽6个按钮点击事件
function HallScenPanel.SetBtnInter(bl)

end


-- 登陆
function HallScenPanel.LogonSuccessSetHall(bl)
    if not bl then
        return
    end
    local vnum = AppConst.valueConfiger.Version + AppConst.gameValueConfiger.Version
    self.Version.text = "V " .. Application.version .. '.' .. vnum
    self.HallMid:SetActive(true);
    -- self.PTXZ:Find("main").gameObject:SetActive(false)

    --self.PTXZ.gameObject:SetActive(false)
    logError("登陆大厅回调成功 !!!");
    -- if SCPlayerInfo._29szPhoneNumber == "" then
    --     local pop = FramePopoutCompent.Pop.New();
    --     pop._02conten = "请游客登录玩家，登录游戏后尽快绑定手机，以方便丢失找回，避免账号遗失。已绑定手机玩家，可以使用手机账号登录进入游戏。"
    --     pop._99last = true
    --     pop.isBig = true;
    --     FramePopoutCompent.Add(pop)
    -- end
    --if (SCPlayerInfo._29szPhoneNumber == "" and Util.isApplePlatform) then
    --    -- MessageBox.CreatGeneralTipsPanel("您是游客账号，请绑定手机号，避免财产损失！");
    --    local pop = FramePopoutCompent.Pop.New()
    --    pop._02conten = "近日有部分玩家因为更换设备、重装游戏等原因，导致游客账号丢失，造成不必要的损失。对此我们提醒广大玩家：对于游客账号丢失，官方不会予以任何补偿。为了您的账号安全，请在注册后及时绑定手机，将游客号升级为正式账号并设置密码。升级后手机号码为你的账号，在更换设备或重新安装游戏后仍然可以使用。若遗忘登录密码或者银行密码，也能通过绑定手机进行找回。"
    --    pop._99last = true
    --    pop.isBig = true;
    --    FramePopoutCompent.Add(pop)
    --    --     return 
    --end
    GameManager.isLogin = true;
    self.isLogin = true;
    self.CheckLoginCode()

    self.PlayerNameText.text = SCPlayerInfo._05wNickName;

    coroutine.start(
            function()
                while (self.waitTransform == nil) do
                    coroutine.wait(2);
                end
                self.waitTransform.gameObject:SetActive(false);
                self.BackHallOnClick();
            end
    );

    --[[if SCPlayerInfo._30LookNotice == 0 then
	if not IsNil(self.backhallBtn) then
		self.backhallBtn.transform:GetComponent("Button").interactable = true
		if gameIsOnline then Event.Brocast(PanelListModeEven._010noticeInfoPanel, gameIsNotice); end
	end
	
end--]]
    -- 开启断网检测(每个几秒钟发送一个心跳)

    --local _buffer = ByteBuffer.New();
    --_buffer:WriteUInt32(SCPlayerInfo._01dwUser_Id);
    --Network.Send(MH.MDM_GP_USER, MH.SUB_GP_BANK_GETBANKINFO, buffer, gameSocketNumber.HallSocket);
    --Network.Send(4, 133, _buffer, gameSocketNumber.HallSocket);
    --   coroutine.start(HallScenPanel.CheckNetHall);
    self:InitPanl();
    ScenSeverName = gameServerName.HALL;
    --  if not Network.startCheckNetAll then Network.CheckNetAll() end
    -- local buffer = ByteBuffer.New();
    -- Network.Send(20, 6, buffer, gameSocketNumber.HallSocket); -- 申请房间列表
    transform:Find("Compose/HeadImg/Image/Image/Image"):GetComponent("Image").sprite = self.GetHeadIcon();
    MoveNotifyInfoClass.PlayerDeleteNotifyInfo();

    if SCPlayerInfo._36ReconnectGameID ~= 0 and SCPlayerInfo._37ReconnectFloorID ~= 0 and not Util.isPc then
        self.isReconnectGame = true;
        SCPlayerInfo._36ReconnectGameID = math.floor((SCPlayerInfo._36ReconnectGameID % 1000) / 10);
        logTable(SCPlayerInfo);
        local pop = FramePopoutCompent.Pop.New()
        pop._02conten = "您还有游戏未结束！"
        pop._99last = true
        pop._05yesBtnCallFunc = function()
            self.LoginReconnectGame();
        end
        pop.isBig = true;
        FramePopoutCompent.Add(pop)
    end

end

--断线重连游戏
function HallScenPanel.LoginReconnectGame()
    --如果正在游戏中不用重连
    if self.IsInGame then
        return ;
    end
    ShowWaitPanel(self.waitTransform, true, nil);
    coroutine.start(function()
        while not self.isReceiveRoomInfo do
            coroutine.wait(0.1);
        end
        self.reconnectRoomInfo = nil;
        for i = 1, #AllSCGameRoom do
            if AllSCGameRoom[i]._2wGameID == SCPlayerInfo._36ReconnectGameID and AllSCGameRoom[i]._1byFloorID == SCPlayerInfo._37ReconnectFloorID then
                self.reconnectRoomInfo = AllSCGameRoom[i];
                break ;
            end
        end
        if self.reconnectRoomInfo ~= nil then
            logTable(self.reconnectRoomInfo);
            if toInt64(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD)) >= toInt64(self.reconnectRoomInfo._6iLessGold) then
                local _id = self.reconnectRoomInfo._2wGameID;
                if _id == 21 then
                    _id = 51;
                elseif _id == 8 then
                    _id = 24;
                elseif _id == 9 then
                    _id = 8;
                end
                local t = GameManager.PassClientIndexToConfiger(_id);
                GameNextScenName = t.scenName;
                HallScenPanel.LoadGame(self.reconnectRoomInfo);
            else
                MessageBox.CreatGeneralTipsPanel("Your gold coins are insufficient, please recharge")
            end
        else
            ShowWaitPanel(self.waitTransform, false, nil);
            MessageBox.CreatGeneralTipsPanel("断线房间暂未开放");
        end
    end);
end

-----------------------------------------------------------Update驱动-----------------------------------------------
function HallScenPanel:FixedUpdate()
    if self.logonover then
        SetShowGame.AddDownTime();
        RankingPanelSystem.AddDownTime()
        GameRoomUserList.AddDownTime()
    end
    -- self.RecodeValueChange();
end
self.connectMaxTime = 20; --最大等待链接时间
self.connectTime = 20; --等待计数时间
self.connectSuccess = false; --是否链接成功
self.LoginList = {  }; --除高防外的备用IP
self.GameIPList = {  }; --除高防外的备用IP
self.LoginIndex = 0; --当前使用的IP索引 0==高防IP
self.GameIndex = 0; --当前使用的IP索引 0==高防IP
self.isLogin = false;

self.rqHeartTimer = 0;
self.rqHeartTimerMax = 7;
function HallScenPanel:Update()
    if self.connectSuccess then
        self.rqHeartTimer = self.rqHeartTimer - Time.deltaTime;
        if self.rqHeartTimer <= 0 then
            log("发送心跳")
            self.rqHeartTimer = self.rqHeartTimerMax;
            local buffer = ByteBuffer.New();
            Network.Send(MH.MDM_3D_HEARTCOFIG, MH.SUB_3D_CS_HEART, buffer, gameSocketNumber.HallSocket);
        end
    end
    --SetInfoSystem.checkUpHead();
    PersonalInfoSystem.checkUpHead();
    SetShowGame.Update();
    -- RankingPanelSystem.RankUpdate();
    --ChatPanel.Update();
    self.CheckNet()
    if Input.GetKeyDown(KeyCode.Escape) then
        local pop = FramePopoutCompent.Pop.New()
        pop._02conten = "是否退出游戏?";
        pop._05yesBtnCallFunc = function()
            Util.Quit();
        end;
        pop.isBig = true;
        GameManager.isQuitGame = true
        FramePopoutCompent.Add(pop);
    end
end
self.connectgameTimer = 7;
self.rqgameHeartTimer = 7;
self.connectgameMaxTimer = 7;
self.heartBack = true;
function HallScenPanel.CheckGameSocketConnect()
    if not self.heartBack then
        self.connectgameTimer = self.connectgameTimer - Time.deltaTime;
        if self.connectgameTimer <= 0 then
            Network.Close(gameSocketNumber.GameSocket);
            self.connectGameSuccess = false;
            self.connectgameTimer = 7;
            self.GameIndex = self.GameIndex + 1;
            if self.GameIndex > #self.GameIPList then
                self.GameIndex = 1;
                HallScenPanel.NetException("网络连接异常", gameSocketNumber.GameSocket);
                return ;
            end
            self.gameip = self.GameIPList[self.GameIndex];
            if self.checkNeedConnect(LaunchModule.currentSceneName) then
                self.ConnectGameServer();
            else
                HallScenPanel.NetException("网络连接异常", gameSocketNumber.GameSocket);
            end
        end
    end
end
function HallScenPanel.CheckNet()
    if self.connectSuccess then
        if self.connectTime > 0 then
            self.connectTime = self.connectTime - Time.deltaTime;
            if self.connectTime <= 0 then
                self.connectTime = self.connectMaxTime;
                HallScenPanel.ReqServer();
            end
        end
    end
end
function HallScenPanel.ReqServer()
    self.connectSuccess = false;
    self.LoginIndex = self.LoginIndex + 1;
    if self.LoginIndex > #self.LoginList then
        coroutine.start(function()
            self.LoginIndex = 0;
            HallScenPanel.NetException("网络异常...", gameSocketNumber.HallSocket);
            PlayerPrefs.SetString("PlayerIP", "");
            PlayerPrefs.SetString("PlayerPort", "");
            coroutine.wait(3);
            LuaResetGame();
        end);
    else
        Network.Close(gameSocketNumber.HallSocket);
        if LogonScenPanel.restConnectCount == nil or LogonScenPanel.restConnectCount < 2 then
            if GameManager.IsUseDefence() then
                local msg = Util.GetIPAndPort(GameManager.logintagIp, HttpData.login_port);
                log(msg);
                local arr = string.split(msg, ":");
                HallIP = arr[1];
                HallPort = arr[2];
            else
                HallIP = self.LoginList[self.LoginIndex];
            end
        else
            HallIP = self.LoginList[self.LoginIndex];
        end
        error("=====链接问题========开始连接下一个IP：" .. HallIP);
        local isSuccess = false;
        LogonScenPanel.ConnectHallServer(function()
            isSuccess = true;
            self.LoginIndex = 0;
            -- self.lastSendFunc();
            if self.isLogin then
                if SCPlayerInfo._04wAccount ~= nil then
                    local headimgurl = "";
                    local nickname = "";
                    local machineCode = Opcodes;
                    if PlayerPrefs.HasKey("LoginType") then
                        local type = PlayerPrefs.GetString("LoginType");
                        if type == "3" then
                            SCPlayerInfo._04wAccount = ''
                            SCPlayerInfo._6wPassword = ''
                            if LogonScenPanel.wxdata ~= nil then
                                local data = json.decode(LogonScenPanel.wxdata);
                                headimgurl = data.headimgurl;
                                nickname = data.nickname;
                                machineCode = data.openid;
                            end
                        end
                    end
                    local Data = {
                        -- 平台
                        [1] = GameManager.Platform();
                        -- [1] = PlatformID,
                        -- 渠道
                        [2] = gameQuDao,
                        [3] = PlatformID,
                        [4] = PlatformID * LoginPlatMultiply + LoginPlatAdd,
                        [5] = PlatformID * LoginPlatMultiply,
                        [6] = PlatformID + LoginPlatAdd,
                        -- id
                        [7] = SCPlayerInfo._04wAccount,
                        -- 密码
                        [8] = SCPlayerInfo._6wPassword,
                        -- 机器码
                        --[6] = 'f6b1b34674b522d5a534b7922006a12322'
                        [9] = machineCode,
                        [10] = LogonScenPanel.selfIP,
                        [11] = headimgurl,
                        [12] = nickname,
                    }
                    logErrorTable(Data)
                    local buffer = SetC2SInfo(CS_LogonInfo, Data)
                    --发送20-3 到服务器
                    Network.Send(MH.MDM_3D_LOGIN, MH.SUB_3D_CS_LOGIN, buffer, gameSocketNumber.HallSocket)
                end
            else
                LogonScenPanel.ResetBtn();
            end
        end);
    end
end
-----------------------------------------------------------End--------------------------------------------------------
-----------------------------------------------------------设置大厅个人信息数据(_31LookEmail==0才能看邮件)-----------------------------------------------
function HallScenPanel:InitPanl()

    if self.Compose == nil then
        return
    end
    if self.nvSprtie == nil then
        return
    end
    local go = transform:Find("Compose/HeadImg/Image/Image/Image").gameObject;
    -- 初始化头像
    if go == nil then
        return
    end
    local headstr = SCPlayerInfo._02bySex;
    if SCPlayerInfo._02bySex == enum_Sex.E_SEX_MAN then
        go.transform:GetComponent('Image').sprite = self.nanSprtie;
    elseif SCPlayerInfo._02bySex == enum_Sex.E_SEX_WOMAN then
        go.transform:GetComponent('Image').sprite = self.nvSprtie
    else
        go.transform:GetComponent('Image').sprite = self.nanSprtie;

    end

    go.transform:GetComponent("Image").sprite = self.GetHeadIcon();
    if SCPlayerInfo._03bCustomHeader == 0 then
        UrlHeadImg = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/0" .. SCPlayerInfo._02bySex .. ".png";
    else
        UrlHeadImg = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/" .. SCPlayerInfo._01dwUser_Id .. "." .. SCPlayerInfo._07wHeaderExtensionName;
        headstr = SCPlayerInfo._01dwUser_Id .. "." .. SCPlayerInfo._07wHeaderExtensionName;
    end

    --  UpdateFile.downHead(UrlHeadImg, headstr, nil, go);
    -- 充值初始化，避免充值成功，验证失败的情况
    if Util.isApplePlatform then
        -- IOS绑定充值的回调
        --NetManager:PayCallBackMethod(RechargeInfoSystem.PayCallBack, RechargeInfoSystem.PayFailed, RechargeInfoSystem.ProvideContent);
        -- 充值初始化，避免充值成功，验证失败的情况
        --NetManager:AppInitIAPManager();
    end
    -- if self.backhallBtn == nil then
    --     return
    -- end
    --[[	if SCPlayerInfo._31LookEmail == 0 then
		self.EmialSetTishi:SetActive(true);
		self.EmialSetTishi_New:SetActive(true);
	else--]]
    -- self.EmialSetTishi:SetActive(false);
    -- self.EmialSetTishi_New:SetActive(false);
    --end
    self.StartValuePropInfo()
end

function HallScenPanel.StartValuePropInfo()
    -- 初始化大厅面板的参数
    if self.PlayerNameText == nil then
        return
    end
    logYellow("_05wNickName==" .. SCPlayerInfo._05wNickName)
    self.PlayerNameText.text = SCPlayerInfo._05wNickName;
    self.UpdatePropInfo();
    if not PlayerPrefs.HasKey("IsPlayAudio") then
        PlayerPrefs.SetString("IsPlayAudio", "true");
    end
    if not PlayerPrefs.HasKey("isCanPlayMusic") then
        PlayerPrefs.SetString("isCanPlayMusic", "true");
    end
    if not PlayerPrefs.HasKey("isCanPlaySound") then
        PlayerPrefs.SetString("isCanPlaySound", "true");
    end
    if PlayerPrefs.GetString("IsPlayAudio") == "true" then
        AllSetGameInfo._5IsPlayAudio = true;
    else
        AllSetGameInfo._5IsPlayAudio = false;
    end

    if PlayerPrefs.GetString("isCanPlaySound") == "true" then
        AllSetGameInfo._6IsPlayEffect = true;
    else
        AllSetGameInfo._6IsPlayEffect = false;
    end
    -- local soundValue = 1
    -- if PlayerPrefs.HasKey("SoundValue") then
    --     soundValue = PlayerPrefs.GetString("SoundValue");
    -- else
    --     soundValue = 1
    -- end

    -- if soundValue ~= nil then
    --     self.BgSoundBtn.transform:GetComponent("Slider").value = tonumber(soundValue)
    -- else
    --     self.BgSoundBtn.transform:GetComponent("Slider").value = 1
    -- end

    -- local musicValue = 1
    -- if PlayerPrefs.HasKey("MusicValue") then
    --     musicValue = PlayerPrefs.GetString("MusicValue");
    -- else
    --     musicValue = 1
    -- end
    -- if musicValue ~= nil then
    --     self.BgMusicBtn.transform:GetComponent("Slider").value = tonumber(musicValue)
    -- else
    --     self.BgMusicBtn.transform:GetComponent("Slider").value = 1

    -- end

    --if AllSetGameInfo._5IsPlayAudio == false then
    --    self.BgMusicBtn.transform:GetComponent("Slider").value = 0
    --    --self.BgMusicBtn.transform:Find("open").gameObject:SetActive(false);
    --else
    --    self.BgMusicBtn.transform:GetComponent("Slider").value = 1
    --    -- self.BgMusicBtn.transform:Find("off").gameObject:SetActive(false);
    --    -- self.BgMusicBtn.transform:Find("open").gameObject:SetActive(true);
    --end
    --if AllSetGameInfo._6IsPlayEffect == false then
    --    self.BgSoundBtn.transform:GetComponent("Slider").value = 0
    --    -- self.BgSoundBtn.transform:Find("off").gameObject:SetActive(true);
    --    -- self.BgSoundBtn.transform:Find("open").gameObject:SetActive(false);
    --else
    --    self.BgSoundBtn.transform:GetComponent("Slider").value = 1
    --    -- self.BgSoundBtn.transform:Find("off").gameObject:SetActive(false);
    --    -- self.BgSoundBtn.transform:Find("open").gameObject:SetActive(true);
    --end
end

-- 更新大厅显示的道具信息
function HallScenPanel.UpdatePropInfo()
    --logYellow("刷新数据");
    --error("更新大厅显示道具" .. "gameData.GetProp(enum_Prop_Id.E_PROP_GOLD)===" .. gameData.GetProp(enum_Prop_Id.E_PROP_GOLD));
    if self.IDText == nil then
        return
    end
    if self.HeadIoc ~= nil then

        self.goldText.text = HallScenPanel.ShowText(tostring(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD)));
        --self.BankGold.text = tostring(gameData.GetProp(enum_Prop_Id.E_PROP_STRONG));

        self.IDText.text = tostring(SCPlayerInfo._beautiful_Id);
        --self.ticketText.text = tostring(gameData.GetProp(enum_Prop_Id.E_PROP_TICKET));
        --local bankGold_k = gameData.GetProp(enum_Prop_Id.E_PROP_STRONG);
        --logYellow("设置大厅银行数据："..bankGold_k);
        --self.HeadIoc.transform:Find("Bank").gameObject:GetComponent('Text').text = bankGold_k;
    end
end
-----------------------------------------------------------END---------------------------------------------------------------
-----------------------------------------------------------声音管理（按钮和BGM）-----------------------------------------------
-- 播放按钮声音
function HallScenPanel.PlayeBtnMusic(name)
    logYellow("按钮点击")
    local clipName = name or "anniu3";
    local obj = self.Pool("Music", false);
    if obj == nil then
        return
    end
    local clip = obj.transform:Find(clipName):GetComponent("AudioSource").clip;
    if clip == nil then
        return
    end
    MusicManager:PlayX(clip);
end

--播放BGM
--[[function HallScenPanel.PlayeBgMusic(play, name)
   local rc = Util.Read("IsPlayAudio");
	if rc==nil then  end
	if rc==tostring(false) then  AllSetGameInfo._5IsPlayAudio=false end
	if rc==tostring(true) then  AllSetGameInfo._5IsPlayAudio=true end
	local b = AllSetGameInfo._5IsPlayAudio;
	
	if play ~= nil then b = play end
	if play == nil then b = true end
	local clipName = "bgm3";
	if name ~= nil then clipName = name end
	local obj = self.Pool("Music", false);

	if obj == nil then return end
	local clip = obj.transform:Find(clipName):GetComponent("AudioSource").clip;
	if clip == nil then return end
	MusicManager:PlayBacksoundX(clip, b);
end--]]
function HallScenPanel.PlayeBgMusic(play, name)
    local rc = Util.Read("IsPlayAudio");
    if rc == nil then
    end
    if not PlayerPrefs.HasKey("IsPlayAudio") then
        PlayerPrefs.SetString("IsPlayAudio", "true");
    end
    rc = PlayerPrefs.GetString("IsPlayAudio");
    if rc == tostring(false) then
        AllSetGameInfo._5IsPlayAudio = false
    end
    if rc == tostring(true) then
        AllSetGameInfo._5IsPlayAudio = true
    end
    local b = AllSetGameInfo._5IsPlayAudio;
    if play ~= nil then
        b = play
    end
    local clipName = "bgm3";
    if name ~= nil then
        clipName = name
    end
    local obj = self.Pool("Music", false);
    if obj == nil then
        return
    end
    local clip = obj.transform:Find(clipName):GetComponent("AudioSource").clip;
    if clip == nil then
        return
    end
    MusicManager:PlayBacksoundX(clip, b);
end

------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------主界面6个按钮------------------------------------------------------
-->（点击事件）个人信息 ：通过面板事件打开个人信息界面
function HallScenPanel.HeadBtnOnClick()
    self.CloseSettingPanel();
    --self.backhallBtn.transform:GetComponent("Button").interactable = true
    if gameIsOnline then
        self.SetBtnInter(false);
        self.openInfoIndex = 0;
        self.HeadIoc.transform:Find("HeadBtn").gameObject:GetComponent('Button').interactable = false;
        self.PlayeBtnMusic();
        Event.Brocast(PanelListModeEven._005personalPanel, self.openInfoIndex);
        self.HeadIoc.transform:Find("HeadBtn").gameObject:GetComponent('Button').interactable = true;
    end
end

-->（点击事件）通过面板事件打开充值界面
function HallScenPanel.PlayBtnOnClick()
    logError("充值=====")
    self.SetBtnInter(false);
    --self.backhallBtn.transform:GetComponent("Button").interactable = true
    local go = self.PlayBtn:GetComponent('Button');
    go.interactable = false;
    self.PlayeBtnMusic();

    Event.Brocast(PanelListModeEven._003rechargePanel);
    go.interactable = true;
    go:Select();
end

local setopentime = 0;

function HallScenPanel.CloseSettingPanel(go)
    if go ~= nil then
        HallScenPanel.PlayeBtnMusic();
    end
    --self.RecFrameBtns:SetActive(false)
end
--> (点击事件) 顶部菜单按钮
function HallScenPanel.SetsBtnOnClick(obj)
    HallScenPanel.PlayeBtnMusic();
    self.BackHallOnClick();
    RecFrameMask.Open(luaBehaviour)
end

--> (点击事件) 排行榜  ：通过事件打开排行榜
function HallScenPanel.GetRank()
    -- if not IsNil(RankingPanelSystem.RankingPanel) then
    --     return
    -- end
    -- -- self.RankingBtn:GetComponent('Button').interactable = false;
    -- self.SetBtnInter(false);
    -- self.backhallBtn.transform:GetComponent("Button").interactable = true
    -- self.PlayeBtnMusic();
    -- local go = self.RankingBtn:GetComponent('Button');
    -- go.interactable = false;
    -- Event.Brocast(PanelListModeEven._002rankPanel);
    -- go.interactable = true;
    -- go:Select();
end

--> (点击事件) 显示大厅
local isInitSetShowGame = false;
function HallScenPanel.BackHallOnClick(obj)
    -- 点击大厅才做显示大厅的处理
    if isInitSetShowGame == false then
        isInitSetShowGame = true;
        SetShowGame.Open();
    end
    -- if not Util.isPc then
    self.Mid.gameObject:SetActive(true);
    -- end
    -- 设置要显示的游戏（顺序，是否下载）
    --  self.LastPanel.transform:DOLocalMoveX(-900, 1, false):SetEase(DG.Tweening.Ease.Linear);
    local pos = HallScenPanel.HallMid.transform.localPosition
    if pos.x < 0 then
        --HallScenPanel.HallMid.transform.localPosition = Vector3.New(0, pos.y, pos.z)
        if HallScenPanel.MidCloseBtn ~= nil then
            HallScenPanel.MidCloseBtn();
            HallScenPanel.MidCloseBtn = nil
        end
        self.ClearPanel();
        --self.backhallBtn.transform:GetComponent("Button").interactable = false
        self.SetBtnInter(true);
    end
end
function HallScenPanel.DuihuanOnClick(go)
    HallScenPanel.PlayeBtnMusic()
    DuiHuanPanel.Init(self.LuaBehaviour);
    --PersonalInfoSystem.Creatobj(HallScenPanel.Pool("DuiHuanPanel"))
    -- DuiHuanPanel.Open(luaBehaviour, "1")
end
function HallScenPanel.RenWuOnClick(go)
    HallScenPanel.PlayeBtnMusic()
    --MessageBox.CreatGeneralTipsPanel("功能暂未开放");
    RenWuPanel.Open(luaBehaviour)
end



--> (点击事件) 银行功能 ：通过事件打开银行面板  Network.Send(20, 6, buffer, gameSocketNumber.HallSocket); 判断是否开复
function HallScenPanel.BankerBtnOnClick()

    if (SCPlayerInfo._29szPhoneNumber == "") then
        BDPhonePanel.Open(luaBehaviour)
        return
    end
    if not IsNil(BankPanel.BankPanelObj) then
        return
    end
    self.isOpenBank = true;
    self.CloseSettingPanel();
    logError("银行打开")
    self.SetBtnInter(false);
    --self.backhallBtn.transform:GetComponent("Button").interactable = true

    self.PlayeBtnMusic();

    --local go = self.backhallBtn:GetComponent('Button');
    --go.interactable = false;

    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(SCPlayerInfo._01dwUser_Id);
    --Network.Send(MH.MDM_GP_USER, MH.SUB_GP_BANK_GETBANKINFO, buffer, gameSocketNumber.HallSocket);
    Network.Send(4, 133, buffer, gameSocketNumber.HallSocket);

    --Event.Brocast(PanelListModeEven._004bankPanel);
    --go.interactable = true;
    --go:Select();
end

--------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------菜单界面7个按钮------------------------------------------------------
--> (点击事件) 公告 ：通过10号事件打开银行面板
function HallScenPanel.NoticeBtnOnClick()
    -- self.SetBtnInter(false);
    -- self.backhallBtn.transform:GetComponent("Button").interactable = true
    -- -- 暂时屏蔽活动界面
    -- --self.SetsBtnOnClick();
    -- --local go = self.NoticeBtn:GetComponent('Button');
    -- go.interactable = false;
    -- Event.Brocast(PanelListModeEven._010noticeInfoPanel);
    -- go.interactable = true;
    -- go:Select();
end

--> (点击事件) 邮件 ：通过17号事件打开邮件面板
function HallScenPanel.EmailBtnOnClick()
    HallScenPanel.PlayeBtnMusic()
    EmailPanel.Open(luaBehaviour)
end
function HallScenPanel.GWBtnOnClick()
    HallScenPanel.PlayeBtnMusic()
    GWPanel.Open();
end
--> (点击事件) 安全中心 ：通过5号事件打开安全中心面板
function HallScenPanel.SafeBtnOnClick()
    HallScenPanel.PlayeBtnMusic()
    --self.RecFrameBtns:SetActive(false);
    changePassWordPanel.Open(luaBehaviour)
    --changePassWordPanel.Open(self.ChangePassWordPanel,luaBehaviour)
end

--> (点击事件) 设置静音
function HallScenPanel.BgMusicBtnOnClick(value)
    -- local go = self.BgMusicBtn:GetComponent('Button')
    -- go.interactable = false;
    -- if IsEffectMuteBl == false then
    -- end
    local isplay = AllSetGameInfo._5IsPlayAudio;
    if value == 0 then
        AllSetGameInfo._5IsPlayAudio = false;
    else
        AllSetGameInfo._5IsPlayAudio = true;
    end
    Util.Write("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
    PlayerPrefs.SetString("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
    PlayerPrefs.SetString("MusicValue", tostring(value));
    GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
    if not isplay and value > 0 then
        self.PlayeBgMusic();
    end
    local soundValue = 1
    if PlayerPrefs.HasKey("SoundValue") then
        soundValue = PlayerPrefs.GetString("SoundValue");
    end
    MusicManager:SetValue(tonumber(soundValue), tonumber(value))
    -- if AllSetGameInfo._5IsPlayAudio == false then
    --     --SetInfoSystem.ResetMute()
    --     HallScenPanel.PlayeBgMusic(true);
    --     AllSetGameInfo._5IsPlayAudio = true;
    --     self.BgMusicBtn.transform:Find("off").gameObject:SetActive(false);
    --     self.BgMusicBtn.transform:Find("open").gameObject:SetActive(true);
    -- else
    --     --SetInfoSystem.GameMute()
    --     HallScenPanel.PlayeBgMusic(false);
    --     AllSetGameInfo._5IsPlayAudio = false;
    --     self.BgMusicBtn.transform:Find("off").gameObject:SetActive(true);
    --     self.BgMusicBtn.transform:Find("open").gameObject:SetActive(false);
    -- end ;
    -- PlayerPrefs.SetString("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
    -- PlayerPrefs.SetString("isCanPlayMusic", tostring(AllSetGameInfo._5IsPlayAudio));
    -- GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
    -- go.interactable = true;
    -- go:Select();
end
--> (点击事件) 设置静音
function HallScenPanel.BgSoundBtnOnClick(value)
    if value == 0 then
        AllSetGameInfo._6IsPlayEffect = false;
    else
        AllSetGameInfo._6IsPlayEffect = true;
    end
    Util.Write("isCanPlaySound", tostring(AllSetGameInfo._6IsPlayEffect));
    PlayerPrefs.SetString("isCanPlaySound", tostring(AllSetGameInfo._5IsPlayAudio));
    PlayerPrefs.SetString("SoundValue", tostring(value));
    GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);

    local musicValue = 1
    if PlayerPrefs.HasKey("MusicValue") then
        musicValue = PlayerPrefs.GetString("MusicValue");
    end
    MusicManager:SetValue(tonumber(value), tonumber(musicValue))
    -- local go = self.BgSoundBtn:GetComponent('Button')
    -- go.interactable = false;
    -- if IsEffectMuteBl == false then
    -- end

    -- if AllSetGameInfo._6IsPlayEffect == false then
    --     HallScenPanel.PlayeBtnMusic();
    --     AllSetGameInfo._6IsPlayEffect = true;
    --     self.BgSoundBtn.transform:Find("off").gameObject:SetActive(false);
    --     self.BgSoundBtn.transform:Find("open").gameObject:SetActive(true);
    -- else
    --     AllSetGameInfo._6IsPlayEffect = false;
    --     self.BgSoundBtn.transform:Find("off").gameObject:SetActive(true);
    --     self.BgSoundBtn.transform:Find("open").gameObject:SetActive(false);
    -- end ;
    -- PlayerPrefs.SetString("isCanPlaySound", tostring(AllSetGameInfo._6IsPlayEffect));
    -- GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
    -- go.interactable = true;
    -- go:Select();
end

--> (点击事件) 客户反馈	;直接打开反馈界面
function HallScenPanel.ChatBtnOnClick()

    -- local go = self.KefuBtn:GetComponent('Button');
    -- go.interactable = false;
    -- self.PlayeBtnMusic();
    -- MessageBox.CreatGeneralTipsPanel("请联系我们的客服专号：，反馈你的意见！");
    -- self.CloseSettingPanel();
    -- --ChatPanel.Open(luaBehaviour, transform);
    -- go.interactable = true;
    -- go:Select();
end

--> (点击事件) 分享游戏 ：面板事件13号打开
function HallScenPanel.ShareBtnOnClick()

    -- local go = self.ShareBtn:GetComponent('Button');
    -- go.interactable = false;
    -- self.PlayeBtnMusic();
    -- Event.Brocast(PanelListModeEven._013sharePanel);
    -- go.interactable = true;
    -- go:Select();
end

--> (点击事件) 账号注销
function HallScenPanel.SetsChildSetBtnOnClick()
    HallScenPanel.PlayeBtnMusic()
    self.goldText.text = HallScenPanel.ShowText("0")
    AllSCUserProp = {}
    -- local go = self.SetsChildSetBtn:GetComponent('Button')
    -- go.interactable = false;
    if IsEffectMuteBl == false then
        self.PlayeBtnMusic();
    end
    PlayerPrefs.SetString("AutoLogin", "0");

    Event.Brocast(PanelListModeEven._012setInfoPanel);
    SetInfoSystem.AccountChangeBtnOnClick();
    -- go.interactable = true;
    -- go:Select();
    self.CloseSettingPanel();
    self.connectSuccess = false;
end

---------------------------------------------------------------------------------------------------------------------------------
-- 交给商城信息系统处理相关操作
function HallScenPanel.MallBtnOnClick()
    --self.backhallBtn.transform:GetComponent("Button").interactable = true
    local go = self.MallBtn:GetComponent('Button');
    go.interactable = false;
    self.PlayeBtnMusic();
    Event.Brocast(PanelListModeEven._008exchangePanel);
    go.interactable = true;
    go:Select();
end
-- 交给免费金币信息系统处理相关操作
function HallScenPanel.FreeGoldBtnOnClick()
    --self.backhallBtn.transform:GetComponent("Button").interactable = true
    local go = self.FreeGoldBtn:GetComponent('Button');
    go.interactable = false;
    self.PlayeBtnMusic();
    Event.Brocast(PanelListModeEven._006freeGoldPanel, false);
    go.interactable = true;
    go:Select();
end
-- 交给聚宝盆信息系统处理相关操作
function HallScenPanel.CornucopiaBtnOnClick()
    --self.backhallBtn.transform:GetComponent("Button").interactable = true
    local go = self.CornucopiaBtn:GetComponent('Button');
    go.interactable = false;
    self.PlayeBtnMusic();
    Event.Brocast(PanelListModeEven._009cornucopiaPanel);
    go.interactable = true;
    go:Select();
end
function HallScenPanel.SetXiaoGuo(obj)
    -- 加一个显示效果
    obj.transform.localPosition = Vector3.New(0, 0, 0)
    local datapos = HallScenPanel.HallMid.transform.localPosition
    --HallScenPanel.HallMid.transform.localPosition = Vector3.New(-900, datapos.y, datapos.z)
    -- SetShowGame.ShowRank(false);
    self.Mid.gameObject:SetActive(false);
end
self.openInfoIndex = 0; -- 1 绑定手机  2 上传头像 3 修改昵称
function HallScenPanel.openUserInfo(args)
    --self.backhallBtn.transform:GetComponent("Button").interactable = true
    self.openInfoIndex = args;
    self.HeadIoc.transform:Find("HeadBtn").gameObject:GetComponent('Button').interactable = false;
    self.PlayeBtnMusic();
    Event.Brocast(PanelListModeEven._005personalPanel, self.openInfoIndex);
    self.HeadIoc.transform:Find("HeadBtn").gameObject:GetComponent('Button').interactable = true;
end

-- 10s之后为自动关闭
function HallScenPanel.CloseSetOnClick()
    -- local pos = self.RecFrameBtns.transform.localPosition
    -- if pos.x < 600 then
    --     self.RecFrameBtns.transform.localPosition = Vector3.New(1000, pos.y, pos.z)
    --     self.RecFrameBtns:SetActive(false)
    -- end
end

--- 准备游戏服务器
function HallScenPanel.LoadGame(gameData)
    -- if self.RecFrameBtns.transform.localPosition.x < 600 then
    --     self.CloseSettingPanel()
    -- end
    log("连接.." .. gameData._9Name);
    self.waitTransform.gameObject:SetActive(true);
    local Scount = table.getn(AllSCGameRoom);
    local infoList = nil;
    for i = 1, Scount do
        if AllSCGameRoom[i]._2wGameID == gameData._2wGameID and AllSCGameRoom[i]._1byFloorID == gameData._1byFloorID then
            infoList = AllSCGameRoom[i];
        end
    end
    if NewHand.buyu_IsNewHand ~= 4 then
        local bl = 0;
        if string.find(gameData._9Name, gameServerName.LKPY) then
            for i = 1, #UserNewHand do
                if UserNewHand[i][1] == 1 then
                    bl = 1;
                end
                if UserNewHand[i][1] == 2 then
                    bl = 2;
                end
                if UserNewHand[i][1] == 3 then
                    bl = 3;
                end
                if UserNewHand[i][1] == 4 then
                    bl = 4;
                end
            end

        end
        NewHand.buyu_IsNewHand = bl;
    end
    if infoList == nil then
        self.waitTransform.gameObject:SetActive(false);
        FramePopoutCompent.Show("服务器未开放！")
        ScenSeverName = gameServerName.HALL;
        return ;
    end

    -- 记录服务器名字
    ScenSeverName = gameData._9Name;
    -- 取消系统通告显示
    NotifyInfoTextObj = nil;
    -- 取消玩家通告显示
    PlayerNotifyInfoTextObj = nil;
    -- 记录服务器名字
    ScenSeverName = gameData._9Name;
    log("服务器名字:" .. ScenSeverName);
    SCPlayerInfo._22Address = gameData._9Name;
    --   GameManager.PanelLogin();
    self.enterGameServerEventID = GetEventIndex();
    local f = function()
        LaunchModule.Enter(GameNextScenName);
        Event.RemoveListener(self.enterGameServerEventID);
        return true;
    end
    Event.AddListener(self.enterGameServerEventID, f)
    self.gameip = infoList._4dwServerAddr;
    self.gameport = infoList._5wServerPort;
    self.currentPort = infoList._5wServerPort;
    if (Util.isPc or Util.isEditor) and not GameManager.IsTest then
        self.gameip = LogonScenPanel.GWData.PCGameIP;
    end
    self.gameip = LogonScenPanel.GWData.PCGameIP;
    GameManager.gametagIp = self.gameip;
    -- self.gameip = "192.168.101.3"
    -- self.gameport = 28018
    logError(string.format("gameSver ip:%s,port:%s", self.gameip, self.gameport));
    if GameManager.IsTest then
        self.ConnectGameServer();
    else
        if GameManager.IsUseDefence() then
            local msg = Util.GetIPAndPort(GameManager.gametagIp, self.currentPort);
            log("msg==========:" .. msg);
            local arr = string.split(msg, ":");
            self.gameip = arr[1];
            self.gameport = arr[2];
        end
        self.ConnectGameServer();
    end
    TishiScenes = nil;
end

-- Home键回来重新登录
function HallScenPanel.ReLoadGame(callbackfun)
    log("Home键回来重新登录");
    if LaunchModule.currentSceneName ~= "module02" then
        if GameManager.IsUseDefence() then
            local msg = Util.GetIPAndPort(GameManager.gametagIp, self.currentPort);
            local arr = string.split(msg, ":");
            self.gameip = arr[1];
            self.gameport = arr[2];
        end
        self.ConnectGameServer(callbackfun);
    end
end


-- 创建数字Img显示对象
function HallScenPanel.CreatShowNum(father, numstr)
    -- numstr = unitPublic.showNumberText2(tonumber(numstr));
    if tyNum == nil then
        tyNum = transform:Find("Compose/TyNum").gameObject;
        tyNum:SetActive(false);
    end
    local klx = 0;
    local kw = 0;
    for i = 1, string.len(numstr) do
        local prefebnum = string.sub(numstr, i, i);
        prefebnum = self.repaceNum(prefebnum);
        if kw ~= 0 then
            klx = kw;
        end
        if prefebnum == 10 then
            klx = klx - 2;
            kw = kw + 9;
        elseif args == 11 then
            kw = kw + 22;
        elseif args == 12 then
            kw = kw + 22;
        else
            kw = kw + 15;
        end

        if father.transform.childCount > string.len(numstr) then
            for j = string.len(numstr), father.transform.childCount - 1 do
                destroy(father.transform:GetChild(j).gameObject);
            end
        end
        if father.transform.childCount < i then
            local go2 = newobject(tyNum.transform:GetChild(prefebnum).gameObject);
            go2.transform:SetParent(father.transform);
            go2.transform.localScale = Vector3.one;
            go2.transform.localPosition = Vector3.New(klx, 0, 0);
            go2.name = prefebnum;
        else
            father.transform:GetChild(i - 1).gameObject.name = prefebnum;
            father.transform:GetChild(i - 1).transform.localPosition = Vector3.New(klx, 0, 0);
            father.transform:GetChild(i - 1).gameObject:GetComponent('Image').sprite = tyNum.transform:GetChild(prefebnum).gameObject:GetComponent('Image').sprite;
            father.transform:GetChild(i - 1).gameObject:GetComponent('Image'):SetNativeSize();
        end
    end
end

function HallScenPanel.repaceNum(args)
    if args == "." then
        return 10;
    elseif args == "w" then
        return 11;
    elseif args == "y" then
        return 12;
    end
    return args;
end
function HallScenPanel.CreatTickePrefeb(args)
    for i = 0, self.TicketNum.transform.childCount - 1 do
        destroy(self.TicketNum.transform:GetChild(i).gameObject);
    end
    for i = 1, string.len(PlayerTicketObj:GetComponent('Text').text) do
        local prefebnum = string.sub(PlayerTicketObj:GetComponent('Text').text, i, i);
        local go = newobject(args.transform:GetChild(prefebnum).gameObject);
        go.transform:SetParent(self.TicketNum.transform);
        go.transform.localScale = Vector3.one;
        go.transform.localPosition = Vector3.New(0, 0, 0);
    end
end

function HallScenPanel.SendNeedData()
    local buffer = ByteBuffer.New();
    -- 获取分享每日奖励道具
    Network.Send(MH.MDM_3D_TASK, MH.SUB_3D_CS_SHARE_AWARD, buffer, gameSocketNumber.HallSocket);
end

-- 清理大厅二级界面
function HallScenPanel.ClearPanel()
    if BankPanel.BankPanelObj ~= nil then
        destroy(BankPanel.BankPanelObj);
        BankPanel.BankPanelObj = nil;
    end
    if CornucopiaSystem.CornucopiaPanel ~= nil then
        destroy(CornucopiaSystem.CornucopiaPanel);
        CornucopiaSystem.CornucopiaPanel = nil;
    end
    if GameRoomList.GameRoomListPanel ~= nil then
        destroy(GameRoomList.GameRoomListPanel);
        GameRoomList.UnloadOther();
        GameRoomList.GameRoomListPanel = nil;
        HallScenPanel.isCreatIngRoom = false;
        GameRoomUserList.destory();
    end
    if GiveRedBag.GiveRedBagPanel ~= nil then
        destroy(GiveRedBag.GiveRedBagPanel);
        GiveRedBag.GiveRedBagPanel = nil;
    end
    if HelpInfoSystem.HelpInfoPanel ~= nil then
        destroy(HelpInfoSystem.HelpInfoPanel);
        HelpInfoSystem.HelpInfoPanel = nil;
    end
    if MallInfoSystem.MallInfoPanel ~= nil then
        destroy(MallInfoSystem.MallInfoPanel);
        MallInfoSystem.MallInfoPanel = nil;
    end
    if NoticeInfoSystem.NoticeInfoPanel ~= nil then
        destroy(NoticeInfoSystem.NoticeInfoPanel);
        NoticeInfoSystem.NoticeInfoPanel = nil;
    end
    if PersonalInfoSystem.PersonalInfoPanel ~= nil then
        destroy(PersonalInfoSystem.PersonalInfoPanel);
        PersonalInfoSystem.PersonalInfoPanel = nil;
    end
    if PlayerInfoSystem.PlayererInfoPanel ~= nil then
        destroy(PlayerInfoSystem.PlayererInfoPanel);
        PlayerInfoSystem.PlayererInfoPanel = nil;
    end
    if RankingPanelSystem.RankingPanel ~= nil then
        destroy(RankingPanelSystem.RankingPanel);
        RankingPanelSystem.RankingPanel = nil;
    end
    if GiveAndSendMoneyRecordPanle.curobj ~= nil then
        destroy(GiveAndSendMoneyRecordPanle.curobj);
        GiveAndSendMoneyRecordPanle.dest();
    end
    if RechargeInfoSystem.RechargeInfoPanel ~= nil then
        destroy(RechargeInfoSystem.RechargeInfoPanel);
        RechargeInfoSystem.RechargeInfoPanel = nil;
    end
    -- if EmailInfoSystem.EmailPanel ~= nil then
    --     destroy(EmailInfoSystem.EmailPanel);
    --     EmailInfoSystem.EmailPanel = nil;
    -- end
    -- 删除大厅提示
    for i = 1, #Destroy_Panel do
        if Destroy_Panel[i] ~= nil then
            destroy(Destroy_Panel[i])
        end
    end
    Destroy_Panel = {};
end

function HallScenPanel.GC(name)
    coroutine.start(
            function()
                coroutine.wait(0);
                local removeName = {};
                local keys = ResManager.bundles.Keys
                local iter = keys:GetEnumerator()
                while iter:MoveNext() do
                    local kname = iter.Current;
                    local flag, v = ResManager.bundles:TryGetValue(kname, nil);
                    if flag == true then
                        if kname ~= name then
                            if string.find(kname, "module02") then
                                v:Unload(false);
                            else
                                logError("Unload LoadSceneAsyncSceneNameAB:" .. kname);
                                v:Unload(true);
                            end
                            table.insert(removeName, #removeName + 1, kname);
                        end
                    end
                end
                for i = 1, #removeName do
                    ResManager.bundles:Remove(removeName[i]);
                end
                NetManager:GameGC();
            end
    );
end

function HallScenPanel.UpdatePersonInfo(buffer, wSize)
    -- CMD_3D_SC_NotifyChangeUserInfo
    local data = buffer:ReadByte();
    if data == 1 then
        -- ID
        SCPlayerInfo._33PlayerID = buffer:ReadUInt32();
        -- self.CreatShowNum(self.ID, SCPlayerInfo._33PlayerID)
        self.IDText.text = SCPlayerInfo._33PlayerID;
    elseif data == 2 then
        -- 2昵称
        SCPlayerInfo._05wNickName = buffer:ReadString()
        self.PlayerNameText.text = SCPlayerInfo._05wNickName;
    elseif data == 3 then
        -- 3签名
        SCPlayerInfo._08wSign = buffer:ReadString()
    end
end

function HallScenPanel.NetException(args, index)

    local idx = index;
    if idx == nil then
        idx = 999;
    end
    error("HallScenPanel.NetException:" .. idx);
    if idx > 100 then
        return
    end
    local s = "网络异常";
    local Pop = FramePopoutCompent.Pop.New();
    Pop._01showType = FramePopoutCompent.ShowType._01border;
    Pop._02conten = args or s;
    Pop._03jump = false;
    Pop._04scenName = nil;
    Pop._05yesBtnCallFunc = nil;
    Pop._06noBtnCallFunc = nil;
    Pop._07module = LaunchModuleConfiger.Module02;
    Pop._99last = true;
    Pop.isBig = true;
    --这里设置下模块,后面号判断在大厅还是游戏
    if idx == gameSocketNumber.GameSocket then
        Pop._07module = LaunchModuleConfiger.Module23
    end

    Pop._06noBtnCallFunc = function()
        Util.ResetGame();
    end

    --处理游戏断网了是弹到大厅还是从新启动APP
    if idx == gameSocketNumber.GameSocket then
        local c = Network.State(gameSocketNumber.HallSocket);
        if c == true then
            log("大厅没有断线");
            Pop._06noBtnCallFunc = function()
                GameSetsBtnInfo.ReturnBtnOnClick();
            end
        end
    end

    FramePopoutCompent.Add(Pop);
end

self.OnReConnnect = false;
self.IsConnectGame = false;
self.isReconnect = false;
self.ReconnectEvent = "ReconnectGame";

self.startConnectGame = false;
function HallScenPanel.checkNeedConnect(modulename)
    local needlist = { "module13", "module16", "module17", "module18", "module22", "module24", "module25", "module27", "module28", "module32", "module33", "module38", "module39" };
    for i = 1, #needlist do
        if needlist[i] == modulename then
            return true;
        end
    end
    return false;
end
--连接游戏服务器
--包含了游戏服务器的网络断线重连
function HallScenPanel.ConnectGameServer(cb)

    local callBack = function()
        self.startConnectGame = false;
        self.connectGameSuccess = true;
        self.connectgameTimer = 7;
        if GameManager.IsStopGame then
            return
        end
        local buffer = ByteBuffer.New();
        log("连接游戏服务器成功。");
        Network.Send(301, 5, buffer, gameSocketNumber.GameSocket);
        local f = Event.Brocast(self.enterGameServerEventID);
        if f == nil then
            log("游戏网络异常处理完毕!");
            Event.Brocast(EventIndex.OnNetException .. gameSocketNumber.GameSocket, true);
        end
        self.OnReConnnect = false;
        self.IsConnectGame = true;
        if (self.isReconnect) then
            self.isReconnect = false;
            Event.Brocast(self.ReconnectEvent);
        end
        GameSetsBtnInfo.InitConnectWait(false);
    end

    --这个cb函数可能是游戏强制重连
    if type(cb) == "function" then
        callBack = cb
    end
    local function rest()
        self.IsConnectGame = false;

        if not self.connectGameSuccess then
            return
        end

        if GameManager.IsStopGame then
            return
        end
        coroutine.start(
                function()
                    coroutine.wait(0.5);
                    logError("yichang2---------------------")
                    self.waitTransform.gameObject:SetActive(false);
                    if self.checkNeedConnect(LaunchModule.currentSceneName) then
                        local t = 8;
                        if HallScenPanel.restConnectCount < t then
                            self.isReconnect = true;
                            GameSetsBtnInfo.InitConnectWait(true);
                            if self.OnReConnnect then
                                return
                            end
                            log("======================")
                            self.OnReConnnect = true;
                            -- 延迟self.restConnectCount+1秒重连
                            local wt = HallScenPanel.restConnectCount + 4;
                            coroutine.wait(wt);
                            HallScenPanel.restConnectCount = HallScenPanel.restConnectCount + 1;
                            logError(string.format("第%d次尝试重新连接游戏服务器!", HallScenPanel.restConnectCount));
                            self.OnReConnnect = false;
                            Network.Close(gameSocketNumber.HallSocket);
                            Network.Close(gameSocketNumber.GameSocket);
                            if GameManager.IsUseDefence() then
                                local msg = Util.GetIPAndPort(GameManager.logintagIp, HttpData.login_port);
                                local arr = string.split(msg, ":");
                                HallIP = arr[1];
                                HallPort = arr[2];
                            else
                                HallIP = HttpData.login_ip;
                                HallPort = HttpData.login_port;
                            end
                            log("重连大厅")
                            ScenSeverName = gameServerName.HALL;
                            LogonScenPanel.ConnectHallServer(function()
                                if SCPlayerInfo._04wAccount ~= nil then
                                    local headimgurl = "";
                                    local nickname = "";
                                    local machineCode = Opcodes;
                                    if PlayerPrefs.HasKey("LoginType") then
                                        local type = PlayerPrefs.GetString("LoginType");
                                        if type == "3" then
                                            SCPlayerInfo._04wAccount = ''
                                            SCPlayerInfo._6wPassword = ''
                                            if LogonScenPanel.wxdata ~= nil then
                                                local data = json.decode(LogonScenPanel.wxdata);
                                                headimgurl = data.headimgurl;
                                                nickname = data.nickname;
                                                machineCode = data.openid;
                                            end
                                        end
                                    end
                                    local Data = {
                                        -- 平台
                                        [1] = GameManager.Platform();
                                        -- [1] = PlatformID,
                                        -- 渠道
                                        [2] = gameQuDao,
                                        [3] = PlatformID,
                                        [4] = PlatformID * LoginPlatMultiply + LoginPlatAdd,
                                        [5] = PlatformID * LoginPlatMultiply,
                                        [6] = PlatformID + LoginPlatAdd,
                                        -- id
                                        [7] = SCPlayerInfo._04wAccount,
                                        -- 密码
                                        [8] = SCPlayerInfo._6wPassword,
                                        -- 机器码
                                        --[6] = 'f6b1b34674b522d5a534b7922006a12322'
                                        [9] = machineCode,
                                        [10] = LogonScenPanel.selfIP,
                                        [11] = headimgurl,
                                        [12] = nickname,
                                    }
                                    logErrorTable(Data)
                                    local buffer = SetC2SInfo(CS_LogonInfo, Data)
                                    --发送20-3 到服务器
                                    Network.Send(MH.MDM_3D_LOGIN, MH.SUB_3D_CS_LOGIN, buffer, gameSocketNumber.HallSocket)
                                end

                                ScenSeverName = gameServerName.Game03;
                                if GameManager.IsUseDefence() then
                                    local msg = Util.GetIPAndPort(GameManager.gametagIp, self.currentPort);
                                    local arr = string.split(msg, ":");
                                    self.gameip = arr[1];
                                    self.gameport = arr[2];
                                else
                                    self.GameIndex = self.GameIndex + 1;
                                    if self.GameIndex > #self.GameIPList then
                                        self.GameIndex = 1;
                                        HallScenPanel.NetException("游戏网络异常!", gameSocketNumber.GameSocket);
                                        return ;
                                    end
                                    self.gameip = self.GameIPList[self.GameIndex];
                                end
                                log("重连游戏")
                                self.ConnectGameServer();
                            end);
                            return ;
                        else
                            HallScenPanel.NetException("游戏网络异常!", gameSocketNumber.GameSocket);
                            GameSetsBtnInfo.ReturnBtnOnClick();
                        end
                    else
                        HallScenPanel.NetException("游戏网络异常!", gameSocketNumber.GameSocket);
                        GameSetsBtnInfo.ReturnBtnOnClick();
                    end
                    HallScenPanel.restConnectCount = 0;
                    self.OnReConnnect = false;
                    self.isReconnect = false;
                end
        );
    end

    -- 游戏网络断开的处理
    local function close()
        local args = nil;
        if EventCallBackTable._19_NetException ~= nil then
            args = Event.Brocast(EventIndex.OnNetException .. gameSocketNumber.GameSocket, false);
        end
        if args == nil then
            args = false
        end

        rest();
        --if args == false then
        --    -- 游戏反馈了就不处理
        --    logError("yichang3---------------------")
        --    self.waitTransform.gameObject:SetActive(false);
        --    HallScenPanel.NetException("游戏网络异常!", gameSocketNumber.GameSocket);
        --else
        --    logError("不需要提示游戏网络异常");
        --    rest();
        --end
    end

    local function state(s)
        if tostring(s) == "Yes" then
            HallScenPanel.restConnectCount = 0;
            self.connectGameSuccess = true;
            self.startConnectGame = false;
            self.connectgameTimer = 7;
            local flag, session = networkMgr.DicSession:TryGetValue(gameSocketNumber.GameSocket, nil)
            logYellow("flag==" .. tostring(flag))
            if not flag then
                logYellow("游戏服务器网络关闭")
                Network.Close(gameSocketNumber.GameSocket)
            end
            if session ~= nil then
                if not session.run then
                    logYellow("游戏服务器网络关闭")
                    Network.Close(gameSocketNumber.GameSocket)
                end
            end

            self.isReconnect = true;
            callBack();
        else
            close();
        end
    end

    local function connect()
        local b = Network.State(gameSocketNumber.GameSocket);
        if b == true then
            callBack();
            return
        end
        log("准备建立游戏连接");
        --if LaunchModule.currentSceneName ~= "module02" then
        Network.Connect(self.gameip, self.gameport, gameSocketNumber.GameSocket, state, 5000, rest);
        self.startConnectGame = true;
        self.connectgameTimer = 7;
        --end
    end
    coroutine.start(connect);
end
--给大厅服务器发送心跳包
function HallScenPanel.CheckNetHall()
    if self.startCheckNetHall then
        return
    end
    self.startCheckNetHall = true;
    function f()
        local t = 8;
        while self.startCheckNetHall do
            coroutine.wait(t);
            -- 发送个定义的心跳给服务测试网络,发送失败就说明断网了
            local buffer = ByteBuffer.New();
            --error("发送个定义的心跳给服务测试网络");
            Network.Send(MH.MDM_3D_ASSIST, MH.SUB_3D_CS_CHECK_CLIENT_NETWORK, buffer, gameSocketNumber.HallSocket);
        end
    end
    coroutine.start(f)
end


--获取排行榜显示数量
function HallScenPanel.GetShowRankNum()

    local ShowRankNum = 100;
    --[[    local configer = AppConst.appInfoConfiger;
    if configer ~= nil then
        local baseConfiger = configer.RankNum;
        if baseConfiger ~= nil then ShowRankNum = tonumber(baseConfiger) or 100 end
    end--]]
    return ShowRankNum;
end

function HallScenPanel.GetImageAnima(trans)
    if trans == nil then
        return nil
    end
    local numberImage = trans:GetComponent("ImageAnima");
    if numberImage == nil then
        numberImage = trans.gameObject:AddComponent(typeof(ImageAnima));
    end
    local sprite = trans:GetComponent("Image");
    local spritename = nil;
    if sprite == nil then
        spritename = "NUMFLY";
    else
        spritename = sprite.sprite.name;
    end
    for i = 1, #self.NumDic do
        if string.find(spritename, self.NumDic[i].name) ~= nil then
            numberImage.lSprites = self.NumDic[i].lSprites;
        end
    end
    return numberImage;
end

function HallScenPanel.ChangeHead(faceId)
    SCPlayerInfo.faceID = faceId;
    transform:Find("Compose/HeadImg/Image/Image/Image"):GetComponent("Image").sprite = self.GetHeadIcon();
    if PersonalInfoSystem.PlayerHeadIMG ~= nil then
        PersonalInfoSystem.PlayerHeadIMG:GetComponent("Image").sprite = self.GetHeadIcon();
    end
end

function HallScenPanel.GetHeadIcon()
    if SCPlayerInfo ~= nil and SCPlayerInfo.faceID ~= nil then
        if self.headIcons == nil then
            --self.headIcons = LoadAsset("module02/Pool/headicons", "HeadIcons").transform;
            self.headIcons = LoadAsset("HallPackage", "HeadIcons").transform;
        end
        return self.headIcons:GetChild(SCPlayerInfo.faceID - 1):GetComponent("Image").sprite;
    end
end

function HallScenPanel.OnDestroy()
    Network.OnDestroy();
end

function HallScenPanel.LoadHeader(index, go)

end

function HallScenPanel.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end

function HallScenPanel.FormatNumberThousands(num)
    --对数字做千分位操作
    local function checknumber(value)
        return tonumber(value) or 0
    end
    local formatted = tostring(checknumber(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        print(formatted, k)
        if k == 0 then
            break
        end

    end
    return formatted
end

function HallScenPanel.ShowText(str)
    --展示tmp字体
    local arr = self.ToCharArray(str);
    local _str = "";
    for i = 1, #arr do
        _str = _str .. string.format("<sprite name=\"%s\" tint=1>", arr[i]);
    end
    return _str;
end