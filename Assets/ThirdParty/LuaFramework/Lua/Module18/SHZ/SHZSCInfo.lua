SHZSCInfo = {}
local self = SHZSCInfo
local IsHomeBack = false
SHZGameMangerTable = {}
self.quitstate = false
self.isreqStart=true
MH_SHZ = {
    D_GAME_STATE_NULL = 0,
    -- 空
    D_GAME_STATE_CHIP = 1,
    -- 下注
    D_GAME_STATE_MARY = 2,
    -- 玛丽
    D_GAME_STATE_TIME_OR_GET_MAIN = 3,
    -- 比倍或者得分——主游戏
    D_GAME_STATE_TIME_OR_GET_MARY = 4,
    -- 比倍或者得分——玛丽
    D_GAME_STATE_TIME_OR_GET_TIME = 5,
    -- 比倍或者得分——比倍
    D_GAME_STATE_BIG_OR_SMA = 6,
    -- 押大小

    D_IMG_SHUI_HU_ZHUAN = 0,
    -- 水浒传
    D_IMG_COUNT = 9,
    -- 图标数

    D_LINE_COUNT = 9,
    -- 线数

    D_ROW_COUNT = 3,
    -- 行数
    D_COL_COUNT = 5,
    -- 列数

    D_MIN_LINE = 3,
    -- 最小线
    D_MAX_LINE = 5,
    -- 最大线

    D_BET_INDEX_COUNT = 10,
    -- 筹码索引数

    D_MARY_TOTAL_COUNT = 24,
    -- 玛丽总数
    D_MARY_PRIZE_COUNT = 4,
    -- 玛丽奖励数

    D_POINT_MAX = 6,
    -- //最大点
    D_POINT_MID = 7,
    -- //中点

    D_TIME_SMA = 1,
    -- //小
    D_TIME_MID = 2,
    -- //中
    D_TIME_BIG = 3,
    -- //大

    D_HIS_COUNT = 10,
    -- //历史数

    C_IMG_LIST = {
        { 5, 6, 7, 8, 9 },
        { 0, 1, 2, 3, 4 },
        { 10, 11, 12, 13, 14 },
        { 0, 6, 12, 8, 4 },
        { 10, 6, 2, 8, 14 },
        { 0, 1, 7, 3, 4 },
        { 10, 11, 7, 13, 14 },
        { 5, 11, 12, 13, 9 },
        { 5, 1, 2, 3, 9 }
    },
    C_MARY_IMG = {
        "D_IMG_EXIT",
        5,
        7,
        1,
        8,
        6,
        "D_IMG_EXIT",
        3,
        5,
        7,
        8,
        2,
        "D_IMG_EXIT",
        4,
        6,
        8,
        5,
        3,
        "D_IMG_EXIT",
        4,
        7,
        8,
        6,
        2
    },
    C_IMG_TEXT = { "水浒传", "忠义堂", "替天行道", "宋江", "林冲", "鲁智深", "大刀", "双枪", "斧子", "退出" },
    C_BIG_OR_SMA_TEXT = { "空", "小", "和", "大" },
    SUB_SC_MAIN_RESULT = 0,
    -- //主游戏结果
    SUB_SC_MARY_RESULT = 1,
    -- //玛丽结果
    SUB_SC_BIG_OR_SMA = 2,
    -- //押大小
    SUB_SC_BIG_OR_SMA_RESULT = 3,
    -- //押大小结果
    SUB_SC_GET = 4,
    -- //得分

    -- //客户端 消息 定义
    SUB_CS_CHIP = 0,
    -- //押注
    SUB_CS_MARY = 1,
    -- //玛丽
    SUB_CS_TIME_OR_GET = 2,
    -- //比倍或者得分
    SUB_CS_BIG_OR_SMA = 3
    -- //押大小
}
-- 初始化消息结构体
function SHZSCInfo.AddGameMessage()
    MessgeEventRegister.Game_Messge_Un()
    -- 清除消息事件
    local t = EventCallBackTable
    t._01_GameInfo = self.OnHandleGameInfo
    -- 游戏消息

    t._02_ScenInfo = self.OnHandleScenInfo
    -- 场景消息
    t._03_LogonSuccess = self.OnGameLogonWin
    -- 登陆成功
    t._04_LogonOver = self.LogonOverMethod
    -- 登陆完成
    t._05_LogonFailed = self.LogonFailed
    -- 登陆失败
    t._06_Biao_Action = self.OnBiaoAction
    -- 表情
    t._07_UserEnter = self.OnPlayerEnter
    -- 用户进入
    t._08_UserLeave = self.OnPlayerLeave
    -- 用户离开
    t._09_UserStatus = self.OnPlayerStatus
    -- 用户状态
    t._10_UserScore = self.OnPlayerScore
    -- 用户分数
    t._11_GameQuit = self.OnGameQuit
    -- 退出游戏
    t._12_OnSit = self.OnInSitOver
    -- 用户入座
    t._13_ChangeTable = self.OnChageTable
    -- 换桌
    t._14_RoomBreakLine = self.OnRoomBreakLine
    -- 断线消息
    t._15_OnBackGame = self.HomeBackGame
    -- home键返回
    t._16_OnHelp = self.HelpOnClick
    -- 点击游戏帮助
    MessgeEventRegister.Game_Messge_Reg(t)
    -- 添加消息
    self.quitstate = false
