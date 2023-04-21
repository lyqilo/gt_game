local GameObjManager=class("GameObjManager");

local StoneObj  = GameRequire("SI_StoneObj");

local DisappearObj  = GameRequire("SI_DisappearObj");

local idCreator = ID_Creator(1);
local StoneInfo = {
    [idCreator()]       = {format = "by%02d",           frame=30, begin=1,},
    [idCreator()]       = {format = "biyu%02d",         frame=30, begin=1,},
    [idCreator()]       = {format = "my%02d",           frame=30, begin=1,},
    [idCreator()]       = {format = "mn%02d",           frame=30, begin=1,},
    [idCreator()]       = {format = "hp%02d",           frame=30, begin=1,},
    [idCreator()]       = {format = "zml%02d",          frame=30, begin=1,},
    [idCreator()]       = {format = "mys%02d",          frame=30, begin=1,},
    [idCreator()]       = {format = "zsj%02d",          frame=30, begin=1,},
    [idCreator()]       = {format = "fc%02d",           frame=30, begin=1,},
    [idCreator()]       = {format = "zz%02d",           frame=30, begin=1,},
    [idCreator()]       = {format = "hbs%02d",          frame=30, begin=1,},
    [idCreator()]       = {format = "green%02d",        frame=30, begin=1,},
    [idCreator()]       = {format = "jbs%02d",          frame=30, begin=1,},
    [idCreator()]       = {format = "lbs%02d",          frame=30, begin=1,},
    [idCreator()]       = {format = "zs%02d",           frame=30, begin=1,},
    [idCreator(100)]    = {format = "yuanzhui%02d",     frame=30, begin=1,},
};

SI_ShaderID= {
    Custom_User_MyMask         =   idCreator(1),
};


local SI_ShaderName={
    [SI_ShaderID.Custom_User_MyMask]               =   "custom/user/MyMask",
};


local EffectInfo = {
    [SI_EFFECT_TYPE.Brick_Disappear     ] = {format = "jinzhuan_1_%05d",frame=6,creator=DisappearObj,interval=0.02,},
    [SI_EFFECT_TYPE.Brick2_Disappear    ] = {format = "jinzhuan_2_%05d",frame=6,creator=DisappearObj,interval=0.02,},
    [SI_EFFECT_TYPE.Stone_Disappear     ] = {format = "bao_%05d",       frame=7,creator=DisappearObj,interval=0.02,begin=1},
    [SI_EFFECT_TYPE.Comb_Fire           ] = {format = "combo_%05d",     frame=15,creator=DisappearObj,interval=0.07,},
    [SI_EFFECT_TYPE.Logo                ] = {format = "logo_%03d",      frame=6,creator=DisappearObj,interval=0.16,begin=1},
};

local MusicInfo = {
    [SI_MUSIC_TYPE.StoneFallDown_BG_1]  = "longzhuduobaobgm",
    [SI_MUSIC_TYPE.StoneFallDown_BG_2]  = "longzhuduobaobgm",
    [SI_MUSIC_TYPE.StoneFallDown_BG_3]  = "longzhuduobaobgm",
    [SI_MUSIC_TYPE.StoneFallDown_BG]    = "ballFallDownBg",
    [SI_MUSIC_TYPE.Dragon_BG]           = "longzhuduobaobgm",
    [SI_MUSIC_TYPE.Stone_FallDown]      = "obj_falldown",
    [SI_MUSIC_TYPE.Stone_Disappear]     = "stone_disappear",
    [SI_MUSIC_TYPE.Brick_Disappear]     = "drill_disappear",
    [SI_MUSIC_TYPE.Drill_Disappear]     = "drill_disappear",
    [SI_MUSIC_TYPE.DragonBallFallDown]  = "ballFallDown",
    [SI_MUSIC_TYPE.DragonUpgrade]       = "DragonUpgrade",
    [SI_MUSIC_TYPE.Stone_Clear]         = "stone_clear",
    [SI_MUSIC_TYPE.FireBurnning]        = "fireBurnning",  --火炉燃烧声音
}

local function getKey(_class,_type)
    return _class .. "_" .. _type;
