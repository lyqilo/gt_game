
import ".Functions";

local _CGOCreator=class("_CGOCreator");

--缓存ab资源里预制体、图片、shader的引用，不用每次都重新从ab里获取，游戏退出后，统一卸载ab资源就好，也减少了动态申请内存的次数

function _CGOCreator:ctor()
    self._gameUIABName      = 'module14/game_white_snake_ui';
    self._gameSceneABName   = 'module14/game_white_snake_scene';
    self._gameFishABName    = 'module14/game_white_snake_fish';
    self._gamePlayerABName  = 'module14/game_white_snake_player';
    self._gameMusicABName   = 'module14/game_white_snake_music';
    self._gameHelpABName    = 'module14/game_white_snake_help'; --帮助 ab资源
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
    self.bombEffectObj={};
    self.lockFlagSprite= {};
    self.playerInfoBgs = {};

    self.fishTemplates = {
        colliders = {
        },
    };

    --鱼的新方式
    self.fishModelObj  ={};
    self.fishGOs = {};
    self.fishSprites = {};

    --ab资源里对应的sprite
    self.abCommonSprite = {};

    --帮助的
    self.helpObjs = {};
    --所有的abName;
    self.abName = {};
    --shader表
    self.shaderTable = {};

    --所有的网
    self.netObjs = {};

    --v1的ab资源
    self._v1ResAbName = "module14/game_white_snake_res_v1";
        --
    self.cacheAssetbundle = GameObject.Find("Unity3dAssetbundle");
    self.cacheAssetbundleTrans = self.cacheAssetbundle.transform
    self.cacheAbName = {};
end

--预加载一些东西
function _CGOCreator:PreLoad()
    local FishType = G_GlobalGame.Enum_FishType;
    for i=FishType.FISH_KIND_1,FishType.FISH_KIND_COUNT do
        self:loadFish(i);
    end
    --self:loadFish(G_GlobalGame.Enum_FishType.FISH_KIND_1);
    self:loadEffect(G_GlobalGame.Enum_BombEffectType.FishDead);
end

--异步加载
function _CGOCreator:AsyncPreLoad(_runTime,_data)
    self._asyncPreLoadStep = self._asyncPreLoadStep or 1;
    local FishType = G_GlobalGame.Enum_FishType;
    if self._asyncPreLoadStep <= FishType.FISH_KIND_COUNT then
        self:asyncLoadFish(self._asyncPreLoadStep);
        self._asyncPreLoadStep = self._asyncPreLoadStep + 1;
        return false,self._asyncPreLoadStep;
    end
    if self._asyncPreLoadStep == FishType.FISH_KIND_COUNT + 1 then
        self:loadEffect(G_GlobalGame.Enum_BombEffectType.FishDead);
        self._asyncPreLoadStep = self._asyncPreLoadStep + 1;
        return true,self._asyncPreLoadStep;
    end
end

--创建主窗口
function _CGOCreator:createMainPanel(asyncFunc)
    local name = "MainPanel";
    local asyncLoad = function(obj)
        self.mainPanelObj = obj;
        local obj1= newobject(self.mainPanelObj);
        obj1.name = name;
        return asyncFunc(obj1);
    end
    if self.mainPanelObj then
        return asyncLoad(newobject(self.mainPanelObj));
    end
    if asyncFunc then 
        self.mainPanelObj= self:LoadAsset(self._gameUIABName, name,asyncLoad);
        return nil;
    else
        self.mainPanelObj= self:LoadAsset(self._gameUIABName, name);
    end
    if not self.mainPanelObj then
        error("obj [" .. self._gameUIABName  .. ":" .. name .. "] ab not exist");
        return nil;
    end
    self.mainPanelObj:GetComponent("CanvasScaler").referenceResolution = Vector2.New(1334,750);
    self.mainPanelObj.transform:Find("UICamera").localRotation = Quaternion.identity;
    self.mainPanelObj.transform:Find("UICamera"):GetComponent("Camera").clearFlags = UnityEngine.CameraClearFlags.SolidColor;
    self.mainPanelObj.transform:Find("UICamera"):GetComponent("Camera").backgroundColor = Color.New(0, 0, 0, 1);
    local obj= self.mainPanelObj;--newobject(self.mainPanelObj);
    obj.name = name;
    return obj;
end

--创建游戏场景
function _CGOCreator:createGameScene(asyncFunc)
    local name = "GameScene";
    local asyncLoad = function (obj)
        self.gameSceneObj = obj;
        local obj1= newobject(self.gameSceneObj);
        obj1.name = name;
        return asyncFunc(obj1);
    end
    if self.gameSceneObj then
        if asyncFunc then
            return asyncLoad(newobject(self.gameSceneObj));
        else
            return newobject(self.gameSceneObj);
        end
    end
    if asyncFunc then 
        self:LoadAsset(self._gameSceneABName, name,asyncLoad);
        return nil;
    else
        self.gameSceneObj= self:LoadAsset(self._gameSceneABName, name);
    end
    if not self.gameSceneObj then
        error("obj [" .. self._gameSceneABName  .. ":" .. name .. "] ab not exist");
        return nil;
    end
    local obj= self.gameSceneObj;--newobject(self.gameSceneObj);
    obj.name = name;
    return obj;
end

--创建UI部分
function _CGOCreator:createUIPart()
    if self.uiObj then
        return newobject(self.uiObj);
    end
    local name = "UIPart";
    self.uiObj= self:LoadAsset(self._gameUIABName, name);
    local obj= self.uiObj;--newobject(self.uiObj);
    obj.name = name;
    return obj;
end


--创建鱼
function _CGOCreator:createFish(_type)
    if self.fishObjs[_type] then
    else
        self.fishObjs[_type] = self:LoadAsset(self._gameFishABName, G_GlobalGame.FunctionsLib.FUNC_GetFishPrefabName(_type));
    end
    local obj= newobject(self.fishObjs[_type]);
    obj.name = "Fish";
    return obj;
