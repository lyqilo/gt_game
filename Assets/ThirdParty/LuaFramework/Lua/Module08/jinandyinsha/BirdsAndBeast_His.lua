BirdsAndBeast_His = {}
local  self = BirdsAndBeast_His;

self.messkey = "0";
self.data = nil;
self.per = nil;
function BirdsAndBeast_His:new()
    local obj = {};
    setmetatable(obj,{__index=self});
    obj.messkey = BirdsAndBeastEvent.guid(); 
    return obj;
end

function BirdsAndBeast_His:setPer(args)
   self.per = args;
   self:reflush(nil);
   self:AddEvent();
end

function BirdsAndBeast_His:setData(args)
   self.data = args;
   self:reflush(nil);
end

function BirdsAndBeast_His:AddEvent()
   BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.hischang,BirdsAndBeastEvent.hander(self,self.reflush),self.messkey);
   BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.exitgame,self.exitgame,self.messkey);
end

function BirdsAndBeast_His.exitgame(args)
   self.destroying();
end
function BirdsAndBeast_His.destroying()
   self.messkey = "0";
   self.data = nil;
   self.per = nil;
end

function BirdsAndBeast_His:RemoveEvent()
  BirdsAndBeastEvent.removeEvent(BirdsAndBeastEvent.hischang,self.messkey);
end

function BirdsAndBeast_His:reflush(args)
  if self.data~=nil and not IsNil(self.per) then 
     if self.data>#BirdsAndBeast_GameData.his_data or BirdsAndBeast_GameData.his_data[self.data]==0 or
      BirdsAndBeast_GameData.his_data[self.data]==3 or BirdsAndBeast_GameData.his_data[self.data]==20  then
        self.per.transform.gameObject:SetActive(false);
     else
        self.per.transform.gameObject:SetActive(true);
        if args==nil or args.data==nil or self.data==args.data  then
            local b = BirdsAndBeast_GameData.his_data[self.data];
            --local m = BirdsAndBeast_GameData.iconres.transform:Find(self.GetLuDanInfo(b)).gameObject:GetComponent("Image").sprite;
            local m = BirdsAndBeast_GameData.iconres.transform:Find(self.GetLuDanInfo(b)).gameObject:GetComponent("Image").sprite;
            self.per.transform:Find("Image").gameObject:GetComponent("Image").sprite = m;
        end   
     end
  end


end
function BirdsAndBeast_His.GetLuDanInfo(args)
   if (args == 8) then
      return   "luadan_1";
   end
   if (args == 9) then
      return   "luadan_2";
   end
   if (args == 10) then
      return   "luadan_7";
   end
   if (args == 11) then
      return   "luadan_8";
   end
   if (args == 4) then
      return   "luadan_3";
   end
   if (args == 7) then
      return   "luadan_6";
   end
   if (args == 6) then
      return   "luadan_5";
   end
   if (args == 5) then
      return   "luadan_4";
   end
   if (args == 1) then
      return   "luadan_10";
   end
   if (args == 2) then
      return   "luadan_9";
   end
end