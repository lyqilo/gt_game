-- SlotBase.lua
-- Date
-- slot 主界面控制类 对应luaBehaviour
-- endregion
-- require "Slot/SlotTimer"
-- require "Slot/SlotExplainCtrl"
-- require "Slot/SlotMainImgAnimation"
-- require "Slot/SlotTitleCtrl"
-- require "Slot/SlotUserInfo"
SlotBase = {}

local slotBase = SlotBase;

local self = SlotBase;

local __luaBehaviour;

-------常量--------
-- 时间
local C_ROTATE_AGO_TIME = 4; -- 转动前动画时间

local C_ROTATE_ONE_TIME = 0.9; -- 转动图片一圈的时间

local C_JYMT_TIME = 6; -- 金玉满堂时间


local C_RESULTS_TIME = 0.5; -- 结算时间  总时间/总金币数 = 间隔变化时间  
local C_SUPER_RATE_RESULTS_TIME = 5; -- 超级倍率结算时间 

local C_SUPER_GOLD_ALL_TIME = 5; -- 超级彩金变化时间
local C_SUPER_GOLD_NOM_TICK_TIME = 1; -- 超级彩金普通变化时间
local C_SUPER_GOLD_TICK_TIME = 0.1; -- 超级彩金变化时间


local C_GOD_DOWN_TIME = 4; -- 财神降临动画播放时间

local C_GOD_AGAIN_MIN = 4; -- 最小重转财神个数
local C_GOD_AGAIN_MAX = 9; -- 最大重转财神个数
local C_GOD_SUPERGOLD = 10; -- 超级彩金财神个数

local C_ROTATE_BASE_COUNT = 2; -- 转动基本次数


local C_SMALL_GOD_COUNT = 4; -- 小财神个数

local C_SUPER_GOLD_RATE = 3000; -- 超级彩金倍率

local C_SUPER_RATE = 500; -- 超级倍率
local C_LEAST_CHIP = 100; -- 最小下注筹码
local iChipsNum = {};

local C_PLAY_ANIMATION = 1; -- 播放动画标志
local C_NOT_PLAY_ANIMATION = -1; -- 不播放动画标志

local C_GOD_IMG_POSX = 21.9; -- 金币图片 x轴初始偏移位置


---------Obj----------
local transform;

local traMainGold; -- 大财神图片

local traSubGold; -- 小财神图片

local traSubGoldPar;

local traImage; -- 游戏主图片

local traImgRotate; -- 转动的图片

local traAgainImg;

local traBetBox; -- 下注列表

local traSuperGold; -- 超级彩金

local traImgResult; -- 结算界面

local traResultGold; -- 结算金币

local traBtnStart; -- 开始按钮

local traBtnAutoOrStop; -- 自动或手动按钮

local traAutoCnt;

local traExplain; -- 提示面板


local traJYMT; -- 金玉满堂

local btnRes; -- 按钮资源

local jymtRes; -- 金玉满堂资源


local bLimitChip = 1;
local iLimitChip = 1000000000;

-------------变量-----------
self.mainImgRes = nil; -- 图片资源

self.objTime = nil; -- 定时器对象
self.btnTimer = nil; -- 按钮定时器对象

self.iGold = 0; -- 玩家金币
self.iCurrentChip = 0; -- 当前下注值
self.iCutChipIdx = 0;  -- 当前下注值索引
self.iGodDownScore = 0; -- 财神降临总金币

self.tabImg = {}; -- 所有图片
self.byLineType = {}; -- 线类型
self.byWealthGodNum = 0; -- 地主个数
self.byFreeNum = 0;  -- 免费次数
self.gameType = -1; -- 游戏类型  SlotDataStruct.enGameType.E_GAME_TYPE_NORMA
self.iWinScore = 0; -- 赢得总分

self.bChipState = false; -- 是否下注状态
self.bGodDown = false; -- 是否财神降临
self.bAuto = false; -- 自动模式
self.bPlayGame = false; -- 是否在游戏中
self.bSendGameStart = false; -- 是否发送了游戏开始
self.bBtnCallBack = false; -- 是否收到按钮定时回调

self.tabPlayAniImgPos = {}; -- 播放动画的图片

self.fGridHight = 0;

function SlotBase.init(obj, luaB)
    self = slotBase:New();
    _luaBehaviour = luaB;
    SlotBase.Begin(obj);
    -- _luaBehaviour = Util.AddComponent("LuaBehaviour", obj.gameObject);
    -- _luaBehaviour:SetLuaTab(self, "SlotBase");
    return self;
end

----构造函数
function SlotBase:New(o)
    local t = o or {};
    setmetatable(t, self);
    self.__index = self
    return t;
end

function SlotBase.Begin(obj)

    self.transform = obj.transform;
    log("tra name = " .. self.transform.name);
    self.objTime = SlotTimer:New();
    -- 定时器对象
    self.btnTimer = SlotTimer:New();

    traMainGold = self.transform:Find("Top/MainGod");
    traSubGold = self.transform:Find("Top/SubGod/Gods");
    traSubGoldPar = self.transform:Find("Top/SubGod/Bj/GoldDownPar");
    -- 财神降临粒子特效
    traImage = self.transform:Find("Centre/Image");
    -- 游戏住图片 父物体
    traRotImage = self.transform:Find("Centre/ImageRotate");
    -- 游戏住图片 父物体
    traAgainImg = self.transform:Find("Centre/ImageAgainGod");
    -- 游戏重转图片
    for i = 0, traImage.childCount - 1 do
        -- 初始化主图片
        local traCol = traImage:GetChild(i);
        for j = 0, traCol.childCount - 1 do
            local traItem = traCol:GetChild(j);
            local idx = tonumber(traItem.name) + 1;
            local obj = traItem:GetChild(traItem.childCount - 1);
            local imgThis = SlotMainImgAnimation:New();
            obj.name = obj.name .. "_panel";
            imgThis:Create(obj);
            self.tabImg[idx] = imgThis;
        end
    end

    traImgRotate = self.transform:Find("Centre/ImageRotate");
    -- 转动的图片
    traBetBox = self.transform:Find("ImageSetBetBox");
    -- 下注列表
    traBtnStart = self.transform:Find("ImageRightBottomBox/ButtonStart");
    -- 启动按钮
    traBtnAutoOrStop = self.transform:Find("ImageRightBottomBox/ButtonAutoOrStop");
    traAutoCnt = self.transform:Find("ImageRightBottomBox/ButtonAutoOrStop/AutoCnt"); --自动次数
    -- 自动或手动按钮
    traSuperGold = self.transform:Find("ImageSuperGoldBg/LayoutSuperGold");
    -- 超级彩金金币数字
    traImgResult = self.transform:Find("ImageResult");
    traResultGold = traImgResult.transform:Find("LayoutResulteGold");
    -- 结算数字
    traExplain = self.transform:Find("ImageExplain");
    traExplain:GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);

    if (not _luaBehaviour) then
        log("-----------_luaBehaviour is null");
    end
    SlotExplainCtrl.Init(traExplain, _luaBehaviour);
    -- 初始化说明面板
    SlotBase.AddBtnOnClick();

    -- btnRes = LoadAsset(SlotResourcesName.dbResNameStr, 'BtnRes');
    btnRes = Game01Panel.Pool("BtnRes");
    -- SlotUserInfo.Init(self.transform:Find("UserInfo"), _luaBehaviour);
    --    if(not mainImgRes) then
    --        mainImgRes = ResManager:LoadAsset(SlotResourcesName.dbResNameStr, 'MainImg'); --住图片资源  test
    --    end
    self.tempChangeGold = 0;
end

