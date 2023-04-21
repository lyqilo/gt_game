BirdsAndBeast_SpecialAnima = {};
local self = BirdsAndBeast_SpecialAnima;


self.per = nil;
self.index = nil;
self.light = nil;
self.data = nil;
self.curstep = 1;
self.messkey = "0";
self.myscale = 1;
self.yuanq = nil;
function BirdsAndBeast_SpecialAnima:new()
    local  obj = {};
    setmetatable(obj,{__index = self});
    obj.messkey = BirdsAndBeastEvent.guid(); 
    return obj;
end

function BirdsAndBeast_SpecialAnima:AddEvent()
   BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.startspecialanima,BirdsAndBeastEvent.hander(self,self.startspecialanima),self.messkey);
   BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.oncestopspecialanima,BirdsAndBeastEvent.hander(self,self.onceStopSpecialAnima),self.messkey);   
   BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.exitgame,BirdsAndBeastEvent.hander(self,self.exitgame),self.messkey);
end

function BirdsAndBeast_SpecialAnima:startspecialanima(args)
   self:run();
end
function BirdsAndBeast_SpecialAnima:onceStopSpecialAnima(args)
  self.curstep = 9;
end

function BirdsAndBeast_SpecialAnima:exitgame(args)
   self:destroying();
end
function BirdsAndBeast_SpecialAnima:destroying()
    self.per = nil;
    self.index = nil;
    self.light = nil;
    self.data = nil;
    self.curstep = 9;
    self.messkey = "0";
    self.myscale = 1;
    self.yuanq = nil;
end

function BirdsAndBeast_SpecialAnima:setPer(per,index)
   self.per = per;
   self.index = index;
   self.light = self.per.transform:Find("light");
   self.yuanq = self.per.transform:Find("Image");
   self.data = BirdsAndBeastConfig.special_anima_config[self.index];
   self:AddEvent();
   self.per.gameObject:SetActive(false);
end

function BirdsAndBeast_SpecialAnima:run()
   self.myscale = self.data.scale;  
   self.curstep = 1;
   coroutine.start(BirdsAndBeastEvent.hander(self,self.doRun));
end
function BirdsAndBeast_SpecialAnima:doRun()
    if IsNil(self.per) then
          return;
    end
    coroutine.wait(self.data["t_"..self.curstep]);
    self.per.gameObject:SetActive(true);
    self.curstep = self.curstep+1;
    local tweener = self.light:DOScaleX( self.myscale, self.data["t_"..self.curstep]);
    self.curstep = self.curstep+1;
    BirdsAndBeast_Socket.playaudio(BirdsAndBeastConfig["sound_shaoguang"],false);
    tweener:OnComplete( function()
         if IsNil(self.per) then
            return;
         end
         if self.curstep<9 then
            if  self.myscale == self.data.scale then
                self.myscale = 1;
            else
                self.myscale = self.data.scale;
                if IsNil(self.per)~=nil then
                   self.per.gameObject:SetActive(false);
                 end
            end
            if IsNil(self.per)==nil then
               return;
            end
             coroutine.start(BirdsAndBeastEvent.hander(self,self.doRun));
         else
             if IsNil(self.per)~=nil then
                   self.per.gameObject:SetActive(false);
             end
             if self.index==1 then
                BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.stopspecialanima,nil);
             end
         end
    end );
end