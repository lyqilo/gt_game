--渔网管理
OneWPBY_NetController = {};
local self = OneWPBY_NetController;
--根据炮弹生成渔网
function OneWPBY_NetController.CreateNew(site, pos, fishID)
    local index = 1;
    if site == OneWPBYEntry.ChairID then
        index = 2;
    else
        index = 1;
    end
    local type = "BulltEffect_" .. index;
    local net = self.FindEnableNet(type);
    if net == nil then
        net = newObject(OneWPBYEntry.netPool:Find(type).gameObject);
        net.gameObject.name = type;
    end
    local fish = OneWPBY_FishController.GetFish(fishID);
    if fish ~= nil and fish.fishData.Kind >= 6 then
        --TODO 音效
        --OneWPBY_Audio.PlaySound(OneWPBY_Audio.SoundList.Hit);
    end
    net.transform:SetParent(OneWPBYEntry.netScene);
    net.transform.position = pos;
    net.transform.localRotation = Quaternion.Euler(0, 0, math.random(0, 359));
    net.transform.localScale = Vector3.New(1, 1, 1);
    net.gameObject:SetActive(true);
    OneWPBYEntry.DelayCall(2, function()
        self.CollectNew(net.gameObject);
    end);
end
function OneWPBY_NetController.FindEnableNet(type)
    for i = 1, OneWPBYEntry.netCache.childCount do
        if OneWPBYEntry.netCache:GetChild(i - 1) ~= nil and OneWPBYEntry.netCache:GetChild(i - 1).gameObject.name == type then
            return OneWPBYEntry.netCache:GetChild(i - 1).gameObject;
        end
    end
end
--回收渔网
function OneWPBY_NetController.CollectNew(net)
    net.transform:SetParent(OneWPBYEntry.netCache);
    net.gameObject:SetActive(false);
    net.transform.localPosition = Vector3.New(0, 0, 0);
end