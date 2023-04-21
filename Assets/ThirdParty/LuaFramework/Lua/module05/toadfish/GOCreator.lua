
import ".Functions";

local _CGOCreator=class("_CGOCreator");

--缓存ab资源里预制体、图片、shader的引用，不用每次都重新从ab里获取，游戏退出后，统一卸载ab资源就好，也减少了动态申请内存的次数

function _CGOCreator:ctor()
    self._gameUIABName      = 'module05/game_toadfish_ui';
    self._gameSceneABName   = 'module05/game_toadfish_scene';
    self._gameFishABName    = 'module05/game_toadfish_fishes';
    self._gamePlayerABName  = 'module05/game_toadfish_player';
    self._gameMusicABName   = 'module05/game_toadfish_music';
    self._gameHelpABName    = 'module05/game_toadfish_help'; --帮助 ab资源
    self._gameUIV1ABName    = 'module05/game_toadfish_ui_v1'; --ui v1 ab资源
    self.mainPanelObj= nil;
    self.gameSceneObj= nil;
    self.uiObj       = nil;
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
    self.fishNetObjs = {
        self = {},
        other= {},
    };

    --鱼的新方式
--    self.fishModelObj  ={};
--    self.fishGOs = {};
--    self.fishSprites = {};
    self.fishTemplates = {
        gos  = {
            
        },
        colliders = {
            
        },
        sprites = {
        },
        modelObjs = {
        },
    };

    --ab资源里对应的sprite
    self.abCommonSprite = {};

    --帮助的
    self.helpObjs = {};
    --所有的abName;
    self.abName = {};
    --shader表
    self.shaderTable = {};
    --
    self.cacheAssetbundle = GameObject.Find("Unity3dAssetbundle");
    self.cacheAssetbundleTrans = self.cacheAssetbundle.transform
    self.cacheAbName = {};
end

--预加载一些东西
function _CGOCreator:PreLoad()
    for i=G_GlobalGame.Enum_FishType.FISH_KIND_1,G_GlobalGame.Enum_FishType.FISH_KIND_COUNT do
        self:loadFish(i);
    end
    --self:loadFish(G_GlobalGame.Enum_FishType.FISH_KIND_1);
end

--创建主窗口
function _CGOCreator:createMainPanel()
    if self.mainPanelObj then
        return newobject(self.mainPanelObj);
    end
    local name = "MainPanel";
    self.mainPanelObj= self:LoadAsset(self._gameUIABName, name);
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

function _CGOCreator:LoadAsset(abName,obName)
    local obj = self:LoadFromScenceCache(abName,obName);
    if obj then
        return obj;
    end
    self.abName[abName] = 1;
    --error("Load AbName:" .. abName .. ",ObjName:" .. obName);
    local obj = ResManager:LoadAsset(abName, obName);
    if obj==nil then
        error("Failed load AbName:" .. abName .. ",ObjName:" .. obName);
    end
    return obj;
end

function _CGOCreator:LoadAssetObj(abName,obName)
    --self.abName[abName] = 1;
    --return ResManager:LoadAssetObj(abName, obName);
    local obj = self:LoadFromScenceCache(abName,obName);
    if obj then
        return obj;
    end
    self.abName[abName] = 1;
    local obj = LoadAssetObj(abName, obName);
    if obj==nil then
        error("Failed load AbName:" .. abName .. ",ObjName:" .. obName);
    end
    return obj;
end

