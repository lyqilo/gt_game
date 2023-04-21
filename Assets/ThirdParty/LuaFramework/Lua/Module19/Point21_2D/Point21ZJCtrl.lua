--Point21ZJCtrl.lua
--Date
-- 21点庄家控制类
--endregion
--默认的定义
--require "Module19/Point21_2D/Point21ScenCtrlPanel" --场景控制
Point21ZJCtrl = {}

local self = Point21ZJCtrl

local sendPokerTime = 0.2 --每个玩家的发牌时间间隔

local transform

local gameobject

local sendPokerPosTra  --发牌位置

local backPokersPosTra  --手牌位置

local playerInst  --庄家自己玩家控制类

local snedPokerDataTab = {} --存储要发的牌 key值为对应的玩家座位号

local bSendPokerTimer = false --是否启用发牌计时

local bBjRepayChipTimer = false --是否启用黑杰克返还保险倒计时

local bjRepayChipEndTimeF = 2 --黑杰克时庄家返还玩家保险时间

local playerWinInstTab = {} -- 赢了的玩家实例
local playerLostChipInstTab = {} --玩家输的筹码实例

local bGameEnd = false

--初始化公共变量
function Point21ZJCtrl.initPublicData()
    self.bIsResult = false

    self.bLostEnd = false --输操作是否结束

    self.bWinEnd = false -- 赢操作是否结束

    self.bPlayerBeginChipMove = false --玩家筹码是否开始运动(用于庄家输筹码时 筹码先飞向玩家 一段时间后 和玩家筹码一起飞向玩家)

    self.bPlayerLostMotionEndTab = { --玩家输了操作是否结束
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = true,
        [5] = true
    }

    self.bPlayerWinMotionEndTab = { --玩家输了操作是否结束
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = true,
        [5] = true
    }
end

--初始化庄家控制类
--zjTra 庄家物体    inst 庄家自己的玩家实例
function Point21ZJCtrl.initZJCtrl(zjTra, inst)
    self.initPublicData()

    transform = zjTra.transform
    gameobject = zjTra

    playerInst = inst

    sendPokerPosTra = transform:Find("SendPokersPos")

    backPokersPosTra = transform:Find("BackPokersPos")

    self.chipsPos = transform:Find("ChipsPos") --筹码位置
end

function Point21ZJCtrl.Update()
    self.sendPokerTimer()
    self.zjIsBJTimer()
    self.gameEndListenEvent()
    self.countDownTimer()
    self.zjLostChipTimer()
end

local tempTimeF = 0

local unitTimeF = 0 --单位累加时间
local bIsCountDown = false --是否启用倒计时
local countDownTiemF = 0 --倒计时 时间

--设置到计时播放
function Point21ZJCtrl.setCountDownTimer(bCD, timeF)
    if (bCD) then
        bIsCountDown = bCD
        countDownTiemF = timeF
    else
        bIsCountDown = false
        countDownTiemF = 0
        tempTimeF = 0
        unitTimeF = 0
    end
end

--倒计时音效播放
function Point21ZJCtrl.countDownTimer()
    if (bIsCountDown) then
        tempTimeF = tempTimeF + Time.deltaTime

        if (tempTimeF <= countDownTiemF) then
            unitTimeF = unitTimeF + Time.deltaTime

            if (unitTimeF >= 1) then
                Point21ScenCtrlPanel.surplusTimer = countDownTiemF - tempTimeF
                if (countDownTiemF - tempTimeF <= 4) then --播放警告倒计时
                    --playerInst.warningMusic:Play();
                    MusicManager:PlayX(playerInst.warningMusic.clip)
                end
                --MusicManager:PlayX(playerInst.warningMusic.clip);
                unitTimeF = unitTimeF - 1
            end
        else
            self.setCountDownTimer(false)
        end
    end
end

-- 庄家发牌定时器
function Point21ZJCtrl.sendPokerTimer()
    if (bSendPokerTimer) then
        tempTimeF = tempTimeF + Time.deltaTime
        if (tempTimeF >= sendPokerTime) then
            tempTimeF = 0
            self.sendPoker()
        end
    end
