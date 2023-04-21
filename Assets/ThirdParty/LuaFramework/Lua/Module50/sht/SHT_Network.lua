-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
--g_sSlotModuleNum = "Module27/CaiShenDao/";

--require(g_sSlotModuleNum .. "Slot/SlotBase")

SHT_Network = {};
local self = SHT_Network;


self.SUB_CS_GAME_START  =   1

self.SUB_SC_GAME_START	=   0
self.SUB_SC_BET_FAIL    =   2 

function SHT_Network.AddMessage()
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
function SHT_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function SHT_Network.LoginGame()
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
function SHT_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function SHT_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
function SHT_Network.StartGame()
    --开始游戏
    SHTEntry.isRoll = true;
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(SHTEntry.CurrentChip);
    logYellow("开始游戏=="..SHTEntry.CurrentChip)
    --buffer:WriteUInt32(SHTEntry.CurrentChip);
    Network.Send(MH.MDM_GF_GAME, SHT_Network.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
end
function SHT_Network.SelectFree()
    -- --选择免费游戏类型
    -- if SHTEntry.ResultData.m_FreeType == 0 then
    --     return ;
    -- end
    -- local buffer = ByteBuffer.New();
    -- buffer:WriteUInt32(SHTEntry.ResultData.m_FreeType);
    -- Network.Send(MH.MDM_GF_GAME, SHT_Network.SUB_CS_CHOSE_FREEGAME_TYPE, buffer, gameSocketNumber.GameSocket);
end
function SHT_Network.StartSmallGame()
    -- --开始转盘小游戏
    -- local buffer = ByteBuffer.New();
    -- Network.Send(MH.MDM_GF_GAME, SHT_Network.SUB_CS_LITTLE_GAME, buffer, gameSocketNumber.GameSocket);
end
function SHT_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));
    --游戏消息
    if SHT_Network.SUB_SC_BET_FAIL == sid then
        --下注失败
        local statusCode = buffer:ReadInt32();
        if statusCode == 1 then
            MessageBox.CreatGeneralTipsPanel("Insufficient gold coins");
            logYellow("Insufficient gold coins")

        elseif statusCode == 2 then
            logYellow("下注失败")
            MessageBox.CreatGeneralTipsPanel("下注失败");--下注错误
        end
        SHT_Result.CheckFree()
    elseif SHT_Network.SUB_SC_GAME_START == sid then
        --结算数据
        logYellow("结算数据")
        SHTEntry.ResultData.ImgTable = {};
        for i = 1, SHT_DataConfig.ALLIMGCOUNT do
            table.insert(SHTEntry.ResultData.ImgTable, buffer:ReadByte());
        end
        SHTEntry.ResultData.LineTypeTable = {};
        for i = 1, 25 do
            local line = {};
            for j = 1, SHT_DataConfig.COLUMNCOUNT do
                table.insert(line, buffer:ReadByte());
            end
            table.insert(SHTEntry.ResultData.LineTypeTable, line);
        end

        local m_Count1=0
        local m_Count2=0
        
        for i=1,#SHTEntry.ResultData.ImgTable do
            if SHTEntry.ResultData.ImgTable[i]==9 and (i-2)%5==0 then
                m_Count1=m_Count1+1
            end
            if SHTEntry.ResultData.ImgTable[i]==9 and (i-4)%5==0 then
                m_Count2=m_Count2+1
            end
        end
        if m_Count1==3 then
            local line={}
            for i=1,3 do
                table.insert(line,1);  
            end
            table.insert(line,0);  
            table.insert(line,0); 
            table.insert(SHTEntry.ResultData.LineTypeTable, line);
        end
        if m_Count2==3 then
            local line={}
            for i=1,3 do
                table.insert(line,1);  
            end
            table.insert(line,0);  
            table.insert(line,0);  
            table.insert(SHTEntry.ResultData.LineTypeTable, line);
        end
        
        SHTEntry.ResultData.WinScore = buffer:ReadInt32();
        SHTEntry.ResultData.FreeCount = buffer:ReadInt32();

        SHTEntry.ResultData.m_nWinPeiLv=SHTEntry.ResultData.WinScore/(SHT_DataConfig.ALLLINECOUNT*SHTEntry.CurrentChip)
        SHTEntry.ResultData.JACKPOT = {};
        for i=1,8 do
            local gold=buffer:ReadInt32()
            table.insert(SHTEntry.ResultData.JACKPOT,gold);
        end
        SHT_Caijin:SetCAIJIN(SHTEntry.ResultData.JACKPOT[SHTEntry.CurrentChipIndex])

        logTable(SHTEntry.ResultData);
        SHTEntry.freeCount = SHTEntry.ResultData.FreeCount;
        SHTEntry.Roll();
    end
end


-- struct SC_SceneInfo
-- {
-- 	INT32	nFreeCount;
-- 	INT32	nCurrenBet;
-- 	INT32	nBetCount;
-- 	INT32	nBet[MAX_BET_COUNT];
-- 	INT32	nJackpot[8];
-- };
function SHT_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    SHTEntry.SceneData.freeNumber = buffer:ReadInt32();

    SHTEntry.SceneData.bet = buffer:ReadInt32();

    --SHTEntry.SceneData.nGainPeilv = buffer:ReadInt32();
    SHTEntry.SceneData.nBetonCount = buffer:ReadInt32();

    SHTEntry.SceneData.chipList = {};
    for i = 1, 10 do
        if i <= SHTEntry.SceneData.nBetonCount then
            table.insert(SHTEntry.SceneData.chipList, buffer:ReadInt32()); 
        else
            buffer:ReadInt32()
        end
    end
    
    SHTEntry.SceneData.Jackpot={}
    for i=1,8 do
        table.insert(SHTEntry.SceneData.Jackpot, buffer:ReadInt32());
    end

    SHTEntry.SceneData.BS={}
    for i=1,5 do
        local num=buffer:ReadInt32()
        table.insert(SHTEntry.SceneData.BS,num);
    end
    logTable(SHTEntry.SceneData);
    SHTEntry.InitPanel();
end
function SHT_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    SHT_Caijin.REQCJ();
end
function SHT_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function SHT_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function SHT_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    --TODO 设置金币数量
end
function SHT_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
end
function SHT_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    --destroy(SHTEntry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function SHT_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function SHT_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function SHT_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function SHT_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end