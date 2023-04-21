FXGZ_Result = {};

local self = FXGZ_Result;

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
self.isWutiao = false;

function FXGZ_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = false;
    self.isPause = false;
end
function FXGZ_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = true;
    self.isWutiao = false;
    --FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.Award);
    for i = 1, #FXGZEntry.ResultData.LineTypeTable do
        if FXGZEntry.ResultData.LineTypeTable[i][5] ~= 0 then
            self.isWutiao = true;
        end
    end
    FXGZEntry.myGold = TableUserInfo._7wGold;
    if not FXGZEntry.isFreeGame then
        FXGZEntry.WinNum.text = ShortNumber(FXGZEntry.ResultData.WinScore);
    end
    --其他正常模式
    if FXGZEntry.isFreeGame then
        self.totalFreeGold = self.totalFreeGold + FXGZEntry.ResultData.WinScore;
        if not FXGZEntry.isReRollGame then
            FXGZEntry.baseChipNum.text = ShortNumber(FXGZEntry.ResultData.WinScore);
        end
        FXGZEntry.WinNum.text = ShortNumber(self.totalFreeGold);
    end
    if FXGZEntry.ResultData.WinScore > 0 then
        FXGZ_Line.Show();
        FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.AwardLine);
        FXGZEntry.resultEffect.gameObject:SetActive(true);
        local rate = FXGZEntry.ResultData.WinScore / (FXGZEntry.CurrentChip*FXGZ_DataConfig.ALLLINECOUNT);
        if rate < 6 then
            --普通奖  不做显示    
            self.ShowNormalEffect();
        elseif rate >= 6 and rate < 8 then
            --bigwin
            self.ShowMidWinEffect();
        elseif rate >= 8 then
            --superwin
            self.ShowBigWinffect();
        end
    else
        FXGZEntry.SetSelfGold(FXGZEntry.myGold);
        Util.RunWinScore(0, 1, FXGZ_DataConfig.autoNoRewardInterval, nil):OnComplete(function()
            self.CheckFree();
        end);
    end
end
function FXGZ_Result.HideResult()
    for i = 1, FXGZEntry.resultEffect.childCount do
        FXGZEntry.resultEffect:GetChild(i - 1).gameObject:SetActive(false);
    end
    FXGZEntry.resultEffect.gameObject:SetActive(false);
    for i = 1, FXGZEntry.CSGroup.childCount do
        if not FXGZEntry.isReRollGame then
            local wild = FXGZEntry.CSGroup:GetChild(i - 1):Find("Wild");
            if wild ~= nil then
                wild.gameObject:SetActive(false);
            end
        end
        local add = FXGZEntry.CSGroup:GetChild(i - 1):Find("Add");
        if add ~= nil then
            add.gameObject:SetActive(false);
        end
    end
    self.timer = 0;
    self.showCSJLCallback = nil;
    self.showResultCallback = nil;
end
function FXGZ_Result.CheckFree()
    FXGZEntry.isRoll = false;
    if self.isWutiao then
        self.isWutiao = false;
        self.ShowWTEffect();
        return ;
    end
    if not FXGZEntry.isFreeGame then
        if FXGZEntry.freeCount > 0 then
            if FXGZEntry.ResultData.FreeType == 0 then
                FXGZEntry.isReRollGame = true;
            else
                FXGZEntry.isReRollGame = false;
            end
            --FXGZ_Line.Close();
            if FXGZEntry.isReRollGame then
                self.ShowReRollEffect();
            else
                --进入免费
                self.ShowFreeEffect(false);
            end
        elseif FXGZEntry.ResultData.cbHitBouns > 0 then
            --FXGZ_Line.Close();
            --进入小游戏
            self.ShowEnterSmallGameEffect(false);
        else
            FXGZEntry.FreeRoll();
        end
    else
        if FXGZEntry.freeCount <= 0 then
            if FXGZEntry.isReRollGame then
                self.ShowReRollResultEffect();
            else
                self.ShowFreeResultEffect();
            end
        else
            if FXGZEntry.isReRollGame then
                FXGZEntry.FreeRoll();
            else
                self.ShowAddBeiTip();
            end
        end
    end
