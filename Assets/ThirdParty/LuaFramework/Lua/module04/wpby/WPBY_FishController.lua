--鱼类管理
WPBY_FishController = {};
local self = WPBY_FishController;
self.fishDic = {};
self.fishComponentDic = {};

self.nowFishGroup = 0;
self.isLockBigFish = false;
function WPBY_FishController.Init()
    self.fishDic = {};
    self.fishComponentDic = {};
end
function WPBY_FishController.SetFish(data)
    log("开始创建鱼");
    for i = 1, #data.loadFishList do
        if data.loadFishList[i].Kind > 0 then
            self.CreateFish(data.loadFishList[i]);
        end
    end
end
function WPBY_FishController.InitFish(_data)
    log("初始创建鱼");
    local data = { FishCount = _data.szSize, loadFishList = _data.szLoadFish }
    for i = 1, #data.loadFishList do
        if data.loadFishList[i].Kind > 0 then
            self.CreateFish(data.loadFishList[i]);
        end
    end
end
--根据鱼ID生成鱼
function WPBY_FishController.CreateFish(data)
    local fishObj = WPBYEntry.fishCache:Find(WPBY_DataConfig.FishKind[data.Kind]);
    if fishObj == nil then
        local _fish = WPBYEntry.fishPool:Find(WPBY_DataConfig.FishKind[data.Kind]);
        fishObj = newObject(_fish.gameObject);
        fishObj.gameObject.name = WPBY_DataConfig.FishKind[data.Kind];
    end
    local fish = WPBY_Fish:New();
    table.insert(self.fishDic, data.id);
    table.insert(self.fishComponentDic, fish);
    fish:Init(data, fishObj.gameObject);
    local eventtrigger = Util.AddComponent("EventTriggerListener", fishObj.gameObject);
    eventtrigger.onDown = function()
        self.LockFish(data.id);
    end
end
--找鱼
function WPBY_FishController.GetFish(id)
    for i = 1, #self.fishDic do
        if self.fishDic[i] == id then
            return self.fishComponentDic[i];
        end
    end
    return nil;
end
function WPBY_FishController.SetAddSpeed()
    for i = 1, #self.fishComponentDic do
        self.fishComponentDic[i]:QuickSwim();
    end
end
function WPBY_FishController.FishDead(deadFish)
    --鱼死亡
    for i = 1, #deadFish.fish do
        if deadFish.fish[i].id > 0 then
            local fish = WPBY_FishController.GetFish(deadFish.fish[i].id);
            fish:Dead(deadFish.fish[i], deadFish.wChairID);
        end
    end
end
--回收鱼,不销毁
function WPBY_FishController.CollectFish(id, obj)
    for i = 1, #self.fishDic do
        if self.fishDic[i] == id then
            local data = self.fishComponentDic[i];
            obj.gameObject.name = WPBY_DataConfig.FishKind[data.fishData.Kind];
            obj.transform:SetParent(WPBYEntry.fishCache);
            obj.transform.localPosition = Vector3.New(0, 0, 0);
            obj.gameObject:SetActive(false);
            destroy(data.luaBehaviour);
            local eventtrigger = obj.transform:GetComponent("EventTriggerListener");
            if eventtrigger ~= nil then
                destroy(eventtrigger);
            end
            table.remove(self.fishDic, i);
            table.remove(self.fishComponentDic, i);
            return ;
        end
    end
