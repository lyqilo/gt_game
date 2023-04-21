JZSF_Result = {};

local self = JZSF_Result;

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

function JZSF_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = false;
    self.isPause = false;
end
function JZSF_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = true;
    JZSFEntry.myGold = TableUserInfo._7wGold;
    JZSFEntry.WinNum.text = JZSFEntry.ShowText(JZSFEntry.ResultData.WinScore);
    --其他正常模式
    if JZSFEntry.isFreeGame then
        self.totalFreeGold = self.totalFreeGold + JZSFEntry.ResultData.WinScore;
        --JZSFEntry.freeWinNum.text = JZSFEntry.ShowText(JZSFEntry.FormatNumberThousands(JZSF_Result.totalFreeGold));
    end
    if JZSFEntry.ResultData.WinScore > 0 then
        local resultCall = function()
            JZSF_Line.Show();
            -- if JZSFEntry.isFreeGame then
            --     JZSF_Audio.PlaySound(JZSF_Audio.SoundList.FreeResult);
            -- end
            JZSFEntry.resultEffect.gameObject:SetActive(true);
            local rate = JZSFEntry.ResultData.m_nWinPeiLv / JZSF_DataConfig.ALLLINECOUNT;
            if rate < 3 then
                --普通奖  不做显示    
                self.ShowBigWinEffect();
            -- elseif rate >= 2 and rate < 3 then
                --bigwin 
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
        JZSF_Line.ShowNoReward();
        JZSFEntry.SetSelfGold(JZSFEntry.myGold);
    end
end
function JZSF_Result.HideResult()
    for i = 1, JZSFEntry.resultEffect.childCount do
        JZSFEntry.resultEffect:GetChild(i - 1).gameObject:SetActive(false);
    end

    JZSFEntry.resultEffect.gameObject:SetActive(false);
    self.timer = 0;
    self.showCSJLCallback = nil;
    self.showResultCallback = nil;
end
function JZSF_Result.Update()
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

function JZSF_Result.NoWinWait()
    if self.nowin then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= JZSF_DataConfig.autoNoRewardInterval then
            self.nowin = false;
            self.CheckFree();
        end
    end
end
function JZSF_Result.CheckFree()
    JZSFEntry.isRoll = false;
    JZSFEntry.resultEffect.gameObject:SetActive(false);
    if not JZSFEntry.isFreeGame then
        if JZSFEntry.ResultData.FreeCount > 0 then
            JZSF_Line.Close();
            self.ShowFreeEffect(false);
        else
            JZSFEntry.FreeRoll();
        end
    else
        if JZSFEntry.freeCount <= 0 then
            self.ShowFreeResultEffect();
        else
            JZSFEntry.FreeRoll();
        end
    end
end
function JZSF_Result.ShowFreeEffect(isSceneData)
    --展示免费
    JZSFEntry.isFreeGame = true;
    self.timer = 0;
    JZSFEntry.addChipBtn.interactable = false;
    JZSFEntry.reduceChipBtn.interactable = false;
    JZSFEntry.MaxChipBtn.interactable = false;
    JZSFEntry.resultEffect.gameObject:SetActive(true);
    JZSFEntry.EnterFreeEffect.gameObject:SetActive(true);
    JZSFEntry.FreeContent.gameObject:SetActive(true);
    JZSFEntry.AutoContent.gameObject:SetActive(false);
    JZSFEntry.Show_Free:SetActive(true)

    --JZSFEntry.startBtn.AnimationState:SetAnimation(0, "freetimes", true);

    JZSFEntry.normalBackground:SetActive(false);
    JZSFEntry.freeBackground:SetActive(true);

    -- JZSF_Network.StartFreeGame()
    JZSFEntry.EnterFreeEffect.gameObject:SetActive(true);
    JZSFEntry.EnterFreeEffectFreeCount.text=JZSFEntry.ShowText(JZSFEntry.freeCount,false);
    JZSFEntry.FreeResulCount.text = JZSFEntry.ShowText(JZSFEntry.freeCount,false);
    --JZSFEntry.freeWinNum.text = JZSFEntry.ShowText("0");
    JZSF_Line.ShowFree();
    JZSFEntry.currentFreeCount = 0;

    self.EnterFreeEffectTweener=Util.RunWinScore(0, 1, 2, function(value)
    end);
    self.EnterFreeEffectTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        self.isHideFree = false;
        JZSF_Audio.PlayBGM(JZSF_Audio.SoundList.FreeBGM);
        JZSFEntry.EnterFreeEffect.gameObject:SetActive(false);
        JZSFEntry.FreeRoll();
    end);

    -- self.showResultCallback = function()
    --     --JZSFEntry.EnterFreeEffect.gameObject:SetActive(false);
    --     self.timer = 0;
    --     self.isHideFree = true;
    --     JZSF_Line.Close();
    -- end
    -- self.isShowFree = true;