end
function FXGZ_Result.ShowReRollEffect()
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.TST);
    FXGZ_Audio.PlayBGM(FXGZ_Audio.SoundList.BGMReSpin);
    FXGZEntry.isFreeGame = true;
    self.timer = 0;
    self.totalFreeGold = 0;
    FXGZEntry.totalFreeCount = FXGZEntry.totalFreeCount + 1;
    FXGZEntry.MaxChipBtn.interactable = false;
    FXGZEntry.openChipBtn.interactable = false;
    FXGZEntry.resultEffect.gameObject:SetActive(true);
    FXGZEntry.EnterReRollEffect.gameObject:SetActive(true);
    FXGZEntry.FreeContent.gameObject:SetActive(false);
    FXGZEntry.stopState.gameObject:SetActive(false);
    FXGZEntry.startState.gameObject:SetActive(false);
    FXGZEntry.AutoContent.gameObject:SetActive(false);
    FXGZEntry.ReRollContent.gameObject:SetActive(true);
    FXGZEntry.ReRollNum.text = "";
    FXGZEntry.EnterReRollNum.text = tostring(FXGZEntry.freeCount);
    FXGZEntry.currentFreeCount = 0;
    Util.RunWinScore(0, 1, FXGZ_DataConfig.freeLoadingShowTime, nil):OnComplete(function()
        FXGZEntry.CSGroup.gameObject:SetActive(true);
        FXGZEntry.CSGroup:GetChild(0):Find("Wild").gameObject:SetActive(true);
        FXGZEntry.CSGroup:GetChild(4):Find("Wild").gameObject:SetActive(true);
        FXGZ_Line.Close();
        FXGZEntry.EnterReRollEffect.gameObject:SetActive(false);
        self.CheckFree();
    end);
    --self.isShowFree = true;
end
--展示免费进场
function FXGZ_Result.ShowFreeEffect(isSceneData)
    --展示免费
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.TST);
    FXGZ_Audio.PlayBGM(FXGZ_Audio.SoundList.BGMFree);
    FXGZEntry.isFreeGame = true;
    FXGZ_Result.totalFreeGold = 0
    self.timer = 0;
    FXGZEntry.totalFreeCount = FXGZEntry.totalFreeCount + 1;
    FXGZEntry.MaxChipBtn.interactable = false;
    FXGZEntry.openChipBtn.interactable = false;
    FXGZEntry.resultEffect.gameObject:SetActive(true);
    FXGZEntry.EnterFreeEffect.gameObject:SetActive(true);
    FXGZEntry.FreeContent.gameObject:SetActive(true);
    FXGZEntry.stopState.gameObject:SetActive(false);
    FXGZEntry.startState.gameObject:SetActive(false);
    FXGZEntry.AutoContent.gameObject:SetActive(false);
    FXGZEntry.ReRollContent.gameObject:SetActive(false);
    FXGZEntry.baseChipGroup.gameObject:SetActive(true);
    FXGZEntry.chipGroup.gameObject:SetActive(false);
    FXGZEntry.MaxChipBtn.gameObject:SetActive(false);
    FXGZEntry.EnterFreeNum.text = tostring(FXGZEntry.freeCount);
    FXGZEntry.freeText.text = "";
    FXGZEntry.baseChipNum.text = ShortNumber("0");
    FXGZEntry.addBei.gameObject:SetActive(true);
    if isSceneData then
        FXGZEntry.ResultData.m_nWinPeiLv = FXGZEntry.SceneData.cbCurMul;
    else
        if FXGZEntry.ResultData.m_nWinPeiLv <= 0 then
            FXGZEntry.ResultData.m_nWinPeiLv = 1;
        end
    end
    FXGZEntry.addBeiNum.text = tostring(FXGZEntry.ResultData.m_nWinPeiLv);
    FXGZEntry.currentFreeCount = 0;
    Util.RunWinScore(0, 1, FXGZ_DataConfig.freeLoadingShowTime, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        FXGZEntry.EnterFreeEffect.gameObject:SetActive(false);
        FXGZ_Line.Close();
        self.ShowAddBeiTip();
    end);
