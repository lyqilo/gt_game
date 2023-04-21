local GameData = class("GameData");

--坐标结构体
local StoneNode = class("StoneNode");

function StoneNode:ctor(_x,_y)
    self._x     = _x;
    self._y     = _y;
    self._up    = nil;  --上边
    self._down  = nil;  --下边 
    self._left  = nil;  --左
    self._right = nil;  --右
    self._value = nil;  --具体类型
    self._isCount = false;
end

function StoneNode:ResetPos(_x,_y)
    self._x = _x;
    self._y = _y;
end

function StoneNode:SetValue(_value)
    self._value = _value;
end

function StoneNode:SetRight(_right)
    self._right = _right;
end

function StoneNode:SetLeft(_left)
    self._left = _left;
end

function StoneNode:SetUp(_up)
    self._up = _up;
end

function StoneNode:SetDown(_down)
    self._down = _down;
end

function StoneNode:Right()
    return self._right;
end

function StoneNode:Left()
    return self._left;
end

function StoneNode:Up()
    return self._up;
end

function StoneNode:Down()
    return self._down;
end

function StoneNode:Value()
    return self._value;
end

--标识为已经计算过
function StoneNode:Count()
    self._isCount = true;
end

--是否计算过
function StoneNode:IsCount()
    return self._isCount;
end

--清除计算过标识 
function StoneNode:ClearCount()
    self._isCount = false;
end

--清空
function StoneNode:Empty()
    self._value=nil;
end

--是否空
function StoneNode:IsEmpty()
    return self._value==nil;
end

--返回值
function StoneNode:Value()
    return self._value;
end

--清除
function StoneNode:Clear()
    self._value=nil;
    self._isCount = false;
end

local MoveAction = class("MoveAction");

function MoveAction:ctor(_sx,_sy,_dx,_dy)
    self._sx = _sx;
    self._sy = _sy;
    self._dx = _dx;
    self._dy = _dy;
end




--[[
坐标体系
    y
   ↑6
   ↑5
   ↑4
   ↑3
   ↑2
   ↑1 
      1 2 3 4 5 6
      →→→→→→ x
--]]
function GameData:ctor()
    self._stage             = 1;
    self._brickCount        = SI_STAGE_BRICKS;
    self._stoneNodes        = {};
    self._tempCountData     = {};
    self._lineMap           = map:new();
    self._reachLinesVec     = vector:new();
    self._moveStoneNode     = vector:new();
    --钻头
    self._drillVec          = vector:new();
    --每列需要的个数,以及总个数
    self._needCount         = {};
    self._needTotalCount    = 0;
end

--重置关卡
function GameData:ResetStage(_stage,_brickCount)
    if _stage then
        self._stage = _stage;
    else
        self._stage = 1;
    end
    self._brickCount=_brickCount or SI_STAGE_BRICKS;
    self:InitStage();
end

--初始化关卡
function GameData:InitStage()
    self._xCount    = SI_STAGE_DATA[self._stage].xCount;
    self._yCount    = SI_STAGE_DATA[self._stage].yCount;
    self._minCount  = SI_STAGE_DATA[self._stage].minCount;
    local stonePos
    --初始化石头
    for j=1,self._yCount do
        self._stoneNodes[j] = {};
        for i=1,self._xCount do
            self._stoneNodes[j][i]  = StoneNode.New(i,j);
        end
    end
    self._stoneNodes[self._yCount+1]=nil;
    local up,down,left,right
    for i=1,self._xCount do
        for j=1,self._yCount do
            stonePos = self._stoneNodes[j][i];
            left = self._stoneNodes[j][i-1];
            right = self._stoneNodes[j][i+1];
            if self._stoneNodes[j+1]==nil then
                up=nil;
            else
                up = self._stoneNodes[j+1][i];
            end
            if self._stoneNodes[j-1]==nil then
                down=nil;
            else
                down = self._stoneNodes[j-1][i];
            end
            stonePos:SetUp(up);
            stonePos:SetDown(down);
            stonePos:SetLeft(left);
            stonePos:SetRight(right);
        end
    end
    self:ResetData();
end