end
function JZSF_Result.ShowFree()
    if self.isShowFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= JZSF_DataConfig.winGoldChangeRate then
            self.isShowFree = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function JZSF_Result.HideFree()
    --隐藏中奖
    if self.isHideFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= JZSF_DataConfig.smallGameLoadingShowTime then
            --等待退出动画时长
            self.isHideFree = false;
            JZSF_Audio.PlayBGM(JZSF_Audio.SoundList.FreeBGM);
            JZSFEntry.EnterFreeEffect.gameObject:SetActive(false);
            XYSGJEntry.FreeRoll();
            --JZSFEntry.SelectFreeEffect.gameObject:SetActive(true);
            -- JZSFEntry.selectBtnGroup.parent.gameObject:SetActive(true);
            -- JZSFEntry.selectResult.gameObject:SetActive(false);
        end

    end
end
function JZSF_Result.ShowFreeResultEffect()
    --展示免费结果
    JZSF_Audio.PlaySound(JZSF_Audio.SoundList.FreeResult);
    self.timer = 0;
    self.currentRunGold = 0;
    self.showResultCallback = function()
        self.isShowTotalFree = false;
        JZSFEntry.FreeResultEffect.gameObject:SetActive(false);
        JZSFEntry.resultEffect.gameObject:SetActive(false);
        self.timer = 0;
        JZSFEntry.FreeRoll();
    end
    JZSFEntry.Show_Free:SetActive(false)

    JZSFEntry.resultEffect.gameObject:SetActive(true);
    JZSFEntry.FreeResultEffect.gameObject:SetActive(true);
    JZSFEntry.FreeResultNum.gameObject:SetActive(true);
    self.winRate = math.ceil(self.totalFreeGold / (JZSF_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    JZSFEntry.FreeResultNum.text = JZSFEntry.ShowText(self.currentRunGold);
    self.isShowTotalFree = true;
end
function JZSF_Result.ShowFreeResult()
    if self.isShowTotalFree then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= self.totalFreeGold then
            self.currentRunGold = self.totalFreeGold;
        end
        JZSFEntry.FreeResultNum.text = JZSFEntry.ShowText(self.currentRunGold);
        if self.timer >= JZSF_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function JZSF_Result.ShowSelectFreeResultEffect()
    self.timer = 0;
    JZSFEntry.selectBtnGroup.parent.gameObject:SetActive(false);
    JZSFEntry.selectResult.gameObject:SetActive(true);
    JZSFEntry.selectCount.text = JZSFEntry.ShowText(JZSFEntry.FreeData.nFreeCount,false);
    JZSFEntry.selectRate.text = JZSFEntry.ShowText(JZSFEntry.FreeData.nFreeOddIndex,false);
    self.showResultCallback = function()
        self.isShowSelectFreeResult = false;
        JZSFEntry.selectResult.gameObject:SetActive(false);
        self.CheckFree();
    end
    self.isShowSelectFreeResult = true;
end
function JZSF_Result.ShowSelectFreeResult()
    if self.isShowSelectFreeResult then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= JZSF_DataConfig.showSelectFreeResultTime then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

---------------------中奖---------------------
function JZSF_Result.ShowBigWinEffect()
    --BigWin奖动画
    log("big=====");
    --JZSF_Audio.PlaySound(JZSF_Audio.SoundList.BW);
    JZSFEntry.bigWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    JZSFEntry.bigWinNum.text = JZSFEntry.ShowText(JZSFEntry.FormatNumberThousands(self.currentRunGold));
    JZSFEntry.bigWinNum.gameObject:SetActive(true);
    self.BigwinTweener1=Util.RunWinScore(0, 1, 0.5, function(value)
    end);
    self.BigwinTweener1:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        self.BigwinTweener = Util.RunWinScore(0, JZSFEntry.ResultData.WinScore, 1.5, function(value)
            self.currentRunGold = math.floor(value);
            JZSFEntry.bigWinNum.text = JZSFEntry.ShowText(self.currentRunGold);
        end);
        self.BigwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.BigwinTweener2=Util.RunWinScore(0, 1, 0.5, function(value)end);
            self.BigwinTweener2:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                JZSFEntry.bigWinNum.text = JZSFEntry.ShowText(JZSFEntry.ResultData.WinScore);
                JZSFEntry.SetSelfGold(JZSFEntry.myGold);
                JZSFEntry.bigWinEffect.gameObject:SetActive(false);
                self.BigwinTweener3 = Util.RunWinScore(0, 1, 1, nil);
                self.BigwinTweener3:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                    self.CheckFree();
                end);
            end);
        end);
    end);
