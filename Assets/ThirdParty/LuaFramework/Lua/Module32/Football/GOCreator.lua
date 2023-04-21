
import ".Functions"

local _CGOCreator=class("_CGOCreator");

--缓存ab资源里预制体、图片、shader的引用，不用每次都重新从ab里获取，游戏退出后，统一卸载ab资源就好，也减少了动态申请内存的次数
local loadType = 
{
    null = 0,
    sprite=1,
    music =2,
};
function _CGOCreator:ctor(unity3dCache)
    self._gameCommonABName  = 'game_fb_common';  --公用
    self._gameEntryABName   = 'game_fb_entry';  --入口
    self._gameUIABName      = 'game_fb_ui';    --UI
    self._gameSceneABName   = 'game_fb_scene'; --场景
    self._gameEffectABName  = 'game_fb_effect'; --特效
    self._gameMusicABName   = 'game_fb_music'; --

    self.mainPanelObj= nil;
    self.gameSceneObj= nil;
    self.uiObj       = nil;
    self.fishNetObj  = nil;
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
    self.playerInfoBgs = {};
    --
    self.comObjs = {};

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

    self.moduleName = "module32";

    self.unity3DABCache = unity3dCache or GameObject.Find("Unity3dAssetbundle");
    self.unity3DABCacheTrans = self.unity3DABCache.transform;
    self.unityCacheObjs = {};
end

function _CGOCreator:SetUnity3DCache(unity3dCache)
    self.unity3DABCache = unity3dCache;
end

--预加载一些东西
function _CGOCreator:PreLoad()

end

--创建主窗口
function _CGOCreator:createMainPanel()
    if self.mainPanelObj then
        --return newobject(self.mainPanelObj);
        return self.mainPanelObj;
    end
    
    local name = "MainPanel";
    self.mainPanelObj= self:LoadAsset(self._gameEntryABName, name);
    if not self.mainPanelObj then
        error("obj [" .. self._gameEntryABName  .. ":" .. name .. "] ab not exist");
        return nil;
    end
    local obj= self.mainPanelObj;--newobject(self.mainPanelObj);
    obj.name = name;
    return obj;
    
end

--创建游戏场景
function _CGOCreator:createGameScene()
    if self.gameSceneObj then
        --return newobject(self.gameSceneObj);
        return self.gameSceneObj;
    end
    local name = "GameScene";
    self.gameSceneObj= self:LoadAsset(self._gameSceneABName, name);
    if not self.gameSceneObj then
        error("obj [" .. self._gameSceneABName  .. ":" .. name .. "] ab not exist");
        return nil;
    end
    local obj= self.gameSceneObj; --newobject(self.gameSceneObj);
    obj.name = name;
    return obj;
end

--创建UI部分
function _CGOCreator:createUIPart()
    if self.uiObj then
        return self.uiObj; --newobject(self.uiObj);
    end
    local name = "UIPart";
    self.uiObj= self:LoadAsset(self._gameUIABName, name);
    local obj= self.uiObj;--newobject(self.uiObj);
    obj.name = name;
    return obj;
end

--创建游戏中UI
function _CGOCreator:createGameUI()
    if self.gameUIObj then
        return self.gameUIObj; --newobject(self.gameUIObj);
    end
    local name = "GameUI";
    self.gameUIObj = self:LoadAsset(self._gameUIABName, name);
    local obj= self.gameUIObj; --newobject(self.gameUIObj);
    obj.name = name;
    return obj;
end

--创建结算
function _CGOCreator:createBalance()
    if self.gameBalanceUIObj then
        return self.gameBalanceUIObj;
    end
    local name = "Balance";
    self.gameBalanceUIObj = self:LoadAsset(self._gameUIABName, name);
    local obj= self.gameBalanceUIObj; --newobject(self.gameUIObj);
    obj.name = name;
    return obj;
end

