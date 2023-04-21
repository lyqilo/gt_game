local CObject = GameRequire("Object");
local CEventObject = GameRequire("EventObject");

local _CFlyGold = class("_CFlyGold",CEventObject);
local GoldName = "Gold";
function _CFlyGold:ctor(_type)
    _CFlyGold.super.ctor(self);
    self._type = _type;
    if _type == G_GlobalGame.Enum_GoldType.Gold then
        self.gameObject = G_GlobalGame._goFactory:createGold();
    elseif _type == G_GlobalGame.Enum_GoldType.Silver then
        self.gameObject = G_GlobalGame._goFactory:createSilver();
    end
    self.transform  = self.gameObject.transform;
    self.gameObject.name = GoldName;
    self.isOver     = false;
    self.imageAnima = self.gameObject:GetComponent(typeof(ImageAnima));
    self.imageAnima:PlayAlways();
end

--初始化
function _CFlyGold:Init(_parent,_localPosition,_targetPos,_time)
    self.transform:SetParent(_parent);
    self.transform.localPosition = _localPosition;
    local endScale
    if self._type == G_GlobalGame.Enum_GoldType.Gold then
        endScale = Vector3.New(0.7,0.7,0.7)*1.2;
        self.transform.localScale    = Vector3.New(0.7,0.7,0.7) * 0.6;
        --self.transform.localScale    = Vector3.New(0.7,0.7,0.7);
    elseif self._type == G_GlobalGame.Enum_GoldType.Silver then
        endScale = Vector3.one *1.2;
        self.transform.localScale    = Vector3.one * 0.6;
    end
    self.transform.localRotation = Quaternion.Euler(0,0,0);
    coroutine.start(
        function ()
            coroutine.wait(0.3);
            if G_GlobalGame.isQuitGame then
                return ;
            end
            local dotw = self.transform:DOMove(_targetPos,_time,false);
            local dotw2 = self.transform:DOScale(endScale,_time-0.1);
            dotw:OnComplete(
                function()
                    self.isOver     = true;
                    if G_GlobalGame.isQuitGame then
                        return ;
                    end
                    self:SendEvent(G_GlobalGame.Enum_EventID.FlyGoldDisappear);
                end
            );
        end
    );
end

--类型
function _CFlyGold:Type()
    return self._type;
end

--每个金币
function _CFlyGold:Update(_dt)

end

local _CFlyGoldGroup = class("_CFlyGoldGroup",CEventObject);

local Name = "FlyGoldGroup";
function _CFlyGoldGroup:ctor()
    _CFlyGoldGroup.super.ctor(self);
    self.gameObject = GameObject.New();
    self.gameObject.name = Name;
    self.transform  = self.gameObject.transform;
    self.golds      = {};
    self.runTime    = 0;
    self.points     = {};
end

function _CFlyGoldGroup:SetParent(transform)
    self.transform:SetParent(transform);
    self.transform.localRotation = Quaternion.Euler(0,0,0);
    self.transform.localScale    = Vector3.one;
end


function _CFlyGoldGroup:Init(chairId,count,startPos,endPos,isRotation,_goldCreator)  
    self.chairId        = chairId;  
    self.count          = count;
    self.iCreateCount   = 0;
    self.iDisappearCount= 0;
    self.isRotation     = isRotation or false;
    self.startPos       = startPos;
    self.endPos         = endPos;
    self.golds          = {};
    self.points         = {};
    self._goldCreator   = _goldCreator;
    self.transform.position = endPos;
    local endPosition = self.transform.localPosition;
    self.transform.position = startPos;
    local startPosition = self.transform.localPosition;

    if self.isRotation then
        self.transform.localRotation = Quaternion.Euler(0,0,180);
    else
        self.transform.localRotation = Quaternion.Euler(0,0,0);
    end
    --需要的时间
    self.needTime       = Vector3.Distance(endPosition,startPosition)/G_GlobalGame.GameConfig.SceneConfig.flyGoldSpeed;
    if self.needTime<1 then
        self.needTime = 1;
    end
    --计算坐标
    self:CountPos();
