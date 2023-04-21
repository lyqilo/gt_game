-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
g_sSlotModuleNum = "Module27/CaiShenDao/";

--require(g_sSlotModuleNum .. "Slot/SlotBase")

Module27_Network = {};
local self = Module27_Network;

self.SUB_CS_GAME_START = 0  --启动游戏
self.SUB_CS_GAME_END = 1        --游戏结束
self.SUB_CS_USER_INFO = 2 --用户列表
self.SUB_CS_JACKPOT = 3;

self.SUB_SC_SEND_ACCPOOL = 0    --发送奖池
self.SUB_SC_RESULTS_INFO = 1;       --结算信息
self.SUB_SC_USER_INFO = 2;          --用户列表

function Module27_Network.AddMessage()
    self.UnMessage();
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
function Module27_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function Module27_Network.LoginGame()
    --登录游戏
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(0);
    buffer:WriteUInt32(0);
    buffer:WriteUInt32(SCPlayerInfo._01dwUser_Id);
    buffer:WriteBytes(33, SCPlayerInfo._6wPassword);
    buffer:WriteBytes(100, Opcodes);
    buffer:WriteByte(0);
    buffer:WriteByte(0);
    log("1111111111111登录----------------")
    Network.Send(MH.MDM_GR_LOGON, MH.SUB_GR_LOGON_GAME, buffer, gameSocketNumber.GameSocket);
end
function Module27_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function Module27_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
function Module27_Network.StartGame()
    Module27.isRoll = true;
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(Module27.CurrentChip);
    Network.Send(MH.MDM_GF_GAME, Module27_Network.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
end
function Module27_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));
    --游戏消息
    if Module27_Network.SUB_SC_SEND_ACCPOOL == sid then
        --奖池数据
        local jackpot = tonumber(buffer:ReadInt64Str());
        if Module27_Caijin.CaijinGold > 0 then
            if jackpot <= Module27_Caijin.currentCaijin then
                Module27_Caijin.currentCaijin = jackpot;
            else
                Module27_Caijin.caijinCha = jackpot - Module27_Caijin.currentCaijin;
            end
        else
            Module27_Caijin.currentCaijin = math.ceil(jackpot / 2);
            Module27_Caijin.caijinCha = math.ceil(jackpot / 2);
        end
        Module27_Caijin.CaijinGold = jackpot;
    elseif Module27_Network.SUB_SC_RESULTS_INFO == sid then
        --结算数据
        Module27.ResultData.ImgTable = {};
        for i = 1, Module27_DataConfig.ALLIMGCOUNT do
            table.insert(Module27.ResultData.ImgTable, buffer:ReadByte());
        end
        Module27.ResultData.LineTypeTable = {};
        for i = 1, Module27_DataConfig.ALLLINECOUNT do
            local tempTab = {};
            for j = 1, Module27_DataConfig.COLUMNCOUNT do
                table.insert(tempTab, buffer:ReadByte());
            end
            table.insert(Module27.ResultData.LineTypeTable, tempTab);
        end
        Module27.ResultData.CaishenCount = buffer:ReadByte();
        Module27.ResultData.FreeCount = buffer:ReadByte();
        Module27.ResultData.GameType = buffer:ReadInt32();
        Module27.ResultData.WinScore = int64.tonum2(buffer:ReadInt64Str());
        Module27.ResultData.Temp = buffer:ReadInt32();
        Module27.ResultData.bLimitChip = buffer:ReadInt32();
        Module27.ResultData.iLimitChip = buffer:ReadInt32();
        Module27.ResultData.bSuperRate = buffer:ReadInt32() > 0;
        Module27.ResultData.bReturn = buffer:ReadInt32() > 0;--财神重转
        Module27.ResultData.AccountPool = int64.tonum2(buffer:ReadInt64Str());
        logTable(Module27.ResultData);
        Module27.Roll();
    end
end
function Module27_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    Module27.SceneData.bet = buffer:ReadInt32();
    Module27.SceneData.freeNumber = buffer:ReadByte();
    Module27.SceneData.chipList = {};
    for i = 1, Module27_DataConfig.CHIPLISTCOUNT do
        table.insert(Module27.SceneData.chipList, buffer:ReadInt32());
    end
    Module27.SceneData.caishenRate = {};
    for i = 1, Module27_DataConfig.CAISHENCOUNT do
        table.insert(Module27.SceneData.caishenRate, buffer:ReadInt32());
    end
    Module27.SceneData.caishenGold = int64.tonum2(buffer:ReadInt64Str());
    Module27.SceneData.betLimitChip = buffer:ReadInt32();
    Module27.SceneData.iLimitChip = buffer:ReadInt32();
    Module27.SceneData.breturn = buffer:ReadInt32() > 0;
    Module27.SceneData.accountPool = int64.tonum2(buffer:ReadInt64Str());
    logTable(Module27.SceneData);
    Module27.InitPanel();
end
function Module27_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    Module27_Caijin.REQCJ();
end
function Module27_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function Module27_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function Module27_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    --TODO 设置金币数量
end
function Module27_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
end
function Module27_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    --destroy(Module27.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function Module27_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function Module27_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function Module27_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function Module27_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end