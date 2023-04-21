Network = {}
local self = Network
self.startCheckNetAll = false
self.sendDataTimes = 0
self.resetNetworkEvent = 0
self.IsConnected = false

function Network.State(id)
    local flag, session = networkMgr.DicSession:TryGetValue(id, nil)
    if flag then
        return session.run
    end
    return false
end

function Network.Close(id, bl)
    if id == gameSocketNumber.HallSocket then
        HallScenPanel.connectSuccess = false;
    elseif id == gameSocketNumber.GameSocket then
        HallScenPanel.connectGameSuccess = false;
    end
    local flag, session = networkMgr.DicSession:TryGetValue(id, nil)
    if flag then
        if session then
            -- 主动端开不用回掉
            if bl == nil then
                session.CloseFunc = nil
            end
            if session.run then
                session:Dispose()
            end
        end
    end
end
function Network.OnSocket(mid, sid, bf, size, idx)
    if idx == gameSocketNumber.HallSocket then
        HallScenPanel.connectTime = HallScenPanel.connectMaxTime;
    elseif idx == gameSocketNumber.GameSocket then
        HallScenPanel.connectgameTimer = HallScenPanel.connectgameMaxTimer;
    end
    local Mid = string.sub(mid, 1, -2)
    if Mid ~= "260" then
        logCyan(string.format("收到消息: mid=%s sid=%s size=%s idx=%s", Mid, sid, size, idx))
    end
    local subID = sid
    self.CheckNetCount = 0
    IsSend = true
    if idx == gameSocketNumber.GameSocket then
        subID = mid .. sid
    end
    -- 底层心跳包处理
    if tostring(mid) == "0" .. idx then
        if sid == 1 then
            --if Network.State(idx) then
            --    Network.Send(0, 1, nil, idx)
            --end
            return
        end
        if sid == 2 then
            logError("服务器断开网络" .. idx)
            Network.Close(idx, false)
            -- HallScenPanel.NetException(nil, gameSocketNumber.HallSocket);
            return
        end
    end
    --收到服务器消息，开始分发
    Event.Brocast(tostring(mid), mid, tonumber(subID), bf, size)
    if tostring(mid) == "1002" and tostring(sid) == "101" then
        GameManager.isEnterGame = true;
    end
    bf:Close()

    self.sendDataTimes = 0
    self.RemoveSendErrorMsg(mid .. subID)
end

function Network.CheckNetAll()
    if self.startCheckNetAll then
        return
    end
    self.startCheckNetAll = true
    self.IsWifi = Util.IsWifi
    self.noNetAvailableCount = 0
    -- 超过40秒没有收到任意服务器消息,视为网络异常,将其关闭
    function f()
        local t = 40
        local netYes = true
        local t2 = 3
        while self.startCheckNetAll do
            coroutine.wait(t2)
            Network.sendDataTimes = Network.sendDataTimes + t2

            -- 网络的畅通性
            netYes = Util.NetAvailable
            if netYes then
                self.noNetAvailableCount = 0
            end
            if not netYes then
                self.noNetAvailableCount = self.noNetAvailableCount + 1
                if self.noNetAvailableCount > 3 then
                    error("网络不可用!")
                    HallScenPanel.waitTransform.gameObject:SetActive(false)
                    HallScenPanel.NetException(nil, gameSocketNumber.HallSocket)
                    Network.sendDataTimes = 999
                end
            end

            -- wifi和4G的切换
            if self.IsWifi ~= Util.IsWifi then
                error("网络环境改变!")
                HallScenPanel.waitTransform.gameObject:SetActive(false)
                Network.sendDataTimes = 999
                HallScenPanel.NetException(nil, gameSocketNumber.HallSocket)
            end

            if Network.sendDataTimes > t then
                error(string.format("检测到超过%d秒没有通讯!", t))
                Network.Close(gameSocketNumber.HallSocket, true)
                Network.Close(gameSocketNumber.GameSocket, true)
                Network.Close(gameSocketNumber.LogSocket, true)
                self.startCheckNetAll = false
                Network.sendDataTimes = 0
            end
        end
    end
    coroutine.start(f)
end

-- ip            远程地址
-- prot          远程端口
-- id            session的序号
-- callBack      连接成功或者失败的回调
-- timeOut       连接的超时时间
-- closeFunc     正常session的意外断开回调
function Network.Connect(ip, prot, id, callBack, timeOut, closeFunc)
    logError("===IP:" .. ip .. "=====Port:" .. prot);
    if (timeOut == nil) then
        timeOut = 7000
    end

    local back = function(state, session)
        log(string.format("session %d connect net %s", id, (state or "No")))
        local y = "Yes"
        local n = "No"
        if tostring(state) == y then
            self.IsConnected = true
            callBack(y)
            if session then
                session.CloseFunc = closeFunc
            end
        end
        if tostring(state) == n then
            callBack(n)
        end
    end

    Session.New(ip, prot, id, back, timeOut)
end