-- 添加按钮响应事件
function SlotBase.AddBtnOnClick()

    -- local traButtonBet = self.transform:Find("ImageLeftBottomBox/ImageAllChip/ButtonBet");  废弃
    -- _luaBehaviour:AddClick(traButtonBet.gameObject, SlotBase.OnClickShowBetBtn); --添加显示下注表按钮事件
    --    for i = 0, (traBetBox.childCount - 1) do 废弃
    --        _luaBehaviour:AddClick(traBetBox.transform:GetChild(i).gameObject, SlotBase.OnClickBetBtn); --添加下注按钮响应事件
    --    end
    local traBtns = self.transform:Find("ImageLeftBottomBox/Btns");
    for i = 0, (traBtns.childCount - 1) do
        _luaBehaviour:AddClick(traBtns.transform:GetChild(i).gameObject, SlotBase.OnClickChangeChipBgn);
        -- 添加下注按钮响应事件
    end


    -- _luaBehaviour:AddClick(traBtnStart.gameObject, SlotBase.OnClickStartBtn); --启动按钮响应事件
    -- _luaBehaviour:AddClick(traBtnAutoOrStop.gameObject, SlotBase.OnClickAutoOrStopBtn); --自动手动切换按钮响应事件
    -- local comEveTri = traBtnAutoOrStop.transform:GetComponent("EventTriggerListener");
    local comEveTri = Util.AddComponent("EventTriggerListener", traBtnAutoOrStop.gameObject);
    comEveTri.onDown = SlotBase.OnClickDownStartBtn;
    comEveTri.onUp = SlotBase.OnClickUpStartBtn;

    local traBtnAutoCnt = traAutoCnt:Find("BtnAutoCnt");
    for i = 0, traBtnAutoCnt.childCount - 1 do
        _luaBehaviour:AddClick(traBtnAutoCnt:GetChild(i).gameObject, SlotBase.OnClickAutoCntBtn);  --说明按钮事件
    end
    local traBtnExplain = self.transform:Find("ButtonExplain");
    _luaBehaviour:AddClick(traBtnExplain.gameObject, SlotBase.OnClickExplainBtn);
    -- 说明按钮事件
end



-- 初始化变量
function SlotBase.InitGameData()

    self.bChipState = false;
    self.bPlayGame = true;
    self.bSendGameStart = false;
    -- self.iGodDownScore = 0; --财神降临总金币
    self.byLineType = {};
    -- 线类型
    self.byWealthGodNum = 0;
    -- 地主个数
    self.byFreeNum = 0;
    -- 免费次数
    self.gameType = -1;
    self.iWinScore = 0;
    -- 赢得总分
    self.tabPlayAniImgPos = {};
    -- 播放动画的图片
    if (self.tempChangeGold and self.tempChangeGold <= 1) then
        traImgResult.gameObject:SetActive(false);
    end
    -- 重传时金币不消失
    SlotBase.PlayImgAnimation(false);
    SlotBase.SetLine(false);
    -- self.transform:Find("PlayerGold/GoldAnimation").gameObject:SetActive(false);
end

-- function SlotBase:FixedUpdate()
--    SlotTimer:timer(Time.fixedDeltaTime);
-- end
function SlotBase.Update()

    if (not self) then
        return ;
    end

    self.objTime:timer(Time.deltaTime);
    self.btnTimer:timer(Time.deltaTime);
    if (self.timerSuperGold) then
        self.timerSuperGold:timer(Time.deltaTime);
    end
    if (self.timeFlash) then
        self.timeFlash:timer(Time.deltaTime);
    end

    if (self.bChipState and not self.bPlayGame) then
        if self.bAuto then
            if toInt64(self.iCurrentChip * SlotDataStruct.D_LINE_COUNT) <= toInt64(self.iGold) then
                SlotBase.SendGameStart();
            else
                if (toInt64(self.iCurrentChip * SlotDataStruct.D_LINE_COUNT) > toInt64(self.iGold)) then
                    -- 金币不足
                    log("SendGameStart 下注金币不足！");
                    -- SlotTitleCtrl.ShowTitle(self.transform, "金币不足！");
                    MessageBox.CreatGeneralTipsPanel("下注金币不足！", nil);
                    traBtnAutoOrStop.transform:GetComponent('Image').sprite = btnRes.transform:Find("BtnZD"):GetComponent('Image').sprite;
                    self.bAuto = false;
                    self.bBtnCallBack = false;
                    return ;
                end
            end
        end

        if (self.bGodDown) then
            SlotBase.SendGameStart();
        end

    end

end

-- 初始化桌子
-- tabGameScen = {iBet; byFreeNumber; byChipList; iRateList; }
function SlotBase.InitTable(tabGameScen)
    log("init table ");

    self.bChipState = true;
    self.iCurrentChip = tabGameScen.iBet;
    self.iCutChipIdx = 1;
    self.byFreeNum = tabGameScen.byFreeNumber;
    logYellow("ibet = " .. self.iCurrentChip);
    SlotBase.InitBetBox(tabGameScen.byChipList, tabGameScen.iBet);
    -- 当前下注值
    -- SlotBase.SuperGoldChange();
    bLimitChip = tabGameScen.bLimitChip;
    iLimitChip = tabGameScen.iLimitChip;

    if (self.byFreeNum <= 0) then
        log("init table return");
        return ;
    end
    log("Free num == " .. self.byFreeNum);
    SlotBase.GodDownBorderFlash(true);

    self.iGodDownScore = tabGameScen.iGodScore;

    -- traMainGold.transform:Find("ImageGold").gameObject:SetActive(false);
    SlotBase.SetFreeNumber(true, self.byFreeNum);

    --    for i = 0, C_SMALL_GOD_COUNT - 1 do
    --        traSubGold.transform:GetChild(i).gameObject:SetActive(true);
    --    end
    self.bGodDown = true;

    log("init table end");

end


-- 初始化下注列表
function SlotBase.InitBetBox(tabChipList, iBet)

    C_LEAST_CHIP = tabChipList[1];
    -- 最下下注筹码
    for i = 1, #tabChipList do
        iChipsNum[i] = tabChipList[i];
    end

    self.transform:Find("ImageLeftBottomBox/ImageAllChip/ButtonBet/Text"):GetComponent('Text').text = SlotDataStruct.D_LINE_COUNT .. "x" .. iBet .. "";

    local iNum = iBet * SlotDataStruct.D_LINE_COUNT;
    local traTarget = self.transform:Find("ImageLeftBottomBox/ImageAllChip/LayoutAllChip");
    SlotBase.showNumberImage(iNum, traTarget, Game01Panel.allChipNumRes);

    -- SlotBase.showNumberImage(iBet*C_SUPER_GOLD_RATE, traSuperGold, Game01Panel.goldNumRes); --设置超级彩金
end

function SlotBase.GetPlayerGold(iGold)
    self.iGold = tostring(iGold);
end

-- 设置金币
function SlotBase.SetGold(gold)
    log("设置金币：" .. gold);
    self.iGold = tostring(gold);
    local traGold = self.transform:Find("PlayerGold/LayoutGold");
    SlotBase.showNumberImage(self.iGold, traGold, Game01Panel.goldNumRes);
end


-- 下注状态
function SlotBase.ChipState()
    log("is chip state");
    self.bChipState = true;
end

function SlotBase.SetSuperGold(iNum)
    SlotBase.showNumberImage(math.floor(iNum), traSuperGold, Game01Panel.superGoldNumRes);
end