end
function _CGOCreator:LoadFromScenceCache(abName,obName)
    local name = abName .. "/" .. obName;
    if (self.cacheAbName[name]) then
        return self.cacheAbName[name].obj; 
    end
    self.cacheAbName[name] = {};
    local tranform = self.cacheAssetbundleTrans:Find(name);
    if not tranform then
        return ;
    end
    self.cacheAbName[name].obj = tranform.gameObject;
    return self.cacheAbName[name].obj;
end


function _CGOCreator:LoadAsset(abName,obName,asyncFunc)
    --error("Load AbName:" .. abName .. ",ObjName:" .. obName);
    if asyncFunc then
        local obj = self:LoadFromScenceCache(abName,obName);
	if obj then
	    return asyncFunc(obj);
	end
	self.abName[abName] = 1;
        Util.LoadAsset(abName, obName,asyncFunc);
        return ;
    end
    local obj = self:LoadFromScenceCache(abName,obName);
    if obj then
        return obj;
    end
    self.abName[abName] = 1;
    local obj = Util.LoadAsset(abName, obName);
    if obj==nil then
        error("Failed load AbName:" .. abName .. ",ObjName:" .. obName);
    end
    return obj;
end

function _CGOCreator:LoadAssetAndInit(abName,obName,asyncFunc)
    --error("Load AbName:" .. abName .. ",ObjName:" .. obName);
    if asyncFunc then
        local obj = self:LoadFromScenceCache(abName,obName);
	if obj then
	    asyncFunc(newobject(obj));
	    return nil
	end
    	self.abName[abName] = 1;
        Util.LoadAssetAsync(abName, obName,asyncFunc);
        return nil;
    else
        local obj = self:LoadFromScenceCache(abName,obName);
	if obj then
	    return newobject(obj);
	end
	self.abName[abName] = 1;
        local obj = Util.LoadAsset(abName, obName);
        if obj==nil then
            error("Failed load AbName:" .. abName .. ",ObjName:" .. obName);
        end
        return newobject(obj);
    end
end

function _CGOCreator:LoadAssetObj(abName,obName,asyncFunc)
    --self.abName[abName] = 1;
    --return ResManager:LoadAssetObj(abName, obName);
    
--[[    if asyncFunc then
    	local obj = self:LoadFromScenceCache(abName,obName);
    	if obj then
	        return asyncFunc(obj);
    	end
	    self.abName[abName] = 1;
        ResManager:LoadAssetObj(abName, obName,asyncFunc);
        return ;
    end--]]
    local obj = self:LoadFromScenceCache(abName,obName);
    if obj then
	    return obj;
    end
    self.abName[abName] = 1;
    local obj = Util.LoadAssetObj(abName, obName);
--[[    if asyncFunc then
        return nil;
    end--]]
    if obj==nil then
        error("Failed load AbName:" .. abName .. ",ObjName:" .. obName);
    end
    return obj;
end

