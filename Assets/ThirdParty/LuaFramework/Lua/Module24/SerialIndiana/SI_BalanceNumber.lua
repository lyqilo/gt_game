local _CBalanceItem = class("_CBalanceItem");

function _CBalanceItem:ctor(_type,_go,_numberLabel,_particleSystem)
    self._type = _type;
    self.gameObject   = _go;
    self._numberLabel = _numberLabel;
    self._particleSystem = _particleSystem;
    self._handler = nil;
    self._num     = 0;
    self._reduceSpeed = 0;
    self._minSpeed   = 0;
    self._waittime = 0;
end

function _CBalanceItem:Hide()
    self.gameObject:SetActive(false);
end

function _CBalanceItem:SetNumber(num,isReduce,waittime,time,handler)
    self.gameObject:SetActive(true);
    self._numberLabel:SetNumber(num);
    self._num = num;
    if self._particleSystem then
        self._particleSystem:Play();
    end
    isReduce = isReduce or false;
    if isReduce then
        time = time or 2;
        self._reduceSpeed = num / time;
        self._minSpeed   = self._reduceSpeed/10;
        self._maxSpeed    = self._reduceSpeed*2;
        self._addSpeed    = self._reduceSpeed/time/2;
        self._addSpeed2    = self._addSpeed/time/3;
        self._waittime = waittime or 0;
        self._handler = handler;
    else
        self._waittime = 0;
    end
end

function _CBalanceItem:ReduceNumber(waittime,time,handler)
    time = time or 2;
    self._reduceSpeed = self._num / time;
    self._minSpeed    = self._reduceSpeed/10;
    self._maxSpeed    = self._reduceSpeed*2;
    self._addSpeed    = self._reduceSpeed/time/2;
    self._addSpeed2   = self._addSpeed/time/3;
    self._waittime = waittime or 0;
    self._handler = handler;
end

function _CBalanceItem:GetNumber()
    return self._num;
end

function _CBalanceItem:Update(_dt)
    if self._waittime >0 then
        if self._waittime<_dt then
            _dt = _dt - self._waittime;
            self._waittime = 0;
        else
            self._waittime = self._waittime - _dt;
            return ;
        end
    end
    local reduceNum = math.floor(self._reduceSpeed*_dt);
    self._reduceSpeed = self._reduceSpeed + self._addSpeed *_dt;
    self._addSpeed = self._addSpeed - self._addSpeed2 * _dt;
    if self._reduceSpeed<self._minSpeed then
        self._reduceSpeed = self._minSpeed
    end 
    if reduceNum<1 then
        reduceNum = 1;
    end
    if self._num<=reduceNum then
        reduceNum = self._num;
    end
    self._num = self._num - reduceNum;
    if self._num<=0 then
        self._num = 0;
    end
    self._numberLabel:SetNumber(self._num);
    if self._handler then
        self._handler(self._num<=0,reduceNum);
    end
end

function _CBalanceItem:IsUpdateOver()
    return self._num<=0 and self._waittime<=0;
end

function _CBalanceItem:Stop()
    self._numberLabel:SetNumber(0);
    if self._handler then
        self._handler(true,self._num);
    end
    self._num = 0;
end

local _CBalanceNumber = class("_CBalanceNumber");

function _CBalanceNumber:ctor()
    self._balanceMap = map:new();
    self._curItem    = nil;
    self._curType    = nil;
end

function _CBalanceNumber:Push(_type,_go,_numberLabel,_particleSystem)
    local item =_CBalanceItem.New(_type,_go,_numberLabel,_particleSystem);
    self._balanceMap:insert(_type,item);
    return item;
end

function _CBalanceNumber:SetNumber(_type,number,isReduce,waittime,time,handler)
    local it =self._balanceMap:iter();
    local val = it();
    local item;
    while(val) do
        item = self._balanceMap:value(val);
        if val == _type then
            self._curType = _type;
            item:SetNumber(number,isReduce,waittime,time,handler);
            if isReduce then
                self._curItem = item;
            end
        else
            item:Hide();
        end
        val = it();
    end
end

function _CBalanceNumber:ReduceNumber(waittime,time,handler)
    local item = self._balanceMap:value(self._curType);
    if item then
        item:ReduceNumber(waittime,time,handler);
        self._curItem = item;
    end
end

function _CBalanceNumber:GetNumber()
    local item = self._balanceMap:value(self._curType);
    if item then
        return item:GetNumber();
    end
    return 0;
end

function _CBalanceNumber:Hide()
    local it =self._balanceMap:iter();
    local val = it();
    local item;
    while(val) do
        item = self._balanceMap:value(val);
        item:Hide();
        val = it();
    end
end


function _CBalanceNumber:Update(_dt)
    if self._curItem then
        self._curItem:Update(_dt);
        if self._curItem:IsUpdateOver() then
            self._curItem = nil;
        end
    end
end

--���̽���
function _CBalanceNumber:Stop()
    if self._curItem then
        self._curItem:Stop();
        self._curItem = nil;
    end
    self:Hide();
end

return _CBalanceNumber;