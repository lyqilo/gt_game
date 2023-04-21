WLZB_Result = {};

local self = WLZB_Result;

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

function WLZB_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = false;
    self.isPause = false;
end
function WLZB_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = true;
    WLZBEntry.myGold = TableUserInfo._7wGold;
    WLZBEntry.WinNum.text = WLZBEntry.ShowText(WLZBEntry.FormatNumberThousands(WLZBEntry.ResultData.WinScore));
    --其他正常模式
    if WLZBEntry.isFreeGame then
        self.totalFreeGold = self.totalFreeGold + WLZBEntry.ResultData.WinScore;
        WLZBEntry.freeWinNum.text = WLZBEntry.ShowText(WLZB_Result.totalFreeGold);
    end
    if WLZBEntry.ResultData.WinScore > 0 then
        local resultCall = function()
            WLZB_Line.Show();
            if WLZBEntry.isFreeGame then
                WLZB_Audio.PlaySound(WLZB_Audio.SoundList.FreeResult);
            end
            WLZBEntry.resultEffect.gameObject:SetActive(true);
            local rate = WLZBEntry.ResultData.m_nWinPeiLv / WLZB_DataConfig.ALLLINECOUNT;
            if rate < 2 then
                --普通奖  不做显示    
                WLZB_Result.ShowNormalEffect()
            elseif rate >= 2 and rate < 3 then
                --bigwin 
                self.ShowBigWinEffect();
            elseif rate >= 3 and rate < 5 then
                --megewin
                self.ShowMegaWinEffect();
            elseif rate >= 5 then
                --superwin
                self.ShowSuperWinffect()
            end
        end
        resultCall();
    else
        self.nowin = true;
        WLZB_Line.ShowNoReward();
        WLZBEntry.SetSelfGold(WLZBEntry.myGold);
    end
end
function WLZB_Result.HideResult()
    for i = 1, WLZBEntry.resultEffect.childCount do
        WLZBEntry.resultEffect:GetChild(i - 1).gameObject:SetActive(false);
    end

    WLZBEntry.resultEffect.gameObject:SetActive(false);
    self.timer = 0;
    self.showCSJLCallback = nil;
    self.showResultCallback = nil;
end
function WLZB_Result.Update()
    if self.isPause then
        return ;
    end

    self.ShowSuperWin();
    self.ShowMegaWin();
    self.ShowBigWin();

    self.ShowFree();
    self.HideFree();
    self.ShowNormal();
    self.NoWinWait();
    self.ShowFreeResult();
    self.ShowSelectFreeResult();
end

function WLZB_Result.NoWinWait()
    if self.nowin then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= WLZB_DataConfig.autoNoRewardInterval then
            self.nowin = false;
            self.CheckFree();
        end
    end
end
function WLZB_Result.CheckFree()
    WLZBEntry.isRoll = false;
    WLZBEntry.resultEffect.gameObject:SetActive(false);
    if not WLZBEntry.isFreeGame then
        if WLZBEntry.ResultData.m_bFreeGame then
            WLZB_Line.Close();
            self.ShowFreeEffect(false);
        else
            WLZBEntry.FreeRoll();
        end
    else
        if WLZBEntry.freeCount <= 0 then
            self.ShowFreeResultEffect();
        else
            WLZBEntry.FreeRoll();
        end
    end
end
function WLZB_Result.ShowFreeEffect(isSceneData)
    --展示免费
    WLZBEntry.isFreeGame = true;
    self.timer = 0;
    WLZBEntry.addChipBtn.interactable = false;
    WLZBEntry.reduceChipBtn.interactable = false;
    WLZBEntry.MaxChipBtn.interactable = false;
    WLZBEntry.resultEffect.gameObject:SetActive(true);
    WLZBEntry.EnterFreeEffect.gameObject:SetActive(true);
    WLZBEntry.FreeContent.gameObject:SetActive(true);
    WLZBEntry.AutoContent.gameObject:SetActive(false);
    WLZBEntry.startBtn.AnimationState:SetAnimation(0, "freetimes", true);
    WLZBEntry.normalBackground:SetActive(false);
    WLZBEntry.freeBackground:SetActive(true);
    WLZBEntry.freeWinNum.text = WLZBEntry.ShowText("0");
    self.showResultCallback = function()
        self.timer = 0;
        self.isHideFree = true;
        WLZB_Line.Close();
    end
    if isSceneData then
        self.showResultCallback();
    else
        WLZB_Line.ShowFree();
        WLZBEntry.currentFreeCount = 0;
        self.isShowFree = true;
    end
