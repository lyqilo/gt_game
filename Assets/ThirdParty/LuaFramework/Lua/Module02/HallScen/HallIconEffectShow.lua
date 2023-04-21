HallIconEffectShow = {}
local self = HallIconEffectShow;
self.transform = nil;
self.gameObject = nil;
self.luaBehaviour = nil;
self.light = nil;
self.timer = 0;
self.durTime = 0;
self.waitTime = 0;
self.isShow = false;
self.isHide = false;
self.currentState = 0;

function HallIconEffectShow:New()
    local t = o or {};
    setmetatable(t, self);
    self.__index = self;
    return t;
end

function HallIconEffectShow:Init(obj)
    self.gameObject = obj;
    self.transform = self.gameObject.transform;
    self.luaBehaviour = self.transform:GetComponent("BaseBehaviour");
    if self.luaBehaviour == nil then
        self.luaBehaviour = Util.AddComponent("BaseBehaviour", self.gameObject);
        self.luaBehaviour:SetLuaTab(self, "HallIconEffectShow");
    end
end

function HallIconEffectShow:Awake(obj)
    --self.light = self.transform:Find("Light"):GetComponent("SkeletonGraphic");
    self.waitTime = math.random(3, 10);
    self.durTime = math.random(3, 6);
    self.isShow = false;
    self.isHide = false;
    local ranState = math.random(1, 2);
    -- if ranState == 1 then
    --     self.light:DOFade(0, 0.5):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
    --         self.currentState = 1;
    --     end);
    -- else
    --     self.light:DOFade(1, 0.5):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
    --         self.currentState = 2;
    --     end);
    -- end
end

function HallIconEffectShow:Update()
    -- if self.light == nil then
    --     return ;
    -- end
    if self.currentState == 0 then
    elseif self.currentState == 1 then
        self:WaitState();
    elseif self.currentState == 2 then
        self:ShowState();
    end
end

function HallIconEffectShow:WaitState()
    if self.waitTime > 0 then
        self.waitTime = self.waitTime - Time.deltaTime;
        return ;
    end
    self.currentState = 0;
    self.light:DOFade(1, 0.5):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        self.currentState = 2;
    end);
end
function HallIconEffectShow:ShowState()
    if self.durTime > 0 then
        self.durTime = self.durTime - Time.deltaTime;
        return ;
    end
    self.currentState = 0;
    self.light:DOFade(0, 0.5):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        self.waitTime = math.random(3, 10);
        self.durTime = math.random(3, 6);
        self.currentState = 1;
    end);
end
