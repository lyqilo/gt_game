AJDMX_SmallGame = {};

local self = AJDMX_SmallGame;

self.transform=nil
self.luotuo=nil
local beginIndex=0
local fun=nil

local clickPos=-1
local CanClickNum=3

local maxGameFreecount=0
local maxGameChipNum=0


function AJDMX_SmallGame:Init(Obj)
    self.transform=Obj.transform
    self.mainPanel=self.transform:Find("SGBG2")

    self.beginBtn=self.mainPanel:Find("SGButton"):GetComponent("Button")

    self.dianshu=self.mainPanel:Find("dianshu")

    self.JSPanel=self.mainPanel:Find("SGWin")

    self.winGold1=self.JSPanel:Find("SGWin1BG0/SGWin1DiZhuText1"):GetComponent("Text")
    self.winGold2=self.JSPanel:Find("SGWin1BG0/SGWin1DiZhuText2"):GetComponent("Text")
    self.winFree=self.JSPanel:Find("SGWin1BG0/SGWin1DiZhuText3"):GetComponent("Text")
    self.CloseSmallGameBtn=self.JSPanel:Find("SGWin1BG0/SGWin1Button"):GetComponent("Button")
    self.POS=self.mainPanel:Find("Image")
    self.luotuo1=self.POS:Find("luotuo1")
    self.luotuo2=self.POS:Find("luotuo2")
    self.luotuo3=self.POS:Find("luotuo3")
    self.luotuo4=self.POS:Find("luotuo4")

    self.maxGamePanel=self.mainPanel:Find("maxGamePanel")
    self.maxGamePanel_Mask=self.maxGamePanel:Find("Image")

    self.beginBtn.onClick:RemoveAllListeners();
    self.beginBtn.onClick:AddListener(self.BeginSmallGame);
    self.CloseSmallGameBtn.onClick:RemoveAllListeners();
    self.CloseSmallGameBtn.onClick:AddListener(self.Close);
    for i=1,self.maxGamePanel:GetChild(0).childCount do
        self.maxGamePanel:GetChild(0):GetChild(i-1):GetComponent("Button").onClick:RemoveAllListeners();
        self.maxGamePanel:GetChild(0):GetChild(i-1):GetComponent("Button").onClick:AddListener(function ()
            self.MaxGame(i)
        end);
    end
    AJDMX_SmallGame.SmallGameClean()
