local ThrowPath = GameRequire("SI_ThrowPath");

local AlertStaticPanel = GameRequire("SI_AlertStaticPanel");

local C_OneScale  = Vector3.New(1,1,1);
local C_ZeroPos   = Vector3.New(0,0,0);
local C_OnePos   = Vector3.New(1,1,1);
local C_NormalVector=Vector3.New(1,1,1);
local C_ZeroRotation = Quaternion.Euler(0,0,0);

local AtlasNumber = GameRequire("SI_AtlasNumber");

local BalanceNumber = GameRequire("SI_BalanceNumber");


local SI_UI_DEFINE = {
--    STONE_GRID_BEGIN_X          = -210,
--    STONE_GRID_BEGIN_Y          = -215,
--    STONE_GRID_BEGIN_Y_DIS      = 64,
--    STONE_GRID_BEGIN_X_DIS      = 85,
    STONE_GRID_BEGIN_X          = -185,
    STONE_GRID_BEGIN_Y          = -240,
    STONE_GRID_BEGIN_Y_DIS      = 68,
    STONE_GRID_BEGIN_X_DIS      = 74,
    STONE_GRID_READY_OFFSET_Y   = -20,
    STONE_GRID_READY_OFFSET_X   = 0,
    DETAIL_LINE_TOP_X           = -9,
    DETAIL_LINE_TOP_Y           = 253,
    DETAIL_LINE_Y_DIS           = 97,
    DETAIL_LINE_MAX_COUNT       = 6, --此参数无效了  使用 SI_GAME_CONFIG.ShowLineCount
    DETAIL_LINE_DISAPPEAR_Y     = 380,
    DETAIL_LINE_START_Y         = -360,
--    STONE_LEFT_X                = -590,
--    STONE_RIGHT_X               = 810,
    STONE_LEFT_X                = -570,
    STONE_RIGHT_X               = 830,
};


--宝石格子
local StoneNodeGrid = class("StoneNodeGrid");

function StoneNodeGrid:ctor(_x,_y)
    self._stoneObj = nil;
    self._transform = nil;
    self._x        = _x;
    self._y        = _y;
    self._throwData = {
        _isJump   = false;
        _throwPath = nil;
        _toward = nil;
        _speed  = nil;
        _beginX = nil;
        _runTime = 0;
        _totalTime =0;
    };
    self._isNeedPlayMusic = false;
    self._isFallDown = false;
    self.isSepDisappear = false;
end

--消失
function StoneNodeGrid:Disappear(_handler)
    local function disappearOver(obj,...)
        if _handler then
            _handler(obj,...);
        end
        --缓存起来
        GlobalGame._gameObjManager:Push(obj);
    end
    --创建
    local obj = GlobalGame._gameObjManager:GetEffectObj(SI_EFFECT_TYPE.Stone_Disappear);
    obj:Disappear(disappearOver);
    obj:SetParent(self._stoneObj.transform.parent);
    obj:SetLocalPosition(self._stoneObj.transform.localPosition);
    obj:SetLocalScale(C_NormalVector);

    GlobalGame._gameObjManager:Push(self._stoneObj);
    self._stoneObj = nil;
    if self._isNeedPlayMusic then
        MusicManager:PlayX(GlobalGame._gameObjManager:GetMusic(SI_MUSIC_TYPE.Stone_Disappear));
    end
end

function StoneNodeGrid:SepDisappear(_handler1,_handler2)
    self.isSepDisappear = true;
    self.isSepDisappearStep = 1;
    self.sepScale = 1; --缩放比例
    self._stoneObj:StopAndRevert();
--    coroutine.start(
--        function ()
--            coroutine.wait(1.4);
--            if not GlobalGame.isInGame then
--                return ;
--            end
--            if _handler1 then
--                _handler1(self);
--            end
--            self:Disappear(_handler);
--        end
--    );

    local temp = function ()
        if _handler1 then
            _handler1(self);
        end
        self:Disappear(_handler);
    end
    GlobalGame._timerMgr:FixUpdateOnce(temp,1.4);
end

local  SCREEN_MATCH_HEIGHT=750;
local SCREEN_MATCH_WIDTH=1334;
--跳出去
function StoneNodeGrid:Jump(_parent)
    if self._stoneObj==nil then
        return;
    end
    self._throwData._isJump = true;
    local lv,time;
    local lowY = -SCREEN_MATCH_WIDTH/2,lowX1,lowX2;
    --error("Screen W:"  .. Screen.width .. ",Screen H:" ..Screen.height);
    local crossX,crossW
    random = math.random(50,100)/100.0;
    y = math.random(100,280);
    x = math.random(0,320)-160 
    local localPosition;
    while(true) do
        lv=x/y;
        if(lv>2.6 or lv<-2.6) then
            y = math.random(100,260);
            x = math.random(0,320)-160
        else
            break;
        end
    end
    if x>-30 and x<30 then
        x= -30;
    end
    if x>0 then
        self._toward=1;
    else
        self._toward=0;
    end
    time = math.random(SI_GAME_CONFIG.StoneJumpMinTime*10,SI_GAME_CONFIG.StoneJumpMaxTime*10);
    time=time/10;
    if _parent then
        --改变父节点
        self._stoneObj:SetParent(_parent);
    end
    localPosition = self._stoneObj:GetLocalPosition();
    x = x + localPosition.x;
    y = y + localPosition.y;
    self._throwData._throwPath = ThrowPath.CreateWithTopPoint(x,y,localPosition.x,localPosition.y);
    lowX1,lowX2 = self._throwData._throwPath:GetX(lowY);
    if self._toward==1 then
        crossX = lowX1;
    else
        crossX = lowX2;
    end
    if crossX> SI_UI_DEFINE.STONE_RIGHT_X then --飞到屏幕外了
        --self._speeds[i] = Screen.width/2/time;
        crossW = SI_UI_DEFINE.STONE_RIGHT_X - localPosition.x;
    elseif crossX< SI_UI_DEFINE.STONE_LEFT_X then  --飞到屏幕外了
        --self._speeds[i] = -Screen.width/2/time;
        crossW = SI_UI_DEFINE.STONE_LEFT_X - localPosition.x;
    else
        --self._speeds[i] = crossX/time;
        crossW = crossX - localPosition.x;
    end
    self._throwData._speed= crossW/time;
    self._throwData._beginX = localPosition.x;
    self._throwData._runTime = 0;
    self._throwData._totalTime = time;
end

function StoneNodeGrid:_updateJump(_dt)
    local x,y;
    local throwData = self._throwData;
    throwData._runTime = throwData._runTime + _dt;
    x = throwData._beginX + throwData._speed*throwData._runTime;
    y = throwData._throwPath:GetY(x);
    self._stoneObj:SetLocalPosition(Vector3.New(x,y,0));
    if throwData._runTime>=throwData._totalTime then --跳结束了 
        self._throwData._isJump = false;
        GlobalGame._gameObjManager:Push(self._stoneObj);
        self._stoneObj = nil;
    end
end

--每帧执行
function StoneNodeGrid:Update(dt)
    if self._stoneObj==nil then
        return;
    end
    if self._throwData._isJump then
        self:_updateJump(dt);
        return;
    end
    if self.isSepDisappear then
        if self.isSepDisappearStep==1 then
            self.sepScale = self.sepScale + dt/6;
            
            if self.sepScale>1.07 then
                self.sepScale = 1.07;
                self.isSepDisappearStep = 2;
                self.sepLocalPosition = self._stoneObj:GetLocalPosition();
                self.sepMoveXSpeed = 80;
                self.sepShakeSpeed = 360;
                self.sepRunTime = 0;
                self.sepHalfRunTime1 = 0.03;
                self.sepHalfRunTime2 = -0.03;
                self.sepRunTimeToward= 1;
            end
            self._stoneObj:SetLocalScale(Vector3.New(self.sepScale,self.sepScale,self.sepScale));
        elseif self.isSepDisappearStep == 2 then
            self.sepRunTime = self.sepRunTime + self.sepRunTimeToward* dt;
            while(true) do
                if self.sepRunTime<=self.sepHalfRunTime1 and self.sepRunTime>=self.sepHalfRunTime2 then
                    break;
                else
                    if self.sepRunTime>self.sepHalfRunTime1 then
                        self.sepRunTimeToward = -self.sepRunTimeToward;
                        self.sepRunTime = self.sepHalfRunTime1*2 - self.sepRunTime;
                    end
                    if self.sepRunTime<self.sepHalfRunTime2 then
                        self.sepRunTimeToward = -self.sepRunTimeToward;
                        self.sepRunTime = self.sepHalfRunTime2*2 - self.sepRunTime;
                    end
                end
            end
            local pianyiX = self.sepMoveXSpeed * self.sepRunTime;
            local shakeValue=self.sepShakeSpeed * self.sepRunTime;
            
            self._stoneObj:SetLocalRotation(Quaternion.Euler(0,0,shakeValue));
            local position = self.sepLocalPosition + Vector3.New(pianyiX,0,0);
            self._stoneObj:SetLocalPosition(position);
        end
    end
    if not self._isFallDown then
        return;
    end
    local localPosition = self._transform.localPosition;
    local x,y = localPosition.x,localPosition.y;
    y = y - SI_GAME_CONFIG.FallStoneSpeed*dt;
    if y<=self._y then
        y = self._y;
        if self._isFallDown then
            MusicManager:PlayX(GlobalGame._gameObjManager:GetMusic(SI_MUSIC_TYPE.Stone_FallDown));
        end
        self._isFallDown = false;
    end
    self._stoneObj.transform.localPosition= Vector3.New(x,y,0);
end

--是否为空
function StoneNodeGrid:IsEmpty()
    return self._stoneObj == nil;
