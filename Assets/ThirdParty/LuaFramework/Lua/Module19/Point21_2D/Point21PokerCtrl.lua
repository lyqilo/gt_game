--Point21PokerCtrl.lua
--Date

local LuaBehaviour
--21点扑克控制 对应LuaBehaviour

--endregion

--默认的定义
--require "Module19/Point21_2D/Point21ScenCtrlPanel" --场景控制
require "Module19/Point21_2D/Point21ResourcesNume" --游戏资源管理

Point21PokerCtrl = {}

local self = Point21PokerCtrl

local pokerMoveSpeedF = 20 -- 扑克移动速度

local pokerRotateSpeedF = -8 --  -10扑克翻转速度

local idx_  --临时存储扑克所对应的玩家ID

local byPokerDataByte_  --临时存储扑克数据

local pokerOrder_  --临时存储扑克在此次发牌中的顺序

local bIsHalfway_  --临时存储是不是中途进入

--构造函数
function Point21PokerCtrl:New(o)
    local t = o or {}
    setmetatable(t, self)
    self.__index = self
    return t
end

--创建一个带 luabehaviour类的面板
function Point21PokerCtrl.Create(idx, this, parentTra, pokerDataByte, pokerOrder, bIsHalfway)
    self.this = this -- 当前脚本对象
    self.thisParentTra = parentTra --当前物体父物体
    idx_ = idx --所属玩家索引
    byPokerDataByte_ = pokerDataByte -- 扑克数据

    pokerOrder_ = pokerOrder

    bIsHalfway_ = bIsHalfway or false

    local resNameStr = "Poker" --需要加载的资源名字
    local objNameStr = resNameStr .. pokerDataByte --创建出物体的名字
    logYellow("创建新扑克牌："..resNameStr.."   "..pokerDataByte.."   所属玩家id："..idx)
    local go = Point21ScenCtrlPanel.PoolForNewobject(resNameStr)
    Util.AddComponent("LuaBehaviour", go)
    go.name = objNameStr
    self.OnCreateCompose(go)

    --创建带luaBehaviour面板的方法
    --参数1：ab资源名字  参数2：要加载的预设名字  参数3：创建出来的对象名字  参数4：回掉方法
    --PanelManager:CreatePanel(Point21ResourcesNume.dbResNameStr, resNameStr, objNameStr, self.OnCreateCompose);
end

--创建面板成功的回掉函数
function Point21PokerCtrl.OnCreateCompose(prefab)
    prefab.transform:SetParent(self.thisParentTra)
    prefab.transform.localPosition = Vector3.New(0, 0, 0)
    if (bIsHalfway_ and 255 ~= byPokerDataByte_) then --中途进入且不是庄家的第2张牌时 直接转过来
        prefab.transform.localEulerAngles = Vector3.New(0, 0, 0)
    else
        prefab.transform.localEulerAngles = Vector3.New(0, 180, 0)
    end

    prefab.transform.localScale = Vector3.New(1, 1, 1)

    LuaBehaviour = prefab.transform:GetComponent("LuaBehaviour")
    LuaBehaviour:SetLuaTab(self.this, "Point21PokerCtrl")
end

--多个对象使用的时候C#调用，当多个对象使用同一份代码时， C#不用调用 Awake，C#只会在 start方法结束后调用 Lua层的StartOver
function Point21PokerCtrl:Begin(obj)
    self.transform = obj.transform

    self.idx = idx_ --扑克对应的玩家ID

    self.byPokerDataByte = byPokerDataByte_ --扑克数据

    self.pokerOrder = pokerOrder_ --扑克在此次发牌中的顺序

    self.bIsHalfway = bIsHalfway_ --是不是中途进入

    --error("transform name :" .. self.transform.name .. " __poker data : " ..self.byPokerDataByte)

    self.bMove = false --扑克是否开始移动

    self.bRotate = false --翻转扑克
    logYellow("self.bRotate = false --翻转扑克")

    self.bShowPoker = false --是否执行过显示扑克函数

    point21PlayerTab[self.idx]:getPokerInst(self.this) --将此扑克保存到自己对应的玩家中去

    if (self.bIsHalfway) then --中途进入直接换上点数图片
        self:showPokerData()
    end
