BirdsAndBeast_PushMoney = {}
local self = BirdsAndBeast_PushMoney

self.messkey = "0"
self.luabe = nil
self.per = nil
self.data = nil
self.mypushcont = nil
self.allpushcont = nil
self.ratecont = nil
self.anima = nil
self.rate = nil
self.isupdate = false
self.curtimer = 0
self.agetimer = 1
self.isAutoPush = false
self.isAutoStart = false
self.lastbtndowntimer = 0
self.selectanima = nil
function BirdsAndBeast_PushMoney:new()
    local obj = {}
    setmetatable(obj, {__index = self})
    obj.messkey = BirdsAndBeastEvent.guid()
    return obj
end

function BirdsAndBeast_PushMoney:setLuabe(lube)
    self.luabe = lube
    self:AddEvent()
end

function BirdsAndBeast_PushMoney:setPer(args)
    self.per = args
    self.mypushcont = self.per.transform:Find("mymoney")
    self.allpushcont = self.per.transform:Find("allmoney")
    self.ratecont = self.per.transform:Find("ratecont")

    local pushbtn = self.per.transform:Find("pushbtn").gameObject
    --pushbtn.gameObject:AddComponent(EventTriggerListener.GetClassType());
    local eventTrigger = Util.AddComponent("EventTriggerListener", pushbtn)
    eventTrigger.onDown = BirdsAndBeastEvent.hander(self, self.btnDown)
    eventTrigger.onUp = BirdsAndBeastEvent.hander(self, self.btnUp)

    local go = self.per.transform:Find("anima")
    go.gameObject:AddComponent(typeof(ImageAnima))
    self.anima = go.transform:GetComponent("ImageAnima")
    for i = 1, 13 do
        --self.anima:AddSprite(BirdsAndBeast_GameData.iconres.transform:Find("aimat_"..1).gameObject:GetComponent('Image').sprite);
        -- self.anima:AddSprite(BirdsAndBeast_GameData.iconres.transform:Find("aimat_"..2).gameObject:GetComponent('Image').sprite);
    end
    self.anima.fSep = 0.2
    self.anima:Stop()

    self.selectanima = self.per.transform:Find("selectanima").gameObject:AddComponent(typeof(ImageAnima))
    local resname = "push_select_anima_"
    if self.data.rtype == BirdsAndBeastConfig.bab_zous or self.data.rtype == BirdsAndBeastConfig.bab_feiq or 
    self.data.rtype == BirdsAndBeastConfig.bab_jinsha or  self.data.rtype == BirdsAndBeastConfig.bab_yins  then
        resname = "push_select_anima_max_"
    end
    for i = 1, 13 do
        self.selectanima:AddSprite(
            BirdsAndBeast_GameData.iconres.transform:Find(resname .. 1).gameObject:GetComponent("Image").sprite
        )
        self.selectanima:AddSprite(
            BirdsAndBeast_GameData.iconres.transform:Find(resname .. 2).gameObject:GetComponent("Image").sprite
        )
    end
    self.selectanima.fSep = 0.2
    self.selectanima:Stop()
    

    self:AddEvent()
end

function BirdsAndBeast_PushMoney:getLocalPos(args)
    local pos = self.per.transform.localPosition
    if
        self.data.rtype == BirdsAndBeastConfig.bab_zous or self.data.rtype == BirdsAndBeastConfig.bab_feiq or
            self.data.rtype == BirdsAndBeastConfig.bab_jinsha or
            self.data.rtype == BirdsAndBeastConfig.bab_yins
     then
        return Vector3.New(pos.x, pos.y + 30, pos.z)
    end
    return Vector3.New(pos.x - 55, pos.y, pos.z)
end

function BirdsAndBeast_PushMoney:btnDown(args)
    --error("_______btnDown_______"..BirdsAndBeast_GameData.runtimer);
    self.lastbtndowntimer = BirdsAndBeast_GameData.runtimer
    self.isAutoPush = true
    if self.isAutoStart == true then
        return
    end
    self:autoSendPush()
end

function BirdsAndBeast_PushMoney:autoSendPush()
    coroutine.start(
        function()
            self.isAutoStart = true
            coroutine.wait(0.2)
            if BirdsAndBeast_GameData.runtimer - self.lastbtndowntimer < 0.2 then
                self.isAutoStart = false
                return
            end
            if self.isAutoPush == true then
                self:pushMoneyHander(nil)
                self:autoSendPush()
            else
                self.isAutoStart = false
            end
        end
    )
end

function BirdsAndBeast_PushMoney:btnUp(args)
    --error("_______btnUp_______"..BirdsAndBeast_GameData.runtimer);
    self.lastbtndowntimer = 0
    self.isAutoPush = false
end

