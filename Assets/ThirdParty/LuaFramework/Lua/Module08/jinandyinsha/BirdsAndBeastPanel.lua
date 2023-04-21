require "Module08/jinandyinsha/BirdsAndBeast_PushMoney"
require "Module08/jinandyinsha/BirdsAndBeast_RunItme"
require "Module08/jinandyinsha/BirdsAndBeast_His"
require "Module08/jinandyinsha/BirdsAndBeastConfig"
require "Module08/jinandyinsha/BirdsAndBeastEvent"
require "Module08/jinandyinsha/BirdsAndBeast_GameData"
require "Module08/jinandyinsha/BirdsAndBeast_Socket"
require "Module08/jinandyinsha/BirdsAndBeast_PushBtn"
require "Module08/jinandyinsha/BirdsAndBeast_CMD"
require "Module08/jinandyinsha/BirdsAndBeast_CaiJin"
require "Module08/jinandyinsha/BirdsAndBeast_MyInfo"
require "Module08/jinandyinsha/BirdsAndBeast_numRolling"
require "Module08/jinandyinsha/BirdsAndBeast_SpecialAnima"
require "Module08/jinandyinsha/jinandyinsha_anima"
require "Module08/jinandyinsha/jinandyinsha_UserListSp"
require "Module08/jinandyinsha/jinandyinsha_PushFun"

BirdsAndBeastPanel = {}
local self = BirdsAndBeastPanel
self.per = nil
self.luabe = nil
self.extendbtn = nil
self.extendbtnbg1 = nil
self.extendbtnbg2 = nil
self.specialanimacont = nil
self.messkey = "0"
self.gameloading = nil
self.openratecont = nil
self.maskclick = nil --�ڵ���ע�ȵ����
self.runtimerconfig = nil
self.isstartrun = false --��¼�ǲ����ڳ����˶� Ҳ��ֹͣ
self.defalutimg = nil --�������ͨ������ʱ�� Ҫ�Ѷ���һֱ��ʾ����һ����ʼ
function BirdsAndBeastPanel.Start(obj, father)
    self.per = obj
    self.init()
    self.loadPerCom(father.transform:Find("bab_icon"), father)
    self.messkey = BirdsAndBeastEvent.guid()
end

function BirdsAndBeastPanel.tesPerCom(args, father)
    --  BirdsAndBeastConfig.anim_res[BirdsAndBeastConfig.bad_tsanim].res = args
    --  self.soundCom(father.transform:Find("bad_sound"))
    --  for i = 1, 10 do
    --      BirdsAndBeast_GameData.loadres(i, true)
    --  end
end

function BirdsAndBeastPanel.soundCom(args)
    BirdsAndBeast_GameData.soundres = args
    BirdsAndBeast_Socket.playaudio(BirdsAndBeastConfig.sound_bg, true, true)
end

function BirdsAndBeastPanel.init()
    self.isrun = false

    self.runendindex = 1
    self.runstartindex = 1
    self.runlightcont = 0
    self.lastindex = 0

    self.runjgtimer = 0.1
    self.currtimer = 0

    self.light_L_animan = nil
    self.light_R_animan = nil
    self.openAnima = nil
    self.isstartrun = false --��¼�ǲ����ڳ����˶� Ҳ��ֹͣ
    self.defalutimg = nil --�������ͨ������ʱ�� Ҫ�Ѷ���һֱ��ʾ����һ����ʼ
    self.expanding = false

    self.goldAnimaTabel = {}
end

