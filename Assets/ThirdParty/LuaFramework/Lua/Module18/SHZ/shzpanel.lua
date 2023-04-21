--Lua水浒传入口，MH消息： 70行游戏服务器登陆(发送1-3) 107行准备（发送101-1）  101-101 场景信息
require "Module18/SHZ/SHZSCInfo"
require "Module18/SHZ/SHZImgAnimation"
require "Module18/SHZ/MainGamePanel"
require "Module18/SHZ/ChipGamePanel"
require "Module18/SHZ/MaryGamePanel"

SHZPanel = {}

function SHZPanel:Update()
end

function SHZPanel:FixedUpdate()
    MainGamePanel.FixedUpdate()
end
function SHZPanel:OnDestroy()
    Event.RemoveListener(HallScenPanel.ReconnectEvent, self.Reconnect);
end

function SHZPanel.Reconnect()
    log("重连成功")
    SHZSCInfo.gamelogon();
    coroutine.start(SHZPanel._StartGame)
end

function SHZPanel._StartGame()
    coroutine.wait(1.2)
    logYellow("MainGamePanel.FreeOrHand"..tostring(MainGamePanel.FreeOrHand))
    if MainGamePanel.FreeOrHand then
        MainGamePanel.StartBtnOnClick(MainGamePanel.StartBtn)    
    end
end

