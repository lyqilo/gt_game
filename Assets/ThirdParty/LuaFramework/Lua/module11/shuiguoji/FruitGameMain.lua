--FruitGameMain.lua
--Date
--此文件由[BabeLua]插件自动生成

--水果机主类

--endregion

require "Module11/ShuiGuoJi/FruitData"
require "Module11/ShuiGuoJi/FruitGameNet"
require "Module11/ShuiGuoJi/FruitGameBase"
require "Module11/ShuiGuoJi/FruitGameTimer"
require "Module11/ShuiGuoJi/MainImgCtrl"
require "Module11/ShuiGuoJi/SubImgCtrl"



FruitGameMain = {}

local this = nil;

--游戏状态
local E_STATE_START = 0;  --开始
local E_STATE_RESULT = 1;  --结算阶段
local E_STATE_COMPARE = 2; --比倍阶段
local E_STATE_RESULT_END = 3; --结算结束
local E_STATE_END = 4; --游戏结束

local D_MUSIC_BJ_END = "end";

local D_TIME_NOT_LIMIT = 600 --不限时间
local D_TIME_BTN_TICK = 0.3; --按钮点击间隔时间

FruitResource = 
{
    dbResNameStr = "module11/game_shuiguoji_res"; --游戏db资源名称
    abMusicNameStr = "module11/game_shuiguoji_music";--游戏音乐资源

    strMusic = "Music";
    strChipMusic = "ChipMusic"; --下注音效
    strRotateMusic = "RotateMusic"; --转动音效
    strWinAwardMusic = "WinAwardMusic"; --胜利音效
    strWinAwardVoice = "WinAwardVoice"; --中奖水果语音

    strSPStartMusic = "SPStartMusic"; --特殊奖开始音效
    strSPEndMusic = "SPEndMusic"; --特殊奖结束音效
    strWu = "WLHCMusic"; --五列火车启动音效

    strComWinMusic = "ComWinMusic"; --比倍赢
    strComLostMusic = "ComLostMusic"; --比倍输
    strComNumMusic = "ComNumMusic"; --比倍数字跳动

    strGoldMusic = "GoldMusic"; --金币数字跳动


    strTraLuckName1 = "ImageLuckyL";
    strTraLuckName2 = "ImageLuckyR";

    strTraMyGoldNum = "MyGoldNumbers";
    strTraWinGold = "WinGoldNumbers";
};


function FruitGameMain:New(o)
    local t = o or { };
    setmetatable(t, self);
    self.__index = self
    return t;
end

function FruitGameMain:Awake(obj)
    
    FruitGameMain.GameQuit(true);

    this = FruitGameMain:New();
    this.transform = obj.transform;

    GameManager.PanelRister(obj);

    FruitGameNet.addGameMessge();

    this.csJoinLua = this.transform:GetComponent('CsJoinLua');

    LoadAssetAsync(FruitResource.dbResNameStr, 'CanvasFruit', FruitGameMain.CallBackCreatScreen, true, true);
    FruitGameMain.ResReadyToLoad();
--    require("ShuiGuoJi/FruitTest");
--    this.test = FruitTest.Init(this.csJoinLua, this.transform:Find("CanvasFruit"), FruitGameMain.InitScene );

end


function FruitGameMain.CallBackCreatScreen(go)
    
    go.transform:SetParent(this.transform);
    go.name = "CanvasFruit";
    go.transform.localScale = Vector3.one;
    go.transform.localPosition = Vector3.New(0, 0, 0);
    --go.transform.localEulerAngles = Vector3.New(0, 0, 0);

	SetCanvasScalersMatch(go.transform:GetComponent("CanvasScaler") ); --屏幕适配

    this.fruitBase = FruitGameBase.Init(go, this.transform, this.csJoinLua);
    this.traPanel = this.transform:Find("CanvasFruit/PanelBase");
    GameManager.GameScenIntEnd(); --加载集合按钮

    FruitGameNet.playerLogon();

    GameManager.PanelInitSucceed(this.transform.gameObject);

    --FruitGameMain.ResReadyToLoad();
end

function FruitGameMain:Update()
    --if(this.fruitBase) then this.fruitBase:Update(); end
    if(this.timerGame) then this.timerGame:timer(Time.deltaTime); end
    if(this.btnTimer) then this.btnTimer:timer(Time.deltaTime) end

--    if(this.test) then this.test:Update(); end
end

function FruitGameMain:FixedUpdate()
    if(this.fruitBase) then this.fruitBase:Update(); end
end

