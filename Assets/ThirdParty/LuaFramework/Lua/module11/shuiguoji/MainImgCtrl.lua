--MainImgCtrl.lua
--Date
--水果机主图片控制

--endregion

MainImgCtrl = {};

local D_TIME_NOT_LIMIT = 600;
local D_TIME_TICK_ANIM = 0.2; --动画间隔时间

function MainImgCtrl:New(o)
    local t = o or { };
    setmetatable(t, self);
    self.__index = self
    return t;
end

function MainImgCtrl.Init(tra, iMainGrid)
    self = MainImgCtrl:New();
    self.transform = tra;
    self.gameObject = tra.gameObject;
    if(FruitResource.strTraLuckName1 == self.transform.name or FruitResource.strTraLuckName2 == self.transform.name) then
        self.bLucky = true;
        self.animLuck = nil; --self.transform:Find("LuckAnim");
    end
    self.iMainGrid = iMainGrid;
    self.animTimer = FruitGameTimer:New();
    return self;
end


function MainImgCtrl:Update()
    if(self.animTimer) then self.animTimer:timer(Time.deltaTime) end
end


function MainImgCtrl:ShowImage(bShow, bLight)
    if(self.bLight) then bShow = true; end
    self.gameObject:SetActive(bShow);
end

--设置送灯状态
function MainImgCtrl:SetIsGiveLight(bLight)
    self.bLight = bLight;
end

function MainImgCtrl:PlayLuckAnim(args)

end

function MainImgCtrl:PlayAnimation(iTime, bNotPlayMusic)
    
    iTime = iTime or D_TIME_NOT_LIMIT;

    local traLuckAnim = nil;
    if(self.animLuck) then
        self.bLight = true;
        self.gameObject:SetActive(true);
        self.animLuck.gameObject:SetActive(true);
        traLuckAnim = self.animLuck:GetChild(0);
    end

    if(self.iMainGrid and not bNotPlayMusic) then
        local id = FruitData.C_MAIN_IMGS[self.iMainGrid + 1];
        FruitGameMain.PlayMusic(FruitResource.strWinAwardVoice, id);
    end

    local funTIck = function ()
                        if(traLuckAnim) then
                            traLuckAnim.gameObject:SetActive(not traLuckAnim.gameObject.activeSelf);
                        else
                            self.gameObject:SetActive(not self.gameObject.activeSelf);
                        end
                    end

    local tab1 = { fun = funTIck; args = MainImgCtrl; }
    local tab2 = { fun = FruitGameMain.handler(self,self.AnimationEnd) ; args = MainImgCtrl; }
    self.animTimer:SetTimer(iTime, true, FruitGameTimer.FruitTimerType.tick, D_TIME_TICK_ANIM, tab1, tab2);
    
end

function MainImgCtrl:StopAnimation()
    
    local tab2 = { fun = FruitGameMain.handler(self,self.AnimationEnd) ; args = MainImgCtrl; }
    self.animTimer:SetTimer(D_TIME_NOT_LIMIT, false, FruitGameTimer.FruitTimerType.tick, 0, nil, tab2);
end

function MainImgCtrl:AnimationEnd()
    --logYellow("anim end name = " .. self.transform.name);
    self.gameObject:SetActive(false);
    if(self.animLuck) then
        self.animLuck.gameObject:SetActive(false);
    end
    self.bLight = false;
end