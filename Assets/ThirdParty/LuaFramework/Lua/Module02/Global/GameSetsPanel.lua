GameSetsPanel = {};
local self = GameSetsPanel;
local gameObject;
local transform;
local LBH;
local gameObj

function GameSetsPanel:New()
    local t = o or { };
    setmetatable(t, { __index = GameSetsPanel });
    return t;
end

function GameSetsPanel.Create()
    self.CreateCallBack(HallScenPanel.Pool("GameSetsPanel"));
end

function GameSetsPanel.CreateCallBack(go)
    local tag = {};

    tag = GameObject.FindGameObjectsWithTag("GuiCamera");
    error("找到几个摄像机=" .. tag.Length)
    if tag.Length < 2 then
        error("not find GuiCamera transform!!!");
        go.transform:SetParent(tag[0].transform);
    else
        go.transform:SetParent(tag[1].transform);
    end ;

    go.name = "GameSetsPanel";
    go.transform.localScale = Vector3.one;
    go.transform.localRotation = Quaternion.identity;
    go.transform.localPosition = Vector3.New(0, 0, 0);
    gameObj = go;
    local rect = go.transform.parent:GetComponent("RectTransform");
    if rect == nil then
        rect = go.transform.parent.gameObject:AddComponent(typeof(UnityEngine.RectTransform));
    end
    logError(tostring(rect==nil))
    rect.anchorMax = Vector2.New(1,1);
    rect.anchorMin = Vector2.New(0,0);
    rect.offsetMax = Vector2.New(0,0);
    rect.offsetMin = Vector2.New(0,0);
    
    Util.AddComponent("LuaBehaviour", go);
    local luaSelf = LogonScenPanel:New();
    luaSelf.LuaBehaviour = go:GetComponent("LuaBehaviour");
    --luaSelf.LuaBehaviour:SetLuaTab(luaSelf, "GameSetsPanel");--新版本不需要了
    PublicMessageBox.setLuaBeHavi(luaSelf.LuaBehaviour);
end
function GameSetsPanel.CreateHideObj(parent, isShow)
    local go = HallScenPanel.Pool("GameSetsPanel");
    go.transform:SetParent(parent);
    go.transform.localScale = Vector3.one;
    go.transform.localRotation = Quaternion.identity;
    go.transform.localPosition = Vector3.New(0, 0, 0);
    gameObj = go;
    Util.AddComponent("LuaBehaviour", go);
    gameObj.transform:Find("SetsBtn").gameObject:SetActive(isShow);
end
function GameSetsPanel:CreateNew(go)
    if gameObj == nil then
        return ;
    end
    gameObj.transform:SetParent(go.transform);
    gameObj.name = "GameSetsPanel"
    gameObj.transform.localScale = Vector3.one
    gameObj.transform.localPosition = Vector3.New(0, 0, 0)
    gameObj.transform.localRotation = Quaternion.identity;
    if gameObj:GetComponent("LuaBehaviour") == nil then
        Util.AddComponent("LuaBehaviour", gameObj)
    end
    local luaSelf = LogonScenPanel:New()
    luaSelf.LuaBehaviour = gameObj:GetComponent("LuaBehaviour")
    PublicMessageBox.setLuaBeHavi(luaSelf.LuaBehaviour)
    gameObj.transform:Find("SetsBtn").gameObject:SetActive(false);

end
function GameSetsPanel:Begin(obj)
    gameObject = obj;
    transform = obj.transform;
end

function GameSetsPanel:Start()
    LBH = transform:GetComponent('LuaBehaviour');
    GameSetsBtnInfo.Init(gameObject, LBH)
end

function GameSetsPanel:Update()
    GameSetsBtnInfo.Update();
end