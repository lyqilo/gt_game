local CFish = GameRequire("Fish");
local CFishGroup = GameRequire("FishGroup");
local _CGameFishControl = class("_CGameFishControl");

function _CGameFishControl:ctor(_sceneControl)
    self._fishMap = map:new();
    self._fishInScreenMap = map:new();
    self._delFishVec = vector:new();
    self._cacheFishMap = map:new();
    self._isRefreshFish = true;
    self._sceneControl  = _sceneControl;
    self._isPauseFish   = false;

    --鱼潮
    self._fishGroupMap = map:new();
    self._fishGroupDelList = vector:new();

    --假死列表
    self._fishFalseDieMap = map:new();
end

function _CGameFishControl:Init(transform)
    self.transform  =  transform;
    self.group = {};
    local count = self.transform.childCount;
    --获取分组存储
    for i=1,count-1 do
        self.group[i] = self.transform:GetChild(i-1);
    end

    --碰撞区容器
    self.fishCollidersTransform = transform:Find("FishCollidersPool");

    --注册事件
    G_GlobalGame:RegEventByStringKey("FishHurt",self,self.OnEventFishHurt);
    --击中李逵
    G_GlobalGame:RegEventByStringKey("HitLK",self,self.OnEventHitLK);

    --注册键值对
    G_GlobalGame:SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetFishById,handler(self,self.OnKVGetFish));
    G_GlobalGame:SetKeyHandler(G_GlobalGame.Enum_KeyValue.CreateUIFish,handler(self,self.OnKVCreateUIFish));
end

--键值对 获取鱼
function _CGameFishControl:OnKVGetFish(_fishId)
    return self:GetFish(_fishId);
end


function _CGameFishControl:_isCanCreateFish()
    if self._isRefreshFish and not self._isPauseFish then
        return  true;
    end
    return false;
end

--创建鱼
function _CGameFishControl:CreateFish(_type,_id,_creator,_flag)

    _flag = _flag or G_GlobalGame.Enum_FISH_FLAG.Common_Fish;
    if not self:_isCanCreateFish() then
        if _flag==G_GlobalGame.Enum_FISH_FLAG.Common_Fish then
            return ;
        end
    end
    local vec = self._cacheFishMap:value(_type);
    local fish;
    if vec==nil or vec:size()==0 then
        fish = CFish.Create(_type,_creator);
    else
        fish = vec:pop();
    end
    fish:SetFishFlag(_flag);
    fish:SetFishID(_id);
    fish:RegEvent(self,self.OnEventFish);
    self._fishMap:insert(fish:FishID(),fish);
    local info = G_GlobalGame.GameConfig.FishInfo[_type];
    local groupCount = #info.groupIds;
    local index=math.random(1,groupCount);
    fish:SetName("FishName_" .. _id);
    --fish.gameObject.name = "FishName_" .. _id;
    fish:SetParent(self.group[info.groupIds[index]]);
    --鱼的碰撞区
    --local boxCollider = fish:BoxCollider();
    --boxCollider:SetParent(self.fishCollidersTransform);
    return fish;
end

--创建鱼
function _CGameFishControl:OnKVCreateUIFish(_type)
    local _flag = G_GlobalGame.Enum_FISH_FLAG.Common_Fish;
    local fish = CFish.Create(_type);
    fish:SetFishFlag(_flag);
    fish:SetName("FishName_" .. _type);
    return fish;
end

--创建鱼潮
function _CGameFishControl:CreateFishGroup(_fishGroupData)
    local fishGroup = CFishGroup.Create(self.transform,handler(self,self.CreateFish),_fishGroupData)
    fishGroup:RegEvent(self,self.OnEventFishGroup);
    self._fishGroupMap:assign(fishGroup:LID(),fishGroup);
    return fishGroup;
end

--停止刷新鱼
function _CGameFishControl:StopRefreshFish()
    self._isRefreshFish = false;
end

--开始刷信鱼
function _CGameFishControl:StartRefreshFish()
    self._isRefreshFish = true;
end

function _CGameFishControl:Pause()
    self._isPauseFish = true;
end

function _CGameFishControl:Resume()
    self._isPauseFish = false;
end