--初始化场景
--    local tabData =
--    {
--        iMinScale = data[1]; --最小倍数
--        iAddStep = data[2]; --每次增加倍数
--        iMaxStep = data[3]; --最大倍数
--    }
function FruitGameMain.InitScene(tabGameScene)
    
    if (not Util.isPc) then GameSetsBtnInfo.SetPlaySuonaPos(0,225,0); end

    this.eState = E_STATE_END;
    this.comBtntras = {}; --btn
    this.tabChipNum = {};

    local traOpearator = this.traPanel:Find("Opearation");
    local tarChipList = this.traPanel:Find("ChipList");

    local comEveTri = nil;
    for i = 0, traOpearator.childCount - 1 do
        local traChild = traOpearator:GetChild(i);

--        if("ButtonOk" == traChild.name) then
--            comEveTri  = Util.AddComponent("EventTriggerListener", traChild.gameObject);
--            comEveTri.onDown = FruitGameMain.OnClickBtn;
--            comEveTri.onUp = FruitGameMain.OnclickUpBtn;
--        end
        
        if("ImageAddRate" == traChild.name) then
            table.insert(this.comBtntras, traChild:Find("ButtonAdd"):GetComponent('Button') );
            this.csJoinLua:AddClick(traChild:Find("ButtonAdd").gameObject, FruitGameMain.OnClickBtn);
            comEveTri  = Util.AddComponent("EventTriggerListener", traChild:Find("ButtonAdd").gameObject );
            comEveTri.onDown = FruitGameMain.OnClickBtnDwon;
            comEveTri.onUp = FruitGameMain.OnclickUpBtn;
        elseif("Compare" == traChild.name) then
            FruitGameMain.SetBtnColor(traChild:Find("ButtonSmall"):GetComponent('Button'), false);
            FruitGameMain.SetBtnColor(traChild:Find("ButtonBig"):GetComponent('Button'), false);
            table.insert(this.comBtntras, traChild:Find("ButtonSmall"):GetComponent('Button') );
            this.csJoinLua:AddClick(traChild:Find("ButtonSmall").gameObject, FruitGameMain.OnClickBtn);
            table.insert(this.comBtntras, traChild:Find("ButtonBig"):GetComponent('Button') );
            this.csJoinLua:AddClick(traChild:Find("ButtonBig").gameObject, FruitGameMain.OnClickBtn);
        else
            if("ButtonAuto" ~= traChild.name) then
                table.insert(this.comBtntras, traChild:GetComponent('Button') );
            end
            if("ButtonOk" ~= traChild.name) then
                this.csJoinLua:AddClick(traChild.gameObject, FruitGameMain.OnClickBtn);
            end
            if("ButtonAllIn" == traChild.name or "ButtonOk" == traChild.name) then
                comEveTri  = Util.AddComponent("EventTriggerListener", traChild.gameObject);
                if("ButtonAllIn" == traChild.name) then
                    comEveTri.onDown = FruitGameMain.OnClickBtnDwon;
                else
                    comEveTri.onDown = FruitGameMain.OnClickBtn;
                end
                comEveTri.onUp = FruitGameMain.OnclickUpBtn;
            end
        end
    end

    for i = 0, tarChipList.childCount - 1 do
        table.insert(this.tabChipNum, tarChipList:GetChild(i):GetChild(0) );
        table.insert(this.comBtntras,  tarChipList:GetChild(i):GetComponent('Button') );
        this.csJoinLua:AddClick(tarChipList:GetChild(i).gameObject, FruitGameMain.OnClickBtn);
        comEveTri  = Util.AddComponent("EventTriggerListener", tarChipList:GetChild(i).gameObject );
        comEveTri.onDown = FruitGameMain.OnClickBtnDwon;
        comEveTri.onUp = FruitGameMain.OnclickUpBtn;
    end


    this.tabCurChip = {}; --当前下注值

    for i = 1, FruitData.D_CHIP_LIST_COUNT do
        this.tabCurChip[i] = 0;
    end

    this.bIsBtnDown = false; --按钮是否按下
    this.bAuto = false;
    this.bIsChip = false; --是否下过注
    this.bIsOkGame = true; --是否可以开始游戏
    this.iAllChip = 0; --总下注值
    this.iMaxChip = 99; -- 最大下注值
    FruitGameMain.SetTableRate(tabGameScene);

end

--部分资源预加载
function FruitGameMain.ResReadyToLoad()
    local fun = function (obj)  local traRes = obj.transform; logYellow("===============预加载资源===============" .. traRes.name); end
    LoadAssetAsync(FruitResource.abMusicNameStr, 'Music', fun, false, true);
end

--设置桌子上的倍数
function FruitGameMain.SetTableRate(tabGameScene)
    logYellow("iMinScale = " .. tabGameScene.iMinScale .. " max chip = " .. tabGameScene.iMaxStep);
    this.iCurRate = tabGameScene.iMinScale;
    this.iMinRate = tabGameScene.iMinScale;
    this.iAddRate = tabGameScene.iAddStep;
    this.iMaxRate = tabGameScene.iMaxStep;
    this.iMaxChip = tabGameScene.iMaxStep / this.iCurRate;
    if(this.iMaxChip > 99 ) then this.iMaxChip = 99; end
    FruitGameMain.SetRateNumImg();
