local ExternalLibs  = require "Common.ExternalLibs";
local _CGlobalGame = class("_CGlobalGame");
local SoundControl = GameRequire__("SoundManager");

local _KeyEvent = GameRequire__("KeyEvent");
local _EventSystem = GameRequire__("EventSystem");

local GameControl     = GameRequire__("GameControl");
local CUILayer = GameRequire__("UILayer");
local _idCreator = ID_Creator(0);
local idCreator  = ID_Creator(0);

local everError;

function _CGlobalGame:ctor()
    self._cachePool     = nil;
    self._beginTickCount= 0;
    self._runTime       = 0;
    self._isInitSuccess = false;
    self._soundCtrl = SoundControl.New();
    self._cacheObjs     = {};

    self._helpPanelCreator = GameRequire__("HelpPanel");
    self._helpPanel        = nil;

    --初始化环境变量
    self:_initAppConstant();
    everError = error;
end

--打开日志
function _CGlobalGame:openLog()
    self._fileOut       = io.open("d:\\fishLog.txt", "w+");
    error = function(str)
        self:writeLog(str);
        everError(str);
    end
end

function _CGlobalGame:writeLog(str)
    if self._fileOut then
        self._fileOut:write(str .. "\r\n");
        self._fileOut:flush();
    end
end

function _CGlobalGame:closeLog()
    if self._fileOut then
        self._fileOut:close();
        error = everError;
        self._fileOut = nil;
    end
end

function _CGlobalGame:isOpenLog()
    return self._fileOut~=nil;
end

