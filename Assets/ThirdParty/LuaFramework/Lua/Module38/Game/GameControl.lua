local GameDefine = GameRequire__("GameDefine");
local KeyEvent   = GameRequire__("KeyEvent");
local EventSystem = GameRequire__("EventSystem");
local _CPlayerControl = GameRequire__("PlayerControl");
local _CGameControl = class("GameControl");
local Enum_GameState = GameDefine.EnumGameState();
local Enum_ServerState = GameDefine.EnumServerState();
local Enum_WholeType = GameDefine.EnumWholeType();

function _CGameControl:ctor(...)
    self._isPlaying  = {};

    self.gameState = Enum_GameState.EM_GameState_Null;
    self.caijin    = 0;
    self.lastGameRet = {getGold = 0,gameBet = 0,comGold = 0};
    self.smallGameRet = { pos = 0,getGold = 0};
    self.gameBet   = 0;

    self._asyncStep        = 1;
    self._isAsyncLoadOver  = false;
    self._asyncPrecent     = 11;
    --是否可以坐下
    self._isLoginOver      = false;
    self._isSendSitDown    = false;
    --是否在运行游戏
    self._isRunGame        =  false;
 
end

function _CGameControl:Init()
    --
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetBet,handler(self,self.OnKey_GetBet));
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetGameState,handler(self,self.OnKey_GetGameState));
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetGameRet,handler(self,self.OnKey_GetGameRet));
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetUserGold,handler(self,self.OnKey_GetUserGold));
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetSmallGameRet,handler(self,self.OnKey_GetSmallGameRet));
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetCaijin,handler(self,self.OnKey_GetCaijin));
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetWholeValues,handler(self,self.OnKey_GetWholeValues));
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetFreeCount,handler(self,self.OnKey_GetFreeCount));
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetCanStartGame,handler(self,self.OnKey_GetCanStartGame));
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetMultiple,handler(self,self.OnKey_GetMultiple));
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetFreeTotal,handler(self,self.OnKey_GetFreeTotal));
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetFightDetail,handler(self,self.OnKey_GetFightDetail));
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetWarDetail,handler(self,self.OnKey_GetWarDetail));
    G_GlobalGame:RegEventByStringKey("GameData",self,self.OnGameData);
    G_GlobalGame:RegEventByStringKey("ChairsData",self,self.OnChairsData);
    G_GlobalGame:RegEventByStringKey("UserEnter",self,self.OnUserEnter);
    G_GlobalGame:RegEventByStringKey("UserLeave",self,self.OnUserLeave);
    G_GlobalGame:RegEventByStringKey("ChangeBet",self,self.OnChangeBet);
    G_GlobalGame:RegEventByStringKey("StartGame",self,self.OnStartGame);
    G_GlobalGame:RegEventByStringKey("ClickSmallGame",self,self.OnClickSmallGame);
    G_GlobalGame:RegEventByStringKey("RequestCaijin",self,self.OnRequestCaiJin);
    G_GlobalGame:RegEventByStringKey("ResponseStartGame",self,self.OnResponseStartGame);
    G_GlobalGame:RegEventByStringKey("ResponseSmallGame",self,self.OnResponseSmallGame);
    G_GlobalGame:RegEventByStringKey("ResponseCaijin",self,self.OnResponseCaijin);
    G_GlobalGame:RegEventByStringKey("ResetWarData",self,self.OnResetWarData);
end

--座位玩家信息
function _CGameControl:OnChairsData(_eventID,_eventData)
    if self.playersControl then
        self.playersControl:OnChairsData(_eventData);
    end
end

