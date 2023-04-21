tjz_MainPanel = {}
local self = tjz_MainPanel;

self.luab = nil;
self.per = nil;

function tjz_MainPanel.Start(args,father)
   logYellow("222222222")

   self.init();
   self.per = args;
   self.guikey = tjz_Event.guid();
   self.initPanel();
   self.loadNumCom(father);
end

function tjz_MainPanel.init(args)
    self.runconttable = nil;
    self.guikey = "cn";
    self.mygoldsp = nil;
    self.wildcont = nil;
    self.goldroll = nil;
    self.bgicon = nil;

    --self.lcaidAnima = nil;
    --self.rcaidAnima = nil;
    self.freedeng = nil;
    self.freesp = nil;
    self.normalsp = nil;
    self.canima1 = nil;
    self.canima2 = nil;
    self.canima3 = nil;
    self.canima4 = nil;
end

function tjz_MainPanel.loadPerCom(args)
   tjz_Data.icon_res = args;  
end

function tjz_MainPanel.loadNumCom(father)
   tjz_Data.numres = father.transform:Find("tjz_num");
   self.loadPerCom(father.transform:Find("tjz_icon"));
   self.loadsound(father.transform:Find("tjz_sound"));
   self.initRes1();
   self.initRes(); 
   tjz_Data.isResCom = 2;
   tjz_Event.dispathEvent(tjz_Event.xiongm_load_res_com);      
end



function tjz_MainPanel.loadsound(args)
    tjz_Data.soundres = args;
end

function tjz_MainPanel.initRes1(args)
  tjz_Socket.addGameMessge();
  tjz_Socket.playerLogon();
   self.creatRunCont();
  self.createBtn();  
  self.creatLianLine();
  self.addEvent();
   
end