end

local bPlayBJAnimation = false --是否播放zj黑杰克动画
local bjAnimationTimeF = 1.5 --动画时间
local bjAnimationUnitTimeF = 0.5 --动画频率
local bjTwoPokerInst  --黑杰克第2张牌实例
local pokerScaleVe3 = Vector3.New(1.1, 1.1, 1) --扑克缩放比例
local bIsBlackJack = false --是否黑杰克
local twoPokerByte  --第2张牌数据


--开始播放黑杰克动画
--bPlay 是否播放, bBj 是否黑杰克, byte 扑克数据
function Point21ZJCtrl.playBjAnimation(bPlay, bBj, byte)
    bIsBlackJack = bBj or false;
    if (byte) then
        twoPokerByte = byte
    end
    if (not bjTwoPoker) then
        bjTwoPokerInst = playerInst.pokerInstTab[1][2]
    end
    local tweener = bjTwoPokerInst.transform:DOScale(Vector3.New(1.1, 1.1, 1), 0.5)
    tweener:SetEase(DG.Tweening.Ease.Linear):SetLoops(3)
    tweener:OnComplete(
    function()
        bjTwoPokerInst.transform:DOScale(Vector3.New(1, 1, 1), 0.3)
        if (bPlay) then
            self.zjBackJack(bIsBlackJack, twoPokerByte)
        elseif (bIsBlackJack > 0) then
            self.zjBackJackForNoInsurance(twoPokerByte)
        end
    end
    )
end

--庄家黑杰克计时 主要用于黑杰克时先返回玩家保险等待一段时间后 再收走玩家的筹码
function Point21ZJCtrl.zjIsBJTimer()
    if bBjRepayChipTimer then
        tempTimeF = tempTimeF + Time.deltaTime
        if (tempTimeF >= bjRepayChipEndTimeF) then
            tempTimeF = 0
            Point21ZJCtrl.zjTackBackChip()
            bBjRepayChipTimer = false
        end
    end
end
local bzjLostChipTimer = false --是否开始庄家输的筹码运动倒计时
local lostChipTime = 1 --输筹码倒计时 时间
--庄家输筹码计时 计时结束后 和玩家桌上的筹码 一起飞向玩家
function Point21ZJCtrl.zjLostChipTimer()
    if (bzjLostChipTimer) then
        tempTimeF = tempTimeF + Time.deltaTime
        if (tempTimeF >= lostChipTime) then
            self.bPlayerBeginChipMove = true
            tempTimeF = 0
            bzjLostChipTimer = false
        end
    end
end
--zj第一次发牌 获取每个玩家的扑克数据
function Point21ZJCtrl.getFirstPokers(allPokerTab, tabChiapType, tabWin)
    for i = 1, #allPokerTab do
        if (allPokerTab[i].byPokerData1 ~= 0) then --此组有玩家
            local tempTab = {}
            tempTab[i] = allPokerTab[i]
            if (zjPos == i) then --zj第2张牌 为背面牌
                tempTab[i].byPokerData2 = 255
            end
            table.insert(snedPokerDataTab, tempTab)
        end
    end
    self.sendPoker()
    bSendPokerTimer = true
    self.tabChiapType = tabChiapType
    self.tabWin = tabWin
end

--zj发牌
function Point21ZJCtrl.sendPoker()
    for i = 1, #snedPokerDataTab do
        for key, var in pairs(snedPokerDataTab[i]) do
            self.createPokers(key, var)
            table.remove(snedPokerDataTab, i)
            return
        end
    end

    snedPokerDataTab = {}
    bSendPokerTimer = false
    tempTimeF = 0
    Point21ScenCtrlPanel.bBeginThrwoChip = false
    coroutine.start(self.SetSpGame)
end

function Point21ZJCtrl.SaveInspectPokerData(tabData)
    logYellow("保存第二张牌：tabData.bZJBlackJack" .. tabData.bZJBlackJack .. "  " .. tabData.byPokerData)
    self.bBj = tabData.bZJBlackJack
    if (self.bBj > 0) then
        logYellow("======================黑杰克===================")
        Point21ScenCtrlPanel.showOperation(false)
        --Point21ZJCtrl.playBjAnimation(false, self.bBj, self.pokerData)
    end
