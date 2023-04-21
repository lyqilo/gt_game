xiangqi_LianLine = {};
local self = xiangqi_LianLine;

function xiangqi_LianLine.setPer(args)
   self.gameExit();
   self.guikey = xiangqi_Event.guid();
   self.per = args;
   self.goodLuckSp = args.transform:Find("bottomcont/tswints");
   self.tsmodetsSp = args.transform:Find("bottomcont/tsmodets");
   local freeicon = args.transform:Find("bottomcont/freeicon");
   self.allfreegoldcont = args.transform:Find("bottomcont/allfreegoldcont");
   self.tsRunKuang = args.transform:Find("tsrun/shandongkuang");

   self.lizi =  args.transform:Find("lizi");
   self.zhipai_mianfeicishu =  args.transform:Find("zhipai_mianfeicishu");

   self.lizi.gameObject:SetActive(false);
   self.zhipai_mianfeicishu.gameObject:SetActive(false);

   self.goodLuckSp.gameObject:SetActive(false);
   self.tsmodetsSp.gameObject:SetActive(false);
   freeicon.gameObject:SetActive(false);
   self.tsmodetsSp.transform:Find("lianx").gameObject:SetActive(false);
   self.tsmodetsSp.transform:Find("freetips").gameObject:SetActive(false);
   self.allfreegoldcont.gameObject:SetActive(false);
   self.addEvent();

   self.goodLuckGoldroll = xiangqi_NumRolling:New();
   self.goodLuckGoldroll:setfun(self,self.goodLuckGoldRollCom,self.goodLuckGoldRollIng);
   table.insert(xiangqi_Data.numrollingcont,#xiangqi_Data.numrollingcont+1,self.goodLuckGoldroll);

   self.freeAllGoldroll = xiangqi_NumRolling:New();
   self.freeAllGoldroll:setfun(self,self.freeAllGoldRollCom,self.freeAllGoldRollIng);
   table.insert(xiangqi_Data.numrollingcont,#xiangqi_Data.numrollingcont+1,self.freeAllGoldroll);

   self.goldanima = args.transform:Find("bottomcont/zhipai_jinbi"):GetComponent("ParticleSystem");
  
end

function xiangqi_LianLine.goodLuckGoldRollIng(obj,args)
    xiangqi_PushFun.CreatShowNum(self.goodLuckSp.transform:Find("numcont"),args,"free_",false,39,3,200,290);
end

function xiangqi_LianLine.goodLuckGoldRollCom(obj,args)
   xiangqi_PushFun.CreatShowNum(self.goodLuckSp.transform:Find("numcont"),args,"free_",false,39,3,200,290);
end

function xiangqi_LianLine.freeAllGoldRollIng(obj,args)
    xiangqi_PushFun.CreatShowNum(self.allfreegoldcont.transform:Find("numcont"),args,"freeall_gold_",false,65,2,750,-350);
end

function xiangqi_LianLine.freeAllGoldRollCom(obj,args)
    xiangqi_PushFun.CreatShowNum(self.allfreegoldcont.transform:Find("numcont"),args,"freeall_gold_",false,65,2,750,-350);   
    --self.goldanima.loop = false;
    local m =self.goldanima.main;
    m.loop = false;
    --error("_______freeAllGoldRollCom____");
    xiangqi_Data.freeAllGold = 0;
    xiangqi_Data.isshowmygold = true;
    xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_gold_chang,true);
    MusicManager:PlayBacksound("end",false);
    coroutine.start(function(args)
       coroutine.wait(1);
        self.allfreegoldcont.gameObject:SetActive(false);
      --   self.allfreegoldcont.transform:Find("leftanima").gameObject:GetComponent("ImageAnima"):Stop();
      --   self.allfreegoldcont.transform:Find("rightanima").gameObject:GetComponent("ImageAnima"):Stop();
       xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_close_stop_btn);
       xiangqi_Socket.gameOneOver2(false); 
    end);
    
end

function xiangqi_LianLine.gameExit(args)
    self.per =   nil;
    self.guikey = "cn";
    self.allfreegoldcont = nil;
    self.goodLuckSp = nil;
    self.tsmodetsSp = nil;
    self.goldanima = nil;
    self.goodLuckGoldroll = nil;
    self.isShowGoodLuck = false;
    self.tsRunKuang = nil;

    self.lizi = nil;
    self.zhipai_mianfeicishu = nil;
    
end

