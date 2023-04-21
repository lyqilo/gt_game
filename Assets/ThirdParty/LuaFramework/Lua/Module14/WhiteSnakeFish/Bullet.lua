local CEventObject=GameRequire("EventObject");


local _CBulletCollider = class("_CBulletCollider",CEventObject);
WhiteSnake_CBulletCollider = _CBulletCollider;
function _CBulletCollider.Create(_bullet,_type,_isOwner)
    local bulletCollider = _CBulletCollider.New(_bullet);
    bulletCollider:_initStyle(_type,_isOwner);
    return bulletCollider;
end

function _CBulletCollider:ctor(_bullet)
    _CBulletCollider.super.ctor(self);
    self._bullet = _bullet;
end

function _CBulletCollider:_initStyle(_type,_isOwner)
    self.gameObject = G_GlobalGame._goFactory:createBulletCollider(_type,_isOwner);
    self.transform  = self.gameObject.transform;
    self.baseBehaviour = Util.AddComponent("BaseBehaviour",self.gameObject);
    self.baseBehaviour:SetLuaTab(self,"WhiteSnake_CBulletCollider");
    self.isOwner = _isOwner;
    self.type    = _type;
end

function _CBulletCollider:OnTriggerEnter(coll)
    return self._bullet:OnTriggerEnter(coll);
end


local _CBullet= class("_CBullet",CEventObject)



--??????????
function _CBullet.CreateOther(_type)
    local obj = _CBullet.New();
    obj:_init(_type,false);
    return obj;
end

--?????????
function _CBullet.CreateSelf(_type)
    local obj = _CBullet.New();
    obj:_init(_type,true);
    return obj;
end

function _CBullet:ctor()
    _CBullet.super.ctor(self);
    self.isDealWith = false; --??????????
    self.lockFishId = G_GlobalGame.ConstDefine.C_S_INVALID_FISH_ID;
    self.lockFish   = nil;
    self.isMyAndroid= false; --??????????й??
    self.bulletId   = G_GlobalGame.ConstDefine.C_S_INVALID_BULLET_ID;
    self.type       = nil;
    self.isOwner    = false;
    self.multiple   = 0;
    self.chairId    = 0;
    self.bulletKind = 0;
    self.runTime    = 0;
    self.bulletCollider = nil;
end

function _CBullet:_init(_type,isOwner)

    local obj = G_GlobalGame._goFactory:createBullet(_type,isOwner);
    self.transform  = obj.transform;
    self.gameObject = obj;
    self.type       = _type;
    self.bulletKind = _type;
    self.isOwner    = isOwner;
    self.speedVec   = Vector3.New(0,G_GlobalGame.GameConfig.Bullet[_type].iSpeed,0);
	--logError(G_GlobalGame.GameConfig.Bullet[_type].iSpeed)
    self.multiple   = G_GlobalGame.GameConfig.Bullet[_type].multiple; --????
    self.isEnergy   = G_GlobalGame.GameConfig.Bullet[_type].isEnergy;
    --[[
    self.baseBehaviour = Util.AddComponent("BaseBehaviour",self.gameObject);
    self.baseBehaviour:SetLuaTab(self,"LKPY_CBullet");
    --]]
    self.animator   = self.transform:GetComponent("ImageAnima");
    self.bulletCollider = _CBulletCollider.Create(self,_type,isOwner);
end

function _CBullet:Start()
    
end

function _CBullet:Init(_chairId,_startPoint,_euler,_bulletId,_isMyAndroid,_bulletKind)
    self.transform.position = _startPoint;
    self:_calSpeed(_euler);
    self.isDealWith = false;
    self.chairId = _chairId;
    self.bulletId = _bulletId or G_GlobalGame.ConstDefine.C_S_INVALID_BULLET_ID;
    self.isMyAndroid = _isMyAndroid or false;
    self.bulletKind = _bulletKind or self.type;
    self.animator:PlayAlways();
    self.runTime    = 0;
    self.bulletCollider:SetLocalPosition(Vector3.New(0,0,0));
    self:CorrentBoxCollider();
    self.countAngleTime = 0;
end

--????????й?
function _CBullet:BoxCollider()
    return self.bulletCollider;
end
function _CBullet:SetMyAndroid(isMyAndroid)
    self.isMyAndroid = isMyAndroid or false;
end

--???????ID
function _CBullet:SetBulletId(_bulletId)
    self.bulletId = _bulletId;
end

