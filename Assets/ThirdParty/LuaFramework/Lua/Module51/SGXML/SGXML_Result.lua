SGXML_Result = {};

local self = SGXML_Result;

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

function SGXML_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = false;
    self.isPause = false;
end
function SGXML_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = true;
    SGXMLEntry.myGold = TableUserInfo._7wGold;
    SGXMLEntry.WinNum.text = ShortNumber(SGXMLEntry.ResultData.WinScore);
    --其他正常模式
    if SGXMLEntry.isFreeGame then
        self.totalFreeGold = self.totalFreeGold + SGXMLEntry.ResultData.WinScore;
    end
    if SGXMLEntry.ResultData.WinScore > 0 then
        SGXML_Line.Show();
        SGXMLEntry.WinDesc.text = "Great，<color=#F5D188FF>" .. #SGXML_Line.showTable .. "</color> lines";
        SGXMLEntry.resultEffect.gameObject:SetActive(true);
        local rate = SGXMLEntry.ResultData.m_nWinPeiLv / SGXML_DataConfig.ALLLINECOUNT;
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
        SGXMLEntry.WinDesc.text = "Sad, try again";
        SGXMLEntry.SetSelfGold(SGXMLEntry.myGold);
    end
end
function SGXML_Result.HideResult()
    for i = 1, SGXMLEntry.resultEffect.childCount do
        SGXMLEntry.resultEffect:GetChild(i - 1).gameObject:SetActive(false);
    end
    SGXMLEntry.resultEffect.gameObject:SetActive(false);
    self.timer = 0;
    self.showCSJLCallback = nil;
    self.showResultCallback = nil;
end
function SGXML_Result.Update()
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

function SGXML_Result.NoWinWait()
    if self.nowin then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= SGXML_DataConfig.autoNoRewardInterval then
            self.nowin = false;
            self.CheckFree();
        end
    end
end
function SGXML_Result.CheckFree()
    SGXMLEntry.isRoll = false;
    if not SGXMLEntry.isFreeGame then
        if SGXMLEntry.freeCount > 0 then
            SGXML_Line.Close();
            --进入免费
            self.ShowFreeEffect(false);
        elseif SGXMLEntry.smallGameCount > 0 then
            --SGXML_Line.Close();
            --进入小游戏
            self.ShowEnterSmallGameEffect();
        else
            SGXMLEntry.FreeRoll();
        end
    else
        --if SGXMLEntry.freeCount <= 0 then
        --    self.ShowFreeResultEffect();
        --else
        --    SGXMLEntry.FreeRoll();
        --end
        SGXMLEntry.FreeRoll();
    end
end
function SGXML_Result.ShowFreeEffect(isSceneData)
    --展示免费
    SGXMLEntry.isFreeGame = true;
    self.timer = 0;
    SGXMLEntry.addChipBtn.interactable = false;
    SGXMLEntry.reduceChipBtn.interactable = false;
    SGXMLEntry.MaxChipBtn.interactable = false;
    SGXMLEntry.resultEffect.gameObject:SetActive(true);
    SGXMLEntry.EnterFreeEffect.gameObject:SetActive(true);
    SGXMLEntry.FreeContent.gameObject:SetActive(true);
    SGXMLEntry.stopState.gameObject:SetActive(false);
    SGXMLEntry.startState.gameObject:SetActive(false);
    SGXMLEntry.AutoContent.gameObject:SetActive(false);
    SGXMLEntry.currentFreeCount = 0;
    Util.RunWinScore(0, 1, SGXML_DataConfig.freeLoadingShowTime, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        SGXMLEntry.EnterFreeEffect.gameObject:SetActive(false);
        if self.showResultCallback ~= nil then
            self.showResultCallback();
        end
    end);
    -- self.isShowFree = true;
    self.CheckFree();
end
function SGXML_Result.ShowFree()
    if self.isShowFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= SGXML_DataConfig.freeLoadingShowTime then
            self.isShowFree = false;
            self.timer = 0;
            SGXMLEntry.EnterFreeEffect.gameObject:SetActive(false);
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function SGXML_Result.ShowEnterSmallGameEffect()
    --展示免费
    SGXMLEntry.isSmallGame = true;
    self.timer = 0;
    SGXMLEntry.addChipBtn.interactable = false;
    SGXMLEntry.reduceChipBtn.interactable = false;
    SGXMLEntry.MaxChipBtn.interactable = false;
    SGXMLEntry.resultEffect.gameObject:SetActive(true);
    SGXMLEntry.normalWinEffect.gameObject:SetActive(false);
    SGXMLEntry.bigWinEffect.gameObject:SetActive(false);
    SGXMLEntry.midWinEffect.gameObject:SetActive(false);
    SGXMLEntry.enterSmallEffect.gameObject:SetActive(true);
    SGXMLEntry.FreeContent.gameObject:SetActive(false);
    SGXMLEntry.AutoContent.gameObject:SetActive(false);
    self.showResultCallback = function()
        self.timer = 0;
        self.ShowSmallGameRuleEffect();
        --SGXML_Line.Close();
    end
    self.isShowEnterSmallGame = true;
