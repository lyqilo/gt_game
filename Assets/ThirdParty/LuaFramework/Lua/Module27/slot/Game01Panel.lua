-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
g_sSlotModuleNum = "Module27/";

require(g_sSlotModuleNum .. "Slot/SlotBase")
require(g_sSlotModuleNum .. "Slot/SlotGameNet")
require(g_sSlotModuleNum .. "Slot/SlotResourcesName_New")

require(g_sSlotModuleNum .. "Slot/SlotTimer")
require(g_sSlotModuleNum .. "Slot/SlotExplainCtrl")
require(g_sSlotModuleNum .. "Slot/SlotMainImgAnimation")
require(g_sSlotModuleNum .. "Slot/SlotTitleCtrl")


-- require("Module03/Common/define")--默认的定义
-- require("Module03/Common/functions")--公共函数
-- require("Module03/Core/MessgeEventRegister")
-- require("Module03/Data/gameData")
require(g_sSlotModuleNum .. "Slot/SlotDataStruct")
require(g_sSlotModuleNum .. "Slot/SlotUserInfo")

-- require("Common/Util")
Game01Panel = {}

local self = Game01Panel;

local transform;

local numberRes;

local tabObjPool = {};
local localTime = 0;

function Game01Panel:Awake(obj)
    Event.AddListener(HallScenPanel.ReconnectEvent, self.Reconnect);
    tabObjPool = {};
    transform = obj.transform;
    Game01Panel.LoadGameScene(obj);
    --log(obj.name);
    --SlotDataStruct.UpdateJackpotTime = Timer.New(self:UpdateJackpot(), 5, true, true);
    -- SlotDataStruct.UpdateJackpotTime:FixUpdateByPeriod(UpdateJackpot,)
end
function Game01Panel.Reconnect()
    logYellow("重连成功")
    SlotGameNet.playerLogon()

    SlotBase.ResetRotate();
end



function Game01Panel:OnDestroy()
    Event.RemoveListener(HallScenPanel.ReconnectEvent, self.Reconnect);
end
function Game01Panel:Update()
    if (self.isBase) then
        self.isBase.Update();
    end

    if (self.bSetGameScenInt) then Game01Panel.SetGameScenInt(); end
    localTime = localTime + Time.deltaTime;
    if (localTime >= 5) then
        log("当前时间：" .. localTime)
        localTime = 0;
        SlotGameNet.RequestJackPot();
    end
end

--[[function UpdateJackpot()
    -- self.RequestJackPot();
end--]]
function Game01Panel.LoadGameScene(obj)
    MessgeEventRegister.Game_Messge_Un();
    -- 清除消息事件
    SlotGameNet.addGameMessge();
    Game01Panel.LoadAssetSceneCallBack(obj);

end

-- 加载场景资源回调
function Game01Panel.LoadAssetSceneCallBack(prefab)
    local go = prefab.transform;
    local cas = go.transform:Find("Canvas");
    if (Util.isPc) then
        local tra = cas.transform:Find("UGUICamera");
        tra.transform.localEulerAngles = Vector3.New(0, 0, 0);
    end
    cas.transform:Find("UGUICamera").localRotation = Quaternion.identity;
    cas.transform:GetComponent("CanvasScaler").referenceResolution = Vector2.New(1334, 750);
    cas.transform:Find("UGUICamera"):GetComponent("Camera").clearFlags = UnityEngine.CameraClearFlags.SolidColor
    cas.transform:Find("UGUICamera"):GetComponent("Camera").backgroundColor = Color.New(0, 0, 0, 1);
    SetCanvasScalersMatch(cas.transform:GetComponent("CanvasScaler"),1);
    -- 屏幕适配
    GameManager.PanelRister(transform.gameObject);
    Game01Panel.InitResourceData(go.transform);
    GameManager.GameScenIntEnd(transform:Find("Canvas/SlotBase/SetButtonPos"));
    -- 加载集合按钮
    GameManager.PanelInitSucceed(transform.gameObject);
    self.bSetGameScenInt = true;

    local bg = GameObject.New("BgImage"):AddComponent(typeof(UnityEngine.UI.Image));
    bg.transform:SetParent(transform:Find("Canvas/SlotBase/Bj"));
    bg.transform:SetSiblingIndex(1);
    bg.transform.localPosition = Vector3(0, 0, 50);
    bg.transform.localScale = Vector3(1, 1, 1);
    bg.sprite = HallScenPanel.moduleBg:Find("module27"):GetComponent("Image").sprite;
    bg:GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);

    local slotbg = transform:Find("Canvas/SlotBase/Bj");
    for i = 3, slotbg.childCount do
        slotbg:GetChild(i - 1):GetComponent("Image").sprite = HallScenPanel.moduleBg:Find("module27/bg_01_0" .. (i - 2)):GetComponent("Image").sprite;
    end
    -- 是否设置了集合按钮
