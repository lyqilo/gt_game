--鱼类管理
OneWPBY_FishController = {};
local self = OneWPBY_FishController;
self.fishDic = {};
self.fishComponentDic = {};

self.nowFishGroup = 0;
self.isLockBigFish = false;
self.creatTweener = {};
function OneWPBY_FishController.Init()
    self.isLockBigFish = false;
    self.fishDic = {};
    self.fishComponentDic = {};
    self.creatTweener = {};
end
function OneWPBY_FishController.SetFish(data)
    log("开始创建鱼");
    for i = 1, #data.loadFishList do
        if data.loadFishList[i].Kind > 0 then
            self.CreateFish(data.loadFishList[i]);
        end
    end
end
function OneWPBY_FishController.InitFish(_data)
    log("初始创建鱼");
    local data = { FishCount = _data.szSize, loadFishList = _data.szLoadFish }
    for i = 1, #data.loadFishList do
        if data.loadFishList[i].Kind > 0 then
            self.CreateFish(data.loadFishList[i]);
        end
    end
end
--根据鱼ID生成鱼
function OneWPBY_FishController.CreateFish(data)
    local fishObj = OneWPBYEntry.fishCache:Find(OneWPBY_DataConfig.FishKind[data.Kind]);
    if fishObj == nil then
        local _fish = OneWPBYEntry.fishPool:Find(OneWPBY_DataConfig.FishKind[data.Kind]);
        fishObj = newObject(_fish.gameObject);
        fishObj.gameObject.name = OneWPBY_DataConfig.FishKind[data.Kind];
    end
    local fish = OneWPBY_Fish:New();
    table.insert(self.fishDic, data.id);
    table.insert(self.fishComponentDic, fish);
    fish:Init(data, fishObj.gameObject);
    local eventtrigger = Util.AddComponent("EventTriggerListener", fishObj.gameObject);
    eventtrigger.onDown = function()
        self.LockFish(data.id);
    end
end
--找鱼
function OneWPBY_FishController.GetFish(id)
    for i = 1, #self.fishDic do
        if self.fishDic[i] == id then
            return self.fishComponentDic[i];
        end
    end
    return nil;
end
function OneWPBY_FishController.SetAddSpeed()
    for i = 1, #self.fishComponentDic do
        self.fishComponentDic[i]:QuickSwim();
    end
end
function OneWPBY_FishController.FishDead(deadFish)
    --鱼死亡
    for i = 1, #deadFish.fish do
        if deadFish.fish[i].id > 0 then
            local fish = OneWPBY_FishController.GetFish(deadFish.fish[i].id);
            fish:Dead(deadFish.fish[i], deadFish.wChairID);
        end
    end
end
--回收鱼,不销毁
function OneWPBY_FishController.CollectFish(id, kind, obj)
    local index = 0;
    local data = nil;
    for i = 1, #self.fishDic do
        if self.fishDic[i] == id then
            data = self.fishComponentDic[i];
            index = i;
            break ;
        end
    end
    obj.gameObject.name = OneWPBY_DataConfig.FishKind[kind];
    obj.transform:SetParent(OneWPBYEntry.fishCache);
    obj.transform.localPosition = Vector3.New(0, 0, 0);
    obj.gameObject:SetActive(false);
    local eventtrigger = obj.transform:GetComponent("EventTriggerListener");
    if eventtrigger ~= nil then
        destroy(eventtrigger);
    end
    local luaBehaviour = obj.transform:GetComponent("BaseBehaviour");
    if luaBehaviour ~= nil then
        destroy(luaBehaviour);
    end
    if index > 0 then
        table.remove(self.fishDic, index);
        table.remove(self.fishComponentDic, index);
    end
end
function OneWPBY_FishController.ClearFish()
    self.fishComponentDic = {};
    self.fishDic = {};
    for i = 1, #self.creatTweener do
        if self.creatTweener[i] ~= nil then
            self.creatTweener[i]:Kill();
        end
    end
    self.creatTweener = {};