end
--开始鱼潮
function WPBY_FishController.OnJoinFishTide(msg)
    local endTime = 0;
    log(msg.fishTide.fishTideCurTime .. "   " .. msg.fishTide.fishTideStartTime .. "鱼潮已经开始时间");
    if msg.YuChaoId == 3 or msg.YuChaoId == 4 then
        self.YuChaoTime = msg.fishTide.fishTideCurTime;
        if self.YuChaoTime == 0 then
            WPBYEntry.DelayCall(6, function()
                WPBYEntry.heidongEffect.gameObject:SetActive(true);
            end);
        else
            local remain = 6 - msg.fishTide.fishTideCurTime;
            WPBYEntry.DelayCall(remain > 0 and remain or 0, function()
                WPBYEntry.heidongEffect.gameObject:SetActive(true);
            end);
        end
    end
    local index = 101;
    local IsShowHaiLang = true;
    for i = 1, #msg.fishTide.fishLines do
        if msg.fishTide.fishLines[i].fishNum > 0 then
            local last = msg.fishTide.fishLines[i].startDelayTime / 1000;
            for j = 0, msg.fishTide.fishLines[i].fishNum - 1 do
                local cTime = msg.fishTide.fishTideStartTime + msg.fishTide.fishLines[i].startDelayTime + (msg.fishTide.fishLines[i].delayTime * j);
                local nTime = (msg.fishTide.fishTideCurTime - cTime) <= 0 and 0 or ((msg.fishTide.fishTideCurTime - cTime) / 10);
                local indexx = i;
                if nTime > msg.fishTide.fishLines[i].livedTime then
                    index = index + 1;
                    IsShowHaiLang = false;
                else
                    local fish = {};
                    setmetatable(fish, { __index = WPBY_Struct.LoadFish });
                    fish.CreateTime = cTime;
                    fish.EndTime = msg.fishTide.fishLines[indexx].livedTime;
                    fish.fishPoint = msg.fishTide.fishLines[indexx].line.Points;
                    fish.id = index;
                    fish.Kind = msg.fishTide.fishLines[indexx].Kind;
                    fish.NowTime = nTime;
                    fish.odd = 0;

                    WPBYEntry.DelayCall((nTime > 0) and 0 or last, function()
                        self.CreateFish(fish);
                    end);
                    if nTime <= 0 then
                        last = last + msg.fishTide.fishLines[i].delayTime / 1000;
                    end
                    index = index + 1;
                    if endTime == 0 then
                        if (j == msg.fishTide.fishLines[i].fishNum - 1) then
                            endTime = last + msg.fishTide.fishLines[i].livedTime / 1000;
                        end
                    end
                end
            end
            if IsShowHaiLang and msg.fishTide.Rotate ~= 0 then
                IsShowHaiLang = false;
                WPBY_GoldEffect.OnShowHaiLang(msg.YuChaoId, msg.fishTide.Rotate);
            end
        end
    end
end
function WPBY_FishController.SendHitFish(bullet, site, fishIdlist)
    local buffer = ByteBuffer.New();
    buffer:WriteInt(bullet.bulletId);
    buffer:WriteByte(bullet.type);
    buffer:WriteByte(bullet.isUse);
    buffer:WriteByte(bullet.Level);
    buffer:WriteInt(WPBY_Struct.CMD_S_CONFIG.bulletScore[bullet.Level + 1]);
    buffer:WriteInt(site);
    for i = 1, WPBY_DataConfig.MAX_DEAD_FISH do
        if i <= #fishIdlist then
            buffer:WriteInt(fishIdlist[i].fishData.id);
        else
            buffer:WriteInt(0);
        end
    end
    Network.Send(MH.MDM_GF_GAME, WPBY_Network.SUB_C_HITED_FISH, buffer, gameSocketNumber.GameSocket);
end
--忠义堂
function WPBY_FishController.OnZYTDie(data)
    WPBY_PlayerController.OnSetPlayerState(1, data.wChairID);
    if data.wChairID == WPBYEntry.ChairID then
        WPBY_GoldEffect.OnShowSuperPowrEffect(true, data.time, data.wChairID);
    else
        WPBYEntry.DelayCall(data.time, function()
            local player = WPBY_PlayerController.GetPlayer(data.wChairID);
            player:OnJoinSuperPowrModel(false);
        end);
    end
end
function WPBY_FishController.OnSHZDie(data)
    WPBY_GoldEffect.ShuiHuZhuan();
    if data.wChairID == WPBYEntry.ChairID then
        local fishlist = self.OnGetFishToSence();
        local buffer = ByteBuffer.New();
        buffer:WriteInt(data.wChairID);
        buffer:WriteInt(data.fishid);
        for i = 1, WPBY_DataConfig.MAX_FISH_BUFFER do
            if i <= #fishlist then
                --TODO 反回坐标
                buffer:WriteInt(fishlist[i].fishData.id);
                WPBY_NetController.CreateNew(data.wChairID, fishlist[i].transform.position, fishlist[i].fishData.id);
            else
                buffer:WriteInt(0);
            end
        end
        Network.Send(MH.MDM_GF_GAME, WPBY_Network.SUB_C_SHUIHUZHUAN, buffer, gameSocketNumber.GameSocket);
    end
