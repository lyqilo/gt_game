local CEventObject=GameRequire("EventObject");

local _CEffect = class("_CEffect",CEventObject);


function _CEffect.Create(_type)
    local effect = _CEffect.New();
    effect:_init(_type);
    return effect;
end

function _CEffect:ctor()
    _CEffect.super.ctor(self);
    self._type = nil;
end

function _CEffect:_init(_type)
    self.gameObject = G_GlobalGame._goFactory:createBombEffect(_type);
    self.transform  = self.gameObject.transform;
    self._type = _type;
    self.gameObject.name = "Effect " .. _type;
    self._anima = self.gameObject:GetComponent(typeof(ImageAnima));
    --self._anima.fSep  = LKPY_GameConfig.SceneConfig.playSpeed_BombEffect;
end

function _CEffect:Play()
    self._anima:StopAndRevert();
    self._anima:Play();
    self._anima:SetEndEvent(handler(self,self.onAnimaOver));
end


--消失
function _CEffect:onAnimaOver()
    self:SendEvent(G_GlobalGame.Enum_EventID.EffectDisappear);
end

--每帧调用
function _CEffect:Update(_dt)

end

function _CEffect:Type()
    return self._type;
end

local _CLineEffect = class("_CLineEffect",_CEffect)

function _CLineEffect.Create(_type)
    local effect = _CLineEffect.New();
    effect:_init(_type);
    return effect;
end

function _CLineEffect:ctor()
    _CLineEffect.super.ctor(self);
    self._speedVec = Vector3.New(2000,0,0);
    self._speed = nil; --移动速度
    self._curMaxLen = 0;
    self._curLocalPosition = 0;
    self._localBeginPosition = nil;
    self._localEndPosition   = nil;
end

function _CLineEffect:_init(_type)
    _CLineEffect.super._init(self,_type);
    self.image = self.transform:GetComponent(typeof(UnityEngine.UI.Image));
    --总长度
    self.maxWidth = 1600;
end

function _CLineEffect:Init(bossPosition,smallPosition)
    --终点启动，确定
    self.transform.position = smallPosition;
    self._localEndPosition = self.transform.localPosition;
    self.transform.position = bossPosition;
    self._localBeginPosition = self.transform.localPosition;
    self._curMaxLen = Vector3.Distance(self._localBeginPosition,self._localEndPosition);
    --self.image.fillAmount = 0;
    self._curLocalPosition = self._localBeginPosition;
    self._isMove = true;
    self._runTime = 0;
    local r = G_GlobalGame.FunctionsLib.FUNC_GetEulerAngle(bossPosition,smallPosition);
    r = r + 90;
    --self.image.fillAmount = self._curMaxLen/self.maxWidth;
    self.transform.rotation = Quaternion.Euler(0,0,r);
    --self.transform.eulerAngles = Vector3.New(0,0,r);
    --self.transform.localScale = Vector3.New(0,0,1);
    self._speed   = self._speedVec*self.transform.localRotation;
    --self.transform.eulerAngles = Vector3.New(0,0,r);
    --self.transform.eulerAngles = Vector3.New(0,0,r);
    --self.transform.position = smallPosition;
    --self.transform.localScale = Vector3.New(self._curMaxLen/self.maxWidth,self._curMaxLen/self.maxWidth,1);
    self.transform.localScale = Vector3.New(0,0,1);
end

function _CLineEffect:Play()
    self._anima:StopAndRevert();
    self._anima:PlayAlways();
end

function _CLineEffect:Update(_dt)
    ----[[
    if self._isMove then
        self:Move(_dt);
    end
    --]]
    self._runTime = self._runTime + _dt;
    if self._runTime >G_GlobalGame.GameConfig.SceneConfig.iLineDisplayTime then
        self:SendEvent(G_GlobalGame.Enum_EventID.EffectDisappear);
    end
end

--移动
function _CLineEffect:Move(_dt)
    self._curLocalPosition =  self._curLocalPosition + self._speed*_dt;
    local curLen = Vector3.Distance(self._localBeginPosition,self._curLocalPosition);
    if curLen>=self._curMaxLen then
        --self.image.fillAmount = self._curMaxLen/self.maxWidth;
        self.transform.localScale = Vector3.New(self._curMaxLen/self.maxWidth,self._curMaxLen/self.maxWidth,1);
        self.transform.localPosition = self._localEndPosition;
        self._isMove = false;
    else
        --self.image.fillAmount = curLen/self.maxWidth;
        self.transform.localScale = Vector3.New(curLen/self.maxWidth,curLen/self.maxWidth,1);
        self.transform.localPosition = self._curLocalPosition;
    end
end


local _CLineSourceEffect = class("_CLineSourceEffect",_CEffect);

function _CLineSourceEffect.Create(_type)
    local effect = _CLineSourceEffect.New();
    effect:_init(_type);
    return effect;
end


function _CLineSourceEffect:ctor()
    _CLineSourceEffect.super.ctor(self); 
    
end

function _CLineSourceEffect:_init(_type)
    _CLineSourceEffect.super._init(self,_type);
end

function _CLineSourceEffect:Update(_dt)
    self._runTime = self._runTime + _dt;
    if self._runTime >G_GlobalGame.GameConfig.SceneConfig.iLineDisplayTime then
        self:SendEvent(G_GlobalGame.Enum_EventID.EffectDisappear);
    end
end

