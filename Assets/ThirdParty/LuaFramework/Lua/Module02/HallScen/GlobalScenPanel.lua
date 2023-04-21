----require "Common/define"

--GlobalScenPanel = { };
--local self = GlobalScenPanel;
--local transform;
--local gameObject;

--function GlobalScenPanel.New()
--return self;
--end

--function GlobalScenPanel.Create()

--end

--function GlobalScenPanel.CreateCallBack(obj)

--end

--function GlobalScenPanel.Awake(obj)
--    transform=obj.transform;
--    gameObject=obj;
--    log("GlobalScenPanel.awake");
--    if GameNextScenName==gameScenName.LOGON then GameNextScen.Create(); 
--    else LoadingScenPanel.Create(); end
--	--ResManager:LoadAsset('logonscen', 'LogonScenPanel', self.InitPanel);
--end

----初始化面板--
--function GlobalScenPanel.InitPanel(prefab)
--    local go=newobject(prefab);
--    go.transform:SetParent(transform);
--    go.name="LogonScenPanel";  		
--    go.transform.localScale = Vector3.one;
--    go.transform.localPosition = Vector3.New(0,0,0);
--    LogonScenPanel.Awake(go);
--end
