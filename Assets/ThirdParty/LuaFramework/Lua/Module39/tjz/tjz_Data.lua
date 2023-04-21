tjz_Data = {};
local self = tjz_Data;

self.icon_res = nil;
self.numres = nil;
self.soundres = nil;
self.luabe = nil;
self.isResCom = 0;


local isChangeWild=0;

function tjz_Data.distory(args)
    self.allshowitem = {};
    self.curSelectChoum = 1000;
    self.numrollingcont = {};
    self.choumtable = {1000,2000,3000,4000,5000};
    self.myinfoData = {};
    self.isResCom = 0;
    self.selectImg = {1,5,8,1,1,1,4,7,7,7,0,3,6,9,9};--开奖的图片
    self.openline = {{line=3,data={1,1,0,1,1}},{line=8,data={1,1,1,0,0}}};      -- 中线里面的图片 以便连接
    self.allOpenRate = 0;--总倍率
    self.lineWinScore = 0;--连线赢得的总分
    self.byFreeCnt = 0;--免费次数
    self.byAddFreeCnt = 0;--增加的免费次数

    self.isgudi = false;--烈焰模式下面固定图片

    self.IsFirstInGame=false;


    self.isshowmygold = true;
    self.lastshwogold = 0;



    self.isAutoGame = false;--是不是自动游戏

    self.curGameIndex = 0;--当前请求的次数

    self.saveSound = nil;

    self.isFreeing = false;--是不是免费模式中
    self.isruning = false;

    self.lockColIndex = 0;

    self.freeAllGold = 0;

    self.baseRunMoneyTimer = 30;--跑金币公式的时间
    self.autoRunNum = 0;

    self.i64AccuPool = 0;--当前累积奖池
    self.i64AccuGold = 0;--彩金
    self.iCheatLimitChip = 0;--作弊下注限制
    self.byCurUpProcess = 0;--当前升级图标进度
    self.byUpProcess = 0;--下次转动使用图标进度
    self.maxWinType = 0;--大奖类型(0:无, 1:发家致富, 2:腰缠万贯, 3:富甲天下)	
    self.winTypeScore = 0;--大奖金币
    self.bReturn = 0;--是否重转
    self.bHisGoldMoreThan = 0;--历史金币是否超过限制
end

function tjz_Data.countScatter(endindx)
   local re = 0;
   for i=1,endindx do
       for a=1,3 do
           if tjz_Data.selectImg[i+(3-a)*5] == tjz_Config.scatter then
              re = re+1;
           end
       end
   end
   return re;
end

local AllWildWinScore=0;
local IsBigAward={};

