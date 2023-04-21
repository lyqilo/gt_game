local VECTOR3DIS                                        = VECTOR3DIS                                       
local VECTOR3ZERO                                       = VECTOR3ZERO                                      
local VECTOR3ONE                                        = VECTOR3ONE                                       
local COLORNEW                                          = COLORNEW                                         
local QUATERNION_EULER                                  = QUATERNION_EULER                                 
local QUATERNION_LOOKROTATION                           = QUATERNION_LOOKROTATION                          
local C_Quaternion_Zero                                 = C_Quaternion_Zero                                
local C_Vector3_Zero                                    = C_Vector3_Zero                                   
local C_Vector3_One                                     = C_Vector3_One                                    
local C_Color_One                                       = C_Color_One                                      
local V_Vector3_Value                                   = V_Vector3_Value                                  
local V_Color_Value                                     = V_Color_Value                                    
local ImageAnimaClassType                               = ImageAnimaClassType                              
local ImageClassType                                    = ImageClassType                                   
local GAMEOBJECT_NEW                                    = GAMEOBJECT_NEW                                   
local BoxColliderClassType                              = BoxColliderClassType                             
local ParticleSystemClassType                           = ParticleSystemClassType                          
local UTIL_ADDCOMPONENT                                 = UTIL_ADDCOMPONENT                                
local MATH_SQRT                                         = MATH_SQRT                                        
local MATH_SIN                                          = MATH_SIN                                         
local MATH_COS                                          = MATH_COS 
local MATH_ATAN                                         = MATH_ATAN
local MATH_TAN                                          = MATH_TAN                                        
local MATH_FLOOR                                        = MATH_FLOOR                                       
local MATH_ABS                                          = MATH_ABS                                         
local MATH_RAD                                          = MATH_RAD                                         
local MATH_RAD2DEG                                      = MATH_RAD2DEG                                     
local MATH_DEG                                          = MATH_DEG                                         
local MATH_DEG2RAD                                      = MATH_DEG2RAD                                     
local MATH_RANDOM                                       = MATH_RANDOM  
local MATH_PI                                           = MATH_PI                                     

local G_GlobalGame_EventID                              = G_GlobalGame_EventID                             
local G_GlobalGame_KeyValue                             = G_GlobalGame_KeyValue                            
local G_GlobalGame_GameConfig                           = G_GlobalGame_GameConfig                          
local G_GlobalGame_GameConfig_FishInfo                  = G_GlobalGame_GameConfig_FishInfo                 
local G_GlobalGame_GameConfig_Bullet                    = G_GlobalGame_GameConfig_Bullet                   
local G_GlobalGame_GameConfig_SceneConfig               = G_GlobalGame_GameConfig_SceneConfig              
local G_GlobalGame_GameConfig_AnimaStyleInfo            = G_GlobalGame_GameConfig_AnimaStyleInfo           
local G_GlobalGame_Enum_FishType                        = G_GlobalGame_Enum_FishType                       
local G_GlobalGame_Enum_FISH_Effect                     = G_GlobalGame_Enum_FISH_Effect                    
local G_GlobalGame_Enum_GoldType                        = G_GlobalGame_Enum_GoldType                       
local G_GlobalGame_Enum_EffectType                      = G_GlobalGame_Enum_EffectType                     
local G_GlobalGame_SoundDefine                          = G_GlobalGame_SoundDefine                         
local G_GlobalGame_ConstDefine                          = G_GlobalGame_ConstDefine                         
local G_GlobalGame_FunctionsLib                         = G_GlobalGame_FunctionsLib                        
local G_GlobalGame_FunctionsLib_FUNC_GetPrefabName      = G_GlobalGame_FunctionsLib_FUNC_GetPrefabName     
local G_GlobalGame_FunctionsLib_FUNC_CacheGO            = G_GlobalGame_FunctionsLib_FUNC_CacheGO           
local G_GlobalGame_FunctionsLib_FUNC_AddAnimate         = G_GlobalGame_FunctionsLib_FUNC_AddAnimate        
local G_GlobalGame_FunctionsLib_FUNC_GetFishPrefabName  = G_GlobalGame_FunctionsLib_FUNC_GetFishPrefabName 
local G_GlobalGame_FunctionsLib_FUNC_GetFishStyleInfo   = G_GlobalGame_FunctionsLib_FUNC_GetFishStyleInfo  
local G_GlobalGame_FunctionsLib_GetFishIDByGameObject   = G_GlobalGame_FunctionsLib_GetFishIDByGameObject  
local G_GlobalGame_FunctionsLib_FUNC_GetEulerAngle      = G_GlobalGame_FunctionsLib_FUNC_GetEulerAngle 
local G_GlobalGame_FunctionsLib_CreateFishName          = G_GlobalGame_FunctionsLib_CreateFishName



