FLM_Result = {};

local self = FLM_Result;

self.timer = 0;
self.isShow = false;

self.isPause = false;

self.isShowDJJY = false;--展示堆金积玉
self.waitNextDJJY = false;--等待下一次重转
self.showDJJYCallback = nil;--展示完回调

self.isShowDJJYResult = false;--展示财神奖励
self.winRate = 0;--赢的跑分比率
self.currentRunGold = 0;

self.isDJJY = false;--当前是否为堆金积玉

self.isShowFXGZ = false;--展示福星高照
self.isShowFLSQ = false;--展示福禄双全
self.isShowWFQQ = false;--展示五福齐全
self.isShowBFJZ = false;--展示百福具臻
self.isShowFMT = false;--展示福满堂
self.isShowNormal = false;--展示中奖
self.isHideNormal = false;--隐藏中奖
self.showResultCallback = nil;
self.hideNormalTime = 0.5;--退出动画时长

self.nowin = false;--没有得分
self.isFreeGame = false;--是否为免费游戏
self.showFreeTweener = nil;--免费财神动画tween
self.isShowFree = false;--展示免费
self.isHideFree = false;--隐藏免费
self.hideFreeTime = 0.2;--免费动画退出时长

self.totalFreeGold = 0;
self.isShowTotalFree = false;

function FLM_Result.Init()
    self.showResultCallback = nil;
    self.showDJJYCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = false;
    self.isPause = false;
end
function FLM_Result.ShowResult(isScene)
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showDJJYCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = true;
    FLMEntry.myGold = TableUserInfo._7wGold;
    if not self.isDJJY then
        FLMEntry.WinNum.text = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(FLMEntry.ResultData.WinScore));
        if FLMEntry.ResultData.GoldModeNum > 0 then
            --得财神
            self.isDJJY = true;
            self.ShowDJJYEffect();
        else
            --其他正常模式
            if FLMEntry.ResultData.fuType[2] > 0 then
                self.ShowFMTWinEffect();
            elseif FLMEntry.ResultData.allOpenRate > 499 then
                self.ShowBFJZWinEffect();
            elseif FLMEntry.ResultData.allOpenRate > 299 then
                self.ShowWFQQWinEffect();
            elseif FLMEntry.ResultData.allOpenRate > 199 then
                self.ShowFLSQWinEffect();
            elseif FLMEntry.ResultData.allOpenRate > 99 then
                self.ShowFXGZWinEffect();
            elseif FLMEntry.ResultData.allOpenRate >= 0 then
                if FLMEntry.ResultData.WinScore > 0 then
                    self.ShowNormalEffect();
                else
                    self.nowin = true;
                    FLMEntry.SetSelfGold(FLMEntry.myGold);
                end
            end
        end
    else
        if FLMEntry.ResultData.GoldModeNum > 0 then
            FLMEntry.WinNum.text = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(FLMEntry.ResultData.WinScore));
            --继续重转
            for i = 1, #FLMEntry.ResultData.ImgTable do
                if FLMEntry.ResultData.ImgTable[i] == 11 then
                    local column = math.floor((i - 1) / 5);--排
                    local raw = (i - 1) % 5;--列
                    local num = nil;
                    if FLMEntry.ResultData.GoldNum[i] == 1 then
                        --大福
                        num = FLMEntry.ShowText(FLMEntry.FormatNumberThousands("d"));
                    elseif FLMEntry.ResultData.GoldNum[i] == 2 then
                        --小福
                        num = FLMEntry.ShowText(FLMEntry.FormatNumberThousands("x"));
                    else
                        num = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(FLMEntry.ResultData.GoldNum[i]));
                    end
                    FLMEntry.CSGroup:GetChild(raw):GetChild(column):Find("Icon"):GetChild(0):GetComponent("TextMeshProUGUI").text = num;
                    FLMEntry.CSGroup:GetChild(raw):GetChild(column).gameObject:SetActive(true);

                end
            end
            self.showDJJYCallback = function()
                FLMEntry.DJJYRoll();
            end
            self.waitNextDJJY = true;
        else
            --堆金积玉结束
            self.ShowDJJYResultEffect();
        end
    end
end
function FLM_Result.HideResult()
    for i = 1, FLMEntry.resultEffect.childCount do
        FLMEntry.resultEffect:GetChild(i - 1).gameObject:SetActive(false);
    end
    self.showDJJYCallback = nil;
    self.showResultCallback = nil;
