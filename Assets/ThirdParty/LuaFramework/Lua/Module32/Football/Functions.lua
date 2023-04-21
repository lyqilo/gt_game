local targetPreSuffix="";


local CFunctionsLibs = {};
local _globalGameConfig ;

function CFunctionsLibs.CreateTargetName(_id)
    return targetPreSuffix .. _id;
end

--获取目标的ID
function CFunctionsLibs.GetTargetID(_name)
    local str= string.gmatch(_name,targetPreSuffix .. "([0-9]+)");
    local targetId = str();
    if targetId==nil then
        return false;
    else
        return true,tonumber(targetId);
    end
--    local str=string.gmatch(_name, targetPreSuffix .. "([0-9]+)"); 
--    return tonumber(str());
end

--是不是鱼根节点的名字
function CFunctionsLibs.IsTargetRootName(_name)
    local str= string.gmatch(_name,targetPreSuffix .. "([0-9]+)");
    local targetId = str();
    if targetId==nil then
        return false;
    else
        return true,tonumber(targetId);
    end
end

--是否是鱼的父节点
function CFunctionsLibs.IsTargetRoot(gameObject)
    if IsNil(gameObject) then
        return false;
    end
    return CFunctionsLibs.IsTargetRootName(gameObject.name);
end

--查询鱼的父节点
function CFunctionsLibs.FindTargetRoot(gameObject)
    if IsNil(gameObject) then
        return nil;
    end
    local ret ,targetid = CFunctionsLibs.IsTargetRoot(gameObject);
    if ret then
        return gameObject,targetid;
    end
    local parentObj = gameObject.transform.parent;
    if parentObj~=nil then
        return CFunctionsLibs.FindTargetRoot(parentObj.gameObject);
    end
    return nil;
end

--得到鱼的ID
function CFunctionsLibs.GetTargetIDByGameObject(go)
    local targetRoot,id = CFunctionsLibs.FindTargetRoot(go);
    if targetRoot then
        return id;
    end
    return _globalGameConfig.ConstDefine.C_S_INVALID_MONSTER_ID;
end

--是否可以锁定
function CFunctionsLibs.Mod_Fish_IsCanBeLock(_type)
    local fishConfig = _globalGameConfig.GameConfig.FishInfo[_type];
    if fishConfig then
        return fishConfig.isLock;
    end
    return false;
end

--得到对应的预制体名字
function CFunctionsLibs.FUNC_GetPrefabName(_styleType)
    local prefabInfo = _globalGameConfig.GameConfig.PrefabName[_styleType];
    if prefabInfo==nil then
        error("!!!!====> PrefabName(" .. _styleType .. ") is empty!!!!");
        return String.Empte;
    end
    return prefabInfo.prefabName;
end

--计算角度
function CFunctionsLibs.FUNC_GetEulerAngle(p1,p2)
    local r
    if p1.x==p2.x then
        if p1.y>p2.y then
            r=0;
        elseif p1.y<p2.y then
            r=180;
        else
            r=0;
        end
    else
        r=math.rad2Deg*math.atan((p2.y-p1.y)/(p2.x-p1.x));
    end
    if (p2.x-p1.x)<=0 then r=90+r else r=r-90 end
    return r;
end

--计算角度
function CFunctionsLibs.FUNC_GetEulerAngleByLevel(p1,p2)
    local r
    if p1.y == p2.y then
        if p1.x<=p2.x then
            r = 0;
        else
            r = 180;
        end
    else
        r=math.rad2Deg*math.atan((p2.y-p1.y)/(p2.x-p1.x));
        if p2.x>=p1.x then
        else
            r = r + 180;
        end
    end
    return r;
end

--添加动画
function CFunctionsLibs.FUNC_AddAnimate(_go,_animateType)
    return _globalGameConfig._animaTool:AddAnimateType(_go,_animateType);
end

