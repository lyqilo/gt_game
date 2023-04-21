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

--local _CAnimaTool = class("_CAnimaTool");
local _CAnimaTool = class();
function _CAnimaTool:ctor()

    self._spriteCreator = nil;
end

--设置sprite 创建器
function _CAnimaTool:SetCreator(_spriteCreator)
    self._spriteCreator = _spriteCreator;
end

--为某个游戏体添加动画组件
--如果没有image组件，会添加，如果没有imageAnima，会添加
function _CAnimaTool:AddAnima(go,animaType)
    if not self._spriteCreator then
        return ;
    end
    local animateData = G_GlobalGame_GameConfig_AnimaStyleInfo[animaType];
    if not animateData then
        return ;
    end
    if not go then
        return ;
    end
    local image = go:GetComponent(ImageClassType);
    if not image then
        image = go:AddComponent(ImageClassType);
    end
    local imageAnima = go:GetComponent(ImageAnimaClassType);
    if not imageAnima then
        imageAnima = go:AddComponent(ImageAnimaClassType);
    end
    imageAnima.fSep = animateData.interval;
    local frameIndex = animateData.frameBeginIndex;
    local str;
    local sprite;
    local abFileName=animateData.abfileName;
    local frameMin = 0;
    if animateData.frameMin then
        frameMin = animateData.frameMin;
    end
    local isRaycastTarget = animateData.isRaycastTarget or false;
    image.raycastTarget = isRaycastTarget;

    for i=1,animateData.frameCount do
        if frameIndex< frameMin then
            frameIndex = frameMin;
        end
        if animateData.frameMax then
            --最大的索引
            if frameIndex>animateData.frameMax then
                frameIndex = frameMin;
            end
        end
        str =string.format(animateData.format, frameIndex);
        frameIndex = frameIndex + animateData.frameInterval;
        sprite = self._spriteCreator(abFileName,str);
        imageAnima:AddSprite(sprite);
        if i==1 then
            image.sprite = sprite;
            if animateData.isCorrentSize then
                if animateData.size then
                    local rect = image.transform:GetComponent("RectTransform");
                    rect.sizeDelta = Vector2.New(animateData.size.x,animateData.size.y);
                else
                    image:SetNativeSize();
                end
            end
        end
    end

    if animateData.defaultSprite then
        imageAnima.defaultSprite = self._spriteCreator(abFileName,animateData.defaultSprite);
        image.sprite = imageAnima.defaultSprite;
    end

    return imageAnima;
end



return _CAnimaTool;