--规则界面
xiangqi_Rule = {};
local self = xiangqi_Rule;



function xiangqi_Rule.setPer(args)
  self.init();
  self.guikey = xiangqi_Event.guid();
  self.per = args;
  self.per.gameObject:SetActive(false);
  self.closeBtn = self.per.transform:Find("closebtn");
  self.addEvent();
  self.per.gameObject:AddComponent(typeof(CreateFont))
end

function xiangqi_Rule.init(args)
    self.per = nil;
    self.guikey = "cn";
    self.closeBtn = nil;
end

function xiangqi_Rule.gameExit(args)
    self.per = nil;
    self.guikey = "cn";
end

function xiangqi_Rule.addEvent()
  xiangqi_Event.addEvent(xiangqi_Event.xiongm_exit,self.gameExit,self.guikey);
  xiangqi_Data.luabe:AddClick(self.closeBtn.gameObject,self.closeBtnHander);
end

function xiangqi_Rule.closeBtnHander(args)
  self.per.gameObject:SetActive(false);
end

function xiangqi_Rule.removeEvent()

end
function xiangqi_Rule.show(args)
   self.per.gameObject:SetActive(true);
end