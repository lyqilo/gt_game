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

local C_HurtColor =COLORNEW(1, 0.41, 0.41, 1);
local C_NormalColor =COLORNEW(1, 1, 1, 1);
local C_ZeroPos   = VECTOR3ZERO();

local BIT_C = G_GlobalGame_FunctionsLib.Bit;

--图集数字
local CAtlasNumber = GameRequire("AtlasNumber");
--对应 GenerateFish FishControl
local idCreator =ID_Creator(0);

local FishAction_Type=
{
    Move = idCreator(1),
    Keai = idCreator(),
    Dead = idCreator(),
    Max  = idCreator(),
};

local FishMove_Type = {
    Line            = idCreator(0),
    PowerPath       = idCreator(),
    CircleAndLine   = idCreator(),
    Bezier5         = idCreator(),
    MultipleLine    = idCreator(), --多重线
};

local CEventObject=GameRequire("EventObject");
local CObject=GameRequire("Object");

local C_STR_BaseLayerActionOver = "Base Layer.action_over";

local C_STR_ActionMoveName = "move";
local C_STR_ActionDieName = "die";
local C_STR_ActionKeaiName = "keai";
local C_STR_BaseLayer_ActionMoveName = "Base Layer.move";
local C_STR_BaseLayer_ActionDieName = "Base Layer.die";
local C_STR_BaseLayer_ActionKeaiName = "Base Layer.keai";
local C_FishName = "_CFish";
local C_FishActionName = "_CFishAction";

local C_FishAnimateBodyName = "FishAnimate";
local C_FishAnimatorName = "Animator";
local C_FishBodyName = "body";

--local _CFishAction = class(C_FishActionName,CObject);
local _CFishAction = class(nil,CObject);

function _CFishAction:ctor(_fishType,_actionOver)
    _CFishAction.super.ctor(self);
    self.bg = nil;
    self.bgImg = nil;
    self.action = nil;
    self.curAction = nil;
    self.bodyImage = nil;
    self.curColor  = nil;
    self.fishType  = _fishType;
    self.interval  = 0;
    self.playSpeed = 1;
    self.handler   = nil;
    self.actionName= String.Empte;
    self.isBeginAction = false;
    --self.actionTime = {};
    self.actionOver = _actionOver;
    self.baseLayerName = String.Empte;
end

function _CFishAction:Init(transform,interval)
    self.transform = transform;
    self.gameObject= transform.gameObject;
    self.fishAnimate = transform:Find(C_FishAnimateBodyName);
    if self.fishAnimate  then
        self.animator   = self.fishAnimate:GetComponent(C_FishAnimatorName);
        self.body       = self.fishAnimate:Find(C_FishBodyName);
        --self.Render=self.body:GetComponent("Renderer");
        --self.Render.material.shader = sha
        --self.Render.material.shader = G_GlobalGame._goFactory:getShader(G_GlobalGame.Enum_ShaderID.Custom_User_StandardFish);
    end
end

--设置播放速度
function _CFishAction:SetPlaySpeed(_speed)
    if _speed==self.playSpeed then
    else
        self.playSpeed = _speed;
        self.animator.speed = _speed;
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
    if _id == FishAction_Type.Move then
        self.actionName = C_STR_ActionMoveName;
        self.baseLayerName = C_STR_BaseLayer_ActionMoveName;
    elseif _id == FishAction_Type.Dead then
        self.actionName = C_STR_ActionDieName;
        self.baseLayerName = C_STR_BaseLayer_ActionDieName;
    elseif _id == FishAction_Type.Keai then
        self.actionName = C_STR_ActionKeaiName;
        self.baseLayerName = C_STR_BaseLayer_ActionKeaiName;
    end
    self.handler = _handler;
    self.animator:Play(self.actionName);
    self.isBeginAction = true;
end

function _CFishAction:Update(_dt)
    local actionOver = self.actionOver;
    local handler = self.handler;
    if not self.isBeginAction then
        if actionOver then
            local stateinfo = self.animator:GetCurrentAnimatorStateInfo(0);
            if stateinfo then
                if (stateinfo:IsName(C_STR_BaseLayerActionOver )) then
                    actionOver();
                elseif handler then
                    if not (stateinfo:IsName(self.baseLayerName)) then
                        handler();
                        self.handler = nil;
                    end
                end
            end
        elseif handler then
            local stateinfo = self.animator:GetCurrentAnimatorStateInfo(0);
            if stateinfo then
                if not (stateinfo:IsName(self.baseLayerName)) then
                    handler();
                    self.handler = nil;
                end
            end
        end
    else
        self.isBeginAction = false;
    end
end

function _CFishAction:Stop()
    --self.animator:Stop();
end

--公用鱼特效数据
local _Common_FishEffectData = {type=1,position = 1};
--local _CFish = class(C_FishName,CEventObject);
local _CFish = class(nil,CEventObject);


local C_WHOLE_FISH_SCALE = 0.4;
local _L_FUNC_ACT_CREATOR = _CFishAction.New;

--创建鱼
function _CFish.Create(_type,_handler,cacheTransform)
    local fish = _CFish.New(_type,cacheTransform);
    --fish:_asyncInitStyle(_type,_handler);
    fish:_initStyle(_type,_handler);
    return fish;
end