--每帧更新
function _CGameFishControl:Update(_dt)
    --清理缓存
    local it = self._delFishVec:iter();
    local val = it();
    local vec;
    local fish;
    local FishSystemInfo =  G_GlobalGame.GameConfig.FishInfo;
    local fishType ;
    local FishInfo;

    while(val) do
        self._fishInScreenMap:erase(val);
        fish = self._fishMap:erase(val);
        if fish then
            fish:Cache();
            if fish:IsFalseDie() then
                --假死
                --先放队列里
                self._fishFalseDieMap:assign(val,fish);
            else
                --放到缓存里
                fishType = fish:FishType();
                vec = self._cacheFishMap:value(fishType);
                if vec==nil then
                    vec = vector:new();
                    self._cacheFishMap:insert(fishType,vec);
                end
                FishInfo = FishSystemInfo[fishType];
                if vec:size()>= FishInfo.cacheCount then
                    fish:Destroy();
                else
                    vec:push_back(fish);
                end
            end
        end
        val = it();
    end 
    self._delFishVec:clear();

    --处理假死队列
    if self._fishFalseDieMap:size()>0 then
        local dieVec = vector:new();
        local it = self._fishFalseDieMap:iter();
        local val= it();
        while (val) do
            fish = self._fishFalseDieMap:value(val);
            if not fish:IsFalseDie() then
                --从假死队列里剔除
                --放到缓存里
                fishType = fish:FishType();
                vec = self._cacheFishMap:value(fishType);
                if vec==nil then
                    vec = vector:new();
                    self._cacheFishMap:assign(fishType,vec);
                end
                FishInfo = FishSystemInfo[fishType];
                if vec:size()>= FishInfo.cacheCount then
                    fish:Destroy();
                else
                    vec:push_back(fish);
                end
                dieVec:push_back(val);
            end
            val = it();
        end

        it = dieVec:iter();
        val = it();
        while(val) do
            self._fishFalseDieMap:erase(val);
            val = it();
        end
        val = nil;
        dieVec:clear();
    end


    --处理假死队列结束

    --暂停移动鱼
--    if self._isPauseFish then
--        return ;
--    end

    local x,y,x2,y2 = self._sceneControl:GetSceneRectInWorld(false);
    local it = self._fishMap:iter();
    local val=it();
    local fish ;
    local i=0;
    while(val) do
        fish = self._fishMap:value(val);
        if fish then
            fish:Update(_dt,self._isPauseFish,x,y,x2,y2);
        end
        i = i+1;
        val = it();
    end

    --鱼潮
    it = self._fishGroupMap:iter();
    val = it();
    local fishGroup
    while(val) do
        fishGroup = self._fishGroupMap:value(val);
        if fishGroup:IsRealStart() then
            fishGroup:Update(_dt);
        else 
            --异步执行
            fishGroup:AsyncUpdate(_dt);
        end
        val = it();
    end

    --删除鱼潮
    it = self._fishGroupDelList:iter();
    val= it();
    while(val) do
        self._fishGroupMap:erase(val:LID());
        val:Destroy();
        val = it();
    end
    self._fishGroupDelList:clear();
end

--根据鱼ID得到鱼
function _CGameFishControl:GetFish(_fishId)
    return self._fishMap:value(_fishId);
end

--根据鱼ID得到假死鱼
function _CGameFishControl:GetFalseDieFish(_fishId)
    local fish = self._fishFalseDieMap:value(_fishId);
    if fish==nil then
        --有可能因为局域网，太快反馈回来，客户端端死亡动作还没有播完
        fish = self:GetFish(_fishId);
        if fish:IsFalseDie() then
            return fish;
        end
    end
    return fish;
end

--收到鱼的事件
function _CGameFishControl:OnEventFish(_eventId,_fish)
    if _eventId == G_GlobalGame.Enum_EventID.FishDie then
        self._delFishVec:push_back(_fish:FishID());
    elseif _eventId == G_GlobalGame.Enum_EventID.FishDead then
        --self._fishMap:erase(_fish:FishID());
        self._fishInScreenMap:erase(_fish:FishID());
    elseif _eventId == G_GlobalGame.Enum_EventID.BeforeFishEnterScreen then
        self._fishInScreenMap:assign(_fish:FishID(),_fish);
        if _fish:IsCanBeLock()  then
            --出现可锁定的鱼了
            G_GlobalGame:DispatchEventByStringKey("Appearance",_fish);
        end
    elseif _eventId == G_GlobalGame.Enum_EventID.BeforeFishLeaveScreen then
        self._fishInScreenMap:erase(_fish:FishID());
    end
