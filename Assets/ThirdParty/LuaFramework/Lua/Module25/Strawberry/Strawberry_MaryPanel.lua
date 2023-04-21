Strawberry_MaryPanel = { };
local self = Strawberry_MaryPanel;
self.friutbl = {
    [1] = 2,
    -- //樱桃0
    [2] = 5,
    -- //杏1
    [3] = 10,
    -- //柠檬2
    [4] = 20,
    -- //苹果3
    [5] = 50,
    -- //梨4
    [6] = 70,
    -- //西瓜5
    [7] = 100,
    -- //鸡尾酒7
    [8] = 0, -- //草莓（没有）8
    [9] = 0,
    -- //WILD(没有)6


};

C_MARY_IMG = { "D_IMG_EXIT", 4, 1, 3, 0, 2, 5, "D_IMG_EXIT", 0, 1, 3, 2, 0, "D_IMG_EXIT", 4, 1, 0, 2, 1, 7, "D_IMG_EXIT", 0, 1, 3, 2, 0 };
function Strawberry_MaryPanel:New()
    local t = o or { };
    setmetatable(t, self);
    self.__index = self
    return t;
end

function Strawberry_MaryPanel.InitScenInfo()
    -- 玛丽数据
    self.NowWinNum = Strawberry_GameNet.WinNum;
    self.NowGoldNum = Strawberry_GameNet.GoldNum;
    Strawberry_MainPanel.NumToImg(self.NowWinNum, Strawberry_MainPanel.Win)
    if not Strawberry_GameNet.ReLogon then
        Strawberry_MainPanel.NumToImg(self.NowGoldNum, Strawberry_MainPanel.Gold)
    end

    if self.marypanel ~= nil then
        self.marypanel:SetActive(true)
        Strawberry_MainPanel.mainpanel:SetActive(false)
        self.MaryCountTxt.text = Strawberry_GameNet.byMaryCount;
        local startpos = self.OutObj.transform:GetChild(Strawberry_GameNet.byStopIndex).localPosition;
        self.nowpos = Strawberry_GameNet.byStopIndex;
        self.RunningImg.transform.localPosition = startpos;
        self.SendGameStart();
        return ;
    end
    local function creatobj(obj)
        local go = obj;
        go.transform:SetParent(Strawberry_MainPanel.GameCanvas.transform:Find("Bg"));
        go.transform.localScale = Vector3.one;
        go.transform.localPosition = Vector3.New(-124, 31, 0);
        Strawberry_MainPanel.mainpanel:SetActive(false)
        go.name = "MaryPanel"
        self.marypanel = go;
        -- 初始化信息
        self.MaryCountTxt = self.marypanel.transform:Find("Count/Text"):GetComponent("Text")
        self.MaryCountTxt.text = Strawberry_GameNet.byMaryCount;
        -- 设置按钮不可点击
        self.OutObj = self.marypanel.transform:Find("Out").gameObject;
        self.OutObjIndex = self.OutObj.transform:GetSiblingIndex();
        self.RunningImg = self.marypanel.transform:Find("Run").gameObject;
        self.RunningImgIndex = self.RunningImg.transform:GetSiblingIndex();
        self.MidObj = self.marypanel.transform:Find("Mid").gameObject;
        -- 停止得位置self.byStopIndex
        self.RunningImg.transform.localPosition = self.OutObj.transform:GetChild(Strawberry_GameNet.byStopIndex).localPosition;
        self.RunningImg:SetActive(false);
        for i = 1, self.MidObj.transform.childCount do
            local obj = self.MidObj.transform:GetChild(i - 1).gameObject;
            obj.transform:Find("MidLight").gameObject:SetActive(false);
            obj.transform:Find("Num").gameObject:SetActive(false);
            obj.transform:Find("Num/Text"):GetComponent("Text").text = " ";
        end

        local startpos = self.OutObj.transform:GetChild(Strawberry_GameNet.byStopIndex).localPosition;
        self.StartIndex = Strawberry_GameNet.byStopIndex;
        self.RunningImg.transform.localPosition = startpos;
        -- 结算
        if Strawberry_GameNet.Game_State == 3 then
            Strawberry_MaryPanel.SCGetResult();
            Strawberry_GameNet.SendResult();
            return
        end
        self.SendGameStart();
    end
    -- ResManager:LoadAsset(cn_strawberry_mary.ab, cn_strawberry_mary.name, creatobj);
    creatobj(find("MaryPanel"))