function _CFish:ctor(_type,cacheTransform)
    _CFish.super.ctor(self);
    self._fishId  = 0;
    self._fishType= _type;
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
    self.externSpeed = 1;

    self.updateTime  = 0;
    
    self.boxCollidersVec = vector:new();
    self.particleComponents = {};

    self.cacheTransform = cacheTransform;

    self.keaiOverHandler = handler(self,self._onKeaiOver);

    self.isHavePath = false;
    self.movePath ={ 
        points={{x=nil,y=nil,z=nil},{x=nil,y=nil,z=nil},{x=nil,y=nil,z=nil},{x=nil,y=nil,z=nil},{x=nil,y=nil,z=nil}} , 
        pointCount=nl,
        type =nil,
        timeLen = nil,
        speed = {x=0,y=0,z=0},
        multipleLines = {
            speeds = {
                {x=0,y=0,z=0},
                {x=0,y=0,z=0},
                {x=0,y=0,z=0},
                {x=0,y=0,z=0},
                {x=0,y=0,z=0},
                {x=0,y=0,z=0},
                {x=0,y=0,z=0},
                {x=0,y=0,z=0},
                {x=0,y=0,z=0},
            },
            step = 1,
            pointCount = nil,
            rotationTime = 0.5,
            everyTime  = nil,
            runTime    = 0,
            isToward   = false,
            isNotChange= true;
            beforeRotation = {x=nil,y=nil,z=nil},
            endRotation    = {x=nil,y=nil,z=nil},
            rotationSpeed  = {x=nil,y=nil,z=nil},
            moveTime= 0,

        },
        angleInfo = {runAngleTime=0,angleTime = 0,needAngle =0, isPlusign=false,},
    };
    self.speed = {x=nil,y=nil,z=0};
    --开始坐标
    self.beginStraightPos = {x=0,y=0,z=0};

    --鱼王死亡特殊数据
    self.beginDeadRotationPos = {x=0,y=0,z=0};
    self.endDeadRotationPos = {x=0,y=0,z=0};
    self.deadRotationMoveTime = 0.4;
    self.deadRotationDiv = 1/self.deadRotationMoveTime;
    self.deadRotationMoveSpeed = {x=0,y=0,z=0};
    self.deadRotationSpeed   = {x=0,y=1080,z=0};
    self.deadRotationRunTime  = 0;

    self.isLoadTransform = false;

    --鱼参数
--    self.fishArgs = {nil,nil,nil,nil};
--    self._ob_localPosition = {x=0,y=0,z=0};
--    self._ob_position      = {x=0,y=0,z=0};
--    self._positionBit      = 0; --代表两个都可以不用 ，1代表localPosition可用,2代表position可用
--    self._ob_localScale    = {x=0,y=0,z=0};
--    self._scaleBit         = 0;
--    self._ob_localEulerAngles = {x=0,y=0,z=0};  --1
--    self._ob_eulerAngles = {x=0,y=0,z=0};       --2 
--    self._ob_localRotation = {x=0,y=0,z=0};     --4
--    self._ob_rotation    = {x=0,y=0,z=0};       --8;
--    self._rotationBit    = 0;

    self.tempScale = {x=0,y=0,z=0};
end

function _CFish:_initStyle(_type,_handler)
    self._fishType = _type;
    self.gameObject,self.names= G_GlobalGame_goFactory:createFishNew(_type);
    self.transform = self.gameObject.transform;
    local transform = self.transform;

    self.isDie = false;

    self.localBeginRotation = transform.localRotation;
    local scale = transform.localScale;
    self.normalScale = {x = scale.x,y=scale.y,z=scale.z};
    if _type== G_GlobalGame_Enum_FishType.FISH_KIND_21 then
        --金龙不缩
    else
        local normalScale = self.normalScale;
        normalScale.x = normalScale.x*C_WHOLE_FISH_SCALE;
        normalScale.y = normalScale.y*C_WHOLE_FISH_SCALE;
        normalScale.z = normalScale.z*C_WHOLE_FISH_SCALE;
    end 
    local fishConfig = G_GlobalGame_GameConfig_FishInfo[_type];
    self.fishConfig = fishConfig;

    local boxColliderTransform = transform:Find("Body/FishAnimate/Dummy001");
    if boxColliderTransform then
        self.boxCollider = boxColliderTransform:GetComponent(BoxColliderClassType);
        self.boxGO = boxColliderTransform.gameObject;
    end

    local bonesCount = transform.childCount;
    local fishAction ;
    local bone;
    local childCount,child;
    local actInterval=fishConfig.actInterval;
    if _type== G_GlobalGame_Enum_FishType.FISH_KIND_21 then
        local overHandler = handler(self,self._onActionOver);
        for i=1,bonesCount do
            fishAction = _L_FUNC_ACT_CREATOR(_type,overHandler);
            bone = transform:GetChild(i-1);
            fishAction:Init(bone,actInterval);
            self.fishActions[i] = fishAction;
            childCount = bone.childCount;
        end
    else
        for i=1,bonesCount do
            fishAction = _L_FUNC_ACT_CREATOR(_type);
            bone = transform:GetChild(i-1);
            fishAction:Init(bone,actInterval);
            self.fishActions[i] = fishAction;
            childCount = bone.childCount;
        end
    end

    local effectCount = #self.names;
    for i=1,effectCount do
        child = transform:Find(self.names[i]);
        self.particleComponents[i] =  child:GetComponent(ParticleSystemClassType);
    end
    _handler(self);
    _handler = nil;
    self.isLoadTransform = true;
end

function _CFish:_asyncInitStyle(_type,_handler)
    self._fishType = _type;
    self._loadOverHandler = _handler;
    --异步加载
    G_GlobalGame_goFactory:CreateFishAsyncEx(_type,handler(self,self._loadTransformCB));
end

function _CFish:_loadTransformCB(_go)
    self.isLoadTransform = true;
    self.gameObject = _go;
    self.transform = _go.transform;
    local transform = self.transform;

    self.localBeginRotation = transform.localRotation;
    local scale = transform.localScale;
    self.normalScale = {x = scale.x,y=scale.y,z=scale.z};
    if _type== G_GlobalGame_Enum_FishType.FISH_KIND_21 then
        --金龙不缩
    else
        local normalScale = self.normalScale;
        normalScale.x = normalScale.x*C_WHOLE_FISH_SCALE;
        normalScale.y = normalScale.y*C_WHOLE_FISH_SCALE;
        normalScale.z = normalScale.z*C_WHOLE_FISH_SCALE;
    end 
    local fishConfig = G_GlobalGame_GameConfig_FishInfo[self._fishType];
    self.fishConfig = fishConfig;
 
    local boxColliderTransform = transform:Find("Body/FishAnimate/Dummy001");
    if boxColliderTransform then
        self.boxCollider = boxColliderTransform:GetComponent(BoxColliderClassType);
        self.boxGO = boxColliderTransform.gameObject;
    end

    local bonesCount = transform.childCount;
    local fishAction ;
    local bone;
    local childCount,child;
    local actInterval = fishConfig.actInterval;
    if _type== G_GlobalGame_Enum_FishType.FISH_KIND_21 then
        local overHandler = handler(self,self._onActionOver);
        for i=1,bonesCount do
            fishAction = _L_FUNC_ACT_CREATOR(_type,overHandler);
            bone = transform:GetChild(i-1);
            fishAction:Init(bone,actInterval);
            self.fishActions[i] = fishAction;
            childCount = bone.childCount;
        end
    else
        for i=1,bonesCount do
            fishAction = _L_FUNC_ACT_CREATOR(_type);
            bone = transform:GetChild(i-1);
            fishAction:Init(bone,actInterval);
            self.fishActions[i] = fishAction;
            childCount = bone.childCount;
        end
    end

