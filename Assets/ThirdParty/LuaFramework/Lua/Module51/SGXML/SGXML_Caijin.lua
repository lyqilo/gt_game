SGXML_Caijin = {};

local self = SGXML_Caijin;

self.currentCaijin = 0;
self.caijinCha = 0;
self.CaijinGold = 0;

self.timer = 0;
self.maxtimer = 0.1;
self.isCanSend = false;
self.isUpdate = false;
function SGXML_Caijin.Init()
    self.isCanSend = false;
    self.isUpdate = false;
    self.currentCaijin = 0;
    self.caijinCha = 0;
    self.CaijinGold = 0;
    self.timer = 0;
end
function SGXML_Caijin.Update()
    if self.CaijinGold > 0 then
        self.timer = self.timer - Time.deltaTime;
        if self.timer <= 0 then
            self.timer = self.maxtimer;
            self.currentCaijin = math.ceil(Mathf.LerpUnclamped(self.currentCaijin, self.CaijinGold, Time.deltaTime));
            SGXMLEntry.MosaicNum.text = SGXMLEntry.ShowText(self.currentCaijin);
        end
    end
end
function SGXML_Caijin.SendCaijin()
    self.timer = self.timer + Time.deltaTime;
    if self.timer >= SGXML_DataConfig.REQCaiJinTime then
        self.timer = 0;
        self.REQCJ();
    end
end
function SGXML_Caijin.REQCJ()
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_GF_GAME, SGXML_Network.SUB_CS_JACKPOT, buffer, gameSocketNumber.GameSocket);
end