local CEventObject=GameRequire("EventObject");

--local _CEffect = class("_CEffect",CEventObject);
local _CEffect = class(nil,CEventObject);

function _CEffect.Create(...)
    local effect = _CEffect.New();
    effect:_init(...);
    return effect;
end

function _CEffect:ctor()
    _CEffect.super.ctor(self);
    self._type = nil;
end

function _CEffect:_init(_type,...)
    self.gameObject = G_GlobalGame_goFactory:createEffect(_type,...);
    self.transform  = self.gameObject.transform;
    self._type = _type;
    --self.gameObject.name = "Effect " .. _type;
    self.particleComponent = self.transform:GetComponent(ParticleSystemClassType);
end

function _CEffect:Play()
    local particleTime = self.particleComponent.main.duration;
    self.particleComponent:Play();
    coroutine.start(
        function()
            coroutine.wait(particleTime);
            if G_GlobalGame.isQuitGame then
                return;
            end
            self:onAnimaOver();
        end
    );
end

--设置位置
function _CEffect:Init(pos)
    local position = self.transform.position;
    local pos = G_GlobalGame:SwitchWorldPosToWorldPosBy3DCamera(pos,position.z);
    self.transform.position = pos;
end


--消失
function _CEffect:onAnimaOver()
    self:SendEvent(G_GlobalGame_EventID.EffectDisappear);
end

--每帧调用
function _CEffect:Update(_dt)

end

--消失
function _CEffect:Disappear()
    self:onAnimaOver();
end

function _CEffect:Type()
    return self._type;
end

--local _CBeatEffect = class("_CBeatEffect",_CEffect);
local _CBeatEffect = class(nil,_CEffect);

function _CBeatEffect:ctor()
    _CBeatEffect.super.ctor(self);
end

function _CBeatEffect.Create(...)
    local effect = _CBeatEffect.New();
    effect:_init(...);
    return effect;
end

function _CBeatEffect:_init(_type,_isOwner,...)
    _CBeatEffect.super._init(self,_type,_isOwner,...);
    self.isOwner = _isOwner;
end

--是否是玩家自己的
function _CBeatEffect:IsOwner()
    return self.isOwner;
end


--local _CLineEffect = class("_CLineEffect",_CEffect)
local _CLineEffect = class(nil,_CEffect)
local C_Common_LineEffect_Speed = VECTOR3NEW(5,0,0);
function _CLineEffect.Create(_type)
    local effect = _CLineEffect.New();
    effect:_init(_type);
    return effect;
end

function _CLineEffect:ctor()
    _CLineEffect.super.ctor(self);
    self._speedVec = C_Common_LineEffect_Speed;
    self._speed = nil; --移动速度
    self._curMaxLen = 0;
    self._curLocalPosition = 0;
    self._localBeginPosition = {x=nil,y=nil,z=nil};
    self._localEndPosition   = {x=nil,y=nil,z=nil};
    self._curLocalPosition = {x = nil,
        y = nil ,z = nil,};
    self.normalScale = {x=nil,y=nil,z=nil};
end

function _CLineEffect:_init(_type)
    _CLineEffect.super._init(self,_type);
    --self.image = self.transform:GetComponent(UnityEngine.UI.Image.GetClassType());
    --总长度
    self.maxWidth = 4.02;
end

