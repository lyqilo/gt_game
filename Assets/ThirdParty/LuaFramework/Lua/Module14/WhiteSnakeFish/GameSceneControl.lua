

local _CGameFishControl = GameRequire("GameFishControl");
local _CGameBulletControl = GameRequire("GameBulletControl");
local _CPlayersControl  = GameRequire("PlayerControl");
local _CEffectControl  = GameRequire("EffectControl");

local CAtlasNumber = GameRequire("AtlasNumber");

local _CSwitchSceneControl = class("_CSwitchSceneControl");

local C_SERVER_SCENE_WIDTH = 1366
local C_SERVER_SCENE_HEIGHT= 768;

local C_CLIENT_SCENE_WIDTH = 1334;
local C_CLIENT_SCENE_HEIGHT = 750;


local LimiteBorderDis  = 30;

function _CSwitchSceneControl:ctor(_sceneControl)
    self.transform  = nil;
    self.endHandler = nil;
    self.switchActionTrans  = nil;
    self.switchSceneBg      = nil;
    self.switchSprite       = nil;
    if G_GlobalGame.RunningPlatform == RuntimePlatform.AndroidPlayer then
        self.switchBgMoveDis    = 1500;
        self.switchWaveMoveDis  = 1700;
        self.switchMoveSpeed    = 265;
    else
        self.switchBgMoveDis    = 1500;
        self.switchWaveMoveDis  = 1780;
        self.switchMoveSpeed    = 260;
    end
    
    self.waveBeginPosition  = nil;
    self.switchMoveX        = 0;
    self.isSwitch           = false;
    self.sceneControl       = _sceneControl;
    self.fishGroupData      = nil;
    self.isStart            = false;

end

function _CSwitchSceneControl:Init(transform)
    self.transform          = transform;
    self.gameObject         = transform.gameObject;
    self.switchActionTrans  = transform:Find("SwitchActions");
    self.switchSceneBgs     = {};
    self.switchSprites      = {};
    self.bgIndex            = 1;
    self.bgCreatorVec       = vector:new();
    self.switchBg           = transform:Find("Bg");
    local childCount        = self.switchBg.childCount;
    for i=1,childCount do
        self.switchSceneBgs[i] = self.switchBg:GetChild(i-1);
        self.switchSprites[i]  = self.switchSceneBgs[i]:GetComponent("Image").sprite;
        if i~=self.bgIndex then
            self.bgCreatorVec:push_back(i);
        end
    end
    self.switchBorderTrans  = GameObject.New().transform;
    self.switchBorderTrans:SetParent(self.switchBg);
    self.switchBorderTrans.gameObject.name = "SwitchSceneBorder";
    self.switchBorderTrans.localPosition = Vector3.New(LimiteBorderDis,0,0);

    self.switchSceneBg      = transform:Find("SwitchBg");
    self.switchSprite       = beforeSprite;
    self.waveBeginPosition  = self.switchActionTrans.localPosition;

    G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self.switchActionTrans.gameObject,G_GlobalGame.Enum_AnimateType.Wave);
    self.switchAction       = self.switchActionTrans:GetComponent("ImageAnima");
    self.switchAction.fSep  = G_GlobalGame.GameConfig.SceneConfig.switchSceneInterval;
    self.switchAction.enabled = false;
    self.switchActionImage  = self.switchActionTrans:GetComponent("Image");
    self.switchActionImage.sprite = self.switchAction.lSprites[0];
    self.switchFrameRunTime = 0;
    self.switchFrame        = 0;

    self.gameObject:SetActive(false);
    self.isSwitch           = false;
    self.isStart            = false;


end


function _CSwitchSceneControl:SetEndHandler(_handler)
    self.endHandler  = _handler;
end

