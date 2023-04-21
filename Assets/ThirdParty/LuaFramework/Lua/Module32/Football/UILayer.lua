local GameDefine = GameRequire__("GameDefine");
local KeyEvent = GameRequire__("KeyEvent");
local EventSystem = GameRequire__("EventSystem");
local CAtlasNumber = GameRequire__("AtlasNumber");
local CAnimateDefine = GameRequire__("AnimateDefine");
local SoundDefine = GameRequire__("SoundDefine");
local _CEventObject = GameRequire__("EventObject");
local Enum_GameState = GameDefine.EnumGameState();
local EnumIconType = GameDefine.EnumIconType();
local isInitOver = false
--查找游戏内基本对象信息--加载
local _v_icons = {
    [EnumIconType.EM_IconValue_Shose] = { name = "icons/normal/shoe", darkname = "icons/dark/shoe", abname = "game_fb_ui" },
    [EnumIconType.EM_IconValue_Card] = { name = "icons/normal/rycard", darkname = "icons/dark/rycard", abname = "game_fb_ui" },
    [EnumIconType.EM_IconValue_Flag] = { name = "icons/normal/sideflag", darkname = "icons/dark/sideflag", abname = "game_fb_ui" },
    [EnumIconType.EM_IconValue_Whistle] = { name = "icons/normal/whistle", darkname = "icons/dark/whistle", abname = "game_fb_ui" },
    [EnumIconType.EM_IconValue_Ball] = { name = "icons/normal/ball", darkname = "icons/dark/ball", abname = "game_fb_ui" },
    [EnumIconType.EM_IconValue_Vanguard] = { name = "icons/normal/forward", darkname = "icons/dark/forward", abname = "game_fb_ui" },
    [EnumIconType.EM_IconValue_GoalKeeper] = { name = "icons/normal/keeper", darkname = "icons/dark/keeper", abname = "game_fb_ui" },
    [EnumIconType.EM_IconValue_Trainer] = { name = "icons/normal/coach", darkname = "icons/dark/coach", abname = "game_fb_ui" },
    [EnumIconType.EM_IconValue_Cup] = { name = "icons/normal/jackpot", darkname = "icons/dark/jackpot", abname = "game_fb_ui" },
    [EnumIconType.EM_IconValue_Court] = { name = "icons/normal/wild", darkname = "icons/dark/wild", abname = "game_fb_ui" },
    [EnumIconType.EM_IconValue_Referee] = { name = "icons/normal/scatter", darkname = "icons/dark/scatter", abname = "game_fb_ui" },
};

--游戏内的基本对象存储
local _v_iconsprites = {};
local _f_initLocal = function()
    for i = EnumIconType.EM_IconValue_Null + 1, EnumIconType.EM_IconValue_Max - 1 do
        _v_iconsprites[i] = {};
        _v_iconsprites[i].sprite = G_GlobalGame._goFactory:getCommonSprite(_v_icons[i].abname,
                _v_icons[i].name);
        _v_iconsprites[i].darksprite = G_GlobalGame._goFactory:getCommonSprite(_v_icons[i].abname,
                _v_icons[i].darkname);
    end
end

local _v_ui_cachePool = nil;
--节点数量
local _NodeYCount = {
    [EnumIconType.EM_IconValue_Null] = 0,
    [EnumIconType.EM_IconValue_Shose] = 1,
    [EnumIconType.EM_IconValue_Card] = 1,
    [EnumIconType.EM_IconValue_Flag] = 1,
    [EnumIconType.EM_IconValue_Whistle] = 1,
    [EnumIconType.EM_IconValue_Ball] = 1,
    [EnumIconType.EM_IconValue_Vanguard] = 1,
    [EnumIconType.EM_IconValue_GoalKeeper] = 1,
    [EnumIconType.EM_IconValue_Trainer] = 1,
    [EnumIconType.EM_IconValue_Cup] = 1,
    [EnumIconType.EM_IconValue_Court] = 1,
    [EnumIconType.EM_IconValue_Referee] = 1,
};

--事件枚举
local EnumEvent = {
    Cache = 0, --缓存节点
    Stop = 1, --一列停止
    ScrollStop = 2, --停止转动
    MiniGameOver = 3, --小游戏结束
    JumpNode = 4, --跳出框
    RecoverNode = 5, --回到框
    AddGold = 6, --增加金币
    BalanceOver = 7, --结算消失
    MiniGameBalance = 8, --可以弹结算框了
}

local CupCount = 0;
local RefCount = 0

--=========================================每个格子的基本属性值设置========================================--
--继承自对象事件--EventObject--一个节点
local _CNode = class("_CNode", _CEventObject);

--基本信息赋值
function _CNode:ctor(_value)
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
    self:_initStyle(true);
end

function _CNode:_initStyle(isAnimate)
    if isAnimate then
        if self.animate then
            self.animate:Destroy();
            self.animate = nil;
        end
        self.animate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self.gameObject, CAnimateDefine.Enum_AnimateStyle.Icon_0 + self.value);--添加动画
    end
    self.image.sprite = _v_iconsprites[self.value].sprite;
    self.image:SetNativeSize();
end

--存储
function _CNode:Retain()
    self.reference = self.reference + 1;
end

--释放
function _CNode:Release()
    self.reference = self.reference - 1;
    if self.reference <= 0 then
        self:SendEvent(EnumEvent.Cache);
    end
end

function _CNode:ForceCache()
    self:SendEvent(EnumEvent.Cache);
end

--弹出框
function _CNode:Action()
    self:SendEvent(EnumEvent.JumpNode);
    self.animate:PlayAlways();
end

--变暗
function _CNode:Dark()
    self.image.sprite = _v_iconsprites[self.value].darksprite;
    self.image:SetNativeSize();
end

--回到框
function _CNode:Normal()
    self:SendEvent(EnumEvent.RecoverNode);
    self.animate:Stop();
    self.image.sprite = _v_iconsprites[self.value].sprite;
    self.image:SetNativeSize();
end

function _CNode:Update(dt)

end

function _CNode:YCount()
    return self.yCount;
end

function _CNode:Recount(ycount)
    self.yCount = self.yCount - ycount;
end

--偏移量
function _CNode:SetOffset(_value1, _value2)
    self.offsetX = _value1;
    self.offsetY = _value2;
    self.transform.localPosition = Vector3.New(_value1, _value2, 0);
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
end
--=========================================每个格子的基本属性值设置========================================--
--=========================================转动信息====================================================--
local _CScrollColumn = class("_CScrollColumn", _CEventObject);

--赋值转动信息
function _CScrollColumn:ctor(index, _nodeCreator, _nodeCreator2)
    _CScrollColumn.super.ctor(self);
    self.nodes = {};
    self.isScroll = false;
    self.isStoping = false;
    self.offsetY = 0;
    self.runTime = 0;
    self.speedTime = 0;
    self.smallTime = 0;
    self.scrollSpeed = 0; --转动速度
    self.beginSpeed = 200;
    self.maxSpeed = 0;
    self.step = 0;   -- 0 倒退, 1 加速, 2 匀速, 3 减速
    self.addSpeed = 0;
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

--初始化转动信息
function _CScrollColumn:Init(transform, beginPos, disY)
    self.scrollSpeed = 0; --转动速度
    self.step = 0; --0倒退 1加速, 2 匀速, 3 减速
    self.backMaxSpeed = -250;
    self.backAddSpeed = -450;
    self.beginSpeed = 2100;  --1700
    self.addSpeed = 13000;  --12000
    self.addSpeed2 = 25000;  --19000
    self.maxSpeed = 2700;   --2100
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
    self.effectAnimate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self.effectObj, CAnimateDefine.Enum_AnimateStyle.Quick_Scroll);
    self.disappearIndex = 0;

    if self.columnIndex == 1 then
        self.withouts = { EnumIconType.EM_IconValue_Court };--足球场百搭10
    elseif self.columnIndex == 2 then
        self.withouts = { EnumIconType.EM_IconValue_Referee };--裁判11
    elseif self.columnIndex == 3 then

    elseif self.columnIndex == 4 then
        self.withouts = { EnumIconType.EM_IconValue_Referee };--裁判11
    elseif self.columnIndex == 5 then

    end
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
end

--停止
function _CScrollColumn:Stop()
    if not self.isScroll then
        return ;
    end
    if self.isStoping then
        return ;
    end
    if self.isQuickSpeed then
        --快速开始就快速停止
        self:QuickStop();
        return ;
    end
    self.isStoping = true;
    if self.step == 1 then
        self.step = 2; --匀速转动
        self.speedTime = 0;
        self.scrollSpeed = self.maxSpeed;
    end
    if self.retNodes then
        local stopValue = self.scrollSpeed * self.stopTime - self.addSpeed2 * self.stopTime * self.stopTime * 0.5;
        local yCount = GameDefine.YCount();--4
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
end

--设置节点位置
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
end

function _CScrollColumn:GetColumnNode(index)
    local yCount = GameDefine.YCount();
    if index > yCount then
        return nil;
    end
    return self.nodes[yCount - index + self.beginIndex];
end

function _CScrollColumn:RandomNodes()
    local nodes = self:CreateNodes(GameDefine.YCount() + self.beginIndex - 1, nil, self.withouts);
    self.curCount = #nodes;
    for i = 1, self.curCount do
        self.nodes[i] = nodes[i];
        nodes[i]:SetParent(self.scrollTransform);
    end
    self:ResetNodes();

end

function _CScrollColumn:ScrollOver()
    self.isScroll = false;
    self:SendEvent(EnumEvent.Stop);
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
        return ;
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
end

function _CScrollColumn:QuickStop()
    if not self.isScroll then
        return ;
    end
    if self.isStoping then
        return ;
    end
    if not self.isQuickSpeed then
        self:Stop()
        return ;
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
end

function _CScrollColumn:OnEventNode(_eventID, node)
    if _eventID == EnumEvent.JumpNode then
        node:SetParent(self.transform, true);
    elseif _eventID == EnumEvent.RecoverNode then
        node:SetParent(self.scrollTransform, true);
    end
end
--=========================================转动信息========================================--
--=========================================转动控制========================================--
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
    local beginPos = { x = 0, y = -210, z = 0 };
    local disY = 140;
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
    CupCount = 0;
    RefCount = 0
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
                    --                    if self.isScrollSepCup then
                    --                        if self.columnIndex>=4 then
                    --                            self.scrollStep = 6; --进入特殊环节
                    --                        end
                    --                    else
                    if self.isScrollSepGame or self.isScrollSepCup2 then
                        if self.columnIndex >= 5 then
                            self.scrollStep = 6; --进入特殊环节
                        end
                    end
                    --                    end
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

    local VerNCount = 0

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

            --限制初始化时出现大力神杯和教练的次数
            if value == 9 then
                CupCount = CupCount + 1
            elseif value == 11 then
                VerNCount = VerNCount + 1
                RefCount = RefCount + 1
            end
            if CupCount >= 5 then
                value = self:CupNodeValueCount(RefCount)
                if value == 9 then
                    CupCount = CupCount + 1
                elseif value == 11 then
                    VerNCount = VerNCount + 1
                    RefCount = RefCount + 1
                end
            end
            if RefCount >= 3 then
                value = self:RefNodeValueCount(CupCount)
                if value == 9 then
                    CupCount = CupCount + 1
                elseif value == 11 then
                    VerNCount = VerNCount + 1
                    RefCount = RefCount + 1
                end
            end
            if VerNCount >= 2 then
                value = self:RefNodeValueCount(CupCount)
                if value == 9 then
                    CupCount = CupCount + 1
                elseif value == 11 then
                    VerNCount = VerNCount + 1
                    RefCount = RefCount + 1
                end
            end
            --========================--
            if _value ~= nil then
                _value = value;
                _continueCount = 1;
            end
        end
        yCount = _NodeYCount[value];
        count = count - yCount;
        if (#self.nodes <= 0) then
            node = _CNode.New(value);
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

--
function _CScrollColumnControl:RefNodeValueCount(_num)
    local value = math.random(1, 11);
    while true do

        if value == 9 then
            if _num >= 5 then
                value = math.random(1, 11);
            else
                if value ~= 11 then
                    return value;
                end
            end
        end

        if value == 11 then
            value = math.random(1, 11);
        end
        if value ~= 11 and value ~= 9 then
            return value;
        end
    end
end
--
function _CScrollColumnControl:CupNodeValueCount(_num)
    local value = math.random(1, 11);
    while true do
        if value == 11 then
            if _num >= 3 then
                value = math.random(1, 11);
            else
                if value ~= 9 then
                    return value;
                end
            end
        end
        if value == 9 then
            value = math.random(1, 11);
        end
        if value ~= 9 and value ~= 11 then
            return value;
        end
    end
end

function _CScrollColumnControl:IsContinue()
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
            --            if(math.random(1,10)>2) then
            --                value = _value;
            --            end
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
function _CScrollColumnControl:_createNode(_value)
    local node;
    if (#self.nodes <= 0) then
        node = _CNode.New(_value);
        node:RegEvent(self, self.OnEventNode);
        node:SetParent(_v_ui_cachePool);
    else
        node = self.nodes[#self.nodes];
        table.remove(self.nodes, #self.nodes);
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
            --            if self.isScrollSepCup then
            --                if not self.isQuickMusic then
            --                    G_GlobalGame._soundCtrl:StopSound(self.scrollMusicHandler);
            --                    self.scrollMusicHandler = G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().QuickScroll,-1);
            --                    self.isQuickMusic = true;
            --                end
            --                self.scrollColumns[4]:QuickScroll(true);
            --                self.scrollStep = 5;
            --            end
        elseif self.stopCount == 4 then
            --有特殊环节的要进行处理
            if self.isScrollSepCup2 or self.isScrollSepGame then
                self.scrollColumns[5]:QuickScroll(true);
                if not self.isQuickMusic then
                    G_GlobalGame._soundCtrl:StopSound(self.scrollMusicHandler);
                    self.scrollMusicHandler = G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().QuickScroll, -1);
                    self.isQuickMusic = true;
                end
                self.scrollStep = 5;
            else
                self.scrollStep = 4;
                if self.isQuickMusic then
                    G_GlobalGame._soundCtrl:StopSound(self.scrollMusicHandler);
                    self.scrollMusicHandler = G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().Scroll, -1);
                    self.isQuickMusic = false;
                end
            end
        end
        if self.stopCount >= GameDefine.XCount() then
            self.isScroll = false;
            --结束转动
            self:SendEvent(EnumEvent.ScrollStop);
            if self.scrollMusicHandler then
                G_GlobalGame._soundCtrl:StopSound(self.scrollMusicHandler);
                self.scrollMusicHandler = nil;
            end
        end
    end
end

--开始转动
function _CScrollColumnControl:Scroll()
    --error("==============开始转动=========================")
    if self.isScroll then
        return ;
    end
    self.isContinue = true;
    self.isScroll = true;
    self.runTime = 0;
    self.columnIndex = 1;
    self.scrollStep = 1;
    self.isGetResult = false;
    self.isScrollSepCup = false;
    self.isScrollSepGame = false;
    if not self.scrollMusicHanlder then
        self.scrollMusicHandler = G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().Scroll, -1);
        self.isQuickMusic = false;
    end
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

