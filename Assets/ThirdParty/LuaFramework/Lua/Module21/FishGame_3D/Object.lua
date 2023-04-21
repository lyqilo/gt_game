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

--local _CObject= class("_CObject");
local _CObject= class();
local idCreator = ID_Creator(1);


function _CObject:ctor()
    self.transform  = nil;
    self.gameObject = nil;
    self.lid        = idCreator();
end

function _CObject:LID()
    return self.lid;
end

function _CObject:Cache()
    G_GlobalGame:CacheObject(self);
    V_Vector3_Value.x=15000;
    V_Vector3_Value.y=15000;
    V_Vector3_Value.z=0;
    self.transform.position = V_Vector3_Value;                          
end

--�Ƿ񱣳�ԭ�������ӣ�������С��λ�ã���ת
function _CObject:IsKeepSame()
    return false;
end

function _CObject:SetParent(_parent)
    local localPosition = self.transform.localPosition;
    local localScale    = self.transform.localScale;
    local localRotation = self.transform.localRotation;
    self.transform:SetParent(_parent);
    self.transform.localPosition    = localPosition;
    self.transform.localScale       = localScale;
    self.transform.localRotation    = localRotation;
    --[[
    self.__beforeIndex= self.__index;
    self.__index =function (table ,key)
        if key == "position" then
            if table.transform then
                return table.transform.position;
            end
        elseif key== "localPosition" then
            if table.transform then
                return table.transform.localPosition;
            end
        end
        return table.__beforeIndex(table,key);
    end
    --]]
end

function _CObject:SetParentBySame(_parent)
    self.transform:SetParent(_parent);
end

function _CObject:Position()
    return self.transform.position;
end 

function _CObject:LocalPosition()
    return self.transform.localPosition;
end

function _CObject:SetPosition(position)
    self.transform.position = position;
end

function _CObject:SetLocalPosition(localPosition)
    self.transform.localPosition = localPosition;
end

function _CObject:Scale()
    return self.transform.scale;
end

function _CObject:LocalScale()
    return self.transform.localScale;
end

--���ñ��ش�С
function _CObject:SetLocalScale(localScale)
    self.transform.localScale = localScale;
end

--
function _CObject:SetScale(scale)
    self.transform.scale = scale;
end
--
function _CObject:LocalRotation()
    return self.transform.localRotation;
end

--
function _CObject:Rotation()
    return self.transform.rotation;
end

function _CObject:SetLocalRotation(localRotation)
    self.transform.localRotation = localRotation;
end

function _CObject:SetRotation(rotation)
    self.transform.rotation = rotation;
end

function _CObject:EulerAngles()
    return self.transform.eulerAngles;
end

function _CObject:LocalEulerAngles()
    return self.transform.localEulerAngles;
end

function _CObject:SetEulerAngles(eulerAngles)
    self.transform.eulerAngles = eulerAngles;
end

function _CObject:SetLocalEulerAngles(localEulerAngles)
    self.transform.localEulerAngles = localEulerAngles;
end

function _CObject:Display()
    if G_GlobalGame.isQuitGame then
        return ;
    end
    self.transform.gameObject:SetActive(true);
end

function _CObject:Hide()
    if G_GlobalGame.isQuitGame then
        return ;
    end
    self.transform.gameObject:SetActive(false);
end

function _CObject:Destroy()
    if G_GlobalGame.isQuitGame then
        return ;
    end
    if self.gameObject then
        destroy(self.gameObject);
    end
end

--ÿִ֡��
function _CObject:Update(_dt)

end

return _CObject;