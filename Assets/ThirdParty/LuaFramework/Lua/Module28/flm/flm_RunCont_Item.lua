flm_RunCont_Item = {}
local self = flm_RunCont_Item

function flm_RunCont_Item:new()
    local go = {}
    self.guikey = "cn"
    setmetatable(go, {__index = self})
    go.guikey = flm_Event.guid()
    return go
end
function flm_RunCont_Item:init()
    self.showpercont = nil
    self.showtabel = nil
    self.curindex = 1
    self.showdata = {}
    self.golddata = {}
    self.opendata = {}

    self.runpercont = nil
    self.sonItem = nil
    self.starty = -310
    self.sh = 160
    self.runtabel = nil
    self.runh = 0
    self.createnum = 0
    self.runcontpos = nil
    self.isrun = false

    self.speed = -5
    self.speedtimer = 0.5
    self.lastjul = 0
    self.maxtimer = 12
    self.jiantimer = 0.4
    self.runStopLen = 0
    self.iscom = false
    self.isGoldIcon = false --是不是出现了金币图标
end

function flm_RunCont_Item:runStop()
    self.iscom = true
end

function flm_RunCont_Item:setOpenPos()
    local len = #self.runtabel - 2
    local pos = nil
    for i = len, #self.runtabel do
        pos = self.runtabel[i].transform.localPosition
        self.runtabel[i].transform.localPosition = Vector3.New(pos.x, pos.y - self.lastjul, pos.z)
    end
    self.lastjul = 0
end

function flm_RunCont_Item:setPer(runargs, showargs, cindex)
    self:init()
    self.curindex = cindex
    self.runpercont = runargs
    self.showpercont = showargs
    local pos = self.runpercont.transform.localPosition
    self.runcontpos = Vector3.New(pos.x, pos.y, pos.z)
    self.runtabel = {}
    self.showtabel = {}
    self.runpercont.gameObject:SetActive(false)
    self.showpercont.gameObject:SetActive(true)
    self.golddata = {}
    self.showdata = {}
    self.opendata = {}
    self:addEvent()
end

function flm_RunCont_Item:loadResCom(args)
end

function flm_RunCont_Item:setSonItem(per)
    self.sonItem = per
end

function flm_RunCont_Item:addEvent()
    flm_Event.addEvent(flm_Event.xiongm_over, flm_Event.hander(self, self.gameOver), self.guikey)
    flm_Event.addEvent(flm_Event.xiongm_load_res_com, flm_Event.hander(self, self.loadResCom), self.guikey)
    flm_Event.addEvent(flm_Event.xiongm_init, flm_Event.hander(self, self.gameInit), self.guikey)
end

