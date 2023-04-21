--规则界面
flm_Rule = {};
local self = flm_Rule;



function flm_Rule.setPer(args)
  self.init();
  self.guikey = flm_Event.guid();
  self.showpagenum = 4;
  self.per = args;
  self.per.gameObject:SetActive(false);
  self.closeBtn = self.per.transform:Find("closebtn");
  self.rulebtn = self.per.transform:Find("rulebtn");  
  self.runcont = self.per.transform:Find("runcont");
  self.perbtn = self.per.transform:Find("runcont/perbtn");
  self.nextbtn = self.per.transform:Find("runcont/nextbtn");

  local eventTrigger=Util.AddComponent("EventTriggerListener",self.runcont.gameObject);
  eventTrigger.onBeginDrag = self.onBeginDrag;
  eventTrigger.onEndDrag  = self.onEndDrag;
  self.addEvent();
end

function flm_Rule.init(args)
    self.per = nil;
    self.curshowpage = nil;
    self.showpagenum = 0;
    self.guikey = "cn";
    self.minMaskW = 101;
    self.maxMaskW = 970;
    self.runcont = nil;
    self.startPos = nil;
    self.closeBtn = nil;
    self.rulebtn = nil;
    self.perbtn = nil;
    self.nextbtn = nil;
end

function flm_Rule.onBeginDrag(go, args)
   self.startPos = args.position;
end


function flm_Rule.onEndDrag(go, args)
    if self.startPos.x>args.position.x then
     -- self.nextBtnHander();
    else
     -- self.perBtnHander();
    end
end


function flm_Rule.gameExit(args)
    self.per = nil;
    self.curshowpage = nil;
    self.showpagenum = 0;
    self.guikey = "cn";
end

function flm_Rule.addEvent()
  flm_Event.addEvent(flm_Event.xiongm_exit,self.gameExit,self.guikey);
  flm_Data.luabe:AddClick(self.closeBtn.gameObject,self.closeBtnHander);
  flm_Data.luabe:AddClick(self.rulebtn.gameObject,self.closeBtnHander);  
  flm_Data.luabe:AddClick(self.perbtn.gameObject,self.perBtnHander);
  flm_Data.luabe:AddClick(self.nextbtn.gameObject,self.nextBtnHander);
end

function flm_Rule.closeBtnHander(args)
  self.per.gameObject:SetActive(false);
end

function flm_Rule.perBtnHander(args)
  if self.curshowpage-1>= 1 then
     self.curshowpage = self.curshowpage-1;
  else
    self.curshowpage = 4;
  end
  self.dafalutPage(self.curshowpage);
end
function flm_Rule.nextBtnHander(args)
  if self.curshowpage+1<= self.showpagenum then
     self.curshowpage = self.curshowpage+1;
  else
     self.curshowpage = 1;
  end
  self.dafalutPage(self.curshowpage);
end


function flm_Rule.removeEvent()

end
function flm_Rule.dafalutPage(showpage)
   for i=1,self.showpagenum do
       if i==showpage then
          self.per.transform:Find("runcont/itemcont/item_"..i).gameObject:SetActive(true);
          self.curshowpage = showpage;
       else
          self.per.transform:Find("runcont/itemcont/item_"..i).gameObject:SetActive(false);
       end
   end
   
end
function flm_Rule.show(args)
   self.dafalutPage(1);
   self.per.gameObject:SetActive(true);
end