end

--庄家差牌
function Point21ZJCtrl.InspectPoker()
    local zjOnePokerInst = playerInst.pokerInstTab[1][1]
    local onePointInt = Point21ResourcesNume.getPokerNum(zjOnePokerInst.byPokerDataByte); --bit:_and(zjOnePokerInst.byPokerDataByte, 15) --新拿到的扑克数据 低四位为点数， 15 = 00001111
    log("庄家差牌，设置庄家牌点数：" .. zjOnePokerInst.byPokerDataByte .. "  当前点数：" .. onePointInt)
    if (onePointInt >= 10) then
        Point21ZJCtrl.playBjAnimation(false, self.bBj, self.pokerData)
    end
end

--创建扑克
function Point21ZJCtrl.createPokers(idx, pokerDataTab)
    playerInst:playMusic(Point21ResourcesNume.EnumSoundType.sound_dealpoker, -1)

    local countInt = 0 --扑克数据

    if 0 ~= pokerDataTab.byPokerData2 then
        countInt = 2
    else
        countInt = 1
    end
    for i = 1, countInt do
        local point21PokerCtrl = Point21PokerCtrl:New()

        local data = 0

        if (1 == countInt) then
            point21PokerCtrl.Create(idx, point21PokerCtrl, sendPokerPosTra, pokerDataTab.byPokerData1, 1)
        else
            if (1 == i) then
                point21PokerCtrl.Create(idx, point21PokerCtrl, sendPokerPosTra, pokerDataTab.byPokerData1, 1)
            else
                point21PokerCtrl.Create(idx, point21PokerCtrl, sendPokerPosTra, pokerDataTab.byPokerData2, 2)
            end
        end
    end
end

