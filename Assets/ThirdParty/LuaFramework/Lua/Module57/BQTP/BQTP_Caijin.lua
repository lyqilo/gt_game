BQTP_Caijin = {};

local self = BQTP_Caijin;

self.currentCaijin = 0;
self.caijinCha = 0;
self.CaijinGold = 0;

self.timer = 0;
self.maxtimer = 0.1;
self.isCanSend = false;
self.isUpdate = false;
function BQTP_Caijin.Init()
    self.isCanSend = false;
    self.isUpdate = false;
    self.currentCaijin = 0;
    self.caijinCha = 0;
    self.CaijinGold = 0;
    self.timer = 0;
end
function BQTP_Caijin.Update()
    if self.CaijinGold > 0 then
        self.timer = self.timer - Time.deltaTime;
        if self.timer <= 0 then
            self.timer = self.maxtimer;
            self.currentCaijin = math.ceil(Mathf.LerpUnclamped(self.currentCaijin, self.CaijinGold, Time.deltaTime));
            BQTPEntry.MosaicNum.text = BQTPEntry.ShowText(self.currentCaijin);
        end
    end
end
function BQTP_Caijin.SendCaijin()
    self.timer = self.timer + Time.deltaTime;
    if self.timer >= BQTP_DataConfig.REQCaiJinTime then
        self.timer = 0;
        self.REQCJ();
    end
end
function BQTP_Caijin.REQCJ()
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_GF_GAME, BQTP_Network.SUB_CS_JACKPOT, buffer, gameSocketNumber.GameSocket);
end