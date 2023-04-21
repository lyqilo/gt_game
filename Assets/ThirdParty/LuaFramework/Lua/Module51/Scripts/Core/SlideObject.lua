SlideObject = {}
local self = SlideObject;

self.icon = nil; -- image
self.selete = nil; -- image
self.hit = nil; -- image
self.isSelete = false;
self.isRun = false;
self.obj = nil; --GameObject
self.alpha = 1;
self.color = nil;
--up image down image y float
function SlideObject:new(obj)
    local o = obj or {};
    setmetatable(o, { __index = self });
    return o;
end
function SlideObject:OnInit(obj)
    self.color = Color.New(1, 1, 1, 1);
    self.obj = obj;
    self.icon = obj.transform:Find(obj.name .. "_icon");
    self.selete = obj.transform:Find(obj.name .. "_ani");
    self.hit = obj.transform:Find(obj.name .. "_hit");
    obj.transform:Find(obj.name .. "_hit").gameObject:SetActive(false);
    self:Hide();
end
function SlideObject:Hide()
    self.selete.gameObject:SetActive(false);
    self.isRun = false;
    self.alpha = 1;
end
function SlideObject:Show()
    self.selete.gameObject:SetActive(true);
    self.isRun = true;
    self.alpha = 1;
end
function SlideObject:ShowX()
    self.selete.gameObject:SetActive(true);
    self.isRun = false;
    self.alpha = 1;
end
function SlideObject:Hit()
    local show = false;
    local time = 0.2
    for i = 1, 6 do
        if (i % 2 == 0) then
            show = false;
        else
            show = true;
        end
        local shan = function()
            self.hit.gameObject:SetActive(show);
        end
        SlotGameEntry.AddCallBack(time, shan)
        time = time + 0.3
    end
    local shan2 = function()
        self.hit.gameObject:SetActive(false);
    end
    SlotGameEntry.AddCallBack(time + 1, shan2)
end

function SlideObject:Update()
    if (self.isRun == false) then
        return;
    end
    if (self.alpha > 0) then
        self.alpha = self.alpha - 0.05;
    end
    self.color.a = self.alpha;
    self.selete.gameObject:GetComponent('Image').color = self.color;
    if (self.alpha <= 0) then
        self:Hide();
    end
end