function _CSwitchSceneControl:StartSwitchScene(_fishGroupData)
    self.gameObject:SetActive(true);
    self.transform.localPosition            = Vector3.zero;
    self.switchActionTrans.localPosition    = self.waveBeginPosition;
    self.switchMoveX    = 0;
    --self.switchAction:PlayAlways();
    self.switchActionImage.sprite = self.switchAction.lSprites[0];
    self.switchActionImage.enabled = true;
    self.switchFrameRunTime = 0;
    self.switchFrame = 0;
    self.frameCount = self.switchAction.lSprites.Count;
    self.isSwitch = true;

    local index = math.random(1,self.bgCreatorVec:size());
    local curIndex = self.bgCreatorVec:pop(index);
    self.switchSceneBgs[self.bgIndex].gameObject:SetActive(false);
    self.bgCreatorVec:push_back(self.bgIndex);
    self.bgIndex = curIndex;
    self.switchSprite = self.switchSprites[self.bgIndex];
    self.switchSceneBgs[self.bgIndex].gameObject:SetActive(true);
    self.fishGroupData = _fishGroupData;
    self.isStart = false;
end

function _CSwitchSceneControl:Start()
    self.isStart = true;
    return self.fishGroupData;
end

function _CSwitchSceneControl:Update(_dt)
    if not self.isSwitch then
        return ;
    end
    if not self.isStart then
        return;
    end
    self.switchFrameRunTime = self.switchFrameRunTime + _dt;
    if self.switchFrameRunTime>self.switchAction.fSep then
        self.switchFrameRunTime = self.switchFrameRunTime - self.switchAction.fSep;
        self.switchFrame = self.switchFrame + 1;
        if self.switchFrame>=self.frameCount then
            self.switchFrame = 0;
        end
        self.switchActionImage.sprite = self.switchAction.lSprites[self.switchFrame];
    end

    self.switchMoveX = self.switchMoveX + self.switchMoveSpeed * _dt;
    if self.switchMoveX>=self.switchWaveMoveDis then
        self.endHandler(self.switchSprite,self.fishGroupData);
        self.gameObject:SetActive(false);
        self.isSwitch = false;
    else
        if self.switchMoveX>=self.switchBgMoveDis then
            self.transform.localPosition = Vector3.New(-self.switchBgMoveDis,0,0);
            self.switchActionTrans.localPosition = self.waveBeginPosition + Vector3.New(self.switchBgMoveDis-self.switchMoveX,0,0);
        else
            self.transform.localPosition = Vector3.New(-self.switchMoveX,0,0);
        end
    end
end

function _CSwitchSceneControl:MoveX()
    return self.switchBorderTrans.position.x;

end

function _CSwitchSceneControl:IsSwitch()
    return self.isSwitch;
end

function _CSwitchSceneControl:IsStart()
    return self.isStart;
end

local _CGameSceneControl = class("_CGameSceneControl");


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
    self._isPauseScreen     = false;
    self._pauseTime         = 0;
    self._bgIndexVec        = vector:new();
    self._bgIndexVec:push_back(G_GlobalGame.SoundDefine.BG1);
    self._bgIndexVec:push_back(G_GlobalGame.SoundDefine.BG2);
    self._bgIndexVec:push_back(G_GlobalGame.SoundDefine.BG3);
    self._bgIndexVec:push_back(G_GlobalGame.SoundDefine.BG4);
    self._isCanShakeScreen  = true;
    self._shakeTime        = 0;
    self._shakeIndex       = 1;
end