function _CGOCreator:asyncLoadFish(_type)
    local fishStyleInfo = G_GlobalGame.FunctionsLib.FUNC_GetFishStyleInfo(_type);
    if not self.fishGOs[_type] then
        local loadFish = function(obj)
            self.fishModelObj[fishStyleInfo.modelName] = obj;
            self.fishGOs[_type] = newobject(self.fishModelObj[fishStyleInfo.modelName]);
            --destroyObj(self.fishModelObj[fishStyleInfo.modelName]);
            --放入缓存
            G_GlobalGame.FunctionsLib.FUNC_CacheGO(self.fishGOs[_type],"Templates");
            self.fishGOs[_type].name = "Template_Fish " .. _type;
            local fishAbName = fishStyleInfo.abName or self._gameFishABName;
            local fishSprites = self.fishSprites;
            local function ReplaceFishAction(transform,fishStyleInfo)
                local bg =transform:Find("Bg");
                local sprite;
                if bg then
                    local bgABName = fishStyleInfo.bg.abName or self._gameFishABName; 
                    --先换背景
                    if fishStyleInfo.bg.type == G_GlobalGame.Enum_FishUnderPanType.Group then
                        --大三元或者大四喜
                        local bgImage = bg.gameObject:AddComponent(typeof(UnityEngine.UI.Image));
                        local bgName = "dish";
                        if not self.fishSprites[bgName] then
                            sprite = self:getCommonSprite(bgABName, bgName);
                            self.fishSprites[bgName] = sprite;
                        else
                            sprite = self.fishSprites[bgName];
                        end
                        bgImage.sprite = sprite;
                        bgImage:SetNativeSize();
                        bgImage.raycastTarget = false;
                    elseif fishStyleInfo.bg.type == G_GlobalGame.Enum_FishUnderPanType.Boss then
                        --鱼王
                        local bgImage = bg.gameObject:AddComponent(typeof(UnityEngine.UI.Image));
                        local bgName = "FBk0_003";
                        if not self.fishSprites[bgName] then
                            sprite = self:getCommonSprite(bgABName, bgName);
                            self.fishSprites[bgName] = sprite;
                        else
                            sprite = self.fishSprites[bgName];
                        end
                        bgImage.sprite = sprite;
                        bgImage:SetNativeSize();
                        bgImage.raycastTarget = false;
                    elseif fishStyleInfo.bg.type == G_GlobalGame.Enum_FishUnderPanType.Custom then  
                        --自定义 
                        local bgImage = bg.gameObject:AddComponent(typeof(UnityEngine.UI.Image));
                        local bgName = fishStyleInfo.bg.fileName;
                        if not self.fishSprites[bgName] then
                            sprite = self:getCommonSprite(bgABName, bgName);
                            self.fishSprites[bgName] = sprite;
                        else
                            sprite = self.fishSprites[bgName];
                        end
                        bgImage.sprite = sprite;
                        bgImage:SetNativeSize();
                        bgImage.raycastTarget = false;
                    elseif fishStyleInfo.bg.type == G_GlobalGame.Enum_FishUnderPanType.Null then 
                        --没有背景  

                    end
                end

                local actions = transform:Find("Actions");
                if not actions then
                    return;
                end
                local moveAction = actions:Find("Move");
                local deadAction = actions:Find("Dead");
                local actionsData = fishStyleInfo.actions;
                if not actionsData then
                    return ;
                end
                local moveData = actionsData.move;
                local deadData = actionsData.dead;

                local imageAnima; 
                local image;
                local str;
                local frameIndex;

                if actions then
                    if actionsData.actionPos then
                        --设置位置
                        actions.localPosition = Vector3.New(actionsData.actionPos.x,actionsData.actionPos.y,actionsData.actionPos.z);
                    end
                    if actionsData.scale then
                        --设置缩放
                        if actionsData.scale.x~=nil then
                            actions.localScale = Vector3.New(actionsData.scale.x,actionsData.scale.y,actionsData.scale.z);
                        else
                            actions.localScale = Vector3.New(actionsData.scale[1],actionsData.scale[2],actionsData.scale[3]);
                        end
                    end
                end

                local function loadSprite(imageAnima,format,frameIndex)
                    local str =string.format(format, frameIndex);
                    local sprite;
                    if not fishSprites[str] then
                        sprite = self:getCommonSprite(fishAbName, str);
                        fishSprites[str] = sprite;
                    else
                        sprite = fishSprites[str];
                    end
                    if xpcall(function()
                        imageAnima:AddSprite(sprite);
                    end,function (msg)
                        error("animateType:" .. animaType);
                    end) then
                    end
                    return sprite;
                end

                if moveData and moveAction then
                    local frameCount = moveData.customFrames and #moveData.customFrames or 0;
                    if frameCount>0 then
                        image = moveAction.gameObject:AddComponent(typeof(UnityEngine.UI.Image));
                        imageAnima = moveAction.gameObject:AddComponent(typeof(ImageAnima));
                        imageAnima.fSep = moveData.interval;
                        local isRaycastTarget = moveData.isRaycastTarget or false;
                        image.raycastTarget = isRaycastTarget;
                        --自定义帧率
                        for i=1,frameCount do
                            frameIndex = moveData.customFrames[i];
                            if frameIndex==-1 then
                                imageAnima:AddSprite(nil);
                            else
                                loadSprite(imageAnima,moveData.format,frameIndex);
                            end

                            if i==1 then
                                image.sprite = sprite;
                                image:SetNativeSize();
                            end
                        end
                    else
                        if moveData.frameCount~=0 then
                            --有移动动画
                            image = moveAction.gameObject:AddComponent(typeof(UnityEngine.UI.Image));
                            imageAnima = moveAction.gameObject:AddComponent(typeof(ImageAnima));
                            imageAnima.fSep = moveData.interval;
                            frameIndex = moveData.frameBeginIndex;
                            local frameMin = 0;
                            if moveData.frameMin then
                                frameMin = moveData.frameMin;
                            end
                            local isRaycastTarget = moveData.isRaycastTarget or false;
                            image.raycastTarget = isRaycastTarget;
                            for i=1,moveData.frameCount do
                                if frameIndex< frameMin then
                                    frameIndex = frameMin;
                                end
                                if moveData.frameMax then
                                    --最大的索引
                                    if frameIndex>moveData.frameMax then
                                        frameIndex = frameMin;
                                    end
                                end
                                sprite = loadSprite(imageAnima,moveData.format, frameIndex);
                                frameIndex = frameIndex + moveData.frameInterval;
                                if i==1 then
                                    image.sprite = sprite;
                                    image:SetNativeSize();
                                end
                            end
                        end
                    end
                    if moveData.boxCollider then
                        --添加碰撞区
                        local boxCollider = moveAction.gameObject:AddComponent(typeof(UnityEngine.BoxCollider));
                        local boxColliderData = moveData.boxCollider;
                        boxCollider.isTrigger = false;
                        if boxColliderData.center  then
                            boxCollider.center = Vector3.New(boxColliderData.center.x,boxColliderData.center.y,boxColliderData.center.z);
                        end
                        if boxColliderData.size then
                            boxCollider.size = Vector3.New(boxColliderData.size.x,boxColliderData.size.y,boxColliderData.size.z);
                        end
                    end
                end

                if deadData and deadAction then

                    local frameCount = deadData.customFrames and #deadData.customFrames or 0;
                    if frameCount>0 then
                        image = deadAction.gameObject:AddComponent(typeof(UnityEngine.UI.Image));
                        imageAnima = deadAction.gameObject:AddComponent(typeof(ImageAnima));
                        imageAnima.fSep = deadData.interval;
                        local isRaycastTarget = deadData.isRaycastTarget or false;
                        image.raycastTarget = isRaycastTarget;
                        --自定义帧率
                        for i=1,frameCount do
                            frameIndex = deadData.customFrames[i];
                            if frameIndex==-1 then
                                imageAnima:AddSprite(nil);
                            else
                                loadSprite(imageAnima,deadData.format,frameIndex);
                            end

                            if i==1 then
                                image.sprite = sprite;
                                image:SetNativeSize();
                            end
                        end
                    else
                        --死亡动作
                        if deadData.frameCount~=0 then
                            --有死亡动画
                            image = deadAction.gameObject:AddComponent(typeof(UnityEngine.UI.Image));
                            imageAnima = deadAction.gameObject:AddComponent(typeof(ImageAnima));
                            imageAnima.fSep = deadData.interval;
                            frameIndex = deadData.frameBeginIndex;
                            local frameMin = 0;
                            if deadData.frameMin then
                                frameMin = deadData.frameMin;
                            end
                            local isRaycastTarget = deadData.isRaycastTarget or false;
                            image.raycastTarget = isRaycastTarget;
                            for i=1,deadData.frameCount do
                                if frameIndex< frameMin then
                                    frameIndex = frameMin;
                                end
                                if deadData.frameMax then
                                    --最大的索引
                                    if frameIndex>deadData.frameMax then
                                        frameIndex = frameMin;
                                    end
                                end
                                sprite = loadSprite(imageAnima,deadData.format, frameIndex);
                                frameIndex = frameIndex + deadData.frameInterval;
                                if i==1 then
                                    image.sprite = sprite;
                                    image:SetNativeSize();
                                end
                            end
                        end ---if deadData.frameCount~=0 then
                        if deadData.boxCollider then
                            --添加碰撞区
                            local boxCollider = deadAction:AddComponent(typeof(UnityEngine.BoxCollider));
                            local boxColliderData = deadData.boxCollider;
                            boxCollider.isTrigger = false;
                            if boxColliderData.center  then
                                boxCollider.center = Vector3.New(boxColliderData.center.x,boxColliderData.center.y,boxColliderData.center.z);
                            end
                            if boxColliderData.size then
                                boxCollider.size = Vector3.New(boxColliderData.size.x,boxColliderData.size.y,boxColliderData.size.z);
                            end
                        end  --if deadData.boxCollider then
                    end

                end
            end
            local go =self.fishGOs[_type];
            local transform  = go.transform;
            --创建动画
            if fishStyleInfo.combType == G_GlobalGame.Enum_FishCombType.Single then
                --单个
                if fishStyleInfo.exStyles ~=nil then
                    --拓展新的版本
                    local nameStyle = fishStyleInfo.exStyles[go.name];
                    if nameStyle then
                        ReplaceFishAction(transform,nameStyle);
                    elseif fishStyleInfo.exStyles.default then
                        ReplaceFishAction(transform,fishStyleInfo.exStyles.default);
                    else
                        ReplaceFishAction(transform,fishStyleInfo);
                    end
                else
                    --兼容以前的版本
                    ReplaceFishAction(transform,fishStyleInfo);
                end
            else
                local childCount = transform.childCount;
                local child;
                for i=1,childCount do
                    child = transform:GetChild(i-1);
                    if fishStyleInfo.exStyles ~=nil then
                        --拓展新的版本
                        local nameStyle = fishStyleInfo.exStyles[child.gameObject.name];
                        if nameStyle then
                            ReplaceFishAction(child,nameStyle);
                        elseif fishStyleInfo.exStyles.default then
                            ReplaceFishAction(child,fishStyleInfo.exStyles.default);
                        else
                            ReplaceFishAction(child,fishStyleInfo);
                        end
                    else
                        --兼容以前的版本
                        ReplaceFishAction(child,fishStyleInfo);
                    end
                end
            end

        end
        if not self.fishModelObj[fishStyleInfo.modelName] then
            self:LoadAsset(self._gameFishABName, fishStyleInfo.modelName,loadFish);
        else
            loadFish(self.fishModelObj[fishStyleInfo.modelName]);
        end
    end
    return self.fishGOs[_type];


