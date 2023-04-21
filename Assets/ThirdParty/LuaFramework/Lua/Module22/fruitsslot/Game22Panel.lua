require "Module22/fruitsslot/FruitsSlot_Config"
require "Module22/fruitsslot/FruitsSlot_Data"
require "Module22/fruitsslot/FruitsSlot_Run_Soon_Item"
require "Module22/fruitsslot/FruitsSlot_RunCont_Item"
require "Module22/fruitsslot/FruitsSlotEvent"
require "Module22/fruitsslot/FruitsSlot_Line"
require "Module22/fruitsslot/FruitsSlot_CMD"
require "Module22/fruitsslot/FruitsSlot_Socket"
require "Module22/fruitsslot/FruitsSlot_ts_anima"
require "Module22/fruitsslot/FruitsSlot_numRolling"
require "Module22/fruitsslot/FruitsSlot_Bell_Game"
require "Module22/fruitsslot/FruitsSlot_Bell_Game_Item"
require "Module22/fruitsslot/FruitsSlot_PushFun"
require "Module22/fruitsslot/FruitsSlot_Choum"
require "Module22/fruitsslot/FruitsSlot_Win_Gold"
require "Module22/fruitsslot/FruiltsSlot_Rule"

Game22Panel = {}
local self = Game22Panel

self.item = nil
self.per = nil
self.cont = nil
self.luabe = nil
self.runtabel = nil
self.autostartbtn = nil
self.stopautobtn = nil
self.stopautobtnnum = nil
self.selectnumcont = nil
self.bellGameIngIconCont = nil
self.rulebtn = nil
self.guikey = "cn"
self.mygoldcont = nil
self.isCountAutoTimer = false --是不是记录 自动按钮按下的时间
self.countAutoTimer = 0 --按钮按下的时间
self.freetimesp = nil
self.lockbgcont = nil
self.lockbgdefalutpos = nil
self.light_anima_l = nil
self.light_anima_r = nil

self.frulecont = nil
self.fwingoldcont = nil
self.fbellgamecont = nil

self.show1 = nil

self.parentobj = nil
self.autoClick = false
function Game22Panel.Awake()
    Event.AddListener(HallScenPanel.ReconnectEvent, self.Reconnect);
    --self.parentobj = obj;
    --ResManager:LoadAsset('game_fruitsslotmain', 'fruitsslotmain',self.loadPercom);
    self.loadPercom()
end
function Game22Panel.Reconnect()
    log("重连成功")

    FruitsSlot_Socket.playerLogon()
    coroutine.start(function ()
        coroutine.wait(1);
        FruitsSlot_Socket.gameOneOver(FruitsSlot_Data.isAutoGame);
    end)
end
function Game22Panel.OnDestroy()
    Event.RemoveListener(HallScenPanel.ReconnectEvent, self.Reconnect);
