SetShowGame = {}
local self = SetShowGame
local ConstSorting = { 7, 40, 44, 42, 41, 43, 21, 14, 5, 22, 13, 16, 18, 24, 25, 28, 17, 27, 19, 3, 8, 20, 32, 33, 38, 39, 45, 46, 47, 51, 53, 54, 55, 48, 49 }
--local ConstSorting = { 6,42, 41,48,19,3,43,46,47,51,53,54}--54
--21,7,14,5,22,13,16,18,24,25,28,17,27,19,8,20,3
-- 3=开心牛牛
-- 5=金蟾捕鱼,
-- 7=李逵劈鱼,
-- 8=飞禽走兽,
-- 13=功夫熊猫,
-- 14=白蛇传,
-- 16=纸牌老虎机,
-- 17=楚河汉界,
-- 18=水浒传,
-- 19=澳门21点,
-- 20=免佣百家乐,
-- 21=3D捕鱼,
-- 22=水果777,
-- 24=龙珠探宝,
-- 25=草莓老虎机,
-- 27=财神降临,
-- 28=福临门,
-- 32=点球大战
-- 33=虎啸龙吟
-- 38=战国史记
-- 39=淘金者

self._moveX = { 267, 267, 390, 347, 480, 264, 269 }

self.moveIndex = { 0, 0, 0, 0, 0, 0, 0 }
local Height = 225 + 20
local RowCount = 1
local Width = 750
local noOpenGames = {} -- 没有开放的游戏
local RankList = {}
self.NeedDownModuleName = {}
self.downing = false
self.PanelID = 1;

self._MovePos={
    {-220,115,0},
    {220,115,0},
    {-275,-120,0},
    {-10,-120,0},
    {255,-120,0},
}

self._UPMovePos={
    {-300,500,0},
    {300,500,0},
    {-300,-500,0},
    {-10,-500,0},
    {300,-500,0},
}

self.games_lb = {}
self.GAMES = {}