--判断裁判和大力神杯出现的次数
function _CScrollColumnControl:createResult()
    local _data = self.retData;
    local xCount = GameDefine.XCount();  --5
    local yCount = GameDefine.YCount();  --4
    local resultNodes;
    local node;
    local cupCount = 0;
    local cupCount2 = 0;
    local refereeCount = 0;

    for i = 1, xCount do
        --5
        resultNodes = {};

        for j = 1, yCount do
            --4
            node = self:_createNode(_data[j][i]);

            if (i <= 3) then
                if _data[j][i] == EnumIconType.EM_IconValue_Referee then
                    refereeCount = refereeCount + 1;--判断裁判出现的数量
                elseif _data[j][i] == EnumIconType.EM_IconValue_Cup then
                    cupCount = cupCount + 1;
                end
            end

            if (i <= 4) then
                if _data[j][i] == EnumIconType.EM_IconValue_Cup then
                    cupCount2 = cupCount2 + 1;
                end
            end
            table.insert(resultNodes, 1, node);

        end

        self.scrollColumns[i]:Result(resultNodes);
    end

    --出现的大力神杯次数
    if cupCount >= 3 then
        self.isScrollSepCup = true;
    else
        self.isScrollSepCup = false;
    end
    if cupCount2 >= 4 then
        self.isScrollSepCup2 = true;
    else
        self.isScrollSepCup2 = false;
    end

    --出现两个裁判
    if refereeCount >= 2 then
        self.isScrollSepGame = true;
    else
        self.isScrollSepGame = false;
    end
end

--获取某一个节点
function _CScrollColumnControl:GetNode(_xIndex, _yIndex)
    local column = self.scrollColumns[_xIndex];
    return column:GetColumnNode(_yIndex);
end

--滚动结束
function _CScrollColumnControl:ScrollOver()
    self.retData = nil;
end
--=========================================转动控制========================================--
--================格子设置=====================--
local _CIconCell = class("_CIconCell");

function _CIconCell:ctor()
    self.node = nil;
    self.isAction = false;
    self.isNeedRecover = false;
end

--关联node 
function _CIconCell:ReleationNode(_node)
    self.node = _node;
    self.isAction = false;
    self.isNeedRecover = false;
end

--一般是中奖了抖动
function _CIconCell:Action()
    self.node:Action();
    self.isAction = true;
    self.isNeedRecover = true;
end

--变暗
function _CIconCell:Dark()
    if self.isAction then
        return ;
    end
    self.node:Dark();
    self.isNeedRecover = true;
end
--回到框
function _CIconCell:Normal()
    if not self.isNeedRecover then
        return ;
    end
    self.isAction = false;
    if self.node then
        self.node:Normal();
    end
end

function _CIconCell:Value()
    if self.node then
        return self.node:Value();
    end
end

--
local BUTTON_TYPE = {
    Btn_Null = 0,
    Btn_UpScore = 1,
};
--================格子设置=====================--
--================长按基本信息=====================--
local LongPressItem = class("LongPressItem");

--初始化
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

--初始值
function LongPressItem:Init(_type, longPressTime, intervalTime, longPressHandler, shortPressHandler)
    self.longPressTime = longPressTime or 0; --长按键时间
    self.intervalTime = intervalTime or 0; --周期时间
    self.btnType = _type;
    self.longHandler = longPressHandler;--长按
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

--
function LongPressItem:Stop()
    self.isDown = false;
    if self.isLongPress then

    else
        if self.shortHandler then
            self.shortHandler(self.btnType);
        end
    end
    self.isLongPress = false;
end

function LongPressItem:IsInvalid()
    return self.isDown == false;
end
--================长按基本信息=====================--
--================长按控制=====================--
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
end

--停止
function LongPressControl:Stop(_type)
    local item = self._itemMap:value(_type);
    if item then
        item:Stop();
    end
    self._delList:push_back(_type);
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

--运行模式
local Enum_RunMode = {
    HandMode = idCreator(0), --手动模式--0
    AutoMode = idCreator(), --自动模式--1
};

--运行内容
local Enum_RunContent = {
    Normal = idCreator(0), --0
    PlayingGame = idCreator(), --1 正在游戏
    AutoGame = idCreator(), --2  自动游戏
    FreeGame = idCreator(), --3  免费游戏
    BallGame = idCreator(), --4  点球游戏
};

--运行步骤
local Enum_RunStep = {
    Null = idCreator(0), --0
    Scroll = idCreator(), --正在滚动 1
    Wait = idCreator(), --显示一会儿 2
    WFlashIcon = idCreator(), -- 3
    FlashIcon = idCreator(), -- 4
    NBalance = idCreator(), --普通结算 5
    WSuperCup = idCreator(), --闪烁大力神杯图标 6
    SuperCup = idCreator(), --闪烁大力神杯图标 7
    CBalance = idCreator(), --大力神杯结算 8
    WGetNumber = idCreator(), --等待检测 9
    GetNumber = idCreator(), --获得金币 10
    EFreeGame = idCreator(), --获得金币结束  11
    WFreeGame = idCreator(), --闪烁免费游戏图标  12
    FreeGame = idCreator(), --闪烁免费游戏图标  13
    FBalance = idCreator(), --显示免费结算  14
    BallGame = idCreator(), --点球大战  15
    FreeTotal = idCreator(), --免费统计  16
};

--运行状态
local Enum_RunState = {
    Null = 0,
    PlayingGame = 1,
    OtherGame = 2,
};

local Enum_StartStatus = {
    Normal = 1, --无
    Auto = 2, --自动
    Free = 3, --免费
};
--================长按控制=====================--
--================点球小游戏基本设置=====================--
local _numGold = "numGold";
local _numGold1 = "numGold1";
local _numSilver = "numSilver";
local _numSilver1 = "numSilver1";
local _numContinue = "numContinue";

local _CMiniGame = class("MiniGame", _CEventObject);

local EnumPos = {
    LT = 1, --左上
    LD = 2, --左下
    CT = 3, --中上
    CD = 4, --中下
    RT = 5, --右上
    RD = 6, --右下
};

local selfHandler = function(obj, _handler, tag)
    return function(...)
        return _handler(obj, tag, ...);
    end
end

function _CMiniGame:ctor()
    _CMiniGame.super.ctor(self);
    --self.
    self.ball = nil;
end

