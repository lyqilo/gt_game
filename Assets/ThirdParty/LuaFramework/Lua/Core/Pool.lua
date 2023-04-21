--[[
通用缓存池
Pool 
new()
init( obj )
Clear()
finish()
]]

Pool = {};
local this = Pool;

local transform;
local PoolList = {};

function this.Init()
	if transform == nil then
		local gameObject = GameObject.New( "PoolNode" );
		gameObject:SetActive(false);
		transform = gameObject.transform;
	end
end

function this.UnInit()
	for k,pool in pairs(PoolList) do
		pool:finish();
	end
	if transform then
		destroy(transform.gameObject);
	end
end

--创建缓存池 
-- tbName 控件tb名称例如：MJCard
-- prefab 控件tb管理的Obj的prefab
function this:new( tbName, prefab , poolName )
    local o = { };
    setmetatable(o, { __index = self } );
    o:init( tbName, prefab , poolName );
    table.insert(PoolList,o);
    return o;
end

--初始化
function this:init( tbName , prefab , poolName )
	self.isInit = true;
	self.stack = Stack:new();	--生成缓存池
	self.stackMap = {};
	self.poolName = poolName;
	self.tbName = tbName;		--保存tb与Pool名称
	self.tbcs = _G[tbName];		--获取tb
	if self.tbcs == nil then	--
		logError("没有找到名为："..tbName.."的脚本！！");
		self.isInit = false;
		return;
	end
	self.prefab = prefab;		--保存prefab
end

--从缓存池获取初始化好的tbcs
function this:Get()
	if not self.isInit then
		return nil;
	end

	if self.stack:size() == 0 then
		--创建新实例
		local tbcs = self.tbcs:new();	--创建控制tb
		local obj = nil;
		if self.prefab then
			obj = newObject(self.prefab);
		end
		tbcs:init(obj);					--绑定tb与Obj
		
		tbcs.__tableName = self.tbName;	--设置控制tb名称
		tbcs.__poolName = self.poolName;
		return tbcs;					--返回tb

	else
		local tbcs = self.stack:pop();
		self.stackMap[tbcs] = nil;
		return tbcs;		--返回缓存池tb
	end
end

--回收不使用的tbcs
function this:Release( tbcs )
	if tbcs == nil then
		return;
	end
	
	if tbcs.Clear == nil then
		logError(tostring(tbcs.__tableName).."脚本没有定义Clear方法！！");
		return;
	end
	tbcs:Clear();	--重置tb

	if tbcs.__tableName ~= self.tbName then
		logError("回收Table名为:"..tostring(tbcs.__tableName).." Pool名称:"..tostring(self.tbName).."!!!!!");
		return;
	end
	if self.stackMap[tbcs] then
		logError(tostring(tbcs.__tableName).."当前已经被回收,请勿重复回收！！！！！");
		return;
	end
	self.stack:push(tbcs);--回收tb
	self.stackMap[tbcs] = true;
	if tbcs.transform then
		tbcs.transform:SetParent(transform);
	end
end

--清理缓存池的tbcs
function this:Clear()
	while self.stack:size() > 0 do
		local tbcs =  self.stack:pop();
		if tbcs.finish == nil then
			logError(tostring(self.tbName).."脚本没有定义finish方法！！");
		else
			tbcs:finish();
		end
	end
	self.stackMap = {};
end

function this:finish()
	self:Clear();
	self.isInit = nil;
	self.stack = nil;
	self.stackMap = nil;
	self.tbName = nil;
	self.tbcs = nil;	
	self.prefab = nil;
	self.poolName = nil;
end

