Module16_Result = {};

local self = Module16_Result;

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

function Module16_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = false;
    --self.isPause = false;
end
function Module16_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = true;
    Module16Entry.myGold = TableUserInfo._7wGold;
    -- Module16Entry.WinNum.text = Module16Entry.ShowText(Module16Entry.ResultData.WinScore);
    -- if self.WinningLineNum>0 then
    --     Module16Entry.TipText.text="恭喜您！中"..self.WinningLineNum.."线"
    -- else
    --     Module16Entry.TipText.text=""
    -- end

    --其他正常模式
    if Module16Entry.ResultData.WinScore > 0 then
        Module16Entry.WinNum.text = Module16Entry.ShowText(Module16Entry.ResultData.WinScore);
        Module16_Line.Show();
        local rate = Module16Entry.ResultData.WinScore / (Module16Entry.CurrentChip * Module16_DataConfig.ALLLINECOUNT);
        --Module16_Result.ShowNormalEffect()

        if rate < 5 then
            --普通奖  不做显示
            self.ShowNormalEffect()
        elseif rate >= 5 then
            self.ShowBigWinEffect();
        end
    else
        Module16Entry.SetSelfGold(Module16Entry.myGold);
        coroutine.start(self.ShowCSGroup)
    end
end

function Module16_Result.ShowCSGroup()
    coroutine.wait(0.3)
    self.timer = 0
    self.nowin = true;
    Module16Entry.CSGroup.gameObject:SetActive(true);
end

function Module16_Result.HideResult()
    for i = 1, Module16Entry.resultEffect.childCount do
        Module16Entry.resultEffect:GetChild(i - 1).gameObject:SetActive(false);
    end
    Module16Entry.CSGroup.gameObject:SetActive(false);
    self.timer = 0;
    self.showCSJLCallback = nil;
    self.showResultCallback = nil;
end
function Module16_Result.Update()
    -- if self.isPause then
    --     return ;
    -- end

    self.ShowSuperWin();
    self.ShowMegaWin();
    self.ShowBigWin();
    self.ShowFree();
    self.HideFree();
    self.ShowNormal();
    self.NoWinWait();
    self.ShowFreeResult();
end

function Module16_Result.NoWinWait()
    if self.nowin then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= Module16_DataConfig.autoNoRewardInterval then
            self.nowin = false;
            Module16Entry.isRoll = false;
            self.CheckFree();
        end
    end
end
function Module16_Result.CheckFree()
    Module16Entry.isRoll = false;
    if not Module16Entry.isFreeGame then
        if Module16Entry.ResultData.FreeCount > 0 then
            self.totalFreeGold = self.totalFreeGold + Module16Entry.ResultData.WinScore;
            Module16_Line.Close();
            self.ShowFreeEffect(false);
        else
            Module16Entry.FreeRoll();
        end
    else
        if Module16Entry.ResultData.FreeCount <= 0 then
            self.ShowFreeResultEffect();
        else
            Module16Entry.FreeRoll();
        end
    end
end
function Module16_Result.ShowFreeEffect(isSceneData)
    --展示免费
    Module16Entry.isFreeGame = true;
    self.timer = 0;
    --Module16_Line.ShowFree();
    Module16Entry.currentFreeCount = 0;
    self.showResultCallback = function()
        self.timer = 0;
        Module16Entry.addChipBtn.interactable = false;
        Module16Entry.reduceChipBtn.interactable = false;
        Module16Entry.MaxChipBtn.interactable = false;
        Module16Entry.AutoStartBtn.interactable = false;

        --Module16Entry.EnterFreeEffect.gameObject:SetActive(true);
        coroutine.start(function()
            local go = Module16Entry.TipPanel:Find("FreeGameTip")
            go.gameObject:SetActive(true)
            Module16Entry.TipPanel.gameObject:SetActive(true)
            go:Find("tip"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "Ch_in", false);
            coroutine.wait(1)
            go:Find("tip"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "Ch_idle", false);
            coroutine.wait(1)
            go:Find("tip"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "Ch_out", false);
            coroutine.wait(1)
            --Module16Entry.SetState(2);
            Module16Entry.freeCount = Module16Entry.ResultData.FreeCount;

            self.isHideFree = true;
            Module16_Line.Close();
        end)
    end
    self.isShowFree = true;
