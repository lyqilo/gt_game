-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion

--require(g_sSlotModuleNum .. "Slot/SlotBase")

WPBY_Network = {};
local self = WPBY_Network;

self.SUB_C_PRESS_SHOOT = 50100;                   --发射子弹
self.SUB_C_HITED_FISH = 50101;                    --玩家命中
self.SUB_C_CHANGEBULLETLEVEL = 50102;                               --切换炮台等级

self.SUB_C_SHUIHUZHUAN = 50103;                 --击中水浒传
self.SUB_C_YUWANG = 50104;                      --打死鱼王
self.SUB_C_TONGLEIZHADAN = 50105;                       --打死同类炸弹
self.SUB_C_JUBUZHADAN = 50106;                      --打死局部炸弹
self.SUB_C_PlayerLock = 50107;--玩家开始锁定
self.SUB_C_PlayerCancalLock = 50108;--玩家取消锁定


self.SUB_S_GAME_START = 50001;                       --游戏开始
self.SUB_S_ADD_FISH = 50002;                         --增加鱼
self.SUB_S_FISH_DEAD = 50003;                        --鱼死亡
self.SUB_S_PLAYER_SHOOT = 50004;                     --玩家发炮
self.SUB_S_CONFIG = 50005;                     --配置信息
self.SUB_S_CHANGEBULLETLEVEL = 50006;                           --切换炮台等级
self.SUB_S_SHUIHUZHUAN = 50007;             --打死水浒传
self.SUB_S_ZHONGYITANG = 50008;             --打死忠义堂
self.SUB_S_DASANYUAN = 50009;                   --打死大三元
self.SUB_S_DASIXI = 50010;              --打死大四喜
self.SUB_S_YUWANG = 50011;              --打死鱼王
self.SUB_S_TONGLEIZHADAN = 50012;                   --打死同类炸弹
self.SUB_S_YIWANGDAJIN = 50013;               --打死一网打尽
self.SUB_S_JUBUZHADAN = 50014;              --打死局部炸弹
self.SUB_S_PLAYERENTER = 50015;                         --玩家进入
self.SUB_S_SHOOT_LK = 50016;                        --击中李逵
self.SUB_S_YUCHAOCOME = 50017;                              --鱼潮来临
self.SUB_S_YUCHAOPRE = 50018;                       --鱼潮即将来临
self.SUB_S_PLAYERGUNLEVEL = 50019;                              --玩家炮台信息
self.SUB_S_PlayerLock = 50020;                              --玩家锁定
self.SUB_S_PlayerCancalLock = 50021;                                --玩家取消锁定
self.SUB_S_RobotCome = 50022;                                --机器人进入
self.SUB_S_RobotList = 50023;                       --机器人列表
self.SUB_S_RobotShoot = 50024;                          --机器人发炮

function WPBY_Network.AddMessage()
    EventCallBackTable._01_GameInfo = self.OnHandleGameInfo;
    EventCallBackTable._02_ScenInfo = self.OnHandleSceneInfo;
    EventCallBackTable._03_LogonSuccess = self.OnHandleLoginSuccess;
    EventCallBackTable._04_LogonOver = self.OnHandleLoginCompleted;
    EventCallBackTable._05_LogonFailed = self.OnHandleLoginFailed;
    EventCallBackTable._07_UserEnter = self.OnHandleUserEnter;
    EventCallBackTable._08_UserLeave = self.OnHandleUserLeave;
    EventCallBackTable._10_UserScore = self.OnHandleUserScore;
    EventCallBackTable._11_GameQuit = self.OnHandleGameQuit;
    EventCallBackTable._12_OnSit = self.OnHandleSitSeat;
    EventCallBackTable._14_RoomBreakLine = self.OnHandleBreakRoomLine;
    EventCallBackTable._15_OnBackGame = self.OnHandleBackGame;
    EventCallBackTable._16_OnHelp = self.OnHandleHelp;
    MessgeEventRegister.Game_Messge_Reg(EventCallBackTable)
end
function WPBY_Network.UnMessage()
    MessgeEventRegister.Game_Messge_Un();
end