end
function AJDMX_SmallGame.Run()
    self.transform.gameObject:SetActive(true)
    AJDMX_Audio.PlayBGM(AJDMX_Audio.SoundList.FreeBgm);
    beginIndex=AJDMXEntry.ResultData.cbIndex
    if beginIndex<=0 then
        beginIndex=1
    end
    AJDMX_SmallGame.InitLTPos(beginIndex)
    self.luotuo.transform:GetComponent("Animator").enabled=false
    self.luotuo.transform.localPosition=self.POS.transform:GetChild(beginIndex-1).localPosition
    if AJDMXEntry.SceneData.nMaxGameCount>0 then
        CanClickNum=AJDMXEntry.SceneData.nMaxGameCount
        self.maxGamePanel.gameObject:SetActive(true) 
        self.maxGamePanel_Mask.gameObject:SetActive(false)
        if AJDMXEntry.SceneData.nMaxGameCount==3 then
            
        elseif AJDMXEntry.SceneData.nMaxGameCount==2 then
            local index= AJDMXEntry.SceneData.nMaxGameIndex[1]
            if AJDMXEntry.SceneData.nMaxGameType[1] <=10 then
                maxGameFreecount=maxGameFreecount+AJDMXEntry.SceneData.nMaxGameType[1]
                self.maxGamePanel:GetChild(0):GetChild(index):Find("Text"):GetComponent("Text").text="Free Game X"..AJDMXEntry.SceneData.nMaxGameType[1]
            else
                maxGameChipNum = maxGameChipNum+AJDMXEntry.SceneData.nMaxGameType[1]
                self.maxGamePanel:GetChild(0):GetChild(index):Find("Text"):GetComponent("Text").text=ShortNumber(AJDMXEntry.SceneData.nMaxGameType[1])
            end
            self.maxGamePanel:GetChild(0):GetChild(index):GetComponent("Image").enabled=false
            self.maxGamePanel:GetChild(0):GetChild(index):Find("Image").gameObject:SetActive(false)
            self.maxGamePanel:GetChild(0):GetChild(index):Find("Image2").gameObject:SetActive(true)
            self.maxGamePanel:GetChild(0):GetChild(index):Find("Image2/Image").gameObject:SetActive(false)
            self.maxGamePanel:GetChild(0):GetChild(index):Find("Image2/Image").localPosition=Vector3.New(0,37,0)
            self.maxGamePanel:GetChild(0):GetChild(index):Find("Text").gameObject:SetActive(true)
        elseif AJDMXEntry.SceneData.nMaxGameCount==1 then
            local index1=AJDMXEntry.SceneData.nMaxGameIndex[1]
            if AJDMXEntry.SceneData.nMaxGameType[1] <=10 then
                maxGameFreecount=maxGameFreecount+AJDMXEntry.SceneData.nMaxGameType[1]
                self.maxGamePanel:GetChild(0):GetChild(index1):Find("Text"):GetComponent("Text").text="Free GameX"..AJDMXEntry.SceneData.nMaxGameType[1]
            else
                maxGameChipNum = maxGameChipNum+AJDMXEntry.SceneData.nMaxGameType[1]
                self.maxGamePanel:GetChild(0):GetChild(index1):Find("Text"):GetComponent("Text").text=ShortNumber(AJDMXEntry.SceneData.nMaxGameType[1])
            end
            self.maxGamePanel:GetChild(0):GetChild(index1):GetComponent("Image").enabled=false
            self.maxGamePanel:GetChild(0):GetChild(index1):Find("Image").gameObject:SetActive(false)
            self.maxGamePanel:GetChild(0):GetChild(index1):Find("Image2").gameObject:SetActive(true)
            self.maxGamePanel:GetChild(0):GetChild(index1):Find("Image2/Image").gameObject:SetActive(false)
            self.maxGamePanel:GetChild(0):GetChild(index1):Find("Image2/Image").localPosition=Vector3.New(0,37,0)
            self.maxGamePanel:GetChild(0):GetChild(index1):Find("Text").gameObject:SetActive(true)

            local index2=AJDMXEntry.SceneData.nMaxGameIndex[2]
            if AJDMXEntry.SceneData.nMaxGameType[2] <=10 then
                maxGameFreecount=maxGameFreecount+AJDMXEntry.SceneData.nMaxGameType[2]
                self.maxGamePanel:GetChild(0):GetChild(index2):Find("Text"):GetComponent("Text").text="Free GameX"..AJDMXEntry.SceneData.nMaxGameType[2]
            else
                maxGameChipNum = maxGameChipNum+AJDMXEntry.SceneData.nMaxGameType[2]
                self.maxGamePanel:GetChild(0):GetChild(index2):Find("Text"):GetComponent("Text").text=ShortNumber(AJDMXEntry.SceneData.nMaxGameType[2])
            end
            self.maxGamePanel:GetChild(0):GetChild(index2):GetComponent("Image").enabled=false
            self.maxGamePanel:GetChild(0):GetChild(index2):Find("Image").gameObject:SetActive(false)
            self.maxGamePanel:GetChild(0):GetChild(index2):Find("Image2").gameObject:SetActive(true)
            self.maxGamePanel:GetChild(0):GetChild(index2):Find("Image2/Image").gameObject:SetActive(false)
            self.maxGamePanel:GetChild(0):GetChild(index2):Find("Image2/Image").localPosition=Vector3.New(0,37,0)
            self.maxGamePanel:GetChild(0):GetChild(index2):Find("Text").gameObject:SetActive(true)
        end
    end
end

function AJDMX_SmallGame.BeginSmallGame()
    AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BtnClick);
    self.beginBtn.interactable = false;
    AJDMX_Network.StartSmallGame()
end

function AJDMX_SmallGame.MaxGame(value)
    clickPos=value
    self.maxGamePanel:GetChild(0):GetChild(clickPos-1):GetComponent("Button").interactable=false
    self.maxGamePanel_Mask.gameObject:SetActive(true)                    
    CanClickNum=CanClickNum-1
    AJDMX_Network.StartMaxGame(value-1)
end