--添加动画集合
function CFunctionsLibs.FUNC_AddAnimateSet(_go,_animateSetType)
    return _globalGameConfig._animaTool:AddAnimateSetType(_go,_animateSetType);
end

--缓存游戏体
function CFunctionsLibs.FUNC_CacheGO(_go,_cacheName)
    _globalGameConfig:CacheGO(_go,_cacheName);
end


--获取spritePlist;
function CFunctionsLibs.FUNC_GetSpritePlist(_tag)
    return _globalGameConfig:GetSpritePlist(_tag);
end

--调用函数初始化
function CFunctionsLibs.FunctionInit(_globalGame)
    _globalGameConfig = _globalGame;
end


local SCENE_RIGHT_DOWN_X = -(1334/2);
local SCENE_LEFT_DOWN_X = -(1334/2);
local nearestZ = 0;
local farestZ  = 580;  --650
local totalZ  = (farestZ-nearestZ);
local SCENE_X_Z_RADIO = 1.2 

local scaleMax,scaleMin = 1,0.65; --1 0.7
local totalScaleDis = (scaleMax - scaleMin);

local z_y_radio = 1;

local scaleYMax,scaleYMin = 1,0.25;  --1 0.1
local maxY     = 600;
local minY     = 0;
local totalY = (maxY - minY);
local totalScaleY = (scaleYMax - scaleYMin);
local z_LayerCount = 5; --层级数
local z_OrderCount = 3; --纬度



function CFunctionsLibs.FUNC_GetFarestScale(y,z)
    local scale,scaleY,scaleZ;
    scaleZ = (1-(z-nearestZ)*1.0/totalZ)*totalScaleDis + scaleMin;
    if y>=maxY then
        scaleY = 0;
    else
        scaleY = (1-(y-minY)*1.0/totalY)*totalScaleY+ scaleYMin;
    end
    return scaleZ * scaleY;
end

local maxColor = 1;
local minColor = 0.45;

function CFunctionsLibs.FUNC_GetHightColor(y)
    local colorY;
    if y>=maxY then
        colorY = minColor;
    else
        colorY = (1-(y-minY)*1.0/totalY)*(maxColor-minColor)+ minColor;
    end
    return colorY;
end

function CFunctionsLibs.FUNC_GetLeftX(z,dis)
	local bili = ((1-(z-nearestZ)*1.0/totalZ)*totalScaleDis + scaleMin);
	if(bili==0) then
		return 0;
	end
	return math.floor((SCENE_LEFT_DOWN_X/bili)-dis);    
end

function CFunctionsLibs.FUNC_GetRightX(z,dis)
    return -CFunctionsLibs.FUNC_GetLeftX(z,dis);
end


--虚拟坐标转化为实际的坐标
function CFunctionsLibs.FUNC_TransformToPosition(x,y,z,zLayer,zOrder)
--    local rx,ry,rz;
--    rx = x;
--    ry = y + z * 0.6;
--    rz = rz;
--    return rx,ry,rz;
    if type(zLayer)=="number" then
    else
        zLayer = 0;
    end
    if type(zOrder)=="number" then
    else
        zOrder = 0;
    end
    zLayer = zLayer or 0;
    zOrder = zOrder or 0;
    if zOrder>= z_OrderCount then
        zOrder = z_OrderCount -1;
    end
    if zOrder<= 0 then
        zOrder = 0;
    end
    if (zLayer>=z_LayerCount) then
        zLayer = z_LayerCount - 1; 
    end
    if zLayer<= 0 then
        zLayer = 0;
    end
    local rx,ry,rz;
    local disZ = z - nearestZ;
    local bili = (1-(disZ*1.0/totalZ))*totalScaleDis + scaleMin;
    rx = x * bili;
    ry = y + z_y_radio*z-240;
    rz = z*(z_OrderCount)*z_LayerCount + zLayer*z_OrderCount + zOrder;
    return rx,ry,rz;