end
function WLZB_Result.ShowFree()
    if self.isShowFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= WLZB_DataConfig.winGoldChangeRate then
            self.isShowFree = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function WLZB_Result.HideFree()
    --隐藏中奖
    if self.isHideFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= WLZB_DataConfig.smallGameLoadingShowTime then
            --等待退出动画时长
            self.isHideFree = false;
            WLZB_Audio.PlayBGM(WLZB_Audio.SoundList.FreeBGM);
            WLZBEntry.EnterFreeEffect.gameObject:SetActive(false);
            WLZBEntry.SelectFreeEffect.gameObject:SetActive(true);
            WLZBEntry.selectBtnGroup.parent.gameObject:SetActive(true);
            WLZBEntry.selectResult.gameObject:SetActive(false);
        end

    end
end
function WLZB_Result.ShowFreeResultEffect()
    --展示免费结果
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.TotalFreeResult, WLZB_DataConfig.winGoldChangeRate);
    self.timer = 0;
    self.currentRunGold = 0;
    self.showResultCallback = function()
        self.isShowTotalFree = false;
        WLZBEntry.FreeResultEffect.gameObject:SetActive(false);
        WLZBEntry.resultEffect.gameObject:SetActive(false);
        self.timer = 0;
        WLZBEntry.FreeRoll();
    end
    WLZBEntry.resultEffect.gameObject:SetActive(true);
    WLZBEntry.FreeResultEffect.gameObject:SetActive(true);
    WLZBEntry.FreeResultNum.gameObject:SetActive(true);
    self.winRate = math.ceil(self.totalFreeGold / (WLZB_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    WLZBEntry.FreeResultNum.text = WLZBEntry.ShowText(WLZBEntry.FormatNumberThousands(self.currentRunGold));
    self.isShowTotalFree = true;
end
function WLZB_Result.ShowFreeResult()
    if self.isShowTotalFree then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= self.totalFreeGold then
            self.currentRunGold = self.totalFreeGold;
        end
        WLZBEntry.FreeResultNum.text = WLZBEntry.ShowText(WLZBEntry.FormatNumberThousands(self.currentRunGold));
        if self.timer >= WLZB_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function WLZB_Result.ShowSelectFreeResultEffect()
    self.timer = 0;
    WLZBEntry.selectBtnGroup.parent.gameObject:SetActive(false);
    WLZBEntry.selectResult.gameObject:SetActive(true);
    WLZBEntry.selectCount.text = ShowRichText(WLZBEntry.FreeData.nFreeCount);
    WLZBEntry.selectRate.text = ShowRichText(WLZBEntry.FreeData.nFreeOddIndex);
    self.showResultCallback = function()
        self.isShowSelectFreeResult = false;
        WLZBEntry.selectResult.gameObject:SetActive(false);
        self.CheckFree();
    end
    self.isShowSelectFreeResult = true;
end
function WLZB_Result.ShowSelectFreeResult()
    if self.isShowSelectFreeResult then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= WLZB_DataConfig.showSelectFreeResultTime then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

---------------------中奖---------------------
function WLZB_Result.ShowBigWinEffect()
    --BigWin奖动画
    log("big=====");
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.BW, WLZB_DataConfig.winGoldChangeRate);
    WLZBEntry.bigWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    WLZBEntry.bigWinNum.text = WLZBEntry.ShowText(WLZBEntry.FormatNumberThousands(self.currentRunGold));
    WLZBEntry.bigWinNum.gameObject:SetActive(true);
    self.winRate = math.ceil(WLZBEntry.ResultData.WinScore / (WLZB_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    local timer = (WLZBEntry.ResultData.WinScore / self.winRate) * Time.deltaTime;
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.Counting, timer)
    WLZBEntry.SetSelfGold(WLZBEntry.myGold);
    self.showResultCallback = function()
        WLZBEntry.bigWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowBigWin = false;
        WLZB_Result.CheckFree();
    end
    log("big=====" .. WLZB_DataConfig.winGoldChangeRate);
    self.isShowBigWin = true;
end
function WLZB_Result.ShowBigWin()
    --BigWin奖
    if self.isShowBigWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= WLZBEntry.ResultData.WinScore then
            self.currentRunGold = WLZBEntry.ResultData.WinScore;
        end
        WLZBEntry.bigWinNum.text = WLZBEntry.ShowText(WLZBEntry.FormatNumberThousands(self.currentRunGold));
        if self.timer >= WLZB_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function WLZB_Result.ShowSuperWinffect()
    --Super奖动画
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.SW, WLZB_DataConfig.winGoldChangeRate);
    WLZBEntry.superWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    WLZBEntry.superWinNum.text = WLZBEntry.ShowText(WLZBEntry.FormatNumberThousands(self.currentRunGold));
    WLZBEntry.superWinNum.gameObject:SetActive(true);
    self.winRate = math.ceil(WLZBEntry.ResultData.WinScore / (WLZB_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    local timer = (WLZBEntry.ResultData.WinScore / self.winRate) * Time.deltaTime;
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.Counting, timer)
    WLZBEntry.SetSelfGold(WLZBEntry.myGold);
    self.showResultCallback = function()
        WLZBEntry.superWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowSuperWin = false;
        WLZB_Result.CheckFree();
    end
    self.isShowSuperWin = true;
end
function WLZB_Result.ShowSuperWin()
    --Super奖
    if self.isShowSuperWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= WLZBEntry.ResultData.WinScore then
            self.currentRunGold = WLZBEntry.ResultData.WinScore;
        end
        WLZBEntry.superWinNum.text = WLZBEntry.ShowText(WLZBEntry.FormatNumberThousands(self.currentRunGold));
        if self.timer >= WLZB_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function WLZB_Result.ShowMegaWinEffect()
    --Mega奖动画
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.MW, WLZB_DataConfig.winGoldChangeRate);
    WLZBEntry.megaWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    WLZBEntry.megaWinNum.text = WLZBEntry.ShowText(WLZBEntry.FormatNumberThousands(self.currentRunGold));
    WLZBEntry.megaWinNum.gameObject:SetActive(true);
    self.winRate = math.ceil(WLZBEntry.ResultData.WinScore / (WLZB_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;

    local timer = (WLZBEntry.ResultData.WinScore / self.winRate) * Time.deltaTime;
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.Counting, timer)
    WLZBEntry.SetSelfGold(WLZBEntry.myGold);
    self.showResultCallback = function()
        WLZBEntry.megaWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowMageWin = false;
        WLZB_Result.CheckFree();
    end
    self.isShowMageWin = true;
end
function WLZB_Result.ShowMegaWin()
    --Mega奖
    if self.isShowMageWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= WLZBEntry.ResultData.WinScore then
            self.currentRunGold = WLZBEntry.ResultData.WinScore;
        end
        WLZBEntry.megaWinNum.text = WLZBEntry.ShowText(WLZBEntry.FormatNumberThousands(self.currentRunGold));
        if self.timer >= WLZB_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function WLZB_Result.ShowNormalEffect()
    log(11111)
    self.timer = 0;
    self.currentRunGold = 0;
    WLZBEntry.normalWinEffect.gameObject:SetActive(true);
    WLZBEntry.normalWinNum.text = WLZBEntry.ShowText(WLZBEntry.FormatNumberThousands(self.currentRunGold));
    WLZBEntry.normalWinNum.gameObject:SetActive(true);
    WLZBEntry.SetSelfGold(WLZBEntry.myGold);
    self.winRate = math.ceil(WLZBEntry.ResultData.WinScore / (WLZB_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    local timer = (WLZBEntry.ResultData.WinScore / self.winRate) * Time.deltaTime;
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.Counting, timer)
    self.showResultCallback = nil;
    self.showResultCallback = function()
        self.isShowNormal = false;
        self.timer = 0;
        WLZBEntry.normalWinEffect.gameObject:SetActive(false);
        self.CheckFree();
    end
    self.isShowNormal = true;
end
function WLZB_Result.ShowNormal()
    if self.isShowNormal then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= WLZBEntry.ResultData.WinScore then
            self.currentRunGold = WLZBEntry.ResultData.WinScore;
        end
        WLZBEntry.normalWinNum.text = WLZBEntry.ShowText(WLZBEntry.FormatNumberThousands(self.currentRunGold));
        if self.timer >= WLZB_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end