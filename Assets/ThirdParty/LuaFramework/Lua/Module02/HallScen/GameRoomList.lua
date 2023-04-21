GameRoomList = {}
local self = GameRoomList
local _LuaBeHaviour = nil
local roomObj = nil
local SvaegameName = nil
local needgold = 0
local froom = {}
local bjlbg = nil
local bjlitem = nil
local bjlRoomNum = nil

local gameRoom = {}
local gameid = 0
self.roomdata = {};

UnLoadGameTable = {}

--[[   gameid=33 
房间信息：gameRoom    self.ChooseGame="水浒传"  SvaegameName=self.ChooseGame="水浒传"
    ["_1byFloorID"] = 1;
    ["_2wGameID"] = 33;
    ["_3wRoomID"] = 1;
    ["_4dwServerAddr"] = 2668275904;	
    ["_5wServerPort"] = 29590;
    ["_6iLessGold"] = 0;
    ["_7dwOnLineCount"] = 0;
    ["_8NameLenght"] = 32;
    ["_9Name"] = "水浒传-初级";
--]]
local enterMoney = {
    [1] = 5000,
    [2] = 50000,
    [3] = 200000,
    [4] = 1000000,
    [5] = 5000000,
}
-- ===========================================房间选择系统======================================
function GameRoomList.Open(id)
    self.roomConfig = GameManager.PassClientIndexToConfiger(id);
    local name = self.roomConfig.uiName;
    log(string.format("打开 %s 房间列表", name))
    HallScenPanel.SetBtnInter(false)
    gameRoom = {}
    --HallScenPanel.backhallBtn.transform:GetComponent("Button").interactable = true
    if HallScenPanel.MidCloseBtn ~= nil then
        HallScenPanel.MidCloseBtn()
        HallScenPanel.MidCloseBtn = nil
    end

    logErrorTable(AllSCGameRoom)
    local _id = id;
    if _id == 51 then
        _id = 21;
    elseif _id == 24 then
        _id = 8;
    elseif _id == 8 then
        _id = 9;
    end
    for i = 1, #AllSCGameRoom do
        --if (string.find(AllSCGameRoom[i]._9Name, name)) ~= nil then
        --    table.insert(gameRoom, AllSCGameRoom[i])
        --    gameid = AllSCGameRoom[i]._2wGameID
        --end

        if _id == AllSCGameRoom[i]._2wGameID then
            table.insert(gameRoom, AllSCGameRoom[i])
            gameid = AllSCGameRoom[i]._2wGameID
        end
    end
    -- logError(#gameRoom)
    if not GameManager.isLoadGameList then
        HallScenPanel.SetBtnInter(true)
        MessageBox.CreatGeneralTipsPanel("请检查网络正常")
        return
    end
    if (#gameRoom == 0) then
        HallScenPanel.SetBtnInter(true)
        MessageBox.CreatGeneralTipsPanel("当前房间未开放，尽请期待")
        return
    end
    logTable(gameRoom)
    self.ChooseGame = name
    if self.GameRoomListPanel == nil then
        self.GameRoomListPanel = "obj"
        self.OnCreacterChildPanel_Room(HallScenPanel.Pool("GameRoomListPanel"))
    else
        self.showRoomImg(name)
    end
end

function GameRoomList.showRoomImg(args)
    self.GameRoomListPanel.transform:Find("Bg/Main/Consel/MainInfo").gameObject:SetActive(true)
    self.GameRoomListPanel.transform:Find("Bg/Main/Consel/MainInfo2").gameObject:SetActive(false)

    bjlbg = self.GameRoomListPanel.transform:Find("Bg/Main/Consel/baijlbg").gameObject
    bjlitem = self.GameRoomListPanel.transform:Find("Bg/Main/Consel/baijlitem").gameObject
    bjlRoomNum = self.GameRoomListPanel.transform:Find("Bg/Main/Consel/baijlnum").gameObject
end

-- 创建UI的子面板_房间列表
function GameRoomList.OnCreacterChildPanel_Room(prefab)
    HallScenPanel.SetGW(false)
    logYellow("=========OnCreacterChildPanel_Room==========")
    local IMGResolution = prefab.transform:GetComponent("IMGResolution")
    if IMGResolution == nil then
        Util.AddComponent("IMGResolution", prefab)
    end

    local go = prefab.transform:GetChild(0)
    self.GameRoomListPanel = go
    self.GameRoomListPanel.gameObject:SetActive(true)

    self.showRoomImg(self.ChooseGame)
    logYellow("000000000000000000000000000000s")
    go.transform.parent:SetParent(HallScenPanel.Compose.transform)
    --go.name = "GameRoomListPanel"
    go.transform.parent.localScale = Vector3.New(1, 1, 1)
    --go.transform:Getchild(0).localScale = Vector3.New(GameManager.ScreenRate, GameManager.ScreenRate, GameManager.ScreenRate)

    go.transform.parent.localPosition = Vector3.New(0, 0, 0)
    self.GameRoomListPanel.transform:GetComponent("RectTransform").sizeDelta = Vector2.New(1334, Screen.height / Screen.width * 1334);
    self.Bg = go.transform:Find("Bg").gameObject
    --self.Bg.transform.localScale = Vector3.New(1, 1, 1)
    self.Bg.transform.localScale = Vector3.New(GameManager.ScreenRate, GameManager.ScreenRate, GameManager.ScreenRate)
    --go.transform:Find("Head").localScale=Vector3.New(GameManager.ScreenRate, GameManager.ScreenRate, GameManager.ScreenRate)

    HallScenPanel.LastPanel = self.GameRoomListPanel
    HallScenPanel.SetXiaoGuo(self.GameRoomListPanel)
    GameRoomList.Init(self.GameRoomListPanel, HallScenPanel.LuaBehaviour)
    GameRoomList.ShowPanel()
    go = nil
    HallScenPanel.SetBtnInter(true)
    HallScenPanel.MidCloseBtn = self.ClosePanelBtnOnClick
end

function GameRoomList.Init(obj, luaBeHaviour)
    local t = obj.transform
    _LuaBeHaviour = luaBeHaviour
    self.GameRoomList = obj

    --1.数字图片父节点
    self.ShowNum = t:Find("Num").gameObject
    self.ShowNum:SetActive(false)
    --2.关闭界面按钮对象（空对象）
    self.ClosePanelBtn = t:Find("CloseBtn").gameObject
    --3.HeadInfo  空对象
    self.HeadText = t:Find("HeadInfo").gameObject
    self.HeadText:SetActive(false)
    --4.界面Content根节点
    self.FirstBg = t:Find("Bg").gameObject
    --5.界面Main节点
    self.MianLen = t:Find("Bg/Main").gameObject
    logError(self.MianLen.name)

    local panel = t:Find("Bg/Main/Panel").gameObject
    destroy(panel)

    --6.界面图标节点
    self.MainPos = t:Find("Bg/Main/Consel").gameObject

    self.DownPanel = t:Find("DownPanel")
    self.DownPanelBFtext = self.DownPanel:Find("mainPanel/Image/Text")
    self.DownPanelBF = self.DownPanel:Find("mainPanel/Image/Image/Image")
    self.DownPanel.gameObject:SetActive(false)
    --MainInfo2 是百家乐用的
    -- if (string.find(self.ChooseGame, "免佣百家乐")) ~= nil then
    --     self.MainInfo = t:Find("Bg/Main/Consel/MainInfo2").gameObject;
    -- else
    self.MainInfo = t:Find("Bg/Main/Consel/MainInfo").gameObject
    -- end

    --User对象
    self.User = t:Find("Bg/Main/User").gameObject
    --顶上那个游戏名字：水浒传
    self.GameName = t:Find("Bg/Head/GameName").gameObject
    self.GameNameImg = t:Find("Bg/Head/RoomName/Image"):GetComponent("Image")
    self.gameNamePool = t:Find("RoomNameImg");

    luaBeHaviour:AddClick(self.ClosePanelBtn, self.ClosePanelBtnOnClick)

    if not (gameIsOnline) then
        self.User:SetActive(gameIsOnline)
        self.MainPos.transform.localPosition = Vector3.New(0, 0, 0)
        return
    end
    self.R_scroolRect_listerner = Util.AddComponent("EventTriggerListener", self.FirstBg)
    --self.R_scroolRect_listerner = self.FirstBg:GetComponent("EventTriggerListener")
    self.R_scroolRect_listerner.onBeginDrag = self.RoomBeginDrag
    self.R_scroolRect_listerner.onDrag = self.RoomDrag
    self.R_scroolRect_listerner.onEndDrag = self.onendDrag
end

----隐藏和显示一个transform
function GameRoomList.ShowPanel()
    logError("____GameRoomList.ShowPanel______" .. self.ChooseGame)
    SvaegameName = self.ChooseGame
    for i = 0, self.HeadText.transform.childCount - 1 do
        self.HeadText.transform:GetChild(i).gameObject:SetActive(false)
    end
    self.GameName:GetComponent("Text").text = SvaegameName

    log(tostring(self.gameNamePool == nil))

    self.GameNameImg.sprite = self.gameNamePool:Find(self.roomConfig.scenName):GetComponent("Image").sprite;
    self.GameNameImg:SetNativeSize();
    log(1111111)
    local t = self.GameRoomListPanel.transform

    --把floor提到上层
    self.panelIndex = t.transform:GetSiblingIndex()
    --HallScenPanel.floor.transform:SetSiblingIndex(self.panelIndex + 1)

    local lennum = math.ceil(#gameRoom / 2)
    if (#gameRoom == 0) then
        self.ClosePanelBtnOnClick()
    else
        local gameRoomName = nil
        local gameRoomGold = nil
        local gameRoomBL = nil
        table.sort(
                gameRoom,
                function(a, b)
                    return a._6iLessGold < b._6iLessGold
                end
        )
        --       local newgameroom = { };

        for n = 0, self.MainInfo.transform.childCount - 1 do
            self.MainInfo.transform:GetChild(n).gameObject:SetActive(false)
        end

        local roomname = { "初级", "中级", "高级", "专家", "大师", "至尊" }
        -- local roomname = { "普通", "土豪", "贵宾", "至尊" }
        local logs = ""
        for i = 1, #gameRoom do
            gameRoomName = (string.split(gameRoom[i]._9Name, "-"))[2]
            logs = logs .. " " .. gameRoomName
            local n = 0
            for j = 1, #roomname do
                if string.find(gameRoomName, roomname[j]) then
                    n = j
                end
            end
            local _id = gameRoom[i]._2wGameID;
            if _id == 21 then
                _id = 51;
            elseif _id == 8 then
                _id = 24;
            elseif _id == 9 then
                _id = 8;
            end
            gameRoom[i]._10BL = GameManager.PassClientIndexToConfiger(_id).BL[i]
            self.SetGameRoom(gameRoomName, gameRoom[i]._6iLessGold, gameRoom[i]._10BL, i, n)
            --self.SetGameRoom(gameRoomName, enterMoney[n], gameRoom[i]._10BL, i, n)

        end
        log("显示房间列表:" .. logs)
    end

    HallScenPanel.isCreatIngRoom = false
    local oldpos = self.User.transform.localPosition
    local oldsize = self.User.transform:GetComponent("RectTransform").sizeDelta

    --[[    GameRoomUserList.setgameid(self.ChooseGame)

    local num =HallScenPanel.GetShowRankNum();
    if num == 0 then return end
    if not gameIsOnline then return end
    self.User.transform:GetComponent('RectTransform').sizeDelta = Vector2.New(750,(945 - 200 *(lennum)))
    self.User.transform.localPosition = Vector3.New(oldpos.x,(-200 *(lennum)) / 2, oldpos.z)
    self.User:SetActive(gameIsOnline);
    if gameIsOnline then
        GameRoomUserList.setPoint(0, 0);
        GameRoomUserList.setShowContWH(750,(945 - 200 *(lennum)));
        GameRoomUserList.shownum(16);
        GameRoomUserList.setdata(self.User, "aaaaa", _LuaBeHaviour);
    end--]]
end

function GameRoomList.SetGameRoom(name, gold, BL, index, i)
    if i > self.MainInfo.transform.childCount then
        return
    end
    if BL == nil then
        BL = 0
    end
    local go = self.MainInfo.transform:GetChild(i - 1).gameObject
    go:SetActive(true)

    -- if (string.find(self.ChooseGame, "百家乐")) ~= nil then
    --     local desTable = string.split(tostring(BL), "_");
    --     go.transform:Find("TiaoJian").gameObject:GetComponent('Text').text = unitPublic.showNumberText(desTable[1]);
    --     go.transform:Find("TiaoJianTwo").gameObject:GetComponent('Text').text = unitPublic.showNumberText(gold);
    --     if desTable[2] == "0" then
    --         go.transform:Find("jinm").gameObject:SetActive(false);
    --     end
    -- else

    local father = go.transform:Find("TiaoJian")
    father:GetComponent("Text").text = "倍率 " .. tostring(BL);
    --local str1 = tostring(BL)
    --for j = 1, string.len(str1) do
    --    local prefebnum = string.sub(BL, j, j)
    --    if tonumber(prefebnum) == nil then
    --        prefebnum = 11
    --    end
    --    local go = newobject(self.ShowNum.transform:GetChild(prefebnum).gameObject)
    --    go.transform:SetParent(father)
    --    go.transform.localScale = Vector3.one
    --    go.transform.localPosition = Vector3.New(0, 0, 0)
    --end

    local father = go.transform:Find("TiaoJianTwo")

    local str2 = unitPublic.showNumberText(gold)
    father:GetComponent("Text").text = "准入 " .. str2;
    --local numlen = string.len(str2)
    --if string.find(str2, "万") then
    --    numlen = string.find(str2, "万")
    --end
    --for j = 1, numlen do
    --    local prefebnum = string.sub(str2, j, j)
    --    if tonumber(prefebnum) == nil then
    --        prefebnum = 10
    --    end
    --    local go = newobject(self.ShowNum.transform:GetChild(prefebnum).gameObject)
    --    go.transform:SetParent(father)
    --    go.transform.localScale = Vector3.one
    --    go.transform.localPosition = Vector3.New(0, 0, 0)
    --end

    -- end
    go.name = name .. "-" .. gold .. "-" .. tostring(index)
    _LuaBeHaviour:AddClick(go, self.StartRoomOnClick)
end

-- 开始滑动
function GameRoomList.RoomBeginDrag()
    startposy = self.MianLen.transform.localPosition.y
    self.wh = (self.MianLen.transform:GetComponent("RectTransform").sizeDelta.y -
            self.FirstBg.transform:GetComponent("RectTransform").sizeDelta.y) /
            2
end

-- 滑动中
function GameRoomList.RoomDrag()
    if gameIsOnline then
        if GameRoomUserList.isreqdata == false and self.MianLen.transform.localPosition.y > startposy then
            if (self.wh - self.MianLen.transform.localPosition.y) < 100 then
                GameRoomUserList.addpage = 1
                GameRoomUserList.requserdata()
            end
        end
    end
end

function GameRoomList.onendDrag(args)
end

function GameRoomList.SetObjPos(num)
    local firstbgsizeDelta = self.FirstBg.transform:GetComponent("RectTransform").sizeDelta
    local oldpos = self.User.transform.localPosition
    local oldsize = self.User.transform:GetComponent("RectTransform").sizeDelta
    local userH = num
    local lennum = math.ceil(#gameRoom / 2)
    local mainy = userH + 200 * (lennum)

    self.MianLen.transform:GetComponent("RectTransform").sizeDelta = Vector2.New(750, mainy)
    if num < 1800 then
        self.MianLen.transform.localPosition = Vector3.New(0, (firstbgsizeDelta.y - mainy) / 2, 0)
    end
    self.MainPos.transform.localPosition = Vector3.New(0, (mainy - 600) / 2, 0)
    self.User.transform:GetComponent("RectTransform").sizeDelta = Vector2.New(750, num)
    self.User.transform.localPosition = Vector3.New(oldpos.x, -(200 * lennum) / 2, oldpos.z)
end

function GameRoomList.CreaterGameRoom(obj)
    roomObj = obj
end

-- 关闭面板
function GameRoomList.ClosePanelBtnOnClick()
    HallScenPanel.PlayeBtnMusic()
    HallScenPanel.SetGW(true)
   -- HallScenPanel.ExitGameBtn.gameObject:SetActive(true);
    --  self.UnloadOther();
    self.GameRoomList.transform.localPosition = Vector3.New(0, 1000, 0)
    HallScenPanel.isCreatIngRoom = false
    froom = {}
    GameRoomUserList.destory()
    destroy(self.GameRoomListPanel.parent.gameObject)
    self.GameRoomListPanel = nil
    HallScenPanel.MidCloseBtn = nil;
    HallScenPanel.BackHallOnClick();
    --163 489 815 1141
    -- 325  324  
end

-- 进入房间按钮
function GameRoomList.StartRoomOnClick(obj)
    local gid = gameid;
    if gid == 21 then
        gid = 51;
    elseif gid == 8 then
        gid = 24;
    elseif gid == 9 then
        gid = 8;
    end
    local t = GameManager.PassClientIndexToConfiger(gid);
    SvaegameName = self.ChooseGame
    logError("准备进入游戏服务器: " .. SvaegameName)
    obj:GetComponent("Button").interactable = false
    local str = obj.transform:Find("TiaoJianTwo"):GetComponent("Text").text
    local data = string.split(obj.name, "-")
    --needgold = toInt64(data[2])
    needgold = toInt64(gameRoom[tonumber(data[3])]._6iLessGold);

    if toInt64(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD)) >= needgold then
        logError("满足条件，准备进入游戏")
        local str = SvaegameName
        if SvaegameName == gameServerName.vip then
            str = SvaegameName .. "-" .. froom[data[1]]["title"]
            local scencename = self.getScenname(data[1])
            if scencename ~= nil then
                GameNextScenName = scencename
            end
        else
            str = SvaegameName .. "-" .. data[1]
            GameNextScenName = t.scenName
            log("next module name: " .. GameNextScenName)
            if GameNextScenName == nil then
                self.ClosePanelBtnOnClick()
                return
            end
        end
        logTable(gameRoom[tonumber(data[3])])
        self.roomdata = gameRoom[tonumber(data[3])];
        if HallScenPanel.isReconnectGame then
            if HallScenPanel.reconnectRoomInfo == nil then
                for i = 1, #AllSCGameRoom do
                    if AllSCGameRoom[i]._2wGameID == SCPlayerInfo._36ReconnectGameID and AllSCGameRoom[i]._1byFloorID == SCPlayerInfo._37ReconnectFloorID then
                        HallScenPanel.reconnectRoomInfo = AllSCGameRoom[i];
                        break ;
                    end
                end
            end
            if self.roomdata._2wGameID ~= HallScenPanel.reconnectRoomInfo._2wGameID or self.roomdata._1byFloorID ~= HallScenPanel.reconnectRoomInfo._1byFloorID then
                local pop = FramePopoutCompent.Pop.New()
                pop._02conten = "您还有游戏未结束！"
                pop._99last = true
                pop._05yesBtnCallFunc = function()
                    if toInt64(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD)) >= toInt64(HallScenPanel.reconnectRoomInfo._6iLessGold) then
                        local _id = HallScenPanel.reconnectRoomInfo._2wGameID;
                        if _id == 21 then
                            _id = 51;
                        elseif _id == 8 then
                            _id = 24;
                        elseif _id == 9 then
                            _id = 8;
                        end
                        local _t = GameManager.PassClientIndexToConfiger(_id);
                        GameNextScenName = _t.scenName;
                        HallScenPanel.LoadGame(HallScenPanel.reconnectRoomInfo);
                    else
                        MessageBox.CreatGeneralTipsPanel("Your gold coins are insufficient, please recharge")
                    end
                end
                pop.isBig = true;
                FramePopoutCompent.Add(pop)
                obj:GetComponent("Button").interactable = true
                return ;
            else
                HallScenPanel.LoadGame(HallScenPanel.reconnectRoomInfo);
            end
        else
            local buffer = ByteBuffer.New();
            Network.Send(MH.MDM_3D_ASSIST, MH.SUB_3D_CS_QUERY_IS_CAN_LOGIN, buffer, gameSocketNumber.HallSocket);
        end
    else
        MessageBox.CreatGeneralTipsPanel("Your gold coins are insufficient, please recharge")
        obj:GetComponent("Button").interactable = true
    end
    obj:GetComponent("Button").interactable = true
end

function GameRoomList.UnloadOther()
    -- 进入其他游戏才释放资源
    if SvaegameName == nil then
        return
    end
    if #UnLoadGameTable == 0 then
        table.insert(UnLoadGameTable, SvaegameName)
    end
    if #UnLoadGameTable > 0 then
        if UnLoadGameTable[1] == SvaegameName then
        end
        -- 释放资源
        if UnLoadGameTable[1] ~= SvaegameName then
            for i = 2, #UnLoadGameTable do
                Unload(UnLoadGameTable[i], true)
                --  error("释放资源=====================" .. UnLoadGameTable[i]);
            end
            UnLoadGameTable = {}
            table.insert(UnLoadGameTable, SvaegameName)
        end
    end
end

function GameRoomList.getScenname(gameName)
    local configer = GameManager.PassGameNameToConfiger(gameName)
    return configer.scenName
end

-- 创建游戏房间玩家列表
function GameRoomList.CreatUserRoom()
end

-- 发送需要查询得玩家信息
function GameRoomList.SeedUser()
end

local roomData = {}
-- 开始接受数据
function GameRoomList.startGetRoomData(wSubID, buffer, wSize)
    roomData = {}
end

-- 接受数据中
function GameRoomList.getIngRoomData(wSubID, buffer, wSize)
    logYellow("11111111")
    local gameid = buffer:ReadUInt32();
    local floorid = buffer:ReadUInt32();
    gameid = math.floor((gameid % 1000) / 10);

    HallScenPanel.reconnectRoomInfo = nil;
    for i = 1, #AllSCGameRoom do
        if AllSCGameRoom[i]._2wGameID == gameid and AllSCGameRoom[i]._1byFloorID == floorid then
            HallScenPanel.reconnectRoomInfo = AllSCGameRoom[i];
            break ;
        end
    end
    if HallScenPanel.reconnectRoomInfo == nil or (HallScenPanel.reconnectRoomInfo._2wGameID == 0 and HallScenPanel.reconnectRoomInfo._1byFloorID == 0) then
        HallScenPanel.LoadGame(self.roomdata);
        return ;
    end
    logYellow("_2wGameID==" .. HallScenPanel.reconnectRoomInfo._2wGameID)
    logYellow("_1byFloorID==" .. HallScenPanel.reconnectRoomInfo._1byFloorID)
    if self.roomdata._2wGameID ~= HallScenPanel.reconnectRoomInfo._2wGameID or self.roomdata._1byFloorID ~= HallScenPanel.reconnectRoomInfo._1byFloorID then
        local pop = FramePopoutCompent.Pop.New()
        pop._02conten = "您还有游戏未结束！"
        pop._99last = true
        pop._05yesBtnCallFunc = function()
            if toInt64(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD)) >= toInt64(HallScenPanel.reconnectRoomInfo._6iLessGold) then
                local _id = HallScenPanel.reconnectRoomInfo._2wGameID;
                if _id == 21 then
                    _id = 51;
                elseif _id == 8 then
                    _id = 24;
                elseif _id == 9 then
                    _id = 8;
                end
                local _t = GameManager.PassClientIndexToConfiger(_id);
                GameNextScenName = _t.scenName;
                HallScenPanel.LoadGame(HallScenPanel.reconnectRoomInfo);
            else
                MessageBox.CreatGeneralTipsPanel("Your gold coins are insufficient, please recharge")
            end
        end
        pop.isBig = true;
        FramePopoutCompent.Add(pop)
        obj:GetComponent("Button").interactable = true
        return ;
    end
    log(self.roomdata._2wGameID .. "|" .. HallScenPanel.reconnectRoomInfo._2wGameID .. "|" .. self.roomdata._1byFloorID .. "|" .. HallScenPanel.reconnectRoomInfo._1byFloorID)
    HallScenPanel.LoadGame(self.roomdata);
end

-- 接受完成
function GameRoomList.endGetRoomData(wSubID, buffer, wSize)
    if self.GameRoomListPanel == nil then
        return
    end
    if (string.find(self.ChooseGame, "百家乐")) == nil then
        return
    end
    local roomtabel = nil
    local findex = 0
    local gameRoom = {}
    for a = 1, #AllSCGameRoom do
        if (string.find(AllSCGameRoom[a]._9Name, self.ChooseGame)) ~= nil then
            table.insert(gameRoom, AllSCGameRoom[a])
        end
    end
    if #gameRoom == 0 then
        return
    end
    table.sort(
            gameRoom,
            function(a, b)
                return a._6iLessGold < b._6iLessGold
            end
    )
    for i = 1, #gameRoom do
        roomtabel = self.getRoomTabel(gameRoom[i]._5wServerPort)
        if roomtabel ~= nil then
            self.setRoomTabel(findex, roomtabel)
            findex = findex + 1
        end
    end
end

function GameRoomList.setRoomTabel(findex, roomtable)
    if self.GameRoomListPanel == nil then
        return
    end
    local ftabel = roomtable.hisdata
    local len = #ftabel
    local roomcont = self.GameRoomListPanel.transform:Find("Bg/Main/Consel/MainInfo2").transform:GetChild(findex)
    local itemcont = roomcont.transform:Find("imgcont")
    local newitem = nil
    local zhuan = 0
    local xian = 0
    local he = 0
    for i = 1, len do
        newitem = newobject(bjlitem)
        newitem.transform:SetParent(itemcont.transform)
        newitem.transform.localPosition = Vector3.New(0, 0, 0)
        newitem.transform.localScale = Vector3.New(1, 1, 1)
        if ftabel[i].bankpoint > ftabel[i].playpoint then
            newitem.transform:Find("bg").gameObject:GetComponent("Image").sprite = bjlbg.transform:Find("bg1").gameObject:GetComponent("Image").sprite
            zhuan = zhuan + 1
        elseif ftabel[i].playpoint > ftabel[i].bankpoint then
            newitem.transform:Find("bg").gameObject:GetComponent("Image").sprite = bjlbg.transform:Find("bg2").gameObject:GetComponent("Image").sprite
            xian = xian + 1
        else
            newitem.transform:Find("bg").gameObject:GetComponent("Image").sprite = bjlbg.transform:Find("bg3").gameObject:GetComponent("Image").sprite
            he = he + 1
        end
    end
    roomcont.transform:Find("countsp/zhuanval").gameObject:GetComponent("Text").text = zhuan
    roomcont.transform:Find("countsp/xianval").gameObject:GetComponent("Text").text = xian
    roomcont.transform:Find("countsp/heval").gameObject:GetComponent("Text").text = he
    roomcont.transform:Find("roomindex").gameObject:GetComponent("Image").sprite = bjlRoomNum.transform:Find("num_" .. (findex + 1)).gameObject:GetComponent("Image").sprite
end

function GameRoomList.getRoomTabel(serverPort)
    local len = #roomData
    for i = 1, len do
        if roomData[i].serverport == serverPort then
            return roomData[i]
        end
    end
    return nil
end