function tjz_MainPanel.initRes(args)

  self.createTSAnima();
   self.goldroll = tjz_NumRolling:New();
   self.goldroll:setfun(self,self.goldRollCom,self.goldRollIng);
   table.insert(tjz_Data.numrollingcont,#tjz_Data.numrollingcont+1,self.goldroll);

    self.freedeng = self.per.transform:Find("bgcont/freebg/deng");
    self.freesp = self.per.transform:Find("bgcont/freebg");
    self.normalsp =self.per.transform:Find("bgcont/norbg");
    --self.freesp.gameObject:SetActive(false);
    self.freedeng.gameObject:SetActive(false);
   --self.bgicon =  self.per.transform:Find("bgcont/Image");
   self.norBgGo=self.normalsp.transform:Find("norbgcont");
   self.freeBgGo=self.freesp.transform:Find("freebgcont")
   
   --self.normalsp.transform:Find("norbgcont/dengl/light"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")
   --self.normalsp.transform:Find("norbgcont/dengr/light"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Additive")

   --local AllTb={};
   --AllTb=HallScenPanel.GetGameAddAllSprite("Module39");
   --local mainTouMing =AllTb[1]
   ----logTable(mainTouMing)
   --local Tramcar=AllTb[2]
   ----logTable(Tramcar)
   --local Tramcar1=AllTb[3]
   ----logTable(Tramcar1)
   --local Bg=AllTb[4]
   --logTable(Bg)

   -- local  gameGo =self.CreateImage("img0",self.norBgGo);
   -- gameGo:GetComponent("Image").sprite=Bg[2]
   -- gameGo:GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.height / Screen.width) * 750 + 20, 750 + 20);

   -- local  freeGo =self.CreateImage("img0",self.freeBgGo);
   -- freeGo:GetComponent("Image").sprite=Bg[1]
   -- freeGo:GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.height / Screen.width) * 750 + 20, 750 + 20);

   --
   --local freeImg8=self.CreateImage("img8",self.freeBgGo);
   --freeImg8.transform.localScale = Vector3.one;
   --freeImg8.transform.localPosition=Vector3.New(-780,97,0)
   --freeImg8:GetComponent("RectTransform").sizeDelta=Vector2.New(403,1042);
   --freeImg8:GetComponent("Image").color=Color.New(0.5,0.5,0.5,1);
   --
   --freeImg8.transform:SetSiblingIndex(10)
   --freeImg8:GetComponent("Image").sprite=Bg[1]
   --
   --local freeImg9=self.CreateImage("img9",self.freeBgGo);
   --freeImg9.transform.localScale = Vector3.New(-1,1,1)
   --freeImg9.transform.localPosition=Vector3.New(806,-14,0)
   --freeImg9:GetComponent("RectTransform").sizeDelta=Vector2.New(399,822);
   --freeImg9:GetComponent("Image").color=Color.New(0.5,05,0.5,1);
   --freeImg9.transform:SetSiblingIndex(11)
   --freeImg9:GetComponent("Image").sprite=Bg[1]
   --
   --local freeImg10=self.CreateImage("img10",self.freeBgGo);
   --freeImg10.transform.localScale = Vector3.New(1,1,1)
   --freeImg10.transform.localPosition=Vector3.New(791,139,0)
   --freeImg10.transform.localEulerAngles=Vector3.New(0,0,180)
   --freeImg10:GetComponent("RectTransform").sizeDelta=Vector2.New(385,919);
   --freeImg10:GetComponent("Image").color=Color.New(0.5,0.5,0.5,1);
   --freeImg10.transform:SetSiblingIndex(12)
   --freeImg10:GetComponent("Image").sprite=Bg[1]
   --
   --local freeImg11=self.CreateImage("img11",self.freeBgGo);
   --freeImg11.transform.localScale = Vector3.New(1,1,1)
   --freeImg11.transform.localPosition=Vector3.New(-817,-20,0)
   --freeImg11.transform.localEulerAngles=Vector3.New(180,0,0)
   --freeImg11:GetComponent("RectTransform").sizeDelta=Vector2.New(403,1268);
   --freeImg11:GetComponent("Image").color=Color.New(0.5,0.5,0.5,1);
   --freeImg11.transform:SetSiblingIndex(13)
   --freeImg11:GetComponent("Image").sprite=Bg[1]
   --
   --self.normalsp.transform:Find("norbgcont/img1").transform:SetSiblingIndex(2)
   --self.normalsp.transform:Find("norbgcont/img3").transform:SetSiblingIndex(0)
   --
   --local bgImg9=self.CreateImage("img9",self.norBgGo);
   --bgImg9.transform.localScale = Vector3.New(1,1,1)
   --bgImg9.transform.localPosition=Vector3.New(-761,0,0)
   --bgImg9.transform.localEulerAngles=Vector3.New(0,180,0)
   --bgImg9:GetComponent("RectTransform").sizeDelta=Vector2.New(531,760);
   --bgImg9.transform:SetSiblingIndex(1)
   --bgImg9:GetComponent("Image").sprite=Bg[2]
   --
   --local bgImg10=self.CreateImage("img10",self.norBgGo);
   --bgImg10.transform.localScale = Vector3.New(1,1,1)
   --bgImg10.transform.localPosition=Vector3.New(743,0,0)
   --bgImg10:GetComponent("RectTransform").sizeDelta=Vector2.New(457,760);
   --bgImg10.transform:SetSiblingIndex(11)
   --bgImg10:GetComponent("Image").sprite=Bg[2]

   self.setFreeBgAlpha(0);

   --1111
   --self.che1=self.norBgGo.transform:Find("che/che1");
   --self.ret1=self.che1.transform:GetComponent(typeof(UnityEngine.RectTransform))
   --self.che1.gameObject:AddComponent(typeof(ImageAnima));
   --self.canima1 = self.che1.gameObject:GetComponent(typeof(ImageAnima));
   --self.canima1.fSep=0.1;
   --self.canima1.defaultSprite=nil;
   --self.canima1.movieName=""
   --for i=1,16 do
   --   if i<=10 then
   --      self.canima1:AddSprite(Tramcar[i])
   --   else
   --      self.canima1:AddSprite(mainTouMing[1])
   --   end
   --end
   -----2222
   --self.che2=self.norBgGo.transform:Find("che2/che2");
   --self.che2.gameObject:AddComponent(typeof(ImageAnima));
   --self.canima2 = self.che2.gameObject:GetComponent(typeof(ImageAnima));
   --self.canima2.fSep=0.1;
   --self.canima2.movieName=""
   --for i=1,18 do 
   --   if i<=10 then
   --      self.canima2:AddSprite(Tramcar[i])
   --   else
   --      self.canima2:AddSprite(mainTouMing[1])
   --   end
   --end
   -----3333
   --self.che3=self.norBgGo.transform:Find("che3/che3");
   --self.che3.gameObject:AddComponent(typeof(ImageAnima));
   --self.canima3 = self.che3.gameObject:GetComponent(typeof(ImageAnima));
   --self.canima3.fSep=0.1;
   --self.canima3.movieName=""
   --for i=1,26 do
   --   if i<=20 then
   --      self.canima3:AddSprite(Tramcar1[i])
   --   else
   --      self.canima3:AddSprite(mainTouMing[1])
   --   end
   --end
   -----4444
   --self.che4=self.norBgGo.transform:Find("che4/che4")
   --self.che4.gameObject:AddComponent(typeof(ImageAnima));
   --self.canima4 = self.che4:GetComponent(typeof(ImageAnima));
   --self.canima4.fSep=0.1;
   --self.canima4.movieName=""
   --for i=1,28 do
   --   if i<=20 then
   --      self.canima4:AddSprite(Tramcar1[i])
   --   else
   --      self.canima4:AddSprite(mainTouMing[1])
   --   end
   --end
     self.canima1 = self.per.transform:Find("bgcont/norbg/norbgcont/che/che1").gameObject:GetComponent(typeof(ImageAnima));
    self.canima2 = self.per.transform:Find("bgcont/norbg/norbgcont/che2/che2").gameObject:GetComponent(typeof(ImageAnima));
    self.canima3 = self.per.transform:Find("bgcont/norbg/norbgcont/che3/che3").gameObject:GetComponent(typeof(ImageAnima));
    self.canima4 = self.per.transform:Find("bgcont/norbg/norbgcont/che4/che4").gameObject:GetComponent(typeof(ImageAnima));
   self.canima1:SetEndEvent(self.cheAnimacom1);
   self.canima2:SetEndEvent(self.cheAnimacom2);
   self.canima3:SetEndEvent(self.cheAnimacom3);
   self.canima4:SetEndEvent(self.cheAnimacom4);
   coroutine.start(
     function()
        self.canima1:Play();
        coroutine.wait(2);
        self.canima2:Play();
        coroutine.wait(5);
        self.canima3:Play();
        coroutine.wait(8);
        self.canima4:Play();
     end
   );

