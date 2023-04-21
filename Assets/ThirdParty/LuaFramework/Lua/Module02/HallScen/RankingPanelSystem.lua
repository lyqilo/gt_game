--[[require "Common/define"
require "Data/gameData"
require "Data/DataStruct"
require "module02/unitPublic"]]


RankingPanelSystem = { }
local self = RankingPanelSystem;
local _luaBehaviour = nil;
RankingPanelSystem.FromRankingSystem = false;
local PlayerPrefeb;
local num = 0;
self.isreqdata = false;
-- 判断排行榜滑动
ShowPlayerBL = true;
local starposx = 0;
local endpos = 0;
local dragnum = 10;
local startendpos = 0;
self.DragRank = false;
self.initInfoNum = 1;
self.FirstRank = { };
RankTab = { };
RankTabVIP = { };
local yesterday = { };
local yesterdayVIP = { };
local GoldRankTab = { };
self.StartTime = 0;
self.RankText = " "
self.updatetimetext = " "
self.ShowRankNum=100;
local RankObj = { };
local iscreatnewobj = false;
-- ===========================================排行榜信息系统======================================
function RankingPanelSystem.Open()

    self.ShowRankNum = HallScenPanel.GetShowRankNum();
    
    iscreatnewobj = false;
    if HallScenPanel.MidCloseBtn == self.ClosePanel then return end
    
    RankObj = { };
   if self.ShowRankNum~=0 then  if #RankTab == 0 then SetShowGame.GetRankInfo(); end end
    if HallScenPanel.MidCloseBtn ~= nil then HallScenPanel.MidCloseBtn(); HallScenPanel.MidCloseBtn = nil end
    if self.RankingPanel == nil then
        self.initInfoNum = 1;
        self.RankingPanel = "obj";
        self.OnCreacterChildPanel_Ranking(HallScenPanel.Pool("RankingPanel"));
    end
    log("=================================排行榜==================================");
end

-- 创建UI的子面板_排行面板
function RankingPanelSystem.OnCreacterChildPanel_Ranking(prefab)
    local go = prefab;
    log("=================================排行榜==================================2");
    go.name = "RankingPanel";
    go.transform:SetParent(HallScenPanel.Compose.transform);
    go.transform.localScale = Vector3.New(1, 1, 1);
    go.transform.localPosition = Vector3.New(900, 0, 0);
    self.Bg = go.transform:Find("Bg").gameObject;
    self.Bg.transform.localScale = Vector3.New(1, 1, 1);
    self.RankingPanel = go;
    HallScenPanel.LastPanel = self.RankingPanel
    HallScenPanel.SetXiaoGuo(self.RankingPanel)
    HallScenPanel.MidCloseBtn = self.ClosePanel
    RankingPanelSystem.Init(self.RankingPanel, HallScenPanel.LuaBehaviour);
    HallScenPanel.SetBtnInter(true);
    log("=================================排行榜==================================2");
end

-- 创建显示排行榜信息
function RankingPanelSystem.ShowRankInfo(prefeb)
    local go = prefeb;
    go.name = "Bg";
    go.transform:SetParent(self.RankingPanel.transform);
    go.transform.localScale = Vector3.New(1, 1, 1);
    go.transform.localPosition = Vector3.New(0, 0, 0);
    log("=================================排行榜==================================3");
end

--- 接受服务器传来的排行榜信息
function RankingPanelSystem.SetRank(wSubID, buffer)
	do return end 
