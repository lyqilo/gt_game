-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion

--require(g_sSlotModuleNum .. "Slot/SlotBase")

MCDZZ_Network = {};
local self = MCDZZ_Network;

self.SUB_CS_GAME_START = 1  --启动游戏
self.SUB_CS_START_BALL_GAME = 2  --小游戏

self.SUB_SC_GAME_OVER = 1;  --游戏结果返回
self.SUB_SC_START_BALL_GAME = 103;--小游戏返回


function MCDZZ_Network.AddMessage()
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
function MCDZZ_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function MCDZZ_Network.LoginGame()
    logYellow("====登录游戏======")
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
function MCDZZ_Network.PrepareGame()
    logYellow("====准备======")

    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function MCDZZ_Network.InSeat()
    logYellow("====入座======")

    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
function MCDZZ_Network.StartGame()
    MCDZZEntry.isRoll = true;
    MCDZZ_Result.WinningLineNum=0
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(MCDZZEntry.CurrentChip);
    logYellow("点击开始===="..MCDZZEntry.CurrentChip)
    Network.Send(MH.MDM_GF_GAME, MCDZZ_Network.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
end
function MCDZZ_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));

    if sid==101 then
        MCDZZ_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    end

    --游戏消息
    if MCDZZ_Network.SUB_SC_GAME_OVER == sid then
        --结算数据
        logYellow("======结算数据=======")
        MCDZZEntry.ResultData.ImgTable = {};
        for i = 1, MCDZZ_DataConfig.ALLIMGCOUNT do
            table.insert(MCDZZEntry.ResultData.ImgTable, buffer:ReadInt32());
        end
        MCDZZEntry.ResultData.FreeImgTable = {};
        for i = 1, MCDZZ_DataConfig.ALLIMGCOUNT do
            table.insert(MCDZZEntry.ResultData.FreeImgTable, buffer:ReadInt32());
        end
        MCDZZEntry.ResultData.LineTypeTable = {};
        MCDZZEntry.ResultData.ZJTABLE = {
            [1]=0,
            [2]=0,
            [3]=0,
            [4]=0,
            [5]=0,
        };
        for i = 1, MCDZZ_DataConfig.ALLLINECOUNT do
            local _Icon=buffer:ReadInt32()
            local _Count=buffer:ReadInt32()
            local _Bl=buffer:ReadInt32()
            local isDYTH={}
            if _Bl > 0 then
                if _Icon==6 then
                    table.remove(MCDZZEntry.ResultData.ZJTABLE,1)
                    table.insert(MCDZZEntry.ResultData.ZJTABLE,1,_Icon);
                elseif _Icon==7 then
                    table.remove(MCDZZEntry.ResultData.ZJTABLE,2)
                    table.insert(MCDZZEntry.ResultData.ZJTABLE,2,_Icon);
                elseif _Icon==8 then
                    table.remove(MCDZZEntry.ResultData.ZJTABLE,3)
                    table.insert(MCDZZEntry.ResultData.ZJTABLE,3,_Icon);
                elseif _Icon==9 then
                    table.remove(MCDZZEntry.ResultData.ZJTABLE,4)
                    table.insert(MCDZZEntry.ResultData.ZJTABLE,4,_Icon);
                elseif _Icon==10 then
                    table.remove(MCDZZEntry.ResultData.ZJTABLE,5)
                    table.insert(MCDZZEntry.ResultData.ZJTABLE,5,_Icon);
                end
                for j=1,5 do
                    if _Count>=j then
                        table.insert(isDYTH, 1);   
                    else
                        table.insert(isDYTH, 0);   
                    end
                end
                MCDZZ_Result.WinningLineNum=MCDZZ_Result.WinningLineNum+1

            else
                for k=1,5 do
                    table.insert(isDYTH, 0);   
                end
            end
            table.insert(MCDZZEntry.ResultData.LineTypeTable, isDYTH);
        end
        local m_nWinPeiLv1=buffer:ReadInt32()
        local m_nWinPeiLv2=buffer:ReadInt32()
        
        MCDZZEntry.ResultData.WinScore = m_nWinPeiLv2*MCDZZEntry.CurrentChip

        MCDZZEntry.ResultData.m_nWinPeiLv=m_nWinPeiLv2

        local isFreeSta=buffer:ReadByte()

        -- if isFreeSta==1 or MCDZZEntry.ResultData.FreeCount > 0 then
        --     if MCDZZEntry.ResultData.FreeCount==0 then
        --         MCDZZEntry.ResultData.FreeCount=10
        --     end
        -- else
        --     MCDZZEntry.ResultData.FreeCount=0
        -- end
        MCDZZEntry.ResultData.FreeCount = buffer:ReadInt32();
        MCDZZEntry.ResultData.isSmallGameCount = buffer:ReadInt32();
        MCDZZEntry.freeCount = MCDZZEntry.ResultData.FreeCount;
        logTable(MCDZZEntry.ResultData);
        MCDZZEntry.Roll();
    end
end
function MCDZZ_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    MCDZZEntry.SceneData.bet = buffer:ReadInt32(); --下注
    MCDZZEntry.SceneData.chipCount=buffer:ReadInt32()

    MCDZZEntry.SceneData.chipList = {};
    for i = 1, MCDZZEntry.SceneData.chipCount do
        table.insert(MCDZZEntry.SceneData.chipList, buffer:ReadInt32()); --下注列表
    end
    if MCDZZEntry.SceneData.bet==0 then
        MCDZZEntry.SceneData.bet=MCDZZEntry.SceneData.chipList[1]
    end
    MCDZZEntry.SceneData.freeNumber = buffer:ReadInt32(); --免费次数
    for i=1,MCDZZ_DataConfig.ColumnCount*MCDZZ_DataConfig.RowCount do
        table.insert(MCDZZEntry.SceneData.StopIcon, buffer:ReadInt32()); 
    end
    logTable(MCDZZEntry.SceneData);
    MCDZZEntry.InitPanel();
end
function MCDZZ_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    MCDZZ_Caijin.REQCJ();
end
function MCDZZ_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function MCDZZ_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function MCDZZ_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    --TODO 设置金币数量
end
function MCDZZ_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
end
function MCDZZ_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    --destroy(MCDZZEntry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function MCDZZ_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function MCDZZ_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function MCDZZ_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function MCDZZ_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end