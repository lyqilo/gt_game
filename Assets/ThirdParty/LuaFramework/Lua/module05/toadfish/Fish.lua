local C_HurtColor =Color.New(1, 0.41, 0.41, 1);
local C_NormalColor =Color.New(1, 1, 1, 1);
--图集数字
local CAtlasNumber = GameRequire("AtlasNumber");
--对应 GenerateFish FishControl
local idCreator =ID_Creator(0);

local FishAction_Type=
{
    Move = idCreator(1),
    Dead = idCreator(),
    Max  = idCreator(),
};

local CEventObject=GameRequire("EventObject");
local CObject=GameRequire("Object");

local _CFishAction = class("_CFishAction",CObject);

function _CFishAction:ctor(_fishType)
    _CFishAction.super.ctor(self);
    self.bg = nil;
    self.bgImg = nil;
    self.actions = {};
    self.curAction = nil;
    self.bodyImage = nil;
    self.curColor  = nil;
    self.fishType  = _fishType;
    self.interval  = 0;
    self.playSpeed = 1;
end

function _CFishAction:Init(transform,interval,vec)
    self.transform = transform;
    self.gameObject= transform.gameObject;
    local boxCollider;
    local action = transform:Find("Actions");
    if action then
        local childCount = action.childCount;
        local actions = self.actions;
        self.interval = interval;
        local curAction;
        local transform;
        for i=1,childCount do
            transform = action:GetChild(i-1);
            if transform then
                boxCollider = transform:GetComponent("BoxCollider");
                if boxCollider then
                    vec:push_back(boxCollider);
                end
   	        curAction = transform:GetComponent("ImageAnima");
                actions[i] = curAction;
                if curAction then
                    self.interval = curAction.fSep;
                    if curAction and interval then
                        curAction.fSep = interval;
                    end
                end
            end
        end
    end
    if interval then
        self.interval = interval;
    end
    local bg =nil;
    bg = transform:Find("Bg");
    if bg then
        self.bg = bg;
        self.bgImg = bg.gameObject:GetComponent("Image");
    end
end

--设置播放速度
function _CFishAction:SetPlaySpeed(_speed)
    if _speed==self.playSpeed then
    else
        self.playSpeed = _speed;
        for i=1,FishAction_Type.Max-1 do
            if self.actions[i]==nil then

            else
                if _speed == 0 then
                    self.actions[i].fSep = 99999999;
                else
                    self.actions[i].fSep = self.interval/_speed;
                end
            end
        end
    end
    
end

--底盘自旋转
function _CFishAction:_bgRotate(rotation)
    if self.bg then
        self.bg:Rotate(0,0,rotation);
    end
end

function _CFishAction:SetBgActive(isVisible)
    if self.bg then
        self.bg.gameObject:SetActive(isVisible);
    end
end

function _CFishAction:ChangeActionColor(_color)
    if self.bodyImage then
        self.bodyImage.color = _color;
    end
    if self.bgImg then
        self.bgImg.color     = _color;
    end
    self.curColor = _color;
end

--播放动作
function _CFishAction:_playAction(_id,_isAlways,_handler)
    if _isAlways==nil then
        _isAlways = true;
    end
    for i=1,FishAction_Type.Max-1 do
        if self.actions[i]==nil then

        else
            if i == _id then
                self.curAction = self.actions[i];
                self.actions[i].gameObject:SetActive(true);
                if _isAlways then
                    self.actions[i]:PlayAlways();
                else
                    self.actions[i]:Play();
                end
                if _handler then
                    self.actions[i]:SetEndEvent(_handler);
                end
                self.bodyImage = self.curAction.gameObject:GetComponent("Image");
                if self.curColor then
                    self:ChangeActionColor(self.curColor);
                end
            else
                self.actions[i].gameObject:SetActive(false);
            end
        end
    end
end


local _CFishCollider = class("_CFishCollider",CEventObject);

function _CFishCollider.Create(_fish,_type)
    local fishCollider = _CFishCollider.New(_fish);
    fishCollider:_initStyle(_type);
    return fishCollider;
end

