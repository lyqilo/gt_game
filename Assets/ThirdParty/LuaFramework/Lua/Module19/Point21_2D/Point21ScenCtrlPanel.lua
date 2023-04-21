--Point21ScenCtrlPanel.lua
--Date
--2D 21点场景控制 对应LuaBehaviour
--endregion
--默认的定义
require "Module19/Point21_2D/Point21GameNet"

require "Module19/Point21_2D/Point21Hellp"

require "Module19/Point21_2D/Point21ZJCtrl"
require "Module19/Point21_2D/Point21PlayerCtrl"

--require "Module19/Point21_2D/Point21PlayerCtrl" --玩家控制
Point21ScenCtrlPanel = {}

local self = Point21ScenCtrlPanel

local luaBehaviour

local chipListTra  --下注列表物体

local traSPChip  --特殊下注

local operationListTra  --操作列表

local infoPanelTra  --信息面板

local bShowChiplist = false --下注界面是否显示了

local bOnClickChipBtn = false --是否点击了下注按钮

self.bBeginThrwoChip = false -- 是否是下注状态

self.StartGameMessage = false--接收到开始游戏消息

self.titleImage = nil --提示面板

self.bInoperation = false --是否进行过了普通操作，若进行了 则不能分牌和双倍

self.insuranceTitleTra = nil --保险提示框

self.surplusTimer = 0 --下注剩余时间

local isInitChip = false;

myChairID = 0 --自己控制角色的椅子号

zjPos = 5 --庄家座位号

point21PlayerTab = {} --存储每个玩家实例

g_bGameQuit = false

fSpChipSpeed = 0.8

bottomChipsListIntTab = {
    [1] = 10000000,
    [2] = 5000000,
    [3] = 1000000,
    [4] = 100000,
    [5] = 50000
} --下注列表

function Point21ScenCtrlPanel:Awake(obj)
    Screen.orientation = UnityEngine.ScreenOrientation.Landscape;
    Screen.autorotateToLandscapeLeft = true;
    Screen.autorotateToLandscapeRight = true;
    Screen.autorotateToPortrait = false;
    Screen.autorotateToPortraitUpsideDown = false;
    Point21ScenCtrlPanel.tabObjPool = {}
    Point21ScenCtrlPanel.onClickHomeBack()
    bPoint21GameQuit = false
    Point21ScenCtrlPanel.transform = obj.transform
    Point21ScenCtrlPanel.InitGameData()
    MessgeEventRegister.Game_Messge_Un() --清除消息事件
    Point21GameNet.addGameMessge() --加入消息事件
    Point21ScenCtrlPanel.OnCreateSceneObjCallBack()

    logBlue("21开始进入场景")
    isInitChip = false;
end

function Point21ScenCtrlPanel:FixedUpdate()
    Point21GameNet.FixedUpdate()
end

function Point21ScenCtrlPanel.InitGameData()
    bShowChiplist = false --下注界面是否显示了
    bOnClickChipBtn = false --是否点击了下注按钮
    self.bBeginThrwoChip = false -- 是否是下注状态
    self.titleImage = nil --提示面板
    self.bInoperation = false --是否进行过了普通操作，若进行了 则不能分牌和双倍
    self.insuranceTitleTra = nil --保险提示框
    self.surplusTimer = 0 --下注剩余时间
end

function Point21ScenCtrlPanel.OnCreateTempBackgroundCallBack(prefab)
    local go = newobject(prefab)
    go.name = "CanvasTempBackground"
    go.transform:SetParent(self.transform)
    go.transform.localScale = Vector3.one
    go.transform.localPosition = Vector3.New(0, 0, 0)
    self.tempBackTra = go

    --coroutine.start(self.waitLoadGameScene);
end

function Point21ScenCtrlPanel.waitLoadGameScene()
    coroutine.wait(0.1)

    --LoadAssetAsync(Point21ResourcesNume.abObjResNameStr, 'Point21GmaeObject2D', self.OnCreateSceneObjCallBack, true, true);
    self.OnCreateSceneObjCallBack()
end

--加载场景物体回调
function Point21ScenCtrlPanel.OnCreateSceneObjCallBack()
    local go = Point21ScenCtrlPanel.PoolForNewobject("Point21GmaeObject2D")
    --local go = newobject(prefab);
    --go.transform:SetParent(GameObject.Find("Point21ScenCtrlPanel").transform);
    go.transform:SetParent(self.transform)
    go.name = "Point21GmaeObject2D"
    go.transform.localScale = Vector3.one
    go.transform.localPosition = Vector3.New(0, 0, 0)
    local cas = go.transform:Find("Canvas")
    cas.transform.localScale = Vector3.one
    SetCanvasScalersMatch(cas.transform:GetComponent("CanvasScaler"), 1) --屏幕适配



    local bJSource = go.transform:GetComponent("AudioSource") --背景音乐
    MusicManager:PlayBacksoundX(bJSource.clip, true)

    self.LoadGameObject(go) --加载完场景物体后 加载需要的资源

    if (self.tempBackTra and not IsNil(self.tempBackTra)) then
        destroy(self.tempBackTra.gameObject)
        self.tempBackTra = nil
    end

    Point21GameNet.playerLogon() --用户登陆
    GameManager.PanelInitSucceed(self.transform.gameObject)
    Point21ScenCtrlPanel.SetTempBJ(false)
end