function _CMiniGame:Init(transform)
    self.transform = transform;
    self.gameObject = transform.gameObject;

    local buttons = transform:Find("Buttons");
    self.buttonObjs = buttons.gameObject;

    local btn = buttons:Find("LT");

    local eventTrigger = Util.AddComponent("EventTriggerListener", btn.gameObject);
    eventTrigger.onClick = selfHandler(self, self._onClickPos, EnumPos.LT);

    btn = buttons:Find("LD");
    eventTrigger = Util.AddComponent("EventTriggerListener", btn.gameObject);
    eventTrigger.onClick = selfHandler(self, self._onClickPos, EnumPos.LD);

    btn = buttons:Find("CT");
    eventTrigger = Util.AddComponent("EventTriggerListener", btn.gameObject);
    eventTrigger.onClick = selfHandler(self, self._onClickPos, EnumPos.CT);

    btn = buttons:Find("CD");
    eventTrigger = Util.AddComponent("EventTriggerListener", btn.gameObject);
    eventTrigger.onClick = selfHandler(self, self._onClickPos, EnumPos.CD);

    btn = buttons:Find("RT");
    eventTrigger = Util.AddComponent("EventTriggerListener", btn.gameObject);
    eventTrigger.onClick = selfHandler(self, self._onClickPos, EnumPos.RT);

    btn = buttons:Find("RD");
    eventTrigger = Util.AddComponent("EventTriggerListener", btn.gameObject);
    eventTrigger.onClick = selfHandler(self, self._onClickPos, EnumPos.RD);

    --足球
    self.ball = transform:Find("Ball");
    self.ballObj = self.ball.gameObject;
    self.ballShadow = transform:Find("BallShader");
    self.ballShadowObj = self.ballShadow.gameObject;

    self.keepers = {};
    local keepers = transform:Find("Keepers");

    local keeper = keepers:Find("LT");
    self.keepers[EnumPos.LT] = { transform = keeper, gameObject = keeper.gameObject, kickerAnimate = nil, shadowAnimate = nil };
    self.keepers[EnumPos.LT].kickerAnimate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(keeper:Find("Body").gameObject, CAnimateDefine.Enum_AnimateStyle.Keeper_LT);
    self.keepers[EnumPos.LT].shadowAnimate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(keeper:Find("Shadow").gameObject, CAnimateDefine.Enum_AnimateStyle.Keeper_LT);

    keeper = keepers:Find("LD");
    self.keepers[EnumPos.LD] = { transform = keeper, gameObject = keeper.gameObject, kickerAnimate = nil, shadowAnimate = nil };
    self.keepers[EnumPos.LD].kickerAnimate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(keeper:Find("Body").gameObject, CAnimateDefine.Enum_AnimateStyle.Keeper_LD);
    self.keepers[EnumPos.LD].shadowAnimate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(keeper:Find("Shadow").gameObject, CAnimateDefine.Enum_AnimateStyle.Keeper_LD);

    keeper = keepers:Find("CT");
    self.keepers[EnumPos.CT] = { transform = keeper, gameObject = keeper.gameObject, kickerAnimate = nil, shadowAnimate = nil };
    self.keepers[EnumPos.CT].kickerAnimate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(keeper:Find("Body").gameObject, CAnimateDefine.Enum_AnimateStyle.Keeper_CT);
    self.keepers[EnumPos.CT].shadowAnimate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(keeper:Find("Shadow").gameObject, CAnimateDefine.Enum_AnimateStyle.Keeper_CT);

    keeper = keepers:Find("CD");
    self.keepers[EnumPos.CD] = { transform = keeper, gameObject = keeper.gameObject, kickerAnimate = nil, shadowAnimate = nil };
    self.keepers[EnumPos.CD].kickerAnimate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(keeper:Find("Body").gameObject, CAnimateDefine.Enum_AnimateStyle.Keeper_CD);
    self.keepers[EnumPos.CD].shadowAnimate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(keeper:Find("Shadow").gameObject, CAnimateDefine.Enum_AnimateStyle.Keeper_CD);

    keeper = keepers:Find("RT");
    self.keepers[EnumPos.RT] = { transform = keeper, gameObject = keeper.gameObject, kickerAnimate = nil, shadowAnimate = nil };
    self.keepers[EnumPos.RT].kickerAnimate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(keeper:Find("Body").gameObject, CAnimateDefine.Enum_AnimateStyle.Keeper_LT);
    self.keepers[EnumPos.RT].shadowAnimate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(keeper:Find("Shadow").gameObject, CAnimateDefine.Enum_AnimateStyle.Keeper_LT);

    keeper = keepers:Find("RD");
    self.keepers[EnumPos.RD] = { transform = keeper, gameObject = keeper.gameObject, kickerAnimate = nil, shadowAnimate = nil };
    self.keepers[EnumPos.RD].kickerAnimate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(keeper:Find("Body").gameObject, CAnimateDefine.Enum_AnimateStyle.Keeper_LD);
    self.keepers[EnumPos.RD].shadowAnimate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(keeper:Find("Shadow").gameObject, CAnimateDefine.Enum_AnimateStyle.Keeper_LD);

    self.wholeMask = transform:Find("WholeMask");
    self.mask = transform:Find("Mask");
    eventTrigger = Util.AddComponent("EventTriggerListener", self.wholeMask.gameObject);
    eventTrigger.onClick = handler(self, self._onClickMask);
    eventTrigger = Util.AddComponent("EventTriggerListener", self.mask.gameObject);
    eventTrigger.onClick = handler(self, self._onClickMask);
    self.tips = transform:Find("Tips");
    self.tipsObj = self.tips.gameObject;
    self.wholeMaskObj = self.wholeMask.gameObject;
    self.maskObj = self.mask.gameObject;

    self.footBaller = transform:Find("FootBaller");
    self.footBallerObj = self.footBaller.gameObject;
    self.footAnimate = G_GlobalGame.FunctionsLib.FUNC_AddAnimateSet(self.footBaller:Find("FootBaller").gameObject, CAnimateDefine.Enum_AnimateSetStyle.FootBaller);
    self.footShadowAnimate = G_GlobalGame.FunctionsLib.FUNC_AddAnimateSet(self.footBaller:Find("Shadow").gameObject, CAnimateDefine.Enum_AnimateSetStyle.FootBaller);
    self.footShadowAnimate:ListenTime(handler(self, self._onListenerFooter));
    self.footShadowAnimate:SetEndHandler(handler(self, self._onListenerFooterEnd));

    self.footFrameData = {
        [1] = {
            pos = VECTOR3NEW(-132, -447, 0),
            rotation = Quaternion.Euler(0, 0, 24.2),
            scale = VECTOR3NEW(0.9, -0.5, 1),
        },
        [2] = {
            pos = VECTOR3NEW(-132, -454, 0),
            rotation = Quaternion.Euler(0, 0, 20.4),
            scale = VECTOR3NEW(0.9, -0.6, 1),
        },
        [3] = {
            pos = VECTOR3NEW(-151, -446, 0),
            rotation = Quaternion.Euler(0, 0, 7.5),
            scale = VECTOR3NEW(0.9, -0.6, 1),
        },
        [4] = {
            pos = VECTOR3NEW(-204, -248, 0),
            rotation = Quaternion.Euler(0, 0, -57.4),
            scale = VECTOR3NEW(0.9, -0.6, 1),
        },
        [5] = {
            pos = VECTOR3NEW(-180, -232, 0),
            rotation = Quaternion.Euler(0, 0, -57.4),
            scale = VECTOR3NEW(0.9, -0.6, 1),
        },
    };

    self.targetInfo = {
        [EnumPos.LT] = {
            ballPos = VECTOR3NEW(-365, 221, 0), --11
            ballScale = VECTOR3NEW(0.9, 0.9, 0.9),
            ballShadowPos = VECTOR3NEW(-365, -60, 0),
            ballShadowScale = VECTOR3NEW(0.75, 0.75, 0.75),
            useTime = 0.55,
        },
        [EnumPos.LD] = {
            ballPos = VECTOR3NEW(-362, -20, 0), --13
            ballScale = VECTOR3NEW(0.9, 0.9, 0.9),
            ballShadowPos = VECTOR3NEW(-362, -50, 0),
            ballShadowScale = VECTOR3NEW(0.9, 0.9, 0.9),
            useTime = 0.6,
        },
        [EnumPos.CT] = {
            ballPos = VECTOR3NEW(8, 245, 0), --13
            ballScale = VECTOR3NEW(0.9, 0.9, 0.9),
            ballShadowPos = VECTOR3NEW(8, -67, 0),
            ballShadowScale = VECTOR3NEW(0.75, 0.75, 0.75),
            useTime = 0.6,
        },
        [EnumPos.CD] = {
            ballPos = VECTOR3NEW(-36, -48, 0),
            ballScale = VECTOR3NEW(0.9, 0.9, 0.9),
            ballShadowPos = VECTOR3NEW(-36.5, -76, 0), --6
            ballShadowScale = VECTOR3NEW(0.9, 0.9, 0.9),
            useTime = 0.4,
        },
        [EnumPos.RT] = {
            ballPos = VECTOR3NEW(365, 221, 0), --11
            ballScale = VECTOR3NEW(0.9, 0.9, 0.9),
            ballShadowPos = VECTOR3NEW(365, -60, 0),
            ballShadowScale = VECTOR3NEW(0.75, 0.75, 0.75),
            useTime = 0.55,
        },
        [EnumPos.RD] = {
            ballPos = VECTOR3NEW(365, -20, 0), --13
            ballScale = VECTOR3NEW(0.9, 0.9, 0.9),
            ballShadowPos = VECTOR3NEW(365, -50, 0),
            ballShadowScale = VECTOR3NEW(0.9, 0.9, 0.9),
            useTime = 0.6,
        },
    };

    self.targetInInfo = {
        [EnumPos.LT] = {
            ballPos = VECTOR3NEW(-389, 234, 0), --11
            ballScale = VECTOR3NEW(0.8, 0.9, 0.9),
            ballShadowPos = VECTOR3NEW(-381, -39, 0),
            ballShadowScale = VECTOR3NEW(0.7, 0.75, 0.75),
            useTime = 0.55,
        },
        [EnumPos.LD] = {
            ballPos = VECTOR3NEW(-352, 11, 0), --13
            ballScale = VECTOR3NEW(0.9, 0.9, 0.9),
            ballShadowPos = VECTOR3NEW(-352, -16, 0),
            ballShadowScale = VECTOR3NEW(0.86, 0.86, 0.86),
            useTime = 0.6,
        },
        [EnumPos.CT] = {
            ballPos = VECTOR3NEW(8, 217, 0), --13
            ballScale = VECTOR3NEW(0.86, 0.86, 0.86),
            ballShadowPos = VECTOR3NEW(8, -36, 0),
            ballShadowScale = VECTOR3NEW(0.75, 0.75, 0.75),
            useTime = 0.6,
        },
        [EnumPos.CD] = {
            ballPos = VECTOR3NEW(-36, -2, 0),
            ballScale = VECTOR3NEW(0.9, 0.9, 0.9),
            ballShadowPos = VECTOR3NEW(-36.5, -28, 0), --6
            ballShadowScale = VECTOR3NEW(0.85, 0.85, 0.85),
            useTime = 0.4,
        },
        [EnumPos.RT] = {
            ballPos = VECTOR3NEW(388, 234, 0), --11
            ballScale = VECTOR3NEW(0.8, 0.9, 0.9),
            ballShadowPos = VECTOR3NEW(381, -39, 0),
            ballShadowScale = VECTOR3NEW(0.7, 0.75, 0.75),
            useTime = 0.55,
        },
        [EnumPos.RD] = {
            ballPos = VECTOR3NEW(352, 11, 0), --13
            ballScale = VECTOR3NEW(0.9, 0.9, 0.9),
            ballShadowPos = VECTOR3NEW(352, -16, 0),
            ballShadowScale = VECTOR3NEW(0.86, 0.86, 0.86),
            useTime = 0.6,
        },
    };

    self.keeperPos = {
        [EnumPos.LT] = {
            --size = 188x155
            [1] = {
                pos = VECTOR3NEW(-16, 66, 0), --
                scale = VECTOR3NEW(1, 0.7, 1),
            },
        },
        [EnumPos.CD] = {
            --size = 304x288
            [1] = {
                pos = VECTOR3NEW(-64, 25, 0), --
                scale = VECTOR3NEW(1, 0.7, 1),
            },
        },
        [EnumPos.LD] = {
            --size = 304x288
            [1] = {
                pos = VECTOR3NEW(-162, 37, 0), --
                scale = VECTOR3NEW(1, 0.7, 1),
            },
        },
        [EnumPos.LT] = {
            --size = 304x288
            [1] = {
                pos = VECTOR3NEW(-217, 40, 0), --
                scale = VECTOR3NEW(1, 0.7, 1),
            },
        },
        [EnumPos.RD] = {
            --size = 304x288
            [1] = {
                pos = VECTOR3NEW(-159, 38, 0), --
                scale = VECTOR3NEW(1, 0.7, 1),
            },
        },
        [EnumPos.RT] = {
            --size = 304x288
            [1] = {
                pos = VECTOR3NEW(-216, 81, 0), --
                scale = VECTOR3NEW(1, 0.7, 1),
            },
        },
    };

    self.ballBeginPos = VECTOR3NEW(0, -187.5, 0);
    self.ballShadowBeginPos = VECTOR3NEW(0, -221, 0);

    self.runTime = 0;
    self.step = 0; --状态
    self.curKeeper = nil;
    self.isDataCB = false;
    self.totalTime = 0;
    self.isShotIn = false;
end

--开始函数
function _CMiniGame:Start()
    self.gameObject:SetActive(true);
    self.tipsObj:SetActive(true);
    --self.wholeMaskObj:SetActive(true);
    self.wholeMaskObj:SetActive(false);
    self.buttonObjs:SetActive(true);
    self.maskObj:SetActive(true);
    self.footBallerObj:SetActive(false);
    self:_changeKeeper(self.keepers[EnumPos.CT]);
    self.ball.localPosition = self.ballBeginPos;
    self.ball.localScale = VECTOR3NEW(1, 1, 1);
    self.ballShadow.localPosition = self.ballShadowBeginPos;
    self.ballShadow.localScale = VECTOR3NEW(1, 1, 1);
    self.isDataCB = false;
    self.step = 1;
    self.totalTime = 20;
end

function _CMiniGame:_changeKeeper(keeper, isPlay)
    if self.curKeeper then
        self.curKeeper.gameObject:SetActive(false);
    end
    self.curKeeper = keeper;
    keeper.gameObject:SetActive(true);
    keeper.kickerAnimate:Play()
    if not isPlay then
        keeper.kickerAnimate:Stop();
    end
    keeper.shadowAnimate:Play();
    if not isPlay then
        keeper.shadowAnimate:Stop();
    end
end

--结束函数
function _CMiniGame:Over()
    self.gameObject:SetActive(false);
end

function _CMiniGame:_onListenerFooter(index, dt, isNew)
    if isNew then
        local transform = self.footShadowAnimate.transform;
        transform.localPosition = self.footFrameData[index].pos;
        transform.localRotation = self.footFrameData[index].rotation;
        transform.localScale = self.footFrameData[index].scale;
    end
end

function _CMiniGame:_onListenerFooterEnd()
    local info;
    if self.isShotIn then
        info = self.targetInInfo[self.target];
    else
        info = self.targetInfo[self.target];
    end
    self.ball:DOScale(info.ballScale, info.useTime);
    local dotw = self.ball:DOLocalMove(info.ballPos, info.useTime, false);
    self.ballShadow:DOScale(info.ballShadowScale, info.useTime);
    self.ballShadow:DOLocalMove(info.ballShadowPos, info.useTime);
    self:_createKeeperAnimate();
    --播放踢球动画
    --error("播放踢球动画")
    G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().Shot);
    dotw:OnComplete(
            function()
                coroutine.start(
                        function()
                            if self.isShotIn then
                                --停留半秒后才弹出结算
                                coroutine.wait(0.8);
                            else
                                --停留半秒后才弹出结算
                                coroutine.wait(0.5);
                            end
                            --结算
                            self:_onNotifyBalance();
                        end
                );
            end
    );
end

--点球奖励类型
function _CMiniGame:_createKeeperAnimate()
    --error("点球奖励类型=="..self.ret)
    local EnumGoalType = GameDefine.EnumGoalType();
    if self.ret == EnumGoalType.EM_GoalValue_Null then
        local keeper = self.keepers[self.target];
        self:_changeKeeper(keeper, true);
        self.isShotIn = false;
    else
        local index = math.random(1, 5);
        local target = 0;
        while (index > 0) do
            target = target + 1;
            if target ~= self.target then
                index = index - 1;
            end
        end
        --一种跳错方向
        local keeper = self.keepers[target];
        self:_changeKeeper(keeper, true);
        self.isShotIn = true;
    end
end

function _CMiniGame:_randomShot()
    local index = math.random(EnumPos.LT, EnumPos.RD);
    self:_onClickPos(index);
end

function _CMiniGame:Update(_dt)
    if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then
        if GameManager.IsStopGame then
            return
        end
        if isInitOver == false then
            return
        end
        if self.step == 1 then
            self.runTime = self.runTime + _dt;
            if self.runTime >= self.totalTime then
                self:_randomShot();
                self.runTime = 0;
                self.step = 2;
            end
        elseif self.step == 2 then
            self.runTime = self.runTime + _dt;
            if self.runTime >= 1 then
                if self.isDataCB then
                    self:_onKickBall();
                    self.runTime = 0;
                    self.step = 3;
                end
            end
        elseif self.step == 3 then
            self.runTime = self.runTime + _dt;
            if self.runTime >= 2 then
                ---self:_onKickBall();
                self.runTime = 0;
            end
        end
    end
end

function _CMiniGame:_onClickMask()
    self:_closeMask();
end

function _CMiniGame:_onClickPos(pos)
    error("通知开始点球")
    --目标
    self.target = pos;
    self:_closeButtons();
    self:_closeMask();
    --通知开始点球
    G_GlobalGame:DispatchEventByStringKey("StartBallGame");
    --显示足球运动员
    self:displayActors();
    --
    self:_onStart();
end

function _CMiniGame:displayActors()
    self.footBallerObj:SetActive(true);
    self.ballObj:SetActive(true);
    self.ballShadowObj:SetActive(true);
    self.footAnimate:Play();
    self.footShadowAnimate:Play();
    self.footAnimate:Stop();
    self.footShadowAnimate:Stop();

    local transform = self.footShadowAnimate.transform;
    transform.localPosition = self.footFrameData[1].pos;
    transform.localRotation = self.footFrameData[1].rotation;
    transform.localScale = self.footFrameData[1].scale;
end

