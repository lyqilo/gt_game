AJDMX_Result = {};

local self = AJDMX_Result;

self.timer = 0;
self.isShow = false;

self.isPause = false;

self.isShowCSJL = false;--展示财神
self.waitNextCSJL = false;--等待下一次重转
self.showCSJLCallback = nil;--展示完回调

self.isShowCSJLResult = false;--展示财神奖励
self.winRate = 0;--赢的跑分比率
self.progressRate = 0;--赢的跑分比率
self.currentRunGold = 0;
self.currentRunProgress = 0;

self.freeGold = 0;--免费游戏总金额

self.isWinCSJL = false;--当前是否为财神降临

self.isShowBig = false;--展示高分
self.isShowBang=false
self.isShowPrefect = false;--展示接近完美
self.isShowJYMT = false;--展示非常棒
self.isShowCYGG = false;--展示很棒
self.isShowNormal = false;--展示中奖
self.isHideNormal = false;--隐藏中奖
self.showResultCallback = nil;
self.hideNormalTime = 0.15;--退出动画时长

self.nowin = false;--没有得分
self.isFreeGame = false;--是否为免费游戏
self.showFreeTweener = nil;--免费财神动画tween
self.isShowFree = false;--展示免费
self.isHideFree = false;--隐藏免费
self.hideFreeTime = 5;--免费动画退出时长
self.isClickShouFen = false;
self.spGameGold = 0;

function AJDMX_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = false;
    self.isPause = false;
    self.isFreeGame = false;
