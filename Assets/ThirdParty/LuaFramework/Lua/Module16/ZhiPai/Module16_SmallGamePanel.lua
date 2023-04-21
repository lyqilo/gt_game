--Module16_SmallGamePanel *.lua
--Date
--此文件由[BabeLua]插件自动生成
--endregion
Module16_SmallGamePanel = {};

local self = Module16_SmallGamePanel;

local E_RATE_BASE = 1000; --基础倍数

local D_TIME_OPER = 60; --自动翻牌时间

local D_BASE_POKER_IDX = 2;
self.currentRunGold=0
local fun=nil
local fun2=nil
local fun3=nil

self.timer = 0;
self.winRate = 0;--赢的跑分比率
self.iGold = 0;

local ClickIndex=-1
--小游戏选择
self.CMD_CS_InsideGameChoose =
{
	--int GameResult;//0~6
    [1] = DataSize.Int32;
};

function Module16_SmallGamePanel:New(o)
    local t = o or {};
    setmetatable(t, self);
    self.__index = self
    return t;
end

function Module16_SmallGamePanel.Init(Obj)

end

function Module16_SmallGamePanel.Run()
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GF_GAME, Module16_Network.SUB_CS_INSIDEGAME, buffer, gameSocketNumber.GameSocket)
end

function Module16_SmallGamePanel.SmallEnter()

    fun3=coroutine.start(function()
        local go =Module16Entry.TipPanel:Find("SmallGameTip")
        go.gameObject:SetActive(true)
        Module16Entry.TipPanel.gameObject:SetActive(true)
        go:Find("tip"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "Ch_in", false);
        coroutine.wait(1)
        go:Find("tip"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "Ch_idle", false);
        coroutine.wait(1)
        go:Find("tip"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "Ch_out", false);
        coroutine.wait(1)
        Module16Entry.TipPanel.gameObject:SetActive(false)
        for i=1,Module16Entry.TipPanel.childCount do
            Module16Entry.TipPanel:GetChild(i-1).gameObject:SetActive(false)
        end
        Module16_SmallGamePanel.MainMove()
    end)
end

function Module16_SmallGamePanel.MainMove()
    local go=newObject(Module16Entry.smallGamePanel.gameObject)
    go.transform:SetParent(Module16Entry.transform:Find("Content"))
    go.transform.localPosition=Vector3.New(0,2000,0)
    go.transform.localScale=Vector3.New(1,1,1)
    self.transform = go.transform;
    self.transform:Find("BJ/bg"):GetComponent('RectTransform').sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
    self.winGoldNum=self.transform:Find("ImageSmallGame/SmallImages/ShowPos/ImageWinAnim/WinGold"):GetComponent("TextMeshProUGUI");
    self.bOpen=false
    self.transform.localEulerAngles = Vector3(0, 0, 0);
    self.transform.gameObject:SetActive(true)

    local dotween = self.transform:DOLocalMove(Vector3.New(0, 0, 0), 2.5);
    dotween:OnComplete(function()
        Module16_SmallGamePanel.PlayBeginAnim();
    end);
end

function Module16_SmallGamePanel.PlayBeginAnim()

    local fTImeMove = 2;
    local traBJ = self.transform:Find("BJ");
    local traImgSGame = self.transform:Find("ImageSmallGame");

    local dotween = traBJ:DOLocalMove(Vector3.New(0,0, 0), fTImeMove);
    traImgSGame:DOLocalMove(Vector3.New(0,-50, 0), fTImeMove);
    dotween:OnComplete(function()
        Module16_SmallGamePanel.UnfoldPoker();
    end);
end

--展开扑克
function Module16_SmallGamePanel.UnfoldPoker()
    local fTImeMove = 0.2;
    local traSamllImg = self.transform:Find("ImageSmallGame/SmallImages");
    local tabTraPokers = {};
    local sPokerPosName = "";
    local idx = 0;
    local pokerMoveNum = 0;
    self.resPoker = self.transform:Find('SmallPokes').gameObject
    for i = 1, Module16_DataConfig.SELECTSMALLCOUNT do
        local traPoker = traSamllImg:GetChild(0);
        idx = i - 1;
        sPokerPosName = "PokerPos" .. idx;
        traPoker.transform:SetParent(traSamllImg:Find(sPokerPosName));
        table.insert(tabTraPokers, traPoker);
        local dotween = traPoker.transform:DOLocalMove(Vector3.New(0, 0, 0), fTImeMove * i);
        traPoker.transform:GetComponent('Image').sprite = self.resPoker.transform:GetChild(i - 1):GetComponent('Image').sprite;
        traPoker:GetComponent("Image"):SetNativeSize();
        traPoker:GetComponent("Image").raycastTarget=false
        dotween:OnComplete(function()
            pokerMoveNum = pokerMoveNum + 1;
            if (Module16_DataConfig.SELECTSMALLCOUNT == pokerMoveNum) then
                for i = 0, #tabTraPokers-1 do
                    traSamllImg:Find("PokerPos" .. i):Find("Button"):GetComponent("Button").onClick:RemoveAllListeners();
                    traSamllImg:Find("PokerPos" .. i):Find("Button"):GetComponent("Button").onClick:AddListener(function ()
                        self.OnClickImgBtn(tabTraPokers[i+1])
                    end);
                end
                fun=coroutine.start(self.OperationTimer)
            end
        end);
    end
end
function Module16_SmallGamePanel.FixedUpdate()
end

function Module16_SmallGamePanel.Update()
    self.ShowSmallGameResult()
end

