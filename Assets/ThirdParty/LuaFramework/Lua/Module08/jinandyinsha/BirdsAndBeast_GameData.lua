BirdsAndBeast_GameData = {}
local self = BirdsAndBeast_GameData
self.iconres = nil --ͼƬ��icon
self.soundres = nil --����
self.runitemcont = {}
self.pushitemcont = {}
self.hisitemcont = {}
self.selectChoumNum = 0
self.myinfoData = {}
self.numrollingcont = {}
self.lastChip = nil --��һ����ע
self.isRunclear = false
self.runtimer = 0 --����ʱ��
self.savesound = nil --�м��˶�����Ч̫���� ���Ա������� �˳���Ϸ��ʱ�� �ùر���
self.playerTable = {}
self.playerDic = {}
self.curGetWinGoldNum = 0
function BirdsAndBeast_GameData.initData()
    self.his_data = {} --��ʷ��¼
    self.choum_data = {} --����
    self.pushmoney_data = {} --�Լ���ע
    self.pushmoneylast_data = {} --��һ���Լ�����ע
    self.multiple_data = {} --�������޺�
    self.allpushmoney_data = {} --ÿ����ע��������ע
    self.gameState = 0 --��Ϸ��״̬
    self.gameTimer = 0 --��Ϸ��ʱ��

    self.openindex = 0 --�����������Ǹ�
    self.caijinrate = 0 --�ʽ���
    self.wingold = 0 --����Ӯ��Ǯ
    self.runtimer = 0 --����ʱ��
    self.defalutTimer = 20
    self.curGetWinGoldNum = 0
end

function BirdsAndBeast_GameData.destroying()
    self.iconres = nil --ͼƬ��icon
    self.soundres = nil
    self.runitemcont = {}
    self.pushitemcont = {}
    self.hisitemcont = {}
    self.selectChoumNum = 0
    self.myinfoData = {}
    self.numrollingcont = {}
    self.lastChip = nil --��һ����ע
    self.initData()
    self.isRunclear = false
    self.runtimer = 0
    self.defalutTimer = 20
    self.curGetWinGoldNum = 0
    if not IsNil(self.savesound) then
        destroy(self.savesound)
    end
    self.savesound = nil
end
--��ʷ��¼
function BirdsAndBeast_GameData.hischang(buff, size)
    local index = 1
    if size > 1 then
        for i = 1, size do
            local ty = buff:ReadByte();
            --ty = BirdsAndBeast_GameData.GetServerType(ty);
            logYellow("历史记录："..ty);
            self.his_data[size - i + 1] = ty
        end
    else
        if #self.his_data >= BirdsAndBeast_CMD.D_HIS_COUNT then
            table.remove(self.his_data, 1)
        end
        local m =  buff:ReadByte();
        logYellow("历史记录b："..m);
        table.insert(self.his_data, #self.his_data + 1,m)
    end
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.hischang, nil)
end

function BirdsAndBeast_GameData.mypushchang(buff, size)
    local BirdsAndBeastType = nil
    for i = 1, size do
        BirdsAndBeastType = buff:ReadByte()
        BirdsAndBeastType = self.GetServerType(BirdsAndBeastType);
        local lastChipsData = self.pushmoney_data[BirdsAndBeastType];
        if (lastChipsData == nil) then lastChipsData = 0 end
        self.pushmoney_data[BirdsAndBeastType] = buff:ReadUInt32();
        if size == 1 then 
            if (self.pushmoney_data[BirdsAndBeastType] == 0) then
                BirdsAndBeast_GameData.myinfoData._7wGold = BirdsAndBeast_GameData.myinfoData._7wGold + lastChipsData;
                logYellow("撤回下注，把钱加回去")
            else
                local nowPushChips = self.pushmoney_data[BirdsAndBeastType] - lastChipsData;
                BirdsAndBeast_GameData.myinfoData._7wGold = BirdsAndBeast_GameData.myinfoData._7wGold - nowPushChips;
                --BirdsAndBeast_GameData.myinfoData._7wGold = BirdsAndBeast_GameData.myinfoData._7wGold - 0;

                logYellow("下注区域："..BirdsAndBeastType.."  总下注值："..self.pushmoney_data[BirdsAndBeastType].."   当前下注值："..nowPushChips);
            end
            BirdsAndBeast_MyInfo.myinfochang();
            BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.mypushmoneychang,BirdsAndBeastType);
            return
        end
    end

    logYellow("设置自己的下注："..BirdsAndBeastType.."   "..self.pushmoney_data[BirdsAndBeastType])
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.mypushmoneychang, nil)
end

