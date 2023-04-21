gongfupanda_RunCont_Item = {}
local self = gongfupanda_RunCont_Item;

function gongfupanda_RunCont_Item:new()
   local go = {};
   self.guikey = "cn";
   setmetatable(go,{__index = self});
   go.guikey = gongfupanda_Event.guid();
   return go;
end
function gongfupanda_RunCont_Item:init()
    self.runpercont = nil;
    self.showpercont = nil;
    self.sonItem = nil;
    self.starty = -340;
    self.sh = 175;
    self.runtabel = nil;
    self.showtabel = nil;
    self.runh = 0;
    self.showdata = {};
    self.opendata = {};
    self.createnum = 0;
    self.runcontpos = nil;
    self.curindex = 1;
    self.lihuoAnima = nil;
end

function gongfupanda_RunCont_Item:setPer(runargs,showper,index,lihuosp)
   self:init();
   self.runpercont = runargs;
   self.showpercont = showper;
   self.curindex = index;
   self.lihuoAnima = lihuosp.gameObject:AddComponent(typeof(ImageAnima));
   self.showdata = gongfupanda_Config.defalut_show_img[self.curindex];
   self.opendata = gongfupanda_Config.defalut_show_img[self.curindex];
   local pos = self.runpercont.transform.localPosition;
   self.runcontpos = Vector3.New(pos.x,pos.y,pos.z);
   self.runtabel = {};
   self.showtabel = {};
   self.runpercont.gameObject:SetActive(true);
   self.showpercont.gameObject:SetActive(false);
   self:addEvent();
    for i=1,10 do
          self.lihuoAnima:AddSprite(gongfupanda_Data.icon_res.transform:Find("lieyan_icon_anima_"..i):GetComponent('Image').sprite);
      end
   self.lihuoAnima.fSep = 0.06;

end

function gongfupanda_RunCont_Item:addEvent()
   gongfupanda_Event.addEvent(gongfupanda_Event.xiongm_over,gongfupanda_Event.hander(self,self.gameOver),self.guikey);
end

function gongfupanda_RunCont_Item:removeEvent()

end
function gongfupanda_RunCont_Item:setSonItem(per)
    self.sonItem = per;
end

function gongfupanda_RunCont_Item:gameOver(args)
    if args.data~=nil and self.curindex~=args.data then
       return;
    end
    for i=1,3 do
        self.opendata[i] = gongfupanda_Data.selectImg[self.curindex+(3-i)*5];
    end
    self:setOpenWin();
end

function gongfupanda_RunCont_Item:startRun()
    --error("______startRun_______");
   self.showpercont.gameObject:SetActive(false);
   self.runpercont.gameObject:SetActive(true);
   if gongfupanda_Config.runwaittimer_config[self.curindex]>0 then
      coroutine.start(function()
          coroutine.wait(gongfupanda_Config.runwaittimer_config[self.curindex]);
          self:oneRun();
     end);
   else
     self:oneRun();
   end
    
end

function gongfupanda_RunCont_Item:oneRun()   
   self:setOpenWin();
   if gongfupanda_Data.isShowLieHuoBg==false and gongfupanda_Data.bFireMode==true then
      self.lihuoAnima:Play();
      gongfupanda_Socket.playaudio("fire"); 
   end
   local pkdotween = self.runpercont.transform:DOLocalMove(Vector3.New(self.runcontpos.x,self.runcontpos.y-self.runh+100,0), gongfupanda_Config.runtimer_config[self.curindex]-0.1, false);
   pkdotween:SetEase(DG.Tweening.Ease.InOutQuad);
   --pkdotween:SetEase(DG.Tweening.Ease.InSine);
   pkdotween:OnComplete(function()
          --self:randImg();
          --self:setShow();
          --self.runpercont.gameObject:SetActive(false);
         -- self.showpercont.gameObject:SetActive(true);
         -- self.runpercont.transform.localPosition = Vector3.New(self.runcontpos.x,self.runcontpos.y,self.runcontpos.z);
          --if self.curindex==5 then
            -- MyBelieveSlot_Event.dispathEvent(MyBelieveSlot_Event.game_run_com);
          --end
          self:secondRun();
   end);
end

function gongfupanda_RunCont_Item:secondRun()
    --MyBelieveSlot_Socket.playaudio(MyBelieveSlot_Config.s_stoprun);
    gongfupanda_Socket.playaudio("runstop"); 
   local pkdotween = self.runpercont.transform:DOLocalMove(Vector3.New(self.runcontpos.x,self.runcontpos.y-self.runh+self.sh,0), 0.1, false);
   --pkdotween:SetEase(DG.Tweening.Ease.InOutQuad);
   pkdotween:SetEase(DG.Tweening.Ease.InSine);
   pkdotween:OnComplete(function()
          self:randImg();
          self:setShow();
          self.runpercont.gameObject:SetActive(false);
          self.showpercont.gameObject:SetActive(true);
          self.runpercont.transform.localPosition = Vector3.New(self.runcontpos.x,self.runcontpos.y,self.runcontpos.z);
          if self.curindex==5 then
             gongfupanda_Event.dispathEvent(gongfupanda_Event.xiongm_run_com);
          elseif self.curindex==1 then
            gongfupanda_Socket.showLiehuo();
          end
   end);
end

function gongfupanda_RunCont_Item:randImg()
   local num = self.createnum-5;
   local config = nil;
   local sonfig = nil;
   local midindex = 4;
   local endindex = self.createnum;
   config = gongfupanda_Config.rand_1;
   for i=midindex,endindex do
     sonfig = self:randFun(config);
     if sonfig==nil then
     end
       if sonfig~=0 then
          self.runtabel[i]:setImg(gongfupanda_Config.resimg_config[sonfig.src].normalimg);
       end 
   end
end

--设计显示
function gongfupanda_RunCont_Item:setShow()
   local item = nil;
   local idata = nil;
   for i=1,3 do
       idata = self.opendata[i];
       item = self.showtabel[i];
       item:setImg(gongfupanda_Config.resimg_config[idata].normalimg);
       item = self.runtabel[i];
       item:setImg(gongfupanda_Config.resimg_config[idata].normalimg);
   end
end


--开奖结果
function gongfupanda_RunCont_Item:setOpenWin()
   local item = nil;
   local idata = nil;
   local len = #self.runtabel-1;
   local dataindex = 1;
   for i=len-2,len do
       idata = self.opendata[dataindex];
       item = self.runtabel[i];
       item:setImg(gongfupanda_Config.resimg_config[idata].normalimg);
       item = self.showtabel[dataindex];
       item:setImg(gongfupanda_Config.resimg_config[idata].normalimg);
       dataindex = dataindex+1;
   end 
end

function gongfupanda_RunCont_Item:randFun(randtabel)
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
function gongfupanda_RunCont_Item:createSonItem(num)
   local item = nil;
   self.createnum = num;
   for i = 1,num do
      item = gongfupanda_Run_Soon_Item:new();
      item:setPer(self.sonItem);
      item:setParent(self.runpercont);
      item:setPoint(Vector3.New(0,self.starty+(i-1)*self.sh,0));
      table.insert(self.runtabel,i,item);
      self.runh = self.starty+(i-1)*self.sh;
   end
   for a = 1,3 do
      item = gongfupanda_Run_Soon_Item:new();
      item:setPer(self.sonItem,true);
      item:setParent(self.showpercont);
      item:setPoint(Vector3.New(0,self.starty+(a-1)*self.sh,0));
      table.insert(self.showtabel,a,item);
      gongfupanda_Data.allshowitem[self.curindex+(3-a)*5] = item;
   end  
   self:setShow();
   self:randImg();
end

