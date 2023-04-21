--渔网管理
WPBY_NetController = {};
local self = WPBY_NetController;
--根据炮弹生成渔网
function WPBY_NetController.CreateNew(site, pos, fishID)
    local type = "BulltEffect_" .. (site + 1);
    local net = self.FindEnableNet(type);
    if net == nil then
        net = newObject(WPBYEntry.netPool:Find(type).gameObject);
        net.gameObject.name = type;
    end
    if fishID >= 6 then
        --TODO 音效
        WPBY_Audio.PlaySound(WPBY_Audio.SoundList.Hit);        
    end
    net.transform:SetParent(WPBYEntry.netScene);
    net.transform.position = pos;
    net.transform.localRotation = Quaternion.Euler(0, 0, math.random(0, 359));
    net.transform.localScale = Vector3.New(1, 1, 1);
    net.gameObject:SetActive(true);
    WPBYEntry.DelayCall(2, function()
        self.CollectNew(net.gameObject);
    end);
end
function WPBY_NetController.FindEnableNet(type)
    for i = 1, WPBYEntry.netCache.childCount do
        if WPBYEntry.netCache:GetChild(i - 1) ~= nil and WPBYEntry.netCache:GetChild(i - 1).gameObject.name == type then
            return WPBYEntry.netCache:GetChild(i - 1).gameObject;
        end
    end
end
--回收渔网
function WPBY_NetController.CollectNew(net)
    net.transform:SetParent(WPBYEntry.netCache);
    net.gameObject:SetActive(false);
    net.transform.localPosition = Vector3.New(0, 0, 0);
end