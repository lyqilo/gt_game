-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion

--require(g_sSlotModuleNum .. "Slot/SlotBase")

BQTP_Network = {};
local self = BQTP_Network;

self.SUB_CS_GAME_START = 1  --启动游戏

self.SUB_SC_BET_FAIL = 2;--游戏开始
self.SUB_SC_START_GAME = 102;--游戏结算

function BQTP_Network.AddMessage()
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
function BQTP_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function BQTP_Network.LoginGame()
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
function BQTP_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function BQTP_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
function BQTP_Network.StartGame()
    if BQTPEntry.myGold < BQTPEntry.CurrentChip * BQTP_DataConfig.ALLLINECOUNT and not BQTPEntry.isFreeGame then
        MessageBox.CreatGeneralTipsPanel("Insufficient gold coins, please recharge");
        BQTPEntry.IdleState();
        return ;
    end
    local buffer = ByteBuffer.New();
    buffer:WriteInt(BQTPEntry.CurrentChip);
    Network.Send(MH.MDM_GF_GAME, BQTP_Network.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
end
function BQTP_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));
    --游戏消息
    if self.SUB_SC_START_GAME == sid then
        --结算数据
        log("结算")
        BQTPEntry.ResultData.ImgTable = {};
        for i = 1, BQTP_DataConfig.ALLIMGCOUNT do
            table.insert(BQTPEntry.ResultData.ImgTable, buffer:ReadByte());
        end
        BQTPEntry.ResultData.LineTypeTable = {};
        for i = 1, BQTP_DataConfig.ALLIMGCOUNT do
            table.insert(BQTPEntry.ResultData.LineTypeTable, buffer:ReadByte());
        end
        BQTPEntry.ResultData.WinScore = buffer:ReadInt32();
        BQTPEntry.ResultData.FreeCount = buffer:ReadInt32();
        BQTPEntry.ResultData.cbRerun = buffer:ReadByte()
        BQTPEntry.ResultData.cbSpecialWild = buffer:ReadByte();
        logTable(BQTPEntry.ResultData);
        BQTPEntry.freeCount = BQTPEntry.ResultData.FreeCount;
        if BQTPEntry.ReRollCount > 0 then
            if BQTPEntry.isScene then
                BQTPEntry.Roll();
            else
                BQTP_Roll.ReRoll();
            end
        else
            BQTPEntry.Roll();
        end
        if BQTPEntry.ReRollCount <= 0 then
            BQTP_Result.totalFreeGold = 0;
        end
        BQTPEntry.isScene = false;
        BQTPEntry.ReRollCount = BQTPEntry.ResultData.cbRerun;
    elseif sid == self.SUB_SC_BET_FAIL then
        local tag = buffer:ReadByte();
        log(tag)
        if tag == 0 then
            MessageBox.CreatGeneralTipsPanel("Insufficient gold coins");
        else
            MessageBox.CreatGeneralTipsPanel("下注失败");
        end
        BQTPEntry.IdleState();
    end
end
function BQTP_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    BQTPEntry.SceneData.freeNumber = buffer:ReadInt32();
    BQTPEntry.SceneData.bet = buffer:ReadInt32();
    BQTPEntry.SceneData.chipNum = buffer:ReadInt32();
    BQTPEntry.SceneData.chipList = {};
    for i = 1, BQTP_DataConfig.CHIPLISTCOUNT do
        table.insert(BQTPEntry.SceneData.chipList, buffer:ReadInt32());
    end
    BQTPEntry.SceneData.cbRerun = buffer:ReadByte();
    if BQTPEntry.SceneData.bet == 0 then
        BQTPEntry.SceneData.bet = BQTPEntry.SceneData.chipList[1];
    end
    BQTPEntry.freeCount = BQTPEntry.SceneData.freeNumber;
    BQTPEntry.ReRollCount = BQTPEntry.SceneData.cbRerun;
    BQTPEntry.isScene = true;
    logTable(BQTPEntry.SceneData);
    BQTPEntry.InitPanel();
end
function BQTP_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    BQTP_Caijin.REQCJ();
end
function BQTP_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function BQTP_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function BQTP_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    --TODO 设置金币数量
end
function BQTP_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
end
function BQTP_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    --destroy(BQTPEntry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function BQTP_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function BQTP_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function BQTP_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function BQTP_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end