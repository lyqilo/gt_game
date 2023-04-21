-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion

--require(g_sSlotModuleNum .. "Slot/SlotBase")

JZSF_Network = {};
local self = JZSF_Network;

self.SUB_CS_GAME_START = 1  --启动游戏
self.LABA_MSG_CS_SMALL_GAME = 5  --免费选择

self.LABA_MSG_SC_START = 1;--游戏开始
self.LABA_MSG_SC_CHECKOUT = 2;--游戏结算
self.LABA_MSG_SC_FREEGAME_CONFIG = 11;--免费游戏

function JZSF_Network.AddMessage()
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
function JZSF_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function JZSF_Network.LoginGame()
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
function JZSF_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function JZSF_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
function JZSF_Network.StartGame()
    JZSFEntry.isRoll = true;
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(JZSF_DataConfig.ALLLINECOUNT);
    buffer:WriteUInt32(JZSFEntry.CurrentChip);
    Network.Send(MH.MDM_GF_GAME, JZSF_Network.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
end
function JZSF_Network.StartFreeGame()
    JZSFEntry.isRoll = true;
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(JZSFEntry.CurrentFreeIndex);
    Network.Send(MH.MDM_GF_GAME, JZSF_Network.LABA_MSG_CS_SMALL_GAME, buffer, gameSocketNumber.GameSocket);
end
function JZSF_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));
    --游戏消息
    if JZSF_Network.LABA_MSG_SC_CHECKOUT == sid then
        --结算数据
        JZSFEntry.ResultData.ImgTable = {};
        for i = 1, JZSF_DataConfig.ALLIMGCOUNT do
            table.insert(JZSFEntry.ResultData.ImgTable, buffer:ReadInt32());
        end
        JZSFEntry.ResultData.LineTypeTable = {};
        for i = 1, #JZSF_DataConfig.IconTable - 6 do
            local tempTab = {
                cbIcon = 0,
                cbCount = 0,
            };
            tempTab.cbIcon = buffer:ReadByte();
            tempTab.cbCount = buffer:ReadByte();
            table.insert(JZSFEntry.ResultData.LineTypeTable, tempTab);
        end
        JZSFEntry.ResultData.m_nWinPeiLv = buffer:ReadInt32();
        JZSFEntry.ResultData.m_nCurrGold = tonumber(buffer:ReadInt64Str());
        JZSFEntry.ResultData.WinScore = buffer:ReadInt32();
        JZSFEntry.ResultData.TotalWinScore = buffer:ReadInt32();
        JZSFEntry.ResultData.FreeCount = buffer:ReadInt32();
        JZSFEntry.ResultData.m_nMultiple = buffer:ReadInt32();
        JZSFEntry.ResultData.m_bFreeGame = buffer:ReadByte() == 1;
        JZSFEntry.ResultData.m_nFreeGamePeiLvLevel = buffer:ReadInt32();
        logTable(JZSFEntry.ResultData);
        JZSFEntry.freeCount = JZSFEntry.ResultData.FreeCount;
        JZSFEntry.Roll();
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
        JZSFEntry.ResetRoll();
    elseif sid == self.LABA_MSG_SC_FREEGAME_CONFIG then
        JZSFEntry.FreeData.nUserChoseIndex = buffer:ReadInt32();
        JZSFEntry.FreeData.nFreeCount = buffer:ReadInt32();
        JZSFEntry.FreeData.nFreeOddIndex = buffer:ReadInt32();
        JZSFEntry.CurrentFreeIndex = JZSFEntry.FreeData.nUserChoseIndex;
        logTable(JZSFEntry.FreeData);
        JZSFEntry.freeCount = JZSFEntry.FreeData.nFreeCount;
        JZSF_Result.ShowSelectFreeResultEffect();
    end
end
function JZSF_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    JZSFEntry.SceneData.freeNumber = buffer:ReadInt32();
    JZSFEntry.SceneData.bet = buffer:ReadInt32();
    JZSFEntry.SceneData.chipNum = buffer:ReadInt32();
    JZSFEntry.SceneData.chipList = {};
    for i = 1, JZSFEntry.SceneData.chipNum do
        table.insert(JZSFEntry.SceneData.chipList, buffer:ReadInt32());
    end
    JZSFEntry.SceneData.nFreeGameIndex = buffer:ReadInt32();
    JZSFEntry.SceneData.nFreeGameGold = buffer:ReadInt32();
    JZSFEntry.SceneData.bFreeGame = buffer:ReadByte() == 1;

    if JZSFEntry.SceneData.freeNumber>0 then
        JZSFEntry.SceneData.bFreeGame=true
    end

    if JZSFEntry.SceneData.bet == 0 then
        JZSFEntry.SceneData.bet = JZSFEntry.SceneData.chipList[1];
    end
    JZSFEntry.CurrentFreeIndex = JZSFEntry.SceneData.nFreeGameIndex;
    logTable(JZSFEntry.SceneData);
    JZSFEntry.InitPanel();
end
function JZSF_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    JZSF_Caijin.REQCJ();
end
function JZSF_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function JZSF_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function JZSF_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    --TODO 设置金币数量
end
function JZSF_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
end
function JZSF_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    --destroy(JZSFEntry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function JZSF_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function JZSF_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function JZSF_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function JZSF_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end