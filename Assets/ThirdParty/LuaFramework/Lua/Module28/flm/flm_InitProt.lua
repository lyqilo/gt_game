require "Module28/flm/flm_Socket"
require "Module28/flm/flm_BtnPanel"
require "Module28/flm/flm_CMD"
require "Module28/flm/flm_Config"
require "Module28/flm/flm_Data"
require "Module28/flm/flm_Event"
require "Module28/flm/flm_LianLine"
require "Module28/flm/flm_MainPanel"
require "Module28/flm/flm_NumRolling"
require "Module28/flm/flm_PushFun"
require "Module28/flm/flm_Rule"
require "Module28/flm/flm_Run_Soon_Item"
require "Module28/flm/flm_RunCont_Item"
require "Module28/flm/flm_Win_Gold"
require "Module28/flm/flm_TSAnima"
--require "Module28/flm/flm_RunComp"



flm_InitProt = {}
local self = flm_InitProt;

local gameObject;
function flm_InitProt.Awake()
    Event.AddListener(HallScenPanel.ReconnectEvent, self.Reconnect);
    flm_Socket.initdataandres();
    self.loadPerCom();
    --LoadAssetAsync("module13/game_gongfupanda_main", "gongfupanda_main", self.loadPerCom,true,true);
    --LoadAsset('game_gongfupanda_main', 'gongfupanda_main',self.loadPerCom); 
end

function flm_InitProt.Reconnect()
    log("重连成功")

    flm_Socket.playerLogon();
    coroutine.start(self._StartGame)
end

function flm_InitProt._StartGame()
    while not flm_Data.InitOver do
        coroutine.wait(0.2)
    end
    coroutine.wait(1)
    logYellow("自动游戏")
    if flm_Data.isAutoGame then
        flm_Socket.gameOneOver(true);
    end
    flm_Data.InitOver=false
end


function flm_InitProt.OnDestroy()
    Event.RemoveListener(HallScenPanel.ReconnectEvent, self.Reconnect);
end
function flm_InitProt.loadPerCom()
    --local obj = newobject(obj);   
    local father = GameObject.Find("flm_InitProt").transform;
    local obj = father.transform:Find("flm_main");

    local bg = GameObject.New("BgImage"):AddComponent(typeof(UnityEngine.UI.Image));
    bg.transform:SetParent(obj:Find("bgcont/bgcont1"));
    bg.transform:SetAsFirstSibling();
    bg.transform.localPosition = Vector3(0, 0, 0);
    bg.transform.localScale = Vector3(1, 1, 1);
    bg.sprite = HallScenPanel.moduleBg:Find("module28"):GetComponent("Image").sprite;
    bg:GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
    bg.gameObject.layer = UnityEngine.LayerMask.NameToLayer("gameModule");
    for i = 1, 10 do
        obj:Find("bgcont/bgcont1/img" .. i).gameObject:SetActive(false);
    end

    bg = GameObject.New("BgImage"):AddComponent(typeof(UnityEngine.UI.Image));
    bg.transform:SetParent(obj:Find("bgcont/bgcont2"));
    bg.transform:SetAsFirstSibling();
    bg.transform.localPosition = Vector3(0, 0, 0);
    bg.transform.localScale = Vector3(1, 1, 1);
    bg.sprite = HallScenPanel.moduleBg:Find("module28/bg1"):GetComponent("Image").sprite;
    bg:GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
    bg.gameObject.layer = UnityEngine.LayerMask.NameToLayer("gameModule");
    for i = 1, 10 do
        obj:Find("bgcont/bgcont2/img" .. i).gameObject:SetActive(false);
    end
    local zhu = GameObject.New("Zhu"):AddComponent(typeof(UnityEngine.UI.Image));
    local yun = GameObject.New("Yun"):AddComponent(typeof(UnityEngine.UI.Image));
    zhu.transform:SetParent(obj:Find("bgcont/bgcont1"));
    yun.transform:SetParent(zhu.transform);
    zhu.transform:SetAsLastSibling();
    zhu.transform.localPosition = Vector3(-666, -3.45, 0);
    zhu.transform.localScale = Vector3(1, 1, 1);
    yun.transform.localPosition = Vector3(0, 0, 0);
    yun.transform.localScale = Vector3(1, 1, 1);
    zhu.sprite = HallScenPanel.moduleBg:Find("module28/zhu"):GetComponent("Image").sprite;
    yun.sprite = HallScenPanel.moduleBg:Find("module28/yun"):GetComponent("Image").sprite;
    zhu:GetComponent("RectTransform").sizeDelta = Vector2.New(97, 732);
    yun:SetNativeSize();
    yun.transform.localPosition = Vector3.New(-60, 0, 0);
    zhu.gameObject.layer = UnityEngine.LayerMask.NameToLayer("gameModule");
    yun.gameObject.layer = UnityEngine.LayerMask.NameToLayer("gameModule");

    local zhu1 = newObject(zhu.gameObject);
    zhu1.transform:SetParent(obj:Find("bgcont/bgcont1"));
    zhu1.transform:SetAsLastSibling();
    zhu1.transform.localScale = Vector3.New(-1, 1, 1);
    zhu1.transform.localPosition = Vector3.New(666, -3.45, 0);

    obj.transform:Find("bottomcont").gameObject:SetActive(false);
    obj.transform:Find("bottomcont/allfreegoldcont").gameObject:SetActive(false);
    obj.transform:Find("rulecont").gameObject:SetActive(false);
    if Util.isPc then
        obj.transform:Find("mycarcam").transform.localRotation = Vector3.New(0, 0, 0);
    end
    obj:GetComponent("CanvasScaler").referenceResolution = Vector2.New(1334, 750);
    obj.transform:Find("mycarcam"):GetComponent('Camera').clearFlags = UnityEngine.CameraClearFlags.SolidColor;
    obj.transform:Find("mycarcam"):GetComponent("Camera").backgroundColor = Color.New(0, 0, 0, 1);
    obj.transform:Find("mycarcam").localRotation = Quaternion.identity;
    SetCanvasScalersMatch(obj.gameObject:GetComponent('CanvasScaler'),1);
    gameObject = father.gameObject;    --obj:SetActive(true);

    GameManager.PanelRister(gameObject);
    local luaBehaviour = father.transform:GetComponent('LuaBehaviour');
    flm_Data.luabe = luaBehaviour;
    --flm_MainPanel.Start(obj);   
    --    obj.transform:SetParent(father);
    --    obj.transform.localScale=Vector3.one;
    --    obj.transform.localPosition=Vector3.New(0,0,0);
    GameManager.PanelInitSucceed(gameObject);
    --    coroutine.start(function(args)
    --    coroutine.wait(0.01);
    flm_MainPanel.Start(obj, father);
    -- end);

end

function flm_InitProt.Update()
    flm_MainPanel.Update();
end
function flm_InitProt.FixedUpdate()
    flm_MainPanel.FixedUpdate();
end

