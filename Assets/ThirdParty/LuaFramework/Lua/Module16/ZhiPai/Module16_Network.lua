-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
g_sSlotModuleNum = "Module16Entry/CaiShenDao/";

--require(g_sSlotModuleNum .. "Slot/SlotBase")

Module16_Network = {};
local self = Module16_Network;

self.SUB_CS_GAME_START = 0  --启动游戏
self.SUB_CS_INSIDEGAME				=1;		--开始小游戏
self.SUB_CS_INSIDEGAME_CHOOSE		=2;		--小游戏选择

self.SUB_CS_USER_INFO = 2 --用户列表
self.SUB_CS_JACKPOT = 3;

self.SUB_SC_ROLL_RESULT = 0    --发送奖池
self.SUB_SC_INSIDEGAME_RESULT = 10;		--小游戏
self.SUB_SC_INSIDEGAME_CHOOSE_RESULT = 20;		--小游戏结果
self.SUB_SC_ACCOUNT_END	= 30;	--结算结束

function Module16_Network.AddMessage()
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
function Module16_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function Module16_Network.LoginGame()
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
function Module16_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function Module16_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
function Module16_Network.StartGame()
    Module16Entry.WinGold.gameObject:SetActive(false)
    Module16Entry.isRoll = true;
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(Module16Entry.CurrentChip);
    Network.Send(MH.MDM_GF_GAME, Module16_Network.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
end
function Module16_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));
    --游戏消息
    if Module16_Network.SUB_SC_ROLL_RESULT == sid then
        --结算数据
        Module16Entry.ResultData.ImgTable = {};

        for i = 1, Module16_DataConfig.ALLIMGCOUNT do
            table.insert(Module16Entry.ResultData.ImgTable, (buffer:ReadInt32()-1));
        end
        logYellow("00000")
        logTable(Module16Entry.ResultData.ImgTable)
        Module16Entry.ResultData.LineTypeTable = {};
        for i = 1, Module16_DataConfig.ALLLINECOUNT do
            local tempTab = {};
            for j = 1, Module16_DataConfig.COLUMNCOUNT do
                table.insert(tempTab, buffer:ReadInt32());
            end
            table.insert(Module16Entry.ResultData.LineTypeTable, tempTab);
        end

        Module16Entry.ResultData.WinScore = buffer:ReadInt32();
        Module16Entry.ResultData.FreeCount = buffer:ReadInt32();
        Module16Entry.ResultData.isSmallGame = buffer:ReadInt32();
        logTable(Module16Entry.ResultData);
        Module16Entry.Roll();
    elseif Module16_Network.SUB_SC_INSIDEGAME_RESULT == sid then
        logYellow("进入小游戏1")
        Module16Entry.SceneData.InsideGameResult={}
        Module16Entry.SceneData.ChooseGameResult={}

        for i = 1, Module16_DataConfig.SELECTSMALLCOUNT do
            local go1=buffer:ReadInt32()
            logYellow("i==="..i)
            table.insert(Module16Entry.SceneData.InsideGameResult,go1);
        end
        logYellow("进入小游戏2")
        logTable(Module16Entry.SceneData.InsideGameResult)
        for i = 1, Module16_DataConfig.SELECTSMALLCOUNT do
            local go2=buffer:ReadInt32()

            table.insert(Module16Entry.SceneData.ChooseGameResult,go2);
        end
        Module16Entry.ResultData.isSmallGame=1
        logYellow("进入小游戏3")
        logTable(Module16Entry.SceneData.ChooseGameResult)

        Module16_SmallGamePanel.SmallEnter()
    elseif Module16_Network.SUB_SC_INSIDEGAME_CHOOSE_RESULT == sid then
        logYellow("小游戏结果")
        local gold= buffer:ReadInt32();
       -- Module16Entry.SmallGameReult.WinScore =gold

        logYellow("Module16Entry.ResultData.WinScore=="..Module16Entry.ResultData.WinScore)

    end
end
function Module16_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    Module16Entry.SceneData.bet = buffer:ReadInt32();
    Module16Entry.SceneData.chipList = {};
    for i = 1, Module16_DataConfig.CHIPLISTCOUNT do
        local bets= buffer:ReadInt32()
        if Module16Entry.SceneData.bet==i then
            Module16Entry.SceneData.bet=bets
        end
        table.insert(Module16Entry.SceneData.chipList,bets);
    end
    logTable(Module16Entry.SceneData.chipList)
    Module16Entry.SceneData.GoldResult = buffer:ReadInt32();

    Module16Entry.SceneData.freeNumber = buffer:ReadInt32();

    Module16Entry.SceneData.isSmallCount = buffer:ReadInt32();
    
    for i = 1, Module16_DataConfig.SELECTSMALLCOUNT do
        table.insert(Module16Entry.SceneData.InsideGameResult, buffer:ReadInt32() );
    end
    for i = 1, Module16_DataConfig.SELECTSMALLCOUNT do
        table.insert(Module16Entry.SceneData.InsideGameChoose, buffer:ReadInt32() );
    end
    logTable(Module16Entry.SceneData);
    Module16Entry.InitPanel();
end
function Module16_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    Module16_Caijin.REQCJ();
end
function Module16_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function Module16_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function Module16_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    --TODO 设置金币数量
end
function Module16_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
end
function Module16_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    Module16_SmallGamePanel.StopCon()
    --destroy(Module16Entry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function Module16_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function Module16_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function Module16_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function Module16_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end