function _CLineEffect:Init(bossPosition,smallPosition)
    local transform = self.transform;
    --终点启动，确定
    transform.position = smallPosition;
    --self._localEndPosition = transform.localPosition;
    local lp = transform.localPosition;
    local lep = self._localEndPosition;
    lep.x = lp.x;
    lep.y = lp.y;
    lep.z = lp.z;
    transform.position = bossPosition;
    lp = transform.localPosition;
    local x,y,z = lp.x,
        lp.y,
        lp.z ;
    local lbp = self._localBeginPosition;
    lbp.x = x;
    lbp.y = y;
    lbp.z = z;
    self._curMaxLen = VECTOR3DIS(lbp,lep);
    --self.image.fillAmount = 0;
    local clp = self._curLocalPosition; 
    clp.x = x;
    clp.y = y;
    clp.z = z;
    self._isMove = true;
    self._runTime = 0;
    local r = G_GlobalGame_FunctionsLib_FUNC_GetEulerAngle(bossPosition,smallPosition);
    r = r - 90;
    local v3 = V_Vector3_Value;
    v3.x = 0;
    v3.y = 0;
    v3.z = r;
    self.transform.eulerAngles = v3;
    self._speed   = self._speedVec*transform.localRotation;
    local Scale = transform.localScale;
    local nscale = self.normalScale;
    nscale.x = 0;
    nscale.y=Scale.y;
    nscale.z=Scale.z;
    transform.localScale = nscale;
end

function _CLineEffect:Play()
--    self._anima:StopAndRevert();
--    self._anima:PlayAlways();
end

function _CLineEffect:Update(_dt)
    ----[[
    if self._isMove then
        self:Move(_dt);
    end
    --]]
    self._runTime = self._runTime + _dt;
--    if self._runTime >G_GlobalGame.GameConfig.SceneConfig.iLineDisplayTime then
--        self:SendEvent(G_GlobalGame.Enum_EventID.EffectDisappear);
--    end
end

--移动
function _CLineEffect:Move(_dt)
    local curPos = self._curLocalPosition;
    local speed = self._speed;
    curPos.x  = curPos.x + speed.x *_dt;
    curPos.y  = curPos.y + speed.y *_dt;
    curPos.z  = curPos.z + speed.z *_dt;
    local curLen = VECTOR3DIS(self._localBeginPosition,curPos);
    if curLen>=self._curMaxLen then
        self.normalScale.x = MATH_SQRT(self._curMaxLen/self.maxWidth);
        self.transform.localScale = self.normalScale;
        self._isMove = false;
    else
        self.normalScale.x = MATH_SQRT(curLen/self.maxWidth);
        self.transform.localScale = self.normalScale;
    end
end


--local _CLineSourceEffect = class("_CLineSourceEffect",_CEffect);
local _CLineSourceEffect = class(nil,_CEffect);

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
    if self._runTime >G_GlobalGame_GameConfig_SceneConfig.iLineDisplayTime then
        self:SendEvent(G_GlobalGame_EventID.EffectDisappear);
    end
end

function _CLineSourceEffect:Play()
    self._anima:StopAndRevert();
    self._anima:PlayAlways();
    self._runTime = 0;
end

--local _CPauseScreenEffect = class("_CLineSourceEffect",_CEffect);
local _CPauseScreenEffect = class(nil,_CEffect);

function _CPauseScreenEffect.Create(_type)
    local effect = _CPauseScreenEffect.New();
    effect:_init(_type);
    return effect;
end

local C_PauseBeginPos = {x=0.2,y=2.11,z=7.05};
function _CPauseScreenEffect:ctor()
    _CPauseScreenEffect.super.ctor(self); 
    
end

function _CPauseScreenEffect:_init(_type)
    _CPauseScreenEffect.super._init(self,_type);

end

function _CPauseScreenEffect:Init()
    self._runTime = 0;
    self.transform.localPosition = C_PauseBeginPos;
end

function _CPauseScreenEffect:Play()
    self.particleComponent:Play();
end

function _CPauseScreenEffect:Update(_dt)
    self._runTime = self._runTime + _dt;

    if self._runTime >G_GlobalGame_GameConfig_SceneConfig.pauseScreenTime then
        --定时时间
        --self:SendEvent(G_GlobalGame.Enum_EventID.EffectDisappear);
    end
end