end

function Point21PokerCtrl:FixedUpdate()
    self:beginMove()

    self:beginRotate()

    if (self.bMove or self.bRotate) then --扑克在运动中 玩家退出，销毁运动的扑克
        if (not point21PlayerTab) then
            return
        end

        if (not point21PlayerTab[self.idx]) then
            self.bMove = false
            self.bRotate = false
            return
        end

        if (not point21PlayerTab[self.idx].bHaveInfo and zjPos ~= self.idx) then
            destroy(self.transform.gameObject)
            return
        end
    end
end

--移动到指定位置
--endPosTra 指定位置的transform
function Point21PokerCtrl:moveToPos(endPosTra, bDestroy)
    bDestroy = bDestroy or false

    self.bDestroy = bDestroy
    self.endPosTra = endPosTra --扑克移动的终点位置
    self.bMove = true

    --self.transform:DOMove(endPosTra.position, 2, false):OnKill(Point21PokerCtrl.moveToPosCallBack);

    --dt:OnKill(Point21PokerCtrl.moveToPosCallBack );
end

--扑克开始移动
function Point21PokerCtrl:beginMove()
    if (self.bMove) then
        self.transform.position =
            Vector3.MoveTowards(self.transform.position, self.endPosTra.position, Time.deltaTime * pokerMoveSpeedF)

        if (self.transform.position == self.endPosTra.position) then
            self.transform:SetParent(self.endPosTra)
            self.transform.localScale = Vector3.New(1, 1, 1)
            self.bMove = false

            if (self.bDestroy) then
                destroy(self.transform.gameObject)
            else
                self.bRotate = true
            end
        end
    end
end

--开始翻转扑克
function Point21PokerCtrl:beginRotate()
    if (self.bRotate) then
        if (self.byPokerDataByte == 255) then
            logYellow("停止翻拍255")
            self.bRotate = false
            return
        end

        self.transform:Rotate(0, pokerRotateSpeedF, 0)

        if (self.transform.localEulerAngles.y <= 90) then --在此时换上点数图片
            if (not self.bShowPoker) then
                self:showPokerData()
                self.bShowPoker = true
            end
        end

        if (self.transform.localEulerAngles.y > 180 and self.transform.localEulerAngles.y <= 360) then --停止转动
            self.transform.localEulerAngles = Vector3.New(0, 0, 0)
            logYellow("停止翻拍1")
            self.bRotate = false
            self.bShowPoke = false
            logYellow("扑克运动结束的回调函数:"..self.idx)
            point21PlayerTab[self.idx]:pokerExerciseEndCallBack(self) --扑克运动结束的回调函数

        end
    end
end

local currentPokerThisTab = {} --临时存储当前要显示图片的扑克实例

--显示扑克数据
function Point21PokerCtrl:showPokerData()
    if (255 ~= self.byPokerDataByte) then --255为庄家背面牌
        self.resNameStr = Point21ResourcesNume.getPokerNume(self.byPokerDataByte)

        table.insert(currentPokerThisTab, self)

        --local res =  LoadAsset(Point21ResourcesNume.dbResNameStr, self.resNameStr);
        local res = Point21ScenCtrlPanel.Pool(self.resNameStr)
        Point21PokerCtrl.loadAssetPokerCallBack(res)
    end
end

--获取扑克资源回调
function Point21PokerCtrl.loadAssetPokerCallBack(prefab)
    for key, var in pairs(currentPokerThisTab) do
        if (prefab.name == var.resNameStr) then
            var.transform:GetComponent("Image").sprite = prefab.transform:GetComponent("Image").sprite
            currentPokerThisTab[key] = nil
            return
        end
    end
end

--moveToPos的回调函数
function Point21PokerCtrl.moveToPosCallBack()
end
