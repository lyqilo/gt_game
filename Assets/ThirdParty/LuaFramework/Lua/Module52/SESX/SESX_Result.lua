SESX_Result = {};

local self = SESX_Result;

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

function SESX_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = false;
    self.isPause = false;
end
function SESX_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    self.winRate = 0;
    self.isShow = true;
    SESXEntry.myGold = TableUserInfo._7wGold;
    SESXEntry.WinNum.text = SESXEntry.ShowText(SESXEntry.ResultData.WinScore);
    --其他正常模式
    if SESXEntry.isFreeGame then
        log(self.totalFreeGold);
        log(SESXEntry.ResultData.WinScore)
        self.totalFreeGold = self.totalFreeGold + SESXEntry.ResultData.WinScore;
    end
    if SESXEntry.ResultData.WinScore > 0 then
        SESX_Line.Show();
        SESXEntry.resultEffect.gameObject:SetActive(true);
        local rate = SESXEntry.ResultData.m_nWinPeiLv / SESX_DataConfig.ALLLINECOUNT;
        if rate < 5 then
            --普通奖  不做显示    
            self.ShowNormalEffect()
        elseif rate >= 5 and rate < 10 then
            --bigWin
            self.ShowBigWinffect();
        elseif rate >= 10 and rate < 15 then
            --megawin
            self.ShowMegaWinffect();
        elseif rate >= 15 and rate < 40 then
            --superwin
            self.ShowSuperWinffect();
        elseif rate >= 40 and rate < 50 then
            --epicwin
            self.ShowEpicWinffect();
        elseif SESXEntry.ResultData.m_nPrizePoolWildGold > 0 then
            --jackpot
            self.ShowJackpotWinffect();
        end
    else
        SESXEntry.DelayCall(SESX_DataConfig.autoNoRewardInterval):OnComplete(function()
            self.CheckFree();
        end);
        SESXEntry.SetSelfGold(SESXEntry.myGold);
    end
end
function SESX_Result.PlayResultSound()
    --遍历第一线 判断图标
    local haslong = false;
    local showlist = SESX_DataConfig.Line[SESX_Line.showTable[1]];
    local elem = SESXEntry.ResultData.ImgTable[showlist[1]];
    if elem == 13 then
        haslong = true;
    end
    if not haslong then
        for i = 1, #SESX_Line.showItemTable do
            for j = 1, #SESX_Line.showItemTable[i] do
                local childName = SESX_Line.showItemTable[i][j].name;
                if childName == "Item13" or childName == "Item13_1" or childName == "Item13_2" or childName == "Item13_3" then
                    haslong = true;
                end
            end
        end
    end
    if haslong then
        log("有龙音效");
        SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_Wild);
    else
        if elem == 1 then
            --鼠奖音效
            log("鼠奖音效");
            SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_Normal_Mouse);
        elseif elem == 2 then
            --牛奖音效
            log("牛奖音效");
            SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_Normal_Cattle);
        elseif elem == 3 then
            --兔奖音效
            log("兔奖音效");
            SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_Normal_Rabbit);
        elseif elem == 4 or elem == 5 or elem == 6 then
            --羊马蛇奖音效
            log("羊马蛇奖音效");
            SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_Normal_YMS);
        elseif elem == 7 or elem == 8 or elem == 9 or elem == 10 then
            --猴鸡狗猪奖音效
            log("猴鸡狗猪奖音效");
            SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_Normal_Win);
        elseif elem == 11 then
            --jackpot音效
            log("jackpot音效");
            SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_Jackpot_Win);
        else
            --其他音效
            log("其他音效");
            SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_Normal_Win);
        end
    end
end
function SESX_Result.HideResult()
    for i = 1, SESXEntry.resultEffect.childCount do
        SESXEntry.resultEffect:GetChild(i - 1).gameObject:SetActive(false);
    end
    SESXEntry.resultEffect.gameObject:SetActive(false);
    self.timer = 0;
    self.showCSJLCallback = nil;
    self.showResultCallback = nil;
