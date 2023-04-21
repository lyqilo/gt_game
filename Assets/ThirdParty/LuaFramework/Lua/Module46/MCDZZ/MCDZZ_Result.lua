MCDZZ_Result = {};

local self = MCDZZ_Result;

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

function MCDZZ_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = false;
    self.isPause = false;
    self.isFreeGame = false;
end
function MCDZZ_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = true;
    MCDZZEntry.myGold = TableUserInfo._7wGold;
    MCDZZEntry.WinNum.text = MCDZZEntry.ShowText(tostring(MCDZZEntry.ResultData.WinScore));
    self.isClickShouFen = false;
    MCDZZEntry.CSGroup:GetComponent("Image").enabled=true

    --其他正常模式
    local showResultCall = function()
        --先做免费的操作
        if MCDZZEntry.isFreeGame then
            self.freeGold = self.freeGold + MCDZZEntry.ResultData.WinScore;
            log("免费累计获得：" .. self.freeGold);
        end
        if MCDZZEntry.ResultData.WinScore > 0 then
            MCDZZEntry.CSGroup.gameObject:SetActive(false)
            MCDZZ_Line.Show()
            if MCDZZEntry.ResultData.m_nWinPeiLv < 4 * MCDZZ_DataConfig.ALLLINECOUNT then
                --低奖
                self.ShowNormalEffect();
             elseif MCDZZEntry.ResultData.m_nWinPeiLv >= 4 * MCDZZ_DataConfig.ALLLINECOUNT and MCDZZEntry.ResultData.m_nWinPeiLv < 8 * MCDZZ_DataConfig.ALLLINECOUNT then
                 --接近完美
                self.ShowBangEffect()
            elseif MCDZZEntry.ResultData.m_nWinPeiLv >= 8 * MCDZZ_DataConfig.ALLLINECOUNT then
                --展示有翅膀的动画
                self.ShowBigEffect();
            end
        else
            self.nowin = true;
            local rd = math.random(2, #MCDZZ_DataConfig.WinConfig);
            MCDZZEntry.TipText.text = MCDZZ_DataConfig.WinConfig[rd];
            MCDZZEntry.ChangeGold(MCDZZEntry.myGold);
        end
    end
    coroutine.stop(showResultCall);
    coroutine.start(showResultCall);
end
function MCDZZ_Result.CheckFree()
    logYellow("检查是否中免费")
    if not MCDZZEntry.isFreeGame then
        MCDZZEntry.isRoll = false;
        if MCDZZEntry.ResultData.FreeCount > 0 then
            --中免费了
            self.freeGold = 0;
            MCDZZEntry.isFreeGame = true;
            self.isFreeGame = true;
            MCDZZEntry.addChipBtn.interactable = false;
            MCDZZEntry.reduceChipBtn.interactable = false;
            MCDZZEntry.BigBtn.interactable = false;
            self.ShowFreeEffect();
        else
            MCDZZEntry.FreeRoll();
        end
    else
        MCDZZEntry.isRoll = false;
        if self.isFreeGame and MCDZZEntry.ResultData.FreeCount <= 0 then
            self.isFreeGame = false;
            self.ShowCSJLResultEffect();--免费结束结算
        else
            MCDZZEntry.FreeRoll();
        end
    end
end
function MCDZZ_Result.HideResult()
    for i = 1, MCDZZEntry.resultEffect.childCount do
        MCDZZEntry.resultEffect:GetChild(i - 1).gameObject:SetActive(false);
    end
    self.showCSJLCallback = nil;
    self.showResultCallback = nil;

end
function MCDZZ_Result.QuickOver(type)
    if self.isClickShouFen then
        return ;
    end
    self.isClickShouFen = true;
    self.currentRunGold = MCDZZEntry.ResultData.WinScore;
    if type == 1 then
        --很棒
        MCDZZEntry.greatProgress.value = 1;
        MCDZZEntry.winGreatNum.text = MCDZZEntry.ShowText(MCDZZEntry.ResultData.WinScore);
        if self.isShowCYGG then
            self.timer = MCDZZ_DataConfig.winGoldChangeRate - 0.5;
        end
    elseif type == 2 then
        --非常棒
        MCDZZEntry.goodProgress.value = 1;
        MCDZZEntry.winGoodNum.text = MCDZZEntry.ShowText(MCDZZEntry.ResultData.WinScore);
        if self.isShowJYMT then
            self.timer = MCDZZ_DataConfig.winGoldChangeRate - 0.5;
        end
    elseif type == 3 then
        --接近完美
        MCDZZEntry.prefectProgress.value = 1;
        MCDZZEntry.winPerfectNum.text = MCDZZEntry.ShowText(MCDZZEntry.ResultData.WinScore);
        if self.isShowPrefect then
            self.timer = MCDZZ_DataConfig.winGoldChangeRate - 0.5;
        end
    elseif type == 4 then
        --高分
        MCDZZEntry.bigProgress.value = 1;
        MCDZZEntry.winBigNum.text = MCDZZEntry.ShowText(MCDZZEntry.ResultData.WinScore);
        MCDZZEntry.bigDJJY:SetActive(false);
        MCDZZEntry.bigFJYF:SetActive(false);
        MCDZZEntry.bigTXWS:SetActive(true);
        if self.isShowBig then
            self.timer = MCDZZ_DataConfig.winGoldChangeRate * 3 - 0.5;
        end
    elseif type == 5 then
        --高分
        MCDZZEntry.BangProgress.value = 1;
        MCDZZEntry.winBangNum.text = MCDZZEntry.ShowText(MCDZZEntry.ResultData.WinScore);
        MCDZZEntry.BangDJJY:SetActive(false);
        MCDZZEntry.BangFJYF:SetActive(false);
        MCDZZEntry.BangTXWS:SetActive(true);
        if self.isShowBang then
            self.timer = MCDZZ_DataConfig.winGoldChangeRate * 3 - 0.5;
        end
    end
    MCDZZEntry.ChangeGold(MCDZZEntry.myGold);
end
function MCDZZ_Result.Update()
    if self.isPause then
        return ;
    end
    self.ShowCSJL();
    self.WaitRollAgainCSJL();

    self.ShowCSJLResult();
    self.ShowCYGG();
    self.ShowJYMT();
    self.ShowPrefect();
    self.ShowBang()
    self.ShowBig();
    self.ShowNormal();
    self.HideNormal();

    self.ShowFree();
    self.HideFree();

    self.NoWinWait();
end

function MCDZZ_Result.NoWinWait()
    if self.nowin then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= MCDZZ_DataConfig.autoNoRewardInterval then
            self.nowin = false;
            self.CheckFree();
        end
    end
end
----------------------财神--------------------------------
function MCDZZ_Result.WaitRollAgainCSJL()
    --财神重转
    if self.waitNextCSJL then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= MCDZZ_DataConfig.autoNoRewardInterval then
            self.waitNextCSJL = false;
            if self.showCSJLCallback ~= nil then
                self.showCSJLCallback();
            end
        end
    end
end
function MCDZZ_Result.ShowCSJLEffect()
    --财神展示动画
    MCDZZ_Audio.PlayBGM(MCDZZ_Audio.SoundList.CSJLBGM);
    MCDZZEntry.CSJLEffect.gameObject:SetActive(true);
    MCDZZEntry.CSJLEffect.AnimationState:SetAnimation(0, "animation", true);
    MCDZZEntry.CSGroup.gameObject:SetActive(true);
    for i = 1, #MCDZZEntry.ResultData.ImgTable do
        if MCDZZEntry.ResultData.ImgTable[i] == 0 then
            local column = math.floor(i / 5);--排
            local raw = i % 5;--列
            if raw == 0 then
                raw = 5;
                column = column - 1;
            end
            MCDZZEntry.CSGroup:GetChild(raw - 1):GetChild(column).gameObject:SetActive(true);
        end
    end
    self.showCSJLCallback = function()
        MCDZZEntry.CSJLRoll();
    end;
    self.isShowCSJL = true;
end
function MCDZZ_Result.ShowCSJL()
    --财神展示
    if self.isShowCSJL then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= MCDZZ_DataConfig.smallGameLoadingShowTime then
            MCDZZEntry.CSJLEffect.gameObject:SetActive(false);
            if self.showCSJLCallback ~= nil then
                self.showCSJLCallback();
            end
            self.isShowCSJL = false;
        end
    end
end
------------------------免费或者小游戏结束---------------------------
function MCDZZ_Result.ShowCSJLResultEffect()
    self.spGameGold = self.freeGold;
    MCDZZEntry.smallEffect.transform.localScale = Vector3.New(0, 0, 0);
    MCDZZEntry.winSmallEffectNum.text = MCDZZEntry.ShowText("0");
    MCDZZEntry.smallEffect.gameObject:SetActive(true);
    local showeffect = function()
        self.timer = 0;
        self.currentRunGold = 0;
        self.currentRunProgress = 0;
        self.hideFreeTime=5
        self.winRate = math.ceil(self.spGameGold / (MCDZZ_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        MCDZZEntry.freeOverTime.text=ShowRichText(self.hideFreeTime)
        self.showResultCallback = function()
            log("关闭小游戏结果")
            MCDZZEntry.ChangeGold(MCDZZEntry.myGold);
            self.timer = 0;
            self.isShowCSJLResult = false;
            coroutine.start(function()
                MCDZZEntry.smallEffect:DOScale(Vector3.New(0, 0, 0), 0.3):OnComplete(function()
                    MCDZZEntry.smallEffect.gameObject:SetActive(false);
                    MCDZZEntry.isFreeGame = false;
                    self.freeGold = 0;
                    self.CheckFree();
                end);
            end);
        end
        MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.moneyAdd);
        self.isShowCSJLResult = true;
    end
    MCDZZEntry.smallEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);
end
function MCDZZ_Result.ShowCSJLResult()
    --展示财神降临结果
    if self.isShowCSJLResult then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= self.spGameGold then
            self.currentRunGold = self.spGameGold;
        end
        MCDZZEntry.winSmallEffectNum.text = MCDZZEntry.ShowText(self.currentRunGold);
        if self.timer >= 5 then
            self.timer =5
        end
        MCDZZEntry.freeOverTime.text=ShowRichText(string.format("%.1f",(self.hideFreeTime-self.timer)))
        if self.timer >= self.hideFreeTime then
            self.isShowCSJLResult = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function MCDZZ_Result.ShowFreeEffect()
    --展示免费
    --TODO 将scatter动画替换为中奖动画
    self.timer = 0;
    self.hideFreeTime=5
    MCDZZ_Audio.PlayBGM(MCDZZ_Audio.SoundList.GuoChang);
    self.showResultCallback = function()
        self.timer = 0;
        self.isHideFree = true;
        MCDZZEntry.addChipBtn.interactable = false;
        MCDZZEntry.reduceChipBtn.interactable = false;
        MCDZZEntry.BigBtn.interactable = false;
        MCDZZEntry.FreeCountText.text=ShowRichText(tostring(MCDZZEntry.freeCount))
        MCDZZEntry.freedownTime.text=ShowRichText(string.format("%.1f",self.hideFreeTime))
        MCDZZEntry.EnterFreeEffect.gameObject:SetActive(true);
        MCDZZ_Line.Close();
        MCDZZ_Audio.PlayBGM(MCDZZ_Audio.SoundList.freeGameBg);
    end
    self.isShowFree = true;
end
function MCDZZ_Result.ShowFree()
    if self.isShowFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= MCDZZ_DataConfig.freeLoadingShowTime then
            self.isShowFree = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function MCDZZ_Result.HideFree()
    --隐藏中奖
    if self.isHideFree then
        self.timer = self.timer + Time.deltaTime;
        MCDZZEntry.freedownTime.text= ShowRichText(string.format("%.1f",(self.hideFreeTime-self.timer)))
        if self.timer >= self.hideFreeTime then
            MCDZZEntry.freedownTime.text=ShowRichText(0)
            --等待退出动画时长
            self.isHideFree = false;
            MCDZZEntry.EnterFreeEffect.gameObject:SetActive(false);
            MCDZZEntry.FreeRoll();
        end

    end
end
---------------------中奖---------------------
function MCDZZ_Result.ShowCYGGEffect()
    --很棒动画
    log("很棒");
    MCDZZEntry.greatEffect.transform.localScale = Vector3.New(0, 0, 0);
    MCDZZEntry.winGreatNum.text = MCDZZEntry.ShowText("0");
    MCDZZEntry.greatProgress.value = 0;
    MCDZZEntry.greatEffect.gameObject:SetActive(true);
    local showeffect = function()
        log("很棒动画");
        self.timer = 0;
        self.currentRunGold = 0;
        self.currentRunProgress = 0;
        self.winRate = math.ceil(MCDZZEntry.ResultData.WinScore / (MCDZZ_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        self.progressRate = math.ceil(1 / (MCDZZ_DataConfig.winGoldChangeRate / Time.deltaTime));
        MCDZZEntry.greatEffect.transform:Find("Group"):GetComponent("CanvasGroup"):DOFade(0, 0.8);
        self.showResultCallback = function()
            self.isShowCYGG = false;
            self.timer = 0;
            MCDZZEntry.ChangeGold(MCDZZEntry.myGold);
            coroutine.start(function()
                coroutine.wait(0.5);
                MCDZZEntry.greatEffect:DOScale(Vector3.New(0, 0, 0), 0.3):OnComplete(function()
                    MCDZZEntry.greatEffect.gameObject:SetActive(false);
                    self.CheckFree();
                end);
            end);
        end
        MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.bigWin, MCDZZ_DataConfig.winGoldChangeRate);
        self.isShowCYGG = true;
    end
    MCDZZEntry.greatEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);
end
function MCDZZ_Result.ShowCYGG()
    --很棒跑分
    if self.isShowCYGG then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= MCDZZEntry.ResultData.WinScore then
            self.currentRunGold = MCDZZEntry.ResultData.WinScore;
        end
        MCDZZEntry.winGreatNum.text = MCDZZEntry.ShowText(self.currentRunGold);
        MCDZZEntry.greatProgress.value = self.currentRunGold / MCDZZEntry.ResultData.WinScore;
        if self.timer >= MCDZZ_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function MCDZZ_Result.ShowJYMTEffect()
    --非常棒动画
    log("非常棒");
    MCDZZEntry.goodEffect.transform.localScale = Vector3.New(0, 0, 0);
    MCDZZEntry.winGoodNum.text = MCDZZEntry.ShowText("0");
    MCDZZEntry.goodProgress.value = 0;
    MCDZZEntry.goodEffect.gameObject:SetActive(true);
    local showeffect = function()
        log("非常棒动画");
        self.timer = 0;
        self.currentRunGold = 0;
        self.currentRunProgress = 0;
        self.winRate = math.ceil(MCDZZEntry.ResultData.WinScore / (MCDZZ_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        self.progressRate = math.ceil(1 / (MCDZZ_DataConfig.winGoldChangeRate / Time.deltaTime));
        MCDZZEntry.goodEffect.transform:Find("Group"):GetComponent("CanvasGroup"):DOFade(0, 0.8);
        self.showResultCallback = function()
            MCDZZEntry.ChangeGold(MCDZZEntry.myGold);
            self.timer = 0;
            self.isShowJYMT = false;
            coroutine.start(function()
                coroutine.wait(0.5);
                MCDZZEntry.goodEffect:DOScale(Vector3.New(0, 0, 0), 0.3):OnComplete(function()
                    MCDZZEntry.goodEffect.gameObject:SetActive(false);
                    self.CheckFree();
                end);
            end);
        end
        MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.bigWin, MCDZZ_DataConfig.winGoldChangeRate);
        self.isShowJYMT = true;
        log("非常棒动画开始");
    end
    MCDZZEntry.goodEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);
end
function MCDZZ_Result.ShowJYMT()
    --金玉满堂
    if self.isShowJYMT then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= MCDZZEntry.ResultData.WinScore then
            self.currentRunGold = MCDZZEntry.ResultData.WinScore;
        end
        MCDZZEntry.winGoodNum.text = MCDZZEntry.ShowText(self.currentRunGold);
        MCDZZEntry.goodProgress.value = self.currentRunGold / MCDZZEntry.ResultData.WinScore;
        if self.timer >= MCDZZ_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function MCDZZ_Result.ShowPrefectEffect()
    --接近完美动画
    MCDZZEntry.perfectEffect.transform.localScale = Vector3.New(0, 0, 0);
    MCDZZEntry.winPerfectNum.text = MCDZZEntry.ShowText("0");
    MCDZZEntry.prefectProgress.value = 0;
    local showeffect = function()
        self.timer = 0;
        self.currentRunGold = 0;
        self.currentRunProgress = 0;
        self.winRate = math.ceil(MCDZZEntry.ResultData.WinScore / (MCDZZ_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        MCDZZEntry.perfectEffect.transform:Find("Group"):GetComponent("CanvasGroup"):DOFade(0, 0.8);
        self.showResultCallback = function()
            MCDZZEntry.ChangeGold(MCDZZEntry.myGold);
            self.timer = 0;
            self.isShowPrefect = false;
            coroutine.start(function()
                coroutine.wait(0.5);
                MCDZZEntry.perfectEffect:DOScale(Vector3.New(0, 0, 0), 0.3):OnComplete(function()
                    MCDZZEntry.perfectEffect.gameObject:SetActive(false);
                    self.CheckFree();
                end);
            end);
        end
        MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.bigWin, MCDZZ_DataConfig.winGoldChangeRate);
        MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.goldToGround, MCDZZ_DataConfig.winGoldChangeRate);

        self.isShowPrefect = true;
        MCDZZEntry.isRoll = false;
    end
    MCDZZEntry.perfectEffect.gameObject:SetActive(true);
    MCDZZEntry.perfectEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);