function AJDMX_SmallGame.SmallGameCallBack()
    local ds=AJDMXEntry.smallGameData.cbPoint
    self.dianshu.transform:GetChild(ds-1).gameObject:SetActive(true)
    fun=coroutine.start(function ()
        while AJDMXEntry.smallGameData.cbPoint>0 do
            coroutine.wait(1)
            self.dianshu.transform:GetChild(ds-1).gameObject:SetActive(false)
            beginIndex=beginIndex+1
            AJDMXEntry.smallGameData.cbPoint=AJDMXEntry.smallGameData.cbPoint-1
            if beginIndex>16 then
                beginIndex=beginIndex-16
            end

            self.luotuo.transform:GetComponent("Animator").enabled=true
            AJDMX_SmallGame.InitLTPos(beginIndex)
            local tweener = self.luotuo.transform:DOLocalMove(self.POS.transform:GetChild(beginIndex-1).localPosition,1, false):SetEase(DG.Tweening.Ease.Linear);
            tweener:OnComplete( function()
                coroutine.start(function ()
                    if AJDMXEntry.smallGameData.cbPoint<=0 then
                        self.luotuo.transform:GetComponent("Animator").enabled=false
                        if AJDMXEntry.smallGameData.cbType==0 then
                            if AJDMXEntry.smallGameData.cbFreeTime>0 then
                                self.winGold1.gameObject:SetActive(false)
                                self.winGold2.gameObject:SetActive(false)
                                self.winFree.text="Free Game X"..AJDMXEntry.smallGameData.cbFreeTime
                                self.winFree.gameObject:SetActive(true)
                            elseif AJDMXEntry.smallGameData.nWinGold>0 then
                                self.winGold2.text=ShortNumber(AJDMXEntry.smallGameData.nWinGold)
                                self.winGold1.gameObject:SetActive(true)
                                self.winGold2.gameObject:SetActive(true)
                                self.winFree.gameObject:SetActive(false)
                            end
                            coroutine.wait(1)
                            self.JSPanel.gameObject:SetActive(true)
                            coroutine.wait(4)
                            AJDMX_SmallGame.Close()
                        elseif AJDMXEntry.smallGameData.cbType==1 then
                            coroutine.wait(1)
                            self.maxGamePanel.gameObject:SetActive(true) 
                            self.maxGamePanel_Mask.gameObject:SetActive(false)                    
                        elseif AJDMXEntry.smallGameData.cbType==2 then
                            coroutine.wait(1)
                            self.beginBtn.interactable = true;
                        end
                    end
                end)
            end );
        end
    end)
end

function AJDMX_SmallGame.MaxGameCallBack()
    --AJDMXEntry.MaxGameData.cbResCode
    coroutine.start(function()
        if AJDMXEntry.MaxGameData.cbFreeTime>0 then
            maxGameFreecount=maxGameFreecount+AJDMXEntry.MaxGameData.cbFreeTime
            self.maxGamePanel:GetChild(0):GetChild(clickPos-1):Find("Text"):GetComponent("Text").text="Free Game X"..AJDMXEntry.MaxGameData.cbFreeTime
        elseif AJDMXEntry.MaxGameData.nWinGold>0 then
            maxGameChipNum=maxGameChipNum+AJDMXEntry.MaxGameData.nWinGold
            self.maxGamePanel:GetChild(0):GetChild(clickPos-1):Find("Text"):GetComponent("Text").text=ShortNumber(AJDMXEntry.MaxGameData.nWinGold)
        end
        coroutine.wait(0.2)
        self.maxGamePanel:GetChild(0):GetChild(clickPos-1):GetComponent("Image").enabled=false
        self.maxGamePanel:GetChild(0):GetChild(clickPos-1):Find("Image").gameObject:SetActive(true)
        coroutine.wait(0.3)
        self.maxGamePanel:GetChild(0):GetChild(clickPos-1):Find("Image").gameObject:SetActive(false)
        self.maxGamePanel:GetChild(0):GetChild(clickPos-1):Find("Image2/Image").gameObject:SetActive(true)
        self.maxGamePanel:GetChild(0):GetChild(clickPos-1):Find("Image2/Image").localPosition=Vector3.New(0,37,0)
        self.maxGamePanel:GetChild(0):GetChild(clickPos-1):Find("Image2").gameObject:SetActive(true)
        coroutine.wait(0.3)
        local tweener = self.maxGamePanel:GetChild(0):GetChild(clickPos-1):Find("Image2/Image"):DOLocalMove(Vector3.New(0,100,0),0.5, false):SetEase(DG.Tweening.Ease.Linear);
        tweener:OnComplete( function()
            coroutine.start(function ()
                self.maxGamePanel:GetChild(0):GetChild(clickPos-1):Find("Image2/Image").gameObject:SetActive(false)
                self.maxGamePanel:GetChild(0):GetChild(clickPos-1):Find("Image2/Image").localPosition=Vector3.New(0,37,0)
                self.maxGamePanel:GetChild(0):GetChild(clickPos-1):Find("Text").gameObject:SetActive(true)
                coroutine.wait(1)
                self.maxGamePanel_Mask.gameObject:SetActive(false)                    
                if CanClickNum<=0 then
                    if maxGameFreecount>0 then
                        self.winFree.text="Free Game X"..maxGameFreecount
                        self.winFree.gameObject:SetActive(true)
                        AJDMXEntry.ResultData.FreeCount=maxGameFreecount
                    else
                        self.winFree.gameObject:SetActive(false)
                    end
                    if maxGameChipNum>0 then
                        self.winGold2.text=ShortNumber(maxGameChipNum)
                        self.winGold1.gameObject:SetActive(true)
                        self.winGold2.gameObject:SetActive(true)
                    else
                        self.winGold1.gameObject:SetActive(false)
                        self.winGold2.gameObject:SetActive(false)
                    end
                    coroutine.wait(1)
                    self.JSPanel.gameObject:SetActive(true)
                    coroutine.wait(4)
                    AJDMX_SmallGame.Close()
                end
            end)
        end)
    end)