--   self.lcaidAnima = self.per.transform:Find("bgcont/lcaid").gameObject:AddComponent(typeof(ImageAnima));
--   self.rcaidAnima = self.per.transform:Find("bgcont/rcaid").gameObject:AddComponent(typeof(ImageAnima));
--   for i=1,20 do
--       self.lcaidAnima:AddSprite(tjz_Data.icon_res.transform:Find("piao_anima_"..i):GetComponent('Image').sprite);
--       self.rcaidAnima:AddSprite(tjz_Data.icon_res.transform:Find("piao_anima_"..i):GetComponent('Image').sprite);
--   end

--   self.lcaidAnima.fSep = 0.15; 
--   self.rcaidAnima.fSep = 0.15; 

--   self.lcaidAnima:PlayAlways();
--   self.rcaidAnima:PlayAlways();

  self.per.transform:Find("bottomcont").gameObject:SetActive(true);
  GameManager.GameScenIntEnd(self.per.transform:Find("gamesetcont").transform); --加载集合按钮 

end

function  tjz_MainPanel.CreateImage(imageName,parentGo)
   local  Go =GameObject()
   Go.name=imageName
   Go.transform:SetParent(parentGo)
   Util.AddComponent("Image", Go);
   Go:GetComponent("Image"):SetNativeSize()
   Go.transform.localScale = Vector3.one;
   Go.transform:SetAsFirstSibling()
   return Go;
end

function tjz_MainPanel.cheAnimacom1()
   self.playAnimaSound(self.canima1);
end
function tjz_MainPanel.cheAnimacom2()
   self.playAnimaSound(self.canima2);
end
function tjz_MainPanel.cheAnimacom3()
   self.playAnimaSound(self.canima3);
end
function tjz_MainPanel.cheAnimacom4()
   self.playAnimaSound(self.canima4);
end

function tjz_MainPanel.playAnimaSound(args)
     coroutine.start(function()
      coroutine.wait(7);
      if tjz_Socket.isongame==false then
         return;
      end
      args:Play();
      if tjz_Data.byFreeCnt==0 and tjz_Data.freeAllGold==0 then
          tjz_Socket.playaudio("guidao");
       end
   end);
end

