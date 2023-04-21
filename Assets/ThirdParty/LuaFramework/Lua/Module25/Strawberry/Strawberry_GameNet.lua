Strawberry_GameNet = {}
local self = Strawberry_GameNet
self.isreqStart=true;
MH_StrawberryData = {
    -- 游戏ID
    KIND_ID = 29,
    -- //玩家总人数
    GAME_PLAYER = 1,
    -- 游戏名字
    GAME_NAME_TEXT = "草莓老虎机",
    -- 游戏状态
    -- 等待开始
    GS_WK_FREE = 0,
    -- 游戏进行
    GS_WK_PLAYING = 100,
    -- -----------游戏状态-------------------
    -- 下注
    D_GAME_STATE_BET = 0,
    -- 主游戏结算
    D_GAME_STATE_RESULT = 1,
    -- 玛丽小游戏
    D_GAME_STATE_MALI = 2,
    -- 玛丽游戏结算
    D_GAME_STATE_MALI_OVER = 3,
    -- -----------服务器消息-------------------
    -- 游戏结果
    SUB_SC_GAME_RESULT = 0,
    -- 玛丽结果
    SUB_SC_MALI_RESULT = 1,
    -- 游戏结束
    SUB_SC_GAME_OVER = 2,
    -- -----------游戏基础数据-------------------
    -- //下注列表长度
    CHIPS_LIST_LEN = 5,
    -- //图标数量
    D_ICON_CNT = 15,
    -- //行数
    D_ROW_CNT = 3,
    -- //列数
    D_COL_CNT = 5,
    -- //线数
    D_LINE_CNT = 9,
    -- //游戏图标
    enum_enGameImage = {
        E_CERRY = 0, -- //樱桃
        E_APRICOT = 1, -- //杏
        E_LEMON = 2, -- //柠檬
        E_APPLE = 3, -- //苹果
        E_PEAR = 4, -- //梨
        E_WATERMELON = 5, -- //西瓜
        E_COCKTAIL = 6, -- //鸡尾酒
        E_STRAWBERRY = 7, -- //草莓
        E_WILD = 8 -- //WILD
    },
    enum_IconName = {
        [1] = "E_CERRY", -- //樱桃
        [2] = "E_APRICOT", -- //杏
        [3] = "E_LEMON", -- //柠檬
        [4] = "E_APPLE", -- //苹果
        [5] = "E_PEAR", -- //梨
        [6] = "E_WATERMELON", -- //西瓜
        [7] = "E_COCKTAIL", -- //鸡尾酒
        [8] = "E_STRAWBERRY", -- //草莓
        [9] = "E_WILD" -- //WILD
    },
    -- -----------客户端消息-------------------
    -- 主游戏
    SUB_CS_GAME_START = 0,
    -- 玛丽
    SUB_CS_GAME_MALI = 1,
    -- 得分
    SUB_CS_GET_SCORE = 2,
    C_IMG_LIST = {
        {5, 6, 7, 8, 9},
        {0, 1, 2, 3, 4},
        {10, 11, 12, 13, 14},
        {0, 6, 12, 8, 4},
        {10, 6, 2, 8, 14},
        {0, 1, 7, 3, 4},
        {10, 11, 7, 13, 14},
        {5, 11, 12, 13, 9},
        {5, 1, 2, 3, 9}
    }
}
-- 初始化消息结构体
function Strawberry_GameNet.AddGameMessage()
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
    -- Home键出去
    t._17_OnStopGame = self.HomeStopGame
    -- 框架弹框消息处理
    t._18_OnHandleMessage = self.OnHandleMessage
    -- 点击游戏帮助
    MessgeEventRegister.Game_Messge_Reg(t)
    -- 添加消息
end

-- 用户登陆
function Strawberry_GameNet.gamelogon()
    self.ClearInfo()
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
        [5] = DataSize.String100,
        -- 机器码 暂时不用
        [6] = DataSize.byte,
        -- 补位
        [7] = DataSize.byte
        -- 补位
    }
    local buffer = SetC2SInfo(CMD_GR_LogonByUserID, data)
    Network.Send(MH.MDM_GR_LOGON, 3, buffer, gameSocketNumber.GameSocket)
end