function _CBullet:_calSpeed(_euler)
    self.transform.rotation = Quaternion.Euler(0,0,_euler);
    self.angle   = _euler;
    self.speed   = self.speedVec*self.transform.localRotation;
    if self.speed ==nil or self.speed.x==nil
        or self.speed.y==nil or self.speed.z==nil then
        error("CalSpeed nil");
    end
end

--?????
function _CBullet:BoxCollider()
    return self.bulletCollider;
end

--[[
function _CBullet:Init(dirc,bulletId,lockFish,nMulriple,bulletKind,isAndroid,chairId)
    --???
    self.bulletId       = bulletId;
    --????????
    self.lockFish       = lockFish;
    --????
    self.bulletMulriple = nMulriple;
    --?????????????
    self.isMyAndroid    = isAndroid;
    --?????????????
    self.chairId         = chairId;
    --???????
    self.bulletKind     = bulletKind;
    local spriteName =nil;

    --??????????? ?? ?????
    local component = self.transform.GetComponent(UISprite.GetClassType());
    if (G_GlobalGame._gameData:SelfChairId()==chairId) then
        component.spriteName = LKPY_GameConfig.Bullet[bulletKind].SelfName;
    else
        component.spriteName = LKPY_GameConfig.Bullet[bulletKind].OtherName;
    end

    local gameObject=GameObject.Find("UI Root");     

    --??????????????????
    self.rigidbody.velocity = dirc * LKPY_GameConfig.Bullet[bulletKind].speed*30;
    self.rigidbody.velocity = self.rigidbody.velocity * gameObject.transform.localScale.x; --???uiRoot.transform.localScale.x??С????????????????
end
--]]

function _CBullet:UpdateEx(_dt,realX,realY,realX2,realY2,x1,x2,_isMove)
    self.runTime = self.runTime + _dt;
    if self.runTime>G_GlobalGame.GameConfig.SceneConfig.iBulletLiveTime then
        --????????????
        self:Unlock();
    end
    local position  =self.transform.position;
    if position.x< x1 or position.x> x2 then
        --????????????????
        self:Unlock();
        self:Delete();
        return ;
    end
    
    if _isMove then
        if self.lockFishId ~= G_GlobalGame.ConstDefine.C_S_INVALID_FISH_ID then
            --????У??λ?? ,??????
            local r = G_GlobalGame.FunctionsLib.FUNC_GetEulerAngleByLevel(position,self.lockFish:Position());
            if r>=90 then
                r = r - 90;
            else
                r = r + 270;
            end
            self:_calSpeed(r);
        end
        local lPosition = self.transform.localPosition;
        if (_dt==nil) then
            error("_CBullet isNil");
        end
        if self.speed == nil  then
            error("_CBullet self.speed");
        end
     	--self.transform.localPosition = self.transform.localPosition + self.speed;
        self.transform.localPosition = self.speed + self.transform.localPosition;
        self.countAngleTime = 0;
    	self:_calAngle(realX,realY,realX2,realY2); 
        self:CorrentBoxCollider();
    end
    
end


function _CBullet:_calAngle(x,y,x2,y2)
    if self.transform.position.x<x then
        self.angle =  -self.angle;
        self:_calSpeed(self.angle);
        self.transform.position = Vector3.New(2*x-self.transform.position.x,self.transform.position.y,self.transform.position.z);
        self:_calAngle(x,y,x2,y2);
    elseif self.transform.position.x>x2 then
        self.angle =  - self.angle;
        self.transform.position = Vector3.New(2*x2-self.transform.position.x,self.transform.position.y,self.transform.position.z);
        self:_calSpeed(self.angle);
        self:_calAngle(x,y,x2,y2);
    end
    if self.transform.position.y<y then
        self.angle = 180 - self.angle;
        self:_calSpeed(self.angle);
        self.transform.position = Vector3.New(self.transform.position.x,2*y-self.transform.position.y,self.transform.position.z);
        self:_calAngle(x,y,x2,y2);
    elseif self.transform.position.y>y2 then
        self.angle = 180 - self.angle;
        self:_calSpeed(self.angle);
        self.transform.position = Vector3.New(self.transform.position.x,2*y2-self.transform.position.y,self.transform.position.z);
        self:_calAngle(x,y,x2,y2);
    end
end