end

-- 用户登陆
function SHZSCInfo.gamelogon()
    IsHomeBack = false
    self.AddGameMessage()
    local data = {
        [1] = 0,
        -- 广场版本 暂时不用
        [2] = 0,
        -- 进程版本 暂时不用
        [3] = SCPlayerInfo._01dwUser_Id,
        -- 用户 I D
        [4] = SCPlayerInfo._06wPassword,
        -- 登录密码 MD5小写加密
        [5] = Opcodes,
        --[5] = "hahwewethfh221222322h2f1",

        -- 机器序列 暂时不用
        [6] = 0,
        [7] = 0
    }
    local CMD_GR_LogonByUserID = {
        [1] = DataSize.UInt32,
        -- 广场版本，暂时不用
        [2] = DataSize.UInt32,
        -- 进程版本 ，暂时不用
        [3] = DataSize.UInt32,
        -- 用户ID
        [4] = DataSize.String33,
        -- 登录密码，MD5小写加密
        [5] = DataSize.String50,
        -- 机器码 暂时不用
        [6] = DataSize.byte,
        -- 补位
        [7] = DataSize.byte
        -- 补位
    }
    local buffer = SetC2SInfo(CMD_GR_LogonByUserID, data)
    --logErrorTable(data)
    Network.Send(MH.MDM_GR_LOGON, 3, buffer, gameSocketNumber.GameSocket)
end

-- 登陆完成消息
function SHZSCInfo.LogonOverMethod(wMain, wSubID, buffer, wSize)
    -- error("===================登陆完成===============");
    if (100 <= self.MySelf_ChairID) then
        --   error(" -- 不在桌子上");
        local buffer = ByteBuffer.New()
        Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket)
    else
          self.PlayerPrepare();
        --   error(" -- 若在桌子上 则直接发送玩家准备");
        NiuNiu_IsGameStartIn = false
    end
end

-- 用户准备
function SHZSCInfo.PlayerPrepare()
    local Data = { [1] = 0 }
    -- 旁观标志 必须等于0
    local CMD_GF_Info = {
        -- public byte bAllowLookon; //旁观标志 必须等于0
        [1] = DataSize.byte
    }
    local buffer = SetC2SInfo(CMD_GF_Info, Data)
     log("发送用户准备消息");
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket)
end

-- 入座完成
function SHZSCInfo.OnInSitOver(wMaiID, wSubID, buffer, wSize)
    if (wSize > 0) then
        error("=============入座失败=============")
        --   error(buffer:ReadString(wSize));
        Network.OnException(buffer:ReadString(wSize), 1)
    elseif (wSize == 0) then
        error("=============入座成功=============")
        self.PlayerPrepare()
    end
end

-- 登陆成功
function SHZSCInfo.OnGameLogonWin(wMaiID, wSubID, buffer, wSize)
    error("=============登陆成功============= " .. TableUserInfo._9wChairID)
    self.MySelf_ChairID = TableUserInfo._9wChairID
end

-- 登陆失败消息
function SHZSCInfo.LogonFailed(wMain, wSubID, buffer, wSize)
    error("=============登陆失败=============")
    --  error(buffer:ReadString(wSize));
    Network.OnException(buffer:ReadString(wSize), 1)
end

-- 游戏消息
function SHZSCInfo.OnHandleGameInfo(wMain, wSubID, buffer, wSize)
    --error("=============游戏消息================");
    SHZGameMangerTable[1]:GameInfo(wMain, wSubID, buffer, wSize)
end

-- 客户端向服务器发送请求信息
-- 选择比倍or得分0为得分，1为比倍
function SHZSCInfo.ChipOrGetSendInfo(num)
    --error("--选择比倍or得分0为得分，1为比倍");
    SHZSCInfo.SendUserReady()
    local b = ByteBuffer.New()
    b:WriteByte(num)
    -- 补位
    b:WriteByte(0)
    b:WriteByte(0)
    b:WriteByte(0)
    Network.Send(MH.MDM_GF_GAME, MH_SHZ.SUB_CS_TIME_OR_GET, b, gameSocketNumber.GameSocket)
