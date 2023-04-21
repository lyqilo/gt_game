FXGZ_Caijin = {};

local self = FXGZ_Caijin;

self.currentCaijin = 0;
self.caijinCha = 0;
self.CaijinGold = 0;

self.timer = 0;
self.maxtimer = 0.01;
self.isCanSend = false;
self.isUpdate = false;
function FXGZ_Caijin.Update()
    if self.CaijinGold > 0 then
        self.timer = self.timer - Time.deltaTime;
        if self.timer <= 0 then
            self.timer = self.maxtimer;
            self.currentCaijin = math.ceil(Mathf.LerpUnclamped(self.currentCaijin, self.CaijinGold, Time.deltaTime));
            FXGZEntry.MosaicNum.text = ShortNumber(self.currentCaijin);
        end
    end
end
function FXGZ_Caijin.SendCaijin()
    self.timer = self.timer + Time.deltaTime;
    if self.timer >= FXGZ_DataConfig.REQCaiJinTime then
        self.timer = 0;
        self.REQCJ();
    end
end
function FXGZ_Caijin.REQCJ()
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_GF_GAME, FXGZ_Network.SUB_CS_JACKPOT, buffer, gameSocketNumber.GameSocket);
end