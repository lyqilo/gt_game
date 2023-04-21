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

local CObject = GameRequire("Object");
local CEventObject = GameRequire("EventObject");
local CThrowPath   = GameRequire("ThrowPath");
local CThrowMove   = GameRequire("ThrowMove");

--local _CFlyGold = class("_CFlyGold",CEventObject);
local _CFlyGold = class(nil,CEventObject);
local GoldName = "Gold";

local C_GOLD_NORMAL_SCALE = VECTOR3NEW(1,1,1);
local C_EULER_ZERO =  Quaternion.Euler(0,0,0);

function _CFlyGold:ctor(_type)
    _CFlyGold.super.ctor(self);
    self._type = _type;
    if _type == G_GlobalGame_Enum_GoldType.Gold then
        self.gameObject = G_GlobalGame_goFactory:createGold();
    elseif _type == G_GlobalGame_Enum_GoldType.Silver then
        self.gameObject = G_GlobalGame_goFactory:createSilver();
    end
    self.transform  = self.gameObject.transform;
    --self.gameObject.name = GoldName;
    self.isOver     = false;
    self.imageAnima = self.gameObject:GetComponent(ImageAnimaClassType);
    self._throwPath = nil;
    self._throwMove = nil;
    self._waitTime  = 0;
    --self._runTime   = 0;
end