function _CFishCollider:ctor(_fish)
    _CFishCollider.super.ctor(self);
    self._fish = _fish;
end

function _CFishCollider:_initStyle(_type)
    self.gameObject = G_GlobalGame._goFactory:createFishCollider(_type);
    self.transform  = self.gameObject.transform;
    self.isOwner = _isOwner;
    self.type    = _type;
end

function _CFishCollider:OnTriggerEnter(coll)
    return self._fish:OnTriggerEnter(coll);
end

local _CFish = class("_CFish",CEventObject);

--创建鱼
function _CFish.Create(_type,_creator)
    local fish = _CFish.New();
    fish:_initStyle(_type,_creator);
    return fish;
end


function _CFish:ctor()
    _CFish.super.ctor(self);
    self._fishId  = 0;
    self._fishType= 0;
    self._fishFlag= G_GlobalGame.Enum_FISH_FLAG.Common_Fish;
    self.isDie = false;
    self.actions= {};
    self.bgs    = {};
    self.imgBgs = {};
    self.rotation = 0;
    self.timer  = 0;
    self.bgRotationTime = 0.05;
    self.runRotationTime =0;
    self.curAction=nil;
    self.bodyImage=nil;
    self.isHurt = false;
    self.hurtTime = 0;
    self.fishActions = {};
    self.isFalseDie =false;
    self.straightMove = false;
    self.beginStraightPos = nil;
    self.straightMoveTime = 0;
    self.deadTime = 0;

    self.moveSpeed = 1;

    self.playSpeed = 1;
    
    self.boxCollidersVec = vector:new();
end

function _CFish:_initStyle()


end

function _CFish:_initStyle(_type,_creator)
    self._fishType = _type;
    self.gameObject= G_GlobalGame._goFactory:createFishNew(_type);
    self.transform = self.gameObject.transform;
    local fishConfig = G_GlobalGame.GameConfig.FishInfo[_type];
    local boxColliders ;
    if fishConfig.bgActInterval then
        self.bgRotationTime = fishConfig.bgActInterval;
    end
    if _type >= G_GlobalGame.Enum_FishType.FISH_KIND_25 and _type<= G_GlobalGame.Enum_FishType.FISH_KIND_30 then
        --大三元，大四喜
        local childCount = self.transform.childCount;
        local fishAction ;
        for i=1,childCount do
            fishAction = _CFishAction.New(_type);
            fishAction:Init(self.transform:GetChild(i-1),fishConfig.actInterval,self.boxCollidersVec);
            self.fishActions[i] = fishAction;
        end
    else
        self.fishActions[1] = _CFishAction.New(_type);
        self.fishActions[1]:Init(self.transform,fishConfig.actInterval,self.boxCollidersVec);
    end

    if _creator then
        self._multipleLabel = CAtlasNumber.New(_creator);
        self._multipleLabel:SetParent(self.transform);
        self._multipleLabel:Hide();
        self._multipleLabel:SetLocalPosition(Vector3.New(0,165,0));
        self._multipleLabel:SetLocalScale(Vector3.New(0.6,0.6,0.6));
    end
end


function _CFish:SetMultiple(_multiple)
    if self._multipleLabel then
        self._multipleLabel:Display();
        self._multipleLabel:SetNumber(_multiple);
    end
end

function _CFish:BoxColliders()
    return self.boxCollidersVec;
end

