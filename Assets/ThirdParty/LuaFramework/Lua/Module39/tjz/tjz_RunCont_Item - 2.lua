tjz_RunCont_Item = {};
local self = tjz_RunCont_Item;

function tjz_RunCont_Item:new()
   local go = {};
   self.guikey = "cn";
   setmetatable(go,{__index = self});
   go.guikey = tjz_Event.guid();
   return go;
end
function tjz_RunCont_Item:init()
    
    self.showpercont = nil;
    self.showtabel = nil;
    self.curindex = 1;
    self.showdata = {};
    self.opendata = {};

    self.runpercont = nil;
    self.sonItem = nil;
    self.starty = -300;
    self.sh = 141;
    self.runtabel = nil;
    self.runh = 0;
    self.createnum = 0;
    self.runcontpos = nil;
    self.isrun = false;

    self.speed = 1;
    self.speedtimer = 0.5;
    self.lastjul = 0;
    self.maxtimer = 12;
    self.jiantimer = 0.4;
    self.runStopLen = 0;
    self.iscom = false;

end

function tjz_RunCont_Item:runStop()    
    self.iscom = true;
end

function tjz_RunCont_Item:setOpenPos()
   local len = #self.runtabel-2;
   local pos = nil;
    for i=len,#self.runtabel do
         pos = self.runtabel[i].transform.localPosition;
         self.runtabel[i].transform.localPosition = Vector3.New(pos.x,pos.y - self.lastjul,pos.z);
    end
    error("____setOpenPos_____"..self.lastjul);
    self.lastjul = 0;
end

function tjz_RunCont_Item:setPer(runargs,showargs,cindex)
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
   self.showdata = tjz_Config.defalut_show_img[self.curindex];
   self.opendata = tjz_Config.defalut_show_img[self.curindex];
   self:addEvent();    
end

function tjz_RunCont_Item:setSonItem(per)
    self.sonItem = per;
end

function tjz_RunCont_Item:addEvent()
    tjz_Event.addEvent(tjz_Event.xiongm_over,tjz_Event.hander(self,self.gameOver),self.guikey);
end

function tjz_RunCont_Item:gameOver(args)
   if args.data~=nil and self.curindex~=args.data.curindex then
       return;
    end
    self.maxtimer = args.data.maxtimer;
    self.jiantimer = args.data.jiantimer;
    local waittime = tjz_Config.runstoptimer_config[self.curindex];
    if self.maxtimer>10 then
        tjz_Socket.playaudio("speed",false,false);
        waittime = waittime/2; 
    end
    self.opendata = {};
    self.showdata = {};
    local openimg = nil;
    self.isfreesound =false;
    self.playStop = false;
    for i=1,3 do
        openimg =  tjz_Data.selectImg[self.curindex+(3-i)*5];
        self.opendata[i] = openimg;
        self.showdata[i] = openimg;
        if openimg == tjz_Config.scatter then
           self.isfreesound =true;
        end
    end  

    self:setOpenWin(); 
    self:setShow();
     coroutine.start(function()
        coroutine.wait(waittime);
        self.runStopLen = 0;
        self:runStop();
    end)
end

function tjz_RunCont_Item:randImg()
   local num = self.createnum;
   local config = nil;
   local sonfig = nil;
   local midindex = 1;
   local endindex = self.createnum;
   config = tjz_Config.rand_1;
   for i=midindex,endindex do
     sonfig = self:randFun(config);
     if sonfig==nil then
     end
       if sonfig~=0 then
          self:setRunImg(self.runtabel[i],tjz_Config.resimg_config[sonfig.src].normalimg);
       end 
   end
end

--设计显示
function tjz_RunCont_Item:setShow()
   local item = nil;
   local idata = nil;
   for i=1,3 do
       idata = self.opendata[i];
       item = self.showtabel[i];
       item:setImg(tjz_Config.resimg_config[idata].normalimg);
   end
end