end
function Game22Panel.loadPercom(args)
    self.parentobj = GameObject.Find("Game22Panel").transform
    FruitsSlot_Socket.gameInitData()
    self.init()
    math.randomseed(os.time())
    self.per = self.parentobj.transform:Find("fruitsslotmain")
    local bg = self.per:Find("bg")
    -- bg:GetComponent("RectTransform").sizeDelta = Vector2.New(750 * (Screen.width/Screen.height), 770)
    -- if Util.isPc then
    --     self.per.transform:Find("mycarcam").transform.localRotation = Vector3.New(0, 0, 0)
    -- end
    -- --self.per.transform:Find("mycarcam").transform.localRotation = Vector3.New(0, 0, 0)

    -- SetCanvasScalersMatch(self.per.gameObject:GetComponent("CanvasScaler"))

    bg:GetComponent("RectTransform").sizeDelta = Vector2.New(750 * (Screen.width / Screen.height), 750)
    self.per:GetComponent("CanvasScaler").referenceResolution = Vector2.New(1334, 750);
    self.per.transform:Find("mycarcam").localRotation = Quaternion.identity;
    self.per.transform:Find("mycarcam"):GetComponent('Camera').clearFlags = UnityEngine.CameraClearFlags.SolidColor
    self.per.transform:Find("mycarcam"):GetComponent('Camera').backgroundColor = Color.New(0, 0, 0, 0)

    gameObject = self.parentobj.gameObject --obj:SetActive(true);

    GameManager.PanelRister(gameObject)

    self.item = self.per.transform:Find("item")
    self.show1 = self.per.transform:Find("runcontmask/show1")
    self.autostartbtn = self.per.transform:Find("bottomcont/btncont/autostartbtn")
    self.stopautobtn = self.per.transform:Find("bottomcont/btncont/closestartbtncont/closestartbtn")
    self.stopautobtnnum = self.per.transform:Find("bottomcont/btncont/closestartbtncont/numtxt").gameObject
    self.rulebtn = self.per.transform:Find("bottomcont/mygoldcont/seeguiz")
    self.mygoldcont = self.per.transform:Find("bottomcont/mygoldcont/numcont")
    self.freetimesp = self.per.transform:Find("bottomcont/btncont/freetimesp")
    self.bellGameIngIconCont = self.per.transform:Find("bottomcont/btncont/bellgame")
    self.lockbgcont = self.per.transform:Find("bgcont/lockbgcont/bgcont")
    --self.per.transform:Find("bottomcont/choumcont/jiantdown").gameObject:SetActive(false);
    --    self.light_anima_l = self.per.transform:Find("bgcont/light_anima_l").gameObject:AddComponent(typeof(ImageAnima));
    --    self.light_anima_r = self.per.transform:Find("bgcont/light_anima_r").gameObject:AddComponent(typeof(ImageAnima));
    --    self.light_anima_l.fSep = 0.1;
    --    self.light_anima_r.fSep = 0.1;
    local pos = self.lockbgcont.transform.localPosition
    self.lockbgdefalutpos = Vector3.New(pos.x, pos.y, pos.z)
    self.luabe = self.parentobj.transform:GetComponent("LuaBehaviour")
    FruitsSlot_Data.luabe = self.luabe
    --ResManager:LoadAsset("game_fruitsslotmain_num", 'fruitsslotmain_num', self.LoadAssetNumCallBack);
    self.frulecont = self.per.transform:Find("rulecont")
    self.fwingoldcont = self.per.transform:Find("wingoldcont")
    self.fbellgamecont = self.per.transform:Find("bellgamecont")
    self.selectnumcont = self.per.transform:Find("bottomcont/btncont/selectnumcont").gameObject
    self.per.transform:Find("titlecont/lingdcont").gameObject:SetActive(false)

    self.stopautobtn.gameObject:SetActive(false)
    self.freetimesp.gameObject:SetActive(false)
    self.frulecont.gameObject:SetActive(false)
    self.fwingoldcont.gameObject:SetActive(false)
    self.fbellgamecont.gameObject:SetActive(false)
    self.bellGameIngIconCont.gameObject:SetActive(false)
    self.selectnumcont.gameObject:SetActive(false)
    self.stopautobtnnum.gameObject:SetActive(false)

    --    self.per.transform:SetParent(self.parentobj.transform);
    --    self.per.transform.localScale=Vector3.one;
    --    self.per.transform.localPosition=Vector3.New(0,0,0);
    self.LoadAssetNumCallBack(self.parentobj.transform:Find("fruitsslotmain_num"))
    GameManager.PanelInitSucceed(gameObject)

    self.guikey = FruitsSlotEvent.guid()
    -- GameManager.GameScenIntEnd(self.per.transform:Find("gamesetcont").transform); --加载集合按钮
    GameManager.GameScenIntEnd() --加载集合按钮
end

function Game22Panel.init()
    self.item = nil
    self.per = nil
    self.cont = nil
    self.luabe = nil
    self.runtabel = nil
    self.autostartbtn = nil
    self.stopautobtn = nil
    self.stopautobtnnum = nil
    self.selectnumcont = nil
    self.rulebtn = nil
    self.guikey = "cn"
    self.mygoldcont = nil
    self.isCountAutoTimer = false --是不是记录 自动按钮按下的时间
    self.countAutoTimer = 0 --按钮按下的时间
    self.freetimesp = nil
    self.lockbgcont = nil
    self.lockbgdefalutpos = nil
    self.light_anima_l = nil
    self.light_anima_r = nil
    self.frulecont = nil
    self.fwingoldcont = nil
    self.fbellgamecont = nil
    self.show1 = nil
    self.autoClick = false
    self.bellGameIngIconCont = nil --按钮拦显示当前正在铃铛游戏
