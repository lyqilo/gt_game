-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
--g_sSlotModuleNum = "FLMEntry/CaiShenDao/";

--require(g_sSlotModuleNum .. "Slot/SlotBase")

FLM_Network = {};
local self = FLM_Network;

self.SUB_CS_GAME_START = 0  --启动游戏

self.SUB_SC_GAME_START = 0    --发送奖池
self.SUB_SC_GAME_OVER = 1;       --结算信息
self.SUB_SC_UPDATE_PRIZE_POOL = 5;          --游戏结束

function FLM_Network.AddMessage()
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
function FLM_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function FLM_Network.LoginGame()
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
function FLM_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function FLM_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
function FLM_Network.StartGame()
    FLMEntry.isRoll = true;
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(FLMEntry.CurrentChip);
    Network.Send(MH.MDM_GF_GAME, FLM_Network.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
end
function FLM_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));
    --游戏消息
    if FLM_Network.SUB_SC_GAME_OVER == sid then
        --结算数据
        FLMEntry.ResultData.ImgTable = {};
        for i = 1, FLM_DataConfig.ALLIMGCOUNT do
            table.insert(FLMEntry.ResultData.ImgTable, buffer:ReadByte());
        end

        FLMEntry.ResultData.GoldNum = {};--开奖的时候 如果是金币图标上面要显示数字和文字
        for i = 1, FLM_DataConfig.ALLIMGCOUNT do
            table.insert(FLMEntry.ResultData.GoldNum, buffer:ReadUInt32());
        end

        FLMEntry.ResultData.LineTypeTable = {};
        for i = 1, FLM_DataConfig.ALLLINECOUNT do
            local tempLine = {};
            for j = 1, FLM_DataConfig.COLUMNCOUNT do
                table.insert(tempLine, buffer:ReadByte());
            end
            table.insert(FLMEntry.ResultData.LineTypeTable, tempLine);
        end

        FLMEntry.ResultData.fuType = {};--大幅 幅满 小幅
        for i = 1, 3 do
            table.insert(FLMEntry.ResultData.fuType, buffer:ReadUInt32());
        end

        FLMEntry.ResultData.WinScore = tonumber(buffer:ReadInt64Str());
        FLMEntry.ResultData.FreeCount = buffer:ReadByte();
        FLMEntry.ResultData.GoldModeNum = buffer:ReadByte();
        FLMEntry.ResultData.allOpenRate = tonumber(buffer:ReadInt64Str());
        FLMEntry.freeCount=FLMEntry.ResultData.FreeCount;
        logTable(FLMEntry.ResultData);
        FLMEntry.Roll();
    elseif FLM_Network.SUB_SC_UPDATE_PRIZE_POOL == sid then
        --奖池数据
        local jackpot = buffer:ReadUInt32();
        if FLM_Caijin.CaijinGold > 0 then
            if jackpot <= FLM_Caijin.currentCaijin then
                FLM_Caijin.currentCaijin = jackpot;
            else
                FLM_Caijin.caijinCha = jackpot - FLM_Caijin.currentCaijin;
            end
        else
            FLM_Caijin.currentCaijin = math.ceil(jackpot / 2);
            FLM_Caijin.caijinCha = math.ceil(jackpot / 2);
        end
        FLM_Caijin.CaijinGold = jackpot;
    end
end
function FLM_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    FLMEntry.SceneData.bet = buffer:ReadInt32();
    FLMEntry.SceneData.chipList = {};
    for i = 1, FLM_DataConfig.CHIPLISTCOUNT do
        table.insert(FLMEntry.SceneData.chipList, buffer:ReadUInt32());
    end
    if FLMEntry.SceneData.bet == 0 then
        FLMEntry.SceneData.bet = FLMEntry.SceneData.chipList[1];
    end
    FLMEntry.SceneData.fuTimes = {};
    for i = 1, 2 do
        --大福小福倍数
        table.insert(FLMEntry.SceneData.fuTimes, buffer:ReadUInt32());
    end
    FLMEntry.SceneData.ImgTable = {};
    for i = 1, FLM_DataConfig.ALLIMGCOUNT do
        table.insert(FLMEntry.SceneData.ImgTable, buffer:ReadByte());
    end
    FLMEntry.ResultData.ImgTable = FLMEntry.SceneData.ImgTable;

    FLMEntry.SceneData.GoldNum = {};
    for i = 1, FLM_DataConfig.ALLIMGCOUNT do
        table.insert(FLMEntry.SceneData.GoldNum, buffer:ReadUInt32());
    end
    FLMEntry.ResultData.GoldNum = FLMEntry.SceneData.GoldNum;

    FLMEntry.SceneData.LineTypeTable = {};
    for i = 1, FLM_DataConfig.ALLLINECOUNT do
        local tempLine = {};
        for j = 1, FLM_DataConfig.COLUMNCOUNT do
            table.insert(tempLine, buffer:ReadByte());
        end
        table.insert(FLMEntry.SceneData.LineTypeTable, tempLine);
    end
    FLMEntry.ResultData.LineTypeTable = FLMEntry.SceneData.LineTypeTable;

    FLMEntry.SceneData.fuType = {};
    for i = 1, 3 do
        table.insert(FLMEntry.SceneData.fuType, buffer:ReadUInt32());
    end
    FLMEntry.ResultData.fuType = FLMEntry.SceneData.fuType;

    FLMEntry.SceneData.WinScore = tonumber(buffer:ReadInt64Str());
    FLMEntry.ResultData.WinScore = FLMEntry.SceneData.WinScore;
    FLMEntry.SceneData.FreeCount = buffer:ReadByte();
    FLMEntry.ResultData.FreeCount = FLMEntry.SceneData.FreeCount;
    FLMEntry.SceneData.GoldModeNum = buffer:ReadByte();
    FLMEntry.ResultData.GoldModeNum = FLMEntry.SceneData.GoldModeNum;
    FLMEntry.SceneData.allOpenRate = tonumber(buffer:ReadInt64Str());
    FLMEntry.ResultData.allOpenRate = FLMEntry.SceneData.allOpenRate;

    logTable(FLMEntry.SceneData);
    FLMEntry.InitPanel();
end
function FLM_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    FLM_Caijin.REQCJ();
end
function FLM_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function FLM_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function FLM_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    --TODO 设置金币数量
end
function FLM_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
end
function FLM_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    --destroy(FLMEntry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function FLM_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function FLM_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function FLM_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function FLM_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end