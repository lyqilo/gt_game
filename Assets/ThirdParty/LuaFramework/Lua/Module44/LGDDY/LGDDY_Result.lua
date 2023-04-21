LGDDY_Result = {};

local self = LGDDY_Result;

self.timer = 0;
self.isShow = false;

self.isPause = false;

self.waitNextCSJL = false;--等待下一次重转
self.showCSJLCallback = nil;--展示完回调

self.winRate = 0;--赢的跑分比率
self.currentRunGold = 0;

self.isShowMageWin = false;--展示Mega
self.isShowSuperWin = false;--展示super
self.isShowBigWin = false;--展示bigwin
self.isShowNormal = false;--展示中奖
self.isHideNormal = false;--隐藏中奖
self.showResultCallback = nil;
self.hideNormalTime = 0.5;--退出动画时长

self.nowin = false;--没有得分
self.isFreeGame = false;--是否为免费游戏
self.showFreeTweener = nil;--免费财神动画tween
self.isShowFree = false;--展示免费
self.isHideFree = false;--隐藏免费

self.isShowFreeResult = false;--展示免费结果
self.hideFreeTime = 1;--免费动画退出时长

self.totalFreeGold = 0;--免费总金币
self.isShowTotalFree = false;--展示免费

self.isShowSelectFreeResult = false;

self.isShowEnterSmallGame = false;
self.isShowSmallGameRule = false;

function LGDDY_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = false;
    self.isPause = false;
end
function LGDDY_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = true;
    LGDDYEntry.myGold = TableUserInfo._7wGold;
    LGDDYEntry.WinNum.text = ShortNumber(LGDDYEntry.ResultData.WinScore);
    --其他正常模式
    if LGDDYEntry.isFreeGame then
        self.totalFreeGold = self.totalFreeGold + LGDDYEntry.ResultData.WinScore;
    end
    if LGDDYEntry.ResultData.WinScore > 0 then
        LGDDY_Line.Show();
        LGDDYEntry.WinDesc.text = "Great！ <color=#F5D188FF>" .. #LGDDY_Line.showTable .. "</color> lines";
        LGDDYEntry.resultEffect.gameObject:SetActive(true);
        local rate = LGDDYEntry.ResultData.m_nWinPeiLv / LGDDY_DataConfig.ALLLINECOUNT;
        if rate < 4 then
            --普通奖  不做显示    
            self.ShowNormalEffect()
        elseif rate >= 4 and rate < 8 then
            --bigwin
            self.ShowBigWinEffect();
        elseif rate >= 8 then
            --superwin
            self.ShowSuperWinffect()
        end
    else
        self.nowin = true;
        LGDDYEntry.WinDesc.text = "Sad, try again";
        LGDDYEntry.SetSelfGold(LGDDYEntry.myGold);
    end
end
function LGDDY_Result.HideResult()
    for i = 1, LGDDYEntry.resultEffect.childCount do
        LGDDYEntry.resultEffect:GetChild(i - 1).gameObject:SetActive(false);
    end
    LGDDYEntry.resultEffect.gameObject:SetActive(false);
    self.timer = 0;
    self.showCSJLCallback = nil;
    self.showResultCallback = nil;
end
function LGDDY_Result.Update()
    if self.isPause then
        return ;
    end

    self.ShowSuperWin();
    self.ShowBigWin();

    self.ShowFree();
    self.HideFree();
    self.ShowNormal();
    self.NoWinWait();
    self.ShowFreeResult();

    self.ShowSmallGameLoading();
    self.ShowSmallGameRule();
end

function LGDDY_Result.NoWinWait()
    if self.nowin then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= LGDDY_DataConfig.autoNoRewardInterval then
            self.nowin = false;
            self.CheckFree();
        end
    end