--    local effectCount = #self.names;
--    for i=1,effectCount do
--        child = transform:Find(self.names[i]);
--        self.particleComponents[i] =  child:GetComponent(ParticleSystemClassType);
--    end
    --加载完成
    if self._loadOverHandler then
        self._loadOverHandler(self);
        self._loadOverHandler = nil;
    end
end


function _CFish:startMove()
    
end

function _CFish:SetMultiple(_multiple)
    self._multipleLabel:Display();
    self._multipleLabel:SetNumber(_multiple);
end

--
function _CFish:Init(_info)
    self._alpha = 1;
    self:_changeFishColor(C_NormalColor);
    self.isDie = false;
    self.rotation = 15;
    --设置大小和旋转
    local transform = self.transform;
    --变成默认大小
    transform.localScale = self.normalScale;
    movePath = self.movePath;

    if _info and self._fishType ~= G_GlobalGame_Enum_FishType.FISH_KIND_21 then
        transform.localRotation = C_Quaternion_Zero;
        movePath.pointCount=_info.initCount;
        local infoPoint = _info.point;
        local movePathPoint = movePath.points;
        for i=1,_info.initCount do
            --self.movePath.points[i] = VECTOR3NEW(_info.point[i].x, _info.point[i].y,_info.point[i].z);
            local mp = movePathPoint[i];
            local ip = infoPoint[i];
            mp.x = ip.x;
            mp.y = ip.y;
            mp.z = ip.z;
        end
        movePath.type = _info.traceType;
        --存活时间
        movePath.timeLen = _info.existTime;
        local movePathPoint2= movePathPoint[2];
        local movePathPoint1 =movePathPoint[1];
        local timeLen = movePath.timeLen;

        if movePath.type == FishMove_Type.Line then
            local speed = movePath.speed;
            speed.x = (movePathPoint2.x - movePathPoint1.x)/timeLen;
            speed.y = (movePathPoint2.y - movePathPoint1.y)/timeLen;
            speed.z = (movePathPoint2.z - movePathPoint1.z)/timeLen;
            --self.movePath.speed = (movePathPoint[2] - self.movePath.points[1]) /timeLen;
        elseif movePath.type == FishMove_Type.MultipleLine then
            local count = _info.initCount-1;
            local multipleLines = movePath.multipleLines;
            multipleLines.step = 1;
            multipleLines.pointCount = count;
            local everyTime = (timeLen-(multipleLines.rotationTime*count-1))/count;
            multipleLines.everyTime  = everyTime;
            multipleLines.runTime    = 0;
            multipleLines.isToward   = false;

            for i=1,_info.initCount-1 do
                local point1,point2 = movePathPoint[i+1],movePathPoint[i];
                --local speed = movePath.speed;
                local selfsPeed =  multipleLines.speeds;
                selfsPeed[i].c = (point1.x - point2.x) /everyTime;
            end
        end
        movePath.moveTime= 0;

        transform.localPosition = movePathPoint1;
        local pos = self:GetPathPoint(0.1);
        local _dirction = V_Vector3_Value;
        _dirction.x = pos.x - movePathPoint1.x;
        _dirction.y = pos.y - movePathPoint1.y;
        _dirction.z = pos.z - movePathPoint1.z;
        _dirction:SetNormalize();
        if not(_dirction:Magnitude()< 1e-6) then transform.localRotation = QUATERNION_LOOKROTATION(_dirction); end
        self.isHavePath = true;
    else
        self.transform.localPosition = C_ZeroPos;
        self.isHavePath = false;
    end

    if self._fishType == G_GlobalGame_Enum_FishType.FISH_KIND_21 then
		

        --BOSS
        if _info.args[1] <3 then
            self:_playAction(FishAction_Type.Move,false);
        else
            self:_playAction(FishAction_Type.Keai,false);
        end
    else
        self:_playAction(FishAction_Type.Move);
    end
    self.isEnterScreen = false;
    --消失了 
    self.isDisappear   = false;
    --假死
    self.isFalseDie   = false;
    --是否死亡旋转
    self.isDeadRotation = false;

    local kef = self.fishConfig.keaiEffect;
    --随机可爱时间
    if kef.isKeai then
        self.keaiTime = Util.getRandom(kef.minTime, kef.maxTime);
    else
        self.keaiTime = 9999999;
    end 
    --游动速度
    self.moveSpeed = 1;
    self.externSpeed = 1;
    --直线走
    self.straightMove = false;
    self.straightMoveTime = 0;
    self.isQuickMove = false;

    self:SetBgActive(true);
    --移动速度
    self:NormalMove();
    self.runTime = 0;

    --粒子系统
    local ps = self.particleComponents;
    local count = #ps;
    for i=1,count do
        local psi = ps[i];
        psi:Stop();
        psi:Play();
    end

    --播放声音
    self.isPlaySound = true;
    if self.boxCollider then
        self.boxCollider.enabled = true;
    end
    --飞金币数据
    self.flyData = nil; 
    --检测是否在屏幕索引
    self._checkInscreenIndex = 0;
    self._realDt = 0;
    self._runDt  = 0.05;
    _info = nil;
end

