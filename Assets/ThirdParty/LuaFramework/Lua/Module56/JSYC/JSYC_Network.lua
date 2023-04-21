-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion

--require(g_sSlotModuleNum .. "Slot/SlotBase")

JSYC_Network = {};
local self = JSYC_Network;

self.SUB_CS_GAME_START = 0  --启动游戏

self.SUB_SC_RESULTS_INFO = 0;       --结算信息
self.SUB_SC_BET_ERR = 11;--错误信息

function JSYC_Network.AddMessage()
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
function JSYC_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function JSYC_Network.LoginGame()
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
function JSYC_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function JSYC_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
function JSYC_Network.StartGame()
    JSYCEntry.isRoll = true;
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(JSYCEntry.CurrentChip);
    Network.Send(MH.MDM_GF_GAME, JSYC_Network.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
end
function JSYC_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));
    --游戏消息
    if JSYC_Network.SUB_SC_RESULTS_INFO == sid then
        --结算数据
        JSYCEntry.ResultData.ImgTable = {};
        for i = 1, JSYC_DataConfig.ALLIMGCOUNT do
            table.insert(JSYCEntry.ResultData.ImgTable, buffer:ReadByte());
        end
        JSYCEntry.ResultData.LineTypeTable = {};
        for i = 1, #JSYC_DataConfig.IconTable do
            local tempTab = {
                cbIcon = 0,
                cbCount = 0,
                cbTemp1 = 0,
                cbTemp2 = 0,
                cbTemp3 = 0
            };
            tempTab.cbIcon = buffer:ReadByte();
            tempTab.cbCount = buffer:ReadByte();
            tempTab.cbTemp1 = buffer:ReadByte();
            tempTab.cbTemp2 = buffer:ReadByte();
            tempTab.cbTemp3 = buffer:ReadByte();
            table.insert(JSYCEntry.ResultData.LineTypeTable, tempTab);
        end
        JSYCEntry.ResultData.WinScore = buffer:ReadInt32();
        JSYCEntry.ResultData.FreeCount = buffer:ReadByte();
        JSYCEntry.ResultData.caiJin = buffer:ReadInt32();
        JSYCEntry.ResultData.cbChangeLine = buffer:ReadByte();
        logTable(JSYCEntry.ResultData);
        JSYCEntry.freeCount = JSYCEntry.ResultData.FreeCount;
        JSYCEntry.Roll();
    elseif sid == self.SUB_SC_BET_ERR then
        local tag = buffer:ReadByte();
        if tag == 1 then
            MessageBox.CreatGeneralTipsPanel("Insufficient gold coins");
        elseif tag == 2 then
            MessageBox.CreatGeneralTipsPanel("Wrong bet value");
        end
        JSYCEntry.ResetRoll();
    end
end
function JSYC_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    JSYCEntry.SceneData.bet = buffer:ReadInt32();
    JSYCEntry.SceneData.userGold = buffer:ReadInt32();
    JSYCEntry.SceneData.chipList = {};
    for i = 1, JSYC_DataConfig.CHIPLISTCOUNT do
        table.insert(JSYCEntry.SceneData.chipList, buffer:ReadInt32());
    end
    JSYCEntry.SceneData.freeNumber = buffer:ReadByte();
    JSYCEntry.SceneData.caiJin = buffer:ReadInt32();
    logTable(JSYCEntry.SceneData);
    JSYCEntry.InitPanel();
end
function JSYC_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    JSYC_Caijin.REQCJ();
end
function JSYC_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function JSYC_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function JSYC_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    --TODO 设置金币数量
end
function JSYC_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
end
function JSYC_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    --destroy(JSYCEntry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function JSYC_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function JSYC_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function JSYC_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function JSYC_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end