end
function FLM_Result.CheckFree(isScene)
    if not FLMEntry.isFreeGame then
        if FLMEntry.ResultData.FreeCount > 0 then
            FLM_Line.Close();
            self.ShowFreeEffect(isScene);
        else
            FLMEntry.FreeRoll();
        end
    else
        FLMEntry.FreeRoll();
        --if FLMEntry.ResultData.FreeCount <= 0 then
        --    self.ShowFreeResultEffect();
        --else
        --    self.totalFreeGold = self.totalFreeGold + FLMEntry.ResultData.WinScore;
        --    FLMEntry.FreeRoll();
        --end
    end
end
function FLM_Result.Update()
    if self.isPause then
        return ;
    end
    self.ShowDJJY();
    self.WaitRollAgainDJJY();

    self.ShowDJJYResult();
    self.ShowBFJZWin();
    self.ShowWFQQWin();
    self.ShowFLSQWin();
    self.ShowFXGZWin();
    self.ShowFMTWin();

    self.ShowNormal();
    self.HideNormal();

    self.ShowFree();
    self.ShowFreeResult();
    self.HideFree();

    self.NoWinWait();
end

function FLM_Result.NoWinWait()
    if self.nowin then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= FLM_DataConfig.autoNoRewardInterval then
            self.nowin = false;
            self.CheckFree();
        end
    end
end
----------------------财神--------------------------------
function FLM_Result.WaitRollAgainDJJY()
    --堆金积玉重转
    if self.waitNextDJJY then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= FLM_DataConfig.autoNoRewardInterval then
            self.waitNextDJJY = false;
            if self.showDJJYCallback ~= nil then
                self.showDJJYCallback();
            end
        end
    end
end
function FLM_Result.ShowDJJYEffect()
    --堆金积玉展示动画
    FLM_Audio.PlaySound(FLM_Audio.SoundList.Bell);
    FLMEntry.addChipBtn.interactable = false;
    FLMEntry.reduceChipBtn.interactable = false;
    FLMEntry.MaxChipBtn.interactable = false;
    FLMEntry.DJJYEffect.gameObject:SetActive(true);
    FLMEntry.DJJYEffect.AnimationState:SetAnimation(0, "ch_in", false);
    FLMEntry.DJJYEffect.AnimationState:AddAnimation(0, "ch_idle", true, 0);
    FLMEntry.CSGroup.gameObject:SetActive(true);
    for i = 1, FLMEntry.CSGroup.childCount do
        for j = 1, FLMEntry.CSGroup:GetChild(i - 1).childCount do
            FLMEntry.CSGroup:GetChild(i - 1):GetChild(j - 1).gameObject:SetActive(false);
        end
    end
    for i = 1, #FLMEntry.ResultData.ImgTable do--1
        if FLMEntry.ResultData.ImgTable[i] == 11 then
            local column = math.floor((i - 1) / 5);--排
            local raw = (i - 1) % 5;--列
            FLMEntry.CSGroup:GetChild(raw):GetChild(column).gameObject:SetActive(true);
            local num = nil;
            if FLMEntry.ResultData.GoldNum[i] == 1 then
                --大福
                num = FLMEntry.ShowText(FLMEntry.FormatNumberThousands("d"));
            elseif FLMEntry.ResultData.GoldNum[i] == 2 then
                --小福
                num = FLMEntry.ShowText(FLMEntry.FormatNumberThousands("x"));
            else
                num = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(FLMEntry.ResultData.GoldNum[i]));
            end
            FLMEntry.CSGroup:GetChild(raw):GetChild(column):Find("Icon"):GetChild(0):GetComponent("TextMeshProUGUI").text = num;
        end
    end
    self.showDJJYCallback = function()
        FLM_Audio.PlaySound(FLM_Audio.SoundList.NCoin);
        FLM_Audio.PlayBGM(FLM_Audio.SoundList.BGMCoin);
        FLMEntry.isRoll = false;
        FLMEntry.DJJYRoll();
    end;
    self.isShowDJJY = true;
end
function FLM_Result.ShowDJJY()
    --堆金积玉展示
    if self.isShowDJJY then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= FLM_DataConfig.smallGameLoadingShowTime then
            FLMEntry.DJJYEffect.gameObject:SetActive(false);
            if self.showDJJYCallback ~= nil then
                self.showDJJYCallback();
            end
            self.isShowDJJY = false;
        end
    end
