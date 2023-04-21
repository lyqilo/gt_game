flm_MainPanel = {}
local self = flm_MainPanel;

self.luab = nil;
self.per = nil;

function flm_MainPanel.Start(args, father)
    self.init();
    self.per = args;
    self.per.transform:Find("mycarcam"):GetComponent('Camera').clearFlags = UnityEngine.CameraClearFlags.SolidColor
    self.guikey = flm_Event.guid();
    GameManager.GameScenIntEnd(self.per.transform:Find("gamesetcont").transform); --���ؼ��ϰ�ť 
    self.initPanel();
    --LoadAsset('module13/game_gongfupanda_num', 'gongfupanda_num',self.loadNumCom);
    self.loadNumCom(father);
end

function flm_MainPanel.init(args)
    self.runconttable = nil;
    self.guikey = "cn";
    self.mygoldsp = nil;
    self.wildcont = nil;
    self.goldroll = nil;
    self.bgicon = nil;
    self.freePaojinbinAnima1 = nil;
    self.freePaojinbinAnima2 = nil;
    self.bgYanHua = nil;
end

function flm_MainPanel.loadPerCom(args)
    flm_Data.icon_res = args;
    self.initRes();
    --   flm_Data.isResCom = flm_Data.isResCom+1;
    --   if flm_Data.isResCom==2 then
    --      flm_Event.dispathEvent(flm_Event.xiongm_load_res_com);      
    --   end
end

function flm_MainPanel.loadNumCom(father)
    flm_Data.numres = father.transform:Find("flm_num");
    self.loadPerCom(father.transform:Find("flm_icon"));
    self.loadsound(father.transform:Find("flm_sound"));
    self.initRes1();
    flm_Data.isResCom = 2;
    flm_Event.dispathEvent(flm_Event.xiongm_load_res_com);
    --   LoadAssetAsync('module13/game_gongfupanda_icon', 'gongfupanda_icon',self.loadPerCom,false,false); 
    --   coroutine.start(function (args)
    --         coroutine.wait(0.1);
    --          LoadAssetAsync('module13/game_gongfupanda_sound', 'gongfupanda_sound',self.loadsound,false,false); 

    --    end);
end

function flm_MainPanel.loadsound(args)
    flm_Data.soundres = args;
    --    flm_Data.isResCom = flm_Data.isResCom+1;
    --    if flm_Data.isResCom==2 then
    --      flm_Event.dispathEvent(flm_Event.xiongm_load_res_com);      
    --   end
end

function flm_MainPanel.initRes1(args)
    self.addEvent();
    self.creatRunCont();
    --self.createLine();
    --self.creatChoum();
    self.createBtn();
    self.creatLianLine();
    flm_Socket.addGameMessge();
    flm_Socket.playerLogon();
    --self.creatWinGlod(); 
    coroutine.start(function()
        coroutine.wait(2);
        GameSetsBtnInfo.SetPlaySuonaPos(0, 190, 0);
    end);

end

