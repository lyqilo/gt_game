longhudou_BtnPanel = {};
local self = longhudou_BtnPanel;



function longhudou_BtnPanel.init()
    self.per = nil;
    self.autobtn = nil;
    self.countAutoTimer = 0;
    self.isCountAutoTimer = false;
    self.autoandstartcont = nil;
    self.myGoldNum = nil;
    self.chouNum = nil;
    self.choumtxt = nil;

    self.freesp = nil;
    self.freeNumCont = nil;

    self.noStartBtn = nil;--手动按钮
    self.stopBtn = nil;--停止按钮
    self.stopautobtnnum = nil;
    self.selectnumcont = nil;
    self.guikey = "cn";

    self.curChoumIndex = 1;
    self.perBtn = nil;
    self.nextBtn = nil;

    self.winGoldSp = nil;
    self.WinGoldNum = nil;
    self.showWinGold = 0;
    self.showWinData = nil;
    self.selfGameIndex = 0;

    self.winGoldroll = nil;

    self.freeTips = nil;

    self.autoClick = false;--开始按钮是不是点击
    self.getgoldanima = nil;
    self.caijinNum = nil;

    self.mianfzhuan = nil;
end

function longhudou_BtnPanel.setPer(args)
   Event.AddListener(PanelListModeEven._020LevelUpChangeGoldTicket,self.LevelUpGoldChange)
   self.init();
   self.per = args;
   self.guikey = longhudou_Event.guid();
   self.autobtn = self.per.transform:Find("startbtn"); 
   self.Autostartbtn = self.per.transform:Find("Autostartbtn"); 

   self.myGoldNum = self.per.transform:Find("mygoldcont/mygoldnumcont"); 
   self.chouNum = self.per.transform:Find("choumcont/choumnumcont"); 
   self.choumtxt = self.per.transform:Find("choumcont/choumtxt"); 
   self.choumtnum = self.per.transform:Find("choumcont/choumtnum"); 

   self.perBtn = self.per.transform:Find("choumcont/perbtn"); 
   self.nextBtn = self.per.transform:Find("choumcont/nextbtn"); 
   self.freeTips = self.per.transform:Find("tsmodets/freetips"); 
   
   self.winGoldSp = self.per.transform:Find("wingoldcont");
   self.WinGoldNum = self.per.transform:Find("wingoldcont/numcont");
    
   self.freesp = self.per.transform:Find("freeicon");
   self.freeNumCont = self.per.transform:Find("freeicon/numcont");
   --self.gametitle = self.per.transform:Find("title");

   self.caijinNum = self.per.transform:Find("caijingcont/numcont");

   self.closestartbtncont=self.per.transform:Find("closestartbtncont")
   self.noStartBtn = self.per.transform:Find("closestartbtncont/nostartbtn");--手动按钮
   self.stopautobtnnum = self.per.transform:Find("closestartbtncont/numtxt").gameObject;
   self.stopbg=self.per.transform:Find("closestartbtncont/bg1").gameObject;

   self.selectnumcont = self.per.transform:Find("selectnumcont").gameObject;
   self.stopBtn = self.per.transform:Find("stopbtn");--停止按钮
   self.mianfzhuan = self.per.transform:Find("mianfzhuan");--免费转状态

   self.noStartBtn.gameObject:SetActive(false);
   self.stopBtn.gameObject:SetActive(false);
   self.freeTips.gameObject:SetActive(false);
   self.mianfzhuan.gameObject:SetActive(false);
   self.selectnumcont.gameObject:SetActive(false);  
   self.stopautobtnnum.gameObject:SetActive(false);
   self.stopbg:SetActive(false)



   self.winGoldroll = longhudou_NumRolling:New();
   self.winGoldroll:setfun(self,self.winGoldRollCom,self.winGoldRollIng);
   table.insert(longhudou_Data.numrollingcont,#longhudou_Data.numrollingcont+1,self.winGoldroll);

    
   self.addEvent();
    local eventTrigger=Util.AddComponent("EventTriggerListener",self.autobtn.gameObject);
    eventTrigger.onDown = self.autoStartDown;
    eventTrigger.onUp  = self.autoStartUp;
    longhudou_PushFun.CreatShowNum(self.WinGoldNum,0);

    self.getgoldanima = self.per.transform:Find("mygoldcont/getgoldanima").gameObject:AddComponent(typeof(ImageAnima));
--     for i=1,5 do
--       self.getgoldanima:AddSprite(longhudou_Data.icon_res.transform:Find("mygold_chang_"..1):GetComponent('Image').sprite);
--       self.getgoldanima:AddSprite(longhudou_Data.icon_res.transform:Find("mygold_chang_"..2):GetComponent('Image').sprite);
--    end
--    self.getgoldanima.fSep = 0.1;
end

function longhudou_BtnPanel.LevelUpGoldChange(gold,allGold)
   logYellow("升级获得金币:"..gold)
   logYellow("全部的金币:"..allGold)
   logYellow("本次获得的金币:"..longhudou_Data.lineWinScore)

   self.UpLevelGolaChang(-(longhudou_Data.lineWinScore),allGold)
end

function longhudou_BtnPanel.loadResCom(args)
   if self.getgoldanima==nil then
      return;
   end
    for i=1,5 do
       self.getgoldanima:AddSprite(longhudou_Data.icon_res.transform:Find("mygold_chang_"..1):GetComponent('Image').sprite);
       self.getgoldanima:AddSprite(longhudou_Data.icon_res.transform:Find("mygold_chang_"..2):GetComponent('Image').sprite);
    end
    self.getgoldanima.fSep = 0.1;
end

function longhudou_BtnPanel.showTitileMode(args)
   if longhudou_Data.byFreeCnt>0 or longhudou_Data.freeAllGold>0 then
      self.freesp.gameObject:SetActive(true); 
      if longhudou_Data.autoRunNum>0 then
         self.closestartbtncont.gameObject:SetActive(false);   
      end
   else
      self.freesp.gameObject:SetActive(false); 
      if longhudou_Data.autoRunNum>0 then
         self.closestartbtncont.gameObject:SetActive(true);   
      end
   end
end

function longhudou_BtnPanel.winGoldRollIng(obj,args)
   longhudou_PushFun.CreatShowNum(self.WinGoldNum,args);
end

function longhudou_BtnPanel.winGoldRollCom(obj,args)
   if not IsNil(longhudou_Data.saveSound) then
      destroy(longhudou_Data.saveSound);
   end
   longhudou_Socket.stopallaudio();
   if self.showWinData.anima~=nil then
     -- self.showWinData.anima.loop = false;
      local m =self.showWinData.anima.main;
      m.loop = false;
      --self.showWinData.anima:Play();
   end
   if self.showWinData.iscom==true then
      longhudou_PushFun.CreatShowNum(self.WinGoldNum,longhudou_Data.lineWinScore);
      self.winGoldSpVisibel();      
    else
      longhudou_PushFun.CreatShowNum(self.WinGoldNum,args);
   end
   self.closeStopBtnHander();
--   if longhudou_Data.isPalyFreeAnima==true then
--      longhudou_LianLine.freeAnima();
--      return;
--   end
--   if longhudou_Data.byFreeCnt>0 or longhudou_Data.freeAllGold>0 or longhudou_Data.isAutoGame==true then
--      --error("___freeAllGold__");
--      longhudou_Socket.gameOneOver2(false);
--    else
--      longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_start_btn,nil);
--      longhudou_Event.dispathEvent(longhudou_Event.xiongm_start_btn_no_inter,true);
--   end
     longhudou_Event.dispathEvent(longhudou_Event.xiongm_normal_roll_com,nil);
