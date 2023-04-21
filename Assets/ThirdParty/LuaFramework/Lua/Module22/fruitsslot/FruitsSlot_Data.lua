FruitsSlot_Data = {}
local self = FruitsSlot_Data

self.icon_res = nil
self.numres = nil
self.sound_res = nil

self.openline = { 4, 9, 8, 7 }
self.openimg = {} --图标15
self.opesecondimg = {} --这是前面4列一样，就把开奖的最后一列放这里面，openimg里面的最后一列随机生成数据，当第二次转的时候在把数据，复制回去
self.isopesecondimg = false
self.openwild = {} --开出的wild,只有4个列 因为第1列不算在里面
self.openrate = 0 --倍率
self.byFullScreenType = 0 --全屏类型
self.lineWinScore = 0 --连线赢得的总分
self.allScreenWinScore = 0 --全屏赢得的总分
self.byFreeCnt = 0 --免费次数
self.curFreeCnt = 0 --当前局中的免费次数
self.bBellGame = 0 --是否进入铃铛小游戏
self.bellnum = 0 --铃铛次数

self.isAutoGame = false --是不是自动游戏

self.allshowitem = {}
self.luabe = nil

self.curSelectChoum = 1

self.numrollingcont = {}
self.choumtable = {}

self.isshowmygold = true
self.lastshwogold = 0

self.myinfoData = {}

self.openedBellTable = {} --登录的时候 传入开过哪些铃铛

self.freesound = nil --在进入免费次数音乐保存
self.bellsound = nil -- 铃铛游戏的时候

self.saveaddgoldsound = nil

self.curGameIndex = 0 --当前请求的次数
self.isruning = false --是不是在转动

self.cheatLimitChip = 0 --作弊下注限制
self.hisGoldMoreThan = true --历史金币是否超过限制
self.autoRunNum = 0

-- 0 = 柠檬
-- 1 = 樱桃
-- 2 = 西瓜
-- 3 = bar
-- 4 = 2bar
-- 5 = 3bar
-- 6 = 7
-- 7 = 27
-- 8 = 37
-- 9 = wild
-- 10 = 铃铛
function FruitsSlot_Data.distory(args)
    self.icon_res = nil
    self.numres = nil
    self.sound_res = nil

    self.openline = { 4, 9, 8, 7 }
    self.openimg = {} --图标15
    self.opesecondimg = {} --这是前面4列一样，就把开奖的最后一列放这里面，openimg里面的最后一列随机生成数据，当第二次转的时候在把数据，复制回去
    self.isopesecondimg = false
    self.openwild = {} --开出的wild,只有4个列 因为第1列不算在里面
    self.openrate = 0 --倍率
    self.byFullScreenType = 0 --全屏类型
    self.allScore = 0 --获得的总分
    self.lineWinScore = 0 --连线赢得的总分
    self.allScreenWinScore = 0 --全屏赢得的总分
    self.byFreeCnt = 0 --免费次数
    self.curFreeCnt = 0 --当前局中的免费次数
    self.bBellGame = 0 --是否进入铃铛小游戏
    self.bellnum = 0 --铃铛次数

    self.isAutoGame = false --是不是自动游戏

    self.allshowitem = {}
    self.luabe = nil

    self.curSelectChoum = 1

    self.numrollingcont = {}
    self.choumtable = {}

    self.isshowmygold = true
    self.lastshwogold = 0
    if not IsNil(self.saveaddgoldsound) then
        destroyObj(self.saveaddgoldsound)
    end
    self.saveaddgoldsound = nil
    self.openedBellTable = {} --登录的时候 传入开过哪些铃铛
    self.curGameIndex = 0 --当前请求的次数
    self.isruning = false --是不是在转动

    self.cheatLimitChip = 0 --作弊下注限制
    self.hisGoldMoreThan = true --历史金币是否超过限制
end

