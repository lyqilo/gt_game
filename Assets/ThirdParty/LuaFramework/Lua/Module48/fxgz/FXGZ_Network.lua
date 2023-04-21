-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion

--require(g_sSlotModuleNum .. "Slot/SlotBase")

FXGZ_Network = {};
local self = FXGZ_Network;

self.SUB_CS_GAME_START = 1  --启动游戏
self.SUB_CS_FREE_GAME = 2  --bonus游戏选择

self.SUB_SC_GAME_START = 0;--游戏开始
self.SUB_SC_FREE_GAME = 1;--小游戏结算
self.SUB_SC_BET_FAIL = 2;--游戏结算
self.SUB_SC_UPDATE_JACKPOT = 3;--奖池

function FXGZ_Network.AddMessage()
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
function FXGZ_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function FXGZ_Network.LoginGame()
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
function FXGZ_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function FXGZ_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
function FXGZ_Network.StartGame()
    if FXGZEntry.myGold < FXGZEntry.CurrentChip * FXGZ_DataConfig.ALLLINECOUNT and not FXGZEntry.isFreeGame then
        MessageBox.CreatGeneralTipsPanel("Insufficient gold coins, please recharge");
        FXGZEntry.ResetState();
        return ;
    end
    FXGZEntry.isRoll = true;
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(FXGZEntry.CurrentChip);
    Network.Send(MH.MDM_GF_GAME, FXGZ_Network.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
end
function FXGZ_Network.StartSmallGame()
    FXGZEntry.isRoll = true;
    local buffer = ByteBuffer.New();
    log("小游戏下标：" .. FXGZEntry.currentSelectBonus);
    buffer:WriteByte(FXGZEntry.currentSelectBonus);
    Network.Send(MH.MDM_GF_GAME, FXGZ_Network.SUB_CS_FREE_GAME, buffer, gameSocketNumber.GameSocket);
end
function FXGZ_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));
    --游戏消息
    if FXGZ_Network.SUB_SC_GAME_START == sid then
        --结算数据
        log("结算")
        FXGZEntry.ResultData.ImgTable = {};
        for i = 1, FXGZ_DataConfig.ALLIMGCOUNT do
            table.insert(FXGZEntry.ResultData.ImgTable, buffer:ReadByte());
        end
        FXGZEntry.ResultData.LineTypeTable = {};
        for i = 1, FXGZ_DataConfig.ALLLINECOUNT do
            local temp = {};
            for j = 1, FXGZ_DataConfig.COLUMNCOUNT do
                table.insert(temp, buffer:ReadByte());
            end
            table.insert(FXGZEntry.ResultData.LineTypeTable, temp);
        end
        FXGZEntry.ResultData.WinScore = buffer:ReadInt32();
        FXGZEntry.ResultData.FreeCount = buffer:ReadInt32();
        FXGZEntry.ResultData.FreeType = buffer:ReadByte();
        FXGZEntry.ResultData.m_nWinPeiLv = buffer:ReadByte();
        FXGZEntry.ResultData.cbHitBouns = buffer:ReadByte();
        logTable(FXGZEntry.ResultData);
        FXGZEntry.freeCount = FXGZEntry.ResultData.FreeCount;
        FXGZEntry.Roll();
    elseif sid == self.SUB_SC_FREE_GAME then
        FXGZEntry.SmallResultData.cbResCode = buffer:ReadByte();
        FXGZEntry.SmallResultData.nFreeCount = buffer:ReadInt32()
        logTable(FXGZEntry.SmallResultData);
        FXGZ_SmallGame.StartSmallGame();--开始小游戏
    elseif sid == self.SUB_SC_BET_FAIL then
        local tag = buffer:ReadByte();
        if tag == 1 then
            MessageBox.CreatGeneralTipsPanel("金币不足");
        elseif tag == 2 then
            MessageBox.CreatGeneralTipsPanel("下注失败");
        end
        FXGZEntry.ResetState();
    elseif sid == self.SUB_SC_UPDATE_JACKPOT then
        --奖池数据
        local jackpot = tonumber(buffer:ReadInt64Str());
        log("彩金：" .. jackpot);
        if FXGZ_Caijin.CaijinGold > 0 then
            if jackpot <= FXGZ_Caijin.currentCaijin then
                FXGZ_Caijin.currentCaijin = jackpot;
            end
        end
        FXGZ_Caijin.CaijinGold = jackpot;
    end
end
function FXGZ_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    FXGZEntry.SceneData.freeNumber = buffer:ReadInt32();
    FXGZEntry.SceneData.bet = buffer:ReadInt32();
    FXGZEntry.SceneData.chipNum = buffer:ReadInt32();
    FXGZEntry.SceneData.chipList = {};
    for i = 1, FXGZ_DataConfig.CHIPLISTCOUNT do
        table.insert(FXGZEntry.SceneData.chipList, buffer:ReadInt32());
    end
    FXGZEntry.SceneData.cbFreeType = buffer:ReadByte();
    FXGZEntry.SceneData.cbCurMul = buffer:ReadByte();
    FXGZEntry.SceneData.cbFreeGameIndex = {};
    for i = 1, 12 do
        table.insert(FXGZEntry.SceneData.cbFreeGameIndex, buffer:ReadByte());
    end
    FXGZEntry.SceneData.cbFreeGameIconCount = {};
    for i = 1, 4 do
        table.insert(FXGZEntry.SceneData.cbFreeGameIconCount, buffer:ReadByte());
    end
    if FXGZEntry.SceneData.bet == 0 then
        FXGZEntry.SceneData.bet = FXGZEntry.SceneData.chipList[1];
    end
    if FXGZEntry.SceneData.cbFreeType == 0 and FXGZEntry.SceneData.freeNumber > 0 then
        FXGZEntry.isReRollGame = true;
    else
        FXGZEntry.isReRollGame = false;        
    end
    logTable(FXGZEntry.SceneData);
    FXGZEntry.InitPanel();
end
function FXGZ_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    FXGZ_Caijin.REQCJ();
end
function FXGZ_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function FXGZ_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function FXGZ_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    --TODO 设置金币数量
end
function FXGZ_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
end
function FXGZ_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    --destroy(FXGZEntry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function FXGZ_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function FXGZ_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function FXGZ_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function FXGZ_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end