end


--设置玩家金币 bServ是否服务器通知
function FruitGameMain.SetPlayerGold(iGold, strTraName, bServ)
    if(not this.resNumber) then
        this.resNumber =  LoadAsset(FruitResource.dbResNameStr, 'ResNumber');
    end
    local traGold = this.traPanel:Find("Gold/" .. strTraName );
    FruitGameMain.SetNumImage(tostring(iGold), traGold, this.resNumber);
    if(FruitResource.strTraMyGoldNum ==  strTraName) then
        if(bServ) then this.iMyGold = iGold; end  --自己当前金币
        this.iCopyGold = iGold; --备份金币
    end
end

--可以下注
function FruitGameMain.BeginChip()
    logYellow("begin chip .. state = " .. this.eState);
    this.bIsOkGame = true;
    if(this.bAuto) then
        FruitGameMain.SendGameBegin();
    elseif(E_STATE_RESULT == this.eState) then --自动结算
        logYellow("自动结算");
        FruitGameMain.GameResultEnd(true);
    end
end

--        local tabData = 
--        {
--            iChipResult -- 第一轮结果金额
--            tabImgId =  --第一轮主盘图案 size 4
--            tabRates =  --倍率 size 3
--            iChipList =  -- 每个图案下注的最后中奖倍数 size 8
--        }
function FruitGameMain.GameStart(tabResultInfo)
	logYellow("IN  GameStart ");
    this.bIsChip = false;
    this.bIsOkGame = false;
    --this.eState = E_STATE_START;
    this.iWinGold = tabResultInfo.iChipResult;
    logYellow("xxxxxxxxxxxxxxx  " .. this.iWinGold);
    this.iWinChipList = tabResultInfo.iChipList;
    this.iOneRate = tabResultInfo.tabRates[1]; --判断是否0倍
    
--    for i = 1, #this.iWinChipList do
--        logYellow("win chip = " .. this.iWinChipList[i]);
--    end
--    logYellow("com gold = " .. this.iWinGold);
    --FruitGameMain.ChangeBtnState(this.eState);
    FruitGameMain.SetPlayChipImgNum(true, this.tabCurChip);
    this._tabImgId = tabResultInfo.tabImgId;
    FruitGameBase.GameBegin(tabResultInfo.tabImgId, tabResultInfo.tabRates);
end

--比倍游戏

--        local tabData =
--        {
--            iWinGold = data[1]; --赢得金币
--            iNumber = data[2]; --比大小最终值
--        }
function FruitGameMain.ComGame(tabComResultInfo)
    logYellow("com num = " .. tabComResultInfo.iNumber);
    this.iWinGold = tabComResultInfo.iWinGold;
    logYellow("com gold = " .. this.iWinGold);
    FruitGameBase.ComRate(tabComResultInfo.iNumber);
--    this.eState = E_STATE_COMPARE;
--    FruitGameMain.ChangeBtnState(this.eState);
end

--游戏结算结束 bNotSend 是否不发送消息
function FruitGameMain.GameResultEnd(bNotSend)
    
    this.eState = E_STATE_RESULT_END;
    FruitGameMain.ChangeBtnState(this.eState);

    local iWinGold = this.iWinGold;
    logYellow("Win gold = " .. iWinGold);
    local index = tonumber(string.len(this.iWinGold .. "") ) - 2; --指数
    if(index < 0) then index = 0; end
    local iAddNum = math.pow(10, index);
    local C_TIME_TICK = 0.02; --单位变化时间
    local iAllTime = 99 * C_TIME_TICK + C_TIME_TICK;
    logYellow("index = " .. index .. "__iAddnum = " .. iAddNum);

    local funTick = function ()

                        FruitGameMain.SetPlayerGold(iWinGold, FruitResource.strTraWinGold);
                        iWinGold = iWinGold - iAddNum;
                        if(this.iWinGold > 0 ) then
                            FruitGameMain.SetPlayerGold(this.iCopyGold, FruitResource.strTraMyGoldNum);
                            this.iCopyGold = this.iCopyGold + iAddNum;
                        end

                        if(iWinGold <= 0) then
                            logYellow("is gold end");
                            iWinGold = 0;
                            this.timerGame:SetTimer(D_TIME_NOT_LIMIT, false, FruitGameTimer.FruitTimerType.tick, 0, nil, nil);
                        elseif(this.iWinGold - iAddNum == iWinGold) then
                            logYellow("play gold music");
                            FruitGameMain.PlayBjMusic(FruitResource.strGoldMusic, 0);
                        end
                    end
    
    local funEnd = function()
                        logYellow("result is end");
                        FruitGameMain.PlayBjMusic("end");
                        FruitGameMain.SetPlayerGold(0, FruitResource.strTraWinGold);
                        FruitGameMain.SetPlayerGold(this.iMyGold + this.iWinGold, FruitResource.strTraMyGoldNum);
                        --logYellow("gold is = " .. (this.iMyGold + this.iWinGold) );
                        this.iWinGold = 0;
                        this.eState = E_STATE_END;
                        FruitGameMain.ChangeBtnState(this.eState);
                        FruitGameBase.GameEnd();
                        
                        local tabChips = {0, 0, 0, 0, 0, 0, 0, 0};
                        FruitGameMain.SetPlayChipImgNum(true, tabChips);
                        this.tabMusicBuf = {};
                        if(not bNotSend) then
                            local buffer = ByteBuffer.New();
                            Network.Send(MH.MDM_GF_GAME, FruitData.SUB_CS_ACCOUNT , buffer, gameSocketNumber.GameSocket);
                        end
                   end

    local tab1 = {fun = funTick; args = FruitGameMain; };
    local tab2 = {fun = funEnd; args = FruitGameMain; };
    if(not this.timerGame) then this.timerGame = FruitGameTimer:New(); end
    this.timerGame:SetTimer(iAllTime, true, FruitGameTimer.FruitTimerType.tick, C_TIME_TICK, tab1, tab2);