end
------------------------堆金积玉结束---------------------------
function FLM_Result.ShowDJJYResultEffect()
    logYellow("====堆金积玉结束1====")

    self.isDJJY = false;
    local showNum = 0;
    local hideNum = 0;
    local totalwin = 0;
    local resultOver = false;
    for i = 1, FLMEntry.CSGroup.childCount do
        for j = 1, FLMEntry.CSGroup:GetChild(i - 1).childCount do
            local num = FLMEntry.CSGroup:GetChild(i - 1):GetChild(j - 1):Find("Icon"):GetChild(0):GetComponent("TextMeshProUGUI");
            if num.text ~= "" then
                showNum = showNum + 1;
                local go = newObject(num.gameObject);
                go.transform:SetParent(num.transform.parent);
                go.name=num.gameObject.name
                go.transform.localPosition = Vector3.New(0, 0, 0);
                go.transform.localRotation = Quaternion.identity;
                go.transform.localScale = Vector3.New(1, 1, 1);
                go.transform:DOMove(FLMEntry.WinNum.transform.position, 0.3):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                    totalwin = totalwin +tonumber(go.name) 

                    FLMEntry.WinNum.text =FLMEntry.ShowText(FLMEntry.FormatNumberThousands(totalwin)) --tostring(totalwin);

                    destroy(go.gameObject);

                    hideNum = hideNum + 1;

                    if hideNum == showNum then
                        resultOver = true;
                    end
                end);
            end
        end
    end
    logYellow("====堆金积玉结束2===="..tostring(resultOver))
    coroutine.start(function()
        coroutine.wait(0.4);
        logYellow("====堆金积玉结束3====")

        FLMEntry.addChipBtn.interactable = true;
        FLMEntry.reduceChipBtn.interactable = true;
        FLMEntry.MaxChipBtn.interactable = true;
        FLMEntry.winNormalEffect.gameObject:SetActive(true);
        FLMEntry.winNormalEffect.AnimationState:SetAnimation(0, "ch_in", false);
        FLMEntry.winNormalEffect.AnimationState:AddAnimation(0, "ch_idle", true, 0);
        self.winRate = math.ceil(FLMEntry.ResultData.WinScore / (FLM_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
        FLMEntry.SetSelfGold(FLMEntry.myGold);
        self.currentRunGold = 0;
        FLMEntry.winNormalNum.gameObject:SetActive(true);
        FLMEntry.winNormalNum.text = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(self.currentRunGold));
    logYellow("====堆金积玉结束4====")

        self.showDJJYCallback = function()
            FLM_Audio.PlayBGM();
            FLMEntry.CSGroup.gameObject:SetActive(false);
            FLMEntry.winNormalEffect.gameObject:SetActive(false);
            for i = 1, FLMEntry.CSGroup.childCount do
                for j = 1, FLMEntry.CSGroup:GetChild(i - 1).childCount do
                    FLMEntry.CSGroup:GetChild(i - 1):GetChild(j - 1).gameObject:SetActive(false);
                    FLMEntry.CSGroup:GetChild(i - 1):GetChild(j - 1):Find("Icon"):GetChild(0):GetComponent("TextMeshProUGUI").text = "";
                end
            end
            self.CheckFree();
        end
        FLM_Audio.PlaySound(FLM_Audio.SoundList.DS, FLM_DataConfig.smallGameLoadingShowTime);
        self.isShowDJJYResult = true;
    end);
end
function FLM_Result.ShowDJJYResult()
    --展示财神降临结果
    if self.isShowDJJYResult then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= FLMEntry.ResultData.WinScore then
            self.currentRunGold = FLMEntry.ResultData.WinScore;
        end
        FLMEntry.winNormalNum.text = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(self.currentRunGold));
        if self.timer >= FLM_DataConfig.smallGameLoadingShowTime then
            self.isShowDJJYResult = false;
            if self.showDJJYCallback ~= nil then
                self.showDJJYCallback();
            end
        end
    end
end

