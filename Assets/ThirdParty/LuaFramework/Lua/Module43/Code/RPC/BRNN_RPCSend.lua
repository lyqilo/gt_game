
BRNN_RPCSend = {}
local self = BRNN_RPCSend;

--玩家下注
function BRNN_RPCSend.PlayerBet(data)
    error("玩家下注。。。。..................")
    local buff = 
    {
        [1] = DataSize.byte, --下注区域
        [2] = DataSize.Int32, --下注值
    }
    local buffer = SetC2SInfo(buff, data)
    Network.Send(MH.MDM_GF_GAME, BRNN_CMD.SUB_CS_PLAYER_CHIP, buffer, gameSocketNumber.GameSocket)
     error("已发送玩家下注。。。。..................")
end

--申请上庄
function BRNN_RPCSend.UpBank()
    local buff = 
    {
    }
    local buffer = SetC2SInfo(buff, nil)
    Network.Send(MH.MDM_GF_GAME, BRNN_CMD.SUB_CS_REQUEST_BANKER, buffer, gameSocketNumber.GameSocket)
end

--申请下庄
function BRNN_RPCSend.DownBank()
    local buff = 
    {
    }
    local buffer = SetC2SInfo(buff, nil)
    Network.Send(MH.MDM_GF_GAME, BRNN_CMD.SUB_SC_LOSE_BANKER, buffer, gameSocketNumber.GameSocket)
    error("发送玩家下庄。。。。..................: ")
end

--

--发送登陆数据结构
self.CMD_GR_LogonByUserID = {
    [1] = DataSize.UInt32, --广场版本 暂时不用
    [2] = DataSize.UInt32, --进程版本 暂时不用
    [3] = DataSize.UInt32, --用户 I D
    [4] = DataSize.String33, --登录密码 MD5小写加密
    [5] = DataSize.String100, --机器序列 暂时不用
    [6] = DataSize.byte, --补位
    [7] = DataSize.byte --补位
}
---用户登陆
function BRNN_RPCSend.PlayerLogon()
    error("登陆游戏。。。。")
    local data = {
        [1] = 0, --广场版本 暂时不用
        [2] = 0, --进程版本 暂时不用
        [3] = SCPlayerInfo._01dwUser_Id, --用户 I D
        [4] = SCPlayerInfo._06wPassword, --登录密码 MD5小写加密
        [5] = Opcodes, --机器序列 暂时不用
        [6] = 0,
        [7] = 0
    }
    local buffer = SetC2SInfo(self.CMD_GR_LogonByUserID, data)
    Network.Send(MH.MDM_GR_LOGON, 3, buffer, gameSocketNumber.GameSocket)
end
---玩家准备
function BRNN_RPCSend.PlayerPrepare()
    local CMD_GF_Info = {
        [1] = DataSize.byte --旁观标志 必须等于0
    }
	local Data = {[1] = 0}
    local buffer = ByteBuffer.New()
    buffer:WriteByte(0)
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket)
    error("==========发送用户准备==========")
end
---玩家入座
function BRNN_RPCSend.PlayerInSeat()
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket)
end