--不播放声音
function _CFish:NotPlaySound()
    self.isPlaySound = false;
end

function _CFish:SetFishFlag(_flag)
    self._fishFlag= _flag or G_GlobalGame.Enum_FISH_FLAG.Common_Fish;
end

function _CFish:SetBgActive(isVisible)
    local fas = self.fishActions;
    local fishCount = #fas;
    for i=1,fishCount do
        fas[i]:SetBgActive(isVisible);
    end
end

--是否可以执行
function _CFish:UpdateIndex()
    return self.fishConfig.updateIndex;
    --return 1;
end

-- 可能会隔断时间执行
function _CFish:Update(_dt)
	--logError("鱼的update")
    if self.isDie then
        return;
    end
    if self._fishFlag == G_GlobalGame.Enum_FISH_FLAG.Common_Fish and 
        self._fishType == G_GlobalGame_Enum_FishType.FISH_KIND_21 then
        self:_bossMove(_dt);
		 --self:_move(_dt);
    else
        self:_move(_dt);
    end
end

--每帧执行
function _CFish:UpdateEveryFrame(_dt,x1,y1,x2,y2)
    local fas = self.fishActions;
    local count=#fas;
    for i=1,count do
        fas[i]:Update(_dt);
    end
    if self.isDie then
        --检测死亡
        --self:_checkDead(_dt);
        return;
    end
    --self:_bgRotate(_dt);
    --self:_checkHurt(_dt);
    self:_checkIsInScreen(x1,y1,x2,y2);
end

--扩展update
function _CFish:UpdateEx(_dt,_isPause,x1,y1,x2,y2)
    if not self.isLoadTransform then
        return ;
    end
    if self.isDeadRotation then
        --死亡旋转
        --self.deadRotationRunTime = self.deadRotationRunTime + _dt;
        local v3 = V_Vector3_Value;
        local ds = self.deadRotationSpeed;
        v3.x = ds.x * _dt;
        v3.y = ds.y * _dt;
        v3.z = ds.y * _dt;
        --自身旋转
        self.transform:Rotate(v3);
    end
    if not _isPause then
        self:Update(_dt);
    end
    self:UpdateEveryFrame(_dt,x1,y1,x2,y2);
    return ;
end

--确定是否在屏幕内
function _CFish:_checkIsInScreen(x1,y1,x2,y2)
    self._checkInscreenIndex = self._checkInscreenIndex + 1;
    if self._checkInscreenIndex%5==0 then
        return ;
    end
    if self.isEnterScreen then
        --local x=self.transform.position.x;
        --local y = self.transform.position.y;
        local pos = G_GlobalGame:SwitchWorldPosToScreenPosBy3DCamera(self.transform.position);
        local x = pos.x;
        local y = pos.y;
--        if G_GlobalGame.ConstantValue.IsPortrait then --竖屏
--            y = pos.x;
--            x = pos.y;
--        end
        if x>x1 and x<x2 and y>y1 and y<y2 then
            
        else
            --通知离开了屏幕
            self.isEnterScreen = false;
            self:SendEvent(G_GlobalGame_EventID.BeforeFishLeaveScreen);
            self:SendEvent(G_GlobalGame_EventID.FishLeaveScreen);
        end  
    else
        --还没有进入过屏幕
        --local x=self.transform.position.x;
        --local y = self.transform.position.y;
        local pos = G_GlobalGame:SwitchWorldPosToScreenPosBy3DCamera(self.transform.position);
        local x = pos.x;
        local y = pos.y;
--        if G_GlobalGame.ConstantValue.IsPortrait then --竖屏
--            y = pos.x;
--            x = pos.y;
--        end
        if x>x1 and x<x2 and y>y1 and y<y2 then
            --通知进入了屏幕
            self.isEnterScreen = true;
            self:SendEvent(G_GlobalGame_EventID.BeforeFishEnterScreen);
            self:SendEvent(G_GlobalGame_EventID.FishEnterScreen);
        end  
    end
end

function _CFish:GetPathPoint(_dt)
    local movePath = self.movePath;
    local movePoint = movePath.points;
    
    local _fishpos=V_Vector3_Value;
    if movePath.type == FishMove_Type.Line then
        local speed = movePath.speed;
        local moveBPoint = movePoint[1];
        _fishpos.x = moveBPoint.x + speed.x*_dt;
        _fishpos.y = moveBPoint.y + speed.y*_dt;
        _fishpos.z = moveBPoint.z + speed.z*_dt;
    elseif movePath.type == FishMove_Type.Bezier5 then
        -- 正常情况下的游动
        _fishpos = BezierPathFor_5(movePoint[1], movePoint[2], movePoint[3], movePoint[4], movePoint[5], _dt);
    elseif movePath.type == FishMove_Type.MultipleLine then
        --多重线
        local multipleLines = movePath.multipleLines;
        local moveTime = _dt + multipleLines.runTime;
        local step = multipleLines.step;
        local pointCount = multipleLines.pointCount;
        local moveSP = movePoint[step];
        if step>= pointCount then
            local speed = multipleLines.speeds[pointCount-1];
            _fishpos.x = moveSP.x + speed.x * moveTime;
            _fishpos.y = moveSP.y + speed.y * moveTime;
            _fishpos.z = moveSP.z + speed.z * moveTime;
            --_fishpos = movePoint[multipleLines.step] + multipleLines.speeds[multipleLines.pointCount-1] * moveTime;
        else
            local speed = multipleLines.speeds[step];
            _fishpos.x = moveSP.x + speed.x * moveTime;
            _fishpos.y = moveSP.y + speed.y * moveTime;
            _fishpos.z = moveSP.z + speed.z * moveTime;
            --_fishpos = movePoint[multipleLines.step] + m
            --_fishpos = movePoint[multipleLines.step] + multipleLines.speeds[multipleLines.step] * moveTime;
        end 
    end
    return _fishpos;
end