function FLM_Result.ShowFreeEffect(isScene)
    --展示免费
    FLMEntry.isFreeGame = true;
    FLM_Audio.PlayBGM(FLM_Audio.SoundList.BGMFree);
    FLM_Audio.PlaySound(FLM_Audio.SoundList.NFree);
    local bplist = {};
    if not isScene then
        for i = 1, #FLMEntry.ResultData.ImgTable do
            if FLMEntry.ResultData.ImgTable[i] == 10 then
                local column = math.floor((i - 1) / 5);
                local raw = math.floor((i - 1) % 5);
                local child = FLMEntry.RollContent.transform:GetChild(raw):GetComponent("ScrollRect").content:GetChild(column);
                local icon = child:Find("Icon");
                local bp = FLM_Line.CreateEffect("BP");
                bp.transform:SetParent(icon);
                icon:GetComponent("Image").enabled = false;
                bp.gameObject.name = "BP";
                bp.transform.localPosition = Vector3.New(0, 0, 0);
                bp.transform.localScale = Vector3.New(1, 1, 1);
                bp.transform.localRotation = Quaternion.identity;
                bp.gameObject:SetActive(true);
                bp.transform:GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "animation", true);
                table.insert(bplist, bp.gameObject);
            end
        end
        FLM_Audio.PlaySound(FLM_Audio.SoundList.FireCrackerExplose);
    end
    coroutine.start(function()
        coroutine.wait(1);
        for i = 1, #bplist do
            bplist[i].transform.parent:GetComponent("Image").enabled = true;
            FLM_Line.CollectEffect(bplist[i]);
        end
        FLMEntry.addChipBtn.interactable = false;
        FLMEntry.reduceChipBtn.interactable = false;
        FLMEntry.MaxChipBtn.interactable = false;
        FLMEntry.EnterFreeEffect.gameObject:SetActive(true);
        FLMEntry.EnterFreeEffect.AnimationState:SetAnimation(0, "animation", true);
        self.timer = 0;
        self.totalFreeGold = 0;
        self.showResultCallback = function()
            self.isHideFree = false;
            FLMEntry.EnterFreeEffect.gameObject:SetActive(false);
            self.CheckFree();
        end
        self.isShowFree = true;
    end);
end
function FLM_Result.ShowFree()
    if self.isShowFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= FLM_DataConfig.freeLoadingShowTime then
            self.isShowFree = false;
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end

function FLM_Result.HideFree()
    --隐藏中奖
    if self.isHideFree then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= self.hideFreeTime then
            --等待退出动画时长
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end

    end
end
function FLM_Result.ShowFreeResultEffect()
    --展示免费结果
    self.timer = 0;
    self.currentRunGold = 0;
    self.showResultCallback = function()
        self.isShowTotalFree = false;
        FLM_Audio.PlayBGM();
        FLMEntry.FreeResultEffect.gameObject:SetActive(false);
        self.timer = 0;
        FLMEntry.isFreeGame = false;
        self.CheckFree();
    end
    FLMEntry.FreeResultNum.text = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(self.currentRunGold));
    FLMEntry.FreeResultEffect.gameObject:SetActive(true);
    FLMEntry.FreeResultEffect.AnimationState:SetAnimation(0, "animation", true);
    FLMEntry.FreeResultNum.gameObject:SetActive(true);
    self.winRate = math.ceil(self.totalFreeGold / (FLM_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    FLMEntry.SetSelfGold(FLMEntry.myGold);
    self.isShowTotalFree = true;
end
function FLM_Result.ShowFreeResult()
    if self.isShowTotalFree then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= self.totalFreeGold then
            self.currentRunGold = self.totalFreeGold;
        end
        FLMEntry.FreeResultNum.text = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(self.currentRunGold));
        if self.timer >= FLM_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
---------------------中奖---------------------
function FLM_Result.ShowFXGZWinEffect()
    --福星高照奖动画
    FLM_Line.Show();
    FLM_Audio.PlaySound(FLM_Audio.SoundList.WinBig);
    FLM_Audio.PlaySound(FLM_Audio.SoundList.Coin_Collect);
    FLMEntry.FXGZEffect.gameObject:SetActive(true);
    FLMEntry.FXGZEffect.AnimationState:SetAnimation(0, "start", false);
    FLMEntry.FXGZEffect.AnimationState:AddAnimation(0, "loop", true, 0);
    self.timer = 0;
    self.currentRunGold = 0;
    FLMEntry.FXGZNum.text = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(self.currentRunGold));
    FLMEntry.FXGZNum.gameObject:SetActive(true);
    self.winRate = math.ceil(FLMEntry.ResultData.WinScore / (FLM_DataConfig.winBigGoldChangeRate / Time.deltaTime)) * 2;
    FLMEntry.SetSelfGold(FLMEntry.myGold);
    self.showResultCallback = function()
        FLMEntry.FXGZEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowFXGZ = false;
        FLM_Result.CheckFree();
    end
    self.isShowFXGZ = true;
