local _CHelpPanel = class("_CHelpPanel");

--创建帮助界面
function _CHelpPanel.Create(_parent)
    return _CHelpPanel.New(_parent);
end

--帮助界面构造
function _CHelpPanel:ctor(_parent)
    self.gameObject = G_GlobalGame._goFactory:createHelpPanel();
    self.transform  = self.gameObject.transform;
    self.transform:SetParent(_parent);
    self.transform.localPosition= C_Vector3_Zero;
    self.transform.localScale   = C_Vector3_One;
    local eventTrigger;
    local closeBtn  = self.transform:Find("CloseBtn");
    eventTrigger = Util.AddComponent("EventTriggerListener",closeBtn.gameObject);
    eventTrigger.onClick = handler(self,self._onCloseClick);
    self.closeBtn = closeBtn;
    local btn= self.transform:Find("LeftBtn");
    eventTrigger = Util.AddComponent("EventTriggerListener",btn.gameObject);
    eventTrigger.onClick = handler(self,self._onPreClick);

    btn= self.transform:Find("RightBtn");
    eventTrigger = Util.AddComponent("EventTriggerListener",btn.gameObject);
    eventTrigger.onClick = handler(self,self._onNextClick);
    
    self.pageContents = {};
    self.curPage      = nil;
    local content = self.transform:Find("Content");
    local count = content.childCount;
    for i=1,count do
        self.pageContents[i] = content:GetChild(i-1).gameObject;
    end

    --页码提示
    self._pagePointsCtrl   = { 
        count=0,        --个数
        realCount = 0,  --实际个数
        distance=35,    --距离
        selectIndex = 0, --所选的索引
        selectHandler = nil,
        sprites = {
            [1] = nil,
            [2] = nil,
        },
        points = {

        },
        SetPage = function(self,index)
            if self.selectIndex==index then
                return ;
            end
            if index>self.realCount then
                index = 1;
            end
            if index<1 then
                index = self.realCount;
            end
            self.selectIndex = index;
            for i=1,self.realCount do
                if i==index then
                    self.points[i].img.sprite = self.sprites[1];
                else
                    self.points[i].img.sprite = self.sprites[2];
                end
            end
            if self.selectHandler then
                self.selectHandler(index);
            end
        end,
        Init    = function(self,transform,handler,activeSprite,unactiveSprite)
            self.transform  = transform;
            self.sprites[1] = activeSprite;
            self.sprites[2] = unactiveSprite;
            self.selectHandler = handler;
        end,
        RenewPages = function(self,_totalPage)
            if self.count~=_totalPage then
                if self.realCount>=_totalPage then
                    for i = _totalPage ,self.realCount do
                        self.points[i].gameObject:SetActive(false);
                    end
                else
                    local gameObject;
                    local point;
                    local img;
                    --
                    for i = self.realCount+1,_totalPage do
                        gameObject = GAMEOBJECT_NEW();
                        --gameObject.name = "Point " .. i;
                        img = gameObject:AddComponent(ImageClassType);
                        gameObject.transform:SetParent(self.transform);
                        gameObject.transform.localScale = C_Vector3_One;
                        point = {};
                        point.gameObject = gameObject;
                        point.transform  = gameObject.transform;
                        point.img        = img;
                        img.sprite       = self.sprites[1];
                        img:SetNativeSize();
                        self.points[i] = point;
                    end
                    self.realCount = _totalPage;
                end
                self.count = _totalPage;
                local totalW = (_totalPage-1) * self.distance;
                --local beginX = -totalW/2;
                V_Vector3_Value.x = -totalW/2;
                V_Vector3_Value.y = 0;
                V_Vector3_Value.z = 0;
                for i=1,_totalPage do
                    self.points[i].gameObject:SetActive(true);
                    self.points[i].transform.localPosition = V_Vector3_Value;
                    --beginX = beginX + self._pagePointsCtrl.distance;
                    V_Vector3_Value.x  = V_Vector3_Value.x + self.distance;
                end
                self:SetPage(1);
            end
        end,
        SelectIndex = function(self)
            return self.selectIndex;
        end,
        TotalPage = function(self)
            return self.realCount;
        end,
        PrePage = function(self)
            self:SetPage(self.selectIndex-1);
        end,
        NextPage = function(self)
            self:SetPage(self.selectIndex+1);
        end,
    };
    --页码点
    local point = self.transform:Find("Point");
    local activeSprite = point:Find("Active"):GetComponent(ImageClassType).sprite;
    local unactiveSprite = point:Find("Unactive"):GetComponent(ImageClassType).sprite;
    self._pagePointsCtrl:Init(point,handler(self,self._onChangePage),activeSprite,unactiveSprite);
    self._pagePointsCtrl:RenewPages(7);
end


function _CHelpPanel:Update(_dt)

end

function _CHelpPanel:_onChangePage(_index)
    if self.curPage then
        self.curPage:SetActive(false);
    end
    self.curPage = self.pageContents[_index];
    self.curPage:SetActive(true);
end

--关闭
function _CHelpPanel:_onCloseClick()
    self.gameObject:SetActive(false);
end

--打开
function _CHelpPanel:OnOpen()
    self.gameObject:SetActive(true);
end

--上一页
function _CHelpPanel:_onPreClick()
    self._pagePointsCtrl:PrePage();
end

--下一页
function _CHelpPanel:_onNextClick()
    self._pagePointsCtrl:NextPage();
end



return _CHelpPanel;