end
function MCDZZ_Result.ShowPrefect()
    --接近完美
    if self.isShowPrefect then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= MCDZZEntry.ResultData.WinScore then
            self.currentRunGold = MCDZZEntry.ResultData.WinScore;
        end
        MCDZZEntry.winPerfectNum.text = MCDZZEntry.ShowText(self.currentRunGold);
        MCDZZEntry.prefectProgress.value = self.currentRunGold / MCDZZEntry.ResultData.WinScore;
        if self.timer >= MCDZZ_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function MCDZZ_Result.ShowBangEffect()
    --bang
    logYellow("棒棒棒棒棒棒")
    MCDZZEntry.BangEffect.transform.localScale = Vector3.New(0, 0, 0);
    MCDZZEntry.winBangNum.text = MCDZZEntry.ShowText("0");
    MCDZZEntry.BangDJJY:SetActive(true);
    MCDZZEntry.BangEffect:Find("Content/Slider/Fill Area/Fill"):GetComponent("Image").sprite = MCDZZEntry.BangImages.transform:GetChild(0):GetComponent("Image").sprite
    MCDZZEntry.BangFJYF:SetActive(false);
    MCDZZEntry.BangTXWS:SetActive(false);
    MCDZZEntry.BangProgress.value = 0;
    local showeffect = function()
        self.timer = 0;
        self.currentRunGold = 0;
        self.currentRunProgress = 0;
        MCDZZEntry.BangEffect.transform:Find("Group"):GetComponent("CanvasGroup"):DOFade(0, 0.8);
        self.winRate = math.ceil(MCDZZEntry.ResultData.WinScore / (MCDZZ_DataConfig.winBigGoldChangeRate * 3 / Time.deltaTime)) * 4;
        self.showResultCallback = function()
            MCDZZEntry.ChangeGold(MCDZZEntry.myGold);
            self.timer = 0;
            self.isShowBang = false;
            coroutine.start(function()
                coroutine.wait(0.5);
                MCDZZEntry.BangEffect.gameObject:SetActive(false);
                MCDZZEntry.BangEffect:DOScale(Vector3.New(0, 0, 0), 0.3):OnComplete(function()
                    self.CheckFree();
                end);
            end);
        end
        MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.bigWin3);
        self.isShowBang = true;
    end
    
    MCDZZEntry.BangEffect.gameObject:SetActive(true);
    MCDZZEntry.BangEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);