--操作定时器
function Module16_SmallGamePanel.OperationTimer()
    local waitTime = D_TIME_OPER
    while waitTime>0 do
        coroutine.wait(1)
        waitTime=waitTime-1
    end
    self.bOpen = true;
    local tra = self.transform:Find("ImageSmallGame/SmallImages");
    Module16_SmallGamePanel.PokerMove(tra:GetChild(D_BASE_POKER_IDX):Find("Sgame_Image" .. D_BASE_POKER_IDX), D_BASE_POKER_IDX);
    Module16_SmallGamePanel.SendSmallGameResult(D_BASE_POKER_IDX);
end
--0 2 
function Module16_SmallGamePanel.PokerMove(traPoker, iGridId)
    local iScaleRate = 1.5;
    local fTImeMove = 2;

    local traEnd = self.transform:Find("ImageSmallGame/SmallImages/ShowPos");
    traPoker.transform:SetParent(traEnd);

    local dotween = traPoker.transform:DOLocalMove(Vector3.New(0, 0, 0), fTImeMove, false);
    dotween:OnComplete(function()
        Module16_SmallGamePanel.PlayPokerAnim(traPoker, iGridId);
    end);
end


function Module16_SmallGamePanel.PlayPokerAnim(traPoker, iGridId)
    local resAnim =self.transform:Find('SGamePokerAnim') 
    local comAnim = self.SetAnimationForNotCreate(traPoker.gameObject, resAnim, 0.1);

    local funAnimEnd = function() --播放闪光动画  
        self.iGold = Module16Entry.SceneData.InsideGameResult[ClickIndex];
        local traWinAnim = traPoker.parent:Find("ImageWinAnim");
        traPoker.gameObject:SetActive(false);        
        Module16_SmallGamePanel.PlayWinAnim(traWinAnim, self.iGold);
    end

    comAnim:SetEndEvent(funAnimEnd);
    comAnim:Play();
end

function Module16_SmallGamePanel.PlayWinAnim(traWinAnim, iGold)
    self.currentRunGold=0
    self.winRate = math.ceil(iGold / (Module16_DataConfig.winGoldChangeRate / Time.deltaTime)) * 2;
    
    traWinAnim.gameObject:SetActive(true);

    local traLight = traWinAnim:Find("ImageLight");
    local fTimeEnd = 2;
    self.isShowNormal = true;
    Module16_Audio.PlaySound(Module16_Audio.SoundList.WSGame);

    traLight:GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "animation", true);
   fun2 = coroutine.start(function ()
        while fTimeEnd > 0 do
            coroutine.wait(0.5)
            fTimeEnd=fTimeEnd-0.5
        end
        self.SmallGameEnd()
    end)
end

function Module16_SmallGamePanel.OnClickImgBtn(btn)
        logYellow("btn name = " .. btn.name);
        if (self.bOpen) then 
            return; 
        end
        local traPos = btn.transform.parent;
        local iGrid = traPos:GetSiblingIndex();
        local sPokerName = "Sgame_Image" .. iGrid;
        Module16_SmallGamePanel.PokerMove(traPos:Find(sPokerName), iGrid);
        Module16_SmallGamePanel.SendSmallGameResult(iGrid);
        self.bOpen = true;
end

function Module16_SmallGamePanel.SendSmallGameResult(iGrid)
    ClickIndex=tonumber(iGrid+1)

    local Data = {[1] = iGrid,}
    local buffer = SetC2SInfo(self.CMD_CS_InsideGameChoose, Data);
    logTable(Data)
    Network.Send(MH.MDM_GF_GAME, Module16_Network.SUB_CS_INSIDEGAME_CHOOSE, buffer, gameSocketNumber.GameSocket);
    logYellow("发送小游戏选则");
end

function Module16_SmallGamePanel.SetAnimationForNotCreate(objAnim, resImg, fSep)

    local comAnim = objAnim.gameObject:AddComponent(typeof(ImageAnima)); --GameObject("tGO"); 

    if (fSep) then
        comAnim.fSep = fSep;
    end

    for i = 0, resImg.transform.childCount - 1 do
        local sprite = resImg.transform:GetChild(i):GetComponent('Image').sprite;
        comAnim:AddSprite(sprite);
    end

    return comAnim;

end

function Module16_SmallGamePanel.SmallGameEnd()
    logYellow("小游戏结束")
    if (not self) then return; end
    local fTImeMove = 1;
    local dotween = self.transform:DOLocalMove(Vector3.New(0, 2000, 0), fTImeMove);
    dotween:OnComplete(function()
        Module16Entry.ResultData.isSmallGame=0
        Module16_Result.totalFreeGold=Module16Entry.SceneData.InsideGameResult[ClickIndex]
        Module16Entry.SmallGameReult.WinScore=Module16Entry.SceneData.InsideGameResult[ClickIndex]
        Module16Entry.myGold=Module16Entry.myGold+Module16Entry.SmallGameReult.WinScore
        Module16_Result.ShowFreeResultEffect()
        Module16_SmallGamePanel.StopCon()
        destroy(self.transform.gameObject)
        self.transform=nil
    end);
end

function Module16_SmallGamePanel.ShowSmallGameResult()
    if self.isShowNormal then
        self.timer = self.timer + Time.deltaTime;
        self.currentRunGold = self.currentRunGold + self.winRate;
        if self.currentRunGold >= Module16Entry.SceneData.InsideGameResult[ClickIndex] then
            self.currentRunGold = Module16Entry.SceneData.InsideGameResult[ClickIndex];
        end
        self.winGoldNum.text = Module16Entry.ShowText(self.currentRunGold);
        if self.timer >= 2.5 then
            self.isShowNormal = false;
            self.timer = 0;
            self.winGoldNum.text=Module16Entry.ShowText(0)
        end
    end
end

function Module16_SmallGamePanel.StopCon()
    coroutine.stop(fun)
    coroutine.stop(fun2)
    coroutine.stop(fun3)
end