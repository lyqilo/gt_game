FruitsSlot_ts_anima = {};
local self = FruitsSlot_ts_anima;

self.guikey = "cn";
self.per = nil;
self.mainper = nil;
self.anima = nil;
self.iswildplay = false;
self.bg = nil;
self.wildsp = nil;
function FruitsSlot_ts_anima.setPer(args, mainper)
    self.init();
    self.guikey = FruitsSlotEvent.guid();
    self.per = args;
    --self.per.gameObject:SetActive(true);
    self.mainper = mainper;
    self.bg = self.per.transform:Find("bgmask/bg");
    self.wildsp = self.per.transform:Find("wildsp");
    local obj = self.per.transform:Find("bganima");
    --   obj.gameObject:AddComponent(typeof(ImageAnima));
    Util.AddComponent("ImageAnima", obj.gameObject);
    self.anima = obj.transform:GetComponent("ImageAnima");
    self.anima:SetEndEvent(self.runPlayCom);
    self.anima.fSep = 0.2;
    --self.anima:Stop();
    self.bg.gameObject:SetActive(false);
    self.wildsp.gameObject:SetActive(false);
    self.addEvent();
end

function FruitsSlot_ts_anima.init(args)
    self.guikey = "cn";
    self.per = nil;
    self.mainper = nil;
    self.anima = nil;
    self.iswildplay = false;
    self.bg = nil;
    self.wildsp = nil;
end

function FruitsSlot_ts_anima.playCom(args)

end

function FruitsSlot_ts_anima.addEvent()
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_img_play_com, self.gameImgPlayCom, self.guikey);
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_bell_over, self.gameBellOver, self.guikey);

end

function FruitsSlot_ts_anima.removeEvent()

end

function FruitsSlot_ts_anima.gameBellOver(args)
    self.countWild();
end

function FruitsSlot_ts_anima.gameImgPlayCom(args)
    --error("________gameImgPlayCom________");
    --error("________gameImgPlayCom________"..args.data);
    if args.data == FruitsSlot_Config.select_img_play_com_type_line then
        if FruitsSlot_Data.byFullScreenType == FruitsSlot_Config.E_FULL_SCREEN_FRUIT then
            --FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_show_win_gold,{isdispathgameover = false,addgold =FruitsSlot_Data.allScreenWinScore,smoney = 0,durtimer = 2,emoney=FruitsSlot_Data.allScreenWinScore,rate=0});
            self.setAnimaBg(1, 5, "gametouming");
            --self.setAnima(FruitsSlot_Config.e_fruit_cherry_anima,FruitsSlot_Config.resimg_config[FruitsSlot_Config.e_fruit_cherry].count);
            self.setBgAnima(FruitsSlot_Config.E_FULL_SCREEN_FRUIT);
            return;
        elseif FruitsSlot_Data.byFullScreenType == FruitsSlot_Config.E_FULL_SCREEN_BAR then
            -- FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_show_win_gold,{isdispathgameover = false,addgold =FruitsSlot_Data.allScreenWinScore,smoney = 0,durtimer = 2,emoney=FruitsSlot_Data.allScreenWinScore,rate=0});
            self.setAnimaBg(1, 5, "gametouming");
            --self.setAnima(FruitsSlot_Config.e_bar_big_anima,FruitsSlot_Config.resimg_config[FruitsSlot_Config.e_bar_big].count);
            self.setBgAnima(FruitsSlot_Config.E_FULL_SCREEN_BAR);
            return;
        elseif FruitsSlot_Data.byFullScreenType == FruitsSlot_Config.E_FULL_SCREEN_SEVEN then
            --FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_show_win_gold,{isdispathgameover = false,addgold =FruitsSlot_Data.allScreenWinScore,smoney = 0,durtimer = 2,emoney=FruitsSlot_Data.allScreenWinScore,rate=0});
            self.setAnimaBg(1, 5, "gametouming");
            --self.setAnima(FruitsSlot_Config.e_seven_small_anima,FruitsSlot_Config.resimg_config[FruitsSlot_Config.e_seven_small].count);
            self.setBgAnima(FruitsSlot_Config.E_FULL_SCREEN_SEVEN);
            return;
        end
        --error("________1111___bBellGame_____");
        if FruitsSlot_Data.bBellGame == 1 then
            -- error("________1111________");
            self.playBell();
            FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_enter_bell_on, false, false);
            return;
        end
        self.countWild();
    elseif args.data == FruitsSlot_Config.select_img_play_com_type_bell then
        self.enterGameBell();
    end
