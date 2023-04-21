BRNN_RPCBase = {};
local self = BRNN_RPCBase;
self.messageMap = {};
self.sysMap = {};


function BRNN_RPCBase:new(args)
    local o = args or {};
    setmetatable(o, { __index = self })
    return o;
end

function BRNN_RPCBase:RegisterSystemMessage()
     self.messageMap = {};

    local gameMessage = function(wMaiID, wSubID, buffer, wSize)
        local sid = tonumber(string.sub(wSubID, string.len(tostring(wMaiID)) + 1, string.len(tostring(wSubID))))
        -- log("GameMessage===============wMaiID:"..wMaiID.." =============wSubID:"..wSubID.." ===========SID:"..sid)
        for i = 1, #self.messageMap do
            if (self.messageMap[i].OpCode == sid) then
                self.messageMap[i].CallBack(buffer, wSize);
                break
            end
        end
    end

    EventCallBackTable._01_GameInfo        = gameMessage --游戏消息
    EventCallBackTable._02_ScenInfo        = BRNN_RPCHandle.JoinGameRoomInfo --场景消息
    EventCallBackTable._03_LogonSuccess    = BRNN_RPCHandle.LogicSuccess--登陆成功
    EventCallBackTable._04_LogonOver        = BRNN_RPCHandle.LoginOver --登陆完成
    EventCallBackTable._05_LogonFailed    = BRNN_RPCHandle.LoginFail --登陆失败
    EventCallBackTable._06_Biao_Action    = nil--表情
    EventCallBackTable._07_UserEnter        = BRNN_RPCHandle.UserJoin --用户进入
    EventCallBackTable._08_UserLeave        = BRNN_RPCHandle.UserLave--用户离开
    EventCallBackTable._09_UserStatus    = BRNN_RPCHandle.UserState --用户状态
    EventCallBackTable._10_UserScore        = BRNN_RPCHandle.UserScore--用户分数
    EventCallBackTable._11_GameQuit        = BRNN_RPCHandle.QuitGame --退出游戏
    EventCallBackTable._12_OnSit            = BRNN_RPCHandle.UserJoinSite --用户入座
    EventCallBackTable._14_RoomBreakLine    = BRNN_RPCHandle.SocketOutLine --断线消息
    EventCallBackTable._16_OnHelp        = BRNN_RPCHandle.HelpConfiger --帮助
    EventCallBackTable._13_ChangeTable    = nil--换桌
    EventCallBackTable._15_OnBackGame    = BRNN_RPCHandle.SocketOutLine -- home键返回游戏
    EventCallBackTable._16_OnHelp=BRNN_RPCHandle.OpenHelp;
    MessgeEventRegister.Game_Messge_Reg(EventCallBackTable)
end

---注册消息号
function BRNN_RPCBase:RegisterNetMessage(opCode, callBack)
    local temp ={
        OpCode = opCode;
        CallBack = callBack;
    }
    table.insert(self.messageMap, temp);
end

---清理所有注册的消息
function BRNN_RPCBase:ClearRegisterMessage()
    logError("OnDestroy  002")
    
    logError("OnDestroy  003")
    MessgeEventRegister.Game_Messge_Un();

    self.messageMap = {};
    logError("OnDestroy  004")
end