end
function FLM_Result.ShowFXGZWin()
    --福星高照
    if self.isShowFXGZ then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= FLMEntry.ResultData.WinScore then
            self.currentRunGold = FLMEntry.ResultData.WinScore;
        end
        FLMEntry.FXGZNum.text = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(self.currentRunGold));
        if self.timer >= FLM_DataConfig.winBigGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function FLM_Result.ShowFLSQWinEffect()
    --福禄双全奖动画
    FLM_Line.Show();
    FLM_Audio.PlaySound(FLM_Audio.SoundList.WinBig);
    FLM_Audio.PlaySound(FLM_Audio.SoundList.Coin_Collect);
    FLMEntry.FLSQEffect.gameObject:SetActive(true);
    FLMEntry.FLSQEffect.AnimationState:SetAnimation(0, "start", false);
    FLMEntry.FLSQEffect.AnimationState:AddAnimation(0, "loop", true, 0);
    self.timer = 0;
    self.currentRunGold = 0;
    FLMEntry.FLSQNum.text = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(self.currentRunGold));
    FLMEntry.FLSQNum.gameObject:SetActive(true);
    self.winRate = math.ceil(FLMEntry.ResultData.WinScore / (FLM_DataConfig.winBigGoldChangeRate / Time.deltaTime)) * 2;
    FLMEntry.SetSelfGold(FLMEntry.myGold);
    self.showResultCallback = function()
        FLMEntry.FLSQEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowFLSQ = false;
        FLM_Result.CheckFree();
    end
    self.isShowFLSQ = true;
end
function FLM_Result.ShowFLSQWin()
    --福禄双全
    if self.isShowFLSQ then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= FLMEntry.ResultData.WinScore then
            self.currentRunGold = FLMEntry.ResultData.WinScore;
        end
        FLMEntry.FLSQNum.text = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(self.currentRunGold));
        if self.timer >= FLM_DataConfig.winBigGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function FLM_Result.ShowWFQQWinEffect()
    --五福齐全奖动画
    FLM_Line.Show();
    FLM_Audio.PlaySound(FLM_Audio.SoundList.WinBig);
    FLM_Audio.PlaySound(FLM_Audio.SoundList.Coin_Collect);
    FLMEntry.WFQQEffect.gameObject:SetActive(true);
    FLMEntry.WFQQEffect.AnimationState:SetAnimation(0, "start", false);
    FLMEntry.WFQQEffect.AnimationState:AddAnimation(0, "loop", true, 0);
    self.timer = 0;
    self.currentRunGold = 0;
    FLMEntry.WFQQNum.text = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(self.currentRunGold));
    FLMEntry.WFQQNum.gameObject:SetActive(true);
    self.winRate = math.ceil(FLMEntry.ResultData.WinScore / (FLM_DataConfig.winBigGoldChangeRate / Time.deltaTime)) * 2;
    FLMEntry.SetSelfGold(FLMEntry.myGold);
    self.showResultCallback = function()
        FLMEntry.WFQQEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowWFQQ = false;
        FLM_Result.CheckFree();
    end
    self.isShowWFQQ = true;
end
function FLM_Result.ShowWFQQWin()
    --五福齐全
    if self.isShowWFQQ then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= FLMEntry.ResultData.WinScore then
            self.currentRunGold = FLMEntry.ResultData.WinScore;
        end
        FLMEntry.WFQQNum.text = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(self.currentRunGold));
        if self.timer >= FLM_DataConfig.winBigGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function FLM_Result.ShowBFJZWinEffect()
    --百福具臻奖动画
    FLM_Line.Show();
    FLM_Audio.PlaySound(FLM_Audio.SoundList.WinBig);
    FLM_Audio.PlaySound(FLM_Audio.SoundList.Coin_Collect);
    FLMEntry.BFJZEffect.gameObject:SetActive(true);
    FLMEntry.BFJZEffect.AnimationState:SetAnimation(0, "start", false);
    FLMEntry.BFJZEffect.AnimationState:AddAnimation(0, "loop", true, 0);
    self.timer = 0;
    self.currentRunGold = 0;
    FLMEntry.BFJZNum.text = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(self.currentRunGold));
    FLMEntry.BFJZNum.gameObject:SetActive(true);
    self.winRate = math.ceil(FLMEntry.ResultData.WinScore / (FLM_DataConfig.winBigGoldChangeRate / Time.deltaTime)) * 2;
    FLMEntry.SetSelfGold(FLMEntry.myGold);
    self.showResultCallback = function()
        FLMEntry.BFJZEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowWFQQ = false;
        FLM_Result.CheckFree();
    end
    self.isShowWFQQ = true;