end

function SESX_Result.CheckFree()
    SESXEntry.isRoll = false;
    if not SESXEntry.isFreeGame then
        if SESXEntry.freeCount > 0 then
            SESX_Line.Close();
            --进入免费
            self.ShowFreeEffect(false);
        else
            SESXEntry.FreeRoll();
        end
    else
        if SESXEntry.freeCount <= 0 then
            SESX_Audio.PlayBGM();
            SESXEntry.FreeRoll();
        else
            if SESXEntry.isDouble then
                SESXEntry.FreeRoll();
            else
                log("移动龙");
                self.MoveLong();
            end
        end
    end
end
function SESX_Result.ShowFreeEffect(isscene)
    --展示免费
    SESXEntry.isFreeGame = true;
    for i = 1, #SESXEntry.ScatterList do
        SESXEntry.ScatterList[i].transform:Find("Anim"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "zhengdong", true);
    end
    local time = isscene and 1 or 3;
    SESXEntry.freeText.text = ShowRichText(SESXEntry.freeCount);
    SESX_Audio.PlayBGM(SESX_Audio.SoundList.FreeBGM);
    SESXEntry.DelayCall(time):OnComplete(function()
        SESX_Line.CloseScatter();
        SESXEntry.resultEffect.gameObject:SetActive(true);
        SESXEntry.EnterFreeEffect.gameObject:SetActive(true);
        SESXEntry.EnterFreeEffectAnim.AnimationState:SetAnimation(0, "animation", false);
        SESXEntry.FreeContent.gameObject:SetActive(true);
        SESXEntry.stopState.gameObject:SetActive(false);
        SESXEntry.startState.gameObject:SetActive(false);
        SESXEntry.startBtn.interactable = false;
        SESXEntry.openChipBtn.interactable = false;
        SESXEntry.currentFreeCount = 0;
        SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_Wild_Win);
        --展示画卷
        SESXEntry.DelayCall(SESX_DataConfig.freeLoadingShowTime):OnComplete(function()
            --龙下来
            SESXEntry.EnterFreeEffect.gameObject:SetActive(false);
            self.EnterFreeEffect();
        end);
    end);
end
function SESX_Result.EnterFreeEffect()
    if SESXEntry.freeCount <= 0 then
        return ;
    end
    SESXEntry.CurrentMoveLongIndex = SESXEntry.freeCount;
    SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_Wild_First);
    self.DownLong(5 - SESXEntry.CurrentMoveLongIndex + 1, 5):OnComplete(function()
        if SESXEntry.isDouble then
            SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_Wild_Second);
            self.DownLong(2, 2.5):OnComplete(function()
                SESXEntry.FreeRoll();
            end);
        else
            SESXEntry.FreeRoll();
        end
    end);
end
function SESX_Result.DownLong(count, timer)
    local longgroup = SESXEntry.CSGroup:GetChild(5 - count);
    for i = 1, longgroup.childCount do
        longgroup:GetChild(i - 1):Find("Icon"):GetComponent("Image").sprite = SESXEntry.icons:Find(SESX_DataConfig.IconTable[13 + i]):GetComponent("Image").sprite;
        longgroup:GetChild(i - 1):Find("Icon"):GetComponent("Image"):SetNativeSize();
    end
    local pos = longgroup.localPosition;
    longgroup.localPosition = Vector3.New(pos.x, pos.y + 465, 0);
    SESXEntry.RollContent:GetChild(5 - count):GetComponent("CanvasGroup").alpha = 0;
    longgroup:GetComponent("CanvasGroup").alpha = 1;
    local tweener = longgroup:DOLocalMove(pos, timer):SetEase(DG.Tweening.Ease.Linear);
    return tweener;
