tjz_LianLine = {};
local self = tjz_LianLine;

function tjz_LianLine.setPer(line,parentline,baseper)
   self.gameExit();
   self.line = line;
   self.per =  parentline;
   self.baseper =  baseper;
   self.line.gameObject:SetActive(false);
   self.tsRunKuang = baseper.transform:Find("tsrun/img");
   self.tsRunKuang.gameObject:SetActive(false);

    self.tsRunAnimaImg = baseper.transform:Find("tsrun/anima");
    self.tsRunAnima = self.tsRunAnimaImg.gameObject:AddComponent(typeof(ImageAnima));
    for i=1,8 do
       self.tsRunAnima:AddSprite(tjz_Data.icon_res.transform:Find("track_anima_"..i):GetComponent('Image').sprite);
    end
    self.tsRunAnima:SetEndEvent(self.tsRunAnimaCom);
    self.tsRunAnima.fSep = 0.07;

   self.guikey = tjz_Event.guid();
   self.defalutLineSize = Vector2.New(self.line.transform:GetComponent('RectTransform').sizeDelta.x,self.line.transform:GetComponent('RectTransform').sizeDelta.y);
   self.addEvent();
end
function tjz_LianLine.tsRunAnimaCom(args)
    self.tsRunKuang.gameObject:SetActive(true);
    self.tsRunAnimaImg.gameObject:SetActive(false);
end

function tjz_LianLine.gameExit(args)
    self.line = nil;
    self.per =   nil;
    self.baseper =   nil;
    self.guikey = "cn";
    self.defalutLineSize = nil;
    self.curShowLineIndex = 0;
    self.selfGameIndex = 0;
    self.goldanima = nil;
    self.tsRunKuang = nil;  
    self.tsRunAnima = nil;
    self.tsRunAnimaImg = nil;
    
end

function tjz_LianLine.addEvent()
     tjz_Event.addEvent(tjz_Event.xiongm_run_com,self.runCom,self.guikey);
     tjz_Event.addEvent(tjz_Event.xiongm_start,self.gameStart,self.guikey);
     tjz_Event.addEvent(tjz_Event.game_once_over,self.onceOver,self.guikey); 
     tjz_Event.addEvent(tjz_Event.xiongm_gold_roll_com,self.gameGoldRollCom,self.guikey);
     tjz_Event.addEvent(tjz_Event.xiongm_com_win_caijin,self.caijinRollCom,self.guikey);
     tjz_Event.addEvent(tjz_Event.xiongm_com_win_type,self.winTypeCom,self.guikey);
     tjz_Event.addEvent(tjz_Event.xiongm_com_icon_up,self.iconLevelUpCom,self.guikey);
     
end

function tjz_LianLine.gameGoldRollCom(args)
   if args.data == tjz_Config.forlin then
      self.nextStep(self.lineover);
   elseif  args.data == tjz_Config.forfree then
      self.nextStep(self.freegoldcom);
   end
end

function tjz_LianLine.winTypeCom(args)
   self.nextStep(self.winTypecom);
end

function tjz_LianLine.iconLevelUpCom(args)
   --error("_______iconLevelUpCom_________");
   self.nextStep(self.iconLeveUpCom);
end


function tjz_LianLine.gameStart(args)
   self.defalutLine();
end

function tjz_LianLine.onceOver(args)
   self.defalutLine();
end


function tjz_LianLine.runCom(args)  
     if args.data.curindex == 5 then
        if tjz_Data.bReturn==true then
            tjz_Event.dispathEvent(tjz_Event.xiongm_show_gudi);
        end
        tjz_Event.dispathEvent(tjz_Event.xiongm_close_gudi); 
        self.tsRunKuang.gameObject:SetActive(false);
        if args.data.isscatter == true then
           coroutine.start(function()
               coroutine.wait(1);
               if tjz_Socket.isongame==false then
                  return;
               end   
               self.countCaijin();
            end);
        else
            self.countCaijin();
        end
        
     elseif tjz_Data.lockColIndex>0 and  args.data.curindex == tjz_Data.lockColIndex then
       tjz_Data.lockColIndex = tjz_Data.lockColIndex + 1;
       tjz_Event.dispathEvent(tjz_Event.xiongm_over,{curindex = tjz_Data.lockColIndex,maxtimer=12,jiantimer=0.6});
       local pos = self.baseper.transform:Find("runcontmask/runcont/showcont_"..tjz_Data.lockColIndex).transform.position;
       local pos2 = self.baseper.transform:Find("tsrun").transform.position
       self.tsRunKuang.transform.position = Vector3.New(pos.x,pos2.y,pos2.z);
       self.tsRunAnimaImg.transform.position = Vector3.New(pos.x,pos2.y,pos2.z);
       self.tsRunKuang.gameObject:SetActive(false);
       self.tsRunAnimaImg.gameObject:SetActive(true);
       self.tsRunAnima:Play();
       return;
    end
