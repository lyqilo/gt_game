GameConfig = {};
local self = GameConfig;

self.FRUIT_TYPE = {
    xiangjiao = 1;
    xigua = 2;
    ningmeng = 3;
    putao = 4;
    boluo = 5;
    lingdang = 6;
    yingtao = 7;
    bar = 8;
    bonus = 9;
    seven = 10;
    wild = 11;
}

function GameConfig.new(args)
    local o = args or {};
    setmetatable(o, self);
    self.__index = self;
    return o
end

function GameConfig.OnInitConfiger()
    self.GameName = "水果小玛丽";
    self.Version = "1.0.0";
    logYellow("on init config. the game name :" .. self.GameName .. " game version :" .. self.Version);
end


function GameConfig.ExitGame()

end