end

--设置石头对象
function StoneNodeGrid:SetStoneObj(_obj)
    self._stoneObj = _obj;
    if self._stoneObj==nil then
        error("Empty");
    end
    self._transform = _obj.transform;
    self._isFallDown = true;
    self.isSepDisappear = false;
    --设置默认大小
    self._stoneObj:SetLocalScale(C_OneScale);
    self._stoneObj:SetLocalRotation(C_ZeroRotation);
    self._stoneObj:PlayAlways();
end

--获取
function StoneNodeGrid:GetStoneObj()
    return self._stoneObj;
end

--弹出给别个用
function StoneNodeGrid:PopStoneObj()
    local stoneObj = self._stoneObj;
    self._stoneObj = nil;
    return stoneObj;
end

--清空
function StoneNodeGrid:Clear()
    if self._stoneObj==nil then
        return;
    end
    GlobalGame._gameObjManager:Push(self._stoneObj);
    self._stoneObj = nil;
    self._transform = nil;
end

--每个砖块格子
local BrickGrid=class("BrickGrid");

function BrickGrid:ctor(_group)
    self._obj=nil;
    self._group = _group;
end

--初始化 工作
function BrickGrid:Init()

end

--消失
function BrickGrid:Disappear(_handler)
    if self._obj then
        self._obj:SetActive(false);

        local function disappearOver(obj,...)
            if _handler then
                _handler(obj,...);
            end
            GlobalGame._gameObjManager:Push(obj);
        end
        --创建
        local obj;
        if self._group==1 or self._group==2 then
            obj = GlobalGame._gameObjManager:GetEffectObj(SI_EFFECT_TYPE.Brick_Disappear);
        else
            obj = GlobalGame._gameObjManager:GetEffectObj(SI_EFFECT_TYPE.Brick2_Disappear);
        end
        obj:Disappear(disappearOver);
        obj:SetParent(self._obj.transform.parent);
        obj:SetLocalPosition(self._obj.transform.localPosition);
        obj:SetLocalScale(C_NormalVector);

        MusicManager:PlayX(GlobalGame._gameObjManager:GetMusic(SI_MUSIC_TYPE.Brick_Disappear));
    end
end

--直接隐藏
function BrickGrid:Hide()
    if self._obj then
        self._obj:SetActive(false);
    end
end


--还原
function BrickGrid:Reset()
    if self._obj then
        self._obj:SetActive(true);
    end
end

--砖游戏体
function BrickGrid:SetBrickObj(_obj)
    self._obj = _obj;
end

function BrickGrid:Destroy()
    self._obj = nil;
end

--砖块组，每关为一个砖块组
local BrickGroup=class("BrickGroup");

function BrickGroup:ctor(group)
    self._brickGrids = {};
    self._brickIndex=1;
    self._group     = group;
end

--初始化
function BrickGroup:Init()
    for i=1,SI_STAGE_BRICKS do
        self._brickGrids[i] = BrickGrid.New(self._group);
        self._brickGrids[i]:Init();
    end
end

--清除到某一个
function BrickGroup:ClearTo(index)
    index = index or SI_STAGE_BRICKS+1;
    for i=1,index-1 do
        self._brickGrids[i]:Hide();
    end
    self._brickIndex = index;
end

--清除下一个 返回是否清除完了
function BrickGroup:ClearNextBrick()
    if self._brickIndex>SI_STAGE_BRICKS then
        --这种情况出现问题
        return true;
    end
    self._brickGrids[self._brickIndex]:Disappear();
    self._brickIndex = self._brickIndex + 1;
	log("宝箱下标："..self._brickIndex);
    if self._brickIndex>SI_STAGE_BRICKS then
        return true;
    end
    return false;
end

--还原
function BrickGroup:Reset()
    for i=1,SI_STAGE_BRICKS do
        self._brickGrids[i]:Reset();
    end
    self._brickIndex=1;
end

--设置砖头游戏体
function BrickGroup:SetBrickObj(index,obj)
    if index<1 or index>SI_STAGE_BRICKS then
        return;
    end
    self._brickGrids[index]:SetBrickObj(obj);
end

function BrickGroup:Destroy()
    for i=1,SI_STAGE_BRICKS do
        self._brickGrids[i]:Destroy();
        self._brickGrids[i]=nil;
    end
    self._brickGrids = nil;
end

--砖头管理
local BrickManager = class("BrickManager");

--构造器
function BrickManager:ctor()
    self._brickGroups = {};
    self._stage  = 1;
    self._isClearAll = false;
end

--初始化
function BrickManager:Init()
    for i=1,SI_MAX_STAGE do
        self._brickGroups[i] = BrickGroup.New(i);
        self._brickGroups[i]:Init();
    end
end

--设置关卡和索引
function BrickManager:Set(stage,index)
    if stage>SI_MAX_STAGE or stage<1 then
        return;
    end
    for i=1,stage-1 do
        self._brickGroups[i]:ClearTo();
    end
    self._brickGroups[stage]:ClearTo(index);
    self._stage = stage;
end

--清除下一块砖头
function BrickManager:ClearNextBrick()
    local ret = self._brickGroups[self._stage]:ClearNextBrick();
    if ret then
        if self._stage==SI_MAX_STAGE then
            self._isClearAll = true;
        else
            --下一关
            --self._stage = self._stage + 1;
            --self._brickIndex = 1;
        end     
    end
    return ret;
end

--设置砖头游戏体
function BrickManager:SetBrickObj(stage,index,obj)
    if stage>SI_MAX_STAGE or stage<1 then
        return;
    end
    self._brickGroups[stage]:SetBrickObj(index,obj);
end

--重置
function BrickManager:Reset()
    for i=1,SI_MAX_STAGE do
        self._brickGroups[i]:Reset();
    end
    self._stage = 1;
    self._isClearAll = false;
end

--是否清空完砖头
function BrickManager:IsClearAll()
    return self._isClearAll;
end

--得到关卡
function BrickManager:GetStage()
    return self._stage;
end

--下一关
function BrickManager:NextStage()
    self._stage = self._stage + 1;
    return self._stage;
end

function BrickManager:Destroy()
    for i=1,SI_MAX_STAGE do
        self._brickGroups[i]:Destroy();
        self._brickGroups[i] = nil;
    end
    self._stage = nil;
    self._brickGroups = nil;
    self._isClearAll = nil;
end

--宝石掉落区的y索引
local READY_STONE_GRID_Y_INDEX  = SI_MAX_Y_COUNT + 3
local FALL_BEGIN_Y_INDEX = READY_STONE_GRID_Y_INDEX + 1

local DetailObjType = {
    LineDetail = 1,  --普通
    JiLeiDetail= 2,  --积累奖
};

local DetailObj = class("DetailObj");

function DetailObj:ctor(_obj,_type)
    self.gameObject = _obj;
    self.transform = _obj.transform;
    self._endY      = 0;
    self._curY      = 0;
    self._sx        = 0;
    self._type      = _type;
end

function DetailObj:Type()
    return self._type;
end

--
function DetailObj:Update(_dt)
    if self._curY < self._endY then --还需要移动
        self._curY = self._curY + SI_GAME_CONFIG.ShowLineMoveSpeed*_dt;
        if self._curY>= self._endY then
            self._curY = self._endY;
        end
        self.transform.localPosition = Vector3.New(self._sx,self._curY,0);
    else
        self.transform.localPosition = Vector3.New(self._sx,self._endY,0);
    end
end

--移动
function DetailObj:SetMovePath(_sx,_sy,_ey)
    self._sx    = _sx;
    self._endY  = _ey;
    self._curY  = _sy;
    self.transform.localPosition = Vector3.New(_sx,_sy,0);
end

--设置终点
function DetailObj:SetEndY(_ey)
    self._endY = _ey;
end

--是否移动到终点
function DetailObj:IsMoveEnd()
    return self._curY>= self._endY;
end

local DetailLineObj = class("DetailLineObj",DetailObj);

function DetailLineObj:ctor(_obj)
    DetailLineObj.super.ctor(self,_obj,DetailObjType.LineDetail);
    self._countLabel = GlobalGame._gamePanel:CreateAtlasNumber(self.transform:Find("Count"),
        1,HorizontalAlignType.Left);
    self._valueLabel = GlobalGame._gamePanel:CreateAtlasNumber(self.transform:Find("Value"),
        0,HorizontalAlignType.Right);
    self._countLabel:DisplayAdd();
    self._icon      = _obj.transform:Find("Icon"):GetComponent("Image");
end

--设置内容
function DetailLineObj:Set(_type,_count,_value)
    self._countLabel:SetNumString(_count);
    self._valueLabel:SetNumber(_value);
    self._valueLabel:SetLocalScale(Vector3.New(0.7,0.7,0.7));
    self._valueLabel:SetFontPadding(-5,true);
    self._icon.sprite    = GlobalGame._gameObjManager:GetStoneSprite(_type);
end

local JiLeiObj = class("JiLeiObj",DetailObj);

function JiLeiObj:ctor(_obj)
    JiLeiObj.super.ctor(self,_obj,DetailObjType.JiLeiDetail);
    self._valueLabel = GlobalGame._gamePanel:CreateAtlasNumber(self.transform:Find("Value"),
        0,HorizontalAlignType.Right);
end

--设置内容
function JiLeiObj:Set(_gold)
    self._valueLabel:SetNumber(_gold);
end


local DetailLineManager = class("DetailLineManager")

function DetailLineManager:ctor(panel)
    self._panel     = panel;
    self._curVec    = vector:new();
    self._oldVec    = vector:new();
    self._recoverVec= vector:new(); 
    self._recoverMap= map:new();
end

