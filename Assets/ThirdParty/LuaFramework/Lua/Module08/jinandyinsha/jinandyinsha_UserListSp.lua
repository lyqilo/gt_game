jinandyinsha_UserListSp = {}
local self = jinandyinsha_UserListSp

function jinandyinsha_UserListSp.init()
    self.myper = nil
    self.userinfoitem = nil
    self.scrollview = nil
    self.scrollviewstartpoint = nil
    self.scrollviewendpoint = nil
    self.itemsy = 10
    self.itemcount = 0
    self.messkey = BirdsAndBeastEvent.guid()
    self.zhedan = nil
    self.headDefalutSp = nil
    self.headMemTabel = {}
    self.userList = {}
end
function jinandyinsha_UserListSp.setper(args)
    self.init()
    self.myper = args
    self.userinfoitem = args.transform:Find("useritem")
    --self.headDefalutSp = self.userinfoitem.transform:Find("Image").transform:GetComponent('Image').sprite;
    self.parentinfoitem = self.myper.transform:Find("ScrollView/Viewport/Content")
    local com = self.parentinfoitem.gameObject:AddComponent(typeof(UnityEngine.UI.GridLayoutGroup))
    com.cellSize = Vector2.New(324, 100)
    self.scrollview = self.myper.transform:Find("ScrollView")
    self.zhedan = self.myper.transform:Find("zhedan")
    self.zhedan.gameObject:SetActive(false)
    self.AddEvent()
end

function jinandyinsha_UserListSp.AddEvent(args)
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.reflushuserlist, self.reflush, self.messkey)
    BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.startchip, self.startChip, self.messkey)
end

function jinandyinsha_UserListSp.startChip(args)
    self.zhedan.gameObject:SetActive(false)
end

function jinandyinsha_UserListSp.UserJoin(args)
    local obj = newobject(self.userinfoitem)
    obj.transform:SetParent(self.parentinfoitem.transform)
    obj.transform.localScale = Vector3.New(1, 1, 1)
    obj.transform.localPosition = Vector3.New(0, 0, 0)
    self.SetUserInfo(args,obj);
    local userUnit = {
        data = args,
        objUnit = obj
    }
    table.insert(self.userList, userUnit)
    self.parentinfoitem.sizeDelta = Vector2.New(self.parentinfoitem.sizeDelta.x,#self.userList*100);
    self.SortUserList();
end

function jinandyinsha_UserListSp.SetUserInfo(args,obj)
    obj.transform:Find("name").transform:GetComponent("Text").text = args._2szNickName
    self.CreatShowNum(obj.transform:Find("numcont"), args._7wGold, "num")
    --TODO 设置头像
    if (args._3bySex == 1) then
        obj.transform:Find("Image"):GetComponent("Image").sprite = HallScenPanel.nanSprtie
    else
        obj.transform:Find("Image"):GetComponent("Image").sprite = HallScenPanel.nvSprtie
    end
    local index = math.random(1, 10);
    obj.transform:Find("Image"):GetComponent("Image").sprite = HallScenPanel.headIcons.transform:GetChild(index - 1):GetComponent("Image").sprite;
    obj.transform:Find("Image").gameObject:SetActive(true)
end

function jinandyinsha_UserListSp.UserLeva(args)
    logYellow("玩家："..args.."离开了");
    for i=1,#self.userList do
        if (self.userList[i].data._1dwUser_Id == args) then
            logYellow("删除玩家物体："..self.userList[i].objUnit.name);
            destroy(self.userList[i].objUnit.gameObject);
            table.remove(self.userList,i);
        end
    end
    self.SortUserList();
end

function jinandyinsha_UserListSp.reflushall(args)
    for i = 1, #self.userList do
        self.SetUserInfo(self.userList[i].data,self.userList[i].objUnit);
    end
    self.SortUserList();
end
function jinandyinsha_UserListSp.reflush(args)
    for i = 1, #self.userList do
        if (args._1dwUser_Id == self.userList[i].data._1dwUser_Id) then
            self.userList[i].data._7wGold = args._7wGold;
            self.SetUserInfo(args,self.userList[i].objUnit);
        end
    end
    self.SortUserList();
end

function jinandyinsha_UserListSp.JianUserGold(args_site,gold)
    for i = 1, #self.userList do
        if (args_site == self.userList[i].data._9wChairID) then
            self.userList[i].data._7wGold =  self.userList[i].data._7wGold - gold;
            self.SetUserInfo( self.userList[i].data,self.userList[i].objUnit);
        end
    end
    --self.SortUserList();
end
function jinandyinsha_UserListSp.SortUserList()
    table.sort( self.userList, function(a ,b) return a.data._7wGold > b.data._7wGold end );

    for i = 1, #self.userList do
        self.userList[i].objUnit.transform:SetSiblingIndex(i);
    end
end

function jinandyinsha_UserListSp.loadhead(tableinfo, per)
    -- ��ʼ��ͷ��
    local UrlHeadImg
    local headstr
    if tableinfo._4bCustomHeader == 0 then
        UrlHeadImg =
            SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/0" .. tableinfo._3bySex .. ".png"
        headstr = tableinfo._3bySex
    else
        UrlHeadImg =
            SCSystemInfo._2wWebServerAddress ..
            "/" .. SCSystemInfo._4wHeaderDir .. "/" .. tableinfo._1dwUser_Id .. "." .. tableinfo._5szHeaderExtensionName
        headstr = tableinfo._1dwUser_Id .. "." .. tableinfo._5szHeaderExtensionName
    end
    if self.headMemTabel[headstr] ~= nil then
        per.transform:GetComponent("Image").sprite = self.headMemTabel[headstr]
    else
        UpdateFile.downHead(
            UrlHeadImg,
            headstr,
            function(isucc, spr)
                local imgname = headstr
                if isucc == true then
                    self.headMemTabel[imgname] = spr
                end
            end,
            per
        )
    end
end

function jinandyinsha_UserListSp.setContH()
    local ressize = self.parentinfoitem.transform:GetComponent("RectTransform").sizeDelta
    self.parentinfoitem.transform:GetComponent("RectTransform").sizeDelta =
        Vector2.New(ressize.x, (self.itemcount + 1) * 90 + 90)
    self.parentinfoitem.transform.localPosition = Vector3.New(0, 0, 0)

end

function jinandyinsha_UserListSp.CreatShowNum(father, numstr, numpathstr)
    if IsNil(father) then
        return
    end
    local splen = father.transform.childCount
    local numlen = string.len(numstr)
    if splen > numlen then
        for j = numlen, splen - 1 do
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
            local itemobj = father.transform:GetChild(i - 1).gameObject
            itemobj:SetActive(true)
            itemobj.name = prefebnum
            itemobj:GetComponent("Image").sprite =
                BirdsAndBeast_GameData.iconres.transform:Find(numpathstr .. "_" .. prefebnum).gameObject:GetComponent(
                "Image"
            ).sprite
            itemobj:GetComponent("Image"):SetNativeSize()
        end
    end
    local sy = father.transform.localPosition.y
    father.transform.localPosition = Vector3.New(120, sy, 0)
end

function jinandyinsha_UserListSp.repaceNum(args)
    if args == "." then
        return 10
    elseif args == "w" then
        return 11
    elseif args == "y" then
        return 12
    end
    return args
end
