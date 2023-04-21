Strawberry_MainPanel = {};
local self = Strawberry_MainPanel;
self.speedtime = -10;
self.dotweentab = {};
function Strawberry_MainPanel:New()
    local t = o or {};
    setmetatable(t, self);
    self.__index = self
    return t;
end

function Strawberry_MainPanel.Start(obj)
    -- error("Strawberry_MainPanel.Start(obj)==================");
    self.GameCanvas = obj.transform:Find("Canvas").gameObject;
    self.GameCanvas:GetComponent("CanvasScaler").referenceResolution = Vector2.New(1334, 750);
    self.GameCanvas.Find("Camera").transform.localRotation = Quaternion.identity;
    self.GameCanvas.Find("Camera").transform.localPosition = Vector3.New(0, 0, -1000)
    self.GameCanvas.Find("Camera"):GetComponent('Camera').clearFlags = UnityEngine.CameraClearFlags.SolidColor;

    -- find("Canvas");
    self.GetCanvasInit();
    self.CanvasScalers = self.GameCanvas.transform:GetComponent('CanvasScaler')
    SetCanvasScalersMatch(self.CanvasScalers,1);

    log("开始生成主场景")
    local strawbg = self.GameCanvas.transform:Find("Bg");
    strawbg.localPosition=Vector3.New(0,0,200);
    self.GameCanvas.transform:Find("GUiCamera").localPosition=Vector3.New(0,0,200);
    --local bg = GameObject.New("BgImage"):AddComponent(typeof(UnityEngine.UI.Image));
    --bg.transform:SetParent(self.GameCanvas.transform:Find("Bg"));
    --bg.transform:SetAsFirstSibling();
    --bg.transform.localPosition = Vector3(0, 0, 0);
    --bg.transform.localScale = Vector3(1, 1, 1);
    --bg.sprite = HallScenPanel.moduleBg:Find("module25"):GetComponent("Image").sprite;
    --bg:GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
    --local bgchild = strawbg:Find("BG");
    --for i = 1, bgchild.childCount do
    --    bgchild:GetChild(i - 1):GetComponent("Image").sprite = HallScenPanel.moduleBg:Find("module25/bg1_0" .. i):GetComponent("Image").sprite;
    --end
    -- 创建游戏
    local function creatmusic(obj)

        local go = obj;
        go.transform:SetParent(self.GameCanvas.transform:Find("Bg"));
        go.transform.localScale = Vector3.one;
        go.transform.localPosition = Vector3.New(0, 0, 0);
        go.name = "Music"
        self.Music = go;
    end
    -- ResManager:LoadAsset(cn_strawberry_music.ab, cn_strawberry_music.name, creatmusic);
    creatmusic(find("Music"))
    log("生成完成主场景")

    -- 创建声音
end
-- 收到场景消息，初始化场景界面
function Strawberry_MainPanel.InitScenInfo()
    self.CreatMain();
end

-- 游戏消息
function Strawberry_MainPanel.GameInfo()
end
-- 创建主游戏
function Strawberry_MainPanel.CreatMain()
     error("创建主游戏");
    local function creatobj(obj)
        if not Strawberry_GameNet.ReLogon then
            local go = obj;
            go.transform:SetParent(self.GameCanvas.transform:Find("Bg"));
            go.transform.localScale = Vector3.one;
            go.transform.localPosition = Vector3.New(0, 0, 0);
            go.name = "MainPanel"
            self.mainpanel = go;
        end
        -- 初始化信息
        self.InitMain();
    end
    creatobj(find("MainPanel"))
end

