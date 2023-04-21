--Point21PlayerCtrl.lua
--Date
--21点每个玩家控制 对应LuaBehaviour
local LuaBehaviour;
--endregion
--默认的定义
--require "Module19/Point21_2D/Point21ZJCtrl" --庄家控制
require "Module19/Point21_2D/Point21PokerCtrl" --扑克控制
require "Module19/Point21_2D/Point21ResourcesNume" --游戏资源管理
require "Module19/Point21_2D/Point21ChipsCtrl"; --筹码控制类
require "Module19/Point21_2D/bit" --位操作类

Point21PlayerCtrl = {};

local self = Point21PlayerCtrl;

local idx_; --临时存储玩家索引


----------- 玩家位置提示参数-----------------
local bTitleTimer = false; --是否开始位置提示动画计时

local titlePosTraParent; --玩家位置提示物体父物体

local titlePosTab = {}; --位置提示物体表

local titlePosTra;--位置提示物体
----------- 玩家位置提示参数end-----------------
local pokeMovePosX = 20; --大于4张牌时 扑克移动的距离

local TempoperateDataTab=nil;

--构造函数
function Point21PlayerCtrl:New(o)
    local t = o or {};
    setmetatable(t, self);
    self.__index = self
    return t;
end


--创建一个带 luabehaviour类的面板
-- idx : 物体索引 this ：当前脚本对象 parentTra : 此物体的父物体
function Point21PlayerCtrl.Create(idx, this, parentTra)

    self.this = this; -- 当前脚本对象
    self.thisParentTra = parentTra; --当前物体父物体
    idx_ = idx; --当前玩家物体索引 对应玩家座位号


    local resNameStr = ""; --需要加载的资源名字
    local objNameStr = ""; --创建出物体的名字

    if zjPos == idx then
        resNameStr = "Point21PlayerZJ";
        objNameStr = resNameStr;
    else
        resNameStr = "Point21Player";
        objNameStr = resNameStr .. idx;
    end

    --local obj = LoadAsset(Point21ResourcesNume.dbResNameStr, resNameStr);
    --local go = newobject(obj);
    local go = Point21ScenCtrlPanel.PoolForNewobject(resNameStr);
    Util.AddComponent("LuaBehaviour", go);
    go.name = objNameStr;
    self.OnCreateCompose(go);

    --创建带luaBehaviour面板的方法
    --参数1：ab资源名字  参数2：要加载的预设名字  参数3：创建出来的对象名字  参数4：回掉方法
    --PanelManager:CreatePanel(Point21ResourcesNume.dbResNameStr, resNameStr, objNameStr, self.OnCreateCompose);
end

--创建面板成功的回掉函数
function Point21PlayerCtrl.OnCreateCompose(prefab)

    for i = 1, self.thisParentTra.childCount do

        if (idx_ == i) then

            local posTra = self.thisParentTra:GetChild(i - 1);

            prefab.transform:SetParent(posTra);
            prefab.transform.localPosition = Vector3.New(0, 0, 0);
            prefab.transform.localScale = Vector3.New(1, 1, 1);

            if (zjPos == i) then --5号位为庄家
                Point21ZJCtrl.initZJCtrl(prefab, self.this);
            end

            break;
        end

    end

    LuaBehaviour = prefab.transform:GetComponent('LuaBehaviour');
    LuaBehaviour:SetLuaTab(self.this, "Point21PlayerCtrl");

end


--多个对象使用的时候C#调用，当多个对象使用同一份代码时， C#不用调用 Awake，C#只会在 start方法结束后调用 Lua层的StartOver
function Point21PlayerCtrl:Begin(obj)

    self.transform = obj.transform;
    self.luaBehaviour = self.transform:GetComponent('LuaBehaviour');

    self.idx = idx_; -- 玩家索引

    self.bHaveInfo = false; --此位置是否有人

    self.playerInfoTab = {}; --玩家信息



    self.pokerPosTra = self.transform:Find("Pokers"); --扑克父物体
    self.pokerPosVe3 = self.pokerPosTra.transform.localPosition; --扑克位置 初始位置

    self.chipsPosTra = self.transform:Find("ChipsPos"); --筹码位置 

    local gridLayoutGroup = self.pokerPosTra.transform:GetChild(0):GetComponent("GridLayoutGroup");
    self.resultUnitWidthF = gridLayoutGroup.cellSize.x; --结算框单位宽度                                             
    self.resultIncrementWidthF = gridLayoutGroup.cellSize.x + gridLayoutGroup.spacing.x; --结算框单位增量 

    self.traSpChipNum = self.transform:Find("SpChipsNumber"); --特殊筹码下注值

    if (zjPos ~= self.idx) then
        --transform/Pos0/Point21Players/Point21UIPanel 
        self.pointsPosTra = self.transform.parent.parent.parent.transform:Find("PointsObject"):GetChild(self.idx - 1); --点数位置
        self.pointPosVe3 = self.pointsPosTra.transform.localPosition; --点数位置 初始位置
        self.ve3PointGroup0 = self.pointsPosTra.transform:GetChild(0).localPosition; --第一组点数初始位置

        if (4 == self.idx) then
            self.point1Tra_Gro_0_5 = self.pointsPosTra.transform:Find("Group0/Point1"); --第5号玩家 第一组的 较长的点数图片
            self.point1Tra_Gro_1_5 = self.pointsPosTra.transform:Find("Group1/Point1"); --第5号玩家 第二组的 较长的点数图片
            self.point1PosVe3_Gro_0_5 = self.point1Tra_Gro_0_5.transform.localPosition;
            self.point1PosVe3_Gro_1_5 = self.point1Tra_Gro_1_5.transform.localPosition;
        end


        self.timerStripTra = self.transform:Find("ImageTimerBox"); --时间条
        self.timerStripTra.gameObject:SetActive(false);

        self.infoBoxTra = self.transform:Find("ButtonInfoBox"); --信息框物体
        self.infoBoxTra.gameObject:SetActive(false);
        self.luaBehaviour:AddClick(self.infoBoxTra.gameObject, Point21PlayerCtrl.onClickInfoBoxBtn); --添加头像按钮响应事件


        self.nameTra = self.infoBoxTra.transform:Find("TextName"); --名字物体 
        self.nameTra.gameObject:SetActive(false);

        self.photoImageTra = self.infoBoxTra.transform:Find("ImagePhoto"); --头像图片物体 
        self.photoImageTra.gameObject:SetActive(false);

        self.goldNumTextTra = self.infoBoxTra.transform:Find("TextGold"); --金币值物体 
        self.goldNumTextTra.gameObject:SetActive(false);


        self.chipsNumImageTra = self.transform:Find("ChipsNum"); --筹码值图片物体 
        self.chipsNumImageTra.gameObject:SetActive(false);

        self.imageResultTra = self.transform:Find("ImageResult"); --结算图片物体
        self.resultPosVe3 = self.imageResultTra.transform.localPosition;
        self.imageResultTra.gameObject:SetActive(false);

        self.expressionPosTra = self.transform:Find("ExpressionPos"); --表情位置

        self.traOperTilte = self.transform:Find("Opertitle"); -- 操作提示
        self.traChipTitle = self.transform:Find("TextChipTitle"); -- 下注提示提示

    end

    self.musicSourceTab = self.transform:GetComponent('AudioSource'); --玩家的音乐组件
    self.voiceSource = self.transform:Find("VoiceObject"):GetComponent('AudioSource');
    self.warningMusic = self.transform:Find("WarningMusic"):GetComponent('AudioSource');


    self:initGameData();

    ----------- 玩家位置提示参数-----------------
    self.allTitleTime = 3; --总时间
    self.allTempTime = 0; --动画总时长累加
    self.titleTime = 0.3; --间隔时间
    self.titleTempTimeF = 0; --位置提示动画计时累加时间时间
    self.currentTraIdx = 1; --当前控制物体索引
    ----------- 玩家位置提示参数 end-----------------
    ---------------爆牌效果计时----------------
    self.bBustTimer = false; --是否启用爆牌效果计时
    self.bustTempTimeF = 0; --爆牌计时累加时间
    self.bustTime = 1.5; --摆拍效果持续时间
    ---------------爆牌效果计时 end----------------
    ---------------玩家计时器---------------
    self.bTimeTimer = false; --是否启用计时器
    self.tempTimeF = 0; --计时器累加时间
    self.time = 0; --计时时间
    self.timeSriptAdd = 0; --时间条增量
    ---------------玩家计时器End---------------
    ---------------------倒计时音效倒计时------------------
    self.tempCDTimeF = 0;
    self.unitCDTimeF = 0; --单位累加时间
    self.bIsCountDown = false; --是否启用倒计时
    self.countCDDownTiemF = 0; --倒计时 时间

    ---------------------倒计时音效倒计时 end------------------
end

--初始化游戏数据
function Point21PlayerCtrl:initGameData()
    self.groupColorTab =    {
        [1] = Color.white;
        [2] = Color.white;
    } --每组的颜色

    self.iSpDChaipNum = 0; --特殊筹码下注值 对子
    self.iSpA13ChaipNum = 0;--特殊筹码下注值 +13
    self.iSpS13ChaipNum = 0;--特殊筹码下注值 -13

    self.allChipNumInt = 0; --所有组下注值总和
    self.allChipValIntTab =    {
        [1] = 0,
        [2] = 0,
    } --每组总下注值
    self.chipInstTab = {}; --当前玩家每组筹码实例
    self.insuranceChipValInt = 0; --保险下注值
    self.InsuranceChipInstTab = {}; --保险筹码物体
    self.tabSpDChipInst = {}; -- 特殊筹码 对子
    self.tabSpA13ChipInst = {}; -- 特殊筹码 +13
    self.tabSpS13ChipInst = {}; -- 特殊筹码 -13

    self.pokerInstTab = {}; --当前玩家的扑克实例 
    self.pokerPointsTraTab = {}; --当前玩家的每组扑克点数图片
    self.pokerPointsStrTab =    {
        [1] = "";
        [2] = "";
    }; --每组扑克点数

    self.currentGroupInt = 1; --当前操作的组

    self.zjLostChipEndPos = nil; --庄家输的筹码移动的终点位置

    self.bDouble = false; --是否是双倍操作
    self.bSplit = false; --是否分牌
    self.bBurst = false; --是否爆牌
    self.bStop = false; --是否停牌
    self.bSurrender = false; --是否投降

    self.bIsBlackJack = false;

    self.bAutoAddPokerToBust = false; --是否自动补拍时爆了

    self.bThrowChipTypeIn = false; -- 玩家是否下注状态进入

    self.currentPokerDataTab =    {
        byPokerData1 = 0,
        byPokerData2 = 0,
    } --当前发牌数据 在双倍和和分牌时记录


    self.b5pointBoxMove = false; --5号玩家点数位置是否移动了。。。
end



function Point21PlayerCtrl:Update()

    if (zjPos == self.idx) then
        Point21ZJCtrl.Update();
    end

    self:posTitleAnimation();

    self:bustPokerTimer();

    self:timeTimer();

    --self:countDownTimer();
    if (Point21ZJCtrl.bPlayerBeginChipMove and zjPos ~= self.idx and self.insuranceChipValInt > 0) then  --玩家收走保险筹码
        log("Point21ZJCtrl.bPlayerBeginChipMove")
        self:playerWinChips(0);
        Point21ZJCtrl.bPlayerBeginChipMove = false;
    end

    self:expressionAnimationListener();

    if (self.bOne and self.bTwo and self.bStop and self.bSplit) then --分牌动作结束后 若有停牌消息 则在此处理
        self.bOne = false;
        self.bTwo = false;
        self.bStop = false;
        self.bSplit = false;
        self:stopPokerOperation();
    end

end



--设置到计时播放
function Point21PlayerCtrl:setCountDownTimer(bCD, timeF)

    if (bCD) then
        self.bIsCountDown = bCD;
        self.countCDDownTiemF = timeF;
    else
        self.bIsCountDown = false;
        self.countCDDownTiemF = 0;
        self.tempCDTimeF = 0;
        self.unitCDTimeF = 0;
    end

end


--倒计时音效播放
function Point21PlayerCtrl:countDownTimer()

    if (self.bIsCountDown) then
        self.tempCDTimeF = self.tempCDTimeF + Time.deltaTime;

        if (self.tempCDTimeF <= self.countCDDownTiemF) then

            self.unitCDTimeF = self.unitCDTimeF + Time.deltaTime;

            if (self.unitCDTimeF >= 1) then
                if (self.countCDDownTiemF - self.tempCDTimeF <= 5) then --播放警告倒计时
                    self.warningMusic:Play();
                end
                self.unitCDTimeF = self.unitCDTimeF - 1;
            end
        else
            self:setCountDownTimer(false);
        end
    end
end


