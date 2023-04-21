TGG_Caijin = {};

local self = TGG_Caijin;

self.currentCaijin = 0;
self.caijinCha = 0;
self.CaijinGold = 0;

self.timer = 5;
self.isCanSend = false;
function TGG_Caijin.Update()
    self.SendCaijin();
    if self.CaijinGold > 0 then
        self.currentCaijin = self.currentCaijin + math.ceil(Time.deltaTime * self.caijinCha*0.2);
        TGGEntry.MosaicNum.text = TGGEntry.ShowText(TGGEntry.FormatNumberThousands(self.currentCaijin));
    end
end
function TGG_Caijin.SendCaijin()
    self.timer = self.timer + Time.deltaTime;
    if self.timer >= TGG_DataConfig.REQCaiJinTime then
        self.timer = 0;
        self.REQCJ();
    end
end
function TGG_Caijin.REQCJ()
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_GF_GAME, TGG_Network.SUB_CS_JACKPOT, buffer, gameSocketNumber.GameSocket);
end