function SHZPanel:Begin(obj)
    Screen.orientation = UnityEngine.ScreenOrientation.Landscape;
    Screen.autorotateToLandscapeLeft = true;
    Screen.autorotateToLandscapeRight = true;
    Screen.autorotateToPortrait = false;
    Screen.autorotateToPortraitUpsideDown = false;
    Event.AddListener(HallScenPanel.ReconnectEvent, self.Reconnect);
    logError(" SHZPanel:Begin" .. obj.name)
    obj.transform:Find("Game_SHZ/Camera"):GetComponent('Camera').clearFlags = UnityEngine.CameraClearFlags.SolidColor
    obj.transform:Find("Game_SHZ/Camera").localRotation = Quaternion.identity;
    obj.transform:Find("Game_SHZ/Canvas"):GetComponent("CanvasScaler").referenceResolution = Vector2.New(1334, 750);
    obj.transform:Find("Game_SHZ/Canvas/Image").localRotation = Quaternion.identity;
    obj.transform:Find("Game_SHZ/Canvas/Prefeb"):GetComponent("RectTransform").sizeDelta = Vector2.New(1334, 750);
    obj.transform:Find("Game_SHZ/Canvas/Prefeb/MainPanel").localRotation = Quaternion.identity;
	obj.transform:Find("Game_SHZ/Camera"):GetComponent('Camera').clearFlags=UnityEngine.CameraClearFlags.SolidColor

    
    SHZGameMangerTable = {}
    SHZSCInfo.ClearInfo()
    table.insert(SHZGameMangerTable, self)
    SHZPanel = self
    self.changepanel = nil
    self.Running = false
    self.nowshowpanel = nil
    self.PlayerGold = 0

    -- 玩家金币
    self.dwBetList = {}
    -- 主游戏下注列表
    self.Game_State = 0
    -- 当前游戏状态
    self.byLine = 9
    -- 压线条数
    self.byBetIndex = 0
    -- 押注索引
    self.byImg = {}
    -- 主游戏15个位置图标
    self.byMaryCount = 0
    -- 玛丽游戏次数
    self.byPrizeImg = {}
    -- 玛丽4个位置图标
    self.byStopIndex = 0
    -- 玛丽游戏停止索引
    self.iWinScore = 0
    -- 玩家当局赢得钱
    self.byHisBigSma = {}
    -- 比倍历史记录
    self.byLineType = {}
    -- 主游戏每个位置是否播放动画
    self.point1 = 0
    -- 第一点数
    self.point2 = 0
    -- 第二个点数
    self.SHZObj = nil
    -- 画布obj
    self.SHZCsJoinLua = nil
    self.HelpPanel = nil
    -- csjoinlua
    -- 第一次主界面创建完毕（可以是主游戏、可以是比大小，可以是玛丽界面）
    IsFirstCreatPanel = false
    self.MyselfGold = 0
    self.IsFirstCreatPanel = false
    self.FreeOrHand = false
    self.MainSelf = MainGamePanel:New()
    self.ChipSelf = ChipGamePanel:New()
    self.MarySelf = MaryGamePanel:New()
    SHZSCInfo.ScenInfoTable = {}
    MessgeEventRegister.Game_Messge_Un()
    SHZSCInfo.gamelogon()

    -- 清理数据方法
    self.SHZObj = obj
    self.SHZCsJoinLua = self.SHZObj.transform:GetComponent("LuaBehaviour")
    self.CsJoinLua = self.SHZCsJoinLua
    --    --加载画布
    self.shzcanvas = find("Game_SHZ")

    self.panelParent = self.SHZObj
    self.shzcanvas.transform:SetParent(self.panelParent.transform)
    self.shzcanvas.transform.localScale = Vector3.New(1, 1, 1)
    self.shzcanvas.transform.localPosition = Vector3.New(0, 0, 0)
    local objcanvas = self.shzcanvas.transform:Find("Canvas"):GetComponent("CanvasScaler")
    SetCanvasScalersMatch(objcanvas,1)


    --local bg = GameObject.New("BgImage"):AddComponent(typeof(UnityEngine.UI.Image));
    --bg.transform:SetParent(objcanvas.transform);
    --bg.transform:SetAsFirstSibling();
    --bg.transform.localPosition = Vector3(0, 0, 0);
    --bg.transform.localRotation = Quaternion.identity;
    --bg.transform.localScale = Vector3(1, 1, 1);
    --bg.sprite = HallScenPanel.moduleBg:Find("module17-20/module18"):GetComponent("Image").sprite;
    --bg:GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);

    self.shzcanvas.transform:Find("Canvas/Image").gameObject:SetActive(false)
    --BG
    --self.shzcanvas.transform:Find("Canvas/Prefeb/MainPanel/Bg/left"):GetComponent("Image").sprite=HallScenPanel.moduleBg:Find("module17-20/module18/frame"):GetComponent("Image").sprite;
    --self.shzcanvas.transform:Find("Canvas/Prefeb/MainPanel/Bg/Right"):GetComponent("Image").sprite=HallScenPanel.moduleBg:Find("module17-20/module18/frame"):GetComponent("Image").sprite;
     local RoteTran=self.shzcanvas.transform:Find("Canvas/Prefeb/MainPanel/Rote");
     local newprefeb=newobject(self.shzcanvas.transform:Find("Canvas/Prefeb").gameObject) 
     newprefeb.transform:SetParent(self.shzcanvas.transform:Find("Canvas/Prefeb/MainPanel"));
     newprefeb.transform:SetSiblingIndex(1);
     destroy(newprefeb.transform:GetChild(1).gameObject);     
     destroy(newprefeb.transform:GetChild(0).gameObject);
     newprefeb:GetComponent("RectTransform").sizeDelta=Vector2.New(1125,490);
     newprefeb.transform.localPosition=Vector3.New(0,0,0)
     newprefeb.transform.localScale=Vector3.New(1,1,1)
     newprefeb.transform.localRotation = Quaternion.Euler(0, 0, 0);
     RoteTran:GetChild(0):SetParent(newprefeb.transform);
     newprefeb.gameObject.name="Rote"
     destroy(RoteTran.gameObject);
     --bibei
     self.shzcanvas.transform:Find("Canvas/Prefeb"):GetComponent("RectTransform").sizeDelta=Vector2.New(2000,750);
     local chipBG=self.shzcanvas.transform.parent:Find("ChipInPanel/Bg"):GetComponent("Image");
    --chipBG.sprite=HallScenPanel.moduleBg:Find("module17-20/module18/TIME"):GetComponent("Image").sprite;
    --chipBG:GetComponent("RectTransform").sizeDelta=Vector2.New(chipBG.sprite.textureRect.width,chipBG.sprite.textureRect.height);
    --xiaomali
    --self.shzcanvas.transform.parent:Find("MaryPanel/Bg/Left"):GetComponent("Image").sprite=HallScenPanel.moduleBg:Find("module17-20/module18/mariobgmariobg-1"):GetComponent("Image").sprite;
    --self.shzcanvas.transform.parent:Find("MaryPanel/Bg/Right"):GetComponent("Image").sprite=HallScenPanel.moduleBg:Find("module17-20/module18/mariobgmariobg-2"):GetComponent("Image").sprite;


    self.shzcanvas.name = "Game_SHZ"
    self:FindComponent()

    self.Musicprefeb = find("SHZMusic")
    local panelParent = self.shzcanvas.transform:Find("Canvas/GuiCamera")
    panelParent:GetComponent("RectTransform").anchorMax = Vector2.New(1,1);
    panelParent:GetComponent("RectTransform").anchorMin = Vector2.New(0,0);
    panelParent:GetComponent("RectTransform").offsetMax = Vector2.New(0,0);
    panelParent:GetComponent("RectTransform").offsetMin = Vector2.New(0,0);
    
    self.Musicprefeb.transform:SetParent(panelParent)
    self.ChipBg = self.Musicprefeb.transform:Find("BigOrSmaBg")
    self.MainBg = self.Musicprefeb.transform:Find("MainBg")
    self.ChipBg.transform:SetParent(self.panelParent.transform)
    self.MainBg.transform:SetParent(self.panelParent.transform)
    MusicManager:PlayBacksound("end", false)

    self.changepanel = find("ChangePanel")
    panelParent.localRotation=Quaternion.identity;
    self.changepanel.transform:SetParent(panelParent)
    self.changepanel.transform.localScale = Vector3.New(1, 1, 1)
    self.changepanel.transform.localPosition = Vector3.New(0, 0, 0)
    self.changepanel.transform.localRotation = Quaternion.identity;
    self.changepanel.name = "ChangePanel"
    self.changepanel:SetActive(false)
    GameManager.PanelRister(self.SHZObj)
    GameManager.PanelInitSucceed(self.SHZObj)
    GameManager.GameScenIntEnd()
    SHZSCInfo.PlayerPrepare()
    --self:ChangePanelAnimator();
