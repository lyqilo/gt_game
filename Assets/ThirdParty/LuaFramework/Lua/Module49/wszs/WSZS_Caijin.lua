WSZS_Caijin = {};

local self = WSZS_Caijin;

self.currentCaijin = 0;
self.caijinCha = 0;
self.CaijinGold = 0;

self.timer = 5;
self.isCanSend = false;
function WSZS_Caijin.Update()
    self.SendCaijin();
    if self.CaijinGold > 0 then
        self.currentCaijin = self.currentCaijin + math.ceil(Time.deltaTime * self.caijinCha*0.2);
        WSZSEntry.MosaicNum.text = WSZSEntry.ShowText(ShortNumber(self.currentCaijin));
    end
end
function WSZS_Caijin.SendCaijin()
    self.timer = self.timer + Time.deltaTime;
    if self.timer >= WSZS_DataConfig.REQCaiJinTime then
        self.timer = 0;
        self.REQCJ();
    end
end
function WSZS_Caijin.REQCJ()
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_GF_GAME, WSZS_Network.SUB_CS_JACKPOT, buffer, gameSocketNumber.GameSocket);
end