function _CGOCreator:loadFish(_type)
    local fishStyleInfo = G_GlobalGame.FunctionsLib.FUNC_GetFishStyleInfo(_type);
    local fishGOs = self.fishTemplates.gos;
    local fishModelObjs = self.fishTemplates.modelObjs;
    local fishSprites   = self.fishTemplates.sprites;
    if not fishGOs[_type] then
        if not fishModelObjs[fishStyleInfo.modelName] then
            fishModelObjs[fishStyleInfo.modelName] = self:LoadAsset(self._gameFishABName, fishStyleInfo.modelName);
        end
        fishGOs[_type] = newobject(fishModelObjs[fishStyleInfo.modelName]);
        --destroyObj(self.fishModelObj[fishStyleInfo.modelName]);
        --放入缓存
        G_GlobalGame.FunctionsLib.FUNC_CacheGO(fishGOs[_type],"Templates");
        fishGOs[_type].name = "Template_Fish " .. _type;
        local function ReplaceFishAction(transform,fishStyleInfo)
            local bg =transform:Find("Bg");
            local sprite;
            if bg then
                --先换背景
                if fishStyleInfo.bg.type == G_GlobalGame.Enum_FishUnderPanType.Group then
                    --大三元或者大四喜
                    local bgImage = bg.gameObject:AddComponent(typeof(UnityEngine.UI.Image));
                    local bgName = "dish";
                    if not fishSprites[bgName] then
                        sprite = self:getCommonSprite(self._gameFishABName, bgName);
                        fishSprites[bgName] = sprite;
                    else
                        sprite = fishSprites[bgName];
                    end
                    bgImage.sprite = sprite;
                    bgImage:SetNativeSize();
                    bgImage.raycastTarget = false;
                elseif fishStyleInfo.bg.type == G_GlobalGame.Enum_FishUnderPanType.Boss then
                    --鱼王
                    local bgImage = bg.gameObject:AddComponent(typeof(UnityEngine.UI.Image));
                    local bgName = "halo";

                    if not fishSprites[bgName] then
                        sprite = self:getCommonSprite(self._gameFishABName, bgName);
                        fishSprites[bgName] = sprite;
                    else
                        sprite = fishSprites[bgName];
                    end
                    bgImage.sprite = sprite;
                    bgImage:SetNativeSize();
                    bgImage.raycastTarget = false;
                elseif fishStyleInfo.bg.type == G_GlobalGame.Enum_FishUnderPanType.Custom then  
                    --自定义 
                    local bgImage = bg.gameObject:AddComponent(typeof(UnityEngine.UI.Image));
                    local bgName = fishStyleInfo.bg.fileName;
                    if not fishSprites[bgName] then
                        sprite = self:getCommonSprite(self._gameFishABName, bgName);
                        fishSprites[bgName] = sprite;
                    else
                        sprite = fishSprites[bgName];
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
            end

            local function loadSprite(imageAnima,format,frameIndex)
                local str =string.format(format, frameIndex);
                local sprite;
                if not fishSprites[str] then
                    sprite = self:getCommonSprite(self._gameFishABName, str);
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
                    boxCollider.isTrigger = true;
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
                        boxCollider.isTrigger = true;
                        if boxColliderData.center  then
                            boxCollider.center = Vector3.New(boxColliderData.center.x,boxColliderData.center.y,boxColliderData.center.z);
                        end
                        if boxColliderData.size then
                            boxCollider.size = Vector3.New(boxColliderData.size.x,boxColliderData.size.y,boxColliderData.size.z);
                        end
                    end
                end
            end
        end
        local go = fishGOs[_type];
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
    return fishGOs[_type];
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
                boxCollider.isTrigger = true;
                if boxColliderData.center  then
                    boxCollider.center = Vector3.New(boxColliderData.center.x,boxColliderData.center.y,boxColliderData.center.z);
                end
                if boxColliderData.size then
                    boxCollider.size = Vector3.New(boxColliderData.size.x,boxColliderData.size.y,boxColliderData.size.z);
                end
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
         self.netObj = ResManager:LoadAsset(self._gameSceneABName, name);
    end
    local obj= newobject(self.netObj);
    obj.name = name;
    return obj;
    --]]
    local tab = nil;
    if _isOwner then
        tab = self.fishNetObjs.self;
    else
        tab = self.fishNetObjs.other;
    end
    
    if not tab[_netType] then
         tab[_netType] = GameObject.New();
         --放入缓存
         G_GlobalGame.FunctionsLib.FUNC_CacheGO(tab[_netType],"Templates");
         tab[_netType].name = "Template_Net " .. _netType;
         G_GlobalGame.FunctionsLib.FUNC_AddAnimate(tab[_netType],G_GlobalGame.FunctionsLib.FUNC_GetNetAnimateType(_netType,_isOwner));
    end
    local obj= newobject(tab[_netType]);
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

--创建玩家
function _CGOCreator:createPlayer(isOwner)
    isOwner = isOwner or false;
    if isOwner then
        if self.selfPlayer then
        else
            local name = "Player_Self";
            self.selfPlayer = self:LoadAsset(self._gameUIABName, name);
        end
        local obj= newobject(self.selfPlayer);
        obj.name = "Player";
        return obj;
    else
        if self.otherPlayer then
        else
            local name = "Player_Other";
            self.otherPlayer = self:LoadAsset(self._gameUIABName, name);
        end
        local obj= newobject(self.otherPlayer);
        obj.name = "Player";
        return obj;
    end

end

--创建左边玩家
function _CGOCreator:createLeftPlayer(isOwner)
    isOwner = isOwner or false;
    if isOwner then
        if self.leftSelfPlayer then
        else
            local name = "Player_Left";
            self.leftSelfPlayer = self:LoadAsset(self._gameUIABName, name);
        end
        local obj= newobject(self.leftSelfPlayer);
        obj.name = "Player";
        return obj;
    else
        if self.leftPlayer then
        else
            local name = "Player_Left_Other";
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
            local name = "Player_Right";
            self.rightSelfPlayer = self:LoadAsset(self._gameUIABName, name);
        end
        local obj= newobject(self.rightSelfPlayer);
        obj.name = "Player";
        return obj;
    else
        if self.rightPlayer then
        else
            local name = "Player_Right_Other";
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
        self.goldObj = ResManager:LoadAsset(self._gamePlayerABName, "FlyGold");
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
        self.silverObj = ResManager:LoadAsset(self._gamePlayerABName, "FlySilver");
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

function _CGOCreator:createContinueShot()
    if not self.continueShotObj  then
        self.continueShotObj = ResManager:LoadAsset(self._gameUIABName, "ContinueShotStatus_v1");
    end
    return newobject(self.continueShotObj);
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

--创建爆炸效果
function _CGOCreator:createBombEffect(_type)
    if not self.bombEffectObj[_type] then
        --self.bombEffectObj[_type] = ResManager:LoadAssetObj(self._gameSceneABName,G_GlobalGame.FunctionsLib.FUNC_GetEffectPrefabName(_type));
        if _type == G_GlobalGame.Enum_BombEffectType.Line then
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
