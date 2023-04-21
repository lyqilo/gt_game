WSZS_Result = {};

local self = WSZS_Result;

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

function WSZS_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = false;
    self.isPause = false;
end
function WSZS_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = true;
    WSZSEntry.myGold = TableUserInfo._7wGold;
    WSZSEntry.WinDesc.text = "Start to win rewards";
    if not WSZSEntry.isFreeGame then
        if WSZSEntry.ResultData.FreeCount > 0 then
            self.totalFreeGold = self.totalFreeGold + WSZSEntry.ResultData.WinScore;
            WSZSEntry.WinNum.text = WSZSEntry.ShowText(self.totalFreeGold);
        else
            WSZSEntry.WinNum.text = WSZSEntry.ShowText(WSZSEntry.ResultData.WinScore);
        end
    else
        self.totalFreeGold = self.totalFreeGold + WSZSEntry.ResultData.WinScore - WSZSEntry.ResultData.ShiGold;
        WSZSEntry.WinNum.text = WSZSEntry.ShowText(self.totalFreeGold);
    end
    --其他正常模式
    if WSZSEntry.ResultData.WinScore > 0 then
        WSZS_Line.Show();
        coroutine.start(function()
            coroutine.wait(0.3);
            local rate = WSZSEntry.ResultData.WinScore / (WSZSEntry.CurrentChip * WSZS_DataConfig.ALLLINECOUNT);
            if rate < 6 then
                --普通奖  不做显示
                WSZS_Result.ShowNormalEffect()
                --elseif rate >= 5 and rate < 10 then
                --    --bigwin
                --    self.ShowBigWinEffect();
                --elseif rate >= 10 and rate < 15 then
                --    --superwin
                --    self.ShowSuperWinffect()
            elseif rate >= 6 then
                --megewin
                self.ShowMegaWinEffect();
            end
        end);
    else
        Util.RunWinScore(0, 1, WSZS_DataConfig.autoNoRewardInterval, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            WSZSEntry.isRoll = false;
            self.CheckFree();
        end);
        WSZSEntry.SetSelfGold(WSZSEntry.myGold);
    end
end
function WSZS_Result.HideResult()
    for i = 1, WSZSEntry.resultEffect.childCount do
        WSZSEntry.resultEffect:GetChild(i - 1).gameObject:SetActive(false);
    end
    self.timer = 0;
    self.showCSJLCallback = nil;
    self.showResultCallback = nil;
end
function WSZS_Result.Update()
    if self.isPause then
        return ;
    end
end
function WSZS_Result.CheckFree()
    WSZSEntry.isRoll = false;
    if not WSZSEntry.isFreeGame then
        if WSZSEntry.ResultData.FreeCount == 1 then
            WSZS_Line.Close();
            self.ShowFreeEffect(false);
        else
            WSZSEntry.FreeRoll();
        end
    else
        WSZS_Line.CollectFreeMJ();
        WSZS_Line.FreeShowAll();
        WSZS_Free.Result();
    end
end
function WSZS_Result.ShowFreeEffect(isSceneData)
    --展示免费
    WSZSEntry.isFreeGame = true;
    self.timer = 0;
    --WSZS_Line.ShowFree();
    if not isSceneData then
        WSZSEntry.currentFreeCount = 0;
    end
    WSZSEntry.freeText.text = ShowRichText(WSZSEntry.currentFreeCount);
    WSZS_Audio.PlayBGM(WSZS_Audio.SoundList.BGMFree);
    WSZS_Audio.PlaySound(WSZS_Audio.SoundList.FreeWS);
    self.totalFreeGold = 0;
    WSZSEntry.normalBackground.transform:DOScale(Vector3.New(0.95, 0.95, 0.95), WSZS_DataConfig.freeLoadingShowTime):SetEase(DG.Tweening.Ease.Linear);
    WSZSEntry.chiplistBtn.gameObject:SetActive(false);
    WSZSEntry.openChipBtn.interactable = false;
    WSZSEntry.startBtn.interactable = false;
    WSZSEntry.MaxChipBtn.interactable = false;
    WSZSEntry.EnterFreeEffect.gameObject:SetActive(true);
    self.showResultCallback = function()
        self.timer = 0;
        WSZSEntry.FreeContent.gameObject:SetActive(true);
        WSZSEntry.AutoContent.gameObject:SetActive(false);
        WSZSEntry.startState.gameObject:SetActive(false);
        WSZSEntry.stopState.gameObject:SetActive(false);
        WSZS_Line.Close();
        WSZS_Free.Init(isSceneData);
        WSZSEntry.EnterFreeEffect.gameObject:SetActive(false);
    end
    Util.RunWinScore(0, 1, WSZS_DataConfig.freeLoadingShowTime, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        Util.RunWinScore(0, 1, 1, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end);
    end);
    log("开始免费")