--玩家计时器设定
--bTimer  是否启用,   t 定时总时间  bOper是否普通操作
function Point21PlayerCtrl:setTimer(bTimer, t, bOper)
    self.bTimeTimer = bTimer;
    self.timerStripTra.gameObject:SetActive(bTimer);
    if (bTimer) then
        self.textTimer = self.timerStripTra:Find("TextTimer"):GetComponent('Text');
        self.textTimer.text = math.floor(t) .. ""; --初始化倒计时总时间
        self.time = math.floor(t);
        if (bOper) then --普通操作的玩家 点数左右摆动
            logYellow("bTimer:"..tostring(bTimer).."boper:"..tostring(bOper))
            logYellow("普通操作的玩家 点数左右摆动")
            self:SetOperTitle(true, self.currentGroupInt);
        end
    else
        self.timeSriptAdd = 0;
        self.tempTimeF = 0;
        self:SetOperTitle(false);
    end
end


--新玩家计时器
function Point21PlayerCtrl:timeTimer()

    if (self.bTimeTimer) then

        local currentTime = math.floor(self.tempTimeF); --当前时间取整
        local nextTime = math.floor(self.tempTimeF + Time.deltaTime); --下一帧时间取整
        self.tempTimeF = self.tempTimeF + Time.deltaTime

        if (currentTime ~= nextTime) then --累加超过1秒
            local timeInt = tonumber(self.textTimer.text);
            timeInt = timeInt - 1;
            self.textTimer.text = timeInt .. "";
        end

        if (Point21ScenCtrlPanel.bBeginThrwoChip and (myChairID + 1) == self.idx) then
            if (self.time - self.tempTimeF <= 0.5) then
                error("----隐藏下注界面---计时器---------");
                Point21ScenCtrlPanel.showChipList(false); --隐藏下注界面        
            end
        end
        -- log("倒计时：self.tempTimeF:"..self.tempTimeF.." self.time："..self.time)
        if (self.tempTimeF >= self.time) then

            self:setTimer(false);
        end

    end
end

--初始化玩家信息
--infoTab 玩家信息
function Point21PlayerCtrl:initPlayerInfo(infoTab)

    self.bHaveInfo = true;
    self.playerInfoTab = infoTab;

    if (self.idx == (myChairID + 1)) then

        -- transform/Pos0/Point21Players/Point21UIPanel/UGUICamera  
        local userInfoBoxTra = self.transform.parent.parent.parent.parent.transform:Find("ImageUserInfoBox");

        --下方玩家信息框物体
        self.bottomPhotoTra = userInfoBoxTra.transform:Find("ImagePhoto");
        self.luaBehaviour:AddClick(self.bottomPhotoTra.gameObject, Point21PlayerCtrl.onClickInfoBoxBtn);

        self.bottomNametra = userInfoBoxTra.transform:Find("TextName");

        self.bottomGoldtra = userInfoBoxTra.transform:Find("TextGold");

    end

    self:showInfoTranform(true);
end

--游戏开始
--b 是否显示时间条,  t 计时时间
function Point21PlayerCtrl:playerGameBegin(b, t)
    self:resetGameInfo();
    if (self.pokerPosTra) then
        for i = 0, self.pokerPosTra.childCount - 1 do --此处放到游戏开始处理 是因为要等处理完收牌事件才可处理
            local pokerGroupTra = self.pokerPosTra.transform:GetChild(i);
            --pokerGroupTra.transform:GetComponent('GridLayoutGroup').enabled = true; --激活layout组件
            pokerGroupTra.gameObject:SetActive(false);
        end
    end

    if (zjPos ~= self.idx and self.bHaveInfo) then --不是庄家 并且位置上有人
        self:setTimer(b, t);
    end
end


--重置游戏信息
function Point21PlayerCtrl:resetGameInfo()
    logYellow("重置游戏信息===========开始===step 1")
    self:initGameData();
    self.pokerPosTra.transform.localPosition = self.pokerPosVe3; -- 初始化扑克位置
    if (zjPos ~= self.idx) then
        self.pointsPosTra.transform.localPosition = self.pointPosVe3; -- 初始化点数位置
        self.pointsPosTra.transform:GetChild(0).localPosition = self.ve3PointGroup0;
        if (5 == self.idx) then -- 初始化5号玩家较长点数图片位置
            self.point1Tra_Gro_0_5.transform.localPosition = self.point1PosVe3_Gro_0_5
            self.point1Tra_Gro_1_5.transform.localPosition = self.point1PosVe3_Gro_1_5
        end
        self.chipsNumImageTra.gameObject:SetActive(false);
        for groupI = 0, self.pointsPosTra.transform.childCount - 1 do      --重置点数底框
            local gropuTra = self.pointsPosTra.transform:GetChild(groupI); --组
            for i = 0, gropuTra.transform.childCount - 1 do
                local nomerPointBoxRes = Point21ScenCtrlPanel.nomerPointboxRes:GetChild(i);
                gropuTra.transform:GetChild(i):GetComponent('Image').sprite = nomerPointBoxRes.transform:GetComponent('Image').sprite;
            end
        end
        self.imageResultTra.transform.localPosition = self.resultPosVe3; --重置结算界面位置
        self.imageResultTra.gameObject:SetActive(false);
        -------清除多余筹码--------
       -- logYellow("重置游戏信息===========开始===step endpos")
        local count = 0;
        local chipEndPosTra = self.chipsPosTra.transform:Find("EndPos");
        for i = 0, chipEndPosTra.transform.childCount - 1 do
            local traChild = chipEndPosTra.transform:GetChild(i);
            local str = string.sub(traChild.name, 1, 3);
            if ("Pos" == str) then
                count = traChild.childCount - 1;
                if count >= 0 then
                    for j = count, 0, -1 do
                        destroy(traChild:GetChild(j).gameObject);
                    end
                end
            else
                destroy(traChild.gameObject);
            end
        end
      --  logYellow("重置游戏信息===========开始===step pos_spchip")
        local traSPChip = self.chipsPosTra.transform:Find("Pos_SPChip");
        for i = 0, traSPChip.childCount - 1 do
            local traEndPos = traSPChip:GetChild(i);
            for j = 0, traEndPos.childCount - 1 do
                local traPos = traEndPos:GetChild(j);
                count = traPos.childCount - 1;
                if count >= 0 then
                    for x = count, 0, -1 do
                        destroy(traPos:GetChild(x).gameObject);
                    end
                end
            end
        end
      --  logYellow("重置游戏信息===========开始===step chipspos")
        local ChipsPosReset = self.transform:Find("ChipsPos");
        count = ChipsPosReset.childCount-1;
        if count >= 1 then
            for i = count, 2, -1 do
                destroy(ChipsPosReset:GetChild(i).gameObject);
            end
        end


      --  logYellow("重置游戏信息===========开始===step  spchipsnumber")
        local spchipsnum = self.transform:Find("SpChipsNumber");
        for i = 0, spchipsnum.childCount - 1 do
            count = spchipsnum:GetChild(i).childCount - 1;
            if count >= 1 then
                for j = count, 1, -1 do
                    destroy(spchipsnum:GetChild(i):GetChild(j).gameObject);
                end
            end
            spchipsnum:GetChild(i).gameObject:SetActive(false);
        end
     --   logYellow("重置游戏信息===========开始===step  win spnum")
        local winnum = self.transform:Find("WinSpNum");
        count = winnum.childCount - 1;
        if count >= 1 then
            for i = count, 1, -1 do
                destroy(winnum:GetChild(i).gameObject);
            end
        end
        winnum.gameObject:SetActive(false);

        logYellow("重置游戏信息===========开始===step chipsnum")
        local chipnum = self.transform:Find("ChipsNum");
        count = chipnum.childCount - 1;
        if count >= 1 then
            for i = count, 1, -1 do
                destroy(chipnum:GetChild(i).gameObject);
            end
        end
        chipnum.gameObject:SetActive(false);

        --logYellow("重置游戏信息===========开始===step pokers")
        self.transform:Find("TextChipTitle").gameObject:SetActive(false);
        local pokers = self.transform:Find("Pokers");
        for i = 0, pokers.childCount - 1 do
            count = pokers:GetChild(i).childCount - 1;
            log(count)
            if count >= 0 then
                for j = count, 0, -1 do
                    destroy(pokers:GetChild(i):GetChild(j).gameObject);
                end
            end
            pokers:GetChild(i).gameObject:SetActive(false);
        end
        pokers:Find("PokerGroup0"):SetSiblingIndex(0);
        pokers:Find("PokerGroup1"):SetSiblingIndex(1);

        local oper = self.transform:Find("Opertitle");--闪光边框
        for i = 0, oper.childCount - 1 do
            oper:GetChild(i).gameObject:SetActive(false);
        end
        self.transform:Find("ImageResult").gameObject:SetActive(false);
        self.transform:Find("ImageTimerBox").gameObject:SetActive(false);
        logYellow("重置游戏信息===========开始===step  over")
    end

end


