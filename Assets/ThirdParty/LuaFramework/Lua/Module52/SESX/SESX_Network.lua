-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion

--require(g_sSlotModuleNum .. "Slot/SlotBase")

SESX_Network = {};
local self = SESX_Network;

self.LABA_MSG_CS_START = 1;--开始游戏

self.LABA_MSG_SC_BET_FAIL = 2;--下注失败
self.LABA_MSG_SC_CHECKOUT = 3;--游戏结算
self.LABA_MSG_SC_UPDATE_PRIZE_POOL = 8;--奖池

function SESX_Network.AddMessage()
    EventCallBackTable._01_GameInfo = self.OnHandleGameInfo;
    EventCallBackTable._02_ScenInfo = self.OnHandleSceneInfo;
    EventCallBackTable._03_LogonSuccess = self.OnHandleLoginSuccess;
    EventCallBackTable._04_LogonOver = self.OnHandleLoginCompleted;
    EventCallBackTable._05_LogonFailed = self.OnHandleLoginFailed;
    EventCallBackTable._07_UserEnter = self.OnHandleUserEnter;
    EventCallBackTable._10_UserScore = self.OnHandleUserScore;
    EventCallBackTable._11_GameQuit = self.OnHandleGameQuit;
    EventCallBackTable._12_OnSit = self.OnHandleSitSeat;
    EventCallBackTable._14_RoomBreakLine = self.OnHandleBreakRoomLine;
    EventCallBackTable._15_OnBackGame = self.OnHandleBackGame;
    EventCallBackTable._16_OnHelp = self.OnHandleHelp;
    MessgeEventRegister.Game_Messge_Reg(EventCallBackTable)
end
function SESX_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function SESX_Network.LoginGame()
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
function SESX_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function SESX_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
function SESX_Network.StartGame()
    if SESXEntry.myGold < SESXEntry.CurrentChip * SESX_DataConfig.ALLLINECOUNT and not SESXEntry.isFreeGame then
        MessageBox.CreatGeneralTipsPanel("Insufficient gold coins, please recharge");
        SESXEntry.ResetState();
        return ;
    end
    SESXEntry.isRoll = true;
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(SESX_DataConfig.ALLLINECOUNT);
    buffer:WriteUInt32(SESXEntry.CurrentChip);
    Network.Send(MH.MDM_GF_GAME, SESX_Network.LABA_MSG_CS_START, buffer, gameSocketNumber.GameSocket);
end
function SESX_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));
    --游戏消息
    if SESX_Network.LABA_MSG_SC_CHECKOUT == sid then
        --结算数据
        log("结算")
        SESXEntry.ResultData.ImgTable = {};
        for i = 1, SESX_DataConfig.ALLIMGCOUNT do
            table.insert(SESXEntry.ResultData.ImgTable, buffer:ReadInt32());
        end
        SESXEntry.ResultData.LineTypeTable = {};
        for i = 1, SESX_DataConfig.ALLLINECOUNT do
            table.insert(SESXEntry.ResultData.LineTypeTable, buffer:ReadByte());
        end
        SESXEntry.ResultData.m_nWinPeiLv = buffer:ReadInt32();
        SESXEntry.ResultData.m_nCurrGold = tonumber(buffer:ReadInt64Str());
        SESXEntry.ResultData.WinScore = buffer:ReadInt32();
        SESXEntry.ResultData.FreeCount = buffer:ReadInt32();
        SESXEntry.ResultData.m_nPrizePoolGold = buffer:ReadInt32();
        SESXEntry.ResultData.m_nPrizePoolWildGold = buffer:ReadInt32();
        SESXEntry.ResultData.m_bIsDoubleLong = buffer:ReadByte() == 1;
        logTable(SESXEntry.ResultData);
        SESXEntry.freeCount = SESXEntry.ResultData.FreeCount;
        if SESXEntry.totalFreeCount == 0 then
            SESXEntry.totalFreeCount = SESXEntry.ResultData.FreeCount;
        end
        SESXEntry.isDouble = SESXEntry.ResultData.m_bIsDoubleLong;
        SESXEntry.Roll();
    elseif sid == self.LABA_MSG_SC_BET_FAIL then
        local tag = buffer:ReadInt32();
        if tag == 1 then
            MessageBox.CreatGeneralTipsPanel("单线金币不正确");
        elseif tag == 2 then
            MessageBox.CreatGeneralTipsPanel("超过下注范围");
        elseif tag == 3 then
            MessageBox.CreatGeneralTipsPanel("Insufficient gold coins");
        elseif tag == 4 then
            MessageBox.CreatGeneralTipsPanel("Insufficient gold coins");
        elseif tag == 5 then
            MessageBox.CreatGeneralTipsPanel("Insufficient gold coins");
        end
        SESXEntry.ResetState();
    elseif sid == self.LABA_MSG_SC_UPDATE_PRIZE_POOL then
        --奖池数据
        local jackpot = buffer:ReadInt32();
        log("彩金：" .. jackpot);
        if SESX_Caijin.CaijinGold > 0 then
            if jackpot <= SESX_Caijin.currentCaijin then
                SESX_Caijin.currentCaijin = jackpot;
            end
        else
            SESX_Caijin.currentCaijin = jackpot;
        end
        SESX_Caijin.CaijinGold = jackpot;
    end
end
function SESX_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    SESXEntry.SceneData.freeNumber = buffer:ReadInt32();
    SESXEntry.SceneData.bet = buffer:ReadInt32();
    SESXEntry.SceneData.nGainPeilv = buffer:ReadInt32();
    SESXEntry.SceneData.chipNum = buffer:ReadInt32();
    SESXEntry.SceneData.chipList = {};
    for i = 1, SESXEntry.SceneData.chipNum do
        table.insert(SESXEntry.SceneData.chipList, buffer:ReadInt32());
    end
    if SESXEntry.SceneData.bet == 0 then
        SESXEntry.SceneData.bet = SESXEntry.SceneData.chipList[1];
    end
    SESXEntry.SceneData.m_bIsDouleWild = buffer:ReadByte();
    SESXEntry.isDouble = SESXEntry.SceneData.m_bIsDouleWild == 1;
    logTable(SESXEntry.SceneData);
    SESXEntry.InitPanel();
end
function SESX_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    SESX_Caijin.REQCJ();
end
function SESX_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function SESX_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function SESX_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    --TODO 设置金币数量
end
function SESX_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
end
function SESX_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    --destroy(SESXEntry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function SESX_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function SESX_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function SESX_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function SESX_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end