function tjz_MainPanel.initPanel()
   tjz_Rule.setPer(self.per.transform:Find("rulecont"));
   self.per.transform:Find("bottomcont/tsmodets/freetips").gameObject:SetActive(false);
end

function tjz_MainPanel.createBtn()
   tjz_BtnPanel.setPer(self.per.transform:Find("bottomcont"));
end

function tjz_MainPanel.creatLianLine()
   tjz_LianLine.setPer(self.per.transform:Find("line"),self.per.transform:Find("linecont"),self.per);
end

function tjz_MainPanel.createTSAnima()
   tjz_TSAnima.setPer(self.per);
end

function tjz_MainPanel.creatRunCont(args)
    self.runconttable = {};
    local item = nil;
    for i=1,5 do
       item = tjz_RunCont_Item:new();
       item:setPer(self.per.transform:Find("runcontmask/runcont/runcont_"..i),self.per.transform:Find("runcontmask/runcont/showcont_"..i),i);
       item:setSonItem(self.per.transform:Find("item"));
       item:createSonItem(12);
       table.insert(self.runconttable,item);
    end
end

function tjz_MainPanel.addEvent()
     tjz_Event.addEvent(tjz_Event.xiongm_start_btn_click,self.startRunHander,self.guikey);
     tjz_Event.addEvent(tjz_Event.xiongm_exit,self.gameExit,self.guikey);
     tjz_Event.addEvent(tjz_Event.xiongm_unload_game_res,self.unloadGameRes,self.guikey);
     tjz_Event.addEvent(tjz_Event.xiongm_mianf_btn_mode,self.modeBtnState,self.guikey);   
     tjz_Event.addEvent(tjz_Event.xiongm_init,self.gameInit,self.guikey);
end

function tjz_MainPanel.modeBtnState(args)
   if tjz_Data.byFreeCnt>0 or tjz_Data.freeAllGold>0  then
      --self.freesp.gameObject:SetActive(true);
      self.setFreeBgAlpha(1);
      self.freedeng.gameObject:SetActive(true);
      --self.normalsp.gameObject:SetActive(false);
      for i=1,10 do
          if i>tjz_Data.byUpProcess then
              self.freedeng.transform:Find("img"..i).gameObject:SetActive(false);
          else
              self.freedeng.transform:Find("img"..i).gameObject:SetActive(true);
          end
      end
      self.freedeng.transform:Find("img11").gameObject:SetActive(false);
      self.freedeng.transform:Find("img12").gameObject:SetActive(false);
      self.freedeng.transform:Find("img13").gameObject:SetActive(false);
      if tjz_Data.byUpProcess>=3 then
         self.freedeng.transform:Find("img11").gameObject:SetActive(true);
      end
      if tjz_Data.byUpProcess>=6 then
         self.freedeng.transform:Find("img12").gameObject:SetActive(true);
      end
      if tjz_Data.byUpProcess>=10 then
         self.freedeng.transform:Find("img13").gameObject:SetActive(true);
      end
   else
      --self.freesp.gameObject:SetActive(false);
      self.setFreeBgAlpha(0);
      self.freedeng.gameObject:SetActive(false);
      --self.normalsp.gameObject:SetActive(true);
   end
end

function tjz_MainPanel.gameInit(args)
   if tjz_Data.byFreeCnt>0 or tjz_Data.freeAllGold>0 or tjz_Data.byCurUpProcess>0 then
      --self.freesp.gameObject:SetActive(true);
      self.setFreeBgAlpha(1);
      self.freedeng.gameObject:SetActive(true);
      --self.normalsp.gameObject:SetActive(false);
      for i=1,10 do
          if i>tjz_Data.byCurUpProcess then
              self.freedeng.transform:Find("img"..i).gameObject:SetActive(false);
          else
              self.freedeng.transform:Find("img"..i).gameObject:SetActive(true);
          end
      end
      self.freedeng.transform:Find("img11").gameObject:SetActive(false);
      self.freedeng.transform:Find("img12").gameObject:SetActive(false);
      self.freedeng.transform:Find("img13").gameObject:SetActive(false);

      if tjz_Data.byCurUpProcess>=3 then
         self.freedeng.transform:Find("img11").gameObject:SetActive(true);
      end

      if tjz_Data.byCurUpProcess>=6 then
         self.freedeng.transform:Find("img12").gameObject:SetActive(true);
      end

      if tjz_Data.byCurUpProcess>=10 then
         self.freedeng.transform:Find("img13").gameObject:SetActive(true);
      end
   else

      self.setFreeBgAlpha(0);
      self.freedeng.gameObject:SetActive(false);
