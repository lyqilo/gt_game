longhudou_LianLine = {};
local self = longhudou_LianLine;
self.IsStartGame=false;

function longhudou_LianLine.setPer(args)
   self.gameExit();
   self.guikey = longhudou_Event.guid();
   self.per = args;
   self.goodLuckSp = args.transform:Find("bottomcont/tswints");
   self.tsmodetsSp = args.transform:Find("bottomcont/tsmodets");
   local freeicon = args.transform:Find("bottomcont/freeicon");
   self.allfreegoldcont = args.transform:Find("bottomcont/allfreegoldcont");
   self.wincaijingoldcont = args.transform:Find("bottomcont/wincaijingoldcont");
   self.tsRunKuang = args.transform:Find("tsrun/shandongkuang");

   --self.lizi =  args.transform:Find("lizi");
  -- self.zhipai_mianfeicishu =  args.transform:Find("zhipai_mianfeicishu");

   --self.lizi.gameObject:SetActive(false);
   --self.zhipai_mianfeicishu.gameObject:SetActive(false);
   self.allfreegoldcont:Find("jinbi_dajiang").localScale=Vector3.New(0.6,0.6,0.6)
   self.wincaijingoldcont:Find("jinbi_dajiang").localScale=Vector3.New(0.6,0.6,0.6)
   args.transform:Find("bottomcont/zhipai_jinbi"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")


   self.goodLuckSp.gameObject:SetActive(false);
   self.tsmodetsSp.gameObject:SetActive(false);
   freeicon.gameObject:SetActive(false);
   self.tsmodetsSp.transform:Find("wulian").gameObject:SetActive(false);
   self.tsmodetsSp.transform:Find("freetips").gameObject:SetActive(false);
   self.allfreegoldcont.gameObject:SetActive(false);
   self.wincaijingoldcont.gameObject:SetActive(false);
   self.addEvent();

   self.goodLuckGoldroll = longhudou_NumRolling:New();
   self.goodLuckGoldroll:setfun(self,self.goodLuckGoldRollCom,self.goodLuckGoldRollIng);
   table.insert(longhudou_Data.numrollingcont,#longhudou_Data.numrollingcont+1,self.goodLuckGoldroll);

   self.freeAllGoldroll = longhudou_NumRolling:New();
   self.freeAllGoldroll:setfun(self,self.freeAllGoldRollCom,self.freeAllGoldRollIng);
   table.insert(longhudou_Data.numrollingcont,#longhudou_Data.numrollingcont+1,self.freeAllGoldroll);

   self.winCaiJinGoldroll = longhudou_NumRolling:New();
   self.winCaiJinGoldroll:setfun(self,self.winCaiJinGoldrollCom,self.winCaiJinGoldrollIng);
   table.insert(longhudou_Data.numrollingcont,#longhudou_Data.numrollingcont+1,self.winCaiJinGoldroll);

   --self.goldanima = args.transform:Find("bottomcont/zhipai_jinbi"):GetComponent("ParticleSystem");
   self.goldanima =nil;
  
end

function longhudou_LianLine.goodLuckGoldRollIng(obj,args)
    longhudou_PushFun.CreatShowNum(self.goodLuckSp.transform:Find("numcont"),args,"max_win_gold_",false,69,2,770,-368);
end

function longhudou_LianLine.goodLuckGoldRollCom(obj,args)
   logYellow("金币结算显示结束")
   self.IsStartGame=true
   longhudou_PushFun.CreatShowNum(self.goodLuckSp.transform:Find("numcont"),args,"max_win_gold_",false,69,2,770,-368);
end

function longhudou_LianLine.winCaiJinGoldrollIng(obj,args)
    longhudou_PushFun.CreatShowNum(self.wincaijingoldcont.transform:Find("numcont"),args,"max_win_gold_",false,65,2,750,-350);
end

function longhudou_LianLine.winCaiJinGoldrollCom(obj,args)

    longhudou_PushFun.CreatShowNum(self.wincaijingoldcont.transform:Find("numcont"),args,"max_win_gold_",false,65,2,750,-350);
    longhudou_Socket.stopallaudio();
    coroutine.start(function(args)
       coroutine.wait(2);
       self.wincaijingoldcont.gameObject:SetActive(false);
       longhudou_Event.dispathEvent(longhudou_Event.xiongm_close_stop_btn);
       longhudou_Event.dispathEvent(longhudou_Event.xiongm_win_caijin_roll_com);
    end);
end

function longhudou_LianLine.freeAllGoldRollIng(obj,args)
    longhudou_PushFun.CreatShowNum(self.allfreegoldcont.transform:Find("numcont"),args,"max_win_gold_",false,65,2,750,-350);
end

function longhudou_LianLine.freeAllGoldRollCom(obj,args)
   
    longhudou_PushFun.CreatShowNum(self.allfreegoldcont.transform:Find("numcont"),args,"max_win_gold_",false,65,2,750,-350);   
    --self.goldanima.loop = false;
    --local m =self.goldanima.main;
    --m.loop = false;
    --error("_______freeAllGoldRollCom____");
    longhudou_Data.freeAllGold = 0;
    longhudou_Data.isshowmygold = true;
    longhudou_Event.dispathEvent(longhudou_Event.xiongm_gold_chang,true);
    longhudou_Socket.stopallaudio();
    coroutine.start(function(args)
       coroutine.wait(2);
        self.allfreegoldcont.gameObject:SetActive(false);
        --self.allfreegoldcont.transform:Find("leftanima").gameObject:GetComponent("ImageAnima"):Stop();
        --self.allfreegoldcont.transform:Find("rightanima").gameObject:GetComponent("ImageAnima"):Stop();
       longhudou_Event.dispathEvent(longhudou_Event.xiongm_close_stop_btn);

       longhudou_Socket.gameOneOver2(false); 
    end);
end

function longhudou_LianLine.gameExit(args)
    self.per =   nil;
    self.guikey = "cn";
    self.allfreegoldcont = nil;
    self.wincaijingoldcont = nil;
    self.goodLuckSp = nil;
    self.tsmodetsSp = nil;
    self.goldanima = nil;
    self.goodLuckGoldroll = nil;
    self.isShowGoodLuck = false;
    self.tsRunKuang = nil;

    --self.lizi = nil;
    --self.zhipai_mianfeicishu = nil;
    
end

function longhudou_LianLine.addEvent()
     longhudou_Event.addEvent(longhudou_Event.xiongm_run_com,self.runCom,self.guikey);
     longhudou_Event.addEvent(longhudou_Event.xiongm_start,self.gameStart,self.guikey);
     longhudou_Event.addEvent(longhudou_Event.game_once_over,self.onceOver,self.guikey); 
     longhudou_Event.addEvent(longhudou_Event.xiongm_show_free_all_gold,self.showFreeAllGold,self.guikey);
     longhudou_Event.addEvent(longhudou_Event.xiongm_show_stop_btn_click,self.stopBtnCLick,self.guikey);
     longhudou_Event.addEvent(longhudou_Event.xiongm_normal_roll_com,self.normalGoldRollCom,self.guikey);
     longhudou_Event.addEvent(longhudou_Event.xiongm_win_caijin_roll_com,self.winCaiJinRollCom,self.guikey);
end

--function longhudou_LianLine.gameGoldRollCom(args)
--   self.sendGameOver();
--end

--function longhudou_LianLine.sendGameOver()
--   longhudou_Socket.gameOneOver(false);
--end

function longhudou_LianLine.gameStart(args)
   self.goodLuckSp.gameObject:SetActive(false);
    self.closeGoodLuckItem();
end

function longhudou_LianLine.onceOver(args)
end

function longhudou_LianLine.doRunCom()
   local isfive = false;
    local len = #longhudou_Data.openWinImg;
    for i=1,len do
        if longhudou_Data.openWinImg[i].byKey==5 then
            isfive = true;
            break;
        end
    end
    if longhudou_Data.isPalyFreeAnima==true then
        coroutine.start(function(args)
            longhudou_Socket.playaudio("freewait",false,false,false)
            coroutine.wait(1);
            if isfive == true then
                self.fiveAnima();
            else
                self.ShowLine();
            end
        end);
        return;
    end 
    if isfive == true then
        self.fiveAnima();
        return;
    end
    self.ShowLine();
end
function longhudou_LianLine.runCom(args) 
    if args.data == 5 then
        self.tsRunKuang.gameObject:SetActive(false);
        local isfreewild = longhudou_Data.isFreeGameWild();
        if isfreewild==true then
           coroutine.start(function()
              coroutine.wait(1);
              if longhudou_Socket.isongame == false then
                 return;
              end
              error("______0______doRunCom____________");
              longhudou_Event.dispathEvent(longhudou_Event.xiangqi_two_reflush_over);
              coroutine.wait(0.5);
              if longhudou_Socket.isongame == false then
                 return;
              end
              self.doRunCom();
           end);
        else
             error("______1______doRunCom____________");
            self.doRunCom();
        end
    elseif longhudou_Data.lockColIndex>0 and  args.data == longhudou_Data.lockColIndex then
       longhudou_Data.lockColIndex = longhudou_Data.lockColIndex + 1;
       longhudou_Event.dispathEvent(longhudou_Event.xiangqi_over,{curindex = longhudou_Data.lockColIndex,maxtimer=12,jiantimer=0.4});

       local pos = self.per.transform:Find("runcontmask/runcont/showcont_"..longhudou_Data.lockColIndex).transform.localPosition;
       local pos2 = self.per.transform:Find("tsrun/shandongkuang").transform.localPosition
       self.per.transform:Find("tsrun/shandongkuang").transform.localPosition = Vector3.New(pos.x,pos2.y,pos2.z);
       self.tsRunKuang.gameObject:SetActive(true);
        return;
    end
end

--
function longhudou_LianLine.showFreeAllGold(args)    
   --self.allfreegoldcont.transform:Find("leftanima").gameObject:GetComponent("ImageAnima"):PlayAlways();
   --self.allfreegoldcont.transform:Find("rightanima").gameObject:GetComponent("ImageAnima"):PlayAlways();
   self.allfreegoldcont.gameObject:SetActive(true);
   local t1 = math.abs(longhudou_Data.freeAllGold/(longhudou_Data.curSelectChoum*longhudou_Data.baseRunMoneyTimer*10));
   self.freeAllGoldroll:setdata(0,longhudou_Data.freeAllGold,t1);
   self.goodLuckSp.gameObject:SetActive(false);
   --self.goldanima.loop = true;
   --local m =self.goldanima.main;
    --m.loop = true;
   --self.goldanima:Play();
   longhudou_Socket.playaudio("getgold",true,true,true);
   longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_stop_btn);
end

function longhudou_LianLine.stopBtnCLick(args)
   if self.freeAllGoldroll.isrun ==true then
      --self.goldanima.loop = false;
      --local m =self.goldanima.main;
      --m.loop = false;
      longhudou_Socket.stopallaudio();
      self.freeAllGoldroll.onceStop = true;
   end
   if self.goodLuckGoldroll.isrun ==true then
      self.goodLuckGoldroll.onceStop = true;
   end
   if self.winCaiJinGoldroll.isrun ==true then
      self.winCaiJinGoldroll.onceStop = true;
   end
   
end

--播放5连动画
function longhudou_LianLine.fiveAnima(args)     
   longhudou_Socket.playaudio("five5",false,true,true);
   local item = self.tsmodetsSp.transform:Find("wulian/lianx");
   local pos = item.transform.localPosition;
   item.transform.localPosition = Vector3.New(500,pos.y,pos.z);
   self.tsmodetsSp.gameObject:SetActive(true);
   self.tsmodetsSp.transform:Find("wulian").gameObject:SetActive(true);
   local tween = item.transform:DOLocalMove(Vector3.New(pos.x,pos.y,pos.z),0.5,false);
   tween:OnComplete(function()
       coroutine.start(function(args)
            coroutine.wait(1);
             self.tsmodetsSp.transform:Find("wulian").gameObject:SetActive(false);
             self.tsmodetsSp.gameObject:SetActive(false);
             self.ShowLine();
       end) 
   end);
end
--播放免费动画
function longhudou_LianLine.freeAnima(args) 
   --self.lizi.gameObject:SetActive(true);
   --self.zhipai_mianfeicishu.gameObject:SetActive(true);

   longhudou_Socket.playaudio("freeenter",false,false,false); 
   local item = self.tsmodetsSp.transform:Find("freetips");
   local pos = item.transform.localPosition;
   item.transform.localPosition = Vector3.New(500,pos.y,pos.z);
   self.tsmodetsSp.gameObject:SetActive(true);
   item.gameObject:SetActive(true);
    longhudou_PushFun.CreatShowNum(item.transform:Find("numcont"),longhudou_Data.byFreeCnt,"freetis_",false,32,2,155,-15);
    --item.transform:Find("numcont").gameObject:GetComponent("Image").sprite =  longhudou_Data.numres.transform:Find("freetis_"..(longhudou_Data.byFreeCnt/5)).gameObject:GetComponent("Image").sprite;
    --item.transform:Find("numcont").gameObject:GetComponent("Image"):SetNativeSize();
   local tween = item.transform:DOLocalMove(Vector3.New(pos.x,pos.y,pos.z),0.5,false);
   longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_bg,1);
   tween:OnComplete(function()
       coroutine.start(function(args)
            coroutine.wait(2);           
            logYellow("播放免费动画") 
            longhudou_Socket.gameOneOver2(false);  
             item.gameObject:SetActive(false);
             self.tsmodetsSp.gameObject:SetActive(false);
       end) 
   end);
end
function longhudou_LianLine.closeGoodLuckItem()
   for i=1,3 do
       self.goodLuckSp.transform:Find("titlecont/win_"..i).gameObject:SetActive(false);
   end
   self.goodLuckSp.transform:Find("numcont").gameObject:SetActive(false);
end
--计算金币显示
function longhudou_LianLine.countGoldTimer(args)
   local t1 = math.abs(longhudou_Data.lineWinScore/(longhudou_Data.curSelectChoum*longhudou_Data.baseRunMoneyTimer));
   local t2 = math.abs(2*#longhudou_Data.openWinImg);
   local t3 = math.min(t1,t2);
   if t3<= args then
      t3 = args;
   else
      t3 = (math.floor(t3/args)+1)*args;
   end
   if longhudou_Data.byFreeCnt>0 or longhudou_Data.freeAllGold>0 then
      longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_win_gold,{addmoney=longhudou_Data.freeAllGold,iscom=false,anima=self.goldanima,playtimer=t3});
   else
      --error("______countGoldTimer_____"..longhudou_Data.lineWinScore);
      if longhudou_Data.allOpenRate>50*longhudou_Data.baseRate then
         longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_win_gold,{addmoney=longhudou_Data.lineWinScore,iscom=true,anima=self.goldanima,playtimer=t3});         
      else
         longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_win_gold,{addmoney=longhudou_Data.lineWinScore,iscom=true,anima=nil,playtimer=t3});         
      end
   end
   if self.isShowGoodLuck == true then
      self.goodLuckGoldroll:setdata(0,longhudou_Data.lineWinScore,t3);
   end
   logYellow("计算金币显示")