end

function Strawberry_MaryPanel.RunningF()
    -- 外圈3次+（最后停）；
    -- 开始转动
    self.RunningImg:SetActive(true);
    local endIndex = Strawberry_GameNet.byStopIndex
    self.nowpos = self.StartIndex;
    local RunNum = 2;
    local isrun = true;
    self.midloop = 2;
    local function midrunfun()
        for i = 1, self.MidObj.transform.childCount do
            local obj = self.MidObj.transform:GetChild(i - 1).gameObject;
            faobj = obj.transform:Find("Rote/Image").gameObject;
            local allnum = faobj.transform.childCount - 1
            faobj.transform.localPosition = Vector3.New(0, 0, 0);
            for k = 0, allnum - 1 do
                local showrad = math.random(0, 8);
                while showrad == 6 do
                    showrad = math.random(0, 8);
                end
                faobj.transform:GetChild(k):GetComponent("Image").sprite = Strawberry_MainPanel.FruitImg.transform:GetChild(showrad):GetComponent("Image").sprite
            end
            local dotween = faobj.transform:DOLocalMove(Vector3.New(0, -(allnum) * 141, 0), 0.1 * allnum, false)
            dotween:OnComplete(function()
                Strawberry_MainPanel.PlayMusic("stop")
            end)
        end
    end
    local function musicplay()
        for i = 1, 6 do
            if ScenSeverName == gameServerName.HALL or ScenSeverName == gameServerName.LOGON then
                return ;
            end
            Strawberry_MainPanel.PlayMusic("roll")
            coroutine.wait(0.52);
        end
    end
    local function runfun()
        self.OutObj.transform:SetSiblingIndex(self.OutObjIndex);
        self.RunningImg.transform:SetSiblingIndex(self.RunningImgIndex);
        -- 中间圈
        midrunfun();
        -- 最后慢下速度位置
        self.speedchangepos = 0;
        if Strawberry_GameNet.byStopIndex < 3 then
            self.speedchangepos = Strawberry_GameNet.byStopIndex - 3 + 26;
        end
        if Strawberry_GameNet.byStopIndex > 2 then
            self.speedchangepos = Strawberry_GameNet.byStopIndex - 3;
        end
        -- 外圈
        local rollTime = 0.03;
        -- 声音循环
        --  local musicplay = 0;
        coroutine.start(musicplay)
        local lastpos = 0;
        local randomnum = math.random(1, 10);
        -- if randomnum % 2 == 0 then
        lastpos = Strawberry_GameNet.byStopIndex - 1;
        if lastpos < 0 then
            lastpos = 25;
        end
        --  end
        while
        (isrun)
        do
            coroutine.wait(rollTime)
            -- 音效

            if ScenSeverName == gameServerName.HALL or ScenSeverName == gameServerName.LOGON then
                return ;
            end
            -- if musicplay % 15 == 0 then Strawberry_MainPanel.PlayMusic("roll") end
            -- musicplay = musicplay + 1;
            self.nowpos = self.nowpos + 1;
            if self.nowpos == self.OutObj.transform.childCount then
                self.nowpos = 0
            end
            if self.StartIndex == self.nowpos then
                RunNum = RunNum - 1
            end ;
            if RunNum == 0 and self.nowpos == lastpos then
                isrun = false
            end
            if RunNum == 0 and self.nowpos == self.speedchangepos then
                rollTime = 0.1
            end
            if rollTime > 0.03 then
                rollTime = rollTime + 0.1;
                Strawberry_MainPanel.PlayMusic("stop")
            end ;
            -- 没有获取到服务器消息
            self.RunningImg.transform.localPosition = self.OutObj.transform:GetChild(self.nowpos).localPosition;
        end
        if randomnum % 2 == 0 then
            coroutine.wait(1.3)
        end ;
        if randomnum % 2 ~= 0 then
            coroutine.wait(0.3)
        end ;
        self.RunningImg.transform.localPosition = self.OutObj.transform:GetChild(Strawberry_GameNet.byStopIndex).localPosition;
        self.OutObj.transform:SetSiblingIndex(self.RunningImgIndex);
        self.RunningImg.transform:SetSiblingIndex(self.OutObjIndex);

        -- 设置颜色渐变3次
        coroutine.wait(0.3);

        if ScenSeverName == gameServerName.HALL or ScenSeverName == gameServerName.LOGON then
            return ;
        end
        self.RunningImg:SetActive(false);
        coroutine.wait(0.3);

        if ScenSeverName == gameServerName.HALL or ScenSeverName == gameServerName.LOGON then
            return ;
        end
        self.RunningImg:SetActive(true);
        self.StartIndex = Strawberry_GameNet.byStopIndex;
        if ScenSeverName == gameServerName.HALL or ScenSeverName == gameServerName.LOGON then
            return ;
        end
        coroutine.start(self.ShowResultAni)
    end
    coroutine.start(runfun);
