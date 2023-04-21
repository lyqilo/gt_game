Module27_Result = {};

local self = Module27_Result;

self.timer = 0;
self.isShow = false;

self.isPause = false;

self.isShowCSJL = false;--展示财神
self.waitNextCSJL = false;--等待下一次重转
self.showCSJLCallback = nil;--展示完回调

self.isShowCSJLResult = false;--展示财神奖励
self.winRate = 0;--赢的跑分比率
self.currentRunGold = 0;

self.isWinCSJL = false;--当前是否为财神降临

self.isShowJYMT = false;--展示金玉满堂
self.isShowCYGG = false;--展示财源滚滚
self.isShowNormal = false;--展示中奖
self.isHideNormal = false;--隐藏中奖
self.showResultCallback = nil;
self.hideNormalTime = 0.5;--退出动画时长

self.nowin = false;--没有得分
self.isFreeGame = false;--是否为免费游戏
self.showFreeTweener = nil;--免费财神动画tween
self.isShowFree = false;--展示免费
self.isHideFree = false;--隐藏免费
self.hideFreeTime = 1;--免费动画退出时长

function Module27_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = false;
    self.isPause = false;
end
function Module27_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = true;
    Module27.myGold = TableUserInfo._7wGold;
    Module27.WinNum.text = Module27.ShowText(Module27.FormatNumberThousands(Module27.ResultData.WinScore));
    if not self.isWinCSJL then
        if Module27.ResultData.bReturn then
            --得财神
            self.isWinCSJL = Module27.ResultData.bReturn;
            self.ShowCSJLEffect();
        else
            --其他正常模式
            if Module27.ResultData.GameType == Module27_DataConfig.GameResultType.CYGG then
                self.ShowCYGGEffect();
            elseif Module27.ResultData.GameType == Module27_DataConfig.GameResultType.JYMT then
                self.ShowJYMTEffect();
            elseif Module27.ResultData.GameType == Module27_DataConfig.GameResultType.NORMAL then
                if Module27.ResultData.WinScore > 0 then
                    self.ShowNormalEffect();
                else
                    Module27.isRoll = false;
                    self.nowin = true;
                    Module27.selfGold.text = Module27.ShowText(Module27.FormatNumberThousands(Module27.myGold));
                end
            end
        end
    else
        if Module27.ResultData.bReturn then
            --继续重转
            for i = 1, #Module27.ResultData.ImgTable do
                if Module27.ResultData.ImgTable[i] == 0 then
                    local column = math.floor(i / 5);--排
                    local raw = i % 5;--列
                    if raw == 0 then
                        raw = 5;
                        column = column - 1;
                    end
                    Module27.CSGroup:GetChild(raw - 1):GetChild(column).gameObject:SetActive(true);
                end
            end
            self.showCSJLCallback = function()
                Module27.CSJLRoll();
            end
            self.waitNextCSJL = true;
        else
            --财神结束
            self.ShowCSJLResultEffect();
        end
    end
end
function Module27_Result.HideResult()
    for i = 1, Module27.resultEffect.childCount do
        Module27.resultEffect:GetChild(i - 1).gameObject:SetActive(false);
    end
    self.showCSJLCallback = nil;
    self.showResultCallback = nil;
end
function Module27_Result.Update()
    if self.isPause then
        return ;
    end
    self.ShowCSJL();
    self.WaitRollAgainCSJL();

    self.ShowCSJLResult();
    self.ShowCYGG();
    self.ShowJYMT();
    self.ShowNormal();
    self.HideNormal();

    self.ShowFree();
    self.HideFree();

    self.NoWinWait();
end

function Module27_Result.NoWinWait()
    if self.nowin then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= Module27_DataConfig.autoNoRewardInterval then
            self.nowin = false;
            Module27.FreeRoll();
        end
    end
end
----------------------财神--------------------------------
function Module27_Result.WaitRollAgainCSJL()
    --财神重转
    if self.waitNextCSJL then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= Module27_DataConfig.autoNoRewardInterval then
            self.waitNextCSJL = false;
            if self.showCSJLCallback ~= nil then
                self.showCSJLCallback();
            end
        end
    end
