-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion

--require(g_sSlotModuleNum .. "Slot/SlotBase")

XYSGJ_Network = {};
local self = XYSGJ_Network;

self.SUB_CS_GAME_START = 1  --启动游戏
self.SUB_CS_START_BALL_GAME = 2  --小游戏

self.SUB_SC_GAME_OVER = 1;  --1
self.SUB_SC_JACKPOT = 2;--jc

self.SUB_SC_BET_FAIL=104;

function XYSGJ_Network.AddMessage()
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
function XYSGJ_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function XYSGJ_Network.LoginGame()
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
function XYSGJ_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function XYSGJ_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end

function XYSGJ_Network.StartGame()
    XYSGJEntry.isRoll = true;
    XYSGJ_Result.WinningLineNum=0
    local buffer = ByteBuffer.New();
    logYellow("CurrentChip=="..XYSGJEntry.CurrentChip)
    buffer:WriteUInt32(XYSGJEntry.CurrentChip);
    Network.Send(MH.MDM_GF_GAME, XYSGJ_Network.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
end

function XYSGJ_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));

    -- if sid==XYSGJ_Network.SUB_SC_BET_FAIL  then
    --     XYSGJEntry.tipJBBZ.gameObject:SetActive(true)
    -- end
    --游戏消息
    if XYSGJ_Network.SUB_SC_GAME_OVER == sid then
        --结算数据
        XYSGJEntry.ResultData.ImgTable = {};
        XYSGJEntry.zpPostable={}
        for i = 1, XYSGJ_DataConfig.ALLIMGCOUNT do
            local pos=buffer:ReadInt32()
            table.insert(XYSGJEntry.ResultData.ImgTable,pos );
            if pos==7 then
                table.insert(XYSGJEntry.zpPostable,i);
            end
        end
        XYSGJEntry.ResultData.LineTypeTable = {};
        for i = 1, XYSGJ_DataConfig.ALLLINECOUNT do
            local _Icon=buffer:ReadInt32()
            local _Count=buffer:ReadInt32()
            local _Bl=buffer:ReadInt32()
            local isDYTH={}
            if _Bl > 0 then
                for j=1,3 do
                    if _Count>=j then
                        table.insert(isDYTH, 1);   
                    else
                        table.insert(isDYTH, 0);   
                    end
                end
                XYSGJ_Result.WinningLineNum=XYSGJ_Result.WinningLineNum+1
            else
                for k=1,3 do
                    table.insert(isDYTH, 0);   
                end
            end
            table.insert(XYSGJEntry.ResultData.LineTypeTable, isDYTH);
        end
        local m_nWinPeiLv1=buffer:ReadInt32()
        local m_nWinPeiLv2=buffer:ReadInt32()
        --XYSGJEntry.ResultData.FreeCount = buffer:ReadInt32();
        XYSGJEntry.ResultData.isSmallGame = buffer:ReadByte();

        XYSGJEntry.ResultData.WinScore =m_nWinPeiLv2*XYSGJEntry.CurrentChip-- buffer:ReadInt32();

        
        if XYSGJEntry.ResultData.isSmallGame ==1 then
            XYSGJEntry.isSmallGame=true
        else
            XYSGJEntry.isSmallGame=false
        end
        XYSGJEntry.SmallGameData.nGameType=buffer:ReadInt32()
        XYSGJEntry.SmallGameData.nGameCount=buffer:ReadInt32()
        XYSGJEntry.SmallGameData.nGameinfo={}

        for i=1,8 do
            local isnum=buffer:ReadInt32()
            logYellow("isnum=="..isnum)
            if isnum>0 then
                table.insert(XYSGJEntry.SmallGameData.nGameinfo,isnum)
            end
        end

        XYSGJEntry.SmallGameData.nFreeTimes=buffer:ReadInt32()--mf
        XYSGJEntry.SmallGameData.nOdd=buffer:ReadInt32()--cm
        XYSGJEntry.ResultData.FreeCount=XYSGJEntry.SmallGameData.nFreeTimes
        XYSGJEntry.freeCount = XYSGJEntry.ResultData.FreeCount;
        --XYSGJEntry.freeCount = XYSGJEntry.ResultData.FreeCount;

        logTable(XYSGJEntry.ResultData);
        logTable(XYSGJEntry.SmallGameData)

        XYSGJEntry.Roll();
    elseif XYSGJ_Network.SUB_SC_JACKPOT == sid then
        local jackpot = buffer:ReadInt32();
        log("彩金：" .. jackpot);
        if XYSGJ_Caijin.CaijinGold > 0 then
            if jackpot <= XYSGJ_Caijin.currentCaijin1 then
                XYSGJ_Caijin.currentCaijin1 = jackpot;
                -- XYSGJ_Caijin.currentCaijin2=XYSGJ_Caijin.currentCaijin1*12
                -- XYSGJ_Caijin.currentCaijin3=XYSGJ_Caijin.currentCaijin1*39
            end
        end
        XYSGJ_Caijin.CaijinGold = jackpot;
    end
end
function XYSGJ_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    XYSGJEntry.SceneData.bet = buffer:ReadInt32(); --下注

    local betCount= buffer:ReadInt32(); --

    XYSGJEntry.SceneData.chipList = {};

    for i = 1, betCount do
        table.insert(XYSGJEntry.SceneData.chipList, buffer:ReadInt32()); --下注列表
    end

    if XYSGJEntry.SceneData.bet==0 then

        XYSGJEntry.SceneData.bet=XYSGJEntry.SceneData.chipList[1]
    
    end

    XYSGJEntry.SceneData.freeNumber = buffer:ReadInt32(); --免费次数

    -- XYSGJEntry.SceneData.cbBouns = buffer:ReadByte();--小游戏轮数
    -- XYSGJEntry.SceneData.nBounsNo = buffer:ReadByte();--小游戏底图
    -- XYSGJEntry.SceneData.SmallAllGold = buffer:ReadInt32();--小游戏总金币
    logTable(XYSGJEntry.SceneData);
    XYSGJEntry.InitPanel();
end
function XYSGJ_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    XYSGJ_Caijin.REQCJ();
end
function XYSGJ_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function XYSGJ_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function XYSGJ_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    --TODO 设置金币数量
end
function XYSGJ_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
end
function XYSGJ_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    --destroy(XYSGJEntry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function XYSGJ_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function XYSGJ_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function XYSGJ_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function XYSGJ_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end