function _CMiniGame:_closeButtons()
    self.buttonObjs:SetActive(false);
end

function _CMiniGame:_closeMask()
    self.tipsObj:SetActive(false);
    self.wholeMaskObj:SetActive(false);
    self.maskObj:SetActive(false);
end

function _CMiniGame:_onStart()
    self.step = 2;
    self.runTime = 0;
end

function _CMiniGame:_onKickBall()
    self.footAnimate:Play();
    self.footShadowAnimate:Play();
end

function _CMiniGame:OnBallDataCB(ret)
    self.isDataCB = true;
    self.ret = ret;
    local EnumGoalType = GameDefine.EnumGoalType();
    if self.ret == EnumGoalType.EM_GoalValue_Null then
        self.isShotIn = false;
    else
        self.isShotIn = true;
    end
end

function _CMiniGame:_onNotifyBalance()
    self:SendEvent(EnumEvent.MiniGameBalance);
end
--================点球小游戏基本设置=====================--
local Enum_BalanceType = {
    Common = 1,
    Cup = 2,
    Ball = 3,
};
local _CBalanceUI = class("CBalanceUI", _CEventObject);

function _CBalanceUI:ctor()
    _CBalanceUI.super.ctor(self);
    self.bigAnimate = nil;
    self.normalAnimate = nil;
    self.multipleAnimate = nil;
    self.cupAnimate = nil;
    self.loseAnimate = nil;
    self.enterBallAnimate = nil;
    self.normalNumber = nil;
    self.cupNumber = nil;
    self.bigNumber = nil;
    self.bigAnimateObj = nil;
    self.normalAnimateObj = nil;
    self.multipleAnimateObj = nil;
    self.cupAnimateObj = nil;
    self.loseAnimateObj = nil;
    self.enterBallAnimateObj = nil;
    --self.multipleControls     = {0,180,600};
end

function _CBalanceUI:Init(transform, frontTransform)
    self.transform = transform;
    self.gameObject = transform.gameObject;
    self.frontTransform = frontTransform;
    self.frontGameObject = frontTransform.gameObject;
    self.bigAnimate = transform:Find("bigwin"):GetComponent("Animator");
    self.normalAnimate = transform:Find("nomal1"):GetComponent("Animator");
    self.normalImageComponent = self.normalAnimate.gameObject:GetComponent("Image");
    self.multipleAnimate = transform:Find("nomal2"):GetComponent("Animator");
    self.loseAnimate = transform:Find("lose"):GetComponent("Animator");
    self.cupAnimate = transform:Find("megawin"):GetComponent("Animator");
    self.enterBallAnimate = transform:Find("game"):GetComponent("Animator");
    self.bigAnimateObj = self.bigAnimate.gameObject;
    self.normalAnimateObj = self.normalAnimate.gameObject;
    self.multipleAnimateObj = self.multipleAnimate.gameObject;
    self.cupAnimateObj = self.cupAnimate.gameObject;
    self.loseAnimateObj = self.loseAnimate.gameObject;
    self.enterBallAnimateObj = self.enterBallAnimate.gameObject;
    self.bigAnimateObj:SetActive(false);
    self.normalAnimateObj:SetActive(false);
    self.multipleAnimateObj:SetActive(false);
    self.cupAnimateObj:SetActive(false);
    self.loseAnimateObj:SetActive(false);
    self.enterBallAnimateObj:SetActive(false);

    self.cupFrontObj = self.frontGameObject;
    self.cupFrontObj:SetActive(false);

    self.prositgetObj = self.normalAnimate.transform:Find("prositget").gameObject;

    --免费统计
    local freeTotalUI = G_GlobalGame._goFactory:createFreeTotal();
    self.freeTransform = freeTotalUI.transform;
    self.freeTransform:SetParent(self.transform);
    self.freeTransform.localPosition = Vector3.zero;
    self.freeTransform.localScale = Vector3.one;
    self.freeTransformObj = self.freeTransform.gameObject;
    self.freeTransformObj:SetActive(false);

    local free = self.freeTransform:Find("Free/FreeCount");
    self.freeNumber = CAtlasNumber.CreateWithGroupName(_numGold1, -4);
    self.freeNumber:SetParent(free);
    self.freeNumber:SetLocalScale(C_Vector3_One);

    free = self.freeTransform:Find("Value");
    self.freeValueNumber = CAtlasNumber.CreateWithGroupName(_numGold1, -4, HorizontalAlignType.Mid, VerticalAlignType.Mid);
    self.freeValueNumber:SetParent(free);
    self.freeValueNumber:SetLocalScale(C_Vector3_One);
    self.freeValueNumber:SetSpace(45, 0);

    local number = self.cupAnimate.transform:Find("numcont");
    self.cupNumber = CAtlasNumber.CreateWithGroupName(_numGold1, -4);
    self.cupNumber:SetParent(number);
    self.cupNumber:SetLocalScale(C_Vector3_One);

    number = self.normalAnimate.transform:Find("numcont");
    self.normalNumber = CAtlasNumber.CreateWithGroupName(_numGold1, -4);
    self.normalNumber:SetParent(number);
    self.normalNumber:SetLocalScale(C_Vector3_One);

    number = self.bigAnimate.transform:Find("numcont");
    self.bigNumber = CAtlasNumber.CreateWithGroupName(_numSilver1, -4);
    self.bigNumber:SetParent(number);
    self.bigNumber:SetLocalScale(C_Vector3_One);

    self.curAnimate = nil;
    self.curObj = nil;
    self.value = 0;
    self.isDisplay = false;
    self.isOver = true;

    self.stop1Number = 0;
    self.stop2Number = 0;
    self.numAddSpeed = 0;
    self.numAddSpeed2 = 0;
    self.numSpeed = 0;
    self.numTime1 = 0;
    self.numTime2 = 0;
    self.numberStep = 0;
    self.numberRunTime = 0;

    self.lastNumber = 0;
    self.waitTime = 0;
    self.numberBeginValue = 0;
    self.isAddNumber = false;

    self.balanceType = 0;

    self.runTime = 0;
    self.totalTime = 0;

    self.musicHanlder = nil;

    self.multipleControls = {
        [1] = {
            animate = self.normalAnimate,
            number = self.normalNumber,
            obj = self.normalAnimateObj,
            disabledComponents = { self.normalImageComponent },
            limiteMultiple = 444,
            limiteValue = 0,
            music = SoundDefine.EnumSound().NormalBalance,
        },
        [2] = {
            animate = self.bigAnimate,
            number = self.bigNumber,
            obj = self.bigAnimateObj,
            limiteMultiple = 888,
            limiteValue = 0,
            music = SoundDefine.EnumSound().BigBalance,
        },
        [3] = {
            animate = self.cupAnimate,
            number = self.cupNumber,
            obj = self.cupAnimateObj,
            displayObjs = { self.cupFrontObj },
            limiteMultiple = -1,
            limiteValue = -1,
            music = SoundDefine.EnumSound().BigBalance,
        },
    };
    self.cupControls = {
        [1] = {
            animate = self.cupAnimate,
            number = self.cupNumber,
            obj = self.cupAnimateObj,
            displayObjs = { self.cupFrontObj },
            limiteMultiple = -1,
            limiteValue = -1,
            music = SoundDefine.EnumSound().BigBalance,
        },
    };
    self.ballControls = {
        [1] = {
            animate = self.normalAnimate,
            number = self.normalNumber,
            obj = self.normalAnimateObj,
            displayObjs = { self.prositgetObj },
            limiteMultiple = -1,
            limiteValue = -1,
            music = SoundDefine.EnumSound().BallBalance,
        },
    };
    self.curControls = nil;
    self.curControl = nil;
    self.curStep = 1;
end

function _CBalanceUI:Update(_dt)
    if not self.isDisplay then
        return ;
    end
    if self.isOver then
        return ;
    end
    self.runTime = self.runTime + _dt;
    if self.isAddNumber then
        if self.waitTime > _dt then
            self.waitTime = self.waitTime - _dt;
            return ;
        end
        _dt = _dt - self.waitTime;
        --        if self.runTime>=15 then
        --            if not G_GlobalGame:isOpenLog() then
        --                G_GlobalGame:openLog();
        --            end
        --        end
        self.waitTime = 0;
        self.numberRunTime = self.numberRunTime + _dt;
        if self.numberStep == 1 then
            local value = math.ceil(self.numSpeed * self.numberRunTime + self.numAddSpeed * 0.5 * self.numberRunTime * self.numberRunTime);
            if value >= self.stop1Number then
                value = self.stop1Number;
            end
            if value + self.numberBeginValue <= self.lastNumber then
                value = self.lastNumber - self.numberBeginValue + 3;
            end
            local control = self.curControls[self.curStep];
            if control.limiteMultiple > 0 then
                if control.limiteValue <= value + self.numberBeginValue then
                    value = control.limiteValue - self.numberBeginValue;
                    self.curStep = self.curStep + 1;
                    control = self.curControls[self.curStep];
                    self:_renewControl(control, value, 0.8);
                end
            end
            if value >= self.stop1Number then
                value = self.stop1Number;
                self.numberStep = 2;
                self.numberRunTime = 0;
                self.numSpeed = self.numAddSpeed * self.numTime1;
            end
            local diff = value + self.numberBeginValue - self.lastNumber;
            control.number:SetNumber(value + self.numberBeginValue);
            self.lastNumber = value + self.numberBeginValue;
            if diff > 0 then
                self:SendEvent(EnumEvent.AddGold, diff);
            end
        elseif self.numberStep == 2 then
            local value = math.ceil(self.numSpeed * self.numberRunTime + self.numAddSpeed2 * 0.5 * self.numberRunTime * self.numberRunTime)
                    + self.stop1Number;
            if value >= self.stop2Number then
                value = self.stop2Number;
            end
            if value + self.numberBeginValue <= self.lastNumber then
                value = self.lastNumber - self.numberBeginValue + 3;
            end
            local control = self.curControls[self.curStep];
            if control.limiteMultiple > 0 then
                if control.limiteValue <= value + self.numberBeginValue then
                    value = control.limiteValue - self.numberBeginValue;
                    self.curStep = self.curStep + 1;
                    control = self.curControls[self.curStep];
                    self:_renewControl(control, value, 0.8);
                end
            end
            if value >= self.stop2Number then
                value = self.stop2Number;
                self.numberStep = 3;
                self.numberRunTime = 0;
                self.isAddNumber = false;
            end
            control.number:SetNumber(value + self.numberBeginValue);
            local diff = value + self.numberBeginValue - self.lastNumber;
            self.lastNumber = value + self.numberBeginValue;
            if diff > 0 then
                self:SendEvent(EnumEvent.AddGold, diff, self.numberStep == 3);
            end
        end
    else
        if self.runTime >= self.totalTime then
            self.isOver = true;
            self:SendEvent(EnumEvent.BalanceOver);
        end
    end
end

function _CBalanceUI:_renewControl(control, value, waittime, isHaveShan)
    self:_clear();
    --control.animate:Play();
    --if control.animate then
    --control.animate:StartPlayback();
    --end
    control.number:SetNumber(value);
    self.waitTime = waittime;
    self.curAnimate = control.animate;
    self.curObj = control.obj;
    self.curObj:SetActive(true);
    self.curControl = control;
    if isHaveShan then
        self.curObj.transform.localScale = Vector3.zero;
        --解决开始会闪一下的问题
        coroutine.start(
                function()
                    coroutine.wait(0.05);
                    self.curObj.transform.localScale = Vector3.one;
                end
        );
    end

    local objects = control.displayObjs;
    if objects ~= nil and #objects > 0 then
        for i = 1, #objects do
            objects[i]:SetActive(true);
        end
    end

    objects = control.hideObjs;
    if objects ~= nil and #objects > 0 then
        for i = 1, #objects do
            objects[i]:SetActive(false);
        end
    end

    local components = self.curControl.enabledComponents;
    if components ~= nil and #components > 0 then
        for i = 1, #components do
            components[i].enabled = true;
        end
    end

    components = self.curControl.disabledComponents;
    if components ~= nil and #components > 0 then
        for i = 1, #components do
            components[i].enabled = false;
        end
    end

    if self.musicHanlder then
        G_GlobalGame._soundCtrl:StopSound(self.musicHanlder);
        self.musicHanlder = nil;
    end
    self.musicHanlder = G_GlobalGame._soundCtrl:PlaySound(control.music);
end

--显示普通奖
function _CBalanceUI:ShowResult(_value, _bet)
    --error("显示普通奖")
    self.isDisplay = true;
    self.runTime = 0;
    self.numberBeginValue = 0;
    self.numSpeed = 0;
    self.numberRunTime = 0;
    self.isOver = false;
    if _value < _bet * 10 then
        self:_countSpeed(tonumber(_value), 5, 0.55, 0.25);
        self.totalTime = 0.5;
    elseif _value < _bet * 444 then
        self:_countSpeed(tonumber(_value), 10, 0.65, 0.3);
        self.totalTime = 0.8;
    elseif _value < _bet * 888 then
        self:_countSpeed(tonumber(_value), 10, 1.4, 0.6);
        self.totalTime = 0.5;
    else
        self.totalTime = 0.5;
        self:_countSpeed(tonumber(_value), 20, 1.8, 0.9);
    end
    self.curStep = 1;
    self.curControls = self.multipleControls;
    local count = #self.multipleControls;
    for i = 1, count do
        self.multipleControls[i].limiteValue = self.multipleControls[i].limiteMultiple * _bet;
    end
    self:_renewControl(self.curControls[self.curStep], 0, 0.4);
