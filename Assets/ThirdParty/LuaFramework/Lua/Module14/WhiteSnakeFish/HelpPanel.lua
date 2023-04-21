local _CHelpPanel = class("_CHelpPanel");

--创建帮助界面
function _CHelpPanel.Create(_parent)
    return _CHelpPanel.New(_parent);
end

--
function _CHelpPanel:ctor(_parent)

    self.gameObject = G_GlobalGame._goFactory:createHelpPanel();
    self.transform  = self.gameObject.transform;
    self.transform:SetParent(_parent);
    self.transform.localPosition= Vector3.zero;
    self.transform.localScale   = Vector3.one;

    local eventTrigger;
    local closeBtn  = self.transform:Find("CloseBtn");
    eventTrigger = Util.AddComponent("EventTriggerListener",closeBtn.gameObject);
    eventTrigger.onClick = handler(self,self._onCloseClick);
    self.closeBtn = closeBtn;


    self.createTimer = 0;

--    local mask  = self.transform:Find("Mask");
--    eventTrigger = Util.AddComponent("EventTriggerListener",mask.gameObject);
--    eventTrigger.onClick = handler(self,self._onRightClick);
--    self.mask = mask;
    local TopTip  = self.transform:Find("TopTip");
    local BottomTip  = self.transform:Find("BottomTip");
    local alignView;
    
    if TopTip then
        alignView = TopTip.gameObject:AddComponent(AlignViewExClassType);
        alignView:setAlign(Enum_AlignViewEx.Align_Up);
        alignView.isKeepPos = true;
    end

    if BottomTip then
        alignView = BottomTip.gameObject:AddComponent(AlignViewExClassType);
        alignView:setAlign(Enum_AlignViewEx.Align_Bottom);
        alignView.isKeepPos = true;    
    end

    TopTip  = self.transform:Find("TipTop");
    BottomTip  = self.transform:Find("TipBottom");

    if TopTip then
        alignView = TopTip.gameObject:AddComponent(AlignViewExClassType);
        alignView:setAlign(Enum_AlignViewEx.Align_Up);
        alignView.isKeepPos = true;
    end

    if BottomTip then
        alignView = BottomTip.gameObject:AddComponent(AlignViewExClassType);
        alignView:setAlign(Enum_AlignViewEx.Align_Bottom);
        alignView.isKeepPos = true;    
    end
    
    --[[
    --页码点
    self._pagePoints  = self.transform:Find("PagePoints");
    --点图标
    self._pointImages = {"guang_1","guang_2"}; 
    --页码提示
    self._pagePointsCtrl   = { 
        count=0,        --个数
        realCount = 0,  --实际个数
        distance=50,    --距离
        sprites = {
            [1] = nil,
            [2] = nil,
        },
        points = {
            
        },
        setPage = function(ctrl,index)
            for i=1,ctrl.realCount do
                if i==index then
                    ctrl.points[i].img.sprite = ctrl.sprites[1];
                else
                    ctrl.points[i].img.sprite = ctrl.sprites[2];
                end
            end
        end,
    };
    --]]

    self._listPages = {
        --添加Page
        addPage = function (self,index,obj)
            local isEmpty = false;
            if obj then
                isEmpty =  false;
            else
                isEmpty = true;
            end
            local page = {
                gameObject= obj,
                isLoaded  = not isEmpty;
                pageIndex = index,
                fishCount = 0,
                fishIndex = 0,
                loadFish = function(self)
                    local pos = Vector3.New(0,0,0);
                    local str,idStr,id;
                    if self.fishIndex<self.fishCount then
                        self.fishIndex = self.fishIndex + 1;
                        local child = self.transform:GetChild(self.fishIndex-1);
                        local fishCount2 = child.childCount;
                        local child2 = child:GetChild(0);
                        if child2 then
                            name = child2.gameObject.name;
                            str=string.gmatch(name, "fish_" .. "([0-9]+)"); 
                            if str then
                                idStr = str();
                                if idStr then
                                    id = tonumber(idStr);
                                    local fish = G_GlobalGame:GetKeyValue(G_GlobalGame.Enum_KeyValue.CreateUIFish,id);
                                    fish:SetParent(child2);
                                    fish:SetLocalPosition(pos);
                                    --播放移动
                                    fish:PlayMove();
                                end
                            end
                        end
                    end
                end,
            };
            if isEmpty then
                page.transform = nil;
            else
                page.transform = obj.transform;
                page.fishCount = page.transform.childCount;
            end
            self[index]  = page;
        end,

        --是否加载过了
        isLoadedPage = function(self,index)
            return self[index] and self[index].isLoaded  or false;
        end,
    };

    --页内容
    self._pageContent = {
        format = "Page_%d",
    };

    --设置并刷新页码总数
    self:RenewPagePoints(1);

    --[[
    local bg = self.transform:Find("Bg");
    self.width = bg:GetComponent('RectTransform').sizeDelta.x;
    self.pageContent = bg:Find("Content");

    --]]
    self.pageContent = self.transform:Find("Content");

    self.isOpen = false;
end

