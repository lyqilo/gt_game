Module13_Result = {};

local self = Module13_Result;

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

self.isShowFireMode = false;--展示免费
self.isHideFireMode = false;--隐藏免费

self.isShowFreeResult = false;--展示免费结果

self.hideFreeTime = 1;--免费动画退出时长

self.totalFreeGold = 0;--免费总金币
self.isShowTotalFree = false;--展示免费

self.lieyanCount=0

self.WinningLineNum=0
self.IsFireMode=false
function Module13_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = false;
    --self.isPause = false;
end
function Module13_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = true;
    Module13Entry.myGold = TableUserInfo._7wGold;

    --其他正常模式
    if Module13Entry.ResultData.WinScore > 0 then   
        Module13_Line.Show();
        local rate = Module13Entry.ResultData.WinScore / (Module13Entry.CurrentChip * Module13_DataConfig.ALLLINECOUNT);
        Module13_Result.ShowNormalEffect()
    else
        Module13Entry.SetSelfGold(Module13Entry.myGold);
        coroutine.start(self.ShowCSGroup)
    end
end

function Module13_Result.ShowCSGroup()
    coroutine.wait(0.3)
    self.timer=0
    self.nowin = true;
    --Module13Entry.CSGroup.gameObject:SetActive(true);
end


function Module13_Result.HideResult()
    for i = 1, Module13Entry.resultEffect.childCount do
        Module13Entry.resultEffect:GetChild(i - 1).gameObject:SetActive(false);
    end
    --Module13Entry.CSGroup.gameObject:SetActive(false);
    self.timer = 0;
    self.showCSJLCallback = nil;
    self.showResultCallback = nil;
end
function Module13_Result.Update()

    -- if self.isPause then
    --     return ;
    -- end

    self.ShowSuperWin();
    self.ShowMegaWin();
    self.ShowBigWin();
    self.ShowFireMode();
    self.ShowFree();
    self.HideFree();
    self.ShowNormal();
    self.NoWinWait();
    self.ShowFreeResult();
end

function Module13_Result.NoWinWait()
    if self.nowin then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= Module13_DataConfig.autoNoRewardInterval then
            self.nowin = false;
            Module13Entry.isRoll = false;
            self.CheckFree();
        end
    end
end
function Module13_Result.CheckFree()
    Module13Entry.isRoll = false;
    if  Module13Entry.isFireMode and not self.IsFireMode then
        Module13_Line.Close();
        self.lieyanCount=self.lieyanCount+1
        Module13_Result.ShowFireModeEffect()
        self.IsFireMode=Module13Entry.isFireMode
        return
    else
        if (Module13Entry.ResultData.WinScore>0 and Module13Entry.isFireMode) or (self.lieyanCount>=5) then
            self.totalFreeGold = self.totalFreeGold + Module13Entry.ResultData.WinScore;
            Module13_Line.Close();
            self.IsFireMode=false
            Module13Entry.isFireMode=false
            self.lieyanCount=0
            Module13_Result.ShowFreeResultEffect()

        else
            Module13_Line.Close();
            self.IsFireMode=Module13Entry.isFireMode
            Module13Entry.FreeRoll();
        end
    end

    if not Module13Entry.isFreeGame then
        if Module13Entry.ResultData.FreeCount > 0 then
            self.totalFreeGold = self.totalFreeGold + Module13Entry.ResultData.WinScore;
            Module13_Line.Close();
            self.ShowFreeEffect(false);
        else
            Module13Entry.FreeRoll();
        end
    else
        if Module13Entry.ResultData.FreeCount <= 0 then
            self.ShowFreeResultEffect();
        else
            Module13Entry.FreeRoll();
        end
    end
end
function Module13_Result.ShowFreeEffect(isSceneData)
    logYellow("============展示免费===================")
    --展示免费
    Module13Entry.isFreeGame = true;
    self.timer = 0;
    --Module13_Line.ShowFree();
    Module13Entry.currentFreeCount = 0;
    self.showResultCallback = function()
        self.timer = 0;
        --self.isHideFree = true;
        Module13Entry.addChipBtn.interactable = false;
        Module13Entry.reduceChipBtn.interactable = false;
        Module13Entry.MaxChipBtn.interactable = false;
       -- Module13Entry.EnterFreeEffect.gameObject:SetActive(true);
        coroutine.start(function()
            local go =Module13Entry.TipPanel:Find("FreeGameTip")
            go.gameObject:SetActive(true)
            Module13Entry.TipPanel.gameObject:SetActive(true)
            go:Find("tip"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "Ch_in", false);
            coroutine.wait(1)
            go:Find("tip"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "Ch_idle", false);
            go:Find("tip/Text"):GetComponent("TextMeshProUGUI").text=Module13Entry.ShowText(Module13Entry.ResultData.FreeCount)
            go:Find("tip/Text").gameObject:SetActive(true)
            coroutine.wait(1)
            go:Find("tip"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "Ch_out", false);
            go:Find("tip/Text").gameObject:SetActive(false)
            coroutine.wait(1)
            --Module13Entry.SetState(2);
            Module13Entry.freeCount = Module13Entry.ResultData.FreeCount;
            self.isHideFree = true;
            Module13_Line.Close();
        end)
    end
    self.isShowFree = true;