end



--计算并记录坐标
function _CFlyGoldGroup:CountPos()
    --创建金币效果
    local count   = self.count;
    local maxY  = count*60;
    --随机金币的弧度，负数往上翘，正数往下翘
    local randomY = (math.random(0,100)-50); 
    local isNeed  = false;
    local toward  = 1;
    local dis = 80;

    local beginCount=math.random(1,count);
    beginCount = math.floor((count+1)/2);
    if isNeed then
        toward=-1
    end

    --计算第一个金币的起始位置
    local w=dis*(count-1)/2;
    local h=randomY*(count-1)/2; --最高点高度
    local offsetPos={x=0-w,y=0-h,z=0};
    local isTop=true;
    local isSingle=false;

    if count%2==1 then
        isSingle = true;
    else
        isSingle =false;
    end
    for i=1,count do
        self.points[i] = Vector3.New(offsetPos.x,offsetPos.y,offsetPos.z);
        offsetPos.x=offsetPos.x+dis;
        if isNeed then
            if isSingle then
                if i<beginCount then
                    offsetPos.y= offsetPos.y + randomY;
                else
                    offsetPos.y= offsetPos.y + randomY*-1;
                end
            else
                if i==beginCount then
                    offsetPos.y= offsetPos.y;
                elseif i<beginCount then
                    offsetPos.y= offsetPos.y + randomY;
                else
                    offsetPos.y= offsetPos.y + randomY*-1;
                end                
            end
        else
            offsetPos.y= offsetPos.y + randomY;
        end
    end
end

function _CFlyGoldGroup:Update(_dt)
    --[[
    for i=1,self.iCreateCount do
        self.golds[i]:Update(_dt);
    end
    --]]
    if self.iCreateCount<self.count then
        self.runTime = self.runTime - _dt;
        if self.runTime<0 then
            local gold = self._goldCreator();
            --注册事件
            gold:RegEvent(self,self.OnFishGoldEvent);
            self.iCreateCount = self.iCreateCount+1;
            self.golds[self.iCreateCount] = gold;
            gold:Init(self.transform,self.points[self.iCreateCount],self.endPos,self.needTime);
            if self.iCreateCount<self.count then
                self.runTime = G_GlobalGame.GameConfig.SceneConfig.createGoldInterval + self.runTime;
            else
                --都创建完了
            end
        end
    end
end

function _CFlyGoldGroup:OnFishGoldEvent()
    self.iDisappearCount = self.iDisappearCount + 1;
    if self.iDisappearCount>=self.count then
        --通知自己消失
        self:SendEvent(G_GlobalGame.Enum_EventID.FlyGoldGroupDisappear);
    end
end

--金币队列
function _CFlyGoldGroup:GetGoldTab()
    return self.golds;
end

--金币个数
function  _CFlyGoldGroup:Count()
    return self.count;
end

--飞金币管理
local _CFlyGoldControl=class("_CFlyGoldControl");

function _CFlyGoldControl:ctor()
    self._flyGoldGroupCache = vector:new();
    self._flyGoldCache      = vector:new();
    self._flySilverCache    = vector:new();
    self._runningFlyGoldMap = map:new();
    self._delListVec        = vector:new();
    self._delGoldVec        = vector:new();
    self._readyToFlyGold    = map:new();
end

--初始化
function _CFlyGoldControl:Init(transform)
    self.transform  = transform;
    self.gameObject = transform.gameObject;
end