end

--收到鱼潮事件
function _CGameFishControl:OnEventFishGroup(_eventId,_fishGroup)
    if _eventId == G_GlobalGame.Enum_EventID.NotifyFishGroupOver then
        --鱼潮结束
        local group=self._fishGroupMap:erase(_fishGroup:LID());
        self._fishGroupDelList:push_back(group);
        --清空所有的鱼
        self:ClearFishes();
        if self._fishGroupMap:size()==0 then
            --开始刷鱼
            self:StartRefreshFish();
        end
    end
end

--删除所有
function _CGameFishControl:ClearAll()
    self._fishMap:clear();
    self._fishInScreenMap:clear();
end

--清除所有鱼
function _CGameFishControl:ClearFishes()
    local vec = vector:new();
    local it = self._fishMap:iter();
    local key = it();
    local fish = nil;
    while(key) do
        fish = self._fishMap:value(key);
        --if not fish:IsDie() then
            --管他死不死都删除
            vec:push_back(fish);
        --end
        key = it();
    end
    --self._fishMap:clear();
    --self._fishInScreenMap:clear();
    it =vec:iter();
    fish = it();
    local tempVec;
    while(fish) do
        fish:Cache();
        self._fishMap:erase(fish:FishID());
        self._fishInScreenMap:erase(fish:FishID());
        --放到缓存里
        tempVec = self._cacheFishMap:value(fish:FishType());
        if tempVec==nil then
            tempVec = vector:new();
            self._cacheFishMap:insert(fish:FishType(),tempVec);
        end
        tempVec:push_back(fish);
        fish = it();
    end
    self._fishInScreenMap:clear();
    self._fishMap:clear();
    --从预删除队列删除
    self._delFishVec:clear();


    --删除鱼潮
    it = self._fishGroupMap:iter();
    val = it();
    local fishGroup
    while(val) do
        fishGroup = self._fishGroupMap:value(val);
        fishGroup:Destroy();
        val = it();
    end

    self._fishGroupMap:clear();
    self._fishGroupDelList:clear();

    return vec;
end

--某种标志的鱼
function _CGameFishControl:ClearFishesByFlag(_flag)
    local vec = vector:new();
    local it = self._fishMap:iter();
    local key = it();
    local fish = nil;
    while(key) do
        fish = self._fishMap:value(key);
        if not fish:IsDie() and fish:IsFlag(_flag) then
            vec:push_back(fish);
        end
        key = it();
    end
    it =vec:iter();
    fish = it();
    while(fish) do
        fish:Disappear();
        --self._fishMap:erase(fish:FishID());
        --self._fishInScreenMap:erase(fish:FishID());
        fish = it();
    end
    
    return vec;
end

--得到屏幕内的所有鱼
function _CGameFishControl:GetFishesInScreen()
    local vec = vector:new();
    local it = self._fishInScreenMap:iter();
    local key = it();
    local fish;
    while(key) do
        fish = self._fishInScreenMap:value(key);
        if not fish:IsDie() then
            vec:push_back(fish);
        end
        key = it();
    end
    return vec;
end

--得到屏幕内的所有鱼 除指定鱼之外
function _CGameFishControl:GetFishesInScreenExceptFish(_fish)
    local vec = vector:new();
    local it = self._fishInScreenMap:iter();
    local key = it();
    local fish;
    while(key) do
        fish = self._fishInScreenMap:value(key);
        if not fish:IsDie() and _fish:FishID()~=fish:FishID() then
            vec:push_back(fish);
        end
        key = it();
    end
    return vec;
end

--清除屏幕内的所有鱼
function _CGameFishControl:ClearFishesInScreen()
    local vec = self:GetFishesInScreen();
    local it = vec:iter();
    local fish=it();
    while(fish) do
        fish:Disappear();
        --self._fishMap:erase(fish:FishID());
        --self._fishInScreenMap:erase(fish:FishID());
        fish = it();
    end 
end

--获取屏幕内指定类型的鱼
function _CGameFishControl:GetFishesInScreenWithFishType(_fishType)
    local vec = vector:new();
    local it = self._fishInScreenMap:iter();
    local key = it();
    local fish;
    while(key) do
        fish = self._fishInScreenMap:value(key);
        if not fish:IsDie() and fish:IsFishType(_fishType) then
            vec:push_back(fish);
        end
        key = it();
    end
    return vec;
