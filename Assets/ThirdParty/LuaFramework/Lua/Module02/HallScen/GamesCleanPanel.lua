
GamesCleanPanel={}
local self=GamesCleanPanel

self.m_luaBeHaviour = nil
self.transform=nil


function GamesCleanPanel.Init(_luaBeHaviour)
    if  self.transform==nil then
        self.transform = HallScenPanel.Pool("GamesCleanPanel").transform;
        self.transform:SetParent(HallScenPanel.Compose.transform);
        self.transform.localPosition = Vector3.New(0, 0, 0);
        self.transform.localScale = Vector3.New(1, 1, 1);
    end   
    self.m_luaBeHaviour = _luaBeHaviour

    self.Content=self.transform:Find("mainPanel/ScrollView/Viewport/Content")
    self.Clie=self.transform:Find("mainPanel/Clie")
    self.IconImage=self.transform:Find("mainPanel/Names")
    log("IconImage=="..tostring(self.IconImage.name))
    self.close=self.transform:Find("mainPanel/CloseBtn")
    self.closeMask=self.transform:Find("zhezhao")
    self.m_luaBeHaviour:AddClick(self.close.gameObject, self.CloseBtnClick);
    self.m_luaBeHaviour:AddClick(self.closeMask.gameObject, self.CloseBtnClick);

end

function GamesCleanPanel.Open(_luaBeHaviour)
    if  self.transform==nil then
        self.Init(_luaBeHaviour)
    end
    HallScenPanel.PlayeBtnMusic()

     log("-------------------")
     logTable(SceneNmae)
     log("-------------------")

    for i=1,#SceneNmae do 
        local go=newObject(self.Clie.gameObject)
        go.transform:SetParent(self.Content)
        go.transform.localPosition = Vector3.New(0, 0, 0);
        go.transform.localScale = Vector3.New(1, 1, 1);
        local name=SceneNmae[i]
        go.name=name
        local t=GameManager.PassScenNameToConfiger(name)
        logYellow("name=="..name)
        go.transform:Find("Image/head"):GetComponent("Image").sprite=self.IconImage:Find(name):GetComponent("Image").sprite
        go.transform:Find("name"):GetComponent("Text").text=t.uiName

        local ph = PathHelp.AppHotfixResPath ..name.."/"..name..".unity3d";
        go.transform:Find("Image/address"):GetComponent("Text").text=""..Util.md5file(ph)
        local SCBtn=go.transform:Find("Button")
        SCBtn.name=t.scenName
        self.m_luaBeHaviour:AddClick(SCBtn.gameObject, self.UnLoadBundle);
        go.gameObject:SetActive(true)
    end 
    self.transform.gameObject:SetActive(true)

end

function GamesCleanPanel.UnLoadBundle(args)
    log("卸载资源==="..tostring(args.name))
    if args.name~="module02" then
        Util.Unload(args.name)
        for i=1,#SceneNmae do
            if args.name==SceneNmae[i] then
                table.remove(SceneNmae,i)
            end
        end 
    end
    destroy(self.Content:Find(args.name).gameObject)
end

function GamesCleanPanel.CloseBtnClick()
    HallScenPanel.PlayeBtnMusic()

    for i=1,self.Content.childCount do
        destroy(self.Content:GetChild(i-1).gameObject)
    end 
    destroy(self.transform.gameObject)

    self.m_luaBeHaviour = nil
    self.transform=nil
end