end
function AJDMX_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = true;
    AJDMXEntry.myGold = TableUserInfo._7wGold;
    --AJDMXEntry.WinNum.text = tostring(AJDMXEntry.ResultData.WinScore);
    self.isClickShouFen = false;

    --其他正常模式
    local showResultCall = function()
        --先做免费的操作

        if AJDMXEntry.isFreeGame then
            self.freeGold = self.freeGold + AJDMXEntry.ResultData.WinScore;
            log("免费累计获得：" .. self.freeGold);
        end
        if AJDMXEntry.ResultData.WinScore > 0 then
            AJDMX_Line.Show()
            if AJDMXEntry.ResultData.m_nWinPeiLv < 6  then
                --低奖
                self.ShowNormalEffect();
             elseif AJDMXEntry.ResultData.m_nWinPeiLv >= 6  and AJDMXEntry.ResultData.m_nWinPeiLv < 10  then
                self.ShowBangEffect()
            elseif AJDMXEntry.ResultData.m_nWinPeiLv >= 10  then
                --展示有翅膀的动画
                --self.ShowBigEffect();
                self.ShowBangEffect()
            end
        else
            self.nowin = true;
            local rd = math.random(2, #AJDMX_DataConfig.WinConfig);
            AJDMXEntry.WinDesc.text = AJDMX_DataConfig.WinConfig[rd];
            AJDMXEntry.ChangeGold(AJDMXEntry.myGold);
        end
    end
    coroutine.stop(showResultCall);
    coroutine.start(showResultCall);
end

function AJDMX_Result.CheckFree()
    logYellow("检查是否中免费")
    --检查是否中免费
    if AJDMXEntry.ResultData.cbHitBouns > 0 then
        AJDMX_SmallGame.Run()
        return
    end
    if not AJDMXEntry.isFreeGame then
        AJDMXEntry.isRoll = false;
        if AJDMXEntry.ResultData.FreeCount > 0 then
            --中免费了
            self.freeGold = 0;
            AJDMXEntry.isFreeGame = true;
            self.isFreeGame = true;
            AJDMXEntry.addChipBtn.interactable = false;
            AJDMXEntry.reduceChipBtn.interactable = false;
            AJDMXEntry.MaxChipBtn.interactable = false;
            self.ShowFreeEffect();
        else
            AJDMXEntry.FreeRoll();
        end
    else
        AJDMXEntry.isRoll = false;
        if self.isFreeGame and AJDMXEntry.ResultData.FreeCount <= 0 then
            self.isFreeGame = false;
            self.ShowCSJLResultEffect();--免费结束结算
        else
            AJDMXEntry.FreeRoll();
        end
    end
end
function AJDMX_Result.HideResult()
    for i = 1, AJDMXEntry.resultEffect.childCount do
        AJDMXEntry.resultEffect:GetChild(i - 1).gameObject:SetActive(false);
    end
    self.showCSJLCallback = nil;
    self.showResultCallback = nil;
    logYellow("HideResult")
end
function AJDMX_Result.QuickOver(type)
    
end
function AJDMX_Result.Update()
    if self.isPause then
        return ;
    end
    self.ShowCSJL();
    self.WaitRollAgainCSJL();
    self.ShowCSJLResult();
    self.ShowCYGG();
    self.ShowJYMT();
    self.ShowPrefect();
    --self.ShowBang()
    --self.ShowBig();
    self.ShowNormal();
    self.HideNormal();
    self.ShowFree();
    self.HideFree();
    self.NoWinWait();
end

function AJDMX_Result.NoWinWait()
    if self.nowin then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= AJDMX_DataConfig.autoNoRewardInterval then
            self.nowin = false;
            self.CheckFree();
        end
    end
end
----------------------财神--------------------------------
function AJDMX_Result.WaitRollAgainCSJL()
    --财神重转
    if self.waitNextCSJL then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= AJDMX_DataConfig.autoNoRewardInterval then
            self.waitNextCSJL = false;
            if self.showCSJLCallback ~= nil then
                self.showCSJLCallback();
            end
        end
    end
end
function AJDMX_Result.ShowCSJLEffect()
    --财神展示动画
    AJDMX_Audio.PlayBGM(AJDMX_Audio.SoundList.CSJLBGM);
    AJDMXEntry.CSJLEffect.gameObject:SetActive(true);
    AJDMXEntry.CSJLEffect.AnimationState:SetAnimation(0, "animation", true);
    AJDMXEntry.CSGroup.gameObject:SetActive(true);
    for i = 1, #AJDMXEntry.ResultData.ImgTable do
        if AJDMXEntry.ResultData.ImgTable[i] == 0 then
            local column = math.floor(i / 5);--排
            local raw = i % 5;--列
            if raw == 0 then
                raw = 5;
                column = column - 1;
            end
            AJDMXEntry.CSGroup:GetChild(raw - 1):GetChild(column).gameObject:SetActive(true);
        end
    end
    self.showCSJLCallback = function()
        AJDMXEntry.CSJLRoll();
    end;
    self.isShowCSJL = true;
end
function AJDMX_Result.ShowCSJL()
    --财神展示
    if self.isShowCSJL then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= AJDMX_DataConfig.smallGameLoadingShowTime then
            AJDMXEntry.CSJLEffect.gameObject:SetActive(false);
            if self.showCSJLCallback ~= nil then
                self.showCSJLCallback();
            end
            self.isShowCSJL = false;
        end
    end
end
------------------------免费或者小游戏结束---------------------------
function AJDMX_Result.ShowCSJLResultEffect()
    logYellow("==========ShowCSJLResultEffect================")
    self.spGameGold = self.freeGold;
    AJDMXEntry.smallEffect.transform.localScale = Vector3.New(1, 1, 1);
    AJDMXEntry.winSmallEffectNum.text ="0" --AJDMXEntry.ShowText("0");

    AJDMXEntry.smallEffect.transform:Find("moveBG/FreeWin_Bg").localPosition=Vector3.New(-1000,0,0)
    AJDMXEntry.smallEffect.transform:Find("moveBG/FreeWin_Bg2").localPosition=Vector3.New(1000,0,0)
    AJDMXEntry.smallEffect.gameObject:SetActive(true);

    local showeffect = function()
        self.timer = 0;
        self.currentRunGold = 0;
        self.currentRunProgress = 0;
        self.hideFreeTime=5
        self.winRate = math.ceil(self.spGameGold / (AJDMX_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        log("累计：" .. AJDMXEntry.SmallGameData.nGold);
        --AJDMXEntry.freeOverTime.text=AJDMXEntry.ShowText(self.hideFreeTime)
        self.showResultCallback = function()
            log("关闭小游戏结果")
            AJDMXEntry.ChangeGold(AJDMXEntry.myGold);
            self.timer = 0;
            self.isShowCSJLResult = false;
            coroutine.start(function()
                AJDMXEntry.smallEffect:DOScale(Vector3.New(0, 0, 0), 0.3):OnComplete(function()
                    AJDMXEntry.smallEffect.gameObject:SetActive(false);
                    local tweener = AJDMXEntry.NormalPanel:DOLocalMove(Vector3.New(0,220,0), 1.5, false);
                    tweener:SetEase(DG.Tweening.Ease.OutCirc);
                    tweener:OnComplete( function()
                        self.CheckFree();
                    end)
                end);
            end);
        end
        self.isShowCSJLResult = true;
        log("开始免费结算跑分")
    end

    AJDMXEntry.smallEffect.transform:Find("moveBG/FreeWin_Bg"):DOLocalMove(Vector3.New(0, 0, 0), 0.3);
    AJDMXEntry.smallEffect.transform:Find("moveBG/FreeWin_Bg2"):DOLocalMove(Vector3.New(0, 0, 0), 0.3):OnComplete(showeffect);
end
function AJDMX_Result.ShowCSJLResult()
    --展示财神降临结果
    if self.isShowCSJLResult then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= self.spGameGold then
            self.currentRunGold = self.spGameGold;
        end
        AJDMXEntry.winSmallEffectNum.text = ShortNumber(self.currentRunGold) -- AJDMXEntry.ShowText(self.currentRunGold);
        --AJDMXEntry.freeOverTime.text=AJDMXEntry.ShowText(string.format("%.1f",(self.hideFreeTime-self.timer)))
        if self.timer >= self.hideFreeTime then
            self.isShowCSJLResult = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function AJDMX_Result.ShowFreeEffect()
    --展示免费
    --TODO 将scatter动画替换为中奖动画
    self.timer = 0;
    self.hideFreeTime=3

    self.showResultCallback = function()
        self.timer = 0;
        self.isHideFree = true;
        AJDMXEntry.addChipBtn.interactable = false;
        AJDMXEntry.reduceChipBtn.interactable = false;
        AJDMXEntry.MaxChipBtn.interactable = false;
        AJDMXEntry.freeCount=AJDMXEntry.ResultData.FreeCount
        AJDMXEntry.maxFreeGameCount = AJDMXEntry.freeCount
        AJDMXEntry.EnterFreeEffect.transform:Find("Tips2/Tips2BG0").localPosition=Vector3.New(-1000,0,0)
        AJDMXEntry.EnterFreeEffect.transform:Find("Tips2/Tips2Text").localPosition=Vector3.New(1000,0,0)
        AJDMXEntry.EnterFreeEffect.gameObject:SetActive(true);

        AJDMXEntry.EnterFreeEffect.transform:Find("Tips2/Tips2BG0"):DOLocalMove(Vector3.New(0, 0, 0), 0.3,false);
        AJDMXEntry.EnterFreeEffect.transform:Find("Tips2/Tips2Text"):DOLocalMove(Vector3.New(0, 0, 0), 0.3,false);

        AJDMX_Line.Close();
    end
    self.isShowFree = true;
end
function AJDMX_Result.ShowFree()
    if self.isShowFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= AJDMX_DataConfig.freeLoadingShowTime then
            self.isShowFree = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function AJDMX_Result.HideFree()
    --隐藏中奖
    if self.isHideFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= self.hideFreeTime then
            AJDMX_Audio.PlayBGM()
            --等待退出动画时长
            self.isHideFree = false;
            AJDMXEntry.EnterFreeEffect.gameObject:SetActive(false);
            local tweener = AJDMXEntry.NormalPanel:DOLocalMove(Vector3.New(0,1000,0), 0.5, false);
            tweener:SetEase(DG.Tweening.Ease.OutCirc);
            tweener:OnComplete( function()
                AJDMXEntry.FreeRoll();
            end)
        end
    end
end
---------------------中奖---------------------
function AJDMX_Result.ShowCYGGEffect()
    --很棒动画
    log("很棒");
    AJDMXEntry.greatEffect.transform.localScale = Vector3.New(0, 0, 0);
    AJDMXEntry.winGreatNum.text = AJDMXEntry.ShowText("0");
    AJDMXEntry.greatProgress.value = 0;
    AJDMXEntry.greatEffect.gameObject:SetActive(true);
    local showeffect = function()
        log("很棒动画");
        self.timer = 0;
        self.currentRunGold = 0;
        self.currentRunProgress = 0;
        self.winRate = math.ceil(AJDMXEntry.ResultData.WinScore / (AJDMX_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        self.progressRate = math.ceil(1 / (AJDMX_DataConfig.winGoldChangeRate / Time.deltaTime));
        AJDMXEntry.greatEffect.transform:Find("Group"):GetComponent("CanvasGroup"):DOFade(0, 0.8);
        self.showResultCallback = function()
            self.isShowCYGG = false;
            self.timer = 0;
            AJDMXEntry.ChangeGold(AJDMXEntry.myGold);
            coroutine.start(function()
                coroutine.wait(0.5);
                AJDMXEntry.greatEffect:DOScale(Vector3.New(0, 0, 0), 0.3):OnComplete(function()
                    AJDMXEntry.greatEffect.gameObject:SetActive(false);
                    self.CheckFree();
                end);
            end);
        end
        AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.bigWin, AJDMX_DataConfig.winGoldChangeRate);
        self.isShowCYGG = true;
    end
    AJDMXEntry.greatEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);
end
function AJDMX_Result.ShowCYGG()
    --很棒跑分
    if self.isShowCYGG then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= AJDMXEntry.ResultData.WinScore then
            self.currentRunGold = AJDMXEntry.ResultData.WinScore;
        end
        AJDMXEntry.winGreatNum.text = AJDMXEntry.ShowText(self.currentRunGold);
        AJDMXEntry.greatProgress.value = self.currentRunGold / AJDMXEntry.ResultData.WinScore;
        if self.timer >= AJDMX_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function AJDMX_Result.ShowJYMTEffect()
    --非常棒动画
    log("非常棒");
    AJDMXEntry.goodEffect.transform.localScale = Vector3.New(0, 0, 0);
    AJDMXEntry.winGoodNum.text = "0";
    AJDMXEntry.goodProgress.value = 0;
    AJDMXEntry.goodEffect.gameObject:SetActive(true);
    local showeffect = function()
        log("非常棒动画");
        self.timer = 0;
        self.currentRunGold = 0;
        self.currentRunProgress = 0;
        self.winRate = math.ceil(AJDMXEntry.ResultData.WinScore / (AJDMX_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        self.progressRate = math.ceil(1 / (AJDMX_DataConfig.winGoldChangeRate / Time.deltaTime));
        AJDMXEntry.goodEffect.transform:Find("Group"):GetComponent("CanvasGroup"):DOFade(0, 0.8);
        self.showResultCallback = function()
            AJDMXEntry.ChangeGold(AJDMXEntry.myGold);
            self.timer = 0;
            self.isShowJYMT = false;
            coroutine.start(function()
                coroutine.wait(0.5);
                AJDMXEntry.goodEffect:DOScale(Vector3.New(0, 0, 0), 0.3):OnComplete(function()
                    AJDMXEntry.goodEffect.gameObject:SetActive(false);
                    self.CheckFree();
                end);
            end);
        end
        AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.bigWin, AJDMX_DataConfig.winGoldChangeRate);
        self.isShowJYMT = true;
        log("非常棒动画开始");
    end
    AJDMXEntry.goodEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);
end
function AJDMX_Result.ShowJYMT()
    --金玉满堂
    if self.isShowJYMT then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= AJDMXEntry.ResultData.WinScore then
            self.currentRunGold = AJDMXEntry.ResultData.WinScore;
        end
        AJDMXEntry.winGoodNum.text = AJDMXEntry.ShowText(self.currentRunGold);
        AJDMXEntry.goodProgress.value = self.currentRunGold / AJDMXEntry.ResultData.WinScore;
        if self.timer >= AJDMX_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function AJDMX_Result.ShowPrefectEffect()
    --接近完美动画
    AJDMXEntry.perfectEffect.transform.localScale = Vector3.New(0, 0, 0);
    AJDMXEntry.winPerfectNum.text = AJDMXEntry.ShowText("0");
    AJDMXEntry.prefectProgress.value = 0;
    local showeffect = function()
        self.timer = 0;
        self.currentRunGold = 0;
        self.currentRunProgress = 0;
        self.winRate = math.ceil(AJDMXEntry.ResultData.WinScore / (AJDMX_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        AJDMXEntry.perfectEffect.transform:Find("Group"):GetComponent("CanvasGroup"):DOFade(0, 0.8);
        self.showResultCallback = function()
            AJDMXEntry.ChangeGold(AJDMXEntry.myGold);
            self.timer = 0;
            self.isShowPrefect = false;
            coroutine.start(function()
                coroutine.wait(0.5);
                AJDMXEntry.perfectEffect:DOScale(Vector3.New(0, 0, 0), 0.3):OnComplete(function()
                    AJDMXEntry.perfectEffect.gameObject:SetActive(false);
                    self.CheckFree();
                end);
            end);
        end
        AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.bigWin, AJDMX_DataConfig.winGoldChangeRate);

        self.isShowPrefect = true;
        AJDMXEntry.isRoll = false;
    end
    AJDMXEntry.perfectEffect.gameObject:SetActive(true);
    AJDMXEntry.perfectEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);
end
function AJDMX_Result.ShowPrefect()
    --接近完美
    if self.isShowPrefect then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= AJDMXEntry.ResultData.WinScore then
            self.currentRunGold = AJDMXEntry.ResultData.WinScore;
        end
        AJDMXEntry.winPerfectNum.text = AJDMXEntry.ShowText(self.currentRunGold);
        AJDMXEntry.prefectProgress.value = self.currentRunGold / AJDMXEntry.ResultData.WinScore;
        if self.timer >= AJDMX_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function AJDMX_Result.ShowBangEffect()
    
    AJDMXEntry.BangEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    AJDMXEntry.winBangNum.text = AJDMXEntry.ShowText(self.currentRunGold);
    AJDMXEntry.winBangNum.gameObject:SetActive(true);

    local index = 0;
    --AJDMXEntry.BangProgress.fillAmount = 0;
    self.BangwinTweener = Util.RunWinScore(0, AJDMXEntry.ResultData.WinScore, 3, function(value)
        self.currentRunGold = math.floor(value);
        local remain = (self.currentRunGold - index * (AJDMXEntry.ResultData.WinScore / 3)) / (AJDMXEntry.ResultData.WinScore / 3);
        --AJDMXEntry.BangProgress.fillAmount = remain;
        if remain >= 1 then
            AJDMXEntry.AJDMX_bingwin01.gameObject:SetActive(true)
            -- if index < 3 then
            --     index = index + 1;
            --     if index>=AJDMXEntry.BangWinTitle.childCount then
            --         index=AJDMXEntry.BangWinTitle.childCount-1
            --         AJDMXEntry.BangProgress.fillAmount = 1;
            --     else
            --         AJDMXEntry.BangProgress.fillAmount = 0;
            --     end
            --     AJDMXEntry.BangWinTitle:GetChild(index).gameObject:SetActive(true);
            -- end
        end
        AJDMXEntry.winBangNum.text = AJDMXEntry.ShowText(self.currentRunGold);
        AJDMXEntry.WinNum.text = ShortNumber(self.currentRunGold);
    end);
    self.BangwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        --AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.Coin);
        AJDMXEntry.AJDMX_bingwin01.gameObject:SetActive(false)

        AJDMXEntry.winBangNum.text = AJDMXEntry.ShowText(AJDMXEntry.ResultData.WinScore);
        AJDMXEntry.WinNum.text = ShortNumber(AJDMXEntry.ResultData.WinScore);

        AJDMXEntry.ChangeGold(AJDMXEntry.myGold);
        self.BangwinTweener = Util.RunWinScore(0, 1, 1, nil);
        self.BangwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            AJDMXEntry.BangEffect.gameObject:SetActive(false);
            self.CheckFree();
        end);
    end);

    AJDMXEntry.closeBangBtn.onClick:RemoveAllListeners();
    AJDMXEntry.closeBangBtn.interactable = true;
    AJDMXEntry.closeBangBtn.onClick:AddListener(function()
        -- AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BTN);
        -- AJDMX_Audio.ClearAuido(AJDMX_Audio.SoundList.BigJB);
        -- AJDMX_Audio.ClearAuido(AJDMX_Audio.SoundList.BigWin2);
        AJDMXEntry.ChangeGold(AJDMXEntry.myGold);
        AJDMXEntry.closeBangBtn.interactable = false;
        if self.BangwinTweener ~= nil then
            self.BangwinTweener:Kill();
        end
        -- index = AJDMXEntry.BangWinTitle.childCount;
        -- for i = 1, AJDMXEntry.BangWinTitle.childCount do
        --     AJDMXEntry.BangWinTitle:GetChild(i - 1).gameObject:SetActive(false);
        -- end
        -- AJDMXEntry.BangWinTitle:GetChild(index-1).gameObject:SetActive(true);
        -- AJDMXEntry.BangProgress.fillAmount = 1;
        AJDMXEntry.winBangNum.text =AJDMXEntry.ShowText(AJDMXEntry.ResultData.WinScore);
        AJDMXEntry.WinNum.text = ShortNumber(AJDMXEntry.ResultData.WinScore);

        Util.RunWinScore(0, 1,1.5, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            AJDMXEntry.BangEffect.gameObject:SetActive(false);
            self.CheckFree();
        end);
    end);