end


--显示大奖
function _CBalanceUI:ShowBigResult(_value, _bet)
    self.isDisplay = true;
    self.totalTime = 1.5;
    self.runTime = 0;
    self.numberBeginValue = 0;
    self.numSpeed = 0;
    self.numberRunTime = 0;
    self.isOver = false;
    self:_countSpeed(tonumber(_value), 0, 1.2, 0.6);
    self.curStep = 1;
    self.curControls = self.multipleControls;
    local count = #self.multipleControls;
    for i = 1, count do
        self.multipleControls[i].limiteValue = self.multipleControls[i].limiteMultiple * _bet;
    end
    self:_renewControl(self.curControls[self.curStep], 0, 0.4);
end

--显示大力神杯
function _CBalanceUI:ShowCupResult(_value, _bet)
    --error("显示大力神杯")
    self.isDisplay = true;
    self.totalTime = 2.6;
    self.runTime = 0;
    self.numberBeginValue = 0;
    self.numSpeed = 0;
    self.numberRunTime = 0;
    self.isOver = false;
    self:_countSpeed(tonumber(_value), 11, 1.2, 0.6);
    self.curStep = 1;
    self.curControls = self.cupControls;
    local count = #self.cupControls;
    for i = 1, count do
        self.cupControls[i].limiteValue = self.cupControls[i].limiteMultiple * _bet;
    end
    self:_renewControl(self.curControls[self.curStep], 0, 0.4);
end

--显示点球结果
function _CBalanceUI:ShowBallResult(_ret, _value)
    --error("显示点球结果")
    local GoalType = GameDefine.EnumGoalType();
    self.isDisplay = true;
    if _ret == GoalType.EM_GoalValue_Null then
        self.totalTime = 2.3;
        self.isOver = false;
        self.runTime = 0;
        self:_clear();
        self.curAnimate = self.loseAnimate;
        self.curObj = self.loseAnimateObj;
        self.curObj:SetActive(true);
        self.musicHanlder = G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().Lose);
        self.curObj.transform.localScale = Vector3.zero;
        --解决开始会闪一下的问题
        coroutine.start(
                function()
                    coroutine.wait(0.05);
                    self.curObj.transform.localScale = Vector3.one;
                end
        );
    elseif _ret == GoalType.EM_GoalValue_Gold then
        self.totalTime = 4.4;
        self.runTime = 0;
        self.numberBeginValue = 0;
        self.numSpeed = 0;
        self.numberRunTime = 0;
        self.isOver = false;
        self:_countSpeed(tonumber(_value), 3, 2.2, 1);
        self.curStep = 1;
        self.curControls = self.ballControls;
        local count = #self.ballControls;
        --        for i=1,count do
        --            self.ballControls[i].limiteValue = self.ballControls[i].limiteMultiple*_bet;
        --        end
        self:_renewControl(self.curControls[self.curStep], 0, 0.1, true);
    elseif _ret == GoalType.EM_GoalValue_Multiple then
        self.totalTime = 4.4;
        self.isOver = false;
        self.runTime = 0;
        self:_clear();
        self.curAnimate = self.multipleAnimate;
        self.curObj = self.multipleAnimateObj;
        self.curObj:SetActive(true);
        self.musicHanlder = G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().BallBalance);
        self.curObj.transform.localScale = Vector3.zero;
        --解决开始会闪一下的问题
        coroutine.start(
                function()
                    coroutine.wait(0.05);
                    self.curObj.transform.localScale = Vector3.one;
                end
        );
    end
end

function _CBalanceUI:ShowFreeTotal(_freeCount, _freeTotal)
    self:_clear();
    self.isDisplay = true;
    self.totalTime = 3;
    self.isOver = false;
    self.isAddNumber = false;
    self.runTime = 0;
    self.curAnimate = self.freeTransform;
    self.curObj = self.freeTransformObj;
    self.curObj:SetActive(true);
    self.freeNumber:SetNumString(tostring(_freeCount));
    self.freeValueNumber:SetNumString("g " .. ShortNumber(_freeTotal));
    G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().FreeBalance);
end

function _CBalanceUI:ReduceNumber(number)
    self.lastNumber = self.lastNumber - number;
    if self.lastNumber < 0 then
        self.lastNumber = 0;
    end
    local control = self.curControls[self.curStep];
    if control.number then
        control.number:SetNumber(self.lastNumber);
    end
end

function _CBalanceUI:_countSpeed(_value, _speed, _t1, _t2)
    if not _value then
        return ;
    end
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
    self.numberStep = 1;
    self.isAddNumber = true;
end


--进入点球大战
function _CBalanceUI:EnterBallGame()
    self:_clear();
    self.totalTime = 5;
    self.runTime = 0;
    self.curAnimate = self.enterBallAnimate;
    self.curObj = self.enterBallAnimateObj;
    --self.curAnimate:Play();
    self.waitTime = 0;
    self.curObj:SetActive(true);
    self.isDisplay = true;
    self.isOver = false;
    self.isAddNumber = false;
end

--清理
function _CBalanceUI:Clear()
    self.isDisplay = false;
    self:_clear();
    self.isAddNumber = false;
end

function _CBalanceUI:_clear()
    if self.curControl then
        local objects = self.curControl.displayObjs;
        if objects ~= nil and #objects > 0 then
            for i = 1, #objects do
                objects[i]:SetActive(false);
            end
        end
        objects = self.curControl.hideObjs;
        if objects ~= nil and #objects > 0 then
            for i = 1, #objects do
                objects[i]:SetActive(true);
            end
        end
        local components = self.curControl.enabledComponents;
        if components ~= nil and #components > 0 then
            for i = 1, #components do
                components[i].enabled = false;
            end
        end
        components = self.curControl.disabledComponents;
        if components ~= nil and #components > 0 then
            for i = 1, #components do
                components[i].enabled = true;
            end
        end
        self.curControl = nil;
    end

    if self.curAnimate then
        --self.curAnimate.enabled=false;
        --self.curAnimate:StopPlayback();
        --self.curAnimate:StartPlayback();
        self.curObj:SetActive(false);
        self.curAnimate = nil;
    end
    if self.musicHanlder then
        G_GlobalGame._soundCtrl:StopSound(self.musicHanlder);
        self.musicHanlder = nil;
    end
end




--===========================数值控制===============================================--
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
    --local number1 =  math.ceil(number*2/3);
    --local leftNumber = number - number1 + 1;
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
--===========================数值控制===============================================--
--function _CBalanceUI:
local _CUILayer = class("_CUILayer");

function _CUILayer.Create(_parent)
    local layer = _CUILayer.New();
    if layer:Init(_parent) then
        return layer;
    end
    return nil;
end