--�Լ���ע�������ı�
function BirdsAndBeast_GameData.mypushchang_list(buff)
    local count = buff:ReadByte()
    self.mypushchang(buff, count)
end

function BirdsAndBeast_GameData.allpushchang(buff, size,isSence)
    local BirdsAndBeastType = nil
    if (size == 1) then
        if (isSence == false) then
            BirdsAndBeastType = buff:ReadByte()
            BirdsAndBeastType = self.GetServerType(BirdsAndBeastType);
            local last =  self.allpushmoney_data[BirdsAndBeastType];
            self.allpushmoney_data[BirdsAndBeastType] = buff:ReadUInt32()
            if isSence == false then
                local site = buff:ReadUInt32();
                local now = self.allpushmoney_data[BirdsAndBeastType] - last;
                logYellow("减少其他玩家当前的金币:"..now)
                --jinandyinsha_UserListSp.JianUserGold(site,now);
            end
        end

        logYellow("总押注改变："..self.allpushmoney_data[BirdsAndBeastType] )
        BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.allpushchang, BirdsAndBeastType)
    else
        logYellow("========================??============================")
        for i = 1, size do
            BirdsAndBeastType = buff:ReadByte()
            BirdsAndBeastType = self.GetServerType(BirdsAndBeastType);
            self.allpushmoney_data[BirdsAndBeastType] = buff:ReadUInt32()
        end
        BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.allpushchang, nil)
    end
end

--����ע�������ı�
function BirdsAndBeast_GameData.allpushchang_list(buff)
    local count = buff:ReadByte()
    self.allpushchang(buff, count)
end

--��·���޺�ĸı�
function BirdsAndBeast_GameData.multipchang(buff)
    for i = 1, BirdsAndBeast_CMD.D_ANIMAL_OR_COLOR_AREA_COUNT do
        local variable = buff:ReadByte()
        variable = self.GetServerType(variable);
        local mit = buff:ReadInt32()
        local re = buff:ReadUInt16()
        self.multiple_data[variable] = {limt = mit, rate = re}
    end
    logYellow("==============================设置倍数和限红================================")
    logTable(self.multiple_data)
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.pushmoneymultiplechang, nil)
    logYellow("==============================设置倍数和限红================================")
end

--����ĸı�
function BirdsAndBeast_GameData.choumChang(buff)
    for i = 1, BirdsAndBeast_CMD.D_CHOUM_NUM do
         local a = buff:ReadUInt32();
         log("筹码："..a)
         table.insert(self.choum_data, i, a)
    end
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.choumchang, nil)
end
--״̬�ı�
function BirdsAndBeast_GameData.gameStateChang(buff)
    self.gameState = buff:ReadByte()
    logYellow("初始状态:"..self.gameState);
    if self.gameState == BirdsAndBeast_CMD.D_GAME_STATE_CHIP or self.gameState == BirdsAndBeast_CMD.D_GAME_STATE_NULL then
        BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.showgameloading, false)
    end
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.gamestatechang, nil)
end

--ʱ��ı�
function BirdsAndBeast_GameData.gameTimereChang(buff)
    self.gameTimer = buff:ReadUInt32()
    if self.gameTimer > 100 then
        self.gameTimer = self.defalutTimer
    end
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.gametimerchang, nil)
end

--��ʾһ�ֵĿ�ʼ��һ�㶼�ǳ�ʼ
function BirdsAndBeast_GameData.gameInit(buff)
    self.gameState = BirdsAndBeast_CMD.D_GAME_STATE_NULL --��Ϸ��״̬
    self.caijinrate = 0 --�ʽ���
    log(1);
    for i=0,#self.allpushmoney_data do
        self.allpushmoney_data[i] = 0
    end
    log(1);
    local num = 0
    for i=0,#self.pushmoney_data do
        num = num + self.pushmoney_data[i];
    end
    log(1);
    local savenum = 0
    table.foreachi(self.pushmoneylast_data,function(i,k)
        savenum = savenum +  k;
     end)
    log(1);
    for i=0,#self.pushmoney_data do
        self.pushmoneylast_data[i ] = self.pushmoney_data[i];
        self.pushmoney_data[i] = 0
    end
    log("初始化下注区域值")
    logErrorTable(self.pushmoney_data);
    logErrorTable(self.pushmoneylast_data);
    logErrorTable(self.allpushmoney_data);
    if num > 0 then
       
    end
    if num > 0 or savenum > 0 then
        BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.continuechipiter, true)
    else
        BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.continuechipiter, false)
    end

    --error("________11111_____");
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.allpushchang, nil)
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.mypushmoneychang, nil)
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.gamenewinit, nil)
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.showgameloading, false)
    BirdsAndBeast_Socket.playaudio(BirdsAndBeastConfig.sound_bg, true, true)