end

--根据一些状态隐藏界面 1 开始 2 手动 3 停止 4 烈火 5免费 
function longhudou_BtnPanel.setVisibleBtn(args)
    --self.autobtn.gameObject:SetActive(false);
    self.autobtn.transform:GetComponent("Button").enabled=false
    self.noStartBtn.gameObject:SetActive(false);
    self.stopautobtnnum.gameObject:SetActive(false);
    self.stopbg:SetActive(false)

    if args==1 then
       if longhudou_Data.isAutoGame==false then
          --self.autobtn.gameObject:SetActive(true);
          self.autobtn.transform:GetComponent("Button").enabled=true
       else
           self.noStartBtn.gameObject:SetActive(true);
           self.stopautobtnnum.gameObject:SetActive(true);
           self.stopbg:SetActive(true)
       end
    elseif args==2 then
       self.myChoumBtnInter(false);
       self.noStartBtn.gameObject:SetActive(true);
       self.stopautobtnnum.gameObject:SetActive(true);
       self.stopbg:SetActive(true)
    end
end

function longhudou_BtnPanel.modeBtnState()
   if longhudou_Data.byFreeCnt>0 or longhudou_Data.freeAllGold>0 then
      self.mianfzhuan.gameObject:SetActive(true);
   else
      self.mianfzhuan.gameObject:SetActive(false);
   end
   
