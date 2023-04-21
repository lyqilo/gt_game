--个人界面加结算界面
BirdsAndBeast_MyInfo = {}
local self = BirdsAndBeast_MyInfo

self.per = nil
self.messkey = "0"
self.myallpushgoldnumcont = nil
self.myhandgold = nil
self.wincont = nil
self.winnumcont = nil
self.handGoldroll = nil
self.pushGoldroll = nil
self.winGoldroll = nil
self.curshowhandgold = 0
self.allpushmoney = 0
self.mynametxt = nil
function BirdsAndBeast_MyInfo.setPer(args, myper)
    self.per = args
    self.myallpushgoldnumcont = self.per.transform:Find("myallpushgoldnumcont")
    self.mynametxt = myper.transform:Find("mynametxt")
    self.myhandgold = myper.transform:Find("myglodnumcont")
    self.wincont = self.per.transform:Find("wincont")
    self.winnumcont = self.per.transform:Find("wincont/numcont")
    self.wincont.gameObject:SetActive(false)
     --TODO 设置头像
     if (SCPlayerInfo._02bySex == 1) then
        myper.transform:Find("Image"):GetComponent("Image").sprite = HallScenPanel.nanSprtie;
    else
        myper.transform:Find("Image"):GetComponent("Image").sprite = HallScenPanel.nvSprtie;
    end
    myper.transform:Find("Image"):GetComponent("Image").sprite = HallScenPanel.GetHeadIcon();
    self.handGoldroll = BirdsAndBeast_numRolling:New()
    self.pushGoldroll = BirdsAndBeast_numRolling:New()
    self.winGoldroll = BirdsAndBeast_numRolling:New()
    self.handGoldroll:setfun(self, self.handcom, self.handroll)
    self.pushGoldroll:setfun(self, self.mypushcom, self.mypushroll)
    self.winGoldroll:setfun(self, self.wincom, self.winroll)
    table.insert(BirdsAndBeast_GameData.numrollingcont, #BirdsAndBeast_GameData.numrollingcont + 1, self.handGoldroll)
    table.insert(BirdsAndBeast_GameData.numrollingcont, #BirdsAndBeast_GameData.numrollingcont + 1, self.pushGoldroll)
    table.insert(BirdsAndBeast_GameData.numrollingcont, #BirdsAndBeast_GameData.numrollingcont + 1, self.winGoldroll)
    self.messkey = BirdsAndBeastEvent.guid()
    self.AddEvent()
end

function BirdsAndBeast_MyInfo.shownum(spcont, num)
    if IsNil(self.per) then
        return
    end
    self.CreatShowNum(spcont, num, "num")
end

function BirdsAndBeast_MyInfo.handroll(tar, args)
    self.CreatShowNum(self.myhandgold, args, "num")
end

function BirdsAndBeast_MyInfo.handcom(tar, args)
    self.curshowhandgold = BirdsAndBeast_GameData.myinfoData._7wGold
    self.CreatShowNum(self.myhandgold, BirdsAndBeast_GameData.myinfoData._7wGold, "num")
end

function BirdsAndBeast_MyInfo.mypushroll(tar, args)
    jinandyinsha_PushFun.CreatShowNum(self.myallpushgoldnumcont, args, "num_", false, 10, 3, 220, 165, 0.6)
end

function BirdsAndBeast_MyInfo.mypushcom(tar, args)
    jinandyinsha_PushFun.CreatShowNum(self.myallpushgoldnumcont, 0, "num_", false, 10, 3, 220, 165, 0.6)
end

function BirdsAndBeast_MyInfo.winroll(tar, args)
    jinandyinsha_PushFun.CreatShowNum(self.winnumcont, args, "num_", false, 10, 3, 220, 270, 0.6)
end

function BirdsAndBeast_MyInfo.wincom(tar, args)
    jinandyinsha_PushFun.CreatShowNum(self.winnumcont, 0, "num_", false, 10, 3, 220, 270, 0.6)
    jinandyinsha_PushFun.CreatShowNum(self.myallpushgoldnumcont, 0, "num_", false, 10, 3, 220, 165, 0.6)
end

function BirdsAndBeast_MyInfo.AddEvent()
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.mypushmoneychang, self.mypushmoneychang, self.messkey)
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.myinfochang, self.myinfochang, self.messkey)
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.gamewinchang, self.gamewinchang, self.messkey)
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.startchip, self.startchip, self.messkey)
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.gameinit, self.gameinit, self.messkey)
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.exitgame, self.exitgame, self.messkey)
end

function BirdsAndBeast_MyInfo.exitgame(args)
    self.destroying()
end
function BirdsAndBeast_MyInfo.destroying()
    self.per = nil
    self.messkey = "0"
    self.myallpushgoldnumcont = nil
    self.myhandgold = nil
    self.wincont = nil
    self.winnumcont = nil
    self.handGoldroll = nil
    self.pushGoldroll = nil
    self.winGoldroll = nil
    self.curshowhandgold = 0
    self.allpushmoney = 0
    self.mynametxt = nil
end

function BirdsAndBeast_MyInfo.myinfochang(args)
    --logYellow("设置自己的金币信息1")
    --if BirdsAndBeast_GameData.gameState == BirdsAndBeast_CMD.D_GAME_STATE_NULL or BirdsAndBeast_GameData.gameState == BirdsAndBeast_CMD.D_GAME_STATE_CHIP or BirdsAndBeast_GameData.gameState == BirdsAndBeast_CMD.SUB_SC_GAME_WIN  then
        logYellow("设置自己的金币信息==="..BirdsAndBeast_GameData.myinfoData._7wGold)
        self.shownum(self.myhandgold, BirdsAndBeast_GameData.myinfoData._7wGold)
        self.curshowhandgold = BirdsAndBeast_GameData.myinfoData._7wGold
    --end