end
function Module27_Result.ShowCSJLEffect()
    --财神展示动画
    Module27_Audio.PlayBGM(Module27_Audio.SoundList.CSJLBGM);
    Module27.addChipBtn.interactable = false;
    Module27.reduceChipBtn.interactable = false;
    Module27.MaxChipBtn.interactable = false;
    Module27.CSJLEffect.gameObject:SetActive(true);
    Module27.CSJLEffect.AnimationState:SetAnimation(0, "animation", true);
    Module27.CSGroup.gameObject:SetActive(true);
    for i = 1, #Module27.ResultData.ImgTable do
        if Module27.ResultData.ImgTable[i] == 0 then
            local column = math.floor(i / 5);--排
            local raw = i % 5;--列
            if raw == 0 then
                raw = 5;
                column = column - 1;
            end
            Module27.CSGroup:GetChild(raw - 1):GetChild(column).gameObject:SetActive(true);
        end
    end
    self.showCSJLCallback = function()
        Module27.CSJLRoll();
    end;
    self.isShowCSJL = true;
end
function Module27_Result.ShowCSJL()
    --财神展示
    if self.isShowCSJL then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= Module27_DataConfig.smallGameLoadingShowTime then
            Module27.CSJLEffect.gameObject:SetActive(false);
            if self.showCSJLCallback ~= nil then
                self.showCSJLCallback();
            end
            self.isShowCSJL = false;
        end
    end