end

function longhudou_BtnPanel.autoStartBtn(args)
   self.selectnumcont.gameObject:SetActive(true); 
   self.noStartBtn.gameObject:SetActive(true);
end

function longhudou_BtnPanel.autoStartDown(args)
   self.isCountAutoTimer = true;
end

function longhudou_BtnPanel.autoStartUp(args)
   if self.isCountAutoTimer== true and self.autobtn.gameObject:GetComponent("Button").interactable then
      self.autoBtnHander();
   end
   self.isCountAutoTimer = false;--是不是记录 自动按钮按下的时间
   self.countAutoTimer = 0;--按钮按下的时间
end

function longhudou_BtnPanel.closeSelectRunNun(args)
   self.stopautobtnnum.gameObject:GetComponent("TextMeshProUGUI").text ="";
   self.selectnumcont.gameObject:SetActive(false);  
   --longhudou_LianLine.IsStartGame=true;
   
   self.autobtn.gameObject:GetComponent("Button").interactable = true;
   self.noStartBtn.gameObject:SetActive(false);

end



function longhudou_BtnPanel.selectRunNunHander(args)
   -- if longhudou_Socket.isOver then
   --    longhudou_LianLine.IsStartGame=true
   -- end  

   -- if longhudou_LianLine.IsStartGame then
   -- else
   --    return
   -- end
   local str = args.transform.parent.name;
   local str1 = string.split(str, "_");
   error("________selectRunNunHander______"..str);
   error("________selectRunNunHander______"..str1[2]);
   self.noStartBtn.gameObject:SetActive(true);
   longhudou_Data.isAutoGame = true;

   longhudou_Socket.gameOneOver(true);
   --longhudou_LianLine.IsStartGame=false;
   self.stopautobtnnum.gameObject:GetComponent("TextMeshProUGUI").text = " ";
   self.selectnumcont.gameObject:SetActive(false); 

   self.setVisibleBtn(2); 
   local datanum = {10,20,50,10000000};
   longhudou_Data.autoRunNum = datanum[tonumber(str1[2])];
   self.stopautobtnnum.gameObject:SetActive(true);
   self.stopbg:SetActive(true)
end

function longhudou_BtnPanel.gameOver(args)
  if longhudou_Data.autoRunNum<1 and longhudou_Data.isAutoGame==true then
     self.noStartBtnHander();
     self.stopautobtnnum.gameObject:SetActive(false);
  else
     local str = longhudou_Data.autoRunNum;
     if longhudou_Data.autoRunNum>1000 then
        str = "l";
     end
      longhudou_PushFun.CreatShowNum(self.stopautobtnnum,str);
  end
