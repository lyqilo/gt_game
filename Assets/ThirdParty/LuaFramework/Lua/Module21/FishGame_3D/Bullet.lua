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


--local _CBulletCollider = class("_CBulletCollider",CEventObject);
local _CBulletCollider = class(nil,CEventObject);
FishGame3D2_CBulletCollider = _CBulletCollider;
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
    self.gameObject = G_GlobalGame_goFactory:createBulletCollider(_type,_isOwner);
    self.transform  = self.gameObject.transform;
    self.baseBehaviour = UTIL_ADDCOMPONENT("BaseBehaviour",self.gameObject);
    self.baseBehaviour:SetLuaTab(self,"FishGame3D2_CBulletCollider");
    self.isOwner = _isOwner;
    self.type    = _type;
end

function _CBulletCollider:OnTriggerEnter(coll)
    return self._bullet:OnTriggerEnter(coll);
end


--local _CBullet= class("_CBullet",CEventObject)
local _CBullet= class(nil,CEventObject)

--FishGame3D2_CBullet = _CBullet;
local C_BulletNormalScale = VECTOR3ONE;
local INVALID_FISH_ID = G_GlobalGame_ConstDefine.C_S_INVALID_FISH_ID;
local INVALID_BULLET_ID = G_GlobalGame_ConstDefine.C_S_INVALID_BULLET_ID;
local COMMON_BulletSpeed = {};
--����������
function _CBullet.CreateOther(_type)
    local obj = _CBullet.New();
    obj:_init(_type,false);
    return obj;
end

--�����Լ���
function _CBullet.CreateSelf(_type)
    local obj = _CBullet.New();
    obj:_init(_type,true);
    return obj;
end

function _CBullet:ctor()
    _CBullet.super.ctor(self);
    self.isDealWith = false; --�Ѿ��������
    self.lockFishId = INVALID_FISH_ID;
    self.lockFish   = nil;
    self.isMyAndroid= false; --�Ƿ��������йܵ�
    self.bulletId   = INVALID_BULLET_ID;
    self.type       = nil;
    self.isOwner    = false;
    self.multiple   = 0;
    self.chairId    = 0;
    self.bulletKind = 0;
    self.runTime    = 0;
    self.bulletCollider = nil;
end

function _CBullet:_init(_type,isOwner)
    local obj = G_GlobalGame_goFactory:createBullet(_type,isOwner);
    self.transform  = obj.transform;
    self.gameObject = obj;
    self.type       = _type;
    self.bulletKind = _type;
    self.isOwner    = isOwner;
    if not COMMON_BulletSpeed[_type] then
        COMMON_BulletSpeed[_type]   = VECTOR3NEW(0,G_GlobalGame_GameConfig_Bullet[_type].iSpeed,0);
    end
    self.speedVec = COMMON_BulletSpeed[_type];
    self.multiple   = G_GlobalGame_GameConfig_Bullet[_type].multiple; --����
    self.body       = self.transform:Find("Body");
    self.animator   = self.body:GetComponent(ImageAnimaClassType);
    self.bulletCollider = _CBulletCollider.Create(self,_type,isOwner);
    self.localPosition = {x=0,y=0,z=0};
    self.localEuler = {x=0,y=0,z=0};
    self.position   = {x=0,y=0,z=0};
end

function _CBullet:Start()
    
end

function _CBullet:Init(_chairId,_startPoint,_euler,_bulletId,_isMyAndroid,_bulletKind)
    local position = self.position;
    position.x = _startPoint.x;
    position.y = _startPoint.y;
    position.z = _startPoint.z;
    self.transform.position = _startPoint;
    local localPosition = self.transform.localPosition;
    local lposition = self.localPosition;
    lposition.x = localPosition.x;
    lposition.y = localPosition.y;
    --self.localPosition.z = localPosition.z;
    lposition.z = 0;
    self.transform.localPosition = lposition;
    self:_calSpeed(_euler);
    self.isDealWith = false;
    self.chairId = _chairId;
    self.transform.localScale = C_BulletNormalScale;
    self.bulletId = _bulletId or INVALID_BULLET_ID;
    self.isMyAndroid = _isMyAndroid or false;
    self.bulletKind = _bulletKind or self.type;
    self.animator:PlayAlways();
    self.runTime    = 0;
    --���ó�ʼλ��
    self.bulletCollider:SetLocalPosition(C_Vector3_Zero);
    self:CorrentBoxCollider();

    --�����ײ����Ļ��Ե
    self._checkHitScreenBorderIndex=0;
