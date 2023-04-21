NiuNiuSCInfo = { };
local self = NiuNiuSCInfo;
local IsHomeBack=false;
--初始化消息结构体
function NiuNiuSCInfo.AddGameMessage()
    MessgeEventRegister.Game_Messge_Un(); --清除消息事件
    local t = EventCallBackTable;
    t._01_GameInfo = self.OnHandleGameInfo; --游戏消息
    t._02_ScenInfo = self.OnHandleScenInfo; --场景消息
    t._03_LogonSuccess = self.OnGameLogonWin; --登陆成功
    t._04_LogonOver = self.LogonOverMethod; --登陆完成
    t._05_LogonFailed = self.LogonFailed; --登陆失败
    t._06_Biao_Action = self.OnBiaoAction; --表情
    t._07_UserEnter = self.OnPlayerEnter; --用户进入
    t._08_UserLeave = self.OnPlayerLeave; --用户离开
    t._09_UserStatus = self.OnPlayerStatus; --用户状态
    t._10_UserScore = self.OnPlayerScore; --用户分数
    t._11_GameQuit = self.OnGameQuit; --退出游戏
    t._12_OnSit = self.OnInSitOver; --用户入座
    t._13_ChangeTable = self.OnChageTable;  --换桌
    t._14_RoomBreakLine = self.OnRoomBreakLine; --断线消息
    t._15_OnBackGame=self.HomeBackGame;--home键返回
    t._16_OnHelp=self.OpenHelp;
    t._17_OnStopGame=self.OnStopGame;--Home键按下状态
    t._18_OnHandleMessage=self.OnHandleMessage;--网络异常处理
    MessgeEventRegister.Game_Messge_Reg(t);--添加消息
end

self.ReLogon = false;
self.LogonNum = 0;

function NiuNiuSCInfo.OnHandleMessage()
    --error(" -- 重新连接");
    if self.ReLogon then return end
    self.ReLogon = true;
    
    if self.LogonNum > 3 then self.RoomBreakQuit("网络异常，重连失败！") self.ReLogon = false; self.LogonNum = 0; return end
    -- table.insert(ReturnNotShowError, "95003");
    -- Network.Close(gameSocketNumber.GameSocket)
    Network.Close(gameSocketNumber.GameSocket)
    HallScenPanel.ReLoadGame(self.ReLoadGame);
    self.LogonNum = self.LogonNum + 1;

    local function checkSuccess()
        local i = 0;
        repeat
            coroutine.wait(1);
            i = i + 1;
            if i > 5 then Network.OnException(10001); self.ReLogon = false return end
        until (not self.ReLogon)
    end
end

--加载帮助界面
function NiuNiuSCInfo.OpenHelp()
  -- LoadAssetCacheAsync('module18/game_niuniuhelptwo', 'Help_NiuNiu', NiuNiuPanel.CreatHelp);
  NiuNiuPanel.CreatHelp(Module03Panel.Pool("Help_NiuNiu"));
end


--用户登陆
function NiuNiuSCInfo.gamelogon()
    error("用户登陆");
    IsHomeBack = false;
    self.AddGameMessage();
    local data =
    {
        [1] = 0,
        -- 广场版本 暂时不用
        [2] = 0,
        -- 进程版本 暂时不用
        [3] = SCPlayerInfo._01dwUser_Id,
        -- 用户 I D
        [4] = SCPlayerInfo._06wPassword,
        -- 登录密码 MD5小写加密
        [5] = Opcodes,
        -- 机器序列 暂时不用
        [6] = 0,
        [7] = 0,
    }
    local buffer = SetC2SInfo(NiuNiuMH.CMD_GR_LogonByUserID, data);
    --Network.Send(MH.MDM_GR_LOGON, MH.SUB_GR_LOGON_USERID, buffer, gameSocketNumber.GameSocket);
    Network.Send(MH.MDM_GR_LOGON, 3, buffer, gameSocketNumber.GameSocket);
end

-- 登陆完成消息
function NiuNiuSCInfo.LogonOverMethod(wMain, wSubID, buffer, wSize)
    if (65535 == NiuNiuMH.MySelf_ChairID) then
        --error(" -- 不在桌子上");
        local buffer = ByteBuffer.New()
        Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
    else
        --error(" -- 若在桌子上 则直接发送玩家准备");
        NiuNiu_IsGameStartIn=false;
        self.PlayerPrepare();
    end
    self.LogonNum=0;
end

--用户准备
function  NiuNiuSCInfo.PlayerPrepare()    
    local Data = { [1] = 0, }
    -- 旁观标志 必须等于0
    local buffer = SetC2SInfo(NiuNiuMH.CMD_GF_Info, Data);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
    error("=========用户准备===========")
end

