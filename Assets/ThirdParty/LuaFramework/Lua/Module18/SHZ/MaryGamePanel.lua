MaryGamePanel = {

};
MaryImgLuaTable={};
local self = MaryGamePanel;
function MaryGamePanel:New()
    local t = o or { };
    setmetatable(t, self);
    self.__index = self
    self.maryPanel = nil;
    return t;
end


function MaryGamePanel:Creat(obj)

end

function MaryGamePanel.ShowPanel()
    log("进入玛丽界面");
    SHZGameMangerTable[1]:ChangePanelAnimator();
    SHZGameMangerTable[1].Running = true;
    if SHZGameMangerTable[1].nowshowpanel == nil then
    else
        SHZGameMangerTable[1].nowshowpanel:SetActive(false);
    end
    if self.maryPanel == nil then
        --LoadAssetCacheAsync('module18/game_luashzmary', 'MaryPanel', self.CreatScen)
        self.CreatScen(find("MaryPanel").gameObject);
    else
        SHZGameMangerTable[1].nowshowpanel = self.maryPanel;
        self.maryPanel:SetActive(true);
        self.ScenInfo();
    end
    --    local bgchip = SHZGameMangerTable[1].MainBg.transform:GetComponent('AudioSource');
    --    MusicManager:PlayBacksoundX(bgchip.clip, true);
    MusicManager:PlayBacksound("end", false);
end

-- 玛丽游戏所有方法
function MaryGamePanel.CreatScen(obj)
    self.maryPanel=obj;
    local parset = SHZGameMangerTable[1].shzcanvas.transform:Find("Canvas/Prefeb");
    self.maryPanel.transform:SetParent(parset);
    self.maryPanel.transform.localScale = Vector3.one;
    self.maryPanel.transform.localPosition = Vector3.New(0, 0, 0);
    self.maryPanel.transform.localRotation = Quaternion.identity;
    self.maryPanel.name = "MaryPanel";
    SHZGameMangerTable[1].nowshowpanel = self.maryPanel;
    self.MaryFindComponent()
end
function MaryGamePanel.MaryFindComponent()
    -- 4个位置显示的图片
    self.Images = self.maryPanel.transform:Find("Images").gameObject;
    self.Images.transform.localPosition=Vector3.New(0,-105,0);
    for i = 0, self.Images.transform.childCount - 1 do
    if  SHZGameMangerTable[1].byPrizeImg[i + 1]>8 then SHZGameMangerTable[1].byPrizeImg[i + 1]=0 end
        self.Images.transform:GetChild(i):GetComponent('Image').sprite = SHZGameMangerTable[1].AllImg.transform:GetChild(SHZGameMangerTable[1].byPrizeImg[i + 1]):GetComponent('Image').sprite;
    end
    self.Rote = self.maryPanel.transform:Find("Rote").gameObject;
    local newrote=newobject(self.maryPanel.transform.parent.gameObject);
    newrote.transform:SetParent(self.maryPanel.transform);
    newrote.transform.localPosition=Vector3.New(0,-105,0);
    newrote.transform.localRotation=self.Rote.transform.localRotation;
    newrote.transform.localScale=self.Rote.transform.localScale;
    newrote.transform:GetComponent("RectTransform").sizeDelta=self.Rote:GetComponent("RectTransform").sizeDelta;
    newrote.transform:SetSiblingIndex(self.Rote.transform:GetSiblingIndex());
    for i = 0, newrote.transform.childCount-1 do
        destroy(newrote.transform:GetChild(i).gameObject);
    end
    self.Rote.transform:SetParent(newrote.transform);
    self.Rote.transform.localPosition=Vector3.New(0,0,0);
    newrote.name="NewRote";
    self.OutImages = self.maryPanel.transform:Find("Bg/OutImages").gameObject;

    self.StopImages = self.maryPanel.transform:Find("Bg/StopImages").gameObject;
    self.maryPanel.transform:Find("Bg/Left"):GetComponent("RectTransform").sizeDelta=Vector2.New(670,750);
    self.maryPanel.transform:Find("Bg/Right"):GetComponent("RectTransform").sizeDelta=Vector2.New(670,750);
    -- 给玛丽游戏绑定动画播放
    for i = 1, self.StopImages.transform.childCount do
        local go = self.StopImages.transform:GetChild(i - 1).gameObject;
        --go:AddComponent(typeof(ImageAnima));
		Util.AddComponent("ImageAnima",go)
        local t = SHZImgAnimation:New();
        t:Creat(go);
        table.insert(MaryImgLuaTable, t);
    end
    self.StopTop = self.maryPanel.transform:Find("Bg/StopTop").gameObject;

    self.ShowNum = self.maryPanel.transform:Find("Bg/ShowNum").gameObject;

    self.ShowInfo = self.maryPanel.transform:Find("Bg/ShowInfo").gameObject;
    self.Gold = self.ShowInfo.transform:Find("Gold").gameObject;
    self.Win = self.ShowInfo.transform:Find("Win").gameObject;
    self.Xiazhu = self.ShowInfo.transform:Find("Xiazhu").gameObject;
    self.WinShow = self.ShowInfo.transform:Find("WinShow").gameObject;
    self.MaryCount = self.ShowInfo.transform:Find("MaryCount").gameObject;
    self.Btn = self.maryPanel.transform:Find("Btn").gameObject;
    SHZGameMangerTable[1].SHZCsJoinLua:AddClick(self.Btn.transform:GetChild(1).gameObject, self.ChooseChipOnClick);
    SHZGameMangerTable[1].SHZCsJoinLua:AddClick(self.Btn.transform:GetChild(0).gameObject, self.ChooseGetOnClick);
    self.ScenInfo();


