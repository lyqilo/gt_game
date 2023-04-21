TGG_Result = {};

local self = TGG_Result;

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
self.isnullWin=false
self.waitnullTime=0

function TGG_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = false;
    self.isPause = false;
end
function TGG_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = true;
    TGGEntry.myGold = TableUserInfo._7wGold;
    TGGEntry.WinNum.text = TGGEntry.ShowText(TGGEntry.ResultData.WinScore);
    --其他正常模式
    if TGGEntry.ResultData.WinScore > 0 then   
        TGG_Line.Show();
        local rate = TGGEntry.ResultData.WinScore / (TGGEntry.CurrentChip * TGG_DataConfig.ALLLINECOUNT);
        if rate < 2 then
            --普通奖  不做显示
            TGG_Result.ShowNormalEffect()
        elseif rate >= 2 and rate < 5 then
            --bigwin
            self.ShowBigWinEffect();
        elseif rate >= 5 and rate < 8 then
            --megewin
            self.ShowMegaWinEffect();
        elseif rate >= 8 then
            --superwin
            self.ShowSuperWinffect()
        end
    else
        self.nowin = true;
        TGGEntry.SetSelfGold(TGGEntry.myGold);
        --self.isnullWin=true
        coroutine.start(self.ShowCSGroup)
    end
end

function TGG_Result.ShowCSGroup()
    coroutine.wait(0.4)
    TGGEntry.CSGroup.gameObject:SetActive(true);
end

function TGG_Result.HideResult()
    for i = 1, TGGEntry.resultEffect.childCount do
        TGGEntry.resultEffect:GetChild(i - 1).gameObject:SetActive(false);
    end
    self.timer = 0;
    self.showCSJLCallback = nil;
    self.showResultCallback = nil;
end
function TGG_Result.Update()
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

    -- if self.isnullWin then
    --     self.waitnullTime=waitnullTime+Time.deltaTime
    --     if condition then
            
    --     end
    -- end

end

function TGG_Result.NoWinWait()
    if self.nowin then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= TGG_DataConfig.autoNoRewardInterval then
            self.nowin = false;
            TGGEntry.isRoll = false;
            self.CheckFree();
        end
    end
end
function TGG_Result.CheckFree()
    TGGEntry.isRoll = false;
    if not TGGEntry.isFreeGame then
        if TGGEntry.ResultData.FreeCount > 0 then
            TGG_Line.Close();
            self.ShowFreeEffect(false);
        else
            TGGEntry.FreeRoll();
        end
    else
        self.totalFreeGold = self.totalFreeGold + TGGEntry.ResultData.WinScore;
        if TGGEntry.ResultData.FreeCount <= 0 then
            self.ShowFreeResultEffect();
        else
            TGGEntry.FreeRoll();
        end
    end
end
function TGG_Result.ShowFreeEffect(isSceneData)
    --展示免费
    TGGEntry.isFreeGame = true;
    self.timer = 0;
    TGG_Line.ShowFree();
    TGGEntry.currentFreeCount = 0;
    self.showResultCallback = function()
        self.timer = 0;
        self.isHideFree = true;
        TGGEntry.addChipBtn.interactable = false;
        TGGEntry.reduceChipBtn.interactable = false;
        TGGEntry.EnterFreeEffect.gameObject:SetActive(true);
        TGGEntry.EnterFreeCount.text = TGGEntry.ShowText(TGGEntry.freeCount);
        TGGEntry.SetState(2);
        TGG_Line.Close();
    end
    self.isShowFree = true;
end
function TGG_Result.ShowFree()
    if self.isShowFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= TGG_DataConfig.winGoldChangeRate then
            self.isShowFree = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function TGG_Result.HideFree()
    --隐藏中奖
    if self.isHideFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= TGG_DataConfig.smallGameLoadingShowTime then
            --等待退出动画时长
            self.isHideFree = false;
            TGG_Audio.PlayBGM(TGG_Audio.SoundList.FreeBGM);
            TGGEntry.EnterFreeEffect.gameObject:SetActive(false);
            TGGEntry.FreeRoll();
        end

    end