function Strawberry_MainPanel.InitMain()
    if not Strawberry_GameNet.ReLogon then
        self.ClearInfoData();
    end
    self.Line = self.mainpanel.transform:Find("Line").gameObject;
    self.Rotefather = self.mainpanel.transform:Find("Mid_Rote").gameObject;
    self.Resultfather = self.mainpanel.transform:Find("Mid_Result").gameObject;
    self.Ani = self.mainpanel.transform:Find("Ani").gameObject;
    self.RightLine = self.mainpanel.transform:Find("Right").gameObject;
    self.LeftLine = self.mainpanel.transform:Find("Left").gameObject;
    for i = 0, self.Line.transform.childCount - 1 do
        self.Line.transform:GetChild(i).gameObject:SetActive(false);
    end
    -- 显示初始图片
    for i = 0, self.Rotefather.transform.childCount - 1 do

        self.Resultfather.transform:GetChild(i):GetComponent("Image").sprite = self.FruitImg.transform:GetChild(Strawberry_GameNet.byImg[i + 1]):GetComponent("Image").sprite
        local count = self.Rotefather.transform:GetChild(i):Find("Image").childCount
        -- error("coount===================" .. count);
        local Roteobj = self.Rotefather.transform:GetChild(i):Find("Image").gameObject;
        local one = Roteobj.transform:GetChild(0).gameObject;
        local last = Roteobj.transform:GetChild(count - 1).gameObject
        one:GetComponent("Image").sprite = self.FruitImg.transform:GetChild(Strawberry_GameNet.byImg[i + 1]):GetComponent("Image").sprite
        last:GetComponent("Image").sprite = self.FruitImg.transform:GetChild(Strawberry_GameNet.byImg[i + 1]):GetComponent("Image").sprite
    end
    -- 设置滚动得第一张图片和最后一张
    if not Strawberry_GameNet.ReLogon then
        self.SetInfo();
    end
    self.AddOnClick();
    log("======================开始判断==================" .. Strawberry_GameNet.Game_State);
    if Strawberry_GameNet.Game_State == 0 then
        self.SetBtnState = 0;
        self.SetBtnIsActive()
        coroutine.start(function()
            while #Strawberry_ChipList <= 0 do
                coroutine.wait(0.2);
            end
            coroutine.wait(0.3);
            if self.IsFreeHand then
                self.StartOnClick();
            end
        end);
        Strawberry_GameNet.ReLogon = false;
        return
    end
    -- 结算
    if Strawberry_GameNet.Game_State == 1 then
        self.SetBtnState = 3;
        Strawberry_MainPanel.SetBtnIsActive()
        Strawberry_GameNet.ReLogon = false;
        return
    end
    if Strawberry_GameNet.Game_State == 2 and Strawberry_GameNet.byMaryCount == 0 then
        self.SetBtnState = 0;
        self.SetBtnIsActive()
        Strawberry_GameNet.ReLogon = false;
        return ;
    end
    self.SetBtnState = 2;
    Strawberry_MainPanel.SetBtnIsActive()
    Strawberry_MaryPanel.InitScenInfo();
    Strawberry_GameNet.ReLogon = false;
    if (not Util.isPc) then
        GameSetsBtnInfo.SetPlaySuonaPos(-85, 326, 0)
    end
    log("设置完成")
end

-- 清理数据
function Strawberry_MainPanel.ClearInfoData()
    self.nowPage = 0;
    self.chipnum = 1;
    self.HelpPanel = nil;
    self.GoldNum = 0;
    self.WinNum = 0;
    self.IsFreeHand = false;
    self.showLineGold = 0;
    self.AniPos = {};
    self.SendGetGold = false;
    Strawberry_GameNet.IsStar = false;
    for i = 1, #self.dotweentab do
        Strawberry_MainPanel.dotweentab[i]:Kill();
    end
    self.dotweentab = {};
end

function Strawberry_MainPanel.GetCanvasInit()
    -- error("self.GameCanvas=================="..self.GameCanvas.gameObject.name)
    self.Help_Btn = self.GameCanvas.transform:Find("Bg/Help_Btn").gameObject;
    -- if (Util.isPc) then
    self.Help_Btn:SetActive(false);
    --  end
    self.Add_Btn = self.GameCanvas.transform:Find("Bg/Add_Btn").gameObject;
    self.Get_Btn = self.GameCanvas.transform:Find("Bg/Get_Btn").gameObject;
    self.Start_Btn = self.GameCanvas.transform:Find("Bg/Start_Btn").gameObject;
    self.Free_Btn = self.GameCanvas.transform:Find("Bg/Free_Btn").gameObject;
    self.Hand_Btn = self.GameCanvas.transform:Find("Bg/Hand_Btn").gameObject;
    self.NumImg = self.GameCanvas.transform:Find("Bg/num").gameObject;
    self.FruitImg = self.GameCanvas.transform:Find("Bg/fruit").gameObject;
    self.DownInfo = self.GameCanvas.transform:Find("Bg/DownInfo").gameObject;
    self.Gold = self.GameCanvas.transform:Find("Bg/Gold").gameObject;
    self.Gold:SetActive(false);
    self.Win = self.GameCanvas.transform:Find("Bg/Win").gameObject;
    self.Win:SetActive(false);
    self.Chip = self.GameCanvas.transform:Find("Bg/Chip").gameObject;
    self.Chip:SetActive(false);
    self.AllChip = self.GameCanvas.transform:Find("Bg/AllChip").gameObject;
    self.AllChip:SetActive(false);
    self.WinAni = self.GameCanvas.transform:Find("Bg/WinAni").gameObject;
    self.HeadLoad = self.GameCanvas.transform:Find("Bg/Head_Load").gameObject;
    Strawberry_MainPanel.SetWinAin(false)
    self.SetInfo();
    -- 修复上线后显示问题
    self.FixBug()
