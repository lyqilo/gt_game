XYSGJ_Result = {};

local self = XYSGJ_Result;

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

self.WinningLineNum = 0

function XYSGJ_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = false;
    self.isPause = false;
end
function XYSGJ_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    log("ShowResult===="..XYSGJEntry.ResultData.WinScore)
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = true;
    XYSGJEntry.myGold = TableUserInfo._7wGold;
    if self.WinningLineNum > 0 then
        XYSGJEntry.TipText.text = "恭喜您！中" .. self.WinningLineNum .. "线"
    else
        XYSGJEntry.TipText.text = ""
    end
    if XYSGJEntry.isFreeGame then
        self.totalFreeGold = self.totalFreeGold + XYSGJEntry.ResultData.WinScore;
        log("免费累计获得：" .. self.totalFreeGold);
        XYSGJEntry.WinNum.text = XYSGJEntry.ShowText(self.totalFreeGold);

    else
        XYSGJEntry.WinNum.text = XYSGJEntry.ShowText(XYSGJEntry.ResultData.WinScore);
    end
    --其他正常模式
    if XYSGJEntry.ResultData.WinScore > 0 then
        XYSGJ_Line.Show();
        local rate = XYSGJEntry.ResultData.WinScore / (XYSGJEntry.CurrentChip);
        if rate < 25 then
            --普通奖  不做显示
            XYSGJ_Result.ShowNormalEffect()
        elseif rate >= 25 and rate < 50 then
            self.ShowBigWinEffect();
        elseif rate >= 50 then
            self.ShowUltraWinEffect();
        end
    else
        if not XYSGJEntry.isSmallGame then
            XYSGJEntry.SetSelfGold(XYSGJEntry.myGold);
        end
        Util.RunWinScore(0, 1, 0.3, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            XYSGJEntry.isRoll = false;
            self.CheckFree();
        end);
        --coroutine.start(self.ShowCSGroup)
    end
end

function XYSGJ_Result.ShowCSGroup()
    coroutine.wait(0.3)
    self.timer = 0
    self.nowin = true;
    ---XYSGJEntry.CSGroup.gameObject:SetActive(true);
end

function XYSGJ_Result.HideResult()
    for i = 1, XYSGJEntry.resultEffect.childCount do
        XYSGJEntry.resultEffect:GetChild(i - 1).gameObject:SetActive(false);
    end
    XYSGJEntry.CSGroup.gameObject:SetActive(false);
    self.timer = 0;
    self.showCSJLCallback = nil;
    self.showResultCallback = nil;
end
function XYSGJ_Result.Update()
    if self.isPause then
        return ;
    end
    self.ShowUltraWin();
    self.ShowSuperWin();
    self.ShowMegaWin();
    self.ShowWin()
    self.ShowBigWin();
    self.ShowFree();
    self.HideFree();
    self.ShowNormal();
    self.NoWinWait();
    self.ShowFreeResult();
end

function XYSGJ_Result.NoWinWait()
    if self.nowin then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= XYSGJ_DataConfig.autoNoRewardInterval then
            self.nowin = false;
            XYSGJEntry.isRoll = false;
            self.CheckFree();
        end
    end
end
function XYSGJ_Result.CheckFree()
    XYSGJEntry.isRoll = false;
    if XYSGJEntry.ResultData.isSmallGame > 0 then
        XYSGJ_SmallGame.Run()
        return
    end
    if not XYSGJEntry.isFreeGame then
        if XYSGJEntry.ResultData.FreeCount > 0 then
            self.totalFreeGold = self.totalFreeGold + XYSGJEntry.ResultData.WinScore;
            XYSGJ_Line.Close();
            self.ShowFreeEffect(false);
        else
            XYSGJEntry.FreeRoll();
        end
    else
        if XYSGJEntry.ResultData.FreeCount <= 0 then
            self.ShowFreeResultEffect();
        else
            XYSGJEntry.FreeRoll();
        end
    end
