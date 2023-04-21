JSYC_Result = {};

local self = JSYC_Result;

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

function JSYC_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = false;
    self.isPause = false;
end
function JSYC_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = true;
    JSYCEntry.myGold = TableUserInfo._7wGold;
    JSYCEntry.WinNum.text = JSYCEntry.ResultData.WinScore;--JSYCEntry.ShowText(JSYCEntry.ResultData.WinScore);
    --其他正常模式
    if JSYCEntry.ResultData.WinScore > 0 then   
        if JSYCEntry.isFreeGame then
            self.totalFreeGold=self.totalFreeGold+JSYCEntry.ResultData.WinScore
        end
        JSYC_Line.Show();
        local rate = JSYCEntry.ResultData.WinScore / (JSYCEntry.CurrentChip * JSYC_DataConfig.ALLLINECOUNT);
        if rate <= 1 then
            --普通奖  不做显示
            self.notShowWin()
        elseif rate > 1 and rate <= 3 then
            self.ShowNormalEffect()
        elseif rate > 3 and rate <= 8 then
            self.ShowBigWinEffect();
         elseif rate > 8 then
            self.ShowMegaWinEffect();
        end
    else
        self.nowin = true;
        JSYCEntry.SetSelfGold(JSYCEntry.myGold);
    end
end
function JSYC_Result.HideResult()
    for i = 1, JSYCEntry.resultEffect.childCount do
        JSYCEntry.resultEffect:GetChild(i - 1).gameObject:SetActive(false);
    end
    self.timer = 0;
    self.showCSJLCallback = nil;
    self.showResultCallback = nil;
end
function JSYC_Result.Update()
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
end

function JSYC_Result.NoWinWait()
    if self.nowin then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= JSYC_DataConfig.autoNoRewardInterval then
            self.nowin = false;
            JSYCEntry.isRoll = false;
            self.CheckFree();
        end
    end
end
function JSYC_Result.CheckFree()
    JSYCEntry.isRoll = false;
    if not JSYCEntry.isFreeGame then
        if JSYCEntry.ResultData.FreeCount > 0 then
            self.totalFreeGold = self.totalFreeGold + JSYCEntry.ResultData.WinScore;
            JSYC_Line.Close();
            self.ShowFreeEffect(false);
        else
            JSYCEntry.FreeRoll();
        end
    else
        if JSYCEntry.ResultData.FreeCount <= 0 then
            self.ShowFreeResultEffect();
        else
            JSYCEntry.FreeRoll();
        end
    end
end
function JSYC_Result.ShowFreeEffect(isSceneData)
    --展示免费
    JSYC_Audio.PlaySound(JSYC_Audio.SoundList.FreeGameIn);
    JSYCEntry.isFreeGame = true;
    self.timer = 0;
    JSYC_Line.ShowFree();
    JSYCEntry.currentFreeCount = 0;
    self.showResultCallback = function()
        self.timer = 0;
        self.isHideFree = true;
        JSYCEntry.addChipBtn.interactable = false;
        JSYCEntry.reduceChipBtn.interactable = false;
        JSYCEntry.maxChipBtn.interactable = false;
        JSYCEntry.EnterFreeEffect.gameObject:SetActive(true);
        JSYCEntry.GetFreeCount=JSYCEntry.freeCount
        JSYCEntry.FreeResulCount.text = ShowRichText(JSYCEntry.freeCount);
        JSYCEntry.EnterFreeCount.text = ShowRichText(JSYCEntry.freeCount);
        JSYCEntry.SetState(2);
        JSYC_Line.Close();
    end
    self.isShowFree = true;
end
function JSYC_Result.ShowFree()
    if self.isShowFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= JSYC_DataConfig.winGoldChangeRate then
            self.isShowFree = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function JSYC_Result.HideFree()
    --隐藏中奖
    if self.isHideFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= 2.3 then
            --等待退出动画时长
            self.isHideFree = false;
            JSYC_Audio.PlayBGM(JSYC_Audio.SoundList.FreeBGM);
            JSYCEntry.EnterFreeEffect.gameObject:SetActive(false);
            JSYCEntry.FreeRoll();
        end

    end
