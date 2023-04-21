OneWPBY_Fish = {};
local self = OneWPBY_Fish;
self.fishID = 0;
self.Path = {};
self.pointCount = 300;
self.fishData = nil;
self.speed = 0;
self.isSwim = false;
self.currentPos = 1;
self.isdead = false;
self.resetColorTime = 0.1;
self.timer = 0;
self.FishImage = {};
self.IsHit = false;
self.lockTag = nil;
self.hitColor = Color.New(255 / 255, 133 / 255, 133 / 255, 255 / 255);
self.isRotate = false;
self.rotateTarget = nil;

function OneWPBY_Fish:New()
    local t = o or {};
    setmetatable(t, self);
    self.__index = self;
    return t;
end
function OneWPBY_Fish:FindAllFishImage()
    self.FishImage = {};
    if self.transform:GetComponent("Image") ~= nil then
        table.insert(self.FishImage, self.transform:GetComponent("Image"));
    end
    self:FindChildImage(self.transform);
end
function OneWPBY_Fish:FindChildImage(parent)
    for i = 1, parent.childCount do
        if parent:GetChild(i - 1):GetComponent("Image") ~= nil then
            table.insert(self.FishImage, parent:GetChild(i - 1):GetComponent("Image"));
        end
        self:FindChildImage(parent:GetChild(i - 1));
    end
end
function OneWPBY_Fish:Init(data, obj)
    self.gameObject = obj.gameObject;
    self.transform = self.gameObject.transform;
    self.luaBehaviour = self.transform:GetComponent("BaseBehaviour");
    if self.luaBehaviour == nil then
        self.luaBehaviour = Util.AddComponent("BaseBehaviour", self.gameObject);
        self.luaBehaviour:SetLuaTab(self, "OneWPBY_Fish");
    end
    self.fishData = data;
    self.fishID = data.id;
    self.gameObject.name = data.id;
    self.currentPos = math.ceil(self.fishData.NowTime / math.ceil(Time.fixedDeltaTime / 0.01));
    if self.currentPos <= 0 then
        self.currentPos = 1;
    end
    self.Path = self:CreateNewPath(data.fishPoint);
    if self.fishData.NowTime >= self.fishData.EndTime then
        self:SwimCompleted();
        return ;
    end
    self.lockTag = self.transform:Find("Lock");
    if self.lockTag ~= nil then
        self.lockTag.gameObject:SetActive(OneWPBY_PlayerController.isLock);
    end
    self.gameObject:SetActive(true);
    local collider = self.transform:GetComponent("Collider");
    if collider ~= nil then
        collider.enabled = true;
    end
    --self:FindAllFishImage();
    --if self.fishData.Kind == 22 then
    --    self.transform:Find("odd"):GetComponent("TextMeshProUGUI").text = OneWPBYEntry.ShowText(self.fishData.odd);
    --end
    self:Swim();
end
function OneWPBY_Fish:CreateNewPath(_path)
    local path = {};
    for i = 1, #_path do
        local p = Vector3.New(_path[i].x, _path[i].y, 0);
        if OneWPBYEntry.isRevert then
            p = Vector3.New(-p.x, -p.y, 0);
        end
        table.insert(path, p);
    end
    local points = math.ceil(self.fishData.EndTime / math.ceil(Time.fixedDeltaTime / 0.01));
    return OneWPBYEntry.GetBezierPoint(path, points);
end
--小鱼开始游
function OneWPBY_Fish:Swim()
    self.transform:SetParent(OneWPBYEntry.fishScene);
    self.transform.localPosition = self.Path[Mathf.Floor(self.currentPos)];
    local rate = OneWPBY_DataConfig.StartScale[self.fishData.Kind];
    self.transform.localScale = Vector3.New(1 * rate, 1 * rate, 1 * rate);
    if OneWPBYEntry.isYc then
        self.speed = 5;
    else
        self.speed = 1;
    end
    local img = self.transform:GetComponent("Image");
    if img ~= nil then
        img.color = Color.New(1, 1, 1, img.color.a);
    end
    self.isdead = false;
    self.isSwim = true;
end
function OneWPBY_Fish:QuickSwim()
    self.speed = 5;
end
function OneWPBY_Fish:FixedUpdate()
    self:RestColor();
    if self.isRotate then
        self.transform:RotateAround(self.rotateTarget, Vector3.New(0, 0, -1), 3)
    end
    if self.isSwim then
        self.currentPos = self.currentPos + self.speed;
        if self.currentPos > #self.Path then
            self:SwimCompleted();
            return ;
        end
        self.transform.localPosition = self.Path[Mathf.Floor(self.currentPos)];
        self.transform.eulerAngles = Vector3.New(0, 0, self:GetAngle());
    end
