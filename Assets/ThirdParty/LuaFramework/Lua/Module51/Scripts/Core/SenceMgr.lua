--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2019-08-20 17:31:13
]]

SenceMgr = {}
local self = SenceMgr;

function SenceMgr.new(args)
    local a = args or {};
    setmetatable(a,self);
    self.__index = self;
    return a;
end

self.senceMap = {};

function SenceMgr.OnInitSenceMgr()
    self.senceMap = {};
end

function SenceMgr.OnClearSence()
    local length = #self.senceMap;
    for i = 1,length do
        self.senceMap[i].SenceView.OnDestroy();
    end 
    self.senceMap = {};
end
function SenceMgr.RegisterSence(args)
    local senceUnit = 
    {
        SenceName = args.SenceName;
        SenceView = args;
    }
    table.insert(self.senceMap,senceUnit);
    args.OnAwake();
end
function SenceMgr.RemoveSence(senceName)
    local length = #self.senceMap;
    for i = 1,length do
        if (self.senceMap[i].SenceName == senceName) then
            self.senceMap[i].SenceView.OnDestroy();
            table.remove( self.senceMap, i )
        end
    end
end

function SenceMgr.FindSence(senceName)
    local length = #self.senceMap;
    for i = 1,length do
        if (self.senceMap[i].SenceName == senceName) then
            return self.senceMap[i].SenceView;
        end
    end 
    return nil;
end