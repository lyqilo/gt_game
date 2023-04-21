

jinandyinsha_anima = {};
local self = jinandyinsha_anima;

function jinandyinsha_anima:new()
    local obj = {};   
    setmetatable(obj,{__index=self});
    self:init();
    return obj;
end

function jinandyinsha_anima:init()
   self.item = nil;
   self.initPos = nil;
   self.animaendpos = nil;
   self.isrun = false;
   self.angel = 5;
   self.img1 = nil;
   self.img2 = nil;
end

function jinandyinsha_anima:setPer(args,itemparent,pos)
    self.item = newobject(args);
    self.item.transform:SetParent(itemparent.transform);
    self.item.transform.localScale = Vector3.New(1,1,1);
    self.item.transform.localPosition = Vector3.New(pos.x,pos.y,pos.z);
    self.initPos = Vector3.New(pos.x,pos.y,pos.z);
    self.img1 =  self.item.transform:Find("img1").gameObject;
    self.img2 =  self.item.transform:Find("img2").gameObject;
    self.img2.gameObject:SetActive(false);
    self.item.gameObject:SetActive(false);
end

function jinandyinsha_anima:getRun(args)
   return self.isrun;
end

function jinandyinsha_anima:update(args)
   if self.isrun == false or IsNil(self.item) then
      return;
   end
   --self.item.transform:Rotate(0,self.angel,0);
end

function jinandyinsha_anima:setAnima3(spos)
   if self.isrun == true then
      return;
   end  
   self.img1.gameObject:SetActive(false);
   self.img2.gameObject:SetActive(true);
   self.item.gameObject:SetActive(true);
   self.isrun = true;
   self.item.transform.localPosition = Vector3.New(spos.x,spos.y,spos.z);
end

function jinandyinsha_anima:playAnima3(spos)
   if self.isrun==false then
      return;
   end
   self.isrun = false;
   if not IsNil(self.item) then
      self.item.transform.localPosition = Vector3(self.initPos.x,self.initPos.y,self.initPos.z);
      self.item.transform.eulerAngles = Vector3.New(0,0,0);
      self.img1.gameObject:SetActive(true);
      self.img2.gameObject:SetActive(false);
      self.item.gameObject:SetActive(false);
   end
end


function jinandyinsha_anima:setAnima2(spos,epos)
   if self.isrun == true then
      return;
   end
   self.item.gameObject:SetActive(true);
   self.animaendpos = Vector3.New(epos.x,epos.y,epos.z);
   self.angel = 0;
   self.isrun = true;
   self.item.transform.localPosition = Vector3.New(spos.x,spos.y,spos.z);
end

function jinandyinsha_anima:playAnima2(args)
   if self.isrun==false then
      return;
   end
   if self.animaendpos~=nil and not IsNil(self.item) then
      local tween = self.item.transform:DOLocalMove(Vector3.New(self.animaendpos.x,self.animaendpos.y,self.animaendpos.z),1.5,false);
      tween:OnComplete(function(args)
            self.animaendpos=nil;
            self.isrun = false;
            self.angel = 5;
            if not IsNil(self.item) then
                self.item.transform.localPosition = Vector3(self.initPos.x,self.initPos.y,self.initPos.z);
                self.item.transform.eulerAngles = Vector3.New(0,0,0);
                self.item.gameObject:SetActive(false);
            end
      end)
   else
     self.isrun = false;
   end
end


function jinandyinsha_anima:setAnima1(epos)
   if self.isrun == true then
      return;
   end
   self.animaendpos = Vector3.New(epos.x,epos.y,epos.z);
   self.angel = 5;
   self.isrun = true;
   self.item.gameObject:SetActive(true);
   --self.item.transform.localPosition = Vector3.New(spos.x,spos.y,spos.z);
end

function jinandyinsha_anima:playAnima1(args)
   if self.animaendpos~=nil and not IsNil(self.item) then
      --BirdsAndBeast_Socket.playaudio("flygold",false,false,false);
      local tween = self.item.transform:DOLocalMove(Vector3.New(self.animaendpos.x,self.animaendpos.y,self.animaendpos.z),0.5,false);
      tween:OnComplete(function(args)
           self.angel = 30;
           coroutine.start(function(args)
               coroutine.wait(0.1);
               self.animaendpos=nil;
               self.isrun = false;
               self.angel = 5;
               if not IsNil(self.item) then
                   self.item.transform.localPosition = Vector3(self.initPos.x,self.initPos.y,self.initPos.z);
                   self.item.transform.eulerAngles = Vector3.New(0,0,0);
                   self.item.gameObject:SetActive(false);
               end
           end);
      end)
   else
     self.isrun = false;
   end
end