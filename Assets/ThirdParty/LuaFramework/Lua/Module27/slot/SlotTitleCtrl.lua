--SlotTitleCtrl *.lua
--Date
--slot 提示控制

--endregion


SlotTitleCtrl = {}

self = SlotTitleCtrl;


function SlotTitleCtrl.ShowTitle(traSlotBase, str)
	
     --SlotTitleCtrl.Init(traSlotBase);
     --SlotTitleCtrl.SetTitleStr(str);

end 

function SlotTitleCtrl.Init(traSlotBase)

    --加载数字图片资源
    local TitleImageRes = LoadAsset(SlotResourcesName.dbResNameStr, 'TitleImage'); 

    local obj = newobject(TitleImageRes);
    obj.transform:SetParent(traSlotBase);
    obj.name = "TitleImage";
    obj.transform.localScale = Vector3.one;
    obj.transform.localPosition = Vector3.New(0, 0, 0);
    --obj:SetActive(true);

    self.transform = obj.transform;

    local luaBehaviour = traSlotBase.transform:GetComponent('LuaBehaviour');

    local traOkBtn = self.transform:Find("Buttons/ButtonOk");

    luaBehaviour:AddClick(traOkBtn.gameObject, self.OnClickOkBtn); --添加下注按钮响应事件

end

function SlotTitleCtrl.SetTitleStr(str)
    local traText = self.transform:Find("TextContent");
    traText:GetComponent('Text').text = str;
end


function SlotTitleCtrl.OnClickOkBtn(traButton)
    destroy(self.transform.gameObject);
end