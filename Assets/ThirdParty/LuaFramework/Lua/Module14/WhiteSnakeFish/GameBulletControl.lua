local CBullet = GameRequire("Bullet");

local CNetControl = GameRequire("GameNetControl");

local _CGameBulletControl = class("_CGameBulletControl");

function _CGameBulletControl:ctor(_sceneControl)
    self._bulletMap = map:new();
    self._delList   = vector:new();
    self._cacheOtherBulletPool  = vector:new();
    self._cacheSelfBulletPool   = vector:new();
    self._gameNetControl        = CNetControl.New();
    self._sceneControl          = _sceneControl;
    self._isMove                = true;
end

function _CGameBulletControl:Init(transform)
    self.transform  = transform;
    self.gameObject = transform.gameObject;
    local netsPool = transform:Find("NetsPool");
    self._gameNetControl:Init(netsPool);
    self.bulletColliderTransform = transform:Find("BulletCollidersPool");
end


--创建子弹事件
function _CGameBulletControl:OnCreateBulletEvent(_eventId,_eventData)
    
end

--子弹暂停移动
function _CGameBulletControl:Pause()
    self._isMove  = false;
end

--恢复移动
function _CGameBulletControl:Resume()
    self._isMove  = true;
end

--创建子弹
function _CGameBulletControl:CreateBullet(_type,_isOwn,_startPos,_rotation,_chairId,_lockFish,_bulletId,_isMyAndroid,_bulletKind)
    local bullet;
    if _isOwn then
        local size = self._cacheSelfBulletPool:size();
        for i=1,size do
            bullet = self._cacheSelfBulletPool:get(i);
            if bullet.type == _type then
                self._cacheSelfBulletPool:pop(i);
                break;
            end
            bullet = nil;
        end
        if bullet~=nil then --从缓存里找到了
            --bullet:SetParent(self.transform);
            --return bullet;
        else
            bullet = CBullet.CreateSelf(_type)
        end
    else
        local size = self._cacheOtherBulletPool:size();
        for i=1,size do
            bullet = self._cacheOtherBulletPool:get(i);
            if bullet.type == _type then
                self._cacheOtherBulletPool:pop(i);
                break;
            end
            bullet = nil;
        end
        if bullet~=nil then --从缓存里找到了
            --bullet:SetParent(self.transform);
            --return bullet;
        else
            bullet = CBullet.CreateOther(_type)
        end
    end
    bullet:RegEvent(self,self.OnEventBullet);
    self._bulletMap:insert(bullet.lid,bullet);
    --加入节点
    bullet:SetParent(self.transform);

    if G_GlobalGame.FunctionsLib.FUNC_BulletIsEnergy(_type) then
        bullet:SetLocalScale(Vector3.New(0.8,0.8,0.8));
    end

    --子弹碰撞区
    local boxCollider = bullet:BoxCollider();
    boxCollider:SetParent(self.bulletColliderTransform);

    if G_GlobalGame.FunctionsLib.FUNC_BulletIsEnergy(_type) then
        boxCollider:SetLocalScale(Vector3.New(0.8,0.8,0.8));
    end

    --设置子弹的起始坐标
    bullet:Init(_chairId,_startPos,_rotation,_bulletId,_isMyAndroid,_bulletKind);
    --锁定鱼
    bullet:Lock(_lockFish);
    --设置是否由我托管
    bullet:SetMyAndroid(_isMyAndroid);
    return bullet;
end

function _CGameBulletControl:Update(_dt)
    local x1,y,x2,y2 = self._sceneControl:GetSceneRectInWorld(true);
    local realx,realy,realx2,realy2= self._sceneControl:GetRealSceneRectInWorld();
    --鱼网每帧执行
    self._gameNetControl:Update(_dt);
    local it = self._delList:iter();
    local val = it();
    local bullet ;
    while(val) do
        bullet = self._bulletMap:erase(val);
        if bullet then
            bullet:Cache();
            if bullet.isOwner then
                if self._cacheSelfBulletPool:size()>10 then
                    bullet:Destroy();
                else
                    self._cacheSelfBulletPool:push_back(bullet);
                end
            else
                if self._cacheOtherBulletPool:size()>25 then --多于25个
                    bullet:Destroy();
                else
                    self._cacheOtherBulletPool:push_back(bullet);
                end
            end
        end
        val = it();
    end
    self._delList:clear();
    it = self._bulletMap:iter();
    val = it();
    
    while(val) do
        bullet = self._bulletMap:value(val);
        bullet:UpdateEx(_dt,realx,realy,realx2,realy2,x1,x2,self._isMove);
        val = it();
    end
end

function _CGameBulletControl:DeleteBullet(_bullet)
    self._delList:push_back(_bullet.lid);
end

function _CGameBulletControl:DeleteBulletById(_bulletId)
    local it = self._bulletMap:iter();
    local val = it();
    local bullet ;
    while(val) do
        bullet = self._bulletMap:value(val);
        if bullet.bulletId == _bulletId then
            self:DeleteBullet(bullet);
            break;
        end
        val = it();
    end
end

function _CGameBulletControl:OnEventBullet(_eventId,_bullet)
    if _eventId == G_GlobalGame.Enum_EventID.BulletDisappear then
        self:DeleteBullet(_bullet);
        --创建鱼网
        self._gameNetControl:CreateNet(_bullet);
    elseif _eventId==G_GlobalGame.Enum_EventID.BulletDelete then
        --直接删除子弹
        self:DeleteBullet(_bullet);
    end
end

--清除所有的子弹
function _CGameBulletControl:ClearAllBullets()
    local it = self._bulletMap:iter();
    local val = it();
    local bullet ;
    while(val) do
        bullet = self._bulletMap:value(val);
        bullet:Cache();
        if bullet.isOwner then
            if self._cacheSelfBulletPool:size()>10 then
                bullet:Destroy();
            else
                self._cacheSelfBulletPool:push_back(bullet);
            end
        else
            if self._cacheOtherBulletPool:size()>25 then --多于25个
                bullet:Destroy();
            else
                self._cacheOtherBulletPool:push_back(bullet);
            end
        end
        val = it();
    end
    self._bulletMap:clear();
    self._delList:clear();
    --删除所有鱼网
    self._gameNetControl:ClearAllNets();
end

function _CGameBulletControl:GetCountByChairId(_chairId)
    local it = self._bulletMap:iter();
    local val = it();
    local bullet ;
    local count = 0; 
    while(val) do
        bullet = self._bulletMap:value(val);
        if bullet.chairId == _chairId then
            count = count + 1;
        end
        val = it();
    end
    return count;
end

return _CGameBulletControl;