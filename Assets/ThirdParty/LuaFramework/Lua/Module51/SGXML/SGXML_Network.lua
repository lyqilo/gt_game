-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion

--require(g_sSlotModuleNum .. "Slot/SlotBase")

SGXML_Network = {};
local self = SGXML_Network;

self.SUB_CS_GAME_START = 1  --启动游戏
self.LABA_MSG_CS_SMALL_GAME = 5  --开始小游戏

self.LABA_MSG_SC_START = 1;--游戏开始
self.LABA_MSG_SC_CHECKOUT = 2;--游戏结算
self.LABA_MSG_SC_FREEGAME_CONFIG = 11;--免费游戏
self.LABA_MSG_SC_SMALL_GAME = 6;--小游戏结算
self.LABA_MSG_SC_UPDATE_PRIZE_POOL = 8;--奖池

function SGXML_Network.AddMessage()
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
function SGXML_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function SGXML_Network.LoginGame()
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
function SGXML_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function SGXML_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
function SGXML_Network.StartGame()
    if SGXMLEntry.myGold < SGXMLEntry.CurrentChip * SGXML_DataConfig.ALLLINECOUNT and not SGXMLEntry.isFreeGame then
        MessageBox.CreatGeneralTipsPanel("Insufficient gold coins, please recharge");
        SGXMLEntry.ResetState();
        return ;
    end
    SGXMLEntry.isRoll = true;
    SGXMLEntry.WinDesc.text = "Good luck next time";
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(SGXML_DataConfig.ALLLINECOUNT);
    buffer:WriteUInt32(SGXMLEntry.CurrentChip);
    Network.Send(MH.MDM_GF_GAME, SGXML_Network.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
end
function SGXML_Network.StartSmallGame()
    SGXMLEntry.isRoll = true;
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(SGXMLEntry.CurrentChip);
    Network.Send(MH.MDM_GF_GAME, SGXML_Network.LABA_MSG_CS_SMALL_GAME, buffer, gameSocketNumber.GameSocket);
end
function SGXML_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));
    --游戏消息
    if SGXML_Network.LABA_MSG_SC_CHECKOUT == sid then
        --结算数据
        log("结算")
        SGXMLEntry.ResultData.ImgTable = {};
        for i = 1, SGXML_DataConfig.ALLIMGCOUNT do
            table.insert(SGXMLEntry.ResultData.ImgTable, buffer:ReadInt32());
        end
        SGXMLEntry.ResultData.LineTypeTable = {};
        for i = 1, SGXML_DataConfig.ALLLINECOUNT do
            table.insert(SGXMLEntry.ResultData.LineTypeTable, buffer:ReadInt32());
        end
        SGXMLEntry.ResultData.m_nWinPeiLv = buffer:ReadInt32();
        SGXMLEntry.ResultData.m_nCurrGold = tonumber(buffer:ReadInt64Str());
        SGXMLEntry.ResultData.WinScore = buffer:ReadInt32();
        SGXMLEntry.ResultData.TotalWinScore = buffer:ReadInt32();
        SGXMLEntry.ResultData.FreeCount = buffer:ReadInt32();
        SGXMLEntry.ResultData.m_nMultiple = buffer:ReadInt32();
        SGXMLEntry.ResultData.m_nJackPotValue = buffer:ReadInt32();
        SGXMLEntry.ResultData.m_bSmallGame = buffer:ReadInt32();
        logTable(SGXMLEntry.ResultData);
        SGXMLEntry.freeCount = SGXMLEntry.ResultData.FreeCount;
        SGXMLEntry.smallGameCount = SGXMLEntry.ResultData.m_bSmallGame;
        if SGXMLEntry.totalFreeCount == 0 then
            SGXMLEntry.totalFreeCount = SGXMLEntry.ResultData.FreeCount;
        end
        SGXMLEntry.Roll();
    elseif sid == self.LABA_MSG_SC_SMALL_GAME then
        SGXMLEntry.SmallResultData.nSmallGameTatolConut = buffer:ReadInt32();
        SGXMLEntry.SmallResultData.nSmallGameConut = buffer:ReadInt32()
        SGXMLEntry.SmallResultData.nGameTatolGold = buffer:ReadInt32()
        SGXMLEntry.SmallResultData.nIconType = buffer:ReadInt32()
        SGXMLEntry.SmallResultData.nIconTypeConut = buffer:ReadInt32()
        SGXMLEntry.SmallResultData.nIconType4 = {};
        for i = 1, SGXML_DataConfig.SMALLIMGCOUNT do
            SGXMLEntry.SmallResultData.nIconType4[i] = buffer:ReadInt32()
        end
        SGXMLEntry.SmallResultData.nGameGold = buffer:ReadInt32()

        SGXMLEntry.SmallResultData.nGameEnd = buffer:ReadByte()
        SGXMLEntry.SmallResultData.nLineGold = buffer:ReadInt32()
        SGXMLEntry.smallGameCount = SGXMLEntry.SmallResultData.nSmallGameConut;
        logTable(SGXMLEntry.SmallResultData);
        SGXML_SmallGame.Start();--开始小游戏
    elseif sid == self.LABA_MSG_SC_START then
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
        SGXMLEntry.ResetState();
    elseif sid == self.LABA_MSG_SC_UPDATE_PRIZE_POOL then
        --奖池数据
        local jackpot = buffer:ReadInt32();
        --log("彩金：" .. jackpot);
        if SGXML_Caijin.CaijinGold > 0 then
            if jackpot <= SGXML_Caijin.currentCaijin then
                SGXML_Caijin.currentCaijin = jackpot;
            end
        else
            SGXML_Caijin.currentCaijin = jackpot;
        end
        SGXML_Caijin.CaijinGold = jackpot;
    end
end
function SGXML_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    SGXMLEntry.SceneData.freeNumber = buffer:ReadInt32();
    SGXMLEntry.SceneData.bet = buffer:ReadInt32();
    SGXMLEntry.SceneData.chipNum = buffer:ReadInt32();
    SGXMLEntry.SceneData.chipList = {};
    for i = 1, SGXMLEntry.SceneData.chipNum do
        table.insert(SGXMLEntry.SceneData.chipList, buffer:ReadInt32());
    end
    SGXMLEntry.SceneData.nFreeGameCotTotal = buffer:ReadInt32();
    SGXMLEntry.SceneData.nFreeGameGold = buffer:ReadInt32();
    SGXMLEntry.SceneData.nSmallCount = buffer:ReadInt32();
    if SGXMLEntry.SceneData.bet == 0 then
        SGXMLEntry.SceneData.bet = SGXMLEntry.SceneData.chipList[1];
    end
    SGXMLEntry.totalFreeCount = SGXMLEntry.SceneData.nFreeGameCotTotal;
    logTable(SGXMLEntry.SceneData);
    SGXMLEntry.smallGameCount = SGXMLEntry.SceneData.nSmallCount;
    SGXMLEntry.InitPanel();
end
function SGXML_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    SGXML_Caijin.REQCJ();
end
function SGXML_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function SGXML_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function SGXML_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    --TODO 设置金币数量
end
function SGXML_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
end
function SGXML_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    --destroy(SGXMLEntry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function SGXML_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function SGXML_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function SGXML_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function SGXML_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end