--
function _CFish:Init(_info)
    local fishConfig = G_GlobalGame.GameConfig.FishInfo[self._fishType];
    self._alpha = 1;
    self:_changeFishColor(C_NormalColor);
    self.isDie = false;
    self.rotation = 15;
    
    --设置大小和旋转
    self.transform.localScale = Vector3.New(1,1,1);
    self.transform.localRotation = Quaternion.Euler(0,0,0);

    if _info then
        self.movePath = {};
        self.movePath.points={};
        self.movePath.pointCount=_info.initCount;
        for i=1,_info.initCount do
            self.movePath.points[i] = Vector3.New(_info.point[i].x, _info.point[i].y,0);
        end
        self.movePath.type = _info.traceType;
        self.movePath.moveTime= 0;
        self.movePath.timeLen = fishConfig.localSpeed;
        self.movePath.angleInfo = {};
        self.movePath.angleInfo.runAngleTime=0;
        self.movePath.angleInfo.angleTime   =1;
        self.movePath.angleInfo.needAngle   =0;
        self.movePath.angleInfo.isPlusign   =false;
        self.transform.localPosition = self.movePath.points[1];

        local pos = self:GetPathPoint(0.1);
        local r = G_GlobalGame.FunctionsLib.FUNC_GetEulerAngle(self.movePath.points[1],pos);
        self.transform.localRotation = Quaternion.Euler(0,0,r+90);
    else
        self.movePath = nil;
    end

    self:_playAction(FishAction_Type.Move);

    self.isEnterScreen = false;
    --消失了 
    self.isDisappear   = false;
    --假死
    self.isFalseDie   = false;

    --直线走
    self.straightMove = false;
    self.straightMoveTime = 0;

    --是否能被锁定
    self._isCanBeLock = true;

    self:SetBgActive(true);

--    if self._fishType == G_GlobalGame.Enum_FishType.FISH_KIND_21 then
--        self:SetMultiple(50);
--    end

    --移动速度
    self:NormalMove();

    --存活时间
    self._relifeTime = nil;
end

--碰撞区
function _CFish:BoxCollider()
    return self.fishCollider;
end

function _CFish:SetFishFlag(_flag)
    self._fishFlag= _flag or G_GlobalGame.Enum_FISH_FLAG.Common_Fish;
end

function _CFish:SetBgActive(isVisible)
    local fishCount = #self.fishActions;
    for i=1,fishCount do
        self.fishActions[i]:SetBgActive(isVisible);
    end
end

--播放移动
function _CFish:PlayMove()
    self:_playAction(FishAction_Type.Move);
end

--鱼类型
function _CFish:FishType()
    return self._fishType;
end

-- 每帧
function _CFish:Update(_dt,_isPause,x1,y1,x2,y2)
    if self.isDie then
        --检测死亡
        self:_checkDead(_dt);
        return;
    end

    self:_bgRotate(_dt);
    if not _isPause then
        self:_move(_dt);
    end
    self:_checkHurt(_dt);
    self:_checkIsInScreen(x1,y1,x2,y2);
end

--确定是否在屏幕内
function _CFish:_checkIsInScreen(x1,y1,x2,y2)
    if self.isEnterScreen then
        local x=self.transform.position.x;
        local y = self.transform.position.y;
        if x>x1 and x<x2 and y>y1 and y<y2 then
            
        else
            if self._relifeTime~=nil then
                self.isDie=true; 
                self:Disappear(); 
                self._relifeTime = nil;
            else
                --通知离开了屏幕
                self.isEnterScreen = false;
                self:SendEvent(G_GlobalGame.Enum_EventID.BeforeFishLeaveScreen);
                self:SendEvent(G_GlobalGame.Enum_EventID.FishLeaveScreen);
            end

        end  
    else
        --还没有进入过屏幕
        local x=self.transform.position.x;
        local y = self.transform.position.y;
        if x>x1 and x<x2 and y>y1 and y<y2 then
            --通知进入了屏幕
            self.isEnterScreen = true;
            self:SendEvent(G_GlobalGame.Enum_EventID.BeforeFishEnterScreen);
            self:SendEvent(G_GlobalGame.Enum_EventID.FishEnterScreen);
        end  
    end
end

--存活时间
function _CFish:RelifeTime(_time)
    self._relifeTime = _time;
end

function _CFish:GetPathPoint(_dt)
    local movePath = self.movePath;
    local movePoint = movePath.points;
    local _fishpos=nil;
--[[    if movePath.pointCount==2 then
        _fishpos = BezierPathFor_2(movePoint[1], movePoint[2],_dt);       
    else
        _fishpos = BezierPathFor_3(movePoint[1], movePoint[2], movePoint[3], _dt);
    end--]]
		 _fishpos = BezierPathFor_5(movePoint[1], movePoint[2], movePoint[3],movePoint[4],movePoint[5],_dt);
    return _fishpos;
