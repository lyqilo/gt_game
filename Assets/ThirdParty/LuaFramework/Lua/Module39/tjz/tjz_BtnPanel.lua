tjz_BtnPanel = {};
local self = tjz_BtnPanel;



function tjz_BtnPanel.init()
    self.per = nil;
    self.autobtn = nil;
    self.countAutoTimer = 0;
    self.isCountAutoTimer = false;
    self.autoandstartcont = nil;
    self.myGoldNum = nil;
    self.chouNum = nil;
    self.allPushNum = nil;

    self.liehuoSp = nil;
    self.freesp = nil;
    self.freeNumCont = nil;

    self.noStartBtn = nil;--手动按钮
    self.stopautobtnnum = nil;
    self.selectnumcont = nil;
    self.stopBtn = nil;--停止按钮
    self.guikey = "cn";

    self.curChoumIndex = 1;
    self.perBtn = nil;
    self.nextBtn = nil;

    self.winGoldSp = nil;
    self.WinGoldNum = nil;

    self.maxwinGoldSp = nil;
    self.maxWinGoldNum = nil;
    self.maxwinGoldroll = nil;

    self.showWinGold = 0;
    self.lastWinGold = 0;
    self.selfGameIndex = 0;

    self.winGoldroll = nil;

    self.freeTips = nil;

    self.autoClick = false;--开始按钮是不是点击

    self.showWinData = nil;

    self.getgoldanima = nil;

    self.mianfzhuan = nil;
    self.lihuoicon = nil;

    self.caijinnum = nil;
end