end
function XYSGJ_Result.ShowFreeEffect(isSceneData)
    --展示免费
    XYSGJEntry.isFreeGame = true;
    self.timer = 0;
    --XYSGJ_Line.ShowFree();
    XYSGJEntry.currentFreeCount = 0;
    --self.showResultCallback = function()
    --    self.timer = 0;
    --    self.isHideFree = true;
    --    XYSGJEntry.EnterFreeEffect.gameObject:SetActive(true);
    --    XYSGJEntry.EnterFreeCount.text = XYSGJEntry.ShowText(XYSGJEntry.freeCount);--"恭喜获得免费"..XYSGJEntry.freeCount.."次" --
    --    XYSGJEntry.SetState(2);
    --    XYSGJ_Line.Close();
    --end
    Util.RunWinScore(0,1,XYSGJ_DataConfig.winGoldChangeRate,nil):OnComplete(function()
        XYSGJEntry.EnterFreeEffect.gameObject:SetActive(true);
        XYSGJEntry.EnterFreeCount.text = ShowRichText(XYSGJEntry.freeCount);--"恭喜获得免费"..XYSGJEntry.freeCount.."次" --
        XYSGJEntry.SetState(2);
        XYSGJ_Line.Close();
        Util.RunWinScore(0,1,XYSGJ_DataConfig.smallGameLoadingShowTime,nil):OnComplete(function()
            XYSGJ_Audio.PlayBGM(XYSGJ_Audio.SoundList.BGM_Free);
            XYSGJEntry.EnterFreeEffect.gameObject:SetActive(false);
            XYSGJEntry.FreeRoll();
        end):SetEase(DG.Tweening.Ease.Linear);
    end):SetEase(DG.Tweening.Ease.Linear);
    --self.isShowFree = true;
end
function XYSGJ_Result.ShowFree()
    if self.isShowFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= XYSGJ_DataConfig.winGoldChangeRate then
            self.isShowFree = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function XYSGJ_Result.HideFree()
    --隐藏中奖
    if self.isHideFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= XYSGJ_DataConfig.smallGameLoadingShowTime then
            --等待退出动画时长
            self.isHideFree = false;
            XYSGJ_Audio.PlayBGM(XYSGJ_Audio.SoundList.BGM_Free);
            XYSGJEntry.EnterFreeEffect.gameObject:SetActive(false);
            XYSGJEntry.FreeRoll();
        end

    end
end
function XYSGJ_Result.ShowFreeResultEffect()
    --展示免费结果

    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_big_win);
    self.timer = 0;
    self.currentRunGold = 0;
    --self.showResultCallback = function()
    --    self.isShowTotalFree = false;
    --    XYSGJEntry.FreeResultEffect.gameObject:SetActive(false);
    --    self.timer = 0;
    --    XYSGJEntry.FreeRoll();
    --    self.totalFreeGold = 0
    --end
    XYSGJEntry.FreeResult_gxhd.gameObject:SetActive(true);
    XYSGJEntry.FreeResult_mfhd.gameObject:SetActive(true);
    XYSGJEntry.FreeResultEffect.gameObject:SetActive(true);
    XYSGJEntry.FreeResultNum.gameObject:SetActive(true);

    Util.RunWinScore(0,self.totalFreeGold,XYSGJ_DataConfig.winGoldChangeRate,function(value)
        self.currentRunGold = math.ceil(value);
        if self.currentRunGold >= self.totalFreeGold then
            self.currentRunGold = self.totalFreeGold;
        end
        XYSGJEntry.FreeResultNum.text = XYSGJEntry.ShowText(self.currentRunGold);
    end):OnComplete(function()
        Util.RunWinScore(0,1,1,nil):OnComplete(function()
            XYSGJEntry.FreeResultEffect.gameObject:SetActive(false);
            self.timer = 0;
            XYSGJEntry.FreeRoll();
            self.totalFreeGold = 0;
        end);
    end);
    self.winRate = math.ceil(self.totalFreeGold / (XYSGJ_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    --self.isShowTotalFree = true;
end
function XYSGJ_Result.ShowFreeResult()
    if self.isShowTotalFree then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= self.totalFreeGold then
            self.currentRunGold = self.totalFreeGold;
        end
        XYSGJEntry.FreeResultNum.text = XYSGJEntry.ShowText(self.currentRunGold);
        if self.timer >= XYSGJ_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function XYSGJ_Result.ShowSmallResult(gold)
    log("小游戏分数:" .. gold);
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_big_win);

    XYSGJEntry.SetSelfGold(XYSGJEntry.myGold);
    XYSGJEntry.SmallResultEffect.gameObject:SetActive(true);
    Util.RunWinScore(0, gold, 3, function(value)
        self.currentRunGold = math.ceil(value);
        XYSGJEntry.SmallResultNum.text = XYSGJEntry.ShowText(self.currentRunGold);
        XYSGJEntry.WinNum.text = XYSGJEntry.ShowText(self.currentRunGold)
    end):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        Util.RunWinScore(0, 1, 2, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            XYSGJEntry.SmallResultEffect:DOScale(Vector3.New(1, 1, 1), 0.3):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                XYSGJEntry.SmallResultEffect.gameObject:SetActive(false);
                log("小游戏结束:" .. XYSGJEntry.myGold);
                XYSGJ_Result.CheckFree();
            end);
        end);
    end);