function _CBullet:OnTriggerEnter(coll)

    if G_GlobalGame.isQuitGame then
        return ;
    end
    --[[
    if (object.CompareTag("border")) then
        ---???
        self.gameObject:GetComponent("Rigidbody");
        local vec = Vector3.Reflect(self.rigidbody.velocity,object.transform.right);
        self.rigidbody.velocity = vec;

        --????????????????????????????????lookat???????????
        local tempPosition = self.transform.position;
        self.transform.position = Vector3.zero;

        --?????????????????????
        self.transform.LookAt(self.rigidbody.velocity, Vector3.New(0, 0, -1));

        --????????lookat??Z?????????????????Y?????????
        self.transform.Rotate(90, 0, 0);

        --??????λ??
        self.transform.position = tempPosition;
        --?????????z?0
        self.transform.localPosition = Vector3.New(self.transform.localPosition.x, self.transform.localPosition.y, 0);
    else
    --]]
    local go = coll.gameObject;
    if (go:CompareTag("fish")) then
        ---??
        if(self.isDealWith) then
            return ;
        end
        local fishId = G_GlobalGame.FunctionsLib.GetFishIDByGameObject(go);
        local fish = G_GlobalGame:GetKeyValue(G_GlobalGame.Enum_KeyValue.GetFishById,fishId);
        if fish==nil then
            return ;
        end
        if  fish:IsDie() then --?????????????趨
            return ;
        end
        --not fish:IsInScreen() or
        --?ж?????????????? ?? ???ж??????????????
        if (self.lockFish ~=nil) then
            --todo ????????ж????????????
            if (fishId==self.lockFishId) then 
                --
                --??????
                self.lockFish:RemoveEvent(self);
                self:Effect(fish);
            else
                --??д???
            end
        else
            --????????
            self:Effect(fish);
        end
    end
end

--???????Ч??
function _CBullet:CorrentBoxCollider()
    self.bulletCollider:SetPosition(self.transform.position);
    self.bulletCollider:SetRotation(self.transform.rotation);
end
function _CBullet:IsEffective()
    return self.bulletId ~= G_GlobalGame.ConstDefine.C_S_INVALID_BULLET_ID; 
end

--????Ч??
function _CBullet:Effect(fish)
    self.isDealWith = true;
    self:Unlock();
    self:Disappear();
    local fishId = fish:FishID();

    --??????????
    if self.isOwner then
        --????????????
    	G_GlobalGame:DispatchEventByStringKey("FishHurt",fishId);
    end
--    if not self:IsEffective() then
--        return ;
--    end
    local EnumBulletType = G_GlobalGame.Enum_BulletType;
    if self.isEnergy then
        --G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.Ion_Catch);
        --G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.Ion_Casting);
    else
        --G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.Catch);
        --G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.Casting);
    end
   

--[[    if not self.isOwner and not self.isMyAndroid then
        --??????????е?
        return ;
    end--]]
    if fish then
        local _type = fish:FishType();
--        if _type == G_GlobalGame.Enum_FishType.FISH_KIND_21 then
--            --????????
--            G_GlobalGame._clientSession:SendHitLikui(fishId);
--        end
        G_GlobalGame._clientSession:SendCatchFish(self.chairId,fishId,G_GlobalGame.GameConfig.FishInfo[_type].iMultiple,self.bulletKind,self.bulletId,G_GlobalGame.GameConfig.Bullet[self.type].multiple);
    end
end

function _CBullet:Delete()
    self:SendEvent(G_GlobalGame.Enum_EventID.BulletDelete);
end

function _CBullet:Disappear()
    self:SendEvent(G_GlobalGame.Enum_EventID.BulletDisappear);
    self:ClearEvent();
end

function _CBullet:Unlock()
    self.lockFishId = G_GlobalGame.ConstDefine.C_S_INVALID_FISH_ID;
    self.lockFish   = nil;
end

--??????
function _CBullet:Lock(_fish)
    if _fish==nil then
        self:Unlock();
    else
        self.lockFish   = _fish;
        self.lockFishId = _fish:FishID();
        _fish:RegEvent(self,self.OnFishEvent);
    end

end

--??????
function _CBullet:Cache()
    self.bulletCollider:Cache();
    _CBullet.super.Cache(self);
end
function _CBullet:OnFishEvent(_eventId,_fish)
    if (_eventId==G_GlobalGame.Enum_EventID.FishDead or _eventId == G_GlobalGame.Enum_EventID.FishLeaveScreen) then
    else
        return;
    end
    if(_fish==nil or _fish:FishID() ~= self.lockFishId) then
        return ;
    end
    self:Unlock();
end

function _CBullet:NetType()
    return G_GlobalGame.GameConfig.Bullet[self.type].netType;
end

function _CBullet:IsOwner()
    return self.isOwner;
end

return _CBullet;