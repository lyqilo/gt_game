local _CGameDefine = class("GameDefine");

local _MAX_LINE_COUNT=40; --总线数
local _X_COUNT = 5;     --一排几个
local _Y_COUNT = 4;     --一共几排
local _PLAYER_COUNT = 1; --几个玩家

local iDCreator = ID_Creator(0);

local _Enum_IconValue = {
    EM_IconValue_Null =iDCreator(0),     --没有     0
	EM_IconValue_Shose=iDCreator(),     --球鞋      1
	EM_IconValue_Card=iDCreator(),      --红黄牌    2
	EM_IconValue_Flag=iDCreator(),      --边裁旗    3
	EM_IconValue_Whistle=iDCreator(),   --口哨      4
	EM_IconValue_Ball=iDCreator(),      --足球      5
	EM_IconValue_Vanguard=iDCreator(),  --前锋      6
	EM_IconValue_GoalKeeper=iDCreator(),--门将      7
    EM_IconValue_Trainer=iDCreator(),   --教练      8
	EM_IconValue_Cup=iDCreator(),       --大力神杯  9 
	EM_IconValue_Court=iDCreator(),     --足球场百搭10
	EM_IconValue_Referee=iDCreator(),   --裁判      11
	EM_IconValue_Max=iDCreator(),       --最大值    12
};

local _Enum_GoalValue = {
	EM_GoalValue_Null=iDCreator(0),     --没有      0
	EM_GoalValue_Gold=iDCreator(),      --金币奖励  1
	EM_GoalValue_Multiple=iDCreator(),  --翻倍      2
	EM_GoalValue_Max=iDCreator(),       --最大值    3
};

local _iconMultiplys = {
    [_Enum_IconValue.EM_IconValue_Null      ] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_Trainer   ] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_Shose     ] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_Card      ] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_Flag      ] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_Whistle   ] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_Ball      ] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_Vanguard  ] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_GoalKeeper] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_Cup       ] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_Court     ] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_Referee   ] = {0,0,0,0,0},
};

_Enum_IconValue.FreeGame = _Enum_IconValue.EM_IconValue_Referee;
_Enum_IconValue.Wild     = _Enum_IconValue.EM_IconValue_Court;


--游戏状态
local _Enum_GameState = {
    EM_GameState_Null = iDCreator(0),           --0
    EM_GameState_PlayingGame = iDCreator(),     --1
    EM_GameState_FreeGame = iDCreator(),        --2
    EM_GameState_BallGame = iDCreator(),        --3
    EM_GameState_Max  = iDCreator(),            --4
};

local _lines = {

};

local _bets = {

};

local _betIndexs = {

};

--获取游戏内对象的总集合
function _CGameDefine.EnumIconType()
    return _Enum_IconValue;
end

--获取倍率
function _CGameDefine.GetIconMultiple(icon,count)
    if icon>_Enum_IconValue.EM_IconValue_Null and icon<_Enum_IconValue.EM_IconValue_Max then
        if count>=1 and count <= _X_COUNT then
            --存在返回_iconMultiplys[icon][count]，不存在返回 0
            return _iconMultiplys[icon][count] and _iconMultiplys[icon][count] or 0;
        end
    end
    return 0;
end