end


-- 设置集合按钮
function Game01Panel.SetGameScenInt()
    local tra = transform:Find("Canvas/SlotBase/SetButtonPos/GameSetsPanel");
    if (not tra) then return; end
    self.bSetGameScenInt = false;
    tra.transform.localPosition = Vector3(0, 0, 0);
    if (not Util.isPc) then GameSetsBtnInfo.SetPlaySuonaPos(15, 150, 0); end
end

-- 初始化资源数据
function Game01Panel.InitResourceData(tra)
    numberRes = Game01Panel.Pool("NumberRes");
    self.goldNumRes = numberRes.transform:Find("GoldNumberRes");
    -- 金币数字资源
    self.freeNumRes = numberRes.transform:Find("FreeNumberRes");
    -- 免费次数数字资源
    self.godDownEndNumRes = numberRes.transform:Find("GodDownEndNumberRes");
    -- 财神降临结束数字资源
    self.allChipNumRes = numberRes.transform:Find("AllChipNumberRes");
    -- 总下注值
    self.bigNumRes = numberRes.transform:Find("BigNumberRes");
    -- 大数字
    self.superGoldNumRes = numberRes.transform:Find("SuperGoldNumRes");
    -- 超级彩金数字资源
    self.animRes = Game01Panel.Pool("MainImageAnimationRes");
    self.musicRes = Game01Panel.Pool("MusicRes");
    local baseObj = tra.transform:Find("Canvas/SlotBase");
    local luaBehaviour = transform:GetComponent('LuaBehaviour');
    self.isBase = SlotBase.init(baseObj, luaBehaviour);
    Game01Panel.PlayBjMusic(SlotResourcesName.bgm);
    SlotGameNet.playerLogon();
end
-- 加载数字图片资源回调
function Game01Panel.LoadAssetNumberResCallBack(prefab)
    self.numberRes = prefab;
end

-- 播放背景音乐
function Game01Panel.PlayBjMusic(sName)
    MusicManager:PlayBacksound("end", false);
    -- 停止背景音乐
    local bJSource = self.musicRes.transform:Find(sName):GetComponent('AudioSource');
    -- 背景音乐
    MusicManager:PlayBacksoundX(bJSource.clip, true);
end
function Game01Panel.GameQuit()
    GameSetsBtnInfo.LuaGameQuit();
    coroutine.start(self.unloadGameRes);
end
function Game01Panel.unloadGameRes()
    coroutine.wait(1);
    SlotBase.GameQuit();
    log("---- game Unload end ----------");
end
-- 创建物体
function Game01Panel.CreateGameObject(resObj, strName, traParent, ve3Pos)
    ve3Pos = ve3Pos or Vector3.New(0, 0, 0);
    local obj = newobject(resObj);
    if (strName) then
        obj.name = strName;
    end
    if (traParent) then
        obj.transform:SetParent(traParent);
    end
    obj.transform.localScale = Vector3.one;
    obj.transform.localPosition = ve3Pos;
    return obj
end

-- 设置物体图片
function Game01Panel.SetImgSprite(traImg, traRes, strName)
    if (strName) then
        traImg.transform:GetComponent('Image').sprite = traRes.transform:Find(strName):GetComponent('Image').sprite;
    else
        traImg.transform:GetComponent('Image').sprite = traRes.transform:GetComponent('Image').sprite;
    end
    traImg.transform:GetComponent('Image'):SetNativeSize();
    return sprite;
