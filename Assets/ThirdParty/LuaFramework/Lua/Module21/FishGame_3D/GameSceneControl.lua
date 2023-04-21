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


local _CGameFishControl = GameRequire("GameFishControl");
local _CGameBulletControl = GameRequire("GameBulletControl");
local _CPlayersControl  = GameRequire("PlayerControl");
local _CEffectControl  = GameRequire("EffectControl");

--图锟斤拷锟斤拷锟斤拷
local CAtlasNumber = GameRequire("AtlasNumber");

--local _CSwitchSceneControl = class("_CSwitchSceneControl");
local _CSwitchSceneControl = class();

local C_SERVER_SCENE_WIDTH = 1366
local C_SERVER_SCENE_HEIGHT= 768;

local C_CLIENT_SCENE_WIDTH = 1334;
local C_CLIENT_SCENE_HEIGHT = 750;

local C_SCENE_LEFT_X  = -C_CLIENT_SCENE_WIDTH/2;
local C_SCENE_RIGHT_X = C_CLIENT_SCENE_WIDTH/2;

function _CSwitchSceneControl:ctor(_sceneControl)
    self.transform  = nil;
    self.endHandler = nil;
    self.startHaiLangHandler = nil;
    self.switchActionTrans  = nil;
    self.switchSceneBg      = nil;
    self.switchSprite       = nil;
    self.waveBeginPosition  = nil;
    self.isSwitch           = false;
    self.sceneControl       = _sceneControl;
    self.fishGroupData      = nil;
    self.isStart            = false;
end

function _CSwitchSceneControl:Init(transform,uiSwitchTransform)

    self.transform          = transform;
    self.gameObject         = transform.gameObject;
    self.switchSceneBgs     = {};
    self.switchSprites      = {};
    self.bgIndex            = 1;
    self.bgCreatorVec       = vector:new();
    self.switchBg           = transform:Find("Bg");
    self.switchBg1          = transform:Find("RefreshBg1"):GetComponent(ImageClassType);
    local childCount        = self.switchBg.childCount;
    for i=1,childCount do
        self.switchSceneBgs[i] = self.switchBg:GetChild(i-1);
        self.switchSprites[i]  = self.switchSceneBgs[i]:GetComponent(ImageClassType).sprite;
        if i~=self.bgIndex then
            self.bgCreatorVec:push_back(i);
        end
    end

    --UI锟姐潮展示锟侥凤拷式
    self.uiTransform        = uiSwitchTransform;
    self.uiGameObject       = uiSwitchTransform.gameObject;
    self.underMask          = uiSwitchTransform:Find("UnderMask");
    self.switchSceneRight   = self.underMask:Find("SwitchActionsRight");
    self.switchSceneLeft    = self.underMask:Find("SwitchActionsLeft");

    self.startFishGroup     = uiSwitchTransform:Find("StartFishGroup");
    self.overFishGroup      = uiSwitchTransform:Find("EndFishGroup");

    --使锟斤拷锟皆讹拷锟藉播锟脚猴拷锟剿讹拷锟斤拷
    G_GlobalGame_FunctionsLib_FUNC_AddAnimate(self.switchSceneRight.gameObject,G_GlobalGame.Enum_AnimateType.Wave);
--    G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self.switchSceneLeft.gameObject, G_GlobalGame.Enum_AnimateType.Wave);

    self.switchSprite       = self.switchSprites[self.bgIndex];

    --锟揭憋拷
    self.switchActionRightImageAnima       = self.switchSceneRight:GetComponent(ImageAnimaClassType);
    self.switchActionRightImageAnima.fSep  = G_GlobalGame_GameConfig_SceneConfig.switchSceneInterval;
    self.switchActionRightImageAnima.enabled = false;
    self.switchActionRightImage  = self.switchSceneRight:GetComponent(ImageClassType);
    self.switchActionRightImage.sprite = self.switchActionRightImageAnima.lSprites[0];
    local scale = 1.0*G_GlobalGame.ConstantValue.RealScreenWidth/G_GlobalGame.ConstantValue.RealScreenHeight;
    if scale>16/9 then
        self.switchActionRightBeginPos = VECTOR3NEW(940,0,0);
        self.switchActionRightEndPos   = VECTOR3NEW(-940,0,0);
        --锟斤拷锟斤拷锟狡讹拷锟斤拷锟劫讹拷
        self.switchMoveSpeed    = 875;
        self.beginBgMovePos         = VECTOR3NEW(-880,0,0);
    else
        self.switchActionRightBeginPos = VECTOR3NEW(860,0,0);
        self.switchActionRightEndPos   = VECTOR3NEW(-860,0,0);
        --锟斤拷锟斤拷锟狡讹拷锟斤拷锟劫讹拷
        self.switchMoveSpeed    = 800;
        self.beginBgMovePos         = VECTOR3NEW(-800,0,0);
    end



    --锟斤拷锟斤拷锟狡讹拷
    self.switchActionBgMove     = self.underMask:Find("BgMove");
    
    self.rightMovePos      = VECTOR3NEW(0,0,0);
    self.leftMovePos      = VECTOR3NEW(0,0,0);

    --锟斤拷锟剿诧拷锟斤拷帧锟斤拷锟斤拷
    self.switchFrameRunTime = 0;
    self.switchFrame        = 0;

    --锟斤拷始锟斤拷
    self.gameObject:SetActive(false);
    self.underMask.gameObject:SetActive(false);

    self.isSwitch           = false;
    self.isStart            = false;

    self.maskScaleSpeed     = 0.15;
    self.maskCurScale       = 1;

    --锟姐潮
    self.spritesName = {
        "t_wh1","t_lxyc","t_wh1","t_dl",
    };

    --锟斤拷锟街凤拷锟叫碉拷锟劫讹拷
    self.title1MoveSpeed    = 2500;
    
    --锟斤拷叻沙锟?
    self.title1BeginPos     = VECTOR3NEW(-830,48,-350);
    self.title1EndPos       = VECTOR3NEW(-103,48,-350);
    
    --锟揭憋拷锟斤拷锟斤拷
    self.title2MoveSpeed    = -2500;
    self.title2BeginPos     = VECTOR3NEW(1114,-54,-350);
    self.title2EndPos       = VECTOR3NEW(159,-54,-350);

    self.title1MovePos      = VECTOR3NEW(0,0,0);
    self.title2MovePos      = VECTOR3NEW(0,0,0);
