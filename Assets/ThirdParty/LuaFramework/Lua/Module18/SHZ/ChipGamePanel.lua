ChipGamePanel={
};
local self=ChipGamePanel;
function ChipGamePanel:New()
    local t = o or { };
    setmetatable(t, self);
    self.__index = self
    self.chipinPanel=nil;
    return t;
end
function ChipGamePanel:Creat(obj)

end

function ChipGamePanel.ShowPanel()
    if self.chipinPanel ~= nil and self.chipinPanel.activeSelf then
    else
        SHZGameMangerTable[1]:ChangePanelAnimator();
    end
    SHZGameMangerTable[1].Running = true;
    if SHZGameMangerTable[1].nowshowpanel == nil then
    else
        SHZGameMangerTable[1].nowshowpanel:SetActive(false);
    end
    --    -- BigOrSmaBg
    --    local bgchip = SHZGameMangerTable[1].ChipBg.transform:GetComponent('AudioSource');
    --    MusicManager:PlayBacksoundX(bgchip.clip, true);
    MusicManager:PlayBacksound("end", false);
    if self.chipinPanel == nil then
   --  LoadAssetCacheAsync('module18/game_luashzchip', 'ChipInPanel', self.CreatScen)
   self.CreatScen(find("ChipInPanel").gameObject)
    else
        SHZGameMangerTable[1].nowshowpanel = self.chipinPanel;
        self.chipinPanel:SetActive(true);
        self.ScenInfo();
    end
    if SHZPanel.MarySelf ~= nil and SHZPanel.ChipSelf.maryPanel ~= nil then SHZPanel.MarySelf.maryPanel:SetActive(false); end
end

-- 押大小游戏结果
function ChipGamePanel.ChipGameResult()
   error("押大小结果得到--------------------------------------");
    self.pointone = SHZGameMangerTable[1].point1;
    self.pointtwo = SHZGameMangerTable[1].point2;
    self.iWinScore = SHZGameMangerTable[1].iWinScore;
    if self.pointtwo>6 then self.pointtwo=self.pointtwo-6 end
    if self.pointone>6 then self.pointone=self.pointone-6 end
    error("赋值完成");
    local str="1+1";
    if self.pointone>self.pointtwo then 
    str= tostring(self.pointtwo.."+"..self.pointone)
    else
    str= tostring(self.pointone.."+"..self.pointtwo)
    end
    self.pointSum.transform:GetComponent('Image').sprite = self.AllPointSum.transform:Find(str):GetComponent('Image').sprite    
    self.ChipPoint.transform:GetChild(0):GetComponent('Image').sprite = self.pointimg.transform:GetChild(self.pointone - 1):GetComponent('Image').sprite

    self.ChipPoint.transform:GetChild(1):GetComponent('Image').sprite = self.pointimg.transform:GetChild(self.pointtwo - 1):GetComponent('Image').sprite
    error("骰子图片替换================");

    error("开始播放================");
    self.BossAnimator:Play("open");
    error("结束播放摇晃动画================");
    if SHZGameMangerTable[1].iWinScore > 0 then
        coroutine.start(self.ChipWinAnimator);
    else
        coroutine.start(self.ChipLoseAnimator);
    end

end

function ChipGamePanel.SaveChipResult()
    local num = 1;
    if self.pointone + self.pointtwo < 7 then
        num = 1;
    elseif self.pointone + self.pointtwo == 7 then
        num = 2;
    elseif self.pointone + self.pointtwo > 7 then
        num = 3;
    end
    if #SHZGameMangerTable[1].byHisBigSma >= 20 then
        table.remove(SHZGameMangerTable[1].byHisBigSma, 1);
        table.insert(SHZGameMangerTable[1].byHisBigSma, num)
        for i = 3, self.ChipShowValue.transform.childCount - 1 do
            if SHZGameMangerTable[1].byHisBigSma[i - 2] < 4 and SHZGameMangerTable[1].byHisBigSma[i - 2] > 0 then
                self.ChipShowValue.transform:GetChild(i):GetComponent("Image").sprite = self.ChipShowValue.transform:GetChild(SHZGameMangerTable[1].byHisBigSma[i - 2] -1):GetComponent("Image").sprite;
            end
        end
        return;
    end
    local go = newobject(self.ChipShowValue.transform:GetChild(num - 1).gameObject);
    go.transform:SetParent(self.ChipShowValue.transform);
    go.transform.localScale = Vector3.one;
    go.transform.localPosition = Vector3.New(0, 0, 0);
    go:SetActive(true);
    go.name = num
    table.insert(SHZGameMangerTable[1].byHisBigSma, num)