-- 登陆完成消息
function Strawberry_GameNet.LogonOverMethod(wMain, wSubID, buffer, wSize)
    error("===================登陆完成===============1")
    if (65535 == self.MySelf_ChairID) then
        --   error(" -- 不在桌子上");
        local buffer = ByteBuffer.New()
        Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket)
    else
        --   error(" -- 若在桌子上 则直接发送玩家准备");
        self.PlayerPrepare()
    end
end

-- 用户准备
function Strawberry_GameNet.PlayerPrepare()
    local Data = {[1] = 0}
    -- 旁观标志 必须等于0
    local CMD_GF_Info = {
        -- public byte bAllowLookon; //旁观标志 必须等于0
        [1] = DataSize.byte
    }
    local buffer = SetC2SInfo(CMD_GF_Info, Data)
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket)
end

-- 入座完成
function Strawberry_GameNet.OnInSitOver(wMaiID, wSubID, buffer, wSize)
    if (wSize > 0) then
        error("=============入座失败=============")
        Network.OnException(buffer:ReadString(wSize), 1)
    elseif (wSize == 0) then
        --   error("=============入座成功=============");
        self.PlayerPrepare()
    end
end

-- 登陆成功
function Strawberry_GameNet.OnGameLogonWin(wMaiID, wSubID, buffer, wSize)
    error("=============登陆成功============= " .. TableUserInfo._9wChairID)
    self.MySelf_ChairID = TableUserInfo._9wChairID
end

-- 登陆失败消息
function Strawberry_GameNet.LogonFailed(wMain, wSubID, buffer, wSize)
    error("=============登陆失败=============")
    --  error(buffer:ReadString(wSize));
    Network.OnException(buffer:ReadString(wSize), 1)
end

--====================================================================游戏消息======================================================================================
function Strawberry_GameNet.OnHandleGameInfo(wMain, wSubID, buffer, wSize)
    local wSubID = string.gsub(wSubID, wMain, "")
    wSubID = tonumber(wSubID)
    -- 游戏结果
    if wSubID == MH_StrawberryData.SUB_SC_GAME_RESULT then
        -- 结算金币
        self.WinNum = tonumber(tostring(toInt64(buffer:ReadInt64Str())))
        -- 连线倍率
        Strawberry_iLineRate = {}
        for i = 1, MH_StrawberryData.D_LINE_CNT do
            table.insert(Strawberry_iLineRate, buffer:ReadInt32())
        end
        -- 图标
        self.byImg = {}
        for i = 1, MH_StrawberryData.D_ICON_CNT do
            local data = buffer:ReadByte()
            --            if data > MH_StrawberryData.enum_enGameImage.E_STRAWBERRY then data = math.random(0, 8) end
            table.insert(self.byImg, data)
        end
        -- 连线结果
        self.LineList = {}
        for i = 1, MH_StrawberryData.D_LINE_CNT * MH_StrawberryData.D_COL_CNT do
            table.insert(self.LineList, buffer:ReadByte())
        end
        -- 玛丽次数
        self.byMaryCount = buffer:ReadByte()
        Strawberry_MainPanel.GameResult()
        self.isreqStart=true
        return
    end
    -- 玛丽结果
    if wSubID == MH_StrawberryData.SUB_SC_MALI_RESULT then
        -- 结算金币
        self.WinNum = tonumber(tostring(toInt64(buffer:ReadInt64Str())))
        -- 玛丽次数
        self.byMaryCount = buffer:ReadByte()
        -- 玛丽奖励图标
        self.byPrizeImg = {}
        for i = 1, MH_StrawberryData.D_ROW_CNT do
            table.insert(self.byPrizeImg, buffer:ReadByte())
        end
        -- 停止索引
        self.byStopIndex = buffer:ReadByte()
        Strawberry_MaryPanel.GetGameResult()
        self.isreqStart=true

        return
    end
    -- 游戏得分
    if wSubID == MH_StrawberryData.SUB_SC_GAME_OVER then
        logYellow("游戏得分")
        self.isreqStart=true
        Strawberry_MainPanel.SCGameResult()
    end
end
--====================================================================游戏消息======================================================================================

