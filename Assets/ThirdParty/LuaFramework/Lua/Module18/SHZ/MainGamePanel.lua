MainGamePanel = {}
ResultImgLuaTable = {}
local self = MainGamePanel
-- 模糊滚动
local rundotween = {}
function MainGamePanel:New()
    local t = o or {}
    setmetatable(t, self)
    self.__index = self
    self.mainPanel = nil
    return t
end

function MainGamePanel.Creat(obj)
end

function MainGamePanel.FixedUpdate()
    self.LongTimeBtn()
end

function MainGamePanel.ShowPanel()
    log("进入主界面");
    if SHZGameMangerTable[1].nowshowpanel == nil then
    else
        SHZGameMangerTable[1].nowshowpanel:SetActive(false)
    end
    if self.mainPanel == nil then
        --self.ResultAnimator = nil
        --self.FreeOrHand = false
        self.IsStop = false
        SHZGameMangerTable[1]:ChangePanelAnimator()
        -- ResManager:LoadAssetAsync('module18/game_luashzmain', 'MainPanel', self.CreatScen,true,true)
        self.CreatScen()
    else
        SHZGameMangerTable[1]:ChangePanelAnimator()
        SHZGameMangerTable[1].nowshowpanel = self.mainPanel
        self.obj:SetActive(true)
        if SHZGameMangerTable[1].byMaryCount > 0 then
            SHZGameMangerTable[1].MarySelf.ShowPanel()
            return            
        end
        self.ScenInfo()
    end

    if SHZPanel.MarySelf ~= nil and SHZPanel.ChipSelf.maryPanel ~= nil then
        SHZPanel.MarySelf.maryPanel:SetActive(false)
    end
    if SHZPanel.ChipSelf ~= nil and SHZPanel.ChipSelf.chipinPanel ~= nil then
        SHZPanel.ChipSelf.chipinPanel:SetActive(false)
    end
    --  local bgchip = SHZGameMangerTable[1].MainBg.transform:GetComponent('AudioSource');
    -- MusicManager:PlayBacksoundX(bgchip.clip, true);
    MusicManager:PlayBacksound("end", false)
end

-- 显示Box 动画
function MainGamePanel.AddBoxImg()
    BoxLuaTable = {}
    for i = 1, self.ResultAnimator.transform.childCount do
        local go = self.ResultAnimator.transform:getChild(i - 1):getChild(0).gameObject
        local newa = go:AddComponent(typeof(CsJoinLua))
        newa:SetLuaFunc(LuaFuncType.luaString, data, "SHZImgAnimation")
    end
end
-- 显示结果动画
function MainGamePanel.AddResultImg(obj)
    self.ShowResultImg = obj
    self.ShowResultImg.transform:SetParent(SHZGameMangerTable[1].SHZObj.transform)
    self.ShowResultImg.transform.localScale = Vector3.New(1, 1, 1)
    self.ShowResultImg.transform.localPosition = Vector3.New(0, 0, 0)
    self.ShowResultImg:SetActive(false)
    for i = 1, self.ResultAnimator.transform.childCount do
        local go = self.ResultAnimator.transform:GetChild(i - 1).gameObject
        local t = SHZImgAnimation:New()
        t:Creat(go)
        table.insert(ResultImgLuaTable, t)
    end
    if self.Rote.activeSelf then
        MainGamePanel.MainGameResult()
    end
end

function MainGamePanel.Update()
    if #ResultImgLuaTable == 0 then
        return
    else
        for i = 1, #ResultImgLuaTable do
            ResultImgLuaTable[i]:Update()
        end
    end
end

self.StartTimeBl = false
self.StartTimeNum = 0

-- 场景消息
function MainGamePanel.ScenInfo()
    log("重新进入场景")
    rundotween = {}
    SHZGameMangerTable[1]:NumToImage(
            self.AllXiazhuNum,
            SHZGameMangerTable[1].byLine * SHZGameMangerTable[1].dwBetList[SHZGameMangerTable[1].byBetIndex + 1],
            false
    )
    local infonum = tostring(SHZGameMangerTable[1].dwBetList[SHZGameMangerTable[1].byBetIndex + 1]) ..
            "x" .. tostring(SHZGameMangerTable[1].byLine)
    self.traYaZhuLineText:GetComponent("Text").text = infonum
    -- 15个押注图标
    if self.ResultAnimator ~= nil then
        self.ResultAnimator:SetActive(false)
        for i = 1, MH_SHZ.D_ROW_COUNT * MH_SHZ.D_COL_COUNT do
            -- error(" -- SHZGameMangerTable[1].byImg[i]======================="..SHZGameMangerTable[1].byImg[i]);
            if SHZGameMangerTable[1].byImg[i] > 8 then
                SHZGameMangerTable[1].byImg[i] = math.random(0, 8)
            end
            --   error(" -- SHZGameMangerTable[1].byImg[i]======================="..SHZGameMangerTable[1].byImg[i]);
            self.ResultImg.transform:GetChild(i - 1):GetComponent("Image").sprite = SHZGameMangerTable[1].AllImg.transform:GetChild(SHZGameMangerTable[1].byImg[i]):GetComponent("Image").sprite
            self.ResultAnimator.transform:GetChild(i - 1):GetComponent("Image").sprite = SHZGameMangerTable[1].AllImg.transform:GetChild(SHZGameMangerTable[1].byImg[i]):GetComponent("Image").sprite
        end
    end

    -- 赢分数
    self.WinShowGrid:SetActive(false)
    -- 显示条数
    for i = 1, SHZGameMangerTable[1].byLine do
        self.Line.transform:GetChild(i - 1).gameObject:SetActive(true)
    end
    -- error("SHZGameMangerTable[1].byLine======"..SHZGameMangerTable[1].byLine);
    for i = SHZGameMangerTable[1].byLine, self.Line.transform.childCount - 1 do
        self.Line.transform:GetChild(i).gameObject:SetActive(false)
    end
    -- error("SHZGameMangerTable[1].iWinScore======"..SHZGameMangerTable[1].iWinScore);
    SHZGameMangerTable[1]:NumToImage(self.WinNum, SHZGameMangerTable[1].iWinScore, false)
    --  error("SHZGameMangerTable[1].MyselfGold======"..SHZGameMangerTable[1].MyselfGold);
    SHZGameMangerTable[1]:NumToImage(self.Gold, SHZGameMangerTable[1].MyselfGold, false)
    if SHZGameMangerTable[1].Game_State == 0 or 1 then
        self.SetMainBtnShow(0)
    elseif SHZGameMangerTable[1].Game_State == 2 then
        self.WinShowGrid:SetActive(true)
        SHZGameMangerTable[1]:NumToImage(self.WinShowGrid, self.iWinScore, true)
        -- 设置按钮只显示得分和比倍
        self.SetMainBtnShow(5)
    else

        -- 不是主游戏消息
    end
    if self.FreeOrHand then
        self.StartBtnOnClick(self.StartBtn)
        return
    end