end
function TGG_Result.ShowFreeResultEffect()
    --展示免费结果
    self.timer = 0;
    self.currentRunGold = 0;
    self.showResultCallback = function()
        self.isShowTotalFree = false;
        TGGEntry.FreeResultEffect.gameObject:SetActive(false);
        self.timer = 0;
        TGGEntry.FreeRoll();
    end
    TGGEntry.FreeResultEffect.gameObject:SetActive(true);
    TGGEntry.FreeResultNum.gameObject:SetActive(true);
    self.winRate = math.ceil(self.totalFreeGold / (TGG_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    self.isShowTotalFree = true;
end
function TGG_Result.ShowFreeResult()
    if self.isShowTotalFree then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= self.totalFreeGold then
            self.currentRunGold = self.totalFreeGold;
        end
        TGGEntry.FreeResultNum.text = TGGEntry.ShowText(self.currentRunGold);
        if self.timer >= TGG_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

---------------------中奖---------------------
function TGG_Result.ShowBigWinEffect()
    --BigWin奖动画
    TGG_Audio.PlaySound(TGG_Audio.SoundList.BW, TGG_DataConfig.winGoldChangeRate);
    TGGEntry.bigWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    TGGEntry.bigWinNum.text = TGGEntry.ShowText(self.currentRunGold);
    TGGEntry.bigWinNum.gameObject:SetActive(true);
    self.winRate = math.ceil(TGGEntry.ResultData.WinScore / (TGG_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    TGGEntry.SetSelfGold(TGGEntry.myGold);
    self.showResultCallback = function()
        TGGEntry.bigWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowBigWin = false;
        TGG_Result.CheckFree();
    end
    log("big=====" .. TGG_DataConfig.winGoldChangeRate);
    self.isShowBigWin = true;
end
function TGG_Result.ShowBigWin()
    --BigWin奖
    if self.isShowBigWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= TGGEntry.ResultData.WinScore then
            self.currentRunGold = TGGEntry.ResultData.WinScore;
        end
        TGGEntry.bigWinNum.text = TGGEntry.ShowText(self.currentRunGold);
        if self.timer >= TGG_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function TGG_Result.ShowSuperWinffect()
    --Super奖动画
    TGG_Audio.PlaySound(TGG_Audio.SoundList.SW, TGG_DataConfig.winGoldChangeRate);
    TGGEntry.superWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    TGGEntry.superWinNum.text = TGGEntry.ShowText(self.currentRunGold);
    TGGEntry.superWinNum.gameObject:SetActive(true);
    self.winRate = math.ceil(TGGEntry.ResultData.WinScore / (TGG_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    TGGEntry.SetSelfGold(TGGEntry.myGold);
    self.showResultCallback = function()
        TGGEntry.superWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowSuperWin = false;
        TGG_Result.CheckFree();
    end
    self.isShowSuperWin = true;
end
function TGG_Result.ShowSuperWin()
    --Super奖
    if self.isShowSuperWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= TGGEntry.ResultData.WinScore then
            self.currentRunGold = TGGEntry.ResultData.WinScore;
        end
        TGGEntry.superWinNum.text = TGGEntry.ShowText(self.currentRunGold);
        if self.timer >= TGG_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function TGG_Result.ShowMegaWinEffect()
    --Mega奖动画
    TGG_Audio.PlaySound(TGG_Audio.SoundList.MW, TGG_DataConfig.winGoldChangeRate);
    TGGEntry.megaWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    TGGEntry.megaWinNum.text = TGGEntry.ShowText(self.currentRunGold);
    TGGEntry.megaWinNum.gameObject:SetActive(true);
    self.winRate = math.ceil(TGGEntry.ResultData.WinScore / (TGG_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    TGGEntry.SetSelfGold(TGGEntry.myGold);
    self.showResultCallback = function()
        TGGEntry.megaWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowMageWin = false;
        TGG_Result.CheckFree();
    end
    self.isShowMageWin = true;
end
function TGG_Result.ShowMegaWin()
    --Mega奖
    if self.isShowMageWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= TGGEntry.ResultData.WinScore then
            self.currentRunGold = TGGEntry.ResultData.WinScore;
        end
        TGGEntry.megaWinNum.text = TGGEntry.ShowText(self.currentRunGold);
        if self.timer >= TGG_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function TGG_Result.ShowNormalEffect()
    TGGEntry.normalWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    TGGEntry.normalWinNum.text = TGGEntry.ShowText(self.currentRunGold);
    TGGEntry.normalWinNum.gameObject:SetActive(true);
    self.winRate = math.ceil(TGGEntry.ResultData.WinScore / (TGG_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    TGGEntry.SetSelfGold(TGGEntry.myGold);
    self.showResultCallback = nil;
    self.showResultCallback = function()
        TGGEntry.normalWinEffect.gameObject:SetActive(false);
        self.isShowNormal = false;
        self.timer = 0;
        self.CheckFree();
    end
    self.isShowNormal = true;
end
function TGG_Result.ShowNormal()
    if self.isShowNormal then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= TGGEntry.ResultData.WinScore then
            self.currentRunGold = TGGEntry.ResultData.WinScore;
        end
        TGGEntry.normalWinNum.text = TGGEntry.ShowText(self.currentRunGold);
        if self.timer >= TGG_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end