function BirdsAndBeastPanel.loadPerCom(args, father)
    --LoadAsset('module08/game_birdsandbeast_tes', 'bad_tes',self.tesPerCom,false,true);
    self.tesPerCom(father.transform:Find("bad_tes"), father)
    BirdsAndBeast_GameData.initData()
    BirdsAndBeast_GameData.iconres = args
    --error("____loadPerCom_____"..args.name);
    self.per.transform:Find("mycarcam"):GetComponent("Camera").clearFlags = UnityEngine.CameraClearFlags.SolidColor
    self.initPushBtn()
    self.setRunConfig()
    self.setpushmoney()
    self.sethis()
    self.localInit()
    self.setSpecialAnima()
    self.AddEvent()
    BirdsAndBeast_CaiJin.setPer(self.per.transform:Find("caijincont"))
    BirdsAndBeast_MyInfo.setPer(
        self.per.transform:Find("pushmoneycont/myinfocont"),
        self.per.transform:Find("player/user")
    )
    GameManager.GameScenIntEnd(self.per.transform:Find("gamesetcont").transform) --���ؼ��ϰ�ť
    --BirdsAndBeast_GameData.loadres(BirdsAndBeastConfig.bab_xiongm,true);
    jinandyinsha_UserListSp.setper(self.per.transform:Find("player"))

    local item = self.per.transform:Find("pushmoneycont/mypushcont/goldcont/golditem")
    local itemparent = self.per.transform:Find("pushmoneycont/mypushcont/goldcont")
    local pos = item.transform.localPosition
    local titem = nil
    for i = 1, 60 do
        titem = jinandyinsha_anima:new()
        titem:setPer(item, itemparent, Vector3.New(pos.x, pos.y + math.random(-260, 360), pos.z))
        table.insert(self.goldAnimaTabel, #self.goldAnimaTabel + 1, titem)
    end

    BirdsAndBeast_Socket.addGameMessge()
    BirdsAndBeast_Socket.playerLogon()
end

--��Ҫ�ǵ�ǰҳ��һ�³�ʼ��
function BirdsAndBeastPanel.localInit()
    self.setLightSp("light_l_anima", self.light_L_animan)
    self.setLightSp("light_r_anima", self.light_R_animan)
    self.light_L_animan = self.per.transform:Find("light_l_anima").transform:GetComponent("ImageAnima")
    self.light_R_animan = self.per.transform:Find("light_r_anima").transform:GetComponent("ImageAnima")

    local go = self.per.transform:Find("openanima")
    go.gameObject:AddComponent(typeof(ImageAnima))
    self.openAnima = go.transform:GetComponent("ImageAnima")

    self.extendbtnbg1 = self.per.transform:Find("pushmoneycont/myinfocont/extendbtn/extendbtn1")
    self.extendbtnbg2 = self.per.transform:Find("pushmoneycont/myinfocont/extendbtn/extendbtn2")
    self.extendbtnbg1.gameObject:SetActive(true)
    self.extendbtnbg2.gameObject:SetActive(false)

    self.gameloading = self.per.transform:Find("gameloading")
    self.openratecont = self.per.transform:Find("openratecont")
    self.openratecont.gameObject:SetActive(false)

    self.maskclick = self.per.transform:Find("pushmoneycont/maskclick")
    self.maskclick.gameObject:SetActive(false)
    self.per.transform:Find("pushmoneycont/pushmoneybtncont/changchoum/choum_btn").gameObject:GetComponent("Button").interactable =
        true
end

function BirdsAndBeastPanel.setLightSp(spname, anima)
    local go = self.per.transform:Find(spname)
    go.gameObject:AddComponent(typeof(ImageAnima))
    anima = go.transform:GetComponent("ImageAnima")
    for i = 1, 10 do
        anima:AddSprite(
            BirdsAndBeast_GameData.iconres.transform:Find("aimat_light_" .. 1).gameObject:GetComponent("Image").sprite
        )
        anima:AddSprite(
            BirdsAndBeast_GameData.iconres.transform:Find("aimat_light_" .. 2).gameObject:GetComponent("Image").sprite
        )
    end
    anima.fSep = 0.2
    anima:Stop()
end

function BirdsAndBeastPanel.setSpecialAnima()
    self.specialanimacont = self.per.transform:Find("specialanimacont")
    local len = math.min(self.specialanimacont.transform.childCount, #BirdsAndBeastConfig.special_anima_config)
    local item = nil
    for i = 1, len do
        item = BirdsAndBeast_SpecialAnima:new()
        item:setPer(self.specialanimacont.transform:GetChild(i - 1), i)
    end
    self.specialanimacont.gameObject:SetActive(false)
end

--��ʼ�� ���� ȡ�� ��ѹ
function BirdsAndBeastPanel.initPushBtn()
    BirdsAndBeast_PushBtn.setPer(self.per.transform:Find("pushmoneycont/pushmoneybtncont"), self.luabe)
end
--ȡ�����������ܶ���������г�ʼ
function BirdsAndBeastPanel.setRunConfig()
    local runcont = self.per.transform:Find("runcont")
    local len = math.min(runcont.transform.childCount, #BirdsAndBeastConfig.runitem_config)
    local item = nil
    for i = 1, len do
        local sprite =
            BirdsAndBeast_GameData.iconres.transform:Find(self.GetIconName(BirdsAndBeastConfig.runitem_config[i].rtype)).gameObject:GetComponent(
            "Image"
        ).sprite
        runcont.transform:GetChild(i - 1).transform:Find("icon").gameObject:GetComponent("Image").sprite = sprite
        item = BirdsAndBeast_RunItme:new()
        item:setData(BirdsAndBeastConfig.runitem_config[i])
        item:setPer(runcont.transform:GetChild(i - 1))
        table.insert(BirdsAndBeast_GameData.runitemcont, i, item)
    end
end

function BirdsAndBeastPanel.GetIconName(args)
    if (args == BirdsAndBeastConfig.bab_tuz) then
        return "run_8"
    end
    if (args == BirdsAndBeastConfig.bab_xiongm) then
        return "run_6"
    end
    if (args == BirdsAndBeastConfig.bab_yanz) then
        return "run_1"
    end
    if (args == BirdsAndBeastConfig.bab_yins) then
        return "run_9"
    end
    if (args == BirdsAndBeastConfig.bab_jinsha) then
        return "run_10"
    end
    if (args == BirdsAndBeastConfig.bab_kongq) then
        return "run_3"
    end
    if (args == BirdsAndBeastConfig.bab_shiz) then
        return "run_5"
    end
    if (args == BirdsAndBeastConfig.bab_zous) then
        return "run_11"
    end
    if (args == BirdsAndBeastConfig.bab_feiq) then
        return "run_12"
    end
    if (args == BirdsAndBeastConfig.bab_laoy) then
        return "run_4"
    end
    if (args == BirdsAndBeastConfig.bab_houz) then
        return "run_7"
    end
    if (args == BirdsAndBeastConfig.bab_gez) then
        return "run_2"
    end
end
--ȡ������������ע���г�ʼ
function BirdsAndBeastPanel.setpushmoney()
    local runcont = self.per.transform:Find("pushmoneycont/mypushcont/itemcont")
    local len = math.min(runcont.transform.childCount, #BirdsAndBeastConfig.push_config)
    for i = 1, len do
        local item = BirdsAndBeast_PushMoney:new()
        item:setLuabe(self.luabe)
        item:setData(BirdsAndBeastConfig.push_config[i])
        item:setPer(runcont.transform:GetChild(i - 1))
        BirdsAndBeast_GameData.pushitemcont[BirdsAndBeastConfig.push_config[i].rtype] = item
    end
end

function BirdsAndBeastPanel.allPushChang(args)
    if args.data == nil then
        return
    end
    coroutine.start(
        function()
            for i = 1, 2 do
                coroutine.wait(0.2)
                self.creatGoldAnima1(args, i)
            end
        end
    )
end

function BirdsAndBeastPanel.creatGoldAnima1(args, cindex)
    local item = BirdsAndBeast_GameData.pushitemcont[args.data]
    local goldanima = self.getGoldAnima()
    if item == nil then
        return
    end
    if goldanima == nil then
        return
    end
    local pos = item:getLocalPos()
    goldanima:setAnima1(Vector3.New(pos.x, pos.y, pos.z))
    if cindex == 1 then
        BirdsAndBeast_Socket.playaudio("flygold", false, false, false)
    end
    goldanima:playAnima1()
end

function BirdsAndBeastPanel.getGoldAnima()
    local len = #self.goldAnimaTabel
    for i = 1, len do
        if self.goldAnimaTabel[i]:getRun() == false then
            return self.goldAnimaTabel[i]
        end
    end
    return nil
end

function BirdsAndBeastPanel.openmyPushCom(args)
    self.per.transform:Find("openanima").gameObject:GetComponent("Image").sprite =
        BirdsAndBeast_GameData.iconres.transform:Find("mian_toum").gameObject:GetComponent("Image").sprite
    self.openratecont.gameObject:SetActive(false)
    --   coroutine.start(function()
    --       coroutine.wait(2);
    --        local len = #self.goldAnimaTabel;
    --        for i=1,len do
    --          self.goldAnimaTabel[i]:playAnima2();
    --        end
    --   end);
    local numtable = args.data
    local isplaysound = false
    for a = 1, 7 do
        if numtable[a] > 0 then
            isplaysound = true
        end
    end
    if isplaysound == true then
        BirdsAndBeast_Socket.playaudio("feijinbi", false, false, false)
    end
    for i = 1, 7 do
        if numtable[i] == 0 then
            return
        end
        self.showJinBi(numtable[i], i)
    end
end

function BirdsAndBeastPanel.showJinBi(args, gindex)
    coroutine.start(
        function()
            for a = 1, args do
                coroutine.wait(0.01)
                if BirdsAndBeast_Socket.isongame == false then
                    return
                end
                goldanima = self.getGoldAnima()
                if goldanima == nil then
                    return
                end
                goldanima:setAnima3(Vector3.New(680, 70 - (gindex - 1) * 90 + a * 4, 0))
            end
        end
    )
end

function BirdsAndBeastPanel.winGoldAnima(args)
    if args.data == nil then
        return
    end
    BirdsAndBeast_GameData.curGetWinGoldNum = 0
    local tarpos = {}
    for a = 1, 20 do
        table.insert(tarpos, #tarpos + 1, self.getWindGoldIndex())
    end
    self.creatGoldAnima(args.data, tarpos)
end

function BirdsAndBeastPanel.getWindGoldIndex()
    BirdsAndBeast_GameData.curGetWinGoldNum = BirdsAndBeast_GameData.curGetWinGoldNum + 1
    if BirdsAndBeast_GameData.curGetWinGoldNum <= 3 then
        return 0 * 90
    elseif BirdsAndBeast_GameData.curGetWinGoldNum <= 6 then
        return 1 * 90
    elseif BirdsAndBeast_GameData.curGetWinGoldNum <= 9 then
        return 2 * 90
    elseif BirdsAndBeast_GameData.curGetWinGoldNum <= 12 then
        return 3 * 90
    elseif BirdsAndBeast_GameData.curGetWinGoldNum <= 15 then
        return 4 * 90
    elseif BirdsAndBeast_GameData.curGetWinGoldNum <= 18 then
        return 5 * 90
    else
        return 6 * 90
    end
    return 6 * 90
end

function BirdsAndBeastPanel.creatGoldAnima(openvale, tarpos)
    local item = BirdsAndBeast_GameData.pushitemcont[openvale]
    if item == nil then
        return
    end
    local goldanima = nil
    local pos = item:getLocalPos()
    coroutine.start(
        function()
            for i = 1, 20 do
                coroutine.wait(0.01)
                goldanima = self.getGoldAnima()
                if goldanima == nil then
                    return
                end
                goldanima:setAnima2(Vector3.New(pos.x, pos.y + i * 5, pos.z), Vector3.New(480, 80 - tarpos[i], 0))
            end
        end
    )
end

--ȡ�����������·�����г�ʼ
function BirdsAndBeastPanel.sethis()
    local cont = self.per.transform:Find("pushmoneycont/luadancont")
    local len = cont.transform.childCount
    local item = nil
    for i = 1, len do
        item = BirdsAndBeast_His:new()
        item:setData(i)
        item:setPer(cont.transform:GetChild(i - 1))
        table.insert(BirdsAndBeast_GameData.hisitemcont, i, item)
    end
end
self.pushmoneycontpanel = nil
self.expandpos = nil
self.noexpandpos = nil
self.expanding = false
function BirdsAndBeastPanel.AddEvent()
    self.extendbtn = self.per.transform:Find("pushmoneycont/myinfocont/extendbtn")
    self.pushmoneycontpanel = self.per.transform:Find("pushmoneycont")
    local pos = self.pushmoneycontpanel.transform.localPosition
    self.expandpos = Vector3.New(pos.x, pos.y, pos.z)
    self.noexpandpos = Vector3.New(pos.x, -440, pos.z)
    self.luabe:AddClick(self.extendbtn.transform.gameObject, self.extendbtnHander)
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.startrun, self.startrun, self.messkey)
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.startchip, self.startChip, self.messkey)
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.stopchip, self.stopChip, self.messkey)
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.openmypushpanel, self.openmypushpanel, self.messkey)
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.showgameloading, self.showgameloading, self.messkey)
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.exitgame, self.exitgame, self.messkey)
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.unload_game_res, self.unloadGameRes, self.messkey)
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.stopspecialanima, self.stopspecialanima, self.messkey)
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.openPushchang, self.openPushchang, self.messkey)
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.allpushchang, self.allPushChang, self.messkey)
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.openmypushcom, self.openmyPushCom, self.messkey)
    --BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.creatgoldanima,self.winGoldAnima,self.messkey);