end


function MCDZZ_Result.ShowBang()
    --bang
    if self.isShowBang then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= MCDZZEntry.ResultData.WinScore then
            self.currentRunGold = MCDZZEntry.ResultData.WinScore;
        end
        MCDZZEntry.winBangNum.text = MCDZZEntry.ShowText(self.currentRunGold);
        if self.currentRunProgress < 3 then
            MCDZZEntry.BangProgress.value = (self.currentRunGold / MCDZZEntry.ResultData.WinScore) * 5 - self.currentRunProgress;
        end
        if MCDZZEntry.BangProgress.value >= 1 and self.currentRunProgress < 2 then
            MCDZZEntry.BangProgress.value = 0;
            --TODO 音效
            self.currentRunProgress = self.currentRunProgress + 1;
            if self.currentRunProgress == 1 then
                MCDZZEntry.BangEffect:Find("Content/Slider/Fill Area/Fill"):GetComponent("Image").sprite = MCDZZEntry.BangImages.transform:GetChild(1):GetComponent("Image").sprite
                MCDZZEntry.BangDJJY:SetActive(false);
                MCDZZEntry.BangFJYF:SetActive(true);
                MCDZZEntry.BangTXWS:SetActive(false);

            elseif self.currentRunProgress == 2 then
                MCDZZEntry.BangEffect:Find("Content/Slider/Fill Area/Fill"):GetComponent("Image").sprite = MCDZZEntry.BangImages.transform:GetChild(2):GetComponent("Image").sprite
                MCDZZEntry.BangDJJY:SetActive(false);
                MCDZZEntry.BangFJYF:SetActive(false);
                MCDZZEntry.BangTXWS:SetActive(true);
            end
        end
        if self.timer >= MCDZZ_DataConfig.winBigGoldChangeRate then
            if self.showResultCallback ~= nil then
                MCDZZEntry.winBangNum.text = MCDZZEntry.ShowText(MCDZZEntry.ResultData.WinScore);
                self.showResultCallback();
            end
        end
    end