end

---------------------中奖---------------------
function XYSGJ_Result.ShowWinEffect()
    --BigWin奖动画
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_bigwin, XYSGJ_DataConfig.winGoldChangeRate);
    XYSGJEntry.winEffect.gameObject:SetActive(true);
    XYSGJEntry.winEffect.transform.localScale = Vector3.New(0, 0, 0);
    XYSGJEntry.winEffectNum.text = XYSGJEntry.ShowText("0");

    local showeffect = function()
        self.timer = 0;
        self.currentRunGold = 0;

        XYSGJEntry.winEffectNum.text = XYSGJEntry.ShowText(self.currentRunGold);
        XYSGJEntry.winEffectNum.gameObject:SetActive(true);
        self.winRate = math.ceil(XYSGJEntry.ResultData.WinScore / (XYSGJ_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        XYSGJEntry.SetSelfGold(XYSGJEntry.myGold);
        self.showResultCallback = function()
            XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_bigwin_end, XYSGJ_DataConfig.winGoldChangeRate);
            XYSGJEntry.winEffect.gameObject:SetActive(false);
            self.timer = 0;
            self.isShowBigWin = false;
            self.showResultCallback=nil;
            XYSGJ_Result.CheckFree();
        end
        --self.isShowBigWin = true;
    end

    XYSGJEntry.winEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);
end
function XYSGJ_Result.ShowWin()
    --BigWin奖
    if self.isShowBigWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= XYSGJEntry.ResultData.WinScore then
            self.currentRunGold = XYSGJEntry.ResultData.WinScore;
        end
        XYSGJEntry.winEffectNum.text = XYSGJEntry.ShowText(self.currentRunGold);
        if self.timer >= XYSGJ_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function XYSGJ_Result.ShowBigWinEffect()
    --BigWin奖动画
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_big_win);
    XYSGJEntry.bigWinEffect.gameObject:SetActive(true);
    XYSGJEntry.bigWinNum.text = XYSGJEntry.ShowText("0");

    self.timer = 0;
    self.currentRunGold = 0;
    local skipBtn = XYSGJEntry.bigWinClose;

    XYSGJEntry.bigWinNum.text = XYSGJEntry.ShowText(self.currentRunGold);
    XYSGJEntry.bigWinNum.gameObject:SetActive(true);
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_jinbi);
    XYSGJEntry.SetSelfGold(XYSGJEntry.myGold);
    self.showResultCallback = function()
        XYSGJEntry.bigWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowBigWin = false;
        XYSGJ_Audio.ClearAuido(XYSGJ_Audio.SoundList.yx_big_win);
        XYSGJ_Result.CheckFree();
    end
    local bigWinRun = Util.RunWinScore(0, XYSGJEntry.ResultData.WinScore, 3.5, function(value)
        self.currentRunGold = math.ceil(value);
        XYSGJEntry.bigWinNum.text = XYSGJEntry.ShowText(self.currentRunGold);
    end)                  :SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        Util.RunWinScore(0, 1, 2, function()
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end);
    end);
    --self.isShowBigWin = true;
    skipBtn.onClick:RemoveAllListeners();
    skipBtn.interactable = true;
    skipBtn.onClick:AddListener(function()
        skipBtn.interactable = false;
        if bigWinRun ~= nil then
            bigWinRun:Kill();
        end
        if self.showResultCallback ~= nil then
            self.showResultCallback();
        end
    end);
