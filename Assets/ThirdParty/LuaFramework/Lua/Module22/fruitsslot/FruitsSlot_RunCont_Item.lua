FruitsSlot_RunCont_Item = {};
local self = FruitsSlot_RunCont_Item;

function FruitsSlot_RunCont_Item:new()
   local go = {};
   self.guikey = "cn";
   setmetatable(go,{__index = self});
   go.guikey = FruitsSlotEvent.guid();
   return go;
end
function FruitsSlot_RunCont_Item:init()
    
    self.showpercont = nil;
    self.showtabel = nil;
    self.curindex = 1;
    self.showdata = {};
    self.opendata = {};

    self.runpercont = nil;
    self.sonItem = nil;
    self.starty = -355;
    self.sh = 161;
    self.runtabel = nil;
    self.runh = 0;
    self.createnum = 0;
    self.runcontpos = nil;
    self.isrun = false;

    self.speed = -5;
    self.speedtimer = 0.5;
    self.lastjul = 0;

    self.iscom = false;
end

function FruitsSlot_RunCont_Item:runStop()    
    self.iscom = true;
end

function FruitsSlot_RunCont_Item:setOpenPos()
   local len = #self.runtabel-2;
   local pos = nil;
    for i=len,#self.runtabel do
         pos = self.runtabel[i].transform.localPosition;
         self.runtabel[i].transform.localPosition = Vector3.New(pos.x,pos.y - self.lastjul,pos.z);
    end
    self.lastjul = 0;
end

function FruitsSlot_RunCont_Item:setPer(runargs,showargs,cindex)
   self:init();
   self.curindex = cindex;
   self.runpercont = runargs;
   self.showpercont = showargs;
   local pos = self.runpercont.transform.localPosition;
   self.runcontpos = Vector3.New(pos.x,pos.y,pos.z);
   self.runtabel = {};
   self.showtabel = {};
   self.runpercont.gameObject:SetActive(false);
   self.showpercont.gameObject:SetActive(true);  
   self.showdata = FruitsSlot_Config.defalut_show_img[self.curindex];
   self.opendata = FruitsSlot_Config.defalut_show_img[self.curindex];
   self:addEvent();
end

function FruitsSlot_RunCont_Item:setSonItem(per)
    self.sonItem = per;
end

function FruitsSlot_RunCont_Item:addEvent()
   FruitsSlotEvent.addEvent(FruitsSlotEvent.game_over,FruitsSlotEvent.hander(self,self.gameOver),self.guikey);
end

function FruitsSlot_RunCont_Item:gameOver(args)
    if args.data~=nil and self.curindex~=args.data then
       return;
    end
    self.opendata = {};
    self.showdata = {};
    for i=1,3 do
        self.opendata[i] = FruitsSlot_Data.openimg[self.curindex+(3-i)*5];
        self.showdata[i] = FruitsSlot_Data.openimg[self.curindex+(3-i)*5];
    end  
    self:setOpenWin(); 
    self:setShow();
    coroutine.start(function()
       coroutine.wait(FruitsSlot_Config.runstoptimer_config[self.curindex]);
       self:runStop();
       coroutine.wait(0.6);
       if FruitsSlot_Socket.isongame == false then
          return;
       end
       FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_run_stop,false,false);
    end)
end

function FruitsSlot_RunCont_Item:randImg()
   local zunum = (self.createnum)/3;
   local config = nil;
   local sonfig = nil;
   local midindex = 1;
   local endindex = self.createnum;
   for i=1,zunum do
        if self.curindex==1 then
           config = self:randFun(FruitsSlot_Config.first_zurate);
        else
           config = self:randFun(FruitsSlot_Config.zurate);
        end
       if config~=0 then
           for i=1,3 do
               sonfig = self:randFun(FruitsSlot_Config[config.cfname]);
               if sonfig~=0 and midindex<=endindex then
                  self:setRunImg(self.runtabel[midindex],sonfig.cfname);
                  --self.runtabel[i].transform:Find("icon").gameObject:GetComponent("Image").sprite = FruitsSlot_Data.icon_res.transform:Find(sonfig.cfname).gameObject:GetComponent("Image").sprite;
                  midindex = midindex+1;
               end
           end
       end
   end
end

--设计显示
function FruitsSlot_RunCont_Item:setShow()
   local item = nil;
   local idata = nil;
   for i=1,3 do
       idata = self.opendata[i];
       item = self.showtabel[i];
       item:setImg(FruitsSlot_Config.resimg_config[idata].cfname);
   end
end

function FruitsSlot_RunCont_Item:setRunShow(args)
   local item = nil;
   local idata = nil;
   for i=1,3 do
       idata = self.opendata[i];
       item = self.runtabel[i];
       self:setRunImg(item,FruitsSlot_Config.resimg_config[idata].cfname);
       --item.transform:Find("icon").gameObject:GetComponent("Image").sprite = FruitsSlot_Data.icon_res.transform:Find(FruitsSlot_Config.resimg_config[idata].cfname).gameObject:GetComponent("Image").sprite;
   end
end

function FruitsSlot_RunCont_Item:startRun(ags)
   if self.curindex == 1  then
      FruitsSlot_Data.isruning = true;
   end
   self.speedtimer = 6;
   self.runpercont.gameObject:SetActive(true);
   self.showpercont.gameObject:SetActive(false);
   self.isrun = true;