end

function Game22Panel.addEvent()
    --self.luabe:AddClick(self.autostartbtn.gameObject,self.autoStartHander);
    self.luabe:AddClick(self.stopautobtn.gameObject, self.stopAutoHander)
    self.luabe:AddClick(self.rulebtn.gameObject, FruiltsSlot_Rule.show)
    --FruitsSlotEvent.addEvent(FruitsSlotEvent.game_start,self.gameStart,self.guikey);
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_start_btn_click, self.gameStart, self.guikey)
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_gold_chang, self.gameGoldChang, self.guikey)
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_show_colse_lock_bg, self.showOrCloseLockBg, self.guikey)
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_play_stop_light_anima, self.playOrStopLightAnima, self.guikey)
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_show_free, self.showFree, self.guikey)
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_bell_start, self.bellStart, self.guikey)
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_bell_over, self.bellOver, self.guikey)
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_start_btn_inter, self.startBtnInter, self.guikey)
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_over, FruitsSlotEvent.hander(self, self.gameOver), self.guikey)
    local eventTrigger = Util.AddComponent("EventTriggerListener", self.autostartbtn.gameObject)
    eventTrigger.onDown = self.autoStartDown
    eventTrigger.onUp = self.autoStartUp
    self.selectnumcont.transform:Find("closebtn/Text").gameObject:SetActive(false)
    self.luabe:AddClick(self.selectnumcont.transform:Find("closebtn").gameObject, self.closeSelectRunNun)
    for i = 1, 4 do
        self.luabe:AddClick(self.selectnumcont.transform:Find("item_" .. i .. "/btn").gameObject, self.selectRunNunHander)
    end
end

function Game22Panel.closeSelectRunNun(args)
    self.selectnumcont.gameObject:SetActive(false)
    self.stopautobtnnum.gameObject:GetComponent("Text").text = " "
end

function Game22Panel.selectRunNunHander(args)
    local str = args.transform.parent.name
    local str1 = string.split(str, "_")
    error("________selectRunNunHander______" .. str)
    error("________selectRunNunHander______" .. str1[2])
    self.closeSelectRunNun()
    self.stopautobtn.gameObject:SetActive(true)
    FruitsSlot_Data.isAutoGame = true
    FruitsSlot_Socket.gameOneOver(true)
    self.setStartAndStopBtn()
    local datanum = { 10, 50, 100, 10000000 }
    FruitsSlot_Data.autoRunNum = datanum[tonumber(str1[2])]
    self.stopautobtnnum.gameObject:SetActive(true)
end

function Game22Panel.gameOver(args)
    if FruitsSlot_Data.autoRunNum < 1 and FruitsSlot_Data.isAutoGame == true then
        self.stopAutoHander()
        self.stopautobtnnum.gameObject:SetActive(false)
    else
        local str = FruitsSlot_Data.autoRunNum
        if FruitsSlot_Data.autoRunNum > 1000 then
            str = "无限"
        else
            FruitsSlot_Data.autoRunNum = FruitsSlot_Data.autoRunNum - 1
        end
        self.stopautobtnnum.gameObject:GetComponent("Text").text = str
    end
end

function Game22Panel.autoStartDown(args)
    self.isCountAutoTimer = true --是不是记录 自动按钮按下的时间
end

function Game22Panel.autoStartUp(args)
    if self.isCountAutoTimer == true then
        if self.autostartbtn.gameObject:GetComponent("Button").interactable then
            self.autoStartHander()
        end
    end
    self.isCountAutoTimer = false --是不是记录 自动按钮按下的时间
    self.countAutoTimer = 0 --按钮按下的时间
