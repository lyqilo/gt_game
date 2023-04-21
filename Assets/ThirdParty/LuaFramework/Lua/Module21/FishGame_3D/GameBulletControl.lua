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



local CBullet = GameRequire("Bullet");

local CNetControl = GameRequire("GameNetControl");

--local _CGameBulletControl = class("_CGameBulletControl");
local _CGameBulletControl = class();

function _CGameBulletControl:ctor(_sceneControl)
    self._bulletMap = {
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                };
    self._cacheOtherBulletPool = {
                nil,nil,nil,nil,nil,nil,nil,
                };
    self._cacheSelfBulletPool = {
                nil,nil,nil,nil,nil,nil,nil,nil,};
    local EnumBulletType = G_GlobalGame.Enum_BulletType;
    for i=EnumBulletType.BULLET_KIND_1_NORMAL,EnumBulletType.BULLET_KIND_COUNT-1 do
        self._cacheOtherBulletPool[i]  = {
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                };
        self._cacheSelfBulletPool[i]   = {
                        nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                };
    end
    --子弹个数
    self._bulletCount = {nil,nil,nil,nil,nil,nil};
    for i=0,4 do
        self._bulletCount[i] = 0;
    end

    self._gameNetControl        = CNetControl.New();
    self._sceneControl          = _sceneControl;
    self._isMove                = true;
    self._positionZ             = 0;
    self.bulletColliderTransform= nil;
end

function _CGameBulletControl:Init(transform,bulletColliderTransform,netTransform)
    self.transform  = transform;
    self.gameObject = transform.gameObject;
    self._positionZ = transform.position.z;
    self.bulletColliderTransform = bulletColliderTransform;
    self._gameNetControl:Init(netTransform);
    self.bulletColliderTransform = bulletColliderTransform;
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
    _startPos = G_GlobalGame:SwitchScreenPosToWorldPosBy3DCamera(_startPos,self._positionZ);
    local bullet;
    if _isOwn then
        local vec = self._cacheSelfBulletPool[_type];
        if #vec<1 then
            bullet = CBullet.CreateSelf(_type);
        else
            bullet = table.remove(vec);
        end
    else
        local vec = self._cacheOtherBulletPool[_type];
        if #vec<1 then
            bullet = CBullet.CreateOther(_type);
        else
            bullet = table.remove(vec);
        end
    end
    bullet:RegEvent(self,self.OnEventBullet);
    self._bulletMap[bullet.lid] = bullet;
    --加入节点
    bullet:SetParent(self.transform);
    --bullet.transform.localScale = C_Vector3_One;
    self._bulletCount[_chairId] = self._bulletCount[_chairId] + 1;

    --子弹碰撞区
    local boxCollider = bullet:BoxCollider();
    boxCollider:SetParent(self.bulletColliderTransform);
    --设置子弹的起始坐标
    bullet:Init(_chairId,_startPos,_rotation,_bulletId,_isMyAndroid,_bulletKind);
    --锁定鱼
    --bullet:Lock(_lockFish);
    --设置是否由我托管
    bullet:SetMyAndroid(_isMyAndroid);

    return bullet;
end

--得到某个座位的子弹个数
function _CGameBulletControl:GetBulletCount(_chairId)
    return self._bulletCount[_chairId];
end

local fishCount = 0;
function _CGameBulletControl:Update(_dt,_isSwitchScene)
    local x1,y1,x2,y2 = self._sceneControl:GetSceneRectInWorld(true);
    local realx,realy,realx2,realy2= self._sceneControl:GetRealSceneRectInWorld();
    --鱼网每帧执行
    self._gameNetControl:Update(_dt);
    local bulletMap = self._bulletMap;
    local isMove = self._isMove;
    for i,v in pairs(bulletMap) do
        v:UpdateEx(_dt,realx,realy,realx2,realy2,x1,x2,isMove,_isSwitchScene);
    end
end


function _CGameBulletControl:DeleteBullet(_bullet)
    local chairId = _bullet.chairId;
    self._bulletCount[chairId] = self._bulletCount[chairId] - 1;
    self._bulletMap[_bullet.lid] = nil;
    local vec;
    if _bullet.isOwner then
        vec = self._cacheSelfBulletPool[_bullet.type];
    else
        vec = self._cacheOtherBulletPool[_bullet.type];
    end
    if _bullet.isOwner then
        if #vec>=10 then --超过释放掉
            _bullet:Destroy();
        else
            _bullet:Cache();
            vec[#vec+1] = _bullet;
        end
    else
        if #vec>=20 then --超过释放掉
            _bullet:Destroy();
        else
            _bullet:Cache();
            vec[#vec+1] = _bullet;
        end
    end
end

function _CGameBulletControl:DeleteBulletById(_bulletId)
    local bulletMap = self._bulletMap;
    local isMove = self._isMove;
    for i,v in pairs(bulletMap) do
        if v.bulletId == _bulletId then
            self:DeleteBullet(v);
            break;
        end
    end
end

function _CGameBulletControl:OnEventBullet(_eventId,_bullet)
    if _eventId == G_GlobalGame_EventID.BulletDisappear then
        self:DeleteBullet(_bullet);
        --创建鱼网
        self._gameNetControl:CreateNet(_bullet);
    elseif _eventId==G_GlobalGame_EventID.BulletDelete then
        --直接删除子弹
        self:DeleteBullet(_bullet);
    end
end

--清除所有的子弹
function _CGameBulletControl:ClearAllBullets()
    local bulletMap = self._bulletMap;
    local vec;
    for i,v in pairs(bulletMap) do
        if v.isOwner then
            vec = self._cacheSelfBulletPool[v.type];
        else
            vec = self._cacheOtherBulletPool[v.type];
        end
        bulletMap[i] = nil;
        if v.isOwner then
            if #vec>=10 then --超过释放掉
                v:Destroy();
            else
                v:Cache();
                vec[#vec+1] = v;
            end
        else
            if #vec>=20 then --超过释放掉
                v:Destroy();
            else
                v:Cache();
                vec[#vec+1] = v;
            end
        end
    end
    for i=0,4 do
        self._bulletCount[i] = 0;
    end
    --self._bulletMap = {};
    --删除所有鱼网
    self._gameNetControl:ClearAllNets();    
end

return _CGameBulletControl;