end


-- function MCDZZ_Result.ShowBigWinffect()
--     --Super奖动画
--     MCDZZEntry.bigEffect.gameObject:SetActive(true);
--     self.timer = 0;
--     self.currentRunGold = 0;
--     MCDZZEntry.winBigNum.text = MCDZZEntry.ShowText(self.currentRunGold);
--     MCDZZEntry.winBigNum.gameObject:SetActive(true);

--     -- for i = 1, MCDZZEntry.bigWinTitle.childCount do
--     --     MCDZZEntry.bigWinTitle:GetChild(i - 1).gameObject:SetActive(false);
--     -- end
    
--     local index = 0;
--     local skipBtn = MCDZZEntry.bigEffect:Find("SkipBtn"):GetComponent("Button");
--     MCDZZEntry.bigWinProgress.fillAmount = 0;
--     MCDZZEntry.bigWinTitle:GetChild(index).gameObject:SetActive(true);
--     FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BigJB);
--     FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BigWin2);
--     self.bigwinTweener = Util.RunWinScore(0, MCDZZEntry.ResultData.WinScore, 14, function(value)
--         self.currentRunGold = Mathf.Ceil(value);
--         local remain = (self.currentRunGold - index * (MCDZZEntry.ResultData.WinScore / 8)) / (MCDZZEntry.ResultData.WinScore / 8);
--         MCDZZEntry.bigWinProgress.fillAmount = remain;
--         if remain >= 1 then
--             if index < 7 then
--                 MCDZZEntry.bigWinTitle:GetChild(index).gameObject:SetActive(false);
--                 index = index + 1;
--                 MCDZZEntry.bigWinTitle:GetChild(index).gameObject:SetActive(true);
--                 MCDZZEntry.bigWinProgress.fillAmount = 0;
--             end
--         end
--         MCDZZEntry.winBigNum.text = MCDZZEntry.ShowText(self.currentRunGold);
--     end);
--     self.bigwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
--         FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.Coin);
--         MCDZZEntry.SetSelfGold(MCDZZEntry.myGold);
--         self.bigwinTweener = Util.RunWinScore(0, 1, 1, nil);
--         self.bigwinTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
--             MCDZZEntry.bigEffect.gameObject:SetActive(false);
--             self.CheckFree();
--         end);
--     end);