-- 发送游戏启动
function SlotBase.SendGameStart()

    if (self.bSendGameStart) then
        return ;
    end

    SlotBase.ShowBetBtn(false);

    if (toInt64(self.iCurrentChip * SlotDataStruct.D_LINE_COUNT) > toInt64(self.iGold) and not bAgainRotate) then
        --金币不足
        logBlue("SendGameStart 下注金币不足！");
        MessageBox.CreatGeneralTipsPanel("下注金币不足！");
        --SlotTitleCtrl.ShowTitle(self.transform, "金币不足！");
        self.bSendGameStart = false;
        self.bAgainRotate = false;
        return ;
    end
    if self.byFreeNum <= 0 then
        local traGold = self.transform:Find("PlayerGold/LayoutGold");
        SlotBase.showNumberImage(self.iGold - self.iCurrentChip * SlotDataStruct.D_LINE_COUNT, traGold, Game01Panel.goldNumRes);
    end
    SlotGameNet.SendUserReady();

    if self.iCurrentChip==0 then
        self.iCurrentChip=iChipsNum[1]
    end
    log("send game start：" .. self.iCurrentChip);
    
    local Data = { [1] = self.iCurrentChip, }
    local buffer = SetC2SInfo(SlotDataStruct.CMD_CS_GAME_START, Data);
    Network.Send(MH.MDM_GF_GAME, SlotDataStruct.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
    SlotGameNet.isreqStart=false
    self.bSendGameStart = true;
end


-- 普通时刻超级彩金变化 废弃 
function SlotBase.SuperGoldChange(bStop)

    if (bStop) then
        -- 停止
        self.timerSuperGold:setTimer(0, not bStop, SlotTimer.slotTimerType.timint, 0, nil, nil);
        self.timerSuperGold = nil;
    else
        if (not self.timerSuperGold) then
            self.timerSuperGold = SlotTimer:New();
        end
        SlotBase.SuperGoldTickCallBack();
        local tab2 = { fun = SlotBase.SuperGoldChangeEndCallBack; args = SlotBase; }
        self.timerSuperGold:setTimer(C_SUPER_GOLD_NOM_TICK_TIME, not bStop, SlotTimer.slotTimerType.timint, 0, nil, tab2);
    end

end



-- 游戏开始
-- tabResultsInfo = {byImg,byLineType,byWealthGodNum,byFreeNum,gameType,dwWinScore,}
function SlotBase.GameStart(tabResultsInfo, bAgainRotate)
    if (bAgainRotate) then
        log("is ------------ bAgainRotate ");
    end
    if not bAgainRotate and self.bAgainRotate then
        SlotBase.SetGold(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD));
    end
    SlotBase.InitGameData();
    self.byLineType = tabResultsInfo.byLineType;
    self.byWealthGodNum = tabResultsInfo.byWealthGodNum;
    self.byFreeNum = tabResultsInfo.byFreeNum;
    self.gameType = tabResultsInfo.gameType;
    self.iWinScore = tabResultsInfo.dwWinScore;
    self.bAgainRotate = bAgainRotate;
    bLimitChip = tabResultsInfo.bLimitChip;
    iLimitChip = tabResultsInfo.iLimitChip;
    -- if bAgainRotate then
    --     local useGold = gameData.GetProp(enum_Prop_Id.E_PROP_GOLD) - (self.iCurrentChip * SlotDataStruct.D_LINE_COUNT);
    --     SlotBase.SetGold(useGold);
    --     log("byWealthGodNum========== " .. self.byWealthGodNum .. "  UserGold:" .. useGold);
    -- end
    SlotBase.PlayMusic(SlotResourcesName.go);

    if (not self.mainImgRes) then
        self.mainImgRes = Game01Panel.Pool("MainImg");
    end
    for i = 1, #tabResultsInfo.byImg do
        -- 初始化图片
        self.tabImg[i]:SetName(tabResultsInfo.byImg[i] .. "");
    end
    for i = 1, SlotDataStruct.D_ALL_COUNT do
        -- 初始化播放图片动画位置表
        table.insert(self.tabPlayAniImgPos, C_NOT_PLAY_ANIMATION);
    end
    for i = 1, #self.byLineType do
        -- 获取播放动画的图片位置
        for j = 1, #self.byLineType[i] do
            if (C_PLAY_ANIMATION ~= self.byLineType[i][j]) then
                break ;
            end
            local pos = SlotDataStruct.C_LINE_LIST_TYPE[i][j];
            self.tabPlayAniImgPos[pos] = C_PLAY_ANIMATION;
        end
    end
    if (bAgainRotate) then
        -- 重转
        SlotBase.AgainRotate();
        return ;
    end
    if (self.bGodDown) then
        self.SetFreeNumber(true, self.byFreeNum);
    end
    if (SlotDataStruct.enGameType.E_GAME_TYPE_NORMAL == self.gameType) then
        -- 普通
        for i = 0, SlotDataStruct.D_COL_COUNT - 1 do
            SlotBase.PlayImgRotate(i);
        end
    elseif (SlotDataStruct.enGameType.E_GAME_TYPE_PBSH == self.gameType) then
        -- 蓬荜生辉
        SlotBase.IsPBSH();
    elseif (SlotDataStruct.enGameType.E_GAME_TYPE_JYMT == self.gameType) then
        -- 金玉满堂
        SlotBase.IsJYMT();
    else
        log("无游戏类型 type = " .. self.gameType);
    end
    SlotGameNet.isreqStart=true;
end

function SlotBase.AgainRotate()
    for i = 0, SlotDataStruct.D_COL_COUNT - 1 do
        SlotBase.PlayImgRotate(i);
    end
end

-- 碰壁生辉
function SlotBase.IsPBSH()
    self.PlayGameTypeAnimation(true, "ImagePBSH");
    local tab1 = nil;
    local tab2 = { fun = SlotBase.rotateAgoAnimationEndCallBack; args = SlotBase; }
    self.objTime:setTimer(C_ROTATE_AGO_TIME, true, SlotTimer.slotTimerType.timint, 0, tab1, tab2);
end

-- 金玉满堂
function SlotBase.IsJYMT()
    self.PlayGameTypeAnimation(true, "ImageJYMT");
    local tab1 = nil;
    local tab2 = { fun = SlotBase.rotateAgoAnimationEndCallBack; args = SlotBase; }
    self.objTime:setTimer(C_ROTATE_AGO_TIME, true, SlotTimer.slotTimerType.timint, 0, tab1, tab2);
end

-- 播放游戏类型动画
function SlotBase.PlayGameTypeAnimation(bShow, sTypeName)
    local traImageGoldDown = traMainGold.transform:Find("ImageGoldDown");
    traImageGoldDown.gameObject:SetActive(bShow);
    if (not bShow) then
        return ;
    end
    for i = 0, traImageGoldDown.childCount - 1 do
        local traGodDownChild = traImageGoldDown:GetChild(i);
        if ("ImageGold" ~= traGodDownChild.name) then
            if (sTypeName == traGodDownChild.name) then
                SlotBase.TitleMove(traGodDownChild, true);
            else
                SlotBase.TitleMove(traGodDownChild, false);
            end
        end
    end

end

function SlotBase.TitleMove(tra, bShow)

    tra.gameObject:SetActive(bShow);
    if (not bShow) then
        return ;
    end

    tra.localPosition = Vector3.New(tra.localPosition.x, 500, tra.localPosition.z);

    tra:DOLocalMoveY(0, C_ROTATE_AGO_TIME / 5, false);

end

-- 设置财神底板
function SlotBase.SetGodImgBox(iImgId, traGrid)

    local bGod = true;
    if (not tonumber(iImgId)) then
        bGod = false;
    end
    if (SlotDataStruct.enGameImage.E_WEALTH_GOD_IMG ~= iImgId) then
        bGod = false;
    end
    local traBox = traGrid:Find("ImageGodBox");

    if (traBox or bGod) then

        -- local resGodBox = LoadAsset(SlotResourcesName.dbResNameStr, 'GodBoxRes');
        local resGodBox = Game01Panel.Pool("GodBoxRes");
        local iChildIdx = 0;
        if (SlotDataStruct.enGameType.E_GAME_TYPE_PBSH == self.gameType or -- 蓬荜生辉
                SlotDataStruct.enGameType.E_GAME_TYPE_JYMT == self.gameType) then
            -- 金玉满堂
            iChildIdx = 1;
        end
        local resGoldImage = resGodBox.transform:GetChild(iChildIdx)

        if (traBox) then
            traBox.gameObject:SetActive(bGod);
            traBox.transform:GetComponent('Image').sprite = resGoldImage.transform:GetComponent('Image').sprite;
        elseif (bGod) then
            traBox = Game01Panel.CreateGameObject(resGoldImage, "ImageGodBox", traGrid).transform;
            traBox.transform:SetSiblingIndex(0);
            traBox.gameObject:SetActive(bGod);
        end
    end

end

-- 设置单列图片
function SlotBase.SetOneColImg(traCol, traRotCol, iColNum)

    local iGrid = iColNum;
    local strImgId = "0";

    local iEnd = traRotCol.childCount - 1;

    local iBeginId = SlotDataStruct.enGameImage.E_WEALTH_GOD_IMG;
    local iEndId = SlotDataStruct.enGameImage.E_COPPER_IMG;

    for i = 0, iEnd do

        local traRotGrid = traRotCol.transform:GetChild(i);
        local traRotItem = traRotGrid:GetChild(traRotGrid.childCount - 1);

        if (i < SlotDataStruct.D_ROW_COUNT) then

            local traGrid = traCol.transform:GetChild(i);
            local traItem = traGrid:GetChild(traGrid.childCount - 1);

            Game01Panel.SetImgSprite(traRotItem, traItem);
            traRotItem.name = traItem.name;

        else
            strImgId = math.random(iBeginId, iEndId);
            SlotBase.SetGodImgBox(strImgId, traRotGrid);
            traRotItem.name = strImgId .. "";
            Game01Panel.SetImgSprite(traRotItem, self.mainImgRes, traRotItem.name);
        end

        SlotBase.SetGodImgBox(tonumber(traRotItem.name), traRotGrid);

    end