end
--展示增倍
function FXGZ_Result.ShowAddBeiTip()
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.FreeShowBei);
    FXGZEntry.addBeiTip.localPosition = Vector3.New(0, 0, 0);
    FXGZEntry.addBeiTip.localScale = Vector3.New(1, 1, 1);
    FXGZEntry.addBeiTipNum.text = tostring(FXGZEntry.ResultData.m_nWinPeiLv);
    FXGZEntry.resultEffect.gameObject:SetActive(true);
    FXGZEntry.addBeiTip.gameObject:SetActive(true);
    FXGZEntry.addBeiTip:Find("ZengBei_Tip_Bg"):GetComponent("RectTransform").sizeDelta = Vector2.New(170, 164);
    FXGZEntry.addBeiTip:Find("Content").gameObject:SetActive(false);
    FXGZEntry.addBeiTip.gameObject:SetActive(true);
    Util.RunWinScore(170, 304, 0.5, function(value)
        FXGZEntry.addBeiTip:Find("ZengBei_Tip_Bg"):GetComponent("RectTransform").sizeDelta = Vector2.New(value, 164);
    end):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        FXGZEntry.addBeiTip:Find("Content").gameObject:SetActive(true);
        FXGZEntry.addBeiTip:Find("Content/Num"):GetComponent("TextMeshProUGUI").text = tostring(FXGZEntry.ResultData.m_nWinPeiLv);
        Util.RunWinScore(0, 1, 1, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            FXGZEntry.addBeiTip:DOScale(Vector3.New(0.3, 0.3, 0.3), 0.3):SetEase(DG.Tweening.Ease.Linear);
            FXGZEntry.addBeiTip:DOLocalMove(Vector3.New(325, -320, 0), 0.3):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                FXGZEntry.addBeiNum.text = tostring(FXGZEntry.ResultData.m_nWinPeiLv);
                FXGZEntry.resultEffect.gameObject:SetActive(false);
                FXGZEntry.addBeiTip.gameObject:SetActive(false);
                FXGZEntry.FreeRoll();
            end);
        end);
    end);
end
function FXGZ_Result.ShowWTEffect()
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.TST);
    FXGZEntry.resultEffect.gameObject:SetActive(true);
    FXGZEntry.wtTip.gameObject:SetActive(true);
    Util.RunWinScore(0, 1, FXGZ_DataConfig.wutiaoTime, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        FXGZEntry.resultEffect.gameObject:SetActive(false);
        FXGZEntry.wtTip.gameObject:SetActive(false);
        self.CheckFree();
    end);
end
function FXGZ_Result.ShowEnterSmallGameEffect(isSceneData)
    --展示免费
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.TST);
    FXGZ_Audio.PlayBGM(FXGZ_Audio.SoundList.BGMBonus);
    FXGZEntry.isSmallGame = true;
    FXGZEntry.MaxChipBtn.interactable = false;
    FXGZEntry.openChipBtn.interactable = false;
    FXGZEntry.resultEffect.gameObject:SetActive(true);
    FXGZEntry.normalWinEffect.gameObject:SetActive(false);
    FXGZEntry.bigWinEffect.gameObject:SetActive(false);
    FXGZEntry.midWinEffect.gameObject:SetActive(false);
    FXGZEntry.EnterBonusEffect.gameObject:SetActive(true);
    FXGZEntry.FreeContent.gameObject:SetActive(false);
    FXGZEntry.AutoContent.gameObject:SetActive(false);
    FXGZEntry.ReRollContent.gameObject:SetActive(false);

    Util.RunWinScore(0, 1, FXGZ_DataConfig.smallGameLoadingShowTime, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        FXGZEntry.EnterBonusEffect.gameObject:SetActive(false);
        FXGZ_SmallGame.ShowSmallGame(isSceneData);
    end);
end
function FXGZ_Result.ShowFreeResultEffect()
    --展示免费结果
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.FreeEnd);
    FXGZEntry.isFreeGame = false;
    FXGZEntry.resultEffect.gameObject:SetActive(true);
    FXGZEntry.FreeResultEffect.gameObject:SetActive(true);
    FXGZEntry.FreeResultNum.gameObject:SetActive(true);
    FXGZEntry.FreeResultNum.text = ShortNumber(self.totalFreeGold);
    Util.RunWinScore(0, 1, FXGZ_DataConfig.showFreeResultTime, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        FXGZEntry.FreeResultEffect.gameObject:SetActive(false);
        FXGZEntry.resultEffect.gameObject:SetActive(false);
        FXGZEntry.MaxChipBtn.gameObject:SetActive(true);
        FXGZEntry.totalFreeCount = 0;
        FXGZ_Audio.PlayBGM(FXGZ_Audio.SoundList.BGM);
        self.CheckFree();
    end);