end

-- 选择押大小
function MainGamePanel.ChooseChip()
    SHZGameMangerTable[1].ChipSelf.ShowPanel()
end

-- 选择得分服务器返回结果
function MainGamePanel.ChooseGetScore(iwin)
    --  SHZGameMangerTable[1]:NumToImage(self.Gold, SHZGameMangerTable[1].MyselfGold, false);
    SHZGameMangerTable[1]:NumToImage(self.WinNum, SHZGameMangerTable[1].iWinScore, false)
    -- 播得分动画
    coroutine.start(self.PalyWinAnimator, iwin)
    if not self.FreeOrHand then
        self.ShowLineAndResult()
    end
end

-- 结算动画
function MainGamePanel.PalyWinAnimator(wingold)
    local jiannum = math.floor(wingold / 20)
    local startnum = wingold
    if SHZGameMangerTable[1].iWinScore > 0 then
        self.WinShowGrid:SetActive(true)
    end
    local stopnum = 10
    if wingold <= 10 then
        jiannum = 1
        stopnum = wingold
    end
    if self.FreeOrHand then
        if SHZSCInfo.quitstate then
            return
        end
        coroutine.wait(1.5)
        if GameNextScenName == gameScenName.HALL then
            return
        end
        self.ShowLineAndResult()
    end
    local musicchip = SHZGameMangerTable[1].Musicprefeb.transform:Find("Get"):GetComponent("AudioSource").clip
    MusicManager:PlayX(musicchip)
    if startnum - jiannum > 0 then
        self.WinShowGrid:SetActive(true)
    end
    for i = 1, stopnum do
        startnum = startnum - jiannum
        SHZGameMangerTable[1]:NumToImage(self.WinShowGrid, startnum, true)
        if toInt64(self.nowGold) < toInt64(SHZGameMangerTable[1].MyselfGold) then
            self.nowGold = self.nowGold + jiannum
            SHZGameMangerTable[1]:NumToImage(self.Gold, self.nowGold + jiannum, false)
        end
        if GameNextScenName == gameScenName.HALL then
            return
        end
        coroutine.wait(0.06)
        if GameNextScenName == gameScenName.HALL then
            return
        end
    end
    self.WinShowGrid:SetActive(false)
    SHZGameMangerTable[1].iWinScore = 0
    SHZGameMangerTable[1]:NumToImage(self.WinNum, SHZGameMangerTable[1].iWinScore, false)
    SHZGameMangerTable[1]:NumToImage(self.Gold, SHZGameMangerTable[1].MyselfGold, false)
    if self.FreeOrHand then
        if GameNextScenName == gameScenName.HALL then
            return
        end
        coroutine.wait(0.3)
        if GameNextScenName == gameScenName.HALL then
            return
        end

        self.NoRunning = true
        self.StartBtnOnClick(self.StartBtn)
        return
    end
    self.SetMainBtnShow(0)
end

-- 设置显示/隐藏的界面（需要播放过度动画，使用Dotween）

-- 判断游戏是否为全盘奖励
local fullnum = -1
function MainGamePanel.FullGame()
    fullnum = -1
    local num = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    for i = 1, #SHZGameMangerTable[1].byImg do
        if SHZGameMangerTable[1].byImg[i] == 0 then
            num[1] = num[1] + 1
        elseif SHZGameMangerTable[1].byImg[i] == 1 then
            num[2] = num[2] + 1
        elseif SHZGameMangerTable[1].byImg[i] == 2 then
            num[3] = num[3] + 1
        elseif SHZGameMangerTable[1].byImg[i] == 3 then
            num[4] = num[4] + 1
        elseif SHZGameMangerTable[1].byImg[i] == 4 then
            num[5] = num[5] + 1
        elseif SHZGameMangerTable[1].byImg[i] == 5 then
            num[6] = num[6] + 1
        elseif SHZGameMangerTable[1].byImg[i] == 6 then
            num[7] = num[7] + 1
        elseif SHZGameMangerTable[1].byImg[i] == 7 then
            num[8] = num[8] + 1
        elseif SHZGameMangerTable[1].byImg[i] == 8 then
            num[9] = num[9] + 1
        else
        end
    end
    for i = 1, #num do
        if num[i] == 15 then
            fullnum = i
        end
    end
    if fullnum < 0 then
        if num[4] + num[5] + num[6] == 15 then
            fullnum = 10
            error("全盘人物奖=======================")
        end
        if num[7] + num[8] + num[9] == 15 then
            fullnum = 11
            error("全盘武器奖=======================")
        end
    end
    return fullnum
