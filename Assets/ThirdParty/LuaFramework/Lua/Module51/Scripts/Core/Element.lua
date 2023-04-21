Element = {}
local self = Element;
---节点
self.node = nil;
---图标
self.icon = nil;
---中奖特效
self.selectNode = nil;
---列
self.m_col = 0;
self.m_Conut = 0;
---顺序位置
self.m_pos = 0;

self.ICON_HIEGHT = 140;
self.ICON_OFFSET = 0;
self.currentIndex = -1;
self.showTime = 0;
function Element:new(obj)
    local t = obj or {};
    setmetatable(t, { __index = self });
    return t;
end
---获取UI组件 GameObject
function Element:OnInit(itemNode)
    self.node = itemNode;
    self.icon = itemNode.transform:GetComponent("Image");
    local select = itemNode.transform:Find("Select");
    if select ~= nil then
        self.selectNode = select.gameObject;
    end

end
function Element:ShowSelect(isshow)
    self.selectNode:SetActive(isshow);
    if isshow then
        local hide = function()
            self.selectNode:SetActive(false);
        end
        SlotGameEntry.AddCallBack(0.15, hide);
    end
end
function Element:PlayAnimation(play)
    if (play == true) then
        self.selectNode.transform.localScale = Vector3.New(1, 1, 1) * 1.5;
    else
        self.selectNode.transform.localScale = Vector3.New(1, 1, 1) * 1.5;
        self.selectNode.SetActive(false);
    end
end
function Element:SetPos(pos)
    self.m_pos = pos;
    local old = self.node.transform.localPosition;
    self.node.transform.localPosition = Vector3.New(old.x, -pos * self.ICON_HIEGHT + self.ICON_OFFSET, old.z);
end
function Element:ChangeMoIcon()
    local number = math.random(1, #ResoureceMgr.SmallMoSpriteList);
    if (self.m_Conut == 2) then
        number = math.random(1, 7);
    end
    self.icon.sprite = ResoureceMgr.SmallMoSpriteList[number];
end
function Element:ChangeIcon(index)
    self.currentIndex = index;
    if not LogicDataSpace.isSmallGameEnd then
        local t = function()
            self:ChangeIcon(self.currentIndex);
        end
        local number = math.random(1, #ResoureceMgr.SpriteList);
        if (self.m_Conut == 2) then
            number = math.random(1, 7);
        end
        self.icon.sprite = ResoureceMgr.SmallMoSpriteList[number];
        SlotGameEntry.AddCallBack(1.5, t)
        return
    end
    if (index < 0) then
        local number = math.random(1, #ResoureceMgr.SpriteList);
        if (self.m_Conut == 2) then
            number = math.random(1, 7);
        end
        self.icon.sprite = ResoureceMgr.SpriteList[number];
    else
        if (index < 3) then
            index = 2 - index;

            local valueIndex = index * self.m_Conut + self.m_col;
            if (self.m_Conut == 2) then
                valueIndex = self.m_col;
                self.icon.sprite = ResoureceMgr.SmallSpriteList[LogicDataSpace.samlCenterResult[valueIndex]];
                return
            end
            self.icon.sprite = ResoureceMgr.SpriteList[LogicDataSpace.resultElement[valueIndex]];
        end
    end
end