end

function FXGZ_Result.ShowReRollResultEffect()
    --展示免费结果
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.TST);
    FXGZEntry.isFreeGame = false;
    FXGZEntry.isReRollGame = false;
    FXGZEntry.resultEffect.gameObject:SetActive(true);
    FXGZEntry.ReRollResultEffect.gameObject:SetActive(true);
    FXGZEntry.ReRollResultNum.gameObject:SetActive(true);
    FXGZEntry.ReRollResultNum.text = ShortNumber(self.totalFreeGold);
    Util.RunWinScore(0, 1, FXGZ_DataConfig.showFreeResultTime, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        FXGZEntry.ReRollResultEffect.gameObject:SetActive(false);
        FXGZEntry.resultEffect.gameObject:SetActive(false);
        FXGZEntry.totalFreeCount = 0;
        FXGZ_Audio.PlayBGM(FXGZ_Audio.SoundList.BGM);
        self.CheckFree();
    end);
end

function FXGZ_Result.ShowWinMosaicResultEffect()
    --展示获得彩金结果
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.TST);
    FXGZEntry.resultEffect.gameObject:SetActive(true);
    FXGZEntry.MosaicResultEffect.gameObject:SetActive(true);
    FXGZEntry.MosaicResultNum.gameObject:SetActive(true);
    FXGZEntry.MosaicResultNum.text = ShortNumber(self.totalFreeGold);
    Util.RunWinScore(0, 1, FXGZ_DataConfig.showFreeResultTime, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        FXGZEntry.MosaicResultEffect.gameObject:SetActive(false);
        FXGZEntry.resultEffect.gameObject:SetActive(false);
        self.CheckFree();
    end);
end
---------------------中奖---------------------
function FXGZ_Result.ShowMidWinEffect()
    --BigWin奖动画
    FXGZEntry.midWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    FXGZEntry.midWinNum.text = FXGZEntry.ShowText(self.currentRunGold);
    FXGZEntry.midWinNum.gameObject:SetActive(true);
    for i = 1, FXGZEntry.midWinTitle.childCount do
        FXGZEntry.midWinTitle:GetChild(i - 1).gameObject:SetActive(false);
    end
    local index = 0;
    local skipBtn = FXGZEntry.midWinEffect:Find("SkipBtn"):GetComponent("Button");
    FXGZEntry.midWinProgress.fillAmount = 0;
    FXGZEntry.midWinTitle:GetChild(index).gameObject:SetActive(true);
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BigJB);
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BigWin1);
    self.midwinTweener = Util.RunWinScore(0, FXGZEntry.ResultData.WinScore, 6, function(value)
        self.currentRunGold = Mathf.Ceil(value);
        local remain = (self.currentRunGold - index * (FXGZEntry.ResultData.WinScore / 3)) / (FXGZEntry.ResultData.WinScore / 3);
        FXGZEntry.midWinProgress.fillAmount = remain;
        if remain >= 1 then
            if index < 2 then
                FXGZEntry.midWinTitle:GetChild(index).gameObject:SetActive(false);
                index = index + 1;
                FXGZEntry.midWinTitle:GetChild(index).gameObject:SetActive(true);
                FXGZEntry.midWinProgress.fillAmount = 0;
            end
        end
        FXGZEntry.midWinNum.text = FXGZEntry.ShowText(self.currentRunGold);
    end);
    self.midwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.Coin);
        FXGZEntry.SetSelfGold(FXGZEntry.myGold);
        self.midwinTweener = Util.RunWinScore(0, 1, 1, nil);
        self.midwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            FXGZEntry.midWinEffect.gameObject:SetActive(false);
            self.CheckFree();
        end);
    end);
    skipBtn.onClick:RemoveAllListeners();
    skipBtn.interactable = true;
    skipBtn.onClick:AddListener(function()
        FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
        FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.Coin);
        FXGZ_Audio.ClearAuido(FXGZ_Audio.SoundList.BigWin1);
        FXGZ_Audio.ClearAuido(FXGZ_Audio.SoundList.BigJB);
        FXGZEntry.SetSelfGold(FXGZEntry.myGold);
        skipBtn.interactable = false;
        if self.midwinTweener ~= nil then
            self.midwinTweener:Kill();
        end
        index =  FXGZEntry.midWinTitle.childCount;
        for i = 1, FXGZEntry.midWinTitle.childCount do
            FXGZEntry.midWinTitle:GetChild(i - 1).gameObject:SetActive(false);
        end
        FXGZEntry.midWinTitle:GetChild(index-1).gameObject:SetActive(true);
        FXGZEntry.midWinProgress.fillAmount = 1;
        FXGZEntry.midWinNum.text = FXGZEntry.ShowText(FXGZEntry.ResultData.WinScore);
        Util.RunWinScore(0, 1, 0.5, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            FXGZEntry.midWinEffect.gameObject:SetActive(false);
            self.CheckFree();
        end);
    end);