--全局游戏数据
function _CGameControl:OnGameData(_eventID,_eventData)
    if _eventData.userState == Enum_ServerState.EM_ServerState_Normal then
        self.gameState = Enum_GameState.EM_GameState_Null;
    elseif _eventData.userState == Enum_ServerState.EM_ServerState_SmallGame then
        self.gameState = Enum_GameState.EM_GameState_SmallGame;
    elseif _eventData.userState == Enum_ServerState.EM_ServerState_FreeGame then
        if _eventData.freeCount==0 then
            self.gameState = Enum_GameState.EM_GameState_Null;
        else
            self.gameState = Enum_GameState.EM_GameState_FreeGame;
        end
    end
    self.caijin    = _eventData.caijin;
    if _eventData.bet~=0  then
        self.gameBet = _eventData.bet;
    else
        self.gameBet = GameDefine.GetMinBet();
    end
    if  self.playersControl then
        self.playersControl:OnGameData(_eventData);
    end
    G_GlobalGame:DispatchEventByStringKey("NotifyUIGameDataCB");
end

--玩家进入
function _CGameControl:OnUserEnter(_eventID,_eventData)
    if self.playersControl then
        self.playersControl:OnUserEnter(_eventData);
    end
end

--玩家离开
function _CGameControl:OnUserLeave(_eventID,_eventData)
    if self.playersControl then
        self.playersControl:OnUserLeave(_eventData);
    end
end

function _CGameControl:OnChangeBet(_eventID,_bet)
    self.gameBet = _bet;
    G_GlobalGame._clientSession:GetBet_Data(_bet)
end

function _CGameControl:OnClearBet()
    error("清除下注信息")
    GameDefine.ClearBet();
end

function _CGameControl:OnStartGame(_eventID)
    local maxLine = GameDefine.MaxLine();
    if not self.playersControl:OnRechargeFreeCount(1) then
        if not self.playersControl:OnRechargeGold(self.gameBet*maxLine) then
            return ;
        end
    end
    
    --发送消息
    self:OnRequestStartGame(self.gameBet);
    --改变状态
    self.gameState = Enum_GameState.PlayingGame;
end

function _CGameControl:OnClickSmallGame(_eventID,_pos)
    --开始点球
    self:OnRequestStartSmallGame(_pos);
end

function _CGameControl:OnKey_GetBet()
    return self.gameBet;
end

function _CGameControl:OnKey_GetGameState()
    return self.gameState;
end

function _CGameControl:OnKey_GetGameRet()
    return self.gameBet,self.lastGameRet.getGold,self.lastGameRet.comGold,self.playersControl:GetSelfGameRet();
end

function _CGameControl:OnKey_GetSmallGameRet()
    return self.smallGameRet.getGold;
end

function _CGameControl:OnKey_GetCaijin()
    local maxBet =GameDefine.GetMaxBet();
    if maxBet==nil or maxBet==0 then
        return 0;
    end
    if self.gameBet>=maxBet then
        return self.caijin;
    else
        return math.floor(self.gameBet/maxBet*self.caijin);
    end
end

function _CGameControl:OnKey_GetWholeValues()
    local maxBet =GameDefine.GetMaxBet();
    if maxBet==nil or maxBet==0 then
        return 0;
    end
    if self.gameBet<=0 then
        return 0;
    end
    return self.gameBet*GameDefine.GetWholeMultiple(Enum_WholeType.EM_WholeValue_Small),
        self.gameBet*GameDefine.GetWholeMultiple(Enum_WholeType.EM_WholeValue_Mid),
        self.gameBet*GameDefine.GetWholeMultiple(Enum_WholeType.EM_WholeValue_Big);
end

function _CGameControl:OnKey_GetUserGold()
    if self.playersControl then
        local player =  self.playersControl:MyPlayer();
        return player:GetGold();
    end
end

function _CGameControl:OnKey_GetFreeCount()
    if self.playersControl then
        local player =  self.playersControl:MyPlayer();
        return player:FreeCount();
    end
end

function _CGameControl:OnKey_GetCanStartGame()
    local maxLine = GameDefine.MaxLine();
    if self.playersControl:OnCanReduceFreeCount(1) or 
        self.playersControl:OnCanRechargeGold(self.gameBet*maxLine) then
        return true;
    end
    return false;
end

function _CGameControl:OnKey_GetMultiple()
    if self.playersControl then
        local player =  self.playersControl:MyPlayer();
        return player:Multiple();
    end
