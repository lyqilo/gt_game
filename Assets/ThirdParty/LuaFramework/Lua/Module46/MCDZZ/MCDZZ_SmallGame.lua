-- --[[
--     luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
--     luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
--     author:{author}
--     time:2020-07-14 16:34:45
-- ]]
-- MCDZZ_SmallGame = {};

-- local self = MCDZZ_SmallGame;

-- self.transform=nil
-- self.bg_Hide=nil
-- self.bg_Show=nil
-- self.movePos=nil

-- local CileNum=5

-- local nowWheel=1

-- local grilIndex=0

-- local fatherImage=nil

-- local ClickIndex=0

-- local AllWinScor=0

-- local isEnd=false

-- local isSelfSend=false

-- local fun=nil
-- local winScore=0

-- function MCDZZ_SmallGame:Init(Obj)
--     self.transform=Obj.transform
    
--     self.mainPanel=self.transform:Find("MainPanel")

--     self.Tu=self.mainPanel:Find("Tu")

--     self.bg1_Hide=self.Tu:Find("bg1_Hide") --底图
--     self.bg1_Show=self.bg1_Hide:Find("Show") --显示的图片
--     self.bg1_movePos=self.bg1_Hide:Find("movePos") 

--     self.bg2_Hide=self.Tu:Find("bg2_Hide") --底图
--     self.bg2_Show=self.bg2_Hide:Find("Show") --显示的图片
--     self.bg2_movePos=self.bg2_Hide:Find("movePos") 

--     self.bg_Hide=self.bg1_Hide
--     self.bg_Show=self.bg1_Show
--     self.movePos=self.bg1_movePos


--     self.RightPanel=self.mainPanel:Find("Tu/Right") --右侧点击界面
    
--     self.rightJT=self.mainPanel:Find("Tu/JT") --箭头界面
--     self.rightJT_D=self.rightJT:GetChild(0) --箭头在的位置

--     self.Images=self.transform:Find("MainPanel/Images") --总的分散图片
--     self.N1=self.Images:Find("N1")
--     self.N2=self.Images:Find("N2")

--     self.Cile=self.mainPanel:Find("cile")

--     self.AllWinScore=self.mainPanel:Find("AllWinScore"):GetComponent("Text")
--     self.Resule=self.mainPanel:Find("result")
    
--     self.Resule_Text=self.mainPanel:Find("result/Image/Text"):GetComponent("TextMeshProUGUI")

--     self.smallGameCloseBtn=self.mainPanel:Find("result/CloseBtn"):GetComponent("Button")
--     self.smallGameCloseBtn.onClick:RemoveAllListeners();
--     self.smallGameCloseBtn.onClick:AddListener(self.Close);
--     nowWheel=1
--     MCDZZ_SmallGame.SmallGameClean()
-- end

-- function MCDZZ_SmallGame.Run()
--     isSelfSend=false
--     if MCDZZEntry.SceneData.nBounsNo==0 then
--         MCDZZEntry.SceneData.nBounsNo=math.random(1,2)
--     end
--     MCDZZ_SmallGame.ShowGrilIndex(MCDZZEntry.SceneData.nBounsNo)
--     nowWheel=MCDZZEntry.SceneData.cbBouns
--     if nowWheel==0 then
--         nowWheel=1
--         MCDZZEntry.SceneData.cbBouns=1
--     end
--     MCDZZ_SmallGame.ShowImage(nowWheel)
--     winScore=0
--     if self.RightPanel.childCount<=0 then
--         for i=1,CileNum do
--             local go=newObject(self.Cile.gameObject)
--             go.name=""..i
--             go.transform:SetParent(self.RightPanel)
--             go.transform.localScale=Vector3.New(1,1,1)
--             go:SetActive(true)
--             MCDZZ_SmallGame.ReImage(go)
--             local btn=go.transform:Find("Button"):GetComponent("Button")
--             self.SetOtherImageNotClick(go,true)
--             local eventTrigger = Util.AddComponent("EventTriggerListener", btn.gameObject);
--             eventTrigger.onClick = self.OnClickStartBtn
--         end
--         for i=1,5 do
--             self.movePos:GetChild(i-1):GetComponent("Image").sprite=fatherImage.gameObject.transform:GetChild(nowWheel-1):GetComponent("Image").sprite  
--             self.movePos:GetChild(i-1):GetComponent("Image"):SetNativeSize()
--         end
--     else
--         for i=1,CileNum do
--             local go=self.RightPanel:GetChild(i-1)
--             go:Find("Image").gameObject:SetActive(false)
--             self.SetOtherImageNotClick(self.RightPanel:GetChild(i-1),true)
--             MCDZZ_SmallGame.ReImage(go)
--             self.rightJT_D.localPosition=Vector3.New(self.rightJT_D.localPosition.x,200,self.rightJT_D.localPosition.z)
--         end
--         for i=1,5 do
--             self.movePos:GetChild(i-1):GetComponent("Image").sprite=fatherImage.gameObject.transform:GetChild(nowWheel-1):GetComponent("Image").sprite  
--             self.movePos:GetChild(i-1):GetComponent("Image"):SetNativeSize()
--         end
--     end
--     self.transform.gameObject:SetActive(true)
--     self.rightJT.gameObject:SetActive(true)
--     fun = coroutine.start(self.JTMove)
-- end