function GameData:ResetData()
    for i=1,self._xCount do
        self._needCount[i] = self._yCount;
    end
    self._needTotalCount = self._xCount * self._yCount;
	log("需要"..self._needTotalCount.."个宝石");
    local pos
    for j=1,self._yCount do
        for i=1,self._xCount do
            pos = self:_getNode(i,j);
            pos:Clear();
        end
    end
end

--初始化数据
function GameData:ReciveStone(_data)
    local pos
    local k=1;
    
    for j=1,self._yCount do
        for i=1,self._xCount do
            pos = self:_getNode(i,j);
            pos:SetValue(_data[k]);
            k = k + 1;
        end
    end

    --debug
    local str="";
    for j=self._yCount,1,-1 do
        for i=1,self._xCount do
            pos = self:_getNode(i,j);
            str = str .. pos._value .. " ";
            k = k + 1;
        end
        str = str .. "\n";
    end
    error("data:\n" ..str);
end

--当前砖块索引
function GameData:CurBrick()
    return self._brickCount;
end

--清除一块砖
function GameData:ClearBrick(_count)
    _count = _count or 1;
    if self._brickCount <= 0 then
        return true;
    end
    self._brickCount = self._brickCount - _count;
	log("消除".._count.."块砖,剩余："..self._brickCount);
    if self._brickCount <= 0 then
        return true;
    end
    return false;
end

--下一关
function GameData:NextStage()
    self._stage = self._stage + 1;
    if self._stage > SI_MAX_STAGE then
        self._stage = 1;
    end
    --self._brickCount = SI_STAGE_BRICKS;
    self:ResetStage(self._stage);
end

--遍历节点
function GameData:foreachStoneNode(_handler)
    local _stoneNode
    for j=1,self._yCount do
        for i=1,self._xCount do
            _stoneNode   = self:_getNode(i,j);
            _handler(_stoneNode);
        end
    end
end

--计算钻头
function GameData:CountDrill()
    local vec,_type,_stoneNode,value
    for j=1,self._yCount do
        for i=1,self._xCount do
            _stoneNode   = self:_getNode(i,j);
            value = _stoneNode:Value();
            --钻头存在单独的容器里
            if value == SI_STONE_TYPE.Drill then
                self._drillVec:push_back(_stoneNode);
            end
        end
    end
end

--清除钻头
function GameData:ClearDrill()
    for i=1,self._xCount do
        self._needCount[i]=0;
    end
    self._needTotalCount  = 0;
    local it = self._drillVec:iter();
    local stoneNode = it();
    while(stoneNode) do
        stoneNode:Empty();
        self._needCount[stoneNode._x] = self._needCount[stoneNode._x] + 1 ;
        self._needTotalCount = self._needTotalCount + 1;
        stoneNode = it();
    end
    --清空队列列表
    self._drillVec:clear();
    return self:_moveStoneNodes();
end

--得到钻头列表
function GameData:GetDrills()
    return self._drillVec;
end

--得到指定钻头
function GameData:GetDrill(index)
    return self._drillVec:get(index);
end

--钻头个数
function GameData:GetDrillSize()
    return self._drillVec:size();
end

