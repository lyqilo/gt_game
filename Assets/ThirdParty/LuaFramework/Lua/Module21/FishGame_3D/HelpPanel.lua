local CAtlasNumber = GameRequire("AtlasNumber");
--local _CHelpPanel = class("_CHelpPanel");
local _CHelpPanel = class();

local C_ZeroPos = VECTOR3ZERO;
local C_NormalScale  = VECTOR3ONE;
local C_NormalRotation = QUATERNION_EULER(0,0,0);

--创建帮助界面
function _CHelpPanel.Create(transform)
    return _CHelpPanel.New(transform);
end

--
function _CHelpPanel:ctor(transform)
--    self.gameObject = G_GlobalGame._goFactory:createHelpPanel();
--    self.transform  = self.gameObject.transform;
--    --local localPosition = self.transform.localPosition;
--    self.transform:SetParent(_parent);
--    --self.transform.localPosition= localPosition;
--    self.transform.localPosition= Vector3.New(0,0,-450);
--    self.transform.localScale   = Vector3.One();
    self.transform = transform;
    self.gameObject= transform.gameObject;

    self.mask = self.transform:Find("Mask");

    local eventTrigger;
    local closeBtn  = self.transform:Find("CloseBtn");
    eventTrigger = UTIL_ADDCOMPONENT("EventTriggerListener",closeBtn.gameObject);
    eventTrigger.onClick = handler(self,self._onCloseClick);
    self.closeBtn = closeBtn;

    local rightBtn  = self.transform:Find("RightBtn");
    eventTrigger = UTIL_ADDCOMPONENT("EventTriggerListener",rightBtn.gameObject);
    eventTrigger.onClick = handler(self,self._onRightClick);
    self.rightBtn = rightBtn;

    local leftBtn  = self.transform:Find("LeftBtn");
    eventTrigger = UTIL_ADDCOMPONENT("EventTriggerListener",leftBtn.gameObject);
    eventTrigger.onClick = handler(self,self._onLeftClick);
    self.leftBtn = leftBtn;

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
        setPage = function(self,index)
            for i=1,self.realCount do
                if i==index then
                    self.points[i].img.sprite = self.sprites[1];
                else
                    self.points[i].img.sprite = self.sprites[2];
                end
            end
        end,
        init    = function(self,activeSprite,unactiveSprite)
            self.sprites[1] = activeSprite;
            self.sprites[2] = unactiveSprite;
        end,
    };

    local point = self.transform:Find("point");
    local activeSprite = point:Find("Active"):GetComponent(ImageClassType).sprite;
    local unactiveSprite = point:Find("Unactive"):GetComponent(ImageClassType).sprite;
    self._pagePointsCtrl:init(activeSprite,unactiveSprite);

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
                    local pos = VECTOR3ZERO();
                    local str,idStr,id;
                    local UILayer = G_GlobalGame.Enum_Layer.UI;
                    local functionLib = G_GlobalGame_FunctionsLib;
                    local fish,names;
                    local goFactory = G_GlobalGame._goFactory;
                    if self.fishIndex<self.fishCount then
                        self.fishIndex = self.fishIndex + 1;
                        local child = self.transform:GetChild(self.fishIndex-1);
                        local fishCount2 = child.childCount;
                        local child2 = child:GetChild(0);
                        if child2 then
                            name = child2.gameObject.name;
                            str= string.gmatch(name, "fish_" .. "([0-9]+)"); 
                            if str then
                                idStr = str();
                                if idStr then
                                    id = tonumber(idStr);
                                    fish,names = goFactory:createUIFish(id-1);
                                    fishTransform =  fish.transform;
                                    effectCount = #names;
                                    for i=1,effectCount do
                                        child = fishTransform:Find(names[i]);
                                        particle=  child:GetComponent(ParticleSystemClassType);
                                        particle:Play();
                                    end
                                    fishTransform:SetParent(child2);
                                    fishTransform.localScale = C_NormalScale;
                                    fishTransform.localPosition = C_ZeroPos;
                                    fishTransform.localRotation = C_NormalRotation;
                                    --改变layer
                                    functionLib.SetGameObjectsLayer(fish,UILayer);
                                    if G_GlobalGame.ConstantValue.IsPortrait then
                                        if id-1 >= G_GlobalGame_Enum_FishType.FISH_KIND_30 and id-1<= G_GlobalGame_Enum_FishType.FISH_KIND_40 then
                                            --鱼王
                                            local qipaoTransform = fishTransform:Find("Body/FishAnimate/Dummy001/qipao");
                                            if qipaoTransform then
                                                self.qipaoGameObject = qipaoTransform.gameObject;
                                                local particleSystem = qipaoTransform:GetComponent(ParticleSystemClassType);
                                                particleSystem.startSize = 1.4;
                                            end
                                        end
                                    end


