local AlertStaticPanel=class("AlertStaticPanel")

function AlertStaticPanel:ctor(_parent,_context,_title)
    self._okHandler    = _okHandler;
    self._alertObj      = GlobalGame._gameObjManager:CreateAlertStatic();
    self.transform      = self._alertObj.transform;
    local localScale    = self.transform.localScale;
    local localPosition = self.transform.localPosition;
    self.transform:SetParent(_parent);
    self.transform.localScale = localScale;
    self.transform.localPosition = localPosition;
--    self._okBtn = Util.AddComponent("EventTriggerListener",self.transform:Find("YesBtn").gameObject);
--    self._okBtn.onClick = handler(self,self.OnOKClick);
    self._closeBtn = Util.AddComponent("EventTriggerListener",self.transform:Find("Mask").gameObject);
    self._closeBtn.onClick = handler(self,self.OnOKClick);
    self.bgTransform = self.transform:Find("Bg");
    self._tips  = self.bgTransform:Find("Content").gameObject:GetComponent("Text");
    self._tips.text = _context;
    self._tips.resizeTextForBestFit = false;
    self._title = self.bgTransform:Find("Title"):GetComponent("Text");
    self._fontSize=26;
    if _title then
        self._title.text = _title;
    else
        --self._title.text = String.Empte;
    end
end

function AlertStaticPanel:SetContext(_context,_fontsize)
    self._tips.text = _context;
    if _fontsize then
        self._tips.fontSize = _fontsize;
    end
end

function AlertStaticPanel:SetContextFontSize(_fontsize)
    self._tips.fontSize = _fontsize;
end

function AlertStaticPanel:SetTitle(_title,_fontsize)
    self._title.text = _title;
    if _fontsize then
        self._title.fontSize = _fontsize;
    end
end

function AlertStaticPanel:SetTitleFontSize(_fontsize)
    self._title.fontSize = _fontsize;
end

function AlertStaticPanel:SetOKHandler(_okHandler)
    self._okHandler    = _okHandler;
end

function AlertStaticPanel:OnOKClick()
    if self._okHandler then
        local ret = self._okHandler();
        if ret or ret==nil then
            self:_close();
        end
    else
        self:_close();
    end
end

function AlertStaticPanel:OnCloseClick()
    self:Close();
end

function AlertStaticPanel:Close()
    self:_close();
end

--关闭
function AlertStaticPanel:_close()
    GameObject.Destroy(self._alertObj);
end

return AlertStaticPanel;