end
function JSYC_Result.ShowFreeResultEffect()
    --展示免费结果
    self.timer = 0;
    self.currentRunGold = 0;
    JSYCEntry.FreeResultEffect.gameObject:SetActive(true);
    JSYCEntry.FreeResultNum.gameObject:SetActive(true);
    self.FreeTweener = Util.RunWinScore(0,self.totalFreeGold,3, function(value)
        self.currentRunGold = math.floor(value);
        JSYCEntry.FreeResultNum.text = JSYCEntry.ShowText(self.currentRunGold);
    end);

    self.FreeTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        JSYCEntry.FreeResultNum.text = JSYCEntry.ShowText(self.totalFreeGold);
        JSYCEntry.SetSelfGold(JSYCEntry.myGold);
        self.FreeTweener = Util.RunWinScore(0, 1, 1, nil);
        self.FreeTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            JSYCEntry.FreeResultEffect.gameObject:SetActive(false);
            JSYCEntry.FreeResultNum.text = JSYCEntry.ShowText(0);
            JSYCEntry.FreeResulCount.text = JSYCEntry.ShowText(0);
            self.timer = 0;
            self.totalFreeGold=0;
            JSYCEntry.FreeRoll();
        end);
    end);
end
function JSYC_Result.ShowFreeResult()
    if self.isShowTotalFree then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= self.totalFreeGold then
            self.currentRunGold = self.totalFreeGold;
        end
        JSYCEntry.FreeResultNum.text = JSYCEntry.ShowText(self.currentRunGold);
        if self.timer >= JSYC_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

---------------------中奖---------------------
function JSYC_Result.notShowWin()
    JSYC_Audio.PlaySound(JSYC_Audio.SoundList.LINE);
    self.notwinTweener = Util.RunWinScore(0, JSYCEntry.ResultData.WinScore, 1, function(value)
    end);
    self.notwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        JSYCEntry.SetSelfGold(JSYCEntry.myGold);
        self.notwinTweener = Util.RunWinScore(0, 1, 1, nil);
        self.notwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.CheckFree();
        end);
    end);
end

function JSYC_Result.ShowNormalEffect()
    JSYC_Audio.PlaySound(JSYC_Audio.SoundList.BW);

    JSYCEntry.WinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    JSYCEntry.WinEffectNum.text = JSYCEntry.ShowText(self.currentRunGold);
    JSYCEntry.WinEffectNum.gameObject:SetActive(true);
    JSYCEntry.WinEffect:Find("BigWin/win_dh"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "Win_star", false);
    JSYCEntry.WinEffect:Find("BigWin/win_dh"):GetComponent("SkeletonGraphic").AnimationState:AddAnimation(0, "Win_looping", true, 0);
    self.winTweener = Util.RunWinScore(0, JSYCEntry.ResultData.WinScore, 3, function(value)
        self.currentRunGold = math.floor(value);
        JSYCEntry.WinEffectNum.text = JSYCEntry.ShowText(self.currentRunGold);
    end);

    self.winTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        JSYCEntry.WinEffectNum.text = JSYCEntry.ShowText(JSYCEntry.ResultData.WinScore);
        JSYCEntry.SetSelfGold(JSYCEntry.myGold);
        JSYCEntry.WinEffect:Find("BigWin/win_dh"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "Win_end", false);
        self.winTweener = Util.RunWinScore(0, 1, 1, nil);
        self.winTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            JSYCEntry.WinEffect.gameObject:SetActive(false);
            self.CheckFree();
        end);
    end);
end

function JSYC_Result.ShowBigWinEffect()
    --BigWin奖动画
    JSYC_Audio.PlaySound(JSYC_Audio.SoundList.BW);

    JSYCEntry.bigWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    JSYCEntry.bigWinNum.text = JSYCEntry.ShowText(self.currentRunGold);
    JSYCEntry.bigWinNum.gameObject:SetActive(true);
    JSYCEntry.bigWinEffect:Find("BigWin/win_dh"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "BigWin_star", false);
    JSYCEntry.bigWinEffect:Find("BigWin/win_dh"):GetComponent("SkeletonGraphic").AnimationState:AddAnimation(0, "BigWin_looping", true, 0);
    self.BigwinTweener = Util.RunWinScore(0, JSYCEntry.ResultData.WinScore, 3, function(value)
        self.currentRunGold = math.floor(value);
        JSYCEntry.bigWinNum.text = JSYCEntry.ShowText(self.currentRunGold);
    end);
    self.BigwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        JSYCEntry.bigWinNum.text = JSYCEntry.ShowText(JSYCEntry.ResultData.WinScore);
        JSYCEntry.SetSelfGold(JSYCEntry.myGold);
        JSYCEntry.bigWinEffect:Find("BigWin/win_dh"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "BigWin_end", false);
        self.BigwinTweener = Util.RunWinScore(0, 1, 1, nil);
        self.BigwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            JSYCEntry.bigWinEffect.gameObject:SetActive(false);
            self.CheckFree();
        end);
    end);
