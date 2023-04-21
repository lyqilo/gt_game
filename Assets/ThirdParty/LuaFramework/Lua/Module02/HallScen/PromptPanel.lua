--local transform;
--local gameObject;

--PromptPanel = {};
--local self = PromptPanel;

----启动事件--
--function PromptPanel.Awake(obj)
--	gameObject = obj;
--	transform = obj.transform;

--	self.InitPanel();
--	log("Awake lua--->>"..gameObject.name);
--end

----初始化面板--
--function PromptPanel.InitPanel()
--	self.btnOpen = transform:Find("Open").gameObject;
--	self.gridParent = transform:Find('ScrollView/Grid');
--end

----单击事件--
--function PromptPanel.OnDestroy()
--	log("OnDestroy---->>>");
--end