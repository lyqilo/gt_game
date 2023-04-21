-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion

--require(g_sSlotModuleNum .. "Slot/SlotBase")

LGDDY_Network = {};
local self = LGDDY_Network;

self.SUB_CS_GAME_START = 1  --启动游戏
self.LABA_MSG_CS_SMALL_GAME = 5  --开始小游戏

self.LABA_MSG_SC_START = 1;--游戏开始
self.LABA_MSG_SC_CHECKOUT = 2;--游戏结算
self.LABA_MSG_SC_FREEGAME_CONFIG = 11;--免费游戏
self.LABA_MSG_SC_SMALL_GAME = 6;--小游戏结算
self.LABA_MSG_SC_UPDATE_PRIZE_POOL = 8;--奖池

function LGDDY_Network.AddMessage()
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
function LGDDY_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function LGDDY_Network.LoginGame()
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
function LGDDY_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function LGDDY_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
function LGDDY_Network.StartGame()
    if LGDDYEntry.myGold < LGDDYEntry.CurrentChip * LGDDY_DataConfig.ALLLINECOUNT and not LGDDYEntry.isFreeGame then
        MessageBox.CreatGeneralTipsPanel("Insufficient gold coins, please recharge");
        LGDDYEntry.ResetState();
        return ;
    end
    LGDDYEntry.isRoll = true;
    LGDDYEntry.WinDesc.text = "Good luck next time";
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(LGDDY_DataConfig.ALLLINECOUNT);
    buffer:WriteUInt32(LGDDYEntry.CurrentChip);
    Network.Send(MH.MDM_GF_GAME, LGDDY_Network.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
end
function LGDDY_Network.StartSmallGame()
    LGDDYEntry.isRoll = true;
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(LGDDYEntry.CurrentChip);
    Network.Send(MH.MDM_GF_GAME, LGDDY_Network.LABA_MSG_CS_SMALL_GAME, buffer, gameSocketNumber.GameSocket);
end
function LGDDY_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));
    --游戏消息
    if LGDDY_Network.LABA_MSG_SC_CHECKOUT == sid then
        --结算数据
        log("结算")
        LGDDYEntry.ResultData.ImgTable = {};
        for i = 1, LGDDY_DataConfig.ALLIMGCOUNT do
            table.insert(LGDDYEntry.ResultData.ImgTable, buffer:ReadInt32());
        end
        LGDDYEntry.ResultData.LineTypeTable = {};
        for i = 1, LGDDY_DataConfig.ALLLINECOUNT do
            table.insert(LGDDYEntry.ResultData.LineTypeTable, buffer:ReadInt32());
        end
        LGDDYEntry.ResultData.m_nWinPeiLv = buffer:ReadInt32();
        LGDDYEntry.ResultData.m_nCurrGold = tonumber(buffer:ReadInt64Str());
        LGDDYEntry.ResultData.WinScore = buffer:ReadInt32();
        LGDDYEntry.ResultData.TotalWinScore = buffer:ReadInt32();
        LGDDYEntry.ResultData.FreeCount = buffer:ReadInt32();
        LGDDYEntry.ResultData.m_nMultiple = buffer:ReadInt32();
        LGDDYEntry.ResultData.m_nJackPotValue = buffer:ReadInt32();
        LGDDYEntry.ResultData.m_bSmallGame = buffer:ReadInt32();
        logTable(LGDDYEntry.ResultData);
        LGDDYEntry.freeCount = LGDDYEntry.ResultData.FreeCount;
        LGDDYEntry.smallGameCount = LGDDYEntry.ResultData.m_bSmallGame;
        if LGDDYEntry.totalFreeCount == 0 then
            LGDDYEntry.totalFreeCount = LGDDYEntry.ResultData.FreeCount;
        end
        LGDDYEntry.Roll();
    elseif sid == self.LABA_MSG_SC_SMALL_GAME then
        LGDDYEntry.SmallResultData.nSmallGameTatolConut = buffer:ReadInt32();
        LGDDYEntry.SmallResultData.nSmallGameConut = buffer:ReadInt32()
        LGDDYEntry.SmallResultData.nGameTatolGold = buffer:ReadInt32()
        LGDDYEntry.SmallResultData.nIconType = buffer:ReadInt32()
        LGDDYEntry.SmallResultData.nIconTypeConut = buffer:ReadInt32()
        LGDDYEntry.SmallResultData.nIconType4 = {};
        for i = 1, LGDDY_DataConfig.SMALLIMGCOUNT do
            LGDDYEntry.SmallResultData.nIconType4[i] = buffer:ReadInt32()
        end
        LGDDYEntry.SmallResultData.nGameGold = buffer:ReadInt32()

        LGDDYEntry.SmallResultData.nGameEnd = buffer:ReadByte()
        LGDDYEntry.SmallResultData.nLineGold = buffer:ReadInt32()
        LGDDYEntry.smallGameCount = LGDDYEntry.SmallResultData.nSmallGameConut;
        logTable(LGDDYEntry.SmallResultData);
        LGDDY_SmallGame.Start();--开始小游戏
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
        LGDDYEntry.ResetState();
    elseif sid == self.LABA_MSG_SC_UPDATE_PRIZE_POOL then
        --奖池数据
        local jackpot = buffer:ReadInt32();
        log("彩金：" .. jackpot);
        if LGDDY_Caijin.CaijinGold > 0 then
            if jackpot <= LGDDY_Caijin.currentCaijin then
                LGDDY_Caijin.currentCaijin = jackpot;
            end
        else
            LGDDY_Caijin.currentCaijin = jackpot;
        end
        LGDDY_Caijin.CaijinGold = jackpot;
    end
end
function LGDDY_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    LGDDYEntry.SceneData.freeNumber = buffer:ReadInt32();
    LGDDYEntry.SceneData.bet = buffer:ReadInt32();
    LGDDYEntry.SceneData.chipNum = buffer:ReadInt32();
    LGDDYEntry.SceneData.chipList = {};
    for i = 1, LGDDYEntry.SceneData.chipNum do
        table.insert(LGDDYEntry.SceneData.chipList, buffer:ReadInt32());
    end
    LGDDYEntry.SceneData.nFreeGameCotTotal = buffer:ReadInt32();
    LGDDYEntry.SceneData.nFreeGameGold = buffer:ReadInt32();
    LGDDYEntry.SceneData.nSmallCount = buffer:ReadInt32();
    if LGDDYEntry.SceneData.bet == 0 then
        LGDDYEntry.SceneData.bet = LGDDYEntry.SceneData.chipList[1];
    end
    LGDDYEntry.totalFreeCount = LGDDYEntry.SceneData.nFreeGameCotTotal;
    logTable(LGDDYEntry.SceneData);
    LGDDYEntry.smallGameCount = LGDDYEntry.SceneData.nSmallCount;
    LGDDYEntry.InitPanel();
end
function LGDDY_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    LGDDY_Caijin.REQCJ();
end
function LGDDY_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function LGDDY_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function LGDDY_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    --TODO 设置金币数量
end
function LGDDY_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
end
function LGDDY_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    --destroy(LGDDYEntry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function LGDDY_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function LGDDY_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function LGDDY_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function LGDDY_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end