end

--显示结果
function FruitGameMain.ShowResult(tabChips, bCom, bResult)
    logYellow("Show result ");
    tabChips = tabChips or this.iWinChipList; 

    if(this.iOneRate <= 0 or bResult) then
        FruitGameMain.GameResultEnd();
        return;
    end

    if(this.iWinGold > 0 and bCom) then
        FruitGameBase.PlayComRateMusic(true);
        this.eState = E_STATE_RESULT;
        FruitGameMain.ChangeBtnState(this.eState);
    elseif(this.iWinGold <= 0 and bCom) then
        FruitGameBase.PlayComRateMusic(false);
        FruitGameMain.GameResultEnd();
    elseif(this.iOneRate > 0) then
        this.eState = E_STATE_RESULT;
        FruitGameMain.ChangeBtnState(this.eState);
        FruitGameMain.SetPlayChipImgNum(false, tabChips, this._tabImgId);
    end

    FruitGameMain.SetPlayerGold(this.iWinGold, FruitResource.strTraWinGold);

    FruitGameMain.SetAutoGameTimer(true);

end

function FruitGameMain.SendGameBegin()
    if(E_STATE_RESULT == this.eState) then
        --this.eState = E_STATE_END;
        FruitGameMain.GameResultEnd();
    elseif(E_STATE_END == this.eState) then
        logYellow("send game begin");
        if(not this.bIsOkGame) then return; end

        if(toInt64( FruitGameMain.GetCurrateOnChip(this.iCurRate) ) > toInt64(this.iMyGold) ) then  
            if(this.bAuto) then
                FruitGameMain.OnClickBtnAuto();
                FruitGameMain.ShowMessageBox("Not enough gold！", true);
                --FruitGameMain.SetAutoGameTimer(false);
            end
            return;
        end;
        --FruitGameNet.SendUserReady();

        local buffer = ByteBuffer.New();
        buffer:WriteLong(this.iCurRate); 
        --logYellow("icur rate = " .. this.iCurRate);
        local iZeroGount = 0;
        for i = 1, FruitData.D_CHIP_LIST_COUNT do
            if(0 == this.tabCurChip[i]) then
                iZeroGount = iZeroGount + 1;
            end
            buffer:WriteUInt32(this.tabCurChip[i]);
            --logYellow("下注列表 this.tabCurChip[" .. i .. "] = " ..  this.tabCurChip[i]);
        end

        if(iZeroGount >= FruitData.D_CHIP_LIST_COUNT) then return; end --没有下注

        Network.Send(MH.MDM_GF_GAME, FruitData.SUB_CS_START , buffer, gameSocketNumber.GameSocket);

        this.eState = E_STATE_START;
        FruitGameMain.ChangeBtnState(this.eState);

    end
end

--设置倍数数字图片
function FruitGameMain.SetRateNumImg(iAddNum)
    
    local iCurRate = this.iCurRate;
    if(iAddNum) then
        iCurRate = iCurRate + iAddNum;
    end
    if(this.iCurRate > this.iMaxRate) then
        iCurRate = this.iMinRate;
    end

    if( toInt64( FruitGameMain.GetCurrateOnChip(iCurRate) ) > toInt64( this.iMyGold ) ) then return; end --下注金币大于总金币
    this.iCurRate = iCurRate;


    local resNum = LoadAsset(FruitResource.dbResNameStr, 'ResAddRateNumber');
    local traRateNum = this.traPanel:Find("Opearation/ImageAddRate/Numbers");
    if(not traRateNum.gameObject.activeSelf) then
        traRateNum.gameObject:SetActive(true);           
    end

    FruitGameMain.SetNumImage(this.iCurRate, traRateNum, resNum);

    local traTitle = this.traPanel:Find("Opearation/ImageAddRate/ImageTitle");
    if(not traTitle.gameObject.activeSelf) then
        traTitle.gameObject:SetActive(true);           
    end

    --------------------移动 "1:" 图片 -----------------------------------------