end
--显示线
function longhudou_LianLine.ShowLine()
  self.isShowGoodLuck = false;
  local showindex = 0;  
  local soundtimer = 0.36;
  longhudou_Socket.isReqDataIng  = false
  self.closeGoodLuckItem();
  if longhudou_Data.allOpenRate>50*longhudou_Data.baseRate then
      self.isShowGoodLuck = true;
     showindex = 3;
     longhudou_Socket.playaudio("superwin",true,true,true) 
     soundtimer = 11.179;
  elseif longhudou_Data.allOpenRate>10*longhudou_Data.baseRate then
      self.isShowGoodLuck = true;
     showindex = 2;
     longhudou_Socket.playaudio("midwin",true,true,true) 
     soundtimer = 9.135;
--  elseif longhudou_Data.allOpenRate>5*longhudou_Data.baseRate then
--     self.isShowGoodLuck = true;
--    showindex = 1; 
--    longhudou_Socket.playaudio("luckwin",true,true,true) 
--    soundtimer = 1.516; 
  elseif longhudou_Data.lineWinScore>0 then
     self.isShowGoodLuck = true;
     showindex = 3;
     longhudou_Socket.playaudio("normalwin",false,false);    
  end 
  if self.isShowGoodLuck==true then
     self.goodLuckSp.gameObject:SetActive(true);
     self.goodLuckSp.transform:Find("titlecont/win_"..showindex).gameObject:SetActive(true);
     self.goodLuckSp.transform:Find("numcont").gameObject:SetActive(true);     
  end
  self.curShowLineIndex = 0;
  local openLineData = nil;
  local len = #longhudou_Data.openWinImg; 
  if len>0 then
      if longhudou_Data.lineWinScore> 0 then
         self.countGoldTimer(soundtimer);
         longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_line_anima);
         longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_stop_btn);
      else
         longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_line_anima);
         logYellow("游戏结束2")   

         self.IsStartGame=true;
         coroutine.start(function()
            coroutine.wait(1);
            if longhudou_Socket.isongame == false then
                 return;
              end
            longhudou_Event.dispathEvent(longhudou_Event.xiongm_normal_roll_com,nil);
         end);

      end
  else
    longhudou_Event.dispathEvent(longhudou_Event.xiongm_normal_roll_com,nil); 
    self.IsStartGame=true;
  end 