function _CGameSceneControl:Init(transform)

    local GOContainer_BelowUI = transform:Find("GOContainer_BelowUI");
    self.transform = transform;

    self:_initArea();

    self._bgTrans  = GOContainer_BelowUI:Find("Bg");
    self._sceneBg  = self._bgTrans:GetComponent("Image");
    self._belowUITrans = GOContainer_BelowUI;
    self._onUITrans    = transform:Find("GOContainer_OnUI");
    self._uiContentTrans = transform:Find("UIContent");
    self._cachePoolTrans = transform:Find("CachePool");
    self._switchScene    = GOContainer_BelowUI:Find("SwitchScene");
    self._effectTrans    = GOContainer_BelowUI:Find("BombEffectPool");
    self._gameFishControl:Init(GOContainer_BelowUI:Find("FishesPool"));
    self._gameBulletControl:Init(GOContainer_BelowUI:Find("BulletsPool"));
    self._switchSceneControl:Init(self._switchScene);
    self._gamePlayersControl:Init(self._uiContentTrans);

    local maskBg = transform:Find("MaskBg");
    self._maskBg         = maskBg:Find("Bg");
    self._maskBgImage    = self._maskBg:GetComponent("Image");
    self._isMaskFadeOut  = false;
    self._maskAlpha      = 1;

    --Ч??????
    self._gameEffectControl:Init(self._effectTrans);

    --
    self:_autoSize();

    --?????
    self.bgWater            = GameObject.New();
    self.bgWater.name       = "Water";
    self.bgWater.transform:SetParent(self._bgTrans);
    self.bgWater.transform.localScale = Vector3.New(1.3,1.3,1);
    self.bgWater.transform.localPosition = Vector3.New(0,0,0);
    self.bgWater.transform.localRotation = Quaternion.Euler(0,0,0);
    self.waterAnima = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self.bgWater,G_GlobalGame.Enum_AnimateType.Water);
    self.waterAnima:PlayAlways();

    --??????????
    G_GlobalGame:RegEventByStringKey("NotifyEnterGame",self,self.OnEnterGameSuccess);
    --??????
    G_GlobalGame:RegEventByStringKey("CreateFish",self,self.OnCreateFish);
    --??
    G_GlobalGame:RegEventByStringKey("SwitchScene",self,self.SwitchScene);
    --?????
    G_GlobalGame:RegEventByStringKey("NotifyShakeScreen",self,self.ShakeScreen);
    --??????????
    G_GlobalGame:RegEventByStringKey("ReloadGame",self,self.OnReloadGame);

    --???????
    G_GlobalGame:SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetScenePixelSize,handler(self,self.OnKVScenePixelSize));
    G_GlobalGame:SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetIsInSwitchScene,handler(self,self.IsInSwitchScene));
    G_GlobalGame:SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetRealSceneSize,handler(self,self.OnKVRealSceneRectInWorld));

end


function _CGameSceneControl:AsyncInit(transform,runtime,data)
    self._asyncStep = self._asyncStep or 1;
    if self._asyncStep == 1 then
        local GOContainer_BelowUI = transform:Find("GOContainer_BelowUI");
        self.transform = transform;

        --?????????
        self:_initArea();

        self._bgTrans  = GOContainer_BelowUI:Find("Bg");
        self._sceneBg  = self._bgTrans:GetComponent("Image");
        self._belowUITrans = GOContainer_BelowUI;
        self._onUITrans    = transform:Find("GOContainer_OnUI");
        self._uiContentTrans = transform:Find("UIContent");
        self._cachePoolTrans = transform:Find("CachePool");
        self._switchScene    = GOContainer_BelowUI:Find("SwitchScene");
        self._effectTrans    = GOContainer_BelowUI:Find("BombEffectPool");
        self._asyncStep = self._asyncStep + 1;
    elseif self._asyncStep==2 then
        self._gameFishControl:Init(self._belowUITrans:Find("FishesPool"));
        self._gameBulletControl:Init(self._belowUITrans:Find("BulletsPool"));
        self._asyncStep = self._asyncStep + 1;
    elseif self._asyncStep==3 then
        self._switchSceneControl:Init(self._switchScene);
        self._asyncStep = self._asyncStep + 1;
    elseif self._asyncStep==4 then
        local ret = self._gamePlayersControl:AsyncInit(self._uiContentTrans);
        if ret then
            self._asyncStep = self._asyncStep + 1;
        end
    elseif self._asyncStep==5 then
        self._gameEffectControl:Init(self._effectTrans);

        local maskBg = self.transform:Find("MaskBg");
        self._maskBg         = maskBg:Find("Bg");
        self._maskBgImage    = self._maskBg:GetComponent("Image");
        self._isMaskFadeOut  = false;
        self._maskAlpha      = 1;

        self:_autoSize();


        self._asyncStep = self._asyncStep + 1;
    elseif self._asyncStep==6 then
        --?????
        self.bgWater            = GameObject.New();
        self.bgWater.name       = "Water";
        self.bgWater.transform:SetParent(self._bgTrans);
        self.bgWater.transform.localScale = Vector3.New(1,1,1);
        self.bgWater.transform.localPosition = Vector3.New(0,0,0);
        self.bgWater.transform.localRotation = Quaternion.Euler(0,0,0);
        self.waterAnima = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self.bgWater,G_GlobalGame.Enum_AnimateType.Water);
        self.waterAnima:PlayAlways();
        self._asyncStep = self._asyncStep + 1;
    elseif self._asyncStep==7 then
        --??????????
        G_GlobalGame:RegEventByStringKey("NotifyEnterGame",self,self.OnEnterGameSuccess);
        --??????
        G_GlobalGame:RegEventByStringKey("CreateFish",self,self.OnCreateFish);
        --??
        G_GlobalGame:RegEventByStringKey("SwitchScene",self,self.SwitchScene);
        --?????
        G_GlobalGame:RegEventByStringKey("NotifyShakeScreen",self,self.ShakeScreen);
        --??????????
        G_GlobalGame:RegEventByStringKey("ReloadGame",self,self.OnReloadGame);

        --???????
        G_GlobalGame:SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetScenePixelSize,handler(self,self.OnKVScenePixelSize));
        G_GlobalGame:SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetIsInSwitchScene,handler(self,self.IsInSwitchScene));
        G_GlobalGame:SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetRealSceneSize,handler(self,self.OnKVRealSceneRectInWorld));
        self._asyncStep = self._asyncStep + 1; 
        return true;    
    end
    return false;
