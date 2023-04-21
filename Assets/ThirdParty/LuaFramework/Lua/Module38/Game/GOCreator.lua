
import ".Functions";

local _CGOCreator=class("_CGOCreator");

--缓存ab资源里预制体、图片、shader的引用，不用每次都重新从ab里获取，游戏退出后，统一卸载ab资源就好，也减少了动态申请内存的次数
local loadType = 
{
    null = 0,
    sprite=1,
    music =2,
};
function _CGOCreator:ctor(unity3dCache)
    self.moduleName = "module38";
    self._gameCommonABName  = 'game_common';  --公用
    self._gameEntryABName   = 'game_entry';  --入口
    self._gameUIABName      = 'game_ui';    --UI
    self._gameSceneABName   = 'game_scene'; --场景
    self._gameEffectABName  = 'game_effect'; --特效
    self._gameMusicABName   = 'game_music'; --

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

    --ab资源里对应的sprite
    self.abCommonSprite = {};

    --帮助的
    self.helpObjs = {};
    --所有的abName;
    self.abName = {};
    --shader表
    self.shaderTable = {};

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

function _CGOCreator:createUIPartShu()
    if self.uiObj then
        return self.uiObj; --newobject(self.uiObj);
    end
    local name = "UIPart";
    self.uiObj= self:LoadAsset(self._gameUIABName, "UIPart_shu");
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
    --obj.transform:Find("Whole/jinbi_dajiang"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")
    obj.name = name;
    return obj;
end

function _CGOCreator:createBalanceShu()
    if self.gameBalanceUIObj then
        return self.gameBalanceUIObj;
    end
    local name = "Balance";
    self.gameBalanceUIObj = self:LoadAsset(self._gameUIABName, "Balance_shu");
    local obj= self.gameBalanceUIObj; --newobject(self.gameUIObj);
    --obj.transform:Find("Whole/jinbi_dajiang"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")
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
    self.abName[rabName] = 1

    obj =LoadAssetObj(rabName, obName);
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


function _CGOCreator:getShader(_shaderId)
    if self.shaderTable[_shaderId] then
        return self.shaderTable[_shaderId];
    end
    local _shaderName = G_GlobalGame.FunctionsLib.FUNC_GetShaderName(_shaderId);
    self.shaderTable[_shaderId] = UnityEngine.Shader.Find(_shaderName);
    return self.shaderTable[_shaderId];
end

--获取声音资源
function _CGOCreator:getMusic(_name,_abName)
    if not self.soundObjs[_name] then
        _abName = _abName or self._gameMusicABName;
        self.soundObjs[_name] = self:LoadAssetObj(_abName, _name,loadType.music);
    end
    return self.soundObjs[_name];
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


--创建普通对象
function _CGOCreator:createCommon(_abName,_prefabName)
    if _prefabName==nil then
        return ;
    end
    self.comObjs[_abName] = self.comObjs[_abName] or {};
    local comObjs = self.comObjs[_abName];
    if not comObjs[_prefabName] then
        comObjs[_prefabName] = self:LoadAssetObj(_abName,_prefabName);
    end
    local obj
    if _prefabName=="+1" or  _prefabName=="+1_shu" then
        obj=comObjs[_prefabName]
        -- +1   +1_shu 
        obj.transform:GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("dian"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("guang"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("xx"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("caijinhuo (3)"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("guang (1)"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")
    end

    if _prefabName=="zimuhuo_shu" or  _prefabName=="zimuhuo" then
        obj=comObjs[_prefabName]
        -- +1   +1_shu 
        obj.transform:GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("dian (1)"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("zimuhuo (1)"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")
    end

    if _prefabName=="mfyx_shu" or  _prefabName=="mfyx" then
        obj=comObjs[_prefabName]
        -- +1   +1_shu 
        obj.transform:GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("caijinhuo (3)"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("caijinhuo (3)/huo2"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("caijinhuo (3)/dian"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("caijinhuo (3)/huo2 (3)"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("huo2 (1)"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("huo2 (2)"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("mfyx (1)"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("mfyx (2)"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("huo2 (4)"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
    end

    if _prefabName=="huo" then
        obj=comObjs[_prefabName]
        obj.transform:GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
    end

    return newobject(obj);
end

function _CGOCreator:createUICommon(_prefabName)
    return self:createCommon(self._gameUIABName,_prefabName);
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
            --释放ab资源
            for key, value in pairs(self.abName) do  
                Util.Unload(key);  
            end 
        end
    );
end

return _CGOCreator;