--加载游戏物体
function Point21ScenCtrlPanel.LoadGameObject(gameObj)
    GameManager.GameScenIntEnd() --加载集合按钮

    luaBehaviour = self.transform:GetComponent("LuaBehaviour")

    --local uiCamera = find("Point21GmaeObject2D").transform:Find("Canvas/UGUICamera");
    local uiCamera = gameObj.transform:Find("Canvas/UGUICamera")
    local playersTra = uiCamera.transform:Find("Point21UIPanel/Point21Players") -- 玩家物体的父物体
    uiCamera.transform:Find("ImageBackground/PlayerPos4").gameObject:SetActive(false);
    uiCamera.transform:Find("ImageBackground/PlayerPos4").transform.localPosition = Vector3.New(10000, 0, 0);

    --bg
    uiCamera:Find("BJ").localScale = Vector3.New(1.25, 1, 1);

    -- local bg = GameObject.New("BgImage"):AddComponent(typeof(UnityEngine.UI.Image));
    -- bg.transform:SetParent(uiCamera);
    -- bg.transform:SetSiblingIndex(1);
    -- bg.transform.localPosition = Vector3(0, 0, 50);
    -- bg.transform.localScale = Vector3(1, 1, 1);
    -- bg.sprite = HallScenPanel.moduleBg:Find("module19"):GetComponent("Image").sprite;
    -- bg:GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.height / Screen.width) * 750 + 20, 750 + 20);
    --playersTra
    for i = 1, 5 do
        -- 动态创建玩家物体并绑定对应的lua脚本
        local point21PlayerCtrl = Point21PlayerCtrl:New()

        point21PlayerCtrl.Create(i, point21PlayerCtrl, playersTra)

        table.insert(point21PlayerTab, point21PlayerCtrl)
    end

    chipListTra = uiCamera.transform:Find("ImageOperationPanel/ChipsList") --下注列表物体

    for i = 0, (chipListTra.transform.childCount - 2) do
        --最后一个为提示图片
        if (0 == i) then
            self.traCurChip = chipListTra.transform:GetChild(i)
            self.traChipTag = chipListTra.transform:GetChild(i):Find("ImageTag")
        end
        luaBehaviour:AddClick(chipListTra.transform:GetChild(i).gameObject, self.onClickChipsBtn) --添加下注按钮响应事件
    end

    traSPChip = uiCamera.transform:Find("ImageOperationPanel/SpOperation") --下注列表物体
    local traBtns = traSPChip.transform:Find("Buttons")
    for i = 0, traBtns.transform.childCount - 1 do
        luaBehaviour:AddClick(traBtns.transform:GetChild(i):Find("Button").gameObject, self.onClickSpChipsBtn) --添加下注按钮响应事件
    end

    self.insuranceTitleTra = uiCamera.transform:Find("ImageInsuranceTitle") --保险提示框

    local insuranceBtn = self.insuranceTitleTra:Find("Buttons") --保险操作按钮

    for i = 0, (insuranceBtn.childCount - 1) do
        luaBehaviour:AddClick(insuranceBtn.transform:GetChild(i).gameObject, self.onClickInsuranceBtn) --添加保险按钮响应事件
    end

    operationListTra = uiCamera.transform:Find("ImageOperationPanel/OperationList") --操作列表物体

    for i = 0, (operationListTra.transform.childCount - 2) do
        --最后一个为提示图片
        luaBehaviour:AddClick(operationListTra.transform:GetChild(i).gameObject, self.onClickOperationBtn) --添加操作按钮响应事件
    end

    infoPanelTra = uiCamera.transform:Find("ShowPlayerInfoPanel") --玩家信息面板
    infoPanelTra.gameObject:SetActive(false)
    local colseInfoPanelBtn = infoPanelTra.transform:Find("ImageTitle/ButtonClose") --关闭信息面板按钮
    local bottomColseInfoPanelBtn = infoPanelTra.transform:Find("ButtonBottomClose") --关闭信息面板底板按钮
    luaBehaviour:AddClick(colseInfoPanelBtn.gameObject, self.onClickClosPanelBtn)
    luaBehaviour:AddClick(bottomColseInfoPanelBtn.gameObject, self.onClickClosPanelBtn)

    self.titleImage = uiCamera.transform:Find("TitleImage") --提示面板
    local titleButtons = self.titleImage.transform:Find("Buttons")
    self.titleImage.gameObject:SetActive(false)
    for i = 0, (titleButtons.transform.childCount - 1) do
        luaBehaviour:AddClick(titleButtons.transform:GetChild(i).gameObject, self.onClickTiltleBtns) --添加提示面板响应事件
    end

    --local res = LoadAsset(Point21ResourcesNume.dbResNameStr, 'GameRes');
    local res = Point21ScenCtrlPanel.Pool("GameRes")

    self.loadAssetGameResCallBack(res)
    --加载扑克点数数字图片资源
    --LoadAsset(Point21ResourcesNume.dbResNameStr, 'NumberPointImage', self.loadAssetPointNumObjResCallBack);
    --加载数字图片资源
    --LoadAsset(Point21ResourcesNume.dbResNameStr, 'NumberImage', self.loadAssetNumObjResCallBack);
    --加载筹码数字图片资源
    --LoadAsset(Point21ResourcesNume.dbResNameStr, 'NumberChipImage', self.loadAssetChipsNumObjResCallBack);
    --加载游戏图片资源图片
    --LoadAsset(Point21ResourcesNume.dbResNameStr, 'GameImageRes', self.loadAssetGameObjectResResCallBack);
    --加载游戏表情资源资源
    --LoadAsset(Point21ResourcesNume.dbResNameStr, 'ExpressionObject', self.loadAssetExpressionResCallBack);
    --加载游戏音效资源
    --self.musicRes = LoadAsset(Point21ResourcesNume.dbMusicResNameStr, 'Point21_2d_musicRes');
    self.musicRes = Point21ScenCtrlPanel.Pool("Point21_2d_musicRes")
    --加载测试资源
    --ResManager:LoadAsset("p21_2d_test", 'PanelTest', self.loadAssetTestCallBack);
    --coroutine.start( self.playersLogon);
    --self.playersLogon();
end

--加载扑游戏资源回调
function Point21ScenCtrlPanel.loadAssetGameResCallBack(prefab)
    local res = prefab
    --加载扑克点数数字图片资源
    self.pointNumObjRes = res.transform:Find("NumberPointImage")
    --加载数字图片资源
    self.numObjRes = res.transform:Find("NumberImage")
    --加载筹码数字图片资源
    self.chipsNumObjRes = res.transform:Find("NumberChipImage")
    --加载游戏图片资源
    self.infoBoxRes = res.transform:Find("GameImageRes/PlayerInfoBoxImage") --玩家信息框资源
    self.plyerPosRes = res.transform:Find("GameImageRes/PlyerPosImage") --自己位置图片资源
    self.nomerPointboxRes = res.transform:Find("GameImageRes/PointBox/NomerPokerPointBoxImage") --普通点数底框
    self.bustPointBoxRes = res.transform:Find("GameImageRes/PointBox/BustPokerPointBoxImage") --爆牌后点数底框
    self.resultRes = res.transform:Find("GameImageRes/ResultImage") --结算资源