function WPBY_Network.LoginGame()
    --登录游戏
    log("登录游戏");
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
function WPBY_Network.PrepareGame()
    --准备
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
end
function WPBY_Network.InSeat()
    --入座
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
end
function WPBY_Network.OnHandleGameInfo(wMainID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMainID)) + 1, string.len(tostring(wSubID))));
    --游戏消息
    if sid == self.SUB_S_CONFIG then
        --初始场景
        --获取配置
        WPBY_Struct.CMD_S_CONFIG.bulletScore = {};
        for i = 1, WPBY_DataConfig.BULLET_COUNT do
            table.insert(WPBY_Struct.CMD_S_CONFIG.bulletScore, buffer:ReadInt32());
        end
        WPBY_Struct.CMD_S_CONFIG.bGID = buffer:ReadByte();
        WPBY_Struct.CMD_S_CONFIG.playerLockFishID = {};
        for i = 1, WPBY_DataConfig.GAME_PLAYER do
            table.insert(WPBY_Struct.CMD_S_CONFIG.playerLockFishID, buffer:ReadInt32());
        end
        WPBY_Struct.CMD_S_CONFIG.playerCurScore = {};
        for i = 1, WPBY_DataConfig.GAME_PLAYER do
            table.insert(WPBY_Struct.CMD_S_CONFIG.playerCurScore, tonumber(buffer:ReadInt64Str()));
        end
        WPBYEntry.InitPanel(WPBY_Struct.CMD_S_CONFIG);
        WPBY_PlayerController.OnInitBulltSeting(WPBY_Struct.CMD_S_CONFIG.bulletScore);
        logTable(WPBY_Struct.CMD_S_CONFIG)
        log("获取配置成功");
    elseif sid == self.SUB_S_PLAYERGUNLEVEL then
        --玩家炮台信息
        log("初始化炮台")

        WPBY_Struct.CMD_S_PlayerGunLevel.GunLevel = {};
        for i = 1, WPBY_DataConfig.GAME_PLAYER do
            table.insert(WPBY_Struct.CMD_S_PlayerGunLevel.GunLevel, buffer:ReadInt32());
        end
        logTable(WPBY_Struct.CMD_S_PlayerGunLevel)
        WPBY_PlayerController.SetPlayerGunLevel(WPBY_Struct.CMD_S_PlayerGunLevel.GunLevel);
        GameManager.isEnterGame=true
    elseif sid == self.SUB_S_PLAYERENTER then
        --玩家进入
        local playerenter = {};
        setmetatable(playerenter, { __index = WPBY_Struct.CMD_S_PlayerEnter });
        playerenter.szSize = buffer:ReadInt32();
        playerenter.szLoadFish = {};
        for i = 1, WPBY_DataConfig.MAX_FISH_COUNT do
            local loadfish = {};
            setmetatable(loadfish, { __index = WPBY_Struct.LoadFish });
            loadfish.Kind = buffer:ReadByte();
            loadfish.id = buffer:ReadInt32();
            loadfish.CreateTime = buffer:ReadInt32();
            loadfish.EndTime = buffer:ReadInt32();
            loadfish.fishPoint = {};
            for j = 1, WPBY_DataConfig.MAX_FISH_POINT do
                local FishPoint = {};
                setmetatable(FishPoint, { __index = WPBY_Struct.FishPoint });
                FishPoint.x = buffer:ReadInt32();
                FishPoint.y = buffer:ReadInt32();
                table.insert(loadfish.fishPoint, FishPoint);
            end
            loadfish.NowTime = buffer:ReadInt32();
            loadfish.odd = buffer:ReadInt32();
            table.insert(playerenter.szLoadFish, loadfish);
            WPBYEntry.ShowTip(loadfish.Kind);
        end
        logTable(playerenter)
        WPBY_FishController.InitFish(playerenter);
        log("玩家进入")
    elseif sid == self.SUB_S_ADD_FISH then
        --增加鱼
        local fish = {};
        setmetatable(fish, { __index = WPBY_Struct.CMD_S_AddFish });
        fish.FishCount = buffer:ReadInt32();
        fish.loadFishList = {};
        for i = 1, 20 do
            local loadfish = {};
            setmetatable(loadfish, { __index = WPBY_Struct.LoadFish });
            loadfish.Kind = buffer:ReadByte();
            loadfish.id = buffer:ReadInt32();
            loadfish.CreateTime = buffer:ReadInt32();
            loadfish.EndTime = buffer:ReadInt32();
            loadfish.fishPoint = {};
            for j = 1, WPBY_DataConfig.MAX_FISH_POINT do
                local FishPoint = {};
                setmetatable(FishPoint, { __index = WPBY_Struct.FishPoint });
                FishPoint.x = buffer:ReadInt32();
                FishPoint.y = buffer:ReadInt32();
                table.insert(loadfish.fishPoint, FishPoint);
            end
            loadfish.NowTime = buffer:ReadInt32();
            loadfish.odd = buffer:ReadInt32();
            table.insert(fish.loadFishList, loadfish);
            WPBYEntry.ShowTip(loadfish.Kind);
        end
        WPBY_FishController.SetFish(fish);
        WPBYEntry.heidongEffect.gameObject:SetActive(false);
    elseif sid == self.SUB_S_PLAYER_SHOOT then
        --玩家发炮
        local pao = {};
        setmetatable(pao, { __index = WPBY_Struct.CMD_S_PlayerShoot });
        pao.wChairID = buffer:ReadInt32();
        pao.x = buffer:ReadFloat();
        pao.y = buffer:ReadFloat();
        pao.level = buffer:ReadInt32();
        pao.playCurScore = tonumber(buffer:ReadInt64Str());
        WPBY_PlayerController.ShootBullet(pao);
    elseif sid == self.SUB_S_FISH_DEAD then
        --鱼被打死
        local fishdead = {};
        setmetatable(fishdead, { __index = WPBY_Struct.CMD_S_FishDead });
        fishdead.wChairID = buffer:ReadInt32();
        fishdead.fish = {}; --鱼ID
        for i = 1, WPBY_DataConfig.MAX_FISH_BUFFER do
            local fish = { id = 0, score = 0 };
            fish.id = buffer:ReadInt32();
            fish.score = buffer:ReadInt32();
            table.insert(fishdead.fish, fish);
        end
        fishdead.score = tonumber(buffer:ReadInt64Str()); --当前分数
        WPBY_FishController.FishDead(fishdead);
    elseif sid == self.SUB_S_CHANGEBULLETLEVEL then
        --改变炮台等级
        local changeLevel = {};
        setmetatable(changeLevel, { __index = WPBY_Struct.CMD_S_ChangeBulletLevel });
        changeLevel.wChairID = buffer:ReadInt32();
        changeLevel.isAdd = buffer:ReadByte();
        local player = WPBY_PlayerController.GetPlayer(changeLevel.wChairID);
        if player ~= nil then
            player:ChangePTLevel(changeLevel.isAdd);
        end
    elseif sid == self.SUB_S_YUCHAOPRE then
        --鱼潮即将来临
        local backId = buffer:ReadByte();
        WPBYEntry.ShowTip(-1);
        WPBY_FishController.SetAddSpeed();
        WPBY_GoldEffect.OnChangeBGYuChao(backId);
        WPBYEntry.isYc = true;
    elseif sid == self.SUB_S_YUCHAOCOME then
        --鱼潮来临
        log("鱼潮来了");
        WPBYEntry.isYc = false;
        local ycdata = {};
        setmetatable(ycdata, { __index = WPBY_Struct.CMD_S_YuChaoCome });
        ycdata.YuChaoId = buffer:ReadByte();
        ycdata.fishTide = {};
        setmetatable(ycdata.fishTide, { __index = WPBY_Struct.FishTide });
        ycdata.fishTide.fishTideStartTime = tonumber(buffer:ReadInt64Str());
        ycdata.fishTide.fishTideCurTime = tonumber(buffer:ReadInt64Str());
        ycdata.fishTide.Rotate = buffer:ReadByte();
        ycdata.fishTide.lineNum = buffer:ReadInt32();
        ycdata.fishTide.fishLines = {};
        for i = 1, 50 do
            local fishLineInfo = {};
            setmetatable(fishLineInfo, { __index = WPBY_Struct.FishLineInfo });
            fishLineInfo.line = {};
            setmetatable(fishLineInfo.line, { __index == WPBY_Struct.LineInfo });
            fishLineInfo.line.type = buffer:ReadUInt32();
            fishLineInfo.line.Points = {};
            setmetatable(fishLineInfo.line.Points, { __index = WPBY_Struct.FishPoint });
            for j = 1, 6 do
                local point = { x = 0, y = 0 };
                point.x = buffer:ReadInt32();
                point.y = buffer:ReadInt32();
                table.insert(fishLineInfo.line.Points, point);
            end
            fishLineInfo.Kind = buffer:ReadInt32();
            fishLineInfo.startDelayTime = buffer:ReadInt32();
            fishLineInfo.delayTime = buffer:ReadInt32();
            fishLineInfo.fishNum = buffer:ReadInt32();
            fishLineInfo.livedTime = buffer:ReadInt32();
            table.insert(ycdata.fishTide.fishLines, fishLineInfo);
        end
        logTable(ycdata);
        WPBY_FishController.OnJoinFishTide(ycdata);
        log("鱼潮");
    elseif sid == self.SUB_S_ZHONGYITANG then
        --打死忠义堂
        local zhongyidead = {};
        setmetatable(zhongyidead, { __index = WPBY_Struct.CMD_S_ZhongYiTang });
        zhongyidead.wChairID = buffer:ReadInt32();
        zhongyidead.time = buffer:ReadByte();
        WPBY_FishController.OnZYTDie(zhongyidead);
    elseif sid == self.SUB_S_SHUIHUZHUAN then
        --打死水浒传
        local shuihuzhuanDead = {};
        setmetatable(shuihuzhuanDead, { __index = WPBY_Struct.CMD_S_ShuiHuZhuan })
        shuihuzhuanDead.wChairID = buffer:ReadInt32();
        shuihuzhuanDead.fishid = buffer:ReadInt32();
        WPBY_FishController.OnSHZDie(shuihuzhuanDead);
    elseif sid == self.SUB_S_JUBUZHADAN then
        --打死局部炸弹
        local jubuzhadan = {};
        setmetatable(jubuzhadan, { __index = WPBY_Struct.CMD_S_JuBuZhaDan });
        jubuzhadan.wChairID = buffer:ReadInt32();
        jubuzhadan.fishid = buffer:ReadInt32();
        WPBY_FishController.OnJBZDDie(jubuzhadan);
    elseif sid == self.SUB_S_DASIXI then
        --打死大四喜
        local dsx = {};
        setmetatable(dsx, { __index = WPBY_Struct.CMD_S_DaSiXi });
        dsx.fish_id = buffer:ReadInt32();
        dsx.wChairID = buffer:ReadInt32();
        dsx.score = buffer:ReadInt32();
        WPBY_FishController.OnDSXDie(dsx);
    elseif sid == self.SUB_S_DASANYUAN then
        local dsy = {};
        setmetatable(dsy, { __index = WPBY_Struct.CMD_S_DaSanYuan });
        dsy.fish_id = buffer:ReadInt32();
        dsy.wChairID = buffer:ReadInt32();
        dsy.score = buffer:ReadInt32();
        WPBY_FishController.OnDSYDie(dsy);
    elseif sid == self.SUB_S_SHOOT_LK then
        --击中李逵
        local lk = {};
        setmetatable(lk, { __index = WPBY_Struct.CMD_S_ShootLK });
        lk.site = buffer:ReadInt32();
        lk.id = buffer:ReadInt32();
        lk.score = buffer:ReadInt32();
        lk.Multiple = buffer:ReadInt32();
        WPBY_FishController.OnShotLK(lk);
    elseif sid == self.SUB_S_PlayerLock then
        --玩家锁定
        local playerlock = {};
        setmetatable(playerlock, { __index = WPBY_Struct.CMD_S_PlayerLock });
        playerlock.chairId = buffer:ReadByte();
        playerlock.fishId = buffer:ReadInt32();
        WPBY_PlayerController.OnLockFish(playerlock);
    elseif sid == self.SUB_S_PlayerCancalLock then
        --玩家取消锁定
        local playercancellock = {};
        setmetatable(playercancellock, { __index = WPBY_Struct.CMD_S_PlayerCancalLockLock });
        playercancellock.chairId = buffer:ReadByte();
        WPBY_PlayerController.OnCancalLock(playerlock);
    elseif sid == self.SUB_S_YUWANG then
        --打死鱼王
        local ywdead = {};
        setmetatable(ywdead, { __index = WPBY_Struct.CMD_S_YuWang });
        ywdead.wChairID = buffer:ReadInt32();
        ywdead.kind = buffer:ReadInt32();
        ywdead.kingID = buffer:ReadInt32();
        ywdead.fish = {};
        for i = 1, 40 do
            local loadfish = {};
            setmetatable(loadfish, { __index = WPBY_Struct.LoadFish });
            loadfish.Kind = buffer:ReadByte();
            loadfish.id = buffer:ReadInt32();
            loadfish.CreateTime = buffer:ReadInt32();
            loadfish.EndTime = buffer:ReadInt32();
            loadfish.fishPoint = {};
            for j = 1, 6 do
                local point = {};
                setmetatable(point, { __index = WPBY_Struct.FishPoint });
                point.x = buffer:ReadInt32();
                point.y = buffer:ReadInt32();
                table.insert(loadfish.fishPoint, point);
            end
            loadfish.NowTime = buffer:ReadInt32();
            loadfish.odd = buffer:ReadInt32();
            table.insert(ywdead.fish, loadfish);
        end
        WPBY_FishController.OnYWDie(ywdead);
    elseif sid == self.SUB_S_YIWANGDAJIN then
        local ywdj = {};
        setmetatable(ywdj, { __index = WPBY_Struct.CMD_S_YiWangDaJin });
        ywdj.wChairID = buffer:ReadInt32();
        ywdj.bullt = buffer:ReadInt32();
        WPBY_FishController.OnYWDJDie(ywdj);
    elseif sid == self.SUB_S_TONGLEIZHADAN then
        local tlzd = {};
        setmetatable(tlzd, { __index = WPBY_Struct.CMD_S_TongLeiZhaDan });
        tlzd.wChairID = buffer:ReadInt32();
        tlzd.fishid = buffer:ReadInt32();
        tlzd.kind = buffer:ReadInt32();
        WPBY_FishController.OnTLZDDie(tlzd);
    elseif sid == self.SUB_S_RobotCome then
        local jqrjr = {};
        setmetatable(jqrjr, { __index = WPBY_Struct.CMD_S_RobotCome });
        jqrjr.chairID = buffer:ReadInt32();
        local player = WPBY_PlayerController.GetPlayer(jqrjr.chairID);
        if player ~= nil then
            player.isRobot = true;
        end
    elseif sid == self.SUB_S_RobotList then
        local robotlist = {};
        setmetatable(robotlist, { __index = WPBY_Struct.CMD_S_RobotList });
        robotlist.isRobot = {};
        for i = 1, WPBY_DataConfig.GAME_PLAYER do
            table.insert(robotlist.isRobot, buffer:ReadByte());
        end
        for i = 1, #robotlist.isRobot do
            if robotlist.isRobot[i] == 1 then
                local player = WPBY_PlayerController.GetPlayer(i - 1);
                if player ~= nil then
                    player.isRobot = true;
                end
            end
        end
    elseif sid == self.SUB_S_RobotShoot then
        local robotShoot = {};
        setmetatable(robotShoot, { __index = WPBY_Struct.CMD_S_RobotShoot });
        robotShoot.chairId = buffer:ReadByte();
        robotShoot.level = buffer:ReadByte();
        robotShoot.isLock = buffer:ReadByte();
        logTable(robotShoot)
        local player = WPBY_PlayerController.GetPlayer(robotShoot.chairId);
        if player ~= nil then
            player.isRobot = true;
            player.IsLock = true;
            player.isRobotIsLock = true;
            player:StopContinueFire();
            local fish = WPBY_FishController.OnGetRandomLookFish(true);
            if fish ~= nil then
                player.LockFish = fish;
                player:OnSetUserGunLevel(robotShoot.level);
                player:IsRobotLockFish();
                player.dir = fish.transform.position;
                player:ContinueFire(WPBY_PlayerController.acceleration, WPBY_PlayerController.acceleration);
            else
                WPBYEntry.DelayCall(0.5, function()
                    fish = WPBY_FishController.OnGetRandomLookFish(true);
                    if fish ~= nil then
                        player.LockFish = fish;
                        player:IsRobotLockFish();
                        player:OnSetUserGunLevel(robotShoot.level);
                        player.dir = fish.transform.position;
                        player:ContinueFire(WPBY_PlayerController.acceleration, WPBY_PlayerController.acceleration);
                    end
                end);
            end
        end
    end