end


-- 创建转动格子
function SlotBase.CreateRotGridImg(traRotCol, iColNum, iAllCol, traCreateRes)


    local count = traRotCol.transform.childCount + iAllCol;
    -- (iColNum + 1) * iAllCol;
    local traBaseGrid = traRotCol.transform:GetChild(0);
    local ve3Pos = traBaseGrid.localPosition;

    local ve3ListItemPos = traRotCol.transform:GetChild(1).localPosition;
    local fHight = ve3Pos.y - ve3ListItemPos.y;

    traCreateRes = traCreateRes or traBaseGrid;
    for i = 1, count do
        local objGrid = Game01Panel.CreateGameObject(traCreateRes, i .. "", traRotCol);
        objGrid.transform:SetSiblingIndex(0);
        ve3Pos.y = ve3Pos.y + fHight;
        objGrid.transform.localPosition = ve3Pos;
        ve3Pos = objGrid.transform.localPosition;
    end

    return fHight;
end

-- 图片转动
-- index 转动列 下标
function slotBase.PlayImgRotate(index)

    local traCol = traImage:GetChild(index);
    local traRotCol = traRotImage:GetChild(index);

    traCol.gameObject:SetActive(false);

    if (traRotCol.childCount <= SlotDataStruct.D_ROW_COUNT) then
        log("创建转动格子。。。。");
        self.fGridHight = SlotBase.CreateRotGridImg(traRotCol, index + 1, SlotDataStruct.D_ROW_COUNT * 2);
        -- self.fGridHight = self.fGridHight + 6;
    end

    for i = 0, traCol.childCount - 1 do

        local traTempImg = traCol.transform:GetChild(i):GetChild(traCol.transform:GetChild(i).childCount - 1);
        local sImgId = traTempImg.name;
        local imgCom = traTempImg.transform:GetComponent('Image');
        imgCom.sprite = self.mainImgRes.transform:Find(sImgId):GetComponent('Image').sprite;
        SlotBase.SetGodImgBox(tonumber(sImgId), traCol.transform:GetChild(i));

        imgCom:SetNativeSize();

    end

    SlotBase.SetOneColImg(traCol, traRotCol, index);
    local moveTra = traImgRotate:GetChild(index);
    local fMoveDes = traRotCol.childCount * self.fGridHight - 2 * self.fGridHight;
    local endPosY = traRotCol.localPosition.y - fMoveDes;
    endPosY = fMoveDes;
    local dotween = moveTra.transform:DOLocalMoveY(-fMoveDes, C_ROTATE_ONE_TIME, false);
    local loop = index + C_ROTATE_BASE_COUNT;

    if ((self.bGodDown or SlotDataStruct.enGameType.E_GAME_TYPE_PBSH == self.gameType) and index ~= 0) then
        loop = C_ROTATE_BASE_COUNT * (index + 1);
    end

    moveTra.gameObject:SetActive(true);

    dotween:SetEase(DG.Tweening.Ease.Linear):SetLoops(loop);

    dotween:OnComplete(function()

        ---------------------------转动音效-----------------------------
        local bHaveGod = false;
        local sMusicName = "";
        for i = 0, traImage:GetChild(index).childCount - 1 do
            local traItem = traImage:GetChild(index):GetChild(i);
            if (SlotDataStruct.enGameImage.E_WEALTH_GOD_IMG == tonumber(traItem:GetChild(traItem.childCount - 1).name)) then
                bHaveGod = true;
                break ;
            end

        end

        if (bHaveGod) then
            sMusicName = SlotResourcesName.godStop;
        else
            sMusicName = SlotResourcesName.rateaStop;
        end

        SlotBase.PlayMusic(sMusicName);
        -------------------------------------------------------------
        traImage:GetChild(index).gameObject:SetActive(true);
        dotween:Pause():Rewind(true);
        moveTra.gameObject:SetActive(false);
        -- log("end idx = " .. index);
        if (SlotDataStruct.D_COL_COUNT - 1 == index) then
            -- 全部结束进行结算
            SlotBase.GameResult();
        end

    end);

end







-- 游戏结算
function SlotBase.GameResult()

    local allTime;
    local t;
    local tempNum = 1;
    error("win score = " .. self.iWinScore);
    -- if(self.byWealthGodNum >= C_GOD_SUPERGOLD or self.iWinScore <= 0) then --超级彩金 或者没中奖
    if (self.iWinScore <= 0) then
        t = -1;
        allTime = 0;
    else
        if (self.byWealthGodNum >= C_GOD_SUPERGOLD) then
            self.iWinScore = self.iWinScore * (self.iCutChipIdx / SlotDataStruct.CHIPS_LIST_COUNT);
            self.iWinScore = math.floor(self.iWinScore);
            log("idx = " .. self.iCutChipIdx .. "  超级彩金 分数打折 = " .. self.iWinScore);
        end
        allTime = C_RESULTS_TIME;
        if (self.iWinScore / self.iCurrentChip >= C_SUPER_RATE) then
            allTime = C_SUPER_RATE_RESULTS_TIME;
        end
        traImgResult.gameObject:SetActive(true);
        -- if (self.tempChangeGold <= 1) then
        --     if (1 == self.iWinScore) then
        --         self.tempChangeGold = 1;
        --     else
        --         self.tempChangeGold = 0;
        --     end
        -- end
        SlotBase.showNumberImage(self.iWinScore, traResultGold, Game01Panel.bigNumRes);
        t = allTime / self.iWinScore;
        tempNum = 2;
        if (t <= 0.02) then
            t = 0.02;
            local eachMSChange = self.iWinScore / (allTime * 1000);
            local eachT = eachMSChange * (t * 1000);
            tempNum = math.ceil(eachT);
        end
        SlotBase.PlayMusic(SlotResourcesName.line);
        self.comSource = SlotBase.PlayMusic(SlotResourcesName.downScore);
    end
    if allTime == 0 then
        allTime = 0.5;
    end
    SlotBase.PlayImgAnimation(true);
    SlotBase.ShowLine();
    log("时间：" .. allTime .. "  " .. tempNum .. "   " .. t);
    local tab1 = { fun = SlotBase.ResultGoldTickCallBack; args = tempNum; }
    local tab2 = { fun = SlotBase.ResultGoldEndCalBack; args = SlotBase; }
    self.objTime:setTimer(allTime, true, SlotTimer.slotTimerType.tick, t, tab1, tab2);
    if (self.byFreeNum > 0) then
        SlotBase.PayAgainRotAnim(false);
        log("有财神");
        self.GodDown()
    end
    if (self.bGodDown) then
        log("======================免费===================")
    end
end

-- 超级倍率
function SlotBase.SuperRate(idx, traSuperRate)

    -- local traSuperRate = traImgResult.transform:Find("ImageSuperRate");
    local traSupChild = traSuperRate.transform:GetChild(idx);
    local dotween = traSupChild.transform:DOScale(Vector3.New(1, 1, 1), 0.5):SetEase(DG.Tweening.Ease.Linear);

    dotween:OnComplete(function()

        local sibIdx = traSupChild.transform:GetSiblingIndex() + 1;

        if (sibIdx < traSuperRate.childCount) then
            -- traSupChild = traSuperRate.transform:GetChild(sibIdx);
            SlotBase.SuperRate(sibIdx, traSuperRate);
            -- dotween:Pause():Rewind(true);
        else
            traSuperRate.transform:GetChild(0).localScale = Vector3.One();
        end


    end);
end


