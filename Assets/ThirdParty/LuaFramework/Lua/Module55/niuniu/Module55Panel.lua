require "Module55.niuniu.TBNNPanel"

Module55Panel = { };
local self = Module55Panel;
local gameObject;

function Module55Panel:Awake(obj)
    Screen.orientation = UnityEngine.ScreenOrientation.Landscape;
    Screen.autorotateToLandscapeLeft = true;
    Screen.autorotateToLandscapeRight = true;
    Screen.autorotateToPortrait = false;
    Screen.autorotateToPortraitUpsideDown = false;
    self.modulePanel = obj.transform;
    self.CallBack(Module55Panel.Pool("NiuNiu"));
end

function Module55Panel.CallBack(obj)
    obj.name = "TBNNPanel";
    obj.transform:SetParent(self.modulePanel.transform);
    obj.transform.localScale = Vector3.one;
    obj.transform.localPosition = Vector3.New(0, 0, 0);
    Util.AddComponent("LuaBehaviour", obj);
    local luaBehaviour = obj.transform:GetComponent("LuaBehaviour");
    local objcanvas = obj.transform:GetComponent('CanvasScaler')
    SetCanvasScalersMatch(objcanvas, 1);
    local t = TBNNPanel:New();
end

function Module55Panel.Pool(prefabName)
    if self.prefabPool == nil then
        self.prefabPool = { };
        local t = self.modulePanel.transform:Find("Pool");
        local n = t.transform.childCount - 1;
        for i = 0, n do
            local ct = t.transform:GetChild(i).gameObject;
            ct.gameObject:SetActive(false);
            self.prefabPool[ct.name] = ct;
        end
    end
    local t = self.prefabPool[prefabName] or nil;
    if t == nil then
        error("not find pool " .. prefabName);
        return nil
    end
    local obj = newobject(t);
    obj:SetActive(true);
    obj.name = prefabName;
    return obj;
end

function Module55Panel.ShowText(str)
    --展示tmp字体
    local arr = self.ToCharArray(str);
    local _str = "";
    for i = 1, #arr do
        _str = _str .. string.format("<sprite name=\"%s\">", arr[i]);
    end
    return _str;
end

function Module55Panel.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end