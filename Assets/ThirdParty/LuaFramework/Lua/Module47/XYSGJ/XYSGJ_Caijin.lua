XYSGJ_Caijin = {};

local self = XYSGJ_Caijin;

self.currentCaijin1 = 0;
self.currentCaijin2 = 0;
self.currentCaijin3 = 0;

self.caijinCha = 0;
self.CaijinGold = 0;

self.timer = 0;
self.maxtimer = 0.1;
self.isCanSend = false;
self.isUpdate = false;
function XYSGJ_Caijin.Update()
    if self.CaijinGold > 0 then
        self.timer = self.timer - Time.deltaTime;
        if self.timer <= 0 then
            self.timer = self.maxtimer;
            self.currentCaijin1 = math.ceil(Mathf.LerpUnclamped(self.currentCaijin1, self.CaijinGold, Time.deltaTime));
            XYSGJEntry.JACKPOTNum.text = XYSGJEntry.ShowText(self.currentCaijin1);

            XYSGJEntry.caiJinPanel_3.text=XYSGJEntry.ShowText(self.currentCaijin1);

            self.currentCaijin2 = math.ceil(Mathf.LerpUnclamped(self.currentCaijin1*12, self.CaijinGold*12, Time.deltaTime));
            XYSGJEntry.caiJinPanel_2.text=XYSGJEntry.ShowText(self.currentCaijin2);

            self.currentCaijin3 = math.ceil(Mathf.LerpUnclamped(self.currentCaijin1*39, self.CaijinGold*39, Time.deltaTime));
            XYSGJEntry.caiJinPanel_1.text=XYSGJEntry.ShowText(self.currentCaijin3);

        end
    end
end
function XYSGJ_Caijin.SendCaijin()
    self.timer = self.timer + Time.deltaTime;
    if self.timer >= XYSGJ_DataConfig.REQCaiJinTime then
        self.timer = 0;
        self.REQCJ();
    end
end
function XYSGJ_Caijin.REQCJ()
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_GF_GAME, SGXML_Network.SUB_CS_JACKPOT, buffer, gameSocketNumber.GameSocket);
end