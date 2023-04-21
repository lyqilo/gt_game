local GameDefine = GameRequire__("GameDefine");
local KeyEvent = GameRequire__("KeyEvent");
local EventSystem = GameRequire__("EventSystem");
local CAtlasNumber = GameRequire__("AtlasNumber");
local CAnimateDefine = GameRequire__("AnimateDefine");
local SoundDefine = GameRequire__("SoundDefine");
local _CEventObject = GameRequire__("EventObject");
local ThrowMove = GameRequire__("ThrowMove");
local ThrowPath = GameRequire__("ThrowPath");
local Enum_GameState = GameDefine.EnumGameState();
local EnumIconType = GameDefine.EnumIconType();
local EnumWholeType = GameDefine.EnumWholeType();
local EnumSmallGameRet = GameDefine.EnumSmallGameType();
local LuaTools = Tools.LuaScript;
local isInitOver = false

local _UIName = "game_ui";
local _v_icons = {
    [EnumIconType.EM_IconValue_Wind] = { name = "icons/normal/wind", darkname = "icons/dark/wind", abname = _UIName },
    [EnumIconType.EM_IconValue_Fire] = { name = "icons/normal/fire", darkname = "icons/dark/fire", abname = _UIName },
    [EnumIconType.EM_IconValue_Star] = { name = "icons/normal/star", darkname = "icons/dark/star", abname = _UIName },
    [EnumIconType.EM_IconValue_Food] = { name = "icons/normal/food", darkname = "icons/dark/food", abname = _UIName },
    [EnumIconType.EM_IconValue_Weapon] = { name = "icons/normal/weapon", darkname = "icons/dark/weapon", abname = _UIName },
    [EnumIconType.EM_IconValue_Army] = { name = "icons/normal/army", darkname = "icons/dark/army", abname = _UIName },
    [EnumIconType.EM_IconValue_Gentleman] = { name = "icons/normal/gentleman", darkname = "icons/dark/gentleman", abname = _UIName },
    [EnumIconType.EM_IconValue_Counsellor] = { name = "icons/normal/counsellor", darkname = "icons/dark/counsellor", abname = _UIName },
    [EnumIconType.EM_IconValue_BookSun] = { name = "icons/normal/booksun", darkname = "icons/dark/booksun", abname = _UIName },
};
local _v_iconsprites = {};
local _f_initLocal = function()
    local vi = _v_iconsprites;
    local gf = G_GlobalGame._goFactory;
    for i = EnumIconType.EM_IconValue_Null + 1, EnumIconType.EM_IconValue_Max - 1 do
        vi[i] = {};
        vi[i].sprite = gf:getCommonSprite(_v_icons[i].abname, _v_icons[i].name);
        vi[i].darksprite = gf:getCommonSprite(_v_icons[i].abname, _v_icons[i].darkname);
    end
end
local _v_ui_cachePool = nil;
local _NodeYCount = {
    [EnumIconType.EM_IconValue_Null] = 0,
    [EnumIconType.EM_IconValue_Wind] = 1,
    [EnumIconType.EM_IconValue_Fire] = 1,
    [EnumIconType.EM_IconValue_Star] = 1,
    [EnumIconType.EM_IconValue_Food] = 1,
    [EnumIconType.EM_IconValue_Weapon] = 1,
    [EnumIconType.EM_IconValue_Army] = 1,
    [EnumIconType.EM_IconValue_Gentleman] = 1,
    [EnumIconType.EM_IconValue_Counsellor] = 1,
    [EnumIconType.EM_IconValue_BookSun] = 1,
};
local EnumEvent = {
    Cache = 0, --缓存节点
    Stop = 1, --一列停止
    ScrollStop = 2, --停止转动
    MiniGameOver = 3, --小游戏结束
    JumpNode = 4, --跳出框
    RecoverNode = 5, --回到框
    AddGold = 6, --增加金币
    BalanceOver = 7, --结算消失
    ShowSepBalance = 8, --显示特殊结算
    HideSepBalance = 9, --特殊结算消失
    MiniGameBigBalance = 10, --小游戏大奖特效
    MiniGameBalance = 11, --可以弹结算框了
}

local _CNode = class("_CNode", _CEventObject);
function _CNode:ctor(_value, _isNeedAnimate)
    _CNode.super.ctor(self);
    _value = _value or EnumIconType.EM_IconValue_Null;
    self.image = nil;
    self.sprite = nil;
    self.value = _value;
    self.reference = 0;
    self.yCount = _NodeYCount[_value];
    self.offsetX = 0;
    self.offsetY = 0;
    self.isResult = false;
    self.gameObject = GameObject.New();
    self.image = self.gameObject:AddComponent(ImageClassType);
    self.gameObject.name = "Node";
    self.transform = self.gameObject.transform;
    self.isNeedAnimate = _isNeedAnimate;
    self:_initStyle(true);
end

function _CNode:_initStyle(isAnimate)
    if isAnimate then
        if self.animate then
            self.animate:Destroy();
            self.animate = nil;
        end
        if self.isNeedAnimate then
            self.animate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self.gameObject, CAnimateDefine.Enum_AnimateStyle.Icon_0 + self.value);
        end
    else
        if self.isNeedAnimate then
            if not self.animate then
                self.animate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self.gameObject, CAnimateDefine.Enum_AnimateStyle.Icon_0 + self.value);
            end
        else
            if self.animate then
                self.animate:Destroy();
                self.animate = nil;
            end
        end
    end
    self.image.sprite = _v_iconsprites[self.value].sprite;
    self.image:SetNativeSize();
end

function _CNode:NeedAnimate(isNeedAnimate)
    self.isNeedAnimate = isNeedAnimate;
end

function _CNode:Retain()
    self.reference = self.reference + 1;
    return self;
end

function _CNode:Release()
    self.reference = self.reference - 1;
    if self.reference <= 0 then
        self:SendEvent(EnumEvent.Cache);
    end
    return self;
end

function _CNode:ForceCache()
    self:SendEvent(EnumEvent.Cache);
    return self;
end

function _CNode:Action()
    self:SendEvent(EnumEvent.JumpNode);
    self.animate:PlayAlways();
    return self;
end
local darkColor = { r = 80 / 255, g = 80 / 255, b = 80 / 255, a = 1 };
local normalColor = { r = 1, g = 1, b = 1, a = 1 };

function _CNode:Dark()
    self.image.color = darkColor;
    self.image.sprite = _v_iconsprites[self.value].darksprite;
    self.image:SetNativeSize();
    return self;
end

function _CNode:Normal()
    self:SendEvent(EnumEvent.RecoverNode);
    self.animate:Stop();
    self.image.sprite = _v_iconsprites[self.value].sprite;
    self.image:SetNativeSize();
    self.image.color = normalColor;
    return self;
end

function _CNode:Update(dt)

end

function _CNode:YCount()
    return self.yCount;
end

function _CNode:Recount(ycount)
    self.yCount = self.yCount - ycount;
    return self.yCount;
end

function _CNode:SetOffset(_value1, _value2)
    self.offsetX = _value1;
    self.offsetY = _value2;
    self.transform.localPosition = Vector3.New(_value1, _value2, 0);
    return self;
end

function _CNode:OffsetX()
    return self.offsetX;
end

function _CNode:OffsetY()
    return self.offsetY;
end

function _CNode:IsResult()
    return self.isResult;
end

function _CNode:Result()
    self.isResult = true;
    return self;
end

function _CNode:Value()
    return self.value;
end

function _CNode:OnReuse(_value)
    self.isResult = false;
    self.reference = 0;
    self.yCount = _NodeYCount[_value];
    if _value == self.value then
        self.value = _value;
        self:_initStyle(false);
    else
        self.value = _value;
        self:_initStyle(true);
    end
    return self;
end

local _CScrollColumn = class("_CScrollColumn", _CEventObject);

function _CScrollColumn:ctor(index, _nodeCreator, _nodeCreator2)
    _CScrollColumn.super.ctor(self);
    self.nodes = {};
    self.isScroll = false;
    self.isStoping = false;
    self.offsetY = 0;
    self.runTime = 0;
    self.speedTime = 0;
    self.beginPosY = 0;
    self.itemBeginPos = nil;
    self.disY = nil;
    self.curCount = 0;
    self.curYCount = 0;
    self.disappearIndex = 0;
    self.nodeCreator = _nodeCreator;
    self.nodeRightCreator = _nodeCreator2;
    self.pos = { x = 0, y = 0, z = 0 };
    self.columnIndex = index;
    self.stopTime = 0.8;
    self.moveStopDis = 0;
    self.moveAllDis = 0;
end

function _CScrollColumn:Init(transform, beginPos, disY)
    self.scrollSpeed = 0; --转动速度
    self.step = 0; --0倒退 1加速, 2 匀速, 3 减速
    self.backMaxSpeed = -250;
    self.backAddSpeed = -450;
    self.beginSpeed = 2100;  --1700
    self.addSpeed = 13000;  --12000
    self.addSpeed2 = 25000;  --19000
    self.maxSpeed = 2500;   --2100
    self.stopTime = 0.16;
    self.beginPosY = 0;
    self.backBeginPosY = 0;
    self.quickCurSpeed = 0;
    self.quickMaxSpeed = 2700;  --2700
    self.quickAddSpeed = 15000; --15000
    self.quickAddSpeed2 = 25000;  --26000
    self.quickStopTime = 0.16;
    self.quickBeginPosY = 0;
    self.beginIndex = 1;
    --快速移动标志
    self.isQuickSpeed = false;
    self.isEffect = false;
    self.itemBeginPos = beginPos;
    self.disY = disY;
    self.curCount = 0;
    self.totalYCount = 0;
    self.transform = transform;
    self.gameObject = transform.gameObject;
    self.maskComponent = self.gameObject:GetComponent("RectMask2D");
    self.rectMaskTransform = transform:Find("RectMask");
    self.scrollTransform = self.rectMaskTransform:Find("Scroll");
    self.transform.localScale = Vector3.one;
    self.transform.localEulerAngles = Vector3.zero;
    self.scrollTransform.localScale = Vector3.one;
    self.scrollTransform.localEulerAngles = Vector3.zero;
    self.effectObj = GAMEOBJECT_NEW();
    self.effectTransform = self.effectObj.transform;
    self.effectTransform:SetParent(self.transform);
    self.effectTransform.localPosition = VECTOR3NEW(-5, 0, 0);
    self.effectTransform.localScale = Vector3.one;
    --self.effectAnimate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self.effectObj,CAnimateDefine.Enum_AnimateStyle.Quick_Scroll);
    self.disappearIndex = 0;
    self.moveStopDis = 0;
    self.moveAllDis = 0;
    self.continueCount = 1;
end

function _CScrollColumn:Update(dt)
    if not self.isScroll then
        return ;
    end
    if (dt > 0.06) then
        dt = 0.06;
    end
    self.runTime = self.runTime + dt;
    if self.step == 0 then
        self.scrollSpeed = self.backAddSpeed * self.runTime;
        if self.scrollSpeed <= self.backMaxSpeed then
            self.step = 1; --加速
            self.runTime = 0;
            self.scrollSpeed = self.backMaxSpeed;
        end
        self.backBeginPosY = self.backAddSpeed * self.runTime * self.runTime * 0.5;
        self.offsetY = self.backBeginPosY;
    elseif self.step == 1 then
        self.scrollSpeed = self.beginSpeed + self.addSpeed * self.runTime;
        if self.scrollSpeed >= self.maxSpeed then
            self.step = 2; --匀速转动
            self.speedTime = 0;
            self.scrollSpeed = self.maxSpeed;
        end
        self.beginPosY = self.beginSpeed * self.runTime + self.addSpeed * self.runTime * self.runTime * 0.5 + self.backBeginPosY;
        self.offsetY = self.beginPosY;
    elseif self.step == 2 then
        self.speedTime = self.speedTime + dt;
        self.offsetY = self.beginPosY + self.scrollSpeed * self.speedTime;
        if self.isStoping then
            self.step = 3;
            if self.offsetY >= self.moveStopDis then
                G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().ScrollStop);
                self.offsetY = self.moveStopDis;
                self.step = 4;
                self.runTime = 0;
                self.beginPosY = self.offsetY;
            end
        end
    elseif self.step == 3 then
        self.speedTime = self.speedTime + dt;
        self.offsetY = self.beginPosY + self.scrollSpeed * self.speedTime;
        if self.offsetY >= self.moveStopDis then
            G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().ScrollStop);
            self.offsetY = self.moveStopDis;
            self.step = 4;
            self.runTime = 0;
            self.beginPosY = self.offsetY;
        end
    elseif self.step == 4 then
        local stopValue = self.scrollSpeed * self.runTime - self.addSpeed2 * self.runTime * self.runTime * 0.5;
        self.offsetY = self.beginPosY + stopValue;
        if self.runTime >= self.stopTime then
            self.offsetY = self.moveAllDis;
            self.step = 5;
            --滚动结束
            self:ScrollOver();
        end
    elseif self.step == 5 then
        return ;
        --以下都是处理快速移动环节
    elseif self.step == 6 then
        self.scrollSpeed = self.quickCurSpeed + self.quickAddSpeed * self.runTime;
        if self.scrollSpeed >= self.quickMaxSpeed then
            self.step = 7; --匀速转动
            self.speedTime = 0;
            self.scrollSpeed = self.quickMaxSpeed;
        end
        self.beginPosY = self.quickBeginPosY + self.quickCurSpeed * self.runTime + self.quickAddSpeed * self.runTime * self.runTime * 0.5;
        self.offsetY = self.beginPosY;
    elseif self.step == 7 then
        self.speedTime = self.speedTime + dt;
        self.offsetY = self.beginPosY + self.scrollSpeed * self.speedTime;
        if self.isStoping then
            self.step = 8;
            if self.offsetY >= self.moveStopDis then
                self.offsetY = self.moveStopDis;
                self.step = 9;
                self.runTime = 0;
                self.beginPosY = self.offsetY;
            end
        end
    elseif self.step == 8 then
        self.speedTime = self.speedTime + dt;
        self.offsetY = self.beginPosY + self.scrollSpeed * self.speedTime;
        if self.offsetY >= self.moveStopDis then
            self.offsetY = self.moveStopDis;
            self.step = 9;
            self.runTime = 0;
            self.beginPosY = self.offsetY;
            --self.effectAnimate:SetPlaySpeed(1);
            self.effectObj:SetActive(false);
        end
    elseif self.step == 9 then
        local stopValue = self.scrollSpeed * self.runTime - self.quickAddSpeed2 * self.runTime * self.runTime * 0.5;
        self.offsetY = self.beginPosY + stopValue;
        if self.runTime >= self.quickStopTime then
            self.offsetY = self.moveAllDis;
            self.step = 10;
            self:_stopQuickEffect();
            --self.effectAnimate:Stop();
            --滚动结束
            self:ScrollOver();
        end
    elseif self.step == 10 then
    end
    self.pos.y = -self.offsetY;
    self.scrollTransform.localPosition = self.pos;
    self:ArrangeNodes();
end

function _CScrollColumn:_quickEffect()
    self.effectObj:SetActive(true);
    self.effectAnimate:PlayAlways();
end
function _CScrollColumn:_stopQuickEffect()
    self.effectObj:SetActive(false);
    self.effectAnimate:Stop();
end
function _CScrollColumn:TotalYCount()
    return self.curYCount;
end

--开始滚动
function _CScrollColumn:Scroll()
    self.continueCount = 1;
    self.isScroll = true;
    self.isStoping = false;
    self.retNodes = nil;
    self.runTime = 0;
    --重新设置下坐标
    self:ResetNodes();
    --快速移动标志
    self.isQuickSpeed = false;
    self.isEffect = false;
    if self.beginIndex == 1 then
        self.step = 1; --第0步倒退 第一步倒退
        self.scrollSpeed = self.beginSpeed;
    else
        self.step = 0; --第0步倒退 第一步倒退
    end
    self.backBeginPosY = 0;
    return self;
end

--停止
function _CScrollColumn:Stop()
    if not self.isScroll then
        return self;
    end
    if self.isStoping then
        return self;
    end
    if self.isQuickSpeed then
        --快速开始就快速停止
        self:QuickStop();
        return self;
    end
    self.isStoping = true;
    if self.step == 1 then
        self.step = 2; --匀速转动
        self.speedTime = 0;
        self.scrollSpeed = self.maxSpeed;
    end
    if self.retNodes then
        local stopValue = self.scrollSpeed * self.stopTime - self.addSpeed2 * self.stopTime * self.stopTime * 0.5;
        local yCount = GameDefine.YCount();
        local leftDis = (self.totalYCount - yCount - 4) * self.disY - self.offsetY;
        local diffDis = 0;
        if (self.totalYCount * self.disY - self.offsetY > stopValue) then
            diffDis = self.totalYCount * self.disY - self.offsetY - stopValue;
        end
        local totalValue = stopValue + diffDis + self.offsetY;
        local totalCount = math.ceil(totalValue / self.disY);
        local count = totalCount - self.totalYCount;
        local nodes, continueCount = self:CreateRightNodes(count, nil, self.withouts, self.nodes[self.curCount]:Value(), self.continueCount);
        self.continueCount = continueCount;
        local node;
        local offsetY = 0;
        local offsetX = 0;
        self.moveAllDis = totalCount * self.disY;
        self.moveStopDis = self.moveAllDis - stopValue;
        for i = 1, #nodes do
            node = nodes[i];
            self.curCount = self.curCount + 1;
            self.nodes[self.curCount] = node;
            node:SetParent(self.scrollTransform);
            self:setNodePos(node);
            self.totalYCount = self.totalYCount + node:YCount();
        end
        for i = 1, #self.retNodes do
            node = self.retNodes[i];
            self.curCount = self.curCount + 1;
            self.nodes[self.curCount] = node;
            node:SetParent(self.scrollTransform);
            self:setNodePos(node);
            self.totalYCount = self.totalYCount + node:YCount();
        end
    else
        local stopValue = self.scrollSpeed * self.stopTime - self.addSpeed2 * self.stopTime * self.stopTime * 0.5;
        local totalValue = stopValue + self.offsetY;
        local totalCount = math.ceil(totalValue / self.disY);
        local count = totalCount - self.totalYCount;
        local nodes, continueCount = self:CreateRightNodes(count, nil, self.withouts, self.nodes[self.curCount]:Value(), self.continueCount);
        self.continueCount = continueCount;
        local node;
        local offsetY = 0;
        local offsetX = 0;
        self.moveAllDis = totalCount * self.disY;
        self.moveStopDis = self.moveAllDis - stopValue;
        for i = 1, #nodes do
            node = nodes[i];
            self.curCount = self.curCount + 1;
            self.nodes[self.curCount] = node;
            node:SetParent(self.scrollTransform);
            self:setNodePos(node);
            self.totalYCount = self.totalYCount + node:YCount();
        end
    end
    return self;
end

function _CScrollColumn:setNodePos(node, isReduce)
    if isReduce then
        local offsetY = (self.totalYCount - 0.5 - node:YCount() * 0.5) * self.disY;
        node:SetOffset(0 + self.itemBeginPos.x, offsetY + self.itemBeginPos.y);
    else
        local offsetY = (self.totalYCount - 0.5 + node:YCount() * 0.5) * self.disY;
        node:SetOffset(0 + self.itemBeginPos.x, offsetY + self.itemBeginPos.y);
    end
end

--设置nodes
function _CScrollColumn:Result(_nodes)
    self.retNodes = _nodes;
    for i = 1, #_nodes do
        _nodes[i]:Retain();
        _nodes[i]:RegEvent(self, self.OnEventNode)
    end
    return self;
end

--整理各节点
function _CScrollColumn:ArrangeNodes()
    if self.isScroll then
        local index = math.floor((self.offsetY / self.disY)) + self.beginIndex - 1;
        if (index >= self.disappearIndex) then
            local count = index - self.disappearIndex;
            self.disappearIndex = index;
            local node;
            local kickCount = 0;
            local yCount = 0;
            while (count > 0) do
                if #self.nodes <= 0 then
                    break ;
                end
                node = self.nodes[1];
                if (node:YCount() >= count) then
                    node:Recount(count);
                    if node:YCount() <= 0 then
                        count = 0;
                        self:ReleaseNode(node);
                        table.remove(self.nodes, 1);
                        kickCount = kickCount + 1;
                    end
                else
                    count = count - node:YCount();
                    self:ReleaseNode(node);
                    table.remove(self.nodes, 1);
                    kickCount = kickCount + 1;
                end
            end
            self.curCount = self.curCount - kickCount;
        end
    else
        local index = math.floor((self.offsetY / self.disY)) + self.beginIndex - 2;
        if (index >= self.disappearIndex) then
            local count = index - self.disappearIndex - 1;
            self.disappearIndex = index + 1;
            local kickCount = 0;
            local yCount = 0;
            while (count > 0) do
                node = self.nodes[1];
                if (node:YCount() >= count) then
                    node:Recount(count);
                    if node:YCount() <= 0 then
                        count = 0;
                        self:ReleaseNode(node);
                        table.remove(self.nodes, 1);
                        kickCount = kickCount + 1;
                    end
                else
                    count = count - node:YCount();
                    self:ReleaseNode(node);
                    table.remove(self.nodes, 1);
                    kickCount = kickCount + 1;
                end
            end
            self.curCount = self.curCount - kickCount;
        end
    end
    local curYCount = 0;
    for i = 1, self.curCount do
        curYCount = curYCount + self.nodes[i]:YCount();
    end
    local needCount = GameDefine.YCount() + self.beginIndex;
    if curYCount < needCount then
        local count = needCount - curYCount;
        local nodes, continueCount = self:CreateNodes(count, nil, self.withouts, self.nodes[self.curCount]:Value(), self.continueCount);
        self.continueCount = continueCount;
        local offsetY = 0;
        local offsetX = 0;
        for i = 1, #nodes do
            local node = nodes[i];
            self.curCount = self.curCount + 1;
            self.nodes[self.curCount] = node;
            node:SetParent(self.scrollTransform);
            self:setNodePos(node);
            self.totalYCount = self.totalYCount + node:YCount();
        end
    end
    return self;
end

function _CScrollColumn:ResetNodes()
    local totalCount = 0;
    local offsetY = 0;
    local offsetX = 0;
    self.offsetY = 0;
    self.totalYCount = 0;
    self.disappearIndex = 0;
    local node;
    for i = 1, self.curCount do
        node = self.nodes[i];
        if i >= self.beginIndex then
            self:setNodePos(node);
            self.totalYCount = self.totalYCount + node:YCount();
        else
            self:setNodePos(node, true);
        end
    end
    self.scrollTransform.localPosition = Vector3.New(0, 0, 0);
    return self;
end

function _CScrollColumn:GetColumnNode(index)
    local yCount = GameDefine.YCount();
    if index > yCount then
        return nil;
    end
    return self.nodes[yCount - index + self.beginIndex];
end