------=====================设置倍率====================================--
function _CGameDefine.SetIconMultiple()
    for i=0,11 do
        if i==_Enum_IconValue.EM_IconValue_Null then
            _CGameDefine.SetMultipleValue(i,0,0,0,0,0)
        elseif i==_Enum_IconValue.EM_IconValue_Shose  then
            _CGameDefine.SetMultipleValue(i,0,0,5,10,20)
        elseif i==_Enum_IconValue.EM_IconValue_Card  then
            _CGameDefine.SetMultipleValue(i,0,0,10,20,40)
        elseif i==_Enum_IconValue.EM_IconValue_Flag  then
            _CGameDefine.SetMultipleValue(i,0,0,15,30,60)
        elseif i==_Enum_IconValue.EM_IconValue_Whistle  then
            _CGameDefine.SetMultipleValue(i,0,0,20,40,80)
        elseif i==_Enum_IconValue.EM_IconValue_Ball  then
            _CGameDefine.SetMultipleValue(i,0,0,25,50,100)
        elseif i==_Enum_IconValue.EM_IconValue_Vanguard then
            _CGameDefine.SetMultipleValue(i,0,0,35,70,140) 
        elseif i==_Enum_IconValue.EM_IconValue_GoalKeeper  then
            _CGameDefine.SetMultipleValue(i,0,0,50,100,200)
        elseif i==_Enum_IconValue.EM_IconValue_Trainer  then
            _CGameDefine.SetMultipleValue(i,0,0,75,150,300)
        elseif i==_Enum_IconValue.EM_IconValue_Cup  then
            _CGameDefine.SetMultipleValue(i,0,0,100,200,400)
        elseif i==_Enum_IconValue.EM_IconValue_Court  then
            _CGameDefine.SetMultipleValue(i,0,0,0,0,0)
        elseif i==_Enum_IconValue.EM_IconValue_Referee  then
            _CGameDefine.SetMultipleValue(i,0,0,0,0,0)
        end
    end
    logTable(_iconMultiplys)
end
function _CGameDefine.SetMultipleValue(num1,num2,num3,num4,num5,num6)
    _iconMultiplys[num1][1]=num2;
    _iconMultiplys[num1][2]=num3;
    _iconMultiplys[num1][3]=num4;
    _iconMultiplys[num1][4]=num5;
    _iconMultiplys[num1][5]=num6; 
end  
-----======================设置倍率=============================--

-----======================线属性设置=============================--
local  Lines={
    C11={1,1},  C12={1,2},  C13={1,3},  C14={1,4},  C15={1,5},  
    C21={2,1},  C22={2,2},  C23={2,3},  C24={2,4},  C25={2,5}, 
    C31={3,1},  C32={3,2},  C33={3,3},  C34={3,4},  C35={3,5},  
    C41={4,1},  C42={4,2},  C43={4,3},  C44={4,4},  C45={4,5},
}

local SetLinesAttr=
{
    { Lines.C11,Lines.C12,Lines.C13,Lines.C14,Lines.C15 },		-- 1
	{ Lines.C21,Lines.C22,Lines.C23,Lines.C24,Lines.C25 },		-- 2
	{ Lines.C31,Lines.C32,Lines.C33,Lines.C34,Lines.C35 },		-- 3
    { Lines.C41,Lines.C42,Lines.C43,Lines.C44,Lines.C45 },		-- 4
    { Lines.C11,Lines.C12,Lines.C13,Lines.C24,Lines.C35 },		-- 5
    { Lines.C41,Lines.C42,Lines.C43,Lines.C34,Lines.C25 },		-- 6
    { Lines.C21,Lines.C22,Lines.C23,Lines.C34,Lines.C45 },		-- 7
    { Lines.C31,Lines.C32,Lines.C33,Lines.C24,Lines.C15 },		-- 8
    { Lines.C11,Lines.C22,Lines.C33,Lines.C34,Lines.C35 },		-- 9
    { Lines.C41,Lines.C32,Lines.C23,Lines.C24,Lines.C25 },		-- 10
    { Lines.C31,Lines.C22,Lines.C13,Lines.C14,Lines.C15 },		-- 11
    { Lines.C21,Lines.C32,Lines.C43,Lines.C44,Lines.C45 },		-- 12
    { Lines.C11,Lines.C22,Lines.C33,Lines.C24,Lines.C15 },		-- 13
    { Lines.C41,Lines.C32,Lines.C23,Lines.C34,Lines.C45 },		-- 14
    { Lines.C31,Lines.C22,Lines.C13,Lines.C24,Lines.C35 },		-- 15
    { Lines.C21,Lines.C32,Lines.C43,Lines.C34,Lines.C25 },		-- 16
    { Lines.C11,Lines.C22,Lines.C33,Lines.C44,Lines.C45 },		-- 17
    { Lines.C41,Lines.C32,Lines.C23,Lines.C14,Lines.C15 },		-- 18
    { Lines.C41,Lines.C42,Lines.C33,Lines.C24,Lines.C15 },		-- 19
    { Lines.C11,Lines.C12,Lines.C23,Lines.C34,Lines.C45 },		-- 20
    { Lines.C21,Lines.C12,Lines.C23,Lines.C34,Lines.C45 },		-- 21
    { Lines.C31,Lines.C42,Lines.C33,Lines.C24,Lines.C15 },		-- 22
    { Lines.C41,Lines.C32,Lines.C23,Lines.C14,Lines.C25 },		-- 23
    { Lines.C11,Lines.C22,Lines.C33,Lines.C44,Lines.C35 },		-- 24
    { Lines.C11,Lines.C12,Lines.C23,Lines.C34,Lines.C35 },		-- 25
    { Lines.C41,Lines.C42,Lines.C33,Lines.C24,Lines.C25 },		-- 26
    { Lines.C21,Lines.C22,Lines.C33,Lines.C44,Lines.C45 },		-- 27
    { Lines.C31,Lines.C32,Lines.C23,Lines.C14,Lines.C15 },		-- 28
    { Lines.C21,Lines.C32,Lines.C23,Lines.C14,Lines.C25 },		-- 29
    { Lines.C31,Lines.C22,Lines.C33,Lines.C44,Lines.C35 },		-- 30
    { Lines.C21,Lines.C12,Lines.C23,Lines.C34,Lines.C25 },		-- 31
    { Lines.C31,Lines.C42,Lines.C33,Lines.C24,Lines.C35 },		-- 32
    { Lines.C11,Lines.C22,Lines.C23,Lines.C24,Lines.C15 },		-- 33
    { Lines.C41,Lines.C32,Lines.C33,Lines.C34,Lines.C45 },		-- 34
    { Lines.C21,Lines.C12,Lines.C13,Lines.C14,Lines.C25 },		-- 35
    { Lines.C31,Lines.C42,Lines.C43,Lines.C44,Lines.C35 },		-- 36
    { Lines.C21,Lines.C32,Lines.C33,Lines.C34,Lines.C25 },		-- 37
    { Lines.C31,Lines.C22,Lines.C23,Lines.C24,Lines.C35 },		-- 38
	{ Lines.C21,Lines.C32,Lines.C23,Lines.C34,Lines.C25 },		-- 39
	{ Lines.C31,Lines.C22,Lines.C33,Lines.C24,Lines.C35 },		-- 40
}

