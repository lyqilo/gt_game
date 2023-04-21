
local DeLayRun = require "Module43/Code/DeLayRun"
require "Module43/Code/BRNN_CMD"
require "Module43/Code/BRNN_Event"
require "Module43/Code/class_a"
local NumFormat = require "Module43/Code/NumFormat"
local GameData71 = require "Module43/Code/GameData71"
local AlphaFade = require "Module43/Code/AlphaFade"
local player = require "Module43/Code/Player"
local PlayerList = require "Module43/Code/PlayerList"
local ResManager = require "Module43/Code/ResManager"
local Card = require "Module43/Code/Card"
local CardManager = require "Module43/Code/CardManager"
--local BankBox = require "Module43/Code/BankBox"

require("Module43/Code/RPC/BRNN_RPCBase")
require("Module43/Code/RPC/BRNN_RPCHandle")
require("Module43/Code/RPC/BRNN_RPCSend")


Game71Panel = {}
local self = Game71Panel
self.AlphaFadeList = {}
self.BetUIList = {{}, {}, {}, {}, {}, {}}
self.BetUIAreaList = {{}, {}, {}, {}}

self.UserInfo={}

function Game71Panel.playBgMusic(name)
    if(MusicManager.isPlayMV)then
        local clip = ResManager.GetAudioCliByName(name)
        if(clip ~= nil)then
            MusicManager:PlayBacksoundX(clip, MusicManager.isPlayMV);
        end
    end
end

function Game71Panel.playShortMusic(name)
    if(MusicManager.isPlaySV)then
        local clip = ResManager.GetAudioCliByName(name)
        if(clip ~= nil)then
            MusicManager:PlayX(clip);
        end
    end
end

function Game71Panel.Awake()

    Screen.orientation = UnityEngine.ScreenOrientation.Landscape;
    Screen.autorotateToLandscapeLeft = true;
    Screen.autorotateToLandscapeRight = true;
    Screen.autorotateToPortrait = false;
    Screen.autorotateToPortraitUpsideDown = false;
    logError("--------====002")
    self.transform = GameObject.Find("Game71Panel").transform
    BRNN_RPCHandle.OnAeake();
    logError("--------====003: "..self.transform:GetChild(0).name)
    --GameManager.PanelRister(obj);
    logError("--------====004")
    --GameManager.PanelInitSucceed(obj);
    logError("--------====005")
    GameManager.GameScenIntEnd();
    logError("--------====006")

    self.Mine = class_a("Player", player)
    self.Mine:ctor()
    BRNN_RPCSend.PlayerLogon();
    PlayerList.Init()
    CardManager.Init(DeLayRun, class_a, Card, ResManager, GameData71, self.Mine)
    self.transform.gameObject:SetActive(false)
    logError("--------====007")
end

local function OnShowSceneOver()
    self.Info:GetComponent("CanvasGroup").interactable = true
    self.BtnPlane:GetComponent("CanvasGroup").interactable = true
end

local function OnShowScene()
    self.playBgMusic("bkmusic2")
    self.AlphaFadeList[1]:StartFade(self.Info, 1, 0.6, OnShowSceneOver)
    self.AlphaFadeList[2]:StartFade(self.BtnPlane, 1, 0.6, nil)
    logError("mmmmmmmmmmmmmmmmm")
end



local function UnActiveButton()
    local BetAreaBtnPar = self.BtnPlane.transform:Find("CustomBtn")
    local BetBtnPar = self.BtnPlane.transform:Find("bottom")
    BetAreaBtnPar:Find("Tian_Btn"):GetComponent("Image").raycastTarget = false
    BetAreaBtnPar:Find("Di_Btn"):GetComponent("Image").raycastTarget = false
    BetAreaBtnPar:Find("Xuan_Btn"):GetComponent("Image").raycastTarget = false
    BetAreaBtnPar:Find("Huang_Btn"):GetComponent("Image").raycastTarget = false

    for i = 0, 5 do
         BetBtnPar:GetChild(i):GetComponent("CanvasGroup").interactable = false
         BetBtnPar:GetChild(i):GetComponent("CanvasGroup").alpha = 0.5
    end

    BetBtnPar:Find("XT_Btn"):GetComponent("Image").raycastTarget = false
    BetBtnPar:Find("XT_Btn"):GetComponent("Image").color = Color.New(0.5, 0.5, 0.5, 0.5)
end

local function ActiveButton(IsBet)
    if(self.Mine.BankerState == 2)then
        logError("00000")
        UnActiveButton()
        return
    end
    local BetAreaBtnPar = self.BtnPlane.transform:Find("CustomBtn")
    local BetBtnPar = self.BtnPlane.transform:Find("bottom")
    BetAreaBtnPar:Find("Tian_Btn"):GetComponent("Image").raycastTarget = true
    BetAreaBtnPar:Find("Di_Btn"):GetComponent("Image").raycastTarget = true
    BetAreaBtnPar:Find("Xuan_Btn"):GetComponent("Image").raycastTarget = true
    BetAreaBtnPar:Find("Huang_Btn"):GetComponent("Image").raycastTarget = true

    for i = 0, 5 do
        if(self.Mine.Money >= GameData71.BetList[i + 1] * 10)then
            BetBtnPar:GetChild(i):GetComponent("CanvasGroup").interactable = true
            BetBtnPar:GetChild(i):GetComponent("CanvasGroup").alpha = 1
        else
            BetBtnPar:GetChild(i):GetComponent("CanvasGroup").interactable = false
            BetBtnPar:GetChild(i):GetComponent("CanvasGroup").alpha = 0.5
        end
    end

    local xuyabet = 0
    for k, v in pairs(self.Mine.XuYaInfo)do
        xuyabet = xuyabet + v
    end
    if(self.Mine.Money >= xuyabet * 10 and xuyabet > 0 and self.Mine:GetAllCurBet() == 0 and IsBet == false)then
         BetBtnPar:Find("XT_Btn"):GetComponent("Image").raycastTarget = true
         BetBtnPar:Find("XT_Btn"):GetComponent("Image").color = Color.New(1, 1, 1, 1)
    else
        BetBtnPar:Find("XT_Btn"):GetComponent("Image").raycastTarget = false
         BetBtnPar:Find("XT_Btn"):GetComponent("Image").color = Color.New(1, 1, 1, 0.5)
    end
end