end


--开奖结果
function FruitsSlot_RunCont_Item:setOpenWin()
   local item = nil;
   local idata = nil;
   local len = #self.runtabel;
   local dataindex = 1;
   for i=len-2,len do
       idata = self.opendata[dataindex];
       item = self.runtabel[i];
       self:setRunImg(item,FruitsSlot_Config.resimg_config[idata].cfname);
       --item.transform:Find("icon").gameObject:GetComponent("Image").sprite = FruitsSlot_Data.icon_res.transform:Find(FruitsSlot_Config.resimg_config[idata].cfname).gameObject:GetComponent("Image").sprite;
       dataindex = dataindex+1;
   end 
end

function FruitsSlot_RunCont_Item:randFun(randtabel)
    local reslut = 0;   
    local randnum = math.random(0,100);
	local beginIndex = math.random(1,#randtabel);
	local curindex ;
	for i=1,#randtabel do
		curindex = ((i+beginIndex)%#randtabel)+1;
		if randnum<=randtabel[curindex].rate then
			reslut = randtabel[curindex];
			return reslut;
        end
		randnum = randnum - randtabel[curindex].rate;
	end
	return reslut;
end

--生成里面的图片
function FruitsSlot_RunCont_Item:createSonItem(num)
   local item = nil;
   self.createnum = num;
   for i = 1,num do
      item = newobject(self.sonItem);
      item.transform:SetParent(self.runpercont.transform);
      item.transform.localScale = Vector3.New(1,1,1);
      item.transform.localPosition = Vector3.New(0,self.starty+(i-1)*self.sh,0);
      table.insert(self.runtabel,i,item);
      self.runh = self.starty+(i-1)*self.sh;
   end
   for a = 1,3 do
      item = FruitsSlot_Run_Soon_Item:new();
      item:setPer(self.sonItem,true);
      item:setParent(self.showpercont);
      item:setPoint(Vector3.New(0,self.starty+(a-1)*self.sh,0));
      --item:setCurIndex(self.curindex+(3-a)*5);
      item.itemname = self.curindex+(3-a)*5;
      table.insert(self.showtabel,a,item);
      FruitsSlot_Data.allshowitem[self.curindex+(3-a)*5] = item;
   end  
   self:randImg();   
   self:setShow();
   
end

function FruitsSlot_RunCont_Item:setRunImg(item,imgname)
   local itemimg = FruitsSlot_Data.icon_res.transform:Find(imgname).gameObject;
   local fsize = itemimg.gameObject:GetComponent("RectTransform").sizeDelta;
   item.transform:Find("icon").gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(fsize.x,fsize.y);
   item.transform:Find("icon").gameObject:GetComponent("Image").sprite = itemimg.gameObject:GetComponent("Image").sprite;
end

function FruitsSlot_RunCont_Item:deFault()
   local item = nil;
   for i = 1,self.createnum do
      item = self.runtabel[i];
      item.transform.localPosition = Vector3.New(0,self.starty+(i-1)*self.sh,0);
   end
end

function FruitsSlot_RunCont_Item:Update()
    if self.isrun == false then
       return;
    end
    if self.iscom == true then
       self:serverRun();
    else
       self:clientRun();
    end
    
end

function FruitsSlot_RunCont_Item:clientRun()
   local pos = nil;
    local py = 0;
    if self.speedtimer>8 then
       self.speedtimer = 8;
    else
        self.speedtimer = self.speedtimer+0.1;
    end
    local len = #self.runtabel-3;
    for i=1,len do
         pos = self.runtabel[i].transform.localPosition;
         py = pos.y + self.speed*self.speedtimer;
         if py< (self.starty -self.sh)  then
            py = self.starty+(len-1)*self.sh -(self.starty -self.sh -pos.y );
            self.lastjul = self.sh + (self.starty -self.sh -pos.y);
         end
         self.runtabel[i].transform.localPosition = Vector3.New(pos.x,py,pos.z);
    end
end

function FruitsSlot_RunCont_Item:serverRun()
   local pos = nil;
   local py = 0;
   if self.lastjul>0 then
      self:setOpenPos();
   end
   if self.runtabel[#self.runtabel].transform.localPosition.y<500 then
      self.speedtimer = self.speedtimer-0.1;
      if self.speedtimer<0.2 then
         self.speedtimer = 0.2;
      end
   else
        if self.speedtimer>8 then
         self.speedtimer = 8;
      else
         self.speedtimer = self.speedtimer+0.1;
      end
   end
    py = self.speed*self.speedtimer;
    if (self.runtabel[#self.runtabel].transform.localPosition.y+py)<= (self.starty +self.sh*2) then
       py = self.starty +self.sh*2 - self.runtabel[#self.runtabel].transform.localPosition.y;
       self.isrun = false;
       self.iscom = false;       
    end
    local len = #self.runtabel;
    for i=1,len do
         pos = self.runtabel[i].transform.localPosition;
         self.runtabel[i].transform.localPosition = Vector3.New(pos.x,pos.y+py,pos.z);
    end
    if self.isrun == false then
       self.runpercont.gameObject:SetActive(false);
       self.showpercont.gameObject:SetActive(true);
       self:deFault();
       self:randImg();
       self:setRunShow();       
       if self.curindex==5 then
          FruitsSlot_Data.isruning = false;
          FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_run_com);
       end
    end

end

