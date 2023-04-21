XMZZ_Result = {};

local self = XMZZ_Result;

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



function XMZZ_Result.Init()
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.currentRunGold = 0;

end
function XMZZ_Result.ShowResult()
    --TODO 判断中奖
    --如果是 中小游戏类型（财神降临）
    self.showResultCallback = nil;
    self.showCSJLCallback = nil;
    self.timer = 0;
    self.currentRunGold = 0;
    XMZZEntry.myGold = TableUserInfo._7wGold;
    if XMZZEntry.ResultData.WinScore > 0 then
        XMZZ_Line.Show();
        XMZZEntry.winNum.text = XMZZEntry.ShowText(XMZZEntry.ResultData.WinScore);
        local rate = XMZZEntry.ResultData.WinScore / (XMZZ_DataConfig.ALLLINECOUNT * XMZZEntry.CurrentChip);
        if rate <= 6 then
            self.ShowNormalEffect();
        elseif rate > 6 and rate <= 10 then
            --superwin
            self.ShowMiddleWinEffect();
        else
            --superwin
            self.ShowBigWinEffect();
        end
    else
        XMZZEntry.DelayCall(XMZZ_DataConfig.autoNoRewardInterval, function()
            XMZZEntry.SetSelfGold(XMZZEntry.myGold);
            XMZZEntry.CheckState();
        end);
    end
end
function XMZZ_Result.ShowFreeEffect()
    if XMZZEntry.freeCount <= 0 then
        return ;
    end
    self.StartDownLong(6 - XMZZEntry.CurrentMoveLongIndex, 1);
end
function XMZZ_Result.StartDownLong(count, timer)
    XMZZ_Line.Close();
    self.DownLong(count, timer):OnComplete(function()
        if XMZZEntry.freeType == 1 then
            if XMZZEntry.isScene then
                XMZZEntry.FreeRollState();
            else
                XMZZEntry.CheckState();
            end
        else
            if count < XMZZEntry.freeWildCount then
                if XMZZEntry.isScene then
                    XMZZEntry.CurrentMoveLongIndex = XMZZEntry.CurrentMoveLongIndex - 1;
                    self.StartDownLong(count + 1, timer);
                else
                    XMZZEntry.FreeRollState();
                end
            else
                if XMZZEntry.isScene then
                    XMZZEntry.CurrentMoveLongIndex = XMZZEntry.CurrentMoveLongIndex - 1;
                    XMZZEntry.FreeRollState();
                else
                    XMZZEntry.CheckState();
                end
            end
        end
    end);
end
function XMZZ_Result.DownLong(count, timer)
    local longgroup = XMZZEntry.CSGroup:GetChild(5 - count);
    for i = 1, longgroup.childCount do
        longgroup:GetChild(i - 1):Find("Icon"):GetComponent("Image").sprite = XMZZEntry.icons:Find(XMZZ_DataConfig.IconTable[10 + i]):GetComponent("Image").sprite;
        longgroup:GetChild(i - 1):Find("Icon"):GetComponent("Image"):SetNativeSize();
    end
    local pos = longgroup.localPosition;
    longgroup.localPosition = Vector3.New(pos.x, pos.y + 465, 0);
    XMZZEntry.RollContent:GetChild(5 - count):GetComponent("CanvasGroup").alpha = 0;
    longgroup:GetComponent("CanvasGroup").alpha = 1;
    local tweener = longgroup:DOLocalMove(pos, timer):SetEase(DG.Tweening.Ease.Linear);
    return tweener;