--local _CEffectControl=class("_CEffectControl");
local _CEffectControl=class(nil);

function _CEffectControl:ctor(_sceneControl)
    self._sceneControl = _sceneControl;
    self._cacheEffectMap = {
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                    };
    self._layerEffect    = {
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                };
    self._runMap        = {
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                    nil,nil,nil,nil,nil,nil,
                };

    --注册事件
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.NotifyCreateEffect,self,self.OnCreateEffect);
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.NotifyCreateBeatEffect,self,self.OnCreateBeatEffect);
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.NotifyCreateLine,self,self.OnCreateLineEffect);
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.NotifyCreateLineSour,self,self.OnCreateLineSourceEffect);
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.NotifyCreatePauseScrn,self,self.OnCreatePauseScreenEffect);
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.NotifyClearEffectType,self,self.OnClearEffectByType);
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.NotifyClearAllEffects,self,self.OnClearAllEffect);
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.NotifyAddEffect,self,self.OnAddEffect);
end

--初始化
function _CEffectControl:Init(transform)
    self.transform = transform;
    self.gameObject= transform.gameObject;
    --[[
    local EffectType = G_GlobalGame.Enum_EffectType;
    for i=EffectType.FishDead, EffectType.Max-1 do
        self:_getEffectLayer(i);
    end
    --]]
end

--创建特效
function _CEffectControl:OnCreateEffect(_eventId,_eventData)
    local _type = _eventData.type;
    local _pos  = _eventData.position;
    local effect;
    local vec = self._cacheEffectMap[_type];
    if vec ==nil then
        self._cacheEffectMap[_type] = {};
        --重新创建加载
        effect = _CEffect.Create(_type);
    elseif #vec<1 then
        effect = _CEffect.Create(_type);
    else
        effect = table.remove(vec);
    end
    effect:SetParent(self.transform);
    effect:Init(_pos);
    effect:RegEvent(self,self.OnEventEffect);
    effect:Play();
    --插入
    self._runMap[effect:LID()] = effect;
    return effect;
end

--创建子弹打击效果
function _CEffectControl:OnCreateBeatEffect(_eventId,_eventData)
    local _type = _eventData.type;
    local _pos  = _eventData.position;
    local _isOwner = _eventData.isOwner;
    local effect;
    local vec = self._cacheEffectMap[_type];
    if vec ==nil then
        self._cacheEffectMap[_type] = {};
        --重新创建加载
        effect = _CBeatEffect.Create(_type,_isOwner);
    elseif #vec<1 then
        effect = _CBeatEffect.Create(_type,_isOwner);
    else
        local count = #vec;
        for i=1,count  do
            if vec[i]:IsOwner() == _isOwner then
                effect = table.remove(vec,i);
                break;
            end
        end
        if effect then
        else
            --重新创建加载
            effect = _CBeatEffect.Create(_type,_isOwner);
        end
    end
    effect:SetParent(self.transform);
    effect:SetPosition(_pos);
    effect:RegEvent(self,self.OnEventEffect);
    effect:Play();
    --插入
    self._runMap[effect:LID()] = effect;
    return effect;
end