end

function _CFish:_move(_dt)
    if self._relifeTime~=nil then
        --有设定存活时间
        self._relifeTime = self._relifeTime - _dt;
        if self._relifeTime<=0 then 
            self.isDie=true; 
            self:Disappear(); 
            self._relifeTime = nil;
            return ; 
        end
    end
    if self.straightMove then
        self.straightMoveTime = self.straightMoveTime + _dt * self.moveSpeed;
        --self.transform.localPosition = self.transform.localPosition + self.speed;
        local _fishpos = self.beginStraightPos + self.speed *self.straightMoveTime;
        self.transform.localPosition = _fishpos;
        --碰撞区
        --self.fishCollider:SetLocalRotation(self.transform.localRotation);
        --self.fishCollider:SetLocalPosition(_fishpos);
        return;
    end
    if not self.movePath then
        --没有移动数据
        --local position = self.transform.position;
        --local rotation = self.transform.rotation;
        --self.fishCollider:SetRotation(rotation);
        --self.fishCollider:SetPosition(position);
        return ;
    end
    local movePath = self.movePath;
    local movePoint = movePath.points;
    movePath.moveTime = movePath.moveTime + _dt * self.moveSpeed;
    local t = movePath.moveTime / movePath.timeLen;
    if t > 1.1 or t == 1.1 then self.isDie=true; self:Disappear();  return; end
    local _fishpos=nil;
    local _nextPos=nil;
--[[    if movePath.pointCount==2 then
        _fishpos = BezierPathFor_2(movePoint[1], movePoint[2],t);
        --_nextPos = BezierPathFor_2(movePoint[1], movePoint[2],t + 0.1);        
    else
        _fishpos = BezierPathFor_3(movePoint[1], movePoint[2], movePoint[3], t);
        --_nextPos = BezierPathFor_3(movePoint[1], movePoint[2], movePoint[3], t + 0.1);
    end--]]
 _fishpos = BezierPathFor_5(movePoint[1], movePoint[2], movePoint[3],movePoint[4],movePoint[5],t);
    local lastPosition = self.transform.localPosition;
    
    local r = G_GlobalGame.FunctionsLib.FUNC_GetEulerAngle(lastPosition,_fishpos);
    local localRotation = Quaternion.Euler(0,0,r+90);
    self.transform.localRotation = localRotation;
    self.transform.localPosition = _fishpos;

    --碰撞区
    --self.fishCollider:SetLocalRotation(localRotation);
    --self.fishCollider:SetLocalPosition(_fishpos);
end

--底盘自旋转
function _CFish:_bgRotate(_dt)
    self.runRotationTime = self.runRotationTime - _dt * self.playSpeed;
    if  self.runRotationTime>0 then
        return;
    end
    local fishCount = #self.fishActions;
    for i=1,fishCount do
        self.fishActions[i]:_bgRotate(self.rotation);
    end
    self.runRotationTime = self.bgRotationTime + self.runRotationTime;
end

--死亡动画播放完
function _CFish:OnDie()
    if self.isDie then
        self:Disappear();
    end
end


--消失
function _CFish:Disappear()
    --通知死亡事件
    self:SendEvent(G_GlobalGame.Enum_EventID.FishDie);
    --删除事件列表
    self:ClearEvent();
end

--受伤
function _CFish:Hurt()
    self.isHurt = true;
    self.hurtTime = G_GlobalGame.GameConfig.SceneConfig.fishHurtTime;
    self:_changeFishColor(C_HurtColor);
end

function _CFish:_checkHurt(_dt)
    if self.isHurt then
        self.hurtTime = self.hurtTime - _dt * self.playSpeed;
        if self.hurtTime<0 then
            self:_changeFishColor(C_NormalColor);
            self.isHurt = false;
        end
    end
end

function _CFish:_checkDead(_dt)
    if self.isDie then
        self.deadTime = self.deadTime - _dt * self.playSpeed;
        if self.deadTime<=0 then
            self:OnDie();
        end
    end
end

function _CFish:IsFlag(_flag)
    return self._fishFlag == _flag;
end

