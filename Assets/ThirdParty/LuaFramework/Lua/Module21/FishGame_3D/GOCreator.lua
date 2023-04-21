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


import ".Functions";

--local _CGOCreator=class("_CGOCreator");
--加载状态
local ENUM_LOAD_STATE = {
    NotLoad     = 0,
    IsLoading   = 1,
    LoadSuccess = 2,
};

local _CGOCreator=class();

--缓存ab资源里预制体、图片、shader的引用，不用每次都重新从ab里获取，游戏退出后，统一卸载ab资源就好，也减少了动态申请内存的次数

function _CGOCreator:ctor()
    self._gameUIABName      = 'module21/game_fish3d2_ui';
    self._gameSceneABName   = 'module21/game_fish3d2_scene';
    self._gameFishABName    = 'module21/game_fish3d2_fish';
    self._gameMusicABName   = 'module21/game_fish3d2_music';
    self._gameHelpABName    = 'module21/game_fish3d2_help'; --帮助 ab资源
    self._gameEffectABName  = 'module21/game_fish3d2_effect';
    self._gameUIV1ABName    = 'module21/game_fish3d2_ui_v1';
    self:_init();
end

function _CGOCreator:_init()
    self.mainPanelObj= nil;
    self.gameSceneObj= nil;
    self.uiObj       = nil;
    self.fishNetObj  = nil;
    self.bulletObjs  = {
                            animate = {
                                other = {},
                                self  = {},
                            },
                            collider = {
                                other = {},
                                self  = {},
                            },
                        };
    self.paotaiObjs  = {};
    self.fishObjs    = {};
    self.rightPlayer = nil;
    self.rightSelfPlayer = nil;
    self.leftPlayer  = nil;
    self.leftSelfPlayer  = nil;
    self.guidePlayer = nil;
    self.players     = nil;
    self.netObj      = nil;
    self.goldItem    = nil;
    self.lockItem    = {};
    self.lockLine    = nil;
    self.goldObj     = nil;
    self.silverObj   = nil;
    self.scoreColumnObjs = {};
    self.soundObjs   = {};
    self.newHandObj  = nil;

    self.effectsGO   = {};
    --特效obj
    self.effectObjs  = {};
    self.effectPrefabName = {
        "effect_yuwangbaodian",
        "effect_xiaoyubaodian",
        "yuwang_H",
        "yuwang_L",
    };
    self.lockFlagSprite= {};
    self.playerInfoBgs = {};

    --加载骨骼预制体
    self._fishBonePrefabNames = {
        "_01_fish",
        "_02_fish",
        "_03_fish",
        "_04_fish",
        "_05_fish",
        "_06_fish",
        "_07_fish",
        "_08_fish",
        "_09_fish",
        "_10_fish",
        "_11_fish",
        "_12_fish",
        "_13_fish",
        "_14_fish",
        "_15_fish",
        "_16_fish",
        "_17_fish",
        "_18_fish",
        "_19_fish",
        "_20_fish",
        "_21_fish",
        "_22_fish",
        "_23_fish",
        "_24_fish",
        "_25_fish",
        "_28_fish",
        "_31_fish",
        "_32_fish",
        "_33_fish",
        "_34_fish",
        "_35_fish",
        "_36_fish",
        "_37_fish",
        "_38_fish",
        "_39_fish",
        "_40_fish",
        "ui_21_fish",
        "ui_23_fish",
        "ui_24_fish",
        "ui_25_fish",
        "ui_28_fish",
        "ui_31_fish",
        "ui_32_fish",
        "ui_33_fish",
        "ui_34_fish",
        "ui_35_fish",
        "ui_36_fish",
        "ui_37_fish",
        "ui_38_fish",
        "ui_39_fish",
        "ui_40_fish",
    };

    self._fishEffectPrefabNames = {
    };

    self._fishModelPrefabNames = {
        "CommonFish",
    };

    --鱼的新方式
    self.fishModelObj  ={};
    self.fishGOs = { sceneGOs = {}, uiGOs = {}};
    self.fishUIGOs = {};
    self.fishEffectChildNames = {};
    self.fishEffectObjs = {};
    self.fishBonesObjs  = {};
    self.netObjs = {self={}, other={}};
    --鱼游戏
    self.fishGOsLoadState = {
        [0 ] = {fishType = 0 , loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [1 ] = {fishType = 1 , loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [2 ] = {fishType = 2 , loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [3 ] = {fishType = 3 , loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [4 ] = {fishType = 4 , loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [5 ] = {fishType = 5 , loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [6 ] = {fishType = 6 , loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [7 ] = {fishType = 7 , loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [8 ] = {fishType = 8 , loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [9 ] = {fishType = 9 , loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [10] = {fishType = 10, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [11] = {fishType = 11, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [12] = {fishType = 12, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [13] = {fishType = 13, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [14] = {fishType = 14, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [15] = {fishType = 15, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [16] = {fishType = 16, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [17] = {fishType = 17, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [18] = {fishType = 18, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [19] = {fishType = 19, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [20] = {fishType = 20, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [21] = {fishType = 21, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [22] = {fishType = 22, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [23] = {fishType = 23, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [24] = {fishType = 24, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [25] = {fishType = 25, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [26] = {fishType = 26, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [27] = {fishType = 27, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [28] = {fishType = 28, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [29] = {fishType = 29, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [30] = {fishType = 30, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [31] = {fishType = 31, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [32] = {fishType = 32, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [33] = {fishType = 33, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [34] = {fishType = 34, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [35] = {fishType = 35, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [36] = {fishType = 36, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [37] = {fishType = 37, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [38] = {fishType = 38, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [39] = {fishType = 39, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [40] = {fishType = 40, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [41] = {fishType = 41, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        [42] = {fishType = 42, loadState = 0, scenGO = nil, uiGO = nil, effcetChildNames = {nil,nil,nil,nil,}, cbFunc = {nil,nil,nil,nil}, boneGOs={}, needGOCount=0, },
        broadcast = function(self,loadState)

        end,
        broadcastSimple = function(self,loadState,_handler)
            local objs = newobject(loadState.sceneGOs);
            _handler(objs,loadState.effcetChildNames);
        end,
        onFishLoadOver = function(self,loadState)

        end,
    };

    --ab资源里对应的sprite
    self.abCommonSprite = {};
    --
    self.spritesPrefab = {
    };
    --帮助的
    self.helpObjs = {};

    --所有的abName;
    self.abName = {};

    --shader表
    self.shaderTable = {};

    self.kingEffect = nil;

    --击杀鱼获取金币
    self.effectGetScoreObj = nil;

    --代码
    self.asyncSeqLoad = {
    
    };
end

--预加载一些东西
function _CGOCreator:PreLoad()
    for i=G_GlobalGame_Enum_FishType.FISH_KIND_31,G_GlobalGame_Enum_FishType.FISH_KIND_COUNT do
        self:loadFish(i);
    end
    --预加载
    self:loadNet(G_GlobalGame.Enum_NetType.Common,true);
end


function _CGOCreator:PreLoadAsync(_handler)
--    local preloadFishModel = function(_handler,_handler1,_handler2,_handler3,_handler4,_handler5,_handler6)
--        local modelName = self._fishModelPrefabNames;
--        local count=#modelName;
--        local i=1;
--        local nextModelHandler;
--        local name;
--        local fishModelObj = self.fishModelObj;
--        local fishABName = self._gameFishABName;
--        nextModelHandler = function (_obj)
--            fishModelObj[name] = _obj;
--            G_GlobalGame_FunctionsLib_FUNC_CacheGO(_obj);
--            i = i + 1;
--            if i>count then
--                _handler(_handler1,_handler2,_handler3,_handler4,_handler5,_handler6);
--                return ;
--            else
--                name = modelName[i];
--                self:LoadAssetAsync(fishABName,name,nextModelHandler,true);
--            end
--        end
--        if i>count then
--            _handler(_handler1,_handler2,_handler3,_handler4,_handler5,_handler6);
--        else
--            name = modelName[i];
--            self:LoadAssetAsync(fishABName,name,nextModelHandler,true);
--        end
--    end
--    --先加载骨骼部分
--    local preloadBone = function(_handler,_handler1,_handler2,_handler3,_handler4,_handler5,_handler6)
--        local boneName = self._fishBonePrefabNames;
--        local count=#boneName;
--        local i=1;
--        local nextBoneHandler;
--        local name;
--        local fishBonesObjs = self.fishBonesObjs;
--        local fishABName = self._gameFishABName;
--        nextBoneHandler = function (_obj)
--            fishBonesObjs[name] = _obj;
--            G_GlobalGame_FunctionsLib_FUNC_CacheGO(_obj);
--            i = i + 1;
--            if i>count then
--                _handler(_handler1,_handler2,_handler3,_handler4,_handler5,_handler6);
--                return ;
--            else
--                name = boneName[i];
--                self:LoadAssetAsync(fishABName,name,nextBoneHandler,true);
--            end
--        end
--        if i>count then
--            _handler(_handler1,_handler2,_handler3,_handler4,_handler5,_handler6);
--        else
--            name = boneName[i];
--            self:LoadAssetAsync(fishABName,name,nextBoneHandler,true);
--        end
--    end

--    local preloadFishEffect = function(_handler,_handler1,_handler2,_handler3,_handler4,_handler5,_handler6)
--        local effectName = self._fishEffectPrefabNames;
--        local count=#effectName;
--        local i=1;
--        local nextEffectHandler;
--        local name;
--        local fishEffectObjs = self.fishEffectObjs;
--        local effectABName = self._gameEffectABName;
--        nextEffectHandler = function (_obj)
--            fishEffectObjs[name] = _obj;
--            i = i + 1;
--            if i>count then
--                _handler(_handler1,_handler2,_handler3,_handler4,_handler5,_handler6);
--                return ;
--            else
--                name = boneName[i];
--                self:LoadAssetAsync(effectABName,name,nextEffectHandler);
--            end
--        end
--        if i>count then
--            _handler(_handler1,_handler2,_handler3,_handler4,_handler5,_handler6);
--        else
--            name = boneName[i];
--            self:LoadAssetAsync(effectABName,name,nextEffectHandler);
--        end
--    end

--    local preloadFish = function(_handler,_handler1,_handler2,_handler3,_handler4,_handler5,_handler6)
--        local FishType = G_GlobalGame.Enum_FishType;
--        local i = FishType.FISH_KIND_31;
--        local nextHandler;
--        nextHandler = function(_obj)
--            i = i + 1;
--            while(i==FishType.FISH_KIND_26 or i==FishType.FISH_KIND_27
--                or i==FishType.FISH_KIND_29 or i==FishType.FISH_KIND_30) do
--                i = i + 1;
--            end
--            if i>FishType.FISH_KIND_COUNT then
--                _handler(_handler1,_handler2,_handler3,_handler4,_handler5,_handler6);
--            else
--                self:loadFishAsync(i,nextHandler);
--            end
--        end
--        self:loadFishAsync(i,nextHandler);
--    end

--    local preloadEffect = function(_handler,_handler1,_handler2,_handler3,_handler4,_handler5,_handler6)
--        local effectName = self.effectPrefabName;
--        local count=#effectName;
--        local i=1;
--        local nextEffectHandler;
--        local name;
--        local fishEffectObjs = self.effectObjs;
--        local effectABName = self._gameEffectABName;
--        nextEffectHandler = function (_obj)
--            fishEffectObjs[name] = _obj;
--            i = i + 1;
--            if i>count then
--                _handler(_handler1,_handler2,_handler3,_handler4,_handler5,_handler6);
--                return ;
--            else
--                name = effectName[i];
--                self:LoadAssetAsync(effectABName,name,nextEffectHandler);
--            end
--        end
--        if i>count then
--            _handler(_handler1,_handler2,_handler3,_handler4,_handler5,_handler6);
--        else
--            name = effectName[i];
--            self:LoadAssetAsync(effectABName,name,nextEffectHandler);
--        end
--    end

--    --执行先后顺序
--    preloadFishModel(preloadBone,preloadFishEffect,preloadFish,preloadEffect,_handler);
    local FishType = G_GlobalGame.Enum_FishType;
    local i = FishType.FISH_KIND_1;
    for i=FishType.FISH_KIND_1,FishType.FISH_KIND_COUNT do
        self:CreateFishAsyncEx(i);
    end 
end

--创建主窗口
function _CGOCreator:createMainPanel()
    if self.mainPanelObj then
        return newobject(self.mainPanelObj);
    end
    local name = "MainPanelEx";
    self.mainPanelObj= self:LoadAsset(self._gameUIABName, name);
    if not self.mainPanelObj then
        error("obj [" .. self._gameUIABName  .. ":" .. name .. "] ab not exist");
        return nil;
    end
    self.mainPanelObj.transform:Find("Layers/ContentLayer/MainCamera").localRotation = Quaternion.identity;
    self.mainPanelObj.transform:Find("Layers/ContentLayer/MainCamera"):GetComponent("Camera").fieldOfView=18;
    self.mainPanelObj.transform:Find("Layers/UILayer/UICamera").localRotation = Quaternion.identity;
    self.mainPanelObj.transform:Find("Layers/UILayer"):GetComponent("CanvasScaler").referenceResolution = Vector2.New(1334, 750);
    self.mainPanelObj.transform:Find("Layers/SystemLayer"):GetComponent("CanvasScaler").referenceResolution = Vector2.New(1334, 750);
    self.mainPanelObj.transform:Find("Layers/TipLayer"):GetComponent("CanvasScaler").referenceResolution = Vector2.New(1334, 750);
    local obj = newobject(self.mainPanelObj);
    --obj.name = name;
    return obj;
end

--创建主窗口
function _CGOCreator:createMainPanelEx(_handler)
    local name = "MainPanelEx";
    self:LoadAssetAsync(self._gameUIABName, name,_handler,true);
end

--创建游戏场景
function _CGOCreator:createGameScene()
    if self.gameSceneObj then
        return newobject(self.gameSceneObj);
    end
    local name = "GameScene";
    self.gameSceneObj= self:LoadAsset(self._gameSceneABName, name);
    if not self.gameSceneObj then
        error("obj [" .. self._gameSceneABName  .. ":" .. name .. "] ab not exist");
        return nil;
    end
    local obj= newobject(self.gameSceneObj);
    --obj.name = name;
    return obj;
end

--背景
function _CGOCreator:createBgScene()
    if self.bgSceneObj then
        return newobject(self.bgSceneObj);
    end
    local name = "BgScene";
    self.bgSceneObj= self:LoadAsset(self._gameSceneABName, name);
    if not self.bgSceneObj then
        error("obj [" .. self._gameSceneABName  .. ":" .. name .. "] ab not exist");
        return nil;
    end
    local obj= newobject(self.bgSceneObj);
    --obj.name = name;
    return obj;
end

--创建UI部分
function _CGOCreator:createUIPart()
    if self.uiObj then
        return newobject(self.uiObj);
    end
    local name = "UIPart";
    self.uiObj= self:LoadAsset(self._gameUIABName, name);
    local obj= newobject(self.uiObj);
    --obj.name = name;
    return obj;
end

function _CGOCreator:createPlayer(isOwner)
    isOwner = isOwner or false;
    if isOwner then
        if self.selfPlayer then
        else
            local name = "Player_Self";
            self.selfPlayer = self:LoadAsset(self._gameUIABName, name);
        end
        local obj= newobject(self.selfPlayer);
        --obj.name = "Player";
        return obj;
    else
        if self.otherPlayer then
        else
            local name = "Player_Other";
            self.otherPlayer = self:LoadAsset(self._gameUIABName, name);
        end
        local obj= newobject(self.otherPlayer);
        --obj.name = "Player";
        return obj;
    end
end


--创建鱼
function _CGOCreator:createFish(_type)
    if self.fishObjs[_type] then
    else
        self.fishObjs[_type] = self:LoadAsset(self._gameFishABName, G_GlobalGame_FunctionsLib_FUNC_GetFishPrefabName(_type));
    end
    local obj= newobject(self.fishObjs[_type]);
    obj.name = "Fish";
    return obj;
end


--
function _CGOCreator:createContinueShotObj()
    if not self._continueCombObj then
        self._continueCombObj = self:LoadAsset(self._gameUIABName, "ContinueCombs");
    end
    local obj= newobject(self._continueCombObj);
    --obj.name = "ContinueStatus";
    return obj;
end

function _CGOCreator:LoadAsset(abName,obName)
    local loadName =  abName .. '/' .. obName;
    local obj = MainPanel.Pool(loadName) 
    if obj then
        return obj;
    end
    self.abName[abName] = 1;
    local obj =LoadAsset(abName, obName); 
    if obj==nil then
        error("Failed load AbName:" .. abName .. ",ObjName:" .. obName);
    end
    return obj;
end

function _CGOCreator:LoadAssetAsync(abName,obName,handler,isInit)
    error("CGOCreator:LoadAssetAsync>>>>>>>"..abName.."  "..obName);
    self.abName[abName] = 1;
    local seqLoad = self.asyncSeqLoad[abName];
    local cbCallBack = function(_go)
        if G_GlobalGame.isQuitGame then
            return ;
        end
        handler(_go);
        table.remove(seqLoad,1);
        if #seqLoad>0 then
            local loadData = seqLoad[1];
            LoadAssetAsync(abName, loadData.obName,loadData.hanlder, loadData.isInit,true);
            --LoadAsset(abName, loadData.obName,loadData.hanlder, loadData.isInit,true);
        end
    end
    if seqLoad==nil then
        seqLoad = {};
        self.asyncSeqLoad[abName] = seqLoad;
        seqLoad[1] = {};
        LoadAssetAsync(abName, obName,cbCallBack,isInit or false,true);
        --LoadAsset(abName, obName,cbCallBack,isInit or false,true);
    else
        if #seqLoad>0 then
            seqLoad[#seqLoad + 1] = {obName = obName, hanlder = cbCallBack,isInit = isInit or false };
        else
            seqLoad[1] = {};
            LoadAssetAsync(abName, obName,cbCallBack,isInit or false,true);
            --LoadAsset(abName, obName,cbCallBack,isInit or false,true);
        end
    end
end

function _CGOCreator:LoadAssetObj(abName,obName)
    --self.abName[abName] = 1;
    --return ResManager:LoadAssetObj(abName, obName);
    self.abName[abName] = 1;
    local obj = self:LoadAsset(abName,obName);
    if obj==nil then
        error("Failed load AbName:" .. abName .. ",ObjName:" .. obName);
    end
    return obj;
end

--鱼网的特效
function _CGOCreator:GetYuWangEffect()
    self:loadFish(G_GlobalGame_Enum_FishType.FISH_KIND_31);
    if self.kingEffect then
        return newobject(self.kingEffect);
    end
    return nil;
end


local cbFishObj = function (loadState,_handler)
    if not _handler then
        return ;
    end
    if loadState.sceneGO==nil then
        _handler(nil)
    else
        local go = newobject(loadState.sceneGO);
        _handler(go);
    end
end

local broadcaseFishObj = function(loadState)
    local cbFunc = loadState.cbFunc;
    if loadState.sceneGO==nil then
        for i=1,#cbFunc do
            cbFunc[i](nil);
        end
    else    
        for i=1,#cbFunc do
            local go = newobject(loadState.sceneGO);
            cbFunc[i](go);
        end
    end
    loadState.cbFunc = {};
end

local _C_Str_Body_Name = "Body";

local loadFishOver = function(loadState)
    loadState.loadState = ENUM_LOAD_STATE.LoadSuccess;
    local fishStyleInfo = G_GlobalGame_FunctionsLib_FUNC_GetFishStyleInfo(loadState.fishType);
    local obj = loadState.sceneGO;
    if obj == nil  then
        broadcaseFishObj(loadState);
        return ; 
    end
    local transform = obj.transform;
    local fishAbName = self._gameFishABName;
    local fishBonesObjs = self.fishBonesObjs;
    local boneGOs = loadState.boneGOs;
    local boneCount = #boneGOs;
    local bodyName;
    local boneInfo;
    local boneData;
    local child;
    local boneGO;
    local boneTransform;
    local localScale;
    local localPosition; 
    local localRotation;
    for i=1,boneCount do
        boneInfo = boneGOs[i];
        boneGO = boneInfo.go;
        if boneGO then
            bodyName = boneInfo.bodyName;
            boneData = boneInfo.data;
            child = transform:Find(bodyName);
            if child then
                boneTransform = boneGO.transform;
                localScale = boneTransform.localScale;
                localPosition = boneTransform.localPosition;
                localRotation = boneTransform.localRotation;
                boneTransform:SetParent(child);
                if boneData.name then
                    --判断是否有名字
                    boneGO.name = boneData.name;
                end
                local bp = boneData.pos;
                if bp then
                    if bp.x then
                        boneTransform.localPosition = bp;
                    else
                        V_Vector3_Value.x = bp[1];
                        V_Vector3_Value.y = bp[2];
                        V_Vector3_Value.z = bp[3];
                        boneTransform.localPosition = V_Vector3_Value;
                    end
                else
                    boneTransform.localPosition = localPosition;
                end
                local rt = boneData.rotation;
                if rt then
                    if rt.x then
                        V_Vector3_Value.x = rt.x;
                        V_Vector3_Value.y = rt.y;
                        V_Vector3_Value.z = rt.z;
                    else
                        V_Vector3_Value.x = rt[1];
                        V_Vector3_Value.y = rt[2];
                        V_Vector3_Value.z = rt[3];
                    end
                    boneTransform.localEulerAngles = V_Vector3_Value;
                else
                    boneTransform.localRotation = localRotation;
                end
                local bs = boneData.scale;
                if bs then
                    if bs.x ==nil then
                        V_Vector3_Value.x = bs[1];
                        V_Vector3_Value.y = bs[2];
                        V_Vector3_Value.z = bs[3];
                    else
                        V_Vector3_Value.x = bs.x;
                        V_Vector3_Value.y = bs.y;
                        V_Vector3_Value.z = bs.z;
                    end
                    boneTransform.localScale = V_Vector3_Value;
                else
                    --tempTrans.localScale = Vector3.One();
                    boneTransform.localScale = localScale;
                end
            end
        end
    end
    broadcaseFishObj(loadState);
end

local loadModelCB = function(loadState,_go)
    loadState.sceneGO = _go;
    loadState.needGOCount = loadState.needGOCount - 1;
    if loadState.needGOCount == 0 then
        loadFishOver(loadState);
    end
end

local loadBoneCB = function(sendData,_go)
    local loadState = sendData.loadState;
    local boneGOs = loadState.boneGOs;
    loadState.needGOCount = loadState.needGOCount - 1;
    if _go then
        sendData.go =  _go;
        boneGOs[#boneGOs+1] = sendData;
    end
    if loadState.needGOCount == 0 then
        loadFishOver(loadState);
    end
end

function _CGOCreator:CreateFishAsyncEx(_type,_handler)
    local fishGOTool = self.fishGOsLoadState;
    local loadState = fishGOTool[_type];
    local cbFunc = loadState.cbFunc;
    if loadState.loadState == ENUM_LOAD_STATE.LoadSuccess then
        cbFishObj(loadState,_handler);
    elseif loadState.loadState == ENUM_LOAD_STATE.NotLoad then
        cbFunc[#cbFunc + 1] = _handler;
        --启动异步加载
        self:_loadFishGOAsync(_type,loadState);
    elseif loadState.loadState == ENUM_LOAD_STATE.IsLoading then
        cbFunc[#cbFunc + 1] = _handler;
    end
end

function _CGOCreator:_loadFishGOAsync(_type,loadState)
    local fishStyleInfo = G_GlobalGame_FunctionsLib_FUNC_GetFishStyleInfo(_type);
    local prefabName = fishStyleInfo.prefabName;
    local data = self.fishModelObj[prefabName];

    loadState.needGOCount = 1;

    loadState.loadState = ENUM_LOAD_STATE.IsLoading
    if data == nil then
        data = {loadState = 0, go = nil, cbFunc = {nil,nil,nil,nil,nil}};
        self.fishModelObj[prefabName] = data;
        local cbFunc = data.cbFunc;
        cbFunc[#cbFunc+1] = handler(loadState,loadModelCB);
        loadState.needGOCount = loadState.needGOCount + 1; --计数器+1
        self:_loadFishModelAsync(prefabName,data)
    elseif data.loadState ==  ENUM_LOAD_STATE.IsLoading then
        local cbFunc = data.cbFunc;
        cbFunc[#cbFunc+1] = handler(loadState,loadModelCB);
        loadState.needGOCount = loadState.needGOCount + 1; --计数器+1
    elseif data.loadState ==  ENUM_LOAD_STATE.LoadSuccess then  
        local go = newobject(data.go);
        G_GlobalGame_FunctionsLib_FUNC_CacheGO(go);
        loadState.needGOCount = loadState.needGOCount + 1; --计数器+1
        loadModelCB(loadState,go);
    end

    local bones = fishStyleInfo.bones;

    local prefabName;
    --local loadBoneCB_ = handler(loadState,loadBoneCB);
    local sendData = nil;
    for i,v in pairs(bones) do
        prefabName = v.prefabName;
        data = self.fishBonesObjs[prefabName];
        if data == nil then
            data = {loadState = 0, go = nil, cbFunc = {nil,nil,nil,nil,nil}};
            self.fishBonesObjs[prefabName] = data;
            sendData = {loadState = loadState,bodyName=i,data= v,go=nil,};
            local cbFunc = data.cbFunc;
            cbFunc[#cbFunc+1] = handler(sendData,loadBoneCB);
            loadState.needGOCount = loadState.needGOCount + 1; --计数器+1
            self:_loadFishBoneAsync(prefabName,data)
        elseif data.loadState ==  ENUM_LOAD_STATE.IsLoading then
            local cbFunc = data.cbFunc;
            sendData = {loadState = loadState,bodyName=i,data= v,go=nil,};
            cbFunc[#cbFunc+1] = handler(sendData,loadBoneCB);
            loadState.needGOCount = loadState.needGOCount + 1; --计数器+1
        elseif data.loadState ==  ENUM_LOAD_STATE.LoadSuccess then  
            local go = newobject(data.go);
            G_GlobalGame_FunctionsLib_FUNC_CacheGO(go);
            loadState.needGOCount = loadState.needGOCount + 1; --计数器+1
            sendData = {loadState = loadState,bodyName=i,data = v,go=go,};
            loadBoneCB(sendData,go);
        end
    end 

    if loadState.needGOCount==1 then
        loadFishOver(loadState);
    end
    loadState.needGOCount = loadState.needGOCount - 1;
end

local broadcaseModelOver = function(modelData)
    local go = modelData.go;
    local cbFunc = modelData.cbFunc;
    local cb;
    local _go;
    for i=1,#cbFunc do
        if go ==nil then
            _go = nil;
        else
            _go = newobject(go);
            G_GlobalGame_FunctionsLib_FUNC_CacheGO(_go);
        end       
        cb = cbFunc[i];
        cb(_go);
    end
    modelData.cbFunc = {};
end

local loadModelOver = function(modelData,_go)
    modelData.go = _go;
    if _go then
        _go:SetActive(true);
        G_GlobalGame_FunctionsLib_FUNC_CacheGO(_go);
    end
    modelData.loadState =  ENUM_LOAD_STATE.LoadSuccess;
    broadcaseModelOver(modelData);
end

local broadcaseBoneOver = function(boneData)
    local go = boneData.go;
    local cbFunc = boneData.cbFunc;
    local cb;
    local _go;
    for i=1,#cbFunc do
        if go ==nil then
            _go = nil;
        else
            _go = newobject(go);
            G_GlobalGame_FunctionsLib_FUNC_CacheGO(_go);
        end 
        cb = cbFunc[i];
        cb(_go);
    end
    boneData.cbFunc = {};
end

local loadBoneOver = function(boneData,_go)
    boneData.go = _go;
    if _go then
        _go:SetActive(true);
        G_GlobalGame_FunctionsLib_FUNC_CacheGO(_go);
    end
    boneData.loadState =  ENUM_LOAD_STATE.LoadSuccess;
    broadcaseBoneOver(boneData);
end


function _CGOCreator:_loadFishModelAsync(prefabName,modelData)
    self:LoadAssetAsync(self._gameFishABName, prefabName,handler(modelData,loadModelOver),true);
    modelData.loadState =  ENUM_LOAD_STATE.IsLoading;
end

function _CGOCreator:_loadFishBoneAsync(prefabName,boneData)
    self:LoadAssetAsync(self._gameFishABName, prefabName,handler(boneData,loadBoneOver),true);
    boneData.loadState =  ENUM_LOAD_STATE.IsLoading;
end

function _CGOCreator:loadFish(_type)
    local fishStyleInfo = G_GlobalGame_FunctionsLib_FUNC_GetFishStyleInfo(_type);
    if not fishStyleInfo then
        return ;
    end
    if not self.fishModelObj[fishStyleInfo.prefabName] then
        self.fishModelObj[fishStyleInfo.prefabName] = self:LoadAsset(self._gameFishABName, fishStyleInfo.prefabName);
    end
    local fishModelObj = self.fishModelObj[fishStyleInfo.prefabName];
    local fishUIStyleInfo = G_GlobalGame_FunctionsLib.FUNC_GetFishUIStyleInfo(_type);

    local isFixedUI = fishStyleInfo.isFixedUI;
    if not self.fishGOs.sceneGOs[_type] then
        self.fishEffectChildNames[_type] = {};

        local loadModel = function(_type,fishStyleInfo,name)
            local MObj = newobject(fishModelObj);
            --放入缓存
            G_GlobalGame_FunctionsLib_FUNC_CacheGO(MObj);

            if fishStyleInfo.bones then
                --鱼骨骼信息
                local transform = MObj.transform;
                local childCount = transform.childCount;
                local child;
                local bonesData;
                local obj;
                local go;
                local tempTrans;
                local animaTrans;
                local fishEffectNames = self.fishEffectChildNames[_type];
                local localScale;
                local localPosition;
                local localRotation;
                local fishAbName = self._gameFishABName;
                local fishBonesObjs = self.fishBonesObjs;
                for i=1,childCount do
                    child = transform:GetChild(i-1);
                    bonesData = fishStyleInfo.bones[child.gameObject.name];
                    animaTrans = nil;
                    if bonesData then
                        local prefabName = bonesData.prefabName;
                        if prefabName then
                            --添加身体骨骼
                            if not fishBonesObjs[prefabName] then
                                if bonesData.abName then
                                    fishBonesObjs[prefabName] = self:LoadAsset(bonesData.abName, prefabName);
                                else
                                    fishBonesObjs[prefabName] = self:LoadAsset(fishAbName, prefabName);
                                end
                            end
                            obj = fishBonesObjs[prefabName];
                            if obj then
                                go = newobject(obj);
                                go:SetActive(true);
                                --go = obj;
                                if bonesData.name then
                                    --判断是否有名字
                                    go.name = bonesData.name;
                                end
                                tempTrans = go.transform;
                                localScale = tempTrans.localScale;
                                localPosition = tempTrans.localPosition;
                                localRotation = tempTrans.localRotation;
                                tempTrans:SetParent(child);
                                animaTrans = tempTrans;
                                local bp = bonesData.pos;
                                if bp then
                                    if bp.x then
                                        tempTrans.localPosition = bp;
                                    else
                                        V_Vector3_Value.x = bp[1];
                                        V_Vector3_Value.y = bp[2];
                                        V_Vector3_Value.z = bp[3];
                                        tempTrans.localPosition = V_Vector3_Value;
                                    end
                                else
                                    tempTrans.localPosition = localPosition;
                                end
                                local rt = bonesData.rotation;
                                if rt then
                                    if rt.x then
                                        V_Vector3_Value.x = rt.x;
                                        V_Vector3_Value.y = rt.y;
                                        V_Vector3_Value.z = rt.z;
                                    else
                                        V_Vector3_Value.x = rt[1];
                                        V_Vector3_Value.y = rt[2];
                                        V_Vector3_Value.z = rt[3];
                                    end
                                    tempTrans.localEulerAngles = V_Vector3_Value;
                                else
                                    tempTrans.localRotation = localRotation;
                                end
                                local bs = bonesData.scale;
                                if bs then
                                    if bonesData.scale.x ==nil then
                                        V_Vector3_Value.x = bs[1];
                                        V_Vector3_Value.y = bs[2];
                                        V_Vector3_Value.z = bs[3];
                                    else
                                        V_Vector3_Value.x = bs.x;
                                        V_Vector3_Value.y = bs.y;
                                        V_Vector3_Value.z = bs.z;
                                    end
                                    tempTrans.localScale = V_Vector3_Value;
                                else
                                    --tempTrans.localScale = Vector3.One();
                                    tempTrans.localScale = localScale;
                                end
                            end -- if obj then

                        end  -- if bonesData.prefabName then
                        local be = bonesData.effects;
                        if be and #be>0 then
                            --添加特效
                            local eCount = #be;
                            local effect;
                            --特效名字
                            local fishEffectObjs = self.fishEffectObjs;
                            local effectABName =self._gameEffectABName;
                            for i=1,eCount do
                                effect = be[i];
                                local epname=effect.prefabName;
                                if effect and epname then
                                    if not fishEffectObjs[epname] then
                                        if effect.abName then
                                            fishEffectObjs[epname] = self:LoadAsset(effect.abName, epname);
                                        else
                                            fishEffectObjs[epname] = self:LoadAsset(effectABName, epname);
                                        end
                                    end
                                    obj = fishEffectObjs[epname];
                                    if _type >= G_GlobalGame_Enum_FishType.FISH_KIND_31 and _type<= G_GlobalGame_Enum_FishType.FISH_KIND_40 then
                                        self.kingEffect = fishEffectObjs[epname];
                                    end
                                    if obj then
                                        go = newobject(obj);
                                        if effect.name then
                                            --判断是否有名字
                                            go.name = effect.name;
                                        end
                                        if effect.isInAnimate and animaTrans then
                                            local andEffectTrans = animaTrans:Find(effect.animateBoneName);
                                            if andEffectTrans then
                                                tempTrans = go.transform;
                                                localScale = tempTrans.localScale;
                                                localPosition = tempTrans.localPosition;
                                                localRotation = tempTrans.localRotation;
                                                tempTrans:SetParent(andEffectTrans); 
                                                fishEffectNames[#fishEffectNames+1] = child.gameObject.name .. 
                                                            "/" ..animaTrans.gameObject.name .. "/" .. effect.animateBoneName .. "/" .. go.name;
                                            else
                                                tempTrans = go.transform;  
                                                localScale = tempTrans.localScale;
                                                localPosition = tempTrans.localPosition;
                                                localRotation = tempTrans.localRotation;    
                                                tempTrans:SetParent(child);
                                                fishEffectNames[#fishEffectNames+1] = child.gameObject.name .. "/" .. go.name;                                           
                                            end
                                        else
                                            tempTrans = go.transform;
                                            localScale = tempTrans.localScale;
                                            localPosition = tempTrans.localPosition;
                                            localRotation = tempTrans.localRotation; 
                                            tempTrans:SetParent(child);
                                            fishEffectNames[#fishEffectNames+1] = child.gameObject.name .. "/" .. go.name;
                                        end
                                        local epos = effect.pos;
                                        if epos then
                                            if epos.x then
                                                tempTrans.localPosition = epos;
                                            else
                                                V_Vector3_Value.x = epos[1];
                                                V_Vector3_Value.y = epos[2];
                                                V_Vector3_Value.z = epos[3];
                                                tempTrans.localPosition = V_Vector3_Value;
                                            end
                                        else
                                            tempTrans.localPosition = localPosition;
                                        end
                                        local ert = effect.rotation;
                                        if ert then
                                            if ert.x then
                                                tempTrans.localEulerAngles = ert;
                                            else
                                                V_Vector3_Value.x = ert[1];
                                                V_Vector3_Value.y = ert[2];
                                                V_Vector3_Value.z = ert[3];
                                                tempTrans.localEulerAngles = V_Vector3_Value;
                                            end
                                            tempTrans.localEulerAngles = ert;
                                        else
                                            tempTrans.localRotation = localRotation;
                                        end
                                        local es = effect.scale;
                                        if es then
                                            if es.x ==nil then
                                                V_Vector3_Value.x = es[1];
                                                V_Vector3_Value.y = es[2];
                                                V_Vector3_Value.z = es[3];
                                                tempTrans.localScale = V_Vector3_Value;
                                            else
                                                tempTrans.localScale = es;
                                            end
                                            
                                        else
                                            tempTrans.localScale = localScale;
                                        end
                                    end --if obj then
                                end  --if effect and effect.prefabName then 
                            end  --for i=1,eCount do

                        end --if bonesData.effects and #bonesData.effects>0 then
                    end --if bonesData then 
                end  --for i=1,childCount do
            end  -- if fishStyleInfo.bones then
            return MObj;
        end

        self.fishGOs.sceneGOs[_type] = loadModel(_type,fishStyleInfo,"scene");
        if fishUIStyleInfo then
            self.fishGOs.uiGOs[_type] = loadModel(_type,fishUIStyleInfo,"ui");
        else
            self.fishGOs.uiGOs[_type] = self.fishGOs.sceneGOs[_type];
        end

    end  -- if not self.fishGOs[_type] then
    return self.fishGOs.sceneGOs[_type],self.fishEffectChildNames[_type],self.fishGOs.uiGOs[_type];
end


function _CGOCreator:loadFishAsync(_type,_handler)
    local fishStyleInfo = G_GlobalGame_FunctionsLib_FUNC_GetFishStyleInfo(_type);
    if not fishStyleInfo then
        return ;
    end
    local fishUIStyleInfo;
    local prefabName = fishStyleInfo.prefabName;
    local _go = self.fishModelObj[prefabName];
    local _async = function(_obj)
        self.fishModelObj[prefabName] = _obj;
        self:loadFishAsync(_type,_handler);
        --放入缓存
        G_GlobalGame_FunctionsLib_FUNC_CacheGO(_obj);
    end
    if not _go then
        self:LoadAssetAsync(self._gameFishABName, prefabName,_async,true,true);
        return ;
    else
        fishUIStyleInfo = G_GlobalGame_FunctionsLib.FUNC_GetFishUIStyleInfo(_type);
    end

    local isFixedUI = fishStyleInfo.isFixedUI;
    if not self.fishGOs.sceneGOs[_type] then
        self.fishEffectChildNames[_type] = {};

        local loadModel = function(_type,fishStyleInfo,name)
            local obj = newobject(_go);
            --放入缓存
            G_GlobalGame_FunctionsLib_FUNC_CacheGO(obj);

            if fishStyleInfo.bones then
                --鱼骨骼信息
                local transform = obj.transform;
                local childCount = transform.childCount;
                local child;
                local bonesData;
                local obj;
                local go;
                local tempTrans;
                local animaTrans;
                local fishEffectNames = self.fishEffectChildNames[_type];
                local localScale;
                local localPosition;
                local localRotation;
                local fishAbName = self._gameFishABName;
                local fishBonesObjs = self.fishBonesObjs;
                for i=1,childCount do
                    child = transform:GetChild(i-1);
                    bonesData = fishStyleInfo.bones[child.gameObject.name];
                    animaTrans = nil;
                    if bonesData then
                        local prefabName = bonesData.prefabName;
                        if prefabName then
                            --添加身体骨骼
--                            if not fishBonesObjs[prefabName] then
--                                if bonesData.abName then
--                                    fishBonesObjs[prefabName] = self:LoadAsset(bonesData.abName, prefabName);
--                                else
--                                    fishBonesObjs[prefabName] = self:LoadAsset(fishAbName, prefabName);
--                                end
--                            end
                            obj = fishBonesObjs[prefabName];
                            if obj then
                                --go = newobject(obj);
                                go = obj;
                                if bonesData.name then
                                    --判断是否有名字
                                    go.name = bonesData.name;
                                end
                                tempTrans = go.transform;
                                localScale = tempTrans.localScale;
                                localPosition = tempTrans.localPosition;
                                localRotation = tempTrans.localRotation;
                                tempTrans:SetParent(child);
                                animaTrans = tempTrans;
                                local bp = bonesData.pos;
                                if bp then
                                    if bp.x then
                                        tempTrans.localPosition = bp;
                                    else
                                        V_Vector3_Value.x = bp[1];
                                        V_Vector3_Value.y = bp[2];
                                        V_Vector3_Value.z = bp[3];
                                        tempTrans.localPosition = V_Vector3_Value;
                                    end
                                else
                                    tempTrans.localPosition = localPosition;
                                end
                                local rt = bonesData.rotation;
                                if rt then
                                    if rt.x then
                                        V_Vector3_Value.x = rt.x;
                                        V_Vector3_Value.y = rt.y;
                                        V_Vector3_Value.z = rt.z;
                                    else
                                        V_Vector3_Value.x = rt[1];
                                        V_Vector3_Value.y = rt[2];
                                        V_Vector3_Value.z = rt[3];
                                    end
                                    tempTrans.localEulerAngles = V_Vector3_Value;
                                else
                                    tempTrans.localRotation = localRotation;
                                end
                                local bs = bonesData.scale;
                                if bs then
                                    if bonesData.scale.x ==nil then
                                        V_Vector3_Value.x = bs[1];
                                        V_Vector3_Value.y = bs[2];
                                        V_Vector3_Value.z = bs[3];
                                    else
                                        V_Vector3_Value.x = bs.x;
                                        V_Vector3_Value.y = bs.y;
                                        V_Vector3_Value.z = bs.z;
                                    end
                                    tempTrans.localScale = V_Vector3_Value;
                                else
                                    --tempTrans.localScale = Vector3.One();
                                    tempTrans.localScale = localScale;
                                end
                            end -- if obj then

                        end  -- if bonesData.prefabName then
                        local be = bonesData.effects;
                        if be and #be>0 then
                            --添加特效
                            local eCount = #be;
                            local effect;
                            --特效名字
                            local fishEffectObjs = self.fishEffectObjs;
                            local effectABName =self._gameEffectABName;
                            for i=1,eCount do
                                effect = be[i];
                                local epname=effect.prefabName;
                                if effect and epname then
                                    if not fishEffectObjs[epname] then
                                        if effect.abName then
                                            fishEffectObjs[epname] = self:LoadAsset(effect.abName, epname);
                                        else
                                            fishEffectObjs[epname] = self:LoadAsset(effectABName, epname);
                                        end
                                    end
                                    obj = fishEffectObjs[epname];
                                    if _type >= G_GlobalGame_Enum_FishType.FISH_KIND_31 and _type<= G_GlobalGame_Enum_FishType.FISH_KIND_40 then
                                        self.kingEffect = fishEffectObjs[epname];
                                    end
                                    if obj then
                                        go = newobject(obj);
                                        if effect.name then
                                            --判断是否有名字
                                            go.name = effect.name;
                                        end
                                        if effect.isInAnimate and animaTrans then
                                            local andEffectTrans = animaTrans:Find(effect.animateBoneName);
                                            if andEffectTrans then
                                                tempTrans = go.transform;
                                                localScale = tempTrans.localScale;
                                                localPosition = tempTrans.localPosition;
                                                localRotation = tempTrans.localRotation;
                                                tempTrans:SetParent(andEffectTrans); 
                                                fishEffectNames[#fishEffectNames+1] = child.gameObject.name .. 
                                                            "/" ..animaTrans.gameObject.name .. "/" .. effect.animateBoneName .. "/" .. go.name;
                                            else
                                                tempTrans = go.transform;  
                                                localScale = tempTrans.localScale;
                                                localPosition = tempTrans.localPosition;
                                                localRotation = tempTrans.localRotation;    
                                                tempTrans:SetParent(child);
                                                fishEffectNames[#fishEffectNames+1] = child.gameObject.name .. "/" .. go.name;                                           
                                            end
                                        else
                                            tempTrans = go.transform;
                                            localScale = tempTrans.localScale;
                                            localPosition = tempTrans.localPosition;
                                            localRotation = tempTrans.localRotation; 
                                            tempTrans:SetParent(child);
                                            fishEffectNames[#fishEffectNames+1] = child.gameObject.name .. "/" .. go.name;
                                        end
                                        local epos = effect.pos;
                                        if epos then
                                            if epos.x then
                                                tempTrans.localPosition = epos;
                                            else
                                                V_Vector3_Value.x = epos[1];
                                                V_Vector3_Value.y = epos[2];
                                                V_Vector3_Value.z = epos[3];
                                                tempTrans.localPosition = V_Vector3_Value;
                                            end
                                        else
                                            tempTrans.localPosition = localPosition;
                                        end
                                        local ert = effect.rotation;
                                        if ert then
                                            if ert.x then
                                                tempTrans.localEulerAngles = ert;
                                            else
                                                V_Vector3_Value.x = ert[1];
                                                V_Vector3_Value.y = ert[2];
                                                V_Vector3_Value.z = ert[3];
                                                tempTrans.localEulerAngles = V_Vector3_Value;
                                            end
                                            tempTrans.localEulerAngles = ert;
                                        else
                                            tempTrans.localRotation = localRotation;
                                        end
                                        local es = effect.scale;
                                        if es then
                                            if es.x ==nil then
                                                V_Vector3_Value.x = es[1];
                                                V_Vector3_Value.y = es[2];
                                                V_Vector3_Value.z = es[3];
                                                tempTrans.localScale = V_Vector3_Value;
                                            else
                                                tempTrans.localScale = es;
                                            end
                                            
                                        else
                                            tempTrans.localScale = localScale;
                                        end
                                    end --if obj then
                                end  --if effect and effect.prefabName then 
                            end  --for i=1,eCount do

                        end --if bonesData.effects and #bonesData.effects>0 then
                    end --if bonesData then 
                end  --for i=1,childCount do
            end  -- if fishStyleInfo.bones then
            return obj;
        end

        self.fishGOs.sceneGOs[_type] = loadModel(_type,fishStyleInfo,"scene");
        if fishUIStyleInfo then
            self.fishGOs.uiGOs[_type] = loadModel(_type,fishUIStyleInfo,"ui");
        else
            self.fishGOs.uiGOs[_type] = self.fishGOs.sceneGOs[_type];
        end

    end  -- if not self.fishGOs[_type] then
    _handler();
    return self.fishGOs.sceneGOs[_type],self.fishEffectChildNames[_type],self.fishGOs.uiGOs[_type];
end

--创建新鱼的方法
function _CGOCreator:createFishNew(_type)
    --加载鱼
    local go,names = self:loadFish(_type);
    if not go then
        return nil,names;
    end
    local obj= newobject(go);
    obj.name = "Fish";
    return obj,names;
end


--创建新鱼的方法
function _CGOCreator:createUIFish(_type)
    --加载鱼
    local _,names,go = self:loadFish(_type);
    if not go then
        return nil,names;
    end
    local obj= newobject(go);
    --obj.name = "Fish";
    return obj,names;
end


--创建子弹
function _CGOCreator:createBullet(_type,_isOwner)
    local objs ;
    if _isOwner then
        objs = self.bulletObjs.animate.self;
    else
        objs = self.bulletObjs.animate.other;
    end
    if objs[_type] then
    else
        local styleInfo = G_GlobalGame_FunctionsLib.FUNC_GetBulletStyleInfo(_type,_isOwner);
        local name= G_GlobalGame_FunctionsLib_FUNC_GetPrefabName(styleInfo.preType);
        local obj = self:LoadAsset(self._gameSceneABName, name);
        objs[_type] = newobject(obj);
        G_GlobalGame_FunctionsLib_FUNC_CacheGO(objs[_type]);
        local body = objs[_type].transform:Find("Body");
        local collider = objs[_type].transform:Find("Collider");
        G_GlobalGame_FunctionsLib_FUNC_AddAnimate(body.gameObject,styleInfo.bodyAnima);
    end
    local obj= newobject(objs[_type]);
    --obj.name = "Bullet";
    return obj;
end

function _CGOCreator:createBulletCollider(_type,_isOwner)
    local objs ;
    if _isOwner then
        objs = self.bulletObjs.collider.self;
    else
        objs = self.bulletObjs.collider.other;
    end
    local name = "BulletCollider";
    if objs[_type] then
    else
        local obj = self:LoadAsset(self._gameSceneABName, name);
        local styleInfo = G_GlobalGame_FunctionsLib.FUNC_GetBulletStyleInfo(_type,_isOwner);
        objs[_type] = newobject(obj);
        G_GlobalGame_FunctionsLib_FUNC_CacheGO(objs[_type]);
        if styleInfo.boxCollider then
            local boxCollider = objs[_type]:GetComponent(BoxColliderClassType);
            local boxColliderData = styleInfo.boxCollider;
            if boxCollider then
            else
                boxCollider = objs[_type]:AddComponent(BoxColliderClassType);
            end
            if boxColliderData.center  then
                boxCollider.center = boxColliderData.center;
                --boxCollider.center = VECTOR3NEW(boxColliderData.center.x,boxColliderData.center.y,boxColliderData.center.z);
            end
            if boxColliderData.size then
                boxCollider.size = boxColliderData.size;
                --boxCollider.size = VECTOR3NEW(boxColliderData.size.x,boxColliderData.size.y,boxColliderData.size.z);
            end
        end
    end
    local obj= newobject(objs[_type]);
    --obj.name = name;
    return obj;
end

--加载鱼网预制体
function _CGOCreator:loadNet(_netType,_isOwner)
    local netObjs;
    if _isOwner then
        netObjs = self.netObjs.self;
    else
        netObjs = self.netObjs.other;
    end
    if not netObjs[_netType] then
         netObjs[_netType] = GAMEOBJECT_NEW();
         --放入缓存
         G_GlobalGame_FunctionsLib_FUNC_CacheGO(netObjs[_netType]);
         --netObjs[_netType].name = "Template_Net";
         G_GlobalGame_FunctionsLib_FUNC_AddAnimate(netObjs[_netType],G_GlobalGame_FunctionsLib.FUNC_GetNetAnimateType(_netType,_isOwner));

         local effectObj;
         local obj;
         if _isOwner then
            obj = self:LoadAsset(self._gameEffectABName, "yuwang_H");
         else
            obj = self:LoadAsset(self._gameEffectABName, "yuwang_L");
         end
         effectObj = newobject(obj);
         local effectTransform = effectObj.transform;
         local localScale    = effectTransform.localScale;
         effectTransform:SetParent(netObjs[_netType].transform);
         effectTransform.localScale    = localScale;
    end
    return netObjs[_netType];
end

--创建鱼网
function _CGOCreator:createNet(_netType,_isOwner)
    local netObjs = self:loadNet(_netType,_isOwner);
    local obj= newobject(netObjs);
    --obj.name = "Net";
    return obj;
end

function _CGOCreator:createPlayers()
    if self.players then
        return newobject(self.players);
    end
    local name = "Players";
    self.players = self:LoadAsset(self._gameUIABName, name);
    local obj= newobject(self.players);
    --obj.name = name;
    return obj;
end

function _CGOCreator:getShader(_shaderId)
    if self.shaderTable[_shaderId] then
        return self.shaderTable[_shaderId];
    end
    local _shaderName = G_GlobalGame_FunctionsLib.FUNC_GetShaderName(_shaderId);
    self.shaderTable[_shaderId] = UnityEngine.Shader.Find(_shaderName);
    return self.shaderTable[_shaderId];
end


--创建左边玩家
function _CGOCreator:createLeftPlayer(isOwner)
    isOwner = isOwner or false;
    if isOwner then
        if self.leftSelfPlayer then
        else
            local name = "Player_Left_Self";
            self.leftSelfPlayer = self:LoadAsset(self._gameUIABName, name);
        end
        local obj= newobject(self.leftSelfPlayer);
        --obj.name = "Player";
        return obj;
    else
        if self.leftPlayer then
        else
            local name = "Player_Left";
            self.leftPlayer = self:LoadAsset(self._gameUIABName, name);
        end
        local obj= newobject(self.leftPlayer);
        --obj.name = "Player";
        return obj;
    end

end

--创建右边玩家
function _CGOCreator:createRightPlayer(isOwner)
    isOwner = isOwner or false;
    if isOwner then
        if self.rightSelfPlayer then
        else
            local name = "Player_Right_Self";
            self.rightSelfPlayer = self:LoadAsset(self._gameUIABName, name);
        end
        local obj= newobject(self.rightSelfPlayer);
        --obj.name = "Player";
        return obj;
    else
        if self.rightPlayer then
        else
            local name = "Player_Right";
            self.rightPlayer = self:LoadAsset(self._gameUIABName, name);
        end
        local obj= newobject(self.rightPlayer);
        --obj.name = "Player";
        return obj;
    end
end

--创建引导player
function _CGOCreator:createGuidePlayer()
    if not self.guidePlayer then
        self.guidePlayer = self:LoadAsset(self._gameUIABName, "Player"); 
    end
    local obj= newobject(self.guidePlayer);
    obj.name = "Player";
    return obj;
end

--创建炮台
function _CGOCreator:createPaotai(_type,_isOwner)
    local FunctionsLib = G_GlobalGame_FunctionsLib;
    local paotaiStyle = FunctionsLib.FUNC_GetPaotaiStyleInfo(_type,_isOwner);
    local styleType = paotaiStyle.preType;
    if not self.paotaiObjs[styleType] then
        local obj = self:LoadAsset(self._gameUIABName, G_GlobalGame_FunctionsLib.FUNC_GetPrefabName(styleType));
        self.paotaiObjs[styleType] = newobject(obj);
        G_GlobalGame_FunctionsLib_FUNC_CacheGO(self.paotaiObjs[styleType]);
        local body = self.paotaiObjs[styleType].transform:Find("Body");
        G_GlobalGame_FunctionsLib_FUNC_AddAnimate(body.gameObject,paotaiStyle.bodyAnima);
    end
    local obj= newobject(self.paotaiObjs[styleType]);
    obj.name = "PaoTai";
    return obj;
end

function _CGOCreator:createGoldItem()
    if not self.goldItem then
        self.goldItem = self:LoadAsset(self._gameUIABName, "GoldItem");
    end
    local obj = newobject(self.goldItem);
    return obj;
end

--创建锁定项
function _CGOCreator:createLockItem(index)
    if not self.lockItem[index] then 
        self.lockItem[index] = self:LoadAsset(self._gameUIABName, G_GlobalGame_FunctionsLib.FUNC_GetLockTargetPrefabName(index));
    end
    local obj = newobject(self.lockItem[index]);
    return obj;
end

--创建锁定线
function _CGOCreator:createLockLine()
    if not self.lockLine then 
        self.lockLine = self:LoadAsset(self._gameUIABName, G_GlobalGame_FunctionsLib.FUNC_GetLockLinePrefabName());
    end
    local obj = newobject(self.lockLine);
    return obj;
end

--得到
function _CGOCreator:createPlayerInfoBg(_colorIndex)
    if not self.playerInfoBgs[_colorIndex] then
        self.playerInfoBgs[_colorIndex] = self:LoadAssetObj(self._gameUIABName, "frameBg" .. _colorIndex);
    end
    return self.playerInfoBgs[_colorIndex];
end


--创建飞金币的效果
function _CGOCreator:createGold()
    --[[
    if not self.goldObj then
        self.goldObj = ResManager:LoadAsset(self._gamePlayerABName, "FlyGold");
    end
    local obj = newobject(self.goldObj);
    return obj;
    --]]
    if not self.goldObj then
         self.goldObj = GAMEOBJECT_NEW();
         --放入缓存
         G_GlobalGame_FunctionsLib_FUNC_CacheGO(self.goldObj);
         --self.goldObj.name = "Template_FlyGold";
         G_GlobalGame_FunctionsLib_FUNC_AddAnimate(self.goldObj,G_GlobalGame.Enum_AnimateType.FlyGold);
    end
    local obj= newobject(self.goldObj);
    --obj.name = "Net";
    return obj;
end

--创建飞银币的效果
function _CGOCreator:createSilver()
    --[[
    if not self.silverObj then
        self.silverObj = ResManager:LoadAsset(self._gamePlayerABName, "FlySilver");
    end
    local obj = newobject(self.silverObj);
    return obj;
    --]]
    if not self.silverObj then
         self.silverObj = GAMEOBJECT_NEW();
         --放入缓存
         G_GlobalGame_FunctionsLib_FUNC_CacheGO(self.silverObj);
         --self.silverObj.name = "Template_FlySilver";
         G_GlobalGame_FunctionsLib_FUNC_AddAnimate(self.silverObj,G_GlobalGame.Enum_AnimateType.FlySilver);
    end
    local obj= newobject(self.silverObj);
    --obj.name = "Net";
    return obj;
end


--创建 金币堆
function _CGOCreator:createScoreColumn(index)
    if not self.scoreColumnObjs[index] then
        self.scoreColumnObjs[index] = self:LoadAsset(self._gameUIABName, G_GlobalGame_FunctionsLib.FUNC_GetScoreColumnPrefabName(index));
    end
    return newobject(self.scoreColumnObjs[index]);
end

--获取声音资源
function _CGOCreator:getMusic(_name,_abName)
    if not self.soundObjs[_name] then
        _abName = _abName or self._gameMusicABName;
        self.soundObjs[_name] = self:LoadAssetObj(_abName, _name);
    end
    return self.soundObjs[_name].gameObject:GetComponent(typeof(UnityEngine.AudioSource)).clip;
end

--创建一个新手引导
function _CGOCreator:createNewHand()
    if not self.newHandObj then
        local _name = "NewHandGuide";
        self.newHandObj = self:LoadAssetObj(self._gameUIABName, _name);
    end
    local obj = newobject(self.newHandObj);
    --obj.name = "NewHandGuide";
    return obj;
end

--创建效果
function _CGOCreator:createEffect(_type,...)
    if not self.effectsGO[_type] then
        local name = G_GlobalGame_FunctionsLib.FUNC_GetEffectPrefabName(_type,...);
        local obj  = self.effectObjs[name];
        if not self.effectObjs[name] then
            obj = self:LoadAsset(self._gameEffectABName,name);
            self.effectObjs[name] = obj;
        end
        if obj ==nil then
            self.effectsGO[_type] = GAMEOBJECT_NEW();
        else
            self.effectsGO[_type] = newobject(obj);
        end 
        --self.effectsGO[_type].name = "Template_Effect " .. _type;
        G_GlobalGame_FunctionsLib_FUNC_CacheGO(self.effectsGO[_type]);
        --G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self.effectsGO[_type],G_GlobalGame.FunctionsLib.FUNC_GetEffectAnimaType(_type,...));
    end
    return newobject(self.effectsGO[_type]);
end

--得到锁定的目标图片
function _CGOCreator:getLockFishFlag(_type)
    if not self.lockFlagSprite[_type] then
        self.lockFlagSprite[_type] = self:LoadAssetObj(self._gameUIABName,G_GlobalGame_FunctionsLib.FUNC_GetLockFishFlagPrefabName(_type));
    end
    return self.lockFlagSprite[_type];
end

--获取公用sprite
function _CGOCreator:getCommonSprite(_abname,_spriteName)
    local abSprite;
    if not self.abCommonSprite[_abname] then
        self.abCommonSprite[_abname] = {};
    end
    abSprite = self.abCommonSprite[_abname];
    if not abSprite[_spriteName] then
        local abPrefabSprite = self.spritesPrefab[_abname];
        if abPrefabSprite then
        else
            local obj = self:LoadAsset(_abname,"SpriteSources");
            local go = newobject(obj);
            G_GlobalGame_FunctionsLib_FUNC_CacheGO(go);
            local tab = {obj = go};
            self.spritesPrefab[_abname] = tab;
            abPrefabSprite = tab;
        end
        local obj = abPrefabSprite.obj;
        if obj then
            local spriteTransform = obj.transform:Find(_spriteName);
            if spriteTransform then
                local spriteRender = spriteTransform:GetComponent("SpriteRenderer");
                abSprite[_spriteName] = {sprite = spriteRender.sprite, };
                return abSprite[_spriteName].sprite;
            end
        end
        local spr = self:LoadAssetObj(_abname,_spriteName);
        abSprite[_spriteName] = {sprite = spr, };
    end
    return abSprite[_spriteName].sprite;
end

--从UI AB资源里读取
function _CGOCreator:getUICommonSprite(_spriteName)
    return self:getCommonSprite(self._gameUIABName,_spriteName);
end

--
function _CGOCreator:createHelpPanel()
    return self:createHelpObjs("HelpPanel");
end

--获取帮助
function _CGOCreator:createHelpObjs(_prefabName)
    if _prefabName==nil then
        return ;
    end
    if not self.helpObjs[_prefabName] then
        self.helpObjs[_prefabName] = self:LoadAssetObj(self._gameUIABName,_prefabName);
    end
    return newobject(self.helpObjs[_prefabName]);
end

--击杀鱼得分
function _CGOCreator:createEffectGetScore()
    if not self.effectGetScoreObj then
        self.effectGetScoreObj = self:LoadAssetObj(self._gameUIABName,"EffectGetScore");
    end
    return newobject(self.effectGetScoreObj);
end



--清除内存
function _CGOCreator:clear()
    self:_init();
    coroutine.start(
        function ()
            coroutine.wait(1);
            --释放ab资源
            for key, value in pairs(self.abName) do  
                ResManager:Unload(key);  
            end 
        end
    );
end



--function _CGOCreator:

return _CGOCreator;