end
local Enum_ObjectType = {
    GameObject= 0,
    Sprite = 1,
    Music = 2,
};
--游戏对象管理
function GameObjManager:ctor(_cachePool)
    self._map = map:new();
    self._assetBundleName   = "module24/game_serialindiana";
    self._musicBundleName   = "module24/game_serialindiana_music";
    self._comResBundleName  = "game_serialindiana_com_res";
    self._resV1BundleName   = "game_serialindiana_res_v1";
    self._lineDetailObj     = nil;
    self._stoneObj          = nil;
    self._stoneObjs         = {};
    self._stoneSprites      = {};
    self._effectObj         = nil;
    self._effectObjs        = {};
    self._effectSprites     = {};
    self._fallStonePanel    = nil;
    self._alertPanel        = nil;
    self._alertOKPanel      = nil;
    self._alertOKStaticPanel= nil;
    self._dragonBallPanel   = nil;
    self._bgMusic           = nil;
    if _cachePool then
        self._cacheObj          = _cachePool.gameObject;
        self._cacheObjTransform = _cachePool;
    end
    self._musicObjs         = {};
    self._stageNames        = {};
    self._dragonStageImage  = {};
    self._shaderObjs        = {};
    self._nameSprites       = {};
    self._playerItemObj     = nil;
    self._resObjs           = nil;
    self._resObjsNew        = nil;
    self._playerInfoPanel   = nil;
    self._dragonEffect      = nil;

    self.helpObjs           = {};
    --[[
    local obj               = ResManager:LoadAsset(self._assetBundleName,"ResObjs");
    self._ResObjs           = newobject(obj);
    self._stoneObjsPool     = self._ResObjs:Find("Stone");
    self._uiObjsPool        = self._ResObjs:Find("UI");
    self._effectObjsPool    = self._ResObjs:Find("Effect");
    --]]
	    local unitySceneAB = GameObject.Find("UnitySceneAB");
    self.scenePoolTrans = unitySceneAB.transform:Find("Pool");
    self.cacheAbName = {};
    self.abMap = map:new();
end

function GameObjManager:SetCacheTransform(_cachePool)
    if _cachePool then
        self._cacheObj          = _cachePool.gameObject;
        self._cacheObjTransform = _cachePool;
    end
end

--压栈
function GameObjManager:Push(_gameObj)
    local key = getKey(_gameObj._class,_gameObj._type);
    local vec = self._map:value(key);
    if vec==nil then
        vec = vector:new();
        self._map:insert(key,vec);
    end
    vec:push_back(_gameObj);
    _gameObj:SetParent(self._cacheObjTransform);
end

--出栈
function GameObjManager:Pop(_class,_type)
    local key = getKey(_class,_type);
    local vec = self._map:value(key);
    if vec==nil or vec:size()==0 then
        return nil;
    end
    local obj = vec:pop();
    obj:SetParent(nil);
    return obj;
end

--获取物体 指向SI_GameObj
function GameObjManager:GetObj(_class,_type)

end

--得到石头游戏体
function GameObjManager:GetStoneObj(_type)
    local obj = self:Pop(SI_OBJ_CLASS.Stone,_type);
    if obj then
       return obj; 
    end
    obj = self:CreateStoneObj(_type);
    return StoneObj.New(_type,obj);
end

--获取线详情游戏体
function GameObjManager:CreateLineDetailObj()
    if not self._lineDetailObj then
        self._lineDetailObj = self:LoadAsset(self._assetBundleName, "LineDetail");
    end
    log("加载一个宝石详情物体");
    return newobject(self._lineDetailObj);
end


--创建宝石游戏体
function GameObjManager:CreateStoneObj(_type)
    if not self._stoneObj then
        self._stoneObj = self:LoadAsset(self._assetBundleName, "stone");
    end
    if not self._stoneObjs[_type] then
        self._stoneObjs[_type]  = newobject(self._stoneObj);
        local imageAnima        = self._stoneObjs[_type]:GetComponent("ImageAnima");
		if imageAnima==nil then imageAnima= Util.AddComponent("ImageAnima",self._stoneObjs[_type]) end 
        local image             = self._stoneObjs[_type]:GetComponent("Image");
        local stoneInfo         = StoneInfo[_type];
        local sprite;
        local objName;
        if stoneInfo==nil then
            error("IsNil...");
        end
        self._stoneSprites[_type] = self._stoneSprites[_type] or {};
        local beginFrame = stoneInfo.begin or 0;
        for i=1,stoneInfo.frame do
            objName = string.format(stoneInfo.format,(i - 1 + beginFrame));
            if self._stoneSprites[_type][i] then
                sprite = self._stoneSprites[_type][i];
            else
                sprite = self:LoadAssetObj(self._assetBundleName,objName,Enum_ObjectType.Sprite);
                self._stoneSprites[_type][i] = sprite;
            end
            imageAnima:AddSprite(sprite);
        end
        image.sprite        = imageAnima.lSprites[0];
        imageAnima.fSep     = SI_GAME_CONFIG.StonePlayInterval;
        self._stoneObjs[_type].transform.parent = self._cacheObj.transform;
    end
    local obj = newobject(self._stoneObjs[_type]);
    obj.name = "stone";
    local imageAnima = obj:GetComponent("ImageAnima");
    imageAnima:StopAndRevert();
    imageAnima:PlayAlways();
    return obj;