--     skipBtn.onClick:RemoveAllListeners();
--     skipBtn.interactable = true;
--     skipBtn.onClick:AddListener(function()
--         FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
--         FXGZ_Audio.ClearAuido(FXGZ_Audio.SoundList.BigJB);
--         FXGZ_Audio.ClearAuido(FXGZ_Audio.SoundList.BigWin2);
--         MCDZZEntry.SetSelfGold(MCDZZEntry.myGold);
--         skipBtn.interactable = false;
--         if self.bigwinTweener ~= nil then
--             self.bigwinTweener:Kill();
--         end
--         index = 7;
--         for i = 1, MCDZZEntry.bigWinTitle.childCount do
--             MCDZZEntry.bigWinTitle:GetChild(i - 1).gameObject:SetActive(false);
--         end
--         MCDZZEntry.bigWinTitle:GetChild(index).gameObject:SetActive(true);
--         MCDZZEntry.bigWinProgress.fillAmount = 1;
--         MCDZZEntry.winBigNum.text = MCDZZEntry.ShowText(MCDZZEntry.ResultData.WinScore);
--         Util.RunWinScore(0, 1, 0.5, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
--             MCDZZEntry.bigEffect.gameObject:SetActive(false);
--             self.CheckFree();
--         end);
--     end);
-- end

