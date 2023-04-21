YGBH_Result = {};

local self = YGBH_Result;

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
self.hideFreeTime = 1;--免费动画退出时长
self.isClickShouFen = false;
self.spGameGold = 0;

function YGBH_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = false;
    self.isPause = false;
    self.isFreeGame = false;
end
function YGBH_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = true;
    YGBHEntry.myGold = TableUserInfo._7wGold;
    YGBHEntry.WinNum.text = tostring(YGBHEntry.ResultData.WinScore);
    self.isClickShouFen = false;

    --其他正常模式
    local showResultCall = function()
        --先做免费的操作
        if YGBHEntry.isFreeGame then
            self.freeGold = self.freeGold + YGBHEntry.ResultData.WinScore;
            log("免费累计获得：" .. self.freeGold);
            if YGBHEntry.ResultData.m_FreeType == 13 then
                --紫霞
                for i = #YGBHEntry.ResultData.m_nIconLie, 1, -1 do
                    local item = YGBHEntry.CSGroup:GetChild(i - 1):Find("Item").gameObject;
                    if YGBHEntry.ResultData.m_nIconLie[i] > 0 and not item.activeSelf then
                        item:SetActive(true);
                        coroutine.wait(0.1);
                    end
                end
            elseif YGBHEntry.ResultData.m_FreeType == 14 then
                --白晶晶
                for i = 1, YGBHEntry.bjjKuGroup.childCount do
                    YGBHEntry.bjjKuGroup:GetChild(i - 1).gameObject:SetActive(true);
                end
                YGBHEntry.bjjKuGroup.gameObject:SetActive(true);
                YGBH_Audio.PlaySound(YGBH_Audio.SoundList.KULOU);
                while YGBHEntry.bjjKuGroup:GetChild(0).gameObject.activeSelf do
                    coroutine.wait(0.1);
                end
                YGBHEntry.bjjKuGroup.gameObject:SetActive(false);
                YGBHEntry.bjjLightGroup.gameObject:SetActive(true);
                local ischanged = false;
                YGBH_Audio.PlaySound(YGBH_Audio.SoundList.BJJEFECT);
                for i = 1, #YGBHEntry.bjjList do
                    local child = YGBHEntry.bjjLightGroup:GetChild(i - 1);
                    --白晶晶光团移动
                    local pos = Vector3.New(YGBHEntry.bjjList[i][1], YGBHEntry.bjjList[i][2], YGBHEntry.bjjList[i][3]);
                    child:DOLocalMove(pos, 0.3):OnComplete(function()
                        child:DOScale(Vector3.New(5, 5, 5), 0.2):OnComplete(function()
                            if i == #YGBHEntry.bjjList then
                                ischanged = true;
                            end
                        end);
                    end);
                end
                while not ischanged do
                    coroutine.wait(0.1);
                end
                YGBH_Audio.PlaySound(YGBH_Audio.SoundList.FREESELECT);
                YGBHEntry.bjjLightGroup.gameObject:SetActive(false);
                for i = 1, YGBHEntry.bjjLightGroup.childCount do
                    YGBHEntry.bjjLightGroup:GetChild(i - 1).localPosition = Vector3.New(500, -500, 0);
                end
                ischanged = false;
                for i = 1, #YGBHEntry.bjjImgList do
                    local childImg = YGBHEntry.bjjImgList[i];
                    --光团移动完 图片切换
                    childImg.transform:DOScale(Vector3.New(0, 0, 0), 0.2):OnComplete(function()
                        childImg.sprite = YGBHEntry.icons:Find(YGBH_DataConfig.IconTable[14]):GetComponent("Image").sprite;
                        childImg.transform:DOScale(Vector3.New(1, 1, 1), 0.2):OnComplete(function()
                            if i == YGBHEntry.bjjLightGroup.childCount then
                                ischanged = true;
                            end
                        end);
                    end);
                end
                while not ischanged do
                    coroutine.wait(0.1);
                end
            else
            end
        end
        if YGBHEntry.ResultData.WinScore > 0 then
            YGBH_Line.Show()
            if YGBHEntry.ResultData.m_nWinPeiLv < 1 * YGBH_DataConfig.ALLLINECOUNT then
                --低奖
                self.ShowNormalEffect();
                -- elseif YGBHEntry.ResultData.m_nWinPeiLv == 1 * YGBH_DataConfig.ALLLINECOUNT  then
                --     --很棒
                --     self.ShowCYGGEffect();
            elseif YGBHEntry.ResultData.m_nWinPeiLv == 1 * YGBH_DataConfig.ALLLINECOUNT then
                --非常棒
                self.ShowJYMTEffect();
            elseif YGBHEntry.ResultData.m_nWinPeiLv > 1 * YGBH_DataConfig.ALLLINECOUNT and YGBHEntry.ResultData.m_nWinPeiLv < 2 * YGBH_DataConfig.ALLLINECOUNT then
                --接近完美
                self.ShowPrefectEffect();
            elseif YGBHEntry.ResultData.m_nWinPeiLv >= 2 * YGBH_DataConfig.ALLLINECOUNT then
                --展示有翅膀的动画
                self.ShowBigEffect();
            end
        else
            self.nowin = true;
            local rd = math.random(2, #YGBH_DataConfig.WinConfig);
            YGBHEntry.WinDesc.text = YGBH_DataConfig.WinConfig[rd];
            YGBHEntry.ChangeGold(YGBHEntry.myGold);
        end
    end
    coroutine.stop(showResultCall);
    coroutine.start(showResultCall);
end
function YGBH_Result.CheckFree()
    --检查是否中免费
    if YGBHEntry.FullSP then
        YGBHEntry.isSmallGame = true;
        YGBHEntry.OpenZP();
        YGBHEntry.isRoll = false;
        return ;
    end
    if not YGBHEntry.isFreeGame then
        YGBHEntry.isRoll = false;
        if YGBHEntry.ResultData.FreeCount > 0 then
            --中免费了
            self.freeGold = 0;
            YGBHEntry.isFreeGame = true;
            self.isFreeGame = true;
            YGBHEntry.addChipBtn.interactable = false;
            YGBHEntry.reduceChipBtn.interactable = false;
            YGBHEntry.MaxChipBtn.interactable = false;
            self.ShowFreeEffect();
        else
            YGBHEntry.FreeRoll();
        end
    else
        YGBHEntry.isRoll = false;
        if self.isFreeGame and YGBHEntry.ResultData.FreeCount <= 0 then
            self.isFreeGame = false;
            self.ShowCSJLResultEffect();--免费结束结算
        else
            YGBHEntry.FreeRoll();
        end
    end
end
function YGBH_Result.HideResult()
    for i = 1, YGBHEntry.resultEffect.childCount do
        YGBHEntry.resultEffect:GetChild(i - 1).gameObject:SetActive(false);
    end
    self.showCSJLCallback = nil;
    self.showResultCallback = nil;
end
function YGBH_Result.QuickOver(type)
    if self.isClickShouFen then
        return ;
    end
    self.isClickShouFen = true;
    self.currentRunGold = YGBHEntry.ResultData.WinScore;
    if type == 1 then
        --很棒
        if self.greatEffectTweener ~= nil then
            self.greatEffectTweener:Kill();
        end
        YGBHEntry.greatProgress.value = 1;
        YGBHEntry.winGreatNum.text = YGBHEntry.ShowText(YGBHEntry.ResultData.WinScore);
        self.StopGreatEffect();
    elseif type == 2 then
        --非常棒
        if self.goodEffectTweener ~= nil then
            self.goodEffectTweener:Kill();
        end
        YGBHEntry.goodProgress.value = 1;
        YGBHEntry.winGoodNum.text = YGBHEntry.ShowText(YGBHEntry.ResultData.WinScore);
        self.StopGoodEffect();
    elseif type == 3 then
        --接近完美
        if self.perfectEffectTweener ~= nil then
            self.perfectEffectTweener:Kill();
        end
        YGBHEntry.prefectProgress.value = 1;
        YGBHEntry.winPerfectNum.text = YGBHEntry.ShowText(YGBHEntry.ResultData.WinScore);
        self.StopPerfectEffect();
    elseif type == 4 then
        --高分
        if self.bigEffectTweener ~= nil then
            self.bigEffectTweener:Kill();
        end
        YGBHEntry.bigProgress.value = 1;
        YGBHEntry.winBigNum.text = YGBHEntry.ShowText(YGBHEntry.ResultData.WinScore);
        YGBHEntry.bigDJJY:SetActive(false);
        YGBHEntry.bigFJYF:SetActive(false);
        YGBHEntry.bigTXWS:SetActive(true);
        self.StopBigEffect();
        --if self.isShowBig then
        --    self.timer = YGBH_DataConfig.winGoldChangeRate * 3 - 0.5;
        --end
    end
    YGBHEntry.ChangeGold(YGBHEntry.myGold);
end
function YGBH_Result.Update()
    if self.isPause then
        return ;
    end
    self.ShowCSJL();
    self.WaitRollAgainCSJL();

    self.ShowCSJLResult();
    self.ShowCYGG();
    self.ShowJYMT();
    self.ShowPrefect();
    self.ShowBig();
    self.ShowNormal();
    self.HideNormal();

    self.ShowFree();
    self.HideFree();

    self.NoWinWait();
end

function YGBH_Result.NoWinWait()
    if self.nowin then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= YGBH_DataConfig.autoNoRewardInterval then
            self.nowin = false;
            self.CheckFree();
        end
    end
end
----------------------财神--------------------------------
function YGBH_Result.WaitRollAgainCSJL()
    --财神重转
    if self.waitNextCSJL then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= YGBH_DataConfig.autoNoRewardInterval then
            self.waitNextCSJL = false;
            if self.showCSJLCallback ~= nil then
                self.showCSJLCallback();
            end
        end
    end
end
function YGBH_Result.ShowCSJLEffect()
    --财神展示动画
    YGBH_Audio.PlayBGM(YGBH_Audio.SoundList.CSJLBGM);
    YGBHEntry.CSJLEffect.gameObject:SetActive(true);
    YGBHEntry.CSJLEffect.AnimationState:SetAnimation(0, "animation", true);
    YGBHEntry.CSGroup.gameObject:SetActive(true);
    for i = 1, #YGBHEntry.ResultData.ImgTable do
        if YGBHEntry.ResultData.ImgTable[i] == 0 then
            local column = math.floor(i / 5);--排
            local raw = i % 5;--列
            if raw == 0 then
                raw = 5;
                column = column - 1;
            end
            YGBHEntry.CSGroup:GetChild(raw - 1):GetChild(column).gameObject:SetActive(true);
        end
    end
    self.showCSJLCallback = function()
        YGBHEntry.CSJLRoll();
    end;
    self.isShowCSJL = true;
end
function YGBH_Result.ShowCSJL()
    --财神展示
    if self.isShowCSJL then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= YGBH_DataConfig.smallGameLoadingShowTime then
            YGBHEntry.CSJLEffect.gameObject:SetActive(false);
            if self.showCSJLCallback ~= nil then
                self.showCSJLCallback();
            end
            self.isShowCSJL = false;
        end
    end
end
------------------------免费或者小游戏结束---------------------------
function YGBH_Result.ShowCSJLResultEffect()
    if YGBHEntry.isSmallGame then
        self.spGameGold = YGBHEntry.SmallGameData.nGold;
    elseif YGBHEntry.isFreeGame then
        self.spGameGold = self.freeGold;
    end
    YGBHEntry.smallEffect.transform.localPosition = Vector3.New(0, -500, 0);
    YGBHEntry.smallEffect.transform.localScale = Vector3.New(0, 0, 0);
    YGBHEntry.winSmallEffectNum.text = YGBHEntry.ShowText("0");
    YGBHEntry.smallEffect.gameObject:SetActive(true);
    local showeffect = function()
        self.timer = 0;
        self.currentRunGold = 0;
        self.currentRunProgress = 0;
        local jbObj = YGBHEntry.smallEffect.transform:Find("JB");
        jbObj:DOScale(Vector3.New(1.5, 1.5, 1.5), 0.1):OnComplete(function()
            jbObj:DOScale(Vector3.New(1, 1, 1), 0.1);
        end);
        self.winRate = math.ceil(self.spGameGold / (YGBH_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        log("累计：" .. YGBHEntry.SmallGameData.nGold);
        self.showResultCallback = function()
            log("关闭小游戏结果")
            YGBHEntry.ChangeGold(YGBHEntry.myGold);
            self.timer = 0;
            self.isShowCSJLResult = false;
            YGBHEntry.FullSP = false;
            local issmall = YGBHEntry.isSmallGame;
            if YGBHEntry.isSmallGame then
                YGBHEntry.isSmallGame = false;
                for i = 1, YGBHEntry.dlBtn.transform.childCount do
                    YGBHEntry.dlBtn.transform:GetChild(i - 1).gameObject:SetActive(false);
                end
                YGBHEntry.smallSPRealCount = 0;
            end
            coroutine.start(function()
                coroutine.wait(1);
                YGBHEntry.smallEffect:DOScale(Vector3.New(0, 0, 0), 0.3):OnComplete(function()
                    YGBHEntry.smallEffect.gameObject:SetActive(false);
                    if issmall then
                        YGBHEntry.zpPanel.parent.gameObject:SetActive(false);
                    end
                    self.CheckFree();
                end);
            end);
        end
        YGBH_Audio.PlaySound(YGBH_Audio.SoundList.FIREGOLD, YGBH_DataConfig.winGoldChangeRate);
        self.isShowCSJLResult = true;
        log("开始免费结算跑分")
    end
    YGBHEntry.smallEffect:DOLocalMove(Vector3.New(0, 0, 0), 0.3);
    YGBHEntry.smallEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);
end
function YGBH_Result.ShowCSJLResult()
    --展示财神降临结果
    if self.isShowCSJLResult then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= self.spGameGold then
            self.currentRunGold = self.spGameGold;
        end
        YGBHEntry.winSmallEffectNum.text = YGBHEntry.ShowText(self.currentRunGold);
        if self.timer >= YGBH_DataConfig.autoRewardInterval then
            self.isShowCSJLResult = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function YGBH_Result.ShowFreeEffect()
    --展示免费
    --TODO 将scatter动画替换为中奖动画
    for i = 1, #YGBHEntry.scatterList do
        YGBH_Line.CollectEffect(YGBHEntry.scatterList[i]:GetChild(0).gameObject);
        local effect = YGBH_Line.CreateEffect(YGBH_DataConfig.GetEffectName(12));
        if effect ~= nil then
            effect.transform:SetParent(YGBHEntry.scatterList[i]);
            effect.transform.localPosition = Vector3.New(0, 0, 0);
            effect.transform.localRotation = Quaternion.identity;
            effect.transform.localScale = Vector3.New(1.15, 1.15, 1.15);
            effect.gameObject:SetActive(true);
            effect.name = YGBH_DataConfig.GetEffectName(12);
        end
    end
    YGBHEntry.ShowFreeGame();
end
function YGBH_Result.ShowFree()
    if self.isShowFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= YGBH_DataConfig.freeLoadingShowTime then
            self.isShowFree = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function YGBH_Result.HideFree()
    --隐藏中奖
    if self.isHideFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= self.hideFreeTime then
            --等待退出动画时长
            self.isHideFree = false;
            YGBHEntry.EnterFreeEffect.gameObject:SetActive(false);
            YGBHEntry.FreeRoll();
        end

    end
end
---------------------中奖---------------------
function YGBH_Result.ShowCYGGEffect()
    --很棒动画
    log("很棒");
    YGBHEntry.greatEffect.transform.localScale = Vector3.New(0, 0, 0);
    YGBHEntry.winGreatNum.text = YGBHEntry.ShowText("0");
    YGBHEntry.greatProgress.value = 0;
    YGBHEntry.greatEffect.gameObject:SetActive(true);
    local showeffect = function()
        log("很棒动画");
        self.timer = 0;
        self.currentRunGold = 0;
        self.currentRunProgress = 0;
        self.winRate = math.ceil(YGBHEntry.ResultData.WinScore / (YGBH_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        self.progressRate = math.ceil(1 / (YGBH_DataConfig.winGoldChangeRate / Time.deltaTime));
        self.greatEffectTweener = Util.RunWinScore(0, YGBHEntry.ResultData.WinScore, YGBH_DataConfig.winGoldChangeRate, function(value)
            self.currentRunGold = math.ceil(value);
            YGBHEntry.greatProgress.value = self.currentRunGold / YGBHEntry.ResultData.WinScore;
            YGBHEntry.winGreatNum.text = YGBHEntry.ShowText(self.currentRunGold);
        end);
        self.greatEffectTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.greatEffectTweener = nil;
            self.StopGreatEffect();
        end);
        self.showResultCallback = function()
            self.isShowCYGG = false;
            self.timer = 0;
            YGBHEntry.ChangeGold(YGBHEntry.myGold);
            YGBHEntry.greatEffect:DOScale(Vector3.New(0, 0, 0), 0.3):SetDelay(0.5):OnComplete(function()
                YGBHEntry.greatEffect.gameObject:SetActive(false);
                self.CheckFree();
            end);
        end
        YGBH_Audio.PlaySound(YGBH_Audio.SoundList.HIGHWIN2, YGBH_DataConfig.winGoldChangeRate);
        --self.isShowCYGG = true;
    end
    YGBHEntry.greatEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);
end
function YGBH_Result.StopGreatEffect()
    YGBHEntry.greatProgress.value = 1;
    if self.showResultCallback ~= nil then
        self.showResultCallback();
    end
end
function YGBH_Result.ShowCYGG()
    --很棒跑分
    if self.isShowCYGG then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= YGBHEntry.ResultData.WinScore then
            self.currentRunGold = YGBHEntry.ResultData.WinScore;
        end
        YGBHEntry.winGreatNum.text = YGBHEntry.ShowText(self.currentRunGold);
        YGBHEntry.greatProgress.value = self.currentRunGold / YGBHEntry.ResultData.WinScore;
        if self.timer >= YGBH_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function YGBH_Result.ShowJYMTEffect()
    --非常棒动画
    log("非常棒");
    YGBHEntry.goodEffect.transform.localScale = Vector3.New(0, 0, 0);
    YGBHEntry.winGoodNum.text = "0";
    YGBHEntry.goodProgress.value = 0;
    YGBHEntry.goodEffect.gameObject:SetActive(true);
    local showeffect = function()
        log("非常棒动画");
        self.timer = 0;
        self.currentRunGold = 0;
        self.currentRunProgress = 0;
        self.winRate = math.ceil(YGBHEntry.ResultData.WinScore / (YGBH_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        self.progressRate = math.ceil(1 / (YGBH_DataConfig.winGoldChangeRate / Time.deltaTime));
        self.goodEffectTweener = Util.RunWinScore(0, YGBHEntry.ResultData.WinScore, YGBH_DataConfig.winGoldChangeRate, function(value)
            self.currentRunGold = math.ceil(value);
            YGBHEntry.goodProgress.value = self.currentRunGold / YGBHEntry.ResultData.WinScore;
            YGBHEntry.winGoodNum.text = YGBHEntry.ShowText(self.currentRunGold);
        end);
        self.goodEffectTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.goodEffectTweener = nil;
            self.StopGoodEffect();
        end);
        self.showResultCallback = function()
            YGBHEntry.ChangeGold(YGBHEntry.myGold);
            self.timer = 0;
            self.isShowJYMT = false;
            YGBHEntry.goodEffect:DOScale(Vector3.New(0, 0, 0), 0.3):SetDelay(0.5):OnComplete(function()
                YGBHEntry.goodEffect.gameObject:SetActive(false);
                self.CheckFree();
            end);
        end
        YGBH_Audio.PlaySound(YGBH_Audio.SoundList.HIGHWIN2, YGBH_DataConfig.winGoldChangeRate);
        --self.isShowJYMT = true;
        log("非常棒动画开始");
    end
    YGBHEntry.goodEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);
end
function YGBH_Result.StopGoodEffect()
    YGBHEntry.goodProgress.value = 1;
    if self.showResultCallback ~= nil then
        self.showResultCallback();
    end
end
function YGBH_Result.ShowJYMT()
    --金玉满堂
    if self.isShowJYMT then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= YGBHEntry.ResultData.WinScore then
            self.currentRunGold = YGBHEntry.ResultData.WinScore;
        end
        YGBHEntry.winGoodNum.text = YGBHEntry.ShowText(self.currentRunGold);
        YGBHEntry.goodProgress.value = self.currentRunGold / YGBHEntry.ResultData.WinScore;
        if self.timer >= YGBH_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function YGBH_Result.ShowPrefectEffect()
    --接近完美动画
    YGBHEntry.perfectEffect.transform.localScale = Vector3.New(0, 0, 0);
    YGBHEntry.winPerfectNum.text = YGBHEntry.ShowText("0");
    YGBHEntry.prefectProgress.value = 0;
    local showeffect = function()
        self.timer = 0;
        self.currentRunGold = 0;
        self.currentRunProgress = 0;
        self.winRate = math.ceil(YGBHEntry.ResultData.WinScore / (YGBH_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        self.perfectEffectTweener = Util.RunWinScore(0, YGBHEntry.ResultData.WinScore, YGBH_DataConfig.winGoldChangeRate, function(value)
            self.currentRunGold = math.ceil(value);
            YGBHEntry.prefectProgress.value = self.currentRunGold / YGBHEntry.ResultData.WinScore;
            YGBHEntry.winPerfectNum.text = YGBHEntry.ShowText(self.currentRunGold);
        end);
        self.perfectEffectTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.perfectEffectTweener = nil;
            self.StopPerfectEffect();
        end);
        self.showResultCallback = function()
            YGBHEntry.ChangeGold(YGBHEntry.myGold);
            self.timer = 0;
            self.isShowPrefect = false;
            YGBHEntry.perfectEffect:DOScale(Vector3.New(0, 0, 0), 0.3):SetDelay(0.5):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                YGBHEntry.perfectEffect.gameObject:SetActive(false);
                self.CheckFree();
            end);
        end
        YGBH_Audio.PlaySound(YGBH_Audio.SoundList.HIGHWIN2, YGBH_DataConfig.winGoldChangeRate);
        --self.isShowPrefect = true;
        YGBHEntry.isRoll = false;
    end
    YGBHEntry.perfectEffect.gameObject:SetActive(true);
    YGBHEntry.perfectEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);
end
function YGBH_Result.StopPerfectEffect()
    YGBHEntry.prefectProgress.value = 1;
    if self.showResultCallback ~= nil then
        self.showResultCallback();
    end
end
function YGBH_Result.ShowPrefect()
    --接近完美
    if self.isShowPrefect then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= YGBHEntry.ResultData.WinScore then
            self.currentRunGold = YGBHEntry.ResultData.WinScore;
        end
        YGBHEntry.winPerfectNum.text = YGBHEntry.ShowText(self.currentRunGold);
        YGBHEntry.prefectProgress.value = self.currentRunGold / YGBHEntry.ResultData.WinScore;
        if self.timer >= YGBH_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function YGBH_Result.ShowBigEffect()
    --大分动画
    YGBHEntry.bigEffect.transform.localScale = Vector3.New(0, 0, 0);
    YGBHEntry.winBigNum.text = YGBHEntry.ShowText("0");
    YGBHEntry.bigDJJY:SetActive(true);
    YGBHEntry.bigFJYF:SetActive(false);
    YGBHEntry.bigTXWS:SetActive(false);
    YGBHEntry.bigProgress.value = 0;
    local showeffect = function()
        self.timer = 0;
        self.currentRunGold = 0;
        self.currentRunProgress = 0;
        local index = 0;
        YGBHEntry.bigProgress.value = 0;
        self.bigEffectTweener = Util.RunWinScore(0, YGBHEntry.ResultData.WinScore, YGBH_DataConfig.winBigGoldChangeRate, function(value)
            self.currentRunGold = math.ceil(value);
            if self.currentRunGold >= YGBHEntry.ResultData.WinScore then
                self.currentRunGold = YGBHEntry.ResultData.WinScore;
            end
            local remain = (self.currentRunGold - index * (YGBHEntry.ResultData.WinScore / 3)) / (YGBHEntry.ResultData.WinScore / 3);
            YGBHEntry.bigProgress.value = remain;
            if remain >= 1 then
                if index < 2 then
                    YGBHEntry.bigEffect:Find("Content"):GetChild(index).gameObject:SetActive(false);
                    index = index + 1;
                    YGBHEntry.bigEffect:Find("Content"):GetChild(index).gameObject:SetActive(true);
                    YGBHEntry.bigProgress.value = 0;
                    YGBH_Audio.ClearAuido(YGBH_Audio.SoundList.HIGHWIN2);
                    YGBH_Audio.PlaySound(YGBH_Audio.SoundList.HIGHWIN2);
                end
            end
            YGBHEntry.winBigNum.text = YGBHEntry.ShowText(self.currentRunGold);
        end);
        self.bigEffectTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.bigEffectTweener = nil;
            self.StopBigEffect();
        end);
        self.winRate = math.ceil(YGBHEntry.ResultData.WinScore / (YGBH_DataConfig.winBigGoldChangeRate * 3 / Time.deltaTime)) * 2;
        self.showResultCallback = function()
            YGBHEntry.ChangeGold(YGBHEntry.myGold);
            self.timer = 0;
            self.isShowBig = false;
            YGBHEntry.bigEffect:DOScale(Vector3.New(0, 0, 0), 0.3):SetDelay(0.5):OnComplete(function()
                YGBHEntry.bigEffect.gameObject:SetActive(false);
                self.CheckFree();
            end);
        end
        YGBH_Audio.PlaySound(YGBH_Audio.SoundList.HIGHWIN2, YGBH_DataConfig.winBigGoldChangeRate / 3);
        --self.isShowBig = true;
    end
    YGBHEntry.bigEffect.gameObject:SetActive(true);
    YGBHEntry.bigEffect:DOScale(Vector3.New(1, 1, 1), 0.3):SetEase(DG.Tweening.Ease.Linear):OnComplete(showeffect);
