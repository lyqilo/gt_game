flm_TSAnima = {};
local self = flm_TSAnima;

function flm_TSAnima.init()
   self.isShowLineAnima = false;
   self.showLineTimer = 3;
   self.showLineCurTimer = 0;
   self.curShowLineIndex = 0;
   self.linePer = nil;

   self.winIcon = nil;
   self.winBg = nil;
   self.winIconAnimaSp = nil;
   self.winIconAnima = nil;
   self.wincont = nil;

   self.gudicont = nil;
   self.guidiItem = nil;

   self.lihuoAnimaL = nil;
   self.lihuoAnimaR = nil;
   self.liBtnAnima = nil;
   self.animaFromTar = nil;

   self.guikey = "cn";

   self.GoldInfo = {};
   self.GoldInfoPos = {};
   self.GoldInfoWH = {};
   self.StartGold = false;
   self.dTime = 0;
   self.wingoldcont = nil;

   self.allfreegoldcont = nil;
   self.freeAllGoldroll = nil;

   self.goldmodewincont = nil;
   self.goldmodewinroll = nil;

   self.goldanima = nil;
   self.goldmodeflycont = nil;
   self.mygold = nil;

end

function flm_TSAnima.setPer(args)
   self.init();
   self.guikey = flm_Event.guid();
   self.linePer = args.transform:Find("linecont");
   self.gudicont = args.transform:Find("runcontmask/runcont/gudicont");
   self.goldmodeflycont = args.transform:Find("goldmodeflycont");   
   self.guidiItem = args.transform:Find("item");
   self.winIcon = args.transform:Find("winanimacont/icon");
   --self.winBg = args.transform:Find("winanimacont/bg");
   self.wincont = args.transform:Find("winanimacont");
   self.wingoldcont = args.transform:Find("bottomcont/wingoldcont");
   self.mygold = args.transform:Find("bottomcont/mygoldcont");
   self.winIconAnima = args.transform:Find("winanimacont/iconanima").gameObject:AddComponent(typeof(ImageAnima));
   self.winIconAnimaSp = args.transform:Find("winanimacont/iconanima");   
   self.winIconAnima.fSep = 0.1;
   self.winIconAnima:SetEndEvent(self.fullAndJiugongAnimaCom);

   --self.goldanima = args.transform:Find("bottomcont/zhipai_jinbi"):GetComponent("ParticleSystem");

  
   --self.winBg.gameObject:SetActive(false);
   --error("_____1111______");
   local golditem = args.transform:Find("gloditem");
   golditem.gameObject:SetActive(false);