end

--进入铃铛游戏
function FruitsSlot_ts_anima.enterGameBell(args)
    --error("________enterGameBell________");
    FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_bell_start);
end

function FruitsSlot_ts_anima.playBell()
    local len = #FruitsSlot_Data.openimg;
    local item = nil;
    local issetdispath = false;
    for i = 1, len do
        if FruitsSlot_Data.openimg[i] == FruitsSlot_Config.e_bell then
            item = FruitsSlot_Data.allshowitem[i];
            if issetdispath == false then
                issetdispath = true;
                item:setAnima(FruitsSlot_Config.resimg_config[FruitsSlot_Config.e_bell].animaimg, FruitsSlot_Config.resimg_config[FruitsSlot_Config.e_bell].count, issetdispath);
                item:addAnima(FruitsSlot_Config.resimg_config[FruitsSlot_Config.e_bell].animaimg, FruitsSlot_Config.resimg_config[FruitsSlot_Config.e_bell].count);--多转一轮
            else
                item:setAnima(FruitsSlot_Config.resimg_config[FruitsSlot_Config.e_bell].animaimg, FruitsSlot_Config.resimg_config[FruitsSlot_Config.e_bell].count, false);
                item:addAnima(FruitsSlot_Config.resimg_config[FruitsSlot_Config.e_bell].animaimg, FruitsSlot_Config.resimg_config[FruitsSlot_Config.e_bell].count);--多转一轮
            end
        end
    end
    FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_play_stop_light_anima, true);
    local alllen = #FruitsSlot_Data.allshowitem;
    for a = 1, alllen do
        FruitsSlot_Data.allshowitem[a]:playAnima(FruitsSlot_Config.select_img_play_com_type_bell);
    end
end

function FruitsSlot_ts_anima.closeGameBell(args)
    self.countWild();
end

function FruitsSlot_ts_anima.countWild()
    local len = #FruitsSlot_Data.openwild;
    local startindex = 0;
    local count = 0;
    local isbreak = false;
    for a = 1, len do
        if FruitsSlot_Data.openwild[a] > 0 then
            error("_____startindex_______" .. FruitsSlot_Data.openwild[a]);
            if startindex == 0 and a < len and FruitsSlot_Data.openwild[a] > 0 then
                startindex = a + 1;
                isbreak = true;
            end
            count = count + 1;
        else
            if isbreak then
                break;
            end
        end
    end
    if count > 0 then
        self.iswildplay = true;
        self.setAnimaBg(startindex, count, "wild_dikuan");
        self.setAnima(FruitsSlot_Config.e_double_wild_anima, FruitsSlot_Config.resimg_config[FruitsSlot_Config.e_double_wild].count, false);
        self.anima:SetEndEvent(function()
            self.runPlayCom();
            FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_show_win_gold, { isdispathgameover = true, addgold = 0, smoney = 0, durtimer = 0, emoney = 0, rate = 0, ftar = nil });
        end);
        self.wildsp.gameObject:SetActive(true);
        FruitsSlot_PushFun.CreatShowNum(self.wildsp.transform:Find("numcont"), FruitsSlot_Data.curFreeCnt, "wild_num_", false, 40, true, 85, 120);
        self.anima:Play();
        FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_play_stop_light_anima, true);
        FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_free, true, true);
    else
        self.wildsp.gameObject:SetActive(false);
        self.iswildplay = false;
        --      coroutine.start(function()
        --         coroutine.wait(2);
        --         FruitsSlot_Socket.gameOneOver(false);
        --      end);
        -- 这里的值全是0  因为我只调用里面isdispathgameover
        FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_show_win_gold, { isdispathgameover = true, addgold = 0, smoney = 0, durtimer = 0, emoney = 0, rate = 0, ftar = nil });
    end

