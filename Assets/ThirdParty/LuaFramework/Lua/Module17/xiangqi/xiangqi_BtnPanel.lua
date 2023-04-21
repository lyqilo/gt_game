xiangqi_BtnPanel = {}
local self = xiangqi_BtnPanel

function xiangqi_BtnPanel.init()
   self.per = nil
   self.autobtn = nil
   self.stopautobtnnum = nil
   self.selectnumcont = nil
   self.countAutoTimer = 0
   self.isCountAutoTimer = false
   self.autoandstartcont = nil
   self.myGoldNum = nil
   self.chouNum = nil
   self.choumtxt = nil

   self.freesp = nil
   self.freeNumCont = nil

   self.noStartBtn = nil --手动按钮
   self.stopBtn = nil --停止按钮
   self.guikey = "cn"

   self.curChoumIndex = 1
   self.perBtn = nil
   self.nextBtn = nil

   self.winGoldSp = nil
   self.WinGoldNum = nil
   self.showWinGold = 0
   self.showWinData = nil
   self.selfGameIndex = 0

   self.winGoldroll = nil

   self.freeTips = nil

   self.autoClick = false --开始按钮是不是点击
   self.getgoldanima = nil

   self.mianfzhuan = nil
end

function xiangqi_BtnPanel.setPer(args)
   self.init()
   self.per = args
   self.guikey = xiangqi_Event.guid()
   self.autobtn = self.per.transform:Find("startbtn")
   self.myGoldNum = self.per.transform:Find("mygoldcont/mygoldnumcont")
   self.chouNum = self.per.transform:Find("choumcont/choumnumcont")
   self.choumtxt = self.per.transform:Find("choumcont/choumtxt")

   self.perBtn = self.per.transform:Find("choumcont/perbtn")
   self.nextBtn = self.per.transform:Find("choumcont/nextbtn")
   self.freeTips = self.per.transform:Find("tsmodets/freetips")

   self.winGoldSp = self.per.transform:Find("wingoldcont")
   self.WinGoldNum = self.per.transform:Find("wingoldcont/numcont")

   self.freesp = self.per.transform:Find("freeicon")
   self.freeNumCont = self.per.transform:Find("freeicon/numcont")
   self.gametitle = self.per.transform:Find("title")

   self.noStartBtn = self.per.transform:Find("closestartbtncont/nostartbtn") --手动按钮
   self.stopautobtnnum = self.per.transform:Find("closestartbtncont/numtxt").gameObject
   self.selectnumcont = self.per.transform:Find("selectnumcont").gameObject
   self.stopBtn = self.per.transform:Find("stopbtn") --停止按钮
   self.mianfzhuan = self.per.transform:Find("mianfzhuan") --免费转状态

   self.noStartBtn.gameObject:SetActive(false)
   self.stopBtn.gameObject:SetActive(false)
   self.freeTips.gameObject:SetActive(false)
   self.mianfzhuan.gameObject:SetActive(false)

   self.selectnumcont.gameObject:SetActive(false)
   self.stopautobtnnum.gameObject:SetActive(false)

   self.winGoldroll = xiangqi_NumRolling:New()
   self.winGoldroll:setfun(self, self.winGoldRollCom, self.winGoldRollIng)
   table.insert(xiangqi_Data.numrollingcont, #xiangqi_Data.numrollingcont + 1, self.winGoldroll)

   self.addEvent()
   local eventTrigger = Util.AddComponent("EventTriggerListener", self.autobtn.gameObject)
   eventTrigger.onDown = self.autoStartDown
   eventTrigger.onUp = self.autoStartUp

   xiangqi_PushFun.CreatShowNum(self.WinGoldNum, 0, "win_gold_", false, 58, 2, 310, -142)

   self.getgoldanima = self.per.transform:Find("mygoldcont/getgoldanima").gameObject:AddComponent(typeof(ImageAnima))
   --     for i=1,5 do
   --       self.getgoldanima:AddSprite(xiangqi_Data.icon_res.transform:Find("mygold_chang_"..1):GetComponent('Image').sprite);
   --       self.getgoldanima:AddSprite(xiangqi_Data.icon_res.transform:Find("mygold_chang_"..2):GetComponent('Image').sprite);
   --    end
   --    self.getgoldanima.fSep = 0.1;
end

function xiangqi_BtnPanel.loadResCom(args)
   if self.getgoldanima == nil then
      return
   end
   for i = 1, 5 do
      self.getgoldanima:AddSprite(
         xiangqi_Data.icon_res.transform:Find("mygold_chang_" .. 1):GetComponent("Image").sprite
      )
      self.getgoldanima:AddSprite(
         xiangqi_Data.icon_res.transform:Find("mygold_chang_" .. 2):GetComponent("Image").sprite
      )
   end
   self.getgoldanima.fSep = 0.1
end

function xiangqi_BtnPanel.showTitileMode(args)
   if xiangqi_Data.byFreeCnt > 0 or xiangqi_Data.freeAllGold > 0 then
      self.gametitle.gameObject:SetActive(false)
      self.freesp.gameObject:SetActive(true)
   else
      self.gametitle.gameObject:SetActive(true)
      self.freesp.gameObject:SetActive(false)
   end
end

function xiangqi_BtnPanel.winGoldRollIng(obj, args)
   xiangqi_PushFun.CreatShowNum(self.WinGoldNum, args, "win_gold_", false, 58, 2, 310, -142)
end

function xiangqi_BtnPanel.winGoldRollCom(obj, args)
   if not IsNil(xiangqi_Data.saveSound) then
      destroy(xiangqi_Data.saveSound)
   end
   MusicManager:PlayBacksound("end", false)
   if self.showWinData.anima ~= nil then
      -- self.showWinData.anima.loop = false;
      local m = self.showWinData.anima.main
      m.loop = false
   --self.showWinData.anima:Play();
   end
   if self.showWinData.iscom == true then
      xiangqi_PushFun.CreatShowNum(self.WinGoldNum, xiangqi_Data.lineWinScore, "win_gold_", false, 58, 2, 310, -142)
      self.winGoldSpVisibel()
   else
      xiangqi_PushFun.CreatShowNum(self.WinGoldNum, args, "win_gold_", false, 58, 2, 310, -142)
   end
   self.closeStopBtnHander()
   if xiangqi_Data.isPalyFreeAnima == true then
      xiangqi_LianLine.freeAnima()
      return
   end
   if xiangqi_Data.byFreeCnt > 0 or xiangqi_Data.freeAllGold > 0 or xiangqi_Data.isAutoGame == true then
      --error("___freeAllGold__");
      xiangqi_Socket.gameOneOver2(false)
   else
      xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_show_start_btn, nil)
      xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_start_btn_no_inter, true)
   end