end
function XYSGJ_Result.ShowBigWin()
    --BigWin奖
    if self.isShowBigWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= XYSGJEntry.ResultData.WinScore then
            self.currentRunGold = XYSGJEntry.ResultData.WinScore;
        end
        XYSGJEntry.bigWinNum.text = XYSGJEntry.ShowText(self.currentRunGold);
        if self.timer >= XYSGJ_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function XYSGJ_Result.ShowSuperWinffect()
    --Super奖动画
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_bigwin, XYSGJ_DataConfig.winGoldChangeRate);
    XYSGJEntry.superWinEffect.gameObject:SetActive(true);
    XYSGJEntry.superWinEffect.transform.localScale = Vector3.New(0, 0, 0);
    XYSGJEntry.superWinNum.text = XYSGJEntry.ShowText("0");

    local showeffect = function()
        self.timer = 0;
        self.currentRunGold = 0;
        XYSGJEntry.superWinNum.text = XYSGJEntry.ShowText(self.currentRunGold);
        XYSGJEntry.superWinNum.gameObject:SetActive(true);
        self.winRate = math.ceil(XYSGJEntry.ResultData.WinScore / (XYSGJ_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        XYSGJEntry.SetSelfGold(XYSGJEntry.myGold);
        self.showResultCallback = function()
            XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_bigwin_end, XYSGJ_DataConfig.winGoldChangeRate);
            XYSGJEntry.superWinEffect.gameObject:SetActive(false);
            self.timer = 0;
            self.isShowSuperWin = false;
            XYSGJ_Audio.ClearAuido(XYSGJ_Audio.SoundList.yx_bigwin);
            XYSGJ_Result.CheckFree();
        end
        --self.isShowSuperWin = true;
    end
    XYSGJEntry.superWinEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);

end
function XYSGJ_Result.ShowSuperWin()
    --Super奖
    if self.isShowSuperWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= XYSGJEntry.ResultData.WinScore then
            self.currentRunGold = XYSGJEntry.ResultData.WinScore;
        end
        XYSGJEntry.superWinNum.text = XYSGJEntry.ShowText(self.currentRunGold);
        if self.timer >= XYSGJ_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function XYSGJ_Result.ShowMegaWinEffect()
    --Mega奖动画
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_bigwin, XYSGJ_DataConfig.winGoldChangeRate);
    XYSGJEntry.megaWinEffect.gameObject:SetActive(true);
    XYSGJEntry.megaWinEffect.transform.localScale = Vector3.New(0, 0, 0);
    XYSGJEntry.megaWinNum.text = XYSGJEntry.ShowText("0");
    local showeffect = function()
        self.timer = 0;
        self.currentRunGold = 0;
        XYSGJEntry.megaWinNum.text = XYSGJEntry.ShowText(self.currentRunGold);
        XYSGJEntry.megaWinNum.gameObject:SetActive(true);
        self.winRate = math.ceil(XYSGJEntry.ResultData.WinScore / (XYSGJ_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        XYSGJEntry.SetSelfGold(XYSGJEntry.myGold);
        self.showResultCallback = function()
            XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_bigwin_end, XYSGJ_DataConfig.winGoldChangeRate);
            XYSGJEntry.megaWinEffect.gameObject:SetActive(false);
            self.timer = 0;
            self.isShowMageWin = false;
            XYSGJ_Audio.ClearAuido(XYSGJ_Audio.SoundList.yx_bigwin);
            XYSGJ_Result.CheckFree();
        end
        --self.isShowMageWin = true;
    end
    XYSGJEntry.megaWinEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);