end

function BirdsAndBeastPanel.unloadGameRes(args)
    --    coroutine.start(function(args)
    --       coroutine.wait(0.5);
    --       Unload('module08/game_birdsandbeast_icon');
    --       Unload('module08/game_birdsandbeast_tes');
    --       Unload('module08/game_birdsandbeast_sound');
    --       Unload('module08/game_birdsandbeast');
    --    end);
end

function BirdsAndBeastPanel.exitgame(args)
    self.destroying()
end
function BirdsAndBeastPanel.destroying()
    self.per = nil
    self.luabe = nil
    self.extendbtn = nil
    self.extendbtnbg1 = nil
    self.extendbtnbg2 = nil
    self.specialanimacont = nil
    self.messkey = "0"
    self.gameloading = nil
    self.runtimerconfig = nil
    self.init()
end

function BirdsAndBeastPanel.showgameloading(args)
    self.gameloading.gameObject:SetActive(args.data)
end

--function BirdsAndBeastPanel.openPushchang(args)
--      self.onceStopRun();
--end

--������ʱ���������ߵĵ�
function BirdsAndBeastPanel.openPushchang(args)
    if args.data == nil then
        return
    end
    local isyaz = false
    isyaz = BirdsAndBeast_GameData.isHandWin(args.data)
    if isyaz == true then
        self.light_L_animan:Play()
        self.light_R_animan:Play()
    --return;
    end