function _CFish:GetNextPathPoint(_dt)
    local movePath = self.movePath;
    local movePoint = movePath.points;
    local totalMoveTime = movePath.moveTime + _dt;
    local _fishpos=V_Vector3_Value;
    if movePath.type == FishMove_Type.Line then
        local speed = movePath.speed;
        local moveBPoint = movePoint[1];
        _fishpos.x = moveBPoint.x + speed.x*totalMoveTime;
        _fishpos.y = moveBPoint.y + speed.y*totalMoveTime;
        _fishpos.z = moveBPoint.z + speed.z*totalMoveTime;
    elseif movePath.type == FishMove_Type.Bezier5 then
        -- 正常情况下的游动
        _fishpos = BezierPathFor_5(movePoint[1], movePoint[2], movePoint[3], movePoint[4], movePoint[5], totalMoveTime);
    elseif movePath.type == FishMove_Type.MultipleLine then
        --多重线
        local multipleLines = movePath.multipleLines;
        local moveTime = _dt + multipleLines.runTime;
        local step = multipleLines.step;
        local pointCount = multipleLines.pointCount;
        local moveSP = movePoint[step];
        if step>= pointCount then
            local speed = multipleLines.speeds[pointCount-1];
            _fishpos.x = moveSP.x + speed.x * moveTime;
            _fishpos.y = moveSP.y + speed.y * moveTime;
            _fishpos.z = moveSP.z + speed.z * moveTime;
            --_fishpos = movePoint[multipleLines.step] + multipleLines.speeds[multipleLines.pointCount-1] * moveTime;
        else
            local speed = multipleLines.speeds[step];
            _fishpos.x = moveSP.x + speed.x * moveTime;
            _fishpos.y = moveSP.y + speed.y * moveTime;
            _fishpos.z = moveSP.z + speed.z * moveTime;
            --_fishpos = movePoint[multipleLines.step] + m
            --_fishpos = movePoint[multipleLines.step] + multipleLines.speeds[multipleLines.step] * moveTime;
        end  
    end
    return _fishpos;
end

--boss移动
function _CFish:_bossMove(_dt,isNotScale)
--    self.existTime = self.existTime - _dt;
--    if self.existTime<=0 then
--        --boss时间到
--        self:OnBossMoveOver();
--    end
end

--boss战结束
function _CFish:_bossDisappear()
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.NotifyUIBossBattleOver); 
    self:Disappear();
end

function _CFish:_move(_dt,isNotScale)
	--logError("移动起来")
    local _dt2;
    if isNotScale then
        _dt2 = _dt;
    else
        _dt2 = _dt * self.moveSpeed * self.externSpeed;
    end
    if self.straightMove then
        local stime = self.straightMoveTime + _dt2; 
        self.straightMoveTime = stime;
        local speed = self.speed;
        local v3 =V_Vector3_Value;
        local bsPos = self.beginStraightPos;
        v3.x = bsPos.x + speed.x*stime;
        v3.y = bsPos.y + speed.y*stime;
        v3.z = bsPos.z + speed.z*stime;
        self.transform.localPosition = v3;
        return;
    end
    if not self.isHavePath then
        --没有移动数据
        return ;
    end

    local movePath = self.movePath;
    local movePoint = movePath.points;
    if _dt2>0 then
        if movePath.type == FishMove_Type.Line then
            local mt = movePath.moveTime + _dt2;
            movePath.moveTime = mt;
            local v3 = V_Vector3_Value;
            local mp = movePoint[1];
            local speed=movePath.speed;
            v3.x = mp.x + speed.x*mt;
            v3.y = mp.y + speed.y*mt;
            v3.z = mp.z + speed.z*mt;
            self.transform.localPosition = v3;
            if movePath.timeLen<=mt then
                self:Disappear();  
                self:_changeDie();
                return ;
            end
        elseif movePath.type == FishMove_Type.Bezier5 then
				--logError("进入贝塞尔曲线")
            -- 正常情况下的游动
            local mt = movePath.moveTime + _dt2;
            movePath.moveTime = mt;
            local t = mt / movePath.timeLen;
            if t > 1.1 or t == 1.1 then self:Disappear();  self:_changeDie(); return; end
            local _fishpos = BezierPathFor_5(movePoint[1], movePoint[2], movePoint[3], movePoint[4], movePoint[5], t);
            self.transform.localPosition = _fishpos;
            local _nextPos = BezierPathFor_5(movePoint[1], movePoint[2], movePoint[3], movePoint[4], movePoint[5], t + 0.1);
            --local _dirction = _nextPos - _fishpos;
            local _dirction = V_Vector3_Value;
            _dirction.x = _nextPos.x - _fishpos.x;
            _dirction.y = _nextPos.y - _fishpos.y;
            _dirction.z = _nextPos.z - _fishpos.z;
            _dirction:SetNormalize();
            if not(_dirction:Magnitude()< 1e-6) then self.transform.rotation = QUATERNION_LOOKROTATION(_dirction); end
        elseif movePath.type == FishMove_Type.MultipleLine then
            local multipleLines = movePath.multipleLines;
            local br = multipleLines.beforeRotation;
            local er = multipleLines.endRotation;
            local runT = multipleLines.runTime + _dt2;
            multipleLines.runTime = runT;
            if multipleLines.isToward then
                local rt = multipleLines.rotationTime ;
                --正在转向
                if runT>=rt then
                    local leftDt = runT - rt;
                    if not multipleLines.isNotChange then
                        self:SetLocalEulerAngles(er);
                    end
                    multipleLines.isToward = false;
                    multipleLines.runTime = 0;
                    if leftDt>0 then
                        self:_move(leftDt,true);
                    end

                else
                    if not multipleLines.isNotChange then
                        local rotation = V_Vector3_Value;
                        local rs = multipleLines.rotationSpeed;
                        rotation.x = br.x + rs.x * runT;
                        rotation.y = br.y + rs.y * runT;
                        rotation.z = br.z + rs.z * runT;
                        self:SetLocalEulerAngles(rotation);
                    end
                end           
            else
                if runT>=multipleLines.everyTime then
                    local leftDt = multipleLines.runTime - multipleLines.everyTime;
                    multipleLines.isToward = true;
                    local step = multipleLines.step + 1;
                    multipleLines.step = step;
                    if step>= multipleLines.pointCount then
                        self:Disappear();  self:_changeDie(); return; 
                    end
                    multipleLines.runTime = 0;
                    local curPos = movePoint[step];
                    self:SetLocalPosition(curPos);
                    local _nextPos = self:GetNextPathPoint(0.1);
                    local _dirction = V_Vector3_Value;
                    _dirction.x = _nextPos.x-curPos.x;
                    _dirction.y = _nextPos.y-curPos.y;
                    _dirction.z = _nextPos.z-curPos.z;
                    if not(_dirction:Magnitude()< 1e-6) then 
                        local lr = self:LocalEulerAngles();
                        local _x,_y,_z = lr.x,lr.y,lr.z;
                        br.x = _x;
                        br.y = _y;
                        br.z = _z;
                        self.transform.rotation = QUATERNION_LOOKROTATION(_dirction); 
                        lr    = self:LocalEulerAngles();
                        local ex,ey,ez = lr.x,lr.y,lr.z;
                        er.x = ex;
                        er.y = ey;
                        er.z = ez;
                        
                        local rx = ex - _x;
                        local ry = ey - _y;
                        local rz = ez - _z;
                        if rx>360 then
                            rx = rx - 360;
                        end
                        if ry>360 then
                            ry = ry - 360;
                        end
                        if rz>360 then
                            rz = rz - 360;
                        end
                        local rsp = multipleLines.rotationSpeed;
                        local rt =  multipleLines.rotationTime;
                        rsp.x = rx / rt;
                        rsp.y = ry /rt;
                        rsp.z = rz /rt;
                        self:SetLocalEulerAngles(br);
                        multipleLines.isNotChange = false;
                    else
                        --没有变化
                        multipleLines.isNotChange = true;
                    end
                    if leftDt>0 then
                        self:_move(leftDt,true);
                    end
                else
                    local nextPos = self:GetNextPathPoint(_dt2);
                    self:SetLocalPosition(nextPos);
                end 
            end
        end
    end
    if self._fishFlag == G_GlobalGame.Enum_FISH_FLAG.YC_Fish then
        --鱼潮的鱼不能播放可爱动画
    else
        if not self.isQuickMove then
            self:_keai(_dt2);
        end 
    end
