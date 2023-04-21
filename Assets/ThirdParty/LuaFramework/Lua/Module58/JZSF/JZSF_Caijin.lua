JZSF_Caijin = {};

local self = JZSF_Caijin;

self.currentCaijin = 0;
self.caijinCha = 0;
self.CaijinGold = 0;

self.timer = 5;
self.isCanSend = false;
function JZSF_Caijin.Update()
    self.SendCaijin();
    if self.CaijinGold > 0 then
        self.currentCaijin = self.currentCaijin + math.ceil(Time.deltaTime * self.caijinCha*0.2);
        JZSFEntry.MosaicNum.text = JZSFEntry.ShowText(JZSFEntry.FormatNumberThousands(self.currentCaijin));
    end
end
function JZSF_Caijin.SendCaijin()
    self.timer = self.timer + Time.deltaTime;
    if self.timer >= JZSF_DataConfig.REQCaiJinTime then
        self.timer = 0;
        self.REQCJ();
    end
end
function JZSF_Caijin.REQCJ()
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_GF_GAME, JZSF_Network.SUB_CS_JACKPOT, buffer, gameSocketNumber.GameSocket);
end