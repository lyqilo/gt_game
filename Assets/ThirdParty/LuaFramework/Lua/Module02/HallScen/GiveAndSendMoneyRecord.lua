--收红包和送红包的list

GiveAndSendMoneyRecord = {};
local self = GiveAndSendMoneyRecord;

self.parentObj = nil;
self.curobj = nil;
self.lub = nil;
self.loadtype = 0;
self.recordItem = nil;
self.itemTable = nil;
self.conent = nil;
self.recodname = 50;
self.dragvalue =999999999;

self.sx = 363.7;
self.sy = -14;
self.sh = 37;
self.sizef = 14;
self.isnoenddrag = false;--是不是能无线拖
self.curshowpage = 0;
self.isreqdata = false;
self.isReqDataList=false;
self.starPoint=0;


function GiveAndSendMoneyRecord:new()
	local go = {};
	setmetatable(go,{__index=self});
	return go;
end

function GiveAndSendMoneyRecord:setPer(per,itemper,bagtype)
	--self:dest();
	self.curobj = per;
	self.recordItem = itemper;
	self.loadtype = bagtype;
	self:findCompent();
end



function GiveAndSendMoneyRecord:reqData()
	if self.isreqdata==true then
		return;
	end
	self.isreqdata = true;
	local buffer = ByteBuffer.New();
	buffer:WriteInt(self.starPoint);
	buffer:WriteInt(49);
	buffer:WriteInt(self.loadtype);
	Network.Send(MH.MDM_3D_GOLDMINET, MH.SUB_2D_CS_GIVE_RECORD_LIST, buffer,gameSocketNumber.HallSocket);
	self.starPoint = self.starPoint + 49;
end

function GiveAndSendMoneyRecord:startRecord()
	self.recodeTable = {};
	log("============================开始接收列表====================================="..self.loadtype)
end

function GiveAndSendMoneyRecord:record(t)
	local item = {};
	item["id"]=t[1];
	item["sid"]=t[2];
	item["rid"]=t[3];
	item["type"]=t[4];
	item["num"]=t[5];
	item["time"]=t[6];
	item["isgive"]=t[7];
	item["sNick"]=t[8];
	item["rNick"]=t[9];
	table.insert(self.recodeTable,item);
end

function GiveAndSendMoneyRecord:endRecord()
	log("=============================================接收完成==========================================================="..self.loadtype)
	logTable(self.recodeTable)
	if #self.recodeTable == 0 then
		return;
	end
	table.sort(self.recodeTable,function(a,b)return a["time"] > b["time"] end )
	self:creatitem(#self.recodeTable);
	local length = #self.recodeTable;
	log("==============================================创建列表==================================================="..length)
	self.curshowpage = self.curshowpage+#self.recodeTable;
	self.isreqdata = false;
end

function GiveAndSendMoneyRecord:getGoldRes(buff,wSize)
	local item = {};
	item["keid"] = tostring(buff:ReadInt64Str());--服务器数据库存储的唯一id
	item["state"] = buff:ReadByte();--当前状态 0未领取 1已领取 2退回
	item["ishow"] = buff:ReadByte();--是不是还有要领取
	local data = self.itemTableDic[tostring(item["keid"])];
	if data~=nil then
		data.item:doState(item["state"]);
	else
		self:statechang(item);
	end
	RedBagPanel.setState(item["ishow"]);
end

--这个是上面的dic出错了 才会用到它
function GiveAndSendMoneyRecord:statechang(args)
	table.foreachi(self.itemTable, function (i,v)
		v:doState(args["state"]);
	end)
end

function GiveAndSendMoneyRecord:dest()
	self.parentObj = nil;
	self.curobj = nil;
	self.lub = nil;
	self.loadtype = 0;
	self.colsebtn = nil;
	self.recordItem = nil;
	self.itemTable = nil;
	self.itemTableDic = nil;
	self.conent = nil;
	self.colsebtn = nil;
	self.recodname = 50;
	self.dragvalue =999999999;
	self.sx =361;
	self.sy = -112;
	self.sh = 37;
	self.sizef = 14;
	self.isnoenddrag = false;
	self.curshowpage = 0;
	self.isreqdata = false;
	self.isReqDataList=false;
	log("关闭界面");
end

function GiveAndSendMoneyRecord:findCompent()
	
	self.sx = 361;
	self.sy = -112;
	self.sh = 60;
	self.sizef = 25;
	self.isnoenddrag = true;
	self.recodname = 10;
	self.conent = self.curobj.transform:Find("Viewport/Content");
	local hander = function (args,fun)
		return function (...)
			fun(args,...);
		end
	end
	if self.isnoenddrag==true then
		self.R_scroolRect_listerner = Util.AddComponent("EventTriggerListener", self.curobj.gameObject);
		self.R_scroolRect_listerner.onEndDrag = hander(self,self.onendDrag);
	end
	self.lub = HallScenPanel.LuaBehaviour;
	self.recordItem.gameObject:SetActive(false);
	self.itemTable ={};
	self.itemTableDic = {};
	if self.isReqDataList==false then
		self:reqData();
		self.isReqDataList=true;
		log("获取记录列表");
	end
	
	
	
end

function GiveAndSendMoneyRecord:onendDrag(go,args)
	
	if self.conent.transform.localPosition.y > self.dragvalue then
		self:reqData();
		log("滑动后获取");
	end
end

function GiveAndSendMoneyRecord:creatitem(len)
	self.recordItem.gameObject:SetActive(true);
	for i = 1,len do
		self.itemTable[i] = GiveAndSendMoneyRecordItem:new();
		self.itemTable[i]:setluabe(self.lub);
		self.itemTable[i]:setBg(self.recordItem);
		self.itemTable[i]:setPoint(self.conent,Vector3.New(self.sx,self.sy-(i-1)*self.sh),self.loadtype);
		self.itemTable[i].transform.name = self.recordItem.name..i;
		self.itemTable[i]:setData(self.recodeTable[i]);
		self.itemTableDic[tostring(self.recodeTable[i]["id"])] = {item=self.itemTable[i],data = self.recodeTable[i]};
	end
	local contsize = self.conent.transform:GetComponent("RectTransform").sizeDelta;
	self.conent.transform:GetComponent("RectTransform").sizeDelta = Vector2.New(contsize.x,#self.itemTable*self.sh);
	self.dragvalue = self.conent.transform:GetComponent("RectTransform").sizeDelta.y - #self.itemTable*self.sh;
	self.conent.transform:GetComponent("RectTransform").localPosition = Vector3.New(0,0,0);
	self.recordItem.gameObject:SetActive(false);
end