function DetailLineManager:_getFreeLineObj()
    local vec = self._recoverMap:value(DetailObjType.LineDetail);
    --获取可用的line
    if vec==nil or vec:size()==0 then
        local obj = GlobalGame._gameObjManager:CreateLineDetailObj();
        obj.transform:SetParent(self._panel);
        obj.transform.localScale = C_NormalVector;
        return DetailLineObj.New(obj);
    end
    return vec:pop_front();
end

function DetailLineManager:_getFreeJiLeiObj()
    local vec = self._recoverMap:value(DetailObjType.JiLeiDetail);
    --获取可用的line
    if vec==nil or vec:size()==0 then
        local obj = GlobalGame._gameObjManager:CreateJiLeiDetail();
        obj.transform:SetParent(self._panel);
        obj.transform.localScale = C_NormalVector;
        return JiLeiObj.New(obj);
    end
    return vec:pop_front();
end

function DetailLineManager:Add(_type,_count,_value,_lines)
    _lines = _lines or 1;
    local _tLines = _lines;
    local lineObj 
    --if self._curVec:
    local size,y
    log("显示一个宝石详情:".._type.." ".._count.." ".._lines.." _value:".._value);
    local tempFunc = function()
        lineObj = self:_getFreeLineObj();
        lineObj:Set(_type,_count,_value);
        size = self._curVec:size();
        y = SI_UI_DEFINE.DETAIL_LINE_TOP_Y-size*SI_UI_DEFINE.DETAIL_LINE_Y_DIS;
        lineObj:SetMovePath(SI_UI_DEFINE.DETAIL_LINE_TOP_X,SI_UI_DEFINE.DETAIL_LINE_START_Y,y);
        self._curVec:push_back(lineObj);
        self:_arrangePos();
    end
    --tempFunc();
    GlobalGame._timerMgr:FixUpdateTimes(tempFunc,0,0.06,1);
end

--获取积累
function DetailLineManager:AddJiLei(_gold)
    local lineObj 
    local size,y
    local tempFunc = function()
        lineObj = self:_getFreeJiLeiObj();
        lineObj:Set(_gold);
        size = self._curVec:size();
        y = SI_UI_DEFINE.DETAIL_LINE_TOP_Y-size*SI_UI_DEFINE.DETAIL_LINE_Y_DIS;
        lineObj:SetMovePath(SI_UI_DEFINE.DETAIL_LINE_TOP_X,SI_UI_DEFINE.DETAIL_LINE_START_Y,y);
        self._curVec:push_back(lineObj);
        self:_arrangePos();
    end
    GlobalGame._timerMgr:FixUpdateTimes(tempFunc,0,0.06,1);
end

function DetailLineManager:_arrangePos()
    if self._curVec:size()>SI_GAME_CONFIG.ShowLineCount then
        local front = self._curVec:pop_front();
        front:SetEndY(SI_UI_DEFINE.DETAIL_LINE_DISAPPEAR_Y);
        self._oldVec:push_back(front);
        local it =self._curVec:iter();
        local val,y;
        local i=0;
        val = it();
        while(val) do
            y = SI_UI_DEFINE.DETAIL_LINE_TOP_Y-i*SI_UI_DEFINE.DETAIL_LINE_Y_DIS;
            val:SetEndY(y);
            val = it();
            i = i +1;
        end
    else
        
    end
end

--清空列表
function DetailLineManager:Clear()
    local it =self._curVec:iter();
    local line=it();
    while(line) do
        self._oldVec:push_back(line);
        line:SetEndY(SI_UI_DEFINE.DETAIL_LINE_DISAPPEAR_Y);
        line = it();
    end
    self._curVec:clear();
end


function DetailLineManager:Update(_dt)
    local it =self._curVec:iter();
    local line=it();
    while(line) do
        line:Update(_dt);
        line = it();
    end
    it = self._oldVec:iter();
    line = it();
    while(line) do
        line:Update(_dt);
        line = it();
    end

    if (self._oldVec:size()>0) then
        local obj = self._oldVec:get(1);
        if obj:IsMoveEnd() then
            --从旧队列里剔除
            self._oldVec:pop_front();
            local vec = self._recoverMap:value(obj:Type());
            if vec ==nil then
                vec = vector:new();
                self._recoverMap:assign(obj:Type(),vec);
            end
            vec:push_back(obj);
            ----放到回收队列里
            --self._recoverVec:push_back(obj);
        end
    end
end


local BUTTON_TYPE = {
    Btn_Null        = 0,
    Btn_StartGame   = 1,
    Btn_Lines       = 2,
    Btn_Bets        = 3,
    Btn_StopAuto    = 4,
};


local LongPressControl = class("LongPressControl");

function LongPressControl:ctor()
    self.isDown      = false;
    self.pressTime   = 0;
    self.btnType     = BUTTON_TYPE.Btn_Null;
    self.isLongPress = false;
    self.longHandler = nil;
    self.shortHandler= nil;
    self.count       = 0; --执行次数
    self.longKeyTime = 0;
    self.intervalTime= 0;
end

--开始
-- @longPressTime 长按时间
-- @intervalTime 周期频率
-- @longPressHandler 长按事件
-- @shortPressHandler 短按事件 
function LongPressControl:Start(_type,longPressTime,intervalTime,longPressHandler,shortPressHandler)
    self.longPressTime  = longPressTime or 0; --长按键时间
    self.intervalTime   = intervalTime or 0; --周期时间
    self.btnType        = _type;
    self.longHandler    = longPressHandler;
    self.shortHandler   = shortPressHandler;
    self.isDown         = true;
    self.pressTime      = 0;
    self.isLongPress    = false;
end

--停止
function LongPressControl:Stop()
    self.isDown      = false;
    if self.isLongPress then
    else
        if self.shortHandler then
            self.shortHandler(self.btnType);
        end
    end
    self.isLongPress = false;
end

--执行 
function LongPressControl:Execute(_dt)
    --不是长按状态
    if not self.isDown then
        return ;
    end
    self.pressTime = self.pressTime + _dt;
    if self.isLongPress then
        if self.pressTime>= self.intervalTime then
            self.pressTime = self.pressTime - self.intervalTime;
            if self.longHandler then
                self.longHandler(self.btnType,self.count);
            end
            self.count = self.count + 1;
        end
    else
        if self.pressTime>= self.longPressTime then
            self.pressTime = self.pressTime - self.longPressTime;
            if self.longHandler then
                self.longHandler(self.btnType,self.count);
            end
            self.count = self.count + 1;
            self.isLongPress = true;
        end
    end

    
end

local FallStonePanel = class("FallStonePanel");

function FallStonePanel:ctor(gamePanel)
    self.gamePanel  = gamePanel;
    self._stoneNodeGrid = {};
    self._stage = 1;
    self._xBegin = 2;
    self._yBegin = 1;
    self._startMode = SI_GAME_MODE.Hand; --是否自动
    self._isPointDown = false;
    self._pointTime = 0; 
    self._pressCtrl = LongPressControl.New();

    self._selectLines = 1;
    self._selectBetIndex = 0;

    local x,y
    for j=1,SI_MAX_Y_COUNT do
        self._stoneNodeGrid[j]={};
        for i=1,SI_MAX_X_COUNT do
            --创建格子
            x = SI_UI_DEFINE.STONE_GRID_BEGIN_X + (i-1)*SI_UI_DEFINE.STONE_GRID_BEGIN_X_DIS;
            y = SI_UI_DEFINE.STONE_GRID_BEGIN_Y + (j-1)*SI_UI_DEFINE.STONE_GRID_BEGIN_Y_DIS;
            self._stoneNodeGrid[j][i] = StoneNodeGrid.New(x,y);
        end
    end

    --初始化待落区的
    self._stoneNodeGrid[READY_STONE_GRID_Y_INDEX]={};
    for i=1,SI_MAX_X_COUNT do
        --创建格子
        x = SI_UI_DEFINE.STONE_GRID_BEGIN_X + (i-1)*SI_UI_DEFINE.STONE_GRID_BEGIN_X_DIS + SI_UI_DEFINE.STONE_GRID_READY_OFFSET_X;
        y = SI_UI_DEFINE.STONE_GRID_BEGIN_Y + (READY_STONE_GRID_Y_INDEX-1)*SI_UI_DEFINE.STONE_GRID_BEGIN_Y_DIS + SI_UI_DEFINE.STONE_GRID_READY_OFFSET_Y;
        self._stoneNodeGrid[READY_STONE_GRID_Y_INDEX][i] = StoneNodeGrid.New(x,y);
    end

    --创建砖头
    self._brickManager = BrickManager.New();
    self._brickManager:Init();

    --事件注册
    --开始游戏事件
    GlobalGame._eventSystem:RegEvent(SI_EventID.NotifyStartGame,self,self.NotifyStartGame);
    --龙珠关卡事件
    --GlobalGame._eventSystem:RegEvent(SI_EventID.NotifyDragonMission,self,self.NotifyStartDragonMission);
    --彩金改变事件
    GlobalGame._eventSystem:RegEvent(SI_EventID.NotifyUICaiJin,self,self.NotifyCaijin);
    --通知下落宝石
    GlobalGame._eventSystem:RegEvent(SI_EventID.NotifyUIFallStone,self,self.NotifyUIFallDownStone);
    --通知结算
    GlobalGame._eventSystem:RegEvent(SI_EventID.NotifyUIBalance,self,self.NotifyUIBalance);
    --清除锥子
    GlobalGame._eventSystem:RegEvent(SI_EventID.NotifyUIClearDrill,self,self.NotifyUIClearDrill);
    --显示积累奖
    GlobalGame._eventSystem:RegEvent(SI_EventID.NotifyUIJiLeiShow,self,self.NotifyUIJiLeiShow);
    --清除宝石
    GlobalGame._eventSystem:RegEvent(SI_EventID.NotifyUIClearStone,self,self.NotifyCountStone);
    --移动宝石
    GlobalGame._eventSystem:RegEvent(SI_EventID.NotifyUIMoveStone,self,self.NotifyUIMoveStone);
    --金钱改变
    GlobalGame._eventSystem:RegEvent(SI_EventID.NotifyChangeGold,self,self.NotifyChangeGold);
    --通知经验改变
    GlobalGame._eventSystem:RegEvent(SI_EventID.NotifyChangeDragonData,self,self.NotifyChangeDragonData);

    --按钮
    self._startGameBtn=nil;
    --按钮
    self._stopAutoStartBtn=nil;

    --应该暂时没用了
    self._numSprite = {};

    --结算倍数
    self._balanceMultiple = 0;
    self._isJileiJiang    = false;

    --当前连线数
    self._curLianCount    = 0;

    --1  显示数字后，会自动减少， 
    --2  显示数字后不会减少，点开始后开始减少 自动模式下会自动减少
    self._balanceType = 2; 

    --是否可以开始游戏
    self._isCanStartGame = true;
    --是否清理过游戏数据
    self._isClearCurGameData = true; 
    self._clearWaitTime  = 2; --清理等待时间