end
function FLM_Result.ShowBFJZWin()
    --百福具臻
    if self.isShowWFQQ then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= FLMEntry.ResultData.WinScore then
            self.currentRunGold = FLMEntry.ResultData.WinScore;
        end
        FLMEntry.BFJZNum.text = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(self.currentRunGold));
        if self.timer >= FLM_DataConfig.winBigGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function FLM_Result.ShowFMTWinEffect()
    --福满堂奖动画
    FLM_Line.Show();
    FLM_Audio.PlaySound(FLM_Audio.SoundList.Jackpot, FLM_DataConfig.winGoldChangeRate);
    FLMEntry.FMTEffect.gameObject:SetActive(true);
    FLMEntry.FMTEffect.AnimationState:SetAnimation(0, "start", false);
    FLMEntry.FMTEffect.AnimationState:AddAnimation(0, "loop", true, 0);
    self.timer = 0;
    self.currentRunGold = 0;
    FLMEntry.FMTNum.text = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(self.currentRunGold));
    FLMEntry.FMTNum.gameObject:SetActive(true);
    self.winRate = math.ceil(FLMEntry.ResultData.WinScore / (FLM_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    FLMEntry.SetSelfGold(FLMEntry.myGold);
    self.showResultCallback = function()
        FLMEntry.FMTEffect.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowFMT = false;
        FLM_Result.CheckFree();
    end
    self.isShowFMT = true;
end
function FLM_Result.ShowFMTWin()
    --福满堂
    if self.isShowFMT then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= FLMEntry.ResultData.WinScore then
            self.currentRunGold = FLMEntry.ResultData.WinScore;
        end
        FLMEntry.FMTNum.text = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(self.currentRunGold));
        if self.timer >= FLM_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function FLM_Result.ShowNormalEffect()
    --普通奖动画                    
    FLM_Line.Show();
    FLM_Audio.PlaySound(FLM_Audio.SoundList.Coin_Collect, FLM_DataConfig.winGoldChangeRate);

    FLMEntry.winNormalEffect.gameObject:SetActive(true);
    FLMEntry.winNormalEffect.AnimationState:SetAnimation(0, "ch_in", false);
    FLMEntry.winNormalEffect.AnimationState:AddAnimation(0, "ch_idle", true, 0);
    self.timer = 0;
    self.currentRunGold = 0;
    FLMEntry.winNormalNum.gameObject:SetActive(true);
    self.winRate = math.ceil(FLMEntry.ResultData.WinScore / (FLM_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    FLMEntry.SetSelfGold(FLMEntry.myGold);
    self.showResultCallback = function()
        FLMEntry.winNormalEffect.AnimationState:SetAnimation(0, "ch_out", false);
        FLMEntry.winNormalNum.gameObject:SetActive(false);
        self.timer = 0;
        self.isShowNormal = false;
        self.isHideNormal = true;
    end
    FLM_Audio.PlaySound(FLM_Audio.SoundList.Win, FLM_DataConfig.winGoldChangeRate);
    self.isShowNormal = true;
end
function FLM_Result.ShowNormal()
    --普通奖
    if self.isShowNormal then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= FLMEntry.ResultData.WinScore then
            self.currentRunGold = FLMEntry.ResultData.WinScore;
        end
        FLMEntry.winNormalNum.text = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(self.currentRunGold));
        if self.timer >= FLM_DataConfig.winGoldChangeRate then
            if self.showResultCallback ~= nil then
                self.showResultCallback();
            end
        end
    end
end
function FLM_Result.HideNormal()
    --隐藏中奖
    if self.isHideNormal then
        self.timer = self.timer + Time.deltaTime;
        if self.timer >= self.hideNormalTime then
            --等待退出动画时长
            self.isHideNormal = false;
            FLMEntry.winNormalEffect.gameObject:SetActive(false);
            self.CheckFree();
        end
    end
end