error("wSubID========================="..wSubID);
    if wSubID == MH.SUB_3D_SC_RANKTOP_GOLD_START then
        RankingPanelSystem.waitnum = -10;
        GoldRankTab = { };
        RankTabVIP = { };
        local num = buffer:ReadUInt32()
        if num == 0 then
            num = "暂未上榜"
        elseif num > 0 then
            num = "第" .. num .. "名"
        end
        self.RankText = "我的排名：" .. num;
        local str = " ";
        -- 年
        str = buffer:ReadUInt16() .. "年";
        str = str .. buffer:ReadUInt16() .. "月";
        local week = buffer:ReadUInt16();
        str = str .. buffer:ReadUInt16() .. "日";
        local hour = buffer:ReadUInt16()
        if hour == 0 then str = str .. "00:"; end
        if hour < 10 and hour > 0 then str = str .. "0" .. hour .. ":"; end
        if hour >= 10 then str = str .. hour .. ":"; end

        local mi = buffer:ReadUInt16()
        if mi == 0 then str = str .. "00:"; end
        if mi < 10 and mi > 0 then str = str .. "0" .. mi .. ":"; end
        if mi >= 10 then str = str .. mi .. ":"; end

        local second = buffer:ReadUInt16()
        if second == 0 then str = str .. "00"; end
        if second < 10 and second > 0 then str = str .. "0" .. second; end
        if second >= 10 then str = str .. second; end
        self.updatetimetext = str;
        self.mydw.text = self.RankText
        self.updatetime.text = "更新时间：" .. self.updatetimetext
    elseif wSubID == MH.SUB_3D_SC_RANKTOP_GOLD then
        local data = GetS2CInfo(SC_RankTopGold, buffer)
        table.insert(GoldRankTab, data);
        table.insert(RankTabVIP, tostring(GoldRankTab[#GoldRankTab][1]));
        table.insert(RankTabVIP, "0");
        RankTab = GoldRankTab
        if #self.FirstRank < 9 then
            table.insert(self.FirstRank, data);
            RankingPanelSystem.CreatPlayer(#GoldRankTab);
        else
        end
        if gameIsOnline and #GoldRankTab < 51 then
            SetShowGame.RankPlayerInfo(#GoldRankTab, data)
        end
    elseif wSubID == MH.SUB_3D_SC_RANKTOP_GOLD_STOP then
        RankTab = GoldRankTab
        log("rank data  receive end");
        -- RankingPanelSystem.UpdateRankNum();
        local num = 9;
        if #RankTab < 10 then num = #RankTab end
        for i = 1, num do
            RankingPanelSystem.CreatPlayer(i);
        end
        if self.playerRankNum ~= nil then
            self.playerRankNum:GetComponent('Text').text = "暂未上榜";
            for i = 1, #GoldRankTab do
                if GoldRankTab[i][1] == SCPlayerInfo._01dwUser_Id then
                    self.playerRankNum:GetComponent('Text').text = "富豪榜第" .. i .. "名";
                end;
            end
        end
        --        SetShowGame.RankMid.gameObject:SetActive(true);
        if #RankTab < 51 then
            SetShowGame.SethallShowPanel(#RankTab)
        end
    end

end

function RankingPanelSystem.SetyesterdayRank(wSubID, buffer)
    if wSubID == MH.SUB_3D_SC_RANKWIN_YESTERDAY_START then
        RankingPanelSystem.waitnum = -10;
        error("MH.SUB_3D_SC_RANKWIN_YESTERDAY_START===============")
        yesterday = { }
        yesterdayVIP = { };
        local num = buffer:ReadUInt32()
        if num == 0 then
            num = "暂未上榜"
        elseif num > 0 then
            num = "第" .. num .. "名"
        end
        self.yesterdayRankText = "我的排名：" .. num;
        local str = " ";
        -- 年
        str = buffer:ReadUInt16() .. "年";
        str = str .. buffer:ReadUInt16() .. "月";
        local week = buffer:ReadUInt16();
        str = str .. buffer:ReadUInt16() .. "日";
        str = str .. buffer:ReadUInt16() .. ":";
        str = str .. buffer:ReadUInt16() .. ":";
        str = str .. buffer:ReadUInt16();
        self.yesterdayupdatetimetext = str;
        self.mydw.text = self.yesterdayRankText
        self.updatetime.text = "更新时间：" .. self.yesterdayupdatetimetext
    elseif wSubID == MH.SUB_3D_SC_RANKWIN_YESTERDAY then
        RankTab = yesterday
        local data = GetS2CInfo(SC_RankWin_Yesterday, buffer)
        table.insert(yesterday, data);
        table.insert(yesterdayVIP, tostring(yesterday[#yesterday][1]));
        table.insert(yesterdayVIP, "0");
        if #self.FirstRank < 9 then
            table.insert(self.FirstRank, data);
            RankingPanelSystem.CreatPlayer(#yesterday);
            -- error("yesterday================="..#yesterday[#yesterday])
            -- error("yesterday[#yesterday][12]================"..yesterday[#yesterday][12])
        else
        end
    elseif wSubID == MH.SUB_3D_SC_RANKWIN_YESTERDAY_STOP then
        RankTab = yesterday
        for i = 1, 9 do
            if self.FirstRank[i][1] ~= yesterday[i][1] then
                RankingPanelSystem.CreatPlayer(i);
            end
        end
        if self.playerRankNum ~= nil then
            self.playerRankNum:GetComponent('Text').text = "暂未上榜";
            for i = 1, #yesterday do
                if yesterday[i][1] == SCPlayerInfo._01dwUser_Id then
                    self.playerRankNum:GetComponent('Text').text = "富豪榜第" .. i .. "名";
                end;
            end
        end
    end

end

function RankingPanelSystem.showGoldRank(num)
    local endpos = num;
    if num == nil then endpos = 9 end
    if endpos > #RankTab then endpos = #RankTab end
    local num2 = self.InfoParset.transform.childCount
    if #RankTab >(num2 + 3) then endpos = num2 + 3 end
    for i = 1, endpos do
        RankingPanelSystem.CreatPlayer(i);
    end
end
function RankingPanelSystem.SendTime()
    starttime = starttime + Time.deltaTime;
    if starttime > 30 then
        FramePopoutCompent.Show("获取排行榜信息失败,请稍后再试。")
        isSendRankSocket = true; starttime = 0; return;
    end;
end

function RankingPanelSystem.Init(obj, LuaBehaviour)
    local t = obj.transform;
    self.RankingPanel = obj;
    _luaBehaviour = LuaBehaviour;
    starposx = 0;
    endpos = 0;
    dragnum = 10;
    startendpos = 0;

    -- 初始化面板
    self.FirstName = t:Find("Bg/Bg/First/Name"):GetComponent('Text');
    self.FirstHeadImg = t:Find("Bg/Bg/First/Head").gameObject;
    self.FirstInfoBtn = t:Find("Bg/Bg/First/InfoBtn").gameObject;
    self.FirstNum = t:Find("Bg/Bg/First/Num"):GetComponent('Text');
    t:Find("Bg/Bg/First/Num"):GetComponent('RectTransform').sizeDelta=Vector2.New(0,0)
    self.FirstGold = t:Find("Bg/Bg/First/Gold"):GetComponent('Text');

    self.SecondName = t:Find("Bg/Bg/Second/Name"):GetComponent('Text');
    self.SecondHeadImg = t:Find("Bg/Bg/Second/Head").gameObject;
    self.SecondInfoBtn = t:Find("Bg/Bg/Second/InfoBtn").gameObject;
    self.SecondNum = t:Find("Bg/Bg/Second/Num"):GetComponent('Text');
    t:Find("Bg/Bg/Second/Num"):GetComponent('RectTransform').sizeDelta=Vector2.New(0,0)
    self.SecondGold = t:Find("Bg/Bg/Second/Gold"):GetComponent('Text');

    self.ThirdName = t:Find("Bg/Bg/Third/Name"):GetComponent('Text');
    self.ThirdHeadImg = t:Find("Bg/Bg/Third/Head").gameObject;
    self.ThirdInfoBtn = t:Find("Bg/Bg/Third/InfoBtn").gameObject;
    self.ThirdNum = t:Find("Bg/Bg/Third/Num"):GetComponent('Text');
    t:Find("Bg/Bg/Third/Num"):GetComponent('RectTransform').sizeDelta=Vector2.New(0,0)
    self.ThirdGold = t:Find("Bg/Bg/Third/Gold"):GetComponent('Text');

    self.Mask = t:Find("Bg/Bg/Mask/Mask").gameObject;
    self.CloseBtn = t:Find("CloseBtn").gameObject;
    self.LeftDrag = t:Find("Bg/Bg/Left").gameObject;
    self.RightDrag = t:Find("Bg/Bg/Right").gameObject;
    self.LeftBigDrag = t:Find("Bg/Bg/LeftBig").gameObject;
    self.RightBigDrag = t:Find("Bg/Bg/RightBig").gameObject;
    self.LeftDrag:GetComponent('Image').enabled = false;
    self.LeftBigDrag:GetComponent('Image').enabled = false;
    self.InfoParset = t:Find("Bg/Bg/Mask/Mask/MainInfo").gameObject;
    self.ScolleMask = t:Find("Bg/Bg/Mask").gameObject;
    -- 添加滑动触发事件
    self.R_scroolRect_listerner = Util.AddComponent("EventTriggerListener", self.ScolleMask);
    --self.R_scroolRect_listerner.onBeginDrag = self.rankBeginDrag
    --self.R_scroolRect_listerner.onDrag = self.rankDrag;
    --self.R_scroolRect_listerner.onEndDrag = self.onendDrag;
    -- 个人
    self.DragPos = self.InfoParset.transform.localPosition.x;
    self.LeftDrag:GetComponent('Image').enabled = false;
    self.LeftBigDrag:GetComponent('Image').enabled = false;
    self.RightBigDrag:GetComponent('Image').enabled = false;
    self.RightDrag:GetComponent('Image').enabled = false;
    self.DragPos = RankingPanelSystem.InfoParset.transform.localPosition.x;

    -- 赋值左侧玩家个人信息
    self.playername = t:Find("Bg/Name/Text").gameObject;
    self.playersex = t:Find("Bg/Sex/Text").gameObject;
    self.playerGold = t:Find("Bg/Gold/Text").gameObject;
    self.playerTicket = t:Find("Bg/Ticket/Text").gameObject;
    self.playerRankNum = t:Find("Bg/RankNum/Text").gameObject;
    self.playerWord = t:Find("Bg/Word/Text").gameObject;
    self.playerHead = t:Find("Bg/PlayerImg/PlayerImg").gameObject;
    -- 添加字体颜色
    AddUTColor(self.playername);
    AddUTColor(self.playersex);
    AddUTColor(self.playerGold);
    AddUTColor(self.playerTicket);
    AddUTColor(self.playerRankNum);
    -- /HeadImg/Image
    self.playerHead:GetComponent('Image').sprite = HallScenPanel.Compose.transform:Find("HeadImg/Image/Image/Image"):GetComponent('Image').sprite;
    self.playerGold:GetComponent('Text').text = self.showNumberText(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD))
    self.playerTicket:GetComponent('Text').text = self.showNumberText(gameData.GetProp(enum_Prop_Id.E_PROP_TICKET))
    self.playername:GetComponent('Text').text = SCPlayerInfo._05wNickName;
    local sextxt = "男"
    if SCPlayerInfo._02bySex == enum_Sex.E_SEX_WOMAN then sextxt = "女" end
    self.playersex:GetComponent('Text').text = sextxt;
    self.playerWord:GetComponent('Text').text = SCPlayerInfo._08wSign;
    self.RankBtn = t:Find("Bg/RankBtn").gameObject;
    self.WinBtn = t:Find("Bg/WinBtn").gameObject;
    self.mydw = t:Find("Bg/myrank"):GetComponent('Text');
    self.updatetime = t:Find("Bg/updatetime"):GetComponent('Text');
    -- SCPlayerInfo._02bySex
    -- 绑定事件
    LuaBehaviour:AddClick(self.RankBtn, self.RankBtnOnClick);
    LuaBehaviour:AddClick(self.WinBtn, self.WinBtnOnClick);
    LuaBehaviour:AddClick(self.CloseBtn, self.ClosePanel);
    LuaBehaviour:AddClick(self.RightDrag, self.ShowLeftOrRightDrag);
    LuaBehaviour:AddClick(self.RightBigDrag, self.ShowLeftOrRightDrag);
    LuaBehaviour:AddClick(self.LeftBigDrag, self.ShowLeftOrRightDrag);
    LuaBehaviour:AddClick(self.LeftDrag, self.ShowLeftOrRightDrag);
    PlayerPrefeb = self.InfoParset.transform:GetChild(0).gameObject;
    self.RankBtn:GetComponent("Button").interactable = false;
    self.WinBtn:GetComponent("Button").interactable = true;
    -- if #RankTab > 0 then

    --     self.UpdateRankNum()
    --     self.showGoldRank();
    -- end
    HallScenPanel.MidCloseBtn = self.ClosePanel
    log("=================================排行榜==================================4");
end
function RankingPanelSystem.UpdateRankNum()
   -- if #RankTab < 100 then return end
    local randnumtab = { };
    local oldRankTab = RankTab;
    for i = 1, #oldRankTab do
        if oldRankTab[i][12] == 0 and toInt64(oldRankTab[i][4]) >= toInt64(2000000000) then
            table.insert(randnumtab, #randnumtab + 1, oldRankTab[i])
        end
    end
    for k = 1, #randnumtab do
        local shownum = math.random(1, #randnumtab)
        if shownum == k then shownum = math.random(1, #randnumtab) end
        local olddata = randnumtab[k]
        local newdata = randnumtab[shownum]
        randnumtab[k] = newdata;
        randnumtab[shownum] = olddata;
    end
    local num = 1;
    for i = 1, #RankTab do
        if RankTab[i][12] == 0 and toInt64(oldRankTab[i][4]) >= toInt64(2000000000) then
            RankTab[i] = randnumtab[num]
            num = num + 1;
        end
    end
    local count=SetShowGame.RankMid.transform.childCount
    local num=#RankTab;
    if num>50 then num=50; end
    for i = 1, num do
       -- if i > count then return end
        SetShowGame.RankPlayerInfo(i, RankTab[i])
    end
    log("=================================排行榜==================================5");
end

function RankingPanelSystem.RankBtnOnClick()
    self.RankBtn:GetComponent("Button").interactable = false;
    self.WinBtn:GetComponent("Button").interactable = true;

    if #GoldRankTab > 0 then
        self.mydw.text = self.RankText
        self.updatetime.text = "更新时间：" .. self.updatetimetext
        RankTab = GoldRankTab
        local num = self.InfoParset.transform.childCount
        if num > #RankTab then
            num = #RankTab
            for i = #RankTab + 1, self.InfoParset.transform.childCount do
                self.InfoParset.transform:GetChild(i - 1).gameObject:SetActive(false);
            end
        end
        self.showGoldRank(num);
    end
end

function RankingPanelSystem.WinBtnOnClick()
    self.RankBtn:GetComponent("Button").interactable = true;
    self.WinBtn:GetComponent("Button").interactable = false;
    if #yesterday == 0 then
        local buffer = ByteBuffer.New();
        Network.Send(MH.MDM_3D_ASSIST, MH.SUB_3D_CS_RANKWIN_YESTERDAY, buffer, gameSocketNumber.HallSocket);
    else
        self.mydw.text = self.yesterdayRankText
        self.updatetime.text = "更新时间：" .. self.yesterdayupdatetimetext
        RankTab = yesterday
        local num = self.InfoParset.transform.childCount
        if num > #RankTab then
            num = #RankTab
            for i = #RankTab + 1, self.InfoParset.transform.childCount do
                self.InfoParset.transform:GetChild(i - 1).gameObject:SetActive(false);
            end
        end
        self.showGoldRank(num);
    end
end

-- 隐藏或显示页面
function RankingPanelSystem.ShowPanel(g)
    local t = g.transform;
    if (t.localPosition.y > 100) then
        t.transform.localPosition = Vector3.New(0, 0, 0);
        self.StartListenRank = true;
    else
        t.localPosition = Vector3.New(0, 1000, 0);
        self.StartListenRank = false;
    end
end

function RankingPanelSystem.ShowLeftOrRightDrag(args)
    if self.isreqdata == false then
        if string.find(args.name, "Right") then
            self.DragMove = 1;
            self.requserdata();
        elseif string.find(args.name, "Left") then
            self.DragMove = -1;
            self.requserdata();
        end
    end
end

-- 关闭页面
function RankingPanelSystem.ClosePanel()
	logError("关闭页面=================")
    HallScenPanel.PlayeBtnMusic();
    SetHeadImg=false;
    -- 恢复被禁用的状态
    self.DragRank = false;
    RankTab = GoldRankTab
    for i = 1, #self.FirstRank do
        self.FirstRank[1] = RankTab[1]
    end
    self.ShowPanel(self.RankingPanel);
    destroy(self.RankingPanel);
    self.InfoParset = nil;
    self.RankingPanel = nil;
end

-- 显示金钱
function RankingPanelSystem.showNumberText(numInt)
    return unitPublic.showNumberText(numInt);

end
-- 开始滑动位置
local BPos = nil;
local EPos = nil;
local very = -3887
function RankingPanelSystem.rankBeginDrag(obj, data)
    if self.ShowRankNum==0 then return end
    if dragnum > 100 or dragnum < 10 then dragnum = 10; return end
    starposx = self.InfoParset.transform.localPosition.y
    -- error("starposx======================="..starposx);
    self.DragRank = false;
    BPos = RankObj[1].transform.position.y;
end
-- 滑动中位置
function RankingPanelSystem.rankDrag(obj, data)
    -- 临时计算方法，通过初始化位置，滑动位置中位置，获取当前子物体移动
    if self.ShowRankNum==0 then return end
    local nowp = self.InfoParset.transform.localPosition.y;
    local s = math.ceil((nowp - very) / 85)
    for i = 1, #RankObj do
        local go = RankObj[i].transform;
        if i < s then
            go.gameObject:SetActive(false);
        elseif i > s + 6 then
            go.gameObject:SetActive(false);
        else
            go.gameObject:SetActive(true);
        end
    end
    if dragnum > 100 or dragnum < 10 then dragnum = 10; return end
    endpos = RankObj[1].transform.position.y;

    if starposx > endpos and endpos > 0 then
        if starposx - endpos < -20 then
            starposx = self.InfoParset.transform.localPosition.y;
            self.CreatPlayerTwo(dragnum);
            dragnum = dragnum + 1;
        end
    elseif endpos < 0 then
        if endpos - starposx > 20 then
            starposx = self.InfoParset.transform.localPosition.y;
            self.CreatPlayerTwo(dragnum);
            dragnum = dragnum + 1;
        end
    end
    --     local ConstY1=30;
    --     local ConstY2=-30;
    --   --UP
    --   if endpos >BPos then
    --   error("up");
    --     for i=1,#RankObj do
    --        local go=RankObj[i].transform;
    --        if go.position.y > ConstY1 then go.gameObject:SetActive(false); end
    --        if go.position.y > ConstY2 then go.gameObject:SetActive(true); end
    --     end
    --   end

    --   --Down
    --   if endpos <endpos then
    --     for i=1,#RankObj do
    --        local go=RankObj[i].transform;
    --        if go.position.y < ConstY1 then go.gameObject:SetActive(true); end
    --        if go.position.y < ConstY2 then go.gameObject:SetActive(false); end
    --     end
    --   end
    --   BPos=endpos;
end


-- 结束滑动位置
function RankingPanelSystem.onendDrag(obj, data)
    if self.ShowRankNum==0 then return end
    if dragnum > 100 or dragnum < 10 then dragnum = 10; return end
    endpos = self.InfoParset.transform.localPosition.y
    --  error("endpos======================="..endpos);
    startendpos = startendpos +(starposx - endpos);
    if startendpos < -20 then
        if startendpos < -100 then
            startendpos = 0;
            starposx = self.InfoParset.transform.localPosition.y;
            for i = 1, 40 do
                self.CreatPlayerTwo(dragnum);
                dragnum = dragnum + 1;
            end
        else
            startendpos = 0;
            starposx = self.InfoParset.transform.localPosition.y;
            for i = 1, 20 do
                self.CreatPlayerTwo(dragnum);
                dragnum = dragnum + 1;
            end
        end
    elseif startendpos > 60 then
        --        startendpos = 0;
        --        starposx = self.InfoParset.transform.localPosition.x;
        --        dragnum = dragnum - 1;
        --        self.NoActivePlayerTwo()
    end
    self.DragRank = true;
    EPos = data.position;
end



function RankingPanelSystem.requserdata()
    self.isreqdata = true;
    if self.DragMove > 0 then
        local numi = self.InfoParset.transform.childCount - 1;
        local endobj = self.InfoParset.transform:GetChild(numi)
        local startnum = tonumber(endobj:Find("Num"):GetComponent('Text').text)
        endnum = startnum + 5;
        startnum = startnum + 1;
        if endnum > 100 then
            startnum = 96
            endnum = 100

            self.LeftDrag:GetComponent('Image').enabled = true;
            self.LeftBigDrag:GetComponent('Image').enabled = true;
            self.RightBigDrag:GetComponent('Image').enabled = false;
            self.RightDrag:GetComponent('Image').enabled = false;
        else
            self.LeftDrag:GetComponent('Image').enabled = true;
            self.LeftBigDrag:GetComponent('Image').enabled = true;
            self.RightBigDrag:GetComponent('Image').enabled = true;
            self.RightDrag:GetComponent('Image').enabled = true;
        end
        local num = 0;
        for i = startnum, endnum do
            RankingPanelSystem.CreatDragPlayer(i, num)
            num = num + 1;
        end
        self.isreqdata = false;
    else
        -- if self.DragMove < 0 then
        local endobj = self.InfoParset.transform:GetChild(0)
        local endtnum = endobj:Find("Num"):GetComponent('Text').text
        local startnum = endtnum - 5;
        endnum = endtnum - 1;
        if endnum < 0 or startnum < 4 then
            startnum = 4
            endnum = 8
            self.LeftDrag:GetComponent('Image').enabled = false;
            self.LeftBigDrag:GetComponent('Image').enabled = false;
            self.RightBigDrag:GetComponent('Image').enabled = true;
            self.RightDrag:GetComponent('Image').enabled = true;
        else
            self.LeftDrag:GetComponent('Image').enabled = true;
            self.LeftBigDrag:GetComponent('Image').enabled = true;
            self.RightBigDrag:GetComponent('Image').enabled = true;
            self.RightDrag:GetComponent('Image').enabled = true;
        end
        local num = 0;
        for i = startnum, endnum do
            RankingPanelSystem.CreatDragPlayer(i, num)
            num = num + 1;
        end
        self.isreqdata = false;
    end

end

-- 点击显示玩家信息
function RankingPanelSystem.PlayerInfo(obj)
    local num = tonumber(obj.transform.parent:Find("Num"):GetComponent('Text').text);
    local father = obj.transform.parent;
    PlayerInfoSystem.SelectUserInfo(RankTab[num][1], nil, father.transform:Find("Head").gameObject);
    --    obj:GetComponent('Button'):Select();
    --
    --     if RankTab[num][6]==enum_Sex.E_SEX_MAN then
    --        self.playerHead.transform:GetComponent('Image').sprite=HallScenPanel.nanSprtie;
    --        elseif RankTab[num][6]==enum_Sex.E_SEX_WOMAN then
    --        self.playerHead.transform:GetComponent('Image').sprite=HallScenPanel.nvSprtie
    --        end
    --    if RankTab[num][7] == 0 then
    --        UrlHeadImgP = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/0" .. RankTab[num][6] .. ".png";
    --    else
    --        UrlHeadImgP = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/" .. RankTab[num][1] .. "." .. RankTab[num][9];
    --        local headstr1 = RankTab[num][1] .. "." .. RankTab[num][9];
    --        UpdateFile.downHead(UrlHeadImgP, headstr1, nil, self.playerHead);
    --    end
    --    self.playerGold:GetComponent('Text').text = self.showNumberText(RankTab[num][4])
    --    self.playerTicket:GetComponent('Text').text = self.showNumberText(RankTab[num][5])
    --    self.playername:GetComponent('Text').text = RankTab[num][3];
    --    self.playerWord:GetComponent('Text').text = RankTab[num][11];
    --    local sextxt = "男"
    --    if RankTab[num][6] == enum_Sex.E_SEX_WOMAN then sextxt = "女" end
    --    self.playersex:GetComponent('Text').text = sextxt;
    --    self.playerRankNum:GetComponent('Text').text = "暂未上榜";
    --    for i = 1, #RankTab do
    --        if RankTab[i][1] == RankTab[num][1] then
    --            self.playerRankNum:GetComponent('Text').text = "富豪榜第" .. i .. "名";
    --        end;
    --    end
end

local SetHeadImg=false;
self.headid=0;
self.downheadtime=0;

function RankingPanelSystem.CreatPlayer(num)
    local UrlHeadImgF;
    local UrlHeadImgS;
    local UrlHeadImgT;
    local headstr;
    if num > #RankTab then
        return;
    end
    if self.InfoParset == nil then return end
    self.initInfoNum = num;
    headstr = RankTab[1][6];
    if num == 1 then
        if RankTab[1][7] == 0 then
            if headstr == enum_Sex.E_SEX_MAN then
                self.FirstHeadImg.transform:GetComponent('Image').sprite = HallScenPanel.nanSprtie;
            elseif headstr == enum_Sex.E_SEX_WOMAN then
                self.FirstHeadImg.transform:GetComponent('Image').sprite = HallScenPanel.nvSprtie
            else
                self.FirstHeadImg.transform:GetComponent('Image').sprite = HallScenPanel.nvSprtie
            end
        else
            UrlHeadImgF = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/" .. RankTab[1][1] .. "." .. RankTab[1][9];
            headstr = RankTab[1][1] .. "." .. RankTab[1][9];
            UpdateFile.downHead(UrlHeadImgF, headstr, nil, self.FirstHeadImg);
           -- error("非默认头像=======================" .. headstr);
        end

        self.FirstName.text = RankTab[1][3];
        self.FirstInfoBtn.name = num;
        self.FirstNum.text = tostring(num);
        self.FirstGold.text = unitPublic.showNumberText(RankTab[1][4]);
        --        if #RankTab[1] == 12 then
        --            self.FirstGold.text = unitPublic.showNumberText(RankTab[1][12]);
        --        end
        _luaBehaviour:AddClick(self.FirstInfoBtn, self.PlayerInfo);
        self.mydw.text = self.RankText
        self.updatetime.text = "更新时间：" .. self.updatetimetext
        self.headid = 1; SetHeadImg = false;
    elseif num == 2 then
        headstr = RankTab[2][6];
        if RankTab[2][7] == 0 then
            if headstr == enum_Sex.E_SEX_MAN then
                self.SecondHeadImg.transform:GetComponent('Image').sprite = HallScenPanel.nanSprtie;
            elseif headstr == enum_Sex.E_SEX_WOMAN then
                self.SecondHeadImg.transform:GetComponent('Image').sprite = HallScenPanel.nvSprtie
            else
                self.SecondHeadImg.transform:GetComponent('Image').sprite = HallScenPanel.nvSprtie
            end
        else
            UrlHeadImgS = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/" .. RankTab[2][1] .. "." .. RankTab[2][9];
            headstr = RankTab[2][1] .. "." .. RankTab[2][9];
            UpdateFile.downHead(UrlHeadImgS, headstr, nil, self.SecondHeadImg);
        end
        self.SecondName.text = RankTab[2][3];
        self.SecondInfoBtn.name = num;
        self.SecondNum.text = tostring(num);
        self.SecondGold.text = unitPublic.showNumberText(RankTab[2][4]);
        --        if #RankTab[2] == 12 then
        --            self.SecondGold.text = unitPublic.showNumberText(RankTab[2][12]);
        --        end
        _luaBehaviour:AddClick(self.SecondInfoBtn, self.PlayerInfo);

    elseif num == 3 then
        headstr = RankTab[3][6];
        if RankTab[3][7] == 0 then
            if headstr == enum_Sex.E_SEX_MAN then
                self.ThirdHeadImg.transform:GetComponent('Image').sprite = HallScenPanel.nanSprtie;
            elseif headstr == enum_Sex.E_SEX_WOMAN then
                self.ThirdHeadImg.transform:GetComponent('Image').sprite = HallScenPanel.nvSprtie
            else
                self.ThirdHeadImg.transform:GetComponent('Image').sprite = HallScenPanel.nvSprtie
            end
        else
            UrlHeadImgT = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/" .. RankTab[3][1] .. "." .. RankTab[3][9];
            headstr = RankTab[3][1] .. "." .. RankTab[3][9];
            UpdateFile.downHead(UrlHeadImgT, headstr, nil, self.ThirdHeadImg);
        end
        self.ThirdName.text = RankTab[3][3];
        self.ThirdInfoBtn.name = num;
        self.ThirdNum.text = tostring(num);
        self.ThirdGold.text = unitPublic.showNumberText(RankTab[3][4]);
        --        if #RankTab[3] == 12 then
        --            self.ThirdGold.text = unitPublic.showNumberText(RankTab[3][12]);

        --        end
        _luaBehaviour:AddClick(self.ThirdInfoBtn, self.PlayerInfo);
    else
        self.CreatDragPlayer(num, num - 4);
        if self.InfoParset ~= nil then _luaBehaviour:AddClick(self.InfoParset.transform:GetChild(num - 4):Find("Panel/InfoBtn").gameObject, self.PlayerInfo); end


    end
    self.ThirdHeadImg.transform:GetComponent('Image').sprite = HallScenPanel.GetHeadIcon();

end
function RankingPanelSystem.CreatDragPlayer(num, i)
    local UrlHeadImgP;
    if self.InfoParset ~= nil then
        local go = self.InfoParset.transform:GetChild(i):Find("Panel");
        if #RankObj < 6 then
            table.insert(RankObj, go);
        end
        local btnname = num;
        local name = go.transform:Find("Num"):GetComponent('Text').text
        go.transform.localScale = Vector3.one;
        go.transform:Find("Name"):GetComponent('Text').text = RankTab[num][3];
        go.transform:Find("Num"):GetComponent('Text').text = tostring(num);
        go.transform:Find("Gold"):GetComponent('Text').text =tostring(RankTab[num][4]);
        go:Find("InfoBtn"):GetComponent('Button').interactable = true;
        --        if #RankTab[num] == 12 then
        --            go.transform:Find("Gold"):GetComponent('Text').text = RankTab[num][12];
        --        end
        if num>10 then return end
        local headstrsave4 = RankTab[num][6];
        if RankTab[num][7] == 0 then
            if headstrsave4 == enum_Sex.E_SEX_MAN then
                go.transform:Find("Head"):GetComponent('Image').sprite = HallScenPanel.nanSprtie;
            elseif headstrsave4 == enum_Sex.E_SEX_WOMAN then
                go.transform:Find("Head"):GetComponent('Image').sprite = HallScenPanel.nvSprtie
            else
                go.transform:GetComponent('Image').sprite = HallScenPanel.nvSprtie
            end
        else
            UrlHeadImgP = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/" .. RankTab[num][1] .. "." .. RankTab[num][9];
            local headstr1 = RankTab[num][1] .. "." .. RankTab[num][9];
            UpdateFile.downHead(UrlHeadImgP, headstr1, nil, go.transform:Find("Head").gameObject);
        end
        go.transform:Find("Head"):GetComponent('Image').sprite = HallScenPanel.GetHeadIcon();
    end
end
function RankingPanelSystem.CreatPlayerTwo(num)
    local UrlHeadImgP;
    if iscreatnewobj then return end
    if num == 100 then iscreatnewobj = true end
    if self.InfoParset ~= nil then
        if num > #RankTab then return end
        if num > self.InfoParset.transform.childCount then
            local go = newobject(self.InfoParset.transform:GetChild(0).gameObject);
            go.transform:SetParent(self.InfoParset.transform);
            go.transform.localScale = Vector3.New(1, 1, 1);
            go.transform.localPosition= Vector3.New(1, 1, 1);
            go = go.transform:Find("Panel");
            table.insert(RankObj, go);
            local btnname = num;
            go.transform:Find("Name"):GetComponent('Text').text = RankTab[num][3];
            go.transform:Find("Num"):GetComponent('Text').text = tostring(num);
            go.transform:Find("Gold"):GetComponent('Text').text =tostring(RankTab[num][4]);
            go.transform:Find("InfoBtn"):GetComponent('Button').interactable = true;
            _luaBehaviour:AddClick(go.transform:Find("InfoBtn").gameObject, self.PlayerInfo);
            --            if #RankTab[num] == 12 then
            --                go.transform:Find("Gold"):GetComponent('Text').text = RankTab[num][12];
            --            end
            local headstrsave4 = RankTab[num][6];
            if headstrsave4 == enum_Sex.E_SEX_MAN then
                go.transform:Find("Head"):GetComponent('Image').sprite = HallScenPanel.nanSprtie;
            elseif headstrsave4 == enum_Sex.E_SEX_WOMAN then
                go.transform:Find("Head"):GetComponent('Image').sprite = HallScenPanel.nvSprtie
            else
                go.transform:GetComponent('Image').sprite = HallScenPanel.nvSprtie
            end
            if RankTab[num][7] == 0 then
                UrlHeadImgP = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/0" .. RankTab[num][6] .. ".png";
            else
             if SetHeadImg == true then return end
             SetHeadImg = true;
             self.headid=num;
                UrlHeadImgP = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/" .. RankTab[num][1] .. "." .. RankTab[num][9];
                local headstr1 = RankTab[num][1] .. "." .. RankTab[num][9];
                UpdateFile.downHead(UrlHeadImgP, headstr1, self.GetHeadSuccess, go.transform:Find("Head").gameObject);
            end
        else
            --  self.InfoParset.transform:GetChild(num - 1).gameObject:SetActive(true);
        end
    end
end

function RankingPanelSystem.GetHeadSuccess()
    if self.RankingPanel == nil then self.headid=1 SetHeadImg = false return end
    self.headid = self.headid + 1
   -- error("self.headid==============="..self.headid.."#RankTab============="..#RankTab)
    if self.headid > #RankTab then self.headid=1 SetHeadImg = false return end
  --  error("self.headid==============="..self.headid.."RankTab[self.headid][7]==============="..RankTab[self.headid][7]);
    if RankTab[self.headid][7] ~= 0 then
        local UrlHeadImgP = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/" .. RankTab[self.headid][1] .. "." .. RankTab[self.headid][9];
        local headstr1 = RankTab[self.headid][1] .. "." .. RankTab[self.headid][9];
        if #RankTab < self.headid then self.headid=1 SetHeadImg = false return end
        if self.InfoParset.transform.childCount< self.headid then SetHeadImg = false return end
        self.downheadtime = 0;
        if self.RankingPanel == nil then self.headid=1 SetHeadImg = false return end
        UpdateFile.downHead(UrlHeadImgP, headstr1, self.GetHeadSuccess, self.InfoParset.transform:GetChild(self.headid - 4).transform:Find("Panel/Head").gameObject);

    end
end

function RankingPanelSystem.AddDownTime()
    if not SetHeadImg then return end
    if self.RankingPanel == nil then SetHeadImg = false self.downheadtime = 0; return end
    self.downheadtime = self.downheadtime + 0.02
    if self.downheadtime > 0.3 then self.downheadtime = 0; self.GetHeadSuccess() end
end

function RankingPanelSystem.NoActivePlayerTwo()
    if dragnum < 10 then return end
    -- error("dragnum=================="..dragnum.."总大小==="..self.InfoParset.transform.childCount);
    --   self.InfoParset.transform:GetChild(dragnum - 4).gameObject:SetActive(false);
end

function RankingPanelSystem.RankUpdate()
    if self.RankingPanel == nil then  return end
    if #RankObj==0 then return end
    if self.DragRank then
        if self.InfoParset == nil or self.RankingPanel == nil then self.DragRank = false return end;
        RankingPanelSystem.rankDrag()
    end
end
