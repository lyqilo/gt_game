--FruitGameTimer.lua
--Date
--水果机 定时器
--endregion

FruitGameTimer = {}

local self = FruitGameTimer;

self.FruitTimerType = 
{
    timint = 1; --计时
    tick = 2; --秒表
}


function FruitGameTimer:New(o)
    local t = o or { };
    setmetatable(t, self);
    self.__index = self
    return t;
end

--初始化变量
function FruitGameTimer:initVariate()
    self.bStartTimer = false;
    self.isTimeType = self.FruitTimerType.timint;
    self.isTime = 0;
    self.currentTime = 0; 
    self.isTickTime = 0;
    self.tickCurrentTime = 0;

    self.tabEndCallBack =
    {
        fun = FruitGameTimer.CallBack;
        args = FruitGameTimer;
    }

    self.tabTickCallBack =
    {
        fun = FruitGameTimer.CallBack;
        args = FruitGameTimer;
    }

end

--设置定时器
--timerTime 总定时时间, bStart 是否开启定时器, timerType定时器类型，tickTime 间隔定时时间
function FruitGameTimer:SetTimer(timerTime, bStart, timerType, tickTime, tabTick, tabEnd)

    if(bStart) then
        self:initVariate();
    end

    timerType = timerType or self.FruitTimerType.timint;

    self.isTime = timerTime;
    self.bStartTimer = bStart;
    self.isTimeType = timerType;
    self.isTickTime = tickTime;

    if(tabTick) then
        self.tabTickCallBack.fun = tabTick.fun;
        self.tabTickCallBack.args = tabTick.args;
    end

   if(tabEnd) then
        self.tabEndCallBack.fun = tabEnd.fun;
        self.tabEndCallBack.args = tabEnd.args;
   end

   if(not self.bStartTimer) then

        self:TimerEnd();
   end

end

--改变间隔时间
function FruitGameTimer:ChangeTickTime(iTime)
    self.bChangeTime = true;
    self.isTickTime = iTime;
end


function FruitGameTimer:timer(changeTime)
    
    if(not self.bStartTimer) then

        return;
    end

    self.currentTime = self.currentTime + changeTime;

    if(self.isTimeType == self.FruitTimerType.tick) then
        
        self.tickCurrentTime = self.tickCurrentTime + changeTime;
--        logYellow("ct = " .. self.tickCurrentTime);
--        logYellow("t =- " .. self.isTickTime);
        if(self.tickCurrentTime >= self.isTickTime) then
            self:TickEnd();
            if(self.bChangeTime) then
                --logYellow("change tiem");
                self.tickCurrentTime = 0;
                self.bChangeTime = false;
            else
                self.tickCurrentTime = self.tickCurrentTime - self.isTickTime;
                --logYellow("time = " .. self.isTickTime ..   "  t =- " .. self.tickCurrentTime);
            end
            --self.tickCurrentTime = self.tickCurrentTime - self.isTickTime;
        end

    end

    if(self.currentTime >= self.isTime) then
        
        self:TimerEnd();
    end

 
end


--计时结束
function FruitGameTimer:TimerEnd()

    self.bStartTimer = false;
    self.tabEndCallBack.fun(self.tabEndCallBack.args);
    --self:initVariate();
end

--单位计时结束
function FruitGameTimer:TickEnd()
    
    self.tabTickCallBack.fun(self.tabTickCallBack.args);
end



function FruitGameTimer.CallBack(args)
    logYellow("timer 无回调");
end

 