end

function Game22Panel.showOrCloseLockBg(args)
    if args.data == true then
        self.lockbgcont.transform:DOLocalMove(
                Vector3.New(self.lockbgdefalutpos.x, 0, self.lockbgdefalutpos.z),
                0.5,
                false
        )
    else
        self.lockbgcont.transform.localPosition = Vector3.New(self.lockbgdefalutpos.x, self.lockbgdefalutpos.y, self.lockbgdefalutpos.z)
    end
end

function Game22Panel.playOrStopLightAnima(args)
    -- error("______playOrStopLightAnimaplayOrStopLightAnimaplayOrStopLightAnima____________________");
    if args.data == true then
        --error("___11___playOrStopLightAnimaplayOrStopLightAnimaplayOrStopLightAnima____________________");
        --       self.light_anima_l:PlayAlways();
        --       self.light_anima_r:PlayAlways();
    else
        --       self.light_anima_l:StopAndRevert();
        --       self.light_anima_r:StopAndRevert();
    end
end

function Game22Panel.stopAutoHander(args)
    FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_btn, false, false)
    self.stopautobtn.gameObject:SetActive(false)
    self.stopautobtnnum.gameObject:SetActive(false)
    FruitsSlot_Data.isAutoGame = false
    self.setStartAndStopBtn()
end

function Game22Panel.autoStartHander(args)
    if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then
        if GameManager.IsStopGame then
            return 
         end
        -- error("_____autoStartHander_____");
        if FruitsSlot_Socket.isongame == false then
            return
        end
        if FruitsSlot_Data.isGoldMoreThan() == true then
            return
        end
        if self.autoClick == true then
            return
        end
        if FruitsSlot_Socket.isHandMoney() == false or self.selectnumcont.gameObject.activeSelf == true then
            return
        end
        self.autoClick = true
        FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_start_btn_click)
        coroutine.start(
                function(args)
                    self.startBtnInter({ data = false })
                    FruitsSlot_Socket.isReqDataIng = false
                    FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_btn, false, false)
                    FruitsSlot_Socket.reqStart()
                    coroutine.wait(1)
                    self.autoClick = false
                end
        )        
    end
end

function Game22Panel.setStartAndStopBtn()
    if FruitsSlot_Data.isAutoGame == true then
        self.stopautobtn.gameObject:SetActive(true)
        self.stopautobtnnum.gameObject:SetActive(true)
        self.autostartbtn.gameObject:SetActive(false)
    else
        self.stopautobtn.gameObject:SetActive(false)
        self.stopautobtnnum.gameObject:SetActive(false)
        self.autostartbtn.gameObject:SetActive(true)
    end
end

function Game22Panel.startBtnInter(args)
    self.autostartbtn.gameObject:GetComponent("Button").interactable = args.data
    if args.data == true then
        self.autostartbtn.gameObject:GetComponent("Image").color = Color.New(255, 255, 255, 255)
    else
        self.autostartbtn.gameObject:GetComponent("Image").color = Color.New(160, 160, 160, 255)
    end
end

function Game22Panel.gameGoldChang(args)
    self.glodShow(args)
end

function Game22Panel.glodShow(margs)
    if FruitsSlot_Data.isshowmygold == false and margs.data == nil then
        return
    end
    if margs.data == nil then
        FruitsSlot_Data.lastshwogold = FruitsSlot_Data.myinfoData._7wGold
    else
        FruitsSlot_Data.lastshwogold = margs.data
    end
    FruitsSlot_PushFun.CreatShowNum(self.mygoldcont, FruitsSlot_Data.lastshwogold, "my_gold_", false, 25, true, 230, -43)
end

function Game22Panel.gameStart(args)
    if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then
        if GameManager.IsStopGame then
            return 
         end
        --error("____Game22Panel.gameStart_____");
        if FruitsSlot_Data.byFreeCnt <= 0 then
            FruitsSlot_PushFun.CreatShowNum(
                    self.mygoldcont,
                    FruitsSlot_Data.myinfoData._7wGold - FruitsSlot_Data.curSelectChoum * FruitsSlot_CMD.D_LINE_COUNT,
                    "my_gold_",
                    false,
                    25,
                    true,
                    230,
                    -43
            )
        end
        FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_once_over)
        if args.data ~= nil then
            self.runtabel[args.data]:startRun()
            self.runtabel[args.data]:runStop()
        else
            for i = 1, 5 do
                self.runtabel[i]:startRun()
            end
        end
        
    end