end



function Game01Panel.Pool(prefabName, ...)
    local arg = { ... };
    for key, var in pairs(arg) do
        if (var) then prefabName = prefabName .. "/" .. var; end
    end
    local obj = tabObjPool[prefabName];
    if obj == nil then
        local t = transform:Find("Pool");
        t = t.transform:Find(prefabName);
        if t == nil then error("Pool下没有找到 " .. prefabName); return; end
        tabObjPool[prefabName] = t.gameObject;
        return t.gameObject;
    end
    return obj;
end

function Game01Panel.PoolForNewobject(prefabName, iChildId, strName, traParent, ve3Pos)
    iChildId = iChildId or -1;
    local res = Game01Panel.Pool(prefabName);
    if (iChildId >= 0) then res = res.transform:GetChild(iChildId); end
    if res == nil then error("没有可实例化的对象 " .. prefabName); return; end
    local obj = Game01Panel.CreateGameObject(res, strName, traParent, ve3Pos)
    return obj;
end
self.tabResultsInfo = { byImg, byLineType, byWealthGodNum, byFreeNum, gameType, dwWinScore,};
self.tabByImg = { 0, 2, 3, 0, 0, 5, 1, 7, 8, 9, 10, 0, 4, 7, 0 };
self.lineType =   --线对应的位置
 {
    [1] = { 1, 1, 1, 1, 1 },
    [2] = { 1, 1, 1, 1, 1 },
    [3] = { 1, 1, 1, 1, 1 },
    [4] = { 1, 0, 0, 0, 0 },
    [5] = { 0, 0, 0, 0, 0 },
    [6] = { 1, 0, 0, 0, 0 },
    [7] = { 0, 0, 0, 0, 0 },
    [8] = { 0, 0, 0, 0, 0 },
    [9] = { 0, 0, 0, 0, 0 },
    [10] = { 0, 0, 0, 0, 0 },
    [11] = { 1, 0, 0, 0, 0 },
    [12] = { 0, 0, 0, 0, 0 },
    [13] = { 0, 0, 0, 0, 0 },
    [14] = { 0, 0, 0, 0, 0 },
    [15] = { 0, 0, 0, 0, 0 },
    [16] = { 0, 0, 0, 0, 0 },
    [17] = { 0, 0, 0, 0, 0 },
    [18] = { 0, 0, 0, 0, 0 },
    [19] = { 0, 0, 0, 0, 0 },
    [20] = { 0, 0, 0, 0, 0 },
    [21] = { 0, 0, 0, 0, 0 },
    [22] = { 0, 0, 0, 0, 0 },
    [23] = { 0, 0, 0, 0, 0 },
    [24] = { 0, 0, 0, 0, 0 },
    [25] = { 0, 0, 0, 0, 0 },
    [26] = { 0, 0, 0, 0, 0 },
    [27] = { 0, 0, 0, 0, 0 },
    [28] = { 0, 0, 0, 0, 0 },
    [29] = { 0, 0, 0, 0, 0 },
    [30] = { 0, 0, 0, 0, 0 }
};

--测试资源回调
local traTestSysInfo;
function Game01Panel.loadAssetTestCallBack(prefab)
    local testParent = find("SlotGameObject").transform:Find("Canvas/SlotBase");
    local go = newobject(prefab);
    go.transform:SetParent(testParent);
    go.name = "PanelTest";
    go.transform.localScale = Vector3.one;
    go.transform.localPosition = Vector3.New(0, 0, 0);
    go:SetActive(true);
    traTestSysInfo = go.transform;
    luaBehaviour = transform:GetComponent('LuaBehaviour');
    for i = 0, (go.transform.childCount - 1) do
        luaBehaviour:AddClick(go.transform:GetChild(i).gameObject, self.testBtnOnClick);
        if (go.transform:GetChild(i).name ~= "TestSysInfo") then
            go.transform:GetChild(i).gameObject:SetActive(false);
        else
            go.transform:GetChild(i).gameObject:SetActive(true);
            go.transform:GetChild(i).localPosition = Vector3.New(go.transform:GetChild(i).localPosition.x,
            go.transform:GetChild(i).localPosition.y, 0);
        end
    end
    go = nil;
    self.tabResultsInfo.byImg = self.tabByImg;
    self.tabResultsInfo.byLineType = self.lineType;
    self.tabResultsInfo.byWealthGodNum = 0;
    self.tabResultsInfo.byFreeNum = 0;
    self.tabResultsInfo.gameType = SlotDataStruct.enGameType.E_GAME_TYPE_NORMAL;
    self.tabResultsInfo.dwWinScore = 0;