end

--锟叫伙拷锟斤拷锟斤拷锟斤拷锟斤拷
function _CSwitchSceneControl:SetEndHandler(_handler)
    self.endHandler  = _handler;
end

--锟斤拷始锟斤拷锟斤拷锟铰硷拷
function _CSwitchSceneControl:SetHaiLangHandler(_handler)
    self.startHaiLangHandler = _handler;
end

function _CSwitchSceneControl:StartSwitchScene(_fishGroupData)
    local startFishGroup = function()
        self.startFishGroup.gameObject:SetActive(true);
        coroutine.wait(4.30);
        if G_GlobalGame.isQuitGame then
            return ;
        end
        self.startFishGroup.gameObject:SetActive(false);
        self:Start();
    end

    self.switchFrameRunTime = 0;
    self.switchFrame = 0;
    self.frameCount = self.switchActionRightImageAnima.lSprites.Count;
    self.isSwitch = true;

    local index = math.random(1,self.bgCreatorVec:size());
    local curIndex = self.bgCreatorVec:pop(index);
    self.bgCreatorVec:push_back(self.bgIndex);
    self.bgIndex = curIndex;
    self.switchSprite = self.switchSprites[self.bgIndex];

    --锟芥换锟斤拷锟斤拷图
    self.switchBg1.sprite = self.switchSprite;
    self.switchBg1.fillAmount = 0;

    self.fishGroupData = _fishGroupData;
    self.isStart = false;
    self.step               = 1;
    self.runTime            = 0;

    self:_prepareStart();

    --锟饺诧拷锟斤拷锟姐潮锟斤拷锟斤拷锟斤拷示
    coroutine.start(startFishGroup);

end

function _CSwitchSceneControl:Start()
    self.isStart = true;
    --锟斤拷锟脚猴拷锟斤拷锟斤拷锟斤拷
    --G_GlobalGame:PlayBgSound(G_GlobalGame.SoundDefine.HaiLang);
    G_GlobalGame:PlayEffect(G_GlobalGame_SoundDefine.ChangeScene);
    if self.startHaiLangHandler then
        self.startHaiLangHandler(self.fishGroupData);
    end
    return self.fishGroupData;
end

--锟姐潮锟斤拷锟斤拷
function _CSwitchSceneControl:FishGroupData()
    return self.fishGroupData;
end

function _CSwitchSceneControl:_prepareStart()
    self.switchSceneRight.localPosition = self.switchActionRightBeginPos;
--    self.switchName.localPosition  =  self.title1BeginPos;
--    self.switchCome.localPosition  =  self.title2BeginPos;
    self.gameObject:SetActive(true);
    self.underMask.gameObject:SetActive(true);
    self.switchBg1.gameObject:SetActive(true);
end

function _CSwitchSceneControl:SwitchOver()
    self.endHandler(self.switchSprite,self.fishGroupData);
    self.gameObject:SetActive(false);
    self.underMask.gameObject:SetActive(false);
    self.isSwitch = false;
    self.isStart  = false;
    self.switchBg1.gameObject:SetActive(false);
end

function _CSwitchSceneControl:Update(_dt)
    if not self.isSwitch then
        return ;
    end
    if not self.isStart then
        return;
    end

    self.switchFrameRunTime = self.switchFrameRunTime + _dt;
    if self.switchFrameRunTime>self.switchActionRightImageAnima.fSep then
        self.switchFrameRunTime = self.switchFrameRunTime - self.switchActionRightImageAnima.fSep;
        self.switchFrame = self.switchFrame + 1;
        if self.switchFrame>=self.frameCount then
            self.switchFrame = 0;
        end
        self.switchActionRightImage.sprite = self.switchActionRightImageAnima.lSprites[self.switchFrame];
    end
    
    if self.step == 1 then
        --锟斤拷锟剿匡拷始锟剿讹拷
        self.runTime = self.runTime + _dt;  
        local moveX = self.switchMoveSpeed * self.runTime;  
        self.rightMovePos.x = -moveX;
        self.leftMovePos.x = moveX;
        local bgPos = self.beginBgMovePos + self.leftMovePos;
        local flv;
        if bgPos.x>=C_SCENE_LEFT_X then
            if bgPos.x>=C_SCENE_RIGHT_X then
                flv = 1;
            else
                local moveX = bgPos.x - C_SCENE_LEFT_X;
                flv = moveX/C_SERVER_SCENE_WIDTH;
            end
            self.switchBg1.fillAmount = flv;
        else
            flv = 0;
        end
        local position1 = self.switchActionRightBeginPos + self.rightMovePos;
        local isArrival = true;
        if position1.x <= self.switchActionRightEndPos.x then
        else
            isArrival = false;
        end
        self.switchSceneRight.localPosition = position1;
        if isArrival then
            --锟斤拷锟斤拷愠?
            self.step    = 2;
            self:SwitchOver();
        end
    end
