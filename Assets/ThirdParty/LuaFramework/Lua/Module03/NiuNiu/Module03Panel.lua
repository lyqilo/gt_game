require "Module03.NiuNiu.NiuNiuPanel"

Module03Panel = { };
local self = Module03Panel;
local gameObject;

function Module03Panel:Awake(obj)
    self.modulePanel=obj.transform;
    Screen.orientation = UnityEngine.ScreenOrientation.Landscape;
    Screen.autorotateToLandscapeLeft = true;
    Screen.autorotateToLandscapeRight = true;
    Screen.autorotateToPortrait = false;
    Screen.autorotateToPortraitUpsideDown = false;
    self.CallBack(Module03Panel.Pool("NiuNiu"));
end

function Module03Panel.CallBack(obj)
    obj.name = "NiuNiuPanel";
    obj.transform:SetParent(self.modulePanel.transform);
    obj.transform.localScale = Vector3.one;
    obj.transform.localPosition = Vector3.New(0, 0, 0);
    Util.AddComponent("LuaBehaviour", obj);
    local luaBehaviour = obj.transform:GetComponent("LuaBehaviour");
    local objcanvas=obj.transform:GetComponent('CanvasScaler')
    SetCanvasScalersMatch(objcanvas,1)
    objcanvas.referenceResolution = Vector2.New(1334, 750);
    obj.transform:Find("Camera").localRotation = Quaternion.identity;
    obj.transform:Find("Camera"):GetComponent('Camera').clearFlags = UnityEngine.CameraClearFlags.SolidColor


    local t = NiuNiuPanel:New();
end

function Module03Panel.Pool(prefabName)
    if self.prefabPool == nil then
        self.prefabPool = { };
        local t = self.modulePanel.transform:Find("Pool");
        local n = t.transform.childCount-1;
        for i = 0, n do
            local ct = t.transform:GetChild(i).gameObject;
            ct.gameObject:SetActive(false);
            self.prefabPool[ct.name] = ct;
        end
    end
    local t = self.prefabPool[prefabName] or nil;
    if t == nil then error("not find pool "..prefabName); return nil end
    local obj=newobject(t);
    obj:SetActive(true);
    obj.name=prefabName;
    return obj;
end