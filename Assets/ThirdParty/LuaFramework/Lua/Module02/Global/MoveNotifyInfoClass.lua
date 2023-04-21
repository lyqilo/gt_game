-- require "Common/define"


MoveNotifyInfoClass = { };
local self = MoveNotifyInfoClass;
--- 通告消息
local ListNotifyInfo = { };-- 系统信息表
-- 玩家信息表
local PlayerListNotifyInfo = { };
-- 优秀玩家播放的消息
local firstPlayerListNotifyInfo = { };
-- 系统信息
ListNotifyInfoNum = 1;
-- 玩家信息
PlayerListNotifyInfoNum = 1;
NotifyInfoTextObj = nil;
PlayerNotifyInfoTextObj = nil;
local isMoveNotifyInfo = false;
local PlayerisMoveNotifyInfo = false;
local showscen = nil;
local setYpos = 0;
self.removedotween = { };
self.enterdotween = { };

self.defaultWelcome = "欢迎来到逍遥阁";
self.cacheList = { "恭喜玩家10003005在水果777中级场赢得5000000金币",
                   "恭喜玩家10003010在跳高高中级场赢得6000000金币",
                   "恭喜玩家10004010在淘金者中级场赢得4520000金币",
                   "恭喜玩家10003019在跳高高中级场赢得8200000金币",
                   "恭喜玩家10004110在福临门高级场赢得4300000金币",
                   "恭喜玩家10004012在财神来了中级场赢得3000000金币",
                   "恭喜玩家10003020在跳高高中级场赢得6000000金币",
                   "恭喜玩家10003033在跳高高中级场赢得6000000金币",
                   "恭喜玩家10004055在跳高高中级场赢得6000000金币" };
self.currentPlayCacheIndex = 0;
function MoveNotifyInfoClass.Int()
    if #self.removedotween > 0 then
        for i = 1, #self.removedotween do
            self.removedotween[i]:Kill()
        end
    end
    if #self.enterdotween > 0 then
        for i = 1, #self.enterdotween do
            self.enterdotween[i]:Kill()
        end
    end
    
    if ScenSeverName == gameServerName.HALL then
        showscen = gameServerName.HALL;
        NotifyInfoTextObj = HallScenPanel.Suona.transform:Find("Text");
        NotifyInfoTextObjParset = HallScenPanel.Suona;
        PlayerNotifyInfoTextObj = HallScenPanel.PlayerSuona.transform:Find("Text");
        PlayerNotifyInfoTextObjParset = HallScenPanel.PlayerSuona
        PlayerNotifyInfoTextObj.localPosition = Vector3.New(955, setYpos, 0);
        -- 设置Text颜色
        -- AddUTColor(PlayerNotifyInfoTextObj);
    elseif ScenSeverName ~= gameScenName.LOGON then
        showscen = gameServerName.SFZ;
        if IsNil(GameSetsBtnInfo.Suona) then
            error("MoveNotifyInfoClass.Int error:GameSetsBtnInfo is nil")
            return
        end
        NotifyInfoTextObj = GameSetsBtnInfo.Suona.transform:Find("Text");
        NotifyInfoTextObjParset = GameSetsBtnInfo.Suona;
        PlayerNotifyInfoTextObj = GameSetsBtnInfo.PlaySuona.transform:Find("Text");
        PlayerNotifyInfoTextObjParset = GameSetsBtnInfo.PlaySuona;
        setYpos = PlayerNotifyInfoTextObj.localPosition.y;
        PlayerNotifyInfoTextObj.localPosition = Vector3.New(955, setYpos, 0);
        -- 设置Text颜色
        -- AddUTColor(PlayerNotifyInfoTextObj);
    end
    isMoveNotifyInfo = false;
    NotifyInfoTextObj:GetComponent('Text').text = " ";
    PlayerisMoveNotifyInfo = false;
    PlayerNotifyInfoTextObj:GetComponent('Text').text = " ";

