--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--UI交互实现      2020.2.19
local UIControlevent = {}

local self = UIControlevent

self.LongPressTime = 1.2
self.LongPressSeriesTime = 0.4
self.CurLongPressTime = 0
self.UIState = {Idle = 1, Down = 2, Series = 3} --Idle:可交互状态  Down:按下状态  Series:长按状态
self.CurUIState = self.UIState.Idle
self.LongPressEvent = nil                   --长按事件
self.LongPressSeriesEvent = nil             --连续长按事件
self.clickEvent = nil                       --点击事件

self.OnBeginDown = nil                          --按钮按下时事件 
self.onDownUp = nil                             --按钮抬起时事件

function UIControlevent:Init(go)
    if(go == nil)then
        logError("Add EventTriggerListener fail, obj is nil")
        return
    end

    local eventTrigger = Util.AddComponent("EventTriggerListener", go)
    eventTrigger.onDown = self.PointDown
    eventTrigger.onUp = self.PointUp
end

function UIControlevent:AddLongPressEvent(Func1, Func2, Func3)
    self.LongPressEvent = Func1
    self.LongPressSeriesEvent = Func2
    self.clickEvent = Func3
end

function UIControlevent:AddPressEvent(Func1, Func2)
    self.OnBeginDown = Func1                        
    self.onDownUp = Func2   
end

function UIControlevent:PointDown()
    if(self.CurUIState == self.UIState.Idle)then
        self.CurLongPressTime = 0
        self.CurUIState = self.UIState.Down
        if(self.OnBeginDown ~= nil)then
            self:OnBeginDown()
        end
    end
end

function UIControlevent:PointUp()
    if(self.CurUIState ~= self.UIState.Series)then
        if(self.clickEvent ~= nil)then
            self:clickEvent()
        end
    end
     if(self.onDownUp ~= nil)then
            self:onDownUp()
        end
    self.CurLongPressTime = 0
    self.CurUIState = self.UIState.Idle
end

function UIControlevent:UIUpdate()
    if(self.CurUIState ~= self.UIState.Idle)then
        if(self.CurUIState == self.UIState.Down)then
            self.CurLongPressTime = self.CurLongPressTime + UnityEngine.Time.deltaTime
            if(self.CurLongPressTime >= self.LongPressTime)then
                self.CurLongPressTime = 0;
                self.CurUIState = self.UIState.Series;
                if(self.LongPressEvent ~= nil)then
                    self:LongPressEvent()
                end
            end
        elseif(self.CurUIState == self.UIState.Series)then
            self.CurLongPressTime = self.CurLongPressTime + UnityEngine.Time.deltaTime
            if(self.CurLongPressTime >= self.LongPressSeriesTime)then
                self.CurLongPressTime = 0;
                 if(self.LongPressSeriesEvent ~= nil)then
                    self:LongPressSeriesEvent()
                end
            end
        end
    end
end

return UIControlevent
--endregion
