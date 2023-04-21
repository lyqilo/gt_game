require "Common/define"-- 默认的定义
require "System/Global"-- 默认的定义
require "Common/functions"-- 公共函数

-- ===========每个筹码身上的执行函数================
BaccaratChip = { };
local self = BaccaratChip;
-- 保存筹码的个数（从游戏一开始生成了多少个鱼    ）
local Count = 0;
AllChipTable={};
chip_index=1;
-- 构造函数
function BaccaratChip:New()
    local t = o or { };
    setmetatable(t, { __index = self });
    return t;
end

-- 创建筹码，提供给其它类调用(下注)
--local t={creatprefeb=" ",parentprefeb=" ",startPos=0,endPos=Vector3.New(0,0,0),areanum=1,}
-- t={creatprefeb,parentprefeb,startPos,endPos,areanum,};
function BaccaratChip.Create(t)
    local go = newobject(t.creatprefeb);
    go.transform:SetParent(t.parentprefeb.transform);
    go.transform.localScale = Vector3.one;
    go.name = t.parentprefeb.name;
    go:GetComponent('RectTransform').sizeDelta = Vector2.New(60, 60);
    local vet2 = t.parentprefeb:GetComponent('RectTransform').sizeDelta;
    if t.startPos == 0 then
        local zhengfu = math.random(0, 5);
        if zhengfu / 2 == 0 then
            go.transform.localPosition = Vector3.New(1000,(350 - math.random(0, 700)), 0);
        else
            go.transform.localPosition = Vector3.New(-1000,(350 - math.random(0, 700)), 0);
        end
    else
        go.transform.Position = startPos
    end
    local pos = Vector3.New(((vet2.x / 2) -30 - math.Random(0,(vet2.x - 60))),((vet2.y / 2) -30 - math.Random(0,(vet2.y - 60))), 0);
    Util.AddComponent("LuaBehaviour", go);
    local l = go:GetComponent("LuaBehaviour");
    local luaSlef = self:New();
    luaSlef.num = t.areanum;
    luaSlef.index = chip_index;
    luaSlef.transform = go.transform;
    l:SetLuaTab(luaSlef, "BaccaratChipObj");
    table.insert(AllChipTable, #AllChipTable + 1, luaSlef)
    chip_index = chip_index + 1;
    local tweener = go.transform:DOLocalMove(pos, 0.5, false);
    tweener:SetEase(DG.Tweening.Ease.Linear);
    tweener:OnComplete( 
        function()
            
            MusicManager:Play(BaccaraPanel.GetMusic("Snd_Chip"));

        end );
end

-- 创建筹码，提供给其它类调用(结束)从筹码盒飞向赢了的下注区域
-- t={creatprefeb,parentprefeb};
function BaccaratChip.CreateStop(t)
    local go = newobject(t.creatprefeb);
    go.transform:SetParent(t.parentprefeb.transform);
    go.transform.localScale = Vector3.one;
    go.name = t.parentprefeb.name;
    go.transform.position = BaccaraPanel.ChipPos.transform.position;
    go:GetComponent('RectTransform').sizeDelta = Vector2.New(60, 60);
    Util.AddComponent("LuaBehaviour", o);
    local l = o:GetComponent("LuaBehaviour");
    local luaSlef = self:New();
    l:SetLuaTab(luaSlef, "BaccaratChipObj");
    local vet2 = t.parentprefeb:GetComponent('RectTransform').sizeDelta;
    local pos = Vector3.New(((vet2.x / 2) -30 - math.Random(0,(vet2.x - 60))),((vet2.y / 2) -30 - math.Random(0,(vet2.y - 60))), 0);
    local tweener = go.transform:DOLocalMove(pos, 0.5, false);
    tweener:SetEase(DG.Tweening.Ease.Linear);
end


-- 飞向筹码盒（需要缩小，删除）BaccaraPanel.ChipPos
function BaccaratChip:FlyAllChipMethod()
    local movepos = BaccaraPanel.ChipPos.transform.position;
    local tweener = self.transform:DOMove(movepos, 0.8, false);
    tweener:OnPlay( function() local tweener = self.transform:DOScale(Vector3.New(0.5, 0.5, 1), 0.8); end)
    tweener:SetEase(DG.Tweening.Ease.Linear);
    tweener:OnComplete( function() destroy(self); end);
end


--结束飞向玩家（左右方向飞）

function BaccaratChip:FlyLeftRightMethod()
    local overpos = Vector3.New(0, 0, 0);
    local zhengfu = math.random(0, 2);
    if zhengfu / 2 == 0 then
        overpos = Vector3.New(1000,(350 - math.random(0, 700)), 0);
    else
        overpos = Vector3.New(-1000,(350 - math.random(0, 700)), 0);
    end
    local tweener = self.transform:DOLocalMove(overpos, 0.5, false);
    tweener:SetEase(DG.Tweening.Ease.Linear);
    tweener:OnComplete( function() destroy(self); end);
end