end


function AJDMX_Result.ShowBang()
    --bang
    if self.isShowBang then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= AJDMXEntry.ResultData.WinScore then
            self.currentRunGold = AJDMXEntry.ResultData.WinScore;
        end
        AJDMXEntry.winBangNum.text = AJDMXEntry.ShowText(self.currentRunGold);
        if self.currentRunProgress < 3 then
            AJDMXEntry.BangProgress.value = (self.currentRunGold / AJDMXEntry.ResultData.WinScore) * 5 - self.currentRunProgress;
        end
        if AJDMXEntry.BangProgress.value >= 1 and self.currentRunProgress < 2 then
            AJDMXEntry.BangProgress.value = 0;
            --TODO 音效
            self.currentRunProgress = self.currentRunProgress + 1;
            if self.currentRunProgress == 1 then
                AJDMXEntry.BangDJJY:SetActive(false);
                AJDMXEntry.BangFJYF:SetActive(true);
                AJDMXEntry.BangTXWS:SetActive(false);
            elseif self.currentRunProgress == 2 then
                AJDMXEntry.BangDJJY:SetActive(false);
                AJDMXEntry.BangFJYF:SetActive(false);
                AJDMXEntry.BangTXWS:SetActive(true);
            end
        end
        if self.timer >= AJDMX_DataConfig.winBigGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function AJDMX_Result.ShowBigEffect()
    --大分动画
    AJDMXEntry.bigEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;

    AJDMXEntry.winBigNum.text = AJDMXEntry.ShowText(self.currentRunGold);
    AJDMXEntry.winBigNum.gameObject:SetActive(true);
    for i = 1, AJDMXEntry.bigWinTitle.childCount do
        AJDMXEntry.bigWinTitle:GetChild(i - 1).gameObject:SetActive(false);
    end
    local index = 0;
    AJDMXEntry.bigProgress.fillAmount = 0;
    AJDMXEntry.bigWinTitle:GetChild(index).gameObject:SetActive(true);
    -- AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BigJB);
    -- AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BigWin2);
    AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.bigWin,5);

    self.BigwinTweener = Util.RunWinScore(0, AJDMXEntry.ResultData.WinScore, 5, function(value)
        self.currentRunGold = math.floor(value);
        local remain = (self.currentRunGold - index * (AJDMXEntry.ResultData.WinScore / 5)) / (AJDMXEntry.ResultData.WinScore / 5);
        AJDMXEntry.bigProgress.fillAmount = remain;
        if remain >= 1 then
            if index < 5 then
                AJDMXEntry.bigWinTitle:GetChild(index).gameObject:SetActive(false);
                index = index + 1;
                if index>=AJDMXEntry.bigWinTitle.childCount then
                    index=AJDMXEntry.bigWinTitle.childCount-1
                    AJDMXEntry.bigProgress.fillAmount = 1;
                else
                    AJDMXEntry.bigProgress.fillAmount = 0;
                    --AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.titleMove);
                end
                AJDMXEntry.bigWinTitle:GetChild(index).gameObject:SetActive(true);
            end
        end
        AJDMXEntry.winBigNum.text = AJDMXEntry.ShowText(self.currentRunGold);
    end);
    self.BigwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        --AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.Coin);
        AJDMXEntry.winBigNum.text = AJDMXEntry.ShowText(AJDMXEntry.ResultData.WinScore);
        AJDMXEntry.ChangeGold(AJDMXEntry.myGold);
        self.BigwinTweener = Util.RunWinScore(0, 1, 1, nil);
        self.BigwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            AJDMXEntry.bigEffect.gameObject:SetActive(false);
            self.CheckFree();
        end);
    end);

    AJDMXEntry.closebigBtn.onClick:RemoveAllListeners();
    AJDMXEntry.closebigBtn.interactable = true;
    AJDMXEntry.closebigBtn.onClick:AddListener(function()
        -- AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BTN);
        -- AJDMX_Audio.ClearAuido(AJDMX_Audio.SoundList.BigJB);
        -- AJDMX_Audio.ClearAuido(AJDMX_Audio.SoundList.BigWin2);
        AJDMXEntry.ChangeGold(AJDMXEntry.myGold);
        AJDMXEntry.closebigBtn.interactable = false;
        if self.BigwinTweener ~= nil then
            self.BigwinTweener:Kill();
        end
        index = AJDMXEntry.bigWinTitle.childCount;
        for i = 1, AJDMXEntry.bigWinTitle.childCount do
            AJDMXEntry.bigWinTitle:GetChild(i - 1).gameObject:SetActive(false);
        end
        AJDMXEntry.bigWinTitle:GetChild(index-1).gameObject:SetActive(true);
        AJDMXEntry.bigProgress.fillAmount = 1;
        AJDMXEntry.winBigNum.text = AJDMXEntry.ShowText(AJDMXEntry.ResultData.WinScore);
        Util.RunWinScore(0, 1, 0.5, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            AJDMXEntry.bigEffect.gameObject:SetActive(false);
            self.CheckFree();
        end);
    end);