end

--主panel
function GameObjManager:CreateMainPanel()
    if not self._mainPanel then
        self._mainPanel = self:LoadAsset(self._assetBundleName,"MainPanel");
        --[[
        local objs=GameObject.FindGameObjectsWithTag("GuiCamera");
        if objs[0].name == "GuiCamera" then
            local camera = self._mainPanel:Find("Camera");
            if camera then
                camera.gameObject:SetActive(false);
            end
        end
        --]]
    end
    return newobject(self._mainPanel);
end

--创建游戏落宝石场景
function GameObjManager:CreateFallStonePanel()
    if not self._fallStonePanel then
        self._fallStonePanel = self:LoadAsset(self._assetBundleName,"FallStonePanel");
    end
    return newobject(self._fallStonePanel);
end

--创建提示框
function GameObjManager:CreateAlert()
    if not self._alertPanel then
        self._alertPanel = self:LoadAsset(self._assetBundleName,"Alert");
    end
    return newobject(self._alertPanel);
end


--创建提示框
function GameObjManager:CreateAlertOK()
    if not self._alertOKPanel then
        self._alertOKPanel = self:LoadAsset(self._assetBundleName,"AlertOK");
    end
    return newobject(self._alertOKPanel);
end

function GameObjManager:CreateAlertStatic()
    if not self._alertOKStaticPanel then
        self._alertOKStaticPanel = self:LoadAsset(self._assetBundleName,"AlertPanel");
    end
    return newobject(self._alertOKStaticPanel);
end

--创建龙珠关卡
function GameObjManager:CreateDragonBallMission()
    if not self._dragonBallPanel then
        self._dragonBallPanel = self:LoadAsset(self._assetBundleName,"DragonBallPanel");
    end
    return newobject(self._dragonBallPanel);
end


--清除
function GameObjManager:Clear()
    self._lineDetailObj = nil;
    ResManager:Unload(self._assetBundleName);
end

--得到宝石sprite
function GameObjManager:GetStoneSprite(_type)
    local stoneInfo         = StoneInfo[_type];
    local beginFrame = stoneInfo.begin or 0;
    if not self._stoneSprites[_type] then
        self._stoneSprites[_type]       = {};
        local name = string.format(stoneInfo.format,beginFrame);
        self._stoneSprites[_type][1]    = self:LoadAssetObj(self._assetBundleName,name,Enum_ObjectType.Sprite);
    end
    return self._stoneSprites[_type][1];
end


--效果
function GameObjManager:CreateEffectObj(_type)
    if not self._effectObj then
        self._effectObj = self:LoadAsset(self._assetBundleName, "EffectObj");
    end
    if not self._effectObjs[_type] then
        self._effectObjs[_type] = newobject(self._effectObj);
        local imageAnima        = self._effectObjs[_type]:GetComponent("ImageAnima");
		if imageAnima==nil then imageAnima= Util.AddComponent("ImageAnima",self._effectObjs[_type])  end 
        local image             = self._effectObjs[_type]:GetComponent("Image");
        local effect            = EffectInfo[_type];
        local sprite;
        self._effectSprites[_type] = self._effectSprites[_type] or {};
        local name 
        local beginFrame = effect.begin or 0;
        for i=1,effect.frame do
            name    = string.format(effect.format,(i - 1 + beginFrame));
            if self._effectSprites[_type][i] then
            else
                sprite = self:LoadAssetObj(self._assetBundleName,name,Enum_ObjectType.Sprite);
                self._effectSprites[_type][i] = sprite; 
            end
            imageAnima:AddSprite(sprite);
        end
        image.sprite        = imageAnima.lSprites[0];
        if effect.interval then
            imageAnima.fSep     = effect.interval;
        end
        self._effectObjs[_type].transform.parent = self._cacheObj.transform;
    end
    local obj           = newobject(self._effectObjs[_type]);
    obj.name            = "effect_" .. _type;
    local imageAnima    = obj:GetComponent("ImageAnima");
    imageAnima:StopAndRevert();
    return obj;
end




--得到石头游戏体
function GameObjManager:GetEffectObj(_type)
    local obj = self:Pop(SI_OBJ_CLASS.Effect,_type);
    if obj then
       return obj; 
    end
    obj = self:CreateEffectObj(_type);
    return EffectInfo[_type].creator.New(_type,obj);
