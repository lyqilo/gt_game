Module13_Caijin = {};

local self = Module13_Caijin;

self.currentCaijin = 0;
self.caijinCha = 0;
self.CaijinGold = 0;

self.timer = 5;
self.isCanSend = false;
function Module13_Caijin.Update()
    self.SendCaijin();
    if self.CaijinGold > 0 then
        self.currentCaijin = self.currentCaijin + math.ceil(Time.deltaTime * self.caijinCha*0.2);
        Module13Entry.MosaicNum.text = Module13Entry.ShowText(Module13Entry.FormatNumberThousands(self.currentCaijin));
    end
end
function Module13_Caijin.SendCaijin()
    self.timer = self.timer + Time.deltaTime;
    if self.timer >= Module13_DataConfig.REQCaiJinTime then
        self.timer = 0;
        self.REQCJ();
    end
end
function Module13_Caijin.REQCJ()
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_GF_GAME, Module13_Network.SUB_CS_JACKPOT, buffer, gameSocketNumber.GameSocket);
end