end

function BirdsAndBeastPanel.Update()
    if BirdsAndBeast_Socket.isongame == false then
        return
    end
    table.foreach(
        BirdsAndBeast_GameData.numrollingcont,
        function(i, k)
            k:update()
        end
    )
    table.foreach(
        self.goldAnimaTabel,
        function(i, k)
            k:update()
        end
    )
    BirdsAndBeast_CaiJin.upDate()
    self.runing()
    BirdsAndBeast_GameData.runtimer = BirdsAndBeast_GameData.runtimer + Time.deltaTime
end
--��ʼ��ע������Ҳ�㵯����ע���
function BirdsAndBeastPanel.startChip(args)
    --error("_________BirdsAndBeastPanel.startChip____________");
    self.maskclick.gameObject:SetActive(false)
    self.per.transform:Find("pushmoneycont/pushmoneybtncont/changchoum/choum_btn").gameObject:GetComponent("Button").interactable =
        true
    --self.openratecont.gameObject:SetActive(false);
    --self.openAnima:StopAndRevert();
    self.doitExtend(true)

    local len = #self.goldAnimaTabel
    for i = 1, len do
        self.goldAnimaTabel[i]:playAnima3()
    end
end

function BirdsAndBeastPanel.stopChip(args)
    self.clearRunSelect(true)
    coroutine.start(
        function()
            coroutine.wait(1)
            if BirdsAndBeast_Socket.isongame == false then
                return
            end
            BirdsAndBeast_Socket.playaudio("daming", false, false, false)
        end
    )
