 --FruitGameBase.lua
--Date
--
--endregion


FruitGameBase = {};

local self = nil;

local E_MAIN_STATE_COUNT = 5;
local E_MAIN_END_COUNT = 10;
local E_BASE_RING = 3; --基础圈数

local E_WLHC_IMTE_COUNT = 5; --五列火车图标个数

local E_TIME_NOT_LIMIT = 600 --不限时间
local E_TIME_ROTATE = 8;-- 转动总时间
local E_TIME_STATE_ROTATE_S = {0.4, 0.3, 0.2, 0.1, 0.1}
local E_TIME_END_ROTATE_S = {0.3, 0.2, 0.1, 0.08, 0.07};
local E_TIME_END_ROTATE_S = {0.4, 0.3, 0.2, 0.1, 0.08};
local E_TIME_ALL_BASE = 3;--5; --基础总时间

local D_TIME_IMG_SHOW = 0.2; --图片闪动的时间
local D_TIME_SP_WAIT= 1.2; --特殊奖励等待时间
local D_TIME_SP_MOVE = 0.1; --特殊奖励单位运动时间
local D_TIME_SHOW_IMG = 0.5; --显示图片的时间

local D_TIME_COM_RATE = 3;
local D_TIME_COM_RATE = 2


local C_CHIPS = {[1] = {40, 30, 20}, [2] = {20, 15, 10}};

function FruitGameBase:New(o)
    local t = o or { };
    setmetatable(t, self);
    self.__index = self
    return t;
end

function FruitGameBase.Init(objCanvas, traParent, csJoinLua)
    self = FruitGameBase:New();
    --local resObj = LoadAsset(FruitResource.dbResNameStr, 'CanvasFruit');
    --local objCanvas = FruitGameMain.CreateGameObject(resObj, "CanvasFruit", traParent);
    self.transform = objCanvas.transform:Find("PanelBase");

    self.iCurMainIdx = 1; --当前转动的主图片id
    self.traMainRotate = self.transform:Find("GamePanel/OuterRotate");
    self.iCurSubIdx = 1; --当前子图片id
    self.traSubRotate = self.transform:Find("GamePanel/InnerRoTate");

    self.tabMainIMg = {};
    for i = 0, self.traMainRotate.childCount - 1 do
        table.insert(self.tabMainIMg, MainImgCtrl.Init(self.traMainRotate:GetChild(i), i) );
    end

    self.tabSubImg = {};
    for i = 0, self.traSubRotate.childCount - 1 do
        table.insert(self.tabSubImg, SubImgCtrl.Init(self.traSubRotate:GetChild(i), i) );
    end

    self.thisJP = SubImgCtrl.Init(self.transform:Find("GamePanel/ImageJP/ImageShowJP") )

    local traRate = self.transform:Find("Rate"); 
    local tabLRatesTra = {};
    local tabRRatesTra = {};
    for i = 0, traRate.childCount - 1 do
        if(i < traRate.childCount / 2) then
            table.insert(tabLRatesTra, traRate:GetChild(i):GetChild(0));
        else
            table.insert(tabRRatesTra, traRate:GetChild(i):GetChild(0));
        end
    end
    self.tabRateTras = {[1] = tabLRatesTra, [2] = tabRRatesTra};

    self.myTimer = FruitGameTimer:New();
    self.subRotTimer = FruitGameTimer:New(); --内圈图片转动定时器
    self.timerRate = FruitGameTimer:New();
    return self;
end