--    if(not this.fBasePosX) then
--        this.fBasePosX = traTitle.transform.localPosition.x;
--    end
--    local iStrLen = string.len(this.iCurRate .. "");
--    traTitle.transform.localPosition = Vector3.New(this.fBasePosX - 28 * (iStrLen - 1), 0, 0);
    
end


--改变当前下注值 iIsAdd >= 0 增加的值 < 0 清零 
function FruitGameMain.ChangeCurrentChip(tabCurChip, iIsAdd, idx)
    
    local bOkChange = true;
    local iAllNumberCount = 0; --全压计数器

    if(not this.bIsChip) then
        for i = 1, FruitData.D_CHIP_LIST_COUNT do
            if(idx) then     
                --logYellow("add chip = " .. (iIsAdd * this.iCurRate) .. " my cold = " .. this.iMyGold );    
                if(i == idx and toInt64( iIsAdd * this.iCurRate ) <= toInt64( this.iMyGold) ) then
                    tabCurChip[idx] = iIsAdd;
                else
                    tabCurChip[i] = 0;
                end
            elseif(iIsAdd >= 0) then
                if( toInt64( iIsAdd * this.iCurRate * FruitData.D_CHIP_LIST_COUNT ) <= toInt64(this.iMyGold) ) then
                    tabCurChip[i] = iIsAdd
                else   --下注值超出总金币
                    tabCurChip[i] = 0;
                end
            elseif(iIsAdd < 0) then
                tabCurChip[i] = 0;
            end
        end
        this.bIsChip = true;
    else
        for i = 1, FruitData.D_CHIP_LIST_COUNT do
            if(idx) then
                if(toInt64(FruitGameMain.GetCurrateOnChip(this.iCurRate, iIsAdd, 1) ) > toInt64(this.iMyGold) ) then bOkChange = false; break; end --下注值超出总金币
                if(tabCurChip[idx] >= this.iMaxChip) then bOkChange = false; break; end
                tabCurChip[idx] = tabCurChip[idx] + iIsAdd;
                break;

            elseif(iIsAdd >= 0) then
--                local iCurGold = FruitGameMain.GetCurrateOnChip(this.iCurRate, iIsAdd, FruitData.D_CHIP_LIST_COUNT);
                if(1 == i and 
                 toInt64( FruitGameMain.GetCurrateOnChip(this.iCurRate, iIsAdd, FruitData.D_CHIP_LIST_COUNT) ) > toInt64(this.iMyGold ) ) then bOkChange = false; break; end --下注值超出总金币
                if(tabCurChip[i] < this.iMaxChip) then  
                    tabCurChip[i] = tabCurChip[i] + iIsAdd;
                else
                    iAllNumberCount = iAllNumberCount + 1;
                end

            elseif(iIsAdd < 0) then
                tabCurChip[i] = 0;
            end
        end
    end

    if(iAllNumberCount >= FruitData.D_CHIP_LIST_COUNT) then bOkChange = false; end

    return bOkChange;
end