function _CFish:IsFishType(_fishType)
    return self._fishType == _fishType;
end

function _CFish:FishType()
    return self._fishType;
end

--鱼ID
function _CFish:FishID()
    return self._fishId;
end

--设置鱼ID
function _CFish:SetFishID(_fishId)
    self._fishId = _fishId;
end

--是否死亡了
function _CFish:IsDie()
    return self.isDie;
end

--鱼死了
function _CFish:Die()
    local fishConfig = G_GlobalGame.GameConfig.FishInfo[self._fishType];
    if fishConfig.deadEffect==nil then
    else
        --特效
        G_GlobalGame:DispatchEventByStringKey("NotifyCreateEffect",{type=fishConfig.deadEffect,position = self:Position()});   
        if fishConfig.ShakeScreen then
            G_GlobalGame:DispatchEventByStringKey("NotifyShakeScreen"); 
        end
    end
    self:SendEvent(G_GlobalGame.Enum_EventID.FishDead);
    
    self.isHurt= false;
    self:_changeFishColor(C_HurtColor);
    self.isDie = true;
    --self:_playAction(FishAction_Type.Dead,false,handler(self,self.OnDie));
    self:_playAction(FishAction_Type.Dead,true);
    self.deadTime = G_GlobalGame.GameConfig.SceneConfig.iFishDeadTime;
    local FishType = G_GlobalGame.Enum_FishType;
    --
    if self._fishType == FishType.FISH_KIND_24 then
        self:SetBgActive(false);
    end


end

--假死
function _CFish:FalseDie()
    self.isFalseDie = true;
    self:Die();
end

--真死
function _CFish:RealDie()
    self.isFalseDie = false;
    if not self.isDie then
        --直接死了
        self:Die();
    end
end

--是否假死
function _CFish:IsFalseDie()
    return self.isFalseDie;
end

--播放动作
function _CFish:_playAction(_id,_isAlways,_handler)
    if _isAlways==nil then
        _isAlways = true;
    end
    local fishCount = #self.fishActions;
    for i=1,fishCount do
        if i==1 then
            self.fishActions[i]:_playAction(_id,_isAlways,_handler);
        else
            self.fishActions[i]:_playAction(_id,_isAlways);
        end
    end
end

--是否能被锁定
function _CFish:IsCanBeLock()
    return not self.isHide and self._isCanBeLock and G_GlobalGame.FunctionsLib.Mod_Fish_IsCanBeLock(self:FishType());
end

--设置锁定
function _CFish:CanBeLock()
    self._isCanBeLock = true;
end

function _CFish:Display()
    self.isHide = false;
    if self.fishCollider then
        self.fishCollider:Display();
    end
    _CFish.super.Display(self);
end

function _CFish:Hide()
    self.isHide = true;
    if self.fishCollider then
        self.fishCollider:Hide();
    end
    _CFish.super.Hide(self);
end
--设置不锁定
function _CFish:CanNotBeLock()
    self._isCanBeLock = false;
end

--设置透明通道
function _CFish:SetAlpha(_a)
    local tempAlpha = self._alpha;
    self._alpha = _a;
    if self._alpha>1 then
        self._alpha = 1;
    end
    if self._alpha<0 then
        self._alpha = 0;
    end
    if tempAlpha == self._alpha then
        --通道值一样
        return ;
    end
    self:_changeFishColor(self._color);
end

--增加透明通道
function _CFish:AddAlpha(_a)
    self:SetAlpha(self._alpha + _a);
end

--透明通道值
function _CFish:Alpha()
    return self._alpha;
end

function _CFish:NormalColor()
    self:_changeFishColor(C_NormalColor);
end

--改变鱼的颜色
function _CFish:_changeFishColor(_color)
    self._color = Color.New(_color.r,_color.g,_color.b,self._alpha);
    local fishCount = #self.fishActions;
    for i=1,fishCount do
        self.fishActions[i]:ChangeActionColor(self._color);
    end
end

--是否进入屏幕
function _CFish:IsInScreen()
    return self.isEnterScreen;
end

local isTest = 1;
local isTest2 = 1;