--    self.normalsp.gameObject:SetActive(true);
   end
end

function tjz_MainPanel.setFreeBgAlpha(val)
   local item = nil;
   local val2 = math.abs(1-val);
   
   for i=1,10 do
       item = self.normalsp.transform:Find("norbgcont/img"..i).gameObject;
       item.gameObject:GetComponent('Image'):DOColor(Color.New(1,1,1,val2),2);
   end

   self.normalsp.transform:Find("norbgcont/che/che1").gameObject:GetComponent('Image'):DOColor(Color.New(1,1,1,val2),2);
   self.normalsp.transform:Find("norbgcont/che/zhezhao1").gameObject:GetComponent('Image'):DOColor(Color.New(1,1,1,val2),2);
   self.normalsp.transform:Find("norbgcont/che2/che2").gameObject:GetComponent('Image'):DOColor(Color.New(1,1,1,val2),2);
   self.normalsp.transform:Find("norbgcont/che2/zhezhao2").gameObject:GetComponent('Image'):DOColor(Color.New(1,1,1,val2),2);
   self.normalsp.transform:Find("norbgcont/che3/che3").gameObject:GetComponent('Image'):DOColor(Color.New(1,1,1,val2),2);
   self.normalsp.transform:Find("norbgcont/che4/che4").gameObject:GetComponent("Image"):DOColor(Color.New(1,1,1,val2),2);
   if val2 == 1 then
      self.normalsp.transform:Find("norbgcont/dengl").gameObject:SetActive(true);
      self.normalsp.transform:Find("norbgcont/dengr").gameObject:SetActive(true);
   else
      self.normalsp.transform:Find("norbgcont/dengl").gameObject:SetActive(false);
      self.normalsp.transform:Find("norbgcont/dengr").gameObject:SetActive(false);
   end


   for i=1,7 do
       item = self.freesp.transform:Find("freebgcont/img"..i).gameObject;
       item.gameObject:GetComponent('Image'):DOColor(Color.New(1,1,1,val),2);
   end

   for i=8,11 do
      item = self.freesp.transform:Find("freebgcont/img"..i).gameObject;
      item.gameObject:GetComponent('Image'):DOColor(Color.New(0.5,0.5,0.5,val),2);
   end

   self.freesp.transform:Find("freebgcont/smoke/smoke_1").gameObject:GetComponent('Image'):DOColor(Color.New(1,1,1,val),2);
   self.freesp.transform:Find("freebgcont/smoke/smoke_2").gameObject:GetComponent('Image'):DOColor(Color.New(1,1,1,val),2);
   self.freesp.transform:Find("freebgcont/smoke/smoke_0").gameObject:GetComponent('Image'):DOColor(Color.New(1,1,1,val),2);
   self.freesp.transform:Find("freebgcont/smoke2/smoke_1").gameObject:GetComponent('Image'):DOColor(Color.New(1,1,1,val),2);
   self.freesp.transform:Find("freebgcont/smoke2/smoke_2").gameObject:GetComponent('Image'):DOColor(Color.New(1,1,1,val),2);
   self.freesp.transform:Find("freebgcont/smoke2/smoke_0").gameObject:GetComponent('Image'):DOColor(Color.New(1,1,1,val),2);
end

function tjz_MainPanel.unloadGameRes(args)
end

function tjz_MainPanel.gameExit(args)

end

function tjz_MainPanel.startRunHander(args)
   tjz_Event.dispathEvent(tjz_Event.xiongm_colse_line,nil);
   tjz_Event.dispathEvent(tjz_Event.game_once_over);
   local len = #self.runconttable;
   for i=1,len do
       self.runconttable[i]:startRun();
   end     
end

function tjz_MainPanel.Update()
  if tjz_Socket.isongame==false then
     return;
  end
  table.foreach(tjz_Data.numrollingcont,function(i,k)
        k:update();
    end)
  tjz_BtnPanel.Update();
  tjz_TSAnima.Update(); 
end

function tjz_MainPanel.FixedUpdate()
    if tjz_Socket.isongame==false then
       return;
    end
    table.foreach(self.runconttable,function(i,k)
        k:Update();
    end)
end