longhudou_RunComp = {};
local self = longhudou_RunComp;

function longhudou_RunComp:new()
   local go = {};
   self.guikey = "cn";
   setmetatable(go,{__index = self});
   go.guikey = longhudou_Event.guid();
   return go;
end
function longhudou_RunComp:init()
    self.runpercont = nil;
    self.sonItem = nil;
    self.starty = -340;
    self.sh = 171;
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

function longhudou_RunComp:runStop()    
    self.iscom = true;
end

function longhudou_RunComp:setOpenPos()
   local len = #self.runtabel-2;
   local pos = nil;
    for i=len,#self.runtabel do
         pos = self.runtabel[i].transform.localPosition;
         self.runtabel[i].transform.localPosition = Vector3.New(pos.x,pos.y - self.lastjul,pos.z);
    end
    error("_____setOpenPos______"..self.lastjul);
    self.lastjul = 0;
end

function longhudou_RunComp:setPer(runargs)
   self:init();
   self.runpercont = runargs;
   local pos = self.runpercont.transform.localPosition;
   self.runcontpos = Vector3.New(pos.x,pos.y,pos.z);
   self.runtabel = {};
   self.runpercont.gameObject:SetActive(true);
end

function longhudou_RunComp:setSonItem(per)
    self.sonItem = per;
end

function longhudou_RunComp:randImg()
   local num = self.createnum;
   local config = nil;
   local sonfig = nil;
   local midindex = 1;
   local endindex = self.createnum;
   config = longhudou_Config.rand_1;
   for i=midindex,endindex do
     sonfig = self:randFun(config);
     if sonfig==nil then
     end
       if sonfig~=0 then
          if longhudou_Data.icon_res==nil then
             self.runtabel[i].transform:Find("icon").gameObject:GetComponent("Image").sprite = longhudou_Data.numres.transform:Find(longhudou_Config.resimg_config[sonfig.src].normalimg).gameObject:GetComponent("Image").sprite;
          else
            self.runtabel[i].transform:Find("icon").gameObject:GetComponent("Image").sprite = longhudou_Data.icon_res.transform:Find(longhudou_Config.resimg_config[sonfig.src].normalimg).gameObject:GetComponent("Image").sprite;
          end
          
       end
   end
end

function longhudou_RunComp:randFun(randtabel)
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
function longhudou_RunComp:createSonItem(num)
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

function longhudou_RunComp:deFault()
   local item = nil;
   for i = 1,self.createnum do
      item = self.runtabel[i];
      item.transform.localPosition = Vector3.New(0,self.starty+(i-1)*self.sh,0);
   end
end

function longhudou_RunComp:Update()
    error("____self.lastjul_________");
    if self.isrun == false then
       return;
    end
    if self.iscom == true then
       self:serverRun();
    else
       self:clientRun();
    end
    
end

function longhudou_RunComp:clientRun()
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
         error("____self.lastjul_________"..self.lastjul);
         if py< (self.starty -self.sh)  then
            py = self.starty+(len-1)*self.sh -(self.starty -self.sh  - py );
            self.lastjul = self.sh + (self.starty -self.sh  - py);
            error("____self.lastjul_________"..self.lastjul);
         end
         self.runtabel[i].transform.localPosition = Vector3.New(pos.x,py,pos.z);
    end
end

function longhudou_RunComp:serverRun()
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

