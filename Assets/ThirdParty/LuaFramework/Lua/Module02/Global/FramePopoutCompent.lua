FramePopoutCompent = {}
local self = FramePopoutCompent
self.isShow = true
self.isTipShow = true
self.isRun = false
self.isTipRun = false
self.lastpop = nil
self.isLast = false
self._luaBeHaviour = nil
FramePopoutCompent.ShowType = {
    _01border = 0,
    _02noBorder = 1
}

FramePopoutCompent.Pop = {
    --以下不需要的请保持默认值 可以通过Pop.New创建
    _01showType = FramePopoutCompent.ShowType._01Border, --显示样式，比如有没有按钮，自动消失
    _02conten = "网络错误", --提示文字描述
    _03jump = false, --是否有跳转
    _04scenName = nil, --跳转到场景的名字
    _05yesBtnCallFunc = nil, --确定按钮的回掉
    _06noBtnCallFunc = nil, --取消按钮的回掉
    _07module = nil, --这个弹窗来自哪里模块
    _08autoClose = false, --是否自动关闭
    _09autoCloseTime = 2, --自动关闭的时间
    _99last = false, --这个弹窗弹了，是否还需要显示其他没有弹出来的窗口
    _100modePanel = nil, --弹窗的父物体，销毁是要删除
    isBig = false
}

function FramePopoutCompent.Show(str, CallBack)
    local pop = FramePopoutCompent.Pop.New()
    pop._02conten = str
    pop._06noBtnCallFunc = CallBack
    pop.isBig = false
    FramePopoutCompent.Add(pop)
end

function FramePopoutCompent.Pop.New()
    local fPop = {}
    setmetatable(fPop, FramePopoutCompent.Pop)
    fPop._01showType = FramePopoutCompent.ShowType._01Border
    fPop._02conten = "网络错误"
    fPop._03jump = false
    fPop._04scenName = nil
    fPop._05yesBtnCallFunc = nil
    fPop._06noBtnCallFunc = nil
    fPop._07module = LaunchModuleConfiger.Module02
    fPop._08autoClose = false
    fPop._09autoCloseTime = 2
    fPop._99last = false
    fPop._100modePanel = nil
    fPop._11title = nil
    fPop.isBig = false;
    return fPop
end

function FramePopoutCompent.Add(pop)
    if FramePopoutCompent.isLast == true then
        return
    end
    if self.PopQueue == nil then
        self.PopQueue = list:new()
    end
    if self.tipQueue == nil then
        self.tipQueue = list:new();
    end
    if pop.isBig then
        self.PopQueue:push(pop)
        log("FramePopoutCompent cout:" .. self.PopQueue.length)
        self.Run()
    else
        if self.isTipShow then
            self.tipQueue:push(pop);
            self.TipRun()
        end
    end
end
function FramePopoutCompent.TipRun()
    --自定义一个类似Update的
    if self.isTipRun then
        return
    end
    if self.tipQueue == nil then
        return
    end
    if not self.isTipRun then
        coroutine.start(
                function()
                    self.isTipRun = true
                    while self.isTipRun do
                        coroutine.wait(0.1)
                        self.ConstTipUpdate()
                        if self.tipQueue.length == 0 then
                            self.isTipRun = false
                        end
                    end
                    self.isTipRun = false
                end
        )
    end
end
function FramePopoutCompent.Run()
    --自定义一个类似Update的
    if self.isRun then
        return
    end
    if self.PopQueue == nil then
        return
    end
    if not self.isRun then
        coroutine.start(
                function()
                    self.isRun = true
                    while self.isRun do
                        coroutine.wait(0.1)
                        self.ConstUpdate()
                        if self.PopQueue.length == 0 then
                            self.isRun = false
                        end
                    end
                    self.isRun = false
                end
        )
    end
end

function FramePopoutCompent.Remove()
    if self.PopQueue == nil then
        return
    end
    self.PopQueue:shift()
end

function FramePopoutCompent.ConstTipUpdate()
    if self.tipQueue == nil then
        return
    end
    if self.tipQueue.length == 0 then
        return
    end
    if not self.isTipShow then
        return
    end
    self.Create(self.tipQueue:shift())