function _CGlobalGame:Init()
    --事件初始化
    _EventSystem.NewLib();
    _KeyEvent.NewLib();

    --常量
    self.ConstDefine                = {
        --非法座位号
        C_S_INVALID_CHAIR_ID        = -1,
        --非法用户ID
        C_S_INVALID_USER_ID        = -1,
        --玩家个数
        C_S_PLAYER_COUNT            = 4,
        --非法的子弹类型
        C_S_INVALID_BULLET_TYPE     = 0xffff,
        --非法炮台类型 
        C_S_INVALID_PAOTAI_TYPE     = 0,
        --玩家昵称的长度
        C_S_PLAYER_NAME_LEN         = 32,
        --游戏对应的ID
        GAME_ID                     = 39,
        GAME_VERSION                = 1,
        C_S_STRING_NULL             = "",
    };

    --物品类型
    self.Enum_ObjType = {
        Invalid= idCreator(-1), --无效  -1
        Bullet = idCreator(),   --子弹  0
        Monster= idCreator(),   --怪物  1
        Shadow = idCreator(),   --阴影  2
    };

    --坐标
    self.Enum_ZOrder = {
        Monster = 0,
        Shadow  = 3,
    };

    --事件定义
    self.Enum_EventID               = {
        --系统事件
        SYSTEM                  = idCreator(0), --系统        0
        SYS_PlayEffect          = idCreator(), --播放音效      1
        SYS_PlayBackgroundSound = idCreator(), --播放背景音乐   2
        SYS_StopBackgroundSound = idCreator(), --停止北京音乐   3

        --局部事件
        PRIVATE            = idCreator(3000),   --3000

        --全局的事件
        GLOBAL              = idCreator(10000), --全局          10000
        GameConfig          = idCreator(),  --游戏设置          10001
        GameData            = idCreator(), --游戏数据           10002
        ChairsData          = idCreator(), --椅子数据           10003
        UserEnter           = idCreator(), --玩家進入           10004
        UserLeave           = idCreator(), --玩家離開           10005
        NotifySceneInfo     = idCreator(), --通知场景消息       10006
        NotifyEnterGame     = idCreator(), --通知进入游戏成功   10007
        UserScore           = idCreator(), --通知玩家分数改变   10008
        --c-->s
        StartGame           = idCreator(), --开始游戏           10009
        StartBallGame       = idCreator(), --开始点球           10010

        --s-->c
        ResponseStartGame   = idCreator(), --开始游戏 10011 
        ResponseBallGame    = idCreator(), --点球10012
        ResponseCaijin      = idCreator(), --彩金10013

        NotifyUIGameDataCB  = idCreator(), --通知UI游戏数据回来
        NotifyUIStartGameCB = idCreator(), --通知UI开始游戏 10014
        NotifyUIBallGameCB  = idCreator(), --通知UI点球游戏 10015
        NotifyUICaijin      = idCreator(), --通知UI彩金     10016

        ChangeBet           = idCreator(), --改变下注       10017
    };

    --键值对定义
    self.Enum_KeyValue               = 
    {
        Null                = _idCreator(0),--预留备用 0
        GetScenePixelSize   = _idCreator(), --得到场景像素大小 1
        GetIsInSwitchScene  = _idCreator(), --是否在切换鱼潮 2
        GetRealSceneSize    = _idCreator(), --得到展示窗口大小,3
        GetSceneIsRotation  = _idCreator(), --获取场景是否旋转了 4
        GetShadowObject     = _idCreator(), --获取影子对象 5
        GetUserGold         = _idCreator(), --获得用户金币 6
        GetFreeCount        = _idCreator(), --获取免费次数 7
        GetBet              = _idCreator(), --获取下注值 8
        GetGameState        = _idCreator(), --获取游戏状态 9
        GetGameRet          = _idCreator(), --获取游戏结算 10
        GetGameBallRet      = _idCreator(), --获取游戏足球比赛 11
        GetCaijin           = _idCreator(), --获取彩金 12
        GetCanStartGame     = _idCreator(), --开始游戏 13
        GetMultiple         = _idCreator(), --获取倍率 14
        GetFreeTotal        = _idCreator(), --获取免费统计 15
    };

    --金币类型
    self.Enum_GoldType              = {
        Gold   = _idCreator(0),   --0
        Silver = _idCreator(),    --1
    };

    --方向
    self.Enum_Toward = {
        Front  = _idCreator(1), --前  1
        Back   = _idCreator(),  --后  2
        Up     = _idCreator(),  --上  3 
        Down   = _idCreator(),  --下  4
        Left   = _idCreator(),  --左  5
        Right  = _idCreator(),  --右  6
    };


    self.GameCommandDefine = {

        --服务器协议  S-->C
        SC_CMD = {
            Game_Config             = idCreator(100),   --游戏配置   100
            Game_Data               = idCreator(),  --用于断线重连   101
            StartGame               = idCreator(),  --开始游戏       102
            StartBallGame           = idCreator(),  --点球大战       103
            ResponseCaiJin          = idCreator(),  --彩金           104
        }, 

        --目前只有这几个协议  C-->S
        CS_CMD = {
            StartGame               = idCreator(1), --开始游戏   1
            StartBallGame           = idCreator(),  --小游戏    2
            RequestCaiJin           = idCreator(),  --请求彩金  3
        },

        --一些命令的码值
        CMD_CODE ={
            SendPaoCode = 0x3135,
            CatchFishCode= 0x7322,
        },
    };

    --声音类型定义
    self.SoundDefine = {
        BG1         = idCreator(),--4
        BG2         = idCreator(),--5
        BG3         = idCreator(),--6
        BG4         = idCreator(),--7
        Main        = idCreator(),--8
        Pao1        = idCreator(),--9
        Pao2        = idCreator(),--10
        Pao3        = idCreator(),--11
        Pao4        = idCreator(),--12
        Pao5        = idCreator(),--13
        BossDead    = idCreator(),--14
        LianDaoDead = idCreator(),--15
        DaEMoDead   = idCreator(),--16
        WolfManDead = idCreator(),--17
        SnowManDead = idCreator(),--18
        XixueGuiDead= idCreator(),--19
        UpScore     = idCreator(),--20
        DownScore   = idCreator(),--21
        GetCoin     = idCreator(),--22
        Attack      = idCreator(),--23
        ChangePao   = idCreator(),--24
        HitMonster  = idCreator(),--25
    };

    --初始化声音引擎
    self:_initSoundEngine();
    --初始化游戏配置
    self:_initGameConfig();
    --初始化其他配置
    self:_initOtherConfig();
    --初始化预制体名字
    self:_initPrefabName();
    --初始化函数
    self:_initFunctions();
    -- 初始化sprite列表
    self:_initSpritePlist();
end

function _CGlobalGame:_initSoundEngine()
    self._soundCtrl:Init();
end

function _CGlobalGame:_initConstValue()
    self.RunningPlatform = Application.platform;
    self.IsEditor        = Application.isEditor;
    RuntimePlatform.AndroidPlayer = 11;
end