end
function XYSGJ_Result.ShowMegaWin()
    --Mega奖
    if self.isShowMageWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= XYSGJEntry.ResultData.WinScore then
            self.currentRunGold = XYSGJEntry.ResultData.WinScore;
        end
        XYSGJEntry.megaWinNum.text = XYSGJEntry.ShowText(self.currentRunGold);
        if self.timer >= XYSGJ_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function XYSGJ_Result.ShowUltraWinEffect()
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_bigwin);
    XYSGJEntry.ultraWinEffect.gameObject:SetActive(true);
    XYSGJEntry.ultraWinNum.text = XYSGJEntry.ShowText("0");
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_jinbi);
    local index = 0;
    local skipBtn = XYSGJEntry.ultraWinClose;

    self.timer = 0;
    self.currentRunGold = 0;
    XYSGJEntry.ultraWinNum.text = XYSGJEntry.ShowText(self.currentRunGold);
    XYSGJEntry.ultraWinNum.gameObject:SetActive(true);
    XYSGJEntry.SetSelfGold(XYSGJEntry.myGold);
    self.showResultCallback = function()
        XYSGJEntry.ultraWinEffect.gameObject:SetActive(false);
        for i = 1, XYSGJEntry.ultraWintag.childCount do
            XYSGJEntry.ultraWintag:GetChild(i - 1).gameObject:SetActive(false);
        end
        self.timer = 0;
        self.isShowMageWin = false;
        XYSGJ_Audio.ClearAuido(XYSGJ_Audio.SoundList.yx_bigwin);
        XYSGJ_Result.CheckFree();
    end
    local ultraWinRun = Util.RunWinScore(0, XYSGJEntry.ResultData.WinScore, 12, function(value)
        self.currentRunGold = math.ceil(value);
        if self.currentRunGold >= XYSGJEntry.ResultData.WinScore then
            self.currentRunGold = XYSGJEntry.ResultData.WinScore;
        end
        XYSGJEntry.ultraWinNum.text = XYSGJEntry.ShowText(self.currentRunGold);
    end):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        XYSGJ_Audio.ClearAuido(XYSGJ_Audio.SoundList.yx_bigwin);
        XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_bigwin_end);
        Util.RunWinScore(0, 1, 1, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end);
    end);
    --self.isShowMageWin = true;
    skipBtn.onClick:RemoveAllListeners();
    skipBtn.interactable = true;
    skipBtn.onClick:AddListener(function()
        skipBtn.interactable = false;
        if ultraWinRun ~= nil then
            ultraWinRun:Kill();
        end
        if self.showResultCallback ~= nil then
            self.showResultCallback();
            self.showResultCallback = nil
        end
    end);
end
function XYSGJ_Result.ShowUltraWin()
    --Mega奖
    if self.isShowMageWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= XYSGJEntry.ResultData.WinScore then
            self.currentRunGold = XYSGJEntry.ResultData.WinScore;
        end
        XYSGJEntry.ultraWinNum.text = XYSGJEntry.ShowText(self.currentRunGold);
        if self.timer >= XYSGJ_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function XYSGJ_Result.ShowNormalEffect()
    self.timer = 0;
    self.currentRunGold = 0;
    XYSGJEntry.SetSelfGold(XYSGJEntry.myGold);
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.dididi);
    XYSGJEntry.winEffectNum.text = XYSGJEntry.ShowText(XYSGJEntry.ResultData.WinScore)
    XYSGJEntry.winEffect.gameObject:SetActive(true)
    self.winRate = math.ceil(XYSGJEntry.ResultData.WinScore / (XYSGJ_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    self.showResultCallback = nil;
    self.showResultCallback = function()
        self.isShowNormal = false;
        self.timer = 0;
        XYSGJEntry.winEffect.gameObject:SetActive(false)
        XYSGJEntry.winEffectNum.text = XYSGJEntry.ShowText(0)
        self.CheckFree();
    end
    Util.RunWinScore(0, XYSGJEntry.ResultData.WinScore, XYSGJ_DataConfig.winGoldChangeRate, function(value)
        self.currentRunGold = math.ceil(value);
        if self.currentRunGold >= XYSGJEntry.ResultData.WinScore then
            self.currentRunGold = XYSGJEntry.ResultData.WinScore;
        end
        XYSGJEntry.winEffectNum.text = XYSGJEntry.ShowText(self.currentRunGold);
    end):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_goldruku);
        Util.RunWinScore(0, 1, 1, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            if self.showResultCallback ~= nil then
                self.showResultCallback();
                self.showResultCallback=nil;
            end
        end);
    end);
    --self.isShowNormal = true;
end
function XYSGJ_Result.ShowNormal()
    if self.isShowNormal then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= XYSGJEntry.ResultData.WinScore then
            self.currentRunGold = XYSGJEntry.ResultData.WinScore;
        end
        XYSGJEntry.WinGoldText.text = XYSGJEntry.ShowText(self.currentRunGold);
        if self.timer >= XYSGJ_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end