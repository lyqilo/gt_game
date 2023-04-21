OneWPBY_BulletController = {};
local self = OneWPBY_BulletController;

self.playlist = {};
self.bulletList = {};
function OneWPBY_BulletController.Init()
    self.playlist = {};
    self.bulletList = {};
end
function OneWPBY_BulletController.CreateBullet(bulletid, bulletdata)
    local bullet = OneWPBYEntry.bulletCache:Find("bullet" .. bulletdata.level);
    if bullet == nil then
        bullet = newobject(OneWPBYEntry.bulletPool:Find("bullet" .. bulletdata.level).gameObject).transform;
    end
    local player = OneWPBY_PlayerController.GetPlayer(bulletdata.wChairID);
    bullet:SetParent(player.shootPoint);
    bullet.localPosition = Vector3.New(0, 0, 0);
    bullet.localRotation = Quaternion.identity;
    bullet.localScale = Vector3.New(1, 1, 1);
    bullet:SetParent(OneWPBYEntry.bulletScene);
    local _bullet = OneWPBY_Bullet:New();
    _bullet:Init(bullet, bulletdata);
    table.insert(self.bulletList, _bullet);
end
function OneWPBY_BulletController.CollectBullet(bullet)
    OneWPBY_NetController.CreateNew(bullet.bulletdata.level, bullet.transform.localPosition);
    for i = 1, #self.bulletList do
        if self.bulletList[i].bulletdata.bulletId == bullet.bulletdata.bulletId then
            table.remove(self.bulletList, i);
            bullet.transform:SetParent(OneWPBYEntry.bulletCache);
            bullet.transform.localPosition = Vector3.New(0, 0, 0);
            bullet.gameObject:SetActive(false);
            destroy(bullet.luaBehaviour);
        end
    end
end