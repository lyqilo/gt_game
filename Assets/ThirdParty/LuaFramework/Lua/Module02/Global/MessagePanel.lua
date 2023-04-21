local transform;
local gameObject;

MessagePanel = {};
local self = MessagePanel;

--启动事件--
function MessagePanel:Awake(obj)
	gameObject = obj;
	transform = obj.transform;

	self:InitPanel();
	GameManager.Log("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function MessagePanel:InitPanel()
	self.btnClose = transform:Find("Button").gameObject;
end

--单击事件--
function MessagePanel.OnDestroy()
	log("OnDestroy---->>>");
end

