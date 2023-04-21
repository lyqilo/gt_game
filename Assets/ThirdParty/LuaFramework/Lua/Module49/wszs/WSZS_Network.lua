-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion

--require(g_sSlotModuleNum .. "Slot/SlotBase")

WSZS_Network = {};
local self = WSZS_Network;
self.isGetResult = false;

self.SUB_CS_GAME_START = 1  --启动游戏

self.SUB_SC_RESULTS_INFO = 102;       --结算信息
self.SUB_SC_BET_ERR = 2;--错误信息

function WSZS_Network.AddMessage()
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
function WSZS_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function WSZS_Network.LoginGame()
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
function WSZS_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function WSZS_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
function WSZS_Network.StartGame()
    WSZSEntry.isRoll = true;
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(WSZSEntry.CurrentChip);
    Network.Send(MH.MDM_GF_GAME, WSZS_Network.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
end
function WSZS_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));
    --游戏消息
    if WSZS_Network.SUB_SC_RESULTS_INFO == sid then
        --结算数据
        WSZS_Network.isGetResult = true;
        WSZSEntry.ResultData.ImgTable = {};
        for i = 1, WSZS_DataConfig.ALLIMGCOUNT do
            table.insert(WSZSEntry.ResultData.ImgTable, buffer:ReadByte());
        end
        WSZSEntry.ResultData.LineTypeTable = {};
        for i = 1, WSZS_DataConfig.ALLIMGCOUNT do
            table.insert(WSZSEntry.ResultData.LineTypeTable, buffer:ReadByte());
        end
        WSZSEntry.ResultData.WinScore = buffer:ReadInt32();
        WSZSEntry.ResultData.ShiGold = buffer:ReadInt32();
        WSZSEntry.ResultData.FreeCount = buffer:ReadInt32();
        WSZSEntry.ResultData.mianjuCount = {};
        for i = 1, WSZS_DataConfig.MIANJUCOUNT + 1 do
            table.insert(WSZSEntry.ResultData.mianjuCount, buffer:ReadInt32());
        end
        logTable(WSZSEntry.ResultData);
        WSZSEntry.freeCount = WSZSEntry.ResultData.FreeCount;
        WSZSEntry.Roll();
    elseif sid == self.SUB_SC_BET_ERR then
        local tag = buffer:ReadByte();
        if tag == 1 then
            MessageBox.CreatGeneralTipsPanel("Not enough gold");
        elseif tag == 2 then
            MessageBox.CreatGeneralTipsPanel("Wrong bet value");
        end
        WSZSEntry.ResetRoll();
    end
end
function WSZS_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    WSZSEntry.SceneData.freeNumber = buffer:ReadInt32();
    WSZSEntry.SceneData.bet = buffer:ReadInt32();
    WSZSEntry.SceneData.chipCount = buffer:ReadInt32();
    WSZSEntry.SceneData.chipList = {};
    for i = 1, 10 do
        table.insert(WSZSEntry.SceneData.chipList, buffer:ReadInt32());
    end
    WSZSEntry.SceneData.mianjuCount = {};
    for i = 1, WSZS_DataConfig.MIANJUCOUNT do
        table.insert(WSZSEntry.SceneData.mianjuCount, buffer:ReadInt32());
    end
    logTable(WSZSEntry.SceneData);
    WSZSEntry.InitPanel();
end
function WSZS_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    WSZS_Caijin.REQCJ();
end
function WSZS_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function WSZS_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function WSZS_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    --TODO 设置金币数量
end
function WSZS_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
end
function WSZS_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    --destroy(WSZSEntry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function WSZS_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function WSZS_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function WSZS_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function WSZS_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end