end
function WPBY_FishController.OnJBZDDie(data)
    WPBY_GoldEffect.JBZDEffectEvent();
    if data.wChairID == WPBYEntry.ChairID then
        local fish = self.GetFish(data.fishid);
        local fishlist = self.OnGetFishToXY(300, fish.transform.localPosition);
        local buffer = ByteBuffer.New();
        buffer:WriteInt(data.wChairID);
        buffer:WriteInt(data.fishid);
        for i = 1, 20 do
            if i <= #fishlist then
                --TODO 反回坐标
                buffer:WriteInt(fishlist[i].fishData.id);
                WPBY_NetController.CreateNew(data.wChairID, fishlist[i].transform.position, fishlist[i].fishData.id);
            else
                buffer:WriteInt(0);
            end
        end
        Network.Send(MH.MDM_GF_GAME, WPBY_Network.SUB_C_JUBUZHADAN, buffer, gameSocketNumber.GameSocket);
    end
end
function WPBY_FishController.OnDSXDie(data)

end
function WPBY_FishController.OnDSYDie(data)

end
function WPBY_FishController.OnYWDie(data)
    local fish = self.GetFish(data.kingID);
    if self.nowFishGroup >= 3 then
        self.fishGroupID = 1000;
        self.nowFishGroup = 0;
        self.IsShowKingFish = false;
    end
    self.nowFishGroup = self.nowFishGroup + 1;
    local deadYuWangPoint = Vector3.New(0, 0, 0);
    if fish == nil then
        if not self.IsShowKingFish then
            return ;
        end
        self.OnShowFishGroupToYuWang(data.fish, deadYuWangPoint);
        return ;
    end
    self.IsShowKingFish = true;
    deadYuWangPoint = fish.transform.localPosition;
    if data.wChairID == WPBYEntry.ChairID then
        local buffer = ByteBuffer.New();
        buffer:WriteInt(data.wChairID);
        Network.Send(MH.MDM_GF_GAME, WPBY_Network.SUB_C_YUWANG, buffer, gameSocketNumber.GameSocket);
    end
    self.OnShowFishGroupToYuWang(data.fish, deadYuWangPoint);
    local player = WPBY_PlayerController.GetPlayer(data.wChairID);
    if player ~= nil then
        WPBY_GoldEffect.ShowOhterFishDead(0, "YuWang", player.transform, fish);
    end
end
function WPBY_FishController.OnYWDJDie(data)
    local fishlist = self.OnGetFishToSence();
    for i = 1, #fishlist do
        WPBY_NetController.CreateNew(data.wChairID, fishlist[i].transform.localPosition, fishlist[i].fishData.id);
        fishlist[i]:OnHitFish();
    end
    if data.wChairID == WPBYEntry.ChairID then
        local player = WPBY_PlayerController.GetPlayer(data.wChairID);
        if playe == nil then
            return ;
        end
        local bullet = {};
        setmetatable(bullet, { __index = WPBY_Struct.Bullet });
        bullet.id = data.bullt;
        bullet.type = player.isSuperMode and 1 or 0;
        bullet.isUse = 0;
        bullet.level = player.gunLevel;
        bullet.chips = WPBY_Struct.CMD_S_CONFIG.bulletScore[player.gunLevel + 1];
        self.SendHitFish(bullet, data.wChairID, fishlist);
    end
end
function WPBY_FishController.OnTLZDDie(data)
    local fishlist = self.OnGetFishToSence();
    local newfishlist = {};
    for i = 1, #fishlist do
        if fishlist[i].fishData.Kind == data.kind then
            table.insert(newfishlist, fishlist[i]);
        end
    end
    if data.wChairID == WPBYEntry.ChairID then
        local buffer = ByteBuffer.New();
        buffer:WriteInt(data.wChairID);
        buffer:WriteInt(data.fishid);
        for i = 1, 20 do
            if i <= #newfishlist then
                log("同类：" .. newfishlist[i].fishData.id)
                buffer:WriteInt(newfishlist[i].fishData.id);
            else
                buffer:WriteInt(0);
            end
        end
        Network.Send(MH.MDM_GF_GAME, WPBY_Network.SUB_C_TONGLEIZHADAN, buffer, gameSocketNumber.GameSocket);
    end