end

function _CGOCreator:loadFish(_type)
    local fishStyleInfo = G_GlobalGame.FunctionsLib.FUNC_GetFishStyleInfo(_type);

    if not self.fishGOs[_type] then
        if not self.fishModelObj[fishStyleInfo.modelName] then
            self.fishModelObj[fishStyleInfo.modelName] = self:LoadAsset(self._gameFishABName, fishStyleInfo.modelName);
        end
        self.fishGOs[_type] = newobject(self.fishModelObj[fishStyleInfo.modelName]);
        --destroyObj(self.fishModelObj[fishStyleInfo.modelName]);
        --放入缓存
        G_GlobalGame.FunctionsLib.FUNC_CacheGO(self.fishGOs[_type],"Templates");
        self.fishGOs[_type].name = "Template_Fish " .. _type;
        local fishAbName = fishStyleInfo.abName or self._gameFishABName;
        local fishSprites = self.fishSprites;
        local function ReplaceFishAction(transform,fishStyleInfo)
            local bg =transform:Find("Bg");
            local sprite;
            if bg then
                local bgABName = fishStyleInfo.bg.abName or self._gameFishABName; 
                bgABName = "module14/game_white_snake_fish";
                --先换背景
                if fishStyleInfo.bg.type == G_GlobalGame.Enum_FishUnderPanType.Group then
                    --大三元或者大四喜
                    local bgImage = bg.gameObject:AddComponent(typeof(UnityEngine.UI.Image));
                    local bgName = "dish";
                    if not self.fishSprites[bgName] then
                        sprite = self:getCommonSprite(bgABName, bgName);
                        self.fishSprites[bgName] = sprite;
                    else
                        sprite = self.fishSprites[bgName];
                    end
                    bgImage.sprite = sprite;
                    bgImage:SetNativeSize();
                    bgImage.raycastTarget = false;
                elseif fishStyleInfo.bg.type == G_GlobalGame.Enum_FishUnderPanType.Boss then
                    --鱼王
                    local bgImage = bg.gameObject:AddComponent(typeof(UnityEngine.UI.Image));
                    local bgName = "FBk0_003";
                    if not self.fishSprites[bgName] then
                        sprite = self:getCommonSprite(bgABName, bgName);
                        self.fishSprites[bgName] = sprite;
                    else
                        sprite = self.fishSprites[bgName];
                    end
                    bgImage.sprite = sprite;
                    bgImage:SetNativeSize();
                    bgImage.raycastTarget = false;
                elseif fishStyleInfo.bg.type == G_GlobalGame.Enum_FishUnderPanType.Custom then  
                    --自定义 
                    local bgImage = bg.gameObject:AddComponent(typeof(UnityEngine.UI.Image));
                    local bgName = fishStyleInfo.bg.fileName;
                    if not self.fishSprites[bgName] then
                        sprite = self:getCommonSprite(bgABName, bgName);
                        self.fishSprites[bgName] = sprite;
                    else
                        sprite = self.fishSprites[bgName];
                    end
                    bgImage.sprite = sprite;
                    bgImage:SetNativeSize();
                    bgImage.raycastTarget = false;
                elseif fishStyleInfo.bg.type == G_GlobalGame.Enum_FishUnderPanType.Null then 
                    --没有背景  

                end
            end

            local actions = transform:Find("Actions");
            if not actions then
                return;
            end
            local moveAction = actions:Find("Move");
            local deadAction = actions:Find("Dead");
            local actionsData = fishStyleInfo.actions;
            if not actionsData then
                return ;
            end
            local moveData = actionsData.move;
            local deadData = actionsData.dead;

            local imageAnima; 
            local image;
            local str;
            local frameIndex;

            if actions then
                if actionsData.actionPos then
                    --设置位置
                    actions.localPosition = Vector3.New(actionsData.actionPos.x,actionsData.actionPos.y,actionsData.actionPos.z);
                end
                if actionsData.scale then
                    --设置缩放
                    if actionsData.scale.x~=nil then
                        actions.localScale = Vector3.New(actionsData.scale.x,actionsData.scale.y,actionsData.scale.z);
                    else
                        actions.localScale = Vector3.New(actionsData.scale[1],actionsData.scale[2],actionsData.scale[3]);
                    end
                end
            end

            local function loadSprite(imageAnima,format,frameIndex)
                local str =string.format(format, frameIndex);
                local sprite;
                local sameFishAbName = "module14/game_white_snake_fish";
                if not fishSprites[str] then
                    --sprite = self:getCommonSprite(fishAbName, str);
                    sprite = self:getCommonSprite(sameFishAbName, str);
                    fishSprites[str] = sprite;
                else
                    sprite = fishSprites[str];
                end
                if xpcall(function()
                    imageAnima:AddSprite(sprite);
                end,function (msg)
                    error("animateType:" .. animaType);
                end) then
                end
                return sprite;
            end

            if moveData and moveAction then
                local frameCount = moveData.customFrames and #moveData.customFrames or 0;
                if frameCount>0 then
                    image = moveAction.gameObject:AddComponent(typeof(UnityEngine.UI.Image));
                    imageAnima = moveAction.gameObject:AddComponent(typeof(ImageAnima));
                    imageAnima.fSep = moveData.interval;
                    local isRaycastTarget = moveData.isRaycastTarget or false;
                    image.raycastTarget = isRaycastTarget;
                    --自定义帧率
                    for i=1,frameCount do
                        frameIndex = moveData.customFrames[i];
                        if frameIndex==-1 then
                            imageAnima:AddSprite(nil);
                        else
                            loadSprite(imageAnima,moveData.format,frameIndex);
                        end

                        if i==1 then
                            image.sprite = sprite;
                            image:SetNativeSize();
                        end
                    end
                else
                    if moveData.frameCount~=0 then
                        --有移动动画
                        image = moveAction.gameObject:AddComponent(typeof(UnityEngine.UI.Image));
                        imageAnima = moveAction.gameObject:AddComponent(typeof(ImageAnima));
                        imageAnima.fSep = moveData.interval;
                        frameIndex = moveData.frameBeginIndex;
                        local frameMin = 0;
                        if moveData.frameMin then
                            frameMin = moveData.frameMin;
                        end
                        local isRaycastTarget = moveData.isRaycastTarget or false;
                        image.raycastTarget = isRaycastTarget;
                        for i=1,moveData.frameCount do
                            if frameIndex< frameMin then
                                frameIndex = frameMin;
                            end
                            if moveData.frameMax then
                                --最大的索引
                                if frameIndex>moveData.frameMax then
                                    frameIndex = frameMin;
                                end
                            end
                            sprite = loadSprite(imageAnima,moveData.format, frameIndex);
                            frameIndex = frameIndex + moveData.frameInterval;
                            if i==1 then
                                image.sprite = sprite;
                                image:SetNativeSize();
                            end
                        end
                    end
                end
                if moveData.boxCollider then
                    --添加碰撞区
                    local boxCollider = moveAction.gameObject:AddComponent(typeof(UnityEngine.BoxCollider));
                    local boxColliderData = moveData.boxCollider;
                    boxCollider.isTrigger = false;
                    if boxColliderData.center  then
                        boxCollider.center = Vector3.New(boxColliderData.center.x,boxColliderData.center.y,boxColliderData.center.z);
                    end
                    if boxColliderData.size then
                        boxCollider.size = Vector3.New(boxColliderData.size.x,boxColliderData.size.y,boxColliderData.size.z);
                    end
                end
            end

            if deadData and deadAction then

                local frameCount = deadData.customFrames and #deadData.customFrames or 0;
                if frameCount>0 then
                    image = deadAction.gameObject:AddComponent(typeof(UnityEngine.UI.Image));
                    imageAnima = deadAction.gameObject:AddComponent(typeof(ImageAnima));
                    imageAnima.fSep = deadData.interval;
                    local isRaycastTarget = deadData.isRaycastTarget or false;
                    image.raycastTarget = isRaycastTarget;
                    --自定义帧率
                    for i=1,frameCount do
                        frameIndex = deadData.customFrames[i];
                        if frameIndex==-1 then
                            imageAnima:AddSprite(nil);
                        else
                            loadSprite(imageAnima,deadData.format,frameIndex);
                        end

                        if i==1 then
                            image.sprite = sprite;
                            image:SetNativeSize();
                        end
                    end
                else
                    --死亡动作
                    if deadData.frameCount~=0 then
                        --有死亡动画
                        image = deadAction.gameObject:AddComponent(typeof(UnityEngine.UI.Image));
                        imageAnima = deadAction.gameObject:AddComponent(typeof(ImageAnima));
                        imageAnima.fSep = deadData.interval;
                        frameIndex = deadData.frameBeginIndex;
                        local frameMin = 0;
                        if deadData.frameMin then
                            frameMin = deadData.frameMin;
                        end
                        local isRaycastTarget = deadData.isRaycastTarget or false;
                        image.raycastTarget = isRaycastTarget;
                        for i=1,deadData.frameCount do
                            if frameIndex< frameMin then
                                frameIndex = frameMin;
                            end
                            if deadData.frameMax then
                                --最大的索引
                                if frameIndex>deadData.frameMax then
                                    frameIndex = frameMin;
                                end
                            end
                            sprite = loadSprite(imageAnima,deadData.format, frameIndex);
                            frameIndex = frameIndex + deadData.frameInterval;
                            if i==1 then
                                image.sprite = sprite;
                                image:SetNativeSize();
                            end
                        end
                    end ---if deadData.frameCount~=0 then
                    if deadData.boxCollider then
                        --添加碰撞区
                        local boxCollider = deadAction:AddComponent(typeof(UnityEngine.BoxCollider));
                        local boxColliderData = deadData.boxCollider;
                        boxCollider.isTrigger = false;
                        if boxColliderData.center  then
                            boxCollider.center = Vector3.New(boxColliderData.center.x,boxColliderData.center.y,boxColliderData.center.z);
                        end
                        if boxColliderData.size then
                            boxCollider.size = Vector3.New(boxColliderData.size.x,boxColliderData.size.y,boxColliderData.size.z);
                        end
                    end  --if deadData.boxCollider then
                end

            end
        end
        local go =self.fishGOs[_type];
        local transform  = go.transform;
        --创建动画
        if fishStyleInfo.combType == G_GlobalGame.Enum_FishCombType.Single then
            --单个
            if fishStyleInfo.exStyles ~=nil then
                --拓展新的版本
                local nameStyle = fishStyleInfo.exStyles[go.name];
                if nameStyle then
                    ReplaceFishAction(transform,nameStyle);
                elseif fishStyleInfo.exStyles.default then
                    ReplaceFishAction(transform,fishStyleInfo.exStyles.default);
                else
                    ReplaceFishAction(transform,fishStyleInfo);
                end
            else
                --兼容以前的版本
                ReplaceFishAction(transform,fishStyleInfo);
            end
        else
            local childCount = transform.childCount;
            local child;
            for i=1,childCount do
                child = transform:GetChild(i-1);
                if fishStyleInfo.exStyles ~=nil then
                    --拓展新的版本
                    local nameStyle = fishStyleInfo.exStyles[child.gameObject.name];
                    if nameStyle then
                        ReplaceFishAction(child,nameStyle);
                    elseif fishStyleInfo.exStyles.default then
                        ReplaceFishAction(child,fishStyleInfo.exStyles.default);
                    else
                        ReplaceFishAction(child,fishStyleInfo);
                    end
                else
                    --兼容以前的版本
                    ReplaceFishAction(child,fishStyleInfo);
                end
            end
        end
    end
    return self.fishGOs[_type];