end

function BirdsAndBeastPanel.openmypushpanel(args)
    self.doitExtend(args.data)
end

function BirdsAndBeastPanel.playRun(args)
    self.countRun(args.data)
    self.doitExtend(false)
    BirdsAndBeast_GameData.loadres(BirdsAndBeastConfig.runitem_config[BirdsAndBeast_GameData.openindex].rtype)
end

function BirdsAndBeastPanel.startrun(args)
    self.maskclick.gameObject:SetActive(true)
    self.per.transform:Find("pushmoneycont/pushmoneybtncont/changchoum/choum_btn").gameObject:GetComponent("Button").interactable =
        false
    self.isstartrun = true
    self.playRun(args)
end

function BirdsAndBeastPanel.RemoveEvent()
end

function BirdsAndBeastPanel.extendbtnHander(args)
    local state = BirdsAndBeast_GameData.gameState
    if
        state == BirdsAndBeast_CMD.D_GAME_STATE_NULL or state == BirdsAndBeast_CMD.D_GAME_STATE_CHIP or
            state == BirdsAndBeast_CMD.D_GAME_STATE_STOP_CHIP or
            state == BirdsAndBeast_CMD.D_GAME_STATE_RUN
     then
        self.doitExtend(nil)
    end
end

function BirdsAndBeastPanel.doitExtend(args)
    if self.expanding == true then
        return
    end
    self.expanding = true
    local pos = self.pushmoneycontpanel.transform.localPosition
    if args == nil then
        if pos.y > -200 then
            pos = self.noexpandpos
            self.extendbtnbg1.gameObject:SetActive(false)
            self.extendbtnbg2.gameObject:SetActive(true)
        else
            pos = self.expandpos
            self.extendbtnbg1.gameObject:SetActive(true)
            self.extendbtnbg2.gameObject:SetActive(false)
        end
    elseif args == true then -- չ��
        pos = self.expandpos
        self.extendbtnbg1.gameObject:SetActive(true)
        self.extendbtnbg2.gameObject:SetActive(false)
    elseif args == false then -- ��£
        pos = self.noexpandpos
        self.extendbtnbg1.gameObject:SetActive(false)
        self.extendbtnbg2.gameObject:SetActive(true)
    end
    local tweener = self.pushmoneycontpanel:DOLocalMove(pos, 0.5, false)
    tweener:OnComplete(
        function()
            self.expanding = false
        end
    )
