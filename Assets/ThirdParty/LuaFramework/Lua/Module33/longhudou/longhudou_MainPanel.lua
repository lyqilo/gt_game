longhudou_MainPanel = {}
local self = longhudou_MainPanel;

self.luab = nil;
self.per = nil;

function longhudou_MainPanel.Start(args,father)
   self.init();
   self.per = args;
   self.guikey = longhudou_Event.guid();
   self.initPanel();
   --LoadAsset('module17/game_xiangqislot_num', 'xiangqislot_num',self.loadNumCom); 
   self.loadNumCom(father);
end

function longhudou_MainPanel.init(args)
    self.runconttable = nil;
    self.guikey = "cn";
    self.mygoldsp = nil;
    self.wildcont = nil;
    self.goldroll = nil;
    self.dalong = nil;
end

function longhudou_MainPanel.loadPerCom(args)
   longhudou_Data.icon_res = args; 
   self.initRes(); 
--   longhudou_Data.isResCom = longhudou_Data.isResCom+1;
--   if longhudou_Data.isResCom==2 then
--      longhudou_Event.dispathEvent(longhudou_Event.xiongm_load_res_com);      
--   end  
end

function longhudou_MainPanel.loadNumCom(father)
   longhudou_Data.numres = father.transform:Find("xiangqislot_num");
   self.loadPerCom(father.transform:Find("xiangqislot_icon"));
   self.loadsound(father.transform:Find("xiangqislot_sound"));
   self.initRes1();
   longhudou_Data.isResCom = 2;
   longhudou_Event.dispathEvent(longhudou_Event.xiongm_load_res_com); 
   longhudou_Socket.playaudio("bg",true,true,true)
   
   --local AllTb=HallScenPanel.GetGameAddAllSprite("module33");
   --local Bg=AllTb[1]
   --self._bgcont=father.transform:Find("xiangqislot_main/bgcont")
   --
   --self.bg2_img1=self._bgcont:Find("bgcont2/img1")
   --self.bg2_img1:GetComponent("Image").sprite=Bg[1]
   --self.bg2_img1:GetComponent("Image"):SetNativeSize();
   --self.bg2_img1.transform.localPosition = Vector3.New(5, -35, 0);
   --
   --self.bg1_img1=self._bgcont:Find("bgcont1/img1")
   --self.bg1_img1:GetComponent("Image").sprite=Bg[1]
   --self.bg1_img1:GetComponent("Image"):SetNativeSize();
   --self.bg1_img1.transform.localPosition = Vector3.New(5, -35, 0);
   --self.bg1_img1.gameObject:SetActive(fasle);
   --
   --local go =GameObject();
   --go.name = "BG"
   --go.transform:SetParent(self._bgcont)
   --Util.AddComponent("Image", go);
   --go.transform.localPosition = Vector3.New(0, 0, 0);
   --go.transform.localScale = Vector3.New(1,1,1)    
   --go:GetComponent("Image").sprite = AllTb[1][2]
   --go:GetComponent("Image"):SetNativeSize();
   --go:GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
   --go.transform:SetAsFirstSibling()

   father.transform:Find("xiangqislot_main/bottomcont/selectnumcont/closebtn"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
   father.transform:Find("xiangqislot_main/bottomcont/allfreegoldcont/zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
   father.transform:Find("xiangqislot_main/bottomcont/wincaijingoldcont/zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);

   --self._bgcont:Find("yun"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
   --self._bgcont:Find("hm"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
   --self._bgcont:Find("hm/huomiao (1)"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
   --self._bgcont:Find("hm/huomiao (2)"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
   --self._bgcont:Find("hm/yanwu"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
   --self._bgcont:Find("hm/yanwu").localScale=Vector3.New(1.2,1.2,1.5)
   --father.transform:Find("xiangqislot_main/bottomcont/allfreegoldcont/jinbi_dajiang"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")
   --father.transform:Find("xiangqislot_main/bottomcont/wincaijingoldcont/jinbi_dajiang"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")
   --father.transform:Find("xiangqislot_main/bottomcont/tswints/titlecont/win_3/jinbi_xiaojiang"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")

--   LoadAssetAsync('module17/game_xiangqislot_icon', 'xiangqislot_icon',self.loadPerCom,false,false); 
--   coroutine.start(function (args)
--         coroutine.wait(0.1);
--          LoadAssetAsync('module17/game_xiangqislot_sound', 'xiangqislot_sound',self.loadsound,false,false); 
--    end);
end
function longhudou_MainPanel.loadsound(args)
   longhudou_Data.soundres = args;
--   longhudou_Data.isResCom = longhudou_Data.isResCom+1;
--   if longhudou_Data.isResCom==2 then
--      longhudou_Event.dispathEvent(longhudou_Event.xiongm_load_res_com);      
--   end
end


function longhudou_MainPanel.initRes1(args)
  longhudou_Socket.addGameMessge();
  longhudou_Socket.playerLogon();
  self.creatRunCont();
  self.createBtn();  
  self.creatLianLine();
  self.addEvent();
end


function longhudou_MainPanel.initRes(args)
  self.createTSAnima();
   self.goldroll = longhudou_NumRolling:New();
   self.goldroll:setfun(self,self.goldRollCom,self.goldRollIng);
   table.insert(longhudou_Data.numrollingcont,#longhudou_Data.numrollingcont+1,self.goldroll);
   self.per.transform:Find("bottomcont").gameObject:SetActive(true); 
   self.dalong = self.per.transform:Find("runcontmask/runcont/dalong");
   self.dalong.localScale=Vector3.New(1,1.1,1)
   self.dalong.gameObject:SetActive(false); 
  GameManager.GameScenIntEnd(self.per.transform:Find("gamesetcont").transform); --加载集合按钮  
  local Canvas=self.per.transform:Find("gamesetcont").transform:GetComponent("Canvas");

    Canvas:GetComponent("RectTransform").anchorMax = Vector2.New(1,1);
    Canvas:GetComponent("RectTransform").anchorMin = Vector2.New(0,0);
    Canvas:GetComponent("RectTransform").offsetMax = Vector2.New(0,0);
    Canvas:GetComponent("RectTransform").offsetMin = Vector2.New(0,0);
  Canvas.sortingOrder=4
end

function longhudou_MainPanel.initPanel()
   longhudou_Rule.setPer(self.per.transform:Find("rulecont"));
end

function longhudou_MainPanel.createBtn()
   longhudou_BtnPanel.setPer(self.per.transform:Find("bottomcont"));
end

function longhudou_MainPanel.creatLianLine()
   longhudou_LianLine.setPer(self.per);
end

function longhudou_MainPanel.createTSAnima()
   longhudou_TSAnima.setPer(self.per);
end

function longhudou_MainPanel.creatRunCont(args)
    self.runconttable = {};
    local item = nil;
    for i=1,5 do
       item = longhudou_RunCont_Item:new();
       item:setPer(self.per.transform:Find("runcontmask/runcont/runcont_"..i),self.per.transform:Find("runcontmask/runcont/showcont_"..i),i);
       item:setSonItem(self.per.transform:Find("item"),self.per.transform:Find("runitem"));
       item:createSonItem(12);
       table.insert(self.runconttable,item);
    end
end

function longhudou_MainPanel.addEvent()
     --longhudou_Event.addEvent(longhudou_Event.xiongm_start,self.startRunHander,self.guikey);
     longhudou_Event.addEvent(longhudou_Event.xiongm_start_btn_click,self.startRunHander,self.guikey);
     longhudou_Event.addEvent(longhudou_Event.xiongm_exit,self.gameExit,self.guikey);
     longhudou_Event.addEvent(longhudou_Event.xiangqi_unload_game_res,self.unloadGameRes,self.guikey);     
     longhudou_Event.addEvent(longhudou_Event.xiongm_show_bg,self.showBg,self.guikey);
     longhudou_Event.addEvent(longhudou_Event.xiongm_show_free_bg_anima,self.showFreeBgAnima,self.guikey);
     longhudou_Event.addEvent(longhudou_Event.xiongm_long_move,self.freeLongMove,self.guikey);
     longhudou_Event.addEvent(longhudou_Event.xiongm_run_com,self.runCom,self.guikey);
     
end

function longhudou_MainPanel.freeLongMove(args)
   local item = self.per.transform:Find("runcontmask/runcont/runcont_"..args.data);
   if item == nil then
      return;
   end
   local pos = item.transform.localPosition;
   local lpos = self.dalong.transform.localPosition;
   self.dalong.gameObject:SetActive(true);
   self.dalong.transform:DOLocalMove(Vector3.New(pos.x,lpos.y,lpos.z),0.5,false);

end
function longhudou_MainPanel.runCom(args)
   if args.data == 5 then
      self.dalong.gameObject:SetActive(false);
   end
end


function longhudou_MainPanel.showFreeBgAnima(args)

end

function longhudou_MainPanel.showBg(args)


   if args.data==2 then
      if  self.per.transform:Find("bgcont/bgcont1").gameObject.activeSelf== true then
          self.bganima(args.data);
          self.per.transform:Find("bottomcont/tswints").gameObject:SetActive(false);
          --self.per.transform:Find("lizi").gameObject:SetActive(false);
          --self.per.transform:Find("zhipai_mianfeicishu").gameObject:SetActive(false);
          coroutine.start(function(args)
               coroutine.wait(2);
               self.per.transform:Find("bgcont/bgcont1").gameObject:SetActive(false);
          end);
      end
   else
      if  self.per.transform:Find("bgcont/bgcont1").gameObject.activeSelf== false then
          self.bganima(args.data);
          --self.per.transform:Find("lizi").gameObject:SetActive(true);
          --self.per.transform:Find("zhipai_mianfeicishu").gameObject:SetActive(true);
          self.per.transform:Find("bgcont/bgcont1").gameObject:SetActive(true);
      end
   end

--   self.per.transform:Find("bgcont/bgcont1").gameObject:SetActive(false);
--   self.per.transform:Find("bgcont/bgcont2").gameObject:SetActive(false);
--   self.per.transform:Find("bgcont/bgcont"..args.data).gameObject:SetActive(true);
--   if args.data==2 then
--      self.per.transform:Find("bottomcont/tswints").gameObject:SetActive(false);
--      self.per.transform:Find("lizi").gameObject:SetActive(false);
--      self.per.transform:Find("zhipai_mianfeicishu").gameObject:SetActive(false);
--   else
--      self.per.transform:Find("lizi").gameObject:SetActive(true);
--      self.per.transform:Find("zhipai_mianfeicishu").gameObject:SetActive(true);
--   end
end

function longhudou_MainPanel.bganima(args)
   local aplaval = 1;
   if args==2 then
      aplaval = 0;
   end
   local item = nil;
   for i=1,1 do
      item = self.per.transform:Find("bgcont/bgcont1/img"..i).gameObject;
      item.gameObject:GetComponent('Image'):DOColor(Color.New(1,1,1,aplaval),2);
   end
   
end



function longhudou_MainPanel.unloadGameRes(args)
   error("______gameExit___");
--    coroutine.start(function(args)
--       coroutine.wait(0.5);
--       Unload('module17/game_xiangqislot_main');
--       Unload('module17/game_xiangqislot_icon');
--       Unload('module17/game_xiangqislot_num');
--       Unload('module17/game_xiangqislot_sound');
--    end);  
end

function longhudou_MainPanel.gameExit(args)
  
end

function longhudou_MainPanel.startRunHander(args)
   longhudou_Event.dispathEvent(longhudou_Event.xiongm_colse_line,nil);
   longhudou_Event.dispathEvent(longhudou_Event.game_once_over);
   if longhudou_Data.byFreeCnt==0 then
      self.dalong.gameObject:SetActive(false);
   end
   local len = #self.runconttable;
   for i=1,len do
       self.runconttable[i]:startRun();
   end
   
end

function longhudou_MainPanel.Update()
  if longhudou_Socket.isongame==false then
     return;
  end
  table.foreach(longhudou_Data.numrollingcont,function(i,k)
        k:update();
    end)
  longhudou_BtnPanel.Update();
  longhudou_TSAnima.Update();  
end

function longhudou_MainPanel.FixedUpdate()
    if longhudou_Socket.isongame==false then
       return;
    end
    table.foreach(self.runconttable,function(i,k)
        k:Update();
    end)
end