function _CScrollColumn:RandomNodes()
    local withouts = { EnumIconType.FreeGame };
    local nodes = self:CreateNodes(GameDefine.YCount() + self.beginIndex - 1, nil, withouts);
    self.curCount = #nodes;
    for i = 1, self.curCount do
        self.nodes[i] = nodes[i];
        nodes[i]:SetParent(self.scrollTransform);
    end
    self:ResetNodes();
    return self;
end

function _CScrollColumn:ScrollOver()
    self.isScroll = false;
    self:SendEvent(EnumEvent.Stop);
    return self;
end

function _CScrollColumn:CreateNodes(...)
    local nodes, _continueCount = self.nodeCreator(...);
    for i = 1, #nodes do
        nodes[i]:Retain();
        nodes[i]:RegEvent(self, self.OnEventNode)
    end
    return nodes, _continueCount;
end

function _CScrollColumn:CreateRightNodes(...)
    local nodes, _continueCount = self.nodeRightCreator(...);
    for i = 1, #nodes do
        nodes[i]:Retain();
        nodes[i]:RegEvent(self, self.OnEventNode)
    end
    return nodes, _continueCount;
end

function _CScrollColumn:ReleaseNode(node)
    node:RemoveEvent(self);
    node:ForceCache();
end

--快速转动
function _CScrollColumn:QuickScroll(isEffect)
    if not self.isScroll then
        self:Scroll();
    end
    if self.isQuickSpeed then
        return self;
    end
    self:_quickEffect();
    self.isQuickSpeed = true;
    self.isEffect = isEffect;
    self.step = 6; --直接到第六步加速环节
    self.quickCurSpeed = self.scrollSpeed;
    --    self.step = 7; --直接到第七步加速环节
    --    self.quickCurSpeed = self.quickMaxSpeed;
    self.quickBeginPosY = self.offsetY;
    self.runTime = 0;
    self.speedTime = 0;
    return self;
end

function _CScrollColumn:QuickStop()
    if not self.isScroll then
        return self;
    end
    if self.isStoping then
        return self;
    end
    if not self.isQuickSpeed then
        self:Stop()
        return self;
    end
    self.isStoping = true;
    if self.step == 6 then
        self.step = 7; --匀速转动
        self.speedTime = 0;
        self.scrollSpeed = self.quickMaxSpeed;
    end
    if self.retNodes then
        local stopValue = self.scrollSpeed * self.quickStopTime - self.quickAddSpeed2 * self.quickStopTime * self.quickStopTime * 0.5;
        local yCount = GameDefine.YCount();
        local leftDis = (self.totalYCount - yCount) * self.disY - self.offsetY;
        local diffDis = 0;
        if (self.totalYCount * self.disY - self.offsetY > stopValue) then
            diffDis = self.totalYCount * self.disY - self.offsetY - stopValue;
        end
        local totalValue = stopValue + diffDis + self.offsetY;
        local totalCount = math.ceil(totalValue / self.disY);
        local count = totalCount - self.totalYCount;
        local nodes, continueCount = self:CreateRightNodes(count, nil, self.withouts, self.nodes[self.curCount]:Value(), self.continueCount);
        self.continueCount = continueCount;
        local node;
        local offsetY = 0;
        local offsetX = 0;
        self.moveAllDis = totalCount * self.disY;
        self.moveStopDis = self.moveAllDis - stopValue;
        for i = 1, #nodes do
            node = nodes[i];
            self.curCount = self.curCount + 1;
            self.nodes[self.curCount] = node;
            node:SetParent(self.scrollTransform);
            offsetY = (self.totalYCount - 0.5 + node:YCount() * 0.5) * self.disY;
            node:SetOffset(offsetX + self.itemBeginPos.x, offsetY + self.itemBeginPos.y);
            self.totalYCount = self.totalYCount + node:YCount();
        end
        for i = 1, #self.retNodes do
            node = self.retNodes[i];
            self.curCount = self.curCount + 1;
            self.nodes[self.curCount] = node;
            node:SetParent(self.scrollTransform);
            offsetY = (self.totalYCount - 0.5 + node:YCount() * 0.5) * self.disY;
            node:SetOffset(offsetX + self.itemBeginPos.x, offsetY + self.itemBeginPos.y);
            self.totalYCount = self.totalYCount + node:YCount();
        end
    else
        local stopValue = self.scrollSpeed * self.quickStopTime - self.quickAddSpeed2 * self.quickStopTime * self.quickStopTime * 0.5;
        local totalValue = stopValue + self.offsetY;
        local totalCount = math.ceil(totalValue / self.disY);
        local count = totalCount - self.totalYCount;
        local nodes, continueCount = self:CreateRightNodes(count, nil, self.withouts, self.nodes[self.curCount]:Value(), self.continueCount);
        self.continueCount = continueCount;
        local node;
        local offsetY = 0;
        local offsetX = 0;
        self.moveAllDis = totalCount * self.disY;
        self.moveStopDis = self.moveAllDis - stopValue;
        for i = 1, #nodes do
            node = nodes[i];
            self.curCount = self.curCount + 1;
            self.nodes[self.curCount] = node;
            node:SetParent(self.scrollTransform);
            offsetY = (self.totalYCount - 0.5 + node:YCount() * 0.5) * self.disY;
            node:SetOffset(offsetX + self.itemBeginPos.x, offsetY + self.itemBeginPos.y);
            self.totalYCount = self.totalYCount + node:YCount();
        end
    end
    return self;
end

function _CScrollColumn:OnEventNode(_eventID, node)
    if _eventID == EnumEvent.JumpNode then
        node:SetParent(self.transform, true);
    elseif _eventID == EnumEvent.RecoverNode then
        node:SetParent(self.scrollTransform, true);
    end
end

local node_BeginPos = { x = 0, y = -183, z = 0 };
local node_disY = 122;
local rectMaskSize = { x = 163, y = 490 };
local scrollColumnPos = {
    { x = -318, y = -11, z = 0 },
    { x = -148, y = 44, z = 0 },
    { x = 20, y = -11, z = 0 },
    { x = 189, y = 44, z = 0 },
    { x = 358, y = -11, z = 0 },
};

local _CScrollColumnControl = class("_CScrollColumnControl", _CEventObject);

function _CScrollColumnControl:ctor()
    _CScrollColumnControl.super.ctor(self);
    self.scrollColumns = {};
    self.nodes = {};  --缓存可用的
    self.transform = nil;
    self.gameObject = nil;
    self.maskComponenet = nil;
    self.isScroll = false;
    self.runTime = 0;
    self.columnIndex = 0;
    self.scrollStep = 1;
    self.isGetResult = false;
    self.stopCount = 0;
    self.retData = nil;
    self.isScrollSepCup = false; --是否特殊的大力神杯
    self.isScrollSepCup2 = false; --是否特殊的第四列也是大力神杯
    self.isScrollSepGame = false; --是否特殊的游戏
    self.scrollMusicHandler = nil;
    self.isQuickMusic = false;
end

function _CScrollColumnControl:Init(transform)
    local beginPos = node_BeginPos;
    local disY = node_disY;
    local XCount = GameDefine.XCount();
    local scrollColumn, ctransform;
    self.transform = transform;
    self.gameObject = transform.gameObject;
    self.maskComponenet = self.gameObject:GetComponent("RectMask2D");
    for i = 1, XCount do
        ctransform = transform:Find("Column" .. i);
        scrollColumn = _CScrollColumn.New(i, handler(self, self.CreateNodes), handler(self, self.CreateRightNodes));
        self.scrollColumns[i] = scrollColumn;
        scrollColumn:Init(ctransform, beginPos, disY);
        scrollColumn:RegEvent(self, self.OnEventColumn);
        --随机节点
        scrollColumn:RandomNodes();
    end
end

local scrollInterval = 0.06;
local scrollStopInterval = 0.15;
local scrollSepInterval = 3; --加 0.4秒停止时间就等于5秒总时间
local scrollMinTime = 0.03;

function _CScrollColumnControl:Update(dt)
    if self.isScroll then
        local xCount = GameDefine.XCount();
        -- xCount = 1;
        if self.scrollStep == 1 then
            self.runTime = self.runTime + dt;
            if self.runTime >= scrollInterval then
                if self.columnIndex <= xCount then
                    self.scrollColumns[self.columnIndex]:Scroll();
                    self.runTime = 0;
                    self.columnIndex = self.columnIndex + 1;
                else
                    self.scrollStep = 2;
                    self.runTime = 0;
                end
            end
        elseif self.scrollStep == 2 then
            self.runTime = self.runTime + dt;
            if self.runTime >= scrollMinTime then
                if self.isContinue then
                    self.scrollStep = 3;
                end
                self.runTime = 0;
            end
        elseif self.scrollStep == 3 then
            if self.isGetResult then
                self:createResult();
                --获取到结果了
                self.scrollStep = 4;
                self.runTime = 0;
                self.stopCount = 0;
                self.columnIndex = 1;
            end
        elseif self.scrollStep == 4 then
            --一个一个停
            self.runTime = self.runTime + dt;
            if self.runTime >= scrollStopInterval then
                if self.columnIndex <= xCount then
                    self.scrollColumns[self.columnIndex]:Stop();
                    self.runTime = 0;
                    self.columnIndex = self.columnIndex + 1;
                    if self.isScrollSepGame or self.isScrollSepCup2 then
                        if self.columnIndex >= 5 then
                            self.scrollStep = 6; --进入特殊环节
                        end
                    end
                else
                    self.scrollStep = 6;
                    self.runTime = 0;
                end
            end
        elseif self.scrollStep == 5 then
            --特殊环节
            self.runTime = self.runTime + dt;
            if self.runTime >= scrollSepInterval then
                if self.columnIndex <= xCount then
                    self.scrollColumns[self.columnIndex]:Stop();
                    self.runTime = 0;
                    self.columnIndex = self.columnIndex + 1;
                else
                    self.scrollStep = 6;
                    self.runTime = 0;
                end
            end
        elseif self.scrollStep == 6 then
            --特殊环节特殊 等待阶段
            --self.runTime = self.runTime + dt;
            --            if self.runTime>=scrollSepInterval then
            --                if self.columnIndex<=xCount then
            --                    self.scrollColumns[self.columnIndex]:Stop();
            --                    self.runTime = 0;
            --                    self.columnIndex = self.columnIndex + 1;
            --                else
            --                    self.scrollStep = 5;
            --                    self.runTime = 0;
            --                end
            --            end
        end
    end
    local XCount = GameDefine.XCount();
    for i = 1, XCount do
        self.scrollColumns[i]:Update(dt);
    end
end

