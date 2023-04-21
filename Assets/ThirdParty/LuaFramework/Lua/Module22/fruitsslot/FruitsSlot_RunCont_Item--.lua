FruitsSlot_RunCont_Item = {}
local self = FruitsSlot_RunCont_Item;

--self.runpercont = nil;
--self.showpercont = nil;
--self.sonItem = nil;
--self.starty = -400;
--self.sh = 200;
--self.runtabel = nil;
--self.showtabel = nil;
--self.runh = 0;
--self.showdata = {FruitsSlot_Config.e_bell,FruitsSlot_Config.e_wild,FruitsSlot_Config.e_fruit_cherry};
--self.opendata = {FruitsSlot_Config.e_bell,FruitsSlot_Config.e_wild,FruitsSlot_Config.e_fruit_cherry};
--self.createnum = 0;
--self.runcontpos = nil;
--self.curindex = 1;
--self.guikey = "cn";
function FruitsSlot_RunCont_Item:new()
   local go = {};
   self.guikey = "cn";
   setmetatable(go,{__index = self});
   go.guikey = FruitsSlotEvent.guid();
   return go;
end
function FruitsSlot_RunCont_Item:init()
    self.runpercont = nil;
    self.showpercont = nil;
    self.sonItem = nil;
    self.starty = -395;
    self.sh = 198;
    self.runtabel = nil;
    self.showtabel = nil;
    self.runh = 0;
    self.showdata = {FruitsSlot_Config.e_bell,FruitsSlot_Config.e_wild,FruitsSlot_Config.e_fruit_cherry};
    self.opendata = {FruitsSlot_Config.e_bell,FruitsSlot_Config.e_wild,FruitsSlot_Config.e_fruit_cherry};
    self.createnum = 0;
    self.runcontpos = nil;
    self.curindex = 1;
end

function FruitsSlot_RunCont_Item:setPer(runargs,showper,index)
   self:init();
   self.runpercont = runargs;
   self.showpercont = showper;
   self.curindex = index;
   self.showdata = FruitsSlot_Config.defalut_show_img[self.curindex];
   self.opendata = FruitsSlot_Config.defalut_show_img[self.curindex];
   local pos = self.runpercont.transform.localPosition;
   self.runcontpos = Vector3.New(pos.x,pos.y,pos.z);
   self.runtabel = {};
   self.showtabel = {};
   self:addEvent();
end

function FruitsSlot_RunCont_Item:addEvent()
   FruitsSlotEvent.addEvent(FruitsSlotEvent.game_over,FruitsSlotEvent.hander(self,self.gameOver),self.guikey);
end

function FruitsSlot_RunCont_Item:removeEvent()

end
function FruitsSlot_RunCont_Item:setSonItem(per)
    self.sonItem = per;
end

function FruitsSlot_RunCont_Item:gameOver(args)
    --error("______gameOver_______");
    if args.data~=nil and self.curindex~=args.data then
       return;
    end
    for i=1,3 do
        self.opendata[i] = FruitsSlot_Data.openimg[self.curindex+(3-i)*5];
    end
    self:setOpenWin();
     --error("___111___gameOver_______");
end

function FruitsSlot_RunCont_Item:startRun()
    --error("______startRun_______");
   self.showpercont.gameObject:SetActive(false);
   self.runpercont.gameObject:SetActive(true);
   --self:setShow();
   local pkdotween = self.runpercont.transform:DOLocalMove(Vector3.New(self.runcontpos.x,self.runcontpos.y-self.runh,0), FruitsSlot_Config.runtimer_config[self.curindex], false);
   pkdotween:SetEase(DG.Tweening.Ease.InOutQuad);
   coroutine.start(function()
       coroutine.wait(FruitsSlot_Config.runtimer_config[self.curindex]-0.7);
       FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_run_stop,false,false);
    end);
  -- pkdotween:SetEase(DG.Tweening.Ease.InSine);
   pkdotween:OnComplete(function()
          self:randImg();
          self:setShow();
          self.runpercont.gameObject:SetActive(false);
          self.showpercont.gameObject:SetActive(true);
          self.runpercont.transform.localPosition = Vector3.New(self.runcontpos.x,self.runcontpos.y,self.runcontpos.z);

          if self.curindex==5 then
              --error("______game_run_com____________");
             FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_run_com);
          end
   end);
end



--function FruitsSlot_RunCont_Item:startRun()
--   self.showpercont.gameObject:SetActive(false);
--   self.runpercont.gameObject:SetActive(true);
--   self:oneRun();
--end

