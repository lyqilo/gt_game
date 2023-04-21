JPM_Result = {};

local self = JPM_Result;

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

self.WinningLineNum=0

function JPM_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = false;
    self.isPause = false;
end
function JPM_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = true;
    JPMEntry.myGold = TableUserInfo._7wGold;
    JPMEntry.WinNum.text = JPMEntry.ShowText(JPMEntry.ResultData.WinScore);
    if self.WinningLineNum>0 then
        JPMEntry.TipText.text="Great!"..self.WinningLineNum.."lines"
    else
        JPMEntry.TipText.text=""
    end

    --其他正常模式
    if JPMEntry.ResultData.WinScore > 0 then   
        JPM_Line.Show();
        local rate = JPMEntry.ResultData.WinScore / (JPMEntry.CurrentChip * JPM_DataConfig.ALLLINECOUNT);
        if rate < 3 then
            --普通奖  不做显示
            JPM_Result.ShowNormalEffect()
        elseif rate >= 3 then
            self.ShowBigWinEffect();
        end
    else
        JPMEntry.SetSelfGold(JPMEntry.myGold);
        coroutine.start(self.ShowCSGroup)
    end
end

function JPM_Result.ShowCSGroup()
    coroutine.wait(0.3)
    self.timer=0
    self.nowin = true;
    JPMEntry.CSGroup.gameObject:SetActive(true);
end


function JPM_Result.HideResult()
    for i = 1, JPMEntry.resultEffect.childCount do
        JPMEntry.resultEffect:GetChild(i - 1).gameObject:SetActive(false);
    end
    JPMEntry.CSGroup.gameObject:SetActive(false);
    self.timer = 0;
    self.showCSJLCallback = nil;
    self.showResultCallback = nil;
end
function JPM_Result.Update()
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

function JPM_Result.NoWinWait()
    if self.nowin then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= JPM_DataConfig.autoNoRewardInterval then
            self.nowin = false;
            JPMEntry.isRoll = false;
            self.CheckFree();
        end
    end
end
function JPM_Result.CheckFree()
    JPMEntry.isRoll = false;
    if not JPMEntry.isFreeGame then
        if JPMEntry.ResultData.FreeCount > 0 then
            self.totalFreeGold = self.totalFreeGold + JPMEntry.ResultData.WinScore;
            JPM_Line.Close();
            self.ShowFreeEffect(false);
        else
            JPMEntry.FreeRoll();
        end
    else
        if JPMEntry.ResultData.FreeCount <= 0 then
            self.ShowFreeResultEffect();
        else
            JPMEntry.FreeRoll();
        end
    end
end
function JPM_Result.ShowFreeEffect(isSceneData)
    --展示免费
    JPMEntry.isFreeGame = true;
    self.timer = 0;
    --JPM_Line.ShowFree();
    JPMEntry.currentFreeCount = 0;
    self.showResultCallback = function()
        self.timer = 0;
        self.isHideFree = true;
        JPMEntry.addChipBtn.interactable = false;
        JPMEntry.reduceChipBtn.interactable = false;
        JPMEntry.BigBtn.interactable = false;
        JPMEntry.EnterFreeEffect.gameObject:SetActive(true);
        JPMEntry.EnterFreeCount.text ="Free Game"..JPMEntry.freeCount.."times" --JPMEntry.ShowText(JPMEntry.freeCount);
        JPMEntry.SetState(2);
        JPM_Line.Close();
    end
    self.isShowFree = true;
end
function JPM_Result.ShowFree()
    if self.isShowFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= JPM_DataConfig.winGoldChangeRate then
            self.isShowFree = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function JPM_Result.HideFree()
    --隐藏中奖
    if self.isHideFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= JPM_DataConfig.smallGameLoadingShowTime then
            --等待退出动画时长
            self.isHideFree = false;
            --JPM_Audio.PlayBGM(JPM_Audio.SoundList.FreeBGM);
            JPMEntry.EnterFreeEffect.gameObject:SetActive(false);
            JPMEntry.FreeRoll();
        end

    end