--获取节点
function _CScrollColumnControl:CreateNodes(count, withs, withouts, _value, _continueCount)
    local NodeCount = #_NodeYCount;
    local nodes = {};
    local yCount;
    local node;
    local values = {};
    if withs ~= nil then
        for i = 1, #withs do
            values[i] = withs[i];
        end
    else
        for i, v in pairs(_NodeYCount) do
            if i ~= EnumIconType.EM_IconValue_Null then
                values[#values + 1] = i;
            end
        end
    end
    if withouts then
        for i = 1, #withouts do
            for j = #values, 1, -1 do
                if withouts[i] == values[j] then
                    table.remove(values, j);
                end
            end
        end
    end
    NodeCount = #values;
    while (count > 0) do
        local value
        if (_value ~= nil) then
            if _continueCount <= 3 then
                _continueCount = _continueCount + 1;
                value = _value;
            elseif _continueCount == 4 then
                _continueCount = _continueCount + 1;
                if (math.random(1, 10) > 5) then
                    value = _value;
                end
            end
        end
        if (value == nil) then
            value = math.random(1, NodeCount);
            value = values[value];
            if _value ~= nil then
                _value = value;
                _continueCount = 1;
            end
        end
        yCount = _NodeYCount[value];
        count = count - yCount;
        if (#self.nodes <= 0) then
            node = _CNode.New(value);
            node:NeedAnimate(false);
            node.transform.localPosition = Vector3.zero;
            node:RegEvent(self, self.OnEventNode);
            node.transform.localPosition = Vector3.zero;
            node.transform.localScale = Vector3.one;
            node:SetParent(_v_ui_cachePool, true);
            node.transform.localScale = Vector3.one;
        else
            node = self.nodes[#self.nodes];
            table.remove(self.nodes, #self.nodes);
            node:OnReuse(value);
        end
        nodes[#nodes + 1] = node;
    end
    return nodes, _continueCount;
end

function _CScrollColumnControl:Continue()
    self.isContinue = true;
end

--获取节点
function _CScrollColumnControl:CreateRightNodes(count, withs, withouts, _value, _continueCount)
    local NodeCount = #_NodeYCount;
    local nodes = {};
    local yCount;
    local node;
    local values = {};
    if withs ~= nil then
        for i = 1, #withs do
            values[i] = withs[i];
        end
    else
        for i, v in pairs(_NodeYCount) do
            if i ~= EnumIconType.EM_IconValue_Null then
                values[#values + 1] = i;
            end
        end
    end
    if withouts then
        for i = 1, #withouts do
            for j = #values, 1, -1 do
                if withouts[i] == values[j] then
                    table.remove(values, j);
                end
            end
        end
    end
    NodeCount = #values;
    while (count > 0) do
        local value
        if (_value ~= nil) then
            if _continueCount <= 3 then
                _continueCount = _continueCount + 1;
                value = _value;
            elseif _continueCount == 4 then
                _continueCount = _continueCount + 1;
                if (math.random(1, 10) > 5) then
                    value = _value;
                end
            end
        end
        if (value == nil) then
            value = math.random(1, NodeCount);
            value = values[value];
            if _value ~= nil then
                _value = value;
                _continueCount = 1;
            end
        end
        yCount = _NodeYCount[value];
        if count >= yCount then
            count = count - yCount;
            if (#self.nodes <= 0) then
                node = _CNode.New(value);
                node:NeedAnimate(false);
                node.transform.localPosition = Vector3.zero;
                node:RegEvent(self, self.OnEventNode);
                node.transform.localPosition = Vector3.zero;
                node.transform.localScale = Vector3.one;
                node:SetParent(_v_ui_cachePool, true);
                node.transform.localScale = Vector3.one;
            else
                node = self.nodes[#self.nodes];
                table.remove(self.nodes, #self.nodes);
                node:OnReuse(value);
            end
            nodes[#nodes + 1] = node;
        else
            table.remove(values, index);
            NodeCount = NodeCount - 1;
        end
    end
    return nodes, _continueCount;
end

--获取可用的
function _CScrollColumnControl:_createNode(_value, _needAnimate)
    local node;
    if (#self.nodes <= 0) then
        node = _CNode.New(_value, _needAnimate);
        node:RegEvent(self, self.OnEventNode);
        node:SetParent(_v_ui_cachePool);
    else
        node = table.remove(self.nodes, #self.nodes);
        node:NeedAnimate(_needAnimate);
        node:OnReuse(_value);
    end
    return node;
end

function _CScrollColumnControl:OnEventNode(_eventID, _node)
    if (_eventID == EnumEvent.Cache) then
        self.nodes[#self.nodes + 1] = _node;
        --放进缓存池
        _node:SetParent(_v_ui_cachePool);
    end
end

function _CScrollColumnControl:OnEventColumn(_eventID, _column)
    if (_eventID == EnumEvent.Stop) then
        self.stopCount = self.stopCount + 1;
        if self.stopCount == 3 then
            --有特殊环节的要进行处理
        elseif self.stopCount == 4 then
            --有特殊环节的要进行处理
        end
        if self.stopCount >= GameDefine.XCount() then
            self.isScroll = false;
            --结束转动
            self:SendEvent(EnumEvent.ScrollStop);
        end
    end
end

--开始转动
function _CScrollColumnControl:Scroll()
    if self.isScroll then
        return self;
    end
    self.isContinue = true;
    self.isScroll = true;
    self.runTime = 0;
    self.columnIndex = 1;
    self.scrollStep = 1;
    self.isGetResult = false;
    self.isScrollSepCup = false;
    self.isScrollSepGame = false;
    --    if not self.scrollMusicHanlder then
    --        self.scrollMusicHandler = G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().Scroll,-1);
    --        self.isQuickMusic = false;
    --    end
    return self;
end

function _CScrollColumnControl:IsScroll()
    return self.isScroll;
end

function _CScrollColumnControl:Stop()
    if not self.isScroll then
        return ;
    end
    self.scrollStep = 3;
    self.runTime = 0;
    self.isGetResult = true;
end

function _CScrollColumnControl:ResultData(_data)
    if not self.isScroll then
        return ;
    end
    self.retData = _data;
    self.isGetResult = true;
end

function _CScrollColumnControl:createResult()
    local _data = self.retData;
    local xCount = GameDefine.XCount();
    local yCount = GameDefine.YCount();
    local resultNodes;
    local node;
    local cupCount = 0;
    local cupCount2 = 0;
    local refereeCount = 0;
    for i = 1, xCount do
        resultNodes = {};
        for j = 1, yCount do
            node = self:_createNode(_data[j][i], true);
            --            if (i<=3) then
            --                if _data[j][i]== EnumIconType.EM_IconValue_Referee then
            --                    refereeCount = refereeCount + 1;
            --                elseif _data[j][i]== EnumIconType.EM_IconValue_Cup then
            --                    cupCount = cupCount + 1;
            --                end
            --            end
            --            if (i<=4) then
            --                if _data[j][i]== EnumIconType.EM_IconValue_Cup then
            --                    cupCount2 = cupCount2 + 1;
            --                end
            --            end
            table.insert(resultNodes, 1, node);
        end
        self.scrollColumns[i]:Result(resultNodes);
    end
end

function _CScrollColumnControl:GetNode(_xIndex, _yIndex)
    local column = self.scrollColumns[_xIndex];
    return column:GetColumnNode(_yIndex);
end

function _CScrollColumnControl:ScrollOver()
    self.retData = nil;
end

local _CIconCell = class("_CIconCell");

function _CIconCell:ctor()
    self.node = nil;
    self.isAction = false;
    self.isNeedRecover = false;
    self.alpha = 0;
    self.isShow = false;
    self.isChangeColor = false;
    self.effectPart = nil;
    self.isShake = false;
    self.isFly = false;
    self.targetPos = nil;
end

function _CIconCell:Init(transform)
    self.gameObject = GAMEOBJECT_NEW();
    self.image = self.gameObject:AddComponent(ImageClassType);
    self.image.sprite = G_GlobalGame._goFactory:getCommonSprite("game_ui", "other/zhanling");
    self.transform = self.gameObject.transform;
    self.transform:SetParent(transform);
    self.transform.localScale = Vector3.one;
    self.image:SetNativeSize();
    self.gameObject:SetActive(true);
    self.isShow = true;
end

function _CIconCell:Show()
    if self.isShow then
        return self;
    end
    self.gameObject:SetActive(true);
    self.alpha = 1;
    self.image.color = { r = 1, g = 1, b = 1, a = self.alpha };
    self.isShow = true;
    return self;
end

function _CIconCell:Hide(handler)
    if not self.isShow then
        return self;
    end
    self.gameObject:SetActive(true);
    self.alpha = 1;
    self.image.color = { r = 1, g = 1, b = 1, a = self.alpha };
    self.isShow = false;
    self.isChangeColor = true;
    self.showHandler = handler;
    return self;
end

function _CIconCell:CreateEffect(transform)
    local obj
    if G_GlobalGame.ConstantValue.IsPortrait then
        obj = G_GlobalGame._goFactory:createUICommon("+1_shu");
    else
        obj = G_GlobalGame._goFactory:createUICommon("+1");
    end
    obj:SetActive(false);
    local trans = obj.transform;
    trans:SetParent(transform);
    trans.localScale = Vector3.one;
    trans.localPosition = C_Vector3_Zero;
    self.effectPart = trans:GetComponent("ParticleSystem");
    self.effectObj = obj;
    self.effectTime = 0;

    obj = G_GlobalGame._goFactory:createUICommon("huo");
    obj:SetActive(false);
    local trans = obj.transform;
    trans:SetParent(transform);
    trans.localScale = Vector3.one;
    trans.localPosition = C_Vector3_Zero;
    self.warEPart = trans:GetComponent("ParticleSystem");
    self.warEObj = obj;
    self.warETime = 0;
    return self;
end

function _CIconCell:SetLocalPosition(pos)
    self.warEPart.transform.localPosition = pos;
    self.beginPos = self.warEPart.transform.position:Clone();
    self.transform.localPosition = pos;
    self.effectPart.transform.localPosition = { x = pos.x, y = pos.y - 54, z = pos.z };
    return self;
end

--关联node 
function _CIconCell:ReleationNode(_node)
    self.node = _node;
    self.isAction = false;
    self.isNeedRecover = false;
    return self;
end

--一般是中奖了抖动
function _CIconCell:Action()
    self.node:Action();
    self.isAction = true;
    self.isNeedRecover = true;
    return self;
end

function _CIconCell:Dark()
    if self.isAction then
        return self;
    end
    self.node:Dark();
    self.isNeedRecover = true;
    return self;
end

function _CIconCell:Normal()
    if not self.isNeedRecover then
        return self;
    end
    self.isAction = false;
    if self.node then
        self.node:Normal();
    end
    return self;
end

function _CIconCell:Value()
    if self.node then
        return self.node:Value();
    end
end

function _CIconCell:ShowEffect()
    self.effectPart:Play();
    self.effectObj:SetActive(true);
    self.effectTime = 1;
    return self;
end

function _CIconCell:Shake()
    self.alpha = 1;
    self.isShake = true;
    self.shakeAdd = -1;
    self.shakeCount = 0;
    return self;
end

function _CIconCell:FlyWarEffect(targetPos, tt, endHandler)
    self.isFly = true;
    self.warEPart.transform.position = self.beginPos;
    self.warEObj:SetActive(true);
    self.warETime = 0;
    self.targetPos = targetPos;
    self.warTT = (tt - 0.15);
    self.speed = (targetPos:Clone() - self.beginPos) / self.warTT;
    self.flyEndHandler = endHandler;
end

function _CIconCell:Update(dt)
    if self.isFly then
        self.warETime = self.warETime + dt;
        if self.warETime >= self.warTT + 0.3 then
            self.warEObj:SetActive(false);
            self.isFly = false;
            if self.flyEndHandler then
                self.flyEndHandler();
            end
        else
            if self.warETime >= self.warTT then
                self.warEObj.transform.position = self.targetPos;
            else
                self.warEObj.transform.position = self.beginPos:Clone() + self.speed:Clone() * self.warETime;
            end
        end
    end
    if self.isChangeColor then
        self.alpha = self.alpha - 0.85 * dt;
        if self.alpha <= 0 then
            self.isChangeColor = false;
            self.alpha = 0;
            self.gameObject:SetActive(false);
            if self.showHandler then
                self.showHandler();
            end
        end
        self.image.color = { r = 1, g = 1, b = 1, a = self.alpha };
    end
    if self.effectTime > 0 then
        self.effectTime = self.effectTime - dt;
        if self.effectTime < 0 then
            self.effectObj:SetActive(false);
        end
    end
    if self.isShake then
        --
        self.alpha = self.alpha + self.shakeAdd * 1.2 * dt;
        if self.alpha >= 1 then
            self.shakeAdd = -self.shakeAdd;
            self.alpha = 1;
            self.shakeCount = self.shakeCount + 1;
            if self.shakeCount >= 4 then
                self.isShake = false;
            end
        elseif self.alpha <= 0.5 then
            self.shakeAdd = -self.shakeAdd;
            self.alpha = 0.5;
        end
        self.image.color = { r = 1, g = 1, b = 1, a = self.alpha };
    end
end

local BUTTON_TYPE = {
    Btn_Null = 0,
    Btn_UpScore = 1,
};

local LongPressItem = class("LongPressItem");
--
function LongPressItem:ctor()
    self.isDown = false;
    self.pressTime = 0;
    self.btnType = BUTTON_TYPE.Btn_Null;
    self.isLongPress = false;
    self.longHandler = nil;
    self.shortHandler = nil;
    self.count = 0; --执行次数
    self.longKeyTime = 0;
    self.intervalTime = 0;
end

function LongPressItem:Init(_type, longPressTime, intervalTime, longPressHandler, shortPressHandler)
    self.longPressTime = longPressTime or 0; --长按键时间
    self.intervalTime = intervalTime or 0; --周期时间
    self.btnType = _type;
    self.longHandler = longPressHandler;
    self.shortHandler = shortPressHandler;
    self.isDown = true;
    self.pressTime = 0;
    self.isLongPress = false;
end

function LongPressItem:Update(_dt)
    --不是长按状态
    if not self.isDown then
        return ;
    end
    self.pressTime = self.pressTime + _dt;
    if self.isLongPress then
        if self.pressTime >= self.intervalTime then
            self.pressTime = self.pressTime - self.intervalTime;
            if self.longHandler then
                self.longHandler(self.btnType, self.count);
            end
            self.count = self.count + 1;
        end
    else
        if self.pressTime >= self.longPressTime then
            self.pressTime = self.pressTime - self.longPressTime;
            self.isLongPress = true;
            if self.longHandler then
                self.longHandler(self.btnType, self.count);
            end
            self.count = self.count + 1;
        end
    end
end

function LongPressItem:Stop()
    self.isDown = false;
    if not self.isLongPress then
        if self.shortHandler then
            self.shortHandler(self.btnType);
        end
    end
    self.isLongPress = false;
    return self;
end

function LongPressItem:IsInvalid()
    return self.isDown == false;
end

local LongPressControl = class("LongPressControl");

function LongPressControl:ctor()
    self._itemMap = map:new();
    self._delList = vector:new();
end

--开始
-- @longPressTime 长按时间
-- @intervalTime 周期频率
-- @longPressHandler 长按事件
-- @shortPressHandler 短按事件 
function LongPressControl:Start(_type, longPressTime, intervalTime, longPressHandler, shortPressHandler)
    local item = LongPressItem.New();
    item:Init(_type, longPressTime, intervalTime, longPressHandler, shortPressHandler);
    self._itemMap:insert(_type, item);
    return self;
end

--停止
function LongPressControl:Stop(_type)
    local item = self._itemMap:value(_type);
    if item then
        item:Stop();
    end
    self._delList:push_back(_type);
    return self;
end

--执行 
function LongPressControl:Execute(_dt)
    local it = self._delList:iter();

    local val = it();
    while (val) do
        self._itemMap:erase(val);
        val = it();
    end

    it = self._itemMap:iter();
    val = it();
    self._delList:clear();
    local item;
    while (val) do
        item = self._itemMap:value(val);
        if not item:IsInvalid() then
            item:Update(_dt);
        end
        val = it();
    end
end

local idCreator = ID_Creator(1);

local Enum_RunMode = {
    HandMode = idCreator(0), --手动模式
    AutoMode = idCreator(), --自动模式
};
local Enum_RunContent = {
    Normal = idCreator(0),
    PlayingGame = idCreator(),
    AutoGame = idCreator(),
    FreeGame = idCreator(),
    BallGame = idCreator(),
};
local Enum_RunStep = {
    Null = idCreator(0),
    Scroll = idCreator(), --1正在滚动
    Wait = idCreator(), --2显示一会儿
    CMulEffect = idCreator(), --3获得倍率
    MulEffect = idCreator(), --4倍率特效
    GetMultiple = idCreator(), --5获得免费倍率
    CSuperEffect = idCreator(), --6等待超级大奖检测
    SuperEffect = idCreator(), --7超级大奖
    CWholeEffect = idCreator(), --8全盘奖或者，彩金
    WholeEffect = idCreator(), --9全盘奖
    GetWholeValue = idCreator(), --10增加金币到我的金币里和本局盈利里
    EWhole = idCreator(), --11全盘奖结束，等待一会儿进入
    CFlashIcon = idCreator(), --12
    FlashIcon = idCreator(), --13
    CFightCell = idCreator(), --14等待占领格子
    FightCell = idCreator(), --15占领格子
    CFlyEffect = idCreator(), --16等待飞
    FlyEffect = idCreator(), --17飞效果
    NBalance = idCreator(), --18普通结算
    GetNumber = idCreator(), --19获得金币
    EGetNumber = idCreator(), --20获得金币结束
    CAddFree = idCreator(), --21等待检测增加免费次数
    AddFree = idCreator(), --22增加免费次数
    AddFBalance = idCreator(), --23获得免费次数结算
    EAddFBalance = idCreator(), --24增加免费次数结束
    CWarGame = idCreator(), --25检测是否征战游戏
    BeginWarGame = idCreator(), --26开始征战游戏
    Yitong = idCreator(), --27一统天下
    Daizi = idCreator(), --28袋子
    WarGame = idCreator(), --29征战游戏
    WarBigBalance = idCreator(), --30征战大奖结算
    WarBalance = idCreator(), --31征战结算
    CFreeGame = idCreator(), --32闪烁免费游戏图标
    FreeGame = idCreator(), --33闪烁免费游戏图标
    FBalance = idCreator(), --34显示免费结算
    EFBalance = idCreator(), --35免费结算后
    FreeTotal = idCreator(), --36免费统计
};
local Enum_RunState = {
    Null = 0,
    PlayingGame = 1,
    OtherGame = 2,
};
local Enum_StartStatus = {
    Normal = 1,
    Auto = 2,
    Free = 3,
};
local _numNumber1 = "number1";
local _numNumber2 = "number2";
local _numNumber3 = "number3";
local _numNumber4 = "number4";
local _numNumber5 = "number5";
local _numNumber6 = "number6";
local _numNumber7 = "number7";
local _numNumber8 = "number8";
local _numNumber9 = "number9";
local _numNumber10 = "number10";
local _numNumber11 = "bignum";

local EnumPos = {
    LT = 1,
    LD = 2,
    CT = 3,
    CD = 4,
    RT = 5,
    RD = 6,
};
local selfHandler = Tools.Handler.Create;
local __EventAreaAction = {
    AddMultiple = 1,
    AddCount = 2,
    AddGold = 3,
    EndEvent = 4,
};
local _CMiniGameAreaAction = class("_CMiniGameAreaAction", _CEventObject);
function _CMiniGameAreaAction:ctor()
    _CMiniGameAreaAction.super.ctor(self);
    self.clrTemp = COLORNEW(1, 1, 1, 1);
end
function _CMiniGameAreaAction:Init(area)
    self.runTime = 0;
    self.area = area;
    self.itemIndex = 1;
    self.areaA = 0;
    self.itemA = 0;
    self.isReady = false;
    self.step = 1;
    self.shakeCount = 1;
    self.maxShakeCount = 3;
    self.image = area.image;
end

function _CMiniGameAreaAction:Update(_dt)
    if self.step == 1 then
        --点击事件
        self.runTime = self.runTime + _dt;
        self.areaA = self.runTime * 3.5;
        if (self.areaA >= 1) then
            self.areaA = 1;
            self.step = 2;
            self.runTime = 0;
        end
        self.clrTemp.a = self.areaA;
        self.image.color = self.clrTemp;
    elseif self.step == 2 then
        self.runTime = self.runTime + _dt;
        if self.runTime >= 0.2 then
            self.runTime = 0;
            if self.areaA == 1 then
                self.areaA = 0.3;
            else
                self.areaA = 1;
                self.shakeCount = self.shakeCount + 1;
                if self.shakeCount >= self.maxShakeCount then
                    self.step = 3;
                    self.runTime = 0;
                end
            end
            self.clrTemp.a = self.areaA;
            self.image.color = self.clrTemp;
        end
    elseif self.step == 3 then
        if self.isReady then
            self.step = 4;
            self.runTime = 0;
        end
    elseif self.step == 4 then
        self.runTime = self.runTime + _dt;
        self.itemA = self.itemA + _dt * 3;
        if self.itemA >= 1 then
            local item = self.area.items[self.itemIndex];
            item.item:SetAlpha(1);
            self:SendEvent(item.et, item.value);
            self.itemIndex = self.itemIndex + 1;
            if self.itemIndex <= #self.area.items then
                self.itemA = 0;
            else
                self.step = 5;
            end
        else
            self.area.items[self.itemIndex].item:SetAlpha(self.itemA);
        end
    end
end

function _CMiniGameAreaAction:OnReady()
    self.isReady = true;
end

function _CMiniGameAreaAction:IsOver()
    return self.step == 5;
end

local idC = ID_Creator(1);

local _CMiniGameAddNumber = class("_CMiniGameAddNumber", _CEventObject);
function _CMiniGameAddNumber:ctor(atlasNumber)
    _CMiniGameAddNumber.super.ctor(self);
    self.alpha = 1;
    self.isOver = true;
    self.event = 0;
    self.beforeNumber = 0;
    self.totalNumber = 0;
    self.runTime = 0;
    self.atlasNumber = atlasNumber;
end
function _CMiniGameAddNumber:Init(event, number, time)
    self.aspeed = 0.6 / time;
    self.event = event;
    self.totalNumber = number;
    self.nspeed = (number + 3) / time;
    self.isOver = false;
    self.atlasNumber:SetAlpha(1);
    self.atlasNumber:Show();
    self.runTime = 0;
    self.beforeNumber = 0;
    self.id = idC();
end
function _CMiniGameAddNumber:SetParent(parent)
    self.atlasNumber:SetParent(parent);
    return self;
end
function _CMiniGameAddNumber:SetLocalPosition(position)
    self.atlasNumber:SetLocalPosition(position);
    return self;
end
function _CMiniGameAddNumber:Update(_dt)
    if self.isOver then
        return ;
    end
    self.runTime = self.runTime + _dt;
    self.alpha = 1 - self.aspeed * self.runTime;
    local num = math.ceil(self.nspeed * self.runTime);
    if (num >= self.totalNumber) then
        num = self.totalNumber;
    end
    local disNum = num - self.beforeNumber;
    self.beforeNumber = num;
    if disNum > 0 then
        self:SendEvent(self.event, disNum);
    end
    if self.alpha <= 0 then
        self.alpha = 0;
        self.isOver = true;
        self.atlasNumber:Hide();
    end
    self.atlasNumber:SetAlpha(self.alpha);
end
function _CMiniGameAddNumber:SetNumber(number)
    self.atlasNumber:SetNumber(number);
    return self;
end
function _CMiniGameAddNumber:SetNumString(numstr)
    self.atlasNumber:SetNumString(numstr);
    return self;
end
function _CMiniGameAddNumber:IsOver()
    return self.isOver;
end

local _CMiniGame = {
};

_CMiniGame = class("MiniGame", _CEventObject);

function _CMiniGame:ctor()
    _CMiniGame.super.ctor(self);
    self.warCount = 0;
    self.maxW = 1024;
    self.clickedSeq = {};
    self.posTemp = { x = 0, y = 0, z = 0 };
    self.clrTemp = { r = 1, g = 1, b = 1, a = 1 };
    self.itemCaches = {};
    self.itemAbnormalCaches = {};
    self.areaActions = {};
    self.isAuto = false;
    self.autoTime = 0;
end

function _CMiniGame:Init(transform)
    self.transform = transform;
    self.gameObject = transform.gameObject;
    self.canvasGroup = self.transform:GetComponent("CanvasGroup");
    --self.canvasGroup.alpha = 0.5;
    self.content = transform:Find("Content");
    self.bg = transform:Find("BG"):GetComponent("Image");

    self.transform:Find("BG"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
    self.transform:Find("Balance/Mask"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);

    self.rectTransform = self.content:GetComponent("RectTransform");
    self.scrollRight = transform:Find("ScrollRight");
    self.scrollLeft = transform:Find("ScrollLeft");
    self.scrollRightImage = self.scrollRight:GetComponent("Image");
    self.scrollLeftImage = self.scrollLeft:GetComponent("Image");
    self.areas = {};
    self.clickArea = self.content:Find("ClickArea");
    self.clickAreaImage = self.clickArea:GetComponent("Image");
    self.displayArea = self.content:Find("DisplayArea");
    self.resultAreas = self.content:Find("Results");
    self.bgAlpha = 0;
    self.scrollAlpha = 0;
    self.abnormalAlpha = 0;
    self.moveDis = 0;
    self.runTime = 0;
    self.scrollBeginPos = { x = 0, y = 0, z = 0 };
    local pos = self.scrollRight.localPosition;
    self.scrollBeginPos.x = pos.x;
    self.scrollBeginPos.y = pos.y;
    self.scrollBeginPos.z = pos.z;

    local childCount = self.clickArea.childCount;
    local area;

    for i = 1, childCount do
        area = {};
        area.cimage = self.clickArea:GetChild(i - 1):GetComponent("Image");
        area.cgameobject = area.cimage.gameObject;
        area.cimage.alphaHitTestMinimumThreshold = 0.1;
        area.image = self.displayArea:GetChild(i - 1):GetComponent("Image");
        area.result = self.resultAreas:GetChild(i - 1);
        area.items = {};
        area.isClicked = false;
        self.areas[i] = area;
        LuaTools.AddClick(area.cgameobject, selfHandler(self, self._onClickPos, i));
    end
    self.step = 0;
    self.shakeCount = 0;
    self.uiGold = 0;
    self.uiCount = 0
    self.uiMultiple = 0;

    local multiple = self.content:Find("Multiple");
    self.multipleNumber = CAtlasNumber.CreateWithGroupName(_numNumber7, -7):SetSpace(8):SetParent(multiple:Find("Number"));
    self.addMultiple = self.content:Find("MultipleAddNumber");
    self.countNumber = CAtlasNumber.CreateWithGroupName(_numNumber6, -2):SetParent(self.content:Find("LeftCount"):Find("Number"));
    self.addCount = self.content:Find("CountAddNumber");
    self.warGoldNumber = self.content:Find("GoldNumber"):GetComponent("Text");
    local warGoldNumber = self.warGoldNumber;
    warGoldNumber.enabled = false;
    self.warGoldNumber = CAtlasNumber.CreateWithGroupName(_numNumber3, -3):SetParent(self.warGoldNumber.transform):SetLocalScale({ x = 0.7, y = 0.7, z = 0.7 });
    self.addGold = self.content:Find("GoldAddNumber");
    --增加数字
    self.addNumberActions = {};
    --
    self.getTip = self.content:Find("GetTip");
    self.getTipObject = self.getTip.gameObject;
    self.getTipObject:SetActive(false);
    self.sepNumber = CAtlasNumber.CreateWithGroupName(_numNumber9, 0):SetParent(self.getTip:Find("Multiple"));
    self.tipTime = 0;
    self.balance = self.transform:Find("Balance");
    self.balanceObj = self.balance.gameObject;
    self.balanceGroup = self.balance:GetComponent("CanvasGroup");
    self.balanceMask = self.balance:Find("Mask");
    local number = self.balance:Find("Number");
    self.balanceNumber = CAtlasNumber.New(_numNumber5, 0):SetParent(number);
    self.balanceObj:SetActive(false);
end

--开始函数
function _CMiniGame:Start(autoTime)
    self.isClicked = false;
    self.isPrepared = false;
    self.step = 1;
    self.clrTemp.a = 0;
    self.scrollAlpha = 0;
    self.bgAlpha = 0;
    self.bg.color = self.clrTemp;
    self.scrollLeftImage.color = self.clrTemp;
    self.scrollRightImage.color = self.clrTemp;
    self.clickAreaImage.color = self.clrTemp;
    --设置地图大小
    self.mapW = 270;
    self:_setMapSize(self.mapW);
    local count = #self.areas;
    local area;
    for i = 1, count do
        area = self.areas[i];
        area.image.color = self.clrTemp;
        area.cgameobject:SetActive(true);
        local items = area.items;
        local icount = #items;
        if area.isClicked then
            --放进缓存里
            for j = 1, icount do
                items[j].item:SetParent(_v_ui_cachePool);
                table.insert(self.itemCaches, items[j].item);
            end
        else
            --放进缓存里
            for j = 1, icount do
                items[j].item:SetParent(_v_ui_cachePool);
                table.insert(self.itemAbnormalCaches, items[j].item);
            end
        end
        area.items = {};
        --设置图片区域
        area.cimage.color = Color.New(1, 1, 1, 0);
    end
    self.areaA = 0;
    self.gameObject:SetActive(true);
    --设置特奖
    self.sepNumber:SetNumString("x" .. GameDefine.GetSepMultiple());
    --显示全部的结果
    self.abnormalAlpha = 0;
    self.runTime = 0;
    --自动时间
    self.autoTime = autoTime;
    --开始
    self:_onStart();
end

function _CMiniGame:_setMapSize(w)
    local x = -w * 0.5 - self.scrollBeginPos.x;
    self:_changeContentSize(w);
    self.posTemp.x = x;
    self.posTemp.y = self.scrollBeginPos.y;
    self.posTemp.z = self.scrollBeginPos.z;
    self.scrollLeft.localPosition = self.posTemp;
    self.posTemp.x = -x;
    self.posTemp.y = self.scrollBeginPos.y;
    self.posTemp.z = self.scrollBeginPos.z;
    self.scrollRight.localPosition = self.posTemp;
end

function _CMiniGame:_changeContentSize(w)
    self.rectTransform.sizeDelta = Vector2.New(w + 10, 750);
end

function _CMiniGame:_pushAddAction(_eventID, value)
    local count = #self.addNumberActions;
    local action;
    for i = 1, count do
        if self.addNumberActions[i]:IsOver() then
            action = self.addNumberActions[i];
        end
    end
    if action == nil then
        local number = CAtlasNumber.CreateWithGroupName(_numNumber8, -3, HorizontalAlignType.Left):SetLocalScale(Vector3.New(0.4, 0.4, 0.4));
        action = _CMiniGameAddNumber.New(number);
        action:RegEvent(self, self._onEventAddNumber);
        table.insert(self.addNumberActions, action);
    end
    if _eventID == __EventAreaAction.AddGold then
        action:Init(_eventID, value, 0.5);
        action:SetParent(self.addGold):SetLocalPosition(Vector3.zero):SetNumString("+" .. value);
    elseif _eventID == __EventAreaAction.AddCount then
        action:Init(_eventID, value, 0.5);
        action:SetParent(self.addCount):SetLocalPosition(Vector3.zero):SetNumString("+" .. value);
    elseif _eventID == __EventAreaAction.AddMultiple then
        if self.isReduceMultiple then
            action:Init(_eventID, value - 1, 0.5);
            self.isReduceMultiple = false;
        else
            action:Init(_eventID, value, 0.5);
        end
        action:SetParent(self.addMultiple):SetLocalPosition(Vector3.zero):SetNumString("x" .. value);
    end
end

--结束函数
function _CMiniGame:Over()
    self.gameObject:SetActive(false);
end

--
function _CMiniGame:WarBigBalanceEnd()
    self:SendEvent(EnumEvent.MiniGameBalance);
end

function _CMiniGame:_randomFight()
    if self.uiCount <= 0 then
        return false;
    end
    local count = #self.areas;
    local seq = {};
    for i = 1, count do
        if not self.areas[i].isClicked then
            seq[#seq + 1] = i;
        end
    end
    local index = math.random(1, #seq);
    self:_fightPos(seq[index]);
end

function _CMiniGame:_createItem(_type, _value)
    local count = #self.itemCaches;
    local item;
    if count > 0 then
        item = table.remove(self.itemCaches);
    else
        item = CAtlasNumber.CreateWithGroupName(_numNumber8, -3);
    end
    if _type == EnumSmallGameRet.EM_SmallGame_Gold then
        item:SetNumString("+" .. _value);
    elseif _type == EnumSmallGameRet.EM_SmallGame_Add2 then
        item:SetNumString("z+2");
    elseif _type == EnumSmallGameRet.EM_SmallGame_Add3 then
        item:SetNumString("z+3");
    elseif _type == EnumSmallGameRet.EM_SmallGame_X2 then
        item:SetNumString("jx2");
    elseif _type == EnumSmallGameRet.EM_SmallGame_X3 then
        item:SetNumString("jx3");
    elseif _type == EnumSmallGameRet.EM_SmallGame_X10 then
        item:SetNumString("jx10");
    elseif _type == EnumSmallGameRet.EM_SmallGame_XMax then
        item:SetNumString("jx" .. GameDefine.GetSepMultiple());
    end
    return item;
end

function _CMiniGame:_createResults(area, _type, _value)
    if _type == EnumSmallGameRet.EM_SmallGame_Gold then
        local item = self:_createItem(_type, _value):SetParent(area.result):SetAlpha(0);
        area.items[1] = { item = item, et = __EventAreaAction.AddGold, value = _value };
    else
        local item = self:_createItem(_type, _value):SetParent(area.result):SetLocalPosition(VECTOR3NEW(0, 16, 0));
        if _type == EnumSmallGameRet.EM_SmallGame_Add2 then
            area.items[1] = { item = item, et = __EventAreaAction.AddCount, value = 2 };
        elseif _type == EnumSmallGameRet.EM_SmallGame_Add3 then
            area.items[1] = { item = item, et = __EventAreaAction.AddCount, value = 3 };
        elseif _type == EnumSmallGameRet.EM_SmallGame_X2 then
            area.items[1] = { item = item, et = __EventAreaAction.AddMultiple, value = 2 };
        elseif _type == EnumSmallGameRet.EM_SmallGame_X3 then
            area.items[1] = { item = item, et = __EventAreaAction.AddMultiple, value = 3 };
        elseif _type == EnumSmallGameRet.EM_SmallGame_X10 then
            area.items[1] = { item = item, et = __EventAreaAction.AddMultiple, value = 10 };
        elseif _type == EnumSmallGameRet.EM_SmallGame_XMax then
            area.items[1] = { item = item, et = __EventAreaAction.AddMultiple, value = GameDefine.GetSepMultiple() };
            self.getTipObject:SetActive(true);
            self.tipTime = 3.6;
            self.tipScale = 0.3;
            self.isTipScale = true;
            self.getTip.localScale = { x = self.tipScale, y = self.tipScale, z = self.tipScale };
        end
        item:SetAlpha(0);
        item = self:_createItem(EnumSmallGameRet.EM_SmallGame_Gold, _value):SetParent(area.result):SetLocalPosition(VECTOR3NEW(0, -16, 0));
        area.items[2] = { item = item, et = __EventAreaAction.AddGold, value = _value };
        item:SetAlpha(0);
    end
end
local __item_norcolor = Color.New(1, 1, 1, 1);

function _CMiniGame:_createResultsNoAction(area, _type, _value)
    if _type == EnumSmallGameRet.EM_SmallGame_Gold then
        local item = self:_createItem(_type, _value):SetParent(area.result):SetAlpha(1);
        area.items[1] = { item = item, et = __EventAreaAction.AddGold, value = _value };
        area.image.color = __item_norcolor;
    else
        local item = self:_createItem(_type, _value):SetParent(area.result):SetLocalPosition(VECTOR3NEW(0, 16, 0));
        if _type == EnumSmallGameRet.EM_SmallGame_Add2 then
            area.items[1] = { item = item, et = __EventAreaAction.AddCount, value = 2 };
        elseif _type == EnumSmallGameRet.EM_SmallGame_Add3 then
            area.items[1] = { item = item, et = __EventAreaAction.AddCount, value = 3 };
        elseif _type == EnumSmallGameRet.EM_SmallGame_X2 then
            area.items[1] = { item = item, et = __EventAreaAction.AddMultiple, value = 2 };
        elseif _type == EnumSmallGameRet.EM_SmallGame_X3 then
            area.items[1] = { item = item, et = __EventAreaAction.AddMultiple, value = 3 };
        elseif _type == EnumSmallGameRet.EM_SmallGame_X10 then
            area.items[1] = { item = item, et = __EventAreaAction.AddMultiple, value = 10 };
        elseif _type == EnumSmallGameRet.EM_SmallGame_XMax then
            area.items[1] = { item = item, et = __EventAreaAction.AddMultiple, value = GameDefine.GetSepMultiple() };
        end
        item:SetAlpha(1);
        item = self:_createItem(EnumSmallGameRet.EM_SmallGame_Gold, _value):SetParent(area.result):SetLocalPosition(VECTOR3NEW(0, -16, 0));
        area.items[2] = { item = item, et = __EventAreaAction.AddGold, value = _value };
        item:SetAlpha(1);
        area.image.color = __item_norcolor;
    end
end

local __item_abcolor = Color.New(9 / 255, 101 / 255, 39 / 255, 1);

function _CMiniGame:_createAbnormalItem(_type, _value)
    local count = #self.itemAbnormalCaches;
    local item;
    if count > 0 then
        item = table.remove(self.itemAbnormalCaches);
    else
        item = CAtlasNumber.CreateWithGroupName(_numNumber8, -3);
        item:SetColor(__item_abcolor);
    end
    if _type == EnumSmallGameRet.EM_SmallGame_Gold then
        item:SetNumString("+" .. _value);
    elseif _type == EnumSmallGameRet.EM_SmallGame_Add2 then
        item:SetNumString("z+2");
    elseif _type == EnumSmallGameRet.EM_SmallGame_Add3 then
        item:SetNumString("z+3");
    elseif _type == EnumSmallGameRet.EM_SmallGame_X2 then
        item:SetNumString("jx2");
    elseif _type == EnumSmallGameRet.EM_SmallGame_X3 then
        item:SetNumString("jx3");
    elseif _type == EnumSmallGameRet.EM_SmallGame_X10 then
        item:SetNumString("jx10");
    elseif _type == EnumSmallGameRet.EM_SmallGame_XMax then
        item:SetNumString("jx" .. GameDefine.GetSepMultiple());
    end
    return item;
end

function _CMiniGame:_createAbnormalResults(area, _type, _value)
    if _type == EnumSmallGameRet.EM_SmallGame_Gold then
        local item = self:_createAbnormalItem(_type, _value):SetParent(area.result):SetAlpha(0);
        area.items[1] = { item = item, et = __EventAreaAction.AddGold, value = _value };
        area.cimage.color = Color.New(1, 1, 1, 0.48);
    else
        local item = self:_createAbnormalItem(_type, _value):SetParent(area.result):SetLocalPosition(VECTOR3NEW(0, 16, 0)):SetAlpha(0);
        if _type == EnumSmallGameRet.EM_SmallGame_Add2 then
            area.items[1] = { item = item, et = __EventAreaAction.AddCount, value = 2 };
        elseif _type == EnumSmallGameRet.EM_SmallGame_Add3 then
            area.items[1] = { item = item, et = __EventAreaAction.AddCount, value = 3 };
        elseif _type == EnumSmallGameRet.EM_SmallGame_X2 then
            area.items[1] = { item = item, et = __EventAreaAction.AddMultiple, value = 2 };
        elseif _type == EnumSmallGameRet.EM_SmallGame_X3 then
            area.items[1] = { item = item, et = __EventAreaAction.AddMultiple, value = 3 };
        elseif _type == EnumSmallGameRet.EM_SmallGame_X10 then
            area.items[1] = { item = item, et = __EventAreaAction.AddMultiple, value = 10 };
        elseif _type == EnumSmallGameRet.EM_SmallGame_XMax then
            area.items[1] = { item = item, et = __EventAreaAction.AddMultiple, value = GameDefine.GetSepMultiple() };
        end
        item = self:_createAbnormalItem(EnumSmallGameRet.EM_SmallGame_Gold, _value):SetParent(area.result):SetLocalPosition(VECTOR3NEW(0, -16, 0)):SetAlpha(0);
        area.items[2] = { item = item, et = __EventAreaAction.AddGold, value = _value };
        area.cimage.color = Color.New(1, 1, 1, 0.48);
    end
end

function _CMiniGame:Update(_dt)
    if self.step == 0 then
        --什么都不做
        -- 步骤1 到步骤3 是开场动画
    elseif self.step == 1 then
        self.runTime = self.runTime + _dt;
        self.bgAlpha = self.bgAlpha + _dt * 3.5;
        if self.bgAlpha >= 1 then
            self.bgAlpha = 1;
            self.step = 3;
            self.runTime = 0;
        end
        self.clrTemp.a = self.bgAlpha;
        self.bg.color = self.clrTemp;
    elseif self.step == 2 then
        self.runTime = self.runTime + _dt;
        if self.runTime >= 0.1 then
            self.step = 3;
            self.runTime = 0;
        end
    elseif self.step == 3 then
        self.runTime = self.runTime + _dt;
        self.scrollAlpha = self.scrollAlpha + _dt * 1.2;
        if self.scrollAlpha >= 1 then
            self.step = 4;
            self.runTime = 0;
        end
        self.clrTemp.a = self.scrollAlpha;
        self.scrollRightImage.color = self.clrTemp;
        self.scrollLeftImage.color = self.clrTemp;
        self.clickAreaImage.color = self.clrTemp;
    elseif self.step == 4 then
        self.runTime = self.runTime + _dt;
        if self.runTime >= 0.15 then
            self.step = 5;
            self.runTime = 0;
        end
    elseif self.step == 5 then
        self.runTime = self.runTime + _dt;
        self.mapW = self.mapW + _dt * 400;
        if self.mapW >= self.maxW then
            self.step = 6; --开场动画结束
            self.mapW = self.maxW;
            self.isPrepared = true;
        end
        self:_setMapSize(self.mapW);
    elseif self.step == 6 then
        if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then
            if GameManager.IsStopGame then
                return
            end
            if isInitOver == false then
                return
            end
            local isActionFinished = true;
            local count = #self.areaActions;
            local areaAction;
            local dCount;

            if self.isAuto then
                self.autoTime = self.autoTime - _dt;
                if self.autoTime <= 0 then
                    if not self.isClicked then
                        --随机点击
                        self:_randomFight();
                    end
                end
            else
                self.autoTime = self.autoTime - _dt;
                if self.autoTime <= 0 then
                    self.isAuto = true;
                    --随机点击
                    self:_randomFight();
                end
            end

            for i = 1, count do
                self.areaActions[i]:Update(_dt);
            end

            for i = 1, count do
                if self.areaActions[i]:IsOver() then
                    table.remove(self.areaActions, i);
                    break ;
                end
            end

            if #self.areaActions > 0 then
                isActionFinished = false;
            end

            --加数字动画
            count = #self.addNumberActions;
            for i = 1, count do
                self.addNumberActions[i]:Update(_dt);
                if not self.addNumberActions[i]:IsOver() then
                    isActionFinished = false;
                end
            end
            if self.tipTime > 0 then
                self.tipTime = self.tipTime - _dt;
                if self.isTipScale then
                    self.tipScale = self.tipScale + _dt * 1.5;
                    if self.tipScale >= 1 then
                        self.tipScale = 1;
                        self.isTipScale = false;
                    end
                    self.getTip.localScale = { x = self.tipScale, y = self.tipScale, z = self.tipScale };
                end
                if self.tipTime <= 0 then
                    self.getTipObject:SetActive(false);
                else
                    isActionFinished = false;
                end
            end
            if isActionFinished and not self.isClicked then
                --检测是否结束
                if self.clickAreaCount >= GameDefine.MapBlockCount() then
                    self.step = 9; --结束了
                    self.runTime = 0;
                elseif self.uiCount <= 0 then
                    self.step = 7; --展示其他的结束了
                    self.runTime = 0;
                end
            end

        end

    elseif self.step == 7 then
        --显示其他未征收区域的结果
        self.runTime = self.runTime + _dt;
        if self.runTime >= 0.5 then
            self:_showAbnormalResults();
            self.step = 8;
        end
    elseif self.step == 8 then
        self.abnormalAlpha = self.abnormalAlpha + _dt * 2;
        local count = #self.areas;
        local area;
        if self.abnormalAlpha > 1 then
            self.abnormalAlpha = 1;
            self.step = 9;
            self.runTime = 0;
        end
        for i = 1, count do
            area = self.areas[i];
            if not area.isClicked then
                local itemCount = #area.items;
                for j = 1, itemCount do
                    area.items[j].item:SetAlpha(self.abnormalAlpha);
                end
            end
        end
    elseif self.step == 9 then
        self.runTime = self.runTime + _dt;
        if self.runTime >= 1.5 then
            self:_onNotifyBalance();
            self.step = 0;
            self.runTime = 0;
        end
    end
end

function _CMiniGame:_onClickMask()
    self:_closeMask();
end

function _CMiniGame:_onClickPos(pos)
    if not self.isPrepared then
        return false;
    end
    if self.isClicked then
        return true;
    end
    if (self.areas[pos].isClicked) then
        return true;
    end
    if self.uiCount <= 0 then
        return false;
    end
    self:_fightPos(pos);
    --
    self.isAuto = false;
    self.autoTime = 30;
end

function _CMiniGame:_fightPos(pos)
    G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().Btn);
    --更新次数
    self.uiCount = self.uiCount - 1;
    self:_setCount(self.uiCount);
    --是否数据回来了
    self.isDataCB = false;
    self.isClicked = true;
    --目标
    self.target = pos;
    self.areaA = 0;
    self.runTime = 0;
    self.shakeCount = 0;
    --点击的区域个数
    self.clickAreaCount = self.clickAreaCount + 1;

    self:_pushToActions(self.areas[pos]);
    --通知开始区域

    --暂时不向服务器发送
    G_GlobalGame:DispatchEventByStringKey("ClickSmallGame", pos);
end

function _CMiniGame:_closeMask()

end

function _CMiniGame:_onStart()
    local _warCount, _gold, _warMultiple, _results = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetWarDetail);
    self.clickAreaCount = 0;
    self.uiGold = _gold;
    self.uiCount = _warCount;
    self.uiMultiple = _warMultiple;
    self.isReduceMultiple = true;
    --金币
    self:_setGold(self.uiGold);
    --个数
    self:_setCount(self.uiCount);
    --翻倍
    self:_setMultiple(self.uiMultiple);
    if self.uiMultiple ~= 1 then
        self.isReduceMultiple = false;
    end
    local area;
    local count = #self.areas;
    for i = 1, count do
        area = self.areas[i];
        if _results[i].valueT ~= EnumSmallGameRet.EM_SmallGame_Null then
            area.isClicked = true;
            self.clickAreaCount = self.clickAreaCount + 1;
            --已经点过了，直接创建
            self:_createResultsNoAction(area, _results[i].valueT, _results[i].value);

            if _results[i].valueT == EnumSmallGameRet.EM_SmallGame_X2 or
                    _results[i].valueT == EnumSmallGameRet.EM_SmallGame_X3 or
                    _results[i].valueT == EnumSmallGameRet.EM_SmallGame_X10 or
                    _results[i].valueT == EnumSmallGameRet.EM_SmallGame_XMax then
                self.isReduceMultiple = false;
            end

        else
            area.isClicked = false;
        end
    end
end

function _CMiniGame:OnDataCB(data)
    self.isDataCB = true;
    self.isClicked = false;
    local area = self.areas[self.target];
    area.isClicked = true;
    area.cgameobject:SetActive(false);
    self:_createResults(area, data.ret, data.addWarGold);
    self:_dataCallBackToAction();
    if self.isAuto then
        self.autoTime = 1; --一秒征收一个
    end
end

function _CMiniGame:_showAbnormalResults()
    local _warCount, _gold, _warMultiple, _results = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetWarDetail);
    local area;
    local count = #self.areas;
    for i = 1, count do
        area = self.areas[i];
        if not area.isClicked then
            self:_createAbnormalResults(area, _results[i].valueT, _results[i].value);
        end
    end
end

function _CMiniGame:_pushToActions(area)
    local areaAction = _CMiniGameAreaAction.New();
    areaAction:Init(area);
    --注册事件
    areaAction:RegEvent(self, self._onEventAreaAction);
    self.areaActions[#self.areaActions + 1] = areaAction;
end

function _CMiniGame:_dataCallBackToAction()
    self.areaActions[#self.areaActions]:OnReady();
end

function _CMiniGame:_onNotifyBalance()
    local _bet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetBet);
    local _getGold = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetSmallGameRet);

    if _bet * 600 <= _getGold then
        self:SendEvent(EnumEvent.MiniGameBigBalance);
    else
        self:SendEvent(EnumEvent.MiniGameBalance);
    end
end

function _CMiniGame:_onEventAddNumber(_eventID, _obj, _eventValue)
    if _eventID == __EventAreaAction.AddGold then
        self.uiGold = self.uiGold + _eventValue;
        self:_setGold(self.uiGold);
    elseif _eventID == __EventAreaAction.AddCount then
        self.uiCount = self.uiCount + _eventValue;
        self:_setCount(self.uiCount);
    elseif _eventID == __EventAreaAction.AddMultiple then
        self.uiMultiple = self.uiMultiple + _eventValue;
        self:_setMultiple(self.uiMultiple);
    end
end

function _CMiniGame:_setGold(gold)
    --self.warGoldNumber.text = tostring(gold);
    self.warGoldNumber:SetNumber(gold);
end

function _CMiniGame:_setCount(count)
    self.countNumber:SetNumber(count);
end

function _CMiniGame:_setMultiple(multiple)
    self.multipleNumber:SetNumString("x " .. multiple);
end

function _CMiniGame:_onEventAreaAction(_eventID, _obj, _eventValue)
    self:_pushAddAction(_eventID, _eventValue);
end

local Enum_BalanceType = {
    Common = 1,
    Cup = 2,
    Ball = 3,
};

local _CBalanceUI = class("CBalanceUI", _CEventObject);

function _CBalanceUI:ctor()
    _CBalanceUI.super.ctor(self);
end

function _CBalanceUI:Init(transform, uiAnimator)
    local can = CAtlasNumber.CreateWithGroupName;
    self.transform = transform;
    self.gameObject = transform.gameObject;
    self.uiAnimator = uiAnimator;
    self.isShowBig = false;
    --其他效果
    self.otherjiesuan = transform:Find("other_jiesuan");
    self.yitong = self.otherjiesuan:Find("yitong").gameObject;
    local daizi = self.otherjiesuan:Find("daizi");
    self.otherjiesuan.gameObject:SetActive(true);
    self.yitong:SetActive(false);
    daizi.gameObject:SetActive(false);
    self.daizi = {
        go = daizi.gameObject,
        number = can(_numNumber5, -4):SetParent(daizi:Find("numcount")),
    };
    local zz = self.otherjiesuan:Find("zhengzhan");
    zz.gameObject:SetActive(false);
    self.zhengzhan = {
        go = zz.gameObject,
        number = can(_numNumber5, -4):SetParent(zz:Find("numcount")),
    };

    local pt = self.otherjiesuan:Find("putong");
    pt.gameObject:SetActive(false);
    pt:Find("zhezhao").gameObject:SetActive(false);
    self.nBalance = {
        go = pt.gameObject,
        number = can(_numNumber5, -4):SetParent(pt:Find("numcount")):SetLocalScale({ x = 0.9, y = 0.9, z = 0.9 }),
    };

    local dajiang = transform:Find("dajiang");
    local tx, sx, sr, qk = dajiang:Find("tianxiawushuang"), dajiang:Find("suoxiangpimi"), dajiang:Find("shirupouzu"), dajiang:Find("qikaidesheng");
    self.dajiang = {
        go = dajiang.gameObject,
        levels = {
            [1] = { multiple = 1200, go = tx.gameObject, camera = tx:Find("AnimCamera"):GetComponent("Camera"), number = can(_numNumber11, -8):SetParent(tx:Find("numcount")), sp = 7, tt = 1.6, t1 = 5.2, t2 = 1.8, music = SoundDefine.EnumSound().TXWS, },
            [2] = { multiple = 1000, go = sx.gameObject, camera = sx:Find("AnimCamera"):GetComponent("Camera"), number = can(_numNumber11, -8):SetParent(sx:Find("numcount")), sp = 7, tt = 1, t1 = 3.5, t2 = 1.1, music = SoundDefine.EnumSound().SXPM, },
            [3] = { multiple = 800, go = sr.gameObject, camera = sr:Find("AnimCamera"):GetComponent("Camera"), number = can(_numNumber11, -8):SetParent(sr:Find("numcount")), sp = 7, tt = 1, t1 = 2.8, t2 = 1, music = SoundDefine.EnumSound().SRPZ, },
            [4] = { multiple = 600, go = qk.gameObject, camera = qk:Find("AnimCamera"):GetComponent("Camera"), number = can(_numNumber11, -8):SetParent(qk:Find("numcount")), sp = 7, tt = 1, t1 = 2.2, t2 = 0.85, music = SoundDefine.EnumSound().QKDS, },
        },
    };
    if G_GlobalGame.ConstantValue.IsPortrait then
        for i = 1, 4 do
            self.dajiang.levels[i].camera.transform.localEulerAngles = Quaternion.Euler(0, 0, 90);
        end
    else
        for i = 1, 4 do
            self.dajiang.levels[i].camera.transform.localEulerAngles = Quaternion.identity;
        end
    end


    --其他结算
    local balanceObj
    if G_GlobalGame.ConstantValue.IsPortrait then
        balanceObj = G_GlobalGame._goFactory:createBalanceShu();
    else
        balanceObj = G_GlobalGame._goFactory:createBalance();
    end

    balanceObj.transform:Find("Whole/jinbi_dajiang"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")

    balanceObj.transform:Find("Whole/caijinhuo"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Additive")
    balanceObj.transform:Find("Whole/caijinhuo/huo2"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Additive")
    balanceObj.transform:Find("Whole/caijinhuo/dian"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Additive")

    local balance = balanceObj.transform;
    balance:SetParent(transform);
    balance.localScale = Vector3.one;
    balance.localPosition = Vector3.zero;
    balance.localRotation = Quaternion.Euler(0, 0, 0);

    local wtransform = balance:Find("Whole");

    local other = wtransform:Find("other");
    self.sepBalance = {
        go = wtransform.gameObject, index = 0,
        objs = {
            other:Find("Caijin").gameObject,
            other:Find("Big").gameObject,
            other:Find("Mid").gameObject,
            other:Find("Small").gameObject,
            other:Find("Free").gameObject
        },

        numer = can(_numNumber5, -4):SetParent(other:Find("Number")),
    };
    --    local nt = balance:Find("Normal");
    --    self.nBalance = {
    --        go = nt.gameObject,
    --        number = can(_numNumber5,-4):SetParent(nt:Find("Number")):SetLocalScale({x=0.7,y=0.7,z=0.7}),
    --    };
    local af = balance:Find("AddFree");
    local number = af:Find("Number");
    self.addFree = {
        go = af.gameObject,
        number = can(_numNumber10, -4):SetParent(number),
        beginPos = number.localPosition,
        endPos = { x = 4, y = 3, z = 0 },
    };

    local gf = balance:Find("GetFree");
    local number = gf:Find("Number");
    self.getFree = {
        go = gf.gameObject,
        number = can(_numNumber10, -4):SetParent(number),
    };

    local am = balance:Find("AddMultiple");
    local number = am:Find("Number");
    number.localPosition = C_Vector3_Zero;
    self.addMul = {
        go = am.gameObject,
        number = can(_numNumber1, -2):SetParent(number),
    };

    self.isDisplay = false;
    self.isOver = true;
    self.curNumber = nil; --
    self.curObj = nil;
    self.curAni = nil;

    --用于自己增加数字用的
    self.stop1Number = 0;
    self.stop2Number = 0;
    self.numAddSpeed = 0;
    self.numAddSpeed2 = 0;
    self.numSpeed = 0;
    self.numTime1 = 0;
    self.numTime2 = 0;
    self.nstep = 0;
    self.numRunT = 0;
    self.lastNumber = 0;
    self.waitTime = 0;
    self.numBValue = 0;
    self.isAddNumber = false;
    self.balanceType = 0;
    self.runTime = 0;
    self.totalTime = 0;
    self.musicHanlder = nil;
    self.curStep = 1;
    self.isCustom = false;
end

function _CBalanceUI:Update(_dt)
    if not self.isDisplay or self.isOver then
        return ;
    end
    self.runTime = self.runTime + _dt;

    if self.isAddNumber then
        if self.waitTime > _dt then
            self.waitTime = self.waitTime - _dt;
            return ;
        end
        _dt = _dt - self.waitTime;
        self.waitTime = 0;
        self.numRunT = self.numRunT + _dt;
        if self.nstep == 1 then
            local value = math.ceil(self.numSpeed * self.numRunT + self.numAddSpeed * 0.5 * self.numRunT * self.numRunT);
            if value >= self.stop1Number then
                value = self.stop1Number;
            end
            if value + self.numBValue <= self.lastNumber then
                value = self.lastNumber - self.numBValue + 3;
            end
            if value >= self.stop1Number then
                value = self.stop1Number;
                self.nstep = 2;
                self.numRunT = 0;
                self.numSpeed = self.numAddSpeed * self.numTime1;
            end
            local diff = value + self.numBValue - self.lastNumber;
            if self.curNumber then
                self.curNumber:SetNumber(value + self.numBValue);
            end
            self.lastNumber = value + self.numBValue;
            if diff > 0 then
                self:SendEvent(EnumEvent.AddGold, diff);
            end
        elseif self.nstep == 2 then
            local value = math.ceil(self.numSpeed * self.numRunT + self.numAddSpeed2 * 0.5 * self.numRunT * self.numRunT) + self.stop1Number;
            if value >= self.stop2Number then
                value = self.stop2Number;
            end
            if value + self.numBValue <= self.lastNumber then
                value = self.lastNumber - self.numBValue + 3;
            end
            if value >= self.stop2Number then
                value = self.stop2Number;
                self.nstep = 3;
                self.numRunT = 0;
                self.isAddNumber = false;
            end
            if self.curNumber then
                self.curNumber:SetNumber(value + self.numBValue);
            end
            local diff = value + self.numBValue - self.lastNumber;
            self.lastNumber = value + self.numBValue;
            if diff > 0 then
                self:SendEvent(EnumEvent.AddGold, diff, self.nstep == 3);
            end
        end
    elseif self.isCustom then
        --自定义
        if self.customHanlder then
            self.customHanlder(self, _dt);
        end
    else
        if self.runTime >= self.totalTime then
            self.isOver = true;
            self:SendEvent(EnumEvent.BalanceOver);
        end
    end
end

function _CBalanceUI:ShowBigResult(_value, _bet)
    self:_reshow();
    self.numBValue = 0;
    self.numSpeed = 0;
    self.numRunT = 0;
    self.isShowBig = true;
    local level;
    local isFind, ret = false, nil;

    for i = 1, 4 do
        level = self.dajiang.levels[i];

        if not isFind then
            if (level.multiple * _bet <= _value) then
                isFind = true;
                ret = level;
                level.go:SetActive(true);
                if level.multiple == 600 then
                elseif level.multiple == 800 then
                    coroutine.start(self.SRPZ, level.go);
                elseif level.multiple == 1000 then
                    coroutine.start(self.SXPM, level.go);
                elseif level.multiple == 1200 then
                    coroutine.start(self.TXWS, level.go, self.dajiang.levels[2].go)
                    coroutine.start(self.SXPM, self.dajiang.levels[2].go);
                end
            else

                if _value < _bet * 1200 then
                    level.go:SetActive(false);
                end
            end
        else
            level.go:SetActive(false);
        end
    end

    if _value >= _bet * 1200 then
        self.dajiang.levels[2].go.transform:Find("AnimCamera").gameObject:SetActive(false)
        self.dajiang.levels[2].go:SetActive(true)
    end

    self.curObj = self.dajiang.go;
    self.curObj:SetActive(true);
    self.curNumber = ret.number;
    self:_countSpeed(_value, ret.sp, ret.t1, ret.t2);
    G_GlobalGame:ChangeCamera(ret.camera);
    self.uiAnimator.enabled = true;
    self.totalTime = ret.tt;
    self.curAni = self.uiAnimator;
    self.musicHanlder = G_GlobalGame._soundCtrl:PlaySound(ret.music);
end

function _CBalanceUI.SRPZ(go)
    local goanim = go.transform:GetComponent("Animator")
    if goanim then
        destroy(goanim)
    end
    local qkds = go.transform:Find("zi1")
    local srpz = go.transform:Find("zi2")
    local srpz_1 = srpz.transform:Find("zi2_1")
    go.transform:Find("baodian").gameObject:SetActive(false)
    qkds.gameObject:SetActive(true);
    qkds.localScale = Vector3.New(0.35, 0.35, 0.35)
    srpz:GetComponent("Image").color = Color.New(1, 1, 1, 0)
    srpz_1.gameObject:SetActive(false);

    local tweener_1 = qkds:DOScale(Vector3.New(1, 1, 1), 0.5)
    tweener_1:SetEase(DG.Tweening.Ease.Linear);
    coroutine.wait(1)

    qkds.gameObject:SetActive(false);
    local tweener_2 = srpz:GetComponent("Image"):DOColor(Color.New(1, 1, 1, 0.5), 0.7)
    tweener_2:SetEase(DG.Tweening.Ease.Linear);
    coroutine.wait(0.9)

    go.transform:Find("baodian").gameObject:SetActive(true)
    srpz_1.gameObject:SetActive(true);

    coroutine.wait(0.3)
    go.transform:Find("baodian").gameObject:SetActive(false)
end

function _CBalanceUI.SXPM(go)
    local goanim = go.transform:GetComponent("Animator")
    if goanim then
        destroy(goanim)
    end

    local qkds = go.transform:Find("zi1")
    local srpz = go.transform:Find("zi2")
    local srpz_1 = srpz.transform:Find("zi2_1")
    local sxpm_1 = go.transform:Find("zi3/zi3_2")
    local sxpm_2 = go.transform:Find("zi3/zi3_1")

    qkds.gameObject:SetActive(false);
    srpz_1.gameObject:SetActive(false);
    sxpm_1.gameObject:SetActive(false);
    sxpm_2.gameObject:SetActive(false);

    qkds.localScale = Vector3.New(0.35, 0.35, 0.35)
    srpz:GetComponent("Image").color = Color.New(1, 1, 1, 0)
    go.transform:Find("baodian").gameObject:SetActive(false)
    sxpm_1.transform.localPosition = Vector3.New(0, 159, 0)
    sxpm_2.transform.localPosition = Vector3.New(0, 159, 0)
    coroutine.wait(0.6)

    qkds.gameObject:SetActive(true);
    coroutine.wait(0.2)

    local tweener_1 = qkds:DOScale(Vector3.New(1, 1, 1), 0.3)
    tweener_1:SetEase(DG.Tweening.Ease.Linear);
    coroutine.wait(0.7)

    qkds.gameObject:SetActive(false);
    srpz.gameObject:SetActive(true);
    local tweener_2 = srpz:GetComponent("Image"):DOColor(Color.New(1, 1, 1, 0.5), 0.3)
    tweener_2:SetEase(DG.Tweening.Ease.Linear);
    coroutine.wait(0.8)

    go.transform:Find("baodian").gameObject:SetActive(true)
    srpz_1.gameObject:SetActive(true);
    coroutine.wait(0.9)

    srpz.gameObject:SetActive(false);
    sxpm_2.gameObject:SetActive(true);
    go.transform:Find("baodian").gameObject:SetActive(false)

    local tweener_3 = sxpm_2:DOLocalMove(Vector3.New(0, 230, 0), 0.7, false)
    tweener_3:SetEase(DG.Tweening.Ease.Linear);
    coroutine.wait(0.9)

    local tweener_4 = sxpm_2:DOLocalMove(Vector3.New(-193, 200, 0), 0.2, false)
    tweener_4:SetEase(DG.Tweening.Ease.Linear);
    coroutine.wait(0.4)

    sxpm_1.gameObject:SetActive(true);
    go.transform:Find("baodian").gameObject:SetActive(true)
    local tweener_5 = sxpm_1:DOLocalMove(Vector3.New(222, 200, 0), 0.1, false)
    tweener_5:SetEase(DG.Tweening.Ease.Linear);
    coroutine.wait(0.3)

    go.transform:Find("baodian").gameObject:SetActive(false)
end

function _CBalanceUI.TXWS(go1, go2)
    go1.transform:Find("zi1").gameObject:SetActive(false)
    go1.transform:Find("zi2").gameObject:SetActive(false)
    go1.transform:Find("zi3").gameObject:SetActive(false)
    go2.transform:Find("numcount").gameObject:SetActive(false)
    coroutine.wait(6.2)

    go2:SetActive(false)
    
    go2.transform:Find("AnimCamera").gameObject:SetActive(true)
    go2.transform:Find("numcount").gameObject:SetActive(true)

end


--普通奖
function _CBalanceUI:ShowResult(_value)
    self:_reshow();
    self.curObj = self.nBalance.go;
    if _value > 0 then
        self.curObj:SetActive(true);
    end
    self.curNumber = self.nBalance.number;
    --self:_countSpeed(_value,1,1.2,0.7);
    self.curNumber:SetNumber(_value);
    self.totalTime = 0.5;
end

function _CBalanceUI:ShowWholeResult(_value, _wholeType)
    local index = 0;
    if _wholeType == EnumWholeType.EM_WholeValue_Caijin then
        index = 1;
    elseif _wholeType == EnumWholeType.EM_WholeValue_Big then
        index = 2;
    elseif _wholeType == EnumWholeType.EM_WholeValue_Mid then
        index = 3;
    elseif _wholeType == EnumWholeType.EM_WholeValue_Small then
        index = 4;
    end
    self:_displaySep(index, _value);
end

function _CBalanceUI:_displaySep(index, _value)
    self:_reshow();
    local sepBalance = self.sepBalance;
    self.curObj = sepBalance.go;
    self.curObj:SetActive(true);
    local count = #sepBalance.objs;
    for i = 1, count do
        if i ~= index then
            sepBalance.objs[i]:SetActive(false);
        else
            sepBalance.objs[i]:SetActive(true);
        end
    end
    self.curNumber = self.sepBalance.numer;
    self.curNumber:SetNumber(_value);
    self.totalTime = 2;
    --只播放一次
    self.musicHanlder = G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().SepEffect);
end

function _CBalanceUI:ShowFreeTotal(_freeCount, _freeTotal, _totalTime)
    self:_displaySep(5, _freeTotal);
    if _totalTime ~= nil then
        self.totalTime = _totalTime;
    end
end

function _CBalanceUI:ShowAddMultiple(_addMultiple)
    self:_reshow();
    self.curObj = self.addMul.go;
    self.curObj:SetActive(true);
    self.curNumber = self.addMul.number;
    self.curNumber:SetNumString("x" .. _addMultiple);
    self.curNumber:Show();
    self.totalTime = 2.5;
    self.isCustom = true;
    local beginPos = { x = 20, y = 68, z = 0 };
    local endPos = { x = 20, y = 344, z = 0 };
    self.curNumber:SetLocalPosition(beginPos);
    local scale = 1.5;
    self.curNumber:SetLocalScale({ x = scale, y = scale, z = scale });
    --self.curNumber:SetLocalScale(C_Vector3_One);
    local moveTime = 0.9;
    local speed = { x = (endPos.x - beginPos.x) / moveTime, y = (endPos.y - beginPos.y) / moveTime, z = (endPos.z - beginPos.z) / moveTime };
    self.customHanlder = function(self, dt)
        self.runTime = self.runTime + dt;
        if self.runTime >= 1.4 then
            local curMoveTime = self.runTime - 1.4;
            if curMoveTime < moveTime then
                local x, y, z = beginPos.x + speed.x * curMoveTime, beginPos.y + speed.y * curMoveTime, beginPos.z + speed.z * curMoveTime;
                scale = scale - dt * 1.2;
                self.curNumber:SetLocalPosition({ x = x, y = y, z = z });
                self.curNumber:SetLocalScale({ x = scale, y = scale, z = scale });
            else
                self.curNumber:Hide();
                self.isOver = true;
                self:SendEvent(EnumEvent.BalanceOver);
            end
        end
    end
end

--显示增加免费
function _CBalanceUI:ShowAddFree(_freeCount)
    self:_reshow();
    self.curObj = self.addFree.go;
    self.curObj:SetActive(true);
    self.curNumber = self.addFree.number;
    self.curNumber:SetNumString("+" .. _freeCount);
    self.curNumber:Show();
    self.totalTime = 2.5;
    self.isCustom = true;
    local beginPos = { x = 15, y = 30, z = 0 };
    local endPos = { x = 538, y = -298, z = 0 };
    self.curNumber:SetLocalPosition(beginPos);
    self.curNumber:SetLocalScale(C_Vector3_One);
    local scale = 1;
    local path = ThrowPath.CreateWithTopY(beginPos.x, beginPos.y, endPos.x, endPos.y, beginPos.y + 45);
    local move = ThrowMove.New(path, beginPos, endPos, 0.8);
    self.customHanlder = function(self, dt)
        self.runTime = self.runTime + dt;
        if self.runTime >= 1.2 then
            local x, y, isOver = move:Step(dt);
            scale = scale - dt * 0.7;
            self.curNumber:SetLocalPosition({ x = x, y = y, z = 0 });
            self.curNumber:SetLocalScale({ x = scale, y = scale, z = scale });
            if isOver then
                --            self.curNumber:SetLocalPosition({x=x,y=y,z=0});
                --            self.curNumber:SetLocalScale({x=scale,y=scale,z=scale});
                self.curNumber:Hide();
                self.isOver = true;
                self:SendEvent(EnumEvent.BalanceOver);
            end
        end
    end
end

--显示获得免费
function _CBalanceUI:ShowGetFree(_freeCount)
    self:_reshow();
    self.curObj = self.getFree.go;
    self.curObj:SetActive(true);
    self.curNumber = self.getFree.number;
    self.curNumber:SetNumber(_freeCount);
    self.totalTime = 2;
    self.musicHanlder = G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().SepEffect);
end

function _CBalanceUI:ReduceNumber(number)
    self.lastNumber = self.lastNumber - number;
    if self.lastNumber < 0 then
        self.lastNumber = 0;
    end
    if self.curNumber then
        self.curNumber:SetNumber(self.lastNumber);
    end
end

function _CBalanceUI:_countSpeed(_value, _speed, _t1, _t2)
    local firstValue = math.ceil(_value * 3 / 4);
    local leftValue = _value - firstValue;
    self.stop1Number = firstValue;
    self.stop2Number = _value;
    self.lastNumber = 0;
    self.numAddSpeed = (firstValue - _speed * _t1) * 2 / (_t1 * _t1);
    self.numTime1 = _t1;
    self.numTime2 = _t2;
    local speedV0 = _speed + self.numAddSpeed * _t1;
    self.numAddSpeed2 = (leftValue + 2 - speedV0 * _t2) * 2 / (_t2 * _t2);
    if self.numAddSpeed2 < 0 then
        self.numAddSpeed2 = self.numAddSpeed2 * 4 * 0.2;
    end
    self.nstep = 1;
    self.isAddNumber = true;
end

--显示一统江湖
function _CBalanceUI:ShowBeginWar()
    self:_reshow();
    self.curObj = self.yitong;
    self.curNumber = nil;
    self.curObj:SetActive(true);
    self.totalTime = 2.8;
    --只播放一次
    self.musicHanlder = G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().BeginWar);
end

function _CBalanceUI:ShowDaizi(value)
    self:_reshow();
    self.curObj = self.daizi.go;
    self.curNumber = self.daizi.number;
    self.curNumber:SetNumber(value);
    self.curObj:SetActive(true);
    self.totalTime = 3.8;

    --只播放一次
    self.musicHanlder = G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().DaiZi);
end

function _CBalanceUI:ShowWarResult(value)
    self:_reshow();
    self.curObj = self.zhengzhan.go;
    self.curNumber = self.zhengzhan.number;
    self.curNumber:SetNumber(value);
    self.curObj:SetActive(true);
    self.totalTime = 4.5;
    --只播放一次
    self.musicHanlder = G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().SepEffect);
end

--清理
function _CBalanceUI:Clear()
    self.isDisplay = false;
    self:_clear();
    self.isAddNumber = false;
    self.runTime = 0;
end

function _CBalanceUI:_reshow()
    self:_clear();
    self.runTime = 0;
    self.totalTime = 99999;
    self.isDisplay = true;
    self.isOver = false
    return self;
end

function _CBalanceUI:_clear()
    if self.curObj ~= nil then
        self.curObj:SetActive(false);
    end
    if self.curAni ~= nil then
        self.curAni.enabled = false;
    end
    if self.musicHanlder then
        --G_GlobalGame._soundCtrl:StopSound(self.musicHanlder);
        self.musicHanlder = nil;
    end
    self.isAddNumber = false;
    self.isCustom = false;
    self.customHanlder = nil;
    if self.isShowBig then
        self.isShowBig = false;
        G_GlobalGame:RecoverCamera();
        self:SendEvent(EnumEvent.HideSepBalance);
    end
end

local _CNumberControl = class("NumberControl");

function _CNumberControl:ctor(handler)
    self.isWork = false;
    self.addSpeed = 0;
    self.curNumber = 0;
    self.recordNumber = 0;
    self.runTime = 0;
    self.handler = handler;
end

function _CNumberControl:ControlNumber(number, time)
    self.curNumber = number;
    self.recordNumber = number;
    self.beginSpeed = 1;
    --    local number1 =  math.ceil(number*2/3);
    --    local leftNumber = number - number1 + 1;
    self.addSpeed = (number + 1 - self.beginSpeed * time) * 2 / (time * time);
    self.runTime = 0;
    self.isWork = true;
end

function _CNumberControl:Update(_dt)
    if not self.isWork then
        return ;
    end
    self.runTime = self.runTime + _dt;
    local dis = math.ceil(self.beginSpeed * self.runTime + self.addSpeed * 0.5 * self.runTime * self.runTime);
    if dis >= self.curNumber then
        self.isWork = false;
        dis = self.curNumber;
    end
    local recordNumber = self.curNumber - dis;
    local diff = self.recordNumber - recordNumber;
    self.recordNumber = recordNumber;
    if self.handler then
        self.handler(diff, self.recordNumber, self.curNumber, dis == self.curNumber);
    end
end

function _CNumberControl:IsWork()
    return self.isWork;
end

local _CUILayer = class("_CUILayer");

function _CUILayer.Create(_parent)
    local layer = _CUILayer.New();
    if layer:Init(_parent) then
        return layer;
    end
end

function _CUILayer:ctor()
    self.scrollColumnControl = _CScrollColumnControl.New();
    self.scrollColumnControl:RegEvent(self, self.OnScrollColumnEvent);
    self.minigame = _CMiniGame.New();
    self.minigame:RegEvent(self, self.OnMiniGameEvent);
    self.balanceUI = _CBalanceUI.New();
    self.balanceUI:RegEvent(self, self.OnBalanceEvent);
    self.numberControl = _CNumberControl.New(handler(self, self.OnNumberControl))
    self.runTime = 0;
    self:_switchGameRunning(Enum_RunStep.Null);
    self.iconCells = {};
end

function _CUILayer:Init(_parent, transform)
    --初始化举报变量
    _f_initLocal();
    if transform == nil then
        local obj
        if G_GlobalGame.ConstantValue.IsPortrait then
            obj = G_GlobalGame._goFactory:createUIPartShu();
        else
            obj = G_GlobalGame._goFactory:createUIPart();
        end


        --======================
        obj.transform:Find("OverArea").gameObject:SetActive(false);

        obj.transform:Find("BG"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
        obj.transform:Find("th_bg"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
        obj.transform:Find("Balance/dajiang/qikaidesheng/zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
        obj.transform:Find("Balance/dajiang/shirupouzu/zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
        obj.transform:Find("Balance/dajiang/tianxiawushuang/zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
        obj.transform:Find("Balance/dajiang/suoxiangpimi/zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
        obj.transform:Find("Balance/other_jiesuan/daizi/zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
        obj.transform:Find("Balance/other_jiesuan/yitong/zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
        obj.transform:Find("Balance/other_jiesuan/zhengzhan/zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
        obj.transform:Find("Balance/other_jiesuan/putong/zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);

        obj.transform:Find("Balance/other_jiesuan/zhengzhan/jinbi/jinbi_dajiang"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")
        obj.transform:Find("Balance/other_jiesuan/zhengzhan/jinbi/jinbi_xiaojiang"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")

        obj.transform:Find("Balance/dajiang/tianxiawushuang/baodian"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("Balance/dajiang/tianxiawushuang/baodian/xi"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("Balance/dajiang/tianxiawushuang/baodian/diguang"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("Balance/dajiang/tianxiawushuang/baodian/guang"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Additive")

        obj.transform:Find("Balance/dajiang/shirupouzu/baodian"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("Balance/dajiang/shirupouzu/baodian/xi"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("Balance/dajiang/shirupouzu/baodian/diguang"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("Balance/dajiang/shirupouzu/baodian/guang"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Additive")

        obj.transform:Find("Balance/dajiang/suoxiangpimi/baodian"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("Balance/dajiang/suoxiangpimi/baodian/xi"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("Balance/dajiang/suoxiangpimi/baodian/diguang"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("Balance/dajiang/suoxiangpimi/baodian/guang"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Additive")

        obj.transform:Find("Balance/other_jiesuan/daizi/baodian"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("Balance/other_jiesuan/daizi/baodian/xi"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("Balance/other_jiesuan/daizi/baodian/diguang"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Additive")
        obj.transform:Find("Balance/other_jiesuan/daizi/baodian/guang"):GetComponent("Renderer").material.shader = UnityEngine.Shader.Find("Mobile/Particles/Additive")


        --======================

        self.transform = obj.transform;
        self.gameObject = obj.gameObject;
        self.transform:SetParent(_parent);
        self.transform.localPosition = C_Vector3_Zero;
        self.transform.localScale = C_Vector3_One;
    else
        self.transform = transform;
        self.gameObject = transform.gameObject;
    end
    --UIanimator
    self.uianimator = self.transform:GetComponent("Animator");
    --初始化小游戏
    self.minigame:Init(self.transform:Find("MiniGame"));

    --内容panel
    self.contentPanel = self.transform:Find("ContentPanel");
    --滚动后面
    self.scrollBackPanel = self.contentPanel:Find("ScrollBack");
    --滚动后面
    self.scrollFrontPanel = self.contentPanel:Find("ScrollFront");
    --滚动区
    self.scrollPanel = self.contentPanel:Find("ScrollPanel");
    --滚动确定区
    self.scrollFixPanel = self.scrollPanel:Find("FixContent");
    --背景
    self.bgImage = self.transform:Find("BG"):GetComponent("Image");
    self.otherBG = self.transform:Find("th_bg"):GetComponent("Image");
    self.otherStarImage = self.transform:Find("th_bg/star"):GetComponent("Image");
    --游戏框的内容
    self.contentBGImage = self.scrollBackPanel:Find("BG"):GetComponent("Image");
    --特效
    self.effect = self.transform:Find("Effect");
    --进入游戏控制
    self.enterGameControl = {
        bAlpha = 0.1, dy = -450, maxDY = -289, cAlpha = 0, step = 1, runTime = 0, };
    self.bgImage.color = { r = 1, g = 1, b = 1, a = 0 };
    self.contentBGImage.color = { r = 1, g = 1, b = 1, a = 0 };
    self.scrollFrontPanel.localPosition = { x = 0, y = self.enterGameControl.dy, z = 0 };
    --结算
    self.balanceTransform = self.transform:Find("Balance");
    --前面
    self.balanceFront = self.balanceTransform:Find("Front");
    --后面
    self.balanceBack = self.balanceTransform:Find("Back");
    --初始化结算
    self.balanceUI:Init(self.balanceTransform, self.uianimator);

    --缓存池
    self.cachePool = self.transform:Find("CachePool");
    _v_ui_cachePool = self.cachePool;
    _v_ui_cachePool.gameObject:SetActive(false);

    self.addBtn = self.scrollFrontPanel:Find("Add");
    self.disabledAdd = self.addBtn:Find("Disabled").gameObject;
    self.reduceBtn = self.scrollFrontPanel:Find("Reduce");
    self.disabledReduce = self.reduceBtn:Find("Disabled").gameObject;
    self.startBtn = self.scrollFrontPanel:Find("Start");
    self.isDisplayBtn = false;

    LuaTools.AddClick(self.addBtn.gameObject, handler(self, self._onAddBet));
    LuaTools.AddClick(self.reduceBtn.gameObject, handler(self, self._onRemoveBet));
    LuaTools.AddPressAndRelease(self.startBtn.gameObject, handler(self, self._onPressStart), handler(self, self._onReleaseStart));
    LuaTools.AddClick(self.startBtn:Find("Auto").gameObject, handler(self, self._onNormalStart));

    --长按事件
    self.longKeyPress = LongPressControl.New();
    --滚动列
    self.scrollColumnControl:Init(self.scrollPanel:Find("Columns"));
    --初始化图标格子
    self:_initIconCells();
    --初始化数字
    self:_initNumbers();
    --彩金
    local caijin = self.scrollBackPanel:Find("Caijin");
    self.caijinNum = CAtlasNumber.CreateWithGroupName(_numNumber4, 0, HorizontalAlignType.Mid):SetParent(caijin):SetLocalScale(C_Vector3_One):SetSpace(6);
    --全盘奖
    self.wholeNum = {};
    local num = CAtlasNumber.CreateWithGroupName(_numNumber4, 0, HorizontalAlignType.Mid)
                            :SetParent(self.scrollBackPanel:Find("SmallWhole")):SetLocalScale(C_Vector3_One):SetSpace(6);
    self.wholeNum[EnumWholeType.EM_WholeValue_Small] = num;
    num = CAtlasNumber.CreateWithGroupName(_numNumber4, 0, HorizontalAlignType.Mid)
                      :SetParent(self.scrollBackPanel:Find("MidWhole")):SetLocalScale(C_Vector3_One):SetSpace(6);
    self.wholeNum[EnumWholeType.EM_WholeValue_Mid] = num;
    num = CAtlasNumber.CreateWithGroupName(_numNumber4, 0, HorizontalAlignType.Mid)
                      :SetParent(self.scrollBackPanel:Find("BigWhole")):SetLocalScale(C_Vector3_One):SetSpace(6);
    self.wholeNum[EnumWholeType.EM_WholeValue_Big] = num;

    --棋子
    self.qizi = self.scrollBackPanel:Find("Qizi");
    self.warNumber = self.qizi:Find("Number"):GetComponent("Text");
    self.qiziAnimate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self.qizi:Find("Action").gameObject, CAnimateDefine.Enum_AnimateStyle.Qizi);
    self.warPer = 0;
    self.qiziControl = {
        qizi = nil, count = 0, qiziMoveDis = 355, beginPos = { x = 588, y = -135, z = 0 }, endPos = 0, maxCount = GameDefine.CellCount(), isMove = false,
        numberControls = {}, number = 0,
        Init = function(self, qizi, warNumber, qiziAnimate)
            self.qizi = qizi;
            self.warNumber = warNumber;
            self.qiziAnimate = qiziAnimate;
            self.warNumber.text = "0";
            self.warNumber.gameObject:SetActive(false);
            self.curPos = 0;
            self.count = 0;
            self.qizi.localPosition = self.beginPos;
        end,
        Fly = function(self)
            self.qiziAnimate:PlayAlways();
        end,
        Stop = function(self)
            self.qiziAnimate:Stop();
        end,
        AddCount = function(self, count, addValue)
            if count == 0 then
                return ;
            end
            self.isMove = true;
            self.count = self.count + count;
            self.endPos = self.count / self.maxCount * self.qiziMoveDis;
        end,
        Reset = function(self)
            self.warNumber.text = "0";
            self.curPos = 0;
            self.count = 0;
            self.qizi.localPosition = self.beginPos;
        end,
        Update = function(self, dt)
            if self.isMove then
                self.curPos = self.curPos + 130 * dt;
                if self.curPos >= self.endPos then
                    self.isMove = false;
                    self.curPos = self.endPos;
                end
                self.qizi.localPosition = { x = self.beginPos.x, y = self.beginPos.y + self.curPos, z = self.beginPos.z };
            end
        end,
    };
    self.qiziControl:Init(self.qizi, self.warNumber, self.qiziAnimate);

    local pai = self.scrollBackPanel:Find("Pai");
    local multiple = pai:Find("Multiple");
    --翻倍
    self.multipleNum = CAtlasNumber.CreateWithGroupName(_numNumber1, -2, HorizontalAlignType.Mid)
                                   :SetParent(multiple):SetLocalScale(C_Vector3_One);
    self.addMultipleNum = CAtlasNumber.CreateWithGroupName(_numNumber8, -3, HorizontalAlignType.Mid)
                                      :SetParent(multiple:Find("AddNumber")):SetLocalScale(C_Vector3_One);
    self.title = pai:Find("Name");
    --顶部显示控制
    self.displayTopControl = {
        title = nil, titleObj = nil, multiple = nil, multipleObj = nil, alpha = 0, addMultiple = nil, isAction = false,
        Init = function(self, title, multiple, multipleNum, addMultiple)
            self.title = title;
            self.multiple = multiple;
            self.titleObj = title.gameObject;
            self.multipleObj = multiple.gameObject;
            self.addMultiple = addMultiple;
            self.multipleNum = multipleNum;
            self.curMultiple = 0;
        end,
        ShowTitle = function(self)
            self.titleObj:SetActive(true);
            self.multipleObj:SetActive(false);
        end,
        ShowMultiple = function(self)
            self.titleObj:SetActive(false);
            self.multipleObj:SetActive(true);
        end,
        AddMultiple = function(self, amultitple, multiple)
            self.addMultiple:SetNumString("+" .. amultitple);
            self.isAction = true;
            self.addMultiple:SetAlpha(1);
            self.alpha = 1;
            self.addMultiple:Show();
            self.curMultiple = multiple;
        end,
        SetMultiple = function(self, multiple)
            self.multipleNum:SetNumString("x" .. multiple);
            --self.isAction = false;
            --self.addMultiple:Hide();
            self.curMultiple = multiple;
        end,
        Update = function(self, dt)
            if self.isAction then
                self.alpha = self.alpha - dt * 0.6;
                if self.alpha <= 0 then
                    self.addMultiple:Hide();
                    self.multipleNum:SetNumString("x" .. self.curMultiple);
                    self.isAction = false;
                else
                    self.addMultiple:SetAlpha(self.alpha);
                end
            end
        end,
    };
    self.displayTopControl:Init(self.title, multiple, self.multipleNum, self.addMultipleNum);

    --滚动区域前面
    --单注值
    local bets = self.scrollFrontPanel:Find("Bets");
    self.oneBet = bets:Find("Bet"):GetComponent("Text");
    self.oneBet.text = "";

    --总下注
    local totalBet = bets:Find("TotalBet");
    self.totalBetNum = CAtlasNumber.CreateWithGroupName(_numNumber3, -2):SetParent(totalBet):SetLocalScale(C_Vector3_One);
    --我的金币
    local myGold = self.scrollFrontPanel:Find("MyGold/Value");
    self.myGoldNum = CAtlasNumber.CreateWithGroupName(_numNumber3, -2):SetParent(myGold):SetLocalScale(C_Vector3_One);
    --获得金币
    local getGold = self.scrollFrontPanel:Find("GetGold/Value");
    self.getGoldNum = CAtlasNumber.CreateWithGroupName(_numNumber2, -2):SetParent(getGold):SetLocalScale(C_Vector3_One);

    --添加事件
    self:_addEvent();

    --开始按钮状态控制
    self.startStatus = {
        transform = nil, startStatus = {}, autoStatus = {}, freeStatus = {}, status = 0, isInRun = false,
        --初始化
        Init = function(self, transform)
            self.transform = transform;
            local ss = self.startStatus;
            local as = self.autoStatus;
            local fs = self.freeStatus;
            ss.transform = transform:Find("Start");
            ss.gameObject = self.startStatus.transform.gameObject;
            ss.gameObject:SetActive(false);
            self.diableObj = transform:Find("Disabled").gameObject;
            self.diableObj:SetActive(true);
            as.transform = transform:Find("Auto");
            as.gameObject = as.transform.gameObject;
            as.gameObject:SetActive(false);
            as.count = 0;
            as.neverObj = as.transform:Find("Never").gameObject;
            local number = as.transform:Find("Number");
            as.atlasNumber = CAtlasNumber.CreateWithGroupName(_numNumber1, -2, HorizontalAlignType.Mid)
                                         :SetParent(number):SetLocalScale(C_Vector3_One);
            fs.transform = transform:Find("Free");
            fs.gameObject = self.freeStatus.transform.gameObject;
            fs.gameObject:SetActive(false);
            fs.count = 0;
            fs.atlasNumber = CAtlasNumber.CreateWithGroupName(_numNumber1, -2, HorizontalAlignType.Mid)
                                         :SetParent(self.freeStatus.transform:Find("Count")):SetLocalScale(C_Vector3_One);
            self.status = Enum_StartStatus.Normal;
            self:InitStatus();
        end,
        --每帧更新
        Update = function(self, _dt)
        end,
        --减少游戏次数
        ReduceGameCount = function(self)
            self.isInRun = true;
            local as = self.autoStatus;
            local fs = self.freeStatus;
            if self.status == Enum_StartStatus.Normal then
                self.diableObj:SetActive(true);
            elseif self.status == Enum_StartStatus.Auto then
                if as.count > 0 then
                    as.count = as.count - 1;
                    as.atlasNumber:SetNumber(as.count);
                elseif as.count == -1 then

                end
            elseif self.status == Enum_StartStatus.Free then
                fs.count = fs.count - 1;
                fs.atlasNumber:SetNumber(fs.count);
            end
        end,
        --自动开始
        AutoStart = function(self, count)
            self.autoStatus.count = count;
            self.status = Enum_StartStatus.Auto;
            self:InitStatus();
        end,
        --免费游戏
        FreeGameCount = function(self, count)
            local fs = self.freeStatus;
            fs.count = fs.count + count;
            if fs.count > 0 then
                self.status = Enum_StartStatus.Free;
                self:InitStatus();
            end
        end,
        SetFreeGameCount = function(self, count)
            self.freeStatus.count = count;
            if self.freeStatus.count > 0 then
                self.status = Enum_StartStatus.Free;
                self:InitStatus();
            end
        end,
        NormalStart = function(self)
            if self.status == Enum_StartStatus.Auto then
                self.status = Enum_StartStatus.Normal;
                self.autoStatus.count = 0;
                self:InitStatus();
                if self.isInRun then
                    self.diableObj:SetActive(true);
                else
                    self.diableObj:SetActive(false);
                end
            end
        end,
        InitStatus = function(self)
            local ss = self.startStatus;
            local as = self.autoStatus;
            local fs = self.freeStatus;
            if self.status == Enum_StartStatus.Normal then
                ss.gameObject:SetActive(true);
                as.gameObject:SetActive(false);
                fs.gameObject:SetActive(false);
            elseif self.status == Enum_StartStatus.Auto then
                self.diableObj:SetActive(false);
                ss.gameObject:SetActive(false);
                as.gameObject:SetActive(true);
                fs.gameObject:SetActive(false);
                if as.count == -1 then
                    as.atlasNumber:Hide();
                    as.neverObj:SetActive(true);
                else
                    as.atlasNumber:Show();
                    as.atlasNumber:SetNumber(self.autoStatus.count);
                    as.neverObj:SetActive(false);
                end
            elseif self.status == Enum_StartStatus.Free then
                self.diableObj:SetActive(true);
                ss.gameObject:SetActive(false);
                as.gameObject:SetActive(false);
                fs.gameObject:SetActive(true);
                fs.atlasNumber:SetNumber(self.freeStatus.count);
            end
        end,
        --改变状态
        ChangeStatus = function(self)

            local ss = self.startStatus;
            local as = self.autoStatus;
            local fs = self.freeStatus;
            self.isInRun = false;
            if self.status == Enum_StartStatus.Normal then
                self.diableObj:SetActive(false);
            elseif self.status == Enum_StartStatus.Auto then
                --看看这里是否又次数限制等
                if as.count == -1 then
                elseif as.count == 0 then
                    ss.gameObject:SetActive(true);
                    as.gameObject:SetActive(false);
                    fs.gameObject:SetActive(false);
                    self.status = Enum_StartStatus.Normal;
                end
            elseif self.status == Enum_StartStatus.Free then
                if fs.count <= 0 then
                    self.diableObj:SetActive(false);
                    if as.count > 0 then
                        self.status = Enum_StartStatus.Auto;
                        ss.gameObject:SetActive(false);
                        as.gameObject:SetActive(true);
                        fs.gameObject:SetActive(false);
                    elseif self.autoStatus.count == -1 then
                        self.status = Enum_StartStatus.Auto;
                        ss.gameObject:SetActive(false);
                        as.gameObject:SetActive(true);
                        fs.gameObject:SetActive(false);
                    else
                        ss.gameObject:SetActive(true);
                        as.gameObject:SetActive(false);
                        fs.gameObject:SetActive(false);
                        self.status = Enum_StartStatus.Normal;
                    end
                end
            end
        end,
        AutoCount = function(self)
            return self.autoStatus.count;
        end,
        --状态
        Status = function(self)
            return self.status;
        end,
    };

    --初始化状态按钮
    self.startStatus:Init(self.startBtn);
    --自动转动配置
    self.autoConfigs = {
        10, 50, 100, -1
    };
    --自动控制
    self.autoPopControl = {
        transform = nil, gameObject = nil, btn = nil, btns = {}, eventHandler = handler,
        Init = function(self, transform, config, eventhandler)
            local CBtn = class("CBtn");
            function CBtn:ctor()
                self.value = -1;
                self.clickHandler = nil;
                self.transform = nil;
            end
            function CBtn:Init(transform, clickHandler)
                self.transform = transform;
                self.clickHandler = clickHandler;
                self.fornever = transform:Find("Fornever");
                self.number = transform:Find("Number");
                self.btnBg = transform:Find("BtnBG");
                self.fornever.gameObject:SetActive(false);
                self.number.gameObject:SetActive(false);
                self.atlasNumber = nil;
                LuaTools.AddClick(self.btnBg.gameObject, handler(self, self._onClick))
            end
            function CBtn:Fornever()
                self.value = -1;
                self.fornever.gameObject:SetActive(true);
                self.number.gameObject:SetActive(false);
            end
            function CBtn:Number(number)
                self.value = number;
                self.fornever.gameObject:SetActive(false);
                self.number.gameObject:SetActive(true);
                if not self.atlasNumber then
                    self.atlasNumber = CAtlasNumber.CreateWithGroupName(_numNumber1, -2, HorizontalAlignType.Mid)
                                                   :SetParent(self.number):SetLocalScale(C_Vector3_One):IsReciveTouch(false);
                end
                self.atlasNumber:SetNumber(number);
            end
            function CBtn:_onClick()
                self.clickHandler(self.value);
                G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().Btn);
            end
            self.transform = transform;
            self.gameObject = transform.gameObject;
            local mask = transform:Find("Mask");
            LuaTools.AddClick(mask.gameObject, handler(self, self._onClickMask));
            self.btn = transform:Find("Btn");
            local configCount = #config;
            local btn;
            local gameObject;
            local transform1;
            for i = 2, configCount do
                btn = CBtn.New();
                gameObject = newobject(self.btn.gameObject);
                transform1 = gameObject.transform;
                transform1:SetParent(transform);
                transform1.localScale = Vector3.one;
                btn:Init(transform1, handler(self, self._onBtnClick));
                if config[i] == -1 then
                    btn:Fornever();
                else
                    btn:Number(config[i]);
                end
                self.btns[i] = btn;
            end
            btn = CBtn.New();
            transform1 = self.btn;
            btn:Init(transform1, handler(self, self._onBtnClick));
            if config[1] == -1 then
                btn:Fornever();
            else
                btn:Number(config[1]);
            end
            self.btns[1] = btn;
            local y = 130;
            for i = 1, configCount do
                self.btns[i].transform.localPosition = Vector3.New(0, y, 0);
                y = y + 68;
            end
            self.eventHandler = eventhandler;
        end,
        Disappear = function(self)
            self.gameObject:SetActive(false);
        end,
        Show = function(self)
            self.gameObject:SetActive(true);
        end,
        _onClickMask = function(self)
            self:Disappear();
        end,
        _onBtnClick = function(self, value)
            self.eventHandler(value);
            self:Disappear();
        end,
    };
    --自由弹窗
    self.autoPopControl:Init(self.scrollFrontPanel:Find("PopMenu"), self.autoConfigs, handler(self, self._onChooseAutoTimes));
    --增加特效
    self:_addEffects();
    --初始化
    self:_initData();
    return true;
end
--初始化iconCells
function _CUILayer:_initIconCells()
    local XCount = GameDefine.XCount();
    local YCount = GameDefine.YCount();
    local beginPos = { x = 0, y = 0, z = 0 };
    local iconCell = nil;
    local transform = nil;
    for i = 1, YCount do
        self.iconCells[i] = {};
    end
    for j = 1, XCount do
        for i = YCount, 1, -1 do
            iconCell = _CIconCell.New();
            iconCell:Init(self.scrollFixPanel);
            self.iconCells[i][j] = iconCell;
        end
    end
    for j = 1, XCount do
        beginPos.x = scrollColumnPos[j].x + node_BeginPos.x;
        beginPos.y = scrollColumnPos[j].y + node_BeginPos.y;
        beginPos.z = scrollColumnPos[j].z + node_BeginPos.z;
        for i = YCount, 1, -1 do
            self.iconCells[i][j]:CreateEffect(self.scrollFixPanel):SetLocalPosition(beginPos);
            beginPos.y = beginPos.y + node_disY;
        end
    end
end
function _CUILayer:_controlIconCells(dt)
    local XCount = GameDefine.XCount();
    local YCount = GameDefine.YCount();
    for i = 1, YCount do
        for j = 1, XCount do
            self.iconCells[i][j]:Update(dt);
        end
    end
end
function _CUILayer:_initNumbers()
    --游戏积分sprites
    local gameScoreSprites = G_GlobalGame:GetSpritePlist(G_GlobalGame.Enum_Sprite_Tag.Number1) or {};
    CAtlasNumber.ImportSprites(_numNumber1, gameScoreSprites);
    --导入获得分数1
    gameScoreSprites = G_GlobalGame:GetSpritePlist(G_GlobalGame.Enum_Sprite_Tag.Number2) or {};
    CAtlasNumber.ImportSprites(_numNumber2, gameScoreSprites);
    --导入获得分数2
    gameScoreSprites = G_GlobalGame:GetSpritePlist(G_GlobalGame.Enum_Sprite_Tag.Number3) or {};
    CAtlasNumber.ImportSprites(_numNumber3, gameScoreSprites);
    --导入获得分数3
    gameScoreSprites = G_GlobalGame:GetSpritePlist(G_GlobalGame.Enum_Sprite_Tag.Number4) or {};
    CAtlasNumber.ImportSprites(_numNumber4, gameScoreSprites);
    --导入获得分数4
    gameScoreSprites = G_GlobalGame:GetSpritePlist(G_GlobalGame.Enum_Sprite_Tag.Number5) or {};
    CAtlasNumber.ImportSprites(_numNumber5, gameScoreSprites);
    --导入获得分数4
    gameScoreSprites = G_GlobalGame:GetSpritePlist(G_GlobalGame.Enum_Sprite_Tag.Number6) or {};
    CAtlasNumber.ImportSprites(_numNumber6, gameScoreSprites);
    --导入获得分数4
    gameScoreSprites = G_GlobalGame:GetSpritePlist(G_GlobalGame.Enum_Sprite_Tag.Number7) or {};
    CAtlasNumber.ImportSprites(_numNumber7, gameScoreSprites);
    --导入获得分数4
    gameScoreSprites = G_GlobalGame:GetSpritePlist(G_GlobalGame.Enum_Sprite_Tag.Number8) or {};
    CAtlasNumber.ImportSprites(_numNumber8, gameScoreSprites);
    --导入获得分数4
    gameScoreSprites = G_GlobalGame:GetSpritePlist(G_GlobalGame.Enum_Sprite_Tag.Number9) or {};
    CAtlasNumber.ImportSprites(_numNumber9, gameScoreSprites);
    --导入获得分数4
    gameScoreSprites = G_GlobalGame:GetSpritePlist(G_GlobalGame.Enum_Sprite_Tag.Number10) or {};
    CAtlasNumber.ImportSprites(_numNumber10, gameScoreSprites);
    gameScoreSprites = G_GlobalGame:GetSpritePlist(G_GlobalGame.Enum_Sprite_Tag.Number11) or {};
    CAtlasNumber.ImportSprites(_numNumber11, gameScoreSprites);
end
--添加事件
function _CUILayer:_addEvent()
    G_GlobalGame:RegEventByStringKey("GameConfig", self, self.OnGameConfig);
    G_GlobalGame:RegEventByStringKey("NotifyEnterGame", self, self.OnEnterGame);
    G_GlobalGame:RegEventByStringKey("NotifyUIStartGameCB", self, self.OnStartGameCB);
    G_GlobalGame:RegEventByStringKey("NotifyUISmallGameCB", self, self.OnStartSmallGameCB);
    G_GlobalGame:RegEventByStringKey("NotifyUICaijin", self, self.OnUpdateCaijin);
    G_GlobalGame:RegEventByStringKey("NotifyUIGameDataCB", self, self.OnGameData);
end
function _CUILayer:_addEffects()
    local effect
    if G_GlobalGame.ConstantValue.IsPortrait then
        effect = G_GlobalGame._goFactory:createUICommon("mfyx_shu");
    else
        effect = G_GlobalGame._goFactory:createUICommon("mfyx");
    end
    local transform = effect.transform;
    local lposiiton = transform.localPosition;
    local lscale = transform.localScale;
    local lrotation = transform.localRotation;
    transform:SetParent(self.effect);
    transform.localPosition = lposiiton;
    transform.localScale = lscale;
    transform.localRotation = lrotation;
    self.freeEffectControl = {
        isShow = false, isShowChild = true, effect = effect:GetComponent("ParticleSystem"), go = effect,
        freeObjs = { transform:Find("caijinhuo (3)").gameObject, transform:Find("huo2 (1)").gameObject,
                     transform:Find("huo2 (2)").gameObject, transform:Find("huo2 (4)").gameObject }
    };
    effect:SetActive(false);
    if G_GlobalGame.ConstantValue.IsPortrait then
        effect = G_GlobalGame._goFactory:createUICommon("zimuhuo_shu");
    else
        effect = G_GlobalGame._goFactory:createUICommon("zimuhuo");
    end

    transform = effect.transform;
    lposiiton = transform.localPosition;
    lscale = transform.localScale;
    lrotation = transform.localRotation;
    self.freeMultipleEffect = effect:GetComponent("ParticleSystem");
    transform:SetParent(self.effect);
    transform.localPosition = lposiiton;
    transform.localScale = lscale;
    transform.localRotation = lrotation;
    effect:SetActive(false);
end
function _CUILayer:_initData()
    self.isDataCB = false;

    --游戏状态
    self.runMode = Enum_RunMode.HandMode;
    self.runContent = Enum_RunContent.Normal;
    self.runState = Enum_RunState.Null;
    --是否可以开始游戏
    self.isCanStart = false;
    --UI界面的我的金币
    self.uiGold = 0;
    --是否请求更新彩金
    self.isUpdateCaijin = false;
    self.isNeedUpdateCaijin = false;
    self.updateCaijinTime = 0;
end
function _CUILayer:_onAddBet()
    if not self.isDisplayBtn then
        return ;
    end
    local bet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetBet);
    bet = GameDefine.GetNextBet(bet);
    G_GlobalGame:DispatchEventByStringKey("ChangeBet", bet);
    self:_onChangeBet(bet);
    G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().Btn);
    self:_onUpdateCaijin();
    --刷新全盘奖
    self:_onUpdateWholeValues();
end

function _CUILayer:_onRemoveBet()
    if not self.isDisplayBtn then
        return ;
    end
    local bet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetBet);
    bet = GameDefine.GetPreBet(bet);
    G_GlobalGame:DispatchEventByStringKey("ChangeBet", bet);
    self:_onChangeBet(bet);
    G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().Btn);
    self:_onUpdateCaijin();
    --刷新全盘奖
    self:_onUpdateWholeValues();
end

function _CUILayer:DisabledChangeBet()
    if self.isDisplayBtn then
        self.disabledAdd:SetActive(true);
        self.disabledReduce:SetActive(true);
        self.isDisplayBtn = false;
    end
end

function _CUILayer:DisplayCaijin()
    self.caijinObj.gameObject:SetActive(true);
    self.multipleObj.gameObject:SetActive(false);
end

function _CUILayer:DisplayMultiple()
    self.caijinObj.gameObject:SetActive(false);
    self.multipleObj.gameObject:SetActive(true);
end

function _CUILayer:EnabledChangeBet()
    if not self.isDisplayBtn then
        self.disabledAdd:SetActive(false);
        self.disabledReduce:SetActive(false);
        self.isDisplayBtn = true;
    end
end

--点击开始按钮
function _CUILayer:_onStartClick()
    --不可用了
    self:DisabledChangeBet();
    self.scrollColumnControl:Start();
end

function _CUILayer:_onPressStart()
    local status = self.startStatus:Status();
    if not self.isCanStart then
        return ;
    end
    if status == Enum_StartStatus.Normal then
        self.longKeyPress:Start(1, 0.8, 0.2, handler(self, self._onLongPressStart), handler(self, self._onShortPressStart));
        G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().Btn);
    elseif status == Enum_StartStatus.Auto then
        self:_onNormalStart();
        G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().Btn);
    elseif status == Enum_StartStatus.Free then

    end
end

function _CUILayer:_onReleaseStart()
    self.longKeyPress:Stop(1);
end

function _CUILayer:_onLongPressStart()
    self.autoPopControl:Show();
    self.longKeyPress:Stop(1);
end

function _CUILayer:_onShortPressStart()
    self.autoPopControl:Disappear();
    self:_onStartGame();
end

--开始自动模式
function _CUILayer:_onAutoStart(count)
    --改为自动模式
    self.runMode = Enum_RunMode.AutoMode;
    --无限循环
    self.startStatus:AutoStart(count);
end

--手动模式
function _CUILayer:_onNormalStart()
    self.runMode = Enum_RunMode.HandMode;
    self.startStatus:NormalStart();
end

--免费模式
function _CUILayer:_onFreeGameStart(count)
    self.runMode = Enum_RunMode.AutoMode;
    self.startStatus:FreeGameCount(count);
end

function _CUILayer:_onStartGame()
    if self.runState ~= Enum_RunState.Null then
        self.scrollColumnControl:Continue();
        return false;
    end
    if not KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetCanStartGame) then
        FramePopoutCompent.Show("金币不足");
        self.startStatus:NormalStart();
        self.runMode = Enum_RunMode.HandMode;
        return false;
    end
    self.isNeedUpdateCaijin = false;
    self.isUpdateCaijin = false;
    self.updateCaijinTime = 0;
    self.runState = Enum_RunState.PlayingGame;
    --通知开始游戏
    G_GlobalGame:DispatchEventByStringKey("StartGame");
    --减少一次游戏
    self.startStatus:ReduceGameCount();
    --至少要转1秒
    self:_onScrollColumns();
    --重置获得金币 
    if self.isClearGetGold then
        --当局获得变为0
        self:_onChangeGetGold(0);
    end
    local status = self.startStatus:Status();
    if status ~= Enum_StartStatus.Free then
        self.isClearGetGold = true;
    else
        self.isClearGetGold = false;
    end
    --更新我的金币
    self:_onUpdateGold();
    --
    self:DisabledChangeBet();
end

function _CUILayer:_reduceBet()
    local gold = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetUserGold);
    local bet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetBet);
    local maxLine = GameDefine.MaxLine();
    local needGold = bet * maxLine;
    if gold < needGold then
        return false;
    end
    --减注
    self:_onChangeMyGold(gold - needGold);
    return true;
end
local nnnn = 1
--改变状态
function _CUILayer:_controlStatus(_dt)
    if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then
        if GameManager.IsStopGame then
            return
        end
        if isInitOver then
            self.startStatus:Update(_dt);
            if self.runMode == Enum_RunMode.HandMode then
                --手动模式
                if self.runContent == Enum_RunContent.FreeGame then
                    --手动模式，免费情况下也要继续游戏
                    if self.runState == Enum_RunState.Null then
                        --开始游戏
                        logYellow("手动模式")
                        self:_onStartGame();
                    end
                end
            else
                --自动模式
                if self.runState == Enum_RunState.Null then
                    --开始游戏
                    logYellow("自动模式")
                    self:_onStartGame();
                end
            end
        end
    else
        self.runState = Enum_RunState.Null
        isInitOver = false
    end
end

--控制星星
function _CUILayer:_controlStars(_dt)
    self.stars:Update(_dt);
end

function _CUILayer:OnGameConfig()
end



--进入游戏
function _CUILayer:OnEnterGame()
    --修改跑马灯位置
    GameSetsBtnInfo.SetPlaySuonaPos(-6, 265, 0);
    --可以开始游戏了
    self.isCanStart = true;
    --更新金币
    self:_onUpdateGold();
    --更新下注值
    self:_onUpdateBet();
    --更新彩金
    self:_onUpdateCaijin();
    --更新全盘奖
    self:_onUpdateWholeValues();
    --更新获得金币
    self:_onUpdateGetGold();
    --改变状态
    self:_onChangeState();
    --控制顶部内容
    self:_controlTopContent();
    --更新旗子
    self:_onUpdateQizi();
    --更新征战信息
    self:_onUpdateFightInfo();
    --播放一次看看
    --self.balanceUI:ShowBigResult(32000,30);
    --self.balanceUI:ShowAddMultiple(5);
end

function _CUILayer:_onChangeState()
    local state = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameState);
    if state == Enum_GameState.EM_GameState_Null then
        self:EnabledChangeBet();
    elseif state == Enum_GameState.EM_GameState_PlayingGame then
        self:DisabledChangeBet();
    elseif state == Enum_GameState.EM_GameState_FreeGame then
        self:DisabledChangeBet();
        --自动切换
        self.displayTopControl:ShowMultiple();
    elseif state == Enum_GameState.EM_GameState_SmallGame then
        self:DisabledChangeBet();
        self.minigame:Start(30);
        self.runState = Enum_RunState.OtherGame;
        self:_switchGameRunning(Enum_RunStep.WarGame);
    end
    G_GlobalGame._soundCtrl:PushBgSound(SoundDefine.EnumSound().BG);
    if state == Enum_GameState.EM_GameState_FreeGame then
        G_GlobalGame._soundCtrl:PushBgSound(SoundDefine.EnumSound().FreeBG);
    end
    --更新免费次数
    self:_onUpdateFreeCount();
    --运行模式
    self:_controlRunMode();
end

function _CUILayer:_onChangeMyGold(_gold)
    self.uiGold = _gold;
    self.myGoldNum:SetNumber(_gold);
    return self;
end

function _CUILayer:_onUpdateGold()
    local gold = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetUserGold);
    G_GlobalGame._clientSession.isreqStart = true;
    return self:_onChangeMyGold(gold);
end

function _CUILayer:_onChangeBet(_bet)
    local maxLine = GameDefine.MaxLine();
    self.totalBetNum:SetNumber(_bet * maxLine);
    self.oneBet.text = tostring(maxLine) .. "线 X " .. _bet;
    return self;
end

function _CUILayer:_onUpdateBet()
    local bet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetBet);
    return self:_onChangeBet(bet);
end

function _CUILayer:_onChangeCaijin(_caijin)
    self.caijinNum:SetNumber(_caijin);
    return self;
end

function _CUILayer:_onUpdateCaijin()
    local caijin = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetCaijin);
    return self:_onChangeCaijin(caijin);
end

function _CUILayer:_onUpdateWholeValues()
    local smallValue, midValue, bigValue = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetWholeValues);
    self.wholeNum[EnumWholeType.EM_WholeValue_Small]:SetNumber(smallValue);
    self.wholeNum[EnumWholeType.EM_WholeValue_Mid]:SetNumber(midValue);
    self.wholeNum[EnumWholeType.EM_WholeValue_Big]:SetNumber(bigValue);
    return self;
end

function _CUILayer:_onChangeGetGold(_gold)
    self.uiGetGold = _gold;
    return self.getGoldNum:SetNumber(_gold);
end

function _CUILayer:_onUpdateGetGold()
    local _bet, _getGold = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    return self:_onChangeGetGold(_getGold);
end

function _CUILayer:_onUpdateComGold()
    local _bet, _getGold, _comGold = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    local gold = _getGold
    return self:_onChangeGetGold(_getGold);
end

function _CUILayer:_onChangeFreeCount(_freeCount)
    self.startStatus:SetFreeGameCount(_freeCount);
    return self;
end

function _CUILayer:_onUpdateFreeCount()
    local _freeCount = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetFreeCount);
    return self:_onChangeFreeCount(_freeCount);
end

--更新旗子
function _CUILayer:_onUpdateQizi()
    local _warNumber, _count, _details = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetFightDetail);
    self.qiziControl:AddCount(_count, _warNumber);
    self.qiziControl:Fly();
    return self;
end

function _CUILayer:_onUpdateFightInfo()
    local _warNumber, _count, _details = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetFightDetail);
    --显示征战的图标
    local xCount = GameDefine.XCount();
    local yCount = GameDefine.YCount();
    for i = 1, xCount do
        for j = 1, yCount do
            if _details[j][i] == 1 then
                self.iconCells[j][i]:Hide();
            end
        end
    end
    return self;
end

function _CUILayer:OnGameData(_eventID, _eventData)
    --self.isCanStart = true;
    self.isDataCB = true;
    self.isNeedUpdateCaijin = true;
    self.updateCaijinTime = 0;
    isInitOver = true

    --self.minigame:Start();
    --self.balanceUI:ShowBigResult(18000,3);
end

--开始游戏数据返回
function _CUILayer:OnStartGameCB(_eventID, _eventData)
    self.scrollColumnControl:ResultData(_eventData);
    --刷新彩金
    self:_onUpdateCaijin();
    self.isNeedUpdateCaijin = true;
    self.updateCaijinTime = 0;
end

--点球数据返回
function _CUILayer:OnStartSmallGameCB(_eventID, data)
    --直接反馈是否有中奖
    self.minigame:OnDataCB(data);
    --刷新彩金
    self:_onUpdateCaijin();
end

function _CUILayer:OnUpdateCaijin(_eventID, data)
    --刷新彩金
    self:_onUpdateCaijin();
end

function _CUILayer:_onNodeNormal()
    local xCount = GameDefine.XCount();
    local yCount = GameDefine.YCount();
    for i = 1, xCount do
        for j = 1, yCount do
            self.iconCells[j][i]:Normal();
        end
    end
end

function _CUILayer:_onNodeHide()
    local xCount = GameDefine.XCount();
    local yCount = GameDefine.YCount();
    for i = 1, xCount do
        for j = 1, yCount do
            self.iconCells[j][i]:Hide();
        end
    end
end

function _CUILayer:_onNodeShow()
    local xCount = GameDefine.XCount();
    local yCount = GameDefine.YCount();
    for i = 1, xCount do
        for j = 1, yCount do
            self.iconCells[j][i]:Show();
        end
    end
end

function _CUILayer:_onScrollColumns()
    --执行步骤
    self:_switchGameRunning(Enum_RunStep.Scroll);
    --图标变正常
    local xCount = GameDefine.XCount();
    local yCount = GameDefine.YCount();
    for i = 1, xCount do
        for j = 1, yCount do
            self.iconCells[j][i]:Normal():ReleationNode(nil);
        end
    end
    self.scrollColumnControl:Scroll();
    --放飞旗子
    --self.qiziControl:Fly();
    --清除结算
    self.balanceUI:Clear();
end

function _CUILayer:_releationNodes()
    local xCount = GameDefine.XCount();
    local yCount = GameDefine.YCount();
    for i = 1, xCount do
        for j = 1, yCount do
            self.iconCells[j][i]:ReleationNode(self.scrollColumnControl:GetNode(i, j));
        end
    end
end

function _CUILayer:_switchGameRunning(step)
    self.runStep = step;
    --error("现在运行状态=====" .. self.runStep)
    self.runTime = 0;
end

function _CUILayer:_checkResult(_bet, _getGold, _comGold, _ret, _curRet)
    if _bet == nil then
        _bet, _getGold, _comGold, _ret, _curRet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    end
    --关联节点
    local xCount = GameDefine.XCount();
    local yCount = GameDefine.YCount();
    local isAction = false;
    local lineCount = #_ret.lines;
    local lines = GameDefine.GetLines();
    local step = 0;
    if self.runStep == Enum_RunStep.CMulEffect then
        local status = self.startStatus:Status();
        if status == Enum_StartStatus.Free then
            if _curRet.extraMultiple > 0 then
                self:_switchGameRunning(Enum_RunStep.MulEffect);
                self:_onIconAnimate(_ret, _curRet);
            else
                self:_switchGameRunning(Enum_RunStep.CSuperEffect);
                self:_checkResult(_bet, _getGold, _comGold, _ret, _curRet);
            end
        else
            self:_switchGameRunning(Enum_RunStep.CSuperEffect);
            self:_checkResult(_bet, _getGold, _comGold, _ret, _curRet);
        end
    elseif self.runStep == Enum_RunStep.CSuperEffect then
        if _getGold >= _bet * 600 then
            if _curRet.extraMultiple > 0 then
                self:_onNodeNormal();
            end
            self:_switchGameRunning(Enum_RunStep.SuperEffect);
            self.balanceUI:ShowBigResult(_getGold, _bet);
        else
            --进入全盘检测
            self:_switchGameRunning(Enum_RunStep.CWholeEffect);
            self:_checkResult(_bet, _getGold, _comGold, _ret, _curRet);
        end
    elseif self.runStep == Enum_RunStep.CWholeEffect then
        if _curRet.wholeValue ~= EnumWholeType.EM_WholeValue_Null then
            self:_switchGameRunning(Enum_RunStep.WholeEffect);

            local smallValue, midValue, bigValue = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetWholeValues);
            if _curRet.wholeValue == 1 then
                self.balanceUI:ShowWholeResult(smallValue, 1);
            elseif _curRet.wholeValue == 2 then
                self.balanceUI:ShowWholeResult(midValue, 2);
            elseif _curRet.wholeValue == 3 then
                self.balanceUI:ShowWholeResult(bigValue, 3);
            end

        else
            --进入连线检测
            self:_switchGameRunning(Enum_RunStep.CFlashIcon);
            self:_checkResult(_bet, _getGold, _comGold, _ret, _curRet);
        end
    elseif self.runStep == Enum_RunStep.CFlashIcon then
        local count = #_ret.comCells + #_ret.sepCells;
        if count > 0 then
            self:_switchGameRunning(Enum_RunStep.FlashIcon);
            self:_onIconAnimate(_ret, _curRet);
        else
            --检测增加免费次数
            self:_switchGameRunning(Enum_RunStep.CAddFree);
            self:_checkResult(_bet, _getGold, _comGold, _ret, _curRet);
        end
    elseif self.runStep == Enum_RunStep.CFightCell then
        if _curRet.fightCount > 0 then
            local iCells = self.iconCells;
            local clearCells = _curRet.clearCells;

            local count = #clearCells;
            local addHandler = false;
            local handler = Tools.Handler.Create(self, self._onRunFlyEffect);
            log("count=============" .. count)
            for i = 1, count do
                iCells[clearCells[i].y][clearCells[i].x]:Hide(not addHandler and handler or nil);
                addHandler = true;
            end
            clearCells = _curRet.sepClears;
            count = #clearCells;
            for i = 1, count do
                iCells[clearCells[i].y][clearCells[i].x]:Hide(not addHandler and handler or nil);
                addHandler = true;
            end
            self:_switchGameRunning(Enum_RunStep.FightCell);
        else
            --普通结算
            self:_onNormalBalance();
        end
    elseif self.runStep == Enum_RunStep.CFlyEffect then
        if _curRet.fightCount > 0 then
            --todo
            self:_onRunFlyEffect(_ret, _curRet);
            self:_switchGameRunning(Enum_RunStep.FlyEffect);
        else
            --普通结算
            self:_onNormalBalance();
        end
    elseif self.runStep == Enum_RunStep.CAddFree then
        local status = self.startStatus:Status();
        if status == Enum_StartStatus.Free then
            local _bet, _getGold, _comGold, _ret, _curRet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
            if _curRet.extraFreeCount > 0 then
                self:_switchGameRunning(Enum_RunStep.AddFree);
                self:_onIconAnimate(_ret, _curRet);
            else
                self:_switchGameRunning(Enum_RunStep.CWarGame);
                self:_checkResult(_bet, _getGold, _comGold, _ret, _curRet);
            end
        else
            self:_switchGameRunning(Enum_RunStep.CWarGame);
            self:_checkResult(_bet, _getGold, _comGold, _ret, _curRet);
        end
    elseif self.runStep == Enum_RunStep.CWarGame then
        if _curRet.isEnterFightGame then
            self.balanceUI:Clear();
            self:_onNodeNormal();
            self:_onRunYiTong();
        else
            --检测免费游戏
            self:_switchGameRunning(Enum_RunStep.CFreeGame);
            self:_checkResult(_bet, _getGold, _comGold, _ret, _curRet);
        end
    elseif self.runStep == Enum_RunStep.CFreeGame then
        local status = self.startStatus:Status();
        if status ~= Enum_StartStatus.Free then
            --不在游戏中
            local _bet, _getGold, _comGold, _ret, _curRet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
            if _curRet.freeCount > 0 then
                self:_switchGameRunning(Enum_RunStep.FreeGame);
                self:_onIconAnimate();
            else
                self:_onCheckFreeTotal();
            end
        else
            self:_onCheckFreeTotal();
        end
    end
end

--检测获得金币
function _CUILayer:_checkGetGold()
    --不需要递减加钱了
    --    local _bet,_getGold,_comGold,_ret = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    --    if _getGold>0 then
    --        self:_switchGameRunning(Enum_RunStep.WGetNumber);
    --        if _getGold<_bet*50 then
    --            self.runTime = 1.3;
    --        elseif _getGold<_bet*100 then 
    --            self.runTime = 1.2;
    --        elseif _getGold<_bet*180 then 
    --            self.runTime = 1;
    --        elseif _getGold<_bet*600 then 
    --            self.runTime = 0.8;
    --        else 
    --            self.runTime = 0;
    --        end
    --    else
    --没有奖励，可以检测免费游戏
    self:_switchGameRunning(Enum_RunStep.CFreeGame);
    self:_checkResult();
    --    end 
end

function _CUILayer:_onGetGold()
    -- local _bet,_getGold,_comGold,_ret,_curRet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);

    -- local smallValue,midValue,bigValue = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetWholeValues);
    -- local gold;
    -- if _curRet.wholeValue==1 then   
    --     gold=_getGold-smallValue
    -- elseif _curRet.wholeValue==2 then
    --     gold=_getGold-midValue
    -- elseif _curRet.wholeValue==3 then
    --     gold=_getGold-bigValue   
    -- else
    --     gold = _getGold;
    -- end

    -- if gold>=0 then
    --     local time = 0;
    --     if gold<=10 then
    --         time = 1.4;
    --     elseif gold<=50 then
    --         time = 1.8;
    --     elseif gold<=80 then
    --         time = 1.9;
    --     elseif gold<=150 then
    --         time = 2.1;
    --     elseif gold<=500 then
    --         time = 2.3;
    --     elseif gold<=1200 then
    --         time = 2.5;
    --     else
    --         time = 2.8;
    --     end
    --     self:_switchGameRunning(Enum_RunStep.GetNumber);
    --     self.numberControl:ControlNumber(gold,time);
    --     self.getGoldMusic =G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().GetGold);
    -- end
end

function _CUILayer:_onRunGetWholeGold()
    local _bet, _getGold, _comGold, _ret, _curRet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    local smallValue, midValue, bigValue = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetWholeValues);

    local gold;
    if _curRet.wholeValue == 1 then
        gold = smallValue
    elseif _curRet.wholeValue == 2 then
        gold = midValue
    elseif _curRet.wholeValue == 3 then
        gold = bigValue
    else
        gold = _getGold - _comGold
    end

    if gold > 0 then
        local time = 0;
        if gold <= _bet * 10 then
            time = 0.5;
        elseif gold <= _bet * 20 then
            time = 0.8;
        elseif gold <= _bet * 80 then
            time = 1.2;
        elseif gold <= _bet * 150 then
            time = 1.5;
        elseif gold <= _bet * 500 then
            time = 1.8;
        elseif gold <= _bet * 1200 then
            time = 2.2;
        else
            time = 2.8;
        end
        self:_switchGameRunning(Enum_RunStep.GetWholeValue);
        self.numberControl:ControlNumber(gold, time);
        --self._getGoldMusic = G_GlobalGame._soundCtrl:PlaySoundByHard(SoundDefine.EnumSound().GetGold);
    end
end

function _CUILayer:_onRunGetComGold()
    local _bet, _getGold, _comGold, _ret, _curRet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    local smallValue, midValue, bigValue = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetWholeValues);
    local gold;
    if _curRet.wholeValue == 1 then
        gold = _getGold - smallValue
    elseif _curRet.wholeValue == 2 then
        gold = _getGold - midValue
    elseif _curRet.wholeValue == 3 then
        gold = _getGold - bigValue
    else
        gold = _getGold;
    end
    if gold >= 0 then
        local time = 0;
        if gold <= _bet * 10 then
            time = 0.5;
        elseif gold <= _bet * 20 then
            time = 0.8;
        elseif gold <= _bet * 80 then
            time = 1.2;
        elseif gold <= _bet * 150 then
            time = 1.5;
        elseif gold <= _bet * 500 then
            time = 1.8;
        elseif gold <= _bet * 1200 then
            time = 2.2;
        else
            time = 2.8;
        end
        time = 0.3;
        self:_switchGameRunning(Enum_RunStep.GetNumber);
        self.numberControl:ControlNumber(gold, time);
        --self._getGoldMusic = G_GlobalGame._soundCtrl:PlaySoundByHard(SoundDefine.EnumSound().GetGold);
    end
end

function _CUILayer:_onCheckGetMultiple()
    self:_switchGameRunning(Enum_RunStep.CMulEffect);
    self:_checkResult();
end

function _CUILayer:_onRunGetMultiple()
    local _bet, _getGold, _comGold, _ret, _curRet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    if _curRet.extraMultiple > 0 then
        self:_switchGameRunning(Enum_RunStep.GetMultiple);
        self.balanceUI:ShowAddMultiple(_curRet.extraMultiple);
    end
end

function _CUILayer:_onCheckSuperEffect()
    self:_switchGameRunning(Enum_RunStep.CSuperEffect);
    self:_checkResult();
end

function _CUILayer:_onCheckWholeEffect()
    self:_switchGameRunning(Enum_RunStep.CWholeEffect);
    self:_checkResult();
end

function _CUILayer:_onCheckFalshIcon()
    self:_switchGameRunning(Enum_RunStep.CFlashIcon);
    self:_checkResult();
end

--占领格子
function _CUILayer:_onCheckFightCell()
    self:_switchGameRunning(Enum_RunStep.CFightCell);
    self:_checkResult();
end

function _CUILayer:_onCheckFlyEffect()
    self:_switchGameRunning(Enum_RunStep.CFlyEffect);
    self:_checkResult();
end

--检测增加免费次数
function _CUILayer:_onCheckAddFreeCount()
    self:_switchGameRunning(Enum_RunStep.CAddFree);
    self:_checkResult();
end

--飞效果
function _CUILayer:_onRunFlyEffect(_ret, _curRet)
    if _ret == nil then
        _, _, _, _ret, _curRet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    end

    local pos = self.qiziAnimate.transform.position;
    local iCells = self.iconCells;
    local clearCells = _curRet.clearCells;
    local count = #clearCells;
    local runTime = 0.5;
    local addHandler = false;
    local handler = Tools.Handler.Create(self, self._onRunGetWarGold);
    for i = 1, count do
        iCells[clearCells[i].y][clearCells[i].x]:FlyWarEffect(pos, runTime, not addHandler and handler or nil);
        addHandler = true;
    end
    clearCells = _curRet.sepClears;
    count = #clearCells;
    for i = 1, count do
        iCells[clearCells[i].y][clearCells[i].x]:FlyWarEffect(pos, runTime, not addHandler and handler or nil);
        addHandler = true;
    end
    G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().FightBlock);
end

function _CUILayer:_onRunGetWarGold()
    local _, _, _, _, _curRet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    if _curRet.fightCount > 0 then
        --棋子需要动
        self.qiziControl:AddCount(_curRet.fightCount, _curRet.addWarBaseGold);
    end
end

function _CUILayer:_onIconAnimate(_ret, _curRet)
    if _ret == nil then
        _, _, _, _ret, _curRet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    end
    --关联节点
    local xCount = GameDefine.XCount();
    local yCount = GameDefine.YCount();
    local isAction = false;
    local lines = GameDefine.GetLines();
    local step = 0;
    local iCells = self.iconCells;
    for i = 1, xCount do
        for j = 1, yCount do
            iCells[j][i]:Normal();
        end
    end
    --结算界面清理
    self.balanceUI:Clear();
    if self.runStep == Enum_RunStep.MulEffect then
        local cells = _ret.wildCells;
        local count = #cells;
        for i = 1, count do
            iCells[cells[i].y][cells[i].x]:Action():ShowEffect();
        end
        isAction = true;
        G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().AddMultiple);
    elseif self.runStep == Enum_RunStep.FlashIcon then
        local cells = _ret.comCells;
        local count = #cells;
        for i = 1, count do
            iCells[cells[i].y][cells[i].x]:Action();
        end
        cells = _ret.sepCells;
        count = #cells;
        for i = 1, count do
            iCells[cells[i].y][cells[i].x]:Action();
        end
        isAction = true;
        local count = #_ret.lines;
        local isJiangjun = false;
        for i = 1, count do
            if _ret.lines[i].value == EnumIconType.EM_IconValue_Gentleman then
                isJiangjun = true;
                break ;
            end
        end
        if isJiangjun then
            G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().FlashSepIcon);
        else
            G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().FlashIcon);
        end
    elseif self.runStep == Enum_RunStep.AddFree then
        local freeCellCount = #_ret.freeCells;
        for i = 1, freeCellCount do
            self.iconCells[_ret.freeCells[i].y][_ret.freeCells[i].x]:Action();
        end
        isAction = true;
        G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().AddFree);
    elseif self.runStep == Enum_RunStep.FreeGame then
        local freeCellCount = #_ret.freeCells;
        for i = 1, freeCellCount do
            self.iconCells[_ret.freeCells[i].y][_ret.freeCells[i].x]:Action();
        end
        isAction = true;
        G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().AddFree);
    end
    if isAction then
        --其他变灰
        for i = 1, xCount do
            for j = 1, yCount do
                iCells[j][i]:Dark();
            end
        end
        --等待结算
        self.runTime = 0;
    end
end

function _CUILayer:_onNormalBalance()
    local _bet, _getGold, _comGold, _ret, _curRet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);

    local smallValue, midValue, bigValue = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetWholeValues);
    local gold;
    if _curRet.wholeValue == 1 then
        gold = _getGold - smallValue
    elseif _curRet.wholeValue == 2 then
        gold = _getGold - midValue
    elseif _curRet.wholeValue == 3 then
        gold = _getGold - bigValue
    else
        gold = _getGold;
    end
    self:_switchGameRunning(Enum_RunStep.NBalance);

    self.balanceUI:ShowResult(gold);

end

--增加免费次数
function _CUILayer:_onRunAddFree()
    local _bet, _getGold, _comGold, _ret, _curRet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    self:_switchGameRunning(Enum_RunStep.AddFBalance);
    self.balanceUI:ShowAddFree(_curRet.extraFreeCount);
end

--检测征战模式
function _CUILayer:_onCheckWarGame()
    self:_switchGameRunning(Enum_RunStep.CWarGame);
    self:_checkResult();
end

--开始运行一统
function _CUILayer:_onRunYiTong()
    self.balanceUI:ShowBeginWar();
    self:_switchGameRunning(Enum_RunStep.Yitong);
end

--还原征战数据
function _CUILayer:_onResetWarData()
    self:_onNodeShow();
    self.qiziControl:Reset();
    G_GlobalGame:DispatchEventByStringKey("ResetWarData");
end

function _CUILayer:_onRunDaizi()
    local _bet, _getGold, _comGold, _ret, _curRet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    self:_switchGameRunning(Enum_RunStep.Daizi);
    self.balanceUI:ShowDaizi(_curRet.totalWarBaseGold);
end

--检测免费游戏
function _CUILayer:_onCheckFreeGame()
    self:_switchGameRunning(Enum_RunStep.CFreeGame);
    self:_checkResult();
end

function _CUILayer:_onRunFreeGame()
    local _bet, _getGold, _comGold, _ret, _curRet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    self:_switchGameRunning(Enum_RunStep.FBalance);
    self.balanceUI:ShowGetFree(_curRet.freeCount);
end

function _CUILayer:_onFreeGameEnd()
    self.balanceUI:Clear();
    G_GlobalGame._soundCtrl:PushBgSound(SoundDefine.EnumSound().FreeBG);
    self:_onGameStateFree();
end

function _CUILayer:_onCheckFreeTotal()
    local status = self.startStatus:Status();
    if status == Enum_StartStatus.Free then
        --免费模式
        local _tfreeCount, _freeGet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetFreeTotal);
        local _freeCount = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetFreeCount);
        if _freeCount <= 0 and _freeGet > 0 then
            --有获得才弹出提示 
            self:_switchGameRunning(Enum_RunStep.FreeTotal);
            if self.startStatus:AutoCount() ~= 0 then
                --自动模式 下
                --显示免费统计
                self.balanceUI:ShowFreeTotal(_tfreeCount, _freeGet);
            else
                self.balanceUI:ShowFreeTotal(_tfreeCount, _freeGet, 3);
            end
        else
            self:_onGameStateFree();
        end
        if _freeCount <= 0 and _freeGet <= 0 then
            --不弹窗的时候
            G_GlobalGame._soundCtrl:PopBgSound();
        end
    else
        --置换成正常模式
        self:_onGameStateFree();
    end
end

function _CUILayer:_onGameStateFree()
    self:_switchGameRunning(Enum_RunStep.Null);
    self.runState = Enum_RunState.Null;
    --这时候可以改变状态
    self.startStatus:ChangeStatus();
    if not self.isClearGetGold then
        if self.startStatus:Status() ~= Enum_StartStatus.Free then
            self.isClearGetGold = true;
        end
    end
    self:_onUpdateGold();
    self:_controlRunMode();
    --控制顶部内容
    self:_controlTopContent();
end

function _CUILayer:OnNumberControl(_diff, _curNumber, _totalNumber, _isEnd)
    if self.runStep == Enum_RunStep.GetWholeValue then
        self.uiGold = self.uiGold + _diff;
        self.uiGetGold = self.uiGetGold + _diff;
        local _bet, _getGold, _comGold, _ret, _curRet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
        local smallValue, midValue, bigValue = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetWholeValues);
        local freeCount = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetFreeCount);

        self:_onChangeGetGold(self.uiGetGold);


        -- if freeCount>0 then
        --     if _curRet.wholeValue==1 then

        --     elseif _curRet.wholeValue==2 then
        --         self:_onChangeGetGold(self.uiGetGold);  

        --     elseif _curRet.wholeValue==3 then
        --         self:_onChangeGetGold(self.uiGetGold);  
        --     end
        -- else
        --     if _curRet.wholeValue==1 then
        --         self:_onChangeGetGold(smallValue);
        --     elseif _curRet.wholeValue==2 then
        --         self:_onChangeGetGold(midValue);
        --     elseif _curRet.wholeValue==3 then
        --         self:_onChangeGetGold(bigValue);     
        --     end
        -- end


        --self.balanceUI:ReduceNumber(_diff);
        if _isEnd then
            --结束了
            --等待一会儿在进入检测
            self:_switchGameRunning(Enum_RunStep.EWhole);
            if self._getGoldMusic then
                G_GlobalGame._soundCtrl:StopSound(self._getGoldMusic);
            end
        end
    elseif self.runStep == Enum_RunStep.GetNumber then
        self.uiGold = self.uiGold + _diff;
        self.uiGetGold = self.uiGetGold + _diff;
        self:_onChangeMyGold(self.uiGold);
        self:_onChangeGetGold(self.uiGetGold);
        if _isEnd then
            self:_onUpdateGold();
            --进入等待环节
            self:_switchGameRunning(Enum_RunStep.EGetNumber);
            if self._getGoldMusic then
                G_GlobalGame._soundCtrl:StopSound(self._getGoldMusic);
            end
        end
    end
end

--
function _CUILayer:OnScrollColumnEvent(_eventID, _eventData)
    if _eventID == EnumEvent.ScrollStop then
        --图标停止转动
        self:_switchGameRunning(Enum_RunStep.Wait);
        --        --停止旗子
        self.qiziControl:Stop();
        --关联图标
        self:_releationNodes();
    end
end

--小游戏结束
function _CUILayer:OnMiniGameEvent(_eventID, _eventData)
    if _eventID == EnumEvent.MiniGameBalance then
        local _getGold = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetSmallGameRet);
        --弹出中奖结果
        self.balanceUI:ShowWarResult(_getGold);
        self:_switchGameRunning(Enum_RunStep.WarBalance);
    elseif _eventID == EnumEvent.MiniGameBigBalance then
        local _getGold = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetSmallGameRet);
        local _bet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
        self.balanceUI:ShowBigResult(_getGold, _bet);
        self:_switchGameRunning(Enum_RunStep.WarBigBalance);
    elseif _eventID == EnumEvent.MiniGameOver then
        --小游戏结束
    end