--function FruitsSlot_RunCont_Item:oneRun()   
--   self:setOpenWin();
--   local pkdotween = self.runpercont.transform:DOLocalMove(Vector3.New(self.runcontpos.x,self.runcontpos.y-self.runh+100,0), FruitsSlot_Config.runtimer_config[self.curindex]-0.1, false);
--   pkdotween:SetEase(DG.Tweening.Ease.InOutQuad);   
--   pkdotween:OnComplete(function()
--          self:secondRun();
--   end);
--end

--function FruitsSlot_RunCont_Item:secondRun()
--   error("______secondRun______");
--   FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_run_stop,false,false);
--   local pkdotween = self.runpercont.transform:DOLocalMove(Vector3.New(self.runcontpos.x,self.runcontpos.y-self.runh+self.sh,0), 0.1, false);
--   pkdotween:SetEase(DG.Tweening.Ease.InSine);
--   pkdotween:OnComplete(function()
--          self:randImg();
--          self:setShow();
--          self.runpercont.gameObject:SetActive(false);
--          self.showpercont.gameObject:SetActive(true);
--          self.runpercont.transform.localPosition = Vector3.New(self.runcontpos.x,self.runcontpos.y,self.runcontpos.z);
--          if self.curindex==5 then
--             FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_run_com);
--          end
--   end);
--end



function FruitsSlot_RunCont_Item:randImg()
   local zunum = (self.createnum-6)/3;
   local config = nil;
   local sonfig = nil;
   local midindex = 4;
   local endindex = self.createnum-3;
   if self.curindex==2 then
      --error("_______endindex_________"..endindex);
   end
   --error("_______randImg_________");
   for i=1,zunum do
        if self.curindex==1 then
           config = self:randFun(FruitsSlot_Config.first_zurate);
        else
           config = self:randFun(FruitsSlot_Config.zurate);
        end
       if config~=0 then
           for i=1,3 do
               
                if self.curindex==2 then
                   sonfig = self:randFun(FruitsSlot_Config[config.cfname],true);
                   --error("____endindex_____"..midindex.."___"..config.cfname);
                else
                  sonfig = self:randFun(FruitsSlot_Config[config.cfname],false);
                end
               if sonfig~=0 and midindex<=endindex then
                  self.runtabel[midindex]:setImg(sonfig.cfname);
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
      -- error("______idata__________"..idata);
       item = self.showtabel[i];
       -- error("___222___idata__________"..item.itemname);
       item:setImg(FruitsSlot_Config.resimg_config[idata].cfname);
       item = self.runtabel[i];
       item:setImg(FruitsSlot_Config.resimg_config[idata].cfname);
   end
end


--开奖结果
function FruitsSlot_RunCont_Item:setOpenWin()
   local item = nil;
   local idata = nil;
   local len = #self.runtabel;
   local dataindex = 1;
   for i=len-2,len do
       idata = self.opendata[dataindex];
      -- error("___opem___idata__________"..idata);
       item = self.runtabel[i];
       item:setImg(FruitsSlot_Config.resimg_config[idata].cfname);
       item = self.showtabel[dataindex];
       item:setImg(FruitsSlot_Config.resimg_config[idata].cfname);
       dataindex = dataindex+1;
   end 
end

function FruitsSlot_RunCont_Item:randFun(randtabel,iserr)
    local reslut = 0;   
    local randnum = math.random(0,100);
	local beginIndex = math.random(1,#randtabel);
	local curindex ;
    if iserr==true then
      -- error("__________randnum___________"..randnum);
    end
    --error("__________randnum___________"..randnum);
	for i=1,#randtabel do
		curindex = ((i+beginIndex)%#randtabel)+1;
         --error("____randnum______"..curindex);
		if randnum<=randtabel[curindex].rate then
			reslut = randtabel[curindex];
            if iserr==true then
              -- error("__________curindex___________"..curindex.."__"..randtabel[curindex].rate.."__"..randtabel[curindex].cfname);
            end
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
      item = FruitsSlot_Run_Soon_Item:new();
      item:setPer(self.sonItem);
      item:setParent(self.runpercont);
      item:setPoint(Vector3.New(0,self.starty+(i-1)*self.sh,0));
      table.insert(self.runtabel,i,item);
      self.runh = self.starty+(i-1)*self.sh;
   end
   for a = 1,3 do
      item = FruitsSlot_Run_Soon_Item:new();
      item:setPer(self.sonItem,true);
      item:setParent(self.showpercont);
      item:setPoint(Vector3.New(0,self.starty+(a-1)*self.sh,0));
      table.insert(self.showtabel,a,item);
      item.itemname = self.curindex+(3-a)*5;
      --error("__11__itemnameitemname_______"..item.itemname);
      FruitsSlot_Data.allshowitem[self.curindex+(3-a)*5] = item;
      --table.insert(FruitsSlot_Data.allshowitem,self.curindex+(a-1)*5,item);
   end  
   self:setShow();
   self:randImg();
end