end

function AJDMX_Result.ShowBig()
    --高分
    if self.isShowBig then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= AJDMXEntry.ResultData.WinScore then
            self.currentRunGold = AJDMXEntry.ResultData.WinScore;
        end
        AJDMXEntry.winBigNum.text = AJDMXEntry.ShowText(self.currentRunGold);
        if self.currentRunProgress < 3 then
            AJDMXEntry.bigProgress.value = (self.currentRunGold / AJDMXEntry.ResultData.WinScore) * 5 - self.currentRunProgress;
        end
        if AJDMXEntry.bigProgress.value >= 1 and self.currentRunProgress < 2 then
            AJDMXEntry.bigProgress.value = 0;
            --TODO 音效
            AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.bigWin, AJDMX_DataConfig.winBigGoldChangeRate / 3);
            self.currentRunProgress = self.currentRunProgress + 1;
            if self.currentRunProgress == 1 then
                AJDMXEntry.bigDJJY:SetActive(false);
                AJDMXEntry.bigFJYF:SetActive(true);
                AJDMXEntry.bigTXWS:SetActive(false);
            elseif self.currentRunProgress == 2 then
                AJDMXEntry.bigDJJY:SetActive(false);
                AJDMXEntry.bigFJYF:SetActive(false);
                AJDMXEntry.bigTXWS:SetActive(true);
            end
        end
        if self.timer >= AJDMX_DataConfig.winBigGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function AJDMX_Result.ShowNormalEffect()
    --普通奖动画
    AJDMXEntry.WinNum.gameObject:SetActive(false)
    AJDMXEntry.winLZPos.gameObject:SetActive(false)
    AJDMXEntry.winNormalEffect.gameObject:SetActive(true);
    AJDMXEntry.closeNormalEffectBtn.gameObject:SetActive(true)
    AJDMXEntry.WinNum.gameObject:SetActive(true)
    self.timer = 0;
    self.currentRunGold = 0;
    AJDMXEntry.WinNum.text = ShortNumber(self.currentRunGold);-- AJDMXEntry.ShowText(self.currentRunGold);
    AJDMXEntry.WinNum.gameObject:SetActive(true);
    AJDMXEntry.winLZPos.gameObject:SetActive(true)
    AJDMXEntry.winLZPos:GetChild(0).gameObject:SetActive(true)
    
    self.winNormalTweener = Util.RunWinScore(0, AJDMXEntry.ResultData.WinScore, 2, function(value)
        self.currentRunGold = math.floor(value);
        AJDMXEntry.WinNum.text =ShortNumber(self.currentRunGold)-- AJDMXEntry.ShowText(self.currentRunGold);
    end);

    self.winNormalTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        AJDMXEntry.WinNum.text = ShortNumber(AJDMXEntry.ResultData.WinScore);--AJDMXEntry.ShowText(AJDMXEntry.ResultData.WinScore);
        AJDMXEntry.ChangeGold(AJDMXEntry.myGold);
        self.winNormalTweener = Util.RunWinScore(0, 1, 1, nil);
        self.winNormalTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            AJDMXEntry.winNormalEffect.gameObject:SetActive(false);
            AJDMXEntry.winLZPos.gameObject:SetActive(false)
            AJDMXEntry.winLZPos:GetChild(0).gameObject:SetActive(false)
            self.CheckFree();
        end);
    end);
    AJDMXEntry.closeNormalEffectBtn.onClick:RemoveAllListeners();
    AJDMXEntry.closeNormalEffectBtn.interactable = true;
    AJDMXEntry.closeNormalEffectBtn.onClick:AddListener(function()
        AJDMXEntry.ChangeGold(AJDMXEntry.myGold);
        AJDMXEntry.closeNormalEffectBtn.interactable = false;
        AJDMXEntry.closeNormalEffectBtn.gameObject:SetActive(false)
        if self.winNormalTweener ~= nil then
            self.winNormalTweener:Kill();
        end
        AJDMXEntry.WinNum.text =ShortNumber(AJDMXEntry.ResultData.WinScore)-- AJDMXEntry.ShowText(AJDMXEntry.ResultData.WinScore);
        Util.RunWinScore(0, 1, 0.5, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            AJDMXEntry.winNormalEffect.gameObject:SetActive(false);
            AJDMXEntry.winLZPos.gameObject:SetActive(false)
            AJDMXEntry.winLZPos:GetChild(0).gameObject:SetActive(false)
            self.CheckFree();
        end);
    end);
end

function AJDMX_Result.ShowNormal()
    --普通奖
    if self.isShowNormal then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= AJDMXEntry.ResultData.WinScore then
            self.currentRunGold = AJDMXEntry.ResultData.WinScore;
        end
        if self.timer >= AJDMX_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function AJDMX_Result.HideNormal()
    --隐藏中奖
    if self.isHideNormal then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= self.hideNormalTime then
            --等待退出动画时长
            self.isHideNormal = false;
            AJDMXEntry.winNormalEffect.gameObject:SetActive(false);
            self.CheckFree();
        end
    end
end