end

function _CUILayer:OnBalanceEvent(_eventID, _ui, _diff, _isEnd)
    if _eventID == EnumEvent.AddGold then
        --小游戏结束
        --self.uiGold = self.uiGold + _diff;
        --self:_onChangeMyGold(self.uiGold);
        if _isEnd then
            if self.runStep == Enum_RunStep.NBalance then
                self:_onUpdateComGold();
            end
        end
    elseif _eventID == EnumEvent.BalanceOver then
        if self.runStep == Enum_RunStep.GetMultiple then
            local multiple = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetMultiple);
            self.displayTopControl:SetMultiple(multiple);
            self:_onNodeNormal();
            self:_onCheckSuperEffect();
        elseif self.runStep == Enum_RunStep.SuperEffect then
            self:_onCheckWholeEffect();
        elseif self.runStep == Enum_RunStep.WholeEffect then
            self:_onRunGetWholeGold();
        elseif self.runStep == Enum_RunStep.NBalance then
            --获得普通金币
            self:_onRunGetComGold();
        elseif self.runStep == Enum_RunStep.AddFBalance then
            --更新免费次数
            self:_onUpdateFreeCount();
            self:_onNodeNormal();
            self:_switchGameRunning(Enum_RunStep.EAddFBalance);
        elseif self.runStep == Enum_RunStep.Yitong then
            --显示袋子
            self:_onRunDaizi();
        elseif self.runStep == Enum_RunStep.Daizi then
            --正式开始征战游戏
            self.balanceUI:Clear();
            local status = self.startStatus:Status();
            --切換背景音樂
            G_GlobalGame._soundCtrl:SwitchTopBg();

            self:_switchGameRunning(Enum_RunStep.WarGame);
            if self.startStatus:AutoCount() == 0 then
                self.minigame:Start(30);
            else
                self.minigame:Start(6);
            end
        elseif self.runStep == Enum_RunStep.WarBigBalance then
            self.minigame:WarBigBalanceEnd();
        elseif self.runStep == Enum_RunStep.WarBalance then
            --结算界面去掉
            self.balanceUI:Clear();
            --更新自己金币
            self:_onUpdateGold();
            --更新彩金
            self:_onUpdateCaijin();
            --重置
            self:_onResetWarData();
            --点球结算
            self.minigame:Over();
            if self.startStatus:Status() == Enum_StartStatus.Free then
                if not G_GlobalGame._soundCtrl:SwitchTopBg() then
                    --切换到免费游戏音效
                    G_GlobalGame._soundCtrl:PushBgSound(SoundDefine.EnumSound().FreeBG);
                end
            end
            --检测免费
            self:_onCheckFreeGame();
        elseif self.runStep == Enum_RunStep.FBalance then
            self:_onUpdateFreeCount();
            self:_switchGameRunning(Enum_RunStep.EFBalance);
            --            --进入正常状态
            --            self:_onGameStateFree();
        elseif self.runStep == Enum_RunStep.FreeTotal then
            --结算界面去掉
            self.balanceUI:Clear();
            --免费统计过后
            self:_onGameStateFree();
            --回归正常的背景音乐
            G_GlobalGame._soundCtrl:PopBgSound();
        end
    elseif _eventID == EnumEvent.HideSepBalance then

        self.bgImage.color = { r = 1, g = 1, b = 1, a = 1 };
        self.otherBG.color = { r = 48 / 255, g = 137 / 255, b = 240 / 255, a = 0 };
        self.otherStarImage.color = { r = 1, g = 1, b = 1, a = 0 };
    end
