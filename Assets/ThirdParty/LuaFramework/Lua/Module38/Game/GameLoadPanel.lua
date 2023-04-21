--加载器
local LoadPanel       = GameRequire__("LoadPanel");

local GameLoadPanel = class("GameLoadPanel",LoadPanel);

local _v_point_interval = 0.5;

function GameLoadPanel:ctor()
    --加载loadPanel
    local loadPanel   = G_GlobalGame._goFactory:createLoadPanel();
    local loadPanelTransform = loadPanel.transform;
    GameLoadPanel.super.ctor(self,loadPanelTransform);
    
    --loading背景适配
    loadPanel.transform:Find("BG"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);

    loadPanelTransform:SetParent(G_GlobalGame._overLayer);
    loadPanelTransform.localPosition = C_Vector3_Zero;
    loadPanelTransform.localScale    = C_Vector3_One;
    loadPanelTransform.localRotation = Quaternion.Euler(0,0,0);

    self.bgTransform  = loadPanelTransform:Find("BG");
    self.text         = loadPanelTransform:Find("Text"):GetComponent("Text");

    GameLoadPanel.super.ctor(self,loadPanelTransform);

    --
    self.pointTime = _v_point_interval;
    self.pointCount = 1;
end


function GameLoadPanel:Update(_dt)
    if GameLoadPanel.super.IsLoading(self) then
        GameLoadPanel.super.Update(self,_dt);
        self.pointTime = self.pointTime - _dt;
        if self.pointTime<=0 then
            if self.pointCount == 1 then
                self.text.text = "正在加载中··";
                self.pointCount = 2;
            elseif self.pointCount ==2 then
                self.text.text = "正在加载中···";
                self.pointCount = 3;
            elseif self.pointCount ==3 then
                self.text.text = "正在加载中·";
                self.pointCount = 1;
            end
            self.pointTime = _v_point_interval;
        end
        if not GameLoadPanel.super.IsLoading(self) then

        end 
    end
end

function GameLoadPanel:AsyncLoad(handler,_data,handler2)
    self.handler2 = handler2;
    GameLoadPanel.super.AsyncLoad(self,handler,_data);
    self.pointTime = _v_point_interval;
    self.pointCount = 1;
    self.text.text = "正在加载中·";
end

--直接显示
function GameLoadPanel:Show()
    if self.gameObect then
        self.gameObject:SetActive(true);
    end
end

--直接隐藏
function GameLoadPanel:Hide()
    if self.gameObect then
        self.gameObject:SetActive(false);
    end
end


function GameLoadPanel:OnLoadOver()
    GameLoadPanel.super.OnLoadOver(self);
    if self.handler2 then
        self.handler2();
    end
end


return GameLoadPanel;