end
-- 主游戏结果
function MainGamePanel.MainGameResult()
    error("主游戏结果============================")
    if self.ResultAnimator == nil then
        return
    end
    self.SetMainBtnShow(3)
    SHZGameMangerTable[1]:NumToImage(self.Gold, SHZGameMangerTable[1].MyselfGold, false)
    -- 15个押注图标
    self.ResultAnimator:SetActive(true)
    for i = 1, MH_SHZ.D_ROW_COUNT * MH_SHZ.D_COL_COUNT do
        self.ResultImg.transform:GetChild(i - 1):GetComponent("Image").sprite = SHZGameMangerTable[1].AllImg.transform:GetChild(SHZGameMangerTable[1].byImg[i]):GetComponent("Image").sprite
        self.ResultAnimator.transform:GetChild(i - 1):GetComponent("Image").sprite = SHZGameMangerTable[1].AllImg.transform:GetChild(SHZGameMangerTable[1].byImg[i]):GetComponent("Image").sprite
        self.ResultAnimator.transform:GetChild(i - 1).gameObject:SetActive(false)
    end
    if self.FullGame() > 0 then
        if self.fullGameobj ~= nil then
            self.WinFullImg.transform:GetComponent("Image").sprite = self.fullGameobj.transform:GetChild(fullnum - 1):GetComponent("Image").sprite
            self.WinFullImg.transform:GetComponent("Image"):SetNativeSize()
            self.WinFullImg.transform.localPosition = Vector3.New(0, 120, 0)
        else
            self.CreatFullImg(find("Full").gameObject)
        end
    end
    if not (self.FreeOrHand) then
        self.SetMainBtnShow(6)
    end
    MainGamePanel.AllRoteRunning(0)
end

-- 创建全盘奖励图标
function MainGamePanel.CreatFullImg(obj)
    self.fullGameobj = obj
    local parset = SHZGameMangerTable[1].shzcanvas.transform:Find("Canvas")
    self.fullGameobj.transform:SetParent(parset)
    self.fullGameobj.transform.localScale = Vector3.New(1, 1, 1)
    self.fullGameobj.transform.localPosition = Vector3.New(0, 0, 0)
    self.fullGameobj:SetActive(false)
    self.CreatFullNewImg(find("Full_New").gameObject)
end
-- 新全盘
function MainGamePanel.CreatFullNewImg(obj)
    self.fullGameobj_New = obj
    local parset = SHZGameMangerTable[1].shzcanvas.transform:Find("Canvas")
    self.fullGameobj_New.transform:SetParent(parset)
    self.fullGameobj_New.transform.localScale = Vector3.New(1, 1, 1)
    self.fullGameobj_New.transform.localPosition = Vector3.New(0, 0, 0)
    self.fullGameobj_New:SetActive(false)
    for i = 0, 1 do
        local prefeb = self.fullGameobj.transform:GetChild(0).gameObject
        local go = newobject(prefeb)
        local parset = self.fullGameobj.transform
        go.transform:SetParent(parset)
        go.transform.localScale = Vector3.New(1, 1, 1)
        go.transform.localPosition = Vector3.New(0, 0, 0)
        go:GetComponent("Image").sprite = self.fullGameobj_New.transform:GetChild(i):GetComponent("Image").sprite
    end
    self.WinFullImg.transform:GetComponent("Image").sprite = self.fullGameobj.transform:GetChild(fullnum - 1):GetComponent("Image").sprite
    self.WinFullImg.transform:GetComponent("Image"):SetNativeSize()
    self.WinFullImg.transform.localPosition = Vector3.New(0, 120, 0)