end

-- 修改游戏显示数据
function Strawberry_MainPanel.SetInfo()

    if #Strawberry_ChipList == 0 then
        self.Chip:SetActive(true);
        self.AllChip:SetActive(true);
        self.Gold:SetActive(true);
        self.Win:SetActive(true);
        self.NumToImg(0, self.Chip)
        self.NumToImg(0, self.AllChip)
        self.NumToImg(0, self.Gold)
        self.NumToImg(0, self.Win)
        return
    end
    self.NumToImg(Strawberry_ChipList[1], self.Chip)
    -- 总下注
    self.NumToImg(Strawberry_ChipList[1] * MH_StrawberryData.D_LINE_CNT, self.AllChip)
    -- 总金币
    self.WinNum = tonumber(tostring(Strawberry_GameNet.WinNum))
    self.NumToImg(Strawberry_GameNet.WinNum, self.Win)
    -- 赢得金币
    self.GoldNum = Strawberry_GameNet.GoldNum
    self.NumToImg(Strawberry_GameNet.GoldNum, self.Gold)
end
function Strawberry_MainPanel.AddOnClick()
    if Strawberry_GameNet.ReLogon then
        return
    end
    Strawberry_Scen.luaBehaviour:AddClick(self.Help_Btn, self.HelpOnClick)
    Strawberry_Scen.luaBehaviour:AddClick(self.Add_Btn, self.AddChipOnClick)
    Strawberry_Scen.luaBehaviour:AddClick(self.Get_Btn, self.GetOnClick)
    Strawberry_Scen.luaBehaviour:AddClick(self.Start_Btn, self.StartOnClick)
    Strawberry_Scen.luaBehaviour:AddClick(self.Free_Btn, self.FreeOnClick)
    Strawberry_Scen.luaBehaviour:AddClick(self.Hand_Btn, self.HandOnClick)
    -- error("添加事件========================");
end
-- 帮助
function Strawberry_MainPanel.HelpOnClick(args)
    -- self.Music
    self.PlayMusic("click")
    args.transform:GetComponent("Button").interactable = false;
    if not IsNil(self.HelpPanel) then

        self.HelpPanel:SetActive(true);
        self.HelpPanel.transform.localPosition = Vector3.New(0, 0, 0)
        return
    end
    self.nowPage = 0;
    -- 返回游戏方法
    local function backgame()
        self.HelpPanel:SetActive(false);
        args.transform:GetComponent("Button").interactable = true;
        self.HelpPanel.transform.localPosition = Vector3.New(0, 1000, 0)
    end
    -- 上一页
    local function uppage()
        self.nowPage = self.nowPage - 1;
        if self.nowPage < 0 then
            self.nowPage = 3
        end
        for i = 0, self.Info.transform.childCount - 1 do
            self.Info.transform:GetChild(i).gameObject:SetActive(false);
        end
        self.Info.transform:GetChild(self.nowPage).gameObject:SetActive(true);
    end
    -- 下一页
    local function downpage()
        self.nowPage = self.nowPage + 1;
        if self.nowPage > 3 then
            self.nowPage = 0
        end
        for i = 0, self.Info.transform.childCount - 1 do
            self.Info.transform:GetChild(i).gameObject:SetActive(false);
        end
        self.Info.transform:GetChild(self.nowPage).gameObject:SetActive(true);
    end
    local function creathelp(obj)
        local go = obj;
        go.transform:SetParent(self.GameCanvas.transform);
        go.transform.localScale = Vector3.one;
        go.transform.localPosition = Vector3.New(0, 0, 0);
        go.name = "HelpPanel"
        self.HelpPanel = go;
        self.panelIndex = self.GameCanvas.transform:Find("Bg"):GetSiblingIndex();
        self.HelpPanel.transform:SetSiblingIndex(self.panelIndex);
        self.backbtn = self.HelpPanel.transform:Find("Back").gameObject;
        self.upbtn = self.HelpPanel.transform:Find("Up_Page").gameObject;
        self.downbtn = self.HelpPanel.transform:Find("Down_Page").gameObject;
        self.Info = self.HelpPanel.transform:Find("Info").gameObject;
        self.nowPage = 0;
        self.Info.transform:GetChild(self.nowPage).gameObject:SetActive(true);
        for i = 1, self.Info.transform.childCount - 1 do
            self.Info.transform:GetChild(i).gameObject:SetActive(false);
        end
        Strawberry_Scen.luaBehaviour:AddClick(self.backbtn, backgame)
        Strawberry_Scen.luaBehaviour:AddClick(self.upbtn, uppage)
        Strawberry_Scen.luaBehaviour:AddClick(self.downbtn, downpage)
    end
    -- ResManager:LoadAsset(cn_strawberry_help.ab, cn_strawberry_help.name, creathelp);
    creathelp(find("HelpPanel"))