end

-- 主游戏下注
self.ChipSend = 0
function SHZSCInfo.MainSendInfo(byline, byindex)
    --error("--主游戏下注");
    SHZSCInfo.SendUserReady()
    local b = ByteBuffer.New()
    b:WriteByte(byline)
    b:WriteByte(byindex)
    b:WriteByte(0)
    b:WriteByte(0)
    error("发下注消息")
    Network.Send(MH.MDM_GF_GAME, MH_SHZ.SUB_CS_CHIP, b, gameSocketNumber.GameSocket)
    self.isreqStart=false
end
-- 转动玛丽游戏
function SHZSCInfo.RoteMarySendInfo()
    SHZSCInfo.SendUserReady()
    local b = ByteBuffer.New()
    Network.Send(MH.MDM_GF_GAME, MH_SHZ.SUB_CS_MARY, b, gameSocketNumber.GameSocket)
end
-- 押大小 1小 2中 3大
function SHZSCInfo.BigOrSmaSendInfo(num)
   -- if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then

        SHZSCInfo.SendUserReady()
        local b = ByteBuffer.New()
        b:WriteByte(num)
        -- 补位
        b:WriteByte(0)
        b:WriteByte(0)
        b:WriteByte(0)
        Network.Send(MH.MDM_GF_GAME, MH_SHZ.SUB_CS_BIG_OR_SMA, b, gameSocketNumber.GameSocket)
   -- end
end

function SHZSCInfo.WaitTimeSetInfo()
    coroutine.wait(1)
    IsHomeBack = false
end