--直线移动
function _CFish:StraightMove(multiple)
    multiple = multiple or 1;
    --计算速度
    local GameConfig = G_GlobalGame.GameConfig;
    local fishConfig = GameConfig.FishInfo[self._fishType];
    local angle = self.transform.localEulerAngles.z;
    local rd=math.rad(angle);
    local x,y
    --[[
    if angle>=270 then
        if isTest>0 then
            error("angle:" .. angle .. ",sin:" .. math.sin(rd) .. ",speed:" .. fishConfig.iSpeed );
            error("angle:" .. angle .. ",cos:" .. math.cos(rd) .. ",speed:" .. fishConfig.iSpeed );
            y = math.sin(rd)*fishConfig.iSpeed*multiple*LKPY_GameConfig.SceneConfig.FrameCount;
            x = math.cos(rd)*fishConfig.iSpeed*multiple*LKPY_GameConfig.SceneConfig.FrameCount;
            error("x:" .. x .. ",y:" .. y);
        else
            y = math.sin(rd)*fishConfig.iSpeed*multiple*LKPY_GameConfig.SceneConfig.FrameCount;
            x = math.cos(rd)*fishConfig.iSpeed*multiple*LKPY_GameConfig.SceneConfig.FrameCount; 
        end
        isTest = isTest - 1;

    elseif angle>250 then
        if isTest2>0 then
            error("angle:" .. angle .. ",sin:" .. math.sin(rd) .. ",speed:" .. fishConfig.iSpeed );
            error("angle:" .. angle .. ",cos:" .. math.cos(rd) .. ",speed:" .. fishConfig.iSpeed );
            y = math.sin(rd)*fishConfig.iSpeed*multiple*LKPY_GameConfig.SceneConfig.FrameCount;
            x = math.cos(rd)*fishConfig.iSpeed*multiple*LKPY_GameConfig.SceneConfig.FrameCount;
            error("x:" .. x .. ",y:" .. y);
        else
            y = math.sin(rd)*fishConfig.iSpeed*multiple*LKPY_GameConfig.SceneConfig.FrameCount;
            x = math.cos(rd)*fishConfig.iSpeed*multiple*LKPY_GameConfig.SceneConfig.FrameCount;
        end
        isTest2 = isTest2 - 1;

    else
        y = math.sin(rd)*fishConfig.iSpeed*multiple*LKPY_GameConfig.SceneConfig.FrameCount;
        x = math.cos(rd)*fishConfig.iSpeed*multiple*LKPY_GameConfig.SceneConfig.FrameCount; 
    end
    --]]
    y = math.sin(rd)*fishConfig.iSpeed*multiple*GameConfig.SceneConfig.FrameCount * 0.6;
    x = math.cos(rd)*fishConfig.iSpeed*multiple*GameConfig.SceneConfig.FrameCount * 0.6; 
    --self.speed   = Vector3.New(fishConfig.iSpeed,0,0)*self.transform.localRotation;
    self.speed = Vector3.New(x,y,0);
    self.straightMove = true;
    self.beginStraightPos = self.transform.localPosition;
    self.straightMoveTime = 0;
end

--快速移出屏幕
function _CFish:QuickMove()
    --移动速度变成3倍
    self.moveSpeed = 6;
    self.playSpeed = 2.5;
    local fishCount = #self.fishActions;
    for i=1,fishCount do
        self.fishActions[i]:SetPlaySpeed(self.playSpeed);
    end
end

--正常移动
function _CFish:NormalMove()
    self.moveSpeed = 1;
    self.playSpeed = 1;
    local fishCount = #self.fishActions;
    for i=1,fishCount do
        self.fishActions[i]:SetPlaySpeed(self.playSpeed);
    end
end

function _CFish:Cache()
    _CFish.super.Cache(self);
    --碰撞区也保存了
    --self.fishCollider:Cache();
end

--设置鱼的游戏体名字
function _CFish:SetName(_name)
    self.gameObject.name = _name;
    --self.fishCollider.gameObject.name = _name;
end

----创建小鱼
--function _CFish:CreateFishes()

--end

return _CFish;