LGDDY_Caijin = {};

local self = LGDDY_Caijin;

self.currentCaijin = 0;
self.caijinCha = 0;
self.CaijinGold = 0;

self.timer = 0;
self.maxtimer = 0.1;
self.isCanSend = false;
self.isUpdate = false;
function LGDDY_Caijin.Init()
    self.isCanSend = false;
    self.isUpdate = false;
    self.currentCaijin = 0;
    self.caijinCha = 0;
    self.CaijinGold = 0;
    self.timer = 0;
end
function LGDDY_Caijin.Update()
    if self.CaijinGold > 0 then
        self.timer = self.timer - Time.deltaTime;
        if self.timer <= 0 then
            self.timer = self.maxtimer;
            self.currentCaijin = math.ceil(Mathf.LerpUnclamped(self.currentCaijin, self.CaijinGold, Time.deltaTime));
            LGDDYEntry.MosaicNum.text = LGDDYEntry.ShowText(self.currentCaijin);
        end
    end
end
function LGDDY_Caijin.SendCaijin()
    self.timer = self.timer + Time.deltaTime;
    if self.timer >= LGDDY_DataConfig.REQCaiJinTime then
        self.timer = 0;
        self.REQCJ();
    end
end
function LGDDY_Caijin.REQCJ()
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_GF_GAME, LGDDY_Network.SUB_CS_JACKPOT, buffer, gameSocketNumber.GameSocket);
end