--                                    local fish = G_GlobalGame:GetKeyValue(G_GlobalGame.Enum_KeyValue.CreateUIFish,id);
--                                    fish:SetParent(child2);
--                                    fish:SetLocalPosition(pos);
--                                    --播放移动
--                                    fish:PlayMove();
--                                    --改变layer
--                                    functionLib.SetGameObjectsLayer(fish.gameObject,UILayer);
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
        isLoadedPage = function(_self,index)
            return _self[index] and _self[index].isLoaded  or false;
        end
    };
    --页内容
    self._pageContent = {
        format = "Page_%d",
    };

    --初始化每页
    self.pageContent = self.transform:Find("Content");
    local count = self.pageContent.childCount;
    local go,transform;

    for i=1,count do
        transform = self.pageContent:GetChild(i-1);
        go = transform.gameObject;
        self._listPages:addPage(i,go);
    end

    --设置并刷新页码总数
    self:RenewPagePoints(3);

    --[[
    local bg = self.transform:Find("Bg");
    self.width = bg:GetComponent('RectTransform').sizeDelta.x;
    self.pageContent = bg:Find("Content");

    --]]


--    self.numberSprites = {};
--    local multipleNumbers = self.transform:Find("Numbers");
--    local numberImage   = multipleNumbers:GetComponent("ImageAnima");
--    local count=numberImage.lSprites.Count;
--    for i=0,count-1 do
--        if i==11 then
--            self.numberSprites[","] =numberImage.lSprites[i];
--        elseif i==10 then
--            self.numberSprites["-"] =numberImage.lSprites[i];
--        else
--            self.numberSprites[tostring(i)] =numberImage.lSprites[i];
--        end
--    end

--    self.createNumberSprite = function (chr)
--        return self.numberSprites[chr];
--    end
    self.createTimer = 0;
end

function _CHelpPanel:Init()  
    --self:SetCurPage(1);
end

--创建帮助页
function _CHelpPanel:createHelpPage(_index)
    local str = string.format(self._pageContent.format,_index);
    local gameObject = G_GlobalGame_goFactory:createHelpObjs(string.format(self._pageContent.format,_index));
    --gameObject.name = "Page " .. _index;
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
                gameObject = GAMEOBJECT_NEW();
                --gameObject.name = "Point " .. i;
                img = gameObject:AddComponent(ImageClassType);
                gameObject.transform:SetParent(self._pagePoints);
                gameObject.transform.localScale = C_Vector3_One;
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
        --local beginX = -totalW/2;
        V_Vector3_Value.x = -totalW/2;
        V_Vector3_Value.y = 0;
        V_Vector3_Value.z = 0;
        for i=1,_totalPage do
            self._pagePointsCtrl.points[i].gameObject:SetActive(true);
            self._pagePointsCtrl.points[i].transform.localPosition = V_Vector3_Value;
            --beginX = beginX + self._pagePointsCtrl.distance;
            V_Vector3_Value.x  = V_Vector3_Value.x + self._pagePointsCtrl.distance;
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
        obj.transform.localPosition= C_Vector3_Zero;
        obj.transform.localScale   = C_Vector3_One;
    end
    for i=1,self._totalPage do
        if self._listPages:isLoadedPage(i) then
            self._listPages[i].gameObject:SetActive(false);          
        end
    end
    obj:SetActive(true);

    self._curPage = _pageIndex;
    self._pagePointsCtrl:setPage(_pageIndex);
    --隐藏显示按钮
--    if _pageIndex==1 then
--        self.leftBtn.gameObject:SetActive(false);
--    else
--        self.leftBtn.gameObject:SetActive(true);
--    end
--    if _pageIndex == self._totalPage then
--        self.rightBtn.gameObject:SetActive(false);
--    else
--        self.rightBtn.gameObject:SetActive(true);
--    end
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
