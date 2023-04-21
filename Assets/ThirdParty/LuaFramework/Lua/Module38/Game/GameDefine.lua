local _CGameDefine = class("GameDefine");

local _MAX_LINE_COUNT=40; --总线数
local _X_COUNT = 5;     --一排几个
local _Y_COUNT = 4;     --一共几排
local _CELL_COUNT = _X_COUNT * _Y_COUNT;
local _PLAYER_COUNT = 1; --几个玩家
local _MAP_BLOCK_COUNT = 19; --征战模式的地图地名个数

local iDCreator = ID_Creator(0);
local _Enum_IconValue = {
    EM_IconValue_Null =iDCreator(0),     --没有
	EM_IconValue_Wind=iDCreator(),      --风
	EM_IconValue_Fire=iDCreator(),      --火
	EM_IconValue_Star=iDCreator(),      --星
	EM_IconValue_Food=iDCreator(),      --粮草
	EM_IconValue_Weapon=iDCreator(),    --兵器
	EM_IconValue_Army=iDCreator(),      --军队
	EM_IconValue_Gentleman=iDCreator(), --将军
    EM_IconValue_Counsellor=iDCreator(),--军师
	EM_IconValue_BookSun=iDCreator(),   --孙子兵法 
	EM_IconValue_Max=iDCreator(),       --最大值
};

local _Enum_GoalValue = {
	EM_GoalValue_Null=iDCreator(0),     --没有
	EM_GoalValue_Gold=iDCreator(),      --金币奖励
	EM_GoalValue_Multiple=iDCreator(),  --翻倍
	EM_GoalValue_Max=iDCreator(),       --最大值
};

local _Enum_WholeValue = {
   EM_WholeValue_Null = iDCreator(0),
   EM_WholeValue_Small= iDCreator(),    --全盘小奖
   EM_WholeValue_Mid  = iDCreator(),    --全盘中奖
   EM_WholeValue_Big  = iDCreator(),    --全盘大奖
   EM_WholeValue_Caijin = iDCreator(),  --奖池
   EM_WholeValue_Max  = iDCreator(),  
};

local _Enum_SmallGameValue = {
    EM_SmallGame_Null = iDCreator(0),
    EM_SmallGame_Gold = iDCreator(),    --金币奖励
    EM_SmallGame_Add2 = iDCreator(),    --次数+2
    EM_SmallGame_Add3 = iDCreator(),    --次数+3
    EM_SmallGame_X2   = iDCreator(),    --倍率X2
    EM_SmallGame_X3   = iDCreator(),    --倍率X3
    EM_SmallGame_X10  = iDCreator(),    --倍率X10
    EM_SmallGame_XMax = iDCreator(),    --特奖
    EM_SmallGame_Max  = iDCreator(),
};

local _iconMultiplys = {
    [_Enum_IconValue.EM_IconValue_Null      ] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_Wind      ] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_Fire      ] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_Star      ] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_Food      ] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_Weapon    ] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_Army      ] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_Gentleman ] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_Counsellor] = {0,0,0,0,0},
    [_Enum_IconValue.EM_IconValue_BookSun   ] = {0,0,0,0,0},
};

_Enum_IconValue.FreeGame = _Enum_IconValue.EM_IconValue_BookSun;
_Enum_IconValue.Wild     = _Enum_IconValue.EM_IconValue_Counsellor;

local _Enum_ServerState = {
    EM_ServerState_Normal       = iDCreator(0),
    EM_ServerState_SmallGame    = iDCreator(),
    EM_ServerState_FreeGame     = iDCreator(),
};

--游戏状态
local _Enum_GameState = {
    EM_GameState_Null = iDCreator(0),
    EM_GameState_PlayingGame = iDCreator(),
    EM_GameState_FreeGame = iDCreator(),
    EM_GameState_SmallGame = iDCreator(),
    EM_GameState_Max  = iDCreator(),
};

local _lines = {
    
};

local _bets = {

};

local _betIndexs = {
};

local _war = {
    sepMultiple = 1000,
    itemsCount = {},
};

local _wholeConfig = 
{

};

function _CGameDefine.EnumIconType()
    return _Enum_IconValue;
end

function _CGameDefine.GetIconMultiple(icon,count)
    if icon>_Enum_IconValue.EM_IconValue_Null and icon<_Enum_IconValue.EM_IconValue_Max then
        if count>=1 and count<=_X_COUNT then
            return _iconMultiplys[icon][count] and _iconMultiplys[icon][count] or 0;
        end
    end
    return 0;
end