end
function WPBY_Network.OnHandleSceneInfo(wMainID, wSubID, buffer, wSize)
    --场景消息
    log("============收到场景消息");
    WPBYEntry.InitPanel();
end
function WPBY_Network.OnHandleLoginSuccess(wMainID, wSubID, buffer, wSize)
    --登录成功消息
    log("登录游戏成功");
end
function WPBY_Network.OnHandleLoginCompleted(wMainID, wSubID, buffer, wSize)
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
function WPBY_Network.OnHandleLoginFailed(wMainID, wSubID, buffer, wSize)
    --登录失败
    local str = buffer:ReadString(wSize);
    log("登录失败：" .. str);
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
end
function WPBY_Network.OnHandleUserEnter(wMainID, wSubID, buffer, wSize)
    --玩家进入
    log("玩家进入=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._7wGold);
    log("玩家头像=========" .. TableUserInfo._5szHeaderExtensionName);
    --TODO 设置金币数量
    if TableUserInfo._1dwUser_Id == SCPlayerInfo._01dwUser_Id then
        WPBYEntry.ChairID = TableUserInfo._9wChairID;
        WPBYEntry.myGold = TableUserInfo._7wGold;
    end
    local userInfo = {
        _1dwUser_Id = TableUserInfo._1dwUser_Id,
        _2szNickName = TableUserInfo._2szNickName,
        _3bySex = TableUserInfo._3bySex,
        _4bCustomHeader = TableUserInfo._4bCustomHeader,
        _5szHeaderExtensionName = TableUserInfo._5szHeaderExtensionName,
        _6szSign = TableUserInfo._6szSign,
        _7wGold = TableUserInfo._7wGold,
        _8wPrize = TableUserInfo._8wPrize,
        _9wChairID = TableUserInfo._9wChairID,
        _10wTableID = TableUserInfo._10wTableID,
        _11byUserStatus = TableUserInfo._11byUserStatus,
    };
    logTable(userInfo)
    table.insert(WPBYEntry.UserList, userInfo);
    WPBY_PlayerController.InitPlayer(userInfo);
end
function WPBY_Network.OnHandleUserLeave(wMainID, wSubID, buffer, wSize)
    log("玩家离开=========" .. TableUserInfo._1dwUser_Id .. " " .. TableUserInfo._9wChairID);
    for i = 1, #WPBYEntry.UserList do
        if WPBYEntry.UserList[i]._9wChairID == TableUserInfo._9wChairID then
            local player = WPBY_PlayerController.GetPlayer(TableUserInfo._9wChairID);
            if player ~= nil then
                player:Leave();
            end
            table.remove(WPBYEntry.UserList, i);
        end
    end
end
function WPBY_Network.OnHandleUserScore(wMainID, wSubID, buffer, wSize)
    --玩家分数
    if TableUserInfo._1dwUser_Id == SCPlayerInfo._01dwUser_Id then
        WPBYEntry.myGold = TableUserInfo._7wGold;
        WPBY_PlayerController.GetPlayer(WPBYEntry.ChairID).userGold.text = tostring(WPBYEntry.myGold);
    end
end
function WPBY_Network.OnHandleGameQuit(wMainID, wSubID, buffer, wSize)
    --退出游戏
    --destroy(WPBYEntry.gameObject);
    GameSetsBtnInfo.LuaGameQuit();
end
function WPBY_Network.OnHandleSitSeat(wMainID, wSubID, buffer, wSize)
    --入座
    if wSize > 0 then
        local str = buffer:ReadString(wSize);
        HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
    else
        self.PrepareGame();
    end
end
function WPBY_Network.OnHandleBreakRoomLine(wMainID, wSubID, buffer, wSize)
    --断线
end
function WPBY_Network.OnHandleBackGame(wMainID, wSubID, buffer, wSize)
    --返回游戏
end
function WPBY_Network.OnHandleHelp(wMainID, wSubID, buffer, wSize)
    --帮助
end