end
--开始鱼潮
function OneWPBY_FishController.OnJoinFishTide(msg)
    for i = 1, #self.creatTweener do
        if self.creatTweener[i] ~= nil then
            self.creatTweener[i]:Kill();
        end
    end
    self.creatTweener = {};
    local endTime = 0;
    log(msg.fishTide.fishTideCurTime .. "   " .. msg.fishTide.fishTideStartTime .. "鱼潮已经开始时间");
    if msg.YuChaoId == 3 or msg.YuChaoId == 4 then
        self.YuChaoTime = msg.fishTide.fishTideCurTime;
        if self.YuChaoTime == 0 then
            OneWPBYEntry.DelayCall(6, function()
                OneWPBYEntry.heidongEffect.gameObject:SetActive(true);
            end);
        else
            local remain = 6 - msg.fishTide.fishTideCurTime;
            OneWPBYEntry.DelayCall(remain > 0 and remain or 0, function()
                OneWPBYEntry.heidongEffect.gameObject:SetActive(true);
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
                    setmetatable(fish, { __index = OneWPBY_Struct.LoadFish });
                    fish.CreateTime = cTime;
                    fish.EndTime = msg.fishTide.fishLines[indexx].livedTime;
                    fish.fishPoint = msg.fishTide.fishLines[indexx].line.Points;
                    fish.id = index;
                    fish.Kind = msg.fishTide.fishLines[indexx].Kind;
                    fish.NowTime = nTime;
                    fish.odd = 0;

                    local tweener = OneWPBYEntry.DelayCall((nTime > 0) and 0 or last, function()
                        self.CreateFish(fish);
                    end);
                    table.insert(self.creatTweener, tweener);
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
                OneWPBY_GoldEffect.OnShowHaiLang(msg.YuChaoId, msg.fishTide.Rotate);
            end
        end
    end
end
function OneWPBY_FishController.SendHitFish(bullet, site, fishIdlist)
    local buffer = ByteBuffer.New();
    buffer:WriteInt(bullet.bulletId);
    buffer:WriteByte(bullet.type);
    buffer:WriteByte(bullet.isUse);
    buffer:WriteByte(bullet.Level);
    buffer:WriteByte(bullet.Grade);
    buffer:WriteInt(OneWPBY_Struct.CMD_S_CONFIG.bulletScore[bullet.Grade + 1] * (bullet.Level + 1));
    buffer:WriteInt(site);
    for i = 1, OneWPBY_DataConfig.MAX_DEAD_FISH do
        if i <= #fishIdlist then
            buffer:WriteInt(fishIdlist[i].fishData.id);
        else
            buffer:WriteInt(0);
        end
    end
    Network.Send(MH.MDM_GF_GAME, OneWPBY_Network.SUB_C_HITED_FISH, buffer, gameSocketNumber.GameSocket);
end
--忠义堂
function OneWPBY_FishController.OnZYTDie(data)
    OneWPBY_PlayerController.OnSetPlayerState(1, data.wChairID);
    if data.wChairID == OneWPBYEntry.ChairID then
        OneWPBY_GoldEffect.OnShowSuperPowrEffect(true, data.time, data.wChairID);
    else
        OneWPBYEntry.DelayCall(data.time, function()
            local player = OneWPBY_PlayerController.GetPlayer(data.wChairID);
            player:OnJoinSuperPowrModel(false);
        end);
    end
end
function OneWPBY_FishController.OnSHZDie(data)
    OneWPBY_GoldEffect.ShuiHuZhuan();
    local fishlist = self.OnGetFishToSence();
    local player = OneWPBY_PlayerController.GetPlayer(data.wChairID);
    if player == nil then
        return ;
    end
    if player.isSelf or player.isRobot then
        local buffer = ByteBuffer.New();
        buffer:WriteInt(data.wChairID);
        buffer:WriteInt(data.fishid);
        for i = 1, OneWPBY_DataConfig.MAX_FISH_BUFFER do
            if i <= #fishlist then
                --TODO 反回坐标
                buffer:WriteInt(fishlist[i].fishData.id);
                OneWPBY_NetController.CreateNew(data.wChairID, fishlist[i].transform.position, fishlist[i].fishData.id);
            else
                buffer:WriteInt(0);
            end
        end
        Network.Send(MH.MDM_GF_GAME, OneWPBY_Network.SUB_C_SHUIHUZHUAN, buffer, gameSocketNumber.GameSocket);
    end
end
function OneWPBY_FishController.OnJBZDDie(data)
    OneWPBY_GoldEffect.JBZDEffectEvent();
    local player = OneWPBY_PlayerController.GetPlayer(data.wChairID);
    if player == nil then
        return ;
    end
    if player.isSelf or player.isRobot then
        local fish = self.GetFish(data.fishid);
        local totalfishlist = {};
        local fishlist = self.OnGetFishToXY(200, fish.transform.localPosition);
        for i = 1, #fishlist do
            fishlist[i]:StopSwim(fish.transform.position);
            table.insert(totalfishlist, fishlist[i]);
        end
        coroutine.start(function()
            local t = 0;
            while true do
                coroutine.wait(0.1);
                t = t + 0.1;
                if t > 1.5 then
                    break ;
                end
                fishlist = self.OnGetFishToXY(200, fish.transform.localPosition);
                for i = 1, #fishlist do
                    local isfind = false;
                    for j = 1, #totalfishlist do
                        if totalfishlist[j].fishData.id == fishlist[i].fishData.id then
                            isfind = true;
                            break ;
                        end
                    end
                    if not isfind then
                        fishlist[i]:StopSwim(fish.transform.position);
                        table.insert(totalfishlist, fishlist[i]);
                    end
                end
            end
            coroutine.wait(0.5);
            local buffer = ByteBuffer.New();
            buffer:WriteInt(data.wChairID);
            buffer:WriteInt(data.fishid);
            for i = 1, 20 do
                if i <= #totalfishlist then
                    --TODO 反回坐标
                    buffer:WriteInt(totalfishlist[i].fishData.id);
                    OneWPBY_NetController.CreateNew(data.wChairID, totalfishlist[i].transform.position, totalfishlist[i].fishData.id);
                else
                    buffer:WriteInt(0);
                end
            end
            Network.Send(MH.MDM_GF_GAME, OneWPBY_Network.SUB_C_JUBUZHADAN, buffer, gameSocketNumber.GameSocket);
        end);
    end
end
function OneWPBY_FishController.OnDSXDie(data)

end
function OneWPBY_FishController.OnDSYDie(data)

end
function OneWPBY_FishController.OnYWDie(data)
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
    if data.wChairID == OneWPBYEntry.ChairID then
        local buffer = ByteBuffer.New();
        buffer:WriteInt(data.wChairID);
        Network.Send(MH.MDM_GF_GAME, OneWPBY_Network.SUB_C_YUWANG, buffer, gameSocketNumber.GameSocket);
    end
    self.OnShowFishGroupToYuWang(data.fish, deadYuWangPoint);
    local player = OneWPBY_PlayerController.GetPlayer(data.wChairID);
    if player ~= nil then
        OneWPBY_GoldEffect.ShowOhterFishDead(0, "YuWang", player.transform, fish);
    end
end
function OneWPBY_FishController.OnYWDJDie(data)
    local fishlist = self.OnGetFishToSence();
    for i = 1, #fishlist do
        OneWPBY_NetController.CreateNew(data.wChairID, fishlist[i].transform.localPosition, fishlist[i].fishData.id);
        fishlist[i]:OnHitFish();
    end
    if data.wChairID == OneWPBYEntry.ChairID then
        local player = OneWPBY_PlayerController.GetPlayer(data.wChairID);
        if playe == nil then
            return ;
        end
        local bullet = {};
        setmetatable(bullet, { __index = OneWPBY_Struct.Bullet });
        bullet.id = data.bullt;
        bullet.type = player.isSuperMode and 1 or 0;
        bullet.isUse = 0;
        bullet.level = player.gunLevel;
        bullet.type = player.gungrade;
        bullet.chips = OneWPBY_Struct.CMD_S_CONFIG.bulletScore[player.gungrade + 1] * (player.gunLevel + 1);
        self.SendHitFish(bullet, data.wChairID, fishlist);
    end
end
function OneWPBY_FishController.OnTLZDDie(data)
    local fishlist = self.OnGetFishToSence();
    local newfishlist = {};
    for i = 1, #fishlist do
        if fishlist[i].fishData.Kind == data.kind then
            table.insert(newfishlist, fishlist[i]);
        end
    end
    OneWPBY_GoldEffect.TLZDEffectEvent();
    OneWPBY_GoldEffect.ShowSingleBomb(newfishlist);
    local player = OneWPBY_PlayerController.GetPlayer(data.wChairID);
    if player == nil then
        return ;
    end
    if player.isSelf or player.isRobot then
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
        Network.Send(MH.MDM_GF_GAME, OneWPBY_Network.SUB_C_TONGLEIZHADAN, buffer, gameSocketNumber.GameSocket);
    end
end
function OneWPBY_FishController.OnShotLK(data)
    local fish = self.GetFish(data.id);
    if fish == nil then
        return ;
    end
    if data.score ~= 0 then
        OneWPBY_GoldEffect.ShowSuperJack(data.score, fish, data.site);
        fish:Dead();
    else
        fish.transform:Find("odd"):GetComponent("TextMeshProUGUI").text = OneWPBYEntry.ShowText(data.Multiple);
    end
end
function OneWPBY_FishController.OnGetFishToSence()
    local list = {};
    for i = 1, #self.fishComponentDic do
        local fish = self.fishComponentDic[i];
        if fish:IsToSence() then
            table.insert(list, fish);
        end
    end
    return list;
end
function OneWPBY_FishController.OnGetBigFishToSence()
    local list = {};
    for i = 1, #self.fishComponentDic do
        local fish = self.fishComponentDic[i];
        if fish:IsToSence() and fish.fishData.Kind >= 18 then
            table.insert(list, fish);
        end
    end
    return list;
end
function OneWPBY_FishController.OnGetFishToXY(distance, pos)
    local list = {};
    for i = 1, #self.fishComponentDic do
        if self.fishComponentDic[i]:IsToAngle(distance, pos) then
            table.insert(list, self.fishComponentDic[i]);
        end
    end
    return list;
end
function OneWPBY_FishController.OnShowFishGroupToYuWang(fishGroup, vector)
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
function OneWPBY_FishController.SetLockFish(islock)
    OneWPBY_PlayerController.isLock = islock;
    for i = 1, #self.fishDic do
        local fishid = self.fishDic[i];
        local fish = self.fishComponentDic[i];
        if fish.lockTag ~= nil then
            fish.lockTag.gameObject:SetActive(islock);
        end
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
function OneWPBY_FishController.LockFish(fishid)
    local player = OneWPBY_PlayerController.GetPlayer(OneWPBYEntry.ChairID);
    if player.IsLock then
        local fish = self.GetFish(fishid);
        if fish == nil then
            return ;
        end
        log("点击鱼id：" .. fishid .. "  Kind:" .. fish.fishData.Kind);
        if fish.fishData.Kind <= 12 then
            return ;
        end
        player.LockFish = fish;
        player:SendBulltPackIsLock(fishid);
        local vector2 = fish.transform.position;
        if not player.isContinue then
            OneWPBY_PlayerController.ShootSelfBullet(Vector3.New(vector2.x, vector2.y, 0), player.data._9wChairID);
        else
            OneWPBY_PlayerController.ContinuousFireByPos(true, player.data._9wChairID, vector2);
        end
    end
end
function OneWPBY_FishController.OnGetRandomLookFish(isrobot)
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