end
function XMZZ_Result.MoveLong()
    --TODO 交换位置  改变icon
    if XMZZEntry.CurrentMoveLongIndex <= 1 then
        return ;
    end
    XMZZ_Line.Close();
    XMZZEntry.CSGroup:GetChild(XMZZEntry.CurrentMoveLongIndex - 2):GetComponent("CanvasGroup").alpha = 1;
    XMZZEntry.RollContent:GetChild(XMZZEntry.CurrentMoveLongIndex - 2):GetComponent("CanvasGroup").alpha = 0;
    local jump1 = XMZZEntry.CSGroup:GetChild(XMZZEntry.CurrentMoveLongIndex - 1);
    local jump2 = XMZZEntry.CSGroup:GetChild(XMZZEntry.CurrentMoveLongIndex - 2);
    XMZZEntry.CSGroup:GetChild(XMZZEntry.CurrentMoveLongIndex - 1):DOLocalJump(Vector3.New(XMZZ_DataConfig.CSRollPos[XMZZEntry.CurrentMoveLongIndex - 1], 0, 0), jump2.localPosition.y + 0, 1, 1):SetEase(DG.Tweening.Ease.Linear);
    XMZZEntry.CSGroup:GetChild(XMZZEntry.CurrentMoveLongIndex - 2):DOLocalJump(Vector3.New(XMZZ_DataConfig.CSRollPos[XMZZEntry.CurrentMoveLongIndex], 0, 0), jump1.localPosition.y - 0, 1, 1):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        --TODO 将旋转图片改掉
        local iconParent = XMZZ_Roll.rollList[XMZZEntry.CurrentMoveLongIndex].content;
        local csIconParent = XMZZEntry.CSGroup:GetChild(XMZZEntry.CurrentMoveLongIndex - 1);
        for i = 0, csIconParent.childCount - 1 do
            iconParent:GetChild(i):Find("Icon"):GetComponent("Image").sprite = csIconParent:GetChild(i):Find("Icon"):GetComponent("Image").sprite;
            iconParent:GetChild(i):Find("Icon"):GetComponent("Image"):SetNativeSize();
        end
        XMZZEntry.CSGroup:GetChild(XMZZEntry.CurrentMoveLongIndex - 1):GetComponent("CanvasGroup").alpha = 0;
        XMZZEntry.RollContent:GetChild(XMZZEntry.CurrentMoveLongIndex - 1):GetComponent("CanvasGroup").alpha = 1;
        XMZZEntry.CurrentMoveLongIndex = XMZZEntry.CurrentMoveLongIndex - 1;
        XMZZEntry.DelayCall(1):OnComplete(function()
            XMZZEntry.FreeRollState();
        end);
    end);
    XMZZEntry.CSGroup:GetChild(XMZZEntry.CurrentMoveLongIndex - 1):SetSiblingIndex(XMZZEntry.CurrentMoveLongIndex - 2);
end
---------------------中奖---------------------
function XMZZ_Result.ShowBigWinEffect()
    --BigWin奖动画
    self.currentRunGold = 0;
    XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.Panda_BigWin);
    XMZZEntry.bigEffect.gameObject:SetActive(true);
    XMZZEntry.bigEffectClose.gameObject:SetActive(true);
    local tweener = Util.RunWinScore(0, XMZZEntry.ResultData.WinScore, XMZZ_DataConfig.winBigGoldChangeRate, function(v)
        self.currentRunGold = math.ceil(v);
        XMZZEntry.bigEffectNum.text = XMZZEntry.ShowText(self.currentRunGold);
    end);
    tweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        XMZZEntry.bigEffectNum.text = XMZZEntry.ShowText(XMZZEntry.ResultData.WinScore);
        XMZZEntry.DelayCall(XMZZ_DataConfig.autoNoRewardInterval * 2, function()
            XMZZEntry.SetSelfGold(XMZZEntry.myGold);
            XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.Panda_FlyCoins);
            XMZZEntry.bigEffectClose.gameObject:SetActive(false);
            XMZZEntry.DelayCall(0.5, function()
                XMZZEntry.bigEffect.gameObject:SetActive(false);
                XMZZEntry.CheckState();
            end);
        end);
    end);

    XMZZEntry.bigEffectClose.onClick:RemoveAllListeners();
    XMZZEntry.bigEffectClose.onClick:AddListener(function()
        if (tweener ~= nil) then
            tweener:Kill();
        end
        XMZZEntry.bigEffectClose.gameObject:SetActive(false);
        XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.Panda_FlyCoins);
        XMZZEntry.bigEffectNum.text = XMZZEntry.ShowText(XMZZEntry.ResultData.WinScore);
        XMZZEntry.SetSelfGold(XMZZEntry.myGold);
        XMZZEntry.DelayCall(0.5, function()
            XMZZEntry.bigEffect.gameObject:SetActive(false);
            XMZZEntry.CheckState();
        end);
    end);