end
function FXGZ_Result.ShowBigWinffect()
    --Super奖动画
    FXGZEntry.bigWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    FXGZEntry.bigWinNum.text = FXGZEntry.ShowText(self.currentRunGold);
    FXGZEntry.bigWinNum.gameObject:SetActive(true);
    for i = 1, FXGZEntry.bigWinTitle.childCount do
        FXGZEntry.bigWinTitle:GetChild(i - 1).gameObject:SetActive(false);
    end
    local index = 0;
    local skipBtn = FXGZEntry.bigWinEffect:Find("SkipBtn"):GetComponent("Button");
    FXGZEntry.bigWinProgress.fillAmount = 0;
    FXGZEntry.bigWinTitle:GetChild(index).gameObject:SetActive(true);
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BigJB);
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BigWin2);
    self.bigwinTweener = Util.RunWinScore(0, FXGZEntry.ResultData.WinScore, 14, function(value)
        self.currentRunGold = Mathf.Ceil(value);
        local remain = (self.currentRunGold - index * (FXGZEntry.ResultData.WinScore / 8)) / (FXGZEntry.ResultData.WinScore / 8);
        FXGZEntry.bigWinProgress.fillAmount = remain;
        if remain >= 1 then
            if index < 7 then
                FXGZEntry.bigWinTitle:GetChild(index).gameObject:SetActive(false);
                index = index + 1;
                FXGZEntry.bigWinTitle:GetChild(index).gameObject:SetActive(true);
                FXGZEntry.bigWinProgress.fillAmount = 0;
            end
        end
        FXGZEntry.bigWinNum.text = FXGZEntry.ShowText(self.currentRunGold);
    end);
    self.bigwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.Coin);
        FXGZEntry.SetSelfGold(FXGZEntry.myGold);
        self.bigwinTweener = Util.RunWinScore(0, 1, 1, nil);
        self.bigwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            FXGZEntry.bigWinEffect.gameObject:SetActive(false);
            self.CheckFree();
        end);
    end);
    skipBtn.onClick:RemoveAllListeners();
    skipBtn.interactable = true;
    skipBtn.onClick:AddListener(function()
        FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
        FXGZ_Audio.ClearAuido(FXGZ_Audio.SoundList.BigJB);
        FXGZ_Audio.ClearAuido(FXGZ_Audio.SoundList.BigWin2);
        FXGZEntry.SetSelfGold(FXGZEntry.myGold);
        skipBtn.interactable = false;
        if self.bigwinTweener ~= nil then
            self.bigwinTweener:Kill();
        end
        index = FXGZEntry.bigWinTitle.childCount;
        for i = 1, FXGZEntry.bigWinTitle.childCount do
            FXGZEntry.bigWinTitle:GetChild(i - 1).gameObject:SetActive(false);
        end
        FXGZEntry.bigWinTitle:GetChild(index-1).gameObject:SetActive(true);
        FXGZEntry.bigWinProgress.fillAmount = 1;
        FXGZEntry.bigWinNum.text = FXGZEntry.ShowText(FXGZEntry.ResultData.WinScore);
        Util.RunWinScore(0, 1, 0.5, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            FXGZEntry.bigWinEffect.gameObject:SetActive(false);
            self.CheckFree();
        end);
    end);