end

--可爱动画
function _CFish:_keai(_dt)
    self.keaiTime = self.keaiTime - _dt;
    if self.keaiTime <=0 then 
        self:_playAction(FishAction_Type.Keai,true,self.keaiOverHandler); 
        local kef = self.fishConfig.keaiEffect;
        self.keaiTime = Util.getRandom(kef.minTime, kef.maxTime); 
        self.externSpeed = kef.speed;
    end
end

function _CFish:_onKeaiOver()
    --结束后回复正常
    self.externSpeed = 1;
end

--动作结束
function _CFish:_onActionOver()
    self:Disappear();
end

--底盘自旋转
function _CFish:_bgRotate(_dt)
    self.runRotationTime = self.runRotationTime - _dt * self.playSpeed;
    if  self.runRotationTime>0 then
        return;
    end
    local fas = self.fishActions;
    local fishCount = #fas;
    local rotation = self.rotation;
    for i=1,fishCount do
        fas[i]:_bgRotate(rotation);
    end
    self.runRotationTime = self.bgRotationTime + self.runRotationTime;
end

--死亡动画播放完
function _CFish:OnDie()
    if self.isDie then
        self:Disappear();
    end
end


--改变死亡
function _CFish:_changeDie()
    self.isDie = true;
    if self.boxCollider then
        self.boxCollider.enabled = false;
    end
end

--消失
function _CFish:Disappear()
    --通知死亡事件
    self:SendEvent(G_GlobalGame_EventID.FishDie);
    --删除事件列表
    self:ClearEvent();
end

--受伤
function _CFish:Hurt(pos,_isOwner)
    --不是变特效了
    --创建子弹打中效果
    --改成了鱼网
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
--    --改掉名字
--    local name = tostring(_fishId);
--    local it = self.boxCollidersVec:iter();
--    local val = it();
--    while(val) do
--        val.gameObject.name = name;
--        val = it();
--    end
    local name = G_GlobalGame_FunctionsLib_CreateFishName(_fishId);
    self.gameObject.name = name;
    if self.boxGO then
        self.boxGO.name = name;
    end
--    self.name = G_GlobalGame_FunctionsLib_CreateFishName(_fishId);
--    if self.gameObject then
--        self.gameObject.name = self.name;
--    end
end

--设置父节点
function _CFish:SetParent(_parent)
    _CFish.super.SetParent(self,_parent);
end

--是否死亡了
function _CFish:IsDie()
    return self.isDie;
end

