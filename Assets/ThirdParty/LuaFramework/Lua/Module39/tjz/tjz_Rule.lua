--规则界面
tjz_Rule = {};
local self = tjz_Rule;



function tjz_Rule.setPer(args)
  self.init();
  self.guikey = tjz_Event.guid();
  self.showpagenum = 4;
  self.per = args;
  self.per.gameObject:SetActive(false);
  self.closeBtn = self.per.transform:Find("closebtn");
  self.perBtn = self.per.transform:Find("perbtn");
  self.nextBtn = self.per.transform:Find("nextbtn");
  self.runcont = self.per.transform:Find("runcont");

--  local eventTrigger=Util.AddComponent("EventTriggerListener",self.runcont.gameObject);
--  eventTrigger.onBeginDrag = self.onBeginDrag;
--  eventTrigger.onEndDrag  = self.onEndDrag;
  self.addEvent();
end

function tjz_Rule.init(args)
    self.per = nil;
    self.curshowpage = nil;
    self.showpagenum = 0;
    self.guikey = "cn";
    self.minMaskW = 101;
    self.maxMaskW = 970;
    self.runcont = nil;
    self.startPos = nil;
    self.closeBtn = nil;
    self.perBtn = nil;
    self.nextBtn = nil;
end

function tjz_Rule.onBeginDrag(go, args)
   self.startPos = args.position;
end


function tjz_Rule.onEndDrag(go, args)
    if self.startPos.x>args.position.x then
      self.nextBtnHander();
    else
      self.perBtnHander();
    end
end


function tjz_Rule.gameExit(args)
    self.per = nil;
    self.curshowpage = nil;
    self.showpagenum = 0;
    self.guikey = "cn";
end

function tjz_Rule.addEvent()
  tjz_Event.addEvent(tjz_Event.xiongm_exit,self.gameExit,self.guikey);
  tjz_Data.luabe:AddClick(self.closeBtn.gameObject,self.closeBtnHander);
  tjz_Data.luabe:AddClick(self.perBtn.gameObject,self.perBtnHander);
  tjz_Data.luabe:AddClick(self.nextBtn.gameObject,self.nextBtnHander);
end

function tjz_Rule.closeBtnHander(args)
  self.per.gameObject:SetActive(false);
end

function tjz_Rule.perBtnHander(args)
  if self.curshowpage-1>= 1 then
     self.curshowpage = self.curshowpage-1;
  else
    self.curshowpage = 3;
  end
  self.dafalutPage(self.curshowpage);
end
function tjz_Rule.nextBtnHander(args)
  if self.curshowpage+1<= self.showpagenum then
     self.curshowpage = self.curshowpage+1;
  else
     self.curshowpage = 1;
  end
  self.dafalutPage(self.curshowpage);
end


function tjz_Rule.removeEvent()

end
function tjz_Rule.dafalutPage(showpage)
   for i=1,self.showpagenum do
       if i==showpage then
          self.per.transform:Find("runcont/itemcont/item_"..i).gameObject:SetActive(true);
          self.curshowpage = showpage;
       else
          self.per.transform:Find("runcont/itemcont/item_"..i).gameObject:SetActive(false);
       end
   end

end
function tjz_Rule.show(args)
   self.dafalutPage(1);
   self.per.gameObject:SetActive(true);
end