function xiangqi_LianLine.addEvent()
     xiangqi_Event.addEvent(xiangqi_Event.xiongm_run_com,self.runCom,self.guikey);
     xiangqi_Event.addEvent(xiangqi_Event.xiongm_start,self.gameStart,self.guikey);
     xiangqi_Event.addEvent(xiangqi_Event.game_once_over,self.onceOver,self.guikey); 
     xiangqi_Event.addEvent(xiangqi_Event.xiongm_show_free_all_gold,self.showFreeAllGold,self.guikey);
     xiangqi_Event.addEvent(xiangqi_Event.xiongm_show_stop_btn_click,self.stopBtnCLick,self.guikey);
end

--function xiangqi_LianLine.gameGoldRollCom(args)
--   self.sendGameOver();
--end

--function xiangqi_LianLine.sendGameOver()
--   xiangqi_Socket.gameOneOver(false);
--end

function xiangqi_LianLine.gameStart(args)
   self.goodLuckSp.gameObject:SetActive(false);
    self.closeGoodLuckItem();
end

function xiangqi_LianLine.onceOver(args)
end


function xiangqi_LianLine.runCom(args) 
    if args.data == 5 then
        self.tsRunKuang.gameObject:SetActive(false);
        local isfive = false;
        local len = #xiangqi_Data.openWinImg;
        for i=1,len do
            if xiangqi_Data.openWinImg[i].byKey==5 then
               isfive = true;
               break;
            end
        end
        if xiangqi_Data.isPalyFreeAnima==true then
           coroutine.start(function(args)
               xiangqi_Socket.playaudio("freewait",false,false,false)
               coroutine.wait(2.5);
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
    elseif xiangqi_Data.lockColIndex>0 and  args.data == xiangqi_Data.lockColIndex then
       xiangqi_Data.lockColIndex = xiangqi_Data.lockColIndex + 1;
       xiangqi_Event.dispathEvent(xiangqi_Event.xiangqi_over,{curindex = xiangqi_Data.lockColIndex,maxtimer=12,jiantimer=0.4});

       local pos = self.per.transform:Find("runcontmask/runcont/showcont_"..xiangqi_Data.lockColIndex).transform.position;
       local pos2 = self.per.transform:Find("tsrun").transform.position
       self.per.transform:Find("tsrun").transform.position = Vector3.New(pos.x,pos2.y,pos2.z);
       self.tsRunKuang.gameObject:SetActive(true);
        return;
    end
end

--
function xiangqi_LianLine.showFreeAllGold(args)    
   --self.allfreegoldcont.transform:Find("leftanima").gameObject:GetComponent("ImageAnima"):PlayAlways();
   --elf.allfreegoldcont.transform:Find("rightanima").gameObject:GetComponent("ImageAnima"):PlayAlways();
   self.allfreegoldcont.gameObject:SetActive(true);
   local t1 = math.abs(xiangqi_Data.freeAllGold/(xiangqi_Data.curSelectChoum*xiangqi_Data.baseRunMoneyTimer*10));
   self.freeAllGoldroll:setdata(0,xiangqi_Data.freeAllGold,t1);
   --self.goldanima.loop = true;
   local m =self.goldanima.main;
    m.loop = true;
   self.goldanima:Play();
   xiangqi_Socket.playaudio("getgold",true,true,true);
   xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_show_stop_btn);
end

function xiangqi_LianLine.stopBtnCLick(args)
   if self.freeAllGoldroll.isrun ==true then
      --self.goldanima.loop = false;
      local m =self.goldanima.main;
      m.loop = false;
      MusicManager:PlayBacksound("end",false);
      self.freeAllGoldroll.onceStop = true;
   end
   if self.goodLuckGoldroll.isrun ==true then
      self.goodLuckGoldroll.onceStop = true;
   end
end

--播放5连动画
function xiangqi_LianLine.fiveAnima(args)     
   xiangqi_Socket.playaudio("five5",false,true,true);
   local item = self.tsmodetsSp.transform:Find("lianx");
   local pos = item.transform.localPosition;
   item.transform.localPosition = Vector3.New(500,pos.y,pos.z);
   self.tsmodetsSp.gameObject:SetActive(true);
   item.gameObject:SetActive(true);
   local tween = item.transform:DOLocalMove(Vector3.New(pos.x,pos.y,pos.z),0.5,false);
   tween:OnComplete(function()
       coroutine.start(function(args)
            coroutine.wait(1);
             item.gameObject:SetActive(false);
             self.tsmodetsSp.gameObject:SetActive(false);
             self.ShowLine();
       end) 
   end);
