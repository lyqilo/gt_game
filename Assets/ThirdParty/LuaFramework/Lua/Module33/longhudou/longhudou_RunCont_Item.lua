longhudou_RunCont_Item = {};
local self = longhudou_RunCont_Item;

function longhudou_RunCont_Item:new()
   local go = {};
   self.guikey = "cn";
   setmetatable(go,{__index = self});
   go.guikey = longhudou_Event.guid();
   return go;
end
function longhudou_RunCont_Item:init()
    
    self.showpercont = nil;
    self.showtabel = nil;
    self.curindex = 1;
    self.showdata = {};
    self.opendata = {};

    self.runpercont = nil;
    self.sonItem = nil;
    self.runSonItem = nil;
    self.starty = -294;
    self.sh = 142;
    self.runtabel = nil;
    self.runh = 0;
    self.createnum = 0;
    self.runcontpos = nil;
    self.isrun = false;

    self.speed = -5;
    self.speedtimer = 0.5;
    self.lastjul = 0;
    self.maxtimer = 12;
    self.jiantimer = 0.4;
    self.runStopLen = 0;
    self.iscom = false;
    self.isfreesound =false;
    self.playStop = false;

end

function longhudou_RunCont_Item:runStop()    
    self.iscom = true;
end

function longhudou_RunCont_Item:setOpenPos()
   local len = #self.runtabel-2;
   local pos = nil;
    for i=len,#self.runtabel do
         pos = self.runtabel[i].transform.localPosition;
         --error("____setOpenPos____"..(pos.y - self.lastjul).."____"..self.curindex);
         self.runtabel[i].transform.localPosition = Vector3.New(pos.x,pos.y - self.lastjul,pos.z);
    end
    self.lastjul = 0;
end

function longhudou_RunCont_Item:setPer(runargs,showargs,cindex,lihuosp)
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
   self.showdata = longhudou_Config.defalut_show_img[self.curindex];
   self.opendata = longhudou_Config.defalut_show_img[self.curindex];
   self:addEvent();
end

function longhudou_RunCont_Item:setSonItem(per,runitem)
    self.sonItem = per;
    self.runSonItem = runitem;
end

function longhudou_RunCont_Item:addEvent()
    longhudou_Event.addEvent(longhudou_Event.xiangqi_over,longhudou_Event.hander(self,self.gameOver),self.guikey);
    longhudou_Event.addEvent(longhudou_Event.xiangqi_two_reflush_over,longhudou_Event.hander(self,self.twoFlushData),self.guikey);
    
end

function longhudou_RunCont_Item:gameOver(args)
    if args.data~=nil and self.curindex~=args.data.curindex then
       return;
    end
    if args.data.curindex>1 then
       --return;
    end
    self.maxtimer = args.data.maxtimer;
    self.jiantimer = args.data.jiantimer;
    local waittime = longhudou_Config.runstoptimer_config[self.curindex];
    if self.maxtimer>8 then
        longhudou_Socket.playaudio("freespeed",false,false);
        waittime = waittime/2; 
    end
    self.opendata = {};
    self.showdata = {};
    local openimg = nil;
    self.isfreesound =false;
    self.playStop = false;
    for i=1,3 do
        openimg =  longhudou_Data.openImg[self.curindex+(3-i)*5];
        self.opendata[i] = openimg;
        self.showdata[i] = openimg;
        if openimg == longhudou_Config.tiger then
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

function longhudou_RunCont_Item:twoFlushData()
    self.opendata = {};
    local openimg = nil;
    for i=1,3 do
        openimg =  longhudou_Data.openImg[self.curindex+(3-i)*5];
        self.opendata[i] = openimg;
    end  
    self:setShow(true);
end

function longhudou_RunCont_Item:randImg()
   local num = self.createnum;
   local config = nil;
   local sonfig = nil;
   local midindex = 1;
   local endindex = self.createnum;
   config = nil;
   if longhudou_Data.byFreeCnt==0 then
      config = longhudou_Config.rand_1;
   else
     config = longhudou_Config.rand_2;
   end
   for i=midindex,endindex do
     sonfig = self:randFun(config);
     if sonfig==nil then
     end
       if sonfig~=0 then
          self:setRunImg(self.runtabel[i],longhudou_Config.resimg_config[sonfig.src].normalimg);
       end 
   end
end

--设计显示
function longhudou_RunCont_Item:setShow(istwoflush)
   local item = nil;
   local idata = nil;
   for i=1,3 do
       idata = self.opendata[i];
       item = self.showtabel[i];
       item:setImg(longhudou_Config.resimg_config[idata].normalimg,istwoflush,idata,i);
   end
end

function longhudou_RunCont_Item:setRunShow(args)
   local item = nil;
   local idata = nil;
   for i=1,3 do
       idata = self.opendata[i];
       item = self.runtabel[i];
       self:setRunImg(item,longhudou_Config.resimg_config[idata].normalimg);
   end
end

function longhudou_RunCont_Item:startRun(ags)
   if self.curindex == 1  then
      longhudou_Data.isruning = true;
   end
    self.lastjul = 0;
    self.maxtimer = 7;
    self.jiantimer = 0.4;
    self.speedtimer = 6;
    self.runpercont.gameObject:SetActive(true);
    self.showpercont.gameObject:SetActive(false);
    self.isrun = true;
end


--开奖结果
function longhudou_RunCont_Item:setOpenWin()
   local item = nil;
   local idata = nil;
   local len = #self.runtabel;
   local dataindex = 1;
   for i=len-2,len do
       idata = self.opendata[dataindex];
       item = self.runtabel[i];
       self:setRunImg(item,longhudou_Config.resimg_config[idata].normalimg);
       dataindex = dataindex+1;
   end 
end

