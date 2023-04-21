
require "Module33/longhudou/longhudou_BtnPanel"
require "Module33/longhudou/longhudou_CMD"
require "Module33/longhudou/longhudou_Config"
require "Module33/longhudou/longhudou_Data"
require "Module33/longhudou/longhudou_Event"
require "Module33/longhudou/longhudou_LianLine"
require "Module33/longhudou/longhudou_MainPanel"
require "Module33/longhudou/longhudou_NumRolling"
require "Module33/longhudou/longhudou_PushFun"
require "Module33/longhudou/longhudou_Rule"
require "Module33/longhudou/longhudou_Run_Soon_Item"
require "Module33/longhudou/longhudou_RunCont_Item"
require "Module33/longhudou/longhudou_Socket"
require "Module33/longhudou/longhudou_Win_Gold"
require "Module33/longhudou/longhudou_TSAnima"
--require "longhudou/longhudou_RunComp"



longhudou_InitProt = {}
local  self = longhudou_InitProt;


local gameObject;
function longhudou_InitProt.Awake()
    Screen.orientation = UnityEngine.ScreenOrientation.Landscape;
    Screen.autorotateToLandscapeLeft = true;
    Screen.autorotateToLandscapeRight = true;
    Screen.autorotateToPortrait = false;
    Screen.autorotateToPortraitUpsideDown = false;
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
    local icon=father.transform:Find("xiangqislot_icon");
     if Util.isPc then
        obj.transform:Find("mycarcam").transform.localRotation = Vector3.New(0, 0, 0);
    end
    obj.transform:Find("mycarcam").transform.localRotation = Quaternion.identity;
    obj.gameObject:GetComponent('CanvasScaler').referenceResolution = Vector2.New(1334, 750);
    SetCanvasScalersMatch(obj.gameObject:GetComponent('CanvasScaler'),1);     
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


   --  local par_1=obj.transform:Find("bgcont/hm"):GetComponent(typeof(UnityEngine.ParticleSystemRenderer))
   --  local par_2=obj.transform:Find("bgcont/hm/huomiao (1)"):GetComponent(typeof(UnityEngine.ParticleSystemRenderer))
   --  local par_3=obj.transform:Find("bgcont/hm/huomiao (2)"):GetComponent(typeof(UnityEngine.ParticleSystemRenderer))
   --  par_1.alignment=UnityEngine.ParticleSystemRenderSpace.Local
   --  par_2.alignment=UnityEngine.ParticleSystemRenderSpace.Local
   --  par_3.alignment=UnityEngine.ParticleSystemRenderSpace.Local


    self.sdkuang=obj.transform:Find("tsrun/shandongkuang/img")
    self.sdkuang.gameObject:AddComponent(typeof(ImageAnima));
    self.canima1 = self.sdkuang.gameObject:GetComponent(typeof(ImageAnima));
    self.canima1.fSep=0.1;
    self.canima1.defaultSprite=nil;
    self.canima1.movieName=""
    self.canima1:PlayAlways()
    self.canima1.defaultSprite=nil
    self.canima1.shower=nil
   local spa=nil;
   for i=1,12 do
      spa= icon:Find("speed_anima_"..i):GetComponent("Image").sprite
      self.canima1:AddSprite(spa)
   end    
   --self.sdkuang:GetComponent("Image").color=Color.New(1,1,1,1)
   obj.transform:Find("tsrun/shandongkuang").transform.localPosition=Vector3.New(0,0,0)




    
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