end

--?????
function _CGameSceneControl:_autoSize()
    local scrrate = G_GlobalGame.ConstantValue.RealScreenWidth /G_GlobalGame.ConstantValue.RealScreenHeight;
    local matchScreenRate = 16/10;
    if G_GlobalGame.ConstantValue.IsLandscape then
        matchScreenRate = 16/10;
        if scrrate<matchScreenRate then
            self._bgTrans.localScale = Vector3.New(1,matchScreenRate/scrrate,1);
            self._switchScene.localScale = Vector3.New(1,matchScreenRate/scrrate,1); 
            self._maskBg.localScale =  Vector3.New(1,matchScreenRate/scrrate,1); 
        else
            self._bgTrans.localScale = Vector3.New(1.1,1,1);
            self._switchScene.localScale = Vector3.New(1.1,1,1);
            self._maskBg.localScale =  Vector3.New(1.1,1,1);  
        end
    elseif G_GlobalGame.ConstantValue.IsPortrait then
        matchScreenRate = 16/9;
        if scrrate<matchScreenRate then
            self._bgTrans.localScale = Vector3.New(1,matchScreenRate/scrrate,1);
            self._switchScene.localScale = Vector3.New(1,matchScreenRate/scrrate,1); 
            self._maskBg.localScale =  Vector3.New(1,matchScreenRate/scrrate,1); 
        else
            self._bgTrans.localScale = Vector3.New(1.1,1,1);
            self._switchScene.localScale = Vector3.New(1.1,1,1);
            self._maskBg.localScale =  Vector3.New(1.1,1,1);  
        end
    end
end


