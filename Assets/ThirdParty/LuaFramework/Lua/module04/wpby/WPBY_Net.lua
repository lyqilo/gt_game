WPBY_Net = {};

function WPBY_Net:New(args)
    args = args or {};
    setmetatable(args, self);
    self.__index = self;
    return self;
end
function WPBY_Net:Init()
    
end