function _CGameDefine.SetLine()
  for i=1,40 do
      _lines[i]=SetLinesAttr[i];
  end
end
-----======================线属性设置=============================--



--奖励类型
function _CGameDefine.EnumGoalType()
    return _Enum_GoalValue;
end

function _CGameDefine.XCount()
    return _X_COUNT;
end

function _CGameDefine.YCount()
    return _Y_COUNT;
end

function _CGameDefine.MaxLine()
    return _MAX_LINE_COUNT;
end

function _CGameDefine.PlayerCount()
    return _PLAYER_COUNT;
end

function _CGameDefine.GetLines()
    return _lines;
end

--存储下注的内容
function _CGameDefine.PushBet(bet)
    _betIndexs[bet] = #_bets + 1;
    table.insert(_bets,bet);
end


function _CGameDefine.ClearBet()
    --error("清除下注信息")
    _bets={};
end

--选择下注的倍数
function _CGameDefine.GetBet(index)
    if index<=0 or index>#_bets then
        return 0;
    end
    return _bets[index];
end

--最小下注
function _CGameDefine.GetMinBet()
    return _bets[1];
end
--最大下注
function _CGameDefine.GetMaxBet()
    return _bets[#_bets];
end

--获取当前下注是第几档下注
local getBetIndex =function(_bet)
    return _betIndexs[_bet] or 1;
end

--下一个下注的
function _CGameDefine.GetNextBet(_bet)
    local index = getBetIndex(_bet);
    if index>=#_bets then
        return _bets[1];
    else
        return _bets[index+1];
    end
end

--上一个下注
function _CGameDefine.GetPreBet(_bet)
    local index = getBetIndex(_bet);
    if index<=1 then
        return _bets[#_bets];
    else
        return _bets[index-1];
    end
end

function _CGameDefine.EnumGameState()
    return _Enum_GameState;
end

function _CGameDefine.GetBetList()
    return _bets;
end

return _CGameDefine;