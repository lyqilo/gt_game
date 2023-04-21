JPM_Caijin = {};

local self = JPM_Caijin;

self.currentCaijin = 0;
self.caijinCha = 0;
self.CaijinGold = 0;

self.timer = 5;
self.isCanSend = false;
function JPM_Caijin.Update()
    self.SendCaijin();
    if self.CaijinGold > 0 then
        self.currentCaijin = self.currentCaijin + math.ceil(Time.deltaTime * self.caijinCha*0.2);
        JPMEntry.MosaicNum.text = JPMEntry.ShowText(JPMEntry.FormatNumberThousands(self.currentCaijin));
    end
end
function JPM_Caijin.SendCaijin()
    self.timer = self.timer + Time.deltaTime;
    if self.timer >= JPM_DataConfig.REQCaiJinTime then
        self.timer = 0;
        self.REQCJ();
    end
end
function JPM_Caijin.REQCJ()
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_GF_GAME, JPM_Network.SUB_CS_JACKPOT, buffer, gameSocketNumber.GameSocket);
end