end

function WSZS_Result.ShowFreeResultEffect(iswin)
    --展示免费结果
    self.timer = 0;
    self.currentRunGold = 0;
    WSZSEntry.isFreeGame = false;
    --TODO 判断输赢情况 显示不同音效不同
    WSZSEntry.FreeWinResultNum.text = "";
    WSZSEntry.FreeLoseResultNum.text = "";
    if iswin then
        WSZSEntry.FreeWinResultEffect.gameObject:SetActive(true);
        WSZSEntry.FreeLoseResultEffect.gameObject:SetActive(false);
        WSZS_Audio.PlaySound(WSZS_Audio.SoundList.FreeWin);
    else
        WSZSEntry.FreeWinResultEffect.gameObject:SetActive(false);
        WSZSEntry.FreeLoseResultEffect.gameObject:SetActive(true);
        WSZS_Audio.PlaySound(WSZS_Audio.SoundList.FreeLose);
    end
    for i = WSZSEntry.IconContainer.childCount, 1, -1 do
        destroy(WSZSEntry.IconContainer:GetChild(i - 1).gameObject);
    end
    for i = 1, WSZSEntry.ScoreContainer.childCount do
        WSZSEntry.ScoreContainer:GetChild(i - 1):GetComponent("TextMeshProUGUI").text = "";
        WSZSEntry.ScoreContainer:GetChild(i - 1).localPosition = Vector3.New(WSZS_DataConfig.IconPos[1], 55, 0);
    end
    WSZSEntry.normalBackground.transform:DOScale(Vector3.New(1, 1, 1), WSZS_DataConfig.freeLoadingShowTime):SetEase(DG.Tweening.Ease.Linear);
    self.showResultCallback = function()
        self.isShowTotalFree = false;
        WSZSEntry.FreeWinResultEffect.gameObject:SetActive(false);
        WSZSEntry.FreeLoseResultEffect.gameObject:SetActive(false);
        self.timer = 0;
        WSZS_Audio.PlayBGM();
        self.CheckFree();
    end
    Util.RunWinScore(0, self.totalFreeGold, WSZS_DataConfig.winFreeChangeRate, function(value)
        self.currentRunGold = math.ceil(value);
        if iswin then
            WSZSEntry.FreeWinResultNum.text = WSZSEntry.ShowText(self.currentRunGold);
        else
            WSZSEntry.FreeLoseResultNum.text = WSZSEntry.ShowText(self.currentRunGold);
        end
    end):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        Util.RunWinScore(0, 1, 1, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end);
    end);
end