end
function SESX_Result.MoveLong()
    --TODO 交换位置  改变icon
    if SESXEntry.CurrentMoveLongIndex <= 1 then
        return ;
    end
    SESX_Line.Close();
    SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_Wild_Move);
    SESXEntry.CSGroup:GetChild(SESXEntry.CurrentMoveLongIndex - 2):GetComponent("CanvasGroup").alpha = 1;
    SESXEntry.RollContent:GetChild(SESXEntry.CurrentMoveLongIndex - 2):GetComponent("CanvasGroup").alpha = 0;
    local jump1 = SESXEntry.CSGroup:GetChild(SESXEntry.CurrentMoveLongIndex - 1);
    local jump2 = SESXEntry.CSGroup:GetChild(SESXEntry.CurrentMoveLongIndex - 2);
    SESXEntry.CSGroup:GetChild(SESXEntry.CurrentMoveLongIndex - 1):DOLocalJump(jump2.localPosition, jump2.localPosition.y + 50, 1, 1):SetEase(DG.Tweening.Ease.Linear);
    SESXEntry.CSGroup:GetChild(SESXEntry.CurrentMoveLongIndex - 2):DOLocalJump(jump1.localPosition, jump1.localPosition.y - 20, 1, 1):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        --TODO 将旋转图片改掉
        local iconParent = SESX_Roll.rollList[SESXEntry.CurrentMoveLongIndex].content;
        local csIconParent = SESXEntry.CSGroup:GetChild(SESXEntry.CurrentMoveLongIndex - 1);
        for i = 0, csIconParent.childCount - 1 do
            iconParent:GetChild(i):Find("Icon"):GetComponent("Image").sprite = csIconParent:GetChild(i):Find("Icon"):GetComponent("Image").sprite;
            iconParent:GetChild(i):Find("Icon"):GetComponent("Image"):SetNativeSize();
        end
        SESXEntry.CSGroup:GetChild(SESXEntry.CurrentMoveLongIndex - 1):GetComponent("CanvasGroup").alpha = 0;
        SESXEntry.RollContent:GetChild(SESXEntry.CurrentMoveLongIndex - 1):GetComponent("CanvasGroup").alpha = 1;
        SESXEntry.CurrentMoveLongIndex = SESXEntry.CurrentMoveLongIndex - 1;
        SESXEntry.DelayCall(1):OnComplete(function()
            SESXEntry.FreeRoll();
        end);
    end);
    SESXEntry.CSGroup:GetChild(SESXEntry.CurrentMoveLongIndex - 1):SetSiblingIndex(SESXEntry.CurrentMoveLongIndex - 2);
end
---------------------中奖---------------------
function SESX_Result.ShowJackpotWinffect()
    --Jackpot奖动画
    SESXEntry.jackpotWinEffect.gameObject:SetActive(true);
    SESXEntry.scoreEffect.gameObject:SetActive(true);
    SESXEntry.winLightEffect.gameObject:SetActive(true);
    SESXEntry.jackpotWinAnim.AnimationState:SetAnimation(0, "start", false);
    SESXEntry.jackpotWinAnim.AnimationState:AddAnimation(0, "loop", true, 0);
    SESXEntry.jackpotWinNum.text = SESXEntry.ShowText(0);
    SESXEntry.scoreEffect.AnimationState:SetAnimation(0, "start", false);
    SESXEntry.scoreEffect.AnimationState:AddAnimation(0, "loop", true, 0);
    SESXEntry.winLightEffect.AnimationState:SetAnimation(0, "animation", false);
    SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_Jackpot_Win);
    Util.RunWinScore(0, SESXEntry.ResultData.m_nPrizePoolGold, SESX_DataConfig.winBigGoldChangeRate, function(value)
        local v = Mathf.Ceil(value);
        SESXEntry.jackpotWinNum.text = SESXEntry.ShowText(v);
    end):OnComplete(function()
        SESXEntry.SetSelfGold(SESXEntry.myGold);
        SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_AddCoin);
        SESXEntry.jackpotWinEffect.gameObject:SetActive(false);
        SESXEntry.scoreEffect.gameObject:SetActive(false);
        SESXEntry.winLightEffect.gameObject:SetActive(false);
        SESX_Result.CheckFree();
    end):SetEase(DG.Tweening.Ease.Linear);