--鱼死了
function _CFish:Die(isDisplayDeadEffect)
    if (isDisplayDeadEffect==nil) then
        isDisplayDeadEffect = true;
    end

    local fishConfig = self.fishConfig;
    local fishType = self._fishType;
    if fishConfig.deadEffect==nil then
    else
        if isDisplayDeadEffect then
            --特效
            local position = self:Position()
            if fishType == G_GlobalGame_Enum_FishType.FISH_KIND_24 then
                position.x = 0;
                position.y = 0;
                _Common_FishEffectData.type =fishConfig.deadEffect;
                _Common_FishEffectData.position = position;
                G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.NotifyCreateEffect,_Common_FishEffectData);   
            else
                _Common_FishEffectData.type =fishConfig.deadEffect;
                _Common_FishEffectData.position = position;
                G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.NotifyCreateEffect,_Common_FishEffectData);   
            end
        end
    end
    self:SendEvent(G_GlobalGame_EventID.FishDead);

    if fishType>=G_GlobalGame_Enum_FishType.FISH_KIND_17 and fishType<= G_GlobalGame_Enum_FishType.FISH_KIND_21 then
        --播放飞金币声音
        G_GlobalGame:PlayEffect(G_GlobalGame_SoundDefine.BigFishGold);
    end

    
    self.isHurt= false;
    self:_changeFishColor(C_HurtColor);
    --改变死亡状态
    self:_changeDie();
    if fishType == G_GlobalGame_Enum_FishType.FISH_KIND_21 then
        self.transform.localRotation = self.localBeginRotation;
        self:_playAction(FishAction_Type.Dead,true,handler(self,self._onDieActionOver));
    else
        self:_playAction(FishAction_Type.Dead,true,handler(self,self._onDieActionOver));
    end
    self.deadTime = G_GlobalGame_GameConfig_SceneConfig.iFishDeadTime;

    --self:SetLocalRotation(Quaternion.Euler(0,90,0));

    if self.isPlaySound then
        --是否播放声音
        if fishType>=G_GlobalGame_Enum_FishType.FISH_KIND_17 and fishType< G_GlobalGame_Enum_FishType.FISH_KIND_22 then

        elseif fishType>=G_GlobalGame_Enum_FishType.FISH_KIND_23 and fishType<=G_GlobalGame_Enum_FishType.FISH_KIND_24 then
            --播放炸弹声音
            if fishType==G_GlobalGame_Enum_FishType.FISH_KIND_23 then
                G_GlobalGame:PlayEffect(G_GlobalGame_SoundDefine.Bomb);
            else
                G_GlobalGame:PlayEffect(G_GlobalGame_SoundDefine.QuanPingBomb);
            end
        end
    end
end

--死亡动画播完
function _CFish:_onDieActionOver()
    if self.flyData then
        --飞金币
        G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.NotifyCreateFlyGold,self.flyData);
        --播放飞金币声音
        G_GlobalGame:PlayEffect(G_GlobalGame_SoundDefine.Coinsfly); 
    end
    self:OnDie();
    --self:Cache();
end

local _L_COM_DREuler = QUATERNION_EULER(-70,0,0); 

--死亡旋转
function _CFish:DeadRotation(_localRotation)
    local comE = _L_COM_DREuler; 
    local transform = self.transform;
    --初始角度
    transform.localRotation = _localRotation or  comE;
    self.isDeadRotation = true;
    local vet = transform.localPosition;
    local bPos = self.beginDeadRotationPos;
    bPos.x = vet.x;
    bPos.y = vet.y;
    bPos.z = vet.z;
    local position = transform.position;
    local v = V_Vector3_Value;
    v.x = 0;
    v.y = 0;
    v.z = -10;
    transform.localPosition = v;
    local position2 = transform.position;
    position2 = G_GlobalGame:SwitchWorldPosToWorldPosBy3DCamera(position,position2.z);

    self.endDeadRotationWorldPos = position2;
    transform.position = position2;
    vet = transform.localPosition;
    local dPos = self.endDeadRotationPos;
    dPos.x = vet.x;
    dPos.y = vet.y;
    dPos.z = vet.z;
    transform.localPosition = bPos;
    local speed = self.deadRotationMoveSpeed;
    local div = self.deadRotationDiv;
    speed.x = (dPos.x - bPos.x)*div;
    speed.y = (dPos.y - bPos.y)*div;
    speed.z = (dPos.z - bPos.z)*div;
    self.deadRotationRunTime  = 0;

    if self._fishType>=G_GlobalGame_Enum_FishType.FISH_KIND_31 and self._fishType<= G_GlobalGame_Enum_FishType.FISH_KIND_40 then
        --播放飞金币声音
        G_GlobalGame:PlayEffect(G_GlobalGame_SoundDefine.BigFishGold);
    end

    --播放移动
    self:_playAction(FishAction_Type.Move);

    --气泡不消失
--    if self.qipaoGameObject then
--        self.qipaoGameObject:SetActive(false);
--    end

    --改变死亡状态
    self:_changeDie();
end

--结束旋转的位置
function _CFish:DeadRotationPos()
    return self.endDeadRotationPos;
end

--结束旋转的位置
function _CFish:DeadRotationWorldPos()
    return self.endDeadRotationWorldPos;
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

--飞金币数据
function _CFish:FlyGoldData(_data)
    self.flyData = _data;
end

--播放移动动作
function _CFish:PlayMove()
    self:_playAction(FishAction_Type.Move);
end

--播放动作
function _CFish:_playAction(_id,_isAlways,_handler)
    if _isAlways==nil then
        _isAlways = true;
    end
    local fs =self.fishActions;
    local fishCount = #fs;
    for i=1,fishCount do
        if i==1 then
            fs[i]:_playAction(_id,_isAlways,_handler);
        else
            fs[i]:_playAction(_id,_isAlways);
        end
    end
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
    self._color = COLORNEW(_color.r,_color.g,_color.b,self._alpha);
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
    local transform = self.transform;
    --计算速度
    local angle = transform.localEulerAngles.z;
    local rd=math.rad(angle);
    local x,y
    local tTemp = self.fishConfig.iSpeed*multiple*G_GlobalGame_GameConfig_SceneConfig.FrameCount;
    y = MATH_SIN(rd)*tTemp;
    x = MATH_COS(rd)*tTemp; 
    local speed = self.speed;
    speed.x = x;
    speed.y = y;
    self.straightMove = true;
    local position = transform.localPosition;
    local pos = self.beginStraightPos
    pos.x = position.x;
    pos.y = position.y;
    pos.z = position.z;
    self.straightMoveTime = 0;
end

--快速移出屏幕
function _CFish:QuickMove()
    --移动速度变成3倍
    self.moveSpeed = 4.5;
    self.playSpeed = 2;
    self.isQuickMove = true;
    local fAs = self.fishActions;
    local fishCount = #fAs;
    for i=1,fishCount do
        fAs[i]:SetPlaySpeed(2);
    end
end

--正常移动
function _CFish:NormalMove()
    self.moveSpeed = 1;
    self.playSpeed = 1;
    local fAs = self.fishActions;
    local fishCount = #fAs;
    for i=1,fishCount do
        fAs[i]:SetPlaySpeed(1);
    end
end