end

function _CGameControl:OnKey_GetFreeTotal()
    if self.playersControl then
        local player =  self.playersControl:MyPlayer();
        return player:GetFreeTotal();
    end
    return nil;
end

function _CGameControl:OnKey_GetFightDetail()
    if self.playersControl then
        return self.playersControl:GetFightDetail();
    end
    return nil;
end

function _CGameControl:OnKey_GetWarDetail()
    if self.playersControl then
        return self.playersControl:GetWarDetail();
    end
    return nil;
end

function _CGameControl:SwitchWorldPosToScreenPosBy3DCamera(pos)
    return Util.WorlPointToScreenSpace(pos, G_GlobalGame._uiCamera);
end

function _CGameControl:SwitchScreenPosToWorldPosBy3DCamera(pos,z)
    if z==nil then
        return G_GlobalGame._uiCamera:ScreenToWorldPoint(pos);
    else
        V_Vector3_Value.x=pos.x;
        V_Vector3_Value.y=pos.y;
        V_Vector3_Value.z=z;
        return G_GlobalGame._uiCamera:ScreenToWorldPoint(V_Vector3_Value);
    end
end

function _CGameControl:SwitchWorldPosToWorldPosBy3DCamera(pos,z)
    local pos1= self:SwitchWorldPosToScreenPosBy3DCamera(pos);
    pos1.z = z;
    return self:SwitchScreenPosToWorldPosBy3DCamera(pos1);
end

function _CGameControl:SwitchWorldPosToScreenPosByUICamera(pos)
    return G_GlobalGame._uiCamera:WorldToScreenPoint(pos);
end

function _CGameControl:SwitchScreenPosToWorldPosByUICamera(pos,z)
    --local position = self._uiCameraPos;
    local position = self._uiCamera.transform.position;
    z = pos.z;
    V_Vector3_Value.x=(pos.x- position.x);
    V_Vector3_Value.y=(pos.y - position.y);
    V_Vector3_Value.z= z - position.z;
    if z==nil then
        return G_GlobalGame._uiCamera:ScreenToWorldPoint(V_Vector3_Value);
    else
        return G_GlobalGame._uiCamera:ScreenToWorldPoint(V_Vector3_Value);
    end
end

function _CGameControl:SwitchScreenPosToWorldPosByUICameraEx(pos)
    local newPos  = G_GlobalGame._uiCamera:ScreenToViewportPoint(pos);
    newPos =  G_GlobalGame._uiCamera:ViewportToWorldPoint(newPos);
    return newPos;
end

-- function _CGameControl:Update(dt)
--     self._isPlaying = {};
-- end

function _CGameControl:OnKey_GetGold()

end

--重新加载游戏
function _CGameControl:ReloadGame()
    --这里可能需要重新加载LoadPanel
    self._isAsyncLoadOver = false;
    self._isLoginOver = false;
    self._isSendSitDown = false;
end


