--Point21ChipsCtrl.lua
--Date

--21点筹码控制类 对应LuaBehaviour
local LuaBehaviour
--endregion

Point21ChipsCtrl = {}

local self = Point21ChipsCtrl

local chipMoveSpeedF = 10 --15; --筹码移动速度

local idx_  --临时存储筹码所对应的玩家ID

local chipsNumberInt_  --临时存储筹码大小

local bInsurance_  --临时存储是否为保险筹码

local bEndChip_  --临时存储是否是最后一个创建的筹码

local toPlayerIdx_  --临时存储此筹码是庄家输给哪个玩家的

local iType_  --临时存储筹码类型

--构造函数
function Point21ChipsCtrl:New(o)
    local t = o or {}
    setmetatable(t, self)
    self.__index = self
    return t
end

--创建一个带 luabehaviour类的面板
function Point21ChipsCtrl.Create(iType, idx, this, parentTra, chipsNumberInt, bInsurance, bEndChip, toPlayerIdx)
    self.this = this -- 当前脚本对象
    self.thisParentTra = parentTra --当前物体父物体

    idx_ = idx --所属玩家索引
    chipsNumberInt_ = chipsNumberInt -- 筹码数据
    bInsurance_ = bInsurance
    bEndChip_ = bEndChip --是否是最后一个创建的筹码
    toPlayerIdx_ = toPlayerIdx --存储此筹码是庄家输给哪个玩家的
    iType_ = iType

    local resNameStr = "Chips" --需要加载的资源名字
    local objNameStr = resNameStr .. chipsNumberInt --创建出物体的名字

    --local obj = LoadAsset(Point21ResourcesNume.dbResNameStr, resNameStr);
    --local go = newobject(obj);
    local go = Point21ScenCtrlPanel.PoolForNewobject(resNameStr)
    Util.AddComponent("LuaBehaviour", go)
    go.name = objNameStr
    self.OnCreateCompose(go)

    --创建带luaBehaviour面板的方法
    --参数1：ab资源名字  参数2：要加载的预设名字  参数3：创建出来的对象名字  参数4：回掉方法
    --PanelManager:CreatePanel(Point21ResourcesNume.dbResNameStr, resNameStr, objNameStr, self.OnCreateCompose);

end

--创建面板成功的回掉函数
function Point21ChipsCtrl.OnCreateCompose(prefab)
    prefab.transform:SetParent(self.thisParentTra)
    prefab.transform.localPosition = Vector3.New(0, 0, 0)
    prefab.transform.localScale = Vector3.New(1, 1, 1)

    for i = 1, #bottomChipsListIntTab do
        prefab.transform:GetChild(i - 1).name = bottomChipsListIntTab[i] .. ""
    end

    local numStr = chipsNumberInt_ .. "" -- 筹码数值转字符串

    prefab.transform:Find(numStr).gameObject:SetActive(true) --将对应的筹码数值显示出来

    --    Point21ScenCtrlPanel.setNumImage(chipsNumberInt_, prefab.transform:Find(numStr):GetChild(0) );

    LuaBehaviour = prefab.transform:GetComponent("LuaBehaviour")
    LuaBehaviour:SetLuaTab(self.this, "Point21ChipsCtrl")

end

function Point21ChipsCtrl:Begin(obj)
    self.transform = obj.transform
    self.idx = idx_ --对应玩家索引
    self.chipsNumberInt = chipsNumberInt_ --筹码值

    self.bInsurance = bInsurance_ --是否是保险筹码

    self.bEndChip = bEndChip_ -- 是否是最后一个创建的筹码

    self.toPlayerIdx = toPlayerIdx_ --存储此筹码是庄家输给哪个玩家的

    self.iType = iType_

    self.bCdTime = false
    self.tempCDTimeF = 0 --冷却累加时间
    self.cdTimeF = 0.2 -- 冷却时间

    self.bMove = false --是否开始移动
    self.bDestroy = false -- 是否删除物体

    point21PlayerTab[self.idx]:getChipInst(self.this) --将此筹码保存到自己对应的玩家中去
end

function Point21ChipsCtrl:FixedUpdate()
    self:beginMove()

    self:zjChipWaitTime()

    if (self.bMove) then
        --筹码在运动中 玩家退出
        if (not point21PlayerTab) then
            return
        end

        if (not point21PlayerTab[self.idx]) then
            self.bMove = false
            return
        end

        --        if(not point21PlayerTab[self.idx].bHaveInfo and 6 ~= self.idx ) then

        --            destroy(self.transform.gameObject);
        --            return;
        --        end
    end
end