end

function _CSwitchSceneControl:MoveX()
    return self.switchBg.position.x;
end

function _CSwitchSceneControl:MoveX1()
    return self.switchSceneLeft.position.x;
end

function _CSwitchSceneControl:MoveX2()
    return self.switchSceneRight.position.x;
end

function _CSwitchSceneControl:IsSwitch()
    return self.isSwitch;
end

function _CSwitchSceneControl:IsStart()
    return self.isStart;
end

--local _CGameSceneControl = class("_CGameSceneControl");
local _CGameSceneControl = class();
--GameScenSoundControl \ GameUIControl \ GameScenTimeControl \ GameScenData

function _CGameSceneControl:ctor()
    self._gameFishVector    = nil;
    self._gameFishControl   = _CGameFishControl.New(self);
    self._gameBulletControl = _CGameBulletControl.New(self);
    self._gamePlayersControl= _CPlayersControl.New(self,self._gameBulletControl,self._gameFishControl);
    self._switchSceneControl= _CSwitchSceneControl.New(self);
    self._gameEffectControl = _CEffectControl.New(self);
    self._belowUITrans      = nil;
    self._onUITrans         = nil;
    self._cachePoolTrans    = nil;
    self._uiContentTrans    = nil;
    self._switchScene       = nil;
    self._sceneBg           = nil;
    self._switchSceneControl:SetEndHandler(handler(self,self.SwitchSceneOver));
    self._switchSceneControl:SetHaiLangHandler(handler(self,self.StartPlayHaiLang));
    self._isPauseScreen     = false;
    self._pauseTime         = 0;
    self._bgIndexVec        = vector:new();
    self._bgIndexVec:push_back(G_GlobalGame_SoundDefine.BG1);
    self._bgIndexVec:push_back(G_GlobalGame_SoundDefine.BG2);
    self._bgIndexVec:push_back(G_GlobalGame_SoundDefine.BG3);
    self._bgIndexVec:push_back(G_GlobalGame_SoundDefine.BG4);
    self._isCanShakeScreen  = true;
    self._shakeTime        = 0;
    self._shakeIndex       = 1;

    --update锟斤拷帧锟斤拷锟斤拷
    --self._updateTotalIndex = 0;
    self._updateIndex     = 1;
    self._maxUpdateCount  = 12;
    self._updateRecords   = {};
    self._updateIsExecute = {};
    for i=1,self._maxUpdateCount do
        self._updateRecords[i] = 0;
    end
    
    --锟竭斤拷
    self._borders = {
        x1 = 0,
        y1 = 0,
        x2 = 0,
        y2 = 0, 
    };

    self.countBorderInfo =  {
        width = 0,
        height= 0,
    };
end