-- 场景消息
function SHZSCInfo.OnHandleScenInfo(wMain, wSubID, buffer, wSize)
    --  error("=============场景消息=============wSize==="..wSize);
    self.ScenInfoTable = {}
    -- 下注列表
    local dwBetList = {}
    for i = 1, MH_SHZ.D_BET_INDEX_COUNT do
        table.insert(dwBetList, buffer:ReadUInt32())
        --error("下注列表："..dwBetList[i])
    end
    table.insert(self.ScenInfoTable, dwBetList)
    -- 游戏状态
    local Game_State = buffer:ReadByte()
    --error("游戏状态==============================:"..Game_State)
    table.insert(self.ScenInfoTable, Game_State)
    -- 压线条数
    local byLine = buffer:ReadByte()
    --error("压线条数："..byLine)
    table.insert(self.ScenInfoTable, byLine)

    -- 押注索引
    local byBetIndex = buffer:ReadByte()
    table.insert(self.ScenInfoTable, byBetIndex)
    --error("押注索引："..byLine)
    -- 图标
    local byImg = {}
    for i = 1, MH_SHZ.D_ROW_COUNT * MH_SHZ.D_COL_COUNT do
        --table.insert(byImg, buffer:ReadByte());
        table.insert(byImg, 0)
        --error("结果图标："..byImg[i])
    end

    table.insert(self.ScenInfoTable, byImg)
    -- 玛丽次数
    local byMaryCount = buffer:ReadByte()
    --error("玛丽次数："..byLine)
    table.insert(self.ScenInfoTable, byMaryCount)
    -- 奖励图标
    local byPrizeImg = {}
    for i = 1, MH_SHZ.D_MARY_PRIZE_COUNT do
        -- table.insert(byPrizeImg, buffer:ReadByte());
        table.insert(byPrizeImg, 0)
        --error("奖励图标"..byPrizeImg[i])
        --   error("玛丽初始化======"..byPrizeImg[#byPrizeImg]);
    end
    table.insert(self.ScenInfoTable, byPrizeImg)
    -- 停止索引
    --  local byStopIndex = buffer:ReadByte();
    local byStopIndex = 1
    table.insert(self.ScenInfoTable, byStopIndex)
    --error("停止索引："..byStopIndex)
    -- 赢分数
    -- local iWinScore = buffer:ReadInt32();
    local iWinScore = 0
    --error("赢了分数"..iWinScore)
    table.insert(self.ScenInfoTable, iWinScore)
    -- 历史大小
    local byHisBigSma = {}
    for i = 1, MH_SHZ.D_HIS_COUNT do
        local datanum = buffer:ReadByte()
        --error("历史大小："..datanum)
        if datanum > 0 then
            table.insert(byHisBigSma, datanum)
        end
    end
    self.IsMaxNum = buffer:ReadByte()
    --error("IsMaxNum："..self.IsMaxNum)
    self.MaxChip = buffer:ReadUInt32()
    --error("MaxChip"..self.MaxChip)
    table.insert(self.ScenInfoTable, byHisBigSma)
    SHZGameMangerTable[1]:ScenInfo()
end

-- 表情
function SHZSCInfo.OnBiaoAction(wMain, wSubID, buffer, wSize)
end

-- 用户进入
function SHZSCInfo.OnPlayerEnter(wMain, wSubID, buffer, wSize)
    -- error("通知用户进入桌子=================");
    local data = {}
    data = TableUserInfo
    local newdata = {
        _1dwUser_Id = data._1dwUser_Id,
        _2szNickName = data._2szNickName,
        _3bySex = data._3bySex,
        _4bCustomHeader = data._4bCustomHeader,
        _5szHeaderExtensionName = data._5szHeaderExtensionName,
        _6szSign = data._6szSign,
        _7wGold = data._7wGold,
        _8wPrize = data._8wPrize,
        _9wChairID = data._9wChairID,
        _10wTableID = data._10wTableID,
        _11byUserStatus = data._11byUserStatus,
        _12wScore = 0
    }
    SHZGameMangerTable[1].MyselfGold = newdata._7wGold
end

-- 用户离开
function SHZSCInfo.OnPlayerLeave(wMain, wSubID, buffer, wSize)
    -- error("通知用户已经离开桌子=================");
    local data = {}
    data = TableUserInfo
    local newdata = {
        _1dwUser_Id = data._1dwUser_Id,
        _2szNickName = data._2szNickName,
        _3bySex = data._3bySex,
        _4bCustomHeader = data._4bCustomHeader,
        _5szHeaderExtensionName = data._5szHeaderExtensionName,
        _6szSign = data._6szSign,
        _7wGold = data._7wGold,
        _8wPrize = data._8wPrize,
        _9wChairID = data._9wChairID,
        _10wTableID = data._10wTableID,
        _11byUserStatus = data._11byUserStatus,
        _12wScore = 0
    }
end

-- 用户状态
function SHZSCInfo.OnPlayerStatus(wMain, wSubID, buffer, wSize)
    local data = {}
    data = TableUserInfo
    local newdata = {
        _1dwUser_Id = data._1dwUser_Id,
        _2szNickName = data._2szNickName,
        _3bySex = data._3bySex,
        _4bCustomHeader = data._4bCustomHeader,
        _5szHeaderExtensionName = data._5szHeaderExtensionName,
        _6szSign = data._6szSign,
        _7wGold = data._7wGold,
        _8wPrize = data._8wPrize,
        _9wChairID = data._9wChairID,
        _10wTableID = data._10wTableID,
        _11byUserStatus = data._11byUserStatus,
        _12wScore = 0
    }
    SHZGameMangerTable[1].MyselfGold = newdata._7wGold
end

-- 用户分数
function SHZSCInfo.OnPlayerScore(wMain, wSubID, buffer, wSize)
    local data = {}
    data = TableUserInfo
    local newdata = {
        _1dwUser_Id = data._1dwUser_Id,
        _2szNickName = data._2szNickName,
        _3bySex = data._3bySex,
        _4bCustomHeader = data._4bCustomHeader,
        _5szHeaderExtensionName = data._5szHeaderExtensionName,
        _6szSign = data._6szSign,
        _7wGold = data._7wGold,
        _8wPrize = data._8wPrize,
        _9wChairID = data._9wChairID,
        _10wTableID = data._10wTableID,
        _11byUserStatus = data._11byUserStatus,
        _12wScore = 0
    }
    SHZGameMangerTable[1].MyselfGold = newdata._7wGold
end

-- 退出游戏
function SHZSCInfo.OnGameQuit(wMain, wSubID, buffer, wSize)
    logError(" SHZSCInfo.OnGameQuit")
    if SHZGameMangerTable[1].Running then
        self.ShowHintInfo()
    else
        self.SureBtnOnClick()
    end
end

function SHZSCInfo.SureBtnOnClick()
    --  error("点击确认退出按钮");
    self.quitstate = true

    GameNextScenName = gameScenName.HALL
    MessgeEventRegister.Game_Messge_Un()
    -- NiuNiuPanel.ClearInfo();
    MusicManager:PlayBacksound("end", false)
    -- 停止背景音乐
    ReturnHallNum = 0
    ReturnLoginNum = 0
    TishiScenes = nil

    GameSetsBtnInfo.LuaGameQuit()
    coroutine.start(self.DestoryAb)
end

-- 显示提示界面
function SHZSCInfo.ShowHintInfo()
    -- 加载提示资源
    --   error("加载提示资源=================");
    local t = GeneralTipsSystem_ShowInfo
    t._01_Title = "提    示"
    t._02_Content = "当前正在游戏，确认退出？"
    t._03_ButtonNum = 2
    t._04_YesCallFunction = self.SureBtnOnClick
    t._05_NoCallFunction = self.IguoreBtnOnClick
    MessageBox.CreatGeneralTipsPanel(t)
end

-- 点击取消提示界面
function SHZSCInfo.IguoreBtnOnClick()
    -- error("点击取消按钮");
end

-- 释放资源
function SHZSCInfo.DestoryAb()
    -- error("点击取消按钮");
    -- coroutine.wait(1)
    --[[    Unload("module18/game_luashzmain");
    Unload("module18/game_luashzmusic");
    Unload("module18/game_shzmary");
    Unload("module18/game_shzchip");
    Unload("module18/game_luashzmain_obj");
    Unload("module18/game_luashzhelp");--]]
    SHZSCInfo.ClearInfo()
end

-- 换桌
function SHZSCInfo.OnChageTable(wMain, wSubID, buffer, wSize)
end

-- 点击帮助
function SHZSCInfo.HelpOnClick()
    SHZPanel:OnClickHelp()
end

-- 断线消息
function SHZSCInfo.OnRoomBreakLine(wMain, wSubID, buffer, wSize)
    error("游戏断线消息")
    --    MusicManager:PlayBacksound("end", false);
    --    GameNextScenName = gameScenName.HALL;
    --    MessgeEventRegister.Game_Messge_Un();
    --    NiuNiuPanel.ClearInfo();
    local tab = GeneralTipsSystem_ShowInfo
    tab._01_Title = ""
    tab._02_Content = str
    tab._03_ButtonNum = 1
    local quit = function()
        self.RoomBreakQuit(str)
        --    Network.OnException(buffer:ReadString(wSize), 1);
        coroutine.start(self.DestoryAb)
    end
    tab._04_YesCallFunction = quit
    tab._05_NoCallFunction = nil
    MessageBox.CreatGeneralTipsPanel(tab)
    -- local str = buffer:ReadString(wSize)
end

function SHZSCInfo.RoomBreakQuit(str)
    local t = GeneralTipsSystem_ShowInfo
    t._01_Title = "提    示"
    t._02_Content = str
    t._03_ButtonNum = 1
    t._04_YesCallFunction = self.SureQuit
    t._05_NoCallFunction = self.SureQuit
    MessageBox.CreatGeneralTipsPanel(t)
end

function SHZSCInfo.SureQuit()
    GameNextScenName = gameScenName.HALL
    MessgeEventRegister.Game_Messge_Un()
    -- NiuNiuPanel.ClearInfo();
    MusicManager:PlayBacksound("end", false)
    -- 停止背景音乐
    ReturnHallNum = 0
    ReturnLoginNum = 0
    TishiScenes = nil
    --    local variable = ByteBuffer.New();
    --    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_LEFT_GAME_REQ, variable, gameSocketNumber.GameSocket);
    --Network.Close(gameSocketNumber.GameSocket)
    --  GameManager.ChangeScen(gameScenName.HALL);
    GameSetsBtnInfo.LuaGameQuit()
    coroutine.start(self.DestoryAb)
end

-- Home键返回
function SHZSCInfo.HomeBackGame()
    if self.isreqStart then
        SHZPanel.Reconnect()
    end
end

-- 退出场景，释放资源
function SHZSCInfo.ClearInfo()
    SHZGameMangerTable = {}
    ResultImgLuaTable = {}
    MaryImgLuaTable = {}
    if SHZPanel.MarySelf ~= nil then
        SHZPanel.MarySelf.maryPanel = nil
        SHZPanel.MarySelf = {}
    end
    if SHZPanel.MainSelf ~= nil then
        SHZPanel.MainSelf.mainPanel = nil
        SHZPanel.MainSelf = {}
    end
    if SHZPanel.ChipSelf ~= nil then
        SHZPanel.ChipSelf.chipinPanel = nil
        SHZPanel.ChipSelf = {}
    end
    if SHZPanel.HelpPanel ~= nil then
        SHZPanel.HelpPanel = nil
    end
end
-- 发送用户准备（游戏中）
function SHZSCInfo.SendUserReady()
    --error("==========发送用户准备==========");
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_USER_READY, buffer, gameSocketNumber.GameSocket)
end