end

function ChipGamePanel.ChipWinAnimator()
   self.ChipPoint.transform:DOMove(self.pointSum.transform.position-Vector3.New(0,0,1100), 0.01, false);
   coroutine.wait(0.02);
   if GameNextScenName == gameScenName.HALL then return end
    self.ChipPoint:SetActive(true);    
    self.pointSum:SetActive(true);
    coroutine.wait(0.1);
    if GameNextScenName == gameScenName.HALL then return end
    local he = self.pointone + self.pointtwo;
    local musicchip = SHZGameMangerTable[1].Musicprefeb.transform:Find("Point/" .. he):GetComponent('AudioSource').clip
    MusicManager:PlayX(musicchip);
    coroutine.wait(1);
    if GameNextScenName == gameScenName.HALL then return end
       local dotween=nil;
    if he > 7 then
        dotween = self.ChipPoint.transform:DOMove(self.pos.transform:GetChild(1).position, 0.5, false);
        if self.pointone == self.pointtwo then
            self.ChipChooseBtn.transform:Find("da"):GetComponent("Animator"):Play("daX4");
        else
            self.ChipChooseBtn.transform:Find("da"):GetComponent("Animator"):Play("daX2");
        end
    elseif he == 7 then
        dotween = self.ChipPoint.transform:DOMove(self.pos.transform:GetChild(1).position, 0.5, false);
        self.ChipChooseBtn.transform:Find("he"):GetComponent("Animator"):Play("he");

    elseif he < 7 then
        dotween = self.ChipPoint.transform:DOMove(self.pos.transform:GetChild(1).position, 0.5, false);
        if self.pointone == self.pointtwo then
            self.ChipChooseBtn.transform:Find("xiao"):GetComponent("Animator"):Play("xiaoX4");
        else
            self.ChipChooseBtn.transform:Find("xiao"):GetComponent("Animator"):Play("xiaoX2");
        end
    end
    self.SaveChipResult();
    self.BossAnimator:Play("win");
    local musicchip = SHZGameMangerTable[1].Musicprefeb.transform:Find("TimeWin"):GetComponent('AudioSource').clip
    MusicManager:PlayX(musicchip);
    SHZGameMangerTable[1]:NumToImage(self.ChipWin, SHZGameMangerTable[1].iWinScore, false);
    SHZGameMangerTable[1]:NumToImage(self.ChipAllxiazhu, 0, false);
    SHZGameMangerTable[1]:NumToImage(self.ChipWinShow, SHZGameMangerTable[1].iWinScore, true);
    coroutine.wait(1.2);
    if GameNextScenName == gameScenName.HALL then return end
    -- self.ChipPoint:SetActive(false);
    self.pointSum:SetActive(false);
    self.ChipWinShow:SetActive(true);
    for i = 0, 1 do
        self.ChipBtn.transform:GetChild(i):GetComponent("Button").interactable = true;
    end
    self.ChipBtn.transform:GetChild(1):DOLocalMoveY(120,0.3,false)
    for i = 2, self.ChipBtn.transform.childCount - 1 do
        self.ChipBtn.transform:GetChild(i):GetComponent("Button").interactable = false;
    end
end

