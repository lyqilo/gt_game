require "Module25/Strawberry/Strawberry_GameNet"
require "Module25/Strawberry/Strawberry_MainPanel"
require "Module25/Strawberry/Strawberry_MaryPanel"

Strawberry_Scen = {}
local self = Strawberry_Scen;
Game14Panel = Strawberry_Scen;
cn_strawberry_help = {
    ab = 'game_strawberry_help',
    name = 'HelpPanel',
}

cn_strawberry_main = {
    ab = 'game_strawberry_main',
    name = 'MainPanel',
}

cn_strawberry_mary = {
    ab = 'game_strawberry_mary',
    name = 'MaryPanel',
}

cn_strawberry_canvas = {
    ab = 'game_strawberry_canvas',
    name = 'Strawberry_Canvas',
}

cn_strawberry_music = {
    ab = 'game_strawberry_music',
    name = 'Music',
}

local gameObject;
function Strawberry_Scen:New(o)
    local t = o or {};
    setmetatable(t, self);
    self.__index = self
    return t;
end
function Strawberry_Scen:Begin(obj)
    Event.AddListener(HallScenPanel.ReconnectEvent, self.Reconnect);
    error("__________");
    self.father = obj.transform;
    self.CreatScen(obj);
end

function Strawberry_Scen.CreatScen(obj)
    -- error("____luaBehaviour____");
    --local obj = find("Canvas");
    --  Util.AddComponent("SceneSaveEditor", self.father.parent.gameObject);
    obj.transform:SetParent(self.father);
    obj.transform.localScale = Vector3.one;
    obj.transform.localPosition = Vector3.New(0, 0, 0);
    GameManager.PanelRister(self.father.gameObject);
    local luaBehaviour = self.father:GetComponent('LuaBehaviour');
    self.luaBehaviour = luaBehaviour;
    --��¼��Ϸ
    Strawberry_GameNet.gamelogon()
    GameManager.GameScenIntEnd(); --���ؼ��ϰ�ť
    Strawberry_MainPanel.Start(obj);
    GameManager.PanelInitSucceed(self.father.gameObject);
    if (not Util.isPc) then
        GameSetsBtnInfo.SetPlaySuonaPos(-85, 326, 0)
    end
end

function Strawberry_Scen:Update()
    
end
function Strawberry_Scen:FixedUpdate()
    Strawberry_MainPanel.FixedUpdate();
end

function Strawberry_Scen.Reconnect()
    log("重连成功")
    Strawberry_GameNet.ReLoadGame();
end
function Strawberry_Scen:OnDestroy()
    Event.RemoveListener(HallScenPanel.ReconnectEvent, self.Reconnect);
end