end

--清除屏幕内指定类型的鱼
function _CGameFishControl:ClearFishesInScreenWithFishType(_fishType)
    local vec=self:GetFishesInScreenWithFishType(_fishType);
    local it = vec:iter();
    local fish=it();
    while(fish) do
        fish:Disappear();
        --self._fishMap:erase(fish:FishID());
        --self._fishInScreenMap:erase(fish:FishID());
        fish = it();
    end 
    return vec;
end

--得到屏幕内 距离某只鱼的距离小于 _distance
function _CGameFishControl:GetFishesInScreenInnerRound(_fish,_distance)
    local vec = vector:new();
    local it = self._fishInScreenMap:iter();
    local key = it();
    local fish;
    while(key) do
        fish = self._fishInScreenMap:value(key);
        if fish:FishID() ~= _fish:FishID() then
            if not fish:IsDie() and Vector3.Distance(_fish.transform.localPosition,fish.transform.localPosition)<_distance then
                vec:push_back(fish);
            end
        end
        key = it();
    end
    return vec;
end

--收到鱼受伤事件
function _CGameFishControl:OnEventFishHurt(_eventId,_eventData)
    if _eventId == G_GlobalGame.Enum_EventID.FishHurt then
        if _eventData~=nil then
            local fish =self:GetFish(_eventData);
            if fish~=nil then
                fish:Hurt();
            end
        end
    end
end

--击中李逵
function _CGameFishControl:OnEventHitLK(_eventId,_eventData)
    if _eventId == G_GlobalGame.Enum_EventID.HitLK then
        if _eventData~=nil then
            local fish =self:GetFish(_eventData.fishId);
            if fish~=nil then
                fish:SetMultiple(_eventData.fishMultiple);
            end
        end
    end
end

--得到下一条可以锁定的鱼 返回nil表示没有可锁定的目标
function _CGameFishControl:GetNextLockFish(_fish)
    local isStart = false;
    if not _fish then
        --随便捉一条
        isStart = true;
    end
    local fish;
    local it = self._fishInScreenMap:iter();
    local val=it();
    while (val) do
        fish = self._fishInScreenMap:value(val);
        if isStart then
            if not fish:IsDie() and G_GlobalGame.FunctionsLib.Mod_Fish_IsCanBeLock(fish:FishType()) then
                return fish;
            end
        else
            if fish:FishID() == _fish:FishID() then
                isStart = true;
            end
        end
        val = it();
    end
    if not _fish then
        --没有找到目标
        return nil;
    end
    it = self._fishInScreenMap:iter();
    val = it();
    while (val) do
        fish = self._fishInScreenMap:value(val);
        if fish:FishID() == _fish:FishID() then
            if not fish:IsDie() then
                return fish;
            else
                return nil;
            end
        end
        if not fish:IsDie() and G_GlobalGame.FunctionsLib.Mod_Fish_IsCanBeLock(fish:FishType()) then
            return fish;
        end
        val = it();
    end
    return nil;
end

--鱼快速的移除屏幕
function _CGameFishControl:FishQuickMoveOutScreen()
    local it = self._fishMap:iter();
    local key = it();
    local fish = nil;
    while(key) do
        fish = self._fishMap:value(key);
        if not fish:IsDie() then
            --鱼快速移除屏幕
            fish:QuickMove();
        end
        key = it();
    end
end

--鱼个数
function _CGameFishControl:FishCount()
    local count=0;
    local it = self._fishMap:iter();
    local key = it();
    local fish = nil;
    while(key) do
        fish = self._fishMap:value(key);
        if not fish:IsDie() then
            count = count + 1;
        end
        key = it();
    end
    return count;
end

--屏幕内鱼的条数
function _CGameFishControl:ScreenFishCount()
    return self._fishInScreenMap:size();
end


--遍历屏幕内的鱼
function _CGameFishControl:IterScreenFish()
    local it = self._fishInScreenMap:iter();
    return function()
        local val = it();
        local fish;
        while (val) do
            fish = self._fishInScreenMap:value(val);
            if not fish:IsDie() then
                return fish;
            end
            val = it();
        end
        return nil;
    end
end

return _CGameFishControl;