--游戏的结算
function tjz_Data.gameOver(buff)
   local ISBigNum=0;
   for i=1,15 do IsBigAward[i]=0;end
   self.selectImg = {};
   self.openline = {};
   self.i64AccuPool =tonumber(buff:ReadInt64Str())--当前累积奖池
   self.i64AccuGold =tonumber(buff:ReadInt64Str())--彩金 
   self.lineWinScore =tonumber(buff:ReadInt64Str())--结算金币
   self.winTypeScore =tonumber(buff:ReadInt64Str())--大奖提示的金币
   self.allOpenRate = buff:ReadInt32();--总倍率
   self.iCheatLimitChip = buff:ReadInt32();--作弊下注限制
   error("当前累积奖池=="..self.i64AccuPool)
   local img = 0xFF;
   local str=""
   for i=1,tjz_CMD.D_ALL_COUNT do --总图标
      img = buff:ReadByte();
      table.insert(self.selectImg,i,img);
      str=str.." "..img
      if i%5==0 then str=str.."\n" end
      if img==10 then
         if i%5==0 then IsBigAward[i]=5 else IsBigAward[i]=i%5 end
      end
   end
   log("服务器返回具体值==".."\n"..str)

   local line = 0xFF;
   local count = 0;
   local fv = 0;
   for a=1,tjz_CMD.D_LINE_COUNT do
      line = a;
      count = 0;
      local linecont = {};
      for b=1,5 do
         fv = buff:ReadByte();
         count = count+fv;
         table.insert(linecont,b,fv);
      end
      if count~=0 then
         table.insert(self.openline,#self.openline+1,{line=line,data=linecont});
      end
   end
   self.byAddFreeCnt = buff:ReadByte();--增加免费次数
   self.byFreeCnt = buff:ReadByte();--免费次数
   tjz_Event.dispathEvent(tjz_Event.xiongm_show_free_btn);
   if self.byFreeCnt>0 then
      self.isFreeing = true;--是不是免费模式中 
   end
   self.byCurUpProcess = buff:ReadByte();--当前升级图标进度
   self.byUpProcess = buff:ReadByte();--下次转动使用图标进度
   self.maxWinType = buff:ReadByte();--大奖类型(0:无, 1:发家致富, 2:腰缠万贯, 3:富甲天下)
   local isretrun = buff:ReadByte();
   self.bReturn = isretrun==1;--是否重转
   self.bHisGoldMoreThan = buff:ReadByte();--历史金币是否超过限制

   if self.byUpProcess>0 then
      self.freeAllGold = self.freeAllGold+self.lineWinScore;
   end
   if isChangeWild ~= self.byUpProcess then
      isChangeWild = self.byUpProcess
      self.byCurUpProcess=self.byUpProcess-1;
   end
   self.isRepalceIcon();
   self.creatOpen();
   self.SetIsBigAward();
   for i=1,15 do
      if ISBigNum<IsBigAward[i] then 
         ISBigNum=IsBigAward[i] 
      end
   end
   error("ISBigNum=="..ISBigNum)
   if ISBigNum>0 then
      AllWildWinScore=AllWildWinScore+self.winTypeScore
      self.winTypeScore=AllWildWinScore;
      self.maxWinType=0;
   else 
      AllWildWinScore=0 
   end
   if ISBigNum==1 then 
   	  AllWildWinScore=0
      self.SetMaxxWinType();
   end
   log("增加免费次数=="..self.byAddFreeCnt)
   log("免费次数=="..self.byFreeCnt)
   log("当前升级图标进度=="..self.byCurUpProcess)
   log("下次转动使用图标进度=="..self.byUpProcess)
   log("大奖类型=="..self.maxWinType)
   log("历史金币是否超过限制=="..self.bHisGoldMoreThan)
   local runnum = 5;
   if self.lockColIndex>0 then 
      runnum = self.lockColIndex;
   end
   if runnum>5 then 
      return;
   end
   for d = 1,runnum do
      tjz_Event.dispathEvent(tjz_Event.xiongm_over,{curindex = d,maxtimer=10,jiantimer=0.4});
   end
end

function  tjz_Data.SetIsBigAward()
   if self.byFreeCnt>0 or self.freeAllGold>0 then
      for i=1,tjz_CMD.D_ALL_COUNT do
         if self.selectImg[i] == tjz_Config.kminewild or self.selectImg[i] == tjz_Config.aqmwild or self.selectImg[i] == tjz_Config.kcarwild then
            if i%5==0 then
               IsBigAward[i]=5
            else
               IsBigAward[i]=i%5
            end
         end
      end
   end
end

--设置大奖信息
function tjz_Data.SetMaxxWinType()
   error("*10=="..self.curSelectChoum*tjz_CMD.D_LINE_COUNT*10)
   error("*20=="..self.curSelectChoum*tjz_CMD.D_LINE_COUNT*20)
   error("*40=="..self.curSelectChoum*tjz_CMD.D_LINE_COUNT*40)
   error("winTypeScore=="..self.winTypeScore)
   if self.winTypeScore < self.curSelectChoum*tjz_CMD.D_LINE_COUNT*10 then
      self.maxWinType=0
   elseif self.winTypeScore >= self.curSelectChoum*tjz_CMD.D_LINE_COUNT*10 and self.winTypeScore < self.curSelectChoum*tjz_CMD.D_LINE_COUNT*20 then
      self.maxWinType=1
   elseif self.winTypeScore >= self.curSelectChoum*tjz_CMD.D_LINE_COUNT*20 and self.winTypeScore <= self.curSelectChoum*tjz_CMD.D_LINE_COUNT*40 then
      self.maxWinType=2
   else
      self.maxWinType=3
   end
end

--
function tjz_Data.creatOpen()
  local num = 0;
  self.lockColIndex = 0;
  local firstvalue = tjz_Config.scatter;
  for a=1,4 do
       for i=1,3 do
           if self.selectImg[a+(3-i)*5] ==firstvalue then
              num = num +1;
           end
       end
       if num>=2 then
          self.lockColIndex = a;
          return;
       end       
  end
  --self.lockColIndex = 2;
end

function tjz_Data.isRepalceIcon()
   if self.byCurUpProcess>=3 then
      local img = nil;
      for i=1,tjz_CMD.D_ALL_COUNT do
         img = self.selectImg[i];
         if img==tjz_Config.kmine and self.byCurUpProcess>=3 then
            self.selectImg[i] = tjz_Config.kminewild;
         elseif img==tjz_Config.aqm and self.byCurUpProcess>=6 then
            self.selectImg[i] = tjz_Config.aqmwild;
         elseif img==tjz_Config.kcar and self.byCurUpProcess>=10 then
            self.selectImg[i] = tjz_Config.kcarwild;
         end
      end
   end
end

local Number=0

function tjz_Data.Number_Zero()
   Number=0
end
--场景消息
function tjz_Data.gameSence(buff)
    AllWildWinScore=0
    Number=Number+1
    self.choumtable = { };
    self.selectImg = {};
    self.i64AccuPool =tonumber(buff:ReadInt64Str());   --当前累积奖池
   error("当前累积奖池=="..self.i64AccuPool)
    local fchoum = 0;
    for i = 1, 5 do
        fchoum = buff:ReadInt32();--下注值
        table.insert(self.choumtable, i, fchoum);
    end
    local n1=buff:ReadInt32();--当前下注
    if Number==1 then
      self.curSelectChoum = n1
    end

    self.iCheatLimitChip = buff:ReadInt32();--作弊下注限制
    self.byFreeCnt = buff:ReadByte();--免费次数
    local img = 0xFF;
    for i=1,tjz_CMD.D_ALL_COUNT do --总图标  15
         img = buff:ReadByte();--具体的值
         if Number==1 then
            table.insert(self.selectImg,i,img);  
         end
    end
    
    self.byCurUpProcess = buff:ReadByte();--当前升级图标进度
    self.byUpProcess = buff:ReadByte();--下次转动使用图标进度
    
    local isretrun = buff:ReadByte();--是否重转 1 是  
   if Number==1 then
      self.bReturn = isretrun==1;--是否重转  
   end
    --self.bReturn = isretrun==1;--是否重转
    
    self.bHisGoldMoreThan = buff:ReadByte();--历史金币是否超过限制

    log("免费次数=="..self.byFreeCnt)
    log("当前升级图标进度=="..self.byCurUpProcess)
    log("下次转动使用图标进度=="..self.byUpProcess)

    self.isRepalceIcon();
    tjz_Event.dispathEvent(tjz_Event.xiongm_init, nil);
    if self.bReturn==true then
       tjz_Event.dispathEvent(tjz_Event.xiongm_show_gudi);
    end
    if tjz_Data.byFreeCnt>0 or self.byCurUpProcess>0 then
       tjz_Socket.playaudio("freebg",true,true);
    else
       tjz_Socket.playaudio("noramlbg",true,true);
   end 
    local freerun = function(args)
        local falg=true;
        while falg do
            coroutine.wait(2);
            if tjz_Data.isResCom ==2 then 
                falg=false;
                logYellow("111111111111")
                self.isInitFreeRun();
            end
        end
    end
    coroutine.start(freerun);
end

function tjz_Data.isInitFreeRun()
   if self.byFreeCnt>0 or self.bReturn==true then
      tjz_Socket.isongame =true;
      tjz_Socket.gameOneOver(false);
      if self.byFreeCnt>0 or self.byUpProcess>0 then
         tjz_BtnPanel.freesp.gameObject:SetActive(true);
         tjz_Event.dispathEvent(tjz_Event.xiongm_show_free_btn);
      end
   end
   logYellow("22222222222222222222")
end


--自己的信息改变
function tjz_Data.myinfoChang()
   self.myinfoData = {};
   self.myinfoData._1dwUser_Id = TableUserInfo._1dwUser_Id;
   self.myinfoData._2szNickName = TableUserInfo._2szNickName;
   self.myinfoData._3bySex = TableUserInfo._3bySex;
   self.myinfoData._4bCustomHeader = TableUserInfo._4bCustomHeader;
   self.myinfoData._5szHeaderExtensionName =TableUserInfo._5szHeaderExtensionName;
   self.myinfoData._6szSign = TableUserInfo._6szSign;
   self.myinfoData._7wGold = TableUserInfo._7wGold;
   self.myinfoData._8wPrize = TableUserInfo._8wPrize;
   self.myinfoData._9wChairID = TableUserInfo._9wChairID;
   self.myinfoData._10wTableID = TableUserInfo._10wTableID;
   self.myinfoData._11byUserStatus = TableUserInfo._11byUserStatus;
   --error("______myinfoChang_______"..self.myinfoData._7wGold);
   --tjz_Event.dispathEvent(tjz_Event.xiongm_gold_chang,nil);
   tjz_Data.isshowmygold = false;
end

