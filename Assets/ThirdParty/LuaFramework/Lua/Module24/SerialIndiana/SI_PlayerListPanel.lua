local UI_DEFINE={
    PanelLeftPosX   = -224,
    PanelRightPosX  = -2,
    ItemBeginX      = 86,
    ItemBeginY      = 150,
    ItemDisY        = 96,
    PaddingDis      = 10,
};

--玩家列表项
local PlayerItem=class("PlayerItem");

function PlayerItem:ctor(_parent)
    self.gameObject = GlobalGame._gameObjManager:GetPlayerItem();
    self.transform  = self.gameObject.transform; 
    self.transform:SetParent(_parent);
    self._goldText = self.transform:Find("Gold"):GetComponent("Text");
    self._nameText = self.transform:Find("Name"):GetComponent("Text");
    self._dragonExp = self.transform:Find("DragonBallLevel"):GetComponent("Image");
    self._dragonStage = -1;
end

function PlayerItem:SetParent(_parent)
    self.transform:SetParent(_parent);
end

function PlayerItem:SetDragonExp(_dragonExp)
    local stage = SI_DRAGON_STAGE_DATA:getDragonStage(_dragonExp);
    self:SetDragonStage(stage);
end

function PlayerItem:SetDragonStage(_stage)
    if self._dragonStage == _stage then
    else
        self._dragonStage = _stage;
        self._dragonExp.sprite = GlobalGame._gameObjManager:GetDragonLevelImage(_stage);
    end
end

--设置UID
function PlayerItem:SetUid(_uid)
    self._uid  = _uid;
end

function PlayerItem:SetName(_name)
 
    self._nameText.text = SI.GetShortNickname2(_name,7,12);
end

--回收
function PlayerItem:Recover()
    GlobalGame._gameObjManager:PushToCache(self.transform);
end

function PlayerItem:SetGold(_gold)
    local str = "金币:" .. SI.NumChangeToMoney(_gold);
    self._goldText.text = str;
end

--玩家整个列表
local PlayerListPanel = class("PlayerListPanel");

function PlayerListPanel:ctor(playerListPanel)
    self.transform      = playerListPanel;
    self.gameObject     = playerListPanel.gameObject;
    self._moveBtn       = playerListPanel:Find("MoveBtn");
    self._contentPanel  = playerListPanel:Find("PlayerListView/Viewport/Content");
    self._contentPanelRectTransform = self._contentPanel:GetComponent("RectTransform");
    self._lastPlayerItemMap = map:new();
    self._curPlayerItemMap    = map:new();
    self._playerCacheVector = vector:new();


    local eventTrigger=Util.AddComponent("EventTriggerListener",self._moveBtn.gameObject);
    eventTrigger.onClick = handler(self,self._onPanelMove);

    self._isHide = true;
    --self:ResponsePlayerList();


    --周期查询玩家列表
    --GlobalGame._timerMgr:FixUpdateByPeriod(handler(self,self.RequestPlayerList),2,SI_GAME_CONFIG.QueryPlayerListPeriod);
    --注册事件回调
    GlobalGame._eventSystem:RegEvent(SI_EventID.ResponsePlayerList,self,self.ResponsePlayerList);
    --金钱改变
    GlobalGame._eventSystem:RegEvent(SI_EventID.NotifyChangeGold,self,self.NotifyChangeGold);
    --通知经验改变
    GlobalGame._eventSystem:RegEvent(SI_EventID.NotifyChangeDragonData,self,self.NotifyChangeDragonData);

    --self:RequestPlayerList();
    self._selfPlayerItem = nil;
end


function PlayerListPanel:ResponsePlayerList(_eventId,_playerList)
    local obj;
    local x,y= UI_DEFINE.ItemBeginX,-UI_DEFINE.PaddingDis - UI_DEFINE.ItemDisY/2;
    local count = _playerList:Count();

    local w = self._contentPanelRectTransform.sizeDelta.x;
    local h = UI_DEFINE.ItemDisY*count + UI_DEFINE.PaddingDis*2;

    local lastPlayerItemMap = self._lastPlayerItemMap;
    self._lastPlayerItemMap = self._curPlayerItemMap;
    self._curPlayerItemMap = lastPlayerItemMap;
    self._curPlayerItemMap:clear();
    
    local mySelfUid=GlobalGame._gameControl:GetMyUid();
    --y = y + h/2;
    self._contentPanelRectTransform.sizeDelta = Vector2.New(w,h);
    --创建自己的
    local function createItem(_playerInfo)
        local obj = self._lastPlayerItemMap:erase(_playerInfo._uid);
        if obj then
        else
            obj =  self._playerCacheVector:pop();
            if obj then
                obj:SetParent(self._contentPanel);
            else
                obj = PlayerItem.New(self._contentPanel);
            end        
            obj:SetName(_playerInfo._name);   
            obj:SetUid(_playerInfo._uid);
        end
        obj.transform.localPosition = Vector3.New(x,y,0);
        obj.transform.localScale = Vector3.New(1,1,1);
        self._curPlayerItemMap:insert(_playerInfo._uid,obj);
        obj:SetDragonExp(_playerInfo._dragonExp);
        obj:SetGold(_playerInfo._gold);
        y = y - UI_DEFINE.ItemDisY;
        return obj;
    end

    --创建其他人的
    local function createOtherItem(_playerInfo)
        if mySelfUid == _playerInfo._uid then
            return ;
        end
        return createItem(_playerInfo);
    end
    local playerInfo = _playerList:GetPlayerByUid(mySelfUid);
    if playerInfo then
        self._selfPlayerItem = createItem(playerInfo);
    else
    end
    
    _playerList:Foreach(createOtherItem);

    if self._lastPlayerItemMap:size()>0 then
        local it = self._lastPlayerItemMap:iter();
        local val = it();
        local item =nil;
        while(val) do
            item = self._lastPlayerItemMap:value(val);
            self._playerCacheVector:push_back(item);
            item:Recover();
            val = it();
        end
    end
    self._contentPanelRectTransform.localPosition = Vector3.New(0,0,0);
end

function PlayerListPanel:RequestPlayerList()
    --请求玩家列表
    GlobalGame._gameControl:RequestPlayerList();
end

function PlayerListPanel:_onPanelMove()
    if self._isHide then
        self.transform:DOLocalMoveX(UI_DEFINE.PanelRightPosX, 0.6, false);
    else
        self.transform:DOLocalMoveX(UI_DEFINE.PanelLeftPosX, 0.6, false);
    end
    self._isHide = not self._isHide;
end


--事件通知
function PlayerListPanel:NotifyChangeGold(_eventId,_gold)
    if self._selfPlayerItem==nil then
        return;
    end
    self._selfPlayerItem:SetGold(_gold);
end

--通知经验等级
function PlayerListPanel:NotifyChangeDragonData(_eventId,_dragonData)
    if self._selfPlayerItem==nil then
        return;
    end
    self._selfPlayerItem:SetDragonStage(_dragonData:GetDragonStage());
end


return PlayerListPanel;