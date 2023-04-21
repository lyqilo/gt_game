--local ThrowPath=class("ThrowPath");
local ThrowPath=class();

--计算公式，抛物线
--[[
function ThrowMove:ctor(topPoint,otherPoint)
    self._topx=topPoint.x;
    self._topy=topPoint.y;
    local xDis = otherPoint.x-topPoint.x;
    self._a = (otherPoint.y - topPoint.y)/(xDis* xDis);
end
--]]

function ThrowPath.CreateWithTopX(sx1,sy1,sx2,sy2,topx)
    local move= ThrowPath.New();
    local sx1_2 = sx1*sx1;
    local sx2_2 = sx2*sx2;
    local temp = (sx1_2-sx2_2-2*sx1*topx + 2*topx*sx2);
    move._a = (sy1-sy2) / temp;
    move._b = move._a*topx*-2;
    move._c = sy1 - move._a*sx1_2 - move._b*sx1;
    --error("a: " .. move._a .. ",b:" .. move._b .. ",c:" .. move._c);
    move._topx = topx;
    move._topy = move._a*math.pow(topx,2) + move._b*topx + move._c;
    --error("topx: " .. topx .. ",topy:" .. move._topy);
    return move;
end

--暂时算不出来，不考虑这种情况
function ThrowPath.CreateWithTopY(sx1,sy1,sx2,sy2,topy)
    local move= ThrowPath.New();
    local t = sy1 - sy2;
    local s = sy1 - topy;
    local n = sx1 - sx2;
    local m = sx1 + sx2;
    if sx1==sx2 then
        move._a = 0;
        move._b = 0;
        move._c = sx1;
        move._topx = sx1;
        move._topy = topy;
        return move;
    end
    local a = 4*sx1*sx1 - 4*m*sx1 + m*m;
    local b = 4*t*sx1/n - 2 * t* m / n -4*s;
    local c = t*t/(n*n);
    local sqrt = math.sqrt(b*b-4*a*c) /(2*a);
    local _ra1 = (-b/(2*a) + sqrt); 
    local _ra2 = (-b/(2*a) - sqrt);
    if _ra1 >0 then
        move._a = _ra2;
    elseif _ra2 >0 then
        move._a = _ra1;
    else
        local _rb1 = t/n - _ra1*m;
        local _rb2 = t/n - _ra2*m;
        local rx1 = -_rb1/(2*_ra1);
        local rx2 = -_rb2/(2*_ra2);
        if (rx1>sx1 and rx1<sx2) or (rx1>sx2 and rx1<sx1) then
            move._a = _ra1;
        else
            move._a = _ra2;
        end
    end 
 
    move._b = t/n - move._a*m;
    move._c = topy + move._b* move._b/ (4* move._a); 
    move._topy =  topy;
    move._topx =  -move._b/(2*move._a);
    return move;
    --[[
    move._a = (sy1-sy2) / (sx1-sx2)/(2*(sx1+sx2)-topx);
    move._b = move._a*topx/-2;
    move._c = sy1 - move._a*math.pow(sx1,2) - move._b*sx1;
    move._topx = topx;
    move._topy = move._a*math.pow(topx,2) + move._b*topx + move._c;
    return move;
    --]]
end

function ThrowPath.CreateWithTopPoint(topx,topy,ox,oy)
    local move= ThrowPath.New();
    move._topx=topx;
    move._topy=topy;
    local xDis = ox-topx;
    move._a = (oy - topy)/(xDis* xDis);
    return move;
end

function ThrowPath:ctor()

end

--
function ThrowPath:GetY(_x)
--    local xDis = _x - self._topx;
--    return  self._a*(xDis)*xDis + self._topy;
    return self._a*(_x)*(_x) + self._b*(_x) + self._c;
end

--算出x，会有两个点
function ThrowPath:GetX(_y)
    local x=math.sqrt((_y-self._topy)/self._a)
    return x+self._topx,self._topx-x;
end

function ThrowPath:GetTop()
    return self._topx,self._topy;
end


return ThrowPath;