--   local createItem = nil;
--   for c=1,80 do
--       createItem = newobject(golditem);
--       createItem.transform:SetParent(self.wingoldcont.transform);
--       createItem.transform.localScale = Vector3.One();
--       createItem.transform.localPosition = Vector3.New(math.random(0,500), math.random(0,10), 0);
--       table.insert(self.GoldInfo,c,createItem);
--       table.insert(self.GoldInfoPos,c,Vector2.New(math.random(0,100), math.random(0,10)));
--       table.insert(self.GoldInfoWH,c,Vector2.New(math.random(0,1), 50));
--   end
   self.allfreegoldcont = args.transform:Find("bottomcont/allfreegoldcont");
   self.allfreegoldcont:Find("maskimg"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);

   self.allfreegoldcont.gameObject:SetActive(false);
   self.freeAllGoldroll = flm_NumRolling:New();
   self.freeAllGoldroll:setfun(self,self.freeAllGoldRollCom,self.freeAllGoldRollIng);
   table.insert(flm_Data.numrollingcont,#flm_Data.numrollingcont+1,self.freeAllGoldroll);

   self.goldmodewincont = args.transform:Find("bottomcont/goldmodewincont");
   self.goldmodewincont:Find("maskimg"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);

   self.goldmodewincont.gameObject:SetActive(false);
   self.goldmodewinroll = flm_NumRolling:New();
   self.goldmodewinroll:setfun(self,self.goldmodewinRollCom,self.goldmodewinRollIng);
   table.insert(flm_Data.numrollingcont,#flm_Data.numrollingcont+1,self.goldmodewinroll);

   self.addEvent();
end

function flm_TSAnima.freeAllGoldRollIng(obj,args)
    flm_PushFun.CreatShowNum(self.allfreegoldcont.transform:Find("numcont"),args,"freeall_gold_",false,65,2,1100,-500);
end

function flm_TSAnima.freeAllGoldRollCom(obj,args)
    flm_PushFun.CreatShowNum(self.allfreegoldcont.transform:Find("numcont"),args,"freeall_gold_",false,65,2,1100,-500);
    --local m =self.goldanima.main;
    --m.loop = false;
    --self.goldanima.loop = false;
    flm_Data.freeAllGold = 0;
    flm_Data.isshowmygold = true;
    flm_Event.dispathEvent(flm_Event.xiongm_gold_chang,true);
    if flm_Data.byFreeCnt==0  and flm_Data.bFireCom == true then
      MusicManager:PlayBacksound("end",false);
    end
    flm_Event.dispathEvent(flm_Event.xiongm_close_stop_btn); 
    coroutine.start(function()
       coroutine.wait(1);
       self.allfreegoldcont.gameObject:SetActive(false);
       flm_Event.dispathEvent(flm_Event.xiongm_close_free_bg); 
       flm_Socket.playaudio("normalbg",true,true);
       flm_Socket.gameOneOver2(false); 
    end);
end

function flm_TSAnima.goldmodewinRollIng(obj,args)
    flm_PushFun.CreatShowNum(self.goldmodewincont.transform:Find("numcont"),args,"freeall_gold_",false,65,2,1100,-500);
end

function flm_TSAnima.goldmodewinRollCom(obj,args)
    flm_PushFun.CreatShowNum(self.goldmodewincont.transform:Find("numcont"),args,"freeall_gold_",false,65,2,1100,-500);   
    flm_Event.dispathEvent(flm_Event.xiongm_close_stop_btn); 
    coroutine.start(function()
       coroutine.wait(1);
       self.goldmodewincont.gameObject:SetActive(false);       
      flm_Socket.playaudio("normalbg",true,true);
      flm_Socket.gameOneOver(false);
    end);
end


function flm_TSAnima.showFreeAllGold(args) 
   coroutine.start(function()
       coroutine.wait(1);
       self.allfreegoldcont.gameObject:SetActive(true);
       local t1 = math.abs(flm_Data.freeAllGold/(flm_Data.curSelectChoum*flm_Data.baseRunMoneyTimer));
       self.freeAllGoldroll:setdata(0,flm_Data.freeAllGold,t1);
       --local m =self.goldanima.main;
       --m.loop = true;
       -- self.goldanima.loop = true;
       --self.goldanima:Play();
       flm_Event.dispathEvent(flm_Event.xiongm_show_stop_btn); 
    end);   
end

function flm_TSAnima.addEvent()
   flm_Event.addEvent(flm_Event.xiongm_show_line_anima,self.showLineAnima,self.guikey);
   flm_Event.addEvent(flm_Event.xiongm_colse_line_anima,self.closeLineAnima,self.guikey);
   flm_Event.addEvent(flm_Event.xiongm_show_jiugong_full_anima,self.fullAndJiugongAnima,self.guikey);
   flm_Event.addEvent(flm_Event.xiongm_show_gudi,self.showGudi,self.guikey);
   flm_Event.addEvent(flm_Event.xiongm_lihuo_bg_anima,self.lihuoBgAnima,self.guikey);
   flm_Event.addEvent(flm_Event.xiongm_lihuo_btn_anima,self.lihuoBtnAnima,self.guikey);
   flm_Event.addEvent(flm_Event.xiongm_show_free_all_gold,self.showFreeAllGold,self.guikey);
   flm_Event.addEvent(flm_Event.xiongm_close_gudi,self.closeGudiHander,self.guikey);
   flm_Event.addEvent(flm_Event.xiongm_close_lihuo_anima,self.closeLiHuoHander,self.guikey);

   flm_Event.addEvent(flm_Event.xiongm_show_stop_btn_click,self.stopBtnCLick,self.guikey);
   flm_Event.addEvent(flm_Event.xiongm_choum_chang,self.choumChangHander,self.guikey);
   flm_Event.addEvent(flm_Event.xiongm_show_gold_mode_com_anima,self.goldModeComFlyAnima,self.guikey);
   flm_Event.addEvent(flm_Event.xiongm_close_allfu,self.closeAllFu,self.guikey);
   

   --flm_Event.addEvent(flm_Event.xiongm_show_win_gold,self.showWinGoldHander,self.guikey);   

end

function flm_TSAnima.stopBtnCLick(args)
   if self.freeAllGoldroll.isrun ==true then
      self.freeAllGoldroll.onceStop = true;
   end

   if self.goldmodewinroll.isrun ==true then
      self.goldmodewinroll.onceStop = true;
   end
   
end

function flm_TSAnima.showWinGoldHander(args)
   local len = #self.GoldInfo;
   for i=1,len do
      self.GoldInfo[i].transform.localPosition = Vector3.New(math.random(0,500), math.random(-150,50), 0);
      self.GoldInfoPos[i] = self.GoldInfo[i].transform.localPosition;
   end
   self.dTime = 0;
   self.StartGold = true;
end

function flm_TSAnima.closeGudiHander(args)
    self.gudicont.gameObject:SetActive(false);
end

function flm_TSAnima.closeLiHuoHander(args)
    self.lihuoAnimaL:StopAndRevert();
    self.lihuoAnimaR:StopAndRevert();
    self.liBtnAnima:StopAndRevert();
end

function flm_TSAnima.PaowuLine()
    self.dTime = self.dTime + 0.05;
    for i = 1, #self.GoldInfo, 1 do
        local movew = 0.5 * self.GoldInfoWH[i].x *((self.dTime - i * 0.03) * 2)+self.GoldInfoPos[i].x;
        local moveh = 0.5 * self.GoldInfoWH[i].y *(4 -(math.pow(((self.dTime - i * 0.03) * 4 - 2), 2)))+self.GoldInfoPos[i].y;
        --  local movew = 0.5 * GoldInfo[i + 2] *((dTime) * 4);
        --   local moveh = 0.5 * GoldInfo[i + 1] *(4 -(math.pow(((dTime) * 4 - 2), 2)));
--        if i % 2 == 0 then
            self.GoldInfo[i].transform.localPosition = Vector3.New(movew, moveh, 0);
--        else
           -- self.GoldInfo[i].transform.localPosition = Vector3.New(- movew, moveh, 0);
        --end
        if self.dTime >3 then 
           self.GoldInfo[i].gameObject:SetActive(false);
        else
           self.GoldInfo[i].gameObject:SetActive(true)
        end
    end
    if self.dTime > 3 then self.StartGold = false; return end
end

function flm_TSAnima.showGudi(args)
   if self.gudicont.gameObject.activeSelf==true then
      --return;
   end
   local len = self.gudicont.transform.childCount;
   local item = nil;
   for i=1,len do
       item = self.gudicont.transform:GetChild(i-1).gameObject;
       item.gameObject:SetActive(false);
   end
   local gindex = 0;
   local resimgconfig = nil;
   local pos = nil;
   len = #flm_Data.selectImg;
   for a=1,len do
       if flm_Data.selectImg[a]==flm_Config.gold then
          item = self.getGudiItem(gindex);         
          resimgconfig = flm_Config.resimg_config[flm_Config.gold];        

           local sourceitem = flm_Data.icon_res.transform:Find("gold_guding_img");
           local sizedel = sourceitem.gameObject:GetComponent("RectTransform").sizeDelta;
           item.transform:Find("icon").gameObject.gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(sizedel.x,sizedel.y);


           item.transform:Find("icon").gameObject:GetComponent('Image').sprite = sourceitem:GetComponent('Image').sprite;

           
          pos = flm_Data.allshowitem[a]:getPosint();
          item.transform.position = Vector3.New(pos.x,pos.y,pos.z);

          item.transform:Find("goldmode/numcont").gameObject:SetActive(false);
          item.transform:Find("goldmode/dafu").gameObject:SetActive(false);
          item.transform:Find("goldmode/xiaofu").gameObject:SetActive(false);
                --1:大福 2小福
          if flm_Data.openImgGold[a] == 2 then
             item.transform:Find("goldmode/xiaofu").gameObject:SetActive(true);
          elseif flm_Data.openImgGold[a] == 1 then
             item.transform:Find("goldmode/dafu").gameObject:SetActive(true);
          else
             item.transform:Find("goldmode/numcont").gameObject:SetActive(true);
             flm_PushFun.CreatShowNum(item.transform:Find("goldmode/numcont"),flm_Data.openImgGold[a],"gold_mode_",false,18,2,125,-50);
          end       

          item.transform:Find("goldmode").gameObject:SetActive(true);
          gindex = gindex+1;
       end
   end
   self.gudicont.gameObject:SetActive(true);
end

function flm_TSAnima.getGudiItem(index)
   local item = nil;
   if index<self.gudicont.transform.childCount then
      item = self.gudicont.transform:GetChild(index);
    else
       item = newobject(self.guidiItem).transform;
       item:SetParent(self.gudicont.transform);
       item.localScale = Vector3.one;
       item.transform:Find("goldmode/dafu").gameObject:SetActive(false);
       item.transform:Find("goldmode/xiaofu").gameObject:SetActive(false);
   end
   item.gameObject:SetActive(true);
   return item;
end


function flm_TSAnima.goldModeComFlyAnima(arg)
   local len = self.gudicont.transform.childCount;
   local item = nil;
   local itempos = nil;
   local gudingitem = nil;
   for i=0,len-1 do 
       gudingitem = self.gudicont.transform:GetChild(i);
       if gudingitem.gameObject.activeSelf ==true then
           itempos = self.gudicont.transform:GetChild(i).transform:Find("goldmode/numcont").transform.position;
           item = newobject(self.gudicont.transform:GetChild(i).transform:Find("goldmode/numcont"));
           item.transform:SetParent(self.goldmodeflycont.transform);
           item.transform.localScale = Vector3.New(1,1,1);
           item.transform.position = Vector3.New(itempos.x,itempos.y,itempos.z);
       end       
   end
   local pos = self.wingoldcont.transform.position;
   self.doitGoldModeAnima(0,pos);
   
end

function flm_TSAnima.doitGoldModeAnima(index,tarpos)
   local len = self.goldmodeflycont.transform.childCount;
   if index<len then
      local item = self.goldmodeflycont.transform:GetChild(index);
      local tween = item.transform:DOMove(tarpos,0.5,false);
      tween:OnComplete(function()
           item.transform.localScale = Vector3.New(0,0,0);
           if index == 0 then
              flm_Event.dispathEvent(flm_Event.xiongm_once_show_win_gold,{addmoney=flm_Data.lineWinScore,iscom=false,anima=nil,playtimer=len*0.5,sendtype = 1});
           end
           index = index +1;
           flm_TSAnima.doitGoldModeAnima(index,tarpos);
      end);
   else
      for i=0,len-1 do
          destroy(self.goldmodeflycont.transform:GetChild(i).gameObject);
      end
      coroutine.start(function()
           coroutine.wait(1);                     
           if flm_Data.fuType[2] >0 then
              flm_Event.dispathEvent(flm_Event.xiongm_show_allfu);
           else
              self.goldmodewincont.gameObject:SetActive(true); 
              local t1 = math.abs(flm_Data.lineWinScore/(flm_Data.curSelectChoum*flm_Data.baseRunMoneyTimer));
              self.goldmodewinroll:setdata(0,flm_Data.lineWinScore,t1);
           end           
           flm_Event.dispathEvent(flm_Event.xiongm_show_stop_btn); 
        end);
    end
end

function flm_TSAnima.closeAllFu(args)
    flm_Event.dispathEvent(flm_Event.xiongm_close_stop_btn);        
    flm_Socket.playaudio("normalbg",true,true);
    flm_Socket.gameOneOver(false);
end

--�һ�ı�������
function flm_TSAnima.lihuoBgAnima(args)
   error("_____lihuoBgAnima______");
   self.lihuoAnimaL:PlayAlways();
   self.lihuoAnimaR:PlayAlways();
end

--�һ�ť�Ķ���
function flm_TSAnima.lihuoBtnAnima(args)
   self.liBtnAnima:PlayAlways();
end



function flm_TSAnima.fullAndJiugongAnima(args)
    self.winIconAnima:StopAndRevert();
    self.winIconAnima:ClearAll();
    self.winIconAnima.fDelta = 0;
    if args.data.val>=flm_Config.full_start_value then
       --self.winBg.gameObject:SetActive(true);
       self.winIcon.transform:SetSiblingIndex(2);
        --flm_Socket.playaudio("full");
    else
       --self.winBg.gameObject:SetActive(false);
       self.winIcon.transform:SetSiblingIndex(1);
        --flm_Socket.playaudio("jiugong");
    end
    local anconfig = flm_Config.resimg_config[args.data.val];
    self.animaFromTar = args.data.from;
    local animasizedel =  flm_Data.icon_res.transform:Find(anconfig.animaimg.."1").gameObject:GetComponent("RectTransform").sizeDelta;
    self.winIconAnimaSp.gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(animasizedel.x,animasizedel.y);
    local len = anconfig.count;
    for a=1,anconfig.loop do
        for i=1,len do
            self.winIconAnima:AddSprite(flm_Data.icon_res.transform:Find(anconfig.animaimg..i):GetComponent('Image').sprite);
        end
    end
    local iconimg = flm_Data.icon_res.transform:Find(anconfig.normalimg);
    local iconsizedel = iconimg .gameObject:GetComponent("RectTransform").sizeDelta;
    self.winIcon.gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(iconsizedel.x,iconsizedel.y);
    self.winIcon.gameObject:GetComponent("Image").sprite = iconimg.gameObject:GetComponent("Image").sprite;
    self.winIconAnima:Play();
    self.wincont.gameObject:SetActive(true);
end

function flm_TSAnima.fullAndJiugongAnimaCom()
    self.wincont.gameObject:SetActive(false);
    flm_Event.dispathEvent(flm_Event.xiongm_show_jiugong_full_anima_com,self.animaFromTar);    
end

function flm_TSAnima.noShowLine()
  local len = self.linePer.transform.childCount;
  local item = nil;
  for i=1,len do
      item = self.linePer.transform:GetChild(i-1);
      item.gameObject:SetActive(false);
  end
  len = #flm_Data.allshowitem;
  for a=1,len do
      item = flm_Data.allshowitem[a];
      item:stopPlaySelctAnima();
  end  
end

function flm_TSAnima.showLineAnima(args)
   if #flm_Data.openline<=0 then
      return;
   end
   self.isShowLineAnima = true;
   self.showLineCurTimer = self.showLineTimer;
   self.curShowLineIndex = 0;
end

function flm_TSAnima.closeLineAnima(args)
   self.isShowLineAnima = false;
   self.showLineCurTimer = 0;
   self.curShowLineIndex = 0;
end

function flm_TSAnima.playShowLineAnima(args)
   self.noShowLine();

   self.curShowLineIndex = self.curShowLineIndex+1;
   if self.curShowLineIndex>#flm_Data.openline then
      self.curShowLineIndex = 1;
   end  
   -- if flm_Data.openline[self.curShowLineIndex] then
   --    return;
   -- end
   local item = nil;   
   for a=2,5 do
       item = self.linePer.transform:Find("line_"..flm_Data.openline[self.curShowLineIndex].line.."_"..a);
       if not IsNil(item) then
          item.gameObject:SetActive(true);
       end
   end
  local selectdata = flm_Data.openline[self.curShowLineIndex].data;
  local configdata = flm_Config.line_config[flm_Data.openline[self.curShowLineIndex].line];
  local len = #selectdata;
  for c=1,len do
      item = flm_Data.allshowitem[configdata[c]+1];
      if selectdata[c] == 1 then
         item:playAnima();
      end
  end
  
end
function flm_TSAnima.choumChangHander(arg)
   self.closeLineAnima();
    self.noShowLine();
end


function flm_TSAnima.Update()
   if self.isShowLineAnima==true then
      self.showLineCurTimer = self.showLineCurTimer+Time.deltaTime;
      if self.showLineCurTimer>=self.showLineTimer then
         self.showLineCurTimer = 0;
         self.playShowLineAnima();
      end
   end
   if self.StartGold==true then
      self.PaowuLine();
   end
end