function _CEffectControl:OnCreateLineEffect(_eventId,_eventData)
    local bossPosition = _eventData.sourcePos;
    local smallPosition= _eventData.endPos;
    local effectVec = _eventData.vec;
    local _type = _eventData.type;
    local effect;
    local vec = self._cacheEffectMap[_type];
    if vec ==nil then
        self._cacheEffectMap[_type] = {};
        --重新创建加载
        effect = _CLineEffect.Create(_type);
    elseif #vec<1 then
        effect = _CLineEffect.Create(_type);
    else
        effect = table.remove(vec);
    end
    effect:SetParent(self.transform);
    effect:Init(bossPosition,smallPosition);
    effect:RegEvent(self,self.OnEventEffect);
    effect:Play();

    effectVec[#effectVec+1] = effect;
    --插入
    self._runMap[effect:LID()]=effect;
    return effect;
end

function _CEffectControl:OnCreateLineSourceEffect(_eventId,_eventData)
    local _pos = _eventData.position;
    local _type = _eventData.type;
    local effect;
    local vec = self._cacheEffectMap[_type];
    if vec ==nil then
        self._cacheEffectMap[_type] = {};
        --重新创建加载
        effect = _CLineSourceEffect.Create(_type);
    elseif #vec<1 then
        effect = _CLineSourceEffect.Create(_type);
    else
        effect = table.remove(vec);
    end
    effect:SetParent(self.transform);
    effect:SetPosition(_pos);
    effect:RegEvent(self,self.OnEventEffect);
    effect:Play();
    --插入
    self._runMap[effect:LID()]=effect;
    return effect;
end

--定屏效果
function _CEffectControl:OnCreatePauseScreenEffect(_eventId,_eventData)
    local _pos = _eventData.position;
    local _type = _eventData.type;
    --其他的定屏效果要消失
    local effectMap = self._runMap;
    for id,v in pairs(effectMap) do
        if v:Type() == _type then
            return;
        end
    end
    local vec = self._cacheEffectMap[_type];
    if vec ==nil then
        self._cacheEffectMap[_type] = {};
        --重新创建加载
        effect = _CPauseScreenEffect.Create(_type);
    elseif #vec<1 then
        effect = _CPauseScreenEffect.Create(_type);
    else
        effect = table.remove(vec);
    end
    effect:SetParent(self.transform);
    --effect:SetLocalPosition(_pos);
    effect:RegEvent(self,self.OnEventEffect);
    effect:Init();
    effect:Play();
    --插入
    self._runMap[effect:LID()] = effect;
    return effect;
end

function _CEffectControl:OnClearEffectByType(_eventId,_eventData)
    local _type = _eventData.type;
    --其他的定屏效果要消失
    local effectMap = self._runMap;
    local vec;
    for id,v in pairs(effectMap) do
        if v:Type() == _type then
            v:Cache(); 
            vec = self._cacheEffectMap[_type];
            if vec== nil then
                vec = {};
                self._cacheEffectMap[_type] = vec;
            end
            vec[#vec+1] = v;
        end
    end
end

--创建效果层
function _CEffectControl:_getEffectLayer(_type)
    if not self._layerEffect[_type] then
        local obj = GAMEOBJECT_NEW();
        local transform = obj.transform;
        transform:SetParent(self.transform);
        transform.localScale = C_Vector3_One;
        transform.localPosition = C_Vector3_Zero;
        transform.localEulerAngles = C_Vector3_Zero;
        self._layerEffect[_type] = transform;
    end
    return self._layerEffect[_type];
end

--事件
function _CEffectControl:OnEventEffect(_eventId,_eventObj)
    if _eventId==G_GlobalGame_EventID.EffectDisappear then
        self:Remove(_eventObj);
    else
        
    end
end

function _CEffectControl:Remove(effect)
    self._runMap[effect:LID()] = nil;
    effect:Cache(); 
    local vec = self._cacheEffectMap[effect:Type()];
    if vec== nil then
        vec = {};
        self._cacheEffectMap[effect:Type()] = vec;
    end
    vec[#vec+1] = effect;
end

function _CEffectControl:OnClearAllEffect(_eventId,_eventObj)
    self:ClearAllEffects();
end

function _CEffectControl:OnAddEffect(_eventId,_eventObj)
    local transform = _eventObj.transform;
    local localPosition = transform.localPosition;
    local localScale    = transform.localScale;
    local localRotation = transform.localRotation;
    transform:SetParent(self.transform);
    transform.localPosition = localPosition;
    transform.localScale    = localScale;
    transform.localRotation = localRotation;
end

function _CEffectControl:ClearAllEffects()
    local effectMap = self._runMap;
    local vec;
    for id,v in pairs(effectMap) do
        v:Cache(); 
        vec = self._cacheEffectMap[_type];
        if vec== nil then
            vec = {};
            self._cacheEffectMap[_type] = vec;
        end
        vec[#vec+1] = v;
    end
    self._runMap = {};
end

--每帧执行
function _CEffectControl:Update(_dt)
    local effectMap = self._runMap;
    local vec;
    for id,v in pairs(effectMap) do
        v:Update(_dt);
    end
end

return _CEffectControl;