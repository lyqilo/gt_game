local CEventObject=GameRequire("EventObject");

local _CBullet= class("_CBullet",CEventObject)

LKPY_CBullet = _CBullet;

-------------------------------------------创建子弹----------------------------------------------------
function _CBullet.CreateOther(_type)
    local obj = _CBullet.New();
    obj:_init(_type,false);
    return obj;
end

function _CBullet.CreateSelf(_type)
    local obj = _CBullet.New();
    obj:_init(_type,true);
    return obj;
end
---------------------------------------------------------------------------------------------------------

--构造函数
function _CBullet:ctor()
    _CBullet.super.ctor(self);
    self.isDealWith = false;                                                   --是否正在处理中
    self.lockFishId = G_GlobalGame.ConstDefine.C_S_INVALID_FISH_ID;			   --锁定的鱼的ID=0
    self.lockFish   = nil;													   --锁定的鱼对象
    self.isMyAndroid= false;												   --是否是我的机器人？
    self.bulletId   = G_GlobalGame.ConstDefine.C_S_INVALID_BULLET_ID;		   --这颗子弹的ID
    self.type       = nil;													   --这颗子弹的类型
    self.isOwner    = false;												   --是否是我的子弹
    self.multiple   = 0;													   --倍数
    self.chairId    = 0;													   --玩家椅子号
    self.bulletKind = 0;													   --子弹类型
    self.runTime    = 0;													   --Timer计时器
end

--初始化（子弹类型，是否是自己的子弹）
function _CBullet:_init(_type,isOwner)

	--对象工厂创建一颗子弹	
    local obj = G_GlobalGame._goFactory:createBullet(_type,isOwner);								
    self.transform  = obj.transform;
    self.gameObject = obj;
    self.type       = _type;
    self.bulletKind = _type;
    self.isOwner    = isOwner;
	
	--通过这个子弹的类型，从配置中读取子弹：速度，威力，能源
    self.speedVec   = Vector3.New(0,G_GlobalGame.GameConfig.Bullet[_type].iSpeed,0)
    self.multiple   = G_GlobalGame.GameConfig.Bullet[_type].multiple; --����
    self.isEnergy   = G_GlobalGame.GameConfig.Bullet[_type].isEnergy;
	--logError(G_GlobalGame.GameConfig.Bullet[_type].iSpeed)
    self.baseBehaviour = Util.AddComponent("BaseBehaviour",self.gameObject);
    self.baseBehaviour:SetLuaTab(self,"LKPY_CBullet");
    self.animator   = self.transform:GetComponent("ImageAnima");
end


function _CBullet:Start()
    
end

--外部初始化，玩家座位号，子弹位置，子弹方向，子弹ID，是否我的机器人，子弹类型
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
end

--设置个bool类型，是否机器人
function _CBullet:SetMyAndroid(isMyAndroid)
    self.isMyAndroid = isMyAndroid or false;
end

--设置子弹ID
function _CBullet:SetBulletId(_bulletId)
    self.bulletId = _bulletId;
end

--设置子弹速度
function _CBullet:_calSpeed(_euler)
    self.transform.rotation = Quaternion.Euler(0,0,_euler);
    self.angle   = _euler;
    self.speed   = self.speedVec*self.transform.localRotation;
end

--1.判断子弹有没有废掉
--2.判断子弹有无目标（有目标向目标飞去，无目标向手指方向飞去）
function _CBullet:UpdateEx(_dt,realX,realY,realX2,realY2,x1,x2,_isMove)
    self.runTime = self.runTime + _dt;
    if self.runTime>G_GlobalGame.GameConfig.SceneConfig.iBulletLiveTime then
        self:Unlock();
    end
    local position  =self.transform.position;
    if position.x< x1 or position.x> x2 then
        self:Unlock();
        self:Delete();
        return ;
    end
    if _isMove then
        if self.lockFishId ~= G_GlobalGame.ConstDefine.C_S_INVALID_FISH_ID then
            local r = G_GlobalGame.FunctionsLib.FUNC_GetEulerAngleByLevel(position,self.lockFish:Position());
            if r>=90 then
                r = r - 90;
            else
                r = r + 270;
            end
            self:_calSpeed(r);
        end
     	self.transform.localPosition = self.transform.localPosition + self.speed;
    	self:_calAngle(realX,realY,realX2,realY2);   
    end

end

--判断子弹是否已经到达边界，进行反弹处理
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

--碰到目标鱼
function _CBullet:OnTriggerEnter(coll)
			
    if G_GlobalGame.isQuitGame then
        return ;
    end
	
    local go = coll.gameObject;
    if (go:CompareTag("fish")) then

        if(self.isDealWith) then
            return ;
        end
        local fishId = G_GlobalGame.FunctionsLib.GetFishIDByGameObject(go);
        local fish = G_GlobalGame:GetKeyValue(G_GlobalGame.Enum_KeyValue.GetFishById,fishId);
        if fish==nil then
            return ;
        end
        if  fish:IsDie() then 
            return ;
        end

        if (self.lockFish ~=nil) then
            if (fishId==self.lockFishId) then 
                self.lockFish:RemoveEvent(self);
                self:Effect(fish);
            else

            end
        else
            self:Effect(fish);
        end
    end
end

--子弹是否激活
function _CBullet:IsEffective()
    return self.bulletId ~= G_GlobalGame.ConstDefine.C_S_INVALID_BULLET_ID; 
end

--杀鱼
function _CBullet:Effect(fish)
    self.isDealWith = true;
    self:Unlock();
    self:Disappear();
    local fishId = fish:FishID();
    if self.isOwner then
    	G_GlobalGame:DispatchEventByStringKey("FishHurt",fishId);
    end

    local EnumBulletType = G_GlobalGame.Enum_BulletType;

--[[    if not self.isOwner and not self.isMyAndroid then
		error("我被return了")
        return ;
    end--]]
	
	
    if fish then
        local _type = fish:FishType();
        if _type == G_GlobalGame.Enum_FishType.FISH_KIND_21 then
            G_GlobalGame._clientSession:SendHitLikui(fishId);
        end


        G_GlobalGame._clientSession:SendCatchFish(self.chairId,fishId,G_GlobalGame.GameConfig.FishInfo[_type].iMultiple,self.bulletKind,self.bulletId,G_GlobalGame.GameConfig.Bullet[self.type].multiple);
    end
end

--删掉这颗子弹
function _CBullet:Delete()
    self:SendEvent(G_GlobalGame.Enum_EventID.BulletDelete);
end

--隐藏这颗子弹
function _CBullet:Disappear()
    self:SendEvent(G_GlobalGame.Enum_EventID.BulletDisappear);
    self:ClearEvent();
end

--解锁
function _CBullet:Unlock()
    self.lockFishId = G_GlobalGame.ConstDefine.C_S_INVALID_FISH_ID;
    self.lockFish   = nil;
end

--锁鱼，传参 鱼对象
function _CBullet:Lock(_fish)
    if _fish==nil then
        self:Unlock();
    else
        self.lockFish   = _fish;
        self.lockFishId = _fish:FishID();
        _fish:RegEvent(self,self.OnFishEvent);
    end
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

--这个子弹网的类型
function _CBullet:NetType()
    return G_GlobalGame.GameConfig.Bullet[self.type].netType;
end

--是否是我的
function _CBullet:IsOwner()
    return self.isOwner;
end

return _CBullet;