end
function SESX_Result.ShowBigWinffect()
    --Big奖动画
    SESXEntry.bigWinEffect.gameObject:SetActive(true);
    SESXEntry.scoreEffect.gameObject:SetActive(true);
    SESXEntry.winLightEffect.gameObject:SetActive(true);
    SESXEntry.bigWinAnim.AnimationState:SetAnimation(0, "start", false);
    SESXEntry.bigWinAnim.AnimationState:AddAnimation(0, "loop", true, 0);
    SESXEntry.scoreEffect.AnimationState:SetAnimation(0, "start", false);
    SESXEntry.scoreEffect.AnimationState:AddAnimation(0, "loop", true, 0);
    SESXEntry.winLightEffect.AnimationState:SetAnimation(0, "animation", false);
    SESXEntry.bigWinNum.text = SESXEntry.ShowText(0);
    SESX_Audio.PlaySound(SESX_Audio.SoundList.Flame_BigWin);
    Util.RunWinScore(0, SESXEntry.ResultData.WinScore, SESX_DataConfig.winBigGoldChangeRate, function(value)
        local v = Mathf.Ceil(value);
        SESXEntry.bigWinNum.text = SESXEntry.ShowText(v);
    end):OnComplete(function()
        SESXEntry.SetSelfGold(SESXEntry.myGold);
        SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_AddCoin);
        SESXEntry.DelayCall(1):OnComplete(function()
            SESXEntry.bigWinEffect.gameObject:SetActive(false);
            SESXEntry.scoreEffect.gameObject:SetActive(false);
            SESXEntry.winLightEffect.gameObject:SetActive(false);
            SESX_Result.CheckFree();
        end);
    end):SetEase(DG.Tweening.Ease.Linear);
end

function SESX_Result.ShowMegaWinffect()
    --Mega奖动画
    SESXEntry.megaWinEffect.gameObject:SetActive(true);
    SESXEntry.scoreEffect.gameObject:SetActive(true);
    SESXEntry.winLightEffect.gameObject:SetActive(true);
    SESXEntry.megaWinAnim.AnimationState:SetAnimation(0, "start", false);
    SESXEntry.megaWinAnim.AnimationState:AddAnimation(0, "loop", true, 0);
    SESXEntry.scoreEffect.AnimationState:SetAnimation(0, "start", false);
    SESXEntry.scoreEffect.AnimationState:AddAnimation(0, "loop", true, 0);
    SESXEntry.winLightEffect.AnimationState:SetAnimation(0, "animation", false);
    SESXEntry.megaWinNum.text = SESXEntry.ShowText(0);
    SESX_Audio.PlaySound(SESX_Audio.SoundList.Flame_BigWin);
    Util.RunWinScore(0, SESXEntry.ResultData.WinScore, SESX_DataConfig.winBigGoldChangeRate, function(value)
        local v = Mathf.Ceil(value);
        SESXEntry.megaWinNum.text = SESXEntry.ShowText(v);
    end):OnComplete(function()
        SESXEntry.SetSelfGold(SESXEntry.myGold);
        SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_AddCoin);
        SESXEntry.DelayCall(1):OnComplete(function()
            SESXEntry.megaWinEffect.gameObject:SetActive(false);
            SESXEntry.scoreEffect.gameObject:SetActive(false);
            SESXEntry.winLightEffect.gameObject:SetActive(false);
            SESX_Result.CheckFree();
        end);
    end):SetEase(DG.Tweening.Ease.Linear);
