flm_Data = {};
local self = flm_Data;

self.icon_res = nil;
self.numres = nil;
self.soundres = nil;
self.luabe = nil;
self.isResCom = 0;
self.InitOver=false;
function flm_Data.distory(args)
    self.allshowitem = {};
    self.curSelectChoum = 1000;
    self.numrollingcont = {};
    self.choumtable = {1000,2000,3000,4000,5000};
    self.myinfoData = {};
    self.isResCom = 0;
    self.selectImg = {};--开奖的图片
    self.openline = {};      -- 中线里面的图片 以便连接
    self.openImgGold ={};--开奖的时候 如果是金币图标上面要显示数字和文字
    self.fuType = {};--福类型  大幅 幅满 小幅
    self.fuTimes = {};--大福小福的倍数
    self.allOpenRate = 0;--总倍率
    self.lineWinScore = 0;--连线赢得的总分
    self.byFreeCnt = 0;--免费次数
    self.byAddFreeCnt = 0;--增加的免费次数

    self.bGoldMode = false;--金币模式
    self.bGoldingMode = false;--金币模式中
    self.isgudi = false;--金币模式下面固定图片
    self.byGoldModeNum = 0;--金币模式的次数

    self.isshowmygold = true;
    self.lastshwogold = 0;

    self.openedSmallTable = {};--登录的时候 传入开过哪些小游戏


    self.isAutoGame = false;--是不是自动游戏

    self.curGameIndex = 0;--当前请求的次数

    self.saveSound = nil;

    self.isShowLieHuoBg = false;
    self.isFreeing = false;--是不是免费模式中
    self.isruning = false;

    self.lockColIndex = 0;

    self.freeAllGold = 0;

    self.baseRunMoneyTimer = 30*4;--跑金币公式的时间

    self.allfuvalue = 0;--满福的钱
    self.autoRunNum = 0;
end

--更新福满的值
function flm_Data.updateAllFuValue(buff)
   self.allfuvalue = buff:ReadUInt32();
   flm_Event.dispathEvent(flm_Event.xiongm_update_allfu_value);
end

--游戏的结算
function flm_Data.gameOver(buff,issence)
     self.selectImg = {};
     self.openline = {};
     self.fuType = {};
     self.openImgGold={};
     local img = 0xFF;
     self.istssound = false;
     for i=1,flm_CMD.D_ALL_COUNT do
         img = buff:ReadByte();
         table.insert(self.selectImg,i,img);
         if self.istssound==false and img==flm_Config.bianpao and 0<(i%5) and (i%5)<4 then
            self.istssound = true;
         end
     end
     logYellow("本次的图标")
     logTable(self.selectImg);
     --error("----333-----gameOver---------");
     local goldnum = 0;
     for e=1,flm_CMD.D_ALL_COUNT do
         goldnum = buff:ReadUInt32();
         table.insert(self.openImgGold,e,goldnum);
     end
     logTable(self.openImgGold);
    -- error("----444-----gameOver---------");
     local line = 0xFF;
     local count = 0;
     local fv = 0;
     for a=1,flm_CMD.D_LINE_COUNT do
         line = a;
         count = 0;
         local linecont = {};
        for b=1,5 do
            fv = buff:ReadByte();
            count = count+fv;
            if fv>0 then
               fv = 1;
            end
            table.insert(linecont,b,fv);
        end
         if count~=0 then
            table.insert(self.openline,#self.openline+1,{line=line,data=linecont});
         end
     end
     logTable(self.openline)

     for c = 1,3 do   
     	local x = buff:ReadUInt32();      
        table.insert(self.fuType,#self.fuType+1,x);
     end
    
    self.lineWinScore = tonumber( buff:ReadInt64Str())
    local freenum = buff:ReadByte();
    local GoldModeNum = buff:ReadByte();
    logYellow("freenum："..freenum.."  GoldModeNum:"..GoldModeNum);
    self.allOpenRate = tonumber( buff:ReadInt64Str())
    log("中将倍数：".. self.allOpenRate );
    self.creatOpen();
    self.isshowmygold = false;
    self.bGoldMode = false;
    self.byAddFreeCnt = 0;
    if freenum>self.byFreeCnt  and issence~=true then
       self.byAddFreeCnt = freenum - self.byFreeCnt;
       self.isFreeing = true;
    end
    if self.byGoldModeNum==0 and GoldModeNum>0 and issence~=true then
       self.bGoldMode = true;
       self.bGoldingMode = true;
    end
    if GoldModeNum>0 then
       self.isgudi = true;
    else
       self.isgudi = false;
    end
    self.byFreeCnt = freenum;
   
    self.byGoldModeNum = GoldModeNum;
    log("免费次数："..self.byGoldModeNum);
    if issence == true then
       return;
    end
    if self.byFreeCnt>0 or self.freeAllGold>0 then
        self.freeAllGold = self.freeAllGold+self.lineWinScore;        
    end
    flm_Event.dispathEvent(flm_Event.xiongm_start); 
    flm_Event.dispathEvent(flm_Event.xiongm_start_btn_no_inter,false);
    local runnum = 5;
    if self.lockColIndex>0 then
      runnum = self.lockColIndex;
    end
     
    if runnum>5 then
       return; 
    end
    for d = 1,runnum do
        flm_Event.dispathEvent(flm_Event.xiongm_over,{curindex = d,maxtimer=8,jiantimer=0.2});
    end
end

-- 
function flm_Data.creatOpen()
  local num = 0;
  self.lockColIndex = 0;
  local firstvalue = flm_Config.bianpao;
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
end

local InitCount=0

function flm_Data.InitCount_Zero()
    InitCount=0
end

function flm_Data.gameSence(buff)
error("===========================================场景消息==================================================");
    
    InitCount=InitCount+1

    self.choumtable = {}; 
    self.fuTimes = {};
    local _choum=buff:ReadInt32();
    if InitCount==1 then
        self.curSelectChoum = _choum
    end

    local fchoum = 0;
    for i=1,5 do
       fchoum = buff:ReadUInt32();
       table.insert(self.choumtable,i,fchoum);
    end
     for a=1,2 do
       table.insert(self.fuTimes,a,buff:ReadUInt32());
    end
    logYellow("选择下注=="..self.curSelectChoum)
    self.gameOver(buff,true);
    if self.byGoldModeNum>0 then
        self.bGoldingMode = true;
    end
    if self.byFreeCnt>0 then
        self.isFreeing = true;
    end
    flm_Event.dispathEvent(flm_Event.xiongm_init,nil);
    log("==========================================call_init");
    local freerun = function(args)
        local falg=true;
        while falg do
            coroutine.wait(0.5);
            if flm_Data.isResCom ==2 then 
                falg=false;
                logYellow("isInitFreeRun")
                self.isInitFreeRun();
            end
        end
    end
    
    coroutine.start(freerun);   
        
    if flm_Data.isgudi==true then        
        flm_Event.dispathEvent(flm_Event.xiongm_show_gudi);         
    end
    self.InitOver=true;
end

function flm_Data.isInitFreeRun()
   -- error("isInitFreeRun2");
   if self.byFreeCnt>0 or self.byGoldModeNum >0 then
       flm_Socket.isongame =true;
       flm_Socket.gameOneOver(false);
       if self.byFreeCnt>0 then
          flm_Socket.playaudio("freebg",true,true);
       else
          flm_Socket.playaudio("coinbg",true,true);
       end      
   else
       flm_Socket.playaudio("normalbg",true,true);
    end
end


function flm_Data.myinfoChang()
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
    flm_Event.dispathEvent(flm_Event.xiongm_gold_chang,nil);
end

