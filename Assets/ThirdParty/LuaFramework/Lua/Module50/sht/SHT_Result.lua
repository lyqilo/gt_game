SHT_Result = {};

local self = SHT_Result;

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

function SHT_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = false;
    self.isPause = false;
    self.isFreeGame = false;
end
function SHT_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = true;
    SHTEntry.myGold = TableUserInfo._7wGold;
    SHTEntry.WinNum.text = SHTEntry.ShowText(SHTEntry.ResultData.WinScore);
    self.isClickShouFen = false;

    --其他正常模式
    local showResultCall = function()
        --先做免费的操作

        if SHTEntry.isFreeGame then
            self.freeGold = self.freeGold + SHTEntry.ResultData.WinScore;
            log("免费累计获得：" .. self.freeGold);
            SHTEntry.TopFreeGameGoood.text=SHTEntry.ShowText(self.freeGold)
        end

        if SHTEntry.ResultData.WinScore > 0 then
            SHT_Line.Show()
            if SHTEntry.ResultData.m_nWinPeiLv < 4  then
                --低奖
                self.ShowNormalEffect();
             elseif SHTEntry.ResultData.m_nWinPeiLv >= 4  and SHTEntry.ResultData.m_nWinPeiLv < 8  then
                self.ShowBangEffect()
            elseif SHTEntry.ResultData.m_nWinPeiLv >= 8  then
                --展示有翅膀的动画
                self.ShowBigEffect();
            end
        else
            self.nowin = true;
            local rd = math.random(2, #SHT_DataConfig.WinConfig);
            SHTEntry.WinDesc.text = SHT_DataConfig.WinConfig[rd];
            SHTEntry.ChangeGold(SHTEntry.myGold);
        end
    end
    coroutine.stop(showResultCall);
    coroutine.start(showResultCall);
end

function SHT_Result.CheckFree()
    logYellow("检查是否中免费")
    --检查是否中免费
    if not SHTEntry.isFreeGame then
        SHTEntry.isRoll = false;
        if SHTEntry.ResultData.FreeCount > 0 then
            --中免费了
            self.freeGold = 0;
            SHTEntry.isFreeGame = true;
            self.isFreeGame = true;
            SHTEntry.addChipBtn.interactable = false;
            SHTEntry.reduceChipBtn.interactable = false;
            SHTEntry.MaxChipBtn.interactable = false;
            self.ShowFreeEffect();
        else
            SHTEntry.FreeRoll();
        end
    else
        SHTEntry.isRoll = false;
        if self.isFreeGame and SHTEntry.ResultData.FreeCount <= 0 then
            self.isFreeGame = false;
            self.ShowCSJLResultEffect();--免费结束结算
        else
            SHTEntry.FreeRoll();
        end
    end
end
function SHT_Result.HideResult()
    for i = 1, SHTEntry.resultEffect.childCount do
        SHTEntry.resultEffect:GetChild(i - 1).gameObject:SetActive(false);
    end
    self.showCSJLCallback = nil;
    self.showResultCallback = nil;
    logYellow("HideResult")
end
function SHT_Result.QuickOver(type)
    if self.isClickShouFen then
        return ;
    end
    self.isClickShouFen = true;
    self.currentRunGold = SHTEntry.ResultData.WinScore;
    if type == 1 then
        --很棒
        SHTEntry.greatProgress.value = 1;
        SHTEntry.winGreatNum.text = SHTEntry.ShowText(SHTEntry.ResultData.WinScore);
        if self.isShowCYGG then
            self.timer = SHT_DataConfig.winGoldChangeRate - 0.5;
        end
    elseif type == 2 then
        --非常棒
        SHTEntry.goodProgress.value = 1;
        SHTEntry.winGoodNum.text = SHTEntry.ShowText(SHTEntry.ResultData.WinScore);
        if self.isShowJYMT then
            self.timer = SHT_DataConfig.winGoldChangeRate - 0.5;
        end
    elseif type == 3 then
        --接近完美
        SHTEntry.prefectProgress.value = 1;
        SHTEntry.winPerfectNum.text = SHTEntry.ShowText(SHTEntry.ResultData.WinScore);
        if self.isShowPrefect then
            self.timer = SHT_DataConfig.winGoldChangeRate - 0.5;
        end
    elseif type == 4 then
        --高分
        SHTEntry.bigProgress.value = 1;
        SHTEntry.winBigNum.text = SHTEntry.ShowText(SHTEntry.ResultData.WinScore);
        SHTEntry.bigDJJY:SetActive(false);
        SHTEntry.bigFJYF:SetActive(false);
        SHTEntry.bigTXWS:SetActive(true);
        if self.isShowBig then
            self.timer = SHT_DataConfig.winGoldChangeRate * 3 - 0.5;
        end
    elseif type == 5 then
        --高分
        SHTEntry.BangProgress.value = 1;
        SHTEntry.winBangNum.text = SHTEntry.ShowText(SHTEntry.ResultData.WinScore);
        SHTEntry.BangDJJY:SetActive(false);
        SHTEntry.BangFJYF:SetActive(false);
        SHTEntry.BangTXWS:SetActive(true);
        if self.isShowBang then
            self.timer = SHT_DataConfig.winGoldChangeRate * 3 - 0.5;
        end
    end
    SHTEntry.ChangeGold(SHTEntry.myGold);
end
function SHT_Result.Update()
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

function SHT_Result.NoWinWait()
    if self.nowin then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= SHT_DataConfig.autoNoRewardInterval then
            self.nowin = false;
            self.CheckFree();
        end
    end
end
----------------------财神--------------------------------
function SHT_Result.WaitRollAgainCSJL()
    --财神重转
    if self.waitNextCSJL then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= SHT_DataConfig.autoNoRewardInterval then
            self.waitNextCSJL = false;
            if self.showCSJLCallback ~= nil then
                self.showCSJLCallback();
            end
        end
    end
end
function SHT_Result.ShowCSJLEffect()
    --财神展示动画
    SHT_Audio.PlayBGM(SHT_Audio.SoundList.CSJLBGM);
    SHTEntry.CSJLEffect.gameObject:SetActive(true);
    SHTEntry.CSJLEffect.AnimationState:SetAnimation(0, "animation", true);
    SHTEntry.CSGroup.gameObject:SetActive(true);
    for i = 1, #SHTEntry.ResultData.ImgTable do
        if SHTEntry.ResultData.ImgTable[i] == 0 then
            local column = math.floor(i / 5);--排
            local raw = i % 5;--列
            if raw == 0 then
                raw = 5;
                column = column - 1;
            end
            SHTEntry.CSGroup:GetChild(raw - 1):GetChild(column).gameObject:SetActive(true);
        end
    end
    self.showCSJLCallback = function()
        SHTEntry.CSJLRoll();
    end;
    self.isShowCSJL = true;
end
function SHT_Result.ShowCSJL()
    --财神展示
    if self.isShowCSJL then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= SHT_DataConfig.smallGameLoadingShowTime then
            SHTEntry.CSJLEffect.gameObject:SetActive(false);
            if self.showCSJLCallback ~= nil then
                self.showCSJLCallback();
            end
            self.isShowCSJL = false;
        end
    end
end
------------------------免费或者小游戏结束---------------------------
function SHT_Result.ShowCSJLResultEffect()
    self.spGameGold = self.freeGold;
    SHTEntry.smallEffect.transform.localScale = Vector3.New(0, 0, 0);
    SHTEntry.winSmallEffectNum.text = SHTEntry.ShowText("0");
    SHTEntry.smallEffect.gameObject:SetActive(true);
    local showeffect = function()
        self.timer = 0;
        self.currentRunGold = 0;
        self.currentRunProgress = 0;
        self.hideFreeTime=5
        self.winRate = math.ceil(self.spGameGold / (SHT_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        log("累计：" .. SHTEntry.SmallGameData.nGold);
        SHTEntry.freeOverTime.text=ShowRichText(self.hideFreeTime)
        self.showResultCallback = function()
            log("关闭小游戏结果")
            SHTEntry.ChangeGold(SHTEntry.myGold);
            self.timer = 0;
            self.isShowCSJLResult = false;
            coroutine.start(function()
                -- while self.hideFreeTime>0 do
                --     coroutine.wait(0.1);
                --     self.hideFreeTime=self.hideFreeTime-0.1
                --     SHTEntry.freeOverTime.text=SHTEntry.ShowText(self.hideFreeTime)
                -- end
                SHTEntry.smallEffect:DOScale(Vector3.New(0, 0, 0), 0.3):OnComplete(function()
                    SHTEntry.smallEffect.gameObject:SetActive(false);
                    local tweener = SHTEntry.NormalPanel:DOLocalMove(Vector3.New(0,220,0), 1.5, false);
                    tweener:SetEase(DG.Tweening.Ease.OutCirc);
                    tweener:OnComplete( function()
                        self.CheckFree();
                    end)
                end);
            end);
        end
        SHT_Audio.PlaySound(SHT_Audio.SoundList.moneyAdd, SHT_DataConfig.winGoldChangeRate);
        self.isShowCSJLResult = true;
        log("开始免费结算跑分")
    end
    SHTEntry.smallEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);

end
function SHT_Result.ShowCSJLResult()
    --展示财神降临结果
    if self.isShowCSJLResult then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= self.spGameGold then
            self.currentRunGold = self.spGameGold;
        end
        SHTEntry.winSmallEffectNum.text = SHTEntry.ShowText(self.currentRunGold);
        SHTEntry.freeOverTime.text=ShowRichText(string.format("%.1f",(self.hideFreeTime-self.timer)))
        if self.timer >= self.hideFreeTime then
            self.isShowCSJLResult = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function SHT_Result.ShowFreeEffect()
    --展示免费
    --TODO 将scatter动画替换为中奖动画
    self.timer = 0;
    self.hideFreeTime=5

    self.showResultCallback = function()
        self.timer = 0;
        self.isHideFree = true;
        SHTEntry.addChipBtn.interactable = false;
        SHTEntry.reduceChipBtn.interactable = false;
        SHTEntry.MaxChipBtn.interactable = false;
        SHTEntry.freeCount=SHTEntry.ResultData.FreeCount
        SHTEntry.FreeCountText.text=ShowRichText(tostring(SHTEntry.ResultData.FreeCount))
        SHTEntry.TopFreeCountText.text=ShowRichText(tostring(SHTEntry.ResultData.FreeCount)) 
        SHTEntry.freedownTime.text= ShowRichText(self.hideFreeTime)
        SHTEntry.TopFreeGameGoood.text=SHTEntry.ShowText("0")
        SHTEntry.EnterFreeEffect.gameObject:SetActive(true);
        SHT_Audio.PlaySound(SHT_Audio.SoundList.guochang);
        SHT_Line.Close();
    end
    self.isShowFree = true;
end
function SHT_Result.ShowFree()
    if self.isShowFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= SHT_DataConfig.freeLoadingShowTime then
            self.isShowFree = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function SHT_Result.HideFree()
    --隐藏中奖
    if self.isHideFree then
        self.timer = self.timer + Time.deltaTime;
        SHTEntry.freedownTime.text=ShowRichText(string.format("%.1f",(self.hideFreeTime-self.timer)))
        if self.timer >= self.hideFreeTime then
            SHT_Audio.PlayBGM(SHT_Audio.SoundList.FreeBgm);
            SHTEntry.freedownTime.text=ShowRichText(0)
            --等待退出动画时长
            self.isHideFree = false;
            SHTEntry.EnterFreeEffect.gameObject:SetActive(false);
            local tweener = SHTEntry.NormalPanel:DOLocalMove(Vector3.New(0,1000,0), 1.5, false);
            tweener:SetEase(DG.Tweening.Ease.OutCirc);
            tweener:OnComplete( function()
                SHTEntry.FreeRoll();
            end)
        end
    end
end
---------------------中奖---------------------
function SHT_Result.ShowCYGGEffect()
    --很棒动画
    log("很棒");
    SHTEntry.greatEffect.transform.localScale = Vector3.New(0, 0, 0);
    SHTEntry.winGreatNum.text = SHTEntry.ShowText("0");
    SHTEntry.greatProgress.value = 0;
    SHTEntry.greatEffect.gameObject:SetActive(true);
    local showeffect = function()
        log("很棒动画");
        self.timer = 0;
        self.currentRunGold = 0;
        self.currentRunProgress = 0;
        self.winRate = math.ceil(SHTEntry.ResultData.WinScore / (SHT_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        self.progressRate = math.ceil(1 / (SHT_DataConfig.winGoldChangeRate / Time.deltaTime));
        SHTEntry.greatEffect.transform:Find("Group"):GetComponent("CanvasGroup"):DOFade(0, 0.8);
        self.showResultCallback = function()
            self.isShowCYGG = false;
            self.timer = 0;
            SHTEntry.ChangeGold(SHTEntry.myGold);
            coroutine.start(function()
                coroutine.wait(0.5);
                SHTEntry.greatEffect:DOScale(Vector3.New(0, 0, 0), 0.3):OnComplete(function()
                    SHTEntry.greatEffect.gameObject:SetActive(false);
                    self.CheckFree();
                end);
            end);
        end
        SHT_Audio.PlaySound(SHT_Audio.SoundList.bigWin, SHT_DataConfig.winGoldChangeRate);
        self.isShowCYGG = true;
    end
    SHTEntry.greatEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);
end
function SHT_Result.ShowCYGG()
    --很棒跑分
    if self.isShowCYGG then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= SHTEntry.ResultData.WinScore then
            self.currentRunGold = SHTEntry.ResultData.WinScore;
        end
        SHTEntry.winGreatNum.text = SHTEntry.ShowText(self.currentRunGold);
        SHTEntry.greatProgress.value = self.currentRunGold / SHTEntry.ResultData.WinScore;
        if self.timer >= SHT_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function SHT_Result.ShowJYMTEffect()
    --非常棒动画
    log("非常棒");
    SHTEntry.goodEffect.transform.localScale = Vector3.New(0, 0, 0);
    SHTEntry.winGoodNum.text = SHTEntry.ShowText("0");
    SHTEntry.goodProgress.value = 0;
    SHTEntry.goodEffect.gameObject:SetActive(true);
    local showeffect = function()
        log("非常棒动画");
        self.timer = 0;
        self.currentRunGold = 0;
        self.currentRunProgress = 0;
        self.winRate = math.ceil(SHTEntry.ResultData.WinScore / (SHT_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        self.progressRate = math.ceil(1 / (SHT_DataConfig.winGoldChangeRate / Time.deltaTime));
        SHTEntry.goodEffect.transform:Find("Group"):GetComponent("CanvasGroup"):DOFade(0, 0.8);
        self.showResultCallback = function()
            SHTEntry.ChangeGold(SHTEntry.myGold);
            self.timer = 0;
            self.isShowJYMT = false;
            coroutine.start(function()
                coroutine.wait(0.5);
                SHTEntry.goodEffect:DOScale(Vector3.New(0, 0, 0), 0.3):OnComplete(function()
                    SHTEntry.goodEffect.gameObject:SetActive(false);
                    self.CheckFree();
                end);
            end);
        end
        SHT_Audio.PlaySound(SHT_Audio.SoundList.bigWin, SHT_DataConfig.winGoldChangeRate);
        self.isShowJYMT = true;
        log("非常棒动画开始");
    end
    SHTEntry.goodEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);
end
function SHT_Result.ShowJYMT()
    --金玉满堂
    if self.isShowJYMT then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= SHTEntry.ResultData.WinScore then
            self.currentRunGold = SHTEntry.ResultData.WinScore;
        end
        SHTEntry.winGoodNum.text = SHTEntry.ShowText(self.currentRunGold);
        SHTEntry.goodProgress.value = self.currentRunGold / SHTEntry.ResultData.WinScore;
        if self.timer >= SHT_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function SHT_Result.ShowPrefectEffect()
    --接近完美动画
    SHTEntry.perfectEffect.transform.localScale = Vector3.New(0, 0, 0);
    SHTEntry.winPerfectNum.text = SHTEntry.ShowText("0");
    SHTEntry.prefectProgress.value = 0;
    local showeffect = function()
        self.timer = 0;
        self.currentRunGold = 0;
        self.currentRunProgress = 0;
        self.winRate = math.ceil(SHTEntry.ResultData.WinScore / (SHT_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        SHTEntry.perfectEffect.transform:Find("Group"):GetComponent("CanvasGroup"):DOFade(0, 0.8);
        self.showResultCallback = function()
            SHTEntry.ChangeGold(SHTEntry.myGold);
            self.timer = 0;
            self.isShowPrefect = false;
            coroutine.start(function()
                coroutine.wait(0.5);
                SHTEntry.perfectEffect:DOScale(Vector3.New(0, 0, 0), 0.3):OnComplete(function()
                    SHTEntry.perfectEffect.gameObject:SetActive(false);
                    self.CheckFree();
                end);
            end);
        end
        SHT_Audio.PlaySound(SHT_Audio.SoundList.bigWin, SHT_DataConfig.winGoldChangeRate);
        SHT_Audio.PlaySound(SHT_Audio.SoundList.goldToGround, SHT_DataConfig.winGoldChangeRate);

        self.isShowPrefect = true;
        SHTEntry.isRoll = false;
    end
    SHTEntry.perfectEffect.gameObject:SetActive(true);
    SHTEntry.perfectEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);
end
function SHT_Result.ShowPrefect()
    --接近完美
    if self.isShowPrefect then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= SHTEntry.ResultData.WinScore then
            self.currentRunGold = SHTEntry.ResultData.WinScore;
        end
        SHTEntry.winPerfectNum.text = SHTEntry.ShowText(self.currentRunGold);
        SHTEntry.prefectProgress.value = self.currentRunGold / SHTEntry.ResultData.WinScore;
        if self.timer >= SHT_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function SHT_Result.ShowBangEffect()
    
    SHTEntry.BangEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    SHTEntry.winBangNum.text = SHTEntry.ShowText(self.currentRunGold);
    SHTEntry.winBangNum.gameObject:SetActive(true);
    for i = 1, SHTEntry.BangWinTitle.childCount do
        SHTEntry.BangWinTitle:GetChild(i - 1).gameObject:SetActive(false);
    end
    local index = 0;
    SHTEntry.BangProgress.fillAmount = 0;
    SHTEntry.BangWinTitle:GetChild(index).gameObject:SetActive(true);
    SHT_Audio.PlaySound(SHT_Audio.SoundList.middleWin1);
    -- SHT_Audio.PlaySound(SHT_Audio.SoundList.BigWin2);
    self.BangwinTweener = Util.RunWinScore(0, SHTEntry.ResultData.WinScore, 3, function(value)
        self.currentRunGold = math.floor(value);
        local remain = (self.currentRunGold - index * (SHTEntry.ResultData.WinScore / 3)) / (SHTEntry.ResultData.WinScore / 3);
        SHTEntry.BangProgress.fillAmount = remain;
        if remain >= 1 then
            if index < 3 then
                SHTEntry.BangWinTitle:GetChild(index).gameObject:SetActive(false);
                index = index + 1;
                if index>=SHTEntry.BangWinTitle.childCount then
                    index=SHTEntry.BangWinTitle.childCount-1
                    SHTEntry.BangProgress.fillAmount = 1;
                else
                    SHTEntry.BangProgress.fillAmount = 0;
                    --SHT_Audio.PlaySound(SHT_Audio.SoundList.titleMove);
                end
                SHTEntry.BangWinTitle:GetChild(index).gameObject:SetActive(true);
            end
        end
        SHTEntry.winBangNum.text = SHTEntry.ShowText(self.currentRunGold);
    end);
    self.BangwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        --SHT_Audio.PlaySound(SHT_Audio.SoundList.Coin);
        SHTEntry.winBangNum.text = SHTEntry.ShowText(SHTEntry.ResultData.WinScore);
        SHTEntry.ChangeGold(SHTEntry.myGold);
        self.BangwinTweener = Util.RunWinScore(0, 1, 1, nil);
        self.BangwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            SHTEntry.BangEffect.gameObject:SetActive(false);
            self.CheckFree();
        end);
    end);

    SHTEntry.closeBangBtn.onClick:RemoveAllListeners();
    SHTEntry.closeBangBtn.interactable = true;
    SHTEntry.closeBangBtn.onClick:AddListener(function()
        -- SHT_Audio.PlaySound(SHT_Audio.SoundList.BTN);
        -- SHT_Audio.ClearAuido(SHT_Audio.SoundList.BigJB);
        -- SHT_Audio.ClearAuido(SHT_Audio.SoundList.BigWin2);
        SHTEntry.ChangeGold(SHTEntry.myGold);
        SHTEntry.closeBangBtn.interactable = false;
        if self.BangwinTweener ~= nil then
            self.BangwinTweener:Kill();
        end
        index = SHTEntry.BangWinTitle.childCount;
        for i = 1, SHTEntry.BangWinTitle.childCount do
            SHTEntry.BangWinTitle:GetChild(i - 1).gameObject:SetActive(false);
        end
        SHTEntry.BangWinTitle:GetChild(index-1).gameObject:SetActive(true);
        SHTEntry.BangProgress.fillAmount = 1;
        SHTEntry.winBangNum.text = SHTEntry.ShowText(SHTEntry.ResultData.WinScore);
        Util.RunWinScore(0, 1, 0.5, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            SHTEntry.BangEffect.gameObject:SetActive(false);
            self.CheckFree();
        end);
    end);
end


function SHT_Result.ShowBang()
    --bang
    if self.isShowBang then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= SHTEntry.ResultData.WinScore then
            self.currentRunGold = SHTEntry.ResultData.WinScore;
        end
        SHTEntry.winBangNum.text = SHTEntry.ShowText(self.currentRunGold);
        if self.currentRunProgress < 3 then
            SHTEntry.BangProgress.value = (self.currentRunGold / SHTEntry.ResultData.WinScore) * 5 - self.currentRunProgress;
        end
        if SHTEntry.BangProgress.value >= 1 and self.currentRunProgress < 2 then
            SHTEntry.BangProgress.value = 0;
            --TODO 音效
            self.currentRunProgress = self.currentRunProgress + 1;
            if self.currentRunProgress == 1 then
                SHTEntry.BangDJJY:SetActive(false);
                SHTEntry.BangFJYF:SetActive(true);
                SHTEntry.BangTXWS:SetActive(false);
            elseif self.currentRunProgress == 2 then
                SHTEntry.BangDJJY:SetActive(false);
                SHTEntry.BangFJYF:SetActive(false);
                SHTEntry.BangTXWS:SetActive(true);
            end
        end
        if self.timer >= SHT_DataConfig.winBigGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function SHT_Result.ShowBigEffect()
    --大分动画
    SHTEntry.bigEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;

    SHTEntry.winBigNum.text = SHTEntry.ShowText(self.currentRunGold);
    SHTEntry.winBigNum.gameObject:SetActive(true);
    for i = 1, SHTEntry.bigWinTitle.childCount do
        SHTEntry.bigWinTitle:GetChild(i - 1).gameObject:SetActive(false);
    end
    local index = 0;
    SHTEntry.bigProgress.fillAmount = 0;
    SHTEntry.bigWinTitle:GetChild(index).gameObject:SetActive(true);
    -- SHT_Audio.PlaySound(SHT_Audio.SoundList.BigJB);
    -- SHT_Audio.PlaySound(SHT_Audio.SoundList.BigWin2);
    SHT_Audio.PlaySound(SHT_Audio.SoundList.bigWin,5);

    self.BigwinTweener = Util.RunWinScore(0, SHTEntry.ResultData.WinScore, 5, function(value)
        self.currentRunGold = math.floor(value);
        local remain = (self.currentRunGold - index * (SHTEntry.ResultData.WinScore / 5)) / (SHTEntry.ResultData.WinScore / 5);
        SHTEntry.bigProgress.fillAmount = remain;
        if remain >= 1 then
            if index < 5 then
                SHTEntry.bigWinTitle:GetChild(index).gameObject:SetActive(false);
                index = index + 1;
                if index>=SHTEntry.bigWinTitle.childCount then
                    index=SHTEntry.bigWinTitle.childCount-1
                    SHTEntry.bigProgress.fillAmount = 1;
                else
                    SHTEntry.bigProgress.fillAmount = 0;
                    --SHT_Audio.PlaySound(SHT_Audio.SoundList.titleMove);
                end
                SHTEntry.bigWinTitle:GetChild(index).gameObject:SetActive(true);
            end
        end
        SHTEntry.winBigNum.text = SHTEntry.ShowText(self.currentRunGold);
    end);
    self.BigwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        --SHT_Audio.PlaySound(SHT_Audio.SoundList.Coin);
        SHTEntry.winBigNum.text = SHTEntry.ShowText(SHTEntry.ResultData.WinScore);
        SHTEntry.ChangeGold(SHTEntry.myGold);
        self.BigwinTweener = Util.RunWinScore(0, 1, 1, nil);
        self.BigwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            SHTEntry.bigEffect.gameObject:SetActive(false);
            self.CheckFree();
        end);
    end);

    SHTEntry.closebigBtn.onClick:RemoveAllListeners();
    SHTEntry.closebigBtn.interactable = true;
    SHTEntry.closebigBtn.onClick:AddListener(function()
        -- SHT_Audio.PlaySound(SHT_Audio.SoundList.BTN);
        -- SHT_Audio.ClearAuido(SHT_Audio.SoundList.BigJB);
        -- SHT_Audio.ClearAuido(SHT_Audio.SoundList.BigWin2);
        SHTEntry.ChangeGold(SHTEntry.myGold);
        SHTEntry.closebigBtn.interactable = false;
        if self.BigwinTweener ~= nil then
            self.BigwinTweener:Kill();
        end
        index = SHTEntry.bigWinTitle.childCount;
        for i = 1, SHTEntry.bigWinTitle.childCount do
            SHTEntry.bigWinTitle:GetChild(i - 1).gameObject:SetActive(false);
        end
        SHTEntry.bigWinTitle:GetChild(index-1).gameObject:SetActive(true);
        SHTEntry.bigProgress.fillAmount = 1;
        SHTEntry.winBigNum.text = SHTEntry.ShowText(SHTEntry.ResultData.WinScore);
        Util.RunWinScore(0, 1, 0.5, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            SHTEntry.bigEffect.gameObject:SetActive(false);
            self.CheckFree();
        end);
    end);


end


function SHT_Result.ShowBig()
    --高分
    if self.isShowBig then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= SHTEntry.ResultData.WinScore then
            self.currentRunGold = SHTEntry.ResultData.WinScore;
        end
        SHTEntry.winBigNum.text = SHTEntry.ShowText(self.currentRunGold);
        if self.currentRunProgress < 3 then
            SHTEntry.bigProgress.value = (self.currentRunGold / SHTEntry.ResultData.WinScore) * 5 - self.currentRunProgress;
        end
        if SHTEntry.bigProgress.value >= 1 and self.currentRunProgress < 2 then
            SHTEntry.bigProgress.value = 0;
            --TODO 音效
            SHT_Audio.PlaySound(SHT_Audio.SoundList.bigWin, SHT_DataConfig.winBigGoldChangeRate / 3);
            self.currentRunProgress = self.currentRunProgress + 1;
            if self.currentRunProgress == 1 then
                SHTEntry.bigDJJY:SetActive(false);
                SHTEntry.bigFJYF:SetActive(true);
                SHTEntry.bigTXWS:SetActive(false);
            elseif self.currentRunProgress == 2 then
                SHTEntry.bigDJJY:SetActive(false);
                SHTEntry.bigFJYF:SetActive(false);
                SHTEntry.bigTXWS:SetActive(true);
            end
        end
        if self.timer >= SHT_DataConfig.winBigGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function SHT_Result.ShowNormalEffect()
    --普通奖动画
    SHTEntry.winNormalNum.gameObject:SetActive(false)
    SHTEntry.winNormalEffect:Find("Image").transform.localPosition=Vector3.New(0,-250,0)
    SHTEntry.winLZPos.gameObject:SetActive(false)
    SHTEntry.winNormalEffect.gameObject:SetActive(true);
    local tb = {}
    for i=1,5 do
        local clie=newObject(SHTEntry.winclie.gameObject)
        clie.transform:SetParent(SHTEntry.winNormalEffect:Find("Group"):GetChild(i-1))
        clie.transform.localScale=Vector3.New(1,1,1)
        clie:SetActive(true)
        table.insert(tb,i,clie)
    end
    for i=1,SHTEntry.winNormalEffect:Find("Group").childCount do
        SHTEntry.winNormalEffect:Find("Group"):GetChild(i-1):GetChild(0):DOLocalMove(Vector3.New(0,0,0),0.8,false):SetEase(DG.Tweening.Ease.Linear)
    end
    local tweener = SHTEntry.winNormalEffect:Find("Image").transform:DOLocalMove(Vector3.New(0,-150,0), 0.8, false);
    tweener:OnComplete(function()
        SHT_Audio.PlaySound(SHT_Audio.SoundList.moneySmallWin);
        SHTEntry.winNormalNum.gameObject:SetActive(true)
        self.timer = 0;
        self.currentRunGold = 0;
        SHTEntry.winNormalNum.text = SHTEntry.ShowText(self.currentRunGold);
        SHTEntry.winNormalNum.gameObject:SetActive(true);
        SHT_Audio.PlaySound(SHT_Audio.SoundList.moneyAdd);
        self.winNormalTweener = Util.RunWinScore(0, SHTEntry.ResultData.WinScore, 2, function(value)
            self.currentRunGold = math.floor(value);
            SHTEntry.winNormalNum.text = SHTEntry.ShowText(self.currentRunGold);
        end);
        self.winNormalTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            SHTEntry.winNormalNum.text = SHTEntry.ShowText(SHTEntry.ResultData.WinScore);
            SHTEntry.ChangeGold(SHTEntry.myGold);
            SHTEntry.winLZPos.gameObject:SetActive(true)
            for i=1,5 do
                tb[i].transform:SetParent(SHTEntry.winLZPos)
                tb[i].transform.localScale=Vector3.New(1,1,1)
                tb[i].transform:DOLocalMove(Vector3.New(0,0,0), (0.3+0.1*i)):SetEase(DG.Tweening.Ease.Linear):OnComplete(function ()
                    destroy(tb[i].transform.gameObject)
                    SHTEntry.winLZPos:GetChild(0).gameObject:SetActive(true)
                    if i==1 then
                        SHT_Audio.PlaySound(SHT_Audio.SoundList.goldToGround, SHT_DataConfig.winGoldChangeRate);  
                    end
                    if i==5 then
                        self.winNormalTweener = Util.RunWinScore(0, 1, 1, nil);
                        self.winNormalTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                            SHTEntry.winNormalEffect.gameObject:SetActive(false);
                            SHTEntry.winLZPos.gameObject:SetActive(false)
                            self.CheckFree();
                        end);
                    end
                end);
            end
        end);
    end)
end
function SHT_Result.ShowNormal()
    --普通奖
    if self.isShowNormal then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= SHTEntry.ResultData.WinScore then
            self.currentRunGold = SHTEntry.ResultData.WinScore;
        end
        SHTEntry.winNormalNum.text = SHTEntry.ShowText(self.currentRunGold);
        if self.timer >= SHT_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function SHT_Result.HideNormal()
    --隐藏中奖
    if self.isHideNormal then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= self.hideNormalTime then
            --等待退出动画时长
            self.isHideNormal = false;
            SHTEntry.winNormalEffect.gameObject:SetActive(false);
            self.CheckFree();
        end
    end
end