end
-- 加注
function Strawberry_MainPanel.AddChipOnClick(args)
    if #Strawberry_ChipList == 0 then
        return
    end
    self.PlayMusic("changebet")
    if self.SetBtnState ~= 4 then
        if self.SetBtnState ~= 0 or self.IsFreeHand == true then
            return
        end ;
    end
    args.transform:GetComponent("Button").interactable = false;
    self.chipnum = self.chipnum + 1;
    if self.chipnum > #Strawberry_ChipList then
        self.chipnum = 1
    end
    self.NumToImg(Strawberry_ChipList[self.chipnum], self.Chip)
    -- 总下注
    self.NumToImg(Strawberry_ChipList[self.chipnum] * MH_StrawberryData.D_LINE_CNT, self.AllChip)
    args.transform:GetComponent("Button").interactable = true;
end
-- 启动
function Strawberry_MainPanel.StartOnClick()
    if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then
        if GameManager.IsStopGame then
            return 
        end
        self.PlayMusic("click")

        if self.SetBtnState ~= 0 or Strawberry_GameNet.IsStar == true then
            return
        end ;
        if not self.mainpanel.activeSelf then
            log("===========================================7=========================================");
            Strawberry_MaryPanel.SCGetResult();
            Strawberry_GameNet.SendResult();
        end
        if not self.mainpanel.activeSelf then
            return
        end
        if #Strawberry_ChipList <= 0 then
            return ;
        end
        if toInt64(self.GoldNum) < toInt64(Strawberry_ChipList[self.chipnum] * 9) then
            self.Free_Btn:GetComponent("Button").interactable = false;
            self.IsFreeHand = false;
            self.SetBtnIsActive()
            self.Free_Btn:GetComponent("Button").interactable = true;
            self.Free_Btn.gameObject:SetActive(true);
            MessageBox.CreatGeneralTipsPanel("下注金币不足！", nil);
            return
        end
        self.SetBtnState = 1;
        self.SetBtnIsActive()
        self.GoldNum = Strawberry_GameNet.GoldNum
        self.WinNum = 0;
        Strawberry_MainPanel.SetWinAin(false)
        self.NumToImg(self.WinNum, self.Win)
        self.NumToImg(self.GoldNum, self.Gold)
        Strawberry_GameNet.MainSendInfo(self.chipnum);
        for r = 0, 2 do
            for j = 0, 4 do
                local i = r * 5 + j;
                local topobj = self.Rotefather.transform:GetChild(i):Find("Image").gameObject
                local allnum = topobj.transform.childCount - 1;
                for k = 1, topobj.transform.childCount - 2 do
                    local radnum = math.random(0, 8);
                    topobj.transform:GetChild(k):GetComponent('Image').sprite = self.FruitImg.transform:GetChild(radnum):GetComponent('Image').sprite
                end
                topobj.transform.localPosition = Vector3.New(0, 0, 0);
                topobj:SetActive(true);
                self.Resultfather.transform:GetChild(i).gameObject:SetActive(false);
                if #self.dotweentab == 15 then
                    if i + 1 > 15 then
                        return
                    end
                    self.dotweentab[i + 1]:DORestart();
                    return
                end
                local dotween = topobj.transform:DOLocalMove(Vector3.New(0, -(allnum) * 141, 0), 0.1 * allnum, false):SetEase(DG.Tweening.Ease.Linear):SetLoops(-1);
                table.insert(self.dotweentab, dotween)
            end
        end

    end
end

-- 游戏结果
function Strawberry_MainPanel.GameResult()

    self.AniPos = {};
    Strawberry_GameNet.GoldNum = Strawberry_GameNet.GoldNum - (Strawberry_ChipList[self.chipnum] * MH_StrawberryData.D_LINE_CNT);
    self.GoldNum = Strawberry_GameNet.GoldNum
    if not Strawberry_GameNet.ReLogon then
        self.NumToImg(self.GoldNum, self.Gold)
        
    end
    for i = 0, self.Rotefather.transform.childCount - 1 do
        local name = MH_StrawberryData.enum_IconName[Strawberry_GameNet.byImg[i + 1] + 1];
        self.Resultfather.transform:GetChild(i):GetComponent("Image").sprite = self.FruitImg.transform:Find(name):GetComponent("Image").sprite
        local count = self.Rotefather.transform:GetChild(i):Find("Image").childCount
        local Roteobj = self.Rotefather.transform:GetChild(i):Find("Image").gameObject;
        local one = Roteobj.transform:GetChild(0).gameObject;
        local last = Roteobj.transform:GetChild(count - 1).gameObject
        one:GetComponent("Image").sprite = self.FruitImg.transform:Find(name):GetComponent("Image").sprite
        last:GetComponent("Image").sprite = self.FruitImg.transform:Find(name):GetComponent("Image").sprite
        -- if Strawberry_GameNet.byImg[i + 1] == 8 then
        --     table.insert(self.AniPos, i);
        -- end
    end
    -- 获取到消息再转
    if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then
        if GameManager.IsStopGame then
            return 
         end
        self.loop = 1;
        self.Rote()

    end