end

--初始化
function FallStonePanel:Init(obj)
    self.transform = obj.transform;
    self.go        = obj;
    self.gameObject= obj;

    local stonePanel = self.transform:Find("StonePanel");
    --初始化砖头
    local brickPanel = stonePanel:Find("BrickPanel");
    local brickGroupCount = brickPanel.childCount;
    local brickCount;
    local brickGroup;
    local brick;
    local newSprite;
    
    local spr 
    for i=1,brickGroupCount do
        brickGroup = brickPanel:GetChild(i-1);
        brickCount = brickGroup.childCount;
        for j=1,brickCount do
            brick = brickGroup:GetChild(j-1);
            self._brickManager:SetBrickObj(i,j,brick.gameObject);
        end
    end

    --存放石头的容器
    self._stonesPanel = stonePanel:Find("FallStonePanel");

    self._jumpStonePanel = stonePanel:Find("JumpStonePanel");

    local Effect = stonePanel:Find("Effect");

    --连击数
    self._displayComb = {
        gameObject = nil,
        combNum    = 0,
        nextNum    = 0,
        combLabel  = nil,
        scale      = Vector3.one,
        hide = function(self)
            self.gameObject:SetActive(false);
            self.combNum = nil;
        end,
        _setComb = function(self,comb)
            if comb>=SI_GAME_CONFIG.BurningCombLine then
                self.comb_fire:Show();
                self.go_com_comb:SetActive(false); 
            else
                self.comb_fire:Hide(); 
                self.go_com_comb:SetActive(true);      
            end
            self.combLabel:SetNumString(comb);
            self.combNum = comb;
            self.nextNum = nil;
        end,
        setComb = function(self,comb)
            self.gameObject:SetActive(true);
            if self.combNum==nil then
                self.combLabel:SetNumString(comb);
                self.combNum = comb;
                if comb>=SI_GAME_CONFIG.BurningCombLine then
                    self.comb_fire:Show();
                    self.go_com_comb:SetActive(false); 
                else
                    self.comb_fire:Hide(); 
                    self.go_com_comb:SetActive(true);      
                end
                self.combLabel:SetLocalScale(C_OneScale);
                self.nextNum = nil;
            else
                if self.nextNum then
                    self:_setComb(self.nextNum);
                end
                self.combLabel:SetLocalScale(C_OneScale);
                self.nextNum = comb;
                self.scale.x = 1;
                self.scale.y = 1;
                self.scale.z = 1;
                self.isScaleBig = true;
            end
        end,
        addComb = function(self)
            self:setComb(self.combNum + 1);
        end,
        init    = function(self,transform,ctl)
            self.gameObject = transform.gameObject;
            local front = transform:Find("Front");
            self.trans_com_comb = front:Find("Tag");
            self.go_com_comb = self.trans_com_comb.gameObject;
            local action = front:Find("Action");
            self.combLabel = ctl.gamePanel:CreateAtlasNumber(front:Find("CombNum"),0,HorizontalAlignType.Right);
            self.comb_fire = GlobalGame._gameObjManager:GetEffectObj(SI_EFFECT_TYPE.Comb_Fire);
            self.comb_fire:SetParent(action);
            self.comb_fire:SetLocalPosition(C_ZeroPos);
            self.comb_fire:SetLocalScale(C_OneScale);
            self.comb_fire:PlayAlways();
        end,
        update = function(self,_dt)
            if self.nextNum then
                if self.isScaleBig then
                    local addNum = _dt*3;
                    self.scale.x = self.scale.x + addNum;
                    self.scale.y = self.scale.y + addNum;
                    self.scale.z = self.scale.z + addNum;
                    if self.scale.x>1.5 then
                        self.scale.x = 1.5;
                        self.scale.y = 1.5;
                        self.scale.z = 1.5;
                        self.isScaleBig = false;
                        self.combLabel:SetNumString(self.nextNum);
                        if self.nextNum>=SI_GAME_CONFIG.BurningCombLine then
                            self.comb_fire:Show();
                            self.go_com_comb:SetActive(false); 
                        else
                            self.comb_fire:Hide(); 
                            self.go_com_comb:SetActive(true);      
                        end  
                    end
                    self.combLabel:SetLocalScale(self.scale);
                else
                    local addNum = _dt*5;
                    self.scale.x = self.scale.x - addNum;
                    self.scale.y = self.scale.y - addNum;
                    self.scale.z = self.scale.z - addNum;
                    if self.scale.x<=1 then
                        self.scale.x = 1;
                        self.scale.y = 1;
                        self.scale.z = 1;
                        self.isScaleBig = false;
                        self.combNum = self.nextNum;
                        self.nextNum = nil;  
                    end
                    self.combLabel:SetLocalScale(self.scale);
                end
            end
        end,
    };

    self._displayComb:init(Effect:Find("Comb"),self);

    local particleSystem = Effect:Find("jujiang"):GetComponent("ParticleSystem");

    --结算文字
    self._balanceNumber = BalanceNumber.New();
    local rewards = Effect:Find("CommonBalance");
    local label = self.gamePanel:CreateAtlasNumber(rewards);
    self._balanceNumber:Push(SI_BALANCE_TYPE.Common,rewards.gameObject,label);
    
    rewards = Effect:Find("BigBalance");
    label = self.gamePanel:CreateAtlasNumber(rewards);
    self._balanceNumber:Push(SI_BALANCE_TYPE.Big,rewards.gameObject,label);

    rewards = Effect:Find("LargeBalance");
    label = self.gamePanel:CreateAtlasNumber(rewards);
    self._balanceNumber:Push(SI_BALANCE_TYPE.Large,rewards.gameObject,label,particleSystem);

    rewards = Effect:Find("SuperLargeBalance");
    label = self.gamePanel:CreateAtlasNumber(rewards);
    self._balanceNumber:Push(SI_BALANCE_TYPE.LeiJi,rewards.gameObject,label,particleSystem);


    --右边的窗口
    self.rightPanel       = self.transform:Find("RightPanel");

    --获得宝石的详细窗口
    self.getStoneDetail   = self.rightPanel:Find("GetStoneDetailPanel");
    self._lineDetailsMgr = DetailLineManager.New(self.getStoneDetail);

    --线数游戏体
    self._linesCtrl={
        atlasLabel=nil,
        linesBtn =nil,
        line = 0,
        isLoop = false,
        maxCount =0,
        addDisabledObj      =nil,
        reduceDisabledObj   =nil,
        activeObjs = {
        },
        unactiveObjs = {
        },
        setLines=function(this,index,isDisplayNumber)
            isDisplayNumber = isDisplayNumber or false;
            if index<=0 or index>SI_MULTIPLE_MAX then
                return ;
            end
            this.line = index;
            if this.atlasLabel and isDisplayNumber then
                this.atlasLabel:SetNumString(index);
            end
            for i=1,index do
                this.activeObjs[i]:SetActive(true);
                this.unactiveObjs[i]:SetActive(false);
            end
            for i=index+1,this.maxCount do
                this.unactiveObjs[i]:SetActive(true);
                this.activeObjs[i]:SetActive(false);
            end
        end,
        getLines= function(this)
            return this.line;
        end,
        addLines= function(this,num)
            num = num or 1;
            if this.line<SI_MULTIPLE_MAX then
                this.line = this.line + num;
            else              
                if not this.isLoop then
                    return ;
                end
                this.line = 1;
            end
            this:setLines(this.line);
        end,
        reduceLines= function(this,num)
            num = num or 1;
            if this.line>num then
                this.line = this.line - num;
            else
                if not this.isLoop then
                    return ;
                end
                this.line = SI_MULTIPLE_MAX;
            end
            this:setLines(this.line);
        end,
        disabled = function(self)
            self.addDisabledObj:SetActive(true);
            self.reduceDisabledObj:SetActive(true);
        end,
        normal = function(self)
            self.addDisabledObj:SetActive(false);
            self.reduceDisabledObj:SetActive(false);
        end,
    };
    local lineDetailPanel = self.rightPanel:Find("LineDetailPanel");
    local lineItems       = lineDetailPanel:Find("LineItems");
    local childCount      = lineItems.childCount;
    local child ;
    for i=1,childCount do
        child = lineItems:GetChild(i-1);
        self._linesCtrl.activeObjs[i] = child:Find("Active").gameObject;
        self._linesCtrl.unactiveObjs[i] = child:Find("Unactive").gameObject;
    end
    self._linesCtrl.maxCount = childCount;

    --显示线数
    self._linesCtrl.atlasLabel = self.gamePanel:CreateAtlasNumber(lineDetailPanel:Find("LineNumber"));

    --设置默认线数
    self._linesCtrl:setLines(self._selectLines);

    local btn = lineDetailPanel:Find("Add");
    local eventTrigger = Util.AddComponent("EventTriggerListener",btn.gameObject);
    eventTrigger.onClick = handler(self,self.__onLinesAdd);
    local disabledObj = btn:Find("Disabled");
    self._linesCtrl.addDisabledObj = disabledObj.gameObject;

    btn = lineDetailPanel:Find("Reduce");
    eventTrigger = Util.AddComponent("EventTriggerListener",btn.gameObject);
    eventTrigger.onClick = handler(self,self.__onLinesReduce);
    disabledObj = btn:Find("Disabled");
    self._linesCtrl.reduceDisabledObj = disabledObj.gameObject;

    --筹码模块
    local betPanel   = self.rightPanel:Find("BetPanel");
    btn = betPanel:Find("Add");
    eventTrigger = Util.AddComponent("EventTriggerListener",btn.gameObject);
    eventTrigger.onClick = handler(self,self.__onBetAdd);

    disabledObj = btn:Find("Disabled");
    self.betAddDisabledObj = disabledObj.gameObject;

    btn = betPanel:Find("Reduce");
    eventTrigger = Util.AddComponent("EventTriggerListener",btn.gameObject);
    eventTrigger.onClick = handler(self,self.__onBetReduce);

    disabledObj = btn:Find("Disabled");
    self.betReduceDisabledObj = disabledObj.gameObject;

    
    self.betAtlasLabel = self.gamePanel:CreateAtlasNumber(betPanel:Find("BetNumber"));
    self.totalAtlasLabel = self.gamePanel:CreateAtlasNumber(betPanel:Find("TotalNumber"));
    self:_setSelectBetIndex(self._selectBetIndex);


    --按钮组
    self._buttonsCtrl = {
        normalBtn = nil,
        autoBtn   = nil,
        startBtn  = nil,
        isStart   = false,
        start     = function(self)
            self.isStart = true;
        end,
        auto      = function(self)
            self.isStart = true;
            self.normalBtn:SetActive(true);
            self.autoBtn:SetActive(false);
            --self.startBtn:SetActive(false);
            self:disabled();
        end,
        normal    = function(self)
            self.normalBtn:SetActive(false);
            self.autoBtn:SetActive(true);
            --self.startBtn:SetActive(true);
        end,
        disabled = function(self)
            self.disabledBtn:SetActive(true);
        end,
        endisabled = function(self)
            self.disabledBtn:SetActive(false);
        end,
    };
    --按钮组
    local buttonPanel = self.rightPanel:Find("ButtonPanel");
    btn = buttonPanel:Find("Start");
    self._buttonsCtrl.startBtn = btn.gameObject;
    eventTrigger = Util.AddComponent("EventTriggerListener",btn.gameObject);
    eventTrigger.onClick = handler(self,self._onStartGameClick);
    self._buttonsCtrl.disabledBtn = btn:Find("Disabled").gameObject;


    btn = buttonPanel:Find("Auto");
    self._buttonsCtrl.autoBtn = btn.gameObject;
    eventTrigger = Util.AddComponent("EventTriggerListener",btn.gameObject);
    eventTrigger.onClick = handler(self,self._onAutoClick);

    btn = buttonPanel:Find("Normal");
    self._buttonsCtrl.normalBtn = btn.gameObject;
    eventTrigger = Util.AddComponent("EventTriggerListener",btn.gameObject);
    eventTrigger.onClick = handler(self,self._onNormalClick);
    
    --提示文本
    self._tipsText =  stonePanel:Find("TipsText"):GetComponent("Text");