--飞金币
function _CFlyGoldControl:CreateFlyGold(chairId,_type,count,startPos,endPos,isRotation,waitTime)
    waitTime = waitTime or 0;
    local flyGroup;
    if self._flyGoldGroupCache:size()>0 then
        flyGroup = self._flyGoldGroupCache:pop();
    else
        flyGroup = _CFlyGoldGroup.New();
    end
    flyGroup:SetParent(self.transform);
    if _type == G_GlobalGame.Enum_GoldType.Gold then
        flyGroup:Init(chairId,count,startPos,endPos,isRotation,handler(self,self._createFlyGold));
    elseif _type == G_GlobalGame.Enum_GoldType.Silver then
        flyGroup:Init(chairId,count,startPos,endPos,isRotation,handler(self,self._createFlySilver));
    end
    flyGroup:RegEvent(self,self.OnFlyGoldGroupEvent);
    if waitTime==0 then
        self._runningFlyGoldMap:assign(flyGroup:LID(),flyGroup);
        --金币声音
        G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.Catch);
    else
        local item = {
            item = flyGroup,
            waitTime = waitTime,
        };
        self._readyToFlyGold:assign(flyGroup:LID(),item);
        --self._runningFlyGoldMap:assign(flyGroup:LID(),flyGroup);
    end

end

--金币
function _CFlyGoldControl:_createFlyGold()
    local flyGold;
    if self._flyGoldCache:size()>0 then
        flyGold = self._flyGoldCache:pop();
    else
        flyGold = _CFlyGold.New(G_GlobalGame.Enum_GoldType.Gold);
    end
    flyGold:RegEvent(self,self.OnFlyGoldEvent);
    return flyGold;
end

--银币
function _CFlyGoldControl:_createFlySilver()
    local flyGold;
    if self._flySilverCache:size()>0 then
        flyGold = self._flySilverCache:pop();
    else
        flyGold = _CFlyGold.New(G_GlobalGame.Enum_GoldType.Silver);
    end
    flyGold:RegEvent(self,self.OnFlyGoldEvent);
    return flyGold;
end

--飞金币
function _CFlyGoldControl:OnFlyGoldEvent(_eventId,_flyGold)
    if _eventId == G_GlobalGame.Enum_EventID.FlyGoldDisappear then
        self._delGoldVec:push_back(_flyGold);
    end
end

--飞金币组消失
function _CFlyGoldControl:OnFlyGoldGroupEvent(_eventId,_flyGoldGroup)
    if _eventId == G_GlobalGame.Enum_EventID.FlyGoldGroupDisappear then
        self._delListVec:push_back(_flyGoldGroup:LID());
    end
end


--每帧执行
function _CFlyGoldControl:Update(_dt)
    local it = self._delGoldVec:iter();
    local val = it();
    while(val )do
        val:Cache();
        if val:Type() == G_GlobalGame.Enum_GoldType.Gold then
            self._flyGoldCache:push_back(val);
        elseif val:Type() == G_GlobalGame.Enum_GoldType.Silver then
            self._flySilverCache:push_back(val);
        end
        val = it();
    end
    self._delGoldVec:clear();
    
    local fishGroup =nil;
    local count;
    it = self._delListVec:iter();
    val = it();
    while(val) do
        fishGroup = self._runningFlyGoldMap:erase(val);
        if fishGroup then
            fishGroup:Cache();
            self._flyGoldGroupCache:push_back(fishGroup);
        end
        val = it();
    end
    self._delListVec:clear();

    it = self._runningFlyGoldMap:iter();
    val = it();
    while (val) do
        fishGroup = self._runningFlyGoldMap:value(val);
        if fishGroup then
            fishGroup:Update(_dt);
        end
        val = it();
    end

    local delVec = vector:new();
    it = self._readyToFlyGold:iter();
    val = it();
    local item ;
    while(val) do
        item = self._readyToFlyGold:value(val);
        item.waitTime = item.waitTime - _dt;
        if item.waitTime<=0 then
            delVec:push_back(val);
            self._runningFlyGoldMap:assign(val,item.item);
            --金币声音
            G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.Catch);
        end
        val = it();
    end

    --删除
    it = delVec:iter();
    val = it();
    while(val) do
        self._readyToFlyGold:erase(val);
        val = it();
    end
end

function _CFlyGoldControl:Clear()


end


return _CFlyGoldControl;