function _CFish:SetPlaySpeed(_playSpeed)
    self.playSpeed = _playSpeed;
    local fAs = self.fishActions;
    local fishCount = #fAs;
    for i=1,fishCount do
        fAs[i]:SetPlaySpeed(_playSpeed);
    end
end

--boss移动结束
function _CFish:OnBossMoveOver()
    self.isDie = true;
--    self.transform.localRotation = self.localBeginRotation;
--    --通知boss结束
--    self:_playAction(FishAction_Type.Dead,false,handler(self,self.Disappear));
    --boss游走了
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.NotifyUIBossBattleOver);
end


--设置本地大小
--放大缩小鱼
function _CFish:SetLocalScale(scale)
    local v3 = V_Vector3_Value;
    local normalScale = self.normalScale;
    if type(scale)=="number" then
        v3.x = scale * normalScale.x;
        v3.y = scale * normalScale.y;
        v3.z = scale * normalScale.z;
    else
        v3.x = scale.x * normalScale.x;
        v3.y = scale.y * normalScale.y;
        v3.z = scale.z * normalScale.z;
    end

    self.transform.localScale = v3;
end

--function _CFish:Position()
--    if self.transform then
--        return self.transform.position;
--    end
--    return C_Vector3_Zero;
--end 

--function _CFish:LocalPosition()
--    if self.transform then
--        return self.transform.localPosition;
--    end
--    return C_Vector3_Zero;
--end

--function _CFish:SetPosition(position)
--    self.transform.position = position;
--end

--function _CFish:SetLocalPosition(localPosition)
--    self.transform.localPosition = localPosition;
--end

--function _CFish:Scale()
--    return self.transform.scale;
--end

--function _CFish:LocalScale()
--    if self._scaleBit==1 then
--        return self._ob_localScale;
--    end
--    if not self.transform then
--        return C_Vector3_One;
--    end
--    local scale = self.transform.localScale;
--    local v3 = self._ob_localScale;
--    v3.x = scale.x;
--    v3.y = scale.y;
--    v3.z = scale.z;
--    self._scaleBit = 1;
--    return v3;
--end

----设置本地大小
----放大缩小鱼
--function _CFish:SetLocalScale(scale)
--    local v3 = self._ob_localScale;
--    if type(scale)=="number" then
--        v3.x = scale;
--        v3.y = scale;
--        v3.z = scale;
--    else
--        v3.x = scale.x;
--        v3.y = scale.y;
--        v3.z = scale.z;
--    end
--    self._scaleBit = 1;
--    if self.transform then
--        local normalScale = self.normalScale;
--        local v2 = V_Vector3_Value;
--        v2.x = v3.x * normalScale.x;
--        v2.y = v3.y * normalScale.y;
--        v2.z = v3.z * normalScale.z;
--        self.transform.localScale = v2;
--    end
--end
----
--function _CFish:SetScale(scale)
--    self.transform.scale = scale;
--end
----
--function _CFish:LocalRotation()
--    if BIT_C:_and(self._rotationBit,4)==4 then
--        return self._ob_localRotation;
--    else   
--        self._ob_localRotation = self.transform.localRotation;
--        return self._ob_localRotation;
--    end
--end

----
--function _CFish:Rotation()
--    if BIT_C:_and(self._rotationBit,8)==8 then
--        return self._ob_rotation;
--    else   
--        self._ob_rotation = self.transform.rotation;
--        return self._ob_rotation;
--    end
--end

--function _CFish:SetLocalRotation(localRotation)
----    if bit:_and(self._rotationBit,1)==1 then
----        return self._ob_localRotation;
----    end
--    self._rotationBit = 4;
--    self._ob_localRotation = localRotation;
--    if self.transform then
--        self.transform.localRotation = localRotation;
--    end
--end

--function _CFish:SetRotation(rotation)
--    self._rotationBit = 8;
--    self._ob_rotation = rotation;
--    if self.transform then
--        self.transform.rotation = rotation;
--    end
--end

--function _CFish:EulerAngles()
--    if BIT_C:_and(self._rotationBit,2)==2 then
--        return self._ob_eulerAngles;
--    else    
--        if self.transform then
--            local eulerAngles = self.transform.eulerAngles;
--            local leuler = self._ob_eulerAngles;
--            leuler.x = eulerAngles.x;
--            leuler.y = eulerAngles.y;
--            leuler.z = eulerAngles.z;
--            self._rotationBit = BIT_C:_or(self._rotationBit,2);
--            return self._ob_eulerAngles; 
--        end
--    end
--end

--function _CFish:LocalEulerAngles()
--    if BIT_C:_and(self._rotationBit,1)==1 then
--        return self._ob_localEulerAngles;
--    else    
--        local eulerAngles = self.transform.localEulerAngles;
--        local leuler = self._ob_localEulerAngles;
--        leuler.x = eulerAngles.x;
--        leuler.y = eulerAngles.y;
--        leuler.z = eulerAngles.z;
--        self._rotationBit = BIT_C:_or(self._rotationBit,1);
--        return self._ob_localEulerAngles;
--    end
--    return self.transform.localEulerAngles;
--end

--function _CFish:SetEulerAngles(eulerAngles)
--    local leuler = self._ob_eulerAngles;
--    leuler.x = eulerAngles.x;
--    leuler.y = eulerAngles.y;
--    leuler.z = eulerAngles.z;
--    self._rotationBit = 2;
--    self.transform.eulerAngles = eulerAngles;
--end

--function _CFish:SetLocalEulerAngles(localEulerAngles)
--    self._rotationBit = 1;
--    local leuler = self._ob_localEulerAngles;
--    leuler.x = localEulerAngles.x;
--    leuler.y = localEulerAngles.y;
--    leuler.z = localEulerAngles.z;
--    self.transform.localEulerAngles = localEulerAngles;
--end
function _CFish:Cache()
    self.transform:SetParent(self.cacheTransform);  
    V_Vector3_Value.x=15000;
    V_Vector3_Value.y=15000;
    V_Vector3_Value.z=0;
    self.transform.localPosition = V_Vector3_Value; 
    --_CFish.super.Cache(self);
    --清理事件 
    self:ClearEvent();
end

return _CFish;