end
function Module13_Result.ShowFree()
    if self.isShowFree then
        self.timer = self.timer + Time.deltaTime;
        logYellow("timer=="..self.timer)
        if self.timer >= Module13_DataConfig.winGoldChangeRate then
            self.isShowFree = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function Module13_Result.ShowFireModeEffect(isSceneData)
    logYellow("====展示烈焰模式=====")
    --展示烈焰模式
    Module13Entry.isFireMode = true;
    self.timer = 0;
    --Module13Entry.currentFreeCount = 0;
    local go =Module13Entry.TipPanel:Find("FireModeGameTip")
    Module13Entry.TipPanel.gameObject:SetActive(true)
    go.gameObject:SetActive(true)
    go:Find("tip"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "animation", false);

    self.showResultCallback = function()
        self.timer = 0;
        self.isHideFree = true;
        Module13Entry.addChipBtn.interactable = false;
        Module13Entry.reduceChipBtn.interactable = false;
        Module13Entry.MaxChipBtn.interactable = false;
        --Module13Entry.EnterFreeEffect.gameObject:SetActive(true);
        local go1 =Module13Entry.TipPanel:Find("FireModeGameTip")
        go1.gameObject:SetActive(false)
        Module13Entry.TipPanel.gameObject:SetActive(false)
        Module13_Line.Close();
    end
    self.isShowFireMode = true;
end
function Module13_Result.ShowFireMode()
    if self.isShowFireMode then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= Module13_DataConfig.FireModeTime then
            self.isShowFireMode = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end


function Module13_Result.HideFree()
    --隐藏中奖
    if self.isHideFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= Module13_DataConfig.smallGameLoadingShowTime then
            --等待退出动画时长
            self.isHideFree = false;
            --Module13_Audio.PlayBGM(Module13_Audio.SoundList.FreeBGM);
            --Module13Entry.EnterFreeEffect.gameObject:SetActive(false);
            Module13Entry.TipPanel.gameObject:SetActive(false)
            for i=1,Module13Entry.TipPanel.childCount do
                Module13Entry.TipPanel:GetChild(i-1).gameObject:SetActive(false)
            end
            Module13Entry.TipPanel:Find("ResultPanel/tip/Text").gameObject:SetActive(false)
            Module13Entry.TipPanel:Find("FreeGameTip/tip/Text").gameObject:SetActive(false)

            Module13Entry.FreeRoll();
        end
    end
end