end
function JZSF_Result.ShowBigWin()
    --BigWin奖
    if self.isShowBigWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= JZSFEntry.ResultData.WinScore then
            self.currentRunGold = JZSFEntry.ResultData.WinScore;
        end
        JZSFEntry.bigWinNum.text = JZSFEntry.ShowText(JZSFEntry.FormatNumberThousands(self.currentRunGold));
        if self.timer >= JZSF_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function JZSF_Result.ShowSuperWinffect()
    --Super奖动画
    --JZSF_Audio.PlaySound(JZSF_Audio.SoundList.SW, JZSF_DataConfig.winGoldChangeRate);
    JZSFEntry.superWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    JZSFEntry.superWinNum.text = JZSFEntry.ShowText(JZSFEntry.FormatNumberThousands(self.currentRunGold));
    JZSFEntry.superWinNum.gameObject:SetActive(true);

    self.superwinTweener1=Util.RunWinScore(0, 1, 0.5, function(value)
    end);
    self.superwinTweener1:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        self.superwinTweener = Util.RunWinScore(0, JZSFEntry.ResultData.WinScore, 1.5, function(value)
            self.currentRunGold = math.floor(value);
            JZSFEntry.superWinNum.text = JZSFEntry.ShowText(self.currentRunGold);
        end);
        self.superwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.BigwinTweener2=Util.RunWinScore(0, 1, 0.5, function(value)end);
            self.BigwinTweener2:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                
                JZSFEntry.superWinNum.text = JZSFEntry.ShowText(JZSFEntry.ResultData.WinScore);
                JZSFEntry.SetSelfGold(JZSFEntry.myGold);
                JZSFEntry.superWinEffect.gameObject:SetActive(false);

                self.superwinTweener3 = Util.RunWinScore(0, 1, 1, nil);
                self.superwinTweener3:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                    self.CheckFree();
                end);
            end);
        end);
    end);
end
function JZSF_Result.ShowSuperWin()
    --Super奖
    if self.isShowSuperWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= JZSFEntry.ResultData.WinScore then
            self.currentRunGold = JZSFEntry.ResultData.WinScore;
        end
        JZSFEntry.superWinNum.text = JZSFEntry.ShowText(JZSFEntry.FormatNumberThousands(self.currentRunGold));
        if self.timer >= JZSF_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function JZSF_Result.ShowMegaWinEffect()
    --Mega奖动画
    --JZSF_Audio.PlaySound(JZSF_Audio.SoundList.MW, JZSF_DataConfig.winGoldChangeRate);
    JZSFEntry.megaWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    JZSFEntry.megaWinNum.text = JZSFEntry.ShowText(JZSFEntry.FormatNumberThousands(self.currentRunGold));
    JZSFEntry.megaWinNum.gameObject:SetActive(true);

    self.megaWinTweener1=Util.RunWinScore(0, 1, 0.5, function(value)
    end);
    self.megaWinTweener1:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        self.megaWinTweener = Util.RunWinScore(0, JZSFEntry.ResultData.WinScore, 1.5, function(value)
            self.currentRunGold = math.floor(value);
            JZSFEntry.megaWinNum.text = JZSFEntry.ShowText(self.currentRunGold);
        end);
        self.megaWinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.megaWinTweener2=Util.RunWinScore(0, 1, 0.5, function(value)end);
            self.megaWinTweener2:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                JZSFEntry.megaWinNum.text = JZSFEntry.ShowText(JZSFEntry.ResultData.WinScore);
                JZSFEntry.SetSelfGold(JZSFEntry.myGold);
                JZSFEntry.megaWinEffect.gameObject:SetActive(false);
                self.megaWinTweener3 = Util.RunWinScore(0, 1, 1, nil);
                self.megaWinTweener3:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                    self.CheckFree();
                end);
            end);
        end);
    end);
end
function JZSF_Result.ShowMegaWin()
    --Mega奖
    if self.isShowMageWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= JZSFEntry.ResultData.WinScore then
            self.currentRunGold = JZSFEntry.ResultData.WinScore;
        end
        JZSFEntry.megaWinNum.text = JZSFEntry.ShowText(JZSFEntry.FormatNumberThousands(self.currentRunGold));
        if self.timer >= JZSF_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function JZSF_Result.ShowNormalEffect()
    log(11111)
    self.timer = 0;
    self.currentRunGold = 0;
    JZSFEntry.normalWinEffect.gameObject:SetActive(true);
    JZSFEntry.normalWinNum.text = JZSFEntry.ShowText(JZSFEntry.FormatNumberThousands(self.currentRunGold));
    JZSFEntry.normalWinNum.gameObject:SetActive(true);

    self.normalWinTweener = Util.RunWinScore(0, JZSFEntry.ResultData.WinScore, 1.5, function(value)
        self.currentRunGold = math.floor(value);
        JZSFEntry.normalWinNum.text = JZSFEntry.ShowText(self.currentRunGold);
    end);
    self.normalWinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        self.normalWinTweener2=Util.RunWinScore(0, 1, 0.5, function(value)end);
        self.normalWinTweener2:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            JZSFEntry.normalWinNum.text = JZSFEntry.ShowText(JZSFEntry.ResultData.WinScore);
            JZSFEntry.SetSelfGold(JZSFEntry.myGold);
            JZSFEntry.normalWinEffect.gameObject:SetActive(false);
            self.normalWinTweener3 = Util.RunWinScore(0, 1, 1, nil);
            self.normalWinTweener3:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                self.CheckFree();
            end);
        end);
    end);
end
function JZSF_Result.ShowNormal()
    if self.isShowNormal then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= JZSFEntry.ResultData.WinScore then
            self.currentRunGold = JZSFEntry.ResultData.WinScore;
        end
        JZSFEntry.normalWinNum.text = JZSFEntry.ShowText(JZSFEntry.FormatNumberThousands(self.currentRunGold));
        if self.timer >= JZSF_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end