function longhudou_RunCont_Item:randFun(randtabel)
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
function longhudou_RunCont_Item:createSonItem(num)
   local item = nil;
   self.createnum = num;
   for i = 1,num do
      item = newobject(self.runSonItem);
      item.transform:SetParent(self.runpercont.transform);
      item.transform.localScale = Vector3.New(1,1,1);
      item.transform.localPosition = Vector3.New(0,self.starty+(i-1)*self.sh,0);
      table.insert(self.runtabel,i,item);
      self.runh = self.starty+(i-1)*self.sh;
   end
   self:creatOneSoonItem(1); 
   self:creatOneSoonItem(3); 
   self:creatOneSoonItem(2); 
   self:randImg();   
   self:setShow();
   self:setRunShow(); 
end

function longhudou_RunCont_Item:creatOneSoonItem(a)
    local item = nil;
    item = longhudou_Run_Soon_Item:new();
    item:setPer(self.sonItem,true,a);
    item:setParent(self.showpercont);
    item:setPoint(Vector3.New(0,self.starty+(a-1)*self.sh,0));
    table.insert(self.showtabel,a,item);
    longhudou_Data.allshowitem[self.curindex+(3-a)*5] = item;
end

function longhudou_RunCont_Item:setRunImg(item,imgname)
   local itemimg = nil;
   if longhudou_Data.icon_res==nil then
      itemimg = longhudou_Data.numres.transform:Find(imgname).gameObject;
   else
      itemimg = longhudou_Data.icon_res.transform:Find(imgname).gameObject;
   end
   local fsize = itemimg.gameObject:GetComponent("RectTransform").sizeDelta;
   item.transform:Find("icon").gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(fsize.x,fsize.y);
   item.transform:Find("icon").gameObject:GetComponent("Image").sprite = itemimg.gameObject:GetComponent("Image").sprite;
end

function longhudou_RunCont_Item:deFault()
   local item = nil;
   for i = 1,self.createnum do
      item = self.runtabel[i];      
      item.transform.localPosition = Vector3.New(0,self.starty+(i-1)*self.sh,0);
   end
end

function longhudou_RunCont_Item:Update()
   if self.isrun == false then
       return;
    end
    if self.iscom == true then
       self:serverRun();
    else
       self:clientRun();
    end
end

function longhudou_RunCont_Item:clientRun()
    local pos = nil;
    local py = 0;
    if self.speedtimer>self.maxtimer then
       self.speedtimer = self.maxtimer;
    else
        self.speedtimer = self.speedtimer+self.jiantimer;
    end
    local len = #self.runtabel-3;
    local jul = 0;
    for i=1,len do
         pos = self.runtabel[i].transform.localPosition;
         py = pos.y + self.speed*self.speedtimer;         
         if py< (self.starty -self.sh)  then
            py = self.starty+(len-1)*self.sh - (self.starty -self.sh  - py);
            --error("___py__"..py.."____"..self.lastjul.."____"..self.curindex);
            --self.lastjul = self.sh + (self.starty -self.sh  - py);
            if longhudou_Data.istihuan==true and longhudou_Data.isPalyFreeAnima==false then
               self:replaceImg(i);
            end
            self.runtabel[i].transform.localPosition = Vector3.New(pos.x,py,pos.z);
         else
           if py<self.starty then
              jul = math.max(jul,self.starty-py);
           end
           self.runtabel[i].transform.localPosition = Vector3.New(pos.x,py,pos.z);
         end
    end
    self.lastjul = jul;
end

function longhudou_RunCont_Item:replaceImg(args)
  if args==4 and self.curindex==5 then
     longhudou_Data.istihuan=false;
  end
  local randnum = math.random(1,#longhudou_Config.rand_2);
  self:setRunImg(self.runtabel[args],longhudou_Config.resimg_config[longhudou_Config.rand_2[randnum].src].normalimg);
end

function longhudou_RunCont_Item:serverRun()
   local pos = nil;
   local py = 0;  
    if self.isrun == false then
       return;
    end
    if self.runStopLen == 0 then
        if self.speedtimer>self.maxtimer then
           if self.lastjul>0 then
              --error("___serverRun__setOpenPos_"..self.lastjul)
              self:setOpenPos();
           end
           if true then
             -- return;
           end
           self.runStopLen = self.runtabel[#self.runtabel].transform.localPosition.y;
        else
           self:clientRun();
           return;
        end
    end
    if self.runStopLen>0 then
       if self.runStopLen>self.maxtimer then
          py = math.min(math.abs(self.speed*self.maxtimer),self.runStopLen/3);
          self.runStopLen = self.runStopLen - py;          
       else
           py = self.runStopLen;
           self.isrun = false;
           self.iscom = false;
       end 
       if self.runStopLen<100 then
           if self.playStop == false then
              self.playStop = true;
              if self.isfreesound==true and longhudou_Data.istssound==true then
                  longhudou_Socket.playaudio("freeiconstop",false,false);
               else
                  longhudou_Socket.playaudio("normalstop",false,false);
              end               
           end
       end      
    end
    local len = #self.runtabel;
    for i=1,len do
         pos = self.runtabel[i].transform.localPosition;
         --error("________Vector3________");
         self.runtabel[i].transform.localPosition = Vector3.New(pos.x,pos.y-py,pos.z);
    end
    if self.isrun == false then
       self.runpercont.gameObject:SetActive(false);
       self.showpercont.gameObject:SetActive(true);
       self:deFault();
       self:randImg();
       self:setRunShow(); 
      
       --error("__0000___self.curindex____"..self.curindex);      
       if self.curindex==5 then
           --error("__111___self.curindex____"..self.curindex);     
          longhudou_Data.isruning = false;
       end
        longhudou_Event.dispathEvent(longhudou_Event.xiongm_run_com,self.curindex);
    end
end