function Module13_Result.ShowFreeResultEffect()
    --展示免费结果
    self.timer = 0;
    self.currentRunGold = 0;
    self.showResultCallback = function()
        self.isShowTotalFree = false;
        --Module13Entry.FreeResultEffect.gameObject:SetActive(false);
        Module13Entry.TipPanel.gameObject:SetActive(false)
        for i=1,Module13Entry.TipPanel.childCount do
            Module13Entry.TipPanel:GetChild(i-1).gameObject:SetActive(false)
        end
        Module13Entry.TipPanel:Find("ResultPanel/tip/Text").gameObject:SetActive(false)
        self.timer = 0;
        Module13Entry.FreeRoll();
    end
    local go =Module13Entry.TipPanel:Find("ResultPanel")
    go.gameObject:SetActive(true)
    go:Find("tip/Text").gameObject:SetActive(true)
    Module13Entry.TipPanel.gameObject:SetActive(true)
    self.isShowTotalFree = true;
    self.winRate = math.ceil(self.totalFreeGold / (Module13_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;

    --Module13Entry.FreeResultEffect.gameObject:SetActive(true);
    --Module13Entry.FreeResultNum.gameObject:SetActive(true);
end
function Module13_Result.ShowFreeResult()
    if self.isShowTotalFree then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= self.totalFreeGold then
            self.currentRunGold = self.totalFreeGold;
        end
        Module13Entry.TipPanel:Find("ResultPanel/tip/Text"):GetComponent("TextMeshProUGUI").text= Module13Entry.ShowText(self.currentRunGold);
        if self.timer >= Module13_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

---------------------中奖---------------------
function Module13_Result.ShowBigWinEffect()
    --BigWin奖动画
    Module13_Audio.PlaySound(Module13_Audio.SoundList.BW, Module13_DataConfig.winGoldChangeRate);
    self.timer = 0;    
    self.currentRunGold = 0;
    Module13Entry.SetSelfGold(Module13Entry.myGold);
    Module13Entry.WinGoldText.text=Module13Entry.ShowText(Module13Entry.ResultData.WinScore)
    Module13Entry.WinGold.gameObject:SetActive(true)
    self.winRate = math.ceil(Module13Entry.ResultData.WinScore / (Module13_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    self.showResultCallback = nil;
    self.showResultCallback = function()
        self.isShowNormal = false;
        self.timer = 0;
         Module13Entry.WinGold.gameObject:SetActive(false)
         Module13Entry.WinGoldText.text=Module13Entry.ShowText(0)
        self.CheckFree();
    end
    self.isShowNormal = true;
end
function Module13_Result.ShowBigWin()
    --BigWin奖
    if self.isShowBigWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= Module13Entry.ResultData.WinScore then
            self.currentRunGold = Module13Entry.ResultData.WinScore;
        end
        Module13Entry.bigWinNum.text = Module13Entry.ShowText(self.currentRunGold);
        if self.timer >= Module13_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function Module13_Result.ShowSuperWinffect()
    --Super奖动画
    --Module13_Audio.PlaySound(Module13_Audio.SoundList.SW, Module13_DataConfig.winGoldChangeRate);
    Module13Entry.superWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    Module13Entry.superWinNum.text = Module13Entry.ShowText(self.currentRunGold);
    Module13Entry.superWinNum.gameObject:SetActive(true);
    self.winRate = math.ceil(Module13Entry.ResultData.WinScore / (Module13_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    Module13Entry.SetSelfGold(Module13Entry.myGold);
    self.showResultCallback = function()
        Module13Entry.superWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowSuperWin = false;
        Module13_Result.CheckFree();
    end
    self.isShowSuperWin = true;
end
function Module13_Result.ShowSuperWin()
    --Super奖
    if self.isShowSuperWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= Module13Entry.ResultData.WinScore then
            self.currentRunGold = Module13Entry.ResultData.WinScore;
        end
        Module13Entry.superWinNum.text = Module13Entry.ShowText(self.currentRunGold);
        if self.timer >= Module13_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function Module13_Result.ShowMegaWinEffect()
    --Mega奖动画
    --Module13_Audio.PlaySound(Module13_Audio.SoundList.MW, Module13_DataConfig.winGoldChangeRate);
    Module13Entry.megaWinEffect.gameObject:SetActive(true);
    self.timer = 0;
    self.currentRunGold = 0;
    Module13Entry.megaWinNum.text = Module13Entry.ShowText(self.currentRunGold);
    Module13Entry.megaWinNum.gameObject:SetActive(true);
    self.winRate = math.ceil(Module13Entry.ResultData.WinScore / (Module13_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    Module13Entry.SetSelfGold(Module13Entry.myGold);
    self.showResultCallback = function()
        Module13Entry.megaWinEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowMageWin = false;
        Module13_Result.CheckFree();
    end
    self.isShowMageWin = true;
end
function Module13_Result.ShowMegaWin()
    --Mega奖
    if self.isShowMageWin then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= Module13Entry.ResultData.WinScore then
            self.currentRunGold = Module13Entry.ResultData.WinScore;
        end
        Module13Entry.megaWinNum.text = Module13Entry.ShowText(self.currentRunGold);
        if self.timer >= Module13_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function Module13_Result.ShowNormalEffect()
    self.timer = 0;    
    self.currentRunGold = 0;
    Module13Entry.SetSelfGold(Module13Entry.myGold);
    Module13Entry.WinGoldText.text=Module13Entry.ShowText(Module13Entry.ResultData.WinScore)
    Module13Entry.WinGold.gameObject:SetActive(true)
    Module13_Audio.PlaySound(Module13_Audio.SoundList.WSGame);
    self.winRate = math.ceil(Module13Entry.ResultData.WinScore / (Module13_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    self.showResultCallback = nil;
    self.showResultCallback = function()
        self.isShowNormal = false;
        self.timer = 0;
         Module13Entry.WinGold.gameObject:SetActive(false)
         Module13Entry.WinGoldText.text=Module13Entry.ShowText(0)
        self.CheckFree();
    end
    self.isShowNormal = true;
end
function Module13_Result.ShowNormal()
    if self.isShowNormal then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= Module13Entry.ResultData.WinScore then
            self.currentRunGold = Module13Entry.ResultData.WinScore;
        end
        Module13Entry.WinGoldText.text = Module13Entry.ShowText(self.currentRunGold);
        Module13Entry.WinNum.text = Module13Entry.ShowText(self.currentRunGold);
        if self.timer >= Module13_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end