end
function LGDDY_Result.CheckFree()
    LGDDYEntry.isRoll = false;
    if not LGDDYEntry.isFreeGame then
        if LGDDYEntry.freeCount > 0 then
            LGDDY_Line.Close();
            --进入免费
            self.ShowFreeEffect(false);
        elseif LGDDYEntry.smallGameCount > 0 then
            --LGDDY_Line.Close();
            --进入小游戏
            self.ShowEnterSmallGameEffect();
        else
            LGDDYEntry.FreeRoll();
        end
    else
        --if LGDDYEntry.freeCount <= 0 then
        --    self.ShowFreeResultEffect();
        --else
        --    LGDDYEntry.FreeRoll();
        --end
        LGDDYEntry.FreeRoll();
    end
end
function LGDDY_Result.ShowFreeEffect(isSceneData)
    --展示免费
    LGDDYEntry.isFreeGame = true;
    self.timer = 0;
    LGDDYEntry.addChipBtn.interactable = false;
    LGDDYEntry.reduceChipBtn.interactable = false;
    LGDDYEntry.MaxChipBtn.interactable = false;
    LGDDYEntry.resultEffect.gameObject:SetActive(true);
    LGDDYEntry.EnterFreeEffect.gameObject:SetActive(true);
    LGDDYEntry.FreeContent.gameObject:SetActive(true);
    LGDDYEntry.stopState.gameObject:SetActive(false);
    LGDDYEntry.startState.gameObject:SetActive(false);
    LGDDYEntry.AutoContent.gameObject:SetActive(false);
    LGDDYEntry.currentFreeCount = 0;
    self.isShowFree = true;
    self.CheckFree();
end
function LGDDY_Result.ShowFree()
    if self.isShowFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= LGDDY_DataConfig.freeLoadingShowTime then
            self.isShowFree = false;
            self.timer = 0;
            LGDDYEntry.EnterFreeEffect.gameObject:SetActive(false);
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function LGDDY_Result.ShowEnterSmallGameEffect()
    --展示免费
    LGDDYEntry.isSmallGame = true;
    self.timer = 0;
    LGDDYEntry.addChipBtn.interactable = false;
    LGDDYEntry.reduceChipBtn.interactable = false;
    LGDDYEntry.MaxChipBtn.interactable = false;
    LGDDYEntry.resultEffect.gameObject:SetActive(true);
    LGDDYEntry.normalWinEffect.gameObject:SetActive(false);
    LGDDYEntry.bigWinEffect.gameObject:SetActive(false);
    LGDDYEntry.midWinEffect.gameObject:SetActive(false);
    LGDDYEntry.enterSmallEffect.gameObject:SetActive(true);
    LGDDYEntry.FreeContent.gameObject:SetActive(false);
    LGDDYEntry.AutoContent.gameObject:SetActive(false);
    self.showResultCallback = function()
        self.timer = 0;
        self.ShowSmallGameRuleEffect();
        --LGDDY_Line.Close();
    end
    self.isShowEnterSmallGame = true;
end
function LGDDY_Result.ShowSmallGameLoading()
    if self.isShowEnterSmallGame then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= LGDDY_DataConfig.smallGameLoadingShowTime then
            self.isShowEnterSmallGame = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function LGDDY_Result.ShowSmallGameRuleEffect()
    --展示免费
    self.timer = 0;
    LGDDYEntry.addChipBtn.interactable = false;
    LGDDYEntry.reduceChipBtn.interactable = false;
    LGDDYEntry.MaxChipBtn.interactable = false;
    LGDDYEntry.resultEffect.gameObject:SetActive(true);
    LGDDYEntry.enterSmallEffect.gameObject:SetActive(false);
    LGDDYEntry.SmallRuleEffect.gameObject:SetActive(true);
    LGDDYEntry.FreeContent.gameObject:SetActive(false);
    LGDDYEntry.AutoContent.gameObject:SetActive(false);
    LGDDYEntry.SmallGamePanel.gameObject:SetActive(true);
    local startSmall = LGDDYEntry.SmallRuleEffect:Find("Start"):GetComponent("Button");
    local closerule = LGDDYEntry.SmallRuleEffect:Find("Close"):GetComponent("Button");
    self.showResultCallback = function()
        self.timer = 0;
        LGDDYEntry.SmallRuleEffect.gameObject:SetActive(false);
        --TODO开始小游戏
        LGDDY_SmallGame.ShowSmallGame();
    end
    startSmall.onClick:RemoveAllListeners();
    startSmall.onClick:AddListener(function()
        if self.showResultCallback ~= nil then
            self.showResultCallback();
        end
        --if self.isShowSmallGameRule then
        --    self.timer = LGDDY_DataConfig.smallGameRuleShowTime;
        --end
    end);
    closerule.onClick:RemoveAllListeners();
    closerule.onClick:AddListener(function()
        if self.showResultCallback ~= nil then
            self.showResultCallback();
        end
        --if self.isShowSmallGameRule then
        --    self.timer = LGDDY_DataConfig.smallGameRuleShowTime;
        --end
    end);
    --self.isShowSmallGameRule = true;
