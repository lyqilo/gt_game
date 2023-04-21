WPBY_BulletController = {};
local self = WPBY_BulletController;

self.playlist = {};
self.bulletList = {};
function WPBY_BulletController.Init()
    self.bulletList = {};
end
function WPBY_BulletController.CreateBullet(bulletid, bulletdata)
    local bullet = WPBYEntry.bulletCache:Find("bullet" .. bulletdata.level);
    if bullet == nil then
        bullet = newobject(WPBYEntry.bulletPool:Find("bullet" .. bulletdata.level).gameObject).transform;
    end
    local player = WPBY_PlayerController.GetPlayer(bulletdata.wChairID);
    bullet:SetParent(player.shootPoint);
    bullet.localPosition = Vector3.New(0, 0, 0);
    bullet.localRotation = Quaternion.identity;
    bullet.localScale = Vector3.New(1, 1, 1);
    bullet:SetParent(WPBYEntry.bulletScene);
    local _bullet = WPBY_Bullet:New();
    _bullet:Init(bullet, bulletdata);
    table.insert(self.bulletList, _bullet);
end
function WPBY_BulletController.CollectBullet(bullet)
    WPBY_NetController.CreateNew(bullet.bulletdata.level, bullet.transform.localPosition);
    for i = 1, #self.bulletList do
        if self.bulletList[i].bulletdata.bulletId == bullet.bulletdata.bulletId then
            table.remove(self.bulletList, i);
            bullet.transform:SetParent(WPBYEntry.bulletCache);
            bullet.transform.localPosition = Vector3.New(0, 0, 0);
            bullet.gameObject:SetActive(false);
            destroy(bullet.luaBehaviour);
        end
    end
end