function FruitGameBase:Update()
    if(self.myTimer) then self.myTimer:timer(Time.deltaTime); end
    if(self.subRotTimer) then self.subRotTimer:timer(Time.deltaTime); end
    if(self.timerRate) then self.timerRate:timer(Time.deltaTime); end
    if(#self.tabMainIMg > 0) then
        for i = 1, #self.tabMainIMg do
            self.tabMainIMg[i]:Update();
        end
    end
    if(#self.tabSubImg > 0) then
        for i = 1, #self.tabSubImg do
            self.tabSubImg[i]:Update();
        end
    end
    if(self.timerLight) then self.timerLight:timer(Time.deltaTime); end
    if(self.thisJP) then self.thisJP:Update(); end
end

--游戏开始
function FruitGameBase.GameBegin(tabImgId, tabRates)
    local eGameType, iMainEndIdx, iSubEndIdx = FruitGameBase.GetEndImgId(tabImgId);
    self.eGameType = eGameType;
    for i = 1, #tabRates do
        logYellow("xxxxxxxxxxxxxxxxtab rate = " .. tabRates[i]);
    end
    FruitGameBase.GameRotateBegin(iMainEndIdx, iSubEndIdx, tabRates);
end

--获取运动的终点图片id
function FruitGameBase.GetEndImgId(tabImgId)
    local eGameType = FruitData.E_NOT_IMG;
    local iMainId = FruitData.E_NOT_IMG;
    local iSubId = FruitData.E_NOT_IMG;
    local tabGiveImgId = {}; --luck中的奖励

    for i = 1, #tabImgId do
        logYellow("xxxxxxxxxxxxxImg id = " .. tabImgId[i]);
    end

    for i = 1, #tabImgId do
        if(1 == i) then
            if( FruitData.E_NOT_IMG == tabImgId[i] or FruitData.E_CAP == tabImgId[i] )  then --进入luck 0倍数
                eGameType = FruitData.E_GIVE_LIGHT;
                iMainId = math.random (FruitData.E_LUCK_GOLD , FruitData.E_LUCK_BULE);
                --logYellow("xxxxxluck id = " .. iMainId);
                iSubId = FruitData.E_CAP;
                break;
            elseif(tabImgId[i] < FruitData.E_CAP) then
                iMainId = tabImgId[i];
                logYellow("Main id is " .. iMainId);
                if(tabImgId[i] >= FruitData.E_LUCK_GOLD and tabImgId[1] <= FruitData.E_LUCK_BULE) then --进入luck
                    iSubId = FruitData.E_CAP;
                    if(FruitData.E_NOT_IMG == tabImgId[i + 1] or FruitData.E_CAP == tabImgId[i + 1]) then  --0倍数
                        eGameType = FruitData.E_GIVE_LIGHT;
                        break;
                    else
                       eGameType = FruitData.E_GIVE_LIGHT;
                       table.insert(tabGiveImgId, tabImgId[i+1]); 
                    end
                else --普通游戏
                    logYellow("普通游戏 ");
                    break;
                end
            elseif(tabImgId[i] > FruitData.E_CAP) then --特殊奖励
                eGameType = tabImgId[i];
                iMainId = FruitData.E_NOT_IMG;
                iSubId = tabImgId[i];
                logYellow("iSubId = " .. iSubId);
                break;
            end
        elseif(i > 2)then
            if(FruitData.E_NOT_IMG == tabImgId[i]) then
                break;
            elseif(FruitData.E_GIVE_LIGHT == eGameType) then
                table.insert(tabGiveImgId, tabImgId[i]); 
            end    
        end
    end

    return eGameType, FruitGameBase.GetEndImgGridId(eGameType, iMainId, iSubId, tabGiveImgId);

end

--获取 最终图片的格子id
function FruitGameBase.GetEndImgGridId(eGameType, iMainId, iSubId, tabGiveImgId)

    local iMainGridId = 1;
    local iSubGridId = 1;
    logYellow("game type = " .. eGameType);
    if(eGameType > FruitData.E_CAP and eGameType < FruitData.E_GIVE_LIGHT) then
        for i = 1, #FruitData.C_SUB_IMG do
            if(iSubId == FruitData.C_SUB_IMG[i]) then
                iSubGridId = i;   
            end
        end
 
        return iMainGridId, iSubGridId; 
    else
--        local iR = math.random(1 , 2);
--        if(iR > 1) then
--            iSubGridId = #FruitData.C_SUB_IMG / 2 + 1;
--        end
        iSubGridId = 1;
    end

    self.tabGiveImgGridId = {};
    
    local tabMainGrids = {}

    for i = 1, #FruitData.C_MAIN_IMGS do
        if(iMainId == FruitData.C_MAIN_IMGS[i]) then
            --logYellow("maind = " .. C_MAIN_IMGS[i]);
            table.insert(tabMainGrids, i);
        end
    end
    local idx = math.random (1 , #tabMainGrids)
    iMainGridId = tabMainGrids[idx];

    if(#tabGiveImgId > 0) then --有送灯
        
        local C_NULL = -1; --无效值
        local tabTempMainImgs = {}; --零时存储每个格子上的图片
        for i = 1, #FruitData.C_MAIN_IMGS do
            tabTempMainImgs[i] =  FruitData.C_MAIN_IMGS[i];
        end

        for i = 1, #tabGiveImgId do
            tabMainGrids = {};
            for j = 1, #tabTempMainImgs do
                if(tabGiveImgId[i] == tabTempMainImgs[j]) then
                   table.insert(tabMainGrids, j); 
                   --logYellow("j = " .. j);
                end
            end
            local idx = math.random (1 , #tabMainGrids);
            tabTempMainImgs[tabMainGrids[idx] ] = C_NULL;
            --logYellow("idx = " .. idx .. "__grid = " .. tabMainGrids[idx]);
            table.insert(self.tabGiveImgGridId, tabMainGrids[idx]);
        end
    end

    logYellow("m grid = " .. iMainGridId .. "__s grid = " .. iSubGridId);
    return iMainGridId, iSubGridId;

end

--开始转动
function FruitGameBase.GameRotateBegin(iMainEndIdx, iSubEndIdx, tabRates)
    logYellow("self.eGameType = " .. self.eGameType);
    self.hlhcRate = tabRates[3]; --五列火车倍数
    self.thisJP:PlayAnimation();
    logYellow("sub idx == " .. iSubEndIdx);
    if(self.eGameType > FruitData.E_CAP and self.eGameType < FruitData.E_GIVE_LIGHT) then
        FruitGameBase.SpecialEffect();
        FruitGameBase.SubImgRotateBegin(iSubEndIdx);
    else   
        FruitGameBase.MainImgRotateBegin(iMainEndIdx);
    end
    --FruitGameBase.SubImgRotateBegin(iSubEndIdx);
    local tabVar = {[1] = tabRates[1], [2] = tabRates[2]}
    FruitGameBase.RateRotate(true, tabVar);
end

--主图片转动
function FruitGameBase.MainImgRotateBegin(iMainEndIdx)
    
    FruitGameMain.PlayBjMusic(FruitResource.strRotateMusic, 0); 

    self.tabMainIMg[self.iCurMainIdx]:ShowImage(true);

    itempMainEnd = FruitGameBase.GetMoveItemCount(#self.tabMainIMg, self.iCurMainIdx, iMainEndIdx);

    local tabMainEnd = 
    {
        bMainImg = true;
        tabImg = self.tabMainIMg;
        iEndidx = iMainEndIdx;
    }

    local tabMain2 = { fun = FruitGameBase.ImageRotateEnd; args = tabMainEnd; }

    local tabMainVar = 
    {
        tabImg = self.tabMainIMg;
        bMainImg = true;
        timerThis = self.myTimer;
        iEndIdx = iMainEndIdx;
        iAllCount = #self.tabMainIMg * E_BASE_RING + itempMainEnd;
        tempCount = 0;
        iCount = 0; 
        tabTimeEnd = tabMain2;
    }

    local tabMain1 = { fun = FruitGameBase.ImageRotate; args = tabMainVar; } 
    self.myTimer:SetTimer(E_TIME_NOT_LIMIT, true, FruitGameTimer.FruitTimerType.tick, E_TIME_STATE_ROTATE_S[1], tabMain1, nil);

end


--子图片转动
function FruitGameBase.SubImgRotateBegin(iSubEndIdx)

    self.tabSubImg[self.iCurSubIdx]:ShowImage(true);

    iTempSubEnd = FruitGameBase.GetMoveItemCount(#self.tabSubImg, self.iCurSubIdx, iSubEndIdx);

    local tabSubEnd = 
    {
        bMainImg = false;
        tabImg = self.tabSubImg;
        iEndidx = iSubEndIdx;
    }
    
    local tabSub2 = { fun = FruitGameBase.ImageRotateEnd; args = tabSubEnd; }

    local tabSubVar = 
    {
        tabImg = self.tabSubImg;
        bMainImg = false;
        timerThis = self.subRotTimer;
        iEndIdx = iSubEndIdx;
        iAllCount = #self.tabSubImg * 2 * E_BASE_RING  + iTempSubEnd;
        tempCount = 0;
        iCount = 0; 
        tabTimeEnd = tabSub2;
    }

  
    local tabSub1 = { fun = FruitGameBase.ImageRotate; args = tabSubVar; }
    self.subRotTimer:SetTimer(E_TIME_NOT_LIMIT, true, FruitGameTimer.FruitTimerType.tick, E_TIME_STATE_ROTATE_S[1], tabSub1, nil);
end


--local tabSubVar = 
--{
--tabImg = self.tabSubImg;
--    bMainImg = false;
--    timerThis = self.subRotTimer;
--    iEndIdx = iSubEndIdx;
--    iAllCount = #self.tabSubImg * 2 * E_BASE_RING  + iSubEndIdx;
--    tempCount = 0;
--    iCount = 0; 
--tabTimeEnd = tabSub2;
--bWLHC   是否五列火车
--iWLHCIdx = self.iCurMainIdx; 
--}
function FruitGameBase.ImageRotate(tabVar)
    
    --logYellow("iCount " .. tabVar.iCount);
    tabVar.iCount = tabVar.iCount + 1;
    if(tabVar.iCount < tabVar.iAllCount) then
        if(tabVar.bWLHC) then
            tabVar.iWLHCIdx = FruitGameBase.ChangeShowImg(tabVar.tabImg, tabVar.iWLHCIdx, tabVar.bWLHC);
            --logYellow("wlhc id " .. tabVar.iWLHCIdx);
        elseif(tabVar.bMainImg) then
            self.iCurMainIdx = FruitGameBase.ChangeShowImg(tabVar.tabImg, self.iCurMainIdx);
        else
            self.iCurSubIdx = FruitGameBase.ChangeShowImg(tabVar.tabImg, self.iCurSubIdx);
        end
    end
    if(tabVar.iCount < E_MAIN_STATE_COUNT) then
        
--        if(1 == tabVar.iCount and tabVar.bMainImg and not tabVar.bWLHC) then
--            FruitGameMain.PlayBjMusic(FruitResource.strRotateMusic, 0); 
--        end

        tabVar.timerThis:ChangeTickTime(E_TIME_STATE_ROTATE_S[tabVar.iCount]);
    elseif(tabVar.iCount == E_MAIN_STATE_COUNT) then
        --logYellow("iCount change 1" .. tabVar.iCount);
        if(tabVar.bMainImg and not tabVar.bWLHC ) then
            FruitGameMain.PlayBjMusic(FruitResource.strRotateMusic, 1);
        end
        tabVar.tempCount = tabVar.iAllCount - tabVar.iCount - E_MAIN_END_COUNT;
        tabVar.timerThis:ChangeTickTime(E_TIME_ALL_BASE/tabVar.tempCount);
        
        --logYellow("time = " .. E_TIME_ALL_BASE/tabVar.tempCount );
    elseif(tabVar.iCount >= tabVar.tempCount + E_MAIN_STATE_COUNT and tabVar.iCount < tabVar.iAllCount - 1) then
        
        if(tabVar.tempCount + E_MAIN_STATE_COUNT == tabVar.iCount and tabVar.bMainImg and not tabVar.bWLHC) then
            FruitGameMain.PlayBjMusic("end");
            FruitGameMain.PlayMusic(FruitResource.strRotateMusic, 2);
        elseif(tabVar.iCount == tabVar.iAllCount - 2 and not tabVar.bMainImg and not tabVar.bWLHC ) then
            if(self.eGameType > FruitData.E_CAP and self.eGameType < FruitData.E_GIVE_LIGHT) then --停止特殊奖开始前的动画
                FruitGameBase.PlaySPMusic(false, true, true);
            end
        end

        local idx = tabVar.iAllCount - 1 - tabVar.iCount;
        if(idx > #E_TIME_END_ROTATE_S) then
            idx = #E_TIME_END_ROTATE_S;
        elseif(idx < 1) then
            idx = 1;
        end
        if(idx > 1 ) then
            tabVar.timerThis:ChangeTickTime(E_TIME_END_ROTATE_S[idx] );
        end
        --logYellow("time2 = " .. E_TIME_STATE_ROTATE_S[idx] );
    elseif(tabVar.iCount == tabVar.iAllCount - 1) then
        tabVar.timerThis:SetTimer(E_TIME_NOT_LIMIT, false, FruitGameTimer.FruitTimerType.tick, 0, nil, tabVar.tabTimeEnd);
        if(tabVar.bMainImg and not tabVar.bWLHC) then
            --FruitGameMain.PlayBjMusic("end");
            FruitGameMain.PlayMusic(FruitResource.strRotateMusic, 3);
        end
    end

end


--    local tabVar = 
--    {
--        bMainImg = true;
--        tabImg = self.tabMainIMg;
--        iEndidx = iMainEndIdx;
--    }
function FruitGameBase.ImageRotateEnd(tabVar)
    logYellow("rotate is end");
    local idx = 0;
    if(tabVar.bMainImg) then
        idx = self.iCurMainIdx;
        self.iCurMainIdx = tabVar.iEndidx;
    else
        idx = self.iCurSubIdx;
        self.iCurSubIdx = tabVar.iEndidx;
    end
    tabVar.tabImg[idx]:ShowImage(false);
    tabVar.tabImg[tabVar.iEndidx]:ShowImage(true);
    --tabVar.tabImg[tabVar.iEndidx]:PlayAnimation();
    FruitGameBase.PlayAnimation(true, tabVar.bMainImg, tabVar.tabImg, tabVar.iEndidx);


    if(tabVar.bMainImg and FruitData.E_GIVE_LIGHT == self.eGameType) then
        FruitGameBase.SpecialBegin();
    elseif(self.eGameType > FruitData.E_CAP and self.eGameType < FruitData.E_GIVE_LIGHT) then
        FruitGameBase.SpecialBegin();
    elseif(tabVar.bMainImg and self.eGameType < FruitData.E_CAP) then
        FruitGameBase.RotateEnd();
    end
end

----倍数转动
--function FruitGameBase.RateRotate_(tabRate)
--    for i = 1, #self.tabRateTras do
--        for j = 1, #self.tabRateTras[i] do

--        end
--    end
--end

--倍数转动
function FruitGameBase.RateRotate(bRotate,tabRate)
    
    local tab1 = nil;
    local tab2 = nil;

    if(bRotate) then
        local bHaveRate = true;
        if(tabRate[1] <= 0) then
            bHaveRate = false;
        end

        local tabEndIdx = {3, 3};
        for i = 1, #C_CHIPS do
            for j = 1, #C_CHIPS[i] do
                if(tabRate[i] == C_CHIPS[i][j]) then
                    tabEndIdx[i] = j;
                    break;
                end
            end
        end 
        
        local tabAllCount = {};
        local tabCurIdx = {};
        local tabTempCount = {};
        local tabCount = {};
        for i = 1, #self.tabRateTras do
            tabCurIdx[i] = 1;
            self.tabRateTras[i][1].gameObject:SetActive(true);
            local itempEnd = FruitGameBase.GetMoveItemCount(#self.tabRateTras[i], tabCurIdx[i], tabEndIdx[i]);
            tabAllCount[i] = #self.tabRateTras[i] * 8 * E_BASE_RING  + itempEnd;
            tabTempCount[i] = 0;
            tabCount[i] = 0;
        end
        local tabIdx = {1, 1};
        local bChangeTime = false;
        local bShow = false;
        local funTick = function ()
                            
                            for i = 1, #self.tabRateTras do
                                tabCount[i] = tabCount[i] + 1;
                                if(tabCount[i] < tabAllCount[i]) then
                                   self.tabRateTras[i][tabIdx[i] ].gameObject:SetActive(false);
                                   tabIdx[i] = tabIdx[i] + 1;
                                   if(tabIdx[i] > #self.tabRateTras[i]) then
                                        tabIdx[i] = 1;
                                   end
                                   self.tabRateTras[i][tabIdx[i] ].gameObject:SetActive(true);
                                end
                                if(tabCount[i] < E_MAIN_STATE_COUNT) then
                                    self.timerRate:ChangeTickTime(E_TIME_STATE_ROTATE_S[tabCount[i]]);
                                elseif(tabCount[i] == E_MAIN_STATE_COUNT) then
                                    tabTempCount[i] = tabAllCount[i] - tabCount[i] - E_MAIN_END_COUNT;
                                    if(1 == i) then
                                        self.timerRate:ChangeTickTime(E_TIME_ALL_BASE/tabTempCount[i]);
                                    end
                                elseif(tabCount[i] == tabTempCount[i] + E_MAIN_STATE_COUNT) then
                                    if(not bChangeTime) then
                                        self.timerRate:ChangeTickTime(0.1);
                                        bChangeTime = true;
                                    end
                                elseif(tabCount[i] == tabAllCount[i] - 1 ) then
                                    self.tabRateTras[i][tabIdx[i]].gameObject:SetActive(false);
                                    self.tabRateTras[i][tabEndIdx[i] ].gameObject:SetActive(true);
                                                                  
                                    if(not bShow) then
                                        self.timerRate:ChangeTickTime(D_TIME_IMG_SHOW);  
                                    end
                                    bShow = true;
                                   
                                end

                                if(bShow) then
                                    self.tabRateTras[i][tabEndIdx[i] ].gameObject:SetActive(not self.tabRateTras[i][tabEndIdx[i] ].gameObject.activeSelf);
                                    if(not bHaveRate) then
                                        FruitGameBase.RateRotate(false);
                                    end 
                                end
                            end  
                                                 
                        end

        local funTimerEnd = function ()
                                --logYellow("Rate is End");
                                for i = 1, #self.tabRateTras do
                                    --logYellow("i = " .. i .. "  end idx = " .. tabEndIdx[i]);
                                    self.tabRateTras[i][tabEndIdx[i] ].gameObject:SetActive(false);
                                end
                            end

        tab1 = { fun = funTick; args = FruitGameBase; };
        tab2 = { fun = funTimerEnd; args = FruitGameBase; } ;

    end

    
    self.timerRate:SetTimer(E_TIME_NOT_LIMIT, bRotate, FruitGameTimer.FruitTimerType.tick, E_TIME_STATE_ROTATE_S[1], tab1, tab2);
end


--特殊奖效果
function FruitGameBase.SpecialEffect()
    FruitGameBase.PlaySPMusic(true);
    --FruitGameBase.PlayLightAnim(true);
    self.tabMainIMg[self.iCurMainIdx]:ShowImage(false);
    for i = 1, #self.tabMainIMg do
        if(i % 2 ~= 0) then
            --self.tabMainIMg[i]:PlayAnimation();
            FruitGameBase.PlayAnimation(true, true, self.tabMainIMg, i, true);
        end
    end

    local funTimerEnd = function ()
                            for i = 1, #self.tabMainIMg do
                                if(i % 2 == 0) then
                                    --self.tabMainIMg[i]:PlayAnimation();
                                    FruitGameBase.PlayAnimation(true, true, self.tabMainIMg, i, true);
                                end
                            end
                        end

    local tab2 = { fun = funTimerEnd; args = FruitGameBase; }
    self.myTimer:SetTimer(D_TIME_IMG_SHOW, true, FruitGameTimer.FruitTimerType.timint, 0, nil, tab2);
end

--特殊奖励开始
function FruitGameBase.SpecialBegin()
    logYellow("game type = " .. self.eGameType );
    if(self.eGameType <= FruitData.E_CAP) then return; end
    logYellow("FruitData.E_GIVE_LIGHT = " .. FruitData.E_GIVE_LIGHT);
    local tabVar = nil;

    if(FruitData.E_GIVE_LIGHT ~= self.eGameType) then
        FruitGameBase.PlayAnimation(false, true); --停止主图片转动
    else
        self.thisJP:ChangeAnimtionTime(0.01);
        --FruitGameBase.PlayLightAnim(true, true); --播放送灯时的 闪灯动画
    end

    if(FruitData.E_XSY == self.eGameType) then      --小三元
        logYellow("xiao san yuan");
        tabVar = FruitData.C_XSY_GRID_IDS;

    elseif(FruitData.E_DSY == self.eGameType) then      --大三元
        logYellow("da san yuan");
        tabVar = FruitData.C_DSY_GRID_IDS;

    elseif(FruitData.E_DSX == self.eGameType) then      --大四喜
        logYellow("da si xi");
        tabVar = FruitData.C_DSX_GRID_IDS;

    elseif(FruitData.E_ZHSH == self.eGameType) then     --纵横四海
        logYellow("zong heng si hai");
        tabVar = FruitData.C_ZHSH_GRID_IDS;

    elseif(FruitData.E_WLHC == self.eGameType) then     --五列火车
        logYellow("wu lie huo che");
        FruitGameBase.WLHCRotate(self.hlhcRate); --C_RATES_WLHC[3]为测试

    elseif(FruitData.E_LLDS == self.eGameType) then     --六六大顺
        logYellow("liu liu da shun");
        tabVar = FruitData.C_LLDS_GRID_IDS;

    elseif(FruitData.E_XNSH == self.eGameType) then     --仙女散花
        logYellow("xian nv san hua");
        tabVar = FruitData.C_XNSH_GRID_IDS;

    elseif(FruitData.E_TLBB == self.eGameType) then     --天龙八部
        logYellow("tian long ba bu");
        tabVar = FruitData.C_TLBB_GRID_IDS;

    elseif(FruitData.E_DMG == self.eGameType) then      --大满堂
        logYellow("da man guan");
         for i = 1, #self.tabMainIMg do
            FruitGameBase.PlayAnimation(true, true, self.tabMainIMg, i, true);
        end
        FruitGameBase.RotateEnd();

    elseif(FruitData.E_GIVE_LIGHT == self.eGameType) then -- 送灯
        logYellow("give light");
        tabVar = self.tabGiveImgGridId;
    end

    if(tabVar) then
        if(FruitData.E_GIVE_LIGHT ~= self.eGameType) then
            local tab2 = { fun = FruitGameBase.SpecialRotate; args = tabVar; }
            self.myTimer:SetTimer(0.5, true, FruitGameTimer.FruitTimerType.timint, 0, nil, tab2);
        else
            FruitGameBase.SpecialRotate(tabVar);
        end 
        --FruitGameBase.SpecialRotate(tabVar);
    end
end

--改变特殊奖图片位置
function FruitGameBase.ChangeSpImgPos(tab)
    
    local tabTemp = {};

    for i = 1, #tab do
        tabTemp[i] = tab[i];
    end

    local index, iTempGrid;

    for i = 1, #tabTemp do
        index = math.random (1 , #tabTemp);
        if(index ~= i ) then
            iTempGrid = tabTemp[i];
            tabTemp[i] = tabTemp[index];
            tabTemp[index] = iTempGrid;
        end
    end

    return tabTemp;

end

--特殊奖励转动
function FruitGameBase.SpecialRotate(tab)
   
    self.tabMainIMg[self.iCurMainIdx]:ShowImage(true);

    local tabItemGrids = FruitGameBase.ChangeSpImgPos(tab);
    local idx = 1;
    local bResetTime = true;
    local bEndMusic = false;
    local bPlayLostMusic = false;
    --local C_TIME_PLAY_MUSIC = 2;
    local C_TIME_BEGIN_TICK = 0.7;
    local iGrid = 1;

    local iCurIdx = self.iCurMainIdx;

    local funTick = function ()

                        if(bResetTime) then
                            logYellow("reset time");
                            self.thisJP:ChangeAnimtionTime();       
                            if(#tabItemGrids <= 0) then
                                logYellow("not gold ");
                                if(not bPlayLostMusic) then
                                    FruitGameBase.PlayWinAwardMusic(true)
                                    bPlayLostMusic = true;
                                else
                                    self.myTimer:SetTimer(0, false, FruitGameTimer.FruitTimerType.tick, 0, nil, nil);
                                    FruitGameBase.RotateEnd(true,true);
                                end
                                return;
                            end
                            self.myTimer:ChangeTickTime(C_TIME_BEGIN_TICK);  
                            --self.myTimer:ChangeTickTime(D_TIME_SP_MOVE);      
                            FruitGameBase.PlaySPMusic(true);
                            bEndMusic = true;
                            bResetTime = false;    
                            return;
                       elseif(bEndMusic) then
                            --FruitGameMain.PlayBjMusic("end");
                            self.myTimer:ChangeTickTime(D_TIME_SP_MOVE);
                            bEndMusic = false;                     
                        end

                        if(idx <= #tabItemGrids) then
                            iCurIdx = FruitGameBase.ChangeShowImg(self.tabMainIMg, iCurIdx);
                            if(FruitData.E_GIVE_LIGHT ~= self.eGameType) then self.iCurMainIdx = iCurIdx end
                        end
                      
                        if(iCurIdx == tabItemGrids[idx] and idx <= #tabItemGrids) then
                            logYellow("with time");
                            if(#tabItemGrids == idx) then
                                FruitGameBase.PlaySPMusic(false, true);
                            else
                                FruitGameBase.PlaySPMusic(false);
                            end
                            self.tabMainIMg[iCurIdx]:SetIsGiveLight(true);
                            self.myTimer:ChangeTickTime(D_TIME_SP_WAIT);
                            if(FruitData.E_GIVE_LIGHT == self.eGameType) then iCurIdx = self.iCurMainIdx; end
                            idx = idx + 1;
                            bResetTime = true;
                        end

                        if(idx > #tabItemGrids) then
                            if(1 == iGrid) then
                                bResetTime = false;
                                self.myTimer:ChangeTickTime(D_TIME_SP_WAIT);
                            end
                            --logYellow("grid = " .. iGrid);
                            if(iGrid <= #tabItemGrids) then
                                FruitGameBase.PlayAnimation(true, true, self.tabMainIMg, tabItemGrids[iGrid]);
                            else
                                logYellow("SP Is end");
                                FruitGameBase.RotateEnd();
                                self.myTimer:SetTimer(0, false, FruitGameTimer.FruitTimerType.tick, 0, nil, nil);
                            end
                            iGrid = iGrid + 1;
                        end
                    end
    local tab1 = { fun = funTick; args = FruitGameBase; }
    self.myTimer:SetTimer(E_TIME_NOT_LIMIT, true, FruitGameTimer.FruitTimerType.tick, C_TIME_BEGIN_TICK, tab1, nil);
end

--五列火车转动
function FruitGameBase.WLHCRotate(iRate)
    
    FruitGameMain.PlayMusic(FruitResource.strWu, 0);

    local iEndidx = FruitData.C_WLHC_GRIDS[1];
    for i = 1, #FruitData.C_RATES_WLHC do
        if(FruitData.C_RATES_WLHC[i] == iRate) then
            iEndidx = FruitData.C_WLHC_GRIDS[i];
            break;
        end
    end 

    

    self.tabMainIMg[self.iCurMainIdx]:ShowImage(true);
    local tabMainVar = {};
    local itempEnd = FruitGameBase.GetMoveItemCount(#self.tabMainIMg, self.iCurMainIdx + 4, iEndidx);

    local funRotateEnd = function ()
                            logYellow("wu lie huoche is end = ");
                            local iCurIdx = tabMainVar.iWLHCIdx;
                            --FruitGameBase.PlayAnimation(true, true, self.tabMainIMg, iCurIdx);
                            local iGrid = iCurIdx; -- - 1;
                            local funTick = function (args)
                                                --logYellow("iGrid = " .. iGrid .. "__all = " .. iCurIdx - (E_WLHC_IMTE_COUNT - 1) );
                                                if(iGrid < iCurIdx - (E_WLHC_IMTE_COUNT - 1) ) then
                                                    self.myTimer:SetTimer(E_TIME_NOT_LIMIT, false, FruitGameTimer.FruitTimerType.tick, 0, nil, nil);
                                                    self.iCurMainIdx = iCurIdx;
--                                                    for i = iCurIdx, iCurIdx - (E_WLHC_IMTE_COUNT - 1), -1 do
--                                                        logYellow("i is = " .. i);
--                                                        self.tabMainIMg[i]:StopAnimation();  --停止动画并重新播放 为了保持动画统一
--                                                        self.tabMainIMg[i]:PlayAnimation();
--                                                    end
                                                    FruitGameBase.RotateEnd();
                                                else
                                                    if(iGrid == iCurIdx) then self.myTimer:ChangeTickTime(D_TIME_SP_WAIT); end
                                                    FruitGameBase.PlayAnimation(true, true, self.tabMainIMg, iGrid);
                                                end
                                                iGrid = iGrid - 1;
                                             end
                            local tab = { fun = funTick; args = FruitGameBase; }
                            self.myTimer:SetTimer(E_TIME_NOT_LIMIT, true, FruitGameTimer.FruitTimerType.tick, 0.02, tab, nil);
                      end
    local tab2 = { fun = funRotateEnd; args = FruitGameBase; }

    tabMainVar = 
    {
        tabImg = self.tabMainIMg;
        bMainImg = true;
        timerThis = self.myTimer;
        iEndIdx = iEndidx;
        iAllCount = #self.tabMainIMg * E_BASE_RING  + itempEnd;
        tempCount = 0;
        iCount = 0; 
        tabTimeEnd = tab2;
        bWLHC = true;
        iWLHCIdx = self.iCurMainIdx;
    }

    local bInitEnd = false;
    local iInitCount = 1; -- 初始个数
    local funTick = function ()
                          if(not bInitEnd and iInitCount < E_WLHC_IMTE_COUNT ) then -- tabMainVar.iWLHCIdx < self.iCurMainIdx + E_WLHC_IMTE_COUNT - 1) then  
                              iInitCount = iInitCount + 1;
                              tabMainVar.iWLHCIdx = tabMainVar.iWLHCIdx + 1;
                              if(tabMainVar.iWLHCIdx > #self.tabMainIMg) then
                                tabMainVar.iWLHCIdx = 1;
                              end  
                              self.tabMainIMg[tabMainVar.iWLHCIdx]:ShowImage(true);
                          else
                              if(not bInitEnd) then bInitEnd = true; end
                              FruitGameBase.ImageRotate(tabMainVar);
                          end        
                    end

    local tab1 = { fun = funTick; args = FruitGameBase; }
    self.myTimer:SetTimer(E_TIME_NOT_LIMIT, true, FruitGameTimer.FruitTimerType.tick, D_TIME_SHOW_IMG, tab1, nil);
end


--改变显示的图片
function FruitGameBase.ChangeShowImg(tabImg, idx, bWLHC)
    
    if(bWLHC) then 
        local iTempIdx = idx - (E_WLHC_IMTE_COUNT - 1);
        if(iTempIdx <= 0) then
            iTempIdx = #tabImg + iTempIdx;
        end
        idx = idx + 1;
        if(idx > #tabImg) then
            idx = 1;
        end
        tabImg[iTempIdx]:ShowImage(false);
        tabImg[idx]:ShowImage(true);
        return idx;
    end

    tabImg[idx]:ShowImage(false);
    idx = idx + 1;
    if(idx > #tabImg) then
        idx = 1;
    end
    tabImg[idx]:ShowImage(true);
    return idx;
end

--获取运动的item总个数 iBaseCount 基础长度, iCurIdx 当前坐标, iEndIdx 终点坐标
function FruitGameBase.GetMoveItemCount(iBaseCount, iCurIdx, iEndIdx)
    --logYellow("end idx = " .. iEndIdx);
    local itempEnd = 0;
    if(iEndIdx >= iCurIdx) then
        itempEnd = iEndIdx - iCurIdx + 1;
    else
        itempEnd = iBaseCount -  (iCurIdx - iEndIdx) + 1;
    end
    return itempEnd;
end

--播放动画 bNotPlayMusic 是否不播放声音
function FruitGameBase.PlayAnimation(bPlay, bMainImg, tab, idx, bNotPlayMusic, iTime)
    
    if(not self.tabMainAnim) then self.tabMainAnim = {}; end
    if(not self.tabSubAnim) then self.tabSubAnim = {}; end
    
    if(bPlay) then
        tab[idx]:PlayAnimation(iTime, bNotPlayMusic);
        if(bMainImg) then
            table.insert(self.tabMainAnim, tab[idx]);
        else
            table.insert(self.tabSubAnim, tab[idx]);
        end
    else
        if(bMainImg) then
            for i = 1, #self.tabMainAnim do
                self.tabMainAnim[i]:StopAnimation();
            end
            self.tabMainAnim = {};
        else
            self.thisJP:StopAnimation();
            for i = 1, #self.tabSubAnim do
                self.tabSubAnim[i]:StopAnimation();
            end
            self.tabSubAnim = {};
        end
    end

end

--播放闪灯动画 暂时不播
function FruitGameBase.PlayLightAnim(bPlay, bGiveLight)
    
    local tab1 = nil;
    local tab2 = nil;

    if(bPlay) then
        local tabLightTra = {}
        local traLight = self.transform:Find("Light");
        for i = 0, traLight.childCount - 1 do
            if("ImageLightTop" == traLight:GetChild(i).name) then
                if(not bGiveLight) then
                    table.insert(tabLightTra, traLight:GetChild(i):GetChild(0) );
                end
            else
                table.insert(tabLightTra, traLight:GetChild(i):GetChild(0) );
            end
        end        
        local funTimerBack = function (bEnd)
                            
                            for i = 1, #tabLightTra do
                                if(bEnd) then
                                    logYellow("is end light");
                                    tabLightTra[i].gameObject:SetActive(false);
                                else
                                   tabLightTra[i].gameObject:SetActive(not tabLightTra[i].gameObject.activeSelf); 
                                end
                            end
                        end
        tab1 = { fun = funTimerBack; args = false; };
        tab2 = { fun = funTimerBack; args = true; };    
    end

    if(not self.timerLight) then
        self.timerLight = FruitGameTimer:New();
    end
    self.timerLight:SetTimer(E_TIME_NOT_LIMIT, bPlay, FruitGameTimer.FruitTimerType.tick, D_TIME_IMG_SHOW, tab1, tab2);
end

--播放胜利音效
function FruitGameBase.PlayWinAwardMusic(bLost)
    local iMusicSize = 11;
    local iRand = 0;
    if(bLost) then
        iRand = iMusicSize;
        FruitGameMain.PlayMusic(FruitResource.strWinAwardMusic, iRand);
    else
        iRand = math.random(0 , iMusicSize - 1);
        self.objWinSource = FruitGameMain.PlayMusic(FruitResource.strWinAwardMusic, iRand).gameObject;
    end
    
end

--播放特殊奖中奖转动音效 bSPBeginEnd 是否是特殊奖励开始时的音效播放结束
function FruitGameBase.PlaySPMusic(bStart, bOver, bSPBeginEnd)
    
    local iMusicSize = 0;

    if(bStart) then
        iMusicSize = 10;
        if(not self.iStartRand) then
            self.iStartRand = math.random(0 , iMusicSize - 1);
        end
        FruitGameMain.PlayBjMusic(FruitResource.strSPStartMusic, self.iStartRand);
    else
        FruitGameMain.PlayBjMusic("end");
        if(not bSPBeginEnd) then
            iMusicSize = 5;
            if(not self.iEndRand) then
                self.iEndRand = math.random(0 , iMusicSize - 1);
            end
            FruitGameMain.PlayMusic(FruitResource.strSPEndMusic, self.iEndRand);
        end
        if(bOver) then self.iStartRand = nil; self.iEndRand = nil; end
    end

end

--播放比倍输赢音效
function FruitGameBase.PlayComRateMusic(bWin)
    local sMusicName = "";
    local iMusicSize = 0;
    local iRand = 0;
    if(bWin) then
        iMusicSize = 5;
        sMusicName = FruitResource.strComWinMusic;
    else
        iMusicSize = 2;
        sMusicName = FruitResource.strComLostMusic;  
    end
    iRand = math.random(0 , iMusicSize - 1);
    --logYellow("size = " .. iMusicSize .. " __rand = " .. iRand);
    FruitGameMain.PlayMusic(sMusicName, iRand);
end

--转动结束
function FruitGameBase.RotateEnd(bLost, bResult)
    if(not bLost) then
        FruitGameBase.PlayWinAwardMusic(bLost);
    end
    FruitGameMain.ShowResult(nil, false, bResult);
end

--比倍
function FruitGameBase.ComRate(iNumber)
    local resNum = LoadAsset(FruitResource.dbResNameStr, 'ResComNumber');
    local traNum = self.transform:Find("GamePanel/ImageComPointBox/Numbers");


    local iLoopTurns = 2
    local iSzie = 13;
    local iChangeSCount = 4;
    local iMoveLength = iSzie * iLoopTurns + iNumber; -- - iLoopTurns;

    local fTickTime = 0.05; 
    local iCentreAllTime = fTickTime * ( iMoveLength - (2*iChangeSCount) );
    local iBothTime = 1;
    local iAllTime = iCentreAllTime + iBothTime * 2;

    local iCurNumber = 1;
    local iAddNum = 1;
    local loopCount = 1;
    
    FruitGameMain.SetNumImage(iCurNumber, traNum, resNum);
    local funChange = function(bEnd)
                        if(not bEnd) then
                            loopCount = loopCount + 1;
                            FruitGameMain.PlayMusic(FruitResource.strComNumMusic, 0);
                            if(iCurNumber == iSzie) then
                                --iAddNum = -1;
                                iCurNumber = 0;
                            elseif(1 == iCurNumber) then   
                                --iAddNum = 1;                                
                            end
                            iCurNumber = iCurNumber + iAddNum;
                            if(loopCount == iChangeSCount) then
                                self.myTimer:ChangeTickTime(fTickTime);
                            elseif(iMoveLength - iChangeSCount   == loopCount) then
                                --logYellow("len = " .. iMoveLength ..  "Change Time .. " .. loopCount .. "  iCurNumber = " .. iCurNumber);
                                self.myTimer:ChangeTickTime(iBothTime/iChangeSCount);
                            end
                                 --logYellow("Change Time .. " .. loopCount .. "  iCurNumber = " .. iCurNumber);
                        else
                            iCurNumber = iNumber;
                            FruitGameMain.ShowResult(tabChips, true);
                            logYellow("is end com");
                        end
                        FruitGameMain.SetNumImage(iCurNumber, traNum, resNum); 
                    end
    local tab1 = {fun = funChange; args = false; };
    local tab2 = {fun = funChange; args = true; };
    self.myTimer:SetTimer(iAllTime, true, FruitGameTimer.FruitTimerType.tick, iBothTime/iChangeSCount, tab1, tab2);
end



function FruitGameBase.GameEnd(args)
    if(not IsNil(self.objWinSource) ) then
        destroy(self.objWinSource);
        self.objWinSource = nil;
    end
    FruitGameBase.PlayAnimation(false, true);
    FruitGameBase.PlayAnimation(false, false);
    self.tabMainIMg[self.iCurMainIdx]:ShowImage(true);
    self.tabSubImg[self.iCurSubIdx]:ShowImage(false);
--    if(self.eGameType > FruitData.E_CAP and self.eGameType <= FruitData.E_GIVE_LIGHT) then
--        FruitGameBase.PlayLightAnim(false);
--    end
    FruitGameBase.RateRotate(false);

    logYellow("game end");
end

function FruitGameBase.Clealthis()
    self = nil;
end