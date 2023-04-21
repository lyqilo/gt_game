local ThrowPath=class("ThrowPath");

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
    local temp = (math.pow(sx1,2)-math.pow(sx2,2)-2*sx1*topx + 2*topx*sx2);
    move._a = (sy1-sy2) / (math.pow(sx1,2)-math.pow(sx2,2)-2*sx1*topx + 2*topx*sx2);
    move._b = move._a*topx*-2;
    move._c = sy1 - move._a*math.pow(sx1,2) - move._b*sx1;
    --error("a: " .. move._a .. ",b:" .. move._b .. ",c:" .. move._c);
    move._topx = topx;
    move._topy = move._a*math.pow(topx,2) + move._b*topx + move._c;
    --error("topx: " .. topx .. ",topy:" .. move._topy);
    return move;
end

--暂时算不出来，不考虑这种情况
function ThrowPath.CreateWithTopY(sx1,sy1,sx2,sy2,topy)
    local move= ThrowPath.New();
    move._a = (sy1-sy2) / (sx1-sx2)/(2*(sx1+sx2)-topx);
    move._b = move._a*topx/-2;
    move._c = sy1 - move._a*math.pow(sx1,2) - move._b*sx1;
    move._topx = topx;
    move._topy = move._a*math.pow(topx,2) + move._b*topx + move._c;
    return move;
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
    local xDis = _x - self._topx;
    return  self._a*(xDis)*xDis + self._topy;
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