end
--鱼儿死掉了
function OneWPBY_Fish:SwimCompleted()
    self.isSwim = false;
    self.speed = 0;
    self.isdead = true;
    self.isRotate = false;
    local anim = self.transform:GetComponent("Animator");
    if anim ~= nil then
        anim:SetTrigger("PlayDieAnime");
    end
    local collider = self.transform:GetComponent("Collider");
    if collider ~= nil then
        collider.enabled = false;
    end
    OneWPBYEntry.DelayCall(1.5, function()
        OneWPBY_FishController.CollectFish(self.fishData.id, self.fishData.Kind, self.gameObject);
    end);
end
function OneWPBY_Fish:StopSwim(pos)
    self.isSwim = false;
    self.rotateTarget = pos;
    self.speed = 0;
    self.isdead = true;
    local collider = self.transform:GetComponent("Collider");
    if collider ~= nil then
        collider.enabled = false;
    end
    self.isRotate = true;
end
function OneWPBY_Fish:Dead(deadFishData, chairId)
    self.isSwim = false;
    self.speed = 0;
    self.isdead = true;
    self.isRotate = false;
    local anim = self.transform:GetComponent("Animator");
    if anim ~= nil then
        anim:SetTrigger("PlayDieAnime");
    end
    local collider = self.transform:GetComponent("Collider");
    if collider ~= nil then
        collider.enabled = false;
    end
    if self.rotateTweener ~= nil then
        self.rotateTweener:Kill();
    end
    --TODO 飞金币,显示文本金币
    OneWPBY_GoldEffect.ShowSuperJack(deadFishData.score, self, chairId);
    OneWPBY_GoldEffect.OnShowScure(self, deadFishData.score, chairId)
    OneWPBY_GoldEffect.FlyGold(self, deadFishData, chairId);
    local player = OneWPBY_PlayerController.GetPlayer(chairId);
    if player ~= nil then
        player:OnChangeUserScure(deadFishData.score, true);
        player:OnShowGold(deadFishData.score, self.fishData.id);
    end
    local time = 1.5;
    if self.fishData.Kind == 19 then
        time = 3;
        self.lockTag.gameObject:SetActive(false);
    end
    OneWPBYEntry.DelayCall(time, function()
        OneWPBY_FishController.CollectFish(self.fishData.id, self.fishData.Kind, self.gameObject);
    end);
end
function OneWPBY_Fish:GetAngle()
    if self.currentPos >= #self.Path then
        return self.transform.eulerAngles.z;
    end
    local to = self.Path[Mathf.Floor(self.currentPos + 1)];
    local direction = to - self.transform.localPosition;
    local angle = (360 - Mathf.Atan2(direction.x, direction.y) * Mathf.Rad2Deg) + 90;
    return angle;
end
function OneWPBY_Fish:RestColor()
    if not self.IsHit then
        return ;
    end
    if Time.realtimeSinceStartup - self.lastRestTime > self.resetColorTime then
        local img = self.transform:GetComponent("Image");
        if img ~= nil then
            img.color = Color.New(1, 1, 1, img.color.a);
        end
    end
end
function OneWPBY_Fish:OnChangeHitColor()
    local img = self.transform:GetComponent("Image");
    if img ~= nil then
        img.color = Color.New(self.hitColor.r, self.hitColor.g, self.hitColor.b, img.color.a);
    end
end
function OneWPBY_Fish:OnHitFish()
    self:OnChangeHitColor();
    self.IsHit = true;
    self.lastRestTime = Time.realtimeSinceStartup;
end
--是否在屏幕内
function OneWPBY_Fish:IsToSence()
    if self.transform.localPosition.x > OneWPBYEntry.width / 2 then
        return false;
    end
    if self.transform.localPosition.x < -OneWPBYEntry.width / 2 then
        return false;
    end
    if self.transform.localPosition.y < -OneWPBYEntry.height / 2 then
        return false;
    end
    if self.transform.localPosition.y > OneWPBYEntry.height / 2 then
        return false;
    end
    if self.isdead then
        return false;
    end
    return true;
end
function OneWPBY_Fish:IsToAngle(distance, point)
    if self.isdead then
        return false;
    end
    local selfPos = self.transform.localPosition;
    if Vector3.Distance(point, selfPos) <= distance then
        return true;
    end
    return false;
end