end

function BirdsAndBeastPanel.playAnima(isstartanima)
    log("播放")

    local res = nil
    local openType = BirdsAndBeastConfig.runitem_config[BirdsAndBeast_GameData.openindex].rtype
    if isstartanima == true then
        error("____111__playAnima________")
        self.openAnima:StopAndRevert()
        self.openAnima:SetEndEvent(self.stopAnimat)
        BirdsAndBeast_Socket.playaudio(BirdsAndBeastConfig["sound_tes"], false)
    else
        self.openPushchang({data = openType})
        res = BirdsAndBeast_GameData.loadres(openType)
        self.openAnima:SetEndEvent(
            function(args)
                log("动画结束")
                self.openAnima.gameObject:SetActive(false)
                self.openratecont.gameObject:SetActive(false)
                if self.defalutimg ~= nil then
                    self.per.transform:Find("openanima").gameObject:GetComponent("Image").sprite = self.defalutimg
                end
                self.isstartrun = false
                if openType == BirdsAndBeastConfig.bab_jinsha or openType == BirdsAndBeastConfig.bab_yins then
                    self.specialanimacont.gameObject:SetActive(true)
                    self.openratecont.gameObject:SetActive(false)
                    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.startspecialanima, nil)
                end
            end
        )
        self.openratecont.gameObject:SetActive(true)
        self.setRate()
        if (openType == 0) then
            BirdsAndBeast_Socket.playaudio("yaz", false)
        else
            BirdsAndBeast_Socket.playaudio(BirdsAndBeastConfig["sound_" .. openType], false)
        end
    end

    if not IsNil(res) then
        logYellow("设置播放动画" .. res.name)
        self.openAnima:ClearAll()
        local ressize = res.transform:GetChild(0).transform:GetComponent("RectTransform").sizeDelta
        self.per.transform:Find("openanima").transform:GetComponent("RectTransform").sizeDelta =
            Vector2.New(ressize.x, ressize.y)
        local cont = res.transform.childCount
        for i = 1, cont do
            self.openAnima:AddSprite(res.transform:GetChild(i - 1).gameObject:GetComponent("Image").sprite)
        end
        if openType ~= BirdsAndBeastConfig.bab_yins and frtype ~= BirdsAndBeastConfig.bab_jinsha then
            self.defalutimg = res.transform:GetChild(cont - 1).gameObject:GetComponent("Image").sprite
        else
            self.defalutimg = nil
        end
        self.openAnima.fSep = 0.12
        self.openAnima:Play()
        self.openAnima.gameObject:SetActive(true)
    --self.openAnima.playerAlways = true;
    end