--???????ó???
function _CGlobalGame:_initAppConstant()
    --常量
    self.ConstantValue = {
        IsLandscape = true, --是否横屏
        IsPortrait  = false, --是否竖屏
        MatchScreenWidth = 1334,
        MatchScreenHeight = 750,
        RealScreenWidth = 1334,
        RealScreenHeight = 750,
        CanvasRate  = 1,
    };
    if Util.isPc then
        self.ConstantValue.IsLandscape = true; 
        self.ConstantValue.IsPortrait = false; 
    else
    	self.ConstantValue.IsLandscape = false; 
        self.ConstantValue.IsPortrait = true;    	
    end

end

function _CGlobalGame:GetCanvasRate()
    return self.ConstantValue.CanvasRate;
end

function _CGlobalGame:InitSystem(_canvasRate,_uiCamera)
    if self.ConstantValue.IsLandscape then
        _canvasRate.referenceResolution = Vector2.New(self.ConstantValue.MatchScreenWidth,self.ConstantValue.MatchScreenHeight);
        _uiCamera.transform.localEulerAngles = Quaternion.identity;
    else
        _canvasRate.referenceResolution = Vector2.New(self.ConstantValue.MatchScreenHeight,self.ConstantValue.MatchScreenWidth);
        _uiCamera.transform.localEulerAngles =Quaternion.Euler(0,0,90);
    end
    SetCanvasScalersMatch(_canvasRate);
    --_canvasRate.matchWidthOrHeight = self.ConstantValue.CanvasRate;
        --??????
    local matchRate = self.ConstantValue.MatchScreenWidth/self.ConstantValue.MatchScreenHeight;
    --?Щ???????
    if self.ConstantValue.IsLandscape then
        --?????С
        if Util.isAndroidPlatform or Util.isApplePlatform then
            self.ConstantValue.RealScreenWidth = Screen.width;
            self.ConstantValue.RealScreenHeight = Screen.height;
        elseif Util.isEditor then
--            self.ConstantValue.RealScreenWidth = Screen.width;
--            --self.ConstantValue.RealScreenHeight = Screen.height;      
--            self.ConstantValue.RealScreenHeight = Screen.width/matchRate;    
            self.ConstantValue.RealScreenWidth = Screen.width;
            self.ConstantValue.RealScreenHeight = Screen.height;   
        elseif Util.isPc then
            --self.ConstantValue.RealScreenWidth = 1334;--Screen.width;
            --self.ConstantValue.RealScreenHeight = 750;--Screen.height;
            self.ConstantValue.RealScreenWidth = Screen.width;
            self.ConstantValue.RealScreenHeight= Screen.height;
        else
            self.ConstantValue.RealScreenWidth = Screen.width;--Screen.width;
            self.ConstantValue.RealScreenHeight = Screen.height;--Screen.height;
        end


        local bili = self.ConstantValue.RealScreenWidth/self.ConstantValue.RealScreenHeight;
        if math.abs(bili-matchRate)<=0.001 then
            AlignViewExClass.setScreenArgs(self.ConstantValue.RealScreenWidth,self.ConstantValue.RealScreenHeight,
            self.ConstantValue.MatchScreenWidth,self.ConstantValue.MatchScreenHeight,true);
            self.ConstantValue.CanvasRate = 0;
        elseif bili>matchRate then
            AlignViewExClass.setScreenArgs(self.ConstantValue.RealScreenWidth,self.ConstantValue.RealScreenHeight,
            self.ConstantValue.MatchScreenWidth,self.ConstantValue.MatchScreenHeight,false);
            self.ConstantValue.CanvasRate = 1;
        else
            --AlignViewExClass.setScreenArgs(self.ConstantValue.RealScreenWidth,self.ConstantValue.RealScreenHeight,
                --self.ConstantValue.MatchScreenWidth,self.ConstantValue.MatchScreenHeight,true);
            self.ConstantValue.CanvasRate = 0;
        end

    elseif self.ConstantValue.IsPortrait then
        self.ConstantValue.RealScreenWidth = Screen.height;
        self.ConstantValue.RealScreenHeight = Screen.width;
        local bili = self.ConstantValue.RealScreenWidth/self.ConstantValue.RealScreenHeight;
        if math.abs(bili-matchRate)<=0.001 then
            AlignViewExClass.setScreenArgs(self.ConstantValue.RealScreenWidth,self.ConstantValue.RealScreenHeight,
            self.ConstantValue.MatchScreenWidth,self.ConstantValue.MatchScreenHeight,false);
            self.ConstantValue.CanvasRate = 1;
        elseif bili>matchRate then
            AlignViewExClass.setScreenArgs(self.ConstantValue.RealScreenWidth,self.ConstantValue.RealScreenHeight,
            self.ConstantValue.MatchScreenWidth,self.ConstantValue.MatchScreenHeight,true);
            self.ConstantValue.CanvasRate = 0;
        else
            AlignViewExClass.setScreenArgs(self.ConstantValue.RealScreenWidth,self.ConstantValue.RealScreenHeight,
            self.ConstantValue.MatchScreenWidth,self.ConstantValue.MatchScreenHeight,false);
            self.ConstantValue.CanvasRate = 1;
        end
    end
    _canvasRate.matchWidthOrHeight = self.ConstantValue.CanvasRate;