---------------------中奖---------------------
function WSZS_Result.ShowBigWinEffect()
    --BigWin奖动画
    WSZS_Audio.PlaySound(WSZS_Audio.SoundList.MiddleWin, WSZS_DataConfig.winGoldBigChangeRate);
    WSZSEntry.bigWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    WSZSEntry.bigWinNum.text = WSZSEntry.ShowText(self.currentRunGold);
    WSZSEntry.bigWinNum.gameObject:SetActive(true);
    WSZSEntry.bigWinProgress.fillAmount = 0;
    WSZSEntry.bigWinImg:SetActive(true);
    WSZSEntry.superWinImg:SetActive(false);
    WSZSEntry.megaWinImg:SetActive(false);
    WSZSEntry.SetSelfGold(WSZSEntry.myGold);
    self.showResultCallback = function()
        WSZSEntry.bigWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowBigWin = false;
        WSZS_Result.CheckFree();
    end
    Util.RunWinScore(0, 1, WSZS_DataConfig.winGoldBigChangeRate - 1, function(value)
        WSZSEntry.bigWinProgress.fillAmount = value;
        if WSZSEntry.bigWinProgress.fillAmount >= 1 then
            WSZSEntry.bigWinProgress.fillAmount = 1;
        end
    end):SetEase(DG.Tweening.Ease.Linear);
    Util.RunWinScore(0, WSZSEntry.ResultData.WinScore, WSZS_DataConfig.winGoldBigChangeRate - 1, function(value)
        self.currentRunGold = math.ceil(value);
        WSZSEntry.bigWinNum.text = WSZSEntry.ShowText(self.currentRunGold);
    end):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        WSZSEntry.CollectGoldEffect.gameObject:SetActive(true);
        WSZSEntry.selfGold.transform.parent:DOShakePosition(1.5, Vector3.New(10, 5, 0)):SetEase(DG.Tweening.Ease.Linear);
        Util.RunWinScore(0, 1, 1, nil):OnComplete(function()
            WSZSEntry.CollectGoldEffect.gameObject:SetActive(false);
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end):SetEase(DG.Tweening.Ease.Linear);
    end);
end
function WSZS_Result.ShowSuperWinffect()
    --Super奖动画
    WSZS_Audio.PlaySoundAtTime(WSZS_Audio.SoundList.BigWin, 4.5);
    WSZSEntry.bigWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    WSZSEntry.bigWinNum.text = WSZSEntry.ShowText(self.currentRunGold);
    WSZSEntry.bigWinNum.gameObject:SetActive(true);
    WSZSEntry.bigWinProgress.fillAmount = 0;
    WSZSEntry.bigWinImg:SetActive(true);
    WSZSEntry.superWinImg:SetActive(false);
    WSZSEntry.megaWinImg:SetActive(false);
    WSZSEntry.SetSelfGold(WSZSEntry.myGold);
    self.showResultCallback = function()
        WSZSEntry.bigWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowSuperWin = false;
        WSZS_Result.CheckFree();
    end
    Util.RunWinScore(0, 1, WSZS_DataConfig.winGoldBigChangeRate, function(value)
        WSZSEntry.bigWinProgress.fillAmount = value;
        if WSZSEntry.bigWinProgress.fillAmount >= 1 then
            WSZSEntry.bigWinProgress.fillAmount = 1;
        end
    end):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        WSZSEntry.bigWinImg:SetActive(false);
        WSZSEntry.superWinImg:SetActive(true);
        WSZSEntry.megaWinImg:SetActive(false);
        WSZSEntry.bigWinProgress.fillAmount = 0;
        Util.RunWinScore(0, 1, WSZS_DataConfig.winGoldBigChangeRate - 1, function(value)
            WSZSEntry.bigWinProgress.fillAmount = value;
            if WSZSEntry.bigWinProgress.fillAmount >= 1 then
                WSZSEntry.bigWinProgress.fillAmount = 1;
            end
        end):SetEase(DG.Tweening.Ease.Linear);
    end)
    Util.RunWinScore(0, WSZSEntry.ResultData.WinScore, WSZS_DataConfig.winGoldBigChangeRate * 2 - 1, function(value)
        self.currentRunGold = math.ceil(value);
        WSZSEntry.bigWinNum.text = WSZSEntry.ShowText(self.currentRunGold);
    end):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        WSZSEntry.CollectGoldEffect.gameObject:SetActive(true);
        WSZSEntry.selfGold.transform.parent:DOShakePosition(1.5, Vector3.New(10, 5, 0)):SetEase(DG.Tweening.Ease.Linear);
        Util.RunWinScore(0, 1, 1, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            WSZSEntry.CollectGoldEffect.gameObject:SetActive(false);
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end);
    end);