end
function MoveNotifyInfoClass.NotifyInfo(buffer, wSize)
    if gameIsOnline then
        if PlayerNotifyInfoTextObj == nil or NotifyInfoTextObj == nil then
            self.Int()
        end ;
        local data = GetS2CInfo(SC_NotifyInfo, buffer);
        --logTable(data)
        local shownum = data[2];
        -- 显示次数
        local IsImportant = data[3]
        -- 是否重要
        if data[1] == 0 then
            -- 系统消息
            for i = 1, shownum do
                table.insert(ListNotifyInfo, data[5]);
            end
            if isMoveNotifyInfo then
            else
                NotifyInfoTextObj:GetComponent('Text').text = ListNotifyInfo[1];
                NotifyInfoTextObjParset:SetActive(true);
                isMoveNotifyInfo = true;
                table.remove(ListNotifyInfo, 1);
                self.MoveNotifyInfo();
            end

        elseif data[1] == 1 then
            -- 玩家消息
            for i = 1, shownum do
                if data[5]~="" then
                    table.insert(PlayerListNotifyInfo, data[5]);
                end
            end
            if #self.cacheList > 20 then
                table.remove(self.cacheList, 1);
            end
            if data[5]~="" then
                table.insert(self.cacheList, data[5]);  
            end
            if PlayerisMoveNotifyInfo then
            else

                PlayerNotifyInfoTextObj:GetComponent('Text').text = PlayerListNotifyInfo[1];
                PlayerNotifyInfoTextObjParset:SetActive(true);
                PlayerisMoveNotifyInfo = true;
                table.remove(PlayerListNotifyInfo, 1);
                self.PlayerMoveNotifyInfo();
            end
        elseif data[1] == 2 then            
            -- 玩家消息
            for i = 1, shownum do
                if data[5]~="" then
                    table.insert(firstPlayerListNotifyInfo, data[5]);
                end
            end
            if #self.cacheList > 20 then
                table.remove(self.cacheList, 1);
            end
            if data[5]~="" then
                table.insert(self.cacheList, data[5]);  
            end
            if PlayerisMoveNotifyInfo then

            else
                if PlayerNotifyInfoTextObj == nil or NotifyInfoTextObj == nil then
                    self.Int()
                end ;
                PlayerNotifyInfoTextObj:GetComponent('Text').text = firstPlayerListNotifyInfo[1];
                PlayerNotifyInfoTextObjParset:SetActive(true);
                PlayerisMoveNotifyInfo = true;
                table.remove(firstPlayerListNotifyInfo, 1);
                self.PlayerMoveNotifyInfo();
            end
        end
    end
end
-- 重置动画

function MoveNotifyInfoClass.QuanDayNotice()
    if gameIsOnline then
        if PlayerNotifyInfoTextObj == nil or NotifyInfoTextObj == nil then
            self.Int()
        end ;
        if ScenSeverName == gameServerName.HALL then
            table.insert(ListNotifyInfo, ExceptionCodeInfo[95021]);
            if isMoveNotifyInfo then
            else
                NotifyInfoTextObj:GetComponent('Text').text = ListNotifyInfo[ListNotifyInfoNum];
                NotifyInfoTextObjParset:SetActive(true);
                isMoveNotifyInfo = true;
            end

        else
            table.insert(firstPlayerListNotifyInfo, ExceptionCodeInfo[95021]);
            if PlayerisMoveNotifyInfo then

            else
                PlayerNotifyInfoTextObj:GetComponent('Text').text = firstPlayerListNotifyInfo[1];
                PlayerNotifyInfoTextObjParset:SetActive(true);
                PlayerisMoveNotifyInfo = true;
                table.remove(firstPlayerListNotifyInfo, 1);
            end
        end
    else
    end
end
-- 针对游戏内部提示
function MoveNotifyInfoClass.GameNotice(args)
    if gameIsOnline then
        if PlayerNotifyInfoTextObj == nil or NotifyInfoTextObj == nil then
            self.Int()
        end ;
        if ScenSeverName == gameServerName.HALL then
        else
            if isMoveNotifyInfo then
                table.insert(ListNotifyInfo, args);
            else
                table.insert(ListNotifyInfo, args);
                NotifyInfoTextObj:GetComponent('Text').text = ListNotifyInfo[1];
                NotifyInfoTextObjParset:SetActive(true);
                isMoveNotifyInfo = true;
                table.remove(ListNotifyInfo, 1);
            end
        end
    else
    end