end

-- 初始化玛丽界面数据
function MaryGamePanel.ScenInfo()
    for i = 0, self.Rote.transform.childCount - 1 do
        self.Rote.transform:GetChild(i).gameObject:SetActive(false);
    end
    for i = 0, self.OutImages.transform.childCount - 1 do
        self.OutImages.transform:GetChild(i).gameObject:SetActive(false);
    end
    for i = 0, self.StopImages.transform.childCount - 1 do
    local go=self.StopImages.transform:GetChild(i).gameObject
        go:SetActive(false);
      --  go:AddComponent(typeof(ImageAnima));
		Util.AddComponent("ImageAnima",go)
    end
    for i = 0, self.StopTop.transform.childCount - 1 do
        self.StopTop.transform:GetChild(i).gameObject:SetActive(false);
    end
    for i = 0, self.ShowNum.transform.childCount - 1 do
        self.ShowNum.transform:GetChild(i).gameObject:SetActive(false);
    end
    self.WinShow:SetActive(false);
    self.Btn:SetActive(false);
    -- 总押注数量
    if SHZGameMangerTable[1].byBetIndex >= 5 then SHZGameMangerTable[1].byBetIndex = 0 end
    SHZGameMangerTable[1]:NumToImage(self.Xiazhu, SHZGameMangerTable[1].byLine * SHZGameMangerTable[1].dwBetList[SHZGameMangerTable[1].byBetIndex + 1], false);
    SHZGameMangerTable[1]:NumToImage(self.Gold, SHZGameMangerTable[1].MyselfGold, false);
    SHZGameMangerTable[1]:NumToImage(self.Win, SHZGameMangerTable[1].iWinScore, false);
    SHZGameMangerTable[1]:NumToImage(self.MaryCount, SHZGameMangerTable[1].byMaryCount, false);
    self.SendInfo();
end

-- 开始向服务器发送玛丽滚动
function MaryGamePanel.SendInfo()
--error("-- 开始向服务器发送玛丽滚动========================");
    SHZSCInfo.RoteMarySendInfo();
end

-- 玛丽游戏结果 
function MaryGamePanel.MaryGameResult()
    -- 开始滚动
    --error("-- 开始滚动-------------------");
    coroutine.start(self.MaryRun);
end

function MaryGamePanel.MaryRun()
    self.OutImages.transform:GetChild(SHZGameMangerTable[1].byStopIndex).gameObject:SetActive(false);
    local endY = -1000;
    local runtime = 0.5;
    local loop = 1
    for i = 1, self.Rote.transform.childCount do
        local roteobj = self.Rote.transform:GetChild(i - 1);
        roteobj.localPosition = Vector3.New(roteobj.localPosition.x, 600, 0);
        local dotween = roteobj:DOLocalMoveY(endY, runtime, false)
        roteobj.gameObject:SetActive(true);
        loop =  i;
        dotween:SetEase(DG.Tweening.Ease.Linear):SetLoops(loop);
        dotween:OnComplete( function()
            dotween:Pause():Rewind(true);
            roteobj.gameObject:SetActive(false);

        end )
    end
    for i = 0, self.Images.transform.childCount - 1 do
        self.Images.transform:GetChild(i):GetComponent('Image').sprite = SHZGameMangerTable[1].AllImg.transform:GetChild(SHZGameMangerTable[1].byPrizeImg[i + 1]):GetComponent('Image').sprite;
    end

    local num = 2;
    for start = 1, num do
        for i = 0, self.OutImages.transform.childCount - 1 do
            if GameNextScenName == gameScenName.HALL then return end
            self.OutImages.transform:GetChild(i).gameObject:SetActive(true);
            coroutine.wait(0.02);
            if not(self.maryPanel.activeSelf) then return end;
            self.OutImages.transform:GetChild(i).gameObject:SetActive(false);
            if i % 2 == 0 then
                local musicchip = SHZGameMangerTable[1].Musicprefeb.transform:Find("Mary"):GetComponent('AudioSource').clip
                MusicManager:PlayX(musicchip);
            end
        end
        if start==num then 
            local endspeed = 0;
    for i = 0, SHZGameMangerTable[1].byStopIndex do
        if GameNextScenName == gameScenName.HALL then return end
        self.OutImages.transform:GetChild(i).gameObject:SetActive(true);
        coroutine.wait(0.02);