end

--根据一些状态隐藏界面 1 开始 2 手动 3 停止 4 烈火 5免费
function xiangqi_BtnPanel.setVisibleBtn(args)
   self.autobtn.gameObject:SetActive(false)
   self.noStartBtn.gameObject:SetActive(false)
   if args == 1 then
      xiangqi_PushFun.CreatShowNum(
         self.myGoldNum,
         xiangqi_Data.myinfoData._7wGold,
         "win_gold_",
         false,
         22,
         2,
         310,
         -142
      )
      if xiangqi_Data.isAutoGame == false then
         self.autobtn.gameObject:SetActive(true)
      else
         self.noStartBtn.gameObject:SetActive(true)
      end
   elseif args == 2 then
      xiangqi_PushFun.CreatShowNum(
         self.myGoldNum,
         xiangqi_Data.myinfoData._7wGold - xiangqi_Data.curSelectChoum * xiangqi_Data.baseRate,
         "win_gold_",
         false,
         22,
         2,
         310,
         -142
      )
      self.myChoumBtnInter(false)
      self.noStartBtn.gameObject:SetActive(true)
   end
end

function xiangqi_BtnPanel.modeBtnState()
   if xiangqi_Data.byFreeCnt > 0 or xiangqi_Data.freeAllGold > 0 then
      self.mianfzhuan.gameObject:SetActive(true)
   else
      self.mianfzhuan.gameObject:SetActive(false)
   end
