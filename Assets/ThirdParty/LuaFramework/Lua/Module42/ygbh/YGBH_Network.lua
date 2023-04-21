-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
--g_sSlotModuleNum = "Module27/CaiShenDao/";

--require(g_sSlotModuleNum .. "Slot/SlotBase")

YGBH_Network = {};
local self = YGBH_Network;

self.SUB_CS_GAME_START = 1  --启动游戏
self.SUB_CS_CHOSE_FREEGAME_TYPE = 8        --选择免费游戏类型
self.SUB_CS_LITTLE_GAME = 9 --开始小游戏

self.SUB_SC_BET_FAIL = 2    --下注失败
self.SUB_SC_RESULTS_INFO = 3;       --游戏结算
self.SUB_SC_SMALLGAME = 11;          --小游戏数据
self.SUB_SC_SMALLGAMEEND = 12;          --小游戏结果

function YGBH_Network.AddMessage()
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
function YGBH_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function YGBH_Network.LoginGame()
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
function YGBH_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function YGBH_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
function YGBH_Network.StartGame()
    --开始游戏
    YGBHEntry.isRoll = true;
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(YGBH_DataConfig.ALLLINECOUNT);
    buffer:WriteUInt32(YGBHEntry.CurrentChip);
    Network.Send(MH.MDM_GF_GAME, YGBH_Network.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
end
function YGBH_Network.SelectFree()
    --选择免费游戏类型
    if YGBHEntry.ResultData.m_FreeType == 0 then
        return ;
    end
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(YGBHEntry.ResultData.m_FreeType);
    Network.Send(MH.MDM_GF_GAME, YGBH_Network.SUB_CS_CHOSE_FREEGAME_TYPE, buffer, gameSocketNumber.GameSocket);
end
function YGBH_Network.StartSmallGame()
    --开始转盘小游戏
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_GF_GAME, YGBH_Network.SUB_CS_LITTLE_GAME, buffer, gameSocketNumber.GameSocket);
end
function YGBH_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));
    --游戏消息
    if YGBH_Network.SUB_SC_BET_FAIL == sid then
        --下注失败
        local statusCode = buffer:ReadInt32();
        if statusCode == 1 then
            MessageBox.CreatGeneralTipsPanel("Insufficient gold coins");
        elseif statusCode == 2 then
            MessageBox.CreatGeneralTipsPanel("下注失败");--下注错误
        end
    elseif YGBH_Network.SUB_SC_RESULTS_INFO == sid then
        --结算数据
        YGBHEntry.ResultData.ImgTable = {};
        for i = 1, YGBH_DataConfig.ALLIMGCOUNT do
            table.insert(YGBHEntry.ResultData.ImgTable, buffer:ReadByte());
        end
        YGBHEntry.ResultData.LineTypeTable = {};
        for i = 1, YGBH_DataConfig.ALLLINECOUNT do
            local line = {};
            for j = 1, YGBH_DataConfig.COLUMNCOUNT do
                table.insert(line, buffer:ReadByte());
            end
            table.insert(YGBHEntry.ResultData.LineTypeTable, line);
        end
        YGBHEntry.ResultData.m_nWinPeiLv = buffer:ReadInt32();
        YGBHEntry.ResultData.m_szCurrGold = int64.tonum2(buffer:ReadInt64Str());
        YGBHEntry.ResultData.WinScore = buffer:ReadInt32();
        YGBHEntry.ResultData.m_nTotalWinGold = buffer:ReadInt32();
        YGBHEntry.ResultData.m_nSmallGame = buffer:ReadInt32();
        YGBHEntry.ResultData.FreeCount = buffer:ReadInt32();
        YGBHEntry.ResultData.m_nPrizePoolGold = buffer:ReadInt32();
        YGBHEntry.ResultData.m_nMultiple = buffer:ReadInt32();
        YGBHEntry.ResultData.m_nPrizePoolPercentMax = buffer:ReadInt32();
        YGBHEntry.ResultData.m_nSmallNnm = buffer:ReadInt32();
        YGBHEntry.ResultData.m_nTotalFreeTimes = buffer:ReadInt32();
        YGBHEntry.ResultData.m_nPrizePoolWildGold = buffer:ReadInt32();
        YGBHEntry.ResultData.m_FreeType = buffer:ReadByte();
        YGBHEntry.ResultData.m_nIconLie = {};
        for i = 1, YGBH_DataConfig.COLUMNCOUNT do
            table.insert(YGBHEntry.ResultData.m_nIconLie, buffer:ReadByte());
        end
        logTable(YGBHEntry.ResultData);
        YGBHEntry.freeCount = YGBHEntry.ResultData.FreeCount;
        YGBHEntry.Roll();
    elseif YGBH_Network.SUB_SC_SMALLGAME == sid then
        --小游戏数据
        YGBHEntry.SceneData.smallGameTrack = {};
        local count = 0;
        for i = 1, 8 do
            local isnew = buffer:ReadInt32();
            if isnew ~= 0 then
                count = count + 1;
            end
            table.insert(YGBHEntry.SceneData.smallGameTrack, isnew);
        end
        logTable(YGBHEntry.SceneData.smallGameTrack);
        if count > YGBHEntry.smallSPCount then
            YGBHEntry.hasNewSP = true;
            YGBHEntry.smallSPCount = count;
        end
    elseif YGBH_Network.SUB_SC_SMALLGAMEEND == sid then
        --小游戏结果
        YGBHEntry.SmallGameData.nIndex = buffer:ReadByte();
        YGBHEntry.SmallGameData.nGold = buffer:ReadInt32();
        YGBHEntry.smallWinIndex = YGBHEntry.SmallGameData.nIndex;
        logTable(YGBHEntry.SmallGameData);
        YGBHEntry.RollZP();
    end
end
function YGBH_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    YGBHEntry.SceneData.freeNumber = buffer:ReadInt32();
    YGBHEntry.SceneData.bet = buffer:ReadInt32();
    YGBHEntry.SceneData.nGainPeilv = buffer:ReadInt32();
    YGBHEntry.SceneData.nBetonCount = buffer:ReadInt32();
    YGBHEntry.SceneData.chipList = {};
    for i = 1, YGBH_DataConfig.CHIPLISTCOUNT do
        table.insert(YGBHEntry.SceneData.chipList, buffer:ReadInt32());
    end
    YGBHEntry.SceneData.nFreeIcon_lie = {};
    for i = 1, YGBH_DataConfig.COLUMNCOUNT do
        table.insert(YGBHEntry.SceneData.nFreeIcon_lie, buffer:ReadByte());
    end
    YGBHEntry.SceneData.nFreeType = buffer:ReadInt32();
    YGBHEntry.SceneData.smallGameTrack = {};
    for i = 1, YGBH_DataConfig.SMALLCHECKNUM do
        table.insert(YGBHEntry.SceneData.smallGameTrack, buffer:ReadInt32());
    end
    logTable(YGBHEntry.SceneData);
    YGBHEntry.InitPanel();
end
function YGBH_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    YGBH_Caijin.REQCJ();
end
function YGBH_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function YGBH_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function YGBH_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    --TODO 设置金币数量
end
function YGBH_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
end
function YGBH_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    --destroy(YGBHEntry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function YGBH_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function YGBH_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function YGBH_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function YGBH_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end