-- 发送Socket信息
function Network.Send(mid, sid, bf, id)
    logCyan(string.format("发送消息: mid=%s sid=%s", mid, sid))
    if (id == nil) then
        id = gameSocketNumber.LogonSoket
    end
    local flag, session = networkMgr.DicSession:TryGetValue(id, nil)
    if not flag then
        error("can't find session object")
        HallScenPanel.NetException(nil, gameSocketNumber.HallSocket)
        return false
    end
    
    if not session.run then
        error("seesion id " .. id .. " stop run!send mid:" .. mid .. ",sid:" .. sid .. " failed")
		if id == gameSocketNumber.HallSocket then
            HallScenPanel.ReqServer();
        end
        return false
    end
    if (bf == nil) then
        bf = ByteBuffer.New()
    end
    local y = (session:Send(mid, sid, bf)) or true
    -- 处理主动断开MH.MDM_GR_USER, MH.SUB_GR_USER_LEFT_GAME_REQ
    if mid == MH.MDM_GR_USER then
        if sid == MH.SUB_GR_USER_LEFT_GAME_REQ then
            -- 主动端开不用回掉
            session.CloseFunc = nil
            session:Dispose()
        end
    end
    if y then
        bf:Close()
    else
		if id == gameSocketNumber.HallSocket then
            HallScenPanel.ReqServer();
        end
        error(string.format("mid:%s, sid:%s  发送失败"))
    end
    return true
end

-- 发送socket信息,并尽量检测是否发送成功,失败则从发
function Network.SendMsg(sf, outMid, OutSid, id)
    if self.SendErrorMsg == nil then
        self.SendErrorMsg = {}
    end
    local t = {
        -- 实际发送消息的函数
        f = sf,
        -- 检测成功的主消息ID
        mid = outMid,
        -- 检测成功的子消息ID
        sid = OutSid,
        -- socketID
        idx = id
    }

    local key = -1
    local addId = outMid .. id .. OutSid
    table.foreach(
            self.SendErrorMsg,
            function(k, v)
                local id = v.mid .. v.idx .. v.sid
                if tostring(addId) == tostring(id) then
                    key = id
                end
            end
    )
    if key == -1 then
        table.insert(self.SendErrorMsg, t)
    end
    sf()
end

function Network.RestSendMsg(id)
    if self.SendErrorMsg == nil then
        return
    end
    table.foreach(
            self.SendErrorMsg,
            function(k, t)
                if t == nil then
                    error("SendErrorMsg t is nil")
                end
                if t.idx == id then
                    self.SendMsg(t.f, t.mid, t.sid, t.idx)
                end
                log(string.format("发送没有发送成功的消息mid:%s sid:%s", t.mid, t.sid))
            end
    )
end

function Network.RemoveSendErrorMsg(removeid)
    if self.SendErrorMsg == nil then
        return
    end
    local key = -1
    table.foreach(
            self.SendErrorMsg,
            function(k, v)
                local id = v.mid .. v.idx .. v.sid
                if tostring(removeid) == tostring(id) then
                    key = k
                end
            end
    )
    if key ~= -1 then
        --local t = self.SendErrorMsg[key];
        --log(string.format("remove sendErrorMsg mid:%s , sid:%s", t.mid, t.sid));
        table.remove(self.SendErrorMsg, key)
    end
    if (#self.SendErrorMsg) == 0 then
        self.SendErrorMsg = nil
    end
end

function Network.AddResetNetworkEvent(f)
    if type(t) ~= "function" then
        error("AddResetNetworkEvent args not function!")
        return
    end
    if self.resetNetworkEvent == nil then
        self.resetNetworkEvent = {}
    end
    local y = false
    table.foreach(
            self.resetNetworkEvent,
            function(k, t)
                if tostring(t) == tostring(f) then
                    y = true
                end
            end
    )
    if not y then
        table.insert(self.resetNetworkEvent, f)
    end
end

function Network.RemoveResetNetworkEvent(f)
    if self.resetNetworkEvent == nil then
        self.resetNetworkEvent = {}
    end
    local key = -1
    table.foreach(
            self.resetNetworkEvent,
            function(k, t)
                if tostring(t) == tostring(f) then
                    key = k
                end
            end
    )
    if key ~= -1 then
        table.remove(self.resetNetworkEvent, key)
    end
end

function Network.ResetNetwork()
    if self.resetNetworkEvent == nil then
        return
    end
    table.foreach(
            self.resetNetworkEvent,
            function(k, t)
                if t ~= nil then
                    if type(t) == "function" then
                        t()
                    end
                end
            end
    )
end

function Network.OnException(s, idx)
    FramePopoutCompent.Show(s)
end

function Network.OnDestroy()
    -- 这里修复底层一个问题。重启APP没有清理socket
    local NetDic = networkMgr.DicSession
    if NetDic.Count > 0 then
        log("Dele NetManager.DicSession")
        local keys = NetDic.Keys
        local iter = keys:GetEnumerator()
        while iter:MoveNext() do
            local id = iter.Current
            local flag, v = NetDic:TryGetValue(id, nil)
            if flag == true then
                local flag, session = NetDic:TryGetValue(id, nil)
                if flag then
                    session:Dispose()
                end
            end
        end
        NetDic:Clear()
    end
end