function MCDZZ_Result.ShowBigEffect()
    --大分动画
    MCDZZEntry.bigEffect.transform.localScale = Vector3.New(0, 0, 0);
    MCDZZEntry.winBigNum.text = MCDZZEntry.ShowText("0");
    MCDZZEntry.bigEffect:Find("Content/Slider/Fill Area/Fill"):GetComponent("Image").sprite = MCDZZEntry.bigImages.transform:GetChild(0):GetComponent("Image").sprite
    MCDZZEntry.bigRJDJ:SetActive(true);
    MCDZZEntry.bigDJJY:SetActive(false);
    MCDZZEntry.bigYCWG:SetActive(false);
    MCDZZEntry.bigFJYF:SetActive(false);
    MCDZZEntry.bigTXWS:SetActive(false);
    MCDZZEntry.bigProgress.value = 0;

    local showeffect = function()
        self.timer = 0;
        self.currentRunGold = 0;
        self.currentRunProgress = 0;
        MCDZZEntry.bigEffect.transform:Find("Group"):GetComponent("CanvasGroup"):DOFade(0, 0.8);
        self.winRate = math.ceil(MCDZZEntry.ResultData.WinScore / (MCDZZ_DataConfig.winBigGoldChangeRate * 4 / Time.deltaTime)) * 3;
        self.showResultCallback = function()
            MCDZZEntry.ChangeGold(MCDZZEntry.myGold);
            self.timer = 0;
            self.isShowBig = false;
            coroutine.start(function()
                coroutine.wait(0.5);
                MCDZZEntry.bigEffect.gameObject:SetActive(false);
                MCDZZEntry.bigEffect:DOScale(Vector3.New(0, 0, 0), 0.3):OnComplete(function()
                    self.CheckFree();
                end);
            end);
        end

        MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.bigWin3);
        self.isShowBig = true;
    end
    MCDZZEntry.bigEffect.gameObject:SetActive(true);
    MCDZZEntry.bigEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);