end
-- 结算
self.SendGetGold = false;
function Strawberry_MainPanel.GetOnClick()
    self.PlayMusic("click")
    if self.SetBtnState ~= 3 then
        return
    end ;
    self.SendGetGold = true;
    self.SetBtnState = 4;
    -- self.SetBtnIsActive()
    -- 给服务器发消息
    Strawberry_GameNet.SendResult()
end
-- 收到服务器结算消息（金币开始逐减）
function Strawberry_MainPanel.SCGameResult()
    local function playani()
        local num = tonumber(tostring(Strawberry_GameNet.WinNum))
        local musicnum = 1;
        local donum = Strawberry_ChipList[self.chipnum]
        local starttime = 0.16
        local rotenum = 2;
        local valuerote = 1;
        self.SetBtnState = 0;

        self.SetBtnIsActive()
        while (num > 0) do
            num = num - donum;
            self.WinNum = self.WinNum - donum;
            self.GoldNum = self.GoldNum + donum;
            if musicnum == 5 then
                musicnum = 1
            end
            self.PlayMusic("score" .. musicnum)
            musicnum = musicnum + 1;
            if valuerote > 20 then
                valuerote = valuerote * 2
            else
                valuerote = valuerote + 1;
            end
            donum = Strawberry_ChipList[self.chipnum] * valuerote
            if ScenSeverName == gameServerName.HALL or ScenSeverName == gameServerName.LOGON then
                return ;
            end
            if starttime ~= 0.08 then
                starttime = starttime - 0.01
            end ;
            if self.SetBtnState == 1 then
                return
            end ;
            coroutine.wait(starttime);
            if num <= 0 then
                self.WinNum = 0;
                self.NumToImg(Strawberry_GameNet.GoldNum, self.Gold)
                self.NumToImg(self.WinNum, self.Win)
                Strawberry_MainPanel.SetWinAin(false)
                if not self.mainpanel.activeSelf then
                    Strawberry_MaryPanel.SCGetResult();
                    Strawberry_GameNet.SendResult();
                    coroutine.wait(0.1);
                end
                if self.IsFreeHand then
                    self.StartOnClick()
                end ;
                return
            end ;
            self.NumToImg(self.GoldNum, self.Gold)
            self.NumToImg(self.WinNum, self.Win)
        end
    end
    if Strawberry_GameNet.WinNum > 0 then
        self.DownInfo.transform:GetChild(1).gameObject:SetActive(false)
        self.DownInfo.transform:GetChild(0).gameObject:SetActive(true)
        self.WinNum = Strawberry_GameNet.WinNum;
        for i = 0, self.Line.transform.childCount - 1 do
            local setline = self.Line.transform:GetChild(i).gameObject
            if setline.activeSelf then
                setline:SetActive(false);
                local lineani = self.RightLine.transform:GetChild(i):GetComponent("Animator");
                lineani:Play("Line", 0, 1);
                local lineaniLeft = self.LeftLine.transform:GetChild(i):GetComponent("Animator");
                lineaniLeft:Play("Line", 0, 1);
            end
        end
        coroutine.start(playani)
        return
    end
    self.SetBtnState = 0;
    self.SetBtnIsActive()

    if not self.mainpanel.activeSelf then
        Strawberry_MaryPanel.SCGetResult();
        Strawberry_GameNet.SendResult();
        coroutine.wait(0.1)
    end
    if self.IsFreeHand then
        self.StartOnClick()
        return ;
    end ;
end

-- 自动开始
self.IsFreeHand = false;
function Strawberry_MainPanel.FreeOnClick(args)
    self.PlayMusic("click")
    if #Strawberry_ChipList <= 0 then
        return ;
    end
    args.transform:GetComponent("Button").interactable = false;
    -- 空状态，开始
    error("self.SetBtnState=========" .. self.SetBtnState);
    if self.SetBtnState == 0 then
        self.StartOnClick()
    end ;
    if self.SetBtnState == 3 then
        self.GetOnClick()
    end ;
    self.IsFreeHand = true;
    self.SetBtnIsActive()
    args.transform:GetComponent("Button").interactable = true;