end

function tjz_LianLine.countCaijin()
    if tjz_Data.i64AccuGold>0 then
       local datalen = #tjz_Data.allshowitem;
       for a=1,datalen do
            if tjz_Data.selectImg[a] == tjz_Config.jackpot then
               tjz_Data.allshowitem[a]:setAnima(tjz_Config.resimg_config[tjz_Config.jackpot],false);
               tjz_Data.allshowitem[a]:playAnima();
            end
       end
    end
    tjz_Event.dispathEvent(tjz_Event.xiongm_show_win_caijin);
end

--计算金币显示
function tjz_LianLine.countGoldTimer(Score,fortar)
   local t1 = math.abs(tjz_Data.lineWinScore/(tjz_Data.curSelectChoum*tjz_Data.baseRunMoneyTimer) - 0.5);
   local t2 = math.abs(2*#tjz_Data.openline - 0.5);
   local t3 = math.max(t1,t2);
   local t4 = math.min(20,t3);
   tjz_Event.dispathEvent(tjz_Event.xiongm_show_win_gold,{addmoney=tjz_Data.lineWinScore,iscom=true,anima=self.goldanima,playtimer=t4});
end

function tjz_LianLine.caijinRollCom(args)
    self.ShowLine();
end

--显示线
function tjz_LianLine.ShowLine()  
  self.curShowLineIndex = 0;
  local openLineData = nil;
  local len = #tjz_Data.openline; 
  tjz_Socket.isReqDataIng  = false
  if len>0 and tjz_Data.lineWinScore>0 then
       self.countGoldTimer();
       self.creatAllLine();
       self.createSeclectAnima();
       tjz_Event.dispathEvent(tjz_Event.xiongm_show_line_anima);
       --tjz_Event.dispathEvent(tjz_Event.xiongm_show_stop_btn);
  else
    self.nextStep(self.lineover)
  end
end

function tjz_LianLine.freeAnima(args)
   if tjz_Data.byAddFreeCnt==0 then
      self.nextStep(self.freetipcom);
       return;
   end
   local item = self.baseper.transform:Find("bottomcont/tsmodets/freetips");
--   local pos = item.transform.localPosition;
--   item.transform.localPosition = Vector3.New(500,pos.y,pos.z);
   item.gameObject:SetActive(true);
   --tjz_Socket.playaudio("winfree",false,false);
   local datalen = #tjz_Data.allshowitem;
   for a=1,datalen do
        if tjz_Data.selectImg[a] == tjz_Config.scatter then
           tjz_Data.allshowitem[a]:setAnima(tjz_Config.resimg_config[tjz_Config.scatter],false);
           tjz_Data.allshowitem[a]:playAnima();
        end
   end
   tjz_PushFun.CreatShowNum(item.transform:Find("numcont"),tjz_Data.byAddFreeCnt,"freeall_gold_",false,57,2,300,-230);
    coroutine.start(function(args)
            coroutine.wait(2);
            if tjz_Socket.isongame==false then
               return;
            end  
            for b=1,datalen do
                if tjz_Data.selectImg[b] == tjz_Config.scatter then
                   tjz_Data.allshowitem[b]:stopPlaySelctAnima();
                end
             end
             item.gameObject:SetActive(false);
            self.nextStep(self.freetipcom);
       end) 
--   tjz_PushFun.CreatShowNum(item.transform:Find("numcont"),tjz_Data.byAddFreeCnt,"freeall_gold_",false,57,2,130,515);
--   local tween = item.transform:DOLocalMove(Vector3.New(pos.x,pos.y,pos.z),0.5,false);
--    tween:OnComplete(function()
--       coroutine.start(function(args)
--            coroutine.wait(2);
--            for b=1,datalen do
--                if tjz_Data.selectImg[b] == tjz_Config.scatter then
--                   tjz_Data.allshowitem[b]:stopPlaySelctAnima();
--                end
--             end
--             item.gameObject:SetActive(false);
--            self.nextStep(self.freetipcom);
--       end) 
--   end);
end

function tjz_LianLine.showAllFreeGold()
  if tjz_Data.byFreeCnt==0 and tjz_Data.freeAllGold>0 and not tjz_Data.bReturn then
      tjz_Event.dispathEvent(tjz_Event.xiongm_show_free_all_gold);
   else
      self.nextStep(self.freegoldcom);
   end
end

function tjz_LianLine.showWinType()
    tjz_Event.dispathEvent(tjz_Event.xiongm_show_win_type);
end
function tjz_LianLine.showIconLeveUp()
    --error("_____showIconLeveUp________");
    tjz_Event.dispathEvent(tjz_Event.xiongm_show_icon_up);
end

self.lineover = 1;
self.freetipcom = 2;
self.freegoldcom = 3;
self.oncegameover = 4;
self.winTypecom = 5;
self.iconLeveUpCom = 6;

--form 1 线的结束 2 免费提示结束 3 免费全部金币播放完的结束 4 完成
function tjz_LianLine.nextStep(form)
   if form==self.lineover then
      self.showWinType();
   elseif  form==self.winTypecom then
       self.freeAnima();
   elseif  form==self.freetipcom then
      self.showAllFreeGold();
   elseif  form==self.freegoldcom then
      self.showIconLeveUp();
   elseif  form==self.iconLeveUpCom then
      self.nextStep(self.oncegameover);
   elseif  form==self.oncegameover then
      if tjz_Data.byFreeCnt>0 then
             tjz_Event.dispathEvent(tjz_Event.xiongm_show_free_btn);
      else
             --tjz_Event.dispathEvent(tjz_Event.xiongm_start_btn_no_inter,true);  
      end
      tjz_Socket.gameOneOver2(false); 
   end
end


function tjz_LianLine.defalutLine()
  local len = self.per.transform.childCount;
  local item = nil;
  for i=1,len do
      item = self.per.transform:GetChild(i-1);
      item.transform:GetComponent('RectTransform').sizeDelta = Vector2.New(self.defalutLineSize.x,self.defalutLineSize.y);
      item.gameObject:SetActive(false);
      item.transform.eulerAngles = Vector3.New(0,0,0);
  end
end

function tjz_LianLine.getLine(index)
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


function tjz_LianLine.createSeclectAnima()
  local len = #tjz_Data.openline;
  local datalen = 0;
  local selectdata = nil;
  local configdata = nil;
  local item = nil;
  local fva = 0;
  local issetdispath = false;
  local resimgconfig = nil;
--  for c=1,#tjz_Data.allshowitem do
--      if #tjz_Data.openline==0 then
--         tjz_Data.allshowitem[c]:setIconColor(Color.New(255,255,255,255))  
--      else
--         tjz_Data.allshowitem[c]:setIconColor(Color.New(86,86,86,255));
--      end

--  end
  for i=1,len do
      selectdata = tjz_Data.openline[i].data;
      configdata = tjz_Config.line_config[tjz_Data.openline[i].line];
      datalen = #selectdata;
      for a=1,datalen do
        item = tjz_Data.allshowitem[configdata[a]+1];
        if selectdata[a] == 1 then
           fva = tjz_Data.selectImg[configdata[a]+1];           
           resimgconfig = tjz_Config.resimg_config[fva];
           item:setAnima(resimgconfig,false);
        end
      end
  end
end


--显示线
function tjz_LianLine.creatAllLine() 
  self.curShowLineIndex = 0;
  local openLineData = nil;
  local len = #tjz_Data.openline;
  local linelen = nil;
  local curpos = nil;
  local nextpos = nil;
  local iDirection = nil;
  for i=1,len do
      openLineData = tjz_Config.line_config[tjz_Data.openline[i].line];
      curpos = self.getpos(openLineData[1]);
      linelen = #openLineData;
      for a=2,linelen do
         nextpos = self.getpos(openLineData[a]);
         iDirection = math.abs(openLineData[a-1] - openLineData[a]);
         self.SetLine(false,curpos,nextpos,iDirection).transform.name = "line_"..tjz_Data.openline[i].line.."_"..a;
         curpos = Vector3.New(nextpos.x,nextpos.y,nextpos.z);
      end
  end  
end

--的到是全局坐标
function tjz_LianLine.getpos(index)
   local item = tjz_Data.allshowitem[index+1];
   return item:getPosint();
end

--设置线
--bShow 是否显示, traCurrentPoint 当前点, traNextPoint 下个点, iDirection 线的方向 -1直线 <0下斜线 >0上斜线
function tjz_LianLine.SetLine(bShow, traCurrentPoint, traNextPoint, iDirection)
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
