OneWPBY_Bullet = {};

local self = OneWPBY_Bullet;

self.bulletdata = nil;
self.speed = 20;
self.Direction = Vector2.New(0, 0);
self.Level = 0;
self.Grade = 0;
self.lockFish = nil;
self.isLock = false;
self.bulletId = 0;
self.wChairID = 0;
self.type = 0;
self.isUse = 0;

function OneWPBY_Bullet:New()
    local t = o or {};
    setmetatable(t, self);
    self.__index = self;
    return t;
end
function OneWPBY_Bullet:Init(obj, bulletid, data)
    self.gameObject = obj.gameObject;
    self.transform = self.gameObject.transform;
    self.luaBehaviour = self.transform:GetComponent("BaseBehaviour");
    if self.luaBehaviour == nil then
        self.luaBehaviour = Util.AddComponent("BaseBehaviour", self.gameObject);
        self.luaBehaviour:SetLuaTab(self, "OneWPBY_Bullet");
    end
    self.wChairID = data.wChairID;
    local player = OneWPBY_PlayerController.GetPlayer(self.wChairID);
    if player ~= nil then
        if player.isSuperMode then
            self.speed = 12;
            self.type = 1;
        else
            self.speed = 20;
            self.type = 0;
        end
    end
    self.bulletdata = data;
    self.Direction = 0;
    self.Level = data.level;
    self.Grade = data.type;
    self.bulletId = bulletid;
    self.transform:GetComponent("Collider").enabled = true;
end
function OneWPBY_Bullet:Update()
    if self.isLock then
        local player = OneWPBY_PlayerController.GetPlayer(self.wChairID);
        if player == nil then
            self.isLock = false;
            self:Collect();
            return ;
        end
        if self.lockFish ~= nil then
            if player.LockFish ~= self.lockFish or not self.lockFish:IsToSence() then
                self.isLock = false;
                return ;
            end
        else
            self.isLock = false;
        end
    end
    if self.Direction ~= 1 then
        --向左
        if self.transform.position.x < OneWPBYEntry.viewportRect.x then
            self.Direction = 1;
            self.transform.up = Vector3.Reflect(self.transform.up, Vector3.right);
        end
    end
    if self.Direction ~= 2 then
        --向上
        if self.transform.position.y > OneWPBYEntry.viewportRect.y then
            self.Direction = 2;
            self.transform.up = Vector3.Reflect(self.transform.up, Vector3.down);
        end
    end
    if self.Direction ~= 3 then
        --向右
        if self.transform.position.x > OneWPBYEntry.viewportRect.z then
            self.Direction = 3;
            self.transform.up = Vector3.Reflect(self.transform.up, Vector3.left);
        end
    end
    if self.Direction ~= 4 then
        --向下
        if self.transform.position.y < OneWPBYEntry.viewportRect.w then
            self.Direction = 4;
            self.transform.up = Vector3.Reflect(self.transform.up, Vector3.up);
        end
    end
    if self.isLock and self.lockFish ~= nil then
        local _dir = self.lockFish.transform.position - self.transform.position;
        self.transform.up = _dir;
        self.transform:Translate(Vector3.New(0, 1 * Time.deltaTime * self.speed * 10, 0));
        return ;
    end
    self.transform:Translate(Vector3.New(0, 1 * Time.deltaTime * self.speed * 10, 0));
end
function OneWPBY_Bullet:OnTriggerEnter(collider)
    if collider.tag == "fish" then
        --碰到鱼
        --如果是锁定，判断是否为锁定的鱼
        if self.isLock and self.lockFish ~= nil and (not self.lockFish.isdead or not self.lockFish:IsToSence()) then
            if self.lockFish.fishData.id ~= tonumber(collider.gameObject.name) then
                return ;
            end
        end
        --TODO 发送消息,隐藏子弹
        local id = tonumber(collider.gameObject.name);
        if id == nil then
            return ;
        end
        local fish = OneWPBY_FishController.GetFish(tonumber(collider.gameObject.name));
        if fish ~= nil then
            fish:OnHitFish();
            local player = OneWPBY_PlayerController.GetPlayer(self.wChairID);
            if self.wChairID == OneWPBYEntry.ChairID or player.isRobot then
                self:SendHitFish({ fish.fishData.id });
            end
        end
        OneWPBY_NetController.CreateNew(self.wChairID, self.transform.position, id);
        self:Collect();
    end
end
function OneWPBY_Bullet:Collect()
    destroy(self.luaBehaviour);
    self.transform:GetComponent("Collider").enabled = false;
    self.transform:SetParent(OneWPBYEntry.bulletCache);
    self.transform.localPosition = Vector3.New(0, 0, 0);
    local player = OneWPBY_PlayerController.GetPlayer(self.wChairID);
    if player ~= nil then
        for i = #player.bulletList, 1, -1 do
            if player.bulletList[i] ~= nil and player.bulletList[i].bulletId == self.bulletId then
                table.remove(player.bulletList, i);
            end
        end
    end
end
--发送击中鱼消息
function OneWPBY_Bullet:SendHitFish(fishIdlist)
    local buffer = ByteBuffer.New();
    buffer:WriteInt(self.bulletId);
    buffer:WriteByte(self.type);
    buffer:WriteByte(self.isUse);
    buffer:WriteByte(self.Level);
    buffer:WriteByte(self.Grade);
    buffer:WriteInt(OneWPBY_Struct.CMD_S_CONFIG.bulletScore[self.Grade + 1] * (self.Level + 1));
    buffer:WriteInt(self.wChairID);
    for i = 1, OneWPBY_DataConfig.MAX_DEAD_FISH do
        if i <= #fishIdlist then
            buffer:WriteInt(tonumber(fishIdlist[i]));
        else
            buffer:WriteInt(0);
        end
    end
    --local fish = OneWPBY_FishController.GetFish(tonumber(fishId));
    --log("=========击中鱼id：" .. fishId);
    --if fish ~= nil then
    --    logTable(fish.fishData);
    --end
    Network.Send(MH.MDM_GF_GAME, OneWPBY_Network.SUB_C_HITED_FISH, buffer, gameSocketNumber.GameSocket);
end