end

-- 手动
function Strawberry_MainPanel.HandOnClick(args)
    self.PlayMusic("click")
    args.transform:GetComponent("Button").interactable = false;
    self.IsFreeHand = false;
    self.SetBtnIsActive()
    args.transform:GetComponent("Button").interactable = true;
end


-- 数字转换成Img
function Strawberry_MainPanel.NumToImg(num, needfather)
    local data = tostring(num);
    for i = 1, string.len(data) do
        local obj = needfather.transform:GetChild(i - 1).gameObject;
        local prefebnum = string.sub(data, i, i);
        obj:GetComponent('Image').sprite = self.NumImg.transform:GetChild(prefebnum):GetComponent('Image').sprite
        obj:SetActive(true);
    end
    for i = (string.len(data)) + 1, needfather.transform.childCount do
        needfather.transform:GetChild(i - 1).gameObject:SetActive(false);
    end
end

-- 底部提示文字
-- num(代表第几条线)，0代表默认
function Strawberry_MainPanel.HintTextInfo(num, Gold, linenum)
    self.showLineGold = self.showLineGold + Gold
    self.NumToImg(self.showLineGold, self.Win)
    -- 显示线条提示
    self.Line.transform:GetChild(num - 1).gameObject:SetActive(true);
    local lineani = self.RightLine.transform:GetChild(num - 1):GetComponent("Animator");
    lineani:Play("Line", 0, 0);
    local lineaniLeft = self.LeftLine.transform:GetChild(num - 1):GetComponent("Animator");
    lineaniLeft:Play("Line", 0, 0);
    if linenum > 9 or linenum < 1 then
        linenum = 1
    end ;
    self.PlayMusic("hitline" .. linenum)
    -- 中奖位置需要添加得数
    -- 显示底部提示
    self.DownInfo.transform:GetChild(0).gameObject:SetActive(false)
    self.DownInfo.transform:GetChild(1).gameObject:SetActive(true)
    self.DownInfo.transform:GetChild(1):GetComponent("Text").text = "连线 " .. num .. " 中奖，获得 " .. Gold .. " 金币"
end

-- 结算动画
-- 设置Btn是否可点
-- 启动时：帮助可点，（加注不可点）
-- 自动时：自动、帮助可点 （加注不可点）
-- 结算时：帮助可点 （加注不可点）
-- 运行状态：帮助、自动可点
-- 两种状态
self.SetBtnState = 0;
-- 空状态：启动、加注、帮助、自动均可点，结算隐藏 0
-- 运行状态 自动、帮助、启动、加注不可点，结算隐藏 1
-- 玛丽状态 自动、帮助可点 启动、加注不可点，结算隐藏 2
-- 结算前（ 自动、帮助、结算显示，启动隐藏、加注不可点  ）3
-- 结算时 （ 自动、帮助、结算显示不可点，启动隐藏、加注不可点  ）4（播结算效果时）
-- 自动状态 除去帮助和取消自动可点 5
function Strawberry_MainPanel.SetBtnIsActive()
    -- self.Add_Btn self.Start_Btn self.Get_Btn self.Chip_Btn
    if self.IsFreeHand then
        self.Hand_Btn:SetActive(true);
        self.Free_Btn:SetActive(false);
        self.Start_Btn:SetActive(true);
        self.Get_Btn:SetActive(false);
        return
    end
    if self.SetBtnState == 0 then
        -- 空状态
        self.Start_Btn:SetActive(true);
        self.Get_Btn:SetActive(false);
    end
    if self.SetBtnState == 1 then
        -- 运行状态
        self.Start_Btn:SetActive(true);
        self.Get_Btn:SetActive(false);
    end
    if self.SetBtnState == 2 then
        -- 玛丽状态
        self.Start_Btn:SetActive(true);
        self.Get_Btn:SetActive(false);
    end
    if self.SetBtnState == 3 then
        -- 结算前状态
        self.Start_Btn:SetActive(false);
        self.Get_Btn:SetActive(true);
    end
    if self.SetBtnState == 4 then
        -- 结算动画
        self.Start_Btn:SetActive(false);
        self.Get_Btn:SetActive(true);
    end
    self.Hand_Btn:SetActive(false);
    self.Free_Btn:SetActive(true);
end

