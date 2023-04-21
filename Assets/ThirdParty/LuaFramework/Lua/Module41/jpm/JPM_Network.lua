-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion

--require(g_sSlotModuleNum .. "Slot/SlotBase")

JPM_Network = {};
local self = JPM_Network;

self.SUB_CS_GAME_START = 1  --启动游戏
self.SUB_CS_START_BALL_GAME = 2  --小游戏

self.SUB_SC_START_GAME = 102;  --游戏结果返回
self.SUB_SC_START_BALL_GAME = 103;--小游戏返回


function JPM_Network.AddMessage()
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
function JPM_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function JPM_Network.LoginGame()
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
function JPM_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function JPM_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
function JPM_Network.StartGame()
    JPMEntry.isRoll = true;
    JPM_Result.WinningLineNum=0
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(JPMEntry.CurrentChip);
    Network.Send(MH.MDM_GF_GAME, JPM_Network.SUB_CS_GAME_START, buffer, gameSocketNumber.GameSocket);
end
function JPM_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));

    if sid==101 then
        JPM_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    end
    --游戏消息
    if JPM_Network.SUB_SC_START_GAME == sid then
        --结算数据
        JPMEntry.ResultData.ImgTable = {};
        for i = 1, JPM_DataConfig.ALLIMGCOUNT do
            table.insert(JPMEntry.ResultData.ImgTable, buffer:ReadByte());
        end
        JPMEntry.ResultData.LineTypeTable = {};
        for i = 1, JPM_DataConfig.ALLLINECOUNT do
            local tempTab = {};
            local isOneAdd=true
            for j = 1, JPM_DataConfig.COLUMNCOUNT do
                local _b=buffer:ReadByte()
                if _b==1 and isOneAdd then
                    isOneAdd=false
                    JPM_Result.WinningLineNum=JPM_Result.WinningLineNum+1
                end
                table.insert(tempTab, _b);
            end
            table.insert(JPMEntry.ResultData.LineTypeTable, tempTab);
        end
        JPMEntry.ResultData.WinScore =tonumber(buffer:ReadInt64Str())-- buffer:ReadInt32();
        JPMEntry.ResultData.FreeCount = buffer:ReadInt32();
        JPMEntry.ResultData.isSmallGame = buffer:ReadByte();
        logTable(JPMEntry.ResultData);
        JPMEntry.freeCount = JPMEntry.ResultData.FreeCount;
        JPMEntry.Roll();
    elseif sid == self.SUB_SC_START_BALL_GAME then
        local gold=buffer:ReadInt32()
        gold=(gold*JPMEntry.CurrentChip*JPM_DataConfig.ALLLINECOUNT)
        JPM_SmallGame.SmallGameBack(gold)
    end
end
function JPM_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    JPMEntry.SceneData.chipList = {};

    local betCount=buffer:ReadInt32()
    JPM_DataConfig.CHIPLISTCOUNT=betCount
    for i = 1, betCount  do
        table.insert(JPMEntry.SceneData.chipList, buffer:ReadInt32()); --下注列表
    end
    
    JPMEntry.SceneData.bet = buffer:ReadInt32(); --下注
    if JPMEntry.SceneData.bet==0 then
        JPMEntry.SceneData.bet=JPMEntry.SceneData.chipList[1];
    end
    JPMEntry.SceneData.freeNumber = buffer:ReadInt32(); --免费次数
    JPMEntry.SceneData.cbBouns = buffer:ReadByte();--小游戏轮数
    JPMEntry.SceneData.nBounsNo = buffer:ReadByte();--小游戏底图
    JPMEntry.SceneData.SmallAllGold = buffer:ReadInt32();--小游戏总金币
    logTable(JPMEntry.SceneData);
    JPMEntry.InitPanel();
end
function JPM_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
    JPM_Caijin.REQCJ();
end
function JPM_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function JPM_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function JPM_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    --TODO 设置金币数量
end
function JPM_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
end
function JPM_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    --destroy(JPMEntry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function JPM_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function JPM_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function JPM_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function JPM_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end