-- function MCDZZ_SmallGame.JTMove()
--     while tonumber(self.rightJT_D.localPosition.y)>-200 do
--         coroutine.wait(1.5)
--         if isSelfSend then
--             return
--         end
--         self.rightJT_D.localPosition=Vector3.New(self.rightJT_D.localPosition.x,(self.rightJT_D.localPosition.y-100),self.rightJT_D.localPosition.z)
--     end
--     if isSelfSend then
--         return
--     end
--     ClickIndex=math.random(1,5)
--     MCDZZ_SmallGame.OnClickStartBtn()
-- end

-- function MCDZZ_SmallGame.ShowGrilIndex(index)
--     if index==1 then
--         fatherImage=self.N1
--         self.bg_Hide=self.bg1_Hide
--         self.bg_Show=self.bg1_Show
--         self.movePos=self.bg1_movePos
--     elseif index==2 then
--         fatherImage=self.N2
--         self.bg_Hide=self.bg2_Hide
--         self.bg_Show=self.bg2_Show
--         self.movePos=self.bg2_movePos
--     end

--     for i=1,self.bg_Show.childCount do
--         self.bg_Show:GetChild(i-1):GetComponent("Image").sprite=fatherImage.gameObject.transform:GetChild(i-1):GetComponent("Image").sprite
--     end
-- end

-- function MCDZZ_SmallGame.ReImage(go)
--     go.transform:Find("Image"):GetComponent("Image").sprite=fatherImage.gameObject.transform:GetChild(nowWheel-1):GetComponent("Image").sprite
-- end

-- function MCDZZ_SmallGame.ShowImage(id)
--     self.bg_Hide.gameObject:SetActive(true)
--     if id==1 then
--         self.bg_Show.gameObject:SetActive(false)
--         for i=id,self.bg_Show.childCount do
--             self.bg_Show:GetChild(i-1).gameObject:SetActive(false)
--         end
--     else
--         self.bg_Show.gameObject:SetActive(true)
--         for i=1,id-1 do
--             self.bg_Show:GetChild(i-1).gameObject:SetActive(true)
--         end
--         for i=id,self.bg_Show.childCount do
--             self.bg_Show:GetChild(i-1).gameObject:SetActive(false)
--         end
--     end
-- end

-- --发送小游戏点击
-- function MCDZZ_SmallGame.OnClickStartBtn(args)
--     if args then
--         ClickIndex=tonumber(args.transform.parent.name)
--         isSelfSend=true
--         coroutine.stop(fun)
--     end
--     for i=1,CileNum do
--         self.SetOtherImageNotClick(self.RightPanel:GetChild(i-1),false)
--     end
--     self.rightJT.gameObject:SetActive(false)
--     local buffer = ByteBuffer.New();
--     buffer:WriteByte(MCDZZEntry.SceneData.nBounsNo);
--     Network.Send(MH.MDM_GF_GAME, MCDZZ_Network.SUB_CS_START_BALL_GAME, buffer, gameSocketNumber.GameSocket);
-- end

