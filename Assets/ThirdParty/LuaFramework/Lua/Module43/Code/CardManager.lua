--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local CardManager = {}
local self = CardManager
self.CardList = {{}, {}, {}, {}, {}} --天地玄黄庄
self.dealyRun = nil
self.class = nil
self.Card = nil
self.Resmanager = nil
self.Data71 = nil
self.Mine = nil

function CardManager.Init(Delayrun, classA, Card, Resmanager, gamedata71, mine)
    self.transform = GameObject.Find("bg/bg1/Info/CardPoint").transform
    self.CardTypePar = GameObject.Find("bg/bg1/Info/CardType").transform
    self.WinArea = GameObject.Find("bg/bg1/Info/WinArea").transform
    self.dealyRun = Delayrun
    self.class = classA
    self.Card = Card
    self.Resmanager = Resmanager
    self.Data71 = gamedata71
    self.Mine = mine
end

local function SetAllCardData()
    for k, v in pairs(self.Data71.CardList)do
        if(v ~= nil)then
             for k1, v1 in pairs(v)do
                 if(v1 ~= nil)then
                    if(self.CardList[k][k1] == nil) then
                        logError("self.CardList[k][k1] is nil")
                    end
                    self.CardList[k][k1]:SetCardVal(v1)
                 else
                    logError("nil-----")
                 end
             end
        else
            logError("nil--")
        end
    end
end

local function FlodCardMove(CardObj, parObj, index)
    CardObj.transform:SetParent(self.transform, false)
    CardObj.transform.localScale = Vector3.New(0.3, 0.3, 1)
    CardObj.transform.localRotation = Quaternion.Euler(0, 0, -30);
    CardObj.transform.localPosition = self.transform:Find("Flod_CardPoint").localPosition
    local v3 = parObj.localPosition
    local jianju = 25
    CardObj.transform:DOScale(1, 0.4)
    CardObj.transform:DOLocalRotate(Vector3.New(0, 0, 0), 0.4)
    CardObj.transform:DOLocalMove(v3, 0.4):OnComplete(function()
        CardObj.transform:DOLocalMove(Vector3.New(v3.x - jianju * ( 3 - index), v3.y, 0), 0.4):OnComplete(function()
            CardObj.transform:SetParent(parObj, true)
        end)
    end)
end

local function FlodTian()
    Game71Panel.playShortMusic("sendcard")
    for i = 1, 5 do
        local j = i 
        self.dealyRun.AddDelay(i * 0.05, function() 
            if( self.CardList[1][i]~=nil)then
                self.CardList[1][i].transform.gameObject:SetActive(true)
                self.CardList[1][i]:ShowCardVal(80)
            else
                self.CardList[1][i] = class_a("Card", self.Card)
                self.CardList[1][i]:Init(self.Resmanager)
            end
            FlodCardMove(self.CardList[1][j],  self.transform:Find("Tian_CardPoint"), j)
        end)
    end
end

local function FlodDi()
    Game71Panel.playShortMusic("sendcard")
    for i = 1, 5 do
        local j = i 
        self.dealyRun.AddDelay(i * 0.05, function() 
            if( self.CardList[2][i]~=nil)then
                self.CardList[2][i].transform.gameObject:SetActive(true)
                self.CardList[2][i]:ShowCardVal(80)
            else
                self.CardList[2][i] = class_a("Card", self.Card)
                self.CardList[2][i]:Init(self.Resmanager)
            end
            FlodCardMove(self.CardList[2][j],  self.transform:Find("Di_CardPoint"), j)
        end)
    end
end

local function FlodXuan()
    Game71Panel.playShortMusic("sendcard")
    for i = 1, 5 do
        local j = i 
        self.dealyRun.AddDelay(i * 0.05, function() 
            if( self.CardList[3][i]~=nil)then
                self.CardList[3][i].transform.gameObject:SetActive(true)
                self.CardList[3][i]:ShowCardVal(80)
            else
                self.CardList[3][i] = class_a("Card", self.Card)
                self.CardList[3][i]:Init(self.Resmanager)
            end
            FlodCardMove(self.CardList[3][j],  self.transform:Find("Xuan_CardPoint"), j)
        end)
    end
end

local function FlodHuang()
    Game71Panel.playShortMusic("sendcard")
    for i = 1, 5 do
        local j = i 
        self.dealyRun.AddDelay(i * 0.05, function() 
            if( self.CardList[4][i]~=nil)then
                self.CardList[4][i].transform.gameObject:SetActive(true)
                self.CardList[4][i]:ShowCardVal(80)
            else
                self.CardList[4][i] = class_a("Card", self.Card)
                self.CardList[4][i]:Init(self.Resmanager)
            end
            FlodCardMove(self.CardList[4][j],  self.transform:Find("Huang_CardPoint"), j)
        end)
    end