function _CUILayer:ctor()
    self.transform = nil;
    self.gameObject = nil;
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
        local obj = G_GlobalGame._goFactory:createUIPart();
        self.transform = obj.transform;
        self.gameObject = obj.gameObject;
        self.transform:SetParent(_parent);
        self.transform.localPosition = C_Vector3_Zero;
        self.transform.localScale = C_Vector3_One;

        local bg = obj.transform:Find("BG");
        bg:GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);

    else
        self.transform = transform;
        self.gameObject = transform.gameObject;
    end

    local go = newObject(self.transform:Find("MiniGame/BG").gameObject)
    go.transform:SetParent(self.transform:Find("MiniGame"));
    go.transform:SetSiblingIndex(0);
    go.transform.localPosition = Vector3(0, 0, 0);
    go.transform.localScale = Vector3(1, 1, 1);
    go:GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750);
    self.transform:Find("MiniGame/Mask"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);

    --初始化小游戏
    self.minigame:Init(self.transform:Find("MiniGame"));

    --内容panel
    self.contentPanel = self.transform:Find("ContentPanel");

    --结算
    self.balanceTransform = self.transform:Find("Balance");


    --前面
    self.balanceFront = self.balanceTransform:Find("Front");
    --后面
    self.balanceBack = self.balanceTransform:Find("Back");
    local balanceObj = G_GlobalGame._goFactory:createBalance();
    local balance = balanceObj.transform;
    balance:SetParent(self.balanceBack);
    balance.localScale = Vector3.one;
    balance.localPosition = Vector3.zero;
    balance.localRotation = Quaternion.Euler(0, 0, 0);
    local balanceFront = G_GlobalGame._goFactory:createBalanceFront();
    local balanceFrontTrans = balanceFront.transform;
    balanceFrontTrans:SetParent(self.balanceFront);
    balanceFrontTrans.localScale = Vector3.one;
    balanceFrontTrans.localPosition = Vector3.zero;
    balanceFrontTrans.localRotation = Quaternion.Euler(0, 0, 0);

    self.balanceBack:Find("Balance/megawin"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
    self.balanceBack:Find("Balance/bigwin"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
    self.balanceBack:Find("Balance/nomal1"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
    self.balanceBack:Find("Balance/nomal2"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
    self.balanceBack:Find("Balance/lose"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
    self.balanceBack:Find("Balance/game"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);

    --初始化结算
    self.balanceUI:Init(balance, balanceFrontTrans);

    --闪光
    self.leftShanGuangAnimate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self.contentPanel:Find("LeftShanGuan").gameObject, CAnimateDefine.Enum_AnimateStyle.ShanGuang);
    self.rightShanGuangAnimate = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self.contentPanel:Find("RightShanGuan").gameObject, CAnimateDefine.Enum_AnimateStyle.ShanGuang);
    self.shanGuangTime = math.random(40, 70) / 10;
    self.leftShanGuangAnimate:SetEndHandler(function()
        self.leftShanGuangAnimate:Hide();
        self.rightShanGuangAnimate:Hide();
    end);

    self.stars = {
        transform = nil,
        arrs = {

        },
        Init = function(self, transform)
            self.transform = transform;
            local childCount = transform.childCount;
            local ctransform;
            self.gameObject = transform.gameObject;
            self.gameObject:SetActive(true);

            for i = 1, childCount do
                local t = { stars = {}, transform = nil };
                self.arrs[i] = t
                ctransform = transform:GetChild(i - 1);
                t.transform = ctransform;
                t.gameObject = ctransform.gameObject;
                t.gameObject:SetActive(false);
                local cTCount = ctransform.childCount;
                local stars = t.stars;
                for j = 1, cTCount do
                    stars[j] = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(ctransform:GetChild(j - 1).gameObject, CAnimateDefine.Enum_AnimateStyle.Star);
                    if j == 1 then
                        stars[j]:SetEndHandler(
                                function()
                                    if (t.shanCount > 0) then
                                        t.shanCount = t.shanCount - 1;
                                        for k = 1, cTCount do
                                            stars[k]:Play();
                                        end
                                    else
                                        t.gameObject:SetActive(false);
                                    end
                                end
                        );
                    end
                end
            end

            self.arrs[1].interval = 1.95;
            self.arrs[1].ran1 = 8;
            self.arrs[1].ran2 = 1;
            self.arrs[1].runTime = self.arrs[1].interval;
            self.arrs[1].shanCount = 0;
            self.arrs[2].interval = 2.35;
            self.arrs[2].ran1 = 2;
            self.arrs[2].ran2 = 4;
            self.arrs[2].runTime = self.arrs[2].interval;
            self.arrs[2].shanCount = 0;
            self.arrs[3].interval = 2.9;
            self.arrs[3].ran1 = 3;
            self.arrs[3].ran2 = 3;
            self.arrs[3].runTime = self.arrs[3].interval;
            self.arrs[3].shanCount = 0;
            self.arrs[4].interval = 3.7;
            self.arrs[4].ran1 = 5;
            self.arrs[4].ran2 = 1;
            self.arrs[4].runTime = 0;
            self.arrs[4].shanCount = self.arrs[4].interval;
        end,
        Update = function(self, dt)
            local tcount = #self.arrs;
            local arr
            local ran
            for i = 1, tcount do
                arr = self.arrs[i];
                arr.runTime = arr.runTime - dt;
                if arr.runTime <= 0 then
                    ran = math.random(1, arr.ran1 + arr.ran2);
                    if (ran > arr.ran1) then
                        arr.shanCount = 1;
                    else
                        arr.shanCount = 0;
                    end
                    arr.gameObject:SetActive(true);
                    arr.runTime = arr.interval;
                    local stars = arr.stars;
                    local co = #stars;
                    for j = 1, co do
                        stars[j]:Play();
                    end
                end

            end
        end,
    };

    --初始化 shanguang
    self.stars:Init(self.contentPanel:Find("Stars"));

    --缓存池
    self.cachePool = self.transform:Find("CachePool");
    _v_ui_cachePool = self.cachePool;

    local buttonPanel = self.transform:Find("ButtonPanel");
    self.addBtn = self.contentPanel:Find("Add");
    self.disabledAdd = self.addBtn:Find("Disabled").gameObject;
    self.reduceBtn = self.contentPanel:Find("Reduce");
    self.disabledReduce = self.reduceBtn:Find("Disabled").gameObject;
    self.startBtn = self.contentPanel:Find("Start");
    self.isDisplayBtn = false;

    local eventTrigger = Util.AddComponent("EventTriggerListener", self.addBtn.gameObject);
    eventTrigger.onClick = handler(self, self._onAddBet);
    eventTrigger = Util.AddComponent("EventTriggerListener", self.reduceBtn.gameObject);
    eventTrigger.onClick = handler(self, self._onRemoveBet);
    eventTrigger = Util.AddComponent("EventTriggerListener", self.startBtn.gameObject);
    --eventTrigger.onClick = handler(self,self._onStartClick);
    eventTrigger.onDown = handler(self, self._onPressStart);
    eventTrigger.onUp = handler(self, self._onReleaseStart);

    local testBtn = self.contentPanel:Find("TestBtn");
    testBtn.gameObject:GetComponent("Image").raycastTarget = false;
    eventTrigger = Util.AddComponent("EventTriggerListener", testBtn.gameObject);
    eventTrigger.onClick = handler(self, self._onTestBtnClick);

    --长按事件
    self.longKeyPress = LongPressControl.New();

    --滚动列
    self.scrollColumnControl:Init(self.contentPanel:Find("ScrollPanel"));

    --初始化图标格子
    self:_initIconCells();

    --初始化数字
    self:_initNumbers();

    self.oneBet = self.contentPanel:Find("OneBet"):GetComponent("Text");
    self.oneBet.text = "";

    --总下注
    local totalBet = self.contentPanel:Find("TotalBet");
    self.totalBetNum = CAtlasNumber.CreateWithGroupName(_numGold, -2);
    self.totalBetNum:SetParent(totalBet);
    self.totalBetNum:SetLocalScale(C_Vector3_One);

    --我的金币
    local myGold = self.contentPanel:Find("MyGold");
    self.myGoldNum = CAtlasNumber.CreateWithGroupName(_numGold, -2);
    self.myGoldNum:SetParent(myGold);
    self.myGoldNum:SetLocalScale(C_Vector3_One);

    --获得金币
    local getGold = self.contentPanel:Find("GetGold");
    self.getGoldNum = CAtlasNumber.CreateWithGroupName(_numGold, -2);
    self.getGoldNum:SetParent(getGold);
    self.getGoldNum:SetLocalScale(C_Vector3_One);

    --添加事件
    self:_addEvent();

    --开始按钮状态控制
    self.startStatus = {
        transform = nil,
        startStatus = {},
        autoStatus = {},
        freeStatus = {},
        status = 0,
        isInRun = false,
        --初始化
        Init = function(self, transform)
            self.transform = transform;
            self.startStatus.transform = transform:Find("Start");
            self.startStatus.gameObject = self.startStatus.transform.gameObject;
            self.startStatus.gameObject:SetActive(false);
            self.diableObj = transform:Find("Disabled").gameObject;
            self.diableObj:SetActive(false);
            self.autoStatus.transform = transform:Find("Auto");
            self.autoStatus.gameObject = self.autoStatus.transform.gameObject;
            self.autoStatus.gameObject:SetActive(false);
            self.autoStatus.count = 0;
            self.autoStatus.neverObj = self.autoStatus.transform:Find("Never").gameObject;
            local number = self.autoStatus.transform:Find("Number");
            self.autoStatus.atlasNumber = CAtlasNumber.CreateWithGroupName(_numGold, -2, HorizontalAlignType.Mid);
            self.autoStatus.atlasNumber:SetParent(number);
            self.autoStatus.atlasNumber:SetLocalScale(C_Vector3_One);

            self.freeStatus.transform = transform:Find("Free");
            self.freeStatus.gameObject = self.freeStatus.transform.gameObject;
            self.freeStatus.gameObject:SetActive(false);
            self.freeStatus.count = 0;
            self.freeStatus.text = self.freeStatus.transform:Find("Count"):GetComponent("Text");
            self.freeStatus.text.text = "0";
            self.status = Enum_StartStatus.Normal;
            self:InitStatus();
        end,
        --每帧更新
        Update = function(self, _dt)

        end,
        --减少游戏次数
        ReduceGameCount = function(self)
            self.isInRun = true;
            if self.status == Enum_StartStatus.Normal then
                self.diableObj:SetActive(true);
            elseif self.status == Enum_StartStatus.Auto then
                if self.autoStatus.count > 0 then
                    self.autoStatus.count = self.autoStatus.count - 1;
                    self.autoStatus.atlasNumber:SetNumString(tostring(self.autoStatus.count));
                elseif self.autoStatus.count == -1 then

                end
            elseif self.status == Enum_StartStatus.Free then
                self.freeStatus.count = self.freeStatus.count - 1;
                self.freeStatus.text.text = "left" .. tostring(self.freeStatus.count);    --免费
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
            self.freeStatus.count = self.freeStatus.count + count;
            if self.freeStatus.count > 0 then
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
            if self.status == Enum_StartStatus.Normal then
                self.startStatus.gameObject:SetActive(true);
                self.autoStatus.gameObject:SetActive(false);
                self.freeStatus.gameObject:SetActive(false);
            elseif self.status == Enum_StartStatus.Auto then
                self.diableObj:SetActive(false);
                self.startStatus.gameObject:SetActive(false);
                self.autoStatus.gameObject:SetActive(true);
                self.freeStatus.gameObject:SetActive(false);

                if self.autoStatus.count == -1 then
                    self.autoStatus.atlasNumber:Hide();
                    self.autoStatus.neverObj:SetActive(true);
                else
                    self.autoStatus.atlasNumber:Show();
                    self.autoStatus.atlasNumber:SetNumString(tostring(self.autoStatus.count));
                    self.autoStatus.neverObj:SetActive(false);
                end

            elseif self.status == Enum_StartStatus.Free then
                self.diableObj:SetActive(true);
                self.startStatus.gameObject:SetActive(false);
                self.autoStatus.gameObject:SetActive(false);
                self.freeStatus.gameObject:SetActive(true);
                self.freeStatus.text.text = "left" .. tostring(self.freeStatus.count);
            end
        end,
        --改变状态
        ChangeStatus = function(self)
            self.isInRun = false;
            if self.status == Enum_StartStatus.Normal then
                self.diableObj:SetActive(false);
            elseif self.status == Enum_StartStatus.Auto then
                --看看这里是否又次数限制等
                if self.autoStatus.count == -1 then
                elseif self.autoStatus.count == 0 then
                    self.startStatus.gameObject:SetActive(true);
                    self.autoStatus.gameObject:SetActive(false);
                    self.freeStatus.gameObject:SetActive(false);
                    self.status = Enum_StartStatus.Normal;
                end
            elseif self.status == Enum_StartStatus.Free then
                if self.freeStatus.count <= 0 then
                    self.diableObj:SetActive(false);
                    if self.autoStatus.count > 0 then
                        self.status = Enum_StartStatus.Auto;
                        self.startStatus.gameObject:SetActive(false);
                        self.autoStatus.gameObject:SetActive(true);
                        self.freeStatus.gameObject:SetActive(false);
                    elseif self.autoStatus.count == -1 then
                        self.status = Enum_StartStatus.Auto;
                        self.startStatus.gameObject:SetActive(false);
                        self.autoStatus.gameObject:SetActive(true);
                        self.freeStatus.gameObject:SetActive(false);
                    else
                        self.startStatus.gameObject:SetActive(true);
                        self.autoStatus.gameObject:SetActive(false);
                        self.freeStatus.gameObject:SetActive(false);
                        self.status = Enum_StartStatus.Normal;
                    end
                end
            end
        end,
        --状态
        Status = function(self)
            return self.status;
        end,
    };

    --初始化状态按钮
    self.startStatus:Init(self.startBtn);

    self.runMode = Enum_RunMode.HandMode;
    self.runContent = Enum_RunContent.Normal;
    self.runState = Enum_RunState.Null;
    --是否可以开始游戏
    self.isCanStart = false;

    --试试
    --self:_onAutoStart(-1);
    --免费游戏
    --self:_onFreeGameStart(40);
    --开始小游戏
    --self.minigame:Start();
    --UI界面的我的金币
    self.uiGold = 0;
    self.uiGetGold = 0;

    --自动转动配置
    self.autoConfigs = {
        10, 50, 100, -1
    };

    --自动控制
    self.autoPopControl = {
        transform = nil,
        gameObject = nil,
        btn = nil,
        btns = {},
        eventHandler = handler,
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
                local eventTrigger = Util.AddComponent("EventTriggerListener", self.btnBg.gameObject);
                eventTrigger.onClick = handler(self, self._onClick);
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
                    self.atlasNumber = CAtlasNumber.CreateWithGroupName(_numGold, -2, HorizontalAlignType.Mid);
                    self.atlasNumber:SetParent(self.number);
                    self.atlasNumber:SetLocalScale(C_Vector3_One);
                    self.atlasNumber:IsReciveTouch(false);
                end
                self.atlasNumber:SetNumString(tostring(number));
            end

            function CBtn:_onClick()
                self.clickHandler(self.value);
            end

            self.transform = transform;
            self.gameObject = transform.gameObject;
            local mask = transform:Find("Mask");
            local eventTrigger = Util.AddComponent("EventTriggerListener", mask.gameObject);
            eventTrigger.onClick = handler(self, self._onClickMask);
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
            local y = 128;
            for i = 1, configCount do
                btn = self.btns[i];
                btn.transform.localPosition = Vector3.New(0, y, 0);
                y = y + 82;
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
    self.autoPopControl:Init(self.contentPanel:Find("PopMenu"), self.autoConfigs, handler(self, self._onChooseAutoTimes));

    local topContent = self.contentPanel:Find("TopContent");
    local topScroll = topContent:Find("RectMask/Scroll");
    local caijin = topScroll:Find("CaiJin");
    self.caijinObj = caijin.gameObject;
    --彩金
    caijin = caijin:Find("CaiJin");
    self.caijinNum = CAtlasNumber.CreateWithGroupName(_numSilver, -2, HorizontalAlignType.Mid);
    self.caijinNum:SetParent(caijin);
    self.caijinNum:SetLocalScale(C_Vector3_One);
    self.caijinNum:SetSpace(6);

    local multiple = topScroll:Find("Multiple");
    self.multipleObj = multiple.gameObject;
    self.multipleObj:SetActive(true);
    --彩金
    multiple = multiple:Find("Multiple");
    self.multipleNum = CAtlasNumber.CreateWithGroupName(_numSilver, -2, HorizontalAlignType.Mid);
    self.multipleNum:SetParent(multiple);
    self.multipleNum:SetLocalScale(C_Vector3_One);

    --顶部显示控制
    self.displayTopControl = {
        transforms = {},
        stopIndex = 1,
        runTime = 0,
        curPos = Vector3.zero,
        disY = 48,
        scrollTrans = nil,
        curY = 0,
        moveToY = 0,
        displayIndex = 1,
        countIndex = 1,
        isAutoScroll = false,
        step = 0,
        Init = function(self, scroll, caijinTransform, multipleTransform)
            self.transforms[1] = caijinTransform;
            self.transforms[2] = multipleTransform;
            self.scrollTrans = scroll;
        end,
        --切换
        Switch = function(self)
            if self.step == 2 then
                return false;
            end
            if self.step == 0 then
                self.moveToY = self.moveToY + self.disY;
                self.step = 2;
                self.runTime = 0;
                self:_arrangeNextPos();
                return true;
            end
            if self.step == 1 then
                if self.moveToY > self.curY then
                else
                    self.moveToY = self.moveToY + self.disY;
                end
                self.step = 2;
                self.runTime = 0;
                self:_arrangeNextPos();
                return true;
            end
            return false;
        end,
        --自动切换
        AutoSwitch = function(self)
            self.isAutoScroll = true;
            if self.step == 0 then
                self.step = 1;
                self.runTime = 0;
            end
        end,
        --停止切换
        StopSwitch = function(self, index)
            self.isAutoScroll = false;
            if index ~= nil then
                local totalCount = #self.transforms;
                if index <= 0 or index > totalCount then
                    return ;
                end
                if self.displayIndex == index then
                    return ;
                else
                    local count = (index - self.displayIndex + totalCount) % totalCount;
                    self.moveToY = count * self.disY + self.moveToY;
                end
            end
        end,
        --直接显示哪一个
        DisplayIndex = function(self, index)
            local totalCount = #self.transforms;
            if index <= 0 or index > totalCount then
                return ;
            end
            self.curPos = Vector3.zero;
            self.scrollTrans.localPosition = self.curPos;
            self.moveToY = 0;
            self.displayIndex = index;

            local cIndex;
            local transform;
            for i = 2, totalCount do
                cIndex = (i + totalCount + index) % totalCount + 1;
                transform = self.transforms[cIndex];
                transform.localPosition = VECTOR3NEW(0, -self.disY, 0);
            end
            transform = self.transforms[index];
            transform.localPosition = self.curPos;
        end,
        _arrangeNextPos = function(self)
            local y = -(self.curY + self.disY);
            local totalCount = #self.transforms;
            if self.displayIndex >= totalCount then
                self.displayIndex = 1;
            else
                self.displayIndex = self.displayIndex + 1;
            end
            local transform = self.transforms[self.displayIndex];
            transform.localPosition = VECTOR3NEW(0, y, 0);
        end,
        Update = function(self, _dt)
            if self.step == 0 then
                return ;
            end
            if self.step == 1 then
                self.runTime = self.runTime + _dt;
                if self.runTime >= 5 then
                    if self.curY < self.moveToY then
                        self.step = 2;
                        self.runTime = 0;
                        self:_arrangeNextPos();
                    elseif self.isAutoScroll then
                        self.moveToY = self.moveToY + self.disY;
                        self.step = 2;
                        self.runTime = 0;
                        self:_arrangeNextPos();
                    else
                        self.step = 0;
                    end
                end
            elseif self.step == 2 then
                self.runTime = self.runTime + _dt;
                self.curPos.y = self.curY + self.runTime * 130;
                if self.curPos.y >= self.curY + self.disY then
                    self.curY = self.curY + self.disY;
                    self.curPos.y = self.curY;
                    self.step = 1;
                    self.runTime = 0;
                end
                self.scrollTrans.localPosition = self.curPos;
            end
        end,
    };
    self.displayTopControl:Init(topScroll, self.caijinObj.transform, self.multipleObj.transform);
    self.displayTopControl:DisplayIndex(1);
    --self.displayTopControl:AutoSwitch();
    --self:DisplayCaijin();
    return true;
end

--初始化iconCells
function _CUILayer:_initIconCells()
    local XCount = GameDefine.XCount();
    local YCount = GameDefine.YCount();
    for i = 1, YCount do
        self.iconCells[i] = {};
        for j = 1, XCount do
            self.iconCells[i][j] = _CIconCell.New();
        end
    end
end

function _CUILayer:_initNumbers()
    --游戏积分sprites
    local gameScoreSprites = G_GlobalGame:GetSpritePlist(G_GlobalGame.Enum_Sprite_Tag.NumGold) or
            {};
    CAtlasNumber.ImportSprites(_numGold, gameScoreSprites);

    --导入获得分数1
    gameScoreSprites = G_GlobalGame:GetSpritePlist(G_GlobalGame.Enum_Sprite_Tag.NumGold1) or
            {};
    CAtlasNumber.ImportSprites(_numGold1, gameScoreSprites);

    --导入获得分数2
    gameScoreSprites = G_GlobalGame:GetSpritePlist(G_GlobalGame.Enum_Sprite_Tag.NumSilver) or
            {};
    CAtlasNumber.ImportSprites(_numSilver, gameScoreSprites);

    --导入获得分数3
    gameScoreSprites = G_GlobalGame:GetSpritePlist(G_GlobalGame.Enum_Sprite_Tag.NumSilver1) or
            {};
    CAtlasNumber.ImportSprites(_numSilver1, gameScoreSprites);

    --导入获得分数4
    gameScoreSprites = G_GlobalGame:GetSpritePlist(G_GlobalGame.Enum_Sprite_Tag.NumContinue) or
            {};
    CAtlasNumber.ImportSprites(_numContinue, gameScoreSprites);

end

--添加事件
function _CUILayer:_addEvent()
    G_GlobalGame:RegEventByStringKey("GameConfig", self, self.OnGameConfig);
    G_GlobalGame:RegEventByStringKey("NotifyEnterGame", self, self.OnEnterGame);
    G_GlobalGame:RegEventByStringKey("NotifyUIStartGameCB", self, self.OnStartGameCB);
    G_GlobalGame:RegEventByStringKey("NotifyUIBallGameCB", self, self.OnStartBallGameCB);
    G_GlobalGame:RegEventByStringKey("NotifyUICaijin", self, self.OnUpdateCaijin);
    G_GlobalGame:RegEventByStringKey("NotifyUIGameDataCB", self, self.OnGameData);
end

function _CUILayer:_onAddBet()
    if not self.isDisplayBtn then
        return ;
    end
    local bet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetBet);
    bet = GameDefine.GetNextBet(bet);
    G_GlobalGame:DispatchEventByStringKey("ChangeBet", bet);
    self:_onChangeBet(bet);
    G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().Bet);
    self:_onUpdateCaijin();
end

function _CUILayer:_onRemoveBet()
    if not self.isDisplayBtn then
        return ;
    end
    local bet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetBet);
    bet = GameDefine.GetPreBet(bet);
    G_GlobalGame:DispatchEventByStringKey("ChangeBet", bet);
    self:_onChangeBet(bet);
    G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().Bet);
    self:_onUpdateCaijin();
