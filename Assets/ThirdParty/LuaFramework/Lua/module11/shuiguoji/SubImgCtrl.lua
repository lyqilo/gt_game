--SubImgCtrl.lua
--Date
--水果机子图片控制

--endregion

SubImgCtrl = {};

local E_TIME_NOT_LIMIT = 600;
local E_TIME_TICK_ANIM = 0.2; --动画间隔时间

function SubImgCtrl:New(o)
    local t = o or { };
    setmetatable(t, self);
    self.__index = self
    return t;
end

function SubImgCtrl.Init(tra, iSubGrid)
    self = SubImgCtrl:New();
    self.transform = tra;
    self.gameObject = tra.gameObject;
    self.animTimer = FruitGameTimer:New();
    self.iSubGrid = iSubGrid;
    return self;
end


function SubImgCtrl:ShowImage(bShow)
    self.gameObject:SetActive(bShow);
end


function SubImgCtrl:Update()
    if(self.animTimer) then self.animTimer:timer(Time.deltaTime) end
end

function SubImgCtrl:ChangeAnimtionTime(iTime)
    iTime = iTime or E_TIME_TICK_ANIM;
    self.animTimer:ChangeTickTime(iTime);
end

function SubImgCtrl:PlayAnimation(iTime)
    
    iTime = iTime or E_TIME_NOT_LIMIT;

    if(self.iSubGrid) then
        local id = FruitData.C_SUB_IMG[self.iSubGrid + 1];
        if(id > FruitData.E_CAP) then
           FruitGameMain.PlayMusic(FruitResource.strWinAwardVoice, id);
        end
    end

    local funTIck = function ()
                        self.gameObject:SetActive(not self.gameObject.activeSelf);
                    end

    local tab1 = { fun = funTIck; args = SubImgCtrl; }
    local tab2 = { fun = FruitGameMain.handler(self,self.AnimationEnd) ; args = SubImgCtrl; }
    self.animTimer:SetTimer(iTime, true, FruitGameTimer.FruitTimerType.tick, E_TIME_TICK_ANIM, tab1, tab2);
end

function SubImgCtrl:StopAnimation()
    
    local tab2 = { fun = FruitGameMain.handler(self,self.AnimationEnd) ; args = SubImgCtrl; }
    self.animTimer:SetTimer(E_TIME_NOT_LIMIT, false, FruitGameTimer.FruitTimerType.tick, 0, nil, tab2);
end

function SubImgCtrl:AnimationEnd()
    --logYellow("anim end name = " .. self.transform.name);
    self.gameObject:SetActive(false);
end