--游戏的结算
function FruitsSlot_Data.gameOver(buff)
    self.openimg = {}
    self.openline = {}
    self.opesecondimg = {}
    self.openwild = {}
    self.isopesecondimg = false
    self.curGameIndex = self.curGameIndex + 1 --当前请求的次数
    local img = nil
    for i = 1, FruitsSlot_CMD.D_ALL_COUNT do
        img = buff:ReadInt32()
        --error("_________openimg______"..img);
        table.insert(self.openimg, i, img)
    end
    logErrorTable(self.openimg)
    logError("==============================游戏图标")
    local line = 255
    local count = 0
    local fv = 0
    --error("____read_____line__________");
    for a = 1, FruitsSlot_CMD.D_LINE_COUNT do
        line = a
        count = 0
        local linecont = {}
        for b = 1, 5 do
            fv = buff:ReadByte()
            count = count + fv
            table.insert(linecont, b, fv)
        end
        if count ~= 0 then
            --error("_________line__________"..line);
            table.insert(self.openline, #self.openline + 1, { line = line, data = linecont })
        end
    end
    error("连线")
    logErrorTable(self.openline)
    --error("____end_____line__________");
    self.openrate = buff:ReadInt32() --倍率
    self.byFullScreenType = buff:ReadByte() --全屏类型
    self.allScore = self.readMy64(buff) --连线赢得的总分
    self.byFreeCnt = buff:ReadByte() --总共的免费次数

    if self.byFullScreenType == 0 then
        self.lineWinScore = self.allScore
        self.allScreenWinScore = 0
    else
        if self.openimg[1] == 0 or self.openimg[1] == 1 or self.openimg[1] == 2 then
            self.lineWinScore = (self.allScore / self.openrate) * (self.openrate - 40)
            self.allScreenWinScore = self.allScore - self.lineWinScore
        elseif self.openimg[1] == 3 or self.openimg[1] == 4 or self.openimg[1] == 5 then
            self.lineWinScore = (self.allScore / self.openrate) * (self.openrate - 300)
            self.allScreenWinScore = self.allScore - self.lineWinScore
        elseif self.openimg[1] == 6 or self.openimg[1] == 7 or self.openimg[1] == 8 then
            self.lineWinScore = (self.allScore / self.openrate) * (self.openrate - 700)
            self.allScreenWinScore = self.allScore - self.lineWinScore
        end
    end
    logError("==========================	免费游戏总次数：" .. self.byFreeCnt)
    self.bBellGame = tonumber(buff:ReadByte()) --是否进入铃铛小游戏
    error(self.bBellGame)
    if self.bBellGame > 0 then
        self.bellnum = 5 --铃铛次数
        self.bBellGame = 1
    else
        self.bellnum = 0 --铃铛次数
    end
    logError("==========================	铃铛游戏总次数：" .. self.bBellGame)
    --error("____end_____line__________"..self.byFreeCnt);
    --error("_________game_ove______"..img);
    self.openwild = {} --开出的wild,只有4个列 因为第1列不算在里面
    for c = 1, 4 do
        table.insert(self.openwild, c, buff:ReadByte())
    end
    logErrorTable(self.openwild)
    logError("开出的wild,只有4个列 因为第1列不算在里面")
    --  self.allScreenWinScore = self.readMy64(buff);--全屏赢得的总分
    self.curFreeCnt = self.byFreeCnt --当前局中的免费次数
    self.creatOpen()
    self.isshowmygold = false
    FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_start_btn_inter, false)
    FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_over, nil)
    FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_start, nil)
    if FruitsSlot_Data.byFreeCnt == 0 then
        FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_start, false, false)
    end
    if FruitsSlot_Data.byFreeCnt == 15 and FruitsSlot_Data.curFreeCnt == 15 then
        FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_start, false, false)
    end

    self.cheatLimitChip = buff:ReadInt32() --作弊下注限制
    self.hisGoldMoreThan = buff:ReadByte() == 1 --历史金币是否超过限制
end
function FruitsSlot_Data.readMy64(buff)
    local fagelineWinScore = toInt64(buff:ReadInt64Str())
    if fagelineWinScore < toInt64(math.pow(2, 31)) then
        return int64.tonum2(tostring(fagelineWinScore))
    else
        return fagelineWinScore
    end
end

--是不是下注被限制
function FruitsSlot_Data.isGoldMoreThan()
    --[[if self.hisGoldMoreThan==false then
       if self.curSelectChoum*FruitsSlot_CMD.D_LINE_COUNT>=self.cheatLimitChip then
         Network.OnException("下注失败，超出个人下注上限");
         return true;
       end
    end--]]
    return false
end

--是不是特殊模式（小游戏，免费）
function FruitsSlot_Data.getIsStop()
    if self.bBellGame > 0 or self.byFreeCnt > 0 then
        return false
    end
    return true
end