function _CGameSceneControl:_initArea()
    local AreaBorder = self.transform:Find("AreaBorder");
    self.topBorder = AreaBorder:Find("TopBorder");
    self.bottomBorder = AreaBorder:Find("Bottom");
    self.topLimiteBorder = GameObject.New();
    self.bottomLimiteBorder= GameObject.New();
    self.topLimiteBorderTrans = self.topLimiteBorder.transform;
    self.bottomLimiteBorderTrans = self.bottomLimiteBorder.transform;
    self.topLimiteBorderTrans:SetParent(self.topBorder);
    self.bottomLimiteBorderTrans:SetParent(self.bottomBorder);
    self.topLimiteBorderTrans.localPosition = Vector3.New(0,LimiteBorderDis,0);
    self.bottomLimiteBorderTrans.localPosition = Vector3.New(0,-LimiteBorderDis,0);
    self.topLimiteBorderTrans.localScale = Vector3.one;
    self.bottomLimiteBorderTrans.localScale = Vector3.one;
    self.topLimiteBorder.name="TopLimiteBorder";
    self.bottomLimiteBorder.name="BottomLimiteBorder";

    self.leftBorder = GameObject.New();
    self.rightBorder= GameObject.New();
    self.leftLimiteBorder = GameObject.New();
    self.rightLimiteBorder= GameObject.New();
    self.leftBorderTrans = self.leftBorder.transform;
    self.rightBorderTrans = self.rightBorder.transform;
    self.leftLimiteBorderTrans = self.leftLimiteBorder.transform;
    self.rightLimiteBorderTrans = self.rightLimiteBorder.transform;
    self.leftBorderTrans:SetParent(AreaBorder);
    self.leftBorderTrans.localPosition = Vector3.New(-C_CLIENT_SCENE_WIDTH/2,0,0);
    self.rightBorderTrans:SetParent(AreaBorder);
    self.rightBorderTrans.localPosition = Vector3.New(C_CLIENT_SCENE_WIDTH/2,0,0);
    self.leftLimiteBorderTrans:SetParent(AreaBorder);
    self.leftLimiteBorderTrans.localPosition = Vector3.New(-C_CLIENT_SCENE_WIDTH/2-LimiteBorderDis,0,0);
    self.rightLimiteBorderTrans:SetParent(AreaBorder);
    self.rightLimiteBorderTrans.localPosition = Vector3.New(C_CLIENT_SCENE_WIDTH/2+LimiteBorderDis,0,0);

    self.leftBorderTrans.localScale = Vector3.one;
    self.rightBorderTrans.localScale = Vector3.one;
    self.leftLimiteBorderTrans.localScale = Vector3.one;
    self.rightLimiteBorderTrans.localScale = Vector3.one;
    self.leftBorder.name="LeftBorder";
    self.rightBorder.name="RightBorder";
    self.leftLimiteBorder.name="LeftLimiteBorder";
    self.rightLimiteBorder.name="RightLimiteBorder";


    local alignView = self.bottomBorder.gameObject:AddComponent(AlignViewExClassType);
    alignView:setAlign(Enum_AlignViewEx.Align_Bottom);
    alignView.isKeepPos = true;

    alignView = self.topBorder.gameObject:AddComponent(AlignViewExClassType);
    alignView:setAlign(Enum_AlignViewEx.Align_Up);
    alignView.isKeepPos = true;

    alignView = self.leftBorder:AddComponent(AlignViewExClassType);
    alignView:setAlign(Enum_AlignViewEx.Align_Left);
    alignView.isKeepPos = true;

    alignView = self.rightBorder:AddComponent(AlignViewExClassType);
    alignView:setAlign(Enum_AlignViewEx.Align_Right);
    alignView.isKeepPos = true;
    alignView = self.bottomLimiteBorder:AddComponent(AlignViewExClassType);
    alignView:setAlign(Enum_AlignViewEx.Align_Bottom);
    alignView.isKeepPos = true;
    alignView = self.topLimiteBorder:AddComponent(AlignViewExClassType);
    alignView:setAlign(Enum_AlignViewEx.Align_Up);
    alignView.isKeepPos = true;
    alignView = self.leftLimiteBorder:AddComponent(AlignViewExClassType);
    alignView:setAlign(Enum_AlignViewEx.Align_Left);
    alignView.isKeepPos = true;
    alignView = self.rightLimiteBorder:AddComponent(AlignViewExClassType);
    alignView:setAlign(Enum_AlignViewEx.Align_Right);
    alignView.isKeepPos = true;
end


--??????
function _CGameSceneControl:OnCreateFish(_eventId,_eventData)
    local fish = self._gameFishControl:CreateFish(_eventData.fishKind,_eventData.fishId,handler(self._gamePlayersControl,self._gamePlayersControl._getSepNumber));
    for i=1,_eventData.initCount do
        _eventData.point[i].x = _eventData.point[i].x- C_SERVER_SCENE_WIDTH/2;
        _eventData.point[i].y = _eventData.point[i].y- C_SERVER_SCENE_HEIGHT/2;
    end
    fish:Init(_eventData);
end

--??????????
function _CGameSceneControl:OnCreateLocalFish(_eventId,_eventData)
    local fish = self._gameFishControl:CreateFish(_eventData.fishKind,handler(self._gamePlayersControl,self._gamePlayersControl._getSepNumber));
    fish:Init(_eventData);
end

--?л?????
function _CGameSceneControl:SwitchScene(_eventId,_data)

    self:Resume();

    self._gameFishControl:FishQuickMoveOutScreen();

    self._switchSceneControl:StartSwitchScene(_data);
    self._gameFishControl:StopRefreshFish();
    self._gamePlayersControl:PauseCreateBullet();