end

function _CUILayer:Update(_dt)
    --游戏流程控制
    self:_controlGameRuning(_dt);

    self.longKeyPress:Execute(_dt);

    self.scrollColumnControl:Update(_dt);

    self.balanceUI:Update(_dt);

    self.minigame:Update(_dt);
    --数字控制
    self.numberControl:Update(_dt);
    --控制旗子
    self.qiziControl:Update(_dt);

    self:_controlStatus(_dt);
    --控制格子
    self:_controlIconCells(_dt);
    --显示头部位置
    self.displayTopControl:Update(_dt);
    --控制彩金
    self:_controlCaijin(_dt);
end

function _CUILayer:_controlGameRuning(_dt)
    if self.runStep == Enum_RunStep.Null then

    elseif self.runStep == Enum_RunStep.Scroll then
    elseif self.runStep == Enum_RunStep.Wait then
        self.runTime = self.runTime + _dt;
        if self.runTime >= 0.1 then
            self:_onCheckGetMultiple();
        end

    elseif self.runStep == Enum_RunStep.MulEffect then
        self.runTime = self.runTime + _dt;
        if self.runTime >= 0.3 then
            self:_onRunGetMultiple();
        end

    elseif self.runStep == Enum_RunStep.EWhole then
        self.runTime = self.runTime + _dt;
        if self.runTime >= 0.1 then
            self.balanceUI:Clear();
            --检测普通奖
            self:_onCheckFalshIcon();
        end

    elseif self.runStep == Enum_RunStep.FlashIcon then

        self.runTime = self.runTime + _dt;
        if self.runTime >= 0.1 then
            --静音背景音乐
            self:_onCheckFightCell();
        end

    elseif self.runStep == Enum_RunStep.FightCell then

        self.runTime = self.runTime + _dt;
        if self.runTime >= 0.2 then
            --静音背景音乐 
            self:_onNormalBalance();
        end

    elseif self.runStep == Enum_RunStep.EGetNumber then

        self.runTime = self.runTime + _dt;
        if self.runTime >= 0.1 then
            --进入免费游戏检测
            self:_onCheckAddFreeCount();
        end

    elseif self.runStep == Enum_RunStep.AddFree then

        self.runTime = self.runTime + _dt;
        if self.runTime >= 0.1 then
            self:_onRunAddFree();
        end

    elseif self.runStep == Enum_RunStep.EAddFBalance then

        self.runTime = self.runTime + _dt;
        if self.runTime >= 0.1 then
            self:_onCheckWarGame();
        end

    elseif self.runStep == Enum_RunStep.BeginWarGame then

        self.runTime = self.runTime + _dt;
        if self.runTime >= 0.8 then
            self:_onRunYiTong();
        end

    elseif self.runStep == Enum_RunStep.FreeGame then

        self.runTime = self.runTime + _dt;
        if self.runTime >= 0.3 then
            self:_onRunFreeGame();
        end

    elseif self.runStep == Enum_RunStep.EFBalance then
        self.runTime = self.runTime + _dt;
        if self.runTime >= 0.5 then
            self:_onFreeGameEnd();
        end
    end