end

function GameObjManager:GetBGMusic()
    if self._bgMusic ==nil  then
        local chipRes = self:LoadAssetObj(self._musicBundleName, "lhdb_bg",Enum_ObjectType.Music);
        self._bgMusic = chipRes;     
    end
    return self._bgMusic;
end


function GameObjManager:GetMusic(_type)
    if self._musicObjs[_type]==nil then
        --error("MusicName:"  .. MusicInfo[_type]);
        local chipRes = self:LoadAssetObj(self._musicBundleName, MusicInfo[_type],Enum_ObjectType.Music);
        self._musicObjs[_type] = chipRes;     
    end
    return self._musicObjs[_type];
end

function GameObjManager:GetLevelImage(_stage)
    if self._stageNames[_stage] then
        return self._stageNames[_stage];
    end
    local name = string.format("words-%d",_stage);
    self._stageNames[_stage] = self:LoadAssetObj(self._assetBundleName,name,Enum_ObjectType.Sprite);
    return self._stageNames[_stage];
--    if self._stageNames[_stage] then
--        return self._stageNames[_stage];
--    end
--    local name = string.format("UI/words-%d",_stage);
--    local objs = self:GetResObjs();
--    local child = objs.transform:Find(name);
--    self._stageNames[_stage] = child:GetComponent("Image").sprite;
--    return self._stageNames[_stage];
end


function GameObjManager:GetPlayerItem()
    if self._playerItemObj then
        return newobject(self._playerItemObj);
    end
    self._playerItemObj = self:LoadAssetObj(self._assetBundleName,"PlayerItem");
    return newobject(self._playerItemObj);
end



function GameObjManager:LoadAssetObj(abName,fileName,objType)
    local obj = self:LoadFromScenceCache(abName,fileName,objType);
    if obj then
        return obj;
    end
    error("load fileName:" .. fileName);
    self.abMap:insert(abName,1);
    local obj=ResManager:LoadAssetObj(abName,fileName);
    if not obj then error("Load abName["..abName.."] bundleName["..fileName.."] is nil")  end
    return obj;
end

function GameObjManager:LoadAsset(abName,fileName)
    local obj = self:LoadFromScenceCache(abName,fileName);
    if obj then
        return obj;
    end
    self.abMap:insert(abName,1);
    local obj=ResManager:LoadAsset(abName,fileName);
    if not obj then error("Load abName["..abName.."] bundleName["..fileName.."] is nil")  end
    return obj;
end

function GameObjManager:LoadFromScenceCache(abName,obName,objType)
    local name = abName .. "/" .. obName;
    objType = objType and objType or  Enum_ObjectType.GameObject;
    if (self.cacheAbName[name]) then
        if objType==Enum_ObjectType.Music then
            return self.cacheAbName[name].music;
        elseif objType==Enum_ObjectType.Sprite then
            return self.cacheAbName[name].sprite;
        else
            return self.cacheAbName[name].obj;    
        end
    end
    self.cacheAbName[name] = {};
    local tranform = self.scenePoolTrans:Find(name);
    if not tranform then
        return ;
    end
    self.cacheAbName[name].obj = tranform.gameObject;
    if objType==Enum_ObjectType.Music then
        self.cacheAbName[name].music = tranform:GetComponent("AudioSource").clip; 
        return self.cacheAbName[name].music; 
    elseif objType==Enum_ObjectType.Sprite then
        self.cacheAbName[name].sprite = tranform:GetComponent("SpriteRenderer").sprite; 
        return self.cacheAbName[name].sprite; 
    else
        return self.cacheAbName[name].obj; 
    end 
end

--通知龙珠等级
function GameObjManager:GetDragonLevelImage(_stage)
    if self._dragonStageImage[_stage] then
        return self._dragonStageImage[_stage];
    end
    local name = string.format("zi_%d",_stage);

    self._dragonStageImage[_stage] = self:LoadAssetObj(self._assetBundleName,name,Enum_ObjectType.Sprite);
    return self._dragonStageImage[_stage];
--    if self._dragonStageImage[_stage] then
--        return self._dragonStageImage[_stage];
--    end
--    local name = string.format("UI/Dragon Ball-%d",_stage+2);
--    local objs = self:GetResObjs();
--    local child = objs.transform:Find(name);
--    self._dragonStageImage[_stage] = child:GetComponent("Image").sprite;
--    return self._dragonStageImage[_stage];
end