--初始化
function _CFlyGold:Init(_parent,_offset,_startPos,_targetPos,_time,_waitTime,_randomY)
    local localPosition ,endLocalPosition;
    self._waitTime = _waitTime;
    self.transform:SetParent(_parent);
    self.transform.position = _targetPos;
    endLocalPosition = self.transform.localPosition;
    self.transform.position = _startPos;
    localPosition = self.transform.localPosition;
    self.isOver = false;
    localPosition = VECTOR3NEW(localPosition.x + _offset.x , localPosition.y + _offset.y ,localPosition.z + _offset.z);
    self.transform.localPosition = localPosition;
    if self._type == G_GlobalGame_Enum_GoldType.Gold then
        --self.transform.localScale    = Vector3.New(0.4,0.4,0.4);
        self.transform.localScale    = C_GOLD_NORMAL_SCALE;
    elseif self._type == G_GlobalGame_Enum_GoldType.Silver then
        --self.transform.localScale    = Vector3.One();
        self.transform.localScale    = C_GOLD_NORMAL_SCALE;
    end
    --endLocalPosition.y = endLocalPosition.y + 200;
    --self.transform.localRotation = Quaternion.Euler(0,0,270);
    _randomY = _randomY or math.random(50,65);
    if endLocalPosition.y>localPosition.y then
        self._throwPath = CThrowPath.CreateWithTopY(localPosition.x,localPosition.y,endLocalPosition.x,endLocalPosition.y, endLocalPosition.y + _randomY);
    else
        self._throwPath = CThrowPath.CreateWithTopY(localPosition.x,localPosition.y,endLocalPosition.x,endLocalPosition.y, localPosition.y + _randomY);
    end
    self._throwMove = CThrowMove.New(self._throwPath,localPosition,endLocalPosition,_time);

    --正常的样子
    self.imageAnima:StopAndRevert();
    --[[
    coroutine.start(
        function ()
            coroutine.wait(0.3);
            if G_GlobalGame.isQuitGame then
                return ;
            end
            local dotw = self.transform:DOMove(_targetPos,_time,false);
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
    --]]
end

--类型
function _CFlyGold:Type()
    return self._type;
end

function _CFlyGold:PlayAlways()
    self.imageAnima.enabled = true;
    self.imageAnima:PlayAlways();
end

function _CFlyGold:Update(_dt)
    if self._waitTime>0 then
        self._waitTime = self._waitTime - _dt;
        if self._waitTime<0 then
            _dt = - self._waitTime;
            self:PlayAlways();
        else
            return ;
        end
    else

    end
    if self.isOver then
        return ;
    end
    --self._runTime =  self._runTime + _dt;
    local x,y,isFinish = self._throwMove:Step(_dt);
    --设置位置
    V_Vector3_Value.x = x;
    V_Vector3_Value.y = y;
    V_Vector3_Value.z = 0;
    self.transform.localPosition = V_Vector3_Value;
    if isFinish then
        --结束了
        self:SendEvent(G_GlobalGame_EventID.FlyGoldDisappear);
        self.isOver = true;
    end
end

----每个金币
--function _CFlyGold:Update(_dt)
--    if self._waitTime>0 then
--        self._waitTime = self._waitTime - _dt;
--        if self._waitTime<0 then
--            _dt = - self._waitTime;
--        else
--            return ;
--        end
--    else

--    end
--    if self.isOver then
--        return ;
--    end
--    --self._runTime =  self._runTime + _dt;
--    local x,y,isFinish = self._throwMove:Step(_dt);
--    --设置位置
--    self.transform.localPosition = Vector3.New(x,y,0);
--    if isFinish then
--        --结束了
--        self:SendEvent(G_GlobalGame.Enum_EventID.FlyGoldDisappear);
--        self.isOver = true;
--    end
--end

--local _CFlyGoldGroup = class("_CFlyGoldGroup",CEventObject);
local _CFlyGoldGroup = class(nil,CEventObject);

local Name = "FlyGoldGroup";
function _CFlyGoldGroup:ctor()
    _CFlyGoldGroup.super.ctor(self);
    self.gameObject = GAMEOBJECT_NEW();
    --self.gameObject.name = Name;
    self.transform  = self.gameObject.transform;
    self.golds      = {};
    self.runTime    = 0;
    self.points     = {};
    self.posGO = GAMEOBJECT_NEW();
    --self.posGO.name = "pos";
    self.posTransform = self.posGO.transform;
    self.posTransform:SetParent(self.transform);

end

function _CFlyGoldGroup:SetParent(transform)
    self.transform:SetParent(transform);
    self.transform.localRotation = C_Quaternion_Zero;
    self.transform.localScale    = C_Vector3_One;
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
    --[[
    if self.isRotation then
        self.transform.localRotation = Quaternion.Euler(0,0,180);
    else
        self.transform.localRotation = Quaternion.Euler(0,0,0);
    end
    --]]
    self.transform.localRotation = C_EULER_ZERO;
    V_Vector3_Value.x = startPosition.x;
    V_Vector3_Value.y = startPosition.y;
    V_Vector3_Value.z = 0;
    self.transform.localPosition = V_Vector3_Value;
    --[[
    --需要的时间
    self.needTime       = Vector3.Distance(endPosition,startPosition)/G_GlobalGame.GameConfig.SceneConfig.flyGoldSpeed;
    if self.needTime<1 then
        self.needTime = 1;
    end
    --]]

    --计算坐标
    self:CountPos();

    --创建金币
    self:CreateCoins();

    local localPosition = self.transform.localPosition;

    --金币的飞行状态
    self.stepDetails = {
        step    = 1,
        runTime = 0,
        beginPos = VECTOR3NEW(localPosition.x,localPosition.y,localPosition.z),
        speed = 0,
        runY  = 0,
        beginY = 0,
        localPosition = VECTOR3NEW(localPosition.x,localPosition.y,localPosition.z),
        steps = {
            {
                beginSpeed = 600,
                addSpeed   = 700,
                topY       = 100,
            },
            {
                addSpeed   = 600,
                topY       = 0,
            },
            {
                beginSpeed = 300,
                addSpeed   = 500,
                topY       = 20,
            },
            {
                addSpeed   = 300,
                topY       = 0,
            },
        },
    };

    self.step = 1;
end


function _CFlyGoldGroup:CreateCoins()
    local gold;
    local waitTime = 0.16;
    --local flyTime = 0.2;
    local flyTime = 0.4;
    self.posTransform.position = self.startPos;
    local startPosition = self.posTransform.localPosition;
    self.posTransform.position = self.endPos;
    local endPosition   = self.posTransform.localPosition;
    local distance = VECTOR3DIS(startPosition,endPosition);
    local disCount = MATH_FLOOR(distance/110);
    --local disTime  = disCount*0.037;
    local randomY = MATH_RANDOM(50,65);
    local disTime  = disCount*0.1;
    waitTime = waitTime + disTime/4;
    flyTime  = flyTime + disTime;

    for i=1,self.count do
        gold = self._goldCreator();
        --注册事件
        gold:RegEvent(self,self.OnFishGoldEvent);
        self.golds[i] = gold;
        --gold:Init(self.transform,self.points[i],self.endPos,self.needTime);
        --gold:Init(self.transform,self.points[i],self.startPos, self.endPos,flyTime,0.5 + waitTime* (i-1));
        gold:Init(self.transform,self.points[i],self.startPos, self.endPos,flyTime,1.5,randomY);
        gold:PlayAlways();
    end
end

local AngleConfig = {
    angleCount = 12,
};
AngleConfig.angleHudu = 2* math.pi/AngleConfig.angleCount; 
AngleConfig.angleMathValue = {
};
local angleValue;
for i=1,AngleConfig.angleCount do
    angleValue = {};
    AngleConfig.angleMathValue[i] = angleValue;
    angleValue.cos = math.cos(AngleConfig.angleHudu * (i-1));
    angleValue.sin = math.sin(AngleConfig.angleHudu * (i-1));
end

function _CFlyGoldGroup:CountPos()
    local maxRadius;
    if self.count<=3 then
        maxRadius = 80;
    elseif self.count<=7 then
        maxRadius = 120;
    elseif self.count<=12 then
        maxRadius = 150;
    else
        maxRadius = 180;
    end
     
    local hudu;
    local xRadius ,yRadius;
    for i=1,self.count do
        xRadius = math.random(0,maxRadius*100)/100.0;
        yRadius = math.random(0,maxRadius*100)/100.0;
        hudu = math.random(0,2*math.pi*100)/100.0;
        x=math.cos(hudu)*xRadius;
        y=math.sin(hudu)*yRadius;
        self.points[i] = VECTOR3NEW(x,y,0);
    end
end

--先自己上下抖动几次
function _CFlyGoldGroup:Update(_dt)
    local stepDetail = self.stepDetails;
    local curStep = stepDetail.steps[stepDetail.step];
    if stepDetail.step == 1 then
        stepDetail.runTime = stepDetail.runTime + _dt;
        stepDetail.runY = stepDetail.beginY + curStep.beginSpeed * stepDetail.runTime - stepDetail.runTime * stepDetail.runTime * curStep.addSpeed /2;
        if stepDetail.runY>= curStep.topY then
            --下一步
            stepDetail.runY = curStep.topY;
            stepDetail.beginY = stepDetail.runY;
            stepDetail.step = 2;
            stepDetail.runTime = 0;
            stepDetail.speed = curStep.beginSpeed - stepDetail.runTime * curStep.addSpeed;
        end
        stepDetail.localPosition.y = stepDetail.beginPos.y + stepDetail.runY;
        self.transform.localPosition = stepDetail.localPosition;
    elseif stepDetail.step == 2 then
        stepDetail.runTime = stepDetail.runTime + _dt;
        local runY = stepDetail.speed * stepDetail.runTime + stepDetail.runTime * stepDetail.runTime * curStep.addSpeed /2;
        stepDetail.runY = stepDetail.beginY - runY;
        if stepDetail.runY<=curStep.topY then
            stepDetail.beginY = curStep.topY;
            stepDetail.step = 3;
            stepDetail.runTime = 0;
            stepDetail.runY = curStep.topY;
        end
        stepDetail.localPosition.y = stepDetail.beginPos.y + stepDetail.runY;
        self.transform.localPosition = stepDetail.localPosition;
    elseif stepDetail.step == 3 then
        stepDetail.runTime = stepDetail.runTime + _dt;
        stepDetail.runY = stepDetail.beginY + curStep.beginSpeed * stepDetail.runTime - stepDetail.runTime * stepDetail.runTime * curStep.addSpeed /2;
        if stepDetail.runY>= curStep.topY then
            --下一步
            stepDetail.runY = curStep.topY;
            stepDetail.beginY = stepDetail.runY;
            stepDetail.step = 4;
            stepDetail.runTime = 0;
            --stepDetail.speed = curStep.beginSpeed * stepDetail.runTime + stepDetail.runTime * curStep.addSpeed;
            stepDetail.speed = curStep.beginSpeed - stepDetail.runTime * curStep.addSpeed;
        end
        --local  pos = stepDetail.beginPos + Vector3.New(0,stepDetail.runY,0);
        stepDetail.localPosition.y = stepDetail.beginPos.y + stepDetail.runY;
        self.transform.localPosition = stepDetail.localPosition;        
    elseif stepDetail.step == 4 then
        stepDetail.runTime = stepDetail.runTime + _dt;
        local runY = stepDetail.speed * stepDetail.runTime + stepDetail.runTime * stepDetail.runTime * curStep.addSpeed /2;
        stepDetail.runY = stepDetail.beginY - runY;
        if stepDetail.runY<=curStep.topY then
            stepDetail.beginY = stepDetail.topY;
            stepDetail.step = 5;
            stepDetail.runTime = 0;
            stepDetail.runY = curStep.topY;
--            for i=1,self.count do
--                self.golds[i]:PlayAlways();
--            end       
        end
        --local  pos = stepDetail.beginPos + Vector3.New(0,stepDetail.runY,0);
        stepDetail.localPosition.y = stepDetail.beginPos.y + stepDetail.runY;
        self.transform.localPosition = stepDetail.localPosition;        
    elseif stepDetail.step == 5 then
        for i=1,self.count do
            self.golds[i]:Update(_dt);
        end        
    end

end

function _CFlyGoldGroup:OnFishGoldEvent()
    self.iDisappearCount = self.iDisappearCount + 1;
    if self.iDisappearCount>=self.count then
        --通知自己消失
        self:SendEvent(G_GlobalGame_EventID.FlyGoldGroupDisappear);
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
--local _CFlyGoldControl=class("_CFlyGoldControl");
local _CFlyGoldControl=class();

function _CFlyGoldControl:ctor()
    self._flyGoldGroupCache = {
        nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,
        };
    self._flyGoldCache      = {
        nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,};
    self._flySilverCache    = {
        nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,};
    self._runningFlyGoldMap = {
        nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,};
    self._createFlyGoldHandler      = handler(self,self._createFlyGold);
    self._createFlySilverHandler    = handler(self,self._createFlySilver);
end

--初始化
function _CFlyGoldControl:Init(transform)
    self.transform  = transform;
    self.gameObject = transform.gameObject;
end

--飞金币
function _CFlyGoldControl:CreateFlyGold(chairId,_type,count,startPos,endPos,isRotation)
    local flyGroup;
    if #self._flyGoldGroupCache>0 then
        flyGroup = table.remove(self._flyGoldGroupCache);
    else
        flyGroup = _CFlyGoldGroup.New();
    end
    flyGroup:SetParent(self.transform);
    startPos = G_GlobalGame:SwitchWorldPosToScreenPosBy3DCamera(startPos);
    --startPos.z = endPos.z;
    startPos.z = -2;
    endPos.z = -2;
    startPos = G_GlobalGame:SwitchScreenPosToWorldPosByUICamera(startPos);
    startPos.y = startPos.y + 0.5;
    if _type == G_GlobalGame_Enum_GoldType.Gold then
        flyGroup:Init(chairId,count,startPos,endPos,isRotation,self._createFlyGoldHandler);
    elseif _type == G_GlobalGame_Enum_GoldType.Silver then
        flyGroup:Init(chairId,count,startPos,endPos,isRotation,self._createFlySilverHandler);
    end
    flyGroup:RegEvent(self,self.OnFlyGoldGroupEvent)
    self._runningFlyGoldMap[flyGroup:LID()] = flyGroup;
end

--金币
function _CFlyGoldControl:_createFlyGold()
    local flyGold;
    if #self._flyGoldCache>0 then
        flyGold = table.remove(self._flyGoldCache);
    else
        flyGold = _CFlyGold.New(G_GlobalGame_Enum_GoldType.Gold);
    end
    flyGold:RegEvent(self,self.OnFlyGoldEvent);
    return flyGold;
end

--银币
function _CFlyGoldControl:_createFlySilver()
    local flyGold;
    if #self._flySilverCache>0 then
        flyGold = table.remove(self._flySilverCache);
    else
        flyGold = _CFlyGold.New(G_GlobalGame_Enum_GoldType.Silver);
    end
    flyGold:RegEvent(self,self.OnFlyGoldEvent);
    return flyGold;
end

--飞金币
function _CFlyGoldControl:OnFlyGoldEvent(_eventId,_flyGold)
    if _eventId == G_GlobalGame_EventID.FlyGoldDisappear then
        local vec;
        if _flyGold:Type() == G_GlobalGame_Enum_GoldType.Gold then
            vec = self._flyGoldCache;
        elseif _flyGold:Type() == G_GlobalGame_Enum_GoldType.Silver then
            vec = self._flySilverCache;
        end
        if #vec>=20 then
            _flyGold:Destroy();
        else
            _flyGold:Cache();
            vec[#vec+1] = _flyGold;
        end
    end
end

--飞金币组消失
function _CFlyGoldControl:OnFlyGoldGroupEvent(_eventId,_flyGoldGroup)
    if _eventId == G_GlobalGame_EventID.FlyGoldGroupDisappear then
        self._runningFlyGoldMap[_flyGoldGroup:LID()] = nil;
        _flyGoldGroup:Destroy();
--        _flyGoldGroup:Cache();
--        self._flyGoldGroupCache[#self._flyGoldGroupCache+1] = _flyGoldGroup;
    end
end

--每帧执行
function _CFlyGoldControl:Update(_dt)
    local runMap = self._runningFlyGoldMap;
    for i,v in pairs(runMap) do
        v:Update(_dt);
    end
end


return _CFlyGoldControl;