end
function WPBY_FishController.OnShotLK(data)
    local fish = self.GetFish(data.id);
    if fish == nil then
        return ;
    end
    if data.score ~= 0 then
        WPBY_GoldEffect.ShowSuperJack(data.score, fish, data.site);
        fish:Dead();
    else
        fish.transform:Find("odd"):GetComponent("TextMeshProUGUI").text = WPBYEntry.ShowText(data.Multiple);
    end
end
function WPBY_FishController.OnGetFishToSence()
    local list = {};
    for i = 1, #self.fishComponentDic do
        local fish = self.fishComponentDic[i];
        if fish:IsToSence() then
            table.insert(list, fish);
        end
    end
    return list;
end
function WPBY_FishController.OnGetBigFishToSence()
    local list = {};
    for i = 1, #self.fishComponentDic do
        local fish = self.fishComponentDic[i];
        if fish:IsToSence() and fish.fishData.Kind >= 18 then
            table.insert(list, fish);
        end
    end
    return list;
end
function WPBY_FishController.OnGetFishToXY(distance, pos)
    local list = {};
    for i = 1, #self.fishComponentDic do
        if self.fishComponentDic[i]:IsToAngle(distance, pos) then
            table.insert(list, self.fishComponentDic[i]);
        end
    end
    return list;
end
function WPBY_FishController.OnShowFishGroupToYuWang(fishGroup, vector)
    local changeAngle = 9;
    local angle = 0;
    for i = 1, #fishGroup do
        fishGroup[i].CreateTime = Time.realtimeSinceStartup;
        fishGroup[i].fishPoint = {};
        local hudu = (angle / 180) * Mathf.PI;
        local v = 3000 / 6;
        for j = 1, 6 do
            local point = { x = 0, y = 0 };
            if j == 1 then
                point.x = vector.x;
                point.y = vector.y;
            else
                local x_off = vector.x + v * j * Mathf.Cos(hudu);
                local y_off = vector.y + v * j * Mathf.Sin(hudu);
                point.x = x_off;
                point.y = y_off
            end
            table.insert(fishGroup[i].fishPoint, point)
        end
        fishGroup[i].EndTime = 1200;
        fishGroup[i].NowTime = 0;
        self.CreateFish(fishGroup[i], false);
        angle = angle + changeAngle;
    end
end
function WPBY_FishController.SetLockFish(islock)
    WPBY_PlayerController.isLock = islock;
    for i = 1, #self.fishDic do
        local fishid = self.fishDic[i];
        local fish = self.fishComponentDic[i];
        local eventtrigger = fish.transform:GetComponent("EventTriggerListener");
        if islock then
            if eventtrigger ~= nil then
                destroy(eventtrigger);
            end
            eventtrigger = Util.AddComponent("EventTriggerListener", fish.gameObject);
            eventtrigger.onDown = function()
                self.LockFish(fishid);
            end
        else
            if eventtrigger ~= nil then
                destroy(eventtrigger);
            end
        end
    end
end
function WPBY_FishController.LockFish(fishid)
    log("点击鱼id："..fishid);
    local player = WPBY_PlayerController.GetPlayer(WPBYEntry.ChairID);
    if player.IsLock then
        local fish = self.GetFish(fishid);
        if fish == nil then
            return ;
        end
        if self.isLockBigFish then
            if fish.fishData.Kind <= 17 then
                return ;
            end
        end
        player.LockFish = fish;
        player:SendBulltPackIsLock(fishid);
    end
end
function WPBY_FishController.OnGetRandomLookFish(isrobot)
    local a = {};
    if isrobot then
        a = self.OnGetFishToSence();
    else
        if self.isLockBigFish then
            a = self.OnGetBigFishToSence();
        else
            a = self.OnGetFishToSence();
        end
    end
    if #a <= 0 then
        return nil;
    end
    local key = math.random(1, #a);
    return a[key];
end