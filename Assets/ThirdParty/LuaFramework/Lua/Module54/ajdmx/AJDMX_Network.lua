-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
--g_sSlotModuleNum = "Module27/CaiShenDao/";

--require(g_sSlotModuleNum .. "Slot/SlotBase")

AJDMX_Network = {};
local self = AJDMX_Network;


self.SUB_CS_GAME_START  =   1
self.SUB_CS_SMALL_GAME  =   2
self.SUB_CS_MAX_CHANCE	=   3

self.SUB_SC_GAME_START	=   0
self.SUB_SC_SMALL_GAME	=   1
self.SUB_SC_BET_FAIL    =   2 
self.SUB_SC_MAX_CHANCE	=	3 


function AJDMX_Network.AddMessage()
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
function AJDMX_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function AJDMX_Network.LoginGame()
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
function AJDMX_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function AJDMX_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
function AJDMX_Network.StartGame()
    --开始游戏
    AJDMXEntry.isRoll = true;
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(AJDMXEntry.CurrentChip);
    logYellow("开始游戏=="..AJDMXEntry.CurrentChip)
    --buffer:WriteUInt32(AJDMXEntry.CurrentChip);
    Network.Send(MH.MDM_GF_GAME, AJDMX_Network.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
end
function AJDMX_Network.SelectFree()

end
function AJDMX_Network.StartSmallGame()
    -- --开始转盘小游戏
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_GF_GAME, AJDMX_Network.SUB_CS_SMALL_GAME, buffer, gameSocketNumber.GameSocket);
end

function AJDMX_Network.StartMaxGame(num)
    -- --开始转盘小游戏
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(num);
    Network.Send(MH.MDM_GF_GAME, AJDMX_Network.SUB_CS_MAX_CHANCE, buffer, gameSocketNumber.GameSocket);
end

function AJDMX_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));
    --游戏消息
    if AJDMX_Network.SUB_SC_BET_FAIL == sid then
        --下注失败
        local statusCode = buffer:ReadInt32();
        if statusCode == 1 then
            MessageBox.CreatGeneralTipsPanel("Insufficient gold coins");
            logYellow("Insufficient gold coins")
        elseif statusCode == 2 then
            logYellow("下注失败")
            MessageBox.CreatGeneralTipsPanel("下注失败");--下注错误
        end
        AJDMX_Result.CheckFree()
    elseif AJDMX_Network.SUB_SC_GAME_START == sid then
        --结算数据
        logYellow("结算数据")
        AJDMXEntry.ResultData.ImgTable = {};
        for i = 1, AJDMX_DataConfig.ALLIMGCOUNT do
            table.insert(AJDMXEntry.ResultData.ImgTable, buffer:ReadByte());
        end
        AJDMXEntry.ResultData.LineTypeTable = {};
        for i = 1, 25 do
            local line = {};
            for j = 1, AJDMX_DataConfig.COLUMNCOUNT do
                table.insert(line, buffer:ReadByte());
            end
            table.insert(AJDMXEntry.ResultData.LineTypeTable, line);
        end
        AJDMXEntry.ResultData.WinScore = buffer:ReadInt32();
        AJDMXEntry.ResultData.FreeCount = buffer:ReadInt32();
        AJDMXEntry.ResultData.m_nWinPeiLv=AJDMXEntry.ResultData.WinScore/(AJDMX_DataConfig.ALLLINECOUNT*AJDMXEntry.CurrentChip)
        AJDMXEntry.ResultData.cbHitBouns = buffer:ReadByte();--是否中小游戏
        AJDMXEntry.ResultData.cbIndex = buffer:ReadByte();--是否中小游戏
        logTable(AJDMXEntry.ResultData);
        AJDMXEntry.freeCount = AJDMXEntry.ResultData.FreeCount;
        AJDMXEntry.Roll();
    elseif AJDMX_Network.SUB_SC_SMALL_GAME == sid then

        AJDMXEntry.smallGameData.cbResCode = buffer:ReadByte();
        AJDMXEntry.smallGameData.cbPoint = buffer:ReadByte();
        AJDMXEntry.smallGameData.cbType = buffer:ReadByte();
        AJDMXEntry.smallGameData.cbFreeTime = buffer:ReadInt32();
        AJDMXEntry.smallGameData.nWinGold = buffer:ReadInt32();
        logTable(AJDMXEntry.smallGameData);
        AJDMX_SmallGame.SmallGameCallBack()

    elseif AJDMX_Network.SUB_SC_MAX_CHANCE == sid then
        AJDMXEntry.MaxGameData.cbResCode = buffer:ReadByte();
        AJDMXEntry.MaxGameData.cbFreeTime = buffer:ReadInt32();
        AJDMXEntry.MaxGameData.nWinGold = buffer:ReadInt32();
        logTable(AJDMXEntry.MaxGameData);
        AJDMX_SmallGame.MaxGameCallBack()
    end
end

function AJDMX_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    AJDMXEntry.SceneData.freeNumber = buffer:ReadInt32();

    AJDMXEntry.SceneData.bet = buffer:ReadInt32();

    --AJDMXEntry.SceneData.nGainPeilv = buffer:ReadInt32();
    AJDMXEntry.SceneData.nBetonCount = buffer:ReadInt32();

    AJDMXEntry.SceneData.chipList = {};
    for i = 1, 10 do
        if i <= AJDMXEntry.SceneData.nBetonCount then
            table.insert(AJDMXEntry.SceneData.chipList, buffer:ReadInt32()); 
        else
            buffer:ReadInt32()
        end
    end

    AJDMXEntry.SceneData.cbIsSmallGame =buffer:ReadByte()
    AJDMXEntry.SceneData.cbIndex =buffer:ReadByte()
    AJDMXEntry.ResultData.cbHitBouns = AJDMXEntry.SceneData.cbIsSmallGame;
    AJDMXEntry.ResultData.cbIndex = AJDMXEntry.SceneData.cbIndex;

    AJDMXEntry.SceneData.nMaxGameCount = buffer:ReadInt32();
    for i=1,3 do
        table.insert(AJDMXEntry.SceneData.nMaxGameType, buffer:ReadInt32()); 
    end
    for i=1,3 do
        table.insert(AJDMXEntry.SceneData.nMaxGameIndex, buffer:ReadInt32()); 
    end
    logTable(AJDMXEntry.SceneData);
    AJDMXEntry.InitPanel();
end
function AJDMX_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    AJDMX_Caijin.REQCJ();
end
function AJDMX_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function AJDMX_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function AJDMX_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    --TODO 设置金币数量
end
function AJDMX_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
end
function AJDMX_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    --destroy(AJDMXEntry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function AJDMX_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function AJDMX_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function AJDMX_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function AJDMX_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end