function _CGOCreator:createBalanceFront()
    if self.gameBalanceFrontUIObj then
        return self.gameBalanceFrontUIObj;
    end
    local name = "FlyCaidai";
    self.gameBalanceFrontUIObj = self:LoadAsset(self._gameUIABName, name);
    local obj= self.gameBalanceFrontUIObj; --newobject(self.gameUIObj);
    obj.name = name;
    obj.transform:Find("diceng"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")
    return obj;
end

--创建免费次数
function _CGOCreator:createFreeTotal()
    if self.freeTotalUIObj then
        return self.freeTotalUIObj;
    end
    local name = "FreeTotal";
    self.freeTotalUIObj = self:LoadAsset(self._gameUIABName, name);
    local obj = self.freeTotalUIObj;
    obj.transform:Find("BG"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
    obj.name = name;
    return obj;
end

--创建加载界面
function _CGOCreator:createLoadPanel()
    if self.loadPanelObj then
        return self.loadPanelObj; --newobject(self.loadPanelObj);
    end
    local name = "LoadPanel";
    self.loadPanelObj = self:LoadAsset(self._gameUIABName, name);
    local obj= self.loadPanelObj; --newobject(self.loadPanelObj);
    obj.name = name;
    return obj;
end

function _CGOCreator:loadAssetFromCache(_abname,_obName,_type)
    local obj
    if self.unity3DABCache then
        local name = _abname .. '/' .. _obName;
        self.unityCacheObjs[name] = self.unityCacheObjs[name] or { isLoad = false,obj=nil};
        obj = self.unityCacheObjs[name].obj;
        if not obj then
            if not self.unityCacheObjs[name].isLoad then
                obj = self.unity3DABCacheTrans:Find(name);
                if obj then
                    if _type==loadType.sprite then
                        local spriteRenderer = obj:GetComponent(SpriteRendererClassType);
                        if spriteRenderer then
                            obj = spriteRenderer.sprite;
                        else
                            spriteRenderer = obj:GetComponent(ImageClassType);
                            if spriteRenderer then
                                obj = spriteRenderer.sprite;
                            else
                                obj = nil;
                            end
                        end
                    elseif _type==loadType.music then
                        local audioSource = obj:GetComponent(AudioSourceClassType);
                        if audioSource then
                            obj = audioSource.clip;
                        else
                            obj = nil;
                        end  
                    else
                        obj = obj.gameObject;
                    end
                end
                self.unityCacheObjs[name].obj = obj;
                self.unityCacheObjs[name].isLoad = true;
            end 
        end
    end
    return obj; 
end

function _CGOCreator:LoadAsset(abName,obName,_type)
    --error("Load AbName:" .. abName .. ",ObjName:" .. obName);
    local rabName = self.moduleName  .. "/" .. abName;
    local obj = self:loadAssetFromCache(rabName,obName,_type);
    if obj then
        return obj,true;
    end
    self.abName[rabName] = 1;
    local obj = ResManager:LoadAsset(rabName, obName);
    if obj==nil then
        error("Failed load AbName:" .. abName .. ",ObjName:" .. obName);
    end
    return obj,false;
end

function _CGOCreator:LoadAssetObj(abName,obName,_type)
    --self.abName[abName] = 1;
    --return ResManager:LoadAssetObj(abName, obName);
    local rabName = self.moduleName  .. "/" .. abName;
    local obj = self:loadAssetFromCache(rabName,obName,_type);
    if obj then
        return obj,true;
    end
    self.abName[rabName] = 1;
    obj = ResManager:LoadAssetObj(rabName, obName);
    if obj==nil then
        error("Failed load AbName:" .. abName .. ",ObjName:" .. obName);
    end
    return obj,false;
end

function _CGOCreator:createBullet(_abName,_prefabName)
    if _prefabName==nil then
        return ;
    end
    _abName = _abName or self._gameSceneABName;
    if not self.bulletObjs[_prefabName] then
        self.bulletObjs[_prefabName] = self:LoadAssetObj(_abName,_prefabName);
    end
    return newobject(self.bulletObjs[_prefabName]);
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
        return self.players; --newobject(self.players);
    end
    local name = "Players";
    self.players = self:LoadAsset(self._gameUIABName, name);
    local obj= self.players; --newobject(self.players);
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
        local obj,isCache = self:LoadAsset(self._gameUIABName, G_GlobalGame.FunctionsLib.FUNC_GetPrefabName(styleType));
        if (isCache) then
            self.paotaiObjs[styleType] = obj;
        else
            self.paotaiObjs[styleType] = newobject(obj);
            FunctionsLib.FUNC_CacheGO(self.paotaiObjs[styleType],"Templates");
        end
--        local body = self.paotaiObjs[styleType].transform:Find("Body");
--        FunctionsLib.FUNC_AddAnimate(body.gameObject,paotaiStyle.bodyAnima);
--        local fire = self.paotaiObjs[styleType].transform:Find("Fire");
--        FunctionsLib.FUNC_AddAnimate(fire.gameObject,paotaiStyle.fireAnima);
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


--获取声音资源
function _CGOCreator:getMusic(_name,_abName)
    if not self.soundObjs[_name] then
        _abName = _abName or self._gameMusicABName;
        self.soundObjs[_name] = self:LoadAssetObj(_abName, _name,loadType.music);
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


--得到锁定的目标图片
function _CGOCreator:getLockFishFlag(_type)
    return self:getCommonSprite(self._gameUIABName,G_GlobalGame.FunctionsLib.FUNC_GetLockFishFlagPrefabName(_type));
end


--获取公用sprite
function _CGOCreator:getCommonSprite(_abname,_spriteName)
    local abSprite;
    if not self.abCommonSprite[_abname] then
        self.abCommonSprite[_abname] = {};
    end
    abSprite = self.abCommonSprite[_abname];
    if not abSprite[_spriteName] then
        abSprite[_spriteName] = self:LoadAsset(_abname,_spriteName,loadType.sprite);
    end
    return abSprite[_spriteName];
end


--获取公用sprite
function _CGOCreator:getUICommonSprite(_spriteName)
    return self:getCommonSprite(self._gameUIABName,_spriteName);
end

--获取公用sprite
function _CGOCreator:getSceneCommonSprite(_spriteName)
    return self:getCommonSprite(self._gameSceneABName,_spriteName);
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

--创建怪物
function _CGOCreator:createMonster(_abName,_prefabName)
    if _prefabName==nil then
        return ;
    end
    _abName = _abName or self._gameSceneABName;
    if not self.monsterModelObjs[_prefabName] then
        self.monsterModelObjs[_prefabName] = self:LoadAssetObj(_abName,_prefabName);
    end
    return newobject(self.monsterModelObjs[_prefabName]);
end

--创建怪物
function _CGOCreator:createCommon(_abName,_prefabName)
    if _prefabName==nil then
        return ;
    end
    self.comObjs[_abName] = self.comObjs[_abName] or {};
    local comObjs = self.comObjs[_abName];
    if not comObjs[_prefabName] then
        comObjs[_prefabName] = self:LoadAssetObj(_abName,_prefabName);
    end
    return newobject(comObjs[_prefabName]);
end

function _CGOCreator:createSceneCommon(_prefabName)
    return self:createCommon(self._gameSceneABName,_prefabName);
end

--创建影子
function _CGOCreator:createShadow()
    local obj = self:LoadAssetObj(self._gameSceneABName,"touying");
    return newobject(obj);
end

function _CGOCreator:AsyncPreLoad(_runTime,_data)
    return true;
end


--清除内存
function _CGOCreator:clear()
    self.gameSceneObj =nil;
    coroutine.start(
        function ()
            coroutine.wait(0.5);
            --ResManager:Unload(self._gameUIABName);
            --ResManager:Unload(self._gameSceneABName);
            --ResManager:Unload(self._gameFishABName);
            --ResManager:Unload(self._gamePlayerABName);
            --ResManager:Unload(self._gameMusicABName);
            --ResManager:Unload(self._gameHelpABName);
            --释放ab资源
            for key, value in pairs(self.abName) do  
                ResManager:Unload(key);  
            end 
        end
    );
end



--function _CGOCreator:

return _CGOCreator;
