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

--local CNet = GameRequire("Net");
local CEventObject=GameRequire("EventObject");

--local _CNet = class("_CNet",CEventObject);
local _CNet = class(nil,CEventObject);

function _CNet.Create(_bullet)
    local obj  = _CNet.New();
    local netType = _bullet:NetType();
    local isOwner = _bullet:IsOwner();
    local go = G_GlobalGame_goFactory:createNet(netType,isOwner);
    --go.name = "Net";
    obj:Init(go.transform);
    obj.type    = netType; --��Ӧ����������
    obj.isOwner = isOwner;
    return obj;
end

function _CNet:ctor()
    _CNet.super.ctor(self);
    self.type       = G_GlobalGame.Enum_NetType.Common;
    self.isOwner    = false;
    self.actionEndHandler = handler(self,self._actionEnd);
end

function _CNet:Init(transform)
    self.transform = transform;
    self.gameObject = transform.gameObject;
    self.animator  = transform:GetComponent(ImageAnimaClassType);
    self.animator:SetEndEvent(self.actionEndHandler);
end

function _CNet:Play(_pos,_isOwner)
    self.animator:Play();
    self.transform.localPosition = _pos;
    self.transform.localScale = C_Vector3_One;
end

function _CNet:_actionEnd()
    --�����Լ�
    --֪ͨ�����¼�
    self:SendEvent(G_GlobalGame_EventID.NetActionEnd);
    --ɾ���¼��б�
    self:ClearEvent();
end


local CNet = _CNet;

--��������
--local _CGameNetControl = class("_CGameNetControl");
local _CGameNetControl = class();


function _CGameNetControl:ctor()
    self._cacheSelfNetPool = {nil,nil,nil,nil,nil,};
    self._cacheOtherNetPool= {nil,nil,nil,nil,nil,};
    for i=G_GlobalGame.Enum_NetType.Common,G_GlobalGame.Enum_NetType.Three do
        self._cacheSelfNetPool[i] = {                
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                };
        self._cacheOtherNetPool[i] = {
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                };
    end
    self._netMap           = {
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,
                nil,nil,nil,nil,nil,nil,nil,nil,nil,};
end

--��ʼ��
function _CGameNetControl:Init(transform)
    self.transform = transform;
    self.gameObject= transform.gameObject;
end

--��������
function _CGameNetControl:CreateNet(_bullet)
    local net;
    local _type = _bullet:NetType();
    local vec;
    if _bullet.isOwner then
        vec = self._cacheSelfNetPool[_type];
        if #vec<1 then
            net = CNet.Create(_bullet)
        else
            net = table.remove(vec);
        end
    else
        vec = self._cacheOtherNetPool[_type];
        if #vec<1 then
            net = CNet.Create(_bullet)
        else
            net = table.remove(vec);
        end
    end
    net:SetParentBySame(self.transform);
    net:RegEvent(self,self.OnEventNet);
    self._netMap[net.lid] = net;
    net:Play(_bullet.localPosition,_bullet.isOwner);
    return net;
end


--�յ�����¼�
function _CGameNetControl:OnEventNet(_eventId,_net)
    if _eventId == G_GlobalGame_EventID.NetActionEnd then
        self._netMap[_net.lid] = nil;
        local vec;
        if _net.isOwner then
            vec = self._cacheSelfNetPool[_net.type];
        else
            vec = self._cacheOtherNetPool[_net.type];
        end
        if _net.isOwner then
            if #vec>=4 then
                _net:Destroy();
            else
                _net:Cache();
                vec[#vec + 1] = _net;
            end
        else
            if #vec>=6 then
                _net:Destroy();
            else
                _net:Cache();
                vec[#vec + 1] = _net;
            end            
        end
    end
end

function _CGameNetControl:Update(_dt)

end

--ɾ�����е�����
function _CGameNetControl:ClearAllNets()
    local netMap = self._netMap;
    local vec;
    for i,v in pairs(netMap) do   
        if v.isOwner then
            vec = self._cacheSelfNetPool[v.type];
        else
            vec = self._cacheOtherNetPool[v.type];
        end
        if v.isOwner then
            if #vec>=4 then
                v:Destroy();
            else
                v:Cache();
                vec[#vec + 1] = v;
            end
        else
            if #vec>=6 then
                v:Destroy();
            else
                v:Cache();
                vec[#vec + 1] = v;
            end            
        end
        netMap[i] = nil;
    end
    --self._netMap = {};
end

return _CGameNetControl;