------=====================设置倍率====================================--
function _CGameDefine.SetIconMultiple()
    for i=0,9 do
        if i==_Enum_IconValue.EM_IconValue_Null then
            _CGameDefine.SetMultipleValue(i,0,0,0,0,0)
        elseif i==_Enum_IconValue.EM_IconValue_Wind  then
            _CGameDefine.SetMultipleValue(i,0,0,2,5,40)
        elseif i==_Enum_IconValue.EM_IconValue_Fire  then
            _CGameDefine.SetMultipleValue(i,0,0,3,10,60)
        elseif i==_Enum_IconValue.EM_IconValue_Star  then
            _CGameDefine.SetMultipleValue(i,0,0,4,15,80)
        elseif i==_Enum_IconValue.EM_IconValue_Food  then
            _CGameDefine.SetMultipleValue(i,0,0,10,20,120)
        elseif i==_Enum_IconValue.EM_IconValue_Weapon  then
            _CGameDefine.SetMultipleValue(i,0,0,15,40,150)
        elseif i==_Enum_IconValue.EM_IconValue_Army then
            _CGameDefine.SetMultipleValue(i,0,0,20,80,200) 
        elseif i==_Enum_IconValue.EM_IconValue_Gentleman  then
            _CGameDefine.SetMultipleValue(i,0,0,40,120,400)
        elseif i==_Enum_IconValue.EM_IconValue_Counsellor  then
            _CGameDefine.SetMultipleValue(i,0,0,0,0,1000)
        elseif i==_Enum_IconValue.EM_IconValue_BookSun  then
            _CGameDefine.SetMultipleValue(i,0,0,50,500,1000)
        end
    end
    -- error("设置倍率")
    -- logTable(_iconMultiplys)
end
function _CGameDefine.SetMultipleValue(num1,num2,num3,num4,num5,num6)
    _iconMultiplys[num1][1]=num2;
    _iconMultiplys[num1][2]=num3;
    _iconMultiplys[num1][3]=num4;
    _iconMultiplys[num1][4]=num5;
    _iconMultiplys[num1][5]=num6; 
end  
-----======================设置倍率=============================--

-----======================线属性设置===========================--
local  Lines={
    C11={1,1},  C12={1,2},  C13={1,3},  C14={1,4},  C15={1,5},  
    C21={2,1},  C22={2,2},  C23={2,3},  C24={2,4},  C25={2,5}, 
    C31={3,1},  C32={3,2},  C33={3,3},  C34={3,4},  C35={3,5},  
    C41={4,1},  C42={4,2},  C43={4,3},  C44={4,4},  C45={4,5},
}

local SetLinesAttr=
{
    {Lines.C11,  Lines.C12,  Lines.C13,  Lines.C14,  Lines.C15,},  --1
    {Lines.C11,  Lines.C22,  Lines.C23,  Lines.C34,  Lines.C35,},  --2
    {Lines.C31,  Lines.C32,  Lines.C23,  Lines.C24,  Lines.C15,},  --3
    {Lines.C41,  Lines.C32,  Lines.C13,  Lines.C34,  Lines.C45,},  --4
    {Lines.C11,  Lines.C32,  Lines.C43,  Lines.C34,  Lines.C15,},  --5
    {Lines.C11,  Lines.C12,  Lines.C43,  Lines.C14,  Lines.C15,},  --6
    {Lines.C41,  Lines.C12,  Lines.C13,  Lines.C14,  Lines.C45,},  --7
    {Lines.C21,  Lines.C12,  Lines.C43,  Lines.C14,  Lines.C25,},  --8
    {Lines.C21,  Lines.C12,  Lines.C23,  Lines.C34,  Lines.C35,},  --9
    {Lines.C31,  Lines.C32,  Lines.C23,  Lines.C14,  Lines.C25,},  --10
    {Lines.C21,  Lines.C22,  Lines.C23,  Lines.C24,  Lines.C25,},  --11
    {Lines.C21,  Lines.C32,  Lines.C33,  Lines.C44,  Lines.C45,},  --12 
    {Lines.C41,  Lines.C42,  Lines.C33,  Lines.C34,  Lines.C25,},  --13
    {Lines.C31,  Lines.C22,  Lines.C43,  Lines.C24,  Lines.C35,},  --14
    {Lines.C21,  Lines.C42,  Lines.C13,  Lines.C44,  Lines.C25,},  --15
    {Lines.C21,  Lines.C22,  Lines.C13,  Lines.C24,  Lines.C25,},  --16
    {Lines.C31,  Lines.C42,  Lines.C43,  Lines.C44,  Lines.C35,},  --17
    {Lines.C31,  Lines.C22,  Lines.C13,  Lines.C24,  Lines.C35,},  --18
    {Lines.C11,  Lines.C22,  Lines.C33,  Lines.C44,  Lines.C45,},  --19
    {Lines.C41,  Lines.C42,  Lines.C33,  Lines.C24,  Lines.C15,},  --20
    {Lines.C31,  Lines.C32,  Lines.C33,  Lines.C34,  Lines.C35,},  --21 
    {Lines.C11,  Lines.C12,  Lines.C13,  Lines.C24,  Lines.C25,},  --22
    {Lines.C21,  Lines.C22,  Lines.C13,  Lines.C14,  Lines.C15,},  --23
    {Lines.C21,  Lines.C12,  Lines.C33,  Lines.C14,  Lines.C25,},  --24
    {Lines.C31,  Lines.C12,  Lines.C23,  Lines.C14,  Lines.C35,},  --25
    {Lines.C31,  Lines.C32,  Lines.C23,  Lines.C34,  Lines.C35,},  --26
    {Lines.C21,  Lines.C32,  Lines.C33,  Lines.C34,  Lines.C25,},  --27
    {Lines.C41,  Lines.C32,  Lines.C23,  Lines.C34,  Lines.C45,},  --28
    {Lines.C41,  Lines.C42,  Lines.C43,  Lines.C24,  Lines.C25,},  --29
    {Lines.C21,  Lines.C22,  Lines.C43,  Lines.C44,  Lines.C45,},  --30
    {Lines.C41,  Lines.C42,  Lines.C43,  Lines.C44,  Lines.C45,},  --31
    {Lines.C31,  Lines.C42,  Lines.C43,  Lines.C14,  Lines.C45,},  --32
    {Lines.C41,  Lines.C12,  Lines.C43,  Lines.C44,  Lines.C35,},  --33
    {Lines.C11,  Lines.C42,  Lines.C23,  Lines.C44,  Lines.C15,},  --34
    {Lines.C41,  Lines.C22,  Lines.C33,  Lines.C24,  Lines.C45,},  --35
    {Lines.C41,  Lines.C42,  Lines.C33,  Lines.C44,  Lines.C45,},  --36
    {Lines.C11,  Lines.C22,  Lines.C23,  Lines.C24,  Lines.C15,},  --37
    {Lines.C11,  Lines.C42,  Lines.C33,  Lines.C44,  Lines.C15,},  --38
    {Lines.C31,  Lines.C32,  Lines.C13,  Lines.C14,  Lines.C15,},  --39
    {Lines.C11,  Lines.C12,  Lines.C13,  Lines.C34,  Lines.C35,},  --40
}