-- 转动130X141+（间距5）
function Strawberry_MainPanel.Rote()
    --  error("Strawberry_MainPanel.Rote()");
    -- 设置每个图片位置
    self.loop = 1;
    self.SendGetGold = false;
    local function setroteimg()
        for r = 0, 2 do
            for j = 0, 4 do
                local i = r * 5 + j;
                local topobj = self.Rotefather.transform:GetChild(i):Find("Image").gameObject
                local allnum = topobj.transform.childCount - 1;
                for k = 1, topobj.transform.childCount - 2 do
                    local radnum = math.random(0, 8);
                    topobj.transform:GetChild(k):GetComponent('Image').sprite = self.FruitImg.transform:GetChild(radnum):GetComponent('Image').sprite
                end
                topobj.transform.localPosition = Vector3.New(0, 0, 0);
                topobj:SetActive(true);
                self.Resultfather.transform:GetChild(i).gameObject:SetActive(false);
                self.dotweentab[i + 1]:Pause():Rewind(true);
                local dotween = topobj.transform:DOLocalMove(Vector3.New(0, -(allnum) * 141, 0), 0.1 * allnum, false):SetEase(DG.Tweening.Ease.Linear):SetLoops(self.loop);
                dotween:OnComplete(
                        function()
                            if i > 9 then
                                self.PlayMusic("stop");
                            end
                        end)
                self.dotweentab[i + 1]:Kill();
            end
        end
        self.dotweentab = {};
        -- 开始转动，转动到最后一个位置停下来时候，需要把第一个图片设
        for i = 1, 4 do
            if ScenSeverName == gameServerName.HALL or ScenSeverName == gameServerName.LOGON then
                return ;
            end
            self.PlayMusic("roll")
            coroutine.wait(0.52)
        end
        if ScenSeverName == gameServerName.HALL or ScenSeverName == gameServerName.LOGON then
            return ;
        end
        -- 没有收到结果一直转动
        if self.loop == -1 then
            error("没有收到结果")
        end ;
        Strawberry_GameNet.IsStar = false;
        -- 全停显示结果
        if Strawberry_GameNet.WinNum == 0 and Strawberry_GameNet.byMaryCount == 0 then
            Strawberry_MainPanel.SetWinAin(false)
            self.SetBtnState = 0;
            Strawberry_MainPanel.SetBtnIsActive();

            Strawberry_MainPanel.GameInfo();
            if ScenSeverName == gameServerName.HALL or ScenSeverName == gameServerName.LOGON then
                return ;
            end
            if self.IsFreeHand then
                coroutine.wait(0.5)
                if GameNextScenName == gameScenName.HALL then
                    return
                end
                self.StartOnClick()
            end ;

            return
        end
        self.showLineGold = 0;
        if Strawberry_GameNet.byMaryCount == 0 then
            self.SetBtnState = 3;
            -- 4.4日 佛改为不自动结算
            Strawberry_MainPanel.SetBtnIsActive();
        end
        if Strawberry_GameNet.WinNum == 0 then
            Strawberry_MainPanel.WinAni.transform:Find("Socre").gameObject:SetActive(false);
        end
        Strawberry_MainPanel.SetWinAin(true)
        local linenum = 0;
        for i = 1, #Strawberry_iLineRate do
            if Strawberry_iLineRate[i] > 0 then
                linenum = linenum + 1;
                self.HintTextInfo(i, Strawberry_iLineRate[i] * Strawberry_ChipList[self.chipnum], linenum)
                coroutine.wait(0.5);
                if ScenSeverName == gameServerName.HALL or ScenSeverName == gameServerName.LOGON then
                    return ;
                end
                if self.SendGetGold then
                    return
                end ;
            end
        end
        if self.SendGetGold then
            return
        end ;
        if (Strawberry_GameNet.WinNum) / Strawberry_ChipList[self.chipnum] > 300 and Strawberry_GameNet.byMaryCount == 0 then
            if self.SendGetGold then
                return
            end ;
            self.winMusic = self.PlayMusic("superwin")
            coroutine.wait(5);
            if GameNextScenName == gameScenName.HALL then
                return
            end
            Strawberry_MainPanel.SetWinAin(false)
        end ;

        if ScenSeverName == gameServerName.HALL or ScenSeverName == gameServerName.LOGON then
            return ;
        end
        if self.SendGetGold then
            return
        end ;
        if (Strawberry_GameNet.WinNum) / Strawberry_ChipList[self.chipnum] > 90 and Strawberry_GameNet.byMaryCount == 0 then
            if self.SendGetGold then
                return
            end ;
            self.winMusic = self.PlayMusic("bigwin")
            coroutine.wait(2);
        end ;
        if ScenSeverName == gameServerName.HALL or ScenSeverName == gameServerName.LOGON then
            return ;
        end
        if self.SendGetGold then
            return
        end ;
        if Strawberry_GameNet.byMaryCount > 0 then
            -- 播放草莓动画
            coroutine.wait(0.5);
            self.marymusic = self.PlayMusic("getberry")
            coroutine.start(self.PlayStrawberry)
            return
        end
        -- 显示完成，可点击结算
        if self.IsFreeHand then
            coroutine.wait(0.5);
            self.GetOnClick();
            return ;
        end ;
    end
    coroutine.start(setroteimg);
