--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion

--红包

RedBagPanel = {};
local self = RedBagPanel;
self.per = nil;
self.luabe = nil;
--self.point = nil;
self.myparent = nil;
self.imganima = nil;
self.state = nil;
self.soonparent = nil;
function RedBagPanel.creatpanel(luabe,myparent,obj,soonparent)
   self.luabe = luabe;
   --self.point = point;
   self.myparent = myparent;
   self.soonparent = soonparent;
   self.per =obj;
   --if self.per==nil then
   --   ResManager:LoadAsset("hall_redbage", "redbag", self.setPer);
   --end
   self.addClick();
   self.doState();
end

function RedBagPanel.setPer(args)
   self.per = newobject(args);
  -- self.per.transform:Find("sendimg").gameObject:SetActive(false);
 --  self.per.transform:SetParent(self.myparent.transform);
 --  self.per.transform.localPosition = self.point;
--   self.per.transform.localScale = Vector3.New(1,1,1);
--   self.imganima = self.per.gameObject:GetComponent("ImageAnima");
   self.addClick();
   self.doState();
end

function RedBagPanel.doState()
   if IsNil( self.per) then
      return;
   end
   if self.state==nil or self.state ==0 then
      self.per:SetActive(false);
   else
      self.per:SetActive(true);
     -- self.imganima:PlayAlways();
   end
end

function RedBagPanel.addClick()
  if self.per~=nil and self.luabe~=nil then
     self.luabe:AddClick(self.per,self.clickHander);
  end
end

function RedBagPanel.clickHander(args)
  error("______clickHander_______");
  if self.soonparent==nil then
     GiveAndSendMoneyRecordPanle.showPanel(self.myparent.transform);
  else
      GiveAndSendMoneyRecordPanle.showPanel(self.soonparent.transform);
  end
   
end

--设置红包的状态
function RedBagPanel.setState(args)
  self.state = args;
  self.doState();
end