end

function xiangqi_BtnPanel.autoStartDown(args)
   self.isCountAutoTimer = true --是不是记录 自动按钮按下的时间
end

function xiangqi_BtnPanel.autoStartUp(args)
   self.isCountAutoTimer = false --是不是记录 自动按钮按下的时间
   self.countAutoTimer = 0 --按钮按下的时间
end

function xiangqi_BtnPanel.addEvent()
   xiangqi_Data.luabe:AddClick(self.autobtn.gameObject, self.autoBtnHander)
   xiangqi_Data.luabe:AddClick(self.noStartBtn.gameObject, self.noStartBtnHander)
   xiangqi_Data.luabe:AddClick(self.stopBtn.gameObject, self.stopBtnHander)

   xiangqi_Data.luabe:AddClick(self.perBtn.gameObject, self.perBtnHander)
   xiangqi_Data.luabe:AddClick(self.nextBtn.gameObject, self.nextBtnHander)

   xiangqi_Event.addEvent(xiangqi_Event.xiongm_init, self.gameInit, self.guikey)
   xiangqi_Event.addEvent(xiangqi_Event.xiongm_show_start_btn, self.showStartBtn, self.guikey)
   xiangqi_Event.addEvent(xiangqi_Event.xiongm_start_btn_no_inter, self.startBtnInter, self.guikey)
   xiangqi_Event.addEvent(xiangqi_Event.xiongm_show_free_btn, self.showFreeBtn, self.guikey)
   xiangqi_Event.addEvent(xiangqi_Event.xiongm_show_free_num_chang, self.freeNumChang, self.guikey)
   --xiangqi_Event.addEvent(xiangqi_Event.xiongm_lihuo_bg_anima,self.showLiehuo,self.guikey);
   xiangqi_Event.addEvent(xiangqi_Event.xiongm_gold_chang, self.goldChang, self.guikey)
   xiangqi_Event.addEvent(xiangqi_Event.xiongm_show_no_start_btn, self.showNoStartBtnHander, self.guikey)
   --error("__111__add_");
   xiangqi_Event.addEvent(xiangqi_Event.xiongm_show_stop_btn, self.showStopBtnHander, self.guikey)
   xiangqi_Event.addEvent(xiangqi_Event.xiongm_close_stop_btn, self.closeStopBtnHander, self.guikey)
   -- error("__22__add_");
   xiangqi_Event.addEvent(xiangqi_Event.xiongm_show_win_gold, self.showWinGoldHander, self.guikey)
   xiangqi_Event.addEvent(xiangqi_Event.xiongm_start, self.startHander, self.guikey)
   xiangqi_Event.addEvent(xiangqi_Event.game_once_over, self.onceOver, self.guikey)

   xiangqi_Event.addEvent(xiangqi_Event.xiongm_mianf_btn_mode, self.modeBtnState, self.guikey)
   xiangqi_Event.addEvent(xiangqi_Event.xiongm_title_mode, self.showTitileMode, self.guikey)

   xiangqi_Event.addEvent(xiangqi_Event.xiongm_load_res_com, self.loadResCom, self.guikey)

   xiangqi_Event.addEvent(xiangqi_Event.xiangqi_over, xiangqi_Event.hander(self, self.gameOver), self.guikey)
   self.selectnumcont.transform:Find("closebtn/Text").gameObject:SetActive(false)
   xiangqi_Data.luabe:AddClick(self.selectnumcont.transform:Find("closebtn").gameObject, self.closeSelectRunNun)
   for i = 1, 4 do
      xiangqi_Data.luabe:AddClick(
         self.selectnumcont.transform:Find("item_" .. i .. "/btn").gameObject,
         self.selectRunNunHander
      )
   end
end

function xiangqi_BtnPanel.closeSelectRunNun(args)
   self.selectnumcont.gameObject:SetActive(false)
end