end
function LGDDY_Result.ShowSmallGameRule()
    if self.isShowSmallGameRule then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= LGDDY_DataConfig.smallGameRuleShowTime then
            self.isShowSmallGameRule = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function LGDDY_Result.HideFree()
    --隐藏中奖
    if self.isHideFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= LGDDY_DataConfig.freeLoadingShowTime then
            --等待退出动画时长
            self.isHideFree = false;
            --self.CheckFree();
        end

    end
end
function LGDDY_Result.ShowFreeResultEffect()
    --展示免费结果
    LGDDY_Audio.PlaySound(LGDDY_Audio.SoundList.SmallPayout);
    LGDDYEntry.isFreeGame = false;
    self.timer = 0;
    self.currentRunGold = 0;
    self.showResultCallback = function()
        self.isShowTotalFree = false;
        LGDDYEntry.FreeResultEffect.gameObject:SetActive(false);
        LGDDYEntry.resultEffect.gameObject:SetActive(false);
        LGDDYEntry.totalFreeCount = 0;
        self.timer = 0;
        self.CheckFree();
    end
    LGDDYEntry.resultEffect.gameObject:SetActive(true);
    LGDDYEntry.FreeResultEffect.gameObject:SetActive(true);
    LGDDYEntry.FreeResultNum.gameObject:SetActive(true);
    LGDDYEntry.FreeTotalCount.gameObject:SetActive(true);
    --self.winRate = math.ceil(self.totalFreeGold / (LGDDY_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    LGDDYEntry.FreeResultNum.text = LGDDYEntry.ShowText(self.totalFreeGold);
    LGDDYEntry.FreeTotalCount.text = LGDDYEntry.ShowText(LGDDYEntry.FormatNumberThousands(LGDDYEntry.totalFreeCount));
    self.isShowTotalFree = true;
end
function LGDDY_Result.ShowFreeResult()
    if self.isShowTotalFree then
        self.timer = self.timer + Time.deltaTime;
        --self.currentRunGold = self.currentRunGold + self.winRate;
        --if self.currentRunGold >= self.totalFreeGold then
        --    self.currentRunGold = self.totalFreeGold;
        --end
        --LGDDYEntry.FreeResultNum.text = LGDDYEntry.ShowText(self.currentRunGold);
        if self.timer >= LGDDY_DataConfig.showFreeResultTime then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

---------------------中奖---------------------
function LGDDY_Result.ShowBigWinEffect()
    --BigWin奖动画
    LGDDYEntry.midWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    LGDDYEntry.midWinNum.text = LGDDYEntry.ShowText("+" .. ShortNumber(LGDDYEntry.ResultData.WinScore),false);
    LGDDYEntry.midWinNum.gameObject:SetActive(true);
    --self.winRate = math.ceil(LGDDYEntry.ResultData.WinScore / (LGDDY_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    coroutine.start(function()
        LGDDY_Audio.PlaySound(LGDDY_Audio.SoundList.Counting)
        coroutine.wait(0.5);
        LGDDY_Audio.PlaySound(LGDDY_Audio.SoundList.Counting)
    end);
    LGDDYEntry.SetSelfGold(LGDDYEntry.myGold);
    self.showResultCallback = function()
        LGDDYEntry.midWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowBigWin = false;
        LGDDY_Result.CheckFree();
    end
    log("big=====" .. LGDDY_DataConfig.winGoldChangeRate);
    self.isShowBigWin = true;
end
function LGDDY_Result.ShowBigWin()
    --BigWin奖
    if self.isShowBigWin then
        self.timer = self.timer + Time.deltaTime;
        --self.currentRunGold = self.currentRunGold + self.winRate;
        --if self.currentRunGold >= LGDDYEntry.ResultData.WinScore then
        --    self.currentRunGold = LGDDYEntry.ResultData.WinScore;
        --end
        --LGDDYEntry.midWinNum.text = LGDDYEntry.ShowText("+" .. self.currentRunGold);
        if self.timer >= LGDDY_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function LGDDY_Result.ShowSuperWinffect()
    --Super奖动画
    LGDDYEntry.bigWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    LGDDYEntry.bigWinNum.text = LGDDYEntry.ShowText("+" .. ShortNumber(LGDDYEntry.ResultData.WinScore),false);
    LGDDYEntry.bigWinNum.gameObject:SetActive(true);
    --self.winRate = math.ceil(LGDDYEntry.ResultData.WinScore / (LGDDY_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    coroutine.start(function()
        LGDDY_Audio.PlaySound(LGDDY_Audio.SoundList.Counting)
        coroutine.wait(0.5);
        LGDDY_Audio.PlaySound(LGDDY_Audio.SoundList.Counting)
        coroutine.wait(0.5);
        LGDDY_Audio.PlaySound(LGDDY_Audio.SoundList.Counting)
    end);
    LGDDYEntry.SetSelfGold(LGDDYEntry.myGold);
    self.showResultCallback = function()
        LGDDYEntry.bigWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowSuperWin = false;
        LGDDY_Result.CheckFree();
    end
    self.isShowSuperWin = true;
end
function LGDDY_Result.ShowSuperWin()
    --Super奖
    if self.isShowSuperWin then
        self.timer = self.timer + Time.deltaTime;
        --self.currentRunGold = self.currentRunGold + self.winRate;
        --if self.currentRunGold >= LGDDYEntry.ResultData.WinScore then
        --    self.currentRunGold = LGDDYEntry.ResultData.WinScore;
        --end
        --LGDDYEntry.bigWinNum.text = LGDDYEntry.ShowText("+" .. self.currentRunGold);
        if self.timer >= LGDDY_DataConfig.winBigGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function LGDDY_Result.ShowNormalEffect()
    self.timer = 0;
    self.currentRunGold = 0;
    LGDDYEntry.normalWinEffect.gameObject:SetActive(true);
    LGDDYEntry.normalWinNum.text = LGDDYEntry.ShowText("+" .. ShortNumber(LGDDYEntry.ResultData.WinScore),false);
    LGDDYEntry.normalWinNum.gameObject:SetActive(true);
    LGDDYEntry.SetSelfGold(LGDDYEntry.myGold);
    --self.winRate = math.ceil(LGDDYEntry.ResultData.WinScore / (LGDDY_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    LGDDY_Audio.PlaySound(LGDDY_Audio.SoundList.Counting)
    self.showResultCallback = nil;
    self.showResultCallback = function()
        self.isShowNormal = false;
        self.timer = 0;
        LGDDYEntry.normalWinEffect.gameObject:SetActive(false);
        self.CheckFree();
    end
    self.isShowNormal = true;
end
function LGDDY_Result.ShowNormal()
    if self.isShowNormal then
        self.timer = self.timer + Time.deltaTime;
        --self.currentRunGold = self.currentRunGold + self.winRate;
        --if self.currentRunGold >= LGDDYEntry.ResultData.WinScore then
        --    self.currentRunGold = LGDDYEntry.ResultData.WinScore;
        --end
        --LGDDYEntry.normalWinNum.text = LGDDYEntry.ShowText("+" .. self.currentRunGold);
        if self.timer >= LGDDY_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end