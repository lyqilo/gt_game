longhudou_TSAnima = {};
local self = longhudou_TSAnima;

function longhudou_TSAnima.init()
   self.isShowLineAnima = false;
   self.showLineTimer = 2;
   self.showLineCurTimer = 0;
   self.curShowLineIndex = 0;
   self.guikey = "cn";
   self.showWinItem = nil;
   self.tischoum = nil;--下注金额的提示
end

function longhudou_TSAnima.setPer(args)
   self.init();
   self.guikey = longhudou_Event.guid();
   self.showWinItem = args.transform:Find("bottomcont/wintsanimacont/itemcont");
   self.tischoum = args.transform:Find("bottomcont/wintsanimacont/tischoum");
   self.showWinItem.gameObject:SetActive(false);
   self.tischoum.gameObject:SetActive(false);
   self.addEvent();
   self.gameInit();
end

function longhudou_TSAnima.addEvent()
   longhudou_Event.addEvent(longhudou_Event.xiongm_show_line_anima,self.showLineAnima,self.guikey);
   longhudou_Event.addEvent(longhudou_Event.xiongm_colse_line_anima,self.closeLineAnima,self.guikey);  
   longhudou_Event.addEvent(longhudou_Event.xiongm_choum_chang,self.choumChangHander,self.guikey); 
   longhudou_Event.addEvent(longhudou_Event.xiongm_init,self.gameInit,self.guikey);
end

function longhudou_TSAnima.gameInit(args)
   self.tischoum.transform:Find("showchoum").gameObject:GetComponent("Text").text = "单注:"..longhudou_Data.curSelectChoum;
end

function longhudou_TSAnima.choumChangHander(arg)
   self.closeLineAnima();
   self.noShowLine();
   self.gameInit();
end
function longhudou_TSAnima.noShowLine()
  len = #longhudou_Data.allshowitem;
  for a=1,len do
      item = longhudou_Data.allshowitem[a];
      item:stopPlaySelctAnima();
  end  
end

function longhudou_TSAnima.showLineAnima(args)
   if #longhudou_Data.openWinImg<=0 then
      error("___000_showLineAnima____");
      return;
   end
   self.isShowLineAnima = true;
   self.showLineCurTimer = self.showLineTimer;
   self.curShowLineIndex = 0;
end

function longhudou_TSAnima.closeLineAnima(args)
   self.isShowLineAnima = false;
   self.showLineCurTimer = 0;
   self.curShowLineIndex = 0;
   self.showWinItem.gameObject:SetActive(false);
   --self.tischoum.gameObject:SetActive(true);
   
end

function longhudou_TSAnima.playShowLineAnima(args)
   self.noShowLine();
   self.curShowLineIndex = self.curShowLineIndex+1;
   if self.curShowLineIndex>#longhudou_Data.openWinImg then    
      self.curShowLineIndex = 1;
     -- error("_111____playShowLineAnima_____");     
   end   
  local selectdata = longhudou_Data.openWinImg[self.curShowLineIndex];
  local len = #longhudou_Data.allshowitem;
  local item = nil;
  local isshowgold = false;
  logYellow("-----======selectdata=====------")
  logTable(selectdata)
  for c=1,len do
      if self.repCol(c)<=selectdata.byKey and selectdata.byIcon~=longhudou_Config.tiger then 
         if longhudou_Data.openImg[c]==selectdata.byIcon then
            longhudou_Data.allshowitem[c]:setAnima(longhudou_Config.resimg_config[selectdata.byIcon],false);
         elseif longhudou_Config.isWild(longhudou_Data.openImg[c])==true then
            longhudou_Data.allshowitem[c]:setAnima(longhudou_Config.resimg_config[longhudou_Data.openImg[c]],false);
         end
       elseif selectdata.byIcon==longhudou_Config.tiger then
         if longhudou_Data.openImg[c]==selectdata.byIcon then
            longhudou_Data.allshowitem[c]:setAnima(longhudou_Config.resimg_config[selectdata.byIcon],false);
         end 
      end
  end
  for c=1,len do
      if self.repCol(c)<=selectdata.byKey and selectdata.byIcon~=longhudou_Config.tiger and (longhudou_Data.openImg[c]==selectdata.byIcon or longhudou_Config.isWild(longhudou_Data.openImg[c])==true) then
         longhudou_Data.allshowitem[c]:playAnima();
         isshowgold = true;
      elseif selectdata.byIcon==longhudou_Config.tiger then
        if longhudou_Data.openImg[c]==selectdata.byIcon then
            longhudou_Data.allshowitem[c]:playAnima();
            isshowgold = false;
        end 
      end
  end
  if isshowgold==true then
     self.showWinTs(selectdata);     
  end
end
function longhudou_TSAnima.showWinTs(opendata)
   if opendata.byKey==0 then
      return false;
   end
   --self.showWinItem.gameObject:SetActive(true);
   --self.tischoum.gameObject:SetActive(false);   
   --self.showWinItem.transform:Find("num").gameObject:GetComponent("Text").text = opendata.byKey.."连";
   --self.showWinItem.transform:Find("icon").gameObject:GetComponent("Image").sprite = longhudou_Data.icon_res.transform:Find(longhudou_Config.resimg_config[opendata.byIcon].normalimg.."_small").gameObject:GetComponent("Image").sprite;
   --local w,ax =  longhudou_PushFun.CreatShowNum(self.showWinItem.transform:Find("goldnum").gameObject,opendata.bymoney,"xiaoshuz _",false,82,1,430,107);
   --longhudou_PushFun.CreatShowNum(self.showWinItem.transform:Find("byCntcont/numcont").gameObject,opendata.byCnt,"xiaoshuz _",false,82,1,430,76);
   --self.showWinItem.transform:Find("byCntcont").transform.localPosition = Vector3.New(w+ax,0,0);
end
--数字转换成列
function longhudou_TSAnima.repCol(args)
   local renum = args%5;
   if renum==0 then
      return 5;
   end
   return renum;
end

function longhudou_TSAnima.Update()
   if self.isShowLineAnima==true then
      self.showLineCurTimer = self.showLineCurTimer+Time.deltaTime;
      if self.showLineCurTimer>=self.showLineTimer then
         self.showLineCurTimer = 0;
         self.playShowLineAnima();
      end
   end
end