--[[    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2019-08-20 17:31:13
]]
AudioItem = {}
local self = AudioItem;

function AudioItem:new(obj)
    local o = obj or {};
    setmetatable(o, { __index = self });
    return o;
end
function AudioItem:Init(go, timer)
    go:SetActive(true);
    go:GetComponent("AudioSource"):Play();
    local stop = function()
        coroutine.wait(timer);
        if go == nil then return end
        destroy(go);
    end
    coroutine.start(stop);
end