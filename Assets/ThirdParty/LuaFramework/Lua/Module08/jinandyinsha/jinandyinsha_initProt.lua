jinandyinsha_initProt = {}
local self = jinandyinsha_initProt;

require 'Module08/jinandyinsha/BirdsAndBeastPanel';

local gameObject;
function jinandyinsha_initProt.Awake()
    BirdsAndBeast_Socket.initdataandres();
    self.loadPerCom();
    --ResManager:LoadAsset('game_birdsandbeast', 'birdsandbeastmain',self.loadPerCom); 
    --- LoadAssetAsync('module08/game_birdsandbeast', 'birdsandbeastmain',self.loadPerCom,true,true); 
end

function jinandyinsha_initProt.loadPerCom()
    --error("____luaBehaviour____");
    --local obj = newobject(arg);    
    -- local father = GameObject.Find("jinandyinsha_initProt").transform;
    -- local obj = father.transform:Find("birdsandbeastmain");
    -- SetCanvasScalersMatch(obj.gameObject:GetComponent('CanvasScaler'));
    local father = GameObject.Find("jinandyinsha_initProt").transform;
    local obj = father.transform:Find("birdsandbeastmain");
    obj.gameObject:GetComponent('CanvasScaler').matchWidthOrHeight = 1;
    SetCanvasScalersMatch(obj.gameObject:GetComponent('CanvasScaler'),1);
    obj.transform:GetComponent("CanvasScaler").referenceResolution = Vector2.New(1334,750);
    obj.transform:Find("mycarcam").localRotation=Vector3.New(0,0,0)

    local bg = GameObject.New("BgImage"):AddComponent(typeof(UnityEngine.UI.Image));
    bg.transform:SetParent(obj);
    bg.transform:SetAsFirstSibling();
    bg.transform.localPosition = Vector3(0, 0, 0);
    bg.transform.localScale = Vector3(1, 1, 1);
    bg.sprite = HallScenPanel.moduleBg:Find("module08"):GetComponent("Image").sprite;
    bg:GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
    --    obj.transform:SetParent(father);
    --    obj.transform.localScale=Vector3.one;
    --    obj.transform.localPosition=Vector3.New(0,0,0);
    gameObject = father.gameObject;
    obj.gameObject:SetActive(true);
    GameManager.PanelRister(gameObject);
    --Util.AddComponent("LuaBehaviour", obj);
    --local luaBehaviour = obj.transform:GetComponent("LuaBehaviour");
    local luaBehaviour = father.transform:GetComponent('LuaBehaviour');
    --local t = BirdsAndBeastPanel:New();
    if luaBehaviour == nil then
        --error("____luaBehaviour____");
    end
    BirdsAndBeastPanel.luabe = luaBehaviour;
    --BirdsAndBeastPanel.Start(obj);   
    --luaBehaviour:SetLuaTab(BirdsAndBeastPanel, "BirdsAndBeastPanel");
    GameManager.PanelInitSucceed(gameObject);
    --    coroutine.start(function(args)
    --        coroutine.wait(0.01);
    BirdsAndBeastPanel.Start(obj, father);
    --end);
    --error("__11__luaBehaviour____");
end

function jinandyinsha_initProt.Update()
    --BirdsAndBeastPanel.Update();
end

function jinandyinsha_initProt.FixedUpdate()
    BirdsAndBeastPanel.Update();
end