function xiangqi_BtnPanel.selectRunNunHander(args)
   local str = args.transform.parent.name
   local str1 = string.split(str, "_")
   self.closeSelectRunNun()
   --self.noStartBtn.gameObject:SetActive(true);
   self.setVisibleBtn(2)
   xiangqi_Data.isAutoGame = true
   xiangqi_Socket.gameOneOver(true)
   local datanum = {10, 50, 100, 10000000}
   xiangqi_Data.autoRunNum = datanum[tonumber(str1[2])]
   self.stopautobtnnum.gameObject:SetActive(true)
end

function xiangqi_BtnPanel.gameOver(args)
   if xiangqi_Data.autoRunNum < 1 and xiangqi_Data.isAutoGame == true then
      self.noStartBtnHander()
      self.stopautobtnnum.gameObject:SetActive(false)
   else
      local str = xiangqi_Data.autoRunNum
      if xiangqi_Data.autoRunNum > 1000 then
         str = "无限"
      end
      self.stopautobtnnum.gameObject:GetComponent("Text").text = str
   end
end

function xiangqi_BtnPanel.showFreeTipHander(args)
   xiangqi_PushFun.CreatShowNum(
      self.freeTips.transform:Find("numcont"),
      xiangqi_Data.byFreeCnt,
      "win_gold_",
      false,
      58,
      2,
      120,
      3
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
function xiangqi_BtnPanel.choumBtnInter(args)
   if
      xiangqi_Data.byFreeCnt > 0 or (xiangqi_Data.bFireMode == true and xiangqi_Data.bFireCom == false) or
         xiangqi_Data.isAutoGame == true
    then
      self.perBtn.gameObject:GetComponent("Button").interactable = false
      self.nextBtn.gameObject:GetComponent("Button").interactable = false
   else
      self.perBtn.gameObject:GetComponent("Button").interactable = args
      self.nextBtn.gameObject:GetComponent("Button").interactable = args
   end
end
--这是按钮改变的时候的检查
function xiangqi_BtnPanel.myChoumBtnInter(args)
   if
      xiangqi_Data.byFreeCnt > 0 or (xiangqi_Data.bFireMode == true and xiangqi_Data.bFireCom == false) or
         xiangqi_Data.isAutoGame == true
    then
      self.nextBtn.gameObject:GetComponent("Button").interactable = false
      self.perBtn.gameObject:GetComponent("Button").interactable = false
   end
end

function xiangqi_BtnPanel.startHander(args)
   if xiangqi_Data.freeAllGold > 0 then
      return
   end
   self.showWinGold = 0
   xiangqi_PushFun.CreatShowNum(self.WinGoldNum, 0, "win_gold_", false, 58, 2, 310, -142)
end

function xiangqi_BtnPanel.onceOver(args)
   --   if xiangqi_Data.byFreeCnt>0 then
   --     return;
   --   end
   --   xiangqi_PushFun.CreatShowNum(self.WinGoldNum,0,"win_gold_",false,58,2,920,-420);
   --   self.showWinGold = 0;
end

function xiangqi_BtnPanel.showWinGoldHander(args)
   --error("__0000__showWinGoldHander____"..self.showWinGold);
   --MusicManager:PlayBacksound("end",false);
   if self.showWinGold >= xiangqi_Data.lineWinScore and xiangqi_Data.freeAllGold == 0 and xiangqi_Data.byFreeCnt == 0 then
      return
   end
   --error("__111__showWinGoldHander____"..self.showWinGold);
   self.showWinData = args.data
   self.winGoldroll:setdata(self.showWinGold, self.showWinData.addmoney, self.showWinData.playtimer)
   if self.showWinData.anima ~= nil then
      --self.showWinData.anima.loop = true;
      local m = self.showWinData.anima.main
      m.loop = true
      self.showWinData.anima:Play()
   end
   self.showWinGold = self.showWinData.addmoney
end

function xiangqi_BtnPanel.winGoldSpVisibel(args)
   --xiangqi_PushFun.CreatShowNum(self.WinGoldNum,0,"win_gold_",false,58,2,920,-420);
   if xiangqi_Data.isshowmygold == false then
      xiangqi_Data.isshowmygold = true
      xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_gold_chang, true)
   end
   if not IsNil(xiangqi_Data.saveSound) then
      destroy(xiangqi_Data.saveSound)
      xiangqi_Data.saveSound = nil
   end
   MusicManager:PlayBacksound("end", false)