end
function FXGZ_Result.ShowNormalEffect()
    self.timer = 0;
    self.currentRunGold = 0;
    FXGZEntry.normalWinEffect.gameObject:SetActive(true);
    FXGZEntry.normalWinNum.text = FXGZEntry.ShowText(self.currentRunGold);
    FXGZEntry.normalWinNum.gameObject:SetActive(true);
    FXGZEntry.SetSelfGold(FXGZEntry.myGold);
    local skipBtn = FXGZEntry.normalWinEffect:Find("SkipBtn"):GetComponent("Button");
    local goldGroup = FXGZEntry.normalWinEffect:Find("Gold");
    FXGZEntry.goldEffect.gameObject:SetActive(false);
    local tweenlist = {};
    local timer = 0;
    for i = 1, 5 do
        local child = nil;
        if i > goldGroup.childCount then
            child = newObject(goldGroup:GetChild(0).gameObject);
            child.transform.localScale = Vector3.New(1, 1, 1);
            child.transform:SetParent(goldGroup);
        else
            child = goldGroup:GetChild(i - 1).gameObject;
        end
        child.transform.localPosition = Vector3.New(0, -180, 0);
        child.transform:GetChild(0).localScale = Vector3.New(1, 1, 1);
        child.gameObject:SetActive(true);
        local xpos = Mathf.Random(0, 20);
        local ran = Mathf.Random(1, 10);
        if ran < 5 then
            xpos = xpos * -1;
        end
        local tweener = child.transform:DOLocalMove(Vector3.New(xpos, 65, 0), 0.3):SetDelay(i * 0.15):SetEase(DG.Tweening.Ease.Linear);
        table.insert(tweenlist, tweener);
    end
    timer = 0.3 + 5 * 0.15;
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.JB);
    self.normalTweener = Util.RunWinScore(0, FXGZEntry.ResultData.WinScore, timer, function(value)
        self.currentRunGold = Mathf.Ceil(value);
        FXGZEntry.normalWinNum.text = FXGZEntry.ShowText(self.currentRunGold);
    end);
    self.normalTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        for i = 1, 5 do
            child = goldGroup:GetChild(i - 1).gameObject;
            local tweener1 = child.transform:DOLocalMove(Vector3.New(-400, -127, 0), 0.3):SetEase(DG.Tweening.Ease.Linear);
            local tweener2 = child.transform:GetChild(0):DOScale(Vector3.New(0.5, 0.5, 0.5), 0.3):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.Coin);
                child.gameObject:SetActive(false);
                child.transform.localPosition = Vector3.New(0, -180, 0);
                child.transform:GetChild(0).localScale = Vector3.New(1, 1, 1);
                FXGZEntry.goldEffect.gameObject:SetActive(true);
            end);
            table.insert(tweenlist, tweener1);
            table.insert(tweenlist, tweener2);
        end
        Util.RunWinScore(0, 1, 1, nil):OnComplete(function()
            FXGZEntry.normalWinEffect.gameObject:SetActive(false);
            self.CheckFree();
        end);
    end);
    skipBtn.onClick:RemoveAllListeners();
    skipBtn.interactable = false;
    skipBtn.onClick:AddListener(function()
        FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
        FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.Coin);
        FXGZ_Audio.ClearAuido(FXGZ_Audio.SoundList.JB);
        FXGZEntry.SetSelfGold(FXGZEntry.myGold);
        if self.normalTweener ~= nil then
            self.normalTweener:Kill();
        end
        for i = 1, #tweenlist do
            if tweenlist[i] ~= nil then
                tweenlist[i]:Kill();
            end
        end
        for i = 1, goldGroup.childCount do
            goldGroup:GetChild(i - 1).gameObject:SetActive(false);
        end
        skipBtn.interactable = false;
        FXGZEntry.normalWinNum.text = FXGZEntry.ShowText(FXGZEntry.ResultData.WinScore);
        Util.RunWinScore(0, 1, 1, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            FXGZEntry.normalWinEffect.gameObject:SetActive(false);
            self.CheckFree();
        end);
    end);
end