OneWPBY_Net = {};

function OneWPBY_Net:New(args)
    args = args or {};
    setmetatable(args, self);
    self.__index = self;
    return self;
end
function OneWPBY_Net:Init()
    
end