--    local function fadeOut(_image,_ba,_ea,_sa)
--        coroutine.start(
--            function()
--                coroutine.wait(2.5);
--                local _ca = _ba;
--                while(_ca>_ea) do
--                    coroutine.wait(0.020);
--                    _ca =_ca + _sa;
--                    if _ca<0 then
--                        _ca=0;
--                    end
--                    if not GlobalGame.isInGame then
--                        return;
--                    end
--                    if IsNil(_image) then
--                        return;
--                    end
--                    _image.color = Color.New(1,1,1,_ca);
--                end
--            end
--        )
--    end
--    fadeOut(self._tipsText,1,0,-0.03);

    local function fadeOut(_image,_ba,_ea,_sa)
        local temp=function()
            local _ca = _ba;
            local tpFunc;
            tpFunc = function()
                _ca =_ca + _sa;
                if _ca<0 then
                    _ca=0;
                end
                if IsNil(_image) then
                    return;
                end
                _image.color = Color.New(1,1,1,_ca);
                if (_ca>_ea) then
                    GlobalGame._timerMgr:FixUpdateOnce(tpFunc,0.02);
                else
                     return ;   
                end
            end
            GlobalGame._timerMgr:FixUpdateOnce(tpFunc,0.02);
        end
        GlobalGame._timerMgr:FixUpdateOnce(temp,2.5);
    end
    fadeOut(self._tipsText,1,0,-0.03);

    

    --整理总下注
    self:_arrangeTotalBet();

    --设置要状态
    self:_setGameState(SI_GAME_STATE.Null);
end

--开始游戏按钮点击
function FallStonePanel:_onStartGameClick()
    if self._gameState == SI_GAME_STATE.RequestGameData then
        return SI_DONE_CODE.Done_Doing;
    end
    if self._gameState ~= SI_GAME_STATE.Free then
        return SI_DONE_CODE.Done_InvalidOperate;
    end
    local stageData = SI_STAGE_DATA[self._stage];
    local bet = SI_STAGE_DATA:getBet(self._stage,self._selectBetIndex);
    local totalGold = self._selectLines*bet;
    if not GlobalGame._gameControl._playerData:IsEnoughGold(totalGold) then
        self:SwitchToHandMode();--关闭自动开始功能
        self._buttonsCtrl:endisabled();
        AlertStaticPanel.New(GlobalGame._tipLayer,SI_WORD[SI_WORD_CODE.RECHANGE_TIPS]);--弹出提示
        return SI_DONE_CODE.Done_NoGold;
    end
    self:_setGameState(SI_GAME_STATE.RequestGameData);--设置游戏状态
    GlobalGame._gameControl:RequestStartGame(self._selectLines,self._selectBetIndex);--请求开始游戏 选择的线数 选择的押注值下标
    self:ClearCurGameData();
    return SI_DONE_CODE.Done_Success;
end


function FallStonePanel:ClearCurGameData()
    if  self._isClearCurGameData then
        return ;
    end

    --清空连线列表
    self._lineDetailsMgr:Clear(); 

    --清理当前关游戏数据
    self._isClearCurGameData = true;

    --跳宝石
    if self:IsAllEmpty() then
        self._isCanStartGame = true;
        self._balanceNumber:Stop();        
    else
        --local curGold = GlobalGame._gameControl._playerData:GetGold();
        local curGold = TableUserInfo._7wGold;
        local function addGold(isOver,num)
            GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyAddGold,num);
            if isOver then
                local tempFunc = function()
                    self._balanceNumber:Stop();
                end 
                GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyChangeGold,curGold);
                GlobalGame._timerMgr:FixUpdateOnce(tempFunc,0.1);
            end
        end
        if self._balanceNumber:GetNumber()>0 then
            if self._balanceType==1 then
                self._balanceNumber:Stop();
            elseif self._balanceType==2 then
                if self._balanceNumber:GetNumber()>100000 then
                    self._balanceNumber:ReduceNumber(0,0.5,addGold);
                else
                    self._balanceNumber:ReduceNumber(0,0.5,addGold);
                end 
            end
        end


        self:JumpStone();
        self._isCanStartGame = false; 
        local tempFunc = function ()
            self._isCanStartGame = true;
        end
        GlobalGame._timerMgr:FixUpdateOnce(tempFunc,SI_GAME_CONFIG.StoneJumpMaxTime+0.4);
    end
end

--是否可以开始游戏
function FallStonePanel:IsCanStartGame()
    return self._isCanStartGame;
end

--自动点击
function FallStonePanel:_onAutoClick()
    --自动模式
    self:SwitchToAutoStart();
    --点击开始
    self:_onStartGameClick(); 
end

function FallStonePanel:_onNormalClick()
    --手动模式
    self:SwitchToHandMode();
end

--龙珠点击
function FallStonePanel:_onDragonBallClick()

end

--开始龙珠关卡按钮
function FallStonePanel:_onStartDragonMissionClick()

end

--长按
function FallStonePanel:__longPressStartGame()
    if self._startMode~=SI_GAME_MODE.Auto then
        --self:Destroy();
        self:SwitchToAutoStart();
        --改变按钮的形状
        --local code = self:_onStartGameClick();

        --金币不足弹出不足界面
        if code == SI_DONE_CODE.Done_NoGold then
            
        end
    end
end

--短按
function FallStonePanel:__shortPressStartGame()
    local code = self:_onStartGameClick();
    --金币不足弹出不足界面
    if code == SI_DONE_CODE.Done_NoGold then
        
    end
end

--按钮按下事件
function FallStonePanel:__onStartGamePointDown()
    self._pressCtrl:Start(BUTTON_TYPE.Btn_Lines,
                SI_GAME_CONFIG.AutoStartTime,
                9999,
                handler(self,self.__longPressStartGame),
                handler(self,self.__shortPressStartGame));
end

--按钮弹起事件
function FallStonePanel:__onStartGamePointUp()
    self._pressCtrl:Stop();
end