end

--获取fishCollider
function _CGOCreator:createFishCollider(_type)
    local name = "FishCollider";
    local go = self.fishTemplates.colliders[_type];
    if go then
    else
        local obj;
        if _type>= G_GlobalGame.Enum_FishType.FISH_KIND_25 and _type<= G_GlobalGame.Enum_FishType.FISH_KIND_27 then
            obj = self:LoadAsset(self._gameFishABName, "SanYuanCollider");
        elseif _type>= G_GlobalGame.Enum_FishType.FISH_KIND_28 and _type<= G_GlobalGame.Enum_FishType.FISH_KIND_30 then
            obj = self:LoadAsset(self._gameFishABName, "SiXiCollider");
        else
            obj = self:LoadAsset(self._gameFishABName, name);
        end 
        local fishStyleInfo = G_GlobalGame.FunctionsLib.FUNC_GetFishStyleInfo(_type);
        self.fishTemplates.colliders[_type] = newobject(obj);
        go = self.fishTemplates.colliders[_type];
        G_GlobalGame.FunctionsLib.FUNC_CacheGO(go,"Templates");
        local actionsData = fishStyleInfo.actions;
        if not actionsData then
            return ;
        end
        local moveData = actionsData.move;
        local deadData = actionsData.dead;

        if moveData and moveData.boxCollider then
            local addBoxCollider = function (go)
                --添加碰撞区
                local boxCollider = go:GetComponent(typeof(UnityEngine.BoxCollider));
                if boxCollider then
                else
                    boxCollider = go:AddComponent(typeof(UnityEngine.BoxCollider));
                end
                local boxColliderData = moveData.boxCollider;
                boxCollider.isTrigger = false;
                if boxColliderData.center  then
                    boxCollider.center = Vector3.New(boxColliderData.center.x,boxColliderData.center.y,boxColliderData.center.z);
                end
                if boxColliderData.size then
                    boxCollider.size = Vector3.New(boxColliderData.size.x,boxColliderData.size.y,boxColliderData.size.z);
                end
                return boxCollider;
            end
            --多个子节点
            local childCount = go.transform.childCount; 
            local child;
            if childCount>0  then
                for i=1,childCount do
                    child = go.transform:GetChild(i-1);
                    addBoxCollider(child.gameObject);
                end
            else
                addBoxCollider(go);
            end
        end
    end
    local obj= newobject(go);
    obj.name = name;
    return obj;