end

function AJDMX_SmallGame.InitLTPos(index)
    if index>0 and index <=4 then
        self.luotuo1.gameObject:SetActive(true)
        self.luotuo2.gameObject:SetActive(false)
        self.luotuo3.gameObject:SetActive(false)
        self.luotuo4.gameObject:SetActive(false)
        self.luotuo=self.luotuo1
    elseif index>4 and index <=8 then
        self.luotuo1.gameObject:SetActive(false)
        self.luotuo2.gameObject:SetActive(true)
        self.luotuo3.gameObject:SetActive(false)
        self.luotuo4.gameObject:SetActive(false)
        self.luotuo=self.luotuo2
    elseif index>8 and index <=12 then
        self.luotuo1.gameObject:SetActive(false)
        self.luotuo2.gameObject:SetActive(false)
        self.luotuo3.gameObject:SetActive(true)
        self.luotuo4.gameObject:SetActive(false)
        self.luotuo=self.luotuo3
    elseif index>12 and index <=16 then
        self.luotuo1.gameObject:SetActive(false)
        self.luotuo2.gameObject:SetActive(false)
        self.luotuo3.gameObject:SetActive(false)
        self.luotuo4.gameObject:SetActive(true)
        self.luotuo=self.luotuo4
    end
end

function AJDMX_SmallGame.Close(args)
    if args~=nil then
        AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BtnClick);
    end
    AJDMXEntry.ResultData.FreeCount = maxGameFreecount

    coroutine.stop(fun)
    self.transform.gameObject:SetActive(false)
    AJDMX_SmallGame.SmallGameClean()
    AJDMXEntry.ResultData.cbHitBouns=0
    AJDMXEntry.SceneData.cbIsSmallGame=0
    AJDMXEntry.isSmallGame=false
    AJDMX_Result.CheckFree()
end

function AJDMX_SmallGame.SmallGameClean()
    for i=1,self.dianshu.childCount do
        self.dianshu:GetChild(i-1).gameObject:SetActive(false)
    end
    for i=1,self.maxGamePanel:GetChild(0).childCount do
        self.maxGamePanel:GetChild(0):GetChild(i-1):GetComponent("Button").interactable=true
        self.maxGamePanel:GetChild(0):GetChild(i-1):GetComponent("Image").enabled=true
        self.maxGamePanel:GetChild(0):GetChild(i-1):Find("Text").gameObject:SetActive(false)
        self.maxGamePanel:GetChild(0):GetChild(i-1):Find("Image2").gameObject:SetActive(false)
        self.maxGamePanel:GetChild(0):GetChild(i-1):Find("Image2/Image").gameObject:SetActive(false)
        self.maxGamePanel:GetChild(0):GetChild(i-1):Find("Image").gameObject:SetActive(false)
    end
    self.beginBtn.interactable = true;
    self.luotuo1.gameObject:SetActive(false)
    self.luotuo2.gameObject:SetActive(false)
    self.luotuo3.gameObject:SetActive(false)
    self.luotuo4.gameObject:SetActive(false)
   -- beginIndex=0
    self.JSPanel.gameObject:SetActive(false)
    clickPos=-1
    CanClickNum=3
    self.luotuo1.transform.localPosition=self.POS.transform:GetChild(0).localPosition
    self.luotuo2.transform.localPosition=self.POS.transform:GetChild(4).localPosition
    self.luotuo3.transform.localPosition=self.POS.transform:GetChild(8).localPosition
    self.luotuo4.transform.localPosition=self.POS.transform:GetChild(12).localPosition
end