end

--????????
function _CGameSceneControl:checkSwitchSceneBegin(_dt)
    if self._switchSceneControl:IsSwitch() then
        if not self._switchSceneControl:IsStart() then
            if self._gameFishControl:ScreenFishCount()==0 then
                --?????????
                self._gameFishControl:ClearFishes();
                --??????????
                self._isCanShakeScreen = false;
                --
                self:StopShakeScreen();
                --???????
                local _data = self._switchSceneControl:Start();

                --??????????
                --??????
                self.fishGroup = self._gameFishControl:CreateFishGroup(_data);

                --???????????
                self:PlayHaiLang();
            end
        end
    end
end

function _CGameSceneControl:SwitchSceneOver(_sprite,_data)
    self._sceneBg.sprite = _sprite;
    self._bgTrans.localPosition = Vector3.zero;
    --self._gameFishControl:StartRefreshFish();

    self:Resume();

    if xpcall(function()
        self._gamePlayersControl:ResumeCreateBullet();
        --self._gameFishControl:ClearFishes();
    end,function (msg)
        error("msg:" .. msg);
    end) then
    end

    self.fishGroup:RealStart();

    self:PlayBgSound();

    self._isCanShakeScreen = true;

    G_GlobalGame:DispatchEventByStringKey("NotifyClearAllEffects");
end


function _CGameSceneControl:Pause()

    if self:IsInSwitchScene() then
        return ;
    end
    self._gameFishControl:Pause();
    self._isPauseScreen = true;
    self._pauseTime     = G_GlobalGame.GameConfig.SceneConfig.pauseScreenTime;
end


function _CGameSceneControl:Rotation()
    self._belowUITrans.localRotation = Quaternion.Euler(0,0,180);
end

function _CGameSceneControl:NormalRotation()
    self._belowUITrans.localRotation = Quaternion.Euler(0,0,0);
end


function _CGameSceneControl:DisappearMaskBg()
    self._maskBg.gameObject:SetActive(false);
end


function _CGameSceneControl:FadeOutMaskBg()
    self._isMaskFadeOut = true;
    self._maskAlpha     = 1;
end


function _CGameSceneControl:_controlFadeOutMaskBg(_dt)
    if self._isMaskFadeOut then
        self._maskAlpha = self._maskAlpha - _dt/1.5;
        if self._maskAlpha<=0 then
            self._maskAlpha = 0;
            self._isMaskFadeOut = false;
            self._maskBg.gameObject:SetActive(false);
        end
        self._maskBgImage.color = Color.New(1,1,1,self._maskAlpha);
    end
end


function _CGameSceneControl:Resume()
    self._gameFishControl:Resume();
    self._isPauseScreen = false;
    self._pauseTime = 0;
end


function _CGameSceneControl:_controlPauseScreen(_dt)
    if self._isPauseScreen then
        self._pauseTime = self._pauseTime - _dt;
        if self._pauseTime<0 then
            self:Resume();
        end
    end
end


function _CGameSceneControl:IsSwitchingScene()
    return self._switchSceneControl:IsSwitch();
end


function _CGameSceneControl:Update(_dt)
    --???????????
    self:_controlFadeOutMaskBg(_dt);
    --???Ч??????
    self._gameEffectControl:Update(_dt);
    --?л????????
    self._switchSceneControl:Update(_dt);
    --?????
    self._gameFishControl:Update(_dt);
    --?????????
    self._gamePlayersControl:Update(_dt);
    --??????
    self._gameBulletControl:Update(_dt);
    --???????
    self:_controlPauseScreen(_dt);
    --????????
    self:_controlShakeScreen(_dt);
    --????????
    self:checkSwitchSceneBegin(_dt);
end