--锟斤拷始锟斤拷锟斤拷锟斤拷
function _CGameSceneControl:Init(transform,uiTransform)

    --self._soundCtrl:Init(transform);
    local UnderWorld    = transform:Find("UnderWorld");
    self.transform      = transform;
    self._uiTransform   = uiTransform;
    self._bgTrans       = UnderWorld:Find("Bg");
    self._sceneBg       = self._bgTrans:GetComponent("SpriteRenderer");
    self._sceneBg.material.shader = UnityEngine.Shader.Find("Sprites/Default");
    self._underWorldTrans= UnderWorld;
    self._worldTrans    = transform:Find("World");
    self._wordZ         = self._worldTrans.localPosition.z;
    self._overWorldTrans= transform:Find("OverWorld");
    self._uiWorldTrans  = transform:Find("UIWorld");
    self._uiContentTrans = transform:Find("UIContainer");

    local maskBg         = self._overWorldTrans:Find("MaskBg");
    self._switchScene    = maskBg:Find("SwitchScene");
    self._effectTrans    = self._overWorldTrans:Find("EffectsPool");
    self._gameFishControl:Init(self._worldTrans:Find("FishesPool"));
				--logError("***********************-1")
    self._gameBulletControl:Init(self._uiWorldTrans:Find("BulletsPool"),self._worldTrans:Find("BulletCollidersPool"),self._uiWorldTrans:Find("NetsPool"));
				--logError("***********************0")
    self._gamePlayersControl:Init(uiTransform);
		--logError("***********************1")
    local playersTransform = self._gamePlayersControl:GetPlayersTransform();
    local uiPartTransform = self._gamePlayersControl:GetUITransform();
    local switchSceneFront = playersTransform:Find("SwitchSceneFront");
    self._switchSceneControl:Init(self._switchScene,switchSceneFront);

    --boss锟斤拷袭
    self._bossComeAnimator = uiPartTransform:Find("BossFishGroup");
    self._bossTitleName    = self._bossComeAnimator:Find("TitleName");
    self._bossTitleImage = self._bossTitleName:GetComponent(ImageClassType);
    self._bossComeName = G_GlobalGame_goFactory:getUICommonSprite("zi_boss");
    self._bossBattleOverName = G_GlobalGame_goFactory:getUICommonSprite("zi_jiesu");

    --锟斤拷锟斤拷戏锟斤拷锟斤拷锟斤拷锟街拷系谋锟斤拷锟?
    self._maskBg         = maskBg:Find("Bg");
    self._maskBgImage    = self._maskBg:GetComponent(ImageClassType);
    self._isMaskFadeOut  = false;
    self._maskAlpha      = 1;

    --效锟斤拷锟斤拷锟斤拷
    self._gameEffectControl:Init(self._effectTrans);
		--logError("***********************2")
    --self:_autoSize();
    --锟斤拷水锟斤拷
    --[[
    self.bgWater            = GameObject.New();
    self.bgWater.name       = "Water";
    self.bgWater.transform:SetParent(self._bgTrans);
    self.bgWater.transform.localScale = Vector3.New(1.3,1.3,1);
    self.bgWater.transform.localPosition = Vector3.New(0,0,0);
    self.bgWater.transform.localRotation = Quaternion.Euler(0,0,0);
    self.waterAnima = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self.bgWater,G_GlobalGame.Enum_AnimateType.Water);
    self.waterAnima:PlayAlways();
    --]]

    --锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.NotifyEnterGame,self,self.OnEnterGameSuccess);
    --注锟斤拷锟铰硷拷
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.CreateFish,self,self.OnCreateFish);
    --锟姐潮
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.SwitchScene,self,self.SwitchScene);
    --锟斤拷锟斤拷幕
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.NotifyShakeScreen,self,self.ShakeScreen);
    --锟斤拷锟铰硷拷锟斤拷锟斤拷戏
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.ReloadGame,self,self.OnReloadGame);
    --通知UI  boss战锟斤拷锟斤拷
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.NotifyUIBossBattleOver,self,self.OnBossBattleOver);
    
	--logError("***********************3")
    --注锟斤拷锟街碉拷锟?
    G_GlobalGame:SetKeyHandler(G_GlobalGame_KeyValue.GetScenePixelSize,handler(self,self.OnKVScenePixelSize));
    G_GlobalGame:SetKeyHandler(G_GlobalGame_KeyValue.GetIsInSwitchScene,handler(self,self.IsInSwitchScene));
    G_GlobalGame:SetKeyHandler(G_GlobalGame_KeyValue.GetRealSceneSize,handler(self,self.OnKVRealSceneRectInWorld));
    self:_initArea();
end


function _CGameSceneControl:_autoSize()
    --
    local scrrate = G_GlobalGame.ConstantValue.RealScreenWidth /G_GlobalGame.ConstantValue.RealScreenHeight;
    local matchScreenRate = 16/10;
    if G_GlobalGame.ConstantValue.IsLandscape then
        matchScreenRate = 16/10;
        if scrrate<matchScreenRate then
            V_Vector3_Value.x = 1;
            V_Vector3_Value.y = matchScreenRate/scrrate;
            V_Vector3_Value.z = 1;
            --self._bgTrans.localScale = self._bgTrans.localScale:SetScale(V_Vector3_Value);
            --self._switchScene.localScale = self._switchScene.localScale:SetScale(V_Vector3_Value);
			self._bgTrans.localScale = V_Vector3_Value
            self._switchScene.localScale = V_Vector3_Value
        else
            V_Vector3_Value.x = scrrate/matchScreenRate;
            V_Vector3_Value.y = 1;
            V_Vector3_Value.z = 1;
           -- self._bgTrans.localScale = self._bgTrans.localScale:SetScale(V_Vector3_Value);
           -- self._switchScene.localScale = self._switchScene.localScale:SetScale(V_Vector3_Value);
					self._bgTrans.localScale = V_Vector3_Value
            self._switchScene.localScale = V_Vector3_Value
        end
    elseif G_GlobalGame.ConstantValue.IsPortrait then
        matchScreenRate = 16/9;
        if scrrate<matchScreenRate then
            V_Vector3_Value.x = 1;
            V_Vector3_Value.y = matchScreenRate/scrrate;
            V_Vector3_Value.z = 1;
          --  self._bgTrans.localScale = self._bgTrans.localScale:SetScale(V_Vector3_Value);
           -- self._switchScene.localScale = self._switchScene.localScale:SetScale(V_Vector3_Value);
					self._bgTrans.localScale = V_Vector3_Value
            self._switchScene.localScale = V_Vector3_Value
        else
            V_Vector3_Value.x = scrrate/matchScreenRate;
            V_Vector3_Value.y = 1;
            V_Vector3_Value.z = 1;
            --self._bgTrans.localScale = self._bgTrans.localScale:SetScale(V_Vector3_Value);
           -- self._switchScene.localScale = self._switchScene.localScale:SetScale(V_Vector3_Value);
					self._bgTrans.localScale = V_Vector3_Value
            self._switchScene.localScale = V_Vector3_Value
        end
    end
end

