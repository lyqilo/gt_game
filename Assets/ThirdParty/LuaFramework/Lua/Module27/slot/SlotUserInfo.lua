--SlotUserInfo.lua
--Date
--slot 玩家信息



--endregion

SlotUserInfo = {}

self = SlotUserInfo;

local C_ITEM_TOP_DISTANCE = 20; --单个元素距离顶部位置

local C_ITEM_MAI_COUNT = 6; --最少item个数

self.tabUserInfoList = {};



function  SlotUserInfo.Init(thisTra, luaBehaviour)
--	log("SlotUserInfo init 1");
--    self.transform = thisTra.transform;
--    self.iMoveDirection = 1; --列表运动方向

--    local BtnShowList = self.transform:Find("ButtonShowList");

--    luaBehaviour:AddClick(BtnShowList.gameObject, self.OnClickBtnUserInfo); --添加显示下注表按钮事件

--	log("SlotUserInfo init 2");


end


function SlotUserInfo.SetTabUserInfo(iDtatCount, buffer)

--    for i = 1 , iDtatCount do
--        local nameCount = buffer:ReadUInt16();
--        local tabUserInfoItem =
--        {
--            name = buffer:ReadString(nameCount);
--            gold = int64.tonum2(buffer:ReadInt64() );
--        };   
--        if(i <= #self.tabUserInfoList) then
--            self.tabUserInfoList[i] = tabUserInfoItem;
--        else
--            table.insert(self.tabUserInfoList, tabUserInfoItem);
--        end
--        --log("name " .. tabUserInfoItem.name .. "  gold  " .. tabUserInfoItem.gold);
--    end

    -------------删除多余元素-----------

--    if(#self.tabUserInfoList <= iDtatCount) then return; end

--    for i = iDtatCount+1, #self.tabUserInfoList do
--        table.remove(self.tabUserInfoList, i);
--    end

end



--改变显示信息物体
function SlotUserInfo.ChangeTraInfoList(tabInfoList)
    
--    if(not tabInfoList) then return; end;


--    local traUserInfoList = self.transform:Find("PanelUserInfo/PanelUserInfoList");

--    local iItemCount = #tabInfoList - traUserInfoList.childCount; --新增item个数


--    if(0 == iItemCount)then self.SetUserInfo(tabInfoList, traUserInfoList); return; end --没有变化


--    local traItem = traUserInfoList:GetChild(0);

--    local fItemHight = traItem:GetComponent('RectTransform').sizeDelta.y; --单个元素高度

--    local iAddCount = 0;

--    if(iItemCount > 0) then
--        for i = 1, iItemCount do
--            local obj = newobject(traItem);
--            obj.transform:SetParent(traItem.parent);
--            obj.name = "ImageUserInfoItem" .. i;
--            obj.transform.localScale = Vector3.one;
--            obj.transform.localPosition = Vector3.New(0, 0, 0);
--        end
--        if(#tabInfoList > C_ITEM_MAI_COUNT) then
--            iAddCount = #tabInfoList - C_ITEM_MAI_COUNT;
--        end
--    else
--        C_ITEM_TOP_DISTANCE = C_ITEM_TOP_DISTANCE * -1;
--        if(#tabInfoList > C_ITEM_MAI_COUNT) then
--            iAddCount = iItemCount;
--        elseif(traUserInfoList.childCount > C_ITEM_MAI_COUNT) then
--            iAddCount = (traUserInfoList.childCount - C_ITEM_MAI_COUNT) * -1;
--        end
--        for i = traUserInfoList.childCount - 1, traUserInfoList.childCount + iItemCount, -1 do
--            destroy(traUserInfoList:GetChild(i).gameObject);
--        end
--    end

--    --log("count is " .. iAddCount);
--    local comRectTar = traUserInfoList.transform:GetComponent('RectTransform'); 
--    comRectTar.sizeDelta = Vector2.New(comRectTar.sizeDelta.x, comRectTar.sizeDelta.y + (fItemHight * iAddCount + C_ITEM_TOP_DISTANCE)  );
--    traUserInfoList.transform.localPosition = Vector3.New(traUserInfoList.transform.localPosition.x, 
--                                                            traUserInfoList.transform.localPosition.y - (fItemHight * iAddCount) / 2, 
--                                                            traUserInfoList.transform.localPosition.z);

--    self.SetUserInfo(tabInfoList, traUserInfoList);
 
end


function SlotUserInfo.SetUserInfo(tabInfoList, traUserInfoList)
    
--    for i = 1, #tabInfoList do
--        if(i - 1 < traUserInfoList.childCount) then
--            local traInfoItem = traUserInfoList.transform:GetChild(i - 1);
--            traInfoItem:Find("TextName"):GetComponent('Text').text = tabInfoList[i].name;
--            traInfoItem:Find("TextGold"):GetComponent('Text').text = tabInfoList[i].gold .. "";
--        end
--    end

end



function SlotUserInfo.MoveToPos(iDirection)
        
--    local traUserInfo = self.transform:Find("PanelUserInfo");
--    local traBtn = self.transform:Find("ButtonShowList");
--    local fDistance = traBtn.transform:GetComponent('RectTransform').sizeDelta.x;
--    local fEndPosX = traUserInfo.transform.localPosition.x + (fDistance * iDirection);
--    local dotween = traUserInfo.transform:DOLocalMoveX(fEndPosX, 0.1, false);
--    dotween:SetEase(DG.Tweening.Ease.Linear);

--    dotween:OnComplete(function() 
--                            fDistance = self.transform:GetComponent('RectTransform').sizeDelta.x - fDistance;
--                            fEndPosX = self.transform.localPosition.x + (fDistance * iDirection);
--                            self.transform:DOLocalMoveX(fEndPosX, 0.5, false);  
--                        end);

end


function SlotUserInfo.OnClickBtnUserInfo(btn)
    
--    if(self.iMoveDirection > 0) then
--        local tabVar = self.TableCopy(self.tabUserInfoList);
--        SlotUserInfo.ChangeTraInfoList(tabVar);
--    else
--        --table.remove(self.tabUserInfoList, #self.tabUserInfoList); --测试
--    end

--    self.MoveToPos(self.iMoveDirection);
--    self.iMoveDirection = self.iMoveDirection * -1;

end


function SlotUserInfo.TableCopy(tabUserInfoList)
    
--    if(not tabUserInfoList) then return nil; end

--    local tabVar = {};
--    for i = 1, #tabUserInfoList do
--        local tabUserInfoItem =
--        {
--            name = tabUserInfoList[i].name;
--            gold = tabUserInfoList[i].gold;
--        };
--        table.insert(tabVar, tabUserInfoItem);
--    end
--    return tabVar;

end