function flm_RunCont_Item:gameInit(arg)
    --error("_____flm_RunCont_Item:gameInit______"..#self.opendata);
    if #self.opendata == 0 then
        --error("___00__flm_RunCont_Item:gameInit______"..#self.opendata);
        self:createServerdata()
        --error("__11___flm_RunCont_Item:gameInit______"..#self.opendata);
        self:setShow()
        self:setRunShow()
    end
end

function flm_RunCont_Item:gameOver(args)
    if args.data ~= nil and self.curindex ~= args.data.curindex then
        return
    end
    self.maxtimer = args.data.maxtimer
    self.jiantimer = args.data.jiantimer
    local waittime = flm_Config.runstoptimer_config[self.curindex]
    if self.maxtimer > 10 then
        flm_Socket.playaudio("speed", false, false)
        waittime = waittime / 2
    end
    --self.opendata = {};
    self.showdata = {}
    self.golddata = {}
    local openimg = nil
    self.isfreesound = false
    self.playStop = false
    self.isGoldIcon = false
    for i = 1, 3 do
        openimg = flm_Data.selectImg[self.curindex + (3 - i) * 5]
        if self.opendata[i] ~= openimg and openimg == flm_Config.gold then
            self.isGoldIcon = true
        end
        self.opendata[i] = openimg
        self.showdata[i] = openimg
        self.golddata[i] = flm_Data.openImgGold[self.curindex + (3 - i) * 5]
        if openimg == flm_Config.bianpao then
            self.isfreesound = true
        end
    end

    self:setOpenWin()
    self:setShow()
    coroutine.start(
        function()
            coroutine.wait(waittime)
            self.runStopLen = 0
            self:runStop()
        end
    )
end

function flm_RunCont_Item:randImg()
    local num = self.createnum
    local config = nil
    local sonfig = nil
    local midindex = 1
    local endindex = self.createnum
    config = flm_Config.rand_1
    for i = midindex, endindex do
        sonfig = self:randFun(config)
        if sonfig == nil then
        end
        if sonfig ~= 0 then
            self:setRunImg(self.runtabel[i], flm_Config.resimg_config[sonfig.src].normalimg, sonfig.src, true)
        end
    end
end

--设计显示
function flm_RunCont_Item:setShow()
    local item = nil
    local idata = nil
    for i = 1, 3 do
        idata = self.opendata[i]
        item = self.showtabel[i]
        item:setImg(flm_Config.resimg_config[idata].normalimg, self.golddata[i])
    end
end

function flm_RunCont_Item:setRunShow(args)
    local item = nil
    local idata = nil
    for i = 1, 3 do
        idata = self.opendata[i]
        item = self.runtabel[i]
        self:setRunImg(item, flm_Config.resimg_config[idata].normalimg, self.golddata[i], false)
    end
end

function flm_RunCont_Item:startRun(ags)
    if self.curindex == 1 then
        flm_Data.isruning = true
    end
    self.lastjul = 0
    self.maxtimer = 10
    self.jiantimer = 0.4
    self.speedtimer = 8
    self.runpercont.gameObject:SetActive(true)
    self.showpercont.gameObject:SetActive(false)
    self.isrun = true
end

--开奖结果
function flm_RunCont_Item:setOpenWin()
    local item = nil
    local idata = nil
    local len = #self.runtabel
    local dataindex = 1
    for i = len - 2, len do
        idata = self.opendata[dataindex]
        item = self.runtabel[i]
        self:setRunImg(item, flm_Config.resimg_config[idata].normalimg, idata, true)
        dataindex = dataindex + 1
    end
end

function flm_RunCont_Item:randFun(randtabel)
    local reslut = 0
    local randnum = math.random(0, 100)
    local beginIndex = math.random(1, #randtabel)
    local curindex
    for i = 1, #randtabel do
        curindex = ((i + beginIndex) % #randtabel) + 1
        if randnum <= randtabel[curindex].rate then
            reslut = randtabel[curindex]
            return reslut
        end
        randnum = randnum - randtabel[curindex].rate
    end
    return reslut
end

--生成里面的图片
function flm_RunCont_Item:createSonItem(num)
    local item = nil
    self.createnum = num
    for i = 1, num do
        item = newobject(self.sonItem)
        item.transform:SetParent(self.runpercont.transform)
        item.transform.localScale = Vector3.New(1, 1, 1)
        item.transform.localPosition = Vector3.New(0, self.starty + (i - 1) * self.sh, 0)
        self.sonItem.transform:Find("goldmode").gameObject:SetActive(false)
        table.insert(self.runtabel, i, item)
        self.runh = self.starty + (i - 1) * self.sh
    end
    for a = 1, 3 do
        item = flm_Run_Soon_Item:new()
        item:setPer(self.sonItem, true)
        item:setParent(self.showpercont)
        item:setPoint(Vector3.New(0, self.starty + (a - 1) * self.sh, 0))
        table.insert(self.showtabel, a, item)
        flm_Data.allshowitem[self.curindex + (3 - a) * 5] = item
    end
    self:randImg()
    if #flm_Data.selectImg > 0 then
        self:createServerdata()
        self:setShow()
        self:setRunShow()
    end
end

--收到服务器的数据后在初始图标
function flm_RunCont_Item:createServerdata()
    local openimg = nil
    for i = 1, 3 do
        openimg = flm_Data.selectImg[self.curindex + (3 - i) * 5]
        self.opendata[i] = openimg
        self.showdata[i] = openimg
        self.golddata[i] = flm_Data.openImgGold[self.curindex + (3 - i) * 5]
    end
end

function flm_RunCont_Item:setRunImg(item, imgname, goldtype, israndgold)
    local itemimg = flm_Data.icon_res.transform:Find(imgname).gameObject
    local fsize = itemimg.gameObject:GetComponent("RectTransform").sizeDelta
    item.transform:Find("icon").gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(fsize.x, fsize.y)
    item.transform:Find("icon").gameObject:GetComponent("Image").sprite =
        itemimg.gameObject:GetComponent("Image").sprite
    item.transform:Find("goldmode").gameObject:SetActive(false)
    if israndgold == false and goldtype > 0 then
        self:setGoldMode(item, goldtype)
    elseif israndgold == true and goldtype == flm_Config.gold then
        local val = math.random(1, 2000)
        local goldnum = flm_Data.curSelectChoum * val
        if val > 1500 then
            goldnum = 2
        elseif val > 1000 then
            goldnum = 1
        end
        self:setGoldMode(item, goldnum)
    end
end
function flm_RunCont_Item:setGoldMode(item, goldtype)
    item.transform:Find("goldmode/xiaofu").gameObject:SetActive(false)
    item.transform:Find("goldmode/dafu").gameObject:SetActive(false)
    item.transform:Find("goldmode/numcont").gameObject:SetActive(false)
    --1:大福 2小福
    if goldtype == 2 then
        item.transform:Find("goldmode/xiaofu").gameObject:SetActive(true)
    elseif goldtype == 1 then
        item.transform:Find("goldmode/dafu").gameObject:SetActive(true)
    else
        item.transform:Find("goldmode/numcont").gameObject:SetActive(true)
        flm_PushFun.CreatShowNum(item.transform:Find("goldmode/numcont"), goldtype,"gold_mode_",false,18, 2,125, -50);
    end
    item.transform:Find("goldmode").gameObject:SetActive(true)
end

function flm_RunCont_Item:deFault()
    local item = nil
    for i = 1, self.createnum do
        item = self.runtabel[i]
        item.transform.localPosition = Vector3.New(0, self.starty + (i - 1) * self.sh, 0)
    end
end

function flm_RunCont_Item:Update()
    if self.isrun == false then
        return
    end
    if self.iscom == true then
        self:serverRun()
    else
        self:clientRun()
    end
end

function flm_RunCont_Item:clientRun()
    local pos = nil
    local py = 0
    if self.speedtimer > self.maxtimer then
        self.speedtimer = self.maxtimer
    else
        self.speedtimer = self.speedtimer + self.jiantimer
    end
    local len = #self.runtabel - 3
    for i = 1, len do
        pos = self.runtabel[i].transform.localPosition
        py = pos.y + self.speed * self.speedtimer
        if py < (self.starty - self.sh) then
            py = self.starty + (len - 1) * self.sh - (self.starty - self.sh - pos.y)
            self.lastjul = self.sh + (self.starty - self.sh - pos.y)
        end
        self.runtabel[i].transform.localPosition = Vector3.New(pos.x, py, pos.z)
    end
end

function flm_RunCont_Item:serverRun()
    --   local pos = nil;
    --   local py = 0;
    --   if self.lastjul>0 then
    --      self:setOpenPos();
    --   end
    --   if self.runtabel[#self.runtabel].transform.localPosition.y<1500 then
    --      self.speedtimer = self.speedtimer-self.speedtimer/30;
    --      if self.speedtimer<0.2 then
    --         self.speedtimer = 0.2;
    --      end
    --   else
    --        if self.speedtimer>8 then
    --         self.speedtimer = 8;
    --      else
    --         self.speedtimer = self.speedtimer+0.1;
    --      end
    --   end
    --    py = self.speed*self.speedtimer;
    --    if (self.runtabel[#self.runtabel].transform.localPosition.y+py)<= (self.starty +self.sh*2) then
    --       py = self.starty +self.sh*2 - self.runtabel[#self.runtabel].transform.localPosition.y;
    --       self.isrun = false;
    --       self.iscom = false;
    --       flm_Socket.playaudio("runstop");
    --    end
    --    local len = #self.runtabel;
    --    for i=1,len do
    --         pos = self.runtabel[i].transform.localPosition;
    --         self.runtabel[i].transform.localPosition = Vector3.New(pos.x,pos.y+py,pos.z);
    --    end
    --    if self.isrun == false then
    --       self.runpercont.gameObject:SetActive(false);
    --       self.showpercont.gameObject:SetActive(true);
    --       self:deFault();
    --       self:randImg();
    --       self:setRunShow();
    --       if self.curindex==1 then
    --            flm_Socket.showLiehuo();
    --       end
    --       if self.curindex==5 then
    --          flm_Data.isruning = false;
    --          flm_Event.dispathEvent(flm_Event.xiongm_run_com);
    --       end
    --    end

    local pos = nil
    local py = 0
    if self.isrun == false then
        return
    end
    if self.runStopLen == 0 then
        if self.speedtimer > self.maxtimer then
            if self.lastjul > 0 then
                self:setOpenPos()
            end
            self.runStopLen = self.runtabel[#self.runtabel].transform.localPosition.y
        else
            self:clientRun()
            return
        end
    end
    if self.runStopLen > 0 then
        if self.runStopLen > self.maxtimer then
            py = math.min(math.abs(self.speed * self.maxtimer), self.runStopLen / 2.5)
            self.runStopLen = self.runStopLen - py
        else
            py = self.runStopLen
            self.isrun = false
            self.iscom = false
        end
        if self.runStopLen < 100 then
            if self.playStop == false then
                self.playStop = true

                if self.isGoldIcon == true then
                    flm_Socket.playaudio("runcoinstop" .. self.curindex, false, false)
                else
                    flm_Socket.playaudio("runnorstop", false, false)
                end
            end
        end
    end
    local len = #self.runtabel
    for i = 1, len do
        pos = self.runtabel[i].transform.localPosition
        self.runtabel[i].transform.localPosition = Vector3.New(pos.x, pos.y - py, pos.z)
    end
    if self.isrun == false then
        self.runpercont.gameObject:SetActive(false)
        self.showpercont.gameObject:SetActive(true)
        self:deFault()
        self:randImg()
        self:setRunShow()
        if self.curindex == 1 then
            flm_Socket.showLiehuo()
        end
        if self.curindex == 5 then
            flm_Data.isruning = false
        end
        flm_Event.dispathEvent(flm_Event.xiongm_run_com, self.curindex)
    end
end