--大厅显示那些游戏，-代表敬请期待
function SetShowGame.Open()
    -- hall1代表游戏显示顺序
    self.NeedUpdate = true
    self.GetRank = false
    self.isInit = true
    self.IsDownGame = {}
    self.NeedUpdate = true

    local issort = true
    if issort then
        coroutine.start(self.SortShowImg)
    else
        local Sort = self.GetSorting()
        for i = 1, #Sort do
            if string.find(Sort[i], "-") then
                Sort[i] = string.gsub(Sort[i], "-", "")
                table.insert(noOpenGames, #noOpenGames + 1, Sort[i])
            end

            if Sort[i] == "21" or Sort[i] == 21 then
                Sort[i] = "51";
            end
            Sort[i] = tonumber(Sort[i])
        end
        ConstSorting = Sort
        self.OnCreate(HallScenPanel.Pool("GameImg"))
    end
end

--获取服务器数据重新排序
function SetShowGame.SortShowImg()
    local Sort = ConstSorting
    for i = 1, #Sort do
        if string.find(Sort[i], "-") then
            Sort[i] = string.gsub(Sort[i], "-", "")
            -- table.insert(noOpenGames, #noOpenGames + 1, Sort[i])
        end
        if Sort[i] == "21" or Sort[i] == 21 then
            Sort[i] = "51";
        end
        Sort[i] = tonumber(Sort[i])
    end

    while HttpData == nil do
        coroutine.wait(0.1)
    end

    table.insert(self.GAMES, #self.GAMES + 1, self.games_lb)
    logTable(self.GAMES)

    local Sorting = {}
    for j = 1, #self.GAMES do
        local Sorting2 = {}

        for i = 1, #self.GAMES[j] do
            if string.find(self.GAMES[j][i], "-") then
                local temp = string.gsub(self.GAMES[j][i], "-", "")
                if self.IsInTable(tonumber(temp), ConstSorting) then
                    if temp == "21" then
                        temp = "51";
                    end
                    table.insert(noOpenGames, #noOpenGames + 1, temp)
                    table.insert(Sorting2, #Sorting2 + 1, temp)
                end
            else
                if self.GAMES[j][i] == "21" or self.GAMES[j][i] == 21 then
                    self.GAMES[j][i] = 51;
                end
                --if self.IsInTable(self.GAMES[j][i], ConstSorting) then
                table.insert(Sorting2, #Sorting2 + 1, self.GAMES[j][i])
                -- end
            end
        end
        table.insert(Sorting, #Sorting + 1, Sorting2)
    end

    ConstSorting = Sorting
    logTable(ConstSorting)
    self.OnCreate(HallScenPanel.Pool("GameImg"))
end
function SetShowGame.IsInTable(value, tbl)
    for k, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end
--拿出挂载所有游戏图片的GameObject
function SetShowGame.OnCreate(go)
    go.transform:SetParent(HallScenPanel.Compose.transform)
    go.name = "GameImg"
    go.transform.localScale = Vector3.New(1, 1, 1)
    go.transform.localPosition = Vector3.New(0, 1000, 0)
    self.GameImgObj = go
    self.GameImgObj:SetActive(false)
    -- if not Util.isPc then
    SetShowGame.Init(HallScenPanel.LuaBehaviour)
    -- end
    if #RankTab == 0 then
        self.GetRank = false
    end
    -- self.GetRankInfo();
end

--克隆图标到滚动视图
function SetShowGame.Init(LuaBehaviour)
    logYellow("==========SetShowGame============")
    self.MoveObj = HallScenPanel.Compose.transform:Find("Mid")
    self.moveRect = self.MoveObj:GetComponent("ScrollRect");
    self.pageProgress = HallScenPanel.Compose.transform:Find("Group");

    self.fixed=HallScenPanel.Compose.transform:Find("Mid/Fixed")

    self.MoveObj.gameObject:SetActive(true)
    self.MoveAllPos = HallScenPanel.Compose.transform:Find("Mid/View")
    self.GameRec = HallScenPanel.Compose.transform:Find("Mid/View/ScrollMid")

    self.GameRecImage = HallScenPanel.Compose.transform:Find("Mid/View/Image")


    self.RankPrefebObj = HallScenPanel.Compose.transform:Find("Mid/RankPrefeb").gameObject
    self.RankPrefebObj:SetActive(false)
    self.RankMid = HallScenPanel.Compose.transform:Find("Mid/View/RankMid")

    for i = 1, self.RankMid.transform.childCount do
        LuaBehaviour:AddClick(self.RankMid.transform:GetChild(i - 1).gameObject, self.SelectPlayer)
        self.RankMid.transform:GetChild(i - 1).gameObject:SetActive(gameIsOnline)
    end
    local prefeb_H = HallScenPanel.Compose.transform:Find("Mid/prefeb_H").gameObject
    local prefeb_S = HallScenPanel.Compose.transform:Find("Mid/prefeb_S").gameObject

    local groupItem = self.MoveObj:Find("Group").gameObject;

    self.JT=HallScenPanel.Compose.transform:Find("jiantou");

    --logYellow("#ConstSorting=="..tostring(#ConstSorting))
    if #ConstSorting[1] > 12 then
        self.JT:GetChild(3).gameObject:SetActive(true)
    else
        self.JT:GetChild(3).gameObject:SetActive(false)
    end

    self.MoveObj.transform.localScale=Vector3.New(GameManager.ScreenRate, GameManager.ScreenRate, GameManager.ScreenRate);
    for j = 1, #ConstSorting do
        local endnum = #ConstSorting[j]
        self.NeedUpdate = false
        local page = 0;
        self.poslist = {};

        local gameImages = self.GameImgObj.transform:GetChild(0)
        local group = nil;
        for i = 1, endnum do
            if i > 1 and (i - 2)%5==0 then
                page = page + 1;
                if page > self.GameRec.childCount then
                    group = newObject(groupItem);
                    group.transform:SetParent(self.GameRec);
                    group.transform.localScale = Vector3.New(1, 1, 1);
                else
                    group = self.GameRec:GetChild(page-1);
                end
                group.transform.localPosition = Vector3.New((page * 930 + 930 / 2), 0, 0)

            end

            local go = nil;
            if i==2 or i==3 or i==7 or i==8 or i==12 or i==13 then
                go = newobject(prefeb_H);
            else
                go = newobject(prefeb_S);
            end

           if i==1 then
                go.transform:SetParent(self.fixed:Find("Image"));
                go.transform.localPosition = Vector3.New(50, 0, 0);
           else
                go.transform:SetParent(group.transform);
                if page==1 then
                    group.transform:GetChild(group.transform.childCount-1).localPosition=Vector3.New(self._MovePos[group.transform.childCount][1],self._MovePos[group.transform.childCount][2],self._MovePos[group.transform.childCount][3])
                else
                    group.transform:GetChild(group.transform.childCount-1).localPosition=Vector3.New(self._UPMovePos[group.transform.childCount][1],self._UPMovePos[group.transform.childCount][2],self._UPMovePos[group.transform.childCount][3])
                end
           end
            go.transform.localScale = Vector3.New(1,1,1);

            local cs = go.transform:Find("Panel").gameObject:AddComponent(typeof(CsJoinLua))
            cs:LoadLua("Module02.HallScen.InCamer", "InCamer")
            local ico = go.transform:Find("Consle/ICO").gameObject
            local configer = GameManager.PassClientIndexToConfiger(ConstSorting[j][i])
            local moduleScenName = configer.scenName
            local go1 = newobject(gameImages.transform:Find(moduleScenName).gameObject)
            go1.transform:SetParent(ico.transform)
            go1.transform.localScale = Vector3.New(1, 1, 1)
            go1.transform.localPosition = Vector3.New(0, 0, 0)

            if go1.transform:GetComponent("BaseBehaviour") ~= nil then
                destroy(go1.transform:GetComponent("BaseBehaviour"));
            end

            go.name = moduleScenName
            ico.name = moduleScenName
            ico:GetComponent("Image").color = Color.New(1, 1, 1, 0);
            go.transform:Find("Consle/tx").gameObject:SetActive(false)
            LuaBehaviour:AddClick(ico, self.ChooseGmaeId)
            local t = GameManager.PassScenNameToConfiger(go.name)
            local isopen = false
            for k = 1, #noOpenGames do
                if tostring(t.clientId) == tostring(noOpenGames[k]) then
                    isopen = true
                end
            end
            go.transform:Find("Consle/bg/open").gameObject:SetActive(isopen)
        end
    end
    local trigger = Util.AddComponent("EventTriggerListener", self.MoveObj.gameObject)
    trigger.onBeginDrag = self.OnBeginDragMidObj;
    trigger.onEndDrag = self.OnEndDragMidObj

    LuaBehaviour:AddClick(self.JT1, self.OnClickLeft);
    LuaBehaviour:AddClick(self.JT2, self.OnClickRight);
    self.totalPage = self.GameRec.childCount;
    self.currentpage = 0;
    self.pageIndex = 0;
    self.isMove = false;
    self.lastplaynum = nil
    self.ShowHalltx()
    local shownum = 0
    self.SethallShowPanel(shownum)
end
self.moveTweener = nil;
self.tweener = nil;
self.startPos = nil;
self.endPos = nil;
self.poslist = {};
self.currentpage = 0;
self.needpos = 0;
function SetShowGame.OnClickLeft()
    logYellow("-------左滑---------")

    if self.moveTweener ~= nil then
        return ;
    end
    self.currentpage = self.currentpage - 1;
    if self.currentpage<0 then
        self.currentpage=0
        return;
    end
    SetShowGame.SetMovePos(self.currentpage)
    for i=1,self.GameRec:GetChild(self.currentpage).childCount do
        local _pos=Vector3.New(self._MovePos[i][1],self._MovePos[i][2],self._MovePos[i][3])
        self.GameRec:GetChild(self.currentpage):GetChild(i-1):DOLocalMove(_pos,0.35);
     end

end
function SetShowGame.OnClickRight()
    logYellow("-------右滑---------")
    if self.moveTweener ~= nil then
        return ;
    end
    self.currentpage = self.currentpage + 1;
    if self.currentpage > self.totalPage-1 then
        self.currentpage =self.totalPage-1;
        return;
    end
    SetShowGame.SetMovePos(self.currentpage)
    for i=1,self.GameRec:GetChild(self.currentpage).childCount do
        local _pos=Vector3.New(self._MovePos[i][1],self._MovePos[i][2],self._MovePos[i][3])
        self.GameRec:GetChild(self.currentpage):GetChild(i-1):DOLocalMove(_pos,0.35);
     end
end

function SetShowGame.OnBeginDragMidObj()
    self.isMove = false;
    self.startPos = self.GameRecImage.localPosition;
end
function SetShowGame.OnEndDragMidObj()
    logYellow("---------滑动结束--------------")
    self.endPos = self.GameRecImage.localPosition;
    if self.endPos.x - self.startPos.x <-20 then
        self.OnClickRight();
    elseif self.endPos.x - self.startPos.x > 20 then
        self.OnClickLeft();
    else

    end
end
self.isMove = false;
function SetShowGame.Update()

end

function SetShowGame.SetMovePos(index)
    for i=0,self.GameRec.childCount-1 do
        if index==i then
            self.GameRec:GetChild(i).gameObject:SetActive(true);
            for j=1,self.GameRec:GetChild(i).childCount do
                local _pos=Vector3.New(self._UPMovePos[j][1],self._UPMovePos[j][2],self._UPMovePos[j][3])
                self.GameRec:GetChild(i):GetChild(j-1).localPosition=_pos
            end
        else
            self.GameRec:GetChild(i).gameObject:SetActive(false);
            self.GameRec:GetChild(i).gameObject:SetActive(false);
        end
    end
end

function SetShowGame.ShowRank(bl)
    if not (gameIsOnline) then
        return
    end
    if (IsNil(self.RankMid)) then
        return
    end
    -- 优化darg call高
    -- self.RankMidChild0=self.RankPrefebObj;
    -- self.RankMid.gameObject:SetActive(bl);
end

function SetShowGame.SelectPlayer(obj)
    obj = obj.transform.parent
    local num = tonumber(obj.transform:Find("Num"):GetComponent("Text").text)
    PlayerInfoSystem.SelectUserInfo(RankTab[num][1], nil, obj.transform:Find("Head").gameObject)
end

function SetShowGame.GetRankInfo()
    if not (gameIsOnline) then
        return
    end
    local num = HallScenPanel.GetShowRankNum()
    if num == 0 then
        return
    end
    if #RankTab == 0 then
        local buffer = ByteBuffer.New()
        buffer:WriteUInt32(0) -- 请求排行榜数据HZ123
        Network.Send(MH.MDM_3D_ASSIST, MH.SUB_3D_CS_RANKTOP_GOLD, buffer, gameSocketNumber.HallSocket)
        return
    end
    RankingPanelSystem.UpdateRankNum()
end
local SetHeadImg = false
self.headid = 0
self.downheadtime = 0
self.LastRankID = {}
function SetShowGame.RankPlayerInfo(num, data)
    if not (gameIsOnline) then
        return
    end
    if self.MoveObj == nil then
        return
    end
    if SetShowGame.isInit == nil then
        if not self.MoveObj.gameObject.activeSelf then
            return
        end
        if self.RankPrefebObj == nil then
            return
        end
    end
    if not self.MoveObj.gameObject.activeSelf then
        --[[    if num > self.RankMid.transform.childCount then 
        return 
        end--]]
    end
    if num == 1 then
        self.headid = 1
        SetHeadImg = false
        RankList = {}
    end
    local go = nil
    if num > #RankTab then
        return
    end
    if num > self.RankMid.transform.childCount then
        logError("排行榜子数据测试  》》》》》》》》》》》》》   1")
        go = newobject(self.RankPrefebObj)
        logError("排行榜子数据测试  》》》》》》》》》》》》》   2")
        go:SetActive(true)
        go.transform:SetParent(self.RankMid)
        logError("排行榜子数据测试  》》》》》》》》》》》》》   3")
        go.transform.localPosition = Vector3.New(0, 0, 0)
        go.transform.localScale = Vector3.New(1, 1, 1)
        logError("排行榜子数据测试  》》》》》》》》》》》》》   4")
        -- local cs = go.transform:Find("Panel").gameObject:AddComponent(typeof(CsJoinLua));
        local cs = Util.AddComponent("CsJoinLua", go.transform:Find("Panel").gameObject)
        logError("排行榜子数据测试  》》》》》》》》》》》》》   5")

        cs:LoadLua("Module02.HallScen.InCamer", "InCamer")

        logError("排行榜子数据测试  》》》》》》》》》》》》》   6")
        go.transform:Find("Consle/Num"):GetComponent("Text").text = num
        go.transform:Find("Consle/Name"):GetComponent("Text").text = data.wNickName
        local ico = go.transform:Find("Consle/ICO").gameObject
        logError("排行榜子数据测试  》》》》》》》》》》》》》   7")
        HallScenPanel.LuaBehaviour:AddClick(ico, self.SelectPlayer)
        logError("排行榜子数据测试  》》》》》》》》》》》》》   8")
    else
        go = self.RankMid.transform:GetChild(num - 1).gameObject
        go:SetActive(true)
    end

    logError("排行榜子数据测试  》》》》》》》》》》》》》   9")
    table.insert(RankList, go)
    logError("排行榜子数据测试  》》》》》》》》》》》》》   10")
    if #self.LastRankID < 50 then
        table.insert(self.LastRankID, data.uiGameId)
    end
    logError("排行榜子数据测试  》》》》》》》》》》》》》   11")
    go.transform:Find("Consle/Num"):GetComponent("Text").text = num
    logError("排行榜子数据测试  》》》》》》》》》》》》》   12")
    go.transform:Find("Consle/Name"):GetComponent("Text").text = data.dwGold
    logError("排行榜子数据测试  》》》》》》》》》》》》》   13")
    if go == nil then
        return
    end
    logError("排行榜子数据测试  》》》》》》》》》》》》》   14")
    go.name = num
    --[[local headstrsave4 = data[6];
        if data[7] == 0 then
            if go == nil then return end
            if headstrsave4 == enum_Sex.E_SEX_MAN then
                go.transform:Find("Consle/Head"):GetComponent('Image').sprite = HallScenPanel.nanSprtie;
            elseif headstrsave4 == enum_Sex.E_SEX_WOMAN then
                go.transform:Find("Consle/Head"):GetComponent('Image').sprite = HallScenPanel.nvSprtie
            end
        else
            if SetHeadImg == true then return end
            SetHeadImg = true;
            self.headid = num;
            local UrlHeadImgP = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/" .. data[1] .. "." .. data[9];
            local headstr1 = data[1] .. "." .. data[9];
            if go == nil then return end
            UpdateFile.downHead(UrlHeadImgP, headstr1, self.GetHeadSuccess, go.transform:Find("Consle/Head").gameObject);
        end--]]
end

function SetShowGame.ChangeHeadImg(id, name)
    if self.LastRankID < 20 then
        return
    end
    local num = nil
    for i = 1, #self.LastRankID do
        if self.LastRankID[i] == id then
            num = i
        end
    end
    if num == nil then
        return
    end
end

function SetShowGame.GetHeadSuccess()
    self.headid = self.headid + 1
    if self.headid > #RankList then
        SetHeadImg = false
        return
    end
    if self.headid > 50 then
        SetHeadImg = false
        return
    end
    if RankTab[self.headid][7] ~= 0 then
        local UrlHeadImgP = SCSystemInfo._2wWebServerAddress ..
                "/" .. SCSystemInfo._4wHeaderDir .. "/" .. RankTab[self.headid][1] .. "." .. RankTab[self.headid][9]
        local headstr1 = RankTab[self.headid][1] .. "." .. RankTab[self.headid][9]
        if #RankList < self.headid then
            SetHeadImg = false
            return
        end
        self.downheadtime = 0
        UpdateFile.downHead(
                UrlHeadImgP,
                headstr1,
                self.GetHeadSuccess,
                RankList[self.headid].transform:Find("Consle/Head").gameObject
        )
    end
end

function SetShowGame.AddDownTime()
    if not SetHeadImg then
        return
    end
    self.downheadtime = self.downheadtime + 0.02
    if self.downheadtime > 0.3 then
        self.downheadtime = 0
        self.GetHeadSuccess()
    end
end

function SetShowGame.SethallShowPanel(allnum)
    local allLen = (math.ceil(allnum / 4)) * 200 + 10
    local fatherwid = self.MoveObj:GetComponent("RectTransform").sizeDelta
    local num = (#ConstSorting)
    --if allnum==0 then num=num+3; end
    -- local v2y =(Height * math.ceil(num / RowCount)) +120+450
    local v2y = (Height * math.ceil(num / RowCount))
    self.RankMid:GetComponent("RectTransform").sizeDelta = Vector2.New(Width, allLen)
    --self.MoveAllPos:GetComponent("RectTransform").sizeDelta = Vector2.New(Width, v2y + allLen)
    local pos = self.MoveAllPos.transform.localPosition
    --self.MoveAllPos.localPosition = Vector3.New(pos.x, (fatherwid.y - (v2y + allLen) - 30) / 2, 0)
    -- 获取初始化
    self.MidPos = Vector3.New(pos.x, (fatherwid.y - (v2y + allLen) - 30) / 2, 0)
    self.RankMid.localPosition = Vector3.New(0, -v2y / 2, 0)
    if allnum > self.RankMid.transform.childCount then
        return
    end
    for i = allnum, self.RankMid.transform.childCount - 1 do
        self.RankMid.transform:GetChild(i).gameObject:SetActive(false)
    end
end
function SetShowGame.HallBeginDrag()
    if self.GetRank then
        return
    end
end
function SetShowGame.HallDrag()
    if self.GetRank then
        return
    end
    local a = (self.MoveAllPos.localPosition.y - self.MidPos.y)
    if not self.GetRank then
        if a > Height then
            self.GetRank = true
            self.GetRankInfo()
            return
        end
    end
end
function SetShowGame.HallendDrag()
    if self.GetRank then
        return
    end
    local a = (self.MoveAllPos.localPosition.y - self.MidPos.y)
    if not self.GetRank then
        if a > Height then
            self.GetRank = true
            self.GetRankInfo()
            return
        end
    end
end

-- 滑动
function SetShowGame.LeftOrRight(xishu)
    -- local x = self.GameRec.transform.localPosition.x + xishu * (wid / 2)
    -- self.GameRec.transform:DOLocalMoveX(x, 0.2, false)
end

function SetShowGame.Show()
end

--控制图标上的光
function SetShowGame.ShowHalltx()
    local function play()
        local allcont = self.GameRec.transform.childCount
        if self.lastplaynum ~= nil then
            for i = 1, self.txshownum do
                local j = self.lastplaynum + (i - 1) * self.txshownum - 1
                if j < 0 then
                    j = 0
                end
                if j >= #ConstSorting then
                    j = #ConstSorting - 1
                end
                if j >= allcont then
                    j = allcont - 1
                end
                --  self.GameRec.transform:GetChild(j):Find("Consle/tx").gameObject:SetActive(false)
            end
        end
        local num = math.random(1, #ConstSorting)
        self.txshownum = math.random(1, 5)
        for i = 1, self.txshownum do
            local j = num + (i - 1) * self.txshownum - 1
            if j < 0 then
                j = 0
            end
            if j >= #ConstSorting then
                j = #ConstSorting - 1
            end
            if j >= allcont then
                j = allcont - 1
            end
            coroutine.wait(0.1)
            --self.GameRec.transform:GetChild(j):Find("Consle/tx").gameObject:SetActive(true)
        end
        self.lastplaynum = num
        coroutine.wait(1.5)
        self.ShowHalltx()
    end
    coroutine.start(play)
end

-----------------------------------------------------------------点击进游戏图标--------------------------------------------------------------
function SetShowGame.ChooseGmaeId(obj)
    if (SCPlayerInfo.IsVIP == 1) then
        MessageBox.CreatGeneralTipsPanel("VIP玩家无法进入游戏")
        return
    end
    --if Util.isPc then
    --    MessageBox.CreatGeneralTipsPanel("该平台无法进入游戏")
    --    return
    --end
    obj.transform:GetComponent("Button").interactable = false
    local t = GameManager.PassScenNameToConfiger(obj.name)
    self.DownGameId(obj)
end

-- 用协程判断
function SetShowGame.DownGameId(obj)
    local t = GameManager.PassScenNameToConfiger(obj.name)
    if t == nil then
        logError("get " .. obj.name .. " launch moduleConfiger is nil")
        return
    end
    GameNextScenName = t.scenName
    self.servername = t.uiName;
    local id = string.gsub(t.scenName, "module", "");
    self.AllGameOnClick(obj, tonumber(id));
    obj.transform:GetComponent('Button').interactable = true;
end

function SetShowGame.AllGameOnClick(obj, uiName)
    HallScenPanel.PlayeBtnMusic()
    local go = obj.transform.parent.parent;
    --for i = 1, self.GameRec.transform.childCount do
    --    for j = 1, self.GameRec.transform:GetChild(i - 1).childCount do
    --        log("child:"..self.GameRec.transform:GetChild(i - 1):GetChild(j - 1).name);
    --        go = self.GameRec.transform:GetChild(i - 1):GetChild(j - 1):Find(obj.name);
    --        if go ~= nil then
    --            break ;
    --        end
    --    end
    --end
    if go ~= nil then
        self.choosenum = go.gameObject
    else
        error("没找到" .. t.scenName);
        return ;
    end
    if self.choosenum.transform:Find("Consle/bg/open").gameObject.activeSelf then
        return
    end

    if self.choosenum.transform:Find("Consle/bg").gameObject.activeSelf then
        local f = function()
            -- obj:GetComponent("Button").onClick:RemoveAllListeners()
            --   table.insert(self.NeedDownModuleName, #self.NeedDownModuleName + 1, obj)
            -- self.choosenum.transform:Find("Consle/bg/hei/liang"):GetComponent("Image").fillAmount = 0
            -- self.choosenum.transform:Find("Consle/bg/hei").gameObject:SetActive(true)
            -- self.choosenum.transform:Find("Consle/bg/down").gameObject:SetActive(false)
            --self.StartDownMethod(obj)
            obj.transform:GetComponent("Button").interactable = true
            Event.Brocast(PanelListModeEven._014gameRoomListPanel, uiName)
        end

        if true then
            f()
            return
        end
        -- 以下是苹果审核用的，下载资源要提示
        --[[        local Pop = FramePopoutCompent.Pop.New();
        Pop._02conten = "下载图片资源需要消耗流量";
        Pop._05yesBtnCallFunc = f;
        Pop._07module = LaunchModuleConfiger.Module02;
        FramePopoutCompent.Add(Pop);
        obj.transform:GetComponent('Button').interactable = true;--]]
        return
    else
        obj.transform:GetComponent("Button").interactable = true
        Event.Brocast(PanelListModeEven._014gameRoomListPanel, uiName)
    end
end

function SetShowGame.StartDownMethod(objbtn)
    local downover = nil
    local t = GameManager.PassScenNameToConfiger(objbtn.name)
    local setobjbtn = objbtn
    local chooseobj = self.GameRec.transform:Find(objbtn.name).gameObject
    --local showobj = chooseobj.transform:Find("Consle/bg/hei/liang")
    -- local showobjtext = chooseobj.transform:Find("Consle/bg/hei/liang/Text"):GetComponent("Text")
    local downname = t.scenName
    local callback = function(a, b, obj)
        local downSize = tostring(a)
        downSize = tonumber(downSize)
        -- showobj:GetComponent("Image").fillAmount = downSize
        -- error("downSize====================="..downSize);
        local num = math.floor((downSize) * 100)
        --showobjtext.text = num .. "%"
        if downSize == 1 then
            log(string.format("下载 %s 完成!", t.uiName))
            local f = function()
                --showobjtext.text = "100%"
                coroutine.wait(1)
                --LuaManager.loader:AddBundleLua();
                self.NeedDown(obj)
                setobjbtn.transform:GetComponent("Button").interactable = true
                if downover ~= nil then
                    destroy(downover)
                end
                setobjbtn:GetComponent("Button").onClick:RemoveAllListeners()
                HallScenPanel.LuaBehaviour:AddClick(setobjbtn, self.ChooseGmaeId)
            end
            coroutine.start(f)
        end

        -- 下载出错
        if downSize < 0 then
            error("下载当前游戏失败")
            if #self.NeedDownModuleName == 0 then
                error("没有需要下载得东西")
                return
            end
            self.downing = false
            -- error("去下第二个");
            SetShowGame.NeedDown(obj)
            setobjbtn.transform:GetComponent("Button").interactable = true
            setobjbtn:GetComponent("Button").onClick:RemoveAllListeners()
            HallScenPanel.LuaBehaviour:AddClick(setobjbtn, self.ChooseGmaeId)
        end
    end

    local f = function(a, b)
        callback(a, b, chooseobj)
    end

    downover = UpdateFile.UnityWebRequestAsync(downname, f)
    local del = function()
        local chooseobj = self.GameRec.transform:Find(setobjbtn.name).gameObject
        self.NeedDown(chooseobj)
        setobjbtn:GetComponent("Button").onClick:RemoveAllListeners()
        -- setobjbtn:GetComponent("Button").onClick:AddListener(self.ChooseGmaeId)
        HallScenPanel.LuaBehaviour:AddClick(setobjbtn, self.ChooseGmaeId)
        if not IsNil(downover) then
            destroy(downover.gameObject)
        end
    end
    setobjbtn:GetComponent("Button").onClick:AddListener(del)
    -- chooseobj.transform:Find("Consle/bg/hei/wait").gameObject:SetActive(false)
    setobjbtn.transform:GetComponent("Button").interactable = true
end

function SetShowGame.DownCallBack(a, b, obj)
    local downSize = tostring(a)
    downSize = tonumber(downSize)
    self.showobj:GetComponent("Image").fillAmount = downSize
    local num = math.floor((downSize) * 100)
    self.showobjtext.text = num .. "%"
    if downSize == 1 then
        log("下载进度：100%")
        local f = function()
            self.showobjtext.text = "100%"
            coroutine.wait(1)
            -- LuaInterface.LuaFileUtils.Instance:Dispose();
            -- LuaManager.loader=SuperLuaFramework.LuaLoader.New();
            --LuaManager.loader:AddBundleLua();
            if #self.NeedDownModuleName == 0 then
                error("没有需要下载得东西")
                return
            end
            -- local obj = self.GameRec.transform:Find(self.NeedDownModuleName[1].name).gameObject;
            -- self.NeedDown(obj);
            -- obj.transform:Find("Consle/bg/hei/liang/Text"):GetComponent("Text").text = " "
            -- obj.transform:Find("Consle/bg/down").gameObject:SetActive(false)
            obj.transform:Find("Consle/bg/open").gameObject:SetActive(false)
            -- obj.transform:Find("Consle/bg/hei").gameObject:SetActive(false)
            -- obj.transform:Find("Consle/bg").gameObject:SetActive(false)
            --            self.downing = false;
            --            table.remove(self.NeedDownModuleName, 1)
            --            if #self.NeedDownModuleName > 0 then self.StartDownMethod(self.NeedDownModuleName[1]) end
        end
        coroutine.start(f)
    end

    -- 下载出错
    if downSize < 0 then
        error("下载当前游戏失败")
        if #self.NeedDownModuleName == 0 then
            error("没有需要下载得东西")
            return
        end
        self.downing = false
        -- error("去下第二个");
        -- local obj = self.GameRec.transform:Find(self.NeedDownModuleName[1].name).gameObject
        SetShowGame.NeedDown(obj)
        --        table.remove(self.NeedDownModuleName, 1)
        --        if #self.NeedDownModuleName > 0 then
        --            self.StartDownMethod(self.NeedDownModuleName[1])
        --        end
    end
end

self.IsDownGame = {}
-- 判断是否需要下载（显示遮罩）
function SetShowGame.NeedDown(obj)
    local needDown = false
    local t = GameManager.PassScenNameToConfiger(obj.name)
    -- if t ~= nil then
    --     needDown = UpdateFile.isDown(t.scenName)
    --     if not needDown then
    --         table.insert(self.IsDownGame, t.scenName)
    --         UpdateFile.SaveFile(t.scenName)
    --     end
    -- end
    local isopen = false
    for i = 1, #noOpenGames do
        if tostring(t.clientId) == tostring(noOpenGames[i]) then
            isopen = true
        end
    end

    if needDown then
        --     obj.transform:Find("Consle/bg/hei/liang/Text"):GetComponent("Text").text = " "
        --     obj.transform:Find("Consle/bg").gameObject:SetActive(true)
        --     obj.transform:Find("Consle/bg/hei").gameObject:SetActive(false)
        obj.transform:Find("Consle/bg/down").gameObject:SetActive(not isopen)
        --     obj.transform:Find("Consle/bg/open").gameObject:SetActive(isopen)
    else
        --     obj.transform:Find("Consle/bg/hei/liang/Text"):GetComponent("Text").text = " "
        --     obj.transform:Find("Consle/bg/down").gameObject:SetActive(false)
        obj.transform:Find("Consle/bg/open").gameObject:SetActive(isopen)
        --     obj.transform:Find("Consle/bg/hei").gameObject:SetActive(false)
        --     obj.transform:Find("Consle/bg").gameObject:SetActive(isopen)
    end
end

-- 直接把所有得设置未下载
function SetShowGame.SetAllGameNoDown()
    if self.GameRec == nil then
        return
    end
    local function setshown(setobj)
        setobj.transform:Find("Consle/bg").gameObject:SetActive(true)
        --setobj.transform:Find("Consle/bg/hei").gameObject:SetActive(false)
        --setobj.transform:Find("Consle/bg/down").gameObject:SetActive(true)
        setobj.transform:Find("Consle/bg/open").gameObject:SetActive(false)
    end
    self.IsDownGame = {}
    for i = 1, self.GameRec.transform.childCount do
        local setobj = self.GameRec.transform:GetChild(i - 1).gameObject
        self.NeedDown(setobj)
    end
end
-- 下载完毕回调方法
function SetShowGame.DownOverCallBack(num)
    if num ~= nil then
        self.choosenum = num
    end
    SetShowGame.NeedDown(self.choosenum)
end

-- 更新File完毕回调方法
function SetShowGame.UpdateFileCallBack()
    logError("更新File完毕回调方法")
    SetShowGame.NeedDown(self.choosenum)
    --obj.transform:Find("Consle/bg/down").gameObject:SetActive(false)
    obj.transform:Find("Consle/bg").gameObject:SetActive(false)
end

-- 判断是否更新
function SetShowGame.CheckGameFile()
    local a = UpdateFile.ChickUpdate(gameScenName.Fish3D)
    if a then
        logError("要更新")
    end
end

-- 游戏默认顺序
function SetShowGame.DefineSorting()
    local choose = ConstSorting
    local rc = Util.Read(enum_hall.hall1)
    if rc == "" then
        return choose
    end
    if rc == nil then
        return choose
    end
    local t = {}
    local data = string.split(rc, ",")
    for i = 1, #data do
        table.insert(t, data[i])
    end
    return t
end

-- 获取游戏显示顺序的配置
function SetShowGame.GetSorting()
    local choose = {}
    if true then
        return ConstSorting
    end
    if WebAppInfo == nil then
        return self.DefineSorting()
    end
    local setstr = WebAppInfo.gameOrder
    if setstr == nil then
        return self.DefineSorting()
    end
    local t = {}
    local str = ""
    for i = 0, setstr.Length - 1 do
        str = str .. setstr[i] .. ","
        table.insert(t, setstr[i])
    end
    log("get game sorting: " .. str)
    Util.Write(enum_hall.hall1, str)
    return t
end