--SlotExplainCtrl.lua
--slot 说明面板类
--

--endregion

SlotExplainCtrl = {}

local self = SlotExplainCtrl;

--local luaBehaviour;

local transform;

local traExplains;


function SlotExplainCtrl.Init(obj, luaBehaviour)
    
    transform = obj.transform;

    traExplains = obj.transform:Find("ImageExplainBottom/Explains");
    
    local traBtnBackGame = obj.transform:Find("ImageExplainBottom/Buttons/ButtonBackGame");
    luaBehaviour:AddClick(traBtnBackGame.gameObject, self.OnClickBackGameBtn); 
    local trnBtnGoRight = obj.transform:Find("ImageExplainBottom/Buttons/ButtonGoRight");
    luaBehaviour:AddClick(trnBtnGoRight.gameObject, self.OnClickChangeSiblingIndex); 
    local trnBtnGoLeft= obj.transform:Find("ImageExplainBottom/Buttons/ButtonGoLeft");
    luaBehaviour:AddClick(trnBtnGoLeft.gameObject, self.OnClickChangeSiblingIndex); 

end


function SlotExplainCtrl.ShowExplain(bShow)
    transform.gameObject:SetActive(bShow);
end


function SlotExplainCtrl.OnClickBackGameBtn(prefab)
    self.ShowExplain(false);        
end


--改变层级
function SlotExplainCtrl.OnClickChangeSiblingIndex(prefab)
    
    if("ButtonGoRight" == prefab.name) then --右
        traExplains:GetChild(traExplains.childCount - 2).gameObject:SetActive(true); --显示下一个

        local tempTra = traExplains:GetChild(traExplains.childCount - 1);
        tempTra.gameObject:SetActive(false); --隐藏当前
        tempTra:SetSiblingIndex(0);

    else --左
        traExplains:GetChild(traExplains.childCount - 1).gameObject:SetActive(false); --隐藏当前

        local tempTra = traExplains:GetChild(0);
        tempTra.gameObject:SetActive(true); --显示下一个
        tempTra:SetSiblingIndex(traExplains.childCount - 1);
    end

end