function _CLineSourceEffect:Play()
    self._anima:StopAndRevert();
    self._anima:PlayAlways();
    self._runTime = 0;
end

local _CEffectControl=class("_CEffectControl");

function _CEffectControl:ctor(_sceneControl)
    self._sceneControl = _sceneControl;
    self._delEffectVec = vector:new();
    self._cacheEffectMap = map:new();
    self._layerEffect    = {};
    self._runMap        = map:new();

    --注册事件
    G_GlobalGame:RegEventByStringKey("NotifyCreateEffect",self,self.OnCreateEffect);
    G_GlobalGame:RegEventByStringKey("NotifyCreateLine",self,self.OnCreateLineEffect);
    G_GlobalGame:RegEventByStringKey("NotifyCreateLineSour",self,self.OnCreateLineSourceEffect);
    G_GlobalGame:RegEventByStringKey("NotifyClearAllEffects",self,self.OnClearAllEffect);
end

--初始化
function _CEffectControl:Init(transform)
    self.transform = transform;
    self.gameObject= transform.gameObject;
    local BombEffectType = G_GlobalGame.Enum_BombEffectType;
    for i=BombEffectType.FishDead, BombEffectType.Max-1 do
        self:_getEffectLayer(i);
    end
end

--创建特效
function _CEffectControl:OnCreateEffect(_eventId,_eventData)
    local _type = _eventData.type;
    local _pos  = _eventData.position;
    local effect;
    local vec = self._cacheEffectMap:value(_type);
    if vec ==nil or vec:size()==0 then
        --重新创建加载
        effect = _CEffect.Create(_type);
    else
        effect = vec:pop();
    end
    effect:SetParent(self:_getEffectLayer(_type));
    effect:SetPosition(_pos);
    effect:RegEvent(self,self.OnEventEffect);
    effect:Play();
    --插入
    self._runMap:insert(effect:LID(),effect);
    return effect;
end

function _CEffectControl:OnCreateLineEffect(_eventId,_eventData)
    local bossPosition = _eventData.bossPosition;
    local smallPosition= _eventData.smallPosition;
    local _type = _eventData.type;
    local effect;
    local vec = self._cacheEffectMap:value(_type);
    if vec ==nil or vec:size()==0 then
        --重新创建加载
        effect = _CLineEffect.Create(_type);
    else
        effect = vec:pop();
    end
    effect:SetParent(self:_getEffectLayer(_type));
    effect:Init(bossPosition,smallPosition);
    effect:RegEvent(self,self.OnEventEffect);
    effect:Play();
    --插入
    self._runMap:assign(effect:LID(),effect);
    return effect;
end

function _CEffectControl:OnCreateLineSourceEffect(_eventId,_eventData)
    local _pos = _eventData.position;
    local _type = _eventData.type;
    local effect;
    local vec = self._cacheEffectMap:value(_type);
    if vec ==nil or vec:size()==0 then
        --重新创建加载
        effect = _CLineSourceEffect.Create(_type);
    else
        effect = vec:pop();
    end
    effect:SetParent(self:_getEffectLayer(_type));
    effect:SetPosition(_pos);
    effect:RegEvent(self,self.OnEventEffect);
    effect:Play();
    --插入
    self._runMap:assign(effect:LID(),effect);
    return effect;
end

--创建效果层
function _CEffectControl:_getEffectLayer(_type)
    if not self._layerEffect[_type] then
        local obj = GameObject.New();
        obj.transform:SetParent(self.transform);
        obj.transform.localScale = Vector3.one;
        obj.transform.localPosition = Vector3.zero;
        obj.transform.localEulerAngles = Vector3.zero;
        self._layerEffect[_type] = obj.transform;
    end
    return self._layerEffect[_type];
end

--事件
function _CEffectControl:OnEventEffect(_eventId,_eventObj)
    if _eventId==G_GlobalGame.Enum_EventID.EffectDisappear then
        self._delEffectVec:push_back(_eventObj:LID());
    else
        
    end
end

function _CEffectControl:OnClearAllEffect(_eventId,_eventObj)
    self:ClearAllEffects();
end

function _CEffectControl:ClearAllEffects()
    local it = self._runMap:iter();
    local val = it();
    local effect;
    local type;
    local vec;
    while(val) do
        effect = self._runMap:erase(val);
        if effect then
            effect:Cache(); 
            type = effect:Type();
            vec = self._cacheEffectMap:value(type)
            if vec== nil then
                vec = vector:new();
                self._cacheEffectMap:assign(type,vec);
            end
            vec:push_back(effect);
        end
        val = it();
    end
    self._runMap:clear();
    self._delEffectVec:clear();
end

--每帧执行
function _CEffectControl:Update(_dt)
    local it = self._delEffectVec:iter();
    local val = it();
    local effect;
    local type;
    local vec;
    while(val) do
        effect = self._runMap:erase(val);
        if effect then
            effect:Cache(); 
            type = effect:Type();
            vec = self._cacheEffectMap:value(type)
            if vec== nil then
                vec = vector:new();
                self._cacheEffectMap:assign(type,vec);
            end
            vec:push_back(effect);
        end
        val = it();
    end
    self._delEffectVec:clear();
    it = self ._runMap:iter();
    val = it();
    while(val) do
        effect = self ._runMap:value(val);
        if effect then
            effect:Update(_dt);
        end
        val = it();
    end
end



return _CEffectControl;