end

function _CUILayer:_onTestBtnClick()
    --    coroutine.start(function()
    --        coroutine.wait(0.8);
    --        local GoalType = GameDefine.EnumGoalType();
    --        --点击测试按钮
    --        self.balanceUI:ShowBallResult(GoalType.EM_GoalValue_Gold,1000);
    --        coroutine.wait(4);
    --        self.balanceUI:Clear();
    --    end)
    --G_GlobalGame:openLog();
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
        self.longKeyPress:Start(1,
                0.8,
                0.2,
                handler(self, self._onLongPressStart),
                handler(self, self._onShortPressStart));
    elseif status == Enum_StartStatus.Auto then
        self:_onNormalStart();
    elseif status == Enum_StartStatus.Free then
    end
end

function _CUILayer:_onReleaseStart()
    self.longKeyPress:Stop(1);
end

--长按
function _CUILayer:_onLongPressStart()
    self.autoPopControl:Show();
    self.longKeyPress:Stop(1);
    --self:_onAutoStart(-1);
end

--短按
function _CUILayer:_onShortPressStart()
    G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().Start);
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
        --        local it = EnumIconType;
        --        local _data = {
        --            [1] = {it.EM_IconValue_Shose,it.EM_IconValue_Card,it.EM_IconValue_Card,it.EM_IconValue_Card,it.EM_IconValue_Card},
        --            [2] = {it.EM_IconValue_Card,it.EM_IconValue_Card,it.EM_IconValue_Card,it.EM_IconValue_Card,it.EM_IconValue_Card},
        --            [3] = {it.EM_IconValue_Vanguard,it.EM_IconValue_Card,it.EM_IconValue_Card,it.EM_IconValue_Card,it.EM_IconValue_Card},
        --            [4] = {it.EM_IconValue_Shose,it.EM_IconValue_Card,it.EM_IconValue_Card,it.EM_IconValue_Card,it.EM_IconValue_Card},
        --        };
        --        self.scrollColumnControl:ResultData(_data);
        --        self.scrollColumnControl:Stop();
        --        self.runState = Enum_RunState.Null;
        self.scrollColumnControl:IsContinue();
        return false;
    end
    if not KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetCanStartGame) then
        --        local _freeCount = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetFreeCount);
        --        if _freeCount
        FramePopoutCompent.Show("Not enough gold");
        self.startStatus:NormalStart();
        self.runMode = Enum_RunMode.HandMode;
        self:EnabledChangeBet();
        return false;
    end
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
        --error("是否为免费游戏")
        self:_reduceBet();
        self.isClearGetGold = true;
    else
        self.isClearGetGold = false;
    end

    if self.status ~= Enum_StartStatus.Free then

    end
    --更新我的金币
    self:_onUpdateGold();
    --
    self:DisabledChangeBet();
end

function _CUILayer:_reduceBet()
    --error("下注值减少")
    local gold = tonumber(KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetUserGold));
    local bet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetBet);
    local maxLine = GameDefine.MaxLine();
    local needGold = tonumber(bet * maxLine);
    if gold < needGold then
        return false;
    end
    --减注
    local num1 = tonumber(gold - needGold)
    self:_onChangeMyGold(num1);
    return true;
end

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
                        logYellow("手动模式")
                        --开始游戏
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
        --self.runState=Enum_RunState.Null
        isInitOver = false
    end
end

--控制星星
function _CUILayer:_controlStars(_dt)
    self.stars:Update(_dt);
end

--游戏配置
function _CUILayer:OnGameConfig()
    --self._guaji.gameObject:SetActive(G_GlobalGame.GameConfig.SceneConfig.isAutoShot);
end

--进入游戏
function _CUILayer:OnEnterGame()
    logYellow("进入游戏")
    --修改跑马灯位置
    GameSetsBtnInfo.SetPlaySuonaPos(-6, 305, 0);
    --可以开始游戏了
    self.isCanStart = true;
    --更新金币
    self:_onUpdateGold();
    --更新下注值
    self:_onUpdateBet();
    --更新彩金
    self:_onUpdateCaijin();
    --更新获得金币
    self:_onUpdateGetGold();
    --改变状态
    self:_onChangeState();
    --控制顶部内容
    self:_controlTopContent();
    --播放一次看看
    --self.balanceUI:ShowResult(30000000000,60000000);
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
        self.displayTopControl:AutoSwitch();
    elseif state == Enum_GameState.EM_GameState_BallGame then
        self:DisabledChangeBet();
        self.minigame:Start();
        self.runState = Enum_RunState.OtherGame;
        self:_switchGameRunning(Enum_RunStep.BallGame);
    end
    if state == Enum_GameState.EM_GameState_FreeGame or state == Enum_GameState.EM_GameState_BallGame then
        G_GlobalGame._soundCtrl:PlayBgSound(SoundDefine.EnumSound().FreeBG);
        if state == Enum_GameState.EM_GameState_BallGame then
            G_GlobalGame._soundCtrl:MuteBgSound();
        end
    else
        G_GlobalGame._soundCtrl:PlayBgSound(SoundDefine.EnumSound().BG);
    end
    --更新免费次数
    self:_onUpdateFreeCount();
    self:_controlRunMode();
end

function _CUILayer:_onChangeMyGold(_gold)
    self.uiGold = _gold;
    self.myGoldNum:SetNumber(_gold);
    --    if _gold>=100000000 then
    --        local mill = math.floor(_gold /1000000)%100;
    --        local yi   = math.floor(_gold /100000000);
    --        if mill==0 then
    --            local str = string.format("%dy",yi);
    --            self.myGoldNum:SetNumString(str);
    --        else
    --            local str = string.format("%d.%dy",yi,mill);
    --            self.myGoldNum:SetNumString(str);            
    --        end
    --    elseif _gold>1000000 then
    --        local mill = math.floor(_gold /100)%100;
    --        local yi   = math.floor(_gold /10000);
    --        if mill==0 then
    --            local str = string.format("%dw",yi);
    --            self.myGoldNum:SetNumString(str);
    --        else
    --            local str = string.format("%d.%dw",yi,mill);
    --            self.myGoldNum:SetNumString(str);            
    --        end
    --    else
    --        self.myGoldNum:SetNumber(_gold);
    --        --self.myGoldNum:SetNumString();
    --    end
    --    --self.myGoldNum:SetNumString();
end

function _CUILayer:_onUpdateGold()
    local gold = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetUserGold);
    logYellow("更新我的金币")
    G_GlobalGame._clientSession.isreqStart = true;
    self:_onChangeMyGold(gold);
end

function _CUILayer:_onChangeBet(_bet)
    local maxLine = GameDefine.MaxLine();
    self.totalBetNum:SetNumber(_bet * maxLine);
    --self.oneBet.text = tostring(maxLine) .. "line X " .. _bet;
end

function _CUILayer:_onUpdateBet()
    local bet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetBet);
    self:_onChangeBet(bet);
end

function _CUILayer:_onChangeCaijin(_caijin)
    self.caijinNum:SetNumString("j " .. ShortNumber(_caijin));
end

function _CUILayer:_onUpdateCaijin()
    --error("G_GlobalGame.Enum_KeyValue.GetGameRet"..G_GlobalGame.Enum_KeyValue.GetCaijin)
    local caijin = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetCaijin);
    --local caijin = KeyEvent.GetKeyValue(12);
    self:_onChangeCaijin(tonumber(caijin));
end

function _CUILayer:_onChangeGetGold(_gold)
    self.uiGetGold = _gold;
    self.getGoldNum:SetNumber(_gold);
end

--_bet==下注值  _getGold 获得金币  
function _CUILayer:_onUpdateGetGold()
    local _bet, _getGold = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    self:_onChangeGetGold(_getGold);
end
--_bet==下注值  _getGold 获得金币  _comGold 
function _CUILayer:_onUpdateComGold()
    local _bet, _getGold, _comGold = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    self:_onChangeGetGold(_comGold);
end

function _CUILayer:_onChangeFreeCount(_freeCount)
    self.startStatus:SetFreeGameCount(_freeCount);
end

function _CUILayer:_onUpdateFreeCount()
    local _freeCount = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetFreeCount);
    self:_onChangeFreeCount(_freeCount);
end

function _CUILayer:OnGameData(_eventID, _eventData)
    --self.isCanStart = true;
    logYellow("游戏数据读取完毕")
    isInitOver = true
end

--开始游戏数据返回
function _CUILayer:OnStartGameCB(_eventID, _eventData)
    error("开始游戏数据返回")
    self.scrollColumnControl:ResultData(_eventData);
    --刷新彩金
    self:_onUpdateCaijin();
end

--点球数据返回
function _CUILayer:OnStartBallGameCB(_eventID, ret)
    --直接反馈是否有中奖
    self.minigame:OnBallDataCB(ret);
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

function _CUILayer:_onScrollColumns()
    --执行步骤
    self:_switchGameRunning(Enum_RunStep.Scroll);
    local xCount = GameDefine.XCount();
    local yCount = GameDefine.YCount();
    for i = 1, xCount do
        for j = 1, yCount do
            self.iconCells[j][i]:Normal();
            self.iconCells[j][i]:ReleationNode(nil);
        end
    end
    self.scrollColumnControl:Scroll();
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
    self.runTime = 0;
end