end

function xiangqi_BtnPanel.perBtnHander(args)
   if xiangqi_Socket.isongame == false then
      return
   end
   if xiangqi_Data.byFreeCnt > 0 then
      return
   end
   if xiangqi_Data.bFireMode == true and xiangqi_Data.bFireCom == false then
      return
   end
   xiangqi_Socket.playaudio("click")
   self.curChoumIndex = self.curChoumIndex - 1
   if self.curChoumIndex <= 0 then
      self.curChoumIndex = #xiangqi_Data.choumtable
   end
   self.showChoumValue()
end

function xiangqi_BtnPanel.nextBtnHander(args)
   if xiangqi_Socket.isongame == false then
      return
   end
   if xiangqi_Data.byFreeCnt > 0 then
      return
   end
   if xiangqi_Data.bFireMode == true and xiangqi_Data.bFireCom == false then
      return
   end
   xiangqi_Socket.playaudio("click")
   self.curChoumIndex = self.curChoumIndex + 1
   if self.curChoumIndex > #xiangqi_Data.choumtable then
      self.curChoumIndex = 1
   end
   self.showChoumValue()
end

function xiangqi_BtnPanel.showChoumValue(args)
   self.choumtxt.gameObject:GetComponent("Text").text = xiangqi_Data.baseRate .. " × 投注金额"
   xiangqi_Data.curSelectChoum = xiangqi_Data.choumtable[self.curChoumIndex]
   xiangqi_PushFun.CreatShowNum(
      self.chouNum,
      xiangqi_Data.curSelectChoum * xiangqi_Data.baseRate,
      "choum_",
      false,
      18,
      2,
      185,
      -566
   )
   xiangqi_PushFun.CreatShowNum(self.WinGoldNum, 0, "win_gold_", false, 58, 2, 310, -142)
   xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_choum_chang)
   --xiangqi_PushFun.CreatShowNum(self.allPushNum,xiangqi_Data.curSelectChoum*xiangqi_CMD.D_LINE_COUNT,"choum_",false,18,2,230,-384);
end

function xiangqi_BtnPanel.startBtnInter(args)
   self.autobtn.gameObject:GetComponent("Button").interactable = args.data
   self.choumBtnInter(args.data)
end

function xiangqi_BtnPanel.showStartBtn(args)
   self.setVisibleBtn(1)
   self.autobtn.gameObject:GetComponent("Button").interactable = true
end

function xiangqi_BtnPanel.showLiehuo(args)
end

function xiangqi_BtnPanel.showNoStartBtnHander(args)
   self.setVisibleBtn(2)
end

function xiangqi_BtnPanel.showStopBtnHander(args)
   --error("________showStopBtnHander_________");
   self.stopBtn.gameObject:SetActive(true)
end

function xiangqi_BtnPanel.closeStopBtnHander(args)
   --error("________showStopBtnHander_________");
   self.stopBtn.gameObject:SetActive(false)
end

function xiangqi_BtnPanel.freeNumChang(args)
   xiangqi_PushFun.CreatShowNum(self.freeNumCont, xiangqi_Data.byFreeCnt - 1, "free_", false, 39, 2, 136, -96)
end

function xiangqi_BtnPanel.showFreeBtn(args)
   xiangqi_PushFun.CreatShowNum(self.freeNumCont, xiangqi_Data.byFreeCnt - 1, "free_", false, 39, 2, 136, -96)
end