end

function longhudou_LianLine.ShowTiger()
   if longhudou_Data.byFreeCnt==0 and longhudou_Data.freeAllGold>0 then
        self.showFreeAllGold();
     else
         if longhudou_Data.byFreeCnt>0 then
             longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_free_btn);
         else
             longhudou_Event.dispathEvent(longhudou_Event.xiongm_start_btn_no_inter,true);  
         end
         if longhudou_Data.isPalyFreeAnima==true then
            self.freeAnima();
           return;
        end
        longhudou_Socket.gameOneOver2(false);  
     end
end

function longhudou_LianLine.normalGoldRollCom(args)
   if longhudou_Data.winCaijin>0 then
       self.wincaijingoldcont.gameObject:SetActive(true);
       local t1 = math.abs(longhudou_Data.winCaijin/(longhudou_Data.curSelectChoum*longhudou_Data.baseRunMoneyTimer*10));
       self.winCaiJinGoldroll:setdata(0,longhudou_Data.winCaijin,t1);
       longhudou_Socket.playaudio("getgold",true,true,true);
       longhudou_Event.dispathEvent(longhudou_Event.xiongm_show_stop_btn);
   else
      longhudou_Event.dispathEvent(longhudou_Event.xiongm_win_caijin_roll_com);
   end
end

function longhudou_LianLine.winCaiJinRollCom(args)
   self.ShowTiger();
end


