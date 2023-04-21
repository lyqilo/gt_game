--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local Card = {}
local self = Card
self.ResManager = nil
self.CardStr = {""}

--花色;  0  方块      1 梅花       2  红桃          3   黑桃

function Card:Init(resmanager)
    self.ResManager = resmanager
    self.HuaSe = nil
    self.Point = nil
    self.num = nil
    self.transform = newObject(self.ResManager.GetPrefabByName("Card")).transform
    self:ShowCardVal(80)
end

function Card:SetCardVal(data)
     if(data < 78) then
         self.HuaSe = math.floor(data / 16)
         self.Point = data % 16
     end
     self.num = data
end

function Card:ShowCardVal(val)
    if(val ~= nil)then
         if(self.num ~= nil and self.num < 78) then
             self.HuaSe = math.floor(val / 16)
             self.Point = val % 16
        end
        self.num = val
    end

    if(self.num == 78)then
        self.transform:GetComponent("Image").sprite = self.ResManager.GetSpriteByName("Card_XiaoWang").sprite
    elseif(self.num == 79)then
        self.transform:GetComponent("Image").sprite = self.ResManager.GetSpriteByName("Card_DaWang").sprite
    elseif(self.num == 80)then
        self.transform:GetComponent("Image").sprite = self.ResManager.GetSpriteByName("Card_Bei").sprite
    else
        if(self.HuaSe == 0)then
            self.transform:GetComponent("Image").sprite = self.ResManager.GetSpriteByName(("Card_F_"..tostring(self.Point))).sprite
        elseif(self.HuaSe == 1)then
            self.transform:GetComponent("Image").sprite = self.ResManager.GetSpriteByName(("Card_M_"..tostring(self.Point))).sprite
        elseif(self.HuaSe == 2)then
            self.transform:GetComponent("Image").sprite = self.ResManager.GetSpriteByName(("Card_H_"..tostring(self.Point))).sprite
        elseif(self.HuaSe == 3)then
            self.transform:GetComponent("Image").sprite = self.ResManager.GetSpriteByName(("Card_HT_"..tostring(self.Point))).sprite
        else
            logError("HuaSe error: "..tostring(self.HuaSe))
        end
    end
    self.transform:GetComponent("Image"):SetNativeSize()
end

return Card


--endregion