end

-- 结果效果
function Strawberry_MaryPanel.ShowResultAni()
    self.MaryCountTxt.text = Strawberry_GameNet.byMaryCount;
    local num = tonumber(C_MARY_IMG[Strawberry_GameNet.byStopIndex + 1]);
    if num == nil and Strawberry_GameNet.byMaryCount == 0 then
        -- 显示结算按钮
        if Strawberry_GameNet.WinNum > 0 then
            Strawberry_MainPanel.SetWinAin(true)
        end
        coroutine.wait(2);
        if Strawberry_GameNet.WinNum == 0 then
            Strawberry_MainPanel.SetBtnState = 0;
            Strawberry_MainPanel.SetBtnIsActive();
            Strawberry_MaryPanel.SCGetResult();
            Strawberry_GameNet.SendResult();
            if Strawberry_MainPanel.IsFreeHand then
                Strawberry_MainPanel.StartOnClick()
                return ;
            end ;
            return ;
        end
        Strawberry_GameNet.SendResult();
        return ;
    end
    -- 没有转到奖励
    if num == nil then
        coroutine.wait(1);
        self.SendGameStart()
        return
    end ;

    if Strawberry_GameNet.WinNum == self.NowWinNum then
        coroutine.wait(1);
        self.SendGameStart()
        return
    end
    -- 转到奖励
    Strawberry_MainPanel.SetWinAin(true)
    local changeobjtab = { };
    for i = 1, #Strawberry_GameNet.byPrizeImg do
        if Strawberry_GameNet.byPrizeImg[i] == num then
            local obj = self.MidObj.transform:GetChild(i - 1).gameObject;
            local changeobj = obj.transform:Find("MidLight").gameObject
            -- 设置颜色渐变3次
            table.insert(changeobjtab, changeobj);
            if #changeobjtab == 1 then
                Strawberry_MainPanel.PlayMusic("marryhit")
            end
            changeobj:SetActive(true);
            if ScenSeverName == gameServerName.HALL or ScenSeverName == gameServerName.LOGON then
                return ;
            end
        end
    end
    for k = 1, 2 do
        for i = 1, #changeobjtab do
            changeobjtab[i]:SetActive(false);
        end
        coroutine.wait(0.2);
        if ScenSeverName == gameServerName.HALL or ScenSeverName == gameServerName.LOGON then
            return ;
        end
        for i = 1, #changeobjtab do
            changeobjtab[i]:SetActive(true);
        end
        coroutine.wait(0.2);
    end
    if ScenSeverName == gameServerName.HALL or ScenSeverName == gameServerName.LOGON then
        return ;
    end
    for i = 1, #Strawberry_GameNet.byPrizeImg do
        if Strawberry_GameNet.byPrizeImg[i] == num then
            local obj = self.MidObj.transform:GetChild(i - 1).gameObject;
            local data = self.friutbl[num + 1]
            obj.transform:Find("Num").gameObject:SetActive(true);
            obj.transform:Find("Num/Text"):GetComponent("Text").text = data;
            local runnum = data;
            local donum = 1;
            local starttime = 0.3
            local rotenum = 3;
            obj.transform:Find("MidLight").gameObject:SetActive(false);
            while
            runnum > 0
            do
                obj.transform:Find("Num/Text"):GetComponent("Text").text = data;
                self.NowWinNum = self.NowWinNum + Strawberry_ChipList[Strawberry_MainPanel.chipnum] * 9
                --   error("当前金币=====" .. self.NowWinNum .. ",runnum=====" .. runnum .. ",Strawberry_GameNet.WinNum=====" .. Strawberry_GameNet.WinNum);
                if self.NowWinNum >= Strawberry_GameNet.WinNum then

                    Strawberry_MainPanel.SetWinAin(false)
                    runnum = 0;
                    self.NowWinNum = Strawberry_GameNet.WinNum
                end
                Strawberry_MainPanel.PlayMusic("score1")
                Strawberry_MainPanel.NumToImg(self.NowWinNum, Strawberry_MainPanel.Win)
                runnum = runnum - donum;
                data = data - donum;
                if rotenum == 0 then
                    rotenum = 3;
                    donum = donum + 1;
                end
                rotenum = rotenum - 1;
                if starttime ~= 0.08 then
                    starttime = starttime - 0.02
                end ;
                coroutine.wait(starttime);

                if ScenSeverName == gameServerName.HALL or ScenSeverName == gameServerName.LOGON then
                    return ;
                end
            end
            obj.transform:Find("Num").gameObject:SetActive(false);
            obj.transform:Find("Num/Text"):GetComponent("Text").text = " ";
            obj.transform:Find("MidLight").gameObject:SetActive(false);
        end
    end
    self.NowWinNum = Strawberry_GameNet.WinNum;
    Strawberry_MainPanel.NumToImg(self.NowWinNum, Strawberry_MainPanel.Win)
    Strawberry_MainPanel.SetWinAin(false)
    coroutine.wait(1);
    self.SendGameStart()
end

-- 给服务发送准备消息
function Strawberry_MaryPanel.SendGameStart()
    if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then
        if GameManager.IsStopGame then
            return 
         end
        Strawberry_GameNet.RoteMarySendInfo()
    end
end


-- 获取到服务器消息
function Strawberry_MaryPanel.GetGameResult()
    -- 开始转动
    self.RunningF();
    for i = 1, self.MidObj.transform.childCount do
        local obj = self.MidObj.transform:GetChild(i - 1).gameObject;
        faobj = obj.transform:Find("Rote/Image").gameObject;
        local allnum = faobj.transform.childCount - 1
        faobj.transform:GetChild(allnum):GetComponent("Image").sprite = Strawberry_MainPanel.FruitImg.transform:GetChild(Strawberry_GameNet.byPrizeImg[i]):GetComponent("Image").sprite
    end
end

-- 结算消息
function Strawberry_MaryPanel.SCGetResult()
    if self.marypanel == nil then
        return
    end
    self.marypanel:SetActive(false)
    Strawberry_MainPanel.mainpanel:SetActive(true)
    Strawberry_MainPanel.SetWinAin(false)
end