function ChipGamePanel.ChipLoseAnimator()
   self.ChipPoint.transform:DOMove(self.pointSum.transform.position-Vector3.New(0,0,1100), 0.01, false);
   coroutine.wait(0.02);
   if GameNextScenName == gameScenName.HALL then return end
    self.ChipPoint:SetActive(true);
    self.pointSum:SetActive(true);
    coroutine.wait(0.1);
    if GameNextScenName == gameScenName.HALL then return end
    local he = self.pointone + self.pointtwo;
    local musicchip = SHZGameMangerTable[1].Musicprefeb.transform:Find("Point/" .. he):GetComponent('AudioSource').clip
    MusicManager:PlayX(musicchip);
    coroutine.wait(1);
    if GameNextScenName == gameScenName.HALL then return end
   local dotweenlose = nil;
--    if he > 7 then
--        dotweenlose = self.ChipPoint.transform:DOMove(self.pos.transform:GetChild(2).position, 0.5, false);
--    elseif he == 7 then
--        dotweenlose = self.ChipPoint.transform:DOMove(self.pos.transform:GetChild(1).position, 0.5, false);
--    elseif he < 7 then
        dotweenlose = self.ChipPoint.transform:DOMove(self.pos.transform:GetChild(1).position, 0.5, false);
 --   end

    self.SaveChipResult();
	logError("Boss失败了")
    self.BossAnimator:Play("lose");
	logError("Boss失败结束")
    local musicchip = SHZGameMangerTable[1].Musicprefeb.transform:Find("TimeLose"):GetComponent('AudioSource').clip
    MusicManager:PlayX(musicchip);
    coroutine.wait(0.8);
    if GameNextScenName == gameScenName.HALL then return end
    --   self.ChipPoint:SetActive(false);
    self.pointSum:SetActive(false);
    coroutine.wait(1.5);
    if GameNextScenName == gameScenName.HALL then return end
    SHZGameMangerTable[1].MainSelf.ShowPanel();
end



--比倍所有方法
function ChipGamePanel.CreatScen(obj)
    self.chipinPanel = obj;
    local parset = SHZGameMangerTable[1].shzcanvas.transform:Find("Canvas/Prefeb");
    self.chipinPanel.transform:SetParent(parset);
    self.chipinPanel.transform.localScale = Vector3.one;
    self.chipinPanel.transform.localPosition = Vector3.New(0, 0, 0);
    self.chipinPanel.name = "ChipInPanel";  
    SHZGameMangerTable[1].nowshowpanel = self.chipinPanel;
    self.ChipInFindComponent();