function _CGameDefine.SetLine()
  for i=1,40 do
      _lines[i]=SetLinesAttr[i];
  end
--   error("设置线属性")
--   logTable(_lines)
end
-----======================线属性设置=============================--

function _CGameDefine.EnumGoalType()
    return _Enum_GoalValue;
end

function _CGameDefine.EnumSmallGameType()
    return _Enum_SmallGameValue;
end

function _CGameDefine.EnumWholeType()
    return _Enum_WholeValue;
end

function _CGameDefine.XCount()
    return _X_COUNT;
end

function _CGameDefine.YCount()
    return _Y_COUNT;
end

function _CGameDefine.CellCount()
    return _CELL_COUNT;
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

function _CGameDefine.MapBlockCount()
    return _MAP_BLOCK_COUNT;
end

function _CGameDefine.PushBet(bet)
    _betIndexs[bet] = #_bets + 1;
    table.insert(_bets,bet);
end

function _CGameDefine.GetBet(index)
    if index<=0 or index>#_bets then
        return 0;
    end
    return _bets[index];
end

function _CGameDefine.ClearBet()
    --error("清除下注信息")
    _bets={};
end

function _CGameDefine.GetMinBet()
    return _bets[1];
end

function _CGameDefine.GetMaxBet()
    return _bets[#_bets];
end

local getBetIndex =function(_bet)
    return _betIndexs[_bet] or 1;
end

function _CGameDefine.GetNextBet(_bet)
    local index = getBetIndex(_bet);
    if index>=#_bets then
        return _bets[1];
    else
        return _bets[index+1];
    end
end

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

function _CGameDefine.EnumServerState()
    return _Enum_ServerState;
end

function _CGameDefine.SetWholeMultiple(_wholeType,_wholeMultiple)
    _wholeConfig[_wholeType] = _wholeMultiple;
end

function  _CGameDefine.WholeMultiple()
    -- error("全盘倍数")
    -- logTable(_wholeConfig)
end

function  _CGameDefine.GetWholeMultiple(_wholeType)
    return _wholeConfig[_wholeType] or 0;
end

function _CGameDefine.SetSepMultiple(sepMultiple)
    _war.sepMultiple = sepMultiple;
end

function _CGameDefine.GetSepMultiple()
    return _war.sepMultiple;
end

function _CGameDefine.SetItemCount(id,count)
    _war.itemsCount[id] = count;
end

function _CGameDefine.ItemCount(id,count)
    -- error("小游戏每个可以出现的次数")
    -- logTable(_war.itemsCount)
end

function _CGameDefine.GetItemCount(id)
    return _war.itemsCount[id] or 0;
end

function _CGameDefine.GetWarAreaCount()
    return _MAP_BLOCK_COUNT;
end

return _CGameDefine;