end
function WSZS_Result.ShowMegaWinEffect()
    --Mega奖动画
    WSZS_Audio.PlaySound(WSZS_Audio.SoundList.BigWin);
    WSZSEntry.bigWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    WSZSEntry.bigWinNum.text = WSZSEntry.ShowText(self.currentRunGold);
    WSZSEntry.bigWinNum.gameObject:SetActive(true);
    WSZSEntry.bigWinProgress.fillAmount = 0;
    WSZSEntry.bigWinImg:SetActive(true);
    WSZSEntry.superWinImg:SetActive(false);
    WSZSEntry.megaWinImg:SetActive(false);
    WSZSEntry.SetSelfGold(WSZSEntry.myGold);
    self.showResultCallback = function()
        WSZSEntry.bigWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowMageWin = false;
        WSZS_Result.CheckFree();
    end

    Util.RunWinScore(0, 1, WSZS_DataConfig.winGoldBigChangeRate, function(value)
        WSZSEntry.bigWinProgress.fillAmount = value;
        if WSZSEntry.bigWinProgress.fillAmount >= 1 then
            WSZSEntry.bigWinProgress.fillAmount = 1;
        end
    end):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        WSZSEntry.bigWinProgress.fillAmount = 0;
        WSZSEntry.bigWinImg:SetActive(false);
        WSZSEntry.superWinImg:SetActive(true);
        WSZSEntry.megaWinImg:SetActive(false);
        Util.RunWinScore(0, 1, WSZS_DataConfig.winGoldBigChangeRate, function(value)
            WSZSEntry.bigWinProgress.fillAmount = value;
            if WSZSEntry.bigWinProgress.fillAmount >= 1 then
                WSZSEntry.bigWinProgress.fillAmount = 1;
            end
        end):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            WSZSEntry.bigWinProgress.fillAmount = 0;
            WSZSEntry.bigWinImg:SetActive(false);
            WSZSEntry.superWinImg:SetActive(false);
            WSZSEntry.megaWinImg:SetActive(true);
            Util.RunWinScore(0, 1, WSZS_DataConfig.winGoldBigChangeRate, function(value)
                WSZSEntry.bigWinProgress.fillAmount = value;
                if WSZSEntry.bigWinProgress.fillAmount >= 1 then
                    WSZSEntry.bigWinProgress.fillAmount = 1;
                end
            end):SetEase(DG.Tweening.Ease.Linear);
        end)
    end)
    Util.RunWinScore(0, WSZSEntry.ResultData.WinScore, WSZS_DataConfig.winGoldBigChangeRate * 3, function(value)
        self.currentRunGold = math.ceil(value);
        WSZSEntry.bigWinNum.text = WSZSEntry.ShowText(self.currentRunGold);
    end):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        --WSZSEntry.CollectGoldEffect.gameObject:SetActive(true);
        WSZSEntry.selfGold.transform.parent:DOShakePosition(1.5, Vector3.New(10, 5, 0)):SetEase(DG.Tweening.Ease.Linear);
        Util.RunWinScore(0, 1, 1, nil):OnComplete(function()
            --WSZSEntry.CollectGoldEffect.gameObject:SetActive(false);
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end);
    end);
end
function WSZS_Result.ShowNormalGoldFly()
    WSZSEntry.NormalWinEffect.gameObject:SetActive(true);
    local pos = {};
    local goldCount = 6;
    coroutine.start(function()
        for i = 1, goldCount do
            self.CreateGoldFly(i);
            coroutine.wait(0.05);
        end
    end);