function _CGameSceneControl:_controlShakeScreen(_dt)
    if self._shakeTime>0 then
        self._shakeTime = self._shakeTime - _dt;
        if self._shakeTime>0 then
            --local random = math.random(1,4);
            ----[[
            self._shakeIndex = self._shakeIndex + 1;
            if self._shakeIndex>4 then
                self._shakeIndex = 1;
            end
            local fudu  = math.random(10,18);
            if self._shakeIndex==1 then
                self._bgTrans.localPosition = Vector3.New(0,fudu,0);
            elseif self._shakeIndex==2 then
                self._bgTrans.localPosition = Vector3.New(fudu,0,0);
            elseif self._shakeIndex==3 then
                self._bgTrans.localPosition = Vector3.New(0,-fudu,0); 
            elseif self._shakeIndex==4 then  
                self._bgTrans.localPosition = Vector3.New(-fudu,0,0);
            end
            --]]
        else
            self:StopShakeScreen();
        end
    end
end


function _CGameSceneControl:GetSceneSize()
    return 
end



function _CGameSceneControl:GetSceneRectInWorld(isEffectBySwitch)
    isEffectBySwitch = isEffectBySwitch or false;

    if isEffectBySwitch then
        if self._switchSceneControl:IsSwitch() then
            --?????л?????
            local x = self._switchSceneControl:MoveX();
            if self._gamePlayersControl:IsRotation() then
                return x,self.bottomLimiteBorderTrans.position.y,self.rightLimiteBorderTrans.position.x,self.topLimiteBorderTrans.position.y;
            else
                return self.leftLimiteBorderTrans.position.x,self.bottomLimiteBorderTrans.position.y,x,self.topLimiteBorderTrans.position.y;
            end
        else
            return self.leftLimiteBorderTrans.position.x,self.bottomLimiteBorderTrans.position.y,self.rightLimiteBorderTrans.position.x,self.topLimiteBorderTrans.position.y;
        end
    else

        return self.leftLimiteBorderTrans.position.x,self.bottomLimiteBorderTrans.position.y,self.rightLimiteBorderTrans.position.x,self.topLimiteBorderTrans.position.y;
    end
end


function _CGameSceneControl:GetRealSceneRectInWorld()

    return self.leftBorderTrans.position.x,self.bottomBorder.position.y,self.rightBorderTrans.position.x,self.topBorder.position.y;
end


function _CGameSceneControl:OnKVRealSceneRectInWorld()
    return self:GetRealSceneRectInWorld();
end


function _CGameSceneControl:IsInGameScene(_point)

end


function _CGameSceneControl:IsInSwitchScene()
    return self._switchSceneControl:IsSwitch();
end


function _CGameSceneControl:GetFish(_fishId)
    return self._gameFishControl:GetFish(_fishId);
end

--????????????С
function _CGameSceneControl:OnKVScenePixelSize()
    return C_CLIENT_SCENE_WIDTH,C_CLIENT_SCENE_HEIGHT;
end

--???????
function _CGameSceneControl:ShakeScreen()
    if self._isCanShakeScreen then
        self._shakeTime     = 0.8;
    end
end

--???????
function _CGameSceneControl:StopShakeScreen()
    self._shakeTime = 0;
    self._bgTrans.localPosition = Vector3.New(0,0,0);
    self._shakeIndex = 1;
end

--??????????
function _CGameSceneControl:OnReloadGame()
    --????????????
    self._gameFishControl:ClearFishes();
    self._gameFishControl:StartRefreshFish();
    self._gameBulletControl:ClearAllBullets();
    --?????????Ч
    G_GlobalGame:DispatchEventByStringKey("NotifyClearAllEffects");
    --??????????
    self._gamePlayersControl:ClearAllPlayers();
end

--??????
function _CGameSceneControl:OnEnterGameSuccess()
    if self._curBgIndex == nil  then
        --???
        self:PlayBgSound();
    end
end

function _CGameSceneControl:PlayBgSound()
    local index= math.random(1,self._bgIndexVec:size());
    local bgIndex = self._bgIndexVec:pop(index);
    if self._curBgIndex then
        --??????????????????
        self._bgIndexVec:push_back(self._curBgIndex);
    end
    --???????????
    G_GlobalGame:PlayBgSound(bgIndex);
    --????????????
    self._curBgIndex = bgIndex;
end

function _CGameSceneControl:PlayHaiLang()
    G_GlobalGame:PlayBgSound(G_GlobalGame.SoundDefine.HaiLang);
end


return _CGameSceneControl;