function _CGameSceneControl:_initArea()
    local border = self._uiTransform:Find("Border");
    self.bottomBorder = border:Find("BottomBorder");
    self.topBorder    = border:Find("TopBorder");
    self.leftBorder   = border:Find("LeftBorder");
    self.rightBorder  = border:Find("RightBorder");

    local alignView = self.bottomBorder.gameObject:AddComponent(AlignViewExClassType);
    alignView:setAlign(Enum_AlignViewEx.Align_Bottom);
    alignView.isKeepPos = true;

    alignView = self.topBorder.gameObject:AddComponent(AlignViewExClassType);
    alignView:setAlign(Enum_AlignViewEx.Align_Up);
    alignView.isKeepPos = true;

    alignView = self.leftBorder.gameObject:AddComponent(AlignViewExClassType);
    alignView:setAlign(Enum_AlignViewEx.Align_Left);
    alignView.isKeepPos = true;

    alignView = self.rightBorder.gameObject:AddComponent(AlignViewExClassType);
    alignView:setAlign(Enum_AlignViewEx.Align_Right);
    alignView.isKeepPos = true;

end


--锟斤拷锟斤拷锟斤拷
function _CGameSceneControl:OnCreateFish(_eventId,_eventData)
    if _eventData.fishKind == G_GlobalGame_Enum_FishType.FISH_KIND_21 then
        _eventData = clone(_eventData);
        local PlayBossComing = function()
            if IsNil(self._bossComeAnimator) then
                return ;
            end
            self._bossComeAnimator.gameObject:SetActive(true);
            self._bossTitleImage.sprite = self._bossComeName;
            self._bossTitleImage:SetNativeSize();
            coroutine.wait(0.6);
            if G_GlobalGame.isQuitGame then
                return ;
            end
            local playSound = function()
                --锟斤拷锟斤拷锟斤拷
                G_GlobalGame:PlayEffect(G_GlobalGame_SoundDefine.SuperArm);
            end
            --锟斤拷锟脚撅拷锟斤拷锟斤拷
            playSound();
            G_GlobalGame._timer:FixUpdateTimes(playSound,0,1,3);
            coroutine.wait(4);
            if G_GlobalGame.isQuitGame then
                return ;
            end
            local wz = self._wordZ;
            local count = _eventData.initCount;
            local point = _eventData.point;
            --锟杰达拷锟斤拷锟斤拷时锟斤拷
            for i=1,count do
                local pt = point[i];
                pt.z = pt.z - wz;
            end
            local fish = self._gameFishControl:CreateFish(_eventData.fishKind,_eventData.fishId,_eventData);

            self._bossComeAnimator.gameObject:SetActive(false);
        end
        coroutine.start(PlayBossComing);    
    else
        local wz = self._wordZ;
        local count = _eventData.initCount;
        local point = _eventData.point;
        --锟杰达拷锟斤拷锟斤拷时锟斤拷
        for i=1,count do
            local pt = point[i];
            pt.z = pt.z - wz;
        end
        local fish = self._gameFishControl:CreateFish(_eventData.fishKind,_eventData.fishId,_eventData);
    end

end

--boss战锟斤拷锟斤拷
function _CGameSceneControl:OnBossBattleOver()
    --self:BossModeOver();
end

--BOSS战锟斤拷锟斤拷锟斤拷
function _CGameSceneControl:BossModeOver()
    local PlayBossOver = function()
        self._bossComeAnimator.gameObject:SetActive(true);
        self._bossTitleImage.sprite = self._bossBattleOverName;
        self._bossTitleImage:SetNativeSize();
        coroutine.wait(4.6);
        if G_GlobalGame.isQuitGame then
            return ;
        end
        self._bossComeAnimator.gameObject:SetActive(false);
    end
    coroutine.start(PlayBossOver);
end

--锟叫伙拷锟斤拷锟斤拷
function _CGameSceneControl:SwitchScene(_eventId,_data)
    --去锟斤拷锟斤拷锟叫э拷锟?
    self:Resume();
    --锟斤拷锟斤拷俚锟斤拷瞥锟斤拷锟侥?
    self._gameFishControl:FishQuickMoveOutScreen();

--    --锟斤拷锟斤拷锟叫伙拷锟斤拷锟斤拷
--    G_GlobalGame:PlayBgSound(G_GlobalGame.SoundDefine.ChangeScene);
    

    --锟斤拷始锟叫伙拷锟斤拷锟斤拷
    self._switchSceneControl:StartSwitchScene(_data);
    self._gameFishControl:StopRefreshFish();
    self._gamePlayersControl:PauseCreateBullet();

    --锟斤拷锟斤拷锟斤拷锟斤拷拥锟?
    self._gameBulletControl:ClearAllBullets();

    --
    self:StopShakeScreen();

    --锟斤拷锟斤拷锟斤拷锟斤拷锟襟，匡拷始锟斤拷锟斤拷
    --self._switchSceneControl:Start();
end

--锟斤拷锟脚猴拷锟剿匡拷始
function _CGameSceneControl:StartPlayHaiLang()
    self._isNeedClearFish = true;
    self.fishGroup = nil;
end

--锟斤拷锟斤拷愠憋拷锟绞?
function _CGameSceneControl:checkSwitchSceneBegin(_dt)
    if self._switchSceneControl:IsSwitch() then
        if self._switchSceneControl:IsStart() then
            if self._isNeedClearFish and self._gameFishControl:ScreenFishCount()==0 then
                self:ResumeNormal();
            end
        end
    end