end

--游戏系统信息测试
function Game01Panel.TestGameSysInfo(scData)
    local strBlood = int64.tonum2(bytes:ReadInt64()) .. "";
    local strCheate = scData:ReadInt32() .. "";
    local textBlood = traTestSysInfo.transform:Find("TestSysInfo/TextBlood/Text"):GetComponent('Text');
    local textCheate = traTestSysInfo.transform:Find("TestSysInfo/TextCheate/Text"):GetComponent('Text');
    textBlood.text = strBlood;
    textCheate.text = strCheate;
end


function Game01Panel.testBtnOnClick(args)
    --    if( "ButtonStart" == args.name )then --启动
    --        log("启动！"); 
    --        SlotBase.iCurrentChip = 1;
    --        SlotBase.GameStart(self.tabResultsInfo)
    --        if(self.tabResultsInfo.byWealthGodNum > 0) then
    --            self.tabResultsInfo.byWealthGodNum = self.tabResultsInfo.byWealthGodNum - 2;
    --        end
    --        if(self.tabResultsInfo.byWealthGodNum <= 0) then
    --            self.tabResultsInfo.byWealthGodNum = 0;
    --        end
    --        self.tabResultsInfo.byFreeNum = self.tabResultsInfo.byFreeNum - 1;
    --    end
    --    if("ButtonResulte" == args.name) then --结算
    --        log("结算！");         
    --        SlotBase.iCurrentChip = 100;
    --        SlotBase.iWinScore = 54700;  
    --        SlotBase.GameResult();
    --    end
    --    if("ButtonGodDown" == args.name) then --财神降临
    --        SlotBase.bGodDown = true;
    --        SlotBase.iCurrentChip = 100;
    --        SlotBase.iWinScore = 200;  
    --        SlotBase.byFreeNum = 8;
    --        SlotBase.byWealthGodNum = 8;
    --        SlotBase.GodDown();
    --    end
    --    if("ButtonIsPBSH" == args.name) then  --蓬荜生辉
    --        SlotBase.iCurrentChip = 100;
    --        SlotBase.iWinScore = 200;  
    --        SlotBase.byFreeNum = 5;
    --        SlotBase.byWealthGodNum = 5;
    --        SlotBase.gameType = SlotDataStruct.enGameType.E_GAME_TYPE_PBSH;
    --        SlotBase.IsPBSH();
    --    end
    --    if("ButtonJYMT" == args.name) then --金玉满堂
    --        SlotBase.byLineType = self.lineType;
    --        SlotBase.ShowLine();
    --    end
    --    if("ButtonSetGold" == args.name) then --设置金币
    --        SlotBase.SetGold(100000000000);
    --    end
    --    if("ButtonDouble" == args.name) then  --双倍
    --    end
    --    if("ButtonSplit" == args.name) then  --分牌
    --    end
    --    if("ButtonSurrender" == args.name) then  --投降
    --    end
    --    if("ButtonStop" == args.name) then  --停牌
    --    end
    --    if("ButtonExpression1" == args.name) then  --表情1
    --    end
    --    if("ButtonExpression2" == args.name) then  --表情2
    --    end
    --    if("TestSysInfo" == args.name) then  --测试数据
    --        local buffer = ByteBuffer.New();
    --        Network.Send(MH.MDM_GF_GAME, SlotDataStruct.SUB_CS_TEST_INFO, buffer, gameSocketNumber.GameSocket);
    --    end
end