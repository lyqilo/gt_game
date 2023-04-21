DuiHuanPanel = {}
local self = DuiHuanPanel
self.m_luaBeHaviour = nil
self.transform = nil

self.QueryCard = "QueryCard";
self.ReceiveCard = "ReceiveCard";

function DuiHuanPanel.Init(_luaBeHaviour)
    if SCPlayerInfo.IsVIP == 1 then
        MessageBox.CreatGeneralTipsPanel("VIP不能进行该操作");
        return ;
    end
    self.transform = HallScenPanel.Pool("DuiHuanPanel").transform;
    self.transform:SetParent(HallScenPanel.Compose.transform);
    self.transform.localPosition = Vector3.New(0, 0, 0);
    self.transform.localScale = Vector3.New(1, 1, 1);
    self.transform.localScale = Vector3.New(GameManager.ScreenRate, GameManager.ScreenRate, GameManager.ScreenRate);
    self.m_luaBeHaviour = _luaBeHaviour;
    self.InitComponent();
    Event.AddListener(self.QueryCard, self.InitData);
    Event.AddListener(self.ReceiveCard, self.OnReceiveData);
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_DIANKA_QUERY, ByteBuffer.New(), gameSocketNumber.HallSocket);
end
function DuiHuanPanel.InitComponent()
    self.group = self.transform:Find("Content/Group");
    self.ReceiveBtn = self.transform:Find("Content/ReceiveBtn").gameObject;
    self.GrouoItem = self.group:Find("Item");
    self.Id = self.GrouoItem:Find("ID"):GetComponent("Text");
    self.Timer = self.GrouoItem:Find("Time"):GetComponent("Text");
    self.Card = self.GrouoItem:Find("Card"):GetComponent("Text");
    self.Gold = self.GrouoItem:Find("Gold"):GetComponent("Text");
    self.closeBtn = self.transform:Find("Content/Close").gameObject;
    self.m_luaBeHaviour:AddClick(self.ReceiveBtn, self.OnClickReceive);
    self.ReceiveBtn:SetActive(false);
    self.m_luaBeHaviour:AddClick(self.closeBtn, self.OnClickCloseDuihuan);
end
function DuiHuanPanel.OnClickReceive(obj)
    self.ReceiveBtn:GetComponent("Button").interactable = false;
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_DIANKA_RECEIVE, ByteBuffer.New(), gameSocketNumber.HallSocket);
end
function DuiHuanPanel.InitData(buffer)
    Event.RemoveListener(self.QueryCard, self.InitData);
    self.GrouoItem.gameObject:SetActive(true);
    local count = buffer:ReadInt32();
    local time = buffer:ReadInt64Str();
    local id = buffer:ReadInt32();
    local ngold = buffer:ReadInt32();
    local card = buffer:ReadString(40);
    log("count:" .. count);
    self.ReceiveBtn:SetActive(count > 0);
    if count <= 0 then
        return ;
    end
    self.Id.text = tostring(id);
    self.Timer.text = os.date("%Y-%m-%d", time);
    self.Card.text = card;
    self.Gold.text = tostring(ngold);
end
function DuiHuanPanel.OnReceiveData(buffer)
    Event.RemoveListener(self.ReceiveCard, self.OnReceiveData);
    local ngold = buffer:ReadInt32();
    local card = buffer:ReadString(40);
    local msg = buffer:ReadString(100);
    MessageBox.CreatGeneralTipsPanel(msg);
    local _bf = ByteBuffer.New()
    _bf:WriteUInt32(SCPlayerInfo._01dwUser_Id) -- 玩家ID
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_SELECT_GOLD_MSG, _bf, gameSocketNumber.HallSocket)
    self.GrouoItem.gameObject:SetActive(false);
    self.ReceiveBtn:SetActive(false);
    self.ReceiveBtn:GetComponent("Button").interactable = true;
end
function DuiHuanPanel.OnClickCloseDuihuan(obj)
    destroy(self.transform.gameObject);
end