function _CHelpPanel:Init()  
    --self:SetCurPage(1);
end

--创建帮助页
function _CHelpPanel:createHelpPage(_index)
    local str = string.format(self._pageContent.format,_index);
    local gameObject = G_GlobalGame._goFactory:createHelpObjs(string.format(self._pageContent.format,_index));
    gameObject.name = "Page " .. _index;
    return gameObject;
end


function _CHelpPanel:Update(_dt)
    if not self.isOpen then
        return ;
    end
    self.createTimer = self.createTimer + 1;
    if self.createTimer%3==2 then
        self._listPages[self._curPage]:loadFish();
    end
end

--刷新页码指示
function _CHelpPanel:RenewPagePoints(_totalPage)
    --[[
    if self._pagePointsCtrl.count~=_totalPage then
        if self._pagePointsCtrl.realCount>=_totalPage then
            for i = _totalPage ,self._pagePointsCtrl.realCount do
                self._pagePointsCtrl.points[i].gameObject:SetActive(false);
            end
        else
            local gameObject;
            local point;
            local img;
            --
            for i = self._pagePointsCtrl.realCount+1,_totalPage do
                gameObject = GameObject.New();
                gameObject.name = "Point " .. i;
                img = gameObject:AddComponent(typeof(UnityEngine.UI.Image));
                gameObject.transform:SetParent(self._pagePoints);
                gameObject.transform.localScale = Vector3.One();
                point = {};
                point.gameObject = gameObject;
                point.transform  = gameObject.transform;
                point.img        = img;
                img.sprite       = self._pagePointsCtrl.sprites[1];
                img:SetNativeSize();
                self._pagePointsCtrl.points[i] = point;
            end
            self._pagePointsCtrl.realCount = _totalPage;
        end
        self._pagePointsCtrl.count = _totalPage;
        local totalW = (_totalPage-1) * self._pagePointsCtrl.distance;
        local beginX = -totalW/2;
        for i=1,_totalPage do
            self._pagePointsCtrl.points[i].gameObject:SetActive(true);
            self._pagePointsCtrl.points[i].transform.localPosition = Vector3.New(beginX,0,0);
            beginX = beginX + self._pagePointsCtrl.distance;
        end
    end
    --]]
    self._totalPage = _totalPage;
end

--直接跳转到某页
function _CHelpPanel:SetCurPage(_pageIndex)
    local obj;
    if self._listPages:isLoadedPage(_pageIndex) then
        obj = self._listPages[_pageIndex].gameObject;
    else
        obj = self:createHelpPage(_pageIndex);
        self._listPages:addPage(_pageIndex,obj);
        obj.transform:SetParent(self.pageContent);
        obj.transform.localPosition=Vector3.New(0,0,0);
        obj.transform.localScale   = Vector3.one;
        --改成动态加载了
--        --初始化
--        local transform = obj.transform;
--        local fishCount = obj.transform.childCount;
--        local child;
--        local fishCount2;
--        local child2;
--        local str,idStr;
--        local id;
--        local pos = Vector3.New(0,0,0);
--        local name;
--        self._listPages[_pageIndex].fishCount = fishCount;

--        for i=1,fishCount do
--            child = transform:GetChild(i-1);
--            fishCount2 = child.childCount;

--            child2 = child:GetChild(0);
--            if child2 then
--                name = child2.gameObject.name;
--                str=string.gmatch(name, "fish_" .. "([0-9]+)"); 
--                if str then
--                    idStr = str();
--                    if idStr then
--                        id = tonumber(idStr);
--                        local fish = G_GlobalGame:GetKeyValue(G_GlobalGame.Enum_KeyValue.CreateUIFish,id);
--                        fish:SetParent(child2);
--                        fish:SetLocalPosition(pos);
--                        --播放移动
--                        fish:PlayMove();
--                    end
--                end
--            end
--        end
    end
    for i=1,self._totalPage do
        if self._listPages:isLoadedPage(i) then
            self._listPages[i].gameObject:SetActive(false);          
        end
    end
    obj:SetActive(true);


    self._curPage = _pageIndex;
    --self._pagePointsCtrl:setPage(_pageIndex);
end

--切换某页
function _CHelpPanel:ChangeToPage(_pageIndex)
    self:SetCurPage(_pageIndex);
end

--向左点击
function _CHelpPanel:_onLeftClick()
    local switchPage = 1;
    if self._curPage == 1 then
        switchPage = self._totalPage;
    else
        switchPage = self._curPage - 1;
    end
    self:ChangeToPage(switchPage);
end

--向右点击
function _CHelpPanel:_onRightClick()
    local switchPage = 1;
    if self._curPage == self._totalPage then
        switchPage = 1;
    else
        switchPage = self._curPage + 1;
    end
    self:ChangeToPage(switchPage);
end

--关闭
function _CHelpPanel:_onCloseClick()
    self.gameObject:SetActive(false);
    self.isOpen = false;
end

--打开
function _CHelpPanel:OnOpen()
    self:SetCurPage(1);
    self.gameObject:SetActive(true);
    self.isOpen = true;
end


return _CHelpPanel;