-- 播放图片动画
function SlotBase.PlayImgAnimation(bPlay)

    if (not bPlay) then

        for i = 1, #self.tabImg do
            self.tabImg[i]:PlayAnimation(bPlay);
        end

        return ;
    end

    log("god count is = " .. self.byWealthGodNum);
    for i = 1, #self.tabPlayAniImgPos do

        if (self.bGodDown or self.byWealthGodNum >= C_GOD_AGAIN_MIN) then

            if (SlotDataStruct.enGameImage.E_WEALTH_GOD_IMG == tonumber(self.tabImg[i].name)) then
                self.tabImg[i]:PlayAnimation(bPlay);
            end
        end

        if (C_PLAY_ANIMATION == self.tabPlayAniImgPos[i]) then
            -- 播放动画的img
            self.tabImg[i]:PlayAnimation(bPlay);
        end

    end

end

-- 播放重转时的动画
function SlotBase.PayAgainRotAnim(bPlay)

    local obj;

    if (not bPlay) then
        for i = 0, traAgainImg.childCount - 1 do
            obj = traAgainImg:GetChild(i).gameObject;
            if (obj.activeSelf) then
                obj:SetActive(false)
            end
        end
        return ;
    end

    for i = 1, #self.tabPlayAniImgPos do
        if (self.byWealthGodNum >= C_GOD_AGAIN_MIN) then
            if (SlotDataStruct.enGameImage.E_WEALTH_GOD_IMG == tonumber(self.tabImg[i].name)) then
                obj = traAgainImg:GetChild(i - 1).gameObject;
                if (not obj.activeSelf) then
                    obj:SetActive(true)
                end
            end
        end
    end

    SlotBase.SendGameStart();

end

-- 财神降临
function SlotBase.GodDown()

    if (not self.bGodDown) then
        self.PlayGameTypeAnimation(true, "Image");
        Game01Panel.PlayBjMusic(SlotResourcesName.godDownBGM);
        SlotBase.GodDownBorderFlash(true);
        -- 播放闪烁动画
    end

    local allTime = C_GOD_DOWN_TIME;
    for i = 0, traSubGold.childCount - 1 do
        if (self.byWealthGodNum <= 0) then
            allTime = 0;
            break ;
        end
        local traGod = traSubGold.transform:GetChild(i);
        local strGodNum = string.split(traGod.name, "_");
        if (tonumber(strGodNum[2]) == self.byWealthGodNum) then
            --           traGod:GetComponent('Image').enabled = true;
            --           traGod:Find("ImageGod"):GetComponent('Animator').enabled = true;
            self.PlayerTopGodAnim(traGod, true);
            break ;
        end

    end

    local tab2 = { fun = SlotBase.GodDownEndCalBack; args = SlotBase; }
    self.objTime:setTimer(allTime, true, SlotTimer.slotTimerType.timint, 0, nil, tab2);

end
function SlotBase.TopGodChangeScale(tra, bShow)
    if (bShow) then
        self.doScale = tra:DOScale(Vector3.New(1.2, 1.2, 1.2), 0.5):SetLoops(-1);
    else
        if (self.doScale) then
            self.doScale:Pause():Rewind(true);
            self.doScale = nil;
        end
    end
end
-- 播放上端财神动画
function SlotBase.PlayerTopGodAnim(traGod, bPlay, bGodDownEnd)

    -- log("top god!!!!");
    if (not traGod) then
        log("god transform is null");
        return ;
    end

    if (bPlay) then
        if (not self.traBegingGod) then
            self.traBegingGod = traGod.transform;
        end
        --        traGod:GetComponent('Image').enabled = true;
        --        traGod:Find("ImageGod"):GetComponent('Animator').enabled = true;
        --traSubGoldPar:SetParent(traGod);
        --traSubGoldPar.localPosition = Vector3.New(0, 0, 0);
        --traSubGoldPar.gameObject:SetActive(bPlay);
        SlotBase.TopGodChangeScale(traGod, bPlay);
    else
        -- traGod:GetComponent('Image').enabled = false;
        if (not self.traBegingGod) then
            return ;
        end
        if (self.traBegingGod.name == traGod.name) then
            -- 触发财神降临的财神，财神阶段结束再结束动画
            if (bGodDownEnd) then
                -- traGod:Find("ImageGod"):GetComponent('Animator').enabled = false;
                -- traGod:Find("ImageGod"):GetComponent('Image').sprite = self.mainImgRes.transform:Find("TopGod"):GetComponent('Image').sprite;
                --traGod:GetChild(0).gameObject:SetActive(false);
                SlotBase.TopGodChangeScale(traGod, false);
                self.traBegingGod = nil;
            end
            -- else
            -- traGod:Find("ImageGod"):GetComponent('Animator').enabled = false;
            -- traGod:Find("ImageGod"):GetComponent('Image').sprite = self.mainImgRes.transform:Find("TopGod"):GetComponent('Image').sprite;
        end
    end

end

-- 财神降临阶段 边框闪烁 废弃
function SlotBase.GodDownBorderFlash(bFlash)
    --if (true) then return; end
    log("开始财神免费");
    if (bFlash) then
        log("开始财神免费1");
        self.timeFlash = SlotTimer:New();
        -- 定时器对象
        local tab1 = { fun = SlotBase.BorderFlashTickCallBack; args = SlotBase; }
        self.timeFlash:setTimer(200, bFlash, SlotTimer.slotTimerType.tick, 0.5, tab1, nil);

    else
        log("开始财神免费2");
        self.timeFlash:setTimer(0, bFlash, SlotTimer.slotTimerType.timint, 0, nil, nil);
        self.timeFlash = nil;
    end
    self.transform:Find("Centre/ImageGodDownBox").gameObject:SetActive(bFlash);

end

-- 财神降临结束
function SlotBase.GodDownEnd()

    --    for i = 0, C_SMALL_GOD_COUNT - 1 do
    --        traSubGold.transform:GetChild(i).gameObject:SetActive(false);
    --    end
    SlotBase.SetFreeNumber(false, -1);
    -- traMainGold.transform:Find("ImageFree").gameObject:SetActive(false);
    local traGodDownEnd = self.transform:Find("GodDownTitle");

    traGodDownEnd.gameObject:SetActive(true);

    local traGodDownNum = traGodDownEnd:Find("ImageGodDwonEnd");

    SlotBase.showNumberImage(self.iGodDownScore, traGodDownNum, Game01Panel.godDownEndNumRes);

    self.iGodDownScore = 0;

    self.bGodDown = false;

    self.PlayerTopGodAnim(self.traBegingGod, false, true);
    -- 结束上方财神动画
    SlotBase.GodDownBorderFlash(false);
    -- 结束闪烁动画
    local tab2 = { fun = SlotBase.GodDownEndEndCalBack; args = SlotBase; }
    self.objTime:setTimer(C_GOD_DOWN_TIME, true, SlotTimer.slotTimerType.timint, 0, nil, tab2);

    Game01Panel.PlayBjMusic(SlotResourcesName.bgm);

end

-- 超级彩金 废弃
function SlotBase.IsSuperGold()

    SlotBase.PlayMusic(SlotResourcesName.superGold);

    -- SlotBase.SuperGoldChange(true); -- 停止超级彩金普通时刻的变化
    -- local superGoldAnimRes = LoadAsset(SlotResourcesName.dbAnimationStr, 'ImageSuperGoldAnim'); --动画资源
    local superGoldAnimRes = Game01Panel.Pool("ImageSuperGoldAnim");
    local objSuperGoldAnim = newobject(superGoldAnimRes);
    objSuperGoldAnim.transform:SetParent(traSuperGold.parent);
    objSuperGoldAnim.name = "ImageSuperGoldAnim";
    objSuperGoldAnim.transform.localScale = Vector3.one;
    objSuperGoldAnim.transform.localPosition = Vector3.New(11, 26, 0);
    objSuperGoldAnim.gameObject:SetActive(true);

    local tab1 = { fun = SlotBase.SuperGoldTickCallBack; args = SlotBase; }

    local tab2 = { fun = SlotBase.SuperGoldEndCallBack; args = SlotBase; }

    self.objTime:setTimer(C_SUPER_GOLD_ALL_TIME, true, SlotTimer.slotTimerType.tick, C_SUPER_GOLD_TICK_TIME, tab1, tab2);

end

