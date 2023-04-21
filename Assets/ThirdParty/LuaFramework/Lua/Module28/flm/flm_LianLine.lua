flm_LianLine = {};
local self = flm_LianLine;

function flm_LianLine.setPer(line,parentline,baseper)
   self.gameExit();
   self.line = line;
   self.per =  parentline;
   self.baseper =  baseper;
   self.line.gameObject:SetActive(false);
   self.tsRunKuang = baseper.transform:Find("tsrun/img");
   self.tsRunKuangAnima = self.tsRunKuang.gameObject:AddComponent(typeof(ImageAnima)); 
   self.tsRunKuangAnima.fSep = 0.03;
   for i=1,14 do
      self.tsRunKuangAnima:AddSprite(flm_Data.icon_res.transform:Find("speed_anima_"..i):GetComponent('Image').sprite);
   end
   self.tsRunKuangAnima:PlayAlways();
   self.tsRunKuang.gameObject:SetActive(false);
   self.guikey = flm_Event.guid();
   self.defalutLineSize = Vector2.New(self.line.transform:GetComponent('RectTransform').sizeDelta.x,self.line.transform:GetComponent('RectTransform').sizeDelta.y);
   self.addEvent();
end

function flm_LianLine.gameExit(args)
    self.line = nil;
    self.per =   nil;
    self.baseper =   nil;
    self.guikey = "cn";
    self.defalutLineSize = nil;
    self.curShowLineIndex = 0;
    self.selfGameIndex = 0;
    self.goldanima = nil;
    self.tsRunKuang = nil; 
    self.tsRunKuangAnima = nil; 
    
end

function flm_LianLine.addEvent()
     flm_Event.addEvent(flm_Event.xiongm_run_com,self.runCom,self.guikey);
     flm_Event.addEvent(flm_Event.xiongm_start,self.gameStart,self.guikey);
     flm_Event.addEvent(flm_Event.game_once_over,self.onceOver,self.guikey); 
     --flm_Event.addEvent(flm_Event.xiongm_img_play_com,self.gameImgPlayCom,self.guikey);
     flm_Event.addEvent(flm_Event.xiongm_gold_roll_com,self.gameGoldRollCom,self.guikey);
     flm_Event.addEvent(flm_Event.xiongm_show_jiugong_full_anima_com,self.showTsAnimaCom,self.guikey);
     
end

function flm_LianLine.gameGoldRollCom(args)
   self.sendGameOver();
end

function flm_LianLine.sendGameOver()
   flm_Socket.gameOneOver(false);
end

function flm_LianLine.gameStart(args)
   self.defalutLine();
end

function flm_LianLine.onceOver(args)
   self.defalutLine();
end


function flm_LianLine.runCom(args)  
     if args.data == 5 then
        self.tsRunKuang.gameObject:SetActive(false);        
        self.ShowLine();
     elseif flm_Data.lockColIndex>0 and  args.data == flm_Data.lockColIndex then
       flm_Data.lockColIndex = flm_Data.lockColIndex + 1;
       flm_Event.dispathEvent(flm_Event.xiongm_over,{curindex = flm_Data.lockColIndex,maxtimer=12,jiantimer=0.6});
       local pos = self.baseper.transform:Find("runcontmask/runcont/showcont_"..flm_Data.lockColIndex).transform.position;
       local pos2 = self.baseper.transform:Find("tsrun").transform.position
       self.tsRunKuang.transform.position = Vector3.New(pos.x,pos2.y,pos2.z);
       self.tsRunKuang.gameObject:SetActive(true);
        return;
    end
end

function flm_LianLine.showTsAnimaCom(args)
   self.ShowLine();
end