end


function _CGlobalGame:_initFunctions()
    --函数库
    self.FunctionsLib = GameRequire__("Functions");
    self.FunctionsLib.FunctionInit(self);
end


function _CGlobalGame:_initPrefabName()
--预制体类型
    self.Enum_PrefabType            = {
        InvalidType             = _idCreator(0xff),
        Test                    = _idCreator(1),
    };
    local PrefabType = self.Enum_PrefabType;
    self.GameConfig = self.GameConfig or {};
    self.GameConfig.PrefabName  = {
        [PrefabType.Test           ] = {prefabName = "Test"         ,abName=nil },
    };
end

function _CGlobalGame:_initGameConfig()
    self.GameConfig = self.GameConfig or {};
    self.GameConfig.
        --场景配置
        SceneConfig = {
            goldColumn          = 3, --最多显示金堆列数
            goldColumnTime      = 5, --金堆显示5秒
            goldColumnMoveSpeed = 80, --移动速度
            goldColumnDis       = 45, --间隔
            wheelDisplayTime    = 5, --摩天轮显示时间
            pauseScreenTime     = 20, --定屏
            bombRound           = 300, --爆炸范围，局部炸弹
            createGoldInterval  = 0.01, --金币爆出的时间间隔
            flyGoldSpeed        = 700, --飞金币速度
            FrameCount          = 40,   --40帧
            iBulletLiveTime     = 16,   --子弹存活时间
            iPosTipTime         = 4,    --位置提示显示4秒
            isAutoShot          = false, --是否自动发炮
        };
end

function _CGlobalGame:_initOtherConfig()

end

function _CGlobalGame:_initSpritePlist()
    self.Enum_Sprite_Tag = {
        NumGold     = _idCreator(),  --游戏分数
        NumSilver   = _idCreator(),  --获得分数
        NumGold1    = _idCreator(),  --获得分数
        NumSilver1  = _idCreator(),  --获得分数
        NumContinue = _idCreator(),  --获得分数
        AddScore    = _idCreator(),  --炮台获取分数
    };
    local SpriteTag = self.Enum_Sprite_Tag;
    self.SpritePlistInfo = {
        [SpriteTag.NumGold] = {
            abFileName = "game_fb_ui",
            spriteName = "0\\,1\\,2\\,3\\,4\\,5\\,6\\,7\\,8\\,9\\,w\\,y\\,.\\,,\\,K\\,T\\,M\\,B",
            spriteSuffix = "numgold/",
        },
        [SpriteTag.NumSilver] = {
            abFileName = "game_fb_ui",
            spriteName = "0\\,1\\,2\\,3\\,4\\,5\\,6\\,7\\,8\\,9\\,w\\,y\\,.\\,m\\,j\\,x\\,,\\,K\\,T\\,M\\,B",
            spriteSuffix = "numsilver/",
        },
        [SpriteTag.NumGold1] = {
            abFileName = "game_fb_ui",
            spriteName = "0\\,1\\,2\\,3\\,4\\,5\\,6\\,7\\,8\\,9\\,.\\,,\\,g\\,K\\,T\\,M\\,B",
            spriteSuffix = "numgold1/",
        },
        [SpriteTag.NumSilver1] = {
            abFileName = "game_fb_ui",
            spriteName = "0\\,1\\,2\\,3\\,4\\,5\\,6\\,7\\,8\\,9\\,.\\,,\\,K\\,T\\,M\\,B",
            spriteSuffix = "numsilver1/",
        },
        [SpriteTag.NumContinue] = {
            abFileName = "game_fb_ui",
            spriteName = "0\\,1\\,2\\,3\\,4\\,5\\,6\\,7\\,8\\,9\\,x\\,.\\,,\\,K\\,T\\,M\\,B",
            spriteSuffix = "numcontinue/",
        },
    };
    self._spritePlists = {};