--============================================================客户端向服务器发送请求信息==============================================================================
-- 主游戏下注
function Strawberry_GameNet.MainSendInfo(byindex)
    if (self.IsStar == true) then
        log("游戏开始中")
        return
    end
    Strawberry_GameNet.SendUserReady()
    local b = ByteBuffer.New()
    b:WriteUInt32(byindex)
    Network.Send(MH.MDM_GF_GAME, MH_StrawberryData.SUB_CS_GAME_START, b, gameSocketNumber.GameSocket)
    self.isreqStart=false
    self.IsStar = true
    logYellow("============================================发送游戏开始====================================================")
end

-- 转动玛丽游戏
function Strawberry_GameNet.RoteMarySendInfo()
    Strawberry_GameNet.SendUserReady()
    local b = ByteBuffer.New()
    Network.Send(MH.MDM_GF_GAME, MH_StrawberryData.SUB_CS_GAME_MALI, b, gameSocketNumber.GameSocket)
    self.isreqStart=false
    --   error("转动玛丽游戏");
end

-- 结算消息
function Strawberry_GameNet.SendResult()
    Strawberry_MainPanel.GameInfo()
    Strawberry_GameNet.SendUserReady()
    local b = ByteBuffer.New()
    Network.Send(MH.MDM_GF_GAME, MH_StrawberryData.SUB_CS_GET_SCORE, b, gameSocketNumber.GameSocket)
    log("发送结算金币")
end
--============================================================客户端向服务器发送请求信息==============================================================================

function Strawberry_GameNet.ClearInfo()
    self.GoldNum = 0
    -- 结算金币
    self.WinNum = 0
    -- 当前底注
    self.icurChip = 0
    -- 下注列表
    Strawberry_ChipList = {}
    -- 游戏状态
    self.Game_State = 0
    -- //连线倍率
    Strawberry_iLineRate = {}
    -- 图标
    self.byImg = {}
    -- 连线结果
    self.LineList = {}
    -- 是否进入小玛丽
    self.EnterMaryBl = false
    -- 玛丽次数
    self.byMaryCount = 0
    -- 玛丽奖励图标
    self.byPrizeImg = {}
    -- 停止索引
    self.byStopIndex = 0
end

--================================================================场景消息=====================================================================

function Strawberry_GameNet.OnHandleScenInfo(wMain, wSubID, buffer, wSize)
    log("设置场景信息")
    -- 下注列表
    -- 结算金币
    self.WinNum = tonumber(tostring(toInt64(buffer:ReadInt64Str())))
    -- 当前底注
    self.icurChip = buffer:ReadInt32()

    -- 下注列表
    Strawberry_ChipList = {}
    for i = 1, MH_StrawberryData.CHIPS_LIST_LEN do --长度5
        table.insert(Strawberry_ChipList, buffer:ReadInt32())
    end
    -- //连线倍率
    Strawberry_iLineRate = {}
    for i = 1, MH_StrawberryData.D_LINE_CNT do --长度9
        table.insert(Strawberry_iLineRate, buffer:ReadInt32())
    end
    -- 游戏状态
    self.Game_State = buffer:ReadByte()
    -- 图标
    self.byImg = {}
    for i = 1, MH_StrawberryData.D_ICON_CNT do --15
        local data = buffer:ReadByte()
        if data > MH_StrawberryData.enum_enGameImage.E_STRAWBERRY then
            data = math.random(0, 8)
        end
        table.insert(self.byImg, data)
    end
    -- 连线结果
    self.LineList = {}
    -- 0代表不播动画，1代表要播动画
    for i = 1, MH_StrawberryData.D_LINE_CNT * MH_StrawberryData.D_COL_CNT do --长度45
        local data = buffer:ReadByte()
        if data > 1 then
            data = 0
        end
        table.insert(self.LineList, data)
    end
    -- 玛丽次数
    self.byMaryCount = buffer:ReadByte()
    -- 玛丽奖励图标
    self.byPrizeImg = {}
    for i = 1, MH_StrawberryData.D_ROW_CNT do --长度3
        local data = buffer:ReadByte()
        if data > MH_StrawberryData.enum_enGameImage.E_STRAWBERRY then
            data = math.random(0, 8)
        end
        table.insert(self.byPrizeImg, data)
    end
    -- 停止索引
    self.byStopIndex = buffer:ReadByte()
    self.OhterGameWinGold = buffer:ReadInt32()
    self.WinNum = self.WinNum + self.OhterGameWinGold
    -- 初始化玛丽游戏
    Strawberry_MainPanel.InitScenInfo()
    log("设置场景信息10")
end