end

function BirdsAndBeastPanel.stopAnimat(args)
    self.openAnima:StopAndRevert()
    self.playRun({data = true})
end

--����ֹͣ�˶��������Ƿ�ֹ���翨��ʱ�� �������� ����������
function BirdsAndBeastPanel.onceStopRun(args)
    if self.isstartrun == false then
        return
    end
    if IsNil(self.per) then
        return
    end
    self.openAnima:StopAndRevert()
    self.openratecont.gameObject:SetActive(false)
    self.specialanimacont.gameObject:SetActive(false)
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.oncestopspecialanima)
    if BirdsAndBeast_GameData.savesound ~= nil then
        destroyObj(BirdsAndBeast_GameData.savesound)
    end
    self.isrun = false
    self.clearRunSelect(true)
    --self.clearRunSelect(true);
    self.isstartrun = false
    BirdsAndBeast_GameData.runitemcont[BirdsAndBeast_GameData.openindex]:setIsSelect(false)
    BirdsAndBeast_GameData.runitemcont[BirdsAndBeast_GameData.openindex]:setRunImgVisible(true)
end

--ֹͣ�������⶯��
function BirdsAndBeastPanel.stopspecialanima(args)
    --self.openAnima:StopAndRevert();
    --self.playRun({data=true});
end