end


function _CGameSceneControl:ResumeNormal()
    --锟斤拷锟斤拷锟斤拷锟斤拷锟?
    self._gameFishControl:ClearFishes();
    --锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷
    self._isCanShakeScreen = false;
    --
    self:StopShakeScreen();

    --锟斤拷始锟斤拷锟斤拷
    local _data = self._switchSceneControl:FishGroupData();

    --锟斤拷锟斤拷锟届步锟斤拷锟斤拷
    --锟斤拷锟斤拷锟姐潮
    self.fishGroup = self._gameFishControl:CreateFishGroup(_data);

    self._isNeedClearFish = false;
end

--锟叫伙拷锟斤拷锟斤拷锟斤拷锟?
function _CGameSceneControl:SwitchSceneOver(_sprite,_data)
    self._sceneBg.sprite = _sprite;
    self._bgTrans.localPosition = C_Vector3_Zero;
    --self._gameFishControl:StartRefreshFish();
    --锟街革拷锟狡讹拷
    self:Resume();

    --锟斤拷锟斤拷悖拷指锟斤拷拥锟?
    --self._gameFishControl:ClearFishes();
    self._gamePlayersControl:ResumeCreateBullet();
    
    if self.fishGroup==nil then
        self:ResumeNormal();
    end

    --锟斤拷式锟斤拷始
    self.fishGroup:RealStart();

    ----锟斤拷锟斤拷锟姐潮
    --self._gameFishControl:CreateFishGroup(_data);

    --锟斤拷锟脚憋拷锟斤拷锟斤拷锟斤拷
    self:PlayBgSound();

    --锟斤拷锟斤拷锟斤拷锟斤拷
    self._isCanShakeScreen = true;

    --锟斤拷锟斤拷锟斤拷锟斤拷锟叫?
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.NotifyClearAllEffects);
end

--锟斤拷锟斤拷
function _CGameSceneControl:Pause()
    --锟姐潮锟斤拷之前锟斤拷锟斤拷锟杰讹拷锟斤拷
    if self:IsInSwitchScene() then
        return ;
    end
    self._gameFishControl:Pause();
    self._isPauseScreen = true;
    self._pauseTime     = G_GlobalGame_GameConfig_SceneConfig.pauseScreenTime;

    --锟斤拷锟斤拷效锟斤拷
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.NotifyCreatePauseScrn,{type = G_GlobalGame_Enum_EffectType.PauseScreen, position = Vector3.New(0,0,0)});
end

--锟斤拷转锟斤拷锟斤拷
function _CGameSceneControl:Rotation()
    V_Vector3_Value.x = 0;
    V_Vector3_Value.y = 0;
    V_Vector3_Value.z = 180;
    self._belowUITrans.localEulerAngles = V_Vector3_Value;
end

--锟斤拷锟斤拷示maskBg
function _CGameSceneControl:DisappearMaskBg()
    self._maskBg.gameObject:SetActive(false);
end

--锟斤拷锟斤拷锟斤拷锟斤拷
function _CGameSceneControl:FadeOutMaskBg()
    self._isMaskFadeOut = true;
    self._maskAlpha     = 1;
end

--锟斤拷锟斤拷锟斤拷锟斤拷
function _CGameSceneControl:_controlFadeOutMaskBg(_dt)
    if self._isMaskFadeOut then
        self._maskAlpha = self._maskAlpha - _dt/1.5;
        if self._maskAlpha<=0 then
            self._maskAlpha = 0;
            self._isMaskFadeOut = false;
            self._maskBg.gameObject:SetActive(false);
        end
        self._maskBgImage.color = COLORNEW(1,1,1,self._maskAlpha);
    end
end

--锟街革拷
function _CGameSceneControl:Resume()
    self._gameFishControl:Resume();
    self._isPauseScreen = false;
    self._pauseTime = 0;

    --删锟斤拷锟斤拷锟斤拷效锟斤拷
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.NotifyClearEffectType,{type = G_GlobalGame_Enum_EffectType.PauseScreen});
end

--锟斤拷锟狡讹拷锟斤拷
function _CGameSceneControl:_controlPauseScreen(_dt)
    if self._isPauseScreen then
        self._pauseTime = self._pauseTime - _dt;
        if self._pauseTime<0 then
            self:Resume();
        end
    end
end

--锟角凤拷锟斤拷锟斤拷锟叫伙拷锟姐潮
function _CGameSceneControl:IsSwitchingScene()
    return self._switchSceneControl:IsSwitch();
end

