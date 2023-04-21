FruitsSlot_Bell_Game = {};
local self = FruitsSlot_Bell_Game;
self.guikey = "cn";
self.per = nil;
self.bellitemtable = nil;
--self.getValueCont = 0;--点击了好多次
self.winAllMoney = 0;--总共的到好多钱
self.goldallroll = nil;
self.allgoldcont = nil;
self.cscont = nil;
self.popallmey = nil;
self.popallmeycont = nil;
function FruitsSlot_Bell_Game.setPer(args)
    self.per = args;
    self.guikey = FruitsSlotEvent.guid();
    self.bellitemtable = {};
    local itemcont = self.per.transform:Find("itemcont");
    local len = itemcont.transform.childCount;
    local item = nil;
    for i = 1, len do
        item = FruitsSlot_Bell_Game_Item:new();
        item:setPer(itemcont.transform:GetChild(i - 1), i);
        table.insert(self.bellitemtable, i, item);
    end
    -- self.per.gameObject:SetActive(false);
    self.addEvent();

    self.allgoldcont = self.per.transform:Find("numcont/cont");
    self.cscont = self.per.transform:Find("moneycont/cont");

    self.goldallroll = FruitsSlot_numRolling:New();
    self.goldallroll:setfun(self, self.goldAllRollCom, self.goldAllRollIng);
    table.insert(FruitsSlot_Data.numrollingcont, #FruitsSlot_Data.numrollingcont + 1, self.goldallroll);

    self.popallmey = self.per.transform:Find("popallmey");
    self.popallmeycont = self.per.transform:Find("popallmey/cont");

end

function FruitsSlot_Bell_Game.goldAllRollCom(obj, args)
    --if self.getValueCont==5 then
    if FruitsSlot_Data.bellnum == 0 then
        self.popallmey.gameObject:SetActive(true);
        FruitsSlot_PushFun.CreatShowNum(self.popallmeycont, self.winAllMoney, "bell_popallwin_", false, 37, true, 120, -50);
        FruitsSlot_PushFun.CreatShowNum(self.allgoldcont, self.winAllMoney, "bell_allwin_", false, 21);
    end
end

function FruitsSlot_Bell_Game.goldAllRollIng(obj, args)
    -- error("__3333_allmoeny_______");
    --error("__222_allmoeny_______"..args);
    FruitsSlot_PushFun.CreatShowNum(self.allgoldcont, args, "bell_allwin_", false, 21);
end

function FruitsSlot_Bell_Game.autoClick(args)
    error("自动点击");
    if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then

        if FruitsSlot_Data.bellnum > 0 then
            -- self.opentime = os.time();
            local count = FruitsSlot_Data.bellnum;
            for i = 1, #self.bellitemtable do
                if self.bellitemtable[i]:autoClick() == true then
                    count = count - 1;
                end
                if count <= 0 then
                    return ;
                end
            end

        end
    else
        self.ResetTime();
    end
end
self.isOpenBell = false;
self.opentime = 60;
function FruitsSlot_Bell_Game.ResetTime()
    self.isOpenBell = true;
    self.opentime = 60;
end
function FruitsSlot_Bell_Game.Update()
    if not self.isOpenBell then
        return ;
    end
    self.opentime = self.opentime - Time.deltaTime;
    if self.opentime <= 0 then
        self.isOpenBell = false;
        self.opentime = 60;
        self.autoClick();
    end
end
-- function FruitsSlot_Bell_Game.WaitClick()
--     coroutine.wait(60);
--     self.autoClick();
-- end
function FruitsSlot_Bell_Game.showGame(args)
    --self.getValueCont = 0;
    if args.data ~= nil then
        self.winAllMoney = args.data;
    else
        self.winAllMoney = 0;
    end
    -- self.opentime = os.time();
    self.isOpenBell = true;
    -- coroutine.stop(self.WaitClick);
    -- coroutine.start(self.WaitClick);
    self.per.gameObject:SetActive(true);
    self.popallmey.gameObject:SetActive(false);
    FruitsSlot_PushFun.CreatShowNum(self.cscont, FruitsSlot_Data.bellnum, "bell_cis_", false, 23);
    FruitsSlot_PushFun.CreatShowNum(self.allgoldcont, self.winAllMoney, "bell_allwin_", false, 21);
    local item = nil;
    local len = #self.bellitemtable;
    for i = 1, len do
        item = self.bellitemtable[i];
        item:setFault();
    end
    FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_bell_game, true, true);
end
function FruitsSlot_Bell_Game.gameExit(args)
    self.guikey = "cn";
    self.per = nil;
    self.bellitemtable = nil;
    --self.getValueCont = 0;--点击了好多次
    self.winAllMoney = 0;--总共的到好多钱
    self.goldallroll = nil;
    self.allgoldcont = nil;
    self.cscont = nil;
    self.popallmey = nil;
    self.popallmeycont = nil;
    self.opentime = 60;
    self.isOpenBell = false;
    -- coroutine.stop(self.WaitClick);
end
function FruitsSlot_Bell_Game.addEvent()
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_bell_value, self.bellValue, self.guikey);
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_bell_start, self.showGame, self.guikey);
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_exit, self.gameExit, self.guikey);
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_gold_roll_com, self.gameGlodRollCom, self.guikey);
end

function FruitsSlot_Bell_Game.gameGlodRollCom(args)
    if args.data == FruitsSlot_Config.starbell then
        FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_bell_over);
    end
end

function FruitsSlot_Bell_Game.removeEvent()

end

function FruitsSlot_Bell_Game.bellValue(args)


    --self.getValueCont =  self.getValueCont + 1;
    --error("__111_allmoeny_______");
    local allmoeny = self.winAllMoney + args.data.money;
    self.goldallroll:setdata(self.winAllMoney, allmoeny, 0.5, true);
    -- error("__111_allmoeny_______"..allmoeny);
    self.winAllMoney = self.winAllMoney + args.data.money;
    --FruitsSlot_PushFun.CreatShowNum(self.cscont,5-self.getValueCont,"bell_cis_",false,23);
    FruitsSlot_PushFun.CreatShowNum(self.cscont, FruitsSlot_Data.bellnum, "bell_cis_", false, 23);
    FruitsSlot_PushFun.CreatShowNum(self.allgoldcont, self.winAllMoney, "bell_allwin_", false, 21);
    --if self.getValueCont==5 then
    if FruitsSlot_Data.bellnum == 0 then
        coroutine.start(function(args)
            coroutine.wait(4);
            FruitsSlot_Socket.isReqBellClick = false;
            self.per.gameObject:SetActive(false);
            self.isOpenBell = false;
            self.opentime = 60;
            FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_bell_game, true, false);
            FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_show_win_gold, { isdispathgameover = false, addgold = self.winAllMoney, smoney = FruitsSlot_Data.lineWinScore, durtimer = 2, emoney = FruitsSlot_Data.lineWinScore + self.winAllMoney, rate = 0, ftar = FruitsSlot_Config.starbell });
        end);
    end
end