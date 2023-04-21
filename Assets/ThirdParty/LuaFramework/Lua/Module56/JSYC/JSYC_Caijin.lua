JSYC_Caijin = {};

local self = JSYC_Caijin;

self.currentCaijin = 0;
self.caijinCha = 0;
self.CaijinGold = 0;

self.timer = 5;
self.isCanSend = false;
function JSYC_Caijin.Update()
    self.SendCaijin();
    if self.CaijinGold > 0 then
        self.currentCaijin = self.currentCaijin + math.ceil(Time.deltaTime * self.caijinCha*0.2);
        JSYCEntry.MosaicNum.text = JSYCEntry.ShowText(self.currentCaijin);
    end
end
function JSYC_Caijin.SendCaijin()
    self.timer = self.timer + Time.deltaTime;
    if self.timer >= JSYC_DataConfig.REQCaiJinTime then
        self.timer = 0;
        self.REQCJ();
    end
end
function JSYC_Caijin.REQCJ()
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_GF_GAME, JSYC_Network.SUB_CS_JACKPOT, buffer, gameSocketNumber.GameSocket);
end