--入座完成
function NiuNiuSCInfo.OnInSitOver(wMaiID, wSubID, buffer, wSize)
    if(wSize > 0) then
        error("=============入座失败=============");
        --error(buffer:ReadString(wSize));
        Network.OnException(buffer:ReadString(wSize),1);
    elseif(wSize == 0) then
        error("=============入座成功=============");
        self.PlayerPrepare();
    end   
end

--登陆成功
function NiuNiuSCInfo.OnGameLogonWin(wMaiID, wSubID, buffer, wSize)
  error("=============登陆成功============= " .. TableUserInfo._9wChairID); 
    NiuNiuMH.MySelf_ChairID=TableUserInfo._9wChairID;
end

-- 登陆失败消息
function NiuNiuSCInfo.LogonFailed(wMain, wSubID, buffer, wSize)
    error("=============登陆失败=============");
    --error(buffer:ReadString(wSize));
    Network.OnException(buffer:ReadString(wSize),1);
end

--游戏消息（if 连续两个Id不同 then 保数据接收小于1秒)
function NiuNiuSCInfo.OnHandleGameInfo(wMain, wSubID, buffer, wSize)
    error("=============游戏消息================");
    local id = string.gsub(wSubID, wMain, "");
    id = tonumber(id);
    error("=============id================"..id);

    NiuNiuPanel.GameInfo(id, buffer)
end

function NiuNiuSCInfo.WaitTimeSetInfo()
    coroutine.wait(1);
    IsHomeBack=false;
end