end


function MCDZZ_Result.ShowBig()
    --高分
    if self.isShowBig then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= MCDZZEntry.ResultData.WinScore then
            self.currentRunGold = MCDZZEntry.ResultData.WinScore;
        end
        MCDZZEntry.winBigNum.text = MCDZZEntry.ShowText(self.currentRunGold);
        if self.currentRunProgress < 5 then
            MCDZZEntry.bigProgress.value = (self.currentRunGold / MCDZZEntry.ResultData.WinScore) * 7 - self.currentRunProgress;
        else
            MCDZZEntry.bigProgress.value=1
        end
        if MCDZZEntry.bigProgress.value >= 1 and self.currentRunProgress < 5 then
            MCDZZEntry.bigProgress.value = 0;
            --TODO 音效
            --MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.bigWin, MCDZZ_DataConfig.winBigGoldChangeRate / 3);
            self.currentRunProgress = self.currentRunProgress + 1;
            if self.currentRunProgress == 1 then
                MCDZZEntry.bigEffect:Find("Content/Slider/Fill Area/Fill"):GetComponent("Image").sprite = MCDZZEntry.bigImages.transform:GetChild(1):GetComponent("Image").sprite
                MCDZZEntry.bigRJDJ:SetActive(false);
                MCDZZEntry.bigDJJY:SetActive(true);
                MCDZZEntry.bigYCWG:SetActive(false);
                MCDZZEntry.bigFJYF:SetActive(false);
                MCDZZEntry.bigTXWS:SetActive(false);
            elseif self.currentRunProgress == 2 then
                MCDZZEntry.bigEffect:Find("Content/Slider/Fill Area/Fill"):GetComponent("Image").sprite = MCDZZEntry.bigImages.transform:GetChild(2):GetComponent("Image").sprite
                MCDZZEntry.bigRJDJ:SetActive(false);
                MCDZZEntry.bigDJJY:SetActive(false);
                MCDZZEntry.bigYCWG:SetActive(true);
                MCDZZEntry.bigFJYF:SetActive(false);
                MCDZZEntry.bigTXWS:SetActive(false);
            elseif self.currentRunProgress == 3 then
                MCDZZEntry.bigEffect:Find("Content/Slider/Fill Area/Fill"):GetComponent("Image").sprite = MCDZZEntry.bigImages.transform:GetChild(3):GetComponent("Image").sprite
                MCDZZEntry.bigRJDJ:SetActive(false);
                MCDZZEntry.bigDJJY:SetActive(false);
                MCDZZEntry.bigYCWG:SetActive(false);
                MCDZZEntry.bigFJYF:SetActive(true);
                MCDZZEntry.bigTXWS:SetActive(false);
            elseif self.currentRunProgress == 4 then
                MCDZZEntry.bigEffect:Find("Content/Slider/Fill Area/Fill"):GetComponent("Image").sprite = MCDZZEntry.bigImages.transform:GetChild(4):GetComponent("Image").sprite
                MCDZZEntry.bigRJDJ:SetActive(false);
                MCDZZEntry.bigDJJY:SetActive(false);
                MCDZZEntry.bigYCWG:SetActive(false);
                MCDZZEntry.bigFJYF:SetActive(false);
                MCDZZEntry.bigTXWS:SetActive(true);
            end
        end
        if self.timer >= MCDZZ_DataConfig.winBigGoldChangeRate then
            if self.showResultCallback ~= nil then
                MCDZZEntry.winBigNum.text = MCDZZEntry.ShowText(MCDZZEntry.ResultData.WinScore);
                self.showResultCallback();
            end
        end
    end