function BirdsAndBeastPanel.runing()
    if self.isrun then
        self.currtimer = self.currtimer + Time.deltaTime
        if self.currtimer < self.runjgtimer then
            return
        end
        -- error("_______self.runjgtimer________"..self.runjgtimer);
        self.currtimer = 0
        self.runendindex = self.runendindex - 1
        if self.runendindex == 0 then
            self.isrun = false
            self.playAnima()
        end
        local runitemlen = #BirdsAndBeast_GameData.runitemcont
        self.runstartindex = self.runstartindex + 1
        if self.runstartindex > runitemlen then
            self.runstartindex = self.runstartindex - runitemlen
        end
        --error("22_____________"..self.runstartindex);
        local destart = 5
        BirdsAndBeast_GameData.runitemcont[self.runstartindex]:setRunImgVisible(true)
        if self.isrun == false then
            BirdsAndBeast_GameData.runitemcont[self.runstartindex]:setIsSelect(true)
        end
        if self.runendindex < 8 then
            destart = math.max(1, self.runendindex - 2)
        end
        if self.runendindex == 0 then
            BirdsAndBeast_Socket.playaudio(BirdsAndBeastConfig["sound_endrun"], false)
        end
        if self.runendindex > 0 and self.runendindex < 9 then
            BirdsAndBeast_Socket.playaudio(BirdsAndBeastConfig["sound_runing"], false)
        end
        if self.runendindex == runitemlen * 4 then
            self.specialanimacont.gameObject:SetActive(false)
        end
        if self.runlightcont < 5 and self.runendindex > 10 then
            self.runlightcont = self.runlightcont + 1
        else
            if self.runtimerconfig ~= nil and self.runendindex < 14 and self.runendindex > 0 then
                self.runjgtimer = self.runtimerconfig --self.runtimerconfig[self.runendindex]
            elseif self.runendindex < runitemlen * 1 then
                self.runjgtimer = 0.03
            elseif self.runendindex < runitemlen * 2 then
                self.runjgtimer = 0.02
            elseif self.runendindex < runitemlen * 5 then
                self.runjgtimer = 0.03
            else
                self.runjgtimer = 0.05
            end
            if self.runendindex == 10 then
            --BirdsAndBeast_CaiJin.stopCont()
            end
            if self.runendindex == 0 then
                BirdsAndBeast_GameData.runitemcont[BirdsAndBeast_GameData.openindex]:setPlayAnima()
            end
            for i = destart, 5 do
                local variable = self.runstartindex - i
                if variable <= 0 then
                    variable = runitemlen + variable
                end
                BirdsAndBeast_GameData.runitemcont[variable]:setRunImgVisible(false)
            end
        end
    end
end

function BirdsAndBeastPanel.clearRunSelect(isclear)
    if isclear == true then
        table.foreach(
            BirdsAndBeast_GameData.runitemcont,
            function(i, k)
                k:setIsSelect(false)
                k:setRunImgVisible(false)
            end
        )
    end
end

function BirdsAndBeastPanel.countRun(isclear)
    --self.clearRunSelect(isclear);--��ʼ��ע��ʱ��ͳһ����
    if self.lastindex ~= 0 then
        self.runstartindex = 0
    end
    local runage = BirdsAndBeast_GameData.openindex - self.lastindex
    local runlen = #BirdsAndBeast_GameData.runitemcont
    if runage < 0 then
        runage = runlen + runage
    end
    if isclear == true then
        self.runendindex = runlen * 5 + runage
    else
        self.runendindex = runage
    end
    if isclear == true then
        BirdsAndBeast_Socket.playaudio(BirdsAndBeastConfig["sound_startrun"], false, false, true)
    end
    self.runstartindex = self.lastindex
    self.lastindex = BirdsAndBeast_GameData.openindex
    self.runlightcont = 0
    self.runjgtimer = 0.1
    self.currtimer = 0
    local rand = math.random(1, #BirdsAndBeastConfig.run_timer_config)
    self.runtimerconfig = 0.15 --BirdsAndBeastConfig.run_timer_config[rand]
    self.isrun = true
    logYellow("开始转")
end

--���ñ���
function BirdsAndBeastPanel.setRate()
    local badtype = BirdsAndBeastConfig.runitem_config[BirdsAndBeast_GameData.openindex].rtype
    jinandyinsha_PushFun.CreatShowNum(
        self.openratecont.transform:Find("numcont"),
        BirdsAndBeast_GameData.multiple_data[badtype].rate,
        "rate_",
        false,
        42,
        1,
        55,
        27
    )
end

function BirdsAndBeastPanel.ShowMessageBox(strTitle, iBtnCount, bQuit)
    local tab = GeneralTipsSystem_ShowInfo
    tab._01_Title = ""
    tab._02_Content = strTitle
    tab._03_ButtonNum = iBtnCount
    if (bQuit) then
        tab._04_YesCallFunction = self.gameQuit
    else
        tab._04_YesCallFunction = nil
    end
    tab._05_NoCallFunction = nil
    MessageBox.CreatGeneralTipsPanel(tab)
end
