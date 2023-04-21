xiangqi_MainPanel = {}
local self = xiangqi_MainPanel;

self.luab = nil;
self.per = nil;

function xiangqi_MainPanel.Start(args, father)
    self.init();
    self.per = args;
    if Util.isPc then
        self.per.transform:Find("mycarcam").transform.localRotation = Vector3.New(0, 0, 0);
    end
    self.per.transform:Find("mycarcam"):GetComponent("Camera").clearFlags = UnityEngine.CameraClearFlags.SolidColor;
    SetCanvasScalersMatch(self.per.gameObject:GetComponent('CanvasScaler'),1);
    self.guikey = xiangqi_Event.guid();
    self.initPanel();
    --LoadAsset('module17/game_xiangqislot_num', 'xiangqislot_num',self.loadNumCom); 
    self.loadNumCom(father);
end

function xiangqi_MainPanel.init(args)
    self.runconttable = nil;
    self.guikey = "cn";
    self.mygoldsp = nil;
    self.wildcont = nil;
    self.goldroll = nil;
end

function xiangqi_MainPanel.loadPerCom(args)
    xiangqi_Data.icon_res = args;
    self.initRes();
    --   xiangqi_Data.isResCom = xiangqi_Data.isResCom+1;
    --   if xiangqi_Data.isResCom==2 then
    --      xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_load_res_com);      
    --   end  
end

function xiangqi_MainPanel.loadNumCom(father)
    xiangqi_Data.numres = father.transform:Find("xiangqislot_num");

    if Util.isAndroidPlatform then
        local choum_0 = xiangqi_Data.numres:Find("choum_0");
        local choum_1 = xiangqi_Data.numres:Find("choum_1");
        local choum_6 = xiangqi_Data.numres:Find("choum_6");
        local choum_7 = xiangqi_Data.numres:Find("choum_7");
        local choum_9 = xiangqi_Data.numres:Find("choum_9");

        local win_gold_0 = xiangqi_Data.numres:Find("win_gold_0");
        local win_gold_1 = xiangqi_Data.numres:Find("win_gold_1");
        local win_gold_6 = xiangqi_Data.numres:Find("win_gold_6");
        local win_gold_7 = xiangqi_Data.numres:Find("win_gold_7");
        local win_gold_9 = xiangqi_Data.numres:Find("win_gold_9");

        win_gold_0.name = "choum_0";
        win_gold_1.name = "choum_1";
        win_gold_6.name = "choum_6";
        win_gold_7.name = "choum_7";
        win_gold_9.name = "choum_9";

        choum_0.name = "win_gold_0";
        choum_1.name = "win_gold_1";
        choum_6.name = "win_gold_6";
        choum_7.name = "win_gold_7";
        choum_9.name = "win_gold_9";

        win_gold_0:GetComponent("RectTransform").sizeDelta = Vector2.New(19, 29)
        win_gold_1:GetComponent("RectTransform").sizeDelta = Vector2.New(19, 29)
        win_gold_6:GetComponent("RectTransform").sizeDelta = Vector2.New(19, 29)
        win_gold_7:GetComponent("RectTransform").sizeDelta = Vector2.New(19, 29)
        win_gold_9:GetComponent("RectTransform").sizeDelta = Vector2.New(19, 29)

        choum_0:GetComponent("RectTransform").sizeDelta = Vector2.New(28, 40)
        choum_1:GetComponent("RectTransform").sizeDelta = Vector2.New(28, 40)
        choum_6:GetComponent("RectTransform").sizeDelta = Vector2.New(28, 40)
        choum_7:GetComponent("RectTransform").sizeDelta = Vector2.New(28, 40)
        choum_9:GetComponent("RectTransform").sizeDelta = Vector2.New(28, 40)
    end

    self.initRes1();
    self.loadPerCom(father.transform:Find("xiangqislot_icon"));
    self.loadsound(father.transform:Find("xiangqislot_sound"));
    xiangqi_Data.isResCom = 2;
    xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_load_res_com);
    --   LoadAssetAsync('module17/game_xiangqislot_icon', 'xiangqislot_icon',self.loadPerCom,false,false); 
    --   coroutine.start(function (args)
    --         coroutine.wait(0.1);
    --          LoadAssetAsync('module17/game_xiangqislot_sound', 'xiangqislot_sound',self.loadsound,false,false); 
    --    end);
end
function xiangqi_MainPanel.loadsound(args)
    xiangqi_Data.soundres = args;
    --   xiangqi_Data.isResCom = xiangqi_Data.isResCom+1;
    --   if xiangqi_Data.isResCom==2 then
    --      xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_load_res_com);      
    --   end
end

function xiangqi_MainPanel.initRes1(args)
    xiangqi_Socket.addGameMessge();
    xiangqi_Socket.playerLogon();
    self.creatRunCont();
    self.createBtn();
    self.creatLianLine();
    self.addEvent();
end

