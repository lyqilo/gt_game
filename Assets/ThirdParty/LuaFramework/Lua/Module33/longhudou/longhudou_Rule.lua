--规则界面
longhudou_Rule = {};
local self = longhudou_Rule;

function longhudou_Rule.setPer(args)
  self.init();
  self.guikey = longhudou_Event.guid();
  self.showpagenum = 2;
  self.per = args;
  self.per.gameObject:SetActive(false);
  self.closeBtn = self.per.transform:Find("closebtn");
  self.runcont = self.per.transform:Find("runcont");

  local eventTrigger=Util.AddComponent("EventTriggerListener",self.runcont.gameObject);
  eventTrigger.onBeginDrag = self.onBeginDrag;
  eventTrigger.onEndDrag  = self.onEndDrag;
  self.addEvent();
end

function longhudou_Rule.init(args)
    self.per = nil;
    self.curshowpage = nil;
    self.showpagenum = 0;
    self.guikey = "cn";
    self.minMaskW = 101;
    self.maxMaskW = 970;
    self.runcont = nil;
    self.startPos = nil;
    self.closeBtn = nil;
end

function longhudou_Rule.onBeginDrag(go, args)
   self.startPos = args.position;
end


function longhudou_Rule.onEndDrag(go, args)
    if self.startPos.x>args.position.x then
      self.nextBtnHander();
    else
      self.perBtnHander();
    end
end


function longhudou_Rule.gameExit(args)
    self.per = nil;
    self.curshowpage = nil;
    self.showpagenum = 0;
    self.guikey = "cn";
end

function longhudou_Rule.addEvent()
  longhudou_Event.addEvent(longhudou_Event.xiongm_exit,self.gameExit,self.guikey);
  longhudou_Data.luabe:AddClick(self.closeBtn.gameObject,self.closeBtnHander);
end

function longhudou_Rule.closeBtnHander(args)
  self.per.gameObject:SetActive(false);
end

function longhudou_Rule.perBtnHander(args)
  if self.curshowpage-1>= 1 then
     self.curshowpage = self.curshowpage-1;
  else
    self.curshowpage = 2;
  end
  self.dafalutPage(self.curshowpage);
end
function longhudou_Rule.nextBtnHander(args)
  if self.curshowpage+1<= self.showpagenum then
     self.curshowpage = self.curshowpage+1;
  else
     self.curshowpage = 1;
  end
  self.dafalutPage(self.curshowpage);
end


function longhudou_Rule.removeEvent()

end
function longhudou_Rule.dafalutPage(showpage)
   for i=1,self.showpagenum do
       if i==showpage then
          self.per.transform:Find("runcont/itemcont/item_"..i).gameObject:SetActive(true);
          self.curshowpage = showpage;
       else
          self.per.transform:Find("runcont/itemcont/item_"..i).gameObject:SetActive(false);
       end
   end
   
end
function longhudou_Rule.show(args)
   self.dafalutPage(1);
   self.per.gameObject:SetActive(true);
end