function tjz_RunCont_Item:playScatter()
    local num = tjz_Data.countScatter(self.curindex);
    if num>2 or (5-self.curindex+num)>2 then
        local item = nil;
        local openimg = nil;
        for i=1,3 do
            openimg =  tjz_Data.selectImg[self.curindex+(3-i)*5];
            if openimg == tjz_Config.scatter then
               item = self.showtabel[i];
               item:setAnima(tjz_Config.resimg_config[tjz_Config.scatter],false);
               item:playAnima();
            end
        end  
    end
end

function tjz_RunCont_Item:setRunShow(args)
   local item = nil;
   local idata = nil;
   for i=1,3 do
       idata = self.opendata[i];
       item = self.runtabel[i];
       self:setRunImg(item,tjz_Config.resimg_config[idata].normalimg);
   end
end

function tjz_RunCont_Item:startRun(ags)
   if self.curindex == 1  then
      tjz_Data.isruning = true;
      if (tjz_Data.bFireMode==false or tjz_Data.bFireCom==true) and tjz_Data.byFreeCnt==0  then
         tjz_Socket.playaudio("runstart"); 
      end
   end
    self.lastjul = 0;
    self.maxtimer = 10;
    self.jiantimer = 0.4;
    self.speedtimer = 8;
    self.runpercont.gameObject:SetActive(true);
    self.showpercont.gameObject:SetActive(false);
    self.isrun = true;
end


--开奖结果
function tjz_RunCont_Item:setOpenWin()
   local item = nil;
   local idata = nil;
   local len = #self.runtabel;
   local dataindex = 1;
   for i=len-2,len do
       idata = self.opendata[dataindex];
       item = self.runtabel[i];
       self:setRunImg(item,tjz_Config.resimg_config[idata].normalimg);
       dataindex = dataindex+1;
   end 
end

function tjz_RunCont_Item:randFun(randtabel)
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
function tjz_RunCont_Item:createSonItem(num)
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
      item = tjz_Run_Soon_Item:new();
      item:setPer(self.sonItem,true);
      item:setParent(self.showpercont);
      item:setPoint(Vector3.New(0,self.starty+(a-1)*self.sh,0));
      table.insert(self.showtabel,a,item);
      tjz_Data.allshowitem[self.curindex+(3-a)*5] = item;
   end  
   self:randImg();   
   self:setShow();
   self:setRunShow(); 
end

function tjz_RunCont_Item:setRunImg(item,imgname)
   local itemimg = tjz_Data.icon_res.transform:Find(imgname).gameObject;
   local fsize = itemimg.gameObject:GetComponent("RectTransform").sizeDelta;
   item.transform:Find("icon").gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(fsize.x,fsize.y);
   item.transform:Find("icon").gameObject:GetComponent("Image").sprite = itemimg.gameObject:GetComponent("Image").sprite;
end

function tjz_RunCont_Item:deFault()
   local item = nil;
   for i = 1,self.createnum do
      item = self.runtabel[i];
      item.transform.localPosition = Vector3.New(0,self.starty+(i-1)*self.sh,0);
   end
end

function tjz_RunCont_Item:Update()
    if self.isrun == false then
       return;
    end
    if self.iscom == true  then
       self:serverRun();
    else
       self:clientRun();
    end
    
end

function tjz_RunCont_Item:clientRun()
    local pos = nil;
    local py = 0;
    if self.speedtimer>self.maxtimer then
       self.speedtimer = self.maxtimer;
    else
        self.speedtimer = self.speedtimer+self.jiantimer;
    end
    local len = #self.runtabel-3;
    local toppos = self.starty+(len-1)*self.sh;
    local maxpos = 0;
    --error("_______clientRun________"..toppos);
    for i=1,len do
         pos = self.runtabel[i].transform.localPosition;
         py = pos.y + self.speed*self.speedtimer;
--         if py< (self.starty -self.sh)  then
--            py = self.starty+(len-1)*self.sh -(self.starty -self.sh -pos.y );
--            self.lastjul = self.sh + (self.starty -self.sh -pos.y);
--         end
         if py > toppos then
            py = self.starty-self.sh -(toppos -pos.y );
            self.lastjul = self.sh-(toppos -pos.y);
            --self.lastjul = 0;
         end
         if py > maxpos then
            maxpos = py;
         end
         self.runtabel[i].transform.localPosition = Vector3.New(pos.x,py,pos.z);
    end
    self.lastjul = toppos-maxpos;
