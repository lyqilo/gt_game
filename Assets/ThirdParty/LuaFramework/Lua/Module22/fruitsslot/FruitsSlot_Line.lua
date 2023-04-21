FruitsSlot_Line = {};
local self = FruitsSlot_Line;

self.line = nil;
self.per =   nil;
self.guikey = "cn";
self.defalutLineSize = nil;
self.curShowLineIndex = 0;


function FruitsSlot_Line.setPer(line,parentline)
   self.line = line;
   self.per =  parentline;
   self.line.gameObject:SetActive(false);
   self.guikey = FruitsSlotEvent.guid();
   self.defalutLineSize = Vector2.New(self.line.transform:GetComponent('RectTransform').sizeDelta.x,self.line.transform:GetComponent('RectTransform').sizeDelta.y);
   self.addEvent();
end

function FruitsSlot_Line.gameExit(args)
    self.line = nil;
    self.per =   nil;
    self.guikey = "cn";
    self.defalutLineSize = nil;
    self.curShowLineIndex = 0;
end

function FruitsSlot_Line.addEvent()
   FruitsSlotEvent.addEvent(FruitsSlotEvent.game_run_com,self.runCom,self.guikey);
   FruitsSlotEvent.addEvent(FruitsSlotEvent.game_start,self.gameStart,self.guikey);
   FruitsSlotEvent.addEvent(FruitsSlotEvent.game_once_over,self.onceOver,self.guikey);   
   FruitsSlotEvent.addEvent(FruitsSlotEvent.game_img_play_com,self.gameImgPlayCom,self.guikey);
   FruitsSlotEvent.addEvent(FruitsSlotEvent.game_exit,self.gameExit,self.guikey);
   FruitsSlotEvent.addEvent(FruitsSlotEvent.game_gold_roll_com,self.gameGoldRollCom,self.guikey);
end

function FruitsSlot_Line.gameGoldRollCom(args)
   --error("________gameGoldRollComgameGoldRollComgameGoldRollCom____________");
   if args.data == FruitsSlot_Config.starlin then
      FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_img_play_com,FruitsSlot_Config.select_img_play_com_type_line);
   end
end

function FruitsSlot_Line.gameImgPlayCom(args)
    self.defalutLine();
end
function FruitsSlot_Line.gameStart(args)
   self.defalutLine();
end
function FruitsSlot_Line.onceOver(args)
   self.defalutLine();
end

function FruitsSlot_Line.runCom(args)
  if FruitsSlot_Data.isopesecondimg==true then
     coroutine.start(function (args)
         coroutine.wait(0.5);
         FruitsSlot_Data.openSecondReFires();
         FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_over,5);
         FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_start,5);
     end);
     --error("____11________game_show_colse_lock_bg________________");
      FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_show_colse_lock_bg,true);
  else
    self.ShowLine();
    self.showSeclectAnima();
    FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_show_colse_lock_bg,false);
    if FruitsSlot_Data.getIsStop()==true then
       FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_show_win_gold,{isdispathgameover = false,addgold =FruitsSlot_Data.lineWinScore,smoney = FruitsSlot_Data.lineWinScore,durtimer = 2,emoney=0,rate=FruitsSlot_Data.openrate,ftar = FruitsSlot_Config.starlin}); 
       FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_start_btn_inter,true);
    else
       FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_show_win_gold,{isdispathgameover = false,addgold =FruitsSlot_Data.lineWinScore,smoney = 0,durtimer = 2,emoney=FruitsSlot_Data.lineWinScore,rate=FruitsSlot_Data.openrate,ftar = FruitsSlot_Config.starlin}); 
    end
  end
  
  --FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_play_select_run);
end

function FruitsSlot_Line.defalutLine()
  local len = self.per.transform.childCount;
  local item = nil;
  for i=1,len do
      item = self.per.transform:GetChild(i-1);
      item.transform:GetComponent('RectTransform').sizeDelta = Vector2.New(self.defalutLineSize.x,self.defalutLineSize.y);
      item.gameObject:SetActive(false);
      item.transform.eulerAngles = Vector3.New(0,0,0);
  end
end

function FruitsSlot_Line.getLine(index)
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

function FruitsSlot_Line.showSeclectAnima()
  local len = #FruitsSlot_Data.openline;
  local datalen = 0;
  local selectdata = nil;
  local configdata = nil;
  local item = nil;
  local fva = 0;
  local issetdispath = false;
  for i=1,len do
      selectdata = FruitsSlot_Data.openline[i].data;
      configdata = FruitsSlot_Config.line_config[FruitsSlot_Data.openline[i].line];
      datalen = #selectdata;
      for a=1,datalen do
        if selectdata[a] == 1 then
           fva = FruitsSlot_Data.openimg[configdata[a]+1];
           item = FruitsSlot_Data.allshowitem[configdata[a]+1];
           if issetdispath==false then
              issetdispath= true;
              item:setAnima(FruitsSlot_Config.resimg_config[fva].animaimg,FruitsSlot_Config.resimg_config[fva].count,false,FruitsSlot_Config.resimg_config[fva].loop);
           else
              item:setAnima(FruitsSlot_Config.resimg_config[fva].animaimg,FruitsSlot_Config.resimg_config[fva].count,false,FruitsSlot_Config.resimg_config[fva].loop);
           end
           
        end
      end
  end
  if len>0 then
     local alllen = #FruitsSlot_Data.allshowitem;
     for a=1, alllen do
         FruitsSlot_Data.allshowitem[a]:playAnima();
     end
      FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_line,false,false);
  else
     self.defalutLine();
     if FruitsSlot_Data.lineWinScore<=0 then
        FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_img_play_com,FruitsSlot_Config.select_img_play_com_type_line);
     end
  end
end

--显示线
function FruitsSlot_Line.ShowLine()
  self.curShowLineIndex = 0;
  local openLineData = nil;
  local len = #FruitsSlot_Data.openline;
  local linelen = nil;
  local curpos = nil;
  local nextpos = nil;
  local iDirection = nil;
  for i=1,len do
      openLineData = FruitsSlot_Config.line_config[FruitsSlot_Data.openline[i].line];
      curpos = self.getpos(openLineData[1]);
      linelen = #openLineData;
      for a=2,linelen do
         nextpos = self.getpos(openLineData[a]);
         iDirection = math.abs(openLineData[a-1] - openLineData[a]);
         self.SetLine(false,curpos,nextpos,iDirection);
         curpos = Vector3.New(nextpos.x,nextpos.y,nextpos.z);
      end
      
  end
end

--的到是全局坐标
function FruitsSlot_Line.getpos(index)
   local item = FruitsSlot_Data.allshowitem[index+1];
   return item:getPosint();
end

--设置线
--bShow 是否显示, traCurrentPoint 当前点, traNextPoint 下个点, iDirection 线的方向 -1直线 <0下斜线 >0上斜线
function FruitsSlot_Line.SetLine(bShow, traCurrentPoint, traNextPoint, iDirection)
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
end
