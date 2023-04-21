require "Module39/tjz/tjz_BtnPanel"
require "Module39/tjz/tjz_CMD"
require "Module39/tjz/tjz_Config"
require "Module39/tjz/tjz_Data"
require "Module39/tjz/tjz_Event"
require "Module39/tjz/tjz_LianLine"
require "Module39/tjz/tjz_MainPanel"
require "Module39/tjz/tjz_NumRolling"
require "Module39/tjz/tjz_PushFun"
require "Module39/tjz/tjz_Rule"
require "Module39/tjz/tjz_Run_Soon_Item"
require "Module39/tjz/tjz_RunCont_Item"
require "Module39/tjz/tjz_Socket"
require "Module39/tjz/tjz_TSAnima"

tjz_InitProt = {}
local self = tjz_InitProt;

local gameObject;
function tjz_InitProt.Awake()
    Event.AddListener(HallScenPanel.ReconnectEvent, self.Reconnect);
    tjz_Socket.initdataandres();
    self.loadPerCom();
end

function tjz_InitProt:OnDestroy()
    Event.RemoveListener(HallScenPanel.ReconnectEvent, self.Reconnect);
end

--回到游戏
function tjz_InitProt:Reconnect()
    logYellow("回到游戏")
    tjz_Socket.playerLogon()

    logYellow("byFreeCnt==" .. tjz_Data.byFreeCnt)
    logYellow("isAutoGame==" .. tostring(tjz_Data.isAutoGame))
    logYellow("bReturn==" .. tostring(tjz_Data.bReturn))

    coroutine.start(tjz_InitProt._WaitTime)
end

function tjz_InitProt:_WaitTime()

    coroutine.wait(1.5)
    if tjz_Data.byFreeCnt >= 1 or tjz_Data.isAutoGame == true or tjz_Data.bReturn then
        tjz_Socket.gameOneOver2(false)
    else
        coroutine.wait(1)
        tjz_Event.dispathEvent(tjz_Event.xiongm_show_start_btn);
    end
end

function tjz_InitProt.loadPerCom()
    local father = GameObject.Find("tjz_InitProt").transform;
    local obj = father.transform:Find("tjz_main");
    obj.transform:Find("bottomcont").gameObject:SetActive(false);
    obj.transform:Find("bottomcont/allfreegoldcont").gameObject:SetActive(false);
    obj.transform:Find("rulecont").gameObject:SetActive(false);
    if Util.isPc then
        obj.transform:Find("mycarcam").transform.localRotation = Vector3.New(0, 0, 0);
    end
    obj.transform:Find("mycarcam").transform.localRotation = Vector3.New(0, 0, 0);
    obj.gameObject:GetComponent('CanvasScaler').referenceResolution = Vector2.New(1334, 750);
    SetCanvasScalersMatch(obj.gameObject:GetComponent('CanvasScaler'), 1);
    gameObject = father.gameObject;    --obj:SetActive(true);

    GameManager.PanelRister(gameObject);
    local luaBehaviour = father.transform:GetComponent('LuaBehaviour');
    tjz_Data.luabe = luaBehaviour;
    GameManager.PanelInitSucceed(gameObject);
    tjz_MainPanel.Start(obj, father);

end

function tjz_InitProt.Update()
    tjz_MainPanel.Update();
end
function tjz_InitProt.FixedUpdate()
    tjz_MainPanel.FixedUpdate();
end