function BirdsAndBeast_PushMoney:setData(args)
    self.data = args
    if self.data.rtype == BirdsAndBeastConfig.bab_jinsha then
        table.insert(BirdsAndBeast_GameData.numrollingcont, #BirdsAndBeast_GameData.numrollingcont + 1, self)
    end
end

function BirdsAndBeast_PushMoney:AddEvent()
    if self.luabe ~= nil and self.per ~= nil then
        self.luabe:AddClick(
            self.per.transform:Find("pushbtn").gameObject,
            BirdsAndBeastEvent.hander(self, self.pushMoneyHander)
        )
    end
    BirdsAndBeastEvent.addEvent(
        BirdsAndBeastEvent.mypushmoneychang,
        BirdsAndBeastEvent.hander(self, self.myPushChang),
        self.messkey
    )
    BirdsAndBeastEvent.addEvent(
        BirdsAndBeastEvent.allpushchang,
        BirdsAndBeastEvent.hander(self, self.allPushChang),
        self.messkey
    )
    BirdsAndBeastEvent.addEvent(
        BirdsAndBeastEvent.pushmoneymultiplechang,
        BirdsAndBeastEvent.hander(self, self.rateChang),
        self.messkey
    )
    BirdsAndBeastEvent.addEvent(
        BirdsAndBeastEvent.openPushchang,
        BirdsAndBeastEvent.hander(self, self.openPushchang),
        self.messkey
    )
    BirdsAndBeastEvent.addEvent(
        BirdsAndBeastEvent.exitgame,
        BirdsAndBeastEvent.hander(self, self.exitgame),
        self.messkey
    )

    BirdsAndBeastEvent.addEvent(
        BirdsAndBeastEvent.startchip,
        BirdsAndBeastEvent.hander(self, self.ratetiaodo),
        self.messkey
    )
    BirdsAndBeastEvent.addEvent(
        BirdsAndBeastEvent.gamestatechang,
        BirdsAndBeastEvent.hander(self, self.ratetiaodo),
        self.messkey
    )
    BirdsAndBeastEvent.addEvent(
        BirdsAndBeastEvent.stopchip,
        BirdsAndBeastEvent.hander(self, self.stopMyPushHander),
        self.messkey
    )
    BirdsAndBeastEvent.addEvent(
        BirdsAndBeastEvent.startrun,
        BirdsAndBeastEvent.hander(self, self.ratetiaodo),
        self.messkey
    )
end

function BirdsAndBeast_PushMoney:stopMyPushHander(args)
    self.isAutoPush = false
    self:ratetiaodo(args)
end

function BirdsAndBeast_PushMoney:exitgame(args)
    self:destroying()
end
function BirdsAndBeast_PushMoney:destroying()
    self.messkey = "0"
    self.luabe = nil
    self.per = nil
    self.data = nil
    self.mypushcont = nil
    self.allpushcont = nil
    self.ratecont = nil
    self.anima = nil
    self.rate = nil
    self.isupdate = false
    self.curtimer = 0
    self.agetimer = 1
    self.isAutoPush = false
    self.isAutoStart = false
    self.lastbtndowntimer = 0
    self.selectanima = nil
end

function BirdsAndBeast_PushMoney:ratetiaodo(args)
    if BirdsAndBeast_GameData.gameState == BirdsAndBeast_CMD.D_GAME_STATE_CHIP  then        
        self.isupdate = true
    else
        self.isupdate = false
        self.curtimer = 0
        local BirdsAndBeastType = args.data
        if BirdsAndBeastType == nil then
            BirdsAndBeastType = self.data.rtype
        end
        if BirdsAndBeastType ~= BirdsAndBeastConfig.bab_jinsha then
            self.ratecont.transform:Find("Text").gameObject:GetComponent("Text").text = BirdsAndBeast_GameData.multiple_data[BirdsAndBeastType].rate        
        else 
            local va = 24 + math.ceil(math.random(0, 1) * math.random(0, 1) * 55 + math.random(0, 1) * 20)
            self.ratecont.transform:Find("Text").gameObject:GetComponent("Text").text = va 
        end        
    end
end

function BirdsAndBeast_PushMoney:pushMoneyHander(args)
    BirdsAndBeast_Socket.reqChipNormal(self.data.rtype, BirdsAndBeast_GameData.selectChoumNum)
    BirdsAndBeast_Socket.playaudio(BirdsAndBeastConfig["sound_xiazhu"], false)
end 

function BirdsAndBeast_PushMoney:RemoveEvent()
    BirdsAndBeastEvent.removeEvent(BirdsAndBeastEvent.mypushmoneychang, self.messkey)
end

function BirdsAndBeast_PushMoney:myPushChang(args)
    
    if self.data == nil or IsNil(self.per) then
        return
    end
    if args.data ~= nil and args.data ~= self.data.rtype then
        return
    end
 
    local BirdsAndBeastType = args.data
    if BirdsAndBeastType == nil then
        BirdsAndBeastType = self.data.rtype
    end
    if BirdsAndBeastType ~= nil then
        self.mypushcont.transform:Find("Text").gameObject:GetComponent("Text").text = BirdsAndBeast_GameData.pushmoney_data[BirdsAndBeastType]
    end
end

function BirdsAndBeast_PushMoney:rateChang(args)
    if self.data == nil or IsNil(self.per) then
        logYellow("空数据")
        return
    end
    if args.data ~= nil and args.data ~= self.data.rtype then
        logYellow("空数据2")
        return
    end
    self.anima:StopAndRevert()
    self.selectanima:StopAndRevert()
    local BirdsAndBeastType = args.data
    if BirdsAndBeastType == nil then
        BirdsAndBeastType = self.data.rtype
    end
    if BirdsAndBeastType ~= nil then
        if BirdsAndBeastType ~= BirdsAndBeastConfig.bab_jinsha then
            self.ratecont.transform:Find("Text").gameObject:GetComponent("Text").text = BirdsAndBeast_GameData.multiple_data[BirdsAndBeastType].rate        
        else 
            local va = 24 + math.ceil(math.random(0, 1) * math.random(0, 1) * 55 + math.random(0, 1) * 20)
            self.ratecont.transform:Find("Text").gameObject:GetComponent("Text").text = va 
        end
    end
end

function BirdsAndBeast_PushMoney:allPushChang(args)
    --error("___allPushChang_____"..self.messkey);
    if self.data == nil or IsNil(self.per) then
        return
    end
    if args.data ~= nil and args.data ~= self.data.rtype then
        return
    end
    local BirdsAndBeastType = args.data
    if BirdsAndBeastType == nil then
        BirdsAndBeastType = self.data.rtype
    end
    if BirdsAndBeastType ~= nil then
        self.allpushcont.transform:Find("Text").gameObject:GetComponent("Text").text = BirdsAndBeast_GameData.allpushmoney_data[BirdsAndBeastType]
    end
end

--ֻ�о�����ܵ��õ�
function BirdsAndBeast_PushMoney:update()
    if self.isupdate == false then
        return false
    end
    self.curtimer = self.curtimer + Time.deltaTime
    if self.curtimer > self.agetimer then
        self.curtimer = self.curtimer - self.agetimer
        local va = 24 + math.ceil(math.random(0, 1) * math.random(0, 1) * 55 + math.random(0, 1) * 20)
        self.ratecont.transform:Find("Text").gameObject:GetComponent("Text").text = va  
    end
end

-- ��������Img��ʾ����
function BirdsAndBeast_PushMoney:CreatShowNum(father, numstr, numpathstr)
    if IsNil(father) then
        return
    end
    if BirdsAndBeast_GameData.iconres == nil then
        return
    end
    numstr = unitPublic.showNumberText2(tonumber(numstr))
    local pointv = 0
    -- error("___CreatShowNum___"..numstr);
    local splen = father.transform.childCount
    local numlen = string.len(numstr)
    local alen = math.max(0, splen - numlen)
    if splen > numlen then
        for j = alen, 1, -1 do
            --destroy(father.transform:GetChild(j).gameObject);
            father.transform:GetChild(j - 1).gameObject:SetActive(false)
        end
    end
    for a = 1, numlen do
        if string.sub(numstr, a, a) == "." then
            pointv = 7
        end
    end
    local klx = 0
    local kw = 0
    for i = 1, string.len(numstr) do
        local prefebnum = string.sub(numstr, i, i)
        prefebnum = self:repaceNum(prefebnum)
        if kw ~= 0 then
            klx = kw
        end
        if prefebnum == 10 then
            --klx = klx - 8;
            kw = kw + 11
        else
            kw = kw + 18
        end
        if splen < i then
            local go2 =
                newobject(BirdsAndBeast_GameData.iconres.transform:Find(numpathstr .. "_" .. prefebnum).gameObject)
            go2.transform:SetParent(father.transform)
            go2.transform.localScale = Vector3.One()
            go2.transform.localPosition = Vector3.New(klx, 0, 0)
            go2.name = prefebnum
        else
            -- end
            -- if tonumber(prefebnum) ~= tonumber(father.transform:GetChild(i - 1).gameObject.name) then
            local itemobj = father.transform:GetChild(alen + i - 1).gameObject
            itemobj:SetActive(true)
            itemobj.name = prefebnum
            itemobj.transform.localPosition = Vector3.New(alen * 18 + pointv + klx, 0, 0)
            itemobj:GetComponent("Image").sprite =
                BirdsAndBeast_GameData.iconres.transform:Find(numpathstr .. "_" .. prefebnum).gameObject:GetComponent(
                "Image"
            ).sprite
            itemobj:GetComponent("Image"):SetNativeSize()
        end
    end
    --father.transform.localPosition = Vector3.New(-24+(65-kw)/2,father.transform.localPosition.y,0);
end

function BirdsAndBeast_PushMoney:repaceNum(args)
    if args == "." then
        return 10
    elseif args == "w" then
        return 11
    elseif args == "y" then
        return 12
    end
    return args
end

--������ʱ�� ��ע��ʾ����
function BirdsAndBeast_PushMoney:openPushchang(args)
    if self.data == nil or IsNil(self.per) then
        return
    end
    self.anima.fDelta = 0.0
    self.selectanima.fDelta = 0.0

    if args.data == self.data.rtype then
        self.anima:PlayAlways()
        self.selectanima:PlayAlways()
        return
    end
end
