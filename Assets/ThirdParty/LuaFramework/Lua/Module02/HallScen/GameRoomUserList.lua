GameRoomUserList = {}
local self = GameRoomUserList;


self.isinittype = 0;-- 0 表示没初始化 1 代表正在加载资源  2 代表加载完成
self.objparent = nil;
self.gamename = " ";
self.pertransform = nil;
self.useritem = nil;
self.contentsp = nil;
self.useritemTable = {};
self.thispoint = nil;
self.thisshownum = -1;
self.thisWh = nil;
self.isopen = false;
self.isreqdata = false;
self.curpage = -1;
self.gameindex = -1;
self.userdata = {};
self.addpage = 1;
self.luaBehaviour = nil;
self.issetgameid = false;
self.AllUserInfo={};
self.CreatUserObj={};
self.SetHeadImg=false;
self.headid=0;
self.downheadtime=0;
function GameRoomUserList.setdata(sparent,gamename,luabe)
  if self.isopen == true then
     return;
  end
  self.isopen = true;
  self.luaBehaviour = luabe;
  self.objparent = sparent;
  self.gamename = gamename;
  if self.isinittype==0 then
     self.isinittype = 1;
     self.loadres();
     return;
  end
  if self.isinittype==2 then
     
  end
end

function  GameRoomUserList.setgameid(gamename)
    local Scount = table.getn(AllSCGameRoom)
    for i = 1, Scount do
        if(string.find(AllSCGameRoom[i]._9Name, gamename)) ~= nil then
           self.gameindex = AllSCGameRoom[i]._2wGameID; 
           break;
        end
    end
    self.dogameid();
end

function GameRoomUserList.dogameid()
   if self.issetgameid == true then
      return;
   end
   if self.gameindex==-1 or self.pertransform==nil then
      return;
   end
   self.issetgameid = true;
   self.requserdata();
end

function GameRoomUserList.destory()
    self.isinittype = 0;
    -- 0 表示没初始化 1 代表正在加载资源  2 代表加载完成
    self.objparent = nil;
    self.gamename = " ";
    self.pertransform = nil;
    self.useritem = nil;
    self.contentsp = nil;
    self.useritemTable = { };
    self.thispoint = nil;
    self.thisshownum = -1;
    self.thisWh = nil;
    self.isopen = false;
    self.isreqdata = false;
    self.curpage = -1;
    self.gameindex = -1;
    self.userdata = { };
    self.addpage = 1;
    self.luaBehaviour = nil;
    self.issetgameid = false;
    self.AllUserInfo = { };
    self.CreatUserObj={};
    self.SetHeadImg = false;
    self.headid = 0;
    self.downheadtime = 0;
end

function GameRoomUserList.loadres()
  -- LoadAssetCacheAsync("module02/hall_gameroom", "UserScrollView", self.onCreateResCom,true,true);
     self.onCreateResCom(HallScenPanel.Pool("UserScrollView"));
end

function GameRoomUserList.onCreateResCom(args)

  local go = args;
  self.pertransform = go.transform; 
  self.isinittype=2;
  self.useritem = self.pertransform.transform:Find("User").gameObject;  
  self.useritem:SetActive(false);
 -- self.useritem=ResManager:LoadAsset("hall_roomplayer", "GameRoomPlay")
  self.Viewport=self.pertransform.transform:Find("Viewport");
  self.contentsp = self.pertransform.transform:Find("Viewport/Content");
  if self.objparent~=nil then   
     self.pertransform.transform:SetParent(self.objparent.transform);
     self.pertransform.localScale = Vector3.New(1,1,1);
     self.pertransform.localPosition = Vector3.New(0,0,0);
  end
--  self.R_scroolRect_listerner = Util.AddComponent("EventTriggerListener", self.pertransform.gameObject);
--     self.R_scroolRect_listerner.onBeginDrag = self.RoomBeginDrag
--     self.R_scroolRect_listerner.onDrag = self.RoomDrag;
--  self.R_scroolRect_listerner.onEndDrag = self.onendDrag;

    self.startpos=(GameRoomList.FirstBg.transform.position.y)-210
    self.endpos=(HallScenPanel.floor.transform.position.y)+10
  self.doitPoint();
  self.doitShowContWH();
  self.doitShownum();
  self.dogameid();
  go = nil;
end
--处理设置过来的位置
function GameRoomUserList.doitPoint()
   if self.pertransform~=nil and self.thisWh~=nil then
      self.pertransform.localPosition = self.thispoint;
   end
end
--处理设置过来的显示高宽
function GameRoomUserList.doitShowContWH()
   if self.pertransform~=nil and self.thispoint~=nil then
      self.pertransform.transform:GetComponent("RectTransform").sizeDelta = self.thisWh;
      self.contentsp.transform:GetComponent("RectTransform").sizeDelta = self.thisWh;
      self.Viewport.transform:GetComponent("RectTransform").sizeDelta = self.thisWh;
   end