--================================================================场景消息=====================================================================

-- 用户进入
function Strawberry_GameNet.OnPlayerEnter(wMain, wSubID, buffer, wSize)
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
    self.GoldNum = newdata._7wGold
end

-- 用户离开
function Strawberry_GameNet.OnPlayerLeave(wMain, wSubID, buffer, wSize)
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
function Strawberry_GameNet.OnPlayerStatus(wMain, wSubID, buffer, wSize)
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
    self.GoldNum = newdata._7wGold
end

-- 用户分数
function Strawberry_GameNet.OnPlayerScore(wMain, wSubID, buffer, wSize)
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
    self.GoldNum = newdata._7wGold
end

-- 退出游戏
function Strawberry_GameNet.OnGameQuit(wMain, wSubID, buffer, wSize)
    if Strawberry_MainPanel.SetBtnState ~= 0 then
        self.ShowHintInfo()
        return
    end
    self.SureBtnOnClick()
end

function Strawberry_GameNet.SureBtnOnClick()
    --  error("点击确认退出按钮");

    GameNextScenName = gameScenName.HALL
    MessgeEventRegister.Game_Messge_Un()
    GameSetsBtnInfo.LuaGameQuit()
    Strawberry_MainPanel.ClearInfoData()
    coroutine.start(self.DestoryAb)
end

function Strawberry_GameNet.DestoryAb()
    coroutine.wait(1)
    Strawberry_MaryPanel.marypanel = nil
    Unload(cn_strawberry_help.ab)
    Unload(cn_strawberry_main.ab)
    Unload(cn_strawberry_mary.ab)
    Unload(cn_strawberry_canvas.ab)
    Unload(cn_strawberry_music.ab)
end

-- 显示提示界面
function Strawberry_GameNet.ShowHintInfo()
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
function Strawberry_GameNet.IguoreBtnOnClick()
    -- error("点击取消按钮");
end

-- 换桌
function Strawberry_GameNet.OnChageTable(wMain, wSubID, buffer, wSize)
end

-- 断线消息
function Strawberry_GameNet.OnRoomBreakLine(wMain, wSubID, buffer, wSize)
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
end

function Strawberry_GameNet.RoomBreakQuit(str)
    local t = GeneralTipsSystem_ShowInfo
    t._01_Title = "提    示"
    t._02_Content = str
    t._03_ButtonNum = 1
    t._04_YesCallFunction = self.SureQuit
    t._05_NoCallFunction = self.SureQuit
    MessageBox.CreatGeneralTipsPanel(t)
end

function Strawberry_GameNet.SureQuit()
    GameNextScenName = gameScenName.HALL
    MessgeEventRegister.Game_Messge_Un()
    -- 停止背景音乐
    ReturnHallNum = 0
    ReturnLoginNum = 0
    TishiScenes = nil
    local variable = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_LEFT_GAME_REQ, variable, gameSocketNumber.GameSocket)
    Network.Close(gameSocketNumber.GameSocket)
    GameManager.ChangeScen(gameScenName.HALL)
    coroutine.start(self.DestoryAb)
end

-- Home键返回
function Strawberry_GameNet.HomeBackGame()
    logYellow("回到游戏=="..tostring(self.isreqStart))
    if self.isreqStart then
        Strawberry_Scen.Reconnect()
    end
    --    HallScenPanel.ReLoadGame(self.ReLoadGame);
end

function Strawberry_GameNet.ReLoadGame()
    -- error("Strawberry_GameNet.ReLoadGame()====");
    self.ReLogon = true
    Strawberry_GameNet.gamelogon()
end

-- Home键离开
function Strawberry_GameNet.HomeStopGame()
    --    self.ReLogon = false;
    --    error("Home键离开游戏===================================");
    --    table.insert(ReturnNotShowError, "95003");
    --    NetManager:Disconnect(gameSocketNumber.GameSocket)
end

-- 框架断线是否提示
function Strawberry_GameNet.OnHandleMessage()
end

-- 发送用户准备（游戏中）
function Strawberry_GameNet.SendUserReady()
    -- logGreen("==========发送用户准备==========");
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_USER_READY, buffer, gameSocketNumber.GameSocket)
end

function Strawberry_GameNet.HelpOnClick()
    Strawberry_MainPanel.HelpOnClick(Strawberry_MainPanel.Help_Btn)
end