end
-- 从屏幕右到左移动公告
function MoveNotifyInfoClass.MoveNotifyInfo()
    if PlayerNotifyInfoTextObj == nil or NotifyInfoTextObj == nil then
        self.Int()
    end ;
    -- 系统
    local v3 = NotifyInfoTextObj.localPosition;
    if NotifyInfoTextObj:GetComponent('Text').preferredWidth > 0 then
        NotifyInfoTextObj:GetComponent("RectTransform").sizeDelta = Vector2.New(NotifyInfoTextObj:GetComponent('Text').preferredWidth + 1, NotifyInfoTextObj:GetComponent("RectTransform").sizeDelta.y);
    end
    local tweener = NotifyInfoTextObj:DOLocalMove(Vector3.New(0, v3.y, v3.z), 1, false);
    tweener:SetEase(DG.Tweening.Ease.Linear);
    tweener:OnComplete(function()
        coroutine.start(function()
            for i = 1, 10 do
                coroutine.wait(0.4);
                if not NotifyInfoTextObj then
                    return
                end
                if IsNil(NotifyInfoTextObj) then
                    isMoveNotifyInfo = false;
                    return
                end
            end
            --            if NotifyInfoTextObj == nil or ScenSeverName == gameServerName.LOGON or showscen ~= TishiScenes then
            --                isMoveNotifyInfo = false;
            --                return;
            --            end
            local tweener = NotifyInfoTextObj:DOLocalMove(Vector3(-1000, v3.y, v3.z), 1, false);
            tweener:SetEase(DG.Tweening.Ease.InCubic);
            tweener:OnComplete(function()
                self.DeleteNotifyInfo();
            end);
        end);
    end);

    if ScenSeverName == gameServerName.HALL and HallScenPanel and HallScenPanel.Suona and HallScenPanel.Suona.transform then
        v3 = HallScenPanel.Suona.transform.localPosition;
        if v3.y > 0 then
            HallScenPanel.Suona.transform.localPosition = Vector3.New(v3.x, setYpos, v3.z);
        end
    end
end

-- 玩家消息滚动
function MoveNotifyInfoClass.PlayerMoveNotifyInfo()
    if NotifyInfoTextObj == nil then
        self.Int()
    end ;
    if PlayerNotifyInfoTextObj == nil then
        self.Int()
    end ;
    local Playerv3 = PlayerNotifyInfoTextObj.localPosition;
    if ScenSeverName == gameServerName.HALL and HallScenPanel and HallScenPanel.PlayerSuona and HallScenPanel.PlayerSuona.transform then
        -- local Playerv22 = HallScenPanel.PlayerSuona.transform.localPosition;
        --        if Playerv22.y > -160 then
        --            --    HallScenPanel.PlayerSuona.transform.localPosition = Vector3.New(70, 310, 0);
        --        end
    end
    if PlayerNotifyInfoTextObj:GetComponent('Text').preferredWidth > 0 then
        PlayerNotifyInfoTextObj:GetComponent("RectTransform").sizeDelta = Vector2.New(PlayerNotifyInfoTextObj:GetComponent('Text').preferredWidth + 1, PlayerNotifyInfoTextObj:GetComponent("RectTransform").sizeDelta.y);
    end
    PlayerNotifyInfoTextObj.localPosition = Vector3.New(955, setYpos, 0);
    if #self.enterdotween > 0 then
        for i = 1, #self.enterdotween do
            self.enterdotween[i]:Kill();
        end
    end
    if #self.removedotween > 0 then
        for i = 1, #self.removedotween do
            self.removedotween[i]:Kill();
        end
    end
    local tweener = PlayerNotifyInfoTextObj:DOLocalMove(Vector3.New(0, Playerv3.y, Playerv3.z), 1, false);
    --  tweener:OnPlay( function() PlayerNotifyInfoTextObj:DOLocalMove(Vector3.New(955, setYpos, 0), 0.01, false); end)
    tweener:SetEase(DG.Tweening.Ease.Linear);
    tweener:OnComplete(function()
        self.enterdotween = {};
        coroutine.start(function()
            for i = 1, 10 do
                coroutine.wait(0.4);
                if not PlayerisMoveNotifyInfo then
                    return
                end
                if IsNil(PlayerNotifyInfoTextObj) then
                    PlayerisMoveNotifyInfo = false;
                    return
                end
            end
            if IsNil(PlayerNotifyInfoTextObj) then
                PlayerisMoveNotifyInfo = false;
                return
            end
            if #self.removedotween > 0 then
                for i = 1, #self.removedotween do
                    self.removedotween[i]:Kill();
                end
            end
            if #self.enterdotween > 0 then
                for i = 1, #self.enterdotween do
                    self.enterdotween[i]:Kill();
                end
            end
            local tweener = PlayerNotifyInfoTextObj:DOLocalMove(Vector3(-1000, Playerv3.y, Playerv3.z), 1, false);
            table.insert(self.removedotween, tweener)
            tweener:SetEase(DG.Tweening.Ease.InCubic);
            tweener:OnComplete(function()
                self.removedotween = { };
                self.PlayerDeleteNotifyInfo();
            end);
        end);
    end);
    table.insert(self.enterdotween, tweener);

