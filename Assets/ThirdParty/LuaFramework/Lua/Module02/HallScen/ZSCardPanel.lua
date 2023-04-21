ZSCardPanel = {}
local self = ZSCardPanel
self.m_luaBeHaviour = nil
self.transform = nil

self.ZSCardResult = "ZSCardResult";

function ZSCardPanel.Init()
    self.transform = HallScenPanel.Pool("ZSCardPanel").transform;
    self.transform:SetParent(HallScenPanel.Compose.transform);
    self.transform.localPosition = Vector3.New(0, 0, 0);
    self.transform.localScale = Vector3.New(1, 1, 1);
    self.m_luaBeHaviour = self.transform:GetComponent("LuaBehaviour");
    if (self.m_luaBeHaviour == nil) then
        self.transform.gameObject:AddComponent(typeof(LuaBehaviour));
    end
end
function ZSCardPanel:Awake()
    self.m_luaBeHaviour = self.transform:GetComponent("LuaBehaviour");
    self.InitComponent();
    Event.AddListener(self.ZSCardResult, self.InitData);
    Event.AddListener(DuiHuanPanel.QueryCard, self.QueryCardResult);
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_DIANKA_QUERY, ByteBuffer.New(), gameSocketNumber.HallSocket);
end
function ZSCardPanel.InitComponent()
    self.SendBtn = self.transform:Find("Content/SendBtn").gameObject;
    self.closeBtn = self.transform:Find("Content/Close").gameObject;
    self.IdInput = self.transform:Find("Content/ID"):GetComponent("InputField");
    self.CountInput = self.transform:Find("Content/Count"):GetComponent("InputField");
    self.DKCount = self.transform:Find("Content/DKCount"):GetComponent("Text");
    self.m_luaBeHaviour:AddClick(self.SendBtn, self.OnClickReceive);
    self.m_luaBeHaviour:AddClick(self.closeBtn, self.OnClickCloseZS);
end
function ZSCardPanel.OnClickReceive(obj)
    if (string.len(self.IdInput.text) <= 0) then
        MessageBox.CreatGeneralTipsPanel("输入赠送ID有误，请重新输入!");
        return ;
    end
    if (string.len(self.CountInput.text) <= 0) then
        MessageBox.CreatGeneralTipsPanel("输入赠送数量有误，请重新输入!");
        return ;
    end
    local id = tonumber(self.IdInput.text);
    local count = tonumber(self.CountInput.text);
    self.SendBtn:GetComponent("Button").interactable = false;
    local buffer = ByteBuffer.New();
    buffer:WriteInt(id);
    buffer:WriteInt(tonumber(SCPlayerInfo._01dwUser_Id));
    buffer:WriteInt(count);
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_DIANKA_GIVE, buffer, gameSocketNumber.HallSocket);
    self.CountInput.text = "";
end
function ZSCardPanel.QueryCardResult(buffer)
    local count = buffer:ReadInt32();
    local time = buffer:ReadInt64Str();
    local id = buffer:ReadInt32();
    local ngold = buffer:ReadInt32();
    local card = buffer:ReadString(40);
    self.DKCount.text = "点卡剩余数量：" .. count .. " 张";
end
function ZSCardPanel.InitData(buffer)
    local count = buffer:ReadInt32();
    local dianka = buffer:ReadString(40);
    local msg = buffer:ReadString(100);
    MessageBox.CreatGeneralTipsPanel(msg);
    self.DKCount.text = "点卡剩余数量：" .. count .. " 张";
    self.SendBtn:GetComponent("Button").interactable = true;
end
function ZSCardPanel.OnClickCloseZS(obj)
    destroy(self.transform.gameObject);
end
function ZSCardPanel:OnDestroy()
    Event.RemoveListener(self.ZSCardResult, self.InitData);
    Event.RemoveListener(DuiHuanPanel.QueryCard, self.QueryCardResult);
    self.transform = nil;
    self.m_luaBeHaviour = nil;
end