end

function longhudou_BtnPanel.addEvent()
   longhudou_Data.luabe:AddClick(self.Autostartbtn.gameObject,self.autoStartBtn);

   longhudou_Data.luabe:AddClick(self.noStartBtn.gameObject,self.noStartBtnHander);
   longhudou_Data.luabe:AddClick(self.stopBtn.gameObject,self.stopBtnHander);


   longhudou_Data.luabe:AddClick(self.perBtn.gameObject,self.perBtnHander);
   longhudou_Data.luabe:AddClick(self.nextBtn.gameObject,self.nextBtnHander);

   longhudou_Event.addEvent(longhudou_Event.xiongm_init,self.gameInit,self.guikey);
   longhudou_Event.addEvent(longhudou_Event.xiongm_show_start_btn,self.showStartBtn,self.guikey);
   longhudou_Event.addEvent(longhudou_Event.xiongm_start_btn_no_inter,self.startBtnInter,self.guikey);
   longhudou_Event.addEvent(longhudou_Event.xiongm_show_free_btn,self.showFreeBtn,self.guikey);
   longhudou_Event.addEvent(longhudou_Event.xiongm_show_free_num_chang,self.freeNumChang,self.guikey);
   --longhudou_Event.addEvent(longhudou_Event.xiongm_lihuo_bg_anima,self.showLiehuo,self.guikey);
   longhudou_Event.addEvent(longhudou_Event.xiongm_gold_chang,self.goldChang,self.guikey); 
   longhudou_Event.addEvent(longhudou_Event.xiongm_show_no_start_btn,self.showNoStartBtnHander,self.guikey); 
   --error("__111__add_");
   longhudou_Event.addEvent(longhudou_Event.xiongm_show_stop_btn,self.showStopBtnHander,self.guikey);
   longhudou_Event.addEvent(longhudou_Event.xiongm_close_stop_btn,self.closeStopBtnHander,self.guikey); 
     -- error("__22__add_");
   longhudou_Event.addEvent(longhudou_Event.xiongm_show_win_gold,self.showWinGoldHander,self.guikey);   
   longhudou_Event.addEvent(longhudou_Event.xiongm_start,self.startHander,self.guikey);   
   longhudou_Event.addEvent(longhudou_Event.game_once_over,self.onceOver,self.guikey);  
   longhudou_Event.addEvent(longhudou_Event.xiongm_caijin_chang,self.caijinChang,self.guikey);  

   longhudou_Event.addEvent(longhudou_Event.xiongm_mianf_btn_mode,self.modeBtnState,self.guikey);   
   longhudou_Event.addEvent(longhudou_Event.xiongm_title_mode,self.showTitileMode,self.guikey);  
   
   longhudou_Event.addEvent(longhudou_Event.xiongm_load_res_com,self.loadResCom,self.guikey); 
   longhudou_Event.addEvent(longhudou_Event.xiangqi_over,longhudou_Event.hander(self,self.gameOver),self.guikey);
   longhudou_Data.luabe:AddClick(self.selectnumcont.transform:Find("closebtn").gameObject,self.closeSelectRunNun); 
   for i=1,4 do
      longhudou_Data.luabe:AddClick(self.selectnumcont.transform:Find("item_"..i.."/btn").gameObject,self.selectRunNunHander); 
   end
end

function longhudou_BtnPanel.showFreeTipHander(args)
   self.freeTips.transform:Find("numcont"):GetComponent("TextMeshProUGUI").text=RETTEXT(longhudou_Data.byFreeCnt)
    self.freeTips.gameObject:SetActive(true);
    coroutine.start(function()
        coroutine.wait(2);
        self.freeTips.gameObject:SetActive(false);
    end);
end

 
 --这是event里面传过来的