end

local function FlodBanker()
    for i = 1, 5 do
        local j = i 
        self.dealyRun.AddDelay(i * 0.05, function() 
            if( self.CardList[5][i]~=nil)then
                self.CardList[5][i].transform.gameObject:SetActive(true)
                self.CardList[5][i]:ShowCardVal(80)
            else
                self.CardList[5][i] = class_a("Card", self.Card)
                self.CardList[5][i]:Init(self.Resmanager)
            end
            FlodCardMove(self.CardList[5][j],  self.transform:Find("Bank_CardPoint"), j)
        end, nil, nil)
    end
end

function CardManager.FlodCard()
    FlodTian()
    self.dealyRun.AddDelay(0.4, function()  FlodDi() end, nil, nil)
    self.dealyRun.AddDelay(0.8, function()  FlodXuan() end, nil, nil)
    self.dealyRun.AddDelay(1.2, function()  FlodHuang() end, nil, nil)
    self.dealyRun.AddDelay(1.6, function()  FlodBanker() end, nil, nil)
    self.dealyRun.AddDelay(2.2, function()  SetAllCardData() end, nil, nil) 
    self.dealyRun.AddDelay(2.6, function()  self.FanPai() end, nil, nil)
end



function CardManager.HideAllCard()
    for k, v in pairs(self.CardList)do
        if(v~= nil) then
            for k1, v1 in pairs(v)do
                if(v1 ~= nil)then
                    v1.transform.gameObject:SetActive(false)
                end
            end
        end
    end

    for i = 0, self.WinArea.childCount - 1 do
        self.WinArea:GetChild(i).gameObject:SetActive(false)
    end

end

local function FanPaiOver(index)
    local str = "Niu"..tostring(self.Data71.CardType[index])
    self.Resmanager.AddEffect(self.CardTypePar:GetChild(index - 1).gameObject.transform, str, Vector3.New(0, 0, 0), true)
    local nnk = self.Data71.CardType[index]
    if(nnk > 10)then
        nnk = 10
    end
    if(math.random(1, 10) > 5)then
        Game71Panel.playShortMusic("F_OX_"..tostring(nnk))
    else
        Game71Panel.playShortMusic("M_OX_"..tostring(nnk))
    end
    local v3 = self.CardList[index][4].transform.localPosition
    local v4 = self.CardList[index][5].transform.localPosition
    if(self.Data71.CardType[index] ~= 0)then
        self.CardList[index][4].transform:DOLocalMove(Vector3.New(v3.x + 15, v3.y, 0), 0.3)
        self.CardList[index][5].transform:DOLocalMove(Vector3.New(v4.x + 15, v4.y, 0), 0.3)
    end
end


local function FanPai(index)
    Game71Panel.playShortMusic("sound-fanpai") 
    for k, v in pairs(self.CardList[index])do
        if(v ~= nil)then
            v.transform:DOLocalRotate(Vector3.New(0, 90, 0), 0.4):OnComplete(function()
                v:ShowCardVal(nil)
                v.transform:DOLocalRotate(Vector3.New(0, 0, 0), 0.4)
            end)
        else
            logError("要翻的牌不存在")
        end
    end
    self.dealyRun.AddDelay(0.81, function() FanPaiOver(index) end, nil, nil)
end

function CardManager.ShowWinArea()
    for k, v in pairs(self.Data71.AreaWin)do
        if(v == 0)then
            self.WinArea:GetChild(k - 1).transform.gameObject:SetActive(true)
            self.Resmanager.AddEffect(self.WinArea:GetChild(k - 1).transform, "Win_Effect", Vector3.New(0, 0, 0), true)
        end
    end
end

function CardManager.FanPai()
     FanPai(1)
     self.dealyRun.AddDelay(0.8, function()  FanPai(2) end, nil, nil)
     self.dealyRun.AddDelay(1.6, function()  FanPai(3) end, nil, nil)
     self.dealyRun.AddDelay(2.4, function()  FanPai(4) end, nil, nil)
     self.dealyRun.AddDelay(3, function()  FanPai(5) end, nil, nil)
end


function CardManager.Dispose()
    self.CardList = {{}, {}, {}, {}, {}} --天地玄黄庄
    self.dealyRun = nil
    self.class = nil
    self.Card = nil
    self.Resmanager = nil
    self.Data71 = nil
    self.Mine = nil
end

return CardManager


--endregion