end

function _CUILayer:_controlRunMode()
    self.startStatus:ChangeStatus();
    local status = self.startStatus:Status();
    if status == Enum_StartStatus.Normal then
        self.runMode = Enum_RunMode.HandMode;
        self:EnabledChangeBet();
    else
        self.runMode = Enum_RunMode.AutoMode;
        self:DisabledChangeBet();
    end
end

function _CUILayer:_controlTopContent()
    local status = self.startStatus:Status();
    local multiple = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetMultiple);
    --self.multipleNum:SetNumber(multiple);
    if (status == Enum_StartStatus.Free) then
        self.displayTopControl:SetMultiple(multiple);
        self.displayTopControl:ShowMultiple();
        if not self.freeEffectControl.isShow then
            self.freeEffectControl.go:SetActive(true);
            self.freeEffectControl.isShow = true;
        end
        if not self.freeEffectControl.isShowChild then
            self.freeEffectControl.isShowChild = true;
            local count = #self.freeEffectControl.freeObjs;
            for i = 1, count do
                self.freeEffectControl.freeObjs[i]:SetActive(true);
            end
        end
        self.freeMultipleEffect.gameObject:SetActive(true);
    else
        self.displayTopControl:ShowTitle();
        if not self.freeEffectControl.isShow then
            self.freeEffectControl.go:SetActive(true);
            self.freeEffectControl.isShow = true;
        end
        if self.freeEffectControl.isShowChild then
            self.freeEffectControl.isShowChild = false;
            local count = #self.freeEffectControl.freeObjs;
            for i = 1, count do
                self.freeEffectControl.freeObjs[i]:SetActive(false);
            end
        end
        self.freeMultipleEffect.gameObject:SetActive(false);
    end
