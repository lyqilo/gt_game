Point21Hellp = {}

local self = nil

--local luaBehaviour;

function Point21Hellp:New(o)
    local t = o or {}
    setmetatable(t, self)
    self.__index = self
    return t
end

function Point21Hellp.Init(traPar, csJoinLua)
    if (not self) then
        self = Point21Hellp:New()
        local resNameStr = "HellpPanel"
        local obj = Point21ScenCtrlPanel.PoolForNewobject(resNameStr)
        obj.name = resNameStr
        obj.transform:SetParent(traPar)
        obj.transform.localScale = Vector3.one
        obj.transform.localPosition = Vector3.New(0, 0, 100)
        obj.transform.localEulerAngles = Vector3.New(0, 0, 0)

        self.transform = obj.transform
        --self.transform:GetComponent("RectTransform").sizeDelta = Vector3.New(0, 0, 0)
        self.transform:GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.height / Screen.width) * 750 + 20, 750 + 20);

        self.traBottom = self.transform:Find("HellpBottom")
        self.traExplains = self.traBottom:Find("Explains")
        self.traSigns = self.traBottom:Find("Signs")
        self.traShowSign = self.traSigns:GetChild(0):GetChild(0)

        self.Bj = self.traBottom:Find("BJ")

        -- for i = self.Bj.childCount - 1, self.Bj.childCount - 2, -1 do
        --     self.Bj:GetChild(i).gameObject:SetActive(false)
        -- end

        csJoinLua:AddClick(self.transform.gameObject, Point21Hellp.OnClickBackGameBtn)
        local eventTrigger = Util.AddComponent("EventTriggerListener", self.traBottom.gameObject)
        eventTrigger.onBeginDrag = self.OnBeginDrag
        eventTrigger.onEndDrag = self.onEndDrag

        local traBtns = self.traBottom:Find("Buttons")
        csJoinLua:AddClick(traBtns.transform:Find("LeftButton").gameObject, Point21Hellp.OnClickBtn)
        csJoinLua:AddClick(traBtns.transform:Find("RightButton").gameObject, Point21Hellp.OnClickBtn)
        csJoinLua:AddClick(traBtns.transform:Find("QuitButton").gameObject, Point21Hellp.OnClickQuitBtn)
    end

    self.transform.gameObject:SetActive(true)
end

function Point21Hellp.ShowExplain(bShow)
    self.transform.gameObject:SetActive(bShow)
end

function Point21Hellp.OnClickBackGameBtn(prefab)
    self.ShowExplain(false)
end

function Point21Hellp.OnBeginDrag(o, traPos)
    self.ve3startPos = traPos.position
end

function Point21Hellp.onEndDrag(o, traPos)
    local bRight = false
    if (self.ve3startPos.x > traPos.position.x) then
        bRight = true
    end
    Point21Hellp.OnClickChangeSiblingIndex(bRight)
end

function Point21Hellp.OnClickBtn(btn)
    local bRight = false
    if ("RightButton" == btn.name) then
        bRight = true
    end
    Point21Hellp.OnClickChangeSiblingIndex(bRight)
end

function Point21Hellp.OnClickQuitBtn(btn)
    self.ShowExplain(false)
end

--改变层级
function Point21Hellp.OnClickChangeSiblingIndex(bRight)
    local traShowExplain
    if (bRight) then --右
        traShowExplain = self.traExplains:GetChild(self.traExplains.childCount - 2)
        traShowExplain.gameObject:SetActive(true) --显示下一个

        local tempTra = self.traExplains:GetChild(self.traExplains.childCount - 1)
        tempTra.gameObject:SetActive(false) --隐藏当前
        tempTra:SetSiblingIndex(0)
    else --左
        self.traExplains:GetChild(self.traExplains.childCount - 1).gameObject:SetActive(false) --隐藏当前

        local tempTra = self.traExplains:GetChild(0)
        tempTra.gameObject:SetActive(true) --显示下一个
        tempTra:SetSiblingIndex(self.traExplains.childCount - 1)
        traShowExplain = tempTra
    end

    Point21Hellp.SetShowSignPos(traShowExplain)
end

--设置显示的点
function Point21Hellp.SetShowSignPos(traExplain)
    local listNameStr = string.split(traExplain.name, "_")
    local iExplainId = tonumber(listNameStr[2])
    local iSignId = self.traSigns.childCount - 1 - iExplainId
    local traPar = self.traSigns:GetChild(iSignId)
    self.traShowSign:SetParent(traPar)
    self.traShowSign.localPosition = Vector3.New(0, 0, 0)
end

function Point21Hellp.Clealthis()
    self = nil
end