end

function BirdsAndBeast_GameData.startRun(buff)
    self.openindex = buff:ReadByte()
    self.openindex =  self.openindex + 1;
    self.gameState = BirdsAndBeast_CMD.D_GAME_STATE_RUN
    error("转圈停止下标>>>>>:"..self.openindex)
    BirdsAndBeastPanel.startrun({data = not self.isRunclear})
    self.isRunclear = true
    BirdsAndBeast_Socket.playaudio(BirdsAndBeastConfig.sound_bg, true, false)
    jinandyinsha_UserListSp.zhedan.gameObject:SetActive(true)
end
--��ʼ��ע
function BirdsAndBeast_GameData.startChip(buff)
    logTable(self.pushmoney_data);
    self.gameTimer = self.defalutTimer --��Ϸ��ʱ��
    self.gameState = BirdsAndBeast_CMD.D_GAME_STATE_CHIP --��Ϸ��״̬
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.startchip, nil)
end
--ֹͣ��ע
function BirdsAndBeast_GameData.stopChip(buff)
    self.isRunclear = false
    self.gameState = BirdsAndBeast_CMD.D_GAME_STATE_STOP_CHIP --��Ϸ��״̬
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.stopchip, nil)
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.continuechipiter, false)
    jinandyinsha_UserListSp.reflushall();
end
--��Ϸ����
function BirdsAndBeast_GameData.gameOver(buff)
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.gameover, nil)
end

function BirdsAndBeast_GameData.gameWin(buff)
    local fagelineWinScore = tonumber(buff:ReadInt64Str())
    self.wingold = fagelineWinScore;
    logYellow("赢取金币："..self.wingold);
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.gamewinchang, nil)
end

--�ʽ�
function BirdsAndBeast_GameData.caiJinChang(buff)
    self.caijinrate = buff:ReadUInt16()
end
--�Լ�����Ϣ�ı�
function BirdsAndBeast_GameData.myinfoChang(isRefresh)
    self.myinfoData._1dwUser_Id = TableUserInfo._1dwUser_Id
    self.myinfoData._2szNickName = TableUserInfo._2szNickName
    self.myinfoData._3bySex = TableUserInfo._3bySex
    self.myinfoData._4bCustomHeader = TableUserInfo._4bCustomHeader
    self.myinfoData._5szHeaderExtensionName = TableUserInfo._5szHeaderExtensionName
    self.myinfoData._6szSign = TableUserInfo._6szSign
    self.myinfoData._7wGold = TableUserInfo._7wGold
    self.myinfoData._8wPrize = TableUserInfo._8wPrize
    self.myinfoData._9wChairID = TableUserInfo._9wChairID
    self.myinfoData._10wTableID = TableUserInfo._10wTableID
    self.myinfoData._11byUserStatus = TableUserInfo._11byUserStatus
    if isRefresh then
        BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.myinfochang, nil)
    end
end