function tjz_BtnPanel.setPer(args)
   self.init();
   self.per = args;
   self.guikey = tjz_Event.guid();
   self.autobtn = self.per.transform:Find("startbtn"); 
   self.myGoldNum = self.per.transform:Find("mygoldcont/mygoldnumcont"); 
   self.chouNum = self.per.transform:Find("choumcont/choumnumcont"); 
   self.choumtxt = self.per.transform:Find("choumcont/choumtxt"); 
   

   self.perBtn = self.per.transform:Find("choumcont/perbtn"); 
   self.nextBtn = self.per.transform:Find("choumcont/nextbtn"); 
   self.freeTips = self.per.transform:Find("tsmodets/freetips"); 
   self.freeTips.transform:Find("zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
   self.per.transform:Find("loading/zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);



   self.winGoldSp = self.per.transform:Find("wingoldcont");
   self.WinGoldNum = self.per.transform:Find("wingoldcont/numcont");

   self.maxwinGoldSp = self.per.transform:Find("wingoldcontmax");
   self.maxWinGoldNum = self.per.transform:Find("wingoldcontmax/numcont");
   self.maxwinGoldSp.transform:Find("jinbi_xiaojiang"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")

   self.caijinnum = self.per.transform:Find("caijcont/numcont");

    
    

   self.freesp = self.per.transform:Find("freeicon");
   self.freeNumCont = self.per.transform:Find("freeicon/numcont");

   self.noStartBtn = self.per.transform:Find("closestartbtncont/closestartbtn");--手动按钮
   self.stopautobtnnum = self.per.transform:Find("closestartbtncont/numtxt").gameObject;
   self.selectnumcont = self.per.transform:Find("selectnumcont").gameObject;
   self.stopBtn = self.per.transform:Find("stopbtn");--停止按钮


   self.mianfzhuan = self.per.transform:Find("mianfzhuan");
   self.chongzhuanicon = self.per.transform:Find("chongzhuan");
   

   self.noStartBtn.gameObject:SetActive(false);
   self.stopBtn.gameObject:SetActive(false);
   self.freeTips.gameObject:SetActive(false);
   self.freesp.gameObject:SetActive(false);
   self.maxwinGoldSp.gameObject:SetActive(false);

   self.mianfzhuan.gameObject:SetActive(false);
   self.chongzhuanicon.gameObject:SetActive(false);

   self.selectnumcont.gameObject:SetActive(false);  
   self.stopautobtnnum.gameObject:SetActive(false);  

   

   self.winGoldroll = tjz_NumRolling:New();
   self.winGoldroll:setfun(self,self.winGoldRollCom,self.winGoldRollIng);
   table.insert(tjz_Data.numrollingcont,#tjz_Data.numrollingcont+1,self.winGoldroll);

   self.maxwinGoldroll = tjz_NumRolling:New();
   self.maxwinGoldroll:setfun(self,self.maxwinGoldRollCom,self.maxwinGoldRollIng);
   table.insert(tjz_Data.numrollingcont,#tjz_Data.numrollingcont+1,self.maxwinGoldroll);

    self.addEvent();
    local eventTrigger=Util.AddComponent("EventTriggerListener",self.autobtn.gameObject);
    eventTrigger.onDown = self.autoStartDown;
    eventTrigger.onUp  = self.autoStartUp;

    tjz_PushFun.CreatShowNum(self.WinGoldNum,0,"choum_",false,58,2,310,-142);

    self.getgoldanima = self.per.transform:Find("mygoldcont/getgoldanima").gameObject:AddComponent(typeof(ImageAnima));
    
end

function tjz_BtnPanel.loadResCom(args)
   if self.getgoldanima==nil then
      return;
   end
    for i=1,5 do
       self.getgoldanima:AddSprite(tjz_Data.icon_res.transform:Find("mygold_chang_"..1):GetComponent('Image').sprite);
       self.getgoldanima:AddSprite(tjz_Data.icon_res.transform:Find("mygold_chang_"..2):GetComponent('Image').sprite);
    end
    self.getgoldanima.fSep = 0.1;
end

function tjz_BtnPanel.maxwinGoldRollIng(obj,args)
    tjz_PushFun.CreatShowNum(self.maxWinGoldNum,args,"freeall_gold_",false,57,2,820,-160);
end

function tjz_BtnPanel.maxwinGoldRollCom(obj,args)
   tjz_PushFun.CreatShowNum(self.maxWinGoldNum,args,"freeall_gold_",false,57,2,820,-160);   
end


function tjz_BtnPanel.winGoldRollIng(obj,args)
    tjz_PushFun.CreatShowNum(self.WinGoldNum,args,"choum_",false,58,2,310,-142);
    
end


function tjz_BtnPanel.winGoldRollCom(obj,args)
  if not IsNil(tjz_Data.saveSound) then
      destroy(tjz_Data.saveSound);
   end
   --self.titleInit();
   self.closeStopBtnHander();
   if self.showWinData.anima~=nil then
      local m =self.showWinData.anima.main;
      m.loop = false;
      --self.showWinData.anima.loop = false;
      --self.showWinData.anima:Play();
   end
   if self.showWinData.iscom==true then
       --tjz_PushFun.CreatShowNum(self.WinGoldNum,tjz_Data.lineWinScore,"choum_",false,58,2,310,-142);
       tjz_PushFun.CreatShowNum(self.WinGoldNum,args,"choum_",false,58,2,310,-142);
      self.winGoldSpVisibel();      
    else
       tjz_PushFun.CreatShowNum(self.WinGoldNum,args,"choum_",false,58,2,310,-142);
   end
    coroutine.start(function()
       coroutine.wait(1);
       if tjz_Socket.isongame==false then
          return;
       end
       self.maxwinGoldSp.gameObject:SetActive(false);
       tjz_Event.dispathEvent(tjz_Event.xiongm_gold_roll_com,tjz_Config.forlin); 
       --tjz_Event.dispathEvent(tjz_Event.xiongm_show_start_btn,nil);
       --tjz_Event.dispathEvent(tjz_Event.xiongm_start_btn_no_inter,true);
    end);

   
end

--根据一些状态隐藏界面 1 开始 2 手动 3 停止 4 烈火 5免费 
function tjz_BtnPanel.setVisibleBtn(args)
    self.autobtn.gameObject:SetActive(false);
    self.noStartBtn.gameObject:SetActive(false); 
    self.stopautobtnnum.gameObject:SetActive(false);
    if args==1 then
       if tjz_Data.isAutoGame==false then
          self.autobtn.gameObject:SetActive(true);
       else
           self.noStartBtn.gameObject:SetActive(true);
           self.stopautobtnnum.gameObject:SetActive(true);
       end
    elseif args==2 then
       self.myChoumBtnInter(false);
       self.noStartBtn.gameObject:SetActive(true);
       self.stopautobtnnum.gameObject:SetActive(true);
    elseif args==3 then
       self.stopBtn.gameObject:SetActive(true);
    elseif args==4 then
       self.myChoumBtnInter(false);
    elseif args==5 then
       self.myChoumBtnInter(false);
       self.freesp.gameObject:SetActive(true);
    end
end

function tjz_BtnPanel.showStopBtnHander(args)
   --error("________showStopBtnHander_________");
   self.stopBtn.gameObject:SetActive(true);
end

function tjz_BtnPanel.closeStopBtnHander(args)
   --error("________showStopBtnHander_________");
   self.stopBtn.gameObject:SetActive(false);
end


function tjz_BtnPanel.closeSelectRunNun(args)
   self.stopautobtnnum.gameObject:SetActive(false);  
   self.selectnumcont.gameObject:SetActive(false);  
end

function tjz_BtnPanel.selectRunNunHander(args)
  local str = args.transform.parent.name;
  local str1 = string.split(str, "_");
  --error("________selectRunNunHander______"..str);
  --error("________selectRunNunHander______"..str1[2]);
  self.closeSelectRunNun();
  self.noStartBtn.gameObject:SetActive(true);
  tjz_Data.isAutoGame = true;
  tjz_Socket.gameOneOver(true);
  self.setVisibleBtn(2); 
  local datanum = {10,50,100,10000000};
  tjz_Data.autoRunNum = datanum[tonumber(str1[2])];
  self.stopautobtnnum.gameObject:SetActive(true);  
  
  tjz_Data.isshowmygold = true
  tjz_Data.myinfoData._7wGold=tjz_Data.myinfoData._7wGold-(tjz_Data.curSelectChoum*tjz_CMD.D_LINE_COUNT)
  tjz_Event.dispathEvent(tjz_Event.xiongm_gold_chang,true);
end

function tjz_BtnPanel.gameOver(args)
   local mindex = 0;
   local len = #tjz_Data.choumtable;
   for i=1,len do
       if tjz_Data.curSelectChoum == tjz_Data.choumtable[i] then
           mindex = i;
       end
   end
  tjz_PushFun.CreatShowNum(self.caijinnum,math.ceil(tjz_Data.i64AccuPool*(mindex*0.2)),"cai_jin_",false,58,2,400,-490);
  if tjz_Data.autoRunNum<1 and tjz_Data.isAutoGame==true then
     self.noStartBtnHander();
     self.stopautobtnnum.gameObject:SetActive(false);  
  else
     local str = tjz_Data.autoRunNum;
     if tjz_Data.autoRunNum>1000 then
        str = "无限";
         tjz_PushFun.CreatShowNum2(self.stopautobtnnum,13,"free_",2,175,-45);
     else
         tjz_PushFun.CreatShowNum(self.stopautobtnnum,str,"free_",false,47,2,175,-45);
     end
  end
end

function tjz_BtnPanel.caijinChang(args)
     local mindex = 0;
     local len = #tjz_Data.choumtable;
     for i=1,len do
         if tjz_Data.curSelectChoum == tjz_Data.choumtable[i] then
             mindex = i;
         end
     end
     if mindex > 0 then
        tjz_PushFun.CreatShowNum(self.caijinnum,math.ceil(tjz_Data.i64AccuPool*(mindex*0.2)),"cai_jin_",false,58,2,400,-490);
     end
end
  

function tjz_BtnPanel.autoStartDown(args)
  self.isCountAutoTimer = true;--是不是记录 自动按钮按下的时间
end

function tjz_BtnPanel.autoStartUp(args)
   if self.isCountAutoTimer== true and self.autobtn.gameObject:GetComponent("Button").interactable then
      self.autoBtnHander();
   end
   self.isCountAutoTimer = false;--是不是记录 自动按钮按下的时间
   self.countAutoTimer = 0;--按钮按下的时间
end

function tjz_BtnPanel.addEvent()
   --tjz_Data.luabe:AddClick(self.autobtn.gameObject,self.autoBtnHander);
   tjz_Data.luabe:AddClick(self.noStartBtn.gameObject,self.noStartBtnHander);
   tjz_Data.luabe:AddClick(self.stopBtn.gameObject,self.stopBtnHander);

   tjz_Data.luabe:AddClick(self.perBtn.gameObject,self.perBtnHander);
   tjz_Data.luabe:AddClick(self.nextBtn.gameObject,self.nextBtnHander);
   tjz_Event.addEvent(tjz_Event.xiongm_init,self.gameInit,self.guikey);
   tjz_Event.addEvent(tjz_Event.xiongm_show_start_btn,self.showStartBtn,self.guikey);
   tjz_Event.addEvent(tjz_Event.xiongm_start_btn_no_inter,self.startBtnInter,self.guikey);
   tjz_Event.addEvent(tjz_Event.xiongm_show_free_btn,self.showFreeBtn,self.guikey);
   tjz_Event.addEvent(tjz_Event.xiongm_show_free_num_chang,self.freeNumChang,self.guikey);
   tjz_Event.addEvent(tjz_Event.xiongm_gold_chang,self.goldChang,self.guikey); 
   tjz_Event.addEvent(tjz_Event.xiongm_show_no_start_btn,self.showNoStartBtnHander,self.guikey); 
   tjz_Event.addEvent(tjz_Event.xiongm_show_stop_btn,self.showStopBtnHander,self.guikey); 
   tjz_Event.addEvent(tjz_Event.xiongm_close_stop_btn,self.closeStopBtnHander,self.guikey);    
   tjz_Event.addEvent(tjz_Event.xiongm_show_win_gold,self.showWinGoldHander,self.guikey);   
   tjz_Event.addEvent(tjz_Event.xiongm_start,self.startHander,self.guikey);   
   tjz_Event.addEvent(tjz_Event.game_once_over,self.onceOver,self.guikey);   
   tjz_Event.addEvent(tjz_Event.xiongm_show_free_tips,self.showFreeTipHander,self.guikey);   
   tjz_Event.addEvent(tjz_Event.xiongm_mianf_btn_mode,self.modeBtnState,self.guikey);   
   tjz_Event.addEvent(tjz_Event.xiongm_over,tjz_Event.hander(self,self.gameOver),self.guikey);
   
   tjz_Event.addEvent(tjz_Event.xiongm_load_res_com,self.loadResCom,self.guikey); 
    tjz_Data.luabe:AddClick(self.selectnumcont.transform:Find("closebtn").gameObject,self.closeSelectRunNun); 
    for i=1,4 do
        tjz_Data.luabe:AddClick(self.selectnumcont.transform:Find("item_"..i.."/btn").gameObject,self.selectRunNunHander); 
    end

end

function tjz_BtnPanel.modeBtnState()

   if tjz_Data.bReturn == true then
      self.chongzhuanicon.gameObject:SetActive(true);
   else
      self.chongzhuanicon.gameObject:SetActive(false);
   end
   if tjz_Data.byFreeCnt>0 or tjz_Data.freeAllGold>0 then
      self.mianfzhuan.gameObject:SetActive(true);
      self.freesp.gameObject:SetActive(true);
   else
      self.mianfzhuan.gameObject:SetActive(false);
      self.freesp.gameObject:SetActive(false);
   end
end

function tjz_BtnPanel.titleInit(args)
   if tjz_Data.byFreeCnt>0 or tjz_Data.freeAllGold>0  then
      self.freesp.gameObject:SetActive(true);
   else
      self.freesp.gameObject:SetActive(false);
   end
end




function tjz_BtnPanel.showFreeTipHander(args)
    if tjz_Data.byAddFreeCnt==0 then
       return; 
    end
    tjz_PushFun.CreatShowNum(self.freeTips.transform:Find("numcont"),tjz_Data.byAddFreeCnt,"choum_",false,58,2,130,535);
    self.freeTips.gameObject:SetActive(true);
    coroutine.start(function()
        coroutine.wait(2);
        self.freeTips.gameObject:SetActive(false);
    end);
end

 
 --这是event里面传过来的
function tjz_BtnPanel.choumBtnInter(args)
  if tjz_Data.byFreeCnt>0 or tjz_Data.bReturn==true or tjz_Data.isAutoGame==true then
    self.perBtn.gameObject:GetComponent("Button").interactable = false;
    self.nextBtn.gameObject:GetComponent("Button").interactable = false;
  else
     self.perBtn.gameObject:GetComponent("Button").interactable = args;
     self.nextBtn.gameObject:GetComponent("Button").interactable = args;
  end
    
end
--这是按钮改变的时候的检查
function tjz_BtnPanel.myChoumBtnInter(args)
    if tjz_Data.byFreeCnt>0 or tjz_Data.bReturn==true or tjz_Data.isAutoGame==true then
       self.nextBtn.gameObject:GetComponent("Button").interactable = false;
       self.perBtn.gameObject:GetComponent("Button").interactable = false;
    end
end

function tjz_BtnPanel.stopBtnHander(args)
   --self.setVisibleBtn(1);
   if tjz_Socket.isongame ==false then
        return;
   end
   if self.maxwinGoldroll.isrun ==true then
      if tjz_Data.byFreeCnt>0 or tjz_Data.freeAllGold>0 or tjz_Data.bReturn or tjz_Data.winTypeScore>0 then
       else
          self.showWinGold = 0;
       end
       self.winGoldroll.onceStop = true;
       self.maxwinGoldroll.onceStop = true;
       --self.autobtn.gameObject:GetComponent("Button").interactable = true;
   end
    self.closeStopBtnHander();
    tjz_Event.dispathEvent(tjz_Event.xiongm_show_stop_btn_click);
end


function tjz_BtnPanel.startHander(args)
  self.maxwinGoldSp.gameObject:SetActive(false);
  if tjz_Data.freeAllGold>0 then
     return; 
   end
   
   if tjz_Data.byFreeCnt>0 or tjz_Data.freeAllGold>0 or tjz_Data.bReturn or tjz_Data.winTypeScore>0 then
     -- error("_____startHander____________"..tjz_Data.winTypeScore);
   else
      self.showWinGold = 0;
      tjz_PushFun.CreatShowNum(self.WinGoldNum,0,"choum_",false,58,2,310,-142);
   end
end

function tjz_BtnPanel.onceOver(args)
--   if tjz_Data.isFreeing==false or ((tjz_Data.byFreeCnt==tjz_Data.byAddFreeCnt) and tjz_Data.byFreeCnt>0)  then
--      self.winGoldSpVisibel();
--   end
end



function tjz_BtnPanel.showWinGoldHander(args) 
   -- error("__0000__showWinGoldHander____"..self.showWinGold); 
   if  self.showWinGold >=tjz_Data.lineWinScore and tjz_Data.freeAllGold==0 and tjz_Data.byFreeCnt==0 and not tjz_Data.bReturn and tjz_Data.winTypeScore==0 then
       return;
   end
   
   self.showWinData = args.data;
   
   if tjz_Data.bReturn or tjz_Data.winTypeScore>0 or tjz_Data.byFreeCnt>0 or tjz_Data.freeAllGold>0 then
      local snum = math.max(tjz_Data.freeAllGold,tjz_Data.winTypeScore);
      if  snum > 0 then
          self.winGoldroll:setdata(self.showWinGold,snum,0.3);
          self.showWinGold = snum;
      else
         self.winGoldroll:setdata(self.showWinGold,tjz_Data.lineWinScore,0.3);
         self.showWinGold = tjz_Data.lineWinScore;
      end 
--   if tjz_Data.bReturn or tjz_Data.winTypeScore>0 then
--      self.winGoldroll:setdata(self.showWinGold,tjz_Data.winTypeScore,self.showWinData.playtimer);
--      self.showWinGold = tjz_Data.winTypeScore;
--   elseif tjz_Data.byFreeCnt>0 or tjz_Data.freeAllGold>0 then
--       self.winGoldroll:setdata(self.showWinGold,tjz_Data.freeAllGold,self.showWinData.playtimer);
--       self.showWinGold = tjz_Data.freeAllGold;
   else
      self.winGoldroll:setdata(self.showWinGold,tjz_Data.lineWinScore,0.3);
      self.showWinGold = tjz_Data.lineWinScore;
   end
   if tjz_Data.lineWinScore>0 then
      self.maxwinGoldroll:setdata(0,tjz_Data.lineWinScore,0.3);
      self.maxwinGoldSp.gameObject:SetActive(true);
      tjz_Socket.playaudio("normalwin",false,false);
   end
--   if self.showWinData.anima~=nil and tjz_Data.allOpenRate>100 then
--      --self.showWinData.anima.main.loop = true;
--      local m =self.showWinData.anima.main;
--      m.loop = true;
--      self.showWinData.anima:Play();
--      if tjz_Data.byFreeCnt>0 then
--         MusicManager:PlayBacksound("end",false);
--      end
--      --self.freesp.gameObject:SetActive(false);
--      if tjz_Data.isfull==false then
--         tjz_Socket.playaudio("maxwin",false,false);
--      end
--   else
--       tjz_Socket.playaudio("normalwin",false,false);
--   end
  
end

function tjz_BtnPanel.winGoldSpVisibel(args)
--   if tjz_Data.isshowmygold == false then
--       tjz_Data.isshowmygold = true;
--       tjz_Event.dispathEvent(tjz_Event.xiongm_gold_chang,true);
--    end
--    if not IsNil(tjz_Data.saveSound) then
--       destroy(tjz_Data.saveSound);
--       tjz_Data.saveSound = nil;
--    end
end

function tjz_BtnPanel.perBtnHander(args)
  if tjz_Socket.isongame ==false then
        return;
   end
  if tjz_Data.byFreeCnt>0 then
     return;
  end
  if tjz_Data.bReturn then
     return;
  end
   tjz_Socket.playaudio("xiaz");
  self.curChoumIndex = self.curChoumIndex -1;
  if self.curChoumIndex<=0 then
     self.curChoumIndex = #tjz_Data.choumtable;
  end
  self.showChoumValue();
end

function tjz_BtnPanel.nextBtnHander(args)
  if tjz_Socket.isongame ==false then
        return;
   end
  if tjz_Data.byFreeCnt>0 then
     return;
  end
  if tjz_Data.bReturn then
     return;
  end
   tjz_Socket.playaudio("xiaz");
  self.curChoumIndex = self.curChoumIndex +1;
  if self.curChoumIndex>#tjz_Data.choumtable then
     self.curChoumIndex = 1;
  end
  self.showChoumValue();


end

function tjz_BtnPanel.showChoumValue(args)
   tjz_Data.curSelectChoum = tjz_Data.choumtable[self.curChoumIndex];
   self.choumtxt.gameObject:GetComponent("Text").text = "("..tjz_CMD.D_LINE_COUNT.."lines × "..tjz_Data.curSelectChoum..")";
   tjz_PushFun.CreatShowNum(self.chouNum,tjz_Data.curSelectChoum*tjz_CMD.D_LINE_COUNT,"choum_",false,18,2,156,-577);
   tjz_PushFun.CreatShowNum(self.WinGoldNum,0,"choum_",false,58,2,310,-142);
   tjz_Event.dispathEvent(tjz_Event.xiongm_choum_chang);
   self.caijinChang();
   --tjz_PushFun.CreatShowNum(self.chouNum,tjz_Data.curSelectChoum,"choum_",false,18,2,136,51);
   --tjz_PushFun.CreatShowNum(self.allPushNum,tjz_Data.curSelectChoum*tjz_CMD.D_LINE_COUNT,"choum_",false,18,2,230,-384);
end

function tjz_BtnPanel.startBtnInter(args)
   self.autobtn.gameObject:GetComponent("Button").interactable = args.data;
   self.choumBtnInter(args.data);
end

function tjz_BtnPanel.showStartBtn(args)
   self.setVisibleBtn(1);
   self.autobtn.gameObject:GetComponent("Button").interactable = true;
end

function tjz_BtnPanel.showLiehuo(args)
   --self.setVisibleBtn(4);
end

function tjz_BtnPanel.showNoStartBtnHander(args)
   self.setVisibleBtn(2);
end
function tjz_BtnPanel.freeNumChang(args)
  tjz_PushFun.CreatShowNum(self.freeNumCont,math.max(0,tjz_Data.byFreeCnt-1),"free_",false,39,2,140,-147);
end

function tjz_BtnPanel.showFreeBtn(args)
  tjz_PushFun.CreatShowNum(self.freeNumCont,math.max(0,tjz_Data.byFreeCnt),"free_",false,39,2,140,-147);
end

function tjz_BtnPanel.gameInit(args)
   local len = #tjz_Data.choumtable;
   for i=1,len do
       if tjz_Data.curSelectChoum==tjz_Data.choumtable[i] then
          self.curChoumIndex = i;
          break;
       end
   end
   local mindex = 0;
   local len = #tjz_Data.choumtable;
   for i=1,len do
       if tjz_Data.curSelectChoum == tjz_Data.choumtable[i] then
           mindex = i;
       end
   end
   self.per.transform:Find("loading").gameObject:SetActive(false);
    tjz_PushFun.CreatShowNum(self.caijinnum,math.ceil(tjz_Data.i64AccuPool*(mindex*0.2)),"cai_jin_",false,58,2,400,-490);
   self.choumtxt.gameObject:GetComponent("Text").text =  "("..tjz_CMD.D_LINE_COUNT.."线 × "..tjz_Data.curSelectChoum..")";
   tjz_PushFun.CreatShowNum(self.myGoldNum,tjz_Data.myinfoData._7wGold,"choum_",false,22,2,280,-109);
   tjz_PushFun.CreatShowNum(self.chouNum,tjz_Data.curSelectChoum*tjz_CMD.D_LINE_COUNT,"choum_",false,18,2,156,-577);
   --tjz_PushFun.CreatShowNum(self.chouNum,tjz_Data.curSelectChoum,"choum_",false,18,2,136,51);
   --tjz_PushFun.CreatShowNum(self.allPushNum,tjz_Data.curSelectChoum*tjz_CMD.D_LINE_COUNT,"choum_",false,18,2,230,-384);

end

function tjz_BtnPanel.goldChang(args)
   if tjz_Data.isshowmygold == true then
      tjz_PushFun.CreatShowNum(self.myGoldNum,tjz_Data.myinfoData._7wGold,"choum_",false,22,2,280,-109);
      if args.data==true then
         self.getgoldanima:Play();
      end
   end
end

function tjz_BtnPanel.noStartBtnHander(args)
   if tjz_Socket.isongame ==false then
        return;
   end
   tjz_Socket.playaudio("click")
   tjz_Data.isAutoGame = false;
   self.stopautobtnnum.gameObject:SetActive(false);
   self.setVisibleBtn(1);
end

function tjz_BtnPanel.Update()
  if self.isCountAutoTimer == true then
     if self.countAutoTimer>1 then
        self.isCountAutoTimer = false;
        self.countAutoTimer = 0;
        --self.autobtn.gameObject:SetActive(false);
--        tjz_Data.isAutoGame = true;
--        self.setVisibleBtn(2); 
--        tjz_Socket.gameOneOver(true); 
        self.selectnumcont.gameObject:SetActive(true);  
     else
       self.countAutoTimer = self.countAutoTimer+Time.deltaTime;
     end
  end
end

function tjz_BtnPanel.autoBtnHander(args)
   
   if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then
   else
       return
   end
   if GameManager.IsStopGame then
      return 
   end

     if self.autoClick == true or  tjz_Socket.isongame ==false  or self.selectnumcont.gameObject.activeSelf==true then
       --error("___autoBtnHander______");
        return;
     end
     if self.isongame ==false or tjz_Data.isResCom~=2 then
       return;
    end 
    if toInt64(tjz_Data.curSelectChoum*tjz_CMD.D_LINE_COUNT)>toInt64(tjz_Data.myinfoData._7wGold) then
       tjz_Socket.ShowMessageBox("金币不够",1,nil);
       return;
    end

    error("点击开始")
    tjz_Data.isshowmygold = true
    tjz_Data.myinfoData._7wGold=tjz_Data.myinfoData._7wGold-(tjz_Data.curSelectChoum*tjz_CMD.D_LINE_COUNT)
    tjz_Event.dispathEvent(tjz_Event.xiongm_gold_chang,true);

     self.autoClick = true;
     tjz_Event.dispathEvent(tjz_Event.xiongm_start_btn_click);
     coroutine.start( function(args)
         self.startBtnInter({data=false});
         tjz_Socket.playaudio("click");     
         tjz_Socket.isReqDataIng = false;
         tjz_Socket.reqStart();
          coroutine.wait(1);
          self.autoClick = false;
      end
     );
     
end

function tjz_BtnPanel.closeAutoBtnHander(args)
   self.autobtn.gameObject:SetActive(true);
   tjz_Data.isAutoGame = false;    
end