--每帧执锟斤拷
function _CGameSceneControl:Update(_dt)
    for i=1,self._maxUpdateCount do
        self._updateRecords[i] = self._updateRecords[i] + _dt;
        if math.fmod(self._updateIndex,i)==0 then
            self._updateIsExecute[i] = true;
        else
            self._updateIsExecute[i] = false;
        end
    end
    local realDt = self._updateRecords[self._updateIndex];

    --锟斤拷幕锟斤拷锟斤拷锟斤拷锟斤拷
    self:_controlFadeOutMaskBg(_dt);
    --error("U1");
    --锟斤拷戏效锟斤拷锟斤拷锟斤拷
    self._gameEffectControl:Update(_dt);
    --锟叫伙拷锟斤拷锟斤拷锟竭硷拷
    self._switchSceneControl:Update(_dt);
    if self._updateIsExecute[1] then
        --锟斤拷锟竭硷拷
        self._gameFishControl:Update(self._updateRecords[1]);
    end
    if self._updateIsExecute[1] then
        --锟斤拷锟揭碉拷锟斤拷呒锟?
        self._gamePlayersControl:Update(self._updateRecords[1]);
    end
    --error("U5");
    --锟接碉拷锟竭硷拷
    self._gameBulletControl:Update(_dt,
            self._switchSceneControl:IsSwitch() and self._switchSceneControl:IsStart());
    if self._updateIsExecute[self._maxUpdateCount] then
        --锟斤拷锟狡讹拷锟斤拷
        self:_controlPauseScreen(realDt);
    end
    --锟斤拷锟斤拷锟斤拷锟斤拷
    self:_controlShakeScreen(_dt);

--    if self._updateIsExecute[6] then
--        --锟斤拷锟斤拷愠憋拷锟绞?
--        self:checkSwitchSceneBegin(self._updateRecords[6]);
--    end
    self:checkSwitchSceneBegin(_dt);

    for i=1,self._updateIndex do
        if self._updateIsExecute[i] then
            self._updateRecords[i] = 0;
        end
    end
    self._updateIndex = self._updateIndex + 1;
    if self._updateIndex>self._maxUpdateCount then
        self._updateIndex = 1;
    end
end

function _CGameSceneControl:_controlShakeScreen(_dt)
    if self._shakeTime>0 then
        self._shakeTime = self._shakeTime - _dt;
        if self._shakeTime>0 then
            self._shakeIndex = self._shakeIndex + 1;
            if self._shakeIndex>4 then
                self._shakeIndex = 1;
            end
            local fudu  = math.random(10,18);
            if self._shakeIndex==1 then
                V_Vector3_Value.x = 0;
                V_Vector3_Value.y = fudu;
                V_Vector3_Value.z = 0;
                self._bgTrans.localPosition = V_Vector3_Value;
            elseif self._shakeIndex==2 then
                V_Vector3_Value.x = fudu;
                V_Vector3_Value.y = 0;
                V_Vector3_Value.z = 0;
                self._bgTrans.localPosition = V_Vector3_Value;
            elseif self._shakeIndex==3 then
                V_Vector3_Value.x = 0;
                V_Vector3_Value.y = -fudu;
                V_Vector3_Value.z = 0;
                self._bgTrans.localPosition = V_Vector3_Value; 
            elseif self._shakeIndex==4 then  
                V_Vector3_Value.x = -fudu;
                V_Vector3_Value.y = 0;
                V_Vector3_Value.z = 0;
                self._bgTrans.localPosition = V_Vector3_Value;
            end
        else
            self:StopShakeScreen();
        end
    end
end

--锟斤拷取锟斤拷锟斤拷锟斤拷小
function _CGameSceneControl:GetSceneSize()
    return 
end


--锟斤拷取锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟叫?
function _CGameSceneControl:GetSceneRectInWorld(isEffectBySwitch)
    isEffectBySwitch = isEffectBySwitch or false;
    local sceneHeight = G_GlobalGame.ConstantValue.RealScreenHeight;
    local sceneWidth  = G_GlobalGame.ConstantValue.RealScreenWidth;
    local dis = sceneHeight*1.0/sceneWidth*55;
    if isEffectBySwitch then
        if self._switchSceneControl:IsSwitch() then
            --锟斤拷锟斤拷锟叫伙拷锟斤拷锟斤拷
            local x1 = self._switchSceneControl:MoveX1();
            local x2 = self._switchSceneControl:MoveX2();
            local dis = self.rightBorder.localPosition.x - self.leftBorder.localPosition.x;
            x1 = sceneHeight *1.0 *(x1-self.leftBorder.localPosition.x)/dis;
            x2 = sceneHeight *1.0 *(x2-self.leftBorder.localPosition.x)/dis;
            if self._gamePlayersControl:IsRotation() then
                return x2-dis,self._borders.y1-dis,x1+dis,self._borders.y2+dis;
            else
                return x1-dis,self._borders.y1-dis,x2+dis,self._borders.y2+dis;
            end
        else
            --return self.leftBorder.position.x-30,self.bottomBorder.position.y-30,self.rightBorder.position.x+30,self.topBorder.position.y+30;
            return self._borders.x1-dis,self._borders.y1-dis,self._borders.x2+dis,self._borders.y2+dis;
        end
    else
        --return self.leftBorder.position.x-30,self.bottomBorder.position.y-30,self.rightBorder.position.x+30,self.topBorder.position.y+30;
        --return -30,self.bottomBorder.position.y-30,Screen.width+30,self.topBorder.position.y+30;
        return self._borders.x1-dis,self._borders.y1-dis,self._borders.x2+dis,self._borders.y2+dis;
    end
end

--锟斤拷实锟侥达拷小
function _CGameSceneControl:GetRealSceneRectInWorld()
    --return 0,self.bottomBorder.position.y,Screen.width,self.topBorder.position.y;
    return self._borders.x1,self._borders.y1,self._borders.x2,self._borders.y2;
    --return self.leftBorder.position.x,self.bottomBorder.position.y,self.rightBorder.position.x,self.topBorder.position.y;
