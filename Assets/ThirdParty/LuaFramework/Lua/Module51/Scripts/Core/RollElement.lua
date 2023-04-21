RollElement = {};
self = RollElement;

---本列个数
self.m_count = 0;
self.m_objs = {};
self.m_pos = 0;
self.m_top = 0;
---运行中的速度
self.m_speed = 0;
self.m_stoping = false;
self.m_fantan = false;
self.m_stoped = true;
self.m_stop_index = 0;
self.m_begin_time = 0;
self.m_ticks = 0;
self.time_Speed = 0.0015;

---开启反弹
self.openFanTan = true;

---增量速度
self.DeltaSpeed = 0.008;

---最大速度
self.MAX_SPEED = 0.5;

---停止时候最大速度
self.STOP_SPEED = 0.1;

self.delayEventTime = 0;
self.OnDelayEvent = nil;

self.OnStoped = nil;

function RollElement:new(args)
    local o = args or {};
    setmetatable(o, { __index = self });
    return o;
end

function RollElement:Init(objs)
    self:SetGeneralSpeed();
    self.m_objs = objs;
    for i = 1, #self.m_objs do
        local o = objs[i];
        o:ChangeIcon(-1);
        o:SetPos(i - 1);
    end
end
---正常速度设置
function RollElement:SetGeneralSpeed()
    self.MAX_SPEED = 0.18;
end

--加速速度设置
function RollElement:SetQuickSpeed()
    self.MAX_SPEED = 1;
end

function RollElement:StartDelay(delayTime)
    self.delayEventTime = delayTime;

    self.OnDelayEvent = self.Start;

    if (self.delayEventTime <= 0) then
        self:OnDelayEvent();
    end
end

function RollElement:StopDelay(delayTime)
    if (not self.m_stoping) then
        self.delayEventTime = delayTime;
        self.OnDelayEvent = self.Stop;
        if (self.delayEventTime == 0) then
            self:OnDelayEvent();
        end
    end
end
function RollElement:Start()
    self.delayEventTime = 0;
    self.OnDelayEvent = nil;
    self.m_pos = 0;
    self.m_speed = 0;
    self.m_stoping = false;
    self.m_stoped = false;
    self.m_fantan = false;
    self.m_stop_index = 0;
    self.m_begin_time = Util.TickCount;
    self.m_ticks = 0;
end

function RollElement:Stop()
    self.delayEventTime = 0;
    self.OnDelayEvent = nil;
    self.m_stoping = true;

end
function RollElement:IsStoped()
    return self.m_stoped;
end
function RollElement:Update()
    if (self.delayEventTime > 0) then
        self.delayEventTime = self.delayEventTime - Time.deltaTime;
        if (self.delayEventTime <= 0 and self.OnDelayEvent ~= nil) then
            self:OnDelayEvent();
        end
    end
    if (self.m_stoped == true) then
        return ;
    end
    local now = Util.TickCount;

    local ticks = (now - self.m_begin_time) / 10;
    while self.m_ticks < ticks do
        self.m_ticks = self.m_ticks + self.time_Speed;
        if (self.m_stoped == false) then
            self:fixed_update();
        end
    end
end
function RollElement:fixed_update()
    if (self.m_stoping == true) then
        --停止中
        if (self.m_fantan == true) then
            if (self.openFanTan == true) then
                --反弹
                self.m_speed = self.m_speed - self.DeltaSpeed*5;
                if not self.m_stoped and self.m_speed < -0.025 then
                    self.m_speed = -0.025;
                end
                self.m_pos = self.m_pos + self.m_speed;
                if (self.m_pos < 0) then
                    self.m_stoped = true;
                    self.m_pos = 0;
                end
            else
                self.m_stoped = true;
                self.m_pos = 0;
            end
        else
            if (self.m_speed > self.STOP_SPEED) then
                self.m_speed = self.m_speed - self.DeltaSpeed * 4;
            end
            if (self.m_speed < self.STOP_SPEED) then
                self.m_speed = self.STOP_SPEED;
            end
            self.m_pos = self.m_pos + self.m_speed;
            if (self.m_pos >= 1) then
                self.m_pos = self.m_pos - 0.5;
                self.m_top = (self.m_top + self.m_count - 1) % self.m_count;
                self.m_stop_index = self.m_stop_index + 1;
                if (self.m_stop_index == self.m_count) then
                    self.m_fantan = true;
                    for i = 0, 3 do
                        if (LogicDataSpace.resultElement[i * 5 + self.m_objs[self.m_top + 1].m_col] == 10) then
                            break ;
                        end
                        if (i == 2) then
                        end
                    end
                    self.m_stop_index = 0;
                    if (self.OnStoped ~= nil) then
                        self:OnStoped();
                    end
                    -- MainGameSence.PlaySound(MainGameSence.AudioEnum.WheelStop);
                    -- coroutine.start(function()
                    --     coroutine.wait(0.5);
                    --     if not LogicDataSpace.isSmallGameStart then
                    --         MainGameSence.PlaySound(MainGameSence.AudioEnum.WheelStop);
                    --     end
                    -- end)
                end
                self.m_objs[self.m_top + 1]:ChangeIcon(self.m_stop_index - 1);
            end
        end
    else
        if LogicDataSpace.isSmallGameStart then
            if (self.m_speed < self.MAX_SPEED) then
                self.m_speed = self.m_speed + self.DeltaSpeed;
            end
        else
            if (self.m_speed < self.MAX_SPEED * 2.5) then
                self.m_speed = self.m_speed + self.DeltaSpeed * 2.5;
            end
        end
        self.m_pos = self.m_pos + self.m_speed;
        if (self.m_pos >= 1) then
            self.m_pos = self.m_pos - 1;
            self.m_top = (self.m_top + self.m_count - 1) % self.m_count;
            self.m_objs[self.m_top + 1]:ChangeIcon(-1);
        end
    end
    for i = 0, self.m_count - 1 do
        local index = (i + self.m_top) % self.m_count;
        local o = self.m_objs[index + 1];
        o:SetPos(self.m_pos + i - 1);
    end
end