end

function Strawberry_MainPanel.PlayMusic(strname)
    if GameNextScenName == gameScenName.HALL then
        return
    end
    if ScenSeverName == gameServerName.HALL or ScenSeverName == gameServerName.LOGON then
        return ;
    end
    if self.Music == nil then
        return
    end
    local musicchip = self.Music.transform:Find(strname):GetComponent('AudioSource').clip
    return MusicManager:PlayX(musicchip);
end

-- 草莓动画
function Strawberry_MainPanel.PlayStrawberry()
    for k = 1, 7 do
        for i = 1, #self.AniPos do
            local num = self.AniPos[i];
            local count = self.Rotefather.transform:GetChild(num):Find("Image").childCount
            local Roteobj = self.Rotefather.transform:GetChild(num):Find("Image").gameObject;
            local last = Roteobj.transform:GetChild(count - 1).gameObject
            last:GetComponent("Image").sprite = self.Ani.transform:GetChild(0):GetComponent("Image").sprite
        end

        if ScenSeverName == gameServerName.HALL or ScenSeverName == gameServerName.LOGON then
            return ;
        end
        coroutine.wait(0.3);
        for i = 1, #self.AniPos do
            local num = self.AniPos[i];
            local count = self.Rotefather.transform:GetChild(num):Find("Image").childCount
            local Roteobj = self.Rotefather.transform:GetChild(num):Find("Image").gameObject;
            local last = Roteobj.transform:GetChild(count - 1).gameObject
            last:GetComponent("Image").sprite = self.Ani.transform:GetChild(1):GetComponent("Image").sprite
        end
        if ScenSeverName == gameServerName.HALL or ScenSeverName == gameServerName.LOGON then
            return ;
        end
        coroutine.wait(0.3);
    end
    self.SetBtnState = 2;
    Strawberry_MainPanel.SetBtnIsActive()
    Strawberry_MaryPanel.InitScenInfo();
    if not IsNil(self.marymusic) then
        destroy(self.marymusic)
    end
    Strawberry_MainPanel.WinAni.transform:Find("Socre").gameObject:SetActive(true);
    Strawberry_MainPanel.SetWinAin(false)
    for i = 1, #self.AniPos do
        local num = self.AniPos[i];
        local count = self.Rotefather.transform:GetChild(num):Find("Image").childCount
        local Roteobj = self.Rotefather.transform:GetChild(num):Find("Image").gameObject;
        local last = Roteobj.transform:GetChild(count - 1).gameObject
        last:GetComponent("Image").sprite = self.FruitImg.transform:GetChild(8):GetComponent("Image").sprite
    end
end

function Strawberry_MainPanel.SetWinAin(bl)
    self.WinAni:SetActive(bl);
    self.HeadLoad:SetActive(not bl);
    if bl == true then
        self.speedtime = 3
    end
    if bl == false then
        self.speedtime = -10
    end
end

function Strawberry_MainPanel.FixedUpdate()
    if self.speedtime == -10 then
        return
    end
    if self.speedtime > 0 then
        self.speedtime = self.speedtime - 0.02;
        return
    end
    if self.speedtime <= 0 then
        Strawberry_MainPanel.SetWinAin(false)
    end
end

function Strawberry_MainPanel.FixBug()
    self.Help_Btn:SetActive(false);
    local obj = self.DownInfo.transform:Find("mary").gameObject;
    local num = obj.transform.childCount;
    local setobj = obj.transform:GetChild(num - 1).gameObject
    setobj.transform:GetComponent("RectTransform").sizeDelta = Vector2.New(185, 66);
    -- 添加黑色遮罩
    local function creatobj(obj)
        local go = obj;
        go.transform:SetParent(self.GameCanvas.transform);
        go.transform.localScale = Vector3.one;
        go.transform.localPosition = Vector3.New(0, 0, 0);
        go.name = "Zhezhao"
        self.panelIndex = self.GameCanvas.transform:Find("Bg"):GetSiblingIndex();
        go.transform:SetSiblingIndex(self.panelIndex - 1);
        go.transform:GetComponent("RectTransform").sizeDelta = Vector2.New(3000, 3000);
        go.transform:GetComponent("Image").color = Color.New(0, 0, 0, 1);
        go:SetActive(true);
    end
    -- 初始化信息
    local go = newobject(self.Help_Btn);
    creatobj(go)
end