--获取shader
function GameObjManager:GetShader(_shaderId)
    if self._shaderObjs[_shaderId] then
        return self._shaderObjs[_shaderId];
    end
    if not SI_ShaderName[_shaderId] then
        return nil;
    end
    self._shaderObjs[_shaderId] = UnityEngine.Shader.Find(SI_ShaderName[_shaderId]);
    return self._shaderObjs[_shaderId];
end


--得到通用的精灵
function GameObjManager:GetCommonSprite(_name)
    if self._nameSprites[_name] then
        return self._nameSprites[_name];
    end
    self._nameSprites[_name] = self:LoadAssetObj(self._assetBundleName,_name,Enum_ObjectType.Sprite);
    return self._nameSprites[_name];
end



--放入缓存池
function GameObjManager:PushToCache(_transform)
    _transform:SetParent(self._cacheObjTransform);    
end

--function GameObjManager:GetSprite(_name,_index)
--    LoadAssetWithSubAssets
--end

--获取资源游戏体
function GameObjManager:GetResObjsNew()
    if (self._resObjsNew==nil) then
        local obj = self:LoadAsset(self._assetBundleNameEx1,"ResObjsNew");
        self._resObjsNew = newobject(obj);
        self._resObjsNew.transform:SetParent(self._cacheObjTransform);
    end
    return self._resObjsNew;
end

--获取资源游戏体
function GameObjManager:GetResObjs()
    if (self._resObjs==nil) then
        local obj = self:LoadAsset(self._assetBundleNameEx2,"ResObjs");
        self._resObjs = newobject(obj);
        self._resObjs.transform:SetParent(self._cacheObjTransform);
    end
    return self._resObjs;
end

--创建帮助窗口
function GameObjManager:CreateHelpPanel()
    if self.helpObj == nil then
        self.helpObj = self:LoadAsset(self._assetBundleName,"Help");
    end
    return newobject(self.helpObj);
end

--
function GameObjManager:createHelpObjs(name)
   if name==nil then
        return ;
    end
    if not self.helpObjs[name] then
        self.helpObjs[name] = self:LoadAssetObj(self._assetBundleName,name);
    end
    return newobject(self.helpObjs[name]);
end

--创建玩家信息
function GameObjManager:CreatePlayerInfoPanel()
    if (self._playerInfoPanel==nil) then
        self._playerInfoPanel = self:LoadAsset(self._assetBundleName,"PlayerInfoPanel");
    end
    local obj =  newobject(self._playerInfoPanel);
    obj.name = "PlayerInfoPanel";
    destroyObj(self._playerInfoPanel);
    self._playerInfoPanel = nil;
    return obj;
end

--龙珠效果
function GameObjManager:CreateDragonEffect()
    if (self._dragonEffect==nil) then
        self._dragonEffect = self:LoadAsset(self._assetBundleName,"DragonEffect");
    end
    local obj =  newobject(self._dragonEffect);
    obj.name = "DragonEffect";
    return obj;
end

function GameObjManager:CreateJiLeiDetail()
    if (self._jileiObj==nil) then
        self._jileiObj = self:LoadAsset(self._musicBundleName,"JiLeiDetail");
    end
    local obj =  newobject(self._jileiObj);
    obj.name = "JiLeiDetail";
    return obj;
end

--卸载
function GameObjManager:Unload()
    self._map:clear();
    self._map = nil;
    self._nameSprites= nil;
    self._alertPanel=nil;
    self._dragonEffect=nil;
    self._playerInfoPanel =nil;
    self._playerItemObj = nil;
    for i=1,SI_MAX_STAGE do
        self._stageNames[i]=nil;
    end
    self._stageNames = nil;
    self._dragonStageImage = nil;
    self._shaderObjs = nil;
    self._musicObjs = nil;
    self._effectObj = nil;
    self._effectObjs = nil;
    self._stoneSprites = nil;
    self._lineDetailObj= nil;
    self._dragonBallPanel = nil;
    self._alertOKStaticPanel = nil;
    self._alertOKPanel = nil;
    self._fallStonePanel = nil;
    self._mainPanel = nil;
    --销毁缓冲池
    destroy(self._cacheObj);
    coroutine.start(
        function()
            coroutine.wait(0.5);
--            ResManager:Unload(self._assetBundleName);
--            ResManager:Unload(self._musicBundleName);
--            ResManager:OnCler();
            local it = self.abMap:iter();
            local val= it();
            while(val) do
                Unload(val);
                val = it();
            end
            self.abMap:clear();
        end
    
    );

    --ResManager:Unload(self._comResBundleName);
end

return GameObjManager;