end
function YGBH_Result.StopBigEffect()
    self.bigEffectTweener = Util.RunWinScore(0, 1, 1, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        if self.showResultCallback ~= nil then
            self.showResultCallback();
        end
    end);
end
function YGBH_Result.ShowBig()
    --高分
    if self.isShowBig then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= YGBHEntry.ResultData.WinScore then
            self.currentRunGold = YGBHEntry.ResultData.WinScore;
        end
        YGBHEntry.winBigNum.text = YGBHEntry.ShowText(self.currentRunGold);
        if self.currentRunProgress < 3 then
            YGBHEntry.bigProgress.value = (self.currentRunGold / YGBHEntry.ResultData.WinScore) * 5 - self.currentRunProgress;
        end
        if YGBHEntry.bigProgress.value >= 1 and self.currentRunProgress < 2 then
            YGBHEntry.bigProgress.value = 0;
            --TODO 音效
            YGBH_Audio.PlaySound(YGBH_Audio.SoundList.HIGHWIN2, YGBH_DataConfig.winBigGoldChangeRate / 3);
            self.currentRunProgress = self.currentRunProgress + 1;
            if self.currentRunProgress == 1 then
                YGBHEntry.bigDJJY:SetActive(false);
                YGBHEntry.bigFJYF:SetActive(true);
                YGBHEntry.bigTXWS:SetActive(false);
            elseif self.currentRunProgress == 2 then
                YGBHEntry.bigDJJY:SetActive(false);
                YGBHEntry.bigFJYF:SetActive(false);
                YGBHEntry.bigTXWS:SetActive(true);
            end
        end
        if self.timer >= YGBH_DataConfig.winBigGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function YGBH_Result.ShowNormalEffect()
    --普通奖动画
    YGBHEntry.winNormalEffect.transform.localScale = Vector3.New(0, 0, 0);
    YGBHEntry.winNormalEffect.gameObject:SetActive(true);
    local showeffect = function()
        self.timer = 0;
        self.currentRunGold = 0;
        YGBHEntry.winNormalNum.text = "0";
        self.winRate = math.ceil(YGBHEntry.ResultData.WinScore / (YGBH_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        Util.RunWinScore(0, YGBHEntry.ResultData.WinScore, YGBH_DataConfig.winGoldChangeRate, function(value)
            self.currentRunGold = math.ceil(value);
            YGBHEntry.winNormalNum.text = YGBHEntry.ShowText(self.currentRunGold);
        end):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end);
        self.showResultCallback = function()
            YGBHEntry.ChangeGold(YGBHEntry.myGold);
            self.timer = 0;
            self.isShowNormal = false;
            YGBHEntry.winNormalEffect:DOScale(Vector3.New(0, 0, 0), 0.15):SetDelay(0.5):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                YGBHEntry.winNormalEffect.gameObject:SetActive(false);
                self.CheckFree();
                --self.isHideNormal = true;
            end);
        end
        YGBH_Audio.PlaySound(YGBH_Audio.SoundList.FIREGOLD, YGBH_DataConfig.winGoldChangeRate);
        Util.RunWinScore(0, 1, 0.5, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            YGBH_Audio.PlaySound(YGBH_Audio.SoundList.FREESELECT);
        end);
        --self.isShowNormal = true;
    end
    YGBHEntry.winNormalEffect:DOScale(Vector3.New(1, 1, 1), 0.3):OnComplete(showeffect);
end
function YGBH_Result.ShowNormal()
    --普通奖
    if self.isShowNormal then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= YGBHEntry.ResultData.WinScore then
            self.currentRunGold = YGBHEntry.ResultData.WinScore;
        end
        YGBHEntry.winNormalNum.text = YGBHEntry.ShowText(self.currentRunGold);
        if self.timer >= YGBH_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function YGBH_Result.HideNormal()
    --隐藏中奖
    if self.isHideNormal then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= self.hideNormalTime then
            --等待退出动画时长
            self.isHideNormal = false;
            YGBHEntry.winNormalEffect.gameObject:SetActive(false);
            self.CheckFree();
        end
    end
end