function flm_MainPanel.initRes(args)
    self.createTSAnima();
    self.goldroll = flm_NumRolling:New();
    self.goldroll:setfun(self, self.goldRollCom, self.goldRollIng);
    table.insert(flm_Data.numrollingcont, #flm_Data.numrollingcont + 1, self.goldroll);
    self.per.transform:Find("bottomcont").gameObject:SetActive(true);

    self.bgYanHua = self.per.transform:Find("yanhua");
    self.bgYanHua.gameObject:SetActive(false);

    self.freePaojinbinAnima1 = self.per.transform:Find("bgcont/bgcont1/leftanima").gameObject:AddComponent(typeof(ImageAnima));
    self.freePaojinbinAnima2 = self.per.transform:Find("bgcont/bgcont1/rightanima").gameObject:AddComponent(typeof(ImageAnima));
    self.freePaojinbinAnima1.fSep = 0.07;
    self.freePaojinbinAnima2.fSep = 0.07;
    for i = 1, 17 do
        self.freePaojinbinAnima1:AddSprite(flm_Data.icon_res.transform:Find("paojb_anima_" .. i):GetComponent('Image').sprite);
        self.freePaojinbinAnima2:AddSprite(flm_Data.icon_res.transform:Find("paojb_anima_" .. i):GetComponent('Image').sprite);
    end


end

function flm_MainPanel.initPanel()
    flm_Rule.setPer(self.per.transform:Find("rulecont"));
    self.per.transform:Find("bottomcont/tsmodets/freetips").gameObject:SetActive(false);
end

function flm_MainPanel.createBtn()
    flm_BtnPanel.setPer(self.per.transform:Find("bottomcont"));
end

function flm_MainPanel.creatLianLine()
    flm_LianLine.setPer(self.per.transform:Find("line"), self.per.transform:Find("linecont"), self.per);
end

function flm_MainPanel.createTSAnima()
    flm_TSAnima.setPer(self.per);
end

function flm_MainPanel.creatRunCont(args)
    self.runconttable = {};
    local item = nil;
    for i = 1, 5 do
        item = flm_RunCont_Item:new();
        item:setPer(self.per.transform:Find("runcontmask/runcont/runcont_" .. i), self.per.transform:Find("runcontmask/runcont/showcont_" .. i), i);
        item:setSonItem(self.per.transform:Find("item"));
        item:createSonItem(12);
        table.insert(self.runconttable, item);
    end
    --       self.compitem = flm_RunComp:new();
    --       self.compitem:setPer(self.per.transform:Find("runcontmask/runcont/runcont_1"));
    --       self.compitem:setSonItem(self.per.transform:Find("item"));
    --       self.compitem:createSonItem(15);
end

function flm_MainPanel.addEvent()
    --flm_Event.addEvent(flm_Event.xiongm_start,self.startRunHander,self.guikey);
    flm_Event.addEvent(flm_Event.xiongm_start_btn_click, self.startRunHander, self.guikey);
    flm_Event.addEvent(flm_Event.xiongm_exit, self.gameExit, self.guikey);
    flm_Event.addEvent(flm_Event.xiongm_unload_game_res, self.unloadGameRes, self.guikey);
    flm_Event.addEvent(flm_Event.xiongm_close_free_bg, self.closeFreeBg, self.guikey);
    flm_Event.addEvent(flm_Event.xiongm_show_free_bg, self.showFreeBg, self.guikey);
    flm_Event.addEvent(flm_Event.xiongm_init, self.gameInit, self.guikey);
    flm_Event.addEvent(flm_Event.xiongm_start, self.gameRunStart, self.guikey);
end

function flm_MainPanel.gameRunStart(arg)
    if flm_Data.byFreeCnt > 0 then
        self.freePaojinbinAnima1:Play();
        self.freePaojinbinAnima2:Play();
    end
end

function flm_MainPanel.gameInit(args)
    if flm_Data.isFreeing == true then
        for i = 1, 10 do
            item = self.per.transform:Find("bgcont/bgcont2/img" .. i).gameObject;
            item.gameObject:GetComponent('Image'):DOColor(Color.New(1, 1, 1, 0), 0.5);
            self.freePaojinbinAnima1:PlayAlways();
            self.freePaojinbinAnima2:PlayAlways();
            self.bgYanHua.gameObject:SetActive(false);
        end
    else
        self.bgYanHua.gameObject:SetActive(true);
    end
end

function flm_MainPanel.showFreeBg(args)
    self.setFreeBgAlpha(0);
    --self.freePaojinbinAnima1:PlayAlways();
    --self.freePaojinbinAnima2:PlayAlways();
    self.bgYanHua.gameObject:SetActive(false);
end

function flm_MainPanel.closeFreeBg(args)
    self.setFreeBgAlpha(1);
    --self.freePaojinbinAnima1:StopAndRevert();
    --self.freePaojinbinAnima2:StopAndRevert();
    self.bgYanHua.gameObject:SetActive(true);
end

function flm_MainPanel.setFreeBgAlpha(val)
    local item = nil;
    for i = 1, 10 do
        item = self.per.transform:Find("bgcont/bgcont2/img" .. i).gameObject;
        item.gameObject:GetComponent('Image'):DOColor(Color.New(1, 1, 1, val), 2);
    end
end

function flm_MainPanel.unloadGameRes(args)
    --   coroutine.start(function(args)
    --       coroutine.wait(0.5);
    --       Unload('module13/game_gongfupanda_main');
    --       Unload('module13/game_gongfupanda_icon');
    --       Unload('module13/game_gongfupanda_num');
    --       Unload('module13/game_gongfupanda_sound');
    --   end);

end

function flm_MainPanel.gameExit(args)

end

function flm_MainPanel.startRunHander(args)
    if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then
        if GameManager.IsStopGame then
            return 
         end
         
        flm_Event.dispathEvent(flm_Event.xiongm_colse_line, nil);
        flm_Event.dispathEvent(flm_Event.game_once_over);
        local len = #self.runconttable;
        for i = 1, len do
            self.runconttable[i]:startRun();
        end
    end
end

function flm_MainPanel.Update()
    if flm_Socket.isongame == false then
        return ;
    end
    table.foreach(flm_Data.numrollingcont, function(i, k)
        k:update();
    end)
    flm_BtnPanel.Update();
    flm_TSAnima.Update();

end

function flm_MainPanel.FixedUpdate()
    if flm_Socket.isongame == false then
        return ;
    end
    table.foreach(self.runconttable, function(i, k)
        k:Update();
    end)
end