-- 当签名4列一样的时候，后面一列要有概率转第二次，第一次的数据是客户模拟的假数据
function FruitsSlot_Data.creatOpen()
    local firstvalue = self.openimg[1]
    for a = 1, 4 do
        for i = 1, 3 do
            if self.openimg[a + (3 - i) * 5] ~= firstvalue then
                return
            end
        end
    end
    local rand = math.random(0, 100)
    if rand > 50 then
        return
    end
    --error("____111___creatOpen__");
    local len = #FruitsSlot_Config.randSecondimg_1
    local randtabel = {}
    local randindex = 0
    for b = 1, len do
        if FruitsSlot_Config.randSecondimg_1[b] ~= firstvalue then
            randtabel[1] = FruitsSlot_Config.randSecondimg_1[b]
            break
        end
    end
    len = #FruitsSlot_Config.randSecondimg_2
    local randnum = 0
    for c = 1, len do
        if FruitsSlot_Config.randSecondimg_2[c] ~= firstvalue then
            table.insert(randtabel, #randtabel + 1, FruitsSlot_Config.randSecondimg_2[c])
            break
        end
    end
    --error("____222___creatOpen__");
    len = #randtabel
    for d = 1, 3 do
        self.opesecondimg[5 + (3 - d) * 5] = self.openimg[5 + (3 - d) * 5]
        self.openimg[5 + (3 - d) * 5] = randtabel[math.random(1, len)]
    end
    --error("____33___creatOpen__");
    self.isopesecondimg = true
end

--把二次的值给第一次
function FruitsSlot_Data.openSecondReFires()
    --error("___openSecondReFires_____");
    for d = 1, 3 do
        self.openimg[5 + (3 - d) * 5] = self.opesecondimg[5 + (3 - d) * 5]
    end
    --error("___1111______openSecondReFires________");
    self.isopesecondimg = false
end

function FruitsSlot_Data.bellValueChang(buff)
    local data = {}
    --error("_____bellValueChang____");
    data.money = self.readMy64(buff)
    -- error("__11___bellValueChang____"..data.money);
    data.index = buff:ReadByte()
    --error("__22___bellValueChang____"..data.index);
    data.bellnum = buff:ReadByte()
    error("铃铛")
    logErrorTable(data)
    FruitsSlot_Data.bellnum = math.max(0, FruitsSlot_Data.bellnum - 1) --铃铛次数
    FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_bell_value, data)
end
function FruitsSlot_Data.GetPEILV(buff)
    local curSelectChoum = buff:ReadInt32(); --断线前下注筹码
    local nBetonCnt = buff:ReadInt32();--下注配置数组个数
    self.choumtable = {}
    for i = 1, nBetonCnt do
        table.insert(self.choumtable, i, buff:ReadInt32())
    end
    logTable(self.choumtable);
    FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_init, nil)
end
function FruitsSlot_Data.gameSence(buff)
    --error("____gameSence_____");
    self.choumtable = {}
    self.openedBellTable = {} --登录的时候 传入开过哪些铃铛
    self.curSelectChoum = buff:ReadInt32()

    logError("断线前下注筹码" .. self.curSelectChoum)

    --self.curSelectChoum = 10;
    --error("____gameSence_____"..self.curSelectChoum);
    for i = 1, 5 do
        table.insert(self.choumtable, i, buff:ReadInt32())
    end
    logErrorTable(self.choumtable)
    logError("============筹码")

    self.byFreeCnt = buff:ReadByte() --免费次数
    logError("===============免费次数 ：" .. self.byFreeCnt)
    self.bellnum = buff:ReadByte() --铃铛次数
    logError("===============剩余铃铛次数 ：" .. self.bellnum)
    local fval = 0
    local isopen = 0
    local fvalnum = 0
    for a = 1, 5 do
        isopen = buff:ReadByte()
        fval = self.readMy64(buff)
        if isopen > 0 then
            fvalnum = fvalnum + fval
        end
        --error("__11___fvalnum_____"..isopen);
        table.insert(self.openedBellTable, a, { openpos = isopen, val = fval })
    end
    logErrorTable(self.openedBellTable);
    --error("__bellnumbellnumbellnum_____"..self.bellnum);
    --error("__byFreeCntbyFreeCntbyFreeCnt_____"..self.byFreeCnt);
    if self.bellnum > 0 then
        FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_bell_start, fvalnum)
    elseif self.byFreeCnt > 0 then
        FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_show_free)
        FruitsSlot_Socket.gameOneOver(false)
    end
    FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_init, nil)
    self.cheatLimitChip = buff:ReadInt32() --作弊下注限制
    self.hisGoldMoreThan = buff:ReadByte() == 1 --历史金币是否超过限制
end

--开过了哪些铃铛
function FruitsSlot_Data.getOpenBell(findex)
    local len = #self.openedBellTable
    local item = nil
    for i = 1, len do
        item = self.openedBellTable[i]
        if item.openpos == findex then
            return item
        end
    end

    return nil
end

--自己的信息改变
function FruitsSlot_Data.myinfoChang()
    self.myinfoData = {}
    self.myinfoData._1dwUser_Id = TableUserInfo._1dwUser_Id
    self.myinfoData._2szNickName = TableUserInfo._2szNickName
    self.myinfoData._3bySex = TableUserInfo._3bySex
    self.myinfoData._4bCustomHeader = TableUserInfo._4bCustomHeader
    self.myinfoData._5szHeaderExtensionName = TableUserInfo._5szHeaderExtensionName
    self.myinfoData._6szSign = TableUserInfo._6szSign
    self.myinfoData._7wGold = TableUserInfo._7wGold
    self.myinfoData._8wPrize = TableUserInfo._8wPrize
    self.myinfoData._9wChairID = TableUserInfo._9wChairID
    self.myinfoData._10wTableID = TableUserInfo._10wTableID
    self.myinfoData._11byUserStatus = TableUserInfo._11byUserStatus
    logError("300-0====" .. self.myinfoData._7wGold)
    --error("______myinfoChang_______");
    FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_gold_chang, nil)
end