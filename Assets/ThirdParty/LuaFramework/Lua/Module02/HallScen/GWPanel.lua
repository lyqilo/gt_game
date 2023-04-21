GWPanel = {}
local self = GWPanel

self.transform = nil

function GWPanel.Init()
    if self.transform == nil then
        self.transform = HallScenPanel.Pool("GWPanel").transform;
        self.transform:SetParent(HallScenPanel.Compose.transform);
        self.transform.localPosition = Vector3.New(0, 0, 0);
        self.transform.localScale = Vector3.New(1, 1, 1);
    end

    self.transform.gameObject:SetActive(true)

    self.CloseBtn = self.transform:Find("Content/CloseBtn"):GetComponent("Button");
    self.GWURL = self.transform:Find("Content/GWURL"):GetComponent("Text");
    self.CopyBtn = self.transform:Find("Content/Copy"):GetComponent("Button");
    self.GWURL.text = LogonScenPanel.GWData.GWUrl;
    self.CloseBtn.onClick:RemoveAllListeners();
    self.CopyBtn.onClick:RemoveAllListeners();
    self.CloseBtn.onClick:AddListener(function()
        self.OnClickClose();
    end);
    self.CopyBtn.onClick:AddListener(function()
        local str = self.GWURL.text;
        Util.CopyStr(str);
        MessageBox.CreatGeneralTipsPanel("官网复制成功");
    end);

end

function GWPanel.Open()
    if self.transform == nil then
        self.Init();
    else
        self.transform.gameObject:SetActive(true)
    end
end
function GWPanel.OnClickClose()
    HallScenPanel.PlayeBtnMusic()
    destroy(self.transform.gameObject)
    self.m_luaBeHaviour = nil
    self.transform = nil
end