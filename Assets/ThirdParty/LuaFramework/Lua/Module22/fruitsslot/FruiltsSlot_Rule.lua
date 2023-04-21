--规则界面
FruiltsSlot_Rule = {};
local self = FruiltsSlot_Rule;

self.per = nil;
self.perbtn = nil;
self.nextbtn = nil;
self.returnbtn = nil;
self.curshowpage = nil;
self.showpagenum = 0;
self.guikey = "cn";

function FruiltsSlot_Rule.setPer(args)
    self.guikey = FruitsSlotEvent.guid();
    self.showpagenum = 3;
    self.per = args;
    self.per.transform:SetAsLastSibling()
    self.perbtn = self.per.transform:Find("perbtn");
    self.nextbtn = self.per.transform:Find("nextbtn");
    self.returnbtn = self.per.transform:Find("returnbtn");
    self.per.gameObject:SetActive(false);
    self.addEvent();
end

function FruiltsSlot_Rule.gameExit(args)
    self.per = nil;
    self.perbtn = nil;
    self.nextbtn = nil;
    self.returnbtn = nil;
    self.curshowpage = nil;
    self.showpagenum = 0;
    self.guikey = "cn";
end

function FruiltsSlot_Rule.addEvent()
    FruitsSlot_Data.luabe:AddClick(self.perbtn.gameObject, self.perBtnHander);
    FruitsSlot_Data.luabe:AddClick(self.nextbtn.gameObject, self.nextBtnHander);
    FruitsSlot_Data.luabe:AddClick(self.returnbtn.gameObject, self.returnBtnHander);
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_exit, self.gameExit, self.guikey);
end

function FruiltsSlot_Rule.perBtnHander(args)
    FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_btn, false, false);
    if self.curshowpage - 1 >= 1 then
        self.dafalutPage(self.curshowpage - 1);
    end
end
function FruiltsSlot_Rule.nextBtnHander(args)
    FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_btn, false, false);
    if self.curshowpage + 1 <= self.showpagenum then
        self.dafalutPage(self.curshowpage + 1);
    end
end
function FruiltsSlot_Rule.returnBtnHander(args)
    FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_btn, false, false);
    self.per.gameObject:SetActive(false);
end

function FruiltsSlot_Rule.removeEvent()

end
function FruiltsSlot_Rule.dafalutPage(showpage)
    for i = 1, self.showpagenum do
        if i == showpage then
            self.per.transform:Find("rule_" .. i).gameObject:SetActive(true);
            self.curshowpage = showpage;
        else
            self.per.transform:Find("rule_" .. i).gameObject:SetActive(false);
        end
    end

end
function FruiltsSlot_Rule.show(args)
    FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_btn, false, false);
    self.dafalutPage(1);
    self.per.gameObject:SetActive(true);
end