--显示下注列表图片 --bShowZRate是否显示0倍率
function FruitGameMain.SetPlayChipImgNum(bShowZRate, tabChipNums, tabImgId)
    
    if(not this.resNumber) then
        this.resNumber =  LoadAsset(FruitResource.dbResNameStr, 'ResNumber');
    end

    if(idx) then
        FruitGameMain.SetNumImage(tabChipNums[1], this.tabChipNum[idx], this.resNumber);
    else
        for i = 1, #this.tabChipNum do
            FruitGameMain.SetNumImage(tabChipNums[i], this.tabChipNum[i], this.resNumber);
            if(not bShowZRate and 0 == tabChipNums[i] ) then
                local bShow = false;
                if(tabImgId) then
                    for id = 1, #tabImgId do
                        if(tabImgId[id] >= FruitData.tabChipImgId[i][1] and tabImgId[id] <= FruitData.tabChipImgId[i][#FruitData.tabChipImgId[i] ] ) then
                            bShow = true;
                        end
                    end
                end
                this.tabChipNum[i].gameObject:SetActive(bShow);
            elseif(not this.tabChipNum[i].gameObject.activeSelf) then
                this.tabChipNum[i].gameObject:SetActive(true);
            end
        end
    end

end


--改变按钮状态
function FruitGameMain.ChangeBtnState(eState)
    
    for i = 1, #this.comBtntras do

        if(E_STATE_START == eState or E_STATE_COMPARE == eState or E_STATE_RESULT_END == eState) then
            --this.comBtntras[i].interactable = false;
            FruitGameMain.SetBtnColor(this.comBtntras[i], false);
            if("ButtonSmall" == this.comBtntras[i].name or  "ButtonBig" == this.comBtntras[i].name) then
                --this.comBtntras[i].transform.parent.transform.gameObject:SetActive(true);
                --FruitGameMain.SetBtnColor(this.comBtntras[i], true);
            elseif("ButtonAllIn" == this.comBtntras[i].name) then
                --this.comBtntras[i].gameObject:SetActive(false);
            end

        elseif(E_STATE_RESULT == eState) then
            if("ButtonOk" == this.comBtntras[i].name or "ButtonAuto" == this.comBtntras[i].name) then
                --this.comBtntras[i].interactable = true;
                FruitGameMain.SetBtnColor(this.comBtntras[i], true);
            end
            if(this.iWinGold > 0 and not this.bAuto and("ButtonSmall" == this.comBtntras[i].name or "ButtonBig" == this.comBtntras[i].name) ) then
                --this.comBtntras[i].interactable = true;
                FruitGameMain.SetBtnColor(this.comBtntras[i], true);
            end

        elseif(E_STATE_END == eState) then
            --this.comBtntras[i].interactable = true;
            FruitGameMain.SetBtnColor(this.comBtntras[i], true);
            if("ButtonSmall" == this.comBtntras[i].name or "ButtonBig" ==  this.comBtntras[i].name) then
                --this.comBtntras[i].transform.parent.gameObject:SetActive(false);
                --FruitGameMain.SetBtnColor(this.comBtntras[i], false);
                FruitGameMain.SetBtnColor(this.comBtntras[i], false);
            elseif("ButtonAllIn" == this.comBtntras[i].name) then
                --this.comBtntras[i].gameObject:SetActive(true);
            end
        end

    end

end

--设置按钮颜色 false 为置灰
function FruitGameMain.SetBtnColor(comBtn, bInteractable)
   
    local comImg = comBtn.transform:GetComponent('Image');
    comBtn.interactable = bInteractable;

    if(not bInteractable) then
        comImg.color = Color.gray;
    else
        comImg.color = Color.white;
    end
    
end

--获取当前下注值
function FruitGameMain.GetCurrateOnChip(iCurRate, iChip, iCount)
    local iAllChip = 0;
    for i = 1, #this.tabCurChip do
        iAllChip = iAllChip + this.tabCurChip[i] * iCurRate;
    end
    if(iChip and iCount) then
        iAllChip = iAllChip + iChip * iCount * iCurRate;
    end
    return iAllChip;
end 

--自动游戏定时器
function FruitGameMain.SetAutoGameTimer(bStartTimer)
    
    if(not this.bAuto) then return; end

    local tab2 = nil;
    if(bStartTimer) then
        tab2 = { fun = FruitGameMain.GameResultEnd; args = false; };
    else
        local funTemp = function () logYellow("auto is end"); end
        tab2 = { fun = funTemp; args = FruitGameMain; };
        this.bAuto = false;
        FruitGameMain.ChangeBtnState(this.eState);
    end
    
    if(not this.timerGame) then this.timerGame = FruitGameTimer:New(); end
    this.btnTimer:SetTimer(3, bStartTimer, FruitGameTimer.FruitTimerType.timint, 0, nil, tab2);

end


--大厅提示框
function FruitGameMain.ShowMessageBox(strTitle, bNotQuit, iBtnCount)
    iBtnCount = iBtnCount or 1;
    local tab = GeneralTipsSystem_ShowInfo;
    tab._01_Title = "";
    tab._02_Content = strTitle;
    tab._03_ButtonNum = iBtnCount;
    if(bNotQuit) then
        tab._04_YesCallFunction = nil;
    else
        tab._04_YesCallFunction = FruitGameMain.GameQuit;
    end
    tab._05_NoCallFunction = nil;
    MessageBox.CreatGeneralTipsPanel(tab);
end



function FruitGameMain.GameQuit(bNotQuit)
    
    if(not this) then return; end

    if(this.tabMusicBuf) then
        for i = 1, #this.tabMusicBuf do
            if(not IsNil(this.tabMusicBuf[i])) then
                destroy(this.tabMusicBuf[i]);
            end
        end
    end

    if(not bNotQuit) then
        GameSetsBtnInfo.LuaGameQuit();
        coroutine.start(FruitGameMain.unloadGameRes);
    end

    this.tabMusicBuf = {};
    this = {};
    FruitGameBase.Clealthis();

end


function FruitGameMain.unloadGameRes()
    
    coroutine.wait(0.5);

    Unload(FruitResource.dbResNameStr);
    Unload(FruitResource.abMusicNameStr);

    logYellow("---- game Unload end ----------");

end

--------------------------- button clock--------------------------

function FruitGameMain.OnClickBtn(btn)
    
    if("ButtonAdd" == btn.name) then
        FruitGameMain.SetRateNumImg(this.iAddRate);

    elseif("ButtonSmall" == btn.name or "ButtonBig" == btn.name) then
        
        local Data = {} 

        if( "ButtonSmall" ==btn.name) then
            Data[1] = 0;
        else
            Data[1] = 1;
        end

        local buffer = SetC2SInfo(FruitData.CMD_CS_PLAYER_COMPARE, Data);
        Network.Send(MH.MDM_GF_GAME, FruitData.SUB_CS_COMPARE , buffer, gameSocketNumber.GameSocket);

        this.eState = E_STATE_COMPARE;
        FruitGameMain.ChangeBtnState(this.eState);

    elseif("ButtonAllIn" == btn.name) then
        FruitGameMain.OnClickBtnAddChip(btn);

    elseif("ButtonCancel" == btn.name) then
        FruitGameMain.ChangeCurrentChip(this.tabCurChip, -1);
        FruitGameMain.SetPlayChipImgNum(true, this.tabCurChip);
        FruitGameMain.SetPlayerGold(this.iMyGold, FruitResource.strTraMyGoldNum);

    elseif("ButtonOk" == btn.name) then
        FruitGameMain.OnclickBtnOk(btn);

    elseif("ButtonAuto" == btn.name) then
        FruitGameMain.OnClickBtnAuto(btn);

    else --chip list     
       FruitGameMain.OnClickBtnAddChip(btn);
    end

end

--按钮按下事件
function FruitGameMain.OnClickBtnDwon(btn)
    
    if(E_STATE_END ~= this.eState) then return; end
    logYellow("is btn down");

    this.bIsBtnDown = true;

    local iNum = 0;
    local iMaxNum = 3;

    local funTick = function ()
                        if("ButtonAdd" == btn.name) then
                            FruitGameMain.SetRateNumImg(this.iAddRate);
                        else
                            FruitGameMain.OnClickBtnAddChip(btn);
                        end
                        
                        if(iNum == iMaxNum) then
                             this.btnTimer:ChangeTickTime(D_TIME_BTN_TICK/10);
                        end
                        if(iNum <= iMaxNum) then
                            iNum = iNum + 1;
                        end

                    end

    local tab1 = { fun = funTick; args = FruitGameMain; }

    if(not this.btnTimer) then this.btnTimer = FruitGameTimer:New(); end

    this.btnTimer:SetTimer(D_TIME_NOT_LIMIT, true, FruitGameTimer.FruitTimerType.tick, D_TIME_BTN_TICK, tab1, nil);

end


function FruitGameMain.OnclickUpBtn(btn)
    if(not this.bIsBtnDown) then return; end
    logYellow("is up");
    this.bIsBtnDown = false;
    local funTimerEnd = function ()
                         end
    local tab2 = { fun = funTimerEnd; args = FruitGameMain; };
    this.btnTimer:SetTimer(D_TIME_NOT_LIMIT, false, FruitGameTimer.FruitTimerType.timint, 0, nil, tab2);

    if("ButtonOk" == btn.name and not this.bAuto) then
        FruitGameMain.SendGameBegin();
    end
end


function FruitGameMain.OnclickBtnOk(btn)
    
    if(E_STATE_RESULT ~= this.eState and E_STATE_END ~= this.eState) then return; end
    logYellow("on ok btn Down state  = " .. this.eState);
    this.bIsBtnDown = true;
    this.bUpbtnOk = false;
    local allTime = 1;
    local funTimerEnd = function ()
                            if(not this.bUpbtnOk) then
                                this.bAuto = true;
                                btn.transform.parent:Find("ButtonAuto").gameObject:SetActive(true);
                                FruitGameMain.SendGameBegin();
                            end
                        end

    local tab2 = { fun = funTimerEnd; args = FruitGameMain; }

    if(not this.btnTimer) then this.btnTimer = FruitGameTimer:New(); end

    this.btnTimer:SetTimer(allTime, true, FruitGameTimer.FruitTimerType.timint, 0, nil, tab2);
end


function FruitGameMain.OnClickBtnAuto(btn)
    btn = btn or this.traPanel:Find("Opearation/ButtonAuto");
    logYellow("on click auto state = " .. this.eState);
    FruitGameMain.SetAutoGameTimer(false);
    btn.gameObject:SetActive(false);
end


--加注
function FruitGameMain.OnClickBtnAddChip(btn)
    if(this.bAuto) then return; end

    local idx = nil;

    if("ButtonAllIn" ~= btn.name) then
        idx = btn.transform:GetSiblingIndex() + 1;
    end

    local bOkChange = FruitGameMain.ChangeCurrentChip(this.tabCurChip, 1, idx);
    FruitGameMain.SetPlayChipImgNum(true, this.tabCurChip);
    if(bOkChange) then
        if(not idx) then
            idx = 1;
        end
        FruitGameMain.PlayMusic(FruitResource.strChipMusic, idx - 1);

        this.iCopyGold = this.iMyGold - FruitGameMain.GetCurrateOnChip(this.iCurRate);
        FruitGameMain.SetPlayerGold(this.iCopyGold, FruitResource.strTraMyGoldNum);
    end

end


-----------------------公共方法--------------------------------

function FruitGameMain.PlayBjMusic(strName, idx)

    MusicManager:PlayBacksound(D_MUSIC_BJ_END, false); --停止背景音乐

    if(D_MUSIC_BJ_END == strName) then return; end

    if(not this.resMusic) then
        this.resMusic = LoadAsset(FruitResource.abMusicNameStr, FruitResource.strMusic);
    end
    
    local bJSource = this.resMusic.transform:Find(strName):GetChild(idx):GetComponent('AudioSource');

    if(bJSource) then
        MusicManager:PlayBacksoundX(bJSource.clip, true);
    end

end


function FruitGameMain.PlayMusic(sName, idx)
    if(not this.tabMusicBuf) then
        this.tabMusicBuf = {};
    end
    local comSource = nil;
    if(not this.resMusic) then
        this.resMusic = LoadAsset(FruitResource.abMusicNameStr, FruitResource.strMusic);
    end
    local source = this.resMusic.transform:Find(sName):GetChild(idx):GetComponent('AudioSource');   
    if(source) then
         comSource = MusicManager:PlayX(source.clip);
         table.insert(this.tabMusicBuf, comSource.gameObject);
    end
    return comSource;
end


--创建物体
function FruitGameMain.CreateGameObject(resObj, strName, traParent, ve3Pos)
    
    ve3Pos = ve3Pos or Vector3.New(0, 0, 0);

    local obj = newobject(resObj);
    if(strName) then
        obj.name = strName;
    end
    if(traParent) then
        obj.transform:SetParent(traParent);
    end
    obj.transform.localScale = Vector3.one;
    obj.transform.localPosition = ve3Pos;

    return obj;

end



--设置图片数字 bUseWord 是否使用 万 亿这些字
function FruitGameMain.SetNumImage(numInt, numTra, numBaseRes, bUseWord)
	
    if(toInt64(numInt) < toInt64(0) ) then  logYellow("！！！！！设置字体图片数值小于0！"); return; end

    local numStr = numInt .. "";
--    if(bUseWord) then
--        numStr = DragonSlotMain.GetNumberStr(numInt);
--    end

    local showNumStrTab = {}; --要显示的数字 字符串表

    for i = 1, #numStr do  
        table.insert(showNumStrTab, string.sub(numStr, i, i ) ); --将要显示的数字字符串存入showNumStrTab
    end

    local numsBeginCount = numTra.transform.childCount; --数字图片的初始个数

    for i = #showNumStrTab, numsBeginCount - 1 do -- 隐藏多余的图片
         numTra.transform:GetChild(i).gameObject:SetActive(false);
    end
    

    for i = 1, #showNumStrTab do
        
        local numChildTra; -- 数字图片物体子物体 

        if(i <= numsBeginCount) then --已经存在的直接改变图片
            numChildTra = numTra.transform:GetChild(i - 1);
        else --不存在的先创建
            numChildTra = FruitGameMain.CreateGameObject(numTra.transform:GetChild(0).gameObject, nil, numTra).transform;
        end

        numChildTra.gameObject:SetActive(true);

        local numRes;

        if(tonumber(showNumStrTab[i])) then --若是数字使用数字图片

            numRes = numBaseRes.transform:GetChild(tonumber(showNumStrTab[i] ) ); --要显示的图片资源

        else --否则使用文字图片
            
            --error("===当前数字字符 ：" .. showNumStrTab[i]);

            local findNameStr = "";

            if("." == showNumStrTab[i]) then
                findNameStr = "p";
            elseif("w" == showNumStrTab[i]) then
                findNameStr = "w";
            elseif("y" == showNumStrTab[i]) then
                findNameStr = "yi";
            end

            numRes = numBaseRes.transform:Find(findNameStr); --要显示的图片资源

        end
        if(numRes) then
            numChildTra.transform:GetComponent('Image').sprite = numRes.transform:GetComponent('Image').sprite;
        else
            logYellow("!!!!数字资源为null 资源名 = " .. findNameStr);
        end

    end

end


function FruitGameMain.handler(obj,func)
    return function(...)
        return func(obj,...);
    end
end