function _CUILayer:_checkResult()
    local _bet, _getGold, _comGold, _ret = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    --关联节点
    local xCount = GameDefine.XCount();
    local yCount = GameDefine.YCount();
    local isAction = false;
    local lineCount = #_ret.lines;
    local lines = GameDefine.GetLines();
    local step = 0;
    if self.runStep == Enum_RunStep.WFlashIcon then
        if lineCount > 0 then
            self:_switchGameRunning(Enum_RunStep.FlashIcon);
            self:_onIconAnimate();
        else
            self:_switchGameRunning(Enum_RunStep.WSuperCup);
            self:_checkResult();
        end
    elseif self.runStep == Enum_RunStep.WSuperCup then
        if _ret.isCup then
            self.cupMusicHandler = G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().FlashCup);
            self:_switchGameRunning(Enum_RunStep.SuperCup);
            self:_onIconAnimate();
        else
            --            self.runStep = Enum_RunStep.WFreeGame;
            --            self:_checkResult(); 
            --检测获得金币
            self:_checkGetGold();
        end
    elseif self.runStep == Enum_RunStep.WFreeGame then
        if _ret.isFreeGame then
            self:_switchGameRunning(Enum_RunStep.FreeGame);
            self.freeGameMusicHandler = G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().FlashFree);
            self:_onIconAnimate();
            --这时候背景音乐就要关闭掉了
            G_GlobalGame._soundCtrl:MuteBgSound();
        else
            --没有任何中奖
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
    self:_switchGameRunning(Enum_RunStep.WFreeGame);
    self:_checkResult();
    --    end 
end

function _CUILayer:_onGetGold()
    local _bet, _getGold, _comGold, _ret = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    if _getGold > 0 then
        local time = 0;
        if _getGold <= 10 then
            time = 0.5;
        elseif _getGold <= 50 then
            time = 0.8;
        elseif _getGold <= 80 then
            time = 1.2;
        elseif _getGold <= 150 then
            time = 1.5;
        elseif _getGold <= 500 then
            time = 1.8;
        elseif _getGold <= 1200 then
            time = 2.2;
        else
            time = 2.8;
        end
        self:_switchGameRunning(Enum_RunStep.GetNumber);
        self.numberControl:ControlNumber(_getGold, time);
        self.getGoldMusic = G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().GetGold);
    end
end

function _CUILayer:_onIconAnimate()
    local _bet, _getGold, _comGold, _ret = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    --关联节点
    local xCount = GameDefine.XCount();
    local yCount = GameDefine.YCount();
    local isAction = false;
    local lineCount = #_ret.lines;
    local lines = GameDefine.GetLines();
    local step = 0;
    for i = 1, xCount do
        for j = 1, yCount do
            self.iconCells[j][i]:Normal();
        end
    end
    --结算界面清理
    self.balanceUI:Clear();
    if self.runStep == Enum_RunStep.FlashIcon then
        local line, lineData;
        for i = 1, lineCount do
            lineData = _ret.lines[i];
            line = lines[lineData.lineNO];
            for j = 1, lineData.count do
                self.iconCells[line[j][1]][j]:Action();
                isAction = true;
                step = Enum_RunStep.FlashIcon;
            end
        end
    elseif self.runStep == Enum_RunStep.SuperCup then
        if _ret.isCup then
            --大力神杯
            local line = lines[_ret.cupLine];
            for i = 1, xCount do
                self.iconCells[line[i][1]][i]:Action();
                isAction = true;
            end
        end
    elseif self.runStep == Enum_RunStep.FreeGame then
        if _ret.isFreeGame then
            --            local freeCellCount = #_ret.freeCells;
            --            for i=1,freeCellCount do
            --                self.iconCells[_ret.freeCells[i].y][_ret.freeCells[i].x]:Action();
            --                local value = self.iconCells[_ret.freeCells[i].y][_ret.freeCells[i].x]:Value();
            --                isAction = true;
            --            end
            local iconEnum = GameDefine.EnumIconType();
            for i = 1, xCount do
                for j = 1, yCount do
                    local value = self.iconCells[j][i]:Value();
                    if value == iconEnum.FreeGame then
                        self.iconCells[j][i]:Action();
                        isAction = true;
                    end
                end
            end
        end
    end

    if isAction then
        --其他变灰
        for i = 1, xCount do
            for j = 1, yCount do
                self.iconCells[j][i]:Dark();
            end
        end
        --等待结算
        self.runTime = 0;
    end
end

function _CUILayer:_onNormalBalance()
    local _bet, _getGold, _comGold, _ret = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    self:_switchGameRunning(Enum_RunStep.NBalance);
    self.balanceUI:ShowResult(_comGold, _bet);
end

--游戏结算
function _CUILayer:_onSuperCupBalance()
    --停止奖杯声音
    G_GlobalGame._soundCtrl:StopSound(self.cupMusicHandler);
    local _bet, _getGold, _comGold, _ret = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameRet);
    self:_switchGameRunning(Enum_RunStep.CBalance);
    self.balanceUI:ShowCupResult(_getGold - _comGold, _bet);
end

function _CUILayer:_onStartEnterBallGame()
    local status = self.startStatus:Status();
    if status ~= Enum_StartStatus.Free then
        self:_onChangeGetGold(0);
    end
    --停止免费声音
    G_GlobalGame._soundCtrl:StopSound(self.freeGameMusicHandler);
    --进入点球开场动画
    self.enterBallGameMusicHandler = G_GlobalGame._soundCtrl:PlaySound(SoundDefine.EnumSound().Dianqiu);
    self:_switchGameRunning(Enum_RunStep.FBalance);
    self.balanceUI:EnterBallGame();
end

function _CUILayer:_onCheckFreeTotal()
    local status = self.startStatus:Status();
    if status == Enum_StartStatus.Free then
        --免费模式
        local _freeCount = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetFreeCount);
        if _freeCount <= 0 then
            self:_switchGameRunning(Enum_RunStep.FreeTotal);
            local _freeCount, _freeGet = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetFreeTotal);
            --显示免费统计
            self.balanceUI:ShowFreeTotal(_freeCount, _freeGet);
            --停止自动切换
            self.displayTopControl:StopSwitch(1);
        else
            self:_onGameStateFree();
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
    --清除结算
    self.balanceUI:Clear();
    if not self.isClearGetGold then
        if self.startStatus:Status() ~= Enum_StartStatus.Free then
            self.isClearGetGold = true;
        end
    end
    --显示正常图标
    self:_onNodeNormal();
    self:_onUpdateGold();
    self:_controlRunMode();
    --控制顶部内容
    self:_controlTopContent();
    --播放背景音乐
    G_GlobalGame._soundCtrl:NoMuteBgSound();
end

function _CUILayer:OnNumberControl(_diff, _curNumber, _totalNumber, _isEnd)
    self.uiGold = self.uiGold + _diff;
    self:_onChangeMyGold(self.uiGold);
    --self:_onChangeGetGold(_curNumber);
    self.balanceUI:ReduceNumber(_diff);
    if _isEnd then
        --结束了
        --等待一会儿在进入检测
        self:_switchGameRunning(Enum_RunStep.EGetNumber);
        self:_onUpdateGold();
        if self.getGoldMusic then
            G_GlobalGame._soundCtrl:StopSound(self.getGoldMusic);
            self.getGoldMusic = nil;
        end
    end
end

--
function _CUILayer:OnScrollColumnEvent(_eventID, _eventData)
    if _eventID == EnumEvent.ScrollStop then
        --图标停止转动
        self:_switchGameRunning(Enum_RunStep.Wait);
        --关联图标
        self:_releationNodes();
    end
end

--小游戏结束
function _CUILayer:OnMiniGameEvent(_eventID, _eventData)
    if _eventID == EnumEvent.MiniGameBalance then
        local _ret, _getGold = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameBallRet);
        --弹出中奖结果
        self.balanceUI:ShowBallResult(_ret, _getGold);
    elseif _eventID == EnumEvent.MiniGameOver then
        --小游戏结束
    end
end

function _CUILayer:OnBalanceEvent(_eventID, _ui, _diff, _isEnd)
    if _eventID == EnumEvent.AddGold then
        --小游戏结束
        self.uiGold = self.uiGold + _diff;
        self:_onChangeMyGold(self.uiGold);
        self.uiGetGold = self.uiGetGold + _diff;
        self:_onChangeGetGold(self.uiGetGold);
        if _isEnd then
            if self.runStep == Enum_RunStep.NBalance then
                --self:_onUpdateComGold();
            elseif self.runStep == Enum_RunStep.CBalance then
                --self:_onUpdateGetGold();
            elseif self.runStep == Enum_RunStep.FBalance then
            end
        end
    elseif _eventID == EnumEvent.BalanceOver then
        if self.runStep == Enum_RunStep.NBalance then
            --进入大力神杯检测
            self:_switchGameRunning(Enum_RunStep.WSuperCup);
            --self:_onUpdateComGold();
            self:_checkResult();
        elseif self.runStep == Enum_RunStep.CBalance then
            --            --进入免费游戏检测
            --            self.runStep = Enum_RunStep.WFreeGame;
            --            self:_checkResult();
            self:_checkGetGold();
        elseif self.runStep == Enum_RunStep.FBalance then
            --进入点球大战
            self:_switchGameRunning(Enum_RunStep.BallGame);
            self.balanceUI:Clear();
            self.minigame:Start();
            G_GlobalGame._soundCtrl:StopSound(self.enterBallGameMusicHandler);
            local status = self.startStatus:Status();
            if status ~= Enum_StartStatus.Free then
                --播放免费背景的背景音乐
                G_GlobalGame._soundCtrl:PlayBgSound(SoundDefine.EnumSound().FreeBG);
            end
            --静音背景音乐
            G_GlobalGame._soundCtrl:MuteBgSound();
        elseif self.runStep == Enum_RunStep.BallGame then
            --            do
            --                return ;
            --            end
            --更新自己金币
            self:_onUpdateGold();
            --            local _ret,_getGold = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetGameBallRet);
            --            self.uiGetGold = self.uiGetGold + _getGold;
            --            self:_onChangeGetGold(self.uiGetGold);
            self.isClearGetGold = false;

            --更新下免费次数
            self:_onUpdateFreeCount();
            --更新彩金
            self:_onUpdateCaijin();
            --点球结算
            self.minigame:Over();
            --开始顶部自动转动
            self.displayTopControl:AutoSwitch();
            --结算
            self:_onGameStateFree();
            --恢复背景音乐
            G_GlobalGame._soundCtrl:NoMuteBgSound();
        elseif self.runStep == Enum_RunStep.FreeTotal then
            --免费统计过后
            self:_onGameStateFree();
            G_GlobalGame._soundCtrl:PlayBgSound(SoundDefine.EnumSound().BG);
        end
    end
end

function _CUILayer:_controlShanGuang(_dt)
    self.shanGuangTime = self.shanGuangTime - _dt;
    if self.shanGuangTime <= 0 then
        self.leftShanGuangAnimate:Show();
        self.rightShanGuangAnimate:Show();
        self.leftShanGuangAnimate:Play();
        self.rightShanGuangAnimate:Play();
        self.shanGuangTime = math.random(40, 70) / 10;
    end
end

function _CUILayer:Update(_dt)
    self.longKeyPress:Execute(_dt);
    self.scrollColumnControl:Update(_dt);
    self.balanceUI:Update(_dt);
    self.minigame:Update(_dt);
    --数字控制
    self.numberControl:Update(_dt);
    self:_controlStatus(_dt);
    --游戏流程控制
    self:_controlGameRuning(_dt);
    --控制顶部显示
    self.displayTopControl:Update(_dt);
    --控制闪光
    self:_controlShanGuang(_dt);
    self:_controlStars(_dt);

end

function _CUILayer:_controlGameRuning(_dt)
    if self.runStep == Enum_RunStep.Null then
    elseif self.runStep == Enum_RunStep.Scroll then
    elseif self.runStep == Enum_RunStep.Wait then
        self.runTime = self.runTime + _dt;
        if self.runTime >= 0.3 then
            self:_switchGameRunning(Enum_RunStep.WFlashIcon);
            self:_checkResult();
        end
    elseif self.runStep == Enum_RunStep.FlashIcon then
        self.runTime = self.runTime + _dt;
        if self.runTime >= 0.8 then
            --静音背景音乐
            --G_GlobalGame._soundCtrl:MuteBgSound();  
            self:_onNormalBalance();
        end
    elseif self.runStep == Enum_RunStep.SuperCup then
        self.runTime = self.runTime + _dt;
        if self.runTime >= 2.3 then
            self:_onSuperCupBalance();
        end
    elseif self.runStep == Enum_RunStep.FreeGame then
        self.runTime = self.runTime + _dt;
        if self.runTime >= 2.3 then
            self:_onStartEnterBallGame();
        end
    elseif self.runStep == Enum_RunStep.WGetNumber then
        self.runTime = self.runTime + _dt;
        if self.runTime >= 1.5 then
            self:_onGetGold();
        end
    elseif self.runStep == Enum_RunStep.EGetNumber then
        self.runTime = self.runTime + _dt;
        if self.runTime >= 0.8 then
            --进入免费游戏检测
            self:_switchGameRunning(Enum_RunStep.WFreeGame);
            self:_checkResult();
        end
    end
end

function _CUILayer:UpdateInfo()

end

function _CUILayer:UpdateCaiJinPool()

end

--
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
--控制顶部内容
function _CUILayer:_controlTopContent()
    local status = self.startStatus:Status();
    local multiple = KeyEvent.GetKeyValue(G_GlobalGame.Enum_KeyValue.GetMultiple); --获取倍率 14
    --self.multipleNum:SetNumber(multiple);
    self.multipleNum:SetNumString("m" .. multiple);
    if status == Enum_StartStatus.Free then
        --self:DisplayMultiple();
    else
        --self.displayTopControl:StopSwitch(1);
    end
end

--选择自动次数
function _CUILayer:_onChooseAutoTimes(count)
    --自动次数
    self:_onAutoStart(count);
end

return _CUILayer;