end

function Game22Panel.showFree(args)
    if FruitsSlot_Data.byFreeCnt > 0 then
        self.freetimesp.gameObject:SetActive(true)
        self.autostartbtn.gameObject:SetActive(false)
        self.stopautobtn.gameObject:SetActive(false)
        self.stopautobtnnum.gameObject:SetActive(false)
        FruitsSlot_PushFun.CreatShowNum(
                self.freetimesp.transform:Find("numcont"),
                FruitsSlot_Data.byFreeCnt,
                "free_",
                false,
                20,
                2,
                100,
                -111
        )
        FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_free, true, true)
    else
        FruitsSlot_Socket.playaudio(FruitsSlot_Config.sound_free, true, false)
        self.freetimesp.gameObject:SetActive(false)
        if FruitsSlot_Data.isAutoGame == true then
            self.stopautobtn.gameObject:SetActive(true)
            self.stopautobtnnum.gameObject:SetActive(true)
            self.autostartbtn.gameObject:SetActive(false)
        else
            self.stopautobtn.gameObject:SetActive(false)
            self.stopautobtnnum.gameObject:SetActive(false)
            self.autostartbtn.gameObject:SetActive(true)
        end
    end
end

function Game22Panel.bellStart(arg)
    self.freetimesp.gameObject:SetActive(false)
    --    self.autostartbtn.gameObject:SetActive(false);
    --    self.stopautobtn.gameObject:SetActive(false);
    self.bellGameIngIconCont.gameObject:SetActive(true)
    self.per.transform:Find("titlecont/titlelightcont").gameObject:SetActive(false)
    self.per.transform:Find("titlecont/lingdcont").gameObject:SetActive(true)
end

function Game22Panel.bellOver(arg)
    self.bellGameIngIconCont.gameObject:SetActive(false)
    self.per.transform:Find("titlecont/titlelightcont").gameObject:SetActive(true)
    self.per.transform:Find("titlecont/lingdcont").gameObject:SetActive(false)
    if FruitsSlot_Data.byFreeCnt > 0 then
        self.freetimesp.gameObject:SetActive(true)
        self.autostartbtn.gameObject:SetActive(false)
        self.stopautobtn.gameObject:SetActive(false)
        self.stopautobtnnum.gameObject:SetActive(false)
    else
        self.freetimesp.gameObject:SetActive(false)
        if FruitsSlot_Data.isAutoGame == true then
            self.stopautobtn.gameObject:SetActive(true)
            self.stopautobtnnum.gameObject:SetActive(true)
            self.autostartbtn.gameObject:SetActive(false)
        else
            self.stopautobtn.gameObject:SetActive(false)
            self.stopautobtnnum.gameObject:SetActive(false)
            self.autostartbtn.gameObject:SetActive(true)
        end
    end
end

function Game22Panel.Update()
    FruitsSlot_Bell_Game.Update();
    if FruitsSlot_Socket.isongame == false then
        return
    end
    table.foreach(
            FruitsSlot_Data.numrollingcont,
            function(i, k)
                k:update()
            end
    )
    if self.isCountAutoTimer == true then
        if self.countAutoTimer > 1 then
            self.isCountAutoTimer = false
            self.countAutoTimer = 0
            --        self.stopautobtn.gameObject:SetActive(true);
            --        FruitsSlot_Data.isAutoGame = true;
            --        FruitsSlot_Socket.gameOneOver(true);
            --        self.setStartAndStopBtn();
            self.selectnumcont.gameObject:SetActive(true)
        else
            self.countAutoTimer = self.countAutoTimer + Time.deltaTime
        end
    end
end