end

--
function _CBullet:BoxCollider()
    return self.bulletCollider;
end

--�Ƿ������й�
function _CBullet:SetMyAndroid(isMyAndroid)
    self.isMyAndroid = isMyAndroid or false;
end

--�����ӵ�ID
function _CBullet:SetBulletId(_bulletId)
    self.bulletId = _bulletId;
end

function _CBullet:_calSpeed(_euler)
    self.localEuler.z = _euler;
    self.transform.eulerAngles = self.localEuler;
    self.angle   = _euler;
    self.speed   = self.speedVec*self.transform.localRotation;
end

function _CBullet:UpdateEx(_dt,realX,realY,realX2,realY2,x1,x2,_isMove,_isSwitchScene)
    local transform = self.transform;
    self.runTime = self.runTime + _dt;
    if self.runTime>G_GlobalGame_GameConfig_SceneConfig.iBulletLiveTime then
        --��ʱ�ˣ�������
        self:Unlock();
    end
    if _isSwitchScene then
        local position  = G_GlobalGame:SwitchWorldPosToScreenPosBy3DCamera(transform.position);
        if position.x> x2 then
            --������Ļ�ˣ�ֱ����ʧ
            self:Unlock();
            self:Delete();
            return ;
        end
    end

    if _isMove then
        self._checkHitScreenBorderIndex = self._checkHitScreenBorderIndex + 1;
        --��������
        local lposition = self.localPosition;
        local speed = self.speed; 
        lposition.x = lposition.x + speed.x;
        lposition.y = lposition.y + speed.y;
        lposition.z = lposition.z + speed.z;
     	--self.localPosition = self.localPosition + self.speed;
        transform.localPosition  = lposition;
        if self._checkHitScreenBorderIndex%3==0 then
            self:_calAngle(realX,realY,realX2,realY2);
        end
        
        --������ײ���ĽǶ�
        self:CorrentBoxCollider();
    else      
    end

end


function _CBullet:_calAngle(x,y,x2,y2)
    local tranform = self.transform;
    local selfPos = tranform.position;
    local pos = G_GlobalGame:SwitchWorldPosToScreenPosBy3DCamera(selfPos);
    local isChangeSpeed = false;
    pos.z = selfPos.z;
    if G_GlobalGame.ConstantValue.IsLandscape then --����
        if pos.x<x then
            self.angle =  - self.angle;
            pos.x = 2*x-pos.x;
            isChangeSpeed = true;
        elseif pos.x>x2 then
            self.angle =  -self.angle;
            pos.x = 2*x2-pos.x;
            isChangeSpeed = true;
        end
        if pos.y<y then
            self.angle = 180 - self.angle;
            pos.y = 2*y-pos.y;
            isChangeSpeed = true;
        elseif pos.y>y2 then
            self.angle = 180 - self.angle;
            pos.y = 2*y2-pos.y;
            isChangeSpeed = true;
        end
    elseif G_GlobalGame.ConstantValue.IsPortrait then --����
        if pos.x<x then
            self.angle =  180 -self.angle;
            pos.x = 2*x-pos.x;
            isChangeSpeed = true;
        elseif pos.x>x2 then
            self.angle =  180 -self.angle;
            pos.x = 2*x2-pos.x;
            isChangeSpeed = true;
        end
        if pos.y<y then
            self.angle = - self.angle;
            self:_calSpeed(self.angle);
            pos.y = 2*y-pos.y;
            isChangeSpeed = true;
        elseif pos.y>y2 then
            self.angle = - self.angle;
            pos.y = 2*y2-pos.y;
            isChangeSpeed = true;
        end
    end

    if isChangeSpeed then
        --�ı����ٶ�
        self:_calSpeed(self.angle);
        tranform.position = G_GlobalGame:SwitchScreenPosToWorldPosBy3DCamera(pos);
        local localPosition = tranform.localPosition;
        self.localPosition.x = localPosition.x;
        self.localPosition.y = localPosition.y;
    end
    return pos;