end

--加载扑克点数数字图片资源回调
function Point21ScenCtrlPanel.loadAssetPointNumObjResCallBack(prefab)
    self.pointNumObjRes = prefab
end

--加载数字图片资源回调
function Point21ScenCtrlPanel.loadAssetNumObjResCallBack(prefab)
    self.numObjRes = prefab
end

--加载筹码数字图片资源回调
function Point21ScenCtrlPanel.loadAssetChipsNumObjResCallBack(prefab)
    self.chipsNumObjRes = prefab
end

--加载游戏图片资源回调
function Point21ScenCtrlPanel.loadAssetGameObjectResResCallBack(prefab)
    self.infoBoxRes = prefab.transform:Find("PlayerInfoBoxImage") --玩家信息框资源
    self.plyerPosRes = prefab.transform:Find("PlyerPosImage") --自己位置图片资源
    self.nomerPointboxRes = prefab.transform:Find("PointBox/NomerPokerPointBoxImage") --普通点数底框
    self.bustPointBoxRes = prefab.transform:Find("PointBox/BustPokerPointBoxImage") --爆牌后点数底框
    self.resultRes = prefab.transform:Find("ResultImage") --结算资源
end

--加载音效资源回调
function Point21ScenCtrlPanel.loadAssetMusicResResCallBack(prefab)
    self.musicRes = prefab
end

--加载表情资源回调
function Point21ScenCtrlPanel.loadAssetExpressionResCallBack(prefab)
    self.expressionRes = prefab
end

--设置玩家下注按钮
function Point21ScenCtrlPanel.SetPlayChipBtn(traBtn)
    log("========设置玩家下注按钮=========")
    self.traPlayerChip = traBtn.transform
    luaBehaviour:AddClick(traBtn.gameObject, self.onClickPlayerChip) --添加下注按钮响应事件
    self.traPlayerChip.gameObject:SetActive(false)
end

--记录用户金币
function Point21ScenCtrlPanel.RecordUserGold(iGold)
    self.iUserGold = iGold
end

--临时计算用户金币
function Point21ScenCtrlPanel.TempChangeUserGold(iChangeGold)
    if (not self.iUserGold) then
        return
    end
    self.iUserGold = self.iUserGold + iChangeGold
    point21PlayerTab[myChairID + 1]:ChangePlayerGold(self.iUserGold)
end

function Point21ScenCtrlPanel.SendOnChip(iType)
    if (not self.bottomStr) then
        logYellow("下注1")
        return
    end

    if (bOnClickChipBtn) then
        logYellow("下注2")
        return
    end

    local myAllGoldInt = self.iUserGold or point21PlayerTab[myChairID + 1].playerInfoTab._7wGold
    local iChipVal = tonumber(self.bottomStr) or 0
    if (toInt64(myAllGoldInt) < toInt64(iChipVal)) then
        Point21ScenCtrlPanel.ShowMessageBox("金币不足", 1)
        return
    end

    --Point21ScenCtrlPanel.TempChangeUserGold(-iChipVal)
    bOnClickChipBtn = true

    local data = { [1] = iType, [2] = tonumber(self.bottomStr) }
    buffer = SetC2SInfo(Point21DataStruct.CMD_CS_PLAYER_CHIP, data)
    logYellow("发送下注消息")
    Network.Send(
            MH.MDM_GF_GAME,
            Point21DataStruct.CMD_BlackJack.SUB_CS_PLAYER_CHIP,
            buffer,
            gameSocketNumber.GameSocket
    )

    coroutine.start(self.throwChipCrtl)

    Point21ScenCtrlPanel.ShowSpChipbtn(true)
end

function Point21ScenCtrlPanel.onClickPlayerChip(btn)
    logYellow("玩家下注")
    Point21ScenCtrlPanel.SendOnChip(Point21DataStruct.E_CHIPTYPE_NORMAL)
end

function Point21ScenCtrlPanel.onClickSpChipsBtn(btn)
    local iType = btn.transform.parent:GetSiblingIndex() + Point21DataStruct.E_CHIPTYPE_NORMAL_D
    logYellow("btn name = " .. btn.transform.parent.name .. " itype = " .. iType)
    logYellow("下注0")
    Point21ScenCtrlPanel.SendOnChip(iType)
    logYellow("下注4")
end

--筹码按钮响应事件
function Point21ScenCtrlPanel.onClickChipsBtn(prefab)
    local buffer

    if ("ButtonOK" == prefab.name) then
        --确认按钮 停止下注
        HallScenPanel.PlayeBtnMusic()
        buffer = ByteBuffer.New()
        if (point21PlayerTab[myChairID + 1].allChipNumInt > 0) then
            --若自己没下注 则不隐藏下注界面
            Network.Send(
                    MH.MDM_GF_GAME,
                    Point21DataStruct.CMD_BlackJack.SUB_CS_STOP_CHIP,
                    buffer,
                    gameSocketNumber.GameSocket
            )

            Point21ScenCtrlPanel.showChipList(false)
        end
    else
        --下注值
        Point21ScenCtrlPanel.ChangeChipsBtnPos(prefab.transform)
        self.bottomStr = prefab.transform:GetChild(1).name
        if isInitChip == true then
            isInitChip = false
            return
        end
        Point21ScenCtrlPanel.onClickPlayerChip()
    end
end