end

--创建新鱼的方法
function _CGOCreator:createFishNew(_type)
    --加载鱼
    local go = self:loadFish(_type);
    if not go then
        return nil;
    end
    local obj= newobject(go);
    obj.name = "Fish";
    return obj;
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
        local styleInfo = G_GlobalGame.FunctionsLib.FUNC_GetBulletStyleInfo(_type,_isOwner);
        local name= G_GlobalGame.FunctionsLib.FUNC_GetPrefabName(styleInfo.preType);
        local obj = self:LoadAsset(self._gameSceneABName, name);
        objs[_type] = newobject(obj);
        G_GlobalGame.FunctionsLib.FUNC_CacheGO(objs[_type],"Templates");
        G_GlobalGame.FunctionsLib.FUNC_AddAnimate(objs[_type],styleInfo.bodyAnima);
    end

    local obj= newobject(objs[_type]);
    obj.name = "Bullet";
    return obj;
end

--子弹碰撞区
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
        local styleInfo = G_GlobalGame.FunctionsLib.FUNC_GetBulletStyleInfo(_type,_isOwner);
        objs[_type] = newobject(obj);
        G_GlobalGame.FunctionsLib.FUNC_CacheGO(objs[_type],"Templates");
        if styleInfo.boxCollider then
            local boxCollider = objs[_type]:GetComponent(typeof(UnityEngine.BoxCollider));
            local boxColliderData = styleInfo.boxCollider;
            if boxCollider then
            else
                boxCollider = objs[_type]:AddComponent(typeof(UnityEngine.BoxCollider));
            end
            if boxColliderData.center  then
                boxCollider.center = Vector3.New(boxColliderData.center.x,boxColliderData.center.y,boxColliderData.center.z);
            end
            if boxColliderData.size then
                boxCollider.size = Vector3.New(boxColliderData.size.x,boxColliderData.size.y,boxColliderData.size.z);
            end
        end
    end
    local obj= newobject(objs[_type]);
    obj.name = name;
    return obj;
