-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion

--require(g_sSlotModuleNum .. "Slot/SlotBase")

JJPM_Network = {};
local self = JJPM_Network;

self.SUB_CS_CHIP_NORMAL = 0;  --下注
self.SUB_CS_CLEAR_MYPUSHMONEY = 1;  --清除下注
self.SUB_CS_CHIP_AGAIN = 2;--续投

self.SUB_SC_CHIP_NORMAL = 0;--押注-普通
self.SUB_SC_BET_FAIL = 1;--下注失败
self.SUB_SC_START = 2;--开始
self.SUB_SC_GAME_RESULT = 3;--游戏结束
self.SUB_SC_CLEAR_BET = 4;--清除下注
self.SUB_SC_CHIP_AGAIN = 5;--续投

function JJPM_Network.AddMessage()
    EventCallBackTable._01_GameInfo = self.OnHandleGameInfo;
    EventCallBackTable._02_ScenInfo = self.OnHandleSceneInfo;
    EventCallBackTable._03_LogonSuccess = self.OnHandleLoginSuccess;
    EventCallBackTable._04_LogonOver = self.OnHandleLoginCompleted;
    EventCallBackTable._05_LogonFailed = self.OnHandleLoginFailed;
    EventCallBackTable._07_UserEnter = self.OnHandleUserEnter;
    EventCallBackTable._08_UserLeave = self.OnHandleUserLeave;
    EventCallBackTable._10_UserScore = self.OnHandleUserScore;
    EventCallBackTable._11_GameQuit = self.OnHandleGameQuit;
    EventCallBackTable._12_OnSit = self.OnHandleSitSeat;
    EventCallBackTable._14_RoomBreakLine = self.OnHandleBreakRoomLine;
    EventCallBackTable._15_OnBackGame = self.OnHandleBackGame;
    EventCallBackTable._16_OnHelp = self.OnHandleHelp;
    MessgeEventRegister.Game_Messge_Reg(EventCallBackTable)
end
function JJPM_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function JJPM_Network.LoginGame()
    --登录游戏
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(0);
    buffer:WriteUInt32(0);
    buffer:WriteUInt32(SCPlayerInfo._01dwUser_Id);
    buffer:WriteBytes(33, SCPlayerInfo._6wPassword);
    buffer:WriteBytes(100, Opcodes);
    buffer:WriteByte(0);
    buffer:WriteByte(0);
    Network.Send(MH.MDM_GR_LOGON, MH.SUB_GR_LOGON_GAME, buffer, gameSocketNumber.GameSocket);
end
function JJPM_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function JJPM_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
--挂机押注
function JJPM_Network.ChipAgain()
    log("挂机押注")
    if JJPMEntry.myGold < JJPMEntry.totalChip then
        MessageBox.CreatGeneralTipsPanel("Insufficient gold coins, please recharge");
        return ;
    end
    local buffer = ByteBuffer.New();
    for i = 1, JJPM_DataConfig.AREA_COUNT do
        buffer:WriteUInt32(JJPMEntry.ChipAreaList[i]);
    end
    Network.Send(MH.MDM_GF_GAME, JJPM_Network.SUB_CS_CHIP_AGAIN, buffer, gameSocketNumber.GameSocket);
end
--押注
function JJPM_Network.Chip()
    if JJPMEntry.myGold < JJPMEntry.currentBet then
        MessageBox.CreatGeneralTipsPanel("Insufficient gold coins, please recharge");
        return ;
    end
    local buffer = ByteBuffer.New();
    buffer:WriteByte(JJPMEntry.currentBetArea);
    buffer:WriteUInt32(JJPMEntry.currentBet);
    Network.Send(MH.MDM_GF_GAME, JJPM_Network.SUB_CS_CHIP_NORMAL, buffer, gameSocketNumber.GameSocket);
end
function JJPM_Network.ClearChip()
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_GF_GAME, JJPM_Network.SUB_CS_CLEAR_MYPUSHMONEY, buffer, gameSocketNumber.GameSocket);
end
function JJPM_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));
    --游戏消息
    if JJPM_Network.SUB_SC_GAME_RESULT == sid then
        --结算数据
        log("结算   chairID:" .. JJPMEntry.ChairID);
        JJPMEntry.ResultData.cbIndex = buffer:ReadByte();
        JJPMEntry.ResultData.IsFrist = buffer:ReadByte();
        JJPMEntry.ResultData.lWinScore = {};
        for i = 1, JJPM_DataConfig.GAME_PLAYER do
            local goal = tonumber(buffer:ReadInt64Str());
            table.insert(JJPMEntry.ResultData.lWinScore, tonumber(goal));
            if JJPMEntry.ChairID == i - 1 then
                JJPMEntry.totalWin = goal;
            end
        end
        logTable(JJPMEntry.ResultData);
        JJPMEntry.hasResult = true;
        JJPM_Roll.ShowRun();
    elseif sid == self.SUB_SC_START then
        --可以下注
        log("开始下注")
        JJPMEntry.StartChipState();
    elseif sid == self.SUB_SC_BET_FAIL then
        local tag = buffer:ReadByte();
        if tag == 1 then
            MessageBox.CreatGeneralTipsPanel("Insufficient gold coins");
        elseif tag == 2 then
            MessageBox.CreatGeneralTipsPanel("超过下注限制");
        elseif tag == 3 then
            MessageBox.CreatGeneralTipsPanel("下注失败");
        end
    elseif sid == self.SUB_SC_CLEAR_BET then
        --清除下注
        local chairID = buffer:ReadInt32();
        log("清除下注：" .. chairID .. "...自身椅子：" .. JJPMEntry.ChairID);
        if JJPMEntry.ChairID == chairID then
            JJPMEntry.ClearChip();
        end
    elseif sid == self.SUB_SC_CHIP_AGAIN then
        --续投，直接将下注区域点亮显示
        local chairID = buffer:ReadInt32();
        JJPMEntry.totalChip = 0;
        if chairID == JJPMEntry.ChairID then
            local chiplist = {};
            for i = 1, JJPM_DataConfig.AREA_COUNT do
                local chip = buffer:ReadInt32();
                table.insert(chiplist, chip);
                JJPMEntry.totalChip = JJPMEntry.totalChip + chip;
            end
            JJPMEntry.ChipAreaList = chiplist;
        end
        JJPMEntry.myGold = JJPMEntry.myGold - JJPMEntry.totalChip;
        JJPMEntry.selfgold.text = tostring(JJPMEntry.myGold);
        JJPMEntry.ShowChipAgain();
    elseif sid == self.SUB_SC_CHIP_NORMAL then
        local data = { chairId = 0, cbIndex = 0, nBetScore = 0 };
        data.chairId = buffer:ReadInt32();
        data.cbIndex = buffer:ReadByte();
        data.nBetScore = buffer:ReadInt32();
        if data.chairId == JJPMEntry.ChairID then
            JJPMEntry.myGold = JJPMEntry.myGold - data.nBetScore;
            JJPMEntry.selfgold.text = tostring(JJPMEntry.myGold);
        end
        JJPMEntry.PlayChip(data)
    end