end
function SGXML_Result.ShowSmallGameLoading()
    if self.isShowEnterSmallGame then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= SGXML_DataConfig.smallGameLoadingShowTime then
            self.isShowEnterSmallGame = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function SGXML_Result.ShowSmallGameRuleEffect()
    --展示免费
    self.timer = 0;
    SGXMLEntry.addChipBtn.interactable = false;
    SGXMLEntry.reduceChipBtn.interactable = false;
    SGXMLEntry.MaxChipBtn.interactable = false;
    SGXMLEntry.resultEffect.gameObject:SetActive(true);
    SGXMLEntry.enterSmallEffect.gameObject:SetActive(false);
    SGXMLEntry.SmallRuleEffect.gameObject:SetActive(true);
    SGXMLEntry.FreeContent.gameObject:SetActive(false);
    SGXMLEntry.AutoContent.gameObject:SetActive(false);
    SGXMLEntry.SmallGamePanel.gameObject:SetActive(true);
    local startSmall = SGXMLEntry.SmallRuleEffect:Find("Start"):GetComponent("Button");
    local closerule = SGXMLEntry.SmallRuleEffect:Find("Close"):GetComponent("Button");
    self.showResultCallback = function()
        self.timer = 0;
        SGXMLEntry.SmallRuleEffect.gameObject:SetActive(false);
        --TODO开始小游戏
        SGXML_SmallGame.ShowSmallGame();
    end
    startSmall.onClick:RemoveAllListeners();
    startSmall.onClick:AddListener(function()
        if self.showResultCallback ~= nil then
            self.showResultCallback();
        end
        --if self.isShowSmallGameRule then
        --    self.timer = SGXML_DataConfig.smallGameRuleShowTime;
        --end
    end);
    closerule.onClick:RemoveAllListeners();
    closerule.onClick:AddListener(function()
        if self.showResultCallback ~= nil then
            self.showResultCallback();
        end
        --if self.isShowSmallGameRule then
        --    self.timer = SGXML_DataConfig.smallGameRuleShowTime;
        --end
    end);
    --self.isShowSmallGameRule = true;
end
function SGXML_Result.ShowSmallGameRule()
    if self.isShowSmallGameRule then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= SGXML_DataConfig.smallGameRuleShowTime then
            self.isShowSmallGameRule = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function SGXML_Result.HideFree()
    --隐藏中奖
    if self.isHideFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= SGXML_DataConfig.freeLoadingShowTime then
            --等待退出动画时长
            self.isHideFree = false;
            --self.CheckFree();
        end

    end