function xiangqi_BtnPanel.gameInit(args)
   local len = #xiangqi_Data.choumtable
   for i = 1, len do
      if xiangqi_Data.curSelectChoum == xiangqi_Data.choumtable[i] then
         self.curChoumIndex = i
         break
      end
   end
   xiangqi_PushFun.CreatShowNum(self.myGoldNum, xiangqi_Data.myinfoData._7wGold, "win_gold_", false, 22, 2, 310, -142)
   self.choumtxt.gameObject:GetComponent("Text").text = xiangqi_Data.baseRate .. " × 投注金额"
   xiangqi_PushFun.CreatShowNum(
      self.chouNum,
      xiangqi_Data.curSelectChoum * xiangqi_Data.baseRate,
      "choum_",
      false,
      18,
      2,
      185,
      -566
   )
   --xiangqi_PushFun.CreatShowNum(self.allPushNum,xiangqi_Data.curSelectChoum*xiangqi_CMD.D_LINE_COUNT,"choum_",false,18,2,230,-384);
end

function xiangqi_BtnPanel.goldChang(args)
   if xiangqi_Data.isshowmygold == true then
      xiangqi_PushFun.CreatShowNum(
         self.myGoldNum,
         xiangqi_Data.myinfoData._7wGold,
         "win_gold_",
         false,
         22,
         2,
         310,
         -142
      )
      if args.data == true then
         self.getgoldanima:Play()
      end
   end
end

function xiangqi_BtnPanel.noStartBtnHander(args)
   if xiangqi_Socket.isongame == false then
      return
   end
   xiangqi_Socket.playaudio("click")
   xiangqi_Data.isAutoGame = false
   self.stopautobtnnum.gameObject:SetActive(false)
   self.setVisibleBtn(1)
end

function xiangqi_BtnPanel.stopBtnHander(args)
   if xiangqi_Socket.isongame == false then
      return
   end
   xiangqi_Socket.playaudio("click")
   --self.setVisibleBtn(1);
   self.showWinGold = xiangqi_Data.lineWinScore
   self.winGoldroll.onceStop = true
   self.closeStopBtnHander()
   --self.autobtn.gameObject:GetComponent("Button").interactable = true;
   xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_show_stop_btn_click)
end

function xiangqi_BtnPanel.Update()
   if self.isCountAutoTimer == true then
      if self.countAutoTimer > 1 then
         self.isCountAutoTimer = false
         self.countAutoTimer = 0
         --        self.autobtn.gameObject:SetActive(false);
         --        xiangqi_Data.isAutoGame = true;
         --        self.setVisibleBtn(2);
         --        xiangqi_Socket.gameOneOver(true);
         self.selectnumcont.gameObject:SetActive(true)
      else
         self.countAutoTimer = self.countAutoTimer + Time.deltaTime
      end
   end
end

function xiangqi_BtnPanel.autoBtnHander(args)
   if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then

      if self.autoClick == true or xiangqi_Socket.isongame == false then
         return
      end
      if self.isongame == false or xiangqi_Data.isResCom ~= 2 then
         return
      end
      if toInt64(xiangqi_Data.curSelectChoum * xiangqi_Data.baseRate) > toInt64(xiangqi_Data.myinfoData._7wGold) then
         xiangqi_Socket.ShowMessageBox("金币不够", 1, nil)
         return
      end
      xiangqi_PushFun.CreatShowNum(
              self.myGoldNum,
              xiangqi_Data.myinfoData._7wGold - xiangqi_Data.curSelectChoum * xiangqi_Data.baseRate,
              "win_gold_",
              false,
              22,
              2,
              310,
              -142
      )
      self.autoClick = true
      xiangqi_Event.dispathEvent(xiangqi_Event.xiongm_start_btn_click)
      coroutine.start(
              function(args)
                 self.startBtnInter({data = false})
                 xiangqi_Socket.playaudio("click")
                 xiangqi_Socket.isReqDataIng = false
                 xiangqi_Socket.reqStart()
                 coroutine.wait(1)
                 self.autoClick = false
              end
      )
      
   end
end

function xiangqi_BtnPanel.closeAutoBtnHander(args)
   self.autobtn.gameObject:SetActive(true)
   xiangqi_Data.isAutoGame = false
end