function Game22Panel.FixedUpdate()
    if FruitsSlot_Socket.isongame == false then
        return
    end
    table.foreach(
            self.runtabel,
            function(i, k)
                k:Update()
            end
    )
end

function Game22Panel.clickHander(args)
    --error("_____111_____");
    self.cont.transform.localPosition = Vector3.New(-113, 0, 0)
    local pkdotween = self.cont.transform:DOLocalMove(Vector3.New(-113, -2264, 0), 1, false)
    pkdotween:SetEase(DG.Tweening.Ease.InOutQuint)
    --pkdotween:SetEase(DG.Tweening.Ease.Linear);
end

function Game22Panel.LoadAssetNumCallBack(args)
    FruitsSlot_Data.numres = args
    self.loadSound(self.parentobj.transform:Find("fruitsslot_sound"))
    --ResManager:LoadAsset("game_fruitsslot_sound", 'fruitsslot_sound', self.loadSound);
end

function Game22Panel.loadSound(args)
    FruitsSlot_Data.sound_res = args
    self.LoadAssetSceneCallBack(self.parentobj.transform:Find("fruitsslot_icon"))
    --ResManager:LoadAsset("game_fruitsslot_icon", 'fruitsslot_icon', self.LoadAssetSceneCallBack);
end

function Game22Panel.LoadAssetSceneCallBack(args)
    FruitsSlot_Data.icon_res = args
    self.runtabel = {}
    if not IsNil(self.show1) then
        self.show1.gameObject:SetActive(false)
    end
    local sonitem = self.per.transform:Find("item")
    --sonitem.gameObject:SetActive(false);
    local item = nil
    for i = 1, 5 do
        item = FruitsSlot_RunCont_Item:new()
        item:setPer(
                self.per.transform:Find("runcontmask/runcont/runcont_" .. i),
                self.per.transform:Find("runcontmask/runcont/showcont_" .. i),
                i
        )
        item:setSonItem(sonitem)
        --item:createSonItem(FruitsSlot_Config.runimglen_config[i]*3);
        item:createSonItem(5 * 3)
        table.insert(self.runtabel, i, item)
    end

    FruitsSlot_Line.setPer(self.per.transform:Find("line"), self.per.transform:Find("linecont"))
    self.addEvent()

    FruitsSlot_ts_anima.setPer(self.per.transform:Find("ts_anima"), self.per)

    FruitsSlot_Choum.setPer(
            self.per.transform:Find("bottomcont/choumcont"),
            self.per.transform:Find("bottomcont/mypushcont")
    )

    FruiltsSlot_Rule.setPer(self.frulecont)
    FruitsSlot_Win_Gold.setPer(self.fwingoldcont)
    FruitsSlot_Bell_Game.setPer(self.fbellgamecont)

    --  for a=1,2 do
    --      self.light_anima_l:AddSprite(FruitsSlot_Data.icon_res.transform:Find("light_anima_"..a):GetComponent('Image').sprite);
    --      self.light_anima_r:AddSprite(FruitsSlot_Data.icon_res.transform:Find("light_anima_"..a):GetComponent('Image').sprite);
    --  end
    FruitsSlot_Socket.addGameMessge()
    FruitsSlot_Socket.playerLogon()

    --  local tsanima = self.per.transform:Find("ts_anima");
    --  local pos = self.per.transform:Find("bgcont/bbg5").transform.position;
    --  local w = self.per.transform:Find("bgcont/bbg5").gameObject:GetComponent("RectTransform").sizeDelta.x/2;
    --  tsanima.gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(300,599);
    --  tsanima.transform.position = Vector3.New(pos.x,pos.y,pos.z);
    --  local lpos = tsanima.transform.localPosition;
    --  tsanima.transform.localPosition = Vector3.New(lpos.x-w,lpos.y,lpos.z);
    --    error("_____lpos______"..lpos.x);
    --   FruitsSlot_Line.ShowLine();
    --   local  lenlen = #FruitsSlot_Data.allshowitem;
    --   local itemitem = nil;
    --   for a=1,lenlen do
    --      itemitem = FruitsSlot_Data.allshowitem[a];
    --   end
end