--按钮按下事件
function FallStonePanel:__onStopAutoPointDown()
--    self._pressCtrl:Start(BUTTON_TYPE.Btn_StopAuto,
--                SI_GAME_CONFIG.AutoStartTime,
--                9999,
--                nil,
--                handler(self,self.__shortPressStartGame));
    self:_onStopAutoClick();
end

--按钮弹起事件
function FallStonePanel:__onStopAutoPointUp()
    --self._pressCtrl:Stop();
end

function FallStonePanel:__onLinesAdd()
    if self._gameState ~= SI_GAME_STATE.Free then --只有再下注阶段才可以
        return;
    end
    self._selectLines = self._selectLines + 1;
    if self._selectLines >SI_MULTIPLE_MAX then
        self._selectLines = 1;
    end
    --改变UI状态
    self._linesCtrl:setLines(self._selectLines,true);
    --self._linesCtrl:addLines();
    self:_arrangeTotalBet();
end

function FallStonePanel:__onLinesReduce()
    if self._gameState ~= SI_GAME_STATE.Free then --只有再下注阶段才可以
        return;
    end
    self._selectLines = self._selectLines - 1;
    if self._selectLines <1 then
        self._selectLines = SI_MULTIPLE_MAX;
    end
    --改变UI状态
    self._linesCtrl:setLines(self._selectLines,true);
    --self._linesCtrl:reduceLines();
    self:_arrangeTotalBet();
end


function FallStonePanel:_setLines(line)
    if line<1 or line >SI_MULTIPLE_MAX then
        return ;
    end
    self._selectLines = line;
    --改变UI状态
    self._linesCtrl:setLines(self._selectLines,true);
end


function FallStonePanel:__onBetAdd()
    if self._gameState ~= SI_GAME_STATE.Free then --只有再下注阶段才可以
        return;
    end
    local stageData = SI_STAGE_DATA[self._stage];
    self._selectBetIndex = self._selectBetIndex+1;
    if self._selectBetIndex>=stageData.betCount then
        self._selectBetIndex = 0;
    end
    --改变UI底注
    self:_setSelectBetIndex(self._selectBetIndex);
    self:_arrangeTotalBet();
end

function FallStonePanel:__onBetReduce()
    if self._gameState ~= SI_GAME_STATE.Free then --只有再下注阶段才可以
        return;
    end
    local stageData = SI_STAGE_DATA[self._stage];
    self._selectBetIndex = self._selectBetIndex-1;
    if self._selectBetIndex<0 then
        self._selectBetIndex = stageData.betCount - 1;
    end
    --改变UI底注
    self:_setSelectBetIndex(self._selectBetIndex);
    self:_arrangeTotalBet();
end

function FallStonePanel:_setSelectBetIndex(_index)
    local stageData = SI_STAGE_DATA[self._stage];
    if _index<0 or _index>=stageData.betCount then
        return ;
    end
    self._selectBetIndex = _index;
    --改变UI底注
    local betNum = SI_STAGE_DATA:getBet(self._stage,self._selectBetIndex);
    if betNum>=100000 then
        --设置间距
        self.betAtlasLabel:SetFontPadding(-6,true);
    else
        --设置间距
        self.betAtlasLabel:SetFontPadding(0,false);
    end
    self.betAtlasLabel:SetNumber(betNum);
end

--整理总下注
function FallStonePanel:_arrangeTotalBet()
    local betNum = SI_STAGE_DATA:getBet(self._stage,self._selectBetIndex);
    local totalNumber  = betNum * self._selectLines;
    self.totalAtlasLabel:SetNumber(totalNumber);
end

--按下线数
function FallStonePanel:__onLinesPointDown()
    if self._gameState ~= SI_GAME_STATE.Free then --只有再下注阶段才可以
        return;
    end
    local handler = handler(self,self.SwitchLines);
    self._pressCtrl:Start(BUTTON_TYPE.Btn_Lines,SI_GAME_CONFIG.LongPressBtnTime,SI_GAME_CONFIG.LongPressInterval,handler,handler);
end

--线数弹起
function FallStonePanel:__onLinesPointUp()
    self._pressCtrl:Stop();
end

--按下下注
function FallStonePanel:__onBetPointDown()
    if self._gameState ~= SI_GAME_STATE.Free then --只有再下注阶段才可以
        return;
    end
    local handler = handler(self,self.SwitchBetIndex);
    self._pressCtrl:Start(BUTTON_TYPE.Btn_Lines,SI_GAME_CONFIG.LongPressBtnTime,SI_GAME_CONFIG.LongPressInterval,handler,handler);
end

--下注弹起
function FallStonePanel:__onBetPointUp()
    self._pressCtrl:Stop();
end

function FallStonePanel:_updateStone(_dt)

    for j=1,SI_MAX_Y_COUNT do
        for i=1,SI_MAX_X_COUNT do
            self._stoneNodeGrid[j][i]:Update(_dt);
        end
    end

    --初始化待落区的
    for i=1,SI_MAX_X_COUNT do
        self._stoneNodeGrid[READY_STONE_GRID_Y_INDEX][i]:Update(_dt);
    end
end

--每帧调
function FallStonePanel:Update(_dt)
    --执行长按事件
    self._pressCtrl:Execute(_dt);
    --自动开始
    if self._startMode == SI_GAME_MODE.Auto then
        if self._gameState == SI_GAME_STATE.Free then
            --通知请求开始游戏
            self:_onStartGameClick();
        end
    end
    --遍历update方法
    --self:_foreachStoneNodeGrid(StoneNodeGrid.Update,_dt);
    if self._startMode == SI_GAME_MODE.Hand then
        --手动模式下，如果没有清理游戏数据就清理下
        if not self._isClearCurGameData then
            --定时清理下
            self._clearWaitTime = self._clearWaitTime - _dt;
            if self._clearWaitTime<=0 then
                self:ClearCurGameData();
                self._clearWaitTime = 999999;
            end
        end
    end 
    self:_updateStone(_dt);
    self._lineDetailsMgr:Update(_dt);
    --结算
    self._balanceNumber:Update(_dt);
    --连击控制
    self._displayComb:update(_dt);
end

--得到具体的宝石格子
function FallStonePanel:_getStoneGrid(_xIndex,_yIndex)
    return self._stoneNodeGrid[_yIndex + self._yBegin-1][_xIndex+self._xBegin-1];
end

--得到准备区的格子
function FallStonePanel:_getReadyStoneGrid(_xIndex)
    return self._stoneNodeGrid[READY_STONE_GRID_Y_INDEX][_xIndex+self._xBegin-1];
end

--创建石头游戏体
function FallStonePanel:_createStone(_type)
    local obj = GlobalGame._gameObjManager:GetObj(SI_OBJ_CLASS.Stone,_type);
end


--切换线
function FallStonePanel:SwitchLines()
    if self._gameState ~= SI_GAME_STATE.Free then --只有再下注阶段才可以
        return;
    end
    self._selectLines = self._selectLines + 1;
    if self._selectLines >SI_MULTIPLE_MAX then
        self._selectLines = 1;
    end
    --改变UI状态
    self._linesCtrl:setLines(self._selectLines,true);
end

--切换下一个筹码
function FallStonePanel:SwitchBetIndex()
    if self._gameState ~= SI_GAME_STATE.Free then --只有再下注阶段才可以
        return;
    end
    local stageData = SI_STAGE_DATA[self._stage];
    self._selectBetIndex = self._selectBetIndex+1;
    if self._selectBetIndex>=stageData.betCount then
        self._selectBetIndex = 0;
    end
    --改变UI底注
    local betNum = SI_STAGE_DATA:getBet(self._stage,self._selectBetIndex);
    self._betTextLabel.text = tostring(betNum);
end

--切换到自动模式
function FallStonePanel:SwitchToAutoStart()
    self._startMode = SI_GAME_MODE.Auto;
    self._buttonsCtrl:auto();
end

--切换回手动模式
function FallStonePanel:SwitchToHandMode()
    self._startMode = SI_GAME_MODE.Hand;
    self._buttonsCtrl:normal();
end


--删除锥子
function FallStonePanel:ClearDrill()
    
end


--切换到下一关
function FallStonePanel:SwithNextStage()
    
end

--获取下落的起始位置
function FallStonePanel:_getBeginFallPos(_x)
    local x = SI_UI_DEFINE.STONE_GRID_BEGIN_X + (self._xBegin + _x-2)*SI_UI_DEFINE.STONE_GRID_BEGIN_X_DIS;
    local y = SI_UI_DEFINE.STONE_GRID_BEGIN_Y + (FALL_BEGIN_Y_INDEX+self._yBegin-2)*SI_UI_DEFINE.STONE_GRID_BEGIN_Y_DIS;
    return x,y;
end

function FallStonePanel:_setDragonData(_stage,_precent)

end

--通知经验等级
function FallStonePanel:NotifyChangeDragonData(_eventId,_dragonData)

end

--获取指定格子的位置
--function 

