local _CHelpPanel = class("_CHelpPanel");

--创建帮助界面
function _CHelpPanel.Create(_parent)
    return _CHelpPanel.New(_parent);
end

--
function _CHelpPanel:ctor(_parent)

    self.gameObject = GlobalGame._gameObjManager:CreateHelpPanel();
    self.transform  = self.gameObject.transform;
    self.transform:SetParent(_parent);
    self.transform.localPosition= Vector3.zero;
    self.transform.localScale   = Vector3.one;

    local eventTrigger;
    local closeBtn  = self.transform:Find("CloseBtn");
    eventTrigger = Util.AddComponent("EventTriggerListener",closeBtn.gameObject);
    eventTrigger.onClick = handler(self,self._onCloseClick);
    self.closeBtn = closeBtn;

    local btn  = self.transform:Find("LastBtn");
    eventTrigger = Util.AddComponent("EventTriggerListener",btn.gameObject);
    eventTrigger.onClick = handler(self,self._onLeftClick);

    btn  = self.transform:Find("NextBtn");
    eventTrigger = Util.AddComponent("EventTriggerListener",btn.gameObject);
    eventTrigger.onClick = handler(self,self._onRightClick);
    

--    local mask  = self.transform:Find("Mask");
--    eventTrigger = Util.AddComponent("EventTriggerListener",mask.gameObject);
--    eventTrigger.onClick = handler(self,self._onRightClick);
--    self.mask = mask;
    
    --页码点
    self._pagePoints  = self.transform:Find("PagePoints");

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
                ctrl.points[i].img:SetNativeSize();
            end
        end,
    };

    --原点图标
    local Cur = self._pagePoints:Find("Cur");
    local sprite =Cur:GetComponent("Image").sprite;
    self._pagePointsCtrl.sprites[1] = sprite;
    local Other = self._pagePoints:Find("Other");
    sprite =Other:GetComponent("Image").sprite;
    self._pagePointsCtrl.sprites[2] = sprite;

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

    --内容
    self.pageContent = self.transform:Find("Content");

    --页内容
    self._pageContent = {
        format = "Page_%d",
    };

    --设置并刷新页码总数
    self:RenewPagePoints(3);

    --[[
    local bg = self.transform:Find("Bg");
    self.width = bg:GetComponent('RectTransform').sizeDelta.x;
    self.pageContent = bg:Find("Content");

    --]]
    
    self.isOpen = false;
end

function _CHelpPanel:Init()  
    --self:SetCurPage(1);
end

--创建帮助页
function _CHelpPanel:createHelpPage(_index)
    local gameObject = GlobalGame._gameObjManager:createHelpObjs(string.format(self._pageContent.format,_index));
    gameObject.name = "Page " .. _index;
    return gameObject;
end


function _CHelpPanel:Update(_dt)
    if not self.isOpen then
        return ;
    end
end

--刷新页码指示
function _CHelpPanel:RenewPagePoints(_totalPage)

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
                gameObject.transform.localScale = Vector3.one;
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
    end
    for i=1,self._totalPage do
        if self._listPages:isLoadedPage(i) then
            self._listPages[i].gameObject:SetActive(false);          
        end
    end
    obj:SetActive(true);


    self._curPage = _pageIndex;
    self._pagePointsCtrl:setPage(_pageIndex);
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