end

--创建鱼网
function _CGOCreator:createNet(_netType,_isOwner)
    --[[
    local name = "Net";
    if not self.netObj then
         self.netObj = self:LoadAsset(self._gameSceneABName, name);
    end
    local obj= newobject(self.netObj);
    obj.name = name;
    return obj;
    --]]
    if not self.netObjs[_netType] then
         self.netObjs[_netType] = GameObject.New();
         --放入缓存
         G_GlobalGame.FunctionsLib.FUNC_CacheGO(self.netObjs[_netType],"Templates");
         self.netObjs[_netType].name = "Template_Net";
         G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self.netObjs[_netType],G_GlobalGame.FunctionsLib.FUNC_GetNetAnimateType(_netType,_isOwner));
    end
    local obj= newobject(self.netObjs[_netType]);
    obj.name = "Net";
    return obj;
end

--创建flylayer
function _CGOCreator:createFlyLayer()
    if self.flyLayer then
        return newobject(self.flyLayer);
    end
    local name = "FlyLayer";
    self.flyLayer = self:LoadAsset(self._gameUIABName, name);
    local obj= newobject(self.flyLayer);
    obj.name = name;
    return obj;
end

function _CGOCreator:createPlayers()
    if self.players then
        return newobject(self.players);
    end
    local name = "Players";
    self.players = self:LoadAsset(self._gameUIABName, name);
    local obj= newobject(self.players);
    obj.name = name;
    return obj;
end

function _CGOCreator:getShader(_shaderId)
    if self.shaderTable[_shaderId] then
        return self.shaderTable[_shaderId];
    end
    local _shaderName = G_GlobalGame.FunctionsLib.FUNC_GetShaderName(_shaderId);
    self.shaderTable[_shaderId] = UnityEngine.Shader.Find(_shaderName);
    return self.shaderTable[_shaderId];
end

--创建左边玩家
function _CGOCreator:createLeftPlayer(isOwner)
    isOwner = isOwner or false;
    if isOwner then
        if self.leftSelfPlayer then
        else
            local name = "Player_Self";
            self.leftSelfPlayer = self:LoadAsset(self._gameUIABName, name);
        end
        local obj= newobject(self.leftSelfPlayer);
        obj.name = "Player";
        return obj;
    else
        if self.leftPlayer then
        else
            local name = "Player_Other";
            self.leftPlayer = self:LoadAsset(self._gameUIABName, name);
        end
        local obj= newobject(self.leftPlayer);
        obj.name = "Player";
        return obj;
    end

end

--创建右边玩家
function _CGOCreator:createRightPlayer(isOwner)
    isOwner = isOwner or false;
    if isOwner then
        if self.rightSelfPlayer then
        else
            local name = "Player_Self";
            self.rightSelfPlayer = self:LoadAsset(self._gameUIABName, name);
        end
        local obj= newobject(self.rightSelfPlayer);
        obj.name = "Player";
        return obj;
    else
        if self.rightPlayer then
        else
            local name = "Player_Other";
            self.rightPlayer = self:LoadAsset(self._gameUIABName, name);
        end
        local obj= newobject(self.rightPlayer);
        obj.name = "Player";
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
    local FunctionsLib = G_GlobalGame.FunctionsLib;
    local paotaiStyle = FunctionsLib.FUNC_GetPaotaiStyleInfo(_type,_isOwner);
    local styleType = paotaiStyle.preType;
    if not self.paotaiObjs[styleType] then
        local obj = self:LoadAsset(self._gameUIABName, G_GlobalGame.FunctionsLib.FUNC_GetPrefabName(styleType));
        self.paotaiObjs[styleType] = newobject(obj);
        FunctionsLib.FUNC_CacheGO(self.paotaiObjs[styleType],"Templates");
        local body = self.paotaiObjs[styleType].transform:Find("Body");
        FunctionsLib.FUNC_AddAnimate(body.gameObject,paotaiStyle.bodyAnima);
        local fire = self.paotaiObjs[styleType].transform:Find("Fire");
        FunctionsLib.FUNC_AddAnimate(fire.gameObject,paotaiStyle.fireAnima);
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
        self.lockItem[index] = self:LoadAsset(self._gameUIABName, G_GlobalGame.FunctionsLib.FUNC_GetLockTargetPrefabName(index));
    end
    local obj = newobject(self.lockItem[index]);
    return obj;
end

