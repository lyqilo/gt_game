-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
g_sSlotModuleNum = "Module13Entry/CaiShenDao/";

--require(g_sSlotModuleNum .. "Slot/SlotBase")

Module13_Network = {};
local self = Module13_Network;

--客户端消息
self.SUB_CS_GAME_START=		0--启动游戏

--服务器消息
self.SUB_SC_GAME_START=	0--启动游戏
self.SUB_SC_GAME_OVER=	1--游戏结束

function Module13_Network.AddMessage()
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
function Module13_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function Module13_Network.LoginGame()
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
function Module13_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function Module13_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
function Module13_Network.StartGame()
    Module13Entry.WinGold.gameObject:SetActive(false)

    Module13Entry.isRoll = true;
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(Module13Entry.CurrentChip/Module13_DataConfig.ALLLINECOUNT);
    Network.Send(MH.MDM_GF_GAME, Module13_Network.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
end
function Module13_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));
    --游戏消息
    if Module13_Network.SUB_SC_GAME_OVER == sid then
        --结算数据
        Module13Entry.ResultData.ImgTable = {};

        for i = 1, Module13_DataConfig.ALLIMGCOUNT do
            table.insert(Module13Entry.ResultData.ImgTable,buffer:ReadInt32());
        end
        logTable(Module13Entry.ResultData.ImgTable)
        Module13Entry.ResultData.LineTypeTable = {};
        for i = 1, Module13_DataConfig.ALLLINECOUNT do
            local tempTab = {};
            for j = 1, Module13_DataConfig.COLUMNCOUNT do
                table.insert(tempTab, buffer:ReadByte());
            end
            table.insert(Module13Entry.ResultData.LineTypeTable, tempTab);
        end
        logErrorTable(Module13Entry.ResultData.LineTypeTable)
        logError("====================中奖线")

        self.allOpenRate = buffer:ReadInt32();--总倍率
        logError("=====================全盘奖："  .. self.allOpenRate)

        Module13Entry.ResultData.WinScore = tonumber(buffer:ReadInt64Str());
        logError("=====================中将金币：" ..Module13Entry.ResultData.WinScore )

        self.byAddFreeCnt = buffer:ReadByte();--增加免费次数
        logError("=====================免费游戏新整次数:" ..self.byAddFreeCnt )

        Module13Entry.ResultData.FreeCount = buffer:ReadByte();
        logError("=====================免费游戏模式次数" ..Module13Entry.ResultData.FreeCount )


        local _bFireMode = buffer:ReadByte();--烈焰模式
        if _bFireMode==1 then
            Module13Entry.isFireMode=true
        else
            Module13Entry.isFireMode=false
        end
        logError("=====================烈火模式次数:" ..tostring(Module13Entry.isFireMode))

        self.isgudi = buffer:ReadByte()==1; -- 是否固定 
        logError("=====================固定图标下标:" ..tostring(self.isgudi) )  
        self.bFireCom = buffer:ReadByte()==1;-- 是否烈火模式
        logError("=====================烈火模式次数:" ..tostring(self.bFireCom) )
        self.isfull = buffer:ReadByte()==1;
        logError("=====================全屏奖:" ..tostring(self.isfull) )

        self.fullValue = buffer:ReadByte()+Module13_DataConfig.full_start_value;--全屏的值
        logError("=====================全屏奖类型:" ..self.fullValue )
        self.isjiugong = buffer:ReadByte()==1;--是不是九宫
        self.jiugongValue = buffer:ReadByte()+Module13_DataConfig.jiugong_start_value;--九宫的值
        logError("=====================九宫格类型:" ..self.jiugongValue )

        logTable(Module13Entry.ResultData);

        Module13Entry.Roll();
    end
end
function Module13_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    Module13Entry.SceneData.chipList = {};
    for i = 1, Module13_DataConfig.CHIPLISTCOUNT do
        local bets= buffer:ReadInt32()
        -- if Module13Entry.SceneData.bet==i then
        --     Module13Entry.SceneData.bet=bets
        -- end
        table.insert(Module13Entry.SceneData.chipList,bets*Module13_DataConfig.ALLLINECOUNT);
    end

    local betIndex=buffer:ReadInt32();
    for i=1,#Module13Entry.SceneData.chipList do
        if betIndex==i then
            Module13Entry.SceneData.bet = Module13Entry.SceneData.chipList[i]
        end
    end

    logTable(Module13Entry.SceneData.chipList)
    Module13Entry.SceneData.freeNumber = buffer:ReadByte();

    local _bFireMode=buffer:ReadByte()

    if _bFireMode==1 then
        Module13Entry.SceneData.bFireMode = true ;
        Module13Entry.isFireMode=true
    else
        Module13Entry.SceneData.bFireMode = false ;
        Module13Entry.isFireMode=false
    end

    logTable(Module13Entry.SceneData);
    Module13Entry.InitPanel();
end
function Module13_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    Module13_Caijin.REQCJ();
end
function Module13_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function Module13_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function Module13_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    --TODO 设置金币数量
end
function Module13_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
end
function Module13_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    Module13_SmallGamePanel.StopCon()
    --destroy(Module13Entry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function Module13_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function Module13_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function Module13_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function Module13_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end