end
function JPM_Result.ShowFreeResultEffect()
    --展示免费结果
    self.timer = 0;
    self.currentRunGold = 0;
    self.showResultCallback = function()
        self.isShowTotalFree = false;
        JPMEntry.FreeResultEffect.gameObject:SetActive(false);
        self.timer = 0;
        JPMEntry.FreeRoll();
    end
    JPMEntry.FreeResultEffect.gameObject:SetActive(true);
    JPMEntry.FreeResultNum.gameObject:SetActive(true);
    self.winRate = math.ceil(self.totalFreeGold / (JPM_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    self.isShowTotalFree = true;
end
function JPM_Result.ShowFreeResult()
    if self.isShowTotalFree then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= self.totalFreeGold then
            self.currentRunGold = self.totalFreeGold;
        end
        JPMEntry.FreeResultNum.text ="Free win".."\n"..ShortNumber(self.currentRunGold) --JPMEntry.ShowText(self.currentRunGold);
        if self.timer >= JPM_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

---------------------中奖---------------------
function JPM_Result.ShowBigWinEffect()
    --BigWin奖动画
    --JPM_Audio.PlaySound(JPM_Audio.SoundList.BW, JPM_DataConfig.winGoldChangeRate);
    JPMEntry.bigWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    JPMEntry.bigWinNum.text = JPMEntry.ShowText(self.currentRunGold);
    JPMEntry.bigWinNum.gameObject:SetActive(true);
    self.winRate = math.ceil(JPMEntry.ResultData.WinScore / (JPM_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    JPMEntry.SetSelfGold(JPMEntry.myGold);
    self.showResultCallback = function()
        JPMEntry.bigWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowBigWin = false;
        JPM_Result.CheckFree();
    end
    log("big=====" .. JPM_DataConfig.winGoldChangeRate);
    self.isShowBigWin = true;
end
function JPM_Result.ShowBigWin()
    --BigWin奖
    if self.isShowBigWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= JPMEntry.ResultData.WinScore then
            self.currentRunGold = JPMEntry.ResultData.WinScore;
        end
        JPMEntry.bigWinNum.text = JPMEntry.ShowText(self.currentRunGold);
        if self.timer >= JPM_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function JPM_Result.ShowSuperWinffect()
    --Super奖动画
    --JPM_Audio.PlaySound(JPM_Audio.SoundList.SW, JPM_DataConfig.winGoldChangeRate);
    JPMEntry.superWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    JPMEntry.superWinNum.text = JPMEntry.ShowText(self.currentRunGold);
    JPMEntry.superWinNum.gameObject:SetActive(true);
    self.winRate = math.ceil(JPMEntry.ResultData.WinScore / (JPM_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    JPMEntry.SetSelfGold(JPMEntry.myGold);
    self.showResultCallback = function()
        JPMEntry.superWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowSuperWin = false;
        JPM_Result.CheckFree();
    end
    self.isShowSuperWin = true;
end
function JPM_Result.ShowSuperWin()
    --Super奖
    if self.isShowSuperWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= JPMEntry.ResultData.WinScore then
            self.currentRunGold = JPMEntry.ResultData.WinScore;
        end
        JPMEntry.superWinNum.text = JPMEntry.ShowText(self.currentRunGold);
        if self.timer >= JPM_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function JPM_Result.ShowMegaWinEffect()
    --Mega奖动画
    --JPM_Audio.PlaySound(JPM_Audio.SoundList.MW, JPM_DataConfig.winGoldChangeRate);
    JPMEntry.megaWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    JPMEntry.megaWinNum.text = JPMEntry.ShowText(self.currentRunGold);
    JPMEntry.megaWinNum.gameObject:SetActive(true);
    self.winRate = math.ceil(JPMEntry.ResultData.WinScore / (JPM_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    JPMEntry.SetSelfGold(JPMEntry.myGold);
    self.showResultCallback = function()
        JPMEntry.megaWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowMageWin = false;
        JPM_Result.CheckFree();
    end
    self.isShowMageWin = true;
end
function JPM_Result.ShowMegaWin()
    --Mega奖
    if self.isShowMageWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= JPMEntry.ResultData.WinScore then
            self.currentRunGold = JPMEntry.ResultData.WinScore;
        end
        JPMEntry.megaWinNum.text = JPMEntry.ShowText(self.currentRunGold);
        if self.timer >= JPM_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function JPM_Result.ShowNormalEffect()
    self.timer = 0;    
    self.currentRunGold = 0;
    JPMEntry.SetSelfGold(JPMEntry.myGold);
    JPMEntry.WinGoldText.text=JPMEntry.ShowText(JPMEntry.ResultData.WinScore)
    JPMEntry.WinGold.gameObject:SetActive(true)
    self.winRate = math.ceil(JPMEntry.ResultData.WinScore / (JPM_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    self.showResultCallback = nil;
    self.showResultCallback = function()
        self.isShowNormal = false;
        self.timer = 0;
        JPMEntry.WinGold.gameObject:SetActive(false)
        JPMEntry.WinGoldText.text=JPMEntry.ShowText(0)
        self.CheckFree();
    end
    self.isShowNormal = true;
end
function JPM_Result.ShowNormal()
    if self.isShowNormal then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= JPMEntry.ResultData.WinScore then
            self.currentRunGold = JPMEntry.ResultData.WinScore;
        end
        JPMEntry.WinGoldText.text = JPMEntry.ShowText(self.currentRunGold);
        if self.timer >= JPM_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end