function longhudou_BtnPanel.choumBtnInter(args)
  if longhudou_Data.byFreeCnt>0 or (longhudou_Data.bFireMode==true and longhudou_Data.bFireCom==false) or longhudou_Data.isAutoGame==true then
    self.perBtn.gameObject:GetComponent("Button").interactable = false;
    self.nextBtn.gameObject:GetComponent("Button").interactable = false;
  else
     self.perBtn.gameObject:GetComponent("Button").interactable = args;
     self.nextBtn.gameObject:GetComponent("Button").interactable = args;
  end
    
end
--这是按钮改变的时候的检查
function longhudou_BtnPanel.myChoumBtnInter(args)
    if longhudou_Data.byFreeCnt>0 or (longhudou_Data.bFireMode==true and longhudou_Data.bFireCom==false) or longhudou_Data.isAutoGame==true then
       self.nextBtn.gameObject:GetComponent("Button").interactable = false;
       self.perBtn.gameObject:GetComponent("Button").interactable = false;
    end
end

function longhudou_BtnPanel.startHander(args)
  if longhudou_Data.freeAllGold>0 then
     return; 
   end
   self.showWinGold = 0;
   longhudou_PushFun.CreatShowNum(self.WinGoldNum,0);
end

local nowcaijinNum=0
function longhudou_BtnPanel.caijinChang(args)
     local mindex = 0;
     local len = #longhudou_Data.choumtable;
     for i=1,len do
         if longhudou_Data.curSelectChoum == longhudou_Data.choumtable[i] then
             mindex = i;
         end
     end
   if mindex > 0 then
      nowcaijinNum=math.ceil(longhudou_Data.caijin*(mindex*0.2))
      longhudou_PushFun.CreatShowNum(self.caijinNum,nowcaijinNum);
   end
end



function longhudou_BtnPanel.onceOver(args)
--   if longhudou_Data.byFreeCnt>0 then
--     return; 
--   end
--   longhudou_PushFun.CreatShowNum(self.WinGoldNum,0,"win_gold_",false,58,2,920,-420);
--   self.showWinGold = 0;
end



function longhudou_BtnPanel.showWinGoldHander(args)
   --error("__0000__showWinGoldHander____"..self.showWinGold); 
   --longhudou_Socket.stopallaudio();
   if  self.showWinGold >=longhudou_Data.lineWinScore  and longhudou_Data.freeAllGold==0 and longhudou_Data.byFreeCnt==0  then
       return;
   end
   --error("__111__showWinGoldHander____"..self.showWinGold); 
   self.showWinData = args.data;
   self.winGoldroll:setdata(self.showWinGold,self.showWinData.addmoney,self.showWinData.playtimer);
   if self.showWinData.anima~=nil then
      --self.showWinData.anima.loop = true;
      local m =self.showWinData.anima.main;
      m.loop = true;
      self.showWinData.anima:Play();
   end
   self.showWinGold = self.showWinData.addmoney;    
end

function longhudou_BtnPanel.winGoldSpVisibel(args) 
    if longhudou_Data.isshowmygold == false then
       longhudou_Data.isshowmygold = true;
       longhudou_Event.dispathEvent(longhudou_Event.xiongm_gold_chang,true);
    end
    if not IsNil(longhudou_Data.saveSound) then
       destroy(longhudou_Data.saveSound);
       longhudou_Data.saveSound = nil;
    end
    longhudou_Socket.stopallaudio();
end

function longhudou_BtnPanel.perBtnHander(args)
  if  longhudou_Socket.isongame ==false then
        return;
   end
  if longhudou_Data.byFreeCnt>0 then
     return;
  end
  if longhudou_Data.bFireMode==true and longhudou_Data.bFireCom==false then
     return;
  end
   longhudou_Socket.playaudio("click");
  self.curChoumIndex = self.curChoumIndex -1;
  if self.curChoumIndex<=0 then
     self.curChoumIndex = #longhudou_Data.choumtable;
  end
  self.showChoumValue();
  longhudou_Event.dispathEvent(longhudou_Event.xiongm_caijin_chang,nil);
