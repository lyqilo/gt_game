flm_BtnPanel = {}
local self = flm_BtnPanel

function flm_BtnPanel.init()
   self.per = nil
   self.autobtn = nil
   self.stopautobtnnum = nil
   self.selectnumcont = nil
   self.countAutoTimer = 0
   self.isCountAutoTimer = false
   self.autoandstartcont = nil
   self.myGoldNum = nil
   self.chouNum = nil
   self.allPushNum = nil

   self.liehuoSp = nil
   self.freesp = nil
   self.freeNumCont = nil

   self.goldModesp = nil
   self.goldModeNumCont = nil

   self.noStartBtn = nil --手动按钮
   self.stopBtn = nil --停止按钮
   self.guikey = "cn"

   self.curChoumIndex = 1
   self.perBtn = nil
   self.nextBtn = nil

   self.winGoldSp = nil
   self.WinGoldNum = nil

   self.tswintsSp = nil
   self.tswintsNum = nil
   self.tswintsNumStr = "freeall_gold_"
   self.tswintswinGoldroll = nil

   self.showWinGold = 0
   self.selfGameIndex = 0

   self.winGoldroll = nil

   self.freeTips = nil
   self.freeTips = nil

   self.autoClick = false --开始按钮是不是点击

   self.showWinData = nil

   self.title = nil
   --self.maxwintitle = nil;
   self.getgoldanima = nil

   self.mianfzhuan = nil
   --self.lihuoicon = nil;
   self.daFuNumCont = nil
   self.xiaoFuNumCont = nil
   self.allFuNumCont = nil
   self.yanhAnima1 = nil
   self.yanhAnima2 = nil
end