--用户离开
function Point21PlayerCtrl:playerLeave()

    if (not Point21ZJCtrl.bPlayerLostMotionEndTab[self.idx] and zjPos ~= self.idx) then
        Point21ZJCtrl.bPlayerLostMotionEndTab[self.idx] = true;
    end

    if (not Point21ZJCtrl.bPlayerWinMotionEndTab[self.idx] and zjPos ~= self.idx) then
        Point21ZJCtrl.bPlayerWinMotionEndTab[self.idx] = true;
    end

    if (self.pokerPointsTraTab) then
        -- if (#thisInst.pokerPointsTraTab >= 1) then --隐藏21点标志
        --     -- thisInst.pokerPointsTraTab[1]:GetComponent("Image").enabled = false
        --     destroy(thisInst.pokerPointsTraTab[1]);
        --     thisInst.pokerPointsTraTab = {};
        -- end
        for groupIdx = 1, #self.pokerPointsTraTab do --隐藏点数
            -- thisInst.pokerPointsTraTab[groupIdx].gameObject:SetActive(false)
            destroy(self.pokerPointsTraTab[groupIdx].gameObject);
        end
        self.pokerPointsTraTab = {};
    end
    -- if (self.pokerPointsTraTab) then
    --     if (#self.pokerPointsTraTab >= 1) then --隐藏21点标志
    --         self.pokerPointsTraTab[1]:GetComponent('Image').enabled = false;
    --     end
    --     for groupIdx = 1, #self.pokerPointsTraTab do  --隐藏点数
    --         self.pokerPointsTraTab[groupIdx].gameObject:SetActive(false);
    --     end
    -- end
    for i = 0, (self.pokerPosTra.transform.childCount - 1) do

        for j = 0, (self.pokerPosTra.transform:GetChild(i).childCount - 1) do

            destroy(self.pokerPosTra.transform:GetChild(i):GetChild(j).gameObject);

        end


    end

    if (zjPos ~= self.idx) then
        local chipEndPosTra = self.chipsPosTra.transform:Find("EndPos");
        for i = 0, chipEndPosTra.transform.childCount - 1 do
            local traChild = chipEndPosTra.transform:GetChild(i);
            local str = string.sub(traChild.name, 1, 3);
            if ("Pos" == str) then
                for j = 0, traChild.childCount - 1 do
                    destroy(traChild:GetChild(j).gameObject);
                end
            else
                destroy(traChild.gameObject);
            end
        end

        local traSPChip = self.chipsPosTra.transform:Find("Pos_SPChip");
        for i = 0, traSPChip.childCount - 1 do
            local traEndPos = traSPChip:GetChild(i);
            for j = 0, traEndPos.childCount - 1 do
                local traPos = traEndPos:GetChild(j);
                for x = 0, traPos.childCount - 1 do
                    destroy(traPos:GetChild(x).gameObject);
                end
            end
        end

    end

    self:SetSpChipNumber(-1);

    self.bHaveInfo = false;

    self:showInfoTranform(false);

    self:resetGameInfo();

    if (zjPos ~= self.idx) then
        self:setTimer(false);
    end

end

--显示玩家信息物体
function Point21PlayerCtrl:showInfoTranform(bShow)

    if (zjPos == self.idx) then
        return;
    end

    self.nameTra.gameObject:SetActive(bShow);
    self.photoImageTra.gameObject:SetActive(bShow);
    self.goldNumTextTra.gameObject:SetActive(bShow);
    --self.chipsNumImageTra.gameObject:SetActive(bShow);
    if (bShow) then

        self.infoBoxTra.gameObject:SetActive(true);

        local nameStr = self.playerInfoTab._2szNickName;

        local infoBoxRes = Point21ScenCtrlPanel.infoBoxRes; --要显示的图片资源

        local photoUrlStr = "";
        local headstr1 = "";
        if (self.playerInfoTab._4bCustomHeader > 0) then --自定义了头像
            headstr1 = self.playerInfoTab._1dwUser_Id .. "." .. self.playerInfoTab._5szHeaderExtensionName;
            photoUrlStr = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/" .. headstr1;
        else
            headstr1 = self.playerInfoTab._3bySex .. ".png";
            photoUrlStr = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/0" .. headstr1;
        end

        self.photoImageTra.gameObject:SetActive(true);

        --UpdateFile.downHead(photoUrlStr, headstr1, nil, self.photoImageTra.gameObject);
        --NetManager:GetLoadHeaderFile(photoUrlStr, self.photoImageTra.gameObject);
        if self.playerInfoTab._3bySex == 1 then
            self.infoBoxTra.transform:Find("Image"):GetComponent("Image").sprite = HallScenPanel.nanSprtie;
        else
            self.infoBoxTra.transform:Find("Image"):GetComponent("Image").sprite = HallScenPanel.nvSprtie;
        end

        --error();
        logYellow("self.idx=="..self.idx)
        logYellow("myChairID"..myChairID)

        if (self.idx == (myChairID + 1)) then --自己
            titlePosTraParent = self.transform.parent;
            --加载玩家位置提示资源
            --ResManager:LoadAsset(Point21ResourcesNume.dbResNameStr, 'PosTitle', self.loadAssetPosTitleResCallBack);
            -- transform/Pos0/Point21Players/Point21UIPanel/UGUICamera  改变自己操作区域图片
            -- local backgroundTra = self.transform.parent.parent.parent.parent.transform:Find("ImageBackground");

            -- local pokerPosImage = backgroundTra.transform:GetChild(myChairID):Find("PokerPos"):GetComponent("Image");

            -- local chipsPosImage = backgroundTra.transform:GetChild(myChairID):Find("ChipPos"):GetComponent("Image");

            -- pokerPosImage.sprite = Point21ScenCtrlPanel.plyerPosRes.transform:Find("PokerPos"):GetComponent('Image').sprite;

            -- chipsPosImage.sprite = Point21ScenCtrlPanel.plyerPosRes.transform:Find("ChipPos"):GetComponent('Image').sprite;


            --self.normalPhotoBoxImage = infoBoxRes.transform:Find("My"):GetComponent('Image'); --普通状态时的玩家头像框
            --self.operationShowBoxImage = infoBoxRes.transform:Find("MyOperation"):GetComponent('Image'); --操作时的玩家头像示框
            --self.infoBoxTra:GetComponent('Image').sprite = infoBoxRes.transform:Find("My"):GetComponent('Image').sprite;
            --self.bottomPhotoTra 
            --            NetManager:GetLoadHeaderFile(photoUrlStr, self.bottomPhotoTra.gameObject);
            -- UpdateFile.downHead(photoUrlStr, headstr1, nil, self.bottomPhotoTra.gameObject);
            if self.playerInfoTab._3bySex == 1 then
                self.bottomNametra.parent:Find("Image"):GetComponent("Image").sprite = HallScenPanel.nanSprtie;
            else
                self.bottomNametra.parent:Find("Image"):GetComponent("Image").sprite = HallScenPanel.nvSprtie;
            end
            self.bottomNametra.parent:Find("Image"):GetComponent("Image").sprite = HallScenPanel.GetHeadIcon();
            self.bottomNametra.transform:GetComponent('Text').text = nameStr;

            self.bottomGoldtra.transform:GetComponent('Text').text = tostring(self.playerInfoTab._7wGold);

            Point21ScenCtrlPanel.RecordUserGold(self.playerInfoTab._7wGold);
            logYellow("自己下注")
            Point21ScenCtrlPanel.SetPlayChipBtn(self.transform:Find("ButtonChip"));
            self.infoBoxTra.transform:Find("Image"):GetComponent("Image").sprite = HallScenPanel.GetHeadIcon();

        else
            --self.normalPhotoBoxImage = infoBoxRes.transform:Find("Normal"):GetComponent('Image'); --普通状态时的玩家头像框
            --self.operationShowBoxImage = infoBoxRes.transform:Find("NormalOperation"):GetComponent('Image'); --操作时的玩家头像示框
            --self.infoBoxTra:GetComponent('Image').sprite = self.normalPhotoBoxImage.sprite;
            
            local index = math.random(1,10);
            self.infoBoxTra.transform:Find("Image"):GetComponent("Image").sprite = HallScenPanel.headIcons.transform:GetChild(index-1):GetComponent("Image").sprite;
        end

        self.nameTra.transform:GetComponent('Text').text = nameStr;
        self:showNumberText(self.playerInfoTab._7wGold, self.goldNumTextTra);
    else
        self.infoBoxTra.gameObject:SetActive(false);
        --        self.photoImageTra.gameObject:SetActive(false);
        --        self.nameTra.transform:GetComponent('Text').text = "";
        --        self.goldNumTextTra.transform:GetComponent('Text').text = "";
        --        self.infoBoxTra:GetComponent('Image').sprite = infoBoxRes.transform:Find("Null"):GetComponent('Image').sprite;
        --        self.photoImageTra.transform:GetComponent('RawImage').texture = nil;
    end

    if (self.bThrowChipTypeIn) then
        logYellow("bThrowChipTypeIn")
        self:setTimer(true, Point21ScenCtrlPanel.surplusTimer);
        self.bThrowChipTypeIn = false;
    end

end

--玩家位置提示资源加载回调
function Point21PlayerCtrl.loadAssetPosTitleResCallBack(prefab)
    local obj = newobject(prefab);
    obj.name = "PosTitle";
    obj.transform:SetParent(titlePosTraParent);
    obj.transform:SetSiblingIndex(0);
    obj.transform.localPosition = Vector3.New(0, 0, 0);
    obj.transform.localScale = Vector3.New(1, 1, 1);

    titlePosTra = obj;

    --    for i = 0, obj.transform.childCount - 1 do
    --        table.insert(titlePosTab, obj.transform:GetChild(i));
    --    end
    bTitleTimer = true;

end

--摄制头像
function Point21PlayerCtrl:setPhoto(photoTra)

end


--玩家位置提示动画
function Point21PlayerCtrl:posTitleAnimation()

    if (bTitleTimer and self.idx == (myChairID + 1)) then

        self.allTempTime = self.allTempTime + Time.deltaTime;
        if (self.allTempTime <= self.allTitleTime) then  --最新版玩家位置提示

            self.titleTempTimeF = self.titleTempTimeF + Time.deltaTime;

            if (self.titleTempTimeF >= self.titleTime) then

                if (1 == titlePosTra.transform.localScale.x) then
                    titlePosTra.transform.localScale = Vector3.New(1.025, 1.1, 1.1);
                else
                    titlePosTra.transform.localScale = Vector3.One();
                end

                self.titleTempTimeF = 0;

            end

        else
            self:setPosTitleImage(false);
            self.allTempTime = 0;
            self.titleTempTimeF = 0;
            bTitleTimer = false;
        end


    end

end


--设置位置提示图片
function Point21PlayerCtrl:setPosTitleImage(bShow)

    if (bShow) then
    else
        destroy(titlePosTra.gameObject);
    end
end


--用户分数改变 
function Point21PlayerCtrl:setPlayerScore(infoTab)
    self.playerInfoTab = infoTab;
    if (self.idx == myChairID + 1) then
        Point21ScenCtrlPanel.RecordUserGold(self.playerInfoTab._7wGold);
    end
    self:ChangePlayerGold(self.playerInfoTab._7wGold);
end

--用户金币变动
function Point21PlayerCtrl:ChangePlayerGold(iGold)

    if (self.idx == myChairID + 1) then
        self.bottomGoldtra.transform:GetComponent('Text').text = tostring(iGold) .. "";
    end

    self:showNumberText(iGold, self.goldNumTextTra);
end




--玩家中途进入
--ZJState   庄家状态, playerData  玩家数据  currentOperateChairID 当前操作的座位号
function Point21PlayerCtrl:halfwayInGame(ZJState, playerData, currentOperateChairID)
    logTable(playerData);
    if (not self.bHaveInfo and zjPos ~= self.idx) then --此位置没人 庄家位置一直有人
        return;
    end
    if (0 == playerData.m_bPlaying) then --没在游戏中
        return;
    end
    if (Point21DataStruct.CMD_BlackJack.enPlayerOperateState.E_PLAYER_OPERATE_STATE_NORMAL_OPERATE == playerData.m_enPlayerOperateState and myChairID == currentOperateChairID) then
        Point21ScenCtrlPanel.showOperation(true);
    end
    if (playerData.m_byGroupCount <= 0) then
        playerData.m_byGroupCount = 1;
    end
    local bustChipsNumInt = 0; --记录爆牌组的下注值
    for groupI = 1, playerData.m_byGroupCount do
        self.currentGroupInt = groupI;
        local currentPoint = 0; --当前点数
        local pCountInt = playerData.m_byPokerCount[groupI]; --每组中的扑克数量
        local frontgroupIdx = groupI - 1; --前面已经处理过得组个数
        local frontPokerCount = frontgroupIdx * Point21DataStruct.CMD_BlackJack.C_GROUP_MAX_POKER_COUNT; --前面已经处理过得扑克数据个数
        local currentPokerIdx = frontPokerCount + 1; --当前要处理的扑克数据数组第一个元素下标
        local groupTra = self.pokerPosTra:GetChild(self.pokerPosTra.childCount - groupI);
        if (pCountInt > 0) then
            if (not groupTra.gameObject.activeSelf) then
                groupTra.gameObject:SetActive(true);
            end
            if (groupI > 1) then --当有2组牌时  第一组点数下移
                self.pointsPosTra.transform:GetChild(0).localPosition = Vector3.New(self.pointsPosTra.transform:GetChild(0).localPosition.x, 0,
                self.pointsPosTra.transform:GetChild(0).localPosition.z);
            end
        end

        for i = currentPokerIdx, (currentPokerIdx + pCountInt) - 1 do
            --修改获取点数方式
            local onePointInt = Point21ResourcesNume.getPokerNum(playerData.m_byPokerData[i]); --新拿到的扑克数据 低四位为点数， 15 = 00001111
            if (onePointInt > 10) then
                onePointInt = 10;
            end
            currentPoint = currentPoint + onePointInt;
            local point21PokerCtrl = Point21PokerCtrl:New();

            if (ZJState ~= Point21DataStruct.CMD_BlackJack.enPlayerOperateState.E_PLAYER_OPERATE_STATE_AFT_LOOK_ZJ_SECOND_POKER
            and ZJState ~= Point21DataStruct.CMD_BlackJack.enPlayerOperateState.E_PLAYER_OPERATE_STATE_NORMAL_OPERATE) then

                if (zjPos == self.idx and 2 == i) then --没有查看庄家第2张牌时 
                    playerData.m_byPokerData[i] = 255;
                end
            end
            point21PokerCtrl.Create(self.idx, point21PokerCtrl, groupTra, playerData.m_byPokerData[i], 1, true);
        end
        --当前操作的玩家是自己并且有分牌 那么将不是正在操作组的颜色改变
        if (playerData.m_byGroupCount > 1 and self.idx == currentOperateChairID and groupI ~= playerData.m_byGroupIndex) then
            self:setPokerColor(Color.gray, groupI);
        end
        ------下注--------
        if (currentPoint <= 21 and 1 ~= playerData.m_bSurrender[groupI]) then -- 没爆牌没投降 才可以下注
            if (zjPos ~= self.idx) then
                local tempChipsCount = playerData.m_iChipList[groupI]
                if (ZJState == Point21DataStruct.CMD_BlackJack.enPlayerOperateState.E_PLAYER_OPERATE_STATE_CHIP) then --下注状态
                    for i = 1, #playerData.m_iChip do
                        if (playerData.m_iChip[i] > 0) then
                            tempChipsCount = playerData.m_iChip[i];
                            self:throwChips(i, tempChipsCount);
                        end
                    end
                else
                    tempChipsCount = playerData.m_iChipList[groupI];
                    self:throwChips(Point21DataStruct.E_CHIPTYPE_NORMAL, tempChipsCount);
                end
                if (1 == playerData.m_bInsurance and
                (ZJState == Point21DataStruct.CMD_BlackJack.enPlayerOperateState.E_PLAYER_OPERATE_STATE_INSURANCE or
                ZJState == Point21DataStruct.CMD_BlackJack.enPlayerOperateState.E_PLAYER_OPERATE_STATE_PRE_LOOK_ZJ_BLACK_JACK)) then --在可以买保险时买了保险

                    if (1 == i) then
                        self:throwChips(Point21DataStruct.E_CHIPTYPE_OTHER, self.allChipValIntTab[groupI] / 2, true);
                    end
                end
            end
        else
            self.groupColorTab[self.currentGroupInt] = Color.gray; --改变当前组的默认颜色
            if (self.idx == currentOperateChairID and playerData.m_byGroupCount > 1) then --是自己操作并且 组数大于一组时不做任何处理
            else
                self:setPokerColor(Color.gray, self.currentGroupInt); --置灰此组
                bustChipsNumInt = bustChipsNumInt + playerData.m_iChipList[groupI];
                self.allChipNumInt = self.allChipNumInt + playerData.m_iChipList[groupI];
                if (not self.chipsNumImageTra.gameObject.activeSelf) then self.chipsNumImageTra.gameObject:SetActive(true); end
                self:showNumberImage(self.allChipNumInt, self.chipsNumImageTra, Point21ScenCtrlPanel.numObjRes.transform);
            end
        end
    end
    self.allChipNumInt = self.allChipNumInt - bustChipsNumInt; --最后将爆掉的下注数从总下注数中清除
    self.currentGroupInt = playerData.m_byGroupIndex + 1;
end





--zj筹码控制
--chipsNumInt 筹码值, chipEndPos 运动的终点位置, bInsurance 是否保险, toPlayerIdx 要运动到的玩家索引
function Point21PlayerCtrl:zjChipsCtrl(chipsNumInt, chipEndPos, bInsurance, toPlayerIdx)
    if (chipsNumInt > 0) then
        self.zjLostChipEndPos = chipEndPos;
        self:throwChips(Point21DataStruct.E_CHIPTYPE_NORMAL, chipsNumInt, bInsurance, toPlayerIdx);
    end

end

--设置下注提示
function Point21PlayerCtrl:SetChipTitle(bShow)
    logYellow("设置下注提示=="..tostring(bShow))
    if (bShow) then
        if (self.traChipTitle.gameObject.activeSelf) then return; end
        self.traChipTitle.gameObject:SetActive(true);
        self.doTilte = self.traChipTitle:Find("ChipTitle/ImageBottom"):DOScale(Vector3.New(1, 1, 1), 0.8):SetLoops(-1);
    else
        if (self.doTilte) then
            self.doTilte:Pause():Rewind(true);
            self.doTilte = nil;
        end
        self.traChipTitle.gameObject:SetActive(false);
    end

end


-- 下注
--  chipsNumInt 下注值   bInsurance 是否是保险下注  toPlayerIdx 若为庄家输掉的筹码 记录此筹码属于哪个玩家
function Point21PlayerCtrl:throwChips(iChipType, chipsNumInt, bInsurance, toPlayerIdx)
    bInsurance = bInsurance or false;
    if (not bInsurance and not self.bSurrender) then --没有保险和没有投降时时

        local gropIdx = self.currentGroupInt;
        if (self.bSplit) then
            gropIdx = gropIdx + 1;
        end

        if (iChipType < Point21DataStruct.E_CHIPTYPE_NORMAL_D) then
            local allChipValInt = self.allChipValIntTab[gropIdx];
            allChipValInt = allChipValInt + chipsNumInt;
            self.allChipValIntTab[gropIdx] = allChipValInt; --存储每组的总下注值
        end

    else
        self.insuranceChipValInt = chipsNumInt;
    end

    local tempNumInt = chipsNumInt;
    local createChipCount = 0; -- 下注筹码个数 每次下注最多10个
    for i = 1, #bottomChipsListIntTab do
        if (tempNumInt >= bottomChipsListIntTab[i]) then
            local chipsRemainder = tempNumInt % bottomChipsListIntTab[i];
            local chipsCount = math.floor(tempNumInt / bottomChipsListIntTab[i]);
            tempNumInt = chipsRemainder;
            for j = 1, chipsCount do
                local bEnd = false
                if (j == chipsCount and 0 == chipsRemainder) then --最后一个创建出的筹码
                    bEnd = true;
                end
                if (100 == createChipCount) then --最多10个筹码 所以若超过个筹码 将第10个筹码设置为最后一个创建的筹码
                    bEnd = true;
                end
                if (createChipCount <= 10) then --每次创建筹码的个数不超过10个
                    if (zjPos == self.idx) then
                        self:createChip(iChipType, bottomChipsListIntTab[i], bInsurance, bEnd, toPlayerIdx);
                    else
                        self:createChip(iChipType, bottomChipsListIntTab[i], bInsurance, bEnd);
                    end
                end
                createChipCount = createChipCount + 1; --累计创建筹码个数
            end
            if (0 == chipsRemainder) then
                break;
            end
        end
    end
    if (not self.bSurrender) then --投降时不播下注音效
        self:playMusic(Point21ResourcesNume.EnumSoundType.sound_bet, -1);
    end
    if (zjPos ~= self.idx) then
        if (iChipType > Point21DataStruct.E_CHIPTYPE_NORMAL and iChipType <= Point21DataStruct.E_CHIPTYPE_NORMAL_S13) then
            self:SetSpChipNumber(iChipType, chipsNumInt);
        else
            self.allChipNumInt = self.allChipNumInt + chipsNumInt; --存储所有组下注的总和
            if (not self.chipsNumImageTra.gameObject.activeSelf) then self.chipsNumImageTra.gameObject:SetActive(true); end
            self:showNumberImage(self.allChipNumInt, self.chipsNumImageTra, Point21ScenCtrlPanel.numObjRes.transform);
        end
    end
end



-- 创建筹码
-- chipsVal 要创建的筹码数值  bInsurance 是否是保险筹码  bEndChip  是否是最后一个创建的筹码
function Point21PlayerCtrl:createChip(iType, chipsVal, bInsurance, bEndChip, toPlayerIdx)

    local point21ChipsCtrl = Point21ChipsCtrl:New();

    --local chipEndPosTra = self.chipsPosTra.transform:Find("EndPos");
    point21ChipsCtrl.Create(iType, self.idx, point21ChipsCtrl, self.chipsPosTra, chipsVal, bInsurance, bEndChip, toPlayerIdx);


end


--获取筹码实例
-- chipInst 筹码实例
function Point21PlayerCtrl:getChipInst(chipInst)


    if (not chipInst.bInsurance) then --非保险筹码

        if (chipInst.iType == Point21DataStruct.E_CHIPTYPE_NORMAL_D) then
            table.insert(self.tabSpDChipInst, chipInst);
        elseif (chipInst.iType == Point21DataStruct.E_CHIPTYPE_NORMAL_A13) then
            table.insert(self.tabSpA13ChipInst, chipInst);
        elseif (chipInst.iType == Point21DataStruct.E_CHIPTYPE_NORMAL_S13) then
            table.insert(self.tabSpS13ChipInst, chipInst);
        else

            local gropIdx = self.currentGroupInt;
            if (self.bSplit) then
                gropIdx = gropIdx + 1;
            end

            if (self.chipInstTab[gropIdx]) then  --若存在此表 则在此表后直接添加
                table.insert(self.chipInstTab[gropIdx], chipInst);
            else  --若不存在 则加入新的表

                local tempChipInstTab = {};

                table.insert(tempChipInstTab, chipInst);

                self.chipInstTab[gropIdx] = tempChipInstTab;

            end

        end

    else
        table.insert(self.InsuranceChipInstTab, chipInst); --保险筹码
    end

    local chipEndPosTra = self.chipsPosTra.transform:Find("EndPos");

    if (self.bSurrender) then --投降
        chipInst:moveToPos(Point21ZJCtrl.chipsPos, true); --投降时输掉筹码
    else
        if (zjPos ~= self.idx) then


            for i = 1, #bottomChipsListIntTab do
                if (bottomChipsListIntTab[i] == chipInst.chipsNumberInt) then
                    if (chipInst.iType >= Point21DataStruct.E_CHIPTYPE_NORMAL_D and chipInst.iType <= Point21DataStruct.E_CHIPTYPE_NORMAL_S13) then
                        chipEndPosTra = self.chipsPosTra.transform:Find("Pos_SPChip"):GetChild(chipInst.iType - Point21DataStruct.E_CHIPTYPE_NORMAL_D):GetChild(i - 1);
                    else
                        chipEndPosTra = self.chipsPosTra.transform:Find("EndPos"):GetChild(i - 1);
                    end
                    break;
                end
            end

            chipInst:moveToPos(chipEndPosTra);
        else
            local traEndPos = self.zjLostChipEndPos;
            if (chipInst.iType >= Point21DataStruct.E_CHIPTYPE_NORMAL_D and chipInst.iType <= Point21DataStruct.E_CHIPTYPE_NORMAL_S13) then

                traEndPos = point21PlayerTab[chipInst.toPlayerIdx]:GetChipPos(chipInst.iType);
                point21PlayerTab[chipInst.toPlayerIdx]:SetplayerWinSpChips(chipInst.iType, chipInst);
                local funCallBack = nil

                --if (chipInst.bEndChip) then
                funCallBack = function()
                    point21PlayerTab[chipInst.toPlayerIdx]:GetplayerWinSpChips(chipInst.iType);
                end
                --end
                chipInst:moveToPos(traEndPos, false, nil, funCallBack);

            end
            chipInst:moveToPos(traEndPos); -- 庄家输掉筹码
        end
    end


    --test ==================
    --for i = 1, #self.chipInstTab[self.currentGroupInt] do
    --error("chip is " .. self.chipInstTab[self.currentGroupInt][i].transform.name);
    --end
    --test end
end


--筹码运动结束回调
-- inst筹码实例
function Point21PlayerCtrl:chipExerciseEndCallBack(inst)

    if (inst.bEndChip) then

        if (self.bDouble or self.bSplit) then

            if (self.currentPokerDataTab ~= 244) then
                Point21ZJCtrl.createPokers(self.idx, self.currentPokerDataTab);
                self.currentPokerDataTab = 244;
            end
            --self.bDouble = false;
        end

        if (self.bSurrender) then
            log("Point21PlayerCtrl:chipExerciseEndCallBack")
            self:playerWinChips(self.currentGroupInt); --收走桌上自己的筹码
            --self.bSurrender = false;
        end

        if (Point21ZJCtrl.bLostEnd) then

            if (not Point21ZJCtrl.bPlayerLostMotionEndTab[self.idx]) then
                Point21ZJCtrl.bPlayerLostMotionEndTab[self.idx] = true;
            end

        else

            if (Point21ZJCtrl.bWinEnd) then

                if (not Point21ZJCtrl.bPlayerWinMotionEndTab[self.idx]) then
                    Point21ZJCtrl.bPlayerWinMotionEndTab[self.idx] = true;
                end

            end

        end

        --self:ChangeChipImg();
    end

end


function Point21PlayerCtrl:ChangeChipImg()
    if (Point21ScenCtrlPanel.bBeginThrwoChip) then
        local allChipValInt = self.allChipValIntTab[1];
        if (allChipValInt >= 2000) then
            local chipEndPosTra = self.chipsPosTra.transform:Find("EndPos");
            local traPos;
            local iCount = 0;
            for i = 0, chipEndPosTra.childCount - 1 do
                traPos = chipEndPosTra:GetChild(i);
                for j = 0, traPos.childCount - 1 do
                    if (iCount <= 2 and j == 0) then
                        iCount = iCount + 1;
                        for x = 0, traPos:GetChild(j).childCount - 1 do
                            if (traPos:GetChild(j):GetChild(x).gameObject.activeSelf) then
                                traPos:GetChild(j):GetChild(x):GetComponent('Image').sprite = traPos:GetChild(j):GetChild(traPos:GetChild(j).childCount - 2):GetComponent('Image').sprite;
                                break;
                            end
                        end
                        --numChildTra.transform:GetComponent('Image').sprite = numRes.transform:GetComponent('Image').sprite;
                    else
                        traPos:GetChild(j).gameObject:SetActive(false);
                    end
                end

            end
        end
    end
end


--设置扑克位置,越小的组号对应的childId越大
--pokerInst 扑克脚本实例
function Point21PlayerCtrl:getPokerInst(pokerInst)
    local gropIdx = self.currentGroupInt;
    if (self.bSplit and pokerInst.pokerOrder == 2) then --分牌时 且为第2组的牌
        gropIdx = gropIdx + 1;
    end
    local strGroupName = "PokerGroup" .. (self.pokerPosTra.childCount - gropIdx);
    local groupTra = self.pokerPosTra:Find(strGroupName);  --当前组的transform
    if (not groupTra.gameObject.activeSelf) then
        groupTra.gameObject:SetActive(true);
    end
    if (gropIdx > #self.pokerPointsTraTab) then --若当前组此时还未获取点数物体则添加
        self.pokerPointsTraTab[gropIdx] = pokerInst.transform:GetChild(0);
    end
    if (self.pokerInstTab[gropIdx]) then  --若存在此表 则在此表后直接添加
        table.insert(self.pokerInstTab[gropIdx], pokerInst);
    else --若不存在 则加入新的表
        local tempPokerInstTab = {};
        table.insert(tempPokerInstTab, pokerInst);
        logTable(tempPokerInstTab)
        logYellow("设置扑克 getPokerInst===========================")
        self.pokerInstTab[gropIdx] = tempPokerInstTab;
    end

    if (not pokerInst.bIsHalfway) then --不是中途进入
        pokerInst:moveToPos(groupTra);
    else --中途进入直接设置点数
        if (255 ~= pokerInst.byPokerDataByte) then  --庄家第2张牌不设置点数
            self:setPokerPoints(pokerInst.byPokerDataByte, gropIdx, pokerInst.bIsHalfway);
        end
    end
end


--设置扑克点数
-- pokerDataByte 单张牌数据 groupInt 所对应的组数  bIsHalfway是否中途进入
function Point21PlayerCtrl:setPokerPoints(pokerDataByte, groupInt, bIsHalfway)

    --local onePointInt = bit:_and(pokerDataByte, 15); --新拿到的扑克数据 低四位为点数， 15 = 00001111
    local onePointInt = Point21ResourcesNume.getPokerNum(pokerDataByte);
    local allPointStr = self.pokerPointsStrTab[groupInt]; --当前组总点数
    if (onePointInt >= 10) then
        onePointInt = 10;
    end

    if (allPointStr ~= "") then

        local allpointInt = tonumber(allPointStr);

        if (allpointInt) then --当前只有一个点数 既没有A

            allpointInt = allpointInt + onePointInt;
            allPointStr = allpointInt .. "";

            if (1 == onePointInt and allpointInt ~= 21) then --新发的牌为A 且不为21点时 计算下个点数

                allpointInt = allpointInt - onePointInt;

                allpointInt = allpointInt + 11;

                if (allpointInt <= 21) then

                    if (21 == allpointInt) then
                        allPointStr = allpointInt .. "";
                    else
                        allPointStr = allPointStr .. "/";
                        allPointStr = allPointStr .. tostring(allpointInt);
                    end

                end

            end

        else --当前有两个点数 既有A

            local listPointStr = string.split(allPointStr, "/");

            local pointInt1 = tonumber(listPointStr[1]);

            local pointInt2 = tonumber(listPointStr[2]);

            pointInt1 = pointInt1 + onePointInt;

            allPointStr = pointInt1 .. "";

            pointInt2 = pointInt2 + onePointInt;

            if (pointInt2 <= 21) then

                if (21 == pointInt2) then --若第2个等于21 只显示21
                    allPointStr = tostring(pointInt2) .. "";
                else
                    allPointStr = allPointStr .. "/";
                    allPointStr = allPointStr .. tostring(pointInt2);
                end

            end

        end

    else --当前还没有点数

        if (1 == onePointInt) then
            allPointStr = "1/11";
        else
            allPointStr = onePointInt .. "";
        end

    end

    self.pokerPointsStrTab[groupInt] = allPointStr;

    if (self.bDouble) then --双倍时只显示最终点数

        local tempPointInt = self:getPokerMaxPoint(allPointStr);
        if (tempPointInt > 0) then
            allPointStr = tempPointInt .. "";
        end
        self.bDouble = false;

    end

    self:showPokerPointText(allPointStr, groupInt);




    --    if(not bIsHalfway) then  --不是中途进入   --暂时不需要 只需要操作前报点数
    --        local tempPointInt = self:getPokerMaxPoint(allPointStr);
    --        if(tempPointInt > 0) then
    --            local sexByte;
    --            if( 6 == self.idx) then
    --                sexByte = 0;
    --            else
    --                sexByte = self.playerInfoTab._3bySex;
    --            end
    --            self:playMusic(tempPointInt, sexByte);
    --        end
    --    end
end


--显示扑克点数图片
-- pointStr 点数  groupInt 所对应的组数
function Point21PlayerCtrl:showPokerPointText(pointStr, groupInt)

    if (1 == #self.pokerInstTab and 2 == #self.pokerInstTab[1]) then  --玩家黑杰克
        local pointList = string.split(pointStr, "/");
        if (tonumber(pointList[1]) == 21) then
            if (not self.bIsBlackJack) then
                self:playMusic(Point21ResourcesNume.EnumSoundType.sound_blackjack, -1);
            end
            self.pokerPointsTraTab[groupInt]:GetComponent('Image').enabled = true;
            self.pokerPointsTraTab[groupInt]:GetChild(0).gameObject:SetActive(false);
            self.bIsBlackJack = true;
            logYellow("XXXXXXXXXXX-------玩家 id : " .. self.idx .. " is black jack!");            
            return;
        end
    end
    self.pokerPointsTraTab[groupInt]:GetChild(0).gameObject:SetActive(true);
    self.pokerPointsTraTab[groupInt]:GetChild(0):GetChild(0):GetComponent('Text').text = pointStr;
    if (not self.bSplit) then return; end  --当前为分牌动作时 则等2组牌动作都完成后再处理后面消息
    if (not self.bStop) then --若为停牌则在 分牌动作全部结束后再处理
        if (groupInt > self.currentGroupInt) then
            self.bSplit = false;
        end
        return;
    end
    if (groupInt == self.currentGroupInt) then
        self.bOne = true;
    end
    if (groupInt > self.currentGroupInt) then
        self.bTwo = true;
    end

end

--显示扑克点数图片
-- pointStr 点数  groupInt 所对应的组数
function Point21PlayerCtrl:showPokerPointImage(pointStr, groupInt)

    local pointList = string.split(pointStr, "/");

    if (#pointList >= 1) then


        self.pokerPointsTraTab[groupInt].gameObject:SetActive(true);

        if (1 == #self.pokerInstTab and 2 == #self.pokerInstTab[1]) then  --玩家黑杰克

            if (tonumber(pointList[1]) == 21) then

                if (not self.bIsBlackJack) then
                    self:playMusic(Point21ResourcesNume.EnumSoundType.sound_blackjack, -1);
                end

                self.pokerPointsTraTab[groupInt]:GetComponent('Image').enabled = true;
                for i = 0, self.pokerPointsTraTab[groupInt].transform.childCount - 1 do --隐藏所有点数

                    self.pokerPointsTraTab[groupInt]:GetChild(i).gameObject:SetActive(false);
                end
                self.bIsBlackJack = true;
                logYellow("玩家 id : " .. self.idx .. " is black jack!");
                return;
            end



        end


        local showPointStr = {}; --要显示的数字

        local pointsParentTra; --点数父物体


        if (#pointList > 1) then
            pointsParentTra = self.pokerPointsTraTab[groupInt]:GetChild(1);
            self.pokerPointsTraTab[groupInt]:GetChild(0).gameObject:SetActive(false);
        else
            pointsParentTra = self.pokerPointsTraTab[groupInt]:GetChild(0);
            self.pokerPointsTraTab[groupInt]:GetChild(1).gameObject:SetActive(false);
        end

        pointsParentTra.gameObject:SetActive(true);

        local pointsTra = pointsParentTra.transform:GetChild(0);
        --        if(6 == self.idx) then
        --            pointsTra = pointsParentTra;
        --        else
        --            pointsTra = pointsParentTra.transform:GetChild(0);
        --        end
        for i = #pointList, 1, -1 do

            for j = #pointList[i], 1, -1 do
                table.insert(showPointStr, string.sub(pointList[i], j, j)); --将要显示的数字倒叙存入showPointStr
            end

        end

        for i = 1, pointsTra.transform.childCount do --给数字图片物体添加对应的图片

            local numTra = pointsTra.transform:GetChild(i - 1); --数字图片物体

            if (i <= #showPointStr) then
                numTra.gameObject:SetActive(true);

                local numRes = Point21ScenCtrlPanel.pointNumObjRes.transform:GetChild(tonumber(showPointStr[i])); --要显示的图片资源

                numTra.transform:GetComponent('Image').sprite = numRes.transform:GetComponent('Image').sprite;
            else
                numTra.gameObject:SetActive(false);
            end

        end

        if (#pointList >= 2) then --有A的情况
            pointsTra.transform:GetChild(pointsTra.transform.childCount - 1).gameObject:SetActive(true);
        else
            --pointsTra.transform:GetChild(pointsTra.transform.childCount - 1).gameObject:SetActive(false);
        end

    end


    if (not self.bSplit) then return; end  --当前为分牌动作时 则等2组牌动作都完成后再处理后面消息

    if (not self.bStop) then --若为停牌则在 分牌动作全部结束后再处理
        if (groupInt > self.currentGroupInt) then
            self.bSplit = false;
        end
        return;
    end


    if (groupInt == self.currentGroupInt) then
        self.bOne = true;
    end

    if (groupInt > self.currentGroupInt) then
        self.bTwo = true;
    end



end


--获取扑克最大有效点数
--allPointStr 当前组总点数
function Point21PlayerCtrl:getPokerMaxPoint(allPointStr)
    --local allPointStr = self.pokerPointsStrTab[groupInt]; --当前组总点数
    local pointList = string.split(allPointStr, "/");

    if (#pointList >= 1) then

        if (#pointList == 1) then
            if (tonumber(pointList[1]) <= 21) then
                return tonumber(pointList[1]);
            else
                return 0;
            end
        else

            local pointInt1 = tonumber(pointList[1]);
            local pointInt2 = tonumber(pointList[2]);

            local maxPointInt = pointInt1 > pointInt2 and pointInt1 or pointInt2;
            local smallPointInt = pointInt1 < pointInt2 and pointInt1 or pointInt2;

            if (maxPointInt <= 21) then
                return maxPointInt;
            elseif (smallPointInt <= 21) then
                return smallPointInt;
            else
                return 0;
            end

        end

    end

end

--改变扑克颜色，在爆牌、投降、分牌时会将不参与必点的牌置灰（若分牌了 再所有组操作完后 将不许置灰的牌还原）
--thisColor   当前颜色       groupIdxInt   当前组
function Point21PlayerCtrl:setPokerColor(thisColor, groupIdxInt)

    for i = 1, #self.pokerInstTab[groupIdxInt] do
        if(self.pokerInstTab[groupIdxInt][i]~=nil and self.pokerInstTab[groupIdxInt][i].transform~=nil)then
            self.pokerInstTab[groupIdxInt][i].transform:GetComponent('Image').color = thisColor;
        end
    end

    --    for i = 0, (self.pokerPointsTraTab[groupIdxInt].transform.childCount - 1 ) do
    --        self.pokerPointsTraTab[groupIdxInt].transform:GetChild(i):GetComponent('Image').color = thisColor;
    --    end
end

--扑克运动结束回调
--pokerDataInt 扑克数据 inst 扑克实例
function Point21PlayerCtrl:pokerExerciseEndCallBack(inst)
    local gropIdx = self.currentGroupInt;
    local lastgroupidx=self.currentGroupInt;
    if (self.bSplit and inst.pokerOrder == 2) then --分牌时 且为第2组的牌
        gropIdx = gropIdx + 1;
        self:setPokerColor(Color.gray, gropIdx); --将第2组置灰
    end
    self:setPokerPoints(inst.byPokerDataByte, gropIdx);
    if (self.bBurst and inst.pokerOrder == 1) then
        self.groupColorTab[self.currentGroupInt] = Color.gray; --改变当前组的默认颜色

        if (zjPos == self.idx) then
            --Point21ZJCtrl.zjBurstPoker();
        else
            log("12112222222")
            --self:playerLostChips(self.currentGroupInt);
            if (not self.chipsNumImageTra.gameObject.activeSelf) then self.chipsNumImageTra.gameObject:SetActive(true); end
            self:showNumberImage(self.allChipNumInt, self.chipsNumImageTra, Point21ScenCtrlPanel.numObjRes.transform); --爆牌后重新设置下注值
        end
        self:bustPoker(inst, self.currentGroupInt);
        --self:AutoStopCard();
        self:playerOperateEnd();
        if(self.pokerPointsStrTab[2]~=nil)then
            self.bBurst = false; 
        end
    end 

        logYellow("self.bBurst:="..tostring(self.bBurst).."self.bSplit:="..tostring(self.bSplit))
        if (((tonumber(self.pokerPointsStrTab[self.currentGroupInt]) == 21 or self.bBurst) and self.idx ~= zjPos) or (self.bIsBlackJack and self.idx ~= zjPos)) then
            log("self.currentGroupInt:" .. self.pokerPointsStrTab[self.currentGroupInt] .. "  需要自动停牌？")                        
            if(TempoperateDataTab~=nil and TempoperateDataTab.byChairID == myChairID  ) then
              --  log("需要自动停牌111111")
               -- self:AutoStopCard();
            end
            self:playerOperateEnd();
            --self:stopPokerOperation();
        end
        logYellow("lastgroupidx:"..lastgroupidx.."self.currentGroupInt:"..self.currentGroupInt)
        --[[
        if(lastgroupidx ~=self.currentGroupInt and TempoperateDataTab.byChairID == myChairID ) then
            if(tonumber(self.pokerPointsStrTab[self.currentGroupInt]) == 21)then                
               
                log("需要自动停牌22222")
                self:AutoStopCard();
                Point21ScenCtrlPanel.showOperation(false, false,true)
            end
        end
        if(TempoperateDataTab~=nil)then            
            logYellow("TempoperateDataTab:"..tostring(TempoperateDataTab==nil).."TempoperateDataTab.bSelfStopPokerByte:"..TempoperateDataTab.bSelfStopPokerByte.." TempoperateDataTab.bBustPokerByte:".. TempoperateDataTab.bBustPokerByte)
        else
            logYellow("TempoperateDataTab: nil")
        end
        
        if(TempoperateDataTab~=nil and (TempoperateDataTab.bSelfStopPokerByte==1 or  TempoperateDataTab.bBustPokerByte==1 ) and TempoperateDataTab.byChairID == myChairID ) then
            logYellow("隐藏操作按钮222=============")
            Point21ScenCtrlPanel.showOperation(false, false)         
        end
        ]]
        

end

function Point21PlayerCtrl:AutoStopCard()
    local data =    {
        [1] = Point21DataStruct.CMD_BlackJack.enPlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_STAND_POKER
    }
    local buffer = SetC2SInfo(Point21DataStruct.CMD_CS_PLAYER_NORMAL_OPERATE, data)
    Network.Send(
    MH.MDM_GF_GAME,
    Point21DataStruct.CMD_BlackJack.SUB_CS_PLAYER_NORMAL_OPERATE,
    buffer,
    gameSocketNumber.GameSocket
    )
end

--设置扑克位置 在单组牌超过4张时会左移
function Point21PlayerCtrl:setPokerPos(gropIdx)

    if (zjPos ~= self.idx) then
        if (gropIdx > 1) then --有多组牌时
            if (#self.pokerInstTab[gropIdx - 1] < 4 and #self.pokerInstTab[gropIdx] == 4) then --若上一组牌小于4张说明上组牌没移动过此组移动
                self.pokerPosTra.transform.localPosition = Vector3.New(self.pokerPosTra.transform.localPosition.x - pokeMovePosX,
                self.pokerPosTra.transform.localPosition.y,
                self.pokerPosTra.transform.localPosition.z);

                self.pointsPosTra.transform.localPosition = Vector3.New(self.pointsPosTra.transform.localPosition.x - pokeMovePosX,
                self.pointsPosTra.transform.localPosition.y,
                self.pointsPosTra.transform.localPosition.z);
            end
        else

            if (#self.pokerInstTab[gropIdx] == 4) then --若 此组牌超过4张则向左移动
                self.pokerPosTra.transform.localPosition = Vector3.New(self.pokerPosTra.transform.localPosition.x - pokeMovePosX,
                self.pokerPosTra.transform.localPosition.y,
                self.pokerPosTra.transform.localPosition.z);

                self.pointsPosTra.transform.localPosition = Vector3.New(self.pointsPosTra.transform.localPosition.x - pokeMovePosX,
                self.pointsPosTra.transform.localPosition.y,
                self.pointsPosTra.transform.localPosition.z);
            end

        end

        if (5 == self.idx and not self.b5pointBoxMove) then

            for gro = 1, #self.pokerInstTab do --扑克实例循环

                if (#self.pokerInstTab[gro] == 4) then --判断牌数

                    self.point1Tra_Gro_0_5.transform.localPosition = Vector3.New(self.point1Tra_Gro_0_5.transform.localPosition.x + pokeMovePosX,
                    self.point1Tra_Gro_0_5.transform.localPosition.y,
                    self.point1Tra_Gro_0_5.transform.localPosition.z);

                    self.point1Tra_Gro_1_5.transform.localPosition = Vector3.New(self.point1Tra_Gro_1_5.transform.localPosition.x + pokeMovePosX,
                    self.point1Tra_Gro_1_5.transform.localPosition.y,
                    self.point1Tra_Gro_1_5.transform.localPosition.z);
                    self.b5pointBoxMove = true;
                    break;
                end --判断牌数 end

            end --扑克实例循环 end

        end

    end

end



--爆牌处理
--poker 最后一张扑克实例  groupIdx爆牌的组
function Point21PlayerCtrl:bustPoker(poker, groupIdx)
    self:playMusic(Point21ResourcesNume.EnumSoundType.sound_bust, -1);
    local bustImageTra = poker.transform:Find("ImageBust"); --“爆”图片
    bustImageTra.gameObject:SetActive(true);
    self:SetBustImg(groupIdx, bustImageTra);
    self.bBustTimer = true;
end

--设置爆牌时的点数图片
function Point21PlayerCtrl:SetBustPointImg(pointsTra, groupIdx)

    local allPointStr = self.pokerPointsStrTab[groupIdx]; --当前组总点数

    if (allPointStr ~= "") then

        local allpointInt = tonumber(allPointStr);
        if (not allpointInt) then return; end

        local showPointStr = {}; --要显示的数字

        for i = #allPointStr, 1, -1 do
            table.insert(showPointStr, string.sub(allPointStr, i, i)); --将要显示的数字倒叙存入showPointStr
        end

        for i = 1, pointsTra.transform.childCount do --给数字图片物体添加对应的图片

            local numTra = pointsTra.transform:GetChild(i - 1); --数字图片物体

            if (i <= #showPointStr) then
                --local numRes = LoadAsset(Point21ResourcesNume.dbResNameStr, 'NumberBustImage');
                local numRes = Point21ScenCtrlPanel.Pool("NumberBustImage");
                local numSprite = numRes.transform:GetChild(tonumber(showPointStr[i])):GetComponent('Image'); --要显示的图片资源
                numTra.transform:GetComponent('Image').sprite = numSprite.sprite;
            end

        end

    end

end


--爆牌显示计时器
function Point21PlayerCtrl:bustPokerTimer()


    --    if(self.bBustTimer) then
    --        self.bustTempTimeF = self.bustTempTimeF + Time.deltaTime;
    --        if(self.bustTempTimeF >= self.bustTime)then
    --            self.bBustTimer = false;
    --            self.bustTempTimeF = 0;
    --            if( self.bustImageTra ) then
    --                self.bustImageTra.gameObject:SetActive(false);
    --            end
    --        end
    --    end
end



--玩家普通操作
--operateDataTab 普通操作数据
function Point21PlayerCtrl:playerOperate(operateDataTab)
    TempoperateDataTab=operateDataTab
    if (self.idx ~= zjPos) then
        self:setTimer(false, 0, true); --隐藏时间条
        self:setCountDownTimer(false); --停止倒计时时间
    end
    if (operateDataTab.byChairID == myChairID) then --自己控制的角色
        Point21ScenCtrlPanel.bInoperation = true;
        if(tonumber(self.pokerPointsStrTab[2]) == 21 and tonumber(self.pokerPointsStrTab[1])==21)then
                log("需要自动停牌33333")
                self:AutoStopCard();
                Point21ScenCtrlPanel.showOperation(false, false)
        end
    end
    local musicTypeInt = 0;-- 音乐索引
    local sexByte; -- 性别
    if (zjPos == self.idx) then
        sexByte = 0;
    else
        sexByte = self.playerInfoTab._3bySex;
    end
    if (Point21DataStruct.CMD_BlackJack.enPlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_AUTO_ADD_POKER == operateDataTab.OperateTypeTab or
    Point21DataStruct.CMD_BlackJack.enPlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_HIT_POKER == operateDataTab.OperateTypeTab) then --自动补牌和拿牌
        musicTypeInt = Point21ResourcesNume.EnumVoiceType.voice_m_024;
        Point21ZJCtrl.createPokers(self.idx, operateDataTab.pokerDataTab);

    end
    if (Point21DataStruct.CMD_BlackJack.enPlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_DOUBLE_CHIP == operateDataTab.OperateTypeTab or
    Point21DataStruct.CMD_BlackJack.enPlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_SPLIT_POKER == operateDataTab.OperateTypeTab) then --双倍和分牌
        if (Point21DataStruct.CMD_BlackJack.enPlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_DOUBLE_CHIP == operateDataTab.OperateTypeTab) then --双倍
            musicTypeInt = Point21ResourcesNume.EnumVoiceType.voice_m_027;
            self.bDouble = true;
        end
        if (Point21DataStruct.CMD_BlackJack.enPlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_SPLIT_POKER == operateDataTab.OperateTypeTab) then --分牌
           -- logYellow("分牌开始")
            local poker2Inst = self.pokerInstTab[1][2];  --取出第一组牌的第2张牌
            local group2Tra = self.pokerPosTra:GetChild(0);   -- 第2组的父物体 transform
            poker2Inst.transform:SetParent(group2Tra);
            group2Tra.gameObject:SetActive(true);
         --   logYellow("self.pokerInstTab[1] :length:"..#self.pokerInstTab)
         --   logYellow("self.pokerInstTab[1][1]:"..self.pokerInstTab[1][1].transform.gameObject.name.."self.pokerInstTab[1][2]:"..self.pokerInstTab[1][2].transform.gameObject.name)
         --   logYellow("group2Tra:"..group2Tra.gameObject.name.."poker2Inst:"..poker2Inst.transform.gameObject.name)
            local tempPokerInstTab = {};
            table.insert(tempPokerInstTab, poker2Inst);
            self.pokerInstTab[self.currentGroupInt + 1] = tempPokerInstTab; --将第2张牌的实例加入表
            table.remove(self.pokerInstTab[self.currentGroupInt], 2); --将原表中的第2张实例删除
            self.pokerPointsTraTab[self.currentGroupInt + 1] = poker2Inst.transform:GetChild(0) --self.pointsPosTra.transform:GetChild(1);--:GetChild(0); --将第2组的点数图片加入表
            self.pointsPosTra.transform:GetChild(0).localPosition = Vector3.New(self.pointsPosTra.transform:GetChild(0).localPosition.x, 0, self.pointsPosTra.transform:GetChild(0).localPosition.z); --第一组点数下移
         --   logYellow("self.pointsPosTra.transform:GetChild(0):"..self.pointsPosTra.transform:GetChild(0).gameObject.name)
            self.pokerPointsStrTab =            {
                [1] = "";
                [2] = "";
            }; --重置每组扑克点数
            self:setPokerPoints(self.pokerInstTab[self.currentGroupInt][1].byPokerDataByte, self.currentGroupInt);
            self:setPokerPoints(poker2Inst.byPokerDataByte, self.currentGroupInt + 1);
            self.bSplit = true;
        end
        local allChipValInt = self.allChipValIntTab[self.currentGroupInt];
        self:throwChips(Point21DataStruct.E_CHIPTYPE_NORMAL, allChipValInt);
        self.currentPokerDataTab = operateDataTab.pokerDataTab;
    end
    if (Point21DataStruct.CMD_BlackJack.enPlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_SURRENDER == operateDataTab.OperateTypeTab or
    Point21DataStruct.CMD_BlackJack.enPlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_STAND_POKER == operateDataTab.OperateTypeTab) then --投降和停牌

        if (Point21DataStruct.CMD_BlackJack.enPlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_SURRENDER == operateDataTab.OperateTypeTab) then  --投降
            musicTypeInt = Point21ResourcesNume.EnumVoiceType.voice_m_028;
            self.bSurrender = true;
            self:setPokerColor(Color.gray, self.currentGroupInt); --置灰此组
            local allChipValInt = self.allChipValIntTab[self.currentGroupInt];
            self:playerWinChips(self.currentGroupInt);
            self:throwChips(Point21DataStruct.E_CHIPTYPE_NORMAL, allChipValInt / 2);
        end
        if (Point21DataStruct.CMD_BlackJack.enPlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_STAND_POKER == operateDataTab.OperateTypeTab) then  --停牌
            self.bStop = true;
            if (not self.bAutoAddPokerToBust) then --不是自动补拍时爆牌了 处理停牌消息
                if (not self.bSplit) then --如没有处理分牌动作则停牌
                    self:stopPokerOperation();
                end
            else --自动补牌爆牌了 不处理停牌消息
                self.bAutoAddPokerToBust = false;
            end
        end
    end
    if (operateDataTab.bBustPokerByte > 0) then
        self.bBurst = true;
        if (Point21DataStruct.CMD_BlackJack.enPlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_AUTO_ADD_POKER == operateDataTab.OperateTypeTab) then
            self.bAutoAddPokerToBust = true;
        end
    end
end


--停牌处理
function Point21PlayerCtrl:stopPokerOperation()
    local sexByte = 1;
    if (zjPos == self.idx) then
        sexByte = 0;
    else
        sexByte = self.playerInfoTab._3bySex;
    end
    local tempPointInt = self:getPokerMaxPoint(self.pokerPointsStrTab[self.currentGroupInt]); --当前点数
    local tempPointStr = tempPointInt .. "";
    if (tempPointInt > 0) then
        --self:playMusic(tempPointInt, sexByte);
        self:showPokerPointText(tempPointStr, self.currentGroupInt);
    end

    self:playerOperateEnd();
end

--设置扑克层级
function Point21PlayerCtrl:SetPoklerIndex(bSet)
    local iCurIdx = 0;
    if (bSet) then
        self.pokerPosTra.transform:GetChild(iCurIdx):SetSiblingIndex(iCurIdx + 1);
    else
        local strIdx = string.sub(self.pokerPosTra.transform:GetChild(iCurIdx).name, #self.pokerPosTra.transform:GetChild(iCurIdx).name);
        if (tonumber(strIdx) == self.pokerPosTra.transform:GetChild(iCurIdx):GetSiblingIndex()) then return; end
        self.pokerPosTra.transform:GetChild(iCurIdx):SetSiblingIndex(tonumber(strIdx));
    end
end

--玩家操作结束 在爆牌和停牌时处理
function Point21PlayerCtrl:playerOperateEnd()
    if (self.currentGroupInt < #self.pokerInstTab) then --若当前组数小于总牌组说 说明还有下一组
        self:setPokerColor(Color.gray, self.currentGroupInt); --将此组置灰
        self.currentGroupInt = self.currentGroupInt+1;
        self:setPokerColor(Color.white, self.currentGroupInt);--将新组还原
        self:SetPoklerIndex(true); 
    else
        for i = 1, #self.pokerInstTab do
            self:setPokerColor(self.groupColorTab[i], i); --将所以组设置成该有的颜色
        end
        self:SetPoklerIndex(false);
    end
    --logYellow("NormaloperateDataTab.byChairID :"..NormaloperateDataTab.byChairID.." myChairID:"..myChairID)        

end

--设置玩家操作提示
function Point21PlayerCtrl:SetOperTitle(bShow, iGroup)
    if (bShow) then
        logYellow("显示操作提示边框光圈")
        if (not self.traOperTilte.gameObject.activeSelf) then self.traOperTilte.gameObject:SetActive(true); end
        local iCurIdx = self.traOperTilte.childCount - iGroup;
        local traTitle = self.traOperTilte:GetChild(iCurIdx);
        traTitle.gameObject:SetActive(true);

        local moveX = self.resultIncrementWidthF * (#self.pokerInstTab[iGroup] - 1); --x方向需要移动的距离 5为偏移定值
        local traMove = traTitle:Find("Right");
        traMove.localPosition = Vector3.New(moveX, traMove.localPosition.y, traMove.localPosition.z);

        self.dotweenTitle = traTitle.transform:DOScale(Vector3.New(1.2, 1.2, 1), 0.5);
        self.dotweenTitle:SetEase(DG.Tweening.Ease.Linear):SetLoops(-1, DG.Tweening.LoopType.Yoyo);

        self.traOperTilte:GetChild(self.traOperTilte.childCount - iCurIdx - 1).gameObject:SetActive(false);
    else
        self.traOperTilte.gameObject:SetActive(false);
        if (self.dotweenTitle) then
            self.dotweenTitle:Pause():Rewind(true);
            self.dotweenTitle = nil
        end
    end
end


--获取玩家筹码
--groupInt 筹码对应的组 
--return 要获取的所有筹码
function Point21PlayerCtrl:getPlayreChips(groupInt)

    local tab = {};

    if (zjPos ~= self.idx) then

        if (self.allChipNumInt > 0) then

            for i = 1, #self.chipInstTab[groupInt] do
                table.insert(tab, self.chipInstTab[groupInt][i]);
            end

            return tab;

        else

            return nil;
        end

    else

        return nil;
    end



end

-- 玩家赢得筹码
--groupInt 筹码对应的组 当为0时为保险筹码
function Point21PlayerCtrl:playerWinChips(groupInt)
    if (0 == groupInt) then

        if (self.insuranceChipValInt > 0) then
            log("这里ba")
            for i = 1, #self.InsuranceChipInstTab do
                self.InsuranceChipInstTab[i]:moveToPos(self.transform, true);
            end
            self.insuranceChipValInt = 0;
        end

        if (self.bIsBlackJack) then
            log("这里baz")
            for i = 1, #self.chipInstTab[1] do
                self.chipInstTab[1][i]:moveToPos(self.transform, true);
            end

            self.bIsBlackJack = false;
        end

        return;

    end

    if (zjPos ~= self.idx) then
        if (self.allChipNumInt > 0) then
            logYellow("?????????")
            if(self.chipInstTab[groupInt]~=nil and self.chipInstTab~=nil)then
                for i = 1, #self.chipInstTab[groupInt] do
                    self.chipInstTab[groupInt][i]:moveToPos(self.transform, true);
                end
            end
            self.chipInstTab[groupInt] = {};

            self.allChipNumInt = self.allChipNumInt - self.allChipValIntTab[groupInt];

            self.allChipValIntTab[groupInt] = 0;
        end
    end

end


--玩家输掉筹码
--groupInt 筹码对应的组 当为0时为保险筹码
function Point21PlayerCtrl:playerLostChips(groupInt)
    log("Point21PlayerCtrl:playerLostChips:" .. groupInt)
    if (0 == groupInt) then
        if (self.insuranceChipValInt > 0) then
            for i = 1, #self.InsuranceChipInstTab do
                self.InsuranceChipInstTab[i]:moveToPos(Point21ZJCtrl.chipsPos, true);
            end
        end

    else
        if (zjPos ~= self.idx) then
            for i = 1, #self.chipInstTab[groupInt] do
                self.chipInstTab[groupInt][i]:moveToPos(Point21ZJCtrl.chipsPos, true);
            end
            self.chipInstTab[groupInt] = {};
            self.allChipNumInt = self.allChipNumInt - self.allChipValIntTab[groupInt];
            self.allChipValIntTab[groupInt] = 0;
        end
    end
end

--设置玩家获得特殊下注筹码
function Point21PlayerCtrl:SetplayerWinSpChips(iType, insZjChip)

    if (iType == Point21DataStruct.E_CHIPTYPE_NORMAL_D) then
        table.insert(self.tabSpDChipInst, insZjChip);
    elseif (iType == Point21DataStruct.E_CHIPTYPE_NORMAL_A13) then
        table.insert(self.tabSpA13ChipInst, insZjChip);
    elseif (iType == Point21DataStruct.E_CHIPTYPE_NORMAL_S13) then
        table.insert(self.tabSpS13ChipInst, insZjChip);
    end

end

--玩家获得特殊下注筹码
function Point21PlayerCtrl:GetplayerWinSpChips(iType)

    local tabTemp = {}
    if (iType == Point21DataStruct.E_CHIPTYPE_NORMAL_D) then
        tabTemp = self.tabSpDChipInst;
    elseif (iType == Point21DataStruct.E_CHIPTYPE_NORMAL_A13) then
        tabTemp = self.tabSpA13ChipInst;
    elseif (iType == Point21DataStruct.E_CHIPTYPE_NORMAL_S13) then
        tabTemp = self.tabSpS13ChipInst;
    else
        return;
    end

    local funCallBack = nil;
    logYellow("xxxxxxxxxx#tab " .. #tabTemp);
    for i = 1, #tabTemp do
        if (1 == i) then

            funCallBack = function()
                self:ShowSpCGameResult(false);
            end
        end
        tabTemp[i]:moveToPos(self.transform, true, fSpChipSpeed, funCallBack);
    end

end

--设置特殊筹码数值状态
function Point21PlayerCtrl:SetSpChipNumber(iType, chipsNumInt)

    if (iType >= Point21DataStruct.E_CHIPTYPE_NORMAL_D and iType <= Point21DataStruct.E_CHIPTYPE_NORMAL_S13) then
        local traNum = self.traSpChipNum:GetChild(iType - Point21DataStruct.E_CHIPTYPE_NORMAL_D);
        if (not traNum.gameObject.activeSelf) then traNum.gameObject:SetActive(true); end
        local iNum = 0;
        if (Point21DataStruct.E_CHIPTYPE_NORMAL_D == iType) then
            self.iSpDChaipNum = self.iSpDChaipNum + chipsNumInt;
            iNum = self.iSpDChaipNum;
        elseif (Point21DataStruct.E_CHIPTYPE_NORMAL_A13 == iType) then
            self.iSpA13ChaipNum = self.iSpA13ChaipNum + chipsNumInt;
            iNum = self.iSpA13ChaipNum;
        elseif (Point21DataStruct.E_CHIPTYPE_NORMAL_S13 == iType) then
            self.iSpS13ChaipNum = self.iSpS13ChaipNum + chipsNumInt;
            iNum = self.iSpS13ChaipNum;
        else
            return;
        end
        self:showNumberImage(iNum, traNum, Point21ScenCtrlPanel.numObjRes.transform);
    else
        for i = 0, self.traSpChipNum.childCount - 1 do self.traSpChipNum:GetChild(i).gameObject:SetActive(false); end
    end
end

--显示特殊游戏结果
function Point21PlayerCtrl:ShowSpCGameResult(bShow, iwinNum)

    local traWinNum = self.transform:Find("WinSpNum");
    traWinNum.gameObject:SetActive(bShow);
    --    if(not bShow) then self:SetSpChipNumber(-1); return; end
    if (not bShow) then return; end
    if (iwinNum <= 0) then return; end

    --local res = LoadAsset(Point21ResourcesNume.dbResNameStr, 'NumberWin');
    local res = Point21ScenCtrlPanel.Pool("NumberWin");
    self:showNumberImage(iwinNum, traWinNum, res, false, true);

end


--显示结算信息
function Point21PlayerCtrl:showResultInfo(winGoldInt, winType)

    local resultRes = Point21ScenCtrlPanel.resultRes; --结算资源
    local resultImageRes; --当前显示的结算图片资源
    if (self.bSurrender == true) then
        winType = 2;
        winGoldInt = 0 - self.allChipNumInt;
        log("结算：" .. winType .. "  " .. winGoldInt);
    end
    local resultStr = ""; --记录输赢状态
    local addStr = "+"; --正号
    if (winType == 0) then   --赢
        resultStr = "WinNum";
        resultImageRes = resultRes.transform:Find("ImageWin");

    elseif (winType == 2) then --输
        addStr = "";
        resultStr = "TextLost";
        resultImageRes = resultRes.transform:Find("ImageLose");
    else   --平
        resultStr = "";
        resultImageRes = resultRes.transform:Find("ImageTied");
    end
    if (not self.imageResultTra) then  --防止玩家中途退出
        return;
    end
    for i = 0, self.imageResultTra.childCount - 2 do --最后一个为图片 不进行比较

        local textResult = self.imageResultTra:GetChild(i);

        if ("WinNum" == resultStr and resultStr == textResult.name) then --要显示的Text
            local res = Point21ScenCtrlPanel.Pool("NumberWin");
            self:showNumberImage(winGoldInt, textResult.transform, res, false, true);
            textResult.gameObject:SetActive(true);
        else
            textResult.gameObject:SetActive(false);
        end
    end
    self.imageResultTra.transform:Find("Image"):GetComponent('Image').sprite = resultImageRes.transform:GetComponent('Image').sprite;
    self.imageResultTra:Find("Image").gameObject:SetActive(true);
    
    self.imageResultTra.gameObject:SetActive(true);
    Point21ScenCtrlPanel.showOperation(false, false)
end




--点击玩家头像响应事件
function Point21PlayerCtrl.onClickInfoBoxBtn(prefab)

end

function Point21PlayerCtrl:showNumber64IntText(numInt, numTra)

    local numStr = "";

    if (toInt64(numInt) >= toInt64(10000)) then -- 大于一万 使用“万”字图片
        --error("int is : 10000");
        numStr = tostring(numInt / 10000) .. "w";

        if (toInt64(numInt) >= toInt64(100000000)) then -- 大于一亿 使用“亿”字图片
            --error("int is : 100000000");
            numStr = tostring(numInt / 100000000) .. "y";
        end

        local front = string.sub(numStr, 1, (#numStr) - 1); --数字部分
        local endStr = string.sub(numStr, #numStr, #numStr); --"万" “亿” 部分

        if (#front > 4) then --若数字部分长度大于4 则取前4位
            front = string.sub(front, 1, 4);
        end

        if ("." == string.sub(front, 4, 4)) then --若第4位是符号 '.' 则省去
            front = string.sub(front, 1, (#front) - 1);
        end

        if (endStr == "w") then
            endStr = "万";
        elseif (endStr == "y") then
            endStr = "亿";
        end

        numStr = front .. endStr; --将数字部分与 "万" "亿" 连接

    else
        numStr = tostring(numInt);
    end

    numTra.transform:GetComponent('Text').text = numStr;
end

function Point21PlayerCtrl:showNumber32IntText(numInt, numTra)

    local numStr = "";
    local tempNumInt = 0;

    if (numInt / 10000 >= 1) then -- 大于一万 使用“万”字图片
        --error("int is : 10000");
        tempNumInt = numInt / 10000;
        numStr = tempNumInt .. "w";

        if (numInt / 100000000 >= 1) then -- 大于一亿 使用“亿”字图片
            --error("int is : 100000000");
            tempNumInt = numInt / 100000000;
            numStr = tempNumInt .. "y";
        end

        local front = string.sub(numStr, 1, (#numStr) - 1); --数字部分
        local endStr = string.sub(numStr, #numStr, #numStr); --"万" “亿” 部分

        if (#front > 4) then --若数字部分长度大于4 则取前4位
            front = string.sub(front, 1, 4);
        end

        if ("." == string.sub(front, 4, 4)) then --若第4位是符号 '.' 则省去
            front = string.sub(front, 1, (#front) - 1);
        end

        if (endStr == "w") then
            endStr = "万";
        elseif (endStr == "y") then
            endStr = "亿";
        end

        numStr = front .. endStr; --将数字部分与 "万" "亿" 连接

    else
        tempNumInt = numInt;
        numStr = tempNumInt .. "";
    end

    numTra.transform:GetComponent('Text').text = numStr;
end

--显示数字字符
--numInt  显示的数字,  numTra 显示数字的物体
function Point21PlayerCtrl:showNumberText(numInt, numTra)

    --numTra.gameObject:SetActive(true);
    local i64Num = toInt64(numInt);

    if (i64Num <= toInt64(2100000000)) then
        self:showNumber32IntText(numInt, numTra);
    else
        self:showNumber64IntText(numInt, numTra);
    end

end


--显示数字图片
-- numInt 数值    numTra 数字图片物体       bCutOutNum 是否截取数字
function Point21PlayerCtrl:showNumberImage(numInt, numTra, numBaseRes, bCutOutNum, bWin)

    bCutOutNum = bCutOutNum or false;

    if (numInt <= 0) then
        numTra.gameObject:SetActive(false);
        return;
    end

    local numStr = "";
    local tempNumInt = 0;

    if (numInt / 10000 >= 1 and bCutOutNum) then -- 大于一万 使用“万”字图片
        --error("int is : 10000");
        tempNumInt = numInt / 10000;
        numStr = tempNumInt .. "w";

        if (numInt / 100000000 >= 1) then -- 大于一亿 使用“亿”字图片
            --error("int is : 100000000");
            tempNumInt = numInt / 100000000;
            numStr = tempNumInt .. "y";
        end

        local front = string.sub(numStr, 1, (#numStr) - 1); --数字部分
        local endStr = string.sub(numStr, #numStr, #numStr); --"万" “亿” 部分

        if (#front > 4) then --若数字部分长度大于4 则取前4位
            front = string.sub(front, 1, 4);
        end

        if ("." == string.sub(front, 4, 4)) then --若第4位是符号 '.' 则省去
            front = string.sub(front, 1, (#front) - 1);
        end

        numStr = front .. endStr; --将数字部分与 "万" "亿" 连接

    else
        tempNumInt = numInt;
        if (bWin) then numStr = "+" .. tempNumInt
        else numStr = tempNumInt .. ""; end

    end

    --error("str is : " .. numStr);
    local showNumStrTab = {}; --要显示的数字 字符串表

    for i = 1, #numStr do
        table.insert(showNumStrTab, string.sub(numStr, i, i)); --将要显示的数字字符串存入showNumStrTab
    end

    numTra.gameObject:SetActive(true);

    local numsBeginCount = numTra.transform.childCount; --数字图片的初始个数

    for i = 1, #showNumStrTab do

        local numChildTra; -- 数字图片物体子物体 

        if (i <= numsBeginCount) then --已经存在的直接改变图片
            numChildTra = numTra.transform:GetChild(i - 1);
        else --不存在的先创建
            numChildTra = newobject(numTra.transform:GetChild(0).gameObject).transform;
            numChildTra.transform:SetParent(numTra);
            numChildTra.transform.localScale = Vector3.one;
            numChildTra.transform.localPosition = Vector3.New(0, 0, 0);
        end

        numChildTra.gameObject:SetActive(true);

        local numRes;

        local strRes = ""

        if (tonumber(showNumStrTab[i])) then --若是数字使用数字图片

            strRes = tonumber(showNumStrTab[i]);
            --numRes = Point21ScenCtrlPanel.numObjRes.transform:GetChild(tonumber(showNumStrTab[i] ) ); --要显示的图片资源
        else --否则使用文字图片

            --error("===当前数字字符 ：" .. showNumStrTab[i]);
            local findNameStr = "";

            if ("." == showNumStrTab[i]) then
                findNameStr = "p";
            elseif ("w" == showNumStrTab[i]) then
                findNameStr = "w";
            elseif ("y" == showNumStrTab[i]) then
                findNameStr = "yi";
            elseif ("+" == showNumStrTab[i]) then
                findNameStr = "+";
            end
            strRes = findNameStr;
            --numRes = Point21ScenCtrlPanel.numObjRes.transform:Find(findNameStr); --要显示的图片资源
        end

        numRes = numBaseRes.transform:Find(strRes); --要显示的图片资源
        numChildTra.transform:GetComponent('Image').sprite = numRes.transform:GetComponent('Image').sprite;

    end

    for i = #showNumStrTab, (numTra.transform.childCount - 1) do --隐藏没有赋值的图片物体
        numTra.transform:GetChild(i).gameObject:SetActive(false);
    end


end


function Point21PlayerCtrl:SetBustImg(iGroup, tra)


    --    local iPokerCount = #self.pokerInstTab[iGroup] ; --最长牌组数
    --    local vaul = iPokerCount % 2;
    --    if(vaul ~= 0) then iPokerCount = math.floor(iPokerCount / 2) - 1; else iPokerCount =  iPokerCount / 2; end
    local iPokerCount = #self.pokerInstTab[iGroup];

    local moveX = (self.resultIncrementWidthF * (iPokerCount - 1)) / 2; --结算图片x方向需要移动的距离

    tra.transform.localPosition = Vector3.New(-moveX, tra.transform.localPosition.y, tra.transform.localPosition.z);

end


function Point21PlayerCtrl:GetChipPos(iType)

    local traEndPos;
    if (iType >= Point21DataStruct.E_CHIPTYPE_NORMAL_D and iType <= Point21DataStruct.E_CHIPTYPE_NORMAL_S13) then
        traEndPos = self.chipsPosTra.transform:Find("Pos_SPChip"):GetChild(iType - Point21DataStruct.E_CHIPTYPE_NORMAL_D);
    else
        traEndPos = self.chipsPosTra.transform:Find("EndPos");
    end

    return traEndPos;
end

-------------------------玩家声音控制-------------------------
--设置声音
--
function Point21PlayerCtrl:setVolume(soundVolumeF, musicVolumeF)

    if (self.musicSourceTab) then
        self.musicSourceTab = self.transform:GetComponent('AudioSource');
    end

    if (self.voiceSource) then
        self.voiceSource = self.transform:Find("VoiceObject"):GetComponent('AudioSource');
    end

    if (self.warningMusic) then
        self.warningMusic = self.transform:Find("WarningMusic"):GetComponent('AudioSource');
    end

end

--播放声音
--musicType 音乐类型, bySex 性别  __大于0 男  等于0 女  小于0为不分男女 
function Point21PlayerCtrl:playMusic(musicType, bySex)

    local musicName = "";
    if (bySex < 0) then  --不分性别 为音效
        musicName = musicType;
        local musicSourceRes = Point21ScenCtrlPanel.musicRes.transform:Find(musicName):GetComponent('AudioSource');
        if (musicSourceRes) then
            self.musicSourceTab.clip = musicSourceRes.clip;
            MusicManager:PlayX(musicSourceRes.clip);
        end
        --self.musicSourceTab:Play();
    else --声音

        if (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_001) then
            if (1 == bySex) then --男
                musicName = "21-a-001";
            else --女
                musicName = "21-b-001";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_002) then
            if (1 == bySex) then --男
                musicName = "21-a-002";
            else --女
                musicName = "21-b-002";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_003) then
            if (1 == bySex) then --男
                musicName = "21-a-003";
            else --女
                musicName = "21-b-003";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_004) then
            if (1 == bySex) then --男
                musicName = "21-a-004";
            else --女
                musicName = "21-b-004";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_005) then
            if (1 == bySex) then --男
                musicName = "21-a-005";
            else --女
                musicName = "21-b-005";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_006) then
            if (1 == bySex) then --男
                musicName = "21-a-006";
            else --女
                musicName = "21-b-006";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_007) then
            if (1 == bySex) then --男
                musicName = "21-a-007";
            else --女
                musicName = "21-b-007";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_008) then
            if (1 == bySex) then --男
                musicName = "21-a-008";
            else --女
                musicName = "21-b-008";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_009) then
            if (1 == bySex) then --男
                musicName = "21-a-009";
            else --女
                musicName = "21-b-009";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_010) then
            if (1 == bySex) then --男
                musicName = "21-a-010";
            else --女
                musicName = "21-b-010";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_011) then
            if (1 == bySex) then --男
                musicName = "21-a-011";
            else --女
                musicName = "21-b-011";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_012) then
            if (1 == bySex) then --男
                musicName = "21-a-12";
            else --女
                musicName = "21-b-012";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_013) then
            if (1 == bySex) then --男
                musicName = "21-a-013";
            else --女
                musicName = "21-b-013";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_014) then
            if (1 == bySex) then --男
                musicName = "21-a-014";
            else --女
                musicName = "21-b-014";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_015) then
            if (1 == bySex) then --男
                musicName = "21-a-015";
            else --女
                musicName = "21-b-015";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_016) then
            if (1 == bySex) then --男
                musicName = "21-a-016";
            else --女
                musicName = "21-b-016";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_017) then
            if (1 == bySex) then --男
                musicName = "21-a-017";
            else --女
                musicName = "21-b-017";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_018) then
            if (1 == bySex) then --男
                musicName = "21-a-018";
            else --女
                musicName = "21-b-018";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_019) then
            if (1 == bySex) then --男
                musicName = "21-a-019";
            else --女
                musicName = "21-b-019";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_020) then
            if (1 == bySex) then --男
                musicName = "21-a-020";
            else --女
                musicName = "21-b-020";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_021) then
            if (1 == bySex) then --男
                musicName = "21-a-021";
            else --女
                musicName = "21-b-021";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_022) then
            if (1 == bySex) then --男
                musicName = "21-a-022";
            else --女
                musicName = "21-b-022";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_023) then
            if (1 == bySex) then --男
                musicName = "21-a-023";
            else --女
                musicName = "21-b-023";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_024) then
            if (1 == bySex) then --男
                musicName = "21-a-024";
            else --女
                musicName = "21-b-024";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_025) then
            if (1 == bySex) then --男
                musicName = "21-a-025";
            else --女
                musicName = "21-b-025";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_026) then
            if (1 == bySex) then --男
                musicName = "21-a-026";
            else --女
                musicName = "21-b-026";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_027) then
            if (1 == bySex) then --男
                musicName = "21-a-027";
            else --女
                musicName = "21-b-027";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_028) then
            if (1 == bySex) then --男
                musicName = "21-a-028";
            else --女
                musicName = "21-b-028";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_029) then
            if (1 == bySex) then --男
                musicName = "21-a-029";
            else --女
                musicName = "21-b-029";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_030) then
            if (1 == bySex) then --男
                musicName = "21-a-030";
            else --女
                musicName = "21-b-030";
            end
        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_win) then

        elseif (musicType == Point21ResourcesNume.EnumVoiceType.voice_m_lost) then

        end
        local audioSourceRes = Point21ScenCtrlPanel.musicRes.transform:Find(musicName):GetComponent('AudioSource');
        if (audioSourceRes) then
            self.voiceSource.clip = audioSourceRes.clip;
            MusicManager:PlayX(audioSourceRes.clip);
        end
    end --声音音效判断结束


end

-------------------------玩家声音控制 end-------------------------
-------------------------玩家表情控制-------------------------
--播放表情
-- idInt 表情ID
function Point21PlayerCtrl:playExpression(idInt)

    local expressionNameStr = "";

    if (idInt == Point21ResourcesNume.ExpressionType.bishi) then
        expressionNameStr = "bishi";
    elseif (idInt == Point21ResourcesNume.ExpressionType.daku) then
        expressionNameStr = "daku";
    elseif (idInt == Point21ResourcesNume.ExpressionType.daxiao) then
        expressionNameStr = "daxiao";
    elseif (idInt == Point21ResourcesNume.ExpressionType.dianzan) then
        expressionNameStr = "dianzan";
    elseif (idInt == Point21ResourcesNume.ExpressionType.dongxin) then
        expressionNameStr = "dongxin";
    elseif (idInt == Point21ResourcesNume.ExpressionType.gaoxing) then
        expressionNameStr = "gaoxing";
    elseif (idInt == Point21ResourcesNume.ExpressionType.jiayou) then
        expressionNameStr = "jiayou";
    elseif (idInt == Point21ResourcesNume.ExpressionType.jingya) then
        expressionNameStr = "jiangya";
    elseif (idInt == Point21ResourcesNume.ExpressionType.liuhan) then
        expressionNameStr = "liuhan";
    elseif (idInt == Point21ResourcesNume.ExpressionType.paizhuan) then
        expressionNameStr = "paizhuan";
    elseif (idInt == Point21ResourcesNume.ExpressionType.shengqi) then
        expressionNameStr = "shengqi";
    elseif (idInt == Point21ResourcesNume.ExpressionType.touxiang) then
        expressionNameStr = "touxiang";
    elseif (idInt == Point21ResourcesNume.ExpressionType.yinxian) then
        expressionNameStr = "yinxian";
    elseif (idInt == Point21ResourcesNume.ExpressionType.zan) then
        expressionNameStr = "zan";
    elseif (idInt == Point21ResourcesNume.ExpressionType.zibao) then
        expressionNameStr = "zibao";
    elseif (idInt == Point21ResourcesNume.ExpressionType.anwei) then
        expressionNameStr = "anwei";
    end


    if ("" ~= expressionNameStr) then

        if (self.bIsExpression) then --若有播放的动画 先停止
            self:endExpressionAnimat();
        end

        local expressionRes = Point21ScenCtrlPanel.expressionRes.transform:Find(expressionNameStr);

        self.expressionTra = newobject(expressionRes);
        self.expressionTra.transform:SetParent(self.expressionPosTra);
        self.expressionTra.name = expressionNameStr;
        self.expressionTra.transform.localScale = Vector3.one;
        self.expressionTra.transform.localPosition = Vector3.New(0, 0, 0);

        self.animator = self.expressionTra.transform:GetComponent("Animator");

        self.bIsExpression = true; --开始播放表情

    end
    --self.expressionPosTra
end

--表情动画监听
function Point21PlayerCtrl:expressionAnimationListener()

    if (self.bIsExpression and zjPos ~= self.idx) then

        local animatorStateInfo = self.animator:GetCurrentAnimatorStateInfo(0);

        if (animatorStateInfo.normalizedTime >= 3) then
            self:endExpressionAnimat();
        end

    end

end

--停止表情动画播放
function Point21PlayerCtrl:endExpressionAnimat()

    self.animator = nil;
    if (self.expressionTra) then
        destroy(self.expressionTra.gameObject);
    end
    self.expressionTra = nil;
    self.bIsExpression = false;

end

-------------------------玩家表情控制 end-------------------------
function Point21PlayerCtrl.gameQuit()
    titlePosTab = {};
end