end
function MoveNotifyInfoClass.ReturnAnimator()

    PlayerisMoveNotifyInfo = false;
    isMoveNotifyInfo = false;
    -- 取消系统通告显示
    NotifyInfoTextObj = nil;
    -- 取消玩家通告显示
    PlayerNotifyInfoTextObj = nil;

end

-- 删除已显示完的公告,继续下一条
function MoveNotifyInfoClass.DeleteNotifyInfo()
    -- error("-- 删除已显示完的公告,继续下一条---------------------"..PlayerNotifyInfoTextObj:GetComponent('Text').text );
    if NotifyInfoTextObj == nil then
        self.Int()
    end ;
    if PlayerNotifyInfoTextObj == nil then
        self.Int()
    end ;
    -- 播放完了一条清一条
    if #(ListNotifyInfo) > 0 then
        NotifyInfoTextObj:GetComponent('Text').text = ListNotifyInfo[1];
        NotifyInfoTextObj.localPosition = Vector3.New(955, setYpos, 0);
        NotifyInfoTextObjParset:SetActive(true);
        table.remove(ListNotifyInfo, 1);
        self.MoveNotifyInfo();
    else
        -- 播放完了清空整个表
        NotifyInfoTextObj.localPosition = Vector3.New(955, setYpos, 0);
        isMoveNotifyInfo = false;
        NotifyInfoTextObj:GetComponent('Text').text = " ";
        -- error("ScenSeverName==================="..ScenSeverName);
        if ScenSeverName == gameServerName.HALL then
            return
        end
        NotifyInfoTextObjParset:SetActive(false);
    end