function Point21ScenCtrlPanel.ChangeChipsBtnPos(traBtn)
    if (traBtn.name == self.traCurChip.name) then
        return
    end
    traBtn.transform.localPosition = Vector3(traBtn.transform.localPosition.x, 20, traBtn.transform.localPosition.z)
    local spriteTemp = traBtn.transform:GetComponent("Image").sprite
    local traImage = traBtn.transform:Find("Image")
    traBtn.transform:GetComponent("Image").sprite = traImage:GetComponent("Image").sprite
    traImage:GetComponent("Image").sprite = spriteTemp
    self.traCurChip.transform.localPosition = Vector3(self.traCurChip.transform.localPosition.x, 0, self.traCurChip.transform.localPosition.z)
    traImage = self.traCurChip.transform:Find("Image")
    spriteTemp = self.traCurChip.transform:GetComponent("Image").sprite
    self.traCurChip.transform:GetComponent("Image").sprite = traImage:GetComponent("Image").sprite
    traImage:GetComponent("Image").sprite = spriteTemp
    self.traCurChip = traBtn.transform
end

--保险按钮响应事件
function Point21ScenCtrlPanel.onClickInsuranceBtn(prefab)
    --MusicManager:Play("Music/Hall/anniu3");
    HallScenPanel.PlayeBtnMusic()

    local isInsurance

    if ("ButtonOk" == prefab.name) then
        --购买保险
        isInsurance = 1
    else
        isInsurance = 0
    end

    local data = {
        [1] = isInsurance,
        [2] = 0,
        [3] = 0,
        [4] = 0
    }

    local buffer = SetC2SInfo(Point21DataStruct.CMD_CS_PLAYER_INSURANCE, data)

    Network.Send(
            MH.MDM_GF_GAME,
            Point21DataStruct.CMD_BlackJack.SUB_CS_PLAYER_INSURANCE,
            buffer,
            gameSocketNumber.GameSocket
    )

    self.showinsurancePanerl(false)
    --self.insuranceTitleTra.gameObject:SetActive(false);
end

--玩家操作按钮响应事件
function Point21ScenCtrlPanel.onClickOperationBtn(prefab)
    --MusicManager:Play("Music/Hall/anniu3");
    HallScenPanel.PlayeBtnMusic()
    logYellow("隐藏操作按钮1")
    Point21ScenCtrlPanel.showOperation(false)
    local playerNormalOperate
    if ("ButtonSplit" == prefab.name) then
        --分牌
        playerNormalOperate = Point21DataStruct.CMD_BlackJack.enPlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_SPLIT_POKER
    elseif ("ButtonSurrender" == prefab.name) then
        --投降
        playerNormalOperate = Point21DataStruct.CMD_BlackJack.enPlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_SURRENDER
    elseif ("ButtonStop" == prefab.name) then
        --停牌
        playerNormalOperate = Point21DataStruct.CMD_BlackJack.enPlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_STAND_POKER
        logYellow("点击发送停牌")
    elseif ("ButtonDouble" == prefab.name) then
        --双倍
        playerNormalOperate = Point21DataStruct.CMD_BlackJack.enPlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_DOUBLE_CHIP
    elseif ("ButtonAskPoker" == prefab.name) then
        --要牌
        playerNormalOperate = Point21DataStruct.CMD_BlackJack.enPlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_HIT_POKER
    else
        playerNormalOperate = Point21DataStruct.CMD_BlackJack.enPlayerNormalOperate.E_PLAYER_NORMAL_OPERATE_NULL
    end
    local data = {
        [1] = playerNormalOperate
    }
    local buffer = SetC2SInfo(Point21DataStruct.CMD_CS_PLAYER_NORMAL_OPERATE, data)
    Network.Send(
            MH.MDM_GF_GAME,
            Point21DataStruct.CMD_BlackJack.SUB_CS_PLAYER_NORMAL_OPERATE,
            buffer,
            gameSocketNumber.GameSocket
    )

end

--关闭信息面板响应事件
function Point21ScenCtrlPanel.onClickClosPanelBtn()
    self.showInfoPanel(-1)
end

--提示面板响应事件
function Point21ScenCtrlPanel.onClickTiltleBtns(prefab)
    if ("ButtonOk" == prefab.name) then
        self.gameQuit()
    end
    self.titleImage.gameObject:SetActive(false)
end

function Point21ScenCtrlPanel.OnClickBtnHellp()
    local uiCamera = Point21ScenCtrlPanel.transform:Find("Point21GmaeObject2D/Canvas/UGUICamera")
    Point21Hellp.Init(uiCamera, luaBehaviour)
end

function Point21ScenCtrlPanel.throwChipCrtl()
    coroutine.wait(0.5)

    bOnClickChipBtn = false
end