end

function CFunctionsLibs.FUNC_RandomZLayer()
    return math.random(1,z_LayerCount)-1;
end

--计算速度
function CFunctionsLibs.FUNC_GetTowardsVectors(_towards,_speed)
    local t =1;
    local x = _towards.x/t;
    local y = _towards.y/t;
    local z = _towards.z/t;
    local pbase = math.sqrt(_speed*_speed /(x*x+y*y+z*z));
    return Vector3.New(pbase*x,pbase*y,pbase*z);
end



local bit={data32={}}
for i=1,32 do
    bit.data32[i]=2^(32-i)
end

function bit:d2b(arg)
    local   tr={}
    for i=1,32 do
        if arg >= self.data32[i] then
        tr[i]=1
        arg=arg-self.data32[i]
        else
        tr[i]=0
        end
    end
    return   tr
end   --bit:d2b

function    bit:b2d(arg)
    local   nr=0
    for i=1,32 do
        if arg[i] ==1 then
        nr=nr+2^(32-i)
        end
    end
    return  nr
end  --bit:b2d

local _int16 = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};

function bit:_getLow(a)
    local   r={}
    local   op1=self:d2b(a)
    for i=1,16 do
        if op1[i+16]==1 then
            r[i+16]=1
        else
            r[i+16]=0
        end
    end
    return  self:b2d(r)
end

function bit:_getHigh(a)
    local   r={}
    local   op1=self:d2b(a)
    for i=1,16 do
        if op1[i]==1  then
            r[i+16]=1
        else
            r[i+16]=0
        end
    end
    return  self:b2d(r)
end

function bit:_changeToShortValue(value)
    if value>=32768 then
        return -(65536 - value);
    end
    return value;
end



function    bit:_xor(a,b)
    local   op1=self:d2b(a)
    local   op2=self:d2b(b)
    local   r={}

    for i=1,32 do
        if op1[i]==op2[i] then
            r[i]=0
        else
            r[i]=1
        end
    end
    return  self:b2d(r)
end --bit:xor

function    bit:_and(a,b)
    local   op1=self:d2b(a)
    local   op2=self:d2b(b)
    local   r={}
    
    for i=1,32 do
        if op1[i]==1 and op2[i]==1  then
            r[i]=1
        else
            r[i]=0
        end
    end
    return  self:b2d(r)
    
end --bit:_and

function    bit:_or(a,b)
    local   op1=self:d2b(a)
    local   op2=self:d2b(b)
    local   r={}
    
    for i=1,32 do
        if  op1[i]==1 or   op2[i]==1   then
            r[i]=1
        else
            r[i]=0
        end
    end
    return  self:b2d(r)
end --bit:_or

function    bit:_not(a)
    local   op1=self:d2b(a)
    local   r={}

    for i=1,32 do
        if  op1[i]==1   then
            r[i]=0
        else
            r[i]=1
        end
    end
    return  self:b2d(r)
end --bit:_not

function    bit:_rshift(a,n)
    local   op1=self:d2b(a)
    local   r=self:d2b(0)
    
    if n < 32 and n > 0 then
        for i=1,n do
            for i=31,1,-1 do
                op1[i+1]=op1[i]
            end
            op1[1]=0
        end
    r=op1
    end
    return  self:b2d(r)
end --bit:_rshift

function    bit:_lshift(a,n)
    local   op1=self:d2b(a)
    local   r=self:d2b(0)
    
    if n < 32 and n > 0 then
        for i=1,n   do
            for i=1,31 do
                op1[i]=op1[i+1]
            end
            op1[32]=0
        end
    r=op1
    end
    return  self:b2d(r)
end --bit:_lshift


function    bit:print(ta)
    local   sr=""
    for i=1,32 do
        sr=sr..ta[i]
    end
    print(sr)
end

CFunctionsLibs.Bit = bit;

return CFunctionsLibs;