end
--获取SpritePlist
function _CGlobalGame:GetSpritePlist(_spritePlistTag)
    if self._spritePlists[_spritePlistTag] then
        return self._spritePlists[_spritePlistTag];
    end
    local spritePlistInfo = self.SpritePlistInfo[_spritePlistTag];
    if not spritePlistInfo then
        return nil;
    end
    local sprName = string.split(spritePlistInfo.spriteName, "\\,");
    local count = #sprName;
    local sprite;
    local sprites = {};
    local name ;
    for i=1,count do
        name = sprName[i];
        sprite = G_GlobalGame._goFactory:getCommonSprite(spritePlistInfo.abFileName,
            spritePlistInfo.spriteSuffix .. name);
        sprites[name] = sprite;
    end
    self._spritePlists[_spritePlistTag] =  sprites;
    return sprites;
end

--分发事件
function _CGlobalGame:DispatchEventByStringKey(_eventStr,_eventData)
    if (self.Enum_EventID[_eventStr])==nil then
        return 
    end
    _EventSystem.DispatchEvent(self.Enum_EventID[_eventStr],_eventData);
end

--注册事件
function _CGlobalGame:RegEventByStringKey(_eventStr,_obj,_handler)
    if (self.Enum_EventID[_eventStr])==nil then
        return 
    end
    _EventSystem.RegEvent(self.Enum_EventID[_eventStr],_obj,_handler);
end

--缓存物体
function _CGlobalGame:CacheObject(cobject,cacheName)
    if self._cachePool then
        local position = cobject:Position();
        local localScale    = cobject:LocalScale();
        local localRotation = cobject:LocalRotation();
        if cacheName and cacheName~=String.Empte then
            local obj  = self._cacheObjs[cacheName];
            if not obj then
                obj = GameObject.New();
                obj.name = cacheName;
                obj = obj.transform;
                obj:SetParent(self._cachePool);  
                self._cacheObjs[cacheName] = obj;
            end
            cobject:SetParent(obj);  
        else
            cobject:SetParent(self._cachePool);        
        end
        cobject:SetPosition(position);
        cobject:SetLocalScale(localScale);
        cobject:SetLocalRotation(localRotation);
        return true;
    else
        cobject:Destroy();
        return false;
    end
end

--缓存游戏体
function _CGlobalGame:CacheGO(gameObject,cacheName)
    if gameObject==nil then
        return false;
    end
    if self._cachePool then
        local localPosition = gameObject.transform.localPosition;
        local localScale    = gameObject.transform.localScale;
        local localRotation = gameObject.transform.localRotation;
        if cacheName and cacheName~=String.Empte then
            local obj  = self._cacheObjs[cacheName];
            if not obj then
                obj = GameObject.New();
                obj.name = cacheName;
                obj = obj.transform;
                obj:SetParent(self._cachePool);  
                self._cacheObjs[cacheName] = obj;
            end
            gameObject.transform:SetParent(obj);  
        else
            gameObject.transform:SetParent(self._cachePool);
        end
        gameObject.transform.localPosition = localPosition;
        gameObject.transform.localScale    = localScale;
        gameObject.transform.localRotation = localRotation;
        return true; 
    else
        destroy(gameObject);
        return false;
    end
end

function _CGlobalGame:GetGameRunTime()
    return self._runTime;
end

function _CGlobalGame:FixedUpdate(_dt)
    self._soundCtrl:Update(_dt);
    self._runTime = self._runTime + _dt*1000;
end

--打开帮助界面
function _CGlobalGame:OpenHelpPanel()
    if not self._helpPanel then
        self._helpPanel = self._helpPanelCreator.Create(self._systemLayer);
    end
    self._helpPanel:OnOpen();
end

function _CGlobalGame:CreateUILayer()
    --创建UI
    local uilayer = CUILayer.Create(self._contentLayer);
    self._ui = uilayer;
    return true;
end

function _CGlobalGame:Update(_dt)
    if self._ui then
        self._ui:Update(_dt);
    end
    if self._helpPanel then
        self._helpPanel:Update(_dt);
    end
end
return _CGlobalGame;