--异步加载
function _CGameControl:OnSameLoad(_runTime,_data)
    local isStepOver = false;
    if self._asyncStep>=8 then
        return true,100;
    elseif self._asyncStep == 6 then
        if self._asyncPrecent<90 then
            self._asyncPrecent = self._asyncPrecent + math.random(2,5);
        else
            self._asyncPrecent = self._asyncPrecent + 1;
        end
        isStepOver = self:_asyncLoadStep6(_runTime,data); 
        if isStepOver then
            self._asyncStep = self._asyncStep + 1;
            if self._asyncStep>=8 then
                self._gameSceneControl:OnGameStart();
                return true,100;
            end
        end 
    elseif self._asyncStep==7 then
        isStepOver = self:_asyncLoadStep7(_runTime,data); 
        if isStepOver then
            self._asyncStep = self._asyncStep + 1;
            if self._asyncStep>=8 then
                self._gameSceneControl:OnGameStart();
                return true,100;
            end
        end
    else
        while(self._asyncStep<7) do
            if self._asyncPrecent<90 then
                self._asyncPrecent = self._asyncPrecent + math.random(2,5);
            else
                self._asyncPrecent = self._asyncPrecent + 1;
            end
            if self._asyncStep == 1 then
                isStepOver = self:_asyncLoadStep1(_runTime,data);
                if isStepOver then
                    if self._asyncPrecent<15 then
                        self._asyncPrecent = 15;
                    end
                end
            elseif self._asyncStep == 2 then
                isStepOver = self:_asyncLoadStep2(_runTime,data);
                if isStepOver then
                    if self._asyncPrecent<35 then
                        self._asyncPrecent = 35;
                    end
                end
            elseif self._asyncStep == 3 then
                isStepOver = self:_asyncLoadStep3(_runTime,data); 
                if isStepOver then
                    if self._asyncPrecent< 50 then
                        self._asyncPrecent = math.random(50,65);
                    end
                end
            elseif self._asyncStep == 4 then
                isStepOver = self:_asyncLoadStep4(_runTime,data);
            elseif self._asyncStep == 5 then
                isStepOver = self:_asyncLoadStep5(_runTime,data); 
                if isStepOver then
                    if self._asyncPrecent< 78 then
                        self._asyncPrecent = math.random(78,83);
                    end
                end
            end
            if isStepOver then
                self._asyncStep = self._asyncStep + 1;
                if self._asyncStep>=8 then
                    self._gameSceneControl:OnGameStart();
                    return true,100;
                elseif self._asyncStep>=6 then
                    if self._asyncPrecent>= 100 then
                        self._asyncPrecent = 99;
                    end
                    return false,self._asyncPrecent;
                end
            end
        end         
    end
end

--异步加载
function _CGameControl:OnAsyncLoad(_runTime,_data)
    if self._asyncPrecent<90 then
        self._asyncPrecent = self._asyncPrecent + math.random(2,5);
    else
        self._asyncPrecent = self._asyncPrecent + 1;
    end
    local isStepOver = false;
    if self._asyncStep == 1 then
        isStepOver = self:_asyncLoadStep1(_runTime,_data);
        if isStepOver then
            if self._asyncPrecent<15 then
                self._asyncPrecent = 15;
            end
        end
    elseif self._asyncStep == 2 then
        isStepOver = self:_asyncLoadStep2(_runTime,_data);
        if isStepOver then
            if self._asyncPrecent<35 then
                self._asyncPrecent = 35;
            end
        end
    elseif self._asyncStep == 3 then
        isStepOver = self:_asyncLoadStep3(_runTime,_data); 
        if isStepOver then
            if self._asyncPrecent< 50 then
                self._asyncPrecent = math.random(50,65);
            end
        end
    elseif self._asyncStep == 4 then
        isStepOver = self:_asyncLoadStep4(_runTime,_data);
    elseif self._asyncStep == 5 then
        isStepOver = self:_asyncLoadStep5(_runTime,_data); 
        if isStepOver then
            if self._asyncPrecent< 78 then
                self._asyncPrecent = math.random(78,83);
            end
        end
    elseif self._asyncStep == 6 then
        isStepOver = self:_asyncLoadStep6(_runTime,_data);    
    elseif self._asyncStep == 7 then
        isStepOver = self:_asyncLoadStep7(_runTime,_data);  
    end
    if isStepOver then
        self._asyncStep = self._asyncStep + 1;
        if self._asyncStep>=8 then
            G_GlobalGame:DispatchEventByStringKey("NotifyEnterGame");
            return true,100;
        end
    end
    if self._asyncPrecent>= 100 then
        self._asyncPrecent = 99;
    end
    return false,self._asyncPrecent;
end


--异步加载系列
function _CGameControl:_asyncLoadStep1(_runTime,_data)
    G_GlobalGame:Init();
    --初始化游戏管理
    self:Init();
    G_GlobalGame._mainPanel:Init();
    G_GlobalGame._mainPanel:InitSystem();
    --
    self:_createPlayers();
    return true;
end

function _CGameControl:_asyncLoadStep2(_runTime,_data)
    --创建UI
    G_GlobalGame:CreateUILayer();
    return true;