--设置特殊游戏
function Point21ZJCtrl.SetSpGame(tabChiapType, tabWin)
    coroutine.wait(1)

    if (g_bGameQuit) then
        return
    end

    local tabChiapType = self.tabChiapType
    local tabWin = self.tabWin

    self.tabLostSpChips = {}
    self.tabWinSpChips = {}
    for i = 1, Point21DataStruct.CMD_BlackJack.GAME_PLAYER do
        for j = 1, 3 do
            if (tabChiapType[i][j] > 0) then
                local tabtemp = {}
                if (j + Point21DataStruct.E_CHIPTYPE_NORMAL == Point21DataStruct.E_CHIPTYPE_NORMAL_D) then
                    tabtemp = point21PlayerTab[i].tabSpDChipInst
                elseif (j + Point21DataStruct.E_CHIPTYPE_NORMAL == Point21DataStruct.E_CHIPTYPE_NORMAL_A13) then
                    tabtemp = point21PlayerTab[i].tabSpA13ChipInst
                elseif (j + Point21DataStruct.E_CHIPTYPE_NORMAL == Point21DataStruct.E_CHIPTYPE_NORMAL_S13) then
                    tabtemp = point21PlayerTab[i].tabSpS13ChipInst
                end
                if (tabWin[i][j] > 0) then
                    for idx = 1, #tabtemp do
                        table.insert(self.tabWinSpChips, tabtemp[idx])
                    end
                else
                    for idx = 1, #tabtemp do
                        table.insert(self.tabLostSpChips, tabtemp[idx])
                    end
                end
            end
        end
        point21PlayerTab[i]:SetSpChipNumber(-1) --隐藏下注点数
    end

    if (#self.tabWinSpChips > 0) then
        for i = 1, Point21DataStruct.CMD_BlackJack.GAME_PLAYER do
            local iWinNum = 0
            for j = 1, 3 do
                if (self.tabWin[i][j] > 0) then
                    iWinNum = iWinNum + self.tabWin[i][j]
                end
            end
            if (iWinNum > 0) then
                point21PlayerTab[i]:ShowSpCGameResult(true, iWinNum)
            end
        end
    end
    self.chipsPos = transform:Find("ChipsPos") --筹码位置
    if self.chipsPos ~= nil then
        if (#self.tabLostSpChips > 0) then
            Point21ZJCtrl.ZjGetSpChip()
        elseif (#self.tabWinSpChips > 0) then
            Point21ZJCtrl.ZjLostSpChip()
        else
            --Point21ZJCtrl.InspectPoker()
        end
    end
end

--庄家收取特殊下注筹码
function Point21ZJCtrl.ZjGetSpChip()
    local funCallBack = nil
    for i = 1, #self.tabLostSpChips do
        if (#self.tabLostSpChips == i) then
            funCallBack = function()
                Point21ZJCtrl.ZjLostSpChip()
            end
        end
        self.tabLostSpChips[i]:moveToPos(self.chipsPos, true, fSpChipSpeed, funCallBack)
    end
end

--庄家输掉特殊筹码
function Point21ZJCtrl.ZjLostSpChip()
    for i = 1, Point21DataStruct.CMD_BlackJack.GAME_PLAYER do
        if (#self.tabWinSpChips > 0) then
            for j = 1, 3 do
                if (self.tabWin[i][j] > 0) then
                    point21PlayerTab[zjPos]:throwChips(
                    j + Point21DataStruct.E_CHIPTYPE_NORMAL,
                    self.tabWin[i][j],
                    false,
                    i
                    )
                end
            end
        end
    end
    Point21ZJCtrl.InspectPoker()
end

--庄家黑杰克
--bBj 是否黑杰克  twoPokerDataByte第2张牌数据
function Point21ZJCtrl.zjBackJack(bBj, twoPokerDataByte)
    self.bPlayerBeginChipMove = false --玩家筹码是否开始运动
    if (bBj) then
        self.lookZjTwoPoker(twoPokerDataByte)
        for i = 1, (#point21PlayerTab) - 1 do --若zj黑杰克 则先给购买保险的玩家返回保险，结束后再收取玩家筹码
            local tempTab = point21PlayerTab[i]:getPlayreChips(1)

            if (tempTab) then --下注的筹码加入输掉的表
                if (not point21PlayerTab[i].bIsBlackJack) then
                    for j = 1, #tempTab do
                        table.insert(playerLostChipInstTab, tempTab[j])
                    end
                end
            end

            if (point21PlayerTab[i].insuranceChipValInt > 0) then --给玩家返还保险
                playerInst:zjChipsCtrl(
                point21PlayerTab[i].insuranceChipValInt,
                point21PlayerTab[i].chipsPosTra.transform:Find("EndPos"),
                false
                )
                bzjLostChipTimer = true
                lostChipTime = 1.5
            elseif (point21PlayerTab[i].bIsBlackJack) then --没有保险筹码 但是玩家黑杰克 则收走自己下的注
                log("point21PlayerTab[i]:playerWinChips(0)")
                point21PlayerTab[i]:playerWinChips(0)
            end

            bBjRepayChipTimer = true
        end
    else
        for i = 1, (#point21PlayerTab) - 1 do --收走保险筹码
            if (point21PlayerTab[i].insuranceChipValInt > 0) then
                for j = 1, #point21PlayerTab[i].InsuranceChipInstTab do
                    point21PlayerTab[i].InsuranceChipInstTab[j]:moveToPos(self.chipsPos, true)
                end
            end
        end
    end
end

--没有保险的庄家黑杰克
function Point21ZJCtrl.zjBackJackForNoInsurance(twoPokerDataByte)
    log("Point21ZJCtrl.zjBackJackForNoInsurance")
    self.lookZjTwoPoker(twoPokerDataByte)
    for i = 1, (#point21PlayerTab) - 1 do --若zj黑杰克 则先给购买保险的玩家返回保险，结束后再收取玩家筹码
        if (point21PlayerTab[i].bIsBlackJack) then --玩家黑杰克 则收走自己下的注
            point21PlayerTab[i]:playerWinChips(0) --收走桌上自己的筹码;
        else
            point21PlayerTab[i]:playerLostChips(1)
        end
    end
end

--庄家收筹码
function Point21ZJCtrl.zjTackBackChip()
    if (playerLostChipInstTab) then
        for i = 1, #playerLostChipInstTab do
            playerLostChipInstTab[i]:moveToPos(self.chipsPos, true)

            --table.remove( playerLostChipInstTab, i);
        end
    end

    --coroutine.start( self.waitResetGameInfo);
end

--查看庄家第2张牌
function Point21ZJCtrl.lookZjTwoPoker(pokerDataByt)
    local pokerInst = playerInst.pokerInstTab[1][2]

    pokerInst.byPokerDataByte = pokerDataByt

    pokerInst.bRotate = true
end

--庄家爆牌
function Point21ZJCtrl.zjBurstPoker()
    for i = 1, (#point21PlayerTab) - 1 do --不考虑庄家
        local pInst = point21PlayerTab[i] --玩家实例

        if (pInst.allChipValIntTab) then
            local zjLostChipInt = 0 --记录庄家输掉的筹码

            for j = 1, #pInst.allChipValIntTab do
                if (pInst.allChipValIntTab[j] > 0) then --玩家此组有筹码
                    zjLostChipInt = zjLostChipInt + pInst.allChipValIntTab[j]
                end
            end

            if (zjLostChipInt > 0) then
                playerInst:zjChipsCtrl(zjLostChipInt, pInst.chipsPosTra.transform:Find("EndPos"), false, i)
            end
        end
    end
end

--庄家输掉筹码的事件 在筹码运动到玩家筹码区触发
function Point21ZJCtrl.zjLostChipsEvent(chipInst)
    log("Point21ZJCtrl.zjLostChipsEvent")
    if (chipInst.bEndChip) then
        if (point21PlayerTab[chipInst.toPlayerIdx].allChipValIntTab) then
            for i = 1, #point21PlayerTab[chipInst.toPlayerIdx].allChipValIntTab do
                if (point21PlayerTab[chipInst.toPlayerIdx].allChipValIntTab[i] > 0) then
                    point21PlayerTab[chipInst.toPlayerIdx]:playerWinChips(i)
                end
            end
        end
    end
end

--游戏正常结束
function Point21ZJCtrl.gameNormalOver(gameEndDataTab)
    local bHaveResuitPlayer = false -- 是否有参与结算的玩家
    for id = 1, #point21PlayerTab - 1 do
        local thisInst = point21PlayerTab[id]
        local winTypes = 0
        if (thisInst.allChipNumInt > 0) then --在游戏中的玩家
            local winGoldInt = 0 --赢得金币数
            for groupIdx = 1, #thisInst.allChipValIntTab do
                if (thisInst.allChipValIntTab[groupIdx] > 0) then --此组有筹码
                    bHaveResuitPlayer = true
                    local frontPlayerCount = id - 1 --前面已经处理过得玩家个数
                    local frontResultCount = frontPlayerCount * Point21DataStruct.CMD_BlackJack.C_SPLIT_POKER_COUNT --前面已经处理过得结算信息个数
                    local currentResuitIdx = frontResultCount + groupIdx --当前要处理的结算信息下标

                    local tempResultTab = gameEndDataTab.gameResult[currentResuitIdx] --当前结算数据表
                    if (tempResultTab.bPlayerWin == Point21DataStruct.CMD_BlackJack.enPlayerWin.E_PLAYER_WIN_LOST) then --输
                        winTypes = 2
                        -- winGoldInt = winGoldInt - thisInst.allChipValIntTab[groupIdx];
                        if (not self.bLostEnd) then
                            self.bLostEnd = true
                        end

                        if (self.bPlayerLostMotionEndTab[id]) then --添加标志 表示庄家还在收筹码中
                            self.bPlayerLostMotionEndTab[id] = false
                        end

                        thisInst:playerLostChips(groupIdx)
                    elseif
                    (tempResultTab.bPlayerWin == Point21DataStruct.CMD_BlackJack.enPlayerWin.E_PLAYER_WIN_WIN or
                    tempResultTab.bPlayerWin == Point21DataStruct.CMD_BlackJack.enPlayerWin.E_PLAYER_WIN_EVEN)
                    then --赢和平
                        if (not self.bWinEnd) then
                            self.bWinEnd = true
                        end

                        if (self.bPlayerWinMotionEndTab[id]) then --添加标志 表示玩家还在收筹码中
                            self.bPlayerWinMotionEndTab[id] = false
                        end

                        local winDataTab = { --存储玩家赢和平的信息，只要有赢 获取筹码按赢处理
                            _id = id,
                            _pInst = thisInst,
                            _bWin = false
                        }

                        if (tempResultTab.bPlayerWin == Point21DataStruct.CMD_BlackJack.enPlayerWin.E_PLAYER_WIN_WIN) then --赢
                            winGoldInt = winGoldInt + tempResultTab.iWinGameGold
                            winDataTab._bWin = true
                            winTypes = 0
                        else --平
                            winTypes = 1
                        end
                        if (#playerWinInstTab > 0) then
                            for i = 1, #playerWinInstTab do
                                if (playerWinInstTab[i]._id == id) then --若有此玩家
                                    if (not playerWinInstTab[i]._bWin) then --若没有赢 则重新赋值
                                        playerWinInstTab[i] = winDataTab
                                    end

                                    break
                                else --没有就新添加
                                    table.insert(playerWinInstTab, winDataTab)
                                end
                            end
                        else --第一次添加
                            table.insert(playerWinInstTab, winDataTab)
                        end
                    else --未知
                    end
                else

                end --此组有筹码判断结束

            end --下注值循环结束
            thisInst:showResultInfo(winGoldInt, winTypes) -- 显示结算信息
        end
    end

    if (not bHaveResuitPlayer) then --没输也没赢的情况 比如 投降 爆牌
        coroutine.start(self.waitResetGameInfo)
        return
    elseif (not self.bLostEnd) then --没输但是有赢的情况
        self.lostMotionEnd()
    end

    bGameEnd = true
end

--游戏结束监听
function Point21ZJCtrl.gameEndListenEvent()
    if (bGameEnd) then
        if (self.bLostEnd) then
            for i = 1, #self.bPlayerLostMotionEndTab do
                if (not self.bPlayerLostMotionEndTab[i]) then
                    return
                end
            end

            self.bLostEnd = false

            if (self.bWinEnd) then
                --self.lostMotionEnd();
                coroutine.start(self.waitPlyaerWinChips)
            else
                bGameEnd = false
                coroutine.start(self.waitResetGameInfo)
            end
        end

        if (self.bWinEnd) then
            for i = 1, #self.bPlayerWinMotionEndTab do
                if (not self.bPlayerWinMotionEndTab[i]) then
                    return
                end
            end

            bGameEnd = false
            self.bWinEnd = false
            coroutine.start(self.waitResetGameInfo)
        end
    end
end

--玩家输筹码动作完成后 触发
function Point21ZJCtrl.lostMotionEnd()
    self.bPlayerBeginChipMove = false --玩家筹码是否开始运动
    for i = 1, #playerWinInstTab do
        if (playerWinInstTab[i]._bWin) then --赢
            playerInst:zjChipsCtrl(playerWinInstTab[i]._pInst.allChipNumInt, playerWinInstTab[i]._pInst.chipsPosTra.transform:Find("EndPos"), false, playerWinInstTab[i]._id)
            bzjLostChipTimer = true
            lostChipTime = 1
        else --平
            if (playerWinInstTab[i]._pInst.allChipValIntTab) then
                for j = 1, #playerWinInstTab[i]._pInst.allChipValIntTab do
                    if (playerWinInstTab[i]._pInst.allChipValIntTab[j] > 0) then
                        playerWinInstTab[i]._pInst:playerWinChips(j)
                    end
                end
            end
        end
    end
end

--庄家回收扑克
function Point21ZJCtrl.zjTackBackPoker()
    --Point21ScenCtrlPanel.mySleep(10); --延迟2秒 收牌
    for id = 1, #point21PlayerTab do
        local thisInst = point21PlayerTab[id]

        if (thisInst.pokerPointsTraTab) then
            -- if (#thisInst.pokerPointsTraTab >= 1) then --隐藏21点标志
            --     -- thisInst.pokerPointsTraTab[1]:GetComponent("Image").enabled = false
            --     destroy(thisInst.pokerPointsTraTab[1]);
            --     thisInst.pokerPointsTraTab = {};
            -- end
            -- for groupIdx = 1, #thisInst.pokerPointsTraTab do --隐藏点数
            --     -- thisInst.pokerPointsTraTab[groupIdx].gameObject:SetActive(false)
            --     destroy(thisInst.pokerPointsTraTab[groupIdx].gameObject);
            -- end
            local pokers = transform:Find("Pokers");
            for i = 0, pokers.childCount - 1 do
                local count = pokers:GetChild(i).childCount - 1;
                for j = count, 0, -1 do
                    destroy(pokers:GetChild(i):GetChild(j).gameObject);
                end
            end
            thisInst.pokerPointsTraTab = {};
        end

        if (thisInst.pokerInstTab) then
            for i = 0, thisInst.pokerPosTra.childCount - 1 do --取消layout组件
                local pokerGroupTra = thisInst.pokerPosTra.transform:GetChild(i)
                --pokerGroupTra.transform:GetComponent("GridLayoutGroup").enabled = false
                --thisInst.pokerPosTra.transform:GetChild(i).gameObject:SetActive(false);
            end

            for groupIdx = 1, #thisInst.pokerInstTab do                
                for i = 1, #thisInst.pokerInstTab[groupIdx] do
                    local thisPoker = thisInst.pokerInstTab[groupIdx][i]
                    thisPoker:moveToPos(backPokersPosTra, true)
                end
            end
        end
    end
end

--重置游戏信息
function Point21ZJCtrl.resetGameInfo()
    if (g_bGameQuit) then
        return
    end

    if (not self.bIsResult) then
        return
    end

    self.zjTackBackPoker()

    self.initPublicData()

    self.restValue()

    Point21ScenCtrlPanel.bInoperation = false

    for id = 1, 5 do
        if(point21PlayerTab[id]~=nil)then
            point21PlayerTab[id]:resetGameInfo()
        end
    end

    coroutine.start(self.sendGameOver)
end

--初始化变量
function Point21ZJCtrl.restValue()
    bGameEnd = false

    snedPokerDataTab = {}
    playerWinInstTab = {} -- 赢了的玩家实例
    playerLostChipInstTab = {} --玩家输的筹码实例

    bSendPokerTimer = false --是否启用发牌计时
    bBjRepayChipTimer = false --是否启用黑杰克返还保险倒计时

    tempTimeF = 0
    unitTimeF = 0
    bIsCountDown = false --是否启用倒计时
    countDownTiemF = 0 --倒计时 时间

    bzjLostChipTimer = false --是否开始庄家输的筹码运动倒计时

    bPlayBJAnimation = false
    bjAnimationUnitTimeF = 0.5
    bjTwoPokerInst = nil
    self.bBj = 0
    self.pokerData = 255
    bIsBlackJack = false
end

--等待播放玩家赢筹码动画 （在结束时 等庄家收走筹码一段时间后 玩家再收自己赢的筹码）
function Point21ZJCtrl.waitPlyaerWinChips()
    coroutine.wait(0.5)
    self.lostMotionEnd()
end

--等待游戏重置
function Point21ZJCtrl.waitResetGameInfo()
    logYellow("等待游戏重置2秒")
    coroutine.wait(2)
    self.resetGameInfo()
end

--发送游戏结束
function Point21ZJCtrl.sendGameOver()
    coroutine.wait(2)

    local buffer = ByteBuffer.New()

    if (bPoint21GameQuit) then
        return
    end

    Network.Send(MH.MDM_GF_GAME, Point21DataStruct.CMD_BlackJack.SUB_CS_ANIMAL_END, buffer, gameSocketNumber.GameSocket)
end

function Point21ZJCtrl.gameQuit()
    self.restValue()
end