end
function JJPM_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    JJPMEntry.SceneData.nBetCount = buffer:ReadInt32();
    JJPMEntry.SceneData.nBetList = {};
    for i = 1, JJPM_DataConfig.CHIPLISTCOUNT do
        table.insert(JJPMEntry.SceneData.nBetList, buffer:ReadInt32());
    end
    JJPMEntry.SceneData.tagBetMsg = {};
    for i = 1, JJPM_DataConfig.AREA_COUNT do
        local temparea = { cbIndex = 0, nGold = 0 };
        temparea.cbIndex = buffer:ReadByte();
        temparea.nGold = buffer:ReadInt32();
        table.insert(JJPMEntry.SceneData.tagBetMsg, temparea);
    end
    JJPMEntry.SceneData.tagMyBetMsg = {};
    for i = 1, JJPM_DataConfig.AREA_COUNT do
        local temparea = { cbIndex = 0, nGold = 0 };
        temparea.cbIndex = buffer:ReadByte();
        temparea.nGold = buffer:ReadInt32();
        table.insert(JJPMEntry.SceneData.tagMyBetMsg, temparea);
    end
    JJPMEntry.SceneData.cbWinMsg = {};
    for i = 1, JJPM_DataConfig.HISTORY_COUNT do
        table.insert(JJPMEntry.SceneData.cbWinMsg, buffer:ReadByte());
    end
    JJPMEntry.SceneData.cbRoomState = buffer:ReadByte();
    JJPMEntry.SceneData.nTime = buffer:ReadInt32();
    logTable(JJPMEntry.SceneData);
    JJPMEntry.ChipAreaList = {};
    for i = 1, #JJPMEntry.SceneData.tagMyBetMsg do
        table.insert(JJPMEntry.ChipAreaList, JJPMEntry.SceneData.tagMyBetMsg[i].nGold);
    end
    JJPMEntry.InitPanel();
end
function JJPM_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    JJPM_Caijin.REQCJ();
end
function JJPM_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
    --登录完成消息
    log("登录游戏完成");
    if TableUserInfo._10wTableID == 65535 then
        --不在座子  需要重新入座
        self.InSeat();
    else
        --直接准备
        self.PrepareGame();
    end
end
function JJPM_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function JJPM_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    log("玩家头像=========" .. TableUserInfo._4bCustomHeader);
    --TODO 设置金币数量
    if TableUserInfo._1dwUser_Id == SCPlayerInfo._01dwUser_Id then
        JJPMEntry.ChairID = TableUserInfo._9wChairID;
        JJPMEntry.myGold = TableUserInfo._7wGold;
    end
    local userInfo = {
        _1dwUser_Id = TableUserInfo._1dwUser_Id,
        _2szNickName = TableUserInfo._2szNickName,
        _3bySex = TableUserInfo._3bySex,
        _4bCustomHeader = TableUserInfo._4bCustomHeader,
        _5szHeaderExtensionName = TableUserInfo._5szHeaderExtensionName,
        _6szSign = TableUserInfo._6szSign,
        _7wGold = TableUserInfo._7wGold,
        _8wPrize = TableUserInfo._8wPrize,
        _9wChairID = TableUserInfo._9wChairID,
        _10wTableID = TableUserInfo._10wTableID,
        _11byUserStatus = TableUserInfo._11byUserStatus,
    };
    JJPMEntry.UserList[userInfo._9wChairID + 1] = userInfo;
end
function JJPM_Network.OnHandleUserLeave(wMainID, wSubID, buffer, wSize)
    log("玩家离开=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._9wChairID);
    JJPMEntry.UserList[TableUserInfo._9wChairID + 1] = nil;
end
function JJPM_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
    if TableUserInfo._1dwUser_Id == SCPlayerInfo._01dwUser_Id then
        JJPMEntry.myGold = TableUserInfo._7wGold;
    end
end
function JJPM_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    --destroy(JJPMEntry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function JJPM_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function JJPM_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function JJPM_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function JJPM_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end