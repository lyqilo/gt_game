local Timer=class("Timer");

local TimeItem=class("TimeItem")

function TimeItem:ctor(_id,_handler)
    self._id    = _id;
    self._isRemove = false;
    self._handler = _handler;
end

function TimeItem:Execute(_dt)

end

function TimeItem:Remove()
    self._isRemove = true;
end

function TimeItem:IsRemove()
    return self._isRemove;
end

function TimeItem:Done(...)
    self._handler(...);
end

local FixUpdate = class("FixUpdate",TimeItem);

function FixUpdate:ctor(_id,_handler,_period,_delay,_count)
    self.super.ctor(self,_id,_handler);
    self._period    = _period or 0;
    self._delay     = _delay or 0;
    self._allCount  = _count or -1;
    self._runTime   = 0;
    self._curRunTime= _period or 0;
    self._count     = 0;
end

function FixUpdate:Execute(_dt)
    if self._delay>_dt then
        self._delay = self._delay - _dt;
        return false;
    end
    local dt = _dt - self._delay;
    self._runTime = self._runTime + dt;
    self._curRunTime = self._curRunTime + dt;
    if self._curRunTime>self._period then
        self._curRunTime = self._curRunTime - self._period;
        self._count = self._count + 1;
        if self._allCount == -1 then
            self:Done(self._runTime,self._count,false);
        else
            if self._allCount<=self._count then
                self:Done(self._runTime,self._count,true);
                return true;
            else
                self:Done(self._runTime,self._count,false);
            end
        end 
    end
    return false;
end


local CountDownTimeItem = class("CountDownTimeItem",TimeItem);

function CountDownTimeItem:ctor(_id,_handler,_time,_delay,_period,_tipTime)
    self.super.ctor(self,_id);
    self._time      = _time or 1;
    self._period    = _period or 1;
    self._tipTime   = _tipTime or _time;
    self._handler   = _handler;
    self._count     = 0;
    self._delay     = _delay or 0;
    self._runTime   = 0;
    self._curRunTime= _period or 1;
end

function CountDownTimeItem:Execute(_dt)
    if self._delay>_dt then
        self._delay = self._delay - _dt;
        return false;
    end
    local dt = _dt - self._delay;
    self._delay = 0;
    self._runTime = self._runTime + dt;
    self._curRunTime = self._curRunTime + dt;
    local leftTime = self._time - self._runTime;
    if leftTime<=0 then
        self._count = self._count + 1;
        self:Done(self._runTime,self._count,true,leftTime);
        return true;
    else
        if self._curRunTime>self._period then
            self._curRunTime = self._curRunTime - self._period;
            if leftTime<=self._tipTime then
                self._count = self._count + 1;
                self:Done(self._runTime,self._count,false,leftTime);
            end
        end
    end
    return false;
end


function Timer:ctor()
    self._idCreator = ID_Creator(1);
    self._timeMap   = map:new();
    self._delList   = vector:new();
    self._runTime   = 0;
end

function Timer:_pushItem(timeItem)
    self._timeMap:insert(timeItem._id,timeItem);
    if timeItem:Execute(0) then
         --可以删除了
        timeItem:Remove();
    end
end

--周期循环执行
function Timer:FixUpdateByPeriod(_handler,_delay,_period)
    local _id = self._idCreator();
    local timeItem = FixUpdate.New(_id,_handler,_period,_delay);
    self:_pushItem(timeItem);
    return _id;
end

--执行一遍
function Timer:FixUpdateOnce(_handler,_delay)
    local _id = self._idCreator();
    local timeItem = FixUpdate.New(_id,_handler,_period,_delay,1);
    self:_pushItem(timeItem);
    return _id;
end

--执行times遍
function Timer:FixUpdateTimes(_handler,_delay,_period,_times)
    local _id = self._idCreator();
    local timeItem = FixUpdate.New(_id,_handler,_period,_delay,_times);
    self:_pushItem(timeItem);
    return _id;
end

--倒计时
function Timer:CountDown(_handler,_time,_period,_tipTime)
    local _id = self._idCreator();
    local timeItem = CountDownTimeItem.New(_id,_handler,_time,0,_period,_tipTime);
    self:_pushItem(timeItem);
    return _id;
end

--倒计时
function Timer:CountDownDelay(_handler,_time,_delay,_period,_tipTime)
    local _id = self._idCreator();
    local timeItem = CountDownTimeItem.New(_id,_handler,_time,_delay,_period,_tipTime);
    self:_pushItem(timeItem);
    return _id;
end

--执行
function Timer:Execute(_dt)
    local it = self._timeMap:iter();
    local val = it();
    local value
    self._runTime = self._runTime + _dt;
    self._delList:clear();
    while(val) do
        value = self._timeMap:value(val);
        if value then
            if value:IsRemove() then
                self._delList:push_back(val);
            else
                if value:Execute(_dt) then
                    self._delList:push_back(val);
                end
            end
            
        end
        val=it();
    end

    --删除队列
    it = self._delList:iter();
    val = it();
    while(val) do
        self._timeMap:erase(val);
        val = it();
    end
end

--移除定时器
function Timer:Remove(_id)
    local val = self._timeMap:value(_id);
    if val then
        val:Remove();
    end
end


return Timer;