--下落石头
function FallStonePanel:FallStone()
    local funcOver =function()
        --下落完成
        GlobalGame._eventSystem:DispatchEvent(SI_EventID.FallDownOverCallBack);
    end
    local nex,stoneGrid,stoneObj;
    local x,y
    local isFallFromReady=false;
    local func1
    func1 = function()
        nex = GlobalGame._gameControl:NextFallData();
        if nex==nil then
            --时间间隔
            GlobalGame._timerMgr:FixUpdateOnce(funcOver,SI_GAME_CONFIG.FallOverWaitTime); 
            return;
        end
        x,y = self:_getBeginFallPos(nex.fallX);
        stoneGrid = self:_getReadyStoneGrid(nex.fallX);
        if stoneGrid==nil then
            --自动改为手动模式
            self:SwitchToHandMode();
        end
        isFallFromReady=false;
        if stoneGrid then
            if stoneGrid:IsEmpty() then 
                if nex._type ~= nil then
                    stoneObj = GlobalGame._gameObjManager:GetStoneObj(nex._type);
                else
                    error("nex._type == nil");
                end 
            else
                if nex.fallY==-1 then
                    stoneObj = nil;
                else
                    isFallFromReady=true;
                    --从待落区落下
                    stoneObj = stoneGrid:PopStoneObj();
                end
            end
        end
        if stoneObj then
            if nex.fallY==-1 then
                stoneGrid = self:_getReadyStoneGrid(nex.fallX);
            else
                stoneGrid = self:_getStoneGrid(nex.fallX,nex.fallY);
            end
            if stoneGrid then
                stoneGrid:SetStoneObj(stoneObj);
                if not isFallFromReady then
                    stoneObj.transform:SetParent(self._stonesPanel);
                    stoneObj.transform.localPosition = Vector3.New(x,y,0);
                    stoneObj.transform.localScale    = Vector3.New(1,1,1);
                end
            end
        end
        --时间间隔
        GlobalGame._timerMgr:FixUpdateOnce(func1,SI_GAME_CONFIG.FallStoneInterval);
    end
    func1();
end

function FallStonePanel:NotifyUIJiLeiShow(_eventId,_gold)
    --显示积累奖
    self._balanceNumber:SetNumber(SI_BALANCE_TYPE.LeiJi,_gold);
    self._lineDetailsMgr:AddJiLei(_gold);
    local displayOver = function()
        --消失积累奖
        self._balanceNumber:Stop();
        local gotoNextState = function()
            --积累奖显示结束
            GlobalGame._eventSystem:DispatchEvent(SI_EventID.JiLeiShowCallBack);
        end
        GlobalGame._timerMgr:FixUpdateOnce(gotoNextState,0.5);
    end
    GlobalGame._timerMgr:FixUpdateOnce(displayOver,SI_GAME_CONFIG.JiLeiShowTime);
end

--计算石头
function FallStonePanel:NotifyCountStone(_eventId,vec)
        local func=function ()
            local it    = vec:iter();
            local val   =  it();
            local it2,val2;
            local stoneGrid;
            local _type ;
            --local multiple = SI_STAGE_DATA:getBet(self._stage,self._selectBetIndex)/SI_ROOM_DATA.baseBet;
            local multiple = SI_STAGE_DATA:getBet(self._stage, self._selectBetIndex)*self._selectLines;
            logYellow("=====================================下注值："..multiple);
            local isSepDisappear = false;
            self._curLianCount = self._curLianCount + vec:size();
            if vec:size()>=2 or self._curLianCount>=SI_GAME_CONFIG.SepDisappearLine then
                isSepDisappear = true;
            else
                isSepDisappear = false;
            end

            local func1 = function()
                --清除宝石完成
                GlobalGame._eventSystem:DispatchEvent(SI_EventID.ClearStoneLinesCallBack);
            end
            if val then
                it2     = val:iter();
                if isSepDisappear then
                    local func2
                    func2 = function()
                        --it2     = val:iter();
                        local function delayDisappear(data)
                            local val = data.val;
                            local _type = data._type;
                            local _balanceData  = GlobalGame._gameControl._balanceData;
                            local rotate=SI_STONE_PRICE[_type][val:size()];
                            logYellow("=====================================倍率："..rotate.."=======下注："..multiple.."======================================");
                            self._lineDetailsMgr:Add(_type,val:size(),rotate * multiple,self._selectLines);
                            self._balanceMultiple = self._balanceMultiple + SI_STONE_PRICE[_type][val:size()];
           
                            self._continueComb = self._continueComb + 1;
                            --显示连击数
                            self._displayComb:setComb(self._continueComb);
                        end
                        val2    = it2();
                        _type   = val2._value;
                        local isFirst =1;
                        local data = {val =val,_type =_type};
                        while(val2) do
                            stoneGrid = self:_getStoneGrid(val2._x,val2._y);
                            stoneGrid._isNeedPlayMusic = true;
                            if isFirst== 1 then
                                stoneGrid:SepDisappear(handler(data,delayDisappear));
                                isFirst = isFirst + 1;
                            else
                                stoneGrid:SepDisappear();
                            end
                            val2 = it2();
                        end
                    
                        val = it();
                        if val then
                            it2     = val:iter();
                            GlobalGame._timerMgr:FixUpdateOnce(func2,SI_GAME_CONFIG.SepClearStoneInterval);
                        else
                            GlobalGame._timerMgr:FixUpdateOnce(func1,SI_GAME_CONFIG.SepClearStoneInterval + SI_GAME_CONFIG.SepClearStoneEndInterval);
                        end
                    end
                    func2();
                else
                    local func2
                    func2 = function()
                        val2    = it2();
                        _type   = val2._value;
                        while(val2) do
                            stoneGrid = self:_getStoneGrid(val2._x,val2._y);
                            stoneGrid._isNeedPlayMusic = true;
                            stoneGrid:Disappear();
                            val2 = it2();
                        end
                        local _balanceData  = GlobalGame._gameControl._balanceData;
                        local rotate=SI_STONE_PRICE[_type][val:size()];
                        logYellow("=====================================倍率："..rotate.."=======下注："..multiple.."======================================");
                        self._lineDetailsMgr:Add(_type,val:size(),rotate*multiple,self._selectLines);
                        self._balanceMultiple = self._balanceMultiple + SI_STONE_PRICE[_type][val:size()];
                        log("self._balanceMultiple:"..self._balanceMultiple);
                        self._continueComb = self._continueComb + 1;
                        --显示连击数
                        self._displayComb:setComb(self._continueComb);
                        val = it();
                        if val then
                            it2     = val:iter();
                            GlobalGame._timerMgr:FixUpdateOnce(func2,SI_GAME_CONFIG.ClearStoneInterval);
                        else
                            GlobalGame._timerMgr:FixUpdateOnce(func1,SI_GAME_CONFIG.ClearStoneInterval);
                        end
                    end
                    func2();
                end
            else
                func1();
            end
        end
        func();
end

--跳出去
function FallStonePanel:JumpStone()
    MusicManager:PlayX(GlobalGame._gameObjManager:GetMusic(SI_MUSIC_TYPE.Stone_Clear));
    self:_foreachStoneNodeGrid(StoneNodeGrid.Jump,self._jumpStonePanel);
end

--移动石头
function FallStonePanel:MoveStone()

end

--下落宝石
function FallStonePanel:NotifyUIFallDownStone()
    self:FallStone();
end

--清除锥子
function FallStonePanel:NotifyUIClearDrill(eventId,vec)
    local funcOver = function()
        --清除锥子完成
        GlobalGame._eventSystem:DispatchEvent(SI_EventID.ClearDrillOverCallBack);
    end
    local it = vec:iter();
    local val = it();
    local stoneGrid;
    if (val) then
        local func1 = function()
            stoneGrid = self:_getStoneGrid(val._x,val._y);
            stoneGrid._isNeedPlayMusic = false;
            stoneGrid:Disappear();
            self._brickManager:ClearNextBrick();
            val = it();
            if val then
                GlobalGame._timerMgr:FixUpdateOnce(func1,SI_GAME_CONFIG.ClearDrillInterval); 
            else
                GlobalGame._timerMgr:FixUpdateOnce(funcOver,SI_GAME_CONFIG.ClearDrillInterval); 
            end
        end
        func1();
    else
        funcOver();
    end
end

--移动石头
function FallStonePanel:NotifyUIMoveStone(eventId,vec)
    local it = vec:iter();
    local val = it();
    local startGrid,endGrid
    local obj =nil;
    local func1Over =function()
        GlobalGame._eventSystem:DispatchEvent(SI_EventID.MoveStoneOverCallback);
    end 
    if (val) then
        local func1;
        func1 =function()
            startGrid = self:_getStoneGrid(val._sx,val._sy);
            endGrid   = self:_getStoneGrid(val._dx,val._dy);
            obj = startGrid:PopStoneObj();
            endGrid:SetStoneObj(obj);
            val = it();
            if val then
                GlobalGame._timerMgr:FixUpdateOnce(func1,SI_GAME_CONFIG.StoneMoveInterval); 
            else
                GlobalGame._timerMgr:FixUpdateOnce(func1Over,SI_GAME_CONFIG.StoneMoveInterval); 
            end   
        end
        func1();
    else
        func1Over();
    end
end

--重新初始化关卡
function FallStonePanel:ReInitStage()
    --实现所有的砖
    self._brickManager:Reset();

    --清空所有的宝石
    self:_foreachStoneNodeGrid(StoneNodeGrid.Clear);
    --变更关卡
    local stage = self._brickManager:GetStage();
    self:_setStage(stage);

    --置为空闲状态 该什么模式就什么模式
    self:_setGameState(SI_GAME_STATE.Free);

    self._lineDetailsMgr:Clear();
    --隐藏结算数字
    self._balanceNumber:Hide();

    --清理时间
    self._isClearCurGameData = true;
    self._clearWaitTime = 99999;
    self._isCanStartGame = true;
end