end

-- 切换场景
function SHZPanel:ChangePanelAnimator()
    if self.changepanel == nil then
        return
    end
    self.changepanel:SetActive(true)

    local leftdotween = self.changepanel.transform:Find("Left"):DOLocalMoveX(-660, 0.5, false)
    leftdotween:SetEase(DG.Tweening.Ease.Linear)
    local rightdotween = self.changepanel.transform:Find("Right"):DOLocalMoveX(660, 0.5, false)
    rightdotween:SetEase(DG.Tweening.Ease.Linear)
    log("leftdotween:Rewind  STAT")
    leftdotween:OnComplete(
    function()
        leftdotween:Rewind(true)
        log("leftdotween:Rewind")
    end
    )
    rightdotween:OnComplete(
    function()
        rightdotween:Rewind(true)
        self.changepanel:SetActive(false)
        log("leftdotween:Rewind3")
    end
    )
end

--图片数字父节点（金币，win分数，9个游戏图标）
function SHZPanel:FindComponent()
    self.NumImg = self.shzcanvas.transform:Find("Canvas/Num").gameObject
    self.NumImg:SetActive(false)
    self.WinNumImg = self.shzcanvas.transform:Find("Canvas/WinNum").gameObject
    self.WinNumImg:SetActive(false)
    self.AllImg = self.shzcanvas.transform:Find("Canvas/AllImg").gameObject
    self.AllImg:SetActive(false)
end

-- 场景消息
function SHZPanel:ScenInfo()
    -- 初始化场景数据
    self.dwBetList = SHZSCInfo.ScenInfoTable[1]
    self.Game_State = SHZSCInfo.ScenInfoTable[2]
    -- 压线条数
    self.byLine = SHZSCInfo.ScenInfoTable[3]
    -- 15个押注图标
    self.byBetIndex = SHZSCInfo.ScenInfoTable[4]

    self.byImg = SHZSCInfo.ScenInfoTable[5]
    self.byMaryCount = SHZSCInfo.ScenInfoTable[6]
    -- 玛丽游戏4个图标
    self.byPrizeImg = SHZSCInfo.ScenInfoTable[7]
    -- 停止索引
    self.byStopIndex = SHZSCInfo.ScenInfoTable[8]
    -- 赢分数
    self.iWinScore = SHZSCInfo.ScenInfoTable[9]
    -- 比倍历史点数
    self.byHisBigSma = SHZSCInfo.ScenInfoTable[10]
    error(tostring(self.changepanel == nil))
    --    --加载切换场景
    if self.changepanel == nil then
        -- LoadAssetCacheAsync('module18/game_luashzmain', 'ChangePanel', handler(self, self.CreatChangePanel))
        self:CreatChangePanel(find("ChangePanel").gameObject)
    end
    error("开始加载创建场景")
    log("=========="..self.Game_State);
    if self.Game_State == 0 or 1 or 3 then
        -- 加载主游戏场景
        self.MainSelf.ShowPanel()
    elseif self.Game_State == 2 or 4 then
        -- 加载玛丽游戏场景
        self.MarySelf.ShowPanel()
    elseif self.Game_State == 5 or 6 then
        -- 加载比倍游戏场景
        self.ChipSelf.ShowPanel()
    end
end

