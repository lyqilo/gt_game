xiangqi_TSAnima = {};
local self = xiangqi_TSAnima;

function xiangqi_TSAnima.init()
   self.isShowLineAnima = false;
   self.showLineTimer = 2;
   self.showLineCurTimer = 0;
   self.curShowLineIndex = 0;
   self.guikey = "cn";
   self.showWinItem = nil;
   self.tischoum = nil;--下注金额的提示
end

function xiangqi_TSAnima.setPer(args)
   self.init();
   self.guikey = xiangqi_Event.guid();
   self.showWinItem = args.transform:Find("bottomcont/wintsanimacont/itemcont");
   self.tischoum = args.transform:Find("bottomcont/wintsanimacont/tischoum");
   self.showWinItem.gameObject:SetActive(false);
   self.addEvent();
   self.gameInit();
end

function xiangqi_TSAnima.addEvent()
   xiangqi_Event.addEvent(xiangqi_Event.xiongm_show_line_anima,self.showLineAnima,self.guikey);
   xiangqi_Event.addEvent(xiangqi_Event.xiongm_colse_line_anima,self.closeLineAnima,self.guikey);  
   xiangqi_Event.addEvent(xiangqi_Event.xiongm_choum_chang,self.choumChangHander,self.guikey); 
   xiangqi_Event.addEvent(xiangqi_Event.xiongm_init,self.gameInit,self.guikey);
end

function xiangqi_TSAnima.gameInit(args)
   self.tischoum.transform:Find("showchoum").gameObject:GetComponent("Text").text = "投注金额："..xiangqi_Data.curSelectChoum;
end

function xiangqi_TSAnima.choumChangHander(arg)
   self.closeLineAnima();
   self.noShowLine();
   self.gameInit();
end
function xiangqi_TSAnima.noShowLine()
  len = #xiangqi_Data.allshowitem;
  for a=1,len do
      item = xiangqi_Data.allshowitem[a];
      item:stopPlaySelctAnima();
  end  
end

function xiangqi_TSAnima.showLineAnima(args)
   if #xiangqi_Data.openWinImg<=0 then
      --error("___000_showLineAnima____");
      return;
   end
   self.isShowLineAnima = true;
   self.showLineCurTimer = self.showLineTimer;
   self.curShowLineIndex = 0;
end

function xiangqi_TSAnima.closeLineAnima(args)
   self.isShowLineAnima = false;
   self.showLineCurTimer = 0;
   self.curShowLineIndex = 0;
   self.showWinItem.gameObject:SetActive(false);
   self.tischoum.gameObject:SetActive(true);
   
end

function xiangqi_TSAnima.playShowLineAnima(args)
   self.noShowLine();
   self.curShowLineIndex = self.curShowLineIndex+1;
   if self.curShowLineIndex>#xiangqi_Data.openWinImg then    
      self.curShowLineIndex = 1;
     -- error("_111____playShowLineAnima_____");     
   end   
  local selectdata = xiangqi_Data.openWinImg[self.curShowLineIndex];
  local len = #xiangqi_Data.allshowitem;
  local item = nil;
  local isshowgold = false;
  for c=1,len do
      if self.repCol(c)<=selectdata.byKey and selectdata.byIcon~=xiangqi_Config.general then 
         if xiangqi_Data.openImg[c]==selectdata.byIcon then
            xiangqi_Data.allshowitem[c]:setAnima(xiangqi_Config.resimg_config[selectdata.byIcon],false);
         elseif xiangqi_Data.openImg[c]==xiangqi_Config.king then
            xiangqi_Data.allshowitem[c]:setAnima(xiangqi_Config.resimg_config[xiangqi_Config.king],false);
         end
       elseif selectdata.byIcon==xiangqi_Config.general then
         if xiangqi_Data.openImg[c]==selectdata.byIcon then
            xiangqi_Data.allshowitem[c]:setAnima(xiangqi_Config.resimg_config[selectdata.byIcon],false);
         end 
      end
  end
  for c=1,len do
      if self.repCol(c)<=selectdata.byKey and selectdata.byIcon~=xiangqi_Config.general and (xiangqi_Data.openImg[c]==selectdata.byIcon or xiangqi_Data.openImg[c]==xiangqi_Config.king) then
         xiangqi_Data.allshowitem[c]:playAnima();
         isshowgold = true;
      elseif selectdata.byIcon==xiangqi_Config.general then
        if xiangqi_Data.openImg[c]==selectdata.byIcon then
            xiangqi_Data.allshowitem[c]:playAnima();
            isshowgold = true;
        end 
      end
  end
  if isshowgold==true then
     self.showWinTs(selectdata);     
  end
end
function xiangqi_TSAnima.showWinTs(opendata)
   self.showWinItem.gameObject:SetActive(true);
   self.tischoum.gameObject:SetActive(false);   
   self.showWinItem.transform:Find("num").gameObject:GetComponent("Text").text = opendata.byKey.."连";
   self.showWinItem.transform:Find("icon").gameObject:GetComponent("Image").sprite = xiangqi_Data.icon_res.transform:Find(xiangqi_Config.resimg_config[opendata.byIcon].normalimg.."_small").gameObject:GetComponent("Image").sprite;
   self.showWinItem.transform:Find("goldnum").gameObject:GetComponent("Text").text = "赢"..opendata.bymoney.."(×"..opendata.byCnt..")";
end
--数字转换成列
function xiangqi_TSAnima.repCol(args)
   local renum = args%5;
   if renum==0 then
      return 5;
   end
   return renum;
end

function xiangqi_TSAnima.Update()
   if self.isShowLineAnima==true then
      self.showLineCurTimer = self.showLineCurTimer+Time.deltaTime;
      if self.showLineCurTimer>=self.showLineTimer then
         self.showLineCurTimer = 0;
         self.playShowLineAnima();
      end
   end
end