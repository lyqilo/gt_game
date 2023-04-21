local GameDefine = GameRequire__("GameDefine");
local KeyEvent   = GameRequire__("KeyEvent");
local EventSystem = GameRequire__("EventSystem");
local _CPlayerControl = GameRequire__("PlayerControl");
local _CGameControl = class("GameControl");
local Enum_GameState = GameDefine.EnumGameState();


--===========游戏主控制界面================--

function _CGameControl:ctor(...)
    self._isPlaying  = {};

    self.gameState = Enum_GameState.EM_GameState_Null;
    self.caijin    = 0;
    self.lastGameRet = {getGold = 0,gameBet = 0,comGold = 0};
    self.ballGameRet = {gameRet=GameDefine.EnumGoalType().EM_GoalValue_Null,getGold = 0};
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
    --事件注册
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetBet,handler(self,self.OnKey_GetBet));  --获取下注值
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetGameState,handler(self,self.OnKey_GetGameState));--获取游戏状态
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetGameRet,handler(self,self.OnKey_GetGameRet));--获取游戏结算
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetUserGold,handler(self,self.OnKey_GetUserGold));--获得用户金币
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetGameBallRet,handler(self,self.OnKey_GetGameBallRet));--获取游戏足球比赛
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetCaijin,handler(self,self.OnKey_GetCaijin));--获取彩金
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetFreeCount,handler(self,self.OnKey_GetFreeCount));--获取免费次数
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetCanStartGame,handler(self,self.OnKey_GetCanStartGame));--开始游戏
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetMultiple,handler(self,self.OnKey_GetMultiple));--获取倍率
    KeyEvent.SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetFreeTotal,handler(self,self.OnKey_GetFreeTotal));--获取免费统计
    G_GlobalGame:RegEventByStringKey("GameData",self,self.OnGameData);--游戏数据      10002
    G_GlobalGame:RegEventByStringKey("ChairsData",self,self.OnChairsData);--椅子数据      10003
    G_GlobalGame:RegEventByStringKey("UserEnter",self,self.OnUserEnter);--玩家進入      10004
    G_GlobalGame:RegEventByStringKey("UserLeave",self,self.OnUserLeave);--玩家離開      10005

    G_GlobalGame:RegEventByStringKey("ChangeBet",self,self.OnChangeBet);--改变下注       10017

    G_GlobalGame:RegEventByStringKey("StartGame",self,self.OnStartGame);--开始游戏       10009
    G_GlobalGame:RegEventByStringKey("StartBallGame",self,self.OnStartBallGame);--请求开始点球       10010

    G_GlobalGame:RegEventByStringKey("ResponseStartGame",self,self.OnResponseStartGame);--开始游戏 10011 
    G_GlobalGame:RegEventByStringKey("ResponseBallGame",self,self.OnResponseBallGame);--点球10012
    G_GlobalGame:RegEventByStringKey("ResponseCaijin",self,self.OnResponseCaijin);--彩金10013
end

--座位玩家信息
function _CGameControl:OnChairsData(_eventID,_eventData)
    if self.playersControl then
        self.playersControl:OnChairsData(_eventData);
    end
end

--全局游戏数据
function _CGameControl:OnGameData(_eventID,_eventData)
    if _eventData.userState == 0 then
        self.gameState = Enum_GameState.EM_GameState_Null;
    elseif _eventData.userState == 1 then
        self.gameState = Enum_GameState.EM_GameState_BallGame;
    elseif _eventData.userState == 2 then
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

--玩家进入--y
function _CGameControl:OnUserEnter(_eventID,_eventData)
    --error("玩家进入")
    if self.playersControl then
        self.playersControl:OnUserEnter(_eventData);
    end
end

--玩家离开--y
function _CGameControl:OnUserLeave(_eventID,_eventData)
    --error("玩家离开")
    if self.playersControl then
        self.playersControl:OnUserLeave(_eventData);
    end
end

function _CGameControl:OnChangeBet(_eventID,_bet)
    --error("改变下注值")
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

--客户端发送点球
function _CGameControl:OnStartBallGame(_eventID,_pos)
    --开始点球
    self:OnRequestStartBallGame(_pos);
end

--获取下注值
function _CGameControl:OnKey_GetBet()
    return self.gameBet;
end

--获取游戏状态
function _CGameControl:OnKey_GetGameState()
    return self.gameState;
end

function _CGameControl:OnKey_GetGameRet()
    return self.lastGameRet.gameBet,self.lastGameRet.getGold,self.lastGameRet.comGold,self.playersControl:GetSelfGameRet();
end

function _CGameControl:OnKey_GetGameBallRet()
    return self.ballGameRet.gameRet,self.ballGameRet.getGold;
end

--获取彩金
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

--获取金币
function _CGameControl:OnKey_GetUserGold()
    if self.playersControl then
        local player =  self.playersControl:MyPlayer();
        return player:GetGold();
    end
end

