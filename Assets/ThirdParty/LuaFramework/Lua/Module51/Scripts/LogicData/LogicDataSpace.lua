--[[    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2019-08-20 17:41:57
]]
LogicDataSpace = {};
local self = LogicDataSpace;

---小游戏中间滚动图标数量
self.MINIICONS = 4
---桌面图标最大数量
self.MAX_ALLICON = 15
---最大线数
self.MAX_LINES = 9
---最大筹码数量
self.CHIPSCOUNT = 5;
self.wTableID = 0;
---玩家昵称
self.UserNick = "";
---玩家筹码
self.UserGold = 0;
---奖池
self.JackpotPool = 0;

self.Sex = 0;
---小游戏剩余次数
self.MiniGameCount = 0;
---免费游戏剩余次数
self.FreeGameCount = 0;
self.FreeTotalCount = 0;--免费总次数
---上一把赢的钱
self.LastWinGold = 0;

self.freeEnd = true;
---上一把中的线数据
self.lastHitLine = 0;
---上一把中的线数
self.lastHitLineNumber = 0;
---下注列表
self.ChipsLable = {};
---当前选中的下注下标
self.LastSelectChipsIndex = 1;
---当前选中的下注下标
self.CurrSeleteChipsIndex = 1;
---返回结果数据
self.resultElement = {}
---是否可以播放背景音
self.isCanPlayMusic = true;
---是否可以播放音效
self.isCanPlaySound = true;

---桌面图标滚动列表
self.RollElementList = {}

---是否显示能量窗口
self.isShowBetPowar = true;

---玩家自动次数，如果是0说明没有选择 如果是-1说明选择的是最大次数
self.SeleteAutoNumber = 0;
---是否在旋转
self.isRoll = false;
---帮助界面当前页码
self.PageNumber = 0;


self.samlGameRollIndex = 0;
---小游戏外圈转动的列表
self.samlGameRollIcon = {};
---小游戏中间转动的列表
self.samlGameCenterRoll = {};
---小游戏水果图标数据
self.samlCenterResult = {};
---小游戏赢得的金币
self.lastSamlGameWinGold = 0;
---小游戏停止图标下标
self.lastStopIndex = 1;
---小游戏开始下标
self.lastStarIndex = 1;
self.lastFreeCount = 0;
self.lastFreeWinGold = 0;
self.isResult = false;
self.isClickStar = false;

self.winRate = 0; --赢取的倍率
self.currentchip = 0; --当前下注
self.isSmallGameStart = false;
self.isSmallGameEnd = true;

function LogicDataSpace.new(args)
    local o = args or {};
    setmetatable(o, self);
    self.__index = self;
    return o;
end

function LogicDataSpace.OnAwake()
    self.wTableID = 0;
    self.UserNick = "";
    self.UserGold = 0;
    self.JackpotPool = 0;
    self.Sex = 0;
    self.MiniGameCount = 0;
    self.FreeGameCount = 0;
    self.LastWinGold = 0;
    self.lastHitLine = 0;
    self.lastHitLineNumber = 0;
    self.ChipsLable = {};
    self.LastSelectChipsIndex = 1;
    self.CurrSeleteChipsIndex = 1;
    self.resultElement = {}
    self.isCanPlayMusic = true;
    self.isCanPlaySound = true;
    self.RollElementList = {}
    self.isShowBetPowar = true;
    self.SeleteAutoNumber = 0;
    self.isRoll = false;
    self.PageNumber = 0;
    self.samlGameRollIndex = 0;
    self.samlGameRollIcon = {};
    self.samlGameCenterRoll = {};
    self.samlCenterResult = {};
    self.lastSamlGameWinGold = 0;
    self.lastStopIndex = 1;
    self.lastStarIndex = 1;
    self.lastFreeCount = 0;
    self.lastFreeWinGold = 0;
    self.isResult = false;
    self.isClickStar = false;
    self.winRate = 0;
    self.currentchip = 0;
    self.isSmallGameEnd = true;
end

function LogicDataSpace.OnDestroy()
    self.wTableID = 0;
    self.UserNick = "";
    self.UserGold = 0;
    self.JackpotPool = 0;
    self.Sex = 0;
    self.MiniGameCount = 0;
    self.FreeGameCount = 0;
    self.LastWinGold = 0;
    self.lastHitLine = 0;
    self.lastHitLineNumber = 0;
    self.ChipsLable = {};
    self.LastSelectChipsIndex = 1;
    self.CurrSeleteChipsIndex = 1;
    self.resultElement = {}
    self.isCanPlayMusic = true;
    self.isCanPlaySound = true;
    self.RollElementList = {}
    self.isShowBetPowar = true;
    self.SeleteAutoNumber = 0;
    self.isRoll = false;
    self.PageNumber = 0;
    self.samlGameRollIndex = 0;
    self.samlGameRollIcon = {};
    self.samlGameCenterRoll = {};
    self.samlCenterResult = {};
    self.lastSamlGameWinGold = 0;
    self.lastStopIndex = 1;
    self.lastStarIndex = 1;
    self.lastFreeCount = 0;
    self.lastFreeWinGold = 0;
    self.isResult = false;
    self.isClickStar = false;
    self.winRate = 0;
    self.currentchip = 0;
    self.isSmallGameEnd = true;
end