local function UpdateUpBankerCountUI()
    self.BtnPlane.transform:Find("CustomBtn/UpBankBtn/Text"):GetComponent("Text").text = " applicants: "..tostring(#GameData71.UpBankerList)
end

local function InitLuDan()
    self.Info.transform:Find("RecordBg/TodayJuShu"):GetComponent("Text").text = "Today games:  "..tostring(GameData71.Allturns)
    self.Info.transform:Find("RecordBg/TianWin_Count"):GetComponent("Text").text = tostring( GameData71.Winturns_Tian)
    self.Info.transform:Find("RecordBg/TianLose_Count"):GetComponent("Text").text = tostring( GameData71.Loseturns_Tian)
    self.Info.transform:Find("RecordBg/DiWin_Count"):GetComponent("Text").text = tostring( GameData71.Winturns_Di)
    self.Info.transform:Find("RecordBg/DiLose_Count"):GetComponent("Text").text = tostring( GameData71.Loseturns_Di)
    self.Info.transform:Find("RecordBg/XuanWin_Count"):GetComponent("Text").text = tostring( GameData71.Winturns_Xuan)
    self.Info.transform:Find("RecordBg/XuanLose_Count"):GetComponent("Text").text = tostring( GameData71.Loseturns_Xuan)
    self.Info.transform:Find("RecordBg/HuangWin_Count"):GetComponent("Text").text = tostring( GameData71.Winturns_Huang)
    self.Info.transform:Find("RecordBg/HuangLose_Count"):GetComponent("Text").text = tostring( GameData71.Loseturns_Huang)
end

local function SetBankerUI()
    --[[
    if(GameData71 == nil)then
        logError("bbbbbbbbb1")
        return
    end
    if(GameData71.CurBanker == nil)then
         logError("bbbbbbbbbbbbbbbbbbbb2")
        return
    end
    if( GameData71.CurBanker.name == nil)then
         logError("bbbbbbbbbbbbbbb3")
        return
    end
    if( GameData71.CurBanker.money == nil)then
        logError("bbbbbbbbbbbbbbbb4")
        return
    end
    ]]
    self.Info.transform:Find("BankerInfo/BankerNameBg/Text"):GetComponent("Text").text = GameData71.CurBanker.name
    self.Info.transform:Find("BankerInfo/BankerMoneyBg/Text"):GetComponent("Text").text = NumFormat.format1(GameData71.CurBanker.money, 2)
    --UpdateUpBankerCountUI()
end

local function UpdateMyMoneyUI()
    self.Info.transform:Find("PlayerInfo/Coin/Text"):GetComponent("Text").text = NumFormat.format1(self.Mine.Money, 2)
end

local function SetMineUI()
    self.Info.transform:Find("PlayerInfo/Name"):GetComponent("Text").text = self.Mine.name
    UpdateMyMoneyUI()
end

local function UpdateCurChooseBetBtnUI()
    for i = 0, 5 do
        local trans = self.BtnPlane.transform:Find("bottom"):GetChild(i)
        if((i + 1) ~= GameData71.CurBetIndex)then
            trans:DOKill(false)
            trans:DOLocalMove(Vector3.New(trans.localPosition.x, 22, 0), 0.3)
        else
            trans:DOKill(false)
            trans:DOLocalMove(Vector3.New(trans.localPosition.x, 43, 0), 0.3)
        end
    end
end

local function OnPressBetBtn(index)
    self.playShortMusic("sound-button") 
    GameData71.CurBetIndex = index + 1
    --选择显示 
    UpdateCurChooseBetBtnUI(index)
end

local function OnPressBetAreaBtn(index)
    if(self.Mine.Money < GameData71.BetList[GameData71.CurBetIndex])then
        logError("当前金币不足, 无法下注")
        return
    end
    ActiveButton(true)
    local betdata = {}
    betdata[1] = index
    betdata[2] = GameData71.BetList[GameData71.CurBetIndex]
    BRNN_RPCSend.PlayerBet(betdata)
end

local function XuYaBtn()
    if(self.Mine.XuYaInfo[1] > 0) then
        local betdata = {}
        betdata[1] = 0
        betdata[2] = self.Mine.XuYaInfo[1]
        BRNN_RPCSend.PlayerBet(betdata)
    end
    if(self.Mine.XuYaInfo[2] > 0)then
        local betdata = {}
        betdata[1] = 1
        betdata[2] = self.Mine.XuYaInfo[2]
        BRNN_RPCSend.PlayerBet(betdata)
    end
    if(self.Mine.XuYaInfo[3] > 0)then
        local betdata = {}
        betdata[1] = 2
        betdata[2] = self.Mine.XuYaInfo[3]
        BRNN_RPCSend.PlayerBet(betdata)
    end
    if(self.Mine.XuYaInfo[4] > 0)then
        local betdata = {}
        betdata[1] = 3
        betdata[2] = self.Mine.XuYaInfo[4]
        BRNN_RPCSend.PlayerBet(betdata)
    end
    ActiveButton(true)
end

local function SetHead(palyerinfo, headimg)
    --local headimg=self.info.transform:Find("Head/Head"):GetComponent('Image')
    if palyerinfo._1dwUser_Id == self.Mine.Id then
        headimg.sprite=HallScenPanel.GetHeadIcon()
    else
        log("NiuNiuPlayer:SetHead: "..palyerinfo.spName)
        --HallScenPanel.LoadHeader(palyerinfo.spName,headimg)
    end
end

local function OpenOtherPlayerListUI()
    self.PlayerListUI.transform:DOLocalMove(Vector3.New(0, 0, 0), 0.3)
    --self.PlayerListItemModel
    local PlayerListContent = self.Info.transform:Find("PlayerList/Scroll View/Viewport/Content")
    local ExistLen = PlayerListContent.childCount

    local changdu = 1
    for k, v in pairs(PlayerList.PlayerArr)do
        if(v ~= nil)then
            changdu = changdu + 1
        end
    end

    if(changdu < 7)then
        --PlayerListContent:GetComponent("RectTransform").offsetMin = Vector2.New(0, 0);
        PlayerListContent:GetComponent("RectTransform").offsetMin = Vector2.New(0, -485);
    else
        --PlayerListContent:GetComponent("RectTransform").offsetMin  = Vector2.New(0, 0)
        PlayerListContent:GetComponent("RectTransform").offsetMin  = Vector2.New(0, -81 * changdu);
    end

    local num = 1
    local go1 = nil
    if(1 <= ExistLen)then
        go1 = PlayerListContent:GetChild(num - 1)
    else
        go1 = newObject(self.PlayerListItemModel)
        go1.transform.gameObject:SetActive(true)
        go1.transform:SetParent(PlayerListContent)
        go1.transform.localScale = Vector3.New(1, 1, 1)
    end
    go1.transform.localPosition = Vector3.New(0, -40 - 81 * (num - 1), 0)
    go1.transform:Find("LevelNum/Name"):GetComponent("Text").text = self.Mine.name
    go1.transform:Find("LevelNum"):GetComponent("Text").text = "1"
    go1.transform:Find("CoinIcon/Money"):GetComponent("Text").text = NumFormat.format1(self.Mine.Money, 2)
    SetHead(self.Mine, go1.transform:Find("HeadKuang/Mask/Headsp"):GetComponent("Image"))

    for k, v in pairs(PlayerList.PlayerArr)do
        if(v ~= nil)then
            num = num + 1
            local go = nil
            if(k <= ExistLen)then
                go = PlayerListContent:GetChild(num - 1)
            else
                go = newObject(self.PlayerListItemModel)
                go.transform.gameObject:SetActive(true)
                go.transform:SetParent(PlayerListContent)
                go.transform.localScale = Vector3.New(1, 1, 1)
            end
            go.transform.localPosition = Vector3.New(0, -40 - 81 * (num - 1), 0)
            go.transform:Find("LevelNum/Name"):GetComponent("Text").text = v.name
            go.transform:Find("LevelNum"):GetComponent("Text").text = "1"
            go.transform:Find("CoinIcon/Money"):GetComponent("Text").text = NumFormat.format1(v.Money, 2)
            SetHead(v, go.transform:Find("HeadKuang/Mask/Headsp"):GetComponent("Image"))
        end
    end

    for i = #PlayerList.PlayerArr + 1, ExistLen - 1 do
        PlayerListContent:GetChild(i).gameObject:SetActive(false)
    end
    self.Info.transform:Find("PlayerList/Descrip"):GetComponent("Text").text = "Online："..tostring(num)
end

local function AddNewItemToLuDan(data)
    local maxLen = 12
    if(#GameData71.LuDan >= maxLen)then
        for i = 1, #GameData71.LuDan - 1 do
            if(i < maxLen - 1)then
                GameData71.LuDan[i] = GameData71.LuDan[i + 1]
            elseif(i == maxLen - 1)then
                GameData71.LuDan[i] = GameData71.LuDan[i + 1]
                GameData71.LuDan[maxLen] = data
            elseif(i > maxLen)then
                table.remove(GameData71.LuDan, i)
            end
        end
    else
        GameData71.LuDan[#GameData71.LuDan + 1] = data
    end
    local RecordItemModel = self.Info.transform:Find("RecordBg/RecordItem")
    local RecordContent = self.Info.transform:Find("RecordBg/ScrollView_Record/Viewport/Content")
    local len = RecordContent.childCount
    RecordContent:GetChild(len - 1).transform:Find("Image").gameObject:SetActive(false)
    RecordContent:GetChild(len - 1):GetComponent("Image").color = Color.New(1, 1, 1, 0.6)

    local go = nil
    if(#GameData71.LuDan > 8)then
        if(#GameData71.LuDan >= maxLen)then
            if(len < maxLen)then
                go = newObject(RecordItemModel.gameObject)
                go.transform:SetParent(RecordContent, false)
                go.transform.localScale = Vector3.New(1, 1, 1)
                go.transform.gameObject:SetActive(true)
            else
               go = RecordContent:GetChild(0)
               go:SetAsLastSibling()
            end
        else
            if(len >= #GameData71.LuDan)then
                go = RecordContent:GetChild(#GameData71.LuDan - 1)
            else
                go = newObject(RecordItemModel.gameObject)
                go.transform:SetParent(RecordContent, false)
                go.transform.localScale = Vector3.New(1, 1, 1)
                go.transform.gameObject:SetActive(true)
            end
        end
        RecordContent:GetComponent("RectTransform").offsetMin  = Vector2.New(0, -282)
        RecordContent:GetComponent("RectTransform").offsetMax  = Vector2.New(0,  35 * (#GameData71.LuDan - 8));
        local offsetPos = (#GameData71.LuDan - 8) * 35
       
        for i = #GameData71.LuDan - 1, 0, -1 do
            RecordContent:GetChild(i).transform.localPosition = Vector3.New(69, -20 - offsetPos - 35 * 7 + (#GameData71.LuDan - 1 - i) * 35, 0)
        end
    else
        if(#GameData71.LuDan >= maxLen)then
           go = RecordContent:GetChild(0)
           go:SetAsLastSibling()
        else
            if(len >= #GameData71.LuDan)then
                go = RecordContent:GetChild(#GameData71.LuDan - 1)
            else
                go = newObject(RecordItemModel.gameObject)
                go.transform:SetParent(RecordContent, false)
                go.transform.localScale = Vector3.New(1, 1, 1)
                go.transform.gameObject:SetActive(true)
            end
        end
        RecordContent:GetComponent("RectTransform").offsetMin  = Vector2.New(0, -282)
        RecordContent:GetComponent("RectTransform").offsetMax  = Vector2.New(0,  0);
        go.transform.localPosition = Vector3.New(69, -20 - 35 * (#GameData71.LuDan - 1), 0)
    end
    if(data[1] == 1)then
        go.transform:Find("Tian"):GetComponent("Image").sprite = ResManager.GetSpriteByName("GreenGou").sprite
    else
        go.transform:Find("Tian"):GetComponent("Image").sprite = ResManager.GetSpriteByName("HongGou").sprite
    end
    if(data[2] == 1)then
        go.transform:Find("Di"):GetComponent("Image").sprite = ResManager.GetSpriteByName("GreenGou").sprite
    else
        go.transform:Find("Di"):GetComponent("Image").sprite = ResManager.GetSpriteByName("HongGou").sprite
    end
    if(data[3] == 1)then
        go.transform:Find("xuan"):GetComponent("Image").sprite = ResManager.GetSpriteByName("GreenGou").sprite
    else
        go.transform:Find("xuan"):GetComponent("Image").sprite = ResManager.GetSpriteByName("HongGou").sprite
    end
    if(data[4] == 1)then
        go.transform:Find("huang"):GetComponent("Image").sprite = ResManager.GetSpriteByName("GreenGou").sprite
    else
        go.transform:Find("huang"):GetComponent("Image").sprite = ResManager.GetSpriteByName("HongGou").sprite
    end
    go.transform:Find("Image").gameObject:SetActive(true)
    go.transform:GetComponent("Image").color = Color.New(1, 1, 1, 1)
    InitLuDan()
end

local function InitLudan()
    local RecordItemModel = self.Info.transform:Find("RecordBg/RecordItem")
    local RecordContent = self.Info.transform:Find("RecordBg/ScrollView_Record/Viewport/Content")
    local len = RecordContent.childCount
    local BornNum = 0

   

    for k, v in pairs(GameData71.LuDan)do
        BornNum = BornNum + 1
        local newItem = nil
        if(BornNum <= len)then
            newItem = RecordContent:GetChild(BornNum - 1)
        else
            newItem = newObject(RecordItemModel.gameObject)
            newItem.transform:SetParent(RecordContent, false)
            newItem.transform.localScale = Vector3.New(1, 1, 1)
            newItem.transform.gameObject:SetActive(true)
        end
        newItem.transform.localPosition = Vector3.New(69, -20 - 35 * (BornNum - 1), 0)
        if(v[1] == 0)then
            newItem.transform:Find("Tian"):GetComponent("Image").sprite = ResManager.GetSpriteByName("GreenGou").sprite
        else
            newItem.transform:Find("Tian"):GetComponent("Image").sprite = ResManager.GetSpriteByName("HongGou").sprite
        end
        if(v[2] == 0)then
            newItem.transform:Find("Di"):GetComponent("Image").sprite = ResManager.GetSpriteByName("GreenGou").sprite
        else
            newItem.transform:Find("Di"):GetComponent("Image").sprite = ResManager.GetSpriteByName("HongGou").sprite
        end
        if(v[3] == 0)then
            newItem.transform:Find("xuan"):GetComponent("Image").sprite = ResManager.GetSpriteByName("GreenGou").sprite
        else
            newItem.transform:Find("xuan"):GetComponent("Image").sprite = ResManager.GetSpriteByName("HongGou").sprite
        end
        if(v[4] == 0)then
            newItem.transform:Find("huang"):GetComponent("Image").sprite = ResManager.GetSpriteByName("GreenGou").sprite
        else
            newItem.transform:Find("huang"):GetComponent("Image").sprite = ResManager.GetSpriteByName("HongGou").sprite
        end
        if(k == 10)then
            newItem.transform:Find("Image").gameObject:SetActive(true)
            newItem:GetComponent("Image").color = Color.New(1, 1, 1, 1)
        else
            newItem.transform:Find("Image").gameObject:SetActive(false)
        end
    end

    RecordContent:GetComponent("RectTransform").offsetMin  = Vector2.New(0, -282)
    RecordContent:GetComponent("RectTransform").offsetMax  = Vector2.New(0,  35 * (#GameData71.LuDan - 8));

    local offsetPos = (#GameData71.LuDan - 8) * 35
       
    for i = #GameData71.LuDan - 1, 0, -1 do
        RecordContent:GetChild(i).transform.localPosition = Vector3.New(69, -20 - offsetPos - 35 * 7 + (#GameData71.LuDan - 1 - i) * 35, 0)
    end
    InitLuDan()
end

local function onPressSet()
    self.playShortMusic("sound-button") 
    self.Info.transform:Find("Set").gameObject:SetActive(true)
    if( MusicManager.isPlaySV)then
        self.Info.transform:Find("Set/SetBg/MusciEffect"):GetComponent("Image").sprite = ResManager.GetSpriteByName("MusicEffect_On").sprite
    else
        self.Info.transform:Find("Set/SetBg/MusciEffect"):GetComponent("Image").sprite = ResManager.GetSpriteByName("MusicEffect_Off").sprite
    end
    if( MusicManager.isPlayMV)then
        self.Info.transform:Find("Set/SetBg/Music"):GetComponent("Image").sprite = ResManager.GetSpriteByName("Music_On").sprite
    else
        self.Info.transform:Find("Set/SetBg/Music"):GetComponent("Image").sprite = ResManager.GetSpriteByName("Music_Off").sprite
    end
end

local function onpressRule()
    self.playShortMusic("sound-button") 
    self.Info.transform:Find("Set").gameObject:SetActive(false)
    self.Info.transform:Find("Rule").gameObject:SetActive(true)
end


local function onpressMusic()
    self.playShortMusic("sound-button") 
    local v = MusicManager.isPlayMV
    if(v)then
        v = false
        Util.SaveData("IsMusic", "1")
        AllSetGameInfo._5IsPlayAudio = false
    else
        v = true
        Util.SaveData("IsMusic", "0")
        AllSetGameInfo._5IsPlayAudio = true
    end
    MusicManager:SetPlaySM(MusicManager.isPlaySV, v)
    if( MusicManager.isPlayMV)then
        self.playBgMusic("bkmusic2")
        self.Info.transform:Find("Set/SetBg/Music"):GetComponent("Image").sprite = ResManager.GetSpriteByName("Music_On").sprite
    else
        self.Info.transform:Find("Set/SetBg/Music"):GetComponent("Image").sprite = ResManager.GetSpriteByName("Music_Off").sprite
    end
end

local function onpressMusciEffect()
    self.playShortMusic("sound-button") 
    local v = MusicManager.isPlaySV
    if(v)then
        v = false
        Util.SaveData("IsSound", "1")
        AllSetGameInfo._6IsPlayEffect = false
    else
        v = true
        Util.SaveData("IsSound", "0")
        AllSetGameInfo._6IsPlayEffect = true
    end
    MusicManager:SetPlaySM(v, MusicManager.isPlayMV)
    if( MusicManager.isPlaySV)then
        self.Info.transform:Find("Set/SetBg/MusciEffect"):GetComponent("Image").sprite = ResManager.GetSpriteByName("MusicEffect_On").sprite
    else
        self.Info.transform:Find("Set/SetBg/MusciEffect"):GetComponent("Image").sprite = ResManager.GetSpriteByName("MusicEffect_Off").sprite
    end
end

local function OnPressBanker()
    --BankBox.Open()
end

local function OnPressPlayerlistBack()
    self.PlayerListUI.transform:DOLocalMove(Vector3.New(-1500, 0, 0), 0.3)
end

local function SetBtn()
    self.BtnPlane.transform:Find("CustomBtn/ExitBtn"):GetComponent("Button").onClick:RemoveAllListeners()
    self.BtnPlane.transform:Find("CustomBtn/ExitBtn"):GetComponent("Button").onClick:AddListener(function()
        self.playShortMusic("sound-button")
        if(self.Mine:GetAllCurBet() > 0)then
           -- MessageBox.CreatGeneralTipsPanel("游戏中无法退出")
            return
        elseif(self.Mine.BankerState == 2)then
           -- MessageBox.CreatGeneralTipsPanel("上庄中无法退出")
            return
        end
        self.QuitGame()
    end)
    local BetBtnPar = self.BtnPlane.transform:Find("bottom")
    for i = 0, 5 do
        local j = i
        BetBtnPar:GetChild(i):GetComponent("Button").onClick:RemoveAllListeners()
        BetBtnPar:GetChild(i):GetComponent("Button").onClick:AddListener(function() OnPressBetBtn(j)end)
    end
    BetBtnPar:Find("XT_Btn"):GetComponent("Button").onClick:RemoveAllListeners()
    BetBtnPar:Find("XT_Btn"):GetComponent("Button").onClick:AddListener(XuYaBtn)
    local BetAreaBtnPar = self.BtnPlane.transform:Find("CustomBtn")
    BetAreaBtnPar:Find("Tian_Btn"):GetComponent("Button").onClick:RemoveAllListeners()
    BetAreaBtnPar:Find("Tian_Btn"):GetComponent("Button").onClick:AddListener(function() OnPressBetAreaBtn(0) end)
    BetAreaBtnPar:Find("Di_Btn"):GetComponent("Button").onClick:RemoveAllListeners()
    BetAreaBtnPar:Find("Di_Btn"):GetComponent("Button").onClick:AddListener(function() OnPressBetAreaBtn(1) end)
    BetAreaBtnPar:Find("Xuan_Btn"):GetComponent("Button").onClick:RemoveAllListeners()
    BetAreaBtnPar:Find("Xuan_Btn"):GetComponent("Button").onClick:AddListener(function() OnPressBetAreaBtn(2) end)
    BetAreaBtnPar:Find("Huang_Btn"):GetComponent("Button").onClick:RemoveAllListeners()
    BetAreaBtnPar:Find("Huang_Btn"):GetComponent("Button").onClick:AddListener(function() OnPressBetAreaBtn(3) end)
    BetAreaBtnPar:Find("UpBankBtn"):GetComponent("Button").onClick:RemoveAllListeners()
    BetAreaBtnPar:Find("UpBankBtn"):GetComponent("Button").onClick:AddListener(function() 
    self.playShortMusic("sound-button") 
    if(self.Mine.BankerState == 0)then
            BRNN_RPCSend.UpBank() 
        else
            BRNN_RPCSend.DownBank()
        end
    end)
    self.Info.transform:Find("OtherPlayerBtn"):GetComponent("Button").onClick:RemoveAllListeners()
    self.Info.transform:Find("OtherPlayerBtn"):GetComponent("Button").onClick:AddListener(function() self.playShortMusic("sound-button")  OpenOtherPlayerListUI() end)

    self.Info.transform:Find("PlayerList"):GetComponent("Button").onClick:RemoveAllListeners()
    self.Info.transform:Find("PlayerList"):GetComponent("Button").onClick:AddListener(function() 
        self.playShortMusic("sound-close") 
        OnPressPlayerlistBack() 
    end)
    self.BtnPlane.transform:Find("CustomBtn/SetBtn"):GetComponent("Button").onClick:RemoveAllListeners()
    self.BtnPlane.transform:Find("CustomBtn/SetBtn"):GetComponent("Button").onClick:AddListener(function()  onPressSet() end)

    local btn_Set = self.Info.transform:Find("Set")
    btn_Set:GetComponent("Button").onClick:RemoveAllListeners()
    btn_Set:GetComponent("Button").onClick:AddListener(function() 
        self.playShortMusic("sound-close")
        btn_Set.gameObject:SetActive(false) 
    end)

    self.Info.transform:Find("Set/SetBg/Rule"):GetComponent("Button").onClick:RemoveAllListeners()
    self.Info.transform:Find("Set/SetBg/Rule"):GetComponent("Button").onClick:AddListener(function() onpressRule() end)

    self.Info.transform:Find("Rule/Bg/Exit_Btn"):GetComponent("Button").onClick:RemoveAllListeners()
    self.Info.transform:Find("Rule/Bg/Exit_Btn"):GetComponent("Button").onClick:AddListener(function()  
        self.playShortMusic("sound-close")
        self.Info.transform:Find("Rule").gameObject:SetActive(false) 
    end)

    self.Info.transform:Find("Set/SetBg/Music"):GetComponent("Button").onClick:RemoveAllListeners()
    self.Info.transform:Find("Set/SetBg/Music"):GetComponent("Button").onClick:AddListener(function() onpressMusic() end)

    self.Info.transform:Find("Set/SetBg/MusciEffect"):GetComponent("Button").onClick:RemoveAllListeners()
    self.Info.transform:Find("Set/SetBg/MusciEffect"):GetComponent("Button").onClick:AddListener(function() onpressMusciEffect() end)

    self.Info.transform:Find("Set/SetBg/Bank"):GetComponent("Button").onClick:RemoveAllListeners()
    self.Info.transform:Find("Set/SetBg/Bank"):GetComponent("Button").onClick:AddListener(function() OnPressBanker() end)

    self.Info.transform:Find("PlayerList/PlayerList_Bg/Back"):GetComponent("Button").onClick:RemoveAllListeners()
    self.Info.transform:Find("PlayerList/PlayerList_Bg/Back"):GetComponent("Button").onClick:AddListener(function() OnPressPlayerlistBack() end)
end

local function UpdateBetInfo()
    self.Info.transform:Find("AllBetBg/Tile/Text"):GetComponent("Text").text = NumFormat.format1(GameData71.GetAllBet(), 2)
    self.TianAreaBetText.text = NumFormat.format1(self.Mine.AllBetInfo[1], 2)
    self.DiAreaBetText.text = NumFormat.format1(self.Mine.AllBetInfo[2], 2)
    self.XuanAreaBetText.text = NumFormat.format1(self.Mine.AllBetInfo[3], 2)
    self.HuangAreaBetText.text = NumFormat.format1(self.Mine.AllBetInfo[4], 2)

    self.TianAreaMyBetText.text = NumFormat.format1(GameData71.TianArea_Bet, 2)
    self.DiAreaMyBetText.text = NumFormat.format1(GameData71.DiArea_Bet, 2)
    self.XuanAreaMyBetText.text = NumFormat.format1(GameData71.XuanArea_Bet, 2)
    self.HuangAreaMyBetText.text = NumFormat.format1(GameData71.HuangArea_Bet, 2)
end

local function SetDeskInfo()
    for i = #GameData71.BetList, 1, -1 do
        local go = nil
        if(GameData71.BetList[i] > 99 and GameData71.BetList[i] < 1000)then
            local index = math.floor(GameData71.BetList[i] / 100)
            go = newObject(ResManager.GetPrefabByName("100_Bet").gameObject)
            go.transform:SetParent(self.BtnPlane.transform:Find("bottom") ,false)
            go.transform.localScale = Vector3.New(1, 1, 1)
            go.transform.localPosition = Vector3.New(265 - (#GameData71.BetList - i) * 139, 23, 0)
            go.transform.gameObject:AddComponent(typeof(UnityEngine.UI.Button));
            go.transform.gameObject:AddComponent(typeof(UnityEngine.CanvasGroup));
            go.transform:GetComponent("Image").raycastTarget = true;
            go.transform:Find("Text"):GetComponent("Text").text =tostring(index)
        elseif(GameData71.BetList[i] > 999 and GameData71.BetList[i] < 10000)then
            local index = math.floor(GameData71.BetList[i] / 1000)
            go = newObject(ResManager.GetPrefabByName("1K_Bet").gameObject)
            go.transform:SetParent(self.BtnPlane.transform:Find("bottom") ,false)
            go.transform.localScale = Vector3.New(1, 1, 1)
            go.transform.localPosition = Vector3.New(265 - (#GameData71.BetList - i) * 139, 23, 0)
            go.transform.gameObject:AddComponent(typeof(UnityEngine.UI.Button));
            go.transform.gameObject:AddComponent(typeof(UnityEngine.CanvasGroup));
            go.transform:GetComponent("Image").raycastTarget = true;
            go.transform:Find("Text"):GetComponent("Text").text =tostring(index)
        elseif(GameData71.BetList[i] > 9999 and GameData71.BetList[i] < 100000)then
            local index = math.floor(GameData71.BetList[i] / 10000)
            go = newObject(ResManager.GetPrefabByName("1w_Bet").gameObject)
            go.transform:SetParent(self.BtnPlane.transform:Find("bottom") ,false)
            go.transform.localScale = Vector3.New(1, 1, 1)
            go.transform.localPosition = Vector3.New(265 - (#GameData71.BetList - i) * 139, 23, 0)
            go.transform.gameObject:AddComponent(typeof(UnityEngine.UI.Button));
            go.transform.gameObject:AddComponent(typeof(UnityEngine.CanvasGroup));
            go.transform:GetComponent("Image").raycastTarget = true;
            go.transform:Find("Text"):GetComponent("Text").text =tostring(index)
        elseif(GameData71.BetList[i] > 99999 and GameData71.BetList[i] < 1000000)then
            local index = math.floor(GameData71.BetList[i] / 10000)
            go = newObject(ResManager.GetPrefabByName("10w_Bet").gameObject)
            go.transform:SetParent(self.BtnPlane.transform:Find("bottom") ,false)
            go.transform.localScale = Vector3.New(1, 1, 1)
            go.transform.localPosition = Vector3.New(265 - (#GameData71.BetList - i) * 139, 23, 0)
            go.transform.gameObject:AddComponent(typeof(UnityEngine.UI.Button));
            go.transform.gameObject:AddComponent(typeof(UnityEngine.CanvasGroup));
            go.transform:GetComponent("Image").raycastTarget = true;
            go.transform:Find("Text"):GetComponent("Text").text =tostring(index)
        elseif(GameData71.BetList[i] > 999999 and GameData71.BetList[i] < 10000000)then
            local index = math.floor(GameData71.BetList[i] / 1000000)
            go = newObject(ResManager.GetPrefabByName("100w_Bet").gameObject)
            go.transform:SetParent(self.BtnPlane.transform:Find("bottom") ,false)
            go.transform.localScale = Vector3.New(1, 1, 1)
            go.transform.localPosition = Vector3.New(265 - (#GameData71.BetList - i) * 139, 23, 0)
            go.transform.gameObject:AddComponent(typeof(UnityEngine.UI.Button));
            go.transform.gameObject:AddComponent(typeof(UnityEngine.CanvasGroup));
            go.transform:GetComponent("Image").raycastTarget = true;
            go.transform:Find("Text"):GetComponent("Text").text =tostring(index)
        elseif(GameData71.BetList[i] > 9999999 and GameData71.BetList[i] < 100000000)then
            local index = math.floor(GameData71.BetList[i] / 10000000)
            go = newObject(ResManager.GetPrefabByName("1000w_Bet").gameObject)
            go.transform:SetParent(self.BtnPlane.transform:Find("bottom") ,false)
            go.transform.localScale = Vector3.New(1, 1, 1)
            go.transform.localPosition = Vector3.New(265 - (#GameData71.BetList - i) * 139, 23, 0)
            go.transform.gameObject:AddComponent(typeof(UnityEngine.UI.Button));
            go.transform.gameObject:AddComponent(typeof(UnityEngine.CanvasGroup));
            go.transform:GetComponent("Image").raycastTarget = true;
            go.transform:Find("Text"):GetComponent("Text").text =tostring(index)
        else
            logError("实例化筹码超出范围: "..tostring(GameData71.BetList[i]))
            return
        end
        go.transform:SetAsFirstSibling()
        go.transform:GetComponent("Image").sprite = ResManager.GetSpriteByName("BetIcon"..tostring(i)).sprite
    end

    self.Info.transform:Find("DJS/DJS_Text"):GetComponent("Text").text = tostring(math.ceil(GameData71.DJS))
    if(GameData71.CurGameState == GameData71.GameState.GAME_STATE_CHIP and self.WaitGameToOver == false)then
        self.Info.transform:Find("DJS/Tile"):GetComponent("Image").sprite = ResManager.GetSpriteByName("XiaZhuZhong").sprite
        ActiveButton(false)
    else
        self.Info.transform:Find("DJS/Tile"):GetComponent("Image").sprite = ResManager.GetSpriteByName("KaiJiangZhong").sprite
        UnActiveButton()
    end

    local WinArea = self.transform:Find("bg/bg1/Info/WinArea").transform
    for i = 0, WinArea.childCount - 1 do
        WinArea:GetChild(i).gameObject:SetActive(false)
    end

    if(self.Mine.BankerState == 0)then
        logError("kkkkkkkkkkkkk1")
        self.BtnPlane.transform:Find("CustomBtn/UpBankBtn"):GetComponent("Image").sprite = ResManager.GetSpriteByName("UpBanker").sprite
    else
        logError("kkkkkkkkkkkkk2")
        self.BtnPlane.transform:Find("CustomBtn/UpBankBtn"):GetComponent("Image").sprite = ResManager.GetSpriteByName("DownBanker").sprite
    end

    DeLayRun.ClearTargetDelay("DJS")
    local djs = math.ceil(GameData71.DJS)
    DeLayRun.AddDelay(GameData71.DJS, nil, function()
        djs = djs - 1
        self.Info.transform:Find("DJS/DJS_Text"):GetComponent("Text").text = tostring(math.ceil(djs))
    end, "DJS")

    UpdateBetInfo()
end

local function BornBet(index)
    local betgo = {}
    
    if(index == 1)then
        local len = #self.BetUIList[1]
        if(#self.BetUIList[1] > 0) then
            if(self.BetUIList[1][len].Obj.transform.gameObject.activeSelf)then
                betgo.Obj = newObject(self.BtnPlane.transform:Find("bottom"):GetChild(0).gameObject)
                betgo.val = GameData71.BetList[1]
                table.remove(self.BetUIList[1])
            else
                betgo = self.BetUIList[1][len]
                table.remove(self.BetUIList[1])
            end
        else
            betgo.Obj = newObject(self.BtnPlane.transform:Find("bottom"):GetChild(0).gameObject)
            betgo.val = GameData71.BetList[1]
        end
    elseif(index == 2)then
        local len = #self.BetUIList[2]
        if(#self.BetUIList[2] > 0) then
            if(self.BetUIList[2][len].Obj.transform.gameObject.activeSelf)then
                betgo.Obj = newObject(self.BtnPlane.transform:Find("bottom"):GetChild(1).gameObject)
                betgo.val = GameData71.BetList[2]
                table.remove(self.BetUIList[2])
            else
                betgo = self.BetUIList[2][len]
                table.remove(self.BetUIList[2])
            end
        else
            betgo.Obj = newObject(self.BtnPlane.transform:Find("bottom"):GetChild(1).gameObject)
            betgo.val = GameData71.BetList[2]
        end
    elseif(index == 3)then
        local len = #self.BetUIList[3]
        if(#self.BetUIList[3] > 0) then
            if(self.BetUIList[3][len].Obj.transform.gameObject.activeSelf)then
                betgo.Obj = newObject(self.BtnPlane.transform:Find("bottom"):GetChild(2).gameObject)
                betgo.val = GameData71.BetList[3]
                table.remove(self.BetUIList[3])
            else
                betgo = self.BetUIList[3][len]
                table.remove(self.BetUIList[3])
            end
        else
            betgo.Obj = newObject(self.BtnPlane.transform:Find("bottom"):GetChild(2).gameObject)
            betgo.val = GameData71.BetList[3]
        end
    elseif(index == 4)then
        local len = #self.BetUIList[4]
        if(#self.BetUIList[4] > 0) then
            if(self.BetUIList[4][len].Obj.transform.gameObject.activeSelf)then
                betgo.Obj = newObject(self.BtnPlane.transform:Find("bottom"):GetChild(3).gameObject)
                betgo.val = GameData71.BetList[4]
                table.remove(self.BetUIList[4])
            else
                betgo = self.BetUIList[4][len]
                table.remove(self.BetUIList[4])
            end
        else
            betgo.Obj = newObject(self.BtnPlane.transform:Find("bottom"):GetChild(3).gameObject)
            betgo.val = GameData71.BetList[4]
        end
    elseif(index == 5)then
        local len = #self.BetUIList[5]
        if(#self.BetUIList[5] > 0) then
            if(self.BetUIList[5][len].Obj.transform.gameObject.activeSelf)then
                betgo.Obj = newObject(self.BtnPlane.transform:Find("bottom"):GetChild(4).gameObject)
                betgo.val = GameData71.BetList[5]
                table.remove(self.BetUIList[5])
            else
                betgo = self.BetUIList[5][len]
                table.remove(self.BetUIList[5])
            end
        else
            betgo.Obj = newObject(self.BtnPlane.transform:Find("bottom"):GetChild(4).gameObject)
            betgo.val = GameData71.BetList[5]
        end
    elseif(index == 6)then
        local len = #self.BetUIList[6]
        if(#self.BetUIList[6] > 0) then
            if(self.BetUIList[6][len].Obj.transform.gameObject.activeSelf)then
                betgo.Obj = newObject(self.BtnPlane.transform:Find("bottom"):GetChild(5).gameObject)
                betgo.val = GameData71.BetList[6]
                table.remove(self.BetUIList[6])
            else
                betgo = self.BetUIList[6][len]
                table.remove(self.BetUIList[6])
            end
        else
            betgo.Obj = newObject(self.BtnPlane.transform:Find("bottom"):GetChild(5).gameObject)
            betgo.val = GameData71.BetList[6]
        end
    else
        logError("生成筹码越界: "..tostring(index))
    end
    if(betgo.Obj:GetComponent("Button") ~= nil)then
        destroy(betgo.Obj:GetComponent("Button"))
    end
    if(betgo.Obj:GetComponent("CanvasGroup") ~= nil)then
        destroy(betgo.Obj:GetComponent("CanvasGroup"))
    end
    betgo.Obj:GetComponent("Image").raycastTarget = false
    betgo.Obj.transform.localPosition = Vector3.New(0.3, 0.3, 1)
    return betgo
end

local function BornBetProccess(SatrtIndex, newNum,  betArr, compelateEvent)
    local newList = {} 
    if(SatrtIndex + newNum < #betArr and SatrtIndex / newNum < 20)then
        for i = SatrtIndex, SatrtIndex + newNum do
            newList[#newList + 1] = BornBet(betArr[i])
        end
        if(compelateEvent ~= nil)then
            compelateEvent(newList)
        else
            logError("compelateEvent is nil")
        end
        DeLayRun.AddDelay(0.05, function() BornBetProccess(SatrtIndex + newNum + 1, newNum, betArr, compelateEvent) end, nil, nil)
    else
        for i = SatrtIndex, SatrtIndex + 5 do
            if(i > #betArr)then
                break
            end
            newList[#newList + 1] = BornBet(betArr[i])
        end
         if(compelateEvent ~= nil)then
            compelateEvent(newList)
        end
    end
end

local function satrtBornBetProccess(betArr, compelateEvent)
    BornBetProccess(1, 1, betArr, compelateEvent)
end

local function BornBetUIByMoney(num, compelateEvent)
    local needNewObjList = {} 
    while(num > 0) do
        if(num >= GameData71.BetList[6])then
            num = num - GameData71.BetList[6]
            needNewObjList[#needNewObjList + 1] = 6
        elseif(num >= GameData71.BetList[5])then
            num = num - GameData71.BetList[5]
            needNewObjList[#needNewObjList + 1] = 5
        elseif(num >= GameData71.BetList[4])then
            num = num - GameData71.BetList[4]
            needNewObjList[#needNewObjList + 1] = 4
        elseif(num >= GameData71.BetList[3])then
            num = num - GameData71.BetList[3]
            needNewObjList[#needNewObjList + 1] = 3
        elseif(num >= GameData71.BetList[2])then
            num = num - GameData71.BetList[2]
            needNewObjList[#needNewObjList + 1] = 2
        elseif(num >= GameData71.BetList[1])then
            num = num - GameData71.BetList[1]
            needNewObjList[#needNewObjList + 1] = 1
        else
            logError("生成筹码有多余的注值："..num)
            needNewObjList[#needNewObjList + 1] = 1
            num = 0
        end
    end

    satrtBornBetProccess(needNewObjList, compelateEvent)
end

local function InitBetUI()
    if(GameData71.TianArea_Bet > 0)then
        BornBetUIByMoney(GameData71.TianArea_Bet, function(newBetList)
            for k, v in pairs(newBetList) do -- 
                if(v ~= nil)then
                    v.Obj.transform:SetParent(self.BetPoint_Tian.parent, false)
                    v.Obj.transform.localScale = Vector3.New(0.3, 0.3, 1)
                    v.Obj.transform.localPosition = Vector3.New(math.random(-65, 65) + self.BetPoint_Tian.localPosition.x, 
                    math.random(-34, 40) + self.BetPoint_Tian.localPosition.y, 0)
                    table.insert(self.BetUIAreaList[1], v)
                else
                    logError("生成的筹码UI有空值1")
                end
            end
        end)
    end

    if(GameData71.DiArea_Bet > 0)then
        BornBetUIByMoney(GameData71.DiArea_Bet,function(newBetList)
            for k, v in pairs(newBetList) do -- 
                if(v ~= nil)then
                    v.Obj.transform:SetParent(self.BetPoint_Di.parent, false)
                    v.Obj.transform.localScale = Vector3.New(0.3, 0.3, 1)
                    v.Obj.transform.localPosition = Vector3.New(math.random(-65, 65) + self.BetPoint_Di.localPosition.x, 
                    math.random(-34, 40) + self.BetPoint_Di.localPosition.y, 0)
                    table.insert(self.BetUIAreaList[2], v)
                else
                    logError("生成的筹码UI有空值1")
                end
            end
        end)
    end

    if(GameData71.XuanArea_Bet > 0)then
       BornBetUIByMoney(GameData71.XuanArea_Bet,function(newBetList)
            for k, v in pairs(newBetList) do -- 
                if(v ~= nil)then
                    v.Obj.transform:SetParent(self.BetPoint_Xuan.parent, false)
                    v.Obj.transform.localScale = Vector3.New(0.3, 0.3, 1)
                    v.Obj.transform.localPosition = Vector3.New(math.random(-65, 65) + self.BetPoint_Xuan.localPosition.x,
                    math.random(-34, 40)  + self.BetPoint_Xuan.localPosition.y, 0)
                    table.insert(self.BetUIAreaList[3], v)
                else
                    logError("生成的筹码UI有空值1")
                end
            end
        end)
    end

    if(GameData71.HuangArea_Bet > 0)then
        BornBetUIByMoney(GameData71.HuangArea_Bet,function(newBetList)
            for k, v in pairs(newBetList) do -- 
                if(v ~= nil)then
                    v.Obj.transform:SetParent(self.BetPoint_Huang.parent, false)
                    v.Obj.transform.localScale = Vector3.New(0.3, 0.3, 1)
                    v.Obj.transform.localPosition = Vector3.New(math.random(-65, 65) + self.BetPoint_Huang.localPosition.x, 
                    math.random(-34, 40) + self.BetPoint_Huang.localPosition.y, 0)
                    table.insert(self.BetUIAreaList[4], v)
                else
                    logError("生成的筹码UI有空值1")
                end
            end
        end)
    end

    --GameData71.BeList
end


local function InitData()
    local newAlphaFade1 = class_a("AlphaFade", AlphaFade)
    local newAlphaFade2 = class_a("AlphaFade", AlphaFade)
    self.AlphaFadeList = {}
    self.AlphaFadeList[1] = newAlphaFade1
    self.AlphaFadeList[2] = newAlphaFade2
    self.Desk = self.transform:Find("bg/bg1/Desk")
    self.Info = self.transform:Find("bg/bg1/Info").gameObject
    self.BtnPlane = self.transform:Find("bg/bg1/BtnPlane").gameObject
    self.Info.transform:Find("Rule").gameObject:SetActive(false);
    --self.Info.transform:Find("bank").gameObject:SetActive(false);
    self.Info.transform:Find("PlayerList").gameObject:SetActive(false);
    self.Info.transform:Find("TileGuaDian/SwitchBankerTile").gameObject:SetActive(false)
    self.Info.transform:Find("BankPlane").gameObject:SetActive(false)
    self.Info.transform:Find("Set").gameObject:SetActive(false);
    self.BetPoint_Other =  self.Info.transform:Find("Betpoint/OtherPlayerBetPoint")
    self.BetPoint_Banker =  self.Info.transform:Find("Betpoint/BankerBetPoint")
    self.BetPoint_Tian =  self.Info.transform:Find("Betpoint/TianBetPoint")
    self.BetPoint_Di =  self.Info.transform:Find("Betpoint/DiBetPoint")
    self.BetPoint_Xuan =  self.Info.transform:Find("Betpoint/XuanBetPoint")
    self.BetPoint_Huang =  self.Info.transform:Find("Betpoint/HuangBetPoint")
    self.BetPoint_Self = self.Info.transform:Find("Betpoint/SelfBetPoint")
    self.ResultPlane = self.Info.transform:Find("ResultPlane")
    self.PlayerListItemModel = self.Info.transform:Find("PlayerList/PlayerItemModel")
    self.PlayerListUI = self.Info.transform:Find("PlayerList")
    self.PlayerListUI.transform.gameObject:SetActive(true)
    self.PlayerListUI.transform.localPosition = Vector3.New(-1500, 0, 0)
    self.TianAreaBetText = self.BtnPlane.transform:Find("CustomBtn/Tian_Btn/Text"):GetComponent("Text")
    self.DiAreaBetText = self.BtnPlane.transform:Find("CustomBtn/Di_Btn/Text"):GetComponent("Text")
    self.XuanAreaBetText = self.BtnPlane.transform:Find("CustomBtn/Xuan_Btn/Text"):GetComponent("Text")
    self.HuangAreaBetText = self.BtnPlane.transform:Find("CustomBtn/Huang_Btn/Text"):GetComponent("Text")

    self.TianAreaMyBetText = self.BtnPlane.transform:Find("CustomBtn/Tian_Btn/MyBetText"):GetComponent("Text")
    self.DiAreaMyBetText = self.BtnPlane.transform:Find("CustomBtn/Di_Btn/MyBetText"):GetComponent("Text")
    self.XuanAreaMyBetText = self.BtnPlane.transform:Find("CustomBtn/Xuan_Btn/MyBetText"):GetComponent("Text")
    self.HuangAreaMyBetText = self.BtnPlane.transform:Find("CustomBtn/Huang_Btn/MyBetText"):GetComponent("Text")

    self.WaitForNextTurn = self.Info.transform:Find("WaitForNext")
    self.Gril = self.transform:Find("bg/bg1/Bg/Grils")
    self.GrilMovePointArr = {}
    GameData71.GrilsMoveJianGe = 5
    GameData71.MoveTime = {1.5, 0.3, 2, 2, 1.5}
    for i = 0, self.transform:Find("bg/bg1/Bg/GrilMovePos").childCount - 1 do
        self.GrilMovePointArr[i + 1] = self.transform:Find("bg/bg1/Bg/GrilMovePos"):GetChild(i)
    end

    local pool_parobj = self.transform:Find("bg/bg1/Pool/PicRes")
    local sp_ResObj = {}
    for i = 0, pool_parobj.childCount - 1 do 
        sp_ResObj[#sp_ResObj + 1] = pool_parobj:GetChild(i):GetComponent("Image")
    end
    ResManager.InitSprite(sp_ResObj)
    
    local pool_parPreobj = self.transform:Find("bg/bg1/Pool/PrefabRes/perfab")
    local sp_PreResObj = {}
    for i = 0, pool_parPreobj.childCount - 1 do 
        sp_PreResObj[#sp_PreResObj + 1] = pool_parPreobj:GetChild(i)
    end
    ResManager.InitPrefab(sp_PreResObj)

    local pool_parAudiobj = self.transform:Find("bg/bg1/Pool/AduioClipRes")
    local sp_AdioResObj = {}
    for i = 0, pool_parAudiobj.childCount - 1 do 
        sp_AdioResObj[#sp_AdioResObj + 1] = pool_parAudiobj:GetChild(i):GetComponent("AudioSource").clip
    end
    ResManager.InitAudioClip(sp_AdioResObj)

    local pool_parEffectobj = self.transform:Find("bg/bg1/Pool/PrefabRes/Effect")
    local sp_EffectResObj = {}
    for i = 0, pool_parEffectobj.childCount - 1 do 
        sp_EffectResObj[#sp_EffectResObj + 1] = pool_parEffectobj:GetChild(i).gameObject
    end
    ResManager.InitEffect(sp_EffectResObj)
    logError("-1111111111")
    SetBankerUI()
    logError("-1111111111222222222")
    SetMineUI()
    logError("-1111111111333333333333")
    SetDeskInfo()
    logError("-11111111113333333333335555")
    SetBtn()
    logError("-1111111111333333333333---")
    InitBetUI()
    UpdateCurChooseBetBtnUI()
    InitLudan()
    logError("-111111111144444444444")
    newAlphaFade1:SetAlphaVal(self.Info, 0)
    newAlphaFade2:SetAlphaVal(self.BtnPlane, 0)
    logError("000000000000000000")
    self.Info:GetComponent("CanvasGroup").interactable = false
    self.BtnPlane:GetComponent("CanvasGroup").interactable = false
    self.Desk.localPosition = Vector3.New(0, -300, 0)
    logError("1111111111111115551")
    self.Desk:DOLocalMove(Vector3.New(0, -164, 0), 1.5):SetEase(DG.Tweening.Ease.OutCubic):OnComplete(OnShowScene)
    self.ResultPlane.gameObject:SetActive(false)
    self.transform.gameObject:SetActive(true)
    if(self.WaitGameToOver)then
        self.WaitForNextTurn.gameObject:SetActive(true)
    else
        self.WaitForNextTurn.gameObject:SetActive(false)
    end
end



function Game71Panel.UpdateBetInfo(buffer)
    local Limit = buffer:ReadInt32()
    local AllBet = {}
    AllBet[1] = buffer:ReadInt32()
    AllBet[2] = buffer:ReadInt32()
    AllBet[3] = buffer:ReadInt32()
    AllBet[4] = buffer:ReadInt32()
    GameData71.InitAllBetData(AllBet)
    self.Mine.AllBetInfo[1] = buffer:ReadInt32()
    self.Mine.AllBetInfo[2] = buffer:ReadInt32()
    self.Mine.AllBetInfo[3] = buffer:ReadInt32()
    self.Mine.AllBetInfo[4] = buffer:ReadInt32()

   UpdateBetInfo()
end

function Game71Panel.ShanChuPlayerInfo(LeaveID)
    PlayerList.RemovePlayer(LeaveID)
end

function Game71Panel.UpdateMyGold(money)
    self.Mine.Money = money
    self.Info.transform:Find("PlayerInfo/Coin/Text"):GetComponent("Text").text = NumFormat.format1(self.Mine.Money, 2)
end

function Game71Panel.UpdatePlayerMoney(data)
    
    if(data._uid == SCPlayerInfo._01dwUser_Id) then
        log("刷新自己金币信息")
        self.Mine.Money = data._gold
         UpdateMyMoneyUI()
    else
        log("刷新其它玩家金币信息")
    end

    PlayerList.UpdatePlayerGold(data)
    logError("update data._chairId: "..tostring(data._chairId).."  GameData71.CurBanker.ChairId: "..GameData71.CurBanker.ChairId.."   data._gold: "..tostring(data._gold))
    if(data._chairId == GameData71.CurBanker.ChairId)then
         self.Info.transform:Find("BankerInfo/BankerMoneyBg/Text"):GetComponent("Text").text = NumFormat.format1(data._gold, 2)
         GameData71.CurBanker.money = data._gold
    end
end

function Game71Panel.UpBankeResult(buffer)
    local result = buffer:ReadByte()
    if(result == 0)then
       MessageBox.CreatGeneralTipsPanel("上庄成功")
       GameData71.CurBanker.name = self.Mine.name
       GameData71.CurBanker.money = self.Mine.Money
       SetBankerUI()
    elseif(result == 1)then
        MessageBox.CreatGeneralTipsPanel("金币不足以上庄")
    elseif(result == 2)then
        MessageBox.CreatGeneralTipsPanel("已在上庄列表中")
    end
end

function Game71Panel.UpBankerListResult(buffer)
    local upBankNum = buffer:ReadByte()
    if(upBankNum > 10)then
        upBankNum = 10
    end
    local UpBankerList = {}
    for i = 1, Count do
        UpBankerList[i] = {}
        UpBankerList[i].Charid = buffer:ReadUInt16()
        UpBankerList[i].money = buffer:ReadInt32()
        UpBankerList[i].name = buffer:ReadString(32)
    end
    GameData71.SetUpBankerList(UpBankerList)
    UpdateUpBankerCountUI()
end

function Game71Panel.PlayerBetFail(buffer)
    local reslut = buffer:ReadByte()
    if(reslut == 0)then
        MessageBox.CreatGeneralTipsPanel("下注超过限制")
    elseif(reslut == 1)then
        MessageBox.CreatGeneralTipsPanel("金币不足")
    elseif(reslut == 2)then
    end
end

function Game71Panel.PlayerBetResult(buffer, size)
    if(self.WaitGameToOver)then
        logError("WaitGameToOver")
        return
    end
    if(buffer == nil)then
         logError("bet return buffer is nil")
    end
    local userId = buffer:ReadInt32()
    local Area = buffer:ReadByte()
    local BetNum = buffer:ReadInt32()
    local betpar = nil
    if(Area == 0)then
        betpar =  self.BetPoint_Tian
    elseif(Area == 1)then
        betpar =  self.BetPoint_Di
    elseif(Area == 2)then
        betpar =  self.BetPoint_Xuan
    elseif(Area == 3)then
        betpar =  self.BetPoint_Huang
    end
    local allbet = {0, 0, 0, 0}
    allbet[Area + 1] = BetNum
    GameData71.AddAllBetData(allbet)
   
    self.playShortMusic("sound-betlow")
    if(userId == self.Mine.Id)then
        self.Mine.Money = self.Mine.Money - BetNum
        self.Mine.AllBetInfo[Area + 1] = self.Mine.AllBetInfo[Area + 1] + BetNum
        UpdateMyMoneyUI()
        BornBetUIByMoney(BetNum, function(newBetList)
            for k, v in pairs(newBetList) do
                if(v ~= nil)then
                    local str = ("Betpoint/BetPoint"..tostring(GameData71.CurBetIndex))
                    local trans = self.Info.transform:Find(str)

                     --[[
                    if(v.Obj == nil)then
                        logError("v.Obj is nil")
                    elseif(v.Obj.transform == nil)then
                        logError("v.Obj.transform is nil")
                    elseif(v.Obj.transform.gameObject == nil)then
                        logError("v.Obj.transform.gameObject is nil")
                    end
                     ]]

                    v.Obj.transform.gameObject:SetActive(true)
                    v.Obj.transform:SetParent(trans.parent, false)
                    v.Obj.transform.localScale = Vector3.New(0.3, 0.3, 1)
                    v.Obj.transform.localPosition = trans.localPosition
                    v.Obj.transform:DOLocalMove(Vector3.New(betpar.localPosition.x + math.random(-65, 65), 
                    betpar.localPosition.y + math.random(-34, 40), 0), 0.4):OnComplete(function()
                        v.Obj.transform.localScale = Vector3.New(0.3, 0.3, 1)
                        table.insert(self.BetUIAreaList[Area + 1], v)
                    end)
                else
                    logError("生成的筹码UI有空值3")
                end
            end
        end)
    else
        logError("他人下注: "..tostring(userId))
        BornBetUIByMoney(BetNum, function(newBetList)
            for k, v in pairs(newBetList) do
                if(v ~= nil)then
                    v.Obj.transform:SetParent(self.BetPoint_Other.parent, false)
                    v.Obj.transform.gameObject:SetActive(true)
                    v.Obj.transform.localScale = Vector3.New(0.3, 0.3, 1)
                    v.Obj.transform.localPosition = self.BetPoint_Other.transform.localPosition
                    v.Obj.transform:DOLocalMove(Vector3.New(betpar.localPosition.x + math.random(-65, 65), 
                    betpar.localPosition.y + math.random(-34, 40), 0), 0.4):OnComplete(function()
                        v.Obj.transform.localScale = Vector3.New(0.3, 0.3, 1)
                        table.insert(self.BetUIAreaList[Area + 1], v)
                    end)
                else
                    logError("生成的筹码UI有空值3")
                end
            end
        end)
    end
    UpdateBetInfo()
end

function Game71Panel.AddPlayerInfo(data)
    local newplay = class_a("Player", player)
    newplay.ChairId = data.ChairId
    newplay.Money = data.Money
    newplay.name = data.name
    newplay.Id = data.Id
    newplay.spName = data.spName
    PlayerList.AddPlayer(newplay)
end

local function ShowStopBetTile()
    if(self.BetDJS ~= nil)then
        destroy(self.BetDJS.gameObject)
        self.BetDJS = nil
    end
    self.StopBetTile = newObject(ResManager.GetPrefabByName("StopBetTile"))
    self.StopBetTile.transform:SetParent(self.Info.transform:Find("TileGuaDian") ,false)
    self.StopBetTile.transform.localScale = Vector3.New(1, 1, 1)
    DeLayRun.AddDelay(1.5, function()
        if(self.StopBetTile ~= nil)then
            destroy(self.StopBetTile.gameObject)
            self.StopBetTile = nil
        end
    end, nil, nil)
end

function Game71Panel.StopBet(buffer)
    self.playShortMusic("sound-end-wager") 
    UnActiveButton()
    ShowStopBetTile()
    GameData71.CurGameState = GameData71.GameState.GAME_STATE_GAME_WAIT
    self.Info.transform:Find("DJS/Tile"):GetComponent("Image").sprite = ResManager.GetSpriteByName("XiaZhuZhong").sprite

    if(self.Mine:GetAllCurBet() > 0)then
        for k, v in pairs(self.Mine.AllBetInfo)do
            self.Mine.XuYaInfo[k] = v
        end
    end
end

local function ChooseFlyArea(AreaWinNumArr, startIndex, betUIList)
    for i = 0, #AreaWinNumArr - 1 do
        if(betUIList[startIndex].val <= AreaWinNumArr[(startIndex + i) % (#AreaWinNumArr) + 1].val)then
            return (startIndex + i) % (#AreaWinNumArr) + 1
        end
    end
    --logError("选择飞向区域失败: "..tostring(betUIList[startIndex].val))
    return -1
end

local function FlyBetOneToMore(betUIList, startIndex, jiange, AreaWinNumArr)
    --logError("FlyBetOneToMore  #betUIList: "..tostring(#betUIList))
    if(startIndex + jiange < #betUIList and startIndex / jiange < 20)then
        for i = startIndex, startIndex + jiange do
            local index = -1
            
            while(index == -1)do
                index = ChooseFlyArea(AreaWinNumArr, i, betUIList)
                if(index == -1)then
                    i = i + 1
                    if(i > startIndex + jiange)then
                        DeLayRun.AddDelay(0.1, function() FlyBetOneToMore(betUIList, startIndex + jiange + 1, jiange, AreaWinNumArr) end, nil, nil)
                        return
                    end
                end
            end
            AreaWinNumArr[index].val = AreaWinNumArr[index].val - betUIList[i].val
            --logError("  剩余金币: "..tostring(AreaWinNumArr[index].val).."   减去金币： "..tostring(betUIList[i].val))
            local TargetPos = {}
            local TargetArea = AreaWinNumArr[index].Area
             if(TargetArea == 1)then --天区域
            TargetPos = self.BetPoint_Tian.localPosition
            elseif(TargetArea == 2) then --地区域
                TargetPos = self.BetPoint_Di.localPosition
            elseif(TargetArea == 3) then --玄区域
                TargetPos = self.BetPoint_Xuan.localPosition
            elseif(TargetArea == 4) then --黄区域
                TargetPos = self.BetPoint_Huang.localPosition
            else
                logError("target bet Area erro1: "..tostring(TargetArea))
                return
            end
            betUIList[i].Obj.transform.gameObject:SetActive(true)
            betUIList[i].Obj.transform:DOLocalMove(Vector3.New(TargetPos.x + math.random(-65, 65), TargetPos.y + math.random(-34, 40), 0), 0.4)
            table.insert(self.BetUIAreaList[TargetArea], betUIList[i])
            self.BankerBetOut[i] = 1
            --logError("Insert Aear: "..tostring(TargetArea).."   self.BetUIAreaList[TargetArea] len: "..tostring(#self.BetUIAreaList[TargetArea]))
        end
        DeLayRun.AddDelay(0.1, function() FlyBetOneToMore(betUIList, startIndex + jiange + 1, jiange, AreaWinNumArr)end, nil, nil)
    else
        for i = startIndex, startIndex + 5 do
            if(i > #betUIList)then
                break;
            end
            local index = -1
            while(index == -1)do
                index = ChooseFlyArea(AreaWinNumArr, i, betUIList)
                if(index == -1)then
                    --logError("FlyBetOneToMore startIndex: "..startIndex)
                    i = i + 1
                    if(i > #betUIList)then
                        return
                    end
                end
            end
            AreaWinNumArr[index].val = AreaWinNumArr[index].val - betUIList[i].val
            local TargetPos = {}
            local TargetArea =  AreaWinNumArr[index].Area
             if(TargetArea == 1)then --天区域
            TargetPos = self.BetPoint_Tian.localPosition
            elseif(TargetArea == 2) then --地区域
                TargetPos = self.BetPoint_Di.localPosition
            elseif(TargetArea == 3) then --玄区域
                TargetPos = self.BetPoint_Xuan.localPosition
            elseif(TargetArea == 4) then --黄区域
                TargetPos = self.BetPoint_Huang.localPosition
            else
                logError("target bet Area erro2: "..tostring(TargetArea))
                return
            end
            betUIList[i].Obj.transform.gameObject:SetActive(true)
            betUIList[i].Obj.transform:DOLocalMove(Vector3.New(TargetPos.x + math.random(-65, 65), TargetPos.y + math.random(-34, 40), 0), 0.4)
            table.insert(self.BetUIAreaList[TargetArea], betUIList[i])
            self.BankerBetOut[i] = 1
            --logError("Insert Aear: "..tostring(TargetArea).."   self.BetUIAreaList[TargetArea] len: "..tostring(#self.BetUIAreaList[TargetArea]))
        end
    end
end


local function FlyBetMoreToOne(Area, startIndex, jiange, targetpos, clear)
    if(startIndex + jiange < #self.BetUIAreaList[Area] and startIndex / jiange < 20)then
        for i = startIndex, startIndex + jiange do
            local j = i
            local go = self.BetUIAreaList[Area][i].Obj
            go.transform.gameObject:SetActive(true)
            self.BetUIAreaList[Area][i].Obj.transform:DOLocalMove(targetpos, 0.4):OnComplete(function() go.transform.gameObject:SetActive(false) end)
        end
        --logError("startIndex: "..tostring(startIndex).."   #self.BetUIAreaList[Area]: "..tostring(#self.BetUIAreaList[Area]))

        DeLayRun.AddDelay(0.1, function() FlyBetMoreToOne(Area, startIndex + jiange + 1, jiange, targetpos, clear)end, nil, nil)
    else
        for i = startIndex, #self.BetUIAreaList[Area] do
            local j = i
            local go = self.BetUIAreaList[Area][i].Obj
            go.transform.gameObject:SetActive(true)
            self.BetUIAreaList[Area][i].Obj.transform:DOLocalMove(targetpos, 0.4):OnComplete(function() go.transform.gameObject:SetActive(false) end)
        end
        if(clear)then
            self.BetUIAreaList[Area] = {}
        end
    end
end

local function FlyBetMoreToOne1(betUIList, startIndex, jiange, targetpos)
    if(startIndex + jiange < #betUIList and startIndex / jiange < 20)then
        for i = startIndex, startIndex + jiange do
            local j = i
            local go = betUIList[i].Obj
            go.transform.gameObject:SetActive(true)
            betUIList[i].Obj.transform:DOLocalMove(targetpos, 0.4):OnComplete(function() go.transform.gameObject:SetActive(false) end)
        end
        DeLayRun.AddDelay(0.1, function() FlyBetMoreToOne1(betUIList, startIndex + jiange + 1, jiange, targetpos)end, nil, nil)
    else
        for i = startIndex, #betUIList do
            local j = i
            local go = betUIList[i].Obj
            go.transform.gameObject:SetActive(true)
            betUIList[i].Obj.transform:DOLocalMove(targetpos, 0.4):OnComplete(function() go.transform.gameObject:SetActive(false) end)
        end
    end
end

local function AreaFlyBetToWiner()
    local betArr = { GameData71.TianArea_Bet,
                     GameData71.DiArea_Bet,
                     GameData71.XuanArea_Bet,
                     GameData71.HuangArea_Bet}

    for k, v in pairs(GameData71.AreaWin) do
        if(v == 0 and self.Mine.Win[k] ~= nil)then
            if(self.Mine.Win[k] > 0)then
                self.MineUIArr = {}
                if(self.Mine.AllBetInfo[k] >= betArr[k])then
                    if(#self.BetUIAreaList[k] > 0)then
                        self.FlyAreaBetToArea(k, 7)
                    end
                else
                    local windata = self.Mine.Win[k] + self.Mine.AllBetInfo[k]
                    for i = #self.BetUIAreaList[k], 1, -1 do
                        if(self.BetUIAreaList[k][i].val <= self.Mine.Win[k])then
                             self.MineUIArr[# self.MineUIArr + 1] = self.BetUIAreaList[k][i]
                            windata = windata - self.BetUIAreaList[k][i].val
                            table.remove(self.BetUIAreaList[k], i)
                            if(windata < GameData71.BetList[1])then
                                break
                            end
                        end
                    end

                    local len = #self.MineUIArr
                    local jiange = 1
                    if(len < 5) then
                        jiange = 1
                        elseif(len <20)then
                        jiange = 2
                        elseif(len < 100)then
                        jiange = 5
                        else
                        jiange = 10
                    end
                    local TargetPos = self.BetPoint_Self.localPosition
                    FlyBetMoreToOne1(self.MineUIArr, 1, jiange, TargetPos)
                    if(#self.BetUIAreaList[k] > 0)then
                        self.FlyAreaBetToArea(k, 6)
                    end
                end
            else
                if(#self.BetUIAreaList[k] > 0)then
                    self.FlyAreaBetToArea(k, 6)
                end
            end
        end
    end
end

local function BankerFlyBetToArea()
    local AreaWinNumArr = {}
    for k, v in pairs(GameData71.BankerAreaWin)do
        if(v < 0)then
            local  len = #AreaWinNumArr + 1
            AreaWinNumArr[len] = {}
            local kkb = GameData71.CardType[k]
            if(kkb > 10)then
                kkb = 10
            elseif( kkb == 0)then
                kkb = 1
            end
            AreaWinNumArr[len].val = math.abs(GameData71.BankerAreaWin[k]) * kkb
            AreaWinNumArr[len].Area = k
            --logError("Area: "..tostring(k).."   len: "..tostring(len).."AreaWinNumArr[len].val: "..tostring(AreaWinNumArr[len].val))
        end
    end

    local len = #self.BankerBornBet
    local jiange = 1
    local TargetPos = nil
    if(len < 5) then
        jiange = 1
        elseif(len <20)then
        jiange = 2
        elseif(len < 100)then
        jiange = 5
        else
        jiange = 10
    end

    FlyBetOneToMore(self.BankerBornBet, 1, jiange, AreaWinNumArr)
end

function Game71Panel.FlyAreaBetToArea(OrginArea, TargetArea)
    local len = #self.BetUIAreaList[OrginArea]
    local jiange = 1
    local TargetPos = nil
    if(len < 5) then
        jiange = 1
        elseif(len < 20)then
        jiange = 2
        elseif(len < 100)then
        jiange = 5
        else
        jiange = 10
    end

     local clear = false
    if(TargetArea == 5)then --庄家区域
        TargetPos = self.BetPoint_Banker.localPosition
        for k, v in pairs(self.BetUIAreaList[OrginArea])do
            table.insert(self.BankerBornBet, v)
        end
         clear = true
    elseif(TargetArea == 6) then --其他玩家区域
        TargetPos = self.BetPoint_Other.localPosition
    elseif(TargetArea == 7) then --自己区域
        TargetPos = self.BetPoint_Self.localPosition
    else
        logError("target bet Area erro4: "..tostring(TargetArea))
        return
    end
    FlyBetMoreToOne(OrginArea, 1, jiange, TargetPos, clear)
end

local function CollectBet()
    for k, v in pairs(self.BetUIAreaList)do
        for k1, v1 in pairs(v)do
            if(v1.val == GameData71.BetList[1])then
                table.insert(self.BetUIList[1], v1)
            elseif(v1.val == GameData71.BetList[2])then          
                table.insert(self.BetUIList[2], v1)
            elseif(v1.val == GameData71.BetList[3])then
                table.insert(self.BetUIList[3], v1)
            elseif(v1.val == GameData71.BetList[4])then
                table.insert(self.BetUIList[4], v1)
            elseif(v1.val == GameData71.BetList[5])then
                table.insert(self.BetUIList[5], v1)
            elseif(v1.val == GameData71.BetList[6])then
                table.insert(self.BetUIList[6], v1)
            end
        end
    end

    for k, v1 in pairs(self.BankerBornBet)do
        if(self.BankerBetOut[k] == nil)then
            if(v1.val == GameData71.BetList[1])then
                table.insert(self.BetUIList[1], v1)
            elseif(v1.val == GameData71.BetList[2])then
                table.insert(self.BetUIList[2], v1)
            elseif(v1.val == GameData71.BetList[3])then
                table.insert(self.BetUIList[3], v1)
            elseif(v1.val == GameData71.BetList[4])then
                table.insert(self.BetUIList[4], v1)
            elseif(v1.val == GameData71.BetList[5])then
                table.insert(self.BetUIList[5], v1)
            elseif(v1.val == GameData71.BetList[6])then
                table.insert(self.BetUIList[6], v1)
            end
        end
    end

    if(self.MineUIArr ~= nil and #self.MineUIArr > 0)then
        for k1, v1 in pairs(self.MineUIArr)do
            if(v1.val == GameData71.BetList[1])then
                table.insert(self.BetUIList[1], v1)
            elseif(v1.val == GameData71.BetList[2])then
                table.insert(self.BetUIList[2], v1)
            elseif(v1.val == GameData71.BetList[3])then
                table.insert(self.BetUIList[3], v1)
            elseif(v1.val == GameData71.BetList[4])then
                table.insert(self.BetUIList[4], v1)
            elseif(v1.val == GameData71.BetList[5])then
                table.insert(self.BetUIList[5], v1)
            elseif(v1.val == GameData71.BetList[6])then
                table.insert(self.BetUIList[6], v1)
            end
        end
    end

    self.BetUIAreaList = {{}, {}, {}, {}}
    self.MineUIArr = {}
    self.BankerBornBet = {}
end

local function ShowResultPlane()
    local Bg = self.ResultPlane:Find("Bg")
    if( GameData71.CurBanker.name ~= nil)then
        Bg:Find("BankerTile/BankerName"):GetComponent("Text").text = GameData71.CurBanker.name
        Bg:Find("BankerCardType"):GetComponent("Image").sprite = ResManager.GetSpriteByName("niuniu"..tostring(GameData71.CardType[5])).sprite
        Bg:Find("BankerCardType"):GetComponent("Image"):SetNativeSize()
        if(GameData71.BankerWin >= 0)then
            Bg:Find("BankerCardType/WinText").gameObject:SetActive(true)
            Bg:Find("BankerCardType/LoseText").gameObject:SetActive(false)
            Bg:Find("BankerCardType/WinText"):GetComponent("Text").text = NumFormat.format1(GameData71.BankerWin, 2)
        else
            Bg:Find("BankerCardType/WinText").gameObject:SetActive(false)
            Bg:Find("BankerCardType/LoseText").gameObject:SetActive(true)
            Bg:Find("BankerCardType/LoseText"):GetComponent("Text").text = NumFormat.format2(GameData71.BankerWin, 2)
        end
    end
   
    Bg:Find("GuanJun").gameObject:SetActive(true)
    Bg:Find("GuanJun/name"):GetComponent("Text").text = GameData71.TopThree[1].name
    Bg:Find("GuanJun/win"):GetComponent("Text").text = NumFormat.format2(GameData71.TopThree[1].WinGold, 2)
    Bg:Find("YaJun").gameObject:SetActive(true)
    Bg:Find("YaJun/name"):GetComponent("Text").text = GameData71.TopThree[2].name
    Bg:Find("YaJun/win"):GetComponent("Text").text = NumFormat.format2(GameData71.TopThree[2].WinGold, 2)
    Bg:Find("JiJun").gameObject:SetActive(true)
    Bg:Find("JiJun/name"):GetComponent("Text").text = GameData71.TopThree[3].name
    Bg:Find("JiJun/win"):GetComponent("Text").text = NumFormat.format2(GameData71.TopThree[3].WinGold, 2)

    if(self.Mine:GetAllCurBet() > 0)then
        DeLayRun.AddDelay(1, function()
            if(self.AlphaFadeList[3] == nil)then
                local newAlphaFade = class_a("AlphaFade", AlphaFade)
                self.AlphaFadeList[3] = newAlphaFade
            end
             self.AlphaFadeList[3]:StartFade(Bg:Find("JieSuan"), 1, 1, nil)
        end)
    else
        DeLayRun.AddDelay(1, function()
            Bg:Find("NoBetTile").gameObject:SetActive(true)
        end, nil, nil)
    end

    local obj_tian = Bg:Find("TianCardType")
    obj_tian.gameObject:SetActive(true)
    obj_tian:GetComponent("Image").sprite = ResManager.GetSpriteByName("niuniu"..tostring(GameData71.CardType[1])).sprite
    obj_tian:GetComponent("Image"):SetNativeSize()
    obj_tian.transform.localScale = Vector3.New(3, 3, 3)
    obj_tian.transform:DOScale(Vector3.New(1, 1, 1), 0.25)

    DeLayRun.AddDelay(0.25, function()
        local obj_di = Bg:Find("DiCardType")
        obj_di.gameObject:SetActive(true)
        obj_di:GetComponent("Image").sprite = ResManager.GetSpriteByName("niuniu"..tostring(GameData71.CardType[2])).sprite
        obj_di:GetComponent("Image"):SetNativeSize()
        obj_di.transform.localScale = Vector3.New(3, 3, 3)
        obj_di.transform:DOScale(Vector3.New(1, 1, 1), 0.25)
    end, nil, nil)

    DeLayRun.AddDelay(0.5, function()
        local obj_xuan = Bg:Find("XuanCardType")
        obj_xuan.gameObject:SetActive(true)
        obj_xuan:GetComponent("Image").sprite = ResManager.GetSpriteByName("niuniu"..tostring(GameData71.CardType[3])).sprite
        obj_xuan:GetComponent("Image"):SetNativeSize()
        obj_xuan.transform.localScale = Vector3.New(3, 3, 3)
        obj_xuan.transform:DOScale(Vector3.New(1, 1, 1), 0.25)
    end, nil, nil)

    DeLayRun.AddDelay(0.75, function()
        local obj_huang = Bg:Find("HuangCardType")
        obj_huang.gameObject:SetActive(true)
        obj_huang:GetComponent("Image").sprite = ResManager.GetSpriteByName("niuniu"..tostring(GameData71.CardType[4])).sprite
        obj_huang:GetComponent("Image"):SetNativeSize()
        obj_huang.transform.localScale = Vector3.New(3, 3, 3)
        obj_huang.transform:DOScale(Vector3.New(1, 1, 1), 0.25)
    end, nil, nil)

end

local function PopResultPlane()
    self.ResultPlane.gameObject:SetActive(true)
    local Bg = self.ResultPlane:Find("Bg")
    Bg.transform.localScale = Vector3.New(0, 0, 0)
    Bg:Find("JieSuan"):GetComponent("CanvasGroup").alpha = 0
    Bg:Find("NoBetTile").gameObject:SetActive(false)
    Bg:Find("TianCardType").gameObject:SetActive(false)
    Bg:Find("DiCardType").gameObject:SetActive(false)
    Bg:Find("XuanCardType").gameObject:SetActive(false)
    Bg:Find("HuangCardType").gameObject:SetActive(false)
    Bg.transform:DOScale(1, 0.25):SetEase(DG.Tweening.Ease.OutBack):OnComplete(function() ShowResultPlane() end)

    if(self.Mine:GetAllCurWin() >= 0)then
        Bg:GetComponent("Image").sprite = ResManager.GetSpriteByName("WinResultBg").sprite
        Bg:Find("JieSuan"):GetComponent("Image").sprite = ResManager.GetSpriteByName("WinJS").sprite
        Bg:Find("JieSuan/Win_Text").gameObject:SetActive(true)
        Bg:Find("JieSuan/Lose_Text").gameObject:SetActive(false)
        Bg:Find("JieSuan/Win_Text"):GetComponent("Text").text = "+"..NumFormat.format1(self.Mine:GetAllCurWin(), 2)
        Game71Panel.playShortMusic("win")
        Bg:Find("WinJieSuan").gameObject:SetActive(true)
        Bg:Find("FailJieSuan").gameObject:SetActive(false)
    else
        Bg:GetComponent("Image").sprite = ResManager.GetSpriteByName("FailResultBg").sprite
        Bg:Find("JieSuan"):GetComponent("Image").sprite = ResManager.GetSpriteByName("LoseJS").sprite
        Bg:Find("JieSuan/Win_Text").gameObject:SetActive(false)
        Bg:Find("JieSuan/Lose_Text").gameObject:SetActive(true)
        Bg:Find("JieSuan/Lose_Text"):GetComponent("Text").text = NumFormat.format1(self.Mine:GetAllCurWin(), 2)
        Game71Panel.playShortMusic("fail")
        Bg:Find("WinJieSuan").gameObject:SetActive(false)
        Bg:Find("FailJieSuan").gameObject:SetActive(true)
    end
end

local function StartFlyBet()
    local time = 0
    for k, v in pairs(GameData71.BankerAreaWin)do
        if(v > 0)then
            time = time + 2
            if(time > 2)then
                time = 2
            end
            self.playShortMusic("fly_gold")
            self.FlyAreaBetToArea(k, 5)
        end
    end

    for k, v in pairs(GameData71.BankerAreaWin)do
         if(v < 0)then
            DeLayRun.AddDelay(time, function() 
            self.playShortMusic("fly_gold") 
            BankerFlyBetToArea() 
            end, nil, nil)
            time = time + 2
            break
        end
    end

    for k, v in pairs(GameData71.BankerAreaWin)do
         if(v < 0)then
            DeLayRun.AddDelay(time, function()
            AreaFlyBetToWiner() 
            self.playShortMusic("fly_gold")
            end, nil, nil)
            time = time + 2
            break
        end
    end
    Game71Panel.UpdatePlayerMoney(Game71Panel.UserInfo)

    --回收筹码
    time = time + 1
    DeLayRun.AddDelay(time, function()
       CollectBet()
       PopResultPlane()
    end, nil, nil) 
end

function Game71Panel.FlodCard(buffer)
    GameData71.DJS = 27
    self.Info.transform:Find("DJS/Tile"):GetComponent("Image").sprite = ResManager.GetSpriteByName("KaiJiangZhong").sprite
    self.Info.transform:Find("DJS/DJS_Text"):GetComponent("Text").text = tostring(math.ceil(GameData71.DJS))

    DeLayRun.ClearTargetDelay("DJS")
    local djs = math.ceil(GameData71.DJS)
    DeLayRun.AddDelay(GameData71.DJS, nil, function()
        djs = djs - 1
        self.Info.transform:Find("DJS/DJS_Text"):GetComponent("Text").text = tostring(math.ceil(djs))
    end, "DJS")
    if(self.WaitGameToOver)then
        logError("WaitGameToOver")
        return
    end
    UnActiveButton()
    GameData71.CurGameState = GameData71.GameState.GAME_STATE_SEND_POKER

    --读取牌数据
    local carddata = {{}, {}, {}, {}, {}} --天地玄黄庄
    for i= 1, 5 do
        carddata[5][i] = buffer:ReadByte()
    end
    for i= 1, 5 do
        carddata[1][i] = buffer:ReadByte()
    end
    for i= 1, 5 do
        carddata[2][i] = buffer:ReadByte()
    end
    for i= 1, 5 do
        carddata[3][i] = buffer:ReadByte()
    end
    for i= 1, 5 do
        carddata[4][i] = buffer:ReadByte()
    end

    GameData71.SetCardData(carddata)

    local cardtype = {}
    cardtype[5] = buffer:ReadByte()
    cardtype[1] = buffer:ReadByte()
    cardtype[2] = buffer:ReadByte()
    cardtype[3] = buffer:ReadByte()
    cardtype[4] = buffer:ReadByte()
    
    GameData71.SetCardType(cardtype)

    CardManager.FlodCard()
end

 function Game71Panel.GameResult(buffer)
    if(self.WaitGameToOver)then
        logError("WaitGameToOver")
        return
    end
    local winareaval = {}
    self.Mine.Win ={0, 0, 0, 0}
    local Banker
    for i = 1, 4 do
        winareaval[i] = buffer:ReadInt32()
        self.Mine.Win[i] = winareaval[i]
        logError("winareaval[i]: "..tostring(winareaval[i]))
    end
    logYellow("区域输赢")
    logTable(winareaval)
   
    local PlayerAreaWin = {}
    local winarea = {}
    for i = 1, 4 do
         winarea[i] = buffer:ReadByte()
         logError("winarea[i]: "..tostring(winarea[i]))
         if(winarea[i] > 0)then
             PlayerAreaWin[i] = 0
         else
             PlayerAreaWin[i] = 1
         end
    end
    logYellow("玩家输赢")
    logTable(winarea)

    local three = {}
    for i =1, 3 do
        local info = {}
        info.WinGold = tonumber(buffer:ReadInt64Str())
        logError("TopThree赢钱: "..tostring(info.WinGold))
        info.name = buffer:ReadString(32)
        logError("TopThree昵称: "..tostring(info.name))
        three[i] = info
    end
    GameData71.SetTopThree(three)

     --winarea[1] = 1
     --winarea[2] = 0
     --winarea[3] = 1
     --winarea[4] = 0
    GameData71.SetAreaWin(winarea)
    GameData71.SetBankerAreaWin()
    logYellow("=======GameData71.SetBankerAreaWin=====")

    GameData71.BankerWin = buffer:ReadInt32()
    --GameData71.BankerWin =0 --buffer:ReadInt32()

    logError("GameData71.BankerWin: "..tostring(GameData71.BankerWin))
    CardManager.ShowWinArea()
    logYellow("=======GameData71.BankerWin=====")

    DeLayRun.AddDelay(2.0, function()
        StartFlyBet()
    end, nil, nil)

    self.BankerBornBet = {}
    self.BankerBetOut = {}
    local bankerWin = GameData71.GetAllBankerWin()
    local needNewObjList = {}
    for k, v in pairs(GameData71.BankerAreaWin)do
        if(v < 0)then
            for k1, v1 in pairs(self.BetUIAreaList[k]) do
                if(v1.val == GameData71.BetList[6])then
                    needNewObjList[#needNewObjList + 1] = 6
                elseif(v1.val == GameData71.BetList[5])then
                    needNewObjList[#needNewObjList + 1] = 5
                elseif(v1.val == GameData71.BetList[4])then
                    needNewObjList[#needNewObjList + 1] = 4
                elseif(v1.val == GameData71.BetList[3])then
                    needNewObjList[#needNewObjList + 1] = 3
                elseif(v1.val == GameData71.BetList[2])then
                    needNewObjList[#needNewObjList + 1] = 2
                elseif(v1.val == GameData71.BetList[1])then
                    needNewObjList[#needNewObjList + 1] = 1
                else
                    logError("born banker bet error: "..tostring(v1.val))
                end
            end
        end
    end
    if(#needNewObjList > 0)then
        satrtBornBetProccess(needNewObjList,function(newBetList)
            for k, v in pairs(newBetList) do -- 
           
                if(v ~= nil)then
                    v.Obj.transform:SetParent(self.BetPoint_Huang.parent, false)
                    v.Obj.transform.localScale = Vector3.New(0.3, 0.3, 1)
                    v.Obj.transform.localPosition = self.BetPoint_Banker.localPosition 
                    v.Obj.transform.gameObject:SetActive(false)
                    self.BankerBornBet[#self.BankerBornBet + 1] = v
                else
                    log("生成的筹码UI有空值1")
                end
            end
        end)
    end

    for k, v in pairs(GameData71.BankerAreaWin)do
        v  = v *  GameData71.CardType[k]
        if(v < 0)then
            BornBetUIByMoney(-v, function(newBetList)
                for k, v in pairs(newBetList) do -- 
                    if(v ~= nil)then
                        v.Obj.transform:SetParent(self.BetPoint_Huang.parent, false)
                        v.Obj.transform.localScale = Vector3.New(0.3, 0.3, 1)
                        v.Obj.transform.localPosition = self.BetPoint_Banker.localPosition 
                        v.Obj.transform.gameObject:SetActive(false)
                        self.BankerBornBet[#self.BankerBornBet + 1] = v
                    else
                        log("生成的筹码UI有空值1")
                    end
                end
            end)
        end
    end

    GameData71.AddNewRecord(PlayerAreaWin)
    AddNewItemToLuDan(PlayerAreaWin)
 end

 
local function ShowStartBetTile()
    self.StartBetTile = newObject(ResManager.GetPrefabByName("StartBetTile"))
    self.StartBetTile.transform:SetParent(self.Info.transform:Find("TileGuaDian") ,false)
    self.StartBetTile.transform.localScale = Vector3.New(1, 1, 1)
    DeLayRun.AddDelay(1.5, function()
        if(self.StartBetTile ~= nil)then
            destroy(self.StartBetTile.gameObject)
            self.StartBetTile = nil
        end
    end, nil, nil)

    if(GameData71.NextChangeBanker ~= nil and GameData71.NextChangeBanker.ChairId ~= GameData71.CurBanker.ChairId)then
        logError("GameData71.NextChangeBanker: "..tostring(GameData71.NextChangeBanker.ChairId).."   GameData71.CurBanker: "..tostring(GameData71.CurBanker.ChairId))
        logError("self.Mine.ChairId: "..tostring(self.Mine.ChairId))
        GameData71.CurLastBankerTurns = 0
        --显示轮换庄家
        logError("111")
        if(GameData71.NextChangeBanker.ChairId == self.Mine.ChairId)then
            MessageBox.CreatGeneralTipsPanel("您已经上庄")
            self.Mine.BankerState = 2
             self.BtnPlane.transform:Find("CustomBtn/ExitBtn"):GetComponent("Button").interactable = false
        end
        for i = 1, #GameData71.UpBankerList do
            if(GameData71.UpBankerList[i].ChairId == GameData71.NextChangeBanker.ChairId)then
                table.remove(GameData71.UpBankerList,i)
                break;
            end
        end
        UpdateUpBankerCountUI()
        self.Info.transform:Find("TileGuaDian/SwitchBankerTile").gameObject:SetActive(true)
        self.Info.transform:Find("TileGuaDian/SwitchBankerTile"):GetComponent("Image").sprite = ResManager.GetSpriteByName("BankerSwitch").sprite
        GameData71.SetBankerData(GameData71.NextChangeBanker)
        SetBankerUI()
        DeLayRun.AddDelay(1.5, function()
            self.Info.transform:Find("TileGuaDian/SwitchBankerTile").gameObject:SetActive(false)
        end, nil, nil)
    else
        if(GameData71.CurBanker.ChairId < 65535 and GameData71.CurLastBankerTurns >= 0)then
            --显示连庄
            GameData71.CurLastBankerTurns = GameData71.CurLastBankerTurns + 1
            if(GameData71.CurLastBankerTurns > 9)then
                return;
            end
            self.Info.transform:Find("TileGuaDian/SwitchBankerTile").gameObject:SetActive(true)
            self.Info.transform:Find("TileGuaDian/SwitchBankerTile"):GetComponent("Image").sprite = ResManager.GetSpriteByName("KeepBanker"..tostring(GameData71.CurLastBankerTurns)).sprite
            DeLayRun.AddDelay(1.5, function()
                self.Info.transform:Find("TileGuaDian/SwitchBankerTile").gameObject:SetActive(false)
            end, nil, nil)
        end
    end
end

function Game71Panel.StartBet(buffer)
    self.playShortMusic("sound-ready") 
    GameData71.DJS = 20
    self.Info.transform:Find("DJS/Tile"):GetComponent("Image").sprite = ResManager.GetSpriteByName("XiaZhuZhong").sprite
    self.Info.transform:Find("DJS/DJS_Text"):GetComponent("Text").text = tostring(math.ceil(GameData71.DJS))

    DeLayRun.ClearTargetDelay("DJS")
    local djs = math.ceil(GameData71.DJS)
    DeLayRun.AddDelay(GameData71.DJS, nil, function()
        djs = djs - 1
        self.Info.transform:Find("DJS/DJS_Text"):GetComponent("Text").text = tostring(math.ceil(djs))
        if(djs == 3)then
             self.playShortMusic("audio_reminded") 
             self.BetDJS = newObject(ResManager.GetPrefabByName("BetDJS"))
             self.BetDJS.transform:SetParent(self.Info.transform:Find("TileGuaDian") ,false)
             self.BetDJS.transform.localScale = Vector3.New(1, 1, 1)
        end
    end, "DJS")

    if(self.WaitGameToOver)then
        for k, v in pairs(self.BetUIAreaList)do
            for k1, v1 in pairs(v)do
                if(v1.val == GameData71.BetList[1])then
                    table.insert(self.BetUIList[1], v1)
                elseif(v1.val == GameData71.BetList[2])then          
                    table.insert(self.BetUIList[2], v1)
                elseif(v1.val == GameData71.BetList[3])then
                    table.insert(self.BetUIList[3], v1)
                elseif(v1.val == GameData71.BetList[4])then
                    table.insert(self.BetUIList[4], v1)
                elseif(v1.val == GameData71.BetList[5])then
                    table.insert(self.BetUIList[5], v1)
                elseif(v1.val == GameData71.BetList[6])then
                    table.insert(self.BetUIList[6], v1)
                end
                v1.Obj.transform.gameObject:SetActive(false)
            end
        end
    end

    ResManager.ClearTempEffect()

    self.WaitForNextTurn.gameObject:SetActive(false)
    ShowStartBetTile()

    self.WaitGameToOver = false
    GameData71.ResetData()
    self.Mine:ResetData()
    UpdateBetInfo()
    ActiveButton(false)

    GameData71.CurGameState = GameData71.GameState.GAME_STATE_CHIP
    CardManager.HideAllCard()
    self.ResultPlane.gameObject:SetActive(false)
end

function Game71Panel.UpdateBankerInfo(buffer)
    --[[
	DWORD	sChairID;			//庄椅子ID  0xffff代表系统当庄
	TCHAR	szName[32];			//庄昵称
	INT64	nGold;				//庄身上货币
	BYTE	cbBankerCount;		//第几轮庄
    ]]

    local Banker = {}
    Banker.ChairId = buffer:ReadInt32()
    Banker.name = buffer:ReadString(32)
    Banker.money = int64.tonum2(buffer:ReadInt64())
    if(Banker.money == nil)then
        Banker.money = 0
    end
    Banker.TurnCount = buffer:ReadByte()
    --GameData71.SetBankerData(Banker)
    GameData71.NextChangeBanker = Banker
    if(self.Mine.ChairId == Banker.ChairId)then
        self.Mine.BankerState = 1
    else
        if(GameData71.CurBanker.ChairId == self.Mine.ChairId)then
            self.Mine.BankerState = 0
            self.BtnPlane.transform:Find("CustomBtn/ExitBtn"):GetComponent("Button").interactable = true
            self.BtnPlane.transform:Find("CustomBtn/UpBankBtn"):GetComponent("Image").sprite = ResManager.GetSpriteByName("UpBanker").sprite
        end
    end
end

local function ShowUpBankerList()
    self.Info.transform:Find("BankPlane").gameObject:SetActive(true)
    local ItemModel = self.Info.transform:Find("BankPlane/BankerItemModel").gameObject
    local BankerListLen = #GameData71.UpBankerList
    local ContentPar = self.Info.transform:Find("BankPlane/Scroll View/Viewport/Content")
    for i = 0, BankerListLen - 1 do
        local ob = nil
        if(ContentPar.transform.childCount > i)then
            ob = ContentPar:GetChild(i).gameObject
        else
            ob = newobject(ItemModel)
            ob.transform.localScale = Vector3.New(1, 1, 1)
            ob.transform:SetParent(ContentPar, false)
        end
        ob.gameObject:SetActive(true)
        ob.transform:Find("Text"):GetComponent("Text").text = GameData71.UpBankerList[i + 1].name
        if(BankerListLen < 4)then
            ContentPar:GetComponent("RectTransform").offsetMin = Vector2.New(0, -89);
        else
            ContentPar:GetComponent("RectTransform").offsetMin = Vector2.New(0, -25 * BankerListLen);
        end
        ob.gameObject.transform.localPosition = Vector3.New(83, 30 - 44.5 - 25 * i, 0)
    end
    for i = BankerListLen, ContentPar.childCount - 1 do
        ContentPar:GetChild(i).gameObject:SetActive(false)
    end
   

    DeLayRun.ClearTargetDelay("ShowBankerList")
    DeLayRun.AddDelay(2.0, function()
        self.Info.transform:Find("BankPlane").gameObject:SetActive(false)
    end, nil, "ShowBankerList")
end

function Game71Panel.UpBankeResult(buffer)
    local result = buffer:ReadByte()
    if(result == 0)then
       MessageBox.CreatGeneralTipsPanel("申请上庄成功")
        self.Mine.BankerState = 1
       local bl = false
       for i = 1, #GameData71.UpBankerList do
            if(GameData71.UpBankerList[i].Charid == self.Mine.ChairId)then
                bl = true
                break
            end
       end
       if(bl == false)then
            local newbanker = {}
            newbanker.ChairId = self.Mine.ChairId
            newbanker.money = self.Mine.Money
            newbanker.name = self.Mine.name
            GameData71.UpBankerList[#GameData71.UpBankerList + 1] = newbanker
       end
       ShowUpBankerList()
       self.BtnPlane.transform:Find("CustomBtn/UpBankBtn"):GetComponent("Image").sprite = ResManager.GetSpriteByName("DownBanker").sprite
    elseif(result == 1)then
        MessageBox.CreatGeneralTipsPanel("金币不足以上庄")
        self.Mine.BankerState = 0
        self.BtnPlane.transform:Find("CustomBtn/ExitBtn"):GetComponent("Button").interactable = true
        self.BtnPlane.transform:Find("CustomBtn/UpBankBtn"):GetComponent("Image").sprite = ResManager.GetSpriteByName("UpBanker").sprite
    elseif(result == 2)then
        MessageBox.CreatGeneralTipsPanel("已在上庄列表中")
    end
end

function Game71Panel.DownBankerResult(buffer)
    local result = buffer:ReadByte()
    if(result == 3 or result == 0)then
        if(result == 3)then
           MessageBox.CreatGeneralTipsPanel("申请下庄成功，本局游戏结束后下庄")
       else
           MessageBox.CreatGeneralTipsPanel("退出上庄列表成功")
           self.Mine.BankerState = 0
           --self.BtnPlane.transform:Find("CustomBtn/ExitBtn"):GetComponent("Button").interactable = true
       end
        self.Mine.IsInBanker = false
        self.BtnPlane.transform:Find("CustomBtn/UpBankBtn"):GetComponent("Image").sprite = ResManager.GetSpriteByName("UpBanker").sprite
        for i = 1, #GameData71.UpBankerList do
            if(GameData71.UpBankerList[i].ChairId == self.Mine.ChairId)then
                table.remove(GameData71.UpBankerList,i)
                break;
            end
        end
        ShowUpBankerList()
        UpdateUpBankerCountUI()
    elseif(result == 1)then
        MessageBox.CreatGeneralTipsPanel("至少坐满2局才能下庄")
    elseif(result == 2)then
        MessageBox.CreatGeneralTipsPanel("游戏过程中不能下庄")
    end
end

function Game71Panel.UpdateBakerList(buffer)
    GameData71.WaitUpBankerCount = buffer:ReadByte()
    --更新上庄列表
    local UpBankerList = {}
    logError("222: "..tostring(GameData71.WaitUpBankerCount))
    if(GameData71.WaitUpBankerCount > 10)then
        GameData71.WaitUpBankerCount = 10
    end
    for i = 1, 10 do
        if(GameData71.WaitUpBankerCount >= i)then
            UpBankerList[i] = {}
            UpBankerList[i].ChairId = buffer:ReadUInt16()
            UpBankerList[i].money = buffer:ReadInt32()
            UpBankerList[i].name = buffer:ReadString(32)
            if(UpBankerList[i].ChairId == self.Mine.ChairId)then
                self.Mine.BankerState = 1
            end
        else
            buffer:ReadUInt16()
            buffer:ReadInt32()
            buffer:ReadString(32)
        end
    end
    GameData71.SetUpBankerList(UpBankerList)
    UpdateUpBankerCountUI()
end

function Game71Panel.FristEnterScense(buffer)
    --初始化筹码--
    logError("FristEnterScense")
    GameData71.Init()
    
    --BankBox.Init(self.transform:Find("bg/bg1/Info/BankBox"), self.transform:GetComponent("LuaBehaviour"), NumFormat)
    logError("初始化筹码; BRNN")
    local betList = {}
    for i = 1, 6 do
        local v = buffer:ReadInt32()
        betList[i] = v
    end
    logTable(betList)
    logError("初始化筹码1")
    GameData71.InitBeList(betList)
    logError("初始化筹码2")
     --初始化庄家--
    local Banker = {}
    Banker.ChairId = buffer:ReadInt32()
    Banker.name = buffer:ReadString(32)
    logError("庄家昵称: "..Banker.name)
    Banker.money = tonumber(buffer:ReadInt64Str())
    if(Banker.money == nil)then
        Banker.money = 0
    end
    Banker.TurnCount = buffer:ReadByte()
    logError("初始化庄家信息")
    GameData71.SetBankerData(Banker)
    logTable(Banker)
    if(Banker.ChairId == self.Mine.ChairId)then
        self.Mine.BankerState = 2
        self.BtnPlane.transform:Find("CustomBtn/ExitBtn"):GetComponent("Button").interactable = false
    end
    logError("初始化庄家5")

     --初始化游戏状态--
    GameData71.SetGameState(buffer:ReadByte())
    if(GameData71.CurGameState == GameData71.GameState.GAME_STATE_CHIP)then
        self.WaitGameToOver = false
        logError("WaitGameToOver = false")
    else
        self.WaitGameToOver = true
        logError("WaitGameToOver = true")
    end
     logError("初始化游戏状态6: ")
     
    --初始化限红---
    GameData71.SetnLimitChip(buffer:ReadInt32())
     logError("初始化限红7")
    
    --初始化所有下注---
    local AllBet = {}
    AllBet[1] = buffer:ReadInt32()
    AllBet[2] = buffer:ReadInt32()
    AllBet[3] = buffer:ReadInt32()
    AllBet[4] = buffer:ReadInt32()
    GameData71.InitAllBetData(AllBet)
    logError("初始化所有下注8")
     logTable(AllBet)
    --初始化自己下注---
    self.Mine.AllBetInfo[1] = buffer:ReadInt32()
    self.Mine.AllBetInfo[2] = buffer:ReadInt32()
    self.Mine.AllBetInfo[3] = buffer:ReadInt32()
    self.Mine.AllBetInfo[4] = buffer:ReadInt32()
    logTable(self.Mine.AllBetInfo)
    logError("初始化自己下注9")
    --初始化倒计时---
    local DJS = buffer:ReadInt32()
    GameData71.DJS = DJS
     logError("初始化倒计时10"..tostring(DJS))
    --初始化路单---
    local ludan = {}
    for i = 1, 10 do
        ludan[i] = {}
        for j = 1, 4 do
            ludan[i][j] = buffer:ReadByte()
            --logError("ludan: "..tostring(ludan[i][j]))
        end
    end
    GameData71.SetLuDan(ludan)
     logError("初始化路单11")
    --初始化游戏总输赢局数---
    local AllTurnsInfo = {}
    AllTurnsInfo.Allturns = buffer:ReadInt32()
    AllTurnsInfo.loseturns_Tian  = buffer:ReadInt32()
    AllTurnsInfo.winturns_Tian = buffer:ReadInt32()

    AllTurnsInfo.loseturns_Di  = buffer:ReadInt32()
    AllTurnsInfo.winturns_Di = buffer:ReadInt32()

    AllTurnsInfo.loseturns_Xuan  = buffer:ReadInt32()
    AllTurnsInfo.winturns_Xuan = buffer:ReadInt32()

    AllTurnsInfo.loseturns_Huang  = buffer:ReadInt32()
    AllTurnsInfo.winturns_Huang = buffer:ReadInt32()
    GameData71.SetAllTurnsIInfo(AllTurnsInfo)
    logError("初始化游戏总输赢局数12")
    logTable(AllTurnsInfo)
    --初始化上庄列表---
    local UpBankerList = {}
    logError("111")
    local Count = buffer:ReadByte()
    logError("222")
    if(Count > 10)then
        Count = 10
    end
    for i = 1, Count do
        UpBankerList[i] = {}
        UpBankerList[i].Charid = buffer:ReadUInt16()
        UpBankerList[i].money = buffer:ReadInt32()
        UpBankerList[i].name = buffer:ReadString(32)
        if(UpBankerList[i].ChairId == self.Mine.ChairId)then
            self.Mine.BankerState = 1
        end
    end
    logError("888")
    --GameData71.SetUpBankerList(UpBankerList)
    logError("初始化上庄列表13")
    InitData()
end

function Game71Panel.QuitGame()
    ResManager.Dispose()
    self.AlphaFadeList = {}
    self.BetUIList = {{}, {}, {}, {}, {}, {}}
    self.BetUIAreaList = {{}, {}, {}, {}}
    PlayerList.Dispose()
    CardManager.Dispose()
    DeLayRun.ClearAllDelay()
    BRNN_RPCHandle.OnDestroy();
    MessgeEventRegister.Game_Messge_Un(); 
    GameSetsBtnInfo.LuaGameQuit();
end

function Game71Panel.init()
    
end

function Game71Panel.addEvent()
  
end

local function BeginToMoveGril(curindex, startindex)
    if(startindex < 7)then
        self.Gril.transform.localPosition = self.GrilMovePointArr[curindex].localPosition
        self.Gril.transform:DOLocalMove(self.GrilMovePointArr[startindex].localPosition, GameData71.MoveTime[curindex]):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            BeginToMoveGril(startindex, startindex + 1)
        end)
    else
        GameData71.GrilsMoveJianGe = math.random(5, 15)
    end
end

function Game71Panel.Update()
    if(DeLayRun.Update ~= nil)then
        DeLayRun.Update()
    end

    for k, v in pairs(self.AlphaFadeList)do
        if(v ~= nil)then
            v:Update()
        end
    end

    if(GameData71.GrilsMoveJianGe ~= nil and GameData71.GrilsMoveJianGe > 0)then
        --logError("ameData71.GrilsMoveJianGe: "..tostring(GameData71.GrilsMoveJianGe))
        GameData71.GrilsMoveJianGe = GameData71.GrilsMoveJianGe - UnityEngine.Time.deltaTime
        if(GameData71.GrilsMoveJianGe <= 0)then
            BeginToMoveGril(1, 2)
        end
    end
end


function Game71Panel.OpenHelp()
    onpressRule()
end