--        if SHZGameMangerTable[1].byStopIndex - i < 5 then
--            endspeed = endspeed + 0.02
--            coroutine.wait(endspeed);
--        end
        if GameNextScenName == gameScenName.HALL then return end
        if not(self.maryPanel.activeSelf) then return end;
        self.OutImages.transform:GetChild(i).gameObject:SetActive(false);
    end
        end
    end
    -- 是否含有三个或四个相同的
    local showmid = nil;
    local startnum = 5;
    local stopnum = 3;
    if SHZGameMangerTable[1].byPrizeImg[1] == SHZGameMangerTable[1].byPrizeImg[2] and SHZGameMangerTable[1].byPrizeImg[2] == SHZGameMangerTable[1].byPrizeImg[3] then
        startnum = 0;
        if SHZGameMangerTable[1].byPrizeImg[3] == SHZGameMangerTable[1].byPrizeImg[4] then
            -- 四个相等
            showmid = self.ShowNum.transform:Find("mid").gameObject
            -- 显示4个需要播放动画界面
            stopnum = 3;
        else
            -- 左边三个相等
            showmid = self.ShowNum.transform:Find("left").gameObject
            -- 显示左边三个需要播放动画界面
            startnum = 0;
            stopnum = 2;
        end
    elseif SHZGameMangerTable[1].byPrizeImg[2] == SHZGameMangerTable[1].byPrizeImg[3] and SHZGameMangerTable[1].byPrizeImg[3] == SHZGameMangerTable[1].byPrizeImg[4] then
        -- 右边三个相等
        showmid = self.ShowNum.transform:Find("right").gameObject
        -- 显示右边需要播放动画界面
        startnum = 1;
        stopnum = 3;
    end
    for i = startnum, stopnum do
        if i == stopnum then
            local musicchip = SHZGameMangerTable[1].Musicprefeb.transform:Find("WinBig/" .. SHZGameMangerTable[1].byPrizeImg[i + 1]):GetComponent('AudioSource').clip
            MusicManager:PlayX(musicchip);
        end
        self.StopImages.transform:GetChild(i).gameObject:SetActive(true);
        MaryImgLuaTable[i + 1]:SetImgScript(SHZGameMangerTable[1].MainSelf.ShowResultImg.transform:GetChild(SHZGameMangerTable[1].byPrizeImg[i + 1]), self.Images.transform:GetChild(i):GetComponent('Image').sprite)
    end
    -- 顶上是否显示show
    local showtop = nil;
    if tonumber(MH_SHZ.C_MARY_IMG[SHZGameMangerTable[1].byStopIndex + 1]) then
        for k = 1, #SHZGameMangerTable[1].byPrizeImg do
            if SHZGameMangerTable[1].byPrizeImg[k] == MH_SHZ.C_MARY_IMG[SHZGameMangerTable[1].byStopIndex + 1] then
                showtop = self.StopTop.transform:GetChild(SHZGameMangerTable[1].byPrizeImg[k] -1).gameObject
                -- 判断如果showmid==nil，才需要播放动画界面
                    self.StopImages.transform:GetChild(k - 1).gameObject:SetActive(true);
                    -- MaryImgLuaTable[k]:SetImgScript(SHZGameMangerTable[1].MainSelf.ShowResultImg.transform:GetChild(SHZGameMangerTable[1].byPrizeImg[k]), self.Images.transform:GetChild(k - 1):GetComponent('Image').sprite)
                    local musicchip = SHZGameMangerTable[1].Musicprefeb.transform:Find("WinBig/" .. SHZGameMangerTable[1].byPrizeImg[k]):GetComponent('AudioSource').clip
                    MusicManager:PlayX(musicchip);
            end
        end
    end

    -- 播动画
    for i = 1, 5 do
        if showtop ~= nil then showtop:SetActive(true); end
        if showmid ~= nil then showmid:SetActive(true); end
        self.OutImages.transform:GetChild(SHZGameMangerTable[1].byStopIndex).gameObject:SetActive(true);
        coroutine.wait(0.2);
        if GameNextScenName == gameScenName.HALL then return end
        if not(self.maryPanel.activeSelf) then return end;
        if showtop ~= nil then showtop:SetActive(false); end
        if showmid ~= nil then showmid:SetActive(false); end
        self.OutImages.transform:GetChild(SHZGameMangerTable[1].byStopIndex).gameObject:SetActive(false);
        coroutine.wait(0.2);
        if GameNextScenName == gameScenName.HALL then return end
        if not(self.maryPanel.activeSelf) then return end;
    end
    for i = 0, self.StopImages.transform.childCount - 1 do
        self.StopImages.transform:GetChild(i).gameObject:SetActive(false);
    end
    SHZGameMangerTable[1]:NumToImage(self.Gold, SHZGameMangerTable[1].MyselfGold, false);
    SHZGameMangerTable[1]:NumToImage(self.Win, SHZGameMangerTable[1].iWinScore, false);
    SHZGameMangerTable[1]:NumToImage(self.MaryCount, SHZGameMangerTable[1].byMaryCount, false);
    -- 闪烁完毕，判断MaryCount是否>0
    if GameNextScenName == gameScenName.HALL then return end
    if SHZGameMangerTable[1].byMaryCount > 0 then
        self.SendInfo();
    else
        -- 显示得分Or比倍（判断是手动还是自动）
        if SHZGameMangerTable[1].MainSelf.FreeOrHand then
            -- 自动
        coroutine.wait(2);
            self.ChooseGetOnClick(self.Btn.transform:GetChild(0).gameObject)
        else
            SHZGameMangerTable[1]:NumToImage(self.WinShow, SHZGameMangerTable[1].iWinScore, true);
            self.WinShow:SetActive(true);
            self.Btn:SetActive(true);
        end

    end