end
------------------------财神结束---------------------------
function Module27_Result.ShowCSJLResultEffect()
    self.isWinCSJL = false;
    Module27.addChipBtn.interactable = true;
    Module27.reduceChipBtn.interactable = true;
    Module27.MaxChipBtn.interactable = true;
    Module27.CSJLResult.gameObject:SetActive(true);
    Module27.CSJLResult.AnimationState:SetAnimation(0, "caishendao_hdjb", false);
    self.winRate = math.ceil(Module27.ResultData.WinScore / (Module27_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    Module27.selfGold.text = Module27.ShowText(Module27.FormatNumberThousands(Module27.myGold));
    Module27.CSJLResultWin.text = Module27.ShowText(0);
    self.showCSJLCallback = function()
        Module27.isRoll = false;
        Module27.CSGroup.gameObject:SetActive(false);
        for i = 1, Module27.CSGroup.childCount do
            for j = 1, Module27.CSGroup:GetChild(i - 1).childCount do
                Module27.CSGroup:GetChild(i - 1):GetChild(j - 1).gameObject:SetActive(false);
            end
        end
        if not self.isFreeGame and Module27.ResultData.FreeCount > 0 then
            self.isFreeGame = true;
            Module27.freeCount = Module27.ResultData.FreeCount;
            Module27.isFreeGame = true;
            self.ShowFreeEffect(false);
        else
            Module27_Audio.PlayBGM();
            Module27.FreeRoll();
        end
    end
    Module27_Audio.PlaySound(Module27_Audio.SoundList.DS, Module27_DataConfig.smallGameLoadingShowTime);
    self.isShowCSJLResult = true;
end
function Module27_Result.ShowCSJLResult()
    --展示财神降临结果
    if self.isShowCSJLResult then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= Module27.ResultData.WinScore then
            self.currentRunGold = Module27.ResultData.WinScore;
        end
        Module27.CSJLResultWin.text = Module27.ShowText(Module27.FormatNumberThousands(self.currentRunGold));
        if self.timer >= Module27_DataConfig.smallGameLoadingShowTime then
            self.isShowCSJLResult = false;
            if self.showCSJLCallback ~= nil then
                self.showCSJLCallback();
            end
        end
    end
end

function Module27_Result.ShowFreeEffect(isSceneData)
    --展示免费
    Module27.addChipBtn.interactable = false;
    Module27.reduceChipBtn.interactable = false;
    Module27.MaxChipBtn.interactable = false;
    Module27.EnterFreeEffect.gameObject:SetActive(true);
    Module27.EnterFreeEffect.AnimationState:SetAnimation(0, "caishendao_mianfeiyouxi", false);
    --Module27.EnterFreeEffect.AnimationState:AddAnimation(0, "ch_idle", true, 0);
    self.timer = 0;
    self.showResultCallback = function()
        --Module27.EnterFreeEffect.AnimationState:SetAnimation(0, "ch_out", false);
        self.isHideFree = true;
    end
    if not isSceneData then
        local cs = Module27.FreeRewardList:Find(tostring(Module27.ResultData.CaishenCount));
        self.showFreeTweener = cs:DOScale(Vector3.New(1.2, 1.2, 1.2), 0.3):SetLoops(-1, DG.Tweening.LoopType.Yoyo);
    end
    self.isShowFree = true;
end
function Module27_Result.ShowFree()
    if self.isShowFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= Module27_DataConfig.freeLoadingShowTime then
            self.isShowFree = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function Module27_Result.HideFree()
    --隐藏中奖
    if self.isHideFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= self.hideFreeTime then
            --等待退出动画时长
            self.isHideFree = false;
            Module27.EnterFreeEffect.gameObject:SetActive(false);
            Module27.FreeRoll();
        end

    end
end
---------------------中奖---------------------
function Module27_Result.ShowCYGGEffect()
    --财源滚滚动画
    Module27.CYGGEffect.gameObject:SetActive(true);
    Module27.CYGGEffect.AnimationState:SetAnimation(0, "animation", true);
    self.timer = 0;
    self.showResultCallback = function()
        Module27.CYGGEffect.gameObject:SetActive(false);
        if Module27.ResultData.WinScore > 0 then
            self.ShowNormalEffect();
        else
            self.nowin = true;
            Module27.selfGold.text = Module27.ShowText(Module27.FormatNumberThousands(Module27.myGold));
            Module27.isRoll = false;
        end
    end
    Module27_Audio.PlaySound(Module27_Audio.SoundList.CYGG);
    self.isShowCYGG = true;
end
function Module27_Result.ShowCYGG()
    --财源滚滚
    if self.isShowCYGG then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= Module27_DataConfig.smallGameLoadingShowTime then
            self.timer = 0;
            self.isShowCYGG = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function Module27_Result.ShowJYMTEffect()
    --金玉满堂动画
    Module27.JYMTEffect.gameObject:SetActive(true);
    Module27.JYMTEffect.AnimationState:SetAnimation(0, "animation", true);
    self.timer = 0;
    self.showResultCallback = function()
        Module27.JYMTEffect.gameObject:SetActive(false);
        if Module27.ResultData.WinScore > 0 then
            self.ShowNormalEffect();
        else
            self.nowin = true;
            Module27.selfGold.text = Module27.ShowText(Module27.FormatNumberThousands(Module27.myGold));
            Module27.isRoll = false;
        end
    end
    Module27_Audio.PlaySound(Module27_Audio.SoundList.JYMT);
    self.isShowJYMT = true;
end
function Module27_Result.ShowJYMT()
    --金玉满堂
    if self.isShowJYMT then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= Module27_DataConfig.smallGameLoadingShowTime then
            self.timer = 0;
            self.isShowJYMT = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function Module27_Result.ShowNormalEffect()
    --普通奖动画
    Module27_Line.Show();
    Module27.winNormalEffect.gameObject:SetActive(true);
    Module27.winNormalEffect.AnimationState:SetAnimation(0, "ch_in", false);
    Module27.winNormalEffect.AnimationState:AddAnimation(0, "ch_idle", true, 0);
    self.timer = 0;
    self.currentRunGold = 0;
    Module27.winNormalNum.gameObject:SetActive(true);
    self.winRate = math.ceil(Module27.ResultData.WinScore / (Module27_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    Module27.selfGold.text = Module27.ShowText(Module27.FormatNumberThousands(Module27.myGold));
    self.showResultCallback = function()
        Module27.winNormalEffect.AnimationState:SetAnimation(0, "ch_out", false);
        Module27.winNormalNum.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowNormal = false;
        self.isHideNormal = true;
    end
    Module27_Audio.PlaySound(Module27_Audio.SoundList.DS, Module27_DataConfig.winGoldChangeRate);
    self.isShowNormal = true;
end
function Module27_Result.ShowNormal()
    --普通奖
    if self.isShowNormal then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= Module27.ResultData.WinScore then
            self.currentRunGold = Module27.ResultData.WinScore;
        end
        Module27.winNormalNum.text = Module27.ShowText(Module27.FormatNumberThousands(self.currentRunGold));
        if self.timer >= Module27_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function Module27_Result.HideNormal()
    --隐藏中奖
    if self.isHideNormal then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= self.hideNormalTime then
            --等待退出动画时长
            self.isHideNormal = false;
            Module27.winNormalEffect.gameObject:SetActive(false);
            Module27.FreeRoll();
        end
    end
end