end
function SESX_Result.ShowSuperWinffect()
    --Super奖动画
    SESXEntry.superWinEffect.gameObject:SetActive(true);
    SESXEntry.scoreEffect.gameObject:SetActive(true);
    SESXEntry.winLightEffect.gameObject:SetActive(true);
    SESXEntry.superWinAnim.AnimationState:SetAnimation(0, "start", false);
    SESXEntry.superWinAnim.AnimationState:AddAnimation(0, "loop", true, 0);
    SESXEntry.scoreEffect.AnimationState:SetAnimation(0, "start", false);
    SESXEntry.scoreEffect.AnimationState:AddAnimation(0, "loop", true, 0);
    SESXEntry.winLightEffect.AnimationState:SetAnimation(0, "animation", false);
    SESXEntry.superWinNum.text = SESXEntry.ShowText(0);
    SESX_Audio.PlaySound(SESX_Audio.SoundList.Flame_BigWin);
    Util.RunWinScore(0, SESXEntry.ResultData.WinScore, SESX_DataConfig.winBigGoldChangeRate, function(value)
        local v = Mathf.Ceil(value);
        SESXEntry.superWinNum.text = SESXEntry.ShowText(v);
    end):OnComplete(function()
        SESXEntry.SetSelfGold(SESXEntry.myGold);
        SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_AddCoin);
        SESXEntry.DelayCall(1):OnComplete(function()
            SESXEntry.superWinEffect.gameObject:SetActive(false);
            SESXEntry.scoreEffect.gameObject:SetActive(false);
            SESXEntry.winLightEffect.gameObject:SetActive(false);
            SESX_Result.CheckFree();
        end);
    end):SetEase(DG.Tweening.Ease.Linear);
end

function SESX_Result.ShowEpicWinffect()
    --Epic奖动画
    SESXEntry.epicWinEffect.gameObject:SetActive(true);
    SESXEntry.scoreEffect.gameObject:SetActive(true);
    SESXEntry.winLightEffect.gameObject:SetActive(true);
    SESXEntry.epicWinAnim.AnimationState:SetAnimation(0, "start", false);
    SESXEntry.epicWinAnim.AnimationState:AddAnimation(0, "loop", true, 0);
    SESXEntry.scoreEffect.AnimationState:SetAnimation(0, "start", false);
    SESXEntry.scoreEffect.AnimationState:AddAnimation(0, "loop", true, 0);
    SESXEntry.winLightEffect.AnimationState:SetAnimation(0, "animation", false);
    SESXEntry.epicWinNum.text = SESXEntry.ShowText(0);
    SESX_Audio.PlaySound(SESX_Audio.SoundList.Flame_BigWin);
    Util.RunWinScore(0, SESXEntry.ResultData.WinScore, SESX_DataConfig.winBigGoldChangeRate, function(value)
        local v = Mathf.Ceil(value);
        SESXEntry.epicWinNum.text = SESXEntry.ShowText(v);
    end):OnComplete(function()
        SESXEntry.SetSelfGold(SESXEntry.myGold);
        SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_AddCoin);
        SESXEntry.DelayCall(1):OnComplete(function()
            SESXEntry.epicWinEffect.gameObject:SetActive(false);
            SESXEntry.scoreEffect.gameObject:SetActive(false);
            SESXEntry.winLightEffect.gameObject:SetActive(false);
            SESX_Result.CheckFree();
        end);
    end):SetEase(DG.Tweening.Ease.Linear);
end
function SESX_Result.ShowNormalEffect()
    self.timer = 0;
    self.currentRunGold = 0;
    SESXEntry.normalWinEffect.gameObject:SetActive(true);
    SESXEntry.normalWinAnim.AnimationState:SetAnimation(0, "animation", false);
    SESXEntry.normalWinNum.text = SESXEntry.ShowText(SESXEntry.ResultData.WinScore);
    SESXEntry.normalWinNum.gameObject:SetActive(true);
    self.PlayResultSound();
    SESXEntry.DelayCall(2):OnComplete(function()
        SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_AddCoin);
    end);
    SESXEntry.DelayCall(SESX_DataConfig.winGoldChangeRate):OnComplete(function()
        SESXEntry.SetSelfGold(SESXEntry.myGold);
        SESXEntry.normalWinEffect.gameObject:SetActive(false);
        self.CheckFree();
    end);
end