--创建锁定线
function _CGOCreator:createLockLine()
    if not self.lockLine then 
        self.lockLine = self:LoadAsset(self._gameUIABName, G_GlobalGame.FunctionsLib.FUNC_GetLockLinePrefabName());
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
        self.goldObj = self:LoadAsset(self._gamePlayerABName, "FlyGold");
    end
    local obj = newobject(self.goldObj);
    return obj;
    --]]
    if not self.goldObj then
         self.goldObj = GameObject.New();
         --放入缓存
         G_GlobalGame.FunctionsLib.FUNC_CacheGO(self.goldObj,"Templates");
         self.goldObj.name = "Template_FlyGold";
         G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self.goldObj,G_GlobalGame.Enum_AnimateType.FlyGold);
    end
    local obj= newobject(self.goldObj);
    --obj.name = "Net";
    return obj;
end

--创建飞银币的效果
function _CGOCreator:createSilver()
    --[[
    if not self.silverObj then
        self.silverObj = self:LoadAsset(self._gamePlayerABName, "FlySilver");
    end
    local obj = newobject(self.silverObj);
    return obj;
    --]]
    if not self.silverObj then
         self.silverObj = GameObject.New();
         --放入缓存
         G_GlobalGame.FunctionsLib.FUNC_CacheGO(self.silverObj,"Templates");
         self.silverObj.name = "Template_FlySilver";
         G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self.silverObj,G_GlobalGame.Enum_AnimateType.FlySilver);
    end
    local obj= newobject(self.silverObj);
    --obj.name = "Net";
    return obj;
end


--创建 金币堆
function _CGOCreator:createScoreColumn(index)
    if not self.scoreColumnObjs[index] then
        self.scoreColumnObjs[index] = self:LoadAsset(self._gameUIABName, G_GlobalGame.FunctionsLib.FUNC_GetScoreColumnPrefabName(index));
    end
    return newobject(self.scoreColumnObjs[index]);
end

--获取声音资源
function _CGOCreator:getMusic(_name,_abName)
    if not self.soundObjs[_name] then
        _abName = _abName or self._gameMusicABName;
        self.soundObjs[_name] = self:LoadAssetObj(_abName, _name);
    end
    return self.soundObjs[_name];
end

--创建一个新手引导
function _CGOCreator:createNewHand()
    if not self.newHandObj then
        local _name = "NewHandGuide";
        self.newHandObj = self:LoadAssetObj(self._gameUIABName, _name);
    end
    local obj = newobject(self.newHandObj);
    obj.name = "NewHandGuide";
    return obj;
end

--加载
function _CGOCreator:loadEffect(_type)
    if not self.bombEffectObj[_type] then
        --self.bombEffectObj[_type] = self:LoadAssetObj(self._gameSceneABName,G_GlobalGame.FunctionsLib.FUNC_GetEffectPrefabName(_type));
        if _type == G_GlobalGame.Enum_BombEffectType.Line or _type == G_GlobalGame.Enum_BombEffectType.PauseScreen  then
            local obj = self:LoadAsset(self._gameSceneABName,G_GlobalGame.FunctionsLib.FUNC_GetEffectPrefabName(_type));
            self.bombEffectObj[_type] = newobject(obj);
        else
            self.bombEffectObj[_type] = GameObject.New();
        end
        self.bombEffectObj[_type].name = "Template_BombEffect " .. _type;
        G_GlobalGame.FunctionsLib.FUNC_CacheGO(self.bombEffectObj[_type],"Templates");
        G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self.bombEffectObj[_type],G_GlobalGame.FunctionsLib.FUNC_GetEffectAnimaType(_type));
    end
end

--创建爆炸效果
function _CGOCreator:createBombEffect(_type)
    if not self.bombEffectObj[_type] then
        --self.bombEffectObj[_type] = self:LoadAssetObj(self._gameSceneABName,G_GlobalGame.FunctionsLib.FUNC_GetEffectPrefabName(_type));
        if _type == G_GlobalGame.Enum_BombEffectType.Line or _type == G_GlobalGame.Enum_BombEffectType.PauseScreen  then
            local obj = self:LoadAsset(self._gameSceneABName,G_GlobalGame.FunctionsLib.FUNC_GetEffectPrefabName(_type));
            self.bombEffectObj[_type] = newobject(obj);
        else
            self.bombEffectObj[_type] = GameObject.New();
        end
        self.bombEffectObj[_type].name = "Template_BombEffect " .. _type;
        G_GlobalGame.FunctionsLib.FUNC_CacheGO(self.bombEffectObj[_type],"Templates");
        G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self.bombEffectObj[_type],G_GlobalGame.FunctionsLib.FUNC_GetEffectAnimaType(_type));
    end
    return newobject(self.bombEffectObj[_type]);
end

--得到锁定的目标图片
function _CGOCreator:getLockFishFlag(_type)
    if not self.lockFlagSprite[_type] then
        self.lockFlagSprite[_type] = self:getCommonSprite(self._gameUIABName,G_GlobalGame.FunctionsLib.FUNC_GetLockFishFlagPrefabName(_type));
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
        local cacheSpritePatch = self:LoadAssetObj(_abname,"SpritePatch");
        if cacheSpritePatch then
            local spriteRender = cacheSpritePatch.transform:Find(_spriteName);
            if spriteRender then
                abSprite[_spriteName] = spriteRender:GetComponent("SpriteRenderer").sprite;
            end
        else
            abSprite[_spriteName] = self:LoadAssetObj(_abname,_spriteName);
        end
    end
    return abSprite[_spriteName];
end

--
function _CGOCreator:createHelpPanel()
    return self:createHelpObjs("Help");
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


--清除内存
function _CGOCreator:clear()
    self.gameSceneObj =nil;
    coroutine.start(
        function ()
            coroutine.wait(1);
            --ResManager:Unload(self._gameUIABName);
            --ResManager:Unload(self._gameSceneABName);
            --ResManager:Unload(self._gameFishABName);
            --ResManager:Unload(self._gamePlayerABName);
            --ResManager:Unload(self._gameMusicABName);
            --ResManager:Unload(self._gameHelpABName);
            --释放ab资源
            for key, value in pairs(self.abName) do  
                Util.Unload(key);  
            end 
        end
    );
end



--function _CGOCreator:

return _CGOCreator;