--获取免费次数
function _CGameControl:OnKey_GetFreeCount()
    if self.playersControl then
        local player =  self.playersControl:MyPlayer();
        return player:FreeCount();
    end
end

--获取是否可以开始免费游戏
function _CGameControl:OnKey_GetCanStartGame()
    local maxLine = GameDefine.MaxLine();
    if self.playersControl:OnCanReduceFreeCount(1) or 
        self.playersControl:OnCanRechargeGold(self.gameBet*maxLine) then
        return true;
    end
    return false;
end

--获取倍数
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

function _CGameControl:Update(dt)
    self._isPlaying = {};
end

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
function _CGameControl:OnAsyncLoad(_runTime,data)
    if self._asyncPrecent<90 then
        self._asyncPrecent = self._asyncPrecent + math.random(2,5);
    else
        self._asyncPrecent = self._asyncPrecent + 1;
    end
    local isStepOver = false;
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
    elseif self._asyncStep == 6 then
        isStepOver = self:_asyncLoadStep6(_runTime,data);    
    elseif self._asyncStep == 7 then
        isStepOver = self:_asyncLoadStep7(_runTime,data);  
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
   -- error("异步加载完成")
    return false,self._asyncPrecent;
end


--异步加载系列
function _CGameControl:_asyncLoadStep1(_runTime,_data)
    --error("初始化游戏管理");
    G_GlobalGame:Init();
    --初始化游戏管理
    self:Init();
    G_GlobalGame._mainPanel:Init();
    G_GlobalGame._mainPanel:InitSystem();
    --
    --同步模式登陸可以提前
    G_GlobalGame._clientSession:SendLogin(); 
    return true;
end

function _CGameControl:_asyncLoadStep2(_runTime,_data)
   -- error("玩家控制");

    self.playersControl = _CPlayerControl.New();
    self.playersControl:Init();
    return true;
end

function _CGameControl:_asyncLoadStep3(_runTime,_data)
    --error("创建UI");

    --创建UI
    G_GlobalGame:CreateUILayer();
    return true;
end

function _CGameControl:_asyncLoadStep4(_runTime,_data)
    --error("_asyncLoadStep4==".._runTime);

    return true;
end

function _CGameControl:_asyncLoadStep5(_runTime,_data)
    --error("预加载游戏体".._runTime);

    --预加载游戏体
    return G_GlobalGame._goFactory:AsyncPreLoad(_runTime,_data);
end

function _CGameControl:_asyncLoadStep6(_runTime,_data)
    error("开始时间");

    --开始时间
    self._beginTickCount    = Util.TickCount;
    if self._isLoginOver then
        --G_GlobalGame._clientSession:SendSitDown();
        self._isSendSitDown = true;
    end
    return self._isSendSitDown;
end

function _CGameControl:_asyncLoadStep7(_runTime,_data)
    --error("等待场景消息完成");
    --等待场景消息完成
    return self._isAsyncLoadOver;
end

function _CGameControl:FixedUpdate(_dt)
    G_GlobalGame:FixedUpdate(_dt);
end

function _CGameControl:Update(dt)
    if self.playersControl then
        self.playersControl:Update(dt);
    end
    G_GlobalGame:Update(dt);
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
end




--请求开始游戏
function _CGameControl:OnRequestStartGame(_bet)
    G_GlobalGame._clientSession:SendStartGame(_bet);
end

--请求开始点球大战
function _CGameControl:OnRequestStartBallGame(_pos)
    G_GlobalGame._clientSession:SendStartBallGame();
end

--请求彩金
function _CGameControl:OnRequestCaiJin()

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

        -- error("游戏结果!!");
        -- if gameRet.isCup then
        --     error("大力神杯!!");
        -- end
        -- if gameRet.isFreeGame then
        --     error("免费游戏!!");
        -- end
        local lineCount = #gameRet.lines;
        logTable(gameRet.lines);
        -- for i=1,lineCount do
        --     local line = gameRet.lines[i];
        --     --.. ",multipe:" .. line.multipe
        --     error("Line No:" .. line.lineNO .. ",value:" .. line.value .. ",count:" .. line.count );
        -- end

    end
    G_GlobalGame:DispatchEventByStringKey("NotifyUIStartGameCB",_eventData.datas);
end

function _CGameControl:OnResponseBallGame(_eventID,_eventData)
    self.caijin = _eventData.caijin;
    self.ballGameRet.gameRet = _eventData.ret;--免费奖励的类型 0 没有， 1金币奖励	2 金币翻倍 
    self.ballGameRet.getGold = _eventData.addGold;
    if self.playersControl then
        self.playersControl:OnBallGameCallBack(_eventData);
    end
    G_GlobalGame:DispatchEventByStringKey("NotifyUIBallGameCB",_eventData.ret);  
    error("接收到服务器点球通知，开始通知UI界面开始点球")
end

function _CGameControl:OnResponseCaijin(_eventID,_eventData)
    self.caijin = _eventData.caijin;
end

return _CGameControl;