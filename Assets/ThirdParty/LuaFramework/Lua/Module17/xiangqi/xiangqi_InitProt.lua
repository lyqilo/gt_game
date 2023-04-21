
require "Module17/xiangqi/xiangqi_BtnPanel"
require "Module17/xiangqi/xiangqi_CMD"
require "Module17/xiangqi/xiangqi_Config"
require "Module17/xiangqi/xiangqi_Data"
require "Module17/xiangqi/xiangqi_Event"
require "Module17/xiangqi/xiangqi_LianLine"
require "Module17/xiangqi/xiangqi_MainPanel"
require "Module17/xiangqi/xiangqi_NumRolling"
require "Module17/xiangqi/xiangqi_PushFun"
require "Module17/xiangqi/xiangqi_Rule"
require "Module17/xiangqi/xiangqi_Run_Soon_Item"
require "Module17/xiangqi/xiangqi_RunCont_Item"
require "Module17/xiangqi/xiangqi_Socket"
require "Module17/xiangqi/xiangqi_Win_Gold"
require "Module17/xiangqi/xiangqi_TSAnima"
--require "xiangqi/xiangqi_RunComp"



xiangqi_InitProt = {}
local  self = xiangqi_InitProt;


local gameObject;
function xiangqi_InitProt.Awake()
    Screen.orientation = UnityEngine.ScreenOrientation.Landscape;
    Screen.autorotateToLandscapeLeft = true;
    Screen.autorotateToLandscapeRight = true;
    Screen.autorotateToPortrait = false;
    Screen.autorotateToPortraitUpsideDown = false;
    Event.AddListener(HallScenPanel.ReconnectEvent, self.Reconnect);
   xiangqi_Socket.initdataandres();
   self.loadPerCom();
   --error("______obj______"..obj.name);
   --LoadAsset('module17/game_xiangqislot_main', 'xiangqislot_main',self.loadPerCom); 
   --LoadAssetAsync('module17/game_xiangqislot_main', 'xiangqislot_main',self.loadPerCom,true,true);
end

function xiangqi_InitProt.loadPerCom()
    --error("____luaBehaviour____");
    --local obj = newobject(arg);
    local father =GameObject.Find("xiangqi_InitProt").transform; 
    local obj = father.transform:Find("xiangqislot_main");
    obj.gameObject:GetComponent('CanvasScaler').referenceResolution = Vector2.New(1334,750);
    obj.transform:Find("mycarcam"):GetComponent('Camera').clearFlags = UnityEngine.CameraClearFlags.SolidColor;
    obj.transform:Find("mycarcam"):GetComponent("Camera").backgroundColor = Color.New(0, 0, 0, 1);
    obj.transform:Find("mycarcam").localRotation = Quaternion.identity;
    obj.gameObject:GetComponent('CanvasScaler').matchWidthOrHeight = 1;
    SetCanvasScalersMatch(obj.gameObject:GetComponent('CanvasScaler'),1); 
        
    gameObject=father.gameObject;    --obj:SetActive(true);
    GameManager.PanelRister(gameObject);
    local luaBehaviour = father.transform:GetComponent('LuaBehaviour');
    xiangqi_Data.luabe = luaBehaviour; 
   -- xiangqi_MainPanel.Start(obj); 
    obj.transform:Find("tsrun/shandongkuang").gameObject:SetActive(false); 
    obj.transform:Find("lizi").gameObject:SetActive(false);
    obj.transform:Find("zhipai_mianfeicishu").gameObject:SetActive(false); 
    obj.transform:Find("bottomcont").gameObject:SetActive(false); 
    obj.transform:Find("rulecont").gameObject:SetActive(false);     
    obj.transform:Find("bgcont").gameObject:SetActive(false); 
    obj.transform:Find("runbgcont").gameObject:SetActive(false);
    obj.transform:Find("runbg2").gameObject:SetActive(false);


--    obj.transform:SetParent(father);
--    obj.transform.localScale=Vector3.one;
--    obj.transform.localPosition=Vector3.New(0,0,0);
   -- GameManager.PanelInitSucceed(gameObject);
    --coroutine.start(function(args)
        --coroutine.wait(0.01);
        xiangqi_MainPanel.Start(obj,father); 
        --local bg = GameObject.New("BgImage"):AddComponent(typeof(UnityEngine.UI.Image));
        --bg.transform:SetParent(obj);
        --bg.transform:SetAsFirstSibling();
        --bg.transform.localPosition = Vector3(0, 0, 0);
        --bg.transform.localScale = Vector3(1, 1, 1);
        --bg.sprite = HallScenPanel.moduleBg:Find("module17-20/module17"):GetComponent("Image").sprite;
        --bg:GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width/Screen.height) *750 + 20, 750 + 20);
        --bg.gameObject:AddComponent(typeof(UnityEngine.Canvas)).overrideSorting = true;
        --bg:GetComponent("Canvas").sortingOrder = -2;
        --bg.gameObject.layer = UnityEngine.LayerMask.NameToLayer("gameModule");
        --
        --local bg1=GameObject.New("BgImage1"):AddComponent(typeof(UnityEngine.UI.Image));
        --bg1.transform:SetParent(bg.transform);
        --bg1.transform.localPosition = Vector3(0, 0, 0);
        --bg1.transform.localScale = Vector3(1, 1, 1);
        --bg1.sprite = HallScenPanel.moduleBg:Find("module17-20/module17/bg1"):GetComponent("Image").sprite;
        --bg1:GetComponent("RectTransform").sizeDelta = Vector2.New( bg1.sprite.textureRect.width,770);
        --bg1.gameObject.layer = UnityEngine.LayerMask.NameToLayer("gameModule");

    --end);
end

function xiangqi_InitProt.Update()
   xiangqi_MainPanel.Update();
end
function xiangqi_InitProt.FixedUpdate()
  xiangqi_MainPanel.FixedUpdate();
end
function xiangqi_InitProt.Reconnect()
    xiangqi_Socket.playerLogon();
    coroutine.start(function ()
        coroutine.wait(1);
        xiangqi_Socket.gameOneOver(xiangqi_Data.isAutoGame);
    end)
end
function xiangqi_InitProt.OnDestroy()
    Event.RemoveListener(HallScenPanel.ReconnectEvent, self.Reconnect);
end