end
--播放免费动画
function xiangqi_LianLine.freeAnima(args) 
   self.lizi.gameObject:SetActive(true);
   self.zhipai_mianfeicishu.gameObject:SetActive(true);

   xiangqi_Socket.playaudio("freeenter",false,false,false); 
   local item = self.tsmodetsSp.transform:Find("freetips");
   local pos = item.transform.localPosition;
   item.transform.localPosition = Vector3.New(500,pos.y,pos.z);
   self.tsmodetsSp.gameObject:SetActive(true);
   item.gameObject:SetActive(true);
    xiangqi_PushFun.CreatShowNum(item.transform:Find("numcont"),xiangqi_Data.byFreeCnt,"freetis_",false,32,1,200,-242);
   local tween = item.transform:DOLocalMove(Vector3.New(pos.x,pos.y,pos.z),0.5,false);
   xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_show_bg,1);
   tween:OnComplete(function()
       coroutine.start(function(args)
            coroutine.wait(2);
             item.gameObject:SetActive(false);
             self.tsmodetsSp.gameObject:SetActive(false);
              xiangqi_Socket.gameOneOver2(false);  
             --self.ShowLine();
       end) 
   end);
end
function xiangqi_LianLine.closeGoodLuckItem()
   for i=1,3 do
       self.goodLuckSp.transform:Find("titlecont/win_"..i).gameObject:SetActive(false);
   end
   self.goodLuckSp.transform:Find("numcont").gameObject:SetActive(false);
end
--计算金币显示
function xiangqi_LianLine.countGoldTimer(args)
   local t1 = math.abs(xiangqi_Data.lineWinScore/(xiangqi_Data.curSelectChoum*xiangqi_Data.baseRunMoneyTimer));
   local t2 = math.abs(2*#xiangqi_Data.openWinImg);
   local t3 = math.min(t1,t2);
   if t3<= args then
      t3 = args;
   else
      t3 = (math.floor(t3/args)+1)*args;
   end
   if xiangqi_Data.byFreeCnt>0 or xiangqi_Data.freeAllGold>0 then
      xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_show_win_gold,{addmoney=xiangqi_Data.freeAllGold,iscom=false,anima=self.goldanima,playtimer=t3});
   else
      --error("______countGoldTimer_____"..xiangqi_Data.lineWinScore);
      xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_show_win_gold,{addmoney=xiangqi_Data.lineWinScore,iscom=true,anima=self.goldanima,playtimer=t3});
   end
   if self.isShowGoodLuck == true then
      self.goodLuckGoldroll:setdata(0,xiangqi_Data.lineWinScore,t3);
   end
end
--显示线
function xiangqi_LianLine.ShowLine()
  self.isShowGoodLuck = false;
  local showindex = 0;  
  local soundtimer = 0.36;
  xiangqi_Socket.isReqDataIng  = false
  self.closeGoodLuckItem();
  if xiangqi_Data.allOpenRate>50*xiangqi_Data.baseRate then
      self.isShowGoodLuck = true;
     showindex = 3;
     xiangqi_Socket.playaudio("superwin",true,true,true) 
     soundtimer = 11.179;
  elseif xiangqi_Data.allOpenRate>10*xiangqi_Data.baseRate then
      self.isShowGoodLuck = true;
     showindex = 2;
     xiangqi_Socket.playaudio("midwin",true,true,true) 
     soundtimer = 9.135;
  elseif xiangqi_Data.allOpenRate>5*xiangqi_Data.baseRate then
     self.isShowGoodLuck = true;
    showindex = 1; 
    xiangqi_Socket.playaudio("luckwin",true,true,true) 
    soundtimer = 1.516; 
  elseif xiangqi_Data.allOpenRate>1 then
    xiangqi_Socket.playaudio("normalwin",false,false,true)    
  end 
  if self.isShowGoodLuck==true then
     self.goodLuckSp.gameObject:SetActive(true);
     self.goodLuckSp.transform:Find("titlecont/win_"..showindex).gameObject:SetActive(true);
     self.goodLuckSp.transform:Find("numcont").gameObject:SetActive(true);     
  end
  self.curShowLineIndex = 0;
  local openLineData = nil;
  local len = #xiangqi_Data.openWinImg; 
  if len>0 then
       self.countGoldTimer(soundtimer);
      xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_show_line_anima);
      --if  xiangqi_Data.byFreeCnt==0 and  xiangqi_Data.freeAllGold==0 and xiangqi_Data.isAutoGame==false then
          xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_show_stop_btn);
      --end
  else
     if xiangqi_Data.byFreeCnt==0 and xiangqi_Data.freeAllGold>0 then
        self.showFreeAllGold();
     else
         if xiangqi_Data.byFreeCnt>0 then
             xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_show_free_btn);
         else
             xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_start_btn_no_inter,true);  
         end
         if xiangqi_Data.isPalyFreeAnima==true then
            self.freeAnima();
           return;
        end
        xiangqi_Socket.gameOneOver2(false);  
     end
  end 
end