function BirdsAndBeast_GameData.openPush(buff)
    self.gameState = BirdsAndBeast_CMD.D_GAME_STATE_HIS --��Ϸ��״̬
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.openmypushpanel, true)
    table.sort(
        BirdsAndBeast_GameData.playerTable,
        function(a, b)
            return a["_12score"] > b["_12score"]
        end
    )
    local numgold = 0
    local playnum = math.min(7, #BirdsAndBeast_GameData.playerTable)
    for b1 = 1, playnum do
        if BirdsAndBeast_GameData.playerTable[b1]["_12score"] > 0 then
            numgold = numgold + BirdsAndBeast_GameData.playerTable[b1]["_12score"]
        end
    end
    local arge = math.floor(numgold / 53)
    local showgoldnum = {0, 0, 0, 0, 0, 0, 0}
    for b1 = 1, playnum do
        if BirdsAndBeast_GameData.playerTable[b1]["_12score"] > 0 then
            showgoldnum[b1] = math.min(12, math.ceil(BirdsAndBeast_GameData.playerTable[b1]["_12score"] / arge))
        else
            showgoldnum[b1] = 0
        end
    end
    local openIndex = buff:ReadInt32()
    openIndex = self.GetServerType(openIndex);
    logYellow("===========================下标："..openIndex.."===============================")
    coroutine.start(
        function()
            local jsyins = 0
            self.curGetWinGoldNum = 0
            if BirdsAndBeast_Socket.isongame == false then
                return
            end
            BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.creatgoldanima, openIndex)
            BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.openPushchang, openIndex)
            coroutine.wait(1)
            if BirdsAndBeast_Socket.isongame == false then
                return
            end
            if openIndex > BirdsAndBeastConfig.bab_start and openIndex < BirdsAndBeastConfig.bab_shiz then
                jsyins = BirdsAndBeastConfig.bab_feiq
            end
            if openIndex >= BirdsAndBeastConfig.bab_shiz and openIndex < BirdsAndBeastConfig.bab_yins then
                jsyins = BirdsAndBeastConfig.bab_zous
            end
            if jsyins > 0 then
                BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.creatgoldanima, jsyins)
                BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.openPushchang, jsyins)
                coroutine.wait(1)
            end
        end
    )

    if BirdsAndBeast_Socket.isongame == false then
        return
    end
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.openmypushcom, showgoldnum)
end
function BirdsAndBeast_GameData.GetServerType(args)
   if (args == 0) then
      return BirdsAndBeastConfig.bab_feiq;
   end
   if (args == 1) then
      return BirdsAndBeastConfig.bab_jinsha;
   end
   if (args == 2) then
      return BirdsAndBeastConfig.bab_yins;
   end
   if (args == 3) then
      return BirdsAndBeastConfig.bab_zous;
   end
   if (args == 4) then
      return BirdsAndBeastConfig.bab_kongq;
   end
   if (args == 5) then
      return BirdsAndBeastConfig.bab_laoy;
   end
   if (args == 6) then
      return BirdsAndBeastConfig.bab_shiz;
   end
   if (args == 7) then
      return BirdsAndBeastConfig.bab_xiongm;
   end
   if (args == 8) then
      return BirdsAndBeastConfig.bab_yanz;
   end
   if (args == 9) then
      return BirdsAndBeastConfig.bab_gez;
   end

   if (args == 10) then
      return BirdsAndBeastConfig.bab_houz;
   end
   if (args == 11) then
      return BirdsAndBeastConfig.bab_tuz;
   end
   return 20;
end


function BirdsAndBeast_GameData.isHandWin(args)
    
    logTable(self.pushmoney_data)
    if self.pushmoney_data[args] > 0 then
        return true
    end
    if args > BirdsAndBeastConfig.bab_start and args < BirdsAndBeastConfig.bab_shiz then
        if self.pushmoney_data[BirdsAndBeastConfig.bab_feiq] > 0 then
            return true
        end
    end
    if args >= BirdsAndBeastConfig.bab_shiz and args < BirdsAndBeastConfig.bab_yins then
        if self.pushmoney_data[BirdsAndBeastConfig.bab_zous] > 0 then
            return true
        end
    end
    return false
end

function BirdsAndBeast_GameData.loadres(BirdsAndBeastType, isclient)
   log("loadres:"..BirdsAndBeastType)
    local item = BirdsAndBeastConfig.anim_res[BirdsAndBeastType]
    logYellow("准备加载资源："..item.resab.."    "..tostring(IsNil(item.res)));
    if item.res ~= nil then
        return item.res
    end
    if item.isloading == false then
         logYellow("加载资源："..item.resab);
         item.isloading = true
         item.res =newObject(LoadAsset(item.resab, item.resname, self.loadcom));
         item.res.name = item.resname;
         item.res.transform:SetParent(BirdsAndBeastPanel.per.transform.parent);
    end
    return item.res;
end
function BirdsAndBeast_GameData.loadcom(args)
   log("加载回调："..tostring(args == nil));
    if not IsNil(args) then
        local spname = args.name
        table.foreachi(
            BirdsAndBeastConfig.anim_res,
            function(i, k)
                if k.resname == spname then
                    k.res = args
                end
            end
        )
    end
end
