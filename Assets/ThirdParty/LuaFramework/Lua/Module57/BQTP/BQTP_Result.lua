BQTP_Result = {};

local self = BQTP_Result;

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



function BQTP_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.currentRunGold = 0;

end
function BQTP_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    BQTPEntry.myGold = TableUserInfo._7wGold;
    if BQTPEntry.ResultData.WinScore > 0 then
        BQTP_Line.Show();
        local rate = BQTPEntry.ResultData.WinScore / (BQTP_DataConfig.ALLLINECOUNT * BQTPEntry.CurrentChip);
        if rate < 8 then
            self.ShowNormalEffect();
        else
            --superwin
            self.ShowBigWinEffect();
        end
    else
        BQTPEntry.DelayCall(BQTP_DataConfig.autoNoRewardInterval, function()
            BQTPEntry.SetSelfGold(BQTPEntry.myGold);
            BQTPEntry.isReRoll = false;
            BQTPEntry.CheckState();
        end);
    end
end

---------------------中奖---------------------
function BQTP_Result.ShowBigWinEffect()
    --BigWin奖动画
    BQTPEntry.normalWin.gameObject:SetActive(false);
    BQTPEntry.bigWin.gameObject:SetActive(true);
    self.currentRunGold = 0;
    BQTP_Audio.PlaySound(BQTP_Audio.SoundList.BigWin);
    BQTP_Audio.PlaySound(BQTP_Audio.SoundList.NumberRunning);
    Util.RunWinScore(self.totalFreeGold, self.totalFreeGold + BQTPEntry.ResultData.WinScore, BQTP_DataConfig.winGoldChangeRate, function(v)
        self.currentRunGold = math.ceil(v);
        BQTPEntry.bigWinNum.text = BQTPEntry.ShowText(self.currentRunGold);
    end):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        self.totalFreeGold = self.totalFreeGold + BQTPEntry.ResultData.WinScore;
        BQTPEntry.normalWinNum.text = tostring(BQTPEntry.ResultData.WinScore);
        BQTPEntry.DelayCall(BQTP_DataConfig.autoNoRewardInterval * 2, function()
            BQTPEntry.SetSelfGold(BQTPEntry.myGold);
            if BQTPEntry.ReRollCount <= 0 then
                BQTPEntry.isReRoll = false;
                BQTPEntry.DelayCall(0.5, function()
                    BQTPEntry.CheckState();
                end);
            end
        end);
    end);
end
function BQTP_Result.ShowNormalEffect()
    BQTPEntry.normalWin.gameObject:SetActive(true);
    BQTPEntry.bigWin.gameObject:SetActive(false);
    self.currentRunGold = 0;
    BQTP_Audio.PlaySound(BQTP_Audio.SoundList.Normal_Win);
    BQTP_Audio.PlaySound(BQTP_Audio.SoundList.NumberRunning);
    Util.RunWinScore(self.totalFreeGold, self.totalFreeGold + BQTPEntry.ResultData.WinScore, BQTP_DataConfig.winGoldChangeRate, function(v)
        self.currentRunGold = math.ceil(v);
        BQTPEntry.normalWinNum.text = tostring(self.currentRunGold);
    end):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        self.totalFreeGold = self.totalFreeGold + BQTPEntry.ResultData.WinScore;
        BQTPEntry.bigWinNum.text = BQTPEntry.ShowText(BQTPEntry.ResultData.WinScore);
        BQTPEntry.DelayCall(BQTP_DataConfig.autoNoRewardInterval * 2, function()
            BQTPEntry.SetSelfGold(BQTPEntry.myGold);
            if BQTPEntry.ReRollCount <= 0 then
                BQTPEntry.isReRoll = false;
                BQTPEntry.DelayCall(0.5, function()
                    BQTPEntry.CheckState();
                end);
            end
        end);
    end);
end