function xiangqi_MainPanel.initRes(args)
    self.createTSAnima();
    self.goldroll = xiangqi_NumRolling:New();
    self.goldroll:setfun(self, self.goldRollCom, self.goldRollIng);
    table.insert(xiangqi_Data.numrollingcont, #xiangqi_Data.numrollingcont + 1, self.goldroll);
    self.per.transform:Find("bottomcont").gameObject:SetActive(true);
    GameManager.GameScenIntEnd(self.per.transform:Find("gamesetcont").transform); --���ؼ��ϰ�ť  

    local rect = self.per.transform:Find("gamesetcont"):GetComponent("RectTransform");
    if rect == nil then
        rect = self.per.transform:Find("gamesetcont").gameObject:AddComponent(typeof(UnityEngine.RectTransform));
    end
    rect.anchorMax = Vector2.New(1,1);
    rect.anchorMin = Vector2.New(0,0);
    rect.offsetMax = Vector2.New(0,0);
    rect.offsetMin = Vector2.New(0,0);
    self.per.transform:Find("gamesetcont"):GetComponent("Canvas").sortingOrder = 7;
end

function xiangqi_MainPanel.initPanel()
    xiangqi_Rule.setPer(self.per.transform:Find("rulecont"));
end

function xiangqi_MainPanel.createBtn()
    xiangqi_BtnPanel.setPer(self.per.transform:Find("bottomcont"));
end

function xiangqi_MainPanel.creatLianLine()
    xiangqi_LianLine.setPer(self.per);
end

function xiangqi_MainPanel.createTSAnima()
    xiangqi_TSAnima.setPer(self.per);
end

function xiangqi_MainPanel.creatRunCont(args)
    self.runconttable = {};
    local item = nil;
    for i = 1, 5 do
        item = xiangqi_RunCont_Item:new();
        item:setPer(self.per.transform:Find("runcontmask/runcont/runcont_" .. i), self.per.transform:Find("runcontmask/runcont/showcont_" .. i), i);
        item:setSonItem(self.per.transform:Find("item"), self.per.transform:Find("runitem"));
        item:createSonItem(12);
        table.insert(self.runconttable, item);
    end
end

function xiangqi_MainPanel.addEvent()
    --xiangqi_Event.addEvent(xiangqi_Event.xiongm_start,self.startRunHander,self.guikey);
    xiangqi_Event.addEvent(xiangqi_Event.xiongm_start_btn_click, self.startRunHander, self.guikey);
    xiangqi_Event.addEvent(xiangqi_Event.xiongm_exit, self.gameExit, self.guikey);
    xiangqi_Event.addEvent(xiangqi_Event.xiangqi_unload_game_res, self.unloadGameRes, self.guikey);
    xiangqi_Event.addEvent(xiangqi_Event.xiongm_show_bg, self.showBg, self.guikey);
    xiangqi_Event.addEvent(xiangqi_Event.xiongm_show_free_bg_anima, self.showFreeBgAnima, self.guikey);

end

function xiangqi_MainPanel.showFreeBgAnima(args)

end

function xiangqi_MainPanel.showBg(args)


    if args.data == 2 then
        if self.per.transform:Find("bgcont/bgcont1").gameObject.activeSelf == true then
            self.bganima(args.data);
            self.per.transform:Find("bottomcont/tswints").gameObject:SetActive(false);
            self.per.transform:Find("lizi").gameObject:SetActive(false);
            self.per.transform:Find("zhipai_mianfeicishu").gameObject:SetActive(false);
            coroutine.start(function(args)
                coroutine.wait(2);
                if self.per.transform ~= nil then
                    self.per.transform:Find("bgcont/bgcont1").gameObject:SetActive(false);
                end
            end);
        end
    else
        if self.per.transform:Find("bgcont/bgcont1").gameObject.activeSelf == false then
            self.bganima(args.data);
            self.per.transform:Find("lizi").gameObject:SetActive(true);
            self.per.transform:Find("zhipai_mianfeicishu").gameObject:SetActive(true);
            self.per.transform:Find("bgcont/bgcont1").gameObject:SetActive(true);
        end
    end

    --   self.per.transform:Find("bgcont/bgcont1").gameObject:SetActive(false);
    --   self.per.transform:Find("bgcont/bgcont2").gameObject:SetActive(false);
    --   self.per.transform:Find("bgcont/bgcont"..args.data).gameObject:SetActive(true);
    --   if args.data==2 then
    --      self.per.transform:Find("bottomcont/tswints").gameObject:SetActive(false);
    --      self.per.transform:Find("lizi").gameObject:SetActive(false);
    --      self.per.transform:Find("zhipai_mianfeicishu").gameObject:SetActive(false);
    --   else
    --      self.per.transform:Find("lizi").gameObject:SetActive(true);
    --      self.per.transform:Find("zhipai_mianfeicishu").gameObject:SetActive(true);
    --   end
end

function xiangqi_MainPanel.bganima(args)
    local aplaval = 1;
    if args == 2 then
        aplaval = 0;
    end
    local item = nil;
    for i = 1, 2 do
        item = self.per.transform:Find("bgcont/bgcont1/img" .. i).gameObject;
        item.gameObject:GetComponent('Image'):DOColor(Color.New(1, 1, 1, aplaval), 2);
    end

end

function xiangqi_MainPanel.unloadGameRes(args)
    --error("______gameExit___");
    --    coroutine.start(function(args)
    --       coroutine.wait(0.5);
    --       Unload('module17/game_xiangqislot_main');
    --       Unload('module17/game_xiangqislot_icon');
    --       Unload('module17/game_xiangqislot_num');
    --       Unload('module17/game_xiangqislot_sound');
    --    end);  
end

function xiangqi_MainPanel.gameExit(args)

end

function xiangqi_MainPanel.startRunHander(args)
    xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_colse_line, nil);
    xiangqi_Event.dispathEvent(xiangqi_Event.game_once_over);
    local len = #self.runconttable;
    for i = 1, len do
        self.runconttable[i]:startRun();
    end
end

function xiangqi_MainPanel.Update()
    if xiangqi_Socket.isongame == false then
        return ;
    end
    table.foreach(xiangqi_Data.numrollingcont, function(i, k)
        k:update();
    end)
    xiangqi_BtnPanel.Update();
    xiangqi_TSAnima.Update();
end

function xiangqi_MainPanel.FixedUpdate()
    if xiangqi_Socket.isongame == false then
        return ;
    end
    table.foreach(self.runconttable, function(i, k)
        k:Update();
    end)
end