-- 场景消息
function NiuNiuSCInfo.OnHandleScenInfo(wMain, wSubID, buffer, wSize)
    error("接受场景消息")
    error("=============场景消息=============wSize==="..wSize);
    NiuNiuMH.IsBankerLeave=false;
    local ScenInfoTable = { };--场景消息
    
    NiuNiuMH.Game_State = buffer:ReadByte();
    --error("=============游戏状态================" .. NiuNiuMH.Game_State);
    table.insert(ScenInfoTable, NiuNiuMH.Game_State);

    -- 当前状态经过的总时间
    local passTime = buffer:ReadUInt32();
    --error("=============游戏经过的时间================" .. passTime);
    table.insert(ScenInfoTable, passTime);

    -- 庄家座位号
    NiuNiuMH.Banker_ChairID = buffer:ReadUInt16();
    --error("=============庄家座位号================" .. NiuNiuMH.Banker_ChairID);
    table.insert(ScenInfoTable, NiuNiuMH.Banker_ChairID);

    --for i = 1, NiuNiuMH.GAME_PLAYER do
        local playerdata = { };
        local chairid = buffer:ReadUInt16();
        --error("=============座位号================" .. chairid);
        table.insert(playerdata, chairid);

        local IsGame=buffer:ReadByte();
        --error("=============是否游戏================" .. IsGame);
        table.insert(playerdata, IsGame);
        
        local bOperate = buffer:ReadByte();
        --error("=============是否操作================" .. bOperate);
        table.insert(playerdata, bOperate);

        local bRobBanker = buffer:ReadByte();
        --error("=============抢庄================" .. bRobBanker);
        table.insert(playerdata, bRobBanker);

         local i64ChipValue = tonumber(buffer:ReadInt64Str());
         --error("=============下注倍数================" .. i64ChipValue);
         table.insert(playerdata, i64ChipValue);
        

        local byNiuNiuPoint = buffer:ReadByte();
        table.insert(playerdata, byNiuNiuPoint);
       --error("=============牛牛点数================" .. byNiuNiuPoint);

         local byNiuNiuPoker = { };
         for i = 1, NiuNiuMH.D_PLAYER_POKER_COUNT do
           table.insert(byNiuNiuPoker, buffer:ReadByte());
           --error("扑克数据["..i.."]===================="..byNiuNiuPoker[#byNiuNiuPoker]);
         end
        table.insert(playerdata, byNiuNiuPoker);

        --赢得金币
        local WinScroe =  tonumber(buffer:ReadInt64Str());
        --error("=============WinScroe================" .. WinScroe);
        table.insert(playerdata, WinScroe);

        --赢得次数
        local winCount= buffer:ReadInt32();
        --error("=============winCount================" .. winCount);
        table.insert(playerdata, winCount);

        --牛牛次数
        local niuniuCount= buffer:ReadInt32();
        --error("=============niuniuCount================" .. niuniuCount);
        table.insert(playerdata, niuniuCount);

        --总赢金币
        local allwinorlose= tonumber(buffer:ReadInt64Str());
        --error("=============allwinorlose================" .. allwinorlose);
        table.insert(playerdata, allwinorlose);
        table.insert(ScenInfoTable, playerdata);
         -- 添加到表里，传给player 赋值初始化（有问题需要用表存储）
    --end
    error("场景消息")
    NiuNiuPanel.InitScen(ScenInfoTable);
end

--表情--***
function NiuNiuSCInfo.OnBiaoAction(wMain, wSubID, buffer, wSize)
    local sChairId = buffer:ReadUInt16();
    local sIndex = buffer:ReadByte();
    local posnum =(sChairId - NiuNiuMH.MySelf_ChairID);
    if posnum < 0 then posnum = posnum + NiuNiuMH.GAME_PLAYER end
    posnum = posnum + 1;
    NiuNiuAllPlayerTable[posnum]:PlayerBiaoQing(sIndex);
end

-- 用户进入
function NiuNiuSCInfo.OnPlayerEnter(wMain, wSubID, buffer, wSize)
    --error("通知用户进入桌子=================");
    local data = { };
    data = TableUserInfo;
    local newdata =
    {
        _1dwUser_Id = data._1dwUser_Id,
        _2szNickName = data._2szNickName,
        _3bySex = data._3bySex,
        _4bCustomHeader = data._4bCustomHeader,
        _5szHeaderExtensionName = data._5szHeaderExtensionName,
        _6szSign = data._6szSign,
        _7wGold = data._7wGold,
        _8wPrize = data._8wPrize,
        _9wChairID = data._9wChairID,
        _10wTableID = data._10wTableID,
        _11byUserStatus = data._11byUserStatus,
        _12wScore = 0;
    };
    NiuNiuMH.PlayerScore=newdata._7wGold;
    NiuNiuUserInfoTable[newdata._9wChairID + 1] = newdata;
    if newdata._1dwUser_Id == SCPlayerInfo._01dwUser_Id then 
        NiuNiuMH.MySelf_ChairID = newdata._9wChairID 
    end
    local posnum =(newdata._9wChairID-NiuNiuMH.MySelf_ChairID);
    if posnum <0 then posnum = posnum + NiuNiuMH.GAME_PLAYER end
    posnum=posnum+1;
    --error("设置用户进入状态=========================="..posnum);
    NiuNiuAllPlayerTable[posnum]:InitInfo(newdata._9wChairID);--1
    logTable(NiuNiuAllPlayerTable)

end

--用户离开
function NiuNiuSCInfo.OnPlayerLeave(wMain, wSubID, buffer, wSize)
    --error("通知用户已经离开桌子=================");
    local data = { };
    data = TableUserInfo;
    local newdata =
    {
        _1dwUser_Id = data._1dwUser_Id,
        _2szNickName = data._2szNickName,
        _3bySex = data._3bySex,
        _4bCustomHeader = data._4bCustomHeader,
        _5szHeaderExtensionName = data._5szHeaderExtensionName,
        _6szSign = data._6szSign,
        _7wGold = data._7wGold,
        _8wPrize = data._8wPrize,
        _9wChairID = data._9wChairID,
        _10wTableID = data._10wTableID,
        _11byUserStatus = data._11byUserStatus,
        _12wScore = 0;
    };
    local leaverid=0;
    for i=1,#NiuNiuUserInfoTable do 
        if NiuNiuUserInfoTable[i]._1dwUser_Id==data._1dwUser_Id  then
            leaverid=NiuNiuUserInfoTable[i]._9wChairID 
        end
    end
    local posnum =(leaverid-NiuNiuMH.MySelf_ChairID);
    if posnum <0 then posnum = posnum + NiuNiuMH.GAME_PLAYER end
    posnum=posnum+1;
    --NiuNiuPanel.SetSta(posnum,data._9wChairID + 1,data._1dwUser_Id);
    NiuNiuAllPlayerTable[posnum]:PlayerLeave();
    NiuNiuUserInfoTable[data._9wChairID + 1] = NiuNiuMH.Start_User_Data;
end

--用户状态
function NiuNiuSCInfo.OnPlayerStatus(wMain, wSubID, buffer, wSize)
    local data = { };
    data = TableUserInfo;
    local newdata =
    {
        _1dwUser_Id = data._1dwUser_Id,
        _2szNickName = data._2szNickName,
        _3bySex = data._3bySex,
        _4bCustomHeader = data._4bCustomHeader,
        _5szHeaderExtensionName = data._5szHeaderExtensionName,
        _6szSign = data._6szSign,
        _7wGold = data._7wGold,
        _8wPrize = data._8wPrize,
        _9wChairID = data._9wChairID,
        _10wTableID = data._10wTableID,
        _11byUserStatus = data._11byUserStatus,
        _12wScore = 0;
    };
    NiuNiuUserInfoTable[data._9wChairID + 1] = newdata;
    local posnum =(newdata._9wChairID - NiuNiuMH.MySelf_ChairID);
    if posnum < 0 then posnum = posnum + NiuNiuMH.GAME_PLAYER end
    posnum = posnum + 1;
    NiuNiuAllPlayerTable[posnum]:PlayerState(newdata._9wChairID);--3
end

--用户分数
function NiuNiuSCInfo.OnPlayerScore(wMain, wSubID, buffer, wSize)
    error("用户分数")
    local data = { };
    data = TableUserInfo;
    local newdata =
    {
        _1dwUser_Id = data._1dwUser_Id,
        _2szNickName = data._2szNickName,
        _3bySex = data._3bySex,
        _4bCustomHeader = data._4bCustomHeader,
        _5szHeaderExtensionName = data._5szHeaderExtensionName,
        _6szSign = data._6szSign,
        _7wGold = data._7wGold,
        _8wPrize = data._8wPrize,
        _9wChairID = data._9wChairID,
        _10wTableID = data._10wTableID,
        _11byUserStatus = data._11byUserStatus,
        _12wScore = 0;
    };

    NiuNiuUserInfoTable[data._9wChairID + 1] = newdata;
    --NiuNiuMH.PlayerScore=newdata._7wGold;
    if NiuNiuMH.IsOver and NiuNiuMH.Banker_ChairID ~= newdata._9wChairID then
        local posnum =(newdata._9wChairID-NiuNiuMH.MySelf_ChairID);
        if posnum <0 then posnum = posnum + NiuNiuMH.GAME_PLAYER end
        posnum=posnum+1;
        NiuNiuAllPlayerTable[posnum]:PlayerScore(newdata._9wChairID,newdata._7wGold);--4
    end    
end

-- 退出游戏
function NiuNiuSCInfo.OnGameQuit(wMain, wSubID, buffer, wSize)
    if NiuNiu_IsPlayingGame then
        NiuNiuPanel.ShowHintInfo();
    else
        NiuNiuPanel.SureBtnOnClick()
    end
end

--换桌
function NiuNiuSCInfo.OnChageTable(wMain, wSubID, buffer, wSize)
end

-- 断线消息
function NiuNiuSCInfo.OnRoomBreakLine(wMain, wSubID, buffer, wSize)
    local msgtype = buffer:ReadUInt16();
    local str = buffer:ReadString(buffer:ReadUInt16());
    self.RoomBreakQuit(str)
    --Network.OnException(buffer:ReadString(wSize), 1);
    --coroutine.start(NiuNiuPanel.DestoryAb)
end

--消息提示
function NiuNiuSCInfo.RoomBreakQuit(str)
    local t = GeneralTipsSystem_ShowInfo;
    t._01_Title = "提    示";
    t._02_Content = str;
    t._03_ButtonNum = 1;
    t._04_YesCallFunction = self.SureQuit;
    t._05_NoCallFunction = self.SureQuit;
    MessageBox.CreatGeneralTipsPanel(t);
end

function NiuNiuSCInfo.SureQuit()
    GameNextScenName = gameScenName.HALL;
    MessgeEventRegister.Game_Messge_Un();
    --NiuNiuPanel.ClearInfo();
    MusicManager:PlayBacksound("end", false);
    --停止背景音乐
    ReturnHallNum = 0;
    ReturnLoginNum = 0;
    TishiScenes = nil;
    --local variable = ByteBuffer.New();
    --Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_LEFT_GAME_REQ, variable, gameSocketNumber.GameSocket);
    -- Network.Close(gameSocketNumber.GameSocket)
    GameSetsBtnInfo.LuaGameQuit();
    -- coroutine.start(NiuNiuPanel.DestoryAb)
end
--Home键开始
self.HomeStartTime=0;
function NiuNiuSCInfo.OnStopGame()
    error("NiuNiuSCInfo.OnStopGame");
    self.HomeStartTime = Util.TickCount;
end

-- Home键返回
function NiuNiuSCInfo.HomeBackGame()
    --error("清理桌面，不接受消息");
    local data = Util.TickCount - self.HomeStartTime
    if data < 5 then return end
    MessgeEventRegister.Game_Messge_Un();
    --    table.insert(ReturnNotShowError, "95003");
    --    Network.Close(gameSocketNumber.GameSocket)
    Network.Close(gameSocketNumber.GameSocket)
    -- coroutine.start(self.WaitTimeSetInfo);
    -- 清除消息事件
    HallScenPanel.ReLoadGame(self.ReLoadGame);
end

function NiuNiuSCInfo.ReLoadGame()
    --error("NiuNiuSCInfo.ReLoadGame()");
    NiuNiuPanel.ClearChip();
    self.ReLogon = false;
    local function waitsecondlogon()
        coroutine.wait(1);
        local infoList = nil;
        for i = 1, #AllSCGameRoom do
            if AllSCGameRoom[i]._9Name == ScenSeverName then infoList = AllSCGameRoom[i]; end
        end
        if infoList == nil then return end
        NiuNiuSCInfo.gamelogon();
    end
    coroutine.start(waitsecondlogon)
end