end
function WSZS_Result.CreateGoldFly(index)
    local orginPos = Vector3.New(-60, -120, 0);
    local endPos = Vector3.New(-245, -340, 0);
    local min = 0;
    local max = 120;
    local go = nil;
    if index > WSZSEntry.normalWinGoldContent.childCount then
        go = newObject(WSZSEntry.normalWinGoldContent:GetChild(0));
        go.transform:SetParent(WSZSEntry.normalWinGoldContent);
    else
        go = WSZSEntry.normalWinGoldContent:GetChild(index - 1).gameObject;
    end
    go.transform.localPosition = Vector3.New(0, 0, 0);
    go.transform.localScale = Vector3.New(1, 1, 1);
    go.transform:GetChild(0).localScale = Vector3.New(1, 1, 1);
    go.transform:GetChild(0):GetChild(0).localScale = Vector3.New(1, 1, 1);
    go.gameObject:SetActive(true);
    go.transform:DOLocalMove(Vector3.New(orginPos.x + Mathf.Random(min, max), orginPos.y, orginPos.z), 0.2):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        for i = 1, 4 do
            local pos = nil;
            if go.transform.localPosition.x >= 0 then
                pos = Vector3.New(go.transform.localPosition.x + Mathf.Random(5, 10), go.transform.localPosition.y, go.transform.localPosition.z);
            else
                pos = Vector3.New(go.transform.localPosition.x - Mathf.Random(5, 10), go.transform.localPosition.y, go.transform.localPosition.z);
            end
            Util.RunWinScore(0, 1, 0.1, nil):SetDelay(i * 0.1):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                go.transform:DOLocalMove(pos, 0.1):SetEase(DG.Tweening.Ease.Linear);
            end);
        end
        go.transform:GetChild(0):DOPunchPosition(Vector3.New(0, 20, 0), 0.2, 5):SetEase(DG.Tweening.Ease.Linear);
    end);
end

function WSZS_Result.HideNormalGoldFly()
    WSZSEntry.NormalWinEffect.gameObject:SetActive(false);
end
function WSZS_Result.ShowNormalEffect()
    self.timer = 0;
    WSZSEntry.SetSelfGold(WSZSEntry.myGold);
    self.ShowNormalGoldFly();
    self.currentRunGold = 0;
    WSZSEntry.normalWinNum.text = WSZSEntry.ShowText(self.currentRunGold);
    WSZSEntry.normalWinNum.gameObject:SetActive(true);
    WSZSEntry.SetSelfGold(WSZSEntry.myGold);
    self.showResultCallback = function()
        self.isShowNormal = false;
        self.HideNormalGoldFly();
        WSZSEntry.normalWinNum.text = WSZSEntry.ShowText(0);
        self.timer = 0;
        self.CheckFree();
    end
    Util.RunWinScore(0, WSZSEntry.ResultData.WinScore, WSZS_DataConfig.winGoldNormalChangeRate, function(value)
        self.currentRunGold = math.ceil(value);
        WSZSEntry.normalWinNum.text = WSZSEntry.ShowText(self.currentRunGold);
    end):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        local endPos = Vector3.New(-245, -340, 0);
        for i = 1, WSZSEntry.normalWinGoldContent.childCount do
            local go = WSZSEntry.normalWinGoldContent:GetChild(i - 1).gameObject
            Util.RunWinScore(0,1,0.1,nil):SetDelay(i*0.1):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                go.transform:GetChild(0):GetChild(0):DOScale(0.7, 0.3):SetEase(DG.Tweening.Ease.Linear);
                go.transform:DOLocalMove(endPos, 0.3):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                    WSZSEntry.CollectGoldEffect.gameObject:SetActive(true);
                    WSZS_Audio.PlaySound(WSZS_Audio.SoundList.NormalWin);
                    go.gameObject:SetActive(false);
                end);
            end);
        end
        WSZSEntry.selfGold.transform.parent:DOShakePosition(1.5, Vector3.New(10, 5, 0)):SetEase(DG.Tweening.Ease.Linear);
        Util.RunWinScore(0, 1, 1, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            WSZSEntry.CollectGoldEffect.gameObject:SetActive(false);
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end);
    end);
end