-- --小游戏返回
-- function MCDZZ_SmallGame.SmallGameBack(gold)
--     winScore=gold
--     AllWinScor=AllWinScor+winScore
--     MCDZZ_SmallGame.SetAllWinScore(AllWinScor)
--     self.RightPanel:GetChild(ClickIndex-1):Find("Image").gameObject:SetActive(true)
--     self.RightPanel:GetChild(ClickIndex-1):Find("Image/TextBG/Text"):GetComponent("Text").text=winScore


--     coroutine.start(self.ImageMove)

-- end

-- function MCDZZ_SmallGame.ImageMove()
--     coroutine.wait(0.1)
--     local oldPos
--     local newPos
--     oldPos=self.movePos:GetChild(ClickIndex-1).transform.localPosition
--     newPos=self.bg_Show:GetChild(nowWheel-1).transform.localPosition
--     self.movePos:GetChild(ClickIndex-1).gameObject:SetActive(true)

--     local tween = self.movePos:GetChild(ClickIndex-1).transform:DOLocalMove(newPos,0.5);
--     self.movePos:GetChild(ClickIndex-1).transform:DOScale(Vector3.New(1, 1, 1), 0.5);

--     tween:OnComplete(function()
--         coroutine.start(function()
--             self.movePos:GetChild(ClickIndex-1).gameObject:SetActive(false)
--             self.bg_Show.gameObject:SetActive(true)
--             self.bg_Show:GetChild(nowWheel-1).gameObject:SetActive(true)
--             self.movePos:GetChild(ClickIndex-1).transform.localPosition=oldPos
--             self.movePos:GetChild(ClickIndex-1).transform.localScale=Vector3.New(0.4,0.34,1)
--             coroutine.wait(1)
--             if winScore==0 or MCDZZEntry.SceneData.cbBouns >=5 then
--                 self.Resule.gameObject:SetActive(true)
--                 coroutine.wait(2.5)
--                 MCDZZ_SmallGame.Close()
--             else
--                 MCDZZEntry.SceneData.cbBouns=MCDZZEntry.SceneData.cbBouns+1
--                 MCDZZ_SmallGame.Run()
--             end
--         end)
--     end);
-- end

-- --设置金币
-- function MCDZZ_SmallGame.SetAllWinScore(num)
--     local str="+"..num
--     self.AllWinScore.text=num
--     self.Resule_Text.text=MCDZZEntry.ShowText(str)
-- end

-- function MCDZZ_SmallGame.SetOtherImageNotClick(go,isOn)
--     go.transform:Find("Button"):GetComponent("Button").interactable=isOn
--     go.transform:Find("Button"):GetComponent("Image").raycastTarget=isOn
--     go.transform:Find("Button"):GetChild(0):GetComponent("Image").raycastTarget=isOn
-- end

-- --小游戏清理
-- function MCDZZ_SmallGame.SmallGameClean()
--     MCDZZEntry.SceneData.cbBouns=0
--     MCDZZEntry.SceneData.nBounsNo=0
--     self.bg_Hide.gameObject:SetActive(false)
--     if fun then
--         coroutine.stop(fun)
--     end
--     self.bg_Show.gameObject:SetActive(false)
--     self.Resule.gameObject:SetActive(false)
--     for i=1,self.bg_Show.childCount do
--         self.bg_Show:GetChild(i-1).gameObject:SetActive(false)
--     end
--     for i=1,self.movePos.childCount do
--         self.movePos:GetChild(i-1).gameObject:SetActive(false)
--     end
--     self.rightJT.gameObject:SetActive(false)
--     self.Images.gameObject:SetActive(false)
--     for i=1,self.RightPanel.childCount do
--         self.RightPanel:GetChild(i-1):Find("Image").gameObject:SetActive(false)
--     end
--     AllWinScor=0
--     MCDZZ_SmallGame.SetAllWinScore(AllWinScor)
--     self.bg_Hide=nil
--     self.bg_Show=nil
--     self.movePos=nil
-- end

-- function MCDZZ_SmallGame.Close()
--     self.transform.gameObject:SetActive(false)
--     MCDZZ_SmallGame.SmallGameClean()
--     MCDZZEntry.ResultData.isSmallGame=0
--     MCDZZEntry.FreeRoll()
-- end