end
-- 主游戏所有方法
function MainGamePanel.CreatScen(obj)
    log("初始场景");
    -- self.mainPanel = obj;
    self.mainPanel = SHZGameMangerTable[1].shzcanvas.transform:Find("Canvas/Prefeb/MainPanel").gameObject
    self.obj = self.mainPanel
    SHZGameMangerTable[1].nowshowpanel = self.mainPanel
    self.MainFindComponent()
    self.CreatResultAnimatorObj(find("ResultAnimator").gameObject)

    -- 主界面所有东西创建完毕（判断是否登陆成功收到场景消息）
    -- 断线重连（winScore有两种状态一种在主界面一种是在比倍界面）
    log("=======玛丽次数===="..SHZGameMangerTable[1].byMaryCount);
    if SHZGameMangerTable[1].byMaryCount > 0 then
        SHZGameMangerTable[1].MarySelf.ShowPanel()
        return
    elseif SHZGameMangerTable[1].iWinScore > 0 then
        if SHZGameMangerTable[1].Game_State == 6 then
            SHZGameMangerTable[1].ChipSelf.ShowPanel()
            return
        end
        self.AnimatorOver()
        --        MH_SHZ={
        -- D_GAME_STATE_MARY=2,--玛丽
        -- D_GAME_STATE_TIME_OR_GET_MAIN=3,--比倍或者得分——主游戏
        -- D_GAME_STATE_TIME_OR_GET_MARY=4,--比倍或者得分——玛丽
        -- D_GAME_STATE_TIME_OR_GET_TIME=5,--比倍或者得分——比倍
        -- D_GAME_STATE_BIG_OR_SMA=6,--押大小
    end
    self.SetMainBtnShow(0)
    self.ScenInfo()
    -- 创建动画物体
    -- ResManager:LoadAssetAsync('module18/game_luashzmain_obj', 'ResultAnimator', self.CreatResultAnimatorObj,true,true)
    -- LoadAssetAsync('module18/game_luashzmain_obj', 'ResultAnimator', self.CreatResultAnimatorObj,true,true)
end
-- 滚动物体
function MainGamePanel.CreatRoteObj(obj)
    -- self.Rote = newobject(obj);
    self.Rote:SetActive(false)
    -- self.Rote.transform:SetParent(self.RoteParset.transform);
    -- self.Rote.transform.localScale = Vector3.New(1, 1, 1);
    -- self.Rote.transform.localPosition = Vector3.New(0, 0, 0);
    -- self.Rote.name = "Rote";
end
-- 创建线
function MainGamePanel.CreatLineObj(obj)
    self.Line = obj
    self.Line.transform:SetParent(self.LineParset.transform)
    self.Line.transform.localScale = Vector3.New(1, 1, 1)
    self.Line.transform.localPosition = Vector3.New(0, 0, 0)
    self.Line.name = "Line"
    self.AddResultImg(find("Img").gameObject)
end
-- 创建动画物体
function MainGamePanel.CreatResultAnimatorObj(obj)
    self.ResultAnimator = obj
    self.ResultAnimator.transform:SetParent(self.ResultAnimatorParset.transform)
    self.ResultAnimator:SetActive(false)
    self.ResultAnimator.transform.localScale = Vector3.New(1, 1, 1)
    self.ResultAnimator.transform.localPosition = Vector3.New(0, 0, 0)
    self.ResultAnimator.name = "ResultAnimator"
    for i = 0, self.ResultAnimator.transform.childCount - 1 do
        local go = self.ResultAnimator.transform:GetChild(i).gameObject
        go:SetActive(false)
        go:AddComponent(typeof(ImageAnima))
    end
    -- ImageAnima
    -- 创建Rote滚动物体
    self.AddResultImg(find("Img").gameObject)
end

--- 主游戏---
function MainGamePanel.MainFindComponent()
    local t = self.mainPanel.transform
    self.ResultImg = t:Find("ResultImg").gameObject
    self.RoteParset = t:Find("Rote").gameObject
    self.Rote = t:Find("Rote/Rote").gameObject
    self.RotePosY = {}
    for i = 1, 5 do
        local roteobj = self.Rote.transform:GetChild(i - 1)
        table.insert(self.RotePosY, roteobj.localPosition.y)
    end
    self.Rote:SetActive(false)
    self.Rote.transform.localScale = Vector3.New(1, 1, 1)
    self.ResultAnimatorParset = t:Find("AnimatorPanel").gameObject
    self.LineParset = t:Find("Line").gameObject
    self.Line = t:Find("Line/Line").gameObject
    self.Btn = t:Find("Btn").gameObject
    self.StartBtn = self.Btn.transform:Find("StartBtn").gameObject
    self.StopBtn = self.Btn.transform:Find("StopBtn").gameObject
    self.GetBtn = self.Btn.transform:Find("GetBtn").gameObject

    self.HandBtn = self.Btn.transform:Find("HandBtn").gameObject
    self.ShowAutoNum = self.Btn.transform:Find("HandBtn/Text"):GetComponent("Text")

    self.ChipInBtn = self.Btn.transform:Find("ChipBtn").gameObject
    self.YazhuJiaBtn = self.Btn.transform:Find("YazhuJiaBtn").gameObject
    self.YazhuJianBtn = self.Btn.transform:Find("YazhuJianBtn").gameObject

    self.BtnAuto = self.Btn.transform:Find("BtnAuto").gameObject
    self.BtnLong = self.Btn.transform:Find("BtnAuto/BtnLong").gameObject
    self.Btn100 = self.Btn.transform:Find("BtnAuto/Btn100").gameObject
    self.Btn50 = self.Btn.transform:Find("BtnAuto/Btn50").gameObject
    self.Btn10 = self.Btn.transform:Find("BtnAuto/Btn10").gameObject
    self.Btn.transform:Find("BtnAuto/ImageMask").gameObject:SetActive(false) --ImageMask

    self.ShowInfo = t:Find("ShowInfo").gameObject
    self.Gold = self.ShowInfo.transform:Find("Gold/Num").gameObject
    self.AllXiazhuNum = self.ShowInfo.transform:Find("AllXiazhu/Num").gameObject
    self.YaZhuLineNum = self.ShowInfo.transform:Find("YazhuLine/Num").gameObject
    self.traYaZhuLineText = self.ShowInfo.transform:Find("YazhuLine/Text")
    self.WinNum = self.ShowInfo.transform:Find("Win/Num").gameObject
    self.WinShowGrid = self.ShowInfo.transform:Find("WinShow").gameObject
    self.WinShowGrid:SetActive(false)
    self.WinShowGrid.transform.localScale = Vector3.New(1.4, 1.6, 1)
    self.WinFullImg = t:Find("WinFullImg").gameObject
    self.WinFullImg:SetActive(false)
    self.fullGameobj = nil
    -- 第一个子物体不能删除
    -- 绑定事件
    local eventTrigger = Util.AddComponent("EventTriggerListener", self.StartBtn)
    eventTrigger.onDown = self.StartBtnDown
    eventTrigger.onUp = self.StartBtnUp

    SHZGameMangerTable[1].SHZCsJoinLua:AddClick(self.StopBtn, self.StopBtnOnClick)
    SHZGameMangerTable[1].SHZCsJoinLua:AddClick(self.GetBtn, self.GetBtnOnClick)
    SHZGameMangerTable[1].SHZCsJoinLua:AddClick(self.HandBtn, self.HandBtnOnClick)
    SHZGameMangerTable[1].SHZCsJoinLua:AddClick(self.ChipInBtn, self.ChipInBtnOnClick)
    SHZGameMangerTable[1].SHZCsJoinLua:AddClick(self.YazhuJiaBtn, self.YazhuJiaBtnOnClick)
    SHZGameMangerTable[1].SHZCsJoinLua:AddClick(self.YazhuJianBtn, self.YazhuJianBtnOnClick)

    SHZGameMangerTable[1].SHZCsJoinLua:AddClick(self.BtnLong, self.BtnLongOnClick)
    SHZGameMangerTable[1].SHZCsJoinLua:AddClick(self.Btn100, self.Btn100OnClick)
    SHZGameMangerTable[1].SHZCsJoinLua:AddClick(self.Btn50, self.Btn50OnClick)
    SHZGameMangerTable[1].SHZCsJoinLua:AddClick(self.Btn10, self.Btn10OnClick)

    self.AutoNumMax = 2100000000
end

function MainGamePanel.BtnLongOnClick()
    self.AutoNumMax = 2100000000
    self.FreeStart()
end

function MainGamePanel.Btn100OnClick()
    self.AutoNumMax = 100
    self.FreeStart()
end

function MainGamePanel.Btn50OnClick()
    self.AutoNumMax = 50
    self.FreeStart()
end

function MainGamePanel.Btn10OnClick()
    self.AutoNumMax = 10
    self.FreeStart()
end

function MainGamePanel.StartBtnDown(e)
    self.realtimeSinceStartup = Time.realtimeSinceStartup
    if not self.StartBtn.activeSelf then
        return
    end
    self.StartTimeBl = true
    self.StartTimeNum = 0
end

function MainGamePanel.StartBtnUp()
    local t = Time.realtimeSinceStartup - self.realtimeSinceStartup
    if t < 1.2 then
        log("点击")
        local pos = self.BtnAuto.transform.localPosition
        if pos.x == 540 then
            self.BtnAuto.transform.localPosition = Vector3.New(2000, 2000, 0)
        else
            self.StartBtnOnClick(self.StartBtn)
        end
    end
    self.StartTimeBl = false;
    self.realtimeSinceStartup = 0
end

function MainGamePanel.LongTimeBtn()
    if not self.NoRunning then
        return;
    end
    if self.realtimeSinceStartup == nil or self.realtimeSinceStartup == 0 then
        return
    end
    if not self.StartBtn.activeSelf then
        return
    end
    if not self.StartTimeBl then
        return;
    end 
    self.StartBtn.transform:GetComponent("Button").interactable = false
    self.StartTimeNum = 0

    local t = Time.realtimeSinceStartup - self.realtimeSinceStartup
    if t > 1.2 then
        self.StartTimeBl = false
        self.StartTimeNum = 0
        if not self.StartBtn.activeSelf then
            self.realtimeSinceStartup = 0
            return
        end
        log("长按")
        self.FreeBtnOnClick()
        self.realtimeSinceStartup = 0
    end
end

-- 开始方法(需要得到结果再开始游戏)
function MainGamePanel.StartBtnOnClick(obj)
    -- if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then
    --     if GameManager.IsStopGame then
    --         return 
    --      end

        Time.timeScale = 1
        if SHZGameMangerTable[1].iWinScore > 0 then
            return
        elseif SHZGameMangerTable[1].byMaryCount > 0 then
            return
        end

        obj.transform:GetComponent("Button").interactable = false
        if not (self.NoRunning) then
            obj.transform:GetComponent("Button").interactable = true
            return
        end

        self.NoRunning = false
        if SHZSCInfo.IsMaxNum == 0 then
            -- if SHZGameMangerTable[1].byLine * SHZGameMangerTable[1].dwBetList[SHZGameMangerTable[1].byBetIndex + 1] >= SHZSCInfo.MaxChip then
            --     Network.OnException("总下注超过限制，请修改下注值");
            --     obj.transform:GetComponent("Button").interactable = true
            --     self.NoRunning = true;
            --     return;
            -- end
        end
        -- obj.transform:GetComponent('Button').interactable = false;
        self.WinShowGrid:SetActive(false)
        self.IsStop = false
        if
        toInt64(SHZGameMangerTable[1].byLine * SHZGameMangerTable[1].dwBetList[SHZGameMangerTable[1].byBetIndex + 1]) >
                toInt64(SHZGameMangerTable[1].MyselfGold)
        then
            self.SetMainBtnShow(0)
            Network.OnException("总金币小于下注数量")
            -- MainGamePanel.AllRoteRunning(0);
            -- self.StartBtn:GetComponent("Button").interactable = false;
            -- error("开始游戏,金币小于下注数量");
            return
        end

        SHZGameMangerTable[1].MyselfGold = SHZGameMangerTable[1].MyselfGold -
                (SHZGameMangerTable[1].byLine * SHZGameMangerTable[1].dwBetList[SHZGameMangerTable[1].byBetIndex + 1])
        self.MainRoteRunning(true)
        SHZSCInfo.MainSendInfo(SHZGameMangerTable[1].byLine, SHZGameMangerTable[1].byBetIndex)
        self.ShowLineAndResult()
        self.AutoNumMax = self.AutoNumMax - 1
        local s = self.AutoNumMax
        if s == 0 then
            self.FreeOrHand = false
        end
        if s > 100 then
            s = "无限"
        end
        self.ShowAutoNum.text = s

    --end
end
-- 显示隐藏结果动画和线
function MainGamePanel.ShowLineAndResult()
    for i = 0, self.Line.transform.childCount - 1 do
        self.Line.transform:GetChild(i).gameObject:SetActive(false)
    end
    if self.ResultAnimator == nil then
        return
    end
    for i = 0, self.ResultAnimator.transform.childCount - 1 do
        self.ResultAnimator.transform:GetChild(i).gameObject:SetActive(false)
    end
end

function MainGamePanel.MainRoteRunning(isrun)
    local endY = -1400
    local runtime = 0.6
    local loop = 1
    if isrun then
        self.Rote:SetActive(true)
        local musicchip = SHZGameMangerTable[1].Musicprefeb.transform:Find("MainRun"):GetComponent("AudioSource").clip
        MusicManager:PlayX(musicchip)
        for i = 1, 5 do
            local roteobj = self.Rote.transform:GetChild(i - 1)
            -- roteobj.localPosition = Vector3.New(roteobj.localPosition.x, self.RotePosY[i], 0);
            if #rundotween < 6 then
                roteobj:DOLocalMoveY(self.RotePosY[i], 0.03, false)
                local dotween = roteobj:DOLocalMoveY(self.RotePosY[i] + endY, runtime, false)
                table.insert(rundotween, dotween)
                dotween:SetEase(DG.Tweening.Ease.Linear):SetLoops(-1)
            end
            roteobj.gameObject:SetActive(true)
        end
    else
        local stopall = function()
            for i = 1, 5 do
                if self.Rote.transform:GetChild(i - 1).gameObject.activeSelf then
                    self.Rote.transform:GetChild(i - 1).gameObject:SetActive(false)
                    if SHZSCInfo.quitstate then
                        return
                    end
                    coroutine.wait(0.2)
                end
            end
            if SHZGameMangerTable[1].iWinScore > 0 then
                -- self:PlayMainWinAnimator();
                coroutine.start(self.PlayMainWinAnimator)
                return
            else
                local waitrun = function()
                    if self.FreeOrHand then
                        if SHZSCInfo.quitstate then
                            return
                        end
                        coroutine.wait(1)
                        self.SetMainBtnShow(0)
                        self.StartBtnOnClick(self.StartBtn)
                    else
                        self.SetMainBtnShow(0)
                    end
                end
                coroutine.start(waitrun)
            end
        end
        coroutine.start(stopall)
    end
end

-- 循环滚动（没有获取到数据前）

function MainGamePanel.AllRoteRunning(num)
    if num == 0 then
        local stopall = function()
            if SHZSCInfo.quitstate then
                return
            end
            coroutine.wait(0.8)
            if SHZSCInfo.quitstate then
                return
            end
            if self.IsStop then
                return
            end
            for i = 1, 5 do
                if self.Rote.transform:GetChild(i - 1).gameObject.activeSelf then
                    if SHZSCInfo.quitstate then
                        return
                    end
                    coroutine.wait(0.2)
                    if SHZSCInfo.quitstate then
                        return
                    end
                    if self.IsStop then
                        return
                    end
                    self.Rote.transform:GetChild(i - 1).gameObject:SetActive(false)
                end
            end
            if self.IsStop then
                return
            end
            if SHZGameMangerTable[1].iWinScore > 0 then
                -- self:PlayMainWinAnimator();
                coroutine.start(self.PlayMainWinAnimator)
                return
            else
                if self.IsStop then
                    return
                end
                local waitrun = function()
                    if self.FreeOrHand then
                        if self.IsStop then
                            return
                        end
                        if SHZSCInfo.quitstate then
                            return
                        end
                        coroutine.wait(1)
                        if SHZSCInfo.quitstate then
                            return
                        end
                        if self.IsStop then
                            return
                        end
                        self.SetMainBtnShow(0)
                        self.StartBtnOnClick(self.StartBtn)
                    else
                        if self.IsStop then
                            return
                        end
                        self.SetMainBtnShow(0)
                    end
                end
                if self.IsStop then
                    return
                end
                coroutine.start(waitrun)
            end
        end
        coroutine.start(stopall)
    end
end

function MainGamePanel.WaitTimeStop()
    if SHZSCInfo.quitstate then
        return
    end
    coroutine.wait(0.3)
    if not (self.FreeOrHand) then
        self.SetMainBtnShow(6)
    end
end

-- 播放主游戏赢了动画（先逐个显示线，再全部统一播放动画）
function MainGamePanel.PlayMainWinAnimator()
    coroutine.wait(0.1)
    if SHZSCInfo.quitstate then
        return
    end
    if GameNextScenName == gameScenName.HALL then
        return
    end
    if fullnum > 0 then
        self.WinFullImg:SetActive(true)
    else
        self.WinFullImg:SetActive(false)
    end
    local ShowLine = {}
    local SHowImgPos = {}
    local isplayMusic = false
    for i = 1, MH_SHZ.D_LINE_COUNT do
        for j = 1, MH_SHZ.D_COL_COUNT do
            if SHZGameMangerTable[1].byLineType[(i - 1) * MH_SHZ.D_COL_COUNT + j] == 1 then
                -- 这是要显示动画的位置（显示Box）
                -- 要显示动画的位置MH_SHZ.C_IMG_LIST[i][j]
                -- 			error("Line id = "  .. (i - 1) * MH_SHZ.D_COL_COUNT + j);
                --                error("i=======" .. i .. ",j=========" .. j);
                if i > SHZGameMangerTable[1].byLine then
                else
                    local idx = MH_SHZ.C_IMG_LIST[i][j]
                    if not (isplayMusic) then
                        isplayMusic = true
                        local musicchip = SHZGameMangerTable[1].Musicprefeb.transform:Find(
                                "WinBig/" .. SHZGameMangerTable[1].byImg[idx + 1]
                        )                                      :GetComponent("AudioSource").clip
                        MusicManager:PlayX(musicchip)
                    end
                    self.ResultAnimator.transform:GetChild(idx).gameObject:SetActive(true)
                    ResultImgLuaTable[idx + 1]:SetImgScript(
                            self.ShowResultImg.transform:GetChild(SHZGameMangerTable[1].byImg[idx + 1]),
                            self.ResultImg.transform:GetChild(idx):GetComponent("Image").sprite
                    )
                    local lineobj = self.Line.transform:GetChild(i - 1).gameObject
                    lineobj:SetActive(true)
                    if ShowLine[#ShowLine] == i then
                    else
                        table.insert(ShowLine, lineobj)
                    end
                end
            end
        end
    end

    for i = 1, 10 do
        coroutine.wait(0.15)
        if SHZSCInfo.quitstate then
            return
        end
        if not self.FreeOrHand then
            if SHZGameMangerTable[1].byMaryCount == 0 and self.IsStop == false then
                if SHZGameMangerTable[1].iWinScore == 0 then
                    return
                end
            end
        end
    end
    if GameNextScenName == gameScenName.HALL then
        return
    end
    if SHZGameMangerTable[1].byMaryCount > 0 then
        if GameNextScenName == gameScenName.HALL then
            return
        end
        -- coroutine.wait(0.5);
        coroutine.wait(0)
        if SHZSCInfo.quitstate then
            return
        end
        if GameNextScenName == gameScenName.HALL then
            return
        end

        SHZGameMangerTable[1].MarySelf.ShowPanel()

        return
    end
    self.SetMainBtnShow(5)
    self.ShowLineAni = true
    self.AnimatorOver()
end
-- 闪动Line
-- function MainGamePanel.AnimatorLine(ShowLine)
--    for j = 1, 10 do
--    self.Line:SetActive(true);
--    coroutine.wait(1);
--    self.Line:SetActive(false);
--    coroutine.wait(1);
--    self.Line:SetActive(true);
--    coroutine.wait(1);
--    self.Line:SetActive(false);
--    end
-- end

-- 播放动画完成
function MainGamePanel.AnimatorOver()
    --  coroutine.start(self.AnimatorLine,ShowLine)
    if SHZGameMangerTable[1].iWinScore > 0 then
        SHZGameMangerTable[1]:NumToImage(self.WinNum, SHZGameMangerTable[1].iWinScore, false)
        -- self.WinShowGrid.transform.localPosition = Vector3.New(0, 0, 0);
        self.WinShowGrid:SetActive(true)
        SHZGameMangerTable[1]:NumToImage(self.WinShowGrid, SHZGameMangerTable[1].iWinScore, true)
        -- 判断是否为自动模式
        -- error("自动得分");
        if self.FreeOrHand then
            self.GetBtnOnClick(self.GetBtn)
            return
            -- self.StartBtnOnClick(self.StartBtn)
        end
    end
    if SHZGameMangerTable[1].byMaryCount == 0 then
        self.SetMainBtnShow(5)
    end
    log("播放动画结束")
    Time.timeScale = 1
end

-- 全停方法（需要转动0.5秒才能全停）
function MainGamePanel.StopBtnOnClick(obj)
    Time.timeScale = 3
    obj.transform:GetComponent("Button").interactable = false
    if self.IsStop then
        obj.transform:GetComponent("Button").interactable = true
        return
    end
    self.IsStop = true
    self.MainRoteRunning(false)
    obj.transform:GetComponent("Button").interactable = true
    --    if SHZGameMangerTable[1].iWinScore > 0 then

    --        return;
    --    elseif SHZGameMangerTable[1].byMaryCount > 0 then

    --        return;
    --    else
    --        self.SetMainBtnShow(0);
    --    end
end

-- 得分方法
function MainGamePanel.GetBtnOnClick(obj)
    self.SetMainBtnShow(4)
    obj.transform:GetComponent("Button").interactable = false
    self.ShowLineAni = false
    self.nowGold = SHZGameMangerTable[1].MyselfGold
    SHZSCInfo.ChipOrGetSendInfo(0)
end

-- 手动方法
function MainGamePanel.HandBtnOnClick(obj)
    --if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then

        obj.transform:GetComponent("Button").interactable = false
        self.FreeOrHand = false
        self.SetMainBtnShow(2)
        --self.BtnAuto:SetActive(false);
        self.BtnAuto.transform.localPosition = Vector3.New(2000, 2000, 0)
        obj.transform:GetComponent("Button").interactable = true

   -- end
end

-- 自动方法
function MainGamePanel.FreeBtnOnClick()
    --if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then

        self.BtnAuto.transform.localPosition = Vector3.New(540, 176, 0)
        self.HandBtn:SetActive(true)

    --end
end

function MainGamePanel.FreeStart()
    self.BtnAuto.transform.localPosition = Vector3.New(2000, 2000, 0)
    self.FreeOrHand = true
    self.SetMainBtnShow(1)
    --if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then

        -- 如果是需要结算（先发送结算）
        if SHZGameMangerTable[1].byMaryCount > 0 then
            return
        elseif SHZGameMangerTable[1].iWinScore > 0 then
            return
        end
        -- 判断游戏是否为运行状态
        if self.FreeOrHand and self.NoRunning then
            self.StartBtnOnClick(self.StartBtn)
        end

    --end
end

-- 选择比倍方法
function MainGamePanel.ChipInBtnOnClick(obj)
   -- if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then
        -- 界面出现遮罩,不能点击然后再判断家宅界面
        -- 给服务器发送选择比倍
        obj.transform:GetComponent("Button").interactable = false
        SHZSCInfo.ChipOrGetSendInfo(1)
        obj.transform:GetComponent("Button").interactable = true

   -- end
end

-- 押注加方法
function MainGamePanel.YazhuJiaBtnOnClick(obj)
    obj.transform:GetComponent("Button").interactable = false
    SHZGameMangerTable[1].byBetIndex = SHZGameMangerTable[1].byBetIndex + 1
    if SHZGameMangerTable[1].byBetIndex == 5 then
        SHZGameMangerTable[1].byBetIndex = 0
    end
    -- SHZGameMangerTable[1]:NumToImage(self.XiazhuNum, SHZGameMangerTable[1].dwBetList[(SHZGameMangerTable[1].byBetIndex + 1)], false)
    SHZGameMangerTable[1]:NumToImage(
            self.AllXiazhuNum,
            SHZGameMangerTable[1].byLine * SHZGameMangerTable[1].dwBetList[(SHZGameMangerTable[1].byBetIndex + 1)],
            false
    )
    local infonum = tostring(SHZGameMangerTable[1].dwBetList[SHZGameMangerTable[1].byBetIndex + 1]) ..
            "x" .. tostring(SHZGameMangerTable[1].byLine)
    -- SHZGameMangerTable[1]:NumToImage(self.YaZhuLineNum, infonum, false);
    self.traYaZhuLineText:GetComponent("Text").text = infonum
    obj.transform:GetComponent("Button").interactable = true
    if
    toInt64(SHZGameMangerTable[1].byLine * SHZGameMangerTable[1].dwBetList[SHZGameMangerTable[1].byBetIndex + 1]) >
            toInt64(SHZGameMangerTable[1].MyselfGold)
    then
        self.StartBtn:GetComponent("Button").interactable = false
    else
        self.StartBtn:GetComponent("Button").interactable = true
        Time.timeScale = 1
    end
end

-- 押注减方法
function MainGamePanel.YazhuJianBtnOnClick(obj)
    obj.transform:GetComponent("Button").interactable = false
    SHZGameMangerTable[1].byBetIndex = SHZGameMangerTable[1].byBetIndex - 1
    if SHZGameMangerTable[1].byBetIndex < 0 then
        SHZGameMangerTable[1].byBetIndex = 4
    end
    --  SHZGameMangerTable[1]:NumToImage(self.XiazhuNum, SHZGameMangerTable[1].dwBetList[(SHZGameMangerTable[1].byBetIndex + 1)], false)
    SHZGameMangerTable[1]:NumToImage(
            self.AllXiazhuNum,
            SHZGameMangerTable[1].byLine * SHZGameMangerTable[1].dwBetList[(SHZGameMangerTable[1].byBetIndex + 1)],
            false
    )
    local infonum = tostring(SHZGameMangerTable[1].dwBetList[SHZGameMangerTable[1].byBetIndex + 1]) ..
            "x" .. tostring(SHZGameMangerTable[1].byLine)
    -- SHZGameMangerTable[1]:NumToImage(self.YaZhuLineNum, infonum, false);
    self.traYaZhuLineText:GetComponent("Text").text = infonum
    obj.transform:GetComponent("Button").interactable = true
    if
    toInt64(SHZGameMangerTable[1].byLine * SHZGameMangerTable[1].dwBetList[SHZGameMangerTable[1].byBetIndex + 1]) >
            toInt64(SHZGameMangerTable[1].MyselfGold)
    then
        self.StartBtn:GetComponent("Button").interactable = false
    else
        self.StartBtn:GetComponent("Button").interactable = true
        Time.timeScale = 1
    end
end
-- 显示隐藏Button
function MainGamePanel.SetMainBtnShow(id)
    if id == 0 then
        -- 初始化状态
        if SHZGameMangerTable[1].iWinScore > 0 then
            return
        elseif SHZGameMangerTable[1].byMaryCount > 0 then
            return
        end
        self.WinFullImg:SetActive(false)
        SHZGameMangerTable[1].Running = false
        self.NoRunning = true
        if self.FreeOrHand then
            -- 自动
            return
        end
        self.StartBtn:SetActive(true)
        self.StartBtn:GetComponent("Button").interactable = true
        Time.timeScale = 1
        self.StopBtn:SetActive(false)
        self.GetBtn:SetActive(false)
        self.HandBtn:SetActive(false)
        self.ChipInBtn:SetActive(false)
        self.HandBtn:SetActive(false)
        self.ChipInBtn.transform.localPosition = Vector3.New(568, -200, 0)
    elseif id == 1 then
        -- 自动模式
        self.StartBtn:SetActive(false)
        self.StopBtn:SetActive(false)
        self.GetBtn:SetActive(false)
        self.HandBtn:SetActive(false)
        self.ChipInBtn:SetActive(false)
        self.HandBtn:SetActive(true)
        self.ChipInBtn.transform.localPosition = Vector3.New(568, -200, 0)
    elseif id == 2 then
        -- 手动模式
        self.StartBtn:SetActive(true)
        self.StartBtn:GetComponent("Button").interactable = false
        self.StopBtn:SetActive(false)
        self.GetBtn:SetActive(false)
        self.HandBtn:SetActive(false)
        self.ChipInBtn:SetActive(false)
        self.HandBtn:SetActive(false)
        self.ChipInBtn.transform.localPosition = Vector3.New(568, -200, 0)
    elseif id == 3 then
        -- 运行中
        self.WinFullImg:SetActive(false)
        SHZGameMangerTable[1].Running = true
        self.NoRunning = false
        if self.FreeOrHand then
            -- 自动
            return
        end
        -- 手动
        self.StartBtn:SetActive(false)
        self.StopBtn:SetActive(true)
        self.GetBtn:SetActive(false)
        self.HandBtn:SetActive(false)
        self.ChipInBtn:SetActive(false)
        self.HandBtn:SetActive(false)
        self.ChipInBtn.transform.localPosition = Vector3.New(568, -200, 0)
    elseif id == 4 then
        -- 结算状态
        self.WinFullImg:SetActive(false)
        if self.FreeOrHand then
            -- 自动
            return
        end
        self.StartBtn:SetActive(false)
        self.StopBtn:SetActive(false)
        self.GetBtn:SetActive(true)
        self.GetBtn:GetComponent("Button").interactable = false
        self.HandBtn:SetActive(false)
        self.ChipInBtn:SetActive(false)
        self.HandBtn:SetActive(false)
        self.ChipInBtn.transform.localPosition = Vector3.New(568, -200, 0)
        self.BtnAuto.transform.localPosition = Vector3.New(2000, 2000, 0)
    elseif id == 5 then
        -- 得分比倍状态
        if self.WinShowGrid.activeSelf then
            return
        end
        if self.ChipInBtn.activeSelf then
            return
        end
        if SHZGameMangerTable[1].iWinScore == 0 then
            return
        end
        if SHZGameMangerTable[1].byMaryCount > 0 then
            return
        end
        SHZGameMangerTable[1].Running = true
        self.NoRunning = true
        if self.FreeOrHand then
            -- 自动
            return
        end
        self.StartBtn:SetActive(false)
        self.StopBtn:SetActive(false)
        self.GetBtn:SetActive(true)
        self.GetBtn:GetComponent("Button").interactable = true
        Time.timeScale = 1
        self.HandBtn:SetActive(false)
        self.ChipInBtn:SetActive(true)
        self.HandBtn:SetActive(false)
        self.ChipInBtn.transform.localPosition = Vector3.New(568, -200, 0)
        self.ChipInBtn.transform:DOLocalMoveY(115, 0.5, false)
        self.BtnAuto.transform.localPosition = Vector3.New(2000, 2000, 0)
    elseif id == 6 then
        -- 显示全停
        if self.FreeOrHand then
            -- 自动
            return
        end
        self.StartBtn:SetActive(false)
        self.StopBtn:SetActive(true)
        self.GetBtn:SetActive(false)
        self.HandBtn:SetActive(false)
        self.ChipInBtn:SetActive(false)
        self.HandBtn:SetActive(false)
        self.ChipInBtn.transform.localPosition = Vector3.New(568, -200, 0)
    end
end