end

-- 选择押大小
function MaryGamePanel.ChooseChipOnClick(obj)
    obj.transform:GetComponent('Button').interactable = false;
    SHZSCInfo.ChipOrGetSendInfo(1);
    obj.transform:GetComponent('Button').interactable = true;
end

--选择得分
function MaryGamePanel.ChooseGetOnClick(obj)
    obj.transform:GetComponent('Button').interactable = false;
    self.nowGold=SHZGameMangerTable[1].MyselfGold;
    SHZSCInfo.ChipOrGetSendInfo(0);
    obj.transform:GetComponent('Button').interactable = true;
end

function MaryGamePanel.ChooseGetScore(win)
    SHZGameMangerTable[1]:NumToImage(self.Win, SHZGameMangerTable[1].iWinScore, false);
    -- 播得分动画
    coroutine.start(self.PalyWinAnimator, win)
end


-- 结算动画
function MaryGamePanel.PalyWinAnimator(wingold)
    local musicchip = SHZGameMangerTable[1].Musicprefeb.transform:Find("Get"):GetComponent('AudioSource').clip
    MusicManager:PlayX(musicchip);
    local jiannum = math.floor(wingold / 20);
    local startnum = wingold;
    self.WinShow:SetActive(true);
    local stopnum = 20;
    if wingold <= 20 then jiannum = 1; stopnum = wingold end
    for i = 1, stopnum do
        startnum = startnum - jiannum;
        SHZGameMangerTable[1]:NumToImage(self.WinShow, startnum, true);
        if toInt64(self.nowGold) < toInt64(SHZGameMangerTable[1].MyselfGold) then 
        self.nowGold=self.nowGold+jiannum
        SHZGameMangerTable[1]:NumToImage(self.Gold, self.nowGold+jiannum, false);
        end
        coroutine.wait(0.06);
        if GameNextScenName == gameScenName.HALL then return end
        if not(self.maryPanel.activeSelf) then return end;
    end
    SHZGameMangerTable[1].iWinScore = 0;
    self.WinShow:SetActive(false);
    -- 跳转到
    SHZGameMangerTable[1].MainSelf.ShowPanel();
    self.maryPanel:SetActive(false);
end

