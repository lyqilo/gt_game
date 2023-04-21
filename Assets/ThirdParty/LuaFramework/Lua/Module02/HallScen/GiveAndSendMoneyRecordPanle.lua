GiveAndSendMoneyRecordPanle = {};
local self = GiveAndSendMoneyRecordPanle;
self.parentObj = nil;
self.curobj = nil;
self.lub = nil;
self.colsebtn = nil;

self.sendRecordCont = nil;
self.getRecordCont = nil;
self.sendrecordItem = nil;
self.giverecordItem = nil;
self.sendScorll = nil;
self.giveScorll = nil;
self.from=nil;
self.RecvieType = 0;
function GiveAndSendMoneyRecordPanle.showPanel(parentObj,from)
	if self.curobj~=nil then
		return;
	end
	self.parentObj = parentObj;
	self.lub = HallScenPanel.LuaBehaviour;
	--ResManager:LoadAsset("module02/hall_giveandsend", "giveandsendmoneyrecord", self.OnCreactergiveandsendmoneyrecord);
	self.OnCreactergiveandsendmoneyrecord(HallScenPanel.Pool("giveandsendmoneyrecord"));
	
end


function  GiveAndSendMoneyRecordPanle.closeHander()
	destroy(self.curobj);
	self.dest();
end

function GiveAndSendMoneyRecordPanle.OnCreactergiveandsendmoneyrecord(go)
	go.transform:SetParent(self.parentObj);
	go.name = "GiveAndSendMoneyRecord";
	go.transform.localScale = Vector3.one;
	go.transform.localPosition = Vector3.New(0, 0, 0);
	self.curobj = go;
	
	local IMGResolution=self.curobj:GetComponent("IMGResolution");
		if IMGResolution==nil then
			Util.AddComponent("IMGResolution",self.curobj.gameObject);
		end 	
	self.findCompent();
end
function GiveAndSendMoneyRecordPanle.dest()
	self.parentObj = nil;
	self.curobj = nil;
	self.lub = nil;
	self.colsebtn = nil;
	self.sendRecordCont = nil;
	self.getRecordCont = nil;
	self.sendrecordItem = nil;
	self.giverecordItem = nil;
	self.from=nil;
end


function GiveAndSendMoneyRecordPanle.findCompent()
	self.sendrecordItem = self.curobj.transform:Find("recorditem");
	self.giverecordItem = self.curobj.transform:Find("recorditemTwo");
	self.titlehandId1 = self.curobj.transform:Find("titlehand/id1")
	self.titlehandId2 = self.curobj.transform:Find("titlehand/id2")
	self.titlehandId2.gameObject:SetActive(false)


	self.lub:AddClick(self.curobj.transform:Find("Btn/GiveBtn").gameObject,self.sendBtn);
	self.lub:AddClick(self.curobj.transform:Find("Btn/GetBtn").gameObject,self.giveBtn);
	self.lub:AddClick(self.curobj.transform:Find("CloseBtn").gameObject,self.closeHander);
	self.giveScorll = self.curobj.transform:Find("ScrollViewsend");
	self.sendScorll = self.curobj.transform:Find("ScrollViewsendgive");
	
	self.sendRecordCont = GiveAndSendMoneyRecord:new();
	self.getRecordCont = GiveAndSendMoneyRecord:new();
	self.sendRecordCont:setPer(self.sendScorll,self.sendrecordItem,0);
	self.getRecordCont:setPer(self.giveScorll,self.giverecordItem,1);
	self.setGiveShow(false);
	if from==nil then self.sendBtn(); end;
end

function GiveAndSendMoneyRecordPanle.sendBtn(args)
	self.setGiveShow(false);
	self.titlehandId1.gameObject:SetActive(true)
	self.titlehandId2.gameObject:SetActive(false)


	self.curobj.transform:Find("Btn/GiveBtn/bg").gameObject:SetActive(true)
	self.curobj.transform:Find("Btn/GiveBtn/Image1").gameObject:SetActive(false)
	self.curobj.transform:Find("Btn/GetBtn/bg").gameObject:SetActive(false)
	self.curobj.transform:Find("Btn/GetBtn/Image1").gameObject:SetActive(true)


end

function GiveAndSendMoneyRecordPanle.giveBtn(args)
	self.setGiveShow(true);
	self.titlehandId1.gameObject:SetActive(false)
	self.titlehandId2.gameObject:SetActive(true)
	--self.titlehandId.text="赠送ID"
	self.curobj.transform:Find("Btn/GiveBtn/bg").gameObject:SetActive(false)
	self.curobj.transform:Find("Btn/GiveBtn/Image1").gameObject:SetActive(true)
	self.curobj.transform:Find("Btn/GetBtn/bg").gameObject:SetActive(true)
	self.curobj.transform:Find("Btn/GetBtn/Image1").gameObject:SetActive(false)

end

function GiveAndSendMoneyRecordPanle.setGiveShow(args)
	self.sendScorll.gameObject:SetActive(not args);
	self.giveScorll.gameObject:SetActive(args);
	self.curobj.transform:Find("Btn/GiveBtn").gameObject:GetComponent("Button").interactable = args;
	self.curobj.transform:Find("Btn/GetBtn").gameObject:GetComponent("Button").interactable = not args;
end

function GiveAndSendMoneyRecordPanle.startRecord(args)
	if args == 1 then
		self.getRecordCont:startRecord();
	else
		self.sendRecordCont:startRecord();
	end
end
function GiveAndSendMoneyRecordPanle.endRecord(args)
	if args == 1 then
		self.getRecordCont:endRecord();
	else
		self.sendRecordCont:endRecord();
	end
end
function GiveAndSendMoneyRecordPanle.record(t,type)
	if type == 0 then
		self.getRecordCont:record(t);
	else
		self.sendRecordCont:record(t);
	end
end
function GiveAndSendMoneyRecordPanle.getGoldRes(buff,wSize)
	self.getRecordCont:getGoldRes(buff,wSize);
end