--计算石头
function GameData:CountStones()
    self._tempCountData = {};
    self._lineMap:clear();
    self._drillVec:clear();
    local vec,_type,_stoneNode,value
    for j=1,self._yCount do
        for i=1,self._xCount do
            _stoneNode   = self:_getNode(i,j);
            value = _stoneNode:Value();
            --钻头存在单独的容器里
            if _stoneNode:IsEmpty() then
                
            else
                vec     = self._lineMap:value(value);
                if not vec then
                    vec = vector:new();
                    self._lineMap:insert(value,vec);
                end
                vec:push_back(_stoneNode);
            end
        end
    end
    --清空计算
    local function clearCount(stoneNode)
        stoneNode:ClearCount();
    end
    self:foreachStoneNode(clearCount);

    --查找相同的节点
    local function findSame(node,line,_value)
        if not node or node:IsCount() or node:Value()~=_value then
            return;
        end
        node:Count();
        line:push_back(node);
        local up,down,left,right
        up      = node:Up();
        down    = node:Down();
        left    = node:Left();
        right   = node:Right();
        findSame(up,line,_value);
        findSame(down,line,_value);
        findSame(left,line,_value);
        findSame(right,line,_value);
    end

    local it = self._lineMap:iter();
    local val = it();
    local it2
    local lineVec
    local up,down,left,right
    self._reachLinesVec:clear();
    while(val) do
        vec = self._lineMap:value(val);
        if vec:size()<self._minCount then
        else
            --判断是否可以
            it2 = vec:iter();
            val = it2();
            while(val) do
                lineVec = vector:new();
                findSame(val,lineVec,val:Value());
                if lineVec:size()>= self._minCount then --达到预定个数
                    self._reachLinesVec:push_back(lineVec);
                end
                val = it2()
            end
        end
        val = it();
    end

    --debug
    local function InitTab()
        local tab={};
        for i=1,self._yCount do
            tab[i] = {};
        end
        return tab;
    end

    local function PrintLine(_tab)
        local str="";
        for i=self._yCount,1,-1 do
            for j=1,self._xCount do
                if _tab[i][j]==1 then
                    str = str .. "   ";
                else
                    str = str .. "* ";
                end
            end
            str = str .. "\n";
        end
        --error(str);
        return _tab;
    end

    it = self._reachLinesVec:iter();
    val = it();
    while(val) do
        it2 = val:iter();
        val = it2();
        --error("Type:" .. val:Value(),true);
        local tab = InitTab()
        while(val) do
            tab[val._y][val._x]=1;
            val = it2();
        end
        --PrintLine(tab);
        val = it();
    end

    local function ClearCountFlag(_stoneNode)
        --清除标识
        _stoneNode:ClearCount();
    end

    self:foreachStoneNode(ClearCountFlag);
end

--得到连线个数
function GameData:GetLineSize()
    return self._reachLinesVec:size();
end

--得到连线列表
function GameData:GetLines()
    return self._reachLinesVec;
end

--得到指定连线
function GameData:GetLine(index)
    return self._reachLinesVec:get(index);
end

function GameData:_moveStoneNodes()
    local function findNextUpStoneNode(_node)
        local node=_node:Up();
        if not node then
            return node;
        end
        if node:IsEmpty() then
            return findNextUpStoneNode(node);
        end
        return node;
    end
    local node
    local moveAction
    local vec = vector:new();
    for i=1,self._xCount do
        for j=1,self._yCount do
            stoneNode = self:_getNode(i,j);
            if stoneNode:IsEmpty() then
                 node = findNextUpStoneNode(stoneNode);
                 if node ==nil then
                    --没有找到，break;
                    break;
                 end
                 --换值下
                 stoneNode:SetValue(node:Value());
                 node:Empty();
                 --记录位置改变
                 moveAction = MoveAction.New(node._x,node._y,stoneNode._x,stoneNode._y);
                 vec:push_back(moveAction);
            end
        end
    end
    return vec;
end

--整理 返回需要改变位置的节点
function GameData:ArrageStonesNode()
    for i=1,self._xCount do
        self._needCount[i]=0;
    end
    self._needTotalCount  = 0;

    local it = self._reachLinesVec:iter();
    local val = it();
    local stoneNode
    while(val) do
        it2 = val:iter();
        val = it2();
        while(val) do
            stoneNode = self:_getNode(val._x,val._y);
            stoneNode:Empty();
            self._needCount[val._x] = self._needCount[val._x] + 1 ;
            self._needTotalCount = self._needTotalCount + 1;
            val = it2();
        end
        val = it();
    end
    return self:_moveStoneNodes();
end

--得到坐标对应的石头
function GameData:_getNode(_x,_y)
    return self._stoneNodes[_y][_x];
end

--得到下落的坐标
function GameData:FallIn(_x,_value)
    local _y=self._yCount-self._needCount[_x]+1;
    if self._yCount<_y then
        return false,_x,_y;
    end
    local stoneNode = self:_getNode(_x,_y);
    stoneNode:SetValue(_value);
    self._needCount[_x] =  self._needCount[_x] - 1;
    self._needTotalCount = self._needTotalCount - 1;
    return true,_x,_y;
end

--是否已经落满了
function GameData:IsFull()
    return self._needTotalCount==0;
end

--某列是否满了
function GameData:IsRowFull(_x)
    return self._needCount[_x]==0;
end

function GameData:XCount()
    return self._xCount;
end

function GameData:YCount()
    return self._yCount;
end

--关卡
function GameData:GetStage()
    return self._stage;
end

return GameData;