end
function XMZZ_Result.ShowMiddleWinEffect()
    --BigWin奖动画
    self.currentRunGold = 0;
    XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.Panda_BigWin);
    XMZZEntry.middleEffect.gameObject:SetActive(true);
    XMZZEntry.normalEffectClose.gameObject:SetActive(true);
    local tweener = Util.RunWinScore(0, XMZZEntry.ResultData.WinScore, XMZZ_DataConfig.winBigGoldChangeRate, function(v)
        self.currentRunGold = math.ceil(v);
        XMZZEntry.middleEffectNum.text = XMZZEntry.ShowText(self.currentRunGold);
    end);
    tweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        XMZZEntry.middleEffectNum.text = XMZZEntry.ShowText(XMZZEntry.ResultData.WinScore);
        XMZZEntry.DelayCall(XMZZ_DataConfig.autoNoRewardInterval * 2, function()
            XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.Panda_FlyCoins);
            XMZZEntry.SetSelfGold(XMZZEntry.myGold);
            XMZZEntry.normalEffectClose.gameObject:SetActive(false);
            XMZZEntry.DelayCall(0.5, function()
                XMZZEntry.middleEffect.gameObject:SetActive(false);
                XMZZEntry.CheckState();
            end);
        end);
    end);
    XMZZEntry.middleEffectClose.onClick:RemoveAllListeners();
    XMZZEntry.middleEffectClose.onClick:AddListener(function()
        if (tweener ~= nil) then
            tweener:Kill();
        end
        XMZZEntry.normalEffectClose.gameObject:SetActive(false);
        XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.Panda_FlyCoins);
        XMZZEntry.middleEffectNum.text = XMZZEntry.ShowText(XMZZEntry.ResultData.WinScore);
        XMZZEntry.SetSelfGold(XMZZEntry.myGold);
        XMZZEntry.DelayCall(0.5, function()
            XMZZEntry.middleEffect.gameObject:SetActive(false);
            XMZZEntry.CheckState();
        end);
    end);
end
function XMZZ_Result.ShowNormalEffect()
    self.currentRunGold = 0;
    XMZZEntry.normalEffect.gameObject:SetActive(true);
    XMZZEntry.normalEffectClose.gameObject:SetActive(true);
    XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.Panda_Normal_Win);
    local tweener = Util.RunWinScore(0, XMZZEntry.ResultData.WinScore, XMZZ_DataConfig.winGoldChangeRate, function(v)
        self.currentRunGold = math.ceil(v);
        XMZZEntry.normalEffectNum.text = XMZZEntry.ShowText(self.currentRunGold);
    end);
    tweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.Panda_FlyCoins);
        XMZZEntry.normalEffectNum.text = XMZZEntry.ShowText(XMZZEntry.ResultData.WinScore);
        XMZZEntry.DelayCall(XMZZ_DataConfig.autoNoRewardInterval * 2, function()
            XMZZEntry.SetSelfGold(XMZZEntry.myGold);
            XMZZEntry.normalEffectClose.gameObject:SetActive(false);
            XMZZEntry.DelayCall(0.5, function()
                XMZZEntry.normalEffect.gameObject:SetActive(false);
                XMZZEntry.CheckState();
            end);
        end);
    end);

    XMZZEntry.normalEffectClose.onClick:RemoveAllListeners();
    XMZZEntry.normalEffectClose.onClick:AddListener(function()
        if (tweener ~= nil) then
            tweener:Kill();
        end
        XMZZEntry.normalEffectClose.gameObject:SetActive(false);
        XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.Panda_FlyCoins);
        XMZZEntry.normalEffectNum.text = XMZZEntry.ShowText(XMZZEntry.ResultData.WinScore);
        XMZZEntry.SetSelfGold(XMZZEntry.myGold);
        XMZZEntry.DelayCall(0.5, function()
            XMZZEntry.normalEffect.gameObject:SetActive(false);
            XMZZEntry.CheckState();
        end);
    end);
end