end

function JSYC_Result.ShowMegaWinEffect()
    --Mega奖动画
    JSYC_Audio.PlaySound(JSYC_Audio.SoundList.BW);
    JSYCEntry.megaWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    JSYCEntry.megaWinNum.text = JSYCEntry.ShowText(self.currentRunGold);
    JSYCEntry.megaWinNum.gameObject:SetActive(true);
    JSYCEntry.megaWinEffect:Find("BigWin/win_dh"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "MegaWin_star", false);
    JSYCEntry.megaWinEffect:Find("BigWin/win_dh"):GetComponent("SkeletonGraphic").AnimationState:AddAnimation(0, "MegaWin_looping", true, 0);
    self.winTweener = Util.RunWinScore(0, JSYCEntry.ResultData.WinScore, 3, function(value)
        self.currentRunGold = math.floor(value);
        JSYCEntry.megaWinNum.text = JSYCEntry.ShowText(self.currentRunGold);
    end);
    self.winTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        JSYCEntry.megaWinNum.text = JSYCEntry.ShowText(JSYCEntry.ResultData.WinScore);
        JSYCEntry.SetSelfGold(JSYCEntry.myGold);
        JSYCEntry.megaWinEffect:Find("BigWin/win_dh"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "MegaWin_end", false);
        self.winTweener = Util.RunWinScore(0, 1, 1, nil);
        self.winTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            JSYCEntry.megaWinEffect.gameObject:SetActive(false);
            self.CheckFree();
        end);
    end);
end


function JSYC_Result.ShowBigWin()
    --BigWin奖
    -- if self.isShowBigWin then
    --     self.timer = self.timer + Time.deltaTime;
    --     self.currentRunGold = self.currentRunGold + self.winRate;
    --     if self.currentRunGold >= JSYCEntry.ResultData.WinScore then
    --         self.currentRunGold = JSYCEntry.ResultData.WinScore;
    --     end
    --     JSYCEntry.bigWinNum.text = JSYCEntry.ShowText(self.currentRunGold);
    --     if self.timer >= JSYC_DataConfig.winGoldChangeRate then
    --         if self.showResultCallback ~= nil then
    --             self.showResultCallback();
    --         end
    --     end
    -- end
end
function JSYC_Result.ShowSuperWinffect()
    --Super奖动画
    --JSYC_Audio.PlaySound(JSYC_Audio.SoundList.SW, JSYC_DataConfig.winGoldChangeRate);
    JSYCEntry.superWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    JSYCEntry.superWinNum.text = JSYCEntry.ShowText(self.currentRunGold);
    JSYCEntry.superWinNum.gameObject:SetActive(true);
    self.winRate = math.ceil(JSYCEntry.ResultData.WinScore / (JSYC_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    JSYCEntry.SetSelfGold(JSYCEntry.myGold);
    self.showResultCallback = function()
        JSYCEntry.superWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowSuperWin = false;
        JSYC_Result.CheckFree();
    end
    self.isShowSuperWin = true;
end
function JSYC_Result.ShowSuperWin()
    --Super奖
    if self.isShowSuperWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= JSYCEntry.ResultData.WinScore then
            self.currentRunGold = JSYCEntry.ResultData.WinScore;
        end
        JSYCEntry.superWinNum.text = JSYCEntry.ShowText(self.currentRunGold);
        if self.timer >= JSYC_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function JSYC_Result.ShowMegaWin()
    --Mega奖
    -- if self.isShowMageWin then
    --     self.timer = self.timer + Time.deltaTime;
    --     self.currentRunGold = self.currentRunGold + self.winRate;
    --     if self.currentRunGold >= JSYCEntry.ResultData.WinScore then
    --         self.currentRunGold = JSYCEntry.ResultData.WinScore;
    --     end
    --     JSYCEntry.megaWinNum.text = JSYCEntry.ShowText(self.currentRunGold);
    --     if self.timer >= JSYC_DataConfig.winGoldChangeRate then
    --         if self.showResultCallback ~= nil then
    --             self.showResultCallback();
    --         end
    --     end
    -- end
end

function JSYC_Result.ShowNormal()
    -- if self.isShowNormal then
    --     self.timer = self.timer + Time.deltaTime;
    --     if self.timer >= JSYC_DataConfig.winGoldChangeRate / 2 then
    --         if self.showResultCallback ~= nil then
    --             self.showResultCallback();
    --         end
    --     end
    -- end
end