end

--锟斤拷锟斤拷锟斤拷锟节碉拷实锟绞达拷小
function _CGameSceneControl:OnKVRealSceneRectInWorld()
    return self:GetRealSceneRectInWorld();
end

--锟角凤拷锟斤拷锟斤拷戏锟斤拷锟斤拷锟斤拷
function _CGameSceneControl:IsInGameScene(_point)

end

--锟角凤拷锟斤拷锟叫伙拷锟姐潮锟斤拷锟斤拷锟斤拷
function _CGameSceneControl:IsInSwitchScene()
    return self._switchSceneControl:IsSwitch();
end

--锟斤拷取锟斤拷应锟斤拷锟斤拷
function _CGameSceneControl:GetFish(_fishId)
    return self._gameFishControl:GetFish(_fishId);
end

--锟矫碉拷锟斤拷锟斤拷锟斤拷锟截达拷小
function _CGameSceneControl:OnKVScenePixelSize()
    return C_CLIENT_SCENE_WIDTH,C_CLIENT_SCENE_HEIGHT;
end

--锟斤拷锟斤拷锟斤拷幕
function _CGameSceneControl:ShakeScreen()
    if self._isCanShakeScreen then
        self._shakeTime     = 0.8;
    end
end

--停止锟斤拷锟斤拷幕
function _CGameSceneControl:StopShakeScreen()
    self._shakeTime = 0;
    self._bgTrans.localPosition = C_Vector3_Zero;
    self._shakeIndex = 1;
end

--锟斤拷锟铰硷拷锟斤拷锟斤拷戏
function _CGameSceneControl:OnReloadGame()
    --锟斤拷锟斤拷锟斤拷锟斤拷系锟斤拷锟?
    self._gameFishControl:ClearFishes();
    self._gameFishControl:StartRefreshFish();
    self._gameBulletControl:ClearAllBullets();
    --锟斤拷锟斤拷锟斤拷锟斤拷锟叫?
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.NotifyClearAllEffects);
    --锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷
    self._gamePlayersControl:ClearAllPlayers();
end

--锟斤拷锟截成癸拷
function _CGameSceneControl:OnEnterGameSuccess()
    if self._curBgIndex == nil  then
        --只锟斤拷
        self:PlayBgSound();
        local pos1 = G_GlobalGame:SwitchWorldPosToScreenPosByUICamera(self.bottomBorder.position);
        local pos2 = G_GlobalGame:SwitchWorldPosToScreenPosByUICamera(self.topBorder.position);
        local pos3 = G_GlobalGame:SwitchWorldPosToScreenPosByUICamera(self.leftBorder.position);
        local pos4 = G_GlobalGame:SwitchWorldPosToScreenPosByUICamera(self.rightBorder.position);
        --0,self.bottomBorder.position.y,Screen.width,self.topBorder.position.y;
--        self._borders.x1 = pos3.x;
--        self._borders.y1 = pos1.y;
--        self._borders.x2 = pos4.x;
--        self._borders.y2 = pos2.y;
        if G_GlobalGame.ConstantValue.IsLandscape then --锟斤拷锟斤拷
            self._borders.x1 = pos3.x;
            self._borders.y1 = pos1.y;
            self._borders.x2 = pos4.x;
            self._borders.y2 = pos2.y;
        elseif G_GlobalGame.ConstantValue.IsPortrait then --锟斤拷锟斤拷
--            self._borders.x1 = pos4.y;
--            self._borders.y1 = pos1.x;
--            self._borders.x2 = pos3.y;
--            self._borders.y2 = pos2.x;    
            self._borders.x1 = pos1.x;
            self._borders.y1 = pos4.y;
            self._borders.x2 = pos2.x;
            self._borders.y2 = pos3.y;      
        end

        --error("x1:" .. self._borders.x1 ..",y1:" .. self._borders.y1 ..",x2:" .. self._borders.x2 ..",y2:" .. self._borders.y2);
--        self._borders.x1 = 0;
--        self._borders.y1 = 0;
--        self._borders.x2 = Screen.height;
--        self._borders.y2 = Screen.width;
        --error("x1:" .. self._borders.x1 ..",y1:" .. self._borders.y1 ..",x2:" .. self._borders.x2 ..",y2:" .. self._borders.y2);
    end
end

function _CGameSceneControl:PlayBgSound()
    --锟斤拷锟缴伙拷锟斤拷
    if self._bgIndexVec:size()==0  then
        return ;
    end
    local index= math.random(1,self._bgIndexVec:size());
    local bgIndex = self._bgIndexVec:pop(index);
    if self._curBgIndex then
        --锟斤拷锟斤拷之前锟斤拷锟脚的憋拷锟斤拷锟斤拷锟斤拷
        self._bgIndexVec:push_back(self._curBgIndex);
    end
    --锟斤拷锟脚憋拷锟斤拷锟斤拷锟斤拷
    G_GlobalGame:PlayBgSound(bgIndex);
    --锟斤拷前锟侥憋拷锟斤拷锟斤拷锟斤拷
    self._curBgIndex = bgIndex;
end

function _CGameSceneControl:Unload()
    self._gamePlayersControl:Unload();
end


return _CGameSceneControl;