--筹码移动
-- PosTra 移动到的位置    bDestroy 是否在移动完删除
function Point21ChipsCtrl:moveToPos_Old(PosTra, bDestroy)
    bDestroy = bDestroy or false

    self.bDestroy = bDestroy
    self.endPosTra = PosTra --运动终点
    self.bMove = true

    self.posVe3 = self.endPosTra.position

    if ("EndPos" == self.endPosTra.name) then
        --玩家扔筹码的位置
        if (Point21ScenCtrlPanel.bBeginThrwoChip) then
            --下注状态且第一组筹码超过10个 则删除第一个1个
            if (point21PlayerTab[self.idx].chipInstTab) then
                if (#point21PlayerTab[self.idx].chipInstTab[1] > 100) then
                    self.bDestroyfistChip = true
                    self.desChip = point21PlayerTab[self.idx].chipInstTab[1][1].transform
                    self.posVe3 = self.desChip.transform.position
                    table.remove(point21PlayerTab[self.idx].chipInstTab[1], 1)
                end
            end
        end
    end

    --self.transform:DOMove(self.posVe3, 0.7, false);
end

function Point21ChipsCtrl:moveToPos(PosTra, bDestroy, fSpeed, funCallBack)
    local fSp = fSpeed or 0.5
    bDestroy = bDestroy or false
    self.bDestroy = bDestroy
    self.endPosTra = PosTra --运动终点
    if (self.transform ~= nil and PosTra ~= nil) then
        self.transform:SetParent(PosTra)
    end

    local dotween = self.transform:DOLocalMove(Vector3.New(0, 0, 0), fSp, false):SetEase(DG.Tweening.Ease.Linear)
    dotween:OnComplete(
            function()
                if (self.endPosTra.parent) then
                    if ("EndPos" == self.endPosTra.parent.name or "Pos_SPChip" == self.endPosTra.parent.parent.name) then
                        local iNum = self.endPosTra.childCount
                        if (iNum ~= 1) then
                            iNum = (iNum - 1) * 4
                        end
                        self.transform.localPosition = Vector3.New(0, iNum, 0)
                    end
                end

                if (funCallBack) then
                    funCallBack()
                end

                if (zjPos == self.idx and not self.bDestroy) then
                else
                    point21PlayerTab[self.idx]:chipExerciseEndCallBack(self)

                    if (self.bDestroy) then
                        self.bDestroy = false
                        destroy(self.transform.gameObject)
                    end
                end
            end
    )
end

--开始移动
function Point21ChipsCtrl:beginMove()
    if (self.bMove) then
        if (self.transform.position ~= self.posVe3) then
            self.transform.position = Vector3.MoveTowards(self.transform.position, self.posVe3, Time.deltaTime * chipMoveSpeedF)
        end

        if (self.transform.position == self.posVe3) then
            self.transform:SetParent(self.endPosTra)
            self.transform.localScale = Vector3.New(1, 1, 1)
            if (self.endPosTra.parent) then
                self.transform.localPosition = Vector3.New(0, 0, 0)
                if ("EndPos" == self.endPosTra.parent.name or "Pos_SPChip" == self.endPosTra.parent.parent.name) then
                    local iNum = self.endPosTra.childCount
                    if (iNum ~= 1) then
                        iNum = iNum * 4
                    end
                    self.transform.localPosition = Vector3.New(0, iNum, 0)
                end
            end
            self.bMove = false

            if (zjPos == self.idx and not self.bDestroy) then
                --self.bCdTime = true
            else
                point21PlayerTab[self.idx]:chipExerciseEndCallBack(self)

                if (self.bDestroyfistChip) then
                    --删除此玩家第一组筹码的首个筹码
                    destroy(self.desChip.transform.gameObject)
                    self.bDestroyfistChip = false
                end

                if (self.bDestroy) then
                    self.bDestroy = false
                    destroy(self.transform.gameObject)
                end
            end
        end
    end
end

function Point21ChipsCtrl:moveToPosForSp(PosTra, bDestroy)
    self.transform:SetParent(PosTra)
    local dotween = self.transform:DOLocalMove(Vector3.New(0, 0, 0), 1, false)
    dotween:OnComplete(
            function()
                if (bDestroy) then
                    destroy(self.transform.gameObject)
                end
            end
    )
end

--庄家筹码等待时间
function Point21ChipsCtrl:zjChipWaitTime()
    --    if(self.bCdTime) then
    --        self.tempCDTimeF = self.tempCDTimeF + Time.deltaTime;

    --        if(self.tempCDTimeF >= self.cdTimeF) then

    --            self:moveToPos(self.endPosTra.parent.parent, true);

    --            if(not self.bInsurance) then
    --                Point21ZJCtrl.zjLostChipsEvent(self);
    --            end

    --            self.bCdTime = false;
    --            self.tempCDTimeF = 0;

    --        end
    --    end

    if (Point21ZJCtrl.bPlayerBeginChipMove and zjPos == self.idx and not self.bDestroy) then
        if (self.endPosTra.parent.parent ~= nil) then
            self:moveToPos(self.endPosTra.parent.parent, true)
        end
        if (not self.bInsurance and self.toPlayerIdx) then
            self:zjLostChipsEvent()
        end
    end
end

--庄家输掉筹码的事件 在筹码运动一段时间后触发触发
function Point21ChipsCtrl:zjLostChipsEvent()
    if (point21PlayerTab[self.toPlayerIdx].allChipValIntTab) then
        for i = 1, #point21PlayerTab[self.toPlayerIdx].allChipValIntTab do
            if (point21PlayerTab[self.toPlayerIdx].allChipValIntTab[i] > 0) then
                point21PlayerTab[self.toPlayerIdx]:playerWinChips(i)
            end
        end
    end
end