end

function longhudou_BtnPanel.nextBtnHander(args)
  if  longhudou_Socket.isongame ==false then
        return;
   end
  if longhudou_Data.byFreeCnt>0 then
     return;
  end
  if longhudou_Data.bFireMode==true and longhudou_Data.bFireCom==false then
     return;
  end
   longhudou_Socket.playaudio("click");
  self.curChoumIndex = self.curChoumIndex +1;
  if self.curChoumIndex>#longhudou_Data.choumtable then
     self.curChoumIndex = 1;
  end
  self.showChoumValue();
  longhudou_Event.dispathEvent(longhudou_Event.xiongm_caijin_chang,nil);

end

function longhudou_BtnPanel.showChoumValue(args)   
   longhudou_Data.curSelectChoum = longhudou_Data.choumtable[self.curChoumIndex];

   local sttr=longhudou_Data.curSelectChoum
   if tonumber(longhudou_Data.curSelectChoum)>=10000 then
      sttr=longhudou_Data.curSelectChoum/10000
      sttr=sttr.."w"
   end

   local str=longhudou_Data.baseRate.."*"..sttr;
   logYellow("Str1=="..str)
   self.choumtxt.gameObject:GetComponent("TextMeshProUGUI").text = RETTEXT(str)
   self.chouNum.gameObject:GetComponent("TextMeshProUGUI").text = RETTEXT(longhudou_Data.curSelectChoum*longhudou_Data.baseRate)

   longhudou_PushFun.CreatShowNum(self.WinGoldNum,0);
   longhudou_Event.dispathEvent(longhudou_Event.xiongm_choum_chang);
end

function longhudou_BtnPanel.startBtnInter(args)
   self.autobtn.gameObject:GetComponent("Button").interactable = args.data;
   self.choumBtnInter(args.data);
end

function longhudou_BtnPanel.showStartBtn(args)
   self.setVisibleBtn(1);
   self.autobtn.gameObject:GetComponent("Button").interactable = true;
end

function longhudou_BtnPanel.showLiehuo(args)
end

function longhudou_BtnPanel.showNoStartBtnHander(args)
   self.setVisibleBtn(2);
end

function longhudou_BtnPanel.showStopBtnHander(args)
   --error("________showStopBtnHander_________");
   self.stopBtn.gameObject:SetActive(true);
end

function longhudou_BtnPanel.closeStopBtnHander(args)
   --error("________showStopBtnHander_________");
   self.stopBtn.gameObject:SetActive(false);
end

function longhudou_BtnPanel.freeNumChang(args)
   self.freeNumCont:GetComponent("TextMeshProUGUI").text =RETTEXT(longhudou_Data.byFreeCnt)
end

function longhudou_BtnPanel.showFreeBtn(args)
   self.freeNumCont:GetComponent("TextMeshProUGUI").text =RETTEXT(longhudou_Data.byFreeCnt)
end

function longhudou_BtnPanel.gameInit(args)
   local len = #longhudou_Data.choumtable;
   for i=1,len do
       if longhudou_Data.curSelectChoum==longhudou_Data.choumtable[i] then
          self.curChoumIndex = i;
          break;
       end
   end   

   self.myGoldNum.gameObject:GetComponent("TextMeshProUGUI").text = RETTEXT(longhudou_Data.myinfoData._7wGold)

   local sttr=longhudou_Data.curSelectChoum
   if tonumber(longhudou_Data.curSelectChoum)>=10000 then
      sttr=longhudou_Data.curSelectChoum/10000
      sttr=sttr.."w"
   end
   local str=longhudou_Data.baseRate.."*"..sttr;
   logYellow("Str1=="..str)
   self.choumtxt.gameObject:GetComponent("TextMeshProUGUI").text = RETTEXT(str)
   self.chouNum.gameObject:GetComponent("TextMeshProUGUI").text = RETTEXT(longhudou_Data.curSelectChoum*longhudou_Data.baseRate)
