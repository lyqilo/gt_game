
require "Module64/longhudou/longhudou_BtnPanel"
require "Module64/longhudou/longhudou_CMD"
require "Module64/longhudou/longhudou_Config"
require "Module64/longhudou/longhudou_Data"
require "Module64/longhudou/longhudou_Event"
require "Module64/longhudou/longhudou_LianLine"
require "Module64/longhudou/longhudou_MainPanel"
require "Module64/longhudou/longhudou_NumRolling"
require "Module64/longhudou/longhudou_PushFun"
require "Module64/longhudou/longhudou_Rule"
require "Module64/longhudou/longhudou_Run_Soon_Item"
require "Module64/longhudou/longhudou_RunCont_Item"
require "Module64/longhudou/longhudou_Socket"
require "Module64/longhudou/longhudou_Win_Gold"
require "Module64/longhudou/longhudou_TSAnima"
--require "longhudou/longhudou_RunComp"



longhudou_InitProt = {}
local  self = longhudou_InitProt;


local gameObject;
function longhudou_InitProt.Awake()
   error("______longhudou_InitProt______");
    Event.AddListener(HallScenPanel.ReconnectEvent, self.Reconnect);
   longhudou_Socket.initdataandres();
   self.loadPerCom();
   --error("______obj______"..obj.name);
   --LoadAsset('module17/game_xiangqislot_main', 'xiangqislot_main',self.loadPerCom); 
   --LoadAssetAsync('module17/game_xiangqislot_main', 'xiangqislot_main',self.loadPerCom,true,true);
end

function longhudou_InitProt:OnDestroy()
    Event.RemoveListener(HallScenPanel.ReconnectEvent, self.Reconnect);
    Event.RemoveListener(PanelListModeEven._020LevelUpChangeGoldTicket,longhudou_BtnPanel.LevelUpGoldChange);
end


--回到游戏
function longhudou_InitProt:Reconnect()
    logYellow("回到游戏")
    longhudou_Socket.playerLogon()

    logYellow("byFreeCnt=="..longhudou_Data.byFreeCnt)
    logYellow("isAutoGame=="..tostring(longhudou_Data.isAutoGame))

    if longhudou_Data.byFreeCnt>=1 or longhudou_Data.isAutoGame==true then
        coroutine.start(longhudou_InitProt._WaitTime)
    end
end

function  longhudou_InitProt:_WaitTime()
    coroutine.wait(1.5)
    longhudou_Socket.gameOneOver2(false)
end
function longhudou_InitProt.loadPerCom()
    error("____luaBehaviour____");
    --local obj = newobject(arg);
    local father =GameObject.Find("longhudou_InitProt").transform; 
    local obj = father.transform:Find("xiangqislot_main");
    --father.transform:Find("xiangqislot_main/Image"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.height / Screen.width) * 750 + 20, 750 + 20);

     if Util.isPc then
        obj.transform:Find("mycarcam").transform.localRotation = Vector3.New(0, 0, 0);
    end
    --SetCanvasScalersMatch(obj.gameObject:GetComponent('CanvasScaler'));     
    gameObject=father.gameObject;    --obj:SetActive(true);
    GameManager.PanelRister(gameObject);
    local luaBehaviour = father.transform:GetComponent('LuaBehaviour');
    longhudou_Data.luabe = luaBehaviour; 
   -- longhudou_MainPanel.Start(obj); 
    obj.transform:Find("tsrun/shandongkuang").gameObject:SetActive(false); 
    --obj.transform:Find("lizi").gameObject:SetActive(false);
    --obj.transform:Find("zhipai_mianfeicishu").gameObject:SetActive(false); 
    obj.transform:Find("bottomcont").gameObject:SetActive(false); 
    obj.transform:Find("rulecont").gameObject:SetActive(false);     
    obj.transform:Find("bgcont/bgcont1").gameObject:SetActive(false); 
--    obj.transform:SetParent(father);
--    obj.transform.localScale=Vector3.one;
--    obj.transform.localPosition=Vector3.New(0,0,0);
   -- GameManager.PanelInitSucceed(gameObject);
    --coroutine.start(function(args)
        --coroutine.wait(0.01);
         error("__111__luaBehaviour____");
        longhudou_MainPanel.Start(obj,father); 
    --end);
end

function longhudou_InitProt.Update()
   longhudou_MainPanel.Update();
end
function longhudou_InitProt.FixedUpdate()
  longhudou_MainPanel.FixedUpdate();
end