end
function Module16_Result.ShowFree()
    if self.isShowFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= Module16_DataConfig.winGoldChangeRate then
            self.isShowFree = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function Module16_Result.HideFree()
    --隐藏中奖
    if self.isHideFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= Module16_DataConfig.smallGameLoadingShowTime then
            --等待退出动画时长
            self.isHideFree = false;
            --Module16_Audio.PlayBGM(Module16_Audio.SoundList.FreeBGM);
            --Module16Entry.EnterFreeEffect.gameObject:SetActive(false);
            Module16Entry.TipPanel.gameObject:SetActive(false)
            for i = 1, Module16Entry.TipPanel.childCount do
                Module16Entry.TipPanel:GetChild(i - 1).gameObject:SetActive(false)
            end
            Module16Entry.TipPanel:Find("ResultPanel/tip/Text").gameObject:SetActive(false)
            Module16Entry.FreeRoll();
        end
    end
end

function Module16_Result.ShowFreeResultEffect()
    --展示免费结果
    self.timer = 0;
    self.currentRunGold = 0;
    self.showResultCallback = function()
        self.isShowTotalFree = false;
        --Module16Entry.FreeResultEffect.gameObject:SetActive(false);
        Module16Entry.TipPanel.gameObject:SetActive(false)
        for i = 1, Module16Entry.TipPanel.childCount do
            Module16Entry.TipPanel:GetChild(i - 1).gameObject:SetActive(false)
        end
        Module16Entry.TipPanel:Find("ResultPanel/tip/Text").gameObject:SetActive(false)
        self.timer = 0;
        Module16Entry.FreeRoll();
    end
    --Module16Entry.FreeResultEffect.gameObject:SetActive(true);
    --Module16Entry.FreeResultNum.gameObject:SetActive(true);
    coroutine.start(function()
        local go = Module16Entry.TipPanel:Find("ResultPanel")
        go.gameObject:SetActive(true)
        Module16Entry.TipPanel.gameObject:SetActive(true)
        go:Find("tip"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "Ch_in", false);
        coroutine.wait(1)
        go:Find("tip"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "Ch_idle", false);
        go:Find("tip/Text").gameObject:SetActive(true)
        self.winRate = math.ceil(self.totalFreeGold / (Module16_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        self.isShowTotalFree = true;
        coroutine.wait(1)
        go:Find("tip"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "Ch_out", false);
        coroutine.wait(1)
    end)
end
function Module16_Result.ShowFreeResult()
    if self.isShowTotalFree then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= self.totalFreeGold then
            self.currentRunGold = self.totalFreeGold;
        end
        Module16Entry.TipPanel:Find("ResultPanel/tip/Text"):GetComponent("TextMeshProUGUI").text = Module16Entry.ShowText(self.currentRunGold);
        if self.timer >= Module16_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

---------------------中奖---------------------
function Module16_Result.ShowBigWinEffect()
    --BigWin奖动画
    Module16_Audio.PlaySound(Module16_Audio.SoundList.BW, Module16_DataConfig.winGoldChangeRate);
    self.timer = 0;
    self.currentRunGold = 0;
    Module16Entry.SetSelfGold(Module16Entry.myGold);
    Module16Entry.WinGoldText.text = Module16Entry.ShowText(Module16Entry.ResultData.WinScore)
    Module16Entry.WinGold.gameObject:SetActive(true)
    self.winRate = math.ceil(Module16Entry.ResultData.WinScore / (Module16_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    self.showResultCallback = nil;
    self.showResultCallback = function()
        self.isShowNormal = false;
        self.timer = 0;
        Module16Entry.WinGold.gameObject:SetActive(false)
        Module16Entry.WinGoldText.text = Module16Entry.ShowText(0)
        self.CheckFree();
    end
    self.isShowNormal = true;
end
function Module16_Result.ShowBigWin()
    --BigWin奖
    if self.isShowBigWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= Module16Entry.ResultData.WinScore then
            self.currentRunGold = Module16Entry.ResultData.WinScore;
        end
        Module16Entry.bigWinNum.text = Module16Entry.ShowText(self.currentRunGold);
        if self.timer >= Module16_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function Module16_Result.ShowSuperWinffect()
    --Super奖动画
    --Module16_Audio.PlaySound(Module16_Audio.SoundList.SW, Module16_DataConfig.winGoldChangeRate);
    Module16Entry.superWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    Module16Entry.superWinNum.text = Module16Entry.ShowText(self.currentRunGold);
    Module16Entry.superWinNum.gameObject:SetActive(true);
    self.winRate = math.ceil(Module16Entry.ResultData.WinScore / (Module16_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    Module16Entry.SetSelfGold(Module16Entry.myGold);
    self.showResultCallback = function()
        Module16Entry.superWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowSuperWin = false;
        Module16_Result.CheckFree();
    end
    self.isShowSuperWin = true;
end
function Module16_Result.ShowSuperWin()
    --Super奖
    if self.isShowSuperWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= Module16Entry.ResultData.WinScore then
            self.currentRunGold = Module16Entry.ResultData.WinScore;
        end
        Module16Entry.superWinNum.text = Module16Entry.ShowText(self.currentRunGold);
        if self.timer >= Module16_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function Module16_Result.ShowMegaWinEffect()
    --Mega奖动画
    --Module16_Audio.PlaySound(Module16_Audio.SoundList.MW, Module16_DataConfig.winGoldChangeRate);
    Module16Entry.megaWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    Module16Entry.megaWinNum.text = Module16Entry.ShowText(self.currentRunGold);
    Module16Entry.megaWinNum.gameObject:SetActive(true);
    self.winRate = math.ceil(Module16Entry.ResultData.WinScore / (Module16_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    Module16Entry.SetSelfGold(Module16Entry.myGold);
    self.showResultCallback = function()
        Module16Entry.megaWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowMageWin = false;
        Module16_Result.CheckFree();
    end
    self.isShowMageWin = true;
end
function Module16_Result.ShowMegaWin()
    --Mega奖
    if self.isShowMageWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= Module16Entry.ResultData.WinScore then
            self.currentRunGold = Module16Entry.ResultData.WinScore;
        end
        Module16Entry.megaWinNum.text = Module16Entry.ShowText(self.currentRunGold);
        if self.timer >= Module16_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function Module16_Result.ShowNormalEffect()
    self.timer = 0;
    self.currentRunGold = 0;
    Module16_Audio.PlaySound(Module16_Audio.SoundList.WSGame);
    Module16Entry.SetSelfGold(Module16Entry.myGold);
    Module16Entry.WinGoldText.text = Module16Entry.ShowText(Module16Entry.ResultData.WinScore)
    Module16Entry.WinGold.gameObject:SetActive(true)
    self.winRate = math.ceil(Module16Entry.ResultData.WinScore / (Module16_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    self.showResultCallback = nil;
    self.showResultCallback = function()
        self.isShowNormal = false;
        self.timer = 0;
        Module16Entry.WinGold.gameObject:SetActive(false)
        Module16Entry.WinGoldText.text = Module16Entry.ShowText(0)
        self.CheckFree();
    end
    self.isShowNormal = true;
end
function Module16_Result.ShowNormal()
    if self.isShowNormal then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= Module16Entry.ResultData.WinScore then
            self.currentRunGold = Module16Entry.ResultData.WinScore;
        end
        Module16Entry.WinGoldText.text = Module16Entry.ShowText(self.currentRunGold);
        if self.timer >= Module16_DataConfig.winGoldChangeRate then

            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end