end
function ChipGamePanel.ChipInFindComponent()
    self.pointimg = self.chipinPanel.transform:Find("pointimg").gameObject;
    self.ChipBtn = self.chipinPanel.transform:Find("Bg/Btn").gameObject;
    self.ChipBoss = self.chipinPanel.transform:Find("Bg/Boss").gameObject;
    self.BossAnimator=self.ChipBoss:GetComponent("Animator");
    self.ChipShowInfo = self.chipinPanel.transform:Find("Bg/ShowInfo").gameObject;
    self.ChipGold = self.ChipShowInfo.transform:Find("Gold/num").gameObject;
    self.ChipAllxiazhu = self.ChipShowInfo.transform:Find("Allxiazhu/num").gameObject;
    self.ChipWin = self.ChipShowInfo.transform:Find("Win/num").gameObject;
    self.ChipWinShow = self.ChipShowInfo.transform:Find("WinShow").gameObject;
    self.ChipChooseBtn = self.chipinPanel.transform:Find("Bg/chooseBtn").gameObject;
    self.ChipPoint = self.chipinPanel.transform:Find("Bg/Point").gameObject;
    self.ChipTishi = self.chipinPanel.transform:Find("Tishi").gameObject;
    self.ChipShowValue = self.chipinPanel.transform:Find("Bg/ShowValue").gameObject;
    self.ChipChipInBtn = self.ChipBtn.transform:Find("ChipInBtn").gameObject;
    self.ChipGetBtn = self.ChipBtn.transform:Find("GetBtn").gameObject;
    self.ChipXiaoBtn = self.ChipBtn.transform:Find("XiaoBtn").gameObject;
    self.ChipHeBtn = self.ChipBtn.transform:Find("HeBtn").gameObject;
    self.ChipDaBtn = self.ChipBtn.transform:Find("DaBtn").gameObject;
    self.pointSum = self.chipinPanel.transform:Find("Bg/pointSum").gameObject;
    self.AllPointSum= self.chipinPanel.transform:Find("AllPointSum").gameObject;
    self.pos= self.chipinPanel.transform:Find("pos").gameObject;
        -- 历史押注大小
    for i = 1, #SHZGameMangerTable[1].byHisBigSma do
        if SHZGameMangerTable[1].byHisBigSma[i] < 4 and SHZGameMangerTable[1].byHisBigSma[i] >0 then
            local go = newobject(self.ChipShowValue.transform:GetChild(SHZGameMangerTable[1].byHisBigSma[i]-1).gameObject);
            go.transform:SetParent(self.ChipShowValue.transform);
            go:SetActive(true);
            go.transform.localScale = Vector3.one;
            go.transform.localPosition = Vector3.New(0, 0, 0);
            go.name = SHZGameMangerTable[1].byHisBigSma[i];
        end
    end
    -- 绑定事件
    SHZGameMangerTable[1].SHZCsJoinLua:AddClick(self.ChipChipInBtn, self.ChipInBtnOnClick);
    SHZGameMangerTable[1].SHZCsJoinLua:AddClick(self.ChipGetBtn, self.GetBtnOnClick);
    SHZGameMangerTable[1].SHZCsJoinLua:AddClick(self.ChipXiaoBtn,  self.ChooseNum);
    SHZGameMangerTable[1].SHZCsJoinLua:AddClick(self.ChipHeBtn, self.ChooseNum);
    SHZGameMangerTable[1].SHZCsJoinLua:AddClick(self.ChipDaBtn, self.ChooseNum);
    self.ScenInfo();
end

-- 初始化比倍界面数据
function ChipGamePanel.ScenInfo()
    -- 总押注数量
    self.AllPointSum:SetActive(false);
    self.pointSum:SetActive(false);
    self.ChipWinShow:SetActive(false);
    self.ChipChooseBtn:SetActive(false);
    self.ChipPoint:SetActive(false);
    self.ChipTishi:SetActive(false);
    for i = 0, 2 do
        self.ChipShowValue.transform:GetChild(i).gameObject:SetActive(false);
    end
    for i = 0, 1 do
        self.ChipBtn.transform:GetChild(i):GetComponent("Button").interactable = false;
    end
    self.ChipBtn.transform:GetChild(1):DOLocalMoveY(-150,0.1,false)
    for i = 2, self.ChipBtn.transform.childCount - 1 do
        self.ChipBtn.transform:GetChild(i):GetComponent("Button").interactable = true;
    end
    SHZGameMangerTable[1]:NumToImage(self.ChipAllxiazhu, SHZGameMangerTable[1].iWinScore, false);
    SHZGameMangerTable[1]:NumToImage(self.ChipGold, SHZGameMangerTable[1].MyselfGold, false);
    SHZGameMangerTable[1]:NumToImage(self.ChipWin, 0, false);
    -- 播放提示动画
    self.ChipTishi:SetActive(true);
    self.BossAnimator:Play("turn");
    local musicchip = SHZGameMangerTable[1].Musicprefeb.transform:Find("Tap"):GetComponent('AudioSource').clip
    MusicManager:PlayX(musicchip);
end

-- 选择押大小
function ChipGamePanel.ChipInBtnOnClick(obj)
    self.ChipWinShow:SetActive(false);
    for i = 0, 2 do
        local go = self.ChipChooseBtn.transform:GetChild(i).gameObject;
        go:SetActive(false);
        go:GetComponent("Animator"):StopRecording();
    end
    for i = 0, self.ChipBtn.transform.childCount - 1 do
        self.ChipBtn.transform:GetChild(i):GetComponent("Button").interactable = false;
    end
    
    self.ChipBtn.transform:GetChild(1):DOLocalMoveY(-150,0.1,false)
    SHZSCInfo.ChipOrGetSendInfo(1);
    SHZGameMangerTable[1]:NumToImage(self.ChipWin, 0, false);
    SHZGameMangerTable[1]:NumToImage(self.ChipAllxiazhu, SHZGameMangerTable[1].iWinScore, false);