--计算金币显示
function flm_LianLine.countGoldTimer()
   local t1 = math.abs(flm_Data.lineWinScore/(flm_Data.curSelectChoum*flm_Data.baseRunMoneyTimer) - 1);
   local t2 = math.abs(1.3*#flm_Data.openline);
   local t3 = math.max(t1,t2);
   if flm_Data.byFreeCnt>0 or flm_Data.freeAllGold>0 then
      flm_Event.dispathEvent(flm_Event.xiongm_show_win_gold,{addmoney=flm_Data.freeAllGold,iscom=false,anima=nil,playtimer=t3});
   else
      flm_Event.dispathEvent(flm_Event.xiongm_show_win_gold,{addmoney=flm_Data.lineWinScore,iscom=true,anima=nil,playtimer=t3});
   end
end
--显示线
function flm_LianLine.ShowLine()  
  self.curShowLineIndex = 0;
  local openLineData = nil;
  local len = #flm_Data.openline; 
  flm_Socket.isReqDataIng  = false
  if len>0 then
       self.countGoldTimer();
       self.creatAllLine();
       self.createSeclectAnima();
      flm_Event.dispathEvent(flm_Event.xiongm_show_line_anima);
      --if  flm_Data.byFreeCnt==0 and  flm_Data.freeAllGold==0 and flm_Data.isAutoGame==false then
          flm_Event.dispathEvent(flm_Event.xiongm_show_stop_btn);
      --end
  else
--     if flm_Data.byFreeCnt==0 and flm_Data.freeAllGold>0 then
--        flm_Event.dispathEvent(flm_Event.xiongm_show_free_all_gold);
--     else
--         if flm_Data.byFreeCnt>0 then
--             flm_Event.dispathEvent(flm_Event.xiongm_show_free_btn);
--         else
--             flm_Event.dispathEvent(flm_Event.xiongm_start_btn_no_inter,true);  
--         end
--         if flm_Data.byAddFreeCnt>0 then
--            self.freeAnima();
--           return;
--        end
--        if flm_Data.lineWinScore>0 then
--           self.countGoldTimer();
--           return;
--        end
--        flm_Socket.gameOneOver2(false);  
--     end
        if flm_Data.bGoldingMode == true and flm_Data.byGoldModeNum==0 then
        elseif flm_Data.lineWinScore>0 then
           self.countGoldTimer();
           flm_Socket.playaudio("normalwin",false,false);
           flm_Event.dispathEvent(flm_Event.xiongm_show_stop_btn);
           return;
        elseif flm_Data.byAddFreeCnt>0 then
           self.freeAnima();
           return;
         elseif flm_Data.bGoldMode==true then
           self.goldModeAnima();
           return;
        end
        if flm_Data.byFreeCnt>0 then
             flm_Event.dispathEvent(flm_Event.xiongm_show_free_btn);
         elseif flm_Data.byGoldModeNum>0 then
             
         else
             flm_Event.dispathEvent(flm_Event.xiongm_start_btn_no_inter,true);  
         end
        flm_Socket.gameOneOver2(false);  
  end
end

--进入金币模式的动画
function flm_LianLine.goldModeAnima(args)
   flm_Socket.playaudio("bell",false,false);
   local datalen = #flm_Data.allshowitem;
   for a=1,datalen do
        if flm_Data.selectImg[a] == flm_Config.gold then
           flm_Data.allshowitem[a]:setAnima(flm_Config.resimg_config[flm_Config.gold],false);
           flm_Data.allshowitem[a]:playAnima();
        end
   end    
    coroutine.start(function(args)
             coroutine.wait(3);
             flm_Socket.playaudio("notificoin",false,false);
             local item = self.baseper.transform:Find("bottomcont/tsmodets/allgoldtips");
             item.gameObject:SetActive(true);
             coroutine.wait(2);
             item = self.baseper.transform:Find("bottomcont/tsmodets/allgoldtips");
             item.gameObject:SetActive(false);
             flm_Socket.playaudio("coinbg",true,true);
             flm_Socket.gameOneOver2(false);
       end) 

end

function flm_LianLine.freeAnima(args)
   local item = self.baseper.transform:Find("bottomcont/tsmodets/freetips");
   local pos = item.transform.localPosition;
   item.transform.localPosition = Vector3.New(500,pos.y,pos.z);   
   flm_Socket.playaudio("bianp",false,false);
   local datalen = #flm_Data.allshowitem;
   for a=1,datalen do
        if flm_Data.selectImg[a] == flm_Config.bianpao then
           flm_Data.allshowitem[a]:setAnima(flm_Config.resimg_config[flm_Config.bianpao],false);
           flm_Data.allshowitem[a]:playAnima();
        end
   end
   flm_PushFun.CreatShowNum(item.transform:Find("numcont"),flm_Data.byAddFreeCnt,"free_tips_",false,58,2,1100,-500);
   coroutine.start(function(args)       
       coroutine.wait(2);
       flm_Socket.playaudio("notifree",false,false);
       item.gameObject:SetActive(true);
       item.transform:DOLocalMove(Vector3.New(pos.x,pos.y,pos.z),0.5,false);
       coroutine.wait(2);
       for b=1,datalen do
           if flm_Data.selectImg[b] == flm_Config.bianpao then
              flm_Data.allshowitem[b]:stopPlaySelctAnima();
           end
        end
        flm_Event.dispathEvent(flm_Event.xiongm_show_free_bg);        
        flm_Socket.playaudio("freebg",true,true);
        item.gameObject:SetActive(false);
        flm_Socket.gameOneOver2(false);
   end);
   
end


function flm_LianLine.defalutLine()
  local len = self.per.transform.childCount;
  local item = nil;
  for i=1,len do
      item = self.per.transform:GetChild(i-1);
      item.transform:GetComponent('RectTransform').sizeDelta = Vector2.New(self.defalutLineSize.x,self.defalutLineSize.y);
      item.gameObject:SetActive(false);
      item.transform.eulerAngles = Vector3.New(0,0,0);
  end
end

function flm_LianLine.getLine(index)
   local traLine = nil;
   if index<self.per.transform.childCount then
      traLine = self.per.transform:GetChild(index);
    else
       traLine = newobject(self.line).transform;
       traLine:SetParent(self.per.transform);
       traLine.localScale = Vector3.one;
   end
   traLine.gameObject:SetActive(true);
   return traLine;
end


function flm_LianLine.createSeclectAnima()
  local len = #flm_Data.openline;
  local datalen = 0;
  local selectdata = nil;
  local configdata = nil;
  local item = nil;
  local fva = 0;
  local issetdispath = false;
  local resimgconfig = nil;
  local soundstr = nil;
  local soundnum = 0;
  local wildnum = 0;
  for d=1,flm_CMD.D_ALL_COUNT do
     if flm_Data.selectImg[d] == flm_Config.wild then
        wildnum = wildnum +1;
     end
  end
  for i=1,len do
      selectdata = flm_Data.openline[i].data;
      configdata = flm_Config.line_config[flm_Data.openline[i].line];
      datalen = #selectdata;
      for a=1,datalen do
        item = flm_Data.allshowitem[configdata[a]+1];
        if selectdata[a] == 1 then
           fva = flm_Data.selectImg[configdata[a]+1];           
           resimgconfig = flm_Config.resimg_config[fva];
           item:setAnima(resimgconfig,false);
           if a==1 then
              if fva==flm_Config.wild and wildnum>4 and fva>soundnum then
                 soundnum = fva;
                 soundstr = nil;
              elseif fva==flm_Config.shiz and fva>soundnum then
                 soundnum = fva;
                 soundstr = "shizwin";
              elseif fva>soundnum and (fva==flm_Config.fu or fva==flm_Config.shou) then
                 soundnum = fva;
                 soundstr = "fuwawin";
              end
           end
        end
      end
  end
  if soundstr ~= nil then
     flm_Socket.playaudio(soundstr,false,false);
  else
    flm_Socket.playaudio("normalwin",false,false);
  end
end


--显示线
function flm_LianLine.creatAllLine() 
  self.curShowLineIndex = 0;
  local openLineData = nil;
  local len = #flm_Data.openline;
  local linelen = nil;
  local curpos = nil;
  local nextpos = nil;
  local iDirection = nil;
  for i=1,len do
      openLineData = flm_Config.line_config[flm_Data.openline[i].line];
      curpos = self.getpos(openLineData[1]);
      linelen = #openLineData;
      for a=2,linelen do
         nextpos = self.getpos(openLineData[a]);
         iDirection = math.abs(openLineData[a-1] - openLineData[a]);
         self.SetLine(false,curpos,nextpos,iDirection).transform.name = "line_"..flm_Data.openline[i].line.."_"..a;
         curpos = Vector3.New(nextpos.x,nextpos.y,nextpos.z);
      end
  end  
end

--的到是全局坐标
function flm_LianLine.getpos(index)
   local item = flm_Data.allshowitem[index+1];
   return item:getPosint();
end

--设置线
--bShow 是否显示, traCurrentPoint 当前点, traNextPoint 下个点, iDirection 线的方向 -1直线 <0下斜线 >0上斜线
function flm_LianLine.SetLine(bShow, traCurrentPoint, traNextPoint, iDirection)
   traLine =  self.getLine(self.curShowLineIndex);
    self.curShowLineIndex = self.curShowLineIndex+1;
    --设置长度--
    local fpos = nil;
    traLine.transform.position = Vector3.New(traCurrentPoint.x,traCurrentPoint.y,traCurrentPoint.z);
    fpos = traLine.transform.localPosition;
    local clocalpos = Vector3.New(fpos.x,fpos.y,fpos.z);
    traLine.transform.position = Vector3.New(traNextPoint.x,traNextPoint.y,traNextPoint.z);
    fpos = traLine.transform.localPosition;
    local tlocalpos = Vector3.New(fpos.x,fpos.y,fpos.z);

    local iDis = Vector3.Distance(clocalpos, tlocalpos); --距离
    local comRectTransform = traLine:GetComponent('RectTransform');  
    local ve2Size= Vector2.New(iDis, comRectTransform.sizeDelta.y);
    comRectTransform.sizeDelta = ve2Size;

    --设置位置--
    --local ve3Pos = (traCurrentPoint.transform.position + traNextPoint.transform.position) / 2
    traLine.transform.position = Vector3.New(traCurrentPoint.x,traCurrentPoint.y,traCurrentPoint.z);
    --设置角度--
    if(1 ~= iDirection) then
        local fYhight = clocalpos.y - tlocalpos.y;
        local fAngel = math.asin(fYhight / iDis) * Mathf.Rad2Deg * -1;
        traLine.transform:Rotate(0, 0, fAngel);
    end
    return traLine;
end