end

function BirdsAndBeast_MyInfo.loadhead(per)
    -- 初始化头像
    local UrlHeadImg
    local headstr
    if SCPlayerInfo._03bCustomHeader == 0 then
        UrlHeadImg =
            SCSystemInfo._2wWebServerAddress ..
            "/" .. SCSystemInfo._4wHeaderDir .. "/0" .. SCPlayerInfo._02bySex .. ".png"
        headstr = SCPlayerInfo._02bySex
    else
        UrlHeadImg =
            SCSystemInfo._2wWebServerAddress ..
            "/" ..
                SCSystemInfo._4wHeaderDir ..
                    "/" .. SCPlayerInfo._01dwUser_Id .. "." .. SCPlayerInfo._07wHeaderExtensionName
        headstr = SCPlayerInfo._01dwUser_Id .. "." .. SCPlayerInfo._07wHeaderExtensionName
    end

    --UpdateFile.downHead(UrlHeadImg,headstr,nil,per);
end

function BirdsAndBeast_MyInfo.gameinit(args)
    --error("____gameinit____");
    self.mynametxt.transform.gameObject:GetComponent("Text").text = BirdsAndBeast_GameData.myinfoData._2szNickName
end

function BirdsAndBeast_MyInfo.mypushmoneychang(args)
    self.allpushmoney = 0
    table.foreach(
        BirdsAndBeast_GameData.pushmoney_data,
        function(i, k)
            self.allpushmoney = self.allpushmoney + k
        end
    )
    jinandyinsha_PushFun.CreatShowNum(self.myallpushgoldnumcont, self.allpushmoney, "num_", false, 10, 3, 220, 165, 0.6)
    self.shownum(self.myallpushgoldnumcont,self.allpushmoney);
end

function BirdsAndBeast_MyInfo.gamewinchang(args)
    BirdsAndBeast_Socket.playaudio(BirdsAndBeastConfig.sound_jies, false)
    if BirdsAndBeast_GameData.wingold > 0 then
        self.wincont.gameObject:SetActive(true)
        jinandyinsha_PushFun.CreatShowNum( self.winnumcont,  BirdsAndBeast_GameData.wingold, "num_", false, 10, 3, 220, 270, 0.6 )
    else
        self.wincont.gameObject:SetActive(false)
    end
   
    if BirdsAndBeast_GameData.wingold > 0 then
        coroutine.start(
            function()
                coroutine.wait(2)
                 local target = BirdsAndBeast_GameData.myinfoData._7wGold - BirdsAndBeast_GameData.wingold;
                self.handGoldroll:setdata(target,BirdsAndBeast_GameData.myinfoData._7wGold, 1.5)
                self.winGoldroll:setdata(BirdsAndBeast_GameData.wingold,0, 1.5)
            end
        )
    end
end

function BirdsAndBeast_MyInfo.startchip(args)
    error("________BirdsAndBeast_MyInfo.startchip____________");
    self.wincont.gameObject:SetActive(false)
    -- BirdsAndBeast_Socket.playaudio(BirdsAndBeastConfig.sound_xiazhustart,false);
    --error("___11_____BirdsAndBeast_MyInfo.startchip____________");
end

function BirdsAndBeast_MyInfo.RemoveEvent()
end

-- 创建数字Img显示对象
function BirdsAndBeast_MyInfo.CreatShowNum(father, getnumstr, numpathstr)
    -- numstr = unitPublic.showNumberText2(tonumber(numstr));
    --error("___CreatShowNum___"..numstr);
    if IsNil(father) then
        return
    end
    if BirdsAndBeast_GameData.iconres == nil then
        return
    end
    local numstr = tostring(getnumstr)
    local splen = father.transform.childCount
    local numlen = string.len(numstr)
    --local alen =  math.max(0,splen-numlen);
    if splen > numlen then
        for j = numlen, splen - 1 do
            --destroy(father.transform:GetChild(j).gameObject);
            father.transform:GetChild(j).gameObject:SetActive(false)
        end
    end
    local klx = 0
    local kw = 0
    for i = 1, string.len(numstr) do
        local prefebnum = string.sub(numstr, i, i)
        prefebnum = self.repaceNum(prefebnum)
        if kw ~= 0 then
            klx = kw
        end
        if prefebnum == 10 then
            --klx = klx - 8;
            kw = kw + 14
        else
            kw = kw + 42
        end
        if splen < i then
            local go2 =
                newobject(BirdsAndBeast_GameData.iconres.transform:Find(numpathstr .. "_" .. prefebnum).gameObject)
            go2.transform:SetParent(father.transform)
            go2.transform.localScale = Vector3.New(1, 1, 1)
            go2.transform.localPosition = Vector3.New(klx, 0, 0)
            go2.name = prefebnum
        else
            -- end
            -- if tonumber(prefebnum) ~= tonumber(father.transform:GetChild(i - 1).gameObject.name) then
            local itemobj = father.transform:GetChild(i - 1).gameObject
            itemobj:SetActive(true)
            itemobj.name = prefebnum
            --itemobj.transform.localPosition = Vector3.New(klx, 0, 0);
            itemobj:GetComponent("Image").sprite =
                BirdsAndBeast_GameData.iconres.transform:Find(numpathstr .. "_" .. prefebnum).gameObject:GetComponent(
                "Image"
            ).sprite
            itemobj:GetComponent("Image"):SetNativeSize()
        end
    end
end

function BirdsAndBeast_MyInfo.repaceNum(args)
    if args == "." then
        return 10
    elseif args == "w" then
        return 11
    elseif args == "y" then
        return 12
    end
    return args
end
