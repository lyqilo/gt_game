tjz_RunComp = {};
local self = tjz_RunComp;

function tjz_RunComp:new()
   local go = {};
   self.guikey = "cn";
   setmetatable(go,{__index = self});
   go.guikey = tjz_Event.guid();
   return go;
end
function tjz_RunComp:init()
    self.runpercont = nil;
    self.sonItem = nil;
    self.starty = -340;
    self.sh = 175;
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

function tjz_RunComp:runStop()    
    self.iscom = true;
end

function tjz_RunComp:setOpenPos()
   local len = #self.runtabel-2;
   local pos = nil;
    for i=len,#self.runtabel do
         pos = self.runtabel[i].transform.localPosition;
         self.runtabel[i].transform.localPosition = Vector3.New(pos.x,pos.y - self.lastjul,pos.z);
    end
    --error("_____setOpenPos______");
    self.lastjul = 0;
end

function tjz_RunComp:setPer(runargs)
   self:init();
   self.runpercont = runargs;
   local pos = self.runpercont.transform.localPosition;
   self.runcontpos = Vector3.New(pos.x,pos.y,pos.z);
   self.runtabel = {};
   self.runpercont.gameObject:SetActive(true);
end

function tjz_RunComp:setSonItem(per)
    self.sonItem = per;
end

function tjz_RunComp:randImg()
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
          self.runtabel[i].transform:Find("icon").gameObject:GetComponent("Image").sprite = tjz_Data.icon_res.transform:Find(tjz_Config.resimg_config[sonfig.src].normalimg).gameObject:GetComponent("Image").sprite;
       end
   end
end

function tjz_RunComp:randFun(randtabel)
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
function tjz_RunComp:createSonItem(num)
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
   self:randImg();
   self.isrun = true;
end

function tjz_RunComp:deFault()
   local item = nil;
   for i = 1,self.createnum do
      item = self.runtabel[i];
      item.transform.localPosition = Vector3.New(0,self.starty+(i-1)*self.sh,0);
   end
end

function tjz_RunComp:Update()
    if self.isrun == false then
       return;
    end
    if self.iscom == true then
       self:serverRun();
    else
       self:clientRun();
    end
    
end

function tjz_RunComp:clientRun()
   local pos = nil;
    local py = 0;
    if self.speedtimer>2 then
       self.speedtimer = 2;
    else
        self.speedtimer = self.speedtimer+0.02;
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

function tjz_RunComp:serverRun()
   local pos = nil;
   local py = 0;
   if self.lastjul>0 then
      self:setOpenPos();
   end
   if self.runtabel[#self.runtabel].transform.localPosition.y<500 then
    
      self.speedtimer = self.speedtimer-0.02;
      if self.speedtimer<0.2 then
         self.speedtimer = 0.2;
      end
   else
        if self.speedtimer>2 then
         self.speedtimer = 2;
      else
         self.speedtimer = self.speedtimer+0.02;
      end
   end
    py = self.speed*self.speedtimer;
    if (self.runtabel[#self.runtabel].transform.localPosition.y+py)<= (self.starty +self.sh*2) then
       py = self.starty +self.sh*2 - self.runtabel[#self.runtabel].transform.localPosition.y;
       self.isrun = false;
    end
    local len = #self.runtabel;
    for i=1,len do
         pos = self.runtabel[i].transform.localPosition;
         self.runtabel[i].transform.localPosition = Vector3.New(pos.x,pos.y+py,pos.z);
    end
    if self.isrun == false then
       self:deFault();
    end

end