end
--处理设置过来的显示数量
function GameRoomUserList.doitShownum()
  if self.pertransform~=nil and self.thisshownum~=-1 then
     local item = nil;
     local startindex = #self.useritemTable;
     if self.thisshownum >#self.useritemTable then
        for i=1,self.thisshownum-#self.useritemTable do
            item = self.creatUser(startindex+i-1);
        end
     elseif self.thisshownum <#self.useritemTable then  
        for i=1,#self.useritemTable-self.thisshownum do
            self.useritemTable[self.thisshownum+i].gameObject:SetActive(false);
        end 
        
     end
  end
end
--设置位置
function GameRoomUserList.setPoint(sx,sy)
   self.thispoint = Vector3.New(sx,sy,0);
   self.doitPoint();
end
--设置显示的高宽
function GameRoomUserList.setShowContWH(w,h)
   self.thisWh = Vector2.New(w,h);
   self.doitShowContWH();
end
--设置显示的数量
function GameRoomUserList.shownum(num)
   self.thisshownum = num;
   self.doitShownum();
end

local startposy=0;
--开始滑动
function GameRoomUserList.RoomBeginDrag()
--error("开始滑动");
startposy=self.contentsp.transform.localPosition.y;
self.nwh=(self.contentsp.transform:GetComponent("RectTransform").sizeDelta.y-355)/2
end

--滑动中
function GameRoomUserList.RoomDrag()
--error("滑动中");
    if self.isreqdata == false then
        if self.contentsp.transform.localPosition.y > startposy and(self.nwh - self.contentsp.transform.localPosition.y) < 40 then
            self.addpage = 1;
            self.requserdata();
        elseif self.contentsp.transform.localPosition.y < startposy then
            --         self.addpage = 1;
            --       self.requserdata();
        end
    end
end

function GameRoomUserList.onendDrag(args)
--   if self.isreqdata == false then
--      if self.contentsp.transform.localPosition.y>0 then
--         self.addpage = 1;
--         self.requserdata();
--      elseif self.contentsp.transform.localPosition.y<0 then
--         self.addpage = -1;
--         self.requserdata();
--      end    
--   end
end
function GameRoomUserList.requserdata()
    self.isreqdata = true;
    local page = self.curpage+self.addpage;
    if page<0 then
        page = 0;
    end
    local bf = ByteBuffer.New();
    bf:WriteUInt16(self.gameindex);
    if not(gameIsOnline) then      
       bf:WriteUInt32(page*self.thisshownum+16);
    else
       bf:WriteUInt32(page*self.thisshownum);
    end
   
    bf:WriteUInt32(self.thisshownum);
    Network.Send(MH.MDM_3D_ASSIST, MH.SUB_3D_CS_RANKROOM_GOLD_SELECT,bf,gameSocketNumber.HallSocket);
end
--的到服务器的数据
function GameRoomUserList.startGetdata(buf)
     --error("___startGetdata______");    
     gameid = buf:ReadUInt16();
     self.userdata = {};