end

function tjz_RunCont_Item:serverRun()
--   local pos = nil;
--   local py = 0;
--   if self.lastjul>0 then
--      self:setOpenPos();
--   end
--   if self.runtabel[#self.runtabel].transform.localPosition.y<1500 then
--      self.speedtimer = self.speedtimer-self.speedtimer/30;
--      if self.speedtimer<0.2 then
--         self.speedtimer = 0.2;
--      end
--   else
--        if self.speedtimer>8 then
--         self.speedtimer = 8;
--      else
--         self.speedtimer = self.speedtimer+0.1;
--      end
--   end
--    py = self.speed*self.speedtimer;
--    if (self.runtabel[#self.runtabel].transform.localPosition.y+py)<= (self.starty +self.sh*2) then
--       py = self.starty +self.sh*2 - self.runtabel[#self.runtabel].transform.localPosition.y;
--       self.isrun = false;
--       self.iscom = false;
--       tjz_Socket.playaudio("runstop"); 
--    end
--    local len = #self.runtabel;
--    for i=1,len do
--         pos = self.runtabel[i].transform.localPosition;
--         self.runtabel[i].transform.localPosition = Vector3.New(pos.x,pos.y+py,pos.z);
--    end
--    if self.isrun == false then
--       self.runpercont.gameObject:SetActive(false);
--       self.showpercont.gameObject:SetActive(true);
--       self:deFault();
--       self:randImg();
--       self:setRunShow(); 
--       if self.curindex==1 then
--            tjz_Socket.showLiehuo();
--       end      
--       if self.curindex==5 then
--          tjz_Data.isruning = false;
--          tjz_Event.dispathEvent(tjz_Event.xiongm_run_com);
--       end
--    end


   local pos = nil;
   local py = 0;  
    if self.isrun == false then
       return;
    end
    if self.runStopLen == 0 then
        if self.speedtimer>self.maxtimer then
           if self.lastjul>0 then
              self:setOpenPos();
           end
            self.isrun = false;
           if self.isrun == false then
       return;
    end
            local maxpos = self.runtabel[#self.runtabel].transform.localPosition.y;
           local numpos = self.starty+(self.createnum-1)*self.sh;
           self.runStopLen = (self.createnum+3)*self.sh+(numpos-maxpos);
           --self.runStopLen = self.runtabel[1].transform.localPosition.y;
        else
           self:clientRun();
           return;
        end
    end
    if self.runStopLen>0 then
       if self.runStopLen>self.maxtimer then
          --py = math.min(math.abs(self.speed*self.maxtimer),self.runStopLen/2.5);
          py = math.abs(self.speed*self.maxtimer);
          self.runStopLen = self.runStopLen - py;          
       else
           py = self.runStopLen;
           self.isrun = false;
           self.iscom = false;
       end 
       if self.runStopLen<2 then
           if self.playStop == false then
              self.playStop = true;
              if self.isfreesound==true then
                  tjz_Socket.playaudio("runfreestop",false,false);
               else
                  tjz_Socket.playaudio("runnorstop",false,false);
               end               
           end
       end      
    end
    local len = #self.runtabel;
    local toppos = self.starty+(len-1)*self.sh;
    local npos = 0;
    for i=1,len do
         pos = self.runtabel[i].transform.localPosition;
         npos = pos.y+py;
         if npos > toppos then
            npos = self.starty-self.sh -(toppos -pos.y );
         end
         self.runtabel[i].transform.localPosition = Vector3.New(pos.x,npos,pos.z);
    end
    if self.isrun == false then
--       self.runpercont.gameObject:SetActive(false);
--       self.showpercont.gameObject:SetActive(true);
--       self:deFault();
--       self:randImg();
--       self:setRunShow();
--       self:playScatter();
--       if self.curindex==5 then
--          tjz_Data.isruning = false;
--       end
--        tjz_Event.dispathEvent(tjz_Event.xiongm_run_com,self.curindex);
    end



end