end

local C_Fish_Tag = "fish";

function _CBullet:OnTriggerEnter(coll)
	
    if G_GlobalGame.isQuitGame then
        return ;
    end
    local go = coll.gameObject;
    if go:CompareTag(C_Fish_Tag) then

        ---��
        if(self.isDealWith) then

            return ;
        end

        local fishId = G_GlobalGame_FunctionsLib_GetFishIDByGameObject(go);
					--logError("------------------"..fishId)
        --local fishId = tonumber(go.name);
        local fish = G_GlobalGame:GetKeyValue(G_GlobalGame_KeyValue.GetFishById,fishId);
			
        if fish==nil then

            return ;
        end
        if fish:IsDie() then 
            return ;
        end


        self:Effect(fish);
    end
end

--������ײ���ĽǶ�
function _CBullet:CorrentBoxCollider()
    local oriPos = self.bulletCollider:Position();
    oriPos = G_GlobalGame:SwitchWorldPosToWorldPosBy3DCamera(self.transform.position,oriPos.z);
    self.bulletCollider:SetPosition(oriPos);
    local aimPos = G_GlobalGame:SwitchWorldPosToWorldPosBy3DCamera(oriPos,25);
    local v3 = V_Vector3_Value;
    v3.x = aimPos.x - oriPos.x;
    v3.y = aimPos.y - oriPos.y;
    v3.z = aimPos.z - oriPos.z;
    --local collisionDir = aimPos - oriPos;
    v3:SetNormalize();
    self.bulletCollider:SetRotation(QUATERNION_LOOKROTATION(v3));
end

--�Ƿ�����Ч��
function _CBullet:IsEffective()
    return self.bulletId ~= INVALID_BULLET_ID; 
end

--����Ч��
function _CBullet:Effect(fish)

    self.isDealWith = true;
    self:Unlock();

    self:Disappear();
    local fishId = fish:FishID();
    --֪ͨ��������

    G_GlobalGame:PlayEffect(G_GlobalGame_SoundDefine.Casting);

--[[    if not self.isOwner and not self.isMyAndroid then
        --�����Լ����е�
        return ;
    end--]]

    if fish then
        G_GlobalGame._clientSession:SendCatchFish(self.chairId,fishId,G_GlobalGame_GameConfig_FishInfo[fish._fishType].iMultiple,self.bulletKind,self.bulletId,G_GlobalGame_GameConfig_Bullet[self.type].multiple);
    end
end

function _CBullet:Delete()
    self:SendEvent(G_GlobalGame_EventID.BulletDelete);
end

function _CBullet:Disappear()
    self:SendEvent(G_GlobalGame_EventID.BulletDisappear);
end

function _CBullet:Unlock()
    self.lockFishId = INVALID_FISH_ID;
    self.lockFish   = nil;
end

--������
function _CBullet:Lock(_fish)
    if _fish==nil then
        self:Unlock();
    else
        self.lockFish   = _fish;
        self.lockFishId = _fish:FishID();
        _fish:RegEvent(self,self.OnFishEvent);
    end

end

--����
function _CBullet:Cache()
    self.bulletCollider:Cache();
    _CBullet.super.Cache(self);
end

function _CBullet:Destroy()
    self.bulletCollider:Destroy();
    _CBullet.super.Destroy(self);
end

--������
function _CBullet:OnFishEvent(_eventId,_fish)
    if (_eventId==G_GlobalGame_EventID.FishDead or _eventId == G_GlobalGame_EventID.FishLeaveScreen) then
    else
        return;
    end
    if(_fish==nil or _fish:FishID() ~= self.lockFishId) then
        return ;
    end
    self:Unlock();
end

function _CBullet:NetType()
    return G_GlobalGame_GameConfig_Bullet[self.type].netType;
end

function _CBullet:IsOwner()
    return self.isOwner;
end

return _CBullet;