end
function GameRoomUserList.getDataing(buf)
     --error("___getDataing_______");
     local data = GetS2CInfo(SC_RoomTopGold, buf)
     table.insert(self.userdata,#self.userdata+1,data);
     
end
function GameRoomUserList.endData(buf)
  if self.gameindex~=buf:ReadUInt16() then
     return;
  end
  if self.isopen == true then     
     local size = #self.userdata;
     if size>0 then
        self.curpage = self.curpage+self.addpage;
        if self.curpage<0 then
           self.curpage = 0;
        end
     end  
     if size==0 then
        return;
     end   
     for i=1,size do
        self.setOneUserData(self.useritemTable[i],self.userdata[i],self.curpage*self.thisshownum+i);
     end
  self.isreqdata = false;  

  end
end
function GameRoomUserList.creatUser(index)
    local GetObj = newobject(self.useritem);
    GetObj:SetActive(true);
    GetObj.transform:SetParent(self.contentsp.transform);
    GetObj.transform.localScale = Vector3.New(1, 1, 1);
    GetObj.transform.localPosition = Vector3.New(1, 1, 1);
    local cs = GetObj.transform:Find("Panel").gameObject:AddComponent(typeof(CsJoinLua));
    cs:LoadLua("Module02.HallScen.InCamer", "InCamer");
    GetObj = GetObj.transform:Find("Consle").gameObject;
    self.luaBehaviour:AddClick(GetObj, self.ShowPlayerInfoPanel);
    table.insert(self.useritemTable, #self.useritemTable + 1, GetObj);
    return GetObj;
end

function GameRoomUserList.setOneUserData(obj, data, num)
    local UrlHeadImgF = nil;
    local headstr = nil;

    if num > self.contentsp.transform.childCount then
        GetObj = self.creatUser()
    else
        GetObj = obj;
        obj.gameObject:SetActive(true);
    end

    GetObj.name = data[1];
    headstr = data[6];
    if headstr == enum_Sex.E_SEX_MAN then
        GetObj.transform:Find("Image"):GetComponent('Image').sprite = HallScenPanel.nanSprtie;
    elseif headstr == enum_Sex.E_SEX_WOMAN then
        GetObj.transform:Find("Image"):GetComponent('Image').sprite = HallScenPanel.nvSprtie
    else
        GetObj.transform:Find("Image"):GetComponent('Image').sprite = HallScenPanel.nanSprtie;
    end

    GetObj.transform:Find("Image"):GetComponent('Image').sprite = HallScenPanel.GetHeadIcon();
    GetObj.transform:Find("name"):GetComponent('Text').text = data[3];
    local lennum= math.ceil(num / 4) * 206
    if self.thisWh.y>lennum then lennum=self.thisWh.y end
    self.contentsp.transform:GetComponent("RectTransform").sizeDelta = Vector2.New(750, lennum);
    self.Viewport.transform.localPosition=Vector3.New(0,0,0)
    self.contentsp.transform.localPosition=Vector3.New(0,0,0)    
    self.Viewport.transform:GetComponent("RectTransform").sizeDelta = Vector2.New(750, lennum);
    self.pertransform:GetComponent("RectTransform").sizeDelta = Vector2.New(750, lennum);
    GameRoomList.SetObjPos(lennum)

    if data[7] == 0 then
        UrlHeadImgF = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/0" .. data[6] .. ".png";
    else
        UrlHeadImgF = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/" .. data[1] .. "." .. data[9];
        local headobj=GetObj.transform:Find("Image").gameObject;
        headstr = data[1] .. "." .. data[9];
        table.insert(self.AllUserInfo,UrlHeadImgF)
        table.insert(self.AllUserInfo,headstr)
        table.insert(self.AllUserInfo,headobj)
             if self.SetHeadImg == true then  return end
             self.SetHeadImg = true;
        UpdateFile.downHead(UrlHeadImgF, headstr, self.GetHeadSuccess, headobj);
    end
end

function GameRoomUserList.GetHeadSuccess()
    if self.curpage < 0 then self.SetHeadImg = false return end
    if #self.AllUserInfo> 2 then 
    table.remove(self.AllUserInfo, 1)
    table.remove(self.AllUserInfo, 1)
    table.remove(self.AllUserInfo, 1)
    end
    if #self.AllUserInfo < 3 then self.SetHeadImg = false return end
       self.downheadtime = 0;
    if self.curpage < 0 then self.SetHeadImg = false return end
    UpdateFile.downHead(self.AllUserInfo[1], self.AllUserInfo[2], self.GetHeadSuccess, self.AllUserInfo[3]);
end

function GameRoomUserList.AddDownTime()
    if not self.SetHeadImg then return end
    if self.curpage<0 then self.SetHeadImg = false self.downheadtime = 0; return end
    self.downheadtime = self.downheadtime + 0.02
    if self.downheadtime > 0.3 then self.downheadtime = 0; self.GetHeadSuccess() end
end

--点击排行榜显示玩家详情
function GameRoomUserList.ShowPlayerInfoPanel(obj)
   if HallScenPanel.isCreatIngRoom == true then
      return;
   end
   if gameIsOnline == false then
      return;
   end
   PlayerInfoSystem.SelectUserInfo(obj.name, nil, obj.transform:Find("Image").gameObject);
end

function GameRoomUserList.GoldToText(obj, num)
   logError(" GameRoomUserList.GoldToText");
    local numstr = " ";
    local endstr = " ";
    local neednum=tonumber(num);
    obj.transform:GetComponent('Text').text = " ";
    if  neednum < 10000 then
        obj.transform:GetComponent('Text').text = neednum;
        return;
    elseif neednum < 100000000 then
        numstr = tostring( neednum / 10000);
        endstr = "万";
    else
        numstr = tostring(neednum / 100000000);
        endstr = "亿";
    end
    if #numstr > 4 then numstr = string.sub(numstr, 1, 4); end
    if ("." == string.sub(numstr, 4, 4)) then numstr = string.sub(numstr, 1,(#numstr) -1); end
    obj:GetComponent('Text').text = numstr .. endstr;
end

function GameRoomUserList.Update()
end

function GameRoomUserList.SetUserPos()
if #self.CreatUserObj==10 then return end
    for i = 1, #self.CreatUserObj do
        local a = self.CreatUserObj[i].transform.position.y
        if a < self.startpos then
            self.CreatUserObj[i]:SetActive(false);
        end
        self.CreatUserObj[i]:SetActive(true);
        if a > self.endpos then
            self.CreatUserObj[i]:SetActive(false);
        end
    end
end