end
function FramePopoutCompent.ConstUpdate()
    if self.PopQueue == nil then
        return
    end
    if self.PopQueue.length == 0 then
        return
    end
    if not self.isShow then
        return
    end
    self.Create(self.PopQueue:shift())
end

function FramePopoutCompent.Dispose(pop)
    GameManager.isQuitGame=false

    if pop._100modePanel then
        destroy(pop._100modePanel.gameObject)
    end
    if pop._06noBtnCallFunc then
        pop._06noBtnCallFunc()
    end
    self.isShow = true
    FramePopoutCompent.isLast = false
end

function FramePopoutCompent.Clear()
    if self.PopQueue == nil then
        return
    end
    self.PopQueue:clear()
    if IsNil(self.lastpop) then
        return
    end
    if self.lastpop._100modePanel then
        destroy(self.lastpop._100modePanel.gameObject)
    end
    self.isShow = true
    FramePopoutCompent.isLast = false
end

function FramePopoutCompent.yesBtnCallFunc(pop)
    if pop._100modePanel then
        destroy(pop._100modePanel.gameObject)
    end
    if pop._05yesBtnCallFunc then
        pop._05yesBtnCallFunc()
    end
    self.isShow = true
    FramePopoutCompent.isLast = false
end

function FramePopoutCompent.Create(pop)
    if pop.isBig then
        log("FramePopoutCompent.Create:" .. self.PopQueue.length)
        self.isShow = false
        self.lastpop = pop
        if pop._99last then
            FramePopoutCompent.isLast = true
            self.PopQueue:clear()
        end
        log("Create framePopoutCompent panle")
        local obj = HallScenPanel.Pool("TishiPanel_Version3")
        pop._100modePanel = obj.transform
        -- local cs = obj:AddComponent(typeof(CsJoinLua));
        -- cs:LoadLua('Module02.Global.FramePopoutCompent', "FramePopoutCompent");
        local go = obj.transform:GetChild(0).gameObject
        obj.name = "FramePopoutCompent"
        go.name = "tishi"
        --fPop._11title
        local IMGResolution = go:GetComponent("IMGResolution")
        if IMGResolution == nil then
            Util.AddComponent("IMGResolution", go)
        end

            local luaBeHaviour=Util.AddComponent("LuaBehaviour",go);
        local IguoreBtn = go.transform:Find("Bg/IguoreBtn").gameObject
        IguoreBtn:SetActive(false)
        local FreeGoldBtn = go.transform:Find("Bg/FreeGoldBtn").gameObject
        FreeGoldBtn:SetActive(false)
        local RechagreBtn = go.transform:Find("Bg/RechagreBtn").gameObject
        RechagreBtn:SetActive(false)
        local TimeBtn = go.transform:Find("Bg/Time").gameObject
        TimeBtn:SetActive(false)
        local SureBtn = go.transform:Find("Bg/SureBtn").gameObject
        SureBtn:SetActive(false)

        --if GameManager.isQuitGame then
        --    SureBtn.transform:Find("Image").gameObject:SetActive(false)
        --    SureBtn.transform:Find("Image2").gameObject:SetActive(true)
        --else
        --    SureBtn.transform:Find("Image").gameObject:SetActive(true)
        --    SureBtn.transform:Find("Image2").gameObject:SetActive(false)
        --end

        local SureBtn_One = go.transform:Find("Bg/SureBtn_One").gameObject
        local Head_Title = go.transform:Find("HeadInfo").gameObject
        if not StringIsNullOrEmpty(pop._11title) then
            Head_Title.transform:GetComponent("Text").text = pop._11title
        end
        -- SureBtn_One:SetActive(false);
        SureBtn.transform.localPosition = Vector3.New(167, -193, 0)

        IguoreBtn.transform.localPosition = Vector3.New(-163, -193, 0)
        --IguoreBtn.transform:Find("Text"):GetComponent("Text").text = "取 消"

        --go.transform.localScale = Vector3.New(1,1,1)
        go.transform.localScale = Vector3.New(GameManager.ScreenRate, GameManager.ScreenRate, GameManager.ScreenRate);
        go.transform.localPosition = Vector3.New(0, 0, 100)

        local t = go.transform:Find("Bg/Text").gameObject
        t:GetComponent("Text").fontSize = 25
        -- Util.LogError(tostring(t.transform.localPosition));
        t:GetComponent("Text").text = pop._02conten
        t:GetComponent("Text").raycastTarget = false
        log("framePopoutCompent panle Info:" .. pop._02conten)

        if pop._05yesBtnCallFunc then
            SureBtn:SetActive(true)
            IguoreBtn:SetActive(true)
            SureBtn.transform.localPosition = Vector3.New(167, -193, 0)
            luaBeHaviour:AddClick(
                    SureBtn,
                    function()
                        HallScenPanel.PlayeBtnMusic();
                        self.yesBtnCallFunc(pop)
                    end
            )
        else
            luaBeHaviour:AddClick(
                    SureBtn,
                    function()
                        HallScenPanel.PlayeBtnMusic();
                        self.Dispose(pop)
                    end
            )
        end
        luaBeHaviour:AddClick(
                SureBtn_One,
                function()
                    HallScenPanel.PlayeBtnMusic();
                    self.Dispose(pop)
                end
        )
        luaBeHaviour:AddClick(
                IguoreBtn,
                function()
                    HallScenPanel.PlayeBtnMusic();
                    self.Dispose(pop)
                end
        )
        luaBeHaviour:AddClick(
                FreeGoldBtn,
                function()
                    HallScenPanel.PlayeBtnMusic();
                    self.Dispose(pop)
                end
        )
        luaBeHaviour:AddClick(
                RechagreBtn,
                function()
                    HallScenPanel.PlayeBtnMusic();
                    self.Dispose(pop)
                end
        )

        -- 横板和竖版的区别
        --if LaunchModule.currentSceneName == "module02" then
        --    go.transform.localRotation = Quaternion.Euler(0, 0, 0)
        --else
        --    go.transform.localRotation = Quaternion.Euler(0, 0, -90)
        --    go.transform.localPosition = Vector3.New(40, 0, 100)
        --end

        -- local textwidth = t:GetComponent("Text").preferredWidth
        -- local contwidth = t:GetComponent("RectTransform").sizeDelta.x
        -- local contheight = t:GetComponent("RectTransform").sizeDelta.y
        -- local tx = 0
        -- if textwidth > contwidth then
        --     local count = math.ceil(textwidth / contwidth)
        --     local lastw = textwidth / count
        --     if lastw + 30 < contwidth then
        --         lastw = lastw + 30
        --     end
        --     t:GetComponent("RectTransform").sizeDelta = Vector2.New(contwidth, contheight)
        --     tx = 10
        -- else
        --     t:GetComponent("RectTransform").sizeDelta =
        --         Vector2.New(t:GetComponent("Text").preferredWidth, contheight)
        -- end
        --t.transform.localPosition = Vector3.New(0, -50, 0)

        if pop._08autoClose then
            coroutine.start(
                    function()
                        coroutine.wait(pop._09autoCloseTime)
                        destroy(obj)
                    end
            )
        end
    else
        self.isTipShow = false
        if self.tipObj == nil then
            self.tipObj = HallScenPanel.Pool("TipPanel")
        end
        local background = self.tipObj.transform:Find("Image"):GetComponent("CanvasGroup");
        local desc = self.tipObj.transform:Find("Image/Text"):GetComponent("Text");
        desc.text = pop._02conten;
        desc.fontSize = 26;
        coroutine.start(function()
            local size = Vector2.New(desc.preferredWidth, desc.preferredHeight);
            desc:GetComponent("RectTransform").sizeDelta = Vector2.New(size.x, size.y);
            background:GetComponent("RectTransform").sizeDelta = Vector2.New(size.x + 40, size.y + 50);
            background.transform.localPosition = Vector3.New(0, 0, 0);
            background.alpha = 1;
            coroutine.wait(2);
            background:DOFade(0, 0.5);
            background.transform:DOLocalMove(Vector3.New(0, 200, 0), 0.5):OnComplete(function()
                self.isTipShow = true;
                destroy(self.tipObj)
                self.tipObj = nil;
            end);
        end);
    end
end