--通知结算
function FallStonePanel:NotifyUIBalance(eventId,_data)
    --开始龙珠关卡
    local startDragonMission = function()
        if self._startMode == SI_GAME_MODE.Auto then
            --这里需要通知
            self.gamePanel:EnterDragonMission(true);
        else
			log("======================================进入小游戏===========================================")
            self.gamePanel:EnterDragonMission(false);
        end
    end

    local function startNext()
        --隐藏连击
        self._displayComb:hide();
        --是否下一关
        if _data._isNextStage then
            if self._brickManager:IsClearAll() then
                --隐藏结算数字
                self._balanceNumber:Stop();
                --开始龙珠关卡
                startDragonMission();
            else
                local stage = self._brickManager:NextStage();
                self.gamePanel:SetStage(stage);
                --游戏状态改为空闲状态
                self:_setStage(stage);
				log("=====================================游戏结束==========================================")
            end
        else
            --游戏状态改为空闲状态
            self:_setGameState(SI_GAME_STATE.Free);
			log("=====================================游戏结束==========================================")
        end
    end

    local function addGold(isOver,num)
        GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyAddGold,num);
        if isOver then
            local tempFunc = function()
                startNext();
            end
            GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyChangeGold,_data._curGold);
            GlobalGame._timerMgr:FixUpdateOnce(tempFunc,0.3);
        end
    end
    --没有清理当前游戏数据
    self._isClearCurGameData = false;
    self._clearWaitTime  = 2;
    --通知金币改变
    if _data._addGold~=0 then

        if self._balanceType==1 then
            if self._isJileiJiang then
                self._balanceNumber:SetNumber(SI_BALANCE_TYPE.LeiJi,_data._addGold,true,2,1.5,addGold);
            else
                if self._balanceMultiple>=500 then
                    self._balanceNumber:SetNumber(SI_BALANCE_TYPE.Large,_data._addGold,true,2,1,addGold);
                elseif self._balanceMultiple>=200 then
                    self._balanceNumber:SetNumber(SI_BALANCE_TYPE.Big,_data._addGold,true,2,1,addGold);
                else
                    self._balanceNumber:SetNumber(SI_BALANCE_TYPE.Common,_data._addGold,true,2,1,addGold);
                end
            end
            --点开始就跳过数字减少过程
            if self._startMode == SI_GAME_MODE.Hand then
                if _data._isNextStage then
                else
                    --不用展示减金币过程
                    --游戏状态改为空闲状态
                    self:_setGameState(SI_GAME_STATE.Free);
                end
            end
        elseif self._balanceType==2 then
            if self._isJileiJiang then
                self._balanceNumber:SetNumber(SI_BALANCE_TYPE.LeiJi,_data._addGold);
            else
                if self._balanceMultiple>=500 then
                    self._balanceNumber:SetNumber(SI_BALANCE_TYPE.Large,_data._addGold);
                elseif self._balanceMultiple>=200 then
                    self._balanceNumber:SetNumber(SI_BALANCE_TYPE.Big,_data._addGold);
                else
                    self._balanceNumber:SetNumber(SI_BALANCE_TYPE.Common,_data._addGold);
                end
            end
            --是否下一关
            if _data._isNextStage then
                if self._brickManager:IsClearAll() then
                    self._balanceNumber:ReduceNumber(2,1,addGold);
                    --不需要清理
                    self._isClearCurGameData = true;
                else
                    GlobalGame._timerMgr:FixUpdateOnce(startNext,1.5);
                end
            else
                GlobalGame._timerMgr:FixUpdateOnce(startNext,1.5);
            end
        end
    else
        startNext();
    end
end

--通知开始游戏
function FallStonePanel:NotifyStartGame()
    self._balanceMultiple = 0;
    self._isJileiJiang    = false;
    self._continueComb    = 0; --连击
    self._isCanStartGame  = false;
    self:_setGameState(SI_GAME_STATE.Gaming);
    self._balanceNumber:Stop();
    self._curLianCount    = 0;
end

--通知开始龙珠关卡
function FallStonePanel:NotifyStartDragonMission(_eventId,_eventData)
    logYellow("通知开始龙珠关卡")
    --龙珠关卡结束事件
    local function OnDragonMissionGameOver(_earnGold,_stage)
        self._dragonBallPanel = nil;
        self:ReInitStage();
        self:PlayBgMusic();
    end
    --进入龙珠关卡
    --self._dragonBallPanel = DragonBallPanel.New(GlobalGame._contentLayer,_eventData,OnDragonMissionGameOver);
end

--通知龙珠关卡结束
function FallStonePanel:NotifyDragonMissionOver(isEnterMission)
    isEnterMission = isEnterMission or false;
    if isEnterMission then
        self:ReInitStage();
        self:PlayBgMusic();
    else
        self:ReInitStage();
    end
end

--通知彩金
function FallStonePanel:NotifyCaijin(_eventId,_caijin)

end

--通知玩家进入
function FallStonePanel:NotifyUserEnter(_eventId,_playerData)

end

--遍历
function FallStonePanel:_foreachStoneNodeGrid(handler,...)
    local grid
    for j=1,SI_MAX_Y_COUNT do
        for i=1,SI_MAX_X_COUNT do
            grid =self._stoneNodeGrid[j][i];
            handler(grid,...);
        end
    end
    for i=1,SI_MAX_X_COUNT do
        grid =self._stoneNodeGrid[READY_STONE_GRID_Y_INDEX][i];
        handler(grid,...);
    end
end

--所有的下落宝石点是否是空的
function FallStonePanel:IsAllEmpty()
    local grid
    local isAll=true;
    for j=1,SI_MAX_Y_COUNT do
        for i=1,SI_MAX_X_COUNT do
            grid =self._stoneNodeGrid[j][i];
            if not grid:IsEmpty() then
                isAll = false;
                break;
            end
        end
    end
    for i=1,SI_MAX_X_COUNT do
        grid =self._stoneNodeGrid[READY_STONE_GRID_Y_INDEX][i];
        if not grid:IsEmpty() then
            isAll = false;
            break;
        end
    end
    return isAll;
end


--重新初始化关卡
function FallStonePanel:_resetStage(_stage)
    self.betAtlasLabel:SetNumber(SI_STAGE_DATA:getBet(_stage,self._selectBetIndex));
    self._stage = _stage;
    if _stage == 1 then
        self._xBegin = 2;
        self._yBegin = 1;
    elseif _stage == 2 then
        self._xBegin = 2;
        self._yBegin = 1;
    elseif _stage == 3 then
        self._xBegin = 1;
        self._yBegin = 1;
    end
end

--设置等级
function FallStonePanel:_setStage(_stage)
    self:_setGameState(SI_GAME_STATE.Free);
    self:_resetStage(_stage);
end


--改变为空闲状态
function FallStonePanel:FreeState()
    self:_setGameState(SI_GAME_STATE.Free);
end

--通知场景消息
function FallStonePanel:NotifySceneInfo(_stage,_brickIndex)
    self._stage         = _stage;
    self:_setGameState(SI_GAME_STATE.Free);
    self._brickManager:Set(_stage,_brickIndex);
    self:_setStage(self._stage);

    --重新设置下线数和押注
    self:_setLines(SI_MULTIPLE_MAX);
    local count = SI_STAGE_DATA:getBetCount(self._stage);
    local betlist = {};
    for i = 1, count do
        table.insert(betlist,SI_STAGE_DATA:getBet(self._stage,i - 1));
    end
    self._selectBetIndex = CheckNear(GlobalGame._gameControl._playerData:GetGold(),betlist) - 1;
    self:_setSelectBetIndex(self._selectBetIndex);
    self:_arrangeTotalBet();

    --播放背景音乐
    self:PlayBgMusic();
end

--播放背景音乐
function FallStonePanel:PlayBgMusic()
    --[[
    if self._stage==1 then
        MusicManager:PlayBacksoundX(GlobalGame._gameObjManager:GetMusic(SI_MUSIC_TYPE.StoneFallDown_BG_1), true);
    elseif self._stage==2 then
        MusicManager:PlayBacksoundX(GlobalGame._gameObjManager:GetMusic(SI_MUSIC_TYPE.StoneFallDown_BG_2), true);
    elseif self._stage==3 then
        MusicManager:PlayBacksoundX(GlobalGame._gameObjManager:GetMusic(SI_MUSIC_TYPE.StoneFallDown_BG_3), true);
    end
    --]]
    MusicManager:PlayBacksoundX(GlobalGame._gameObjManager:GetMusic(SI_MUSIC_TYPE.StoneFallDown_BG), true);
end

--根据对应的字符得到对应的sprite
function FallStonePanel:GetAtlasSprite(chr)
    local str = "number_" .. chr;
    --error("sprite:" .. str);
    --return GlobalGame._gameObjManager:GetCommonSprite(str);
    return self._numSprite[str];
end

--隐藏按钮
function FallStonePanel:_btnDisabled()
    self._linesCtrl:disabled();
    self.betAddDisabledObj:SetActive(true);
    self.betReduceDisabledObj:SetActive(true);
end

--显示按钮
function FallStonePanel:_btnNormal()
    self._linesCtrl:normal();
    self.betAddDisabledObj:SetActive(false);
    self.betReduceDisabledObj:SetActive(false);
end

--设置游戏状态
function FallStonePanel:_setGameState(_gameState)
    self._gameState = _gameState;
    if self._startMode == SI_GAME_MODE.Auto then
        self._buttonsCtrl:disabled();
    elseif self._gameState == SI_GAME_STATE.Free or  self._gameState == SI_GAME_STATE.Null then
        self._buttonsCtrl:endisabled();
    else
        self._buttonsCtrl:disabled();
    end
    if self._startMode == SI_GAME_MODE.Auto then
        self:_btnDisabled();
    elseif self._gameState == SI_GAME_STATE.Free or  self._gameState == SI_GAME_STATE.Null then
        self:_btnNormal();
    else
        self:_btnDisabled();
    end 
end

--销毁
function FallStonePanel:Destroy()
    self._brickManager:Destroy();
    self._brickManager=nil;
    self._betBtnTips = nil;
    self._linesBtnTips = nil;
    self._betTextLabel = nil;
    self.transform = nil;
--    destroy(self.go);
--    self.go = nil;
    self._numSprite= {};
end
return FallStonePanel;