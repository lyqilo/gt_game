FruitsSlot_Bell_Game_Item = {};
local self = FruitsSlot_Bell_Game_Item;


function FruitsSlot_Bell_Game_Item:new()
    local go = {};
    self.guikey = "cn";
    setmetatable(go, { __index = self });
    go.guikey = FruitsSlotEvent.guid();
    return go;
end

function FruitsSlot_Bell_Game_Item:init(args)
    self.item = nil;
    self.anima = nil;-- 动画
    self.button = nil;
    self.curindex = 0;
    self.goldroll = nil;
    self.numcont = nil;
    self.goldanima = nil;
end

function FruitsSlot_Bell_Game_Item:setPer(per, index)
    self:init();
    self.item = per;
    self.curindex = index;
    self.button = self.item.transform:Find("button");
    self.numcont = self.item.transform:Find("moneycont");

    local icon = self.item.transform:Find("anima");
    --   icon.gameObject:AddComponent(typeof(ImageAnima));
    Util.AddComponent("ImageAnima", icon.gameObject);
    self.anima = icon.transform:GetComponent("ImageAnima");
    self.anima:SetEndEvent(self.playCom);
    self:setAnima(self.anima, FruitsSlot_Config.resimg_config[FruitsSlot_Config.e_bell].animaimg, FruitsSlot_Config.resimg_config[FruitsSlot_Config.e_bell].count);
    self.anima.fSep = 0.1;
    self.anima:Stop();

    --   self.goldanima = self.item.transform:Find("goldanima").gameObject:AddComponent(typeof(ImageAnima));
    self.goldanima = Util.AddComponent("ImageAnima", self.item.transform:Find("goldanima").gameObject);

    self:setAnima(self.goldanima, "bell_gold_anima", 15);
    self.goldanima.fSep = 0.1;
    self.goldanima:Stop();


    self:addEvent();
    self.goldroll = FruitsSlot_numRolling:New();
    self.goldroll:setfun(self, self.goldRollCom, self.goldRollIng);
    table.insert(FruitsSlot_Data.numrollingcont, #FruitsSlot_Data.numrollingcont + 1, self.goldroll);
end

function FruitsSlot_Bell_Game_Item:goldRollCom(args)
    FruitsSlot_Socket.isReqBellClick = false;
end
function FruitsSlot_Bell_Game_Item:goldRollIng(args)
    --error("______goldRollIng______"..args);
    FruitsSlot_PushFun.CreatShowNum(self.numcont, args, "bell_popallwin_", true, 37, true, 90, -30);
end

function FruitsSlot_Bell_Game_Item:addEvent()
    FruitsSlot_Data.luabe:AddClick(self.button.gameObject, FruitsSlotEvent.hander(self, self.btnHander));
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_bell_value, FruitsSlotEvent.hander(self, self.bellValue), self.guikey);
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_init, FruitsSlotEvent.hander(self, self.gameInit), self.guikey);

end

function FruitsSlot_Bell_Game_Item:removeEvent()

end

function FruitsSlot_Bell_Game_Item:gameInit(args)
    local fdata = FruitsSlot_Data.getOpenBell(self.curindex);
    if fdata ~= nil then
        self.button.gameObject:GetComponent("Button").interactable = false;
        FruitsSlot_PushFun.CreatShowNum(self.numcont, fdata.val, "bell_popallwin_", true, 37, true, 90, -30);
    end
end

function FruitsSlot_Bell_Game_Item:bellValue(args)
    local data = args.data;
    if data.index == self.curindex then
        self.anima:StopAndRevert();
        self.button.gameObject:SetActive(true);
        self.goldroll:setdata(0, data.money, 0.5);
        self.goldanima:Play();
        FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_click_bell, false, false);
    end
end

function FruitsSlot_Bell_Game_Item:setFault()
    self:setInteractable(true);
    self:clearnum();
    self.button.gameObject:SetActive(true);
    FruitsSlot_Socket.isReqBellClick = false;
end

function FruitsSlot_Bell_Game_Item:setInteractable(args)
    self.button.gameObject:GetComponent("Button").interactable = args;
end

function FruitsSlot_Bell_Game_Item:clearnum()
    local len = self.numcont.transform.childCount;
    for i = 1, len do
        self.numcont.transform:GetChild(i - 1).gameObject:SetActive(false);
    end

end

function FruitsSlot_Bell_Game_Item:btnHander(args)
    if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then

        if FruitsSlot_Socket.isReqBellClick == true then
            return;
        end
        if FruitsSlot_Data.bellnum == 0 then
            return;
        end
        FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_btn, false, false);
        self:playAnima();
        self.button.gameObject:SetActive(false);
        self.button.gameObject:GetComponent("Button").interactable = false;
        coroutine.start(function(args)
            FruitsSlot_Socket.isReqBellClick = true;
            coroutine.wait(1);
            FruitsSlot_Socket.reqBellClick(self.curindex);
            FruitsSlot_Bell_Game.ResetTime();
            -- coroutine.stop(FruitsSlot_Bell_Game.WaitClick);
            -- FruitsSlot_Bell_Game.opentime = os.time();
            -- coroutine.start(FruitsSlot_Bell_Game.WaitClick);
        end);
        
    end
end

function FruitsSlot_Bell_Game_Item:autoClick()
    if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then

        if self.button.gameObject:GetComponent("Button").interactable ~= false then
            self.button.gameObject:SetActive(false);
            self.button.gameObject:GetComponent("Button").interactable = false;
            FruitsSlot_Socket.reqBellClick(self.curindex);
            return true;
        end
        return false;
        
    end
end

--设置动画
function FruitsSlot_Bell_Game_Item:setAnima(tarsp, animgname, cont)
    tarsp:ClearAll();
    for i = 1, cont do
        tarsp:AddSprite(FruitsSlot_Data.icon_res.transform:Find(animgname .. "_" .. i):GetComponent('Image').sprite);
    end
end
--播放动画
function FruitsSlot_Bell_Game_Item:playAnima()
    self.anima:PlayAlways();
end
--播放完成把默认的图片弄上去
function FruitsSlot_Bell_Game_Item:playCom()

end