-- 显示线
function SlotBase.ShowLine()


    local traPoint = self.transform:Find("Centre/objLine/Point");

    SlotBase.SetLinePointPos(traPoint);

    for i = 1, #self.byLineType do

        for j = 1, #self.byLineType[i] do

            if (C_PLAY_ANIMATION ~= self.byLineType[i][1] or j + 1 > #self.byLineType[i]) then
                break ;
            end

            local iCurrentPos = SlotDataStruct.C_LINE_LIST_TYPE[i][j];
            local iNextPos = SlotDataStruct.C_LINE_LIST_TYPE[i][j + 1];
            local iDirection = iCurrentPos - iNextPos;

            local traCurrentPoint = traPoint:GetChild(iCurrentPos - 1);
            local traNextPoint = traPoint:GetChild(iNextPos - 1);

            SlotBase.SetLine(true, traCurrentPoint, traNextPoint, iDirection);

        end

    end

end

-- 设置线
-- bShow 是否显示, traCurrentPoint 当前点, traNextPoint 下个点, iDirection 线的方向 -1直线 <0下斜线 >0上斜线
function SlotBase.SetLine(bShow, traCurrentPoint, traNextPoint, iDirection)

    local traLineBase = self.transform:Find("Centre/objLine/Line");

    if (not bShow) then
        for i = 0, traLineBase.childCount - 1 do
            if ("ImageLine" ~= traLineBase:GetChild(i).name) then
                destroy(traLineBase:GetChild(i).gameObject);
            end
        end
        return ;
    end

    local traLineClon = traLineBase.transform:Find("ImageLine");
    local traLine = newobject(traLineClon).transform;
    traLine:SetParent(traLineClon.parent);
    traLine.localScale = Vector3.one;
    traLine.gameObject:SetActive(true);

    -- 设置长度--
    local iDis = Vector3.Distance(traCurrentPoint.transform.localPosition, traNextPoint.transform.localPosition);
    -- 距离
    local comRectTransform = traLine:GetComponent('RectTransform');
    local ve2Size = Vector2.New(iDis, comRectTransform.sizeDelta.y);
    comRectTransform.sizeDelta = ve2Size;

    -- 设置位置--
    local ve3Pos = (traCurrentPoint.transform.position + traNextPoint.transform.position) / 2;
    traLine.transform.position = ve3Pos;

    -- 设置角度--
    if (-1 ~= iDirection) then

        local fYhight = traCurrentPoint.transform.localPosition.y - traNextPoint.transform.localPosition.y;
        local fAngel = math.asin(fYhight / iDis) * Mathf.Rad2Deg * -1;
        -- math.rad2Deg
        -- log("angle " .. fAngel);
        traLine.transform:Rotate(0, 0, fAngel);

    end

end


-- 设置连线的点
function SlotBase.SetLinePointPos(traPointBase)

    if (traPointBase.childCount > 1) then
        return ;
    end

    for i = 1, #self.tabImg do

        local traPoint;
        if (i > traPointBase.childCount) then
            traPoint = newobject(traPointBase:GetChild(0));
            traPoint.transform:SetParent(traPointBase);
            traPoint.name = "pos" .. i;
            traPoint.transform.localScale = Vector3.one;
        else
            traPoint = traPointBase:GetChild(i - 1);
        end

        traPoint.position = self.tabImg[i].transform.position;

    end

end


-- 设置免费次数
function SlotBase.SetFreeNumber(bShow, byNum)

    local traImgFree = traMainGold.transform:Find("FreeBox");

    traImgFree.gameObject:SetActive(bShow);

    if (byNum >= 0) then
        local traFreeNum = traImgFree:Find("ImageFree");
        SlotBase.showNumberImage(byNum, traFreeNum, Game01Panel.freeNumRes);
    end

end

function SlotBase.GameEnd()
    log("===============================游戏结束================================" .. self.iGold)
    SlotBase.SetGold(self.iGold);
    self.bPlayGame = false;
    traBtnAutoOrStop:GetComponent("Button").interactable = true;

    SlotBase.ChipState();
end




-- 显示下注列表
-- bShow 是否显示 废弃
function SlotBase.ShowBetBtn(bShow)
    if (true) then
        return ;
    end
    -- traBetBox.gameObject:SetActive(bShow);
    if (not bShow or toInt64(C_LEAST_CHIP * SlotDataStruct.D_LINE_COUNT) > toInt64(self.iGold)) then
        return ;
    end

    for i = 0, (traBetBox.childCount - 1) do

        local traBetBtn = traBetBox.transform:GetChild(i);
        local iBet = tonumber(traBetBtn:Find("Text"):GetComponent('Text').text);
        local iChipNum = iBet * SlotDataStruct.D_LINE_COUNT;

        if (toInt64(iChipNum) <= toInt64(self.iGold)) then
            traBetBtn:GetComponent('Button').interactable = true;
        else
            traBetBtn:GetComponent('Button').interactable = false;
        end

    end


end


--设置自动状态次数
function SlotBase.SetAutoCntState()
    error("自动")
    if (not traAutoCnt.gameObject.activeSelf) then
        return ;
    end

    if (not tonumber(iAutoCnt)) then
        return ;
    end

    iAutoCnt = iAutoCnt - 1;
    SlotBase.SetAutoCntText(iAutoCnt);
    if (iAutoCnt <= 0) then
        self.bAuto = false;
        traBtnAutoOrStop.transform:GetComponent('Image').sprite = btnRes.transform:Find("BtnZD"):GetComponent('Image').sprite
        traAutoCnt.gameObject:SetActive(false);
    end

end

function SlotBase.SetAutoCntText(iCnt)
    traAutoCnt:Find("Text"):GetComponent("Text").text = iCnt .. "";
end

----------------- 计时器回调 -------------------
self.tempChangeGold = 0; -- 单位变化金币数
-- 结算金币 单位变化回调
function SlotBase.ResultGoldTickCallBack(tempNum)
    self.tempChangeGold = self.tempChangeGold + tempNum;
    if (self.tempChangeGold > self.iWinScore) then
        self.tempChangeGold = self.iWinScore;
    end
    -- log("change gold " .. self.tempChangeGold .. " temp number " .. tempNum);
    SlotBase.showNumberImage(self.tempChangeGold, traResultGold, Game01Panel.bigNumRes);
end

-- 结算金币 变化结束回调
function SlotBase.ResultGoldEndCalBack(args)

    if (not self.bAgainRotate) then
        self.tempChangeGold = 0;
    else
        self.tempChangeGold = self.iWinScore;
    end

    if (self.comSource) then
        destroy(self.comSource.gameObject);
        -- 结束玩家获得金币音效
        self.comSource = nil;
    end
    -- if(self.byWealthGodNum < C_GOD_SUPERGOLD) then
    SlotBase.showNumberImage(self.iWinScore, traResultGold, Game01Panel.bigNumRes);
    -- end
    if (self.bGodDown or self.byWealthGodNum >= 5 and not self.bAgainRotate) then
        log("is GodDown");
        SlotBase.GodDown();
    else
        -- self.transform:Find("PlayerGold/GoldAnimation").gameObject:SetActive(true);
        -- self.bPlayGame = false;
        if (not self.bAgainRotate) then
            SlotBase.SetAutoCntState();
        end
        self.GameEnd();
    end
    error("==========结算重转" .. tostring(self.bAgainRotate));
    SlotBase.PayAgainRotAnim(self.bAgainRotate);

    log("resilt is end " .. self.iWinScore);

end

-- 普通时刻超级彩金变化结束回调
function SlotBase.SuperGoldChangeEndCallBack(args)
    -- SlotBase.SuperGoldChange();
end

-- 超级彩金 单位变化回调 --废弃
function SlotBase.SuperGoldTickCallBack(args)
    local num = math.random(self.iCurrentChip * 2000, self.iCurrentChip * 20000);
    if (num > 999999999) then
        num = 999999999;
    end
    num = math.ceil(num);
    SlotBase.showNumberImage(num, traSuperGold, Game01Panel.superGoldNumRes);
end

-- 超级彩金 变化结束回调 --废弃
function SlotBase.SuperGoldEndCallBack(args)
    -- self.bPlayGame = false;
    destroy(traSuperGold.parent:Find("ImageSuperGoldAnim").gameObject);
    SlotBase.showNumberImage(self.iWinScore, traSuperGold, Game01Panel.superGoldNumRes);
    self.GameEnd();
end

-- 转动前 动画播放结束回调
function SlotBase.rotateAgoAnimationEndCallBack(args)

    -- traMainGold.transform:Find("ImageGold").gameObject:SetActive(true);
    -- if(SlotDataStruct.enGameType.E_GAME_TYPE_PBSH == self.gameType) then --蓬荜生辉
    -- traMainGold.transform:Find("ImagePBSH").gameObject:SetActive(false);
    -- elseif(SlotDataStruct.enGameType.E_GAME_TYPE_JYMT == self.gameType) then --金玉满堂
    -- traMainGold.transform:Find("ImageJYMT").gameObject:SetActive(false);
    --        local tab1 = { fun = SlotBase.JYMTAnimationTickCallBack; args = SlotBase; }
    --        local tab2 = { fun = SlotBase.JYMTAnimationEndCallBack; args = SlotBase; }
    --        local t = C_JYMT_TIME/SlotDataStruct.D_ROW_COUNT;
    --        self.objTime:setTimer(C_JYMT_TIME, true, SlotTimer.slotTimerType.tick, t, tab1, tab2);
    -- end
    self.PlayGameTypeAnimation(false);

    for i = 0, SlotDataStruct.D_COL_COUNT - 1 do
        SlotBase.PlayImgRotate(i);
    end

end

self.changeRow = 0;
-- 金玉满堂 
function SlotBase.JYMTAnimationTickCallBack(args)

    if (self.changeRow >= SlotDataStruct.D_ROW_COUNT) then
        return ;
    end

    local loopI = (self.changeRow * SlotDataStruct.D_COL_COUNT) + 1
    local iCount = (loopI + SlotDataStruct.D_COL_COUNT) - 1;

    for i = loopI, iCount do
        --        local imgCom = self.tabImg[i]:GetComponent('Image');
        --        imgCom.sprite = self.mainImgRes.transform:Find(self.tabImg[i].name):GetComponent('Image').sprite;
        --        imgCom:SetNativeSize();
        self.tabImg[i]:PlayAnimation(true, true);
    end

    --    for i = 0, traImage.childCount - 1 do
    --        local imgCom = traImage:GetChild(i):GetChild(self.changeRow):GetChild(0):GetComponent('Image');
    --        imgCom.sprite = mainImgRes.transform:Find("5"):GetComponent('Image').sprite;
    --        imgCom:SetNativeSize();
    --    end
    SlotBase.PlayMusic(SlotResourcesName.JYMT);
    self.changeRow = self.changeRow + 1;
end

function SlotBase.JYMTAnimationEndCallBack(args)
    SlotBase.GameResult();
    self.changeRow = 0;
end

-- 财神降临 动画结束回调
function SlotBase.GodDownEndCalBack(args)

    -- traMainGold.transform:Find("ImageGold").gameObject:SetActive(false);
    traMainGold.transform:Find("ImageGoldDown").gameObject:SetActive(false);

    for i = 0, traSubGold.childCount - 1 do

        local traGod = traSubGold.transform:GetChild(i);
        local strGodNum = string.split(traGod.name, "_");

        --        if(i < C_SMALL_GOD_COUNT and not self.bGodDown) then
        --           traGod.gameObject:SetActive(true);
        --        end
        if (self.byWealthGodNum <= 0) then
            break ;
        end

        if (tonumber(strGodNum[2]) == self.byWealthGodNum) then
            --           traGod:GetComponent('Image').enabled = false;
            --           traGod:Find("ImageGod"):GetComponent('Image').sprite = self.mainImgRes.transform:Find("TopGod"):GetComponent('Image').sprite;
            --           traGod:Find("ImageGod"):GetComponent('Animator').enabled = false;
            log("is end");
            self.PlayerTopGodAnim(traGod, false);

            break ;
        end

    end

    if (not self.bGodDown) then
        SlotBase.SetFreeNumber(true, self.byFreeNum);
        self.bGodDown = true;
    end

    self.iGodDownScore = self.iGodDownScore + self.iWinScore;
    error("财神降临==========" .. self.iGodDownScore);


    --    if(self.byWealthGodNum >= C_GOD_SUPERGOLD) then --超级彩金
    --        SlotBase.IsSuperGold();
    if (self.byFreeNum <= 0) then
        SlotBase.GodDownEnd();
    else
        -- self.bPlayGame = false;
        self.GameEnd();
    end

end

-- 财神降临边框闪烁 单位时间回调
function SlotBase.BorderFlashTickCallBack(args)
    local obj = self.transform:Find("Centre/ImageGodDownBox").gameObject;
    obj:SetActive(not obj.activeSelf);
end

-- 财神降临结束回调
function SlotBase.GodDownEndEndCalBack(args)

    -- traMainGold.transform:Find("ImageGold").gameObject:SetActive(true);
    self.transform:Find("GodDownTitle").gameObject:SetActive(false);
    -- self.bPlayGame = false;
    self.GameEnd();
end

function SlotBase.StartBtnUpEndCallBack(args)
    log("is btn call back");
    self.bAuto = true;
    traBtnAutoOrStop.transform:GetComponent('Image').sprite = btnRes.transform:Find("BtnSD"):GetComponent('Image').sprite
    traAutoCnt.gameObject:SetActive(true);
    traAutoCnt:Find("BtnAutoCnt").gameObject:SetActive(true);
    self.bBtnCallBack = true;
end

----------------- 计时器回调 end-------------------
---------------------  响应事件 -----------------------------
-- 显示下注列表事件 废弃
function SlotBase.OnClickShowBetBtn(prefab)
    SlotBase.PlayMusic(SlotResourcesName.btn);

    if (self.byFreeNum > 0) then
        return ;
    end

    if (traBetBox.gameObject.activeSelf) then
        SlotBase.ShowBetBtn(false);
    else
        SlotBase.ShowBetBtn(true);
    end

end

-- 筹码按钮事件 废弃
function SlotBase.OnClickBetBtn(prefab)

    if (self.byFreeNum > 0) then
        return ;
    end

    SlotBase.PlayMusic(SlotResourcesName.btn);

    local iChip = tonumber(prefab.transform:Find("Text"):GetComponent('Text').text);

    log("xxxxxxxxxxxxxxxx是否限制 ： " .. bLimitChip .. "  限制值 = " .. iLimitChip);
    if (bLimitChip < 1 and iChip * SlotDataStruct.D_LINE_COUNT > iLimitChip) then
        Network.OnException("下注失败 超出个人下注上限");
        return ;
    end
    -- 下注限制
    self.iCurrentChip = iChip;

    local traSign = GameObject.FindGameObjectWithTag("Bullet").transform;
    traSign.transform.parent = prefab.transform;
    traSign.transform.localPosition = Vector3.New(0, 9, 0);

    self.transform:Find("ImageLeftBottomBox/ImageAllChip/ButtonBet/Text"):GetComponent('Text').text = iChip .. "";
    local iNum = iChip * SlotDataStruct.D_LINE_COUNT;
    local traTarget = self.transform:Find("ImageLeftBottomBox/ImageAllChip/LayoutAllChip");
    SlotBase.showNumberImage(iNum, traTarget, Game01Panel.allChipNumRes);
    SlotBase.ShowBetBtn(false);
    -- SlotBase.showNumberImage(iChip*C_SUPER_GOLD_RATE, traSuperGold, Game01Panel.goldNumRes); --设置超级彩金
    log("当前下注值 = " .. iChip);

end

-- 加减下注值
function SlotBase.OnClickChangeChipBgn(prefab)

    local iSing = 1;
    if ("ButtonL" == prefab.name) then
        iSing = -1;
    end

    if (self.byFreeNum > 0) then
        return ;
    end

    SlotBase.PlayMusic(SlotResourcesName.btn);

    local iTempChipNum = self.iCurrentChip;

    local iMaxChip = iChipsNum[#iChipsNum];
    local iMaxIdx = #iChipsNum;

    if (bLimitChip > 1) then
        for i = #iChipsNum, 1, -1 do
            if (iLimitChip / SlotDataStruct.D_LINE_COUNT <= iChipsNum[i]) then
                iMaxChip = iChipsNum[i];
                iMaxIdx = i;
                break ;
            end
        end
    end
    -- 下注限制
    local idx = 1;
    for i = idx, iMaxIdx do
        if (self.iCurrentChip == iChipsNum[i]) then
            idx = i + iSing;
            if (idx > #iChipsNum) then
                idx = 1;
            elseif (idx <= 0) then
                idx = iMaxIdx;
            end
            iTempChipNum = iChipsNum[idx];
            self.iCutChipIdx = idx;
            break ;
        elseif (i == iMaxIdx) then
            self.iCutChipIdx = 1;
            iTempChipNum = iChipsNum[1];
        end
    end

    self.iCurrentChip = iTempChipNum;

    self.transform:Find("ImageLeftBottomBox/ImageAllChip/ButtonBet/Text"):GetComponent('Text').text = SlotDataStruct.D_LINE_COUNT .. "x" .. self.iCurrentChip;
    local iNum = self.iCurrentChip * SlotDataStruct.D_LINE_COUNT;
    local traTarget = self.transform:Find("ImageLeftBottomBox/ImageAllChip/LayoutAllChip");
    SlotBase.showNumberImage(iNum, traTarget, Game01Panel.allChipNumRes);

end

-- 启动按钮响应事件 --废弃
function SlotBase.OnClickStartBtn(prefab)

    -- if(self.bAuto) then return; end
    logYellow("OnClickStartBtn");
    if (self.bPlayGame) then
        log("game is not end");
        return ;
    end

    if (toInt64(self.iCurrentChip * SlotDataStruct.D_LINE_COUNT) > toInt64(self.iGold)) then
        -- 金币不足
        log("OnClickStartBtn 下注金币不足！");
        return ;
    end
    SlotBase.PlayMusic(SlotResourcesName.btn);
    -- traBtnStart:GetComponent('Button').interactable = false;
    SlotBase.SendGameStart();

end

-- 自动手动切换按钮响应事件 废弃
function SlotBase.OnClickAutoOrStopBtn(prefab)
    log("OnClickAutoOrStopBtn");
    if (not self.bAuto) then

        if (toInt64(self.iCurrentChip * SlotDataStruct.D_LINE_COUNT) > toInt64(self.iGold)) then
            -- 金币不足
            log("OnClickAutoOrStopBtn 下注金币不足！");
            return ;
        end
        prefab.transform:GetComponent('Image').sprite = btnRes.transform:Find("BtnSD"):GetComponent('Image').sprite
        self.bAuto = true;

        if (self.bChipState and not self.bPlayGame) then
            SlotBase.SendGameStart();
        end
    else
        prefab.transform:GetComponent('Image').sprite = btnRes.transform:Find("BtnZD"):GetComponent('Image').sprite
        self.bAuto = false;
    end

    SlotBase.PlayMusic(SlotResourcesName.btn);

end

-- 说明按钮响应事件
function SlotBase.OnClickExplainBtn(prefab)
    traExplain.gameObject:SetActive(true);
    SlotBase.PlayMusic(SlotResourcesName.btn);
end

function SlotBase.OnClickAutoCntBtn(btn)
    iAutoCnt = btn.transform:Find("Text"):GetComponent("Text").text;
    logYellow("iAutoCnt = " .. iAutoCnt);
    if (tonumber(iAutoCnt)) then
        iAutoCnt = tonumber(iAutoCnt);
    end
    SlotBase.SetAutoCntText(iAutoCnt);
    traAutoCnt:Find("BtnAutoCnt").gameObject:SetActive(false);
    self.bAuto = true;
end
function SlotBase.OnClickDownStartBtn()

    local tab1 = nil;

    local tab2 = { fun = SlotBase.StartBtnUpEndCallBack; args = SlotBase; }

    local allTime = 1;
    if (toInt64(self.iCurrentChip * SlotDataStruct.D_LINE_COUNT) > toInt64(self.iGold)) then
        -- 金币不足
        return ;
    end
    self.btnTimer:setTimer(allTime, true, SlotTimer.slotTimerType.timint, 0, tab1, tab2);

end

function SlotBase.ResetRotate()
    coroutine.start(function()
        if self.bAuto then
            if  self.bSendGameStart then
                coroutine.wait(1)
                SlotGameNet.SendUserReady();
                log("send game start：" .. self.iCurrentChip);
                local Data = { [1] = self.iCurrentChip, }
                local buffer = SetC2SInfo(SlotDataStruct.CMD_CS_GAME_START, Data);
                Network.Send(MH.MDM_GF_GAME, SlotDataStruct.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
                SlotGameNet.isreqStart=false
            end
        end
    end)
end

function SlotBase.OnClickUpStartBtn()
    log("OnClickUpStartBtn");
    if (toInt64(self.iCurrentChip * SlotDataStruct.D_LINE_COUNT) > toInt64(self.iGold)) then
        -- 金币不足
        log("SendGameStart 下注金币不足！");
        -- SlotTitleCtrl.ShowTitle(self.transform, "金币不足！");
        MessageBox.CreatGeneralTipsPanel("下注金币不足！", nil);
        self.btnTimer:setTimer(allTime, false, SlotTimer.slotTimerType.timint, 0, nil, nil);
        return ;
    end
    --traBtnAutoOrStop:GetComponent("Button").interactable = false;
    local allTime = 2;
    self.btnTimer:setTimer(allTime, false, SlotTimer.slotTimerType.timint, 0, nil, nil);

    if (self.bBtnCallBack) then
        self.bAuto = true;
        self.bBtnCallBack = false;
    else
        self.bAuto = false;
        traBtnAutoOrStop.transform:GetComponent('Image').sprite = btnRes.transform:Find("BtnZD"):GetComponent('Image').sprite
        traAutoCnt.gameObject:SetActive(false);
    end

    self.bBtnCallBack = false;

    if (self.bPlayGame) then
        return ;
    end

    --    if(self.iCurrentChip * SlotDataStruct.D_LINE_COUNT > self.iGold) then --金币不足
    --        SlotTitleCtrl.ShowTitle(self.transform, "金币不足！");
    --        log("下注金币不足！");
    --        return;
    --    end
    SlotBase.PlayMusic(SlotResourcesName.btn);

    if (not self.bAuto and not self.bPlayGame and self.bChipState and not self.bGodDown) then

        SlotBase.SendGameStart();
    end

end

---------------------  响应事件 end-----------------------------
function SlotBase.GetMainImage(sImgName)
    return self.mainImgRes.transform:Find(sImgName):GetComponent('Image');
end

function SlotBase.PlayMusic(sName)

    -- if(sName ~= "RateaStop" and sName ~= "GodStop") then return;end
    local source = Game01Panel.musicRes.transform:Find(sName):GetComponent('AudioSource');
    -- 背景音乐
    return MusicManager:PlayX(source.clip);

end

-- 显示数字图片
-- iNum 数值    traNum 数字图片物体  res 数字资源
function SlotBase.showNumberImage(iNum, traNum, res)

    if (toInt64(iNum) < toInt64(0)) then
        log("！！！！！设置字体图片数值小于0！");
        return ;
    end
    local strNum = iNum .. "";
    local tabShowNumStr = {};
    -- 要显示的数字 字符串表
    for i = 1, #strNum do
        table.insert(tabShowNumStr, string.sub(strNum, i, i));
        -- 将要显示的数字字符串存入showNumStrTab
    end
    local numsBeginCount = traNum.transform.childCount;
    -- 数字图片的初始个数
    for i = 1, #tabShowNumStr do
        local traNumChild;
        -- 数字图片物体子物体
        if (i <= numsBeginCount) then
            -- 已经存在的直接改变图片
            traNumChild = traNum.transform:GetChild(i - 1);
        else
            -- 不存在的先创建
            traNumChild = newobject(traNum.transform:GetChild(0).gameObject).transform;
            traNumChild.transform:SetParent(traNum);
            traNumChild.transform.localScale = Vector3.one;
            traNumChild.transform.localPosition = Vector3.New(0, 0, 0);
        end

        traNumChild.gameObject:SetActive(true);

        local numRes;

        numRes = res.transform:GetChild(tonumber(tabShowNumStr[i]));
        -- 要显示的图片资源
        traNumChild.transform:GetComponent('Image').sprite = numRes.transform:GetComponent('Image').sprite;

    end

    for i = #tabShowNumStr, (traNum.transform.childCount - 1) do
        -- 隐藏没有赋值的图片物体
        traNum.transform:GetChild(i).gameObject:SetActive(false);
    end

end

function SlotBase.GameQuit()
    self = nil;
end