end

function FruitsSlot_ts_anima.setAnimaBg(startname, num, kuangbg)
    self.per.gameObject:SetActive(true);
    error("==========起始位置：======" .. startname);
    local pos = self.mainper.transform:Find("bgcont/bbg" .. startname).transform.position;
    local w = self.mainper.transform:Find("bgcont/bbg" .. startname).gameObject:GetComponent("RectTransform").sizeDelta.x / 2;
    self.per.gameObject:GetComponent("Image").sprite = FruitsSlot_Data.icon_res.transform:Find(kuangbg):GetComponent('Image').sprite;
    self.per.gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(w * 2 * num + (num - 1) * 5, 489);
    self.per.transform.position = Vector3.New(pos.x, pos.y, pos.z);
    local lpos = self.per.transform.localPosition;
    self.per.transform.localPosition = Vector3.New(lpos.x - w, lpos.y, lpos.z);
end

--设置动画
function FruitsSlot_ts_anima.setAnima(animgname, cont, isplay)
    self.anima:ClearAll();
    self.bg.gameObject:SetActive(false);
    local item = FruitsSlot_Data.icon_res.transform:Find(animgname .. "_" .. 1);
    local sizedel = item.gameObject:GetComponent("RectTransform").sizeDelta;
    --error("______FruitsSlot_ts_anima.setAnima______"..sizedel.x);
    --error("______FruitsSlot_ts_anima.setAnima______"..animgname);
    self.anima:SetEndEvent(self.runPlayCom);
    self.per.transform:Find("bganima").gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(sizedel.x, sizedel.y);
    for i = 1, cont do
        self.anima:AddSprite(FruitsSlot_Data.icon_res.transform:Find(animgname .. "_" .. i):GetComponent('Image').sprite);
    end
    if isplay == true then
        self.anima:Play();
    end

end
--如果是全屏的动画
function FruitsSlot_ts_anima.setBgAnima(fulindex)
    self.anima:ClearAll();
    self.per.gameObject:SetActive(true);
    self.wildsp.gameObject:SetActive(false);
    local config = FruitsSlot_Config.resimg_full_anima_config[fulindex];
    local item = FruitsSlot_Data.icon_res.transform:Find(config.showicon);
    local sizedel = item.gameObject:GetComponent("RectTransform").sizeDelta;
    self.per.transform:Find("bganima").gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(sizedel.x, sizedel.y);
    self.per.transform:Find("bganima").gameObject:GetComponent("Image").sprite = item.gameObject:GetComponent("Image").sprite

    item = FruitsSlot_Data.icon_res.transform:Find(config.showbg);
    sizedel = item.gameObject:GetComponent("RectTransform").sizeDelta;
    self.bg.gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(sizedel.x, sizedel.y);
    self.bg.gameObject:GetComponent("Image").sprite = item.gameObject:GetComponent("Image").sprite

    self.bg.transform:DOLocalRotate(Vector3.New(0, 0, 360), config.timer, DG.Tweening.RotateMode.WorldAxisAdd);
    coroutine.start(function()
        coroutine.wait(config.timer);
        self.runPlayCom();
        FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_show_win_gold, { isdispathgameover = true, addgold = FruitsSlot_Data.allScreenWinScore, smoney = FruitsSlot_Data.lineWinScore, durtimer = 2, emoney = FruitsSlot_Data.allScreenWinScore + FruitsSlot_Data.lineWinScore, rate = 0, ftar = nil });
    end);
    self.bg.gameObject:SetActive(true);
    FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_play_stop_light_anima, true);
    FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_full, false, false);
end


function FruitsSlot_ts_anima.runPlayCom(args)
    self.per.gameObject:SetActive(false);
    FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_tes_play_com, self.iswildplay);
    --   coroutine.start(function()
    --         coroutine.wait(2);
    --         FruitsSlot_Socket.gameOneOver(false);
    --   end);
    self.iswildplay = false;
end