end
function MCDZZ_Result.ShowNormalEffect()
    --普通奖动画
    MCDZZEntry.winNormalNum.gameObject:SetActive(false)
    MCDZZEntry.winNormalEffect:Find("Image").transform.localPosition=Vector3.New(0,-250,0)
    MCDZZEntry.winLZPos.gameObject:SetActive(false)
    MCDZZEntry.winNormalEffect.gameObject:SetActive(true);
    local tb = {}
    for i=1,5 do
        local clie=newObject(MCDZZEntry.winclie.gameObject)
        clie.transform:SetParent(MCDZZEntry.winclie)
        clie.transform.localScale=Vector3.New(1,1,1)
        clie.transform.localPosition=Vector3.New(0,0,0)
        clie.transform:SetParent(MCDZZEntry.winNormalEffect:Find("Group"):GetChild(i-1))
        clie.transform.localScale=Vector3.New(1,1,1)
        clie:SetActive(true)
        table.insert(tb,i,clie)
    end
    for i=1,MCDZZEntry.winNormalEffect:Find("Group").childCount do
        MCDZZEntry.winNormalEffect:Find("Group"):GetChild(i-1):GetChild(0):DOLocalMove(Vector3.New(0,0,0),0.6,false):SetEase(DG.Tweening.Ease.Linear)
    end
    local tweener = MCDZZEntry.winNormalEffect:Find("Image").transform:DOLocalMove(Vector3.New(0,-150,0), 0.6, false);
    tweener:OnComplete(function()
        --MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.goldToGround, MCDZZ_DataConfig.winGoldChangeRate);
        MCDZZEntry.winNormalNum.gameObject:SetActive(true)
        self.timer = 0;
        self.currentRunGold = 0;
        MCDZZEntry.winNormalNum.text = MCDZZEntry.ShowText(self.currentRunGold);
        MCDZZEntry.winNormalNum.gameObject:SetActive(true);
        MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.smallWin, MCDZZ_DataConfig.winGoldChangeRate);
        self.winNormalTweener = Util.RunWinScore(0, MCDZZEntry.ResultData.WinScore, 2, function(value)
            self.currentRunGold = math.floor(value);
            MCDZZEntry.winNormalNum.text = MCDZZEntry.ShowText(self.currentRunGold);
        end);
        self.winNormalTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            MCDZZEntry.winNormalNum.text = MCDZZEntry.ShowText(MCDZZEntry.ResultData.WinScore);
            MCDZZEntry.ChangeGold(MCDZZEntry.myGold);
            MCDZZEntry.winLZPos.gameObject:SetActive(true)
            for i=1,5 do
                tb[i].transform:SetParent(MCDZZEntry.winLZPos)
                tb[i].transform.localScale=Vector3.New(1,1,1)
                tb[i].transform:DOLocalMove(Vector3.New(0,0,0), (0.3+0.1*i)):SetEase(DG.Tweening.Ease.Linear):OnComplete(function ()
                    destroy(tb[i].transform.gameObject)
                    MCDZZEntry.winLZPos:GetChild(0).gameObject:SetActive(true)
                    if i==1 then
                        MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.goldToGround,MCDZZ_DataConfig.winGoldChangeRate);  
                    end
                    if i==5 then
                        self.winNormalTweener = Util.RunWinScore(0, 1, 1, nil);
                        self.winNormalTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                            MCDZZEntry.winNormalEffect.gameObject:SetActive(false);
                            MCDZZEntry.winLZPos.gameObject:SetActive(false)
                            self.CheckFree();
                        end);
                    end
                end);
            end
        end);
    end)
end
function MCDZZ_Result.ShowNormal()
    --普通奖
    if self.isShowNormal then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= MCDZZEntry.ResultData.WinScore then
            self.currentRunGold = MCDZZEntry.ResultData.WinScore;
        end
        MCDZZEntry.winNormalNum.text = MCDZZEntry.ShowText(self.currentRunGold);
        if self.timer >= MCDZZ_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function MCDZZ_Result.HideNormal()
    --隐藏中奖
    if self.isHideNormal then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= self.hideNormalTime then
            --等待退出动画时长
            self.isHideNormal = false;
            MCDZZEntry.winNormalEffect.gameObject:SetActive(false);
            self.CheckFree();
        end
    end
end