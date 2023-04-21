XMZZ_Caijin = {};

local self = XMZZ_Caijin;

self.currentCaijin = 0;
self.caijinCha = 0;
self.CaijinGold = 0;

self.timer = 0;
self.maxtimer = 0.1;
self.isCanSend = false;
self.isUpdate = false;
function XMZZ_Caijin.Init()
    self.isCanSend = false;
    self.isUpdate = false;
    self.currentCaijin = 0;
    self.caijinCha = 0;
    self.CaijinGold = 0;
    self.timer = 0;
end
function XMZZ_Caijin.Update()
    if self.CaijinGold > 0 then
        self.timer = self.timer - Time.deltaTime;
        if self.timer <= 0 then
            self.timer = self.maxtimer;
            self.currentCaijin = math.ceil(Mathf.LerpUnclamped(self.currentCaijin, self.CaijinGold, Time.deltaTime));
            XMZZEntry.JackpotNum.text = XMZZEntry.ShowText(self.currentCaijin);
        end
    end
end