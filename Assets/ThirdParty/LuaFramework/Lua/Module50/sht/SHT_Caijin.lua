SHT_Caijin = {};

local self = SHT_Caijin;

self.currentCaijin = 0;
self.caijinCha = 0;
self.CaijinGold = 0;

self.timer = 5;
self.isCanSend = false;

self.jackotTable={
    10,
    30,
    80,
    150,
    500,
}

function SHT_Caijin.Init(obj)
    
    self.caiJin_1=obj.transform:Find("NormalReward_PoolTitle5/NormalReward_PoolBg5/NormalReward_PoolNum5"):GetComponent("TextMeshProUGUI")
    self.caiJin_2=obj.transform:Find("NormalReward_PoolTitle6/NormalReward_PoolBg6/NormalReward_PoolNum6"):GetComponent("TextMeshProUGUI")
    self.caiJin_3=obj.transform:Find("NormalReward_PoolTitle7/NormalReward_PoolBg7/NormalReward_PoolNum7"):GetComponent("TextMeshProUGUI")
    self.caiJin_4=obj.transform:Find("NormalReward_PoolTitle8/NormalReward_PoolBg8/NormalReward_PoolNum8"):GetComponent("TextMeshProUGUI")
    self.caiJin_5=obj.transform:Find("NormalReward_PoolTitle9/NormalReward_PoolBg9/NormalReward_PoolNum9"):GetComponent("TextMeshProUGUI")

end

function SHT_Caijin.Update()
    self.SendCaijin();
    if self.CaijinGold > 0 then
        self.currentCaijin = self.currentCaijin + math.ceil(Time.deltaTime * self.caijinCha*0.2);
        SHTEntry.MosaicNum.text = SHTEntry.ShowText(self.currentCaijin);
    end
end
function SHT_Caijin.SendCaijin()
    self.timer = self.timer + Time.deltaTime;
    if self.timer >= SHT_DataConfig.REQCaiJinTime then
        self.timer = 0;
        self.REQCJ();
    end
end
function SHT_Caijin.REQCJ()
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_GF_GAME, SHT_Network.SUB_CS_JACKPOT, buffer, gameSocketNumber.GameSocket);
end


function SHT_Caijin:SetCAIJIN(gold)
    logYellow("gold=="..gold)



    self.caiJin_1.text= SHTEntry.ShowText(math.floor(self.jackotTable[1]*SHTEntry.CurrentChip * SHT_DataConfig.ALLLINECOUNT + gold* SHTEntry.SceneData.BS[1]/SHTEntry.SceneData.BS[1]))
    self.caiJin_2.text= SHTEntry.ShowText(math.floor(self.jackotTable[2]*SHTEntry.CurrentChip * SHT_DataConfig.ALLLINECOUNT + gold* SHTEntry.SceneData.BS[2]/SHTEntry.SceneData.BS[1]))
    self.caiJin_3.text= SHTEntry.ShowText(math.floor(self.jackotTable[3]*SHTEntry.CurrentChip * SHT_DataConfig.ALLLINECOUNT + gold* SHTEntry.SceneData.BS[3]/SHTEntry.SceneData.BS[1]))
    self.caiJin_4.text= SHTEntry.ShowText(math.floor(self.jackotTable[4]*SHTEntry.CurrentChip * SHT_DataConfig.ALLLINECOUNT + gold* SHTEntry.SceneData.BS[4]/SHTEntry.SceneData.BS[1]))
    self.caiJin_5.text= SHTEntry.ShowText(math.floor(self.jackotTable[5]*SHTEntry.CurrentChip * SHT_DataConfig.ALLLINECOUNT + gold* SHTEntry.SceneData.BS[5]/SHTEntry.SceneData.BS[1]))
end