end
-- 删除玩家已显示完的公告,继续下一条
function MoveNotifyInfoClass.PlayerDeleteNotifyInfo()
    --logYellow("删除玩家已显示完的公告,继续下一条")
    if NotifyInfoTextObj == nil then
        self.Int()
    end ;
    if PlayerNotifyInfoTextObj == nil then
        self.Int()
    end ;
    --logYellow("firstPlayerListNotifyInfo=="..#firstPlayerListNotifyInfo)
    -- 播放完了一条清一条
    if #(firstPlayerListNotifyInfo) > 0 then
        PlayerNotifyInfoTextObj:GetComponent('Text').text = firstPlayerListNotifyInfo[1];
        PlayerNotifyInfoTextObj.localPosition = Vector3.New(955, setYpos, 0);
        PlayerNotifyInfoTextObjParset:SetActive(true);
        table.remove(firstPlayerListNotifyInfo, 1);
        self.PlayerMoveNotifyInfo();
        return ;
    end
    -- 播放完了一条清一条
    --logYellow("PlayerListNotifyInfo=="..#PlayerListNotifyInfo)

    if #(PlayerListNotifyInfo) > 0 then
        --logTable(PlayerListNotifyInfo)
        PlayerNotifyInfoTextObj:GetComponent('Text').text = PlayerListNotifyInfo[1];
        PlayerNotifyInfoTextObj.localPosition = Vector3.New(955, setYpos, 0);
        PlayerNotifyInfoTextObjParset:SetActive(true);
        table.remove(PlayerListNotifyInfo, 1);
        self.PlayerMoveNotifyInfo();
        return ;
    end

    --logYellow('播放默认')
    if #(PlayerListNotifyInfo) <= 0 and #(firstPlayerListNotifyInfo) <= 0 then
        -- 播放完了清空整个表
        PlayerNotifyInfoTextObj.localPosition = Vector3.New(955, setYpos, 0);
        PlayerisMoveNotifyInfo = false;
        if #self.cacheList <= 0 then
            PlayerNotifyInfoTextObj:GetComponent('Text').text = self.defaultWelcome;
        else
            self.currentPlayCacheIndex = self.currentPlayCacheIndex + 1;
            if self.currentPlayCacheIndex > #self.cacheList then
                self.currentPlayCacheIndex = 1;
            end
            PlayerNotifyInfoTextObj:GetComponent('Text').text = self.cacheList[self.currentPlayCacheIndex];
        end
        PlayerNotifyInfoTextObj.localPosition = Vector3.New(955, setYpos, 0);
        PlayerNotifyInfoTextObjParset:SetActive(true);
        PlayerisMoveNotifyInfo = true;
        self.PlayerMoveNotifyInfo();
        --PlayerNotifyInfoTextObj:GetComponent('Text').text = " ";
        --  error("ScenSeverName==================="..ScenSeverName);
        --if ScenSeverName == gameServerName.HALL then
        --    return
        --end
        --if ScenSeverName ~= gameServerName.HALL then
        --    PlayerNotifyInfoTextObjParset:SetActive(false);
        --end
    end
end

self.getcodetime = 0;
self.getcodefuntion = nil;
function MoveNotifyInfoClass.GetCodeTime()
    if self.getcodetime > 0 then
        self.getcodetime = self.getcodetime - 1;
        coroutine.wait(1);
        if self.getcodefuntion == nil then
        else
            --     error("发送现在得Time值=====" .. self.getcodetime);
            self.getcodefuntion();
            ---        error("发送完成=====");
        end
        coroutine.start(self.GetCodeTime);
    end
end

function MoveNotifyInfoClass.ReLogin()
    -- 取消通告显示
    isMoveNotifyInfo = false;
    PlayerisMoveNotifyInfo = false;
    -- 取消通告显示
    NotifyInfoTextObj = nil;
    -- 清空排行榜
    RankTab = { };
    isPlayerModel = false
    if ScenSeverName == gameServerName.HALL then
    elseif ScenSeverName == gameServerName.LOGON then
        -- 登录时用户账户密码错误,跳转到登录界面重新输入密码
    else
        -- 要关闭网络连接,相当于退出了当前

        table.insert(ReturnNotShowError, "95003");
        Network.Close(gameSocketNumber.GameSocket);

    end
    GameFail = 0;
    GameManager.ChangeScen(gameScenName.LOGON);
end

function MoveNotifyInfoClass.GameQuit()
    -- 要关闭网络连接,相当于退出了当前
    Network.Close(gameSocketNumber.GameSocket);
    GameManager.ChangeScen(gameScenName.HALL);

end

function MoveNotifyInfoClass.EveryDayClear(buffer, wSize)
    local data = GetS2CInfo(SC_EverydayClearData, buffer);
    -- 应该领取的时间ID
    SCPlayerInfo._09dwShouldGet_Time_Id = data[1];
    -- 已经在线时间
    SCPlayerInfo._10dwHasOnlineTime = data[2];
    -- 已经抽奖次数
    SCPlayerInfo._11dwHasLotteryCount = data[3];
    -- 是否完成每日对战
    SCPlayerInfo._12bFinishEverydayGame = data[4];
    -- 已经分享的天数
    SCPlayerInfo._14byHasShareDay_Id = data[5];
    -- 是否今天已经领取分享奖励
    SCPlayerInfo._15bTodayShare = data[6];
    SCPlayerInfo._19dwShouldGet_Alms_Id = data[7];
    SCPlayerInfo._20dwAlmsGetLeftTime = data[8];
end