end

--选择自动次数
function _CUILayer:_onChooseAutoTimes(count)
    --自动次数
    self:_onAutoStart(count);
end

--控制游戏进入
function _CUILayer:ControlGameEnter(_dt)
    --控制游戏开始进入动画
    local ec = self.enterGameControl;
    ec.runTime = ec.runTime + _dt;
    if ec.step == 1 then
        ec.bAlpha = ec.bAlpha + _dt * 0.3;
        if ec.runTime >= 0.5 then
            ec.step = 2;
            ec.runTime = 0;
        end
        if ec.bAlpha >= 1 then
            ec.bAlpha = 1;
        end
        self.bgImage.color = Color.New(1, 1, 1, ec.bAlpha);
        return false;
    elseif ec.step == 2 then
        ec.dy = ec.dy + _dt * 35;
        ec.bAlpha = ec.bAlpha + _dt * 0.35;
        if ec.runTime >= 1 then
            ec.step = 3;
            ec.runTime = 0;
        end
        if ec.bAlpha >= 1 then
            ec.bAlpha = 1;
        end
        if ec.dy >= ec.maxDY then
            ec.dy = ec.maxDY;
        end
        self.bgImage.color = { r = 1, g = 1, b = 1, a = ec.bAlpha };
        self.scrollFrontPanel.localPosition = { x = 0, y = ec.dy, z = 0 };
        return false;
    elseif ec.step == 3 then
        ec.dy = ec.dy + _dt * 40;
        ec.bAlpha = ec.bAlpha + _dt * 0.5;
        ec.cAlpha = ec.cAlpha + _dt * 0.7;
        local cp = 0;
        if ec.bAlpha >= 1 then
            ec.bAlpha = 1;
            cp = cp + 1;
        end
        if ec.cAlpha >= 1 then
            ec.cAlpha = 1;
            cp = cp + 1;
        end
        if ec.dy >= ec.maxDY then
            ec.dy = ec.maxDY;
            cp = cp + 1;
        end
        self.bgImage.color = { r = 1, g = 1, b = 1, a = ec.bAlpha };
        self.scrollFrontPanel.localPosition = { x = 0, y = ec.dy, z = 0 };
        self.contentBGImage.color = { r = 1, g = 1, b = 1, a = ec.cAlpha };
        if cp >= 3 then
            ec.step = 4;
        end
        return false;
    elseif ec.step == 4 then
        return true;
    end
end

function _CUILayer:_controlCaijin(_dt)
    if self.isUpdateCaijin then
        self.updateCaijinTime = self.updateCaijinTime + _dt;
        if self.updateCaijinTime >= 4 then
            self.updateCaijinTime = 0;
            --通知开始游戏
            G_GlobalGame:DispatchEventByStringKey("RequestCaijin");
        end
    elseif self.isNeedUpdateCaijin then
        self.updateCaijinTime = self.updateCaijinTime + _dt;
        if self.updateCaijinTime >= 10 then
            self.isUpdateCaijin = true;
            self.updateCaijinTime = 0;
        end
    end
end

return _CUILayer;