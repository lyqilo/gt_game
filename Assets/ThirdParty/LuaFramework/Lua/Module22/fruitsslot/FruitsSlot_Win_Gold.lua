FruitsSlot_Win_Gold = {};
local self = FruitsSlot_Win_Gold;

self.guikey = "cn";
self.per = nil;
self.winGoldroll = nil;
self.winGoldcont = nil;
self.addgold = 0;--���ӵ�Ǯ
self.isclose = true;
self.norrate = nil;
self.maxrate = nil;
self.isdispathgameover = false;--�ǲ���������Ϸ����
self.ftar = nil;--���Ǹ�������
self.waittiemr = 1;
self.curShowGameIndex = 0;
function FruitsSlot_Win_Gold.setPer(args)
    self.init();
    self.per = args;
    self.guikey = FruitsSlotEvent.guid();
    self.per.gameObject:SetActive(false);
    self.addEvent();

    self.moneycont = self.per.transform:Find("numcont");

    self.norrate = self.per.transform:Find("norrate");
    self.maxrate = self.per.transform:Find("maxrate");

    self.norrate.gameObject:SetActive(false);
    self.maxrate.gameObject:SetActive(false);
    self.winGoldroll = FruitsSlot_numRolling:New();
    self.winGoldroll:setfun(self, self.winGoldRollCom, self.winGoldRollIng);
    table.insert(FruitsSlot_Data.numrollingcont, #FruitsSlot_Data.numrollingcont + 1, self.winGoldroll);

end

function FruitsSlot_Win_Gold.init(args)
    self.guikey = "cn";
    self.per = nil;
    self.winGoldroll = nil;
    self.winGoldcont = nil;
    self.addgold = 0;--���ӵ�Ǯ
    self.waittiemr = 1;
    self.isclose = true;
    self.norrate = nil;
    self.maxrate = nil;
    self.isdispathgameover = false;--�ǲ���������Ϸ����
    self.ftar = nil;--���Ǹ�������
    self.curShowGameIndex = 0;
end

function FruitsSlot_Win_Gold.winGoldRollCom(obj, args)
    --FruitsSlot_PushFun.CreatShowNum(self.moneycont,self.addgold,"win_gold_",false,53,true,430,-200);
    if not IsNil(FruitsSlot_Data.saveaddgoldsound) then
        destroy(FruitsSlot_Data.saveaddgoldsound);
    end
    error("金币：" .. (self.addgold));
    error("金币：" .. (FruitsSlot_Data.lastshwogold + self.addgold));
    FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_gold_chang, TableUserInfo._7wGold);
    self.isDispathGameOver();
    if self.isclose == false then
        coroutine.start(function(args)
            self.isclose = true;
            coroutine.wait(self.waittiemr);
            if self.isclose == true then
                self.per.gameObject:SetActive(false);
                self.isclose = false;
            end
            if self.curShowGameIndex ~= FruitsSlot_Data.curGameIndex then
                return;
            end
            FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_gold_roll_com, self.ftar);
        end);
    end

end

function FruitsSlot_Win_Gold.winGoldRollIng(obj, args)
    FruitsSlot_PushFun.CreatShowNum(self.moneycont, args, "win_gold_", false, 58, true, 390, -160);
end

function FruitsSlot_Win_Gold.addEvent()
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_show_win_gold, self.showWinGold, self.guikey);
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_start, self.startHander, self.guikey);
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_once_over, self.onceOver, self.guikey);
end

function FruitsSlot_Win_Gold.startHander(args)
    self.per.gameObject:SetActive(false);
    self.winGoldroll.isrun = false;
    if not IsNil(FruitsSlot_Data.saveaddgoldsound) then
        destroy(FruitsSlot_Data.saveaddgoldsound);
    end
end

function FruitsSlot_Win_Gold.onceOver(args)
    self.per.gameObject:SetActive(false);
    self.winGoldroll.isrun = false;
    if not IsNil(FruitsSlot_Data.saveaddgoldsound) then
        destroy(FruitsSlot_Data.saveaddgoldsound);
    end
end


function FruitsSlot_Win_Gold.isDispathGameOver()
    if self.isdispathgameover == true then
        coroutine.start(function()
            coroutine.wait(1);
            if self.curShowGameIndex ~= FruitsSlot_Data.curGameIndex then
                return;
            end
            if FruitsSlot_Data.byFreeCnt <= 0 then
                FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_play_stop_light_anima, false);
            end
            FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_show_free);
            FruitsSlot_Socket.gameOneOver(false);
        end);
    end
end

function FruitsSlot_Win_Gold.showWinGold(args)
    -- logErrorTable(args);
    --error("_____showWinGold_________");
    self.curShowGameIndex = FruitsSlot_Data.curGameIndex;
    if FruitsSlot_Data.getIsStop() == true then
        FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_start_btn_inter, true);
    end
    self.isdispathgameover = args.data.isdispathgameover;--�ǲ���������Ϸ����
    self.ftar = args.data.ftar;--���Ǹ�������
    if args.data.addgold <= 0 then
        self.isDispathGameOver();
        if self.ftar == FruitsSlot_Config.starbell then
            FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_gold_roll_com, self.ftar);
        end
        return;
    end
    self.norrate.gameObject:SetActive(false);
    self.maxrate.gameObject:SetActive(false);
    if args.data.rate >= 500 then
        self.maxrate.gameObject:SetActive(true);
    elseif args.data.rate >= 100 then
        self.norrate.gameObject:SetActive(true);
    end
    self.waittiemr = 1;
    self.isclose = false;
    self.addgold = args.data.addgold;
    local emoney = args.data.emoney;
    local smoney = args.data.smoney;
    local durtimer = args.data.durtimer;
    if args.data.addgold < 10000 then
        durtimer = 2;
    elseif args.data.addgold < 1000000 then
        durtimer = 2.5;
    elseif args.data.addgold < 10000000 then
        durtimer = 3;
    else
        durtimer = 3.5;
    end
    --error("__11___showWinGold________"..self.addgold);
    FruitsSlot_PushFun.CreatShowNum(self.moneycont, smoney, "win_gold_", false, 58, true, 390, -160);
    if smoney > emoney then
        self.waittiemr = 0.1;
        coroutine.start(function()
            coroutine.wait(1);
            if self.curShowGameIndex ~= FruitsSlot_Data.curGameIndex then
                return;
            end
            self.winGoldroll:setdata(smoney, emoney, durtimer);
            FruitsSlot_Data.saveaddgoldsound = FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_gold_add, false, false);
        end);
    else
        self.winGoldroll:setdata(smoney, emoney, durtimer);
        FruitsSlot_Data.saveaddgoldsound = FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_gold_add, false, false);
    end
    self.per.gameObject:SetActive(true);
    if not IsNil(FruitsSlot_Data.saveaddgoldsound) then
        destroy(FruitsSlot_Data.saveaddgoldsound);
    end

end

function FruitsSlot_Win_Gold.removeEvent()

end