-- 游戏消息  100-0（主游戏结果）  100-1（玛丽游戏结果）100-2（进入比大小界面）100-3（比大小结果）100-4（选择得分）
function SHZPanel:GameInfo(wMain, wSubID, buffer, wSize)
    local id = string.gsub(wSubID, wMain, "")
    id = tonumber(id)
    --   error("=============id================" .. id);
    if id == MH_SHZ.SUB_SC_MAIN_RESULT then
        -- 主游戏结果
        local byImg = {}
        for i = 1, MH_SHZ.D_ROW_COUNT * MH_SHZ.D_COL_COUNT do
            table.insert(byImg, buffer:ReadInt32())
            --error("图片："..byImg[i])
        end
        self.byImg = byImg
        local byLineType = {}
        for i = 1, MH_SHZ.D_LINE_COUNT * MH_SHZ.D_COL_COUNT do
            table.insert(byLineType, buffer:ReadByte())
        end
        self.byLineType = byLineType
        --logErrorTable(self.byLineType)
        self.byMaryCount = buffer:ReadByte()
        error("玛丽次数================*****************************************==" .. self.byMaryCount)
        -- for i = 1, 3 do
        -- 补位
        --local bHelp = buffer:ReadByte();
        --error("补位："..bHelp)
        -- end
        self.iWinScore = buffer:ReadInt32()
        --error("赢的分："..self.iWinScore)
        self.MainSelf.MainGameResult()
    elseif id == MH_SHZ.SUB_SC_MARY_RESULT then
        -- 玛丽游戏结果
        local byPrizeImg = {}
        for i = 1, MH_SHZ.D_MARY_PRIZE_COUNT do
            table.insert(byPrizeImg, buffer:ReadByte())
            error("玛丽结果======" .. byPrizeImg[#byPrizeImg])
        end
        self.byPrizeImg = byPrizeImg
        self.byMaryCount = buffer:ReadByte()
        error("玛丽次数=" .. self.byMaryCount)
        --停止索引，需要自己计算
        self.byStopIndex = buffer:ReadByte()
        error("停止索引=" .. self.byStopIndex)
        if self.byStopIndex >= 24 then
            self.byStopIndex = 0
        end

        --[[        for i = 1, 2 do
            -- 补位
            local bHelp = buffer:ReadByte();
        end--]]
        self.iWinScore = buffer:ReadInt32()
        error("赢的分=" .. self.iWinScore)
        self.MarySelf.MaryGameResult()
    elseif id == MH_SHZ.SUB_SC_BIG_OR_SMA then
        -- 选择押大小（用于跳转押大小界面）
        self.ChipSelf.ShowPanel()
    elseif id == MH_SHZ.SUB_SC_BIG_OR_SMA_RESULT then
        -- 押大小结果
        self.point1 = buffer:ReadByte()
        self.point2 = buffer:ReadByte()
        --[[        for i = 1, 2 do
            -- 补位
            local bHelp = buffer:ReadByte();
        end--]]
        self.iWinScore = buffer:ReadInt32()
        --logError("比倍赢的分"..self.iWinScore)
        --error("押大小结果调用==============="..self.point1..",,,,,,,,,,,,,,self.point2==================="..self.point2);
        self.ChipSelf.ChipGameResult()
    elseif id == MH_SHZ.SUB_SC_GET then
        --    error(" 选择得分（选择得分，金币变化同时播金币动画）====="..self.nowshowpanel.name);
        SHZGameMangerTable[1].Game_State = 0
        self.iWinScore = buffer:ReadInt32()
        if self.nowshowpanel.name == "MainPanel" then
            self.MainSelf.ChooseGetScore(self.iWinScore)
        elseif self.nowshowpanel.name == "MaryPanel" then
            self.MarySelf.ChooseGetScore(self.iWinScore)
        elseif self.nowshowpanel.name == "ChipInPanel" then
            self.ChipSelf.ChooseGetScore(self.iWinScore)
        end
    else
        -- 未知命令（最好把用户弹出界面）
    end
    SHZSCInfo.isreqStart=true
end

-- 数字转换成图片
function SHZPanel:NumToImage(father, num, iswin)
    local numstr = tostring(num)
    local startchange = 0
    local creatImg = self.NumImg
    if iswin then
        startchange = 1
        creatImg = self.WinNumImg
    else
        startchange = 0
    end
    if father.transform.childCount - startchange > string.len(numstr) then
        for j = string.len(numstr) + startchange, father.transform.childCount - 1 do
            father.transform:GetChild(j).gameObject:SetActive(false)
        end
    end
    for i = 1, string.len(numstr) do
        local imgnum = string.sub(numstr, i, i)
        if tonumber(imgnum) == nil then
            imgnum = creatImg.transform.childCount - 1
        end
        if father.transform.childCount - startchange < i then
            local go = newobject(creatImg.transform:GetChild(imgnum).gameObject)
            go.transform:SetParent(father.transform)
            go.transform.localScale = Vector3.New(1, 1, 1)
            go.transform.localPosition = Vector3.New(0, 0, 0)
            go.name = imgnum
        else
            father.transform:GetChild(i - 1 + startchange).gameObject.name = imgnum
            father.transform:GetChild(i - 1 + startchange).gameObject:GetComponent("Image").sprite =            creatImg.transform:GetChild(imgnum).gameObject:GetComponent("Image").sprite
            father.transform:GetChild(i - 1 + startchange).gameObject:SetActive(true)
        end
    end
end

function SHZPanel:OnClickHelp()
    if self.HelpPanel == nil then
        -- LoadAssetCacheAsync('module18/game_luashzhelp', 'Help', handler(self, self.CreateHelpPanel))
        self:CreateHelpPanel(find("Help").gameObject)
    else
        self.HelpPanel:SetActive(true)
    end
end

function SHZPanel:CreateHelpPanel(obj)
    --self.HelpPanel = newobject(obj);--底层创建
    self.HelpPanel = obj
    local panelParent = self.shzcanvas.transform:Find("Canvas/GuiCamera")
    self.HelpPanel.transform:SetParent(panelParent)
    self.HelpPanel.transform.localScale = Vector3.New(1, 1, 1)
    self.HelpPanel.transform.localPosition = Vector3.New(0, 0, 0)
    self.HelpPanel.name = "HelpPanel"

    local go=self.HelpPanel.transform:Find("Image")
    go:GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);

    self.helpMask = self.HelpPanel.transform:Find("Mask").gameObject
    self.helpdragImage = self.HelpPanel.transform:Find("Mask/MainInfo").gameObject
    self.helpCloseBtn = self.HelpPanel.transform:Find("Close").gameObject
    self.LeftBtn = self.HelpPanel.transform:Find("Left").gameObject
    self.RightBtn = self.HelpPanel.transform:Find("Right").gameObject
    self.helpMaskID = 1
    self.helpdragImage.transform:Find(self.helpMaskID).gameObject:SetActive(true)
    self.helpdragImage.transform:Find("2").gameObject:SetActive(false)
    self.helpdragImage.transform:Find("3").gameObject:SetActive(false)
    self.helpdragImage.transform:Find("4").gameObject:SetActive(false)
    local helpclose = function()
        self.HelpPanel:SetActive(false)
    end
    local helpdrag = function()
        if self.helpdragImage.transform.localPosition.x > 0 then
            self.helpdragImage.transform:Find(self.helpMaskID).gameObject:SetActive(false)
            self.helpMaskID = self.helpMaskID - 1
            if self.helpMaskID <= 0 then
                self.helpMaskID = 4
            end
            self.helpdragImage.transform:Find(self.helpMaskID).gameObject:SetActive(true)
        else
            self.helpdragImage.transform:Find(self.helpMaskID).gameObject:SetActive(false)
            self.helpMaskID = self.helpMaskID + 1
            if self.helpMaskID > 4 then
                self.helpMaskID = 1
            end
            self.helpdragImage.transform:Find(self.helpMaskID).gameObject:SetActive(true)
        end
    end

    local helpleft = function()
        self.helpdragImage.transform:Find(self.helpMaskID).gameObject:SetActive(false)
        self.helpMaskID = self.helpMaskID - 1
        if self.helpMaskID <= 0 then
            self.helpMaskID = 4
        end
        self.helpdragImage.transform:Find(self.helpMaskID).gameObject:SetActive(true)
    end
    local helpRight = function()
        self.helpdragImage.transform:Find(self.helpMaskID).gameObject:SetActive(false)
        self.helpMaskID = self.helpMaskID + 1
        if self.helpMaskID > 4 then
            self.helpMaskID = 1
        end
        self.helpdragImage.transform:Find(self.helpMaskID).gameObject:SetActive(true)
    end
    self.SHZCsJoinLua:AddClick(self.helpCloseBtn, helpclose)
    self.SHZCsJoinLua:AddClick(self.LeftBtn, helpleft)
    self.SHZCsJoinLua:AddClick(self.RightBtn, helpRight)
    -- 添加滑动触发事件
    self.R_scroolRect_listerner = Util.AddComponent("EventTriggerListener", self.helpMask)
    self.R_scroolRect_listerner.onEndDrag = helpdrag
end