end

-- 选择得分
function ChipGamePanel.GetBtnOnClick(obj)
    for i = 0, self.ChipBtn.transform.childCount - 1 do
        self.ChipBtn.transform:GetChild(i):GetComponent("Button").interactable = false;
    end
    self.ChipBtn.transform:GetChild(1):DOLocalMoveY(-150,0.1,false)
    self.nowGold=SHZGameMangerTable[1].MyselfGold;
    SHZSCInfo.ChipOrGetSendInfo(0);
end

function ChipGamePanel.ChooseGetScore(win)
 --   error("播得分动画======")
    SHZGameMangerTable[1]:NumToImage(self.ChipWin, SHZGameMangerTable[1].iWinScore, false);
    -- 播得分动画
    coroutine.start(self.PalyWinAnimator, win)
end


--结算动画
function ChipGamePanel.PalyWinAnimator(wingold)
local musicchip = SHZGameMangerTable[1].Musicprefeb.transform:Find("Get"):GetComponent('AudioSource').clip
        MusicManager:PlayX(musicchip);
    local jiannum = math.floor(wingold / 20);
    local startnum = wingold;
    self.ChipWinShow:SetActive(true);
        local stopnum=20;
    if wingold <= 20 then jiannum = 1; stopnum=wingold end
    for i = 1, stopnum do
   -- self.ChipWinShow.transform.localPosition=Vector3.New(0,0,0)
        startnum = startnum - jiannum;
        SHZGameMangerTable[1]:NumToImage(self.ChipWinShow, startnum, true);
        if toInt64(self.nowGold) < toInt64(SHZGameMangerTable[1].MyselfGold) then 
        self.nowGold=self.nowGold+jiannum
        SHZGameMangerTable[1]:NumToImage(self.ChipGold, self.nowGold+jiannum, false);
        end
        coroutine.wait(0.06);
        if GameNextScenName == gameScenName.HALL then return end
        if not(self.chipinPanel.activeSelf) then return end;
    end
    self.ChipWinShow:SetActive(false);
    -- 跳转到
    SHZGameMangerTable[1]:NumToImage(self.ChipGold, SHZGameMangerTable[1].MyselfGold, false);
    SHZGameMangerTable[1].iWinScore=0;
    coroutine.wait(0.1);
    if GameNextScenName == gameScenName.HALL then return end
    SHZGameMangerTable[1].MainSelf.ShowPanel();
end

--押大小 1小 2中 3大
function ChipGamePanel.ChooseNum(obj)
    for i = 0, self.ChipBtn.transform.childCount - 1 do
        self.ChipBtn.transform:GetChild(i):GetComponent("Button").interactable = false;
    end
    self.ChipBtn.transform:GetChild(1):DOLocalMoveY(-150,0.1,false)
    local choosenum = 0;
    self.ChipTishi:SetActive(false);
    self.ChipChooseBtn:SetActive(true);
    for i = 0, 2 do
        self.ChipChooseBtn.transform:GetChild(i).gameObject:SetActive(false);
    end
    if obj.name == "Big" or obj.name == "DaBtn" then
        self.ChipChooseBtn.transform:Find("da").gameObject:SetActive(true);
        choosenum = 3;
    elseif obj.name == "Mid" or obj.name == "HeBtn" then
        self.ChipChooseBtn.transform:Find("he").gameObject:SetActive(true);
        choosenum = 2;
    elseif obj.name == "Small" or obj.name == "XiaoBtn" then
        self.ChipChooseBtn.transform:Find("xiao").gameObject:SetActive(true);
        choosenum = 1;
    else
        return;
    end
    SHZSCInfo.BigOrSmaSendInfo(choosenum);
end