--初始化下注列表
function Point21ScenCtrlPanel.initChipsList(chipsListTab)
    local chipsListIdx = 1
    isInitChip = true;
    for i = (#bottomChipsListIntTab - 2), 1, -1 do
        bottomChipsListIntTab[i] = chipsListTab[chipsListIdx]
        chipsListIdx = chipsListIdx + 1
    end

    bottomChipsListIntTab[#bottomChipsListIntTab] = bottomChipsListIntTab[#bottomChipsListIntTab - 2] / 2 --最后一个为保险筹码

    for i = 1, #bottomChipsListIntTab - 2 do
        Point21ScenCtrlPanel.setChipNumImage(bottomChipsListIntTab[i], chipListTra:GetChild(i - 1))

        if (#bottomChipsListIntTab - 2 == i) then
            Point21ScenCtrlPanel.onClickChipsBtn(chipListTra:GetChild(i - 1))
        end
    end
end

--显示特殊下注按钮
function Point21ScenCtrlPanel.ShowSpChipbtn(bShow)
    if (bShow) then
        if (traSPChip.gameObject.activeSelf) then
            return
        end
        traSPChip.gameObject:SetActive(true)
        traSPChip.transform:DOLocalMoveY(50, 0.8, false)
    else
        traSPChip.transform.localPosition = Vector3.New(traSPChip.localPosition.x, -180, traSPChip.localPosition.z)
        traSPChip.gameObject:SetActive(false)
    end
end

--显示下注列表
--bShow
function Point21ScenCtrlPanel.showChipList(bShow)
    logYellow("显示或者隐藏下注按钮 ::" .. tostring(bShow))
    chipListTra.gameObject:SetActive(bShow)
    if (self.traPlayerChip) then
        if (not IsNil(self.traPlayerChip)) then
            self.traPlayerChip.gameObject:SetActive(bShow)
        end
    end
    bShowChiplist = bShow

    if (bShow) then
        for i = 0, (chipListTra.transform.childCount - 3) do
            --最后一个为提示 倒数第二个为确认按钮
            local btnTra = chipListTra.transform:GetChild(i)
            local chipValStr = btnTra:GetChild(1).name
            local chipValInt = tonumber(chipValStr)
            local myAllGoldInt = point21PlayerTab[myChairID + 1].playerInfoTab._7wGold

            if (chipValInt <= tonumber(myAllGoldInt)) then
                --按钮可点击  
                btnTra:GetComponent("Button").interactable = true
            else
                --按钮不可点击   
                btnTra:GetComponent("Button").interactable = false
            end
        end
    else
        Point21ScenCtrlPanel.ShowSpChipbtn(false)
    end

    point21PlayerTab[myChairID + 1]:SetChipTitle(bShow)
end

function Point21ScenCtrlPanel.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end
function Point21ScenCtrlPanel.ShowText(str)
    --展示tmp字体
    local arr = self.ToCharArray(str);
    local _str = "";
    for i = 1, #arr do
        _str = _str .. string.format("<sprite name=\"%s\">", arr[i]);
    end
    return _str;
end
function Point21ScenCtrlPanel.FormatNumberThousands(num)
    --对数字做千分位操作
    local function checknumber(value)
        return tonumber(value) or 0
    end
    local formatted = tostring(checknumber(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        print(formatted, k)
        if k == 0 then
            break
        end

    end
    return formatted
end
--设置筹码按钮数值
-- numInt筹码数 btnTra按钮物体
function Point21ScenCtrlPanel.setChipNumImage(numInt, btnTra)
    logYellow("设置筹码按钮数值==" .. numInt)
    local str = ""
    btnTra:GetChild(1).name = "" .. numInt
    if tonumber(numInt) > 10000 then
        str = str .. (numInt / 10000) .. "w"
    else
        str = "" .. numInt
    end
    btnTra:GetChild(1):GetComponent("TextMeshProUGUI").text = self.ShowText(str)
    -- Point21ScenCtrlPanel.setNumImage(numInt, btnTra:GetChild(0))
    -- Point21ScenCtrlPanel.SortNumberImg(btnTra:GetChild(0))
end

--显示保险界面
function Point21ScenCtrlPanel.showinsurancePanerl(bShow)
    self.insuranceTitleTra.gameObject:SetActive(bShow)
    if (bShow) then
        local btnCancelTra = self.insuranceTitleTra:Find("Buttons"):Find("ButtonCancel") --取消按钮
        local timeTra = btnCancelTra.transform:Find("Timer/Time")
        self.insuranceTimerText = timeTra.transform:GetComponent("Text")
        self.insuranceTimerText.text = Point21DataStruct.CMD_BlackJack.TIMER_INSURACE
        coroutine.start(self.insuranceTimer)
    else
        point21PlayerTab[myChairID + 1]:setTimer(false) --隐藏自己的时间条
    end
end

--保险计时器
function Point21ScenCtrlPanel.insuranceTimer()
    coroutine.wait(1)
    local timeInt = tonumber(self.insuranceTimerText.text)
    timeInt = timeInt - 1
    self.insuranceTimerText.text = timeInt .. ""
    if (timeInt > 0 and self.insuranceTitleTra.gameObject.activeSelf) then
        coroutine.start(self.insuranceTimer)
    else
        self.showinsurancePanerl(false)
    end
end

--显示普通操作界面
-- bShow 是否显示 , bSplit 是否可以分牌
local isWaitShow = false

function Point21ScenCtrlPanel.showOperation(bShow, bSplit, waitshow)

    if (waitshow) then
        isWaitShow = true
    else
        if (isWaitShow) then
            isWaitShow = false;
            return ;
        end
    end
    logYellow(" bSplit 是否可以分牌" .. tostring(bShow))
    if (point21PlayerTab[5].bIsBlackJack) then
        logYellow("庄家黑杰克")
    end
    if (bShow) then
        bSplit = bSplit or false
        local myPlayerInst = point21PlayerTab[myChairID + 1]
        local myThrowGoldInt = myPlayerInst.allChipValIntTab[myPlayerInst.currentGroupInt]
        local myAllGoldInt = myPlayerInst.playerInfoTab._7wGold
        if (not self.bInoperation) then
            --若没进行过普通操作 则可以双倍和投降
            if (myAllGoldInt >= myThrowGoldInt) then
                --当前金币足够双倍
                operationListTra.transform:Find("ButtonDouble"):GetComponent("Button").interactable = true
            else
                operationListTra.transform:Find("ButtonDouble"):GetComponent("Button").interactable = false
            end
            operationListTra.transform:Find("ButtonSurrender"):GetComponent("Button").interactable = true
        else
            operationListTra.transform:Find("ButtonSurrender"):GetComponent("Button").interactable = false
            operationListTra.transform:Find("ButtonDouble"):GetComponent("Button").interactable = false
        end

        if (bSplit) then
            -- 是否可以分牌
            if (myAllGoldInt >= myThrowGoldInt) then
                --当前金币足够分牌
                operationListTra.transform:Find("ButtonSplit"):GetComponent("Button").interactable = true
            else
                operationListTra.transform:Find("ButtonSplit"):GetComponent("Button").interactable = false
            end
        else
            operationListTra.transform:Find("ButtonSplit"):GetComponent("Button").interactable = bSplit
        end
    end
    operationListTra.gameObject:SetActive(bShow)
end

--显示玩家信息
--idx 玩家索引 小于0为隐藏界面
function Point21ScenCtrlPanel.showInfoPanel(idx)
    if not (gameIsOnline) then
        return
    end
    PlayerInfoSystem.SelectUserInfo(
            point21PlayerTab[idx].playerInfoTab._1dwUser_Id,
            infoPanelTra.transform.parent,
            point21PlayerTab[idx].photoImageTra.transform
    )
    PlayerInfoSystem.SetObjPosition(0, 0, 100)
end
--显示提示框
function Point21ScenCtrlPanel.showtitleImage(bShow)
end

--设置图片数字
function Point21ScenCtrlPanel.setNumImage(numInt, numTra)
    local numStr = ""
    local tempNumInt = 0
    if (numInt / 10000 >= 1) then
        -- 大于一万 使用“万”字图片
        --error("int is : 10000");
        tempNumInt = numInt / 10000
        numStr = tempNumInt .. "w"
        if (numInt / 100000000 >= 1) then
            -- 大于一亿 使用“亿”字图片
            tempNumInt = numInt / 100000000
            numStr = tempNumInt .. "y"
        end
        local front = string.sub(numStr, 1, (#numStr) - 1) --数字部分
        local endStr = string.sub(numStr, #numStr, #numStr) --"万" “亿” 部分
        if (#front > 4) then
            --若数字部分长度大于4 则去前4位
            front = string.sub(front, 1, 4)
        end
        if ("." == string.sub(front, 1, 4)) then
            --若第4位是符号 '.' 则省去
            front = string.sub(front, 1, (#front) - 1)
        end
        numStr = front .. endStr --将数字部分与 "万" "亿" 连接
    else
        tempNumInt = numInt
        numStr = tempNumInt .. ""
    end
    local showNumStrTab = {} --要显示的数字 字符串表
    for i = 1, #numStr do
        table.insert(showNumStrTab, string.sub(numStr, i, i)) --将要显示的数字字符串存入showNumStrTab
    end
    local numsBeginCount = numTra.transform.childCount --数字图片的初始个数
    for i = 1, #showNumStrTab do
        local numChildTra  -- 数字图片物体子物体
        if (i <= numsBeginCount) then
            --已经存在的直接改变图片
            numChildTra = numTra.transform:GetChild(i - 1)
        else
            --不存在的先创建
            numChildTra = newobject(numTra.transform:GetChild(0).gameObject).transform
            numChildTra.transform:SetParent(numTra)
            numChildTra.transform.localScale = Vector3.one
            numChildTra.transform.localPosition = Vector3.New(0, 0, 0)
        end
        numChildTra.gameObject:SetActive(true)
        local numRes
        if (tonumber(showNumStrTab[i])) then
            --若是数字使用数字图片
            numRes = Point21ScenCtrlPanel.chipsNumObjRes.transform:GetChild(tonumber(showNumStrTab[i])) --要显示的图片资源
        else
            --否则使用文字图片
            local findNameStr = ""
            if ("." == showNumStrTab[i]) then
                findNameStr = "p"
            elseif ("w" == showNumStrTab[i]) then
                findNameStr = "w"
            elseif ("y" == showNumStrTab[i]) then
                findNameStr = "yi"
            end
            numRes = Point21ScenCtrlPanel.chipsNumObjRes.transform:Find(findNameStr) --要显示的图片资源
        end
        numChildTra.transform:GetComponent("Image").sprite = numRes.transform:GetComponent("Image").sprite
    end
end

--数字图片排序  iInterval 间隔
function Point21ScenCtrlPanel.SortNumberImg(traNumBase, iInterval)
    iInterval = iInterval or 1
    local iNumCount = 0
    local fAllSize = 0
    for i = 0, traNumBase.childCount - 1 do
        if (traNumBase:GetChild(i).gameObject.activeSelf) then
            iNumCount = iNumCount + 1
            traNumBase:GetChild(i):GetComponent("Image"):SetNativeSize()
            if (0 ~= i) then
                fAllSize = fAllSize + traNumBase:GetChild(i):GetComponent("RectTransform").sizeDelta.x
            end
        else
            break
        end
    end

    local iLostPosX = 0
    local iLastW = 0
    local iThisW = 0
    for i = 0, iNumCount - 1 do
        if (0 ~= i) then
            iLostPosX = traNumBase:GetChild(i - 1).localPosition.x
            iLastW = traNumBase:GetChild(i - 1):GetComponent("RectTransform").sizeDelta.x / 2
            iThisW = traNumBase:GetChild(i):GetComponent("RectTransform").sizeDelta.x / 2
            traNumBase:GetChild(i).localPosition = Vector3.New(iLostPosX + iThisW + iLastW + iInterval, 0, 0)
        end
    end
    traNumBase.localPosition = Vector3.New(0, 0, 0)
end

---------------界面操作 End-------------------
--场景消息处理
function Point21ScenCtrlPanel.scenInfoDispose(scenInfoTab)
    if (not Util.isPc) then
        GameSetsBtnInfo.SetPlaySuonaPos(0, 345, 0)
    end
    g_bGameQuit = false
    if (scenInfoTab.gameRunState == Point21DataStruct.CMD_BlackJack.enGameRunState.E_GAME_RUN_STATE_NULL) then
    elseif (scenInfoTab.gameRunState == Point21DataStruct.CMD_BlackJack.enGameRunState.E_GAME_RUN_STATE_START) then
    elseif (scenInfoTab.gameRunState == Point21DataStruct.CMD_BlackJack.enGameRunState.E_GAME_RUN_STATE_CHIP) then
        for i = 1, #scenInfoTab.iChip do
            if (scenInfoTab.iChip[i] > 0) then
                point21PlayerTab[i]:throwChips(Point21DataStruct.E_CHIPTYPE_NORMAL, scenInfoTab.iChip[i])
            end
        end

        for i = 1, #point21PlayerTab - 1 do
            if (point21PlayerTab[i].bHaveInfo) then
                local timeSecontF = scenInfoTab.iLeftTime / 1000 --时间转化为秒
                if (point21PlayerTab[i].idx == (myChairID + 1)) then
                    if (timeSecontF >= 8) then
                        point21PlayerTab[i]:setTimer(true, timeSecontF) --下注时间大于8秒还可以下注
                        self.showChipList(true)
                    end
                else
                    point21PlayerTab[i]:setTimer(true, timeSecontF)
                end
            end
        end
    elseif (scenInfoTab.gameRunState == Point21DataStruct.CMD_BlackJack.enGameRunState.E_GAME_RUN_STATE_NOT_CHIP) then
        self.scenInfoOfNotChip(scenInfoTab)
    elseif (scenInfoTab.gameRunState == Point21DataStruct.CMD_BlackJack.enGameRunState.E_GAME_RUN_STATE_OFFLINE) then
        self.scenInfoOfNotChip(scenInfoTab)
    end
end

--非下注状态进入游戏
function Point21ScenCtrlPanel.scenInfoOfNotChip(scenInfoTab)
    local ZJState = scenInfoTab.zjOperateState --庄家状态
    if (ZJState > 8 or ZJState < 0) then
        return
    end
    if (ZJState == Point21DataStruct.CMD_BlackJack.enPlayerOperateState.E_PLAYER_OPERATE_STATE_NULL) then
        return
    end
    for i = 1, #point21PlayerTab do
        local playerData = scenInfoTab.serverPlayerData[i] --玩家数据
        point21PlayerTab[i]:halfwayInGame(ZJState, playerData, scenInfoTab.byCurrentOperateChairID)
    end
end

--游戏开始
function Point21ScenCtrlPanel.gameBegin()
    logYellow("游戏开始")
    self.bBeginThrwoChip = true
    self.StartGameMessage = true
    bOnClickChipBtn = false

    for i = 1, #point21PlayerTab do
        point21PlayerTab[i]:playerGameBegin(true, Point21DataStruct.CMD_BlackJack.TIMER_CHIP) --显示时间条, 激活扑克layout
    end

    Point21ZJCtrl.setCountDownTimer(true, Point21DataStruct.CMD_BlackJack.TIMER_CHIP) --倒计时音效

    Point21ScenCtrlPanel.showChipList(true)
end

--大厅提示框
function Point21ScenCtrlPanel.ShowMessageBox(strTitle, iBtnCount, bQuit)
    local tab = GeneralTipsSystem_ShowInfo
    tab._01_Title = ""
    tab._02_Content = strTitle
    tab._03_ButtonNum = iBtnCount
    if (bQuit) then
        tab._04_YesCallFunction = self.gameQuit
    else
        tab._04_YesCallFunction = nil
    end
    tab._05_NoCallFunction = nil
    MessageBox.CreatGeneralTipsPanel(tab)
end

--游戏退出
function Point21ScenCtrlPanel.gameQuit(bNotForce)
    bPoint21GameQuit = true
    point21PlayerTab = {}
    self.bBeginThrwoChip = false
    myChairID = 0
    Point21ZJCtrl.gameQuit()
    Point21PlayerCtrl.gameQuit()
    Point21Hellp.Clealthis()
    MessgeEventRegister.Game_Messge_Un()
    GameSetsBtnInfo.LuaGameQuit()
    g_bGameQuit = true
end

--卸载游戏资源,延迟处理。 防止销毁资源后,界面还没推出
function Point21ScenCtrlPanel.unloadGameRes()
    coroutine.wait(1)
end

function Point21ScenCtrlPanel.onClickHomeBack()
    bPoint21GameQuit = true
    point21PlayerTab = {}
    self.bBeginThrwoChip = false

    myChairID = 0
    Point21ZJCtrl.gameQuit()
    Point21PlayerCtrl.gameQuit()
end

function Point21ScenCtrlPanel.LeaveGame()
    --Point21ScenCtrlPanel.SetTempBJ(false)
    Point21ScenCtrlPanel.onClickHomeBack()
    --local obj=self.transform:Find("Point21GmaeObject2D")
    -- if(obj~=nil)then
    --     destroy(obj.gameObject)  
    -- end
end

function Point21ScenCtrlPanel.GoBackGame()
    --Point21GameNet.playerLogon();
    --LoadAssetAsync(Point21ResourcesNume.abObjResNameStr, 'Point21GmaeObject2D', self.OnCreateSceneObjCallBack,true,true);
    self.OnCreateSceneObjCallBack()
end

function Point21ScenCtrlPanel.SetTempBJ(bShow)
    local tra = self.transform:Find("CanvasTempBackground")
    tra.gameObject:SetActive(bShow)
end

function Point21ScenCtrlPanel.Pool(prefabName)
    if self.tabObjPool == nil then
        self.tabObjPool = {};
    end
    local obj = self.tabObjPool[prefabName]

    if obj == nil then
        local t = self.transform:Find("Pool")
        t = t.transform:Find(prefabName)
        if t == nil then
            error("Pool下没有找到 " .. prefabName)
            return
        end
        self.tabObjPool[prefabName] = t.gameObject
        return t.gameObject
    end
    return obj
end

function Point21ScenCtrlPanel.PoolForNewobject(prefabName)
    local res = Point21ScenCtrlPanel.Pool(prefabName)

    if res == nil then
        return
    end

    local obj = newobject(res)
    obj:SetActive(true)
    obj.name = prefabName
    return obj
end

--睡眠函数
function Point21ScenCtrlPanel.mySleep(sTimeF)
    local bSleep = true
    local tempTimeF = 0

    while bSleep do
        tempTimeF = tempTimeF + Time.deltaTime
        if (tempTimeF >= sTimeF) then
            return
        end
    end
end

--test ===============================================
local stDealPokerTab = { --扑克数据
    byPokerData1 = 0,
    byPokerData2 = 0
}

local point21PlayerOperateTypeTab = { --玩家普通操作类型
    E_PLAYER_NORMAL_OPERATE_NULL = -1,
    --未知
    E_PLAYER_NORMAL_OPERATE_SURRENDER = 0,
    --投降
    E_PLAYER_NORMAL_OPERATE_SPLIT_POKER = 1,
    --分牌
    E_PLAYER_NORMAL_OPERATE_DOUBLE_CHIP = 2,
    --双倍
    E_PLAYER_NORMAL_OPERATE_STAND_POKER = 3,
    --停牌
    E_PLAYER_NORMAL_OPERATE_HIT_POKER = 4,
    --拿牌
    E_PLAYER_NORMAL_OPERATE_AUTO_ADD_POKER = 5
    --自动补牌
}

local point21playerOperateDataTab = { --玩家普通操作数据
    OperateTypeTab = -1, --操作类型
    pokerDataTab = stDealPokerTab, --扑克数据
    byChairID = 0, --玩家座位号
    bBustPokerByte = 0, --是否爆牌
    b21Byte = 0, --21点
    bSelfStopPokerByte = 0 --自己停牌
}

--测试资源回调
function Point21ScenCtrlPanel.loadAssetTestCallBack(prefab)
    local p = find("Canvas").transform:Find("UGUICamera")
    local go = newobject(prefab)
    go.transform:SetParent(p)
    go.name = "PanelTest"
    go.transform.localScale = Vector3.one
    go.transform.localPosition = Vector3.New(0, 0, 100)
    go:SetActive(true)

    luaBehaviour = self.transform:GetComponent("LuaBehaviour")
    --local sendPokerBtn = go.transform:Find('ButtonSendPoker').gameObject;
    for i = 0, (go.transform.childCount - 1) do
        luaBehaviour:AddClick(go.transform:GetChild(i).gameObject, self.testBtnOnClick)
    end

    go = nil
    logYellow("end")
end

function Point21ScenCtrlPanel.testBtnOnClick(args)
    if ("Button0" == args.name) then
        Point21GameNet.BreakGame(true)
    end

    if ("Button1" == args.name) then
        Point21GameNet.OnHomeBack()
    end

    if "ButtonSendPoker" == args.name then
        --发牌测试
        local testPokerData = {}

        for i = 1, 5 do
            local data = {
                byPokerData1 = 0,
                byPokerData2 = 0
            }

            if (3 == i or 5 == i) then
                data.byPokerData1 = 2
                data.byPokerData2 = 2
            end

            table.insert(testPokerData, data)
        end

        Point21ZJCtrl.getFirstPokers(testPokerData)
    end

    if ("ButtonBottomChip" == args.name) then
        --下注
        for i = 1, #point21PlayerTab do
            if (zjPos ~= i) then
                point21PlayerTab[i]:throwChips(10000)
            end
        end
    end

    if ("ButtonBottomInsuranceChip" == args.name) then
        --保险下注
        for i = 1, #point21PlayerTab do
            if (zjPos ~= i) then
                point21PlayerTab[i]:throwChips(point21PlayerTab[i].allChipValIntTab[1] / 2, true)
            end
        end
    end

    if ("ButtonIsBlackjack" == args.name) then
        --庄家黑杰克
        Point21ZJCtrl.zjBackJack(true, 7)
    end

    if ("ButtonNotBlackjack" == args.name) then
        --庄家不是黑杰克
        Point21ZJCtrl.zjBackJack(false)
    end

    if ("ButtonAskPoker" == args.name) then
        --玩家要牌
        for i = 1, #point21PlayerTab do
            if (5 == i) then
                point21playerOperateDataTab.OperateTypeTab = point21PlayerOperateTypeTab.E_PLAYER_NORMAL_OPERATE_HIT_POKER
                point21playerOperateDataTab.pokerDataTab = { byPokerData1 = 1, byPokerData2 = 0 }
                point21playerOperateDataTab.byChairID = i
                point21playerOperateDataTab.bBustPokerByte = 0
                point21playerOperateDataTab.b21Byte = 0
                point21playerOperateDataTab.bSelfStopPokerByte = 0

                point21PlayerTab[i]:playerOperate(point21playerOperateDataTab)
            end
        end
    end

    if ("ButtonDouble" == args.name) then
        --双倍
        point21playerOperateDataTab.OperateTypeTab = point21PlayerOperateTypeTab.E_PLAYER_NORMAL_OPERATE_DOUBLE_CHIP
        point21playerOperateDataTab.pokerDataTab = { byPokerData1 = 12, byPokerData2 = 0 }
        point21playerOperateDataTab.byChairID = 1
        point21playerOperateDataTab.bBustPokerByte = 1
        point21playerOperateDataTab.b21Byte = 0
        point21playerOperateDataTab.bSelfStopPokerByte = 0

        point21PlayerTab[point21playerOperateDataTab.byChairID]:playerOperate(point21playerOperateDataTab)

        Point21ScenCtrlPanel.showOperation(false)
    end

    if ("ButtonSplit" == args.name) then
        --分牌
        point21playerOperateDataTab.OperateTypeTab = point21PlayerOperateTypeTab.E_PLAYER_NORMAL_OPERATE_SPLIT_POKER
        point21playerOperateDataTab.pokerDataTab = { byPokerData1 = 12, byPokerData2 = 7 }
        point21playerOperateDataTab.byChairID = 1
        point21playerOperateDataTab.bBustPokerByte = 0
        point21playerOperateDataTab.b21Byte = 0
        point21playerOperateDataTab.bSelfStopPokerByte = 0

        point21PlayerTab[point21playerOperateDataTab.byChairID]:playerOperate(point21playerOperateDataTab)
    end

    if ("ButtonSurrender" == args.name) then
        --投降
        point21playerOperateDataTab.OperateTypeTab = point21PlayerOperateTypeTab.E_PLAYER_NORMAL_OPERATE_SURRENDER
        point21playerOperateDataTab.byChairID = 5
        point21PlayerTab[point21playerOperateDataTab.byChairID]:playerOperate(point21playerOperateDataTab)
    end

    if ("ButtonStop" == args.name) then
        --停牌
        point21playerOperateDataTab.OperateTypeTab = point21PlayerOperateTypeTab.E_PLAYER_NORMAL_OPERATE_STAND_POKER
        point21playerOperateDataTab.byChairID = 1
        point21PlayerTab[point21playerOperateDataTab.byChairID]:playerOperate(point21playerOperateDataTab)
    end

    if ("ButtonExpression1" == args.name) then
        --表情1
        point21PlayerTab[1]:playExpression(Point21ResourcesNume.ExpressionType.daxiao)
    end

    if ("ButtonExpression2" == args.name) then
        --表情2
        point21PlayerTab[1]:playExpression(Point21ResourcesNume.ExpressionType.jiayou)
    end
end

--test end ==========================================