end
function SGXML_Result.ShowFreeResultEffect()
    --展示免费结果
    SGXML_Audio.PlaySound(SGXML_Audio.SoundList.SmallPayout);
    SGXMLEntry.isFreeGame = false;
    self.timer = 0;
    self.currentRunGold = 0;
    self.showResultCallback = function()
        self.isShowTotalFree = false;
        SGXMLEntry.FreeResultEffect.gameObject:SetActive(false);
        SGXMLEntry.resultEffect.gameObject:SetActive(false);
        SGXMLEntry.totalFreeCount = 0;
        self.timer = 0;
        self.CheckFree();
    end
    SGXMLEntry.resultEffect.gameObject:SetActive(true);
    SGXMLEntry.FreeResultEffect.gameObject:SetActive(true);
    SGXMLEntry.FreeResultNum.gameObject:SetActive(true);
    SGXMLEntry.FreeTotalCount.gameObject:SetActive(true);
    --self.winRate = math.ceil(self.totalFreeGold / (SGXML_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    SGXMLEntry.FreeResultNum.text = SGXMLEntry.ShowText(self.totalFreeGold);
    SGXMLEntry.FreeTotalCount.text = ShowRichText(SGXMLEntry.totalFreeCount);
    self.isShowTotalFree = true;
end
function SGXML_Result.ShowFreeResult()
    if self.isShowTotalFree then
        self.timer = self.timer + Time.deltaTime;
        --self.currentRunGold = self.currentRunGold + self.winRate;
        --if self.currentRunGold >= self.totalFreeGold then
        --    self.currentRunGold = self.totalFreeGold;
        --end
        --SGXMLEntry.FreeResultNum.text = SGXMLEntry.ShowText(self.currentRunGold);
        if self.timer >= SGXML_DataConfig.showFreeResultTime then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

---------------------中奖---------------------
function SGXML_Result.ShowBigWinEffect()
    --BigWin奖动画
    SGXMLEntry.midWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    SGXMLEntry.midWinNum.text = SGXMLEntry.ShowText("+" .. ShortNumber(SGXMLEntry.ResultData.WinScore),false);
    SGXMLEntry.midWinNum.gameObject:SetActive(true);
    --self.winRate = math.ceil(SGXMLEntry.ResultData.WinScore / (SGXML_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    coroutine.start(function()
        SGXML_Audio.PlaySound(SGXML_Audio.SoundList.Counting)
        coroutine.wait(0.5);
        SGXML_Audio.PlaySound(SGXML_Audio.SoundList.Counting)
    end);
    SGXMLEntry.SetSelfGold(SGXMLEntry.myGold);
    self.showResultCallback = function()
        SGXMLEntry.midWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowBigWin = false;
        SGXML_Result.CheckFree();
    end
    log("big=====" .. SGXML_DataConfig.winGoldChangeRate);
    self.isShowBigWin = true;
end
function SGXML_Result.ShowBigWin()
    --BigWin奖
    if self.isShowBigWin then
        self.timer = self.timer + Time.deltaTime;
        --self.currentRunGold = self.currentRunGold + self.winRate;
        --if self.currentRunGold >= SGXMLEntry.ResultData.WinScore then
        --    self.currentRunGold = SGXMLEntry.ResultData.WinScore;
        --end
        --SGXMLEntry.midWinNum.text = SGXMLEntry.ShowText("+" .. self.currentRunGold);
        if self.timer >= SGXML_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function SGXML_Result.ShowSuperWinffect()
    --Super奖动画
    SGXMLEntry.bigWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    SGXMLEntry.bigWinNum.text = SGXMLEntry.ShowText("+" .. ShortNumber(SGXMLEntry.ResultData.WinScore),false);
    SGXMLEntry.bigWinNum.gameObject:SetActive(true);
    --self.winRate = math.ceil(SGXMLEntry.ResultData.WinScore / (SGXML_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    coroutine.start(function()
        SGXML_Audio.PlaySound(SGXML_Audio.SoundList.Counting)
        coroutine.wait(0.5);
        SGXML_Audio.PlaySound(SGXML_Audio.SoundList.Counting)
        coroutine.wait(0.5);
        SGXML_Audio.PlaySound(SGXML_Audio.SoundList.Counting)
    end);
    SGXMLEntry.SetSelfGold(SGXMLEntry.myGold);
    self.showResultCallback = function()
        SGXMLEntry.bigWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowSuperWin = false;
        SGXML_Result.CheckFree();
    end
    self.isShowSuperWin = true;
end
function SGXML_Result.ShowSuperWin()
    --Super奖
    if self.isShowSuperWin then
        self.timer = self.timer + Time.deltaTime;
        --self.currentRunGold = self.currentRunGold + self.winRate;
        --if self.currentRunGold >= SGXMLEntry.ResultData.WinScore then
        --    self.currentRunGold = SGXMLEntry.ResultData.WinScore;
        --end
        --SGXMLEntry.bigWinNum.text = SGXMLEntry.ShowText("+" .. self.currentRunGold);
        if self.timer >= SGXML_DataConfig.winBigGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function SGXML_Result.ShowNormalEffect()
    self.timer = 0;
    self.currentRunGold = 0;
    SGXMLEntry.normalWinEffect.gameObject:SetActive(true);
    SGXMLEntry.normalWinNum.text = SGXMLEntry.ShowText("+" .. ShortNumber(SGXMLEntry.ResultData.WinScore),false);
    SGXMLEntry.normalWinNum.gameObject:SetActive(true);
    SGXMLEntry.SetSelfGold(SGXMLEntry.myGold);
    --self.winRate = math.ceil(SGXMLEntry.ResultData.WinScore / (SGXML_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    SGXML_Audio.PlaySound(SGXML_Audio.SoundList.Counting)
    self.showResultCallback = nil;
    self.showResultCallback = function()
        self.isShowNormal = false;
        self.timer = 0;
        SGXMLEntry.normalWinEffect.gameObject:SetActive(false);
        self.CheckFree();
    end
    Util.RunWinScore(0, 1, SGXML_DataConfig.winGoldChangeRate * 0.6, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        if self.showResultCallback ~= nil then
            self.showResultCallback();
        end
    end);
    --self.isShowNormal = true;
end
function SGXML_Result.ShowNormal()
    if self.isShowNormal then
        self.timer = self.timer + Time.deltaTime;
        --self.currentRunGold = self.currentRunGold + self.winRate;
        --if self.currentRunGold >= SGXMLEntry.ResultData.WinScore then
        --    self.currentRunGold = SGXMLEntry.ResultData.WinScore;
        --end
        --SGXMLEntry.normalWinNum.text = SGXMLEntry.ShowText("+" .. self.currentRunGold);
        if self.timer >= SGXML_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end