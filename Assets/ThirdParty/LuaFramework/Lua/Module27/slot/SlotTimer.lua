--SlotTimer.lua
--Date
--Slot 记时器类

--endregion

SlotTimer = {};

local self = SlotTimer;

self.slotTimerType = 
{
    timint = 1; --计时
    tick = 2; --秒表
}



function SlotTimer:New(o)
    local t = o or { };
    setmetatable(t, self);
    self.__index = self
    return t;
end

--初始化变量
function SlotTimer:initVariate()
    self.bStartTimer = false;
    self.isTimeType = self.slotTimerType.timint;
    self.isTime = 0;
    self.currentTime = 0; 
    self.isTickTime = 0;
    self.tickCurrentTime = 0;

    self.tabEndCallBack =
    {
        fun = SlotTimer.CallBack;
        args = SlotTimer;
    }

    self.tabTickCallBack =
    {
        fun = SlotTimer.CallBack;
        args = SlotTimer;
    }

end

--设置定时器
--timerTime 总定时时间, bStart 是否开启定时器, timerType定时器类型，tickTime 间隔定时时间
function SlotTimer:setTimer(timerTime, bStart, timerType, tickTime, tabTick, tabEnd)

    self:initVariate();

    timerType = timerType or self.slotTimerType.timint;

    self.isTime = timerTime;
    self.bStartTimer = bStart;
    self.isTimeType = timerType;
    self.isTickTime = tickTime;

    if(tabTick) then
        self.tabTickCallBack.fun = tabTick.fun;
        self.tabTickCallBack.args = tabTick.args
    end

   if(tabEnd) then
        self.tabEndCallBack.fun = tabEnd.fun;
        self.tabEndCallBack.args = tabEnd.args;
    end



end


function SlotTimer:timer(changeTime)
    
    if(not self.bStartTimer) then
        
        return;
    end

    self.currentTime = self.currentTime + changeTime;

    if(self.isTimeType == self.slotTimerType.tick) then
        
        self.tickCurrentTime = self.tickCurrentTime + changeTime;

        if(self.tickCurrentTime >= self.isTickTime) then
            self:TickEnd();
            self.tickCurrentTime = self.tickCurrentTime - self.isTickTime;
        end

    end

    if(self.currentTime >= self.isTime) then
        
        
        self:TimerEnd();
    end

 
end


--计时结束
function SlotTimer:TimerEnd()

    self.bStartTimer = false;
    self.tabEndCallBack.fun(self.tabEndCallBack.args);
    --self:initVariate();
end

--单位计时结束
function SlotTimer:TickEnd()
    
    self.tabTickCallBack.fun(self.tabTickCallBack.args);
end



function SlotTimer.CallBack(args)
    --log("timer 无回调");
end

 