-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion

--require(g_sSlotModuleNum .. "Slot/SlotBase")

XMZZ_Network = {};
local self = XMZZ_Network;

self.SUB_CS_GAME_START = 1  --启动游戏

self.SUB_SC_START_GAME = 0;--游戏结算
self.SUB_SC_BET_FAIL = 2;--游戏开始
self.SUB_SC_UPDATE_PRIZE_POOL = 3;--奖池分数

function XMZZ_Network.AddMessage()
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
function XMZZ_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function XMZZ_Network.LoginGame()
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
function XMZZ_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function XMZZ_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
function XMZZ_Network.StartGame()
    if XMZZEntry.myGold < XMZZEntry.CurrentChip * XMZZ_DataConfig.ALLLINECOUNT and not XMZZEntry.isFreeGame then
        MessageBox.CreatGeneralTipsPanel("Insufficient gold coins, please recharge");
        XMZZEntry.IdleState();
        return ;
    end
    local buffer = ByteBuffer.New();
    buffer:WriteInt(XMZZEntry.CurrentChip);
    Network.Send(MH.MDM_GF_GAME, XMZZ_Network.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
end
function XMZZ_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));
    --游戏消息
    if self.SUB_SC_START_GAME == sid then
        --结算数据
        log("结算")
        XMZZEntry.ResultData.ImgTable = {};
        for i = 1, XMZZ_DataConfig.ALLIMGCOUNT do
            table.insert(XMZZEntry.ResultData.ImgTable, buffer:ReadByte());
        end
        XMZZEntry.ResultData.LineTypeTable = {};
        for i = 1, XMZZ_DataConfig.ALLLINECOUNT do
            local hits = {};
            for j = 1, XMZZ_DataConfig.COLUMNCOUNT do
                table.insert(hits, buffer:ReadByte());
            end
            table.insert(XMZZEntry.ResultData.LineTypeTable, hits);
        end
        XMZZEntry.ResultData.WinScore = buffer:ReadInt32();
        XMZZEntry.ResultData.FreeCount = buffer:ReadInt32();
        XMZZEntry.ResultData.nFreeType = buffer:ReadInt32()
        logTable(XMZZEntry.ResultData);
        XMZZEntry.freeCount = XMZZEntry.ResultData.FreeCount;
        XMZZEntry.freeType = XMZZEntry.ResultData.nFreeType;
        XMZZEntry.isScene = false;
        XMZZEntry.Roll()
    elseif sid == self.SUB_SC_BET_FAIL then
        local tag = buffer:ReadByte();
        log(tag)
        if tag == 0 then
            MessageBox.CreatGeneralTipsPanel("Insufficient gold coins");
        else
            MessageBox.CreatGeneralTipsPanel("下注失败");
        end
        XMZZEntry.IdleState();
    elseif sid == self.SUB_SC_UPDATE_PRIZE_POOL then
        --奖池数据
        local jackpot = buffer:ReadInt32();
        log("彩金：" .. jackpot);
        if XMZZ_Caijin.CaijinGold > 0 then
            if jackpot <= XMZZ_Caijin.currentCaijin then
                XMZZ_Caijin.currentCaijin = jackpot;
            end
        else
            XMZZ_Caijin.currentCaijin = jackpot;
        end
        XMZZ_Caijin.CaijinGold = jackpot;
    end
end
function XMZZ_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    XMZZEntry.SceneData.freeNumber = buffer:ReadInt32();
    XMZZEntry.SceneData.bet = buffer:ReadInt32();
    XMZZEntry.SceneData.chipNum = buffer:ReadInt32();
    XMZZEntry.SceneData.chipList = {};
    for i = 1, XMZZ_DataConfig.CHIPLISTCOUNT do
        table.insert(XMZZEntry.SceneData.chipList, buffer:ReadInt32());
    end
    if XMZZEntry.SceneData.bet == 0 then
        XMZZEntry.SceneData.bet = XMZZEntry.SceneData.chipList[1];
    end
    XMZZEntry.SceneData.cbColWild = {};
    for i = 1, XMZZ_DataConfig.COLUMNCOUNT do
        table.insert(XMZZEntry.SceneData.cbColWild, buffer:ReadByte());
    end
    XMZZEntry.SceneData.freeType = buffer:ReadInt32();
    XMZZEntry.freeCount = XMZZEntry.SceneData.freeNumber;
    XMZZEntry.freeType = XMZZEntry.SceneData.freeType;
    logTable(XMZZEntry.SceneData);
    XMZZEntry.InitPanel();
end
function XMZZ_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    XMZZ_Caijin.REQCJ();
end
function XMZZ_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function XMZZ_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function XMZZ_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    --TODO 设置金币数量
end
function XMZZ_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
end
function XMZZ_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    --destroy(XMZZEntry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function XMZZ_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function XMZZ_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function XMZZ_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function XMZZ_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end