end

function _CGameControl:_asyncLoadStep3(_runTime,_data)
    --预加载游戏体
    return G_GlobalGame._goFactory:AsyncPreLoad(_runTime,_data);
end

function _CGameControl:_asyncLoadStep4(_runTime,_data)
    return G_GlobalGame:ControlGameEnter(_runTime);
end

function _CGameControl:_asyncLoadStep5(_runTime,_data)
    return true;
end

function _CGameControl:_asyncLoadStep6(_runTime,_data)
    return true;
end

function _CGameControl:_asyncLoadStep7(_runTime,_data)
    --等待场景消息完成
    return self._isAsyncLoadOver;
end

function _CGameControl:_createPlayers()
    if self.playersControl==nil then
        self.playersControl = _CPlayerControl.New();
        self.playersControl:Init();
    end
end

function _CGameControl:FixedUpdate(_dt)
    G_GlobalGame:FixedUpdate(_dt);
end

function _CGameControl:Update(dt)
    self._isPlaying = {};
--    local real = os.clock();
    if self.playersControl then
        self.playersControl:Update(dt);
    end
--    local time = ( os.clock() - real);
--    if time>=0.002 then
--        error("playersControl :" .. time);
--    end
--    local real = os.clock();
    G_GlobalGame:Update(dt);
--    local time = ( os.clock() - real);
--    if time>=0.002 then
--        error("G_GlobalGame :" .. time);
--    end
end

function _CGameControl:IsRunGame()
    return self._isRunGame;
end

function _CGameControl:InitSuccess()
    --异步加载完成
    self._isAsyncLoadOver = true;
    self._isRunGame = true;
    if not self._isInitSuccess then
        self._isInitSuccess = true;
    end
end

function _CGameControl:OnLoginOver()
    self._isLoginOver = true;
    error("登录成功!!");
    --开始时间
    self._beginTickCount    = Util.TickCount;
    --开始坐下
    G_GlobalGame._clientSession:SendSitDown();
    self._isSendSitDown = true;
    
end

--请求开始游戏
function _CGameControl:OnRequestStartGame(_bet)
    G_GlobalGame._clientSession:SendStartGame(_bet);
end

--请求开始点球大战
function _CGameControl:OnRequestStartSmallGame(_pos)
    self.smallGameRet.pos = _pos;
    G_GlobalGame._clientSession:SendStartSmallGame(_pos);
end

--请求彩金
function _CGameControl:OnRequestCaiJin()
    G_GlobalGame._clientSession:SendStartCaiJin();
end

function _CGameControl:OnResponseStartGame(_eventID,_eventData)
    self.caijin = _eventData.caijin;
    self.gameBet = _eventData.bet;
    self.lastGameRet.getGold = _eventData.addGold;
    self.lastGameRet.gameBet = _eventData.bet;
    self.lastGameRet.comGold = _eventData.comGold;
    local gameRet;
    if self.playersControl then
        gameRet = self.playersControl:OnPlayGameCallBack(_eventData);
    end
    G_GlobalGame:DispatchEventByStringKey("NotifyUIStartGameCB",_eventData.datas);
end

--小游戏数据返回
function _CGameControl:OnResponseSmallGame(_eventID,_eventData)
    self.caijin = _eventData.caijin;
    _eventData.pos = self.smallGameRet.pos;
    if self.playersControl then
        self.playersControl:OnSmallGameCallBack(_eventData);
    end 
    self.smallGameRet.getGold = _eventData.addGold;
    G_GlobalGame:DispatchEventByStringKey("NotifyUISmallGameCB",_eventData);  
end

function _CGameControl:OnResponseCaijin(_eventID,_eventData)
    self.caijin = _eventData.caijin;
    G_GlobalGame:DispatchEventByStringKey("NotifyUICaijin",_eventData);  
end

function _CGameControl:OnResetWarData(_eventID,_eventData)
    if self.playersControl then
        self.playersControl:OnResetWarData();
    end 
end

return _CGameControl;