function flm_BtnPanel.setPer(args)
   self.init()
   self.per = args
   self.guikey = flm_Event.guid()
   self.autobtn = self.per.transform:Find("startbtn")
   self.myGoldNum = self.per.transform:Find("mygoldcont/mygoldnumcont")
   self.chouNum = self.per.transform:Find("choumcont/choumnumcont")
   self.choumtxt = self.per.transform:Find("choumcont/choumtxt")
   self.choumtxt.gameObject:GetComponent("Text").horizontalOverflow = UnityEngine.HorizontalWrapMode.Overflow

   self.daFuNumCont = self.per.transform:Find("fucont/dafucont/numcont")
   self.xiaoFuNumCont = self.per.transform:Find("fucont/xiaofucont/numcont")
   self.allFuNumCont = self.per.transform:Find("fucont/fumancont/numcont")

   self.perBtn = self.per.transform:Find("choumcont/perbtn")
   self.nextBtn = self.per.transform:Find("choumcont/nextbtn")
   self.freeTips = self.per.transform:Find("tsmodets/freetips")
   self.allgoldtips = self.per.transform:Find("tsmodets/allgoldtips")

   self.winGoldSp = self.per.transform:Find("wingoldcont")
   self.WinGoldNum = self.per.transform:Find("wingoldcont/numcont")

   self.tswintsSp = self.per.transform:Find("tswints")
   self.tswintsSp:Find("item_1/zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
   self.tswintsSp:Find("item_2/zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
   self.tswintsSp:Find("item_3/zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
   self.tswintsSp:Find("item_4/zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
   self.tswintsSp:Find("item_5/zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);


   self.tswintsNum = nil

   self.yanhAnima1 = self.tswintsSp.transform:Find("item_5/anima_1").gameObject:AddComponent(typeof(ImageAnima))
   self.yanhAnima2 = self.tswintsSp.transform:Find("item_5/anima_2").gameObject:AddComponent(typeof(ImageAnima))
   self.yanhAnima1.fSep = 0.07
   self.yanhAnima2.fSep = 0.07
   for c = 1, 19 do
      self.yanhAnima1:AddSprite(flm_Data.icon_res.transform:Find("yanh_anima_" .. c):GetComponent("Image").sprite)
      self.yanhAnima2:AddSprite(flm_Data.icon_res.transform:Find("yanh_anima_" .. c):GetComponent("Image").sprite)
   end
   self.yanhAnima1:PlayAlways()
   self.yanhAnima2:PlayAlways()

   self.freesp = self.per.transform:Find("freeicon")
   self.freeNumCont = self.per.transform:Find("freeicon/numcont")

   self.goldModesp = self.per.transform:Find("goldicon")
   self.goldModeNumCont = self.per.transform:Find("goldicon/numcont")

   self.noStartBtn = self.per.transform:Find("closestartbtncont/nostartbtn") --手动按钮
   self.stopautobtnnum = self.per.transform:Find("closestartbtncont/numtxt").gameObject
   self.selectnumcont = self.per.transform:Find("selectnumcont").gameObject
   self.stopBtn = self.per.transform:Find("stopbtn") --停止按钮

   --self.title = self.per.transform:Find("title");
   --self.maxwintitle = self.per.transform:Find("maxwintitle");

   self.mianfzhuan = self.per.transform:Find("mianfzhuan")
   --self.lihuoicon = self.per.transform:Find("lihuoicon");

   self.noStartBtn.gameObject:SetActive(false)
   self.stopBtn.gameObject:SetActive(false)
   self.freeTips.gameObject:SetActive(false)
   self.freesp.gameObject:SetActive(false)
   self.goldModesp.gameObject:SetActive(false)
   self.allgoldtips.gameObject:SetActive(false)
   self.tswintsSp.gameObject:SetActive(false)

   self.mianfzhuan.gameObject:SetActive(false)

   self.selectnumcont.gameObject:SetActive(false)
   self.stopautobtnnum.gameObject:SetActive(false)

   self.winGoldroll = flm_NumRolling:New()
   self.winGoldroll:setfun(self, self.winGoldRollCom, self.winGoldRollIng)
   table.insert(flm_Data.numrollingcont, #flm_Data.numrollingcont + 1, self.winGoldroll)

   self.tswintswinGoldroll = flm_NumRolling:New()
   self.tswintswinGoldroll:setfun(self, self.tswintswinGoldrollCom, self.tswintswinGoldrollIng)
   table.insert(flm_Data.numrollingcont, #flm_Data.numrollingcont + 1, self.tswintswinGoldroll)

   self.addEvent()
   local eventTrigger = Util.AddComponent("EventTriggerListener", self.autobtn.gameObject)
   eventTrigger.onDown = self.autoStartDown
   eventTrigger.onUp = self.autoStartUp

   flm_PushFun.CreatShowNum(self.WinGoldNum, 0, "win_gold_", false, 58, 2, 310, -142)

   self.getgoldanima = self.per.transform:Find("mygoldcont/getgoldanima").gameObject:AddComponent(typeof(ImageAnima))
end

function flm_BtnPanel.loadResCom(args)
   if self.getgoldanima == nil then
      return
   end
   for i = 1, 5 do
      self.getgoldanima:AddSprite(flm_Data.icon_res.transform:Find("mygold_chang_" .. 1):GetComponent("Image").sprite)
      self.getgoldanima:AddSprite(flm_Data.icon_res.transform:Find("mygold_chang_" .. 2):GetComponent("Image").sprite)
   end
   self.getgoldanima.fSep = 0.1
end

function flm_BtnPanel.tswintswinGoldrollIng(obj, args)
   flm_PushFun.CreatShowNum(self.tswintsNum, args, "freeall_gold_", false, 57, 2, 820, -210)
end

function flm_BtnPanel.tswintswinGoldrollCom(obj, args)
   flm_PushFun.CreatShowNum(self.tswintsNum, args, "freeall_gold_", false, 57, 2, 820, -210)
   if flm_Data.fuType[2] > 0 then
      self.tswintsSp.gameObject:SetActive(false)
      flm_Event.dispathEvent(flm_Event.xiongm_close_allfu)
      flm_Data.fuType[2] = 0
   end
end

function flm_BtnPanel.winGoldRollIng(obj, args)
   flm_PushFun.CreatShowNum(self.WinGoldNum, args, "win_gold_", false, 58, 2, 310, -142)
end

function flm_BtnPanel.winGoldRollCom(obj, args)
   if not IsNil(flm_Data.saveSound) then
      destroy(flm_Data.saveSound)
   end
   --self.titleInit();
   self.tswintsSp.gameObject:SetActive(false)
   self.closeStopBtnHander()
   if self.showWinData.anima ~= nil then
      local m = self.showWinData.anima.main
      m.loop = false
   --self.showWinData.anima.loop = false;
   --self.showWinData.anima:Play();
   end
   if self.showWinData.iscom == true then
      flm_PushFun.CreatShowNum(self.WinGoldNum, flm_Data.lineWinScore, "win_gold_", false, 58, 2, 310, -142)
      self.winGoldSpVisibel()
   else
      flm_PushFun.CreatShowNum(self.WinGoldNum, args, "win_gold_", false, 58, 2, 310, -142)
   end
   if flm_Data.byAddFreeCnt > 0 then
      flm_LianLine.freeAnima()
      return
   end
   if flm_Data.bGoldMode == true then
      flm_LianLine.goldModeAnima()
      return
   end
   if self.showWinData.sendtype then
      return
   end

   --   if flm_Data.byFreeCnt>0 or flm_Data.freeAllGold>0 or flm_Data.isAutoGame==true then
   --      --error("___freeAllGold__");
   --      flm_Socket.gameOneOver2(false);
   --    else
   --      if flm_Data.bFireMode ==true and flm_Data.bFireCom == true then
   --         flm_Socket.gameOneOver2(false);
   --      end
   --      flm_Event.dispathEvent(flm_Event.xiongm_show_start_btn,nil);
   --      flm_Event.dispathEvent(flm_Event.xiongm_start_btn_no_inter,true);
   --   end
   flm_Socket.gameOneOver2(false)
   flm_Event.dispathEvent(flm_Event.xiongm_show_start_btn, nil)
   flm_Event.dispathEvent(flm_Event.xiongm_start_btn_no_inter, true)
end

--根据一些状态隐藏界面 1 开始 2 手动 3 停止 4 烈火 5免费 6 金币模式
function flm_BtnPanel.setVisibleBtn(args)
   self.autobtn.gameObject:SetActive(false)
   self.noStartBtn.gameObject:SetActive(false)
   if args == 1 then
      if flm_Data.isAutoGame == false then
         self.autobtn.gameObject:SetActive(true)
      else
         self.noStartBtn.gameObject:SetActive(true)
      end
   elseif args == 2 then
      self.myChoumBtnInter(false)
      self.noStartBtn.gameObject:SetActive(true)
   elseif args == 3 then
      --  self.stopBtn.gameObject:SetActive(true);
      self.showStopBtnHander()
   elseif args == 4 then
      self.myChoumBtnInter(false)
   elseif args == 5 then
      self.myChoumBtnInter(false)
      self.freesp.gameObject:SetActive(true)
   elseif args == 6 then
      self.myChoumBtnInter(false)
      self.goldModesp.gameObject:SetActive(true)
   end
end

function flm_BtnPanel.showStopBtnHander(args)
   --error("________showStopBtnHander_________");
   self.stopBtn.gameObject:SetActive(true)
   self.freesp.gameObject:SetActive(false)
   self.goldModesp.gameObject:SetActive(false)
end

function flm_BtnPanel.closeStopBtnHander(args)
   --error("________showStopBtnHander_________");
   self.stopBtn.gameObject:SetActive(false)
   if flm_Data.byFreeCnt > 0 then
      self.freesp.gameObject:SetActive(true)
   elseif flm_Data.bGoldingMode == true then
      self.goldModesp.gameObject:SetActive(true)
   end
end

function flm_BtnPanel.autoStartDown(args)
   self.isCountAutoTimer = true --是不是记录 自动按钮按下的时间
end

function flm_BtnPanel.autoStartUp(args)
   self.isCountAutoTimer = false --是不是记录 自动按钮按下的时间
   self.countAutoTimer = 0 --按钮按下的时间
end

function flm_BtnPanel.addEvent()
   log("==================================add event listener")
   flm_Data.luabe:AddClick(self.autobtn.gameObject, self.autoBtnHander)
   flm_Data.luabe:AddClick(self.noStartBtn.gameObject, self.noStartBtnHander)
   flm_Data.luabe:AddClick(self.stopBtn.gameObject, self.stopBtnHander)

   flm_Data.luabe:AddClick(self.perBtn.gameObject, self.perBtnHander)
   flm_Data.luabe:AddClick(self.nextBtn.gameObject, self.nextBtnHander)
   flm_Event.addEvent(flm_Event.xiongm_init, self.gameInit, self.guikey)
   flm_Event.addEvent(flm_Event.xiongm_show_start_btn, self.showStartBtn, self.guikey)
   flm_Event.addEvent(flm_Event.xiongm_start_btn_no_inter, self.startBtnInter, self.guikey)
   flm_Event.addEvent(flm_Event.xiongm_show_free_btn, self.showFreeBtn, self.guikey)
   flm_Event.addEvent(flm_Event.xiongm_show_gold_mode_btn, self.showGoldModeBtn, self.guikey)
   flm_Event.addEvent(flm_Event.xiongm_show_free_num_chang, self.freeNumChang, self.guikey)
   flm_Event.addEvent(flm_Event.xiongm_show_gold_mode_num_chang, self.goldModeNumChang, self.guikey)
   flm_Event.addEvent(flm_Event.xiongm_lihuo_bg_anima, self.showLiehuo, self.guikey)
   flm_Event.addEvent(flm_Event.xiongm_gold_chang, self.goldChang, self.guikey)
   flm_Event.addEvent(flm_Event.xiongm_show_no_start_btn, self.showNoStartBtnHander, self.guikey)
   flm_Event.addEvent(flm_Event.xiongm_show_stop_btn, self.showStopBtnHander, self.guikey)
   flm_Event.addEvent(flm_Event.xiongm_close_stop_btn, self.closeStopBtnHander, self.guikey)
   flm_Event.addEvent(flm_Event.xiongm_show_win_gold, self.showWinGoldHander, self.guikey)
   flm_Event.addEvent(flm_Event.xiongm_once_show_win_gold, self.onceShowWinGold, self.guikey)
   flm_Event.addEvent(flm_Event.xiongm_show_allfu, self.showAllFu, self.guikey)

   flm_Event.addEvent(flm_Event.xiongm_start, self.startHander, self.guikey)
   flm_Event.addEvent(flm_Event.game_once_over, self.onceOver, self.guikey)
   flm_Event.addEvent(flm_Event.xiongm_show_free_tips, self.showFreeTipHander, self.guikey)
   flm_Event.addEvent(flm_Event.xiongm_mianf_btn_mode, self.modeBtnState, self.guikey)
   flm_Event.addEvent(flm_Event.xiongm_title_mode, self.titleInit, self.guikey)

   flm_Event.addEvent(flm_Event.xiongm_load_res_com, self.loadResCom, self.guikey)
   flm_Event.addEvent(flm_Event.xiongm_update_allfu_value, self.updateAllFuValue, self.guikey)

   flm_Event.addEvent(flm_Event.xiongm_over, flm_Event.hander(self, self.gameOver), self.guikey)
   self.selectnumcont.transform:Find("closebtn/Text").gameObject:SetActive(false)
   flm_Data.luabe:AddClick(self.selectnumcont.transform:Find("closebtn").gameObject, self.closeSelectRunNun)
   for i = 1, 4 do
      flm_Data.luabe:AddClick(
         self.selectnumcont.transform:Find("item_" .. i .. "/btn").gameObject,
         self.selectRunNunHander
      )
   end
end

function flm_BtnPanel.closeSelectRunNun(args)
   self.selectnumcont.gameObject:SetActive(false)
end

function flm_BtnPanel.selectRunNunHander(args)
   local str = args.transform.parent.name
   local str1 = string.split(str, "_")
   self.closeSelectRunNun()
   --self.noStartBtn.gameObject:SetActive(true);
   self.setVisibleBtn(2)
   flm_Data.isAutoGame = true
   flm_Socket.gameOneOver(true)
   local datanum = {10, 50, 100, 10000000}
   flm_Data.autoRunNum = datanum[tonumber(str1[2])]
   self.stopautobtnnum.gameObject:SetActive(true)
end

function flm_BtnPanel.gameOver(args)
   if flm_Data.autoRunNum < 1 and flm_Data.isAutoGame == true then
      self.noStartBtnHander()
      self.stopautobtnnum.gameObject:SetActive(false)
   else
      local str = flm_Data.autoRunNum
      if flm_Data.autoRunNum > 1000 then
         flm_Data.autoRunNum = 10000000
         str = "无限"
      end
      self.stopautobtnnum.gameObject:GetComponent("Text").text = str
   end
end

function flm_BtnPanel.modeBtnState()
   if flm_Data.byFreeCnt > 0 or flm_Data.freeAllGold > 0 then
      self.mianfzhuan.gameObject:SetActive(true)
   else
      self.mianfzhuan.gameObject:SetActive(false)
   end
end

function flm_BtnPanel.titleInit(args)
   --self.maxwintitle.gameObject:SetActive(false);
   if flm_Data.byFreeCnt > 0 or flm_Data.freeAllGold > 0 then
      self.freesp.gameObject:SetActive(true)
   else
      self.freesp.gameObject:SetActive(false)
   end
   if flm_Data.byFreeCnt == 0 and flm_Data.freeAllGold == 0 then
      if flm_Data.bFireMode == false then
         MusicManager:PlayBacksound("end", false)
      elseif flm_Data.bFireCom == true then
         MusicManager:PlayBacksound("end", false)
      end
   end
end

function flm_BtnPanel.showFreeTipHander(args)
   if flm_Data.byAddFreeCnt == 0 then
      return
   end
   flm_PushFun.CreatShowNum(
      self.freeTips.transform:Find("numcont"),
      flm_Data.byAddFreeCnt,
      "free_tips_",
      false,
      58,
      2,
      1100,
      -500
   )
   self.freeTips.gameObject:SetActive(true)
   coroutine.start(
      function()
         coroutine.wait(2)
         self.freeTips.gameObject:SetActive(false)
      end
   )
end

--这是event里面传过来的
function flm_BtnPanel.choumBtnInter(args)
   if
      flm_Data.byFreeCnt > 0 or (flm_Data.bFireMode == true and flm_Data.bFireCom == false) or
         flm_Data.isAutoGame == true
    then
      self.perBtn.gameObject:GetComponent("Button").interactable = false
      self.nextBtn.gameObject:GetComponent("Button").interactable = false
   else
      self.perBtn.gameObject:GetComponent("Button").interactable = args
      self.nextBtn.gameObject:GetComponent("Button").interactable = args
   end
end
--这是按钮改变的时候的检查
function flm_BtnPanel.myChoumBtnInter(args)
   if
      flm_Data.byFreeCnt > 0 or (flm_Data.bFireMode == true and flm_Data.bFireCom == false) or
         flm_Data.isAutoGame == true
    then
      self.nextBtn.gameObject:GetComponent("Button").interactable = false
      self.perBtn.gameObject:GetComponent("Button").interactable = false
   end
end

function flm_BtnPanel.stopBtnHander(args)
   --self.setVisibleBtn(1);
   if flm_Socket.isongame == false then
      return
   end
   self.showWinGold = flm_Data.lineWinScore
   self.winGoldroll.onceStop = true
   self.tswintswinGoldroll.onceStop = true
   self.closeStopBtnHander()
   --self.autobtn.gameObject:GetComponent("Button").interactable = true;
   flm_Event.dispathEvent(flm_Event.xiongm_show_stop_btn_click)
end

function flm_BtnPanel.startHander(args)
   self.tswintsSp.gameObject:SetActive(false)
   if flm_Data.freeAllGold > 0 then
      return
   end
   self.showWinGold = 0
   flm_PushFun.CreatShowNum(self.WinGoldNum, 0, "win_gold_", false, 58, 2, 310, -142)
end

function flm_BtnPanel.onceOver(args)
   if flm_Data.isFreeing == false or ((flm_Data.byFreeCnt == flm_Data.byAddFreeCnt) and flm_Data.byFreeCnt > 0) then
      self.winGoldSpVisibel()
   end
end

function flm_BtnPanel.showAllFu(args)
   for i = 1, 5 do
      self.tswintsSp.transform:Find("item_" .. i).gameObject:SetActive(false)
   end
   local numspStr = nil
   local soundstr = nil
   if flm_Data.fuType[2] > 0 then
      self.tswintsNumStr = "freeall_gold_"
      numspStr = "item_5"
      soundstr = "jackpot"
   end
   if numspStr ~= nil then
      self.tswintsSp.transform:Find(numspStr).gameObject:SetActive(true)
      self.tswintsNum = self.tswintsSp.transform:Find(numspStr .. "/numcont")
      self.tswintsSp.gameObject:SetActive(true)
      self.tswintswinGoldroll:setdata(0, flm_Data.fuType[2], 5)
      if soundstr ~= nil then
         flm_Socket.playaudio(soundstr, false, false)
      end
      return 1
   end
   return nil
end

function flm_BtnPanel.setTsWinSpShow()
   for i = 1, 5 do
      self.tswintsSp.transform:Find("item_" .. i).gameObject:SetActive(false)
   end
   local numspStr = nil
   local soundstr = nil
   if flm_Data.fuType[2] > 0 then
      self.tswintsNumStr = "freeall_gold_"
      numspStr = "item_5"
      soundstr = "jackpot"
   elseif flm_Data.allOpenRate > 499 then
      self.tswintsNumStr = "freeall_gold_"
      numspStr = "item_4"
      soundstr = "jackpot"
   elseif flm_Data.allOpenRate > 299 then
      self.tswintsNumStr = "freeall_gold_"
      numspStr = "item_3"
      soundstr = "jackpot"
   elseif flm_Data.allOpenRate > 199 then
      self.tswintsNumStr = "freeall_gold_"
      numspStr = "item_2"
      soundstr = "win"
   elseif flm_Data.allOpenRate > 99 then
      self.tswintsNumStr = "freeall_gold_"
      numspStr = "item_1"
      soundstr = "win"
   end
   if numspStr ~= nil then
      self.tswintsSp.transform:Find(numspStr).gameObject:SetActive(true)
      self.tswintsNum = self.tswintsSp.transform:Find(numspStr .. "/numcont")
      self.tswintsSp.gameObject:SetActive(true)
      self.tswintsNum.gameObject:SetActive(false)
      --flm_PushFun.CreatShowNum(self.tswintsNum,0,"freeall_gold_",false,57,2,820,-210);
      if soundstr ~= nil then
         flm_Socket.playaudio(soundstr, false, false)
      end
      return 1
   end
   return nil
end

--
function flm_BtnPanel.onceShowWinGold(args)
   self.winGoldroll:setdata(0, args.data.addmoney, args.data.playtimer)
   self.showWinData = args.data
   self.showWinGold = 20000000000
end

function flm_BtnPanel.showWinGoldHander(args)
   -- error("__0000__showWinGoldHander____"..self.showWinGold);
   if self.showWinGold >= flm_Data.lineWinScore and flm_Data.freeAllGold == 0 and flm_Data.byFreeCnt == 0 then
      return
   end

   self.showWinData = args.data
   --error("__111__showWinGoldHander____"..self.showWinData.addmoney);
   local redata = self.setTsWinSpShow()
   if redata ~= nil then
      coroutine.start(
         function()
            coroutine.wait(1.5)
            if flm_Data.fuType[2] > 0 then
               flm_Socket.playaudio("firework", false, false)
               coroutine.wait(1.5)
               self.tswintsNum.gameObject:SetActive(true)
               self.tswintswinGoldroll:setdata(0, flm_Data.lineWinScore, self.showWinData.playtimer)
               flm_Socket.playaudio("normalwin", false, false)
               self.winGoldroll:setdata(self.showWinGold, self.showWinData.addmoney, self.showWinData.playtimer + 2)
            else
               self.tswintsNum.gameObject:SetActive(true)
               self.tswintswinGoldroll:setdata(0, flm_Data.lineWinScore, self.showWinData.playtimer)
               flm_Socket.playaudio("normalwin", false, false)
               error("_________winGoldroll_______" .. self.showWinGold .. "_____" .. self.showWinData.addmoney)
               self.winGoldroll:setdata(self.showWinGold, self.showWinData.addmoney, self.showWinData.playtimer + 2)
            end
            self.showWinGold = self.showWinData.addmoney
         end
      )
   else
      flm_Socket.playaudio("normalwin", false, false)
      self.winGoldroll:setdata(self.showWinGold, self.showWinData.addmoney, self.showWinData.playtimer)
      self.showWinGold = self.showWinData.addmoney
   end

   if self.showWinData.anima ~= nil and flm_Data.allOpenRate > 100 then
      --self.showWinData.anima.main.loop = true;
      -- local m =self.showWinData.anima.main;
      --m.loop = true;
      --self.showWinData.anima:Play();
      if flm_Data.byFreeCnt > 0 then
         MusicManager:PlayBacksound("end", false)
      end
      --self.maxwintitle.gameObject:SetActive(true);
      self.freesp.gameObject:SetActive(false)
   else
      --flm_Socket.playaudio("normalwin",false,false);
   end
end

function flm_BtnPanel.winGoldSpVisibel(args)
   if flm_Data.isshowmygold == false then
      flm_Data.isshowmygold = true
      flm_Event.dispathEvent(flm_Event.xiongm_gold_chang, true)
   end
   if not IsNil(flm_Data.saveSound) then
      destroy(flm_Data.saveSound)
      flm_Data.saveSound = nil
   end
   if flm_Data.byFreeCnt == 0 and flm_Data.bFireCom == true then
      MusicManager:PlayBacksound("end", false)
   end
end

function flm_BtnPanel.perBtnHander(args)
   if flm_Socket.isongame == false then
      return
   end
   if flm_Data.byFreeCnt > 0 then
      return
   end
   if flm_Data.bFireMode == true and flm_Data.bFireCom == false then
      return
   end
   flm_Socket.playaudio("click")
   self.curChoumIndex = self.curChoumIndex - 1
   if self.curChoumIndex <= 0 then
      self.curChoumIndex = #flm_Data.choumtable
   end
   self.showChoumValue()
   flm_Event.dispathEvent(flm_Event.xiongm_update_allfu_value)
end

function flm_BtnPanel.nextBtnHander(args)
   if flm_Socket.isongame == false then
      return
   end
   if flm_Data.byFreeCnt > 0 then
      return
   end
   if flm_Data.bFireMode == true and flm_Data.bFireCom == false then
      return
   end
   flm_Socket.playaudio("click")
   self.curChoumIndex = self.curChoumIndex + 1
   if self.curChoumIndex > #flm_Data.choumtable then
      self.curChoumIndex = 1
   end
   self.showChoumValue()
   flm_Event.dispathEvent(flm_Event.xiongm_update_allfu_value)
end

function flm_BtnPanel.showChoumValue(args)
   flm_Data.curSelectChoum = flm_Data.choumtable[self.curChoumIndex]
   self.choumtxt.gameObject:GetComponent("Text").text =
      "(" .. flm_CMD.D_LINE_COUNT .. "线 × " .. flm_Data.curSelectChoum .. ")"
   flm_PushFun.CreatShowNum(
      self.chouNum,
      flm_Data.curSelectChoum * flm_CMD.D_LINE_COUNT,
      "choum_",
      false,
      18,
      2,
      220,
      -566
   )
   flm_PushFun.CreatShowNum(self.WinGoldNum, 0, "win_gold_", false, 58, 2, 310, -142)
   flm_Event.dispathEvent(flm_Event.xiongm_choum_chang)
   self.setDaXiaoFuValue()
   --flm_PushFun.CreatShowNum(self.chouNum,flm_Data.curSelectChoum,"choum_",false,18,2,136,51);
   --flm_PushFun.CreatShowNum(self.allPushNum,flm_Data.curSelectChoum*flm_CMD.D_LINE_COUNT,"choum_",false,18,2,230,-384);
end

function flm_BtnPanel.startBtnInter(args)
   self.autobtn.gameObject:GetComponent("Button").interactable = args.data
   self.choumBtnInter(args.data)
end

function flm_BtnPanel.showStartBtn(args)
   self.setVisibleBtn(1)
   self.autobtn.gameObject:GetComponent("Button").interactable = true
end

function flm_BtnPanel.showLiehuo(args)
   --self.setVisibleBtn(4);
end

function flm_BtnPanel.showNoStartBtnHander(args)
   self.setVisibleBtn(2)
end
function flm_BtnPanel.freeNumChang(args)
   flm_PushFun.CreatShowNum(self.freeNumCont, math.max(0, flm_Data.byFreeCnt - 1), "free_", false, 39, 2, 120, -40)
end

function flm_BtnPanel.goldModeNumChang(args)
   if flm_Data.byGoldModeNum == 0 then
      self.goldModesp.gameObject:SetActive(false)
   else
      self.setVisibleBtn(6)
   end
   flm_PushFun.CreatShowNum(
      self.goldModeNumCont,
      math.max(0, flm_Data.byGoldModeNum - 1),
      "free_",
      false,
      39,
      2,
      120,
      -40
   )
end

function flm_BtnPanel.showFreeBtn(args)
   --self.setVisibleBtn(5);
   flm_PushFun.CreatShowNum(self.freeNumCont, math.max(0, flm_Data.byFreeCnt - 1), "free_", false, 39, 2, 120, -40)
end

function flm_BtnPanel.showGoldModeBtn(args)
   self.setVisibleBtn(6)
   flm_PushFun.CreatShowNum(
      self.goldModeNumCont,
      math.max(0, flm_Data.byGoldModeNum - 1),
      "free_",
      false,
      39,
      2,
      120,
      -40
   )
end

function flm_BtnPanel.gameInit(args)
   log("====================================setsence")
   if flm_Data.curSelectChoum==0 then
      self.curChoumIndex=1
      flm_Data.curSelectChoum=flm_Data.choumtable[self.curChoumIndex]
   else
      local len = #flm_Data.choumtable
      for i = 1, len do
         if flm_Data.curSelectChoum == flm_Data.choumtable[i] then
            self.curChoumIndex = i
            break
         end
      end
   end

   log("===================================init")
   self.choumtxt.gameObject:GetComponent("Text").text =
      "(" .. flm_CMD.D_LINE_COUNT .. "线 × " .. flm_Data.curSelectChoum .. ")"
   flm_PushFun.CreatShowNum(self.myGoldNum, flm_Data.myinfoData._7wGold, "win_gold_", false, 22, 2, 310, -142)
   flm_PushFun.CreatShowNum(
      self.chouNum,
      flm_Data.curSelectChoum * flm_CMD.D_LINE_COUNT,
      "choum_",
      false,
      18,
      2,
      220,
      -566
   )
   self.setDaXiaoFuValue()
   --flm_PushFun.CreatShowNum(self.chouNum,flm_Data.curSelectChoum,"choum_",false,18,2,136,51);
   --flm_PushFun.CreatShowNum(self.allPushNum,flm_Data.curSelectChoum*flm_CMD.D_LINE_COUNT,"choum_",false,18,2,230,-384);
end

function flm_BtnPanel.setDaXiaoFuValue()
   flm_PushFun.CreatShowNum(
      self.daFuNumCont,
      flm_Data.curSelectChoum * flm_Data.fuTimes[2],
      "fu_",
      false,
      18,
      2,
      290,
      -130
   )
   flm_PushFun.CreatShowNum(
      self.xiaoFuNumCont,
      flm_Data.curSelectChoum * flm_Data.fuTimes[1],
      "fu_",
      false,
      18,
      2,
      290,
      -130
   )
end

function flm_BtnPanel.updateAllFuValue(arg)
   flm_PushFun.CreatShowNum(
      self.allFuNumCont,
      math.ceil(flm_Data.allfuvalue * (self.curChoumIndex / 5)),
      "fu_",
      false,
      18,
      2,
      290,
      -130
   )
end

function flm_BtnPanel.goldChang(args)
   if flm_Data.isshowmygold == true then
      flm_PushFun.CreatShowNum(self.myGoldNum, flm_Data.myinfoData._7wGold, "win_gold_", false, 22, 2, 310, -142)
   --      if args.data==true then
   --         self.getgoldanima:Play();
   --      end
   end
end

function flm_BtnPanel.noStartBtnHander(args)
   if flm_Socket.isongame == false then
      return
   end
   flm_Socket.playaudio("click")
   flm_Data.isAutoGame = false
   self.stopautobtnnum.gameObject:SetActive(false)
   self.setVisibleBtn(1)
end

function flm_BtnPanel.Update()
   if self.isCountAutoTimer == true then
      if self.countAutoTimer > 1 then
         self.isCountAutoTimer = false
         self.countAutoTimer = 0
         --   self.autobtn.gameObject:SetActive(false);
         --   flm_Data.isAutoGame = true;
         --   self.setVisibleBtn(2);
         --   flm_Socket.gameOneOver(true);
         self.selectnumcont.gameObject:SetActive(true)
      else
         self.countAutoTimer = self.countAutoTimer + Time.deltaTime
      end
   end
end

function flm_BtnPanel.autoBtnHander(args)
   if self.autoClick == true or flm_Socket.isongame == false then
      --error("___autoBtnHander______");
      return
   end
   if self.isongame == false or flm_Data.isResCom ~= 2 then
      return
   end
   if toInt64(flm_Data.curSelectChoum * flm_CMD.D_LINE_COUNT) > toInt64(flm_Data.myinfoData._7wGold) then
      flm_Socket.ShowMessageBox("金币不够", 1, nil)
      return
   end
   self.autoClick = true
   flm_Event.dispathEvent(flm_Event.xiongm_start_btn_click)
   coroutine.start(
      function(args)
         self.startBtnInter({data = false})
         flm_Socket.playaudio("click")
         flm_Socket.isReqDataIng = false
         flm_Socket.reqStart()
         coroutine.wait(1)
         self.autoClick = false
      end
   )
end

function flm_BtnPanel.closeAutoBtnHander(args)
   self.autobtn.gameObject:SetActive(true)
   flm_Data.isAutoGame = false
end