end

function longhudou_BtnPanel.goldChang(args)
   if longhudou_Data.isshowmygold == true then
      self.myGoldNum.gameObject:GetComponent("TextMeshProUGUI").text = RETTEXT(longhudou_Data.myinfoData._7wGold)
      if args.data==true then
         --self.getgoldanima:Play();
      end
   end
end

function longhudou_BtnPanel.UpLevelGolaChang(gold,allGold)
   self.myGoldNum.gameObject:GetComponent("TextMeshProUGUI").text = RETTEXT(allGold+gold)
   TableUserInfo._7wGold=allGold
   logYellow("游戏内显示金币2=="..TableUserInfo._7wGold)
end

function longhudou_BtnPanel.noStartBtnHander(args)
   if  longhudou_Socket.isongame ==false then
        return;
   end
   longhudou_Socket.playaudio("click")
   longhudou_Data.isAutoGame = false;
   self.setVisibleBtn(1);
   -- if longhudou_Socket.isOver then
   --    longhudou_LianLine.IsStartGame=true
   -- end   
end

function longhudou_BtnPanel.stopBtnHander(args)
   if  longhudou_Socket.isongame ==false then
        return;
   end
   longhudou_Socket.playaudio("click")
   --self.setVisibleBtn(1);
   self.showWinGold = longhudou_Data.lineWinScore;
   self.winGoldroll.onceStop = true;
   self.closeStopBtnHander();
   --self.autobtn.gameObject:GetComponent("Button").interactable = true;
   longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_stop_btn_click);
end

function longhudou_BtnPanel.Update()
  if self.isCountAutoTimer == true then
     if self.countAutoTimer>1 then
        self.isCountAutoTimer = false;
        self.countAutoTimer = 0;
--        self.autobtn.gameObject:SetActive(false);
--        longhudou_Data.isAutoGame = true;
--        self.setVisibleBtn(2); 
        --longhudou_Socket.gameOneOver(true); 
         --self.autobtn.gameObject:GetComponent("Button").interactable = false;
     else
       self.countAutoTimer = self.countAutoTimer+Time.deltaTime;
     end
  end
end

function longhudou_BtnPanel.autoBtnHander(args)
   -- if longhudou_Socket.isOver then
   --    longhudou_LianLine.IsStartGame=true
   -- end  
   -- logYellow("autoBtnHander=="..tostring(longhudou_LianLine.IsStartGame))
   -- if longhudou_LianLine.IsStartGame then
   -- else
   --    return;
   -- end
   -- longhudou_LianLine.IsStartGame=false;
   
   if self.autoClick == true or  longhudou_Socket.isongame ==false or self.selectnumcont.gameObject.activeSelf==true then
      return;
   end
      if self.isongame ==false or longhudou_Data.isResCom~=2 then
       return;
    end
      if toInt64(longhudou_Data.curSelectChoum*longhudou_Data.baseRate)>toInt64(longhudou_Data.myinfoData._7wGold) then
       longhudou_Socket.ShowMessageBox("金币不够",1,nil);
       return;
    end
     self.autoClick = true;

     longhudou_Event.dispathEvent(longhudou_Event.xiongm_start_btn_click);
     coroutine.start( function(args)
         self.startBtnInter({data=false});
         longhudou_Socket.playaudio("click");     
         longhudou_Socket.isReqDataIng = false;
         longhudou_Socket.reqStart();
          coroutine.wait(1);
          self.autoClick = false;
      end
     );
     
end

function longhudou_BtnPanel.closeAutoBtnHander(args)
   --self.autobtn.gameObject:SetActive(true);
   self.autobtn.transform:GetComponent("Button").enabled=true

   longhudou_Data.isAutoGame = false;    
end
