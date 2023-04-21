--[[
�������ƶ��������ʱ������Ӧ�������
--]]

local ThrowMove=class("ThrowMove");

function ThrowMove:ctor(_throwPath,_sp,_ep,_totalTime)
    self._throwPath = _throwPath;
    self._sp = _sp;
    self._ep = _ep;
    self._totalTime = _totalTime;
    local topx,topy = self._throwPath:GetTop();
    self._topy = topy;
    self._l1 = topy - _sp.y;
    self._l2 = topy - _ep.y;
    local b = -2*_totalTime*self._l1;
    local c = self._l1*math.pow(_totalTime,2);
    local a = (self._l1-self._l2);
    self._t1 = (-b+math.sqrt(math.pow(b,2)-4*a*c))/(2*a);
    self._t2 = (-b-math.sqrt(math.pow(b,2)-4*a*c))/(2*a);
    self._realT1=self._t1>0 and self._t1 or self._t2;
    self._aSpeed = self._l1*2/math.pow(self._realT1,2);
    self._moveTime=-self._realT1;
    if topx>_sp.x then
        self._toward = 1;
    else
        self._toward = -1;
    end
    self._runTime = 0;
end


function ThrowMove:Step(dt)
    self._runTime = self._runTime + dt;
    self._moveTime = self._moveTime + dt;
    local disY = self._aSpeed * math.pow(self._moveTime ,2)/2;
    local curY = self._topy  - disY;
    if self._runTime>= self._totalTime then
        return self._ep.x,self._ep.y,true;
    end
    if self._toward==1 then
        if self._moveTime<0 then
            local _,x =self._throwPath:GetX(curY);
            return x,curY,false;
        else
            local x =self._throwPath:GetX(curY);
            return x,curY,false;
        end

    else
        if self._moveTime<0 then
            local x =self._throwPath:GetX(curY);
            return x,curY,false;
        else
            local _,x= self._throwPath:GetX(curY);
            return x,curY,false;
        end
    end
    
end


return ThrowMove;